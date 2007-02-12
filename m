From: Oliver Paulus <oliver@code-project.org>
Subject: Fwd: kernel oops SCSI tape drive access kernel 2.6.18
Date: Mon, 12 Feb 2007 20:47:52 +0100
Message-ID: <20070212204752.kkm3rcnvlk84kg4g@raudies.homeip.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=_el4yyi043u0"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-out1.kundencontroller.de ([85.31.185.13]:45234 "EHLO
	mail-out1.kundencontroller.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965358AbXBLTzr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Feb 2007 14:55:47 -0500
Received: from david (p57A6C75F.dip.t-dialin.net [87.166.199.95])
	by mail-out1.kundencontroller.de (Postfix) with ESMTP id 9E46A23827
	for <linux-scsi@vger.kernel.org>; Mon, 12 Feb 2007 20:55:46 +0100 (CET)
Received: from localhost ([127.0.0.1])
	by david with esmtp  id 1HGh9V-0000dm-1J
	for linux-scsi@vger.kernel.org; Mon, 12 Feb 2007 20:47:57 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This message is in MIME format.

--=_el4yyi043u0
Content-Type: text/plain;
	charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Hello,

I get a kernel oops if I want to read from my SCSI HP tape (C5683A) drive -
using tar command.

Here my system information:
1. Kernel: 2.6.18-3-vserver-amd64
2. OS: Debian Etch

Here my lspci output:
00:00.0 Host bridge: VIA Technologies, Inc. K8M890CE Host Bridge
00:00.1 Host bridge: VIA Technologies, Inc. K8M890CE Host Bridge
00:00.2 Host bridge: VIA Technologies, Inc. K8M890CE Host Bridge
00:00.3 Host bridge: VIA Technologies, Inc. K8M890CE Host Bridge
00:00.4 Host bridge: VIA Technologies, Inc. K8M890CE Host Bridge
00:00.5 PIC: VIA Technologies, Inc. K8M890CE I/O APIC Interrupt Controller
00:00.7 Host bridge: VIA Technologies, Inc. K8M890CE Host Bridge
00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI bridge [K8T800/K8T890
South]
00:02.0 PCI bridge: VIA Technologies, Inc. K8T890 PCI to PCI Bridge Controller
00:03.0 PCI bridge: VIA Technologies, Inc. K8T890 PCI to PCI Bridge Controller
00:0f.0 IDE interface: VIA Technologies, Inc. VT8237A SATA 2-Port Controller
(rev 80)
00:0f.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 07)
00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
(rev a0)
00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
(rev a0)
00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
(rev a0)
00:10.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
(rev a0)
00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86)
00:11.0 ISA bridge: VIA Technologies, Inc. VT8237A PCI to ISA Bridge
00:11.7 Host bridge: VIA Technologies, Inc. VT8251 Ultra VLINK Controller
00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev 7c)
00:13.0 PCI bridge: VIA Technologies, Inc. VT8237A Host Bridge
00:13.1 PCI bridge: VIA Technologies, Inc. VT8237A PCI to PCI Bridge
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address
Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM
Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Miscellaneous Control
01:00.0 VGA compatible controller: VIA Technologies, Inc. Unknown device 3230
(rev 11)
04:01.0 Audio device: VIA Technologies, Inc. VIA High Definition Audio
Controller (rev 10)
05:05.0 SCSI storage controller: Adaptec AHA-2940U/UW/D / AIC-7881U (rev 01)

Here my SCSI info:
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: SAMSUNG SP2504C  Rev: VT10
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: SAMSUNG SP2504C  Rev: VT10
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 06 Lun: 00
  Vendor: HP       Model: C5683A           Rev: C305
  Type:   Sequential-Access                ANSI SCSI revision: 03

