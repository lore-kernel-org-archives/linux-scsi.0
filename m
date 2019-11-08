Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB98FC5DF60
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 07:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 870C12085B
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 07:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfKHHRV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:17:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:60390 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725886AbfKHHRV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Nov 2019 02:17:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 64464AF8E;
        Fri,  8 Nov 2019 07:17:18 +0000 (UTC)
Subject: Re: [PATCH 4/9] block: Remove partition support for zoned block
 devices
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
 <20191108015702.233102-5-damien.lemoal@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <160bfb8f-2793-af74-df2b-5f30ae9383db@suse.de>
Date:   Fri, 8 Nov 2019 08:17:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191108015702.233102-5-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/8/19 2:56 AM, Damien Le Moal wrote:
> No known partitioning tool supports zoned block devices, especially the
> host managed flavor with strong sequential write constraints.
> Furthermore, there are also no known user nor use cases for partitioned
> zoned block devices.
> 
> This patch removes partition device creation for zoned block devices,
> which allows simplifying the processing of zone commands for zoned
> block devices. A warning is added if a partition table is found on the
> device.
> 
> For report zones operations no zone sector information remapping is
> necessary anymore, simplifying the code. Of note is that remapping of
> zone reports for DM targets is still necessary as done by
> dm_remap_zone_report().
> 
> Similarly, remaping of a zone reset bio is not necessary anymore.
> Testing for the applicability of the zone reset all request also becomes
> simpler and only needs to check that the number of sectors of the
> requested zone range is equal to the disk capacity.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  block/blk-core.c          |  6 +---
>  block/blk-zoned.c         | 62 ++++++--------------------------
>  block/partition-generic.c | 74 +++++----------------------------------
>  drivers/md/dm.c           |  3 --
>  4 files changed, 21 insertions(+), 124 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 3306a3c5bed6..df6b70476187 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -851,11 +851,7 @@ static inline int blk_partition_remap(struct bio *bio)
>  	if (unlikely(bio_check_ro(bio, p)))
>  		goto out;
>  
> -	/*
> -	 * Zone management bios do not have a sector count but they do have
> -	 * a start sector filled out and need to be remapped.
> -	 */
> -	if (bio_sectors(bio) || op_is_zone_mgmt(bio_op(bio))) {
> +	if (bio_sectors(bio)) {
>  		if (bio_check_eod(bio, part_nr_sects_read(p)))
>  			goto out;
>  		bio->bi_iter.bi_sector += p->start_sect;
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index ea4e086ba00e..ae665e490858 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -93,32 +93,10 @@ unsigned int blkdev_nr_zones(struct block_device *bdev)
>  	if (!blk_queue_is_zoned(q))
>  		return 0;
>  
> -	return __blkdev_nr_zones(q, bdev->bd_part->nr_sects);
> +	return __blkdev_nr_zones(q, get_capacity(bdev->bd_disk));
>  }
>  EXPORT_SYMBOL_GPL(blkdev_nr_zones);
>  
> -/*
> - * Check that a zone report belongs to this partition, and if yes, fix its start
> - * sector and write pointer and return true. Return false otherwise.
> - */
> -static bool blkdev_report_zone(struct block_device *bdev, struct blk_zone *rep)
> -{
> -	sector_t offset = get_start_sect(bdev);
> -
> -	if (rep->start < offset)
> -		return false;
> -
> -	rep->start -= offset;
> -	if (rep->start + rep->len > bdev->bd_part->nr_sects)
> -		return false;
> -
> -	if (rep->type == BLK_ZONE_TYPE_CONVENTIONAL)
> -		rep->wp = rep->start + rep->len;
> -	else
> -		rep->wp -= offset;
> -	return true;
> -}
> -
>  /**
>   * blkdev_report_zones - Get zones information
>   * @bdev:	Target block device
> @@ -140,8 +118,7 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
>  {
>  	struct request_queue *q = bdev_get_queue(bdev);
>  	struct gendisk *disk = bdev->bd_disk;
> -	unsigned int i, nrz;
> -	int ret;
> +	sector_t capacity = get_capacity(disk);
>  
>  	if (!blk_queue_is_zoned(q))
>  		return -EOPNOTSUPP;
> @@ -154,27 +131,14 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
>  	if (WARN_ON_ONCE(!disk->fops->report_zones))
>  		return -EOPNOTSUPP;
>  
> -	if (!*nr_zones || sector >= bdev->bd_part->nr_sects) {
> +	if (!*nr_zones || sector >= capacity) {
>  		*nr_zones = 0;
>  		return 0;
>  	}
>  
> -	nrz = min(*nr_zones,
> -		  __blkdev_nr_zones(q, bdev->bd_part->nr_sects - sector));
> -	ret = disk->fops->report_zones(disk, get_start_sect(bdev) + sector,
> -				       zones, &nrz);
> -	if (ret)
> -		return ret;
> +	*nr_zones = min(*nr_zones, __blkdev_nr_zones(q, capacity - sector));
>  
> -	for (i = 0; i < nrz; i++) {
> -		if (!blkdev_report_zone(bdev, zones))
> -			break;
> -		zones++;
> -	}
> -
> -	*nr_zones = i;
> -
> -	return 0;
> +	return disk->fops->report_zones(disk, sector, zones, nr_zones);
>  }
>  EXPORT_SYMBOL_GPL(blkdev_report_zones);
>  
> @@ -185,15 +149,11 @@ static inline bool blkdev_allow_reset_all_zones(struct block_device *bdev,
>  	if (!blk_queue_zone_resetall(bdev_get_queue(bdev)))
>  		return false;
>  
> -	if (sector || nr_sectors != part_nr_sects_read(bdev->bd_part))
> -		return false;
>  	/*
> -	 * REQ_OP_ZONE_RESET_ALL can be executed only if the block device is
> -	 * the entire disk, that is, if the blocks device start offset is 0 and
> -	 * its capacity is the same as the entire disk.
> +	 * REQ_OP_ZONE_RESET_ALL can be executed only if the number of sectors
> +	 * of the applicable zone range is the entire disk.
>  	 */
> -	return get_start_sect(bdev) == 0 &&
> -	       part_nr_sects_read(bdev->bd_part) == get_capacity(bdev->bd_disk);
> +	return !sector && nr_sectors == get_capacity(bdev->bd_disk);
>  }
>  
>  /**
> @@ -218,6 +178,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>  {
>  	struct request_queue *q = bdev_get_queue(bdev);
>  	sector_t zone_sectors = blk_queue_zone_sectors(q);
> +	sector_t capacity = get_capacity(bdev->bd_disk);
>  	sector_t end_sector = sector + nr_sectors;
>  	struct bio *bio = NULL;
>  	int ret;
> @@ -231,7 +192,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>  	if (!op_is_zone_mgmt(op))
>  		return -EOPNOTSUPP;
>  
> -	if (!nr_sectors || end_sector > bdev->bd_part->nr_sects)
> +	if (!nr_sectors || end_sector > capacity)
>  		/* Out of range */
>  		return -EINVAL;
>  
> @@ -239,8 +200,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>  	if (sector & (zone_sectors - 1))
>  		return -EINVAL;
>  
> -	if ((nr_sectors & (zone_sectors - 1)) &&
> -	    end_sector != bdev->bd_part->nr_sects)
> +	if ((nr_sectors & (zone_sectors - 1)) && end_sector != capacity)
>  		return -EINVAL;
>  
>  	while (sector < end_sector) {
> diff --git a/block/partition-generic.c b/block/partition-generic.c
> index aee643ce13d1..31bff3fb28af 100644
> --- a/block/partition-generic.c
> +++ b/block/partition-generic.c
> @@ -459,56 +459,6 @@ static int drop_partitions(struct gendisk *disk, struct block_device *bdev)
>  	return 0;
>  }
>  
> -static bool part_zone_aligned(struct gendisk *disk,
> -			      struct block_device *bdev,
> -			      sector_t from, sector_t size)
> -{
> -	unsigned int zone_sectors = bdev_zone_sectors(bdev);
> -
> -	/*
> -	 * If this function is called, then the disk is a zoned block device
> -	 * (host-aware or host-managed). This can be detected even if the
> -	 * zoned block device support is disabled (CONFIG_BLK_DEV_ZONED not
> -	 * set). In this case, however, only host-aware devices will be seen
> -	 * as a block device is not created for host-managed devices. Without
> -	 * zoned block device support, host-aware drives can still be used as
> -	 * regular block devices (no zone operation) and their zone size will
> -	 * be reported as 0. Allow this case.
> -	 */
> -	if (!zone_sectors)
> -		return true;
> -
> -	/*
> -	 * Check partition start and size alignement. If the drive has a
> -	 * smaller last runt zone, ignore it and allow the partition to
> -	 * use it. Check the zone size too: it should be a power of 2 number
> -	 * of sectors.
> -	 */
> -	if (WARN_ON_ONCE(!is_power_of_2(zone_sectors))) {
> -		u32 rem;
> -
> -		div_u64_rem(from, zone_sectors, &rem);
> -		if (rem)
> -			return false;
> -		if ((from + size) < get_capacity(disk)) {
> -			div_u64_rem(size, zone_sectors, &rem);
> -			if (rem)
> -				return false;
> -		}
> -
> -	} else {
> -
> -		if (from & (zone_sectors - 1))
> -			return false;
> -		if ((from + size) < get_capacity(disk) &&
> -		    (size & (zone_sectors - 1)))
> -			return false;
> -
> -	}
> -
> -	return true;
> -}
> -
>  int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
>  {
>  	struct parsed_partitions *state = NULL;
> @@ -544,6 +494,14 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
>  		}
>  		return -EIO;
>  	}
> +
> +	/* Partitions are not supported on zoned block devices */
> +	if (bdev_is_zoned(bdev)) {
> +		pr_warn("%s: ignoring partition table on zoned block device\n",
> +			disk->disk_name);
> +		goto out;
> +	}
> +
>  	/*
>  	 * If any partition code tried to read beyond EOD, try
>  	 * unlocking native capacity even if partition table is

While I do applaud removing special cases for zoned devices, we do have
the GENHD_FL_NO_PART_SCAN for precisely this use case.
Any particular reason why this isn't being used, nor even set?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 247165 (AG München), GF: Felix Imendörffer
