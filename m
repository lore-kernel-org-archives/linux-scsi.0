Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33904C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 14:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECAB961411
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 14:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhELOOE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 10:14:04 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3067 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhELOOC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 10:14:02 -0400
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FgGkT5k4Cz6wj4N;
        Wed, 12 May 2021 22:04:33 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 12 May 2021 16:12:46 +0200
Received: from [10.47.85.216] (10.47.85.216) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 12 May
 2021 15:12:45 +0100
Subject: Re: [PATCH v2] blk-mq: Use request queue-wide tags for tagset-wide
 sbitmap
To:     Ming Lei <ming.lei@redhat.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        "yama@redhat.com" <yama@redhat.com>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>
References: <1620749743-36000-1-git-send-email-john.garry@huawei.com>
 <YJs2KWMCn2kpyryT@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <06b5ab3f-467a-44eb-c997-5a85508dbcda@huawei.com>
Date:   Wed, 12 May 2021 15:12:01 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <YJs2KWMCn2kpyryT@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.85.216]
X-ClientProxiedBy: lhreml740-chm.china.huawei.com (10.201.108.190) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>>   
>> +static int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue)
>> +{
>> +	struct blk_mq_tag_set *set = queue->tag_set;
>> +	int ret;
>> +
>> +	/*
>> +	 * Set initial depth at max so that we don't need to reallocate for
>> +	 * updating nr_requests.
>> +	 */
>> +	ret = blk_mq_init_bitmaps(&queue->sched_bitmap_tags,
>> +				  &queue->sched_breserved_tags,
>> +				  set, MAX_SCHED_RQ, set->reserved_tags);
>> +	if (ret)
>> +		return ret;
>> +
>> +	sbitmap_queue_resize(&queue->sched_bitmap_tags,
>> +			     queue->nr_requests - set->reserved_tags);
>> +
>> +	return 0;
>> +}
>> +
>> +static void blk_mq_exit_sched_shared_sbitmap(struct request_queue *queue)
>> +{
>> +	sbitmap_queue_free(&queue->sched_bitmap_tags);
>> +	sbitmap_queue_free(&queue->sched_breserved_tags);
>> +}
>> +
>>   int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>>   {
>>   	struct blk_mq_hw_ctx *hctx;
>> @@ -578,12 +598,25 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>>   	queue_for_each_hw_ctx(q, hctx, i) {
>>   		ret = blk_mq_sched_alloc_tags(q, hctx, i);
>>   		if (ret)
>> -			goto err;
>> +			goto err_free_tags;
>> +	}
>> +
>> +	if (blk_mq_is_sbitmap_shared(q->tag_set->flags)) {
>> +		ret = blk_mq_init_sched_shared_sbitmap(q);
>> +		if (ret)
>> +			goto err_free_tags;
>> +
>> +		queue_for_each_hw_ctx(q, hctx, i) {
>> +			hctx->sched_tags->bitmap_tags =
>> +						&q->sched_bitmap_tags;
>> +			hctx->sched_tags->breserved_tags =
>> +						&q->sched_breserved_tags;
>> +		}
> The above assignment can be folded into blk_mq_init_sched_shared_sbitmap().
> 

ok

>>   	}
>>   
>>   	ret = e->ops.init_sched(q, e);
>>   	if (ret)
>> -		goto err;
>> +		goto err_free_sbitmap;
>>   
>>   	blk_mq_debugfs_register_sched(q);
>>   
>> @@ -603,7 +636,10 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
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
>> @@ -641,5 +677,7 @@ void blk_mq_exit_sched(struct request_queue *q, struct elevator_queue *e)
>>   	if (e->type->ops.exit_sched)
>>   		e->type->ops.exit_sched(e);
>>   	blk_mq_sched_tags_teardown(q);
>> +	if (blk_mq_is_sbitmap_shared(q->tag_set->flags))
>> +		blk_mq_exit_sched_shared_sbitmap(q);
> The above two lines can be moved to blk_mq_sched_tags_teardown().

blk_mq_sched_tags_teardown() is also used in blk_mq_init_sched() to undo 
the blk_mq_sched_alloc_tags() calls; however, in that same function we 
call blk_mq_sched_alloc_tags() and blk_mq_init_sched_shared_sbitmap() 
separately, so can't combine into a single teardown function.

> 
>>   	q->elevator = NULL;
>>   }
>> diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
>> index 5b18ab915c65..aff037cfd8e7 100644
>> --- a/block/blk-mq-sched.h
>> +++ b/block/blk-mq-sched.h
>> @@ -5,6 +5,8 @@
>>   #include "blk-mq.h"
>>   #include "blk-mq-tag.h"
>>   
>> +#define MAX_SCHED_RQ (16 * BLKDEV_MAX_RQ)
>> +
>>   void blk_mq_sched_assign_ioc(struct request *rq);
>>   
>>   bool blk_mq_sched_try_merge(struct request_queue *q, struct bio *bio,
>> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
>> index 2a37731e8244..e3ab8631be22 100644
>> --- a/block/blk-mq-tag.c
>> +++ b/block/blk-mq-tag.c
>> @@ -13,6 +13,7 @@
>>   #include <linux/delay.h>
>>   #include "blk.h"
>>   #include "blk-mq.h"
>> +#include "blk-mq-sched.h"
>>   #include "blk-mq-tag.h"
>>   
>>   /*
>> @@ -466,19 +467,39 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
>>   	return -ENOMEM;
>>   }
>>   
>> -int blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int flags)
>> +int blk_mq_init_bitmaps(struct sbitmap_queue *bitmap_tags,
>> +			struct sbitmap_queue *breserved_tags,
>> +			struct blk_mq_tag_set *set,
> The 'set' parameter can be killed, meantime pass 'node' & 'alloc_policy',
> just like blk_mq_init_bitmap_tags()'s type, then blk_mq_init_bitmaps()
> can be re-used by blk_mq_init_bitmap_tags() for avoiding to duplicate
> bitmap allocation code.

I was thinking that we could consolidate here, so let me check this.

> 
>> +			unsigned int queue_depth, unsigned int reserved)
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
> s/set->reserved_tags/reserved/

ok

Thanks!

