From: Ilia Mirkin <imirkin@alum.mit.edu>
Subject: mvsas panic
Date: Sun, 28 Feb 2010 22:28:28 -0500
Message-ID: <87d699441002281928u7e57f4a1saacddd020a6d6c3f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016364ec92cb45ff50480b4d7aa
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40578 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab0CAD23 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2010 22:28:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

--0016364ec92cb45ff50480b4d7aa
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I had earlier e-mailed about an apparent NCQ vs non-NCQ command issue
on this machine in mvsas/libsas that didn't get any attention
(http://kerneltrap.org/mailarchive/linux-scsi/2010/1/24/6725113), but
now I've run into a crash/panic issue as well... perhaps related which
is why I mention it.

Unfortunately I don't have a full backtrace, but I'm going to try to
reproduce it tonight with netconsole set up.

Attached is a screenshot of the crash; the visible part of the trace
goes something like

mvs_interrupt
mvs_64xx_isr
mvs_int_full
mvs_int_rx
scsi_io_completion
mvs_slot_compete
sas_ata_task_done
ata_qc_complete
__ata_qc_complete
ata_sg_clean
swiotlb_unmap_sg_attrs
... and then it cuts off.

After this the machine was completely unresponsive, didn't even ping.
Please let me know if you have any ideas for figuring out what's wrong
here, if there's something I should test, etc. I noticed that there
were a bunch of patches a few months ago for mvsas, but they were
never merged... should I try those? I checked the commits that went
into 2.6.33, that didn't seem to have any relevant changes to mvsas,
libsas, or libata core features, but I can try that too if you think
it's likely to help things out.

The workload that triggered this was just dd reading and writing
(simultaneously) to 11 of the disks (/dev/zero -> disk, disk ->
/dev/null, bs=1M).

Some information about the machine:

Supermicro X8DTE, 2x L5520 cpu, 24G ram (12G per cpu). Areca 1300ix-16
controller, with 12 drives attached.

Various virtualization features enabled in bios, like VT-d, SR-IOV,
etc (none of which I'm using, but wanted to play with at some point).
Boot log below.

lspci -vvvnx -s 07:00.0
07:00.0 0100: 17d3:1300 (rev 02)
        Subsystem: 17d3:1300
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 256 bytes
        Interrupt: pin A routed to IRQ 16
        Region 2: I/O ports at ec00 [size=128]
        Region 4: Memory at fafff000 (64-bit, non-prefetchable) [size=4K]
        Expansion ROM at faf80000 [disabled] [size=256K]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA
PME(D0+,D1+,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
unlimited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 2048 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
                LnkCap: Port #2, Speed 2.5GT/s, Width x4, ASPM L0s,
Latency L0 <256ns, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                AERCap: First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
        Kernel driver in use: mvsas


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32-gentoo-r1 (root@storage) (gcc
version 4.3.4 (Gentoo 4.3.4 p1.0, pie-10.1.5) ) #2 SMP Mon Jan 11
11:59:22 EST 2010
[    0.000000] Command line: root=/dev/sda1 ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000096c00 (usable)
[    0.000000]  BIOS-e820: 0000000000096c00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf760000 (usable)
[    0.000000]  BIOS-e820: 00000000bf76e000 - 00000000bf770000 type 9
[    0.000000]  BIOS-e820: 00000000bf770000 - 00000000bf77e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf77e000 - 00000000bf7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf7ec000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fbf00000 - 00000000ff000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000640000000 (usable)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] last_pfn = 0x640000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-E7FFF write-through
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FC00000000 write-back
[    0.000000]   1 base 0400000000 mask FE00000000 write-back
[    0.000000]   2 base 0600000000 mask FFC0000000 write-back
[    0.000000]   3 base 00C0000000 mask FFC0000000 uncachable
[    0.000000]   4 base 00BF800000 mask FFFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bf800000 - 0000000100000000
(usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf760 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 0000000000096c00 (usable)
[    0.000000]  modified: 0000000000096c00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bf760000 (usable)
[    0.000000]  modified: 00000000bf76e000 - 00000000bf770000 type 9
[    0.000000]  modified: 00000000bf770000 - 00000000bf77e000 (ACPI data)
[    0.000000]  modified: 00000000bf77e000 - 00000000bf7d0000 (ACPI NVS)
[    0.000000]  modified: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
[    0.000000]  modified: 00000000bf7ec000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fbf00000 - 00000000ff000000 (reserved)
[    0.000000]  modified: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000640000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf760000
[    0.000000]  0000000000 - 00bf600000 page 2M
[    0.000000]  00bf600000 - 00bf760000 page 4k
[    0.000000] kernel direct mapping tables up to bf760000 @ 10000-15000
[    0.000000] init_memory_mapping: 0000000100000000-0000000640000000
[    0.000000]  0100000000 - 0640000000 page 2M
[    0.000000] kernel direct mapping tables up to 640000000 @ 13000-2d000
[    0.000000] ACPI: RSDP 00000000000fa240 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf770100 00084 (v01 080809 XSDT1324
20090808 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf770290 000F4 (v04 080809 FACP1324
20090808 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf7704b0 058A5 (v02  1XDT6 1XDT6003
00000003 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf77e000 00040
[    0.000000] ACPI: APIC 00000000bf770390 000D2 (v02 080809 APIC1324
20090808 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf770470 0003C (v01 080809 OEMMCFG
20090808 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf77e040 0007A (v01 080809 OEMB1324
20090808 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000bf77a4b0 001D0 (v02 080809 OEMSRAT
00000001 INTL 00000001)
[    0.000000] ACPI: HPET 00000000bf77a680 00038 (v01 080809 OEMHPET
20090808 MSFT 00000097)
[    0.000000] ACPI: DMAR 00000000bf77e0c0 00128 (v01    AMI  OEMDMAR
00000001 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf781700 00363 (v01 DpgPmm    CpuPm
00000012 INTL 20051117)
[    0.000000] ACPI: EINJ 00000000bf77a6c0 00130 (v01  AMIER AMI_EINJ
20090808 MSFT 00000097)
[    0.000000] ACPI: BERT 00000000bf77a850 00030 (v01  AMIER AMI_BERT
20090808 MSFT 00000097)
[    0.000000] ACPI: ERST 00000000bf77a880 001B0 (v01  AMIER AMI_ERST
20090808 MSFT 00000097)
[    0.000000] ACPI: HEST 00000000bf77aa30 000A8 (v01  AMIER AMI_HEST
20090808 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 2 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 4 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 6 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 3 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 5 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 7 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 16 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 18 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 17 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 19 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 23 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] SRAT: Node 0 PXM 0 100000-c0000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-340000000
[    0.000000] SRAT: Node 1 PXM 1 340000000-640000000
[    0.000000] NUMA: Allocated memnodemap from 28000 - 34840
[    0.000000] NUMA: Using 20 for the hash shift.
[    0.000000] Bootmem setup node 0 0000000000000000-0000000340000000
[    0.000000]   NODE_DATA [0000000000034840 - 000000000003683f]
[    0.000000]   bootmap [0000000000100000 -  0000000000167fff] pages 68
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0340000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==>
[0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001852284]    TEXT DATA BSS ==>
[0001000000 - 0001852284]
[    0.000000]   #3 [0000096c00 - 0000100000]    BIOS reserved ==>
[0000096c00 - 0000100000]
[    0.000000]   #4 [0001853000 - 00018531b8]              BRK ==>
[0001853000 - 00018531b8]
[    0.000000]   #5 [0000010000 - 0000013000]          PGTABLE ==>
[0000010000 - 0000013000]
[    0.000000]   #6 [0000013000 - 0000028000]          PGTABLE ==>
[0000013000 - 0000028000]
[    0.000000]   #7 [0000028000 - 0000034840]       MEMNODEMAP ==>
[0000028000 - 0000034840]
[    0.000000] Bootmem setup node 1 0000000340000000-0000000640000000
[    0.000000]   NODE_DATA [0000000340000000 - 0000000340001fff]
[    0.000000]   bootmap [0000000340002000 -  0000000340061fff] pages 60
[    0.000000] (8 early reservations) ==> bootmem [0340000000 - 0640000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0001000000 - 0001852284]    TEXT DATA BSS
[    0.000000]   #3 [0000096c00 - 0000100000]    BIOS reserved
[    0.000000]   #4 [0001853000 - 00018531b8]              BRK
[    0.000000]   #5 [0000010000 - 0000013000]          PGTABLE
[    0.000000]   #6 [0000013000 - 0000028000]          PGTABLE
[    0.000000]   #7 [0000028000 - 0000034840]       MEMNODEMAP
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000]  [ffffea0000000000-ffffea000b5fffff] PMD ->
[ffff880028600000-ffff880032dfffff] on node 0
[    0.000000]  [ffffea000b600000-ffffea0015dfffff] PMD ->
[ffff880340200000-ffff88034a9fffff] on node 1
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00640000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000096
[    0.000000]     0: 0x00000100 -> 0x000bf760
[    0.000000]     0: 0x00100000 -> 0x00340000
[    0.000000]     1: 0x00340000 -> 0x00640000
[    0.000000] On node 0 totalpages: 3143398
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 144 pages reserved
[    0.000000]   DMA zone: 3774 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 765848 pages, LIFO batch:31
[    0.000000]   Normal zone: 32256 pages used for memmap
[    0.000000]   Normal zone: 2327040 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 3145728
[    0.000000]   Normal zone: 43008 pages used for memmap
[    0.000000]   Normal zone: 3102720 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] SMP: Allowing 16 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at c0000000 (gap:
c0000000:20000000)
[    0.000000] NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:16 nr_node_ids:2
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880028200000 s83480
r8192 d23016 u262144
[    0.000000] pcpu-alloc: s83480 r8192 d23016 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 08 09 10 11 [1] 04 05 06 07
12 13 14 15
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.
Total pages: 6199382
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sda1 ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff880020000000 -
ffff880024000000
[    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.000000] Memory: 24735632k/26214400k available (4631k kernel
code, 1057896k absent, 420872k reserved, 2538k data, 452k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0,
CPUs=16, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:536
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2260.970 MHz processor.
[    0.000006] Calibrating delay loop (skipped), value calculated
using timer frequency.. 4521.94 BogoMIPS (lpj=2260970)
[    0.000530] Security Framework initialized
[    0.003406] Dentry cache hash table entries: 4194304 (order: 13,
33554432 bytes)
[    0.016954] Inode-cache hash table entries: 2097152 (order: 12,
16777216 bytes)
[    0.020808] Mount-cache hash table entries: 256
[    0.021223] Initializing cgroup subsys ns
[    0.021483] Initializing cgroup subsys cpuacct
[    0.021737] Initializing cgroup subsys freezer
[    0.022005] CPU: Physical Processor ID: 0
[    0.022259] CPU: Processor Core ID: 0
[    0.022507] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.022798] CPU: L2 cache: 256K
[    0.023045] CPU: L3 cache: 8192K
[    0.023301] CPU 0/0x0 -> Node 0
[    0.023549] mce: CPU supports 9 MCE banks
[    0.023809] CPU0: Thermal monitoring enabled (TM1)
[    0.024061] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
[    0.024579] using mwait in idle threads.
[    0.024827] Performance Events: Nehalem/Corei7 events, Intel PMU driver.
[    0.025166] ... version:                3
[    0.025422] ... bit width:              48
[    0.025670] ... generic registers:      4
[    0.025917] ... value mask:             0000ffffffffffff
[    0.026167] ... max period:             000000007fffffff
[    0.026423] ... fixed-purpose events:   3
[    0.026670] ... event mask:             000000070000000f
[    0.026937] ACPI: Core revision 20090903
[    0.058192] Setting APIC routing to physical flat
[    0.058620]   alloc irq_desc for 20 on node 0
[    0.058622]   alloc kstat_irqs on node 0
[    0.058764] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.068996] CPU0: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz stepping 05
[    0.171048] Booting processor 1 APIC 0x2 ip 0x6000
[    0.181911] Initializing CPU#1
[    0.241782] Calibrating delay using timer specific routine..
4521.21 BogoMIPS (lpj=2260606)
[    0.241790] CPU: Physical Processor ID: 0
[    0.241791] CPU: Processor Core ID: 1
[    0.241794] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.241795] CPU: L2 cache: 256K
[    0.241796] CPU: L3 cache: 8192K
[    0.241799] CPU 1/0x2 -> Node 0
[    0.241814] CPU1: Thermal monitoring enabled (TM1)
[    0.241818] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.241896] CPU1: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz stepping 05
[    0.244908] Skipping synchronization checks as TSC is reliable.
[    0.245234] Booting processor 2 APIC 0x4 ip 0x6000
[    0.255852] Initializing CPU#2
[    0.315622] Calibrating delay using timer specific routine..
4521.22 BogoMIPS (lpj=2260611)
[    0.315630] CPU: Physical Processor ID: 0
[    0.315631] CPU: Processor Core ID: 2
[    0.315633] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.315635] CPU: L2 cache: 256K
[    0.315636] CPU: L3 cache: 8192K
[    0.315639] CPU 2/0x4 -> Node 0
[    0.315653] CPU2: Thermal monitoring enabled (TM1)
[    0.315657] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.315681] CPU2: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz stepping 05
[    0.318780] Booting processor 3 APIC 0x6 ip 0x6000
[    0.329396] Initializing CPU#3
[    0.389462] Calibrating delay using timer specific routine..
4521.21 BogoMIPS (lpj=2260608)
[    0.389470] CPU: Physical Processor ID: 0
[    0.389471] CPU: Processor Core ID: 3
[    0.389474] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.389475] CPU: L2 cache: 256K
[    0.389477] CPU: L3 cache: 8192K
[    0.389479] CPU 3/0x6 -> Node 0
[    0.389493] CPU3: Thermal monitoring enabled (TM1)
[    0.389496] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.389571] CPU3: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz stepping 05
[    0.392671] Booting processor 4 APIC 0x10 ip 0x6000
[    0.403286] Initializing CPU#4
[    0.463303] Calibrating delay using timer specific routine..
4521.25 BogoMIPS (lpj=2260625)
[    0.463310] CPU: Physical Processor ID: 1
[    0.463312] CPU: Processor Core ID: 0
[    0.463314] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.463316] CPU: L2 cache: 256K
[    0.463317] CPU: L3 cache: 8192K
[    0.463320] CPU 4/0x10 -> Node 1
[    0.463336] CPU4: Thermal monitoring enabled (TM1)
[    0.463339] CPU 4 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
[    0.463419] CPU4: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz stepping 05
[    0.466490] Booting processor 5 APIC 0x12 ip 0x6000
[    0.477108] Initializing CPU#5
[    0.537143] Calibrating delay using timer specific routine..
4521.23 BogoMIPS (lpj=2260619)
[    0.537151] CPU: Physical Processor ID: 1
[    0.537153] CPU: Processor Core ID: 1
[    0.537156] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.537158] CPU: L2 cache: 256K
[    0.537159] CPU: L3 cache: 8192K
[    0.537162] CPU 5/0x12 -> Node 1
[    0.537179] CPU5: Thermal monitoring enabled (TM1)
[    0.537183] CPU 5 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.537280] CPU5: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz stepping 05
[    0.540356] Booting processor 6 APIC 0x14 ip 0x6000
[    0.550972] Initializing CPU#6
[    0.610983] Calibrating delay using timer specific routine..
4521.25 BogoMIPS (lpj=2260629)
[    0.610992] CPU: Physical Processor ID: 1
[    0.610993] CPU: Processor Core ID: 2
[    0.610996] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.610998] CPU: L2 cache: 256K
[    0.610999] CPU: L3 cache: 8192K
[    0.611002] CPU 6/0x14 -> Node 1
[    0.611019] CPU6: Thermal monitoring enabled (TM1)
[    0.611022] CPU 6 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.611103] CPU6: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz stepping 05
[    0.614168] Booting processor 7 APIC 0x16 ip 0x6000
[    0.624783] Initializing CPU#7
[    0.684823] Calibrating delay using timer specific routine..
4521.26 BogoMIPS (lpj=2260633)
[    0.684832] CPU: Physical Processor ID: 1
[    0.684833] CPU: Processor Core ID: 3
[    0.684836] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.684838] CPU: L2 cache: 256K
[    0.684839] CPU: L3 cache: 8192K
[    0.684843] CPU 7/0x16 -> Node 1
[    0.684858] CPU7: Thermal monitoring enabled (TM1)
[    0.684862] CPU 7 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.684912] CPU7: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz stepping 05
[    0.687980] Booting processor 8 APIC 0x1 ip 0x6000
[    0.698592] Initializing CPU#8
[    0.758663] Calibrating delay using timer specific routine..
4521.26 BogoMIPS (lpj=2260630)
[    0.758671] CPU: Physical Processor ID: 0
[    0.758672] CPU: Processor Core ID: 0
[    0.758675] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.758677] CPU: L2 cache: 256K
[    0.758678] CPU: L3 cache: 8192K
[    0.758681] CPU 8/0x1 -> Node 0
[    0.758693] CPU8: Thermal monitoring enabled (TM1)
[    0.758696] CPU 8 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.758732] CPU8: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz stepping 05
[    0.761813] Booting processor 9 APIC 0x3 ip 0x6000
[    0.772410] Initializing CPU#9
[    0.832503] Calibrating delay using timer specific routine..
4521.26 BogoMIPS (lpj=2260631)
[    0.832509] CPU: Physical Processor ID: 0
[    0.832511] CPU: Processor Core ID: 1
[    0.832513] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.832514] CPU: L2 cache: 256K
[    0.832515] CPU: L3 cache: 8192K
[    0.832517] CPU 9/0x3 -> Node 0
[    0.832528] CPU9: Thermal monitoring enabled (TM1)
[    0.832530] CPU 9 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.832553] CPU9: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz stepping 05
[    0.835639] Booting processor 10 APIC 0x5 ip 0x6000
[    0.846237] Initializing CPU#10
[    0.906343] Calibrating delay using timer specific routine..
4521.26 BogoMIPS (lpj=2260630)
[    0.906349] CPU: Physical Processor ID: 0
[    0.906350] CPU: Processor Core ID: 2
[    0.906353] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.906354] CPU: L2 cache: 256K
[    0.906355] CPU: L3 cache: 8192K
[    0.906357] CPU 10/0x5 -> Node 0
[    0.906367] CPU10: Thermal monitoring enabled (TM1)
[    0.906370] CPU 10 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.906463] CPU10: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
stepping 05
[    0.909749] Booting processor 11 APIC 0x7 ip 0x6000
[    0.920347] Initializing CPU#11
[    0.980183] Calibrating delay using timer specific routine..
4521.24 BogoMIPS (lpj=2260621)
[    0.980189] CPU: Physical Processor ID: 0
[    0.980190] CPU: Processor Core ID: 3
[    0.980193] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.980194] CPU: L2 cache: 256K
[    0.980195] CPU: L3 cache: 8192K
[    0.980197] CPU 11/0x7 -> Node 0
[    0.980207] CPU11: Thermal monitoring enabled (TM1)
[    0.980210] CPU 11 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.980295] CPU11: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
stepping 05
[    0.983585] Booting processor 12 APIC 0x11 ip 0x6000
[    0.994184] Initializing CPU#12
[    1.054024] Calibrating delay using timer specific routine..
4521.25 BogoMIPS (lpj=2260629)
[    1.054030] CPU: Physical Processor ID: 1
[    1.054031] CPU: Processor Core ID: 0
[    1.054033] CPU: L1 I cache: 32K, L1 D cache: 32K
[    1.054035] CPU: L2 cache: 256K
[    1.054036] CPU: L3 cache: 8192K
[    1.054038] CPU 12/0x11 -> Node 1
[    1.054049] CPU12: Thermal monitoring enabled (TM1)
[    1.054051] CPU 12 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    1.054128] CPU12: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
stepping 05
[    1.062326] Booting processor 13 APIC 0x13 ip 0x6000
[    1.072925] Initializing CPU#13
[    1.132853] Calibrating delay using timer specific routine..
4521.26 BogoMIPS (lpj=2260633)
[    1.132860] CPU: Physical Processor ID: 1
[    1.132861] CPU: Processor Core ID: 1
[    1.132864] CPU: L1 I cache: 32K, L1 D cache: 32K
[    1.132865] CPU: L2 cache: 256K
[    1.132866] CPU: L3 cache: 8192K
[    1.132869] CPU 13/0x13 -> Node 1
[    1.132881] CPU13: Thermal monitoring enabled (TM1)
[    1.132884] CPU 13 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    1.132969] CPU13: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
stepping 05
[    1.136224] Booting processor 14 APIC 0x15 ip 0x6000
[    1.148755] Initializing CPU#14
[    1.207691] Calibrating delay using timer specific routine..
4521.26 BogoMIPS (lpj=2260631)
[    1.207698] CPU: Physical Processor ID: 1
[    1.207699] CPU: Processor Core ID: 2
[    1.207702] CPU: L1 I cache: 32K, L1 D cache: 32K
[    1.207703] CPU: L2 cache: 256K
[    1.207704] CPU: L3 cache: 8192K
[    1.207707] CPU 14/0x15 -> Node 1
[    1.207719] CPU14: Thermal monitoring enabled (TM1)
[    1.207722] CPU 14 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    1.207794] CPU14: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
stepping 05
[    1.211055] Booting processor 15 APIC 0x17 ip 0x6000
[    1.221650] Initializing CPU#15
[    1.281531] Calibrating delay using timer specific routine..
4521.26 BogoMIPS (lpj=2260631)
[    1.281538] CPU: Physical Processor ID: 1
[    1.281539] CPU: Processor Core ID: 3
[    1.281542] CPU: L1 I cache: 32K, L1 D cache: 32K
[    1.281543] CPU: L2 cache: 256K
[    1.281544] CPU: L3 cache: 8192K
[    1.281547] CPU 15/0x17 -> Node 1
[    1.281558] CPU15: Thermal monitoring enabled (TM1)
[    1.281561] CPU 15 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    1.281596] CPU15: Intel(R) Xeon(R) CPU           L5520  @ 2.27GHz
stepping 05
[    1.284816] Brought up 16 CPUs
[    1.285064] Total of 16 processors activated (72340.67 BogoMIPS).
[    1.292471] khelper used greatest stack depth: 5888 bytes left
[    1.293016] NET: Registered protocol family 16
[    1.293693] ACPI: bus type pci registered
[    1.294072] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    1.294324] PCI: MCFG area at e0000000 reserved in E820
[    1.302429] PCI: Using MMCONFIG at e0000000 - efffffff
[    1.302680] PCI: Using configuration type 1 for base access
[    1.310691] bio: create slab <bio-0> at 0
[    1.311904] ACPI: EC: Look up EC in DSDT
[    1.314657] ACPI: Executed 1 blocks of module-level executable AML code
[    1.322124] ACPI: Interpreter enabled
[    1.322371] ACPI: (supports S0 S5)
[    1.322706] ACPI: Using IOAPIC for interrupt routing
[    1.336345] ACPI: No dock devices found.
[    1.336743] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.337110] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.337368] pci 0000:00:00.0: PME# disabled
[    1.337675] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.337929] pci 0000:00:01.0: PME# disabled
[    1.338235] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.338487] pci 0000:00:03.0: PME# disabled
[    1.338792] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    1.339047] pci 0000:00:05.0: PME# disabled
[    1.339354] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    1.339606] pci 0000:00:07.0: PME# disabled
[    1.339912] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    1.340166] pci 0000:00:09.0: PME# disabled
[    1.341082] pci 0000:00:16.0: reg 10 64bit mmio: [0xf9ff4000-0xf9ff7fff]
[    1.341139] pci 0000:00:16.1: reg 10 64bit mmio: [0xf9ff0000-0xf9ff3fff]
[    1.341197] pci 0000:00:16.2: reg 10 64bit mmio: [0xf9fec000-0xf9feffff]
[    1.341254] pci 0000:00:16.3: reg 10 64bit mmio: [0xf9fe8000-0xf9febfff]
[    1.341310] pci 0000:00:16.4: reg 10 64bit mmio: [0xf9fe4000-0xf9fe7fff]
[    1.341365] pci 0000:00:16.5: reg 10 64bit mmio: [0xf9fe0000-0xf9fe3fff]
[    1.341421] pci 0000:00:16.6: reg 10 64bit mmio: [0xf9fdc000-0xf9fdffff]
[    1.341477] pci 0000:00:16.7: reg 10 64bit mmio: [0xf9fd8000-0xf9fdbfff]
[    1.341554] pci 0000:00:1a.0: reg 20 io port: [0xb400-0xb41f]
[    1.341617] pci 0000:00:1a.1: reg 20 io port: [0xb080-0xb09f]
[    1.341680] pci 0000:00:1a.2: reg 20 io port: [0xb000-0xb01f]
[    1.341749] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf9ffa000-0xf9ffa3ff]
[    1.341799] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    1.342054] pci 0000:00:1a.7: PME# disabled
[    1.342364] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.342617] pci 0000:00:1c.0: PME# disabled
[    1.342926] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.343183] pci 0000:00:1c.4: PME# disabled
[    1.343487] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.343742] pci 0000:00:1c.5: PME# disabled
[    1.344039] pci 0000:00:1d.0: reg 20 io port: [0xb880-0xb89f]
[    1.344103] pci 0000:00:1d.1: reg 20 io port: [0xb800-0xb81f]
[    1.344168] pci 0000:00:1d.2: reg 20 io port: [0xb480-0xb49f]
[    1.344235] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf9ffc000-0xf9ffc3ff]
[    1.344286] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.344540] pci 0000:00:1d.7: PME# disabled
[    1.344900] pci 0000:00:1f.0: quirk: region 0800-087f claimed by
ICH6 ACPI/GPIO/TCO
[    1.345358] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    1.345614] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at
164c (mask 0007)
[    1.346066] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at
03e8 (mask 0007)
[    1.346518] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at
0290 (mask 001f)
[    1.346969] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at
0ca0 (mask 000f)
[    1.347458] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf9ffe000-0xf9ffe0ff]
[    1.347471] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    1.347576] pci 0000:07:00.0: reg 18 io port: [0xec00-0xec7f]
[    1.347589] pci 0000:07:00.0: reg 20 64bit mmio: [0xfafff000-0xfaffffff]
[    1.347595] pci 0000:07:00.0: reg 30 32bit mmio pref: [0xfaf80000-0xfafbffff]
[    1.347616] pci 0000:07:00.0: supports D1
[    1.347618] pci 0000:07:00.0: PME# supported from D0 D1 D3hot
[    1.347870] pci 0000:07:00.0: PME# disabled
[    1.348148] pci 0000:00:05.0: bridge io port: [0xe000-0xefff]
[    1.348151] pci 0000:00:05.0: bridge 32bit mmio: [0xfaf00000-0xfaffffff]
[    1.348306] pci 0000:03:00.0: reg 10 32bit mmio: [0xfade0000-0xfadfffff]
[    1.348325] pci 0000:03:00.0: reg 18 io port: [0xcc00-0xcc1f]
[    1.348336] pci 0000:03:00.0: reg 1c 32bit mmio: [0xfaddc000-0xfaddffff]
[    1.348413] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.348670] pci 0000:03:00.0: PME# disabled
[    1.348975] pci 0000:00:1c.4: bridge io port: [0xc000-0xcfff]
[    1.348979] pci 0000:00:1c.4: bridge 32bit mmio: [0xfad00000-0xfadfffff]
[    1.349045] pci 0000:04:00.0: reg 10 32bit mmio: [0xfaee0000-0xfaefffff]
[    1.349064] pci 0000:04:00.0: reg 18 io port: [0xdc00-0xdc1f]
[    1.349074] pci 0000:04:00.0: reg 1c 32bit mmio: [0xfaedc000-0xfaedffff]
[    1.349154] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    1.349410] pci 0000:04:00.0: PME# disabled
[    1.349716] pci 0000:00:1c.5: bridge io port: [0xd000-0xdfff]
[    1.349719] pci 0000:00:1c.5: bridge 32bit mmio: [0xfae00000-0xfaefffff]
[    1.349758] pci 0000:01:03.0: reg 10 32bit mmio pref: [0xf8000000-0xf8ffffff]
[    1.349764] pci 0000:01:03.0: reg 14 32bit mmio: [0xfacfc000-0xfacfffff]
[    1.349770] pci 0000:01:03.0: reg 18 32bit mmio: [0xfa000000-0xfa7fffff]
[    1.349842] pci 0000:00:1e.0: transparent bridge
[    1.350094] pci 0000:00:1e.0: bridge 32bit mmio: [0xfa000000-0xfacfffff]
[    1.350099] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xf8000000-0xf8ffffff]
[    1.350132] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.350441] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    1.350532] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    1.350597] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[    1.350640] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    1.350682] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
[    1.350742] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
[    1.350800] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE5._PRT]
[    1.350857] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
[    1.350914] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9._PRT]
[    1.365905] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 *11 12 14 15)
[    1.366731] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 *10 11 12 14 15)
[    1.367550] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12 14 *15)
[    1.368369] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 *7 10 11 12 14 15)
[    1.369185] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12
14 15) *0, disabled.
[    1.370292] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *6 7 10 11 12 14 15)
[    1.371112] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 7 10 11 12
14 15) *0, disabled.
[    1.372216] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 11 12 *14 15)
[    1.373134] vgaarb: device added:
PCI:0000:01:03.0,decodes=io+mem,owns=io+mem,locks=none
[    1.373593] vgaarb: loaded
[    1.374034] SCSI subsystem initialized
[    1.374618] libata version 3.00 loaded.
[    1.374758] usbcore: registered new interface driver usbfs
[    1.375057] usbcore: registered new interface driver hub
[    1.375373] usbcore: registered new device driver usb
[    1.375937] PCI: Using ACPI for IRQ routing
[    1.376487] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.376947] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    1.391735] Switching to clocksource tsc
[    1.394331] pnp: PnP ACPI init
[    1.394593] ACPI: bus type pnp registered
[    1.400924] pnp: PnP ACPI: found 16 devices
[    1.401173] ACPI: ACPI bus type pnp unregistered
[    1.401431] system 00:01: iomem range 0xfbf00000-0xfbffffff has been reserved
[    1.401690] system 00:01: iomem range 0xfc000000-0xfcffffff has been reserved
[    1.401945] system 00:01: iomem range 0xfd000000-0xfdffffff has been reserved
[    1.402203] system 00:01: iomem range 0xfe000000-0xfebfffff has been reserved
[    1.402459] system 00:01: iomem range 0xfec8a000-0xfec8afff has been reserved
[    1.402715] system 00:01: iomem range 0xfed10000-0xfed10fff has been reserved
[    1.402974] system 00:09: ioport range 0x164e-0x164f has been reserved
[    1.403228] system 00:0a: ioport range 0x680-0x6ff has been reserved
[    1.403482] system 00:0a: ioport range 0x295-0x296 has been reserved
[    1.403737] system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
[    1.403988] system 00:0b: ioport range 0x800-0x87f has been reserved
[    1.404240] system 00:0b: ioport range 0x500-0x57f could not be reserved
[    1.404494] system 00:0b: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    1.404750] system 00:0b: iomem range 0xfed20000-0xfed3ffff has been reserved
[    1.405004] system 00:0b: iomem range 0xfed40000-0xfed8ffff has been reserved
[    1.405260] system 00:0d: iomem range 0xfec00000-0xfec00fff could
not be reserved
[    1.405719] system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
[    1.405976] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
[    1.406233] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
[    1.406488] system 00:0f: iomem range 0xc0000-0xcffff has been reserved
[    1.406743] system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
[    1.406997] system 00:0f: iomem range 0x100000-0xbf8fffff could not
be reserved
[    1.407456] system 00:0f: iomem range 0xfed90000-0xffffffff could
not be reserved
[    1.412572] pci 0000:00:01.0: PCI bridge, secondary bus 0000:09
[    1.412823] pci 0000:00:01.0:   IO window: disabled
[    1.413076] pci 0000:00:01.0:   MEM window: disabled
[    1.413328] pci 0000:00:01.0:   PREFETCH window: disabled
[    1.413582] pci 0000:00:03.0: PCI bridge, secondary bus 0000:08
[    1.413834] pci 0000:00:03.0:   IO window: disabled
[    1.414087] pci 0000:00:03.0:   MEM window: disabled
[    1.414337] pci 0000:00:03.0:   PREFETCH window: disabled
[    1.414594] pci 0000:00:05.0: PCI bridge, secondary bus 0000:07
[    1.414848] pci 0000:00:05.0:   IO window: 0xe000-0xefff
[    1.415102] pci 0000:00:05.0:   MEM window: 0xfaf00000-0xfaffffff
[    1.415358] pci 0000:00:05.0:   PREFETCH window: disabled
[    1.415615] pci 0000:00:07.0: PCI bridge, secondary bus 0000:06
[    1.415867] pci 0000:00:07.0:   IO window: disabled
[    1.416119] pci 0000:00:07.0:   MEM window: disabled
[    1.416371] pci 0000:00:07.0:   PREFETCH window: disabled
[    1.416627] pci 0000:00:09.0: PCI bridge, secondary bus 0000:05
[    1.416879] pci 0000:00:09.0:   IO window: disabled
[    1.417134] pci 0000:00:09.0:   MEM window: disabled
[    1.417384] pci 0000:00:09.0:   PREFETCH window: disabled
[    1.417637] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    1.417888] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    1.418139] pci 0000:00:1c.0:   MEM window: 0xc0000000-0xc01fffff
[    1.423343] pci 0000:00:1c.0:   PREFETCH window:
0x000000c0200000-0x000000c03fffff
[    1.423802] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:03
[    1.424056] pci 0000:00:1c.4:   IO window: 0xc000-0xcfff
[    1.424309] pci 0000:00:1c.4:   MEM window: 0xfad00000-0xfadfffff
[    1.424566] pci 0000:00:1c.4:   PREFETCH window:
0x000000c0400000-0x000000c05fffff
[    1.425025] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:04
[    1.425277] pci 0000:00:1c.5:   IO window: 0xd000-0xdfff
[    1.425531] pci 0000:00:1c.5:   MEM window: 0xfae00000-0xfaefffff
[    1.425784] pci 0000:00:1c.5:   PREFETCH window:
0x000000c0600000-0x000000c07fffff
[    1.426239] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
[    1.426492] pci 0000:00:1e.0:   IO window: disabled
[    1.426745] pci 0000:00:1e.0:   MEM window: 0xfa000000-0xfacfffff
[    1.426999] pci 0000:00:1e.0:   PREFETCH window:
0x000000f8000000-0x000000f8ffffff
[    1.427467] pci 0000:00:01.0: setting latency timer to 64
[    1.427474] pci 0000:00:03.0: setting latency timer to 64
[    1.427481] pci 0000:00:05.0: setting latency timer to 64
[    1.427487] pci 0000:00:07.0: setting latency timer to 64
[    1.427494] pci 0000:00:09.0: setting latency timer to 64
[    1.427501] pci 0000:00:1c.0: enabling device (0104 -> 0107)
[    1.427754]   alloc irq_desc for 17 on node -1
[    1.427755]   alloc kstat_irqs on node -1
[    1.427760] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.428015] pci 0000:00:1c.0: setting latency timer to 64
[    1.428022] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.428276] pci 0000:00:1c.4: setting latency timer to 64
[    1.428283]   alloc irq_desc for 16 on node -1
[    1.428284]   alloc kstat_irqs on node -1
[    1.428287] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.428545] pci 0000:00:1c.5: setting latency timer to 64
[    1.428550] pci 0000:00:1e.0: setting latency timer to 64
[    1.428554] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    1.428556] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    1.428559] pci_bus 0000:07: resource 0 io:  [0xe000-0xefff]
[    1.428561] pci_bus 0000:07: resource 1 mem: [0xfaf00000-0xfaffffff]
[    1.428563] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
[    1.428565] pci_bus 0000:02: resource 1 mem: [0xc0000000-0xc01fffff]
[    1.428567] pci_bus 0000:02: resource 2 pref mem [0xc0200000-0xc03fffff]
[    1.428569] pci_bus 0000:03: resource 0 io:  [0xc000-0xcfff]
[    1.428571] pci_bus 0000:03: resource 1 mem: [0xfad00000-0xfadfffff]
[    1.428573] pci_bus 0000:03: resource 2 pref mem [0xc0400000-0xc05fffff]
[    1.428575] pci_bus 0000:04: resource 0 io:  [0xd000-0xdfff]
[    1.428577] pci_bus 0000:04: resource 1 mem: [0xfae00000-0xfaefffff]
[    1.428579] pci_bus 0000:04: resource 2 pref mem [0xc0600000-0xc07fffff]
[    1.428581] pci_bus 0000:01: resource 1 mem: [0xfa000000-0xfacfffff]
[    1.428583] pci_bus 0000:01: resource 2 pref mem [0xf8000000-0xf8ffffff]
[    1.428585] pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
[    1.428587] pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffffffffffff]
[    1.428625] NET: Registered protocol family 2
[    1.429236] IP route cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    1.430982] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    1.433009] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.433446] TCP: Hash tables configured (established 524288 bind 65536)
[    1.433700] TCP reno registered
[    1.434095] NET: Registered protocol family 1
[    1.434809] RPC: Registered udp transport module.
[    1.435058] RPC: Registered tcp transport module.
[    1.435306] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.435735] pci 0000:01:03.0: Boot video device
[    1.435819] DMAR: Host address width 40
[    1.436068] DMAR: DRHD base: 0x000000fbffe000 flags: 0x1
[    1.436332] IOMMU fbffe000: ver 1:0 cap c90780106f0462 ecap f0207e
[    1.436588] DMAR: RMRR base: 0x000000000ec000 end: 0x000000000effff
[    1.436841] DMAR: RMRR base: 0x000000bf7ec000 end: 0x000000bf7fffff
[    1.437095] DMAR: ATSR flags: 0x0
[    1.443862] microcode: CPU0 sig=0x106a5, pf=0x1, revision=0x11
[    1.444122] microcode: CPU1 sig=0x106a5, pf=0x1, revision=0x11
[    1.444389] microcode: CPU2 sig=0x106a5, pf=0x1, revision=0x11
[    1.444647] microcode: CPU3 sig=0x106a5, pf=0x1, revision=0x11
[    1.444902] microcode: CPU4 sig=0x106a5, pf=0x1, revision=0x11
[    1.445158] microcode: CPU5 sig=0x106a5, pf=0x1, revision=0x11
[    1.445416] microcode: CPU6 sig=0x106a5, pf=0x1, revision=0x11
[    1.445674] microcode: CPU7 sig=0x106a5, pf=0x1, revision=0x11
[    1.445931] microcode: CPU8 sig=0x106a5, pf=0x1, revision=0x11
[    1.446190] microcode: CPU9 sig=0x106a5, pf=0x1, revision=0x11
[    1.446446] microcode: CPU10 sig=0x106a5, pf=0x1, revision=0x11
[    1.446701] microcode: CPU11 sig=0x106a5, pf=0x1, revision=0x11
[    1.446957] microcode: CPU12 sig=0x106a5, pf=0x1, revision=0x11
[    1.447216] microcode: CPU13 sig=0x106a5, pf=0x1, revision=0x11
[    1.447473] microcode: CPU14 sig=0x106a5, pf=0x1, revision=0x11
[    1.447729] microcode: CPU15 sig=0x106a5, pf=0x1, revision=0x11
[    1.448022] Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.448487] Scanning for low memory corruption every 60 seconds
[    1.448971] audit: initializing netlink socket (disabled)
[    1.449231] type=2000 audit(1267475873.298:1): initialized
[    1.458560] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.462486] VFS: Disk quotas dquot_6.5.2
[    1.462819] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.464103] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.464710] SGI XFS with security attributes, large block/inode
numbers, no debug enabled
[    1.466782] msgmni has been set to 32768
[    1.468018] alg: No test for stdrng (krng)
[    1.468393] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    1.468848] io scheduler noop registered
[    1.469097] io scheduler anticipatory registered
[    1.469349] io scheduler deadline registered
[    1.469663] io scheduler cfq registered (default)
[    1.470148]   alloc irq_desc for 24 on node -1
[    1.470150]   alloc kstat_irqs on node -1
[    1.470159] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    1.470165] pcieport 0000:00:01.0: setting latency timer to 64
[    1.470322]   alloc irq_desc for 25 on node -1
[    1.470324]   alloc kstat_irqs on node -1
[    1.470329] pcieport 0000:00:03.0: irq 25 for MSI/MSI-X
[    1.470335] pcieport 0000:00:03.0: setting latency timer to 64
[    1.470495]   alloc irq_desc for 26 on node -1
[    1.470496]   alloc kstat_irqs on node -1
[    1.470501] pcieport 0000:00:05.0: irq 26 for MSI/MSI-X
[    1.470507] pcieport 0000:00:05.0: setting latency timer to 64
[    1.470663]   alloc irq_desc for 27 on node -1
[    1.470665]   alloc kstat_irqs on node -1
[    1.470670] pcieport 0000:00:07.0: irq 27 for MSI/MSI-X
[    1.470676] pcieport 0000:00:07.0: setting latency timer to 64
[    1.470830]   alloc irq_desc for 28 on node -1
[    1.470832]   alloc kstat_irqs on node -1
[    1.470837] pcieport 0000:00:09.0: irq 28 for MSI/MSI-X
[    1.470842] pcieport 0000:00:09.0: setting latency timer to 64
[    1.471004]   alloc irq_desc for 29 on node -1
[    1.471006]   alloc kstat_irqs on node -1
[    1.471012] pcieport 0000:00:1c.0: irq 29 for MSI/MSI-X
[    1.471018] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.471223]   alloc irq_desc for 30 on node -1
[    1.471224]   alloc kstat_irqs on node -1
[    1.471230] pcieport 0000:00:1c.4: irq 30 for MSI/MSI-X
[    1.471237] pcieport 0000:00:1c.4: setting latency timer to 64
[    1.471438]   alloc irq_desc for 31 on node -1
[    1.471440]   alloc kstat_irqs on node -1
[    1.471446] pcieport 0000:00:1c.5: irq 31 for MSI/MSI-X
[    1.471452] pcieport 0000:00:1c.5: setting latency timer to 64
[    1.471755] aer 0000:00:01.0:pcie02: AER service couldn't init
device: no _OSC support
[    1.471765] aer 0000:00:03.0:pcie02: AER service couldn't init
device: no _OSC support
[    1.471771] aer 0000:00:05.0:pcie02: AER service couldn't init
device: no _OSC support
[    1.471780] aer 0000:00:07.0:pcie02: AER service couldn't init
device: no _OSC support
[    1.471785] aer 0000:00:09.0:pcie02: AER service couldn't init
device: no _OSC support
[    1.475205] Non-volatile memory driver v1.3
[    1.475563] ipmi message handler version 39.2
[    1.475812] ipmi device interface
[    1.476136] IPMI System Interface driver.
[    1.476389] ipmi_si: Trying SMBIOS-specified kcs state machine at
i/o address 0xca2, slave address 0x20, irq 0
[    1.586287] ipmi: Found new BMC (man_id: 0x00b980,  prod_id:
0xaabb, dev_id: 0x20)
[    1.586792] IPMI kcs interface initialized
[    1.592104] IPMI Watchdog: driver initialized
[    1.592356] Copyright (C) 2004 MontaVista Software - IPMI Powerdown
via sys_reboot.
[    1.599124] IPMI poweroff: ATCA Detect mfg 0xB980 prod 0xAABB
[    1.599377] IPMI poweroff: Found a chassis style poweroff function
[    1.599844] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.600316] ACPI: Power Button [PWRB]
[    1.600628] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.601096] ACPI: Power Button [PWRF]
[    1.603474] ACPI: SSDT 00000000bf77e1f0 02B94 (v01 DpgPmm  P001Ist
00000011 INTL 20051117)
[    1.604890] ACPI: SSDT 00000000bf780d90 00961 (v01  PmRef  P001Cst
00003001 INTL 20051117)
[    1.606940] Monitor-Mwait will be used to enter C-3 state
[    1.606980] Monitor-Mwait will be used to enter C-3 state
[    1.607080] processor LNXCPU:00: registered as cooling_device0
[    1.608758] processor LNXCPU:01: registered as cooling_device1
[    1.610443] processor LNXCPU:02: registered as cooling_device2
[    1.612135] processor LNXCPU:03: registered as cooling_device3
[    1.613808] processor LNXCPU:04: registered as cooling_device4
[    1.615493] processor LNXCPU:05: registered as cooling_device5
[    1.617160] processor LNXCPU:06: registered as cooling_device6
[    1.618828] processor LNXCPU:07: registered as cooling_device7
[    1.620511] processor LNXCPU:08: registered as cooling_device8
[    1.622194] processor LNXCPU:09: registered as cooling_device9
[    1.623869] processor LNXCPU:0a: registered as cooling_device10
[    1.625554] processor LNXCPU:0b: registered as cooling_device11
[    1.627248] processor LNXCPU:0c: registered as cooling_device12
[    1.628920] processor LNXCPU:0d: registered as cooling_device13
[    1.630600] processor LNXCPU:0e: registered as cooling_device14
[    1.632285] processor LNXCPU:0f: registered as cooling_device15
[    1.635005] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.878465] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.121977] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.365491] serial8250: ttyS2 at I/O 0x3e8 (irq = 5) is a NS16550A
[    2.366067] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.366501] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.366929] 00:08: ttyS2 at I/O 0x3e8 (irq = 5) is a NS16550A
[    2.369388] brd: module loaded
[    2.370592] loop: module loaded
[    2.371250] mvsas 0000:07:00.0: mvsas: driver version 0.8.2
[    2.371524] mvsas 0000:07:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.371781] mvsas 0000:07:00.0: setting latency timer to 64
[    2.372788] mvsas 0000:07:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
[    5.098928] scsi0 : mvsas
[    5.099793] sas: phy-0:0 added to port-0:0, phy_mask:0x1 (5001b4d5021b403f)
[    5.100052] drivers/scsi/mvsas/mv_sas.c 1250:set wide port phy map 1
[    5.110038] sas: phy1 matched wide port0
[    5.110288] sas: phy-0:1 added to port-0:0, phy_mask:0x3 (5001b4d5021b403f)
[    5.110543] drivers/scsi/mvsas/mv_sas.c 1250:set wide port phy map 3
[    5.130507] sas: phy2 matched wide port0
[    5.130760] sas: phy-0:2 added to port-0:0, phy_mask:0x7 (5001b4d5021b403f)
[    5.131015] drivers/scsi/mvsas/mv_sas.c 1250:set wide port phy map 7
[    5.160959] sas: phy3 matched wide port0
[    5.161212] sas: phy-0:3 added to port-0:0, phy_mask:0xf (5001b4d5021b403f)
[    5.161464] drivers/scsi/mvsas/mv_sas.c 1250:set wide port phy map f
[    5.201392] sas: DOING DISCOVERY on port 0, pid:1108
[    5.203271] sas: ex 5001b4d5021b403f phy00:D attached: 5001b4d5021b4000
[    5.203901] sas: ex 5001b4d5021b403f phy01:D attached: 5001b4d5021b4001
[    5.204530] sas: ex 5001b4d5021b403f phy02:D attached: 5001b4d5021b4002
[    5.205169] sas: ex 5001b4d5021b403f phy03:D attached: 5001b4d5021b4003
[    5.205803] sas: ex 5001b4d5021b403f phy04:D attached: 0000000000000000
[    5.206445] sas: ex 5001b4d5021b403f phy05:D attached: 0000000000000000
[    5.207078] sas: ex 5001b4d5021b403f phy06:D attached: 0000000000000000
[    5.207721] sas: ex 5001b4d5021b403f phy07:D attached: 0000000000000000
[    5.208359] sas: ex 5001b4d5021b403f phy08:D attached: 5001b4d5021b4008
[    5.208997] sas: ex 5001b4d5021b403f phy09:D attached: 5001b4d5021b4009
[    5.209632] sas: ex 5001b4d5021b403f phy10:D attached: 5001b4d5021b400a
[    5.210271] sas: ex 5001b4d5021b403f phy11:D attached: 5001b4d5021b400b
[    5.210911] sas: ex 5001b4d5021b403f phy12:S attached: 5005043011ab0000
[    5.211544] sas: ex 5001b4d5021b403f phy13:S attached: 5005043011ab0000
[    5.212193] sas: ex 5001b4d5021b403f phy14:S attached: 5005043011ab0000
[    5.212823] sas: ex 5001b4d5021b403f phy15:S attached: 5005043011ab0000
[    5.213461] sas: ex 5001b4d5021b403f phy16:T attached: 0000000000000000
[    5.214098] sas: ex 5001b4d5021b403f phy17:T attached: 0000000000000000
[    5.214734] sas: ex 5001b4d5021b403f phy18:T attached: 0000000000000000
[    5.215380] sas: ex 5001b4d5021b403f phy19:T attached: 0000000000000000
[    5.216014] sas: ex 5001b4d5021b403f phy20:T attached: 0000000000000000
[    5.216654] sas: ex 5001b4d5021b403f phy21:T attached: 0000000000000000
[    5.217288] sas: ex 5001b4d5021b403f phy22:T attached: 0000000000000000
[    5.217926] sas: ex 5001b4d5021b403f phy23:T attached: 0000000000000000
[    5.218564] sas: ex 5001b4d5021b403f phy24:T attached: 5001b4d5021b4018
[    5.219203] sas: ex 5001b4d5021b403f phy25:T attached: 5001b4d5021b4019
[    5.219841] sas: ex 5001b4d5021b403f phy26:T attached: 5001b4d5021b401a
[    5.220477] sas: ex 5001b4d5021b403f phy27:T attached: 5001b4d5021b401b
[    5.221117] sas: ex 5001b4d5021b403f phy28:D attached: 5001b4d5021b403d
[    5.221765] sas: ex 5001b4d5021b403f phy29:D attached: 5001b4d5021b403e
[    5.225796] sas: sas_ata_phy_reset: Found ATA device.
[    5.244538] ata1.00: ATA-8: WDC WD20EADS-00S2B0, 04.05G04, max UDMA/133
[    5.244801] ata1.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.248480] ata1.00: configured for UDMA/133
[    5.248787] scsi 0:0:0:0: Direct-Access     ATA      WDC
WD20EADS-00S 04.0 PQ: 0 ANSI: 5
[    5.252397] sas: sas_ata_phy_reset: Found ATA device.
[    5.662880] ata2.00: ATA-8: WDC WD20EADS-00S2B0, 04.05G04, max UDMA/133
[    5.663142] ata2.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.666243] ata2.00: configured for UDMA/133
[    5.666525] scsi 0:0:1:0: Direct-Access     ATA      WDC
WD20EADS-00S 04.0 PQ: 0 ANSI: 5
[    5.670204] sas: sas_ata_phy_reset: Found ATA device.
[    6.095662] ata3.00: ATA-8: WDC WD20EADS-00S2B0, 04.05G04, max UDMA/133
[    6.095921] ata3.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.103974] ata3.00: configured for UDMA/133
[    6.104260] scsi 0:0:2:0: Direct-Access     ATA      WDC
WD20EADS-00S 04.0 PQ: 0 ANSI: 5
[    6.108066] sas: sas_ata_phy_reset: Found ATA device.
[    6.518998] ata4.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
[    6.519264] ata4.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.524506] ata4.00: configured for UDMA/133
[    6.524790] scsi 0:0:3:0: Direct-Access     ATA      WDC
WD20EADS-00R 01.0 PQ: 0 ANSI: 5
[    6.528603] sas: sas_ata_phy_reset: Found ATA device.
[    6.925489] ata5.00: ATA-8: WDC WD20EADS-00S2B0, 04.05G04, max UDMA/133
[    6.925749] ata5.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.928884] ata5.00: configured for UDMA/133
[    6.929168] scsi 0:0:4:0: Direct-Access     ATA      WDC
WD20EADS-00S 04.0 PQ: 0 ANSI: 5
[    6.933409] sas: sas_ata_phy_reset: Found ATA device.
[    7.355281] ata6.00: ATA-8: WDC WD20EADS-00S2B0, 04.05G04, max UDMA/133
[    7.355544] ata6.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.359236] ata6.00: configured for UDMA/133
[    7.359532] scsi 0:0:5:0: Direct-Access     ATA      WDC
WD20EADS-00S 04.0 PQ: 0 ANSI: 5
[    7.362934] sas: sas_ata_phy_reset: Found ATA device.
[    7.783853] ata7.00: ATA-8: WDC WD20EADS-00S2B0, 04.05G04, max UDMA/133
[    7.784111] ata7.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.786906] ata7.00: configured for UDMA/133
[    7.787190] scsi 0:0:6:0: Direct-Access     ATA      WDC
WD20EADS-00S 04.0 PQ: 0 ANSI: 5
[    7.790567] sas: sas_ata_phy_reset: Found ATA device.
[    8.191104] ata8.00: ATA-8: WDC WD20EADS-00S2B0, 04.05G04, max UDMA/133
[    8.191360] ata8.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    8.194068] ata8.00: configured for UDMA/133
[    8.194353] scsi 0:0:7:0: Direct-Access     ATA      WDC
WD20EADS-00S 04.0 PQ: 0 ANSI: 5
[    8.198555] sas: sas_ata_phy_reset: Found ATA device.
[    8.604900] ata9.00: ATA-8: WDC WD20EADS-00S2B0, 04.05G04, max UDMA/133
[    8.605164] ata9.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    8.608675] ata9.00: configured for UDMA/133
[    8.608966] scsi 0:0:8:0: Direct-Access     ATA      WDC
WD20EADS-00S 04.0 PQ: 0 ANSI: 5
[    8.612804] sas: sas_ata_phy_reset: Found ATA device.
[    9.028485] ata10.00: ATA-8: WDC WD20EADS-00S2B0, 04.05G04, max UDMA/133
[    9.028744] ata10.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    9.031882] ata10.00: configured for UDMA/133
[    9.032169] scsi 0:0:9:0: Direct-Access     ATA      WDC
WD20EADS-00S 04.0 PQ: 0 ANSI: 5
[    9.036203] sas: sas_ata_phy_reset: Found ATA device.
[    9.434533] ata11.00: ATA-8: WDC WD20EADS-00S2B0, 04.05G04, max UDMA/133
[    9.434793] ata11.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    9.438259] ata11.00: configured for UDMA/133
[    9.438546] scsi 0:0:10:0: Direct-Access     ATA      WDC
WD20EADS-00S 04.0 PQ: 0 ANSI: 5
[    9.442826] sas: sas_ata_phy_reset: Found ATA device.
[    9.832039] ata12.00: ATA-8: WDC WD20EADS-00S2B0, 04.05G04, max UDMA/133
[    9.832300] ata12.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    9.836008] ata12.00: configured for UDMA/133
[    9.836295] scsi 0:0:11:0: Direct-Access     ATA      WDC
WD20EADS-00S 04.0 PQ: 0 ANSI: 5
[    9.839944] scsi 0:0:12:0: Enclosure         Areca
x28-05.60.1.30   000  PQ: 0 ANSI: 3
[    9.845752] sas: DONE DISCOVERY on port 0, pid:1108, result:0
[    9.846247] sd 0:0:0:0: [sda] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    9.846309] sd 0:0:1:0: [sdb] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    9.846347] sd 0:0:1:0: [sdb] Write Protect is off
[    9.846349] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    9.846352] sd 0:0:2:0: [sdc] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    9.846373] sd 0:0:1:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    9.846387] sd 0:0:2:0: [sdc] Write Protect is off
[    9.846389] sd 0:0:2:0: [sdc] Mode Sense: 00 3a 00 00
[    9.846406] sd 0:0:2:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    9.846425] sd 0:0:3:0: [sdd] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    9.846463] sd 0:0:3:0: [sdd] Write Protect is off
[    9.846465] sd 0:0:3:0: [sdd] Mode Sense: 00 3a 00 00
[    9.846476] sd 0:0:4:0: [sde] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    9.846482] sd 0:0:3:0: [sdd] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    9.846519] sd 0:0:4:0: [sde] Write Protect is off
[    9.846521] sd 0:0:4:0: [sde] Mode Sense: 00 3a 00 00
[    9.846541] sd 0:0:5:0: [sdf] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    9.846546] sd 0:0:4:0: [sde] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    9.846579] sd 0:0:5:0: [sdf] Write Protect is off
[    9.846581] sd 0:0:5:0: [sdf] Mode Sense: 00 3a 00 00
[    9.846597] sd 0:0:5:0: [sdf] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    9.846626] sd 0:0:6:0: [sdg] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    9.846670] sd 0:0:6:0: [sdg] Write Protect is off
[    9.846672] sd 0:0:6:0: [sdg] Mode Sense: 00 3a 00 00
[    9.846748] sd 0:0:6:0: [sdg] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    9.846794]  sdb:
[    9.846864] sd 0:0:7:0: [sdh] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    9.846900]  sde:
[    9.846917] sd 0:0:7:0: [sdh] Write Protect is off
[    9.846920] sd 0:0:7:0: [sdh] Mode Sense: 00 3a 00 00
[    9.846951] sd 0:0:7:0: [sdh] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    9.846965] sd 0:0:8:0: [sdi] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    9.847013]  sdc:
[    9.847015] sd 0:0:8:0: [sdi] Write Protect is off
[    9.847017] sd 0:0:8:0: [sdi] Mode Sense: 00 3a 00 00
[    9.847046] sd 0:0:9:0: [sdj] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    9.847062] sd 0:0:8:0: [sdi] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    9.847087] sd 0:0:9:0: [sdj] Write Protect is off
[    9.847089] sd 0:0:9:0: [sdj] Mode Sense: 00 3a 00 00
[    9.847107] sd 0:0:9:0: [sdj] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    9.847114]  sdf:
[    9.847259]  sdd:
[    9.847293] sd 0:0:10:0: [sdk] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    9.847332] sd 0:0:10:0: [sdk] Write Protect is off
[    9.847335] sd 0:0:10:0: [sdk] Mode Sense: 00 3a 00 00
[    9.847356]  sdg:
[    9.847360] sd 0:0:10:0: [sdk] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    9.847383]  sdh:
[    9.847398] sd 0:0:11:0: [sdl] 3907029168 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[    9.847433] sd 0:0:11:0: [sdl] Write Protect is off
[    9.847435] sd 0:0:11:0: [sdl] Mode Sense: 00 3a 00 00
[    9.847450] sd 0:0:11:0: [sdl] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    9.847593] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    9.847718]  sdi:
[    9.847750] sd 0:0:1:0: Attached scsi generic sg1 type 0
[    9.847792]  sdk:
[    9.847822] sd 0:0:2:0: Attached scsi generic sg2 type 0
[    9.847853]  sdj:
[    9.847878]  sdl:
[    9.847902] sd 0:0:3:0: Attached scsi generic sg3 type 0
[    9.847958] sd 0:0:4:0: Attached scsi generic sg4 type 0
[    9.847998] sd 0:0:5:0: Attached scsi generic sg5 type 0
[    9.848059] sd 0:0:6:0: Attached scsi generic sg6 type 0
[    9.848098] sd 0:0:7:0: Attached scsi generic sg7 type 0
[    9.848144] sd 0:0:8:0: Attached scsi generic sg8 type 0
[    9.848185] sd 0:0:9:0: Attached scsi generic sg9 type 0
[    9.848229] sd 0:0:10:0: Attached scsi generic sg10 type 0
[    9.848268] sd 0:0:11:0: Attached scsi generic sg11 type 0
[    9.848307] scsi 0:0:12:0: Attached scsi generic sg12 type 13
[    9.850415]  sdl1
[    9.865606]  sdd1
[    9.865652] sd 0:0:0:0: [sda] Write Protect is off
[    9.865657] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    9.865676] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    9.865870] sd 0:0:11:0: [sdl] Attached SCSI disk
[    9.866861]
[    9.867156]  sdb1
[    9.867337] sd 0:0:3:0: [sdd] Attached SCSI disk
[    9.867740]  sdj1
[    9.867964] sd 0:0:1:0: [sdb] Attached SCSI disk
[    9.868333]  sdi1
[    9.868516] sd 0:0:9:0: [sdj] Attached SCSI disk
[    9.868940]  sdh1
[    9.869236]  sdf1
[    9.869463] sd 0:0:8:0: [sdi] Attached SCSI disk
[    9.869841]  sdk1
[    9.870044] sd 0:0:5:0: [sdf] Attached SCSI disk
[    9.870420]  sdc1
[    9.870780]  sde1
[    9.871002] sd 0:0:10:0: [sdk] Attached SCSI disk
[    9.871012] sd 0:0:2:0: [sdc] Attached SCSI disk
[    9.871640]  sdg1
[    9.871822] sd 0:0:4:0: [sde] Attached SCSI disk
[    9.871854] sd 0:0:7:0: [sdh] Attached SCSI disk
[    9.872466]  sda: sda1 sda2
[    9.872685] sd 0:0:6:0: [sdg] Attached SCSI disk
[    9.873206]  sda3
[    9.887568] sd 0:0:0:0: [sda] Attached SCSI disk
[   10.484367] ses 0:0:12:0: Attached Enclosure device
[   10.484669] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[   10.484926] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   10.485236] e1000e 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.485522] e1000e 0000:03:00.0: setting latency timer to 64
[   10.485700]   alloc irq_desc for 32 on node -1
[   10.485702]   alloc kstat_irqs on node -1
[   10.485706] e1000e 0000:03:00.0: irq 32 for MSI/MSI-X
[   10.485708]   alloc irq_desc for 33 on node -1
[   10.485709]   alloc kstat_irqs on node -1
[   10.485711] e1000e 0000:03:00.0: irq 33 for MSI/MSI-X
[   10.485713]   alloc irq_desc for 34 on node -1
[   10.485714]   alloc kstat_irqs on node -1
[   10.485717] e1000e 0000:03:00.0: irq 34 for MSI/MSI-X
[   10.568731] 0000:03:00.0: eth0: (PCI Express:2.5GB/s:Width x1)
00:30:48:dc:bf:d4
[   10.569192] 0000:03:00.0: eth0: Intel(R) PRO/1000 Network Connection
[   10.569530] 0000:03:00.0: eth0: MAC: 3, PHY: 8, PBA No: 0101ff-0ff
[   10.569820] e1000e 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   10.570103] e1000e 0000:04:00.0: setting latency timer to 64
[   10.570272]   alloc irq_desc for 35 on node -1
[   10.570273]   alloc kstat_irqs on node -1
[   10.570276] e1000e 0000:04:00.0: irq 35 for MSI/MSI-X
[   10.570278]   alloc irq_desc for 36 on node -1
[   10.570279]   alloc kstat_irqs on node -1
[   10.570282] e1000e 0000:04:00.0: irq 36 for MSI/MSI-X
[   10.570283]   alloc irq_desc for 37 on node -1
[   10.570285]   alloc kstat_irqs on node -1
[   10.570287] e1000e 0000:04:00.0: irq 37 for MSI/MSI-X
[   10.658259] 0000:04:00.0: eth1: (PCI Express:2.5GB/s:Width x1)
00:30:48:dc:bf:d5
[   10.663663] 0000:04:00.0: eth1: Intel(R) PRO/1000 Network Connection
[   10.664002] 0000:04:00.0: eth1: MAC: 3, PHY: 8, PBA No: 0101ff-0ff
[   10.664309] tun: Universal TUN/TAP device driver, 1.6
[   10.664563] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   10.664899] console [netcon0] enabled
[   10.665147] netconsole: network logging started
[   10.665410] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   10.665679]   alloc irq_desc for 18 on node -1
[   10.665680]   alloc kstat_irqs on node -1
[   10.665684] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   10.665953] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   10.665956] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   10.666209] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned
bus number 1
[   10.666686] ehci_hcd 0000:00:1a.7: debug port 1
[   10.670801] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[   10.670814] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf9ffa000
[   10.680782] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   10.681068] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   10.681324] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[   10.681782] usb usb1: Product: EHCI Host Controller
[   10.682033] usb usb1: Manufacturer: Linux 2.6.32-gentoo-r1 ehci_hcd
[   10.682287] usb usb1: SerialNumber: 0000:00:1a.7
[   10.682617] usb usb1: configuration #1 chosen from 1 choice
[   10.682933] hub 1-0:1.0: USB hub found
[   10.683190] hub 1-0:1.0: 6 ports detected
[   10.683484]   alloc irq_desc for 23 on node -1
[   10.683485]   alloc kstat_irqs on node -1
[   10.683489] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   10.683750] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   10.683753] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   10.684015] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 2
[   10.684488] ehci_hcd 0000:00:1d.7: debug port 1
[   10.688620] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[   10.688630] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf9ffc000
[   10.697748] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   10.698024] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   10.698276] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[   10.698726] usb usb2: Product: EHCI Host Controller
[   10.698980] usb usb2: Manufacturer: Linux 2.6.32-gentoo-r1 ehci_hcd
[   10.699234] usb usb2: SerialNumber: 0000:00:1d.7
[   10.699559] usb usb2: configuration #1 chosen from 1 choice
[   10.699874] hub 2-0:1.0: USB hub found
[   10.700127] hub 2-0:1.0: 6 ports detected
[   10.700456] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   10.700760] uhci_hcd: USB Universal Host Controller Interface driver
[   10.701050] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.701309] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   10.701312] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   10.701566] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned
bus number 3
[   10.702043] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000b400
[   10.702318] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   10.702573] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[   10.703029] usb usb3: Product: UHCI Host Controller
[   10.703278] usb usb3: Manufacturer: Linux 2.6.32-gentoo-r1 uhci_hcd
[   10.703529] usb usb3: SerialNumber: 0000:00:1a.0
[   10.703856] usb usb3: configuration #1 chosen from 1 choice
[   10.704166] hub 3-0:1.0: USB hub found
[   10.704422] hub 3-0:1.0: 2 ports detected
[   10.704707]   alloc irq_desc for 21 on node -1
[   10.704709]   alloc kstat_irqs on node -1
[   10.704713] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[   10.704973] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   10.704976] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   10.705231] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned
bus number 4
[   10.705710] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000b080
[   10.705988] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   10.706240] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[   10.706691] usb usb4: Product: UHCI Host Controller
[   10.706944] usb usb4: Manufacturer: Linux 2.6.32-gentoo-r1 uhci_hcd
[   10.707197] usb usb4: SerialNumber: 0000:00:1a.1
[   10.707525] usb usb4: configuration #1 chosen from 1 choice
[   10.707841] hub 4-0:1.0: USB hub found
[   10.708095] hub 4-0:1.0: 2 ports detected
[   10.708379]   alloc irq_desc for 19 on node -1
[   10.708381]   alloc kstat_irqs on node -1
[   10.708385] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[   10.708644] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   10.708647] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   10.708903] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned
bus number 5
[   10.709385] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000b000
[   10.709664] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   10.709921] usb usb5: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[   10.710376] usb usb5: Product: UHCI Host Controller
[   10.710627] usb usb5: Manufacturer: Linux 2.6.32-gentoo-r1 uhci_hcd
[   10.710882] usb usb5: SerialNumber: 0000:00:1a.2
[   10.711207] usb usb5: configuration #1 chosen from 1 choice
[   10.711518] hub 5-0:1.0: USB hub found
[   10.711775] hub 5-0:1.0: 2 ports detected
[   10.712064] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   10.712321] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   10.712324] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   10.712577] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 6
[   10.713053] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b880
[   10.713330] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   10.713585] usb usb6: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[   10.714040] usb usb6: Product: UHCI Host Controller
[   10.714288] usb usb6: Manufacturer: Linux 2.6.32-gentoo-r1 uhci_hcd
[   10.714539] usb usb6: SerialNumber: 0000:00:1d.0
[   10.714866] usb usb6: configuration #1 chosen from 1 choice
[   10.715178] hub 6-0:1.0: USB hub found
[   10.715431] hub 6-0:1.0: 2 ports detected
[   10.715715] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   10.715972] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   10.715975] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   10.716226] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 7
[   10.716701] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b800
[   10.716976] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   10.717229] usb usb7: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[   10.717685] usb usb7: Product: UHCI Host Controller
[   10.717938] usb usb7: Manufacturer: Linux 2.6.32-gentoo-r1 uhci_hcd
[   10.718189] usb usb7: SerialNumber: 0000:00:1d.1
[   10.718512] usb usb7: configuration #1 chosen from 1 choice
[   10.718822] hub 7-0:1.0: USB hub found
[   10.719075] hub 7-0:1.0: 2 ports detected
[   10.719359] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   10.719616] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   10.719619] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   10.719876] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 8
[   10.720351] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b480
[   10.720626] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[   10.720883] usb usb8: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[   10.721336] usb usb8: Product: UHCI Host Controller
[   10.721585] usb usb8: Manufacturer: Linux 2.6.32-gentoo-r1 uhci_hcd
[   10.721841] usb usb8: SerialNumber: 0000:00:1d.2
[   10.722166] usb usb8: configuration #1 chosen from 1 choice
[   10.722479] hub 8-0:1.0: USB hub found
[   10.722740] hub 8-0:1.0: 2 ports detected
[   10.723066] Initializing USB Mass Storage driver...
[   10.723386] usbcore: registered new interface driver usb-storage
[   10.723642] USB Mass Storage support registered.
[   10.723964] usbcore: registered new interface driver libusual
[   10.724411] PNP: No PS/2 controller found. Probing ports directly.
[   10.727146] serio: i8042 KBD port at 0x60,0x64 irq 1
[   10.727399] serio: i8042 AUX port at 0x60,0x64 irq 12
[   10.727759] mice: PS/2 mouse device common for all mice
[   10.728256] Driver 'rtc_cmos' needs updating - please use bus_type methods
[   10.728531] rtc_cmos 00:03: RTC can wake from S4
[   10.728852] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[   10.729127] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   10.729426] i2c /dev entries driver
[   10.729781] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
[   10.730490] coretemp coretemp.0: Unable to access MSR 0xEE, for
Tjmax, left at default
[   10.730870] coretemp coretemp.1: Unable to access MSR 0xEE, for
Tjmax, left at default
[   10.731473] coretemp coretemp.2: Unable to access MSR 0xEE, for
Tjmax, left at default
[   10.732083] coretemp coretemp.3: Unable to access MSR 0xEE, for
Tjmax, left at default
[   10.732686] coretemp coretemp.4: Unable to access MSR 0xEE, for
Tjmax, left at default
[   10.733292] coretemp coretemp.5: Unable to access MSR 0xEE, for
Tjmax, left at default
[   10.733906] coretemp coretemp.6: Unable to access MSR 0xEE, for
Tjmax, left at default
[   10.734513] coretemp coretemp.7: Unable to access MSR 0xEE, for
Tjmax, left at default
[   10.735115] coretemp coretemp.8: Unable to access MSR 0xEE, for
Tjmax, left at default
[   10.735718] coretemp coretemp.9: Unable to access MSR 0xEE, for
Tjmax, left at default
[   10.736320] coretemp coretemp.10: Unable to access MSR 0xEE, for
Tjmax, left at default
[   10.736932] coretemp coretemp.11: Unable to access MSR 0xEE, for
Tjmax, left at default
[   10.737538] coretemp coretemp.12: Unable to access MSR 0xEE, for
Tjmax, left at default
[   10.738150] coretemp coretemp.13: Unable to access MSR 0xEE, for
Tjmax, left at default
[   10.738768] coretemp coretemp.14: Unable to access MSR 0xEE, for
Tjmax, left at default
[   10.739371] coretemp coretemp.15: Unable to access MSR 0xEE, for
Tjmax, left at default
[   10.739928] EDAC MC: Ver: 2.1.0 Jan  8 2010
[   10.743927] cpuidle: using governor ladder
[   10.749680] cpuidle: using governor menu
[   10.751529] usbcore: registered new interface driver hiddev
[   10.751846] usbcore: registered new interface driver usbhid
[   10.752105] usbhid: v2.6:USB HID core driver
[   10.752545] oprofile: using NMI interrupt.
[   10.757792] Mirror/redirect action on
[   10.758039] u32 classifier
[   10.758286]     input device check on
[   10.758537]     Actions configured
[   10.758791] Netfilter messages via NETLINK v0.30.
[   10.759059] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   10.759532] CONFIG_NF_CT_ACCT is deprecated and will be removed
soon. Please use
[   10.759994] nf_conntrack.acct=1 kernel parameter, acct=1
nf_conntrack module option or
[   10.760455] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   10.760755] ctnetlink v0.93: registering with nfnetlink.
[   10.761275] IPv4 over IPv4 tunneling driver
[   10.761794] GRE over IPv4 tunneling driver
[   10.762565] ip_tables: (C) 2000-2006 Netfilter Core Team
[   10.762857] TCP cubic registered
[   10.763105] Initializing XFRM netlink socket
[   10.763359] NET: Registered protocol family 17
[   10.763613] NET: Registered protocol family 15
[   10.763874] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   10.764130] All bugs added by David S. Miller <davem@redhat.com>
[   10.772406] registered taskstats version 1
[   10.863508] async/11 used greatest stack depth: 5008 bytes left
[   11.143107] EXT3-fs: INFO: recovery required on readonly filesystem.
[   11.143365] EXT3-fs: write access will be enabled during recovery.
[   11.290827] usb 5-2: new full speed USB device using uhci_hcd and address 2
[   11.451220] usb 5-2: New USB device found, idVendor=046b, idProduct=ff10
[   11.451588] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   11.451844] usb 5-2: Product: Virtual Keyboard and Mouse
[   11.452093] usb 5-2: Manufacturer: American Megatrends Inc.
[   11.452581] usb 5-2: SerialNumber: serial
[   11.453159] usb 5-2: configuration #1 chosen from 1 choice
[   11.475329] kjournald starting.  Commit interval 5 seconds
[   11.475338] EXT3-fs: sda1: orphan cleanup on readonly fs
[   11.475344] ext3_orphan_cleanup: deleting unreferenced inode 2908166
[   11.475373] ext3_orphan_cleanup: deleting unreferenced inode 2908164
[   11.475379] EXT3-fs: sda1: 2 orphan inodes deleted
[   11.475380] EXT3-fs: recovery complete.
[   11.479239] EXT3-fs: mounted filesystem with writeback data mode.
[   11.479687] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
[   11.480129] Freeing unused kernel memory: 452k freed
[   11.480687] Write protecting the kernel read-only data: 6628k
[   11.556436] khelper used greatest stack depth: 4840 bytes left
[   11.563537] input: American Megatrends Inc. Virtual Keyboard and
Mouse as /devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/input/input2
[   11.564415] generic-usb 0003:046B:FF10.0001: input,hidraw0: USB HID
v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse]
on usb-0000:00:1a.2-2/input0
[   11.581549] input: American Megatrends Inc. Virtual Keyboard and
Mouse as /devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.1/input/input3
[   11.582736] generic-usb 0003:046B:FF10.0002: input,hidraw1: USB HID
v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on
usb-0000:00:1a.2-2/input1
[   11.788687] usb 6-1: new low speed USB device using uhci_hcd and address 2
[   11.987851] usb 6-1: New USB device found, idVendor=1c4f, idProduct=0002
[   11.988111] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   11.988395] usb 6-1: Product: USB Keykoard
[   11.988649] usb 6-1: Manufacturer: USB
[   11.989162] usb 6-1: configuration #1 chosen from 1 choice
[   12.005334] input: USB USB Keykoard as
/devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.0/input/input4
[   12.006052] stty used greatest stack depth: 4160 bytes left
[   12.006172] generic-usb 0003:1C4F:0002.0003: input,hidraw2: USB HID
v1.10 Keyboard [USB USB Keykoard] on usb-0000:00:1d.0-1/input0
[   12.449847] udev: starting version 146
[   12.529975] iTCO_vendor_support: vendor-support=0
[   12.576657] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   12.577091] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0860)
[   12.577109] iTCO_wdt: cannot register miscdev on minor=130 (err=-16)
[   12.577116] iTCO_wdt: No card detected
[   13.099671] EXT3 FS on sda1, internal journal
[   13.215281] Adding 10490436k swap on /dev/sda2.  Priority:-1
extents:1 across:10490436k
[   15.493672] ls used greatest stack depth: 3904 bytes left
[   21.056275] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: None
[   22.001305] drivers/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed
[   22.001314] generic-usb 0003:1C4F:0002.0004: timeout initializing reports
[   22.001491] input: USB USB Keykoard as
/devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.1/input/input5
[   22.001563] generic-usb 0003:1C4F:0002.0004: input,hidraw3: USB HID
v1.10 Device [USB USB Keykoard] on usb-0000:00:1d.0-1/input1
[   64.874322] w83627hf: Found W83627HF chip at 0x290

Thanks,

-- 
Ilia Mirkin
imirkin@alum.mit.edu

--0016364ec92cb45ff50480b4d7aa
Content-Type: image/png; name="mvsas-crash.png"
Content-Disposition: attachment; filename="mvsas-crash.png"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g68p2bd40

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
NTk6MzItMDU6MDDkjDlGAAAAAElFTkSuQmCC
--0016364ec92cb45ff50480b4d7aa--
