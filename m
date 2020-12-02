Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A265C64E8A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 06:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBC9522202
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 06:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727288AbgLBGX3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 01:23:29 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8179 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgLBGX2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 01:23:28 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cm84x5lX0z15Rhq;
        Wed,  2 Dec 2020 14:21:53 +0800 (CST)
Received: from [127.0.0.1] (10.74.219.194) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Wed, 2 Dec 2020
 14:22:10 +0800
Subject: Re: [bug report] Hang on sync after dd
To:     Ming Lei <ming.lei@redhat.com>
References: <2847d0e1-ccb1-7be6-2456-274e41ea981b@huawei.com>
 <20201201123407.GA487145@T590>
 <f30358a5-c930-3363-86fc-9e21639d0874@hisilicon.com>
 <20201202032237.GC494805@T590>
CC:     John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        "Sumit Saxena" <sumit.saxena@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Ewan Milne <emilne@redhat.com>, Long Li <longli@microsoft.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <8cb5cd8e-5a48-dc36-879c-37950e6228c8@hisilicon.com>
Date:   Wed, 2 Dec 2020 14:22:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20201202032237.GC494805@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.219.194]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



在 2020/12/2 11:22, Ming Lei 写道:
> On Wed, Dec 02, 2020 at 09:44:48AM +0800, chenxiang (M) wrote:
>>
>> 在 2020/12/1 20:34, Ming Lei 写道:
>>> On Mon, Nov 30, 2020 at 11:22:33AM +0000, John Garry wrote:
>>>> Hi all,
>>>>
>>>> Some guys internally upgraded to v5.10-rcX and start to see a hang after dd
>>>> + sync for a large file:
>>>> - mount /dev/sda1 (ext4 filesystem) to directory /mnt;
>>>> - run "if=/dev/zero of=test1 bs=1M count=2000" on directory /mnt;
>>>> - run "sync"
>>>>
>>>> and get:
>>>>
>>>> [  367.912761] INFO: task jbd2/sdb1-8:3602 blocked for more than 120
>>>> seconds.
>>>> [  367.919618]       Not tainted 5.10.0-rc1-109488-g32ded76956b6 #948
>>>> [  367.925776] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>>> disables this message.
>>>> [  367.933579] task:jbd2/sdb1-8     state:D stack:    0 pid: 3602
>>>> ppid:     2 flags:0x00000028
>>>> [  367.941901] Call trace:
>>>> [  367.944351] __switch_to+0xb8/0x168
>>>> [  367.947840] __schedule+0x30c/0x670
>>>> [  367.951326] schedule+0x70/0x108
>>>> [  367.954550] io_schedule+0x1c/0xe8
>>>> [  367.957948] bit_wait_io+0x18/0x68
>>>> [  367.961346] __wait_on_bit+0x78/0xf0
>>>> [  367.964919] out_of_line_wait_on_bit+0x8c/0xb0
>>>> [  367.969356] __wait_on_buffer+0x30/0x40
>>>> [  367.973188] jbd2_journal_commit_transaction+0x1370/0x1958
>>>> [  367.978661] kjournald2+0xcc/0x260
>>>> [  367.982061] kthread+0x150/0x158
>>>> [  367.985288] ret_from_fork+0x10/0x34
>>>> [  367.988860] INFO: task sync:3823 blocked for more than 120 seconds.
>>>> [  367.995102]       Not tainted 5.10.0-rc1-109488-g32ded76956b6 #948
>>>> [  368.001265] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>>> disables this message.
>>>> [  368.009067] task:sync            state:D stack:    0 pid: 3823 ppid:
>>>> 3450 flags:0x00000009
>>>> [  368.017397] Call trace:
>>>> [  368.019841] __switch_to+0xb8/0x168
>>>> [  368.023320] __schedule+0x30c/0x670
>>>> [  368.026804] schedule+0x70/0x108
>>>> [  368.030025] jbd2_log_wait_commit+0xbc/0x158
>>>> [  368.034290] ext4_sync_fs+0x188/0x1c8
>>>> [  368.037947] sync_fs_one_sb+0x30/0x40
>>>> [  368.041606] iterate_supers+0x9c/0x138
>>>> [  368.045350] ksys_sync+0x64/0xc0
>>>> [  368.048569] __arm64_sys_sync+0x10/0x20
>>>> [  368.052398] el0_svc_common.constprop.3+0x68/0x170
>>>> [  368.057177] do_el0_svc+0x24/0x90
>>>> [  368.060482] el0_sync_handler+0x118/0x168
>>>> [  368.064478]  el0_sync+0x158/0x180
>>>>
>>>> The issue was reported here originally:
>>>> https://lore.kernel.org/linux-ext4/4d18326e-9ca2-d0cb-7cb8-cb56981280da@hisilicon.com/
>>>>
>>>> But it looks like issue related to recent work for SCSI MQ.
>>>>
>>>> They can only create with hisi_sas v3 hw. I could not create with megaraid
>>>> sas on the same dev platform or hisi_sas on a similar dev board.
>>>>
>>>> Reverting "scsi: core: Only re-run queue in scsi_end_request() if device
>>>> queue is busy" seems solve the issue. Also, checking out to patch prior to
>>>> "scsi: hisi_sas: Switch v3 hw to MQ" seems to not have the issue.
>>> If the issue can be reproduced, you may try the following patch:
>> I tried the change, and the issue is still.
>> We find that the number of completed IO is less than dispatched, but from
>> sysfs of block device (such as /sys/devices/pci0000:74/0000:74:02.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/block/sda/sda1/inflight),
>>
>> the number of inflight is 0.
> Hello chenxiang,
>
> Can you collect the debugfs log via the following commands after the io
> hang is triggered?
>
> 1) debugfs log:
>
>          (cd /sys/kernel/debug/block/sda && find . -type f -exec grep -aH . {} \;)
>
> 2) scsi sysfs info:
>
>          (cd /sys/block/sda/device && find . -type f -exec grep -aH . {} \;)
>
> Suppose the disk is /dev/sda.

The issue occurs on /dev/sdb1, and those logs are as follows (please 
notice that i add the change you provide):

