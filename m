From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: Suspending SCSI devices and buses
Date: Fri, 20 Aug 2004 14:49:53 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <7C828B3E-F2EA-11D8-B9BF-00039398BB5E@ieee.org>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:35507 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S268761AbUHTUt0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 16:49:26 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>

 > a hardcoded invalidate on resume is overkill.

Theoretically yes.

 > current ... Linux kernel ... not distinguish
 > power-on events from media change events.

One case for leaving Linux pessimistic that way is ...

 > I'm not sure doing so is even possible for SCSI devices.
 > (Comments on that?)

SK ASC x 6 29 UnitAttention Reset is the only notice a host gets of a 
wall-powered drive unplugged from one host and plugged into another, 
when the bus does not distinctly identify the host, as in USB, etc.  
 From the drive's point of view, that is not an SK ASC x 6 28 
UnitAttention GoneReady ... yet still from the host's point of view, 
that is a media change.

Same for drives that don't let you remove the media: those drives might 
report no unit attentions at all, again implying that plug-in or resume 
of power is always a potential media change for the host.

 > old 1Gig Jaz drive

Those drives often report x 2 04 02 (else x 2 04 00 meaning x 2 04 
00..FF which includes x 2 04 02) while auto spun down, to help the host 
avoid timing out a read that includes spin up delay.  Their auto spin 
down time is configurable with vendor-specific protocol between resets. 
  Insertion spinup, eject spindown, while spinning up and down are all 
more intricate.

 > Does "Medium May Have Changed" show up reliably
 > if somebody changes the medium in a cartridge drive,
 > Zip drive, etc while it is powered down?

Relevant device design questions include:

1) Do enough hosts consistently limit how stale cache may be?

2) Do enough hosts reliably tolerate x 6 28 GoneReady produced by a 
suspend-resume power cycle without media change?

3) Does the device itself cache part of the disc?

4) Is the disc robust enough to tolerate a auto fetch of its identity 
after each resume or power on?

5) Does swapping the disc detectably change a mechanical state in the 
drive?

6) Was the device expensive enough to include a non-volatile record of 
the identity of the disc present before each suspend or power off?

In design, me, I'd vote to have the device pessimistically queue any UA 
that might be necessary, and let the host sort out which are real, but 
I'm not sure how often people like me lose such votes.

Pat LaVarre

