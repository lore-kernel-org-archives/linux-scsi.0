Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60CB4C64E7A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 01:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04A30221FC
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 01:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgLBBpj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 20:45:39 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8549 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgLBBpi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 20:45:38 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cm1wt1y8jzhlPq;
        Wed,  2 Dec 2020 09:44:30 +0800 (CST)
Received: from [127.0.0.1] (10.74.219.194) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Wed, 2 Dec 2020
 09:44:48 +0800
Subject: Re: [bug report] Hang on sync after dd
To:     Ming Lei <ming.lei@redhat.com>, John Garry <john.garry@huawei.com>
References: <2847d0e1-ccb1-7be6-2456-274e41ea981b@huawei.com>
 <20201201123407.GA487145@T590>
CC:     Hannes Reinecke <hare@suse.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Ewan Milne <emilne@redhat.com>, Long Li <longli@microsoft.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <f30358a5-c930-3363-86fc-9e21639d0874@hisilicon.com>
Date:   Wed, 2 Dec 2020 09:44:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20201201123407.GA487145@T590>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.219.194]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



在 2020/12/1 20:34, Ming Lei 写道:
> On Mon, Nov 30, 2020 at 11:22:33AM +0000, John Garry wrote:
>> Hi all,
>>
>> Some guys internally upgraded to v5.10-rcX and start to see a hang after dd
>> + sync for a large file:
>> - mount /dev/sda1 (ext4 filesystem) to directory /mnt;
>> - run "if=/dev/zero of=test1 bs=1M count=2000" on directory /mnt;
>> - run "sync"
>>
>> and get:
>>
>> [  367.912761] INFO: task jbd2/sdb1-8:3602 blocked for more than 120
>> seconds.
>> [  367.919618]       Not tainted 5.10.0-rc1-109488-g32ded76956b6 #948
>> [  367.925776] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [  367.933579] task:jbd2/sdb1-8     state:D stack:    0 pid: 3602
>> ppid:     2 flags:0x00000028
>> [  367.941901] Call trace:
>> [  367.944351] __switch_to+0xb8/0x168
>> [  367.947840] __schedule+0x30c/0x670
>> [  367.951326] schedule+0x70/0x108
>> [  367.954550] io_schedule+0x1c/0xe8
>> [  367.957948] bit_wait_io+0x18/0x68
>> [  367.961346] __wait_on_bit+0x78/0xf0
>> [  367.964919] out_of_line_wait_on_bit+0x8c/0xb0
>> [  367.969356] __wait_on_buffer+0x30/0x40
>> [  367.973188] jbd2_journal_commit_transaction+0x1370/0x1958
>> [  367.978661] kjournald2+0xcc/0x260
>> [  367.982061] kthread+0x150/0x158
>> [  367.985288] ret_from_fork+0x10/0x34
>> [  367.988860] INFO: task sync:3823 blocked for more than 120 seconds.
>> [  367.995102]       Not tainted 5.10.0-rc1-109488-g32ded76956b6 #948
>> [  368.001265] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [  368.009067] task:sync            state:D stack:    0 pid: 3823 ppid:
>> 3450 flags:0x00000009
>> [  368.017397] Call trace:
>> [  368.019841] __switch_to+0xb8/0x168
>> [  368.023320] __schedule+0x30c/0x670
>> [  368.026804] schedule+0x70/0x108
>> [  368.030025] jbd2_log_wait_commit+0xbc/0x158
>> [  368.034290] ext4_sync_fs+0x188/0x1c8
>> [  368.037947] sync_fs_one_sb+0x30/0x40
>> [  368.041606] iterate_supers+0x9c/0x138
>> [  368.045350] ksys_sync+0x64/0xc0
>> [  368.048569] __arm64_sys_sync+0x10/0x20
>> [  368.052398] el0_svc_common.constprop.3+0x68/0x170
>> [  368.057177] do_el0_svc+0x24/0x90
>> [  368.060482] el0_sync_handler+0x118/0x168
>> [  368.064478]  el0_sync+0x158/0x180
>>
>> The issue was reported here originally:
>> https://lore.kernel.org/linux-ext4/4d18326e-9ca2-d0cb-7cb8-cb56981280da@hisilicon.com/
>>
>> But it looks like issue related to recent work for SCSI MQ.
>>
>> They can only create with hisi_sas v3 hw. I could not create with megaraid
>> sas on the same dev platform or hisi_sas on a similar dev board.
>>
>> Reverting "scsi: core: Only re-run queue in scsi_end_request() if device
>> queue is busy" seems solve the issue. Also, checking out to patch prior to
>> "scsi: hisi_sas: Switch v3 hw to MQ" seems to not have the issue.
> If the issue can be reproduced, you may try the following patch:

I tried the change, and the issue is still.
We find that the number of completed IO is less than dispatched, but 
from sysfs of block device (such as 
/sys/devices/pci0000:74/0000:74:02.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/block/sda/sda1/inflight), 

the number of inflight is 0.


>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 60c7a7d74852..f95bd0e5006e 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -602,6 +602,9 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
>   
>          __blk_mq_end_request(req, error);
>   
> +       if (unlikely(req->end_io))
> +               smp_mb();
> +
>          scsi_run_queue_async(sdev);
>   
>          percpu_ref_put(&q->q_usage_counter);
>
>
> Thanks,
> Ming
>
>
> .
>


