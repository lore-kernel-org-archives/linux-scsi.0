Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A4F3C07E95
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 17:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E231D610C7
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 17:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbhGTQ0c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Jul 2021 12:26:32 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3439 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhGTQZI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jul 2021 12:25:08 -0400
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GTlHW1hQMz6FD8P;
        Wed, 21 Jul 2021 00:56:55 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 20 Jul 2021 19:05:44 +0200
Received: from [10.47.85.214] (10.47.85.214) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 20 Jul
 2021 18:05:43 +0100
Subject: Re: [PATCH 0/9] blk-mq: Reduce static requests memory footprint for
 shared sbitmap
To:     Ming Lei <ming.lei@redhat.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>,
        "hare@suse.de" <hare@suse.de>
References: <1626275195-215652-1-git-send-email-john.garry@huawei.com>
 <YPbqMSjZIA8l0jHQ@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <22a23f4d-9d6b-308d-7a32-75c5adffe8d2@huawei.com>
Date:   Tue, 20 Jul 2021 18:05:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <YPbqMSjZIA8l0jHQ@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.85.214]
X-ClientProxiedBy: lhreml712-chm.china.huawei.com (10.201.108.63) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/07/2021 16:22, Ming Lei wrote:
> On Wed, Jul 14, 2021 at 11:06:26PM +0800, John Garry wrote:
>> Currently a full set of static requests are allocated per hw queue per
>> tagset when shared sbitmap is used.
>>
>> However, only tagset->queue_depth number of requests may be active at
>> any given time. As such, only tagset->queue_depth number of static
>> requests are required.
>>
>> The same goes for using an IO scheduler, which allocates a full set of
>> static requests per hw queue per request queue.
>>
>> This series very significantly reduces memory usage in both scenarios by
>> allocating static rqs per tagset and per request queue, respectively,
>> rather than per hw queue per tagset and per request queue.
>>
>> For megaraid sas driver on my 128-CPU arm64 system with 1x SATA disk, we
>> save approx. 300MB(!) [370MB -> 60MB]
>>
>> A couple of patches are marked as RFC, as maybe there is a better
>> implementation approach.

Hi Ming,

To be clear, my concerns with my implementation were:
a. Interface of __blk_mq_{alloc,free}_rqs was a bit strange in passing a 
struct list_head * and struct request ** . But maybe it's ok.
b. We need to ensure that the host should not expect a set of static rqs 
per hw queue, i.e. should not use blk_mq_ops.init_request hctx_idx 
argument. The guard I have added is effectively useless against that. I 
am thinking that we should have a variant of blk_mq_ops.init_request 
without a hctx_idx argument, which needs to be used for shared sbitmap.

> 
> There is another candidate for addressing this issue, and looks simpler:

Thanks, I think that this solution does not deal with b., above, either.

> 
>   block/blk-mq-sched.c |  4 ++++
>   block/blk-mq-tag.c   |  4 ++++
>   block/blk-mq-tag.h   |  3 +++
>   block/blk-mq.c       | 18 ++++++++++++++++++
>   block/blk-mq.h       | 11 +++++++++++
>   5 files changed, 40 insertions(+)
> 
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index c838d81ac058..b9236ee0fe4e 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -538,6 +538,10 @@ static int blk_mq_sched_alloc_tags(struct request_queue *q,
>   	if (!hctx->sched_tags)
>   		return -ENOMEM;
>   
> +	blk_mq_set_master_tags(hctx->sched_tags,
> +			q->queue_hw_ctx[0]->sched_tags, hctx->flags,
> +			hctx_idx);
> +
>   	ret = blk_mq_alloc_rqs(set, hctx->sched_tags, hctx_idx, q->nr_requests);
>   	if (ret)
>   		blk_mq_sched_free_tags(set, hctx, hctx_idx);
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 86f87346232a..c471a073234d 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -608,6 +608,10 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
>   				tags->nr_reserved_tags, set->flags);
>   		if (!new)
>   			return -ENOMEM;
> +
> +		blk_mq_set_master_tags(new,
> +			hctx->queue->queue_hw_ctx[0]->sched_tags, set->flags,
> +			hctx->queue_num);
>   		ret = blk_mq_alloc_rqs(set, new, hctx->queue_num, tdepth);
>   		if (ret) {
>   			blk_mq_free_rq_map(new, set->flags);
> diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
> index 8ed55af08427..0a3fbbc61e06 100644
> --- a/block/blk-mq-tag.h
> +++ b/block/blk-mq-tag.h
> @@ -21,6 +21,9 @@ struct blk_mq_tags {
>   	struct request **static_rqs;
>   	struct list_head page_list;
>   
> +	/* only used for blk_mq_is_sbitmap_shared() */
> +	struct blk_mq_tags	*master;

It is a bit odd to have a pointer to struct blk_mq_tags in struct 
blk_mq_tags like this

> +
>   	/*
>   	 * used to clear request reference in rqs[] before freeing one
>   	 * request pool
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 2c4ac51e54eb..ef8a6a7e5f7c 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2348,6 +2348,15 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
>   {
>   	struct page *page;
>   
> +	if (blk_mq_is_sbitmap_shared(set->flags)) {
> +		if (tags->master)
> +			tags = tags->master;
> +		if (hctx_idx < set->nr_hw_queues - 1) {
> +			blk_mq_clear_rq_mapping(set, tags, hctx_idx);
> +			return;
> +		}
> +	}
> +
>   	if (tags->rqs && set->ops->exit_request) {
>   		int i;
>   
> @@ -2444,6 +2453,12 @@ int blk_mq_alloc_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
>   	size_t rq_size, left;
>   	int node;
>   
> +	if (blk_mq_is_sbitmap_shared(set->flags) && tags->master) {
> +		memcpy(tags->static_rqs, tags->master->static_rqs,
> +		       sizeof(tags->static_rqs[0]) * tags->nr_tags);
> +		return 0;
> +	}
> +
>   	node = blk_mq_hw_queue_to_node(&set->map[HCTX_TYPE_DEFAULT], hctx_idx);
>   	if (node == NUMA_NO_NODE)
>   		node = set->numa_node;
> @@ -2860,6 +2875,9 @@ static bool __blk_mq_alloc_map_and_request(struct blk_mq_tag_set *set,
>   	if (!set->tags[hctx_idx])
>   		return false;
>   
> +	blk_mq_set_master_tags(set->tags[hctx_idx], set->tags[0], flags,
> +			       hctx_idx);
> +
>   	ret = blk_mq_alloc_rqs(set, set->tags[hctx_idx], hctx_idx,
>   				set->queue_depth);
>   	if (!ret)
> diff --git a/block/blk-mq.h b/block/blk-mq.h
> index d08779f77a26..a08b89be6acc 100644
> --- a/block/blk-mq.h
> +++ b/block/blk-mq.h
> @@ -354,5 +354,16 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
>   	return __blk_mq_active_requests(hctx) < depth;
>   }
>   
> +static inline void blk_mq_set_master_tags(struct blk_mq_tags *tags,
> +		struct blk_mq_tags *master_tags, unsigned int flags,
> +		unsigned int hctx_idx)
> +{
> +	if (blk_mq_is_sbitmap_shared(flags)) {
> +		if (hctx_idx)
> +			tags->master = master_tags;
> +		else
> +			tags->master = NULL;
> +	}
> +}
>   
>   #endif
> 

I'll check this solution a bit further.

Thanks,
John
