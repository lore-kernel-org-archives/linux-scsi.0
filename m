Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C6BC64E90
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 11:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D0F02085B
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 11:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgK3LXm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 06:23:42 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2174 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgK3LXm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 06:23:42 -0500
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Cl2q74qSGz67KHm;
        Mon, 30 Nov 2020 19:21:07 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 30 Nov 2020 12:23:00 +0100
Received: from [10.47.3.199] (10.47.3.199) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1913.5; Mon, 30 Nov
 2020 11:22:58 +0000
From:   John Garry <john.garry@huawei.com>
Subject: [bug report] Hang on sync after dd
To:     Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>,
        "Sumit Saxena" <sumit.saxena@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Bart Van Assche" <bvanassche@acm.org>
CC:     chenxiang <chenxiang66@hisilicon.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Ewan Milne <emilne@redhat.com>, Long Li <longli@microsoft.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Message-ID: <2847d0e1-ccb1-7be6-2456-274e41ea981b@huawei.com>
Date:   Mon, 30 Nov 2020 11:22:33 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.3.199]
X-ClientProxiedBy: lhreml704-chm.china.huawei.com (10.201.108.53) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

Some guys internally upgraded to v5.10-rcX and start to see a hang after 
dd + sync for a large file:
- mount /dev/sda1 (ext4 filesystem) to directory /mnt;
- run "if=/dev/zero of=test1 bs=1M count=2000" on directory /mnt;
- run "sync"

and get:

[  367.912761] INFO: task jbd2/sdb1-8:3602 blocked for more than 120
seconds.
[  367.919618]       Not tainted 5.10.0-rc1-109488-g32ded76956b6 #948
[  367.925776] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  367.933579] task:jbd2/sdb1-8     state:D stack:    0 pid: 3602
ppid:     2 flags:0x00000028
[  367.941901] Call trace:
[  367.944351] __switch_to+0xb8/0x168
[  367.947840] __schedule+0x30c/0x670
[  367.951326] schedule+0x70/0x108
[  367.954550] io_schedule+0x1c/0xe8
[  367.957948] bit_wait_io+0x18/0x68
[  367.961346] __wait_on_bit+0x78/0xf0
[  367.964919] out_of_line_wait_on_bit+0x8c/0xb0
[  367.969356] __wait_on_buffer+0x30/0x40
[  367.973188] jbd2_journal_commit_transaction+0x1370/0x1958
[  367.978661] kjournald2+0xcc/0x260
[  367.982061] kthread+0x150/0x158
[  367.985288] ret_from_fork+0x10/0x34
[  367.988860] INFO: task sync:3823 blocked for more than 120 seconds.
[  367.995102]       Not tainted 5.10.0-rc1-109488-g32ded76956b6 #948
[  368.001265] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  368.009067] task:sync            state:D stack:    0 pid: 3823 ppid:
3450 flags:0x00000009
[  368.017397] Call trace:
[  368.019841] __switch_to+0xb8/0x168
[  368.023320] __schedule+0x30c/0x670
[  368.026804] schedule+0x70/0x108
[  368.030025] jbd2_log_wait_commit+0xbc/0x158
[  368.034290] ext4_sync_fs+0x188/0x1c8
[  368.037947] sync_fs_one_sb+0x30/0x40
[  368.041606] iterate_supers+0x9c/0x138
[  368.045350] ksys_sync+0x64/0xc0
[  368.048569] __arm64_sys_sync+0x10/0x20
[  368.052398] el0_svc_common.constprop.3+0x68/0x170
[  368.057177] do_el0_svc+0x24/0x90
[  368.060482] el0_sync_handler+0x118/0x168
[  368.064478]  el0_sync+0x158/0x180

The issue was reported here originally:
https://lore.kernel.org/linux-ext4/4d18326e-9ca2-d0cb-7cb8-cb56981280da@hisilicon.com/

But it looks like issue related to recent work for SCSI MQ.

They can only create with hisi_sas v3 hw. I could not create with 
megaraid sas on the same dev platform or hisi_sas on a similar dev board.

Reverting "scsi: core: Only re-run queue in scsi_end_request() if device 
queue is busy" seems solve the issue. Also, checking out to patch prior 
to "scsi: hisi_sas: Switch v3 hw to MQ" seems to not have the issue.

It occurs on SATA disks only, rather than SAS disks also, it seems. 
Maybe related to IO depth being smaller on SATA disk (32 vs 64), which 
can cause budget fail.

"mq-deadline" and "none" schedulers look to have the issue.

@Kashyap, have you guys tested megaraid sas much for this?

Thanks,
John


Block debugfs info is as follows:

estuary:/sys/kernel/debug/block/sda/hctx8$ cat
active cpu101/ cpu96/ cpu99/ dispatch_busy io_poll sched_tags tags
busy cpu102/ cpu97/ ctx_map dispatched queued sched_tags_bitmap tags_bitmap
cpu100/ cpu103/ cpu98/ dispatch flags run state type
estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu
cpu100/ cpu101/ cpu102/ cpu103/ cpu96/ cpu97/ cpu98/ cpu99/
estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu
cpu100/ cpu101/ cpu102/ cpu103/ cpu96/ cpu97/ cpu98/ cpu99/
estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu96/
completed default_rq_list dispatched merged poll_rq_list read_rq_list
estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu96/dispatched
0 0
estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu97/dispatched
0 0
estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu98/dispatched
0 0
estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu99/dispatched
0 0
estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu100/dispatched
3 0
estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu100/completed
2 0
estuary:/sys/kernel/debug/block/sda/hctx8$
estuary:/sys/kernel/debug/block/sda/hctx8$
estuary:/sys/kernel/debug/block/sda/hctx8$ cat state
SCHED_RESTART
estuary:/sys/kernel/debug/block/sda/hctx8$ ls
active cpu101 cpu96 cpu99 dispatch_busy io_poll sched_tags tags
busy cpu102 cpu97 ctx_map dispatched queued sched_tags_bitmap tags_bitmap
cpu100 cpu103 cpu98 dispatch flags run state type
estuary:/sys/kernel/debug/block/sda/hctx8$ cat dispatch
000000007abb596e {.op=FLUSH, .cmd_flags=PREFLUSH, 
.rq_flags=FLUSH_SEQ|MQ_INFLIGHT|DONTPREP, .state=idle, .tag=21, 
.internal_tag=-1, .cmd=opcode=0x35 35 00 00 00 00 00 00 00 00 00, 
.retries=0, .result = 0x0, .flags=TAGGED|INITIALIZED|3, .timeout=60.000, 
allocated 2208.876 s ago}
estuary:/sys/kernel/debug/block/sda/hctx8$


On cpu100, it seems completed is less than number dispatched.

