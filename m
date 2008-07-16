From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: Tree for July 16 (crash on quad core AMD)
Date: Wed, 16 Jul 2008 18:01:32 -0500
Message-ID: <1216249292.3358.66.camel@localhost.localdomain>
References: <20080716235011.ac9643aa.sfr@canb.auug.org.au>
	 <200807170053.36661.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41187 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755496AbYGPXBi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2008 19:01:38 -0400
In-Reply-To: <200807170053.36661.rjw@sisk.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Testers List <kernel-testers@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>, linux-ide <linux-ide@vger.kernel.org>

On Thu, 2008-07-17 at 00:53 +0200, Rafael J. Wysocki wrote:
> On Wednesday, 16 of July 2008, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since next-20080715:
> > 
> > Temporarily dropped tree: ttydev (it gets too many patch failures).
> > 
> > Most of the differences were conflicts moving from tree to tree as some
> > of the trees are now merged into Linus' tree.  Most have been inflicted
> > on the driver-core and usb trees.  I have not notified these separately.
> > 
> > Because of the moving of conflicts around it is difficult to tell when
> > they are going away (though I assume some are).
> > 
> > The usb.current tree lost its conflict against Linus' tree.
> > 
> > The usb tree gained a conflict against Linus' tree.
> > 
> > The cpus4096 tree gained a conflict against Linus' tree.
> > 
> > The pci tree lost one of its build fix patches.
> > 
> > The i2c tree lost a conflict against Linus' tree.
> > 
> > The ide tree gained a lot of conflicts against Linus' tree because part
> > of it was merged into Linus' tree but the remaining pat modified many of
> > the same files further.
> > 
> > The acpi tree gained a conflict against Linus' tree.
> > 
> > The net tree gained a conflict against each of Linus' tree and the
> > powerpc tree.
> > 
> > The sparc tree gained conflicts against Linus' tree and the ide and
> > sparc-current trees.
> > 
> > The rr tree gained conflict against the net tree.
> > 
> > The semaphore tree gained a conflict against the sparc tree.
> > 
> > The generic-ipi tree gained a conflict against the powerpc tree.
> > 
> > The ttydev series had many patches fail to apply, so it was dropped for
> > today.
> > 
> > I have also applied the following patches for known problems:
> > 
> > 	sparc64: sysdev API change fallout
> > 
> > Patches no longer necessary:
> > 
> > 	s390: fix compile error due to smp_call_function
> > 	powerpc: mman.h export fixups
> > 	powerpc/stacktrace: EXPORT SYMBOL_GPL needs module.h
> > 
> > This tree fails to build for ARCH=sparc (i.e. 32bit) with a 64bit gcc
> > v3.4.5 - it tries to use the 64bit header files.  This may be an artifact
> > of one of my merge fixups, but I don't actually think so.
> > 
> > ----------------------------------------------------------------------------
> 
> Crashes during boot on a box with Phenom X4 and AMD 790-based mainboard.
> AFAICS, the Linus' tree is unaffected and linux-next from yesterday was fine
> on the same box with the same .config.

OK, that means that all the current SCSI patches were merged and it was
still OK (they're all in linus and I haven't put together the next slice
yet).  I'd suspect something in drivers/ata (cc ide list added).

James


