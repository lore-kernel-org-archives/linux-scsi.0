From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: question on flushing buffers and spinning down disk
Date: Mon, 24 Sep 2007 13:10:19 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709241257070.5501-100000@iolanthe.rowland.org>
References: <200709241847.17714.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53759 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754115AbXIXRKV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2007 13:10:21 -0400
In-Reply-To: <200709241847.17714.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Mon, 24 Sep 2007, Oliver Neukum wrote:

> > It sounds like you want to add the equivalent of
> > usb_autopm_get/set_device() and usb_autopm_get/set_interface() into the
> 
> That would be an ideal solution, but it is not necessary to solve this
> problem.
> 
> > driver model.  But it would not be appropriate, since other subsystems
> > don't have the same kinds of runtime power levels as USB does.
> 
> But we don't bother when suspending the whole system. So why not simply
> walk the subtrees under a USB device? Let the subsystem choose what
> depth of sleep to use.

Because by doing so you are effectively telling the drivers in the
subtree that the entire system is going to be suspended, which isn't
correct.  It may also turn out that the user wants to keep the
subsystem active, even though the USB driver isn't aware of it.  Last
but not least, the subsystem will need to have some form of autoresume.  

The way it should work is for the lower subsystem to tell the USB
driver when suspending is okay, not the other way around.  When the
subsystem implements its own form of runtime PM support, then you'll be
able to use it properly.  But until then, there isn't anything much you
can do.

> > There may be no way of getting around the need for specialized 
> > communication methods between subsystems for runtime PM.
> 
> That's a lot of code duplication and should be a solution of last resort.

Would it really be a lot of duplication?  That's hard to say at this
point, since I know of only one implementation.  It's still far too
early to say what the common features will be that all subsystems can
share.  Until we do have at least a rough idea, trying to set up a 
runtime PM core would be a waste of time.

For example, if we had runtime PM implemented in USB, SCSI, and PCI --
and we knew what sort of communication was needed between them -- then
we'd be ready to change the PM or driver core.  I don't think we're 
there yet.

Alan Stern

