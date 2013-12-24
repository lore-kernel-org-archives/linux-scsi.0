From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: spinlock_irqsave() && flags (Was: pm80xx: Spinlock fix)
Date: Tue, 24 Dec 2013 09:29:31 -0800
Message-ID: <1387906171.2343.7.camel@dabdike.int.hansenpartnership.com>
References: <52B83B89.9040700@gmail.com>
	 <CE2C58F938F4C44EA74FFF880BAA7E5E1C68AA8A@BBYEXM01.pmc-sierra.internal>
	 <CAD0Z9T+69VoSnDY-Sj7a1QfJ-KLJYVyL9=WQ123XMfRvQmGdsg@mail.gmail.com>
	 <52B8518B.4060204@gmail.com> <52B8569D.4050101@redhat.com>
	 <CAD0Z9TK-cn=X3ywSzPnEQN-FB+ue+0dHQ3EHuwonC+KfgrmPMA@mail.gmail.com>
	 <20131223163410.GA28220@redhat.com> <20131223172744.GA2069@redhat.com>
	 <20131223182323.GA8656@gmail.com> <20131223183341.GA6082@redhat.com>
	 <20131224082931.GA20471@gmail.com>
	 <CE2C58F938F4C44EA74FFF880BAA7E5E1C68AD12@BBYEXM01.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CE2C58F938F4C44EA74FFF880BAA7E5E1C68AD12@BBYEXM01.pmc-sierra.internal>
Sender: linux-kernel-owner@vger.kernel.org
To: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Cc: Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Jason Seba <jason.seba42@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Tomas Henzl <thenzl@redhat.com>, Jack Wang <xjtuwjp@gmail.com>, Viswas G <Viswas.G@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vasanthalakshmi Tharmarajan <Vasanthalakshmi.Tharmarajan@pmcs.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-12-24 at 09:13 +0000, Suresh Thiagarajan wrote:
> 
> On Tue, Dec 24, 2013 at 1:59 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> wrote:
> >
> >> On 12/23, Ingo Molnar wrote:
> >> >
> >> > * Oleg Nesterov <oleg@redhat.com> wrote:
> >> >
> >> > > Initially I thought that this is obviously wrong, irqsave/irqrestore
> >> > > assume that "flags" is owned by the caller, not by the lock. And
> >> > > iirc this was certainly wrong in the past.
> >> > >
> >> > > But when I look at spinlock.c it seems that this code can actually
> >> > > work. _irqsave() writes to FLAGS after it takes the lock, and
> >> > > _irqrestore() has a copy of FLAGS before it drops this lock.
> >> >
> >> > I don't think that's true: if it was then the lock would not be
> >> > irqsave, a hardware-irq could come in after the lock has been taken
> >> > and before flags are saved+disabled.
> >>
> >> I do agree that this pattern is not safe, that is why I decided to ask.
> >>
> >> But, unless I missed something, with the current implementation
> >> spin_lock_irqsave(lock, global_flags) does:
> >>
> >>       unsigned long local_flags;
> >>
> >>       local_irq_save(local_flags);
> >>       spin_lock(lock);
> >>
> >>       global_flags = local_flags;
> >>
> >> so the access to global_flags is actually serialized by lock.
> 
> Below is a small pseudo code on protecting/serializing the flag for global access.
> struct temp
> {
> 	...
> 	spinlock_t lock;
> 	unsigned long lock_flags;
> };
> void my_lock(struct temp *t)
> {
>                unsigned long flag; // thread-private variable as suggested
>                spin_lock_irqsave(&t->lock, flag);
>                t->lock_flags = flag; //updating inside critical section now to serialize the access to flag
> }
> 
> void my_unlock(struct temp *t)
> {
>                unsigned long flag = t->lock_flags;
>                t->lock_flags = 0;  //clearing it before getting out of critical section
>                spin_unlock_irqrestore(&t->lock, flag);
> }
> 
> Here for unlocking, I could even use spin_unlock_irqrestore(&t->lock,
> t->lock_flags) directly instead of my_unlock() since t->lock_flags is
> updated only in my_lock and so there is no need to explicitly clear
> t->lock_flags. Please let me know if I miss anything here in
> serializing the global lock flag.

I don't think anyone's arguing that you can't do this.  The argument is
more you shouldn't: Lock contention is one of the biggest killers of
performance and getting locking right (avoiding inversions, or even
nested locks at all) is hard.  Therefore you need to keep the shortest
and clearest critical sections in Linux that you can, so the pattern for
locking is to lock and unlock in the same routine with a local flags
variable.

So, rather than develop a primitive that supports and encourages uses of
locking that violate the pattern and is far more likely to cause
performance and other problems, could you just audit the code to see if
the need to carry a lock across a routine could be eliminated (either by
shortening the critical section or by better nesting the calls).

Thanks,

James
