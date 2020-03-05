Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746CAC3F2D7
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 13:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55DAA2146E
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 13:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgCENww (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 08:52:52 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2510 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725991AbgCENww (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Mar 2020 08:52:52 -0500
Received: from LHREML712-CAH.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 333C0F09AF1F46B7760C;
        Thu,  5 Mar 2020 13:52:50 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML712-CAH.china.huawei.com (10.201.108.35) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 5 Mar 2020 13:52:49 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 5 Mar 2020
 13:52:48 +0000
Subject: Re: [PATCH RFC v6 04/10] blk-mq: Facilitate a shared sbitmap per
 tagset
To:     Hannes Reinecke <hare@suse.de>, <axboe@kernel.dk>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>,
        <don.brace@microsemi.com>, <sumit.saxena@broadcom.com>,
        <hch@infradead.org>, <kashyap.desai@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>
CC:     <chenxiang66@hisilicon.com>, <linux-block@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <esc.storagedev@microsemi.com>
References: <1583409280-158604-1-git-send-email-john.garry@huawei.com>
 <1583409280-158604-5-git-send-email-john.garry@huawei.com>
 <8c201f62-d4f4-8d34-9d3f-9d726f22e091@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <1821b99a-d935-837b-45f4-099410677b12@huawei.com>
Date:   Thu, 5 Mar 2020 13:52:47 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <8c201f62-d4f4-8d34-9d3f-9d726f22e091@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml712-chm.china.huawei.com (10.201.108.63) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Hannes,

>> +
>> +void blk_mq_exit_shared_sbitmap(struct blk_mq_tag_set *tag_set)
>> +{
>> +    sbitmap_queue_free(&tag_set->__bitmap_tags);
>> +    sbitmap_queue_free(&tag_set->__breserved_tags);
>> +}
>> +
>> +struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_tag_set *set,
>> +                     unsigned int total_tags,
>>                        unsigned int reserved_tags,
>>                        int node, int alloc_policy)
>>   {
>> @@ -480,6 +506,7 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int 
>> total_tags,
>>   void blk_mq_free_tags(struct blk_mq_tags *tags)
>>   {
>> +    /* Do not use tags->{bitmap, breserved}_tags */
>>       sbitmap_queue_free(&tags->__bitmap_tags);
>>       sbitmap_queue_free(&tags->__breserved_tags);
>>       kfree(tags);
> Hmm. This is essentially the same as blk_mq_exit_shared_sbitmap().

It does the same thing, but takes different argument types: struct 
blk_mq_tag_set * vs struct blk_mq_tags *

> Please call into that function or clarify the relationship between both.
> And modify the comment; it's not about the 'use' but rather the freeing 

ok

> of the structures, and ->bitmap/breserved just point to the __ variants.

Please note that I had to change blk_mq_init_tags() from v5 to now 
continue to init the blk_mq_tags.__{bitmap, breserved}_tags always. The 
reason is that the following would now be broken for scheduler tags when 
BLK_MQ_F_TAG_HCTX_SHARED is set, ***:

struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_tag_set *set, ...)
{
	struct blk_mq_tags *tags;
	...

	tags->nr_tags = total_tags;
	tags->nr_reserved_tags = reserved_tags;

	if (blk_mq_is_sbitmap_shared(set)) ***
		return tags;

	if (blk_mq_init_bitmap_tags(tags, node, alloc_policy) < 0) {
		...
	}
	return tags;
}

Keeping the blk_mq_is_sbitmap_shared() check would mean that we never 
call blk_mq_init_bitmap_tags() for scheduler tags for when 
BLK_MQ_F_TAG_HCTX_SHARED is set.

As such, I removed the blk_mq_is_sbitmap_shared() check, and we still 
init the blk_mq_tags bitmaps always. Hence we still need to free them.

And as I noted in the hctx_tags_bitmap_show() change (patch #5), we 
could actually reuse blk_mq_tags.__bitmap_tags.sb in that function 
instead of using a local temp sbitmap.

> 
>> @@ -538,6 +565,11 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx 
>> *hctx,
>>       return 0;
>>   }
>> +void blk_mq_tag_resize_shared_sbitmap(struct blk_mq_tag_set *set, 
>> unsigned int size)
>> +{
>> +    sbitmap_queue_resize(&set->__bitmap_tags, size - 
>> set->reserved_tags);
>> +}
>> +

[...]

>>       return 0;
>> +out_free_mq_rq_maps:
>> +    for (i = 0; i < set->nr_hw_queues; i++)
>> +        blk_mq_free_rq_map(set->tags[i]);
>>   out_free_mq_map:
>>       for (i = 0; i < set->nr_maps; i++) {
>>           kfree(set->map[i].mq_map);
>> @@ -3170,6 +3189,9 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set 
>> *set)
>>       for (i = 0; i < set->nr_hw_queues; i++)
>>           blk_mq_free_map_and_requests(set, i);
>> +    if (blk_mq_is_sbitmap_shared(set))
>> +        blk_mq_exit_shared_sbitmap(set);
>> +
>>       for (j = 0; j < set->nr_maps; j++) {
>>           kfree(set->map[j].mq_map);
>>           set->map[j].mq_map = NULL;
>> @@ -3206,6 +3228,8 @@ int blk_mq_update_nr_requests(struct 
>> request_queue *q, unsigned int nr)
>>           if (!hctx->sched_tags) {
>>               ret = blk_mq_tag_update_depth(hctx, &hctx->tags, nr,
>>                               false);
>> +            if (!ret && blk_mq_is_sbitmap_shared(set))
>> +                blk_mq_tag_resize_shared_sbitmap(set, nr);
>>           } else {
>>               ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
>>                               nr, true);
>> diff --git a/block/blk-mq.h b/block/blk-mq.h
>> index 10bfdfb494fa..dde2d29f0ce5 100644
>> --- a/block/blk-mq.h
>> +++ b/block/blk-mq.h
>> @@ -158,6 +158,11 @@ struct blk_mq_alloc_data {
>>       struct blk_mq_hw_ctx *hctx;
>>   };
>> +static inline bool blk_mq_is_sbitmap_shared(struct blk_mq_tag_set 
>> *tag_set)
>> +{
>> +    return tag_set->flags & BLK_MQ_F_TAG_HCTX_SHARED;
>> +}
>> +
> When is that set?

It set later for SCSI hosts in scsi_mq_setup_tags(), for when 
.host_tagset is set.

> And to my understanding it contingent on the ->bitmap pointer _not_ 
> pointing to ->__bitmap.
> Can we use this as a test and drop this flag?

Maybe, but we need some flag passed to blk_mq_alloc_set() to request to 
use the shared sbitmap.

Thanks,
John
