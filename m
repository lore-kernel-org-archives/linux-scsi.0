From: Nathan Bryant <nbryant@optonline.net>
Subject: Re: Suspending SCSI devices and buses
Date: Fri, 20 Aug 2004 17:38:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41266F71.9060207@optonline.net>
References: <7C828B3E-F2EA-11D8-B9BF-00039398BB5E@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.5.68]:33477 "EHLO
	mta2.srv.hcvlny.cv.net") by vger.kernel.org with ESMTP
	id S267388AbUHTVi6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 17:38:58 -0400
Received: from [67.86.72.128] (ool-43564880.dyn.optonline.net [67.86.72.128])
 by mta2.srv.hcvlny.cv.net
 (iPlanet Messaging Server 5.2 HotFix 1.25 (built Mar  3 2004))
 with ESMTP id <0I2R00KU1LGX4G@mta2.srv.hcvlny.cv.net> for
 linux-scsi@vger.kernel.org; Fri, 20 Aug 2004 17:38:58 -0400 (EDT)
In-reply-to: <7C828B3E-F2EA-11D8-B9BF-00039398BB5E@ieee.org>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

Pat LaVarre wrote:

> > a hardcoded invalidate on resume is overkill.
>
> Theoretically yes.
>
> > current ... Linux kernel ... not distinguish
> > power-on events from media change events.
>
> One case for leaving Linux pessimistic that way is ...
>
> > I'm not sure doing so is even possible for SCSI devices.
> > (Comments on that?)
>
> SK ASC x 6 29 UnitAttention Reset is the only notice a host gets of a 
> wall-powered drive unplugged from one host and plugged into another, 
> when the bus does not distinctly identify the host, as in USB, etc.  
> From the drive's point of view, that is not an SK ASC x 6 28 
> UnitAttention GoneReady ... yet still from the host's point of view, 
> that is a media change.

We only see this sense when the device is unplugged from the wall in the 
process, right?

> Same for drives that don't let you remove the media: those drives 
> might report no unit attentions at all, again implying that plug-in or 
> resume of power is always a potential media change for the host.
>
> > old 1Gig Jaz drive
>
> Those drives often report x 2 04 02 (else x 2 04 00 meaning x 2 04 
> 00..FF which includes x 2 04 02) while auto spun down, to help the 
> host avoid timing out a read that includes spin up delay.  Their auto 
> spin down time is configurable with vendor-specific protocol between 
> resets.  Insertion spinup, eject spindown, while spinning up and down 
> are all more intricate.

OK, that translates as NOT_READY,     "LOGICAL UNIT NOT READY, 
INITIALIZING CMD. REQUIRED" Which means they require START UNIT, right?

>
> > Does "Medium May Have Changed" show up reliably
> > if somebody changes the medium in a cartridge drive,
> > Zip drive, etc while it is powered down?
>
> Relevant device design questions include:
>
> 1) Do enough hosts consistently limit how stale cache may be?
>
> 2) Do enough hosts reliably tolerate x 6 28 GoneReady produced by a 
> suspend-resume power cycle without media change?

According to recent SBC/SPC, drives are not supposed to produce x6 28 
for low-power conditions defined by the SCSI standard. There is a 
separate sense code for that: ILLEGAL REQUEST, ASC=LOW POWER CONDITION ON.

However, for SCSI devices hooked up to an ACPI capable desktop power 
supply, S3 suspend looks just like power-off to them. So in that case 
they're likely to report x6 29 and maybe also x6 28.

> 3) Does the device itself cache part of the disc?

With my patch, I'm sending SYNCHRONIZE CACHE on suspend.

> 4) Is the disc robust enough to tolerate a auto fetch of its identity 
> after each resume or power on?
>
> 5) Does swapping the disc detectably change a mechanical state in the 
> drive?
>
> 6) Was the device expensive enough to include a non-volatile record of 
> the identity of the disc present before each suspend or power off?
>
> In design, me, I'd vote to have the device pessimistically queue any 
> UA that might be necessary, and let the host sort out which are real, 
> but I'm not sure how often people like me lose such votes.

Kill 'em all, and let Ghod sort 'em out. :)
