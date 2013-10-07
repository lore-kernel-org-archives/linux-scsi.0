From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Mon, 7 Oct 2013 16:44:26 +0200
Message-ID: <20131007144424.GA28054@dhcp-26-207.brq.redhat.com>
References: <51E83E32.9050306@cs.wisc.edu>
 <1374193399.7397.973.camel@haakon3.risingtidesystems.com>
 <20130719003034.GG28005@kernel.dk>
 <1374195825.7397.997.camel@haakon3.risingtidesystems.com>
 <1374215660.7397.1041.camel@haakon3.risingtidesystems.com>
 <1374248000.2266.20.camel@dabdike>
 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
 <51EAA33C.9010405@fusionio.com>
 <20131003110650.GA23454@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131003110650.GA23454@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Mike Christie <mchristie@fusionio.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 03, 2013 at 04:06:51AM -0700, Christoph Hellwig wrote:
> On Sat, Jul 20, 2013 at 09:48:28AM -0500, Mike Christie wrote:
> > What about the attached only compile tested patch. The patch has the mq
> > block code work like the non mq code for bio cleanups.
> > 
> > 
> 
> > blk-mq: blk-mq should free bios in pass through case
> > 
> > For non mq calls, the block layer will free the bios when
> > blk_finish_request is called.
> e 
> > For mq calls, the blk mq code wants the caller to do this.
> > 
> > This patch has the blk mq code work like the non mq code
> > and has the block layer free the bios.
> > 
> > Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> This patch breaks booting for me in the current blk multiqueue tree,
> with an apparent double free of a bio when using virtio-blk in writeback
> mode (cache=writeback or cache=none in qemu):

I am not sure if the root cause the same, but the panic I experience with
mounting a ahci device (and those double-tag usage described in another
thread) is somehow similar:


