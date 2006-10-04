From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: aic94xx IO errors with "escb_tasklet_complete: phy0: REQ_TASK_ABORT"
Date: Wed, 4 Oct 2006 18:44:38 +0200
Message-ID: <20061004164438.GC5091@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:21330 "EHLO
	mtagate3.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1161587AbWJDQop (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Oct 2006 12:44:45 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate3.uk.ibm.com (8.13.8/8.13.8) with ESMTP id k94GihdM061666
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 17:44:43 +0100
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k94Gl52n1921094
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 17:47:05 +0100
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k94GigGR005084
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 17:44:42 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>

[resending as it probably hit the 100K limit the first time]

I'm seeing these aic94xx IO errors on an IBM x366, usually after I
copy ~20GB but occasionally as soon as heavy IO starts. Happens with
and without Calgary enabled (iommu=off). I'm seeing this on two
different disks which badblocks claims are ok. The machine usually
stays up and keeps chugging along after this happens.

I also have an older version of aic94xx in a Xen dom0 kernel
(2.6.16.29 based) with an older firmware version which works
fine. I'll try and narrow the differences down.

bad: 2.6.18-git + firmware version V17/10c6 using request_firmware
good: 2.6.16.29-xen + firmware version Razor_10a1 inline in the driver

boot.msg and /var/log/messages are inline.

boot.msg:

klogd 1.4.1, log source = ksyslog started.
<5>Linux version 2.6.18mx (muli@rhun) (gcc version 3.4.1) #122 SMP Sat Sep 30 12:56:19 IDT 2006
<6>Command line: root=/dev/sdb2 console=tty0 console=ttyS1,19200 iommu=off
<6>BIOS-provided physical RAM map:
<4> BIOS-e820: 0000000000000000 - 0000000000099000 (usable)
<4> BIOS-e820: 0000000000099000 - 00000000000a0000 (reserved)
<4> BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
<4> BIOS-e820: 0000000000100000 - 00000000e7f9c640 (usable)
<4> BIOS-e820: 00000000e7f9c640 - 00000000e7fa6a40 (ACPI data)
<4> BIOS-e820: 00000000e7fa6a40 - 00000000e8000000 (reserved)
<4> BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
<4> BIOS-e820: 0000000100000000 - 0000000198000000 (usable)
<7>Entering add_active_range(0, 0, 153) 0 entries of 256 used
<7>Entering add_active_range(0, 256, 950172) 1 entries of 256 used
<7>Entering add_active_range(0, 1048576, 1671168) 2 entries of 256 used
<4>end_pfn_map = 1671168
<6>DMI 2.3 present.
<7>ACPI: RSDP (v000 IBM                                   ) @ 0x00000000000fdcf0
<7>ACPI: RSDT (v001 IBM    EXA01ZEU 0x00001000 IBM  0x45444f43) @ 0x00000000e7fa69c0
<7>ACPI: FADT (v001 IBM    EXA01ZEU 0x00001000 IBM  0x45444f43) @ 0x00000000e7fa6940
<7>ACPI: MADT (v001 IBM    EXA01ZEU 0x00001000 IBM  0x45444f43) @ 0x00000000e7fa6880
<7>ACPI: SRAT (v001 IBM    EXA01ZEU 0x00001000 IBM  0x45444f43) @ 0x00000000e7fa67c0
<7>ACPI: SSDT (v001 IBM    VIGSSDT0 0x00001000 INTL 0x20030122) @ 0x00000000e7f9f440
<7>ACPI: DSDT (v001 IBM    SER01ZEU 0x00001000 INTL 0x20030122) @ 0x0000000000000000
<7>Entering add_active_range(0, 0, 153) 0 entries of 256 used
<7>Entering add_active_range(0, 256, 950172) 1 entries of 256 used
<7>Entering add_active_range(0, 1048576, 1671168) 2 entries of 256 used
<4>Zone PFN ranges:
<4>  DMA             0 ->     4096
<4>  DMA32        4096 ->  1048576
<4>  Normal    1048576 ->  1671168
<4>early_node_map[3] active PFN ranges
<4>    0:        0 ->      153
<4>    0:      256 ->   950172
<4>    0:  1048576 ->  1671168
<7>On node 0 totalpages: 1572661
<7>  DMA zone: 88 pages used for memmap
<7>  DMA zone: 2747 pages reserved
<7>  DMA zone: 1158 pages, LIFO batch:0
<7>  DMA32 zone: 22440 pages used for memmap
<7>  DMA32 zone: 923636 pages, LIFO batch:31
<7>  Normal zone: 13376 pages used for memmap
<7>  Normal zone: 609216 pages, LIFO batch:31
<6>ACPI: PM-Timer IO Port: 0x9c
<7>ACPI: Local APIC address 0xfee00000
<6>ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
<6>Processor #0 (Bootup-CPU)
<6>ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
<6>Processor #1
<6>ACPI: LAPIC (acpi_id[0x02] lapic_id[0x06] enabled)
<6>Processor #6
<6>ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
<6>Processor #7
<6>ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
<6>ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
<6>ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
<6>ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
<6>ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[0])
<6>IOAPIC[0]: apic_id 15, address 0xfec00000, GSI 0-35
<6>ACPI: IOAPIC (id[0x0e] address[0xfec01000] gsi_base[35])
<6>IOAPIC[1]: apic_id 14, address 0xfec01000, GSI 35-70
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 8 global_irq 8 low edge)
<6>ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 low edge)
<7>ACPI: IRQ0 used by override.
<7>ACPI: IRQ2 used by override.
<7>ACPI: IRQ8 used by override.
<7>ACPI: IRQ9 used by override.
<7>ACPI: IRQ14 used by override.
<6>Setting APIC routing to flat
<6>Using ACPI (MADT) for SMP configuration information
<4>Nosave address range: 0000000000099000 - 00000000000a0000
<4>Nosave address range: 00000000000a0000 - 00000000000e0000
<4>Nosave address range: 00000000000e0000 - 0000000000100000
<4>Nosave address range: 00000000e7f9c000 - 00000000e7f9d000
<4>Nosave address range: 00000000e7f9d000 - 00000000e7fa6000
<4>Nosave address range: 00000000e7fa6000 - 00000000e7fa7000
<4>Nosave address range: 00000000e7fa7000 - 00000000e8000000
<4>Nosave address range: 00000000e8000000 - 00000000fec00000
<4>Nosave address range: 00000000fec00000 - 0000000100000000
<6>Allocating PCI resources starting at ea000000 (gap: e8000000:16c00000)
<6>PERCPU: Allocating 32128 bytes of per cpu data
<4>Built 1 zonelists.  Total pages: 1534010
<5>Kernel command line: root=/dev/sdb2 console=tty0 console=ttyS1,19200 iommu=off
<4>Initializing CPU#0
<4>PID hash table entries: 4096 (order: 12, 32768 bytes)
<4>Console: colour VGA+ 80x25
<4>Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
<4>... MAX_LOCKDEP_SUBCLASSES:    8
<4>... MAX_LOCK_DEPTH:          30
<4>... MAX_LOCKDEP_KEYS:        2048
<4>... CLASSHASH_SIZE:           1024
<4>... MAX_LOCKDEP_ENTRIES:     8192
<4>... MAX_LOCKDEP_CHAINS:      8192
<4>... CHAINHASH_SIZE:          4096
<4> memory used by lock dependency info: 1328 kB
<4> per task-struct memory footprint: 1680 bytes
<4>Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
<4>Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
<4>Checking aperture...
<4>Memory: 6120856k/6684672k available (3950k kernel code, 169284k reserved, 2793k data, 276k init)
<4>Calibrating delay using timer specific routine.. 6346.63 BogoMIPS (lpj=12693267)
<4>Mount-cache hash table entries: 256
<6>CPU: Trace cache: 12K uops, L1 D cache: 16K
<6>CPU: L2 cache: 1024K
<4>using mwait in idle threads.
<6>CPU: Physical Processor ID: 0
<6>CPU: Processor Core ID: 0
<6>CPU0: Thermal monitoring enabled (TM1)
<6>Freeing SMP alternatives: 36k freed
<6>ACPI: Core revision 20060707
<3>..MP-BIOS bug: 8254 timer not connected to IO-APIC
<6>Using local APIC timer interrupts.
<4>result 10425626
<6>Detected 10.425 MHz APIC timer.
<4>lockdep: not fixing up alternatives.
<6>Booting processor 1/4 APIC 0x1
<4>Initializing CPU#1
<4>Calibrating delay using timer specific routine.. 6339.08 BogoMIPS (lpj=12678162)
<6>CPU: Trace cache: 12K uops, L1 D cache: 16K
<6>CPU: L2 cache: 1024K
<6>CPU: Physical Processor ID: 0
<6>CPU: Processor Core ID: 0
<6>CPU1: Thermal monitoring enabled (TM1)
<4>               Intel(R) Xeon(TM) MP CPU 3.16GHz stepping 01
<4>lockdep: not fixing up alternatives.
<6>Booting processor 2/4 APIC 0x6
<4>Initializing CPU#2
<4>Calibrating delay using timer specific routine.. 6339.22 BogoMIPS (lpj=12678446)
<6>CPU: Trace cache: 12K uops, L1 D cache: 16K
<6>CPU: L2 cache: 1024K
<6>CPU: Physical Processor ID: 3
<6>CPU: Processor Core ID: 0
<6>CPU2: Thermal monitoring enabled (TM1)
<4>              Intel(R) Pentium(R) 4 CPU 3.16GHz stepping 09
<4>lockdep: not fixing up alternatives.
<6>Booting processor 3/4 APIC 0x7
<4>Initializing CPU#3
<4>Calibrating delay using timer specific routine.. 6339.31 BogoMIPS (lpj=12678628)
<6>CPU: Trace cache: 12K uops, L1 D cache: 16K
<6>CPU: L2 cache: 1024K
<6>CPU: Physical Processor ID: 3
<6>CPU: Processor Core ID: 0
<6>CPU3: Thermal monitoring enabled (TM1)
<4>              Intel(R) Pentium(R) 4 CPU 3.16GHz stepping 09
<6>Brought up 4 CPUs
<6>testing NMI watchdog ... OK.
<6>time.c: Using 3.579545 MHz WALL PM GTOD PIT/TSC timer.
<6>time.c: Detected 3169.417 MHz processor.
<4>migration_cost=9,718
<6>checking if image is initramfs... it is
<6>Freeing initrd memory: 1728k freed
<6>NET: Registered protocol family 16
<6>ACPI: bus type pci registered
<6>PCI: Using configuration type 1
<6>ACPI: Interpreter enabled
<6>ACPI: Using IOAPIC for interrupt routing
<6>ACPI: PCI Root Bridge [VP00] (0000:00)
<7>PCI: Probing PCI hardware (bus 00)
<7>PCI: Scanning bus 0000:00
<7>PCI: Found 0000:00:00.0 [1014/02a1] 000600 00
<7>PCI: Calling quirk ffffffff8037c336 for 0000:00:00.0
<7>PCI: Calling quirk ffffffff804ec977 for 0000:00:00.0
<7>PCI: Calling quirk ffffffff804ec654 for 0000:00:00.0
<7>PCI: Found 0000:00:01.0 [1002/5159] 000300 00
<7>PCI: Calling quirk ffffffff8037c336 for 0000:00:01.0
<7>PCI: Calling quirk ffffffff804ec977 for 0000:00:01.0
<7>Boot video device is 0000:00:01.0
<7>PCI: Calling quirk ffffffff804ec654 for 0000:00:01.0
<7>PCI: Found 0000:00:03.0 [1033/0035] 000c03 00
<7>PCI: Calling quirk ffffffff8037c336 for 0000:00:03.0
<7>PCI: Calling quirk ffffffff804ec977 for 0000:00:03.0
<7>PCI: Calling quirk ffffffff804ec654 for 0000:00:03.0
<7>PCI: Found 0000:00:03.1 [1033/0035] 000c03 00
<7>PCI: Calling quirk ffffffff8037c336 for 0000:00:03.1
<7>PCI: Calling quirk ffffffff804ec977 for 0000:00:03.1
<7>PCI: Calling quirk ffffffff804ec654 for 0000:00:03.1
<7>PCI: Found 0000:00:03.2 [1033/00e0] 000c03 00
<7>PCI: Calling quirk ffffffff8037c336 for 0000:00:03.2
<7>PCI: Calling quirk ffffffff804ec977 for 0000:00:03.2
<7>PCI: Calling quirk ffffffff804ec654 for 0000:00:03.2
<7>PCI: Found 0000:00:0f.0 [1166/0203] 000600 00
<7>PCI: Calling quirk ffffffff8037c336 for 0000:00:0f.0
<7>PCI: Calling quirk ffffffff804ec977 for 0000:00:0f.0
<7>PCI: Calling quirk ffffffff804ec654 for 0000:00:0f.0
<7>PCI: Found 0000:00:0f.1 [1166/0213] 000101 00
<7>PCI: Calling quirk ffffffff8037c336 for 0000:00:0f.1
<6>PCI: Ignoring BAR0-3 of IDE controller 0000:00:0f.1
<7>PCI: Calling quirk ffffffff804ec977 for 0000:00:0f.1
<7>PCI: Calling quirk ffffffff804ec654 for 0000:00:0f.1
<7>PCI: Found 0000:00:0f.3 [1166/0227] 000601 00
<7>PCI: Calling quirk ffffffff8037c336 for 0000:00:0f.3
<7>PCI: Calling quirk ffffffff804ec977 for 0000:00:0f.3
<7>PCI: Calling quirk ffffffff804ec654 for 0000:00:0f.3
<7>PCI: Fixups for bus 0000:00
<7>PCI: Bus scan for 0000:00 returning with max=00
<7>ACPI: PCI Interrupt Routing Table [\_SB_.VP00._PRT]
<6>ACPI: PCI Root Bridge [VP01] (0000:01)
<7>PCI: Probing PCI hardware (bus 01)
<7>PCI: Scanning bus 0000:01
<7>PCI: Found 0000:01:00.0 [1014/02a1] 000600 00
<7>PCI: Calling quirk ffffffff8037c336 for 0000:01:00.0
<7>PCI: Calling quirk ffffffff804ec977 for 0000:01:00.0
<7>PCI: Calling quirk ffffffff804ec654 for 0000:01:00.0
<7>PCI: Found 0000:01:01.0 [14e4/1648] 000200 00
<7>PCI: Calling quirk ffffffff8037c336 for 0000:01:01.0
<7>PCI: Calling quirk ffffffff804ec977 for 0000:01:01.0
<7>PCI: Calling quirk ffffffff804ec654 for 0000:01:01.0
<7>PCI: Found 0000:01:01.1 [14e4/1648] 000200 00
<7>PCI: Calling quirk ffffffff8037c336 for 0000:01:01.1
<7>PCI: Calling quirk ffffffff804ec977 for 0000:01:01.1
<7>PCI: Calling quirk ffffffff804ec654 for 0000:01:01.1
<7>PCI: Found 0000:01:02.0 [9005/041e] 000100 00
<7>PCI: Calling quirk ffffffff8037c336 for 0000:01:02.0
<7>PCI: Calling quirk ffffffff804ec977 for 0000:01:02.0
<7>PCI: Calling quirk ffffffff804ec654 for 0000:01:02.0
<7>PCI: Fixups for bus 0000:01
<7>PCI: Bus scan for 0000:01 returning with max=01
<7>ACPI: PCI Interrupt Routing Table [\_SB_.VP01._PRT]
<6>ACPI: PCI Root Bridge [VP02] (0000:02)
<7>PCI: Probing PCI hardware (bus 02)
<7>PCI: Scanning bus 0000:02
<7>PCI: Found 0000:02:00.0 [1014/02a1] 000600 00
<7>PCI: Calling quirk ffffffff8037c336 for 0000:02:00.0
<7>PCI: Calling quirk ffffffff804ec977 for 0000:02:00.0
<7>PCI: Calling quirk ffffffff804ec654 for 0000:02:00.0
<7>PCI: Found 0000:02:01.0 [10b7/9200] 000200 00
<7>PCI: Calling quirk ffffffff8037c336 for 0000:02:01.0
<7>PCI: Calling quirk ffffffff804ec977 for 0000:02:01.0
<7>PCI: Calling quirk ffffffff804ec654 for 0000:02:01.0
<7>PCI: Fixups for bus 0000:02
<7>PCI: Bus scan for 0000:02 returning with max=02
<7>ACPI: PCI Interrupt Routing Table [\_SB_.VP02._PRT]
<6>ACPI: PCI Root Bridge [VP03] (0000:04)
<7>PCI: Probing PCI hardware (bus 04)
<7>PCI: Scanning bus 0000:04
<7>PCI: Found 0000:04:00.0 [1014/02a1] 000600 00
<7>PCI: Calling quirk ffffffff8037c336 for 0000:04:00.0
<7>PCI: Calling quirk ffffffff804ec977 for 0000:04:00.0
<7>PCI: Calling quirk ffffffff804ec654 for 0000:04:00.0
<7>PCI: Fixups for bus 0000:04
<7>PCI: Bus scan for 0000:04 returning with max=04
<7>ACPI: PCI Interrupt Routing Table [\_SB_.VP03._PRT]
<6>ACPI: PCI Root Bridge [VP04] (0000:06)
<7>PCI: Probing PCI hardware (bus 06)
<7>PCI: Scanning bus 0000:06
<7>PCI: Found 0000:06:00.0 [1014/02a1] 000600 00
<7>PCI: Calling quirk ffffffff8037c336 for 0000:06:00.0
<7>PCI: Calling quirk ffffffff804ec977 for 0000:06:00.0
<7>PCI: Calling quirk ffffffff804ec654 for 0000:06:00.0
<7>PCI: Fixups for bus 0000:06
<7>PCI: Bus scan for 0000:06 returning with max=06
<7>ACPI: PCI Interrupt Routing Table [\_SB_.VP04._PRT]
<6>ACPI: PCI Root Bridge [VP05] (0000:08)
<7>PCI: Probing PCI hardware (bus 08)
<7>PCI: Scanning bus 0000:08
<7>PCI: Found 0000:08:00.0 [1014/02a1] 000600 00
<7>PCI: Calling quirk ffffffff8037c336 for 0000:08:00.0
<7>PCI: Calling quirk ffffffff804ec977 for 0000:08:00.0
<7>PCI: Calling quirk ffffffff804ec654 for 0000:08:00.0
<7>PCI: Fixups for bus 0000:08
<7>PCI: Bus scan for 0000:08 returning with max=08
<7>ACPI: PCI Interrupt Routing Table [\_SB_.VP05._PRT]
<6>ACPI: PCI Root Bridge [VP06] (0000:0a)
<7>PCI: Probing PCI hardware (bus 0a)
<7>PCI: Scanning bus 0000:0a
<7>PCI: Found 0000:0a:00.0 [1014/02a1] 000600 00
<7>PCI: Calling quirk ffffffff8037c336 for 0000:0a:00.0
<7>PCI: Calling quirk ffffffff804ec977 for 0000:0a:00.0
<7>PCI: Calling quirk ffffffff804ec654 for 0000:0a:00.0
<7>PCI: Fixups for bus 0000:0a
<7>PCI: Bus scan for 0000:0a returning with max=0a
<7>ACPI: PCI Interrupt Routing Table [\_SB_.VP06._PRT]
<6>ACPI: PCI Root Bridge [VP07] (0000:0c)
<7>Losing some ticks... checking if CPU frequency changed.
<7>PCI: Probing PCI hardware (bus 0c)
<7>PCI: Scanning bus 0000:0c
<7>PCI: Found 0000:0c:00.0 [1014/02a1] 000600 00
<7>PCI: Calling quirk ffffffff8037c336 for 0000:0c:00.0
<7>PCI: Calling quirk ffffffff804ec977 for 0000:0c:00.0
<7>PCI: Calling quirk ffffffff804ec654 for 0000:0c:00.0
<7>PCI: Fixups for bus 0000:0c
<7>PCI: Bus scan for 0000:0c returning with max=0c
<7>ACPI: PCI Interrupt Routing Table [\_SB_.VP07._PRT]
<5>SCSI subsystem initialized
<6>usbcore: registered new interface driver usbfs
<6>usbcore: registered new interface driver hub
<6>usbcore: registered new device driver usb
<6>PCI: Using ACPI for IRQ routing
<6>PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
<6>PCI-GART: No AMD northbridge found.
<7>  got res [f0000000:f001ffff] bus [f0000000:f001ffff] flags 7202 for BAR 6 of 0000:00:01.0
<7>  got res [f0080000:f00fffff] bus [f0080000:f00fffff] flags 7200 for BAR 6 of 0000:01:02.0
<7>  got res [f0020000:f003ffff] bus [f0020000:f003ffff] flags 7200 for BAR 6 of 0000:02:01.0
<6>NET: Registered protocol family 2
<4>IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
<4>TCP established hash table entries: 65536 (order: 9, 3670016 bytes)
<4>TCP bind hash table entries: 32768 (order: 8, 1835008 bytes)
<6>TCP: Hash tables configured (established 65536 bind 32768)
<6>TCP reno registered
<6>IA-32 Microcode Update Driver: v1.14a <tigran@veritas.com>
<4>Total HugeTLB memory allocated, 0
<6>Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
<6>io scheduler noop registered
<6>io scheduler anticipatory registered (default)
<6>io scheduler deadline registered
<6>io scheduler cfq registered
<7>PCI: Calling quirk ffffffff8037c257 for 0000:00:00.0
<7>PCI: Calling quirk ffffffff80491872 for 0000:00:00.0
<7>PCI: Calling quirk ffffffff8037c257 for 0000:00:01.0
<7>PCI: Calling quirk ffffffff80491872 for 0000:00:01.0
<7>PCI: Calling quirk ffffffff8037c257 for 0000:00:03.0
<7>PCI: Calling quirk ffffffff80491872 for 0000:00:03.0
<7>PCI: Calling quirk ffffffff8037c257 for 0000:00:03.1
<7>PCI: Calling quirk ffffffff80491872 for 0000:00:03.1
<7>PCI: Calling quirk ffffffff8037c257 for 0000:00:03.2
<7>PCI: Calling quirk ffffffff80491872 for 0000:00:03.2
<7>PCI: Calling quirk ffffffff8037c257 for 0000:00:0f.0
<7>PCI: Calling quirk ffffffff80491872 for 0000:00:0f.0
<7>PCI: Calling quirk ffffffff8037c257 for 0000:00:0f.1
<7>PCI: Calling quirk ffffffff80491872 for 0000:00:0f.1
<7>PCI: Calling quirk ffffffff8037c257 for 0000:00:0f.3
<7>PCI: Calling quirk ffffffff80491872 for 0000:00:0f.3
<7>PCI: Calling quirk ffffffff8037c257 for 0000:01:00.0
<7>PCI: Calling quirk ffffffff80491872 for 0000:01:00.0
<7>PCI: Calling quirk ffffffff8037c257 for 0000:01:01.0
<7>PCI: Calling quirk ffffffff80491872 for 0000:01:01.0
<7>PCI: Calling quirk ffffffff8037c257 for 0000:01:01.1
<7>PCI: Calling quirk ffffffff80491872 for 0000:01:01.1
<7>PCI: Calling quirk ffffffff8037c257 for 0000:01:02.0
<7>PCI: Calling quirk ffffffff80491872 for 0000:01:02.0
<7>PCI: Calling quirk ffffffff8037c257 for 0000:02:00.0
<7>PCI: Calling quirk ffffffff80491872 for 0000:02:00.0
<7>PCI: Calling quirk ffffffff8037c257 for 0000:02:01.0
<7>PCI: Calling quirk ffffffff80491872 for 0000:02:01.0
<7>PCI: Calling quirk ffffffff8037c257 for 0000:04:00.0
<7>PCI: Calling quirk ffffffff80491872 for 0000:04:00.0
<7>PCI: Calling quirk ffffffff8037c257 for 0000:06:00.0
<7>PCI: Calling quirk ffffffff80491872 for 0000:06:00.0
<7>PCI: Calling quirk ffffffff8037c257 for 0000:08:00.0
<7>PCI: Calling quirk ffffffff80491872 for 0000:08:00.0
<7>PCI: Calling quirk ffffffff8037c257 for 0000:0a:00.0
<7>PCI: Calling quirk ffffffff80491872 for 0000:0a:00.0
<7>PCI: Calling quirk ffffffff8037c257 for 0000:0c:00.0
<7>PCI: Calling quirk ffffffff80491872 for 0000:0c:00.0
<6>GSI 16 sharing vector 0xA9 and IRQ 16
<6>ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
<6>radeonfb: Found Intel x86 BIOS ROM Image
<6>radeonfb: Retrieved PLL infos from BIOS
<4>radeonfb: Reference=27.00 MHz (RefDiv=60) Memory=143.00 Mhz, System=143.00 MHz
<4>radeonfb: PLL min 12000 max 35000
<6>radeonfb: Monitor 1 type DFP found
<6>radeonfb: EDID probed
<6>radeonfb: Monitor 2 type CRT found
<4>Console: switching to colour frame buffer device 128x48
<4>radeonfb (0000:00:01.0): ATI Radeon QY 
<6>tridentfb: Trident framebuffer 0.7.8-NEWAPI initializing
<6>hgafb: HGA card not detected.
<4>hgafb: probe of hgafb.0 failed with error -22
<7>vga16fb: initializing
<6>vga16fb: mapped to 0xffff8100000a0000
<6>fb1: VGA16 VGA frame buffer device
<6>fb2: Virtual frame buffer device, using 1024K of video memory
<6>ACPI: Power Button (FF) [PWRF]
<3>ibm_acpi: ec object not found
<6>Linux agpgart interface v0.101 (c) Dave Jones
<6>ipmi message handler version 39.0
<6>ipmi device interface
<4>Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
<4>Hangcheck: Using monotonic_clock().
<6>Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
<6>serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
<4>RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
<6>loop: loaded (max 8 devices)
<6>ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
<6>GSI 17 sharing vector 0xB1 and IRQ 17
<6>ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 18 (level, low) -> IRQ 17
<4>3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
<6>0000:02:01.0: 3Com PCI 3c905C Tornado at ffffc20000042000.
<6>tg3.c:v3.65 (August 07, 2006)
<6>GSI 18 sharing vector 0xB9 and IRQ 18
<6>ACPI: PCI Interrupt 0000:01:01.0[A] -> GSI 24 (level, low) -> IRQ 18
<7>PCI: Enabling bus mastering for device 0000:01:01.0
<6>eth1: Tigon3 [partno(BCM95704A6) rev 2100 PHY(5704)] (PCIX:66MHz:64-bit) 10/100/1000BaseT Ethernet 00:0d:60:98:74:22
<6>eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] Split[0] WireSpeed[1] TSOcap[0] 
<6>eth1: dma_rwctrl[769f0000] dma_mask[64-bit]
<6>GSI 19 sharing vector 0xC1 and IRQ 19
<6>ACPI: PCI Interrupt 0000:01:01.1[B] -> GSI 28 (level, low) -> IRQ 19
<7>PCI: Enabling bus mastering for device 0000:01:01.1
<6>eth2: Tigon3 [partno(BCM95704A6) rev 2100 PHY(5704)] (PCIX:66MHz:64-bit) 10/100/1000BaseT Ethernet 00:0d:60:98:74:23
<6>eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TSOcap[1] 
<6>eth2: dma_rwctrl[769f0000] dma_mask[64-bit]
<6>Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
<6>ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
<6>SvrWks CSB6: IDE controller at PCI slot 0000:00:0f.1
<6>SvrWks CSB6: chipset revision 160
<6>SvrWks CSB6: not 100%% native mode: will probe irqs later
<6>    ide0: BM-DMA at 0x0700-0x0707, BIOS settings: hda:DMA, hdb:DMA
<6>SvrWks CSB6: simplex device: DMA disabled
<6>ide1: SvrWks CSB6 Bus-Master DMA disabled (BIOS)
<7>Probing IDE interface ide0...
<4>hda: HL-DT-STDVD-ROM GDR8082N, ATAPI CD/DVD-ROM drive
<4>ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
<7>Probing IDE interface ide1...
<6>hda: ATAPI 24X DVD-ROM drive, 256kB Cache
<6>Uniform CD-ROM driver Revision: 3.20
<5>usbmon: debugfs is not available
<7>ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
<7>ohci_hcd: block sizes: ed 80 td 96
<6>GSI 20 sharing vector 0xC9 and IRQ 20
<6>ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 20 (level, low) -> IRQ 20
<6>ohci_hcd 0000:00:03.0: OHCI Host Controller
<6>ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 1
<7>ohci_hcd 0000:00:03.0: created debug files
<6>ohci_hcd 0000:00:03.0: irq 20, io mem 0xf2c10000
<7>ohci_hcd 0000:00:03.0: resetting from state 'reset', control = 0x0
<7>ohci_hcd 0000:00:03.0: OHCI controller state
<7>ohci_hcd 0000:00:03.0: OHCI 1.0, NO legacy support registers
<7>ohci_hcd 0000:00:03.0: control 0x083 HCFS=operational CBSR=3
<7>ohci_hcd 0000:00:03.0: cmdstatus 0x00000 SOC=0
<7>ohci_hcd 0000:00:03.0: intrstatus 0x00000004 SF
<7>ohci_hcd 0000:00:03.0: intrenable 0x8000005a MIE RHSC UE RD WDH
<7>ohci_hcd 0000:00:03.0: hcca frame #001f
<7>ohci_hcd 0000:00:03.0: roothub.a 0f000202 POTPGT=15 NPS NDP=2(2)
<7>ohci_hcd 0000:00:03.0: roothub.b 00000000 PPCM=0000 DR=0000
<7>ohci_hcd 0000:00:03.0: roothub.status 00008000 DRWE
<7>ohci_hcd 0000:00:03.0: roothub.portstatus [0] 0x00000100 PPS
<7>ohci_hcd 0000:00:03.0: roothub.portstatus [1] 0x00000100 PPS
<7>usb usb1: default language 0x0409
<7>usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>usb usb1: Product: OHCI Host Controller
<6>usb usb1: Manufacturer: Linux 2.6.18mx ohci_hcd
<6>usb usb1: SerialNumber: 0000:00:03.0
<7>usb usb1: uevent
<7>usb usb1: usb_probe_device
<6>usb usb1: configuration #1 chosen from 1 choice
<7>usb usb1: adding 1-0:1.0 (config #1, interface 0)
<7>usb 1-0:1.0: uevent
<7>hub 1-0:1.0: usb_probe_interface
<7>hub 1-0:1.0: usb_probe_interface - got id
<6>hub 1-0:1.0: USB hub found
<6>hub 1-0:1.0: 2 ports detected
<7>hub 1-0:1.0: standalone hub
<7>hub 1-0:1.0: no power switching (usb 1.0)
<7>hub 1-0:1.0: global over-current protection
<7>hub 1-0:1.0: power on to power good time: 30ms
<7>hub 1-0:1.0: local power source is good
<7>hub 1-0:1.0: no over-current condition exists
<7>hub 1-0:1.0: trying to enable port power on non-switchable hub
<7>hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
<6>ACPI: PCI Interrupt 0000:00:03.1[B] -> GSI 20 (level, low) -> IRQ 20
<6>ohci_hcd 0000:00:03.1: OHCI Host Controller
<6>ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 2
<7>ohci_hcd 0000:00:03.1: created debug files
<6>ohci_hcd 0000:00:03.1: irq 20, io mem 0xf2c11000
<7>ohci_hcd 0000:00:03.1: resetting from state 'reset', control = 0x0
<7>ohci_hcd 0000:00:03.1: OHCI controller state
<7>ohci_hcd 0000:00:03.1: OHCI 1.0, NO legacy support registers
<7>ohci_hcd 0000:00:03.1: control 0x083 HCFS=operational CBSR=3
<7>ohci_hcd 0000:00:03.1: cmdstatus 0x00000 SOC=0
<7>ohci_hcd 0000:00:03.1: intrstatus 0x00000004 SF
<7>ohci_hcd 0000:00:03.1: intrenable 0x8000005a MIE RHSC UE RD WDH
<7>ohci_hcd 0000:00:03.1: hcca frame #001f
<7>ohci_hcd 0000:00:03.1: roothub.a 0f000202 POTPGT=15 NPS NDP=2(2)
<7>ohci_hcd 0000:00:03.1: roothub.b 00000000 PPCM=0000 DR=0000
<7>ohci_hcd 0000:00:03.1: roothub.status 00008000 DRWE
<7>ohci_hcd 0000:00:03.1: roothub.portstatus [0] 0x00000100 PPS
<7>ohci_hcd 0000:00:03.1: roothub.portstatus [1] 0x00000100 PPS
<7>usb usb2: default language 0x0409
<7>usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>usb usb2: Product: OHCI Host Controller
<6>usb usb2: Manufacturer: Linux 2.6.18mx ohci_hcd
<6>usb usb2: SerialNumber: 0000:00:03.1
<7>usb usb2: uevent
<7>usb usb2: usb_probe_device
<6>usb usb2: configuration #1 chosen from 1 choice
<7>usb usb2: adding 2-0:1.0 (config #1, interface 0)
<7>usb 2-0:1.0: uevent
<7>hub 2-0:1.0: usb_probe_interface
<7>hub 2-0:1.0: usb_probe_interface - got id
<6>hub 2-0:1.0: USB hub found
<6>hub 2-0:1.0: 2 ports detected
<7>hub 2-0:1.0: standalone hub
<7>hub 2-0:1.0: no power switching (usb 1.0)
<7>hub 2-0:1.0: global over-current protection
<7>hub 2-0:1.0: power on to power good time: 30ms
<7>hub 2-0:1.0: local power source is good
<7>hub 2-0:1.0: no over-current condition exists
<7>hub 2-0:1.0: trying to enable port power on non-switchable hub
<7>hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
<6>USB Universal Host Controller Interface driver v3.0
<6>serio: i8042 AUX port at 0x60,0x64 irq 12
<6>serio: i8042 KBD port at 0x60,0x64 irq 1
<6>mice: PS/2 mouse device common for all mice
<6>ts: Compaq touchscreen protocol output
<6>input: PC Speaker as /class/input/input0
<6>input: AT Translated Set 2 keyboard as /class/input/input1
<6>i2c /dev entries driver
<4>i2c-parport: adapter type unspecified
<3>i2c_adapter i2c-9191: Driver w83781d-isa failed to attach adapter, unregistering
<3>i2c_adapter i2c-9191: Driver lm78-isa failed to attach adapter, unregistering
<7>ohci_hcd 0000:00:03.0: auto-stop root hub
<6>md: linear personality registered for level -1
<6>md: raid0 personality registered for level 0
<6>md: raid1 personality registered for level 1
<6>md: multipath personality registered for level -4
<6>md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
<6>md: bitmap version 4.39
<6>IBM TrackPoint firmware: 0x0b, buttons: 3/3
<6>input: TPPS/2 IBM TrackPoint as /class/input/input2
<7>ohci_hcd 0000:00:03.1: auto-stop root hub
<6>device-mapper: ioctl: 4.7.0-ioctl (2006-06-24) initialised: dm-devel@redhat.com
<6>device-mapper: multipath: version 1.0.4 loaded
<6>device-mapper: multipath round-robin: version 1.0.0 loaded
<6>device-mapper: multipath emc: version 0.0.3 loaded
<6>EDAC MC: Ver: 2.0.1 Sep 30 2006
<4>pktgen v2.67: Packet Generator for packet performance testing.
<4>u32 classifier
<4>    OLD policer on 
<6>IPv4 over IPv4 tunneling driver
<6>GRE over IPv4 tunneling driver
<6>TCP cubic registered
<6>Initializing XFRM netlink socket
<6>NET: Registered protocol family 1
<6>NET: Registered protocol family 10
<6>lo: Disabled Privacy Extensions
<6>IPv6 over IPv4 tunneling driver
<6>NET: Registered protocol family 17
<6>NET: Registered protocol family 15
<6>802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
<6>All bugs added by David S. Miller <davem@redhat.com>
<6>SCTP: Hash tables configured (established 37449 bind 37449)
<6>Freeing unused kernel memory: 276k freed
<5>aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.2 loaded
<6>GSI 21 sharing vector 0xD1 and IRQ 21
<6>ACPI: PCI Interrupt 0000:01:02.0[A] -> GSI 25 (level, low) -> IRQ 21
<5>aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:01:02.0
<6>scsi0 : aic94xx
<5>aic94xx: BIOS present (1,1), 1323
<5>aic94xx: ue num:2, ue size:88
<5>aic94xx: manuf sect SAS_ADDR 5005076a0112df00
<5>aic94xx: manuf sect PCBA SN 
<5>aic94xx: ms: num_phy_desc: 8
<5>aic94xx: ms: phy0: ENEBLEABLE
<5>aic94xx: ms: phy1: ENEBLEABLE
<5>aic94xx: ms: phy2: ENEBLEABLE
<5>aic94xx: ms: phy3: ENEBLEABLE
<5>aic94xx: ms: phy4: ENEBLEABLE
<5>aic94xx: ms: phy5: ENEBLEABLE
<5>aic94xx: ms: phy6: ENEBLEABLE
<5>aic94xx: ms: phy7: ENEBLEABLE
<5>aic94xx: ms: max_phys:0x8, num_phys:0x8
<5>aic94xx: ms: enabled_phys:0xff
<5>aic94xx: ctrla: phy0: sas_addr: 5005076a0112df00, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
<5>aic94xx: ctrla: phy1: sas_addr: 5005076a0112df00, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
<5>aic94xx: ctrla: phy2: sas_addr: 5005076a0112df00, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
<5>aic94xx: ctrla: phy3: sas_addr: 5005076a0112df00, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
<5>aic94xx: ctrla: phy4: sas_addr: 5005076a0112df00, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
<5>aic94xx: ctrla: phy5: sas_addr: 5005076a0112df00, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
<5>aic94xx: ctrla: phy6: sas_addr: 5005076a0112df00, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
<5>aic94xx: ctrla: phy7: sas_addr: 5005076a0112df00, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
<5>aic94xx: max_scbs:512, max_ddbs:128
<5>aic94xx: setting phy0 addr to 5005076a0112df00
<5>aic94xx: setting phy1 addr to 5005076a0112df00
<5>aic94xx: setting phy2 addr to 5005076a0112df00
<5>aic94xx: setting phy3 addr to 5005076a0112df00
<5>aic94xx: setting phy4 addr to 5005076a0112df00
<5>aic94xx: setting phy5 addr to 5005076a0112df00
<5>aic94xx: setting phy6 addr to 5005076a0112df00
<5>aic94xx: setting phy7 addr to 5005076a0112df00
<5>aic94xx: num_edbs:21
<5>aic94xx: num_escbs:3
<5>aic94xx: using sequencer V17/10c6
<5>aic94xx: downloading CSEQ...
<5>aic94xx: dma-ing 8192 bytes
<5>aic94xx: verified 8192 bytes, passed
<5>aic94xx: downloading LSEQs...
<5>aic94xx: dma-ing 14336 bytes
<5>aic94xx: LSEQ0 verified 14336 bytes, passed
<5>aic94xx: LSEQ1 verified 14336 bytes, passed
<5>aic94xx: LSEQ2 verified 14336 bytes, passed
<5>aic94xx: LSEQ3 verified 14336 bytes, passed
<5>aic94xx: LSEQ4 verified 14336 bytes, passed
<5>aic94xx: LSEQ5 verified 14336 bytes, passed
<5>aic94xx: LSEQ6 verified 14336 bytes, passed
<5>aic94xx: LSEQ7 verified 14336 bytes, passed
<5>aic94xx: max_scbs:446
<5>aic94xx: first_scb_site_no:0x20
<5>aic94xx: last_scb_site_no:0x1fe
<5>aic94xx: First SCB dma_handle: 0x196ab6000
<5>aic94xx: device 0000:01:02.0: SAS addr 5005076a0112df00, PCBA SN , 8 phys, 8 enabled phys, flash present, BIOS build 1323
<5>aic94xx: posting 3 escbs
<5>aic94xx: escbs posted
<5>aic94xx: posting 8 control phy scbs
<5>aic94xx: enabled phys
<5>aic94xx: control_phy_tasklet_complete: phy0, lrate:0x9, proto:0xe
<5>aic94xx: escb_tasklet_complete: phy0: BYTES_DMAED
<5>aic94xx: SAS proto IDENTIFY:
<5>aic94xx: 00: 10 00 00 08
<5>aic94xx: 04: 00 00 00 00
<5>aic94xx: 08: 00 00 00 00
<5>aic94xx: 0c: 50 00 c5 00
<5>aic94xx: 10: 00 32 f3 95
<5>aic94xx: 14: 00 00 00 00
<5>aic94xx: 18: 00 00 00 00
<5>aic94xx: control_phy_tasklet_complete: phy4, lrate:0x9, proto:0xe
<5>aic94xx: escb_tasklet_complete: phy4: BYTES_DMAED
<5>aic94xx: SAS proto IDENTIFY:
<5>aic94xx: 00: 10 00 00 08
<5>aic94xx: 04: 00 00 00 00
<5>aic94xx: 08: 00 00 00 00
<5>aic94xx: 0c: 50 00 c5 00
<5>aic94xx: 10: 00 32 f5 25
<5>aic94xx: 14: 00 00 00 00
<5>aic94xx: 18: 00 00 00 00
<5>sas: phy0 added to port0, phy_mask:0x1
<5>sas: phy4 added to port1, phy_mask:0x10
<5>sas: DOING DISCOVERY on port 0, pid:1126
<5>scsi 0:0:0:0: Direct-Access     IBM-ESXS ST936701SS    F  B512 PQ: 0 ANSI: 4
<5>aic94xx: control_phy_tasklet_complete: phy1: no device present: oob_status:0x0
<5>aic94xx: control_phy_tasklet_complete: phy2: no device present: oob_status:0x0
<5>aic94xx: control_phy_tasklet_complete: phy3: no device present: oob_status:0x0
<5>aic94xx: control_phy_tasklet_complete: phy5: no device present: oob_status:0x0
<5>aic94xx: control_phy_tasklet_complete: phy6: no device present: oob_status:0x0
<5>aic94xx: control_phy_tasklet_complete: phy7: no device present: oob_status:0x0
<5>SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
<5>sda: Write Protect is off
<7>sda: Mode Sense: bb 00 10 08
<5>SCSI device sda: drive cache: write through w/ FUA
<5>SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
<5>sda: Write Protect is off
<7>sda: Mode Sense: bb 00 10 08
<5>SCSI device sda: drive cache: write through w/ FUA
<6> sda: sda1 sda2
<5>sd 0:0:0:0: Attached scsi disk sda
<5>sd 0:0:0:0: Attached scsi generic sg0 type 0
<5>sas: DONE DISCOVERY on port 0, pid:1126, result:0
<5>sas: DOING DISCOVERY on port 1, pid:1126
<5>scsi 0:0:1:0: Direct-Access     IBM-ESXS ST936701SS    F  B512 PQ: 0 ANSI: 4
<5>SCSI device sdb: 71096640 512-byte hdwr sectors (36401 MB)
<5>sdb: Write Protect is off
<7>sdb: Mode Sense: bb 00 10 08
<5>SCSI device sdb: drive cache: write through w/ FUA
<5>SCSI device sdb: 71096640 512-byte hdwr sectors (36401 MB)
<5>sdb: Write Protect is off
<7>sdb: Mode Sense: bb 00 10 08
<5>SCSI device sdb: drive cache: write through w/ FUA
<6> sdb: sdb1 sdb2
<5>sd 0:0:1:0: Attached scsi disk sdb
<5>sd 0:0:1:0: Attached scsi generic sg1 type 0
<5>sas: DONE DISCOVERY on port 1, pid:1126, result:0
<6>kjournald starting.  Commit interval 5 seconds
<6>EXT3-fs: mounted filesystem with ordered data mode.
<6>warning: process `showconsole' used the removed sysctl system call
<6>Adding 1048552k swap on /dev/sda1.  Priority:42 extents:1 across:1048552k
<6>Adding 1048552k swap on /dev/sdb1.  Priority:42 extents:1 across:1048552k
<6>warning: process `showconsole' used the removed sysctl system call
<6>EXT3 FS on sdb2, internal journal
<6>md: Autodetecting RAID arrays.
<6>md: autorun ...
<6>md: ... autorun DONE.
<6>warning: process `sleep' used the removed sysctl system call
<6>warning: process `showconsole' used the removed sysctl system call
<6>warning: process `sleep' used the removed sysctl system call
Kernel logging (ksyslog) stopped.
Kernel log daemon terminating.

Boot logging started on /dev/ttyS1(/dev/console) at Sat Sep 30 16:03:49 2006

Master Resource Control: previous runlevel: N, switching to runlevel: 3
<notice>start services (random isdn irq_balancer hotplug)
Hotplug is already active  (disable with  NOHOTPLUG=1 at the boot prompt)done
Initializing random number generatordone
Starting irqbalance <notice>startproc: execve (/usr/sbin/irqbalance) [ /usr/sbin/irqbalance ], [ CONSOLE=/dev/console TERM=vt102 SHELL=/bin/sh progress=20 INIT_VERSION=sysvinit-2.85 INIT=/sbin/init REDIRECT=/dev/ttyS1 COLUMNS=80 PATH=/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin RUNLEVEL=3 PWD=/ PREVLEVEL=N LINES=24 HOME=/ SHLVL=2 sscripts=46 _=/sbin/startproc DAEMON=/usr/sbin/irqbalance ]
<notice>exit status of (random isdn irq_balancer hotplug) is (0 0 0 0)
done
<notice>start services (coldplug)
coldplug scanning input: ***done
         scanning pci: *W..**.**...*.*****done
         scanning usb: done
         .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .done
<notice>exit status of (coldplug) is (0)
<notice>start services (network)
Setting up network interfaces:
    lo       
    lo        IP address: 127.0.0.1/8   
done    eth0      device: 3Com Corporation 3c905C-TX/TX-M [Tornado] (rev 6c)
    eth0      configuration: eth-id-00:04:76:15:f4:8f
    eth0      Startmode is 'manual'
skipped    eth1      device: Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet (rev 10)
    eth1      configuration: eth-id-00:0d:60:98:74:22
    eth1      (DHCP) . . . . . no IP address yet... backgrounding. 
waiting
    eth2      device: Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet (rev 10)
    eth2      configuration: eth-id-00:0d:60:98:74:23
<notice>checkproc: /sbin/dhcpcd 3603
    eth2      (DHCP) . <notice>pidofproc: dhcpcd 3914<notice>pidofproc: dhcpcd  3603
. . . . no IP address yet... backgrounding. 
waiting
    gre0     
    gre0      No configuration found for gre0
unused    ip6tnl0  
    ip6tnl0   No configuration found for ip6tnl0
unused    teql0    
    teql0     No configuration found for teql0
unused    tunl0    
    tunl0     No configuration found for tunl0
unused<notice>checkproc: /sbin/dhcpcd 3958<notice>checkproc: /sbin/dhcpcd  3914
    eth1      device: Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet (rev 10)
    eth1      configuration: eth-id-00:0d:60:98:74:22
    eth1      IP address: 9.148.9.208/24 (DHCP)
<notice>checkproc: /sbin/dhcpcd 3958<notice>checkproc: /sbin/dhcpcd  3914
done<notice>checkproc: /sbin/dhcpcd 3958<notice>checkproc: /sbin/dhcpcd  3914
Waiting for mandatory devices:  eth-id-00:0d:60:98:74:23
8 <notice>checkproc: /sbin/dhcpcd 3958<notice>checkproc: /sbin/dhcpcd  3914
6 <notice>checkproc: /sbin/dhcpcd 3958<notice>checkproc: /sbin/dhcpcd  3914
5 <notice>checkproc: /sbin/dhcpcd 3958<notice>checkproc: /sbin/dhcpcd  3914
4 <notice>checkproc: /sbin/dhcpcd 3958<notice>checkproc: /sbin/dhcpcd  3914
3 <notice>checkproc: /sbin/dhcpcd 3958<notice>checkproc: /sbin/dhcpcd  3914
2 <notice>checkproc: /sbin/dhcpcd 3958<notice>checkproc: /sbin/dhcpcd  3914
1 <notice>checkproc: /sbin/dhcpcd 3958<notice>checkproc: /sbin/dhcpcd  3914
0 <notice>checkproc: /sbin/dhcpcd 3958<notice>checkproc: /sbin/dhcpcd  3914

    eth2                                interface could not be set up
failedSetting up service network  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .failed
<notice>exit status of (network) is (7)
<notice>start services (syslog)
<notice>startproc: execve (/sbin/syslogd) [ /sbin/syslogd -a /var/lib/ntp/dev/log ], [ CONSOLE=/dev/console TERM=vt102 SHELL=/bin/sh progress=26 INIT_VERSION=sysvinit-2.85 INIT=/sbin/init REDIRECT=/dev/ttyS1 COLUMNS=80 PATH=/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin RUNLEVEL=3 PWD=/ PREVLEVEL=N LINES=24 HOME=/ SHLVL=2 sscripts=46 _=/sbin/startproc DAEMON=/sbin/syslogd ]
Starting syslog services<notice>startproc: execve (/sbin/klogd) [ /sbin/klogd -c 7 -2 -x ], [ CONSOLE=/dev/console TERM=vt102 SHELL=/bin/sh progress=26 INIT_VERSION=sysvinit-2.85 INIT=/sbin/init REDIRECT=/dev/ttyS1 COLUMNS=80 PATH=/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin RUNLEVEL=3 PWD=/ PREVLEVEL=N LINES=24 HOME=/ SHLVL=2 sscripts=46 _=/sbin/startproc DAEMON=/sbin/klogd ]
done
<notice>exit status of (syslog) is (0)
<notice>start services (splash_early smbfs slpd resmgr portmap)
<notice>startproc: execve (/sbin/resmgrd) [ /sbin/resmgrd ], [ CONSOLE=/dev/console TERM=vt102 SHELL=/bin/sh progress=27 INIT_VERSION=sysvinit-2.85 INIT=/sbin/init REDIRECT=/dev/ttyS1 COLUMNS=80 PATH=/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin RUNLEVEL=3 PWD=/ PREVLEVEL=N LINES=24 HOME=/ SHLVL=2 sscripts=46 _=/sbin/startproc DAEMON=/sbin/resmgrd ]
<notice>startproc: execve (/usr/sbin/slpd) [ /usr/sbin/slpd ], [ CONSOLE=/dev/console TERM=vt102 SHELL=/bin/sh progress=27 INIT_VERSION=sysvinit-2.85 INIT=/sbin/init REDIRECT=/dev/ttyS1 COLUMNS=80 PATH=/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin RUNLEVEL=3 PWD=/ PREVLEVEL=N LINES=24 HOME=/ SHLVL=2 sscripts=46 _=/sbin/startproc DAEMON=/usr/sbin/slpd ]
<notice>startproc: execve (/sbin/portmap) [ /sbin/portmap ], [ CONSOLE=/dev/console TERM=vt102 SHELL=/bin/sh progress=27 INIT_VERSION=sysvinit-2.85 INIT=/sbin/init REDIRECT=/dev/ttyS1 COLUMNS=80 PATH=/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin RUNLEVEL=3 PWD=/ PREVLEVEL=N LINES=24 HOME=/ SHLVL=2 sscripts=46 _=/sbin/startproc DAEMON=/sbin/portmap ]
Starting resource managerdone
Starting RPC portmap daemondone
Starting slpd done
Mount SMB/ CIFS File Systems unused
<notice>exit status of (splash_early smbfs slpd resmgr portmap) is (0 6 0 0 0)
<notice>start services (nfsboot nfs)
Importing Net File System (NFS)unused
Starting nfsboot (sm-notify) done
<notice>exit status of (nfsboot nfs) is (0 6)
<notice>start services (sshd powersaved microcode fbset cups alsasound)
<notice>startproc: execve (/usr/sbin/sshd) [ /usr/sbin/sshd -o PidFile=/var/run/sshd.init.pid ], [ CONSOLE=/dev/console TERM=vt102 SHELL=/bin/sh progress=34 INIT_VERSION=sysvinit-2.85 INIT=/sbin/init REDIRECT=/dev/ttyS1 COLUMNS=80 PATH=/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin RUNLEVEL=3 PWD=/ PREVLEVEL=N LINES=24 HOME=/ SHLVL=2 sscripts=46 _=/sbin/startproc DAEMON=/usr/sbin/sshd ]
<notice>startproc: execve (/usr/sbin/cupsd) [ /usr/sbin/cupsd ], [ CONSOLE=/dev/console TERM=vt102 SHELL=/bin/sh progress=34 INIT_VERSION=sysvinit-2.85 INIT=/sbin/init REDIRECT=/dev/ttyS1 COLUMNS=80 PATH=/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin RUNLEVEL=3 PWD=/ PREVLEVEL=N LINES=24 HOME=/ SHLVL=2 sscripts=46 _=/sbin/startproc DAEMON=/usr/sbin/cupsd ]
Starting sound driverdone
Checking/updating CPU microcodeFATAL: Could not load /lib/modules/2.6.18mx/modules.dep: No such file or directory
FATAL: Could not load /lib/modules/2.6.18mx/modules.dep: No such file or directory
failed
Starting cupsddone
Starting SSH daemondone
loading ACPI modules () Starting powersaved <notice>startproc: execve (/usr/sbin/powersaved) [ /usr/sbin/powersaved -d -e /etc/powersave.conf -a resmgr -v 3 ], [ CONSOLE=/dev/console TERM=vt102 SHELL=/bin/sh progress=34 INIT_VERSION=sysvinit-2.85 INIT=/sbin/init REDIRECT=/dev/ttyS1 COLUMNS=80 PATH=/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin RUNLEVEL=3 PWD=/ PREVLEVEL=N LINES=24 HOME=/ SHLVL=2 sscripts=46 _=/sbin/startproc DAEMON=/usr/sbin/powersaved ]
done
<notice>exit status of (sshd powersaved microcode fbset cups alsasound) is (0 0 1 0 0 0)
<notice>start services (splash postfix kbd)
Starting mail service (Postfix)done
Loading keymap qwerty/us.map.gz
doneSep 30 16:04:18 undeg kernel: klogd 1.4.1, log source = /proc/kmsg started.

Sep 30 16:04:18 undeg kernel: PM: Writing back config space on device 0000:01:01.0 at offset b (was 164814e4, writing 2e71014)

Sep 30 16:04:18 undeg kernel: PM: Writing back config space on device 0000:01:01.0 at offset 3 (was 804000, writing 80f010)

Sep 30 16:04:18 undeg kernel: PM: Writing back config space on device 0000:01:01.0 at offset 2 (was 2000000, writing 2000010)

Sep 30 16:04:18 undeg kernel: PM: Writing back config space on device 0000:01:01.0 at offset 1 (was 2b00000, writing 2b00146)

Sep 30 16:04:18 undeg kernel: ADDRCONF(NETDEV_UP): eth1: link is not ready

Sep 30 16:04:18 undeg kernel: tg3: eth1: Link is up at 100 Mbps, full duplex.

Sep 30 16:04:18 undeg kernel: tg3: eth1: Flow control is on for TX and on for RX.

Sep 30 16:04:18 undeg kernel: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready

Sep 30 16:04:18 undeg kernel: PM: Writing back config space on device 0000:01:01.1 at offset b (was 164814e4, writing 2e71014)

Sep 30 16:04:18 undeg kernel: PM: Writing back config space on device 0000:01:01.1 at offset 3 (was 804000, writing 80f010)

Sep 30 16:04:18 undeg kernel: PM: Writing back config space on device 0000:01:01.1 at offset 2 (was 2000000, writing 2000010)

Sep 30 16:04:18 undeg kernel: PM: Writing back config space on device 0000:01:01.1 at offset 1 (was 2b00000, writing 2b00146)

Sep 30 16:04:18 undeg kernel: ADDRCONF(NETDEV_UP): eth2: link is not ready

Sep 30 16:04:18 undeg kernel: tg3: eth2: Link is up at 100 Mbps, full duplex.

Sep 30 16:04:18 undeg kernel: tg3: eth2: Flow control is off for TX and off for RX.

Sep 30 16:04:18 undeg kernel: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready

Sep 30 16:04:18 undeg kernel: eth1: no IPv6 routers present

Sep 30 16:04:18 undeg kernel: eth2: no IPv6 routers present

Loading compose table winkeys shiftctrl latin1.adddone
Start Unicode mode
doneLoading console font lat9w-16.psfu  -m trivial (K
done<notice>exit status of (splash postfix kbd) is (5 0 0)
<notice>start services (nscd hwscan cron)
Starting hardware scan on boot<notice>startproc: execve (/usr/sbin/nscd) [ /usr/sbin/nscd ], [ CONSOLE=/dev/console TERM=vt102 SHELL=/bin/sh progress=43 INIT_VERSION=sysvinit-2.85 INIT=/sbin/init REDIRECT=/dev/ttyS1 COLUMNS=80 PATH=/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin RUNLEVEL=3 PWD=/ PREVLEVEL=N LINES=24 HOME=/ SHLVL=2 sscripts=46 _=/sbin/startproc DAEMON=/usr/sbin/nscd ]
<notice>startproc: execve (/usr/sbin/cron) [ /usr/sbin/cron ], [ CONSOLE=/dev/console TERM=vt102 SHELL=/bin/sh progress=43 INIT_VERSION=sysvinit-2.85 INIT=/sbin/init REDIRECT=/dev/ttyS1 COLUMNS=80 PATH=/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin RUNLEVEL=3 PWD=/ PREVLEVEL=N LINES=24 HOME=/ SHLVL=2 sscripts=46 _=/sbin/startproc DAEMON=/usr/sbin/cron ]
Starting Name Service Cache Daemondone
Starting CRON daemondone
Sep 30 16:04:24 undeg kernel: program hwscan is using a deprecated SCSI ioctl, please convert it to SG_IO

<notice>exit status of (nscd hwscan cron) is (0 0 0)
<notice>start services (splash_late)
<notice>exit status of (splash_late) is (0)
Master Resource Control: runlevel 3 has been reached
Failed services in runlevel 3: network microcode
Skipped services in runlevel 3: smbfs nfs splash
<notice>killproc: kill(2794,3)

pertinent excerpt from /var/log/messages:

Sep 30 16:06:30 undeg kernel: aic94xx: escb_tasklet_complete: phy0: REQ_TASK_ABORT
Sep 30 16:07:17 undeg kernel: sas: command 0xffff810192103e00, task 0xffff810188057900, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff810192103c80, task 0xffff810188057700, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff81018f51e380, task 0xffff810188057500, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff81018f51e200, task 0xffff810188057300, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff81018f51e080, task 0xffff810191836680, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff810191834980, task 0xffff810191836480, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff810191834800, task 0xffff810191836280, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff810191834680, task 0xffff81018e59a300, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff810191834500, task 0xffff81018e59a700, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff8101969f8800, task 0xffff81018e59ad00, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff8101969f8380, task 0xffff81018e59a100, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff8101969f8080, task 0xffff81018f51cc80, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff8101969f8b00, task 0xffff81018f51ca80, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff8101969f8c80, task 0xffff81018f51c880, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff81018f51ee00, task 0xffff81018f51c680, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff81018f51ec80, task 0xffff81018f51c480, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff81018f51eb00, task 0xffff81018f51c280, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff810192103680, task 0xffff81018cce2780, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff810192103500, task 0xffff81018cce2580, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff810192103380, task 0xffff81018cce2380, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff810192103200, task 0xffff81018cce2180, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff810192103080, task 0xffff810191836c80, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff810191834e00, task 0xffff810191836a80, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff810191834c80, task 0xffff810191836880, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff810191834b00, task 0xffff81018f51c080, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff810192103b00, task 0xffff81018cce2b80, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff810192103980, task 0xffff81018cce2980, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff810192103800, task 0xffff810188057d00, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff81018f51e980, task 0xffff81018e59a900, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff81018f51e800, task 0xffff810188057b00, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff81018f51e680, task 0xffff810188057100, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: command 0xffff81018f51e500, task 0xffff81018cce2d80, timed out: EH_NOT_HANDLED
Sep 30 16:07:17 undeg kernel: sas: Enter sas_scsi_recover_host
Sep 30 16:07:17 undeg kernel: sas: going over list...
Sep 30 16:07:17 undeg kernel: sas: trying to find task 0xffff810188057900
Sep 30 16:07:17 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff810188057900
Sep 30 16:07:17 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:17 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:17 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:17 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:17 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:17 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:17 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:17 undeg kernel: aic94xx: task 0xffff810188057900 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:17 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:17 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:17 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:17 undeg kernel: aic94xx: task 0xffff810188057900 aborted, res: 0x0
Sep 30 16:07:17 undeg kernel: sas: sas_scsi_find_task: task 0xffff810188057900 is done
Sep 30 16:07:17 undeg kernel: sas: sas_scsi_recover_host: task 0xffff810188057900 is done
Sep 30 16:07:17 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:19 undeg kernel: end_request: I/O error, dev sdb, sector 15462560
Sep 30 16:07:19 undeg kernel: Buffer I/O error on device sdb2, logical block 1670676
Sep 30 16:07:19 undeg kernel: lost page write due to I/O error on sdb2
Sep 30 16:07:19 undeg kernel: Buffer I/O error on device sdb2, logical block 1670677
Sep 30 16:07:19 undeg kernel: lost page write due to I/O error on sdb2
Sep 30 16:07:19 undeg kernel: Buffer I/O error on device sdb2, logical block 1670678
Sep 30 16:07:19 undeg kernel: lost page write due to I/O error on sdb2
Sep 30 16:07:19 undeg kernel: Buffer I/O error on device sdb2, logical block 1670679
Sep 30 16:07:19 undeg kernel: lost page write due to I/O error on sdb2
Sep 30 16:07:19 undeg kernel: Buffer I/O error on device sdb2, logical block 1670680
Sep 30 16:07:19 undeg kernel: lost page write due to I/O error on sdb2
Sep 30 16:07:19 undeg kernel: Buffer I/O error on device sdb2, logical block 1670681
Sep 30 16:07:19 undeg kernel: lost page write due to I/O error on sdb2
Sep 30 16:07:19 undeg kernel: Buffer I/O error on device sdb2, logical block 1670682
Sep 30 16:07:19 undeg kernel: lost page write due to I/O error on sdb2
Sep 30 16:07:19 undeg kernel: Buffer I/O error on device sdb2, logical block 1670683
Sep 30 16:07:19 undeg kernel: lost page write due to I/O error on sdb2
Sep 30 16:07:19 undeg kernel: Buffer I/O error on device sdb2, logical block 1670684
Sep 30 16:07:19 undeg kernel: lost page write due to I/O error on sdb2
Sep 30 16:07:19 undeg kernel: Buffer I/O error on device sdb2, logical block 1670685
Sep 30 16:07:19 undeg kernel: lost page write due to I/O error on sdb2
Sep 30 16:07:19 undeg kernel: sas: trying to find task 0xffff810188057700
Sep 30 16:07:19 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff810188057700
Sep 30 16:07:19 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:19 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:19 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:19 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:19 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:19 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:19 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:19 undeg kernel: aic94xx: task 0xffff810188057700 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:19 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:19 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:19 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:19 undeg kernel: aic94xx: task 0xffff810188057700 aborted, res: 0x0
Sep 30 16:07:19 undeg kernel: sas: sas_scsi_find_task: task 0xffff810188057700 is done
Sep 30 16:07:19 undeg kernel: sas: sas_scsi_recover_host: task 0xffff810188057700 is done
Sep 30 16:07:19 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:19 undeg kernel: end_request: I/O error, dev sdb, sector 15463584
Sep 30 16:07:19 undeg kernel: sas: trying to find task 0xffff810188057500
Sep 30 16:07:19 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff810188057500
Sep 30 16:07:19 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:19 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:19 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:19 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:19 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:19 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:19 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:21 undeg kernel: aic94xx: task 0xffff810188057500 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:21 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:21 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:21 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:21 undeg kernel: aic94xx: task 0xffff810188057500 aborted, res: 0x0
Sep 30 16:07:21 undeg kernel: sas: sas_scsi_find_task: task 0xffff810188057500 is done
Sep 30 16:07:21 undeg kernel: sas: sas_scsi_recover_host: task 0xffff810188057500 is done
Sep 30 16:07:21 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:21 undeg kernel: end_request: I/O error, dev sdb, sector 15464608
Sep 30 16:07:21 undeg kernel: sas: trying to find task 0xffff810188057300
Sep 30 16:07:21 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff810188057300
Sep 30 16:07:21 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:21 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:21 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:21 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:21 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:21 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:21 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:21 undeg kernel: aic94xx: task 0xffff810188057300 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:21 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:21 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:21 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:21 undeg kernel: aic94xx: task 0xffff810188057300 aborted, res: 0x0
Sep 30 16:07:21 undeg kernel: sas: sas_scsi_find_task: task 0xffff810188057300 is done
Sep 30 16:07:21 undeg kernel: sas: sas_scsi_recover_host: task 0xffff810188057300 is done
Sep 30 16:07:21 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:21 undeg kernel: end_request: I/O error, dev sdb, sector 15465632
Sep 30 16:07:21 undeg kernel: sas: trying to find task 0xffff810191836680
Sep 30 16:07:21 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff810191836680
Sep 30 16:07:21 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:21 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:21 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:21 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:21 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:21 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:21 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:21 undeg kernel: aic94xx: task 0xffff810191836680 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:21 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:21 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:21 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:21 undeg kernel: aic94xx: task 0xffff810191836680 aborted, res: 0x0
Sep 30 16:07:21 undeg kernel: sas: sas_scsi_find_task: task 0xffff810191836680 is done
Sep 30 16:07:21 undeg kernel: sas: sas_scsi_recover_host: task 0xffff810191836680 is done
Sep 30 16:07:21 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:21 undeg kernel: end_request: I/O error, dev sdb, sector 15470600
Sep 30 16:07:21 undeg kernel: sas: trying to find task 0xffff810191836480
Sep 30 16:07:21 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff810191836480
Sep 30 16:07:21 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:21 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:23 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:23 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:23 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:23 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:23 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:23 undeg kernel: aic94xx: task 0xffff810191836480 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:23 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:23 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:23 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:23 undeg kernel: aic94xx: task 0xffff810191836480 aborted, res: 0x0
Sep 30 16:07:23 undeg kernel: sas: sas_scsi_find_task: task 0xffff810191836480 is done
Sep 30 16:07:23 undeg kernel: sas: sas_scsi_recover_host: task 0xffff810191836480 is done
Sep 30 16:07:23 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:23 undeg kernel: end_request: I/O error, dev sdb, sector 15471624
Sep 30 16:07:23 undeg kernel: sas: trying to find task 0xffff810191836280
Sep 30 16:07:23 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff810191836280
Sep 30 16:07:23 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:23 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:23 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:23 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:23 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:23 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:23 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:23 undeg kernel: aic94xx: task 0xffff810191836280 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:23 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:23 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:23 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:23 undeg kernel: aic94xx: task 0xffff810191836280 aborted, res: 0x0
Sep 30 16:07:23 undeg kernel: sas: sas_scsi_find_task: task 0xffff810191836280 is done
Sep 30 16:07:23 undeg kernel: sas: sas_scsi_recover_host: task 0xffff810191836280 is done
Sep 30 16:07:23 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:23 undeg kernel: end_request: I/O error, dev sdb, sector 15472648
Sep 30 16:07:23 undeg kernel: sas: trying to find task 0xffff81018e59a300
Sep 30 16:07:23 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff81018e59a300
Sep 30 16:07:23 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:23 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:23 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:23 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:23 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:23 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:23 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:23 undeg kernel: aic94xx: task 0xffff81018e59a300 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:23 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:23 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:23 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:23 undeg kernel: aic94xx: task 0xffff81018e59a300 aborted, res: 0x0
Sep 30 16:07:23 undeg kernel: sas: sas_scsi_find_task: task 0xffff81018e59a300 is done
Sep 30 16:07:23 undeg kernel: sas: sas_scsi_recover_host: task 0xffff81018e59a300 is done
Sep 30 16:07:23 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:23 undeg kernel: end_request: I/O error, dev sdb, sector 15473672
Sep 30 16:07:25 undeg kernel: sas: trying to find task 0xffff81018e59a700
Sep 30 16:07:25 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff81018e59a700
Sep 30 16:07:25 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:25 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:25 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:25 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:25 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:25 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:25 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:25 undeg kernel: aic94xx: task 0xffff81018e59a700 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:25 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:25 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:25 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:25 undeg kernel: aic94xx: task 0xffff81018e59a700 aborted, res: 0x0
Sep 30 16:07:25 undeg kernel: sas: sas_scsi_find_task: task 0xffff81018e59a700 is done
Sep 30 16:07:25 undeg kernel: sas: sas_scsi_recover_host: task 0xffff81018e59a700 is done
Sep 30 16:07:25 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:25 undeg kernel: end_request: I/O error, dev sdb, sector 15474696
Sep 30 16:07:25 undeg kernel: sas: trying to find task 0xffff81018e59ad00
Sep 30 16:07:25 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff81018e59ad00
Sep 30 16:07:25 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:25 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:25 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:25 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:25 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:25 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:25 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:25 undeg kernel: aic94xx: task 0xffff81018e59ad00 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:25 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:25 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:25 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:25 undeg kernel: aic94xx: task 0xffff81018e59ad00 aborted, res: 0x0
Sep 30 16:07:25 undeg kernel: sas: sas_scsi_find_task: task 0xffff81018e59ad00 is done
Sep 30 16:07:25 undeg kernel: sas: sas_scsi_recover_host: task 0xffff81018e59ad00 is done
Sep 30 16:07:25 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:25 undeg kernel: end_request: I/O error, dev sdb, sector 15483064
Sep 30 16:07:25 undeg kernel: sas: trying to find task 0xffff81018e59a100
Sep 30 16:07:25 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff81018e59a100
Sep 30 16:07:25 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:25 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:25 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:25 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:25 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:25 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:25 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:25 undeg kernel: aic94xx: task 0xffff81018e59a100 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:25 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:25 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:27 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:27 undeg kernel: aic94xx: task 0xffff81018e59a100 aborted, res: 0x0
Sep 30 16:07:27 undeg kernel: sas: sas_scsi_find_task: task 0xffff81018e59a100 is done
Sep 30 16:07:27 undeg kernel: sas: sas_scsi_recover_host: task 0xffff81018e59a100 is done
Sep 30 16:07:27 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:27 undeg kernel: end_request: I/O error, dev sdb, sector 15484088
Sep 30 16:07:27 undeg kernel: sas: trying to find task 0xffff81018f51cc80
Sep 30 16:07:27 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff81018f51cc80
Sep 30 16:07:27 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:27 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:27 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:27 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:27 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:27 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:27 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:27 undeg kernel: aic94xx: task 0xffff81018f51cc80 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:27 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:27 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:27 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:27 undeg kernel: aic94xx: task 0xffff81018f51cc80 aborted, res: 0x0
Sep 30 16:07:27 undeg kernel: sas: sas_scsi_find_task: task 0xffff81018f51cc80 is done
Sep 30 16:07:27 undeg kernel: sas: sas_scsi_recover_host: task 0xffff81018f51cc80 is done
Sep 30 16:07:27 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:27 undeg kernel: end_request: I/O error, dev sdb, sector 15485112
Sep 30 16:07:27 undeg kernel: sas: trying to find task 0xffff81018f51ca80
Sep 30 16:07:27 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff81018f51ca80
Sep 30 16:07:27 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:27 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:27 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:27 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:27 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:27 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:27 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:27 undeg kernel: aic94xx: task 0xffff81018f51ca80 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:27 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:27 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:27 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:27 undeg kernel: aic94xx: task 0xffff81018f51ca80 aborted, res: 0x0
Sep 30 16:07:27 undeg kernel: sas: sas_scsi_find_task: task 0xffff81018f51ca80 is done
Sep 30 16:07:27 undeg kernel: sas: sas_scsi_recover_host: task 0xffff81018f51ca80 is done
Sep 30 16:07:27 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:27 undeg kernel: end_request: I/O error, dev sdb, sector 15486136
Sep 30 16:07:27 undeg kernel: sas: trying to find task 0xffff81018f51c880
Sep 30 16:07:27 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff81018f51c880
Sep 30 16:07:27 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:27 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:27 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:27 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:27 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:29 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:29 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:29 undeg kernel: aic94xx: task 0xffff81018f51c880 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:29 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:29 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:29 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:29 undeg kernel: aic94xx: task 0xffff81018f51c880 aborted, res: 0x0
Sep 30 16:07:29 undeg kernel: sas: sas_scsi_find_task: task 0xffff81018f51c880 is done
Sep 30 16:07:29 undeg kernel: sas: sas_scsi_recover_host: task 0xffff81018f51c880 is done
Sep 30 16:07:29 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:29 undeg kernel: end_request: I/O error, dev sdb, sector 15487160
Sep 30 16:07:29 undeg kernel: sas: trying to find task 0xffff81018f51c680
Sep 30 16:07:29 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff81018f51c680
Sep 30 16:07:29 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:29 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:29 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:29 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:29 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:29 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:29 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:29 undeg kernel: aic94xx: task 0xffff81018f51c680 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:29 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:29 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:29 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:29 undeg kernel: aic94xx: task 0xffff81018f51c680 aborted, res: 0x0
Sep 30 16:07:29 undeg kernel: sas: sas_scsi_find_task: task 0xffff81018f51c680 is done
Sep 30 16:07:29 undeg kernel: sas: sas_scsi_recover_host: task 0xffff81018f51c680 is done
Sep 30 16:07:29 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:29 undeg kernel: end_request: I/O error, dev sdb, sector 15488184
Sep 30 16:07:29 undeg kernel: sas: trying to find task 0xffff81018f51c480
Sep 30 16:07:29 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff81018f51c480
Sep 30 16:07:29 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:29 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:29 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:29 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:29 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:29 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:29 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:29 undeg kernel: aic94xx: task 0xffff81018f51c480 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:29 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:29 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:29 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:29 undeg kernel: aic94xx: task 0xffff81018f51c480 aborted, res: 0x0
Sep 30 16:07:29 undeg kernel: sas: sas_scsi_find_task: task 0xffff81018f51c480 is done
Sep 30 16:07:29 undeg kernel: sas: sas_scsi_recover_host: task 0xffff81018f51c480 is done
Sep 30 16:07:29 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:29 undeg kernel: end_request: I/O error, dev sdb, sector 15489208
Sep 30 16:07:29 undeg kernel: sas: trying to find task 0xffff81018f51c280
Sep 30 16:07:29 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff81018f51c280
Sep 30 16:07:29 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:31 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:31 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:31 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:31 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:31 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:31 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:31 undeg kernel: aic94xx: task 0xffff81018f51c280 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:31 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:31 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:31 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:31 undeg kernel: aic94xx: task 0xffff81018f51c280 aborted, res: 0x0
Sep 30 16:07:31 undeg kernel: sas: sas_scsi_find_task: task 0xffff81018f51c280 is done
Sep 30 16:07:31 undeg kernel: sas: sas_scsi_recover_host: task 0xffff81018f51c280 is done
Sep 30 16:07:31 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:31 undeg kernel: end_request: I/O error, dev sdb, sector 15490232
Sep 30 16:07:31 undeg kernel: sas: trying to find task 0xffff81018cce2780
Sep 30 16:07:31 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff81018cce2780
Sep 30 16:07:31 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:31 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:31 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:31 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:31 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:31 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:31 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:31 undeg kernel: aic94xx: task 0xffff81018cce2780 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:31 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:31 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:31 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:31 undeg kernel: aic94xx: task 0xffff81018cce2780 aborted, res: 0x0
Sep 30 16:07:31 undeg kernel: sas: sas_scsi_find_task: task 0xffff81018cce2780 is done
Sep 30 16:07:31 undeg kernel: sas: sas_scsi_recover_host: task 0xffff81018cce2780 is done
Sep 30 16:07:31 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:31 undeg kernel: end_request: I/O error, dev sdb, sector 15499464
Sep 30 16:07:31 undeg kernel: sas: trying to find task 0xffff81018cce2580
Sep 30 16:07:31 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff81018cce2580
Sep 30 16:07:31 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:31 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:31 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:31 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:31 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:31 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:31 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:31 undeg kernel: aic94xx: task 0xffff81018cce2580 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:31 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:31 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:31 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:31 undeg kernel: aic94xx: task 0xffff81018cce2580 aborted, res: 0x0
Sep 30 16:07:33 undeg kernel: sas: sas_scsi_find_task: task 0xffff81018cce2580 is done
Sep 30 16:07:33 undeg kernel: sas: sas_scsi_recover_host: task 0xffff81018cce2580 is done
Sep 30 16:07:33 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:33 undeg kernel: end_request: I/O error, dev sdb, sector 15500488
Sep 30 16:07:33 undeg kernel: sas: trying to find task 0xffff81018cce2380
Sep 30 16:07:33 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff81018cce2380
Sep 30 16:07:33 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:33 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:33 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:33 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:33 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:33 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:33 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:33 undeg kernel: aic94xx: task 0xffff81018cce2380 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:33 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:33 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:33 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:33 undeg kernel: aic94xx: task 0xffff81018cce2380 aborted, res: 0x0
Sep 30 16:07:33 undeg kernel: sas: sas_scsi_find_task: task 0xffff81018cce2380 is done
Sep 30 16:07:33 undeg kernel: sas: sas_scsi_recover_host: task 0xffff81018cce2380 is done
Sep 30 16:07:33 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:33 undeg kernel: end_request: I/O error, dev sdb, sector 15501512
Sep 30 16:07:33 undeg kernel: sas: trying to find task 0xffff81018cce2180
Sep 30 16:07:33 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff81018cce2180
Sep 30 16:07:33 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:33 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:33 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:33 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:33 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:33 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:33 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:33 undeg kernel: aic94xx: task 0xffff81018cce2180 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:33 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:33 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:33 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:33 undeg kernel: aic94xx: task 0xffff81018cce2180 aborted, res: 0x0
Sep 30 16:07:33 undeg kernel: sas: sas_scsi_find_task: task 0xffff81018cce2180 is done
Sep 30 16:07:33 undeg kernel: sas: sas_scsi_recover_host: task 0xffff81018cce2180 is done
Sep 30 16:07:33 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:33 undeg kernel: end_request: I/O error, dev sdb, sector 15502536
Sep 30 16:07:33 undeg kernel: sas: trying to find task 0xffff810191836c80
Sep 30 16:07:33 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff810191836c80
Sep 30 16:07:33 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:33 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:33 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:33 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:33 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:33 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:33 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:35 undeg kernel: aic94xx: task 0xffff810191836c80 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:35 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:35 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:35 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:35 undeg kernel: aic94xx: task 0xffff810191836c80 aborted, res: 0x0
Sep 30 16:07:35 undeg kernel: sas: sas_scsi_find_task: task 0xffff810191836c80 is done
Sep 30 16:07:35 undeg kernel: sas: sas_scsi_recover_host: task 0xffff810191836c80 is done
Sep 30 16:07:35 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:35 undeg kernel: end_request: I/O error, dev sdb, sector 15503560
Sep 30 16:07:35 undeg kernel: sas: trying to find task 0xffff810191836a80
Sep 30 16:07:35 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff810191836a80
Sep 30 16:07:35 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:35 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:35 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:35 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:35 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:35 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:35 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:35 undeg kernel: aic94xx: task 0xffff810191836a80 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:35 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:35 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:35 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:35 undeg kernel: aic94xx: task 0xffff810191836a80 aborted, res: 0x0
Sep 30 16:07:35 undeg kernel: sas: sas_scsi_find_task: task 0xffff810191836a80 is done
Sep 30 16:07:35 undeg kernel: sas: sas_scsi_recover_host: task 0xffff810191836a80 is done
Sep 30 16:07:35 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:35 undeg kernel: end_request: I/O error, dev sdb, sector 15504584
Sep 30 16:07:35 undeg kernel: sas: trying to find task 0xffff810191836880
Sep 30 16:07:35 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff810191836880
Sep 30 16:07:35 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:35 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:35 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:35 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:35 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:35 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:35 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:35 undeg kernel: aic94xx: task 0xffff810191836880 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:35 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:35 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:35 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:35 undeg kernel: aic94xx: task 0xffff810191836880 aborted, res: 0x0
Sep 30 16:07:35 undeg kernel: sas: sas_scsi_find_task: task 0xffff810191836880 is done
Sep 30 16:07:35 undeg kernel: sas: sas_scsi_recover_host: task 0xffff810191836880 is done
Sep 30 16:07:35 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:35 undeg kernel: end_request: I/O error, dev sdb, sector 15505608
Sep 30 16:07:35 undeg kernel: sas: trying to find task 0xffff81018f51c080
Sep 30 16:07:35 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff81018f51c080
Sep 30 16:07:35 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:35 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:37 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:37 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:37 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:37 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:37 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:37 undeg kernel: aic94xx: task 0xffff81018f51c080 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:37 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:37 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:37 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:37 undeg kernel: aic94xx: task 0xffff81018f51c080 aborted, res: 0x0
Sep 30 16:07:37 undeg kernel: sas: sas_scsi_find_task: task 0xffff81018f51c080 is done
Sep 30 16:07:37 undeg kernel: sas: sas_scsi_recover_host: task 0xffff81018f51c080 is done
Sep 30 16:07:37 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:37 undeg kernel: end_request: I/O error, dev sdb, sector 15506632
Sep 30 16:07:37 undeg kernel: sas: trying to find task 0xffff81018cce2b80
Sep 30 16:07:37 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff81018cce2b80
Sep 30 16:07:37 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:37 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:37 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:37 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:37 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:37 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:37 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:37 undeg kernel: aic94xx: task 0xffff81018cce2b80 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:37 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:37 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:37 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:37 undeg kernel: aic94xx: task 0xffff81018cce2b80 aborted, res: 0x0
Sep 30 16:07:37 undeg kernel: sas: sas_scsi_find_task: task 0xffff81018cce2b80 is done
Sep 30 16:07:37 undeg kernel: sas: sas_scsi_recover_host: task 0xffff81018cce2b80 is done
Sep 30 16:07:37 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:37 undeg kernel: end_request: I/O error, dev sdb, sector 15512784
Sep 30 16:07:37 undeg kernel: sas: trying to find task 0xffff81018cce2980
Sep 30 16:07:37 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff81018cce2980
Sep 30 16:07:37 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:37 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:37 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:37 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:37 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:37 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:37 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:37 undeg kernel: aic94xx: task 0xffff81018cce2980 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:37 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:37 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:37 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:37 undeg kernel: aic94xx: task 0xffff81018cce2980 aborted, res: 0x0
Sep 30 16:07:37 undeg kernel: sas: sas_scsi_find_task: task 0xffff81018cce2980 is done
Sep 30 16:07:37 undeg kernel: sas: sas_scsi_recover_host: task 0xffff81018cce2980 is done
Sep 30 16:07:37 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:37 undeg kernel: end_request: I/O error, dev sdb, sector 15513808
Sep 30 16:07:39 undeg kernel: sas: trying to find task 0xffff810188057d00
Sep 30 16:07:39 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff810188057d00
Sep 30 16:07:39 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:39 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:39 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:39 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:39 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:39 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:39 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:39 undeg kernel: aic94xx: task 0xffff810188057d00 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:39 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:39 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:39 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:39 undeg kernel: aic94xx: task 0xffff810188057d00 aborted, res: 0x0
Sep 30 16:07:39 undeg kernel: sas: sas_scsi_find_task: task 0xffff810188057d00 is done
Sep 30 16:07:39 undeg kernel: sas: sas_scsi_recover_host: task 0xffff810188057d00 is done
Sep 30 16:07:39 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:39 undeg kernel: end_request: I/O error, dev sdb, sector 15514832
Sep 30 16:07:39 undeg kernel: sas: trying to find task 0xffff81018e59a900
Sep 30 16:07:39 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff81018e59a900
Sep 30 16:07:39 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:39 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:39 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:39 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:39 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:39 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:39 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:39 undeg kernel: aic94xx: task 0xffff81018e59a900 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:39 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:39 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:39 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:39 undeg kernel: aic94xx: task 0xffff81018e59a900 aborted, res: 0x0
Sep 30 16:07:39 undeg kernel: sas: sas_scsi_find_task: task 0xffff81018e59a900 is done
Sep 30 16:07:39 undeg kernel: sas: sas_scsi_recover_host: task 0xffff81018e59a900 is done
Sep 30 16:07:39 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:39 undeg kernel: end_request: I/O error, dev sdb, sector 15515864
Sep 30 16:07:39 undeg kernel: sas: trying to find task 0xffff810188057b00
Sep 30 16:07:39 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff810188057b00
Sep 30 16:07:39 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:39 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:39 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:39 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:39 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:39 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:39 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:39 undeg kernel: aic94xx: task 0xffff810188057b00 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:39 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:39 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:41 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:41 undeg kernel: aic94xx: task 0xffff810188057b00 aborted, res: 0x0
Sep 30 16:07:41 undeg kernel: sas: sas_scsi_find_task: task 0xffff810188057b00 is done
Sep 30 16:07:41 undeg kernel: sas: sas_scsi_recover_host: task 0xffff810188057b00 is done
Sep 30 16:07:41 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:41 undeg kernel: end_request: I/O error, dev sdb, sector 15516888
Sep 30 16:07:41 undeg kernel: sas: trying to find task 0xffff810188057100
Sep 30 16:07:41 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff810188057100
Sep 30 16:07:41 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:41 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:41 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:41 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:41 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:41 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:41 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:41 undeg kernel: aic94xx: task 0xffff810188057100 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:41 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:41 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:41 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:41 undeg kernel: aic94xx: task 0xffff810188057100 aborted, res: 0x0
Sep 30 16:07:41 undeg kernel: sas: sas_scsi_find_task: task 0xffff810188057100 is done
Sep 30 16:07:41 undeg kernel: sas: sas_scsi_recover_host: task 0xffff810188057100 is done
Sep 30 16:07:41 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:41 undeg kernel: end_request: I/O error, dev sdb, sector 15517912
Sep 30 16:07:41 undeg kernel: sas: trying to find task 0xffff81018cce2d80
Sep 30 16:07:41 undeg kernel: sas: sas_scsi_find_task: aborting task 0xffff81018cce2d80
Sep 30 16:07:41 undeg kernel: aic94xx: tmf tasklet complete
Sep 30 16:07:41 undeg kernel: aic94xx: tmf resp tasklet
Sep 30 16:07:41 undeg kernel: aic94xx: tmf came back
Sep 30 16:07:41 undeg kernel: aic94xx: task not done, clearing nexus
Sep 30 16:07:41 undeg kernel: aic94xx: asd_clear_nexus_tag: PRE
Sep 30 16:07:41 undeg kernel: aic94xx: asd_clear_nexus_tag: POST
Sep 30 16:07:41 undeg kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
Sep 30 16:07:41 undeg kernel: aic94xx: task 0xffff81018cce2d80 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Sep 30 16:07:41 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
Sep 30 16:07:41 undeg kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Sep 30 16:07:41 undeg kernel: aic94xx: came back from clear nexus
Sep 30 16:07:41 undeg kernel: aic94xx: task 0xffff81018cce2d80 aborted, res: 0x0
Sep 30 16:07:41 undeg kernel: sas: sas_scsi_find_task: task 0xffff81018cce2d80 is done
Sep 30 16:07:41 undeg kernel: sas: sas_scsi_recover_host: task 0xffff81018cce2d80 is done
Sep 30 16:07:41 undeg kernel: sd 0:0:1:0: SCSI error: return code = 0x00050000
Sep 30 16:07:41 undeg kernel: end_request: I/O error, dev sdb, sector 15518936
Sep 30 16:07:41 undeg kernel: sas: --- Exit sas_scsi_recover_host

Cheers,
Muli
