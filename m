Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 230FCC001DB
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 12:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjHNMcO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 08:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbjHNMcI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 08:32:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB17CCC;
        Mon, 14 Aug 2023 05:32:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79CE962D5E;
        Mon, 14 Aug 2023 12:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFB7C433C8;
        Mon, 14 Aug 2023 12:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692016326;
        bh=0DJHJ3rAXmJtkRIBadVM+FdIyJCgIhDp0E+687UQdnk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=VqE2HWtj76+zmKkRWjjiH2qbvY27jDLfKUgAVDzgyvDsmudGHpVdO9Qv/1jTL3a4C
         p/h8sm59CsWPRsqElEvTfNyspdylh4gJ7msg4l7Eum4unsEDc25Vy2nLAdoyWyjQeZ
         6mozxkIajwgy2lP6mQIbk/GL1nzHFaXTeLmUS8/vmw7X4+tWhb6NVnwYZacnYJnLOL
         zxSL5JPL2AjgnUJHTYX/LjGi38YbCbJdG5Z6pkmhYB0og8oYzNa3XliLRfjVvMR2R4
         sEUo4KLmGNBeu+84aIjCTKsONuRndTrd+fiBHfzQ7/CJ1FfGLNA4+E0UfDTaRgVAWr
         tVWBqbDERiC5A==
Message-ID: <3188f400-b387-7be8-0f21-cf5089fe1411@kernel.org>
Date:   Mon, 14 Aug 2023 21:32:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v8 1/9] block: Introduce more member variables related to
 zone write locking
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-2-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230811213604.548235-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/12/23 06:35, Bart Van Assche wrote:
> Many but not all storage controllers require serialization of zoned writes.
> Introduce a new request queue limit member variable
> (driver_preserves_write_order) that allows block drivers to indicate that
> the order of write commands is preserved and hence that serialization of
> writes per zone is not required.
> 
> Make disk_set_zoned() set 'use_zone_write_lock' only if the block device
> has zones and if the block driver does not preserve the order of write
> requests.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-settings.c   |  7 +++++++
>  include/linux/blkdev.h | 10 ++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 0046b447268f..3a7748af1bef 100644
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
> @@ -685,6 +687,9 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  						   b->max_secure_erase_sectors);
>  	t->zone_write_granularity = max(t->zone_write_granularity,
>  					b->zone_write_granularity);
> +	/* Request-based stacking drivers do not reorder requests. */
> +	t->driver_preserves_write_order = b->driver_preserves_write_order;
> +	t->use_zone_write_lock = b->use_zone_write_lock;

I do not think this is correct as the last target of a multi target device will
dictate the result, regardless of the other targets. So this should be something
like:

	t->driver_preserves_write_order = t->driver_preserves_write_order &&
		b->driver_preserves_write_order;
	t->use_zone_write_lock =
		t->use_zone_write_lock || b->use_zone_write_lock;

However, given that driver_preserves_write_order is initialized as false, this
would always be false. Not sure how to handle that...

>  	t->zoned = max(t->zoned, b->zoned);
>  	return ret;
>  }
> @@ -949,6 +954,8 @@ void disk_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
>  	}
>  
>  	q->limits.zoned = model;
> +	q->limits.use_zone_write_lock = model != BLK_ZONED_NONE &&
> +		!q->limits.driver_preserves_write_order;

I think this needs a comment to explain the condition as it takes a while to
understand it.

>  	if (model != BLK_ZONED_NONE) {
>  		/*
>  		 * Set the zone write granularity to the device logical block

You also should set use_zone_write_lock to false in disk_clear_zone_settings().

In patch 9, ufshcd_auto_hibern8_update() changes the value of
driver_preserves_write_order, which will change the value of use_zone_write_lock
only if disk_set_zoned() is called again after ufshcd_auto_hibern8_update(). Is
that the case ? Is the drive revalidated always after
ufshcd_auto_hibern8_update() is executed ?

> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 2f5371b8482c..2c090a28ec78 100644
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

