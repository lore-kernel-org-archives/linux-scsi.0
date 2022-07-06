Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6CFC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 11:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbiGFL70 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 07:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbiGFL7Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 07:59:25 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4834DE71
        for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2022 04:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1657108763; x=1688644763;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7s7q0INtd+Rq06SCkVVAKizJ6RdF1NL+4ogbR8OLEAM=;
  b=ZGh7qytfmheBcQJyq9VtMpn7dlCNN0L9fikcuxOZJ28SRpvjg86m1ryt
   gr8jMCzXTyjf4q2tZuRvRVfOWUbiM3rwbuyCgDR47BYZzso7NUvE9kGif
   kw58hwOVjptJg/Blc0sHqOpB0wNaPazsyHTzvpPsM+GI/TpJ13jZZ47eg
   UY7zawOmxzKdzgzBXuxDvJe0vkRZIOMKOK1xC1R5adOMitWIG8KekgiAE
   haHOCv5IGI2RTGQlSdeHWCYfD2eXrtlq9/Q1YvFNoRrww7QEcBnQKKenm
   KzVz1Nn8kSduc+tgr1NEyaxz4hpia1AHzpZJpSBimBxal0B/SiFwdnSpA
   w==;
X-IronPort-AV: E=Sophos;i="5.92,249,1650902400"; 
   d="scan'208";a="204978277"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2022 19:59:21 +0800
IronPort-SDR: M17CbrWS9DLD3EaSTTsko0U0+53nqdQ5jiGJ8KtZB0cNmGoV+J7+lxzEXdHJ/8DGRUUeXxYrpG
 9gVBN9Ir5Vnq0mNYksHoX5zDGRaqwgj32zx4FnBtI6gYjQsA3RSpCMCyxboD6SMkPRXiUAaioH
 Kj3iV26KfZlsoAUwQGjqo6pAesX6UtmBZ2+Fpk1kYN2A9tS1EjQduNV/s8jz/Kg5uWeTMxgIGp
 jMrRO2WzWt3WAI+nclHTLevz7pvCNqOYW3OPkEzdlVdd+cZAtYfSyTUpL4jTPfGE9gAKW++M1N
 z7hOI/1+zcpbQNZCcc1yQ8PW
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2022 04:16:37 -0700
IronPort-SDR: 5fZDffv2QJZUUMd97eruZQs+drOAsbE1TLUHS5DOx8JY/Mp1/z/6FRoWLQiStnyEWpRlNPV9yH
 /Er8ridR5reckB5ZBCgsYL4WpBscoXljqOhX2l/fg8Roynt/3P0HOSR+VuKxFT5rLv/l4z8DAK
 qWArP++QExhdTKkUuJKvkxR9Gb2K7/Jr2CLVsbKs5q28Th+W7eiQYlcj7vOnRKrz9Z2Ggpn0cM
 SllQ51rDM6ka50jnxXhlTvFpZIIDlArXaeOorNp+pq9fG0Aj7hRG0QO6XY8TV72R9mrqnwqTvF
 kdA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2022 04:59:23 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LdJ496dGvz1Rwqy
        for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2022 04:59:21 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1657108760; x=1659700761; bh=7s7q0INtd+Rq06SCkVVAKizJ6RdF1NL+4og
        bR8OLEAM=; b=KHyklUV29fkLDUfNPXPjsamI0VSfhAeaNT1+1sUHwRFVSY967n2
        vGLVRkAjeWTsg0ZTtIqVXUTcK4CS/guh3FTrn2VC5/KjmCZ2DvKsk/WXwdoG33Pe
        Vf888AJjh7Vmf8BVG08elXDATR7N9mV2IWKfK0KB7RrvJ2hvVOw4iKBPo0j3ZCv2
        BB/eN7WjUFMaAmGvPTLitDWq0ZHnphaZNzNoW/VRl1jGZqS8jXeR8Tg6hSvVgS8f
        AQlzTkkU841tEAgOt0C1lbYT9Ur2DShKATvVDvuScdMa0VHrKAQY7CPiDFXoqCu7
        4XMRw6jwo5n+Kaq4pu9NFKHMieqbcu9vR2A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id jPwSJwUvZHI9 for <linux-scsi@vger.kernel.org>;
        Wed,  6 Jul 2022 04:59:20 -0700 (PDT)
