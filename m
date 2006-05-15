From: Dario Oliva <anikami1@gmail.com>
Subject: IO Data USB HD - read/write with SGIO ioctl does not acces the drive,
 kernel 2.6.15.6
Date: Mon, 15 May 2006 16:15:43 -0400
Message-ID: <4468E16F.4060709@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080008060206020709030809"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.233]:5294 "EHLO
	wr-out-0506.google.com") by vger.kernel.org with ESMTP
	id S965215AbWEOUPw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 May 2006 16:15:52 -0400
Received: by wr-out-0506.google.com with SMTP id i5so55512wra
        for <linux-scsi@vger.kernel.org>; Mon, 15 May 2006 13:15:50 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: doliva@arcoide.com

This is a multi-part message in MIME format.
--------------080008060206020709030809
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I am trying to use the SG_IO ioctl from the scsi driver to read and 
write raw
data to this USB hard drive (IO Data USB HD). I have googled the device 
name and
only came up with 13 sites, none of which had any information for this 
problem.
This is a link to a reseller in California who sells the device I am using
http://www.devicenet-usa.com/product_en.html#hdp

To verify that the data was not being written from the device or read 
from the device,
I used a protocol analyzer connected to the hard disk While sending the 
read or write
commands using SG_IO, there was no activity on the disk. I have also 
used a program I wrote
that reads individual sectors from a disk and displays the data in a 
format similar to hexdump.
The output from that program is also attached, in the file named data. 
As you will see, I did a read
several times from sector 0, receiving different slightly different 
values every time.

I am attaching output from dmesg gathered while connecting and reading 
from the device.


Where should I go from here? Are there other debug messages I can enable 
within the scsi generic drivers.


Dario Oliva

--------------080008060206020709030809
Content-Type: text/plain;
 name="dmesg-2.6.15.6-ezb"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg-2.6.15.6-ezb"

Linux version 2.6.15.6-ezb (dario@linux) (gcc version 3.3.5 20050117 (prerelease) (SUSE Linux)) #16 Mon May 15 14:10:13 EDT 2006
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000f6e0000 (usable)
 BIOS-e820: 000000000f6e0000 - 000000000f6f7000 (ACPI data)
 BIOS-e820: 000000000f6f7000 - 000000000f6f9000 (ACPI NVS)
 BIOS-e820: 000000000f700000 - 0000000010000000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
246MB LOWMEM available.
On node 0 totalpages: 63200
  DMA zone: 4096 pages, LIFO batch:0
  DMA32 zone: 0 pages, LIFO batch:0
  Normal zone: 59104 pages, LIFO batch:15
  HighMem zone: 0 pages, LIFO batch:0
DMI present.
ACPI: RSDP (v002 IBM                                   ) @ 0x000f6e30
ACPI: XSDT (v001 IBM    TP-1V    0x00001170  LTP 0x00000000) @ 0x0f6eb5fe
ACPI: FADT (v003 IBM    TP-1V    0x00001170 IBM  0x00000001) @ 0x0f6eb700
ACPI: SSDT (v001 IBM    TP-1V    0x00001170 MSFT 0x0100000e) @ 0x0f6eb8b4
ACPI: ECDT (v001 IBM    TP-1V    0x00001170 IBM  0x00000001) @ 0x0f6f6e8b
ACPI: TCPA (v001 IBM    TP-1V    0x00001170 PTL  0x00000001) @ 0x0f6f6edd
ACPI: BOOT (v001 IBM    TP-1V    0x00001170  LTP 0x00000001) @ 0x0f6f6fd8
ACPI: DSDT (v001 IBM    TP-1V    0x00001170 MSFT 0x0100000e) @ 0x00000000
ACPI: PM-Timer IO Port: 0x1008
Allocating PCI resources starting at 20000000 (gap: 10000000:ef800000)
Built 1 zonelists
Kernel command line: root=/dev/hda6 vga=0x314 selinux=0  splash=silen
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (011ef000)
Initializing CPU#0
PID hash table entries: 1024 (order: 10, 16384 bytes)
Detected 1498.885 MHz processor.
Using pmtmr for high-res timesource
Console: colour dummy device 80x25
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 242820k/252800k available (3145k kernel code, 9416k reserved, 1163k data, 236k init, 0k highmem)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 2999.93 BogoMIPS (lpj=5999875)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: a7e9f9bf 00000000 00000000 00000000 00000180 00000000 00000000
CPU: After vendor identify, caps: a7e9f9bf 00000000 00000000 00000000 00000180 00000000 00000000
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 1024K
CPU: After all inits, caps: a7e9f9bf 00000000 00000000 00000040 00000180 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
mtrr: v2.0 (20020519)
CPU: Intel(R) Pentium(R) M processor 1500MHz stepping 05
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
ACPI: setting ELCR to 0200 (from 0800)
checking if image is initramfs... it is
Freeing initrd memory: 1334k freed
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd8e6, last bus=5
PCI: Using configuration type 1
ACPI: Subsystem revision 20050902
ACPI: Found ECDT
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:00:02.0
PCI quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH4 GPIO
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: Embedded Controller [EC] (gpe 28)
ACPI: Power Resource [PUBS] (on)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
SCSI subsystem initialized
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0
PCI: Bus 3, cardbus bridge: 0000:02:00.0
  IO window: 00003000-000030ff
  IO window: 00003400-000034ff
  PREFETCH window: f0000000-f1ffffff
  MEM window: d2000000-d3ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 3000-7fff
  MEM window: d0200000-dfffffff
  PREFETCH window: f0000000-f7ffffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
