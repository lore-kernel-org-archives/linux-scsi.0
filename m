From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 8942] dac960 driver stopped working with 2.6.22 kernel
 series
Date: Fri, 31 Aug 2007 08:42:59 -0700
Message-ID: <20070831084259.fc2fd903.akpm@linux-foundation.org>
References: <bug-8942-27@http.bugzilla.kernel.org/>
	<20070831151748.37C39108012@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35653 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757439AbXHaPnP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Aug 2007 11:43:15 -0400
In-Reply-To: <20070831151748.37C39108012@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>, Greg KH <greg@kroah.com>
Cc: alex@nibbles.it, dac@conglom-o.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, linux-scsi@vger.kernel.org

On Fri, 31 Aug 2007 08:17:48 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8942

Seems that DAC960 broke in 2.6.22 - three people are reporting this.

Running `diff -u dmesg-2.6.21 dmesg-2.6.22.3-rc1-slh-smp-2' gives:

--- dmesg-2.6.21	2007-08-31 08:36:32.000000000 -0700
+++ dmesg-2.6.22.3-rc1-slh-smp-2	2007-08-31 08:36:21.000000000 -0700
@@ -1,21 +1,7 @@
-Linux version 2.6.21.7 (root@BadBoy) (gcc version 4.1.2 (Gentoo 4.1.2)) #1 PREEMPT Tue Aug 7 06:54:40 CEST 2007
+Linux version 2.6.22.3-rc1-slh-smp-2 (slh@acer-292lmi) (gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)) #1 SMP PREEMPT Wed Aug 15 01:32:21 CEST 2007
 BIOS-provided physical RAM map:
-sanitize start
-sanitize end
-copy_e820_map() start: 0000000000000000 size: 000000000009ec00 end: 000000000009ec00 type: 1
-copy_e820_map() type is E820_RAM
-copy_e820_map() start: 000000000009ec00 size: 0000000000001400 end: 00000000000a0000 type: 2
-copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
-copy_e820_map() start: 0000000000100000 size: 000000007fde0000 end: 000000007fee0000 type: 1
-copy_e820_map() type is E820_RAM
-copy_e820_map() start: 000000007fee0000 size: 0000000000003000 end: 000000007fee3000 type: 4
-copy_e820_map() start: 000000007fee3000 size: 000000000000d000 end: 000000007fef0000 type: 3
-copy_e820_map() start: 000000007fef0000 size: 0000000000010000 end: 000000007ff00000 type: 2
-copy_e820_map() start: 00000000fec00000 size: 0000000000001000 end: 00000000fec01000 type: 2
-copy_e820_map() start: 00000000fee00000 size: 0000000000001000 end: 00000000fee01000 type: 2
-copy_e820_map() start: 00000000ffff0000 size: 0000000000010000 end: 0000000100000000 type: 2
- BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
- BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
+ BIOS-e820: 0000000000000000 - 000000000009e400 (usable)
+ BIOS-e820: 000000000009e400 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000007fee0000 (usable)
  BIOS-e820: 000000007fee0000 - 000000007fee3000 (ACPI NVS)
@@ -65,28 +51,31 @@
 Using ACPI (MADT) for SMP configuration information
 Allocating PCI resources starting at 80000000 (gap: 7ff00000:7ed00000)
 Built 1 zonelists.  Total pages: 519907
-Kernel command line: root=/dev/rd/c0d0p1 panic=60
+Kernel command line: lang=de boot=fll quiet vga=791 2
 mapped APIC to ffffd000 (fee00000)
 mapped IOAPIC to ffffc000 (fec00000)
 Enabling fast FPU save and restore... done.
 Enabling unmasked SIMD FPU exception support... done.
 Initializing CPU#0
 PID hash table entries: 4096 (order: 12, 16384 bytes)
-Detected 2104.956 MHz processor.
-Console: colour VGA+ 80x25
+Detected 2104.914 MHz processor.
+Console: colour dummy device 80x25
 Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
 Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
-Memory: 2072952k/2096000k available (3291k kernel code, 21964k reserved, 952k data, 192k init, 1178496k highmem)
+Memory: 2068056k/2096000k available (2176k kernel code, 26764k reserved, 784k data, 356k init, 1178496k highmem)
 virtual kernel memory layout:
-    fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
+    fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
-      .init : 0xc0528000 - 0xc0558000   ( 192 kB)
-      .data : 0xc0436cf1 - 0xc0524f7c   ( 952 kB)
-      .text : 0xc0100000 - 0xc0436cf1   (3291 kB)
+      .init : 0xc03eb000 - 0xc0444000   ( 356 kB)
+      .data : 0xc03202e1 - 0xc03e46c4   ( 784 kB)
+      .text : 0xc0100000 - 0xc03202e1   (2176 kB)
 Checking if this processor honours the WP bit even in supervisor mode... Ok.
-Calibrating delay using timer specific routine.. 4211.75 BogoMIPS (lpj=2105879)
+SLUB: Genslabs=22, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
+Calibrating delay using timer specific routine.. 4211.67 BogoMIPS (lpj=2105837)
+Security Framework v1.0.0 initialized
+SELinux:  Disabled at boot.
 Mount-cache hash table entries: 512
 CPU: After generic identify, caps: 0383fbff c1c3fbff 00000000 00000000 00000000 00000000 00000000
 CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
@@ -94,23 +83,31 @@
 CPU: After all inits, caps: 0383fbff c1c3fbff 00000000 00000420 00000000 00000000 00000000
 Intel machine check architecture supported.
 Intel machine check reporting enabled on CPU#0.
-CPU: AMD Athlon(tm) XP 3000+ stepping 00
+Compat vDSO mapped to ffffe000.
 Checking 'hlt' instruction... OK.
+SMP alternatives: switching to UP code
+Freeing SMP alternatives: 11k freed
+Early unpacking initramfs... done
 ACPI: Core revision 20070126
+ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
+CPU0: AMD Athlon(tm) XP 3000+ stepping 00
+Total of 1 processors activated (4211.67 BogoMIPS).
 ENABLING IO-APIC IRQs
 ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
+Brought up 1 CPUs
 NET: Registered protocol family 16
+EISA bus registered
 ACPI: bus type pci registered
 PCI: PCI BIOS revision 2.10 entry at 0xfbab0, last bus=1
 PCI: Using configuration type 1
 Setting up standard PCI resources
 ACPI: Interpreter enabled
+ACPI: (supports S0 S1 S4 S5)
 ACPI: Using IOAPIC for interrupt routing
 ACPI: PCI Root Bridge [PCI0] (0000:00)
 PCI: Probing PCI hardware (bus 00)
 PCI: MSI-K8T-Neo2Fir, attempting to turn soundcard ON
 PCI: MSI-K8T-Neo2Fir, soundcard on
-Boot video device is 0000:01:00.0
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
 ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 11 12) *14
 ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 *10 11 12)
@@ -126,21 +123,23 @@
 ACPI: PCI Interrupt Link [ALKD] (IRQs 23) *0
 Linux Plug and Play Support v0.97 (c) Adam Belay
 pnp: PnP ACPI init
+ACPI: bus type pnp registered
 pnp: PnP ACPI: found 11 devices
+ACPI: ACPI bus type pnp unregistered
+PnPBIOS: Disabled by ACPI PNP
 SCSI subsystem initialized
-libata version 2.20 loaded.
-usbcore: registered new interface driver usbfs
-usbcore: registered new interface driver hub
-usbcore: registered new device driver usb
 PCI: Using ACPI for IRQ routing
 PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
+NET: Registered protocol family 8
+NET: Registered protocol family 20
+ACPI: RTC can wake from S4
 pnp: 00:00: iomem range 0xd9800-0xdbfff has been reserved
 pnp: 00:00: iomem range 0xf0000-0xf7fff could not be reserved
 pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
-Time: tsc clocksource has been installed.
 pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
 pnp: 00:02: ioport range 0x4000-0x407f has been reserved
 pnp: 00:02: ioport range 0x5000-0x500f has been reserved
+Time: tsc clocksource has been installed.
 PCI: Bridge: 0000:00:01.0
   IO window: disabled.
   MEM window: dd000000-dfffffff
@@ -148,91 +147,82 @@
 PCI: Setting latency timer of device 0000:00:01.0 to 64
 NET: Registered protocol family 2
 IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
-TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
-TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
+TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
+TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
 TCP: Hash tables configured (established 131072 bind 65536)
 TCP reno registered
+checking if image is initramfs... it is
+Freeing initrd memory: 5859k freed
 Machine check exception polling timer started.
+audit: initializing netlink socket (disabled)
+audit(1188343387.389:1): initialized
 highmem bounce pool size: 64 pages
-JFS: nTxBlock = 8192, nTxLock = 65536
-SGI XFS with ACLs, no debug enabled
+Total HugeTLB memory allocated, 0
+VFS: Disk quotas dquot_6.5.1
+Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
 io scheduler noop registered
-io scheduler anticipatory registered (default)
+io scheduler anticipatory registered
 io scheduler deadline registered
-io scheduler cfq registered
+io scheduler cfq registered (default)
+PCI: VIA PCI bridge detected. Disabling DAC.
 PCI: Bypassing VIA 8237 APIC De-Assert Message
-input: Power Button (FF) as /class/input/input0
-ACPI: Power Button (FF) [PWRF]
-input: Power Button (CM) as /class/input/input1
-ACPI: Power Button (CM) [PWRB]
-input: Sleep Button (CM) as /class/input/input2
-ACPI: Sleep Button (CM) [SLPB]
-ACPI: Fan [FAN] (on)
-ACPI: CPU0 (power states: C1[C1] C2[C2])
-ACPI: Thermal Zone [THRM] (52 C)
-lp: driver loaded but no devices found
+Boot video device is 0000:01:00.0
+vesafb: framebuffer at 0xc0000000, mapped to 0xf8880000, using 3072k, total 262144k
+vesafb: mode is 1024x768x16, linelength=2048, pages=1
+vesafb: protected mode interface info at c000:c2a0
+vesafb: pmi: set display start = c00cc2d6, set palette = c00cc340
+vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da 
+vesafb: scrolling: redraw
+vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
+Switched to high resolution mode on CPU 0
+Console: switching to colour frame buffer device 128x48
+fb0: VESA VGA frame buffer device
+isapnp: Scanning for PnP cards...
+isapnp: No Plug & Play device found
 Real Time Clock Driver v1.12ac
-Non-volatile memory driver v1.2
-Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
-serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
+Linux agpgart interface v0.102 (c) Dave Jones
+Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
-parport: PnPBIOS parport detected.
-parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE,EPP]
+RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
+PNP: No PS/2 controller found. Probing ports directly.
+serio: i8042 KBD port at 0x60,0x64 irq 1
+serio: i8042 AUX port at 0x60,0x64 irq 12
+mice: PS/2 mouse device common for all mice
+EISA: Probing bus 0 at eisa.0
+Cannot allocate resource for EISA slot 4
+Cannot allocate resource for EISA slot 5
+EISA: Detected 0 cards.
+TCP cubic registered
+NET: Registered protocol family 1
+Using IPI No-Shortcut mode
+Freeing unused kernel memory: 356k freed
+ACPI: Fan [FAN] (on)
+ACPI: CPU0 (power states: C1[C1] C2[C2])
+ACPI: Thermal Zone [THRM] (45 C)
+r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
+ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 17 (level, low) -> IRQ 16
+eth0: RTL8169sb/8110sb at 0xf8842000, 00:1b:11:52:da:6e, IRQ 16
+ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 17
+usbcore: registered new interface driver usbfs
+usbcore: registered new interface driver hub
+usbcore: registered new device driver usb
+USB Universal Host Controller Interface driver v3.0
+Floppy drive(s): fd0 is 1.44M
+FDC 0 is a post-1991 82077
+Marking TSC unstable due to: possible TSC halt in C2.
 Time: acpi_pm clocksource has been installed.
-Switched to high resolution mode on CPU 0
-lp0: using parport0 (interrupt-driven).
-loop: loaded (max 8 devices)
-ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 16
-DAC960: ***** DAC960 RAID Driver Version 2.5.48 of 14 May 2006 *****
-DAC960: Copyright 1998-2001 by Leonard N. Zubkoff <lnz@dandelion.com>
-DAC960#0: Configuring Mylex AcceleRAID 170 PCI RAID Controller
-DAC960#0:   Firmware Version: 7.02-00, Channels: 1, Memory Size: 64MB
-DAC960#0:   PCI Bus: 0, Device: 11, Function: 0, I/O Address: Unassigned
-DAC960#0:   PCI Address: 0xD8000000 mapped at 0xF8CB4000, IRQ Channel: 16
-DAC960#0:   Controller Queue Depth: 512, Maximum Blocks per Command: 2048
-DAC960#0:   Driver Queue Depth: 511, Scatter/Gather Limit: 128 of 257 Segments
-DAC960#0:   Physical Devices:
-DAC960#0:     0:3  Vendor: IBM       Model: DDYS-T36950M      Revision: SC4D
-DAC960#0:          Wide Synchronous at 160 MB/sec
-DAC960#0:          Serial Number:         4FY8F620
-DAC960#0:          Disk Status: Online, 71651328 blocks
-DAC960#0:     0:4  Vendor: IBM       Model: DDYS-T36950M      Revision: SC4D
-DAC960#0:          Wide Synchronous at 160 MB/sec
-DAC960#0:          Serial Number:         4FY8C738
-DAC960#0:          Disk Status: Online, 71651328 blocks
-DAC960#0:     0:5  Vendor: IBM       Model: DDYS-T36950M      Revision: SC4D
-DAC960#0:          Wide Synchronous at 160 MB/sec
-DAC960#0:          Serial Number:         4FY8C891
-DAC960#0:          Disk Status: Online, 71651328 blocks
-DAC960#0:     0:7  Vendor: MYLEX     Model: AcceleRAID 170    Revision: 0702
-DAC960#0:          Wide Synchronous at 160 MB/sec
-DAC960#0:          Serial Number:   
-DAC960#0:   Logical Drives:
-DAC960#0:     /dev/rd/c0d0: RAID-5, Online, 143302656 blocks
-DAC960#0:                   Logical Device Initialized, BIOS Geometry: 255/63
-DAC960#0:                   Stripe Size: 64KB, Segment Size: 8KB
-DAC960#0:                   Read Cache Disabled, Write Cache Disabled
- rd/c0d0: p1 p2 p3
-PPP generic driver version 2.4.2
-PPP Deflate Compression module registered
-PPP BSD Compression module registered
-r8169 Gigabit Ethernet driver 2.2LK loaded
-ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 17 (level, low) -> IRQ 17
-eth0: RTL8169sb/8110sb at 0xf8cb6000, 00:1b:11:52:da:6e, IRQ 17
-Linux video capture interface: v2.00
-ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 18
 scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
         <Adaptec 29160 Ultra160 SCSI adapter>
         aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
 
 scsi 0:0:1:0: Direct-Access     IBM      DDYS-T09170N     S96H PQ: 0 ANSI: 3
-scsi0:A:1:0: Tagged Queuing enabled.  Depth 128
+scsi0:A:1:0: Tagged Queuing enabled.  Depth 8
  target0:0:1: Beginning Domain Validation
  target0:0:1: wide asynchronous
  target0:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
  target0:0:1: Ending Domain Validation
 scsi 0:0:2:0: Direct-Access     IBM      DNES-309170W     SAH0 PQ: 0 ANSI: 3
-scsi0:A:2:0: Tagged Queuing enabled.  Depth 128
+scsi0:A:2:0: Tagged Queuing enabled.  Depth 8
  target0:0:2: Beginning Domain Validation
  target0:0:2: wide asynchronous
  target0:0:2: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 30)
@@ -254,46 +244,49 @@
  target0:0:6: Domain Validation skipping write tests
  target0:0:6: Ending Domain Validation
 scsi 0:0:8:0: Direct-Access     IBM      DDYS-T18350N     S96H PQ: 0 ANSI: 3
-scsi0:A:8:0: Tagged Queuing enabled.  Depth 128
+scsi0:A:8:0: Tagged Queuing enabled.  Depth 8
  target0:0:8: Beginning Domain Validation
  target0:0:8: wide asynchronous
  target0:0:8: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
  target0:0:8: Ending Domain Validation
-SCSI device sda: 17916240 512-byte hdwr sectors (9173 MB)
-sda: Write Protect is off
-sda: Mode Sense: cb 00 00 08
-SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
-SCSI device sda: 17916240 512-byte hdwr sectors (9173 MB)
-sda: Write Protect is off
-sda: Mode Sense: cb 00 00 08
-SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
- sda: sda1 sda2
-sd 0:0:1:0: Attached scsi disk sda
-SCSI device sdb: 17916240 512-byte hdwr sectors (9173 MB)
-sdb: Write Protect is off
-sdb: Mode Sense: c3 00 00 08
-SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
-SCSI device sdb: 17916240 512-byte hdwr sectors (9173 MB)
-sdb: Write Protect is off
-sdb: Mode Sense: c3 00 00 08
-SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
- sdb: sdb1 sdb2
-sd 0:0:2:0: Attached scsi disk sdb
-SCSI device sdc: 35843670 512-byte hdwr sectors (18352 MB)
-sdc: Write Protect is off
-sdc: Mode Sense: cb 00 00 08
-SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
-SCSI device sdc: 35843670 512-byte hdwr sectors (18352 MB)
-sdc: Write Protect is off
-sdc: Mode Sense: cb 00 00 08
-SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
- sdc: sdc1
-sd 0:0:8:0: Attached scsi disk sdc
-sr0: scsi-1 drive
+ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 18
+DAC960: ***** DAC960 RAID Driver Version 2.5.48 of 14 May 2006 *****
+DAC960: Copyright 1998-2001 by Leonard N. Zubkoff <lnz@dandelion.com>
+DAC960#0: While configuring DAC960 PCI RAID Controller at
+DAC960#0: PCI Bus 0 Device 11 Function 0 I/O Address N/A PCI Address 0xD8000000
+DAC960#0: DMA mask out of range FAILED - DETACHING
+DAC960#0: Unable to Enable Memory Mailbox Interface for Controller at
+DAC960#0: PCI Bus 0 Device 11 Function 0 I/O Address N/A PCI Address 0xD8000000
+ACPI: PCI interrupt for device 0000:00:0b.0 disabled
+ACPI: PCI Interrupt 0000:00:0c.2[B] -> GSI 19 (level, low) -> IRQ 18
+ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18]  MMIO=[e0005000-e00057ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
+ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 18 (level, low) -> IRQ 17
+ohci1394: fw-host1: OHCI-1394 1.0 (PCI): IRQ=[17]  MMIO=[e0008000-e00087ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
+ACPI: PCI Interrupt Link [ALKB] BIOS reported IRQ 0, using IRQ 21
+ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
+ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 19
+uhci_hcd 0000:00:10.0: UHCI Host Controller
+uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
+uhci_hcd 0000:00:10.0: irq 19, io base 0x0000d000
+usb usb1: configuration #1 chosen from 1 choice
+hub 1-0:1.0: USB hub found
+hub 1-0:1.0: 2 ports detected
+sd 0:0:1:0: [sda] 17916240 512-byte hardware sectors (9173 MB)
+sd 0:0:1:0: [sda] Write Protect is off
+sd 0:0:1:0: [sda] Mode Sense: cb 00 00 08
+sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
+sd 0:0:1:0: [sda] 17916240 512-byte hardware sectors (9173 MB)
+sd 0:0:1:0: [sda] Write Protect is off
+sd 0:0:1:0: [sda] Mode Sense: cb 00 00 08
+sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
+ sda:sr0: scsi-1 drive
 Uniform CD-ROM driver Revision: 3.20
 sr 0:0:3:0: Attached scsi CD-ROM sr0
+ sda1 sda2
+sd 0:0:1:0: [sda] Attached SCSI disk
 sr1: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
 sr 0:0:4:0: Attached scsi CD-ROM sr1
+sd 0:0:2:0: [sdb] 17916240 512-byte hardware sectors (9173 MB)
 sr2: scsi3-mmc drive: 16x/40x cd/rw xa/form2 cdda tray
 sr 0:0:6:0: Attached scsi CD-ROM sr2
 sd 0:0:1:0: Attached scsi generic sg0 type 0
@@ -301,134 +294,123 @@
 sr 0:0:3:0: Attached scsi generic sg2 type 5
 sr 0:0:4:0: Attached scsi generic sg3 type 5
 sr 0:0:6:0: Attached scsi generic sg4 type 5
-sd 0:0:8:0: Attached scsi generic sg5 type 0
-ACPI: PCI Interrupt Link [ALKB] BIOS reported IRQ 0, using IRQ 21
-ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
-ACPI: PCI Interrupt 0000:00:10.4[C] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 19
-ehci_hcd 0000:00:10.4: EHCI Host Controller
-ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
-ehci_hcd 0000:00:10.4: irq 19, io mem 0xe0007000
-ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
-usb usb1: configuration #1 chosen from 1 choice
-hub 1-0:1.0: USB hub found
-hub 1-0:1.0: 8 ports detected
-USB Universal Host Controller Interface driver v3.0
-ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 19
-uhci_hcd 0000:00:10.0: UHCI Host Controller
-uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
-uhci_hcd 0000:00:10.0: irq 19, io base 0x0000d000
-usb usb2: configuration #1 chosen from 1 choice
-hub 2-0:1.0: USB hub found
-hub 2-0:1.0: 2 ports detected
+scsi 0:0:8:0: Attached scsi generic sg5 type 0
+sd 0:0:2:0: [sdb] Write Protect is off
+sd 0:0:2:0: [sdb] Mode Sense: c3 00 00 08
 ACPI: PCI Interrupt 0000:00:10.1[A] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 19
 uhci_hcd 0000:00:10.1: UHCI Host Controller
-uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
+uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
 uhci_hcd 0000:00:10.1: irq 19, io base 0x0000d400
-usb usb3: configuration #1 chosen from 1 choice
-hub 3-0:1.0: USB hub found
-hub 3-0:1.0: 2 ports detected
+usb usb2: configuration #1 chosen from 1 choice
+hub 2-0:1.0: USB hub found
+hub 2-0:1.0: 2 ports detected
+sd 0:0:2:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
+sd 0:0:2:0: [sdb] 17916240 512-byte hardware sectors (9173 MB)
+sd 0:0:2:0: [sdb] Write Protect is off
+sd 0:0:2:0: [sdb] Mode Sense: c3 00 00 08
 ACPI: PCI Interrupt 0000:00:10.2[B] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 19
 uhci_hcd 0000:00:10.2: UHCI Host Controller
-uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
+uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
 uhci_hcd 0000:00:10.2: irq 19, io base 0x0000d800
-usb usb4: configuration #1 chosen from 1 choice
-hub 4-0:1.0: USB hub found
-hub 4-0:1.0: 2 ports detected
+usb usb3: configuration #1 chosen from 1 choice
+hub 3-0:1.0: USB hub found
+hub 3-0:1.0: 2 ports detected
+sd 0:0:2:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
+ sdb: sdb1 sdb2
+sd 0:0:2:0: [sdb] Attached SCSI disk
+sd 0:0:8:0: [sdc] 35843670 512-byte hardware sectors (18352 MB)
+sd 0:0:8:0: [sdc] Write Protect is off
+sd 0:0:8:0: [sdc] Mode Sense: cb 00 00 08
+sd 0:0:8:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
+sd 0:0:8:0: [sdc] 35843670 512-byte hardware sectors (18352 MB)
+sd 0:0:8:0: [sdc] Write Protect is off
+sd 0:0:8:0: [sdc] Mode Sense: cb 00 00 08
+sd 0:0:8:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
+ sdc: sdc1
+sd 0:0:8:0: [sdc] Attached SCSI disk
 ACPI: PCI Interrupt 0000:00:10.3[B] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 19
 uhci_hcd 0000:00:10.3: UHCI Host Controller
-uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
+uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
 uhci_hcd 0000:00:10.3: irq 19, io base 0x0000dc00
+usb usb4: configuration #1 chosen from 1 choice
+hub 4-0:1.0: USB hub found
+hub 4-0:1.0: 2 ports detected
+usb 1-1: new full speed USB device using uhci_hcd and address 2
+ACPI: PCI Interrupt 0000:00:10.4[C] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 19
+ehci_hcd 0000:00:10.4: EHCI Host Controller
+ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 5
+ehci_hcd 0000:00:10.4: irq 19, io mem 0xe0007000
+ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
 usb usb5: configuration #1 chosen from 1 choice
 hub 5-0:1.0: USB hub found
-hub 5-0:1.0: 2 ports detected
-usb 3-2: new full speed USB device using uhci_hcd and address 2
-usb 3-2: configuration #1 chosen from 1 choice
-hub 3-2:1.0: USB hub found
-hub 3-2:1.0: 4 ports detected
-usb 3-2.1: new low speed USB device using uhci_hcd and address 3
-DAC960#0: Physical Device 0:3 Found
-DAC960#0: Physical Device 0:4 Found
-DAC960#0: Physical Device 0:5 Found
-DAC960#0: Physical Device 0:5 Online
-DAC960#0: Physical Device 0:4 Online
-DAC960#0: Physical Device 0:3 Online
-DAC960#0: Logical Drive 0 (/dev/rd/c0d0) Found
-DAC960#0: Logical Drive 0 (/dev/rd/c0d0) Online
-usb 3-2.1: configuration #1 chosen from 1 choice
-usb 3-2.4: new full speed USB device using uhci_hcd and address 4
-usb 3-2.4: configuration #1 chosen from 1 choice
-usbcore: registered new interface driver usblp
-drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
-Initializing USB Mass Storage driver...
-usbcore: registered new interface driver usb-storage
-USB Mass Storage support registered.
-usb 2-1: new full speed USB device using uhci_hcd and address 2
-usb 2-1: configuration #1 chosen from 1 choice
-input: Logitech Logitech Gaming Keyboard as /class/input/input3
+hub 5-0:1.0: 8 ports detected
+usb 1-1: device not accepting address 2, error -71
+ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023c0091012a77]
+ieee1394: Host added: ID:BUS[1-00:1023]  GUID[000461000005da74]
+ISO 9660 Extensions: Microsoft Joliet Level 3
+ISO 9660 Extensions: RRIP_1991A
+loop: module loaded
+squashfs: version 3.2-r2 (2007/01/15) Phillip Lougher
+usb 1-1: new full speed USB device using uhci_hcd and address 4
+usb 1-1: configuration #1 chosen from 1 choice
+usb 2-2: new full speed USB device using uhci_hcd and address 2
+usb 2-2: configuration #1 chosen from 1 choice
+hub 2-2:1.0: USB hub found
+hub 2-2:1.0: 4 ports detected
+usb 2-2.1: new low speed USB device using uhci_hcd and address 3
+usb 2-2.1: configuration #1 chosen from 1 choice
+aufs 20070813
+usb 2-2.4: new full speed USB device using uhci_hcd and address 4
+usb 2-2.4: configuration #1 chosen from 1 choice
+usbcore: registered new interface driver hiddev
+input: Razer Razer Copperhead Laser Mouse as /class/input/input0
+input: USB HID v10.01 Mouse [Razer Razer Copperhead Laser Mouse] on usb-0000:00:10.0-1
+input: Razer Razer Copperhead Laser Mouse as /class/input/input1
+input: USB HID v10.01 Keyboard [Razer Razer Copperhead Laser Mouse] on usb-0000:00:10.0-1
+input: Logitech Logitech Gaming Keyboard as /class/input/input2
 input: USB HID v1.10 Keyboard [Logitech Logitech Gaming Keyboard] on usb-0000:00:10.1-2.1
-input: Logitech Logitech Gaming Keyboard as /class/input/input4
-input: USB HID v1.10 Device [Logitech Logitech Gaming Keyboard] on usb-0000:00:10.1-2.1
-input: G15 Keyboard G15 Keyboard as /class/input/input5
-input: USB HID v1.11 Keypad [G15 Keyboard G15 Keyboard] on usb-0000:00:10.1-2.4
-input: Razer Razer Copperhead Laser Mouse as /class/input/input6
-input: USB HID v1.00 Mouse [Razer Razer Copperhead Laser Mouse] on usb-0000:00:10.0-1
-input: Razer Razer Copperhead Laser Mouse as /class/input/input7
-input: USB HID v0.01 Keyboard [Razer Razer Copperhead Laser Mouse] on usb-0000:00:10.0-1
+input: Logitech Logitech Gaming Keyboard as /class/input/input3
+input,hiddev96: USB HID v1.10 Device [Logitech Logitech Gaming Keyboard] on usb-0000:00:10.1-2.1
+input: G15 Keyboard G15 Keyboard as /class/input/input4
+input,hiddev97: USB HID v1.11 Keypad [G15 Keyboard G15 Keyboard] on usb-0000:00:10.1-2.4
 usbcore: registered new interface driver usbhid
-drivers/usb/input/hid-core.c: v2.6:USB HID core driver
-PNP: No PS/2 controller found. Probing ports directly.
-serio: i8042 KBD port at 0x60,0x64 irq 1
-serio: i8042 AUX port at 0x60,0x64 irq 12
+drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
+Capability LSM initialized
+pci_hotplug: PCI Hot Plug PCI Core version: 0.5
+shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
+input: PC Speaker as /class/input/input5
+agpgart: Detected VIA KT400/KT400A/KT600 chipset
+agpgart: AGP aperture is 128M @ 0xd0000000
+parport_pc 00:0a: reported by Plug and Play ACPI
+parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
 gameport: EMU10K1 is pci0000:00:0c.1/gameport0, io 0xcc00, speed 1242kHz
-mice: PS/2 mouse device common for all mice
-input: PC Speaker as /class/input/input8
-nf_conntrack version 0.5.0 (8192 buckets, 65536 max)
-ip_tables: (C) 2000-2006 Netfilter Core Team
-arp_tables: (C) 2002 David S. Miller
-TCP cubic registered
-NET: Registered protocol family 1
-NET: Registered protocol family 17
-Using IPI Shortcut mode
-kjournald starting.  Commit interval 5 seconds
-EXT3-fs: mounted filesystem with ordered data mode.
-VFS: Mounted root (ext3 filesystem) readonly.
-Freeing unused kernel memory: 192k freed
-Write protecting the kernel read-only data: 742k
-EXT3 FS on rd/c0d0p1, internal journal
-Filesystem "rd/c0d0p3": Disabling barriers, not supported by the underlying device
-XFS mounting filesystem rd/c0d0p3
-Ending clean XFS mount for filesystem: rd/c0d0p3
-XFS mounting filesystem sdb2
-Ending clean XFS mount for filesystem: sdb2
-XFS mounting filesystem sda2
-Ending clean XFS mount for filesystem: sda2
-Adding 506008k swap on /dev/sdb1.  Priority:-1 extents:1 across:506008k
-ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 18 (level, low) -> IRQ 18
-ALSA /home/.portage/tmp/portage/media-sound/alsa-driver-1.0.14/work/alsa-driver-1.0.14/pci/emu10k1/../../alsa-kernel/pci/emu10k1/emufx.c:1528: Installing spdif_bug patch: Audigy 2 Platinum [SB0240P]
+ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 18 (level, low) -> IRQ 17
+Installing spdif_bug patch: Audigy 2 Platinum [SB0240P]
 ACPI: PCI Interrupt Link [ALKC] BIOS reported IRQ 0, using IRQ 22
 ACPI: PCI Interrupt Link [ALKC] enabled at IRQ 22
 ACPI: PCI Interrupt 0000:00:11.5[C] -> Link [ALKC] -> GSI 22 (level, low) -> IRQ 20
 PCI: Setting latency timer of device 0000:00:11.5 to 64
-input: G15 Extra Keys as /class/input/input9
+sr2: CDROM not ready.  Make sure there is a disc in the drive.
 r8169: eth0: link up
-sg_write: data in/out 18/6 bytes for SCSI command 0xbb--guessing data in;
-   program plextor-tool not setting count and/or reply_len properly
-Linux agpgart interface v0.102 (c) Dave Jones
-agpgart: Detected VIA KT400/KT400A/KT600 chipset
-agpgart: AGP aperture is 128M @ 0xd0000000
-nvidia: module license 'NVIDIA' taints kernel.
-ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 21
-NVRM: loading NVIDIA UNIX x86 Kernel Module  100.14.11  Wed Jun 13 18:21:22 PDT 2007
-agpgart: Found an AGP 3.5 compliant device at 0000:00:00.0.
-agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
-agpgart: Putting AGP V3 device at 0000:01:00.0 into 8x mode
-usb 2-1: USB disconnect, address 2
-usb 2-2: new full speed USB device using uhci_hcd and address 3
-usb 2-2: configuration #1 chosen from 1 choice
-usb 2-2: USB disconnect, address 3
-usb 2-1: new full speed USB device using uhci_hcd and address 4
-usb 2-1: configuration #1 chosen from 1 choice
-input: Razer Razer Copperhead Laser Mouse as /class/input/input10
-input: USB HID v10.01 Mouse [Razer Razer Copperhead Laser Mouse] on usb-0000:00:10.0-1
-input: Razer Razer Copperhead Laser Mouse as /class/input/input11
-input: USB HID v10.01 Keyboard [Razer Razer Copperhead Laser Mouse] on usb-0000:00:10.0-1
+fuse init (API version 7.8)
+Adding 506008k swap on /dev/sdb1.  Priority:-1 extents:1 across:506008k
+NET: Registered protocol family 17
+NET: Registered protocol family 10
+lo: Disabled Privacy Extensions
+pnp: Device 00:0a disabled.
+parport 0x378 (WARNING): CTR: wrote 0x0c, read 0xff
+parport 0x378 (WARNING): DATA: wrote 0xaa, read 0xff
+parport 0x378: You gave this address, but there is probably no parallel port there!
+parport0: PC-style at 0x378 [PCSPP,TRISTATE]
+pnp: Device 00:0a activated.
+parport_pc 00:0a: reported by Plug and Play ACPI
+parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
+lp0: using parport0 (interrupt-driven).
+lp0: console ready
+eth0: no IPv6 routers present
+input: Power Button (FF) as /class/input/input6
+ACPI: Power Button (FF) [PWRF]
+input: Power Button (CM) as /class/input/input7
+ACPI: Power Button (CM) [PWRB]
+input: Sleep Button (CM) as /class/input/input8
+ACPI: Sleep Button (CM) [SLPB]


>From which this bit tells the story:

+DAC960#0: While configuring DAC960 PCI RAID Controller at
+DAC960#0: PCI Bus 0 Device 11 Function 0 I/O Address N/A PCI Address 0xD8000000
+DAC960#0: DMA mask out of range FAILED - DETACHING
+DAC960#0: Unable to Enable Memory Mailbox Interface for Controller at
+DAC960#0: PCI Bus 0 Device 11 Function 0 I/O Address N/A PCI Address 0xD8000000

