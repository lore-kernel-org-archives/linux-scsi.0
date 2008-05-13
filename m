From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Fwd: [2.6.25.1] QLA1040 Panic on startup (ACPI related)
Date: Mon, 12 May 2008 19:27:58 -0500
Message-ID: <1210638478.3078.46.camel@localhost.localdomain>
References: <c457bfbf0805121437m355f2931p7d1a32fd5e40eb8e@mail.gmail.com>
	 <1210629550.3078.34.camel@localhost.localdomain>
	 <c457bfbf0805121638q4f9fd69eh86b01e5516f67d8a@mail.gmail.com>
	 <c457bfbf0805121640l7959d6fq402284ea1087604c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43263 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753886AbYEMA2E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2008 20:28:04 -0400
In-Reply-To: <c457bfbf0805121640l7959d6fq402284ea1087604c@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sean bruno <seanwbruno@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

On Mon, 2008-05-12 at 16:40 -0700, sean bruno wrote:
> ---------- Forwarded message ----------
> From: sean bruno <seanwbruno@gmail.com>
> Date: Mon, May 12, 2008 at 4:38 PM
> Subject: Re: [2.6.25.1] QLA1040 Panic on startup
> To: James Bottomley <James.Bottomley@hansenpartnership.com>
> 
> 
> >  This looks a bit like an ACPI IRQ routing problem
>  >
>  >  Could you try booting with the kernel parameter
>  >
>  >  acpi=noirq
>  >
>  >  And see if that fixes it?
>  >
>  >  Thanks,
>  >
>  >  James
> 
>  Thanks James.  Setting acpi=noirq does indeed allow this system to
>  boot normally.  The motherboard in question is an Intel D201GLY2.
> 
>  Here is the output of the system when it works correctly:

That definitely tags it as an acpi issue.  I've cc'd the acpi mailing
list who should be able to help with further advice about how to fix
this (or how to help them diagnose it further).

James


