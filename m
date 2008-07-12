From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PROBLEM: module a100u2w (SCSI, Initio) on ppc
Date: Fri, 11 Jul 2008 22:09:01 -0700
Message-ID: <20080711220901.e1b69adb.akpm@linux-foundation.org>
References: <20080712033040.GA8086@h42136.pems.adfa.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470AbYGLFKO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jul 2008 01:10:14 -0400
In-Reply-To: <20080712033040.GA8086@h42136.pems.adfa.edu.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Harker <s.harker@adfa.edu.au>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

(cc linux-scsi)

On Sat, 12 Jul 2008 13:30:41 +1000 Stephen Harker <s.harker@adfa.edu.au> wrote:

> The SCSI Initio a100u2w driver compiles as a module, loads, but
> hangs on a powerpc machine.  
> 
> I am running linux (YellowDog 5.0) on a PowerMac 7600.  I am using
> self-compiled kernels.  The initio a100u2w card runs successfully
> under Mac OSX and OS9.  In the past when I tried the a100u2w module
> under kernel 2.4 and early 2.6 it would hang for at least 30 minutes
> (in the end I rebooted the machine).
> 
> I thought I would try again recently using 2.6.23.14 and 2.6.25.4
> kernels.  This was more successful in that the machine did not hang
> seemingly forever.  However, the module seems to fail in
> initialisation and no drive partitions are seen/mounted.  I tried
> removing the module (rmmod), the reloading it (modprobe) and similar
> issues are noted.  Output from dmesg shows the problems.  The
> following is the output from dmesg under 2.6.25.4, look for scsi2 and
> initio and inia100.  I am afraid that I am away from home at present
> and  don't have all the information that may be desirable.  I hope the
> following is adequate.  The kernel and system run well except for this
> one module.
> 
> Using PowerMac machine description
> Total memory = 768MB; using 2048kB for hash table (at cfe00000)
> Linux version 2.6.25.4 (root@wonnangatta) (gcc version 4.1.1 20060525 (Yellow Dog 4.1.1-1)) #5 Sat Jul 5 11:02:58 EST 2008
> Found a Grand Central mac-io controller, rev: 2, mapped at 0xfdf00000
> PowerMac motherboard: PowerMac 7500
> console [udbg0] enabled
> Entering add_active_range(0, 0, 196608) 0 entries of 256 used
> Cache coherency enabled for bandit/PSX
> Found Bandit PCI host bridge at 0x00000000f2000000. Firmware bus number: 0->1
> PCI host bridge /bandit (primary) ranges:
>  MEM 0x00000000f3000000..0x00000000f3ffffff -> 0x00000000f3000000 
>   IO 0x00000000f2000000..0x00000000f27fffff -> 0x0000000000000000
>  MEM 0x0000000080000000..0x000000008fffffff -> 0x0000000080000000 
> Found Chaos PCI host bridge at 0x00000000f0000000. Firmware bus number: 2->2
> PCI host bridge /chaos  ranges:
>  MEM 0x00000000f1000000..0x00000000f1ffffff -> 0x00000000f1000000 
>   IO 0x00000000f0000000..0x00000000f07fffff -> 0x0000000000000000
>  MEM 0x0000000090000000..0x000000009fffffff -> 0x0000000090000000 
> nvram: OF partition at 0x1800
> nvram: XP partition at 0x1300
> nvram: NR partition at 0x1400
> Top of RAM: 0x30000000, Total RAM: 0x30000000
> Memory hole size: 0MB
> Zone PFN ranges:
>   DMA             0 ->   196608
>   Normal     196608 ->   196608
> Movable zone start PFN for each node
> early_node_map[1] active PFN ranges
>     0:        0 ->   196608
> On node 0 totalpages: 196608
>   DMA zone: 1536 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 195072 pages, LIFO batch:31
>   Normal zone: 0 pages used for memmap
>   Movable zone: 0 pages used for memmap
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 195072
> Kernel command line: root=/dev/sda8 video=atyfb:vmode:16,cmode:32, lcr=0xB9180000
> irq: Found primary Apple PIC /bandit/gc for 32 irqs
> irq: System has 32 possible interrupts
> PID hash table entries: 4096 (order: 12, 16384 bytes)
> GMT Delta read from XPRAM: 600 minutes, DST: off
> time_init: decrementer frequency = 12.498833 MHz
> time_init: processor frequency   = 455.000000 MHz
> clocksource: timebase mult[14007a61] shift[22] registered
> clockevent: decrementer mult[333] shift[16] cpu[0]
> Console: colour dummy device 80x25
> console handover: boot [udbg0] -> real [tty0]
> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Memory: 766336k/786432k available (4328k kernel code, 19760k reserved, 160k data, 137k bss, 208k init)
> SLUB: Genslabs=12, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
> Calibrating delay loop... 24.96 BogoMIPS (lpj=49920)
> Mount-cache hash table entries: 512
> device-tree: Duplicate name in /bandit/pci-bridge, renamed to "pci3592,35#1"
> net_namespace: 536 bytes
> NET: Registered protocol family 16
> PCI: Probing PCI hardware
> PCI: Cannot allocate resource region 0 of device 0001:02:0d.0, will remap
> PCI: Bridge: 0000:00:0f.0
>   IO window: disabled.
>   MEM window: 0x80800000-0x808fffff
>   PREFETCH window: disabled.
> Registering pmac pic with sysfs...
> SCSI subsystem initialized
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> NET: Registered protocol family 2
> Switched to high resolution mode on CPU 0
> IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
> TCP: Hash tables configured (established 131072 bind 65536)
> TCP reno registered
> Thermal assist unit using timers, shrink_timer: 500 jiffies
> audit: initializing netlink socket (disabled)
> type=2000 audit(1215242654.320:1): initialized
> VFS: Disk quotas dquot_6.5.1
> Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
> io scheduler noop registered
> io scheduler anticipatory registered (default)
> io scheduler deadline registered
> io scheduler cfq registered
> PCI: Enabling device 0000:00:0e.0 (0086 -> 0087)
> aty128fb: Found Open Firmware ROM Image
> aty128fb: BIOS not located, guessing timings.
> aty128fb: Rage128 RE PCI [chip rev 0x2] 16M 128-bit SDR SGRAM (1:1)
> Console: switching to colour frame buffer device 128x48
> fb0: ATY Rage128 frame buffer device on Rage128 RE PCI
> controlfb: VRAM Total = 4MB (2MB @ bank 1, 2MB @ bank 2)
> controlfb: using video mode 6 and color mode 0.
> fb1: control display adapter
> Generic RTC Driver v1.07
> Macintosh non-volatile memory driver v1.1
> brd: module loaded
> loop: module loaded
> pcnet32.c:v1.34 14.Aug.2007 tsbogend@alpha.franken.de
> PPP generic driver version 2.4.2
> PPP Deflate Compression module registered
> MacIO PCI driver attached to Grand Central chipset
> eth0: MACE at 00:05:02:ae:83:28, chip revision 25.64
> input: Macintosh mouse button emulation as /class/input/input0
> Macintosh CUDA driver v0.5 for Unified ADB.
> Uniform Multi-Platform E-IDE driver
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> adb: starting probe task...
> ide-floppy driver 1.00
> mesh: configured for synchronous 10 MB/s
> adb devices: [2]: 2 2 [3]: 3 1
> ADB keyboard at 2, handler set to 3
> Detected ADB keyboard, type ANSI.
> input: ADB keyboard as /class/input/input1
> mesh: performing initial bus reset...
> ADB mouse at 3, handler set to 2
> input: ADB mouse as /class/input/input2
> adb: finished probe task...
> scsi0 : MESH
> scsi1 : 53C94
> st: Version 20080221, fixed bufsize 32768, s/g segs 256
> Driver 'st' needs updating - please use bus_type methods
> Driver 'sd' needs updating - please use bus_type methods
> Driver 'sr' needs updating - please use bus_type methods
> usbmon: debugfs is not available
> ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
> PCI: Enabling device 0000:01:00.0 (0014 -> 0016)
> ohci_hcd 0000:01:00.0: OHCI Host Controller
> ohci_hcd 0000:01:00.0: new USB bus registered, assigned bus number 1
> ohci_hcd 0000:01:00.0: irq 25, io mem 0x80803000
> usb usb1: configuration #1 chosen from 1 choice
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 3 ports detected
> mesh: target 2 synchronous at 10.0 MB/s
> scsi 0:0:2:0: Direct-Access     IBM-PSG  DNES-318350Y  !# SA30 PQ: 0 ANSI: 3
> mesh: target 3 synchronous at 10.0 MB/s
> scsi 0:0:3:0: CD-ROM            SONY     CD-RW  CRX160S   1.0a PQ: 0 ANSI: 4
> PCI: Enabling device 0000:01:00.1 (0014 -> 0016)
> ohci_hcd 0000:01:00.1: OHCI Host Controller
> ohci_hcd 0000:01:00.1: new USB bus registered, assigned bus number 2
> ohci_hcd 0000:01:00.1: irq 25, io mem 0x80802000
> usb usb2: configuration #1 chosen from 1 choice
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 2 ports detected
> usb 1-2: new low speed USB device using ohci_hcd and address 2
> sd 0:0:2:0: [sda] 35548320 512-byte hardware sectors (18201 MB)
> sd 0:0:2:0: [sda] Write Protect is off
> sd 0:0:2:0: [sda] Mode Sense: c3 00 00 08
> usb 1-2: configuration #1 chosen from 1 choice
> sd 0:0:2:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> sd 0:0:2:0: [sda] 35548320 512-byte hardware sectors (18201 MB)
> sd 0:0:2:0: [sda] Write Protect is off
> sd 0:0:2:0: [sda] Mode Sense: c3 00 00 08
> sd 0:0:2:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>  sda: [mac] sda1 sda2 sda3 sda4 sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 sda13
> sd 0:0:2:0: [sda] Attached SCSI disk
> sd 0:0:2:0: Attached scsi generic sg0 type 0
> mice: PS/2 mouse device common for all mice
> APM Battery Driver
> input: Logitech USB-PS/2 Optical Mouse as /class/input/input3
> input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:01:00.0-2
> usb 2-2: new full speed USB device using ohci_hcd and address 2
> usb 2-2: configuration #1 chosen from 1 choice
> usbcore: registered new interface driver usbhid
> drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
> oprofile: using timer interrupt.
> TCP cubic registered
> Initializing XFRM netlink socket
> NET: Registered protocol family 1
> NET: Registered protocol family 17
> NET: Registered protocol family 15
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> scsi: waiting for bus probes to complete ...
> sr0: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
> Uniform CD-ROM driver Revision: 3.20
> sr 0:0:3:0: Attached scsi CD-ROM sr0
> sr 0:0:3:0: Attached scsi generic sg1 type 5
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: mounted filesystem with ordered data mode.
> VFS: Mounted root (ext3 filesystem) readonly.
> Freeing unused kernel memory: 208k init
> pmac_zilog: 0.6 (Benjamin Herrenschmidt <benh@kernel.crashing.org>)
> ttyS0 at MMIO 0xf3013020 (irq = 36) is a Z85c30 ESCC - Serial port
> ttyS1 at MMIO 0xf3013000 (irq = 39) is a Z85c30 ESCC - Serial port
> Linux agpgart interface v0.103
> scsi2 : Initio INI-A100U2W SCSI device driver; Revision: 1.02d
> Initializing USB Mass Storage driver...
> scsi3 : SCSI emulation for USB Mass Storage devices
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> usb-storage: device found at 2
> usb-storage: waiting for device to settle before scanning
> usbcore: registered new interface driver ub
> usb-storage: device scan complete
> scsi 3:0:0:0: Direct-Access     ST320082 2A                    PQ: 0 ANSI: 0
> PCI: Enabling device 0000:01:00.2 (0014 -> 0016)
> ehci_hcd 0000:01:00.2: EHCI Host Controller
> ehci_hcd 0000:01:00.2: new USB bus registered, assigned bus number 3
> ehci_hcd 0000:01:00.2: irq 25, io mem 0x80800000
> usb 1-2: USB disconnect, address 2
> ehci_hcd 0000:01:00.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004
> usb usb3: configuration #1 chosen from 1 choice
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 5 ports detected
> usb 2-2: USB disconnect, address 2
> PCI: Enabling device 0000:01:01.0 (0014 -> 0016)
> ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[25]  MMIO=[80801000-808017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
> ieee1394: Node added: ID:BUS[0-00:1023]  GUID[0001a37050300510]
> ieee1394: Host added: ID:BUS[0-01:1023]  GUID[00004ce0b000280e]
> IEEE 1394 device has ROM CRC error
> scsi4 : SBP-2 IEEE-1394
> device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
> ieee1394: sbp2: Logged into SBP-2 device
> ieee1394: sbp2: Node 0-00:1023: Max speed [S400] - Max payload [2048]
> scsi: waiting for bus probes to complete ...
> EXT3 FS on sda8, internal journal
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
> EXT3 FS on sda10, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on sda11, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on sda12, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on sda9, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> scsi 2:0:0:0: Device offlined - not ready after error recovery
> Adding 262136k swap on /dev/sda7.  Priority:-1 extents:1 across:262136k
> Adding 713700k swap on /dev/sda13.  Priority:-2 extents:1 across:713700k
> warning: process `kudzu' used the deprecated sysctl system call with 1.23.
> ip_tables: (C) 2000-2006 Netfilter Core Team
> scsi 2:0:1:0: Device offlined - not ready after error recovery
> scsi 2:0:2:0: Device offlined - not ready after error recovery
> scsi 2:0:3:0: Device offlined - not ready after error recovery
> scsi 2:0:4:0: Device offlined - not ready after error recovery
> warning: `named' uses 32-bit capabilities (legacy support in use)
> scsi 2:0:5:0: Device offlined - not ready after error recovery
> scsi 2:0:6:0: Device offlined - not ready after error recovery
> scsi 2:0:8:0: Device offlined - not ready after error recovery
> scsi 2:0:9:0: Device offlined - not ready after error recovery
> scsi 2:0:10:0: Device offlined - not ready after error recovery
> scsi 2:0:11:0: Device offlined - not ready after error recovery
> scsi 2:0:12:0: Device offlined - not ready after error recovery
> scsi 2:0:13:0: Device offlined - not ready after error recovery
> scsi 2:0:14:0: Device offlined - not ready after error recovery
> scsi 2:0:15:0: Device offlined - not ready after error recovery
> sd 3:0:0:0: [sdb] READ CAPACITY failed
> sd 3:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> sd 3:0:0:0: [sdb] Sense not available.
> sd 3:0:0:0: [sdb] Write Protect is off
> sd 3:0:0:0: [sdb] Mode Sense: 00 00 00 00
> sd 3:0:0:0: [sdb] Assuming drive cache: write through
> sd 3:0:0:0: [sdb] Attached SCSI disk
> sd 3:0:0:0: Attached scsi generic sg2 type 0
> scsi 4:0:0:0: CD-ROM            LITE-ON  COMBO SOHC-5232K NK0G PQ: 0 ANSI: 0
> sr1: scsi3-mmc drive: 0x/52x writer cd/rw xa/form2 cdda tray
> sr 4:0:0:0: Attached scsi CD-ROM sr1
> sr 4:0:0:0: Attached scsi generic sg2 type 5
> fd0: SWIM3 floppy controller 
> hub 3-0:1.0: unable to enumerate USB device on port 3
> usb 3-4: new high speed USB device using ehci_hcd and address 3
> usb 3-4: configuration #1 chosen from 1 choice
> scsi5 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 3
> usb-storage: waiting for device to settle before scanning
> usb 1-2: new low speed USB device using ohci_hcd and address 3
> usb 1-2: configuration #1 chosen from 1 choice
> input: Logitech USB-PS/2 Optical Mouse as /class/input/input4
> input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:01:00.0-2
> input: PowerMac Beep as /class/input/input5
> usb-storage: device scan complete
> scsi 5:0:0:0: Direct-Access     ST320082 2A                    PQ: 0 ANSI: 0
> sd 5:0:0:0: [sdb] 390721968 512-byte hardware sectors (200050 MB)
> sd 5:0:0:0: [sdb] Write Protect is off
> sd 5:0:0:0: [sdb] Mode Sense: 33 00 00 00
> sd 5:0:0:0: [sdb] Assuming drive cache: write through
> sd 5:0:0:0: [sdb] 390721968 512-byte hardware sectors (200050 MB)
> sd 5:0:0:0: [sdb] Write Protect is off
> sd 5:0:0:0: [sdb] Mode Sense: 33 00 00 00
> sd 5:0:0:0: [sdb] Assuming drive cache: write through
>  sdb: [mac] sdb1 sdb2 sdb3 sdb4 sdb5 sdb6 sdb7 sdb8 sdb9 sdb10 sdb11 sdb12 sdb13
> sd 5:0:0:0: [sdb] Attached SCSI disk
> sd 5:0:0:0: Attached scsi generic sg3 type 0
> [drm] Initialized drm 1.1.0 20060810
> [drm] Initialized r128 2.5.0 20030725 on minor 0
> kjournald starting.  Commit interval 5 seconds
> EXT3 FS on sdb12, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> inia100: initial orchid fail!!
> 
> The following is the output of cat /proc/cpuinfo
> 
> processor	: 0
> cpu		: 7400, altivec supported
> temperature 	: 27-29 C (uncalibrated)
> clock		: 455.000000MHz
> revision	: 2.9 (pvr 000c 0209)
> bogomips	: 24.96
> timebase	: 12498833
> platform	: PowerMac
> machine		: Power Macintosh
> motherboard	: AAPL,7500 MacRISC
> detected as	: 16 (PowerMac 7500)
> pmac flags	: 00000000
> pmac-generation	: OldWorld
> 
> The following is the output of lspci -vvv (as root)
> 
> 00:0b.0 Host bridge: Apple Computer Inc. Bandit PowerPC host bridge (rev 03)
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
> 	Latency: 32, Cache Line Size 08
> 	Interrupt: pin ? routed to IRQ 22
> 
> 00:0d.0 SCSI storage controller: Initio Corporation INI-A100U2W (rev 01)
> 	Subsystem: Initio Corporation INI-A100U2W
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 32, Cache Line Size 08
> 	Interrupt: pin A routed to IRQ 23
> 	Region 0: I/O ports at 1000 [size=256]
> 	Region 1: Memory at 80900000 (32-bit, non-prefetchable) [size=4K]
> 	Expansion ROM at f3040000 [disabled] [size=64K]
> 	Capabilities: [50] Power Management version 1
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:0e.0 VGA compatible controller: ATI Technologies Inc Rage 128 RE/SG (prog-if 00 [VGA])
> 	Subsystem: Unknown device b530:0408
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 32 (2000ns min), Cache Line Size 08
> 	Interrupt: pin A routed to IRQ 24
> 	Region 0: Memory at 88000000 (32-bit, prefetchable) [size=64M]
> 	Region 1: I/O ports at 0400 [size=256]
> 	Region 2: Memory at 80904000 (32-bit, non-prefetchable) [size=16K]
> 	Expansion ROM at f3020000 [disabled] [size=128K]
> 	Capabilities: [5c] Power Management version 1
> 		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:0f.0 PCI bridge: Hint Corp HB6 Universal PCI-PCI bridge (non-transparent mode) (rev 11) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 32, Cache Line Size 08
> 	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
> 	I/O behind bridge: 0000f000-00000fff
> 	Memory behind bridge: 80800000-808fffff
> 	Prefetchable memory behind bridge: fff00000-000fffff
> 	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 	Capabilities: [80] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 		Bridge: PM- B3+
> 	Capabilities: [90] #06 [0000]
> 
> 00:10.0 Class ff00: Apple Computer Inc. Grand Central I/O (rev 02)
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR+
> 	Latency: 32, Cache Line Size 08
> 	Interrupt: pin ? routed to IRQ 22
> 	Region 0: Memory at f3000000 (32-bit, non-prefetchable) [size=128K]
> 
> 01:00.0 USB Controller: NEC Corporation USB (rev 41) (prog-if 10 [OHCI])
> 	Subsystem: Unknown device 3592:0035
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 32 (250ns min, 10500ns max), Cache Line Size 08
> 	Interrupt: pin A routed to IRQ 25
> 	Region 0: Memory at 80803000 (32-bit, non-prefetchable) [size=4K]
> 	Capabilities: [40] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 01:00.1 USB Controller: NEC Corporation USB (rev 41) (prog-if 10 [OHCI])
> 	Subsystem: Unknown device 3592:0035
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 32 (250ns min, 10500ns max), Cache Line Size 08
> 	Interrupt: pin B routed to IRQ 25
> 	Region 0: Memory at 80802000 (32-bit, non-prefetchable) [size=4K]
> 	Capabilities: [40] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 01:00.2 USB Controller: NEC Corporation USB 2.0 (rev 02) (prog-if 20 [EHCI])
> 	Subsystem: Unknown device 3592:2050
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 32 (4000ns min, 8500ns max), Cache Line Size 08
> 	Interrupt: pin C routed to IRQ 25
> 	Region 0: Memory at 80800000 (32-bit, non-prefetchable) [size=256]
> 	Capabilities: [40] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 01:01.0 FireWire (IEEE 1394): NEC Corporation uPD72874 IEEE1394 OHCI 1.1 3-port PHY-Link Ctrlr (rev 01) (prog-if 10 [OHCI])
> 	Subsystem: NEC Corporation uPD72874 IEEE1394 OHCI 1.1 3-port PHY-Link Ctrlr
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 32 (5000ns min, 11000ns max), Cache Line Size 08
> 	Interrupt: pin A routed to IRQ 25
> 	Region 0: Memory at 80801000 (32-bit, non-prefetchable) [size=4K]
> 	Capabilities: [60] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
> 
> 0001:02:0b.0 Non-VGA unclassified device: Apple Computer Inc. Control Video
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Interrupt: pin ? routed to IRQ 26
> 	Region 1: Memory at 90000000 (32-bit, non-prefetchable) [disabled] [size=64K]
> 	Region 2: Memory at 94000000 (32-bit, non-prefetchable) [disabled] [size=64M]
> 
> 0001:02:0d.0 Class ff00: Apple Computer Inc. PlanB Video-In (rev 01)
> 	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 32, Cache Line Size 08
> 	Interrupt: pin ? routed to IRQ 28
> 	Region 0: Memory at f1000000 (32-bit, non-prefetchable) [disabled] [size=1K]
> 

