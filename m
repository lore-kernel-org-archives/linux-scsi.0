From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 4.6+ merge window
Date: Sun, 29 May 2016 14:02:09 -0400
Message-ID: <574B2EA1.9080006@oracle.com>
References: <1463570346.27423.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1463570346.27423.2.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi all,

On 05/18/2016 07:19 AM, James Bottomley wrote:
> Douglas Gilbert (13):
>       scsi_debug: use locally assigned naa
>       scsi_debug: uuid for lu name
>       scsi_debug: vpd and mode page work
>       scsi_debug: add multiple queue support
>       scsi_debug: rework resp_report_luns

The commit above seems to be causing the following:

[  784.130990] BUG: sleeping function called from invalid context at mm/slab.h:388

[  784.131073] in_atomic(): 1, irqs_disabled(): 0, pid: 21582, name: syz-executor

[  784.131216] Preemption disabled blk_mq_insert_request (block/blk-mq.h:89 block/blk-mq.c:1010)
[  784.131252]
[  784.131292] CPU: 4 PID: 21582 Comm: syz-executor Tainted: G    B           4.6.0-next-20160527-sasha-00024-g6ab0dc9-dirty #3098

[  784.131336]  1ffff100369e8e06 0000000085bb6488 ffff8801b4f470b8 ffffffffa0fd0b37

[  784.131367]  ffffffff00000004 fffffbfff57eeda4 0000000041b58ab3 ffffffffab8dd830

[  784.131391]  ffffffffa0fd09c8 ffff8801b4f47060 ffffffff9f53ef7a 00007f4739889c18

[  784.131396] Call Trace:
[  784.131443] dump_stack (lib/dump_stack.c:53)
[  784.131609] ___might_sleep (kernel/sched/core.c:7554)
[  784.131637] __might_sleep (kernel/sched/core.c:7516 (discriminator 14))
[  784.131706] kmem_cache_alloc_node (mm/slab.h:390 mm/slub.c:2498 mm/slub.c:2608)
[  784.131761] __get_vm_area_node (include/linux/slab.h:390 include/linux/slab.h:516 include/linux/slab.h:633 mm/vmalloc.c:1370)
[  784.131778] __vmalloc_node_range (mm/vmalloc.c:1688)
[  784.131941] vmalloc (mm/vmalloc.c:1766)
[  784.131974] resp_report_luns (drivers/scsi/scsi_debug.c:3335)
[  784.132010] scsi_debug_queuecommand (drivers/scsi/scsi_debug.c:5362)
[  784.132109] scsi_dispatch_cmd (drivers/scsi/scsi_lib.c:1635)
[  784.132125] scsi_queue_rq (drivers/scsi/scsi_lib.c:1924)
[  784.132185] __blk_mq_run_hw_queue (block/blk-mq.c:784)
[  784.132315] blk_mq_run_hw_queue (block/blk-mq.c:874)
[  784.132340] blk_mq_insert_request (block/blk-mq.h:94 block/blk-mq.c:1023)
[  784.132359] blk_execute_rq_nowait (block/blk-exec.c:69)
[  784.132390] sg_common_write.isra.5 (drivers/scsi/sg.c:812)
[  784.132490] sg_write (drivers/scsi/sg.c:687)
[  784.132679] __vfs_write (fs/read_write.c:514)
[  784.132815] vfs_write (fs/read_write.c:565)
[  784.132830] SyS_write (fs/read_write.c:612 fs/read_write.c:603)
[  784.132929] do_syscall_64 (arch/x86/entry/common.c:350)
[  784.132947] entry_SYSCALL64_slow_path (arch/x86/entry/entry_64.S:251)


Thanks,
Sasha
