From: Russell Kroll <rkroll@exploits.org>
Subject: Re: PROBLEM: sym53c8xx is broken on HP LH 4 after Linux 2.2
Date: Sun, 09 Nov 2003 14:46:19 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FAEA79B.mail23J11O804@exploits.org>
References: <3FAC4BB1.mail1NJ11B4U4@exploits.org>
 <20031109163756.GB2014@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: application/octet-stream; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gearbox.exploits.org ([65.64.162.194]:18821 "EHLO
	gearbox.exploits.org") by vger.kernel.org with ESMTP
	id S262791AbTKIUqZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Nov 2003 15:46:25 -0500
In-Reply-To: <20031109163756.GB2014@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: willy@debian.org
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:

> > lspci, perhaps due to the bug that was fixed by the pre4-1 patch.  This is 
> > generally not a problem, since the NetRAID/MegaRAID typically covers that 
> > interface.
>
> Hmm.. is this what's meant by the comment:
>
>         /*
>          *  Ignore Symbios chips controlled by various RAID controllers.
>          *  These controllers set value 0x52414944 at RAM end - 16.
>          */

I don't know for sure, but my guess is that code would only matter if both 
the "bottom" controller and the RAID controller were visible at the same 
time.  Given the other response about 450NX bus weirdness, I wonder if 
this is actually a single device that's showing up twice.

Another data point: I checked in the Symbios BIOS (^C at boot) and it only 
lists one controller:

                  Port    Irq   ---------Status-------- NvRAM
                  Num    Level  Current      Next-Boot  Found
       SYM53C895  A000     11     On           On        Yes             
       Change Adapter Status

	< snip >

As you saw, lspci has both 0x1400 and 0xa000.  When it works (2.2 or 
mangled 2.4), it's only at 0xa000.

> First, I have a strong suspicion that updating your firmware will
> fix this problem.  But once we do that, we lose this opportunity for

The latest BIOS out there is 4.06.36PS, and the first line in the boot 
process is "PhoenixBIOS 4.06.36 PS", so that may not be an option here.

> Second, I want to see what the PCI code is up to.  So, can you change
> the #undef DEBUG to #define DEBUG in linux-2.6.0-test9/drivers/pci/probe.c
> then boot that kernel and send me the dmesg output.

OK, here it is:

---

Linux version 2.6.0-test9 (rkroll@webserv) (gcc version 3.2.2) #1 Sun Nov 9 13:10:48 MST 2003
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8800 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003ffffc00 (ACPI data)
 BIOS-e820: 000000003ffffc00 - 0000000040000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fffe8800 - 0000000100000000 (reserved)
Warning only 896MB will be used.
Use a HIGHMEM enabled kernel.
896MB LOWMEM available.
On node 0 totalpages: 229376
  DMA zone: 4096 pages, LIFO batch:1
  Normal zone: 225280 pages, LIFO batch:16
  HighMem zone: 0 pages, LIFO batch:1
DMI 2.1 present.
Building zonelist for node : 0
Kernel command line: auto BOOT_IMAGE=test ro root=801 panic=15
Initializing CPU#0
PID hash table entries: 4096 (order 12: 32768 bytes)
Detected 500.105 MHz processor.
Console: colour VGA+ 80x25
Memory: 905912k/917504k available (946k kernel code, 10808k reserved, 356k data, 252k init, 0k highmem)
Calibrating delay loop... 987.13 BogoMIPS
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
CPU:     After generic identify, caps: 0387fbff 00000000 00000000 00000000
CPU:     After vendor identify, caps: 0387fbff 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU serial number disabled.
CPU:     After all inits, caps: 0383fbff 00000000 00000000 00000040
CPU: Intel Pentium III (Katmai) stepping 02
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
POSIX conformance testing by UNIFIX
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfdab2, last bus=2
PCI: Using configuration type 1
SCSI subsystem initialized
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
Scanning bus 00
Found 00:10 [8086/0960] 000604 01
Found 00:11 [8086/1960] 000e00 00
Found 00:18 [1011/0024] 000604 01
Found 00:30 [103c/10c1] 000880 00
Found 00:40 [1013/00b8] 000300 00
Found 00:78 [8086/7110] 000601 00
Found 00:79 [8086/7111] 000101 00
Found 00:7a [8086/7112] 000c03 00
Found 00:7b [8086/7113] 000680 00
Found 00:80 [8086/84ca] 000600 00
PCI: Searching for i450NX host bridges on 0000:00:10.0
Scanning bus 01
Found 01:38 [1000/000c] 000100 00
Fixups for bus 01
Bus scan for 01 returning with max=01
Found 00:90 [8086/84cb] 000600 00
Fixups for bus 00
Scanning behind PCI bridge 0000:00:02.0, config 010100, pass 0
Scanning bus 01
Found 01:38 [1000/000c] 000100 00
Fixups for bus 01
Bus scan for 01 returning with max=01
Scanning behind PCI bridge 0000:00:03.0, config 020200, pass 0
Scanning bus 02
Found 02:10 [8086/1229] 000200 00
Fixups for bus 02
Bus scan for 02 returning with max=02
Scanning behind PCI bridge 0000:00:02.0, config 010100, pass 1
Scanning behind PCI bridge 0000:00:03.0, config 020200, pass 1
Bus scan for 00 returning with max=02
PCI: Using IRQ router PIIX [8086/7110] at 0000:00:0f.0
PCI: IRQ 0 for device 0000:00:0f.2 doesn't match PIRQ mask - try pci=usepirqmask
PCI: Cannot allocate resource region 0 of device 0000:01:07.0
PCI: Cannot allocate resource region 1 of device 0000:01:07.0
PCI: Cannot allocate resource region 2 of device 0000:01:07.0
SBF: ACPI BOOT descriptor is wrong length (39)
SBF: Simple Boot Flag extension found and enabled.
SBF: Setting boot flags 0x1
pty: 256 Unix98 ptys configured
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing disabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
Using anticipatory io scheduler
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
megaraid: v2.00.3 (Release Date: Wed Feb 19 08:51:30 EST 2003)
PCI: Assigned IRQ 10 for device 0000:00:02.1
megaraid: found 0x8086:0x1960:bus 0:slot 2:func 1
scsi0:Found MegaRAID controller at 0xf8800000, IRQ:10
megaraid: [D :B ] detected 1 logical drives.
megaraid: channel[0] is raid.
scsi0 : LSI Logic MegaRAID D  254 commands 16 targs 4 chans 7 luns
scsi0: scanning scsi channel 0 for logical drives.
  Vendor: MegaRAID  Model: LD0 RAID5 51834R  Rev:   D 
  Type:   Direct-Access                      ANSI SCSI revision: 02
scsi0: scanning scsi channel 4 [P0] for physical devices.
st: Version 20030811, fixed bufsize 32768, s/g segs 256
SCSI device sda: 106156032 512-byte hdwr sectors (54352 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
 sda: sda1 sda2
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
mice: PS/2 mouse device common for all mice
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
NET: Registered protocol family 1
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 252k freed
Adding 1662716k swap on /dev/sda2.  Priority:-1 extents:1
EXT3 FS on sda1, internal journal
