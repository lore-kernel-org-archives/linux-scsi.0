Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 291F3C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 02:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiGECz4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 22:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiGECz4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 22:55:56 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E151CC3
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 19:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656989755; x=1688525755;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Y8lcgAPDEr2cqKnB0CgGnKFQmRqGD0zu4iwMGeDrRYo=;
  b=Nno4SFxyG9Jb4jn7AF0ualk4zwJeRcLpDLYSQz4lCTMOAZ/oO4u8f6GF
   BiAIdPUqgVNxbgVo/+zHzbohPDI/KNxNQNnTBwYd76eyMColulJPq78bE
   lCGAxXXJf97osDwMGyiNR9vLYQPBGg/iA5V0uVAZnwArVtsBY16TGitdF
   ra+Eejf0j1vAHp1c/oqyDQl3PQ4Q+5WaNSDa5crItk2JjkYbsK14sTVDX
   itPgdcVT3YoXdVJP4hnll0cZCex5QctIHFkaCSeLvuV9+5JXCtDvheVOp
   qr8HtBlan3udXIn4zjVv2H56lbTqx0URitN7gxxBHVcKeMrADcVVur2+e
   A==;
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; 
   d="scan'208";a="316926993"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:55:55 +0800
IronPort-SDR: qYyRUwm4dW1Hwqu1a/UwmBqLQBmv4YtReBaCdJN1C29XsRxjknuw/42iKoE1wJiuASmXUyJmbO
 nGqnF5tH+MALzL0vKuqAv7HKBuBr/WKScZveHGnSuRsWJDVtHLouPor8yCT+yxuwAgNSkhgbUh
 btYtiMGf6YZbZYtxJSdnFLD9+dv1DKBzisMzqK7EgCqZp4HjmkFt4BsyBkudqC61Rd1Mty1ytT
 9+YuAAPV/lrpa82fN9MoATpszM4d+f97h2A5aVxY8TUPYlXb08gHHjvFZh9JwZHfogp293a2Zy
 q7yFElcm9kban36ENHeRpOU6
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jul 2022 19:13:14 -0700
IronPort-SDR: L6zUc4vqC38pmA6YQPQY+IvXrAHyyQp6PMplgyNucx215cZNCqj3B0EtXS0pj+8RsVl1CYgkr3
 gqcx3JI40Wt4ZojGBp01xJc+DGTtwyZqg1mB11aqsaVAZU5GXZEGwjTPmRdOctcDx+gmv7DQqy
 81lwtYSLVWX+jWf1j4RKpWWd+xSKnyLn9de90aaTUGnFwWjtlbbWd/LYW0yukjg4bkHnn82a1I
 og8/bgF6aXFOlk1HHfkPxHbWP9H2uAPfBnLux8rdJUzKF7jWVinj3XZWJROHmOAP5l5+uG8rWK
 TMg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jul 2022 19:55:56 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcS3b0F5pz1Rw4L
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 19:55:55 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1656989754; x=1659581755; bh=Y8lcgAPDEr2cqKnB0CgGnKFQmRqGD0zu4iw
        MGeDrRYo=; b=DbdYtbrAPEpkNXcR5ct8xxau/LljEmNX1k6H3A6NYsEs9PJFhNp
        anVlqxX3Fos6UX6AQWMUlmKU5XWXxyOaXirFSZjLLD0rSWik7E9Q0HpG0Wm2WKAO
        ZZDcZVqmWMhB1skK9W6ITUs9faTytKvvxk5xftGbtwoxHZA8sZeMpJIVl9oKlWlY
        0L9oJmLRZDgD7AGSw8l/1QC3G9QnMgU9e6nUiYSiFOME51yx5PX41lj/OCA5lNm6
        1OpJssZ9DHlhBlN4GIzvnnJBCNoWGwsYqT67YpEhsqEAWzfYwF3BonbkEMls/GEe
        GDJ59RSEh3+WNdUWjDZ0IUQauLNWoqQ0Rdw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id UD3Av2F9ZSXH for <linux-scsi@vger.kernel.org>;
        Mon,  4 Jul 2022 19:55:54 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcS3Y3vhHz1RtVk;
        Mon,  4 Jul 2022 19:55:53 -0700 (PDT)
