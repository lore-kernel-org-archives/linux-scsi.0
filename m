From: Gerald Britton <gbritton@alum.mit.edu>
Subject: Re: [PATCH] cciss: Fix pci_driver.shutdown while device is still active
Date: Mon, 14 May 2007 15:21:06 -0400
Message-ID: <20070514192106.GB19871@zante.sekrit.org>
References: <20070514175301.GA19871@zante.sekrit.org> <226E1C65E4F6164E8EA5FD3CC913AE8C011FF0D8@G3W0639.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eldorado.sekrit.org ([72.5.28.212]:36188 "EHLO
	eldorado.sekrit.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915AbXENTVJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2007 15:21:09 -0400
Content-Disposition: inline
In-Reply-To: <226E1C65E4F6164E8EA5FD3CC913AE8C011FF0D8@G3W0639.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, ISS StorageDev <iss_storagedev@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 07:06:45PM -0000, Miller, Mike (OS Dev) wrote:
> Please send the Oops output.

Sure, here it is, this was built from a clean 2.6.21.1 tree (despite the
-dirty in the kernel version).

				-- Gerald

Unmounting local filesystems...umount: /: device is busy
done.
mount: / is busy
Rebooting... md: stopping all md devices.
p<6>Completed flushing cache on controller 0
BUG: unable to handle kernel NULL pointer dereference<2>EXT3-fs error (device cciss/c0d0p1): ext3_find_entry: reading directory #879553 offset 0
Aborting journal on device cciss/c0d0p1.
Buffer I/O error on device cciss/c0d0p1, logical block 518
lost page write due to I/O error on cciss/c0d0p1
Remounting filesystem read-only
Buffer I/O error on device cciss/c0d0p1, logical block 0
lost page write due to I/O error on cciss/c0d0p1
EXT3-fs error (device cciss/c0d0p1): ext3_find_entry: reading directory #879553 offset 0
EXT3-fs error (device cciss/c0d0p1): ext3_find_entry: reading directory #456065 offset 0
EXT3-fs error (device cciss/c0d0p1): ext3_find_entry: reading directory #879553 offset 0
EXT3-fs error (device cciss/c0d0p1): ext3_find_entry: reading directory #879553 offset 0
EXT3-fs error (device cciss/c0d0p1): ext3_find_entry: reading directory #197834 offset 0
EXT3-fs error (device cciss/c0d0p1): ext3_find_entry: reading directory #197834 offset 0
EXT3-fs error (device cciss/c0d0p1): ext3_find_entry: reading directory #197834 offset 0
EXT3-fs error (device cciss/c0d0p1): ext3_find_entry: reading directory #197834 offset 0
EXT3-fs error (device cciss/c0d0p1): ext3_find_entry: reading directory #197834 offset 0
EXT3-fs error (device cciss/c0d0p1): ext3_find_entry: reading directory #197834 offset 0
EXT3-fs error (device cciss/c0d0p1): ext3_find_entry: reading directory #197834 offset 0
EXT3-fs error (device cciss/c0d0p1): ext3_find_entry: reading directory #293192 offset 0
EXT3-fs error (device cciss/c0d0p1): ext3_find_entry: reading directory #456065 offset 0
 at virtual address 00000024
 printing eip:
c04dbb7e
*pde = 00000000
Oops: 0000 [#1]
SMP
Modules linked in: tun ipv6 pcspkr e1000 bnx2 ipmi_si ipmi_msghandler sg sr_mod cdrom ata_piix ata_generic libata ehci_hcd joydev uhci_hcd ext3 jbd mbcache cciss scsi_mod
CPU:    2
EIP:    0060:[<c04dbb7e>]    Not tainted VLI
EFLAGS: 00010002   (2.6.21.1-dirty #2)
EIP is at elv_completed_request+0x7e/0x90
eax: 00000000   ebx: dfbf3784   ecx: 00000000   edx: f7497d60
esi: dfbf3784   edi: f7497d60   ebp: f7c80000   esp: c07b6f94
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process reboot (pid: 4004, ti=c07b6000 task=dfadba70 task.ti=c1920000)
Stack: f7497d60 dfbf3784 c04df4d8 f7c7b094 00000282 f7497d60 f7c80000 f883b445
       00000001 f7c70000 f7497d68 c07b6fd0 c07add00 c07ac380 c04e0549 c07b6fd0
       c07b6fd0 00000001 c075db20 c0432df4 00000002 0000000a c1920d68 c1920000
Call Trace:
 [<c04df4d8>] __blk_put_request+0x28/0xa0
 [<f883b445>] cciss_softirq_done+0xa5/0x110 [cciss]
 [<c04e0549>] blk_done_softirq+0x59/0x70
 [<c0432df4>] __do_softirq+0xc4/0xe0
 [<c0407199>] do_softirq+0x59/0xd0
 [<c0432eb5>] irq_exit+0x75/0x80
 [<c041d13a>] smp_apic_timer_interrupt+0x2a/0x40
 [<c0405b74>] apic_timer_interrupt+0x28/0x30
 [<c042e5ce>] vprintk+0x1ae/0x290
 [<f883d465>] do_cciss_intr+0x4e5/0x4f0 [cciss]
 [<f883c8ad>] sendcmd+0x8d/0x2b0 [cciss]
 [<c042e417>] printk+0x17/0x20
 [<f883e52d>] cciss_remove_one+0xfd/0x230 [cciss]
 [<c04fa654>] pci_device_shutdown+0x14/0x20
 [<c0570de0>] device_shutdown+0xf0/0x100
 [<c043c14e>] kernel_restart+0xe/0x40
 [<c063c6ac>] lock_kernel+0x1c/0x40
 [<c043c327>] sys_reboot+0xf7/0x1b0
 [<c04606e1>] filemap_nopage+0x211/0x3a0
 [<c046d923>] do_no_page+0x1a3/0x310
 [<c06147b0>] inet_sock_destruct+0xd0/0x210
 [<c063c458>] _spin_lock_bh+0x8/0x20
 [<c04a14be>] invalidate_inode_buffers+0xe/0xb0
 [<c0491835>] dput+0x25/0x150
 [<c0481ebf>] __fput+0x11f/0x190
 [<c04967cb>] mntput_no_expire+0x1b/0x90
 [<c0480483>] filp_close+0x43/0x70
 [<c0480514>] sys_close+0x64/0xb0
 [<c040511c>] syscall_call+0x7/0xb
 =======================
Code: d1 89 d8 31 c9 ba 02 00 00 00 e8 6e 09 00 00 89 d8 ff 53 40 eb bc 8d b4 26 00 00 00 00 ff 8b 44 01 00 00 f6 42 14 04 74 9f 8b 00 <8b> 48 24 85 c9 74 96 89 d8 ff d1 eb 90 90 8d 74 26 00 83 ec 10
EIP: [<c04dbb7e>] elv_completed_request+0x7e/0x90 SS:ESP 0068:c07b6f94
Kernel panic - not syncing: Fatal exception in interrupt
BUG: at /home/gbritton/kernel/linux-2.6/arch/i386/kernel/smp.c:546 smp_call_function()
 [<c041b51e>] smp_call_function+0xfe/0x110
 [<c040617e>] show_registers+0x18e/0x2a0
 [<c0552f24>] do_unblank_screen+0x24/0x150
 [<c041b58b>] smp_send_stop+0x1b/0x30
 [<c042da70>] panic+0x50/0x100
 [<c04064a7>] die+0x1c7/0x220
 [<c063e199>] do_page_fault+0x2a9/0x560
 [<c053fb28>] __add_entropy_words+0x68/0x1b0
 [<c063def0>] do_page_fault+0x0/0x560
 [<c063c794>] error_code+0x7c/0x84
 [<c04dbb7e>] elv_completed_request+0x7e/0x90
 [<c04df4d8>] __blk_put_request+0x28/0xa0
 [<f883b445>] cciss_softirq_done+0xa5/0x110 [cciss]
 [<c04e0549>] blk_done_softirq+0x59/0x70
 [<c0432df4>] __do_softirq+0xc4/0xe0
 [<c0407199>] do_softirq+0x59/0xd0
 [<c0432eb5>] irq_exit+0x75/0x80
 [<c041d13a>] smp_apic_timer_interrupt+0x2a/0x40
 [<c0405b74>] apic_timer_interrupt+0x28/0x30
 [<c042e5ce>] vprintk+0x1ae/0x290
 [<f883d465>] do_cciss_intr+0x4e5/0x4f0 [cciss]
 [<f883c8ad>] sendcmd+0x8d/0x2b0 [cciss]
 [<c042e417>] printk+0x17/0x20
 [<f883e52d>] cciss_remove_one+0xfd/0x230 [cciss]
 [<c04fa654>] pci_device_shutdown+0x14/0x20
 [<c0570de0>] device_shutdown+0xf0/0x100
 [<c043c14e>] kernel_restart+0xe/0x40
 [<c063c6ac>] lock_kernel+0x1c/0x40
 [<c043c327>] sys_reboot+0xf7/0x1b0
 [<c04606e1>] filemap_nopage+0x211/0x3a0
 [<c046d923>] do_no_page+0x1a3/0x310
 [<c06147b0>] inet_sock_destruct+0xd0/0x210
 [<c063c458>] _spin_lock_bh+0x8/0x20
 [<c04a14be>] invalidate_inode_buffers+0xe/0xb0
 [<c0491835>] dput+0x25/0x150
 [<c0481ebf>] __fput+0x11f/0x190
 [<c04967cb>] mntput_no_expire+0x1b/0x90
 [<c0480483>] filp_close+0x43/0x70
 [<c0480514>] sys_close+0x64/0xb0
 [<c040511c>] syscall_call+0x7/0xb
 =======================

