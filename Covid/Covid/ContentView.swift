//
//  ContentView.swift
//  Covid
//
//  Created by NAVEEN MADHAN on 8/10/20.
//  Copyright © 2020 Navemics. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeView()
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HomeView: View{
    
    @ObservedObject var data = getData()
    
    
    var body: some View {
        
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 15) {
                    
                    Text("21 August, 2020")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("Covid - 19 Cases")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("123,132")
                        .fontWeight(.semibold)
                        .font(.title)
                        .foregroundColor(.white)
                    
                }
                Spacer()
                Button(action :{
                    
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 18)
            .padding()
            .padding(.bottom, 80)
            .background(Color.red)
            
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 15)  {
                    Text("Deaths")
                        .foregroundColor(Color.black.opacity(0.5))
                    Text("5346")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
                    .padding(30)
                    .background(Color.white)
                    .cornerRadius(15)
                
                VStack(alignment: .leading, spacing: 15)  {
                    Text("Recovered")
                        .foregroundColor(Color.black.opacity(0.5))
                    Text("5346")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }.padding(.horizontal, 20)
                    .padding(.vertical, 30)
                    .background(Color.white)
                    .cornerRadius(15)
                
                
            }
            .offset(y: -60)
            .padding(.bottom, -60)
            .zIndex(25)
            
            VStack(alignment: .center, spacing: 15)  {
                Text("Active Cases")
                    .foregroundColor(Color.black.opacity(0.5))
                Text("5346")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
            }.padding(.horizontal, 20)
                .padding(.vertical, 30)
                .background(Color.white)
                .cornerRadius(15)
                .padding(.top, 15)
            
            
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(1...15, id: \.self) { i in
                        cellView()
                    }
                }.padding()
            }
            
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color.black.opacity(0.1).edgesIgnoringSafeArea(.all))
    }
}


func getdate(time: Double) -> String {
    let date = Double(time/1000)
    let format = DateFormatter()
    format.dateFormat = "MMM - dd - YYYY hh:mm a"
    return format.string(from: Date(timeIntervalSinceNow: TimeInterval(exactly: date)!))
}

func getValue(date: Double) {
    let format = NumberFormatter()
    format.numberStyle = .decimal
}

struct cellView: View{
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("USA")
                .fontWeight(.bold)
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Active Cases")
                        
                        .font(.title)
                    Text("123,234")
                        .fontWeight(.bold)
                        .font(.title)
                }
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Deaths")
                        Text("225").foregroundColor(.red)
                    }
                    Divider()
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recovered")
                        Text("225").foregroundColor(.green)
                    }
                    Divider()
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Active")
                        Text("225").foregroundColor(.yellow)
                    }
                }
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
            
            
        .cornerRadius(20)
    }
}


struct Case: Decodable {
    
    var country: String
    var confirmed: Double
    var recovered: Double
    var critical: Double
    var deaths: Double
    var lastUpdate: String
}
  

class geteData: ObservableObject {
    @Published var data: Case!
    
    init() {
        
    }
    //8dcb66424cmsh6917bca0a8c1b99p1ad9ffjsn978cf621421d
    
    func updateData() {
        let url = "https://covid-19-data.p.rapidapi.com/report/country/name?date-format=YYYY-MM-DD&format=json&date=2020-08-10&name=India"
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, response, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
            }
            
            let json = try! JSONDecoder().decode(Case.self, from: data!)
            DispatchQueue.main.async {
                self.data = json
                print("0k")
            }
            
            }.resume()
    
    }
}


class getData: ObservableObject {
    
    @Published var data: Case!
    
    init() {
        
    }
    
    func updateData(){
        let headers = [
            "x-rapidapi-host": "covid-19-data.p.rapidapi.com",
            "x-rapidapi-key": "1b593b093emshbf4ee12bc1e15e8p1d9a00jsn4c94ef2b8255"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://covid-19-data.p.rapidapi.com/country?format=json&name=India")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared

        session.dataTask(with: request as URLRequest) { (data, response, err) in
        if err != nil {
            print((err?.localizedDescription)!)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print(httpResponse.statusCode)
        }
        
        let json = try! JSONDecoder().decode(Case.self, from: data!)
        DispatchQueue.main.async {
            self.data = json
            print("ok")
        }
        
        }.resume()
    }
}
