class PuzzlesController < ApplicationController
  def show
    session[:board] ||= generate_board # Инициализация игрового поля, если его нет в сессии
    session[:moves] ||= 0 # Инициализация счётчика ходов
    session[:start_time] ||= Time.now.to_i # Запоминаем время начала игры

    @board = session[:board]
    @moves = session[:moves]
    @elapsed_time = Time.now.to_i - session[:start_time] # Рассчитываем прошедшее время
    @won = won?(@board) # Проверка на победу
  end

  def move
    board = session[:board]
    tile = params[:tile].to_i # Получаем нажатую плитку
    empty_index = board.flatten.index(nil) # Находим пустую ячейку
    tile_index = board.flatten.index(tile) # Находим индекс нажатой плитки

    if valid_move?(tile_index, empty_index)
      # Меняем местами плитку и пустую ячейку
      board[empty_index / 4][empty_index % 4], board[tile_index / 4][tile_index % 4] =
        board[tile_index / 4][tile_index % 4], board[empty_index / 4][empty_index % 4]

      session[:board] = board
      session[:moves] += 1 # Увеличиваем количество ходов
    end

    if won?(board)
      flash[:notice] = "Поздравляем! Головоломка решена за #{session[:moves]} ходов и #{Time.now.to_i - session[:start_time]} секунд!"
    end

    redirect_to root_path
  end

  def restart
    session[:board] = generate_board # Пересоздаём поле
    session[:moves] = 0 # Сбрасываем счётчик ходов
    session[:start_time] = Time.now.to_i # Обновляем время начала игры
    redirect_to root_path
  end

  private

  def generate_board
    numbers = (1..15).to_a.shuffle + [nil] # Перемешиваем числа и добавляем пустую ячейку
    numbers.each_slice(4).to_a # Преобразуем в 4x4 массив
  end

  def valid_move?(tile_index, empty_index)
    row, col = tile_index / 4, tile_index % 4
    empty_row, empty_col = empty_index / 4, empty_index % 4
    (row == empty_row && (col - empty_col).abs == 1) || (col == empty_col && (row - empty_row).abs == 1) # Проверяем, можно ли передвинуть плитку
  end

  def won?(board)
    goal = (1..15).to_a + [nil] # Целевая последовательность
    board.flatten == goal # Прове
    end
  end
      #     goal = (1..15).to_a + [nil]
      #     board.flatten == goal
      #   end
      # end

# class PuzzlesController < ApplicationController
#   def show
#     session[:board] ||= generate_board
#     @board = session[:board]
#     @won = won?(@board) # Проверка на победу
#   end

#   def move
#     board = session[:board]
#     tile = params[:tile].to_i
#     empty_index = board.flatten.index(nil)
#     tile_index = board.flatten.index(tile)

#     if valid_move?(tile_index, empty_index)
#       board[empty_index / 4][empty_index % 4], board[tile_index / 4][tile_index % 4] =
#         board[tile_index / 4][tile_index % 4], board[empty_index / 4][empty_index % 4]

#       session[:board] = board
#     end

#     if won?(board)
#       flash[:notice] = "Поздравляем!Головоломка решена!"
#     end

#     redirect_to root_path
#   end
#   def restart
#     session[:board] = generate_board # Пересоздаём поле
#     redirect_to root_path
#   end
#   private

#   def generate_board
#     numbers = (1..15).to_a.shuffle + [nil]
#     numbers.each_slice(4).to_a
#   end

#   def valid_move?(tile_index, empty_index)
#     row, col = tile_index / 4, tile_index % 4
#     empty_row, empty_col = empty_index / 4, empty_index % 4
#     (row == empty_row && (col - empty_col).abs == 1) || (col == empty_col && (row - empty_row).abs == 1)
#   end

#   def won?(board)
#     goal = (1..15).to_a + [nil]
#     board.flatten == goal
#   end
# end
