From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: bug 2400
Date: Sun, 4 Apr 2004 23:17:55 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0404042235420.23916-100000@netrider.rowland.org>
References: <1081098273.2112.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:1803 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S263059AbUDEDR5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Apr 2004 23:17:57 -0400
In-Reply-To: <1081098273.2112.18.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 4 Apr 2004, James Bottomley wrote:

> On Sun, 2004-04-04 at 12:46, Alan Stern wrote:
> > Ah, you have left out the third, bad alternative: open succeeds, user gets 
> > an fd that points to a deallocated device.  More details below...
> 
> No, that would be a bug.

Of course it would!  That's exactly what this thread is about: bugs caused
by improper handling of open/disconnect races.

>  I'm looking for evidence that such a bug exists
> in sd.

Put up or shut up, eh?  Okay...

> This is what's wrong.  Here you should get a reference to the device
> pointer (that's what scsi_device_get() actually does for us).

That's too vague; I can't tell what you're referring to.  In sd.c 
there's the struct scsi_device, the struct scsi_disk, the struct gendisk, 
and their embedded struct devices and struct kobjects.  Maybe you mean 
scsi_disk_get(), the one place in sd.c that calls scsi_device_get().  I 
would say that it acquires a reference to the device, not to the device 
pointer (whatever that might mean).  But let's not dwell on this point.

>  If the
> ref getting routine comes back with an error, you may not proceed.  If
> it comes back with a device, you own a reference to it and may go on
> (even if the device is now gone, the structure will behave correctly).

What if the ref getting routine causes an oops because the device has been 
deallocated?  I know, you'll say that should never happen...  See below.


> You're not obeying the object lifetime rules here.  The device may be
> gone but the device structure must stay around (obviously in a special
> state) until the last reference is dropped.  Only after that may you
> start nulling things out and killing it.

In the example I gave, the device structure _did_ stay around until the 
last reference was dropped.  The problem was that _another_ reference was 
in the middle of being acquired at the time.

> If anyone can find a similar bug in the SCSI ULD's, I'll fix it, that's
> why I asked for an example in sd (or sr with the current fixes) way back
> in this thread.

All right, let's look at sd.c.  I'll show you that _it_ doesn't obey the 
object lifetime rules.  In sd_open we see this code (lightly edited):


	static int sd_open(struct inode *inode, struct file *filp)
	{
		struct gendisk *disk = inode->i_bdev->bd_disk;
		struct scsi_disk *sdkp = scsi_disk(disk);
		struct scsi_device *sdev;
		int retval;

		retval = scsi_disk_get(sdkp);
		if (retval)
			return retval;

		sdev = sdkp->device;


As it turns out, the block layer guarantees that when sd_open runs the
bd_disk pointer will be valid.  It does this by following the pattern I
mentioned in an earlier message -- drivers/base/map.c uses a
subsystem-wide semaphore, domain_sem, to properly synchronize lookups and
deletes.

Next, the scsi_disk inline function returns:

	container_of(disk->private_data, struct scsi_disk, driver);

How do you know that the scsi_disk pointed to by disk->private_data still 
exists?  So far as I can see, the gendisk doesn't take any references to 
it.  Correct me if I'm wrong, but there doesn't seem to be anything 
preventing a disconnect event from arriving after the open() call has got 
a valid reference to the gendisk, and succeeding in deallocating the 
scsi_disk before this code executes.  There's only one reference between 
the scsi_disk and the gendisk, and it goes the wrong way: the scsi_disk 
owns a reference to the gendisk.

But let's suppose that works okay, so sdkp is a valid pointer.  Then 
the code calls scsi_disk_get(), which in turn calls scsi_device_get() for 
sdkp->device.  How do you know that this doesn't point to deallocated 
storage?  The only reference to the scsi_device is taken (in a rather 
convoluted way) by the gendisk, and it is dropped during del_gendisk() -- 
not when the gendisk is released.  Hence it is entirely possible for a 
disconnect event to have freed the scsi_device when this code executes.


There's two potential oopses for you.  I don't have a full grasp of the
web of interlocking references (and interlocking code) in the SCSI,
gendisk, and block layers, but it seems likely that at least one of
these might actually happen.

The object lifetime rules require that in your disconnect() routine, you
must tell all your users that your structure is going away, but you must
not free the structure until your users have notified you that they won't
try to use it any more.  When the scsi_disk is on its way out, sd.c tells
the gendisk but doesn't wait for a notification in return.  When the
scsi_device is on its way out the SCSI core tells sd.c, but sd.c doesn't
send back its notification at the right time.

Alan Stern

