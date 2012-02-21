From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-io async WRITE_SAME results in iSCSI NULL pointer [was: Re:
 Write same support]
Date: Mon, 20 Feb 2012 22:18:55 -0500
Message-ID: <20120221031854.GA468@redhat.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
 <20120216200202.GA27311@redhat.com>
 <20120216210301.GA27404@redhat.com>
 <yq139a55rhr.fsf@sermon.lab.mkp.net>
 <20120220184623.GA29931@redhat.com>
 <20120220234410.GC31853@redhat.com>
 <yq1k43h2gm9.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab2BUDTJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2012 22:19:09 -0500
Content-Disposition: inline
In-Reply-To: <yq1k43h2gm9.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com, dm-devel@redhat.com, michaelc@cs.wisc.edu, Vivek Goyal <vgoyal@redhat.com>

On Mon, Feb 20 2012 at  7:07pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> The REQ_WRITE_SAME request, that SCSI is processing on behalf of
> Mike> the dm_kcopyd_zero() generated bio, has multiple bios (as if
> Mike> merging occurred).
> 
> Did you add a fix for the issue Vivek pointed out wrt. merging?

Nope, probably the problem (rq_mergeable called in multiple places).
 
> PS. I pushed an updated 'writesame2' branch to kernel.org.

OK, thanks.

One, thing I noticed: bio_has_data returns false for REQ_WRITE_SAME.
But REQ_WRITE_SAME does have data, and it really should be accounted
no?:

@@ -1682,7 +1682,7 @@ void submit_bio(int rw, struct bio *bio)
         * If it's a regular read/write or a barrier with data attached,
         * go through the normal accounting stuff before submission.
         */
-       if (bio_has_data(bio) && !(rw & REQ_DISCARD)) {
+       if (bio_has_data(bio)) {
                if (rw & WRITE) {
                        count_vm_events(PGPGOUT, count);
                } else {

That aside, I tried your updated code and hit this BUG when I use the
patch that has always worked (my dm-thin patch that uses the
blkdev_issue_write_same() interface):

------------[ cut here ]------------
kernel BUG at drivers/scsi/scsi_lib.c:1116!
invalid opcode: 0000 [#1] SMP 
CPU 1 
Modules linked in: dm_thin_pool dm_persistent_data dm_bufio libcrc32c dm_mod sunrpc iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi virtio_net virtio_balloon i2c_piix4 i2c_core virtio_blk virtio_pci virtio_ring virtio [last unloaded : dm_thin_pool]

Pid: 33, comm: kworker/1:2 Tainted: G        W    3.2.0-snitm+ #177 Red Hat KVM
RIP: 0010:[<ffffffff81293c06>]  [<ffffffff81293c06>] scsi_setup_blk_pc_cmnd+0x91/0x11f
RSP: 0000:ffff880117d99b00  EFLAGS: 00010046
RAX: ffff8801191db838 RBX: ffff880119315a80 RCX: 8c6318c6318c6320
RDX: ffff88011f40dabc RSI: ffffffff81395722 RDI: ffffffff8107254a
RBP: ffff880117d99b20 R08: ffff880117f96880 R09: ffffffff815509b7
R10: ffff880117f96800 R11: 0000000000000046 R12: ffff8801191db740
R13: 0000000000000000 R14: ffff880117f96800 R15: ffff880117f96800
FS:  0000000000000000(0000) GS:ffff88011f400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000410fb0 CR3: 0000000111b93000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/1:2 (pid: 33, threadinfo ffff880117d98000, task ffff880117d94880)
Stack:
 0000000000008000 ffff8801191db740 0000000000420800 0000000000000001
 ffff880117d99ba0 ffffffff8129e271 ffff8801191db740 0000000000000001
 ffff880117d99b70 ffff8801191db740 ffff8801175c4f48 ffff8801175c4f48
Call Trace:
 [<ffffffff8129e271>] sd_prep_fn+0x3da/0xce2
 [<ffffffff811c35be>] ? elv_dispatch_add_tail+0x6f/0x71
 [<ffffffff811c9ee0>] blk_peek_request+0xee/0x1d8
 [<ffffffff812930b7>] scsi_request_fn+0x7d/0x48d
 [<ffffffff811c4480>] __blk_run_queue+0x1e/0x20
 [<ffffffff811c88e3>] queue_unplugged+0x8a/0xa2
 [<ffffffff811c9034>] blk_flush_plug_list+0x1a9/0x1dd
 [<ffffffffa00e3e32>] ? process_jobs+0xe1/0xe1 [dm_mod]
 [<ffffffff811c9080>] blk_finish_plug+0x18/0x39
 [<ffffffffa00e3ea4>] do_work+0x72/0x7d [dm_mod]
 [<ffffffff81049ccd>] process_one_work+0x213/0x37b
 [<ffffffff81049c3e>] ? process_one_work+0x184/0x37b
 [<ffffffff8104a16a>] worker_thread+0x138/0x21c
 [<ffffffff8104a032>] ? rescuer_thread+0x1fd/0x1fd
 [<ffffffff8104de3a>] kthread+0xa7/0xaf
 [<ffffffff810744f4>] ? trace_hardirqs_on_caller+0x16/0x166
 [<ffffffff8139d6f4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81395974>] ? retint_restore_args+0x13/0x13
 [<ffffffff8104dd93>] ? __init_kthread_worker+0x5b/0x5b
 [<ffffffff8139d6f0>] ? gs_change+0x13/0x13
Code: 00 88 83 e4 00 00 00 49 8b 84 24 08 01 00 00 c6 43 48 00 48 89 43 50 49 83 7c 24 60 00 74 26 66 41 83 bc 24 d0 00 00 00 00 75 04 <0f> 0b eb fe be 20 00 00 00 48 89 df e8 55 fd ff ff 85 c0 74 2d 
RIP  [<ffffffff81293c06>] scsi_setup_blk_pc_cmnd+0x91/0x11f
 RSP <ffff880117d99b00>
---[ end trace a7919e7f17c0a727 ]---
