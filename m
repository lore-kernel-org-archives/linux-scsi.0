Return-Path: <SRS0=RyiH=BH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFEAC433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 07:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55C3D22B3F
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 07:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgG1H42 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:56:28 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2543 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727858AbgG1H42 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Jul 2020 03:56:28 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id A1416B40E0209DCC518A;
        Tue, 28 Jul 2020 08:56:26 +0100 (IST)
Received: from [127.0.0.1] (10.47.11.173) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 28 Jul
 2020 08:56:25 +0100
Subject: Re: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
To:     Ming Lei <ming.lei@redhat.com>
CC:     Kashyap Desai <kashyap.desai@broadcom.com>, <axboe@kernel.dk>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <don.brace@microsemi.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>, <bvanassche@acm.org>,
        <hare@suse.com>, <hch@lst.de>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
References: <1dcf2bb9-142c-7bb8-9207-5a1b792eb3f9@huawei.com>
 <e69dc243174664efd414a4cd0176e59d@mail.gmail.com>
 <20200721011323.GA833377@T590>
 <c71bbdf2607a8183926430b5f4aa1ae1@mail.gmail.com>
 <20200722041201.GA912316@T590>
 <f6f05483491c391ce79486b8fb78cb2e@mail.gmail.com>
 <20200722080409.GB912316@T590>
 <fe7a7acf-d62b-d541-4203-29c1d0403c2a@huawei.com>
 <20200723140758.GA957464@T590>
 <f4a896a3-756e-68bb-7700-cab1e5523c81@huawei.com>
 <20200724024704.GB957464@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <6531e06c-9ce2-73e6-46fc-8e97400f07b2@huawei.com>
Date:   Tue, 28 Jul 2020 08:54:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200724024704.GB957464@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.11.173]
X-ClientProxiedBy: lhreml739-chm.china.huawei.com (10.201.108.189) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/07/2020 03:47, Ming Lei wrote:
> On Thu, Jul 23, 2020 at 06:29:01PM +0100, John Garry wrote:
>>>> As I see, since megaraid will have 1:1 mapping of CPU to hw queue, will
>>>> there only ever possibly a single bit set in ctx_map? If so, it seems a
>>>> waste to always check every sbitmap map. But adding logic for this may
>>>> negate any possible gains.
>>>
>>> It really depends on min and max cpu id in the map, then sbitmap
>>> depth can be reduced to (max - min + 1). I'd suggest to double check that
>>> cost of sbitmap_any_bit_set() really matters.
>>
>> Hi Ming,
>>
>> I'm not sure that reducing the search range would help much, as we still
>> need to load some indexes of map[], and at best this may be reduced from 2/3
>> -> 1 elements, depending on nr_cpus.
> 
> I believe you misunderstood my idea, and you have to think it from implementation
> viewpoint.
> 
> The only workable way is to store the min cpu id as 'offset' and set the sbitmap
> depth as (max - min + 1), isn't it? Then the actual cpu id can be figured out via
> 'offset' + nr_bit. And the whole indexes are just spread on the actual depth. BTW,
> max & min is the max / min cpu id in hctx->cpu_map. So we can improve not only on 1:1,
> and I guess most of MQ cases can benefit from the change, since it shouldn't be usual
> for one ctx_map to cover both 0 & nr_cpu_id - 1.
> 
> Meantime, we need to allocate the sbitmap dynamically.

OK, so dynamically allocating the sbitmap could be good. I was thinking 
previously that we still allocate for nr_cpus size, and search a limited 
range - but this would have heavier runtime overhead.

So if you really think that this may have some value, then let me know, 
so we can look to take it forward.

Thanks,
John

