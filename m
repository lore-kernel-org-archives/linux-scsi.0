From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 2/6] block: push down BKL into .open and .release
Date: Sun, 4 Jul 2010 10:01:46 +0200
Message-ID: <20100704080146.GA31828@merkur.ravnborg.org>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de> <1278193640-24223-3-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1278193640-24223-3-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>  
>  static int DAC960_getgeo(struct block_device *bdev, struct hd_geometry *geo)
> diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
> index 7a51535..8af7af7 100644
> --- a/drivers/block/amiflop.c
> +++ b/drivers/block/amiflop.c
> @@ -1555,10 +1555,13 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
>  	int old_dev;
>  	unsigned long flags;
>  
> +	lock_kernel();
>  	old_dev = fd_device[drive];
>  
> -	if (fd_ref[drive] && old_dev != system)
> +	if (fd_ref[drive] && old_dev != system) {
> +		unlock_kernel();
>  		return -EBUSY;
> +	}
>  
>  	if (mode & (FMODE_READ|FMODE_WRITE)) {
>  		check_disk_change(bdev);
> @@ -1571,8 +1574,10 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
>  			fd_deselect (drive);
>  			rel_fdc();
>  
> -			if (wrprot)
> +			if (wrprot) {
> +				unlock_kernel();
>  				return -EROFS;
> +			}
>  		}
>  	}
>  
> @@ -1589,6 +1594,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
>  	printk(KERN_INFO "fd%d: accessing %s-disk with %s-layout\n",drive,
>  	       unit[drive].type->name, data_types[system].name);
>  
> +	unlock_kernel();
>  	return 0;
>  }

Using goto for errorhandling here would have been nicer.
Also did you forget to include smp_locks.h?



>  
> @@ -1597,6 +1603,7 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
>  	struct amiga_floppy_struct *p = disk->private_data;
>  	int drive = p - unit;
>  
> +	lock_kernel();
>  	if (unit[drive].dirty == 1) {
>  		del_timer (flush_track_timer + drive);
>  		non_int_flush_track (drive);
> @@ -1610,6 +1617,7 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
>  /* the mod_use counter is handled this way */
>  	floppy_off (drive | 0x40000000);
>  #endif
> +	unlock_kernel();
>  	return 0;
>  }

Cooked up the following replacement patch:
[Not build tested]

diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 832798a..25d63cf 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -67,6 +67,7 @@
 #include <linux/elevator.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/smp_lock.h>
 
 #include <asm/setup.h>
 #include <asm/uaccess.h>
@@ -1541,11 +1542,16 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	int system =  (MINOR(bdev->bd_dev) & 4) >> 2;
 	int old_dev;
 	unsigned long flags;
+	int err;
 
+	err = 0;
+	lock_kernel();
 	old_dev = fd_device[drive];
 
-	if (fd_ref[drive] && old_dev != system)
-		return -EBUSY;
+	if (fd_ref[drive] && old_dev != system) {
+		err = -EBUSY;
+		goto out;
+	}
 
 	if (mode & (FMODE_READ|FMODE_WRITE)) {
 		check_disk_change(bdev);
@@ -1558,8 +1564,10 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 			fd_deselect (drive);
 			rel_fdc();
 
-			if (wrprot)
-				return -EROFS;
+			if (wrprot) {
+				err = -EROFS;
+				goto out;
+			}
 		}
 	}
 
@@ -1576,7 +1584,9 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	printk(KERN_INFO "fd%d: accessing %s-disk with %s-layout\n",drive,
 	       unit[drive].type->name, data_types[system].name);
 
-	return 0;
+out:
+	unlock_kernel();
+	return err;
 }
 
 static int floppy_release(struct gendisk *disk, fmode_t mode)
@@ -1584,6 +1594,7 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
 	struct amiga_floppy_struct *p = disk->private_data;
 	int drive = p - unit;
 
+	lock_kernel();
 	if (unit[drive].dirty == 1) {
 		del_timer (flush_track_timer + drive);
 		non_int_flush_track (drive);
@@ -1597,6 +1608,7 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
 /* the mod_use counter is handled this way */
 	floppy_off (drive | 0x40000000);
 #endif
+	unlock_kernel();
 	return 0;
 }
 

Feel free to use this as is.


