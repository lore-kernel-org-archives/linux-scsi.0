From: Fredrik Roubert <roubert@df.lth.se>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Wed, 15 Feb 2006 22:43:49 +0100
Message-ID: <20060215214349.GA7947@igloo.df.lth.se>
References: <20060211011457.GA1839@igloo.df.lth.se> <Pine.LNX.4.60.0602112153320.3570@poirot.grange> <Pine.LNX.4.60.0602130043540.19775@poirot.grange> <20060211011457.GA1839@igloo.df.lth.se> <Pine.LNX.4.60.0602112153320.3570@poirot.grange> <20060213171052.GI18853@igloo.df.lth.se> <Pine.LNX.4.60.0602140000160.18538@poirot.grange> <20060214010138.GJ18853@igloo.df.lth.se> <Pine.LNX.4.60.0602140656430.30136@poirot.grange> <Pine.LNX.4.60.0602152056530.5682@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from igloo.df.lth.se ([194.47.250.47]:4590 "EHLO df.lth.se")
	by vger.kernel.org with ESMTP id S1751308AbWBOVn7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Feb 2006 16:43:59 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0602152056530.5682@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

Hi!

Now I applied your two patches to a fresh kernel source tree, added
"Verbose SCSI error reporting" and "Show timing information on printks"
to the configuration and rebooted with the newly built kernel and
modules. Then I ran "xscanimage hp:/dev/sg2" (using xscanimage from the
sane_1.0.14-1_amd64.deb Debian package), and scanned the same image a
few times, so that the driver hung two times.

Scanning an image doesn't fail every time, but almost every time. So if
one try succeeds, I just need to scan again to make the driver hang.

This is the output from dmesg, from boot until second failed scan:


[    0.000000] Bootdata ok (command line is auto BOOT_IMAGE=3DLinux ro =
root=3Dfd00)
[    0.000000] Linux version 2.6.15 (Version: skalman.5.dev) (roubert@s=
kalman) (gcc version 4.0.3 20060128 (prerelease) (Debian 4.0.2-8)) #1 S=
MP Wed Feb 15 22:08:56 CET 2006
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserve=
d)
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserve=
d)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ffb0000 (usable)
[    0.000000]  BIOS-e820: 000000007ffb0000 - 000000007ffc0000 (ACPI da=
ta)
[    0.000000]  BIOS-e820: 000000007ffc0000 - 000000007fff0000 (ACPI NV=
S)
[    0.000000]  BIOS-e820: 000000007fff0000 - 0000000080000000 (reserve=
d)
[    0.000000]  BIOS-e820: 00000000ff7c0000 - 0000000100000000 (reserve=
d)
[    0.000000] ACPI: RSDP (v000 ACPIAM                                )=
 @ 0x00000000000f9bb0
[    0.000000] ACPI: RSDT (v001 A M I  OEMRSDT  0x12000506 MSFT 0x00000=
097) @ 0x000000007ffb0000
[    0.000000] ACPI: FADT (v002 A M I  OEMFACP  0x12000506 MSFT 0x00000=
097) @ 0x000000007ffb0200
[    0.000000] ACPI: MADT (v001 A M I  OEMAPIC  0x12000506 MSFT 0x00000=
097) @ 0x000000007ffb0390
[    0.000000] ACPI: OEMB (v001 A M I  AMI_OEM  0x12000506 MSFT 0x00000=
097) @ 0x000000007ffc0040
[    0.000000] ACPI: DSDT (v001  939M2 939M2150 0x00000150 INTL 0x02002=
026) @ 0x0000000000000000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007ffb0000
[    0.000000] Bootmem setup node 0 0000000000000000-000000007ffb0000
[    0.000000] On node 0 totalpages: 513614
[    0.000000]   DMA zone: 612 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 513002 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages, LIFO batch:0
[    0.000000]   HighMem zone: 0 pages, LIFO batch:0
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:11 APIC version 16
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1 15:11 APIC version 16
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GS=
I 0-23
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec10000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 3, version 17, address 0xfec10000, GS=
I 24-39
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low leve=
l)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 8000=
0000:7f7c0000)
[    0.000000] Built 1 zonelists
[    0.000000] Kernel command line: auto BOOT_IMAGE=3DLinux ro root=3Df=
d00
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 131072 bytes)
[    0.000000] time.c: Using 3.579545 MHz PM timer.
[    0.000000] time.c: Detected 2000.109 MHz processor.
[   40.640391] Console: colour VGA+ 80x25
[   40.644038] Dentry cache hash table entries: 262144 (order: 9, 20971=
52 bytes)
[   40.647571] Inode-cache hash table entries: 131072 (order: 8, 104857=
6 bytes)
[   40.679328] Memory: 2051108k/2096832k available (1587k kernel code, =
45336k reserved, 821k data, 176k init)
[   40.756066] Calibrating delay using timer specific routine.. 4004.81=
 BogoMIPS (lpj=3D8009629)
