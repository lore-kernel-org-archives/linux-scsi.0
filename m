From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Thu, 3 Oct 2013 04:06:51 -0700
Message-ID: <20131003110650.GA23454@infradead.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51EAA33C.9010405@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <mchristie@fusionio.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Jens Axboe <axboe@kernel.dk>, Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 20, 2013 at 09:48:28AM -0500, Mike Christie wrote:
> What about the attached only compile tested patch. The patch has the mq
> block code work like the non mq code for bio cleanups.
> 
> 

> blk-mq: blk-mq should free bios in pass through case
> 
> For non mq calls, the block layer will free the bios when
> blk_finish_request is called.
e 
> For mq calls, the blk mq code wants the caller to do this.
> 
> This patch has the blk mq code work like the non mq code
> and has the block layer free the bios.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

This patch breaks booting for me in the current blk multiqueue tree,
with an apparent double free of a bio when using virtio-blk in writeback
mode (cache=writeback or cache=none in qemu):

[   15.253608] ------------[ cut here ]------------
[   15.256422] kernel BUG at /work/hch/linux/fs/bio.c:498!
[   15.256879] invalid opcode: 0000 [#1] SMP 
[   15.256879] Modules linked in:
[   15.256879] CPU: 3 PID: 353 Comm: kblockd Not tainted 3.11.0+ #25
[   15.256879] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   15.256879] task: ffff88007d75e0c0 ti: ffff88007d676000 task.ti: ffff88007d676000
[   15.256879] RIP: 0010:[<ffffffff811b470a>]  [<ffffffff811b470a>] bio_put+0x8a/0x90
[   15.256879] RSP: 0018:ffff88007fd83b50  EFLAGS: 00010046
[   15.256879] RAX: 0000000000000000 RBX: ffff88007d713080 RCX: 0000000000000035
[   15.256879] RDX: 0000000000000002 RSI: ffff88007ad50338 RDI: ffff88007d713080
[   15.256879] RBP: ffff88007fd83b60 R08: 7010000000000000 R09: 007ad50338080000
[   15.256879] R10: ff672b1b7d38ce02 R11: 000000000000028b R12: 0000000000000000
[   15.256879] R13: 0000000000000000 R14: ffff88007b4c36c0 R15: ffff88007b40d608
[   15.256879] FS:  0000000000000000(0000) GS:ffff88007fd80000(0000) knlGS:0000000000000000
[   15.256879] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   15.256879] CR2: 0000000000000138 CR3: 0000000002124000 CR4: 00000000000006e0
[   15.256879] Stack:
[   15.256879]  ffff88007d713080 0000000000000000 ffff88007fd83b80 ffffffff811ae8a3
[   15.256879]  ffff88007fd83bf0 0000000000001000 ffff88007fd83b90 ffffffff811b3268
[   15.256879]  ffff88007fd83bc0 ffffffff816ac847 ffff88007b4c36c0 ffff88007fd99d00
[   15.256879] Call Trace:
[   15.256879]  <IRQ> 
[   15.256879]  [<ffffffff811ae8a3>] end_bio_bh_io_sync+0x33/0x50
[   15.256879]  [<ffffffff811b3268>] bio_endio+0x18/0x30
[   15.256879]  [<ffffffff816ac847>] blk_mq_complete_request+0x47/0xd0
[   15.256879]  [<ffffffff816ac8e9>] __blk_mq_end_io+0x19/0x20
[   15.256879]  [<ffffffff816ac958>] blk_mq_end_io+0x68/0xd0
[   15.256879]  [<ffffffff816a6162>] blk_flush_complete_seq+0xe2/0x370
[   15.256879]  [<ffffffff816a653b>] flush_end_io+0x11b/0x200
[   15.256879]  [<ffffffff816ac875>] blk_mq_complete_request+0x75/0xd0
[   15.256879]  [<ffffffff816ac8e9>] __blk_mq_end_io+0x19/0x20
[   15.256879]  [<ffffffff816ac958>] blk_mq_end_io+0x68/0xd0
[   15.256879]  [<ffffffff81844c2f>] virtblk_done+0xef/0x260
[   15.256879]  [<ffffffff81753cc0>] vring_interrupt+0x30/0x60
[   15.256879]  [<ffffffff81103724>] handle_irq_event_percpu+0x54/0x1f0
[   15.256879]  [<ffffffff81103903>] handle_irq_event+0x43/0x70
[   15.256879]  [<ffffffff8110609f>] handle_edge_irq+0x6f/0x120
[   15.256879]  [<ffffffff810445b8>] handle_irq+0x58/0x140
[   15.256879]  [<ffffffff81094bbf>] ? irq_enter+0x4f/0x90
[   15.256879]  [<ffffffff810440b5>] do_IRQ+0x55/0xd0
[   15.256879]  [<ffffffff81bd3972>] common_interrupt+0x72/0x72
[   15.256879]  [<ffffffff810c5135>] ? sched_clock_local+0x25/0xa0
[   15.256879]  [<ffffffff81094960>] ? __do_softirq+0xb0/0x250
[   15.256879]  [<ffffffff81094959>] ? __do_softirq+0xa9/0x250
[   15.256879]  [<ffffffff81094cae>] irq_exit+0xae/0xd0
[   15.256879]  [<ffffffff8106dcd5>] smp_apic_timer_interrupt+0x45/0x60
[   15.256879]  [<ffffffff81bdc772>] apic_timer_interrupt+0x72/0x80
[   15.256879]  <EOI> 
[   15.256879]  [<ffffffff81bd3a33>] ? retint_restore_args+0x13/0x13
[   15.256879]  [<ffffffff81bd3502>] ? _raw_spin_unlock_irq+0x32/0x40
[   15.256879]  [<ffffffff81bd34fb>] ? _raw_spin_unlock_irq+0x2b/0x40
[   15.256879]  [<ffffffff810ac0c4>] rescuer_thread+0xe4/0x2f0
[   15.256879]  [<ffffffff810abfe0>] ? process_scheduled_works+0x40/0x40
[   15.256879]  [<ffffffff810b3916>] kthread+0xd6/0xe0
[   15.256879]  [<ffffffff81bd34fb>] ? _raw_spin_unlock_irq+0x2b/0x40
[   15.256879]  [<ffffffff810b3840>] ? __init_kthread_worker+0x70/0x70
[   15.256879]  [<ffffffff81bdbabc>] ret_from_fork+0x7c/0xb0
[   15.256879]  [<ffffffff810b3840>] ? __init_kthread_worker+0x70/0x70
[   15.256879] Code: ff 41 8b 44 24 08 48 89 df 49 8b 74 24 10 48 29 c7 e8 cb 88 f8 ff 48 8b 5d f0 4c 8b 65 f8 c9 c3 90 48 89 df e8 b8 5c fc ff eb 9b <0f> 0b 0f 1f 40 00 55 48 89 e5 41 57 45 31 ff 41 56 41 55 41 54 
[   15.256879] RIP  [<ffffffff811b470a>] bio_put+0x8a/0x90
[   15.256879]  RSP <ffff88007fd83b50>
[   15.256879] ---[ end trace 1f201608bfddfca7 ]---
[   15.256879] Kernel panic - not syncing: Fatal exception in interrupt
[   15.256879] Shutting down cpus with NMI
