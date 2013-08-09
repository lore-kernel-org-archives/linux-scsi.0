From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Fri, 09 Aug 2013 13:17:37 -0700
Message-ID: <1376079457.5171.172.camel@haakon3.risingtidesystems.com>
References: <1374173515.7397.948.camel@haakon3.risingtidesystems.com>
	 <51E83E32.9050306@cs.wisc.edu>
	 <1374193399.7397.973.camel@haakon3.risingtidesystems.com>
	 <20130719003034.GG28005@kernel.dk>
	 <1374195825.7397.997.camel@haakon3.risingtidesystems.com>
	 <1374215660.7397.1041.camel@haakon3.risingtidesystems.com>
	 <1374248000.2266.20.camel@dabdike>
	 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
	 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
	 <51EAA33C.9010405@fusionio.com>
	 <20130809191542.GD25306@dhcp-26-207.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20130809191542.GD25306@dhcp-26-207.brq.redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Mike Christie <mchristie@fusionio.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-08-09 at 21:15 +0200, Alexander Gordeev wrote:
> On Sat, Jul 20, 2013 at 09:48:28AM -0500, Mike Christie wrote:
> > What about the attached only compile tested patch. The patch has the mq
> > block code work like the non mq code for bio cleanups.
> 
> Not sure if it is related to the patch or not, but it never returns from
> wait_for_completion_io(&wait) in blkdev_issue_flush():
> 
> # ps axl | awk '$10 ~ /D\+/'
> 4     0   938   879  20   0 111216   656 blkdev D+   pts/1      0:00 fdisk/dev/sda
> #
> # cat /proc/938/stack
> [<ffffffff812a8a5c>] blkdev_issue_flush+0xfc/0x160
> [<ffffffff811ac606>] blkdev_fsync+0x96/0xc0
> [<ffffffff811a2f4d>] do_fsync+0x5d/0x90
> [<ffffffff811a3330>] SyS_fsync+0x10/0x20
> [<ffffffff81611582>] system_call_fastpath+0x16/0x1b
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Any ideas?
> 

Mmmm, I'm able to reproduce over here with ahci + scsi-mq, and it
appears to be a bug related with using sdev->sdev_md_req.queue_depth=1,
that ends up causing the blkdev_issue_flush() to wait forever because
blk_mq_wait_for_tags() never ends up getting the single tag back for the
WRITE_FLUSH bio -> SYNCHRONIZE_CACHE cdb.

Here's the echo w > /proc/sysrq-trigger output:

