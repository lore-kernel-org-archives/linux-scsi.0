From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: bug 2400
Date: Mon, 5 Apr 2004 15:10:31 -0700
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20040405151031.A5470@beaverton.ibm.com>
References: <1081098273.2112.18.camel@mulgrave> <Pine.LNX.4.44L0.0404042235420.23916-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0404042235420.23916-100000@netrider.rowland.org>; from stern@rowland.harvard.edu on Sun, Apr 04, 2004 at 11:17:55PM -0400
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Apr 04, 2004 at 11:17:55PM -0400, Alan Stern wrote:

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

Yes. 

If we are in middle opening an sd, and are anywhere between the
kobj_lookup having completed call to up_read(domain->sem) [called via
do_open calling get_gendisk] and sd_open calling scsi_device_get(), and
separately an sd_remove call completes [freeing the scsi_disk and the
scsi_device] there could be an oops.

Much as I hate it, simply adding a lock_kernel in sd_remove would solve
the problem, since do_open uses lock_kernel.

And I don't see why the kobject_get/put use an atomic_inc/dec, it just
obscures the need for a lock. We already have a reference to the kobject
(it's passed as an argument). The calls to the get/put must either be
protected with a lock or other method, or we have already gotten a
reference to the object and getting another is meaningless.

-- Patrick Mansfield


-------------------------------------------------------
This SF.Net email is sponsored by: IBM Linux Tutorials
Free Linux tutorial presented by Daniel Robbins, President and CEO of
GenToo technologies. Learn everything from fundamentals to system
administration.http://ads.osdn.com/?ad_id=1470&alloc_id=3638&op=click
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
