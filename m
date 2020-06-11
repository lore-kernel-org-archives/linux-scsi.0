Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F14C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 14:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A35012065C
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 14:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgFKOYP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 10:24:15 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2302 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726414AbgFKOYP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Jun 2020 10:24:15 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 147FADAAA204334EE69F;
        Thu, 11 Jun 2020 15:24:11 +0100 (IST)
Received: from [127.0.0.1] (10.210.169.30) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Thu, 11 Jun
 2020 15:24:09 +0100
Subject: Re: [PATCH RFC v7 06/12] blk-mq: Record active_queues_shared_sbitmap
 per tag_set for when using shared sbitmap
To:     Hannes Reinecke <hare@suse.de>, <axboe@kernel.dk>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <don.brace@microsemi.com>, <kashyap.desai@broadcom.com>,
        <sumit.saxena@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <hare@suse.com>, <hch@lst.de>,
        <shivasharan.srikanteshwara@broadcom.com>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-7-git-send-email-john.garry@huawei.com>
 <a10a20de-d8e2-8505-65ec-1c26bfbf6cfc@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <8bafb633-de7c-8b9e-7369-8e59c93712f8@huawei.com>
Date:   Thu, 11 Jun 2020 15:22:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <a10a20de-d8e2-8505-65ec-1c26bfbf6cfc@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.210.169.30]
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>   out:
>> @@ -802,6 +822,7 @@ static const struct blk_mq_debugfs_attr 
>> blk_mq_debugfs_hctx_shared_sbitmap_attrs
>>       {"dispatch", 0400, .seq_ops = &hctx_dispatch_seq_ops},
>>       {"busy", 0400, hctx_busy_show},
>>       {"ctx_map", 0400, hctx_ctx_map_show},
>> +    {"tags", 0400, hctx_tags_show},
>>       {"sched_tags", 0400, hctx_sched_tags_show},
>>       {"sched_tags_bitmap", 0400, hctx_sched_tags_bitmap_show},
>>       {"io_poll", 0600, hctx_io_poll_show, hctx_io_poll_write},
> 
> I had been pondering this, too, when creating v6. Problem is that it'll 
> show the tags per hctx, but as they are shared I guess the list looks 
> pretty identical per hctx.

Right, so my main concern in this series is debugfs, and how to present 
the tag/hctx info. We can hide things under the hood mostly, but not so 
much for debugfs.

> So I guess we should filter the tags per hctx to have only those active 
> on that hctx displayed. But when doing so we can only print the 
> in-flight tags, the others are not assigned to a hctx and as such we 
> can't make a decision on which hctx they'll end up.

So we filter the tags in 7/12, and that should be ok.

But a concern is that we present identical hctx_tags_show() -> 
blk_mq_debugfs_shared_sitmap_show() -> sbitmap_queue_show() per-hctx 
info, which may be inappropriate/misleading/wrong. I need to audit that 
more thoroughly.

> 
>> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
>> index 7db16e49f6f6..6ca06b1c3a99 100644
>> --- a/block/blk-mq-tag.c
>> +++ b/block/blk-mq-tag.c
>> @@ -23,9 +23,19 @@
>>    */
>>   bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
>>   {
>> -    if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) &&
>> -        !test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
>> -        atomic_inc(&hctx->tags->active_queues);
>> +    struct request_queue *q = hctx->queue;
>> +    struct blk_mq_tag_set *set = q->tag_set;
>> +
>> +    if (blk_mq_is_sbitmap_shared(set)){
>> +        if (!test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags) &&
>> +            !test_and_set_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags))
>> +            atomic_inc(&set->active_queues_shared_sbitmap);
>> +
>> +    } else {
>> +        if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) &&
>> +            !test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
>> +            atomic_inc(&hctx->tags->active_queues);
>> +    }
>>       return true;
>>   }
> At one point someone would need to educate me what this double 
> 'test_bit' and 'test_and_set_bit' is supposed to achieve.
> Other than deliberately injecting a race condition ...

As I see, it's not a dangerous race, and meant as a performance 
optimization.

test_bit() should be is quick compared to test_and_set_bit(), so nicer 
to avoid always doing a test_and_set_bit().