[   40.756224] Mount-cache hash table entries: 256
[   40.756389] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 by=
tes/line)
[   40.756438] CPU: L2 Cache: 512K (64 bytes/line)
[   40.756485] CPU 0(2) -> Node 0 -> Core 0
[   40.756537] mtrr: v2.0 (20020519)
[   40.804885] Using local APIC timer interrupts.
[   40.854835] Detected 12.500 MHz APIC timer.
[   40.854995] Booting processor 1/2 APIC 0x1
[   40.864627] Initializing CPU#1
[   40.943053] Calibrating delay using timer specific routine.. 4000.41=
 BogoMIPS (lpj=3D8000825)
[   40.943060] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 by=
tes/line)
[   40.943062] CPU: L2 Cache: 512K (64 bytes/line)
[   40.943064] CPU 1(2) -> Node 0 -> Core 1
[   40.943145] AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping =
01
[   40.943154] CPU 1: Syncing TSC to CPU 0.
[   40.943915] CPU 1: synchronized TSC with CPU 0 (last diff -77 cycles=
, maxerr 565 cycles)
[   40.943921] Brought up 2 CPUs
[   40.944433] Disabling vsyscall due to use of PM timer
[   40.944480] time.c: Using PM based timekeeping.
[   40.944525] testing NMI watchdog ... OK.
[   40.984717] checking if image is initramfs... it is
[   41.859424] NET: Registered protocol family 16
[   41.859502] ACPI: bus type pci registered
[   41.859552] PCI: Using configuration type 1
[   41.860130] ACPI: Subsystem revision 20050902
[   41.866093] ACPI: Interpreter enabled
[   41.866139] ACPI: Using IOAPIC for interrupt routing
[   41.866837] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   41.866884] PCI: Probing PCI hardware (bus 00)
[   41.869317] PCI quirk: region 0800-083f claimed by ali7101 ACPI
[   41.869748] Boot video device is 0000:01:00.0
[   41.870029] PCI: Transparent bridge - 0000:00:06.0
[   41.870109] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   41.884201] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[   41.884441] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HTT_._PRT]
[   41.890416] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB1._PRT]
[   41.890616] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEB2._PRT]
[   41.891283] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 12=
 14 *15), disabled.
[   41.892004] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 1=
2 14 15)
[   41.892682] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 *6 7 10 11 1=
2 14 15)
[   41.893356] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 1=
2 14 15)
[   41.894028] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11 1=
2 14 15)
[   41.894707] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *10 11 1=
2 14 15)
[   41.895381] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11 1=
2 14 15)
[   41.896056] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12=
 14 15) *9