I get a kernel oops if I want to access the /dev/st0 with tar (or mondorescue
restore - because this program uses tar too). Here the oops info:
Feb  8 20:15:35 hal9000 kernel: st0: Block limits 1 - 16777215 bytes.
Feb  8 20:15:56 hal9000 kernel: Unable to handle kernel paging request at
ffff82bc8057b000 RIP:
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020748b>] kmem_cache_free+0x42/0x1bb
Feb  8 20:15:56 hal9000 kernel: PGD 0
Feb  8 20:15:56 hal9000 kernel: Oops: 0000 [13] SMP
Feb  8 20:15:56 hal9000 kernel: CPU 0
Feb  8 20:15:56 hal9000 kernel: Modules linked in: usb_storage cdc_acm ipv6
dm_snapshot dm_mirror dm_mod loop snd_hda_intel snd_hda_codec serio_raw snd_pcm
snd_timer snd soundcore snd_page_alloc pcspkr psmouse shpchp pci_hotplug st
joydev evdev ext3 jbd mbcache raid1 md_mod ide_generic sd_mod ide_cd cdrom
usbhid aic7xxx scsi_transport_spi via_rhine mii ehci_hcd sata_via via82cxxx
uhci_hcd libata scsi_mod generic ide_core processor
Feb  8 20:15:56 hal9000 kernel: Pid: 16448, comm: tar Not tainted
2.6.18-3-vserver-amd64 #1
Feb  8 20:15:56 hal9000 kernel: RIP: 0010:[<ffffffff8020748b>]
[<ffffffff8020748b>] kmem_cache_free+0x42/0x1bb
Feb  8 20:15:56 hal9000 kernel: RSP: 0018:ffff8100155a5ca8  EFLAGS: 00010286
Feb  8 20:15:56 hal9000 kernel: RAX: ffff82bc8057b000 RBX: ffff81001a4ae1c0 RCX:
000000000000003f
Feb  8 20:15:56 hal9000 kernel: RDX: ffff82bc8057b000 RSI: 0000000000000000 RDI:
00000007f0000000
Feb  8 20:15:56 hal9000 kernel: RBP: ffff8100010fae00 R08: 0000000000000000 R09:
0000000000000400
Feb  8 20:15:56 hal9000 kernel: R10: ffff810016b96748 R11: ffffffff80242899 R12:
0000000000000000
Feb  8 20:15:56 hal9000 kernel: R13: ffff81001bed71c0 R14: 0000000000001000 R15:
ffff810016b96748
Feb  8 20:15:56 hal9000 kernel: FS:  00002b7bfb7f46d0(0000)
GS:ffffffff8052f000(0000) knlGS:0000000000000000
Feb  8 20:15:56 hal9000 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Feb  8 20:15:56 hal9000 kernel: CR2: ffff82bc8057b000 CR3: 0000000010c2a000 CR4:
00000000000006e0
Feb  8 20:15:56 hal9000 kernel: Process tar (pid: 16448[#0], threadinfo
ffff8100155a4000, task ffff810005696880)
Feb  8 20:15:56 hal9000 kernel: Stack:  ffff810003a64d28 0000000000000000
ffff81001a4ae1c0 ffff8100010fae00
Feb  8 20:15:56 hal9000 kernel:  0000000000000000 ffff81001a4ae1c0
0000000000001000 ffffffff8023fd8d
Feb  8 20:15:56 hal9000 kernel:  ffff81001a4ae1c0 0000000000001000
ffff810003a64d28 ffffffff8803a3e9
Feb  8 20:15:56 hal9000 kernel: Call Trace:
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8023fd8d>] bio_free+0x33/0x43
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8803a3e9>]
:scsi_mod:scsi_execute_async+0x18a/0x3ac
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff802b5f20>] get_user_pages+0x2f1/0x34f
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8816fbba>] :st:st_do_scsi+0x1ca/0x225
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8816f52d>] :st:st_sleep_done+0x0/0x45
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff88171c01>] :st:st_read+0x338/0x818
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020b1c9>] vfs_read+0xcb/0x171
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020fff8>] sys_read+0x45/0x6e
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8025ab0e>] system_call+0x7e/0x83
Feb  8 20:15:56 hal9000 kernel:
Feb  8 20:15:56 hal9000 kernel:
Feb  8 20:15:56 hal9000 kernel: Code: 8b 00 f6 c4 40 74 04 48 8b 52 10 8b 02 84
c0 78 0a 0f 0b 68
Feb  8 20:15:56 hal9000 kernel: RIP  [<ffffffff8020748b>]
kmem_cache_free+0x42/0x1bb
Feb  8 20:15:56 hal9000 kernel:  RSP <ffff8100155a5ca8>
Feb  8 20:15:56 hal9000 kernel: CR2: ffff82bc8057b000
Feb  8 20:15:56 hal9000 kernel:  BUG: warning at
drivers/scsi/st.c:2513/st_int_ioctl()
Feb  8 20:15:56 hal9000 kernel:
Feb  8 20:15:56 hal9000 kernel: Call Trace:
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8817016c>]
:st:st_int_ioctl+0x52/0x98c
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff881725b4>] :st:st_flush+0x245/0x25e
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80222685>] filp_close+0x36/0x64
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80237ed4>] put_files_struct+0x6c/0xe4
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80213ad9>] do_exit+0x259/0x948
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80365fc8>] set_palette+0x9/0x5b
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8032dd7e>]
vgacon_set_cursor_size+0x36/0xdb
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020abbb>] do_page_fault+0x68b/0x706
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80221c7d>] mempool_alloc+0x24/0xda
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8025b7dd>] error_exit+0x0/0x84
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80242899>] mempool_free_slab+0x0/0xe
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020748b>] kmem_cache_free+0x42/0x1bb
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80207488>] kmem_cache_free+0x3f/0x1bb
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8023fd8d>] bio_free+0x33/0x43
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8803a3e9>]
:scsi_mod:scsi_execute_async+0x18a/0x3ac
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff802b5f20>] get_user_pages+0x2f1/0x34f
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8816fbba>] :st:st_do_scsi+0x1ca/0x225
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8816f52d>] :st:st_sleep_done+0x0/0x45
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff88171c01>] :st:st_read+0x338/0x818
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020b1c9>] vfs_read+0xcb/0x171
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020fff8>] sys_read+0x45/0x6e
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8025ab0e>] system_call+0x7e/0x83
Feb  8 20:15:56 hal9000 kernel:
Feb  8 20:15:56 hal9000 kernel: Unable to handle kernel paging request at
ffff82bc8057b000 RIP:
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020748b>] kmem_cache_free+0x42/0x1bb
Feb  8 20:15:56 hal9000 kernel: PGD 0
Feb  8 20:15:56 hal9000 kernel: Oops: 0000 [14] SMP
Feb  8 20:15:56 hal9000 kernel: CPU 0
Feb  8 20:15:56 hal9000 kernel: Modules linked in: usb_storage cdc_acm ipv6
dm_snapshot dm_mirror dm_mod loop snd_hda_intel snd_hda_codec serio_raw snd_pcm
snd_timer snd soundcore snd_page_alloc pcspkr psmouse shpchp pci_hotplug st
joydev evdev ext3 jbd mbcache raid1 md_mod ide_generic sd_mod ide_cd cdrom
usbhid aic7xxx scsi_transport_spi via_rhine mii ehci_hcd sata_via via82cxxx
uhci_hcd libata scsi_mod generic ide_core processor
Feb  8 20:15:56 hal9000 kernel: Pid: 16448, comm: tar Not tainted
2.6.18-3-vserver-amd64 #1
Feb  8 20:15:56 hal9000 kernel: RIP: 0010:[<ffffffff8020748b>]
[<ffffffff8020748b>] kmem_cache_free+0x42/0x1bb
Feb  8 20:15:56 hal9000 kernel: RSP: 0018:ffff8100155a5818  EFLAGS: 00010286
Feb  8 20:15:56 hal9000 kernel: RAX: ffff82bc8057b000 RBX: ffff81001a4ae540 RCX:
000000000000003f
Feb  8 20:15:56 hal9000 kernel: RDX: ffff82bc8057b000 RSI: 0000000000000000 RDI:
00000007f0000000
Feb  8 20:15:56 hal9000 kernel: RBP: ffff8100010fae00 R08: 0000000000000000 R09:
0000000000000400
Feb  8 20:15:56 hal9000 kernel: R10: ffff810016b96f28 R11: ffffffff80242899 R12:
0000000000000000
Feb  8 20:15:56 hal9000 kernel: R13: ffff81001bed71c0 R14: 0000000000001000 R15:
ffff810016b96f28
Feb  8 20:15:56 hal9000 kernel: FS:  00002b7bfb7f46d0(0000)
GS:ffffffff8052f000(0000) knlGS:0000000000000000
Feb  8 20:15:56 hal9000 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Feb  8 20:15:56 hal9000 kernel: CR2: ffff82bc8057b000 CR3: 000000001b8fe000 CR4:
00000000000006e0
Feb  8 20:15:56 hal9000 kernel: Process tar (pid: 16448[#0], threadinfo
ffff8100155a4000, task ffff810005696880)
Feb  8 20:15:56 hal9000 kernel: Stack:  ffff81001aff7068 0000000000000000
ffff81001a4ae540 ffff8100010fae00
Feb  8 20:15:56 hal9000 kernel:  0000000000000000 ffff81001a4ae540
0000000000001000 ffffffff8023fd8d
Feb  8 20:15:56 hal9000 kernel:  ffff81001a4ae540 0000000000001000
ffff81001aff7068 ffffffff8803a3e9
Feb  8 20:15:56 hal9000 kernel: Call Trace:
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8023fd8d>] bio_free+0x33/0x43
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8803a3e9>]
:scsi_mod:scsi_execute_async+0x18a/0x3ac
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8816fbba>] :st:st_do_scsi+0x1ca/0x225
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8816f52d>] :st:st_sleep_done+0x0/0x45
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8817072c>]
:st:st_int_ioctl+0x612/0x98c
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff881725b4>] :st:st_flush+0x245/0x25e
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80222685>] filp_close+0x36/0x64
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80237ed4>] put_files_struct+0x6c/0xe4
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80213ad9>] do_exit+0x259/0x948
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80365fc8>] set_palette+0x9/0x5b
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8032dd7e>]
vgacon_set_cursor_size+0x36/0xdb
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020abbb>] do_page_fault+0x68b/0x706
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80221c7d>] mempool_alloc+0x24/0xda
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8025b7dd>] error_exit+0x0/0x84
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80242899>] mempool_free_slab+0x0/0xe
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020748b>] kmem_cache_free+0x42/0x1bb
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80207488>] kmem_cache_free+0x3f/0x1bb
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8023fd8d>] bio_free+0x33/0x43
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8803a3e9>]
:scsi_mod:scsi_execute_async+0x18a/0x3ac
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff802b5f20>] get_user_pages+0x2f1/0x34f
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8816fbba>] :st:st_do_scsi+0x1ca/0x225
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8816f52d>] :st:st_sleep_done+0x0/0x45
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff88171c01>] :st:st_read+0x338/0x818
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020b1c9>] vfs_read+0xcb/0x171
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020fff8>] sys_read+0x45/0x6e
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8025ab0e>] system_call+0x7e/0x83
Feb  8 20:15:56 hal9000 kernel:
Feb  8 20:15:56 hal9000 kernel:
Feb  8 20:15:56 hal9000 kernel: Code: 8b 00 f6 c4 40 74 04 48 8b 52 10 8b 02 84
c0 78 0a 0f 0b 68
Feb  8 20:15:56 hal9000 kernel: RIP  [<ffffffff8020748b>]
kmem_cache_free+0x42/0x1bb
Feb  8 20:15:56 hal9000 kernel:  RSP <ffff8100155a5818>
Feb  8 20:15:56 hal9000 kernel: CR2: ffff82bc8057b000
Feb  8 20:15:56 hal9000 kernel:  <1>Fixing recursive fault but reboot is needed!

