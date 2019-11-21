Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A931FC432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 10:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80C2720872
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 10:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfKUKYU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 05:24:20 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2110 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726014AbfKUKYU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Nov 2019 05:24:20 -0500
Received: from lhreml708-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 0FD5A7597279BC2F94E6;
        Thu, 21 Nov 2019 10:24:18 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml708-cah.china.huawei.com (10.201.108.49) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 21 Nov 2019 10:24:17 +0000
Received: from [127.0.0.1] (10.202.226.46) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 21 Nov
 2019 10:24:17 +0000
Subject: Re: [PATCH RFC V2 3/5] blk-mq: Facilitate a shared sbitmap per tagset
To:     Ming Lei <ming.lei@redhat.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>
References: <1574173658-76818-1-git-send-email-john.garry@huawei.com>
 <1574173658-76818-4-git-send-email-john.garry@huawei.com>
 <20191121085531.GC4755@ming.t460p>
From:   John Garry <john.garry@huawei.com>
Message-ID: <db93e0ba-118a-a4f6-41a8-064353568ef7@huawei.com>
Date:   Thu, 21 Nov 2019 10:24:16 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191121085531.GC4755@ming.t460p>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.46]
X-ClientProxiedBy: lhreml720-chm.china.huawei.com (10.201.108.71) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>   
>>   int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>>   {
>> +	struct blk_mq_tag_set *tag_set = q->tag_set;
>>   	struct blk_mq_hw_ctx *hctx;
>>   	struct elevator_queue *eq;
>>   	unsigned int i;
>> @@ -537,6 +538,19 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>>   		blk_mq_debugfs_register_sched_hctx(q, hctx);
>>   	}
>>   
>> +	if (blk_mq_is_sbitmap_shared(tag_set)) {
>> +		if (!blk_mq_init_sched_shared_sbitmap(tag_set, q->nr_requests)) {
>> +			ret = -ENOMEM;
>> +			goto err;
>> +		}
>> +		queue_for_each_hw_ctx(q, hctx, i) {
>> +			struct blk_mq_tags *tags = hctx->sched_tags;
>> +
>> +			tags->pbitmap_tags = &tag_set->sched_shared_bitmap_tags;
>> +			tags->pbreserved_tags = &tag_set->sched_shared_breserved_tags;
> 
> This kind of sharing is wrong, sched tags should be request queue wide
> instead of tagset wide, and each request queue has its own & independent
> scheduler queue.

Right, so if we get get a scheduler tag we still need to get a driver 
tag, and this would be the "shared" tag.

That makes things simpler then.

> 
>> +		}
>> +	}
>> +
>>   	return 0;
>>   
>>   err:
>> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
>> index 42792942b428..6625bebb46c3 100644
>> --- a/block/blk-mq-tag.c
>> +++ b/block/blk-mq-tag.c
>> @@ -35,9 +35,9 @@ bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
>>    */
>>   void blk_mq_tag_wakeup_all(struct blk_mq_tags *tags, bool include_reserve)
>>   {
>> -	sbitmap_queue_wake_all(&tags->bitmap_tags);
>> +	sbitmap_queue_wake_all(tags->pbitmap_tags);
>>   	if (include_reserve)
>> -		sbitmap_queue_wake_all(&tags->breserved_tags);
>> +		sbitmap_queue_wake_all(tags->pbreserved_tags);
>>   }
>>   

[...]


>>   	mutex_init(&set->tag_list_lock);
>>   	INIT_LIST_HEAD(&set->tag_list);
>>   
>> @@ -3137,6 +3151,7 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
>>   {
>>   	struct blk_mq_tag_set *set = q->tag_set;
>>   	struct blk_mq_hw_ctx *hctx;
>> +	bool sched_tags = false;
>>   	int i, ret;
>>   
>>   	if (!set)
>> @@ -3160,6 +3175,7 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
>>   			ret = blk_mq_tag_update_depth(hctx, &hctx->tags, nr,
>>   							false);
>>   		} else {
>> +			sched_tags = true;
>>   			ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
>>   							nr, true);
>>   		}
>> @@ -3169,8 +3185,41 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
>>   			q->elevator->type->ops.depth_updated(hctx);
>>   	}
>>   
>> -	if (!ret)
>> +	/*
>> +	 * if ret is 0, all queues should have been updated to the same depth
>> +	 * if not, then maybe some have been updated - yuk, need to handle this for shared sbitmap...
>> +	 * if some are updated, we should probably roll back the change altogether. FIXME
>> +	 */
>> +	if (!ret) {
>> +		if (blk_mq_is_sbitmap_shared(set)) {
>> +			if (sched_tags) {
>> +				sbitmap_queue_free(&set->sched_shared_bitmap_tags);
>> +				sbitmap_queue_free(&set->sched_shared_breserved_tags);
>> +				if (!blk_mq_init_sched_shared_sbitmap(set, nr))
>> +					return -ENOMEM; /* fixup error handling */
>> +
>> +				queue_for_each_hw_ctx(q, hctx, i) {
>> +					hctx->sched_tags->pbitmap_tags = &set->sched_shared_bitmap_tags;
>> +					hctx->sched_tags->pbreserved_tags = &set->sched_shared_breserved_tags;
>> +				}
>> +			} else {
>> +				sbitmap_queue_free(&set->shared_bitmap_tags);
>> +				sbitmap_queue_free(&set->shared_breserved_tags);
>> +				if (!blk_mq_init_shared_sbitmap(set))
>> +					return -ENOMEM; /* fixup error handling */
> 
> No, we can't re-allocate driver tags here which are shared by all LUNs. > And you should see that 'can_grow' is set as false for driver tags
> in blk_mq_update_nr_requests(), which can only touch per-request-queue
> data, not tagset wide data.

Yeah, I see that. We should just resize for driver tags bitmap.

Personally I think the mainline code is a little loose here, as if we 
could grow driver tags, then blk_mq_tagset.tags would be out-of-sync 
with the hctx->tags. Maybe that should be made more explicit in the code.

BTW, do you have anything to say about this (modified slightly) comment:

/*
  * if ret != 0, q->nr_requests would not be updated, yet the depth
  * for some hctx sched tags may have changed - is that the right thing
  * to do?
  */

Thanks,
John