[   41.896767] ACPI: PCI Interrupt Link [LNKP] (IRQs 3 4 5 6 7 *10 11 1=
2 14 15)
[   41.897252] Linux Plug and Play Support v0.97 (c) Adam Belay
[   41.897313] pnp: PnP ACPI init
[   41.897379] pnp: ACPI device : hid PNP0200
[   41.897418] pnp: ACPI device : hid PNP0B00
[   41.897453] pnp: ACPI device : hid PNP0800
[   41.897487] pnp: ACPI device : hid PNP0C04
[   41.897735] pnp: ACPI device : hid PNP0510
[   41.898489] pnp: ACPI device : hid PNP0401
[   41.899377] pnp: ACPI device : hid PNPB02F
[   41.899785] pnp: ACPI device : hid PNPB006
[   41.900034] pnp: ACPI device : hid PNP0C02
[   41.900191] pnp: ACPI device : hid PNP0C02
[   41.900347] pnp: ACPI device : hid PNP0303
[   41.900426] pnp: ACPI device : hid PNP0F03
[   41.900712] pnp: ACPI device : hid PNP0501
[   41.901033] pnp: ACPI device : hid PNP0C02
[   41.901211] pnp: ACPI device : hid PNP0C01
[   41.901774] pnp: PnP ACPI: found 15 devices
[   41.901836] PCI: Using ACPI for IRQ routing
[   41.901883] PCI: If a device doesn't work, try "pci=3Drouteirq".  If=
 it helps, post a report
