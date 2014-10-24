From: Brian Foster <bfoster@redhat.com>
Subject: Re: virtio_blk - kernel BUG at drivers/virtio/virtio_ring.c:160!
Date: Fri, 24 Oct 2014 13:17:32 -0400
Message-ID: <20141024171731.GA32490@bfoster.bfoster>
References: <20141016151738.GC57207@bfoster.bfoster>
 <20141017132721.GN16538@infradead.org>
 <5446BC7C.9080607@kernel.dk>
 <CACVXFVMkyRb=ZKCzmn28s=MtwJwktWtqgtHh+yQ6WBnYm83OiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbaJXRSB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Oct 2014 13:18:01 -0400
Content-Disposition: inline
In-Reply-To: <CACVXFVMkyRb=ZKCzmn28s=MtwJwktWtqgtHh+yQ6WBnYm83OiQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Linux SCSI List <linux-scsi@vger.kernel.org>

On Wed, Oct 22, 2014 at 08:57:07AM +0800, Ming Lei wrote:
> On Wed, Oct 22, 2014 at 4:05 AM, Jens Axboe <axboe@kernel.dk> wrote:
> > On 10/17/2014 07:27 AM, Christoph Hellwig wrote:
> >> On Thu, Oct 16, 2014 at 11:17:39AM -0400, Brian Foster wrote:
> >>> Hi all,
> >>>
> >>> Hopefully this is the right list for this report...
> >>>
> >>> I hit the following kernel bug reliably by running xfstests test
> >>> generic/234 against XFS using 10GB LVM test/scratch volumes on top of a
> >>> ~100GB virtio_blk block device. The virt block device is file-backed on
> >>> the host.
> >>
> >> Jens, I thought the segment merging bug was fixed a while ago.  Did we
> >> manage to not include parts of it for 3.17?
> >
> > Mings patch went in after 3.17, iirc. Ming?
> 
> Sorry, that patch is wrong[1], attachment patch should fix the issue.
> 

Hi guys,

Thanks for the patch. A couple notes... I went to give this a test and
the kernel from the latest tree (commit 816fb4175c29) doesn't even boot
on my vm due to another BUG()[1].

I commented that BUG() out as an experiment and was able to proceed. As
it is, I can no longer reproduce the original problem on the latest tree
with that single modification, either via generic/234 or a few other of
the generic xfstests. I added the patch below to give that a test (still
with BUG[1] commented out) and I hit yet another bug[2] just attempting
to mount a freshly mkfs'd XFS filesystem.

Brian

[1]