Here my ksymoops info:
ksymoops 2.4.11 on x86_64 2.6.18-3-vserver-amd64.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.6.18-3-vserver-amd64/ (default)
     -m /boot/System.map-2.6.18-3-vserver-amd64 (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

Error (regular_file): read_ksyms stat /proc/ksyms failed
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
Feb  8 20:15:56 hal9000 kernel: Unable to handle kernel paging request at
ffff82bc8057b000 RIP:
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020748b>] kmem_cache_free+0x42/0x1bb
Feb  8 20:15:56 hal9000 kernel: Oops: 0000 [13] SMP
Feb  8 20:15:56 hal9000 kernel: CPU 0
Feb  8 20:15:56 hal9000 kernel: Pid: 16448, comm: tar Not tainted
2.6.18-3-vserver-amd64 #1
Feb  8 20:15:56 hal9000 kernel: RIP: 0010:[<ffffffff8020748b>]
[<ffffffff8020748b>] kmem_cache_free+0x42/0x1bb
Using defaults from ksymoops -t elf64-x86-64 -a i386:x86-64
Feb  8 20:15:56 hal9000 kernel: RSP: 0018:ffff8100155a5ca8  EFLAGS: 00010286
Feb  8 20:15:56 hal9000 kernel: RAX: ffff82bc8057b000 RBX: ffff81001a4ae1c0 RCX:
000000000000003f
Feb  8 20:15:56 hal9000 kernel: RDX: ffff82bc8057b000 RSI: 0000000000000000 RDI:
00000007f0000000
Feb  8 20:15:56 hal9000 kernel: RBP: ffff8100010fae00 R08: 0000000000000000 R09:
0000000000000400
Feb  8 20:15:56 hal9000 kernel: R10: ffff810016b96748 R11: ffffffff80242899 R12:
0000000000000000
Feb  8 20:15:56 hal9000 kernel: R13: ffff81001bed71c0 R14: 0000000000001000 R15:
ffff810016b96748
Feb  8 20:15:56 hal9000 kernel: FS:  00002b7bfb7f46d0(0000)
GS:ffffffff8052f000(0000) knlGS:0000000000000000
Feb  8 20:15:56 hal9000 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Feb  8 20:15:56 hal9000 kernel: CR2: ffff82bc8057b000 CR3: 0000000010c2a000 CR4:
00000000000006e0
Feb  8 20:15:56 hal9000 kernel: Stack:  ffff810003a64d28 0000000000000000
ffff81001a4ae1c0 ffff8100010fae00
Feb  8 20:15:56 hal9000 kernel:  0000000000000000 ffff81001a4ae1c0
0000000000001000 ffffffff8023fd8d
Feb  8 20:15:56 hal9000 kernel:  ffff81001a4ae1c0 0000000000001000
ffff810003a64d28 ffffffff8803a3e9
Feb  8 20:15:56 hal9000 kernel: Call Trace:
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8023fd8d>] bio_free+0x33/0x43
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8803a3e9>]
:scsi_mod:scsi_execute_async+0x18a/0x3ac
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff802b5f20>] get_user_pages+0x2f1/0x34f
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8816fbba>] :st:st_do_scsi+0x1ca/0x225
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8816f52d>] :st:st_sleep_done+0x0/0x45
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff88171c01>] :st:st_read+0x338/0x818
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020b1c9>] vfs_read+0xcb/0x171
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020fff8>] sys_read+0x45/0x6e
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8025ab0e>] system_call+0x7e/0x83
Feb  8 20:15:56 hal9000 kernel: Code: 8b 00 f6 c4 40 74 04 48 8b 52 10 8b 02 84
c0 78 0a 0f 0b 68


