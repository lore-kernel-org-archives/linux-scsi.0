From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: hot scsi disk resize
Date: 17 Mar 2003 10:21:41 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1047918111.1632.3.camel@mulgrave>
References: <m3bs0s9xij.fsf@lexa.home.net>
	<20030303181536.A30199@infradead.org>  <m365qz8vlp.fsf@lexa.home.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <m365qz8vlp.fsf@lexa.home.net>
List-Id: linux-scsi@vger.kernel.org
To: alexey@technomagesinc.com
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>, Dennis Gerasimov <denis@technomagesinc.com>, viro@math.psu.edu

On Tue, 2003-03-04 at 01:00, alexey@technomagesinc.com wrote:
> Here is new version of the patch. All procfs-related stuff has been removed.
> One may rescan device size writing something to /sysfs/.../<scsi device>/rescan:

I applied all of this, except this piece:

> diff -uNr linux/fs/block_dev.c edited/fs/block_dev.c
> --- linux/fs/block_dev.c	Mon Jan 20 02:23:49 2003
> +++ edited/fs/block_dev.c	Mon Mar  3 18:49:47 2003
> @@ -623,6 +623,8 @@
>  			up(&whole->bd_sem);
>  		}
>  	} else {
> +		if (!part)
> +			bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
>  		put_disk(disk);
>  		module_put(owner);
>  		if (bdev->bd_contains == bdev) {
> 
> 

Because adding this in will break the initial ramdisk.  Thus, although
the SCSI layer does resize, the block layer may not.

I've copied Al Viro because he's more familiar with the block layer
device code than I and may have been planning to add this feature.  Al,
can you tell us what needs to happen to allow for hot resizing a SCSI
disc?

Thanks,

James


