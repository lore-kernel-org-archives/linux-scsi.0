From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 7/8] SCSI: add a field to scsi_device to count open file
 references
Date: Wed, 5 Mar 2008 16:24:59 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0803051608140.4161-100000@iolanthe.rowland.org>
References: <1204750514.3047.63.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55145 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756772AbYCEVZA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 16:25:00 -0500
In-Reply-To: <1204750514.3047.63.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 5 Mar 2008, James Bottomley wrote:

> OK, I looked through the patch series.  It really looks like the
> in-kernel thing is the wrong approach.
> 
> Why not export this want_persist flag via sysfs and then have hal and
> udev update it when they see a filesystem on an underlying usb device
> mounted (and zero it out on unmount)?  That way you always have the
> exactly correct state and there's no need to go fishing for information
> in layers that are difficult to get to.

The flag (or rather, a similar one named "persist_enabled") already is
exported via sysfs.

Having hal+udev set it automatically as you describe never occurred 
to me.  The reason for doing all of this within the kernel is that 
Linus said (off-list) that the kernel should handle this automatically.  
Whether he considered userspace tools taking over the responsibility, I 
can't say.  (But he might object to having to wait for the tools to add 
the extra functionality.)

Now, it has to be mentioned that mounted filesystems on a USB device
account for something like 90% of the objections against USB-PERSIST.  
If we go ahead and enable it automatically in that case, there is
really very little reason not to enable it for every USB device, 
mounted or not.

In fact, the only other important reason for not turning it on by
default (or always!) is because the USB spec says not to.  By adding
this check for mounted filesystems, we are trying to adhere as closely
as possible to the spec -- but only in cases where we don't care since
it doesn't matter!

Whether to enable USB-PERSIST for mounted devices is a policy decision.  
Whether that policy should be set by the kernel or by userspace is
outside my jursidiction.  If you think this approach is wrong-headed
and you can convince Linus to go along, I'll be willing to drop the
last three patches in this series.

Alan Stern

