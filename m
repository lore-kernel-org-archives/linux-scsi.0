From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Aic7x_x_x 6.3.4 && Aic79xx 2.0.5 Updates
Date: Fri, 26 Dec 2003 17:13:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2832150000.1072484024@aslan.scsiguy.com>
References: <1051920000.1054684267@aslan.btc.adaptec.com>	<3637050000.1054690456@aslan.s		csiguy.com>
 	<2113050000.1072285128@aslan.scsiguy.com>	<1072288242.1906.35.camel@mulgrave	>
 	<2148850000.1072292121@aslan.scsiguy.com>	<1072292714.2415.39.camel@mulgrave> 	<2304040000.1072326693@aslan.scsiguy.com>
 <1072463795.1873.127.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.scsiguy.com ([63.229.232.106]:6418 "EHLO aslan.scsiguy.com")
	by vger.kernel.org with ESMTP id S264268AbTL0AOF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Dec 2003 19:14:05 -0500
In-Reply-To: <1072463795.1873.127.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@transmeta.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcelo Tosatti <marcelo@conectiva.com.br>, Andrew Morton <akpm@osdl.org>

>> The crux of the problem is that *watchdog error recovery* is happening
>> at entirely the wrong level in Linux. 
> 
> So this is actually an architectural complaint, not a bug in the SCSI
> mid-layer as previously stated.

No.  There are several bugs in the mid-layer.  Replaying commands that
have successfully completed *is a bug*.  Stopping I/O to all devices
during recovery *is a bug*.  The current recovery handler is also fairly
stupid in how it does things.  I would also call this a bug.  In at
least 2.4 (haven't tested 2.6 yet), error recovery will loop forever.
This is also a bug.  The fact that peripheral drivers are not in control
of the replay of commands that fail is also a bug. etc. etc.

> But your complaint is only that recovery takes longer than you think you
> can do in the driver.
> 
> If error recovery were critical path in SCSI performance, this might be
> a consideration, but it isn't...error recovery should be the exception,
> not the rule.

Recovery is critical.  Why have failover controllers if it takes several
minutes for that failover to succeed.  The whole point of these controllers
is to allow a critical service to continue to operate almost uninterrupted.

> [...]
>> In general, I prefer the CAM model.  Briefly, this means, let the
>> HBA drivers do what they can do best, provide as much information to
>> the peripheral drivers so they can do their job correctly, and provide
>> a "mid-layer" to simply route commands between the two.  This avoids
>> having a mid-layer that second guesses, often incorrectly, both ends
>> of the system.
> 
> The CAM (Common Access Model) was last updated in 1995 and is extremely
> SCSI-2 (and hence parallel SCSI) specific.

You are missing the point of CAM (either version 2 or 3).  CAM was
designed to be transport agnostic.  It is not a replacement for SAM,
or any other high or low level protocol.  It is simply a routing engine
for  CAM Control Blocks (CCB), and a set of rules for how those CCBs
are routed between a peripheral driver and the low level "SIM" driver.
The exact details listed in the spec for the different CCB types are mostly
irrelevant since a single CAM subsystem may provide support for past and
future transport types that the spec couldn't envision.  In CAM, this
type of extension means defining a few CCB types for the new transport
and reusing the same routing engine unaltered.

> The successive t10
> committees charged with rewriting it have never successfully produced a
> draft standard that has been published on the t10 site.

This is because no-one wanted to rewrite their SCSI layers to be in
complete compliance with the letter and verse of CAM (i.e. the actual
CCB structure definitions listed in the CAM spec).  I was at the last
meeting of the CAM subcommittee so I know why it was disbanded.

> The linux SCSI subsystem follows the SAM (Scsi Architecture Model) which
> was published as the backbone to SCSI-3 (SAM-3 was last updated in
> November 2003).  I find it's command/transport separation extremely
> appealing.  It has helped us to add new transports like Fibre and Even
> SATA to the mix with relative ease.  This lack of command/transport
> separation is, in my view, the biggest hole in CAM, and the reason why
> we'll be continuing with SAM for Linux SCSI.

I'm fully aware of SAM and the whole T10 family of specs.  To believe that
CAM is transport specific is again to completely miss why it was written.
SAM is not even close to a replacement for CAM.

> I cannot deny that the current error handler, trying to be all things to
> all devices/transports, is out of kilter with this vision...it should,
> at the very least have transport and device components...However, in
> 2.6, it does at least work.

If the SCSI layer didn't have the critical flaws that:

 o scsi_done() doesn't always complete commands.
 o the HBA is not informed of timeouts until the HBA is idle
   and all other commands have timed out.
 o the HBA cannot discern between requests related to watchdog
   recovery and "normal" task management.

I would have just rewrittent the error handler.  Unfortunately,
you can't avoid the above three issues without canceling and
restoring timeouts.

> On the Futures roadmap for the block layer in 2.7 is stackable error
> recovery (you can already see the beginnings of this in the fastfail
> processing) which will form the basis of async I/O, multi-path and
> software RAID.

In general, the peripheral driver should get the first crack at any
status returned by an HBA driver.  Until that occurs, the Linux SCSI
layer is critically flawed.  If you are interested, you can look at
how the FreeBSD SCSI layer deals with these issues.  The peripheral
driver "filters" all errors and defaults to using a common, generic
error handler for errors that do not need special handling.  Right
now, the Linux mid-layer hides information and performs actions that
are not necessarilly what the peripheral driver wants.  Other than
perhaps statistics gathering, and other actions that are not visible
to the end device, this should not be the case.

> From a technical perspective, the way you try to thwart mid-layer error
> recovery: intercept all the SCSI timers and substitute your own, is
> extremely ugly (and leads to quite a bit of code duplication) but it's
> surely going to cause a conflict with the evolving stackable error
> handling.

I doubt that.  The higher levels will never see a timeout.  For other
transport errors that are visible in terms of returned SCSI status,
the abort, BDR, and reset entry points are fully functional.  The
current strategy also guarantees that I can quickly and easily correct
any bug reports that are sent to me regarding how my drivers perform
recovery.  This was exactly why I took the steps I did.

> If you want to help us with the transport and device separations of the
> error handler, you're more than welcome, but trying to pull all error
> handling into your driver isn't useful because it adds layering
> violations, promotes compatibility problems and cannot be used by any
> other driver.

I'm not pulling all error recovery into my driver.  I'm pulling transport
specific *watchdog recovery* into my driver.  It is the HBA's job to ensure
that it can access the devices attached to it.  The peripheral driver's
job is to inform the HBA of a drop-dead time for a command.  Recovering
from a timeout is actually very straight forward if you have the information
you need to do it correctly.  This can only be done at the HBA where HBA
specific state can be referenced to pick the correct type of action.  This,
to my mind, is just a minor extention to the transport validation and
recovery that HBAs also must do in order to be robust.  Protocol and device
specific recovery (related to SCSI status, residuals, etc.) will continue to
be performed by the peripheral driver (or as in the case of Linux, by
the mid-layer).  I have no interest in *doing it all*, only what I have
to for the drivers I maintain to be robust.

--
Justin

