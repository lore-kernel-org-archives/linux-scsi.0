From: "George Spelvin" <linux@horizon.com>
Subject: Hard lockup during intense reads from BR10i
Date: 14 Oct 2013 05:08:18 -0400
Message-ID: <20131014090818.28591.qmail@science.horizon.com>
References: <20131013134256.15088.qmail@science.horizon.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:17877 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754510Ab3JNJIY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Oct 2013 05:08:24 -0400
In-Reply-To: <20131013134256.15088.qmail@science.horizon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: DL-MPTFusionLinux@lsi.com, kashyap.desai@lsi.com, linux-scsi@vger.kernel.org, Nagalakshmi.Nandigama@lsi.com
Cc: linux@horizon.com

[This is a repost with redacted boot messages, because the full ones
broke vger's 100K message limit. "(...)" marks elisions.]

This problem is being a bit of a PITA.  Basically, during heavy activity
on multiple drives (originally a RAID rebuild, but since repeated using
6 parallel badblocks(8) reads), the machine locks up.  Hard enough that
the PS/2 keyboard stops responding.  Usually, this is silent, even though
I'm running from a text console.  Once, I got the message:

[  697.454935] mptscsih: ioc0: attempting task abort! (sc=ffff88023270af00)
[  697.455639] sd 14:0:3:0: [sdf] CDB:
[  697.456913] Read(10): 28 00 05 b0 7e 00 00 00 80 00

on the screen just before everything stopped responding.

The most interesting thing is that, if I'm plugged into a network, the
e1000e gigabit ethernet driver does *something* which manages to DoS the
office network.  I get >5000 ms ping times across a single gigabit switch.
If I plug it into a 100baseT switch downstream from the gigabit, it still
manages the same, but it takes a few minutes for the DoS to take hold.
(The instant I unplug the ethernet cable, ping times return to the normal
<1 ms range.  No, I haven't sniffed to see what the traffic is yet.)

I'm not sure how useful that information is, but I figured I'd mention it,
since it is distinctly odd, and possibly points to some PCIe-level hardware
problem.


In more detail, I have a RAID-6 array consisting of 7 2TB SATA drives
(Toshiba/Hitachi) connected to one of those BR10i controllers that were
all over eBay recently.  I built the array, put data on it, and things
were working fine.

Until I had a drive fail, and after replacing it I started getting
screams about the network being down.  Let's just say I had some very
POed users until I figured out the need to unplug that ethernet cable.

Then I started trying to figure out why my machine had locked up.
Memtest86+ revealed some bad RAM (which had previously passed 24 hours
of mprime/prime95 torture test), which got blamed and pulled, but the
problem continued.  Then I moved the rebuilding drive to a motherboard
SATA port, to avoid mptsas writes, but that still locked up.  Then I
abandoned RAID entirely and just ran 6 copies of badblocks (Default
parameters).  A few minutes of 125 MB/s from each drive, and Urk!

This is with the RAID array unmounted, and there's nothing else on
the drives to cause activity.  I *do* have smartd running, which
generates some SATA traffic.

The root file system is on a different RAID-1 array (/dev/sd[ab]2)
connected to the motherboard SATA ports.

Right now, I'm just casting about for ways to get more information; a
silent hard lockup is hard to learn much from.  Is there some debugging
I can enable that won't be useless at high I/O rates?  I'm thinking of
trying some old kernels in the hope I can find a bisectable regression.
Any other ideas?


Since I have nothing else to offer, let me describe the machine in detail.
It's a Gigabyte X79-UP4 motherboard, with the F2 (07/16/2012) BIOS.
2x4G DDR3-1600 SDRAM.  (Was 4x4G, but 8G is in RMA.)

Processor is an i7-3930K.  Everything is at stock speeds (although the
DRAM defaults to 1333 and needs "XMP profile 1" selected for 1600),
and the machine has been generally stable for 2013 so far.  I'm running
mprime torture test on 5G of RAM right now, about 3 hours in.

Full lspci -nn is:
("(...)" denotes a copy of the previous line)

00:00.0 Host bridge [0600]: Intel Corporation Xeon E5/Core i7 DMI2 [8086:3c00] (rev 07)
00:01.0 PCI bridge [0604]: (...) i7 IIO PCI Express Root Port 1a [8086:3c02] (rev 07)
00:02.0 PCI bridge [0604]: (...) i7 IIO PCI Express Root Port 2a [8086:3c04] (rev 07)
00:03.0 PCI bridge [0604]: (...) i7 IIO PCI Express Root Port 3a in PCI Express Mode [8086:3c08] (rev 07)
00:04.0 System peripheral [0880]: (...) i7 DMA Channel 0 [8086:3c20] (rev 07)
00:04.1 System peripheral [0880]: (...) i7 DMA Channel 1 [8086:3c21] (rev 07)
00:04.2 System peripheral [0880]: (...) i7 DMA Channel 2 [8086:3c22] (rev 07)
00:04.3 System peripheral [0880]: (...) i7 DMA Channel 3 [8086:3c23] (rev 07)
00:04.4 System peripheral [0880]: (...) i7 DMA Channel 4 [8086:3c24] (rev 07)
00:04.5 System peripheral [0880]: (...) i7 DMA Channel 5 [8086:3c25] (rev 07)
00:04.6 System peripheral [0880]: (...) i7 DMA Channel 6 [8086:3c26] (rev 07)
00:04.7 System peripheral [0880]: (...) i7 DMA Channel 7 [8086:3c27] (rev 07)
00:05.0 System peripheral [0880]: (...) i7 Address Map, VTd_Misc, System Management [8086:3c28] (rev 07)
00:05.2 System peripheral [0880]: (...) i7 Control Status and Global Errors [8086:3c2a] (rev 07)
00:05.4 PIC [0800]: (...) i7 I/O APIC [8086:3c2c] (rev 07)
00:11.0 PCI bridge [0604]: Intel Corporation C600/X79 series chipset PCI Express Virtual Root Port [8086:1d3e] (rev 06)
00:16.0 Communication controller [0780]: (...) chipset MEI Controller #1 [8086:1d3a] (rev 05)
00:19.0 Ethernet controller [0200]: Intel Corporation 82579LM Gigabit Network Connection [8086:1502] (rev 06)
00:1a.0 USB controller [0c03]: Intel Corporation C600/X79 series chipset USB2 Enhanced Host Controller #2 [8086:1d2d] (rev 06)
00:1b.0 Audio device [0403]: (...) chipset High Definition Audio Controller [8086:1d20] (rev 06)
00:1c.0 PCI bridge [0604]: (...) chipset PCI Express Root Port 1 [8086:1d10] (rev b6)
00:1c.1 PCI bridge [0604]: (...) chipset PCI Express Root Port 2 [8086:1d12] (rev b6)
00:1c.2 PCI bridge [0604]: (...) chipset PCI Express Root Port 3 [8086:1d14] (rev b6)
00:1c.3 PCI bridge [0604]: (...) chipset PCI Express Root Port 4 [8086:1d16] (rev b6)
00:1c.5 PCI bridge [0604]: (...) chipset PCI Express Root Port 6 [8086:1d1a] (rev b6)
00:1c.6 PCI bridge [0604]: (...) chipset PCI Express Root Port 7 [8086:1d1c] (rev b6)
00:1c.7 PCI bridge [0604]: (...) chipset PCI Express Root Port 8 [8086:1d1e] (rev b6)
00:1d.0 USB controller [0c03]: (...) chipset USB2 Enhanced Host Controller #1 [8086:1d26] (rev 06)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev a6)
00:1f.0 ISA bridge [0601]: Intel Corporation C600/X79 series chipset LPC Controller [8086:1d41] (rev 06)
00:1f.2 SATA controller [0106]: (...) chipset 6-Port SATA AHCI Controller [8086:1d02] (rev 06)
00:1f.3 SMBus [0c05]: (...) chipset SMBus Host Controller [8086:1d22] (rev 06)
02:00.0 VGA compatible controller [0300]: NVIDIA Corporation GT216 [GeForce 210] [10de:0a23] (rev a2)
02:00.1 Audio device [0403]: NVIDIA Corporation High Definition Audio Controller [10de:0be2] (rev a1)
03:00.0 SCSI storage controller [0100]: LSI Logic / Symbios Logic SAS1068E PCI-Express Fusion-MPT SAS [1000:0058] (rev 08)
05:00.0 SATA controller [0106]: Marvell Technology Group Ltd. 88SE9172 SATA 6Gb/s Controller [1b4b:9172] (rev 11)
06:00.0 SATA controller [0106]: (...) 88SE9172 SATA 6Gb/s Controller [1b4b:9172] (rev 11)
07:00.0 SATA controller [0106]: (...) 88SE9172 SATA 6Gb/s Controller [1b4b:9172] (rev 11)
09:00.0 USB controller [0c03]: Fresco Logic FL1009 USB 3.0 Host Controller [1b73:1009] (rev 02)
0a:00.0 USB controller [0c03]: Fresco Logic FL1009 USB 3.0 Host Controller [1b73:1009] (rev 02)
0c:00.0 Mass storage controller [0180]: Promise Technology, Inc. PDC20268 [Ultra100 TX2] [105a:4d68] (rev 01)
ff:08.0 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 QPI Link 0 [8086:3c80] (rev 07)
ff:08.3 System peripheral [0880]: (...) i7 QPI Link Reut 0 [8086:3c83] (rev 07)
ff:08.4 System peripheral [0880]: (...) i7 QPI Link Reut 0 [8086:3c84] (rev 07)
ff:09.0 System peripheral [0880]: (...) i7 QPI Link 1 [8086:3c90] (rev 07)
ff:09.3 System peripheral [0880]: (...) i7 QPI Link Reut 1 [8086:3c93] (rev 07)
ff:09.4 System peripheral [0880]: (...) i7 QPI Link Reut 1 [8086:3c94] (rev 07)
ff:0a.0 System peripheral [0880]: (...) i7 Power Control Unit 0 [8086:3cc0] (rev 07)
ff:0a.1 System peripheral [0880]: (...) i7 Power Control Unit 1 [8086:3cc1] (rev 07)
ff:0a.2 System peripheral [0880]: (...) i7 Power Control Unit 2 [8086:3cc2] (rev 07)
ff:0a.3 System peripheral [0880]: (...) i7 Power Control Unit 3 [8086:3cd0] (rev 07)
ff:0b.0 System peripheral [0880]: (...) i7 Interrupt Control Registers [8086:3ce0] (rev 07)
ff:0b.3 System peripheral [0880]: (...) i7 Semaphore and Scratchpad Configuration Registers [8086:3ce3] (rev 07)
ff:0c.0 System peripheral [0880]: (...) i7 Unicast Register 0 [8086:3ce8] (rev 07)
ff:0c.1 System peripheral [0880]: (...) i7 Unicast Register 0 [8086:3ce8] (rev 07)
ff:0c.2 System peripheral [0880]: (...) i7 Unicast Register 0 [8086:3ce8] (rev 07)
ff:0c.6 System peripheral [0880]: (...) i7 Integrated Memory Controller System Address Decoder 0 [8086:3cf4] (rev 07)
ff:0c.7 System peripheral [0880]: (...) i7 System Address Decoder [8086:3cf6] (rev 07)
ff:0d.0 System peripheral [0880]: (...) i7 Unicast Register 0 [8086:3ce8] (rev 07)
ff:0d.1 System peripheral [0880]: (...) i7 Unicast Register 0 [8086:3ce8] (rev 07)
ff:0d.2 System peripheral [0880]: (...) i7 Unicast Register 0 [8086:3ce8] (rev 07)
ff:0d.6 System peripheral [0880]: (...) i7 Integrated Memory Controller System Address Decoder 1 [8086:3cf5] (rev 07)
ff:0e.0 System peripheral [0880]: (...) i7 Processor Home Agent [8086:3ca0] (rev 07)
ff:0e.1 Performance counters [1101]: (...) i7 Processor Home Agent Performance Monitoring [8086:3c46] (rev 07)
ff:0f.0 System peripheral [0880]: (...) i7 Integrated Memory Controller Registers [8086:3ca8] (rev 07)
ff:0f.1 System peripheral [0880]: (...) i7 Integrated Memory Controller RAS Registers [8086:3c71] (rev 07)
ff:0f.2 System peripheral [0880]: (...) i7 Integrated Memory Controller Target Address Decoder 0 [8086:3caa] (rev 07)
ff:0f.3 System peripheral [0880]: (...) i7 Integrated Memory Controller Target Address Decoder 1 [8086:3cab] (rev 07)
ff:0f.4 System peripheral [0880]: (...) i7 Integrated Memory Controller Target Address Decoder 2 [8086:3cac] (rev 07)
ff:0f.5 System peripheral [0880]: (...) i7 Integrated Memory Controller Target Address Decoder 3 [8086:3cad] (rev 07)
ff:0f.6 System peripheral [0880]: (...) i7 Integrated Memory Controller Target Address Decoder 4 [8086:3cae] (rev 07)
ff:10.0 System peripheral [0880]: (...) i7 Integrated Memory Controller Channel 0-3 Thermal Control 0 [8086:3cb0] (rev 07)
ff:10.1 System peripheral [0880]: (...) i7 Integrated Memory Controller Channel 0-3 Thermal Control 1 [8086:3cb1] (rev 07)
ff:10.2 System peripheral [0880]: (...) i7 Integrated Memory Controller ERROR Registers 0 [8086:3cb2] (rev 07)
ff:10.3 System peripheral [0880]: (...) i7 Integrated Memory Controller ERROR Registers 1 [8086:3cb3] (rev 07)
ff:10.4 System peripheral [0880]: (...) i7 Integrated Memory Controller Channel 0-3 Thermal Control 2 [8086:3cb4] (rev 07)
ff:10.5 System peripheral [0880]: (...) i7 Integrated Memory Controller Channel 0-3 Thermal Control 3 [8086:3cb5] (rev 07)
ff:10.6 System peripheral [0880]: (...) i7 Integrated Memory Controller ERROR Registers 2 [8086:3cb6] (rev 07)
ff:10.7 System peripheral [0880]: (...) i7 Integrated Memory Controller ERROR Registers 3 [8086:3cb7] (rev 07)
ff:11.0 System peripheral [0880]: (...) i7 DDRIO [8086:3cb8] (rev 07)
ff:13.0 System peripheral [0880]: (...) i7 R2PCIe [8086:3ce4] (rev 07)
ff:13.1 Performance counters [1101]: (...) i7 Ring to PCI Express Performance Monitor [8086:3c43] (rev 07)
ff:13.4 Performance counters [1101]: (...) i7 QuickPath Interconnect Agent Ring Registers [8086:3ce6] (rev 07)
ff:13.5 Performance counters [1101]: (...) i7 Ring to QuickPath Interconnect Link 0 Performance Monitor [8086:3c44] (rev 07)
ff:13.6 System peripheral [0880]: Intel (...) i7 Ring to QuickPath Interconnect Link 1 Performance Monitor [8086:3c45] (rev 07)

And here's the dmesg from a recent boot (which ended in a lockup).
To fit withing VGER's message size limit, I have edited out some stuff
which I'm pretty sure is irrelevant, like USB and nouveau initialization.
Also, PCI addresses starting with "0000:" have been edited down to "0:"
and a few other large blocks of leading zeros chopped down.

[ 0.000000] Initializing cgroup subsys cpu
[ 0.000000] Linux version 3.11.3-00045-g594a67a (user@host) (gcc version 4.8.1 (Debian 4.8.1-10) ) #296 SMP Wed Oct 2 05:18:20 EDT 2013
[ 0.000000] Command line: BOOT_IMAGE=Linux ro root=902 atkbd.softraw=0 libata.fua=1 no_console_suspend tsc_khz=3510135
[ 0.000000] e820: BIOS-provided physical RAM map:
[ 0.000000] BIOS-e820: [mem 0x000000000-0x00009e7ff] usable
[ 0.000000] BIOS-e820: [mem 0x00009e800-0x00009ffff] reserved
[ 0.000000] BIOS-e820: [mem 0x0000e0000-0x0000fffff] reserved
[ 0.000000] BIOS-e820: [mem 0x000100000-0x0bca45fff] usable
[ 0.000000] BIOS-e820: [mem 0x0bca46000-0x0bcb5ffff] ACPI NVS
[ 0.000000] BIOS-e820: [mem 0x0bcb60000-0x0bce8afff] reserved
[ 0.000000] BIOS-e820: [mem 0x0bce8b000-0x0bcf02fff] ACPI data
[ 0.000000] BIOS-e820: [mem 0x0bcf03000-0x0bcf33fff] reserved
[ 0.000000] BIOS-e820: [mem 0x0bcf34000-0x0bcf38fff] ACPI NVS
[ 0.000000] BIOS-e820: [mem 0x0bcf39000-0x0bcf57fff] reserved
[ 0.000000] BIOS-e820: [mem 0x0bcf58000-0x0bcf58fff] ACPI NVS
[ 0.000000] BIOS-e820: [mem 0x0bcf59000-0x0bcf5bfff] reserved
[ 0.000000] BIOS-e820: [mem 0x0bcf5c000-0x0bcf63fff] ACPI NVS
[ 0.000000] BIOS-e820: [mem 0x0bcf64000-0x0bcf8efff] reserved
[ 0.000000] BIOS-e820: [mem 0x0bcf8f000-0x0bd191fff] ACPI NVS
[ 0.000000] BIOS-e820: [mem 0x0bd192000-0x0bd486fff] usable
[ 0.000000] BIOS-e820: [mem 0x0bd487000-0x0bd7dafff] reserved
[ 0.000000] BIOS-e820: [mem 0x0bd7db000-0x0bd7fffff] usable
[ 0.000000] BIOS-e820: [mem 0x0e0000000-0x0efffffff] reserved
[ 0.000000] BIOS-e820: [mem 0x0fed1c000-0x0fed1ffff] reserved
[ 0.000000] BIOS-e820: [mem 0x0ff000000-0x0ffffffff] reserved
[ 0.000000] BIOS-e820: [mem 0x100000000-0x23fffffff] usable
[ 0.000000] NX (Execute Disable) protection: active
[ 0.000000] SMBIOS 2.7 present.
[ 0.000000] DMI: Gigabyte Technology Co., Ltd. To be filled by O.E.M./X79-UP4, BIOS F2 07/16/2012
[ 0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[ 0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[ 0.000000] No AGP bridge found
[ 0.000000] e820: last_pfn = 0x240000 max_arch_pfn = 0x400000000
[ 0.000000] MTRR default type: uncachable
[ 0.000000] MTRR fixed ranges enabled:
[ 0.000000]   00000-9FFFF write-back
[ 0.000000]   A0000-BFFFF uncachable
[ 0.000000]   C0000-D3FFF write-protect
[ 0.000000]   D4000-E7FFF uncachable
[ 0.000000]   E8000-FFFFF write-protect
[ 0.000000] MTRR variable ranges enabled:
[ 0.000000]   0 base 000000000000 mask 3FFE00000000 write-back
[ 0.000000]   1 base 000200000000 mask 3FFFC0000000 write-back
[ 0.000000]   2 base 0000BE000000 mask 3FFFFE000000 uncachable
[ 0.000000]   3 base 0000C0000000 mask 3FFFC0000000 uncachable
[ 0.000000]   4 disabled
[ 0.000000]   5 disabled
[ 0.000000]   6 disabled
[ 0.000000]   7 disabled
[ 0.000000]   8 disabled
[ 0.000000]   9 disabled
[ 0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[ 0.000000] e820: update [mem 0xbe000000-0xffffffff] usable ==> reserved
[ 0.000000] e820: last_pfn = 0xbd800 max_arch_pfn = 0x400000000
[ 0.000000] Scanning 1 areas for low memory corruption
[ 0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[ 0.000000] Using GB pages for direct mapping
[ 0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[ 0.000000]  [mem 0x00000000-0x000fffff] page 4k
[ 0.000000] BRK [0x0196f000, 0x0196ffff] PGTABLE
[ 0.000000] BRK [0x01970000, 0x01970fff] PGTABLE
[ 0.000000] BRK [0x01971000, 0x01971fff] PGTABLE
[ 0.000000] init_memory_mapping: [mem 0x23fe00000-0x23fffffff]
[ 0.000000]  [mem 0x23fe00000-0x23fffffff] page 1G
[ 0.000000] init_memory_mapping: [mem 0x23c000000-0x23fdfffff]
[ 0.000000]  [mem 0x23c000000-0x23fdfffff] page 1G
[ 0.000000] init_memory_mapping: [mem 0x200000000-0x23bffffff]
[ 0.000000]  [mem 0x200000000-0x23bffffff] page 1G
[ 0.000000] init_memory_mapping: [mem 0x00100000-0xbca45fff]
[ 0.000000]  [mem 0x00100000-0x001fffff] page 4k
[ 0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[ 0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[ 0.000000]  [mem 0x80000000-0xbc9fffff] page 2M
[ 0.000000]  [mem 0xbca00000-0xbca45fff] page 4k
[ 0.000000] init_memory_mapping: [mem 0xbd192000-0xbd486fff]
[ 0.000000]  [mem 0xbd192000-0xbd1fffff] page 4k
[ 0.000000]  [mem 0xbd200000-0xbd3fffff] page 2M
[ 0.000000]  [mem 0xbd400000-0xbd486fff] page 4k
[ 0.000000] BRK [0x01972000, 0x01972fff] PGTABLE
[ 0.000000] BRK [0x01973000, 0x01973fff] PGTABLE
[ 0.000000] init_memory_mapping: [mem 0xbd7db000-0xbd7fffff]
[ 0.000000]  [mem 0xbd7db000-0xbd7fffff] page 4k
[ 0.000000] BRK [0x01974000, 0x01974fff] PGTABLE
[ 0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[ 0.000000]  [mem 0x100000000-0x1ffffffff] page 1G
[ 0.000000] ACPI: RSDP 000f0490 00024 (v02 ALASKA)
[ 0.000000] ACPI: XSDT bce8b070 00064 (v01 ALASKA    A M I 01072009 AMI  00010013)
[ 0.000000] ACPI: FACP bce930f8 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
[ 0.000000] ACPI: DSDT bce8b168 07F8A (v02 ALASKA    A M I 00000000 INTL 20051117)
[ 0.000000] ACPI: FACS bcf61f80 00040
[ 0.000000] ACPI: APIC bce931f0 000B2 (v03 ALASKA    A M I 01072009 AMI  00010013)
[ 0.000000] ACPI: MCFG bce932a8 0003C (v01 ALASKA OEMMCFG. 01072009 MSFT 00000097)
[ 0.000000] ACPI: HPET bce932e8 00038 (v01 ALASKA    A M I 01072009 AMI. 00000004)
[ 0.000000] ACPI: SSDT bce93320 6F0C4 (v02  INTEL    CpuPm 00004000 INTL 20051117)
[ 0.000000] ACPI: MATS bcf023e8 00034 (v01 ALASKA    A M I 00000001 w?x2 00000000)
[ 0.000000] ACPI: DMAR bcf02420 000C4 (v01 A M I   OEMDMAR 00000001 INTL 00000001)
[ 0.000000] ACPI: MATS bcf024e8 00034 (v02 ALASKA    A M I 00000002 w?x2 00000000)
[ 0.000000] ACPI: Local APIC address 0xfee00000
[ 0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880237600000-ffff88023f5fffff] on node 0
[ 0.000000] Zone ranges:
[ 0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[ 0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[ 0.000000]   Normal   [mem 0x100000000-0x23fffffff]
[ 0.000000] Movable zone start for each node
[ 0.000000] Early memory node ranges
[ 0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[ 0.000000]   node   0: [mem 0x00100000-0xbca45fff]
[ 0.000000]   node   0: [mem 0xbd192000-0xbd486fff]
[ 0.000000]   node   0: [mem 0xbd7db000-0xbd7fffff]
[ 0.000000]   node   0: [mem 0x100000000-0x23fffffff]
[ 0.000000] On node 0 totalpages: 2084093
[ 0.000000]   DMA zone: 64 pages used for memmap
[ 0.000000]   DMA zone: 21 pages reserved
[ 0.000000]   DMA zone: 3997 pages, LIFO batch:0
[ 0.000000]   DMA32 zone: 12022 pages used for memmap
[ 0.000000]   DMA32 zone: 769376 pages, LIFO batch:31
[ 0.000000]   Normal zone: 20480 pages used for memmap
[ 0.000000]   Normal zone: 1310720 pages, LIFO batch:31
[ 0.000000] ACPI: PM-Timer IO Port: 0x408
[ 0.000000] ACPI: Local APIC address 0xfee00000
[ 0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
	( and apic_id 0x01..0x0b ...)
[ 0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[ 0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[ 0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[ 0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[ 0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[ 0.000000] ACPI: IRQ0 used by override.
[ 0.000000] ACPI: IRQ2 used by override.
[ 0.000000] ACPI: IRQ9 used by override.
[ 0.000000] Using ACPI (MADT) for SMP configuration information
[ 0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[ 0.000000] smpboot: Allowing 12 CPUs, 0 hotplug CPUs
[ 0.000000] nr_irqs_gsi: 40
[ 0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[ 0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[ 0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[ 0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[ 0.000000] PM: Registered nosave memory: [mem 0xbca46000-0xbcb5ffff]
[ 0.000000] PM: Registered nosave memory: [mem 0xbcb60000-0xbce8afff]
[ 0.000000] PM: Registered nosave memory: [mem 0xbce8b000-0xbcf02fff]
[ 0.000000] PM: Registered nosave memory: [mem 0xbcf03000-0xbcf33fff]
[ 0.000000] PM: Registered nosave memory: [mem 0xbcf34000-0xbcf38fff]
[ 0.000000] PM: Registered nosave memory: [mem 0xbcf39000-0xbcf57fff]
[ 0.000000] PM: Registered nosave memory: [mem 0xbcf58000-0xbcf58fff]
[ 0.000000] PM: Registered nosave memory: [mem 0xbcf59000-0xbcf5bfff]
[ 0.000000] PM: Registered nosave memory: [mem 0xbcf5c000-0xbcf63fff]
[ 0.000000] PM: Registered nosave memory: [mem 0xbcf64000-0xbcf8efff]
[ 0.000000] PM: Registered nosave memory: [mem 0xbcf8f000-0xbd191fff]
[ 0.000000] PM: Registered nosave memory: [mem 0xbd487000-0xbd7dafff]
[ 0.000000] PM: Registered nosave memory: [mem 0xbd800000-0xdfffffff]
[ 0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[ 0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfed1bfff]
[ 0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[ 0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
[ 0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[ 0.000000] e820: [mem 0xbd800000-0xdfffffff] available for PCI devices
[ 0.000000] setup_percpu: NR_CPUS:12 nr_cpumask_bits:12 nr_cpu_ids:12 nr_node_ids:1
[ 0.000000] PERCPU: Embedded 26 pages/cpu @ffff88023fc00000 s75712 r8192 d22592 u131072
[ 0.000000] pcpu-alloc: s75712 r8192 d22592 u131072 alloc=1*2097152
[ 0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 -- -- -- -- 
[ 0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2051506
[ 0.000000] Kernel command line: BOOT_IMAGE=Linux ro root=902 atkbd.softraw=0 libata.fua=1 no_console_suspend tsc_khz=3510135
[ 0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[ 0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[ 0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[ 0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[ 0.000000] Checking aperture...
[ 0.000000] No AGP bridge found
[ 0.000000] Memory: 8115780K/8336372K available (5664K kernel code, 634K rwdata, 1920K rodata, 776K init, 620K bss, 220592K reserved)
[ 0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=12, Nodes=1
[ 0.000000] Hierarchical RCU implementation.
[ 0.000000] NR_IRQS:4352 nr_irqs:776 16
[ 0.000000] Console: colour VGA+ 80x50
[ 0.000000] console [tty0] enabled
[ 0.000000] hpet clockevent registered
[ 0.000000] tsc: Fast TSC calibration using PIT
[ 0.003333] tsc: Detected 3199.912 MHz processor
[ 0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 6402.48 BogoMIPS (lpj=10666373)
[ 0.000070] pid_max: default: 32768 minimum: 301
[ 0.000120] Mount-cache hash table entries: 256
[ 0.000262] CPU: Physical Processor ID: 0
[ 0.000294] CPU: Processor Core ID: 0
[ 0.000329] mce: CPU supports 18 MCE banks
[ 0.000379] CPU0: Thermal monitoring enabled (TM1)
[ 0.000424] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[ 0.000424] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[ 0.000424] tlb_flushall_shift: 5
[ 0.000561] Freeing SMP alternatives memory: 20K (ffffffff818cd000 - ffffffff818d2000)
[ 0.000606] ACPI: Core revision 20130517
[ 0.008980] ACPI: All ACPI Tables successfully acquired
[ 0.009168] dmar: Host address width 46
[ 0.009201] dmar: DRHD base: 0xfbffc000 flags: 0x1
[ 0.009239] dmar: IOMMU 0: reg_base_addr fbffc000 ver 1:0 cap d2078c106f0462 ecap f020ff
[ 0.009284] dmar: RMRR base: 0xbcf09000 end: 0xbcf33fff
[ 0.009319] dmar: RHSA base: 0xfbffc000 proximity domain: 0x0
[ 0.009449] Switched APIC routing to physical flat.
[ 0.009871] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[ 0.042906] smpboot: CPU0: Intel(R) Core(TM) i7-3930K CPU @ 3.20GHz (fam: 06, model: 2d, stepping: 07)
[ 0.043013] TSC deadline timer enabled
[ 0.043018] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, full-width counters, Intel PMU driver.
[ 0.043166] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
[ 0.043213] ... version:                3
[ 0.043245] ... bit width:              48
[ 0.043277] ... generic registers:      4
[ 0.043309] ... value mask:             0000ffffffffffff
[ 0.043343] ... max period:             0000ffffffffffff
[ 0.043376] ... fixed-purpose events:   3
[ 0.045864] ... event mask:             000000070000000f
[ 0.046016] smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 #8 #9 #10 #11 OK
[ 0.192101] Brought up 12 CPUs
[ 0.192136] smpboot: Total of 12 processors activated (76828.79 BogoMIPS)
[ 0.201172] devtmpfs: initialized
[ 0.201308] PM: Registering ACPI NVS region [mem 0xbca46000-0xbcb5ffff] (1155072 bytes)
[ 0.201362] PM: Registering ACPI NVS region [mem 0xbcf34000-0xbcf38fff] (20480 bytes)
[ 0.201407] PM: Registering ACPI NVS region [mem 0xbcf58000-0xbcf58fff] (4096 bytes)
[ 0.201452] PM: Registering ACPI NVS region [mem 0xbcf5c000-0xbcf63fff] (32768 bytes)
[ 0.201497] PM: Registering ACPI NVS region [mem 0xbcf8f000-0xbd191fff] (2109440 bytes)
[ 0.201644] xor: automatically using best checksumming function:
[ 0.234368]    avx       : 25039.200 MB/sec
[ 0.234421] NET: Registered protocol family 16
[ 0.234639] ACPI: bus type PCI registered
[ 0.234717] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[ 0.234764] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[ 0.252729] PCI: Using configuration type 1 for base access
[ 0.255674] bio: create slab <bio-0> at 0
[ 0.311051] raid6: sse2x1    9432 MB/s
[ 0.367728] raid6: sse2x2   11646 MB/s
[ 0.424404] raid6: sse2x4   13607 MB/s
[ 0.424436] raid6: using algorithm sse2x4 (13607 MB/s)
[ 0.424470] raid6: using ssse3x2 recovery algorithm
[ 0.424553] ACPI: Added _OSI(Module Device)
[ 0.424585] ACPI: Added _OSI(Processor Device)
[ 0.424618] ACPI: Added _OSI(3.0 _SCP Extensions)
[ 0.424651] ACPI: Added _OSI(Processor Aggregator Device)
[ 0.427348] ACPI: EC: Look up EC in DSDT
[ 0.430112] ACPI: Executed 1 blocks of module-level executable AML code
[ 0.473624] ACPI: Interpreter enabled
[ 0.473661] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130517/hwxface-571)
[ 0.473753] ACPI: (supports S0 S1 S3 S4 S5)
[ 0.473786] ACPI: Using IOAPIC for interrupt routing
[ 0.473849] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[ 0.473977] ACPI: No dock devices found.
[ 0.479367] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[ 0.479482] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[ 0.479626] acpi PNP0A08:00: ACPI _OSC control (0x15) granted
[ 0.479791] PCI host bridge to bus 0:00
[ 0.479825] pci_bus 0:00: root bus resource [bus 00-fe]
[ 0.479860] pci_bus 0:00: root bus resource [io  0x0000-0x03af]
[ 0.479895] pci_bus 0:00: root bus resource [io  0x03e0-0x0cf7]
[ 0.479929] pci_bus 0:00: root bus resource [io  0x03b0-0x03df]
[ 0.479964] pci_bus 0:00: root bus resource [io  0x0d00-0xffff]
[ 0.479998] pci_bus 0:00: root bus resource [mem 0x000a0000-0x000bffff]
[ 0.480034] pci_bus 0:00: root bus resource [mem 0x000c0000-0x000dffff]
[ 0.480069] pci_bus 0:00: root bus resource [mem 0xc0000000-0xfbffffff]
[ 0.480113] pci 0:00:00.0: [8086:3c00] type 00 class 0x060000
[ 0.480160] pci 0:00:00.0: PME# supported from D0 D3hot D3cold
[ 0.480226] pci 0:00:01.0: [8086:3c02] type 01 class 0x060400
[ 0.480280] pci 0:00:01.0: PME# supported from D0 D3hot D3cold
[ 0.480354] pci 0:00:02.0: [8086:3c04] type 01 class 0x060400
[ 0.480407] pci 0:00:02.0: PME# supported from D0 D3hot D3cold
[ 0.480478] pci 0:00:03.0: [8086:3c08] type 01 class 0x060400
[ 0.480531] pci 0:00:03.0: PME# supported from D0 D3hot D3cold
[ 0.480600] pci 0:00:04.0: [8086:3c20] type 00 class 0x088000
[ 0.480611] pci 0:00:04.0: reg 0x10: [mem 0xfb140000-0xfb143fff 64bit]
[ 0.480716] pci 0:00:04.1: [8086:3c21] type 00 class 0x088000
[ 0.480728] pci 0:00:04.1: reg 0x10: [mem 0xfb13c000-0xfb13ffff 64bit]
[ 0.480833] pci 0:00:04.2: [8086:3c22] type 00 class 0x088000
[ 0.480844] pci 0:00:04.2: reg 0x10: [mem 0xfb138000-0xfb13bfff 64bit]
[ 0.480951] pci 0:00:04.3: [8086:3c23] type 00 class 0x088000
[ 0.480962] pci 0:00:04.3: reg 0x10: [mem 0xfb134000-0xfb137fff 64bit]
[ 0.481066] pci 0:00:04.4: [8086:3c24] type 00 class 0x088000
[ 0.481078] pci 0:00:04.4: reg 0x10: [mem 0xfb130000-0xfb133fff 64bit]
[ 0.481186] pci 0:00:04.5: [8086:3c25] type 00 class 0x088000
[ 0.481197] pci 0:00:04.5: reg 0x10: [mem 0xfb12c000-0xfb12ffff 64bit]
[ 0.481302] pci 0:00:04.6: [8086:3c26] type 00 class 0x088000
[ 0.481313] pci 0:00:04.6: reg 0x10: [mem 0xfb128000-0xfb12bfff 64bit]
[ 0.481419] pci 0:00:04.7: [8086:3c27] type 00 class 0x088000
[ 0.481430] pci 0:00:04.7: reg 0x10: [mem 0xfb124000-0xfb127fff 64bit]
[ 0.481533] pci 0:00:05.0: [8086:3c28] type 00 class 0x088000
[ 0.481635] pci 0:00:05.2: [8086:3c2a] type 00 class 0x088000
[ 0.481736] pci 0:00:05.4: [8086:3c2c] type 00 class 0x080020
[ 0.481746] pci 0:00:05.4: reg 0x10: [mem 0xfb14a000-0xfb14afff]
[ 0.481850] pci 0:00:11.0: [8086:1d3e] type 01 class 0x060400
[ 0.481929] pci 0:00:11.0: PME# supported from D0 D3hot D3cold
[ 0.482004] pci 0:00:16.0: [8086:1d3a] type 00 class 0x078000
[ 0.482024] pci 0:00:16.0: reg 0x10: [mem 0xfb149000-0xfb14900f 64bit]
[ 0.482092] pci 0:00:16.0: PME# supported from D0 D3hot D3cold
[ 0.482160] pci 0:00:19.0: [8086:1502] type 00 class 0x020000
[ 0.482175] pci 0:00:19.0: reg 0x10: [mem 0xfb100000-0xfb11ffff]
[ 0.482182] pci 0:00:19.0: reg 0x14: [mem 0xfb148000-0xfb148fff]
[ 0.482189] pci 0:00:19.0: reg 0x18: [io  0xf040-0xf05f]
[ 0.482243] pci 0:00:19.0: PME# supported from D0 D3hot D3cold
[ 0.482275] pci 0:00:19.0: System wakeup disabled by ACPI
[ 0.482343] pci 0:00:1a.0: [8086:1d2d] type 00 class 0x0c0320
[ 0.482361] pci 0:00:1a.0: reg 0x10: [mem 0xfb147000-0xfb1473ff]
[ 0.482440] pci 0:00:1a.0: PME# supported from D0 D3hot D3cold
[ 0.482474] pci 0:00:1a.0: System wakeup disabled by ACPI
[ 0.482541] pci 0:00:1b.0: [8086:1d20] type 00 class 0x040300
[ 0.482553] pci 0:00:1b.0: reg 0x10: [mem 0xfb120000-0xfb123fff 64bit]
[ 0.482611] pci 0:00:1b.0: PME# supported from D0 D3hot D3cold
[ 0.482673] pci 0:00:1c.0: [8086:1d10] type 01 class 0x060400
[ 0.482742] pci 0:00:1c.0: PME# supported from D0 D3hot D3cold
[ 0.482778] pci 0:00:1c.0: System wakeup disabled by ACPI
[ 0.482841] pci 0:00:1c.1: [8086:1d12] type 01 class 0x060400
[ 0.482910] pci 0:00:1c.1: PME# supported from D0 D3hot D3cold
[ 0.482946] pci 0:00:1c.1: System wakeup disabled by ACPI
[ 0.483010] pci 0:00:1c.2: [8086:1d14] type 01 class 0x060400
[ 0.483079] pci 0:00:1c.2: PME# supported from D0 D3hot D3cold
[ 0.483115] pci 0:00:1c.2: System wakeup disabled by ACPI
[ 0.483180] pci 0:00:1c.3: [8086:1d16] type 01 class 0x060400
[ 0.483250] pci 0:00:1c.3: PME# supported from D0 D3hot D3cold
[ 0.483286] pci 0:00:1c.3: System wakeup disabled by ACPI
[ 0.483350] pci 0:00:1c.5: [8086:1d1a] type 01 class 0x060400
[ 0.483420] pci 0:00:1c.5: PME# supported from D0 D3hot D3cold
[ 0.483456] pci 0:00:1c.5: System wakeup disabled by ACPI
[ 0.483519] pci 0:00:1c.6: [8086:1d1c] type 01 class 0x060400
[ 0.483588] pci 0:00:1c.6: PME# supported from D0 D3hot D3cold
[ 0.483624] pci 0:00:1c.6: System wakeup disabled by ACPI
[ 0.483688] pci 0:00:1c.7: [8086:1d1e] type 01 class 0x060400
[ 0.483758] pci 0:00:1c.7: PME# supported from D0 D3hot D3cold
[ 0.483794] pci 0:00:1c.7: System wakeup disabled by ACPI
[ 0.483861] pci 0:00:1d.0: [8086:1d26] type 00 class 0x0c0320
[ 0.483879] pci 0:00:1d.0: reg 0x10: [mem 0xfb146000-0xfb1463ff]
[ 0.483958] pci 0:00:1d.0: PME# supported from D0 D3hot D3cold
[ 0.483992] pci 0:00:1d.0: System wakeup disabled by ACPI
[ 0.484053] pci 0:00:1e.0: [8086:244e] type 01 class 0x060401
[ 0.484119] pci 0:00:1e.0: System wakeup disabled by ACPI
[ 0.484184] pci 0:00:1f.0: [8086:1d41] type 00 class 0x060100
[ 0.484335] pci 0:00:1f.2: [8086:1d02] type 00 class 0x010601
[ 0.484350] pci 0:00:1f.2: reg 0x10: [io  0xf090-0xf097]
[ 0.484356] pci 0:00:1f.2: reg 0x14: [io  0xf080-0xf083]
[ 0.484362] pci 0:00:1f.2: reg 0x18: [io  0xf070-0xf077]
[ 0.484369] pci 0:00:1f.2: reg 0x1c: [io  0xf060-0xf063]
[ 0.484375] pci 0:00:1f.2: reg 0x20: [io  0xf020-0xf03f]
[ 0.484381] pci 0:00:1f.2: reg 0x24: [mem 0xfb145000-0xfb1457ff]
[ 0.484419] pci 0:00:1f.2: PME# supported from D3hot
[ 0.484478] pci 0:00:1f.3: [8086:1d22] type 00 class 0x0c0500
[ 0.484491] pci 0:00:1f.3: reg 0x10: [mem 0xfb144000-0xfb1440ff 64bit]
[ 0.484508] pci 0:00:1f.3: reg 0x20: [io  0xf000-0xf01f]
[ 0.484619] pci 0:00:01.0: PCI bridge to [bus 01]
[ 0.484712] pci 0:02:00.0: [10de:0a23] type 00 class 0x030000
[ 0.484718] pci 0:02:00.0: reg 0x10: [mem 0xfa000000-0xfaffffff]
[ 0.484726] pci 0:02:00.0: reg 0x14: [mem 0xc0000000-0xcfffffff 64bit pref]
[ 0.484732] pci 0:02:00.0: reg 0x1c: [mem 0xd0000000-0xd1ffffff 64bit pref]
[ 0.484737] pci 0:02:00.0: reg 0x24: [io  0xe000-0xe07f]
[ 0.484742] pci 0:02:00.0: reg 0x30: [mem 0xfb000000-0xfb07ffff pref]
[ 0.484802] pci 0:02:00.1: [10de:0be2] type 00 class 0x040300
[ 0.484809] pci 0:02:00.1: reg 0x10: [mem 0xfb080000-0xfb083fff]
[ 0.491117] pci 0:00:02.0: PCI bridge to [bus 02]
[ 0.491169] pci 0:00:02.0:   bridge window [io  0xe000-0xefff]
[ 0.491174] pci 0:00:02.0:   bridge window [mem 0xfa000000-0xfb0fffff]
[ 0.491182] pci 0:00:02.0:   bridge window [mem 0xc0000000-0xd1ffffff 64bit pref]
[ 0.491296] pci 0:03:00.0: [1000:0058] type 00 class 0x010000
[ 0.491310] pci 0:03:00.0: reg 0x10: [io  0xd000-0xd0ff]
[ 0.491325] pci 0:03:00.0: reg 0x14: [mem 0xfb410000-0xfb413fff 64bit]
[ 0.491340] pci 0:03:00.0: reg 0x1c: [mem 0xfb400000-0xfb40ffff 64bit]
[ 0.491358] pci 0:03:00.0: reg 0x30: [mem 0xfb200000-0xfb3fffff pref]
[ 0.491413] pci 0:03:00.0: supports D1 D2
[ 0.491444] pci 0:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[ 0.491495] pci 0:00:03.0: PCI bridge to [bus 03]
[ 0.491530] pci 0:00:03.0:   bridge window [io  0xd000-0xdfff]
[ 0.491533] pci 0:00:03.0:   bridge window [mem 0xfb200000-0xfb4fffff]
[ 0.491596] pci 0:00:11.0: PCI bridge to [bus 04]
[ 0.491631] pci 0:00:11.0:   bridge window [io  0xc000-0xcfff]
[ 0.491634] pci 0:00:11.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[ 0.491639] pci 0:00:11.0:   bridge window [mem 0xd2400000-0xd28fffff 64bit pref]
[ 0.491710] pci 0:05:00.0: [1b4b:9172] type 00 class 0x010601
[ 0.491726] pci 0:05:00.0: reg 0x10: [io  0xb040-0xb047]
[ 0.491737] pci 0:05:00.0: reg 0x14: [io  0xb030-0xb033]
[ 0.491749] pci 0:05:00.0: reg 0x18: [io  0xb020-0xb027]
[ 0.491760] pci 0:05:00.0: reg 0x1c: [io  0xb010-0xb013]
[ 0.491771] pci 0:05:00.0: reg 0x20: [io  0xb000-0xb00f]
[ 0.491782] pci 0:05:00.0: reg 0x24: [mem 0xfbb10000-0xfbb101ff]
[ 0.491794] pci 0:05:00.0: reg 0x30: [mem 0xfbb00000-0xfbb0ffff pref]
[ 0.491847] pci 0:05:00.0: PME# supported from D3hot
[ 0.497788] pci 0:00:1c.0: PCI bridge to [bus 05]
[ 0.497841] pci 0:00:1c.0:   bridge window [io  0xb000-0xbfff]
[ 0.497846] pci 0:00:1c.0:   bridge window [mem 0xfbb00000-0xfbbfffff]
[ 0.497981] pci 0:06:00.0: [1b4b:9172] type 00 class 0x010601
[ 0.498004] pci 0:06:00.0: reg 0x10: [io  0xa040-0xa047]
[ 0.498020] pci 0:06:00.0: reg 0x14: [io  0xa030-0xa033]
[ 0.498036] pci 0:06:00.0: reg 0x18: [io  0xa020-0xa027]
[ 0.498052] pci 0:06:00.0: reg 0x1c: [io  0xa010-0xa013]
[ 0.498068] pci 0:06:00.0: reg 0x20: [io  0xa000-0xa00f]
[ 0.498092] pci 0:06:00.0: reg 0x24: [mem 0xfba10000-0xfba101ff]
[ 0.498103] pci 0:06:00.0: reg 0x30: [mem 0xfba00000-0xfba0ffff pref]
[ 0.498157] pci 0:06:00.0: PME# supported from D3hot
[ 0.504459] pci 0:00:1c.1: PCI bridge to [bus 06]
[ 0.504511] pci 0:00:1c.1:   bridge window [io  0xa000-0xafff]
[ 0.504516] pci 0:00:1c.1:   bridge window [mem 0xfba00000-0xfbafffff]
[ 0.504648] pci 0:07:00.0: [1b4b:9172] type 00 class 0x010601
[ 0.504670] pci 0:07:00.0: reg 0x10: [io  0x9040-0x9047]
[ 0.504686] pci 0:07:00.0: reg 0x14: [io  0x9030-0x9033]
[ 0.504702] pci 0:07:00.0: reg 0x18: [io  0x9020-0x9027]
[ 0.504718] pci 0:07:00.0: reg 0x1c: [io  0x9010-0x9013]
[ 0.504734] pci 0:07:00.0: reg 0x20: [io  0x9000-0x900f]
[ 0.504750] pci 0:07:00.0: reg 0x24: [mem 0xfb910000-0xfb9101ff]
[ 0.504767] pci 0:07:00.0: reg 0x30: [mem 0xfb900000-0xfb90ffff pref]
[ 0.504833] pci 0:07:00.0: PME# supported from D3hot
[ 0.511130] pci 0:00:1c.2: PCI bridge to [bus 07]
[ 0.511182] pci 0:00:1c.2:   bridge window [io  0x9000-0x9fff]
[ 0.511187] pci 0:00:1c.2:   bridge window [mem 0xfb900000-0xfb9fffff]
[ 0.511298] pci 0:00:1c.3: PCI bridge to [bus 08]
[ 0.511479] pci 0:09:00.0: [1b73:1009] type 00 class 0x0c0330
[ 0.511502] pci 0:09:00.0: reg 0x10: [mem 0xfb800000-0xfb80ffff 64bit]
[ 0.511520] pci 0:09:00.0: reg 0x18: [mem 0xfb811000-0xfb811fff 64bit]
[ 0.511538] pci 0:09:00.0: reg 0x20: [mem 0xfb810000-0xfb810fff 64bit]
[ 0.511613] pci 0:09:00.0: supports D1
[ 0.511614] pci 0:09:00.0: PME# supported from D0 D1 D3hot D3cold
[ 0.517801] pci 0:00:1c.5: PCI bridge to [bus 09]
[ 0.517855] pci 0:00:1c.5:   bridge window [mem 0xfb800000-0xfb8fffff]
[ 0.517988] pci 0:0a:00.0: [1b73:1009] type 00 class 0x0c0330
[ 0.518020] pci 0:0a:00.0: reg 0x10: [mem 0xfb700000-0xfb70ffff 64bit]
[ 0.518045] pci 0:0a:00.0: reg 0x18: [mem 0xfb711000-0xfb711fff 64bit]
[ 0.518070] pci 0:0a:00.0: reg 0x20: [mem 0xfb710000-0xfb710fff 64bit]
[ 0.518165] pci 0:0a:00.0: supports D1
[ 0.518165] pci 0:0a:00.0: PME# supported from D0 D1 D3hot D3cold
[ 0.524471] pci 0:00:1c.6: PCI bridge to [bus 0a]
[ 0.524526] pci 0:00:1c.6:   bridge window [mem 0xfb700000-0xfb7fffff]
[ 0.524637] pci 0:00:1c.7: PCI bridge to [bus 0b]
[ 0.524785] pci 0:0c:00.0: [105a:4d68] type 00 class 0x018085
[ 0.524800] pci 0:0c:00.0: reg 0x10: [io  0x8040-0x8047]
[ 0.524809] pci 0:0c:00.0: reg 0x14: [io  0x8030-0x8033]
[ 0.524817] pci 0:0c:00.0: reg 0x18: [io  0x8020-0x8027]
[ 0.524826] pci 0:0c:00.0: reg 0x1c: [io  0x8010-0x8013]
[ 0.524834] pci 0:0c:00.0: reg 0x20: [io  0x8000-0x800f]
[ 0.524842] pci 0:0c:00.0: reg 0x24: [mem 0xfb604000-0xfb607fff]
[ 0.524851] pci 0:0c:00.0: reg 0x30: [mem 0xfb600000-0xfb603fff pref]
[ 0.524876] pci 0:0c:00.0: supports D1
[ 0.524933] pci 0:00:1e.0: PCI bridge to [bus 0c] (subtractive decode)
[ 0.524970] pci 0:00:1e.0:   bridge window [io  0x8000-0x8fff]
[ 0.524973] pci 0:00:1e.0:   bridge window [mem 0xfb600000-0xfb6fffff]
[ 0.524977] pci 0:00:1e.0:   bridge window [io  0x0000-0x03af] (subtractive decode)
[ 0.524978] pci 0:00:1e.0:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
[ 0.524979] pci 0:00:1e.0:   bridge window [io  0x03b0-0x03df] (subtractive decode)
[ 0.524980] pci 0:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[ 0.524981] pci 0:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[ 0.524982] pci 0:00:1e.0:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[ 0.524983] pci 0:00:1e.0:   bridge window [mem 0xc0000000-0xfbffffff] (subtractive decode)
[ 0.525027] pci_bus 0:00: on NUMA node 0
[ 0.525222] ACPI: PCI Root Bridge [UNC0] (domain 0000 [bus ff])
[ 0.525258] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[ 0.525303] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[ 0.525381] PCI host bridge to bus 0:ff
[ 0.525415] pci_bus 0:ff: root bus resource [bus ff]
[ 0.525453] pci 0:ff:08.0: [8086:3c80] type 00 class 0x088000
[ 0.525502] pci 0:ff:08.3: [8086:3c83] type 00 class 0x088000
[ 0.525555] pci 0:ff:08.4: [8086:3c84] type 00 class 0x088000
[ 0.525615] pci 0:ff:09.0: [8086:3c90] type 00 class 0x088000
[ 0.525662] pci 0:ff:09.3: [8086:3c93] type 00 class 0x088000
[ 0.525717] pci 0:ff:09.4: [8086:3c94] type 00 class 0x088000
[ 0.525776] pci 0:ff:0a.0: [8086:3cc0] type 00 class 0x088000
[ 0.525814] pci 0:ff:0a.1: [8086:3cc1] type 00 class 0x088000
[ 0.525852] pci 0:ff:0a.2: [8086:3cc2] type 00 class 0x088000
[ 0.525891] pci 0:ff:0a.3: [8086:3cd0] type 00 class 0x088000
[ 0.525930] pci 0:ff:0b.0: [8086:3ce0] type 00 class 0x088000
[ 0.525966] pci 0:ff:0b.3: [8086:3ce3] type 00 class 0x088000
[ 0.526003] pci 0:ff:0c.0: [8086:3ce8] type 00 class 0x088000
[ 0.526039] pci 0:ff:0c.1: [8086:3ce8] type 00 class 0x088000
[ 0.526075] pci 0:ff:0c.2: [8086:3ce8] type 00 class 0x088000
[ 0.526112] pci 0:ff:0c.6: [8086:3cf4] type 00 class 0x088000
[ 0.526148] pci 0:ff:0c.7: [8086:3cf6] type 00 class 0x088000
[ 0.526185] pci 0:ff:0d.0: [8086:3ce8] type 00 class 0x088000
[ 0.526221] pci 0:ff:0d.1: [8086:3ce8] type 00 class 0x088000
[ 0.526258] pci 0:ff:0d.2: [8086:3ce8] type 00 class 0x088000
[ 0.526294] pci 0:ff:0d.6: [8086:3cf5] type 00 class 0x088000
[ 0.526331] pci 0:ff:0e.0: [8086:3ca0] type 00 class 0x088000
[ 0.526371] pci 0:ff:0e.1: [8086:3c46] type 00 class 0x110100
[ 0.526414] pci 0:ff:0f.0: [8086:3ca8] type 00 class 0x088000
[ 0.526461] pci 0:ff:0f.1: [8086:3c71] type 00 class 0x088000
[ 0.526509] pci 0:ff:0f.2: [8086:3caa] type 00 class 0x088000
[ 0.526557] pci 0:ff:0f.3: [8086:3cab] type 00 class 0x088000
[ 0.526604] pci 0:ff:0f.4: [8086:3cac] type 00 class 0x088000
[ 0.526653] pci 0:ff:0f.5: [8086:3cad] type 00 class 0x088000
[ 0.526698] pci 0:ff:0f.6: [8086:3cae] type 00 class 0x088000
[ 0.526740] pci 0:ff:10.0: [8086:3cb0] type 00 class 0x088000
[ 0.526789] pci 0:ff:10.1: [8086:3cb1] type 00 class 0x088000
[ 0.526838] pci 0:ff:10.2: [8086:3cb2] type 00 class 0x088000
[ 0.526885] pci 0:ff:10.3: [8086:3cb3] type 00 class 0x088000
[ 0.526933] pci 0:ff:10.4: [8086:3cb4] type 00 class 0x088000
[ 0.526982] pci 0:ff:10.5: [8086:3cb5] type 00 class 0x088000
[ 0.527030] pci 0:ff:10.6: [8086:3cb6] type 00 class 0x088000
[ 0.527078] pci 0:ff:10.7: [8086:3cb7] type 00 class 0x088000
[ 0.527125] pci 0:ff:11.0: [8086:3cb8] type 00 class 0x088000
[ 0.527172] pci 0:ff:13.0: [8086:3ce4] type 00 class 0x088000
[ 0.527208] pci 0:ff:13.1: [8086:3c43] type 00 class 0x110100
[ 0.527246] pci 0:ff:13.4: [8086:3ce6] type 00 class 0x110100
[ 0.527283] pci 0:ff:13.5: [8086:3c44] type 00 class 0x110100
[ 0.527320] pci 0:ff:13.6: [8086:3c45] type 00 class 0x088000
[ 0.527362] pci_bus 0:ff: on NUMA node 0
[ 0.527402] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[ 0.527701] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[ 0.528002] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15)
[ 0.528280] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
[ 0.528557] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[ 0.528855] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[ 0.529200] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
[ 0.529498] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[ 0.531575] ACPI: Enabled 2 GPEs in block 00 to 3F
[ 0.531651] ACPI: \_SB_.PCI0: notify handler is installed
[ 0.531670] ACPI: \_SB_.UNC0: notify handler is installed
[ 0.531705] Found 2 acpi root devices
[ 0.531788] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
[ 0.531836] vgaarb: loaded
[ 0.531867] vgaarb: bridge control possible 0:02:00.0
[ 0.531961] SCSI subsystem initialized
[ 0.531994] ACPI: bus type ATA registered
[ 0.532088] libata version 3.00 loaded.
[ 0.532090] ACPI: bus type USB registered
[ 0.532154] usbcore: registered new interface driver usbfs
[ 0.532202] usbcore: registered new interface driver hub
[ 0.532256] usbcore: registered new device driver usb
[ 0.532340] pps_core: LinuxPPS API ver. 1 registered
[ 0.532373] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[ 0.532431] PTP clock support registered
[ 0.532519] EDAC MC: Ver: 3.0.0
[ 0.532762] wmi: Mapper loaded
[ 0.532832] Advanced Linux Sound Architecture Driver Initialized.
[ 0.532867] PCI: Using ACPI for IRQ routing
[ 0.538312] PCI: pci_cache_line_size set to 64 bytes
[ 0.538424] e820: reserve RAM buffer [mem 0x0009e800-0x0009ffff]
[ 0.538425] e820: reserve RAM buffer [mem 0xbca46000-0xbfffffff]
[ 0.538427] e820: reserve RAM buffer [mem 0xbd487000-0xbfffffff]
[ 0.538428] e820: reserve RAM buffer [mem 0xbd800000-0xbfffffff]
[ 0.538542] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[ 0.538754] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[ 0.541816] Switched to clocksource hpet
[ 0.541888] pnp: PnP ACPI init
[ 0.541923] ACPI: bus type PNP registered
[ 0.542007] system 00:00: [mem 0xfc000000-0xfcffffff] has been reserved
[ 0.542042] system 00:00: [mem 0xfd000000-0xfdffffff] has been reserved
[ 0.542077] system 00:00: [mem 0xfe000000-0xfeafffff] has been reserved
[ 0.542113] system 00:00: [mem 0xfeb00000-0xfebfffff] has been reserved
[ 0.542148] system 00:00: [mem 0xfed00400-0xfed3ffff] could not be reserved
[ 0.542183] system 00:00: [mem 0xfed45000-0xfedfffff] has been reserved
[ 0.542219] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[ 0.542317] system 00:01: [io  0x0a00-0x0a0f] has been reserved
[ 0.542352] system 00:01: [io  0x0a30-0x0a3f] has been reserved
[ 0.542387] system 00:01: [io  0x0a20-0x0a2f] has been reserved
[ 0.542422] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[ 0.542464] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[ 0.542558] pnp 00:03: [dma 0 disabled]
[ 0.542600] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[ 0.542606] pnp 00:04: [dma 4]
[ 0.542628] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[ 0.542655] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[ 0.542679] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[ 0.542731] system 00:07: [io  0x04d0-0x04d1] has been reserved
[ 0.542766] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[ 0.542793] pnp 00:08: Plug and Play ACPI device, IDs PNP0c04 (active)
[ 0.542928] system 00:09: [io  0x0400-0x0453] could not be reserved
[ 0.542963] system 00:09: [io  0x0458-0x047f] has been reserved
[ 0.542998] system 00:09: [io  0x1180-0x119f] has been reserved
[ 0.543033] system 00:09: [io  0x0500-0x057f] has been reserved
[ 0.543068] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[ 0.543103] system 00:09: [mem 0xfec00000-0xfecfffff] could not be reserved
[ 0.543138] system 00:09: [mem 0xfed08000-0xfed08fff] has been reserved
[ 0.543174] system 00:09: [mem 0xff000000-0xffffffff] has been reserved
[ 0.543209] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[ 0.543263] system 00:0a: [io  0x0454-0x0457] has been reserved
[ 0.543298] system 00:0a: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[ 0.543375] pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)
[ 0.543484] pnp: PnP ACPI: found 12 devices
[ 0.543516] ACPI: bus type PNP unregistered
[ 0.550439] pci 0:00:01.0: PCI bridge to [bus 01]
[ 0.550480] pci 0:00:02.0: PCI bridge to [bus 02]
[ 0.550514] pci 0:00:02.0:   bridge window [io  0xe000-0xefff]
[ 0.550551] pci 0:00:02.0:   bridge window [mem 0xfa000000-0xfb0fffff]
[ 0.550588] pci 0:00:02.0:   bridge window [mem 0xc0000000-0xd1ffffff 64bit pref]
[ 0.550635] pci 0:00:03.0: PCI bridge to [bus 03]
[ 0.550669] pci 0:00:03.0:   bridge window [io  0xd000-0xdfff]
[ 0.550706] pci 0:00:03.0:   bridge window [mem 0xfb200000-0xfb4fffff]
[ 0.550746] pci 0:00:11.0: PCI bridge to [bus 04]
[ 0.550780] pci 0:00:11.0:   bridge window [io  0xc000-0xcfff]
[ 0.550819] pci 0:00:11.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[ 0.550856] pci 0:00:11.0:   bridge window [mem 0xd2400000-0xd28fffff 64bit pref]
[ 0.553336] pci 0:00:1c.0: PCI bridge to [bus 05]
[ 0.553370] pci 0:00:1c.0:   bridge window [io  0xb000-0xbfff]
[ 0.553407] pci 0:00:1c.0:   bridge window [mem 0xfbb00000-0xfbbfffff]
[ 0.553448] pci 0:00:1c.1: PCI bridge to [bus 06]
[ 0.553482] pci 0:00:1c.1:   bridge window [io  0xa000-0xafff]
[ 0.553519] pci 0:00:1c.1:   bridge window [mem 0xfba00000-0xfbafffff]
[ 0.553560] pci 0:00:1c.2: PCI bridge to [bus 07]
[ 0.553594] pci 0:00:1c.2:   bridge window [io  0x9000-0x9fff]
[ 0.553631] pci 0:00:1c.2:   bridge window [mem 0xfb900000-0xfb9fffff]
[ 0.553671] pci 0:00:1c.3: PCI bridge to [bus 08]
[ 0.553713] pci 0:00:1c.5: PCI bridge to [bus 09]
[ 0.553749] pci 0:00:1c.5:   bridge window [mem 0xfb800000-0xfb8fffff]
[ 0.553790] pci 0:00:1c.6: PCI bridge to [bus 0a]
[ 0.553825] pci 0:00:1c.6:   bridge window [mem 0xfb700000-0xfb7fffff]
[ 0.553866] pci 0:00:1c.7: PCI bridge to [bus 0b]
[ 0.553907] pci 0:00:1e.0: PCI bridge to [bus 0c]
[ 0.553941] pci 0:00:1e.0:   bridge window [io  0x8000-0x8fff]
[ 0.553978] pci 0:00:1e.0:   bridge window [mem 0xfb600000-0xfb6fffff]
[ 0.554410] pci 0:00:1e.0: setting latency timer to 64
[ 0.554414] pci_bus 0:00: resource 4 [io  0x0000-0x03af]
[ 0.554415] pci_bus 0:00: resource 5 [io  0x03e0-0x0cf7]
[ 0.554416] pci_bus 0:00: resource 6 [io  0x03b0-0x03df]
[ 0.554417] pci_bus 0:00: resource 7 [io  0x0d00-0xffff]
[ 0.554418] pci_bus 0:00: resource 8 [mem 0x000a0000-0x000bffff]
[ 0.554419] pci_bus 0:00: resource 9 [mem 0x000c0000-0x000dffff]
[ 0.554420] pci_bus 0:00: resource 10 [mem 0xc0000000-0xfbffffff]
[ 0.554421] pci_bus 0:02: resource 0 [io  0xe000-0xefff]
[ 0.554422] pci_bus 0:02: resource 1 [mem 0xfa000000-0xfb0fffff]
[ 0.554424] pci_bus 0:02: resource 2 [mem 0xc0000000-0xd1ffffff 64bit pref]
[ 0.554425] pci_bus 0:03: resource 0 [io  0xd000-0xdfff]
[ 0.554426] pci_bus 0:03: resource 1 [mem 0xfb200000-0xfb4fffff]
[ 0.554427] pci_bus 0:04: resource 0 [io  0xc000-0xcfff]
[ 0.554428] pci_bus 0:04: resource 1 [mem 0xfbc00000-0xfbcfffff]
[ 0.554429] pci_bus 0:04: resource 2 [mem 0xd2400000-0xd28fffff 64bit pref]
[ 0.554430] pci_bus 0:05: resource 0 [io  0xb000-0xbfff]
[ 0.554431] pci_bus 0:05: resource 1 [mem 0xfbb00000-0xfbbfffff]
[ 0.554432] pci_bus 0:06: resource 0 [io  0xa000-0xafff]
[ 0.554433] pci_bus 0:06: resource 1 [mem 0xfba00000-0xfbafffff]
[ 0.554435] pci_bus 0:07: resource 0 [io  0x9000-0x9fff]
[ 0.554436] pci_bus 0:07: resource 1 [mem 0xfb900000-0xfb9fffff]
[ 0.554437] pci_bus 0:09: resource 1 [mem 0xfb800000-0xfb8fffff]
[ 0.554438] pci_bus 0:0a: resource 1 [mem 0xfb700000-0xfb7fffff]
[ 0.554439] pci_bus 0:0c: resource 0 [io  0x8000-0x8fff]
[ 0.554440] pci_bus 0:0c: resource 1 [mem 0xfb600000-0xfb6fffff]
[ 0.554441] pci_bus 0:0c: resource 4 [io  0x0000-0x03af]
[ 0.554442] pci_bus 0:0c: resource 5 [io  0x03e0-0x0cf7]
[ 0.554443] pci_bus 0:0c: resource 6 [io  0x03b0-0x03df]
[ 0.554444] pci_bus 0:0c: resource 7 [io  0x0d00-0xffff]
[ 0.554445] pci_bus 0:0c: resource 8 [mem 0x000a0000-0x000bffff]
[ 0.554446] pci_bus 0:0c: resource 9 [mem 0x000c0000-0x000dffff]
[ 0.554447] pci_bus 0:0c: resource 10 [mem 0xc0000000-0xfbffffff]
[ 0.554463] NET: Registered protocol family 2
[ 0.554565] TCP established hash table entries: 65536 (order: 8, 1048576 bytes)
[ 0.554717] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[ 0.554862] TCP: Hash tables configured (established 65536 bind 65536)
[ 0.554910] TCP: reno registered
[ 0.554943] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[ 0.554995] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[ 0.555071] NET: Registered protocol family 1
[ 0.588629] pci 0:02:00.0: Boot video device
[ 0.588891] PCI: CLS 64 bytes, default 64
[ 0.588901] DMAR: No ATSR found
[ 0.588955] IOMMU 0 0xfbffc000: using Queued invalidation
[ 0.588991] IOMMU: Setting RMRR:
[ 0.589029] IOMMU: Setting identity map for device 0:00:1d.0 [0xbcf09000 - 0xbcf33fff]
[ 0.589084] IOMMU: Setting identity map for device 0:00:1a.0 [0xbcf09000 - 0xbcf33fff]
[ 0.589132] IOMMU: Prepare 0-16MiB unity mapping for LPC
[ 0.589170] IOMMU: Setting identity map for device 0:00:1f.0 [0x0 - 0xffffff]
[ 0.589231] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[ 0.591528] microcode: CPU0 sig=0x206d7, pf=0x4, revision=0x70b
	( and again for CPU1..CPU11 ...)
[ 0.592017] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[ 0.592064] Scanning for low memory corruption every 60 seconds
[ 0.592444] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
	( more crypto initialization ...)
[ 0.596511] Asymmetric key parser 'x509' registered
[ 0.596597] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[ 0.596641] io scheduler noop registered
[ 0.596674] io scheduler deadline registered
[ 0.596736] io scheduler cfq registered (default)
[ 0.596864] pcieport 0:00:01.0: irq 41 for MSI/MSI-X
[ 0.596936] pcieport 0:00:02.0: irq 42 for MSI/MSI-X
[ 0.597003] pcieport 0:00:03.0: irq 43 for MSI/MSI-X
[ 0.597072] pcieport 0:00:11.0: irq 44 for MSI/MSI-X
[ 0.597150] pcieport 0:00:1c.0: irq 45 for MSI/MSI-X
[ 0.597223] pcieport 0:00:1c.1: irq 46 for MSI/MSI-X
[ 0.597299] pcieport 0:00:1c.2: irq 47 for MSI/MSI-X
[ 0.597373] pcieport 0:00:1c.3: irq 48 for MSI/MSI-X
[ 0.597447] pcieport 0:00:1c.5: irq 49 for MSI/MSI-X
[ 0.597521] pcieport 0:00:1c.6: irq 50 for MSI/MSI-X
[ 0.597594] pcieport 0:00:1c.7: irq 51 for MSI/MSI-X
[ 0.597711] pcieport 0:00:01.0: Signaling PME through PCIe PME interrupt
[ 0.597748] pcie_pme 0:00:01.0:pcie01: service driver pcie_pme loaded
[ 0.597759] pcieport 0:00:02.0: Signaling PME through PCIe PME interrupt
[ 0.597794] pci 0:02:00.0: Signaling PME through PCIe PME interrupt
[ 0.597829] pci 0:02:00.1: Signaling PME through PCIe PME interrupt
[ 0.597865] pcie_pme 0:00:02.0:pcie01: service driver pcie_pme loaded
[ 0.597876] pcieport 0:00:03.0: Signaling PME through PCIe PME interrupt
[ 0.597911] pci 0:03:00.0: Signaling PME through PCIe PME interrupt
[ 0.597948] pcie_pme 0:00:03.0:pcie01: service driver pcie_pme loaded
[ 0.597961] pcieport 0:00:11.0: Signaling PME through PCIe PME interrupt
[ 0.597998] pcie_pme 0:00:11.0:pcie01: service driver pcie_pme loaded
[ 0.598010] pcieport 0:00:1c.0: Signaling PME through PCIe PME interrupt
[ 0.598045] pci 0:05:00.0: Signaling PME through PCIe PME interrupt
[ 0.598081] pcie_pme 0:00:1c.0:pcie01: service driver pcie_pme loaded
[ 0.598093] pcieport 0:00:1c.1: Signaling PME through PCIe PME interrupt
[ 0.598128] pci 0:06:00.0: Signaling PME through PCIe PME interrupt
[ 0.598165] pcie_pme 0:00:1c.1:pcie01: service driver pcie_pme loaded
[ 0.598177] pcieport 0:00:1c.2: Signaling PME through PCIe PME interrupt
[ 0.598212] pci 0:07:00.0: Signaling PME through PCIe PME interrupt
[ 0.598248] pcie_pme 0:00:1c.2:pcie01: service driver pcie_pme loaded
[ 0.598261] pcieport 0:00:1c.3: Signaling PME through PCIe PME interrupt
[ 0.598298] pcie_pme 0:00:1c.3:pcie01: service driver pcie_pme loaded
[ 0.598309] pcieport 0:00:1c.5: Signaling PME through PCIe PME interrupt
[ 0.598345] pci 0:09:00.0: Signaling PME through PCIe PME interrupt
[ 0.598381] pcie_pme 0:00:1c.5:pcie01: service driver pcie_pme loaded
[ 0.598392] pcieport 0:00:1c.6: Signaling PME through PCIe PME interrupt
[ 0.598428] pci 0:0a:00.0: Signaling PME through PCIe PME interrupt
[ 0.598465] pcie_pme 0:00:1c.6:pcie01: service driver pcie_pme loaded
[ 0.598476] pcieport 0:00:1c.7: Signaling PME through PCIe PME interrupt
[ 0.598519] pcie_pme 0:00:1c.7:pcie01: service driver pcie_pme loaded
[ 0.598544] ioapic: probe of 0:00:05.4 failed with error -22
[ 0.598685] intel_idle: MWAIT substates: 0x21120
[ 0.598686] intel_idle: v0.4 model 0x2D
[ 0.598686] intel_idle: lapic_timer_reliable_states 0xffffffff
[ 0.598752] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[ 0.598799] ACPI: Power Button [PWRB]
[ 0.598867] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[ 0.598912] ACPI: Power Button [PWRF]
[ 0.599013] ACPI: Requesting acpi_cpufreq
[ 0.599738] ACPI Error: [\TST0] Namespace lookup failure, AE_NOT_FOUND (20130517/psargs-359)
[ 0.599844] ACPI Error: Method parse/execution failed [\_SB_.C000._TPC] (Node ffff8802368767d0), AE_NOT_FOUND (20130517/psparse-536)
	( repeat for _SB_.C001._TPC through \_SB_.C00B._TPC ...)
[ 0.610594] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[ 0.631166] 00:03: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[ 0.631580] Linux agpgart interface v0.103
[ 0.631665] [drm] Initialized drm 1.1.0 20060810
[ 0.631721] MXM: GUID detected in BIOS
[ 0.632000] nouveau  [  DEVICE][0000:02:00.0] BOOT0  : 0x0a5180a2
	( more nouveau, TTM & drm stuff ...)
[ 1.558432] fbcon: nouveaufb (fb0) is primary device
[ 1.591832] tsc: Refined TSC clocksource calibration: 3200.013 MHz
[ 1.624388] Console: switching to colour frame buffer device 240x67
[ 1.626978] nouveau 0:02:00.0: fb0: nouveaufb frame buffer device
[ 1.626991] nouveau 0:02:00.0: registered panic notifier
[ 1.627005] [drm] Initialized nouveau 1.1.1 20120801 for 0:02:00.0 on minor 0
[ 1.628143] loop: module loaded
[ 1.628449] ahci 0:00:1f.2: version 3.0
[ 1.628518] ahci 0:00:1f.2: irq 52 for MSI/MSI-X
[ 1.628540] ahci: SSS flag set, parallel bus scan disabled
[ 1.641854] ahci 0:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[ 1.641859] ahci 0:00:1f.2: flags: 64bit ncq sntf stag led clo pio ems apst 
[ 1.641865] ahci 0:00:1f.2: setting latency timer to 64
[ 1.675647] scsi0 : ahci
[ 1.675718] scsi1 : ahci
[ 1.675782] scsi2 : ahci
[ 1.675848] scsi3 : ahci
[ 1.675914] scsi4 : ahci
[ 1.675979] scsi5 : ahci
[ 1.676046] ata1: SATA max UDMA/133 abar m2048@0xfb145000 port 0xfb145100 irq 52
[ 1.676051] ata2: SATA max UDMA/133 abar m2048@0xfb145000 port 0xfb145180 irq 52
[ 1.676229] ata3: SATA max UDMA/133 abar m2048@0xfb145000 port 0xfb145200 irq 52
[ 1.676416] ata4: SATA max UDMA/133 abar m2048@0xfb145000 port 0xfb145280 irq 52
[ 1.676820] ata5: SATA max UDMA/133 abar m2048@0xfb145000 port 0xfb145300 irq 52
[ 1.677217] ata6: SATA max UDMA/133 abar m2048@0xfb145000 port 0xfb145380 irq 52
[ 1.677659] ahci 0:05:00.0: irq 53 for MSI/MSI-X
[ 1.677723] ahci 0:05:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
[ 1.678004] ahci 0:05:00.0: flags: 64bit ncq sntf led only pmp fbs pio slum part sxs 
[ 1.678671] scsi6 : ahci
[ 1.678918] scsi7 : ahci
[ 1.679242] ata7: SATA max UDMA/133 abar m512@0xfbb10000 port 0xfbb10100 irq 53
[ 1.679595] ata8: SATA max UDMA/133 abar m512@0xfbb10000 port 0xfbb10180 irq 53
[ 1.680047] ahci 0:06:00.0: irq 54 for MSI/MSI-X
[ 1.680101] ahci 0:06:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
[ 1.680398] ahci 0:06:00.0: flags: 64bit ncq sntf led only pmp fbs pio slum part sxs 
[ 1.681059] scsi8 : ahci
[ 1.681306] scsi9 : ahci
[ 1.681682] ata9: SATA max UDMA/133 abar m512@0xfba10000 port 0xfba10100 irq 54
[ 1.682052] ata10: SATA max UDMA/133 abar m512@0xfba10000 port 0xfba10180 irq 54
[ 1.682523] ahci 0:07:00.0: irq 55 for MSI/MSI-X
[ 1.682575] ahci 0:07:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
[ 1.682906] ahci 0:07:00.0: flags: 64bit ncq sntf led only pmp fbs pio slum part sxs 
[ 1.683595] scsi10 : ahci
[ 1.683851] scsi11 : ahci
[ 1.684269] ata11: SATA max UDMA/133 abar m512@0xfb910000 port 0xfb910100 irq 55
[ 1.684664] ata12: SATA max UDMA/133 abar m512@0xfb910000 port 0xfb910180 irq 55
[ 1.685183] pata_pdc2027x 0:0c:00.0: version 1.0
[ 1.690418] dmar: DRHD: handling fault status reg 2
[ 1.691339] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffc0000 
[ 1.691339] DMAR:[fault reason 02] Present bit in context entry is clear
[ 1.787216] pata_pdc2027x 0:0c:00.0: PLL input clock 16656 kHz
[ 1.817669] scsi12 : pata_pdc2027x
[ 1.817927] scsi13 : pata_pdc2027x
[ 1.818170] ata13: PATA max UDMA/100 mmio m16384@0xfb604000 cmd 0xfb6057c0 irq 16
[ 1.818594] ata14: PATA max UDMA/100 mmio m16384@0xfb604000 cmd 0xfb6055c0 irq 16
[ 1.819245] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[ 1.819533] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[ 1.820072] e1000e 0:00:19.0: setting latency timer to 64
[ 1.820113] e1000e 0:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[ 1.820524] e1000e 0:00:19.0: irq 56 for MSI/MSI-X
[ 1.995165] ata1: SATA link down (SStatus 0 SControl 300)
[ 2.001853] ata9: SATA link down (SStatus 0 SControl 300)
[ 2.001869] ata12: SATA link down (SStatus 0 SControl 300)
[ 2.001898] ata11: SATA link down (SStatus 0 SControl 300)
[ 2.002895] ata10: SATA link down (SStatus 0 SControl 300)
[ 2.010564] dmar: DRHD: handling fault status reg 102
[ 2.011530] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffe0000 
[ 2.011530] DMAR:[fault reason 02] Present bit in context entry is clear
[ 2.020504] dmar: DRHD: handling fault status reg 202
[ 2.021459] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffc0000 
[ 2.021459] DMAR:[fault reason 02] Present bit in context entry is clear
[ 2.086462] e1000e 0:00:19.0 eth0: registered PHC clock
[ 2.086657] e1000e 0:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 90:2b:34:db:9f:1b
[ 2.086917] e1000e 0:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[ 2.087418] e1000e 0:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
[ 2.087886] Fusion MPT base driver 3.04.20
[ 2.088324] Copyright (c) 1999-2008 LSI Corporation
[ 2.088794] Fusion MPT SAS Host driver 3.04.20
[ 2.089336] mptbase: ioc0: Initiating bringup
[ 2.158507] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2.159783] dmar: DRHD: handling fault status reg 302
[ 2.160746] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffe0000 
[ 2.160746] DMAR:[fault reason 02] Present bit in context entry is clear
[ 2.162614] ata7.00: failed to IDENTIFY (INIT_DEV_PARAMS failed, err_mask=0x80)
[ 2.315174] ata2: SATA link down (SStatus 0 SControl 300)
[ 2.591878] Switched to clocksource tsc
[ 2.635167] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 2.636148] ata3.00: ATA-7: ST3400832AS, 3.01, max UDMA/133
[ 2.636337] ata3.00: 781422768 sectors, multi 16: LBA48 NCQ (depth 31/32)
[ 2.637474] ata3.00: configured for UDMA/133
[ 2.637725] scsi 2:0:0:0: Direct-Access     ATA      ST3400832AS      3.01 PQ: 0 ANSI: 5
[ 2.638072] sd 2:0:0:0: [sda] 781422768 512-byte logical blocks: (400 GB/372 GiB)
[ 2.638107] sd 2:0:0:0: Attached scsi generic sg0 type 0
[ 2.639053] sd 2:0:0:0: [sda] Write Protect is off
[ 2.639509] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 2.639526] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 2.660127]  sda: sda1 sda2 sda3
[ 2.660529] sd 2:0:0:0: [sda] Attached SCSI disk
[ 2.695158] ioc0: LSISAS1068E B3: Capabilities={Initiator}
[ 2.955168] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 2.956193] ata4.00: ATA-7: ST3400832AS, 3.03, max UDMA/133
[ 2.956394] ata4.00: 781422768 sectors, multi 16: LBA48 NCQ (depth 31/32)
[ 2.957629] ata4.00: configured for UDMA/133
[ 2.957860] scsi 3:0:0:0: Direct-Access     ATA      ST3400832AS      3.03 PQ: 0 ANSI: 5
[ 2.958313] sd 3:0:0:0: [sdb] 781422768 512-byte logical blocks: (400 GB/372 GiB)
[ 2.958345] sd 3:0:0:0: Attached scsi generic sg1 type 0
[ 2.959358] sd 3:0:0:0: [sdb] Write Protect is off
[ 2.959860] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[ 2.959871] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 2.975397]  sdb: sdb1 sdb2 sdb3
[ 2.975744] sd 3:0:0:0: [sdb] Attached SCSI disk
[ 3.275169] ata5: SATA link down (SStatus 0 SControl 300)
[ 3.595171] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 3.596500] ata6.00: ATA-8: TOSHIBA DT01ACA200, MX4OABB0, max UDMA/133
[ 3.596701] ata6.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[ 3.598218] ata6.00: configured for UDMA/133
[ 3.598460] scsi 5:0:0:0: Direct-Access     ATA      TOSHIBA DT01ACA2 MX4O PQ: 0 ANSI: 5
[ 3.598934] sd 5:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[ 3.598979] sd 5:0:0:0: Attached scsi generic sg2 type 0
[ 3.599948] sd 5:0:0:0: [sdc] 4096-byte physical blocks
[ 3.600520] sd 5:0:0:0: [sdc] Write Protect is off
[ 3.601052] sd 5:0:0:0: [sdc] Mode Sense: 00 3a 00 10
[ 3.601061] sd 5:0:0:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
[ 3.632360]  sdc: unknown partition table
[ 3.632636] sd 5:0:0:0: [sdc] Attached SCSI disk
[ 7.158531] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 7.159830] dmar: DRHD: handling fault status reg 402
[ 7.160907] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffc0000 
[ 7.160907] DMAR:[fault reason 02] Present bit in context entry is clear
[ 7.163071] ata8.00: failed to IDENTIFY (INIT_DEV_PARAMS failed, err_mask=0x80)
[12.163869] dmar: DRHD: handling fault status reg 502
[12.164942] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffe0000 
[12.164942] DMAR:[fault reason 02] Present bit in context entry is clear
[12.172374] dmar: DRHD: handling fault status reg 602
[12.173476] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffc0000 
[12.173476] DMAR:[fault reason 02] Present bit in context entry is clear
[12.490600] dmar: DRHD: handling fault status reg 702
[12.491707] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffe0000 
[12.491707] DMAR:[fault reason 02] Present bit in context entry is clear
[12.499273] dmar: DRHD: handling fault status reg 2
[12.500375] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffc0000 
[12.500375] DMAR:[fault reason 02] Present bit in context entry is clear
[12.638542] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[12.639840] dmar: DRHD: handling fault status reg 102
[12.640960] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffe0000 
[12.640960] DMAR:[fault reason 02] Present bit in context entry is clear
[12.643216] ata7.00: failed to IDENTIFY (INIT_DEV_PARAMS failed, err_mask=0x80)
[12.643431] ata7: limiting SATA link speed to 1.5 Gbps
[12.758177] scsi14 : ioc0: LSISAS1068E B3, FwRev=011e0a00h, Ports=1, MaxQ=277, IRQ=16
[12.795943] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 14, phy 0, sas_addr 0x3c4a3a1b89ab65a7
[12.798673] scsi 14:0:0:0: Direct-Access     ATA      TOSHIBA DT01ACA2 ABB0 PQ: 0 ANSI: 5
[12.800340] sd 14:0:0:0: Attached scsi generic sg3 type 0
[12.801244] sd 14:0:0:0: [sdd] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[12.801857] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 15, phy 1, sas_addr 0x3c4a3b2d9e9e65a7
[12.804838] scsi 14:0:1:0: Direct-Access     ATA      TOSHIBA DT01ACA2 ABB0 PQ: 0 ANSI: 5
[12.806592] sd 14:0:1:0: Attached scsi generic sg4 type 0
[12.807502] sd 14:0:1:0: [sde] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[12.808118] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 16, phy 3, sas_addr 0x8262895894d9d6ad
[12.811244] scsi 14:0:2:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[12.813002] sd 14:0:2:0: Attached scsi generic sg5 type 0
[12.813909] sd 14:0:2:0: [sdf] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[12.814527] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 18, phy 4, sas_addr 0x82628953a7daf9ac
[12.817442] scsi 14:0:3:0: Direct-Access     ATA      Hitachi HDS5C302 AA10 PQ: 0 ANSI: 5
[12.819239] sd 14:0:3:0: Attached scsi generic sg6 type 0
[12.820147] sd 14:0:3:0: [sdg] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[12.820765] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 17, phy 5, sas_addr 0x8262895896c2daad
[12.826365] scsi 14:0:4:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[12.828042] sd 14:0:4:0: Attached scsi generic sg7 type 0
[12.828956] sd 14:0:4:0: [sdh] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[12.829576] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 19, phy 6, sas_addr 0x8262895593d5f9ad
[12.832740] scsi 14:0:5:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[12.834416] sd 14:0:5:0: Attached scsi generic sg8 type 0
[12.835409] sd 14:0:5:0: [sdi] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[12.836092] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
	( a bunch of ehci & xhci messages, finding root hubs ...)
[12.921908] usbcore: registered new interface driver usb-storage
[12.922118] usbcore: registered new interface driver usbserial
[12.922358] usbcore: registered new interface driver pl2303
[12.922841] usbserial: USB Serial support registered for pl2303
[12.923348] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[12.923789] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[12.924409] serio: i8042 KBD port at 0x60,0x64 irq 1
[12.924869] mousedev: PS/2 mouse device common for all mice
[12.925403] rtc_cmos 00:05: RTC can wake from S4
[12.925883] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[12.926295] rtc_cmos 00:05: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[12.926793] i2c /dev entries driver
[12.927642] i801_smbus 0:00:1f.3: SMBus using PCI Interrupt
[12.928956] pps_ldisc: PPS line discipline registered
[12.929239] it87: Found IT8728F chip at 0xa30, revision 1
[12.929426] it87: Beeping is supported
[12.930049] md: raid1 personality registered for level 1
[12.930407] md: raid6 personality registered for level 6
[12.930909] md: raid5 personality registered for level 5
[12.931403] md: raid4 personality registered for level 4
[12.931933] EDAC sbridge: Seeking for: dev 0e.0 PCI ID 8086:3ca0
[12.932385] EDAC sbridge: Seeking for: dev 0e.0 PCI ID 8086:3ca0
[12.932867] EDAC sbridge: Seeking for: dev 0f.0 PCI ID 8086:3ca8
[12.933349] EDAC sbridge: Seeking for: dev 0f.0 PCI ID 8086:3ca8
[12.933822] EDAC sbridge: Seeking for: dev 0f.1 PCI ID 8086:3c71
[12.934289] EDAC sbridge: Seeking for: dev 0f.1 PCI ID 8086:3c71
[12.934747] EDAC sbridge: Seeking for: dev 0f.2 PCI ID 8086:3caa
[12.935202] EDAC sbridge: Seeking for: dev 0f.2 PCI ID 8086:3caa
[12.935643] EDAC sbridge: Seeking for: dev 0f.3 PCI ID 8086:3cab
[12.936087] EDAC sbridge: Seeking for: dev 0f.3 PCI ID 8086:3cab
[12.936524] EDAC sbridge: Seeking for: dev 0f.4 PCI ID 8086:3cac
[12.936951] EDAC sbridge: Seeking for: dev 0f.4 PCI ID 8086:3cac
[12.937367] EDAC sbridge: Seeking for: dev 0f.5 PCI ID 8086:3cad
[12.937785] EDAC sbridge: Seeking for: dev 0f.5 PCI ID 8086:3cad
[12.938189] EDAC sbridge: Seeking for: dev 11.0 PCI ID 8086:3cb8
[12.938590] EDAC sbridge: Seeking for: dev 11.0 PCI ID 8086:3cb8
[12.938977] EDAC sbridge: Seeking for: dev 0c.6 PCI ID 8086:3cf4
[12.939362] EDAC sbridge: Seeking for: dev 0c.6 PCI ID 8086:3cf4
[12.939739] EDAC sbridge: Seeking for: dev 0c.7 PCI ID 8086:3cf6
[12.940117] EDAC sbridge: Seeking for: dev 0c.7 PCI ID 8086:3cf6
[12.940486] EDAC sbridge: Seeking for: dev 0d.6 PCI ID 8086:3cf5
[12.940849] EDAC sbridge: Seeking for: dev 0d.6 PCI ID 8086:3cf5
[12.941206] EDAC sbridge: ECC is disabled. Aborting
[12.941554] EDAC sbridge: Couldn't find mci handler
[12.941926] Intel P-state driver initializing.
[12.942244] Intel pstate controlling: cpu 0
	( and cpu 1..11 ...)
[12.946063] cpuidle: using governor ladder
[12.946391] cpuidle: using governor menu
[12.946777] usbcore: registered new interface driver usbhid
[12.946926] usbhid: USB HID core driver
[12.947183] snd_hda_intel 0:00:1b.0: irq 73 for MSI/MSI-X
[12.958515] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[12.968552] hda_intel: Disabling MSI
[12.988829] sd 14:0:0:0: [sdd] Write Protect is off
[12.989097] sd 14:0:0:0: [sdd] Mode Sense: 73 00 00 08
[12.991324] sd 14:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[12.993023] sd 14:0:1:0: [sde] Write Protect is off
[12.993299] sd 14:0:1:0: [sde] Mode Sense: 73 00 00 08
[12.995856] sd 14:0:1:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[13.033038] sd 14:0:2:0: [sdf] Write Protect is off
[13.033319] sd 14:0:2:0: [sdf] Mode Sense: 73 00 00 08
[13.035932] sd 14:0:2:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[13.053676] sd 14:0:5:0: [sdi] Write Protect is off
[13.053940] sd 14:0:5:0: [sdi] Mode Sense: 73 00 00 08
[13.056556] sd 14:0:5:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[13.058548] sd 14:0:4:0: [sdh] Write Protect is off
[13.058813] sd 14:0:4:0: [sdh] Mode Sense: 73 00 00 08
[13.063951] sd 14:0:4:0: [sdh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[13.082164] sd 14:0:3:0: [sdg] Write Protect is off
[13.082407] sd 14:0:3:0: [sdg] Mode Sense: 73 00 00 08
[13.084799] sd 14:0:3:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[13.165204] usb 1-1: new high-speed USB device number 2 using ehci-pci
[13.182766]  sdd: unknown partition table
[13.186844]  sde: unknown partition table
[13.277036]  sdf: unknown partition table
[13.288881] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[13.289047] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[13.289433] hub 1-1:1.0: USB hub found
[13.289630] hub 1-1:1.0: 6 ports detected
[13.297664]  sdi: unknown partition table
[13.310926]  sdh: unknown partition table
[13.346368]  sdg: unknown partition table
[13.376547] sd 14:0:0:0: [sdd] Attached SCSI disk
[13.380491] sd 14:0:1:0: [sde] Attached SCSI disk
[13.395203] usb 2-1: new high-speed USB device number 2 using ehci-pci
[13.502830] sd 14:0:2:0: [sdf] Attached SCSI disk
[13.518882] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[13.519056] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[13.519404] hub 2-1:1.0: USB hub found
[13.519630] hub 2-1:1.0: 8 ports detected
[13.523371] sd 14:0:5:0: [sdi] Attached SCSI disk
[13.553367] sd 14:0:4:0: [sdh] Attached SCSI disk
[13.592034] sd 14:0:3:0: [sdg] Attached SCSI disk
[13.598675] usb 1-1.6: new low-speed USB device number 3 using ehci-pci
[13.652640] ipip: IPv4 over IPv4 tunneling driver
[13.653006] IPv4 over IPSec tunneling driver
[13.653338] TCP: cubic registered
[13.653549] Initializing XFRM netlink socket
[13.653761] NET: Registered protocol family 17
[13.653999] NET: Registered protocol family 15
[13.663443] Loading module verification certificates
[13.664756] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: e15e709a1018c16b0dd528ad3bf6d5d10ed0812c'
[13.665046] registered taskstats version 1
[13.666230] rtc_cmos 00:05: setting system clock to 2013-10-13 09:00:33 UTC (1381654833)
[13.666518] ALSA device list:
[13.666770]   #0: HDA Intel PCH at 0xfb120000 irq 73
[13.667023]   #1: HDA NVidia at 0xfb080000 irq 16
[13.687723] usb 1-1.6: New USB device found, idVendor=045e, idProduct=0039
[13.688203] usb 1-1.6: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[13.688681] usb 1-1.6: Product: Microsoft 5-Button Mouse with IntelliEye(TM)
[13.689117] usb 1-1.6: Manufacturer: Microsoft
[13.693381] input: Microsoft Microsoft 5-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input3
[13.694287] hid-generic 0003:045E:0039.0001: input: USB HID v1.10 Mouse [Microsoft Microsoft 5-Button Mouse with IntelliEye(TM)] on usb-0000:00:1a.0-1.6/input0
[17.638734] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[17.640565] dmar: DRHD: handling fault status reg 202
[17.643111] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffc0000 
[17.643111] DMAR:[fault reason 02] Present bit in context entry is clear
[17.648400] ata8.00: failed to IDENTIFY (INIT_DEV_PARAMS failed, err_mask=0x80)
[17.648978] ata8: limiting SATA link speed to 1.5 Gbps
[17.650735] dmar: DRHD: handling fault status reg 302
[17.653246] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffe0000 
[17.653246] DMAR:[fault reason 02] Present bit in context entry is clear
[22.650740] dmar: DRHD: handling fault status reg 402
[22.653407] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffc0000 
[22.653407] DMAR:[fault reason 02] Present bit in context entry is clear
[22.767573] dmar: DRHD: handling fault status reg 502
[22.770378] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffe0000 
[22.770378] DMAR:[fault reason 02] Present bit in context entry is clear
[22.915290] ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[22.917134] dmar: DRHD: handling fault status reg 602
[22.919848] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffe0000 
[22.919848] DMAR:[fault reason 02] Present bit in context entry is clear
[22.925393] ata7.00: failed to IDENTIFY (INIT_DEV_PARAMS failed, err_mask=0x80)
[27.927516] dmar: DRHD: handling fault status reg 702
[27.930091] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffe0000 
[27.930091] DMAR:[fault reason 02] Present bit in context entry is clear
[27.935086] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffc0000 
[27.935086] DMAR:[fault reason 02] Present bit in context entry is clear
[27.940066] dmar: DRHD: handling fault status reg 100
[28.082049] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[28.083829] dmar: DRHD: handling fault status reg 102
[28.086388] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffc0000 
[28.086388] DMAR:[fault reason 02] Present bit in context entry is clear
[28.091489] ata8.00: failed to IDENTIFY (INIT_DEV_PARAMS failed, err_mask=0x80)
[33.094133] dmar: DRHD: handling fault status reg 202
[33.096742] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffc0000 
[33.096742] DMAR:[fault reason 02] Present bit in context entry is clear
[33.210884] dmar: DRHD: handling fault status reg 302
[33.213573] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffe0000 
[33.213573] DMAR:[fault reason 02] Present bit in context entry is clear
[33.358720] ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[33.420827] dmar: DRHD: handling fault status reg 402
[33.423571] dmar: DMAR:[DMA Write] Request device [05:00.1] fault addr fffc0000 
[33.423571] DMAR:[fault reason 02] Present bit in context entry is clear
[33.568730] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[33.734012] md: Waiting for all devices to be available before autodetect
[33.734484] md: If you don't use raid, use raid=noautodetect
[33.735414] md: Autodetecting RAID arrays.
[33.881963] md: Scanned 6 and added 6 devices.
[33.882475] md: autorun ...
[33.882963] md: considering sdb3 ...
[33.883448] md:  adding sdb3 ...
[33.884024] md: sdb2 has different UUID to sdb3
[33.884664] md: sdb1 has different UUID to sdb3
[33.885308] md:  adding sda3 ...
[33.885936] md: sda2 has different UUID to sdb3
[33.886571] md: sda1 has different UUID to sdb3
[33.887755] md: created md2
[33.888255] md: bind<sda3>
[33.888767] md: bind<sdb3>
[33.889213] md: running: <sdb3><sda3>
[33.890337] md/raid1:md2: active with 2 out of 2 mirrors
[33.891124] created bitmap (3 pages) for device md2
[33.892003] md2: bitmap initialized from disk: read 1 pages, set 1 of 5337 bits
[33.898644] md2: detected capacity change from 0 to 358120357888
[33.899341] md: considering sdb2 ...
[33.899850] md:  adding sdb2 ...
[33.900326] md: sdb1 has different UUID to sdb2
[33.900792] md:  adding sda2 ...
[33.901255] md: sda1 has different UUID to sdb2
[33.902432] md: created md1
[33.902958] md: bind<sda2>
[33.903461] md: bind<sdb2>
[33.903955] md: running: <sdb2><sda2>
[33.905066] md/raid1:md1: active with 2 out of 2 mirrors
[33.905606] md1: detected capacity change from 0 to 40961769472
[33.906365] md: considering sdb1 ...
[33.906882] md:  adding sdb1 ...
[33.907375] md:  adding sda1 ...
[33.907852] md: created md0
[33.908324] md: bind<sda1>
[33.908816] md: bind<sdb1>
[33.909289] md: running: <sdb1><sda1>
[33.910479] md/raid1:md0: active with 2 out of 2 mirrors
[33.911003] md0: detected capacity change from 0 to 1005977600
[33.911698] md: ... autorun DONE.
[33.942855]  md2: unknown partition table
[33.943658] EXT4-fs (md2): couldn't mount as ext3 due to feature incompatibilities
[33.944487] EXT4-fs (md2): couldn't mount as ext2 due to feature incompatibilities
[33.950070] EXT4-fs (md2): INFO: recovery required on readonly filesystem
[33.950589] EXT4-fs (md2): write access will be enabled during recovery
[34.854375] EXT4-fs (md2): recovery complete
[34.877799] EXT4-fs (md2): mounted filesystem with ordered data mode. Opts: (null)
[34.878252] VFS: Mounted root (ext4 filesystem) readonly on device 9:2.
[34.879377] Freeing unused kernel memory: 776K (ffffffff8180b000 - ffffffff818cd000)
[37.419992] systemd-udevd[1430]: starting version 204
[39.415230]  md0:
[39.458827]  md1: unknown partition table
[41.908310] md: md3 stopped.
[41.913119] md: bind<sde>
[41.948158] md: bind<sdf>
[41.992660] md: bind<sdg>
[42.029149] md: bind<sdh>
[42.029710] md: bind<sdi>
[42.049135] md: bind<sdc>
[42.049628] md: bind<sdd>
[42.051105] md/raid:md3: device sdd operational as raid disk 0
[42.051438] md/raid:md3: device sdi operational as raid disk 6
[42.051762] md/raid:md3: device sdh operational as raid disk 5
[42.052115] md/raid:md3: device sdg operational as raid disk 4
[42.052451] md/raid:md3: device sdf operational as raid disk 3
[42.052768] md/raid:md3: device sde operational as raid disk 1
[42.053518] md/raid:md3: allocated 7452kB
[42.053927] md/raid:md3: raid level 6 active with 6 out of 7 devices, algorithm 2
[42.054275] RAID conf printout:
[42.054276]  --- level:6 rd:7 wd:6
[42.054278]  disk 0, o:1, dev:sdd
[42.054279]  disk 1, o:1, dev:sde
[42.054281]  disk 3, o:1, dev:sdf
[42.054283]  disk 4, o:1, dev:sdg
[42.054284]  disk 5, o:1, dev:sdh
[42.054286]  disk 6, o:1, dev:sdi
[42.083673] created bitmap (15 pages) for device md3
[42.092396] md3: bitmap initialized from disk: read 1 pages, set 0 of 29809 bits
[42.159871] md3: detected capacity change from 0 to 10001994219520
[42.160342] RAID conf printout:
[42.160348]  --- level:6 rd:7 wd:6
[42.160352]  disk 0, o:1, dev:sdd
[42.160355]  disk 1, o:1, dev:sde
[42.160358]  disk 2, o:1, dev:sdc
[42.160361]  disk 3, o:1, dev:sdf
[42.160363]  disk 4, o:1, dev:sdg
[42.160365]  disk 5, o:1, dev:sdh
[42.160367]  disk 6, o:1, dev:sdi
[42.160610] md: recovery of RAID array md3
[42.161038] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[42.161442] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[42.161854] md: using 128k window, over a total of 1953514496k.
[42.335750]  md3: unknown partition table
[43.032445] Adding 40001724k swap on /dev/md1.  Priority:0 extents:1 across:40001724k 
[43.110878] EXT4-fs (md2): re-mounted. Opts: (null)
[43.678474] EXT4-fs (md2): re-mounted. Opts: data=ordered
[44.832808] fuse init (API version 7.22)
[47.251651] e1000e 0:00:19.0: irq 56 for MSI/MSI-X
[47.352344] e1000e 0:00:19.0: irq 56 for MSI/MSI-X
[48.945650] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
[48.946012] e1000e 0:00:19.0 eth0: 10/100 speed: disabling TSO
[56.306246] ata3.00: configured for UDMA/133
[56.306674] ata3: EH complete
[56.309009] ata4.00: configured for UDMA/133
[56.309327] ata4: EH complete
[56.312756] ata6.00: configured for UDMA/133
[56.313155] ata6: EH complete

I have a number of kernel patches I'm working on, but nothing remotely
near this area.  They're mostly in drivers/media/rc, and the closest
is a couple of patches to the md layer to printk the block numbers at
which mismatches are found when checking or repairing.

Finally, here's the kernel .config (comments & leading "CONFIG_" stripped):
64BIT=y
X86_64=y
X86=y
INSTRUCTION_DECODER=y
OUTPUT_FORMAT="elf64-x86-64"
ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
LOCKDEP_SUPPORT=y
STACKTRACE_SUPPORT=y
HAVE_LATENCYTOP_SUPPORT=y
MMU=y
NEED_DMA_MAP_STATE=y
NEED_SG_DMA_LENGTH=y
GENERIC_ISA_DMA=y
GENERIC_BUG=y
GENERIC_BUG_RELATIVE_POINTERS=y
GENERIC_HWEIGHT=y
ARCH_MAY_HAVE_PC_FDC=y
RWSEM_XCHGADD_ALGORITHM=y
GENERIC_CALIBRATE_DELAY=y
ARCH_HAS_CPU_RELAX=y
ARCH_HAS_CACHE_LINE_SIZE=y
ARCH_HAS_CPU_AUTOPROBE=y
HAVE_SETUP_PER_CPU_AREA=y
NEED_PER_CPU_EMBED_FIRST_CHUNK=y
NEED_PER_CPU_PAGE_FIRST_CHUNK=y
ARCH_HIBERNATION_POSSIBLE=y
ARCH_SUSPEND_POSSIBLE=y
ARCH_WANT_HUGE_PMD_SHARE=y
ARCH_WANT_GENERAL_HUGETLB=y
ZONE_DMA32=y
AUDIT_ARCH=y
ARCH_SUPPORTS_OPTIMIZED_INLINING=y
ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
HAVE_INTEL_TXT=y
X86_64_SMP=y
X86_HT=y
ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
ARCH_CPU_PROBE_RELEASE=y
ARCH_SUPPORTS_UPROBES=y
DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
IRQ_WORK=y
BUILDTIME_EXTABLE_SORT=y
INIT_ENV_ARG_LIMIT=32
CROSS_COMPILE=""
LOCALVERSION=""
LOCALVERSION_AUTO=y
HAVE_KERNEL_GZIP=y
HAVE_KERNEL_BZIP2=y
HAVE_KERNEL_LZMA=y
HAVE_KERNEL_XZ=y
HAVE_KERNEL_LZO=y
HAVE_KERNEL_LZ4=y
KERNEL_XZ=y
DEFAULT_HOSTNAME="(none)"
SWAP=y
SYSVIPC=y
SYSVIPC_SYSCTL=y
HAVE_GENERIC_HARDIRQS=y
GENERIC_HARDIRQS=y
GENERIC_IRQ_PROBE=y
GENERIC_IRQ_SHOW=y
GENERIC_PENDING_IRQ=y
IRQ_FORCED_THREADING=y
SPARSE_IRQ=y
CLOCKSOURCE_WATCHDOG=y
ARCH_CLOCKSOURCE_DATA=y
GENERIC_TIME_VSYSCALL=y
GENERIC_CLOCKEVENTS=y
GENERIC_CLOCKEVENTS_BUILD=y
GENERIC_CLOCKEVENTS_BROADCAST=y
GENERIC_CLOCKEVENTS_MIN_ADJUST=y
GENERIC_CMOS_UPDATE=y
TICK_ONESHOT=y
NO_HZ_COMMON=y
NO_HZ_IDLE=y
NO_HZ=y
HIGH_RES_TIMERS=y
TICK_CPU_ACCOUNTING=y
TASKSTATS=y
TASK_DELAY_ACCT=y
TASK_XACCT=y
TASK_IO_ACCOUNTING=y
TREE_RCU=y
RCU_STALL_COMMON=y
RCU_FANOUT=64
RCU_FANOUT_LEAF=16
IKCONFIG=y
IKCONFIG_PROC=y
LOG_BUF_SHIFT=17
HAVE_UNSTABLE_SCHED_CLOCK=y
ARCH_SUPPORTS_NUMA_BALANCING=y
ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CGROUPS=y
CGROUP_SCHED=y
FAIR_GROUP_SCHED=y
NAMESPACES=y
UIDGID_CONVERTED=y
SCHED_AUTOGROUP=y
SYSCTL=y
ANON_INODES=y
HAVE_UID16=y
SYSCTL_EXCEPTION_TRACE=y
HAVE_PCSPKR_PLATFORM=y
UID16=y
KALLSYMS=y
PRINTK=y
BUG=y
ELF_CORE=y
PCSPKR_PLATFORM=y
BASE_FULL=y
FUTEX=y
EPOLL=y
SIGNALFD=y
TIMERFD=y
EVENTFD=y
SHMEM=y
AIO=y
PCI_QUIRKS=y
HAVE_PERF_EVENTS=y
PERF_EVENTS=y
VM_EVENT_COUNTERS=y
SLUB_DEBUG=y
SLUB=y
SLUB_CPU_PARTIAL=y
HAVE_OPROFILE=y
OPROFILE_NMI_TIMER=y
JUMP_LABEL=y
HAVE_EFFICIENT_UNALIGNED_ACCESS=y
ARCH_USE_BUILTIN_BSWAP=y
HAVE_IOREMAP_PROT=y
HAVE_KPROBES=y
HAVE_KRETPROBES=y
HAVE_OPTPROBES=y
HAVE_KPROBES_ON_FTRACE=y
HAVE_ARCH_TRACEHOOK=y
HAVE_DMA_ATTRS=y
USE_GENERIC_SMP_HELPERS=y
GENERIC_SMP_IDLE_THREAD=y
HAVE_REGS_AND_STACK_ACCESS_API=y
HAVE_DMA_API_DEBUG=y
HAVE_HW_BREAKPOINT=y
HAVE_MIXED_BREAKPOINTS_REGS=y
HAVE_USER_RETURN_NOTIFIER=y
HAVE_PERF_EVENTS_NMI=y
HAVE_PERF_REGS=y
HAVE_PERF_USER_STACK_DUMP=y
HAVE_ARCH_JUMP_LABEL=y
ARCH_HAVE_NMI_SAFE_CMPXCHG=y
HAVE_ALIGNED_STRUCT_PAGE=y
HAVE_CMPXCHG_LOCAL=y
HAVE_CMPXCHG_DOUBLE=y
ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
ARCH_WANT_OLD_COMPAT_IPC=y
HAVE_ARCH_SECCOMP_FILTER=y
SECCOMP_FILTER=y
HAVE_CONTEXT_TRACKING=y
HAVE_IRQ_TIME_ACCOUNTING=y
HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
HAVE_ARCH_SOFT_DIRTY=y
MODULES_USE_ELF_RELA=y
OLD_SIGSUSPEND3=y
COMPAT_OLD_SIGACTION=y
SLABINFO=y
RT_MUTEXES=y
BASE_SMALL=0
MODULES=y
MODULE_FORCE_LOAD=y
MODULE_UNLOAD=y
MODULE_FORCE_UNLOAD=y
MODULE_SIG=y
MODULE_SIG_FORCE=y
MODULE_SIG_ALL=y
MODULE_SIG_SHA256=y
MODULE_SIG_HASH="sha256"
STOP_MACHINE=y
BLOCK=y
BLK_DEV_BSG=y
PARTITION_ADVANCED=y
MSDOS_PARTITION=y
BLOCK_COMPAT=y
IOSCHED_NOOP=y
IOSCHED_DEADLINE=y
IOSCHED_CFQ=y
DEFAULT_CFQ=y
DEFAULT_IOSCHED="cfq"
ASN1=y
INLINE_SPIN_UNLOCK_IRQ=y
INLINE_READ_UNLOCK=y
INLINE_READ_UNLOCK_IRQ=y
INLINE_WRITE_UNLOCK=y
INLINE_WRITE_UNLOCK_IRQ=y
MUTEX_SPIN_ON_OWNER=y
FREEZER=y
ZONE_DMA=y
SMP=y
X86_SUPPORTS_MEMORY_FAILURE=y
SCHED_OMIT_FRAME_POINTER=y
NO_BOOTMEM=y
MCORE2=y
X86_INTERNODE_CACHE_SHIFT=6
X86_L1_CACHE_SHIFT=6
X86_INTEL_USERCOPY=y
X86_USE_PPRO_CHECKSUM=y
X86_P6_NOP=y
X86_TSC=y
X86_CMPXCHG64=y
X86_CMOV=y
X86_MINIMUM_CPU_FAMILY=64
X86_DEBUGCTLMSR=y
CPU_SUP_INTEL=y
CPU_SUP_AMD=y
CPU_SUP_CENTAUR=y
HPET_TIMER=y
HPET_EMULATE_RTC=y
DMI=y
GART_IOMMU=y
SWIOTLB=y
IOMMU_HELPER=y
NR_CPUS=12
SCHED_SMT=y
SCHED_MC=y
PREEMPT_VOLUNTARY=y
X86_LOCAL_APIC=y
X86_IO_APIC=y
X86_MCE=y
X86_MCE_INTEL=y
X86_MCE_THRESHOLD=y
X86_THERMAL_VECTOR=y
MICROCODE=y
MICROCODE_INTEL=y
MICROCODE_OLD_INTERFACE=y
MICROCODE_INTEL_LIB=y
X86_MSR=y
ARCH_PHYS_ADDR_T_64BIT=y
ARCH_DMA_ADDR_T_64BIT=y
DIRECT_GBPAGES=y
ARCH_SPARSEMEM_ENABLE=y
ARCH_SPARSEMEM_DEFAULT=y
ARCH_SELECT_MEMORY_MODEL=y
ARCH_PROC_KCORE_TEXT=y
ILLEGAL_POINTER_VALUE=0xdead000000000000
SELECT_MEMORY_MODEL=y
SPARSEMEM_MANUAL=y
SPARSEMEM=y
HAVE_MEMORY_PRESENT=y
SPARSEMEM_EXTREME=y
SPARSEMEM_VMEMMAP_ENABLE=y
SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
SPARSEMEM_VMEMMAP=y
HAVE_MEMBLOCK=y
HAVE_MEMBLOCK_NODE_MAP=y
ARCH_DISCARD_MEMBLOCK=y
MEMORY_ISOLATION=y
PAGEFLAGS_EXTENDED=y
SPLIT_PTLOCK_CPUS=4
COMPACTION=y
MIGRATION=y
PHYS_ADDR_T_64BIT=y
ZONE_DMA_FLAG=1
BOUNCE=y
VIRT_TO_BUS=y
DEFAULT_MMAP_MIN_ADDR=4096
ARCH_SUPPORTS_MEMORY_FAILURE=y
MEMORY_FAILURE=y
TRANSPARENT_HUGEPAGE=y
TRANSPARENT_HUGEPAGE_ALWAYS=y
CROSS_MEMORY_ATTACH=y
X86_CHECK_BIOS_CORRUPTION=y
X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
X86_RESERVE_LOW=64
MTRR=y
MTRR_SANITIZER=y
MTRR_SANITIZER_ENABLE_DEFAULT=0
MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
X86_PAT=y
ARCH_USES_PG_UNCACHED=y
ARCH_RANDOM=y
X86_SMAP=y
SECCOMP=y
HZ_300=y
HZ=300
SCHED_HRTICK=y
KEXEC=y
PHYSICAL_START=0x1000000
PHYSICAL_ALIGN=0x1000000
HOTPLUG_CPU=y
ARCH_ENABLE_MEMORY_HOTPLUG=y
ARCH_HIBERNATION_HEADER=y
SUSPEND=y
SUSPEND_FREEZER=y
HIBERNATE_CALLBACKS=y
HIBERNATION=y
PM_STD_PARTITION="/dev/sdb2"
PM_SLEEP=y
PM_SLEEP_SMP=y
PM_RUNTIME=y
PM=y
ACPI=y
ACPI_SLEEP=y
ACPI_PROC_EVENT=y
ACPI_BUTTON=y
ACPI_VIDEO=y
ACPI_FAN=m
ACPI_DOCK=y
ACPI_I2C=y
ACPI_PROCESSOR=y
ACPI_HOTPLUG_CPU=y
ACPI_THERMAL=m
ACPI_BLACKLIST_YEAR=0
X86_PM_TIMER=y
ACPI_CONTAINER=y
CPU_FREQ=y
CPU_FREQ_TABLE=y
CPU_FREQ_GOV_COMMON=y
CPU_FREQ_STAT=y
CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CPU_FREQ_GOV_PERFORMANCE=y
CPU_FREQ_GOV_ONDEMAND=y
CPU_FREQ_GOV_CONSERVATIVE=y
X86_INTEL_PSTATE=y
X86_ACPI_CPUFREQ=m
CPU_IDLE=y
CPU_IDLE_GOV_LADDER=y
CPU_IDLE_GOV_MENU=y
INTEL_IDLE=y
PCI=y
PCI_DIRECT=y
PCI_MMCONFIG=y
PCI_DOMAINS=y
PCIEPORTBUS=y
PCIEAER=y
PCIEASPM=y
PCIEASPM_DEFAULT=y
PCIE_PME=y
ARCH_SUPPORTS_MSI=y
PCI_MSI=y
PCI_ATS=y
PCI_IOV=y
PCI_IOAPIC=y
PCI_LABEL=y
ISA_DMA_API=y
AMD_NB=y
BINFMT_ELF=y
COMPAT_BINFMT_ELF=y
ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CORE_DUMP_DEFAULT_ELF_HEADERS=y
BINFMT_SCRIPT=y
COREDUMP=y
IA32_EMULATION=y
X86_X32=y
COMPAT=y
COMPAT_FOR_U64_ALIGNMENT=y
SYSVIPC_COMPAT=y
KEYS_COMPAT=y
HAVE_TEXT_POKE_SMP=y
X86_DEV_DMA_OPS=y
NET=y
PACKET=y
PACKET_DIAG=y
UNIX=y
UNIX_DIAG=y
XFRM=y
XFRM_ALGO=y
XFRM_USER=y
XFRM_IPCOMP=y
NET_KEY=y
INET=y
NET_IPIP=y
NET_IP_TUNNEL=y
SYN_COOKIES=y
NET_IPVTI=y
INET_AH=y
INET_ESP=y
INET_IPCOMP=y
INET_XFRM_TUNNEL=y
INET_TUNNEL=y
INET_XFRM_MODE_TRANSPORT=y
INET_XFRM_MODE_TUNNEL=y
INET_XFRM_MODE_BEET=y
INET_LRO=y
INET_DIAG=y
INET_TCP_DIAG=y
INET_UDP_DIAG=y
TCP_CONG_CUBIC=y
DEFAULT_TCP_CONG="cubic"
HAVE_NET_DSA=y
NETLINK_DIAG=y
RPS=y
RFS_ACCEL=y
XPS=y
NET_RX_BUSY_POLL=y
BQL=y
NET_FLOW_LIMIT=y
HAVE_BPF_JIT=y
UEVENT_HELPER_PATH="/sbin/hotplug"
DEVTMPFS=y
STANDALONE=y
PREVENT_FIRMWARE_BUILD=y
FW_LOADER=y
FIRMWARE_IN_KERNEL=y
EXTRA_FIRMWARE=""
DMA_SHARED_BUFFER=y
PARPORT=y
PARPORT_PC=y
PARPORT_PC_FIFO=y
PARPORT_PC_SUPERIO=y
PARPORT_1284=y
PNP=y
PNP_DEBUG_MESSAGES=y
PNPACPI=y
BLK_DEV=y
BLK_DEV_FD=m
BLK_DEV_LOOP=y
BLK_DEV_LOOP_MIN_COUNT=8
BLK_DEV_CRYPTOLOOP=y
CDROM_PKTCDVD=y
CDROM_PKTCDVD_BUFFERS=8
EEPROM_AT24=m
EEPROM_LEGACY=y
HAVE_IDE=y
IDE=m
IDE_XFER_MODE=y
IDE_ATAPI=y
IDE_GD=m
IDE_GD_ATA=y
BLK_DEV_IDECD=m
BLK_DEV_IDECD_VERBOSE_ERRORS=y
BLK_DEV_IDEACPI=y
IDE_TASK_IOCTL=y
IDE_GENERIC=m
BLK_DEV_IDEDMA_SFF=y
BLK_DEV_IDEPCI=y
BLK_DEV_GENERIC=m
BLK_DEV_IDEDMA_PCI=y
BLK_DEV_PDC202XX_NEW=m
BLK_DEV_IDEDMA=y
SCSI_MOD=y
RAID_ATTRS=m
SCSI=y
SCSI_DMA=y
SCSI_PROC_FS=y
BLK_DEV_SD=y
BLK_DEV_SR=y
CHR_DEV_SG=y
SCSI_CONSTANTS=y
SCSI_SAS_ATTRS=y
SCSI_LOWLEVEL=y
ATA=y
ATA_VERBOSE_ERROR=y
ATA_ACPI=y
SATA_PMP=y
SATA_AHCI=y
SATA_SIL24=m
ATA_SFF=y
ATA_BMDMA=y
PATA_PDC2027X=y
MD=y
BLK_DEV_MD=y
MD_AUTODETECT=y
MD_RAID1=y
MD_RAID456=y
FUSION=y
FUSION_SAS=y
FUSION_MAX_SGE=128
FUSION_CTL=m
FUSION_LOGGING=y
NETDEVICES=y
MII=m
NET_CORE=y
DUMMY=y
ETHERNET=y
NET_VENDOR_INTEL=y
E1000E=y
NET_VENDOR_I825XX=y
NET_VENDOR_REALTEK=y
R8169=m
NET_VENDOR_VIA=y
VIA_VELOCITY=m
INPUT=y
INPUT_MOUSEDEV=y
INPUT_MOUSEDEV_PSAUX=y
INPUT_MOUSEDEV_SCREEN_X=1920
INPUT_MOUSEDEV_SCREEN_Y=1080
INPUT_EVDEV=y
INPUT_KEYBOARD=y
KEYBOARD_ATKBD=y
INPUT_MOUSE=y
MOUSE_PS2=y
MOUSE_PS2_ALPS=y
MOUSE_PS2_LOGIPS2PP=y
MOUSE_PS2_SYNAPTICS=y
MOUSE_PS2_CYPRESS=y
MOUSE_PS2_LIFEBOOK=y
MOUSE_PS2_TRACKPOINT=y
INPUT_JOYSTICK=y
INPUT_MISC=y
SERIO=y
SERIO_I8042=y
SERIO_LIBPS2=y
TTY=y
VT=y
CONSOLE_TRANSLATIONS=y
VT_CONSOLE=y
VT_CONSOLE_SLEEP=y
HW_CONSOLE=y
UNIX98_PTYS=y
SERIAL_8250=y
SERIAL_8250_PNP=y
FIX_EARLYCON_MEM=y
SERIAL_8250_PCI=y
SERIAL_8250_NR_UARTS=4
SERIAL_8250_RUNTIME_UARTS=4
SERIAL_8250_EXTENDED=y
SERIAL_8250_DETECT_IRQ=y
SERIAL_CORE=y
HPET=y
HPET_MMAP=y
DEVPORT=y
I2C=y
I2C_BOARDINFO=y
I2C_COMPAT=y
I2C_CHARDEV=y
I2C_HELPER_AUTO=y
I2C_ALGOBIT=y
I2C_I801=y
I2C_SCMI=y
PPS=y
PPS_CLIENT_LDISC=y
PTP_1588_CLOCK=y
ARCH_WANT_OPTIONAL_GPIOLIB=y
GPIO_DEVRES=y
POWER_SUPPLY=y
HWMON=y
HWMON_VID=y
SENSORS_CORETEMP=y
SENSORS_IT87=y
THERMAL=y
THERMAL_HWMON=y
THERMAL_DEFAULT_GOV_STEP_WISE=y
THERMAL_GOV_STEP_WISE=y
THERMAL_GOV_USER_SPACE=y
X86_PKG_TEMP_THERMAL=m
SSB_POSSIBLE=y
BCMA_POSSIBLE=y
MEDIA_SUPPORT=m
AGP=y
AGP_INTEL=y
VGA_ARB=y
VGA_ARB_MAX_GPUS=4
DRM=y
DRM_KMS_HELPER=y
DRM_TTM=y
DRM_NOUVEAU=y
NOUVEAU_DEBUG=5
NOUVEAU_DEBUG_DEFAULT=3
DRM_I915=m
DRM_I915_KMS=y
VIDEO_OUTPUT_CONTROL=y
HDMI=y
FB=y
FIRMWARE_EDID=y
FB_DDC=y
FB_CFB_FILLRECT=y
FB_CFB_COPYAREA=y
FB_CFB_IMAGEBLIT=y
FB_BACKLIGHT=y
FB_MODE_HELPERS=y
FB_RADEON=y
FB_RADEON_I2C=y
FB_RADEON_BACKLIGHT=y
BACKLIGHT_LCD_SUPPORT=y
LCD_CLASS_DEVICE=y
BACKLIGHT_CLASS_DEVICE=y
BACKLIGHT_GENERIC=y
VGA_CONSOLE=y
DUMMY_CONSOLE=y
FRAMEBUFFER_CONSOLE=y
FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
SOUND=y
SND=y
SND_TIMER=y
SND_PCM=y
SND_HRTIMER=y
SND_DYNAMIC_MINORS=y
SND_MAX_CARDS=4
SND_VERBOSE_PROCFS=y
SND_VMASTER=y
SND_KCTL_JACK=y
SND_DMA_SGBUF=y
SND_PCI=y
SND_HDA_INTEL=y
SND_HDA_PREALLOC_SIZE=256
SND_HDA_CODEC_REALTEK=y
SND_HDA_CODEC_HDMI=y
SND_HDA_GENERIC=y
SND_HDA_POWER_SAVE_DEFAULT=5
HID=y
HID_GENERIC=y
HID_A4TECH=y
HID_APPLE=y
HID_BELKIN=y
HID_CHERRY=y
HID_CHICONY=y
HID_CYPRESS=y
HID_EZKEY=y
HID_KYE=y
HID_KENSINGTON=y
HID_LOGITECH=y
HID_MICROSOFT=y
HID_MONTEREY=y
USB_HID=y
USB_SUPPORT=y
USB_COMMON=y
USB_ARCH_HAS_HCD=y
USB=y
USB_ANNOUNCE_NEW_DEVICES=y
USB_DEFAULT_PERSIST=y
USB_MON=y
USB_XHCI_HCD=y
USB_EHCI_HCD=y
USB_EHCI_ROOT_HUB_TT=y
USB_EHCI_PCI=y
USB_UHCI_HCD=y
USB_STORAGE=y
USB_SERIAL=y
USB_SERIAL_PL2303=y
EDAC=y
EDAC_MM_EDAC=y
EDAC_I7CORE=y
EDAC_SBRIDGE=y
RTC_LIB=y
RTC_CLASS=y
RTC_HCTOSYS=y
RTC_SYSTOHC=y
RTC_HCTOSYS_DEVICE="rtc0"
RTC_INTF_SYSFS=y
RTC_INTF_PROC=y
RTC_INTF_DEV=y
RTC_DRV_CMOS=y
X86_PLATFORM_DEVICES=y
ACPI_WMI=y
MXM_WMI=y
INTEL_SMARTCONNECT=m
CLKEVT_I8253=y
I8253_LOCK=y
CLKBLD_I8253=y
IOMMU_API=y
IOMMU_SUPPORT=y
DMAR_TABLE=y
INTEL_IOMMU=y
INTEL_IOMMU_DEFAULT_ON=y
INTEL_IOMMU_FLOPPY_WA=y
IRQ_REMAP=y
PM_DEVFREQ=y
DEVFREQ_GOV_SIMPLE_ONDEMAND=y
DEVFREQ_GOV_PERFORMANCE=y
DEVFREQ_GOV_POWERSAVE=y
DEVFREQ_GOV_USERSPACE=y
FIRMWARE_MEMMAP=y
DMIID=y
DCACHE_WORD_ACCESS=y
EXT4_FS=y
EXT4_USE_FOR_EXT23=y
JBD2=y
FS_MBCACHE=y
EXPORTFS=m
FILE_LOCKING=y
FSNOTIFY=y
INOTIFY_USER=y
FANOTIFY=y
FUSE_FS=m
ISO9660_FS=m
JOLIET=y
UDF_FS=m
UDF_NLS=y
FAT_FS=m
MSDOS_FS=m
VFAT_FS=m
FAT_DEFAULT_CODEPAGE=437
FAT_DEFAULT_IOCHARSET="iso8859-1"
NTFS_FS=m
PROC_FS=y
PROC_KCORE=y
PROC_SYSCTL=y
PROC_PAGE_MONITOR=y
SYSFS=y
TMPFS=y
NETWORK_FILESYSTEMS=y
NFS_FS=m
NFS_V2=m
NFS_V3=m
NFSD=m
NFSD_V3=y
LOCKD=m
LOCKD_V4=y
NFS_COMMON=y
SUNRPC=m
CIFS=m
CIFS_DEBUG=y
NLS=y
NLS_DEFAULT="cp437"
NLS_CODEPAGE_437=m
NLS_ISO8859_1=m
NLS_ISO8859_15=m
NLS_UTF8=m
TRACE_IRQFLAGS_SUPPORT=y
PRINTK_TIME=y
DEFAULT_MESSAGE_LOGLEVEL=4
ENABLE_WARN_DEPRECATED=y
ENABLE_MUST_CHECK=y
FRAME_WARN=1024
STRIP_ASM_SYMS=y
ARCH_WANT_FRAME_POINTERS=y
MAGIC_SYSRQ=y
DEBUG_KERNEL=y
HAVE_DEBUG_KMEMLEAK=y
DEBUG_MEMORY_INIT=y
HAVE_DEBUG_STACKOVERFLOW=y
DEBUG_STACKOVERFLOW=y
HAVE_ARCH_KMEMCHECK=y
DETECT_HUNG_TASK=y
DEFAULT_HUNG_TASK_TIMEOUT=120
BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
PANIC_ON_OOPS_VALUE=0
SCHEDSTATS=y
TIMER_STATS=y
DEBUG_BUGVERBOSE=y
RCU_CPU_STALL_TIMEOUT=60
ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
USER_STACKTRACE_SUPPORT=y
HAVE_FUNCTION_TRACER=y
HAVE_FUNCTION_GRAPH_TRACER=y
HAVE_FUNCTION_GRAPH_FP_TEST=y
HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
HAVE_DYNAMIC_FTRACE=y
HAVE_DYNAMIC_FTRACE_WITH_REGS=y
HAVE_FTRACE_MCOUNT_RECORD=y
HAVE_SYSCALL_TRACEPOINTS=y
HAVE_FENTRY=y
HAVE_C_RECORDMCOUNT=y
TRACING_SUPPORT=y
HAVE_ARCH_KGDB=y
X86_VERBOSE_BOOTUP=y
EARLY_PRINTK=y
DOUBLEFAULT=y
HAVE_MMIOTRACE_SUPPORT=y
IO_DELAY_TYPE_0X80=0
IO_DELAY_TYPE_0XED=1
IO_DELAY_TYPE_UDELAY=2
IO_DELAY_TYPE_NONE=3
IO_DELAY_NONE=y
DEFAULT_IO_DELAY_TYPE=3
OPTIMIZE_INLINING=y
KEYS=y
DEFAULT_SECURITY_DAC=y
DEFAULT_SECURITY=""
XOR_BLOCKS=y
ASYNC_CORE=y
ASYNC_MEMCPY=y
ASYNC_XOR=y
ASYNC_PQ=y
ASYNC_RAID6_RECOV=y
CRYPTO=y
CRYPTO_ALGAPI=y
CRYPTO_ALGAPI2=y
CRYPTO_AEAD=y
CRYPTO_AEAD2=y
CRYPTO_BLKCIPHER=y
CRYPTO_BLKCIPHER2=y
CRYPTO_HASH=y
CRYPTO_HASH2=y
CRYPTO_RNG2=y
CRYPTO_PCOMP2=y
CRYPTO_MANAGER=y
CRYPTO_MANAGER2=y
CRYPTO_GF128MUL=y
CRYPTO_WORKQUEUE=y
CRYPTO_CRYPTD=y
CRYPTO_AUTHENC=y
CRYPTO_ABLK_HELPER_X86=y
CRYPTO_GLUE_HELPER_X86=y
CRYPTO_CBC=y
CRYPTO_ECB=m
CRYPTO_LRW=y
CRYPTO_PCBC=m
CRYPTO_XTS=y
CRYPTO_CMAC=m
CRYPTO_HMAC=y
CRYPTO_XCBC=m
CRYPTO_CRC32C=y
CRYPTO_CRC32C_INTEL=y
CRYPTO_CRC32_PCLMUL=y
CRYPTO_MD4=m
CRYPTO_MD5=y
CRYPTO_SHA1=y
CRYPTO_SHA1_SSSE3=y
CRYPTO_SHA256_SSSE3=y
CRYPTO_SHA256=y
CRYPTO_AES=y
CRYPTO_AES_X86_64=y
CRYPTO_AES_NI_INTEL=y
CRYPTO_ARC4=m
CRYPTO_DES=y
CRYPTO_TEA=m
CRYPTO_TWOFISH=m
CRYPTO_TWOFISH_COMMON=m
CRYPTO_TWOFISH_X86_64=m
CRYPTO_TWOFISH_X86_64_3WAY=m
CRYPTO_TWOFISH_AVX_X86_64=m
CRYPTO_DEFLATE=y
ASYMMETRIC_KEY_TYPE=y
ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
PUBLIC_KEY_ALGO_RSA=y
X509_CERTIFICATE_PARSER=y
HAVE_KVM=y
RAID6_PQ=y
BITREVERSE=y
GENERIC_STRNCPY_FROM_USER=y
GENERIC_STRNLEN_USER=y
GENERIC_NET_UTILS=y
GENERIC_FIND_FIRST_BIT=y
GENERIC_PCI_IOMAP=y
GENERIC_IOMAP=y
GENERIC_IO=y
CRC_CCITT=y
CRC16=y
CRC_ITU_T=y
CRC32=y
CRC32_SLICEBY8=y
ZLIB_INFLATE=y
ZLIB_DEFLATE=y
LZO_COMPRESS=y
LZO_DECOMPRESS=y
HAS_IOMEM=y
HAS_IOPORT=y
HAS_DMA=y
CHECK_SIGNATURE=y
CPU_RMAP=y
DQL=y
NLATTR=y
ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CLZ_TAB=y
MPILIB=y
OID_REGISTRY=y
FONT_SUPPORT=y
FONT_8x8=y
FONT_8x16=y

