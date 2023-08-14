Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A39BC04E69
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 12:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjHNMeV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 08:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjHNMdv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 08:33:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACB6CC;
        Mon, 14 Aug 2023 05:33:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1937C6146B;
        Mon, 14 Aug 2023 12:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F98C433C8;
        Mon, 14 Aug 2023 12:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692016429;
        bh=pWj7KH8ASKmWbVWlAOELqcUEv/MbdNdv3xXF+vOT060=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=No00WK5uOiprcIzKGGKMh31Hl9JsYDeKTRGbuV48Vm6MMMXTelMLw/4ycvwI0gXgu
         KyjE+l1KwhtMse0hhjQFIJzZOc6SYzCAoDWeIL0Ip8js5/tn9swWDVX6VHsGTvSb+G
         dyIz4BLEn1xV2zTABG1XdaQTCGXY2B4WIGxQ4XiyQ+TlIiSt9z2BHrkDdMLjQgmWHm
         nayhQgg02qRPgPjGKPDQml0XpQIYpvfm6h8GXXvbXFnLpKxjV5jxxNB0QNv2B8ceyR
         TMIMwi0PCWJbvwfspAnqurk9ceLDLNj+zFNOBGdAkpgCwqZc+i4q6quRuBxNhp/4/8
         0onBlyHuIVMQQ==
Message-ID: <0ba79726-fb9c-c5ae-146f-ffc29703ec21@kernel.org>
Date:   Mon, 14 Aug 2023 21:33:47 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v8 2/9] block/mq-deadline: Only use zone locking if
 necessary
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-3-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230811213604.548235-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/12/23 06:35, Bart Van Assche wrote:
> Measurements have shown that limiting the queue depth to one per zone for
> zoned writes has a significant negative performance impact on zoned UFS
> devices. Hence this patch that disables zone locking by the mq-deadline
> scheduler if the storage controller preserves the command order. This
> patch is based on the following assumptions:
> - It happens infrequently that zoned write requests are reordered by the
>   block layer.
> - The I/O priority of all write requests is the same per zone.
> - Either no I/O scheduler is used or an I/O scheduler is used that
>   serializes write requests per zone.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/mq-deadline.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/block/mq-deadline.c b/block/mq-deadline.c
> index f958e79277b8..5c2fc4003bc0 100644
> --- a/block/mq-deadline.c
> +++ b/block/mq-deadline.c
> @@ -353,7 +353,7 @@ deadline_fifo_request(struct deadline_data *dd, struct dd_per_prio *per_prio,
>  		return NULL;
>  
>  	rq = rq_entry_fifo(per_prio->fifo_list[data_dir].next);
> -	if (data_dir == DD_READ || !blk_queue_is_zoned(rq->q))
> +	if (data_dir == DD_READ || !rq->q->limits.use_zone_write_lock)
>  		return rq;
>  
>  	/*
> @@ -398,7 +398,7 @@ deadline_next_request(struct deadline_data *dd, struct dd_per_prio *per_prio,
>  	if (!rq)
>  		return NULL;
>  
> -	if (data_dir == DD_READ || !blk_queue_is_zoned(rq->q))
> +	if (data_dir == DD_READ || !rq->q->limits.use_zone_write_lock)
>  		return rq;
>  
>  	/*
> @@ -526,8 +526,9 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
>  	}
>  
>  	/*
> -	 * For a zoned block device, if we only have writes queued and none of
> -	 * them can be dispatched, rq will be NULL.
> +	 * For a zoned block device that requires write serialization, if we
> +	 * only have writes queued and none of them can be dispatched, rq will
> +	 * be NULL.
>  	 */
>  	if (!rq)
>  		return NULL;
> @@ -552,7 +553,8 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
>  	/*
>  	 * If the request needs its target zone locked, do it.
>  	 */
> -	blk_req_zone_write_lock(rq);
> +	if (rq->q->limits.use_zone_write_lock)
> +		blk_req_zone_write_lock(rq);
>  	rq->rq_flags |= RQF_STARTED;
>  	return rq;
>  }
> @@ -934,7 +936,7 @@ static void dd_finish_request(struct request *rq)
>  
>  	atomic_inc(&per_prio->stats.completed);
>  
> -	if (blk_queue_is_zoned(q)) {
> +	if (rq->q->limits.use_zone_write_lock) {

This is all nice and simple ! However, an inline helper to check
rq->q->limits.use_zone_write_lock would be nice. E.g.
blk_queue_use_zone_write_lock() ?

>  		unsigned long flags;
>  
>  		spin_lock_irqsave(&dd->zone_lock, flags);

-- 
Damien Le Moal
Western Digital Research

