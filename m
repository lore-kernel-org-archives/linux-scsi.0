From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] Unable to handle kernel NULL pointer
 dereference...as_move_to_dispatch+0x11/0x135
Date: Thu, 1 Feb 2007 23:23:02 -0800
Message-ID: <20070201232302.905962b6.akpm@linux-foundation.org>
References: <20070122183510.GA19905@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37222 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423169AbXBBHXN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Feb 2007 02:23:13 -0500
In-Reply-To: <20070122183510.GA19905@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Nigel Kirkland <nigel.kirkland@qlogic.com>

On Mon, 22 Jan 2007 10:35:10 -0800 Andrew Vasquez <andrew.vasquez@qlogic.com> wrote:

> All,
> 
> We've been trying to track down a nagging regression  seen during some
> port-disable/enable testing.  The problem occurs anywhere from
> 20 minutes to 120 minutes of testing under very minimal I/O load:
> 
> 	[ 1143.890598] Unable to handle kernel NULL pointer dereference at 0000000000000028 RIP: 
> 	[ 1143.896087]  [<ffffffff802ed04f>] as_move_to_dispatch+0x11/0x135
> 	[ 1143.904574] PGD 120ba067 PUD 31e8c067 PMD 0 
> 	[ 1143.908895] Oops: 0000 [1] SMP 
> 	[ 1143.912065] CPU 1 
> 	[ 1143.914092] Modules linked in: qla2xxx scsi_transport_fc
> 	[ 1143.919453] Pid: 8362, comm: dt Not tainted 2.6.19 #39
> 	[ 1143.924588] RIP: 0010:[<ffffffff802ed04f>]  [<ffffffff802ed04f>] as_move_to_dispatch+0x11/0x135
> 	[ 1143.933300] RSP: 0018:ffff8100021f7cf0  EFLAGS: 00010046
> 	[ 1143.938610] RAX: 0000000000000000 RBX: ffff8100261392f0 RCX: 0000000000000000
> 	[ 1143.945736] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8100261392f0
> 	[ 1143.952865] RBP: 0000000000000000 R08: ffffffff804d0928 R09: ffff8100351a96e0
> 	[ 1143.959992] R10: ffff8100351a96e0 R11: 0000000000000000 R12: 0000000000000000
> 	[ 1143.967118] R13: 0000000000000000 R14: 0000000000000282 R15: 0000000000000001
> 	[ 1143.974248] FS:  0000000000000000(0000) GS:ffff8100021c5930(0000) knlGS:0000000000000000
> 	[ 1143.982327] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> 	[ 1143.988070] CR2: 0000000000000028 CR3: 000000003493b000 CR4: 00000000000006e0
> 	[ 1143.995198] Process dt (pid: 8362, threadinfo ffff8100207a2000, task ffff810023d86840)
> 	[ 1144.003103] Stack:  0000000000000000 ffff8100261392f0 0000000000000000 0000000000000001
> 	[ 1144.011183]  0000000000000000 ffffffff802ed591 0000000000000000 ffff810035795990
> 	[ 1144.018640]  ffff81000f11b3f8 ffff810035795990 ffff810035795990 ffffffff802e53d6
> 	[ 1144.025906] Call Trace:
> 	[ 1144.028548]  <IRQ>  [<ffffffff802ed591>] as_dispatch_request+0x39d/0x3aa
> 	[ 1144.035274]  [<ffffffff802e53d6>] elv_next_request+0x45/0x151
> 	[ 1144.041015]  [<ffffffff8037b3cf>] scsi_request_fn+0x7a/0x375
> 	[ 1144.046667]  [<ffffffff802e8fa0>] blk_run_queue+0x42/0x74
> 	[ 1144.052062]  [<ffffffff8037b2bc>] scsi_next_command+0x2d/0x39
> 	[ 1144.057805]  [<ffffffff8037b85b>] scsi_end_request+0xc0/0xce
> 	[ 1144.063460]  [<ffffffff8037ba03>] scsi_io_completion+0x149/0x351
> 	[ 1144.069464]  [<ffffffff8038aad6>] sd_rw_intr+0x247/0x256
> 	[ 1144.074770]  [<ffffffff80376b92>] scsi_finish_command+0x88/0x8d
> 	[ 1144.080686]  [<ffffffff8037c25e>] scsi_softirq_done+0xe7/0xef
> 	[ 1144.086429]  [<ffffffff802e614c>] blk_done_softirq+0x63/0x71
> 	[ 1144.092082]  [<ffffffff80226487>] __do_softirq+0x51/0xbd
> 	[ 1144.097394]  [<ffffffff8020a88c>] call_softirq+0x1c/0x28
> 	[ 1144.102701]  [<ffffffff8020bffa>] do_softirq+0x2e/0x94
> 	[ 1144.107836]  [<ffffffff8020c10e>] do_IRQ+0xae/0xc8
> 	[ 1144.112625]  [<ffffffff80209c81>] ret_from_intr+0x0/0xb
> 	[ 1144.117845]  <EOI>  [<ffffffff8027dfad>] __bio_add_page+0x1b8/0x1bf
> 	[ 1144.124135]  [<ffffffff8027ecb6>] blkdev_direct_IO+0x2c9/0x420
> 	[ 1144.129964]  [<ffffffff8021a1f4>] __activate_task+0x2d/0x3f
> 	[ 1144.135537]  [<ffffffff8040df0d>] _spin_unlock_irq+0x6/0x9
> 	[ 1144.141024]  [<ffffffff80241d86>] generic_file_direct_IO+0xa6/0xe8
> 	[ 1144.147196]  [<ffffffff80219efe>] __wake_up_common+0x42/0x6c
> 	[ 1144.152852]  [<ffffffff80242515>] generic_file_aio_read+0xcc/0x19d
> 	[ 1144.159029]  [<ffffffff8025d7cd>] do_sync_read+0xc8/0x10b
> 	[ 1144.164426]  [<ffffffff8023343c>] autoremove_wake_function+0x0/0x2e
> 	[ 1144.170684]  [<ffffffff8040df0d>] _spin_unlock_irq+0x6/0x9
> 	[ 1144.176166]  [<ffffffff8025c516>] do_filp_open+0x2d/0x3d
> 	[ 1144.181480]  [<ffffffff80259876>] poison_obj+0x35/0x44
> 	[ 1144.186620]  [<ffffffff8025e1c0>] vfs_read+0xac/0x14f
> 	[ 1144.191668]  [<ffffffff8025e322>] sys_read+0x45/0x6e
> 	[ 1144.196630]  [<ffffffff8020976e>] system_call+0x7e/0x83
> 	[ 1144.201852] 
>
> ...
>
> Basically what is happening from the FC side is the initiator executes
> a simple dt test:
> 
>         dt of=/dev/raw/raw1 procs=8 oncerr=abort bs=16k disable=stats limit=2m passes=1000000 pattern=iot dlimit=2048
> 
> against a single lun (a very basic Windows target mode driver).
> During the test a port-enable, port-disable script is running agains
> the switch's port that is connected to the target (this occurs every
> sixty seconds (for a disabled duration of 2 seconds).  Additionally,
> the target itself is set to LOGO (logout) or drop off the topology
> every 30 seconds.

