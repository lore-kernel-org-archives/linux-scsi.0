Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A794FC0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 01:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjHJBgO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 21:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjHJBgN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 21:36:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E53F1982;
        Wed,  9 Aug 2023 18:36:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7BDB617F0;
        Thu, 10 Aug 2023 01:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4734FC433C8;
        Thu, 10 Aug 2023 01:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691631372;
        bh=ztq7cTQm3DVhlVUte/zLPzkS3OzDfmQ5LdM3sbz0DDE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=d9/AEUHE7NPmHFm8kaem4sHRrsTyAfcaxg9SllkjhPH7Ztze7sTzJ1LneExgxyhfg
         gxvM4j9EVBXIKlGFBj1KYKtCn5MwnODGsPXu3MMnF1vEa2extwXNZIzAqCWC5PORm3
         6c8COz/YX5/AuA9Ucf5Occ8sSFp0ze54C4/FHDKSp2OweVOLJXgBR4wvIUAAjVROIk
         1onDwksjd3r9pVHntm3khZZMs5qhlOcqGJUdp02e4ouTrNJme59JgpV3WB64a7ZjMh
         oJ0aK34bTj9RxKPsWUaWaVCVWbFKCwmFTRNa3Vjo0jlV4h5AMCexrXT3JPkfzeqA/7
         qPV+wnAHAPqGQ==
Message-ID: <06527195-8f6d-0395-a7d5-d19634a00ad2@kernel.org>
Date:   Thu, 10 Aug 2023 10:36:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 2/7] block/mq-deadline: Only use zone locking if
 necessary
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230809202355.1171455-1-bvanassche@acm.org>
 <20230809202355.1171455-3-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230809202355.1171455-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/10/23 05:23, Bart Van Assche wrote:
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
>  block/mq-deadline.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/block/mq-deadline.c b/block/mq-deadline.c
> index f958e79277b8..cd2504205ff8 100644
> --- a/block/mq-deadline.c
> +++ b/block/mq-deadline.c
> @@ -338,6 +338,16 @@ static struct request *deadline_skip_seq_writes(struct deadline_data *dd,
>  	return rq;
>  }
>  
> +/*
> + * Whether or not to use zone write locking. Not using zone write locking for
> + * sequential write required zones is only safe if the block driver preserves
> + * the request order.
> + */
> +static bool dd_use_zone_write_locking(struct request_queue *q)
> +{
> +	return q->limits.use_zone_write_lock && blk_queue_is_zoned(q);

use_zone_write_lock should be true ONLY if the queue is zoned.
So the "&& blk_queue_is_zoned(q)" seems unnecessary to me.
This little helper could be moved to be generic in blkdev.h too.

> +}
> +
>  /*
>   * For the specified data direction, return the next request to
>   * dispatch using arrival ordered lists.
> @@ -353,7 +363,7 @@ deadline_fifo_request(struct deadline_data *dd, struct dd_per_prio *per_prio,
>  		return NULL;
>  
>  	rq = rq_entry_fifo(per_prio->fifo_list[data_dir].next);
> -	if (data_dir == DD_READ || !blk_queue_is_zoned(rq->q))
> +	if (data_dir == DD_READ || !dd_use_zone_write_locking(rq->q))
>  		return rq;
>  
>  	/*
> @@ -398,7 +408,7 @@ deadline_next_request(struct deadline_data *dd, struct dd_per_prio *per_prio,
>  	if (!rq)
>  		return NULL;
>  
> -	if (data_dir == DD_READ || !blk_queue_is_zoned(rq->q))
> +	if (data_dir == DD_READ || !dd_use_zone_write_locking(rq->q))
>  		return rq;
>  
>  	/*
> @@ -526,8 +536,9 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
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
> @@ -552,7 +563,8 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
>  	/*
>  	 * If the request needs its target zone locked, do it.
>  	 */
> -	blk_req_zone_write_lock(rq);
> +	if (dd_use_zone_write_locking(rq->q))
> +		blk_req_zone_write_lock(rq);
>  	rq->rq_flags |= RQF_STARTED;
>  	return rq;
>  }
> @@ -934,7 +946,7 @@ static void dd_finish_request(struct request *rq)
>  
>  	atomic_inc(&per_prio->stats.completed);
>  
> -	if (blk_queue_is_zoned(q)) {
> +	if (dd_use_zone_write_locking(rq->q)) {
>  		unsigned long flags;
>  
>  		spin_lock_irqsave(&dd->zone_lock, flags);

-- 
Damien Le Moal
Western Digital Research

