Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60023C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 05:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4766761155
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 05:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239639AbhINFlt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 01:41:49 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:54844 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239499AbhINFls (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 01:41:48 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BAD01220AF;
        Tue, 14 Sep 2021 05:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631598030; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bBTIyk2Jw8pTCwo5fmyzWPO7SApQGjflPJngKNpP8WI=;
        b=M8Oe5bV/wo9LJ9yymUZynO24YhHxCJHlZgI50F2ue/CaIm5tEflr6KfWcqg86wZNcO9WTL
        L+n5DXlRB4OB/pswkGxzR/YX1fK8HiLWSZDsx7O+ujMFTYKIbhxhvjEWZqTetQVfEmb2b4
        b7+bimzHpnT7MHfGbWfF4n5Z01s0mKA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631598030;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bBTIyk2Jw8pTCwo5fmyzWPO7SApQGjflPJngKNpP8WI=;
        b=UI87ipDu1fpwpGZ+TysEbEdEv950z784K+SdN0vyI0RuNceYu37NPw8M2TXglIO5ElPomZ
        A1mb4H5dUS+fncAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8DAB713E4A;
        Tue, 14 Sep 2021 05:40:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hRrcIc41QGHKUAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 14 Sep 2021 05:40:30 +0000
Subject: Re: [PATCH RESEND v3 05/13] blk-mq-sched: Rename
 blk_mq_sched_alloc_{tags -> map_and_rqs}()
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        ming.lei@redhat.com, linux-scsi@vger.kernel.org
References: <1631545950-56586-1-git-send-email-john.garry@huawei.com>
 <1631545950-56586-6-git-send-email-john.garry@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <bcbc3479-86f9-6d72-44a5-aacd4f03fcc2@suse.de>
Date:   Tue, 14 Sep 2021 07:40:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1631545950-56586-6-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/13/21 5:12 PM, John Garry wrote:
> Function blk_mq_sched_alloc_tags() does same as
> __blk_mq_alloc_map_and_request(), so give a similar name to be consistent.
> 
> Similarly rename label err_free_tags -> err_free_map_and_rqs.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> ---
>   block/blk-mq-sched.c | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index 2231fb0d4c35..5f340203e6e5 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -515,9 +515,9 @@ void blk_mq_sched_insert_requests(struct blk_mq_hw_ctx *hctx,
>   	percpu_ref_put(&q->q_usage_counter);
>   }
>   
> -static int blk_mq_sched_alloc_tags(struct request_queue *q,
> -				   struct blk_mq_hw_ctx *hctx,
> -				   unsigned int hctx_idx)
> +static int blk_mq_sched_alloc_map_and_rqs(struct request_queue *q,
> +					  struct blk_mq_hw_ctx *hctx,
> +					  unsigned int hctx_idx)
>   {
>   	struct blk_mq_tag_set *set = q->tag_set;
>   	int ret;
> @@ -609,15 +609,15 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>   				   BLKDEV_DEFAULT_RQ);
>   
>   	queue_for_each_hw_ctx(q, hctx, i) {
> -		ret = blk_mq_sched_alloc_tags(q, hctx, i);
> +		ret = blk_mq_sched_alloc_map_and_rqs(q, hctx, i);
>   		if (ret)
> -			goto err_free_tags;
> +			goto err_free_map_and_rqs;
>   	}
>   
>   	if (blk_mq_is_sbitmap_shared(q->tag_set->flags)) {
>   		ret = blk_mq_init_sched_shared_sbitmap(q);
>   		if (ret)
> -			goto err_free_tags;
> +			goto err_free_map_and_rqs;
>   	}
>   
>   	ret = e->ops.init_sched(q, e);
> @@ -645,8 +645,8 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>   err_free_sbitmap:
>   	if (blk_mq_is_sbitmap_shared(q->tag_set->flags))
>   		blk_mq_exit_sched_shared_sbitmap(q);
> -err_free_tags:
>   	blk_mq_sched_free_requests(q);
> +err_free_map_and_rqs:
>   	blk_mq_sched_tags_teardown(q);
>   	q->elevator = NULL;
>   	return ret;
> 
This is not only a rename, but it also moves the location of the label.
Is that intended?
If so it needs some documentation why this is safe.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
