From: Hugh Dickins <hugh@veritas.com>
Subject: Re: Fw: crash on x86_64 - mm related?
Date: Fri, 2 Dec 2005 19:12:19 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0512021856170.4940@goblin.wat.veritas.com>
References: <20051129092432.0f5742f0.akpm@osdl.org>
 <Pine.LNX.4.63.0512012040390.5777@kai.makisara.local>
 <Pine.LNX.4.64.0512011136000.3099@g5.osdl.org> <20051201195657.GB7236@tau.solarneutrino.net>
 <Pine.LNX.4.61.0512012008420.28450@goblin.wat.veritas.com>
 <20051202180326.GB7634@tau.solarneutrino.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from silver.veritas.com ([143.127.12.111]:48224 "EHLO
	silver.veritas.com") by vger.kernel.org with ESMTP id S1750781AbVLBTMe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Dec 2005 14:12:34 -0500
Received: from linux.wat.veritas.com([10.10.97.50]) (2977 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1EiGKS-0001HhC@megami.veritas.com>
	for <linux-scsi@vger.kernel.org>; Fri, 2 Dec 2005 11:12:20 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
In-Reply-To: <20051202180326.GB7634@tau.solarneutrino.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ryan Richter <ryan@tau.solarneutrino.net>
Cc: Linus Torvalds <torvalds@osdl.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2 Dec 2005, Ryan Richter wrote:
> On Thu, Dec 01, 2005 at 08:21:57PM +0000, Hugh Dickins wrote:
> > If the problem were easily reproducible, it'd be great if you could
> > try this patch; but I think you've said it's not :-(
> 
> I can throw this in and test it for sure.  I'll run the backups every
> day for a while to speed up the testing also.

Thanks - though everyone seems to have agreed that the patch is needed
whatever: so although it would be interesting to know if it has fixed
your problem, we're not waiting on you to go forward with it (James
already invited Linus to pull).

> Could someone please tell me exactly which patches I should include in
> the kernel I will boot tomorrow?

You hit the problem with 2.6.14.2.  My own opinion would be to apply
just that patch to that release, or to 2.6.14.3 if you prefer.

Linus was suggesting 2.6.15-rc4 because there's some debug there which
might have helped identify the offending driver: but your backtrace
had already showed us the offending driver.  Well, not proven: if a
page is doubly freed, the one that suffers is not necessarily the one
that's guilty; but it's a reasonable expectation.  I don't think his
debug would tell us anything more.

> I haven't played with -rc for ages, so
> I'm no longer sure which kernel I should start with (2.6.14 or
> 2.6.14.3?).

If you do want 2.6.15-rc4, then it's 2.6.14 + patch-2.6.15-rc4.

> Are the MPT-fusion performance fix patches in -rc4, or if
> not will they still apply?

I don't know it myself.  Is that the one about the module performing
much better than the builtin?  I'd expect that to be in.  If you have
it, suggest you look at your 2.6.15-rc4 source to see if it's there.

Hugh
