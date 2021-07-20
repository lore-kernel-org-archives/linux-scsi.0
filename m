Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D4DC07E95
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 08:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C6C0611ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 08:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbhGTH2F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Jul 2021 03:28:05 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3435 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbhGTH1y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jul 2021 03:27:54 -0400
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GTWMg0mqLz6FDtf;
        Tue, 20 Jul 2021 15:59:43 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 10:08:31 +0200
Received: from [10.47.85.214] (10.47.85.214) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 20 Jul
 2021 09:08:30 +0100
Subject: Re: [PATCH 4/9] blk-mq: Add blk_mq_tag_resize_sched_shared_sbitmap()
To:     Ming Lei <ming.lei@redhat.com>
CC:     <axboe@kernel.dk>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <kashyap.desai@broadcom.com>, <hare@suse.de>
References: <1626275195-215652-1-git-send-email-john.garry@huawei.com>
 <1626275195-215652-5-git-send-email-john.garry@huawei.com>
 <YPaCBSrQNP5ciIVh@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <2f2b4a83-02be-f74f-d6f7-7ec9b9645e00@huawei.com>
Date:   Tue, 20 Jul 2021 09:08:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <YPaCBSrQNP5ciIVh@T590>
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

On 20/07/2021 08:57, Ming Lei wrote:
>> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
>> index f5cb2931c20d..1e028183557d 100644
>> --- a/block/blk-mq-sched.c
>> +++ b/block/blk-mq-sched.c
>> @@ -584,8 +584,7 @@ static int blk_mq_init_sched_shared_sbitmap(struct request_queue *queue)
>>   					&queue->sched_breserved_tags;
>>   	}
>>   
>> -	sbitmap_queue_resize(&queue->sched_bitmap_tags,
>> -			     queue->nr_requests - set->reserved_tags);
>> +	blk_mq_tag_resize_sched_shared_sbitmap(queue);
>>   
>>   	return 0;
>>   }
>> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
>> index 86f87346232a..55c7f1bf41c7 100644
>> --- a/block/blk-mq-tag.c
>> +++ b/block/blk-mq-tag.c
>> @@ -634,6 +634,16 @@ void blk_mq_tag_resize_shared_sbitmap(struct blk_mq_tag_set *set, unsigned int s
>>   	sbitmap_queue_resize(&set->__bitmap_tags, size - set->reserved_tags);
>>   }
>>   
>> +/*
>> + * We always resize with q->nr_requests - q->tag_set->reserved_tags, so
>> + * don't bother passing a size.
>> + */
>> +void blk_mq_tag_resize_sched_shared_sbitmap(struct request_queue *q)
>> +{
>> +	sbitmap_queue_resize(&q->sched_bitmap_tags,
>> +			     q->nr_requests - q->tag_set->reserved_tags);
>> +}
> It is a bit hard to follow the resize part of the name, since no size
> parameter passed in. Maybe update is better?

Right, this function is a bit odd. Maybe I can just have a size argument 
for consistency with blk_mq_tag_resize_shared_sbitmap().

Thanks,
John
