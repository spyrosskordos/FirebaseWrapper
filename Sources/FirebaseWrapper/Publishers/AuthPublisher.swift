//
//  File.swift
//
//
//  Created by Sko on 16/7/22.
//

import Combine
import FirebaseAuth

public extension Publishers {
    struct AuthPublisher: Publisher {
        public init(){ }
        public typealias Output = User?

        public typealias Failure = Never

        public func receive<S>(subscriber: S)
        where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let authSubscription = AuthSubscription(subscriber: subscriber)
            subscriber.receive(subscription: authSubscription)
        }

        public class AuthSubscription<S: Subscriber>: Subscription
        where S.Input == User?, S.Failure == Never {

            private var subscriber: S?
            private var handler: AuthStateDidChangeListenerHandle?

            public init(subscriber: S) {
                self.subscriber = subscriber
                handler = Auth.auth().addStateDidChangeListener { auth, user in
                    _ = subscriber.receive(user)
                }
            }
            public func request(_ demand: Subscribers.Demand) {

            }

            public func cancel() {
                subscriber = nil
                handler = nil
            }

        }
    }
}


