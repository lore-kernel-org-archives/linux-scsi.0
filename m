From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Aic7x_x_x 6.3.4 && Aic79xx 2.0.5 Updates
Date: 26 Dec 2003 12:36:33 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1072463795.1873.127.camel@mulgrave>
References: <1051920000.1054684267@aslan.btc.adaptec.com>	<3637050000.1054690456@aslan.s
		csiguy.com>
	<2113050000.1072285128@aslan.scsiguy.com>	<1072288242.1906.35.camel@mulgrave
	> 	<2148850000.1072292121@aslan.scsiguy.com>
	<1072292714.2415.39.camel@mulgrave>
	<2304040000.1072326693@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:388 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265201AbTLZSgi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Dec 2003 13:36:38 -0500
In-Reply-To: <2304040000.1072326693@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@transmeta.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcelo Tosatti <marcelo@conectiva.com.br>, Andrew Morton <akpm@osdl.org>

On Wed, 2003-12-24 at 22:31, Justin T. Gibbs wrote:
> The crux of the problem is that *watchdog error recovery* is happening
> at entirely the wrong level in Linux. 

So this is actually an architectural complaint, not a bug in the SCSI
mid-layer as previously stated.

[...]
> Some of the problems with this strategy are:
> 
> 1) During recovery, access to perfectly viable devices is cut off.
> 
> 2) The mid-layer doesn't know which of the timed-out commands is the root
>    cause of the failure.  It assumes, since it doesn't have access to
>    better information, that all commands that have timed-out are equally
>    dead.
> 
> 3) If the mid-layer happens to abort a command that *is* the root cause
>    of the failure, the completions of all the "released" commands are
>    ignored.  This causes the mid-layer to request aborts for commands
>    that are not outstanding and then replay these commands that have
>    already completed successfully.  The replay may have unintended
>    side-effects - replay order is not maintained and no thought is given
>    to non-DASD devices where replay is destructive.  The replay may
>    also occur on a device that never really failed, but what held off
>    due to an error on another device.
> 
> 4) The TUR that occurs after each abort causes the recovery process to
>    take an inordinate amount of time.  Consider that the mid-layer can't
>    pick the most likely command to abort and that with lots of commands
>    outstanding chances are that at least half of the commands will have
>    to be aborted before the *right one* is aborted.

But your complaint is only that recovery takes longer than you think you
can do in the driver.

If error recovery were critical path in SCSI performance, this might be
a consideration, but it isn't...error recovery should be the exception,
not the rule.

[...]
> In general, I prefer the CAM model.  Briefly, this means, let the
> HBA drivers do what they can do best, provide as much information to
> the peripheral drivers so they can do their job correctly, and provide
> a "mid-layer" to simply route commands between the two.  This avoids
> having a mid-layer that second guesses, often incorrectly, both ends
> of the system.

The CAM (Common Access Model) was last updated in 1995 and is extremely
SCSI-2 (and hence parallel SCSI) specific.  The successive t10
committees charged with rewriting it have never successfully produced a
draft standard that has been published on the t10 site.

The linux SCSI subsystem follows the SAM (Scsi Architecture Model) which
was published as the backbone to SCSI-3 (SAM-3 was last updated in
November 2003).  I find it's command/transport separation extremely
appealing.  It has helped us to add new transports like Fibre and Even
SATA to the mix with relative ease.  This lack of command/transport
separation is, in my view, the biggest hole in CAM, and the reason why
we'll be continuing with SAM for Linux SCSI.

I cannot deny that the current error handler, trying to be all things to
all devices/transports, is out of kilter with this vision...it should,
at the very least have transport and device components...However, in
2.6, it does at least work.

On the Futures roadmap for the block layer in 2.7 is stackable error
recovery (you can already see the beginnings of this in the fastfail
processing) which will form the basis of async I/O, multi-path and
software RAID.

>From a technical perspective, the way you try to thwart mid-layer error
recovery: intercept all the SCSI timers and substitute your own, is
extremely ugly (and leads to quite a bit of code duplication) but it's
surely going to cause a conflict with the evolving stackable error
handling.

If you want to help us with the transport and device separations of the
error handler, you're more than welcome, but trying to pull all error
handling into your driver isn't useful because it adds layering
violations, promotes compatibility problems and cannot be used by any
other driver.

James


