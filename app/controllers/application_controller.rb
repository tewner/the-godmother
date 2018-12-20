class ApplicationController < ActionController::Base
  force_ssl if: Proc.new { Rails.env.production? }

	private

	def current_person
		@current_person ||= Person.find(session[:person_id]) if session[:person_id]
	end
	helper_method :current_person

	def godmother?
	  if current_person && current_person.role_name == :godmother
      true
    else
      false
    end
  end
  helper_method :godmother?

  def registration_open
    unless Rails.configuration.x.basic.registration_open || godmother?
      redirect_to home_path, alert: "Sorry, registration is closed."
    end
  end

  def require_godmother
    unless godmother?
      flash[:alert] = "You must be logged in."
      session[:last] = request.original_url
      redirect_to controller: 'sessions', action: 'new'
    end
  end
end