So if we race with failed test_bit() calls and have multiple attempts 
with the test_and_set_bit(), only 1 will succeed and do the increment.

> 
>> @@ -47,11 +57,19 @@ void blk_mq_tag_wakeup_all(struct blk_mq_tags 
>> *tags, bool include_reserve)
>>   void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
>>   {
>>       struct blk_mq_tags *tags = hctx->tags;
>> -
>> -    if (!test_and_clear_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
>> -        return;
>> -
>> -    atomic_dec(&tags->active_queues);
>> +    struct request_queue *q = hctx->queue;
>> +    struct blk_mq_tag_set *set = q->tag_set;
>> +
>> +    if (blk_mq_is_sbitmap_shared(q->tag_set)){
>> +        if (!test_and_clear_bit(QUEUE_FLAG_HCTX_ACTIVE,
>> +                    &q->queue_flags))
>> +            return;
>> +        atomic_dec(&set->active_queues_shared_sbitmap);
>> +    } else {
>> +        if (!test_and_clear_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
>> +            return;
>> +        atomic_dec(&tags->active_queues);
>> +    }
>>       blk_mq_tag_wakeup_all(tags, false);
>>   }
>> @@ -65,12 +83,11 @@ static inline bool hctx_may_queue(struct 
>> blk_mq_alloc_data *data,
>>   {
>>       struct blk_mq_hw_ctx *hctx = data->hctx;
>>       struct request_queue *q = data->q;
>> +    struct blk_mq_tag_set *set = q->tag_set;
>>       unsigned int depth, users;
>>       if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
>>           return true;
>> -    if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
>> -        return true;
>>       /*
>>        * Don't try dividing an ant
>> @@ -78,7 +95,15 @@ static inline bool hctx_may_queue(struct 
>> blk_mq_alloc_data *data,
>>       if (bt->sb.depth == 1)
>>           return true;
>> -    users = atomic_read(&hctx->tags->active_queues);
>> +    if (blk_mq_is_sbitmap_shared(q->tag_set)) {
>> +        if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &q->queue_flags))
>> +            return true;
>> +        users = atomic_read(&set->active_queues_shared_sbitmap);
>> +    } else {
>> +        if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
>> +            return true;
>> +        users = atomic_read(&hctx->tags->active_queues);
>> +    }
>>       if (!users)
>>           return true;
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 0f7e062a1665..f73a2f9c58bd 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -3350,6 +3350,8 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set 
>> *set)
>>           goto out_free_mq_map;
>>       if (blk_mq_is_sbitmap_shared(set)) {
>> +        atomic_set(&set->active_queues_shared_sbitmap, 0);
>> +
>>           if (!blk_mq_init_shared_sbitmap(set)) {
>>               ret = -ENOMEM;
>>               goto out_free_mq_rq_maps;
>> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
>> index 7b31cdb92a71..66711c7234db 100644
>> --- a/include/linux/blk-mq.h
>> +++ b/include/linux/blk-mq.h
>> @@ -252,6 +252,7 @@ struct blk_mq_tag_set {
>>       unsigned int        timeout;
>>       unsigned int        flags;
>>       void            *driver_data;
>> +    atomic_t        active_queues_shared_sbitmap;

I'm not sure if we should present this in debugfs. It is not according 
to this series.

>>       struct sbitmap_queue    __bitmap_tags;
>>       struct sbitmap_queue    __breserved_tags;
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index c536278bec9e..1b0087e8d01a 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -619,6 +619,7 @@ struct request_queue {
>>   #define QUEUE_FLAG_PCI_P2PDMA    25    /* device supports PCI p2p 
>> requests */
>>   #define QUEUE_FLAG_ZONE_RESETALL 26    /* supports Zone Reset All */
>>   #define QUEUE_FLAG_RQ_ALLOC_TIME 27    /* record rq->alloc_time_ns */
>> +#define QUEUE_FLAG_HCTX_ACTIVE 28    /* at least one blk-mq hctx is 
>> active */
>>   #define QUEUE_FLAG_MQ_DEFAULT    ((1 << QUEUE_FLAG_IO_STAT) |        \
>>                    (1 << QUEUE_FLAG_SAME_COMP))
>>
> Other than that it looks fine.

Cheers
