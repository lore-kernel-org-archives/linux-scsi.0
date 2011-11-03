From: Jiri Slaby <jslaby@suse.cz>
Subject: NULL ptr deref at elv_drain_elevator
Date: Thu, 03 Nov 2011 17:08:40 +0100
Message-ID: <4EB2BC88.3070105@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <jejb@parisc-linux.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

I'm seeing the NULL ptr dereference below on each boot of KVM virtual
machine. q->elevator is NULL. This is next-20111025.

I tried to apply Tejun's patch from:
 https://lkml.org/lkml/2011/4/30/87
but it doesn't help. Maybe I should revert something?

Scanning for LVM volume groups...
Reading all physical volumes.  This may take a while...
No volume groups found
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff8125a69c>] elv_drain_elevator+0x1c/0x70
PGD 46176067 PUD 452b5067 PMD 0
Oops: 0000 [#1] SMP
CPU 0
Modules linked in:

Pid: 830, comm: kworker/0:2 Not tainted 3.1.0-next-20111025_64+ #1590
Bochs Bochs
RIP: 0010:[<ffffffff8125a69c>]  [<ffffffff8125a69c>]
elv_drain_elevator+0x1c/0x70
RSP: 0018:ffff8800461abd00  EFLAGS: 00010086
RAX: 0000000000000000 RBX: ffff880046948e00 RCX: 00000001820001ee
RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff880046948e00
RBP: ffff8800461abd10 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000001
R13: ffff8800469494e0 R14: ffff88004689c450 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff880049600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 00000000451f6000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:2 (pid: 830, threadinfo ffff8800461aa000, task
ffff880046f28670)
Stack:
 ffff88004789f888 ffff880046948e00 ffff8800461abd30 ffffffff8125da92
 ffff880046948e00 ffff8800469491f4 ffff8800461abd60 ffffffff8125db90
 ffff8800461abd40 ffff88004689c450 ffff88004689c400 ffff88004789f888
Call Trace:
 [<ffffffff8125da92>] blk_drain_queue+0x42/0x70
 [<ffffffff8125db90>] blk_cleanup_queue+0xd0/0x1c0
 [<ffffffff81469640>] md_free+0x50/0x70
 [<ffffffff8126f43b>] kobject_release+0x8b/0x1d0
 [<ffffffff8126f3b0>] ? kobject_del+0x40/0x40
 [<ffffffff81469380>] ? bb_show+0x20/0x20
 [<ffffffff81270d56>] kref_put+0x36/0xa0
 [<ffffffff8126f2b7>] kobject_put+0x27/0x60
 [<ffffffff814693af>] mddev_delayed_delete+0x2f/0x40
 [<ffffffff81083450>] process_one_work+0x100/0x3b0
 [<ffffffff8108527f>] worker_thread+0x15f/0x3a0
 [<ffffffff81085120>] ? manage_workers.isra.32+0x240/0x240
 [<ffffffff81089937>] kthread+0x87/0x90
 [<ffffffff81621834>] kernel_thread_helper+0x4/0x10
 [<ffffffff810898b0>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff81621830>] ? gs_change+0xb/0xb
Code: c0 74 02 ff d0 5d c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 53 48 89
fb 48 83 ec 08 0f 1f 40 00 48 8b 43 18 be 01 00 00 00 48 89 df
 8b 00 ff 50 28 85 c0 75 ea 8b 93 80 04 00 00 85 d2 74 14 8b
RIP  [<ffffffff8125a69c>] elv_drain_elevator+0x1c/0x70
 RSP <ffff8800461abd00>
CR2: 0000000000000000
---[ end trace 2b4616ccecf0982b ]---

thanks,
-- 
js
suse labs
