Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B85CC4320A
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 14:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 530F660560
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 14:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239221AbhHROVc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 10:21:32 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3666 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240449AbhHROTh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 10:19:37 -0400
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GqVNp380qz6D9Mx;
        Wed, 18 Aug 2021 22:18:02 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 18 Aug 2021 16:19:01 +0200
Received: from [10.202.227.179] (10.202.227.179) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 18 Aug 2021 15:19:00 +0100
Subject: Re: [PATCH v2 10/11] blk-mq: Use shared tags for shared sbitmap
 support
To:     Ming Lei <ming.lei@redhat.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>,
        "hare@suse.de" <hare@suse.de>
References: <1628519378-211232-1-git-send-email-john.garry@huawei.com>
 <1628519378-211232-11-git-send-email-john.garry@huawei.com>
 <YRzB+aCVVSP+OmE4@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <e8fdad10-f162-78be-c24a-417d7aee45df@huawei.com>
Date:   Wed, 18 Aug 2021 15:18:59 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <YRzB+aCVVSP+OmE4@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-ClientProxiedBy: lhreml748-chm.china.huawei.com (10.201.108.198) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/08/2021 09:16, Ming Lei wrote:
> On Mon, Aug 09, 2021 at 10:29:37PM +0800, John Garry wrote:
>> Currently we use separate sbitmap pairs and active_queues atomic_t for
>> shared sbitmap support.
>>
>> However a full set of static requests are used per HW queue, which is
>> quite wasteful, considering that the total number of requests usable at
>> any given time across all HW queues is limited by the shared sbitmap depth.
>>
>> As such, it is considerably more memory efficient in the case of shared
>> sbitmap to allocate a set of static rqs per tag set or request queue, and
>> not per HW queue.
>>
>> So replace the sbitmap pairs and active_queues atomic_t with a shared
>> tags per tagset and request queue.
> 
> This idea looks good and the current implementation is simplified a bit
> too.

Good, but you did hint at it :)

> 
>>
>> Continue to use term "shared sbitmap" for now, as the meaning is known.
> 
> I guess shared tags is better.

Yeah, agreed. My preference would be to change later, once things settle 
down.

As I see, the only thing close to an ABI is the debugfs "flags" code, 
but that's debugfs, so not stable.

> 
>>
>> Signed-off-by: John Garry <john.garry@huawei.com>
>> ---
>>   block/blk-mq-sched.c   | 77 ++++++++++++++++++++-----------------
>>   block/blk-mq-tag.c     | 65 ++++++++++++-------------------
>>   block/blk-mq-tag.h     |  4 +-
>>   block/blk-mq.c         | 86 +++++++++++++++++++++++++-----------------
>>   block/blk-mq.h         |  8 ++--
>>   include/linux/blk-mq.h | 13 +++----
>>   include/linux/blkdev.h |  3 +-
>>   7 files changed, 131 insertions(+), 125 deletions(-)
>>
>> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c

...

>> +
>>   static int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue)
>>   {
>>   	struct blk_mq_tag_set *set = queue->tag_set;
>> -	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags);
>> -	struct blk_mq_hw_ctx *hctx;
>> -	int ret, i;
>> +	struct blk_mq_tags *tags;
>> +	int ret;
>>   
>>   	/*
>>   	 * Set initial depth at max so that we don't need to reallocate for
>>   	 * updating nr_requests.
>>   	 */
>> -	ret = blk_mq_init_bitmaps(&queue->sched_bitmap_tags,
>> -				  &queue->sched_breserved_tags,
>> -				  MAX_SCHED_RQ, set->reserved_tags,
>> -				  set->numa_node, alloc_policy);
>> -	if (ret)
>> -		return ret;
>> +	tags = queue->shared_sbitmap_tags = blk_mq_alloc_rq_map(set, 0,
>> +					  set->queue_depth,
>> +					  set->reserved_tags);
>> +	if (!queue->shared_sbitmap_tags)
>> +		return -ENOMEM;
>>   
>> -	queue_for_each_hw_ctx(queue, hctx, i) {
>> -		hctx->sched_tags->bitmap_tags =
>> -					&queue->sched_bitmap_tags;
>> -		hctx->sched_tags->breserved_tags =
>> -					&queue->sched_breserved_tags;
>> +	ret = blk_mq_alloc_rqs(set, tags, 0, set->queue_depth);
>> +	if (ret) {
>> +		blk_mq_exit_sched_shared_sbitmap(queue);
>> +		return ret;
> 
> There are two such patterns for allocate rq map and request pool
> together, please put them into one helper(such as blk_mq_alloc_map_and_rqs)
> which can return the allocated tags and handle failure inline. Also we may
> convert current users into this helper.

I'll have a look, but I will mention about "free" helper below

> 
>>   	}
>>   
>>   	blk_mq_tag_update_sched_shared_sbitmap(queue);
>> @@ -580,12 +589,6 @@ static int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue)
>>   	return 0;
>>   }
>>   
>> -static void blk_mq_exit_sched_shared_sbitmap(struct request_queue *queue)
>> -{
>> -	sbitmap_queue_free(&queue->sched_bitmap_tags);
>> -	sbitmap_queue_free(&queue->sched_breserved_tags);
>> -}
>> -