[   41.902577] pnp: the driver 'system' has been registered
[   41.902606] pnp: match found with the PnP device '00:08' and the dri=
ver 'system'
[   41.902610] pnp: match found with the PnP device '00:09' and the dri=
ver 'system'
[   41.902615] pnp: match found with the PnP device '00:0d' and the dri=
ver 'system'
[   41.902620] pnp: 00:0d: ioport range 0x290-0x29f has been reserved
[   41.902670] pnp: match found with the PnP device '00:0e' and the dri=
ver 'system'
[   41.902854] PCI: Bridge: 0000:00:01.0
[   41.902899]   IO window: disabled.
[   41.902946]   MEM window: f4700000-fe7fffff
[   41.902993]   PREFETCH window: c7e00000-d7dfffff
[   41.903040] PCI: Bridge: 0000:00:02.0
[   41.903084]   IO window: disabled.
[   41.903130]   MEM window: fe800000-fe8fffff
[   41.903176]   PREFETCH window: disabled.
[   41.903223] PCI: Bridge: 0000:00:05.0
[   41.903267]   IO window: disabled.
[   41.903315]   MEM window: fe900000-fe9fffff
[   41.903361]   PREFETCH window: disabled.
[   41.903413] PCI: Bridge: 0000:00:06.0
[   41.903459]   IO window: c000-cfff
[   41.903506]   MEM window: fea00000-feafffff
[   41.903554]   PREFETCH window: d7e00000-d7efffff
[   41.903612] GSI 16 sharing vector 0xA9 and IRQ 16
[   41.903660] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 29 (level, lo=
w) -> IRQ 16
[   41.903751] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   41.903759] GSI 17 sharing vector 0xB1 and IRQ 17
[   41.903805] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 34 (level, lo=
w) -> IRQ 17
[   41.903895] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   41.903903] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   41.903910] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   41.904180] IA32 emulation $Id: sys_ia32.c,v 1.32 2002/03/24 13:02:2=
8 ak Exp $
[   41.904647] io scheduler noop registered
[   41.904728] io scheduler anticipatory registered
[   41.953277] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 29 (level, lo=
w) -> IRQ 16
[   41.953373] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   41.953397] assign_interrupt_mode Found MSI capability
[   41.953444] Allocate Port Service[pcie00]
[   41.953482] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 34 (level, lo=
w) -> IRQ 17
[   41.953573] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   41.953596] assign_interrupt_mode Found MSI capability
[   41.953643] Allocate Port Service[pcie00]
[   41.954984] pnp: the driver 'i8042 kbd' has been registered
[   41.955012] pnp: match found with the PnP device '00:0a' and the dri=
ver 'i8042 kbd'
[   41.955021] pnp: the driver 'i8042 aux' has been registered
[   41.955047] pnp: match found with the PnP device '00:0b' and the dri=
ver 'i8042 aux'
[   41.955057] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60=
,0x64 irq 1,12
[   41.956645] serio: i8042 AUX port at 0x60,0x64 irq 12
[   41.956789] serio: i8042 KBD port at 0x60,0x64 irq 1
[   41.957169] RAMDISK driver initialized: 16 RAM disks of 4096K size 1=
024 blocksize
[   41.957272] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   41.957322] ide: Assuming 33MHz system bus speed for PIO modes; over=
ride with idebus=3Dxx
[   41.957425] ALI15X3: IDE controller at PCI slot 0000:00:12.0
[   41.957481] GSI 18 sharing vector 0xB9 and IRQ 18
[   41.957528] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 19 (level, lo=
w) -> IRQ 18
[   41.957626] ALI15X3: chipset revision 199
[   41.957671] ALI15X3: not 100% native mode: will probe irqs later
[   41.957730]     ide0: BM-DMA at 0xff00-0xff07, BIOS settings: hda:DM=
A, hdb:pio
[   41.957863]     ide1: BM-DMA at 0xff08-0xff0f, BIOS settings: hdc:pi=
o, hdd:pio
[   41.957988] Probing IDE interface ide0...
[   42.695555] hda: BENQ DVD DD DW1640, ATAPI CD/DVD-ROM drive
[   43.366504] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   43.366619] Probing IDE interface ide1...
[   43.937041] mice: PS/2 mouse device common for all mice
[   43.937382] NET: Registered protocol family 2
[   43.962495] input: AT Translated Set 2 keyboard as /class/input/inpu=
t0
[   43.972964] IP route cache hash table entries: 65536 (order: 7, 5242=
88 bytes)
[   43.973562] TCP established hash table entries: 262144 (order: 10, 4=
194304 bytes)
[   43.978388] TCP bind hash table entries: 65536 (order: 8, 1048576 by=
tes)
[   43.979619] TCP: Hash tables configured (established 262144 bind 655=
36)
[   43.979671] TCP reno registered
[   43.979779] TCP bic registered
[   43.979842] NET: Registered protocol family 1
[   43.980244] Freeing unused kernel memory: 176k freed
[   44.107514] usbcore: registered new driver usbfs
[   44.107585] usbcore: registered new driver hub
[   44.109254] ohci_hcd: 2005 April 22 USB 1.1 'Open' Host Controller (=
OHCI) Driver (PCI)
[   44.109291] GSI 19 sharing vector 0xC1 and IRQ 19
[   44.109344] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 20 (level, lo=
w) -> IRQ 19
[   44.109755] ohci_hcd 0000:00:13.0: OHCI Host Controller
[   44.109919] ohci_hcd 0000:00:13.0: new USB bus registered, assigned =
bus number 1
[   44.109990] ohci_hcd 0000:00:13.0: irq 19, io mem 0xfebfd000
[   44.145627] SCSI subsystem initialized
[   44.149684] libata version 1.20 loaded.
[   44.150943] sata_uli 0000:00:12.1: version 0.5
[   44.151008] ACPI: PCI Interrupt 0000:00:12.1[A] -> GSI 19 (level, lo=
w) -> IRQ 18
[   44.151158] ata1: SATA max UDMA/133 cmd 0xEC00 ctl 0xE082 bmdma 0xD8=
80 irq 18
[   44.170724] hub 1-0:1.0: USB hub found
[   44.170786] hub 1-0:1.0: 3 ports detected
[   44.205168] ata2: SATA max UDMA/133 cmd 0xE000 ctl 0xDC02 bmdma 0xD8=
88 irq 18
[   44.276441] GSI 20 sharing vector 0xC9 and IRQ 20
[   44.276495] ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 21 (level, lo=
w) -> IRQ 20
[   44.276866] ohci_hcd 0000:00:13.1: OHCI Host Controller
[   44.276977] ohci_hcd 0000:00:13.1: new USB bus registered, assigned =
bus number 2
[   44.277049] ohci_hcd 0000:00:13.1: irq 20, io mem 0xfebfc000
[   44.334350] hub 2-0:1.0: USB hub found
[   44.334411] hub 2-0:1.0: 3 ports detected
[   44.420250] ata1: dev 0 cfg 49:2f00 82:746b 83:7f01 84:4023 85:7468 =
86:3c01 87:4023 88:40ff
[   44.420256] ata1: dev 0 ATA-7, max UDMA7, 488397168 sectors: LBA48
[   44.420405] ata1: dev 0 configured for UDMA/133
[   44.420458] scsi0 : sata_uli
[   44.440679] GSI 21 sharing vector 0xD1 and IRQ 21
[   44.440732] ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 22 (level, lo=
w) -> IRQ 21
[   44.440967] ohci_hcd 0000:00:13.2: OHCI Host Controller
[   44.441081] ohci_hcd 0000:00:13.2: new USB bus registered, assigned =
bus number 3
[   44.441152] ohci_hcd 0000:00:13.2: irq 21, io mem 0xfebfb000
[   44.501994] hub 3-0:1.0: USB hub found
[   44.502051] hub 3-0:1.0: 3 ports detected
[   44.607891] GSI 22 sharing vector 0xD9 and IRQ 22
[   44.607945] ACPI: PCI Interrupt 0000:00:13.3[D] -> GSI 23 (level, lo=
w) -> IRQ 22
[   44.608224] ehci_hcd 0000:00:13.3: EHCI Host Controller
[   44.608972] ehci_hcd 0000:00:13.3: debug port 1
[   44.636773] ehci_hcd 0000:00:13.3: new USB bus registered, assigned =
bus number 4
[   44.636859] ehci_hcd 0000:00:13.3: irq 22, io mem 0xfebfe800
[   44.636914] ehci_hcd 0000:00:13.3: USB 2.0 started, EHCI 1.00, drive=
r 10 Dec 2004
[   44.637050] hub 4-0:1.0: USB hub found
[   44.637101] hub 4-0:1.0: 8 ports detected
[   44.640916] ata2: dev 0 cfg 49:2f00 82:746b 83:7f01 84:4023 85:7468 =
86:3c01 87:4023 88:40ff
[   44.640922] ata2: dev 0 ATA-7, max UDMA7, 488397168 sectors: LBA48
[   44.641074] ata2: dev 0 configured for UDMA/133
[   44.641121] scsi1 : sata_uli
[   44.641298]   Vendor: ATA       Model: SAMSUNG SP2504C   Rev: VT10
[   44.642261]   Type:   Direct-Access                      ANSI SCSI r=
evision: 05
[   44.642449]   Vendor: ATA       Model: SAMSUNG SP2504C   Rev: VT10
[   44.643412]   Type:   Direct-Access                      ANSI SCSI r=
evision: 05
[   44.744928] ACPI: PCI Interrupt 0000:04:07.0[A] -> GSI 22 (level, lo=
w) -> IRQ 21
[   44.745021] 3c59x: Donald Becker and others. www.scyld.com/network/v=
ortex.html
[   44.745083] 0000:04:07.0: 3Com PCI 3c900 Boomerang 10baseT at 000000=
000001cc00. Vers LK1.1.19
[   44.759178] dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 =
v2.05, 2004/03/08
[   44.759260] ACPI: PCI Interrupt 0000:04:05.0[A] -> GSI 20 (level, lo=
w) -> IRQ 19
[   45.001435] dc395x: Used settings: AdapterID=3D07, Speed=3D0(20.0MHz=
), dev_mode=3D0x57
[   45.001495] dc395x:                AdaptMode=3D0x0f, Tags=3D4(16), D=
elayReset=3D1s
[   45.001545] dc395x: Connectors:  Termination: Auto Low High
[   45.001763] dc395x: Performing initial SCSI bus reset
[   45.002336] scsi2 : Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 =
v2.05, 2004/03/08
[   46.505989]   Vendor: HP        Model: C2520A            Rev: 3503
[   46.506957]   Type:   Processor                          ANSI SCSI r=
evision: 02
[   49.521068] SCSI device sda: 488397168 512-byte hdwr sectors (250059=
 MB)
