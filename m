From: Alan Stern <stern@rowland.harvard.edu>
Subject: Another SCSI/block layer bug [resend]
Date: Sun, 18 Sep 2011 11:15:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1109181112570.703-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:59838 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754251Ab1IRPPg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Sep 2011 11:15:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>
Cc: Rocko Requin <rockorequin@hotmail.com>, Theodore Tso <tytso@mit.edu>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>

[Resending because of an incorrect email address for James last time -- 
sorry!]

James and Jens:

Just in the last couple of days, Rocko encountered the two oopses shown
below.  They occurred when a USB drive containing a mounted ext4
filesystem was first unbound from the usb-storage driver and then later
unmounted.  He was running a 3.1-rc6 kernel.

This problem looks exactly like the one we encountered a few months
ago: The request queue for the disappearing drive gets used after its
elevator has been removed.  In Rocko's case, the offending accesses
were in elv_completed_request() called from __blk_put_request(), and
elv_put_request() called from blk_free_request() via
__blk_put_request().  (The second oops didn't appear until after I sent 
Rocko a patch to prevent the first one.)

I don't know how the request in question got added to the queue in the
first place, but evidently it should not have been there.  Here is a
patch that prevents both oopses, but it clearly is only a band-aid
(although clearing q->elevator after calling elevator_exit() might be
worthwhile in any case.)  Any ideas on the right way to fix this?

Alan Stern



