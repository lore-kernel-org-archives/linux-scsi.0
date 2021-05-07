Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F4BC433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 10:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 144EA6143F
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 10:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbhEGKRC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 May 2021 06:17:02 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3039 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhEGKRB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 May 2021 06:17:01 -0400
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Fc5jh2Bw7z71ffb;
        Fri,  7 May 2021 18:07:52 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 7 May 2021 12:15:58 +0200
Received: from [10.47.82.108] (10.47.82.108) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 7 May 2021
 11:15:57 +0100
Subject: Re: [PATCH] blk-mq: Use request queue-wide tags for tagset-wide
 sbitmap
To:     Ming Lei <ming.lei@redhat.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        "yama@redhat.com" <yama@redhat.com>
References: <1620037333-2495-1-git-send-email-john.garry@huawei.com>
 <YJOph1oI8CTJjzQx@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <4d5893e2-13f0-ce6f-4fd7-44c7ecf8553f@huawei.com>
Date:   Fri, 7 May 2021 11:15:28 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <YJOph1oI8CTJjzQx@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.82.108]
X-ClientProxiedBy: lhreml719-chm.china.huawei.com (10.201.108.70) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/05/2021 09:32, Ming Lei wrote:
>> +	if (blk_mq_is_sbitmap_shared(q->tag_set->flags)) {
>> +		ret = blk_mq_init_sched_shared_sbitmap(q);
>> +		if (ret)
>> +			goto err_free_tags;
>> +
>> +		queue_for_each_hw_ctx(q, hctx, i) {
>> +			hctx->sched_tags->bitmap_tags =
>> +					q->sched_bitmap_tags;
>> +			hctx->sched_tags->breserved_tags =
>> +					q->sched_breserved_tags;
>> +		}
>>   	}
>>   
>>   	ret = e->ops.init_sched(q, e);
>>   	if (ret)
>> -		goto err;
>> +		goto err_free_sbitmap;
>>   
>>   	blk_mq_debugfs_register_sched(q);
>>   
>> @@ -584,6 +590,7 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>>   				eq = q->elevator;
>>   				blk_mq_sched_free_requests(q);
>>   				blk_mq_exit_sched(q, eq);
>> +				blk_mq_exit_sched_shared_sbitmap(q);
> blk_mq_exit_sched_shared_sbitmap() has been called in blk_mq_exit_sched() already.

ah, yes

> 
>>   				kobject_put(&eq->kobj);
>>   				return ret;
>>   			}
>> @@ -593,7 +600,10 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>>   
>>   	return 0;
>>   
>> -err:
>> +err_free_sbitmap:
>> +	if (blk_mq_is_sbitmap_shared(q->tag_set->flags))
>> +		blk_mq_exit_sched_shared_sbitmap(q);
>> +err_free_tags:
>>   	blk_mq_sched_free_requests(q);
>>   	blk_mq_sched_tags_teardown(q);
>>   	q->elevator = NULL;
>> @@ -631,5 +641,7 @@ void blk_mq_exit_sched(struct request_queue *q, struct elevator_queue *e)
>>   	if (e->type->ops.exit_sched)
>>   		e->type->ops.exit_sched(e);
>>   	blk_mq_sched_tags_teardown(q);
>> +	if (blk_mq_is_sbitmap_shared(q->tag_set->flags))
>> +		blk_mq_exit_sched_shared_sbitmap(q);
>>   	q->elevator = NULL;
>>   }
>> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
>> index 2a37731e8244..734fedceca7d 100644
>> --- a/block/blk-mq-tag.c
>> +++ b/block/blk-mq-tag.c
>> @@ -466,19 +466,40 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
>>   	return -ENOMEM;
>>   }
>>   
>> -int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int flags)
>> +static int __blk_mq_init_bitmaps(struct sbitmap_queue *bitmap_tags,
>> +				 struct sbitmap_queue *breserved_tags,
>> +				 struct blk_mq_tag_set *set,
>> +				 unsigned int queue_depth,
>> +				 unsigned int reserved)
>>   {
>> -	unsigned int depth = set->queue_depth - set->reserved_tags;
>> +	unsigned int depth = queue_depth - reserved;
>>   	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags);
>>   	bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;
>> -	int i, node = set->numa_node;
>>   
>> -	if (bt_alloc(&set->__bitmap_tags, depth, round_robin, node))
>> +	if (bt_alloc(bitmap_tags, depth, round_robin, set->numa_node))
>>   		return -ENOMEM;
>> -	if (bt_alloc(&set->__breserved_tags, set->reserved_tags,
>> -		     round_robin, node))
>> +	if (bt_alloc(breserved_tags, set->reserved_tags,
>> +		     round_robin, set->numa_node))
>>   		goto free_bitmap_tags;
>>   
>> +	return 0;
>> +
>> +free_bitmap_tags:
>> +	sbitmap_queue_free(bitmap_tags);
>> +	return -ENOMEM;
>> +}
>> +
>> +int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set)
> IMO, this function should be named as blk_mq_init_shared_tags
> and moved to blk-mq-sched.c

But this is for regular tags.

I assume you mean blk_mq_init_sched_shared_sbitmap(), below.

If so, I can relocate it.

As for "sbitmap" vs "tags" in the name, I'm just being consistent 
between preexisting blk_mq_init_shared_sbitmap() and 
blk_mq_sbitmap_shared(),  and new blk_mq_init_sched_shared_sbitmap()

> 
>> +{
>> +	int i, ret;
>> +
>> +	ret = __blk_mq_init_bitmaps(&set->__bitmap_tags,
>> +				    &set->__breserved_tags,
>> +				    set, set->queue_depth,
>> +				    set->reserved_tags);
>> +	if (ret)
>> +		return ret;
>> +
>>   	for (i = 0; i < set->nr_hw_queues; i++) {
>>   		struct blk_mq_tags *tags = set->tags[i];
>>   
>> @@ -487,9 +508,6 @@ int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int flags)
>>   	}
>>   
>>   	return 0;
>> -free_bitmap_tags:
>> -	sbitmap_queue_free(&set->__bitmap_tags);
>> -	return -ENOMEM;
>>   }
>>   
>>   void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *set)
>> @@ -498,6 +516,52 @@ void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *set)
>>   	sbitmap_queue_free(&set->__breserved_tags);
>>   }
>>   
>> +#define MAX_SCHED_RQ (16 * BLKDEV_MAX_RQ)
>> +
>> +int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue)
>> +{
>> +	struct blk_mq_tag_set *set = queue->tag_set;
>> +	int ret;
>> +
>> +	queue->sched_bitmap_tags =
>> +		kmalloc(sizeof(*queue->sched_bitmap_tags), GFP_KERNEL);
>> +	queue->sched_breserved_tags =
>> +		kmalloc(sizeof(*queue->sched_breserved_tags), GFP_KERNEL);
>> +	if (!queue->sched_bitmap_tags || !queue->sched_breserved_tags)
>> +		goto err;
> The two sbitmap queues can be embedded into 'request queue', so that
> we can avoid to re-allocation in every elevator switch.

ok

> 
> I will ask Yanhui to test the patch and see if it can make a difference.

Thanks
