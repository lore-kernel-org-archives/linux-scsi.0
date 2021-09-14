Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 963C1C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 08:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74BE660F24
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 08:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhINIYq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 04:24:46 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3787 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhINIYq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 04:24:46 -0400
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H7xBk0RTxz67Xb5;
        Tue, 14 Sep 2021 16:21:18 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 14 Sep 2021 10:23:25 +0200
Received: from [10.47.80.114] (10.47.80.114) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Tue, 14 Sep
 2021 09:23:25 +0100
Subject: Re: [PATCH RESEND v3 12/13] blk-mq: Use shared tags for shared
 sbitmap support
To:     Hannes Reinecke <hare@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <1631545950-56586-1-git-send-email-john.garry@huawei.com>
 <1631545950-56586-13-git-send-email-john.garry@huawei.com>
 <05804d91-4392-260d-34f2-618b0d3b3f7f@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <664ba62f-ccbf-ac0c-548e-e15561b82224@huawei.com>
Date:   Tue, 14 Sep 2021 09:27:04 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <05804d91-4392-260d-34f2-618b0d3b3f7f@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.80.114]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

...

>>    static int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue)
>>    {
>>    	struct blk_mq_tag_set *set = queue->tag_set;
>> -	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags);
>> -	struct blk_mq_hw_ctx *hctx;
>> -	int ret, i;
>>    
>>    	/*
>>    	 * Set initial depth at max so that we don't need to reallocate for
>>    	 * updating nr_requests.
>>    	 */
>> -	ret = blk_mq_init_bitmaps(&queue->sched_bitmap_tags,
>> -				  &queue->sched_breserved_tags,
>> -				  MAX_SCHED_RQ, set->reserved_tags,
>> -				  set->numa_node, alloc_policy);
>> -	if (ret)
>> -		return ret;
>> -
>> -	queue_for_each_hw_ctx(queue, hctx, i) {
>> -		hctx->sched_tags->bitmap_tags =
>> -					&queue->sched_bitmap_tags;
>> -		hctx->sched_tags->breserved_tags =
>> -					&queue->sched_breserved_tags;
>> -	}
>> +	queue->shared_sbitmap_tags = blk_mq_alloc_map_and_rqs(set,
>> +						BLK_MQ_NO_HCTX_IDX,
>> +						MAX_SCHED_RQ);
>> +	if (!queue->shared_sbitmap_tags)
>> +		return -ENOMEM;
>>    
> 
> Any particular reason why the 'shared_sbitmap_tags' pointer is added to
> the request queue and not the tagset?
> Everything else is located there, so I would have found it more logical
> to add the 'shared_sbitmap_tags' pointer to the tagset, not the queue ...
> 

