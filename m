From: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Subject: Bug report (kernel crash)
Date: Wed, 28 Jan 2004 14:37:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200401281437.17505.Rafal.Wysocki@fuw.edu.pl>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Ns7FAylOcMe1QV0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.fuw.edu.pl ([193.0.80.14]:41372 "EHLO mail.fuw.edu.pl")
	by vger.kernel.org with ESMTP id S265951AbUA1Ndp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2004 08:33:45 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: ak@suse.de


--Boundary-00=_Ns7FAylOcMe1QV0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

There's a nasty bug in the Linux kernel 2.4.24 and above on x86_64 that I 
think is related to SCSI and that makes the kernel crash during boot as soon 
as the SCSI initialization code is reached.  It prevents me from using the 
2.4.24 and above on my system, because I only have SCSI drives. :-(

I got some information out of the 2.4.25-pre7 kernel.  I collected every piece 
of information I could.  If I can get any more information that may be useful 
to you, please let me know how to do this.

Attached are: (1) the output of ksymoops (unfortunately, I was unable to 
privide it with any kernel symbols), (2) the kernel log from a serial console 
that has been fed to ksymoops, (3) the contents of /proc/pci, (4) the file 
boot.msg that contains all of the boot messages from a running kernel 
(2.6.x), (5) the kernel configuration file.

Best regards,
Rafael

-- 
Rafael J. Wysocki, Ph.D.
Institute of Theoretical Physics
Faculty of Physics of Warsaw University
ul. Hoza 69, 00-681 Warsaw
[tel. (+48 22) 55 32 263]
[mob. (+48) 605 053 693]
----------------------------
One should not increase, beyond what is necessary, the number of entities 
required to explain anything.
				-- William of Ockham
--Boundary-00=_Ns7FAylOcMe1QV0
Content-Type: text/plain;
  charset="iso-8859-2";
  name="ksymoops_output"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="ksymoops_output"

ksymoops 2.4.9 on x86_64 2.6.2-bk1.  Options used
     -v /local/src/testing/linux-2.4.25-pre7/vmlinux (specified)
     -K (specified)
     -L (specified)
     -o /lib/modules/2.4.25-pre7/ (specified)
     -m /boot/System.map-2.4.25-pre7 (specified)

No modules in ksyms, skipping objects
Unable to handle kernel NULL pointer dereference<1> at 0000000000000180 RIP: [<
Oops: 0000
CPU 1
Pid: 1, comm: swapper Not tainted
RIP: 0010:[<ffffffff80140ce6>]
Using defaults from ksymoops -t elf64-x86-64 -a i386:x86-64
RSP: 0000:000001001ffede78  EFLAGS: 00010016
RAX: 0000000000000000 RBX: 0000010020000548 RCX: 0000000000000021
RDX: 0000010020000548 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000010001b36780 R11: 0000000000000001 R12: 0000000000000000
R13: 0000010020000000 R14: 0000000000000000 R15: 0000000000000021
FS:  0000000000000000(0000) GS:ffffffff803ea100(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000180 CR3: 000000001ffee000 CR4: 00000000000006e0
Process swapper (pid: 1, stackpage=1001ffed000)
Stack: 000001001ffede78 0000000000000000 ffffffff8031c400 0000000000000000
       0000010020000548 000001003ffa2950 0000010020000000 0000000000000000
       0000000000000021 0000010020000000 0000000000000000 0000000000000000
Call Trace: [<ffffffff8014384d>] [<ffffffff80140f70>]
       [<ffffffff80210237>] [<ffffffff8010c0b8>] [<ffffffff8010ee54>]
       [<ffffffff8010c090>] [<ffffffff8010ee4c>]
Code: 48 2b 80 80 01 00 00 48 c1 f8 03 44 69 f0 87 b5 6f 58 eb 09


>>RIP; ffffffff80140ce6 <__alloc_pages+26/2a0>   <=====

Trace; ffffffff8014384d <_alloc_pages+4d/9b>
Trace; ffffffff80140f70 <__get_free_pages+10/60>
Trace; ffffffff80210237 <scsi_init_minimal_dma_pool+97/106>
Trace; ffffffff8010c0b8 <init+28/130>
Trace; ffffffff8010ee54 <child_rip+8/10>
Trace; ffffffff8010c090 <init+0/130>
Trace; ffffffff8010ee4c <child_rip+0/10>

Code;  ffffffff80140ce6 <__alloc_pages+26/2a0>
0000000000000000 <_RIP>:
Code;  ffffffff80140ce6 <__alloc_pages+26/2a0>   <=====
   0:   48 2b 80 80 01 00 00      sub    0x180(%rax),%rax   <=====
Code;  ffffffff80140ced <__alloc_pages+2d/2a0>
   7:   48 c1 f8 03               sar    $0x3,%rax
Code;  ffffffff80140cf1 <__alloc_pages+31/2a0>
   b:   44 69 f0 87 b5 6f 58      imul   $0x586fb587,%eax,%r14d
Code;  ffffffff80140cf8 <__alloc_pages+38/2a0>
  12:   eb 09                     jmp    1d <_RIP+0x1d>

CR2: 0000000000000180
 <0>Kernel panic: Attempted to kill init!

--Boundary-00=_Ns7FAylOcMe1QV0
Content-Type: text/x-log;
  charset="iso-8859-2";
  name="2.4.25-pre7.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="2.4.25-pre7.log"

PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ f0000000 size 131072 KB
PCI-DMA: Reserving 128MB of IOMMU area in the AGP aperture
Linux NET4.0 for Linux 2.4
Based upon Swansea University Computer Society NET3.039
Initializing RT netlink socket
Starting kswapd
VFS: Disk quotas vdquot_6.5.1
Journalled Block Device driver loaded
IA32 emulation $Id: sys_ia32.c,v 1.66 2003/11/10 13:09:54 ak Exp $
ACPI: Power Button (FF) [PWRF]
ACPI: Processor [CPU1] (supports C1, 8 throttling states)
ACPI: Processor [CPU2] (supports C1)
vesafb: framebuffer at 0xe0000000, mapped to 0xffffff000000b000, size 6144k
vesafb: mode is 1024x768x32, linelength=4096, pages=1
vesafb: scrolling: redraw
vesafb: directcolor: size=8:8:8:8, shift=24:16:8:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
pty: 256 Unix98 ptys configured
Serial driver version 5.05c (2001-07-08) with MANY_PORTS SHARE_IRQ SERIAL_PCI ed
ttyS00 at 0x03f8 (irq = 4) is a 16550A
ttyS01 at 0x02f8 (irq = 3) is a 16550A
Real Time Clock Driver v1.10f
amd768_rng: AMD768 system management I/O registers at 0x5000.
amd768_rng hardware driver 0.1.0 loaded
hw_random: AMD768 system management I/O registers at 0x5000.
hw_random: misc device register failed
Uniform Multi-Platform E-IDE driver Revision: 7.00beta4-2.4
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
AMD8111: IDE controller at PCI slot 00:07.1
AMD8111: chipset revision 3
AMD8111: not 100% native mode: will probe irqs later
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
AMD_IDE: Advanced Micro Devices [AMD] AMD-8111 IDE (rev 03) UDMA100 controller 1
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:pio, hdd:pio
hda: JLMS XJ-HD166S, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
SCSI subsystem driver Revision: 1.00
Unable to handle kernel NULL pointer dereference<1> at 0000000000000180 RIP: [<
Oops: 0000
CPU 1
Pid: 1, comm: swapper Not tainted
RIP: 0010:[<ffffffff80140ce6>]
RSP: 0000:000001001ffede78  EFLAGS: 00010016
RAX: 0000000000000000 RBX: 0000010020000548 RCX: 0000000000000021
RDX: 0000010020000548 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000010001b36780 R11: 0000000000000001 R12: 0000000000000000
R13: 0000010020000000 R14: 0000000000000000 R15: 0000000000000021
FS:  0000000000000000(0000) GS:ffffffff803ea100(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000180 CR3: 000000001ffee000 CR4: 00000000000006e0
Process swapper (pid: 1, stackpage=1001ffed000)
Stack: 000001001ffede78 0000000000000000 ffffffff8031c400 0000000000000000
       0000010020000548 000001003ffa2950 0000010020000000 0000000000000000
       0000000000000021 0000010020000000 0000000000000000 0000000000000000
Call Trace: [<ffffffff8014384d>] [<ffffffff80140f70>]
       [<ffffffff80210237>] [<ffffffff8010c0b8>] [<ffffffff8010ee54>]
       [<ffffffff8010c090>] [<ffffffff8010ee4c>]

Code: 48 2b 80 80 01 00 00 48 c1 f8 03 44 69 f0 87 b5 6f 58 eb 09
RIP [<ffffffff80140ce6>] RSP <000001001ffede78>
CR2: 0000000000000180
 <0>Kernel panic: Attempted to kill init!


--Boundary-00=_Ns7FAylOcMe1QV0
Content-Type: text/plain;
  charset="iso-8859-2";
  name="pci.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="pci.txt"

PCI devices found:
  Bus  0, device   6, function  0:
    PCI bridge: Advanced Micro Devic AMD-8111 PCI (rev 7).
      Master Capable.  Latency=64.  Min Gnt=7.
  Bus  0, device   7, function  0:
    ISA bridge: Advanced Micro Devic AMD-8111 LPC (rev 5).
  Bus  0, device   7, function  1:
    IDE interface: Advanced Micro Devic AMD-8111 IDE (rev 3).
      Master Capable.  Latency=32.  
      I/O at 0xffa0 [0xffaf].
  Bus  0, device   7, function  2:
    SMBus: Advanced Micro Devic AMD-8111 SMBus 2.0 (rev 2).
      IRQ 19.
      Master Capable.  Latency=64.  
      I/O at 0xb480 [0xb49f].
  Bus  0, device   7, function  3:
    Bridge: Advanced Micro Devic AMD-8111 ACPI (rev 5).
      Master Capable.  Latency=64.  
  Bus  0, device   7, function  5:
    Multimedia audio controller: Advanced Micro Devic AMD-8111 AC97 Audio (rev 3).
      IRQ 17.
      Master Capable.  Latency=64.  
      I/O at 0xb800 [0xb8ff].
      I/O at 0xbc00 [0xbc3f].
  Bus  0, device  10, function  0:
    PCI bridge: Advanced Micro Devic AMD-8131 PCI-X Bridg (rev 18).
      Master Capable.  Latency=64.  Min Gnt=5.
  Bus  0, device  10, function  1:
    PIC: Advanced Micro Devic AMD-8131 PCI-X APIC (rev 1).
      Non-prefetchable 64 bit memory at 0xfc9fe000 [0xfc9fefff].
  Bus  0, device  11, function  0:
    PCI bridge: Advanced Micro Devic AMD-8131 PCI-X Bridg (#2) (rev 18).
      Master Capable.  Latency=64.  Min Gnt=5.
  Bus  0, device  11, function  1:
    PIC: Advanced Micro Devic AMD-8131 PCI-X APIC (#2) (rev 1).
      Non-prefetchable 64 bit memory at 0xfc9ff000 [0xfc9fffff].
  Bus  0, device  24, function  0:
    Host bridge: Advanced Micro Devic K8 NorthBridge (rev 0).
  Bus  0, device  24, function  1:
    Host bridge: Advanced Micro Devic K8 NorthBridge (rev 0).
  Bus  0, device  24, function  2:
    Host bridge: Advanced Micro Devic K8 NorthBridge (rev 0).
  Bus  0, device  24, function  3:
    Host bridge: Advanced Micro Devic K8 NorthBridge (rev 0).
  Bus  0, device  25, function  0:
    Host bridge: Advanced Micro Devic K8 NorthBridge (#2) (rev 0).
  Bus  0, device  25, function  1:
    Host bridge: Advanced Micro Devic K8 NorthBridge (#2) (rev 0).
  Bus  0, device  25, function  2:
    Host bridge: Advanced Micro Devic K8 NorthBridge (#2) (rev 0).
  Bus  0, device  25, function  3:
    Host bridge: Advanced Micro Devic K8 NorthBridge (#2) (rev 0).
  Bus  3, device   0, function  0:
    USB Controller: Advanced Micro Devic AMD-8111 USB (rev 11).
      IRQ 19.
      Master Capable.  Latency=64.  Max Lat=80.
      Non-prefetchable 32 bit memory at 0xfc8f7000 [0xfc8f7fff].
  Bus  3, device   0, function  1:
    USB Controller: Advanced Micro Devic AMD-8111 USB (#2) (rev 11).
      IRQ 19.
      Master Capable.  Latency=64.  Max Lat=80.
      Non-prefetchable 32 bit memory at 0xfc8fc000 [0xfc8fcfff].
  Bus  3, device  10, function  0:
    USB Controller: NEC Corporation USB (rev 65).
      IRQ 16.
      Master Capable.  Latency=64.  Min Gnt=1.Max Lat=42.
      Non-prefetchable 32 bit memory at 0xfc8fd000 [0xfc8fdfff].
  Bus  3, device  10, function  1:
    USB Controller: NEC Corporation USB (#2) (rev 65).
      IRQ 17.
      Master Capable.  Latency=64.  Min Gnt=1.Max Lat=42.
      Non-prefetchable 32 bit memory at 0xfc8fe000 [0xfc8fefff].
  Bus  3, device  10, function  2:
    USB Controller: NEC Corporation USB 2.0 (rev 2).
      IRQ 18.
      Master Capable.  Latency=64.  Min Gnt=16.Max Lat=34.
      Non-prefetchable 32 bit memory at 0xfc8ff800 [0xfc8ff8ff].
  Bus  3, device  11, function  0:
    RAID bus controller: PCI device 1095:3114 (CMD Technology Inc) (rev 2).
      IRQ 17.
      Master Capable.  Latency=64.  
      I/O at 0x9c00 [0x9c07].
      I/O at 0x9880 [0x9883].
      I/O at 0x9800 [0x9807].
      I/O at 0x9480 [0x9483].
      I/O at 0x9400 [0x940f].
      Non-prefetchable 32 bit memory at 0xfc8ffc00 [0xfc8fffff].
  Bus  3, device  12, function  0:
    FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-139 (rev 0).
      IRQ 19.
      Master Capable.  Latency=64.  Min Gnt=2.Max Lat=4.
      Non-prefetchable 32 bit memory at 0xfc8ff000 [0xfc8ff7ff].
      Non-prefetchable 32 bit memory at 0xfc8f8000 [0xfc8fbfff].
  Bus  2, device   8, function  0:
    SCSI storage controller: LSI Logic / Symbios  53c1010 66MHz  Ultra (rev 1).
      IRQ 27.
      Master Capable.  Latency=64.  Min Gnt=17.Max Lat=18.
      I/O at 0x8800 [0x88ff].
      Non-prefetchable 64 bit memory at 0xfc6dfc00 [0xfc6dffff].
      Non-prefetchable 64 bit memory at 0xfc6dc000 [0xfc6ddfff].
  Bus  2, device   9, function  0:
    Ethernet controller: Broadcom Corporation NetXtreme BCM5703 Gi (rev 2).
      IRQ 24.
      Master Capable.  Latency=64.  Min Gnt=64.
      Non-prefetchable 64 bit memory at 0xfc6f0000 [0xfc6fffff].
  Bus  1, device   6, function  0:
    SCSI storage controller: Adaptec AIC-7892B U160/m (rev 2).
      IRQ 29.
      Master Capable.  Latency=64.  Min Gnt=40.Max Lat=25.
      I/O at 0x7800 [0x78ff].
      Non-prefetchable 64 bit memory at 0xfc5ff000 [0xfc5fffff].
  Bus  4, device   0, function  0:
    Host bridge: Advanced Micro Devic AMD-8151 System Cont (rev 19).
      Prefetchable 32 bit memory at 0xf0000000 [0xf7ffffff].
  Bus  4, device   1, function  0:
    PCI bridge: Advanced Micro Devic AMD-8151 AGP Bridge (rev 19).
      Master Capable.  Latency=64.  Min Gnt=8.
  Bus  5, device   0, function  0:
    VGA compatible controller: PCI device 10de:0322 (nVidia Corporation) (rev 161).
      IRQ 16.
      Master Capable.  Latency=64.  Min Gnt=5.Max Lat=1.
      Non-prefetchable 32 bit memory at 0xfd000000 [0xfdffffff].
      Prefetchable 32 bit memory at 0xe0000000 [0xe7ffffff].

--Boundary-00=_Ns7FAylOcMe1QV0
Content-Type: text/plain;
  charset="iso-8859-2";
  name="boot.msg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="boot.msg"

Inspecting /boot/System.map-2.6.2-rc1
Loaded 29700 symbols from /boot/System.map-2.6.2-rc1.
Symbols match kernel version 2.6.2.
No module symbols loaded - kernel modules not enabled.

klogd 1.4.1, log source = ksyslog started.
<4>Bootdata ok (command line is root=/dev/sdb3 vga=792)
<4>Linux version 2.6.2-rc1 (root@chimera) (gcc version 3.3.1 (SuSE Linux)) #3 SMP Thu Jan 22 22:23:01 CET 2004
<6>BIOS-provided physical RAM map:
<4> BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
<4> BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
<4> BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
<4> BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
<4> BIOS-e820: 000000003fff0000 - 000000003ffff000 (ACPI data)
<4> BIOS-e820: 000000003ffff000 - 0000000040000000 (ACPI NVS)
<4> BIOS-e820: 00000000ff7c0000 - 0000000100000000 (reserved)
<6>Scanning NUMA topology in Northbridge 24
<6>Node 0 MemBase 0000000000000000 Limit 000000001fffffff
<6>Node 1 MemBase 0000000020000000 Limit 000000003fff0000
<6>Using node hash shift of 24
<4>Bootmem setup node 0 0000000000000000-000000001fffffff
<4>Bootmem setup node 1 0000000020000000-000000003fff0000
<6>found SMP MP-table at 000ff780
<4>hm, page 000ff000 reserved twice.
<4>hm, page 00100000 reserved twice.
<4>hm, page 000f9000 reserved twice.
<4>hm, page 000fa000 reserved twice.
<6>setting up node 0 0-1ffff
<4>On node 0 totalpages: 131071
<4>  DMA zone: 4096 pages, LIFO batch:1
<4>  Normal zone: 126975 pages, LIFO batch:16
<4>  HighMem zone: 0 pages, LIFO batch:1
<6>setting up node 1 20000-3fff0
<4>On node 1 totalpages: 131056
<4>  DMA zone: 0 pages, LIFO batch:1
<4>  Normal zone: 131056 pages, LIFO batch:16
<4>  HighMem zone: 0 pages, LIFO batch:1
<6>ACPI: RSDP (v000 ACPIAM                                    ) @ 0x00000000000f66f0
<6>ACPI: RSDT (v001 A M I  OEMRSDT  0x10000302 MSFT 0x00000097) @ 0x000000003fff0000
<6>ACPI: FADT (v001 A M I  OEMFACP  0x10000302 MSFT 0x00000097) @ 0x000000003fff0200
<6>ACPI: MADT (v001 A M I  OEMAPIC  0x10000302 MSFT 0x00000097) @ 0x000000003fff0380
<6>ACPI: OEMB (v001 A M I  OEMBIOS  0x10000302 MSFT 0x00000097) @ 0x000000003ffff040
<6>ACPI: SRAT (v001 A M I  OEMSRAT  0x10000302 MSFT 0x00000097) @ 0x000000003fff39f0
<6>ACPI: ASF! (v001 AMIASF AMDSTRET 0x00000001 INTL 0x02002026) @ 0x000000003fff3ae0
<6>ACPI: DSDT (v001  0ABCF 0ABCF007 0x00000007 INTL 0x02002026) @ 0x0000000000000000
<6>ACPI: Local APIC address 0x00000000fee00000
<6>ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
<6>Processor #0 15:5 APIC version 16
<6>ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
<6>Processor #1 15:5 APIC version 16
<6>ACPI: IOAPIC (id[0x02] address[0xfec00000] global_irq_base[0x0])
<6>IOAPIC[0]: Assigned apic_id 2
<6>IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, IRQ 0-23
<6>ACPI: IOAPIC (id[0x03] address[0xfc9fe000] global_irq_base[0x18])
<6>IOAPIC[1]: Assigned apic_id 3
<6>IOAPIC[1]: apic_id 3, version 17, address 0xfc9fe000, IRQ 24-27
<6>ACPI: IOAPIC (id[0x04] address[0xfc9ff000] global_irq_base[0x1c])
<6>IOAPIC[2]: Assigned apic_id 4
<6>IOAPIC[2]: apic_id 4, version 17, address 0xfc9ff000, IRQ 28-31
<6>ACPI: INT_SRC_OVR (bus[0] irq[0x0] global_irq[0x2] polarity[0x0] trigger[0x0])
<6>Using ACPI (MADT) for SMP configuration information
<4>Checking aperture...
<4>CPU 0: aperture @ f0000000 size 128 MB
<4>CPU 1: aperture @ f0000000 size 128 MB
<4>Building zonelist for node : 0
<4>Building zonelist for node : 1
<4>Kernel command line: root=/dev/sdb3 vga=792 console=tty0
<4>Initializing CPU#0
<4>PID hash table entries: 16 (order 4: 256 bytes)
<6>time.c: Using 1.193182 MHz PIT timer.
<6>time.c: Detected 1385.330 MHz processor.
<4>Console: colour dummy device 80x25
<4>Memory: 1022708k/1048512k available (2333k kernel code, 0k reserved, 1120k data, 172k init)
<4>Calibrating delay loop... 2719.74 BogoMIPS
<6>Security Scaffold v1.0.0 initialized
<6>SELinux:  Initializing.
<6>SELinux:  Starting in permissive mode
<6>There is already a security framework initialized, register_security failed.
<6>Failure registering capabilities with the kernel
<6>selinux_register_security:  Registering secondary module capability
<6>Capability LSM initialized
<6>Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
<4>Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
<4>Mount-cache hash table entries: 256 (order: 0, 4096 bytes)
<6>CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
<6>CPU: L2 Cache: 1024K (64 bytes/line)
<4>POSIX conformance testing by UNIFIX
<6>CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
<6>CPU: L2 Cache: 1024K (64 bytes/line)
<6>CPU0: AMD Opteron(tm) Processor 240 stepping 01
<6>per-CPU timeslice cutoff: 1023.59 usecs.
<6>task migration cache decay timeout: 2 msecs.
<6>watchdog: setting K7_PERFCTR0 to ffeaddd8
<6>Booting processor 1/1 rip 6000 rsp 1001ff85f58
<4>Initializing CPU#1
<6>CPU1:  stepping 00
<6>watchdog: setting K7_PERFCTR0 to ffeaddd8
<4>Calibrating delay loop... <6>Total of 2 processors activated (2719.74 BogoMIPS).
<4>ENABLING IO-APIC IRQs
<7>init IO_APIC IRQs
<7> IO-APIC (apicid-pin) 2-0, 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23, 3-0, 3-1, 3-2, 3-3, 4-0, 4-1, 4-2, 4-3 not connected.
<6>..TIMER: vector=0x31 pin1=2 pin2=0
<7>number of MP IRQ sources: 16.
<7>number of IO-APIC #2 registers: 24.
<7>number of IO-APIC #3 registers: 4.
<7>number of IO-APIC #4 registers: 4.
<6>testing the IO APIC.......................
<4>
<7>IO APIC #2......
<7>.... register #00: 02000000
<7>.......    : physical APIC id: 02
<7>.... register #01: 00170011
<7>.......     : max redirection entries: 0017
<7>.......     : PRQ implemented: 0
<7>.......     : IO APIC version: 0011
<7>.... register #02: 02000000
<7>.......     : arbitration: 02
<7>.... IRQ redirection table:
<7> NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
<7> 00 000 00  1    0    0   0   0    0    0    00
<7> 01 001 01  0    0    0   0   0    1    1    39
<7> 02 001 01  0    0    0   0   0    1    1    31
<7> 03 001 01  0    0    0   0   0    1    1    41
<7> 04 001 01  0    0    0   0   0    1    1    49
<7> 05 001 01  0    0    0   0   0    1    1    51
<7> 06 001 01  0    0    0   0   0    1    1    59
<7> 07 001 01  0    0    0   0   0    1    1    61
<7> 08 001 01  0    0    0   0   0    1    1    69
<7> 09 001 01  0    0    0   0   0    1    1    71
<7> 0a 001 01  0    0    0   0   0    1    1    79
<7> 0b 001 01  0    0    0   0   0    1    1    81
<7> 0c 001 01  0    0    0   0   0    1    1    89
<7> 0d 001 01  0    0    0   0   0    1    1    91
<7> 0e 001 01  0    0    0   0   0    1    1    99
<7> 0f 001 01  0    0    0   0   0    1    1    A1
<7> 10 000 00  1    0    0   0   0    0    0    00
<7> 11 000 00  1    0    0   0   0    0    0    00
<7> 12 000 00  1    0    0   0   0    0    0    00
<7> 13 000 00  1    0    0   0   0    0    0    00
<7> 14 000 00  1    0    0   0   0    0    0    00
<7> 15 000 00  1    0    0   0   0    0    0    00
<7> 16 000 00  1    0    0   0   0    0    0    00
<7> 17 000 00  1    0    0   0   0    0    0    00
<4>
<7>IO APIC #3......
<7>.... register #00: 03000000
<7>.......    : physical APIC id: 03
<7>.... register #01: 00030011
<7>.......     : max redirection entries: 0003
<7>.......     : PRQ implemented: 0
<7>.......     : IO APIC version: 0011
<7>.... register #02: 00000000
<7>.......     : arbitration: 00
<7>.... IRQ redirection table:
<7> NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
<7> 00 000 00  1    0    0   0   0    0    0    00
<7> 01 000 00  1    0    0   0   0    0    0    00
<7> 02 000 00  1    0    0   0   0    0    0    00
<7> 03 000 00  1    0    0   0   0    0    0    00
<4>
<7>IO APIC #4......
<7>.... register #00: 04000000
<7>.......    : physical APIC id: 04
<7>.... register #01: 00030011
<7>.......     : max redirection entries: 0003
<7>.......     : PRQ implemented: 0
<7>.......     : IO APIC version: 0011
<7>.... register #02: 00000000
<7>.......     : arbitration: 00
<7>.... IRQ redirection table:
<7> NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
<7> 00 000 00  1    0    0   0   0    0    0    00
<7> 01 000 00  1    0    0   0   0    0    0    00
<7> 02 000 00  1    0    0   0   0    0    0    00
<7> 03 000 00  1    0    0   0   0    0    0    00
<7>IRQ to pin mappings:
<7>IRQ0 -> 0:2
<7>IRQ1 -> 0:1
<7>IRQ3 -> 0:3
<7>IRQ4 -> 0:4
<7>IRQ5 -> 0:5
<7>IRQ6 -> 0:6
<7>IRQ7 -> 0:7
<7>IRQ8 -> 0:8
<7>IRQ9 -> 0:9
<7>IRQ10 -> 0:10
<7>IRQ11 -> 0:11
<7>IRQ12 -> 0:12
<7>IRQ13 -> 0:13
<7>IRQ14 -> 0:14
<7>IRQ15 -> 0:15
<6>.................................... done.
<6>Using local APIC timer interrupts.
<6>Detected 12.369 MHz APIC timer.
<6>checking TSC synchronization across 2 CPUs: 2768.89 BogoMIPS
<6>CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
<6>CPU: L2 Cache: 1024K (64 bytes/line)
<4>passed.
<6>time.c: Using PIT/TSC based timekeeping.
<4>Starting migration thread for cpu 0
<4>Bringing up 1
<4>CPU 1 IS NOW UP!
<4>Starting migration thread for cpu 1
<4>CPUS done 2
<6>NET: Registered protocol family 16
<6>PCI: Using configuration type 1
<6>mtrr: v2.0 (20020519)
<6>ACPI: Subsystem revision 20031002
<6>ACPI: Interpreter enabled
<6>ACPI: Using IOAPIC for interrupt routing
<6>ACPI: PCI Root Bridge [PCI0] (00:00)
<4>PCI: Probing PCI hardware (bus 00)
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.GOLA._PRT]
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.GOLB._PRT]
<6>ACPI: PCI Root Bridge [PCIB] (00:04)
<4>PCI: Probing PCI hardware (bus 04)
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCIB.PBP2._PRT]
<4>ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
<4>ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
<4>ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
<4>ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
<5>SCSI subsystem initialized
<7>IOAPIC[0]: Set PCI routing entry (2-16 -> 0xa9 -> IRQ 16 Mode:1 Active:1)
<7>00:00:07[A] -> 2-16 -> IRQ 16
<7>IOAPIC[0]: Set PCI routing entry (2-17 -> 0xb1 -> IRQ 17 Mode:1 Active:1)
<7>00:00:07[B] -> 2-17 -> IRQ 17
<7>IOAPIC[0]: Set PCI routing entry (2-18 -> 0xb9 -> IRQ 18 Mode:1 Active:1)
<7>00:00:07[C] -> 2-18 -> IRQ 18
<7>IOAPIC[0]: Set PCI routing entry (2-19 -> 0xc1 -> IRQ 19 Mode:1 Active:1)
<7>00:00:07[D] -> 2-19 -> IRQ 19
<7>Pin 2-19 already programmed
<7>Pin 2-16 already programmed
<7>Pin 2-17 already programmed
<7>Pin 2-18 already programmed
<7>Pin 2-19 already programmed
<7>Pin 2-17 already programmed
<7>Pin 2-19 already programmed
<7>IOAPIC[1]: Set PCI routing entry (3-3 -> 0xc9 -> IRQ 27 Mode:1 Active:1)
<7>00:02:08[A] -> 3-3 -> IRQ 27
<7>IOAPIC[1]: Set PCI routing entry (3-0 -> 0xd1 -> IRQ 24 Mode:1 Active:1)
<7>00:02:08[B] -> 3-0 -> IRQ 24
<7>IOAPIC[1]: Set PCI routing entry (3-1 -> 0xd9 -> IRQ 25 Mode:1 Active:1)
<7>00:02:08[C] -> 3-1 -> IRQ 25
<7>IOAPIC[1]: Set PCI routing entry (3-2 -> 0xe1 -> IRQ 26 Mode:1 Active:1)
<7>00:02:08[D] -> 3-2 -> IRQ 26
<7>Pin 3-2 already programmed
<7>Pin 3-3 already programmed
<7>Pin 3-0 already programmed
<7>Pin 3-1 already programmed
<7>Pin 3-0 already programmed
<7>Pin 3-1 already programmed
<7>IOAPIC[2]: Set PCI routing entry (4-0 -> 0xe9 -> IRQ 28 Mode:1 Active:1)
<7>00:01:03[A] -> 4-0 -> IRQ 28
<7>IOAPIC[2]: Set PCI routing entry (4-1 -> 0x32 -> IRQ 29 Mode:1 Active:1)
<7>00:01:03[B] -> 4-1 -> IRQ 29
<7>IOAPIC[2]: Set PCI routing entry (4-2 -> 0x3a -> IRQ 30 Mode:1 Active:1)
<7>00:01:03[C] -> 4-2 -> IRQ 30
<7>IOAPIC[2]: Set PCI routing entry (4-3 -> 0x42 -> IRQ 31 Mode:1 Active:1)
<7>00:01:03[D] -> 4-3 -> IRQ 31
<7>Pin 4-1 already programmed
<7>Pin 4-2 already programmed
<7>Pin 4-3 already programmed
<7>Pin 4-0 already programmed
<7>Pin 2-16 already programmed
<7>Pin 2-17 already programmed
<6>PCI: Using ACPI for IRQ routing
<6>PCI: if you experience problems, try using option 'pci=noacpi' or even 'acpi=off'
<6>agpgart: Detected AMD 8151 AGP Bridge rev B2
<6>agpgart: Maximum main memory to use for agp memory: 941M
<6>agpgart: AGP aperture is 128M @ 0xf0000000
<6>PCI-DMA: Disabling IOMMU.
<6>vesafb: framebuffer at 0xe0000000, mapped to 0xffffff000004f000, size 16384k
<6>vesafb: mode is 1024x768x32, linelength=4096, pages=1
<6>vesafb: scrolling: redraw
<6>vesafb: directcolor: size=8:8:8:8, shift=24:16:8:0
<6>fb0: VESA VGA frame buffer device
<4>Total HugeTLB memory allocated, 0
<4>IA32 emulation $Id: sys_ia32.c,v 1.32 2002/03/24 13:02:28 ak Exp $
<5>VFS: Disk quotas dquot_6.5.1
<6>SELinux:  Registering netfilter hooks
<6>Initializing Cryptographic API
<6>ACPI: Power Button (FF) [PWRF]
<6>ACPI: Processor [CPU1] (supports C1, 8 throttling states)
<6>ACPI: Processor [CPU2] (supports C1)
<4>Console: switching to colour frame buffer device 128x48
<4>pty: 256 Unix98 ptys configured
<6>Real Time Clock Driver v1.12
<6>hw_random: AMD768 system management I/O registers at 0x5000.
<6>hw_random hardware driver 1.0.0 loaded
<6>Linux agpgart interface v0.100 (c) Dave Jones
<6>Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing enabled
<4>ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<4>ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
<6>loop: loaded (max 8 devices)
<6>Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
<6>ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
<6>AMD8111: IDE controller at PCI slot 0000:00:07.1
<6>AMD8111: chipset revision 3
<6>AMD8111: not 100%% native mode: will probe irqs later
<6>ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
<6>AMD8111: 0000:00:07.1 (rev 03) UDMA133 controller
<6>    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
<6>    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:pio, hdd:pio
<4>hda: JLMS XJ-HD166S, ATAPI CD/DVD-ROM drive
<4>Using anticipatory io scheduler
<4>ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
<6>scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
<4>        <Adaptec 19160B Ultra160 SCSI adapter>
<4>        aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
<4>
<4>(scsi0:A:3): 10.000MB/s transfers (10.000MHz, offset 15)
<5>  Vendor: YAMAHA    Model: CRW6416S          Rev: 1.0b
<5>  Type:   CD-ROM                             ANSI SCSI revision: 02
<6>sym0: <1010-66> rev 0x1 at pci 0000:02:08.0 irq 27
<6>sym0: using 64 bit DMA addressing
<4>sym0: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
<4>sym0: open drain IRQ line driver, using on-chip SRAM
<4>sym0: using LOAD/STORE-based firmware.
<4>sym0: handling phase mismatch from SCRIPTS.
<5>sym0: SCSI BUS has been reset.
<6>scsi1 : sym-2.1.18f
<6>sym0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
<5>  Vendor: IBM       Model: DDYS-T36950N      Rev: S96H
<5>  Type:   Direct-Access                      ANSI SCSI revision: 03
<6>sym0:0:0: tagged command queuing enabled, command queue depth 16.
<5>  Vendor: IBM       Model: IC35L018UWD210-0  Rev: S5BS
<5>  Type:   Direct-Access                      ANSI SCSI revision: 03
<6>sym0:10:0: tagged command queuing enabled, command queue depth 16.
<7>libata version 0.81 loaded.
<6>sym0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
<5>SCSI device sda: 71687340 512-byte hdwr sectors (36704 MB)
<5>SCSI device sda: drive cache: write back
<6> sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
<5>Attached scsi disk sda at scsi1, channel 0, id 0, lun 0
<6>sym0:10: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
<5>SCSI device sdb: 35843670 512-byte hdwr sectors (18352 MB)
<5>SCSI device sdb: drive cache: write back
<6> sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 >
<5>Attached scsi disk sdb at scsi1, channel 0, id 10, lun 0
<4>Console: switching to colour frame buffer device 128x48
<6>mice: PS/2 mouse device common for all mice
<6>serio: i8042 AUX port at 0x60,0x64 irq 12
<6>input: ImExPS/2 Logitech Explorer Mouse on isa0060/serio1
<6>serio: i8042 KBD port at 0x60,0x64 irq 1
<6>input: AT Translated Set 2 keyboard on isa0060/serio0
<6>md: raid1 personality registered as nr 3
<6>md: raid5 personality registered as nr 4
<6>raid5: measuring checksumming speed
<4>   generic_sse:  4076.000 MB/sec
<4>raid5: using function: generic_sse (4076.000 MB/sec)
<6>md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
<6>NET: Registered protocol family 2
<6>IP: routing cache hash table of 4096 buckets, 64Kbytes
<6>TCP: Hash tables configured (established 131072 bind 65536)
<4>ip_conntrack version 2.1 (4095 buckets, 32760 max) - 448 bytes per conntrack
<6>NET: Registered protocol family 1
<6>NET: Registered protocol family 15
<6>md: Autodetecting RAID arrays.
<6>md: autorun ...
<6>md: ... autorun DONE.
<6>EXT3-fs: INFO: recovery required on readonly filesystem.
<6>EXT3-fs: write access will be enabled during recovery.
<6>kjournald starting.  Commit interval 5 seconds
<6>EXT3-fs: recovery complete.
<6>EXT3-fs: mounted filesystem with ordered data mode.
<4>VFS: Mounted root (ext3 filesystem) readonly.
<4>Freeing unused kernel memory: 172k freed
<6>md: Autodetecting RAID arrays.
<6>md: autorun ...
<6>md: ... autorun DONE.
<6>EXT3 FS on sdb3, internal journal
<6>EXT3 FS on sdb3, internal journal
<6>Adding 525304k swap on /dev/sda2.  Priority:42 extents:1
<6>Adding 525304k swap on /dev/sdb2.  Priority:42 extents:1
<6>EXT3 FS on sdb3, internal journal
<6>kjournald starting.  Commit interval 5 seconds
<6>EXT3 FS on sdb1, internal journal
<6>EXT3-fs: mounted filesystem with ordered data mode.
<6>kjournald starting.  Commit interval 5 seconds
<6>EXT3 FS on sdb5, internal journal
<6>EXT3-fs: mounted filesystem with ordered data mode.
<6>kjournald starting.  Commit interval 5 seconds
<6>EXT3 FS on sdb6, internal journal
<6>EXT3-fs: mounted filesystem with ordered data mode.
<6>kjournald starting.  Commit interval 5 seconds
<6>EXT3 FS on sdb7, internal journal
<6>EXT3-fs: mounted filesystem with ordered data mode.
<6>kjournald starting.  Commit interval 5 seconds
<6>EXT3 FS on sdb8, internal journal
<6>EXT3-fs: mounted filesystem with ordered data mode.
<6>kjournald starting.  Commit interval 5 seconds
<6>EXT3 FS on sda9, internal journal
<6>EXT3-fs: mounted filesystem with ordered data mode.
<4>sr0: scsi3-mmc drive: 16x/16x writer cd/rw xa/form2 cdda tray
<6>Uniform CD-ROM driver Revision: 3.20
<7>Attached scsi CD-ROM sr0 at scsi0, channel 0, id 3, lun 0
<6>inserting floppy driver for 2.6.2-rc1
<6>Floppy drive(s): fd0 is 1.44M
<6>FDC 0 is a post-1991 82077
<6>Intel 810 + AC97 Audio, version 0.24, 22:24:11 Jan 21 2004
<6>i810: AMD-8111 IOHub found at IO 0xbc00 and 0xb800, MEM 0x0000 and 0x0000, IRQ 17
<6>i810_audio: Audio Controller supports 6 channels.
<6>i810_audio: Defaulting to base 2 channel mode.
<6>i810_audio: Resetting connection 0
<6>ac97_codec: AC97 Audio codec, id: ADS116 (Unknown)
<4>i810_audio: AC'97 codec 0 supports AMAP, total channels = 2
<4>i810_audio: setting clocking to 48979
Kernel logging (ksyslog) stopped.
Kernel log daemon terminating.

Boot logging started on /dev/tty1(/dev/console) at Sun Jan 25 13:54:43 2004

Master Resource Control: previous runlevel: N, switching to runlevel: 5
<notice>start services (random)
Initializing random number generatordone
<notice>exit status of (random) is (0)
<notice>start services (network)
Setting up network interfaces:
    lo        done
    eth0      IP/Netmask: 192.168.100.1 / 255.255.255.0  done
<notice>exit status of (network) is (0)
<notice>start services (syslog)
Starting syslog services<notice>startproc: execve (/sbin/syslogd) [ /sbin/syslogd -a /var/lib/dhcp/dev/log -a /var/lib/named/dev/log ], [ CONSOLE=/dev/console SHELL=/bin/sh TERM=linux progress=18 INIT_VERSION=sysvinit-2.82 REDIRECT=/dev/tty1 COLUMNS=128 PATH=/bin:/sbin:/usr/bin:/usr/sbin vga=792 RUNLEVEL=5 PWD=/ PREVLEVEL=N LINES=48 SHLVL=2 HOME=/ sscripts=33 _=/sbin/startproc DAEMON=/sbin/syslogd ]
<notice>startproc: execve (/sbin/klogd) [ /sbin/klogd -c 1 -2 ], [ CONSOLE=/dev/console SHELL=/bin/sh TERM=linux progress=18 INIT_VERSION=sysvinit-2.82 REDIRECT=/dev/tty1 COLUMNS=128 PATH=/bin:/sbin:/usr/bin:/usr/sbin vga=792 RUNLEVEL=5 PWD=/ PREVLEVEL=N LINES=48 SHLVL=2 HOME=/ sscripts=33 _=/sbin/startproc DAEMON=/sbin/klogd ]
done
<notice>exit status of (syslog) is (0)
<notice>start services (hotplug)
Starting hotplugging services [ ieee1394 net pci usb .. ]done
<notice>exit status of (hotplug) is (0)
<notice>start services (resmgr)
Starting resource manager<notice>startproc: execve (/sbin/resmgrd) [ /sbin/resmgrd ], [ CONSOLE=/dev/console SHELL=/bin/sh TERM=linux progress=20 INIT_VERSION=sysvinit-2.82 REDIRECT=/dev/tty1 COLUMNS=128 PATH=/bin:/sbin:/usr/bin:/usr/sbin vga=792 RUNLEVEL=5 PWD=/ PREVLEVEL=N LINES=48 SHLVL=2 HOME=/ sscripts=33 _=/sbin/startproc DAEMON=/sbin/resmgrd ]
done
<notice>exit status of (resmgr) is (0)
<notice>start services (splash_early)
<notice>exit status of (splash_early) is (0)
<notice>start services (sshd named fbset)
<notice>startproc: execve (/usr/sbin/sshd) [ /usr/sbin/sshd -o PidFile=/var/run/sshd.init.pid ], [ CONSOLE=/dev/console SHELL=/bin/sh TERM=linux progress=22 INIT_VERSION=sysvinit-2.82 REDIRECT=/dev/tty1 COLUMNS=128 PATH=/bin:/sbin:/usr/bin:/usr/sbin vga=792 RUNLEVEL=5 PWD=/ PREVLEVEL=N LINES=48 SHLVL=2 HOME=/ sscripts=33 _=/sbin/startproc DAEMON=/usr/sbin/sshd ]
Starting SSH daemondone
Starting name server BIND 9 - Warning: /var/lib/named/var/run/named/named.pid exists! <notice>startproc: execve (/usr/sbin/named) [ /usr/sbin/named -t /var/lib/named -u named ], [ CONSOLE=/dev/console SHELL=/bin/sh TERM=linux progress=22 INIT_VERSION=sysvinit-2.82 REDIRECT=/dev/tty1 COLUMNS=128 PATH=/sbin:/usr/sbin:/bin:/usr/bin vga=792 RUNLEVEL=5 PWD=/ PREVLEVEL=N LINES=48 SHLVL=2 HOME=/ sscripts=33 _=/sbin/startproc DAEMON=/usr/sbin/named ]
done
<notice>exit status of (sshd named fbset) is (0 0 0)
<notice>start services (splash kbd cups)
<notice>startproc: execve (/usr/sbin/cupsd) [ /usr/sbin/cupsd ], [ CONSOLE=/dev/console SHELL=/bin/sh TERM=linux progress=25 INIT_VERSION=sysvinit-2.82 REDIRECT=/dev/tty1 COLUMNS=128 PATH=/bin:/sbin:/usr/bin:/usr/sbin vga=792 RUNLEVEL=5 PWD=/ PREVLEVEL=N LINES=48 SHLVL=2 HOME=/ sscripts=33 _=/sbin/startproc DAEMON=/usr/sbin/cupsd ]
Starting cupsddone
Loading keymap qwerty/pl.map.gz
doneLoading compose table latin2done
Stop Unicode mode
doneLoading console font lat2-16.psfu  -m none (B
done<notice>exit status of (splash kbd cups) is (5 0 0)
<notice>start services (smpppd postfix)
<notice>startproc: execve (/usr/sbin/smpppd) [ /usr/sbin/smpppd ], [ CONSOLE=/dev/console SHELL=/bin/sh TERM=linux progress=28 INIT_VERSION=sysvinit-2.82 REDIRECT=/dev/tty1 COLUMNS=128 PATH=/bin:/sbin:/usr/bin:/usr/sbin vga=792 RUNLEVEL=5 PWD=/ PREVLEVEL=N LINES=48 SHLVL=2 HOME=/ sscripts=33 _=/sbin/startproc DAEMON=/usr/sbin/smpppd ]
Starting SMPPPDdone
Starting mail service (Postfix)done
<notice>exit status of (smpppd postfix) is (0 0)
<notice>start services (xdm)
Starting service kdm<notice>startproc: execve (/opt/kde3/bin/kdm) [ /opt/kde3/bin/kdm ], [ LC_MONETARY= CONSOLE=/dev/console SHELL=/bin/sh TERM=linux LC_NUMERIC= QTDIR=/usr/lib/qt3 LC_ALL= progress=30 INIT_VERSION=sysvinit-2.82 KDEROOTHOME=/root/.kdm REDIRECT=/dev/tty1 COLUMNS=128 PATH=/bin:/sbin:/usr/bin:/usr/sbin LC_MESSAGES= vga=792 RUNLEVEL=5 LC_COLLATE= PWD=/ LANG=en_US PREVLEVEL=N LINES=48 SHLVL=2 HOME=/ XCURSOR_THEME=blueprint-cursor-theme no_proxy=localhost WINDOWMANAGER=/usr/X11R6/bin/kde LC_CTYPE=en_US sscripts=33 LC_TIME= _=/sbin/startproc DAEMON=/opt/kde3/bin/kdm ]
done
<notice>exit status of (xdm) is (0)
<notice>start services (dhcpd cron)
<notice>startproc: execve (/usr/sbin/cron) [ /usr/sbin/cron ], [ CONSOLE=/dev/console SHELL=/bin/sh TERM=linux progress=31 INIT_VERSION=sysvinit-2.82 REDIRECT=/dev/tty1 COLUMNS=128 PATH=/bin:/sbin:/usr/bin:/usr/sbin vga=792 RUNLEVEL=5 PWD=/ PREVLEVEL=N LINES=48 SHLVL=2 HOME=/ sscripts=33 _=/sbin/startproc DAEMON=/usr/sbin/cron ]
Starting CRON daemondone
Starting DHCP server <notice>startproc: execve (/usr/sbin/dhcpd) [ /usr/sbin/dhcpd -chroot /var/lib/dhcp/ -lf /dhcpd.leases -user nobody -group nogroup eth0 ], [ CONSOLE=/dev/console SHELL=/bin/sh TERM=linux progress=31 INIT_VERSION=sysvinit-2.82 REDIRECT=/dev/tty1 COLUMNS=128 PATH=/bin:/sbin:/usr/bin:/usr/sbin vga=792 RUNLEVEL=5 PWD=/ PREVLEVEL=N LINES=48 SHLVL=2 HOME=/ sscripts=33 _=/sbin/startproc DAEMON=/usr/sbin/dhcpd ]
[chroot]done
<notice>exit status of (dhcpd cron) is (0 0)
<notice>start services (splash_late)
<notice>exit status of (splash_late) is (0)
Master Resource Control: runlevel 5 has been reached
Skipped services in runlevel 5: splash
<notice>killproc: kill(470,3)

--Boundary-00=_Ns7FAylOcMe1QV0
Content-Type: text/plain;
  charset="iso-8859-2";
  name="kernel-config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="kernel-config"

#
# Automatically generated make config: don't edit
#
CONFIG_X86_64=y
CONFIG_X86=y
# CONFIG_ISA is not set
# CONFIG_SBUS is not set
# CONFIG_UID16 is not set
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_X86_CMPXCHG=y
CONFIG_EARLY_PRINTK=y

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y

#
# Loadable module support
#
CONFIG_MODULES=y
# CONFIG_MODVERSIONS is not set
CONFIG_KMOD=y

#
# Processor type and features
#
CONFIG_MK8=y
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_MATH_EMULATION is not set
# CONFIG_MCA is not set
# CONFIG_EISA is not set
CONFIG_X86_IO_APIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_MTRR=y
CONFIG_SMP=y
CONFIG_HPET_TIMER=y
CONFIG_GART_IOMMU=y
CONFIG_HAVE_DEC_LOCK=y
CONFIG_NR_CPUS=2
CONFIG_MCE=y
CONFIG_K8_NUMA=y
CONFIG_DISCONTIGMEM=y
CONFIG_NUMA=y

#
# General setup
#
CONFIG_NET=y
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_NAMES=y
CONFIG_HOTPLUG=y

#
# PCMCIA/CardBus support
#
# CONFIG_PCMCIA is not set

#
# PCI Hotplug Support
#
# CONFIG_HOTPLUG_PCI is not set
CONFIG_SYSVIPC=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_SYSCTL=y
CONFIG_KCORE_ELF=y
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_MISC=m
CONFIG_PM=y
CONFIG_IA32_EMULATION=y

#
# ACPI Support
#
CONFIG_ACPI=y
CONFIG_ACPI_BOOT=y
CONFIG_ACPI_BUS=y
CONFIG_ACPI_INTERPRETER=y
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_PCI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_SYSTEM=y
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_RELAXED_AML is not set

#
# Memory Technology Devices (MTD)
#
# CONFIG_MTD is not set

#
# Parallel port support
#
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_PC_CML1=m
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_AMIGA is not set
# CONFIG_PARPORT_MFC3 is not set
# CONFIG_PARPORT_ATARI is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_SUNBPP is not set
# CONFIG_PARPORT_IP22 is not set
# CONFIG_PARPORT_OTHER is not set
CONFIG_PARPORT_1284=y

#
# Block devices
#
CONFIG_BLK_DEV_FD=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
CONFIG_BLK_DEV_LOOP=m
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_STATS=y

#
# Multi-device support (RAID and LVM)
#
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=y
CONFIG_MD_RAID5=y
CONFIG_MD_MULTIPATH=y
# CONFIG_BLK_DEV_LVM is not set

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_NETLINK_DEV=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_FILTER=y
CONFIG_UNIX=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
CONFIG_INET_ECN=y
CONFIG_SYN_COOKIES=y

#
#   IP: Netfilter Configuration
#
CONFIG_IP_NF_CONNTRACK=y
CONFIG_IP_NF_FTP=y
CONFIG_IP_NF_AMANDA=y
CONFIG_IP_NF_TFTP=y
CONFIG_IP_NF_IRC=y
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_LIMIT=m
CONFIG_IP_NF_MATCH_MAC=m
CONFIG_IP_NF_MATCH_PKTTYPE=m
CONFIG_IP_NF_MATCH_MARK=m
CONFIG_IP_NF_MATCH_MULTIPORT=m
CONFIG_IP_NF_MATCH_TOS=m
CONFIG_IP_NF_MATCH_RECENT=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_DSCP=m
CONFIG_IP_NF_MATCH_AH_ESP=m
CONFIG_IP_NF_MATCH_LENGTH=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_MATCH_TCPMSS=m
CONFIG_IP_NF_MATCH_HELPER=m
CONFIG_IP_NF_MATCH_STATE=m
CONFIG_IP_NF_MATCH_CONNTRACK=m
CONFIG_IP_NF_MATCH_UNCLEAN=m
CONFIG_IP_NF_MATCH_OWNER=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_MIRROR=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_NAT_AMANDA=m
CONFIG_IP_NF_NAT_LOCAL=y
CONFIG_IP_NF_NAT_SNMP_BASIC=m
CONFIG_IP_NF_NAT_IRC=m
CONFIG_IP_NF_NAT_FTP=m
CONFIG_IP_NF_NAT_TFTP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_TOS=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_DSCP=m
CONFIG_IP_NF_TARGET_MARK=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_IP_NF_TARGET_TCPMSS=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
#   IP: Virtual Server Configuration
#
CONFIG_IP_VS=m
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
# CONFIG_IPV6 is not set
# CONFIG_KHTTPD is not set

#
#    SCTP Configuration (EXPERIMENTAL)
#
CONFIG_IPV6_SCTP__=y
# CONFIG_IP_SCTP is not set
# CONFIG_ATM is not set
# CONFIG_VLAN_8021Q is not set

#
#  
#
# CONFIG_IPX is not set
# CONFIG_ATALK is not set

#
# Appletalk devices
#
# CONFIG_DECNET is not set
# CONFIG_BRIDGE is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_LLC is not set
# CONFIG_NET_DIVERT is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_FASTROUTE is not set
# CONFIG_NET_HW_FLOWCONTROL is not set

#
# QoS and/or fair queueing
#
# CONFIG_NET_SCHED is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=m

#
# Telephony Support
#
# CONFIG_PHONE is not set

#
# ATA/IDE/MFM/RLL support
#
CONFIG_IDE=y

#
# IDE, ATA and ATAPI Block devices
#
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_HD_IDE is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_IDEDISK=m
# CONFIG_IDEDISK_MULTI_MODE is not set
# CONFIG_IDEDISK_STROKE is not set
CONFIG_BLK_DEV_IDECD=m
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
CONFIG_BLK_DEV_IDESCSI=m
# CONFIG_IDE_TASK_IOCTL is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_ISAPNP is not set
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_BLK_DEV_GENERIC=y
CONFIG_IDEPCI_SHARE_IRQ=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_IDEDMA_FORCED is not set
CONFIG_IDEDMA_PCI_AUTO=y
# CONFIG_IDEDMA_ONLYDISK is not set
CONFIG_BLK_DEV_IDEDMA=y
# CONFIG_IDEDMA_PCI_WIP is not set
# CONFIG_BLK_DEV_ADMA100 is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=y
# CONFIG_AMD74XX_OVERRIDE is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_RZ1000 is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
CONFIG_IDEDMA_AUTO=y
CONFIG_IDEDMA_IVB=y
# CONFIG_DMA_NONPCI is not set
CONFIG_BLK_DEV_IDE_MODES=y
# CONFIG_BLK_DEV_ATARAID is not set

#
# SCSI support
#
CONFIG_SCSI=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_SD_EXTRA_DEVS=40
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_SR_EXTRA_DEVS=2
CONFIG_CHR_DEV_SG=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_DEBUG_QUEUES is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y

#
# SCSI low-level drivers
#
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AHA152X is not set
# CONFIG_SCSI_AHA1542 is not set
# CONFIG_SCSI_AHA1740 is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=253
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
# CONFIG_AIC7XXX_PROBE_EISA_VL is not set
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_IN2000 is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_MEGARAID is not set
# CONFIG_SCSI_MEGARAID2 is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_CPQFCTS is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_EATA_DMA is not set
# CONFIG_SCSI_EATA_PIO is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_NCR53C7xx is not set
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_IOMAPPED is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_PCI2000 is not set
# CONFIG_SCSI_PCI2220I is not set
# CONFIG_SCSI_PSI240I is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
# CONFIG_SCSI_QLOGIC_ISP is not set
# CONFIG_SCSI_QLOGIC_FC is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_SEAGATE is not set
# CONFIG_SCSI_SIM710 is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
# CONFIG_SCSI_NSP32 is not set
CONFIG_SCSI_DEBUG=m

#
# Fusion MPT device support
#
# CONFIG_FUSION is not set
# CONFIG_FUSION_BOOT is not set
# CONFIG_FUSION_ISENSE is not set
# CONFIG_FUSION_CTL is not set
# CONFIG_FUSION_LAN is not set

#
# IEEE 1394 (FireWire) support (EXPERIMENTAL)
#
CONFIG_IEEE1394=m

#
# Device Drivers
#

#
#   Texas Instruments PCILynx requires I2C bit-banging
#
CONFIG_IEEE1394_OHCI1394=m

#
# Protocol Drivers
#
CONFIG_IEEE1394_VIDEO1394=m
CONFIG_IEEE1394_SBP2=m
CONFIG_IEEE1394_SBP2_PHYS_DMA=y
CONFIG_IEEE1394_ETH1394=m
CONFIG_IEEE1394_DV1394=m
CONFIG_IEEE1394_RAWIO=m
CONFIG_IEEE1394_CMP=m
CONFIG_IEEE1394_AMDTP=m
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
# CONFIG_IEEE1394_OUI_DB is not set

#
# Network device support
#
CONFIG_NETDEVICES=y

#
# ARCnet devices
#
# CONFIG_ARCNET is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_ETHERTAP is not set

#
# Ethernet (10 or 100Mbit)
#
CONFIG_NET_ETHERNET=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=m
# CONFIG_TYPHOON is not set
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_NET_VENDOR_RACAL is not set
# CONFIG_HP100 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
# CONFIG_TULIP is not set
# CONFIG_DE4X5 is not set
# CONFIG_DGRS is not set
# CONFIG_DM9102 is not set
# CONFIG_EEPRO100 is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
CONFIG_8139TOO=m
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=y
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_NET_POCKET is not set

#
# Ethernet (1000 Mbit)
#
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SK98LIN is not set
CONFIG_TIGON3=m
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=m
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPPOE=m
# CONFIG_SLIP is not set

#
# Wireless LAN (non-hamradio)
#
# CONFIG_NET_RADIO is not set

#
# Token Ring devices
#
# CONFIG_TR is not set
# CONFIG_NET_FC is not set
# CONFIG_RCPCI is not set
# CONFIG_SHAPER is not set

#
# Wan interfaces
#
# CONFIG_WAN is not set

#
# Amateur Radio support
#
# CONFIG_HAMRADIO is not set

#
# IrDA (infrared) support
#
# CONFIG_IRDA is not set

#
# ISDN subsystem
#
# CONFIG_ISDN is not set

#
# Input core support
#
CONFIG_INPUT=y
CONFIG_INPUT_KEYBDEV=y
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_UINPUT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_SERIAL=y
CONFIG_SERIAL_CONSOLE=y
CONFIG_SERIAL_EXTENDED=y
# CONFIG_SERIAL_MANY_PORTS is not set
CONFIG_SERIAL_SHARE_IRQ=y
# CONFIG_SERIAL_DETECT_IRQ is not set
# CONFIG_SERIAL_MULTIPORT is not set
# CONFIG_HUB6 is not set
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_UNIX98_PTYS=y
CONFIG_UNIX98_PTY_COUNT=256
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
# CONFIG_TIPAR is not set

#
# I2C support
#
# CONFIG_I2C is not set

#
# Mice
#
# CONFIG_BUSMOUSE is not set
CONFIG_MOUSE=y
CONFIG_PSMOUSE=y
# CONFIG_82C710_MOUSE is not set
# CONFIG_PC110_PAD is not set
# CONFIG_MK712_MOUSE is not set

#
# Joysticks
#
# CONFIG_INPUT_GAMEPORT is not set
# CONFIG_INPUT_SERIO is not set

#
# Joysticks
#
# CONFIG_INPUT_IFORCE_USB is not set
# CONFIG_INPUT_DB9 is not set
# CONFIG_INPUT_GAMECON is not set
# CONFIG_INPUT_TURBOGRAFX is not set
# CONFIG_QIC02_TAPE is not set
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_KCS=m
# CONFIG_IPMI_WATCHDOG is not set

#
# Watchdog Cards
#
# CONFIG_WATCHDOG is not set
# CONFIG_SCx200 is not set
CONFIG_AMD_RNG=y
# CONFIG_INTEL_RNG is not set
CONFIG_HW_RANDOM=y
# CONFIG_AMD_PM768 is not set
CONFIG_NVRAM=m
CONFIG_RTC=y
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# Ftape, the floppy tape device driver
#
# CONFIG_FTAPE is not set
CONFIG_AGP_AMD_K8=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_I810 is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_ATI is not set

#
# Direct Rendering Manager (XFree86 DRI support)
#
# CONFIG_DRM is not set
# CONFIG_MWAVE is not set
# CONFIG_OBMOUSE is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set

#
# File systems
#
CONFIG_QUOTA=y
CONFIG_QFMT_V2=y
CONFIG_AUTOFS_FS=y
CONFIG_AUTOFS4_FS=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
CONFIG_EXT3_FS=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
# CONFIG_UMSDOS_FS is not set
CONFIG_VFAT_FS=m
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
CONFIG_TMPFS=y
CONFIG_RAMFS=y
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_JFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_NTFS_FS is not set
# CONFIG_HPFS_FS is not set
CONFIG_PROC_FS=y
CONFIG_DEVPTS_FS=y
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_EXT2_FS=y
# CONFIG_SYSV_FS is not set
CONFIG_UDF_FS=m
# CONFIG_UDF_RW is not set
# CONFIG_UFS_FS is not set
# CONFIG_XFS_FS is not set

#
# Network File Systems
#
# CONFIG_CODA_FS is not set
# CONFIG_INTERMEZZO_FS is not set
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_DIRECTIO=y
CONFIG_NFSD=m
CONFIG_NFSD_V3=y
CONFIG_NFSD_TCP=y
CONFIG_SUNRPC=m
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_SMB_FS=m
CONFIG_SMB_NLS_DEFAULT=y
CONFIG_SMB_NLS_REMOTE="cp852"
# CONFIG_NCP_FS is not set
CONFIG_ZISOFS_FS=m

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_SMB_NLS=y
CONFIG_NLS=y

#
# Native Language Support
#
CONFIG_NLS_DEFAULT="iso8859-2"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y

#
# Console drivers
#
CONFIG_VGA_CONSOLE=y
CONFIG_VIDEO_SELECT=y
# CONFIG_MDA_CONSOLE is not set

#
# Frame-buffer support
#
CONFIG_FB=y
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FB_RIVA is not set
# CONFIG_FB_CLGEN is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_VESA=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_HGA is not set
CONFIG_VIDEO_SELECT=y
# CONFIG_FB_MATROX is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_IT8181 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FBCON_ADVANCED is not set
CONFIG_FBCON_CFB8=y
CONFIG_FBCON_CFB16=y
CONFIG_FBCON_CFB24=y
CONFIG_FBCON_CFB32=y
# CONFIG_FBCON_FONTWIDTH8_ONLY is not set
CONFIG_FBCON_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set

#
# Sound
#
CONFIG_SOUND=m
# CONFIG_SOUND_ALI5455 is not set
# CONFIG_SOUND_BT878 is not set
# CONFIG_SOUND_CMPCI is not set
# CONFIG_SOUND_EMU10K1 is not set
# CONFIG_SOUND_FUSION is not set
# CONFIG_SOUND_CS4281 is not set
# CONFIG_SOUND_ES1370 is not set
# CONFIG_SOUND_ES1371 is not set
# CONFIG_SOUND_ESSSOLO1 is not set
# CONFIG_SOUND_MAESTRO is not set
# CONFIG_SOUND_MAESTRO3 is not set
# CONFIG_SOUND_FORTE is not set
CONFIG_SOUND_ICH=m
# CONFIG_SOUND_RME96XX is not set
# CONFIG_SOUND_SONICVIBES is not set
# CONFIG_SOUND_TRIDENT is not set
# CONFIG_SOUND_MSNDCLAS is not set
# CONFIG_SOUND_MSNDPIN is not set
# CONFIG_SOUND_VIA82CXXX is not set
# CONFIG_SOUND_OSS is not set
# CONFIG_SOUND_AD1980 is not set
# CONFIG_SOUND_WM97XX is not set

#
# USB support
#
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_BANDWIDTH=y

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=m
# CONFIG_USB_UHCI is not set
# CONFIG_USB_UHCI_ALT is not set
CONFIG_USB_OHCI=m

#
# USB Device Class drivers
#
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_BLUETOOTH is not set
# CONFIG_USB_MIDI is not set
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_HP8200e=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=m

#
# USB Human Interface Devices (HID)
#
CONFIG_USB_HID=m
CONFIG_USB_HIDINPUT=y
CONFIG_USB_HIDDEV=y
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set
# CONFIG_USB_AIPTEK is not set
# CONFIG_USB_WACOM is not set
# CONFIG_USB_KBTAB is not set
# CONFIG_USB_POWERMATE is not set

#
# USB Imaging devices
#
CONFIG_USB_DC2XX=m
CONFIG_USB_MDC800=m
CONFIG_USB_SCANNER=m
# CONFIG_USB_MICROTEK is not set
CONFIG_USB_HPUSBSCSI=m

#
# USB Multimedia devices
#

#
#   Video4Linux support is needed for USB Multimedia device support
#

#
# USB Network adaptors
#
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_CATC is not set
# CONFIG_USB_AX8817X is not set
# CONFIG_USB_CDCETHER is not set
# CONFIG_USB_USBNET is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set

#
# USB Serial Converter support
#
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OMNINET is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_TIGL is not set
# CONFIG_USB_BRLVGER is not set
# CONFIG_USB_LCD is not set

#
# Support for USB gadgets
#
# CONFIG_USB_GADGET is not set

#
# Bluetooth support
#
# CONFIG_BLUEZ is not set

#
# Cryptographic options
#
CONFIG_CRYPTO=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_TEST=m

#
# Kernel hacking
#
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SLAB is not set
CONFIG_MAGIC_SYSRQ=y
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_CHECKING is not set
# CONFIG_INIT_DEBUG is not set
CONFIG_IOMMU_DEBUG=y
CONFIG_IOMMU_LEAK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_LOG_BUF_SHIFT=17

#
# Library routines
#
CONFIG_CRC32=m
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
# CONFIG_FW_LOADER is not set

--Boundary-00=_Ns7FAylOcMe1QV0--

