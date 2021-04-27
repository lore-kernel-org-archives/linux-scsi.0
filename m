Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E0EC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 09:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AE06613B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 09:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbhD0JlY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 05:41:24 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2922 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbhD0JlY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Apr 2021 05:41:24 -0400
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FTxSR4b7hz6wl4r;
        Tue, 27 Apr 2021 17:35:03 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 27 Apr 2021 11:40:39 +0200
Received: from [10.47.94.234] (10.47.94.234) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 27 Apr
 2021 10:40:39 +0100
Subject: Re: [bug report] shared tags causes IO hang and performance drop
To:     Ming Lei <ming.lei@redhat.com>
CC:     Kashyap Desai <kashyap.desai@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.com>
References: <87ceccf2-287b-9bd1-899a-f15026c9e65b@huawei.com>
 <YHe3M62agQET6o6O@T590> <0c85fe52-ebc7-68b3-2dbe-dfad5d604346@huawei.com>
 <c1d5abaa-c460-55f8-5351-16f09d6aa81f@huawei.com> <YIbS1dgSYrsAeGvZ@T590>
 <55743a51-4d6f-f481-cebf-e2af9c657911@huawei.com> <YIbkX2G0+dp3PV+u@T590>
 <9ad15067-ba7b-a335-ae71-8c4328856b91@huawei.com> <YIdTyyVE5azlYwtO@T590>
 <ab83eec4-20f1-ad74-7f43-52a4a87a8aa9@huawei.com> <YIfVVRheF9ZWjzbh@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <cb81d990-e5a6-49b1-5d96-8079a80c73f5@huawei.com>
Date:   Tue, 27 Apr 2021 10:37:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <YIfVVRheF9ZWjzbh@T590>
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

On 27/04/2021 10:11, Ming Lei wrote:
> On Tue, Apr 27, 2021 at 08:52:53AM +0100, John Garry wrote:
>> On 27/04/2021 00:59, Ming Lei wrote:
>>>> Anyway, I'll look at adding code for a per-request queue sched tags to see
>>>> if it helps. But I would plan to continue to use a per hctx sched request
>>>> pool.
>>> Why not switch to per hctx sched request pool?
>> I don't understand. The current code uses a per-hctx sched request pool, and
>> I said that I don't plan to change that.
> I forget why you didn't do that, because for hostwide tags, request
> is always 1:1 for either sched tags(real io sched) or driver tags(none).
> 
> Maybe you want to keep request local to hctx, but never see related
> performance data for supporting the point, sbitmap queue allocator has
> been intelligent enough to allocate tag freed from native cpu.
> 
> Then you just waste lots of memory, I remember that scsi request payload
> is a bit big.

It's true that we waste much memory for regular static requests for when 
using hostwide tags today.

One problem in trying to use a single set of "hostwide" static requests 
is that we call blk_mq_init_request(..., hctx_idx, ...) -> 
set->ops->init_request(.., hctx_idx, ...) for each static rq, and this 
would not work for a single set of "hostwide" requests.

And I see a similar problem for a "request queue-wide" sched static 
requests.

Maybe we can improve this in future.

BTW, for the performance issue which Yanhui witnessed with megaraid sas, 
do you think it may because of the IO sched tags issue of total sched 
tag depth growing vs driver tags? Are there lots of LUNs? I can imagine 
that megaraid sas has much larger can_queue than scsi_debug :)

Thanks,
John