[  181.184510] general protection fault: 0000 [#1] SMP 
[  181.184546] Modules linked in: lockd sunrpc snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm mperf snd_page_alloc i5000_edac coretemp snd_timer edac_core iTCO_wdt snd kvm_intel iTCO_vendor_support lpc_ich mfd_core igb dca i5k_amb ppdev soundcore hp_wmi tg3 kvm sparse_keymap serio_raw ptp microcode pcspkr rfkill pps_core shpchp parport_pc parport mptsas scsi_transport_sas mptscsih mptbase floppy nouveau video mxm_wmi wmi i2c_algo_bit drm_kms_helper ttm drm i2c_core
[  181.184550] CPU: 6 PID: 0 Comm: swapper/6 Tainted: G        W    3.10.0-rc5.debug+ #180
[  181.184552] Hardware name: Hewlett-Packard HP xw6400 Workstation/0A04h, BIOS 786D4 v02.31 03/14/2008
[  181.184554] task: ffff88007b1a8000 ti: ffff88007b19c000 task.ti: ffff88007b19c000
[  181.184563] RIP: 0010:[<ffffffff811fa97b>]  [<ffffffff811fa97b>] bio_endio+0x1b/0x40
[  181.184565] RSP: 0018:ffff88007d203a28  EFLAGS: 00010002
[  181.184567] RAX: 6b6b6b6b6b6b6b6b RBX: 0000000000000000 RCX: dead000000200200
[  181.184568] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880068e29200
[  181.184570] RBP: ffff88007d203a28 R08: ffffe8ffff201240 R09: 0000000000000000
[  181.184571] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880074d86000
[  181.184572] R13: 6b6b6b6b6b6b6b6b R14: 000000006b6b6b6b R15: 0000000000000001
[  181.184575] FS:  0000000000000000(0000) GS:ffff88007d200000(0000) knlGS:0000000000000000
[  181.184576] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  181.184578] CR2: 00007f8afac8c45c CR3: 000000005f431000 CR4: 00000000000007e0
[  181.184580] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  181.184581] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  181.184582] Stack:
[  181.184587]  ffff88007d203a78 ffffffff813202aa ffff88007d203a98 0000000000000046
[  181.184591]  0000000000000046 ffff880072d08000 0000000000000000 ffff880074d860d8
[  181.184594]  0000000000000000 0000000000000001 ffff88007d203a88 ffffffff81320445
[  181.184595] Call Trace:
[  181.184597]  <IRQ> 
[  181.184603]  [<ffffffff813202aa>] blk_mq_complete_request+0x5a/0x1d0
[  181.184607]  [<ffffffff81320445>] __blk_mq_end_io+0x25/0x30
[  181.184609]  [<ffffffff81320535>] blk_mq_end_io+0xe5/0xf0
[  181.184613]  [<ffffffff81319754>] blk_flush_complete_seq+0xf4/0x360
[  181.184616]  [<ffffffff81319a4b>] ? flush_end_io+0x4b/0x210
[  181.184619]  [<ffffffff81319b2a>] flush_end_io+0x12a/0x210
[  181.184622]  [<ffffffff813202da>] blk_mq_complete_request+0x8a/0x1d0
[  181.184626]  [<ffffffff8147b9fd>] ? scsi_device_unbusy+0x9d/0xd0
[  181.184629]  [<ffffffff81320445>] __blk_mq_end_io+0x25/0x30
[  181.184632]  [<ffffffff81320535>] blk_mq_end_io+0xe5/0xf0
[  181.184635]  [<ffffffff8147cae5>] scsi_mq_end_request+0x15/0x20
[  181.184638]  [<ffffffff8147bf20>] scsi_io_completion+0xa0/0x650
[  181.184643]  [<ffffffff810bbc3d>] ? trace_hardirqs_off+0xd/0x10
[  181.184648]  [<ffffffff814722f7>] scsi_finish_command+0x87/0xe0
[  181.184650]  [<ffffffff8147bccf>] scsi_softirq_done+0x13f/0x160
[  181.184653]  [<ffffffff8147cba5>] scsi_mq_done+0x15/0x20
[  181.184658]  [<ffffffff81495a73>] ata_scsi_qc_complete+0x63/0x470
[  181.184661]  [<ffffffff8148fad0>] __ata_qc_complete+0x90/0x140
[  181.184664]  [<ffffffff8148fc1d>] ata_qc_complete+0x9d/0x230
[  181.184667]  [<ffffffff8148fe51>] ata_qc_complete_multiple+0xa1/0xe0
[  181.184673]  [<ffffffff814aa449>] ahci_handle_port_interrupt+0x109/0x560
[  181.184676]  [<ffffffff814ab63f>] ahci_port_intr+0x2f/0x40
[  181.184678]  [<ffffffff814ab6f1>] ahci_interrupt+0xa1/0x100
[  181.184683]  [<ffffffff810ff7b5>] handle_irq_event_percpu+0x75/0x3d0
[  181.184686]  [<ffffffff810ffb58>] handle_irq_event+0x48/0x70
[  181.184689]  [<ffffffff81102d9e>] ? handle_fasteoi_irq+0x1e/0x100
[  181.184692]  [<ffffffff81102dda>] handle_fasteoi_irq+0x5a/0x100
[  181.184696]  [<ffffffff81004320>] handle_irq+0x60/0x150
[  181.184702]  [<ffffffff816ff846>] ? atomic_notifier_call_chain+0x16/0x20
[  181.184706]  [<ffffffff81705f7a>] do_IRQ+0x5a/0xe0
[  181.184710]  [<ffffffff816fb52f>] common_interrupt+0x6f/0x6f
[  181.184712]  <EOI> 
[  181.184716]  [<ffffffff8100aa45>] ? default_idle+0x25/0x280
[  181.184719]  [<ffffffff8100aa43>] ? default_idle+0x23/0x280
[  181.184722]  [<ffffffff8100b4f6>] arch_cpu_idle+0x26/0x30
[  181.184726]  [<ffffffff810afe66>] cpu_startup_entry+0x96/0x3e0
[  181.184729]  [<ffffffff810b7ad5>] ? clockevents_register_device+0xb5/0x120
[  181.184734]  [<ffffffff816e67ea>] start_secondary+0x27a/0x27c
[  181.184767] Code: 47 c1 c1 ea 03 83 c2 01 39 d0 0f 47 c2 c3 66 90 66 66 66 66 90 55 85 f6 48 89 e5 74 1b f0 80 67 18 fe 48 8b 47 40 48 85 c0 74 02 <ff> d0 5d 66 90 c3 0f 1f 80 00 00 00 00 48 8b 47 18 a8 01 b8 fb 
[  181.184770] RIP  [<ffffffff811fa97b>] bio_endio+0x1b/0x40
[  181.184772]  RSP <ffff88007d203a28>
[  181.184777] ---[ end trace 5e8fd083b8562c3c ]---
[  181.184779] Kernel panic - not syncing: Fatal exception in interrupt
[  181.185483] drm_kms_helper: panic occurred, switching back to text console


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