[   49.521134] SCSI device sda: drive cache: write back
[   49.521310] SCSI device sda: 488397168 512-byte hdwr sectors (250059=
 MB)
[   49.521368] SCSI device sda: drive cache: write back
[   49.521418]  sda: sda1 sda2 sda3
[   49.532840] sd 0:0:0:0: Attached scsi disk sda
[   49.532954] SCSI device sdb: 488397168 512-byte hdwr sectors (250059=
 MB)
[   49.533015] SCSI device sdb: drive cache: write back
[   49.538723] SCSI device sdb: 488397168 512-byte hdwr sectors (250059=
 MB)
[   49.538788] SCSI device sdb: drive cache: write back
[   49.538836]  sdb: sdb1 sdb2 sdb3
[   49.546372] sd 1:0:0:0: Attached scsi disk sdb
[   50.245898] hda: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache=
, UDMA(33)
[   50.246211] Uniform CD-ROM driver Revision: 3.20
[   50.285481] md: md driver 0.90.3 MAX_MD_DEVS=3D256, MD_SB_DISKS=3D27
[   50.285536] md: bitmap version 4.39
[   50.288382] md: raid1 personality registered as nr 3
[   50.295375] md: raid0 personality registered as nr 2
[   50.371093] md: md0 stopped.
[   50.372014] md: bind<sdb1>
[   50.372233] md: bind<sda1>
[   50.372363] raid1: raid set md0 active with 2 out of 2 mirrors
[   50.384641] md: md1 stopped.
[   50.385487] md: bind<sdb2>
[   50.385702] md: bind<sda2>
[   50.385761] md1: setting max_sectors to 128, segment boundary to 327=
67
[   50.385814] raid0: looking at sda2
[   50.385858] raid0:   comparing sda2(8787456) with sda2(8787456)
[   50.385936] raid0:   END
[   50.385979] raid0:   =3D=3D> UNIQUE
[   50.386023] raid0: 1 zones
[   50.386075] raid0: looking at sdb2
[   50.386120] raid0:   comparing sdb2(8787456) with sda2(8787456)
[   50.386198] raid0:   EQUAL
[   50.386241] raid0: FINAL 1 zones
[   50.386286] raid0: done.
[   50.386330] raid0 : md_size is 17574912 blocks.
[   50.386376] raid0 : conf->hash_spacing is 17574912 blocks.
[   50.386423] raid0 : nb_zone is 1.
[   50.386467] raid0 : Allocating 8 bytes for hash.
[   50.398699] device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-=
devel@redhat.com
[   50.415941] cdrom: open failed.
[   50.497161] ReiserFS: dm-0: found reiserfs format "3.6" with standar=
d journal
[   51.088548] ReiserFS: dm-0: using ordered data mode
[   51.094115] ReiserFS: dm-0: journal params: device dm-0, size 8192, =
journal first block 18, max trans len 1024, max batch 900, max commit a=
ge 30, max trans age 30
[   51.096598] ReiserFS: dm-0: checking transaction log (dm-0)
[   51.138663] ReiserFS: dm-0: Using r5 hash to sort names
[   52.678502] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005=
-7-29)
[   52.678630] GSI 23 sharing vector 0xE1 and IRQ 23
[   52.678679] ACPI: PCI Interrupt 0000:00:11.0[A] -> GSI 17 (level, lo=
w) -> IRQ 23
[   52.700514] eth1: ULi M5263 at pci0000:00:11.0, 00:13:8f:70:07:df, i=
rq 23.
[   52.737240] pnp: the driver 'parport_pc' has been registered
[   52.737260] pnp: match found with the PnP device '00:05' and the dri=
ver 'parport_pc'
[   52.737264] parport: PnPBIOS parport detected.
[   52.737425] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTA=
TE,EPP]
[   52.816544] input: PC Speaker as /class/input/input1
[   52.837764] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   52.837835] sd 1:0:0:0: Attached scsi generic sg1 type 0
[   52.837896]  2:0:2:0: Attached scsi generic sg2 type 3
[   52.852344] Real Time Clock Driver v1.12
[   52.884591] ali1563: SMBus control =3D 0403
[   52.884690] ali1563_probe: Returning 0
[   52.892825] Linux video capture interface: v1.00
[   52.958455] logips2pp: Detected unknown logitech mouse model 1
[   53.047483] input: PS/2 Logitech Mouse as /class/input/input2
[   53.098652] Serial: 8250/16550 driver $Revision: 1.90 $ 1 ports, IRQ=
 sharing disabled
