Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB23C0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 01:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbjHJBdx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 21:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjHJBdx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 21:33:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B0C1982;
        Wed,  9 Aug 2023 18:33:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B18D464610;
        Thu, 10 Aug 2023 01:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE78C433C7;
        Thu, 10 Aug 2023 01:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691631231;
        bh=oWGKhIeh6kaeaJn6ZNIE4zHxvGRiQzaD/SvZcJqakZc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=M9k8yK/xPfB1v+JwzySRfWhUp8jOGMuG5Sj/BcIfdiZkWb+jFQstqWKik/ma00C0y
         5TiAKXGCiLxHXcqmmHBri+zEWO+TxgeuUXYJ+4C07Vw6wl6Wcv5D2ZjsUIBC+QCqo3
         WMzj5ePcLAatavb/MIu4+gNUmJveQ7hUvpC3Ga0GO2BRp1w4CDEYg54dsfdxbFeFMF
         SvzgxbQV47Dh5A+4ukNJjF2utIScGCJyGspRQTNpW99dRaKNsGeH8X9WChMcULnZN3
         a8X6KzPLQelgYfJbFceS4QsZ2IG2i9xhKIbHTC98t/vED5SGs6BXJ6cT4RKE9xXstc
         8ycPgZlB1LtGw==
Message-ID: <8312a7c4-b3ef-873d-c4fa-825b7fce8be1@kernel.org>
Date:   Thu, 10 Aug 2023 10:33:49 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 1/7] block: Introduce the use_zone_write_lock member
 variable
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230809202355.1171455-1-bvanassche@acm.org>
 <20230809202355.1171455-2-bvanassche@acm.org>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230809202355.1171455-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/10/23 05:23, Bart Van Assche wrote:
> Writes in sequential write required zones must happen at the write
> pointer. Even if the submitter of the write commands (e.g. a filesystem)
> submits writes for sequential write required zones in order, the block
> layer or the storage controller may reorder these write commands.
> 
> The zone locking mechanism in the mq-deadline I/O scheduler serializes
> write commands for sequential zones. Some but not all storage controllers
> require this serialization. Introduce a new request queue limit member
> variable to allow block drivers to indicate that they preserve the order
> of write commands and thus do not require serialization of writes per
> zone.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-settings.c   | 6 ++++++
>  include/linux/blkdev.h | 1 +
>  2 files changed, 7 insertions(+)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 0046b447268f..b75c97971860 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -56,6 +56,7 @@ void blk_set_default_limits(struct queue_limits *lim)
>  	lim->alignment_offset = 0;
>  	lim->io_opt = 0;
>  	lim->misaligned = 0;
> +	lim->use_zone_write_lock = true;
>  	lim->zoned = BLK_ZONED_NONE;

Given that the default for zoned is BLK_ZONED_NONE, having use_zone_write_lock
default to true is strange. It would be better to set the default to false and
have disk_set_zoned() set it to true if needed, with an additional argument to
specify if it should be the case or not. E.g., for SMR drives, sd.c would call
something like:

disk_set_zoned(sdkp->disk, BLK_ZONED_HM, sdp->use_zone_write_lock);

sd.c would default to sdp->use_zone_write_lock == true and UFS driver can set
it to false. That would be cleaner I think.

>  	lim->zone_write_granularity = 0;
>  	lim->dma_alignment = 511;
> @@ -685,6 +686,11 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  						   b->max_secure_erase_sectors);
>  	t->zone_write_granularity = max(t->zone_write_granularity,
>  					b->zone_write_granularity);
> +	/*
> +	 * Whether or not the zone write lock should be used depends on the
> +	 * bottom driver only.
> +	 */
> +	t->use_zone_write_lock = b->use_zone_write_lock;

Given that DM bio targets do not have a scheduler and do not have a zone lock
bitmap allocated, I do not think this is necessary at all. This can remain to
false, thus in sync with the fact that there is no IO scheduler.

>  	t->zoned = max(t->zoned, b->zoned);
>  	return ret;
>  }
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 2f5371b8482c..deffa1f13444 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -316,6 +316,7 @@ struct queue_limits {
>  	unsigned char		misaligned;
>  	unsigned char		discard_misaligned;
>  	unsigned char		raid_partial_stripes_expensive;
> +	bool			use_zone_write_lock;
>  	enum blk_zoned_model	zoned;
>  
>  	/*

-- 
Damien Le Moal
Western Digital Research