I don't understand what effect the port-enable/port-disable has upon the
system.  Will it cause I/O errors, or what?


> This test runs fine up to 2.6.19.

One thing we did in there was to give direct-io-against-blockdevs some
special-case bio-preparation code.  Perhaps this is tickling a bug somehow.

We can revert that change like this:


diff -puN fs/block_dev.c~a fs/block_dev.c
--- a/fs/block_dev.c~a
+++ a/fs/block_dev.c
@@ -196,8 +196,47 @@ static void blk_unget_page(struct page *
 	pvec->page[--pvec->idx] = page;
 }
 
+static int
+blkdev_get_blocks(struct inode *inode, sector_t iblock,
+		struct buffer_head *bh, int create)
+{
+	sector_t end_block = max_block(I_BDEV(inode));
+	unsigned long max_blocks = bh->b_size >> inode->i_blkbits;
+
+	if ((iblock + max_blocks) > end_block) {
+		max_blocks = end_block - iblock;
+		if ((long)max_blocks <= 0) {
+			if (create)
+				return -EIO;	/* write fully beyond EOF */
+			/*
+			 * It is a read which is fully beyond EOF.  We return
+			 * a !buffer_mapped buffer
+			 */
+			max_blocks = 0;
+		}
+	}
+
+	bh->b_bdev = I_BDEV(inode);
+	bh->b_blocknr = iblock;
+	bh->b_size = max_blocks << inode->i_blkbits;
+	if (max_blocks)
+		set_buffer_mapped(bh);
+	return 0;
+}
+
 static ssize_t
 blkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
+			loff_t offset, unsigned long nr_segs)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+
+	return blockdev_direct_IO_no_locking(rw, iocb, inode, I_BDEV(inode),
+				iov, offset, nr_segs, blkdev_get_blocks, NULL);
+}
+
+static ssize_t
+xxblkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 		 loff_t pos, unsigned long nr_segs)
 {
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
_

