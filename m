Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD787C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 09:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C726A21775
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 09:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgGTJUT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 05:20:19 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2504 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727780AbgGTJUS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jul 2020 05:20:18 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 0A685CB9C9AD4A7FB5F7;
        Mon, 20 Jul 2020 10:20:17 +0100 (IST)
Received: from [127.0.0.1] (10.210.170.208) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 20 Jul
 2020 10:20:15 +0100
Subject: Re: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "don.brace@microsemi.com" <don.brace@microsemi.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "esc.storagedev@microsemi.com" <esc.storagedev@microsemi.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-11-git-send-email-john.garry@huawei.com>
 <d55972999b9370f947c20537e41b49bf@mail.gmail.com>
 <e61593f8-5ee7-5763-9d02-d0ea13aeb49f@huawei.com>
 <92ba1829c9e822e4239a7cdfd94acbce@mail.gmail.com>
 <10d36c09-9d5b-92e9-23ac-ea1a2628e7d9@huawei.com>
 <0563e53f843c97de1a5a035fae892bf8@mail.gmail.com>
 <61299951-97dc-b2be-c66c-024dfbd3a1cb@huawei.com>
 <b49c33ebda36b8f116a51bc5c430eb9d@mail.gmail.com>
 <13d6b63e-3aa8-68fa-29ab-a4c202024280@huawei.com>
 <34a832717fef4702b143ea21aa12b79e@mail.gmail.com>
 <1dcf2bb9-142c-7bb8-9207-5a1b792eb3f9@huawei.com>
 <e69dc243174664efd414a4cd0176e59d@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <4fa30c15-1b94-8b1c-83a8-f1f91f4d8c66@huawei.com>
Date:   Mon, 20 Jul 2020 10:18:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <e69dc243174664efd414a4cd0176e59d@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.170.208]
X-ClientProxiedBy: lhreml721-chm.china.huawei.com (10.201.108.72) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/07/2020 08:23, Kashyap Desai wrote:

Hi Kashyap,

>> John - I did more testing on v8 wip branch.  CPU hotplug is working as
>> expected, 

Good to hear.

but I still see some performance issue on Logical Volumes.
>>
>> I created 8 Drives Raid-0 VD on MR controller and below is performance
>> impact of this RFC. Looks like contention is on single <sdev>.
>>
>> I used command - "numactl -N 1  fio 1vd.fio --iodepth=128 --bs=4k --
>> rw=randread --cpus_allowed_policy=split --ioscheduler=none --
>> group_reporting --runtime=200 --numjobs=1"
>> IOPS without RFC = 300K IOPS with RFC = 230K.
>>
>> Perf top (shared host tag. IOPS = 230K)
>>
>> 13.98%  [kernel]        [k] sbitmap_any_bit_set

I guess that this comes from the blk_mq_hctx_has_pending() -> 
sbitmap_any_bit_set(&hctx->ctx_map) call. The 
list_empty_careful(&hctx->dispatch) and blk_mq_sched_has_work(hctx) 
[when scheduler=none] calls look pretty lightweight.

>>       6.43%  [kernel]        [k] blk_mq_run_hw_queue
> blk_mq_run_hw_queue function take more CPU which is called from "
> scsi_end_request"
> It looks like " blk_mq_hctx_has_pending" handles only elevator (scheduler)
> case. If  queue has ioscheduler=none, we can skip. I case of scheduler=none,
> IO will be pushed to hardware queue and it by pass software queue.
> Based on above understanding, I added below patch and I can see performance
> scale back to expectation.
> 
> Ming mentioned that - we cannot remove blk_mq_run_hw_queues() from IO
> completion path otherwise we may see IO hang. So I have just modified
> completion path assuming it is only required for IO scheduler case.
> https://www.spinics.net/lists/linux-block/msg55049.html
> 
> Please review and let me know if this is good or we have to address with
> proper fix.
> 

So what you're doing looks reasonable, but I would be concerned about 
missing the blk_mq_run_hw_queue() -> blk_mq_hctx_has_pending() -> 
list_empty_careful(&hctx->dispatch) check - if it's not really needed 
there, then why not remove?

Hi Ming, any opinion on this?

> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 1be7ac5a4040..b6a5b41b7fc2 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1559,6 +1559,9 @@ void blk_mq_run_hw_queues(struct request_queue *q,
> bool async)
>          struct blk_mq_hw_ctx *hctx;
>          int i;
> 
> +       if (!q->elevator)
> +               return;
> +
>          queue_for_each_hw_ctx(q, hctx, i) {
>                  if (blk_mq_hctx_stopped(hctx))
>                          continue;
> 

Thanks,
John

