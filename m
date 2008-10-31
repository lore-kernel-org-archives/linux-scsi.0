From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Thu, 30 Oct 2008 20:12:48 -0700 (PDT)
Message-ID: <20081031031248.41111108048@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753294AbYJaDNU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2008 23:13:20 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9V3CmnV009875
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2008 20:12:49 -0700
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #4 from alex.shi@intel.com  2008-10-30 20:12 -------
Thanks Yi's help. 
After enable CONFIG_DEBUG_INFO, this bug can not reproduce on 2.6.28-rc1. but
it still exists on 28-rc2 kernel. Soft lockup catchs several times lockup. And
they are same as the following one. 


BUG: soft lockup - CPU#7 stuck for 61s! [mke2fs:3918]
Modules linked in: e1000e [last unloaded: microcode]
Modules linked in: e1000e [last unloaded: microcode]
Call Trace:
 <IRQ>  [<ffffffff8033f311>] ? blk_invoke_request_fn+0x76/0x11a
 [<ffffffff8033f872>] ? __blk_run_queue+0x2a/0x2e
 [<ffffffff803f2b5a>] ? scsi_run_queue+0x2c7/0x2de
 [<ffffffff803f31b7>] ? scsi_next_command+0x3b/0x4c
 [<ffffffff803f3454>] ? scsi_end_request+0x97/0xa9
 [<ffffffff803f4112>] ? scsi_io_completion+0x190/0x3a8
 [<ffffffff80271930>] ? wb_timer_fn+0x0/0x37
 [<ffffffff803ee889>] ? scsi_finish_command+0xb6/0xbf
 [<ffffffff803f442b>] ? scsi_softirq_done+0x101/0x109
 [<ffffffff80343413>] ? blk_done_softirq+0x68/0x79
 [<ffffffff8023d8bc>] ? __do_softirq+0x86/0x14f
 [<ffffffff8020c62c>] ? call_softirq+0x1c/0x28
 [<ffffffff8020dc21>] ? do_softirq+0x39/0x77
 [<ffffffff8023d834>] ? irq_exit+0x44/0x46
 [<ffffffff8020de65>] ? do_IRQ+0xc8/0xe7
 [<ffffffff8020b8e6>] ? ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff802b402a>] ? blkdev_write_end+0x0/0x3e
 [<ffffffff802aeecb>] ? mark_buffer_dirty+0x14/0x85
 [<ffffffff802aefbc>] ? __block_commit_write+0x80/0xb1
 [<ffffffff802af173>] ? block_write_end+0x51/0x5d
 [<ffffffff802b404a>] ? blkdev_write_end+0x20/0x3e
 [<ffffffff8026b060>] ? iov_iter_copy_from_user_atomic+0x85/0xb3
 [<ffffffff8026c2d0>] ? generic_file_buffered_write+0x1c1/0x628
 [<ffffffff8022eb7b>] ? task_rq_lock+0x40/0x75
 [<ffffffff8023cef9>] ? current_fs_time+0x27/0x2e
 [<ffffffff8026cc41>] ? __generic_file_aio_write_nolock+0x359/0x3c3
 [<ffffffff8026cdb0>] ? generic_file_aio_write_nolock+0x40/0x91
 [<ffffffff80291c35>] ? do_sync_write+0xe7/0x12b
 [<ffffffff8024b982>] ? autoremove_wake_function+0x0/0x3d
 [<ffffffff8039f01c>] ? tty_write+0x211/0x22c
 [<ffffffff803a0f51>] ? n_tty_write+0x0/0x31d
 [<ffffffff802923e7>] ? vfs_write+0xb3/0x13c
 [<ffffffff802928bf>] ? sys_write+0x4c/0x74
 [<ffffffff8020b3db>] ? system_call_fastpath+0x16/0x1b


I do not know what addr2line show a strange output:
Addr2line -e vmlinux -f blk_invoke_request_fn+0x76 | hexdump 
0000000 3f3f 3f0a 3a3f 0a30
0000008

But seems gdb works for this. 
(gdb) list *blk_invoke_request_fn+0x76 
0xffffffff8033f311 is in blk_invoke_request_fn (include/linux/blkdev.h:456).
451     #define QUEUE_FLAG_NONROT      14       /* non-rotational device (SSD)
*/
452
453     static inline int queue_is_locked(struct request_queue *q)
454     {
455     #ifdef CONFIG_SMP
456             spinlock_t *lock = q->queue_lock;
457             return lock && spin_is_locked(lock);
458     #else
459             return 1;
460     #endif

Alex 


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