...

>>   
>> -void blk_mq_free_tags(struct blk_mq_tags *tags, unsigned int flags)
>> +void blk_mq_free_tags(struct blk_mq_tags *tags)
>>   {
>> -	if (!blk_mq_is_sbitmap_shared(flags)) {
>> -		sbitmap_queue_free(tags->bitmap_tags);
>> -		sbitmap_queue_free(tags->breserved_tags);
>> -	}
>> +	sbitmap_queue_free(tags->bitmap_tags);
>> +	sbitmap_queue_free(tags->breserved_tags);
>>   	kfree(tags);
>>   }
>>   
>> @@ -604,18 +580,25 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
>>   		if (tdepth > MAX_SCHED_RQ)
>>   			return -EINVAL;
>>   
>> +		if (blk_mq_is_sbitmap_shared(set->flags)) {
>> +			/* No point in allowing this to happen */
>> +			if (tdepth > set->queue_depth)
>> +				return -EINVAL;
>> +			return 0;
>> +		}
> 
> The above looks wrong, it isn't unusual to see small queue depth
> hardware meantime we often have scheduler queue depth of 2 * set->queue_depth.

ok, I suppose you're right.

> 
>> +
>>   		new = blk_mq_alloc_rq_map(set, hctx->queue_num, tdepth,
>> -				tags->nr_reserved_tags, set->flags);
>> +				tags->nr_reserved_tags);
>>   		if (!new)
>>   			return -ENOMEM;
>>   		ret = blk_mq_alloc_rqs(set, new, hctx->queue_num, tdepth);
>>   		if (ret) {
>> -			blk_mq_free_rq_map(new, set->flags);
>> +			blk_mq_free_rq_map(new);
>>   			return -ENOMEM;
>>   		}
>>   
>>   		blk_mq_free_rqs(set, *tagsptr, hctx->queue_num);
>> -		blk_mq_free_rq_map(*tagsptr, set->flags);
>> +		blk_mq_free_rq_map(*tagsptr);
>>   		*tagsptr = new;
>>   	} else {
>>   		/*
>> @@ -631,12 +614,14 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
>>   
>>   void blk_mq_tag_resize_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int size)
>>   {
>> -	sbitmap_queue_resize(&set->__bitmap_tags, size - set->reserved_tags);
>> +	struct blk_mq_tags *tags = set->shared_sbitmap_tags;
>> +
>> +	sbitmap_queue_resize(&tags->__bitmap_tags, size - set->reserved_tags);
>>   }
>>   
>>   void blk_mq_tag_update_sched_shared_sbitmap(struct request_queue *q)
>>   {
>> -	sbitmap_queue_resize(&q->sched_bitmap_tags,
>> +	sbitmap_queue_resize(q->shared_sbitmap_tags->bitmap_tags,
>>   			     q->nr_requests - q->tag_set->reserved_tags);
>>   }
>>   
>> diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
>> index 88f3c6485543..c9fc52ee07c4 100644
>> --- a/block/blk-mq-tag.h
>> +++ b/block/blk-mq-tag.h
>> @@ -30,8 +30,8 @@ struct blk_mq_tags {
>>   
>>   extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
>>   					unsigned int reserved_tags,
>> -					int node, unsigned int flags);
>> -extern void blk_mq_free_tags(struct blk_mq_tags *tags, unsigned int flags);
>> +					int node, int alloc_policy);
>> +extern void blk_mq_free_tags(struct blk_mq_tags *tags);
>>   extern int blk_mq_init_bitmaps(struct sbitmap_queue *bitmap_tags,
>>   			       struct sbitmap_queue *breserved_tags,
>>   			       unsigned int queue_depth,
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 4d6723cfa582..d3dd5fab3426 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -2348,6 +2348,9 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
>>   	struct blk_mq_tags *drv_tags;
>>   	struct page *page;
>>   
>> +	if (blk_mq_is_sbitmap_shared(set->flags))
>> +		drv_tags = set->shared_sbitmap_tags;
>> +	else
>>   		drv_tags = set->tags[hctx_idx];
> 
> Here I guess you need to avoid to double ->exit_request()?

I'll check that doesn't occur, but I didn't think it did.

> 
>>   
>>   	if (tags->static_rqs && set->ops->exit_request) {
>> @@ -2377,21 +2380,20 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
>>   	}
>>   }
>>   
>> -void blk_mq_free_rq_map(struct blk_mq_tags *tags, unsigned int flags)
>> +void blk_mq_free_rq_map(struct blk_mq_tags *tags)
>>   {
>>   	kfree(tags->rqs);
>>   	tags->rqs = NULL;
>>   	kfree(tags->static_rqs);
>>   	tags->static_rqs = NULL;
>>   
>> -	blk_mq_free_tags(tags, flags);
>> +	blk_mq_free_tags(tags);
>>   }
>>   

...

>>   }
>> @@ -2877,11 +2886,11 @@ static bool __blk_mq_alloc_map_and_request(struct blk_mq_tag_set *set,
>>   static void blk_mq_free_map_and_requests(struct blk_mq_tag_set *set,
>>   					 unsigned int hctx_idx)
>>   {
>> -	unsigned int flags = set->flags;
>> -
>>   	if (set->tags && set->tags[hctx_idx]) {
>> -		blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
>> -		blk_mq_free_rq_map(set->tags[hctx_idx], flags);
>> +		if (!blk_mq_is_sbitmap_shared(set->flags)) {
> 
> I remember you hate negative check, :-)

Not always, but sometimes I think the code harder to read with them.

> 
>> +			blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
>> +			blk_mq_free_rq_map(set->tags[hctx_idx]);
> 
> We can add one helper of blk_mq_free_map_and_rqs(), and there seems
> several such pattern.

ok, I can check, but I don't think it's useful in the blk-mq sched code 
as the tags and rqs are freed separately there, so not sure on how much 
we gain.

> 
>> +		}
>>   		set->tags[hctx_idx] = NULL;
>>   	}
>>   }
>> @@ -3348,6 +3357,21 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
>>   {
>>   	int i;
>>   
>> +	if (blk_mq_is_sbitmap_shared(set->flags)) {
>> +		int ret;
>> +
>> +		set->shared_sbitmap_tags = blk_mq_alloc_rq_map(set, 0,
>> +						  set->queue_depth,
>> +						  set->reserved_tags);
>> +		if (!set->shared_sbitmap_tags)
>> +			return -ENOMEM;
>> +
>> +		ret = blk_mq_alloc_rqs(set, set->shared_sbitmap_tags, 0,
>> +				       set->queue_depth);
>> +		if (ret)
>> +			goto out_free_sbitmap_tags;
>> +	}
>> +
>>   	for (i = 0; i < set->nr_hw_queues; i++) {
>>   		if (!__blk_mq_alloc_map_and_request(set, i))
>>   			goto out_unwind;
>> @@ -3359,6 +3383,11 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
>>   out_unwind:
>>   	while (--i >= 0)
>>   		blk_mq_free_map_and_requests(set, i);
>> +	if (blk_mq_is_sbitmap_shared(set->flags))
>> +		blk_mq_free_rqs(set, set->shared_sbitmap_tags, 0);
>> +out_free_sbitmap_tags:
>> +	if (blk_mq_is_sbitmap_shared(set->flags))
>> +		blk_mq_exit_shared_sbitmap(set);
> 
> Once a helper of blk_mq_alloc_map_and_rqs() is added, the above failure
> handling can be simplified too.
> 
> 

OK

Thanks a lot,
John


