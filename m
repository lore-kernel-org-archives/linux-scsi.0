From: Meelis Roos <mroos@linux.ee>
Subject: Re: qla2xxx: MSI-X: Unsupported ISP 2432 SSVID/SSDID
 (0x103C,0x7041)
Date: Tue, 19 Sep 2017 17:35:56 +0300 (EEST)
Message-ID: <alpine.LRH.2.21.1709191725090.26572@math.ut.ee>
References: <alpine.LRH.2.20.1708192337130.26479@math.ut.ee> <063278e2-f5ff-24f3-9b73-a2a05a4c5542@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:39597 "EHLO smtp2.it.da.ut.ee"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751685AbdISOgC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Sep 2017 10:36:02 -0400
In-Reply-To: <063278e2-f5ff-24f3-9b73-a2a05a4c5542@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com

> On 08/19/2017 10:41 PM, Meelis Roos wrote:
> > Hello, I just tried Linux with the latest kernel (4.13-rc5+git) on a HP 
> > DL360 G6 with HP branded ISP2432 HBA. The driver mentions unsupported 
> > model of the card:
> > 
> > [    3.868589] scsi host1: qla2xxx
> > [    3.871696] qla2xxx [0000:07:00.0]-00fb:1: QLogic HPAE312A - PCI-Express Dual Port 4Gb Fibre Channel HBA.
> > [    3.871782] qla2xxx [0000:07:00.0]-00fc:1: ISP2432: PCIe (2.5GT/s x4) @ 0000:07:00.0 hdma+ host#=1 fw=8.03.00 (9496).
> > [    3.871973] qla2xxx [0000:07:00.1]-001d: : Found an ISP2432 irq 49 iobase 0xffffc900062c5000.
> > [    3.872568] qla2xxx [0000:07:00.1]-0034:4: MSI-X: Unsupported ISP 2432 SSVID/SSDID (0x103C,0x7041).
> > 
> > Is there some information I can provide to include this card in fully 
> > supported list?
> > 
> Weelll ... that statement indicates that MSI-X is unsupported, not the
> card itself.

Yes, something seems to be bad about MSI-X. Other hardware is using MSI, 
QLA is using IOAPIC.

cut -c 1-10,185- < /proc/interrupts

   0:     IO-APIC    2-edge      timer
   1:     IO-APIC    1-edge      i8042
   8:     IO-APIC    8-edge      rtc0
   9:     IO-APIC    9-fasteoi   acpi
  12:     IO-APIC   12-edge      i8042
  17:     IO-APIC   17-fasteoi   ata_piix
  20:     IO-APIC   20-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
  21:     IO-APIC   21-fasteoi   ipmi_si
  22:     IO-APIC   22-fasteoi   hpilo, uhci_hcd:usb4, uhci_hcd:usb6
  23:     IO-APIC   23-fasteoi   uhci_hcd:usb3, uhci_hcd:usb5, radeon
  24:     DMAR-MSI    0-edge      dmar0
  26:     PCI-MSI 1572864-edge      hpsa0-msix0
  27:     PCI-MSI 1572865-edge      hpsa0-msix1
  28:     PCI-MSI 1572866-edge      hpsa0-msix2
  29:     PCI-MSI 1572867-edge      hpsa0-msix3
  30:     PCI-MSI 1572868-edge      hpsa0-msix4
  31:     PCI-MSI 1572869-edge      hpsa0-msix5
  32:     PCI-MSI 1572870-edge      hpsa0-msix6
  33:     PCI-MSI 1572871-edge      hpsa0-msix7
  34:     PCI-MSI 1572872-edge      hpsa0-msix8
  35:     PCI-MSI 1572873-edge      hpsa0-msix9
  36:     PCI-MSI 1572874-edge      hpsa0-msix10
  37:     PCI-MSI 1572875-edge      hpsa0-msix11
  38:     PCI-MSI 1572876-edge      hpsa0-msix12
  39:     PCI-MSI 1572877-edge      hpsa0-msix13
  40:     PCI-MSI 1572878-edge      hpsa0-msix14
  41:     PCI-MSI 1572879-edge      hpsa0-msix15
  45:     PCI-MSI 2097152-edge      ens1f0
  46:     IO-APIC    0-fasteoi   qla2xxx
  48:     PCI-MSI 2099200-edge      ens1f1
  49:     IO-APIC   10-fasteoi   qla2xxx
  50:     PCI-MSI 1048576-edge      enp2s0f0-0
  51:     PCI-MSI 1048577-edge      enp2s0f0-1
  52:     PCI-MSI 1048578-edge      enp2s0f0-2
  53:     PCI-MSI 1048579-edge      enp2s0f0-3
  54:     PCI-MSI 1048580-edge      enp2s0f0-4
  55:     PCI-MSI 1048581-edge      enp2s0f0-5
  56:     PCI-MSI 1048582-edge      enp2s0f0-6
  57:     PCI-MSI 1048583-edge      enp2s0f0-7
  59:     PCI-MSI 1050624-edge      enp2s0f1-0
  60:     PCI-MSI 1050625-edge      enp2s0f1-1
  61:     PCI-MSI 1050626-edge      enp2s0f1-2
  62:     PCI-MSI 1050627-edge      enp2s0f1-3
  63:     PCI-MSI 1050628-edge      enp2s0f1-4
  64:     PCI-MSI 1050629-edge      enp2s0f1-5
  65:     PCI-MSI 1050630-edge      enp2s0f1-6
  66:     PCI-MSI 1050631-edge      enp2s0f1-7
 NMI:     Non-maskable interrupts
 LOC:     Local timer interrupts
 SPU:     Spurious interrupts
 PMI:     Performance monitoring interrupts
 IWI:     IRQ work interrupts
 RTR:     APIC ICR read retries
 RES:     Rescheduling interrupts
 CAL:     Function call interrupts
 TLB:     TLB shootdowns
 TRM:     Thermal event interrupts
 THR:     Threshold APIC interrupts
 MCE:     Machine check exceptions
 MCP:     Machine check polls
 ERR:     
 MIS:     
 PIN:     Posted-interrupt notification event
 NPI:     Nested posted-interrupt event
 PIW:     Posted-interrupt wakeup event

Full dmesg:

[    0.000000] Linux version 4.14.0-rc1-00013-gebb2c2437d80 (mroos@dl360g6) (gcc version 7.2.0 (Debian 7.2.0-1)) #17 SMP Tue Sep 19 15:01:51 EEST 2017
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-4.14.0-rc1-00013-gebb2c2437d80 root=/dev/sda1 ro
[    0.000000] x86/fpu: x87 FPU will use FXSAVE
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000d761efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d761f000-0x00000000d762bfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000d762c000-0x00000000d762cfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d762d000-0x00000000d7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000e3ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fee0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000001227ffefff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] random: fast init done
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: HP ProLiant DL360 G6, BIOS P64 08/16/2015
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x1227fff max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00D8000000 mask FFF8000000 uncachable
[    0.000000]   1 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[    0.000000] e820: last_pfn = 0xd762d max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f4f80-0x000f4f8f] mapped at [ffffffffff200f80]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] BRK [0x01de9000, 0x01de9fff] PGTABLE
[    0.000000] BRK [0x01dea000, 0x01deafff] PGTABLE
[    0.000000] BRK [0x01deb000, 0x01debfff] PGTABLE
[    0.000000] BRK [0x01dec000, 0x01decfff] PGTABLE
[    0.000000] BRK [0x01ded000, 0x01dedfff] PGTABLE
[    0.000000] BRK [0x01dee000, 0x01deefff] PGTABLE
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F4F00 000024 (v02 HP    )
[    0.000000] ACPI: XSDT 0x00000000D7620140 0000AC (v01 HP     ProLiant 00000002 \xffffffd2?   0000162E)
[    0.000000] ACPI: FACP 0x00000000D7620240 0000F4 (v03 HP     ProLiant 00000002 \xffffffd2?   0000162E)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20170728/tbfadt-708)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm2ControlBlock: 32, using default 8 (20170728/tbfadt-708)
[    0.000000] ACPI: DSDT 0x00000000D7620340 00206D (v01 HP     DSDT     00000001 INTL 20030228)
[    0.000000] ACPI: FACS 0x00000000D761F100 000040
[    0.000000] ACPI: FACS 0x00000000D761F100 000040
[    0.000000] ACPI: SPCR 0x00000000D761F140 000050 (v01 HP     SPCRRBSU 00000001 \xffffffd2?   0000162E)
[    0.000000] ACPI: MCFG 0x00000000D761F1C0 00003C (v01 HP     ProLiant 00000001      00000000)
[    0.000000] ACPI: HPET 0x00000000D761F200 000038 (v01 HP     ProLiant 00000002 \xffffffd2?   0000162E)
[    0.000000] ACPI: FFFF 0x00000000D761F240 000064 (v02 HP     ProLiant 00000002 \xffffffd2?   0000162E)
[    0.000000] ACPI: SPMI 0x00000000D761F2C0 000040 (v05 HP     ProLiant 00000001 \xffffffd2?   0000162E)
[    0.000000] ACPI: ERST 0x00000000D761F300 0001D0 (v01 HP     ProLiant 00000001 \xffffffd2?   0000162E)
[    0.000000] ACPI: APIC 0x00000000D761F500 00015E (v01 HP     ProLiant 00000002      00000000)
[    0.000000] ACPI: FFFF 0x00000000D761F680 000570 (v01 HP     Proliant 00000001 \xffffffd2?   0000162E)
[    0.000000] ACPI: FFFF 0x00000000D761FC00 000176 (v01 HP     ProLiant 00000001 \xffffffd2?   0000162E)
[    0.000000] ACPI: BERT 0x00000000D761FD80 000030 (v01 HP     ProLiant 00000001 \xffffffd2?   0000162E)
[    0.000000] ACPI: HEST 0x00000000D761FDC0 0000BC (v01 HP     ProLiant 00000001 \xffffffd2?   0000162E)
[    0.000000] ACPI: DMAR 0x00000000D761FE80 000164 (v01 HP     ProLiant 00000001 \xffffffd2?   0000162E)
[    0.000000] ACPI: SSDT 0x00000000D76223C0 000125 (v03 HP     CRSPCI0  00000002 HP   00000001)
[    0.000000] ACPI: SSDT 0x00000000D7622500 0001CF (v03 HP     riser1a  00000002 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000D7622700 000377 (v01 HP     pmab     00000001 INTL 20090625)
[    0.000000] ACPI: SSDT 0x00000000D7622A80 004674 (v01 INTEL  PPM RCM  00000001 INTL 20061109)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000001227ffefff]
[    0.000000] NODE_DATA(0) allocated [mem 0x1227ffd000-0x1227ffefff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x0000001227ffefff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000d761efff]
[    0.000000]   node   0: [mem 0x00000000d762c000-0x00000000d762cfff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x0000001227ffefff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x0000001227ffefff]
[    0.000000] On node 0 totalpages: 18871741
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13721 pages used for memmap
[    0.000000]   DMA32 zone: 878112 pages, LIFO batch:31
[    0.000000]   Normal zone: 281088 pages used for memmap
[    0.000000]   Normal zone: 17989631 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] IOAPIC[1]: apic_id 0, version 32, address 0xfec80000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 32 CPUs, 16 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd761f000-0xd762bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xd762d000-0xd7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd8000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xe3ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe4000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfee0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee10000-0xff7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
[    0.000000] e820: [mem 0xe4000000-0xfebfffff] available for PCI devices
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:32 nr_node_ids:1
[    0.000000] percpu: Embedded 36 pages/cpu @ffff881227400000 s106968 r8192 d32296 u262144
[    0.000000] pcpu-alloc: s106968 r8192 d32296 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 [0] 08 09 10 11 12 13 14 15 
[    0.000000] pcpu-alloc: [0] 16 17 18 19 20 21 22 23 [0] 24 25 26 27 28 29 30 31 
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 18576847
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-4.14.0-rc1-00013-gebb2c2437d80 root=/dev/sda1 ro
[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 126976 bytes
[    0.000000] log_buf_len min size: 131072 bytes
[    0.000000] log_buf_len: 262144 bytes
[    0.000000] early log buf free: 121696(92%)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 74221764K/75486964K available (5300K kernel code, 597K rwdata, 2240K rodata, 832K init, 424K bss, 1265200K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=32, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS: 4352, nr_irqs: 1088, preallocated irqs: 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 2533.291 MHz processor
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 5066.58 BogoMIPS (lpj=10133164)
[    0.004000] pid_max: default: 32768 minimum: 301
[    0.004000] ACPI: Core revision 20170728
[    0.008430] ACPI: 5 ACPI AML tables successfully acquired and loaded
[    0.022618] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.029777] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.030193] Mount-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.030533] Mountpoint-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.030954] CPU: Physical Processor ID: 0
[    0.031055] CPU: Processor Core ID: 0
[    0.031161] mce: CPU supports 9 MCE banks
[    0.031267] CPU0: Thermal monitoring enabled (TM1)
[    0.031379] process: using mwait in idle threads
[    0.031484] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.031593] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.031826] Freeing SMP alternatives memory: 28K
[    0.032091] smpboot: Max logical packages: 8
[    0.032199] DMAR-IR: This system BIOS has enabled interrupt remapping
               on a chipset that contains an erratum making that
               feature unstable.  To maintain system stability
               interrupt remapping is being disabled.  Please
               contact your BIOS vendor for an update
