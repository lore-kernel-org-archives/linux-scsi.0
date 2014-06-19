From: Theodore Ts'o <tytso@mit.edu>
Subject: BUG: scheduling while atomic in blk_mq codepath?
Date: Thu, 19 Jun 2014 11:35:51 -0400
Message-ID: <20140619153550.GA12836@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

While trying to bisect some problems which were introduced sometime
between 3.15 and 3.16-rc1 (specifically, (1) reads to a block device
at offset 262144 * 4k are failing with a short read, and (2) block
device reads are sometimes causing the entire kernel to hang), the
following BUG got hit.

[    0.000000] Linux version 3.15.0-rc8-06047-gaaeb255 (tytso@closure) (gcc version 4.8.3 (Debian 4.8.3-2) ) #1902 SMP Thu Jun 19 11:16:10 EDT 2014

[....] Checking file systems...fsck from util-linux 2.20.1
/dev/vdg was not cleanly unmounted, check forced.
[    4.161703] BUG: scheduling while atomic: fsck.ext4/2072/0x0000000266.5%    
[    4.163673] no locks held by fsck.ext4/2072.
[    4.164318] Modules linked in:
[    4.164845] CPU: 0 PID: 2072 Comm: fsck.ext4 Not tainted 3.15.0-rc8-06047-gaaeb255 #1902
[    4.166047] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.166917]  00000000 00000000 f52c5ba0 c0832655 f5158610 f52c5bac c082f88a f6501e40
[    4.168188]  f52c5c20 c08362ca c0eb3e40 c0eb3e40 374d3933 00000001 0396a8da 00000000
[    4.169474]  f5158610 f51f1674 f4f46a00 f52c5be4 c015dd4b f4f46a00 f52c5bf0 c015dd5e
[    4.170781] Call Trace:
[    4.171159]  [<c0832655>] dump_stack+0x48/0x60
[    4.171838]  [<c082f88a>] __schedule_bug+0x5c/0x6d
[    4.172572]  [<c08362ca>] __schedule+0x61/0x65a
[    4.173228]  [<c015dd4b>] ? kvm_clock_read+0x1f/0x29
[    4.173977]  [<c015dd5e>] ? kvm_clock_get_cycles+0x9/0xc
[    4.174771]  [<c01b4cb9>] ? timekeeping_get_ns.constprop.14+0x10/0x56
[    4.175701]  [<c0836922>] schedule+0x5f/0x61
[    4.176345]  [<c0836aa2>] io_schedule+0x50/0x67
[    4.177060]  [<c0423b2d>] bt_get+0xaf/0xd1
[    4.177677]  [<c0198282>] ? wake_up_atomic_t+0x1f/0x1f
[    4.178444]  [<c0423bfd>] blk_mq_get_tag+0x26/0x82
[    4.179158]  [<c0420f14>] __blk_mq_alloc_request+0x2a/0x169
[    4.180022]  [<c04222b5>] blk_mq_map_request+0x137/0x1e3
[    4.180825]  [<c0422f89>] blk_sq_make_request+0x82/0x145
[    4.181630]  [<c041a687>] generic_make_request+0x82/0xb5
[    4.182430]  [<c041a7aa>] submit_bio+0xf0/0x109
[    4.183113]  [<c019e97c>] ? trace_hardirqs_on_caller+0x14e/0x169
[    4.184019]  [<c025de72>] _submit_bh+0x1ad/0x1ca
[    4.184661]  [<c025de9e>] submit_bh+0xf/0x11
[    4.185267]  [<c025f5c9>] block_read_full_page+0x1e2/0x1f2
[    4.186073]  [<c025f8cd>] ? I_BDEV+0xa/0xa
[    4.186695]  [<c020ad30>] ? __lru_cache_add+0x24/0x46
[    4.187452]  [<c020af13>] ? lru_cache_add+0xd/0xf
[    4.188130]  [<c025fc04>] blkdev_readpage+0x14/0x16
[    4.188832]  [<c0209adf>] __do_page_cache_readahead+0x1c0/0x1eb
[    4.189704]  [<c0209cb9>] ondemand_readahead+0x1af/0x1b9
[    4.190508]  [<c0209d22>] page_cache_async_readahead+0x5f/0x6a
[    4.191424]  [<c0202370>] generic_file_aio_read+0x226/0x4f4
[    4.192272]  [<c0260841>] blkdev_aio_read+0x90/0x9e
[    4.193017]  [<c02385cd>] do_sync_read+0x52/0x79
[    4.193731]  [<c023857b>] ? fdput_pos+0x25/0x25
[    4.194412]  [<c0238d27>] vfs_read+0x72/0xd1
[    4.195064]  [<c02391da>] SyS_read+0x49/0x7c
[    4.195700]  [<c083a0c9>] syscall_call+0x7/0xb
[    4.196385]  [<c0830000>] ? print_usage_bug+0xcd/0x18e

Is any of these known problems?  This is blocking me from doing any
kind of testing at the moment...  (these problems are showing up while
running KVM using virtio devices).

						- Ted
