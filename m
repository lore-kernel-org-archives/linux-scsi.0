From: Sasha Levin <sasha.levin@oracle.com>
Subject: scsi: non atomic allocation in mempool_alloc in atomic context
Date: Wed, 31 Dec 2014 13:14:19 -0500
Message-ID: <54A43CFB.2080705@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hch@lst.de
Cc: bvanassche@acm.org, hare@suse.de, JBottomley@parallels.com, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Christoph,

I'm seeing an issue which was bisected down to 3c356bde1 ("scsi: stop passing
a gfp_mask argument down the command setup path"):

[ 3395.328221] BUG: sleeping function called from invalid context at mm/mempool.c:206
[ 3395.329540] in_atomic(): 1, irqs_disabled(): 0, pid: 6399, name: trinity-c531
[ 3395.331104] no locks held by trinity-c531/6399.
[ 3395.331849] Preemption disabled blk_execute_rq_nowait (block/blk-exec.c:95)
[ 3395.333145]
[ 3395.333392] CPU: 5 PID: 6399 Comm: trinity-c531 Not tainted 3.19.0-rc1-next-20141226-sasha-00051-g2dd3d73 #1646
[ 3395.335266]  0000000000000000 0000000000000000 ffff880608948000 ffff880645a07548
[ 3395.337679]  ffffffff9137c79d 0000000000000000 ffff880608948000 ffff880645a07588
[ 3395.340220]  ffffffff814ad713 ffffffff9de20590 ffff880608948000 ffffffff926a166c
[ 3395.342643] Call Trace:
[ 3395.345099] dump_stack (lib/dump_stack.c:52)
[ 3395.346793] ___might_sleep (kernel/sched/core.c:7342)
[ 3395.348571] __might_sleep (kernel/sched/core.c:7308)
[ 3395.351944] mempool_alloc (mm/mempool.c:206 (discriminator 1))
[ 3395.355196] scsi_sg_alloc (drivers/scsi/scsi_lib.c:582)
[ 3395.356893] __sg_alloc_table (lib/scatterlist.c:282)
[ 3395.358844] ? sdev_disable_disk_events (drivers/scsi/scsi_lib.c:577)
[ 3395.360873] scsi_alloc_sgtable (drivers/scsi/scsi_lib.c:608)
[ 3395.362769] scsi_init_sgtable (drivers/scsi/scsi_lib.c:1087)
[ 3395.364583] ? lockdep_init_map (kernel/locking/lockdep.c:2986)
[ 3395.366354] scsi_init_io (drivers/scsi/scsi_lib.c:1122)
[ 3395.368092] ? do_init_timer (kernel/time/timer.c:669)
[ 3395.369837] scsi_setup_cmnd (drivers/scsi/scsi_lib.c:1220 drivers/scsi/scsi_lib.c:1268)
[ 3395.371743] scsi_queue_rq (drivers/scsi/scsi_lib.c:1875 drivers/scsi/scsi_lib.c:1980)
[ 3395.373471] __blk_mq_run_hw_queue (block/blk-mq.c:751)
[ 3395.375481] blk_mq_run_hw_queue (block/blk-mq.c:831)
[ 3395.377324] blk_mq_insert_request (block/blk-mq.h:92 block/blk-mq.c:974)
[ 3395.379377] ? blk_rq_map_user (block/blk-map.c:78 block/blk-map.c:142)
[ 3395.381307] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2559 kernel/locking/lockdep.c:2601)
[ 3395.383485] blk_execute_rq_nowait (block/blk-exec.c:95)
[ 3395.386995] sg_common_write.isra.2 (drivers/scsi/sg.c:823)
[ 3395.388712] ? might_fault (mm/memory.c:3730)
[ 3395.390624] sg_write (drivers/scsi/sg.c:686)
[ 3395.403014] do_loop_readv_writev (fs/read_write.c:722)
[ 3395.407429] do_readv_writev (fs/read_write.c:854)
[ 3395.415486] vfs_writev (fs/read_write.c:893)
[ 3395.417116] SyS_writev (fs/read_write.c:926 fs/read_write.c:917)
[ 3395.418851] ? trace_hardirqs_on_thunk (arch/x86/lib/thunk_64.S:33)
[ 3395.420922] system_call_fastpath (arch/x86/kernel/entry_64.S:423)


Thanks,
Sasha
