From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] pm80xx: Spinlock fix
Date: Mon, 23 Dec 2013 17:34:10 +0100
Message-ID: <20131223163410.GA28220@redhat.com>
References: <1387366123-3950-1-git-send-email-Viswas.G@pmcs.com> <52B8357D.60202@redhat.com> <52B83B89.9040700@gmail.com> <CE2C58F938F4C44EA74FFF880BAA7E5E1C68AA8A@BBYEXM01.pmc-sierra.internal> <CAD0Z9T+69VoSnDY-Sj7a1QfJ-KLJYVyL9=WQ123XMfRvQmGdsg@mail.gmail.com> <52B8518B.4060204@gmail.com> <52B8569D.4050101@redhat.com> <CAD0Z9TK-cn=X3ywSzPnEQN-FB+ue+0dHQ3EHuwonC+KfgrmPMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757276Ab3LWQdr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Dec 2013 11:33:47 -0500
Content-Disposition: inline
In-Reply-To: <CAD0Z9TK-cn=X3ywSzPnEQN-FB+ue+0dHQ3EHuwonC+KfgrmPMA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Seba <jason.seba42@gmail.com>
Cc: Tomas Henzl <thenzl@redhat.com>, Jack Wang <xjtuwjp@gmail.com>, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>, Viswas G <Viswas.G@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Vasanthalakshmi Tharmarajan <Vasanthalakshmi.Tharmarajan@pmcs.com>

On 12/23, Jason Seba wrote:
>
>  Wouldn't the contents of the global flags value be protected by the
> spinlock itself?

This can be even true because nowadays spin_lock_irqsave() writes to
"flags" after it takes the lock, and _irqrestore works gets the copy
of "flags" before it releases the lock.

Still this doesn't look safe and afaik this is not documented. Although
I have to admit that after I actually looked at the current implementation
I think this should work.

Perhaps we should ask the maintainers upstream? Even if this works, I am
not sure this is _supposed_ to work. I mean, in theory spin_lock_irqave()
can be changed as, say

	#define spin_lock_irqsave(lock, flags)		\
		do {    				\
			local_irq_save(flags);		\
			spin_lock(lock);		\
		} while (0)

(and iirc it was defined this way a long ago). In this case "flags" is
obviously not protected.

Oleg.