Received: from [10.225.163.110] (unknown [10.225.163.110])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LdJ471s4bz1RtVk;
        Wed,  6 Jul 2022 04:59:19 -0700 (PDT)
Message-ID: <e5737383-3b85-e50b-166f-296ef821a47a@opensource.wdc.com>
Date:   Wed, 6 Jul 2022 20:59:18 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 11/16] block: replace blkdev_nr_zones with bdev_nr_zones
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20220706070350.1703384-1-hch@lst.de>
 <20220706070350.1703384-12-hch@lst.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220706070350.1703384-12-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/6/22 16:03, Christoph Hellwig wrote:
> Pass a block_device instead of a request_queue as that is what most
> callers have at hand.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

And for the zonefs bits:

Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  block/blk-zoned.c              | 15 ++++++++-------
>  block/ioctl.c                  |  2 +-
>  drivers/block/null_blk/zoned.c |  2 +-
>  drivers/md/dm-zone.c           |  2 +-
>  drivers/md/dm-zoned-target.c   |  5 ++---
>  drivers/nvme/target/zns.c      |  6 +++---
>  fs/zonefs/super.c              | 17 ++++++++---------
>  include/linux/blkdev.h         |  4 ++--
>  8 files changed, 26 insertions(+), 27 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 0d431394cf90c..2dec25d8aa3bd 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -108,21 +108,22 @@ void __blk_req_zone_write_unlock(struct request *rq)
>  EXPORT_SYMBOL_GPL(__blk_req_zone_write_unlock);
>  
>  /**
> - * blkdev_nr_zones - Get number of zones
> - * @disk:	Target gendisk
> + * bdev_nr_zones - Get number of zones
> + * @bdev:	Target device
>   *
>   * Return the total number of zones of a zoned block device.  For a block
>   * device without zone capabilities, the number of zones is always 0.
>   */
> -unsigned int blkdev_nr_zones(struct gendisk *disk)
> +unsigned int bdev_nr_zones(struct block_device *bdev)
>  {
> -	sector_t zone_sectors = blk_queue_zone_sectors(disk->queue);
> +	sector_t zone_sectors = bdev_zone_sectors(bdev);
>  
> -	if (!blk_queue_is_zoned(disk->queue))
> +	if (!bdev_is_zoned(bdev))
>  		return 0;
> -	return (get_capacity(disk) + zone_sectors - 1) >> ilog2(zone_sectors);
> +	return (bdev_nr_sectors(bdev) + zone_sectors - 1) >>
> +		ilog2(zone_sectors);
>  }
> -EXPORT_SYMBOL_GPL(blkdev_nr_zones);
> +EXPORT_SYMBOL_GPL(bdev_nr_zones);
>  
>  /**
>   * blkdev_report_zones - Get zones information
> diff --git a/block/ioctl.c b/block/ioctl.c
> index 46949f1b0dba5..60121e89052bc 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -495,7 +495,7 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
>  	case BLKGETZONESZ:
>  		return put_uint(argp, bdev_zone_sectors(bdev));
>  	case BLKGETNRZONES:
> -		return put_uint(argp, blkdev_nr_zones(bdev->bd_disk));
> +		return put_uint(argp, bdev_nr_zones(bdev));
>  	case BLKROGET:
>  		return put_int(argp, bdev_read_only(bdev) != 0);
>  	case BLKSSZGET: /* get block device logical block size */
> diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
> index 576ab3ed082a5..e62c52e964259 100644
> --- a/drivers/block/null_blk/zoned.c
> +++ b/drivers/block/null_blk/zoned.c
> @@ -170,7 +170,7 @@ int null_register_zoned_dev(struct nullb *nullb)
>  			return ret;
>  	} else {
>  		blk_queue_chunk_sectors(q, dev->zone_size_sects);
> -		q->nr_zones = blkdev_nr_zones(nullb->disk);
> +		q->nr_zones = bdev_nr_zones(nullb->disk->part0);
>  	}
>  
>  	blk_queue_max_zone_append_sectors(q, dev->zone_size_sects);
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index ae616b87c91ae..6d105abe12415 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -301,7 +301,7 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
>  	 * correct value to be exposed in sysfs queue/nr_zones.
>  	 */
>  	WARN_ON_ONCE(queue_is_mq(q));
> -	q->nr_zones = blkdev_nr_zones(md->disk);
> +	q->nr_zones = bdev_nr_zones(md->disk->part0);
>  
>  	/* Check if zone append is natively supported */
>  	if (dm_table_supports_zone_append(t)) {
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index 0ec5d8b9b1a4e..6ba6ef44b00e2 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -793,8 +793,7 @@ static int dmz_fixup_devices(struct dm_target *ti)
>  			}
>  			zone_nr_sectors = blk_queue_zone_sectors(q);
>  			zoned_dev->zone_nr_sectors = zone_nr_sectors;
> -			zoned_dev->nr_zones =
> -				blkdev_nr_zones(zoned_dev->bdev->bd_disk);
> +			zoned_dev->nr_zones = bdev_nr_zones(zoned_dev->bdev);
>  		}
>  	} else {
>  		reg_dev = NULL;
> @@ -805,7 +804,7 @@ static int dmz_fixup_devices(struct dm_target *ti)
>  		}
>  		q = bdev_get_queue(zoned_dev->bdev);
>  		zoned_dev->zone_nr_sectors = blk_queue_zone_sectors(q);
> -		zoned_dev->nr_zones = blkdev_nr_zones(zoned_dev->bdev->bd_disk);
> +		zoned_dev->nr_zones = bdev_nr_zones(zoned_dev->bdev);
>  	}
>  
>  	if (reg_dev) {
> diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
> index 82b61acf7a72b..c4c99b832daf2 100644
> --- a/drivers/nvme/target/zns.c
> +++ b/drivers/nvme/target/zns.c
> @@ -60,7 +60,7 @@ bool nvmet_bdev_zns_enable(struct nvmet_ns *ns)
>  	if (ns->bdev->bd_disk->queue->conv_zones_bitmap)
>  		return false;
>  
> -	ret = blkdev_report_zones(ns->bdev, 0, blkdev_nr_zones(bd_disk),
> +	ret = blkdev_report_zones(ns->bdev, 0, bdev_nr_zones(ns->bdev),
>  				  validate_conv_zones_cb, NULL);
>  	if (ret < 0)
>  		return false;
> @@ -241,7 +241,7 @@ static unsigned long nvmet_req_nr_zones_from_slba(struct nvmet_req *req)
>  {
>  	unsigned int sect = nvmet_lba_to_sect(req->ns, req->cmd->zmr.slba);
>  
> -	return blkdev_nr_zones(req->ns->bdev->bd_disk) -
> +	return bdev_nr_zones(req->ns->bdev) -
>  		(sect >> ilog2(bdev_zone_sectors(req->ns->bdev)));
>  }
>  
> @@ -386,7 +386,7 @@ static int zmgmt_send_scan_cb(struct blk_zone *z, unsigned i, void *d)
>  static u16 nvmet_bdev_zone_mgmt_emulate_all(struct nvmet_req *req)
>  {
>  	struct block_device *bdev = req->ns->bdev;
> -	unsigned int nr_zones = blkdev_nr_zones(bdev->bd_disk);
> +	unsigned int nr_zones = bdev_nr_zones(bdev);
>  	struct request_queue *q = bdev_get_queue(bdev);
>  	struct bio *bio = NULL;
>  	sector_t sector = 0;
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index 053299758deb9..9c0eef1ff32a0 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -1394,7 +1394,7 @@ static void zonefs_init_dir_inode(struct inode *parent, struct inode *inode,
>  {
>  	struct super_block *sb = parent->i_sb;
>  
> -	inode->i_ino = blkdev_nr_zones(sb->s_bdev->bd_disk) + type + 1;
> +	inode->i_ino = bdev_nr_zones(sb->s_bdev) + type + 1;
>  	inode_init_owner(&init_user_ns, inode, parent, S_IFDIR | 0555);
>  	inode->i_op = &zonefs_dir_inode_operations;
>  	inode->i_fop = &simple_dir_operations;
> @@ -1540,7 +1540,7 @@ static int zonefs_create_zgroup(struct zonefs_zone_data *zd,
>  	/*
>  	 * The first zone contains the super block: skip it.
>  	 */
> -	end = zd->zones + blkdev_nr_zones(sb->s_bdev->bd_disk);
> +	end = zd->zones + bdev_nr_zones(sb->s_bdev);
>  	for (zone = &zd->zones[1]; zone < end; zone = next) {
>  
>  		next = zone + 1;
> @@ -1635,8 +1635,8 @@ static int zonefs_get_zone_info(struct zonefs_zone_data *zd)
>  	struct block_device *bdev = zd->sb->s_bdev;
>  	int ret;
>  
> -	zd->zones = kvcalloc(blkdev_nr_zones(bdev->bd_disk),
> -			     sizeof(struct blk_zone), GFP_KERNEL);
> +	zd->zones = kvcalloc(bdev_nr_zones(bdev), sizeof(struct blk_zone),
> +			     GFP_KERNEL);
>  	if (!zd->zones)
>  		return -ENOMEM;
>  
> @@ -1648,9 +1648,9 @@ static int zonefs_get_zone_info(struct zonefs_zone_data *zd)
>  		return ret;
>  	}
>  
> -	if (ret != blkdev_nr_zones(bdev->bd_disk)) {
> +	if (ret != bdev_nr_zones(bdev)) {
>  		zonefs_err(zd->sb, "Invalid zone report (%d/%u zones)\n",
> -			   ret, blkdev_nr_zones(bdev->bd_disk));
> +			   ret, bdev_nr_zones(bdev));
>  		return -EIO;
>  	}
>  
> @@ -1816,8 +1816,7 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
>  	if (ret)
>  		goto cleanup;
>  
> -	zonefs_info(sb, "Mounting %u zones",
> -		    blkdev_nr_zones(sb->s_bdev->bd_disk));
> +	zonefs_info(sb, "Mounting %u zones", bdev_nr_zones(sb->s_bdev));
>  
>  	if (!sbi->s_max_wro_seq_files &&
>  	    !sbi->s_max_active_seq_files &&
> @@ -1833,7 +1832,7 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
>  	if (!inode)
>  		goto cleanup;
>  
> -	inode->i_ino = blkdev_nr_zones(sb->s_bdev->bd_disk);
> +	inode->i_ino = bdev_nr_zones(sb->s_bdev);
>  	inode->i_mode = S_IFDIR | 0555;
>  	inode->i_ctime = inode->i_mtime = inode->i_atime = current_time(inode);
>  	inode->i_op = &zonefs_dir_inode_operations;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index c05e1cc05c265..fa2757ef4a846 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -298,7 +298,7 @@ void disk_set_zoned(struct gendisk *disk, enum blk_zoned_model model);
>  #define BLK_ALL_ZONES  ((unsigned int)-1)
>  int blkdev_report_zones(struct block_device *bdev, sector_t sector,
>  			unsigned int nr_zones, report_zones_cb cb, void *data);
> -unsigned int blkdev_nr_zones(struct gendisk *disk);
> +unsigned int bdev_nr_zones(struct block_device *bdev);
>  extern int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>  			    sector_t sectors, sector_t nr_sectors,
>  			    gfp_t gfp_mask);
> @@ -312,7 +312,7 @@ extern int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
>  
>  #else /* CONFIG_BLK_DEV_ZONED */
>  
> -static inline unsigned int blkdev_nr_zones(struct gendisk *disk)
> +static inline unsigned int bdev_nr_zones(struct block_device *bdev)
>  {
>  	return 0;
>  }


-- 
Damien Le Moal
Western Digital Research