We already have it for both. Since commit d97e594c5166 ("blk-mq: Use 
request queue-wide tags for tagset-wide sbitmap"), we have a "shared 
sbitmap" per tagset and per request queue. If you check d97e594c5166 
then it should explain the reason.

>>    	blk_mq_tag_update_sched_shared_sbitmap(queue);
>>    
>>    	return 0;
>>    }
>>    
>> -static void blk_mq_exit_sched_shared_sbitmap(struct request_queue *queue)
>> -{
>> -	sbitmap_queue_free(&queue->sched_bitmap_tags);
>> -	sbitmap_queue_free(&queue->sched_breserved_tags);
>> -}
>> -
>>    int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>>    {
>> +	unsigned int i, flags = q->tag_set->flags;
>>    	struct blk_mq_hw_ctx *hctx;
>>    	struct elevator_queue *eq;
>> -	unsigned int i;
>>    	int ret;
>>    
>>    	if (!e) {
>> @@ -598,21 +596,21 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>>    	q->nr_requests = 2 * min_t(unsigned int, q->tag_set->queue_depth,
>>    				   BLKDEV_DEFAULT_RQ);
>>    
>> -	queue_for_each_hw_ctx(q, hctx, i) {
>> -		ret = blk_mq_sched_alloc_map_and_rqs(q, hctx, i);
>> +	if (blk_mq_is_sbitmap_shared(flags)) {
>> +		ret = blk_mq_init_sched_shared_sbitmap(q); >   		if (ret)
>> -			goto err_free_map_and_rqs;
>> +			return ret;
>>    	}
>>    
>> -	if (blk_mq_is_sbitmap_shared(q->tag_set->flags)) {
>> -		ret = blk_mq_init_sched_shared_sbitmap(q);
>> +	queue_for_each_hw_ctx(q, hctx, i) {
>> +		ret = blk_mq_sched_alloc_map_and_rqs(q, hctx, i);
>>    		if (ret)
>>    			goto err_free_map_and_rqs;
>>    	}
>>    
>>    	ret = e->ops.init_sched(q, e);
>>    	if (ret)
>> -		goto err_free_sbitmap;
>> +		goto err_free_map_and_rqs;
>>    
>>    	blk_mq_debugfs_register_sched(q);
>>    
>> @@ -632,12 +630,10 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>>    
>>    	return 0;
>>    
>> -err_free_sbitmap:
>> -	if (blk_mq_is_sbitmap_shared(q->tag_set->flags))
>> -		blk_mq_exit_sched_shared_sbitmap(q);
>> -	blk_mq_sched_free_rqs(q);
>>    err_free_map_and_rqs:
>> -	blk_mq_sched_tags_teardown(q);
>> +	blk_mq_sched_free_rqs(q);
>> +	blk_mq_sched_tags_teardown(q, flags);
>> +
>>    	q->elevator = NULL;
>>    	return ret;
>>    }
>> @@ -651,9 +647,15 @@ void blk_mq_sched_free_rqs(struct request_queue *q)
>>    	struct blk_mq_hw_ctx *hctx;
>>    	int i;
>>    
>> -	queue_for_each_hw_ctx(q, hctx, i) {
>> -		if (hctx->sched_tags)
>> -			blk_mq_free_rqs(q->tag_set, hctx->sched_tags, i);
>> +	if (blk_mq_is_sbitmap_shared(q->tag_set->flags)) {
>> +		blk_mq_free_rqs(q->tag_set, q->shared_sbitmap_tags,
>> +				BLK_MQ_NO_HCTX_IDX);
> 
> 'if (q->shared_sbitmap_tags)'
> 
> would be more obvious here ...

I suppose so. I am just doing it this way for consistency.

> 
>> +	} else {
>> +		queue_for_each_hw_ctx(q, hctx, i) {
>> +			if (hctx->sched_tags)
>> +				blk_mq_free_rqs(q->tag_set,
>> +						hctx->sched_tags, i);
>> +		}
>>    	}
>>    }
>>    

...

>>    };
>> @@ -432,6 +429,8 @@ enum {
>>    	((policy & ((1 << BLK_MQ_F_ALLOC_POLICY_BITS) - 1)) \
>>    		<< BLK_MQ_F_ALLOC_POLICY_START_BIT)
>>    
>> +#define BLK_MQ_NO_HCTX_IDX	(-1U)
>> +
>>    struct gendisk *__blk_mq_alloc_disk(struct blk_mq_tag_set *set, void *queuedata,
>>    		struct lock_class_key *lkclass);
>>    #define blk_mq_alloc_disk(set, queuedata)				\
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 4baf9435232d..17e50e5ef47b 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -459,8 +459,7 @@ struct request_queue {
>>    
>>    	atomic_t		nr_active_requests_shared_sbitmap;
>>    
>> -	struct sbitmap_queue	sched_bitmap_tags;
>> -	struct sbitmap_queue	sched_breserved_tags;
>> +	struct blk_mq_tags	*shared_sbitmap_tags;
>>    
>>    	struct list_head	icq_list;
>>    #ifdef CONFIG_BLK_CGROUP
>>
> Why the double shared_sbitmap_tags pointer in struct request_queue and
> struct tag_set? To my knowledge there's a 1:1 relationship between
> request_queue and tag_set, so where's the point?
> 

As above, we also added a shared sbitmap per request queue.

The reason being that for "shared sbitmap" support, the request queue 
total depth should not grow for an increase in the number of HW queues.

Thanks,
John

