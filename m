Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91069C55189
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 21:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 730EA21569
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 21:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgDVV3X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 17:29:23 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2085 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726112AbgDVV3X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 17:29:23 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id EC4CB9844C771D4063A1;
        Wed, 22 Apr 2020 22:29:20 +0100 (IST)
Received: from [127.0.0.1] (10.47.1.29) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1913.5; Wed, 22 Apr
 2020 22:29:19 +0100
From:   John Garry <john.garry@huawei.com>
Subject: Re: [PATCH RFC v6 08/10] megaraid_sas: switch fusion adapters to MQ
To:     Kashyap Desai <kashyap.desai@broadcom.com>, <axboe@kernel.dk>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hare@suse.de>,
        <don.brace@microsemi.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>, <hch@infradead.org>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
CC:     <chenxiang66@hisilicon.com>, <linux-block@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <esc.storagedev@microsemi.com>,
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
Message-ID: <380d3bf2-67ee-a09a-3098-51b24b98f912@huawei.com>
Date:   Wed, 22 Apr 2020 22:28:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <260c5decdb38db9f74994988ce7fcaf1@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.1.29]
X-ClientProxiedBy: lhreml702-chm.china.huawei.com (10.201.108.51) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/04/2020 19:59, Kashyap Desai wrote:
>>

Hi Kashyap,

>> So I tested this on hisi_sas with x12 SAS SSDs, and performance with "mq-
>> deadline" is comparable with "none" @ ~ 2M IOPs. But after a while
>> performance drops alot, to maybe 700K IOPS. Do you have a similar
>> experience?
> 
> I am using mq-deadline only for HDD. I have not tried on SSD since it is not
> useful scheduler for SSDs.
> 

I ask as I only have SAS SSDs to test.

> I noticed that when I used mq-deadline, performance drop starts if I have
> more number of drives.
> I am running <fio> script which has 64 Drives, 64 thread and all treads are
> bound to local numa node which has 36 logical cores.
> I noticed that lock contention is in " dd_dispatch_request". I am not sure
> why there is a no penalty of same lock in nr_hw_queue  = 1 mode.

So this could be just pre-existing issue of exposing multiple queues for 
SCSI HBAs combined with mq-deadline iosched. I mean, that's really the 
only significant change in this series, apart from the shared sbitmap, 
and, at this point, I don't think that is the issue.

> 
> static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
> {
>          struct deadline_data *dd = hctx->queue->elevator->elevator_data;
>          struct request *rq;
> 
>          spin_lock(&dd->lock);

So if multiple hctx's are accessing this lock, then much contention 
possible.

>          rq = __dd_dispatch_request(dd);
>          spin_unlock(&dd->lock);
> 
>          return rq;
> }
> 
> Here is perf report -
> 
> -    1.04%     0.99%  kworker/18:1H+k  [kernel.vmlinux]  [k]
> native_queued_spin_lock_slowpath
>       0.99% ret_from_fork
>      -   kthread
>        - worker_thread
>           - 0.98% process_one_work
>              - 0.98% __blk_mq_run_hw_queue
>                 - blk_mq_sched_dispatch_requests
>                    - 0.98% blk_mq_do_dispatch_sched
>                       - 0.97% dd_dispatch_request
>                          + 0.97% queued_spin_lock_slowpath
> +    1.04%     0.00%  kworker/18:1H+k  [kernel.vmlinux]  [k]
> queued_spin_lock_slowpath
> +    1.03%     0.95%  kworker/19:1H-k  [kernel.vmlinux]  [k]
> native_queued_spin_lock_slowpath
> +    1.03%     0.00%  kworker/19:1H-k  [kernel.vmlinux]  [k]
> queued_spin_lock_slowpath
> +    1.02%     0.97%  kworker/20:1H+k  [kernel.vmlinux]  [k]
> native_queued_spin_lock_slowpath
> +    1.02%     0.00%  kworker/20:1H+k  [kernel.vmlinux]  [k]
> queued_spin_lock_slowpath
> +    1.01%     0.96%  kworker/21:1H+k  [kernel.vmlinux]  [k]
> native_queued_spin_lock_slowpath
> 

I'll try to capture a perf report and compare to mine.

Thanks very much,
john
