From: Luis Henriques <luis.henriques@canonical.com>
Subject: Re: Kernel crashing on eject SD card
Date: Thu, 1 Mar 2012 18:58:17 +0000
Message-ID: <20120301185817.GA16253@zeus>
References: <1328660390.4f31bfa6e8f4b@www.imp.polymtl.ca>
 <20120212220836.6aa7fa4d@stein>
 <20120212222027.71651e8b@stein>
 <20120213021813.GA589@redhat.com>
 <1329154831.4f394b0f3c69c@www.imp.polymtl.ca>
 <4F3A4220.4010901@ce.jp.nec.com>
 <20120214162858.GM12117@google.com>
 <4F3B1ED3.4000706@ce.jp.nec.com>
 <20120215172617.GB24986@google.com>
 <4F3C5B4E.3080606@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F3C5B4E.3080606@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Tejun Heo <tj@kernel.org>, Naveen Goswamy <naveen.goswamy@polymtl.ca>, Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On Thu, Feb 16, 2012 at 10:26:38AM +0900, Jun'ichi Nomura wrote:
> Hi,
> 
> Thank you for review and comments.
> 
> On 02/16/12 02:26, Tejun Heo wrote:
> > On Wed, Feb 15, 2012 at 11:56:19AM +0900, Jun'ichi Nomura wrote:
> >> +int invalidate_partitions(struct gendisk *disk, struct block_device *bdev)
> >> +{
> >> +	int res;
> >> +
> >> +	res = drop_partitions(disk, bdev);
> >> +	if (res)
> >> +		return res;
> >> +
> > 
> > Hmmm... shouldn't we have set_capacity(disk, 0) here?
> 
> Added.
> I wasn't sure whether I should leave it to drivers.
> But it seems capacity 0 for ENOMEDIUM device is reasonable.
> 
> >> +	check_disk_size_change(disk, bdev);
> >> +	bdev->bd_invalidated = 0;
> >> +	/* tell userspace that the media / partition table may have changed */
> >> +	kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
> > 
> > Also, we really shouldn't be generating KOBJ_CHANGE after every
> > -ENOMEDIUM open.  This can easily lead to infinite loop.  We should
> > generate this iff we actually dropped partitions && modified the size.
> 
> invalidate_partitions() is called only when bd_invalidated is set.
> So KOBJ_CHANGE is not raised for every ENOMEDIUM open.
> 
> I put it explicit in the function to make it safer for
> possible misuse.
> 
> How about this?

Are there any updates on this fix?  I was wondering if any progress has been
made and if this patch has any chances of hitting mainline soon.

I have executed a quick test and it seems to solve the problem (or, at least, I
am not able to reproduce the oops anymore).

Cheers,
-- 
Luis

> ---------------------------------------------------------
> Do not call drivers when invalidating partitions for -ENOMEDIUM
> 
> When a scsi driver returns -ENOMEDIUM for open(),
> __blkdev_get() calls rescan_partitions(), which ends up calling
> sd_revalidate_disk() without getting a refcount of scsi_device.
> 
> That could lead to oops like this:
> 
>   process A                  process B
>   ----------------------------------------------
>   sys_open
>     __blkdev_get
>       sd_open
>         returns -ENOMEDIUM
>                              scsi_remove_device
>                                <scsi_device torn down>
>       rescan_partitions
>         sd_revalidate_disk
>           <oops>
> 
> Oopses are reported here:
> http://marc.info/?l=linux-scsi&m=132388619710052
> 
> This patch separates the partition invalidation from rescan_partitions()
> and use it for -ENOMEDIUM case. 
> 
> Index: linux-3.3/block/partition-generic.c
> ===================================================================
> --- linux-3.3.orig/block/partition-generic.c	2012-02-15 09:00:25.147293790 +0900
> +++ linux-3.3/block/partition-generic.c	2012-02-16 10:48:22.257680685 +0900
> @@ -389,17 +389,11 @@ static bool disk_unlock_native_capacity(
>  	}
>  }
>  
> -int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
> +static int drop_partitions(struct gendisk *disk, struct block_device *bdev)
>  {
> -	struct parsed_partitions *state = NULL;
>  	struct disk_part_iter piter;
>  	struct hd_struct *part;
> -	int p, highest, res;
> -rescan:
> -	if (state && !IS_ERR(state)) {
> -		kfree(state);
> -		state = NULL;
> -	}
> +	int res;
>  
>  	if (bdev->bd_part_count)
>  		return -EBUSY;
> @@ -412,6 +406,24 @@ rescan:
>  		delete_partition(disk, part->partno);
>  	disk_part_iter_exit(&piter);
>  
> +	return 0;
> +}
> +
> +int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
> +{
> +	struct parsed_partitions *state = NULL;
> +	struct hd_struct *part;
> +	int p, highest, res;
> +rescan:
> +	if (state && !IS_ERR(state)) {
> +		kfree(state);
> +		state = NULL;
> +	}
> +
> +	res = drop_partitions(disk, bdev);
> +	if (res)
> +		return res;
> +
>  	if (disk->fops->revalidate_disk)
>  		disk->fops->revalidate_disk(disk);
>  	check_disk_size_change(disk, bdev);
> @@ -515,6 +527,26 @@ rescan:
>  	return 0;
>  }
>  
> +int invalidate_partitions(struct gendisk *disk, struct block_device *bdev)
> +{
> +	int res;
> +
> +	if (!bdev->bd_invalidated)
> +		return 0;
> +
> +	res = drop_partitions(disk, bdev);
> +	if (res)
> +		return res;
> +
> +	set_capacity(disk, 0);
> +	check_disk_size_change(disk, bdev);
> +	bdev->bd_invalidated = 0;
> +	/* tell userspace that the media / partition table may have changed */
> +	kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
> +
> +	return 0;
> +}
> +
>  unsigned char *read_dev_sector(struct block_device *bdev, sector_t n, Sector *p)
>  {
>  	struct address_space *mapping = bdev->bd_inode->i_mapping;
> Index: linux-3.3/include/linux/genhd.h
> ===================================================================
> --- linux-3.3.orig/include/linux/genhd.h	2012-02-09 12:21:53.000000000 +0900
> +++ linux-3.3/include/linux/genhd.h	2012-02-16 10:47:43.783681813 +0900
> @@ -596,6 +596,7 @@ extern char *disk_name (struct gendisk *
>  
>  extern int disk_expand_part_tbl(struct gendisk *disk, int target);
>  extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
> +extern int invalidate_partitions(struct gendisk *disk, struct block_device *bdev);
>  extern struct hd_struct * __must_check add_partition(struct gendisk *disk,
>  						     int partno, sector_t start,
>  						     sector_t len, int flags,
> Index: linux-3.3/fs/block_dev.c
> ===================================================================
> --- linux-3.3.orig/fs/block_dev.c	2012-02-09 12:21:53.000000000 +0900
> +++ linux-3.3/fs/block_dev.c	2012-02-16 10:47:52.602681441 +0900
> @@ -1183,8 +1183,12 @@ static int __blkdev_get(struct block_dev
>  			 * The latter is necessary to prevent ghost
>  			 * partitions on a removed medium.
>  			 */
> -			if (bdev->bd_invalidated && (!ret || ret == -ENOMEDIUM))
> -				rescan_partitions(disk, bdev);
> +			if (bdev->bd_invalidated) {
> +				if (!ret)
> +					rescan_partitions(disk, bdev);
> +				else if (ret == -ENOMEDIUM)
> +					invalidate_partitions(disk, bdev);
> +			}
>  			if (ret)
>  				goto out_clear;
>  		} else {
> @@ -1214,8 +1218,12 @@ static int __blkdev_get(struct block_dev
>  			if (bdev->bd_disk->fops->open)
>  				ret = bdev->bd_disk->fops->open(bdev, mode);
>  			/* the same as first opener case, read comment there */
> -			if (bdev->bd_invalidated && (!ret || ret == -ENOMEDIUM))
> -				rescan_partitions(bdev->bd_disk, bdev);
> +			if (bdev->bd_invalidated) {
> +				if (!ret)
> +					rescan_partitions(bdev->bd_disk, bdev);
> +				else if (ret == -ENOMEDIUM)
> +					invalidate_partitions(bdev->bd_disk, bdev);
> +			}
>  			if (ret)
>  				goto out_unlock_bdev;
>  		}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
