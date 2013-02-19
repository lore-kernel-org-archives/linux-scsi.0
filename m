From: Tommi Rantala <tt.rantala@gmail.com>
Subject: WARNING: at drivers/ata/libata-core.c:5049 ata_qc_issue+0x1c7/0x3a0()
Date: Tue, 19 Feb 2013 20:37:38 +0200
Message-ID: <CA+ydwtooKGVOVq246d1DdROs_ytezTt1JqwX4-TyvNdDi7o+jQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

Hit this WARNING once while fuzzing the kernel with trinity in a qemu
virtual machine as the root user.

Does this make any sense? I have occasionally seen some ATA related
troubles while fuzzing in a VM, but this warning is new to me.

[  490.717030] WARNING: at
/home/ttrantal/git/linux-2.6/drivers/ata/libata-core.c:5049
ata_qc_issue+0x1c7/0x3a0()
[  490.717030] Hardware name: Bochs
[  490.717030] Pid: 2548, comm: trinity-child6 Not tainted 3.8.0+ #87
[  490.717030] Call Trace:
[  490.717030]  [<ffffffff81097b86>] warn_slowpath_common+0x86/0xb0
[  490.717030]  [<ffffffff81097c75>] warn_slowpath_null+0x15/0x20
[  490.717030]  [<ffffffff8150efd7>] ata_qc_issue+0x1c7/0x3a0
[  490.717030]  [<ffffffff81516550>] ? ata_scsi_set_sense.constprop.13+0x30/0x30
[  490.717030]  [<ffffffff815155c0>] ata_scsi_translate+0x120/0x190
[  490.717030]  [<ffffffff81518f4e>] ? ata_scsi_queuecmd+0x2e/0x2d0
[  490.717030]  [<ffffffff81519173>] ata_scsi_queuecmd+0x253/0x2d0
[  490.717030]  [<ffffffff814e3e91>] scsi_dispatch_cmd+0x161/0x230
[  490.717030]  [<ffffffff814e9fd4>] scsi_request_fn+0x544/0x580
[  490.717030]  [<ffffffff813473a6>] ? cfq_dispatch_requests+0x56/0xb30
[  490.717030]  [<ffffffff810f173a>] ? __lock_is_held+0x5a/0x80
[  490.717030]  [<ffffffff81332112>] __blk_run_queue+0x32/0x40
[  490.717030]  [<ffffffff8132d0ea>] __elv_add_request+0x10a/0x280
[  490.717030]  [<ffffffff813391f6>] blk_execute_rq_nowait+0xb6/0xf0
[  490.717030]  [<ffffffff810c0151>] ? __init_waitqueue_head+0x41/0x60
[  490.717030]  [<ffffffff813392d8>] blk_execute_rq+0xa8/0x110
[  490.717030]  [<ffffffff810f557e>] ? lock_release_non_nested+0xde/0x310
[  490.717030]  [<ffffffff812fc1a4>] ? selinux_capable+0x34/0x50
[  490.717030]  [<ffffffff812f8aa3>] ? security_capable+0x13/0x20
[  490.717030]  [<ffffffff810a55d3>] ? ns_capable+0x53/0x80
[  490.717030]  [<ffffffff8133f6c1>] sg_scsi_ioctl+0x2b1/0x3a0
[  490.717030]  [<ffffffff8133fbc2>] scsi_cmd_ioctl+0x412/0x4a0
[  490.717030]  [<ffffffff810f41d7>] ? __lock_acquire+0x957/0x1c20
[  490.717030]  [<ffffffff81084adf>] ? kvm_clock_read+0x1f/0x30
[  490.717030]  [<ffffffff81342d36>] bsg_ioctl+0x146/0x270
[  490.717030]  [<ffffffff810f5b18>] ? trace_hardirqs_off_caller+0x28/0xd0
[  490.717030]  [<ffffffff810f5bcd>] ? trace_hardirqs_off+0xd/0x10
[  490.717030]  [<ffffffff810d552a>] ? local_clock+0x4a/0x70
[  490.717030]  [<ffffffff810f1e98>] ? lock_release_holdtime+0x28/0x170
[  490.717030]  [<ffffffff812fb640>] ? avc_has_perm_flags+0x1d0/0x2a0
[  490.717030]  [<ffffffff812fb498>] ? avc_has_perm_flags+0x28/0x2a0
[  490.717030]  [<ffffffff810f5b18>] ? trace_hardirqs_off_caller+0x28/0xd0
[  490.717030]  [<ffffffff810f5bcd>] ? trace_hardirqs_off+0xd/0x10
[  490.717030]  [<ffffffff811b5ff2>] do_vfs_ioctl+0x532/0x580
[  490.717030]  [<ffffffff812fc7d3>] ? file_has_perm+0x83/0xa0
[  490.717030]  [<ffffffff811b609d>] sys_ioctl+0x5d/0xa0
[  490.717030]  [<ffffffff813571de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  490.717030]  [<ffffffff81ca07e9>] system_call_fastpath+0x16/0x1b
[  490.717030] ---[ end trace fce35d2b40bd0565 ]---
[  490.810874] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[  490.812538] ata1.00: failed command: READ DMA
[  490.813715] ata1.00: cmd c8/00:2c:00:01:00/00:00:00:00:00/e0 tag 0
[  490.813715]          res 50/01:00:b0:16:04/00:00:00:00:00/a0 Emask
0x40 (internal error)
[  490.817269] ata1.00: status: { DRDY }
[watchdog] 333615 iterations. [F:326712 S:6891]
[watchdog] kernel became tainted! Last seed was 71022097
[  491.266158] ata1.00: configured for MWDMA2
[  491.267358] ata1: EH complete
child 2548 exitting
child 2492 exitting
child 2500 exitting
[2351] Bailing main loop. Exit reason: kernel became tainted
[2350] Watchdog exiting

Ran 333617 syscalls. Successes: 6892  Failures: 326714

Tommi
