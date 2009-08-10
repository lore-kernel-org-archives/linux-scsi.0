From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Bugs in scsi_vpd_inquiry()
Date: Mon, 10 Aug 2009 16:13:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908101518020.4223-100000@iolanthe.rowland.org>
References: <yq17hxbfvf9.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43409 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751987AbZHJUNj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2009 16:13:39 -0400
In-Reply-To: <yq17hxbfvf9.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 10 Aug 2009, Martin K. Petersen wrote:

> >>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:
> 
> Alan,
> 
> >> > data always to be accurate may not be a good idea.  I'm considering
> >> > adding a "restrict_to_MS_usb" flag to the host template, to
> >> > indicate that commands shouldn't be sent unless some version of
> >> > Windows uses them when talking to USB devices -- do you think that
> >> > could work?
> >> 
> >> Not really my area of expertise.
> 
> Alan> Okay.  Maybe Martin has some thoughts on it.
> 
> First of all we're not going to send EVPD=1 out to devices reporting
> SCSI_SPC_2 or lower anymore, making some of this discussion moot in the
> short term.

Ah.  Has this change been posted anywhere yet?

> But as I have alluded to in the past we do have a conflict brewing
> because the switch to drives with 4KB physical blocks will mean USB
> bridges will have to get smarter.

If only all the existing bridges could be made smarter too!  :-)

>  And that in turn will mean adhering
> (*gasp*) to the standard instead of firmware writers flipping bits until
> Windows stops crashing.  Windows 7 does in fact query drives about
> alignment, block sizes, etc.  But I'm not sure how true that is for the
> Windows USB storage stack.

Does Vista also do this querying?  I've got access to a machine running 
Vista, so I can test the USB storage stack behavior.  But I don't have 
access to any machines with Windows 7.

> Originally I was in favor of just considering any USB device suspect and
> only send it a limited command set.  But the 4KB switch means that it is
> imperative that we get the alignment reported correctly.  Performance is
> totally and absolutely going to tank without it.  Enough that users will
> complain loudly.
> 
> Consequently, I'm no longer a fan of the reduced command set approach.
> Because in 12 months that MS command set *will* include stuff that
> causes existing USB devices to crash, catch fire, or eat your breakfast.

How will Windows 7 deal with all those old buggy USB devices?  (You 
probably don't have any idea...)

> And then we're back to finding heuristics for USB device brain damage.
> Blindly clamping the SCSI rev. in scsiglue.c will have to be replaced
> with something smarter.  And I really think that's what needs to be
> fixed.

I generally agree.  But finding a solution won't be easy.

> Please note that I'm not trying to weasel out of changing stuff in SCSI.
> But it's USB devices that deviate wildly from the spec, so I think we
> should keep as much of the workaround stuff in the USB stack as
> possible.  And the current SCSI rev. mechanism is a reasonable way to
> limit what we send out in sd.c.
> 
> So I'd prefer an approach where the USB stack sets the SCSI level
> according to how much it trusts the attached device.
> 
> Is there a USB rev. or something else you can key off of and combine
> with the device-reported SCSI rev. to come up with a better heuristic?
> Something which doesn't depend on being SCSIly correct.

No, there isn't.  There are USB device IDs, but they are assigned more 
or less randomly by the manufacturers -- they don't form a nicely 
increasing sequence of revision numbers.

Even worse, the device-reported SCSI rev. is completely independent of
the ID for the bridge chip, which is where the failures seem to occur.  
(Although it's hard to be certain which component is failing.)

> Do we have any way of identifying the devices that caused the SCSI
> rev. to be clamped for USB in the first place?  Any way of collecting
> that data over a couple of kernel release cycles?

Some of them are listed in the email archives.  Searching through some
old records I came across this example:

	http://marc.info/?l=linux-scsi&m=110895748728466&w=2

Unfortunately this thread doesn't contain the original bug report with
the USB device ID; I think the files were put up on a web server that 
doesn't exist any more.

I'm not keen on the idea of collecting more failure data by changing
the driver so as to cause failures!

Alan Stern

