From: "Patrick J. LoPresti" <patl@users.sourceforge.net>
Subject: Re: Linux 2.6.8.1 + megaraid-2.20.3.0 == Oops
Date: 21 Aug 2004 12:54:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <s5gwtzssaez.fsf@patl=users.sf.net>
References: <s5g3c2hkcod.fsf@patl=users.sf.net>
	<20040820160802.7b74cfa3.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ext.curl.com ([66.228.88.132]:17938 "HELO
	mail-ext.curl.com") by vger.kernel.org with SMTP id S266752AbUHUQyJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 12:54:09 -0400
In-Reply-To: <20040820160802.7b74cfa3.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: Atul.Mukker@lsil.com, linux-scsi@vger.kernel.org

--=-=-=

"Randy.Dunlap" <rddunlap@osdl.org> writes:

> Looks like mraid_mm_init() hasn't done the
> 	INIT_LIST_HEAD(&adapters_list_g);
> yet.  You might be able to verify that by using
> "initcall_debug" on the kernel boot/command line.
> I don't see the expected "megaraid cmm:" message, e.g.

OK, I added "debug initcall_debug" to the kernel command line, but I
am not exactly sure what I am looking for.  The results are attached
below.

> I expected to be able to build these drivers as modules, but that's
> not allowed by their Kconfig.  Is that because of the module
> inter-dependencies?

I do not understand.  The first thing I did was to build these as
modules against the Fedora Core 2 kernel, but that resulted in a
different failure.  So I thought I would try them non-modular on a
vanilla kernel, which is how I ended up with this Oops.

 - Pat



--=-=-=
Content-Disposition: inline; filename=boot4.txt
Content-Description: boot4.txt

Linux version 2.6.8.1 (patl@users.sourceforge.net) (gcc version 3.3.3 20040412 (Red Hat Linux 3.3.3-7)) #4 SMP Fri Aug 20 12:07:09 EDT 2004
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 0000000000100000 - 000000007ffe0000 (usable)
 BIOS-e820: 000000007ffe0000 - 000000007ffefc00 (ACPI data)
 BIOS-e820: 000000007ffefc00 - 000000007ffff000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
1151MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000fe710
On node 0 totalpages: 524256
  DMA zone: 4096 pages, LIFO batch:1
  Normal zone: 225280 pages, LIFO batch:16
  HighMem zone: 294880 pages, LIFO batch:16
DMI 2.3 present.
ACPI: RSDP (v000 DELL                                      ) @ 0x000fdc40
ACPI: RSDT (v001 DELL   PE650    0x00000001 MSFT 0x0100000a) @ 0x000fdc54
ACPI: FADT (v001 DELL   PE650    0x00000001 MSFT 0x0100000a) @ 0x000fdc84
ACPI: MADT (v001 DELL   PE650    0x00000001 MSFT 0x0100000a) @ 0x000fdcf8
ACPI: SPCR (v001 DELL   PE650    0x00000001 MSFT 0x0100000a) @ 0x000fdd64
ACPI: DSDT (v001 DELL   PE650    0x00000001 MSFT 0x0100000a) @ 0x00000000
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:2 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: Assigned apic_id 2
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-15
ACPI: IOAPIC (id[0x03] address[0xfec01000] gsi_base[16])
IOAPIC[1]: Assigned apic_id 3
IOAPIC[1]: apic_id 3, version 17, address 0xfec01000, GSI 16-31
ACPI: IOAPIC (id[0x04] address[0xfec02000] gsi_base[32])
IOAPIC[2]: Assigned apic_id 4
IOAPIC[2]: apic_id 4, version 17, address 0xfec02000, GSI 32-47
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 3 I/O APICs
Using ACPI (MADT) for SMP configuration information
Built 1 zonelists
Kernel command line: ro root=LABEL=/ console=tty0 console=ttyS0 debug initcall_debug
Initializing CPU#0
PID hash table entries: 4096 (order 12: 32768 bytes)
Detected 3067.286 MHz processor.
Using pmtmr for high-res timesource
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2075652k/2097024k available (1436k kernel code, 20244k reserved, 800k data, 148k init, 1179520k highmem)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay loop... 6078.46 BogoMIPS
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000
CPU: After vendor identify, caps:  bfebfbff 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps:        bfebfbff 00000000 00000000 00000080
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
CPU0: Intel(R) Pentium(R) 4 CPU 3.06GHz stepping 07
per-CPU timeslice cutoff: 1462.79 usecs.
task migration cache decay timeout: 2 msecs.
enabled ExtINT on CPU#0
ESR value before enabling vector: 00000040
ESR value after enabling vector: 00000000
Booting processor 1/1 eip 2000
Initializing CPU#1
masked ExtINT on CPU#1
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Calibrating delay loop... 6127.61 BogoMIPS
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000
CPU: After vendor identify, caps:  bfebfbff 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps:        bfebfbff 00000000 00000000 00000080
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Pentium(R) 4 CPU 3.06GHz stepping 07
Total of 2 processors activated (12206.08 BogoMIPS).
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 IO-APIC (apicid-pin) 3-0, 3-1, 3-2, 3-3, 3-4, 3-5, 3-6, 3-7, 3-8, 3-9, 3-10, 3-11, 3-12, 3-13, 3-14, 3-15, 4-0, 4-1, 4-2, 4-3, 4-4, 4-5, 4-6, 4-7, 4-8, 4-9, 4-10, 4-11, 4-12, 4-13, 4-14, 4-15 not connected.
..TIMER: vector=0x31 pin1=0 pin2=-1
Using local APIC timer interrupts.
calibrating APIC timer ...
..... CPU clock speed is 3066.0159 MHz.
..... host bus clock speed is 133.0311 MHz.
checking TSC synchronization across 2 CPUs: passed.
Brought up 2 CPUs
CPU0:  online
 domain 0: span 03
  groups: 01 02
CPU1:  online
 domain 0: span 03
  groups: 02 01
Calling initcall 0xc0110b38: reboot_init+0x0/0x15()
Calling initcall 0xc0340e7a: usermodehelper_init+0x0/0x30()
Calling initcall 0xc03411cf: pm_init+0x0/0x2d()
Calling initcall 0xc0343477: init_script_binfmt+0x0/0x13()
Calling initcall 0xc034348a: init_elf_binfmt+0x0/0x13()
Calling initcall 0xc03499bf: netlink_proto_init+0x0/0x42()
NET: Registered protocol family 16
Calling initcall 0xc0343fd3: pcibus_class_init+0x0/0x13()
Calling initcall 0xc034462c: pci_driver_init+0x0/0x13()
Calling initcall 0xc0345a54: tty_class_init+0x0/0x32()
Calling initcall 0xc0339534: mtrr_if_init+0x0/0x6d()
Calling initcall 0xc03486cb: pci_pcbios_init+0x0/0x30()
PCI: PCI BIOS revision 2.10 entry at 0xfc91e, last bus=2
Calling initcall 0xc03486fb: pci_mmcfg_init+0x0/0x41()
Calling initcall 0xc03488c9: pci_direct_init+0x0/0x10a()
PCI: Using configuration type 1
Calling initcall 0xc03393cb: mtrr_init+0x0/0x169()
mtrr: v2.0 (20020519)
Calling initcall 0xc03401bc: topology_init+0x0/0x42()
Calling initcall 0xc0342b3e: init_bio+0x0/0xb2()
Calling initcall 0xc03451ac: acpi_init+0x0/0xd9()
ACPI: Subsystem revision 20040326
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
Calling initcall 0xc034540d: acpi_ec_init+0x0/0x58()
Calling initcall 0xc0345465: acpi_pci_root_init+0x0/0x26()
Calling initcall 0xc0345522: acpi_pci_link_init+0x0/0x44()
Calling initcall 0xc0345566: acpi_power_init+0x0/0x6c()
Calling initcall 0xc034569e: acpi_system_init+0x0/0xc5()
Calling initcall 0xc0345763: acpi_event_init+0x0/0x3e()
Calling initcall 0xc03457a1: acpi_scan_init+0x0/0x68()
ACPI: PCI Root Bridge [PCI0] (00:00)
PCI: Probing PCI hardware (bus 00)
PCI: Ignoring BAR0-3 of IDE controller 0000:00:0f.1
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Root Bridge [PCI1] (00:01)
PCI: Probing PCI hardware (bus 01)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
ACPI: PCI Root Bridge [PCI2] (00:02)
PCI: Probing PCI hardware (bus 02)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2._PRT]
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 9 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK6] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK7] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK8] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK9] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN10] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN11] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN12] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN13] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN14] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN15] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN16] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN17] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN18] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN19] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN1A] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN1B] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN1C] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN1D] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN1E] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LN1F] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUSB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
Calling initcall 0xc0345f63: misc_init+0x0/0x9c()
Calling initcall 0xc0346cdf: device_init+0x0/0x33()
Calling initcall 0xc0346d12: as_slab_setup+0x0/0x52()
Calling initcall 0xc0346d64: deadline_slab_setup+0x0/0x52()
Calling initcall 0xc0346db6: cfq_slab_setup+0x0/0xce()
Calling initcall 0xc034722b: init_scsi+0x0/0xe0()
SCSI subsystem initialized
Calling initcall 0xc0347c94: input_init+0x0/0xbf()
Calling initcall 0xc0348a7e: pci_acpi_init+0x0/0x80()
PCI: Using ACPI for IRQ routing
ACPI: PCI interrupt 0000:00:03.0[A] -> GSI 17 (level, low) -> IRQ 17
ACPI: PCI Interrupt Link [LUSB] enabled at IRQ 11
ACPI: PCI interrupt 0000:00:0f.2[A] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI interrupt 0000:01:03.0[A] -> GSI 19 (level, low) -> IRQ 19
ACPI: PCI interrupt 0000:01:03.1[B] -> GSI 20 (level, low) -> IRQ 20
number of MP IRQ sources: 16.
number of IO-APIC #2 registers: 16.
number of IO-APIC #3 registers: 16.
number of IO-APIC #4 registers: 16.
testing the IO APIC.......................
IO APIC #2......
.... register #00: 02000000
.......    : physical APIC id: 02
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 000F0011
.......     : max redirection entries: 000F
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 02000000
.......     : arbitration: 02
.... IRQ redirection table:
 NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
 00 003 03  0    0    0   0   0    1    1    31
 01 003 03  0    0    0   0   0    1    1    39
 02 003 03  1    0    0   0   0    1    1    41
 03 003 03  0    0    0   0   0    1    1    49
 04 003 03  0    0    0   0   0    1    1    51
 05 003 03  0    0    0   0   0    1    1    59
 06 003 03  0    0    0   0   0    1    1    61
 07 003 03  0    0    0   0   0    1    1    69
 08 003 03  0    0    0   0   0    1    1    71
 09 003 03  0    1    0   1   0    1    1    79
 0a 003 03  0    0    0   0   0    1    1    81
 0b 003 03  1    1    0   1   0    1    1    89
 0c 003 03  0    0    0   0   0    1    1    91
 0d 003 03  0    0    0   0   0    1    1    99
 0e 003 03  0    0    0   0   0    1    1    A1
 0f 003 03  0    0    0   0   0    1    1    A9
