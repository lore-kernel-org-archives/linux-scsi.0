From: Greg KH <greg@kroah.com>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices (fwd)
Date: Tue, 30 Oct 2007 21:24:00 -0700
Message-ID: <20071031042400.GA16426@kroah.com>
References: <1193672157.3383.22.camel@localhost.localdomain> <Pine.LNX.4.44L0.0710291434370.11432-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55807 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbXJaEXq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 00:23:46 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0710291434370.11432-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Kay Sievers <kay.sievers@vrfy.org>, Hannes Reinecke <hare@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Oct 29, 2007 at 02:47:59PM -0400, Alan Stern wrote:
> On Mon, 29 Oct 2007, James Bottomley wrote:
> 
> > I'm not sure if we can do this patch.  If you kill a device, you see
> > there's a processing state in scsi_prep_fn() for SDEV_DEL, which has a
> > printk message I see quite often when I unplug devices while they're
> > operating.
> > 
> > If you NULL out and free the request queue immediately after setting
> > SDEV_DEL, without allowing the devices and filesystems to finish, are
> > you sure we're not going to get a null deref on sdev->request_queue?
> 
> Let's get at this another way.  The patch below probably should be 
> applied in any case.  It's essentially a reversion of this patch from 
> 2003:
> 
> http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commit;h=10921a8f1305b8ec97794941db78b825db5839bc
> 
> which was written to compensate for problems in the SCSI stack.  The
> idea was to avoid releasing a kobject before all its children were
> released.  However as far as I can see, in general we should be able to
> release a kobject as soon as all its children are removed and its
> refcount drops to 0, without waiting for the children to be released.  
> To put it another way, once a child is removed from visibility it
> should not try (or need) to access its parent at all.  If it has to
> then it should take an explicit reference to the parent.
> 
> Since the SCSI stack is now in much better shape, there doesn't seem to 
> be any reason to keep the old code.  Do you agree that the patch below 
> is worth merging?  I submitted it to Greg some time ago, but he didn't 
> want to accept it without some assurance that it is now safe.
> 
> It would fix the problem Kay and saw with the circular references, 
> because the references would all get dropped when the scsi_device is 
> removed instead of waiting for a release that will never come.

Hm, will this really solve the problem properly?  I kept that above
patch because of the very real problem where a device in the middle of
the device tree can go away without the lower devices being gone.

The example at the time was usb-serial devices.  The physical USB device
goes away, but the tty device that userspace has open still sticks
around until userspace closes the char device.

With your patch, will things break for this usage model?

This kobject cleanup path is so fickle, I hate having to touch it :(

thanks,

greg k-h
