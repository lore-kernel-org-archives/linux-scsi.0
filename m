From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: [PATCH 1/2] virtio: Reduce BUG if total_sg > virtqueue size to
 WARN.
Date: Thu, 10 Aug 2017 22:30:38 +0100
Message-ID: <20170810213038.GC20914@redhat.com>
References: <20170810164035.19963-1-rjones@redhat.com>
 <20170810164035.19963-2-rjones@redhat.com>
 <20170811001447-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170811001447-mutt-send-email-mst@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jasowang@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, hch@lst.de, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 11, 2017 at 12:21:16AM +0300, Michael S. Tsirkin wrote:
> On Thu, Aug 10, 2017 at 05:40:34PM +0100, Richard W.M. Jones wrote:
> > If using indirect descriptors, you can make the total_sg as large as
> > you want.
> 
> That would be a spec violation though, even if it happens to
> work on current QEMU.
> 
> The spec says:
> 	A driver MUST NOT create a descriptor chain longer than the Queue Size of the device.
> 
> What prompted this patch?
> Do we ever encounter this situation?

This patch is needed because the following (2/2) patch will trigger
that BUG_ON if I set virtqueue_size=64 or any smaller value.

The precise backtrace is below.

Rich.

[    4.029510] ------------[ cut here ]------------
[    4.030127] kernel BUG at drivers/virtio/virtio_ring.c:299!
[    4.030834] invalid opcode: 0000 [#1] SMP
[    4.031340] Modules linked in: libcrc32c crc8 crc7 crc4 crc_itu_t virtio_pci virtio_mmio virtio_input virtio_balloon virtio_scsi nd_pmem nd_btt virtio_net virtio_crypto crypto_engine virtio_console virtio_rng virtio_blk virtio_ring virtio nfit crc32_generic crct10dif_pclmul crc32c_intel crc32_pclmul
[    4.034606] CPU: 0 PID: 1 Comm: init Not tainted 4.13.0-rc4+ #100
[    4.035354] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
[    4.036770] task: ffff9a859e243300 task.stack: ffffa731c00cc000
[    4.037506] RIP: 0010:virtqueue_add_sgs+0x23d/0x460 [virtio_ring]
[    4.038250] RSP: 0000:ffffa731c00cf6e0 EFLAGS: 00010097
[    4.038898] RAX: 0000000000000000 RBX: 0000000000000011 RCX: ffffdd0680646c40
[    4.039762] RDX: 0000000000000000 RSI: ffffa731c00cf7b8 RDI: ffff9a85945c4d68
[    4.040634] RBP: ffffa731c00cf748 R08: ffff9a85945c4a78 R09: 0000000001080020
[    4.041508] R10: ffffa731c00cf788 R11: ffff9a859b3d3120 R12: ffffa731c00cf7d0
[    4.042382] R13: ffffa731c00cf7d0 R14: 0000000000000001 R15: ffff9a859b3f8200
[    4.043248] FS:  0000000000000000(0000) GS:ffff9a859e600000(0000) knlGS:0000000000000000
[    4.044232] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.044942] CR2: 00007fcff02e931c CR3: 000000001d23b000 CR4: 00000000003406f0
[    4.045815] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    4.046684] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    4.047559] Call Trace:
[    4.047876]  virtscsi_add_cmd+0x1c9/0x280 [virtio_scsi]
[    4.048528]  virtscsi_kick_cmd+0x38/0x90 [virtio_scsi]
[    4.049161]  virtscsi_queuecommand+0x104/0x280 [virtio_scsi]
[    4.049875]  virtscsi_queuecommand_single+0x38/0x40 [virtio_scsi]
[    4.050628]  scsi_dispatch_cmd+0xf9/0x390
[    4.051128]  scsi_queue_rq+0x5e5/0x6f0
[    4.051602]  blk_mq_dispatch_rq_list+0x1ff/0x3c0
[    4.052175]  blk_mq_sched_dispatch_requests+0x199/0x1f0
[    4.052824]  __blk_mq_run_hw_queue+0x11d/0x1b0
[    4.053382]  __blk_mq_delay_run_hw_queue+0x8d/0xa0
[    4.053972]  blk_mq_run_hw_queue+0x14/0x20
[    4.054485]  blk_mq_sched_insert_requests+0x96/0x120
[    4.055095]  blk_mq_flush_plug_list+0x19d/0x410
[    4.055661]  blk_flush_plug_list+0xf9/0x2b0
[    4.056182]  blk_finish_plug+0x2c/0x40
[    4.056655]  __do_page_cache_readahead+0x32e/0x400
[    4.057261]  filemap_fault+0x2fb/0x890
[    4.057731]  ? filemap_fault+0x2fb/0x890
[    4.058220]  ? find_held_lock+0x3c/0xb0
[    4.058714]  ext4_filemap_fault+0x34/0x50
[    4.059212]  __do_fault+0x1e/0x110
[    4.059644]  __handle_mm_fault+0x6b2/0x1080
[    4.060167]  handle_mm_fault+0x178/0x350
[    4.060662]  __do_page_fault+0x26e/0x510
[    4.061152]  trace_do_page_fault+0x9d/0x290
[    4.061677]  do_async_page_fault+0x51/0xa0
[    4.062189]  async_page_fault+0x28/0x30
[    4.062667] RIP: 0033:0x7fcff030a24f
[    4.063113] RSP: 002b:00007ffefc2ad078 EFLAGS: 00010206
[    4.063760] RAX: 00007fcff02e931c RBX: 00007fcff050f660 RCX: 00007fcff02e935c
[    4.064648] RDX: 0000000000000664 RSI: 0000000000000000 RDI: 00007fcff02e931c
[    4.065519] RBP: 00007ffefc2ad320 R08: 00007fcff02e931c R09: 0000000000027000
[    4.066392] R10: 00007fcff02e9980 R11: 0000000000000206 R12: 00007ffefc2ad0b0
[    4.067263] R13: 00007ffefc2ad408 R14: 0000000000000002 R15: 00000000000087f0
[    4.068135] Code: af 01 c7 45 c8 01 00 00 00 45 31 ed e9 9b fe ff ff 31 db 48 83 7d d0 00 0f 85 3f fe ff ff 0f 0b 48 8b 7d b8 e8 e5 fd 22 de eb 8b <0f> 0b 0f 0b 44 89 6d a8 45 89 f5 48 8b 45 a0 44 8d 70 01 48 83 
[    4.070506] RIP: virtqueue_add_sgs+0x23d/0x460 [virtio_ring] RSP: ffffa731c00cf6e0
[    4.071434] ---[ end trace 02532659840e2a64 ]---


-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
libguestfs lets you edit virtual machines.  Supports shell scripting,
bindings from many languages.  http://libguestfs.org
