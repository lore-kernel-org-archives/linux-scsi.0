From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down
 disk
Date: Sat, 29 Sep 2007 15:06:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709291428050.1094-100000@netrider.rowland.org>
References: <200709291952.56657.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:2116 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756176AbXI2TGK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2007 15:06:10 -0400
In-Reply-To: <200709291952.56657.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Pavel Machek <pavel@ucw.cz>, linux-usb-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Sat, 29 Sep 2007, Oliver Neukum wrote:

> > I don't know what that's supposed to mean.  And whatever that means, it
> > must be equally true that usb-storage doesn't know CD drives.  Or disk
> > drives, or flash memories, or SCSI tape drives, or ...  On the whole,
> > I'd say that usb-storage's lack of knowledge about SCSI devices greatly
> > outweighs sr's lack of knowledge about hardware.
> 
> Neither driver knows enough to completely do power management.

Right.  So each should do what it can, and neither should try to do the 
other's job.

> > The suspend done by usb-storage suspends only the USB part of the link.  
> > It might or might not affect anything beyond the device's USB chip, 
> > depending on how the device was designed.
> 
> Yes, but do we care about we don't see anyway?

Sure we do.  If the user tells the kernel to suspend a device, the
kernel should do its best to carry out the order -- even if the kernel
doesn't know exactly what's happening inside the device.

> > Your (1) is correct, since all communication must take place over the
> > USB link.  Your (2) is wrong -- the _link_'s power consumption is
> > indeed limited, but the _device_ could be self-powered and so its power
> > consumption need not be affected by the link state.  For instance in
> > the case of a USB-ATA drive enclosure, power consumption is affected
> > more by whether or not the disk is spinning than anything else.
> 
> OK, yes, it is true only for bus powered devices. Do we really want
> to differentiate that far? I suggest we assume the worst case.

It's not clear which case you think is worst, but it doesn't matter.  
We don't have to assume anything; all we have to do is send the right
commands at the right time.  Then it won't make any difference whether
the device is bus-powered or self-powered.


> > Suppose D1 decides that it wants to suspend A1, thus breaking the data
> > link to A2.  Shouldn't it get D2's permission first?  Better yet,
> > shouldn't it wait until D2 tells it: "Okay, A2 is safely suspended and
> > I'm not going to talk to it for a while, you can suspend the link"?
> 
> Ok, I should be much more explicit and try to to explain very clearly.
> 
> In short:
> D1 should definitely get D2's permission. But waiting is not enough.
> 
> Suppose we have all child devices in a suspended state. Then we might ask
> whether this is enough to be sure that you can the suspend the parent.
> Unfortunately it is not, as the bug report about the drive enclosure cutting
> power when suspended shows.

I disagree.  That bug report shows that problems arise when we try to
suspend a parent without making sure the children are suspended first.  
If the sd suspend method had already run then it would have been okay
for the enclosure to cut power.

> Suspension in a higher layer can have effects that are different to suspension
> of all devices on a lower level. Therefore the higher level must ask the lower
> level to prepare itself.

When the lower level is suspended then it is supposed to be prepared 
for the higher layer to suspend.  No additional preparation should be 
needed.

(That's true for USB and SCSI.  Other buses can have additional 
complications, like PCI with its multiple D states.  But the principle 
remains the same.)

> Ideally it would ask the lower level for permission to do an autosuspend. I'd
> like to change the API so that you can do that. But I don't think that the
> lower levels have to implement autosuspend on their own to have levels
> above them support autosuspend. Can you summarize your requirements
> for supporting autosuspend in the higher levels?

It's very simple: The higher level can't autosuspend if doing so would 
cause harm to the lower level.

There are two ways to avoid harm.  One is for the lower level to be 
such that it can never be harmed, no matter what the higher level does.  
For example, a purely logical entity like a partition won't be harmed 
if the drive it belongs to is suspended.  In fact we don't try to 
suspend partitions, and they don't even have drivers.

The other way is for the lower level to be suspended already.  That's
how the autosuspend framework operates: the lower level autosuspends
and tells the higher level that it is now safe for the higher level to
autosuspend.  It's not supposed to work by the higher level announcing:  
"I want to autosuspend now, so all you lower guys had better get
ready."

Even in the case of system suspend things don't work that way.  We
don't have higher-level drivers telling lower-level drivers to suspend.  
Rather, the PM core (acting on behalf of the user) tells _every_ driver
to suspend -- in the correct order, of course.

Now, how much extra work is involved in having the lower-level drivers 
implement autosuspend as opposed to having the higher-level driver ask 
permission?  Not much more than adding the autosuspend timers.  
Everything else is needed anyway for supporting manual runtime suspend.

Alan Stern

