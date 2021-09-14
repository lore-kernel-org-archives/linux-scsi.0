Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA0EC4321E
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 08:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 280F26103B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 08:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhINIKR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 04:10:17 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3786 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbhINII4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 04:08:56 -0400
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H7wqx49m6z67bMW;
        Tue, 14 Sep 2021 16:05:01 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 14 Sep 2021 10:07:09 +0200
Received: from [10.47.80.114] (10.47.80.114) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Tue, 14 Sep
 2021 09:07:08 +0100
Subject: Re: [PATCH RESEND v3 05/13] blk-mq-sched: Rename
 blk_mq_sched_alloc_{tags -> map_and_rqs}()
To:     Hannes Reinecke <hare@suse.de>, <axboe@kernel.dk>
CC:     <linux-kernel@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>
References: <1631545950-56586-1-git-send-email-john.garry@huawei.com>
 <1631545950-56586-6-git-send-email-john.garry@huawei.com>
 <bcbc3479-86f9-6d72-44a5-aacd4f03fcc2@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <4a139bf3-d536-4f9c-8cd2-6fbd6da7d6c4@huawei.com>
Date:   Tue, 14 Sep 2021 09:10:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <bcbc3479-86f9-6d72-44a5-aacd4f03fcc2@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.80.114]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>> +static int blk_mq_sched_alloc_map_and_rqs(struct request_queue *q,
>> +                      struct blk_mq_hw_ctx *hctx,
>> +                      unsigned int hctx_idx)
>>   {
>>       struct blk_mq_tag_set *set = q->tag_set;
>>       int ret;
>> @@ -609,15 +609,15 @@ int blk_mq_init_sched(struct request_queue *q, 
>> struct elevator_type *e)
>>                      BLKDEV_DEFAULT_RQ);
>>       queue_for_each_hw_ctx(q, hctx, i) {
>> -        ret = blk_mq_sched_alloc_tags(q, hctx, i);
>> +        ret = blk_mq_sched_alloc_map_and_rqs(q, hctx, i);
>>           if (ret)
>> -            goto err_free_tags;
>> +            goto err_free_map_and_rqs;
>>       }
>>       if (blk_mq_is_sbitmap_shared(q->tag_set->flags)) {
>>           ret = blk_mq_init_sched_shared_sbitmap(q);
>>           if (ret)
>> -            goto err_free_tags;
>> +            goto err_free_map_and_rqs;
>>       }
>>       ret = e->ops.init_sched(q, e);
>> @@ -645,8 +645,8 @@ int blk_mq_init_sched(struct request_queue *q, 
>> struct elevator_type *e)
>>   err_free_sbitmap:
>>       if (blk_mq_is_sbitmap_shared(q->tag_set->flags))
>>           blk_mq_exit_sched_shared_sbitmap(q);
>> -err_free_tags:
>>       blk_mq_sched_free_requests(q);
>> +err_free_map_and_rqs:
>>       blk_mq_sched_tags_teardown(q);
>>       q->elevator = NULL;
>>       return ret;
>>
> This is not only a rename, but it also moves the location of the label.
> Is that intended?
> If so it needs some documentation why this is safe.

Yeah, I think you're right.

The final code in the series looks correct, but this is a transient 
breakage.

I'll fix it.

Thanks,
John