IO APIC #3......
.... register #00: 03000000
.......    : physical APIC id: 03
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 000F0011
.......     : max redirection entries: 000F
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 03000000
.......     : arbitration: 03
.... IRQ redirection table:
 NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
 00 000 00  1    0    0   0   0    0    0    00
 01 003 03  1    1    0   1   0    1    1    B1
 02 000 00  1    0    0   0   0    0    0    00
 03 003 03  1    1    0   1   0    1    1    B9
 04 003 03  1    1    0   1   0    1    1    C1
 05 000 00  1    0    0   0   0    0    0    00
 06 000 00  1    0    0   0   0    0    0    00
 07 000 00  1    0    0   0   0    0    0    00
 08 000 00  1    0    0   0   0    0    0    00
 09 000 00  1    0    0   0   0    0    0    00
 0a 000 00  1    0    0   0   0    0    0    00
 0b 000 00  1    0    0   0   0    0    0    00
 0c 000 00  1    0    0   0   0    0    0    00
 0d 000 00  1    0    0   0   0    0    0    00
 0e 000 00  1    0    0   0   0    0    0    00
 0f 000 00  1    0    0   0   0    0    0    00
IO APIC #4......
.... register #00: 04000000
.......    : physical APIC id: 04
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 000F0011
.......     : max redirection entries: 000F
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 04000000
.......     : arbitration: 04
.... IRQ redirection table:
 NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
 00 000 00  1    0    0   0   0    0    0    00
 01 000 00  1    0    0   0   0    0    0    00
 02 000 00  1    0    0   0   0    0    0    00
 03 000 00  1    0    0   0   0    0    0    00
 04 000 00  1    0    0   0   0    0    0    00
 05 000 00  1    0    0   0   0    0    0    00
 06 000 00  1    0    0   0   0    0    0    00
 07 000 00  1    0    0   0   0    0    0    00
 08 000 00  1    0    0   0   0    0    0    00
 09 000 00  1    0    0   0   0    0    0    00
 0a 000 00  1    0    0   0   0    0    0    00
 0b 000 00  1    0    0   0   0    0    0    00
 0c 000 00  1    0    0   0   0    0    0    00
 0d 000 00  1    0    0   0   0    0    0    00
 0e 000 00  1    0    0   0   0    0    0    00
 0f 000 00  1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:0
