From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: 4.15.14 crash with iscsi target and dvd
Date: Sun, 1 Apr 2018 12:24:22 -0400
Message-ID: <20180401162421.GA25011@animx.eu.org>
References: <20180331015903.GA29398@animx.eu.org>
 <CAFLxGvzbA9XzXLsH56iyqYkitrSnBbOzD977u4266=w5zw0jNg@mail.gmail.com>
 <20180331221252.GA25573@animx.eu.org>
 <b68bf187c9cde1c36489fc5ab2187ca8750a1292.camel@wdc.com>
 <20180401113721.GA8471@animx.eu.org>
 <44e142c66ee48606a877af37077f9a6dd8a522dc.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44e142c66ee48606a877af37077f9a6dd8a522dc.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "richard.weinberger@gmail.com" <richard.weinberger@gmail.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "lduncan@suse.com" <lduncan@suse.com>, "cleech@redhat.com" <cleech@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Bart Van Assche wrote:
> On Sun, 2018-04-01 at 07:37 -0400, Wakko Warner wrote:
> > Bart Van Assche wrote:
> > > On Sat, 2018-03-31 at 18:12 -0400, Wakko Warner wrote:
> > > > Richard Weinberger wrote:
> > > > > On Sat, Mar 31, 2018 at 3:59 AM, Wakko Warner <wakko@animx.eu.org> wrote:
> > > > > > I reported this before but noone responded.
> > > > > 
> > > > > Because you're sending only to LKML.
> > > > > CC'ing storage folks.
> > > > 
> > > > Thank you.  I wasn't sure who I needed to send it to.
> > > 
> > > Can you share the output of lsscsi? I would like to know whether or not you
> > > are using a (S)ATA CDROM.
> > 
> > From the target:
> > [4:0:0:0]    cd/dvd  ATAPI    iHAS224   B      GL05  /dev/sr0 
> > [5:0:0:0]    cd/dvd  ATAPI    iHAS422   8      4L11  /dev/sr1 
> > [6:0:0:0]    cd/dvd  PBDS     DVD+-RW DH-16W1S 2D14  /dev/sr2 
> > 
> > From the initiator:
> > [19:0:0:0]   cd/dvd  ATAPI    iHAS224   B      GL05  /dev/sr1
> > [19:0:0:1]   cd/dvd  ATAPI    iHAS422   8      4L11  /dev/sr2
> > [19:0:0:2]   cd/dvd  PBDS     DVD+-RW DH-16W1S 2D14  /dev/sr3
> > 
> > I tested 4.14.32 last night with the same oops.  4.9.91 works fine.
> > From the initiator, if I do cat /dev/sr1 > /dev/null it works.  If I mount
> > /dev/sr1 and then do find -type f | xargs cat > /dev/null the target
> > crashes.  I'm using the builtin iscsi target with pscsi.  I can burn from
> > the initiator with out problems.  I'll test other kernels between 4.9 and
> > 4.14.
> 
> (+Lee and Chris)
> 
> Hello Wakko,
> 
> Although I'm not sure that what I ran into is exactly the same as what you
> ran into, there is definitely something wrong with what I encountered. What
> I ran into with Linus' latest master branch indicates two issues - one in
> the iSCSI initiator and one in the block layer:
> 
> scsi 3:0:0:1: Direct-Access     LIO-ORG  FILEIO           4.0  PQ: 0 ANSI: 5
> sd 2:0:0:1: [sdd] Attached SCSI disk
> sd 3:0:0:1: Warning! Received an indication that the LUN assignments on this
> target have changed. The Linux SCSI layer does not automatical
> sd 3:0:0:1: Attached scsi generic sg8 type 0
> sd 3:0:0:1: [sdf] 128 512-byte logical blocks: (65.5 kB/64.0 KiB)
> sd 3:0:0:1: [sdf] Write Protect is off
> sd 3:0:0:1: [sdf] Mode Sense: 43 00 00 08
> sd 3:0:0:1: [sdf] Write cache: disabled, read cache: enabled, doesn't
> support DPO or FUA
> iSCSI/iqn.1993-08.org.debian:01:3b68b1b3d2eb: Unsupported SCSI Opcode 0xa3,
> sending CHECK_CONDITION.
> sd 3:0:0:2: [sde] Attached SCSI disk
> sd 3:0:0:1: [sdf] Attached SCSI disk
> 
> =====================================================
> WARNING: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected
> 4.16.0-rc7-dbg+ #3 Not tainted
> -----------------------------------------------------
> kworker/6:1H/155 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
>  (&(&session->frwd_lock)->rlock){+.-.}, at: [<000000007eb678ec>]
> iscsi_eh_cmd_timed_out+0x6b/0x5a0 [libiscsi]