[   53.114270] GSI 24 sharing vector 0xE9 and IRQ 24
[   53.114326] ACPI: PCI Interrupt 0000:00:08.0[A] -> GSI 18 (level, lo=
w) -> IRQ 24
[   53.158090] bttv: driver version 0.9.16 loaded
[   53.158145] bttv: using 8 buffers with 2080k (520 pages) each for ca=
pture
[   53.354981] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   53.407182] pnp: the driver 'serial' has been registered
[   53.407249] pnp: match found with the PnP device '00:0c' and the dri=
ver 'serial'
[   53.407407] 00:0c: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   54.134472] AC'97 1 does not respond - RESET
[   54.135068] AC'97 1 access is not valid [0xffffffff], removing mixer=
=2E
[   54.135118] Unable to initialize codec #1
[   54.194358] intel8x0_measure_ac97_clock: measured 58726 usecs
[   54.194406] intel8x0: clocking to 48000
[   54.195061] bttv: Bt8xx card found (0).
[   54.195125] ACPI: PCI Interrupt 0000:04:06.0[A] -> GSI 21 (level, lo=
w) -> IRQ 20
[   54.195224] bttv0: Bt848 (rev 18) at 0000:04:06.0, irq: 20, latency:=
 32, mmio: 0xd7eff000
