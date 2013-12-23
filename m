From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: spinlock_irqsave() && flags (Was: pm80xx: Spinlock fix)
Date: Mon, 23 Dec 2013 19:33:41 +0100
Message-ID: <20131223183341.GA6082@redhat.com>
References: <52B8357D.60202@redhat.com> <52B83B89.9040700@gmail.com> <CE2C58F938F4C44EA74FFF880BAA7E5E1C68AA8A@BBYEXM01.pmc-sierra.internal> <CAD0Z9T+69VoSnDY-Sj7a1QfJ-KLJYVyL9=WQ123XMfRvQmGdsg@mail.gmail.com> <52B8518B.4060204@gmail.com> <52B8569D.4050101@redhat.com> <CAD0Z9TK-cn=X3ywSzPnEQN-FB+ue+0dHQ3EHuwonC+KfgrmPMA@mail.gmail.com> <20131223163410.GA28220@redhat.com> <20131223172744.GA2069@redhat.com> <20131223182323.GA8656@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab3LWSd2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Dec 2013 13:33:28 -0500
Content-Disposition: inline
In-Reply-To: <20131223182323.GA8656@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Jason Seba <jason.seba42@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Tomas Henzl <thenzl@redhat.com>, Jack Wang <xjtuwjp@gmail.com>, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>, Viswas G <Viswas.G@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Vasanthalakshmi Tharmarajan <Vasanthalakshmi.Tharmarajan@pmcs.com>, linux-kernel@vger.kernel.org

On 12/23, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Initially I thought that this is obviously wrong, irqsave/irqrestore
> > assume that "flags" is owned by the caller, not by the lock. And
> > iirc this was certainly wrong in the past.
> >
> > But when I look at spinlock.c it seems that this code can actually
> > work. _irqsave() writes to FLAGS after it takes the lock, and
> > _irqrestore() has a copy of FLAGS before it drops this lock.
>
> I don't think that's true: if it was then the lock would not be
> irqsave, a hardware-irq could come in after the lock has been taken
> and before flags are saved+disabled.

I do agree that this pattern is not safe, that is why I decided to ask.

But, unless I missed something, with the current implementation
spin_lock_irqsave(lock, global_flags) does:

	unsigned long local_flags;

	local_irq_save(local_flags);
	spin_lock(lock);

	global_flags = local_flags;

so the access to global_flags is actually serialized by lock.

> So AFAICS this is an unsafe pattern, beyond being ugly as hell.

Yes, I think the same.

Oleg.

