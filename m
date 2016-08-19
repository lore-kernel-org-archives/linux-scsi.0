From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: Re: Oops when completing request on the wrong queue
Date: Fri, 19 Aug 2016 13:38:17 -0300
Message-ID: <87shu0hfye.fsf@linux.vnet.ibm.com>
References: <87a8gltgks.fsf@linux.vnet.ibm.com>
        <871t1kq455.fsf@linux.vnet.ibm.com>
        <bb6f8757-4c3d-8f49-8aff-aa0fdb8bae89@kernel.dk>
        <8fc9ae38-9488-ef52-f620-08499edebffa@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24222 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755013AbcHSQiY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Aug 2016 12:38:24 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7JGY9L8132610
        for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2016 12:38:23 -0400
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
        by mx0b-001b2d01.pphosted.com with ESMTP id 24wyt130e7-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2016 12:38:23 -0400
Received: from localhost
        by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
        Fri, 19 Aug 2016 13:38:21 -0300
In-Reply-To: <8fc9ae38-9488-ef52-f620-08499edebffa@kernel.dk> (Jens Axboe's
        message of "Fri, 19 Aug 2016 09:51:21 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org, Brian King <brking@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

>> Some good detective work so far! I agree, this looks like a blk-mq core
>> bug. Do you have a trace of a BUG() triggering in nvme_queue_rq(), when
>> req->tag != nvmeq->tags? I don't immediately see how this could happen,
>> the freezing should protect us from this, unless it's broken somehow.
>> I'll take a look at this.

Nothing much on the BUG() stack trace, at least to me.  We are coming
from an async execution of __blk_mq_run_hw_queue:

This is from 4.7. I'll give another run on 4.8-rc1.

[ 1953.910860] kernel BUG at ../drivers/nvme/host/pci.c:602!
cpu 0x48: Vector: 700 (Program Check) at [c000007870d3b7a0]
    pc: d000000035aa2e88: nvme_queue_rq+0x1a8/0x7a0 [nvme]
    lr: d000000035aa2e78: nvme_queue_rq+0x198/0x7a0 [nvme]
    sp: c000007870d3ba20
   msr: 900000010282b033
  current = 0xc000007870d9e400
  paca    = 0xc000000002bd8800   softe: 0        irq_happened: 0x01
    pid   = 9205, comm = kworker/72:1H
kernel BUG at ../drivers/nvme/host/pci.c:602!
Linux version 4.7.0.mainline+ (root@iod76) (gcc version 5.3.1 20160413 (Ubuntu/IBM 5.3.1-14ubuntu2.
1) ) #150 SMP Wed Aug 17 14:53:47 CDT 2016
enter ? for help
[c000007870d3bb10] c0000000005697b4 __blk_mq_run_hw_queue+0x384/0x640
[c000007870d3bc50] c0000000000e8cf0 process_one_work+0x1e0/0x590
[c000007870d3bce0] c0000000000e9148 worker_thread+0xa8/0x660
[c000007870d3bd80] c0000000000f2090 kthread+0x110/0x130
[c000007870d3be30] c0000000000095f0 ret_from_kernel_thread+0x5c/0x6c
48:mon>


Another interesting data point is that we always reach the WARN_ON in
__blk_mq_run_hw_queue immediately before submitting the bad request.

Maybe we are touching some percpu variable from the wrong cpu?

See the WARN_ON trace below.


[  369.953825] ------------[ cut here ]------------
[  369.954011] WARNING: CPU: 142 PID: 9475 at ../block/blk-mq.c:840 __blk_mq_run_hw_queue+0x338/0x6
40
[  369.954139] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs lockd grace fscache binfmt_
misc xfs ofpart cmdlinepart powernv_flash mtd ipmi_powernv ipmi_msghandler at24 opal_prd ibmpowernv
 nvmem_core powernv_rng input_leds joydev uio_pdrv_genirq mac_hid uio ib_iser rdma_cm sunrpc iw_cm
ib_cm ib_core configfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi autofs4 btrfs raid10 ra
id456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0
 multipath linear ast i2c_algo_bit ttm drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops
 drm hid_generic uas usb_storage usbhid hid nvme ahci libahci nvme_core drbg ansi_cprng
[  369.955011] CPU: 142 PID: 9475 Comm: kworker/142:1H Not tainted 4.7.0.mainline+ #150
[  369.955085] Workqueue: kblockd blk_mq_run_work_fn
[  369.955153] task: c0000078cbb89a00 ti: c0000078cb024000 task.ti: c0000078cb024000
[  369.955253] NIP: c000000000569768 LR: c000000000569668 CTR: 0000000000000000
[  369.955314] REGS: c0000078cb027890 TRAP: 0700   Not tainted  (4.7.0.mainline+)
[  369.955372] MSR: 900000010282b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE,TM[E]>  CR: 28002224  XER:
 20000000
[  369.955579] CFAR: c000000000569a18 SOFTE: 1
GPR00: c0000000005695b0 c0000078cb027b10 c0000000013d0b00 0000000000000008
GPR04: 0000000000000008 0000000000000040 0000000000000000 0000000000000001
GPR08: c0000078c345d800 0000000000000001 0000000001700000 9000000102803003
GPR12: 0000000000002200 c000000002bffe00 c0000078bb96b000 0000000000000000
GPR16: 0000000000000008 c0000078bb930000 c000007954aafd00 c0000078bb961800
GPR20: c000007954aafd08 c000000000da3728 c0000078bea80000 c0000078cb027b88
GPR24: 0000000000000000 c0000078bea80000 c0000078bb961808 fffffffffffffffb
GPR28: 0000000000000000 c0000078cb027b98 0000000000000000 c0000078bd299700
[  369.956334] NIP [c000000000569768] __blk_mq_run_hw_queue+0x338/0x640
[  369.956383] LR [c000000000569668] __blk_mq_run_hw_queue+0x238/0x640
[  369.956433] Call Trace:
[  369.956454] [c0000078cb027b10] [c0000000005695b0] __blk_mq_run_hw_queue+0x180/0x640 (unreliable)
[  369.956535] [c0000078cb027c50] [c0000000000e8cf0] process_one_work+0x1e0/0x590
[  369.956605] [c0000078cb027ce0] [c0000000000e9148] worker_thread+0xa8/0x660
[  369.956664] [c0000078cb027d80] [c0000000000f2090] kthread+0x110/0x130
[  369.956723] [c0000078cb027e30] [c0000000000095f0] ret_from_kernel_thread+0x5c/0x6c
[  369.956791] Instruction dump:
[  369.956821] 815f0108 e91302d8 81280000 7f895040 409d01e8 e9280060 794a1f24 7d29502a
[  369.956920] 7d2afa78 312affff 7d295110 7d2907b4 <0b090000> e9210088 e95f0058 38810060
[  369.957020] ---[ end trace 1398dd60e3057065 ]---
[  369.957094] ------------[ cut here ]------------


> Can you share what you ran to online/offline CPUs? I can't reproduce
> this here.

I was using the ppc64_cpu tool, which shouldn't do nothing more than
write to sysfs.  but I just reproduced it with the script below.

Note that this is ppc64le.  I don't have a x86 in hand to attempt to
reproduce right now, but I'll look for one and see how it goes.


#!/bin/bash

MAXCPUs=159
STATE=1

while true; do
    for i in $(seq 1 ${MAXCPUS}); do
        if (($i%8)); then
            echo $STATE > /sys/devices/system/cpu/cpu$i/online
        fi
    done
    if [[ $STATE -eq 1 ]]; then
        STATE=0
    else
        STATE=1
    fi
done

-- 
Gabriel Krisman Bertazi