>>RIP; ffffffff8020748b <kmem_cache_free+42/1bb>   <=====

>>RAX; ffff82bc8057b000 <phys_startup_64+ffff82bc8037af00/ffffffff7fffff00>
>>RBX; ffff81001a4ae1c0 <phys_startup_64+ffff81001a2ae0c0/ffffffff7fffff00>
>>RDX; ffff82bc8057b000 <phys_startup_64+ffff82bc8037af00/ffffffff7fffff00>
>>RDI; 00000007f0000000 <phys_startup_64+7efdfff00/ffffffff7fffff00>
>>RBP; ffff8100010fae00 <phys_startup_64+ffff810000efad00/ffffffff7fffff00>
>>R10; ffff810016b96748 <phys_startup_64+ffff810016996648/ffffffff7fffff00>
>>R11; ffffffff80242899 <mempool_free_slab+0/e>
>>R13; ffff81001bed71c0 <phys_startup_64+ffff81001bcd70c0/ffffffff7fffff00>
>>R15; ffff810016b96748 <phys_startup_64+ffff810016996648/ffffffff7fffff00>

Trace; ffffffff8023fd8d <bio_free+33/43>
Trace; ffffffff8803a3e9 <_end+7abf3e9/7f085000>
Trace; ffffffff802b5f20 <get_user_pages+2f1/34f>
Trace; ffffffff8816fbba <_end+7bf4bba/7f085000>
Trace; ffffffff8816f52d <_end+7bf452d/7f085000>
Trace; ffffffff88171c01 <_end+7bf6c01/7f085000>
Trace; ffffffff8020b1c9 <vfs_read+cb/171>
Trace; ffffffff8020fff8 <sys_read+45/6e>
Trace; ffffffff8025ab0e <system_call+7e/83>

