From: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Subject: aic94xx driver woes continued
Date: Thu, 20 Mar 2008 19:43:16 +0100
Message-ID: <47E2B044.70705@ipax.at>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050802040202080107060309"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ipax.at ([80.64.143.40]:40683 "EHLO mail.ipax.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbYCTSwe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2008 14:52:34 -0400
Received: from [192.168.1.110] (vie-078-142-128-152.dsl.sil.at [78.142.128.152])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ipax.at (Postfix) with ESMTP id C55DB4773CC
	for <linux-scsi@vger.kernel.org>; Thu, 20 Mar 2008 19:43:19 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050802040202080107060309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

hi there,

we find ourself in the same situation as posted on this list before [1]

first of all, the hardware details:

System:
 > Tyan Transport GT24-B3992
 > Motherboard: Tyan B3992
 > Dual Opteron 2218 (Dual-Core)
 > 8GB RAM

SAS Controller:
 > product: AIC-9410W SAS (Razor ASIC RAID)=20
 > vendor: Adaptec

 > controler-bios: BIOS present (1,1), 1820
 > controler-sequencer: Firmware version 1.1 (V30)

Harddisks:
 > 4x Seagate Cheetah 15K.5 ST373455SS

There is a Software Raid10 on top of those 4 disks.
 > vanilla kernel 2.6.25-rc5
 > Debian GNU/Linux 4.0, AMD64


coming to the problem description itself:

the server is booted, the raid is working as intended
 > md4 : active raid10 sdb9[1] sda9[0] sdd9[3] sdc9[2]
 >       100181120 blocks 64K chunks 2 near-copies [4/4] [UUUU]

now we mount /dev/md4 to /home, cd there and run an io intensive task
such as stress, tiobench (or even raid-reinit is enough)
 > stress --hdd 20 --hdd-bytes 2gb --hdd-noclean

soon we see:
 > aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason=0x6
 > sas: command 0xffff81023fb2ca80, task 0xffff81023ea7ab40, timed out: 
EH_NOT_HANDLED
 > ...
 > sas: Enter sas_scsi_recover_host
 > sas: trying to find task 0xffff81023ea7ab40
 > sas: sas_scsi_find_task: aborting task 0xffff81023ea7ab40
 > ...
 > sas: --- Exit sas_scsi_recover_host

please se the attached logfile.

sometimes even a disk is kicked out of the raid configuration.

any idea what is causing this? maybe some of the folks who provide code
for the aic94xx module can help us out.

i am available for provoding more data, enabling debug code, giving
access to a test-server with this hardware, etc.

cheers,
raoul

[1] http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg06332.html
-- 
____________________________________________________________________
DI (FH) Raoul Bhatia M.Sc.          email.          r.bhatia@ipax.at
Technischer Leiter

IPAX - Aloy Bhatia Hava OEG         web.          http://www.ipax.at
Barawitzkagasse 10/2/2/11           email.            office@ipax.at
1190 Wien                           tel.               +43 1 3670030
FN 277995t HG Wien                  fax.            +43 1 3670030 15
____________________________________________________________________

--------------050802040202080107060309
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.log"

Linux version 2.6.25-rc5 (root@db-com7.travian.info) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Mon Mar 10 16:42:17 CET 2008
Command line: root=/dev/md1 ro 
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 0000000000099800 (usable)
 BIOS-e820: 0000000000099800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bfff0000 (usable)
 BIOS-e820: 00000000bfff0000 - 00000000bfffe000 (ACPI data)
 BIOS-e820: 00000000bfffe000 - 00000000c0000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec03000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000240000000 (usable)
Entering add_active_range(0, 0, 153) 0 entries of 3200 used
Entering add_active_range(0, 256, 786416) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 2359296) 2 entries of 3200 used
end_pfn_map = 2359296
DMI 2.3 present.
ACPI: RSDP 000F9210, 0024 (r2 ACPIAM)
ACPI: XSDT BFFF0100, 0044 (r1 091107 XSDT1527 20070911 MSFT       97)
ACPI: FACP BFFF0290, 00F4 (r3 091107 FACP1527 20070911 MSFT       97)
ACPI: DSDT BFFF0460, 3B2A (r1  0AAAA 0AAAA000        0 INTL  2002026)
ACPI: FACS BFFFE000, 0040
ACPI: APIC BFFF0390, 00CA (r1 091107 APIC1527 20070911 MSFT       97)
ACPI: OEMB BFFFE040, 0056 (r1 091107 OEMB1527 20070911 MSFT       97)
ACPI: SRAT BFFF3F90, 0110 (r1 AMD    HAMMER          1 AMD         1)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 0 PXM 0 0-a0000
Entering add_active_range(0, 0, 153) 0 entries of 3200 used
SRAT: Node 0 PXM 0 0-c0000000
Entering add_active_range(0, 0, 153) 1 entries of 3200 used
Entering add_active_range(0, 256, 786416) 1 entries of 3200 used
SRAT: Node 0 PXM 0 0-140000000
Entering add_active_range(0, 0, 153) 2 entries of 3200 used
Entering add_active_range(0, 256, 786416) 2 entries of 3200 used
Entering add_active_range(0, 1048576, 1310720) 2 entries of 3200 used
SRAT: Node 1 PXM 1 140000000-240000000
Entering add_active_range(1, 1310720, 2359296) 3 entries of 3200 used
NUMA: Using 30 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000140000000
  NODE_DATA [0000000000012000 - 0000000000018fff]
  bootmap [0000000000019000 -  0000000000040fff] pages 28
