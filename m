From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices (fwd)
Date: Wed, 31 Oct 2007 11:51:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0710311131060.4704-100000@iolanthe.rowland.org>
References: <20071031042400.GA16426@kroah.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52219 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755929AbXJaPve (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 11:51:34 -0400
In-Reply-To: <20071031042400.GA16426@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Kay Sievers <kay.sievers@vrfy.org>, Hannes Reinecke <hare@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 30 Oct 2007, Greg KH wrote:

> > Since the SCSI stack is now in much better shape, there doesn't seem to 
> > be any reason to keep the old code.  Do you agree that the patch below 
> > is worth merging?  I submitted it to Greg some time ago, but he didn't 
> > want to accept it without some assurance that it is now safe.
> > 
> > It would fix the problem Kay and saw with the circular references, 
> > because the references would all get dropped when the scsi_device is 
> > removed instead of waiting for a release that will never come.
> 
> Hm, will this really solve the problem properly?  I kept that above
> patch because of the very real problem where a device in the middle of
> the device tree can go away without the lower devices being gone.

When you say "go away", do you mean "be deleted (deallocated)"?  In 
general that should not pose a problem.  Once a child has been 
unregistered it should not try to access its parent's structure any 
more.  Hence, if the parent structure gets deallocated before the child 
structure, nothing bad will happen.

Or when you say "go away", do you mean "be removed (unregistered)"?  If 
a parent is removed while it still has children registered, that's a 
genuine bug.  (In fact, driver_del() should check for this and issue a 
WARN_ON if it ever happens.)  The driver doing the remove needs to be 
fixed.

> The example at the time was usb-serial devices.  The physical USB device
> goes away, but the tty device that userspace has open still sticks
> around until userspace closes the char device.

Now you are using "goes away" to mean "is unplugged from the computer"!  :-)

There's nothing wrong with the physical device being unplugged, so long
as the logical usb_device structure remains allocated.  And since the
usb_device is the parent of the tty device (it is the parent, isn't
it?), it _will_ remain pinned while the tty device is registered.

So the only problem that could arise would be if the tty device and the
usb_device are both unregistered while userspace continues to hold the
char device file open.  There are two possible ways to handle this:

     1. Ideally, the usb-serial driver would realize that the USB 
	device was disconnected (by checking a private flag) and would
	therefore avoid trying to access the usb_device structure.

     2. If that's impractical, the usb-serial driver could take an
	explicit reference to the usb_device structure each time
	the char device file is opened, and drop the reference when
	the file is closed.

Either approach would work.

> With your patch, will things break for this usage model?

Not if the usb-serial drivers are written properly.

> This kobject cleanup path is so fickle, I hate having to touch it :(

Is usb-serial the worst case?  Then if it turns out to be compatible 
with this change, all other problems will be equally fixable.

Alan Stern

