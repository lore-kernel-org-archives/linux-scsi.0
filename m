From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: 28 Feb 2004 09:39:48 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077982791.2020.25.camel@mulgrave>
References: <1077906383.2157.98.camel@mulgrave>
		<3462370000.1077909838@aslan.btc.adaptec.com>
	<1077910452.2157.110.camel@mulgrave>
	<3492060000.1077915050@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:58316 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261871AbUB1Pjz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Feb 2004 10:39:55 -0500
In-Reply-To: <3492060000.1077915050@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Fri, 2004-02-27 at 14:50, Justin T. Gibbs wrote:
> Well, experience shows that if you implement a SCSI system based solely

Heh, well, I won't disagree with that.

> There are lots of devices out there that require a delay of at least
> 250ms in order to not deadlock their internal SCSI processor.  The
> I/O load of the system has no bearing on when a device will become
> "unbusy" (we can't even say why it is "busy"), so I fail to see why
> it should have any effect on how long we wait in response to this
> condition.

Could you give the most common example ... I'll see if I can persuade
the OSDL test people to try it out with the current stack?

What we currently do is by design ... on busy or queue full at zero
depth we pause for three unplugs.  The first will be the returning queue
unplug, but the other two depend on the I/O pressure or the unplug
timer.  If you tell me what the inquiry strings of these devices are, I
can blacklist them to have a much larger max_device_blocked count, so if
there is a problem with them, *all* drivers will work rather than just
the Adaptec ones.

> In order to issue a DV command to the end device via the mid-layer, the
> host queue and the device queue must not be blocked.  But, for DV to be
> effective, it must be the only activity occurring on that device.  How do
> you reconcile the two while using the mid-layer to do your I/O?  The
> mid-layer has no concept of allowing a client to freeze the queue,
> wait for the active count to go to zero, effectively pre-empt
> the command stream with a series of special commands, and then unblock
> everyone else only at the end.  The closest the mid-layer comes to this
> is in some of its error recovery handling but those are internal
> interfaces.

But domain validation is a pretty intrusive thing.  It's only really
supposed to be run in two places:

1. At start of day, which you should do from slave_configure, where you
are guaranteed that nothing else is using the device

2. On indication of transport problems.  This you would run for a single
target from the bus or device reset handler after issuing the command
and pausing for the settle time (OK, that's bad because the settle time
is also built into the error handler, but that will improve when error
handling becomes more transport specific and I can build domain
validation directly into the SPI transport error handling).

In both of these cases, you are guaranteed a quiescent device queue, so
I don't see what the problem is.

James