estuary:~$ cd /sys/kernel/debug/block/sdb && find . -type f -exec grep 
-aH . {} \;
./hctx15/cpu31/completed:0 0
./hctx15/cpu31/merged:0
./hctx15/cpu31/dispatched:0 0
./hctx15/cpu30/completed:0 0
./hctx15/cpu30/merged:0
./hctx15/cpu30/dispatched:0 0
./hctx15/cpu29/completed:0 0
./hctx15/cpu29/merged:0
./hctx15/cpu29/dispatched:0 0
./hctx15/cpu28/completed:0 0
./hctx15/cpu28/merged:0
./hctx15/cpu28/dispatched:0 0
./hctx15/cpu27/completed:0 0
./hctx15/cpu27/merged:0
./hctx15/cpu27/dispatched:0 0
./hctx15/cpu26/completed:0 0
./hctx15/cpu26/merged:0
./hctx15/cpu26/dispatched:0 0
./hctx15/cpu25/completed:0 0
./hctx15/cpu25/merged:0
./hctx15/cpu25/dispatched:0 0
./hctx15/cpu24/completed:0 0
./hctx15/cpu24/merged:0
./hctx15/cpu24/dispatched:0 0
./hctx15/type:default
./hctx15/dispatch_busy:0
./hctx15/active:0
./hctx15/run:0
./hctx15/queued:0
./hctx15/dispatched:       0    0
./hctx15/dispatched:       1    0
./hctx15/dispatched:       2    0
./hctx15/dispatched:       4    0
./hctx15/dispatched:       8    0
./hctx15/dispatched:      16    0
./hctx15/dispatched:      32+   0
./hctx15/io_poll:considered=0
./hctx15/io_poll:invoked=0
./hctx15/io_poll:success=0
./hctx15/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:00000020: 0000 0000 0000 0000 0100 0000 0000 0000
./hctx15/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:00000080: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:00000090: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:000000a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:000000b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:000000c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:000000d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:000000e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:000000f0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:00000100: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:00000110: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:00000120: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:00000130: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:00000140: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:00000150: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:00000160: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:00000170: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:00000180: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:00000190: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:000001a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:000001b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:000001c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:000001d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:000001e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx15/tags_bitmap:000001f0: 0000 0000
./hctx15/tags:nr_tags=4000
./hctx15/tags:nr_reserved_tags=0
./hctx15/tags:active_queues=0
./hctx15/tags:bitmap_tags:
./hctx15/tags:depth=4000
./hctx15/tags:busy=1
./hctx15/tags:cleared=3891
./hctx15/tags:bits_per_word=64
./hctx15/tags:map_nr=63
./hctx15/tags:alloc_hint={3264, 3265, 0, 3731, 2462, 842, 0, 0, 1278, 
27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2424, 0, 0, 0, 
346, 3, 3191, 235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 0, 0, 285, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1165, 538, 0, 
372, 277, 3476, 0, 0, 0, 111, 0, 2081, 0, 112, 0, 0, 0, 0, 904, 1127, 0, 
0, 0, 113, 0, 0, 0, 0, 0, 0, 321, 0}
./hctx15/tags:wake_batch=8
./hctx15/tags:wake_index=7
./hctx15/tags:ws_active=0
./hctx15/tags:ws={
./hctx15/tags:  {.wait_cnt=8, .wait=inactive},
./hctx15/tags:  {.wait_cnt=8, .wait=inactive},
./hctx15/tags:  {.wait_cnt=8, .wait=inactive},
./hctx15/tags:  {.wait_cnt=8, .wait=inactive},
./hctx15/tags:  {.wait_cnt=8, .wait=inactive},
./hctx15/tags:  {.wait_cnt=8, .wait=inactive},
./hctx15/tags:  {.wait_cnt=8, .wait=inactive},
./hctx15/tags:  {.wait_cnt=8, .wait=inactive},
./hctx15/tags:}
./hctx15/tags:round_robin=1
./hctx15/tags:min_shallow_depth=4294967295
./hctx15/ctx_map:00000000: 00
./hctx15/flags:alloc_policy=RR SHOULD_MERGE|TAG_QUEUE_SHARED|3
./hctx14/cpu23/completed:0 0
./hctx14/cpu23/merged:0
./hctx14/cpu23/dispatched:0 0
./hctx14/cpu22/completed:0 0
./hctx14/cpu22/merged:0
./hctx14/cpu22/dispatched:0 0
./hctx14/cpu21/completed:0 0
./hctx14/cpu21/merged:0
./hctx14/cpu21/dispatched:0 0
./hctx14/cpu20/completed:0 0
./hctx14/cpu20/merged:0
./hctx14/cpu20/dispatched:0 0
./hctx14/cpu19/completed:0 0
./hctx14/cpu19/merged:0
./hctx14/cpu19/dispatched:0 0
./hctx14/cpu18/completed:0 0
./hctx14/cpu18/merged:0
./hctx14/cpu18/dispatched:0 0
./hctx14/cpu17/completed:0 0
./hctx14/cpu17/merged:0
./hctx14/cpu17/dispatched:0 0
./hctx14/cpu16/completed:0 0
./hctx14/cpu16/merged:0
./hctx14/cpu16/dispatched:0 0
./hctx14/type:default
./hctx14/dispatch_busy:0
./hctx14/active:0
./hctx14/run:0
./hctx14/queued:0
./hctx14/dispatched:       0    0
./hctx14/dispatched:       1    0
./hctx14/dispatched:       2    0
./hctx14/dispatched:       4    0
./hctx14/dispatched:       8    0
./hctx14/dispatched:      16    0
./hctx14/dispatched:      32+   0
./hctx14/io_poll:considered=0
./hctx14/io_poll:invoked=0
./hctx14/io_poll:success=0
./hctx14/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:00000020: 0000 0000 0000 0000 0100 0000 0000 0000
./hctx14/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:00000080: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:00000090: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:000000a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:000000b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:000000c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:000000d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:000000e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:000000f0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:00000100: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:00000110: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:00000120: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:00000130: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:00000140: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:00000150: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:00000160: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:00000170: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:00000180: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:00000190: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:000001a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:000001b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:000001c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:000001d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:000001e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx14/tags_bitmap:000001f0: 0000 0000
./hctx14/tags:nr_tags=4000
./hctx14/tags:nr_reserved_tags=0
./hctx14/tags:active_queues=0
./hctx14/tags:bitmap_tags:
./hctx14/tags:depth=4000
./hctx14/tags:busy=1
./hctx14/tags:cleared=3891
./hctx14/tags:bits_per_word=64
./hctx14/tags:map_nr=63
./hctx14/tags:alloc_hint={3264, 3265, 0, 3731, 2462, 842, 0, 0, 1278, 
27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2424, 0, 0, 0, 
346, 3, 3191, 235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 0, 0, 285, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1165, 538, 0, 
372, 277, 3476, 0, 0, 0, 111, 0, 2081, 0, 112, 0, 0, 0, 0, 904, 1127, 0, 
0, 0, 113, 0, 0, 0, 0, 0, 0, 321, 0}
./hctx14/tags:wake_batch=8
./hctx14/tags:wake_index=7
./hctx14/tags:ws_active=0
./hctx14/tags:ws={
./hctx14/tags:  {.wait_cnt=8, .wait=inactive},
./hctx14/tags:  {.wait_cnt=8, .wait=inactive},
./hctx14/tags:  {.wait_cnt=8, .wait=inactive},
./hctx14/tags:  {.wait_cnt=8, .wait=inactive},
./hctx14/tags:  {.wait_cnt=8, .wait=inactive},
./hctx14/tags:  {.wait_cnt=8, .wait=inactive},
./hctx14/tags:  {.wait_cnt=8, .wait=inactive},
./hctx14/tags:  {.wait_cnt=8, .wait=inactive},
./hctx14/tags:}
./hctx14/tags:round_robin=1
./hctx14/tags:min_shallow_depth=4294967295
./hctx14/ctx_map:00000000: 00
./hctx14/flags:alloc_policy=RR SHOULD_MERGE|TAG_QUEUE_SHARED|3
./hctx13/cpu15/completed:0 0
./hctx13/cpu15/merged:0
./hctx13/cpu15/dispatched:0 0
./hctx13/cpu14/completed:0 0
./hctx13/cpu14/merged:0
./hctx13/cpu14/dispatched:0 0
./hctx13/cpu13/completed:0 0
./hctx13/cpu13/merged:0
./hctx13/cpu13/dispatched:0 0
./hctx13/cpu12/completed:0 0
./hctx13/cpu12/merged:0
./hctx13/cpu12/dispatched:0 0
./hctx13/cpu11/completed:0 0
./hctx13/cpu11/merged:0
./hctx13/cpu11/dispatched:0 0
./hctx13/cpu10/completed:0 0
./hctx13/cpu10/merged:0
./hctx13/cpu10/dispatched:0 0
./hctx13/cpu9/completed:0 0
./hctx13/cpu9/merged:0
./hctx13/cpu9/dispatched:0 0
./hctx13/cpu8/completed:0 0
./hctx13/cpu8/merged:0
./hctx13/cpu8/dispatched:0 0
./hctx13/type:default
./hctx13/dispatch_busy:0
./hctx13/active:0
./hctx13/run:0
./hctx13/queued:0
./hctx13/dispatched:       0    0
./hctx13/dispatched:       1    0
./hctx13/dispatched:       2    0
./hctx13/dispatched:       4    0
./hctx13/dispatched:       8    0
./hctx13/dispatched:      16    0
./hctx13/dispatched:      32+   0
./hctx13/io_poll:considered=0
./hctx13/io_poll:invoked=0
./hctx13/io_poll:success=0
./hctx13/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:00000020: 0000 0000 0000 0000 0100 0000 0000 0000
./hctx13/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:00000080: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:00000090: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:000000a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:000000b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:000000c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:000000d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:000000e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:000000f0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:00000100: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:00000110: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:00000120: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:00000130: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:00000140: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:00000150: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:00000160: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:00000170: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:00000180: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:00000190: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:000001a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:000001b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:000001c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:000001d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:000001e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx13/tags_bitmap:000001f0: 0000 0000
./hctx13/tags:nr_tags=4000
./hctx13/tags:nr_reserved_tags=0
./hctx13/tags:active_queues=0
./hctx13/tags:bitmap_tags:
./hctx13/tags:depth=4000
./hctx13/tags:busy=1
./hctx13/tags:cleared=3891
./hctx13/tags:bits_per_word=64
./hctx13/tags:map_nr=63
./hctx13/tags:alloc_hint={3264, 3265, 0, 3731, 2462, 842, 0, 0, 1278, 
27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2424, 0, 0, 0, 
346, 3, 3191, 235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 0, 0, 285, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1165, 538, 0, 
372, 277, 3476, 0, 0, 0, 111, 0, 2081, 0, 112, 0, 0, 0, 0, 904, 1127, 0, 
0, 0, 113, 0, 0, 0, 0, 0, 0, 321, 0}
./hctx13/tags:wake_batch=8
./hctx13/tags:wake_index=7
./hctx13/tags:ws_active=0
./hctx13/tags:ws={
./hctx13/tags:  {.wait_cnt=8, .wait=inactive},
./hctx13/tags:  {.wait_cnt=8, .wait=inactive},
./hctx13/tags:  {.wait_cnt=8, .wait=inactive},
./hctx13/tags:  {.wait_cnt=8, .wait=inactive},
./hctx13/tags:  {.wait_cnt=8, .wait=inactive},
./hctx13/tags:  {.wait_cnt=8, .wait=inactive},
./hctx13/tags:  {.wait_cnt=8, .wait=inactive},
./hctx13/tags:  {.wait_cnt=8, .wait=inactive},
./hctx13/tags:}
./hctx13/tags:round_robin=1
./hctx13/tags:min_shallow_depth=4294967295
./hctx13/ctx_map:00000000: 00
./hctx13/flags:alloc_policy=RR SHOULD_MERGE|TAG_QUEUE_SHARED|3
./hctx12/cpu7/completed:0 0
./hctx12/cpu7/merged:0
./hctx12/cpu7/dispatched:0 0
./hctx12/cpu6/completed:0 0
./hctx12/cpu6/merged:0
./hctx12/cpu6/dispatched:0 0
./hctx12/cpu5/completed:150 567
./hctx12/cpu5/merged:15
./hctx12/cpu5/dispatched:150 567
./hctx12/cpu4/completed:0 0
./hctx12/cpu4/merged:0
./hctx12/cpu4/dispatched:0 0
./hctx12/cpu3/completed:0 0
./hctx12/cpu3/merged:0
./hctx12/cpu3/dispatched:0 0
./hctx12/cpu2/completed:0 0
./hctx12/cpu2/merged:0
./hctx12/cpu2/dispatched:0 0
./hctx12/cpu1/completed:0 0
./hctx12/cpu1/merged:0
./hctx12/cpu1/dispatched:0 0
./hctx12/cpu0/completed:0 0
./hctx12/cpu0/merged:0
./hctx12/cpu0/dispatched:0 0
./hctx12/type:default
./hctx12/dispatch_busy:7
./hctx12/active:0
./hctx12/run:1486
./hctx12/queued:717
./hctx12/dispatched:       0    821
./hctx12/dispatched:       1    547
./hctx12/dispatched:       2    0
./hctx12/dispatched:       4    0
./hctx12/dispatched:       8    0
./hctx12/dispatched:      16    0
./hctx12/dispatched:      32+   0
./hctx12/io_poll:considered=0
./hctx12/io_poll:invoked=0
./hctx12/io_poll:success=0
./hctx12/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:00000020: 0000 0000 0000 0000 0100 0000 0000 0000
./hctx12/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:00000080: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:00000090: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:000000a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:000000b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:000000c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:000000d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:000000e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:000000f0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:00000100: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:00000110: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:00000120: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:00000130: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:00000140: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:00000150: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:00000160: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:00000170: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:00000180: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:00000190: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:000001a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:000001b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:000001c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:000001d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:000001e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx12/tags_bitmap:000001f0: 0000 0000
./hctx12/tags:nr_tags=4000
./hctx12/tags:nr_reserved_tags=0
./hctx12/tags:active_queues=0
./hctx12/tags:bitmap_tags:
./hctx12/tags:depth=4000
./hctx12/tags:busy=1
./hctx12/tags:cleared=3891
./hctx12/tags:bits_per_word=64
./hctx12/tags:map_nr=63
./hctx12/tags:alloc_hint={3264, 3265, 0, 3731, 2462, 842, 0, 0, 1278, 
27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2424, 0, 0, 0, 
346, 3, 3191, 235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 0, 0, 285, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1165, 538, 0, 
372, 277, 3476, 0, 0, 0, 111, 0, 2081, 0, 112, 0, 0, 0, 0, 904, 1127, 0, 
0, 0, 113, 0, 0, 0, 0, 0, 0, 321, 0}
./hctx12/tags:wake_batch=8
./hctx12/tags:wake_index=7
./hctx12/tags:ws_active=0
./hctx12/tags:ws={
./hctx12/tags:  {.wait_cnt=8, .wait=inactive},
./hctx12/tags:  {.wait_cnt=8, .wait=inactive},
./hctx12/tags:  {.wait_cnt=8, .wait=inactive},
./hctx12/tags:  {.wait_cnt=8, .wait=inactive},
./hctx12/tags:  {.wait_cnt=8, .wait=inactive},
./hctx12/tags:  {.wait_cnt=8, .wait=inactive},
./hctx12/tags:  {.wait_cnt=8, .wait=inactive},
./hctx12/tags:  {.wait_cnt=8, .wait=inactive},
./hctx12/tags:}
./hctx12/tags:round_robin=1
./hctx12/tags:min_shallow_depth=4294967295
./hctx12/ctx_map:00000000: 00
./hctx12/flags:alloc_policy=RR SHOULD_MERGE|TAG_QUEUE_SHARED|3
./hctx11/cpu127/completed:0 0
./hctx11/cpu127/merged:0
./hctx11/cpu127/dispatched:0 0
./hctx11/cpu126/completed:2 0
./hctx11/cpu126/merged:0
./hctx11/cpu126/dispatched:3 0
./hctx11/cpu125/completed:0 0
./hctx11/cpu125/merged:0
./hctx11/cpu125/dispatched:0 0
./hctx11/cpu124/completed:0 0
./hctx11/cpu124/merged:0
./hctx11/cpu124/dispatched:0 0
./hctx11/cpu123/completed:0 0
./hctx11/cpu123/merged:0
./hctx11/cpu123/dispatched:0 0
./hctx11/cpu122/completed:0 0
./hctx11/cpu122/merged:0
./hctx11/cpu122/dispatched:0 0
./hctx11/cpu121/completed:0 0
./hctx11/cpu121/merged:0
./hctx11/cpu121/dispatched:0 0
./hctx11/cpu120/completed:0 0
./hctx11/cpu120/merged:0
./hctx11/cpu120/dispatched:0 0
./hctx11/type:default
./hctx11/dispatch_busy:9
./hctx11/active:0
./hctx11/run:3356
./hctx11/queued:3
./hctx11/dispatched:       0    3336
./hctx11/dispatched:       1    2
./hctx11/dispatched:       2    0
./hctx11/dispatched:       4    0
./hctx11/dispatched:       8    0
./hctx11/dispatched:      16    0
./hctx11/dispatched:      32+   0
./hctx11/io_poll:considered=0
./hctx11/io_poll:invoked=0
./hctx11/io_poll:success=0
./hctx11/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:00000020: 0000 0000 0000 0000 0100 0000 0000 0000
./hctx11/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:00000080: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:00000090: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:000000a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:000000b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:000000c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:000000d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:000000e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:000000f0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:00000100: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:00000110: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:00000120: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:00000130: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:00000140: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:00000150: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:00000160: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:00000170: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:00000180: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:00000190: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:000001a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:000001b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:000001c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:000001d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:000001e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx11/tags_bitmap:000001f0: 0000 0000
./hctx11/tags:nr_tags=4000
./hctx11/tags:nr_reserved_tags=0
./hctx11/tags:active_queues=0
./hctx11/tags:bitmap_tags:
./hctx11/tags:depth=4000
./hctx11/tags:busy=1
./hctx11/tags:cleared=3891
./hctx11/tags:bits_per_word=64
./hctx11/tags:map_nr=63
./hctx11/tags:alloc_hint={3264, 3265, 0, 3731, 2462, 842, 0, 0, 1278, 
27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2424, 0, 0, 0, 
346, 3, 3191, 235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 0, 0, 285, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1165, 538, 0, 
372, 277, 3476, 0, 0, 0, 111, 0, 2081, 0, 112, 0, 0, 0, 0, 904, 1127, 0, 
0, 0, 113, 0, 0, 0, 0, 0, 0, 321, 0}
./hctx11/tags:wake_batch=8
./hctx11/tags:wake_index=7
./hctx11/tags:ws_active=0
./hctx11/tags:ws={
./hctx11/tags:  {.wait_cnt=8, .wait=inactive},
./hctx11/tags:  {.wait_cnt=8, .wait=inactive},
./hctx11/tags:  {.wait_cnt=8, .wait=inactive},
./hctx11/tags:  {.wait_cnt=8, .wait=inactive},
./hctx11/tags:  {.wait_cnt=8, .wait=inactive},
./hctx11/tags:  {.wait_cnt=8, .wait=inactive},
./hctx11/tags:  {.wait_cnt=8, .wait=inactive},
./hctx11/tags:  {.wait_cnt=8, .wait=inactive},
./hctx11/tags:}
./hctx11/tags:round_robin=1
./hctx11/tags:min_shallow_depth=4294967295
./hctx11/ctx_map:00000000: 00
./hctx11/dispatch:000000005b673391 {.op=FLUSH, .cmd_flags=PREFLUSH, 
.rq_flags=FLUSH_SEQ|MQ_INFLIGHT|DONTPREP, .state=idle, .tag=320, 
.internal_tag=-1, .cmd=opcode=0x35 35 00 00 00 00 00 00 00 00 00, 
.retries=0, .result = 0x0, .flags=TAGGED|INITIALIZED|3, .timeout=60.000, 
allocated 103.948 s ago}
./hctx11/flags:alloc_policy=RR SHOULD_MERGE|TAG_QUEUE_SHARED|3
./hctx11/state:SCHED_RESTART
./hctx10/cpu119/completed:0 0
./hctx10/cpu119/merged:0
./hctx10/cpu119/dispatched:0 0
./hctx10/cpu118/completed:0 0
./hctx10/cpu118/merged:0
./hctx10/cpu118/dispatched:0 0
./hctx10/cpu117/completed:0 0
./hctx10/cpu117/merged:0
./hctx10/cpu117/dispatched:0 0
./hctx10/cpu116/completed:0 0
./hctx10/cpu116/merged:0
./hctx10/cpu116/dispatched:0 0
./hctx10/cpu115/completed:0 0
./hctx10/cpu115/merged:0
./hctx10/cpu115/dispatched:0 0
./hctx10/cpu114/completed:0 0
./hctx10/cpu114/merged:0
./hctx10/cpu114/dispatched:0 0
./hctx10/cpu113/completed:0 0
./hctx10/cpu113/merged:0
./hctx10/cpu113/dispatched:0 0
./hctx10/cpu112/completed:0 0
./hctx10/cpu112/merged:0
./hctx10/cpu112/dispatched:0 0
./hctx10/type:default
./hctx10/dispatch_busy:0
./hctx10/active:0
./hctx10/run:0
./hctx10/queued:0
./hctx10/dispatched:       0    0
./hctx10/dispatched:       1    0
./hctx10/dispatched:       2    0
./hctx10/dispatched:       4    0
./hctx10/dispatched:       8    0
./hctx10/dispatched:      16    0
./hctx10/dispatched:      32+   0
./hctx10/io_poll:considered=0
./hctx10/io_poll:invoked=0
./hctx10/io_poll:success=0
./hctx10/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:00000020: 0000 0000 0000 0000 0100 0000 0000 0000
./hctx10/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:00000080: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:00000090: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:000000a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:000000b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:000000c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:000000d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:000000e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:000000f0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:00000100: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:00000110: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:00000120: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:00000130: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:00000140: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:00000150: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:00000160: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:00000170: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:00000180: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:00000190: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:000001a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:000001b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:000001c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:000001d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:000001e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx10/tags_bitmap:000001f0: 0000 0000
./hctx10/tags:nr_tags=4000
./hctx10/tags:nr_reserved_tags=0
./hctx10/tags:active_queues=0
./hctx10/tags:bitmap_tags:
./hctx10/tags:depth=4000
./hctx10/tags:busy=1
./hctx10/tags:cleared=3891
./hctx10/tags:bits_per_word=64
./hctx10/tags:map_nr=63
./hctx10/tags:alloc_hint={3264, 3265, 0, 3731, 2462, 842, 0, 0, 1278, 
27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2424, 0, 0, 0, 
346, 3, 3191, 235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 0, 0, 285, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1165, 538, 0, 
372, 277, 3476, 0, 0, 0, 111, 0, 2081, 0, 112, 0, 0, 0, 0, 904, 1127, 0, 
0, 0, 113, 0, 0, 0, 0, 0, 0, 321, 0}
./hctx10/tags:wake_batch=8
./hctx10/tags:wake_index=7
./hctx10/tags:ws_active=0
./hctx10/tags:ws={
./hctx10/tags:  {.wait_cnt=8, .wait=inactive},
./hctx10/tags:  {.wait_cnt=8, .wait=inactive},
./hctx10/tags:  {.wait_cnt=8, .wait=inactive},
./hctx10/tags:  {.wait_cnt=8, .wait=inactive},
./hctx10/tags:  {.wait_cnt=8, .wait=inactive},
./hctx10/tags:  {.wait_cnt=8, .wait=inactive},
./hctx10/tags:  {.wait_cnt=8, .wait=inactive},
./hctx10/tags:  {.wait_cnt=8, .wait=inactive},
./hctx10/tags:}
./hctx10/tags:round_robin=1
./hctx10/tags:min_shallow_depth=4294967295
./hctx10/ctx_map:00000000: 00
./hctx10/flags:alloc_policy=RR SHOULD_MERGE|TAG_QUEUE_SHARED|3
./hctx9/cpu111/completed:0 0
./hctx9/cpu111/merged:0
./hctx9/cpu111/dispatched:0 0
./hctx9/cpu110/completed:0 0
./hctx9/cpu110/merged:0
./hctx9/cpu110/dispatched:0 0
./hctx9/cpu109/completed:0 0
./hctx9/cpu109/merged:0
./hctx9/cpu109/dispatched:0 0
./hctx9/cpu108/completed:0 0
./hctx9/cpu108/merged:0
./hctx9/cpu108/dispatched:0 0
./hctx9/cpu107/completed:0 0
./hctx9/cpu107/merged:0
./hctx9/cpu107/dispatched:0 0
./hctx9/cpu106/completed:0 0
./hctx9/cpu106/merged:0
./hctx9/cpu106/dispatched:0 0
./hctx9/cpu105/completed:0 0
./hctx9/cpu105/merged:0
./hctx9/cpu105/dispatched:0 0
./hctx9/cpu104/completed:0 0
./hctx9/cpu104/merged:0
./hctx9/cpu104/dispatched:0 0
./hctx9/type:default
./hctx9/dispatch_busy:0
./hctx9/active:0
./hctx9/run:0
./hctx9/queued:0
./hctx9/dispatched:       0     0
./hctx9/dispatched:       1     0
./hctx9/dispatched:       2     0
./hctx9/dispatched:       4     0
./hctx9/dispatched:       8     0
./hctx9/dispatched:      16     0
./hctx9/dispatched:      32+    0
./hctx9/io_poll:considered=0
./hctx9/io_poll:invoked=0
./hctx9/io_poll:success=0
./hctx9/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:00000020: 0000 0000 0000 0000 0100 0000 0000 0000
./hctx9/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:00000080: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:00000090: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:000000a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:000000b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:000000c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:000000d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:000000e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:000000f0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:00000100: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:00000110: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:00000120: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:00000130: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:00000140: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:00000150: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:00000160: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:00000170: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:00000180: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:00000190: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:000001a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:000001b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:000001c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:000001d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:000001e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx9/tags_bitmap:000001f0: 0000 0000
./hctx9/tags:nr_tags=4000
./hctx9/tags:nr_reserved_tags=0
./hctx9/tags:active_queues=0
./hctx9/tags:bitmap_tags:
./hctx9/tags:depth=4000
./hctx9/tags:busy=1
./hctx9/tags:cleared=3891
./hctx9/tags:bits_per_word=64
./hctx9/tags:map_nr=63
./hctx9/tags:alloc_hint={3264, 3265, 0, 3731, 2462, 842, 0, 0, 1278, 27, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2424, 0, 0, 0, 
346, 3, 3191, 235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 0, 0, 285, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1165, 538, 0, 
372, 277, 3476, 0, 0, 0, 111, 0, 2081, 0, 112, 0, 0, 0, 0, 904, 1127, 0, 
0, 0, 113, 0, 0, 0, 0, 0, 0, 321, 0}
./hctx9/tags:wake_batch=8
./hctx9/tags:wake_index=7
./hctx9/tags:ws_active=0
./hctx9/tags:ws={
./hctx9/tags:   {.wait_cnt=8, .wait=inactive},
./hctx9/tags:   {.wait_cnt=8, .wait=inactive},
./hctx9/tags:   {.wait_cnt=8, .wait=inactive},
./hctx9/tags:   {.wait_cnt=8, .wait=inactive},
./hctx9/tags:   {.wait_cnt=8, .wait=inactive},
./hctx9/tags:   {.wait_cnt=8, .wait=inactive},
./hctx9/tags:   {.wait_cnt=8, .wait=inactive},
./hctx9/tags:   {.wait_cnt=8, .wait=inactive},
./hctx9/tags:}
./hctx9/tags:round_robin=1
./hctx9/tags:min_shallow_depth=4294967295
./hctx9/ctx_map:00000000: 00
./hctx9/flags:alloc_policy=RR SHOULD_MERGE|TAG_QUEUE_SHARED|3
./hctx8/cpu103/completed:0 0
./hctx8/cpu103/merged:0
./hctx8/cpu103/dispatched:0 0
./hctx8/cpu102/completed:0 0
./hctx8/cpu102/merged:0
./hctx8/cpu102/dispatched:0 0
./hctx8/cpu101/completed:0 2933
./hctx8/cpu101/merged:0
./hctx8/cpu101/dispatched:0 2933
./hctx8/cpu100/completed:0 0
./hctx8/cpu100/merged:0
./hctx8/cpu100/dispatched:0 0
./hctx8/cpu99/completed:0 0
./hctx8/cpu99/merged:0
./hctx8/cpu99/dispatched:0 0
./hctx8/cpu98/completed:0 0
./hctx8/cpu98/merged:0
./hctx8/cpu98/dispatched:0 0
./hctx8/cpu97/completed:0 0
./hctx8/cpu97/merged:0
./hctx8/cpu97/dispatched:0 0
./hctx8/cpu96/completed:1303 1302
./hctx8/cpu96/merged:0
./hctx8/cpu96/dispatched:1303 1302
./hctx8/type:default
./hctx8/dispatch_busy:0
./hctx8/active:0
./hctx8/run:6865
./hctx8/queued:5538
./hctx8/dispatched:       0     2986
./hctx8/dispatched:       1     3375
./hctx8/dispatched:       2     1
./hctx8/dispatched:       4     1
./hctx8/dispatched:       8     0
./hctx8/dispatched:      16     0
./hctx8/dispatched:      32+    0
./hctx8/io_poll:considered=0
./hctx8/io_poll:invoked=0
./hctx8/io_poll:success=0
./hctx8/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:00000020: 0000 0000 0000 0000 0100 0000 0000 0000
./hctx8/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:00000080: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:00000090: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:000000a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:000000b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:000000c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:000000d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:000000e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:000000f0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:00000100: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:00000110: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:00000120: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:00000130: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:00000140: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:00000150: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:00000160: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:00000170: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:00000180: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:00000190: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:000001a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:000001b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:000001c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:000001d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:000001e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx8/tags_bitmap:000001f0: 0000 0000
./hctx8/tags:nr_tags=4000
./hctx8/tags:nr_reserved_tags=0
./hctx8/tags:active_queues=0
./hctx8/tags:bitmap_tags:
./hctx8/tags:depth=4000
./hctx8/tags:busy=1
./hctx8/tags:cleared=3891
./hctx8/tags:bits_per_word=64
./hctx8/tags:map_nr=63
./hctx8/tags:alloc_hint={3264, 3265, 0, 3731, 2462, 842, 0, 0, 1278, 27, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2424, 0, 0, 0, 
346, 3, 3191, 235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 0, 0, 285, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1165, 538, 0, 
372, 277, 3476, 0, 0, 0, 111, 0, 2081, 0, 112, 0, 0, 0, 0, 904, 1127, 0, 
0, 0, 113, 0, 0, 0, 0, 0, 0, 321, 0}
./hctx8/tags:wake_batch=8
./hctx8/tags:wake_index=7
./hctx8/tags:ws_active=0
./hctx8/tags:ws={
./hctx8/tags:   {.wait_cnt=8, .wait=inactive},
./hctx8/tags:   {.wait_cnt=8, .wait=inactive},
./hctx8/tags:   {.wait_cnt=8, .wait=inactive},
./hctx8/tags:   {.wait_cnt=8, .wait=inactive},
./hctx8/tags:   {.wait_cnt=8, .wait=inactive},
./hctx8/tags:   {.wait_cnt=8, .wait=inactive},
./hctx8/tags:   {.wait_cnt=8, .wait=inactive},
./hctx8/tags:   {.wait_cnt=8, .wait=inactive},
./hctx8/tags:}
./hctx8/tags:round_robin=1
./hctx8/tags:min_shallow_depth=4294967295
./hctx8/ctx_map:00000000: 00
./hctx8/flags:alloc_policy=RR SHOULD_MERGE|TAG_QUEUE_SHARED|3
./hctx7/cpu95/completed:0 0
./hctx7/cpu95/merged:0
./hctx7/cpu95/dispatched:0 0
./hctx7/cpu94/completed:0 0
./hctx7/cpu94/merged:0
./hctx7/cpu94/dispatched:0 0
./hctx7/cpu93/completed:0 0
./hctx7/cpu93/merged:0
./hctx7/cpu93/dispatched:0 0
./hctx7/cpu92/completed:0 0
./hctx7/cpu92/merged:0
./hctx7/cpu92/dispatched:0 0
./hctx7/cpu91/completed:0 0
./hctx7/cpu91/merged:0
./hctx7/cpu91/dispatched:0 0
./hctx7/cpu90/completed:0 0
./hctx7/cpu90/merged:0
./hctx7/cpu90/dispatched:0 0
./hctx7/cpu89/completed:0 0
./hctx7/cpu89/merged:0
./hctx7/cpu89/dispatched:0 0
./hctx7/cpu88/completed:0 0
./hctx7/cpu88/merged:0
./hctx7/cpu88/dispatched:0 0
./hctx7/type:default
./hctx7/dispatch_busy:0
./hctx7/active:0
./hctx7/run:0
./hctx7/queued:0
./hctx7/dispatched:       0     0
./hctx7/dispatched:       1     0
./hctx7/dispatched:       2     0
./hctx7/dispatched:       4     0
./hctx7/dispatched:       8     0
./hctx7/dispatched:      16     0
./hctx7/dispatched:      32+    0
./hctx7/io_poll:considered=0
./hctx7/io_poll:invoked=0
./hctx7/io_poll:success=0
./hctx7/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:00000020: 0000 0000 0000 0000 0100 0000 0000 0000
./hctx7/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:00000080: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:00000090: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:000000a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:000000b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:000000c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:000000d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:000000e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:000000f0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:00000100: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:00000110: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:00000120: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:00000130: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:00000140: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:00000150: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:00000160: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:00000170: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:00000180: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:00000190: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:000001a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:000001b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:000001c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:000001d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:000001e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx7/tags_bitmap:000001f0: 0000 0000
./hctx7/tags:nr_tags=4000
./hctx7/tags:nr_reserved_tags=0
./hctx7/tags:active_queues=0
./hctx7/tags:bitmap_tags:
./hctx7/tags:depth=4000
./hctx7/tags:busy=1
./hctx7/tags:cleared=3891
./hctx7/tags:bits_per_word=64
./hctx7/tags:map_nr=63
./hctx7/tags:alloc_hint={3264, 3265, 0, 3731, 2462, 842, 0, 0, 1278, 27, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2424, 0, 0, 0, 
346, 3, 3191, 235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 0, 0, 285, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1165, 538, 0, 
372, 277, 3476, 0, 0, 0, 111, 0, 2081, 0, 112, 0, 0, 0, 0, 904, 1127, 0, 
0, 0, 113, 0, 0, 0, 0, 0, 0, 321, 0}
./hctx7/tags:wake_batch=8
./hctx7/tags:wake_index=7
./hctx7/tags:ws_active=0
./hctx7/tags:ws={
./hctx7/tags:   {.wait_cnt=8, .wait=inactive},
./hctx7/tags:   {.wait_cnt=8, .wait=inactive},
./hctx7/tags:   {.wait_cnt=8, .wait=inactive},
./hctx7/tags:   {.wait_cnt=8, .wait=inactive},
./hctx7/tags:   {.wait_cnt=8, .wait=inactive},
./hctx7/tags:   {.wait_cnt=8, .wait=inactive},
./hctx7/tags:   {.wait_cnt=8, .wait=inactive},
./hctx7/tags:   {.wait_cnt=8, .wait=inactive},
./hctx7/tags:}
./hctx7/tags:round_robin=1
./hctx7/tags:min_shallow_depth=4294967295
./hctx7/ctx_map:00000000: 00
./hctx7/flags:alloc_policy=RR SHOULD_MERGE|TAG_QUEUE_SHARED|3
./hctx6/cpu87/completed:0 0
./hctx6/cpu87/merged:0
./hctx6/cpu87/dispatched:0 0
./hctx6/cpu86/completed:0 0
./hctx6/cpu86/merged:0
./hctx6/cpu86/dispatched:0 0
./hctx6/cpu85/completed:0 0
./hctx6/cpu85/merged:0
./hctx6/cpu85/dispatched:0 0
./hctx6/cpu84/completed:0 0
./hctx6/cpu84/merged:0
./hctx6/cpu84/dispatched:0 0
./hctx6/cpu83/completed:0 0
./hctx6/cpu83/merged:0
./hctx6/cpu83/dispatched:0 0
./hctx6/cpu82/completed:0 0
./hctx6/cpu82/merged:0
./hctx6/cpu82/dispatched:0 0
./hctx6/cpu81/completed:0 0
./hctx6/cpu81/merged:0
./hctx6/cpu81/dispatched:0 0
./hctx6/cpu80/completed:0 0
./hctx6/cpu80/merged:0
./hctx6/cpu80/dispatched:0 0
./hctx6/type:default
./hctx6/dispatch_busy:0
./hctx6/active:0
./hctx6/run:0
./hctx6/queued:0
./hctx6/dispatched:       0     0
./hctx6/dispatched:       1     0
./hctx6/dispatched:       2     0
./hctx6/dispatched:       4     0
./hctx6/dispatched:       8     0
./hctx6/dispatched:      16     0
./hctx6/dispatched:      32+    0
./hctx6/io_poll:considered=0
./hctx6/io_poll:invoked=0
./hctx6/io_poll:success=0
./hctx6/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:00000020: 0000 0000 0000 0000 0100 0000 0000 0000
./hctx6/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:00000080: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:00000090: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:000000a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:000000b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:000000c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:000000d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:000000e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:000000f0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:00000100: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:00000110: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:00000120: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:00000130: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:00000140: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:00000150: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:00000160: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:00000170: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:00000180: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:00000190: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:000001a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:000001b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:000001c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:000001d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:000001e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx6/tags_bitmap:000001f0: 0000 0000
./hctx6/tags:nr_tags=4000
./hctx6/tags:nr_reserved_tags=0
./hctx6/tags:active_queues=0
./hctx6/tags:bitmap_tags:
./hctx6/tags:depth=4000
./hctx6/tags:busy=1
./hctx6/tags:cleared=3891
./hctx6/tags:bits_per_word=64
./hctx6/tags:map_nr=63
./hctx6/tags:alloc_hint={3264, 3265, 0, 3731, 2462, 842, 0, 0, 1278, 27, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2424, 0, 0, 0, 
346, 3, 3191, 235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 0, 0, 285, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1165, 538, 0, 
372, 277, 3476, 0, 0, 0, 111, 0, 2081, 0, 112, 0, 0, 0, 0, 904, 1127, 0, 
0, 0, 113, 0, 0, 0, 0, 0, 0, 321, 0}
./hctx6/tags:wake_batch=8
./hctx6/tags:wake_index=7
./hctx6/tags:ws_active=0
./hctx6/tags:ws={
./hctx6/tags:   {.wait_cnt=8, .wait=inactive},
./hctx6/tags:   {.wait_cnt=8, .wait=inactive},
./hctx6/tags:   {.wait_cnt=8, .wait=inactive},
./hctx6/tags:   {.wait_cnt=8, .wait=inactive},
./hctx6/tags:   {.wait_cnt=8, .wait=inactive},
./hctx6/tags:   {.wait_cnt=8, .wait=inactive},
./hctx6/tags:   {.wait_cnt=8, .wait=inactive},
./hctx6/tags:   {.wait_cnt=8, .wait=inactive},
./hctx6/tags:}
./hctx6/tags:round_robin=1
./hctx6/tags:min_shallow_depth=4294967295
./hctx6/ctx_map:00000000: 00
./hctx6/flags:alloc_policy=RR SHOULD_MERGE|TAG_QUEUE_SHARED|3
./hctx5/cpu79/completed:0 0
./hctx5/cpu79/merged:0
./hctx5/cpu79/dispatched:0 0
./hctx5/cpu78/completed:0 0
./hctx5/cpu78/merged:0
./hctx5/cpu78/dispatched:0 0
./hctx5/cpu77/completed:0 0
./hctx5/cpu77/merged:0
./hctx5/cpu77/dispatched:0 0
./hctx5/cpu76/completed:0 0
./hctx5/cpu76/merged:0
./hctx5/cpu76/dispatched:0 0
./hctx5/cpu75/completed:0 0
./hctx5/cpu75/merged:0
./hctx5/cpu75/dispatched:0 0
./hctx5/cpu74/completed:0 0
./hctx5/cpu74/merged:0
./hctx5/cpu74/dispatched:0 0
./hctx5/cpu73/completed:0 0
./hctx5/cpu73/merged:0
./hctx5/cpu73/dispatched:0 0
./hctx5/cpu72/completed:0 0
./hctx5/cpu72/merged:0
./hctx5/cpu72/dispatched:0 0
./hctx5/type:default
./hctx5/dispatch_busy:0
./hctx5/active:0
./hctx5/run:0
./hctx5/queued:0
./hctx5/dispatched:       0     0
./hctx5/dispatched:       1     0
./hctx5/dispatched:       2     0
./hctx5/dispatched:       4     0
./hctx5/dispatched:       8     0
./hctx5/dispatched:      16     0
./hctx5/dispatched:      32+    0
./hctx5/io_poll:considered=0
./hctx5/io_poll:invoked=0
./hctx5/io_poll:success=0
./hctx5/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:00000020: 0000 0000 0000 0000 0100 0000 0000 0000
./hctx5/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:00000080: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:00000090: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:000000a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:000000b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:000000c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:000000d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:000000e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:000000f0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:00000100: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:00000110: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:00000120: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:00000130: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:00000140: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:00000150: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:00000160: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:00000170: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:00000180: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:00000190: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:000001a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:000001b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:000001c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:000001d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:000001e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx5/tags_bitmap:000001f0: 0000 0000
./hctx5/tags:nr_tags=4000
./hctx5/tags:nr_reserved_tags=0
./hctx5/tags:active_queues=0
./hctx5/tags:bitmap_tags:
./hctx5/tags:depth=4000
./hctx5/tags:busy=1
./hctx5/tags:cleared=3891
./hctx5/tags:bits_per_word=64
./hctx5/tags:map_nr=63
./hctx5/tags:alloc_hint={3264, 3265, 0, 3731, 2462, 842, 0, 0, 1278, 27, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2424, 0, 0, 0, 
346, 3, 3191, 235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 0, 0, 285, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1165, 538, 0, 
372, 277, 3476, 0, 0, 0, 111, 0, 2081, 0, 112, 0, 0, 0, 0, 904, 1127, 0, 
0, 0, 113, 0, 0, 0, 0, 0, 0, 321, 0}
./hctx5/tags:wake_batch=8
./hctx5/tags:wake_index=7
./hctx5/tags:ws_active=0
./hctx5/tags:ws={
./hctx5/tags:   {.wait_cnt=8, .wait=inactive},
./hctx5/tags:   {.wait_cnt=8, .wait=inactive},
./hctx5/tags:   {.wait_cnt=8, .wait=inactive},
./hctx5/tags:   {.wait_cnt=8, .wait=inactive},
./hctx5/tags:   {.wait_cnt=8, .wait=inactive},
./hctx5/tags:   {.wait_cnt=8, .wait=inactive},
./hctx5/tags:   {.wait_cnt=8, .wait=inactive},
./hctx5/tags:   {.wait_cnt=8, .wait=inactive},
./hctx5/tags:}
./hctx5/tags:round_robin=1
./hctx5/tags:min_shallow_depth=4294967295
./hctx5/ctx_map:00000000: 00
./hctx5/flags:alloc_policy=RR SHOULD_MERGE|TAG_QUEUE_SHARED|3
./hctx4/cpu71/completed:0 0
./hctx4/cpu71/merged:0
./hctx4/cpu71/dispatched:0 0
./hctx4/cpu70/completed:0 0
./hctx4/cpu70/merged:0
./hctx4/cpu70/dispatched:0 0
./hctx4/cpu69/completed:0 0
./hctx4/cpu69/merged:0
./hctx4/cpu69/dispatched:0 0
./hctx4/cpu68/completed:0 0
./hctx4/cpu68/merged:0
./hctx4/cpu68/dispatched:0 0
./hctx4/cpu67/completed:8 28
./hctx4/cpu67/merged:0
./hctx4/cpu67/dispatched:8 28
./hctx4/cpu66/completed:0 8
./hctx4/cpu66/merged:0
./hctx4/cpu66/dispatched:0 8
./hctx4/cpu65/completed:0 0
./hctx4/cpu65/merged:0
./hctx4/cpu65/dispatched:0 0
./hctx4/cpu64/completed:0 0
./hctx4/cpu64/merged:0
./hctx4/cpu64/dispatched:0 0
./hctx4/type:default
./hctx4/dispatch_busy:0
./hctx4/active:0
./hctx4/run:36
./hctx4/queued:44
./hctx4/dispatched:       0     0
./hctx4/dispatched:       1     36
./hctx4/dispatched:       2     0
./hctx4/dispatched:       4     0
./hctx4/dispatched:       8     0
./hctx4/dispatched:      16     0
./hctx4/dispatched:      32+    0
./hctx4/io_poll:considered=0
./hctx4/io_poll:invoked=0
./hctx4/io_poll:success=0
./hctx4/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:00000020: 0000 0000 0000 0000 0100 0000 0000 0000
./hctx4/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:00000080: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:00000090: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:000000a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:000000b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:000000c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:000000d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:000000e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:000000f0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:00000100: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:00000110: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:00000120: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:00000130: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:00000140: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:00000150: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:00000160: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:00000170: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:00000180: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:00000190: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:000001a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:000001b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:000001c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:000001d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:000001e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx4/tags_bitmap:000001f0: 0000 0000
./hctx4/tags:nr_tags=4000
./hctx4/tags:nr_reserved_tags=0
./hctx4/tags:active_queues=0
./hctx4/tags:bitmap_tags:
./hctx4/tags:depth=4000
./hctx4/tags:busy=1
./hctx4/tags:cleared=3891
./hctx4/tags:bits_per_word=64
./hctx4/tags:map_nr=63
./hctx4/tags:alloc_hint={3264, 3265, 0, 3731, 2462, 842, 0, 0, 1278, 27, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2424, 0, 0, 0, 
346, 3, 3191, 235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 0, 0, 285, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1165, 538, 0, 
372, 277, 3476, 0, 0, 0, 111, 0, 2081, 0, 112, 0, 0, 0, 0, 904, 1127, 0, 
0, 0, 113, 0, 0, 0, 0, 0, 0, 321, 0}
./hctx4/tags:wake_batch=8
./hctx4/tags:wake_index=7
./hctx4/tags:ws_active=0
./hctx4/tags:ws={
./hctx4/tags:   {.wait_cnt=8, .wait=inactive},
./hctx4/tags:   {.wait_cnt=8, .wait=inactive},
./hctx4/tags:   {.wait_cnt=8, .wait=inactive},
./hctx4/tags:   {.wait_cnt=8, .wait=inactive},
./hctx4/tags:   {.wait_cnt=8, .wait=inactive},
./hctx4/tags:   {.wait_cnt=8, .wait=inactive},
./hctx4/tags:   {.wait_cnt=8, .wait=inactive},
./hctx4/tags:   {.wait_cnt=8, .wait=inactive},
./hctx4/tags:}
./hctx4/tags:round_robin=1
./hctx4/tags:min_shallow_depth=4294967295
./hctx4/ctx_map:00000000: 00
./hctx4/flags:alloc_policy=RR SHOULD_MERGE|TAG_QUEUE_SHARED|3
./hctx3/cpu63/completed:0 0
./hctx3/cpu63/merged:0
./hctx3/cpu63/dispatched:0 0
./hctx3/cpu62/completed:0 0
./hctx3/cpu62/merged:0
./hctx3/cpu62/dispatched:0 0
./hctx3/cpu61/completed:0 0
./hctx3/cpu61/merged:0
./hctx3/cpu61/dispatched:0 0
./hctx3/cpu60/completed:0 0
./hctx3/cpu60/merged:0
./hctx3/cpu60/dispatched:0 0
./hctx3/cpu59/completed:0 0
./hctx3/cpu59/merged:0
./hctx3/cpu59/dispatched:0 0
./hctx3/cpu58/completed:0 0
./hctx3/cpu58/merged:0
./hctx3/cpu58/dispatched:0 0
./hctx3/cpu57/completed:0 0
./hctx3/cpu57/merged:0
./hctx3/cpu57/dispatched:0 0
./hctx3/cpu56/completed:0 0
./hctx3/cpu56/merged:0
./hctx3/cpu56/dispatched:0 0
./hctx3/type:default
./hctx3/dispatch_busy:0
./hctx3/active:0
./hctx3/run:0
./hctx3/queued:0
./hctx3/dispatched:       0     0
./hctx3/dispatched:       1     0
./hctx3/dispatched:       2     0
./hctx3/dispatched:       4     0
./hctx3/dispatched:       8     0
./hctx3/dispatched:      16     0
./hctx3/dispatched:      32+    0
./hctx3/io_poll:considered=0
./hctx3/io_poll:invoked=0
./hctx3/io_poll:success=0
./hctx3/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:00000020: 0000 0000 0000 0000 0100 0000 0000 0000
./hctx3/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:00000080: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:00000090: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:000000a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:000000b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:000000c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:000000d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:000000e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:000000f0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:00000100: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:00000110: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:00000120: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:00000130: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:00000140: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:00000150: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:00000160: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:00000170: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:00000180: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:00000190: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:000001a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:000001b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:000001c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:000001d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:000001e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx3/tags_bitmap:000001f0: 0000 0000
./hctx3/tags:nr_tags=4000
./hctx3/tags:nr_reserved_tags=0
./hctx3/tags:active_queues=0
./hctx3/tags:bitmap_tags:
./hctx3/tags:depth=4000
./hctx3/tags:busy=1
./hctx3/tags:cleared=3891
./hctx3/tags:bits_per_word=64
./hctx3/tags:map_nr=63
./hctx3/tags:alloc_hint={3264, 3265, 0, 3731, 2462, 842, 0, 0, 1278, 27, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2424, 0, 0, 0, 
346, 3, 3191, 235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 0, 0, 285, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1165, 538, 0, 
372, 277, 3476, 0, 0, 0, 111, 0, 2081, 0, 112, 0, 0, 0, 0, 904, 1127, 0, 
0, 0, 113, 0, 0, 0, 0, 0, 0, 321, 0}
./hctx3/tags:wake_batch=8
./hctx3/tags:wake_index=7
./hctx3/tags:ws_active=0
./hctx3/tags:ws={
./hctx3/tags:   {.wait_cnt=8, .wait=inactive},
./hctx3/tags:   {.wait_cnt=8, .wait=inactive},
./hctx3/tags:   {.wait_cnt=8, .wait=inactive},
./hctx3/tags:   {.wait_cnt=8, .wait=inactive},
./hctx3/tags:   {.wait_cnt=8, .wait=inactive},
./hctx3/tags:   {.wait_cnt=8, .wait=inactive},
./hctx3/tags:   {.wait_cnt=8, .wait=inactive},
./hctx3/tags:   {.wait_cnt=8, .wait=inactive},
./hctx3/tags:}
./hctx3/tags:round_robin=1
./hctx3/tags:min_shallow_depth=4294967295
./hctx3/ctx_map:00000000: 00
./hctx3/flags:alloc_policy=RR SHOULD_MERGE|TAG_QUEUE_SHARED|3
./hctx2/cpu55/completed:0 0
./hctx2/cpu55/merged:0
./hctx2/cpu55/dispatched:0 0
./hctx2/cpu54/completed:0 0
./hctx2/cpu54/merged:0
./hctx2/cpu54/dispatched:0 0
./hctx2/cpu53/completed:0 0
./hctx2/cpu53/merged:0
./hctx2/cpu53/dispatched:0 0
./hctx2/cpu52/completed:0 0
./hctx2/cpu52/merged:0
./hctx2/cpu52/dispatched:0 0
./hctx2/cpu51/completed:0 0
./hctx2/cpu51/merged:0
./hctx2/cpu51/dispatched:0 0
./hctx2/cpu50/completed:0 0
./hctx2/cpu50/merged:0
./hctx2/cpu50/dispatched:0 0
./hctx2/cpu49/completed:0 0
./hctx2/cpu49/merged:0
./hctx2/cpu49/dispatched:0 0
./hctx2/cpu48/completed:0 0
./hctx2/cpu48/merged:0
./hctx2/cpu48/dispatched:0 0
./hctx2/type:default
./hctx2/dispatch_busy:0
./hctx2/active:0
./hctx2/run:0
./hctx2/queued:0
./hctx2/dispatched:       0     0
./hctx2/dispatched:       1     0
./hctx2/dispatched:       2     0
./hctx2/dispatched:       4     0
./hctx2/dispatched:       8     0
./hctx2/dispatched:      16     0
./hctx2/dispatched:      32+    0
./hctx2/io_poll:considered=0
./hctx2/io_poll:invoked=0
./hctx2/io_poll:success=0
./hctx2/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:00000020: 0000 0000 0000 0000 0100 0000 0000 0000
./hctx2/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:00000080: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:00000090: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:000000a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:000000b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:000000c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:000000d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:000000e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:000000f0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:00000100: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:00000110: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:00000120: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:00000130: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:00000140: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:00000150: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:00000160: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:00000170: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:00000180: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:00000190: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:000001a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:000001b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:000001c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:000001d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:000001e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx2/tags_bitmap:000001f0: 0000 0000
./hctx2/tags:nr_tags=4000
./hctx2/tags:nr_reserved_tags=0
./hctx2/tags:active_queues=0
./hctx2/tags:bitmap_tags:
./hctx2/tags:depth=4000
./hctx2/tags:busy=1
./hctx2/tags:cleared=3891
./hctx2/tags:bits_per_word=64
./hctx2/tags:map_nr=63
./hctx2/tags:alloc_hint={3264, 3265, 0, 3731, 2462, 842, 0, 0, 1278, 27, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2424, 0, 0, 0, 
346, 3, 3191, 235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 0, 0, 285, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1165, 538, 0, 
372, 277, 3476, 0, 0, 0, 111, 0, 2081, 0, 112, 0, 0, 0, 0, 904, 1127, 0, 
0, 0, 113, 0, 0, 0, 0, 0, 0, 321, 0}
./hctx2/tags:wake_batch=8
./hctx2/tags:wake_index=7
./hctx2/tags:ws_active=0
./hctx2/tags:ws={
./hctx2/tags:   {.wait_cnt=8, .wait=inactive},
./hctx2/tags:   {.wait_cnt=8, .wait=inactive},
./hctx2/tags:   {.wait_cnt=8, .wait=inactive},
./hctx2/tags:   {.wait_cnt=8, .wait=inactive},
./hctx2/tags:   {.wait_cnt=8, .wait=inactive},
./hctx2/tags:   {.wait_cnt=8, .wait=inactive},
./hctx2/tags:   {.wait_cnt=8, .wait=inactive},
./hctx2/tags:   {.wait_cnt=8, .wait=inactive},
./hctx2/tags:}
./hctx2/tags:round_robin=1
./hctx2/tags:min_shallow_depth=4294967295
./hctx2/ctx_map:00000000: 00
./hctx2/flags:alloc_policy=RR SHOULD_MERGE|TAG_QUEUE_SHARED|3
./hctx1/cpu47/completed:0 0
./hctx1/cpu47/merged:0
./hctx1/cpu47/dispatched:0 0
./hctx1/cpu46/completed:0 0
./hctx1/cpu46/merged:0
./hctx1/cpu46/dispatched:0 0
./hctx1/cpu45/completed:0 0
./hctx1/cpu45/merged:0
./hctx1/cpu45/dispatched:0 0
./hctx1/cpu44/completed:0 0
./hctx1/cpu44/merged:0
./hctx1/cpu44/dispatched:0 0
./hctx1/cpu43/completed:0 0
./hctx1/cpu43/merged:0
./hctx1/cpu43/dispatched:0 0
./hctx1/cpu42/completed:0 0
./hctx1/cpu42/merged:0
./hctx1/cpu42/dispatched:0 0
./hctx1/cpu41/completed:0 0
./hctx1/cpu41/merged:0
./hctx1/cpu41/dispatched:0 0
./hctx1/cpu40/completed:0 0
./hctx1/cpu40/merged:0
./hctx1/cpu40/dispatched:0 0
./hctx1/type:default
./hctx1/dispatch_busy:0
./hctx1/active:0
./hctx1/run:0
./hctx1/queued:0
./hctx1/dispatched:       0     0
./hctx1/dispatched:       1     0
./hctx1/dispatched:       2     0
./hctx1/dispatched:       4     0
./hctx1/dispatched:       8     0
./hctx1/dispatched:      16     0
./hctx1/dispatched:      32+    0
./hctx1/io_poll:considered=0
./hctx1/io_poll:invoked=0
./hctx1/io_poll:success=0
./hctx1/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:00000020: 0000 0000 0000 0000 0100 0000 0000 0000
./hctx1/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:00000080: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:00000090: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:000000a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:000000b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:000000c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:000000d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:000000e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:000000f0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:00000100: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:00000110: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:00000120: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:00000130: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:00000140: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:00000150: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:00000160: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:00000170: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:00000180: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:00000190: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:000001a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:000001b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:000001c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:000001d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:000001e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx1/tags_bitmap:000001f0: 0000 0000
./hctx1/tags:nr_tags=4000
./hctx1/tags:nr_reserved_tags=0
./hctx1/tags:active_queues=0
./hctx1/tags:bitmap_tags:
./hctx1/tags:depth=4000
./hctx1/tags:busy=1
./hctx1/tags:cleared=3891
./hctx1/tags:bits_per_word=64
./hctx1/tags:map_nr=63
./hctx1/tags:alloc_hint={3264, 3265, 0, 3731, 2462, 842, 0, 0, 1278, 27, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2424, 0, 0, 0, 
346, 3, 3191, 235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 0, 0, 285, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1165, 538, 0, 
372, 277, 3476, 0, 0, 0, 111, 0, 2081, 0, 112, 0, 0, 0, 0, 904, 1127, 0, 
0, 0, 113, 0, 0, 0, 0, 0, 0, 321, 0}
./hctx1/tags:wake_batch=8
./hctx1/tags:wake_index=7
./hctx1/tags:ws_active=0
./hctx1/tags:ws={
./hctx1/tags:   {.wait_cnt=8, .wait=inactive},
./hctx1/tags:   {.wait_cnt=8, .wait=inactive},
./hctx1/tags:   {.wait_cnt=8, .wait=inactive},
./hctx1/tags:   {.wait_cnt=8, .wait=inactive},
./hctx1/tags:   {.wait_cnt=8, .wait=inactive},
./hctx1/tags:   {.wait_cnt=8, .wait=inactive},
./hctx1/tags:   {.wait_cnt=8, .wait=inactive},
./hctx1/tags:   {.wait_cnt=8, .wait=inactive},
./hctx1/tags:}
./hctx1/tags:round_robin=1
./hctx1/tags:min_shallow_depth=4294967295
./hctx1/ctx_map:00000000: 00
./hctx1/flags:alloc_policy=RR SHOULD_MERGE|TAG_QUEUE_SHARED|3
./hctx0/cpu39/completed:0 0
./hctx0/cpu39/merged:0
./hctx0/cpu39/dispatched:0 0
./hctx0/cpu38/completed:0 0
./hctx0/cpu38/merged:0
./hctx0/cpu38/dispatched:0 0
./hctx0/cpu37/completed:0 0
./hctx0/cpu37/merged:0
./hctx0/cpu37/dispatched:0 0
./hctx0/cpu36/completed:0 0
./hctx0/cpu36/merged:0
./hctx0/cpu36/dispatched:0 0
./hctx0/cpu35/completed:0 0
./hctx0/cpu35/merged:0
./hctx0/cpu35/dispatched:0 0
./hctx0/cpu34/completed:0 0
./hctx0/cpu34/merged:0
./hctx0/cpu34/dispatched:0 0
./hctx0/cpu33/completed:0 0
./hctx0/cpu33/merged:0
./hctx0/cpu33/dispatched:0 0
./hctx0/cpu32/completed:0 0
./hctx0/cpu32/merged:0
./hctx0/cpu32/dispatched:0 0
./hctx0/type:default
./hctx0/dispatch_busy:0
./hctx0/active:0
./hctx0/run:0
./hctx0/queued:0
./hctx0/dispatched:       0     0
./hctx0/dispatched:       1     0
./hctx0/dispatched:       2     0
./hctx0/dispatched:       4     0
./hctx0/dispatched:       8     0
./hctx0/dispatched:      16     0
./hctx0/dispatched:      32+    0
./hctx0/io_poll:considered=0
./hctx0/io_poll:invoked=0
./hctx0/io_poll:success=0
./hctx0/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:00000020: 0000 0000 0000 0000 0100 0000 0000 0000
./hctx0/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:00000080: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:00000090: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:000000a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:000000b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:000000c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:000000d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:000000e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:000000f0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:00000100: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:00000110: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:00000120: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:00000130: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:00000140: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:00000150: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:00000160: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:00000170: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:00000180: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:00000190: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:000001a0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:000001b0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:000001c0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:000001d0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:000001e0: 0000 0000 0000 0000 0000 0000 0000 0000
./hctx0/tags_bitmap:000001f0: 0000 0000
./hctx0/tags:nr_tags=4000
./hctx0/tags:nr_reserved_tags=0
./hctx0/tags:active_queues=0
./hctx0/tags:bitmap_tags:
./hctx0/tags:depth=4000
./hctx0/tags:busy=1
./hctx0/tags:cleared=3891
./hctx0/tags:bits_per_word=64
./hctx0/tags:map_nr=63
./hctx0/tags:alloc_hint={3264, 3265, 0, 3731, 2462, 842, 0, 0, 1278, 27, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2424, 0, 0, 0, 
346, 3, 3191, 235, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 0, 0, 285, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1165, 538, 0, 
372, 277, 3476, 0, 0, 0, 111, 0, 2081, 0, 112, 0, 0, 0, 0, 904, 1127, 0, 
0, 0, 113, 0, 0, 0, 0, 0, 0, 321, 0}
./hctx0/tags:wake_batch=8
./hctx0/tags:wake_index=7
./hctx0/tags:ws_active=0
./hctx0/tags:ws={
./hctx0/tags:   {.wait_cnt=8, .wait=inactive},
./hctx0/tags:   {.wait_cnt=8, .wait=inactive},
./hctx0/tags:   {.wait_cnt=8, .wait=inactive},
./hctx0/tags:   {.wait_cnt=8, .wait=inactive},
./hctx0/tags:   {.wait_cnt=8, .wait=inactive},
./hctx0/tags:   {.wait_cnt=8, .wait=inactive},
./hctx0/tags:   {.wait_cnt=8, .wait=inactive},
./hctx0/tags:   {.wait_cnt=8, .wait=inactive},
./hctx0/tags:}
./hctx0/tags:round_robin=1
./hctx0/tags:min_shallow_depth=4294967295
./hctx0/ctx_map:00000000: 00
./hctx0/flags:alloc_policy=RR SHOULD_MERGE|TAG_QUEUE_SHARED|3
./write_hints:hint0: 0
./write_hints:hint1: 0
./write_hints:hint2: 0
./write_hints:hint3: 0
./write_hints:hint4: 0
./state:SAME_COMP|NONROT|IO_STAT|DISCARD|INIT_DONE|WC|REGISTERED|SCSI_PASSTHROUGH|29
./pm_only:0
./poll_stat:read  (512 Bytes): samples=0
./poll_stat:write (512 Bytes): samples=0
./poll_stat:read  (1024 Bytes): samples=0
./poll_stat:write (1024 Bytes): samples=0
./poll_stat:read  (2048 Bytes): samples=0
./poll_stat:write (2048 Bytes): samples=0
./poll_stat:read  (4096 Bytes): samples=0
./poll_stat:write (4096 Bytes): samples=0
./poll_stat:read  (8192 Bytes): samples=0
./poll_stat:write (8192 Bytes): samples=0
./poll_stat:read  (16384 Bytes): samples=0
./poll_stat:write (16384 Bytes): samples=0
./poll_stat:read  (32768 Bytes): samples=0
./poll_stat:write (32768 Bytes): samples=0
./poll_stat:read  (65536 Bytes): samples=0
./poll_stat:write (65536 Bytes): samples=0
estuary:/sys/kernel/debug/block/sdb$
estuary:/sys/kernel/debug/block/sdb$
estuary:/sys/kernel/debug/block/sdb$
estuary:/sys/kernel/debug/block/sdb$
estuary:/sys/kernel/debug/block/sdb$ cd /sys/block/sdb/device && find . 
-type f -exec grep -aH . {} \;
./uevent:DEVTYPE=scsi_device
./uevent:DRIVER=sd
./uevent:MODALIAS=scsi:t-0x00
./evt_media_change:0
./evt_mode_parameter_change_reported:0
./scsi_device/2:0:0:0/power/runtime_active_time:0
./scsi_device/2:0:0:0/power/runtime_status:unsupported
./scsi_device/2:0:0:0/power/runtime_suspended_time:0
./scsi_device/2:0:0:0/power/control:auto
./evt_inquiry_change_reported:0
./vendor:ATA
grep: ./delete: Permission denied
./evt_capacity_change_reported:0
./power/runtime_active_time:516011
./power/runtime_status:active
./power/autosuspend_delay_ms:-1
./power/runtime_suspended_time:0
./power/control:on
./model:SAMSUNG MZ7LH960
./evt_lun_change_reported:0
grep: ./rescan: Permission denied
./iorequest_cnt:0x22e1
./wwid:t10.ATA     SAMSUNG MZ7LH960HAJR-00005 S45NNA0M712225
./iocounterbits:32
./type:0
./queue_type:simple
./device_busy:0
./vpd_pg80:▒
./vpd_pg80:S45NNA0M712225
./device_blocked:0
./scsi_disk/2:0:0:0/max_write_same_blocks:0
./scsi_disk/2:0:0:0/cache_type:write back
./scsi_disk/2:0:0:0/zeroing_mode:write
./scsi_disk/2:0:0:0/allow_restart:1
./scsi_disk/2:0:0:0/provisioning_mode:writesame_16
./scsi_disk/2:0:0:0/power/runtime_active_time:0
./scsi_disk/2:0:0:0/power/runtime_status:unsupported
./scsi_disk/2:0:0:0/power/runtime_suspended_time:0
./scsi_disk/2:0:0:0/power/control:auto
./scsi_disk/2:0:0:0/zoned_cap:none
./scsi_disk/2:0:0:0/thin_provisioning:1
./scsi_disk/2:0:0:0/max_retries:5
./scsi_disk/2:0:0:0/app_tag_own:0
./scsi_disk/2:0:0:0/manage_start_stop:1
./scsi_disk/2:0:0:0/FUA:0
./scsi_disk/2:0:0:0/protection_mode:none
./scsi_disk/2:0:0:0/max_medium_access_timeouts:2
./scsi_disk/2:0:0:0/protection_type:0
./vpd_pg89:▒8
./vpd_pg89:linux   libata          3.004▒@
./vpd_pg89:
./vpd_pg89:
./vpd_pg89:▒
./vpd_pg89:@
./vpd_pg89:▒?7▒
./vpd_pg89:?
./vpd_pg89:4SN5ANM0172252
./vpd_pg89:XH7T04Q4ASSMNU GZML79H06AHRJ0-0050              ▒
./vpd_pg89:@
./vpd_pg89:/
./vpd_pg89:@
./vpd_pg89:
./vpd_pg89:
./vpd_pg89:▒?
./vpd_pg89:?
./vpd_pg89:▒▒
./vpd_pg89:▒▒▒▒
./vpd_pg89:
./vpd_pg89:
./vpd_pg89:x
./vpd_pg89:x
./vpd_pg89:x
./vpd_pg89:x
./vpd_pg89:0O
./vpd_pg89:
./vpd_pg89:▒f
./vpd_pg89:d`
./vpd_pg89:▒^
./vpd_pg89:kt}cAit▒c@
./vpd_pg89:
./vpd_pg89:▒▒
./vpd_pg89:▒▒o
./vpd_pg89:
./vpd_pg89:`
./vpd_pg89:P▒Sv 3▒
./vpd_pg89:@@
./vpd_pg89:!
./vpd_pg89:
./vpd_pg89:
./vpd_pg89:
./vpd_pg89:=
./vpd_pg89:@
./vpd_pg89:
./vpd_pg89:▒
./vpd_pg89:
./vpd_pg89:@
./vpd_pg89:▒▒
./scsi_level:6
./vpd_pg0:
./vpd_pg0:▒▒▒▒▒▒
./inquiry:[
./inquiry:ATA     SAMSUNG MZ7LH960404Q
./inquiry:`
./eh_timeout:10
./state:running
xterm./block/sdb/uevent:MAJOR=8
./block/sdb/uevent:MINOR=16
./block/sdb/uevent:DEVNAME=sdb
./block/sdb/uevent:DEVTYPE=disk
./block/sdb/ext_range:256
./block/sdb/range:16
./block/sdb/alignment_offset:0
./block/sdb/power/runtime_active_time:0
./block/sdb/power/runtime_status:unsupported
./block/sdb/power/runtime_suspended_time:0
./block/sdb/power/control:auto
./block/sdb/dev:8:16
./block/sdb/ro:0
./block/sdb/mq/7/cpu_list:88, 89, 90, 91, 92, 93, 94, 95
./block/sdb/mq/7/nr_reserved_tags:0
./block/sdb/mq/7/nr_tags:4000
./block/sdb/mq/15/cpu_list:24, 25, 26, 27, 28, 29, 30, 31
./block/sdb/mq/15/nr_reserved_tags:0
./block/sdb/mq/15/nr_tags:4000
./block/sdb/mq/5/cpu_list:72, 73, 74, 75, 76, 77, 78, 79
./block/sdb/mq/5/nr_reserved_tags:0
./block/sdb/mq/5/nr_tags:4000
./block/sdb/mq/13/cpu_list:8, 9, 10, 11, 12, 13, 14, 15
./block/sdb/mq/13/nr_reserved_tags:0
./block/sdb/mq/13/nr_tags:4000
./block/sdb/mq/3/cpu_list:56, 57, 58, 59, 60, 61, 62, 63
./block/sdb/mq/3/nr_reserved_tags:0
./block/sdb/mq/3/nr_tags:4000
./block/sdb/mq/11/cpu_list:120, 121, 122, 123, 124, 125, 126, 127
./block/sdb/mq/11/nr_reserved_tags:0
./block/sdb/mq/11/nr_tags:4000
./block/sdb/mq/1/cpu_list:40, 41, 42, 43, 44, 45, 46, 47
./block/sdb/mq/1/nr_reserved_tags:0
./block/sdb/mq/1/nr_tags:4000
./block/sdb/mq/8/cpu_list:96, 97, 98, 99, 100, 101, 102, 103
./block/sdb/mq/8/nr_reserved_tags:0
./block/sdb/mq/8/nr_tags:4000
./block/sdb/mq/6/cpu_list:80, 81, 82, 83, 84, 85, 86, 87
./block/sdb/mq/6/nr_reserved_tags:0
./block/sdb/mq/6/nr_tags:4000
./block/sdb/mq/14/cpu_list:16, 17, 18, 19, 20, 21, 22, 23
./block/sdb/mq/14/nr_reserved_tags:0
./block/sdb/mq/14/nr_tags:4000
./block/sdb/mq/4/cpu_list:64, 65, 66, 67, 68, 69, 70, 71
./block/sdb/mq/4/nr_reserved_tags:0
./block/sdb/mq/4/nr_tags:4000
./block/sdb/mq/12/cpu_list:0, 1, 2, 3, 4, 5, 6, 7
./block/sdb/mq/12/nr_reserved_tags:0
./block/sdb/mq/12/nr_tags:4000
./block/sdb/mq/2/cpu_list:48, 49, 50, 51, 52, 53, 54, 55
./block/sdb/mq/2/nr_reserved_tags:0
./block/sdb/mq/2/nr_tags:4000
./block/sdb/mq/10/cpu_list:112, 113, 114, 115, 116, 117, 118, 119
./block/sdb/mq/10/nr_reserved_tags:0
./block/sdb/mq/10/nr_tags:4000
./block/sdb/mq/0/cpu_list:32, 33, 34, 35, 36, 37, 38, 39
./block/sdb/mq/0/nr_reserved_tags:0
./block/sdb/mq/0/nr_tags:4000
./block/sdb/mq/9/cpu_list:104, 105, 106, 107, 108, 109, 110, 111
./block/sdb/mq/9/nr_reserved_tags:0
./block/sdb/mq/9/nr_tags:4000
./block/sdb/stat:     147       15     1228       37     6118 73  
9970344 12870227        0    11584 12870264        0 0        0        
0        5        0
./block/sdb/events_poll_msecs:-1
./block/sdb/queue/io_poll_delay:-1
./block/sdb/queue/max_integrity_segments:0
./block/sdb/queue/zoned:none
./block/sdb/queue/scheduler:[none] mq-deadline kyber
./block/sdb/queue/io_poll:0
./block/sdb/queue/discard_zeroes_data:0
./block/sdb/queue/minimum_io_size:4096
./block/sdb/queue/nr_zones:0
./block/sdb/queue/write_same_max_bytes:0
./block/sdb/queue/max_segments:124
./block/sdb/queue/dax:0
./block/sdb/queue/physical_block_size:4096
./block/sdb/queue/logical_block_size:512
./block/sdb/queue/zone_append_max_bytes:0
./block/sdb/queue/io_timeout:30000
./block/sdb/queue/nr_requests:4000
./block/sdb/queue/write_cache:write back
./block/sdb/queue/stable_writes:0
./block/sdb/queue/max_segment_size:65536
./block/sdb/queue/rotational:0
./block/sdb/queue/discard_max_bytes:2147450880
./block/sdb/queue/add_random:0
./block/sdb/queue/discard_max_hw_bytes:2147450880
./block/sdb/queue/optimal_io_size:0
./block/sdb/queue/chunk_sectors:0
./block/sdb/queue/read_ahead_kb:128
./block/sdb/queue/max_discard_segments:1
./block/sdb/queue/write_zeroes_max_bytes:0
./block/sdb/queue/nomerges:0
./block/sdb/queue/fua:0
./block/sdb/queue/discard_granularity:4096
./block/sdb/queue/rq_affinity:1
./block/sdb/queue/max_sectors_kb:1280
./block/sdb/queue/hw_sector_size:512
./block/sdb/queue/max_hw_sectors_kb:32767
./block/sdb/queue/iostats:1
./block/sdb/size:1875385008
./block/sdb/integrity/write_generate:0
./block/sdb/integrity/format:none
./block/sdb/integrity/read_verify:0
./block/sdb/integrity/tag_size:0
./block/sdb/integrity/protection_interval_bytes:0
./block/sdb/integrity/device_is_integrity_capable:0
./block/sdb/sdb1/uevent:MAJOR=8
./block/sdb/sdb1/uevent:MINOR=17
./block/sdb/sdb1/uevent:DEVNAME=sdb1
./block/sdb/sdb1/uevent:DEVTYPE=partition
./block/sdb/sdb1/uevent:PARTN=1
./block/sdb/sdb1/alignment_offset:0
./block/sdb/sdb1/power/runtime_active_time:0
./block/sdb/sdb1/power/runtime_status:unsupported
./block/sdb/sdb1/power/runtime_suspended_time:0
./block/sdb/sdb1/power/control:auto
./block/sdb/sdb1/dev:8:17
./block/sdb/sdb1/ro:0
./block/sdb/sdb1/stat:     138       15     1212       35 6116       73  
9970344 12870227        0    11576 12870262 0        0        0        
0        0        0
./block/sdb/sdb1/size:209715200
./block/sdb/sdb1/discard_alignment:0
./block/sdb/sdb1/partition:1
./block/sdb/sdb1/inflight:       0        0
./block/sdb/sdb1/start:2048
./block/sdb/discard_alignment:0
./block/sdb/capability:50
./block/sdb/hidden:0
./block/sdb/removable:0
./block/sdb/inflight:       0        0
./iodone_cnt:0x18a0
./queue_ramp_up_period:120000
./queue_depth:32
./bsg/2:0:0:0/uevent:MAJOR=245
./bsg/2:0:0:0/uevent:MINOR=4
./bsg/2:0:0:0/uevent:DEVNAME=bsg/2:0:0:0
./bsg/2:0:0:0/power/runtime_active_time:0
./bsg/2:0:0:0/power/runtime_status:unsupported
./bsg/2:0:0:0/power/runtime_suspended_time:0
./bsg/2:0:0:0/power/control:auto
./bsg/2:0:0:0/dev:245:4
./ioerr_cnt:0x0
./vpd_pg83:▒
./vpd_pg83:l
./vpd_pg83:S45NNA0M712225
./vpd_pg83:DATA     SAMSUNG MZ7LH960HAJR-00005 S45NNA0M712225
./vpd_pg83PS▒   v▒3
./timeout:30
./evt_soft_threshold_reached:0
./rev:404Q
./modalias:scsi:t-0x00
estuary:/sys/devices/pci0000:b4/0000:b4:02.0/host2/port-2:0/end_device-2:0/target2:0:0/2:0:0:0$