> +++ b/drivers/block/aoe/aoeblk.c
> @@ -12,6 +12,7 @@
>  #include <linux/slab.h>
>  #include <linux/genhd.h>
>  #include <linux/netdevice.h>
> +#include <linux/smp_lock.h>
>  #include "aoe.h"
>  
>  static struct kmem_cache *buf_pool_cache;
> @@ -124,13 +125,16 @@ aoeblk_open(struct block_device *bdev, fmode_t mode)
>  	struct aoedev *d = bdev->bd_disk->private_data;
>  	ulong flags;
>  
> +	lock_kernel();
>  	spin_lock_irqsave(&d->lock, flags);
>  	if (d->flags & DEVFL_UP) {
>  		d->nopen++;
>  		spin_unlock_irqrestore(&d->lock, flags);
> +		unlock_kernel();
>  		return 0;
>  	}
>  	spin_unlock_irqrestore(&d->lock, flags);
> +	unlock_kernel();
>  	return -ENODEV;
>  }

"goto out" would be cleaner.

> diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> index 1f70aec..4f2e12f 100644
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -2383,6 +2383,7 @@ static int pkt_open(struct block_device *bdev, fmode_t mode)
>  
>  	VPRINTK(DRIVER_NAME": entering open\n");
>  
> +	lock_kernel();
>  	mutex_lock(&ctl_mutex);
>  	pd = pkt_find_dev_from_minor(MINOR(bdev->bd_dev));
>  	if (!pd) {
> @@ -2410,6 +2411,7 @@ static int pkt_open(struct block_device *bdev, fmode_t mode)
>  	}
>  
>  	mutex_unlock(&ctl_mutex);
> +	unlock_kernel();
>  	return 0;
>  
>  out_dec:
> @@ -2417,6 +2419,7 @@ out_dec:
>  out:
>  	VPRINTK(DRIVER_NAME": failed open (%d)\n", ret);
>  	mutex_unlock(&ctl_mutex);
> +	unlock_kernel();
>  	return ret;
>  }
>  
> @@ -2425,6 +2428,7 @@ static int pkt_close(struct gendisk *disk, fmode_t mode)
>  	struct pktcdvd_device *pd = disk->private_data;
>  	int ret = 0;
>  
> +	lock_kernel();
>  	mutex_lock(&ctl_mutex);
>  	pd->refcnt--;
>  	BUG_ON(pd->refcnt < 0);
> @@ -2433,6 +2437,7 @@ static int pkt_close(struct gendisk *disk, fmode_t mode)
>  		pkt_release_dev(pd, flush);
>  	}
>  	mutex_unlock(&ctl_mutex);
> +	unlock_kernel();
>  	return ret;
>  }

Improved "goto" errorhandling would be nicer.
Is smp_lock.h included by other files?

Replacement patch (not build tested...):

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 8a549db..30d585d 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -59,6 +59,8 @@
 #include <linux/freezer.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
+
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi.h>
@@ -2382,11 +2384,12 @@ static int pkt_open(struct block_device *bdev, fmode_t mode)
 
 	VPRINTK(DRIVER_NAME": entering open\n");
 
+	lock_kernel();
 	mutex_lock(&ctl_mutex);
 	pd = pkt_find_dev_from_minor(MINOR(bdev->bd_dev));
 	if (!pd) {
 		ret = -ENODEV;
-		goto out;
+		goto out_fail;
 	}
 	BUG_ON(pd->refcnt < 0);
 
@@ -2408,14 +2411,16 @@ static int pkt_open(struct block_device *bdev, fmode_t mode)
 		set_blocksize(bdev, CD_FRAMESIZE);
 	}
 
-	mutex_unlock(&ctl_mutex);
-	return 0;
+	ret = 0;
+	goto out;
 
 out_dec:
 	pd->refcnt--;
-out:
+out_fail:
 	VPRINTK(DRIVER_NAME": failed open (%d)\n", ret);
+out:
 	mutex_unlock(&ctl_mutex);
+	unlock_kernel();
 	return ret;
 }
 
Lot's of other places could benefit from improved goto error handling.
The driver maintainers should do this (if there is a maintainer).
I stopped with the small replacement patches.

I did not find anything else going through this patch.

	Sam
