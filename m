From: Simon Kirby <sim@hostway.ca>
Subject: MegaRAID: Unhandled error code since upgrading to 2.6.33.2
Date: Mon, 26 Apr 2010 12:46:49 -0700
Message-ID: <20100426194649.GE31380@hostway.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from newpeace.netnation.com ([204.174.223.7]:45724 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753417Ab0DZUHj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Apr 2010 16:07:39 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: megaraidlinux@lsi.com
Cc: linux-scsi@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

Since upgrading some old Dell 1850 boxes from 2.6.18 to 2.6.33.2, we are
seeing this error occasionally occurring:

sd 0:1:0:0: [sda] Unhandled error code
sd 0:1:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 02 77 62 0d 00 00 80 00
end_request: I/O error, dev sda, sector 41378317

...and sometimes this causes EXT3 to be unhappy and it aborts the journal
or similar, so it is having an effect on normal activity.  This error
seems to come up only every few days even though the boxes are usually
busy all day.  Two other boxes which are Dell 1950s run the exact same
kernel and software but don't see the error.

The error used to be occurring many times in a row.  I set
/sys/block/sda/device/queue_depth to 1, and now the errors only seem
to occur one at a time, but maybe that's just chance.

Anway, the boxes showing the error have:

02:0e.0 RAID bus controller: Dell PowerEdge Expandable RAID controller 4 (rev 06)
02:0e.0 0104: 1028:0013 (rev 06)

The other boxes with no errors have:

02:0e.0 RAID bus controller: Dell PowerEdge Expandable RAID controller 5
02:0e.0 0104: 1028:0015

It happens rarely enough that git bisecting it might be painful. 
If this issue hasn't been seen before, ideas for reproducing it more
readily are welcome.  These servers typically do postfix-related I/O.

Thanks!

Simon-

sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 08 0f e5 95 00 00 80 00
sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 08 13 08 2d 00 00 20 00
sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 08 22 eb d5 00 00 78 00
sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 08 11 94 8d 00 00 80 00
sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 08 10 e5 45 00 00 08 00
sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 08 22 eb 55 00 00 80 00
sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 08 22 ea d5 00 00 80 00
sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 08 10 e4 c5 00 00 40 00
sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 08 10 d1 9d 00 00 18 00
sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 08 0f e6 65 00 00 40 00
sd 0:1:0:0: [sda] CDB: Write(10): 2a 00 08 13 3b 0d 00 00 10 00

--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

Linux version 2.6.33.2-hw (root@packages01-dev) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Sat Apr 3 04:17:19 CDT 2010
Command line: root=/dev/sda1 ro rootflags=data=ordered
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 0000000000100000 - 00000000cffc0000 (usable)
 BIOS-e820: 00000000cffc0000 - 00000000cffcfc00 (ACPI data)
 BIOS-e820: 00000000cffcfc00 - 00000000cffff000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000fec90000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
DMI 2.3 present.
No AGP bridge found
last_pfn = 0x230000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-D3FFF write-protect
  D4000-EBFFF uncachable
  EC000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask E00000000 write-back
  1 base 200000000 mask FE0000000 write-back
  2 base 220000000 mask FF0000000 write-back
  3 base 0D0000000 mask FF0000000 uncachable
  4 base 0E0000000 mask FE0000000 uncachable
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000d0000000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xcffc0 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
found SMP MP-table at [ffff8800000fe710] fe710
init_memory_mapping: 0000000000000000-00000000cffc0000
 0000000000 - 00cfe00000 page 2M
 00cfe00000 - 00cffc0000 page 4k
kernel direct mapping tables up to cffc0000 @ 8000-e000
init_memory_mapping: 0000000100000000-0000000230000000
 0100000000 - 0230000000 page 2M
kernel direct mapping tables up to 230000000 @ c000-16000
ACPI: RSDP 00000000000fd6c0 00014 (v00 DELL  )
ACPI: RSDT 00000000000fd6d4 00034 (v01 DELL   PE BKC   00000001 MSFT 0100000A)
ACPI: FACP 00000000000fd708 00074 (v01 DELL   PE BKC   00000001 MSFT 0100000A)
ACPI: DSDT 00000000cffc0000 03861 (v01 DELL   PE BKC   00000001 MSFT 0100000E)
ACPI: FACS 00000000cffcfc00 00040
ACPI: APIC 00000000000fd77c 0009C (v01 DELL   PE BKC   00000001 MSFT 0100000A)
ACPI: SPCR 00000000000fd824 00050 (v01 DELL   PE BKC   00000001 MSFT 0100000A)
ACPI: HPET 00000000000fd874 00038 (v01 DELL   PE BKC   00000001 MSFT 0100000A)
ACPI: Local APIC address 0xfee00000
(11 early reservations) ==> bootmem [0000000000 - 0230000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0001000000 - 0001ab3124]    TEXT DATA BSS ==> [0001000000 - 0001ab3124]
  #2 [0001ab4000 - 0001ab4274]              BRK ==> [0001ab4000 - 0001ab4274]
  #3 [00000fe720 - 0000100000]    BIOS reserved ==> [00000fe720 - 0000100000]
  #4 [00000fe710 - 00000fe720]     MP-table mpf ==> [00000fe710 - 00000fe720]
  #5 [000009f800 - 00000f0000]    BIOS reserved ==> [000009f800 - 00000f0000]
  #6 [00000f0200 - 00000fe710]    BIOS reserved ==> [00000f0200 - 00000fe710]
  #7 [00000f0000 - 00000f0200]     MP-table mpc ==> [00000f0000 - 00000f0200]
  #8 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
  #9 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
  #10 [000000c000 - 0000011000]          PGTABLE ==> [000000c000 - 0000011000]
 [ffffea0000000000-ffffea0007bfffff] PMD -> [ffff880028600000-ffff88002f7fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00230000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x000000a0
    0: 0x00000100 -> 0x000cffc0
    0: 0x00100000 -> 0x00230000
On node 0 totalpages: 2096992
  DMA zone: 56 pages used for memmap
  DMA zone: 107 pages reserved
  DMA zone: 3837 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 833528 pages, LIFO batch:31
  Normal zone: 17024 pages used for memmap
  Normal zone: 1228160 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x00] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfec80000] gsi_base[32])
