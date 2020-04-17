Return-Path: <SRS0=7BVi=6B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD075C2D0EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 16:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A287A20771
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 16:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgDQQrC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 12:47:02 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2059 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726420AbgDQQrC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Apr 2020 12:47:02 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id A5AEC2902422DABEF175;
        Fri, 17 Apr 2020 17:46:59 +0100 (IST)
Received: from [127.0.0.1] (10.210.172.89) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 17 Apr
 2020 17:46:57 +0100
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
From:   John Garry <john.garry@huawei.com>
Message-ID: <40faaef8-8bfc-639f-747f-cacd4e61464f@huawei.com>
Date:   Fri, 17 Apr 2020 17:46:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <7cac3eb9fd79b5b988e25da542305b35@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.172.89]
X-ClientProxiedBy: lhreml735-chm.china.huawei.com (10.201.108.86) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/04/2020 10:59, Kashyap Desai wrote:

Hi Kashyap,

> 
>>> We have done some level of testing to know performance impact on SAS
>>> SSDs and HDD setup. Here is my finding - My testing used - Two socket
>>> Intel Skylake/Lewisburg/Purley Output of numactl --hardware
>>>
>>> available: 2 nodes (0-1)
>>> node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 36 37 38 39
>>> 40 41
>>> 42 43 44 45 46 47 48 49 50 51 52 53
>>> node 0 size: 31820 MB
>>> node 0 free: 21958 MB
>>> node 1 cpus: 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 54
>>> 55
>>> 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 node 1 size: 32247 MB
>>> node 1 free: 21068 MB node distances:
>>> node   0   1
>>>     0:  10  21
>>>     1:  21  10

Do you have other info, like IRQ-CPU affinity dump and controller PCI 
vendor+device ID? Also /proc/interrupts info would be good after a run, 
like supplied by Sumit here:

https://lore.kernel.org/linux-scsi/CAL2rwxotoWakFS4DPe85hZ4VAgd_zw8pL+B5ckHR9NwEf+-L=g@mail.gmail.com/

Are you enabling some special driver perf mode?

>>>
>>>
>>> 64 HDD setup -
>>>
>>> With higher QD
>> what's OD?
>>
>>> and io schedulder = mq-deadline, shared host tag is not scaling well. >>> If I use ioscheduler = none, I can see consistent 2.0M IOPs.
>>> This issue is seen only with RFC. Without RFC mq-deadline scales up to
>>> 2.0M IOPS.

In theory, from this driver perspective, we should not be making a 
difference. That's after your change to use sdev-> device busy count, 
rather than the hctx nr_active count. As I understand, that's the only 
difference you made.

But I will try an IO scheduler on hisi sas for ssd to see if any difference.

>> I didn't try any scheduler. I can have a look at that.
>>
>>> Perf Top result of RFC - (IOPS = 1.4M IOPS)
>>>
>>>      78.20%  [kernel]        [k] native_queued_spin_lock_slowpath
>>>        1.46%  [kernel]        [k] sbitmap_any_bit_set
>>>        1.14%  [kernel]        [k] blk_mq_run_hw_queue
>>>        0.90%  [kernel]        [k] _mix_pool_bytes
>>>        0.63%  [kernel]        [k] _raw_spin_lock
>>>        0.57%  [kernel]        [k] blk_mq_run_hw_queues
>>>        0.56%  [megaraid_sas]  [k] complete_cmd_fusion
>>>        0.54%  [megaraid_sas]  [k] megasas_build_and_issue_cmd_fusion
>>>        0.50%  [kernel]        [k] dd_has_work
>>>        0.38%  [kernel]        [k] _raw_spin_lock_irqsave
>>>        0.36%  [kernel]        [k] gup_pgd_range
>>>        0.35%  [megaraid_sas]  [k] megasas_build_ldio_fusion
>>>        0.31%  [kernel]        [k] io_submit_one
>>>        0.29%  [kernel]        [k] hctx_lock
>>>        0.26%  [kernel]        [k] try_to_grab_pending
>>>        0.24%  [kernel]        [k] scsi_queue_rq
>>>        0.22%  fio             [.] __fio_gettime
>>>        0.22%  [kernel]        [k] insert_work
>>>        0.20%  [kernel]        [k] native_irq_return_iret
>>>
>>> Perf top without RFC driver - (IOPS = 2.0 M IOPS)
>>>
>>>       58.40%  [kernel]          [k] native_queued_spin_lock_slowpath
>>>        2.06%  [kernel]          [k] _mix_pool_bytes
>>>        1.38%  [kernel]          [k] _raw_spin_lock_irqsave
>>>        0.97%  [kernel]          [k] _raw_spin_lock
>>>        0.91%  [kernel]          [k] scsi_queue_rq
>>>        0.82%  [kernel]          [k] __sbq_wake_up
>>>        0.77%  [kernel]          [k] _raw_spin_unlock_irqrestore
>>>        0.74%  [kernel]          [k] scsi_mq_get_budget
>>>        0.61%  [kernel]          [k] gup_pgd_range
>>>        0.58%  [kernel]          [k] aio_complete_rw
>>>        0.52%  [kernel]          [k] elv_rb_add
>>>        0.50%  [kernel]          [k] llist_add_batch
>>>        0.50%  [kernel]          [k] native_irq_return_iret
>>>        0.48%  [kernel]          [k] blk_rq_map_sg
>>>        0.48%  fio               [.] __fio_gettime
>>>        0.47%  [kernel]          [k] blk_mq_get_tag
>>>        0.44%  [kernel]          [k] blk_mq_dispatch_rq_list
>>>        0.40%  fio               [.] io_u_queued_complete
>>>        0.39%  fio               [.] get_io_u
>>>
>>>
>>> If you want me to test any top up patch, please let me know.  BTW, we
>>> also wants to provide module parameter for user to switch back to
>>> older nr_hw_queue = 1 mode. I will work on that part.
>> ok, but I would just like to reiterate the point that you will not see the
>> full
>> benefit of blk-mq draining hw queues for cpu hotplug since you hide hw
>> queues from blk-mq.
> Agree. We have done  minimal testing using this RFC. We want to ACK this RFC
> as long as primary performance goal is achieved.
> 
> We have done full testing on nr_hw_queue =1 (and that is what customer is
> using) so we at least want to give that interface available for customer for
> some time (assuming they may find some performance gap between two interface
> which we may not have encountered during smoke testing.).
> Over a period of time, if nr_hw_queue = N works for (Broadcom will conduct
> full performance once RFC is committed in upstream) all the IO profiles, we
> will share the information with customer about benefit of using nr_hw_queues
> =  N.

Hopefully you can use nr_hw_queues = N always.

> 

Thanks,
john