Code;  ffffffff8020748b <kmem_cache_free+42/1bb>
0000000000000000 <_RIP>:
Code;  ffffffff8020748b <kmem_cache_free+42/1bb>   <=====
   0:   8b 00                     mov    (%rax),%eax   <=====
Code;  ffffffff8020748d <kmem_cache_free+44/1bb>
   2:   f6 c4 40                  test   $0x40,%ah
Code;  ffffffff80207490 <kmem_cache_free+47/1bb>
   5:   74 04                     je     b <_RIP+0xb>
Code;  ffffffff80207492 <kmem_cache_free+49/1bb>
   7:   48 8b 52 10               mov    0x10(%rdx),%rdx
Code;  ffffffff80207496 <kmem_cache_free+4d/1bb>
   b:   8b 02                     mov    (%rdx),%eax
Code;  ffffffff80207498 <kmem_cache_free+4f/1bb>
   d:   84 c0                     test   %al,%al
Code;  ffffffff8020749a <kmem_cache_free+51/1bb>
   f:   78 0a                     js     1b <_RIP+0x1b>
Code;  ffffffff8020749c <kmem_cache_free+53/1bb>
  11:   0f 0b                     ud2a
Code;  ffffffff8020749e <kmem_cache_free+55/1bb>
  13:   68 00 00 00 00            pushq  $0x0