IRQ1 -> 0:1
IRQ2 -> 0:2
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
IRQ17 -> 1:1
IRQ19 -> 1:3
IRQ20 -> 1:4
.................................... done.
Calling initcall 0xc0348afe: pci_legacy_init+0x0/0x56()
Calling initcall 0xc03492bd: pcibios_irq_init+0x0/0xc3()
Calling initcall 0xc0349380: pcibios_init+0x0/0x76()
Calling initcall 0xc0349779: net_dev_init+0x0/0x168()
Calling initcall 0xc0345809: chr_dev_init+0x0/0x99()
Calling initcall 0xc03350c7: i8259A_init_sysfs+0x0/0x25()
Calling initcall 0xc033514c: init_timer_sysfs+0x0/0x25()
Calling initcall 0xc010bda2: time_init_device+0x0/0x25()
Calling initcall 0xc033703f: sbf_init+0x0/0x59()
Calling initcall 0xc033c9fd: init_lapic_sysfs+0x0/0x37()
Calling initcall 0xc033d286: balanced_irq_init+0x0/0x1a5()
Starting balanced_irq
Calling initcall 0xc033f397: sysenter_setup+0x0/0xc1()
Calling initcall 0xc0340810: abi_register_sysctl+0x0/0x1d()
Calling initcall 0xc0340c19: ioresources_init+0x0/0x57()
Calling initcall 0xc0340d99: uid_cache_init+0x0/0xa1()
Calling initcall 0xc0341049: init_posix_timers+0x0/0xba()
Calling initcall 0xc0341103: init+0x0/0x59()
Calling initcall 0xc034115c: proc_dma_init+0x0/0x30()
Calling initcall 0xc012ebe2: percpu_modinit+0x0/0x7d()
Calling initcall 0xc034118c: modules_init+0x0/0x13()
Calling initcall 0xc034119f: kallsyms_init+0x0/0x30()
Calling initcall 0xc03411fc: ikconfig_init+0x0/0x3e()
Calling initcall 0xc0342160: init_per_zone_pages_min+0x0/0x41()
Calling initcall 0xc0342372: pdflush_init+0x0/0xd()
Calling initcall 0xc03426b1: cpucache_init+0x0/0x3d()
Calling initcall 0xc0342704: kswapd_init+0x0/0x54()
Calling initcall 0xc0342758: init_emergency_pool+0x0/0x78()
highmem bounce pool size: 64 pages
Calling initcall 0xc0342853: gate_vma_init+0x0/0x35()
Calling initcall 0xc03428c8: init_tmpfs+0x0/0x9e()
Calling initcall 0xc0342966: procswaps_init+0x0/0x30()
Calling initcall 0xc0342cb4: init_pipe_fs+0x0/0x4b()
Calling initcall 0xc0342cff: fasync_init+0x0/0x42()
Calling initcall 0xc0342d41: filelock_init+0x0/0x42()
Calling initcall 0xc034307d: dnotify_init+0x0/0x42()
Calling initcall 0xc03432f6: aio_setup+0x0/0x94()
Calling initcall 0xc034338a: eventpoll_init+0x0/0xed()
Calling initcall 0xc034349d: init_mbcache+0x0/0x22()
Calling initcall 0xc0343947: init_devpts_fs+0x0/0x3e()
Calling initcall 0xc0343985: init_ext3_fs+0x0/0x45()
Calling initcall 0xc0343c04: journal_init+0x0/0x1c()
Calling initcall 0xc0343c20: init_ramfs_fs+0x0/0x13()
Calling initcall 0xc0343c46: init_nls_cp437+0x0/0x13()
Calling initcall 0xc0343c59: init_nls_cp737+0x0/0x13()
Calling initcall 0xc0343c6c: init_autofs4_fs+0x0/0x13()
Calling initcall 0xc0343c7f: ipc_init+0x0/0x12()
Calling initcall 0xc0343e11: init_mqueue_fs+0x0/0xf3()
Calling initcall 0xc0343f04: init_crypto+0x0/0x1a()
Initializing Cryptographic API
Calling initcall 0xc01aec74: pci_init+0x0/0x3d()
Calling initcall 0xc034463f: pci_proc_init+0x0/0x81()
Calling initcall 0xc03455d2: acpi_processor_init+0x0/0x7a()
ACPI: Processor [CPU0] (supports C1)
ACPI: Processor [CPU1] (supports C1)
Calling initcall 0xc034564c: acpi_thermal_init+0x0/0x52()
Calling initcall 0xc0345939: rand_initialize+0x0/0xd7()
Calling initcall 0xc0345a86: tty_init+0x0/0x222()
Calling initcall 0xc0345ca8: pty_init+0x0/0x2bb()
Calling initcall 0xc0346957: serial8250_init+0x0/0x6c()
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing disabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Calling initcall 0xc03469c3: acpi_serial_init+0x0/0x13()
Calling initcall 0xc03469d6: serial8250_pci_init+0x0/0x1d()
Calling initcall 0xc01ef222: elevator_global_init+0x0/0x3()
Calling initcall 0xc0346e84: rd_init+0x0/0x1a1()
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
Calling initcall 0xc034719c: net_olddevs_init+0x0/0x34()
Calling initcall 0xc0347465: megaraid_init+0x0/0x9c()
megaraid: 2.20.3.0 (Release Date: Thu Aug 19 09:58:33 EDT 2004)
megaraid: probe new device 0x1000:0x1960:0x1028:0x0520: bus 0:slot 3:func 0
ACPI: PCI interrupt 0000:00:03.0[A] -> GSI 17 (level, low) -> IRQ 17
megaraid: fw version:[350O] bios version:[1.09]
Unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
c0208374
*pde = 00000000
Oops: 0002 [#1]
SMP 
Modules linked in:
CPU:    1
EIP:    0060:[<c0208374>]    Not tainted
EFLAGS: 00010246   (2.6.8.1) 
EIP is at mraid_mm_register_adp+0x241/0x30e
eax: f7fcd398   ebx: f7fcd380   ecx: f7d90000   edx: 00000000
esi: c2147940   edi: c217fc00   ebp: f7f93dfc   esp: f7f93db0
ds: 007b   es: 007b   ss: 0068
Process swapper (pid: 1, threadinfo=f7f92000 task=f7f916b0)
Stack: f7fcd380 000000d0 c217fcc0 00000010 00000000 00008000 f7fcd3a4 00000020 
       00000000 f7d5c940 f7d5b0b8 f7d5c600 00000020 c0206f8b f7f93dfc 000000d0 
       f7f93dfc 00000580 f7d5c000 00000018 00000001 f7d5a000 0000201e c218c400 
Call Trace:
 [<c0206f8b>] megaraid_cmm_register+0x165/0x1cf
 [<c0207026>] megaraid_mbox_mm_handler+0x0/0xc2
 [<c01abf2e>] __delay+0x12/0x16
 [<c020646a>] mbox_post_sync_cmd+0x103/0x26b
 [<c0206bd7>] megaraid_mbox_enum_raid_scsi+0x62/0x89
 [<c034776d>] megaraid_init_mbox+0x26c/0x2a8
 [<c0205a54>] megaraid_mbox_dpc+0x0/0x364
 [<c0203f35>] megaraid_probe_one+0x1ad/0x260
 [<c01afcf6>] pci_device_probe_static+0x52/0x61
 [<c01afd40>] __pci_device_probe+0x3b/0x4e
 [<c01afd7f>] pci_device_probe+0x2c/0x4a
 [<c01ec116>] bus_match+0x3f/0x6a
 [<c01ec228>] driver_attach+0x56/0x80
 [<c01ec680>] bus_add_driver+0x92/0xb1
 [<c01affce>] pci_register_driver+0x6c/0x94
 [<c03474d2>] megaraid_init+0x6d/0x9c
 [<c03328c6>] do_initcalls+0x28/0xb4
 [<c0347465>] megaraid_init+0x0/0x9c
 [<c01004d1>] init+0x86/0x1b9
 [<c010044b>] init+0x0/0x1b9
 [<c0103da1>] kernel_thread_helper+0x5/0xb
Code: 89 02 89 50 04 83 05 a8 cb 37 c0 01 31 c0 e9 e1 fe ff ff 0f 
 <0>Kernel panic: Attempted to kill init!
 
--=-=-=--
