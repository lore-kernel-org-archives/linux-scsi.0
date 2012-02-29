From: Naveen Goswamy <naveen.goswamy@polymtl.ca>
Subject: Re: [PATCH] Fix NULL pointer dereference in sd_revalidate_disk
Date: Wed, 29 Feb 2012 13:46:43 -0500
Message-ID: <1330541203.4f4e7293d1477@www.imp.polymtl.ca>
References: <4F443E81.2060402@ce.jp.nec.com> <20120222010435.GI12236@google.com> <95E22EAF20104309BF3938E7820F36D6@usish.com.cn> <20120222053651.GA7891@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120222053651.GA7891@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: 'Dave Jones' <davej@redhat.com>
Cc: Jack Wang <jack_wang@usish.com>, 'Tejun Heo' <tj@kernel.org>, 'Jun'ichi Nomura' <j-nomura@ce.jp.nec.com>, 'Jens Axboe' <axboe@kernel.dk>, linux-kernel@vger.kernel.org, 'linux-scsi' <linux-scsi@vger.kernel.org>, 'James Bottomley' <James.Bottomley@HansenPartnership.com>, 'Stefan Richter' <stefanr@s5r6.in-berlin.de>, sgruszka@redhat.com, 'Huajun Li' <huajun.li.lee@gmail.com>
List-Id: linux-scsi@vger.kernel.org

I have tested Dave Jones' 3.2 backport patch in gentoo, against kernel sources
3.2.1-gentoo-r2 and it works as well.

Regards,

Naveen





Quoting 'Dave Jones' <davej@redhat.com>:

> On Wed, Feb 22, 2012 at 12:58:08PM +0800, Jack Wang wrote:
>  > Should this need pick up into stable too?
>  >
>  > Jack
>
> The 3.2 backport seems fairly trivial (just some stuff moved to different
> files)
> Here's the patch I did for Fedora.
>
> 	Dave
>
> --- linux/fs/partitions/check.c~	2012-02-20 18:32:55.314253719 -0500
> +++ linux/fs/partitions/check.c	2012-02-20 18:34:46.509859745 -0500
> @@ -539,17 +539,11 @@ static bool disk_unlock_native_capacity(
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
> @@ -562,6 +556,24 @@ rescan:
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
> @@ -665,6 +677,26 @@ rescan:
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
>  unsigned char *read_dev_sector(struct block_device *bdev, sector_t n, Sector
> *p)
>  {
>  	struct address_space *mapping = bdev->bd_inode->i_mapping;
> --- linux/include/linux/genhd.h~	2012-02-20 18:35:02.777802107 -0500
> +++ linux/include/linux/genhd.h	2012-02-20 18:35:13.873762792 -0500
> @@ -596,6 +596,7 @@ extern char *disk_name (struct gendisk *
>
>  extern int disk_expand_part_tbl(struct gendisk *disk, int target);
>  extern int rescan_partitions(struct gendisk *disk, struct block_device
> *bdev);
> +extern int invalidate_partitions(struct gendisk *disk, struct block_device
> *bdev);
>  extern struct hd_struct * __must_check add_partition(struct gendisk *disk,
>  						     int partno, sector_t start,
>  						     sector_t len, int flags,
> --- linux/fs/block_dev.c~	2012-02-20 18:35:24.890723757 -0500
> +++ linux/fs/block_dev.c	2012-02-20 18:36:25.166510197 -0500
> @@ -1159,8 +1159,12 @@ static int __blkdev_get(struct block_dev
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
> @@ -1190,8 +1194,12 @@ static int __blkdev_get(struct block_dev
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
>