Bootmem setup node 1 0000000140000000-0000000240000000
  NODE_DATA [0000000140000000 - 0000000140006fff]
  bootmap [0000000140007000 -  0000000140026fff] pages 20
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-6192af] TEXT DATA BSS
early res: 3 [37abb000-37fefca3] RAMDISK
early res: 4 [99800-9f7ff] EBDA
early res: 5 [8000-11fff] PGTABLE
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
 [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
 [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
 [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
 [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
 [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
 [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
 [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
 [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004a00000 on node 0
 [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004e00000 on node 0
 [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005200000 on node 0
 [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005600000 on node 0
 [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005a00000 on node 0
 [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005e00000 on node 0
 [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006200000 on node 0
 [ffffe20003800000-ffffe200039fffff] PMD ->ffff810006600000 on node 0
 [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810006a00000 on node 0
 [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810006e00000 on node 0
 [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810007200000 on node 0
 [ffffe20004000000-ffffe200041fffff] PMD ->ffff810007600000 on node 0
 [ffffe20004200000-ffffe200043fffff] PMD ->ffff810007a00000 on node 0
 [ffffe20004400000-ffffe200045fffff] PMD ->ffff810007e00000 on node 0
 [ffffe20004600000-ffffe200047fffff] PMD ->ffff810140200000 on node 1
 [ffffe20004800000-ffffe200049fffff] PMD ->ffff810140400000 on node 1
 [ffffe20004a00000-ffffe20004bfffff] PMD ->ffff810140600000 on node 1
 [ffffe20004c00000-ffffe20004dfffff] PMD ->ffff810140800000 on node 1
 [ffffe20004e00000-ffffe20004ffffff] PMD ->ffff810140a00000 on node 1
 [ffffe20005000000-ffffe200051fffff] PMD ->ffff810140c00000 on node 1
 [ffffe20005200000-ffffe200053fffff] PMD ->ffff810140e00000 on node 1
 [ffffe20005400000-ffffe200055fffff] PMD ->ffff810141000000 on node 1
 [ffffe20005600000-ffffe200057fffff] PMD ->ffff810141200000 on node 1
 [ffffe20005800000-ffffe200059fffff] PMD ->ffff810141400000 on node 1
 [ffffe20005a00000-ffffe20005bfffff] PMD ->ffff810141600000 on node 1
 [ffffe20005c00000-ffffe20005dfffff] PMD ->ffff810141800000 on node 1
 [ffffe20005e00000-ffffe20005ffffff] PMD ->ffff810141a00000 on node 1
 [ffffe20006000000-ffffe200061fffff] PMD ->ffff810141c00000 on node 1
 [ffffe20006200000-ffffe200063fffff] PMD ->ffff810141e00000 on node 1
 [ffffe20006400000-ffffe200065fffff] PMD ->ffff810142000000 on node 1
 [ffffe20006600000-ffffe200067fffff] PMD ->ffff810142200000 on node 1
 [ffffe20006800000-ffffe200069fffff] PMD ->ffff810142400000 on node 1
 [ffffe20006a00000-ffffe20006bfffff] PMD ->ffff810142600000 on node 1
 [ffffe20006c00000-ffffe20006dfffff] PMD ->ffff810142800000 on node 1
 [ffffe20006e00000-ffffe20006ffffff] PMD ->ffff810142a00000 on node 1
 [ffffe20007000000-ffffe200071fffff] PMD ->ffff810142c00000 on node 1
 [ffffe20007200000-ffffe200073fffff] PMD ->ffff810142e00000 on node 1
 [ffffe20007400000-ffffe200075fffff] PMD ->ffff810143000000 on node 1
 [ffffe20007600000-ffffe200077fffff] PMD ->ffff810143200000 on node 1
 [ffffe20007800000-ffffe200079fffff] PMD ->ffff810143400000 on node 1
 [ffffe20007a00000-ffffe20007bfffff] PMD ->ffff810143600000 on node 1
 [ffffe20007c00000-ffffe20007dfffff] PMD ->ffff810143800000 on node 1
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  2359296
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0:        0 ->      153
    0:      256 ->   786416
    0:  1048576 ->  1310720
    1:  1310720 ->  2359296
On node 0 totalpages: 1048457
  DMA zone: 56 pages used for memmap
  DMA zone: 1070 pages reserved
  DMA zone: 2867 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 768040 pages, LIFO batch:31
  Normal zone: 3584 pages used for memmap
  Normal zone: 258560 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
On node 1 totalpages: 1048576
  DMA zone: 0 pages used for memmap
  DMA32 zone: 0 pages used for memmap
  Normal zone: 14336 pages used for memmap
  Normal zone: 1034240 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x508
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x86] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x87] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-15
ACPI: IOAPIC (id[0x05] address[0xfec01000] gsi_base[16])
IOAPIC[1]: apic_id 5, address 0xfec01000, GSI 16-31
ACPI: IOAPIC (id[0x06] address[0xfec02000] gsi_base[32])
IOAPIC[2]: apic_id 6, address 0xfec02000, GSI 32-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at c4000000 (gap: c0000000:3ec00000)
SMP: Allowing 8 CPUs, 4 hotplug CPUs
PERCPU: Allocating 34576 bytes of per cpu data
Built 2 zonelists in Node order, mobility grouping on.  Total pages: 2063707
Policy zone: Normal
Kernel command line: root=/dev/md1 ro 
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2593.500 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
Node 0: aperture @ c0000000 size 128 MB
Node 1: aperture @ c0000000 size 128 MB
Memory: 8263000k/9437184k available (2150k kernel code, 125132k reserved, 1062k data, 336k init)
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 5190.88 BogoMIPS (lpj=10381770)
Security Framework initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 12468743
Detected 12.468 MHz APIC timer.
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 5187.08 BogoMIPS (lpj=10374169)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Dual-Core AMD Opteron(tm) Processor 2218 stepping 03
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 5187.04 BogoMIPS (lpj=10374081)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/2 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
Dual-Core AMD Opteron(tm) Processor 2218 stepping 03
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 5187.08 BogoMIPS (lpj=10374177)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/3 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
Dual-Core AMD Opteron(tm) Processor 2218 stepping 03
Brought up 4 CPUs
CPU0 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000001 00000002
  domain 1: span 0000000f
   groups: 00000003 0000000c
CPU1 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000002 00000001
  domain 1: span 0000000f
   groups: 00000003 0000000c
CPU2 attaching sched-domain:
 domain 0: span 0000000c
  groups: 00000004 00000008
  domain 1: span 0000000f
   groups: 0000000c 00000003
CPU3 attaching sched-domain:
 domain 0: span 0000000c
  groups: 00000008 00000004
  domain 1: span 0000000f
   groups: 0000000c 00000003
net_namespace: 1024 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: Enabling HT MSI Mapping
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1.P1P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR1E._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR28._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR32._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR3C._PRT]
ACPI: PCI Interrupt Link [LN00] (IRQs 3 4 5 7 *9 11 12 14 15)
ACPI: PCI Interrupt Link [LN01] (IRQs 1 3 4 5 6 7 9 *11 12 14 15)
ACPI: PCI Interrupt Link [LN02] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN03] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN04] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN05] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN06] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN07] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN08] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN09] (IRQs 1 3 4 *5 6 7 9 11 12 14 15)
ACPI: PCI Interrupt Link [LN10] (IRQs 1 3 4 5 6 7 *9 11 12 14 15)
ACPI: PCI Interrupt Link [LN11] (IRQs 1 3 4 5 6 *7 9 11 12 14 15)
ACPI: PCI Interrupt Link [LN12] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN13] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN14] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN15] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN16] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN17] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN18] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN19] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN20] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN21] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN22] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN23] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN24] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN25] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN26] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN27] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN28] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN29] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN30] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNUS] (IRQs 10) *0
ACPI: PCI Interrupt Link [LNSA] (IRQs *11)
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  86, should be 7B [20070126]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
 00:08: calling quirk 0xffffffff803417ce: quirk_supermicro_h8dce_system+0x0/0xda()