[   54.195328] bttv0: using:  *** UNKNOWN/GENERIC ***  [card=3D0,autode=
tected]
[   54.195412] bttv0: gpio: en=3D00000000, out=3D00000000 in=3D00fffffb=
 [init]
[   54.283702] bttv0: detected by eeprom: Hauppauge (bt848) [card=3D2]
[   54.370868] tveeprom 1-0050: Hauppauge model 60114, rev CV  , serial=
# 541274
[   54.370919] tveeprom 1-0050: tuner model is Temic 4002FH5 (idx 14, t=
ype 0)
[   54.370968] tveeprom 1-0050: TV standards PAL(B/G) (eeprom 0x04)
[   54.371017] tveeprom 1-0050: audio processor is MSP3410D (idx 5)
[   54.371065] tveeprom 1-0050: has no radio
[   54.371110] bttv0: using tuner=3D0
[   54.371156] bttv0: i2c: checking for MSP34xx @ 0x80... found
[   54.421132] msp3400 1-0040: chip=3DMSP3410D-B4 +nicam +simple mode=3D=
simple
[   54.421319] msp3400 1-0040: msp3410 daemon started
[   54.441181] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
[   54.443399] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
[   54.476039] bttv0: i2c: checking for TDA9887 @ 0x86... not found
[   54.509062] tuner 1-0061: chip found @ 0xc2 (bt848 #0 [sw])
[   54.509145] tuner 1-0061: type set to 0 (Temic PAL (4002 FH5))
[   54.540471] bttv0: registered device video0
[   54.540534] bttv0: registered device vbi0
[   55.353395] Adding 1911724k swap on /dev/sda3.  Priority:-1 extents:=
1 across:1911724k
[   55.372582] Adding 1911724k swap on /dev/sdb3.  Priority:-2 extents:=
1 across:1911724k
[   86.145612] ReiserFS: dm-1: found reiserfs format "3.6" with standar=
d journal
[   93.815153] ReiserFS: dm-1: using ordered data mode
[   93.827359] ReiserFS: dm-1: journal params: device dm-1, size 8192, =
journal first block 18, max trans len 1024, max batch 900, max commit a=
ge 30, max trans age 30
[   93.829927] ReiserFS: dm-1: checking transaction log (dm-1)
[   93.924830] ReiserFS: dm-1: Using r5 hash to sort names
[   94.007660] ReiserFS: md1: found reiserfs format "3.6" with standard=
 journal
[   94.929992] ReiserFS: md1: using ordered data mode
[   94.953085] ReiserFS: md1: journal params: device md1, size 8192, jo=
urnal first block 18, max trans len 1024, max batch 900, max commit age=
 30, max trans age 30
[   94.955592] ReiserFS: md1: checking transaction log (md1)
[   94.966630] ReiserFS: md1: Using r5 hash to sort names
[   96.139055] ACPI: PCI Interrupt 0000:04:07.0[A] -> GSI 22 (level, lo=
w) -> IRQ 21
[   97.173742] NET: Registered protocol family 17
[   99.159228] ACPI: Power Button (FF) [PWRF]
[   99.159324] ACPI: Power Button (CM) [PWRB]
[  100.008805] lp0: using parport0 (interrupt-driven).
[  105.609877] nvidia: module license 'NVIDIA' taints kernel.
[  105.614825] GSI 25 sharing vector 0x32 and IRQ 25
[  105.614832] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 25 (level, lo=
w) -> IRQ 25
[  105.615205] PCI: Setting latency timer of device 0000:01:00.0 to 64
[  105.615676] NVRM: loading NVIDIA Linux x86_64 NVIDIA Kernel Module  =
1.0-8178  Wed Dec 14 16:58:07 PST 2005
[  344.852017] dc395x: reselect: w/o disconnected cmds <02-0>
[  344.852038] dc395x: disconnect: Unexpected reselection <02-0>
[  464.630090] dc395x: eh_abort: (pid#2002) target=3D<02-0> cmd=3Dffff8=
100743c04c0
[  464.630096] dc395x: eh_abort: Command in progress<6>dc395x: eh_bus_r=
eset: (pid#2002) target=3D<02-0> cmd=3Dffff8100743c04c0
[  464.630623] dc395x: doing_srb_done: pids G:2002(02-0)
[  528.066303] dc395x: reselect: w/o disconnected cmds <02-0>
[  528.066324] dc395x: disconnect: Unexpected reselection <02-0>
[  647.842343] dc395x: eh_abort: (pid#2130) target=3D<02-0> cmd=3Dffff8=
1007cc1b5c0
[  647.842350] dc395x: eh_abort: Command in progress<6>dc395x: eh_abort=
: (pid#2131) target=3D<02-0> cmd=3Dffff81007cc1b780
[  647.842356] dc395x: eh_abort: Command was waiting
[  657.823181] dc395x: eh_abort: (pid#2131) target=3D<02-0> cmd=3Dffff8=
1007cc1b780
[  657.823188] dc395x: eh_abort: Command was waiting
[  657.823196] dc395x: eh_bus_reset: (pid#2130) target=3D<02-0> cmd=3Df=
fff81007cc1b5c0
[  657.823717] dc395x: doing_srb_done: pids G:2130(02-0)


Do you need any other information?

Cheers // Fredrik Roubert

--=20
S=F6rbyplan 5       |  +46 8 7609169 / +46 708 776974
SE-163 71 Sp=E5nga  |  http://www.df.lth.se/~roubert/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