Simple Boot Flag at 0x35 set to 0x1
IBM machine detected. Enabling interrupts during APM calls.
apm: BIOS not found.
audit: initializing netlink socket (disabled)
audit(1147705940.568:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
NTFS driver 2.1.25 [Flags: R/W DEBUG].
Initializing Cryptographic API
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2000
 0000:00:1d.0: Performing full reset
 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
 0000:00:1d.1: Performing full reset
 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
 0000:00:1d.2: Performing full reset
vesafb: framebuffer at 0xe0000000, mapped to 0xd0080000, using 3750k, total 8000k
vesafb: mode is 800x600x16, linelength=1600, pages=7
vesafb: protected mode interface info at 00ff:44f0
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
vesafb: Mode is VGA compatible
bootsplash 3.1.6-2004/03/31: looking for picture...<6> silentjpeg size 39926 bytes,<6>...found (800x600, 25182 bytes, v3).
Console: switching to colour frame buffer device 100x37
fb0: VESA VGA frame buffer device
vga16fb: initializing
vga16fb: mapped to 0xc00a0000
fb1: VGA16 VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
pnp: Device 00:09 activated.
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI interrupt for device 0000:00:1f.6 disabled
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH4: IDE controller at PCI slot 0000:00:1f.1
PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
ICH4: chipset revision 1
ICH4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1810-0x1817, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x1818-0x181f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: ST9808210A, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: HL-DT-STCD-RW/DVD DRIVE GCC-4241N, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 156301488 sectors (80026 MB) w/8192KiB Cache, CHS=65535/16/63, UDMA(100)
hda: cache flushes supported
 hda: hda1 hda2 hda3 < hda5 hda6 >
hdc: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
libata version 1.20 loaded.
st: Version 20050830, fixed bufsize 32768, s/g segs 256
osst :I: Tape driver with OnStream support version 0.99.3
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
SCSI Media Changer driver v0.25 
ieee1394: Initialized config rom entry `ip1394'
video1394: Installed video1394 module
ieee1394: raw1394: /dev/raw1394 device initialized
sbp2: $Rev: 1306 $ Ben Collins <bcollins@debian.org>
ieee1394: sbp2: Driver forced to serialize I/O (serialize_io=1)
ieee1394: sbp2: Try serialize_io=0 for better performance
ieee1394: Loaded AMDTP driver
ieee1394: Loaded CMP driver
pd: pd version 1.05, major 45, cluster 64, nice 0
pda: Autoprobe failed
pd: no valid drive found
pcd: pcd version 1.07, major 46, nice 0
pcd0: Autoprobe failed
pcd: No CD-ROM drive found
pf: pf version 1.04, major 47, cluster 64, nice 0
pf: No ATAPI disk detected
pt: pt version 1.04, major 96
pt0: Autoprobe failed
pt: No ATAPI tape drive detected
pg: pg version 1.02, major 97
pga: Autoprobe failed
pg: No ATAPI device detected
usbmon: debugfs is not available
ehci_hcd: block sizes: qh 128 qtd 96 itd 192 sitd 96
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: capability 0001 at 68
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: irq 11, io mem 0xd0100000
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: default language 0x0409
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.15.6-ezb ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
usb usb1: hotplug
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: hotplug
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: Single TT
hub 1-0:1.0: TT requires at most 8 FS bit times (666 ns)
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: state 5 ports 6 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
ohci_hcd: 2005 April 22 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
ohci_hcd: block sizes: ed 64 td 64
ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001403 POWER sig=k CSC CONNECT
hub 1-0:1.0: port 3, status 0501, change 0001, 480 Mb/s
USB Universal Host Controller Interface driver v2.3
ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001820
usb usb2: default language 0x0409
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.15.6-ezb uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
usb usb2: hotplug
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: hotplug
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 1-0:1.0: debounce: port 3: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 3 low speed --> companion
drivers/usb/core/inode.c: creating file '001'
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
drivers/usb/core/inode.c: creating file '003'
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 11, io base 0x00001840
usb usb3: default language 0x0409
usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.15.6-ezb uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
usb usb3: hotplug
ehci_hcd 0000:00:1d.7: GetStatus port 3 status 003002 POWER OWNER sig=se0 CSC
hub 2-0:1.0: state 5 ports 2 chg 0000 evt 0000
usb usb3: adding 3-0:1.0 (config #1, interface 0)
usb 3-0:1.0: hotplug
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: power on to power good time: 2ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: state 5 ports 2 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.1: port 1 portsc 01ab,00
hub 3-0:1.0: port 1, status 0301, change 0003, 1.5 Mb/s
drivers/usb/core/inode.c: creating file '004'
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 11, io base 0x00001860
usb usb4: default language 0x0409
usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.15.6-ezb uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
usb usb4: hotplug
usb usb4: adding 4-0:1.0 (config #1, interface 0)
usb 4-0:1.0: hotplug
hub 4-0:1.0: usb_probe_interface
hub 4-0:1.0: usb_probe_interface - got id
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: power on to power good time: 2ms
hub 4-0:1.0: local power source is good
hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
drivers/usb/core/inode.c: creating file '001'
Initializing USB Mass Storage driver...
usb 3-1: new low speed USB device using uhci_hcd and address 2
usb 3-1: skipped 1 descriptor after interface
usb 3-1: default language 0x0409
usb 3-1: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1: Product: USB Receiver
usb 3-1: Manufacturer: Logitech
usb 3-1: hotplug
usb 3-1: adding 3-1:1.0 (config #1, interface 0)
usb 3-1:1.0: hotplug
drivers/usb/core/inode.c: creating file '002'
hub 3-0:1.0: state 5 ports 2 chg 0000 evt 0000
usbcore: registered new driver usb-storage
USB Mass Storage support registered.
hub 4-0:1.0: state 5 ports 2 chg 0000 evt 0000
usbcore: registered new driver hiddev
usbhid 3-1:1.0: usb_probe_interface
usbhid 3-1:1.0: usb_probe_interface - got id
input: Logitech USB Receiver as /class/input/input0
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1d.1-1
usbcore: registered new driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
usbcore: registered new driver usbserial
drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
usbcore: registered new driver usbserial_generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input1
md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bitmap version 4.39
NET: Registered protocol family 2
input: AT Translated Set 2 keyboard as /class/input/input2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 3, 32768 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 8
NET: Registered protocol family 20
Using IPI Shortcut mode
ACPI wakeup devices: 
 LID SLPB PCI0 UART PCI1 USB0 USB1 USB2 AC9M 
ACPI: (supports S0 S3 S4 S5)
Freeing unused kernel memory: 236k freed
uhci_hcd 0000:00:1d.0: suspend_rh (auto-stop)
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /class/input/input3
ide_core: disagrees about version of symbol struct_module
uhci_hcd 0000:00:1d.2: suspend_rh (auto-stop)
piix: disagrees about version of symbol struct_module
ide_disk: disagrees about version of symbol struct_module
cdrom: disagrees about version of symbol struct_module
ide_cd: disagrees about version of symbol struct_module
jbd: disagrees about version of symbol struct_module
ext3: disagrees about version of symbol struct_module
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-devel@redhat.com
NTFS volume version 3.1.
parport: PnPBIOS parport detected.
parport0: PC-style at 0x3bc, irq 7 [PCSPP,TRISTATE]
lp0: using parport0 (interrupt-driven).
Adding 1574328k swap on /dev/hda5.  Priority:42 extents:1 across:1574328k
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
IPv6 over IPv4 tunneling driver
ip6_tables: (C) 2000-2002 Netfilter core team
Linux agpgart interface v0.101 (c) Dave Jones
ip_tables: (C) 2000-2002 Netfilter core team
agpgart: Detected an Intel 855 Chipset.
agpgart: Detected 8060K stolen memory.
agpgart: AGP aperture is 128M @ 0xe0000000
ip_conntrack version 2.4 (1975 buckets, 15800 max) - 212 bytes per conntrack
e100: Intel(R) PRO/100 Network Driver, 3.4.14-k4-NAPI
e100: Copyright(c) 1999-2005 Intel Corporation
ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 11
ACPI: PCI Interrupt 0000:02:08.0[A] -> Link [LNKE] -> GSI 11 (level, low) -> IRQ 11
e100: eth0: e100_probe: addr 0xd0201000, irq 11, MAC addr 00:11:25:42:11:4F
ieee80211_crypt: registered algorithm 'NULL'
ieee80211: 802.11 data/management/control stack, git-1.1.7
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, git-1.0.8
ipw2200: Copyright(c) 2003-2005 Intel Corporation
ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 11
ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKF] -> GSI 11 (level, low) -> IRQ 11
ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
ipw2200: ipw-2.4-boot.fw load failed: Reason -2
ipw2200: Unable to load firmware: -2
ipw2200: failed to register network device
sit0: Disabled Privacy Extensions
ACPI: PCI interrupt for device 0000:02:02.0 disabled
ipw2200: probe of 0000:02:02.0 failed with error -5
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
ADDRCONF(NETDEV_UP): eth0: link is not ready
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
NET: Registered protocol family 17
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
cdrom: open failed.
eth0: no IPv6 routers present
Non-volatile memory driver v1.2
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
ACPI: Power Button (FF) [PWRF]
ACPI: Lid Switch [LID]
ACPI: Sleep Button (CM) [SLPB]
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU] (supports 8 throttling states)
ACPI: Thermal Zone [THM0] (51 C)
end_request: I/O error, dev fd0, sector 0
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.1.67 DST=224.0.0.251 LEN=106 TOS=0x00 PREC=0x00 TTL=255 ID=7 DF PROTO=UDP SPT=5353 DPT=5353 LEN=86 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.1.67 DST=224.0.0.251 LEN=106 TOS=0x00 PREC=0x00 TTL=255 ID=8 DF PROTO=UDP SPT=5353 DPT=5353 LEN=86 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=192.168.1.67 DST=224.0.0.251 LEN=106 TOS=0x00 PREC=0x00 TTL=255 ID=9 DF PROTO=UDP SPT=5353 DPT=5353 LEN=86 
hub 1-0:1.0: state 5 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 1-0:1.0: port 4, status 0100, change 0001, 12 Mb/s
hub 1-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x100
hub 1-0:1.0: state 5 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 1-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE CONNECT
usb 1-4: new high speed USB device using ehci_hcd and address 3
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE CONNECT
usb 1-4: default language 0x0409
usb 1-4: new device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-4: Product: I-O DATA HDP-UP
usb 1-4: Manufacturer: I-O DATA DEVICE,INC.
usb 1-4: SerialNumber: 000000005B93
usb 1-4: hotplug
usb 1-4: adding 1-4:1.0 (config #1, interface 0)
usb 1-4:1.0: hotplug
usb-storage 1-4:1.0: usb_probe_interface
usb-storage 1-4:1.0: usb_probe_interface - got id
scsi0 : SCSI emulation for USB Mass Storage devices
drivers/usb/core/inode.c: creating file '003'
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
  Vendor: FUJITSU   Model: MHT2030AT         Rev: 009B
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sda: 58605120 512-byte hdwr sectors (30006 MB)
sda: assuming drive cache: write through
SCSI device sda: 58605120 512-byte hdwr sectors (30006 MB)
sda: assuming drive cache: write through
 sda: sda1
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
usb-storage: device scan complete

--------------080008060206020709030809
Content-Type: text/plain;
 name="data"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="data"

Read Sector 0, 1st try

0000: 00 00 00 00 40 00 24 C8 00 93 D4 C1 00 00 00 00   ....@.$.........
0001: 50 DA 71 CE A0 7E 11 C0 00 01 10 00 00 02 20 00   P.q..~........ .
0002: 18 6E EE C0 00 EF FF C1 00 00 00 00 50 DA 71 CE   .n..........P.q.
0003: A0 7E 11 C0 00 01 10 00 00 02 20 00 00 6E 1B C2   .~........ ..n..
0004: 00 DE 55 C2 00 00 00 00 90 2A AB CC A0 7E 11 C0   ..U......*...~..
0005: 00 01 10 00 00 02 20 00 00 36 47 C4 80 1D 55 C2   ...... ..6G...U.
0006: 00 00 00 00 90 2A AB CC A0 7E 11 C0 00 01 10 00   .....*...~......
0007: 00 02 20 00 00 5C 5E C3 40 8D 54 C2 00 00 00 00   .. ..\^.@.T.....
0008: 90 2A AB CC A0 7E 11 C0 00 01 10 00 00 02 20 00   .*...~........ .
0009: 98 D3 4D C4 80 E7 0B C8 00 00 00 00 50 1A 2E CC   ..M.........P...
000A: A0 7E 11 C0 00 01 10 00 00 02 20 00 00 B2 FF CD   .~........ .....
000B: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
000C: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
000D: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
000E: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
000F: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0011: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0012: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0013: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0014: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0015: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0016: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0017: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0018: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
0019: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
001A: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
001B: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
001C: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
001D: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
001E: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
001F: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................

------------------------------------------------------------------------------
Read Sector 0, 2nd try

0000: 00 00 00 00 40 60 84 C1 00 93 D4 C1 00 00 00 00   ....@`..........
0001: 50 DA 71 CE A0 7E 11 C0 00 01 10 00 00 02 20 00   P.q..~........ .
0002: 18 6E EE C0 00 EF FF C1 00 00 00 00 50 DA 71 CE   .n..........P.q.
0003: A0 7E 11 C0 00 01 10 00 00 02 20 00 00 6E 1B C2   .~........ ..n..
0004: 00 A3 B9 CB 00 00 00 00 30 30 44 CD A0 7E 11 C0   ........00D..~..
0005: 00 01 10 00 00 02 20 00 00 DA 80 CD 80 AA 4E CE   ...... .......N.
0006: 00 00 00 00 30 30 44 CD A0 7E 11 C0 00 01 10 00   ....00D..~......
0007: 00 02 20 00 00 4E AA CB 80 9A EE CE 00 00 00 00   .. ..N..........
0008: 30 30 44 CD A0 7E 11 C0 00 01 10 00 00 02 20 00   00D..~........ .
0009: D8 43 3E C6 C0 95 14 C8 00 00 00 00 30 30 44 CD   .C>.........00D.
000A: A0 7E 11 C0 00 01 10 00 00 02 20 00 D8 40 3E C6   .~........ ..@>.
000B: 00 85 54 C2 00 00 00 00 80 55 D9 CE A0 7E 11 C0   ..T......U...~..
000C: 00 01 10 00 00 02 20 00 30 49 1C C8 00 59 44 C8   ...... .0I...YD.
000D: 00 00 00 00 80 55 D9 CE A0 7E 11 C0 00 01 10 00   .....U...~......
000E: 00 02 20 00 38 79 FC CA 00 59 44 C8 00 00 00 00   .. .8y...YD.....
000F: 80 55 D9 CE A0 7E 11 C0 00 01 10 00 00 02 20 00   .U...~........ .
0010: 30 79 FC CA C0 16 CC C1 00 00 00 00 80 55 D9 CE   0y...........U..
0011: A0 7E 11 C0 00 01 10 00 00 02 20 00 38 49 E7 C4   .~........ .8I..
0012: C0 16 CC C1 00 00 00 00 80 55 D9 CE A0 7E 11 C0   .........U...~..
0013: 00 01 10 00 00 02 20 00 30 49 E7 C4 C0 F3 3A C2   ...... .0I....:.
0014: 00 00 00 00 80 55 D9 CE A0 7E 11 C0 00 01 10 00   .....U...~......
0015: 00 02 20 00 38 C9 2B C2 C0 F3 3A C2 00 00 00 00   .. .8.+...:.....
0016: 80 55 D9 CE A0 7E 11 C0 00 01 10 00 00 02 20 00   .U...~........ .
0017: 30 C9 2B C2 40 AE 88 C9 00 00 00 00 50 7A 7F CE   0.+.@.......Pz..
0018: A0 7E 11 C0 00 01 10 00 00 02 20 00 98 D9 4D C4   .~........ ...M.
0019: C0 12 2F C2 00 00 00 00 50 7A 7F CE A0 7E 11 C0   ../.....Pz...~..
001A: 00 01 10 00 00 02 20 00 58 35 CD C1 00 EB 10 CD   ...... .X5......
001B: 00 00 00 00 50 7A 7F CE A0 7E 11 C0 00 01 10 00   ....Pz...~......
001C: 00 02 20 00 18 6B 8E C3 40 B8 62 CC 00 00 00 00   .. ..k..@.b.....
001D: 50 7A 7F CE A0 7E 11 C0 00 01 10 00 00 02 20 00   Pz...~........ .
001E: 18 68 8E C3 40 95 37 CC 00 00 00 00 50 7A 7F CE   .h..@.7.....Pz..
001F: A0 7E 11 C0 00 01 10 00 00 02 20 00 58 B8 E0 C3   .~........ .X...

------------------------------------------------------------------------------
Read Sector 0, 3rd try

0000: 00 00 00 00 40 F0 5D C2 00 93 D4 C1 00 00 00 00   ....@.].........
0001: 50 DA 71 CE A0 7E 11 C0 00 01 10 00 00 02 20 00   P.q..~........ .
0002: 18 6E EE C0 00 EF FF C1 00 00 00 00 50 DA 71 CE   .n..........P.q.
0003: A0 7E 11 C0 00 01 10 00 00 02 20 00 00 6E 1B C2   .~........ ..n..
0004: 00 DE 55 C2 00 00 00 00 90 2A AB CC A0 7E 11 C0   ..U......*...~..
0005: 00 01 10 00 00 02 20 00 00 36 47 C4 80 1D 55 C2   ...... ..6G...U.
0006: 00 00 00 00 90 2A AB CC A0 7E 11 C0 00 01 10 00   .....*...~......
0007: 00 02 20 00 00 5C 5E C3 40 8D 54 C2 00 00 00 00   .. ..\^.@.T.....
0008: 90 2A AB CC A0 7E 11 C0 00 01 10 00 00 02 20 00   .*...~........ .
0009: 98 D3 4D C4 C0 95 14 C8 00 00 00 00 30 30 44 CD   ..M.........00D.
000A: A0 7E 11 C0 00 01 10 00 00 02 20 00 D8 40 3E C6   .~........ ..@>.
000B: 40 55 54 CE 00 00 00 00 50 DA 86 CB A0 7E 11 C0   @UT.....P....~..
000C: 00 01 10 00 00 02 20 00 D8 53 B9 CC C0 96 82 CA   ...... ..S......
000D: 00 00 00 00 50 DA 86 CB A0 7E 11 C0 00 01 10 00   ....P....~......
000E: 00 02 20 00 58 B5 70 C7 00 A6 B9 CB 00 00 00 00   .. .X.p.........
000F: 50 DA 86 CB A0 7E 11 C0 00 01 10 00 00 02 20 00   P....~........ .
0010: 98 80 02 C6 80 5A 4E CD 00 00 00 00 50 DA 86 CB   .....ZN.....P...
0011: A0 7E 11 C0 00 01 10 00 00 02 20 00 D8 4C 3E C6   .~........ ..L>.
0012: 80 39 44 C8 00 00 00 00 50 DA 86 CB A0 7E 11 C0   .9D.....P....~..
0013: 00 01 10 00 00 02 20 00 58 48 3E C6 00 7B 39 CC   ...... .XH>..{9.
0014: 00 00 00 00 50 DA 86 CB A0 7E 11 C0 00 01 10 00   ....P....~......
0015: 00 02 20 00 18 55 EC C5 C0 62 E5 CC 00 00 00 00   .. ..U...b......
0016: 50 DA 86 CB A0 7E 11 C0 00 01 10 00 00 02 20 00   P....~........ .
0017: 18 5B EC C5 80 11 FD CC 00 00 00 00 50 DA 86 CB   .[..........P...
0018: A0 7E 11 C0 00 01 10 00 00 02 20 00 D8 46 C1 C4   .~........ ..F..
0019: 00 1F 4F CE 00 00 00 00 50 DA 86 CB A0 7E 11 C0   ..O.....P....~..
001A: 00 01 10 00 00 02 20 00 98 D6 4D C4 C0 C9 91 C9   ...... ...M.....
001B: 00 00 00 00 50 DA 86 CB A0 7E 11 C0 00 01 10 00   ....P....~......
001C: 00 02 20 00 58 E8 9A C4 C0 96 F4 CE 00 00 00 00   .. .X...........
001D: 50 DA 86 CB A0 7E 11 C0 00 01 10 00 00 02 20 00   P....~........ .
001E: 58 E2 9A C4 40 EB EC CC 00 00 00 00 50 DA 86 CB   X...@.......P...
001F: A0 7E 11 C0 00 01 10 00 00 02 20 00 18 65 8E C3   .~........ ..e..

------------------------------------------------------------------------------


--------------080008060206020709030809--