Message-ID: <98bebb07-d8a6-7a65-7843-874e62422fd6@opensource.wdc.com>
Date:   Tue, 5 Jul 2022 11:55:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 16/17] block: remove blk_queue_zone_sectors
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-17-hch@lst.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-17-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/4/22 21:44, Christoph Hellwig wrote:
> Always use bdev_zone_sectors instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/md/dm-table.c  |  4 +---
>  drivers/md/dm-zone.c   | 10 ++++++----
>  include/linux/blkdev.h | 11 +++--------
>  3 files changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index b36b528e56cff..df904b7e95ce3 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1620,13 +1620,11 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
>  static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *dev,
>  					   sector_t start, sector_t len, void *data)
>  {
> -	struct request_queue *q = bdev_get_queue(dev->bdev);
>  	unsigned int *zone_sectors = data;
>  
>  	if (!bdev_is_zoned(dev->bdev))
>  		return 0;
> -
> -	return blk_queue_zone_sectors(q) != *zone_sectors;
> +	return bdev_zone_sectors(dev->bdev) != *zone_sectors;
>  }
>  
>  /*
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index 6d105abe12415..842c31019b513 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -334,7 +334,7 @@ static int dm_update_zone_wp_offset_cb(struct blk_zone *zone, unsigned int idx,
>  static int dm_update_zone_wp_offset(struct mapped_device *md, unsigned int zno,
>  				    unsigned int *wp_ofst)
>  {
> -	sector_t sector = zno * blk_queue_zone_sectors(md->queue);
> +	sector_t sector = zno * bdev_zone_sectors(md->disk->part0);
>  	unsigned int noio_flag;
>  	struct dm_table *t;
>  	int srcu_idx, ret;
> @@ -373,7 +373,7 @@ struct orig_bio_details {
>  static bool dm_zone_map_bio_begin(struct mapped_device *md,
>  				  unsigned int zno, struct bio *clone)
>  {
> -	sector_t zsectors = blk_queue_zone_sectors(md->queue);
> +	sector_t zsectors = bdev_zone_sectors(md->disk->part0);
>  	unsigned int zwp_offset = READ_ONCE(md->zwp_offset[zno]);
>  
>  	/*
> @@ -443,7 +443,7 @@ static blk_status_t dm_zone_map_bio_end(struct mapped_device *md, unsigned int z
>  		return BLK_STS_OK;
>  	case REQ_OP_ZONE_FINISH:
>  		WRITE_ONCE(md->zwp_offset[zno],
> -			   blk_queue_zone_sectors(md->queue));
> +			   bdev_zone_sectors(md->disk->part0));
>  		return BLK_STS_OK;
>  	case REQ_OP_WRITE_ZEROES:
>  	case REQ_OP_WRITE:
> @@ -593,6 +593,7 @@ void dm_zone_endio(struct dm_io *io, struct bio *clone)
>  {
>  	struct mapped_device *md = io->md;
>  	struct request_queue *q = md->queue;
> +	struct gendisk *disk = md->disk;
>  	struct bio *orig_bio = io->orig_bio;
>  	unsigned int zwp_offset;
>  	unsigned int zno;
> @@ -608,7 +609,8 @@ void dm_zone_endio(struct dm_io *io, struct bio *clone)
>  		 */
>  		if (clone->bi_status == BLK_STS_OK &&
>  		    bio_op(clone) == REQ_OP_ZONE_APPEND) {
> -			sector_t mask = (sector_t)blk_queue_zone_sectors(q) - 1;
> +			sector_t mask =
> +				(sector_t)bdev_zone_sectors(disk->part0) - 1;
>  
>  			orig_bio->bi_iter.bi_sector +=
>  				clone->bi_iter.bi_sector & mask;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 183aa83143fd2..f1eca3f5610eb 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -669,11 +669,6 @@ static inline bool blk_queue_is_zoned(struct request_queue *q)
>  	}
>  }
>  
> -static inline sector_t blk_queue_zone_sectors(struct request_queue *q)
> -{
> -	return blk_queue_is_zoned(q) ? q->limits.chunk_sectors : 0;
> -}
> -
>  #ifdef CONFIG_BLK_DEV_ZONED
>  static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
>  {
> @@ -1312,9 +1307,9 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
>  {
>  	struct request_queue *q = bdev_get_queue(bdev);
>  
> -	if (q)
> -		return blk_queue_zone_sectors(q);
> -	return 0;
> +	if (!blk_queue_is_zoned(q))
> +		return 0;
> +	return q->limits.chunk_sectors;
>  }
>  
>  static inline int queue_dma_alignment(const struct request_queue *q)


-- 
Damien Le Moal
Western Digital Research
