From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: bug 2400
Date: Thu, 8 Apr 2004 10:09:48 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0404080941420.961-100000@ida.rowland.org>
References: <20040405151031.A5470@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3076 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261784AbUDHOJu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2004 10:09:50 -0400
In-Reply-To: <20040405151031.A5470@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 5 Apr 2004, Patrick Mansfield wrote:

> Much as I hate it, simply adding a lock_kernel in sd_remove would solve
> the problem, since do_open uses lock_kernel.

On Fri, 2 Apr 2004, Mike Anderson wrote:

> I believe as indicated above that all cross subsystem registrations need
> a release / put callback. This would allow the release chain to be
> called from block -> ULD -> scsi core -> LLDD.
> 
> Recently I have not been spending the proper time looking at this, but
> last look it appeared that we needed to  add a release / put method call
> to the gendisk disk_release routine. The release function or object to do
> the put on would need to be set prior to the call to add_disk.

On Mon, 5 Apr 2004, Mike Anderson wrote:

> As I previously stated there is no notification back from the block
> layer that users are complete with a structure. Currently the only 
> method to prevent an oops looks like sd_remove would need to use   
> lock_kernel so that scsi could ensure that a user would be through open
> which means the sd_remove would not take references to zero or the user
> has not made it far enough through do open that they have received a   
> gendisk structure so that del_gendisk will ensure they do not call     
> sd_open.
> 
> I would like another method, but this looks like it would need to be
> another shared sync mechanism between scsi layer (an other blk
> interfaces) and block layer or a lookup method similar to kobj_lookup
> in scsi open routines so that a object can be unmapped atomically.


Mike's first comment was exactly right.

If a pointer to a kobject (or kref) were added to the genhd structure, and 
if the genhd release routine would do a put() on this pointer, then there 
would be no problem.  The pointer could be set to the scsi_disk's embedded 
kobject, and then the scsi_disk structure would be guaranteed to exist 
when it is dereferenced in sd_open().

Likewise, if the scsi_disk took a reference to its scsi_device and dropped 
that reference during its release routine, that would cure the other 
potential oops I identified earlier.  In neither case would a kernel lock 
be needed.


This discussion has stimulated some ideas about the driver model in 
general.  It turns out that many drivers take a struct device from one 
subsystem and present it (in different form) to another subsystem.  Some 
examples:

	A SCSI host adapter driver takes a PCI device (or in the case
	of usb-storage, a USB device interface) and presents it to the
	SCSI core as a host adapter.

	The sd driver takes a SCSI device and presents it to the genhd
	layer as a disk drive.

	The USB UHCI driver takes a PCI device and presents it to the
	USB core as a USB bus.

In each case there are two driver-model structures involved: the parent 
which belongs to the upper subsystem, and the child which belongs to the 
lower subsystem.  No driver-model entity belongs to the intermediate 
driver!

As a result, when a disconnect occurs the driver has no way to know when 
the lower subsystem is finished using the device:

	The SCSI core does not notify the LLDD in any way following
	scsi_remove_host().

	The genhd layer doesn't inform sd.c when then genhd structure
	is released.

	usbcore _does_ notify the HC drivers via a callback when a bus is 
	released; it's an exception.

There is implicitly _a_ notification, because when the child device is 
released it drops its reference to the parent (I still think this would be 
better if it were done differently, but never mind).  However that doesn't 
do the intermediate driver any good, because the driver doesn't own the 
parent!  The parent is owned by the higher subsystem.

A general solution is to have the lower subsystem take a pointer to a 
kobject (or even a kref) belonging to the intermediate driver, and have it 
drop its reference when the child device is released.  This approach is 
just as flexible as the callback made by usbcore.

It could even be formalized as part of the driver model, although I'm not
at all certain this would be a good idea.  The concept is simple enough: A
struct device (or maybe a struct kobject) would have as an additional
member a pointer to a struct kobject (or maybe to a struct kref).  Call
this additional member "master".  During the device release (or kobject
cleanup) the core would do a put on the master pointer if it is set.

It's not clear that a sufficiently high percentage of all kobjects follow 
this intermediate-driver pattern for it to be worthwhile adding the master 
pointer.  But individual systems can still implement it on their own, and 
they should.

Alan Stern