Index: usb-3.1/block/blk-core.c
===================================================================
--- usb-3.1.orig/block/blk-core.c
+++ usb-3.1/block/blk-core.c
@@ -367,8 +367,10 @@ void blk_cleanup_queue(struct request_qu
 	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
 	mutex_unlock(&q->sysfs_lock);
 
-	if (q->elevator)
+	if (q->elevator) {
 		elevator_exit(q->elevator);
+		q->elevator = NULL;
+	}
 
 	blk_throtl_exit(q);
 
Index: usb-3.1/block/elevator.c
===================================================================
--- usb-3.1.orig/block/elevator.c
+++ usb-3.1/block/elevator.c
@@ -769,7 +769,7 @@ void elv_put_request(struct request_queu
 {
 	struct elevator_queue *e = q->elevator;
 
-	if (e->ops->elevator_put_req_fn)
+	if (e && e->ops->elevator_put_req_fn)
 		e->ops->elevator_put_req_fn(rq);
 }
 
@@ -812,7 +812,7 @@ void elv_completed_request(struct reques
 	 */
 	if (blk_account_rq(rq)) {
 		q->in_flight[rq_is_sync(rq)]--;
-		if ((rq->cmd_flags & REQ_SORTED) &&
+		if ((rq->cmd_flags & REQ_SORTED) && e &&
 		    e->ops->elevator_completed_req_fn)
 			e->ops->elevator_completed_req_fn(q, rq);
 	}




First oops:

[  103.498275] BUG: unable to handle kernel paging request at 0000000000100000
[  103.498374] IP: [<0000000000100000>] 0xfffff
[  103.498412] PGD 3d040067 PUD 3d041067 PMD 0 
[  103.498473] Oops: 0010 [#1] SMP 
[  103.498523] CPU 0 
[  103.498541] Modules linked in: usb_storage uas netconsole configfs bnep rfcomm bluetooth binfmt_misc snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq joydev snd_timer snd_seq_device snd soundcore snd_page_alloc i2c_piix4 lp ppdev psmouse parport_pc serio_raw parport usbhid hid ahci libahci e1000
[  103.499077] 
[  103.499095] Pid: 3, comm: ksoftirqd/0 Not tainted 3.1.0-rc6-git-20110917.1649 #15 innotek GmbH VirtualBox
[  103.499142] RIP: 0010:[<0000000000100000>]  [<0000000000100000>] 0xfffff
[  103.499175] RSP: 0018:ffff88003da51c78  EFLAGS: 00010006
[  103.499191] RAX: 0000000000100000 RBX: ffff88003a95b8c0 RCX: 0000000000000b68
[  103.499206] RDX: ffff88002310cc00 RSI: ffff8800232b62e0 RDI: ffff88003a95b8c0
[  103.499222] RBP: ffff88003da51c80 R08: 0000000000000001 R09: 0000000000000007
[  103.499237] R10: 0000000000000000 R11: 00000000ffffb33d R12: ffff8800232b62e0
[  103.499254] R13: 00000000000000b8 R14: 0000000000000000 R15: 0000000000000000
[  103.499271] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
[  103.499287] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  103.499303] CR2: 0000000000100000 CR3: 000000003d03d000 CR4: 00000000000006f0
[  103.499323] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  103.499338] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  103.499356] Process ksoftirqd/0 (pid: 3, threadinfo ffff88003da50000, task ffff88003da3adc0)
[  103.499371] Stack:
[  103.499386]  ffffffff812c239c ffff88003da51cb0 ffffffff812c7adc ffff8800232b62e0
[  103.499456]  ffff8800232b62e0 ffff88003ccf9000 00000000000000b8 ffff88003da51ce0
[  103.499526]  ffffffff812c7d99 ffff8800232b62e0 0000000000000000 ffff88003a95b8c0
[  103.499600] Call Trace:
[  103.499623]  [<ffffffff812c239c>] ? elv_completed_request+0x4c/0x50
[  103.499651]  [<ffffffff812c7adc>] __blk_put_request+0x3c/0xd0
[  103.499670]  [<ffffffff812c7d99>] blk_finish_request+0x229/0x280
[  103.499687]  [<ffffffff812c7e3f>] blk_end_bidi_request+0x4f/0x80
[  103.499704]  [<ffffffff812c7eb0>] blk_end_request+0x10/0x20
[  103.499722]  [<ffffffff813ec6af>] scsi_io_completion+0xaf/0x630
[  103.499739]  [<ffffffff813e2bb1>] scsi_finish_command+0xc1/0x120
[  103.499756]  [<ffffffff813ec4ff>] scsi_softirq_done+0x13f/0x160
[  103.499775]  [<ffffffff812cda23>] blk_done_softirq+0x83/0xa0
[  103.499793]  [<ffffffff81068d28>] __do_softirq+0xa8/0x210
[  103.499813]  [<ffffffff81068f4a>] run_ksoftirqd+0xba/0x170
[  103.499830]  [<ffffffff81068e90>] ? __do_softirq+0x210/0x210
[  103.499847]  [<ffffffff810841ac>] kthread+0x8c/0xa0
[  103.499865]  [<ffffffff815ee174>] kernel_thread_helper+0x4/0x10
[  103.499884]  [<ffffffff81084120>] ? flush_kthread_worker+0xa0/0xa0
[  103.499900]  [<ffffffff815ee170>] ? gs_change+0x13/0x13
[  103.499915] Code:  Bad RIP value.
[  103.499957] RIP  [<0000000000100000>] 0xfffff
[  103.499987]  RSP <ffff88003da51c78>
[  103.500002] CR2: 0000000000100000
[  103.500019] ---[ end trace 14cd7fcafbb12468 ]---


Second oops:

[   56.287858] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   56.287976] IP: [<ffffffff812c231d>] elv_put_request+0xd/0x20
[   56.288059] PGD 2881b067 PUD 2883f067 PMD 0 
[   56.288172] Oops: 0000 [#1] SMP 
[   56.288277] CPU 0 
[   56.288299] Modules linked in: netconsole configfs usb_storage uas bnep rfcomm bluetooth snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer ppdev snd_seq_device binfmt_misc joydev snd soundcore snd_page_alloc parport_pc i2c_piix4 psmouse serio_raw lp parport usbhid hid ahci libahci e1000
[   56.289431] 
[   56.289453] Pid: 3, comm: ksoftirqd/0 Not tainted 3.1.0-rc6-git-20110917.2200 #17 innotek GmbH VirtualBox
[   56.289580] RIP: 0010:[<ffffffff812c231d>]  [<ffffffff812c231d>] elv_put_request+0xd/0x20
[   56.289644] RSP: 0018:ffff88003da51c80  EFLAGS: 00010006
[   56.289664] RAX: 0000000000000000 RBX: ffff88001a570000 RCX: 000000000000017a
[   56.289703] RDX: 0000000000000000 RSI: ffff880029848a10 RDI: ffff88001a570000
[   56.289723] RBP: ffff88003da51c80 R08: 0000000000000001 R09: 0000000000000001
[   56.289763] R10: 0000000000000000 R11: 00000000ffffa0cc R12: ffff880029848a10
[   56.289784] R13: 000000000489200e R14: 0000000000000000 R15: 0000000000000000
[   56.289824] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
[   56.289844] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   56.289885] CR2: 0000000000000000 CR3: 0000000028820000 CR4: 00000000000006f0
[   56.289910] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   56.289953] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   56.289973] Process ksoftirqd/0 (pid: 3, threadinfo ffff88003da50000, task ffff88003da3adc0)
[   56.290012] Stack:
[   56.290031]  ffff88003da51cb0 ffffffff812c7b63 ffff88003da51ca0 ffff880029848a10
[   56.290180]  ffff88001a645800 00000000000000b8 ffff88003da51ce0 ffffffff812c7da9
[   56.290313]  ffff880029848a10 0000000000000000 ffff88001a570000 0000000000000282
[   56.290460] Call Trace:
[   56.290483]  [<ffffffff812c7b63>] __blk_put_request+0xb3/0xd0
[   56.290483]  [<ffffffff812c7da9>] blk_finish_request+0x229/0x280
[   56.290483]  [<ffffffff812c7e4f>] blk_end_bidi_request+0x4f/0x80
[   56.290483]  [<ffffffff812c7ec0>] blk_end_request+0x10/0x20
[   56.290483]  [<ffffffff813ec6bf>] scsi_io_completion+0xaf/0x630
[   56.290483]  [<ffffffff813e2bc1>] scsi_finish_command+0xc1/0x120
[   56.290483]  [<ffffffff813ec50f>] scsi_softirq_done+0x13f/0x160
[   56.290483]  [<ffffffff812cda33>] blk_done_softirq+0x83/0xa0
[   56.290483]  [<ffffffff81068d28>] __do_softirq+0xa8/0x210
[   56.290483]  [<ffffffff81068f4a>] run_ksoftirqd+0xba/0x170
[   56.290483]  [<ffffffff81068e90>] ? __do_softirq+0x210/0x210
[   56.290483]  [<ffffffff810841ac>] kthread+0x8c/0xa0
[   56.290483]  [<ffffffff815ee1b4>] kernel_thread_helper+0x4/0x10
[   56.290483]  [<ffffffff81084120>] ? flush_kthread_worker+0xa0/0xa0
[   56.290483]  [<ffffffff815ee1b0>] ? gs_change+0x13/0x13
[   56.290483] Code: 40 60 48 85 c0 74 07 ff d0 5d c3 0f 1f 00 31 c0 48 c7 86 98 00 00 00 00 00 00 00 5d c3 90 55 48 89 e5 66 66 66 66 90 48 8b 47 18 
[   56.290483]  8b 00 48 8b 40 68 48 85 c0 74 05 48 89 f7 ff d0 5d c3 55 48 
[   56.290483] RIP  [<ffffffff812c231d>] elv_put_request+0xd/0x20
[   56.290483]  RSP <ffff88003da51c80>
[   56.290483] CR2: 0000000000000000
[   56.290483] ---[ end trace 997383ef5eb9fbd0 ]---

