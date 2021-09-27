Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 873CEC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 09:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A4976103B
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 09:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbhI0JMI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 05:12:08 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3877 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbhI0JMH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 05:12:07 -0400
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HHxcW4cMTz67P1q;
        Mon, 27 Sep 2021 17:07:55 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 27 Sep 2021 11:10:27 +0200
Received: from [10.47.85.67] (10.47.85.67) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Mon, 27 Sep
 2021 10:10:26 +0100
Subject: Re: [PATCH v4 12/13] blk-mq: Use shared tags for shared sbitmap
 support
To:     Ming Lei <ming.lei@redhat.com>
CC:     <axboe@kernel.dk>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <hare@suse.de>
References: <1632472110-244938-1-git-send-email-john.garry@huawei.com>
 <1632472110-244938-13-git-send-email-john.garry@huawei.com>
 <YU/oIu2uQ420ol8F@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <6f52adfd-6904-6efb-adfc-f5f20eb5c1cf@huawei.com>
Date:   Mon, 27 Sep 2021 10:13:29 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <YU/oIu2uQ420ol8F@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.85.67]
X-ClientProxiedBy: lhreml717-chm.china.huawei.com (10.201.108.68) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/09/2021 04:25, Ming Lei wrote:
>> c
>> @@ -27,10 +27,11 @@ bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
>>   	if (blk_mq_is_sbitmap_shared(hctx->flags)) {
>>   		struct request_queue *q = hctx->queue;
>>   		struct blk_mq_tag_set *set = q->tag_set;
>> +		struct blk_mq_tags *tags = set->shared_sbitmap_tags;
> The local variable of 'set' can be removed and just retrieve 'tags' from
> hctx->tags.
> 
>>   
>>   		if (!test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags) &&
>>   		    !test_and_set_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags))
>> -			atomic_inc(&set->active_queues_shared_sbitmap);
>> +			atomic_inc(&tags->active_queues);
>>   	} else {
>>   		if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) &&
>>   		    !test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
>> @@ -61,10 +62,12 @@ void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
>>   	struct blk_mq_tag_set *set = q->tag_set;
>>   
>>   	if (blk_mq_is_sbitmap_shared(hctx->flags)) {
>> +		struct blk_mq_tags *tags = set->shared_sbitmap_tags;
>> +
> Same with above.

ok

> 
>>   		if (!test_and_clear_bit(QUEUE_FLAG_HCTX_ACTIVE,
>>   					&q->queue_flags))
>>   			return;
>> -		atomic_dec(&set->active_queues_shared_sbitmap);
>> +		atomic_dec(&tags->active_queues);
>>   	} else {
>>   		if (!test_and_clear_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
>>   			return;
>> @@ -510,38 +513,10 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
>>   	return 0;
>>   }

...

>> -	struct sbitmap_queue	__bitmap_tags;
>> -	struct sbitmap_queue	__breserved_tags;
>>   	struct blk_mq_tags	**tags;
>>   
>> +	struct blk_mq_tags	*shared_sbitmap_tags;
>> +
>>   	struct mutex		tag_list_lock;
>>   	struct list_head	tag_list;
>>   };
>> @@ -432,6 +429,8 @@ enum {
>>   	((policy & ((1 << BLK_MQ_F_ALLOC_POLICY_BITS) - 1)) \
>>   		<< BLK_MQ_F_ALLOC_POLICY_START_BIT)
>>   
>> +#define BLK_MQ_NO_HCTX_IDX	(-1U)
>> +
>>   struct gendisk *__blk_mq_alloc_disk(struct blk_mq_tag_set *set, void *queuedata,
>>   		struct lock_class_key *lkclass);
>>   #define blk_mq_alloc_disk(set, queuedata)				\
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 4baf9435232d..17e50e5ef47b 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -459,8 +459,7 @@ struct request_queue {
>>   
>>   	atomic_t		nr_active_requests_shared_sbitmap;
>>   
>> -	struct sbitmap_queue	sched_bitmap_tags;
>> -	struct sbitmap_queue	sched_breserved_tags;
>> +	struct blk_mq_tags	*shared_sbitmap_tags;
> Maybe better with shared_sched_sbitmap_tags or sched_sbitmap_tags?

Yeah, I suppose I should add "sched" to the name, as before.

BTW, Do you think that I should just change shared_sbitmap -> 
shared_tags naming now globally? I'm thinking now that I should...

Thanks,
John
