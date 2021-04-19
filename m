Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAD4C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 15:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66354611CE
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 15:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240771AbhDSPOg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 11:14:36 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2879 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240740AbhDSPOf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 11:14:35 -0400
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FP9F30l4vz70gcf;
        Mon, 19 Apr 2021 23:08:39 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 19 Apr 2021 17:14:03 +0200
Received: from [10.47.84.228] (10.47.84.228) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 19 Apr
 2021 16:14:02 +0100
Subject: Re: [bug report] scsi host hang when running fio
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>, <linux-scsi@vger.kernel.org>,
        <linux-block@vger.kernel.org>, Hannes Reinecke <hare@suse.com>
CC:     chenxiang <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>
References: <0dda71da-4119-2e40-b8e9-ab2b3ee8e96a@huawei.com>
 <f934ca65fa55345c360c944dd0fc2239@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <2bd9adf9-7766-687a-2510-eb6a058f00d8@huawei.com>
Date:   Mon, 19 Apr 2021 16:11:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <f934ca65fa55345c360c944dd0fc2239@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.84.228]
X-ClientProxiedBy: lhreml733-chm.china.huawei.com (10.201.108.84) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Kashyap,

> John - I have not seen such issue on megaraid_sas driver.

I could try to test megaraid SAS also, but the system with that card has 
only 1x SATA disk, so pointless really.

> Is this something
> to do with CPU lock up ?

Seems to be.

JFYI, Enabling configs RCU_EXPERT, DEBUG_ATOMIC_SLEEP, and 
DEBUG_SPINLOCK gives:

job1: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 
4096B-4096B, ioengine=libaio, iodepth=128
job1: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 
4096B-4096B, ioengine=libaio, iodepth=128
job1: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 
4096B-4096B, ioengine=libaio, iodepth=128
fio-3.1
Starting 6 processes
[  196.342724] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:ta 
01h:12m:22s]
[  196.348816] rcu:     Tasks blocked on level-1 rcu_node (CPUs 32-47):
[  196.354913] rcu: All QSes seen, last rcu_preempt kthread activity 1 
(4294941135-4294941134), jiffies_till_next_fqs=1, root ->qsmask 0x4
[  196.367089] BUG: sleeping function called from invalid context at 
include/linux/uaccess.h:174
[  196.375605] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 
1893, name: fio
[  196.383502] BUG: scheduling while atomic: fio/1893/0x00000004
[  196.389312] BUG: spinlock recursion on CPU#11, fio/1893
[  196.394527]  lock: rcu_state+0x280/0x2d00, .magic: dead4ead, .owner: 
fio/1893, .owner_cpu: 11
[  196.403046] CPU: 11 PID: 1893 Comm: fio Tainted: G W 
5.12.0-rc7-00001-g3ae18ff9e445 #219
[  196.412426] Hardware name: Huawei Taishan 2280 /D05, BIOS Hisilicon 
D05 IT21 Nemo 2.0 RC0 04/18/2018
[  196.421544] Call trace:
[  196.423977]  dump_backtrace+0x0/0x1b0
[  196.427629]  show_stack+0x18/0x68
[  196.430932]  dump_stack+0xd8/0x134
[  196.434322]  spin_dump+0x84/0x94
[  196.437539]  do_raw_spin_lock+0x108/0x120
[  196.441539]  _raw_spin_lock+0x20/0x30
[  196.445191]  rcu_note_context_switch+0xbc/0x348
[  196.449710]  __schedule+0xc8/0x6e8
[  196.453100]  preempt_schedule_notrace+0x50/0x70
[  196.457618]  __arm64_sys_io_submit+0x188/0x240
[  196.462051]  el0_svc_common.constprop.2+0x8c/0x128
[  196.466829]  do_el0_svc+0x24/0x90
[  196.470133]  el0_svc+0x24/0x38
[  196.473175]  el0_sync_handler+0x90/0xb8
[  196.476999]  el0_sync+0x154/0x180
^Cbs: 6 (f=6): [r(6)][4.2%][r=0KiB/s,w=0KiB/s][r=0,w=0 IOPS][eta 
01h:11m:54s]
fio: terminating on signal 2

> Can you try your test with "rq_affinity=2" ? 

I cannot see the issue with this setting.

> megaraid_sas driver detect CPU
> lockup (flood of completion on single CPU) and it use irq_poll interface to
> avoid such loop.

Can you turn it off? I guess that this is what happens to me, but the 
system should not hang.

> Since you mentioned you noticed issue with hisi_sas v2 without hostwide tag
> I can think of similar stuffs in this case.
> 
> How cpus to irq affinity settled in your case. ? Is it 1-1 mapping ?

We have a 4-1 CPU-HW queue mapping.

Disabling CONFIG_PREEMPT makes the issue go away for me also, so it 
would be useful to try enabling it to recreate (if disabled), like:

  more .config| grep PREEMPT
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_PREEMPTION=y
CONFIG_PREEMPT_RCU=y
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_DEBUG_PREEMPT is not set

Thanks,
John

> 
> Kashyap
> 
>>
>> scsi debug or null_blk don't seem to load the system heavily enough to
>> recreate.
>>
>> I have seen it on 5.11 also. I see it on hisi_sas v2 and v3 hw drivers,
>> And I don't
>> think it's related to hostwide tags, as for hisi_sas v2 hw driver, I unset
>> that flag
>> and can still see it.
>>
>> Thanks,
>> John
>>
>> [0]
>> https://lore.kernel.org/linux-scsi/89ebc37c-21d6-c57e-4267-
>> cac49a3e5953@huawei.com/T/#t