[    0.032613] Switched APIC routing to physical flat.
[    0.033252] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.076000] smpboot: CPU0: Intel(R) Xeon(R) CPU           E5540  @ 2.53GHz (family: 0x6, model: 0x1a, stepping: 0x5)
[    0.076000] Performance Events: PEBS fmt1+, Nehalem events, 16-deep LBR, Broken BIOS detected, complain to your hardware vendor.
[    0.076000] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 38d is 330)
[    0.076000] Intel PMU driver.
[    0.076000] core: CPU erratum AAJ80 worked around
[    0.076000] core: CPUID marked event: 'bus cycles' unavailable
[    0.076000] ... version:                3
[    0.076000] ... bit width:              48
[    0.076000] ... generic registers:      4
[    0.076000] ... value mask:             0000ffffffffffff
[    0.076000] ... max period:             000000007fffffff
[    0.076000] ... fixed-purpose events:   3
[    0.076000] ... event mask:             000000070000000f
[    0.076000] Hierarchical SRCU implementation.
[    0.076000] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.076000] smp: Bringing up secondary CPUs ...
[    0.076000] x86: Booting SMP configuration:
[    0.076000] .... node  #0, CPUs:        #1  #2  #3  #4  #5  #6  #7  #8  #9 #10 #11 #12 #13 #14 #15
[    1.282027] smp: Brought up 1 node, 16 CPUs
[    1.282027] smpboot: Total of 16 processors activated (81067.19 BogoMIPS)
[    1.286191] devtmpfs: initialized
[    1.288044] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    1.288249] futex hash table entries: 8192 (order: 7, 524288 bytes)
[    1.288642] NET: Registered protocol family 16
[    1.288881] cpuidle: using governor ladder
[    1.288881] cpuidle: using governor menu
[    1.288881] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    1.288881] ACPI: bus type PCI registered
[    1.288881] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    1.288881] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
[    1.288881] PCI: Using configuration type 1 for base access
[    1.288881] PCI: HP ProLiant DL360 detected, enabling pci=bfsort.
[    1.292140] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    1.292154] ACPI: Added _OSI(Module Device)
[    1.292222] ACPI: Added _OSI(Processor Device)
[    1.292325] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.292429] ACPI: Added _OSI(Processor Aggregator Device)
[    1.294873] ACPI: Interpreter enabled
[    1.294985] ACPI: (supports S0 S4 S5)
[    1.295083] ACPI: Using IOAPIC for interrupt routing
[    1.295203] HEST: Table parsing has been initialized.
[    1.296007] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.298902] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-0f])
[    1.299021] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.299193] acpi PNP0A08:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.299324] acpi PNP0A08:00: host bridge window expanded to [mem 0xfed00000-0xfed44fff window]; [mem 0xfed00000-0xfed44fff window] ignored
[    1.299565] PCI host bridge to bus 0000:00
[    1.299668] pci_bus 0000:00: root bus resource [mem 0xe7000000-0xfbffffff window]
[    1.299832] pci_bus 0000:00: root bus resource [io  0x1000-0x6fff window]
[    1.299949] pci_bus 0000:00: root bus resource [io  0x0000-0x03af window]
[    1.300003] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7 window]
[    1.300120] pci_bus 0000:00: root bus resource [io  0x0d00-0x0fff window]
[    1.300237] pci_bus 0000:00: root bus resource [mem 0xfed00000-0xfed44fff window]
[    1.300401] pci_bus 0000:00: root bus resource [io  0x03b0-0x03bb window]
[    1.300518] pci_bus 0000:00: root bus resource [io  0x03c0-0x03df window]
[    1.300636] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    1.300800] pci_bus 0000:00: root bus resource [bus 00-0f]
[    1.300918] pci 0000:00:00.0: [8086:3406] type 00 class 0x060000
[    1.300948] pci 0000:00:00.0: enabling Extended Tags
[    1.301085] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.301147] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[    1.301172] pci 0000:00:01.0: enabling Extended Tags
[    1.301309] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.301366] pci 0000:00:02.0: [8086:3409] type 01 class 0x060400
[    1.301390] pci 0000:00:02.0: enabling Extended Tags
[    1.301525] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    1.301582] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[    1.301606] pci 0000:00:03.0: enabling Extended Tags
[    1.301743] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.301802] pci 0000:00:04.0: [8086:340b] type 01 class 0x060400
[    1.301825] pci 0000:00:04.0: enabling Extended Tags
[    1.301963] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    1.302020] pci 0000:00:05.0: [8086:340c] type 01 class 0x060400
[    1.302044] pci 0000:00:05.0: enabling Extended Tags
[    1.302179] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    1.302236] pci 0000:00:06.0: [8086:340d] type 01 class 0x060400
[    1.302259] pci 0000:00:06.0: enabling Extended Tags
[    1.302394] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    1.302450] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[    1.302474] pci 0000:00:07.0: enabling Extended Tags
[    1.302611] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    1.302668] pci 0000:00:08.0: [8086:340f] type 01 class 0x060400
[    1.302691] pci 0000:00:08.0: enabling Extended Tags
[    1.302826] pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
[    1.302882] pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
[    1.302905] pci 0000:00:09.0: enabling Extended Tags
[    1.303042] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    1.303099] pci 0000:00:0a.0: [8086:3411] type 01 class 0x060400
[    1.303122] pci 0000:00:0a.0: enabling Extended Tags
[    1.303257] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    1.303314] pci 0000:00:0d.0: [8086:343a] type 00 class 0x060000
[    1.303402] pci 0000:00:0d.1: [8086:343b] type 00 class 0x060000
[    1.303489] pci 0000:00:0d.2: [8086:343c] type 00 class 0x060000
[    1.303571] pci 0000:00:0d.3: [8086:343d] type 00 class 0x060000
[    1.303653] pci 0000:00:0d.4: [8086:3418] type 00 class 0x060000
[    1.303735] pci 0000:00:0d.5: [8086:3419] type 00 class 0x060000
[    1.303817] pci 0000:00:0d.6: [8086:341a] type 00 class 0x060000
[    1.304011] pci 0000:00:0e.0: [8086:341c] type 00 class 0x060000
[    1.304094] pci 0000:00:0e.1: [8086:341d] type 00 class 0x060000
[    1.304177] pci 0000:00:0e.2: [8086:341e] type 00 class 0x060000
[    1.304261] pci 0000:00:0e.3: [8086:341f] type 00 class 0x060000
[    1.304343] pci 0000:00:0e.4: [8086:3439] type 00 class 0x060000
[    1.304426] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[    1.304509] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[    1.304595] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[    1.304691] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    1.304740] pci 0000:00:1d.0: reg 0x20: [io  0x1000-0x101f]
[    1.304817] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    1.304887] pci 0000:00:1d.1: reg 0x20: [io  0x1020-0x103f]
[    1.304986] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    1.305055] pci 0000:00:1d.2: reg 0x20: [io  0x1040-0x105f]
[    1.305154] pci 0000:00:1d.3: [8086:3a39] type 00 class 0x0c0300
[    1.305223] pci 0000:00:1d.3: reg 0x20: [io  0x1060-0x107f]
[    1.305322] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    1.305342] pci 0000:00:1d.7: reg 0x10: [mem 0xf5df0000-0xf5df03ff]
[    1.305416] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.305461] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    1.305547] pci 0000:00:1f.0: [8086:3a18] type 00 class 0x060100
[    1.305681] pci 0000:00:1f.2: [8086:3a20] type 00 class 0x01018f
[    1.305696] pci 0000:00:1f.2: reg 0x10: [io  0x1080-0x1087]
[    1.305702] pci 0000:00:1f.2: reg 0x14: [io  0x1088-0x108b]
[    1.305708] pci 0000:00:1f.2: reg 0x18: [io  0x1090-0x1097]
[    1.305715] pci 0000:00:1f.2: reg 0x1c: [io  0x1098-0x109b]
[    1.305721] pci 0000:00:1f.2: reg 0x20: [io  0x10a0-0x10af]
[    1.305727] pci 0000:00:1f.2: reg 0x24: [io  0x10b0-0x10bf]
[    1.305827] pci 0000:03:00.0: [103c:323a] type 00 class 0x010400
[    1.305843] pci 0000:03:00.0: reg 0x10: [mem 0xfbc00000-0xfbdfffff 64bit]
[    1.305852] pci 0000:03:00.0: reg 0x18: [mem 0xfbbf0000-0xfbbf0fff 64bit]
[    1.305859] pci 0000:03:00.0: reg 0x20: [io  0x4000-0x40ff]
[    1.305871] pci 0000:03:00.0: reg 0x30: [mem 0x00000000-0x0007ffff pref]
[    1.305907] pci 0000:03:00.0: PME# supported from D0
[    1.305947] pci 0000:00:01.0: PCI bridge to [bus 03]
[    1.306056] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
[    1.306059] pci 0000:00:01.0:   bridge window [mem 0xfbb00000-0xfbdfffff]
[    1.306090] pci 0000:00:02.0: PCI bridge to [bus 0a]
[    1.306270] pci 0000:07:00.0: [1077:2432] type 00 class 0x0c0400
[    1.306289] pci 0000:07:00.0: reg 0x10: [io  0x6000-0x60ff]
[    1.306301] pci 0000:07:00.0: reg 0x14: [mem 0xfbff0000-0xfbff3fff 64bit]
[    1.306331] pci 0000:07:00.0: reg 0x30: [mem 0x00000000-0x0003ffff pref]
[    1.306444] pci 0000:07:00.1: [1077:2432] type 00 class 0x0c0400
[    1.306463] pci 0000:07:00.1: reg 0x10: [io  0x6400-0x64ff]
[    1.306475] pci 0000:07:00.1: reg 0x14: [mem 0xfbfe0000-0xfbfe3fff 64bit]
[    1.306504] pci 0000:07:00.1: reg 0x30: [mem 0x00000000-0x0003ffff pref]
[    1.316019] pci 0000:00:03.0: PCI bridge to [bus 07-09]
[    1.316130] pci 0000:00:03.0:   bridge window [io  0x6000-0x6fff]
[    1.316133] pci 0000:00:03.0:   bridge window [mem 0xfbf00000-0xfbffffff]
[    1.316165] pci 0000:00:04.0: PCI bridge to [bus 0b]
[    1.316304] pci 0000:00:05.0: PCI bridge to [bus 0c]
[    1.316442] pci 0000:00:06.0: PCI bridge to [bus 0d]
[    1.316578] pci 0000:00:07.0: PCI bridge to [bus 0e]
[    1.316725] pci 0000:02:00.0: [14e4:1639] type 00 class 0x020000
[    1.316745] pci 0000:02:00.0: reg 0x10: [mem 0xf8000000-0xf9ffffff 64bit]
[    1.316775] pci 0000:02:00.0: reg 0x30: [mem 0x00000000-0x0000ffff pref]
[    1.316828] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    1.316884] pci 0000:02:00.1: [14e4:1639] type 00 class 0x020000
[    1.316904] pci 0000:02:00.1: reg 0x10: [mem 0xf6000000-0xf7ffffff 64bit]
[    1.316934] pci 0000:02:00.1: reg 0x30: [mem 0x00000000-0x0000ffff pref]
[    1.316986] pci 0000:02:00.1: PME# supported from D0 D3hot D3cold
[    1.328018] pci 0000:00:08.0: PCI bridge to [bus 02]
[    1.328128] pci 0000:00:08.0:   bridge window [mem 0xf6000000-0xf9ffffff]
[    1.328204] pci 0000:04:00.0: [8086:105e] type 00 class 0x020000
[    1.328222] pci 0000:04:00.0: reg 0x10: [mem 0xfbee0000-0xfbefffff]
[    1.328229] pci 0000:04:00.0: reg 0x14: [mem 0xfbec0000-0xfbedffff]
[    1.328237] pci 0000:04:00.0: reg 0x18: [io  0x5000-0x501f]
[    1.328264] pci 0000:04:00.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    1.328306] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    1.328368] pci 0000:04:00.1: [8086:105e] type 00 class 0x020000
[    1.328386] pci 0000:04:00.1: reg 0x10: [mem 0xfbea0000-0xfbebffff]
[    1.328393] pci 0000:04:00.1: reg 0x14: [mem 0xfbe80000-0xfbe9ffff]
[    1.328401] pci 0000:04:00.1: reg 0x18: [io  0x5020-0x503f]
[    1.328428] pci 0000:04:00.1: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    1.328469] pci 0000:04:00.1: PME# supported from D0 D3hot D3cold
[    1.340017] pci 0000:00:09.0: PCI bridge to [bus 04-06]
[    1.340128] pci 0000:00:09.0:   bridge window [io  0x5000-0x5fff]
[    1.340131] pci 0000:00:09.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    1.340162] pci 0000:00:0a.0: PCI bridge to [bus 0f]
[    1.340311] pci 0000:01:03.0: [1002:515e] type 00 class 0x030000
[    1.340331] pci 0000:01:03.0: reg 0x10: [mem 0xe8000000-0xefffffff pref]
[    1.340341] pci 0000:01:03.0: reg 0x14: [io  0x3000-0x30ff]
[    1.340350] pci 0000:01:03.0: reg 0x18: [mem 0xf5ff0000-0xf5ffffff]
[    1.340383] pci 0000:01:03.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    1.340412] pci 0000:01:03.0: supports D1 D2
[    1.340442] pci 0000:01:04.0: [0e11:b203] type 00 class 0x088000
[    1.340462] pci 0000:01:04.0: reg 0x10: [io  0x2800-0x28ff]
[    1.340471] pci 0000:01:04.0: reg 0x14: [mem 0xf5fe0000-0xf5fe01ff]
[    1.340539] pci 0000:01:04.0: PME# supported from D0 D3hot D3cold
[    1.340579] pci 0000:01:04.2: [0e11:b204] type 00 class 0x088000
[    1.340602] pci 0000:01:04.2: reg 0x10: [io  0x3400-0x34ff]
[    1.340612] pci 0000:01:04.2: reg 0x14: [mem 0xf5fd0000-0xf5fd07ff]
[    1.340622] pci 0000:01:04.2: reg 0x18: [mem 0xf5fc0000-0xf5fc3fff]
[    1.340632] pci 0000:01:04.2: reg 0x1c: [mem 0xf5f00000-0xf5f7ffff]
[    1.340660] pci 0000:01:04.2: reg 0x30: [mem 0x00000000-0x0000ffff pref]
[    1.340692] pci 0000:01:04.2: PME# supported from D0 D3hot D3cold
[    1.340730] pci 0000:01:04.4: [103c:3300] type 00 class 0x0c0300
[    1.340789] pci 0000:01:04.4: reg 0x20: [io  0x3800-0x381f]
[    1.340838] pci 0000:01:04.4: PME# supported from D0 D3hot D3cold
[    1.340874] pci 0000:01:04.6: [103c:3302] type 00 class 0x0c0701
[    1.340894] pci 0000:01:04.6: reg 0x10: [mem 0xf5ef0000-0xf5ef00ff]
[    1.340966] pci 0000:01:04.6: PME# supported from D0 D3hot D3cold
[    1.341022] pci 0000:00:1e.0: PCI bridge to [bus 01] (subtractive decode)
[    1.341083] pci 0000:00:1e.0:   bridge window [io  0x2000-0x3fff]
[    1.341086] pci 0000:00:1e.0:   bridge window [mem 0xf5e00000-0xf5ffffff]
[    1.341090] pci 0000:00:1e.0:   bridge window [mem 0xe8000000-0xefffffff 64bit pref]
[    1.341092] pci 0000:00:1e.0:   bridge window [mem 0xe7000000-0xfbffffff window] (subtractive decode)
[    1.341093] pci 0000:00:1e.0:   bridge window [io  0x1000-0x6fff window] (subtractive decode)
[    1.341094] pci 0000:00:1e.0:   bridge window [io  0x0000-0x03af window] (subtractive decode)
[    1.341096] pci 0000:00:1e.0:   bridge window [io  0x03e0-0x0cf7 window] (subtractive decode)
[    1.341097] pci 0000:00:1e.0:   bridge window [io  0x0d00-0x0fff window] (subtractive decode)
[    1.341098] pci 0000:00:1e.0:   bridge window [mem 0xfed00000-0xfed44fff window] (subtractive decode)
[    1.341099] pci 0000:00:1e.0:   bridge window [io  0x03b0-0x03bb window] (subtractive decode)
[    1.341100] pci 0000:00:1e.0:   bridge window [io  0x03c0-0x03df window] (subtractive decode)
[    1.341101] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff window] (subtractive decode)
[    1.341367] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *7 10 11)
[    1.341460] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 10 *11)
[    1.341552] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 10 11) *0, disabled.
[    1.341646] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 10 11) *0, disabled.
[    1.341740] ACPI: PCI Interrupt Link [LNKE] (IRQs *5 7 10 11)
[    1.341831] ACPI: PCI Interrupt Link [LNKF] (IRQs 5 7 *10 11)
[    1.341923] ACPI: PCI Interrupt Link [LNKG] (IRQs 5 7 *10 11)
[    1.342016] ACPI: PCI Interrupt Link [LNKH] (IRQs 5 *7 10 11)
[    1.342259] pci 0000:01:03.0: vgaarb: setting as boot VGA device
[    1.342259] pci 0000:01:03.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    1.342259] pci 0000:01:03.0: vgaarb: bridge control possible
[    1.342259] vgaarb: loaded
[    1.342259] SCSI subsystem initialized
[    1.342259] EDAC MC: Ver: 3.0.0
[    1.342259] PCI: Using ACPI for IRQ routing
[    1.344406] PCI: Discovered peer bus 3e
[    1.344505] PCI: root bus 3e: using default resources
[    1.344506] PCI: Probing PCI hardware (bus 3e)
[    1.344523] ACPI: \: failed to evaluate _DSM (0x1001)
[    1.344629] PCI host bridge to bus 0000:3e
[    1.344730] pci_bus 0000:3e: root bus resource [io  0x0000-0xffff]
[    1.344844] pci_bus 0000:3e: root bus resource [mem 0x00000000-0xffffffffff]
[    1.344963] pci_bus 0000:3e: No busn resource found for root bus, will use [bus 3e-ff]
[    1.345133] pci 0000:3e:00.0: [8086:2c40] type 00 class 0x060000
[    1.345169] pci 0000:3e:00.1: [8086:2c01] type 00 class 0x060000
[    1.345205] pci 0000:3e:02.0: [8086:2c10] type 00 class 0x060000
[    1.345236] pci 0000:3e:02.1: [8086:2c11] type 00 class 0x060000
[    1.345268] pci 0000:3e:02.4: [8086:2c14] type 00 class 0x060000
[    1.345300] pci 0000:3e:02.5: [8086:2c15] type 00 class 0x060000
[    1.345333] pci 0000:3e:03.0: [8086:2c18] type 00 class 0x060000
[    1.345364] pci 0000:3e:03.1: [8086:2c19] type 00 class 0x060000
[    1.345396] pci 0000:3e:03.2: [8086:2c1a] type 00 class 0x060000
[    1.345428] pci 0000:3e:03.4: [8086:2c1c] type 00 class 0x060000
[    1.345460] pci 0000:3e:04.0: [8086:2c20] type 00 class 0x060000
[    1.345492] pci 0000:3e:04.1: [8086:2c21] type 00 class 0x060000
[    1.345526] pci 0000:3e:04.2: [8086:2c22] type 00 class 0x060000
[    1.345558] pci 0000:3e:04.3: [8086:2c23] type 00 class 0x060000
[    1.345591] pci 0000:3e:05.0: [8086:2c28] type 00 class 0x060000
[    1.345623] pci 0000:3e:05.1: [8086:2c29] type 00 class 0x060000
[    1.345654] pci 0000:3e:05.2: [8086:2c2a] type 00 class 0x060000
[    1.345686] pci 0000:3e:05.3: [8086:2c2b] type 00 class 0x060000
[    1.345719] pci 0000:3e:06.0: [8086:2c30] type 00 class 0x060000
[    1.345751] pci 0000:3e:06.1: [8086:2c31] type 00 class 0x060000
[    1.345782] pci 0000:3e:06.2: [8086:2c32] type 00 class 0x060000
[    1.345814] pci 0000:3e:06.3: [8086:2c33] type 00 class 0x060000
[    1.345857] pci_bus 0000:3e: busn_res: [bus 3e-ff] end is updated to 3e
[    1.345862] PCI: Discovered peer bus 3f
[    1.345961] PCI: root bus 3f: using default resources
[    1.345962] PCI: Probing PCI hardware (bus 3f)
[    1.345978] ACPI: \: failed to evaluate _DSM (0x1001)
[    1.346085] PCI host bridge to bus 0000:3f
[    1.346186] pci_bus 0000:3f: root bus resource [io  0x0000-0xffff]
[    1.346300] pci_bus 0000:3f: root bus resource [mem 0x00000000-0xffffffffff]
[    1.346420] pci_bus 0000:3f: No busn resource found for root bus, will use [bus 3f-ff]
[    1.346589] pci 0000:3f:00.0: [8086:2c40] type 00 class 0x060000
[    1.346621] pci 0000:3f:00.1: [8086:2c01] type 00 class 0x060000
[    1.346652] pci 0000:3f:02.0: [8086:2c10] type 00 class 0x060000
[    1.346680] pci 0000:3f:02.1: [8086:2c11] type 00 class 0x060000
[    1.346710] pci 0000:3f:02.4: [8086:2c14] type 00 class 0x060000
[    1.346738] pci 0000:3f:02.5: [8086:2c15] type 00 class 0x060000
[    1.346768] pci 0000:3f:03.0: [8086:2c18] type 00 class 0x060000
[    1.346796] pci 0000:3f:03.1: [8086:2c19] type 00 class 0x060000
[    1.346826] pci 0000:3f:03.2: [8086:2c1a] type 00 class 0x060000
[    1.346855] pci 0000:3f:03.4: [8086:2c1c] type 00 class 0x060000
[    1.346885] pci 0000:3f:04.0: [8086:2c20] type 00 class 0x060000
[    1.346914] pci 0000:3f:04.1: [8086:2c21] type 00 class 0x060000
[    1.346943] pci 0000:3f:04.2: [8086:2c22] type 00 class 0x060000
[    1.346972] pci 0000:3f:04.3: [8086:2c23] type 00 class 0x060000
[    1.347002] pci 0000:3f:05.0: [8086:2c28] type 00 class 0x060000
[    1.347031] pci 0000:3f:05.1: [8086:2c29] type 00 class 0x060000
[    1.347061] pci 0000:3f:05.2: [8086:2c2a] type 00 class 0x060000
[    1.347090] pci 0000:3f:05.3: [8086:2c2b] type 00 class 0x060000
[    1.347122] pci 0000:3f:06.0: [8086:2c30] type 00 class 0x060000
[    1.347151] pci 0000:3f:06.1: [8086:2c31] type 00 class 0x060000
[    1.347179] pci 0000:3f:06.2: [8086:2c32] type 00 class 0x060000
[    1.347208] pci 0000:3f:06.3: [8086:2c33] type 00 class 0x060000
[    1.347246] pci_bus 0000:3f: busn_res: [bus 3f-ff] end is updated to 3f
[    1.347251] PCI: pci_cache_line_size set to 64 bytes
[    1.347363] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    1.347364] e820: reserve RAM buffer [mem 0xd761f000-0xd7ffffff]
[    1.347364] e820: reserve RAM buffer [mem 0xd762d000-0xd7ffffff]
[    1.347365] e820: reserve RAM buffer [mem 0x1227fff000-0x1227ffffff]
[    1.347511] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    1.347511] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.347511] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    1.349014] clocksource: Switched to clocksource hpet
[    1.349014] pnp: PnP ACPI init
[    1.349014] system 00:00: [io  0x0408-0x040f] has been reserved
[    1.349014] system 00:00: [io  0x04d0-0x04d1] has been reserved
[    1.349014] system 00:00: [io  0x0700-0x071f] has been reserved
[    1.349014] system 00:00: [io  0x0880-0x08ff] has been reserved
[    1.349014] system 00:00: [io  0x0900-0x097f] has been reserved
[    1.349046] system 00:00: [io  0x0c80-0x0c83] has been reserved
[    1.349158] system 00:00: [io  0x0cd4-0x0cd7] has been reserved
[    1.349270] system 00:00: [io  0x0f50-0x0f58] has been reserved
[    1.349382] system 00:00: [io  0x0ca0-0x0ca1] has been reserved
[    1.349506] system 00:00: [io  0x0ca4-0x0ca5] has been reserved
[    1.349619] system 00:00: [io  0x02f8-0x02ff] has been reserved
[    1.349732] system 00:00: [mem 0xe0000000-0xe3ffffff] has been reserved
[    1.349849] system 00:00: [mem 0xfe000000-0xfebfffff] has been reserved
[    1.349965] system 00:00: [mem 0xe7ffe000-0xe7ffffff] has been reserved
[    1.350084] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.350115] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.350131] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
[    1.350287] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    1.350330] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.350433] pnp: PnP ACPI: found 5 devices
[    1.356310] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    1.356446] pci 0000:03:00.0: BAR 6: assigned [mem 0xfbb00000-0xfbb7ffff pref]
[    1.356520] pci 0000:00:01.0: PCI bridge to [bus 03]
[    1.356576] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
[    1.356635] pci 0000:00:01.0:   bridge window [mem 0xfbb00000-0xfbdfffff]
[    1.356697] pci 0000:00:02.0: PCI bridge to [bus 0a]
[    1.356759] pci 0000:07:00.0: BAR 6: assigned [mem 0xfbf00000-0xfbf3ffff pref]
[    1.356921] pci 0000:07:00.1: BAR 6: assigned [mem 0xfbf40000-0xfbf7ffff pref]
[    1.357084] pci 0000:00:03.0: PCI bridge to [bus 07-09]
[    1.357192] pci 0000:00:03.0:   bridge window [io  0x6000-0x6fff]
[    1.357307] pci 0000:00:03.0:   bridge window [mem 0xfbf00000-0xfbffffff]
[    1.357429] pci 0000:00:04.0: PCI bridge to [bus 0b]
[    1.357540] pci 0000:00:05.0: PCI bridge to [bus 0c]
[    1.357652] pci 0000:00:06.0: PCI bridge to [bus 0d]
[    1.357763] pci 0000:00:07.0: PCI bridge to [bus 0e]
[    1.357874] pci 0000:02:00.0: BAR 6: no space for [mem size 0x00010000 pref]
[    1.357994] pci 0000:02:00.0: BAR 6: failed to assign [mem size 0x00010000 pref]
[    1.358157] pci 0000:02:00.1: BAR 6: no space for [mem size 0x00010000 pref]
[    1.358277] pci 0000:02:00.1: BAR 6: failed to assign [mem size 0x00010000 pref]
[    1.358441] pci 0000:00:08.0: PCI bridge to [bus 02]
[    1.358549] pci 0000:00:08.0:   bridge window [mem 0xf6000000-0xf9ffffff]
[    1.358671] pci 0000:04:00.0: BAR 6: assigned [mem 0xfbe00000-0xfbe1ffff pref]
[    1.358833] pci 0000:04:00.1: BAR 6: assigned [mem 0xfbe20000-0xfbe3ffff pref]
[    1.358995] pci 0000:00:09.0: PCI bridge to [bus 04-06]
[    1.359104] pci 0000:00:09.0:   bridge window [io  0x5000-0x5fff]
[    1.359218] pci 0000:00:09.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    1.359339] pci 0000:00:0a.0: PCI bridge to [bus 0f]
[    1.359453] pci 0000:01:03.0: BAR 6: assigned [mem 0xf5e00000-0xf5e1ffff pref]
[    1.359616] pci 0000:01:04.2: BAR 6: assigned [mem 0xf5e20000-0xf5e2ffff pref]
[    1.359778] pci 0000:00:1e.0: PCI bridge to [bus 01]
[    1.359885] pci 0000:00:1e.0:   bridge window [io  0x2000-0x3fff]
[    1.360007] pci 0000:00:1e.0:   bridge window [mem 0xf5e00000-0xf5ffffff]
[    1.360127] pci 0000:00:1e.0:   bridge window [mem 0xe8000000-0xefffffff 64bit pref]
[    1.360298] pci_bus 0000:00: resource 4 [mem 0xe7000000-0xfbffffff window]
[    1.360299] pci_bus 0000:00: resource 5 [io  0x1000-0x6fff window]
[    1.360300] pci_bus 0000:00: resource 6 [io  0x0000-0x03af window]
[    1.360301] pci_bus 0000:00: resource 7 [io  0x03e0-0x0cf7 window]
[    1.360302] pci_bus 0000:00: resource 8 [io  0x0d00-0x0fff window]
[    1.360304] pci_bus 0000:00: resource 9 [mem 0xfed00000-0xfed44fff window]
[    1.360305] pci_bus 0000:00: resource 10 [io  0x03b0-0x03bb window]
[    1.360306] pci_bus 0000:00: resource 11 [io  0x03c0-0x03df window]
[    1.360307] pci_bus 0000:00: resource 12 [mem 0x000a0000-0x000bffff window]
[    1.360308] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
[    1.360309] pci_bus 0000:03: resource 1 [mem 0xfbb00000-0xfbdfffff]
[    1.360311] pci_bus 0000:07: resource 0 [io  0x6000-0x6fff]
[    1.360312] pci_bus 0000:07: resource 1 [mem 0xfbf00000-0xfbffffff]
[    1.360313] pci_bus 0000:02: resource 1 [mem 0xf6000000-0xf9ffffff]
[    1.360314] pci_bus 0000:04: resource 0 [io  0x5000-0x5fff]
[    1.360315] pci_bus 0000:04: resource 1 [mem 0xfbe00000-0xfbefffff]
[    1.360316] pci_bus 0000:01: resource 0 [io  0x2000-0x3fff]
[    1.360317] pci_bus 0000:01: resource 1 [mem 0xf5e00000-0xf5ffffff]
[    1.360319] pci_bus 0000:01: resource 2 [mem 0xe8000000-0xefffffff 64bit pref]
[    1.360320] pci_bus 0000:01: resource 4 [mem 0xe7000000-0xfbffffff window]
[    1.360321] pci_bus 0000:01: resource 5 [io  0x1000-0x6fff window]
[    1.360322] pci_bus 0000:01: resource 6 [io  0x0000-0x03af window]
[    1.360323] pci_bus 0000:01: resource 7 [io  0x03e0-0x0cf7 window]
[    1.360324] pci_bus 0000:01: resource 8 [io  0x0d00-0x0fff window]
[    1.360325] pci_bus 0000:01: resource 9 [mem 0xfed00000-0xfed44fff window]
[    1.360326] pci_bus 0000:01: resource 10 [io  0x03b0-0x03bb window]
[    1.360327] pci_bus 0000:01: resource 11 [io  0x03c0-0x03df window]
[    1.360328] pci_bus 0000:01: resource 12 [mem 0x000a0000-0x000bffff window]
[    1.360350] pci_bus 0000:3e: resource 4 [io  0x0000-0xffff]
[    1.360351] pci_bus 0000:3e: resource 5 [mem 0x00000000-0xffffffffff]
[    1.360354] pci_bus 0000:3f: resource 4 [io  0x0000-0xffff]
[    1.360355] pci_bus 0000:3f: resource 5 [mem 0x00000000-0xffffffffff]
[    1.360393] NET: Registered protocol family 2
[    1.360781] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
[    1.361822] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.362118] TCP: Hash tables configured (established 524288 bind 65536)
[    1.362375] UDP hash table entries: 65536 (order: 9, 2097152 bytes)
[    1.362945] UDP-Lite hash table entries: 65536 (order: 9, 2097152 bytes)
[    1.363569] NET: Registered protocol family 1
[    1.384127] pci 0000:01:03.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    1.385072] PCI: CLS 64 bytes, default 64
[    1.385105] DMAR: Host address width 39
[    1.385160] DMAR: DRHD base: 0x000000e7ffe000 flags: 0x1
[    1.385222] DMAR: dmar0: reg_base_addr e7ffe000 ver 1:0 cap c90780106f0462 ecap f0207e
[    1.385296] DMAR: RMRR base: 0x000000d77fc000 end: 0x000000d77fdfff
[    1.385353] DMAR: RMRR base: 0x000000d77f5000 end: 0x000000d77fafff
[    1.385410] DMAR: RMRR base: 0x000000d763e000 end: 0x000000d763ffff
[    1.385467] DMAR: ATSR flags: 0x0
[    1.385827] DMAR: dmar0: Using Queued invalidation
[    1.385898] DMAR: Setting RMRR:
[    1.386271] DMAR: Setting identity map for device 0000:01:04.0 [0xd763e000 - 0xd763ffff]
[    1.386368] DMAR: Setting identity map for device 0000:01:04.2 [0xd763e000 - 0xd763ffff]
[    1.386789] DMAR: Setting identity map for device 0000:03:00.0 [0xd763e000 - 0xd763ffff]
[    1.387198] DMAR: Setting identity map for device 0000:04:00.0 [0xd763e000 - 0xd763ffff]
[    1.387595] DMAR: Setting identity map for device 0000:04:00.1 [0xd763e000 - 0xd763ffff]
[    1.387995] DMAR: Setting identity map for device 0000:07:00.0 [0xd763e000 - 0xd763ffff]
[    1.390020] DMAR: Setting identity map for device 0000:07:00.1 [0xd763e000 - 0xd763ffff]
[    1.390425] DMAR: Setting identity map for device 0000:00:1d.0 [0xd77f5000 - 0xd77fafff]
[    1.390831] DMAR: Setting identity map for device 0000:00:1d.1 [0xd77f5000 - 0xd77fafff]
[    1.391238] DMAR: Setting identity map for device 0000:00:1d.2 [0xd77f5000 - 0xd77fafff]
[    1.391647] DMAR: Setting identity map for device 0000:00:1d.3 [0xd77f5000 - 0xd77fafff]
[    1.391741] DMAR: Setting identity map for device 0000:01:04.0 [0xd77f5000 - 0xd77fafff]
[    1.391817] DMAR: Setting identity map for device 0000:01:04.2 [0xd77f5000 - 0xd77fafff]
[    1.391894] DMAR: Setting identity map for device 0000:01:04.4 [0xd77f5000 - 0xd77fafff]
[    1.392295] DMAR: Setting identity map for device 0000:00:1d.7 [0xd77fc000 - 0xd77fdfff]
[    1.392394] DMAR: Prepare 0-16MiB unity mapping for LPC
[    1.392761] DMAR: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
[    1.393020] DMAR: Intel(R) Virtualization Technology for Directed I/O
[    1.393133] iommu: Adding device 0000:00:00.0 to group 0
[    1.393202] iommu: Adding device 0000:00:01.0 to group 1
[    1.393272] iommu: Adding device 0000:00:02.0 to group 2
[    1.393340] iommu: Adding device 0000:00:03.0 to group 3
[    1.393409] iommu: Adding device 0000:00:04.0 to group 4
[    1.393477] iommu: Adding device 0000:00:05.0 to group 5
[    1.393547] iommu: Adding device 0000:00:06.0 to group 6
[    1.393616] iommu: Adding device 0000:00:07.0 to group 7
[    1.393684] iommu: Adding device 0000:00:08.0 to group 8
[    1.393753] iommu: Adding device 0000:00:09.0 to group 9
[    1.393822] iommu: Adding device 0000:00:0a.0 to group 10
[    1.393959] iommu: Adding device 0000:00:0d.0 to group 11
[    1.394029] iommu: Adding device 0000:00:0d.1 to group 11
[    1.394099] iommu: Adding device 0000:00:0d.2 to group 11
[    1.394168] iommu: Adding device 0000:00:0d.3 to group 11
[    1.394238] iommu: Adding device 0000:00:0d.4 to group 11
[    1.394308] iommu: Adding device 0000:00:0d.5 to group 11
[    1.394378] iommu: Adding device 0000:00:0d.6 to group 11
[    1.394494] iommu: Adding device 0000:00:0e.0 to group 12
[    1.394564] iommu: Adding device 0000:00:0e.1 to group 12
[    1.394634] iommu: Adding device 0000:00:0e.2 to group 12
[    1.394705] iommu: Adding device 0000:00:0e.3 to group 12
[    1.394775] iommu: Adding device 0000:00:0e.4 to group 12
[    1.394871] iommu: Adding device 0000:00:14.0 to group 13
[    1.394942] iommu: Adding device 0000:00:14.1 to group 13
[    1.395012] iommu: Adding device 0000:00:14.2 to group 13
[    1.395124] iommu: Adding device 0000:00:1d.0 to group 14
[    1.395193] iommu: Adding device 0000:00:1d.1 to group 14
[    1.395263] iommu: Adding device 0000:00:1d.2 to group 14
[    1.395332] iommu: Adding device 0000:00:1d.3 to group 14
[    1.395405] iommu: Adding device 0000:00:1d.7 to group 14
[    1.395474] iommu: Adding device 0000:00:1e.0 to group 15
[    1.395560] iommu: Adding device 0000:00:1f.0 to group 16
[    1.395630] iommu: Adding device 0000:00:1f.2 to group 16
[    1.395689] iommu: Adding device 0000:01:03.0 to group 15
[    1.395747] iommu: Adding device 0000:01:04.0 to group 15
[    1.395806] iommu: Adding device 0000:01:04.2 to group 15
[    1.395863] iommu: Adding device 0000:01:04.4 to group 15
[    1.395922] iommu: Adding device 0000:01:04.6 to group 15
[    1.396024] iommu: Adding device 0000:02:00.0 to group 17
[    1.396104] iommu: Adding device 0000:02:00.1 to group 17
[    1.396174] iommu: Adding device 0000:03:00.0 to group 18
[    1.396246] iommu: Adding device 0000:04:00.0 to group 19
[    1.396317] iommu: Adding device 0000:04:00.1 to group 20
[    1.396409] iommu: Adding device 0000:07:00.0 to group 21
[    1.396485] iommu: Adding device 0000:07:00.1 to group 21
[    1.396572] iommu: Adding device 0000:3e:00.0 to group 22
[    1.396645] iommu: Adding device 0000:3e:00.1 to group 22
[    1.396750] iommu: Adding device 0000:3e:02.0 to group 23
[    1.396822] iommu: Adding device 0000:3e:02.1 to group 23
[    1.396893] iommu: Adding device 0000:3e:02.4 to group 23
[    1.396965] iommu: Adding device 0000:3e:02.5 to group 23
[    1.397069] iommu: Adding device 0000:3e:03.0 to group 24
[    1.397141] iommu: Adding device 0000:3e:03.1 to group 24
[    1.397213] iommu: Adding device 0000:3e:03.2 to group 24
[    1.397285] iommu: Adding device 0000:3e:03.4 to group 24
[    1.397388] iommu: Adding device 0000:3e:04.0 to group 25
[    1.397460] iommu: Adding device 0000:3e:04.1 to group 25
[    1.397532] iommu: Adding device 0000:3e:04.2 to group 25
[    1.397605] iommu: Adding device 0000:3e:04.3 to group 25
[    1.397708] iommu: Adding device 0000:3e:05.0 to group 26
[    1.397781] iommu: Adding device 0000:3e:05.1 to group 26
[    1.397854] iommu: Adding device 0000:3e:05.2 to group 26
[    1.397928] iommu: Adding device 0000:3e:05.3 to group 26
[    1.398032] iommu: Adding device 0000:3e:06.0 to group 27
[    1.398106] iommu: Adding device 0000:3e:06.1 to group 27
[    1.398179] iommu: Adding device 0000:3e:06.2 to group 27
[    1.398253] iommu: Adding device 0000:3e:06.3 to group 27
[    1.398339] iommu: Adding device 0000:3f:00.0 to group 28
[    1.398412] iommu: Adding device 0000:3f:00.1 to group 28
[    1.398515] iommu: Adding device 0000:3f:02.0 to group 29
[    1.398590] iommu: Adding device 0000:3f:02.1 to group 29
[    1.398664] iommu: Adding device 0000:3f:02.4 to group 29
[    1.398738] iommu: Adding device 0000:3f:02.5 to group 29
[    1.398841] iommu: Adding device 0000:3f:03.0 to group 30
[    1.398915] iommu: Adding device 0000:3f:03.1 to group 30
[    1.398989] iommu: Adding device 0000:3f:03.2 to group 30
[    1.399063] iommu: Adding device 0000:3f:03.4 to group 30
[    1.399167] iommu: Adding device 0000:3f:04.0 to group 31
[    1.399242] iommu: Adding device 0000:3f:04.1 to group 31
[    1.399316] iommu: Adding device 0000:3f:04.2 to group 31
[    1.399391] iommu: Adding device 0000:3f:04.3 to group 31
[    1.399494] iommu: Adding device 0000:3f:05.0 to group 32
[    1.399569] iommu: Adding device 0000:3f:05.1 to group 32
[    1.399644] iommu: Adding device 0000:3f:05.2 to group 32
[    1.399719] iommu: Adding device 0000:3f:05.3 to group 32
[    1.399823] iommu: Adding device 0000:3f:06.0 to group 33
[    1.399898] iommu: Adding device 0000:3f:06.1 to group 33
[    1.399973] iommu: Adding device 0000:3f:06.2 to group 33
[    1.400055] iommu: Adding device 0000:3f:06.3 to group 33
[    1.402445] audit: initializing netlink subsys (disabled)
[    1.402554] audit: type=2000 audit(1505823155.400:1): state=initialized audit_enabled=0 res=1
[    1.402675] workingset: timestamp_bits=44 max_order=25 bucket_order=0
[    1.404873] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.405006] io scheduler noop registered
[    1.405059] io scheduler deadline registered
[    1.405157] io scheduler cfq registered (default)
[    1.405211] io scheduler mq-deadline registered
[    1.405898] intel_idle: MWAIT substates: 0x1120
[    1.405899] intel_idle: v0.4.1 model 0x1A
[    1.406390] intel_idle: lapic_timer_reliable_states 0x2
[    1.406792] ERST: Failed to get Error Log Address Range.
[    1.406930] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
[    1.407052] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.427498] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.447989] serial8250: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    1.448856] Linux agpgart interface v0.103
[    1.451325] HP HPSA Driver (v 3.4.20-0)
[    1.451398] hpsa 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
[    1.451744] hpsa 0000:03:00.0: Logical aborts not supported
[    1.451801] hpsa 0000:03:00.0: HP SSD Smart Path aborts not supported
[    1.488817] scsi host0: hpsa
[    1.488925] hpsa can't handle SMP requests
[    1.489054] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    1.491047] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.491106] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.491193] rtc_cmos 00:04: RTC can wake from S4
[    1.491491] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.491579] rtc_cmos 00:04: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[    1.492224] NET: Registered protocol family 10
[    1.495651] Segment Routing with IPv6
[    1.495732] NET: Registered protocol family 17
[    1.498370] RAS: Correctable Errors collector initialized.
[    1.498461] microcode: sig=0x106a5, pf=0x1, revision=0x1b
[    1.499391] microcode: Microcode Update Driver: v2.2.
[    1.499401] sched_clock: Marking stable (1499385661, 0)->(1628144851, -128759190)
[    1.505203] hpsa 0000:03:00.0: scsi 0:0:0:0: added RAID              HP       P410i            controller SSDSmartPathCap- En- Exp=1
[    1.505203] hpsa 0000:03:00.0: scsi 0:0:1:0: masked Direct-Access     HP       DH072ABAA6       PHYS DRV SSDSmartPathCap- En- Exp=0
[    1.505203] hpsa 0000:03:00.0: scsi 0:0:2:0: masked Direct-Access     HP       DH072ABAA6       PHYS DRV SSDSmartPathCap- En- Exp=0
[    1.505203] hpsa 0000:03:00.0: scsi 0:0:3:0: masked Direct-Access     HP       DH072ABAA6       PHYS DRV SSDSmartPathCap- En- Exp=0
[    1.505203] hpsa 0000:03:00.0: scsi 0:0:4:0: masked Direct-Access     HP       DH072ABAA6       PHYS DRV SSDSmartPathCap- En- Exp=0
[    1.505203] hpsa 0000:03:00.0: scsi 0:0:5:0: masked Enclosure         PMCSIERA  SRC 8x6G        enclosure SSDSmartPathCap- En- Exp=0
[    1.505203] hpsa 0000:03:00.0: scsi 0:1:0:0: added Direct-Access     HP       LOGICAL VOLUME   RAID-1(+0) SSDSmartPathCap- En- Exp=1
[    1.505203] hpsa can't handle SMP requests
[    1.505203] scsi 0:0:0:0: RAID              HP       P410i            6.64 PQ: 0 ANSI: 5
[    1.508008] scsi 0:1:0:0: Direct-Access     HP       LOGICAL VOLUME   6.64 PQ: 0 ANSI: 5
[    1.508292] registered taskstats version 1
[    1.508922] sd 0:1:0:0: [sda] 286615665 512-byte logical blocks: (147 GB/137 GiB)
[    1.509094] sd 0:1:0:0: [sda] Write Protect is off
[    1.509151] sd 0:1:0:0: [sda] Mode Sense: 6b 00 00 08
[    1.509305] rtc_cmos 00:04: setting system clock to 2017-09-19 12:12:36 UTC (1505823156)
[    1.509334] sd 0:1:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.516983]  sda: sda1 sda2 < sda5 >
[    1.518293] sd 0:1:0:0: [sda] Attached SCSI disk
[    1.615382] EXT4-fs (sda1): couldn't mount as ext3 due to feature incompatibilities
[    1.615965] EXT4-fs (sda1): couldn't mount as ext2 due to feature incompatibilities
[    1.625120] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.625202] VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
[    1.632298] devtmpfs: mounted
[    1.634703] Freeing unused kernel memory: 832K
[    1.634757] Write protecting the kernel read-only data: 10240k
[    1.638541] Freeing unused kernel memory: 828K
[    1.643866] Freeing unused kernel memory: 1856K
[    1.650079] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    2.330676] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.428262] tsc: Refined TSC clocksource calibration: 2533.422 MHz
[    2.428567] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x24848ea16a3, max_idle_ns: 440795313972 ns
[    2.509392] systemd[1]: systemd 234 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN default-hierarchy=hybrid)
[    2.509760] systemd[1]: Detected architecture x86-64.
[    2.521813] systemd[1]: Set hostname to <dl360g6>.
[    3.142079] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    3.142466] systemd[1]: Reached target Remote File Systems.
[    3.142878] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    3.143242] systemd[1]: Listening on Syslog Socket.
[    3.143565] systemd[1]: Listening on Journal Socket (/dev/log).
[    3.143901] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    3.144457] systemd[1]: Created slice System Slice.
[    3.452893] clocksource: Switched to clocksource tsc
[    3.752615] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    3.780556] systemd-journald[199]: Received request to flush runtime journal from PID 1
[    3.940096] hpwdt 0000:01:04.0: HPE Watchdog Timer Driver: 1.4.0, timer margin: 30 seconds (nowayout=0).
[    3.940420] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    3.940536] ACPI: Power Button [PWRF]
[    3.941800] libata version 3.00 loaded.
[    3.943773] EDAC MC1: Giving out device to module i7core_edac.c controller i7 core #1: DEV 0000:3e:03.0 (INTERRUPT)
[    3.943887] EDAC PCI0: Giving out device to module i7core_edac controller EDAC PCI controller: DEV 0000:3e:03.0 (POLLED)
[    3.944338] EDAC MC0: Giving out device to module i7core_edac.c controller i7 core #0: DEV 0000:3f:03.0 (INTERRUPT)
[    3.944431] EDAC PCI1: Giving out device to module i7core_edac controller EDAC PCI controller: DEV 0000:3f:03.0 (POLLED)
[    3.944522] EDAC i7core: Driver loaded, 2 memory controller(s) found.
[    3.945363] ipmi message handler version 39.2
[    3.950219] ata_piix 0000:00:1f.2: version 2.13
[    3.950312] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    3.951131] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    3.959796] ipmi device interface
[    3.966755] ipmi_si: probing via SMBIOS
[    3.966810] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[    3.966867] ipmi_si: Adding SMBIOS-specified kcs state machine
[    3.966937] ipmi_si IPI0001:00: ipmi_si: probing via ACPI
[    3.967015] ipmi_si IPI0001:00: [io  0x0ca2-0x0ca3] regsize 1 spacing 1 irq 0
[    3.967073] ipmi_si: ACPI-specified kcs state machine: duplicate
[    3.967188] IPMI System Interface driver.
[    3.967262] ipmi_si 0000:01:04.6: probing via PCI
[    3.967369] ipmi_si 0000:01:04.6: [mem 0xf5ef0000-0xf5ef00ff] regsize 1 spacing 1 irq 21
[    3.967444] ipmi_si: Adding PCI-specified kcs state machine
[    3.967521] ipmi_si: probing via SPMI
[    3.967574] ipmi_si: SPMI: io 0xca2 regsize 2 spacing 2 irq 0
[    3.967630] ipmi_si: SPMI-specified kcs state machine: duplicate
[    3.967688] ipmi_si: Trying PCI-specified kcs state machine at mem address 0xf5ef0000, slave address 0x0, irq 21
[    3.978452] (NULL device *): hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
[    3.978604] thermal LNXTHERM:00: registered as thermal_zone0
[    3.978661] ACPI: Thermal Zone [THM0] (8 C)
[    4.112761] scsi host1: ata_piix
[    4.113179] scsi host2: ata_piix
[    4.113272] ata1: SATA max UDMA/133 cmd 0x1080 ctl 0x1088 bmdma 0x10a0 irq 17
[    4.113333] ata2: SATA max UDMA/133 cmd 0x1090 ctl 0x1098 bmdma 0x10a8 irq 17
[    4.113498] ACPI Warning: SystemIO range 0x0000000000000928-0x000000000000092F conflicts with OpRegion 0x0000000000000920-0x000000000000092F (\SGPE) (20170728/utaddress-247)
[    4.113617] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.113725] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    4.139807] ACPI: bus type USB registered
[    4.139880] usbcore: registered new interface driver usbfs
[    4.139942] usbcore: registered new interface driver hub
[    4.140051] usbcore: registered new device driver usb
[    4.143950] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[    4.153046] pps_core: LinuxPPS API ver. 1 registered
[    4.153104] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    4.155049] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.172462] bnx2: QLogic bnx2 Gigabit Ethernet Driver v2.2.6 (January 29, 2014)
[    4.172619] ehci-pci: EHCI PCI platform driver
[    4.172848] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    4.172909] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    4.172994] ehci-pci 0000:00:1d.7: debug port 1
[    4.173414] bnx2 0000:02:00.0 eth0: Broadcom NetXtreme II BCM5709 1000Base-T (C0) PCI Express found at mem f8000000, IRQ 42, node addr 00:26:55:1a:e8:90
[    4.174274] bnx2 0000:02:00.1 eth1: Broadcom NetXtreme II BCM5709 1000Base-T (C0) PCI Express found at mem f6000000, IRQ 43, node addr 00:26:55:1a:e8:92
[    4.176956] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[    4.176974] ehci-pci 0000:00:1d.7: irq 20, io mem 0xf5df0000
[    4.179186] PTP clock support registered
[    4.186357] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[    4.186415] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    4.186610] e1000e 0000:04:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    4.196064] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.196357] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.196420] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.196495] usb usb1: Product: EHCI Host Controller
[    4.196553] usb usb1: Manufacturer: Linux 4.14.0-rc1-00013-gebb2c2437d80 ehci_hcd
[    4.196625] usb usb1: SerialNumber: 0000:00:1d.7
[    4.196963] hub 1-0:1.0: USB hub found
[    4.197077] hub 1-0:1.0: 8 ports detected
[    4.225242] power_meter ACPI000D:00: Found ACPI power meter.
[    4.225315] power_meter ACPI000D:00: Ignoring unsafe software power cap!
[    4.225376] power_meter ACPI000D:00: hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
[    4.252181] iTCO_vendor_support: vendor-support=0
[    4.257105] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    4.257183] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[    4.316848] uhci_hcd: USB Universal Host Controller Interface driver
[    4.317017] scsi 0:0:0:0: Attached scsi generic sg0 type 12
[    4.317064] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.317071] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    4.317080] uhci_hcd 0000:00:1d.0: detected 2 ports
[    4.317112] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001000
[    4.317219] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    4.317221] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.317222] usb usb2: Product: UHCI Host Controller
[    4.317224] usb usb2: Manufacturer: Linux 4.14.0-rc1-00013-gebb2c2437d80 uhci_hcd
[    4.317225] usb usb2: SerialNumber: 0000:00:1d.0
[    4.317367] hub 2-0:1.0: USB hub found
[    4.317386] hub 2-0:1.0: 2 ports detected
[    4.317618] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.317622] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    4.317628] uhci_hcd 0000:00:1d.1: detected 2 ports
[    4.317658] uhci_hcd 0000:00:1d.1: irq 23, io base 0x00001020
[    4.317755] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.317757] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.317758] usb usb3: Product: UHCI Host Controller
[    4.317759] usb usb3: Manufacturer: Linux 4.14.0-rc1-00013-gebb2c2437d80 uhci_hcd
[    4.317760] usb usb3: SerialNumber: 0000:00:1d.1
[    4.317898] hub 3-0:1.0: USB hub found
[    4.317908] hub 3-0:1.0: 2 ports detected
[    4.318111] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.318116] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    4.318122] uhci_hcd 0000:00:1d.2: detected 2 ports
[    4.318145] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001040
[    4.318237] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.318238] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.318239] usb usb4: Product: UHCI Host Controller
[    4.318240] usb usb4: Manufacturer: Linux 4.14.0-rc1-00013-gebb2c2437d80 uhci_hcd
[    4.318241] usb usb4: SerialNumber: 0000:00:1d.2
[    4.318383] hub 4-0:1.0: USB hub found
[    4.318394] hub 4-0:1.0: 2 ports detected
[    4.318589] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    4.318593] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    4.318599] uhci_hcd 0000:00:1d.3: detected 2 ports
[    4.318622] uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001060
[    4.318709] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.318710] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.318711] usb usb5: Product: UHCI Host Controller
[    4.318712] usb usb5: Manufacturer: Linux 4.14.0-rc1-00013-gebb2c2437d80 uhci_hcd
[    4.318713] usb usb5: SerialNumber: 0000:00:1d.3
[    4.318854] hub 5-0:1.0: USB hub found
[    4.318864] hub 5-0:1.0: 2 ports detected
[    4.319026] uhci_hcd 0000:01:04.4: UHCI Host Controller
[    4.319030] uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 6
[    4.319046] uhci_hcd 0000:01:04.4: detected 8 ports
[    4.319047] uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
[    4.319678] uhci_hcd 0000:01:04.4: irq 22, io base 0x00003800
[    4.319888] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.319890] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.319891] usb usb6: Product: UHCI Host Controller
[    4.319892] usb usb6: Manufacturer: Linux 4.14.0-rc1-00013-gebb2c2437d80 uhci_hcd
[    4.319893] usb usb6: SerialNumber: 0000:01:04.4
[    4.319987] hub 6-0:1.0: USB hub found
[    4.319997] hub 6-0:1.0: 2 ports detected
[    4.321319] sd 0:1:0:0: Attached scsi generic sg1 type 0
[    4.352859] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 10.00.00.01-k.
[    4.353053] qla2xxx [0000:07:00.0]-001d: : Found an ISP2432 irq 46 iobase 0xffffc90006295000.
[    4.353502] qla2xxx [0000:07:00.0]-0034:3: MSI-X: Unsupported ISP 2432 SSVID/SSDID (0x103C,0x7041).
[    4.365154] e1000e 0000:04:00.0 eth2: (PCI Express:2.5GT/s:Width x4) 00:1b:78:59:c4:e6
[    4.365238] e1000e 0000:04:00.0 eth2: Intel(R) PRO/1000 Network Connection
[    4.365380] e1000e 0000:04:00.0 eth2: MAC: 0, PHY: 4, PBA No: D51930-003
[    4.365597] e1000e 0000:04:00.1: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    4.369948] bnx2 0000:02:00.1 enp2s0f1: renamed from eth1
[    4.396597] bnx2 0000:02:00.0 enp2s0f0: renamed from eth0
[    4.433255] [drm] radeon kernel modesetting enabled.
[    4.433781] [drm] initializing kernel modesetting (RV100 0x1002:0x515E 0x103C:0x31FB 0x02).
[    4.433948] radeon 0000:01:03.0: VRAM: 128M 0x00000000E8000000 - 0x00000000EFFFFFFF (64M used)
[    4.434024] radeon 0000:01:03.0: GTT: 512M 0x00000000C8000000 - 0x00000000E7FFFFFF
[    4.434102] [drm] Detected VRAM RAM=128M, BAR=128M
[    4.434156] [drm] RAM width 16bits DDR
[    4.434440] [TTM] Zone  kernel: Available graphics memory: 37145630 kiB
[    4.434500] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    4.434560] [TTM] Initializing pool allocator
[    4.434620] [TTM] Initializing DMA pool allocator
[    4.434721] [drm] radeon: 64M of VRAM memory ready
[    4.434775] [drm] radeon: 512M of GTT memory ready.
[    4.434846] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    4.445367] NMI: PCI system error (SERR) for reason b1 on CPU 0.
[    4.445368] Dazed and confused, but trying to continue
[    4.445496] DMAR: DRHD: handling fault status reg 2
[    4.445557] DMAR: [DMA Read] Request device [00:1e.0] fault addr 12000 [fault reason 06] PTE Read access is not set
[    4.455210] [drm] PCI GART of 512M enabled (table at 0x00000000FFF00000).
[    4.455285] radeon 0000:01:03.0: WB disabled
[    4.455341] radeon 0000:01:03.0: fence driver on ring 0 use gpu addr 0x00000000c8000000 and cpu addr 0xffff8800d7002000
[    4.455420] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    4.455477] [drm] Driver supports precise vblank timestamp query.
[    4.455542] [drm] radeon: irq initialized.
[    4.455602] [drm] Loading R100 Microcode
[    4.464179] [drm] radeon: ring at 0x00000000C8001000
[    4.464264] [drm] ring test succeeded in 1 usecs
[    4.464521] [drm] ib test succeeded in 0 usecs
[    4.464745] [drm] No TV DAC info found in BIOS
[    4.464821] [drm] Radeon Display Connectors
[    4.464877] [drm] Connector 0:
[    4.464928] [drm]   VGA-1
[    4.464979] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[    4.465035] [drm]   Encoders:
[    4.465085] [drm]     CRT1: INTERNAL_DAC1
[    4.465138] [drm] Connector 1:
[    4.465189] [drm]   VGA-2
[    4.465240] [drm]   DDC: 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c
[    4.465296] [drm]   Encoders:
[    4.465346] [drm]     CRT2: INTERNAL_DAC2
[    4.509238] [drm] fb mappable at 0xE8040000
[    4.509293] [drm] vram apper at 0xE8000000
[    4.509346] [drm] size 1572864
[    4.509397] [drm] fb depth is 16
[    4.509448] [drm]    pitch is 2048
[    4.509696] fbcon: radeondrmfb (fb0) is primary device
[    4.548912] e1000e 0000:04:00.1 eth0: (PCI Express:2.5GT/s:Width x4) 00:1b:78:59:c4:e7
[    4.548914] e1000e 0000:04:00.1 eth0: Intel(R) PRO/1000 Network Connection
[    4.548990] e1000e 0000:04:00.1 eth0: MAC: 0, PHY: 4, PBA No: D51930-003
[    4.580148] e1000e 0000:04:00.0 ens1f0: renamed from eth2
[    4.664315] usb 6-1: new full-speed USB device number 2 using uhci_hcd
[    4.676453] Console: switching to colour frame buffer device 128x48
[    4.693847] radeon 0000:01:03.0: fb0: radeondrmfb frame buffer device
[    4.708318] CE: hpet increased min_delta_ns to 20115 nsec
[    4.732405] ipmi_si 0000:01:04.6: Using irq 21
[    4.736422] [drm] Initialized radeon 2.50.0 20080528 for 0000:01:03.0 on minor 0
[    4.736678] e1000e 0000:04:00.1 ens1f1: renamed from eth0
[    4.756413] ata2.00: SATA link down (SStatus 4 SControl 300)
[    4.756594] ata2.01: SATA link down (SStatus 4 SControl 300)
[    4.762568] ipmi_si 0000:01:04.6: Found new BMC (man_id: 0x00000b, prod_id: 0x2000, dev_id: 0x11)
[    4.763006] ipmi_si 0000:01:04.6: IPMI kcs interface initialized
[    4.792522] scsi host3: qla2xxx
[    4.793409] qla2xxx [0000:07:00.0]-00fb:3: QLogic HPAE312A - PCI-Express Dual Port 4Gb Fibre Channel HBA.
[    4.793690] qla2xxx [0000:07:00.0]-00fc:3: ISP2432: PCIe (2.5GT/s x4) @ 0000:07:00.0 hdma+ host#=3 fw=8.03.00 (9496).
[    4.794175] qla2xxx [0000:07:00.1]-001d: : Found an ISP2432 irq 49 iobase 0xffffc9000629d000.
[    4.794927] qla2xxx [0000:07:00.1]-0034:4: MSI-X: Unsupported ISP 2432 SSVID/SSDID (0x103C,0x7041).
[    4.797245] IPMI SSIF Interface driver
[    4.836203] usb 6-1: New USB device found, idVendor=03f0, idProduct=1027
[    4.842668] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.849135] usb 6-1: Product: Virtual Keyboard
[    4.855504] usb 6-1: Manufacturer: HP
[    4.895763] hidraw: raw HID events driver (C) Jiri Kosina
[    4.904443] ata1.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.911062] ata1.01: SATA link down (SStatus 4 SControl 300)
[    4.917720] ata1.01: link offline, clearing class 3 to NONE
[    4.920337] ata1.00: ATAPI: DV-28S-V, C.0F, max UDMA/100
[    4.937682] usbcore: registered new interface driver usbhid
[    4.944604] usbhid: USB HID core driver
[    4.968523] ata1.00: configured for UDMA/100
[    5.018065] scsi: waiting for bus probes to complete ...
[    5.018601] Adding 25153532k swap on /dev/sda5.  Priority:-2 extents:1 across:25153532k 
[    5.035676] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:1e.0/0000:01:04.4/usb6/6-1/6-1:1.0/0003:03F0:1027.0001/input/input6
[    5.092877] hid-generic 0003:03F0:1027.0001: input,hidraw0: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1/input0
[    5.108861] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:1e.0/0000:01:04.4/usb6/6-1/6-1:1.1/0003:03F0:1027.0002/input/input7
[    5.126049] hid-generic 0003:03F0:1027.0002: input,hidraw1: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1/input1
[    5.208656] scsi host4: qla2xxx
[    5.218270] qla2xxx [0000:07:00.1]-00fb:4: QLogic HPAE312A - PCI-Express Dual Port 4Gb Fibre Channel HBA.
[    5.227410] qla2xxx [0000:07:00.1]-00fc:4: ISP2432: PCIe (2.5GT/s x4) @ 0000:07:00.1 hdma+ host#=4 fw=8.03.00 (9496).
[    5.856346] random: crng init done
[    6.046399] bnx2 0000:02:00.0 enp2s0f0: using MSIX
[    6.054370] IPv6: ADDRCONF(NETDEV_UP): enp2s0f0: link is not ready
[    6.373728] ACPI Error: SMBus/IPMI/GenericSerialBus write requires Buffer of length 66, found length 32 (20170728/exfield-427)
[    6.390164] ACPI Error: Method parse/execution failed \_SB.PMI0._PMM, AE_AML_BUFFER_LIMIT (20170728/psparse-550)
[    6.390175] ACPI Exception: AE_AML_BUFFER_LIMIT, Evaluating _PMM (20170728/power_meter-338)
[    7.662672] bnx2 0000:02:00.0 enp2s0f0: NIC Copper Link is Up, 100 Mbps full duplex
[    7.669162] IPv6: ADDRCONF(NETDEV_CHANGE): enp2s0f0: link becomes ready
[    9.839554] scsi 1:0:0:0: CD-ROM            TEAC     DV-28S-V         C.0F PQ: 0 ANSI: 5
[    9.893187] scsi 1:0:0:0: Attached scsi generic sg2 type 5
[   10.339878] sr 1:0:0:0: [sr0] scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[   10.340096] cdrom: Uniform CD-ROM driver Revision: 3.20
[   10.340516] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   26.300340] qla2xxx [0000:07:00.0]-8038:3: Cable is unplugged...
[   26.716307] qla2xxx [0000:07:00.1]-8038:4: Cable is unplugged...
[ 6137.192676] systemd: 27 output lines suppressed due to ratelimiting
[ 6137.256475] systemd-journald[199]: Received SIGTERM from PID 1 (systemd).
[ 6159.911913] device-mapper: uevent: version 1.0.3
[ 6159.912184] device-mapper: ioctl: 4.36.0-ioctl (2017-06-09) initialised: dm-devel@redhat.com
[ 8238.178906] bnx2 0000:02:00.1 enp2s0f1: using MSIX
[ 8238.179091] IPv6: ADDRCONF(NETDEV_UP): enp2s0f1: link is not ready
[ 8245.268915] IPv6: ADDRCONF(NETDEV_UP): ens1f0: link is not ready
[ 8246.924987] IPv6: ADDRCONF(NETDEV_UP): ens1f1: link is not ready


-- 
Meelis Roos (mroos@linux.ee)
