Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743EEC433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 15:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42C31613B3
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 15:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbhDZP4V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 11:56:21 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2916 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234224AbhDZP4L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Apr 2021 11:56:11 -0400
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FTTjh6J8Qz77b2h;
        Mon, 26 Apr 2021 23:44:56 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 26 Apr 2021 17:55:26 +0200
Received: from [10.47.94.234] (10.47.94.234) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 26 Apr
 2021 16:55:25 +0100
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
From:   John Garry <john.garry@huawei.com>
Message-ID: <55743a51-4d6f-f481-cebf-e2af9c657911@huawei.com>
Date:   Mon, 26 Apr 2021 16:52:28 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <YIbS1dgSYrsAeGvZ@T590>
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

On 26/04/2021 15:48, Ming Lei wrote:
>>       --0.56%--sbitmap_get
>>
>> I don't see this for hostwide tags - this may be because we have multiple
>> hctx, and the IO sched tags are per hctx, so less chance of exhaustion. But
>> this is not from hostwide tags specifically, but for multiple HW queues in
>> general. As I understood, sched tags were meant to be per request queue,
>> right? I am reading this correctly?
> sched tags is still per-hctx.
> 
> I just found that you didn't change sched tags into per-request-queue
> shared tags. 
> Then for hostwide tags, each hctx still has its own
> standalone sched tags and request pool, that is one big difference with
> non hostwide tags. 

For both hostwide and non-hostwide tags, we have standalone sched tags 
and request pool per hctx when q->nr_hw_queues > 1.

> That is why you observe that scheduler tag exhaustion
> is easy to trigger in case of non-hostwide tags.
> 
> I'd suggest to add one per-request-queue sched tags, and make all hctxs
> sharing it, just like what you did for driver tag.
> 

That sounds reasonable.

But I don't see how this is related to hostwide tags specifically, but 
rather just having q->nr_hw_queues > 1, which NVMe PCI and some other 
SCSI MQ HBAs have (without using hostwide tags).

Thanks,
John