[trimmed]

I'm not sure.  Mine happens as 2 oopses.  Both have <IRQ> </IRQ> lines.
The files mine happen in are drivers/scsi/scsi_lib.c followed by
block/blk-core.c

The first one, the stack trace began with <IRQ> then scsi_setup_cmnd.  I
tested 4.10.x, 4.11.x 4.12.x 4.14.x 4.15.x where x is the latest patch
(except for 4.15).  ALL crash.  4.9.91 doesn't.  4.10 added dump_stack
__warn scsi_init_io after <IRQ> and before scsi_setup_cmnd.  Within seconds
of issueing the command to read files, it crashes.  On 4.15, if I just do a
sequential read from the raw device, it doesn't crash.

What do you enable in the kernel to get those locking messages?

> stack backtrace:
> CPU: 6 PID: 155 Comm: kworker/6:1H Not tainted 4.16.0-rc7-dbg+ #3
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> Workqueue: kblockd blk_timeout_work
> Call Trace:
>  dump_stack+0x85/0xc5
>  check_usage+0x6e7/0x700
>  ? check_usage_forwards+0x220/0x220
>  ? find_next_and_bit+0x51/0xe0
>  ? cpumask_next_and+0x20/0x30
>  ? find_busiest_group+0xc94/0x1010
>  ? class_equal+0x11/0x20
>  ? __bfs+0x62/0x2e0
>  ? class_equal+0x11/0x20
>  ? __bfs+0xfb/0x2e0
>  ? __lock_acquire+0x17aa/0x1af0
>  __lock_acquire+0x17aa/0x1af0
>  ? mark_lock+0xc7/0x770
>  ? debug_check_no_locks_freed+0x1b0/0x1b0
>  ? __lock_acquire+0x583/0x1af0
>  ? mark_lock+0xc7/0x770
>  ? lock_pin_lock+0x160/0x160
>  ? debug_check_no_locks_freed+0x1b0/0x1b0
>  ? lock_acquire+0xc9/0x260
>  lock_acquire+0xc9/0x260
>  ? iscsi_eh_cmd_timed_out+0x6b/0x5a0 [libiscsi]
>  _raw_spin_lock+0x2f/0x40
>  ? iscsi_eh_cmd_timed_out+0x6b/0x5a0 [libiscsi]
>  iscsi_eh_cmd_timed_out+0x6b/0x5a0 [libiscsi]
>  scsi_times_out+0xcc/0x3f0 [scsi_mod]
>  blk_rq_timed_out+0x2f/0x70
>  blk_timeout_work+0x1b0/0x220
>  process_one_work+0x446/0xa50
>  ? pwq_dec_nr_in_flight+0x100/0x100
>  ? worker_thread+0x177/0x6d0
>  worker_thread+0x7b/0x6d0
>  ? process_one_work+0xa50/0xa50
>  kthread+0x1b7/0x1e0
>  ? kthread_create_worker_on_cpu+0xc0/0xc0
>  ret_from_fork+0x24/0x30
> 
> [ ... ]
> 
> ------------[ cut here ]------------
> kernel BUG at block/blk-core.c:3267!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> Modules linked in: sd_mod crc32c_generic target_core_pscsi
> target_core_iblock target_core_file iscsi_target_mod target_core_mod brd
> i2c_piix4 sg virtio_balloon i2c_core af_packet button ib_iser rdma_cm iw_cm
> ib_cm ib_core configfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi
> ip_tables x_tables autofs4 hid_generic usbhid hid ext4 crc16 mbcache jbd2
> sr_mod cdrom ata_generic pata_acpi virtio_blk virtio_net ata_piix xhci_pci
> xhci_hcd libata virtio_pci usbcore scsi_mod virtio_ring intel_agp usb_common
> intel_gtt virtio agpgart
> CPU: 2 PID: 151 Comm: scsi_eh_1 Tainted: G        W        4.16.0-rc7-dbg+
> #3
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> RIP: 0010:__blk_end_request_all+0xda/0xe0
> RSP: 0018:ffff88006192f980 EFLAGS: 00010002
> sr 2:0:0:3: rejecting I/O to offline device
> sr 3:0:0:3: rejecting I/O to offline device
> RAX: 0000000000000001 RBX: ffff88006818e780 RCX: ffffffff814065a6
> RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88006818e838
> RBP: 000000000000000a R08: 0000000000000000 R09: 0000000000000012
> R10: ffff88006192f588 R11: 000000005e4786a3 R12: 0000000000000000
> R13: 0000000000000000 R14: ffff880061280160 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff88006d280000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f1fcc53f010 CR3: 00000000666fc000 CR4: 00000000000006e0
> Call Trace:
>  blk_peek_request+0x1ff/0x5f0
>  scsi_request_fn+0x48/0xaf0 [scsi_mod]
>  ? lock_acquire+0xc9/0x260
>  __blk_run_queue+0xc5/0x160
>  blk_run_queue+0x48/0x70
>  scsi_run_queue+0x475/0x5d0 [scsi_mod]
>  ? scsi_io_completion+0x69e/0x980 [scsi_mod]
>  ? sdev_evt_alloc+0x80/0x80 [scsi_mod]
>  ? blk_queue_end_tag+0x10a/0x210
>  ? __list_add_valid+0x29/0xa0
>  ? do_raw_spin_unlock+0x91/0x120
>  scsi_io_completion+0x6a6/0x980 [scsi_mod]
>  ? lock_downgrade+0x200/0x2b0
>  ? scsi_end_request+0x310/0x310 [scsi_mod]
>  ? scsi_device_unbusy+0x3b/0x60 [scsi_mod]
>  scsi_eh_flush_done_q+0x1a6/0x210 [scsi_mod]
>  ata_scsi_port_error_handler+0x794/0xb00 [libata]
>  ata_scsi_error+0x168/0x1a0 [libata]
>  ? ata_scsi_port_error_handler+0xb00/0xb00 [libata]
>  ? _raw_spin_unlock_irqrestore+0x59/0x70
>  scsi_error_handler+0x1b5/0xa40 [scsi_mod]
>  ? scsi_eh_get_sense+0x3b0/0x3b0 [scsi_mod]
>  ? __sched_text_start+0x8/0x8
>  ? __wake_up_common+0x9c/0x230
>  ? mark_held_locks+0x1c/0x90
>  ? _raw_spin_unlock_irqrestore+0x59/0x70
>  ? scsi_eh_get_sense+0x3b0/0x3b0 [scsi_mod]
>  kthread+0x1b7/0x1e0
>  ? kthread_create_worker_on_cpu+0xc0/0xc0
>  ret_from_fork+0x24/0x30
> Code: 85 c0 75 02 0f 0b 48 89 df e8 b3 99 eb ff 4c 8b 23 e9 6e ff ff ff 0f
> 0b eb 82 49 8d 7c 24 20 e8 9d 98 eb ff 45 8b 6c 24 20 eb 8c <0f> 0b 0f 1f 40
> 00 0f 1f 44 00 00 41 57 41 56 41 55 41 54 55 48 
> RIP: __blk_end_request_all+0xda/0xe0 RSP: ffff88006192f980
> ---[ end trace b9c2429e31acedb4 ]---
-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