IOAPIC[1]: apic_id 3, version 32, address 0xfec80000, GSI 32-55
ACPI: IOAPIC (id[0x04] address[0xfec83000] gsi_base[64])
IOAPIC[2]: apic_id 4, version 32, address 0xfec83000, GSI 64-87
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0xffffffff base: 0xfed00000
SMP: Allowing 4 CPUs, 2 hotplug CPUs
nr_irqs_gsi: 88
Allocating PCI resources starting at cffff000 (gap: cffff000:10001000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 30 pages/cpu @ffff880028200000 s90520 r8192 d24168 u524288
pcpu-alloc: s90520 r8192 d24168 u524288 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2065525
Kernel command line: root=/dev/sda1 ro rootflags=data=ordered
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Checking aperture...
No AGP bridge found
Memory: 8180292k/9175040k available (6532k kernel code, 787072k absent, 206736k reserved, 2966k data, 528k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:1280
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2992.521 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5985.04 BogoMIPS (lpj=11970084)
Mount-cache hash table entries: 256
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 4 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
Performance Events: no PMU driver, software events only.
ACPI: Core revision 20091214
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(TM) CPU 3.00GHz stepping 01
Booting Node   0, Processors  #1
Brought up 2 CPUs
Total of 2 processors activated (11970.38 BogoMIPS).
xor: automatically using best checksumming function: generic_sse
   generic_sse:  4634.000 MB/sec
xor: using function: generic_sse (4634.000 MB/sec)
NET: Registered protocol family 16
ACPI: bus type pci registered
dca service started, version 1.12.1
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci_root PNP0A03:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xfebfffff] (ignored)
pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: PME# disabled
pci 0000:00:1d.0: reg 20: [io  0xbce0-0xbcff]
pci 0000:00:1d.1: reg 20: [io  0xbcc0-0xbcdf]
pci 0000:00:1d.2: reg 20: [io  0xbca0-0xbcbf]
pci 0000:00:1d.7: reg 10: [mem 0xdff00000-0xdff003ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x0880-0x08bf] claimed by ICH4 GPIO
pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 20: [io  0xfc00-0xfc0f]
pci 0000:00:1f.1: reg 24: [mem 0x00000000-0x000003ff]
pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
pci 0000:01:00.0: PME# disabled
pci 0000:01:00.2: PME# supported from D0 D3hot D3cold
pci 0000:01:00.2: PME# disabled
pci 0000:00:02.0: PCI bridge to [bus 01-03]
pci 0000:00:02.0:   bridge window [mem 0xdfc00000-0xdfefffff]
pci 0000:00:02.0:   bridge window [mem 0xd8000000-0xd80fffff 64bit pref]
pci 0000:02:0e.0: reg 10: [mem 0xd80f0000-0xd80fffff pref]
pci 0000:02:0e.0: reg 18: [mem 0xdfde0000-0xdfdfffff]
pci 0000:02:0e.0: reg 30: [mem 0xdfe00000-0xdfe1ffff pref]
pci 0000:02:0e.0: supports D1
pci 0000:01:00.0: PCI bridge to [bus 02-02]
pci 0000:01:00.0:   bridge window [mem 0xdfd00000-0xdfefffff]
pci 0000:01:00.0:   bridge window [mem 0xd8000000-0xd80fffff 64bit pref]
pci 0000:01:00.2: PCI bridge to [bus 03-03]
pci 0000:00:04.0: PCI bridge to [bus 04-04]
pci 0000:05:00.0: PXH quirk detected; SHPC device MSI disabled
pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
pci 0000:05:00.0: PME# disabled
pci 0000:05:00.2: PXH quirk detected; SHPC device MSI disabled
pci 0000:05:00.2: PME# supported from D0 D3hot D3cold
pci 0000:05:00.2: PME# disabled
pci 0000:00:05.0: PCI bridge to [bus 05-07]
pci 0000:00:05.0:   bridge window [io  0xd000-0xefff]
pci 0000:00:05.0:   bridge window [mem 0xdf700000-0xdfbfffff]
pci 0000:06:07.0: reg 10: [mem 0xdfae0000-0xdfafffff]
pci 0000:06:07.0: reg 18: [io  0xecc0-0xecff]
pci 0000:06:07.0: PME# supported from D0 D3hot D3cold
pci 0000:06:07.0: PME# disabled
pci 0000:05:00.0: PCI bridge to [bus 06-06]
pci 0000:05:00.0:   bridge window [io  0xe000-0xefff]
pci 0000:05:00.0:   bridge window [mem 0xdfa00000-0xdfbfffff]
pci 0000:07:08.0: reg 10: [mem 0xdf8e0000-0xdf8fffff]
pci 0000:07:08.0: reg 18: [io  0xdcc0-0xdcff]
pci 0000:07:08.0: PME# supported from D0 D3hot D3cold
pci 0000:07:08.0: PME# disabled
pci 0000:05:00.2: PCI bridge to [bus 07-07]
pci 0000:05:00.2:   bridge window [io  0xd000-0xdfff]
pci 0000:05:00.2:   bridge window [mem 0xdf800000-0xdf9fffff]
pci 0000:00:06.0: PCI bridge to [bus 08-08]
pci 0000:09:0d.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
pci 0000:09:0d.0: reg 14: [io  0xcc00-0xccff]
pci 0000:09:0d.0: reg 18: [mem 0xdf5f0000-0xdf5fffff]
pci 0000:09:0d.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:09:0d.0: supports D1 D2
pci 0000:00:1e.0: PCI bridge to [bus 09-09] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:1e.0:   bridge window [mem 0xdf500000-0xdf6fffff]
pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff pref]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PALO._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PALO.DOBA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PALO.DOBB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PBLO._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.VPR0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PBHI._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PBHI.PXB1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PBHI.PXB2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PICH._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12)
vgaarb: device added: PCI:0000:09:0d.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
raid6: int64x1   1330 MB/s
raid6: int64x2   1814 MB/s
raid6: int64x4   1803 MB/s
raid6: int64x8   1538 MB/s
raid6: sse2x1    2150 MB/s
raid6: sse2x2    2835 MB/s
raid6: sse2x4    3121 MB/s
raid6: using algorithm sse2x4 (3121 MB/s)
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
system 00:07: [io  0x0800-0x087f] has been reserved
system 00:07: [io  0x0880-0x08bf] has been reserved
system 00:07: [io  0x08c0-0x08df] has been reserved
system 00:07: [io  0x0c00-0x0c0f] has been reserved
system 00:07: [io  0x0c10-0x0c1f] has been reserved
system 00:07: [io  0x0ca0-0x0caf] has been reserved
system 00:07: [io  0x0c20-0x0c3f] has been reserved
system 00:08: [mem 0xe0000000-0xefffffff] has been reserved
pci 0000:00:1f.1: BAR 5: assigned [mem 0xd8100000-0xd81003ff]
pci 0000:00:1f.1: BAR 5: set to [mem 0xd8100000-0xd81003ff] (PCI address [0xd8100000-0xd81003ff]
pci 0000:01:00.0: PCI bridge to [bus 02-02]
pci 0000:01:00.0:   bridge window [io  disabled]
pci 0000:01:00.0:   bridge window [mem 0xdfd00000-0xdfefffff]
pci 0000:01:00.0:   bridge window [mem 0xd8000000-0xd80fffff 64bit pref]
pci 0000:01:00.2: PCI bridge to [bus 03-03]
pci 0000:01:00.2:   bridge window [io  disabled]
pci 0000:01:00.2:   bridge window [mem disabled]
pci 0000:01:00.2:   bridge window [mem pref disabled]
pci 0000:00:02.0: PCI bridge to [bus 01-03]
pci 0000:00:02.0:   bridge window [io  disabled]
pci 0000:00:02.0:   bridge window [mem 0xdfc00000-0xdfefffff]
pci 0000:00:02.0:   bridge window [mem 0xd8000000-0xd80fffff 64bit pref]
pci 0000:00:04.0: PCI bridge to [bus 04-04]
pci 0000:00:04.0:   bridge window [io  disabled]
pci 0000:00:04.0:   bridge window [mem disabled]
pci 0000:00:04.0:   bridge window [mem pref disabled]
pci 0000:05:00.0: PCI bridge to [bus 06-06]
pci 0000:05:00.0:   bridge window [io  0xe000-0xefff]
pci 0000:05:00.0:   bridge window [mem 0xdfa00000-0xdfbfffff]
pci 0000:05:00.0:   bridge window [mem pref disabled]
pci 0000:05:00.2: PCI bridge to [bus 07-07]
pci 0000:05:00.2:   bridge window [io  0xd000-0xdfff]
pci 0000:05:00.2:   bridge window [mem 0xdf800000-0xdf9fffff]
pci 0000:05:00.2:   bridge window [mem pref disabled]
pci 0000:00:05.0: PCI bridge to [bus 05-07]
pci 0000:00:05.0:   bridge window [io  0xd000-0xefff]
pci 0000:00:05.0:   bridge window [mem 0xdf700000-0xdfbfffff]
pci 0000:00:05.0:   bridge window [mem pref disabled]
pci 0000:00:06.0: PCI bridge to [bus 08-08]
pci 0000:00:06.0:   bridge window [io  disabled]
pci 0000:00:06.0:   bridge window [mem disabled]
pci 0000:00:06.0:   bridge window [mem pref disabled]
pci 0000:09:0d.0: BAR 6: assigned [mem 0xdf500000-0xdf51ffff pref]
pci 0000:00:1e.0: PCI bridge to [bus 09-09]
pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:1e.0:   bridge window [mem 0xdf500000-0xdf6fffff]
pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff pref]
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
pci 0000:01:00.0: setting latency timer to 64
pci 0000:01:00.2: setting latency timer to 64
pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:04.0: setting latency timer to 64
pci 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:05.0: setting latency timer to 64
pci 0000:05:00.0: setting latency timer to 64
pci 0000:05:00.2: setting latency timer to 64
pci 0000:00:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:06.0: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
pci_bus 0000:01: resource 1 [mem 0xdfc00000-0xdfefffff]
pci_bus 0000:01: resource 2 [mem 0xd8000000-0xd80fffff 64bit pref]
pci_bus 0000:02: resource 1 [mem 0xdfd00000-0xdfefffff]
pci_bus 0000:02: resource 2 [mem 0xd8000000-0xd80fffff 64bit pref]
pci_bus 0000:05: resource 0 [io  0xd000-0xefff]
pci_bus 0000:05: resource 1 [mem 0xdf700000-0xdfbfffff]
pci_bus 0000:06: resource 0 [io  0xe000-0xefff]
pci_bus 0000:06: resource 1 [mem 0xdfa00000-0xdfbfffff]
pci_bus 0000:07: resource 0 [io  0xd000-0xdfff]
pci_bus 0000:07: resource 1 [mem 0xdf800000-0xdf9fffff]
pci_bus 0000:09: resource 0 [io  0xc000-0xcfff]
pci_bus 0000:09: resource 1 [mem 0xdf500000-0xdf6fffff]
pci_bus 0000:09: resource 2 [mem 0xd0000000-0xd7ffffff pref]
pci_bus 0000:09: resource 3 [io  0x0000-0xffff]
pci_bus 0000:09: resource 4 [mem 0x00000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 4096 (order: 5, 131072 bytes)
UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:09:0d.0: Boot video device
PCI: CLS 64 bytes, default 64
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
software IO TLB at phys 0x20000000 - 0x24000000
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
fuse init (API version 7.13)
SGI XFS with security attributes, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
Btrfs loaded
msgmni has been set to 15978
alg: No test for stdrng (krng)
async_tx: api initialized (async)
io scheduler noop registered
io scheduler deadline registered (default)
io scheduler cfq registered
pcieport 0000:00:02.0: setting latency timer to 64
pcieport 0000:00:02.0: irq 88 for MSI/MSI-X
pcieport 0000:00:04.0: setting latency timer to 64
pcieport 0000:00:04.0: irq 89 for MSI/MSI-X
pcieport 0000:00:05.0: setting latency timer to 64
pcieport 0000:00:05.0: irq 90 for MSI/MSI-X
pcieport 0000:00:06.0: setting latency timer to 64
pcieport 0000:00:06.0: irq 91 for MSI/MSI-X
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
intel_rng: FWH not detected
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
brd: module loaded
loop: module loaded
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.20)
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
ide-cd driver 5.00
Adaptec aacraid driver 1.1-5[24702]-ms
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megaraid: probe new device 0x1028:0x0013:0x1028:0x016c: bus 2:slot 14:func 0
megaraid 0000:02:0e.0: PCI INT A -> GSI 46 (level, low) -> IRQ 46
megaraid: fw version:[513O] bios version:[H418]
scsi0 : LSI Logic MegaRAID driver
scsi[0]: scanning scsi channel 0 [Phy 0] for non-raid devices
scsi 0:0:6:0: Processor         PE/PV    1x2 SCSI BP      1.0  PQ: 0 ANSI: 2
scsi[0]: scanning scsi channel 1 [virtual] for logical drives
scsi 0:1:0:0: Direct-Access     MegaRAID LD 0 RAID1   69G 513O PQ: 0 ANSI: 2
megasas: 00.00.04.12-rc1 Thu Sep. 17 11:41:51 PST 2009
GDT-HA: Storage RAID Controller Driver. Version: 3.05
3ware Storage Controller device driver for Linux v1.26.02.002.
3ware 9000 Storage Controller device driver for Linux v2.26.02.013.
sd 0:1:0:0: [sda] 143114240 512-byte logical blocks: (73.2 GB/68.2 GiB)
sd 0:1:0:0: [sda] Write Protect is off
sd 0:1:0:0: [sda] Mode Sense: 00 00 00 00
sd 0:1:0:0: [sda] Asking for cache data failed
sd 0:1:0:0: [sda] Assuming drive cache: write through
sd 0:1:0:0: [sda] Asking for cache data failed
sd 0:1:0:0: [sda] Assuming drive cache: write through
 sda:
