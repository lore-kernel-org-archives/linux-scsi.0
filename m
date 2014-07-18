From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1/15] block copy: initial XCOPY offload support
Date: Fri, 18 Jul 2014 15:03:26 +0200
Message-ID: <53C91B1E.7060703@redhat.com>
References: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1407151534180.14632@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170AbaGRND7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2014 09:03:59 -0400
In-Reply-To: <alpine.LRH.2.02.1407151534180.14632@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 07/15/2014 09:34 PM, Mikulas Patocka wrote:
> This is Martin Petersen's xcopy patch
> (https://git.kernel.org/cgit/linux/kernel/git/mkp/linux.git/commit/?h=xcopy&id=0bdeed274e16b3038a851552188512071974eea8)
> with some bug fixes, ported to the current kernel.
>
> This patch makes it possible to use the SCSI XCOPY command.
>
> We create a bio that has REQ_COPY flag in bi_rw and a bi_copy structure
> that defines the source device. The target device is defined in the
> bi_bdev and bi_iter.bi_sector.
>
> There is a new BLKCOPY ioctl that makes it possible to use XCOPY from
> userspace. The ioctl argument is a pointer to an array of four uint64_t
> values.
>
> The first value is a source byte offset, the second value is a destination
> byte offset, the third value is byte length. The forth value is written by
> the kernel and it represents the number of bytes that the kernel actually
> copied.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> ---
>  Documentation/ABI/testing/sysfs-block |    9 +
>  block/bio.c                           |    2 
>  block/blk-core.c                      |    5 
>  block/blk-lib.c                       |   95 ++++++++++++
>  block/blk-merge.c                     |    7 
>  block/blk-settings.c                  |   13 +
>  block/blk-sysfs.c                     |   10 +
>  block/compat_ioctl.c                  |    1 
>  block/ioctl.c                         |   49 ++++++
>  drivers/scsi/scsi.c                   |   57 +++++++
>  drivers/scsi/sd.c                     |  263 +++++++++++++++++++++++++++++++++-
>  drivers/scsi/sd.h                     |    4 
>  include/linux/bio.h                   |    9 -
>  include/linux/blk_types.h             |   15 +
>  include/linux/blkdev.h                |   15 +
>  include/scsi/scsi_device.h            |    3 
>  include/uapi/linux/fs.h               |    1 
>  17 files changed, 545 insertions(+), 13 deletions(-)
>
> Index: linux-3.16-rc5/Documentation/ABI/testing/sysfs-block
> ===================================================================
> --- linux-3.16-rc5.orig/Documentation/ABI/testing/sysfs-block	2014-07-14 15:17:07.000000000 +0200
> +++ linux-3.16-rc5/Documentation/ABI/testing/sysfs-block	2014-07-14 16:26:44.000000000 +0200
> @@ -220,3 +220,12 @@ Description:
>  		write_same_max_bytes is 0, write same is not supported
>  		by the device.
>  
> +
> +What:		/sys/block/<disk>/queue/copy_max_bytes
> +Date:		January 2014
> +Contact:	Martin K. Petersen <martin.petersen@oracle.com>
> +Description:
> +		Devices that support copy offloading will set this value
> +		to indicate the maximum buffer size in bytes that can be
> +		copied in one operation. If the copy_max_bytes is 0 the
> +		device does not support copy offload.
> Index: linux-3.16-rc5/block/blk-core.c
> ===================================================================
> --- linux-3.16-rc5.orig/block/blk-core.c	2014-07-14 16:26:22.000000000 +0200
> +++ linux-3.16-rc5/block/blk-core.c	2014-07-14 16:26:44.000000000 +0200
> @@ -1831,6 +1831,11 @@ generic_make_request_checks(struct bio *
>  		goto end_io;
>  	}
>  
> +	if (bio->bi_rw & REQ_COPY && !bdev_copy_offload(bio->bi_bdev)) {
> +		err = -EOPNOTSUPP;
> +		goto end_io;
> +	}
> +
>  	/*
>  	 * Various block parts want %current->io_context and lazy ioc
>  	 * allocation ends up trading a lot of pain for a small amount of
> Index: linux-3.16-rc5/block/blk-lib.c
> ===================================================================
> --- linux-3.16-rc5.orig/block/blk-lib.c	2014-07-14 16:26:40.000000000 +0200
> +++ linux-3.16-rc5/block/blk-lib.c	2014-07-14 16:32:21.000000000 +0200
> @@ -304,3 +304,98 @@ int blkdev_issue_zeroout(struct block_de
>  	return __blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask);
>  }
>  EXPORT_SYMBOL(blkdev_issue_zeroout);
> +
> +/**
> + * blkdev_issue_copy - queue a copy same operation
> + * @src_bdev:	source blockdev
> + * @src_sector:	source sector
> + * @dst_bdev:	destination blockdev
> + * @dst_sector: destination sector
> + * @nr_sects:	number of sectors to copy
> + * @gfp_mask:	memory allocation flags (for bio_alloc)
> + *
> + * Description:
> + *    Copy a block range from source device to target device.
> + */
> +int blkdev_issue_copy(struct block_device *src_bdev, sector_t src_sector,
> +		      struct block_device *dst_bdev, sector_t dst_sector,
> +		      unsigned int nr_sects, gfp_t gfp_mask)
> +{
> +	DECLARE_COMPLETION_ONSTACK(wait);
> +	struct request_queue *sq = bdev_get_queue(src_bdev);
> +	struct request_queue *dq = bdev_get_queue(dst_bdev);
> +	unsigned int max_copy_sectors;
> +	struct bio_batch bb;
> +	int ret = 0;
> +
> +	if (!sq || !dq)
> +		return -ENXIO;
> +
> +	max_copy_sectors = min(sq->limits.max_copy_sectors,
> +			       dq->limits.max_copy_sectors);
> +
> +	if (max_copy_sectors == 0)
> +		return -EOPNOTSUPP;
> +
> +	if (src_sector + nr_sects < src_sector ||
> +	    dst_sector + nr_sects < dst_sector)
> +		return -EINVAL;

Hi Mikulas,
this^ is meant as an overflow test or what is the reason?
Thanks, Tomas

> +
> +	/* Do not support overlapping copies */
> +	if (src_bdev == dst_bdev &&
> +	    abs64((u64)dst_sector - (u64)src_sector) < nr_sects)
> +		return -EOPNOTSUPP;
> +
> +	atomic_set(&bb.done, 1);
> +	bb.error = 0;
> +	bb.wait = &wait;
> +
> +	while (nr_sects) {
> +		struct bio *bio;
> +		struct bio_copy *bc;
> +		unsigned int chunk;
> +
> +		bc = kmalloc(sizeof(struct bio_copy), gfp_mask);
> +		if (!bc) {
> +			ret = -ENOMEM;
> +			break;
> +		}
> +
> +		bio = bio_alloc(gfp_mask, 1);
> +		if (!bio) {
> +			kfree(bc);
> +			ret = -ENOMEM;
> +			break;
> +		}
> +
> +		chunk = min(nr_sects, max_copy_sectors);
> +
> +		bio->bi_iter.bi_sector = dst_sector;
> +		bio->bi_iter.bi_size = chunk << 9;
> +		bio->bi_end_io = bio_batch_end_io;
> +		bio->bi_bdev = dst_bdev;
> +		bio->bi_private = &bb;
> +		bio->bi_copy = bc;
> +
> +		bc->bic_bdev = src_bdev;
> +		bc->bic_sector = src_sector;
> +
> +		atomic_inc(&bb.done);
> +		submit_bio(REQ_WRITE | REQ_COPY, bio);
> +
> +		src_sector += chunk;
> +		dst_sector += chunk;
> +		nr_sects -= chunk;
> +	}
> +
> +	/* Wait for bios in-flight */
> +	if (!atomic_dec_and_test(&bb.done))
> +		wait_for_completion_io(&wait);
> +
> +	if (likely(!ret))
> +		ret = bb.error;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(blkdev_issue_copy);
> +
> Index: linux-3.16-rc5/block/blk-merge.c
> ===================================================================
> --- linux-3.16-rc5.orig/block/blk-merge.c	2014-07-14 15:17:07.000000000 +0200
> +++ linux-3.16-rc5/block/blk-merge.c	2014-07-14 16:26:44.000000000 +0200
> @@ -25,10 +25,7 @@ static unsigned int __blk_recalc_rq_segm
>  	 * This should probably be returning 0, but blk_add_request_payload()
>  	 * (Christoph!!!!)
>  	 */
> -	if (bio->bi_rw & REQ_DISCARD)
> -		return 1;
> -
> -	if (bio->bi_rw & REQ_WRITE_SAME)
> +	if (bio->bi_rw & (REQ_DISCARD | REQ_WRITE_SAME | REQ_COPY))
>  		return 1;
>  
>  	fbio = bio;
> @@ -196,7 +193,7 @@ static int __blk_bios_map_sg(struct requ
>  	nsegs = 0;
>  	cluster = blk_queue_cluster(q);
>  
> -	if (bio->bi_rw & REQ_DISCARD) {
> +	if (bio->bi_rw & (REQ_DISCARD | REQ_COPY)) {
>  		/*
>  		 * This is a hack - drivers should be neither modifying the
>  		 * biovec, nor relying on bi_vcnt - but because of
> Index: linux-3.16-rc5/block/blk-settings.c
> ===================================================================
> --- linux-3.16-rc5.orig/block/blk-settings.c	2014-07-14 15:17:08.000000000 +0200
> +++ linux-3.16-rc5/block/blk-settings.c	2014-07-14 16:26:44.000000000 +0200
> @@ -115,6 +115,7 @@ void blk_set_default_limits(struct queue
>  	lim->max_sectors = lim->max_hw_sectors = BLK_SAFE_MAX_SECTORS;
>  	lim->chunk_sectors = 0;
>  	lim->max_write_same_sectors = 0;
> +	lim->max_copy_sectors = 0;
>  	lim->max_discard_sectors = 0;
>  	lim->discard_granularity = 0;
>  	lim->discard_alignment = 0;
> @@ -322,6 +323,18 @@ void blk_queue_max_write_same_sectors(st
>  EXPORT_SYMBOL(blk_queue_max_write_same_sectors);
>  
>  /**
> + * blk_queue_max_copy_sectors - set max sectors for a single copy operation
> + * @q:  the request queue for the device
> + * @max_copy_sectors: maximum number of sectors per copy operation
> + **/
> +void blk_queue_max_copy_sectors(struct request_queue *q,
> +				unsigned int max_copy_sectors)
> +{
> +	q->limits.max_copy_sectors = max_copy_sectors;
> +}
> +EXPORT_SYMBOL(blk_queue_max_copy_sectors);
> +
> +/**
>   * blk_queue_max_segments - set max hw segments for a request for this queue
>   * @q:  the request queue for the device
>   * @max_segments:  max number of segments
> Index: linux-3.16-rc5/block/blk-sysfs.c
> ===================================================================
> --- linux-3.16-rc5.orig/block/blk-sysfs.c	2014-07-14 15:17:08.000000000 +0200
> +++ linux-3.16-rc5/block/blk-sysfs.c	2014-07-14 16:26:44.000000000 +0200
> @@ -161,6 +161,11 @@ static ssize_t queue_write_same_max_show
>  		(unsigned long long)q->limits.max_write_same_sectors << 9);
>  }
>  
> +static ssize_t queue_copy_max_show(struct request_queue *q, char *page)
> +{
> +	return sprintf(page, "%llu\n",
> +		(unsigned long long)q->limits.max_copy_sectors << 9);
> +}
>  
>  static ssize_t
>  queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
> @@ -374,6 +379,10 @@ static struct queue_sysfs_entry queue_wr
>  	.show = queue_write_same_max_show,
>  };
>  
> +static struct queue_sysfs_entry queue_copy_max_entry = {
> +	.attr = {.name = "copy_max_bytes", .mode = S_IRUGO },
> +	.show = queue_copy_max_show,
> +};
>  static struct queue_sysfs_entry queue_nonrot_entry = {
>  	.attr = {.name = "rotational", .mode = S_IRUGO | S_IWUSR },
>  	.show = queue_show_nonrot,
> @@ -422,6 +431,7 @@ static struct attribute *default_attrs[]
>  	&queue_discard_max_entry.attr,
>  	&queue_discard_zeroes_data_entry.attr,
>  	&queue_write_same_max_entry.attr,
> +	&queue_copy_max_entry.attr,
>  	&queue_nonrot_entry.attr,
>  	&queue_nomerges_entry.attr,
>  	&queue_rq_affinity_entry.attr,
> Index: linux-3.16-rc5/block/ioctl.c
> ===================================================================
> --- linux-3.16-rc5.orig/block/ioctl.c	2014-07-14 15:17:08.000000000 +0200
> +++ linux-3.16-rc5/block/ioctl.c	2014-07-14 16:26:44.000000000 +0200
> @@ -201,6 +201,31 @@ static int blk_ioctl_zeroout(struct bloc
>  	return blkdev_issue_zeroout(bdev, start, len, GFP_KERNEL);
>  }
>  
> +static int blk_ioctl_copy(struct block_device *bdev, uint64_t src_offset,
> +			  uint64_t dst_offset, uint64_t len)
> +{
> +	if (src_offset & 511)
> +		return -EINVAL;
> +	if (dst_offset & 511)
> +		return -EINVAL;
> +	if (len & 511)
> +		return -EINVAL;
> +	src_offset >>= 9;
> +	dst_offset >>= 9;
> +	len >>= 9;
> +
> +	if (unlikely(src_offset + len < src_offset) ||
> +	    unlikely(src_offset + len > (i_size_read(bdev->bd_inode) >> 9)))
> +		return -EINVAL;
> +
> +	if (unlikely(dst_offset + len < dst_offset) ||
> +	    unlikely(dst_offset + len > (i_size_read(bdev->bd_inode) >> 9)))
> +		return -EINVAL;
> +
> +	return blkdev_issue_copy(bdev, src_offset, bdev, dst_offset, len,
> +				 GFP_KERNEL);
> +}
> +
>  static int put_ushort(unsigned long arg, unsigned short val)
>  {
>  	return put_user(val, (unsigned short __user *)arg);
> @@ -328,6 +353,30 @@ int blkdev_ioctl(struct block_device *bd
>  		return blk_ioctl_zeroout(bdev, range[0], range[1]);
>  	}
>  
> +	case BLKCOPY: {
> +		uint64_t range[4];
> +
> +		range[3] = 0;
> +
> +		if (copy_to_user((void __user *)(arg + 24), &range[3], 8))
> +			return -EFAULT;
> +
> +		if (!(mode & FMODE_WRITE))
> +			return -EBADF;
> +
> +		if (copy_from_user(range, (void __user *)arg, 24))
> +			return -EFAULT;
> +
> +		ret = blk_ioctl_copy(bdev, range[0], range[1], range[2]);
> +		if (!ret) {
> +			range[3] = range[2];
> +			if (copy_to_user((void __user *)(arg + 24), &range[3], 8))
> +				return -EFAULT;
> +		}
> +
> +		return ret;
> +	}
> +
>  	case HDIO_GETGEO: {
>  		struct hd_geometry geo;
>  
> Index: linux-3.16-rc5/drivers/scsi/scsi.c
> ===================================================================
> --- linux-3.16-rc5.orig/drivers/scsi/scsi.c	2014-07-14 15:17:08.000000000 +0200
> +++ linux-3.16-rc5/drivers/scsi/scsi.c	2014-07-14 16:26:44.000000000 +0200
> @@ -1024,6 +1024,62 @@ int scsi_get_vpd_page(struct scsi_device
>  EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
>  
>  /**
> + * scsi_lookup_naa - Lookup NAA descriptor in VPD page 0x83
> + * @sdev: The device to ask
> + *
> + * Copy offloading requires us to know the NAA descriptor for both
> + * source and target device. This descriptor is mandatory in the Device
> + * Identification VPD page. Locate this descriptor in the returned VPD
> + * data so we don't have to do lookups for every copy command.
> + */
> +static void scsi_lookup_naa(struct scsi_device *sdev)
> +{
> +	unsigned char *buf = sdev->vpd_pg83;
> +	unsigned int len = sdev->vpd_pg83_len;
> +
> +	if (buf[1] != 0x83 || get_unaligned_be16(&buf[2]) == 0) {
> +		sdev_printk(KERN_ERR, sdev,
> +			    "%s: VPD page 0x83 contains no descriptors\n",
> +			    __func__);
> +		return;
> +	}
> +
> +	buf += 4;
> +	len -= 4;
> +
> +	do {
> +		unsigned int desig_len = buf[3] + 4;
> +
> +		/* Binary code set */
> +		if ((buf[0] & 0xf) != 1)
> +			goto skip;
> +
> +		/* Target association */
> +		if ((buf[1] >> 4) & 0x3)
> +			goto skip;
> +
> +		/* NAA designator */
> +		if ((buf[1] & 0xf) != 0x3)
> +			goto skip;
> +
> +		sdev->naa = buf;
> +		sdev->naa_len = desig_len;
> +
> +		return;
> +
> +	skip:
> +		buf += desig_len;
> +		len -= desig_len;
> +
> +	} while (len > 0);
> +
> +	sdev_printk(KERN_ERR, sdev,
> +		    "%s: VPD page 0x83 NAA descriptor not found\n", __func__);
> +
> +	return;
> +}
> +
> +/**
>   * scsi_attach_vpd - Attach Vital Product Data to a SCSI device structure
>   * @sdev: The device to ask
>   *
> @@ -1107,6 +1163,7 @@ retry_pg83:
>  		}
>  		sdev->vpd_pg83_len = result;
>  		sdev->vpd_pg83 = vpd_buf;
> +		scsi_lookup_naa(sdev);
>  	}
>  }
>  
> Index: linux-3.16-rc5/drivers/scsi/sd.c
> ===================================================================
> --- linux-3.16-rc5.orig/drivers/scsi/sd.c	2014-07-14 16:26:22.000000000 +0200
> +++ linux-3.16-rc5/drivers/scsi/sd.c	2014-07-14 16:26:44.000000000 +0200
> @@ -100,6 +100,7 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
>  
>  static void sd_config_discard(struct scsi_disk *, unsigned int);
>  static void sd_config_write_same(struct scsi_disk *);
> +static void sd_config_copy(struct scsi_disk *);
>  static int  sd_revalidate_disk(struct gendisk *);
>  static void sd_unlock_native_capacity(struct gendisk *disk);
>  static int  sd_probe(struct device *);
> @@ -463,6 +464,48 @@ max_write_same_blocks_store(struct devic
>  }
>  static DEVICE_ATTR_RW(max_write_same_blocks);
>  
> +static ssize_t
> +max_copy_blocks_show(struct device *dev, struct device_attribute *attr,
> +		     char *buf)
> +{
> +	struct scsi_disk *sdkp = to_scsi_disk(dev);
> +
> +	return snprintf(buf, 20, "%u\n", sdkp->max_copy_blocks);
> +}
> +
> +static ssize_t
> +max_copy_blocks_store(struct device *dev, struct device_attribute *attr,
> +		      const char *buf, size_t count)
> +{
> +	struct scsi_disk *sdkp = to_scsi_disk(dev);
> +	struct scsi_device *sdp = sdkp->device;
> +	unsigned long max;
> +	int err;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EACCES;
> +
> +	if (sdp->type != TYPE_DISK)
> +		return -EINVAL;
> +
> +	err = kstrtoul(buf, 10, &max);
> +
> +	if (err)
> +		return err;
> +
> +	if (max == 0)
> +		sdp->no_copy = 1;
> +	else if (max <= SD_MAX_COPY_BLOCKS) {
> +		sdp->no_copy = 0;
> +		sdkp->max_copy_blocks = max;
> +	}
> +
> +	sd_config_copy(sdkp);
> +
> +	return count;
> +}
> +static DEVICE_ATTR_RW(max_copy_blocks);
> +
>  static struct attribute *sd_disk_attrs[] = {
>  	&dev_attr_cache_type.attr,
>  	&dev_attr_FUA.attr,
> @@ -474,6 +517,7 @@ static struct attribute *sd_disk_attrs[]
>  	&dev_attr_thin_provisioning.attr,
>  	&dev_attr_provisioning_mode.attr,
>  	&dev_attr_max_write_same_blocks.attr,
> +	&dev_attr_max_copy_blocks.attr,
>  	&dev_attr_max_medium_access_timeouts.attr,
>  	NULL,
>  };
> @@ -830,6 +874,109 @@ static int sd_setup_write_same_cmnd(stru
>  	return ret;
>  }
>  
> +static void sd_config_copy(struct scsi_disk *sdkp)
> +{
> +	struct request_queue *q = sdkp->disk->queue;
> +	unsigned int logical_block_size = sdkp->device->sector_size;
> +
> +	if (sdkp->device->no_copy)
> +		sdkp->max_copy_blocks = 0;
> +
> +	/* Segment descriptor 0x02 has a 64k block limit */
> +	sdkp->max_copy_blocks = min(sdkp->max_copy_blocks,
> +				    (u32)SD_MAX_CSD2_BLOCKS);
> +
> +	blk_queue_max_copy_sectors(q, sdkp->max_copy_blocks *
> +				   (logical_block_size >> 9));
> +}
> +
> +static int sd_setup_copy_cmnd(struct scsi_device *sdp, struct request *rq)
> +{
> +	struct scsi_device *src_sdp, *dst_sdp;
> +	struct gendisk *src_disk;
> +	struct request_queue *src_queue, *dst_queue;
> +	sector_t src_lba, dst_lba;
> +	unsigned int nr_blocks, buf_len, nr_bytes = blk_rq_bytes(rq);
> +	int ret;
> +	struct bio *bio = rq->bio;
> +	struct page *page;
> +	unsigned char *buf;
> +
> +	if (!bio->bi_copy)
> +		return BLKPREP_KILL;
> +
> +	dst_sdp = scsi_disk(rq->rq_disk)->device;
> +	dst_queue = rq->rq_disk->queue;
> +	src_disk = bio->bi_copy->bic_bdev->bd_disk;
> +	src_queue = src_disk->queue;
> +	if (!src_queue ||
> +	    src_queue->make_request_fn != blk_queue_bio ||
> +	    src_queue->request_fn != dst_queue->request_fn ||
> +	    *(struct scsi_driver **)rq->rq_disk->private_data !=
> +	    *(struct scsi_driver **)src_disk->private_data)
> +		return BLKPREP_KILL;
> +	src_sdp = scsi_disk(src_disk)->device;
> +
> +	if (src_sdp->no_copy || dst_sdp->no_copy)
> +		return BLKPREP_KILL;
> +
> +	if (src_sdp->sector_size != dst_sdp->sector_size)
> +		return BLKPREP_KILL;
> +
> +	dst_lba = blk_rq_pos(rq) >> (ilog2(dst_sdp->sector_size) - 9);
> +	src_lba = bio->bi_copy->bic_sector >> (ilog2(src_sdp->sector_size) - 9);
> +	nr_blocks = blk_rq_sectors(rq) >> (ilog2(dst_sdp->sector_size) - 9);
> +
> +	page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
> +	if (!page)
> +		return BLKPREP_DEFER;
> +
> +	buf = page_address(page);
> +
> +	/* Extended Copy (LID1) Parameter List (16 bytes) */
> +	buf[0] = 0;				/* LID */
> +	buf[1] = 3 << 3;			/* LID usage 11b */
> +	put_unaligned_be16(32 + 32, &buf[2]);	/* 32 bytes per E4 desc. */
> +	put_unaligned_be32(28, &buf[8]);	/* 28 bytes per B2B desc. */
> +	buf += 16;
> +
> +	/* Source CSCD (32 bytes) */
> +	buf[0] = 0xe4;				/* Identification desc. */
> +	memcpy(&buf[4], src_sdp->naa, src_sdp->naa_len);
> +	buf += 32;
> +
> +	/* Destination CSCD (32 bytes) */
> +	buf[0] = 0xe4;				/* Identification desc. */
> +	memcpy(&buf[4], dst_sdp->naa, dst_sdp->naa_len);
> +	buf += 32;
> +
> +	/* Segment descriptor (28 bytes) */
> +	buf[0] = 0x02;				/* Block to block desc. */
> +	put_unaligned_be16(0x18, &buf[2]);	/* Descriptor length */
> +	put_unaligned_be16(0, &buf[4]);		/* Source is desc. 0 */
> +	put_unaligned_be16(1, &buf[6]);		/* Dest. is desc. 1 */
> +	put_unaligned_be16(nr_blocks, &buf[10]);
> +	put_unaligned_be64(src_lba, &buf[12]);
> +	put_unaligned_be64(dst_lba, &buf[20]);
> +
> +	/* CDB */
> +	memset(rq->cmd, 0, rq->cmd_len);
> +	rq->cmd[0] = EXTENDED_COPY;
> +	rq->cmd[1] = 0; /* LID1 */
> +	buf_len = 16 + 32 + 32 + 28;
> +	put_unaligned_be32(buf_len, &rq->cmd[10]);
> +	rq->timeout = SD_COPY_TIMEOUT;
> +
> +	rq->completion_data = page;
> +	blk_add_request_payload(rq, page, buf_len);
> +	ret = scsi_setup_blk_pc_cmnd(sdp, rq);
> +	rq->__data_len = nr_bytes;
> +
> +	if (ret != BLKPREP_OK)
> +		__free_page(page);
> +	return ret;
> +}
> +
>  static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
>  {
>  	rq->timeout *= SD_FLUSH_TIMEOUT_MULTIPLIER;
> @@ -844,7 +991,7 @@ static void sd_uninit_command(struct scs
>  {
>  	struct request *rq = SCpnt->request;
>  
> -	if (rq->cmd_flags & REQ_DISCARD)
> +	if (rq->cmd_flags & (REQ_DISCARD | REQ_COPY))
>  		__free_page(rq->completion_data);
>  
>  	if (SCpnt->cmnd != rq->cmd) {
> @@ -876,6 +1023,9 @@ static int sd_init_command(struct scsi_c
>  	} else if (rq->cmd_flags & REQ_WRITE_SAME) {
>  		ret = sd_setup_write_same_cmnd(sdp, rq);
>  		goto out;
> +	} else if (rq->cmd_flags & REQ_COPY) {
> +		ret = sd_setup_copy_cmnd(sdp, rq);
> +		goto out;
>  	} else if (rq->cmd_flags & REQ_FLUSH) {
>  		ret = scsi_setup_flush_cmnd(sdp, rq);
>  		goto out;
> @@ -1649,7 +1799,8 @@ static int sd_done(struct scsi_cmnd *SCp
>  	unsigned char op = SCpnt->cmnd[0];
>  	unsigned char unmap = SCpnt->cmnd[1] & 8;
>  
> -	if (req->cmd_flags & REQ_DISCARD || req->cmd_flags & REQ_WRITE_SAME) {
> +	if (req->cmd_flags & REQ_DISCARD || req->cmd_flags & REQ_WRITE_SAME ||
> +	    req->cmd_flags & REQ_COPY) {
>  		if (!result) {
>  			good_bytes = blk_rq_bytes(req);
>  			scsi_set_resid(SCpnt, 0);
> @@ -1708,6 +1859,14 @@ static int sd_done(struct scsi_cmnd *SCp
>  		/* INVALID COMMAND OPCODE or INVALID FIELD IN CDB */
>  		if (sshdr.asc == 0x20 || sshdr.asc == 0x24) {
>  			switch (op) {
> +			case EXTENDED_COPY:
> +				sdkp->device->no_copy = 1;
> +				sd_config_copy(sdkp);
> +
> +				good_bytes = 0;
> +				req->__data_len = blk_rq_bytes(req);
> +				req->cmd_flags |= REQ_QUIET;
> +				break;
>  			case UNMAP:
>  				sd_config_discard(sdkp, SD_LBP_DISABLE);
>  				break;
> @@ -2681,6 +2840,105 @@ static void sd_read_write_same(struct sc
>  		sdkp->ws10 = 1;
>  }
>  
> +static void sd_read_copy_operations(struct scsi_disk *sdkp,
> +				    unsigned char *buffer)
> +{
> +	struct scsi_device *sdev = sdkp->device;
> +	struct scsi_sense_hdr sshdr;
> +	unsigned char cdb[16];
> +	unsigned int result, len, i;
> +	bool b2b_desc = false, id_desc = false;
> +
> +	if (sdev->naa_len == 0)
> +		return;
> +
> +	/* Verify that the device has 3PC set in INQUIRY response */
> +	if (sdev->inquiry_len < 6 || (sdev->inquiry[5] & (1 << 3)) == 0)
> +		return;
> +
> +	/* Receive Copy Operation Parameters */
> +	memset(cdb, 0, 16);
> +	cdb[0] = RECEIVE_COPY_RESULTS;
> +	cdb[1] = 0x3;
> +	put_unaligned_be32(SD_BUF_SIZE, &cdb[10]);
> +
> +	memset(buffer, 0, SD_BUF_SIZE);
> +	result = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE,
> +				  buffer, SD_BUF_SIZE, &sshdr,
> +				  SD_TIMEOUT, SD_MAX_RETRIES, NULL);
> +
> +	if (!scsi_status_is_good(result)) {
> +		sd_printk(KERN_ERR, sdkp,
> +			  "%s: Receive Copy Operating Parameters failed\n",
> +			  __func__);
> +		return;
> +	}
> +
> +	/* The RCOP response is a minimum of 44 bytes long. First 4
> +	 * bytes contain the length of the remaining buffer, i.e. 40+
> +	 * bytes. Trailing the defined fields is a list of supported
> +	 * descriptors. We need at least 2 descriptors to drive the
> +	 * target, hence 42.
> +	 */
> +	len = get_unaligned_be32(&buffer[0]);
> +	if (len < 42) {
> +		sd_printk(KERN_ERR, sdkp, "%s: result too short (%u)\n",
> +			  __func__, len);
> +		return;
> +	}
> +
> +	if ((buffer[4] & 1) == 0) {
> +		sd_printk(KERN_ERR, sdkp, "%s: does not support SNLID\n",
> +			  __func__);
> +		return;
> +	}
> +
> +	if (get_unaligned_be16(&buffer[8]) < 2) {
> +		sd_printk(KERN_ERR, sdkp,
> +			  "%s: Need 2 or more CSCD descriptors\n", __func__);
> +		return;
> +	}
> +
> +	if (get_unaligned_be16(&buffer[10]) < 1) {
> +		sd_printk(KERN_ERR, sdkp,
> +			  "%s: Need 1 or more segment descriptor\n", __func__);
> +		return;
> +	}
> +
> +	if (len - 40 != buffer[43]) {
> +		sd_printk(KERN_ERR, sdkp,
> +			  "%s: Buffer len and descriptor count mismatch " \
> +			  "(%u vs. %u)\n", __func__, len - 40, buffer[43]);
> +		return;
> +	}
> +
> +	for (i = 44 ; i < len + 4 ; i++) {
> +		if (buffer[i] == 0x02)
> +			b2b_desc = true;
> +
> +		if (buffer[i] == 0xe4)
> +			id_desc = true;
> +	}
> +
> +	if (!b2b_desc) {
> +		sd_printk(KERN_ERR, sdkp,
> +			  "%s: No block 2 block descriptor (0x02)\n",
> +			  __func__);
> +		return;
> +	}
> +
> +	if (!id_desc) {
> +		sd_printk(KERN_ERR, sdkp,
> +			  "%s: No identification descriptor (0xE4)\n",
> +			  __func__);
> +		return;
> +	}
> +
> +	sdkp->max_copy_blocks = get_unaligned_be32(&buffer[16])
> +		>> ilog2(sdev->sector_size);
> +	sd_config_copy(sdkp);
> +}
> +
>  static int sd_try_extended_inquiry(struct scsi_device *sdp)
>  {
>  	/*
> @@ -2741,6 +2999,7 @@ static int sd_revalidate_disk(struct gen
>  		sd_read_cache_type(sdkp, buffer);
>  		sd_read_app_tag_own(sdkp, buffer);
>  		sd_read_write_same(sdkp, buffer);
> +		sd_read_copy_operations(sdkp, buffer);
>  	}
>  
>  	sdkp->first_scan = 0;
> Index: linux-3.16-rc5/drivers/scsi/sd.h
> ===================================================================
> --- linux-3.16-rc5.orig/drivers/scsi/sd.h	2014-07-14 15:17:08.000000000 +0200
> +++ linux-3.16-rc5/drivers/scsi/sd.h	2014-07-14 16:26:44.000000000 +0200
> @@ -19,6 +19,7 @@
>   */
>  #define SD_FLUSH_TIMEOUT_MULTIPLIER	2
>  #define SD_WRITE_SAME_TIMEOUT	(120 * HZ)
> +#define SD_COPY_TIMEOUT		(120 * HZ)
>  
>  /*
>   * Number of allowed retries
> @@ -46,6 +47,8 @@ enum {
>  enum {
>  	SD_MAX_WS10_BLOCKS = 0xffff,
>  	SD_MAX_WS16_BLOCKS = 0x7fffff,
> +	SD_MAX_CSD2_BLOCKS = 0xffff,
> +	SD_MAX_COPY_BLOCKS = 0xffffffff,
>  };
>  
>  enum {
> @@ -66,6 +69,7 @@ struct scsi_disk {
>  	sector_t	capacity;	/* size in 512-byte sectors */
>  	u32		max_ws_blocks;
>  	u32		max_unmap_blocks;
> +	u32		max_copy_blocks;
>  	u32		unmap_granularity;
>  	u32		unmap_alignment;
>  	u32		index;
> Index: linux-3.16-rc5/include/linux/bio.h
> ===================================================================
> --- linux-3.16-rc5.orig/include/linux/bio.h	2014-07-14 15:17:09.000000000 +0200
> +++ linux-3.16-rc5/include/linux/bio.h	2014-07-14 16:26:44.000000000 +0200
> @@ -106,7 +106,7 @@ static inline bool bio_has_data(struct b
>  {
>  	if (bio &&
>  	    bio->bi_iter.bi_size &&
> -	    !(bio->bi_rw & REQ_DISCARD))
> +	    !(bio->bi_rw & (REQ_DISCARD | REQ_COPY)))
>  		return true;
>  
>  	return false;
> @@ -260,8 +260,8 @@ static inline unsigned bio_segments(stru
>  	struct bvec_iter iter;
>  
>  	/*
> -	 * We special case discard/write same, because they interpret bi_size
> -	 * differently:
> +	 * We special case discard/write same/copy, because they
> +	 * interpret bi_size differently:
>  	 */
>  
>  	if (bio->bi_rw & REQ_DISCARD)
> @@ -270,6 +270,9 @@ static inline unsigned bio_segments(stru
>  	if (bio->bi_rw & REQ_WRITE_SAME)
>  		return 1;
>  
> +	if (bio->bi_rw & REQ_COPY)
> +		return 1;
> +
>  	bio_for_each_segment(bv, bio, iter)
>  		segs++;
>  
> Index: linux-3.16-rc5/include/linux/blk_types.h
> ===================================================================
> --- linux-3.16-rc5.orig/include/linux/blk_types.h	2014-07-14 15:17:09.000000000 +0200
> +++ linux-3.16-rc5/include/linux/blk_types.h	2014-07-14 16:26:44.000000000 +0200
> @@ -39,6 +39,11 @@ struct bvec_iter {
>  						   current bvec */
>  };
>  
> +struct bio_copy {
> +	struct block_device	*bic_bdev;
> +	sector_t		bic_sector;
> +};
> +
>  /*
>   * main unit of I/O for the block layer and lower layers (ie drivers and
>   * stacking drivers)
> @@ -81,6 +86,7 @@ struct bio {
>  #if defined(CONFIG_BLK_DEV_INTEGRITY)
>  	struct bio_integrity_payload *bi_integrity;  /* data integrity */
>  #endif
> +	struct bio_copy		*bi_copy; 	/* TODO, use bi_integrity */
>  
>  	unsigned short		bi_vcnt;	/* how many bio_vec's */
>  
> @@ -160,6 +166,7 @@ enum rq_flag_bits {
>  	__REQ_DISCARD,		/* request to discard sectors */
>  	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
>  	__REQ_WRITE_SAME,	/* write same block many times */
> +	__REQ_COPY,		/* copy block range */
>  
>  	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
>  	__REQ_FUA,		/* forced unit access */
> @@ -203,6 +210,7 @@ enum rq_flag_bits {
>  #define REQ_PRIO		(1ULL << __REQ_PRIO)
>  #define REQ_DISCARD		(1ULL << __REQ_DISCARD)
>  #define REQ_WRITE_SAME		(1ULL << __REQ_WRITE_SAME)
> +#define REQ_COPY		(1ULL << __REQ_COPY)
>  #define REQ_NOIDLE		(1ULL << __REQ_NOIDLE)
>  
>  #define REQ_FAILFAST_MASK \
> @@ -210,14 +218,15 @@ enum rq_flag_bits {
>  #define REQ_COMMON_MASK \
>  	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_PRIO | \
>  	 REQ_DISCARD | REQ_WRITE_SAME | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | \
> -	 REQ_SECURE)
> +	 REQ_SECURE | REQ_COPY)
>  #define REQ_CLONE_MASK		REQ_COMMON_MASK
>  
> -#define BIO_NO_ADVANCE_ITER_MASK	(REQ_DISCARD|REQ_WRITE_SAME)
> +#define BIO_NO_ADVANCE_ITER_MASK	(REQ_DISCARD|REQ_WRITE_SAME|REQ_COPY)
>  
>  /* This mask is used for both bio and request merge checking */
>  #define REQ_NOMERGE_FLAGS \
> -	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA)
> +	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA | \
> +	 REQ_COPY)
>  
>  #define REQ_RAHEAD		(1ULL << __REQ_RAHEAD)
>  #define REQ_THROTTLED		(1ULL << __REQ_THROTTLED)
> Index: linux-3.16-rc5/include/linux/blkdev.h
> ===================================================================
> --- linux-3.16-rc5.orig/include/linux/blkdev.h	2014-07-14 16:26:22.000000000 +0200
> +++ linux-3.16-rc5/include/linux/blkdev.h	2014-07-14 16:26:44.000000000 +0200
> @@ -289,6 +289,7 @@ struct queue_limits {
>  	unsigned int		io_opt;
>  	unsigned int		max_discard_sectors;
>  	unsigned int		max_write_same_sectors;
> +	unsigned int		max_copy_sectors;
>  	unsigned int		discard_granularity;
>  	unsigned int		discard_alignment;
>  
> @@ -1012,6 +1013,8 @@ extern void blk_queue_max_discard_sector
>  		unsigned int max_discard_sectors);
>  extern void blk_queue_max_write_same_sectors(struct request_queue *q,
>  		unsigned int max_write_same_sectors);
> +extern void blk_queue_max_copy_sectors(struct request_queue *q,
> +		unsigned int max_copy_sectors);
>  extern void blk_queue_logical_block_size(struct request_queue *, unsigned short);
>  extern void blk_queue_physical_block_size(struct request_queue *, unsigned int);
>  extern void blk_queue_alignment_offset(struct request_queue *q,
> @@ -1168,6 +1171,8 @@ extern int blkdev_issue_discard(struct b
>  		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
>  extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
>  		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
> +extern int blkdev_issue_copy(struct block_device *, sector_t,
> +		struct block_device *, sector_t, unsigned int, gfp_t);
>  extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
>  			sector_t nr_sects, gfp_t gfp_mask);
>  static inline int sb_issue_discard(struct super_block *sb, sector_t block,
> @@ -1367,6 +1372,16 @@ static inline unsigned int bdev_write_sa
>  	return 0;
>  }
>  
> +static inline unsigned int bdev_copy_offload(struct block_device *bdev)
> +{
> +	struct request_queue *q = bdev_get_queue(bdev);
> +
> +	if (q)
> +		return q->limits.max_copy_sectors;
> +
> +	return 0;
> +}
> +
>  static inline int queue_dma_alignment(struct request_queue *q)
>  {
>  	return q ? q->dma_alignment : 511;
> Index: linux-3.16-rc5/include/scsi/scsi_device.h
> ===================================================================
> --- linux-3.16-rc5.orig/include/scsi/scsi_device.h	2014-07-14 15:17:09.000000000 +0200
> +++ linux-3.16-rc5/include/scsi/scsi_device.h	2014-07-14 16:26:44.000000000 +0200
> @@ -119,6 +119,8 @@ struct scsi_device {
>  	unsigned char *vpd_pg83;
>  	int vpd_pg80_len;
>  	unsigned char *vpd_pg80;
> +	unsigned char naa_len;
> +	unsigned char *naa;
>  	unsigned char current_tag;	/* current tag */
>  	struct scsi_target      *sdev_target;   /* used only for single_lun */
>  
> @@ -151,6 +153,7 @@ struct scsi_device {
>  	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
>  	unsigned no_report_opcodes:1;	/* no REPORT SUPPORTED OPERATION CODES */
>  	unsigned no_write_same:1;	/* no WRITE SAME command */
> +	unsigned no_copy:1;		/* no copy offload */
>  	unsigned use_16_for_rw:1; /* Use read/write(16) over read/write(10) */
>  	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
>  	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
> Index: linux-3.16-rc5/include/uapi/linux/fs.h
> ===================================================================
> --- linux-3.16-rc5.orig/include/uapi/linux/fs.h	2014-07-14 15:17:09.000000000 +0200
> +++ linux-3.16-rc5/include/uapi/linux/fs.h	2014-07-14 16:26:44.000000000 +0200
> @@ -149,6 +149,7 @@ struct inodes_stat_t {
>  #define BLKSECDISCARD _IO(0x12,125)
>  #define BLKROTATIONAL _IO(0x12,126)
>  #define BLKZEROOUT _IO(0x12,127)
> +#define BLKCOPY _IO(0x12,128)
>  
>  #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
>  #define FIBMAP	   _IO(0x00,1)	/* bmap access */
> Index: linux-3.16-rc5/block/compat_ioctl.c
> ===================================================================
> --- linux-3.16-rc5.orig/block/compat_ioctl.c	2014-07-14 16:26:38.000000000 +0200
> +++ linux-3.16-rc5/block/compat_ioctl.c	2014-07-14 16:26:44.000000000 +0200
> @@ -696,6 +696,7 @@ long compat_blkdev_ioctl(struct file *fi
>  	 * but we call blkdev_ioctl, which gets the lock for us
>  	 */
>  	case BLKRRPART:
> +	case BLKCOPY:
>  		return blkdev_ioctl(bdev, mode, cmd,
>  				(unsigned long)compat_ptr(arg));
>  	case BLKBSZSET_32:
> Index: linux-3.16-rc5/block/bio.c
> ===================================================================
> --- linux-3.16-rc5.orig/block/bio.c	2014-07-14 16:26:24.000000000 +0200
> +++ linux-3.16-rc5/block/bio.c	2014-07-14 16:26:44.000000000 +0200
> @@ -239,6 +239,8 @@ static void __bio_free(struct bio *bio)
>  {
>  	bio_disassociate_task(bio);
>  
> +	kfree(bio->bi_copy);
> +
>  	if (bio_integrity(bio))
>  		bio_integrity_free(bio);
>  }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

