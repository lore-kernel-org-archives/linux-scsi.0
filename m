Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC32C41513
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 11:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350112AbjHQLCD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 07:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350204AbjHQLBa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 07:01:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3292D78;
        Thu, 17 Aug 2023 04:01:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B237063496;
        Thu, 17 Aug 2023 11:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BA6C433C8;
        Thu, 17 Aug 2023 11:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692270080;
        bh=NxwG7nqbQi0pWVUN3Nm1m8HI9r6b0qPeq/ibhoYdS9w=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Usv8QoEhrbndl9Z9ETO9IQ5juJ/VN1lqdjAWSH29Iu73DRUZR7pafYzjDo2tFlUPc
         F6i82JpRSs5ZqurdkV1kVGhdg9j1FjonDEM8WUwAhrzFJcBcBoJKqv9hopGVohpyr+
         ZiPIgudhhGS6U58Th6nGMAEByogS6WCPJMF7+VUg/XShthq9NbTUUC7jSQKmVMgK7q
         JjnIDeuSi6QfYANYCnpK3lDM8JmYSgzof3kl/etYnne5hkW7p9VQPMjJB2Q7nabS2q
         Of9LyJV0fIS0kIjHtL1z78XGAfGNHFG0sIQsIpm5T1d+ZQpbpf+7vbZlCNyqBMZLiY
         yikbgQLcIjiEw==
Message-ID: <0b3b4453-52a1-75e3-4dfd-6aae74c8c257@kernel.org>
Date:   Thu, 17 Aug 2023 20:01:18 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v9 02/17] block: Only use write locking if necessary
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-3-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230816195447.3703954-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/23 04:53, Bart Van Assche wrote:
> Make blk_req_needs_zone_write_lock() return false if
> q->limits.use_zone_write_lock is false. Inline this function because it
> is short and because it is called from the hot path of the mq-deadline
> I/O scheduler.

Your are not actually inlining the function. Did you forget to move it to
blkdev.h ?

Otherwise, the change looks OK.

> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-zoned.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 112620985bff..d8a80cce832f 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -53,11 +53,16 @@ const char *blk_zone_cond_str(enum blk_zone_cond zone_cond)
>  EXPORT_SYMBOL_GPL(blk_zone_cond_str);
>  
>  /*
> - * Return true if a request is a write requests that needs zone write locking.
> + * Return true if a request is a write request that needs zone write locking.
>   */
>  bool blk_req_needs_zone_write_lock(struct request *rq)
>  {
> -	if (!rq->q->disk->seq_zones_wlock)
> +	struct request_queue *q = rq->q;
> +
> +	if (!q->limits.use_zone_write_lock)
> +		return false;
> +
> +	if (!q->disk->seq_zones_wlock)
>  		return false;
>  
>  	return blk_rq_is_seq_zoned_write(rq);

-- 
Damien Le Moal
Western Digital Research