scsi 0:0:6:0: Attached scsi generic sg0 type 3
 sda1 sda2 sda3 sda4 <
sd 0:1:0:0: Attached scsi generic sg1 type 0
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
ata_piix 0000:00:1f.1: can't derive routing for PCI INT A
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi1 : ata_piix
scsi2 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
console [netcon0] enabled
netconsole: network logging started
Fusion MPT base driver 3.04.13
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.13
Fusion MPT FC Host driver 3.04.13
Fusion MPT SAS Host driver 3.04.13
Fusion MPT misc device (ioctl) driver 3.04.13
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xdff00000
 sda5 sda6 >
sd 0:1:0:0: [sda] Asking for cache data failed
sd 0:1:0:0: [sda] Assuming drive cache: write through
sd 0:1:0:0: [sda] Attached SCSI disk
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.33.2-hw ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000bce0
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.33.2-hw uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000bcc0
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.33.2-hw uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000bca0
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.33.2-hw uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usbcore: registered new interface driver libusual
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input1
rtc_cmos 00:04: RTC can wake from S4
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, y3k, 242 bytes nvram, hpet irqs
Software Watchdog Timer: 0.07 initialized. soft_noboot=0 soft_margin=60 sec (nowayout= 0)
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
ioatdma: Intel(R) QuickData Technology Driver 4.00
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
registered taskstats version 1
rtc_cmos 00:04: setting system clock to 2010-04-15 20:57:54 UTC (1271365074)
ata1.00: ATAPI: SAMSUNG CD-ROM SN-124, N104, max UDMA/33
ata1.00: configured for UDMA/33
scsi 1:0:0:0: CD-ROM            SAMSUNG  CD-ROM SN-124    N104 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr 1:0:0:0: Attached scsi generic sg2 type 5
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda1): mounted filesystem with ordered data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
Freeing unused kernel memory: 528k freed
usb 1-3: new high speed USB device using ehci_hcd and address 2
usb 1-3: New USB device found, idVendor=413c, idProduct=a001
usb 1-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-3:1.0: USB hub found
hub 1-3:1.0: 2 ports detected
usb 4-2: new low speed USB device using uhci_hcd and address 2
Adding 1036184k swap on /dev/sda3.  Priority:-1 extents:1 across:1036184k 
EXT3-fs (sda1): using internal journal
usb 4-2: New USB device found, idVendor=413c, idProduct=2105
usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-2: Product: Dell USB Keyboard
usb 4-2: Manufacturer: Dell
input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:1d.2/usb4/4-2/4-2:1.0/input/input2
generic-usb 0003:413C:2105.0001: input,hidraw0: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.2-2/input0
Intel(R) PRO/1000 Network Driver - version 7.3.21-k5-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e1000 0000:06:07.0: PCI INT A -> GSI 64 (level, low) -> IRQ 64
e1000: 0000:06:07.0: e1000_probe: (PCI:66MHz:32-bit) 00:11:43:d7:40:bf
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000 0000:07:08.0: PCI INT A -> GSI 65 (level, low) -> IRQ 65
e1000: 0000:07:08.0: e1000_probe: (PCI:66MHz:32-bit) 00:11:43:d7:40:c0
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda2): using internal journal
EXT3-fs (sda2): mounted filesystem with writeback data mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda5): using internal journal
EXT3-fs (sda5): mounted filesystem with ordered data mode
IPv4 FIB: Using LC-trie version 0.409
e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX

--8t9RHnE3ZwKMSgU+--
