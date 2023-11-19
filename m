Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E510C072A2
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Nov 2023 23:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbjKSX3n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Nov 2023 18:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjKSX3m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Nov 2023 18:29:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C73115
        for <linux-scsi@vger.kernel.org>; Sun, 19 Nov 2023 15:29:39 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F24C433C8;
        Sun, 19 Nov 2023 23:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700436579;
        bh=L0gZfWbFJNB5A1+APx2Mb6++m61UV1JX2ge42wd7A+4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kDwsPdbIemdGe7pfShARdu3v6yI79NMF8J1zD9DXGKMBikfFICN8Y+X52v7nMix1p
         ySnusm7XkifQJnmbFmzMyRtYoT0VvMdYMoyHkndLx/Hhe6muqIDR/SNQMNg4pyChZu
         JPM4LFbyk6z+frZDzWrePjv+U5tr5WCdTaykXCDtNSyaI3uzvxxnkE8gVoufLGLA1J
         vB5mAivpVZOjGbvltP0r34rPuxSwEQo1fdTMJdZRp7p6xnuttqa4+OVMEm2FWNCHkT
         ViE1y6KWCl8ZM3m43ebT4gXuAJehdvnIS/y77hK/c7wzp8VhPA6UkSqYMcozJeZuXY
         7lu2IRwTCkvfw==
Message-ID: <3d8d04d5-80d8-4eee-9899-d9fe197dd203@kernel.org>
Date:   Mon, 20 Nov 2023 08:29:34 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 01/19] block: Introduce more member variables related
 to zone write locking
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Ming Lei <ming.lei@redhat.com>
References: <20231114211804.1449162-1-bvanassche@acm.org>
 <20231114211804.1449162-2-bvanassche@acm.org>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20231114211804.1449162-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/15/23 06:16, Bart Van Assche wrote:
> Many but not all storage controllers require serialization of zoned writes.
> Introduce two new request queue limit member variables related to write
> serialization. 'driver_preserves_write_order' allows block drivers to
> indicate that the order of write commands is preserved and hence that
> serialization of writes per zone is not required. 'use_zone_write_lock' is
> set by disk_set_zoned() if and only if the block device has zones and if
> the block driver does not preserve the order of write requests.
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-settings.c   | 15 +++++++++++++++
>  block/blk-zoned.c      |  1 +
>  include/linux/blkdev.h | 10 ++++++++++
>  3 files changed, 26 insertions(+)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 0046b447268f..4c776c08f190 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -56,6 +56,8 @@ void blk_set_default_limits(struct queue_limits *lim)
>  	lim->alignment_offset = 0;
>  	lim->io_opt = 0;
>  	lim->misaligned = 0;
> +	lim->driver_preserves_write_order = false;
> +	lim->use_zone_write_lock = false;
>  	lim->zoned = BLK_ZONED_NONE;
>  	lim->zone_write_granularity = 0;
>  	lim->dma_alignment = 511;
> @@ -82,6 +84,8 @@ void blk_set_stacking_limits(struct queue_limits *lim)
>  	lim->max_dev_sectors = UINT_MAX;
>  	lim->max_write_zeroes_sectors = UINT_MAX;
>  	lim->max_zone_append_sectors = UINT_MAX;
> +	/* Request-based stacking drivers do not reorder requests. */

Rereading this patch, I do not think this statement is correct. I seriously
doubt that multipath will preserve write command order in all cases...

> +	lim->driver_preserves_write_order = true;

... so it is likely much safer to set the default to "false" as that is the
default for all requests in general.

>  }
>  EXPORT_SYMBOL(blk_set_stacking_limits);
>  
> @@ -685,6 +689,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  						   b->max_secure_erase_sectors);
>  	t->zone_write_granularity = max(t->zone_write_granularity,
>  					b->zone_write_granularity);
> +	t->driver_preserves_write_order = t->driver_preserves_write_order &&
> +		b->driver_preserves_write_order;
> +	t->use_zone_write_lock = t->use_zone_write_lock ||
> +		b->use_zone_write_lock;

Very minor nit: splitting the line after the equal would make this more readable.

>  	t->zoned = max(t->zoned, b->zoned);
>  	return ret;
>  }
> @@ -949,6 +957,13 @@ void disk_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
>  	}
>  
>  	q->limits.zoned = model;
> +	/*
> +	 * Use the zone write lock only for zoned block devices and only if
> +	 * the block driver does not preserve the order of write commands.
> +	 */
> +	q->limits.use_zone_write_lock = model != BLK_ZONED_NONE &&
> +		!q->limits.driver_preserves_write_order;
> +
>  	if (model != BLK_ZONED_NONE) {
>  		/*
>  		 * Set the zone write granularity to the device logical block
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 619ee41a51cc..112620985bff 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -631,6 +631,7 @@ void disk_clear_zone_settings(struct gendisk *disk)
>  	q->limits.chunk_sectors = 0;
>  	q->limits.zone_write_granularity = 0;
>  	q->limits.max_zone_append_sectors = 0;
> +	q->limits.use_zone_write_lock = false;
>  
>  	blk_mq_unfreeze_queue(q);
>  }
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 51fa7ffdee83..2d452f5a36c8 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -316,6 +316,16 @@ struct queue_limits {
>  	unsigned char		misaligned;
>  	unsigned char		discard_misaligned;
>  	unsigned char		raid_partial_stripes_expensive;
> +	/*
> +	 * Whether or not the block driver preserves the order of write
> +	 * requests. Set by the block driver.
> +	 */
> +	bool			driver_preserves_write_order;
> +	/*
> +	 * Whether or not zone write locking should be used. Set by
> +	 * disk_set_zoned().
> +	 */
> +	bool			use_zone_write_lock;
>  	enum blk_zoned_model	zoned;
>  
>  	/*

-- 
Damien Le Moal
Western Digital Research