Feb  8 20:15:56 hal9000 kernel: CR2: ffff82bc8057b000
Feb  8 20:15:56 hal9000 kernel: Call Trace:
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8817016c>]
:st:st_int_ioctl+0x52/0x98c
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff881725b4>] :st:st_flush+0x245/0x25e
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80222685>] filp_close+0x36/0x64
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80237ed4>] put_files_struct+0x6c/0xe4
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80213ad9>] do_exit+0x259/0x948
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80365fc8>] set_palette+0x9/0x5b
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8032dd7e>]
vgacon_set_cursor_size+0x36/0xdb
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020abbb>] do_page_fault+0x68b/0x706
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80221c7d>] mempool_alloc+0x24/0xda
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8025b7dd>] error_exit+0x0/0x84
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80242899>] mempool_free_slab+0x0/0xe
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020748b>] kmem_cache_free+0x42/0x1bb
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80207488>] kmem_cache_free+0x3f/0x1bb
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8023fd8d>] bio_free+0x33/0x43
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8803a3e9>]
:scsi_mod:scsi_execute_async+0x18a/0x3ac
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff802b5f20>] get_user_pages+0x2f1/0x34f
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8816fbba>] :st:st_do_scsi+0x1ca/0x225
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8816f52d>] :st:st_sleep_done+0x0/0x45
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff88171c01>] :st:st_read+0x338/0x818
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020b1c9>] vfs_read+0xcb/0x171
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020fff8>] sys_read+0x45/0x6e
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8025ab0e>] system_call+0x7e/0x83
Feb  8 20:15:56 hal9000 kernel: Unable to handle kernel paging request at
ffff82bc8057b000 RIP:
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020748b>] kmem_cache_free+0x42/0x1bb
Feb  8 20:15:56 hal9000 kernel: Oops: 0000 [14] SMP
Feb  8 20:15:56 hal9000 kernel: CPU 0
Feb  8 20:15:56 hal9000 kernel: Pid: 16448, comm: tar Not tainted
2.6.18-3-vserver-amd64 #1
Feb  8 20:15:56 hal9000 kernel: RIP: 0010:[<ffffffff8020748b>]
[<ffffffff8020748b>] kmem_cache_free+0x42/0x1bb
Feb  8 20:15:56 hal9000 kernel: RSP: 0018:ffff8100155a5818  EFLAGS: 00010286
Feb  8 20:15:56 hal9000 kernel: RAX: ffff82bc8057b000 RBX: ffff81001a4ae540 RCX:
000000000000003f
Feb  8 20:15:56 hal9000 kernel: RDX: ffff82bc8057b000 RSI: 0000000000000000 RDI:
00000007f0000000
Feb  8 20:15:56 hal9000 kernel: RBP: ffff8100010fae00 R08: 0000000000000000 R09:
0000000000000400
Feb  8 20:15:56 hal9000 kernel: R10: ffff810016b96f28 R11: ffffffff80242899 R12:
0000000000000000
Feb  8 20:15:56 hal9000 kernel: R13: ffff81001bed71c0 R14: 0000000000001000 R15:
ffff810016b96f28
Feb  8 20:15:56 hal9000 kernel: FS:  00002b7bfb7f46d0(0000)
GS:ffffffff8052f000(0000) knlGS:0000000000000000
Feb  8 20:15:56 hal9000 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Feb  8 20:15:56 hal9000 kernel: CR2: ffff82bc8057b000 CR3: 000000001b8fe000 CR4:
00000000000006e0
Feb  8 20:15:56 hal9000 kernel: Stack:  ffff81001aff7068 0000000000000000
ffff81001a4ae540 ffff8100010fae00
Feb  8 20:15:56 hal9000 kernel:  0000000000000000 ffff81001a4ae540
0000000000001000 ffffffff8023fd8d
Feb  8 20:15:56 hal9000 kernel:  ffff81001a4ae540 0000000000001000
ffff81001aff7068 ffffffff8803a3e9
Feb  8 20:15:56 hal9000 kernel: Call Trace:
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8023fd8d>] bio_free+0x33/0x43
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8803a3e9>]
:scsi_mod:scsi_execute_async+0x18a/0x3ac
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8816fbba>] :st:st_do_scsi+0x1ca/0x225
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8816f52d>] :st:st_sleep_done+0x0/0x45
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8817072c>]
:st:st_int_ioctl+0x612/0x98c
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff881725b4>] :st:st_flush+0x245/0x25e
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80222685>] filp_close+0x36/0x64
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80237ed4>] put_files_struct+0x6c/0xe4
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80213ad9>] do_exit+0x259/0x948
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80365fc8>] set_palette+0x9/0x5b
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8032dd7e>]
vgacon_set_cursor_size+0x36/0xdb
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020abbb>] do_page_fault+0x68b/0x706
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80221c7d>] mempool_alloc+0x24/0xda
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8025b7dd>] error_exit+0x0/0x84
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80242899>] mempool_free_slab+0x0/0xe
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020748b>] kmem_cache_free+0x42/0x1bb
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff80207488>] kmem_cache_free+0x3f/0x1bb
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8023fd8d>] bio_free+0x33/0x43
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8803a3e9>]
:scsi_mod:scsi_execute_async+0x18a/0x3ac
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff802b5f20>] get_user_pages+0x2f1/0x34f
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8816fbba>] :st:st_do_scsi+0x1ca/0x225
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8816f52d>] :st:st_sleep_done+0x0/0x45
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff88171c01>] :st:st_read+0x338/0x818
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020b1c9>] vfs_read+0xcb/0x171
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020fff8>] sys_read+0x45/0x6e
Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8025ab0e>] system_call+0x7e/0x83
Feb  8 20:15:56 hal9000 kernel: Code: 8b 00 f6 c4 40 74 04 48 8b 52 10 8b 02 84
c0 78 0a 0f 0b 68


