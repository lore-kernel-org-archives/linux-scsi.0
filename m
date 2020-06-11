Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3282DC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 10:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AA8120835
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 10:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgFKKLE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 06:11:04 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2300 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726802AbgFKKLE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Jun 2020 06:11:04 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 63A40B928A75ECC11DD6;
        Thu, 11 Jun 2020 11:11:02 +0100 (IST)
Received: from [127.0.0.1] (10.210.169.30) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Thu, 11 Jun
 2020 11:11:00 +0100
Subject: Re: [PATCH RFC v7 04/12] blk-mq: Facilitate a shared sbitmap per
 tagset
To:     Ming Lei <ming.lei@redhat.com>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <bvanassche@acm.org>, <hare@suse.com>, <hch@lst.de>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-5-git-send-email-john.garry@huawei.com>
 <20200611033728.GC453671@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <4a5ef683-91f4-093c-4fed-675f9fcfda31@huawei.com>
Date:   Thu, 11 Jun 2020 11:09:43 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200611033728.GC453671@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.169.30]
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/06/2020 04:37, Ming Lei wrote:

Hi Ming,

Thanks for checking this.

>> bool bt_iter(struct sbitmap *bitmap, unsigned int bitnr, void *data)
>>   	 * We can hit rq == NULL here, because the tagging functions
>>   	 * test and set the bit before assigning ->rqs[].
>>   	 */
>> -	if (rq && rq->q == hctx->queue)
>> +	if (rq && rq->q == hctx->queue && rq->mq_hctx == hctx)
>>   		return iter_data->fn(hctx, rq, iter_data->data, reserved);
>>   	return true;
>>   }
>> @@ -466,6 +466,7 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
>>   		     round_robin, node))
>>   		goto free_bitmap_tags;
>>   
>> +	/* We later overwrite these in case of per-set shared sbitmap */
>>   	tags->bitmap_tags = &tags->__bitmap_tags;
>>   	tags->breserved_tags = &tags->__breserved_tags;
> You may skip to allocate anything for blk_mq_is_sbitmap_shared(), and
> similar change for blk_mq_free_tags().

I did try that, but it breaks scheduler tags allocation - this is common 
code. Maybe I can pass some flag, to avoid the allocation for case of 
shared sbitmap and !sched tags. Same for free path.

BTW, if you check patch 7/12, I mentioned that we could use this sbitmap 
for iterating to get the per-hctx bitmap, instead of allocating a temp 
sbitmap. Maybe it's better.

> 
>>   
>> @@ -475,7 +476,32 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
>>   	return -ENOMEM;
>>   }
>>   
>> -struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
>> +bool blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *tag_set)
>> +{
>> +	unsigned int depth = tag_set->queue_depth - tag_set->reserved_tags;
>> +	int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(tag_set->flags);
>> +	bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;
>> +	int node = tag_set->numa_node;
>> +
>> +	if (bt_alloc(&tag_set->__bitmap_tags, depth, round_robin, node))
>> +		return false;
>> +	if (bt_alloc(&tag_set->__breserved_tags, tag_set->reserved_tags,
>> +		     round_robin, node))
>> +		goto free_bitmap_tags;
>> +	return true;
>> +free_bitmap_tags:
>> +	sbitmap_queue_free(&tag_set->__bitmap_tags);
>> +	return false;
>> +}
>> +

[...]

>> index 90b645c3092c..77120dd4e4d5 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -2229,7 +2229,7 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
>>   	if (node == NUMA_NO_NODE)
>>   		node = set->numa_node;
>>   
>> -	tags = blk_mq_init_tags(nr_tags, reserved_tags, node,
>> +	tags = blk_mq_init_tags(set, nr_tags, reserved_tags, node,
>>   				BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags));
>>   	if (!tags)
>>   		return NULL;
>> @@ -3349,11 +3349,28 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
>>   	if (ret)
>>   		goto out_free_mq_map;
>>   
>> +	if (blk_mq_is_sbitmap_shared(set)) {
>> +		if (!blk_mq_init_shared_sbitmap(set)) {
>> +			ret = -ENOMEM;
>> +			goto out_free_mq_rq_maps;
>> +		}
>> +
>> +		for (i = 0; i < set->nr_hw_queues; i++) {
>> +			struct blk_mq_tags *tags = set->tags[i];
>> +
>> +			tags->bitmap_tags = &set->__bitmap_tags;
>> +			tags->breserved_tags = &set->__breserved_tags;
>> +		}
> I am wondering why you don't put ->[bitmap|breserved]_tags initialization into
> blk_mq_init_shared_sbitmap().

I suppose I could.

Thanks,
John
