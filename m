From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] block: Check that queue is alive in blk_insert_cloned_request()
Date: Fri,  8 Jul 2011 16:04:30 -0700
Message-ID: <1310166270-23196-1-git-send-email-roland@kernel.org>
References: <CAG4TOxMjuntpd3Q5jgn+xDa2tgB9tq+jLcDquM_eAdFHXLDrWA@mail.gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG4TOxMjuntpd3Q5jgn+xDa2tgB9tq+jLcDquM_eAdFHXLDrWA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

This fixes crashes such as the below that I see when the storage
underlying a dm-multipath device is hot-removed.  The problem is that
dm requeues a request to a device whose block queue has already been
cleaned up, and blk_insert_cloned_request() doesn't check if the queue
is alive, but rather goes ahead and tries to queue the request.  This
ends up dereferencing the elevator that was already freed in
blk_cleanup_queue().

    general protection fault: 0000 [#1] SMP 
    CPU 7 
    Modules linked in: kvm_intel kvm serio_raw i7core_edac edac_core ioatdma dca pci_stub ses enclosure usbhid usb_storage qla2xxx mpt2sas ahci hid uas libahci e1000e scsi_transport_fc scsi_transport_sas mlx4_core raid_class scsi_tgt
    RIP: 0010:[<ffffffff81233867>]  [<ffffffff81233867>] elv_drain_elevator+0x27/0x80
    RSP: 0018:ffff880614e9fa48  EFLAGS: 00010096
    RAX: 6b6b6b6b6b6b6b6b RBX: ffff880610bb0000 RCX: 0000000000000000
    RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffff880610bb0000
    RBP: ffff880614e9fa58 R08: 0000000000000000 R09: 0000000000000001
    R10: ffff880c0a7dca70 R11: ffff880615622440 R12: ffff880610bb0000
    R13: 0000000000000002 R14: 0000000000000002 R15: ffff880c0db01160
    FS:  00007fe46457a760(0000) GS:ffff880c3fc20000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 00007fe463c86330 CR3: 0000000c0cc0c000 CR4: 00000000000006e0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    Process blkid (pid: 12458, threadinfo ffff880614e9e000, task ffff8806190eae20)
    Stack:
     ffff880c0d9f03c8 ffff880c0d9f03c8 ffff880614e9fa88 ffffff
     ffff880c0d9f03c8 ffff880610bb0000 0000000000000002 ffffc9
     ffff880614e9fab8 ffffffff812366fd ffff880614e9fad8 ffff88
    Call Trace:
     [<ffffffff812339a8>] __elv_add_request+0xe8/0x280
     [<ffffffff812366fd>] add_acct_request+0x3d/0x50
     [<ffffffff81236775>] blk_insert_cloned_request+0x65/0x90
     [<ffffffff813b8d4e>] dm_dispatch_request+0x3e/0x70
     [<ffffffff813ba850>] dm_request_fn+0x160/0x250
     [<ffffffff81236e88>] queue_unplugged+0x48/0xd0
     [<ffffffff8123b03d>] blk_flush_plug_list+0x1ed/0x250
     [<ffffffff810e98f0>] ? sleep_on_page+0x20/0x20
     [<ffffffff814db895>] io_schedule+0x75/0xd0
     [<ffffffff810e98fe>] sleep_on_page_killable+0xe/0x40
     [<ffffffff814dbf9a>] __wait_on_bit_lock+0x5a/0xc0
     [<ffffffff810e9857>] __lock_page_killable+0x67/0x70
     [<ffffffff8106d650>] ? autoremove_wake_function+0x40/0x40
     [<ffffffff810eb5c5>] generic_file_aio_read+0x405/0x720
     [<ffffffff81146962>] do_sync_read+0xd2/0x110
     [<ffffffff8121e393>] ? security_file_permission+0x93/0xb0
     [<ffffffff81146c81>] ? rw_verify_area+0x61/0xf0
     [<ffffffff81147143>] vfs_read+0xc3/0x180
     [<ffffffff81147251>] sys_read+0x51/0x90
     [<ffffffff814e5942>] system_call_fastpath+0x16/0x1b
    Code: c3 0f 1f 00 55 48 89 e5 53 48 83 ec 08 66 66 66 66 90 48 89 fb 0f 1f 80 00 00 00 00 48 8b 43 18 be 01 00 00 00 48 89 df 48 8b 00 <ff> 50 28 85 c0 75 ea 8b 93 f0 03 00 00 85 d2 74 14 8b 05 fa e1 
    RIP  [<ffffffff81233867>] elv_drain_elevator+0x27/0x80
     RSP <ffff880614e9fa48>
     RSP <ffff880614e9fa48>
    ---[ end trace 5dbd03e7295023d7 ]---

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 block/blk-core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d2f8f40..a13a9cc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1706,6 +1706,9 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 		return -EIO;
 #endif
 
+	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
+		return -EIO;
+
 	spin_lock_irqsave(q->queue_lock, flags);
 
 	/*
