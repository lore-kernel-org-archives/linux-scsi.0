From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Sun, 29 Feb 2004 12:26:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <154922704.1078082802@aslan.btc.adaptec.com>
References: <1077906383.2157.98.camel@mulgrave>		<3462370000.1077909838@aslan.btc.adaptec.com>	<1077910452.2157.110.camel@mulgrave> 	<3492060000.1077915050@aslan.btc.adaptec.com> <1077982791.2020.25.camel@mulgrave>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:24215 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262115AbUB2T0u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 14:26:50 -0500
In-Reply-To: <1077982791.2020.25.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

>> There are lots of devices out there that require a delay of at least
>> 250ms in order to not deadlock their internal SCSI processor.  The
>> I/O load of the system has no bearing on when a device will become
>> "unbusy" (we can't even say why it is "busy"), so I fail to see why
>> it should have any effect on how long we wait in response to this
>> condition.
> 
> Could you give the most common example ... I'll see if I can persuade
> the OSDL test people to try it out with the current stack?

I don't recall exact devices, model numbers etc, but the behavior
I has been observed this behavior on scanners, CDROM drives, and
several external RAID controllers from different vendors.

> If you tell me what the inquiry strings of these devices are, I
> can blacklist them to have a much larger max_device_blocked count, so if
> there is a problem with them, *all* drivers will work rather than just
> the Adaptec ones.

This is not something worth black-listing.  It is not a special case.
Busy and/or queue full with no I/O pending is a rare event.  The user
will never notice this in practice other than their devices that need
this delay will work correctly in this situation.  To put it another
way, the aic7xxx and aic79xx drivers have enforced this delay for almost
four years in Linux and I have yet to have someone complain that they
had poor device performance due to this delay.  It is just not worth
the code complexity or potential of missing a broken device to "optimize"
this delay.

>> In order to issue a DV command to the end device via the mid-layer, the
>> host queue and the device queue must not be blocked.  But, for DV to be
>> effective, it must be the only activity occurring on that device.  How do
>> you reconcile the two while using the mid-layer to do your I/O?  The
>> mid-layer has no concept of allowing [this] ...
>
> But domain validation is a pretty intrusive thing.  It's only really
> supposed to be run in two places:
> 
> 1. At start of day, which you should do from slave_configure, where you
> are guaranteed that nothing else is using the device
> 
> 2. On indication of transport problems.  This you would run for a single
> target from the bus or device reset handler after issuing the command
> and pausing for the settle time (OK, that's bad because the settle time
> is also built into the error handler, but that will improve when error
> handling becomes more transport specific and I can build domain
> validation directly into the SPI transport error handling).
> 
> In both of these cases, you are guaranteed a quiescent device queue, so
> I don't see what the problem is.

First of all, domain validation may occur without the mid-layer ever
seeing a timeout.  The driver records transmission errors regardless of
whether they are successfully recovered (target performs a manual restore
data pointers), are properly reported via sense information, or result
in a timeout.  After a predetermined threshold, the driver will "fallback"
to a slower speed and re-perform domain validation.

Domain validation also occurs any time the driver believes the end-target
may have changed.  Typically this occurs due to a selection timeout or the
target reporting a power-on or inquiry change event.  The Linux mid-layer
is not very careful about determining if a device has changed.  This is
especially true during error recovery where unit attention conditions
are routinely discarded without any type of processing.  If the end
device has changed, the optimal negotiated transfer rate has likely
also changed, which is why domain validation is required.

Even without these issues, I don't see how you expect a driver to do
domain validation through the mid-layer.  If domain validation occurs
before the mid-layer scans for devices, then by definition, you can't
go through the mid-layer.  If you wait until after the device is found,
you run into the same problem of making sure the queue is frozen yet allows
your domain validation code to issue commands through the mid-layer.  
In the case of doing this in an error-handler, you again are not able
to issue these commands through the mid-layer - the queue is blocked.
This means that any correction to the queue full or busy behavior in the
mid-layer does not address the need for a functional delay in domain
validation case.

While it is certainly possible to move domain validation into the mid-layer
and remove it from LLDs, I doubt that is the type of change you want to
include in 2.6.  It would require at minimum:

1) A generic method for fetching and changing the transport parameters for
   devices attached to LLDs.

2) A generic method for freezing the execution queue and "single-stepping"
   things like domain validation and error recovery commands.

3) A way to wait for the active count on a device or target (including all
   luns) to drop to 0.

Don't get me wrong.  One of my main complaints of the Linux SCSI layer is
its intrinsic lack of consistency.  In my opinion, the code path for sending
commands to and processing the results from a LLD should be identical
regardless of whether the commands are from error recovery, domain validation,
a peripheral driver, or the probe code.  Instead we only get certain behavior
(like a bus settle delay) for some clients and not others.  Fixing this
would allow the behavior to be defined in one place and these "workarounds"
could be removed from the LLDs.  Unfortunately, the LLDs are the only "code
path" common to all of the clients of the mid-layer, so you wind up with the
LLDs enforcing correct behavior.

--
Justin

