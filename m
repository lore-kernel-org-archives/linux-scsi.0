From: Joel Soete <joel.soete@tiscali.be>
Subject: Re: [parisc-linux] [PATCH] zalon & ncr53c8xx cleanups
Date: Wed, 17 Sep 2003 10:35:25 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F6838ED.6070103@tiscali.be>
References: <20030911181135.GN21596@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from spoolo1.tiscali.be ([62.235.13.210]:46343 "EHLO
	smtp-out.tiscali.be") by vger.kernel.org with ESMTP id S261406AbTIQKfR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Sep 2003 06:35:17 -0400
In-Reply-To: <20030911181135.GN21596@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: parisc-linux@parisc-linux.org, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:

>I don't actually have a zalon machine to test these on, but they seem
>right to me, and compile fine.
>
>Some cleanups for ncr53c8xx & zalon:
>
> - Inline zalon.h into zalon.c
> - Rationalise (a little) ncr53c8xx.c's includes
> - Remove all the version checks
> - Stop using remap_pci_mem & unmap_pci_mem & delete their definitions.
> - Use mb() instead of custom inline asm for MEMORY_BARRIER.
>  
>
Hi Willy,

It works fine on my c110 (just remove serial mux from defconfig); here 
is dmesg:
Linux version 2.6.0-test5-pa6 (root@hpalin) (gcc version 3.3.2 20030908 
(Debian
prerelease)) #1 Wed Sep 17 10:21:19 CEST 2003
FP[0] enabled: Rev 1 Model 11
The 32-bit Kernel has started...
Determining PDC firmware type: System Map.
model 000058e0 00000481 00000000 00000002 77e47570 100000f1 00000004 
0000008a 00
00008a
vers  0000000d
CPUID vers 11 rev 13 (0x0000016d)
model 9000/777/C110
Total Memory: 128 Mb
pagetable_init
On node 0 totalpages: 32768
  DMA zone: 32768 pages, LIFO batch:8
  Normal zone: 0 pages, LIFO batch:1
  HighMem zone: 0 pages, LIFO batch:1
Building zonelist for node : 0
Kernel command line: root=/dev/sda5 HOME=/ console=ttyS0 TERM=vt102 
palo_kernel=
3/vmlinux-2.6.0-test5-pa6
PID hash table entries: 16 (order 4: 128 bytes)
Console: colour dummy device 160x64
Memory: 126072k available
Calibrating delay loop... 119.60 BogoMIPS
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
-> /dev
-> /dev/console
-> /root
POSIX conformance testing by UNIFIX
NET: Registered protocol family 16
EISA bus registered
Searching for devices...
Found devices:
1. U2-IOA BC Runway Port (12) at 0xfff88000 [8], versions 0x580, 0x7, 0xb
2. SkyHawk 100/120 FW-SCSI (4) at 0xf3f8c000 [8/12], versions 0x1f, 0x0, 
0x89
3. Raven T' Core BA (11) at 0xffd00000 [8/16], versions 0x32, 0x0, 
0x81,  additi
onal addresses: 0xffd0c000 0xffc00000
4. Raven T' Core Centronics (10) at 0xffd02000 [8/16/0], versions 0x32, 
0x0, 0x7
4,  additional addresses: 0xffd01000 0xffd03000
5. Raven T' Audio (10) at 0xffd04000 [8/16/1], versions 0x32, 0x0, 0x7b
6. Raven T' Lasi Core RS-232 (10) at 0xffd05000 [8/16/4], versions 0x32, 
0x0, 0x
8c
7. Raven T' Core SCSI (10) at 0xffd06000 [8/16/5], versions 0x32, 0x0, 0x82
8. Raven T' Core LAN (802.3) (10) at 0xffd07000 [8/16/6], versions 0x32, 
0x0, 0x
8a
9. Raven T' Core PS/2 Port (10) at 0xffd08000 [8/16/7], versions 0x32, 
0x0, 0x84
10. Raven T' Core PS/2 Port (10) at 0xffd08100 [8/16/8], versions 0x32, 
0x0, 0x8
4
11. Raven T' Core PC Floppy (10) at 0xffd0a000 [8/16/10], versions 0x32, 
0x0, 0x
83
12. Raven T' Wax BA (11) at 0xffe00000 [8/20], versions 0x1e, 0x0, 
0x8e,  additi
onal addresses: 0xffe03000 0xffe06000
13. Raven T' Wax HIL (10) at 0xffe01000 [8/20/1], versions 0x1e, 0x0, 0x73
14. Raven T' Wax RS-232 (10) at 0xffe02000 [8/20/2], versions 0x1e, 0x0, 
0x8c
15. Raven T' Wax EISA BA (11) at 0xfc000000 [8/20/5], versions 0x1e, 
0x0, 0x90,
 additional addresses: 0xffc88400 0xf4000000
16. U2-IOA BC GSC+ Port (7) at 0xf3fbf000 [8/63], versions 0x501, 0x1, 
0xc,  add
itional addresses: 0xf3f80000
17. U2-IOA BC Runway Port (12) at 0xfff8a000 [10], versions 0x580, 0x7, 0xb
18. Raven T' GSC Core Graphics (10) at 0xf4000000 [10/16], versions 
0x32, 0x0, 0
x85,  additional addresses: 0xf0069000
19. U2-IOA BC GSC+ Port (7) at 0xf3fff000 [10/63], versions 0x501, 0x1, 0xc
20. Raven 120 T' (0) at 0xfffa0000 [32], versions 0x58e, 0x0, 0x4
21. Memory (1) at 0xfffb1000 [49], versions 0x49, 0x0, 0x9
CPU(s): 1 x PA7200 (PCX-T') at 120.000000 MHz
Found U2 at 0xfff88000
Found U2 at 0xfff8a000
Lasi version 0 at 0xffd00000 found.
Wax at 0xffe00000 found.
Wax EISA Adapter found at 0xfc000000
EISA EEPROM at 0xffc88400
Enumerating EISA bus
EISA: Probing bus 0 at parisc8:20:5
EISA: Mainboard HWPC0E1 detected.
EISA: Detected 0 cards.
SCSI subsystem initialized
drivers/usb/core/usb.c: registered new driver hub
pty: 256 Unix98 ptys configured
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Serial: 8250/16550 driver $Revision: 1.90 $ IRQ sharing enabled
Soft power switch enabled, polling @ 0xf0140000.
lp: driver loaded but no devices found
Generic RTC Driver v1.07
ttyS0 at MMIO 0xffd05800 (irq = 90) is a 16550A
ttyS1 at MMIO 0xffe02800 (irq = 121) is a 16550A
parport_init_chip: initialize bidirectional-mode.
parport0: PC-style at 0xffd02800, irq 88 [PCSPP,TRISTATE]
lp0: using parport0 (interrupt-driven).
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
Found i82596 at 0xffd07000, IRQ 87
eth0: 82596 at 0xffd07000, 00 60 B0 07 1E EA IRQ 87.
82596.c $Revision: 1.29 $
airo:  Probing for PCI adapters
airo:  Finished probing for PCI adapters
zalon_scsi_callback: Zalon vers field is 0x1, IRQ 34
ncr53c720-0: rev 0xf on pci bus 0 device 0 function 0 irq 34
ncr53c720-0: ID 7, Fast-10, Parity Checking, Differential
scsi0 : ncr53c8xx-3.4.3b-20010512
Using anticipatory scheduling io scheduler
  Vendor: SEAGATE   Model: ST34371W          Rev: HP03
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: SEAGATE   Model: ST34371W          Rev: HP03
  Type:   Direct-Access                      ANSI SCSI revision: 02
53c700: Version 2.8 By James.Bottomley@HansenPartnership.com
scsi1: 53c710 rev 2
scsi1 : LASI SCSI 53c700
st: Version 20030811, fixed bufsize 32768, s/g segs 256
ncr53c720-0-<5,*>: FAST-10 WIDE SCSI 20.0 MB/s (100 ns, offset 8)
SCSI device sda: 8388314 512-byte hdwr sectors (4295 MB)
SCSI device sda: drive cache: write back
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
Attached scsi disk sda at scsi0, channel 0, id 5, lun 0
ncr53c720-0-<6,*>: FAST-10 WIDE SCSI 20.0 MB/s (100 ns, offset 8)
SCSI device sdb: 8388314 512-byte hdwr sectors (4295 MB)
SCSI device sdb: drive cache: write back
 sdb: unknown partition table
Attached scsi disk sdb at scsi0, channel 0, id 6, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 5, lun 0,  type 0
Attached scsi generic sg1 at scsi0, channel 0, id 6, lun 0,  type 0
STI GSC/PCI core graphics driver Version 0.9a
STI word mode ROM at f0069000, hpa at f4000000
STI id 2b4ded6d-40a00499, conforms to spec rev. 8.04
STI device: HPA208LC1024
sticon: Initializing STI text console.
Console: switching to colour STI console 128x48
ehci_hcd: block sizes: qh 128 qtd 96 itd 128 sitd 64
ohci-hcd: 2003 Feb 24 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
ohci-hcd: block sizes: ed 64 td 64
mice: PS/2 mouse device common for all mice
Found HIL bus at 0xffe01000, IRQ 126
HIL: no keyboard present.
input: HIL keyboard, ID -1 at 0xffe01000 (irq 126) found and attached
Keyboard initialization sequence failled
gsckbd_leds: timeout
input: PS/2 keyboard port at 0xffd08000 (irq 69) found and attached
input: PS/2 mouse port at 0xffd08100 (irq 69) found and attached
HP SDC: No SDC found.
md: linear personality registered as nr 1
md: raid0 personality registered as nr 2
md: raid1 personality registered as nr 3
md: raid5 personality registered as nr 4
raid5: measuring checksumming speed
   8regs     :    85.200 MB/sec
   8regs_prefetch:    83.200 MB/sec
   32regs    :    98.800 MB/sec
   32regs_prefetch:    96.400 MB/sec
raid5: using function: 32regs (98.800 MB/sec)
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
oprofile: using timer interrupt.
NET: Registered protocol family 2
IP: routing cache hash table of 512 buckets, 4Kbytes
TCP: Hash tables configured (established 8192 bind 16384)
NET: Registered protocol family 1
NET: Registered protocol family 17
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 500k freed
Adding 131928k swap on /dev/sda2.  Priority:-1 extents:1
EXT3 FS on sda5, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
eth0: link ok.

hth,
    joel