> 
>   BIOS-provided physical RAM map:
>   BIOS-e801: 0000000000000000 - 000000000009f000 (usable)
>   BIOS-e801: 0000000000100000 - 000000001ce60000 (usable)
>  0MB HIGHMEM available.
>  462MB LOWMEM available.
>  Zone PFN ranges:
>   DMA             0 ->     4096
>   Normal       4096 ->   118368
>   HighMem    118368 ->   118368
>  Movable zone start PFN for each node
>  early_node_map[1] active PFN ranges
>     0:        0 ->   118368
>  DMI 2.4 present.
>  ACPI: RSDP 000FE020, 0014 (r0 INTEL )
>  ACPI: RSDT 1DEFE038, 002C (r1 INTEL  DG965CO        89       1000013)
>  ACPI: FACP 1DEFD000, 0074 (r1 INTEL  DG965CO        89 MSFT  1000013)
>  ACPI: DSDT 1DEF9000, 312C (r1 INTEL  DG965CO        89 MSFT  1000013)
>  ACPI: FACS 1DEBC000, 0040
>  ACPI: APIC 1DEF8000, 006C (r1 INTEL  DG965CO        89 MSFT  1000013)
>  ACPI: PM-Timer IO Port: 0x808
>  Allocating PCI resources starting at 20000000 (gap: 1ce60000:e31a0000)
>  Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 117444
>  Kernel command line: nokeymap root=/dev/ram0 rw vga=normal acpi=noirq
>  console=tty1 console=ttyS0,115200n8
> 
> Enabling fast FPU save and restore... done.
>  Enabling unmasked SIMD FPU exception support... done.
>  Initializing CPU#0
>  PID hash table entries: 2048 (order: 11, 8192 bytes)
>  Detected 1200.063 MHz processor.
> 
> Console: colour VGA+ 80x25
>  console [tty1] enabled
>  console [ttyS0] enabled
>  Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
>  Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
>  Memory: 425476k/473472k available (5522k kernel code, 47404k reserved,
>  2555k data, 332k init, 0k highmem)
>  virtual kernel memory layout:
>     fixmap  : 0xfffe8000 - 0xfffff000   (  92 kB)
>     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
>     vmalloc : 0xdd800000 - 0xff7fe000   ( 543 MB)
>     lowmem  : 0xc0000000 - 0xdce60000   ( 462 MB)
>       .init : 0xc08e6000 - 0xc0939000   ( 332 kB)
>       .data : 0xc066497f - 0xc08e3774   (2555 kB)
>       .text : 0xc0100000 - 0xc066497f   (5522 kB)
>  Checking if this processor honours the WP bit even in supervisor mode...Ok.
>  Calibrating delay using timer specific routine.. 2401.71 BogoMIPS (lpj=4803439)
> 
> Mount-cache hash table entries: 512
>  CPU: L1 I cache: 32K, L1 D cache: 32K
>  CPU: L2 cache: 512K
>  using mwait in idle threads.
>  Compat vDSO mapped to ffffe000.
>  CPU: Intel(R) Celeron(R) CPU          220  @ 1.20GHz stepping 01
>  Checking 'hlt' instruction... OK.
>  Freeing SMP alternatives: 0k freed
>  ACPI: Core revision 20070126
>  ACPI: setting ELCR to 0e00 (from 0c00)
> 
> net_namespace: 152 bytes
>  xor: automatically using best checksumming function: pIII_sse
>    pIII_sse  :  4277.000 MB/sec
>  xor: using function: pIII_sse (4277.000 MB/sec)
>  NET: Registered protocol family 16
>  No dock devices found.
>  ACPI: bus type pci registered
>  PCI: Using configuration type 1
>  Setting up standard PCI resources
>  ACPI: Interpreter enabled
>  ACPI: (supports S0 S1 S5)
>  ACPI: Using PIC for interrupt routing
>  ACPI: PCI Root Bridge [PCI0] (0000:00)
> 
> Linux Plug and Play Support v0.97 (c) Adam Belay
>  pnp: PnP ACPI init
>  ACPI: bus type pnp registered
>  pnp: PnP ACPI: found 8 devices
>  ACPI: ACPI bus type pnp unregistered
>  SCSI subsystem initialized
>  usbcore: registered new interface driver usbfs
>  usbcore: registered new interface driver hub
>  usbcore: registered new device driver usb
>  PCI: Probing PCI hardware
>  PCI: Using IRQ router default [1039/0964] at 0000:00:02.0
> 
> 
> system 00:05: ioport range 0x800-0x8fe has been reserved
>  system 00:05: ioport range 0x8ff-0x8ff has been reserved
>  system 00:05: ioport range 0x4d0-0x4d1 has been reserved
>  system 00:05: ioport range 0x4d6-0x4d6 has been reserved
>  system 00:05: ioport range 0x295-0x29e has been reserved
>  system 00:05: ioport range 0x2e8-0x2ef has been reserved
>  system 00:05: ioport range 0x481-0x48f has been reserved
>  system 00:06: iomem range 0x0-0x9ffff could not be reserved
>  system 00:06: iomem range 0xec000-0xfffff could not be reserved
>  system 00:06: iomem range 0x100000-0x1dffffff could not be reserved
>  system 00:06: iomem range 0xe0000000-0xefffffff has been reserved
>  system 00:06: iomem range 0xfec00000-0xfec00fff has been reserved
>  system 00:06: iomem range 0xfee00000-0xfee00fff has been reserved
>  PCI: Bridge: 0000:00:01.0
>   IO window: 1000-1fff
>   MEM window: 0x2a000000-0x2a0fffff
>   PREFETCH window: 0x0000000020000000-0x0000000027ffffff
>  PCI: Bridge: 0000:00:1f.0
>   IO window: disabled.
>   MEM window: 0x1e000000-0x1e0fffff
>   PREFETCH window: disabled.
>  PCI: Enabling device 0000:00:1f.0 (0000 -> 0002)
>  NET: Registered protocol family 2
>  IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
>  TCP established hash table entries: 16384 (order: 5, 131072 bytes)
>  TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
>  TCP: Hash tables configured (established 16384 bind 16384)
>  TCP reno registered
>  checking if image is initramfs... it is
>  Overmounted tmpfs
>  Freeing initrd memory: 34338k freed
>  Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
>  NTFS driver 2.1.29 [Flags: R/W].
>  fuse init (API version 7.9)
>  JFS: nTxBlock = 3593, nTxLock = 28751
>  SGI XFS with realtime, large block numbers, no debug enabled
>  async_tx: api initialized (sync-only)
>  io scheduler noop registered
>  io scheduler anticipatory registered (default)
>  input: Power Button (FF) as /class/input/input0
>  ACPI: Power Button (FF) [PWRF]
>  input: Power Button (CM) as /class/input/input1
>  ACPI: Power Button (CM) [PWRB]
>  ACPI: ACPI0007:00 is registered as cooling_device0
>  ACPI: Processor [CPU0] (supports 8 throttling states)
>  Real Time Clock Driver v1.12ac
>  Non-volatile memory driver v1.2
>  Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
>  serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>  00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>  brd: module loaded
>  loop: module loaded
>  Compaq SMART2 Driver (v 2.6.0)
>  HP CISS Driver (v 3.6.14)
>  Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
>  Copyright (c) 1999-2006 Intel Corporation.
>  e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
>  e1000e: Copyright (c) 1999-2007 Intel Corporation.
>  Intel(R) Gigabit Ethernet Network Driver - version 1.0.8-k2
>  Copyright (c) 2007 Intel Corporation.
>  ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 1.1.18
>  ixgbe: Copyright (c) 1999-2007 Intel Corporation.
>  Intel(R) PRO/10GbE Network Driver - version 1.0.126-k4
>  Copyright (c) 1999-2006 Intel Corporation.
>  tehuti: Tehuti Networks(R) Network Driver, 7.29.3
>  tehuti: Options: hw_csum
>  pcnet32.c:v1.34 14.Aug.2007 tsbogend@alpha.franken.de
>  e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
>  e100: Copyright(c) 1999-2006 Intel Corporation
>  ThunderLAN driver v1.15
>  TLAN: 0 devices installed, PCI: 0  EISA: 0
>  sis900.c: v1.08.10 Apr. 2 2006
> 
> 0000:00:04.0: SiS 900 on Foxconn 661 7MI transceiver found at address 1.
>  0000:00:04.0: Using transceiver found at address 1 as default
>  eth0: SiS 900 PCI Fast Ethernet at 0x2400, IRQ 10, 00:1c:c0:1e:dc:6b
> 
> 
> ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
>  eth%d: i82596 initialization timed out
>  usbcore: registered new interface driver catc
>  drivers/net/usb/catc.c: v2.8 CATC EL1210A NetMate USB Ethernet driver
>  usbcore: registered new interface driver kaweth
>  pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
>  usbcore: registered new interface driver pegasus
>  drivers/net/usb/rtl8150.c: rtl8150 based usb-ethernet driver v0.6.2
> (2004/08/27)
>  usbcore: registered new interface driver rtl8150
>  dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
>  winbond-840.c:v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
>   http://www.scyld.com/network/drivers.html
>  Uniform Multi-Platform E-IDE driver
>  ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
>  SIS5513: IDE controller (0x1039:0x5513 rev 0x01) at  PCI slot 0000:00:02.5
>  SIS5513: not 100% native mode: will probe irqs later
>  SIS5513: SiS 962/963 MuTIOL IDE UDMA133 controller
>     ide0: BM-DMA at 0x2890-0x2897, BIOS settings: hda:PIO, hdb:PIO
>     ide1: BM-DMA at 0x2898-0x289f, BIOS settings: hdc:PIO, hdd:PIO
>  hda: TRANSCEND, ATA DISK drive
>  hda: UDMA/66 mode selected
>  ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
>  hda: max request size: 128KiB
>  hda: 1000944 sectors (512 MB) w/2KiB Cache, CHS=993/16/63
>   hda: hda1 hda2 hda3
>   hda1: <bsd:bad subpartition - ignored
>   >
>   hda2: <bsd:bad subpartition - ignored
>   >
>  ide-floppy driver 1.00
>  Loading Adaptec I2O RAID: Version 2.4 Build 5go
>  Detecting Adaptec I2O RAID controllers...
>  Adaptec aacraid driver 1.1-5[2455]-ms
>  scsi: <fdomain> Detection failed (no card)
> 
> qla1280: QLA1040 found on PCI bus 0, dev 6
>  scsi(2:0): Resetting SCSI BUS
>  scsi2 : QLogic QLA1040 PCI to SCSI Host Adapter
>        Firmware version:  7.65.06, Driver version 3.26
>  Emulex LightPulse Fibre Channel SCSI driver 8.2.5
>  Copyright(c) 2004-2008 Emulex.  All rights reserved.
>  Failed initialization of WD-7000 SCSI card!
>  megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
>  megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
>  megasas: 00.00.03.16-rc1 Thu. Nov. 07 10:09:32 PDT 2007
>  GDT-HA: Storage RAID Controller Driver. Version: 3.05
>  GDT-HA: Found 0 PCI Storage RAID Controllers
>  3ware Storage Controller device driver for Linux v1.26.02.002.
>  3ware 9000 Storage Controller device driver for Linux v2.26.02.010.
>  RocketRAID 3xxx/4xxx Controller driver v1.3 (071203)
>  st: Version 20080221, fixed bufsize 32768, s/g segs 256
>  Driver 'st' needs updating - please use bus_type methods
>  osst :I: Tape driver with OnStream support version 0.99.4
>  osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
>  Driver 'osst' needs updating - please use bus_type methods
>  Driver 'sd' needs updating - please use bus_type methods
>  Driver 'sr' needs updating - please use bus_type methods
>  sata_sis 0000:00:05.0: version 1.0
>  sata_sis 0000:00:05.0: Detected SiS 180/181/964 chipset in SATA mode
>  scsi3 : sata_sis
>  scsi4 : sata_sis
>  ata1: SATA max UDMA/133 cmd 0x28a8 ctl 0x28b4 bmdma 0x2880 irq 11
>  ata2: SATA max UDMA/133 cmd 0x28a0 ctl 0x28b0 bmdma 0x2888 irq 11
>  ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>  ata1.00: ATA-7: ST380815AS, 3.AAD, max UDMA/133
>  ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 0/32)
>  ata1.00: configured for UDMA/133
>  ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>  ata2.00: ATA-7: ST3250410AS, 3.AAC, max UDMA/133
>  ata2.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
>  ata2.00: configured for UDMA/133
>  scsi 3:0:0:0: Direct-Access     ATA      ST380815AS       3.AA PQ: 0 ANSI: 5
>  sd 3:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
>  sd 3:0:0:0: [sda] Write Protect is off
>  sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
>  support DPO or FUA
>  sd 3:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
>  sd 3:0:0:0: [sda] Write Protect is off
>  sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
>  support DPO or FUA
>   sda: unknown partition table
>  sd 3:0:0:0: [sda] Attached SCSI disk
>  sd 3:0:0:0: Attached scsi generic sg0 type 0
>  scsi 4:0:0:0: Direct-Access     ATA      ST3250410AS      3.AA PQ: 0 ANSI: 5
>  sd 4:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
>  sd 4:0:0:0: [sdb] Write Protect is off
>  sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
>  support DPO or FUA
>  sd 4:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
>  sd 4:0:0:0: [sdb] Write Protect is off
>  sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
>  support DPO or FUA
>   sdb: [LDM]
>  sd 4:0:0:0: [sdb] Attached SCSI disk
>  sd 4:0:0:0: Attached scsi generic sg1 type 0
>  Fusion MPT base driver 3.04.06
>  Copyright (c) 1999-2007 LSI Corporation
>  Fusion MPT SPI Host driver 3.04.06
>  Fusion MPT FC Host driver 3.04.06
>  Fusion MPT SAS Host driver 3.04.06
>  Fusion MPT misc device (ioctl) driver 3.04.06
>  mptctl: Registered with Fusion MPT base driver
>  mptctl: /dev/mptctl @ (major,minor=10,220)
>  ieee1394: raw1394: /dev/raw1394 device initialized
>  PCI: Enabling device 0000:00:03.3 (0100 -> 0102)
>  ehci_hcd 0000:00:03.3: EHCI Host Controller
>  ehci_hcd 0000:00:03.3: new USB bus registered, assigned bus number 1
>  ehci_hcd 0000:00:03.3: irq 11, io mem 0x2a102000
>  ehci_hcd 0000:00:03.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
>  usb usb1: configuration #1 chosen from 1 choice
>  hub 1-0:1.0: USB hub found
>  hub 1-0:1.0: 8 ports detected
>  116x: driver isp116x-hcd, 03 Nov 2005
>  PCI: Enabling device 0000:00:03.0 (0100 -> 0102)
>  ohci_hcd 0000:00:03.0: OHCI Host Controller
>  ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
>  ohci_hcd 0000:00:03.0: irq 11, io mem 0x2a105000
>  usb usb2: configuration #1 chosen from 1 choice
>  hub 2-0:1.0: USB hub found
>  hub 2-0:1.0: 3 ports detected
>  PCI: Enabling device 0000:00:03.1 (0100 -> 0102)
>  ohci_hcd 0000:00:03.1: OHCI Host Controller
>  ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
>  ohci_hcd 0000:00:03.1: irq 11, io mem 0x2a104000
>  hub 1-0:1.0: unable to enumerate USB device on port 5
>  usb usb3: configuration #1 chosen from 1 choice
>  hub 3-0:1.0: USB hub found
>  hub 3-0:1.0: 3 ports detected
>  PCI: Enabling device 0000:00:03.2 (0100 -> 0102)
>  ohci_hcd 0000:00:03.2: OHCI Host Controller
>  ohci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 4
>  ohci_hcd 0000:00:03.2: irq 10, io mem 0x2a103000
>  usb usb4: configuration #1 chosen from 1 choice
>  hub 4-0:1.0: USB hub found
>  hub 4-0:1.0: 2 ports detected
>  usb 1-6: new high speed USB device using ehci_hcd and address 3
>  USB Universal Host Controller Interface driver v3.0
>  sl811: driver sl811-hcd, 19 May 2005
>  usb 1-6: configuration #1 chosen from 1 choice
>  usb 3-2: new full speed USB device using ohci_hcd and address 2
>  usb 3-2: configuration #1 chosen from 1 choice
>  hub 3-2:1.0: USB hub found
>  hub 3-2:1.0: 3 ports detected
>  usb 3-2.1: new full speed USB device using ohci_hcd and address 3
>  usb 3-2.1: configuration #1 chosen from 1 choice
>  usbcore: registered new interface driver usblp
>  Initializing USB Mass Storage driver...
>  scsi5 : SCSI emulation for USB Mass Storage devices
>  usbcore: registered new interface driver usb-storage
>  USB Mass Storage support registered.
>  usbcore: registered new interface driver usblcd
>  PNP: No PS/2 controller found. Probing ports directly.
>  serio: i8042 KBD port at 0x60,0x64 irq 1
>  serio: i8042 AUX port at 0x60,0x64 irq 12
>  mice: PS/2 mouse device common for all mice
>  md: linear personality registered for level -1
>  md: raid0 personality registered for level 0
>  md: raid1 personality registered for level 1
>  md: raid10 personality registered for level 10
>  raid6: int32x1    504 MB/s
>  raid6: int32x2    514 MB/s
>  raid6: int32x4    366 MB/s
>  raid6: int32x8    348 MB/s
>  raid6: mmxx1     1630 MB/s
>  raid6: mmxx2     1787 MB/s
>  raid6: sse1x1    1125 MB/s
>  raid6: sse1x2    1394 MB/s
>  raid6: sse2x1    2028 MB/s
>  raid6: sse2x2    2212 MB/s
>  raid6: using algorithm sse2x2 (2212 MB/s)
>  md: raid6 personality registered for level 6
>  md: raid5 personality registered for level 5
>  md: raid4 personality registered for level 4
>  md: multipath personality registered for level -4
>  device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised:
> dm-devel@redhat.com
>  device-mapper: multipath: version 1.0.5 loaded
>  device-mapper: multipath round-robin: version 1.0.0 loaded
>  device-mapper: multipath emc: version 0.0.3 loaded
>  cpuidle: using governor ladder
>  sdhci: Secure Digital Host Controller Interface driver
>  sdhci: Copyright(c) Pierre Ossman
>  wbsd: Winbond W83L51xD SD/MMC card interface driver
>  wbsd: Copyright(c) Pierre Ossman
>  padlock: VIA PadLock not detected.
>  usbcore: registered new interface driver hiddev
>  input: Dell Dell USB Keyboard Hub as /class/input/input2
>  input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard Hub] on
>  usb-0000:00:03.1-2.1
>  input: Dell Dell USB Keyboard Hub as /class/input/input3
>  input: USB HID v1.10 Device [Dell Dell USB Keyboard Hub] on
> usb-0000:00:03.1-2.1
>  usbcore: registered new interface driver usbhid
>  drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
>  TCP cubic registered
>  NET: Registered protocol family 1
>  NET: Registered protocol family 17
>  RPC: Registered udp transport module.
>  RPC: Registered tcp transport module.
>  Using IPI Shortcut mode
>  BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
>  Freeing unused kernel memory: 332k freed
> 
>  INIT: version 2.86 booting
>  none on /proc type proc (rw)
>  sysfs on /sys type sysfs (rw)
>  Initializing udev dynamic device directory.
>  Checking non-root filesystems:
>  fsck 1.40.9 (27-Apr-2008)
>  none on /dev/pts type devpts (rw,gid=5,mode=620)
>  none on /proc/bus/usb type usbfs (rw)
>  Running /etc/rc.d/rc.modules:
>  Updating module dependencies for Linux 2.6.25.1:
> 
>  INIT: Entering runlevel: 3
>  Going multiuser...
>  Updating shared library links:  /sbin/ldconfig &
>  Starting sysklogd daemons:  /usr/sbin/syslogd /usr/sbin/klogd -c 3 -x
>  Starting ACPI daemon:  /usr/sbin/acpid
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

