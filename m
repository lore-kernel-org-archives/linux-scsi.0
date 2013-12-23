From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: spinlock_irqsave() && flags (Was: pm80xx: Spinlock fix)
Date: Mon, 23 Dec 2013 19:24:55 +0100
Message-ID: <20131223182455.GA5656@redhat.com>
References: <52B8357D.60202@redhat.com> <52B83B89.9040700@gmail.com> <CE2C58F938F4C44EA74FFF880BAA7E5E1C68AA8A@BBYEXM01.pmc-sierra.internal> <CAD0Z9T+69VoSnDY-Sj7a1QfJ-KLJYVyL9=WQ123XMfRvQmGdsg@mail.gmail.com> <52B8518B.4060204@gmail.com> <52B8569D.4050101@redhat.com> <CAD0Z9TK-cn=X3ywSzPnEQN-FB+ue+0dHQ3EHuwonC+KfgrmPMA@mail.gmail.com> <20131223163410.GA28220@redhat.com> <20131223172744.GA2069@redhat.com> <CA+55aFy_y45feJNJgFa=Taks0GpxiXEMJexhjVVYH-vVFkPmkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFy_y45feJNJgFa=Taks0GpxiXEMJexhjVVYH-vVFkPmkA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jason Seba <jason.seba42@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Tomas Henzl <thenzl@redhat.com>, Jack Wang <xjtuwjp@gmail.com>, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>, Viswas G <Viswas.G@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Vasanthalakshmi Tharmarajan <Vasanthalakshmi.Tharmarajan@pmcs.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 12/23, Linus Torvalds wrote:
>
> On Mon, Dec 23, 2013 at 9:27 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > In short, is this code
> >
> >         spinlock_t LOCK;
> >         unsigned long FLAGS;
> >
> >         void my_lock(void)
> >         {
> >                 spin_lock_irqsave(&LOCK, FLAGS);
> >         }
> >
> >         void my_unlock(void)
> >         {
> >                 spin_unlock_irqrestore(&LOCK, FLAGS);
> >         }
> >
> > correct or not?
>
> Hell no. "flags" needs to be a thread-private variable, or at least
> protected some way (ie the above could work if everything is inside a
> bigger lock, to serialize access to FLAGS).

This was my understanding (although, once again, it seems to me this can
suprisingly work with the current implementation).

However, the code above already has the users. Do you think it makes
sense to add something like

	void spinlock_irqsave_careful(spinlock_t *lock, unsigned long *flags)
	{
		unsigned long _flags;
		spinlock_irqsave(lock, _flags);
		*flags = flags;
	}

	void spinlock_irqrestore_careful(spinlock_t *lock, unsigned long *flags)
	{
		unsigned long _flags = *flags;
		spinlock_irqrestore(lock, _flags);
	}

into include/linux/spinlock.h ?

Oleg.