pnp 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
 00:09: calling quirk 0xffffffff803417ce: quirk_supermicro_h8dce_system+0x0/0xda()
pnp 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0a: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
 00:0b: calling quirk 0xffffffff803417ce: quirk_supermicro_h8dce_system+0x0/0xda()
pnp 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
 00:0c: calling quirk 0xffffffff803417ce: quirk_supermicro_h8dce_system+0x0/0xda()
pnp 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
 00:0d: calling quirk 0xffffffff803417ce: quirk_supermicro_h8dce_system+0x0/0xda()
pnp 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NET: Registered protocol family 8
NET: Registered protocol family 20
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ c0000000 size 131072 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 128MB of IOMMU area in the AGP aperture
pnp: the driver 'system' has been registered
system 00:08: ioport range 0x4d0-0x4d1 has been reserved
system 00:08: ioport range 0xc00-0xc01 has been reserved
system 00:08: ioport range 0xcd6-0xcd7 has been reserved
system 00:08: ioport range 0xcd4-0xcd5 has been reserved
system 00:08: ioport range 0xcd8-0xcdf has been reserved
system 00:08: ioport range 0x40b-0x40b has been reserved
system 00:08: ioport range 0x4d6-0x4d6 has been reserved
system 00:08: ioport range 0xc06-0xc07 has been reserved
system 00:08: ioport range 0xc14-0xc14 has been reserved
system 00:08: ioport range 0xc49-0xc49 has been reserved
system 00:08: ioport range 0xc4a-0xc4a has been reserved
system 00:08: ioport range 0xc50-0xc51 has been reserved
system 00:08: ioport range 0xc52-0xc52 has been reserved
system 00:08: ioport range 0xc6c-0xc6c has been reserved
system 00:08: ioport range 0xc6f-0xc6f has been reserved
system 00:08: ioport range 0x500-0x57f has been reserved
system 00:08: driver attached
system 00:09: ioport range 0x580-0x58f has been reserved
system 00:09: ioport range 0x590-0x593 has been reserved
system 00:09: ioport range 0x700-0x703 has been reserved
system 00:09: ioport range 0xca0-0xcaf has been reserved
system 00:09: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:09: iomem range 0xfec01000-0xfec01fff could not be reserved
system 00:09: iomem range 0xfec02000-0xfec02fff could not be reserved
system 00:09: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:09: iomem range 0xfff00000-0xffffffff has been reserved
system 00:09: iomem range 0xff780000-0xffbfffff has been reserved
system 00:09: iomem range 0xfebfe000-0xfebfefff has been reserved
system 00:09: driver attached
system 00:0b: ioport range 0x600-0x61f has been reserved
system 00:0b: ioport range 0x520-0x53f has been reserved
system 00:0b: ioport range 0x540-0x54f has been reserved
system 00:0b: ioport range 0x640-0x65f has been reserved
system 00:0b: driver attached
system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0c: driver attached
system 00:0d: iomem range 0x0-0x9ffff could not be reserved
system 00:0d: iomem range 0x0-0x0 could not be reserved
system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
system 00:0d: iomem range 0x100000-0xbfffffff could not be reserved
system 00:0d: iomem range 0x0-0x0 could not be reserved
system 00:0d: driver attached
PCI: Bridge: 0000:01:0d.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:01.0
  IO window: 9000-afff
  MEM window: 0xff200000-0xff2fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: b000-bfff
  MEM window: 0xff300000-0xff4fffff
