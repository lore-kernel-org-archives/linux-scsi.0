From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] pm80xx: Spinlock fix
Date: Mon, 23 Dec 2013 16:38:51 +0100
Message-ID: <20131223153851.GA27812@redhat.com>
References: <1387366123-3950-1-git-send-email-Viswas.G@pmcs.com> <52B8357D.60202@redhat.com> <52B83B89.9040700@gmail.com> <CE2C58F938F4C44EA74FFF880BAA7E5E1C68AA8A@BBYEXM01.pmc-sierra.internal> <CAD0Z9T+69VoSnDY-Sj7a1QfJ-KLJYVyL9=WQ123XMfRvQmGdsg@mail.gmail.com> <52B8518B.4060204@gmail.com> <52B8569D.4050101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab3LWPiF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Dec 2013 10:38:05 -0500
Content-Disposition: inline
In-Reply-To: <52B8569D.4050101@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Jack Wang <xjtuwjp@gmail.com>, Jason Seba <jason.seba42@gmail.com>, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>, Viswas G <Viswas.G@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Vasanthalakshmi Tharmarajan <Vasanthalakshmi.Tharmarajan@pmcs.com>

On 12/23, Tomas Henzl wrote:
>
> On 12/23/2013 04:06 PM, Jack Wang wrote:
> > On 12/23/2013 03:55 PM, Jason Seba wrote:
> >> Why is this considered dangerous?  I put some thought into it and
> >> couldn't find any obvious reason why it wouldn't work, but I also
> >> couldn't find any other drivers that work this way.  Is there a
> >> particular reason to avoid doing it this way?
> >>
> > If you use global flags, you may change interrupt state depends on context.
>
> The problem could show up when different threads try to store different content to the flags.

Agreed. I have no idea if the patch is right or not, but at least
the changelog should clearly explain that only one thread can do
spin_lock_irqsave(&x->lock, x->lock_flags) at any time, otherwise
the patch (and the code) _looks_ wrong even if it is correct.

And if we can't use a local "unsigned long flags" because _unlock
can happen in another function, imho this should be mentioned in
the changelog as well.

Oleg.