> Full dmesg: http://www.sisk.pl/kernel/debug/next/20080716/crash-M3A32-MVP.log
> Kernel config: http://www.sisk.pl/kernel/debug/next/20080716/M3A32-MVP-config
> 
> scsi scan: INQUIRY result too short (5), using 36
> scsi 2:0:0:0: Direct-Access                                    PQ: 0 ANSI: 0
> ------------[ cut here ]------------
> kernel BUG at /home/rafael/src/linux-next/mm/slab.c:2822!
> invalid opcode: 0000 [1] SMP
> last sysfs file:
> CPU 0
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.26-next #51
> RIP: 0010:[<ffffffff802b59e8>]  [<ffffffff802b59e8>] cache_free_debugcheck+0x288/0x2b0
> RSP: 0018:ffff880127c81880  EFLAGS: 00010016
> RAX: 00da9803898590c8 RBX: ffff880127c01880 RCX: 204a483235324448
> RDX: 0000000000da9803 RSI: ffff880124488810 RDI: ffff880127c01880
> RBP: ffff880127c818b0 R08: 0000000000000058 R09: 2222222222222222
> R10: 2222222222222222 R11: 2222222222222222 R12: ffff880124488810
> R13: 09f911029d74e35b R14: 09f911029d74e35b R15: ffff880124488000
> FS:  0000000000000000(0000) GS:ffffffff806b7f40(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff880127c80000, task ffff880127c7e040)
> Stack:  ffffffff803f9bcb ffff880127c01880 ffff880127c0bad0 ffff880124488818
>  0000000000000282 ffff880124460000 ffff880127c818e0 ffffffff802b5c16
>  0000000000000000 0000000000000002 ffffffff80627d9b 0000000000000000
> Call Trace:
>  [<ffffffff803f9bcb>] ? scsi_probe_and_add_lun+0x86b/0xc20
>  [<ffffffff802b5c16>] kfree+0xd6/0x160
>  [<ffffffff803f9bcb>] scsi_probe_and_add_lun+0x86b/0xc20
>  [<ffffffff803fad4f>] __scsi_add_device+0xff/0x110
>  [<ffffffff8040c99b>] ata_scsi_scan_host+0xdb/0x2b0
>  [<ffffffff804094b3>] ata_host_register+0x243/0x2a0
>  [<ffffffff8041b920>] ? ahci_interrupt+0x0/0x530
>  [<ffffffff804095b4>] ata_host_activate+0xa4/0x110
>  [<ffffffff8041b668>] ahci_init_one+0x9a8/0xc60
>  [<ffffffff80378fb9>] pci_device_probe+0x79/0xa0
>  [<ffffffff803e6aab>] driver_probe_device+0x9b/0x1a0
>  [<ffffffff803e6c36>] __driver_attach+0x86/0x90
>  [<ffffffff803e6bb0>] ? __driver_attach+0x0/0x90
>  [<ffffffff803e5ffd>] bus_for_each_dev+0x5d/0x90
>  [<ffffffff803e68ec>] driver_attach+0x1c/0x20
>  [<ffffffff803e6525>] bus_add_driver+0xc5/0x250
>  [<ffffffff803e6e0f>] driver_register+0x5f/0x140
>  [<ffffffff8037927d>] __pci_register_driver+0x7d/0xc0
>  [<ffffffff806f00c0>] ? ahci_init+0x0/0x20
>  [<ffffffff806f00d9>] ahci_init+0x19/0x20
>  [<ffffffff806c8a48>] kernel_init+0x128/0x310
>  [<ffffffff8026167f>] ? trace_hardirqs_on_caller+0xbf/0x150
>  [<ffffffff8026171d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff804ff1eb>] ? _spin_unlock_irq+0x2b/0x40
>  [<ffffffff804fea80>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff8026167f>] ? trace_hardirqs_on_caller+0xbf/0x150
>  [<ffffffff8020c6d9>] child_rip+0xa/0x11
>  [<ffffffff8020bd0f>] ? restore_args+0x0/0x30
>  [<ffffffff806c8920>] ? kernel_init+0x0/0x310
>  [<ffffffff8020c6cf>] ? child_rip+0x0/0x11
> 
> 
> Code: 48 8b 40 10 48 8b 08 f6 c5 40 0f 84 06 fe ff ff 48 8b 40 10 48 8b 08 e9 fa fd ff ff 0f 1f 80 00 00 00 00 0f 0b eb fe 0f 0b eb fe <0f> 0b eb fe 0f 1f 40 00 48
> RIP  [<ffffffff802b59e8>] cache_free_debugcheck+0x288/0x2b0
>  RSP <ffff880127c81880>
> ---[ end trace c69efc8b7b1131cd ]---
> Kernel panic - not syncing: Attempted to kill init!
> Pid: 1, comm: swapper Tainted: G      D   2.6.26-next #51
> 
> Call Trace:
>  [<ffffffff8023c240>] panic+0xa0/0x190
>  [<ffffffff802577f9>] ? up+0x19/0x50
>  [<ffffffff8023d0f7>] ? printk+0x67/0x70
>  [<ffffffff803be042>] ? account+0xc2/0x100
>  [<ffffffff803be1ee>] ? extract_entropy+0x7e/0xa0
>  [<ffffffff8024063f>] do_exit+0x8bf/0x8d0
>  [<ffffffff803be22b>] ? get_random_bytes+0x1b/0x20
>  [<ffffffff8020cbd5>] oops_end+0x85/0x90
>  [<ffffffff8020d84e>] die+0x5e/0x90
>  [<ffffffff8020da30>] do_trap+0x130/0x150
>  [<ffffffff8020e84c>] do_invalid_op+0x9c/0xc0
>  [<ffffffff802b59e8>] ? cache_free_debugcheck+0x288/0x2b0
>  [<ffffffff80311490>] ? sysfs_ilookup_test+0x0/0x20
>  [<ffffffff804fede6>] ? _spin_unlock+0x26/0x30
>  [<ffffffff803e9927>] ? attribute_container_device_trigger+0x27/0xd0
>  [<ffffffff804ff54d>] error_exit+0x0/0xa9
>  [<ffffffff802b59e8>] ? cache_free_debugcheck+0x288/0x2b0
>  [<ffffffff803f9bcb>] ? scsi_probe_and_add_lun+0x86b/0xc20
>  [<ffffffff802b5c16>] kfree+0xd6/0x160
>  [<ffffffff803f9bcb>] scsi_probe_and_add_lun+0x86b/0xc20
>  [<ffffffff803fad4f>] __scsi_add_device+0xff/0x110
>  [<ffffffff8040c99b>] ata_scsi_scan_host+0xdb/0x2b0
>  [<ffffffff804094b3>] ata_host_register+0x243/0x2a0
>  [<ffffffff8041b920>] ? ahci_interrupt+0x0/0x530
>  [<ffffffff804095b4>] ata_host_activate+0xa4/0x110
>  [<ffffffff8041b668>] ahci_init_one+0x9a8/0xc60
>  [<ffffffff80378fb9>] pci_device_probe+0x79/0xa0
>  [<ffffffff803e6aab>] driver_probe_device+0x9b/0x1a0
>  [<ffffffff803e6c36>] __driver_attach+0x86/0x90
>  [<ffffffff803e6bb0>] ? __driver_attach+0x0/0x90
>  [<ffffffff803e5ffd>] bus_for_each_dev+0x5d/0x90
>  [<ffffffff803e68ec>] driver_attach+0x1c/0x20
>  [<ffffffff803e6525>] bus_add_driver+0xc5/0x250
>  [<ffffffff803e6e0f>] driver_register+0x5f/0x140
>  [<ffffffff8037927d>] __pci_register_driver+0x7d/0xc0
>  [<ffffffff806f00c0>] ? ahci_init+0x0/0x20
>  [<ffffffff806f00d9>] ahci_init+0x19/0x20
>  [<ffffffff806c8a48>] kernel_init+0x128/0x310
>  [<ffffffff8026167f>] ? trace_hardirqs_on_caller+0xbf/0x150
>  [<ffffffff8026171d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff804ff1eb>] ? _spin_unlock_irq+0x2b/0x40
>  [<ffffffff804fea80>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff8026167f>] ? trace_hardirqs_on_caller+0xbf/0x150
>  [<ffffffff8020c6d9>] child_rip+0xa/0x11
>  [<ffffffff8020bd0f>] ? restore_args+0x0/0x30
>  [<ffffffff806c8920>] ? kernel_init+0x0/0x310
>  [<ffffffff8020c6cf>] ? child_rip+0x0/0x11
> 
> ------------[ cut here ]------------
> WARNING: at /home/rafael/src/linux-next/kernel/smp.c:288 smp_call_function_mask+0x198/0x1a0()
> Modules linked in:
> Pid: 1, comm: swapper Tainted: G      D   2.6.26-next #51
> 
> Call Trace:
>  [<ffffffff8023beff>] warn_on_slowpath+0x5f/0x80
>  [<ffffffff8020c6cf>] ? child_rip+0x0/0x11
>  [<ffffffff802577f9>] ? up+0x19/0x50
>  [<ffffffff8023d0f7>] ? printk+0x67/0x70
>  [<ffffffff80267f48>] smp_call_function_mask+0x198/0x1a0
>  [<ffffffff8020d063>] ? dump_trace+0x373/0x400
>  [<ffffffff8020d14e>] ? show_trace+0x5e/0x80
>  [<ffffffff80267f6b>] smp_call_function+0x1b/0x20
>  [<ffffffff8021c4f0>] native_smp_send_stop+0x30/0x60
>  [<ffffffff8023c24d>] panic+0xad/0x190
>  [<ffffffff802577f9>] ? up+0x19/0x50
>  [<ffffffff8023d0f7>] ? printk+0x67/0x70
>  [<ffffffff803be042>] ? account+0xc2/0x100
>  [<ffffffff803be1ee>] ? extract_entropy+0x7e/0xa0
>  [<ffffffff8024063f>] do_exit+0x8bf/0x8d0
>  [<ffffffff803be22b>] ? get_random_bytes+0x1b/0x20
>  [<ffffffff8020cbd5>] oops_end+0x85/0x90
>  [<ffffffff8020d84e>] die+0x5e/0x90
>  [<ffffffff8020da30>] do_trap+0x130/0x150
>  [<ffffffff8020e84c>] do_invalid_op+0x9c/0xc0
>  [<ffffffff802b59e8>] ? cache_free_debugcheck+0x288/0x2b0
>  [<ffffffff80311490>] ? sysfs_ilookup_test+0x0/0x20
>  [<ffffffff804fede6>] ? _spin_unlock+0x26/0x30
>  [<ffffffff803e9927>] ? attribute_container_device_trigger+0x27/0xd0
>  [<ffffffff804ff54d>] error_exit+0x0/0xa9
>  [<ffffffff802b59e8>] ? cache_free_debugcheck+0x288/0x2b0
>  [<ffffffff803f9bcb>] ? scsi_probe_and_add_lun+0x86b/0xc20
>  [<ffffffff802b5c16>] kfree+0xd6/0x160
>  [<ffffffff803f9bcb>] scsi_probe_and_add_lun+0x86b/0xc20
>  [<ffffffff803fad4f>] __scsi_add_device+0xff/0x110
>  [<ffffffff8040c99b>] ata_scsi_scan_host+0xdb/0x2b0
>  [<ffffffff804094b3>] ata_host_register+0x243/0x2a0
>  [<ffffffff8041b920>] ? ahci_interrupt+0x0/0x530
>  [<ffffffff804095b4>] ata_host_activate+0xa4/0x110
>  [<ffffffff8041b668>] ahci_init_one+0x9a8/0xc60
>  [<ffffffff80378fb9>] pci_device_probe+0x79/0xa0
>  [<ffffffff803e6aab>] driver_probe_device+0x9b/0x1a0
>  [<ffffffff803e6c36>] __driver_attach+0x86/0x90
>  [<ffffffff803e6bb0>] ? __driver_attach+0x0/0x90
>  [<ffffffff803e5ffd>] bus_for_each_dev+0x5d/0x90
>  [<ffffffff803e68ec>] driver_attach+0x1c/0x20
>  [<ffffffff803e6525>] bus_add_driver+0xc5/0x250
>  [<ffffffff803e6e0f>] driver_register+0x5f/0x140
>  [<ffffffff8037927d>] __pci_register_driver+0x7d/0xc0
>  [<ffffffff806f00c0>] ? ahci_init+0x0/0x20
>  [<ffffffff806f00d9>] ahci_init+0x19/0x20
>  [<ffffffff806c8a48>] kernel_init+0x128/0x310
>  [<ffffffff8026167f>] ? trace_hardirqs_on_caller+0xbf/0x150
>  [<ffffffff8026171d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff804ff1eb>] ? _spin_unlock_irq+0x2b/0x40
>  [<ffffffff804fea80>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff8026167f>] ? trace_hardirqs_on_caller+0xbf/0x150
>  [<ffffffff8020c6d9>] child_rip+0xa/0x11
>  [<ffffffff8020bd0f>] ? restore_args+0x0/0x30
>  [<ffffffff806c8920>] ? kernel_init+0x0/0x310
>  [<ffffffff8020c6cf>] ? child_rip+0x0/0x11
> 
> ---[ end trace c69efc8b7b1131cd ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

