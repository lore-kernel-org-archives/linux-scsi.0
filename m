From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195285] qla2xxx FW immediatly crashing after target start
Date: Mon, 10 Apr 2017 19:27:01 +0000
Message-ID: <bug-195285-11613-4MoiRXXZUV@https.bugzilla.kernel.org/>
References: <bug-195285-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55766 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752580AbdDJT1D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Apr 2017 15:27:03 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 60FA425EF7
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 19:27:02 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BF98125EF7
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 19:27:01 +0000 (UTC)
In-Reply-To: <bug-195285-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=195285

himanshu.madhani@cavium.com (himanshu.madhani@qlogic.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |himanshu.madhani@qlogic.com

--- Comment #1 from himanshu.madhani@cavium.com (himanshu.madhani@qlogic.com) ---
Hi Anthony, 

(In reply to Anthony from comment #0)
> System always become unresposive after target start with messages
> 
> qla2xxx [0000:07:00.0]-00fb:1: QLogic QLE2564 - PCI-Express Quad Channel 8Gb
> Fibre Channel HBA.
> qla2xxx [0000:07:00.0]-00fc:1: ISP2532: PCIe (5.0GT/s x8) @ 0000:07:00.0
> hdma+ host#=1 fw=8.06.00 (90d5).
> qla2xxx [0000:07:00.1]-001a: : MSI-X vector count: 32.
> qla2xxx [0000:07:00.1]-001d: : Found an ISP2532 irq 103 iobase
> 0xffffb830c62d5000.
> qla2xxx [0000:07:00.1]-504b:2: RISC paused -- HCCR=40, Dumping firmware.
> qla2xxx [0000:07:00.1]-8033:2: Unable to reinitialize FCE (258).
> qla2xxx [0000:07:00.1]-8034:2: Unable to reinitialize EFT (258).
> qla2xxx [0000:07:00.1]-00af:2: Performing ISP error recovery -
> ha=ffff88a2624e0000.
> qla2xxx [0000:07:00.1]-504b:2: RISC paused -- HCCR=40, Dumping firmware.
> 
> trying - kernel 4.11-rc5
> 
> Apr 07 23:39:58 : ------------[ cut here ]------------
> Apr 07 23:39:58 : WARNING: CPU: 0 PID: 1468 at lib/dma-debug.c:519
> add_dma_entry+0x176/0x180
> Apr 07 23:39:58 : DMA-API: exceeded 7 overlapping mappings of cacheline
> 0x0000000013e77000
> Apr 07 23:39:58 : Modules linked in: vhost_net vhost tap tun ebtable_filter
> ebtables ip6table_filter ip6_tables tcm_qla2xxx target_core_user uio targ
> Apr 07 23:39:58 :  nvme_core scsi_transport_sas
> Apr 07 23:39:58 : CPU: 0 PID: 1468 Comm: qemu-system-x86 Tainted: G        W
> I     4.11.0-0.rc5.git3.1.fc27.x86_64 #1
> Apr 07 23:39:58 : Hardware name: HP ProLiant DL180 G6  , BIOS O20 07/01/2013
> Apr 07 23:39:58 : Call Trace:
> Apr 07 23:39:58 :  dump_stack+0x8e/0xd1
> Apr 07 23:39:58 :  __warn+0xcb/0xf0
> Apr 07 23:39:58 :  warn_slowpath_fmt+0x5a/0x80
> Apr 07 23:39:58 :  ? active_cacheline_read_overlap+0x2e/0x60
> Apr 07 23:39:58 :  add_dma_entry+0x176/0x180
> Apr 07 23:39:58 :  debug_dma_map_sg+0x11a/0x170
> Apr 07 23:39:58 :  nvme_queue_rq+0x513/0x950 [nvme]
> Apr 07 23:39:58 :  blk_mq_try_issue_directly+0xbb/0x110
> Apr 07 23:39:58 :  blk_mq_make_request+0x3a9/0xa70
> Apr 07 23:39:58 :  ? blk_queue_enter+0xa3/0x2c0
> Apr 07 23:39:58 :  ? blk_queue_enter+0x39/0x2c0
> Apr 07 23:39:58 :  ? generic_make_request+0xf9/0x3b0
> Apr 07 23:39:58 :  generic_make_request+0x126/0x3b0
> Apr 07 23:39:58 :  ? iov_iter_get_pages+0xc9/0x330
> Apr 07 23:39:58 :  submit_bio+0x73/0x150
> Apr 07 23:39:58 :  ? submit_bio+0x73/0x150
> Apr 07 23:39:58 :  ? bio_iov_iter_get_pages+0xe0/0x120
> Apr 07 23:39:58 :  blkdev_direct_IO+0x1f7/0x3e0
> Apr 07 23:39:58 :  ? SYSC_io_destroy+0x1d0/0x1d0
> Apr 07 23:39:58 :  ? __atime_needs_update+0x7f/0x1a0
> Apr 07 23:39:58 :  generic_file_read_iter+0x2e5/0xad0
> Apr 07 23:39:58 :  ? generic_file_read_iter+0x2e5/0xad0
> Apr 07 23:39:58 :  ? rw_copy_check_uvector+0x8a/0x180
> Apr 07 23:39:58 :  blkdev_read_iter+0x35/0x40
> Apr 07 23:39:58 :  aio_read+0xeb/0x150
> Apr 07 23:39:58 :  ? sched_clock+0x9/0x10
> Apr 07 23:39:58 :  ? sched_clock_cpu+0x11/0xc0
> Apr 07 23:39:58 :  ? __might_fault+0x3e/0x90
> Apr 07 23:39:58 :  ? __might_fault+0x3e/0x90
> Apr 07 23:39:58 :  do_io_submit+0x5f8/0x920
> Apr 07 23:39:58 :  ? do_io_submit+0x5f8/0x920
> Apr 07 23:39:58 :  SyS_io_submit+0x10/0x20
> Apr 07 23:39:58 :  ? SyS_io_submit+0x10/0x20
> Apr 07 23:39:58 :  entry_SYSCALL_64_fastpath+0x1f/0xc2
> Apr 07 23:39:58 : RIP: 0033:0x7f73766216a7
> Apr 07 23:39:58 : RSP: 002b:00007ffc9aac6108 EFLAGS: 00000246 ORIG_RAX:
> 00000000000000d1
> Apr 07 23:39:58 : RAX: ffffffffffffffda RBX: 000055617d90b900 RCX:
> 00007f73766216a7
> Apr 07 23:39:58 : RDX: 00007ffc9aac6120 RSI: 0000000000000002 RDI:
> 00007f7377800000
> Apr 07 23:39:58 : RBP: 0000000000000258 R08: 00007ffc9aac6440 R09:
> 000055617d9a2000
> Apr 07 23:39:58 : R10: 0000556188f93cf0 R11: 0000000000000246 R12:
> 0000000000000280
> Apr 07 23:39:58 : R13: 0000000000000130 R14: 0000000000000001 R15:
> 0000000000000011
> Apr 07 23:39:58 : ---[ end trace 81f169903702b67d ]---

We are working internally to reproduce this issue. we'll report what we find
out from reproduction. 

Thanks,
Himanshu

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
