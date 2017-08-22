From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: possible circular locking dependency detected [was: linux-next: Tree
 for Aug 22]
Date: Tue, 22 Aug 2017 19:47:08 +0900
Message-ID: <20170822104708.GA491@jagdpanzerIV.localdomain>
References: <20170822183816.7925e0f8@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170822183816.7925e0f8@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

======================================================
WARNING: possible circular locking dependency detected
4.13.0-rc6-next-20170822-dbg-00020-g39758ed8aae0-dirty #1746 Not tainted
------------------------------------------------------
fsck.ext4/148 is trying to acquire lock:
 (&bdev->bd_mutex){+.+.}, at: [<ffffffff8116e73e>] __blkdev_put+0x33/0x190

 but now in release context of a crosslock acquired at the following:
 ((complete)&wait#2){+.+.}, at: [<ffffffff812159e0>] blk_execute_rq+0xbb/0xda

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #1 ((complete)&wait#2){+.+.}:
       lock_acquire+0x176/0x19e
       __wait_for_common+0x50/0x1e3
       blk_execute_rq+0xbb/0xda
       scsi_execute+0xc3/0x17d [scsi_mod]
       sd_revalidate_disk+0x112/0x1549 [sd_mod]
       rescan_partitions+0x48/0x2c4
       __blkdev_get+0x14b/0x37c
       blkdev_get+0x191/0x2c0
       device_add_disk+0x2b4/0x3e5
       sd_probe_async+0xf8/0x17e [sd_mod]
       async_run_entry_fn+0x34/0xe0
       process_one_work+0x2af/0x4d1
       worker_thread+0x19a/0x24f
       kthread+0x133/0x13b
       ret_from_fork+0x27/0x40

 -> #0 (&bdev->bd_mutex){+.+.}:
       __blkdev_put+0x33/0x190
       blkdev_close+0x24/0x27
       __fput+0xee/0x18a
       task_work_run+0x79/0xa0
       prepare_exit_to_usermode+0x9b/0xb5

 other info that might help us debug this:
 Possible unsafe locking scenario by crosslock:
       CPU0                    CPU1
       ----                    ----
  lock(&bdev->bd_mutex);
  lock((complete)&wait#2);
                               lock(&bdev->bd_mutex);
                               unlock((complete)&wait#2);

  *** DEADLOCK ***
4 locks held by fsck.ext4/148:
 #0:  (&bdev->bd_mutex){+.+.}, at: [<ffffffff8116e73e>] __blkdev_put+0x33/0x190
 #1:  (rcu_read_lock){....}, at: [<ffffffff81217f16>] rcu_lock_acquire+0x0/0x20
 #2:  (&(&host->lock)->rlock){-.-.}, at: [<ffffffffa00e7550>] ata_scsi_queuecmd+0x23/0x74 [libata]
 #3:  (&x->wait#14){-...}, at: [<ffffffff8106b593>] complete+0x18/0x50

 stack backtrace:
CPU: 1 PID: 148 Comm: fsck.ext4 Not tainted 4.13.0-rc6-next-20170822-dbg-00020-g39758ed8aae0-dirty #1746
Call Trace:
 dump_stack+0x67/0x8e
 print_circular_bug+0x2a1/0x2af
 ? zap_class+0xc5/0xc5
 check_prev_add+0x76/0x20d
 ? __lock_acquire+0xc27/0xcc8
 lock_commit_crosslock+0x327/0x35e
 complete+0x24/0x50
 scsi_end_request+0x8d/0x176 [scsi_mod]
 scsi_io_completion+0x1be/0x423 [scsi_mod]
 __blk_mq_complete_request+0x112/0x131
 ata_scsi_simulate+0x212/0x218 [libata]
 __ata_scsi_queuecmd+0x1be/0x1de [libata]
 ata_scsi_queuecmd+0x41/0x74 [libata]
 scsi_dispatch_cmd+0x194/0x2af [scsi_mod]
 scsi_queue_rq+0x1e0/0x26f [scsi_mod]
 blk_mq_dispatch_rq_list+0x193/0x2a7
 ? _raw_spin_unlock+0x2e/0x40
 blk_mq_sched_dispatch_requests+0x132/0x176
 __blk_mq_run_hw_queue+0x59/0xc5
 __blk_mq_delay_run_hw_queue+0x5f/0xc1
 blk_mq_flush_plug_list+0xfc/0x10b
 blk_flush_plug_list+0xc6/0x1eb
 blk_finish_plug+0x25/0x32
 generic_writepages+0x56/0x63
 do_writepages+0x36/0x70
 __filemap_fdatawrite_range+0x59/0x5f
 filemap_write_and_wait+0x19/0x4f
 __blkdev_put+0x5f/0x190
 blkdev_close+0x24/0x27
 __fput+0xee/0x18a
 task_work_run+0x79/0xa0
 prepare_exit_to_usermode+0x9b/0xb5
 entry_SYSCALL_64_fastpath+0xab/0xad
RIP: 0033:0x7ff5755a2f74
RSP: 002b:00007ffe46fce038 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000555ddeddded0 RCX: 00007ff5755a2f74
RDX: 0000000000001000 RSI: 0000555ddede2580 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000555ddede2580 R09: 0000555ddedde080
R10: 0000000108000000 R11: 0000000000000246 R12: 0000555ddedddfa0
R13: 00007ff576523680 R14: 0000000000001000 R15: 0000555ddeddc2b0

	-ss
