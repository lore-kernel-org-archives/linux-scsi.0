From: Ingo Molnar <mingo@kernel.org>
Subject: Re: spinlock_irqsave() && flags (Was: pm80xx: Spinlock fix)
Date: Tue, 24 Dec 2013 09:29:31 +0100
Message-ID: <20131224082931.GA20471@gmail.com>
References: <52B83B89.9040700@gmail.com>
 <CE2C58F938F4C44EA74FFF880BAA7E5E1C68AA8A@BBYEXM01.pmc-sierra.internal>
 <CAD0Z9T+69VoSnDY-Sj7a1QfJ-KLJYVyL9=WQ123XMfRvQmGdsg@mail.gmail.com>
 <52B8518B.4060204@gmail.com>
 <52B8569D.4050101@redhat.com>
 <CAD0Z9TK-cn=X3ywSzPnEQN-FB+ue+0dHQ3EHuwonC+KfgrmPMA@mail.gmail.com>
 <20131223163410.GA28220@redhat.com>
 <20131223172744.GA2069@redhat.com>
 <20131223182323.GA8656@gmail.com>
 <20131223183341.GA6082@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131223183341.GA6082@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jason Seba <jason.seba42@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Tomas Henzl <thenzl@redhat.com>, Jack Wang <xjtuwjp@gmail.com>, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>, Viswas G <Viswas.G@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Vasanthalakshmi Tharmarajan <Vasanthalakshmi.Tharmarajan@pmcs.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 12/23, Ingo Molnar wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > Initially I thought that this is obviously wrong, irqsave/irqrestore
> > > assume that "flags" is owned by the caller, not by the lock. And
> > > iirc this was certainly wrong in the past.
> > >
> > > But when I look at spinlock.c it seems that this code can actually
> > > work. _irqsave() writes to FLAGS after it takes the lock, and
> > > _irqrestore() has a copy of FLAGS before it drops this lock.
> >
> > I don't think that's true: if it was then the lock would not be
> > irqsave, a hardware-irq could come in after the lock has been taken
> > and before flags are saved+disabled.
> 
> I do agree that this pattern is not safe, that is why I decided to ask.
> 
> But, unless I missed something, with the current implementation
> spin_lock_irqsave(lock, global_flags) does:
> 
> 	unsigned long local_flags;
> 
> 	local_irq_save(local_flags);
> 	spin_lock(lock);
> 
> 	global_flags = local_flags;
> 
> so the access to global_flags is actually serialized by lock.

You are right, today that's true technically because IIRC due to Sparc 
quirks we happen to return 'flags' as a return value - still it's very 
ugly and it could break anytime if we decide to do more aggressive 
optimizations and actually directly save into 'flags'.

Note that even today there's a narrow exception: on UP we happen to 
build it the other way around, so that we do:

	local_irq_save(global_flags);
	__acquire(lock);

This does not matter for any real code because on UP there is no 
physical lock and __acquire() is empty code-wise, but any compiler 
driven locking analysis tool using __attribute__ __context__(), if 
built on UP, would see the unsafe locking pattern.

Thanks,

	Ingo
