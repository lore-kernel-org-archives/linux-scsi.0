Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8AEC54FD0
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 16:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A543821556
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 16:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729480AbgDWQcj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 12:32:39 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2091 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729423AbgDWQcj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Apr 2020 12:32:39 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 751AA79CD0BB64364E6E;
        Thu, 23 Apr 2020 17:32:35 +0100 (IST)
Received: from [127.0.0.1] (10.47.5.255) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Thu, 23 Apr
 2020 17:32:33 +0100
Subject: Re: [PATCH RFC v6 08/10] megaraid_sas: switch fusion adapters to MQ
From:   John Garry <john.garry@huawei.com>
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
 <380d3bf2-67ee-a09a-3098-51b24b98f912@huawei.com>
Message-ID: <e0c5a076-9fe5-4401-fd41-97f457888ad3@huawei.com>
Date:   Thu, 23 Apr 2020 17:31:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <380d3bf2-67ee-a09a-3098-51b24b98f912@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.5.255]
X-ClientProxiedBy: lhreml722-chm.china.huawei.com (10.201.108.73) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> 
>>> So I tested this on hisi_sas with x12 SAS SSDs, and performance with 
>>> "mq-
>>> deadline" is comparable with "none" @ ~ 2M IOPs. But after a while
>>> performance drops alot, to maybe 700K IOPS. Do you have a similar
>>> experience?
>>
>> I am using mq-deadline only for HDD. I have not tried on SSD since it 
>> is not
>> useful scheduler for SSDs.
>>
> 
> I ask as I only have SAS SSDs to test.
> 
>> I noticed that when I used mq-deadline, performance drop starts if I have
>> more number of drives.
>> I am running <fio> script which has 64 Drives, 64 thread and all 
>> treads are
>> bound to local numa node which has 36 logical cores.
>> I noticed that lock contention is in " dd_dispatch_request". I am not 
>> sure
>> why there is a no penalty of same lock in nr_hw_queue  = 1 mode.
> 
> So this could be just pre-existing issue of exposing multiple queues for 
> SCSI HBAs combined with mq-deadline iosched. I mean, that's really the 
> only significant change in this series, apart from the shared sbitmap, 
> and, at this point, I don't think that is the issue.

As an experiment, I modified hisi_sas mainline driver to expose hw 
queues and manage tags itself, and I see the same issue I mentioned:

Jobs: 12 (f=12): [R(12)] [14.8% done] [7592MB/0KB/0KB /s] [1943K/0/0 
iops] [eta
Jobs: 12 (f=12): [R(12)] [16.4% done] [7949MB/0KB/0KB /s] [2035K/0/0 
iops] [eta
Jobs: 12 (f=12): [R(12)] [18.0% done] [7940MB/0KB/0KB /s] [2033K/0/0 
iops] [eta
Jobs: 12 (f=12): [R(12)] [19.7% done] [7984MB/0KB/0KB /s] [2044K/0/0 
iops] [eta
Jobs: 12 (f=12): [R(12)] [21.3% done] [7984MB/0KB/0KB /s] [2044K/0/0 
iops] [eta
Jobs: 12 (f=12): [R(12)] [23.0% done] [2964MB/0KB/0KB /s] [759K/0/0 
iops] [eta 0
Jobs: 12 (f=12): [R(12)] [24.6% done] [2417MB/0KB/0KB /s] [619K/0/0 
iops] [eta 0
Jobs: 12 (f=12): [R(12)] [26.2% done] [2909MB/0KB/0KB /s] [745K/0/0 
iops] [eta 0
Jobs: 12 (f=12): [R(12)] [27.9% done] [2366MB/0KB/0KB /s] [606K/0/0 
iops] [eta 0

The odd time I see "sched: RT throttling activated" around the time the 
throughput falls. I think issue is the per-queue threaded irq threaded 
handlers consuming too many cycles. With "none" io scheduler, IOPS is 
flat at around 2M.

> 
>>
>> static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
>> {
>>          struct deadline_data *dd = hctx->queue->elevator->elevator_data;
>>          struct request *rq;
>>
>>          spin_lock(&dd->lock);
> 
> So if multiple hctx's are accessing this lock, then much contention 
> possible.
> 
>>          rq = __dd_dispatch_request(dd);
>>          spin_unlock(&dd->lock);
>>
>>          return rq;
>> }
>>
>> Here is perf report -
>>
>> -    1.04%     0.99%  kworker/18:1H+k  [kernel.vmlinux]  [k]
>> native_queued_spin_lock_slowpath
>>       0.99% ret_from_fork
>>      -   kthread
>>        - worker_thread
>>           - 0.98% process_one_work
>>              - 0.98% __blk_mq_run_hw_queue
>>                 - blk_mq_sched_dispatch_requests
>>                    - 0.98% blk_mq_do_dispatch_sched
>>                       - 0.97% dd_dispatch_request
>>                          + 0.97% queued_spin_lock_slowpath
>> +    1.04%     0.00%  kworker/18:1H+k  [kernel.vmlinux]  [k]
>> queued_spin_lock_slowpath
>> +    1.03%     0.95%  kworker/19:1H-k  [kernel.vmlinux]  [k]
>> native_queued_spin_lock_slowpath
>> +    1.03%     0.00%  kworker/19:1H-k  [kernel.vmlinux]  [k]
>> queued_spin_lock_slowpath
>> +    1.02%     0.97%  kworker/20:1H+k  [kernel.vmlinux]  [k]
>> native_queued_spin_lock_slowpath
>> +    1.02%     0.00%  kworker/20:1H+k  [kernel.vmlinux]  [k]
>> queued_spin_lock_slowpath
>> +    1.01%     0.96%  kworker/21:1H+k  [kernel.vmlinux]  [k]
>> native_queued_spin_lock_slowpath
>>
> 
> I'll try to capture a perf report and compare to mine.

Mine is spending a huge amount of time (circa 33% on a cpu servicing 
completion irqs) in mod_delayed_work_on():

--79.89%--sas_scsi_task_done |
    |--76.72%--scsi_mq_done
    |    |
    |     --76.53%--blk_mq_complete_request
    |    |
    |    |--74.81%--scsi_softirq_done
    |    |    |
    |    |     --73.91%--scsi_finish_command
    |    |    |
    |    |    |--72.11%--scsi_io_completion
    |    |    |    |
    |    |    |     --71.89%--scsi_end_request
    |    |    |    |
    |    |    |    |--40.82%--blk_mq_run_hw_queues
    |    |    |    |    |
    |    |    |    |    |--35.86%--blk_mq_run_hw_queue
    |    |    |    |    |    |
    |    |    |    |    |     --33.59%--__blk_mq_delay_run_hw_queue
    |    |    |    |    |    |
    |    |    |    |    |     --33.38%--kblockd_mod_delayed_work_on
    |    |    |    |    |          |
    |    |    |    |    |                --33.31%--mod_delayed_work_on

hmmmm...

Thanks,
John
