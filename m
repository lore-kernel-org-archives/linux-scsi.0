From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down disk
Date: Sat, 29 Sep 2007 19:52:56 +0200
Message-ID: <200709291952.56657.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0709291156460.29112-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:57256 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXI2Rv4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2007 13:51:56 -0400
In-Reply-To: <Pine.LNX.4.44L0.0709291156460.29112-100000@netrider.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pavel Machek <pavel@ucw.cz>, linux-usb-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Am Samstag 29 September 2007 schrieb Alan Stern:
> On Fri, 28 Sep 2007, Oliver Neukum wrote:
> 
> > Am Freitag 28 September 2007 schrieb Alan Stern:
> > > On Fri, 28 Sep 2007, Oliver Neukum wrote:

> I don't know what that's supposed to mean.  And whatever that means, it
> must be equally true that usb-storage doesn't know CD drives.  Or disk
> drives, or flash memories, or SCSI tape drives, or ...  On the whole,
> I'd say that usb-storage's lack of knowledge about SCSI devices greatly
> outweighs sr's lack of knowledge about hardware.

Neither driver knows enough to completely do power management.

> > > My point is that when dealing with SCSI disks, sd understands the 
> > > implications of Power Management better than usb-storage does.  
> > > Similarly, when dealing with SCSI cd drives, sr understands the 
> > > implications of Power Management better than usb-storage.
> > 
> > No. The capabilities of the hardware are determined by USB.
> > USB imposes two strict rules.
> > 
> > 1. The host cannot talk to a suspended device (keeping it suspended)
> > 2. Power consumption is very limited
> > 
> > It makes no sense to talk about power management of devices as
> > such. You need to talk about devices on the bus type they are connected
> > to.
> 
> You forget that the USB bus ends at the USB interface chip on the
> device.  From there on it's a different sort of bus.  It might be ATA,
> as in commonly-available USB-ATA converter boxes.  It might be a
> genuine SCSI bus, as in some USB-SCSI bridges.  It might be an internal
> flash-memory "bus".  It might be a full-blown Linux gadget.  And so on.
> 
> The suspend done by usb-storage suspends only the USB part of the link.  
> It might or might not affect anything beyond the device's USB chip, 
> depending on how the device was designed.

Yes, but do we care about we don't see anyway?

> Your (1) is correct, since all communication must take place over the
> USB link.  Your (2) is wrong -- the _link_'s power consumption is
> indeed limited, but the _device_ could be self-powered and so its power
> consumption need not be affected by the link state.  For instance in
> the case of a USB-ATA drive enclosure, power consumption is affected
> more by whether or not the disk is spinning than anything else.

OK, yes, it is true only for bus powered devices. Do we really want
to differentiate that far? I suggest we assume the worst case.
 
[..]
> Suppose we have devices A1 and A2, where A1 is the parent and A2 is the 
> child.  In order to pass between the CPU and A2, data must flow through 
> A1.  Let D1 and D2 be the drivers for A1 and A2.
> 
> It may be that for D2 to communicate with A2, it has to ask D1 to send 
> or receive the data for it.  Or it may be that once D1 has configured 
> A1, data can flow automatically through A1 with no need for further 
> involvement on D1's part.  Would you say that in either case the flow 
> of information has diverged from the device tree?

In the latter case it diverges.

> Suppose D1 decides that it wants to suspend A1, thus breaking the data
> link to A2.  Shouldn't it get D2's permission first?  Better yet,
> shouldn't it wait until D2 tells it: "Okay, A2 is safely suspended and
> I'm not going to talk to it for a while, you can suspend the link"?

Ok, I should be much more explicit and try to to explain very clearly.

In short:
D1 should definitely get D2's permission. But waiting is not enough.

Suppose we have all child devices in a suspended state. Then we might ask
whether this is enough to be sure that you can the suspend the parent.
Unfortunately it is not, as the bug report about the drive enclosure cutting
power when suspended shows.

Suspension in a higher layer can have effects that are different to suspension
of all devices on a lower level. Therefore the higher level must ask the lower
level to prepare itself.
Ideally it would ask the lower level for permission to do an autosuspend. I'd
like to change the API so that you can do that. But I don't think that the
lower levels have to implement autosuspend on their own to have levels
above them support autosuspend. Can you summarize your requirements
for supporting autosuspend in the higher levels?

	Regards
		Oliver
