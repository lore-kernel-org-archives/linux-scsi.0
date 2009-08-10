From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Bugs in scsi_vpd_inquiry()
Date: Mon, 10 Aug 2009 13:08:58 -0400
Message-ID: <yq17hxbfvf9.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.44L0.0908101119460.3208-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:65150 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349AbZHJRJT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2009 13:09:19 -0400
In-Reply-To: <Pine.LNX.4.44L0.0908101119460.3208-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Mon, 10 Aug 2009 11:32:00 -0400 (EDT)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Wilcox <matthew@wil.cx>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <willy@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

>>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:

Alan,

>> > data always to be accurate may not be a good idea.  I'm considering
>> > adding a "restrict_to_MS_usb" flag to the host template, to
>> > indicate that commands shouldn't be sent unless some version of
>> > Windows uses them when talking to USB devices -- do you think that
>> > could work?
>> 
>> Not really my area of expertise.

Alan> Okay.  Maybe Martin has some thoughts on it.

First of all we're not going to send EVPD=1 out to devices reporting
SCSI_SPC_2 or lower anymore, making some of this discussion moot in the
short term.

But as I have alluded to in the past we do have a conflict brewing
because the switch to drives with 4KB physical blocks will mean USB
bridges will have to get smarter.  And that in turn will mean adhering
(*gasp*) to the standard instead of firmware writers flipping bits until
Windows stops crashing.  Windows 7 does in fact query drives about
alignment, block sizes, etc.  But I'm not sure how true that is for the
Windows USB storage stack.

Originally I was in favor of just considering any USB device suspect and
only send it a limited command set.  But the 4KB switch means that it is
imperative that we get the alignment reported correctly.  Performance is
totally and absolutely going to tank without it.  Enough that users will
complain loudly.

Consequently, I'm no longer a fan of the reduced command set approach.
Because in 12 months that MS command set *will* include stuff that
causes existing USB devices to crash, catch fire, or eat your breakfast.

And then we're back to finding heuristics for USB device brain damage.
Blindly clamping the SCSI rev. in scsiglue.c will have to be replaced
with something smarter.  And I really think that's what needs to be
fixed.

Please note that I'm not trying to weasel out of changing stuff in SCSI.
But it's USB devices that deviate wildly from the spec, so I think we
should keep as much of the workaround stuff in the USB stack as
possible.  And the current SCSI rev. mechanism is a reasonable way to
limit what we send out in sd.c.

So I'd prefer an approach where the USB stack sets the SCSI level
according to how much it trusts the attached device.

Is there a USB rev. or something else you can key off of and combine
with the device-reported SCSI rev. to come up with a better heuristic?
Something which doesn't depend on being SCSIly correct.

Do we have any way of identifying the devices that caused the SCSI
rev. to be clamped for USB in the first place?  Any way of collecting
that data over a couple of kernel release cycles?

-- 
Martin K. Petersen	Oracle Linux Engineering