Trace; ffffffff8817016c <_end+7bf516c/7f085000>
Trace; ffffffff881725b4 <_end+7bf75b4/7f085000>
Trace; ffffffff80222685 <filp_close+36/64>
Trace; ffffffff80237ed4 <put_files_struct+6c/e4>
Trace; ffffffff80213ad9 <do_exit+259/948>
Trace; ffffffff80365fc8 <set_palette+9/5b>
Trace; ffffffff8032dd7e <vgacon_set_cursor_size+36/db>
Trace; ffffffff8020abbb <do_page_fault+68b/706>
Trace; ffffffff80221c7d <mempool_alloc+24/da>
Trace; ffffffff8025b7dd <error_exit+0/84>
Trace; ffffffff80242899 <mempool_free_slab+0/e>
Trace; ffffffff8020748b <kmem_cache_free+42/1bb>
Trace; ffffffff80207488 <kmem_cache_free+3f/1bb>
Trace; ffffffff8023fd8d <bio_free+33/43>
Trace; ffffffff8803a3e9 <_end+7abf3e9/7f085000>
Trace; ffffffff802b5f20 <get_user_pages+2f1/34f>
Trace; ffffffff8816fbba <_end+7bf4bba/7f085000>
Trace; ffffffff8816f52d <_end+7bf452d/7f085000>
Trace; ffffffff88171c01 <_end+7bf6c01/7f085000>
Trace; ffffffff8020b1c9 <vfs_read+cb/171>
Trace; ffffffff8020fff8 <sys_read+45/6e>
Trace; ffffffff8025ab0e <system_call+7e/83>

>>RIP; ffffffff8020748b <kmem_cache_free+42/1bb>   <=====

>>RAX; ffff82bc8057b000 <phys_startup_64+ffff82bc8037af00/ffffffff7fffff00>
>>RBX; ffff81001a4ae540 <phys_startup_64+ffff81001a2ae440/ffffffff7fffff00>
>>RDX; ffff82bc8057b000 <phys_startup_64+ffff82bc8037af00/ffffffff7fffff00>
>>RDI; 00000007f0000000 <phys_startup_64+7efdfff00/ffffffff7fffff00>
>>RBP; ffff8100010fae00 <phys_startup_64+ffff810000efad00/ffffffff7fffff00>
>>R10; ffff810016b96f28 <phys_startup_64+ffff810016996e28/ffffffff7fffff00>
>>R11; ffffffff80242899 <mempool_free_slab+0/e>
>>R13; ffff81001bed71c0 <phys_startup_64+ffff81001bcd70c0/ffffffff7fffff00>
>>R15; ffff810016b96f28 <phys_startup_64+ffff810016996e28/ffffffff7fffff00>