Time: acpi_pm clocksource has been installed.
  PREFETCH window: 0x00000000cfd00000-0x00000000cfdfffff
PCI: Bridge: 0000:00:07.0
  IO window: disabled.
  MEM window: 0xff500000-0xff5fffff
  PREFETCH window: 0x00000000cfe00000-0x00000000cfefffff
PCI: Bridge: 0000:00:08.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:09.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0a.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:08.0 to 64
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0a.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 5331k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1206036088.195:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:04.0: Firmware left e100 interrupts enabled; disabling
pci 0000:00:08.0: Found enabled HT MSI Mapping
pci 0000:00:09.0: Found enabled HT MSI Mapping
pci 0000:00:0a.0: Found enabled HT MSI Mapping
pci 0000:00:0b.0: Found enabled HT MSI Mapping
pci 0000:00:0c.0: Boot video device
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
pnp: the driver 'serial' has been registered
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial 00:05: driver attached
00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
serial 00:06: driver attached
brd: module loaded
pnp: the driver 'i8042 kbd' has been registered
i8042 kbd 00:0a: driver attached
pnp: the driver 'i8042 aux' has been registered
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Freeing unused kernel memory: 336k freed
input: AT Translated Set 2 keyboard as /class/input/input0
sata_svw 0000:01:0e.0: version 2.3
ACPI: PCI Interrupt 0000:01:0e.0[A] -> GSI 11 (level, low) -> IRQ 11
scsi0 : sata_svw
scsi1 : sata_svw
scsi2 : sata_svw
scsi3 : sata_svw
ata1: SATA max UDMA/133 mmio m8192@0xff2fe000 port 0xff2fe000 irq 11
ata2: SATA max UDMA/133 mmio m8192@0xff2fe000 port 0xff2fe100 irq 11
ata3: SATA max UDMA/133 mmio m8192@0xff2fe000 port 0xff2fe200 irq 11
ata4: SATA max UDMA/133 mmio m8192@0xff2fe000 port 0xff2fe300 irq 11
ata1: SATA link down (SStatus 4 SControl 300)
ata2: SATA link down (SStatus 4 SControl 300)
ata3: SATA link down (SStatus 4 SControl 300)
ata4: SATA link down (SStatus 4 SControl 300)
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
ACPI: PCI Interrupt 0000:03:07.0[A] -> GSI 25 (level, low) -> IRQ 25
aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:03:07.0
scsi4 : aic94xx
aic94xx: BIOS present (1,1), 1820
aic94xx: ue num:4, ue size:88
aic94xx: manuf sect SAS_ADDR 500e08100001b6b8
aic94xx: manuf sect PCBA SN 
aic94xx: ms: no phy parameters found
aic94xx: ms: Creating default phy parameters
aic94xx: ms: num_phy_desc: 8
aic94xx: ms: phy0: ENABLED
aic94xx: ms: phy1: ENABLED
aic94xx: ms: phy2: ENABLED
aic94xx: ms: phy3: ENABLED
aic94xx: ms: phy4: ENABLED
aic94xx: ms: phy5: ENABLED
aic94xx: ms: phy6: ENABLED
aic94xx: ms: phy7: ENABLED
aic94xx: ms: max_phys:0x8, num_phys:0x8
aic94xx: ms: enabled_phys:0xff
aic94xx: ms: no connector map found
aic94xx: ctrla: phy0: sas_addr: 500e08100001b6b8, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy1: sas_addr: 500e08100001b6b8, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy2: sas_addr: 500e08100001b6b8, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy3: sas_addr: 500e08100001b6b8, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy4: sas_addr: 500e08100001b6b8, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy5: sas_addr: 500e08100001b6b8, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy6: sas_addr: 500e08100001b6b8, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy7: sas_addr: 500e08100001b6b8, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: max_scbs:512, max_ddbs:128
aic94xx: setting phy0 addr to 500e08100001b6b8
aic94xx: setting phy1 addr to 500e08100001b6b8
aic94xx: setting phy2 addr to 500e08100001b6b8
aic94xx: setting phy3 addr to 500e08100001b6b8
aic94xx: setting phy4 addr to 500e08100001b6b8
aic94xx: setting phy5 addr to 500e08100001b6b8
aic94xx: setting phy6 addr to 500e08100001b6b8
aic94xx: setting phy7 addr to 500e08100001b6b8
aic94xx: num_edbs:21
aic94xx: num_escbs:3
aic94xx: Found sequencer Firmware version 1.1 (V30)
aic94xx: downloading CSEQ...
aic94xx: dma-ing 8192 bytes
aic94xx: verified 8192 bytes, passed
aic94xx: downloading LSEQs...
aic94xx: dma-ing 14336 bytes
aic94xx: LSEQ0 verified 14336 bytes, passed
aic94xx: LSEQ1 verified 14336 bytes, passed
aic94xx: LSEQ2 verified 14336 bytes, passed
aic94xx: LSEQ3 verified 14336 bytes, passed
aic94xx: LSEQ4 verified 14336 bytes, passed
aic94xx: LSEQ5 verified 14336 bytes, passed
aic94xx: LSEQ6 verified 14336 bytes, passed
aic94xx: LSEQ7 verified 14336 bytes, passed
aic94xx: max_scbs:446
aic94xx: first_scb_site_no:0x20
aic94xx: last_scb_site_no:0x1fe
aic94xx: First SCB dma_handle: 0x13e6c9000
aic94xx: device 0000:03:07.0: SAS addr 500e08100001b6b8, PCBA SN , 8 phys, 8 enabled phys, flash present, BIOS build 1820
aic94xx: posting 3 escbs
aic94xx: escbs posted
aic94xx: posting 8 control phy scbs
aic94xx: control_phy_tasklet_complete: phy4, lrate:0x9, proto:0xe
aic94xx: control_phy_tasklet_complete: phy5, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy4: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 10 00 00 08
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 00 c5 00
aic94xx: 10: 07 92 e1 09
aic94xx: 14: 00 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x10 for phy4
aic94xx: control_phy_tasklet_complete: phy6, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy5: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 10 00 00 08
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 00 c5 00
aic94xx: 10: 07 92 d8 a1
aic94xx: 14: 00 00 00 00
aic94xx: 18: 00 00 00 00
sas: phy-4:4 added to port-4:0, phy_mask:0x10 (5000c5000792e109)
sas: DOING DISCOVERY on port 0, pid:954
aic94xx: asd_form_port: updating phy_mask 0x20 for phy5
aic94xx: control_phy_tasklet_complete: phy7, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy6: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 10 00 00 08
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 00 c5 00
aic94xx: 10: 07 92 e0 91
aic94xx: 14: 00 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x40 for phy6
aic94xx: escb_tasklet_complete: phy7: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 10 00 00 08
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 00 c5 00
aic94xx: 10: 07 92 d8 f9
aic94xx: 14: 00 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x80 for phy7
scsi 4:0:0:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sas: DONE DISCOVERY on port 0, pid:954, result:0
aic94xx: control_phy_tasklet_complete: phy0: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy1: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy2: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy3: no device present: oob_status:0x0
sas: phy-4:5 added to port-4:1, phy_mask:0x20 (5000c5000792d8a1)
sas: phy-4:6 added to port-4:2, phy_mask:0x40 (5000c5000792e091)
sas: phy-4:7 added to port-4:3, phy_mask:0x80 (5000c5000792d8f9)
sas: DOING DISCOVERY on port 1, pid:954
scsi 4:0:1:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sas: DONE DISCOVERY on port 1, pid:954, result:0
sas: DOING DISCOVERY on port 2, pid:954
scsi 4:0:2:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sas: DONE DISCOVERY on port 2, pid:954, result:0
sas: DOING DISCOVERY on port 3, pid:954
scsi 4:0:3:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sas: DONE DISCOVERY on port 3, pid:954, result:0
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: ACPI0007:02 is registered as cooling_device2
ACPI: ACPI0007:03 is registered as cooling_device3
Driver 'sd' needs updating - please use bus_type methods
sd 4:0:0:0: [sda] 143374744 512-byte hardware sectors (73408 MB)
sd 4:0:0:0: [sda] Write Protect is off
sd 4:0:0:0: [sda] Mode Sense: b3 00 10 08
sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 4:0:0:0: [sda] 143374744 512-byte hardware sectors (73408 MB)
sd 4:0:0:0: [sda] Write Protect is off
sd 4:0:0:0: [sda] Mode Sense: b3 00 10 08
sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
sd 4:0:0:0: [sda] Attached SCSI disk
sd 4:0:1:0: [sdb] 143374744 512-byte hardware sectors (73408 MB)
sd 4:0:1:0: [sdb] Write Protect is off
sd 4:0:1:0: [sdb] Mode Sense: b3 00 10 08
sd 4:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 4:0:1:0: [sdb] 143374744 512-byte hardware sectors (73408 MB)
sd 4:0:1:0: [sdb] Write Protect is off
sd 4:0:1:0: [sdb] Mode Sense: b3 00 10 08
sd 4:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 sdb9 >
sd 4:0:1:0: [sdb] Attached SCSI disk
sd 4:0:2:0: [sdc] 143374744 512-byte hardware sectors (73408 MB)
sd 4:0:2:0: [sdc] Write Protect is off
sd 4:0:2:0: [sdc] Mode Sense: b3 00 10 08
sd 4:0:2:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 4:0:2:0: [sdc] 143374744 512-byte hardware sectors (73408 MB)
sd 4:0:2:0: [sdc] Write Protect is off
sd 4:0:2:0: [sdc] Mode Sense: b3 00 10 08
sd 4:0:2:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 sdc7 sdc8 sdc9 >
sd 4:0:2:0: [sdc] Attached SCSI disk
sd 4:0:3:0: [sdd] 143374744 512-byte hardware sectors (73408 MB)
sd 4:0:3:0: [sdd] Write Protect is off
sd 4:0:3:0: [sdd] Mode Sense: b3 00 10 08
sd 4:0:3:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
sd 4:0:3:0: [sdd] 143374744 512-byte hardware sectors (73408 MB)
sd 4:0:3:0: [sdd] Write Protect is off
sd 4:0:3:0: [sdd] Mode Sense: b3 00 10 08
sd 4:0:3:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdd: sdd1 sdd2 sdd3 sdd4 < sdd5 sdd6 sdd7 sdd8 sdd9 >
sd 4:0:3:0: [sdd] Attached SCSI disk
e100: eth0: e100_probe: addr 0xff6eb000, irq 16, MAC addr 00:e0:81:4b:5b:4b
scsi5 : pata_serverworks
scsi6 : pata_serverworks
ata5: PATA max UDMA/66 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata6: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
ata5.01: ATAPI: DV-28E-R, 1.8A, max UDMA/33
ata5.01: configured for UDMA/33
scsi 5:0:1:0: CD-ROM            TEAC     DV-28E-R         1.8A PQ: 0 ANSI: 5
tg3.c:v3.87 (December 20, 2007)
ACPI: PCI Interrupt 0000:04:04.0[A] -> GSI 26 (level, low) -> IRQ 26
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
eth1: Tigon3 [partno(BCM95780) rev 8100 PHY(5780)] (PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:e0:81:4b:5a:da
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth1: dma_rwctrl[76144000] dma_mask[40-bit]
ACPI: PCI Interrupt 0000:04:04.1[B] -> GSI 27 (level, low) -> IRQ 27
eth2: Tigon3 [partno(BCM95780) rev 8100 PHY(5780)] (PCIX:133MHz:64-bit) 10/100/1000Base-T Ethernet 00:e0:81:4b:5a:db
eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth2: dma_rwctrl[76144000] dma_mask[40-bit]
ide0: I/O resource 0x3F6-0x3F6 not free.
ide0: ports already in use, skipping probe
ide1: I/O resource 0x376-0x376 not free.
ide1: ports already in use, skipping probe
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
md: md5 stopped.
md: bind<sdb1>
md: bind<sdc1>
md: bind<sdd1>
md: bind<sda1>
raid1: raid set md5 active with 4 out of 4 mirrors
md: md0 stopped.
md: bind<sdb3>
md: bind<sdc3>
md: bind<sdd3>
md: bind<sda3>
raid10: raid set md0 active with 4 out of 4 devices
md: md1 stopped.
md: bind<sdb5>
md: bind<sdc5>
md: bind<sdd5>
md: bind<sda5>
raid10: raid set md1 active with 4 out of 4 devices
md: md2 stopped.
md: bind<sdb7>
md: bind<sdc7>
md: bind<sdd7>
md: bind<sda7>
raid10: raid set md2 active with 4 out of 4 devices
md: md3 stopped.
md: bind<sdb8>
md: bind<sdc8>
md: bind<sdd8>
md: bind<sda8>
raid10: raid set md3 active with 4 out of 4 devices
md: md4 stopped.
md: bind<sdc9>
md: bind<sdd9>
md: bind<sda9>
md: bind<sdb9>
raid10: raid set md4 active with 2 out of 4 devices
RAID10 conf printout:
 --- wd:2 rd:4
 disk 0, wo:1, o:1, dev:sda9
 disk 1, wo:0, o:1, dev:sdb9
 disk 2, wo:0, o:1, dev:sdc9
RAID10 conf printout:
 --- wd:2 rd:4
 disk 0, wo:1, o:1, dev:sda9
 disk 1, wo:0, o:1, dev:sdb9
 disk 2, wo:0, o:1, dev:sdc9
 disk 3, wo:1, o:1, dev:sdd9
md: recovery of RAID array md4
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
md: using 128k window, over a total of 50090560 blocks.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
sd 4:0:0:0: Attached scsi generic sg0 type 0
sd 4:0:1:0: Attached scsi generic sg1 type 0
sd 4:0:2:0: Attached scsi generic sg2 type 0
sd 4:0:3:0: Attached scsi generic sg3 type 0
scsi 5:0:1:0: Attached scsi generic sg4 type 5
input: Power Button (FF) as /class/input/input1
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
input: PC Speaker as /class/input/input2
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (FF) as /class/input/input3
Floppy drive(s): fd0 is 1.44M
piix4_smbus 0000:00:02.0: Found 0000:00:02.0 device
FDC 0 is a National Semiconductor PC87306
ACPI: Sleep Button (FF) [SLPF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [PWRB]
Adding 3999992k swap on /dev/md0.  Priority:-1 extents:1 across:3999992k
EXT3 FS on md1, internal journal
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md2, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
md: md4: recovery done.
RAID10 conf printout:
 --- wd:4 rd:4
 disk 0, wo:0, o:1, dev:sda9
 disk 1, wo:0, o:1, dev:sdb9
 disk 2, wo:0, o:1, dev:sdc9
 disk 3, wo:0, o:1, dev:sdd9
aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason=0x6
sas: command 0xffff81023fb2ca80, task 0xffff81023ea7ab40, timed out: EH_NOT_HANDLED
sas: command 0xffff81023ea7dbc0, task 0xffff81023dc5a0c0, timed out: EH_NOT_HANDLED
sas: command 0xffff81023deb66c0, task 0xffff810217a7f540, timed out: EH_NOT_HANDLED
sas: command 0xffff81023d669700, task 0xffff810217a7fe40, timed out: EH_NOT_HANDLED
sas: command 0xffff81023ea7d1c0, task 0xffff81023d66b540, timed out: EH_NOT_HANDLED
sas: command 0xffff81021717eac0, task 0xffff81023e73c840, timed out: EH_NOT_HANDLED
sas: Enter sas_scsi_recover_host
sas: trying to find task 0xffff81023ea7ab40
sas: sas_scsi_find_task: aborting task 0xffff81023ea7ab40
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task 0xffff81023e73c840 done with opcode 0x0 resp 0x0 stat 0x0 but aborted by upper layer!
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff81023ea7ab40 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: task 0xffff81023d66b540 done with opcode 0x0 resp 0x0 stat 0x0 but aborted by upper layer!
aic94xx: came back from clear nexus
aic94xx: task 0xffff81023ea7ab40 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81023ea7ab40 is done
sas: sas_eh_handle_sas_errors: task 0xffff81023ea7ab40 is done
sas: trying to find task 0xffff81023dc5a0c0
sas: sas_scsi_find_task: aborting task 0xffff81023dc5a0c0
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff81023dc5a0c0 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff81023dc5a0c0 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81023dc5a0c0 is done
sas: sas_eh_handle_sas_errors: task 0xffff81023dc5a0c0 is done
sas: trying to find task 0xffff810217a7f540
sas: sas_scsi_find_task: aborting task 0xffff810217a7f540
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff810217a7f540 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff810217a7f540 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff810217a7f540 is done
sas: sas_eh_handle_sas_errors: task 0xffff810217a7f540 is done
sas: trying to find task 0xffff810217a7fe40
sas: sas_scsi_find_task: aborting task 0xffff810217a7fe40
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff810217a7fe40 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff810217a7fe40 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff810217a7fe40 is done
sas: sas_eh_handle_sas_errors: task 0xffff810217a7fe40 is done
sas: trying to find task 0xffff81023d66b540
sas: sas_scsi_find_task: aborting task 0xffff81023d66b540
aic94xx: asd_abort_task: task 0xffff81023d66b540 done
aic94xx: task 0xffff81023d66b540 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81023d66b540 is done
sas: sas_eh_handle_sas_errors: task 0xffff81023d66b540 is done
sas: trying to find task 0xffff81023e73c840
sas: sas_scsi_find_task: aborting task 0xffff81023e73c840
aic94xx: asd_abort_task: task 0xffff81023e73c840 done
aic94xx: task 0xffff81023e73c840 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81023e73c840 is done
sas: sas_eh_handle_sas_errors: task 0xffff81023e73c840 is done
sas: --- Exit sas_scsi_recover_host
aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason=0x6
sas: command 0xffff81023ea7d580, task 0xffff81023e85ee00, timed out: EH_NOT_HANDLED
sas: command 0xffff81023dc55700, task 0xffff810217a97500, timed out: EH_NOT_HANDLED
sas: command 0xffff81021717eac0, task 0xffff810217a7f540, timed out: EH_NOT_HANDLED
sas: command 0xffff8102171fa300, task 0xffff810217a97b00, timed out: EH_NOT_HANDLED
sas: command 0xffff810217a8ac00, task 0xffff81023ea7a840, timed out: EH_NOT_HANDLED
sas: command 0xffff81023fb2ca80, task 0xffff8102189d6380, timed out: EH_NOT_HANDLED
sas: command 0xffff81023fb2cbc0, task 0xffff81023dc5a0c0, timed out: EH_NOT_HANDLED
sas: command 0xffff81023deb66c0, task 0xffff81023e85eb00, timed out: EH_NOT_HANDLED
sas: command 0xffff81021883f080, task 0xffff81023dc5a6c0, timed out: EH_NOT_HANDLED
sas: command 0xffff8102171faa80, task 0xffff81023eae8380, timed out: EH_NOT_HANDLED
sas: command 0xffff81023fb2c940, task 0xffff81023ea7a0c0, timed out: EH_NOT_HANDLED
sas: command 0xffff8102189d00c0, task 0xffff81023eae8b00, timed out: EH_NOT_HANDLED
sas: command 0xffff81023deb6440, task 0xffff81023dc51680, timed out: EH_NOT_HANDLED
sas: command 0xffff81023dc55840, task 0xffff81023dc51200, timed out: EH_NOT_HANDLED
sas: command 0xffff81021717e200, task 0xffff81023dc51e00, timed out: EH_NOT_HANDLED
sas: command 0xffff81021883f300, task 0xffff81023ea7ab40, timed out: EH_NOT_HANDLED
sas: command 0xffff81023ea7d6c0, task 0xffff81021888f3c0, timed out: EH_NOT_HANDLED
sas: command 0xffff81023de88bc0, task 0xffff81023d66bcc0, timed out: EH_NOT_HANDLED
sas: Enter sas_scsi_recover_host
sas: trying to find task 0xffff81023e85ee00
sas: sas_scsi_find_task: aborting task 0xffff81023e85ee00
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff81023e85ee00 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff81023e85ee00 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81023e85ee00 is done
sas: sas_eh_handle_sas_errors: task 0xffff81023e85ee00 is done
sas: trying to find task 0xffff810217a97500
sas: sas_scsi_find_task: aborting task 0xffff810217a97500
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff810217a97500 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: task 0xffff81023d66bcc0 done with opcode 0x0 resp 0x0 stat 0x0 but aborted by upper layer!
aic94xx: came back from clear nexus
aic94xx: task 0xffff810217a97500 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff810217a97500 is done
sas: sas_eh_handle_sas_errors: task 0xffff810217a97500 is done
sas: trying to find task 0xffff810217a7f540
sas: sas_scsi_find_task: aborting task 0xffff810217a7f540
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff810217a7f540 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff810217a7f540 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff810217a7f540 is done
sas: sas_eh_handle_sas_errors: task 0xffff810217a7f540 is done
sas: trying to find task 0xffff810217a97b00
sas: sas_scsi_find_task: aborting task 0xffff810217a97b00
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff810217a97b00 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff810217a97b00 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff810217a97b00 is done
sas: sas_eh_handle_sas_errors: task 0xffff810217a97b00 is done
sas: trying to find task 0xffff81023ea7a840
aic94xx: task 0xffff81023ea7ab40 done with opcode 0x0 resp 0x0 stat 0x0 but aborted by upper layer!
sas: sas_scsi_find_task: aborting task 0xffff81023ea7a840
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff81023ea7a840 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: task 0xffff81021888f3c0 done with opcode 0x0 resp 0x0 stat 0x0 but aborted by upper layer!
aic94xx: came back from clear nexus
aic94xx: task 0xffff81023ea7a840 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81023ea7a840 is done
sas: sas_eh_handle_sas_errors: task 0xffff81023ea7a840 is done
sas: trying to find task 0xffff8102189d6380
sas: sas_scsi_find_task: aborting task 0xffff8102189d6380
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff8102189d6380 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff8102189d6380 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff8102189d6380 is done
sas: sas_eh_handle_sas_errors: task 0xffff8102189d6380 is done
sas: trying to find task 0xffff81023dc5a0c0
sas: sas_scsi_find_task: aborting task 0xffff81023dc5a0c0
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff81023dc5a0c0 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff81023dc5a0c0 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81023dc5a0c0 is done
sas: sas_eh_handle_sas_errors: task 0xffff81023dc5a0c0 is done
sas: trying to find task 0xffff81023e85eb00
sas: sas_scsi_find_task: aborting task 0xffff81023e85eb00
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff81023e85eb00 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff81023e85eb00 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81023e85eb00 is done
sas: sas_eh_handle_sas_errors: task 0xffff81023e85eb00 is done
sas: trying to find task 0xffff81023dc5a6c0
sas: sas_scsi_find_task: aborting task 0xffff81023dc5a6c0
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff81023dc5a6c0 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff81023dc5a6c0 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81023dc5a6c0 is done
sas: sas_eh_handle_sas_errors: task 0xffff81023dc5a6c0 is done
sas: trying to find task 0xffff81023eae8380
sas: sas_scsi_find_task: aborting task 0xffff81023eae8380
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff81023eae8380 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff81023eae8380 aborted, res: 0x0
aic94xx: task 0xffff81023ea7a0c0 done with opcode 0x0 resp 0x0 stat 0x0 but aborted by upper layer!
sas: sas_scsi_find_task: task 0xffff81023eae8380 is done
sas: sas_eh_handle_sas_errors: task 0xffff81023eae8380 is done
sas: trying to find task 0xffff81023ea7a0c0
sas: sas_scsi_find_task: aborting task 0xffff81023ea7a0c0
aic94xx: task 0xffff81023dc51680 done with opcode 0x0 resp 0x0 stat 0x0 but aborted by upper layer!
aic94xx: asd_abort_task: task 0xffff81023ea7a0c0 done
aic94xx: task 0xffff81023ea7a0c0 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81023ea7a0c0 is done
aic94xx: task 0xffff81023dc51200 done with opcode 0x0 resp 0x0 stat 0x0 but aborted by upper layer!
sas: sas_eh_handle_sas_errors: task 0xffff81023ea7a0c0 is done
sas: trying to find task 0xffff81023eae8b00
sas: sas_scsi_find_task: aborting task 0xffff81023eae8b00
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff81023eae8b00 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff81023eae8b00 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81023eae8b00 is done
sas: sas_eh_handle_sas_errors: task 0xffff81023eae8b00 is done
sas: trying to find task 0xffff81023dc51680
sas: sas_scsi_find_task: aborting task 0xffff81023dc51680
aic94xx: asd_abort_task: task 0xffff81023dc51680 done
aic94xx: task 0xffff81023dc51680 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81023dc51680 is done
sas: sas_eh_handle_sas_errors: task 0xffff81023dc51680 is done
sas: trying to find task 0xffff81023dc51200
sas: sas_scsi_find_task: aborting task 0xffff81023dc51200
aic94xx: asd_abort_task: task 0xffff81023dc51200 done
aic94xx: task 0xffff81023dc51200 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81023dc51200 is done
sas: sas_eh_handle_sas_errors: task 0xffff81023dc51200 is done
sas: trying to find task 0xffff81023dc51e00
sas: sas_scsi_find_task: aborting task 0xffff81023dc51e00
aic94xx: tmf tasklet complete
aic94xx: tmf resp tasklet
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_tag: PRE
aic94xx: asd_clear_nexus_tag: POST
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
aic94xx: task 0xffff81023dc51e00 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff81023dc51e00 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81023dc51e00 is done
sas: sas_eh_handle_sas_errors: task 0xffff81023dc51e00 is done
sas: trying to find task 0xffff81023ea7ab40
sas: sas_scsi_find_task: aborting task 0xffff81023ea7ab40
aic94xx: asd_abort_task: task 0xffff81023ea7ab40 done
aic94xx: task 0xffff81023ea7ab40 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81023ea7ab40 is done
sas: sas_eh_handle_sas_errors: task 0xffff81023ea7ab40 is done
sas: trying to find task 0xffff81021888f3c0
sas: sas_scsi_find_task: aborting task 0xffff81021888f3c0
aic94xx: asd_abort_task: task 0xffff81021888f3c0 done
aic94xx: task 0xffff81021888f3c0 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81021888f3c0 is done
sas: sas_eh_handle_sas_errors: task 0xffff81021888f3c0 is done
sas: trying to find task 0xffff81023d66bcc0
sas: sas_scsi_find_task: aborting task 0xffff81023d66bcc0
aic94xx: asd_abort_task: task 0xffff81023d66bcc0 done
aic94xx: task 0xffff81023d66bcc0 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81023d66bcc0 is done
sas: sas_eh_handle_sas_errors: task 0xffff81023d66bcc0 is done
sas: --- Exit sas_scsi_recover_host

--------------050802040202080107060309--
