From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: bug 2400
Date: Mon, 5 Apr 2004 07:59:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040405145933.GC8535@us.ibm.com>
References: <1081098273.2112.18.camel@mulgrave> <Pine.LNX.4.44L0.0404042235420.23916-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:40654 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263399AbUDGBMR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2004 21:12:17 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0404042235420.23916-100000@netrider.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>


PS, I am traveling today so future comments will be delayed a bit.

Alan Stern [stern@rowland.harvard.edu] wrote:
> All right, let's look at sd.c.  I'll show you that _it_ doesn't obey the 
> object lifetime rules.  In sd_open we see this code (lightly edited):
> 
> 
> 	static int sd_open(struct inode *inode, struct file *filp)
> 	{
> 		struct gendisk *disk = inode->i_bdev->bd_disk;
> 		struct scsi_disk *sdkp = scsi_disk(disk);
> 		struct scsi_device *sdev;
> 		int retval;
> 
> 		retval = scsi_disk_get(sdkp);
> 		if (retval)
> 			return retval;
> 
> 		sdev = sdkp->device;
> 
> 
> As it turns out, the block layer guarantees that when sd_open runs the
> bd_disk pointer will be valid.  It does this by following the pattern I
> mentioned in an earlier message -- drivers/base/map.c uses a
> subsystem-wide semaphore, domain_sem, to properly synchronize lookups and
> deletes.
> 
> Next, the scsi_disk inline function returns:
> 
> 	container_of(disk->private_data, struct scsi_disk, driver);
> 
> How do you know that the scsi_disk pointed to by disk->private_data still 
> exists?  So far as I can see, the gendisk doesn't take any references to 
> it.  Correct me if I'm wrong, but there doesn't seem to be anything 
> preventing a disconnect event from arriving after the open() call has got 
> a valid reference to the gendisk, and succeeding in deallocating the 
> scsi_disk before this code executes.  There's only one reference between 
> the scsi_disk and the gendisk, and it goes the wrong way: the scsi_disk 
> owns a reference to the gendisk.
> 
> But let's suppose that works okay, so sdkp is a valid pointer.  Then 
> the code calls scsi_disk_get(), which in turn calls scsi_device_get() for 
> sdkp->device.  How do you know that this doesn't point to deallocated 
> storage?  The only reference to the scsi_device is taken (in a rather 
> convoluted way) by the gendisk, and it is dropped during del_gendisk() -- 
> not when the gendisk is released.  Hence it is entirely possible for a 
> disconnect event to have freed the scsi_device when this code executes.
> 
> 
> There's two potential oopses for you.  I don't have a full grasp of the
> web of interlocking references (and interlocking code) in the SCSI,
> gendisk, and block layers, but it seems likely that at least one of
> these might actually happen.
> 
> The object lifetime rules require that in your disconnect() routine, you
> must tell all your users that your structure is going away, but you must
> not free the structure until your users have notified you that they won't
> try to use it any more.  When the scsi_disk is on its way out, sd.c tells
> the gendisk but doesn't wait for a notification in return.  When the
> scsi_device is on its way out the SCSI core tells sd.c, but sd.c doesn't
> send back its notification at the right time.

As I previously stated there is no notification back from the block
layer that users are complete with a structure. Currently the only
method to prevent an oops looks like sd_remove would need to use
lock_kernel so that scsi could ensure that a user would be through open
which means the sd_remove would not take references to zero or the user
has not made it far enough through do open that they have received a
gendisk structure so that del_gendisk will ensure they do not call
sd_open.

I would like another method, but this looks like it would need to be
another shared sync mechanism between scsi layer (an other blk
interfaces) and block layer or a lookup method similar to kobj_lookup
in scsi open routines so that a object can be unmapped atomically.

-andmike
--
Michael Anderson
andmike@us.ibm.com