------------[ cut here ]------------
kernel BUG at include/linux/virtio_config.h:125!
invalid opcode: 0000 [#1] SMP 
Modules linked in: virtio_console pvpanic floppy parport snd i2c_piix4 soundcore nfsd auth_rpcgss nfs_acl lockd grace sunrpc qxl drm_kms_helper virtio_blk virtio_net virtio_scsi ttm drm virtio_pci virtio_ring virtio ata_generic pata_acpi
CPU: 1 PID: 51 Comm: kworker/1:1 Not tainted 3.18.0-rc1+ #1
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Workqueue: events control_work_handler [virtio_console]
task: ffff8800daa49a40 ti: ffff880035428000 task.ti: ffff880035428000
RIP: 0010:[<ffffffffa01d8340>]  [<ffffffffa01d8340>] virtio_device_ready.part.9+0x4/0x6 [virtio_console]
RSP: 0000:ffff88003542bc48  EFLAGS: 00010202
RAX: 0000000000000007 RBX: ffff8800da700e00 RCX: 0000000000006e0c
RDX: 000000000000c232 RSI: 0000000000000000 RDI: 000000000001c232
RBP: ffff88003542bc48 R08: ffffffff81fcf420 R09: 0000000000000000
R10: 0000000000000001 R11: ffff8800daa4a6e0 R12: ffff880118313600
R13: 0000000000000001 R14: ffff8800365eb000 R15: ffff8800da700e20
FS:  00007f14a4d9b880(0000) GS:ffff88011b000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f14a2a142a8 CR3: 00000000da18d000 CR4: 00000000000006e0
Stack:
 ffff88003542bcb8 ffffffffa01d78da ffff880000000001 ffffffff811039ed
 ffff88003542bc88 0000000000000292 0000000000000000 000000004a7fbb3c
 ffff88003542bcb8 ffff880035559a80 ffff8801183136b8 ffff880118313610
Call Trace:
 [<ffffffffa01d78da>] add_port+0x40a/0x440 [virtio_console]
 [<ffffffff811039ed>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffa01d7cda>] control_work_handler+0x3ca/0x420 [virtio_console]
 [<ffffffff810c9b1d>] process_one_work+0x20d/0x830
 [<ffffffff810c9a87>] ? process_one_work+0x177/0x830
 [<ffffffff810ca25b>] worker_thread+0x11b/0x490
 [<ffffffff810ca140>] ? process_one_work+0x830/0x830
 [<ffffffff810d03f9>] kthread+0xf9/0x110
 [<ffffffff810e6286>] ? local_clock+0x16/0x30
 [<ffffffff810d0300>] ? kthread_create_on_node+0x250/0x250
 [<ffffffff81848cfc>] ret_from_fork+0x7c/0xb0
 [<ffffffff810d0300>] ? kthread_create_on_node+0x250/0x250
Code: 89 ef e8 14 d6 ff ff 49 89 c4 4d 85 e4 0f 8f 25 ff ff ff eb b0 48 c7 c0 f4 ff ff ff e9 17 ff ff ff e8 45 11 ed e0 90 55 48 89 e5 <0f> 0b 55 48 89 e5 0f 0b 55 48 89 e5 e8 5f e0 ff ff 48 c7 c7 c0 
RIP  [<ffffffffa01d8340>] virtio_device_ready.part.9+0x4/0x6 [virtio_console]
 RSP <ffff88003542bc48>
---[ end trace 2b6f7b706d173ace ]---

[2]

XFS (dm-3): Mounting V4 Filesystem
------------[ cut here ]------------
kernel BUG at drivers/block/virtio_blk.c:172!
invalid opcode: 0000 [#1] SMP 
Modules linked in: xfs libcrc32c xt_conntrack cfg80211 rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm ppdev joydev snd_timer serio_raw virtio_console virtio_balloon snd i2c_piix4 soundcore pvpanic parport_pc parport nfsd auth_rpcgss nfs_acl lockd grace sunrpc virtio_net virtio_blk qxl drm_kms_helper ttm virtio_pci virtio_ring virtio drm ata_generic pata_acpi
CPU: 2 PID: 1152 Comm: mount Not tainted 3.18.0-rc1+ #7
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
task: ffff8800d89d9a30 ti: ffff8800d9ffc000 task.ti: ffff8800d9ffc000
RIP: 0010:[<ffffffffa007c737>]  [<ffffffffa007c737>] virtio_queue_rq+0x277/0x280 [virtio_blk]
RSP: 0018:ffff8800d9fff798  EFLAGS: 00010202
RAX: 0000000000000082 RBX: ffff8800d7152b80 RCX: dead000000200200
RDX: 0000000000000000 RSI: ffff8800d7152b80 RDI: ffff880035c05800
RBP: ffff8800d9fff7d8 R08: ffff8800d7152b80 R09: ffff8800d9fff800
R10: 0000000000000000 R11: ffff8800d89da660 R12: ffff8800d9fff800
R13: ffff880035c05800 R14: ffff8800d818c200 R15: 0000000000000000
FS:  00007f7d544a4840(0000) GS:ffff88011b200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f85265e75e0 CR3: 00000000d949e000 CR4: 00000000000006e0
Stack:
 ffff880000000000 ffff8800d7152cf0 0000000000000002 ffff880035c05800
 ffff8800d9fff800 0000000000000000 ffff8800d7152b80 ffff880035c05848
 ffff8800d9fff848 ffffffff813de0b8 ffff880035c71940 0000000000000001
Call Trace:
 [<ffffffff813de0b8>] __blk_mq_run_hw_queue+0x1c8/0x330
 [<ffffffff813deb00>] blk_mq_run_hw_queue+0x70/0xa0
 [<ffffffff813dfa2d>] blk_mq_insert_requests+0xfd/0x2d0
 [<ffffffff813e09eb>] blk_mq_flush_plug_list+0x13b/0x160
 [<ffffffff813d4451>] blk_flush_plug_list+0xc1/0x240
 [<ffffffff813d4ba8>] blk_finish_plug+0x18/0x50
 [<ffffffffa041e7bd>] _xfs_buf_ioapply+0x32d/0x5e0 [xfs]
 [<ffffffffa04232e4>] ? xfs_bwrite+0x24/0x60 [xfs]
 [<ffffffffa0422341>] xfs_buf_submit_wait+0x91/0x890 [xfs]
 [<ffffffffa04232e4>] xfs_bwrite+0x24/0x60 [xfs]
 [<ffffffffa0455677>] xlog_bwrite+0x87/0x110 [xfs]
 [<ffffffffa0456267>] ? xlog_add_record.isra.10+0xf7/0x160 [xfs]
 [<ffffffffa0456483>] xlog_write_log_records+0x1b3/0x250 [xfs]
 [<ffffffffa0456628>] xlog_clear_stale_blocks+0x108/0x1b0 [xfs]
 [<ffffffffa0455d33>] ? xlog_bread+0x43/0x60 [xfs]
 [<ffffffffa045822b>] xlog_find_tail+0x33b/0x420 [xfs]
 [<ffffffffa045d0dd>] xlog_recover+0x2d/0x130 [xfs]
 [<ffffffffa044bedc>] xfs_log_mount+0x24c/0x2c0 [xfs]
 [<ffffffffa04417ec>] xfs_mountfs+0x48c/0x960 [xfs]
 [<ffffffffa0442d5a>] ? xfs_mru_cache_create+0x18a/0x200 [xfs]
 [<ffffffffa044502a>] xfs_fs_fill_super+0x33a/0x3b0 [xfs]
 [<ffffffff81267d10>] mount_bdev+0x1b0/0x1f0
 [<ffffffffa0444cf0>] ? xfs_parseargs+0xbf0/0xbf0 [xfs]
 [<ffffffffa04430a5>] xfs_fs_mount+0x15/0x20 [xfs]
 [<ffffffff812686b9>] mount_fs+0x39/0x1b0
 [<ffffffff81201435>] ? __alloc_percpu+0x15/0x20
 [<ffffffff81288b3b>] vfs_kern_mount+0x6b/0x150
 [<ffffffff8128bb50>] do_mount+0x230/0xbc0
 [<ffffffff8120bca8>] ? might_fault+0xa8/0xb0
 [<ffffffff811fb62b>] ? memdup_user+0x4b/0x90
 [<ffffffff8128c832>] SyS_mount+0xa2/0x110
 [<ffffffff817e0de9>] system_call_fastpath+0x12/0x17
Code: fe ff ff 90 0f b7 86 f4 00 00 00 c7 86 78 01 00 00 02 00 00 00 48 c7 86 80 01 00 00 00 00 00 00 89 86 7c 01 00 00 e9 12 fe ff ff <0f> 0b 0f 1f 80 00 00 00 00 66 66 66 66 90 55 31 f6 b9 08 00 00 
RIP  [<ffffffffa007c737>] virtio_queue_rq+0x277/0x280 [virtio_blk]
 RSP <ffff8800d9fff798>
---[ end trace a4b47c21da10534d ]---

> [1] http://marc.info/?l=linux-kernel&m=141290430004361&w=2
> 
> 
> Thanks,
> -- 
> Ming Lei

> From dde19549352da3fea516d89bbfa25d08b784e229 Mon Sep 17 00:00:00 2001
> From: Ming Lei <tom.leiming@gmail.com>
> Date: Wed, 22 Oct 2014 08:30:30 +0800
> Subject: [PATCH] blk-merge: recaculate segment if it isn't less than max
>  segments
> 
> The problem is introduced by commit 764f612c6c3c231b(blk-merge:
> don't compute bi_phys_segments from bi_vcnt for cloned bio),
> and merge is needed if number of current segment isn't less than
> max segments.
> 
> Strictly speaking, bio->bi_vcnt shouldn't be used here since
> it may not be accurate in cases of both cloned bio or bio cloned
> from, but bio_segments() is a bit expensive, and bi_vcnt is still
> the biggest number, so the approach should work.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  block/blk-merge.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index ba99351..b3ac40a 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -99,16 +99,17 @@ void blk_recount_segments(struct request_queue *q, struct bio *bio)
>  {
>  	bool no_sg_merge = !!test_bit(QUEUE_FLAG_NO_SG_MERGE,
>  			&q->queue_flags);
> +	bool merge_not_need = bio->bi_vcnt < queue_max_segments(q);
>  
>  	if (no_sg_merge && !bio_flagged(bio, BIO_CLONED) &&
> -			bio->bi_vcnt < queue_max_segments(q))
> +			merge_not_need)
>  		bio->bi_phys_segments = bio->bi_vcnt;
>  	else {
>  		struct bio *nxt = bio->bi_next;
>  
>  		bio->bi_next = NULL;
>  		bio->bi_phys_segments = __blk_recalc_rq_segments(q, bio,
> -				no_sg_merge);
> +				no_sg_merge && merge_not_need);
>  		bio->bi_next = nxt;
>  	}
>  
> -- 
> 1.7.9.5
> 

