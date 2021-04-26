Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3AD7C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 17:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B8BE613AA
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 17:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234796AbhDZRGa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 13:06:30 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2917 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235532AbhDZRGN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Apr 2021 13:06:13 -0400
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FTWGW57Nnz680L7;
        Tue, 27 Apr 2021 00:54:59 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 26 Apr 2021 19:05:29 +0200
Received: from [10.47.94.234] (10.47.94.234) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 26 Apr
 2021 18:05:28 +0100
Subject: Re: [bug report] shared tags causes IO hang and performance drop
To:     Ming Lei <ming.lei@redhat.com>
CC:     Kashyap Desai <kashyap.desai@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.com>
References: <YHaez6iN2HHYxYOh@T590>
 <9a6145a5-e6ac-3d33-b52a-0823bfc3b864@huawei.com>
 <cb326d404c6e0785d03a7dfadc42832c@mail.gmail.com> <YHbOOfGNHwO4SMS7@T590>
 <87ceccf2-287b-9bd1-899a-f15026c9e65b@huawei.com> <YHe3M62agQET6o6O@T590>
 <0c85fe52-ebc7-68b3-2dbe-dfad5d604346@huawei.com>
 <c1d5abaa-c460-55f8-5351-16f09d6aa81f@huawei.com> <YIbS1dgSYrsAeGvZ@T590>
 <55743a51-4d6f-f481-cebf-e2af9c657911@huawei.com> <YIbkX2G0+dp3PV+u@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <9ad15067-ba7b-a335-ae71-8c4328856b91@huawei.com>
Date:   Mon, 26 Apr 2021 18:02:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <YIbkX2G0+dp3PV+u@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.94.234]
X-ClientProxiedBy: lhreml745-chm.china.huawei.com (10.201.108.195) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/04/2021 17:03, Ming Lei wrote:
>> For both hostwide and non-hostwide tags, we have standalone sched tags and
>> request pool per hctx when q->nr_hw_queues > 1.
> driver tags is shared for hostwide tags.
> 
>>> That is why you observe that scheduler tag exhaustion
>>> is easy to trigger in case of non-hostwide tags.
>>>
>>> I'd suggest to add one per-request-queue sched tags, and make all hctxs
>>> sharing it, just like what you did for driver tag.
>>>
>> That sounds reasonable.
>>
>> But I don't see how this is related to hostwide tags specifically, but
>> rather just having q->nr_hw_queues > 1, which NVMe PCI and some other SCSI
>> MQ HBAs have (without using hostwide tags).
> Before hostwide tags, the whole scheduler queue depth should be 256.
> After hostwide tags, the whole scheduler queue depth becomes 256 *
> nr_hw_queues. But the driver tag queue depth is_not_  changed.

Fine.

> 
> More requests come and are tried to dispatch to LLD and can't succeed
> because of limited driver tag depth, and CPU utilization could be increased.

Right, maybe this is a problem.

I quickly added some debug, and see that 
__blk_mq_get_driver_tag()->__sbitmap_queue_get() fails ~7% for hostwide 
tags and 3% for non-hostwide tags.

Having it fail at all for non-hostwide tags seems a bit dubious... 
here's the code for deciding the rq sched tag depth:

q->nr_requests = 2 * min(q->tags_set->queue_depth [128], BLK_DEV_MAX_RQ 
[128])

So we get 256 for our test scenario, which is appreciably bigger than 
q->tags_set->queue_depth, so the failures make sense.

Anyway, I'll look at adding code for a per-request queue sched tags to 
see if it helps. But I would plan to continue to use a per hctx sched 
request pool.

Thanks,
John

