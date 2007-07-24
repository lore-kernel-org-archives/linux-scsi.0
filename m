From: Vasily Averin <vvs@sw.ru>
Subject: Re: unexpected scsi timeout
Date: Tue, 24 Jul 2007 17:07:55 +0700
Message-ID: <46A5CF7B.40102@sw.ru>
References: <46A0A462.2090407@sw.ru> <46A5B632.8040201@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060209060102000109080600"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:1504 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761804AbXGXKKN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jul 2007 06:10:13 -0400
In-Reply-To: <46A5B632.8040201@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devel@openvz.org, Albert Lee <albertcc@tw.ibm.com>

This is a multi-part message in MIME format.
--------------060209060102000109080600
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Tejun Heo wrote:
> [cc'ing Albert]
> 
> Vasily Averin wrote:
>> Tejun, Jeff
>>
>> I've noticed that some scsi commands for DVD-drive attached to pata_via
>> successfully finishes without any delays but reports about TIMEOUT condition. It
>> happens because of ATA_ERR bit is set in status register. As result for each
>> command  Error Handler thread awakened, requests sense buffer and go to sleep again.
> 
> Need more info.  Please post boot dmesg and the result of 'lspci -nn'
> and 'hdparm -I /dev/srX' and when such errors occur.

It was 2.6.22 kernel with pata_via and sata_via drivers, scsi and cdrom debug
was temporally enabled via sysctl (please see logs near Jul 24 13:42:46 timestamp)

Btw. I'm not sure that it was an error, I've looked on the sources and IMHO it's
normal command processing cdrom without disk inserted into drive. I've checked
2.6.19, 2.6.20 and 2.6.22 kernels and got the same behavior.

# lspci -nn
00:00.0 0600: 1106:3188 (rev 01)
00:01.0 0604: 1106:b188
00:0b.0 0200: 14e4:1653 (rev 03)
00:0f.0 0104: 1106:3149 (rev 80)
00:0f.1 0101: 1106:0571 (rev 06)
00:10.0 0c03: 1106:3038 (rev 81)
00:10.1 0c03: 1106:3038 (rev 81)
00:10.2 0c03: 1106:3038 (rev 81)
00:10.4 0c03: 1106:3104 (rev 86)
00:11.0 0601: 1106:3227
00:18.0 0600: 1022:1100
00:18.1 0600: 1022:1101
00:18.2 0600: 1022:1102
00:18.3 0600: 1022:1103
00:19.0 0600: 1022:1100
00:19.1 0600: 1022:1101
00:19.2 0600: 1022:1102
00:19.3 0600: 1022:1103

# hdparm -I /dev/cdrom

/dev/cdrom:
 HDIO_DRIVE_CMD(identify) failed: Input/output error

(Hmm, strange. please see logs near Jul 24 13:44:30 timestamp)

You can find more details about this node in
http://bugzilla.kernel.org/show_bug.cgi?id=8650

I have full logs from kernel compiled with extra ata debug -- but it is very
big. Please tell me if you want to look it too.

thank you,
	Vasily Averin

--------------060209060102000109080600
Content-Type: text/x-log;
 name="ts28.22.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ts28.22.log"

Jul 24 13:39:01 ts28 Linux version 2.6.22 (vvs@vvs.work.ve) (gcc version 3.4.6 20060404 (Red Hat 3.4.6-3)) #4 SMP Thu Jul 12 07:58:27 MSD 2007
Jul 24 13:39:01 ts28 Command line: ro root=LABEL=/1 console=ttyS0,115200 console=tty debug silencelevel=8 crashkernel=128M@128M acpc=noirq
Jul 24 13:39:01 ts28 BIOS-provided physical RAM map:
Jul 24 13:39:01 ts28  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
Jul 24 13:39:01 ts28  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
Jul 24 13:39:01 ts28  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Jul 24 13:39:01 ts28  BIOS-e820: 0000000000100000 - 00000000dfee0000 (usable)
Jul 24 13:39:01 ts28  BIOS-e820: 00000000dfee0000 - 00000000dfee3000 (ACPI NVS)
Jul 24 13:39:01 ts28  BIOS-e820: 00000000dfee3000 - 00000000dfef0000 (ACPI data)
Jul 24 13:39:01 ts28  BIOS-e820: 00000000dfef0000 - 00000000dff00000 (reserved)
Jul 24 13:39:01 ts28  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Jul 24 13:39:01 ts28 Entering add_active_range(0, 0, 157) 0 entries of 3200 used
Jul 24 13:39:01 ts28 Entering add_active_range(0, 256, 917216) 1 entries of 3200 used
Jul 24 13:39:01 ts28 end_pfn_map = 1048576
Jul 24 13:39:01 ts28 DMI 2.3 present.
Jul 24 13:39:01 ts28 ACPI: RSDP 000F6980, 0014 (r0 VIAK8 )
Jul 24 13:39:01 ts28 ACPI: RSDT DFEE3000, 002C (r1 VIAK8  AWRDACPI 42302E31 AWRD        0)
Jul 24 13:39:01 ts28 ACPI: FACP DFEE3040, 0074 (r1 VIAK8  AWRDACPI 42302E31 AWRD        0)
Jul 24 13:39:01 ts28 ACPI: DSDT DFEE30C0, 4A4C (r1 VIAK8  AWRDACPI     1000 MSFT  100000E)
Jul 24 13:39:01 ts28 ACPI: FACS DFEE0000, 0040
Jul 24 13:39:01 ts28 ACPI: APIC DFEE7B40, 0068 (r1 VIAK8  AWRDACPI 42302E31 AWRD        0)
Jul 24 13:39:01 ts28 Scanning NUMA topology in Northbridge 24
Jul 24 13:39:01 ts28 Number of nodes 2
Jul 24 13:39:01 ts28 Node 0 MemBase 0000000000000000 Limit 00000000dfee0000
Jul 24 13:39:01 ts28 Entering add_active_range(0, 0, 157) 0 entries of 3200 used
Jul 24 13:39:01 ts28 Entering add_active_range(0, 256, 917216) 1 entries of 3200 used
Jul 24 13:39:01 ts28 Skipping disabled node 1
Jul 24 13:39:01 ts28 NUMA: Using 63 for the hash shift.
Jul 24 13:39:01 ts28 Using node hash shift of 63
Jul 24 13:39:01 ts28 Bootmem setup node 0 0000000000000000-00000000dfee0000
Jul 24 13:39:01 ts28 Zone PFN ranges:
Jul 24 13:39:01 ts28   DMA             0 ->     4096
Jul 24 13:39:01 ts28   DMA32        4096 ->  1048576
Jul 24 13:39:01 ts28   Normal    1048576 ->  1048576
Jul 24 13:39:01 ts28 early_node_map[2] active PFN ranges
Jul 24 13:39:01 ts28     0:        0 ->      157
Jul 24 13:39:01 ts28     0:      256 ->   917216
Jul 24 13:39:01 ts28 On node 0 totalpages: 917117
Jul 24 13:39:01 ts28   DMA zone: 56 pages used for memmap
Jul 24 13:39:01 ts28   DMA zone: 2018 pages reserved
Jul 24 13:39:01 ts28   DMA zone: 1923 pages, LIFO batch:0
Jul 24 13:39:01 ts28   DMA32 zone: 12484 pages used for memmap
Jul 24 13:39:01 ts28 
Jul 24 13:39:01 ts28   DMA32 zone: 900636 pages, LIFO batch:31
Jul 24 13:39:01 ts28   Normal zone: 0 pages used for memmap
Jul 24 13:39:01 ts28 ACPI: PM-Timer IO Port: 0x4008
Jul 24 13:39:01 ts28 ACPI: Local APIC address 0xfee00000
Jul 24 13:39:01 ts28 ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Jul 24 13:39:01 ts28 Processor #0 (Bootup-CPU)
Jul 24 13:39:01 ts28 ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Jul 24 13:39:01 ts28 Processor #1
Jul 24 13:39:01 ts28 ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
Jul 24 13:39:01 ts28 ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Jul 24 13:39:01 ts28 ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Jul 24 13:39:01 ts28 IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
Jul 24 13:39:01 ts28 ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Jul 24 13:39:01 ts28 ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Jul 24 13:39:01 ts28 ACPI: IRQ0 used by override.
Jul 24 13:39:01 ts28 ACPI: IRQ2 used by override.
Jul 24 13:39:01 ts28 ACPI: IRQ9 used by override.
Jul 24 13:39:01 ts28 Setting APIC routing to flat
Jul 24 13:39:01 ts28 Using ACPI (MADT) for SMP configuration information
Jul 24 13:39:01 ts28 Allocating PCI resources starting at e0000000 (gap: dff00000:1ed00000)
Jul 24 13:39:01 ts28 PERCPU: Allocating 68072 bytes of per cpu data
Jul 24 13:39:01 ts28 Built 1 zonelists.  Total pages: 902559
Jul 24 13:39:01 ts28 Kernel command line: ro root=LABEL=/1 console=ttyS0,115200 console=tty debug silencelevel=8 crashkernel=128M@128M acpc=noirq
Jul 24 13:39:01 ts28 Initializing CPU#0
Jul 24 13:39:01 ts28 PID hash table entries: 4096 (order: 12, 32768 bytes)
Jul 24 13:39:01 ts28 Marking TSC unstable due to TSCs unsynchronized
Jul 24 13:39:01 ts28 time.c: Detected 2004.613 MHz processor.
Jul 24 13:39:01 ts28 Console: colour VGA+ 80x25
Jul 24 13:39:01 ts28 Checking aperture...
Jul 24 13:39:01 ts28 CPU 0: aperture @ e8000000 size 128 MB
Jul 24 13:39:01 ts28 CPU 1: aperture @ e8000000 size 128 MB
Jul 24 13:39:01 ts28 Memory: 3477240k/3668864k available (2449k kernel code, 191228k reserved, 1418k data, 296k init)
Jul 24 13:39:01 ts28 Calibrating delay using timer specific routine.. 4012.11 BogoMIPS (lpj=2006056)
Jul 24 13:39:01 ts28 Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Jul 24 13:39:01 ts28 Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Jul 24 13:39:01 ts28 Mount-cache hash table entries: 256
Jul 24 13:39:01 ts28 CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Jul 24 13:39:01 ts28 CPU: L2 Cache: 1024K (64 bytes/line)
Jul 24 13:39:01 ts28 CPU 0/0 -> Node 0
Jul 24 13:39:01 ts28 Freeing SMP alternatives: 27k freed
Jul 24 13:39:01 ts28 ACPI: Core revision 20070126
Jul 24 13:39:01 ts28 Using local APIC timer interrupts.
Jul 24 13:39:01 ts28 result 12528848
Jul 24 13:39:01 ts28 Detected 12.528 MHz APIC timer.
Jul 24 13:39:01 ts28 Booting processor 1/2 APIC 0x1
Jul 24 13:39:01 ts28 Initializing CPU#1
Jul 24 13:39:01 ts28 Calibrating delay using timer specific routine.. 4008.43 BogoMIPS (lpj=2004219)
Jul 24 13:39:01 ts28 CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Jul 24 13:39:01 ts28 CPU: L2 Cache: 1024K (64 bytes/line)
Jul 24 13:39:01 ts28 CPU 1/1 -> Node 0
Jul 24 13:39:01 ts28 AMD Opteron(tm) Processor 246 stepping 0a
Jul 24 13:39:01 ts28 Brought up 2 CPUs
Jul 24 13:39:01 ts28 migration_cost=417
Jul 24 13:39:01 ts28 NET: Registered protocol family 16
Jul 24 13:39:01 ts28 No dock devices found.
Jul 24 13:39:01 ts28 ACPI: bus type pci registered
Jul 24 13:39:01 ts28 PCI: Using configuration type 1
Jul 24 13:39:01 ts28 ACPI: Interpreter enabled
Jul 24 13:39:01 ts28 ACPI: Using IOAPIC for interrupt routing
Jul 24 13:39:01 ts28 ACPI: PCI Root Bridge [PCI0] (0000:00)
Jul 24 13:39:01 ts28 PCI: Probing PCI hardware (bus 00)
Jul 24 13:39:01 ts28 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Jul 24 13:39:01 ts28 ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12)
Jul 24 13:39:01 ts28 ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 *11 12)
Jul 24 13:39:01 ts28 ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12) *5
Jul 24 13:39:01 ts28 ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12) *0, disabled.
Jul 24 13:39:01 ts28 ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12) *0, disabled.
Jul 24 13:39:01 ts28 ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12) *0, disabled.
Jul 24 13:39:01 ts28 ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 6 7 10 11 12) *0, disabled.
Jul 24 13:39:01 ts28 ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 6 7 10 11 12) *0, disabled.
Jul 24 13:39:01 ts28 ACPI: PCI Interrupt Link [ALKA] (IRQs 20) *0
Jul 24 13:39:01 ts28 ACPI: PCI Interrupt Link [ALKB] (IRQs 21) *0
Jul 24 13:39:01 ts28 ACPI: PCI Interrupt Link [ALKC] (IRQs 22) *0
Jul 24 13:39:01 ts28 ACPI: PCI Interrupt Link [ALKD] (IRQs 23) *0, disabled.
Jul 24 13:39:01 ts28 
Jul 24 13:39:01 ts28 Linux Plug and Play Support v0.97 (c) Adam Belay
Jul 24 13:39:01 ts28 pnp: PnP ACPI init
Jul 24 13:39:01 ts28 ACPI: bus type pnp registered
Jul 24 13:39:01 ts28 pnp: PnP ACPI: found 14 devices
Jul 24 13:39:01 ts28 ACPI: ACPI bus type pnp unregistered
Jul 24 13:39:01 ts28 SCSI subsystem initialized
Jul 24 13:39:01 ts28 libata version 2.21 loaded.
Jul 24 13:39:01 ts28 usbcore: registered new interface driver usbfs
Jul 24 13:39:01 ts28 usbcore: registered new interface driver hub
Jul 24 13:39:01 ts28 usbcore: registered new device driver usb
Jul 24 13:39:01 ts28 PCI: Using ACPI for IRQ routing
Jul 24 13:39:01 ts28 PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Jul 24 13:39:01 ts28 PCI: Cannot allocate resource region 0 of device 0000:00:00.0
Jul 24 13:39:01 ts28 agpgart: Detected AGP bridge 0
Jul 24 13:39:01 ts28 agpgart: AGP aperture is 128M @ 0xe8000000
Jul 24 13:39:01 ts28 pnp: 00:00: iomem range 0xd6000-0xd7fff has been reserved
Jul 24 13:39:01 ts28 pnp: 00:00: iomem range 0xf0000-0xf7fff could not be reserved
Jul 24 13:39:01 ts28 pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
Jul 24 13:39:02 ts28 pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
Jul 24 13:39:02 ts28 pnp: 00:02: ioport range 0x4000-0x407f has been reserved
Jul 24 13:39:02 ts28 pnp: 00:02: ioport range 0x5000-0x500f has been reserved
Jul 24 13:39:02 ts28 PCI: Bridge: 0000:00:01.0
Jul 24 13:39:02 ts28   IO window: disabled.
Jul 24 13:39:02 ts28   MEM window: f8000000-f9ffffff
Jul 24 13:39:02 ts28 Time: acpi_pm clocksource has been installed.
Jul 24 13:39:02 ts28   PREFETCH window: f0000000-f7ffffff
Jul 24 13:39:02 ts28 PCI: Setting latency timer of device 0000:00:01.0 to 64
Jul 24 13:39:02 ts28 NET: Registered protocol family 2
Jul 24 13:39:02 ts28 IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
Jul 24 13:39:02 ts28 TCP established hash table entries: 524288 (order: 11, 12582912 bytes)
Jul 24 13:39:02 ts28 TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Jul 24 13:39:02 ts28 TCP: Hash tables configured (established 524288 bind 65536)
Jul 24 13:39:02 ts28 TCP reno registered
Jul 24 13:39:02 ts28 checking if image is initramfs... it is
Jul 24 13:39:02 ts28 Freeing initrd memory: 1447k freed
Jul 24 13:39:02 ts28 audit: initializing netlink socket (disabled)
Jul 24 13:39:02 ts28 audit(1185269885.320:1): initialized
Jul 24 13:39:02 ts28 Total HugeTLB memory allocated, 0
Jul 24 13:39:02 ts28 VFS: Disk quotas dquot_6.5.1
Jul 24 13:39:02 ts28 Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Jul 24 13:39:02 ts28 io scheduler noop registered
Jul 24 13:39:02 ts28 io scheduler anticipatory registered
Jul 24 13:39:02 ts28 io scheduler deadline registered
Jul 24 13:39:02 ts28 io scheduler cfq registered (default)
Jul 24 13:39:02 ts28 PCI: VIA PCI bridge detected. Disabling DAC.
Jul 24 13:39:02 ts28 Boot video device is 0000:01:00.0
Jul 24 13:39:02 ts28 pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Jul 24 13:39:02 ts28 ACPI: Fan [FAN] (on)
Jul 24 13:39:02 ts28 ACPI: Thermal Zone [THRM] (40 C)
Jul 24 13:39:02 ts28 Real Time Clock Driver v1.12ac
Jul 24 13:39:02 ts28 Non-volatile memory driver v1.2
Jul 24 13:39:02 ts28 Linux agpgart interface v0.102 (c) Dave Jones
Jul 24 13:39:02 ts28 Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Jul 24 13:39:02 ts28 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Jul 24 13:39:02 ts28 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Jul 24 13:39:02 ts28 RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
Jul 24 13:39:02 ts28 Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
Jul 24 13:39:02 ts28 ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Jul 24 13:39:02 ts28 ide-floppy driver 0.99.newide
Jul 24 13:39:02 ts28 sata_via 0000:00:0f.0: version 2.2
Jul 24 13:39:02 ts28 ACPI: PCI Interrupt Link [ALKA] BIOS reported IRQ 0, using IRQ 20
Jul 24 13:39:02 ts28 ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 20
Jul 24 13:39:02 ts28 ACPI: PCI Interrupt 0000:00:0f.0[B] -> Link [ALKA] -> GSI 20 (level, low) -> IRQ 20
Jul 24 13:39:02 ts28 sata_via 0000:00:0f.0: routed to hard irq line 11
Jul 24 13:39:02 ts28 scsi0 : sata_via
Jul 24 13:39:02 ts28 scsi1 : sata_via
Jul 24 13:39:02 ts28 ata1: SATA max UDMA/133 cmd 0x000000000001c000 ctl 0x000000000001c402 bmdma 0x000000000001d000 irq 20
Jul 24 13:39:02 ts28 ata2: SATA max UDMA/133 cmd 0x000000000001c800 ctl 0x000000000001cc02 bmdma 0x000000000001d008 irq 20
Jul 24 13:39:02 ts28 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Jul 24 13:39:02 ts28 ata1.00: ATA-7: ST380811AS, 3.AAE, max UDMA/133
Jul 24 13:39:02 ts28 ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 0/32)
Jul 24 13:39:02 ts28 ata1.00: configured for UDMA/133
Jul 24 13:39:02 ts28 ata2: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
Jul 24 13:39:02 ts28 scsi 0:0:0:0: Direct-Access     ATA      ST380811AS       3.AA PQ: 0 ANSI: 5
Jul 24 13:39:02 ts28 sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
Jul 24 13:39:02 ts28 sd 0:0:0:0: [sda] Write Protect is off
Jul 24 13:39:02 ts28 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jul 24 13:39:02 ts28 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 24 13:39:02 ts28 sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
Jul 24 13:39:02 ts28 sd 0:0:0:0: [sda] Write Protect is off
Jul 24 13:39:02 ts28 sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jul 24 13:39:02 ts28 
Jul 24 13:39:02 ts28 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 24 13:39:02 ts28  sda: sda1 sda2 sda3 sda4 < sda5 >
Jul 24 13:39:03 ts28 
Jul 24 13:39:03 ts28 sd 0:0:0:0: [sda] Attached SCSI disk
Jul 24 13:39:03 ts28 pata_via 0000:00:0f.1: version 0.3.1
Jul 24 13:39:03 ts28 ACPI: PCI Interrupt 0000:00:0f.1[A] -> Link [ALKA] -> GSI 20 (level, low) -> IRQ 20
Jul 24 13:39:03 ts28 scsi2 : pata_via
Jul 24 13:39:03 ts28 scsi3 : pata_via
Jul 24 13:39:03 ts28 ata3: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x000000000001d800 irq 14
Jul 24 13:39:03 ts28 ata4: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x000000000001d808 irq 15
Jul 24 13:39:03 ts28 ata3.00: ATAPI: TEAC DV-516G, F4S6, max UDMA/33
Jul 24 13:39:03 ts28 ata3.00: configured for UDMA/33
Jul 24 13:39:03 ts28 scsi 2:0:0:0: CD-ROM            TEAC     DV-516G          F4S6 PQ: 0 ANSI: 5
Jul 24 13:39:03 ts28 PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Jul 24 13:39:03 ts28 serio: i8042 KBD port at 0x60,0x64 irq 1
Jul 24 13:39:03 ts28 serio: i8042 AUX port at 0x60,0x64 irq 12
Jul 24 13:39:03 ts28 mice: PS/2 mouse device common for all mice
Jul 24 13:39:03 ts28 input: AT Translated Set 2 keyboard as /class/input/input0
Jul 24 13:39:03 ts28 usbcore: registered new interface driver hiddev
Jul 24 13:39:03 ts28 usbcore: registered new interface driver usbhid
Jul 24 13:39:03 ts28 drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Jul 24 13:39:03 ts28 TCP bic registered
Jul 24 13:39:03 ts28 Initializing XFRM netlink socket
Jul 24 13:39:03 ts28 NET: Registered protocol family 1
Jul 24 13:39:03 ts28 NET: Registered protocol family 17
Jul 24 13:39:03 ts28 powernow-k8: Found 2 AMD Opteron(tm) Processor 246 processors (version 2.00.00)
Jul 24 13:39:03 ts28 powernow-k8: MP systems not supported by PSB BIOS structure
Jul 24 13:39:03 ts28 powernow-k8: MP systems not supported by PSB BIOS structure
Jul 24 13:39:03 ts28 Freeing unused kernel memory: 296k freed
Jul 24 13:39:03 ts28 Write protecting the kernel read-only data: 840k
Jul 24 13:39:04 ts28 input: ImPS/2 Generic Wheel Mouse as /class/input/input1
Jul 24 13:39:04 ts28 USB Universal Host Controller Interface driver v3.0
Jul 24 13:39:04 ts28 ACPI: PCI Interrupt Link [ALKB] BIOS reported IRQ 0, using IRQ 21
Jul 24 13:39:04 ts28 ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
Jul 24 13:39:04 ts28 ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 21
Jul 24 13:39:04 ts28 uhci_hcd 0000:00:10.0: UHCI Host Controller
Jul 24 13:39:04 ts28 uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
Jul 24 13:39:04 ts28 uhci_hcd 0000:00:10.0: irq 21, io base 0x0000dc00
Jul 24 13:39:04 ts28 usb usb1: configuration #1 chosen from 1 choice
Jul 24 13:39:04 ts28 hub 1-0:1.0: USB hub found
Jul 24 13:39:04 ts28 hub 1-0:1.0: 2 ports detected
Jul 24 13:39:04 ts28 ACPI: PCI Interrupt 0000:00:10.1[A] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 21
Jul 24 13:39:04 ts28 uhci_hcd 0000:00:10.1: UHCI Host Controller
Jul 24 13:39:04 ts28 uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
Jul 24 13:39:04 ts28 uhci_hcd 0000:00:10.1: irq 21, io base 0x0000e000
Jul 24 13:39:04 ts28 usb usb2: configuration #1 chosen from 1 choice
Jul 24 13:39:04 ts28 hub 2-0:1.0: USB hub found
Jul 24 13:39:04 ts28 hub 2-0:1.0: 2 ports detected
Jul 24 13:39:04 ts28 ACPI: PCI Interrupt 0000:00:10.2[B] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 21
Jul 24 13:39:04 ts28 uhci_hcd 0000:00:10.2: UHCI Host Controller
Jul 24 13:39:04 ts28 uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
Jul 24 13:39:04 ts28 uhci_hcd 0000:00:10.2: irq 21, io base 0x0000e400
Jul 24 13:39:04 ts28 usb usb3: configuration #1 chosen from 1 choice
Jul 24 13:39:04 ts28 hub 3-0:1.0: USB hub found
Jul 24 13:39:04 ts28 hub 3-0:1.0: 2 ports detected
Jul 24 13:39:04 ts28 ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
Jul 24 13:39:04 ts28 ACPI: PCI Interrupt 0000:00:10.4[C] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 21
Jul 24 13:39:04 ts28 ehci_hcd 0000:00:10.4: EHCI Host Controller
Jul 24 13:39:04 ts28 ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 4
Jul 24 13:39:04 ts28 ehci_hcd 0000:00:10.4: irq 21, io mem 0xfa010000
Jul 24 13:39:04 ts28 ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Jul 24 13:39:04 ts28 usb usb4: configuration #1 chosen from 1 choice
Jul 24 13:39:04 ts28 hub 4-0:1.0: USB hub found
Jul 24 13:39:04 ts28 hub 4-0:1.0: 6 ports detected
Jul 24 13:39:04 ts28 device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
Jul 24 13:39:04 ts28 kjournald starting.  Commit interval 5 seconds
Jul 24 13:39:04 ts28 EXT3-fs: mounted filesystem with ordered data mode.
Jul 24 13:39:19 ts28 Bluetooth: Core ver 2.11
Jul 24 13:39:19 ts28 NET: Registered protocol family 31
Jul 24 13:39:19 ts28 Bluetooth: HCI device and connection manager initialized
Jul 24 13:39:19 ts28 Bluetooth: HCI socket layer initialized
Jul 24 13:39:19 ts28 Bluetooth: L2CAP ver 2.8
Jul 24 13:39:19 ts28 Bluetooth: L2CAP socket layer initialized
Jul 24 13:39:19 ts28 Bluetooth: RFCOMM socket layer initialized
Jul 24 13:39:19 ts28 Bluetooth: RFCOMM TTY layer initialized
Jul 24 13:39:19 ts28 Bluetooth: RFCOMM ver 1.8
Jul 24 13:39:20 ts28 Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Jul 24 13:39:27 ts28 eth0: no IPv6 routers present
Jul 24 13:42:46 ts28 cdrom: entering cdrom_open
Jul 24 13:42:46 ts28 scsi_block_when_processing_errors: rtn: 1
Jul 24 13:42:46 ts28 cdrom: Use count for "/dev/sr0" now 1
Jul 24 13:42:46 ts28 scsi_add_timer: scmd: ffff8100d277ab00, time: 30000, (ffffffff80382c14)
Jul 24 13:42:46 ts28 sr 2:0:0:0: Send: 0xffff8100d277ab00 
Jul 24 13:42:46 ts28 sr 2:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Jul 24 13:42:46 ts28 buffer = 0x0000000000000000, bufflen = 0, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:42:46 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:42:46 ts28 scsi_delete_timer: scmd: ffff8100d277ab00, rtn: 1
Jul 24 13:42:46 ts28 sr 2:0:0:0: Done: 0xffff8100d277ab00 TIMEOUT
Jul 24 13:42:46 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:42:46 ts28 sr 2:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Jul 24 13:42:46 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:42:46 ts28 
Jul 24 13:42:46 ts28 Waking error handler thread
Jul 24 13:42:46 ts28 Error handler scsi_eh_2 waking up
Jul 24 13:42:46 ts28 scsi_eh_2: flush finish cmd: ffff8100d277ab00
Jul 24 13:42:46 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 24 13:42:46 ts28 8 sectors total, 0 bytes done.
Jul 24 13:42:46 ts28 use_sg is 0
Jul 24 13:42:46 ts28 scsi_restart_operations: waking up host to restart
Jul 24 13:42:46 ts28 Error handler scsi_eh_2 sleeping
Jul 24 13:42:46 ts28 scsi_block_when_processing_errors: rtn: 1
Jul 24 13:42:46 ts28 scsi_add_timer: scmd: ffff8100d277ae00, time: 30000, (ffffffff80382c14)
Jul 24 13:42:46 ts28 sr 2:0:0:0: Send: 0xffff8100d277ae00 
Jul 24 13:42:46 ts28 sr 2:0:0:0: CDB: Read TOC/PMA/ATIP: 43 00 00 00 00 00 00 00 0c 40
Jul 24 13:42:46 ts28 buffer = 0xffff8100dea78080, bufflen = 12, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:42:46 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:42:46 ts28 scsi_delete_timer: scmd: ffff8100d277ae00, rtn: 1
Jul 24 13:42:46 ts28 sr 2:0:0:0: Done: 0xffff8100d277ae00 TIMEOUT
Jul 24 13:42:46 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:42:46 ts28 sr 2:0:0:0: CDB: Read TOC/PMA/ATIP: 43 00 00 00 00 00 00 00 0c 40
Jul 24 13:42:46 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:42:46 ts28 Waking error handler thread
Jul 24 13:42:46 ts28 Error handler scsi_eh_2 waking up
Jul 24 13:42:46 ts28 scsi_eh_2: flush finish cmd: ffff8100d277ae00
Jul 24 13:42:46 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 24 13:42:46 ts28 0 sectors total, 12 bytes done.
Jul 24 13:42:46 ts28 use_sg is 1
Jul 24 13:42:46 ts28 scsi_restart_operations: waking up host to restart
Jul 24 13:42:46 ts28 Error handler scsi_eh_2 sleeping
Jul 24 13:42:46 ts28 scsi_block_when_processing_errors: rtn: 1
Jul 24 13:42:46 ts28 scsi_add_timer: scmd: ffff8100d277a200, time: 30000, (ffffffff80382c14)
Jul 24 13:42:46 ts28 sr 2:0:0:0: Send: 0xffff8100d277a200 
Jul 24 13:42:46 ts28 
Jul 24 13:42:46 ts28 sr 2:0:0:0: CDB: Read TOC/PMA/ATIP: 43 00 00 00 00 00 00 00 0c 00
Jul 24 13:42:46 ts28 buffer = 0xffff8100dea78b80, bufflen = 12, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:42:46 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:42:46 ts28 scsi_delete_timer: scmd: ffff8100d277a200, rtn: 1
Jul 24 13:42:46 ts28 sr 2:0:0:0: Done: 0xffff8100d277a200 TIMEOUT
Jul 24 13:42:46 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:42:46 ts28 sr 2:0:0:0: CDB: Read TOC/PMA/ATIP: 43 00 00 00 00 00 00 00 0c 00
Jul 24 13:42:46 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:42:46 ts28 Waking error handler thread
Jul 24 13:42:46 ts28 Error handler scsi_eh_2 waking up
Jul 24 13:42:46 ts28 scsi_eh_2: flush finish cmd: ffff8100d277a200
Jul 24 13:42:46 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 24 13:42:46 ts28 0 sectors total, 12 bytes done.
Jul 24 13:42:46 ts28 use_sg is 1
Jul 24 13:42:46 ts28 scsi_restart_operations: waking up host to restart
Jul 24 13:42:46 ts28 scsi_add_timer: scmd: ffff8100d277a080, time: 30000, (ffffffff80382c14)
Jul 24 13:42:46 ts28 sr 2:0:0:0: Send: 0xffff8100d277a080 
Jul 24 13:42:46 ts28 sr 2:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
Jul 24 13:42:46 ts28 buffer = 0xffff8100dea78d80, bufflen = 8, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:42:46 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:42:46 ts28 Error handler scsi_eh_2 sleeping
Jul 24 13:42:46 ts28 scsi_delete_timer: scmd: ffff8100d277a080, rtn: 1
Jul 24 13:42:46 ts28 sr 2:0:0:0: Done: 0xffff8100d277a080 TIMEOUT
Jul 24 13:42:46 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:42:46 ts28 sr 2:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
Jul 24 13:42:46 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:42:46 ts28 Waking error handler thread
Jul 24 13:42:46 ts28 Error handler scsi_eh_2 waking up
Jul 24 13:42:46 ts28 scsi_eh_2: flush finish cmd: ffff8100d277a080
Jul 24 13:42:46 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 24 13:42:46 ts28 0 sectors total, 8 bytes done.
Jul 24 13:42:46 ts28 use_sg is 1
Jul 24 13:42:46 ts28 scsi_restart_operations: waking up host to restart
Jul 24 13:42:46 ts28 scsi_add_timer: scmd: ffff8100d277a500, time: 30000, (ffffffff80382c14)
Jul 24 13:42:46 ts28 sr 2:0:0:0: Send: 0xffff8100d277a500 
Jul 24 13:42:46 ts28 sr 2:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
Jul 24 13:42:46 ts28 buffer = 0xffff8100dea78380, bufflen = 8, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:42:46 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:42:46 ts28 Error handler scsi_eh_2 sleeping
Jul 24 13:42:46 ts28 scsi_delete_timer: scmd: ffff8100d277a500, rtn: 1
Jul 24 13:42:46 ts28 sr 2:0:0:0: Done: 0xffff8100d277a500 TIMEOUT
Jul 24 13:42:46 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:42:46 ts28 sr 2:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
Jul 24 13:42:46 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:42:46 ts28 Waking error handler thread
Jul 24 13:42:46 ts28 
Jul 24 13:42:46 ts28 Error handler scsi_eh_2 waking up
Jul 24 13:42:46 ts28 scsi_eh_2: flush finish cmd: ffff8100d277a500
Jul 24 13:42:46 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 24 13:42:46 ts28 0 sectors total, 8 bytes done.
Jul 24 13:42:46 ts28 use_sg is 1
Jul 24 13:42:46 ts28 scsi_restart_operations: waking up host to restart
Jul 24 13:42:46 ts28 scsi_add_timer: scmd: ffff8100d277a380, time: 30000, (ffffffff80382c14)
Jul 24 13:42:46 ts28 sr 2:0:0:0: Send: 0xffff8100d277a380 
Jul 24 13:42:46 ts28 sr 2:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
Jul 24 13:42:46 ts28 buffer = 0xffff8100dea78980, bufflen = 8, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:42:46 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:42:46 ts28 Error handler scsi_eh_2 sleeping
Jul 24 13:42:46 ts28 scsi_delete_timer: scmd: ffff8100d277a380, rtn: 1
Jul 24 13:42:46 ts28 sr 2:0:0:0: Done: 0xffff8100d277a380 TIMEOUT
Jul 24 13:42:46 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:42:46 ts28 sr 2:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
Jul 24 13:42:46 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:42:46 ts28 Waking error handler thread
Jul 24 13:42:46 ts28 Error handler scsi_eh_2 waking up
Jul 24 13:42:46 ts28 scsi_eh_2: flush finish cmd: ffff8100d277a380
Jul 24 13:42:46 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 24 13:42:46 ts28 0 sectors total, 8 bytes done.
Jul 24 13:42:46 ts28 use_sg is 1
Jul 24 13:42:46 ts28 scsi_restart_operations: waking up host to restart
Jul 24 13:42:46 ts28 cdrom: entering CDROM_DRIVE_STATUS
Jul 24 13:42:46 ts28 Error handler scsi_eh_2 sleeping
Jul 24 13:42:46 ts28 scsi_block_when_processing_errors: rtn: 1
Jul 24 13:42:46 ts28 scsi_add_timer: scmd: ffff8100d277a680, time: 30000, (ffffffff80382c14)
Jul 24 13:42:46 ts28 sr 2:0:0:0: Send: 0xffff8100d277a680 
Jul 24 13:42:46 ts28 sr 2:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Jul 24 13:42:46 ts28 buffer = 0x0000000000000000, bufflen = 0, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:42:46 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:42:46 ts28 scsi_delete_timer: scmd: ffff8100d277a680, rtn: 1
Jul 24 13:42:46 ts28 sr 2:0:0:0: Done: 0xffff8100d277a680 TIMEOUT
Jul 24 13:42:46 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:42:46 ts28 sr 2:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Jul 24 13:42:46 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:42:46 ts28 Waking error handler thread
Jul 24 13:42:46 ts28 Error handler scsi_eh_2 waking up
Jul 24 13:42:46 ts28 scsi_eh_2: flush finish cmd: ffff8100d277a680
Jul 24 13:42:46 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 24 13:42:46 ts28 0 sectors total, 0 bytes done.
Jul 24 13:42:46 ts28 use_sg is 0
Jul 24 13:42:46 ts28 scsi_restart_operations: waking up host to restart
Jul 24 13:42:46 ts28 cdrom: entering cdrom_release
Jul 24 13:42:46 ts28 cdrom: Use count for "/dev/sr0" now zero
Jul 24 13:42:46 ts28 cdrom: sr0: No DVD+RW
Jul 24 13:42:46 ts28 cdrom: Unlocking door!
Jul 24 13:42:46 ts28 Trying ioctl with scsi command 30
Jul 24 13:42:46 ts28 scsi_add_timer: scmd: ffff810037f30680, time: 10000, (ffffffff80382c14)
Jul 24 13:42:46 ts28 sr 2:0:0:0: Send: 0xffff810037f30680 
Jul 24 13:42:46 ts28 sr 2:0:0:0: CDB: Prevent/Allow Medium Removal: 1e 00 00 00 00 00
Jul 24 13:42:46 ts28 buffer = 0x0000000000000000, bufflen = 0, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:42:46 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:42:46 ts28 Error handler scsi_eh_2 sleeping
Jul 24 13:42:46 ts28 scsi_delete_timer: scmd: ffff810037f30680, rtn: 1
Jul 24 13:42:46 ts28 sr 2:0:0:0: Done: 0xffff810037f30680 SUCCESS
Jul 24 13:42:46 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:42:46 ts28 sr 2:0:0:0: CDB: Prevent/Allow Medium Removal: 1e 00 00 00 00 00
Jul 24 13:42:46 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:42:46 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 0)
Jul 24 13:42:46 ts28 0 sectors total, 0 bytes done.
Jul 24 13:42:46 ts28 use_sg is 0
Jul 24 13:42:46 ts28 Ioctl returned  0x0
Jul 24 13:42:46 ts28 IOCTL Releasing command
Jul 24 13:44:29 ts28 sd 0:0:0:0: [sda] sd_init_command: block=15725208, count=32
Jul 24 13:44:29 ts28 sd 0:0:0:0: [sda] block=15725208
Jul 24 13:44:29 ts28 sd 0:0:0:0: [sda] reading 32/32 512 byte blocks.
Jul 24 13:44:29 ts28 
Jul 24 13:44:29 ts28 scsi_add_timer: scmd: ffff8100d277ae00, time: 60000, (ffffffff80382c14)
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Send: 0xffff8100d277ae00 
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 ef f2 98 00 00 20 00
Jul 24 13:44:30 ts28 buffer = 0xffff8100dea78280, bufflen = 16384, done = 0xffffffff8038b663, queuecommand 0xffffffff80396bb2
Jul 24 13:44:30 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:30 ts28 scsi_delete_timer: scmd: ffff8100d277ae00, rtn: 1
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Done: 0xffff8100d277ae00 SUCCESS
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 ef f2 98 00 00 20 00
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] scsi host busy 1 failed 0
Jul 24 13:44:30 ts28 sd 0:0:0:0: Notifying upper driver of completion (result 0)
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:30 ts28 32 sectors total, 16384 bytes done.
Jul 24 13:44:30 ts28 use_sg is 1
Jul 24 13:44:30 ts28 
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] sd_init_command: block=15725240, count=8
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] block=15725240
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] reading 8/8 512 byte blocks.
Jul 24 13:44:30 ts28 scsi_add_timer: scmd: ffff8100d277ab00, time: 60000, (ffffffff80382c14)
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Send: 0xffff8100d277ab00 
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 ef f2 b8 00 00 08 00
Jul 24 13:44:30 ts28 buffer = 0xffff8100dea78c80, bufflen = 4096, done = 0xffffffff8038b663, queuecommand 0xffffffff80396bb2
Jul 24 13:44:30 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:30 ts28 scsi_delete_timer: scmd: ffff8100d277ab00, rtn: 1
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Done: 0xffff8100d277ab00 SUCCESS
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 ef f2 b8 00 00 08 00
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] scsi host busy 1 failed 0
Jul 24 13:44:30 ts28 sd 0:0:0:0: Notifying upper driver of completion (result 0)
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:30 ts28 8 sectors total, 4096 bytes done.
Jul 24 13:44:30 ts28 use_sg is 1
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] sd_init_command: block=15725248, count=8
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] block=15725248
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] reading 8/8 512 byte blocks.
Jul 24 13:44:30 ts28 scsi_add_timer: scmd: ffff8100d277ac80, time: 60000, (ffffffff80382c14)
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Send: 0xffff8100d277ac80 
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 ef f2 c0 00 00 08 00
Jul 24 13:44:30 ts28 buffer = 0xffff8100dea78380, bufflen = 4096, done = 0xffffffff8038b663, queuecommand 0xffffffff80396bb2
Jul 24 13:44:30 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:30 ts28 scsi_delete_timer: scmd: ffff8100d277ac80, rtn: 1
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Done: 0xffff8100d277ac80 SUCCESS
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 ef f2 c0 00 00 08 00
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] scsi host busy 1 failed 0
Jul 24 13:44:30 ts28 sd 0:0:0:0: Notifying upper driver of completion (result 0)
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:30 ts28 8 sectors total, 4096 bytes done.
Jul 24 13:44:30 ts28 use_sg is 1
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] sd_init_command: block=15725256, count=56
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] block=15725256
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] reading 56/56 512 byte blocks.
Jul 24 13:44:30 ts28 scsi_add_timer: scmd: ffff8100d277a200, time: 60000, (ffffffff80382c14)
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Send: 0xffff8100d277a200 
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 ef f2 c8 00 00 38 00
Jul 24 13:44:30 ts28 buffer = 0xffff8100dea78a80, bufflen = 28672, done = 0xffffffff8038b663, queuecommand 0xffffffff80396bb2
Jul 24 13:44:30 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:30 ts28 scsi_delete_timer: scmd: ffff8100d277a200, rtn: 1
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Done: 0xffff8100d277a200 SUCCESS
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 ef f2 c8 00 00 38 00
Jul 24 13:44:30 ts28 
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] scsi host busy 1 failed 0
Jul 24 13:44:30 ts28 sd 0:0:0:0: Notifying upper driver of completion (result 0)
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:30 ts28 56 sectors total, 28672 bytes done.
Jul 24 13:44:30 ts28 use_sg is 4
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] sd_init_command: block=15725312, count=24
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] block=15725312
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] reading 24/24 512 byte blocks.
Jul 24 13:44:30 ts28 scsi_add_timer: scmd: ffff8100d277a800, time: 60000, (ffffffff80382c14)
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Send: 0xffff8100d277a800 
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 ef f3 00 00 00 18 00
Jul 24 13:44:30 ts28 buffer = 0xffff8100dea78980, bufflen = 12288, done = 0xffffffff8038b663, queuecommand 0xffffffff80396bb2
Jul 24 13:44:30 ts28 
Jul 24 13:44:30 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:30 ts28 scsi_delete_timer: scmd: ffff8100d277a800, rtn: 1
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Done: 0xffff8100d277a800 SUCCESS
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 ef f3 00 00 00 18 00
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] scsi host busy 1 failed 0
Jul 24 13:44:30 ts28 sd 0:0:0:0: Notifying upper driver of completion (result 0)
Jul 24 13:44:30 ts28 sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:30 ts28 24 sectors total, 12288 bytes done.
Jul 24 13:44:30 ts28 use_sg is 2
Jul 24 13:44:30 ts28 cdrom: entering cdrom_open
Jul 24 13:44:30 ts28 scsi_block_when_processing_errors: rtn: 1
Jul 24 13:44:30 ts28 cdrom: Use count for "/dev/sr0" now 1
Jul 24 13:44:30 ts28 scsi_add_timer: scmd: ffff8100d277a980, time: 30000, (ffffffff80382c14)
Jul 24 13:44:30 ts28 sr 2:0:0:0: Send: 0xffff8100d277a980 
Jul 24 13:44:30 ts28 sr 2:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Jul 24 13:44:30 ts28 buffer = 0x0000000000000000, bufflen = 0, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:30 ts28 
Jul 24 13:44:30 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:30 ts28 scsi_delete_timer: scmd: ffff8100d277a980, rtn: 1
Jul 24 13:44:30 ts28 sr 2:0:0:0: Done: 0xffff8100d277a980 TIMEOUT
Jul 24 13:44:30 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:30 ts28 sr 2:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Jul 24 13:44:30 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:44:30 ts28 Waking error handler thread
Jul 24 13:44:30 ts28 Error handler scsi_eh_2 waking up
Jul 24 13:44:30 ts28 scsi_eh_2: flush finish cmd: ffff8100d277a980
Jul 24 13:44:30 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 24 13:44:30 ts28 33 sectors total, 0 bytes done.
Jul 24 13:44:30 ts28 use_sg is 0
Jul 24 13:44:30 ts28 scsi_restart_operations: waking up host to restart
Jul 24 13:44:30 ts28 Error handler scsi_eh_2 sleeping
Jul 24 13:44:30 ts28 scsi_block_when_processing_errors: rtn: 1
Jul 24 13:44:30 ts28 scsi_add_timer: scmd: ffff8100d277a800, time: 30000, (ffffffff80382c14)
Jul 24 13:44:30 ts28 sr 2:0:0:0: Send: 0xffff8100d277a800 
Jul 24 13:44:30 ts28 sr 2:0:0:0: CDB: Read TOC/PMA/ATIP: 43 00 00 00 00 00 00 00 0c 40
Jul 24 13:44:30 ts28 buffer = 0xffff8100dea78980, bufflen = 12, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:30 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:30 ts28 scsi_delete_timer: scmd: ffff8100d277a800, rtn: 1
Jul 24 13:44:30 ts28 sr 2:0:0:0: Done: 0xffff8100d277a800 TIMEOUT
Jul 24 13:44:30 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:30 ts28 sr 2:0:0:0: CDB: Read TOC/PMA/ATIP: 43 00 00 00 00 00 00 00 0c 40
Jul 24 13:44:30 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:44:30 ts28 Waking error handler thread
Jul 24 13:44:30 ts28 Error handler scsi_eh_2 waking up
Jul 24 13:44:30 ts28 scsi_eh_2: flush finish cmd: ffff8100d277a800
Jul 24 13:44:30 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 24 13:44:30 ts28 0 sectors total, 12 bytes done.
Jul 24 13:44:30 ts28 use_sg is 1
Jul 24 13:44:30 ts28 scsi_restart_operations: waking up host to restart
Jul 24 13:44:30 ts28 Error handler scsi_eh_2 sleeping
Jul 24 13:44:30 ts28 scsi_block_when_processing_errors: rtn: 1
Jul 24 13:44:30 ts28 scsi_add_timer: scmd: ffff8100d277a200, time: 30000, (ffffffff80382c14)
Jul 24 13:44:30 ts28 sr 2:0:0:0: Send: 0xffff8100d277a200 
Jul 24 13:44:30 ts28 sr 2:0:0:0: CDB: Read TOC/PMA/ATIP: 43 00 00 00 00 00 00 00 0c 00
Jul 24 13:44:30 ts28 buffer = 0xffff8100dea78a80, bufflen = 12, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:30 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:30 ts28 scsi_delete_timer: scmd: ffff8100d277a200, rtn: 1
Jul 24 13:44:30 ts28 sr 2:0:0:0: Done: 0xffff8100d277a200 TIMEOUT
Jul 24 13:44:30 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:30 ts28 sr 2:0:0:0: CDB: Read TOC/PMA/ATIP: 43 00 00 00 00 00 00 00 0c 00
Jul 24 13:44:30 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:44:30 ts28 Waking error handler thread
Jul 24 13:44:30 ts28 Error handler scsi_eh_2 waking up
Jul 24 13:44:30 ts28 scsi_eh_2: flush finish cmd: ffff8100d277a200
Jul 24 13:44:30 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 24 13:44:30 ts28 0 sectors total, 12 bytes done.
Jul 24 13:44:30 ts28 use_sg is 1
Jul 24 13:44:30 ts28 scsi_restart_operations: waking up host to restart
Jul 24 13:44:30 ts28 scsi_add_timer: scmd: ffff8100d277ac80, time: 30000, (ffffffff80382c14)
Jul 24 13:44:30 ts28 sr 2:0:0:0: Send: 0xffff8100d277ac80 
Jul 24 13:44:30 ts28 sr 2:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
Jul 24 13:44:30 ts28 buffer = 0xffff8100dea78380, bufflen = 8, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:30 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:30 ts28 Error handler scsi_eh_2 sleeping
Jul 24 13:44:30 ts28 scsi_delete_timer: scmd: ffff8100d277ac80, rtn: 1
Jul 24 13:44:30 ts28 sr 2:0:0:0: Done: 0xffff8100d277ac80 TIMEOUT
Jul 24 13:44:30 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:30 ts28 sr 2:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
Jul 24 13:44:30 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:44:30 ts28 Waking error handler thread
Jul 24 13:44:30 ts28 Error handler scsi_eh_2 waking up
Jul 24 13:44:30 ts28 scsi_eh_2: flush finish cmd: ffff8100d277ac80
Jul 24 13:44:30 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 24 13:44:30 ts28 0 sectors total, 8 bytes done.
Jul 24 13:44:30 ts28 use_sg is 1
Jul 24 13:44:30 ts28 scsi_restart_operations: waking up host to restart
Jul 24 13:44:30 ts28 scsi_add_timer: scmd: ffff8100d277ab00, time: 30000, (ffffffff80382c14)
Jul 24 13:44:30 ts28 sr 2:0:0:0: Send: 0xffff8100d277ab00 
Jul 24 13:44:30 ts28 sr 2:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
Jul 24 13:44:30 ts28 buffer = 0xffff8100dea78c80, bufflen = 8, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:30 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:30 ts28 Error handler scsi_eh_2 sleeping
Jul 24 13:44:30 ts28 scsi_delete_timer: scmd: ffff8100d277ab00, rtn: 1
Jul 24 13:44:30 ts28 sr 2:0:0:0: Done: 0xffff8100d277ab00 TIMEOUT
Jul 24 13:44:30 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:30 ts28 sr 2:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
Jul 24 13:44:30 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:44:30 ts28 Waking error handler thread
Jul 24 13:44:30 ts28 Error handler scsi_eh_2 waking up
Jul 24 13:44:30 ts28 scsi_eh_2: flush finish cmd: ffff8100d277ab00
Jul 24 13:44:30 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 24 13:44:30 ts28 0 sectors total, 8 bytes done.
Jul 24 13:44:30 ts28 use_sg is 1
Jul 24 13:44:30 ts28 scsi_restart_operations: waking up host to restart
Jul 24 13:44:30 ts28 scsi_add_timer: scmd: ffff8100d277ae00, time: 30000, (ffffffff80382c14)
Jul 24 13:44:30 ts28 sr 2:0:0:0: Send: 0xffff8100d277ae00 
Jul 24 13:44:30 ts28 sr 2:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
Jul 24 13:44:30 ts28 buffer = 0xffff8100dea78280, bufflen = 8, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:30 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:30 ts28 Error handler scsi_eh_2 sleeping
Jul 24 13:44:30 ts28 scsi_delete_timer: scmd: ffff8100d277ae00, rtn: 1
Jul 24 13:44:30 ts28 sr 2:0:0:0: Done: 0xffff8100d277ae00 TIMEOUT
Jul 24 13:44:30 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:30 ts28 sr 2:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00 00 00 00
Jul 24 13:44:30 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:44:30 ts28 Waking error handler thread
Jul 24 13:44:30 ts28 Error handler scsi_eh_2 waking up
Jul 24 13:44:30 ts28 scsi_eh_2: flush finish cmd: ffff8100d277ae00
Jul 24 13:44:30 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 8000002)
Jul 24 13:44:30 ts28 0 sectors total, 8 bytes done.
Jul 24 13:44:30 ts28 use_sg is 1
Jul 24 13:44:30 ts28 scsi_restart_operations: waking up host to restart
Jul 24 13:44:30 ts28 Error handler scsi_eh_2 sleeping
Jul 24 13:44:30 ts28 scsi_block_when_processing_errors: rtn: 1
Jul 24 13:44:30 ts28 scsi_block_when_processing_errors: rtn: 1
Jul 24 13:44:30 ts28 scsi_add_timer: scmd: ffff8100d277a680, time: 10000, (ffffffff80382c14)
Jul 24 13:44:30 ts28 sr 2:0:0:0: Send: 0xffff8100d277a680 
Jul 24 13:44:30 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 ec 00
Jul 24 13:44:30 ts28 buffer = 0xffff8100dea78080, bufflen = 512, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:30 ts28 scsi_delete_timer: scmd: ffff8100d277a680, rtn: 1
Jul 24 13:44:30 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:30 ts28 sr 2:0:0:0: Done: 0xffff8100d277a680 RETRY
Jul 24 13:44:30 ts28 sr 2:0:0:0: Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:30 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 ec 00
Jul 24 13:44:30 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:44:30 ts28 Inserting command ffff8100d277a680 into mlqueue
Jul 24 13:44:31 ts28 scsi_add_timer: scmd: ffff8100d277a680, time: 10000, (ffffffff80382c14)
Jul 24 13:44:31 ts28 sr 2:0:0:0: Send: 0xffff8100d277a680 
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 ec 00
Jul 24 13:44:31 ts28 buffer = 0xffff8100dea78080, bufflen = 512, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:31 ts28 scsi_delete_timer: scmd: ffff8100d277a680, rtn: 1
Jul 24 13:44:31 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:31 ts28 sr 2:0:0:0: Done: 0xffff8100d277a680 RETRY
Jul 24 13:44:31 ts28 sr 2:0:0:0: Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 ec 00
Jul 24 13:44:31 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:44:31 ts28 Inserting command ffff8100d277a680 into mlqueue
Jul 24 13:44:31 ts28 scsi_add_timer: scmd: ffff8100d277a680, time: 10000, (ffffffff80382c14)
Jul 24 13:44:31 ts28 sr 2:0:0:0: Send: 0xffff8100d277a680 
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 ec 00
Jul 24 13:44:31 ts28 buffer = 0xffff8100dea78080, bufflen = 512, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:31 ts28 scsi_delete_timer: scmd: ffff8100d277a680, rtn: 1
Jul 24 13:44:31 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:31 ts28 sr 2:0:0:0: Done: 0xffff8100d277a680 RETRY
Jul 24 13:44:31 ts28 sr 2:0:0:0: Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 ec 00
Jul 24 13:44:31 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:44:31 ts28 
Jul 24 13:44:31 ts28 Inserting command ffff8100d277a680 into mlqueue
Jul 24 13:44:31 ts28 scsi_add_timer: scmd: ffff8100d277a680, time: 10000, (ffffffff80382c14)
Jul 24 13:44:31 ts28 sr 2:0:0:0: Send: 0xffff8100d277a680 
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 ec 00
Jul 24 13:44:31 ts28 buffer = 0xffff8100dea78080, bufflen = 512, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:31 ts28 scsi_delete_timer: scmd: ffff8100d277a680, rtn: 1
Jul 24 13:44:31 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:31 ts28 sr 2:0:0:0: Done: 0xffff8100d277a680 RETRY
Jul 24 13:44:31 ts28 sr 2:0:0:0: Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 ec 00
Jul 24 13:44:31 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:44:31 ts28 Inserting command ffff8100d277a680 into mlqueue
Jul 24 13:44:31 ts28 scsi_add_timer: scmd: ffff8100d277a680, time: 10000, (ffffffff80382c14)
Jul 24 13:44:31 ts28 sr 2:0:0:0: Send: 0xffff8100d277a680 
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 ec 00
Jul 24 13:44:31 ts28 buffer = 0xffff8100dea78080, bufflen = 512, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:31 ts28 scsi_delete_timer: scmd: ffff8100d277a680, rtn: 1
Jul 24 13:44:31 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:31 ts28 sr 2:0:0:0: Done: 0xffff8100d277a680 RETRY
Jul 24 13:44:31 ts28 sr 2:0:0:0: Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 ec 00
Jul 24 13:44:31 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:44:31 ts28 Inserting command ffff8100d277a680 into mlqueue
Jul 24 13:44:31 ts28 scsi_add_timer: scmd: ffff8100d277a680, time: 10000, (ffffffff80382c14)
Jul 24 13:44:31 ts28 sr 2:0:0:0: Send: 0xffff8100d277a680 
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 ec 00
Jul 24 13:44:31 ts28 buffer = 0xffff8100dea78080, bufflen = 512, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:31 ts28 scsi_delete_timer: scmd: ffff8100d277a680, rtn: 1
Jul 24 13:44:31 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:31 ts28 sr 2:0:0:0: Done: 0xffff8100d277a680 SUCCESS
Jul 24 13:44:31 ts28 sr 2:0:0:0: Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 ec 00
Jul 24 13:44:31 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:44:31 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 70000)
Jul 24 13:44:31 ts28 1 sectors total, 512 bytes done.
Jul 24 13:44:31 ts28 use_sg is 1
Jul 24 13:44:31 ts28 scsi_block_when_processing_errors: rtn: 1
Jul 24 13:44:31 ts28 scsi_block_when_processing_errors: rtn: 1
Jul 24 13:44:31 ts28 scsi_add_timer: scmd: ffff8100d277a680, time: 10000, (ffffffff80382c14)
Jul 24 13:44:31 ts28 sr 2:0:0:0: Send: 0xffff8100d277a680 
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 a1 00
Jul 24 13:44:31 ts28 buffer = 0xffff8100dea78080, bufflen = 512, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:31 ts28 scsi_delete_timer: scmd: ffff8100d277a680, rtn: 1
Jul 24 13:44:31 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:31 ts28 
Jul 24 13:44:31 ts28 sr 2:0:0:0: Done: 0xffff8100d277a680 RETRY
Jul 24 13:44:31 ts28 sr 2:0:0:0: Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 a1 00
Jul 24 13:44:31 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:44:31 ts28 Inserting command ffff8100d277a680 into mlqueue
Jul 24 13:44:31 ts28 scsi_add_timer: scmd: ffff8100d277a680, time: 10000, (ffffffff80382c14)
Jul 24 13:44:31 ts28 sr 2:0:0:0: Send: 0xffff8100d277a680 
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 a1 00
Jul 24 13:44:31 ts28 buffer = 0xffff8100dea78080, bufflen = 512, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:31 ts28 scsi_delete_timer: scmd: ffff8100d277a680, rtn: 1
Jul 24 13:44:31 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:31 ts28 sr 2:0:0:0: Done: 0xffff8100d277a680 RETRY
Jul 24 13:44:31 ts28 sr 2:0:0:0: Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 a1 00
Jul 24 13:44:31 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:44:31 ts28 
Jul 24 13:44:31 ts28 Inserting command ffff8100d277a680 into mlqueue
Jul 24 13:44:31 ts28 scsi_add_timer: scmd: ffff8100d277a680, time: 10000, (ffffffff80382c14)
Jul 24 13:44:31 ts28 sr 2:0:0:0: Send: 0xffff8100d277a680 
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 a1 00
Jul 24 13:44:31 ts28 buffer = 0xffff8100dea78080, bufflen = 512, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:31 ts28 scsi_delete_timer: scmd: ffff8100d277a680, rtn: 1
Jul 24 13:44:31 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:31 ts28 sr 2:0:0:0: Done: 0xffff8100d277a680 RETRY
Jul 24 13:44:31 ts28 sr 2:0:0:0: Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 a1 00
Jul 24 13:44:31 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:44:31 ts28 Inserting command ffff8100d277a680 into mlqueue
Jul 24 13:44:31 ts28 scsi_add_timer: scmd: ffff8100d277a680, time: 10000, (ffffffff80382c14)
Jul 24 13:44:31 ts28 sr 2:0:0:0: Send: 0xffff8100d277a680 
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 a1 00
Jul 24 13:44:31 ts28 buffer = 0xffff8100dea78080, bufflen = 512, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:31 ts28 scsi_delete_timer: scmd: ffff8100d277a680, rtn: 1
Jul 24 13:44:31 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:31 ts28 sr 2:0:0:0: Done: 0xffff8100d277a680 RETRY
Jul 24 13:44:31 ts28 sr 2:0:0:0: Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 a1 00
Jul 24 13:44:31 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:44:31 ts28 Inserting command ffff8100d277a680 into mlqueue
Jul 24 13:44:31 ts28 scsi_add_timer: scmd: ffff8100d277a680, time: 10000, (ffffffff80382c14)
Jul 24 13:44:31 ts28 sr 2:0:0:0: Send: 0xffff8100d277a680 
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 a1 00
Jul 24 13:44:31 ts28 buffer = 0xffff8100dea78080, bufflen = 512, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:31 ts28 scsi_delete_timer: scmd: ffff8100d277a680, rtn: 1
Jul 24 13:44:31 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:31 ts28 sr 2:0:0:0: Done: 0xffff8100d277a680 RETRY
Jul 24 13:44:31 ts28 
Jul 24 13:44:31 ts28 sr 2:0:0:0: Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 a1 00
Jul 24 13:44:31 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:44:31 ts28 Inserting command ffff8100d277a680 into mlqueue
Jul 24 13:44:31 ts28 scsi_add_timer: scmd: ffff8100d277a680, time: 10000, (ffffffff80382c14)
Jul 24 13:44:31 ts28 sr 2:0:0:0: Send: 0xffff8100d277a680 
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 a1 00
Jul 24 13:44:31 ts28 buffer = 0xffff8100dea78080, bufflen = 512, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:31 ts28 scsi_delete_timer: scmd: ffff8100d277a680, rtn: 1
Jul 24 13:44:31 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:31 ts28 sr 2:0:0:0: Done: 0xffff8100d277a680 SUCCESS
Jul 24 13:44:31 ts28 sr 2:0:0:0: Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: ATA command pass through(16): 85 08 0e 00 00 00 00 00 00 00 00 00 00 00 a1 00
Jul 24 13:44:31 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:44:31 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 70000)
Jul 24 13:44:31 ts28 1 sectors total, 512 bytes done.
Jul 24 13:44:31 ts28 use_sg is 1
Jul 24 13:44:31 ts28 cdrom: entering cdrom_release
Jul 24 13:44:31 ts28 cdrom: Use count for "/dev/sr0" now zero
Jul 24 13:44:31 ts28 cdrom: sr0: No DVD+RW
Jul 24 13:44:31 ts28 cdrom: Unlocking door!
Jul 24 13:44:31 ts28 Trying ioctl with scsi command 30
Jul 24 13:44:31 ts28 scsi_add_timer: scmd: ffff8100d277a680, time: 10000, (ffffffff80382c14)
Jul 24 13:44:31 ts28 sr 2:0:0:0: Send: 0xffff8100d277a680 
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: Prevent/Allow Medium Removal: 1e 00 00 00 00 00
Jul 24 13:44:31 ts28 buffer = 0x0000000000000000, bufflen = 0, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:31 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:31 ts28 scsi_delete_timer: scmd: ffff8100d277a680, rtn: 1
Jul 24 13:44:31 ts28 sr 2:0:0:0: Done: 0xffff8100d277a680 SUCCESS
Jul 24 13:44:31 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: Prevent/Allow Medium Removal: 1e 00 00 00 00 00
Jul 24 13:44:31 ts28 sr 2:0:0:0: scsi host busy 1 failed 0
Jul 24 13:44:31 ts28 sr 2:0:0:0: Notifying upper driver of completion (result 0)
Jul 24 13:44:31 ts28 1 sectors total, 0 bytes done.
Jul 24 13:44:31 ts28 use_sg is 0
Jul 24 13:44:31 ts28 
Jul 24 13:44:31 ts28 Ioctl returned  0x0
Jul 24 13:44:31 ts28 IOCTL Releasing command
Jul 24 13:44:31 ts28 cdrom: entering cdrom_open
Jul 24 13:44:31 ts28 scsi_block_when_processing_errors: rtn: 1
Jul 24 13:44:31 ts28 cdrom: Use count for "/dev/sr0" now 1
Jul 24 13:44:31 ts28 scsi_add_timer: scmd: ffff8100d277a680, time: 30000, (ffffffff80382c14)
Jul 24 13:44:31 ts28 sr 2:0:0:0: Send: 0xffff8100d277a680 
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Jul 24 13:44:31 ts28 buffer = 0x0000000000000000, bufflen = 0, done = 0xffffffff803856e5, queuecommand 0xffffffff80396bb2
Jul 24 13:44:31 ts28 leaving scsi_dispatch_cmnd()
Jul 24 13:44:31 ts28 scsi_delete_timer: scmd: ffff8100d277a680, rtn: 1
Jul 24 13:44:31 ts28 sr 2:0:0:0: Done: 0xffff8100d277a680 TIMEOUT
Jul 24 13:44:31 ts28 sr 2:0:0:0: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Jul 24 13:44:31 ts28 sr 2:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Jul 24 13:44:31 ts28 sr 2:0:0:0: scsi host busy 1 failed 0

--------------060209060102000109080600--
