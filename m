Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 451E4C55199
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 17:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 299CB2078C
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 17:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgD0RHP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 13:07:15 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2114 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726204AbgD0RHP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Apr 2020 13:07:15 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 231CCFDF50853D5DCE20;
        Mon, 27 Apr 2020 18:07:13 +0100 (IST)
Received: from [127.0.0.1] (10.210.170.137) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 27 Apr
 2020 18:07:11 +0100
Subject: Re: [PATCH RFC v6 08/10] megaraid_sas: switch fusion adapters to MQ
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "hare@suse.de" <hare@suse.de>,
        "don.brace@microsemi.com" <don.brace@microsemi.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
CC:     "chenxiang (M)" <chenxiang66@hisilicon.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "esc.storagedev@microsemi.com" <esc.storagedev@microsemi.com>,
        Hannes Reinecke <hare@suse.com>
References: <1583409280-158604-1-git-send-email-john.garry@huawei.com>
 <1583409280-158604-9-git-send-email-john.garry@huawei.com>
 <a1f0399e2e85b2244a9ae40e4a2f1089@mail.gmail.com>
 <f839f040-8bf4-cf83-7670-dfc208b77326@huawei.com>
 <7cac3eb9fd79b5b988e25da542305b35@mail.gmail.com>
 <40faaef8-8bfc-639f-747f-cacd4e61464f@huawei.com>
 <7b8c79b0453722023c6c7d53cd24441d@mail.gmail.com>
 <b759a8ed-09ba-bfe8-8916-c05ab9671cbf@huawei.com>
 <260c5decdb38db9f74994988ce7fcaf1@mail.gmail.com>
 <380d3bf2-67ee-a09a-3098-51b24b98f912@huawei.com>
 <e0c5a076-9fe5-4401-fd41-97f457888ad3@huawei.com>
 <d2ae343770a83466b870a33ffae5fa23@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <8e16d68b-4d71-58f1-ede9-92ffe5d65ba9@huawei.com>
Date:   Mon, 27 Apr 2020 18:06:32 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <d2ae343770a83466b870a33ffae5fa23@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.170.137]
X-ClientProxiedBy: lhreml722-chm.china.huawei.com (10.201.108.73) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Kashyap,

>> hmmmm...
> 
> I did some more experiments. It looks like issue is with both <none> and
> <mq-deadline> scheduler.  Let me simplify what happens with ioscheduler =
> <none>.

I know it's good to compare like-for-like, but, as I understand, "none" 
is more suited for MQ host, while deadline is more suited for SQ host.

> 
> Old Driver which has nr_hw_queue = 1 and I issue IOs from <fio>  queue depth
> = 128. We get 3.1M IOPS in this config. This eventually exhaust host
> can_queue.

So I think I need to find a point where we start to get throttled.

> Note - Very low contention in sbitmap_get()
> 
> -   23.58%     0.25%  fio              [kernel.vmlinux]            [k]
> blk_mq_make_request
>     - 23.33% blk_mq_make_request
>        - 21.68% blk_mq_get_request
>           - 20.19% blk_mq_get_tag
>              + 10.08% prepare_to_wait_exclusive
>              + 4.51% io_schedule
>              - 3.59% __sbitmap_queue_get
>                 - 2.82% sbitmap_get
>                      0.86% __sbitmap_get_word
>                      0.75% _raw_spin_lock_irqsave
>                      0.55% _raw_spin_unlock_irqrestore
> 
> Driver with RFC which has nr_hw_queue = N and I issue IOs from <fio>  queue
> depth = 128. We get 2.3 M IOPS in this config. This eventually exhaust host
> can_queue.
> Note - Very high contention in sbitmap_get()
> 
> -   42.39%     0.12%  fio              [kernel.vmlinux]            [k]
> generic_make_request
>     - 42.27% generic_make_request
>        - 41.00% blk_mq_make_request
>           - 38.28% blk_mq_get_request
>              - 33.76% blk_mq_get_tag
>                 - 30.25% __sbitmap_queue_get
>                    - 29.90% sbitmap_get
>                       + 9.06% _raw_spin_lock_irqsave
>                       + 7.94% _raw_spin_unlock_irqrestore
>                       + 3.86% __sbitmap_get_word
>                       + 1.78% call_function_single_interrupt
>                       + 0.67% ret_from_intr
>                 + 1.69% io_schedule
>                   0.59% prepare_to_wait_exclusive
>                   0.55% __blk_mq_get_tag
> 
> In this particular case, I observed alloc_hint = zeros which means,
> sbitmap_get is not able to find free tags from hint. That may lead to
> contention.
> This condition is not happening with nr_hw_queue=1 (without RFC) driver.
> 
> alloc_hint=
> {663, 2425, 3060, 54, 3149, 4319, 4175, 4867, 543, 2481, 0, 4779, 377,
> ***0***, 2010, 0, 909, 3350, 1546, 2179, 2875, 659, 3902, 2224, 3212, 836,
> 1892, 1669, 2420,
> 3415, 1904, 512, 3027, 4810, 2845, 4690, 712, 3105, 0, 0, 0, 3268, 4915,
> 3897, 1349, 547, 4, 733, 1765, 2068, 979, 51, 880, 0, 370, 3520, 2877, 4097,
> 418, 4501, 3717,
> 2893, 604, 508, 759, 3329, 4038, 4829, 715, 842, 1443, 556}
> 
> Driver with RFC which has nr_hw_queue = N and I issue IOs from <fio>  queue
> depth = 32. We get 3.1M IOPS in this config. This workload does *not*
> exhaust host can_queue.

Please ensure .host_tagset is set for whenever nr_hw_queue = N. This is 
as per RFC, and I don't think you modified from the RFC for your test. 
But I just wanted to mention that to be crystal clear.

> 
> -    5.07%     0.14%  fio              [kernel.vmlinux]  [k]
> generic_make_request
>     - 4.93% generic_make_request
>        - 3.61% blk_mq_make_request
>           - 2.04% blk_mq_get_request
>              - 1.08% blk_mq_get_tag
>                 - 0.70% __sbitmap_queue_get
>                      0.67% sbitmap_get
> 
> In summary, RFC has some performance bottleneck in sbitmap_get () if
> outstanding per shost is about to exhaust.  Without this RFC also driver
> works in nr_hw_queue = 1, but that case is managed very well.
> I am not sure why it happens only with shared host tag ? Theoretically all
> the hctx is sharing the same bitmaptag which is same as nr_hw_queue=1, so
> why contention is only visible in shared host tag case.

Let me check this.

> 
> If you want to reproduce this issue, may be you have to reduce the can_queue
> in hisi_sas driver.
> 

Thanks,
John