Trace; ffffffff8023fd8d <bio_free+33/43>
Trace; ffffffff8803a3e9 <_end+7abf3e9/7f085000>
Trace; ffffffff8816fbba <_end+7bf4bba/7f085000>
Trace; ffffffff8816f52d <_end+7bf452d/7f085000>
Trace; ffffffff8817072c <_end+7bf572c/7f085000>
Trace; ffffffff881725b4 <_end+7bf75b4/7f085000>
Trace; ffffffff80222685 <filp_close+36/64>
Trace; ffffffff80237ed4 <put_files_struct+6c/e4>
Trace; ffffffff80213ad9 <do_exit+259/948>
Trace; ffffffff80365fc8 <set_palette+9/5b>
Trace; ffffffff8032dd7e <vgacon_set_cursor_size+36/db>
Trace; ffffffff8020abbb <do_page_fault+68b/706>
Trace; ffffffff80221c7d <mempool_alloc+24/da>
Trace; ffffffff8025b7dd <error_exit+0/84>
Trace; ffffffff80242899 <mempool_free_slab+0/e>
Trace; ffffffff8020748b <kmem_cache_free+42/1bb>
Trace; ffffffff80207488 <kmem_cache_free+3f/1bb>
Trace; ffffffff8023fd8d <bio_free+33/43>
Trace; ffffffff8803a3e9 <_end+7abf3e9/7f085000>
Trace; ffffffff802b5f20 <get_user_pages+2f1/34f>
Trace; ffffffff8816fbba <_end+7bf4bba/7f085000>
Trace; ffffffff8816f52d <_end+7bf452d/7f085000>
Trace; ffffffff88171c01 <_end+7bf6c01/7f085000>
Trace; ffffffff8020b1c9 <vfs_read+cb/171>
Trace; ffffffff8020fff8 <sys_read+45/6e>
Trace; ffffffff8025ab0e <system_call+7e/83>

Code;  ffffffff8020748b <kmem_cache_free+42/1bb>
0000000000000000 <_RIP>:
Code;  ffffffff8020748b <kmem_cache_free+42/1bb>   <=====
   0:   8b 00                     mov    (%rax),%eax   <=====
Code;  ffffffff8020748d <kmem_cache_free+44/1bb>
   2:   f6 c4 40                  test   $0x40,%ah
Code;  ffffffff80207490 <kmem_cache_free+47/1bb>
   5:   74 04                     je     b <_RIP+0xb>
Code;  ffffffff80207492 <kmem_cache_free+49/1bb>
   7:   48 8b 52 10               mov    0x10(%rdx),%rdx
Code;  ffffffff80207496 <kmem_cache_free+4d/1bb>
   b:   8b 02                     mov    (%rdx),%eax
Code;  ffffffff80207498 <kmem_cache_free+4f/1bb>
   d:   84 c0                     test   %al,%al
Code;  ffffffff8020749a <kmem_cache_free+51/1bb>
   f:   78 0a                     js     1b <_RIP+0x1b>
Code;  ffffffff8020749c <kmem_cache_free+53/1bb>
  11:   0f 0b                     ud2a
Code;  ffffffff8020749e <kmem_cache_free+55/1bb>
  13:   68 00 00 00 00            pushq  $0x0

Feb  8 20:15:56 hal9000 kernel: CR2: ffff82bc8057b000

1 warning and 1 error issued.  Results may not be reliable.

Would be great if you can help me. Is this an already known issue?

Regards
-- 
Oliver Paulus

OpenPGP
Key id: 28D9C44F
Fingerprint: EADA 62FC 07DC 3361 A3D6  4174 2DE3 C027 28D9 C44F
Public Key: http://pgp.mit.edu:11371/pks/lookup?op=get&search=0x28D9C44F
--=_el4yyi043u0
Content-Type: application/pgp-signature
Content-Description: Digitale PGP-Unterschrift
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBF0L1LLePAJyjZxE8RAixTAJ9NVxXcPk8lNmBeKoINYf9HqC6CnwCfV0c3
5GKSJHqi5j99Dl4Iv0L6pyY=
=/kCj
-----END PGP SIGNATURE-----

--=_el4yyi043u0--