[  282.620140] SysRq : Show Blocked State
[  282.620958]   task                        PC stack   pid father
[  282.622228] kworker/2:1H    D 0000000000000002     0   532      2 0x00000000
[  282.623607] Workqueue: kblockd mq_flush_work
[  282.624027]  ffff880037869c98 0000000000000046 ffff880037868010 0000000000011380
[  282.624027]  ffff88007d255910 0000000000011380 ffff880037869fd8 0000000000011380
[  282.624027]  ffff880037869fd8 0000000000011380 ffff88007d06f0d0 ffff88007d255910
[  282.624027] Call Trace:
[  282.624027]  [<ffffffff8125b4fd>] ? do_rw_taskfile+0x2ab/0x2bf
[  282.624027]  [<ffffffff810235c4>] ? kvm_clock_read+0x1f/0x21
[  282.624027]  [<ffffffff81054fbc>] ? update_curr+0x4f/0xcd
[  282.624027]  [<ffffffff810235c4>] ? kvm_clock_read+0x1f/0x21
[  282.624027]  [<ffffffff810235cf>] ? kvm_clock_get_cycles+0x9/0xb
[  282.624027]  [<ffffffff81383946>] schedule+0x5f/0x61
[  282.624027]  [<ffffffff813839cf>] io_schedule+0x87/0xca
[  282.624027]  [<ffffffff81192402>] wait_on_tags+0x10f/0x146
[  282.624027]  [<ffffffff81192462>] blk_mq_wait_for_tags+0x29/0x3b
[  282.624027]  [<ffffffff8119132d>] blk_mq_alloc_request_pinned+0xcf/0xe5
[  282.624027]  [<ffffffff811913a6>] blk_mq_alloc_request+0x2d/0x34
[  282.624027]  [<ffffffff8118c60f>] mq_flush_work+0x1a/0x3d
[  282.624027]  [<ffffffff8104474b>] process_one_work+0x257/0x368
[  282.624027]  [<ffffffff81044a4a>] worker_thread+0x1ee/0x34b
[  282.624027]  [<ffffffff8104485c>] ? process_one_work+0x368/0x368
[  282.624027]  [<ffffffff81049771>] kthread+0xb0/0xb8
[  282.624027]  [<ffffffff810496c1>] ? kthread_freezable_should_stop+0x60/0x60
[  282.624027]  [<ffffffff8138a07c>] ret_from_fork+0x7c/0xb0
[  282.624027]  [<ffffffff810496c1>] ? kthread_freezable_should_stop+0x60/0x60
[  282.624027] fdisk           D 0000000000000002     0  1947   1930 0x00000000
[  282.624027]  ffff880037bd9d48 0000000000000082 ffff880037bd8010 0000000000011380
[  282.624027]  ffff88007ca223a0 0000000000011380 ffff880037bd9fd8 0000000000011380
[  282.624027]  ffff880037bd9fd8 0000000000011380 ffff88007d06bb60 ffff88007ca223a0
[  282.624027] Call Trace:
[  282.624027]  [<ffffffff813835e8>] ? __schedule+0x687/0x726
[  282.624027]  [<ffffffff81383946>] schedule+0x5f/0x61
[  282.624027]  [<ffffffff81381d18>] schedule_timeout+0x24/0x183
[  282.624027]  [<ffffffff810235c4>] ? kvm_clock_read+0x1f/0x21
[  282.624027]  [<ffffffff810235cf>] ? kvm_clock_get_cycles+0x9/0xb
[  282.624027]  [<ffffffff8105d2bd>] ? ktime_get_ts+0x53/0xc7
[  282.624027]  [<ffffffff81382e01>] io_schedule_timeout+0x93/0xe4
[  282.624027]  [<ffffffff81051fc7>] ? __cond_resched+0x25/0x31
[  282.624027]  [<ffffffff81383c46>] T.1554+0x8e/0xfc
[  282.624027]  [<ffffffff81054159>] ? try_to_wake_up+0x222/0x222
[  282.624027]  [<ffffffff81383cc7>] wait_for_completion_io+0x13/0x15
[  282.624027]  [<ffffffff8118cbde>] blkdev_issue_flush+0xfb/0x145
[  282.624027]  [<ffffffff810f067a>] blkdev_fsync+0x30/0x3d
[  282.624027]  [<ffffffff810e9259>] vfs_fsync_range+0x18/0x21
[  282.624027]  [<ffffffff810e9279>] vfs_fsync+0x17/0x19
[  282.624027]  [<ffffffff810e942e>] do_fsync+0x35/0x53
[  282.624027]  [<ffffffff810d5574>] ? SyS_ioctl+0x47/0x69
[  282.624027]  [<ffffffff810e9469>] SyS_fsync+0xb/0xf
[  282.624027]  [<ffffffff8138a129>] system_call_fastpath+0x16/0x1b
[  282.624027] blkid           D 0000000000000001     0  1952      1 0x00000000
[  282.679428]  ffff8800371638a8 0000000000000082 ffff880037162010 0000000000011380
[  282.679428]  ffff88007ca205f0 0000000000011380 ffff880037163fd8 0000000000011380
[  282.679428]  ffff880037163fd8 0000000000011380 ffff88007d06b570 ffff88007ca205f0
[  282.679428] Call Trace:
[  282.679428]  [<ffffffff810677a9>] ? generic_exec_single+0x75/0x93
[  282.679428]  [<ffffffff8119212a>] ? blk_mq_tag_busy_iter+0x116/0x116
[  282.679428]  [<ffffffff8106797f>] ? smp_call_function_single+0xf9/0x111
[  282.679428]  [<ffffffff81383946>] schedule+0x5f/0x61
[  282.679428]  [<ffffffff813839cf>] io_schedule+0x87/0xca
[  282.679428]  [<ffffffff81192402>] wait_on_tags+0x10f/0x146
[  282.679428]  [<ffffffff81192462>] blk_mq_wait_for_tags+0x29/0x3b
[  282.679428]  [<ffffffff8119132d>] blk_mq_alloc_request_pinned+0xcf/0xe5
[  282.679428]  [<ffffffff811916b9>] blk_mq_make_request+0x14d/0x2dc
[  282.679428]  [<ffffffff810978c4>] ? mempool_alloc_slab+0x10/0x12
[  282.679428]  [<ffffffff8118951e>] generic_make_request+0x9c/0xdf
[  282.679428]  [<ffffffff81189648>] submit_bio+0xe7/0xf2
[  282.679428]  [<ffffffff810eaaeb>] _submit_bh+0x1b0/0x1d3
[  282.679428]  [<ffffffff810eab19>] submit_bh+0xb/0xd
[  282.679428]  [<ffffffff810ed6e5>] block_read_full_page+0x24d/0x26d
[  282.679428]  [<ffffffff810ef905>] ? I_BDEV+0xd/0xd
[  282.679428]  [<ffffffff810a7624>] ? __inc_zone_page_state+0x1e/0x20
[  282.679428]  [<ffffffff81096188>] ? add_to_page_cache_locked+0x78/0xb0
[  282.679428]  [<ffffffff810f04a5>] blkdev_readpage+0x13/0x15
[  282.679428]  [<ffffffff8109de8d>] __do_page_cache_readahead+0x194/0x1d0
[  282.679428]  [<ffffffff81381f41>] ? __wait_on_bit_lock+0x79/0x8a
[  282.679428]  [<ffffffff8109df50>] force_page_cache_readahead+0x67/0x8d
[  282.679428]  [<ffffffff8109e29a>] page_cache_sync_readahead+0x26/0x3a
[  282.679428]  [<ffffffff81097510>] generic_file_aio_read+0x265/0x5cd
[  282.679428]  [<ffffffff810efaae>] blkdev_aio_read+0x57/0x5e
[  282.679428]  [<ffffffff810c6b8d>] do_sync_read+0x79/0x9f
[  282.679428]  [<ffffffff810c7db7>] vfs_read+0xab/0x130
[  282.679428]  [<ffffffff810c7f06>] SyS_read+0x4f/0x79
[  282.679428]  [<ffffffff8138a129>] system_call_fastpath+0x16/0x1b
[  282.679428] blkid           D 0000000000000003     0  1992    927 0x00000000
[  282.679428]  ffff88007848f8a8 0000000000000086 ffff88007848e010 0000000000011380
[  282.679428]  ffff88007d250000 0000000000011380 ffff88007848ffd8 0000000000011380
[  282.679428]  ffff88007848ffd8 0000000000011380 ffff88007d06c150 ffff88007d250000
[  282.679428] Call Trace:
[  282.679428]  [<ffffffff8109b9b6>] ? __alloc_pages_nodemask+0xf7/0x5eb
[  282.679428]  [<ffffffff81383946>] schedule+0x5f/0x61
[  282.679428]  [<ffffffff813839cf>] io_schedule+0x87/0xca
[  282.679428]  [<ffffffff81192402>] wait_on_tags+0x10f/0x146
[  282.679428]  [<ffffffff81192462>] blk_mq_wait_for_tags+0x29/0x3b
[  282.679428]  [<ffffffff8119132d>] blk_mq_alloc_request_pinned+0xcf/0xe5
[  282.679428]  [<ffffffff811916b9>] blk_mq_make_request+0x14d/0x2dc
[  282.679428]  [<ffffffff8118d81f>] ? create_task_io_context+0xa6/0xf5
[  282.679428]  [<ffffffff8118951e>] generic_make_request+0x9c/0xdf
[  282.679428]  [<ffffffff81189648>] submit_bio+0xe7/0xf2
[  282.679428]  [<ffffffff810eaaeb>] _submit_bh+0x1b0/0x1d3
[  282.679428]  [<ffffffff810eab19>] submit_bh+0xb/0xd
[  282.679428]  [<ffffffff810ed6e5>] block_read_full_page+0x24d/0x26d
[  282.679428]  [<ffffffff810ef905>] ? I_BDEV+0xd/0xd
[  282.679428]  [<ffffffff810f04a5>] blkdev_readpage+0x13/0x15
[  282.679428]  [<ffffffff8109de8d>] __do_page_cache_readahead+0x194/0x1d0
[  282.679428]  [<ffffffff8109df50>] force_page_cache_readahead+0x67/0x8d
[  282.679428]  [<ffffffff8109e29a>] page_cache_sync_readahead+0x26/0x3a
[  282.679428]  [<ffffffff81097510>] generic_file_aio_read+0x265/0x5cd
[  282.679428]  [<ffffffff810efaae>] blkdev_aio_read+0x57/0x5e
[  282.679428]  [<ffffffff810c6b8d>] do_sync_read+0x79/0x9f
[  282.679428]  [<ffffffff810c7db7>] vfs_read+0xab/0x130
[  282.679428]  [<ffffffff810c7f06>] SyS_read+0x4f/0x79
[  282.679428]  [<ffffffff8138a129>] system_call_fastpath+0x16/0x1b

Bumping queue_depth=2 seems to work-around the issue, but AFAICT it's a
genuine tag starvation bug with queue_depth=1 and WRITE_FLUSH..

--nab

