From: Sachin Sant <sachinp@in.ibm.com>
Subject: [-next Feb 9] Boot failure on x86_64: mptbase fails to initialize
Date: Tue, 09 Feb 2010 18:11:45 +0530
Message-ID: <4B715809.6000202@in.ibm.com>
References: <20100209190736.fe252102.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040404030109070706020602"
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20100209190736.fe252102.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Eric.Moore@lsi.com
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040404030109070706020602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Today's next failed to boot on my 4 way x86_64 box because
of mptbase driver initialization failure.

Snippet of messages during boot :

Fusion MPT SAS Host driver 3.04.14
mptsas 0000:03:04.0: can't find IRQ for PCI INT A; probably buggy MP table
mptbase: ioc0: Initiating bringup
ioc0: LSISAS1064 A3: Capabilities={Initiator}
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x1, page 0x2, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x1, page 0x1, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!

Eventually machine fails to boot. I have similar problem on
a x86 box but with IPS driver. So might not be a driver specific
issue. 

I had similar problem with yesterday's next.IIRC the last successful boot was with next-20100203.

Have attached the boot log from x86_64 box.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------


--------------040404030109070706020602
Content-Type: text/plain;
 name="dmesg_next_0209"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg_next_0209"

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.33-rc7-autotest-next-20100209 (root@mls21b) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP Tue Feb 9 15:56:08 IST 2010
Command line: root=/dev/disk/by-id/scsi-3500000e015c26a80-part1 console=tty0 console=ttyS1,19200 IDENT=1265712119
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009c000 (usable)
 BIOS-e820: 000000000009c000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cffa3900 (usable)
 BIOS-e820: 00000000cffa3900 - 00000000cffa7400 (ACPI data)
 BIOS-e820: 00000000cffa7400 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000f4000000 - 00000000fc000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
NX (Execute Disable) protection: active
DMI 2.4 present.
No AGP bridge found
last_pfn = 0x130000 max_arch_pfn = 0x400000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xcffa3 max_arch_pfn = 0x400000000
found SMP MP-table at [ffff88000009c140] 9c140
init_memory_mapping: 0000000000000000-00000000cffa3000
init_memory_mapping: 0000000100000000-0000000130000000
RAMDISK: 37702000 - 37fefbdf
ACPI: RSDP 00000000000fdfe0 00014 (v00 IBM   )
ACPI: RSDT 00000000cffa7380 00038 (v01 IBM    SERLEWIS 00001000 IBM  45444F43)
ACPI: FACP 00000000cffa72c0 00084 (v02 IBM    SERLEWIS 00001000 IBM  45444F43)
ACPI: DSDT 00000000cffa3900 036CE (v01 IBM    SERLEWIS 00001000 INTL 20060912)
ACPI: FACS 00000000cffa7040 00040
ACPI: APIC 00000000cffa7200 00090 (v01 IBM    SERLEWIS 00001000 IBM  45444F43)
ACPI: SRAT 00000000cffa7100 000E8 (v01 AMD    HAMMER   00000001 AMD  00000001)
ACPI: HPET 00000000cffa70c0 00038 (v01 IBM    SERLEWIS 00001000 IBM  45444F43)
ACPI: MCFG 00000000cffa7080 0003C (v01 IBM    SERLEWIS 00001000 IBM  45444F43)
SRAT: PXM 0 -> APIC 0x00 -> Node 0
SRAT: PXM 0 -> APIC 0x01 -> Node 0
SRAT: PXM 1 -> APIC 0x02 -> Node 1
SRAT: PXM 1 -> APIC 0x03 -> Node 1
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 100000-d0000000
SRAT: Node 0 PXM 0 100000000-130000000
Bootmem setup node 0 0000000000000000-0000000130000000
  NODE_DATA [000000000000f640 - 000000000002363f]
  bootmap [0000000000024000 -  0000000000049fff] pages 26
(14 early reservations) ==> bootmem [0000000000 - 0130000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0001000000 - 0005e8a494]    TEXT DATA BSS ==> [0001000000 - 0005e8a494]
  #2 [0037702000 - 0037fefbdf]          RAMDISK ==> [0037702000 - 0037fefbdf]
  #3 [0005e8b000 - 0005e8b2d0]              BRK ==> [0005e8b000 - 0005e8b2d0]
  #4 [000009c000 - 000009c140]    BIOS reserved ==> [000009c000 - 000009c140]
  #5 [000009c140 - 000009c150]     MP-table mpf ==> [000009c140 - 000009c150]
  #6 [000009c150 - 000009dce0]    BIOS reserved ==> [000009c150 - 000009dce0]
  #7 [000009de64 - 0000100000]    BIOS reserved ==> [000009de64 - 0000100000]
  #8 [000009dce0 - 000009de64]     MP-table mpc ==> [000009dce0 - 000009de64]
  #9 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
  #10 [0000003000 - 0000007000]      ACPI WAKEUP ==> [0000003000 - 0000007000]
  #11 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
  #12 [000000c000 - 000000d000]          PGTABLE ==> [000000c000 - 000000d000]
  #13 [000000d000 - 000000f640]       MEMNODEMAP ==> [000000d000 - 000000f640]
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00130000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000001 -> 0x0000009c
    0: 0x00000100 -> 0x000cffa3
    0: 0x00100000 -> 0x00130000
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x488
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 14, version 17, address 0xfec00000, GSI 0-15
ACPI: IOAPIC (id[0x0d] address[0xfec02000] gsi_base[16])
IOAPIC[1]: apic_id 13, version 17, address 0xfec02000, GSI 16-31
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x1166a201 base: 0xfed00000
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 00000000cffa3000 - 00000000cffa4000
PM: Registered nosave memory: 00000000cffa4000 - 00000000cffa7000
PM: Registered nosave memory: 00000000cffa7000 - 00000000cffa8000
PM: Registered nosave memory: 00000000cffa8000 - 00000000d0000000
PM: Registered nosave memory: 00000000d0000000 - 00000000f4000000
PM: Registered nosave memory: 00000000f4000000 - 00000000fc000000
PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
Allocating PCI resources starting at d0000000 (gap: d0000000:24000000)
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:2
PERCPU: Embedded 28 pages/cpu @ffff880009c00000 s85544 r8192 d20952 u524288
pcpu-alloc: s85544 r8192 d20952 u524288 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1031245
Policy zone: Normal
Kernel command line: root=/dev/disk/by-id/scsi-3500000e015c26a80-part1 console=tty0 console=ttyS1,19200 IDENT=1265712119
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ f4000000 size 64 MB
Node 1: aperture @ f4000000 size 64 MB
Memory: 3977660k/4980736k available (3446k kernel code, 787208k absent, 215868k reserved, 4993k data, 952k init)
Hierarchical RCU implementation.
RCU-based detection of stalled CPUs is enabled.
NR_IRQS:4352
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS1] enabled
allocated 41943040 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
Fast TSC calibration using PIT
Detected 2199.695 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4399.39 BogoMIPS (lpj=8798780)
Security Framework initialized
SELinux:  Disabled at boot.
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
using C1E aware idle routine
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
ACPI: Core revision 20100121
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:111 __ioremap_caller+0x169/0x2f1()
Hardware name: BladeCenter LS21 -[79716AA]-
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.33-rc7-autotest-next-20100209 #1
Call Trace:
 [<ffffffff81023d4b>] ? __ioremap_caller+0x169/0x2f1
 [<ffffffff81040685>] warn_slowpath_common+0x77/0xa4
 [<ffffffff810406c1>] warn_slowpath_null+0xf/0x11
 [<ffffffff81023d4b>] __ioremap_caller+0x169/0x2f1
 [<ffffffff81346065>] ? acpi_os_map_memory+0x12/0x1b
 [<ffffffff81023f5c>] ioremap_nocache+0x12/0x14
 [<ffffffff81346065>] acpi_os_map_memory+0x12/0x1b
 [<ffffffff81259f04>] acpi_tb_verify_table+0x29/0x5b
 [<ffffffff81259754>] acpi_load_tables+0x39/0x15a
 [<ffffffff8187fc14>] acpi_early_init+0x60/0xf5
 [<ffffffff81855cad>] start_kernel+0x397/0x3a7
 [<ffffffff81855295>] x86_64_start_reservations+0xa5/0xa9
 [<ffffffff8185537a>] x86_64_start_kernel+0xe1/0xe8
---[ end trace 4eaa2a86a8e2da22 ]---
ioremap reserve_memtype failed -22
ACPI Exception: AE_NO_ACPI_TABLES, While loading namespace from ACPI tables (20100121/tbxface-604)
ACPI: Unable to load the System Description Tables
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Dual-Core AMD Opteron(tm) Processor 2218 stepping 02
Booting Node   0, Processors  #1 #2 #3 Ok.
Brought up 4 CPUs
Total of 4 processors activated (17600.10 BogoMIPS).
devtmpfs: initialized
NET: Registered protocol family 16
TOM: 00000000d0000000 aka 3328M
TOM2: 0000000130000000 aka 4864M
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Interpreter disabled.
vgaarb: loaded
PCI: Probing PCI hardware
pci 0000:00:01.0: Enabling HT MSI Mapping
pci 0000:00:01.0: PCI bridge to [bus 01-02]
pci 0000:01:0d.0: PCI bridge to [bus 02-02]
pci 0000:00:06.0: PCI bridge to [bus 03-03]
pci 0000:00:07.0: PCI bridge to [bus 04-04]
pci 0000:00:08.0: PCI bridge to [bus 05-05]
pci 0000:00:09.0: PCI bridge to [bus 06-06]
pci 0000:00:0a.0: PCI bridge to [bus 07-07]
pci 0000:00:0b.0: PCI bridge to [bus 08-08]
vgaarb: device added: PCI:0000:00:05.0,decodes=io+mem,owns=io+mem,locks=none
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI: disabled
pci 0000:00:06.0: BAR 9: assigned [mem 0xd0000000-0xd00fffff pref]
pci 0000:00:05.0: BAR 6: assigned [mem 0xd0100000-0xd011ffff pref]
pci 0000:01:0d.0: PCI bridge to [bus 02-02]
pci 0000:01:0d.0:   bridge window [io  disabled]
pci 0000:01:0d.0:   bridge window [mem 0xe2000000-0xe6ffffff]
pci 0000:01:0d.0:   bridge window [mem pref disabled]
pci 0000:00:01.0: PCI bridge to [bus 01-02]
pci 0000:00:01.0:   bridge window [io  disabled]
pci 0000:00:01.0:   bridge window [mem 0xe2000000-0xe7ffffff]
pci 0000:00:01.0:   bridge window [mem pref disabled]
pci 0000:03:04.0: BAR 6: assigned [mem 0xd0000000-0xd00fffff pref]
pci 0000:00:06.0: PCI bridge to [bus 03-03]
pci 0000:00:06.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:06.0:   bridge window [mem 0xdf000000-0xe00fffff]
pci 0000:00:06.0:   bridge window [mem 0xd0000000-0xd00fffff pref]
pci 0000:00:07.0: PCI bridge to [bus 04-04]
pci 0000:00:07.0:   bridge window [io  disabled]
pci 0000:00:07.0:   bridge window [mem 0xdd000000-0xddffffff]
pci 0000:00:07.0:   bridge window [mem pref disabled]
pci 0000:00:08.0: PCI bridge to [bus 05-05]
pci 0000:00:08.0:   bridge window [io  disabled]
pci 0000:00:08.0:   bridge window [mem 0xdc000000-0xdcffffff]
pci 0000:00:08.0:   bridge window [mem pref disabled]
pci 0000:00:09.0: PCI bridge to [bus 06-06]
pci 0000:00:09.0:   bridge window [io  disabled]
pci 0000:00:09.0:   bridge window [mem 0xdb000000-0xdbffffff]
pci 0000:00:09.0:   bridge window [mem pref disabled]
pci 0000:00:0a.0: PCI bridge to [bus 07-07]
pci 0000:00:0a.0:   bridge window [io  disabled]
pci 0000:00:0a.0:   bridge window [mem 0xda000000-0xdaffffff]
pci 0000:00:0a.0:   bridge window [mem pref disabled]
pci 0000:00:0b.0: PCI bridge to [bus 08-08]
pci 0000:00:0b.0:   bridge window [io  disabled]
pci 0000:00:0b.0:   bridge window [mem 0xd9000000-0xd9ffffff]
pci 0000:00:0b.0:   bridge window [mem pref disabled]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: disabled boot interrupts on device [1166:0205]
pci 0000:00:08.0: Found enabled HT MSI Mapping
pci 0000:00:09.0: Found enabled HT MSI Mapping
pci 0000:00:0a.0: Found enabled HT MSI Mapping
pci 0000:00:0b.0: Found enabled HT MSI Mapping
Unpacking initramfs...
Freeing initrd memory: 9142k freed
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ f4000000 size 65536 KB
init_memory_mapping: 00000000f4000000-00000000f8000000
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
platform rtc_cmos: registered platform RTC device (no PNP device found)
audit: initializing netlink socket (disabled)
type=2000 audit(1265712261.588:1): initialized
rcu-torture:--- Start of test: nreaders=8 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 7915
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
registered taskstats version 1
Freeing unused kernel memory: 952k freed
Write protecting the kernel read-only data: 6144k
Freeing unused kernel memory: 632k freed
Freeing unused kernel memory: 244k freed
doing fast boot
SCSI subsystem initialized
Fusion MPT base driver 3.04.14
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SAS Host driver 3.04.14
mptsas 0000:03:04.0: can't find IRQ for PCI INT A; probably buggy MP table
mptbase: ioc0: Initiating bringup
ioc0: LSISAS1064 A3: Capabilities={Initiator}
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x1, page 0x2, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x1, page 0x1, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x0, page 0x2, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x9, page 0x0, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
scsi0 : ioc0: LSISAS1064 A3, FwRev=000a0f00h, Ports=1, MaxQ=511, IRQ=9
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x10, page 0x0, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x10, page 0x0, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x12, page 0x0, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x11, page 0x0, action 0
FATAL: Error inserting thermal (/lib/modules/2.6BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
.33-rc7-autotestudevd version 128 started
-next-20100209/kernel/drivers/acpi/thermal.ko): No such device
usbcore: registered new interface driver usbfs
FATAL: Error insusbcore: registered new interface driver hub
erting fan (/libusbcore: registered new device driver usb
/modules/2.6.33-ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
rc7-autotest-nexehci_hcd 0000:00:03.2: can't find IRQ for PCI INT A; probably buggy MP table
t-20100209/kerneehci_hcd 0000:00:03.2: EHCI Host Controller
l/drivers/acpi/fehci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 1
an.ko): No such device
FATAL: Module jbd not foehci_hcd 0000:00:03.2: irq 5, io mem 0xf3ffd000
und.
FATAL: Module ext3 not fouehci_hcd 0000:00:03.2: USB 2.0 started, EHCI 1.00
nd.
Creating deusb usb1: New USB device found, idVendor=1d6b, idProduct=0002
vice nodes with usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
udev
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.33-rc7-autotest-next-20100209 ehci_hcd
usb usb1: SerialNumber: 0000:00:03.2
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:03.0: can't find IRQ for PCI INT A; probably buggy MP table
ohci_hcd 0000:00:03.0: OHCI Host Controller
ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:03.0: irq 5, io mem 0xf3fff000
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.33-rc7-autotest-next-20100209 ohci_hcd
usb usb2: SerialNumber: 0000:00:03.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ohci_hcd 0000:00:03.1: can't find IRQ for PCI INT A; probably buggy MP table
ohci_hcd 0000:00:03.1: OHCI Host Controller
ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:03.1: irq 5, io mem 0xf3ffe000
usb 1-4: new high speed USB device using ehci_hcd and address 2
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.33-rc7-autotest-next-20100209 ohci_hcd
usb usb3: SerialNumber: 0000:00:03.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
blogd: Warning: the ioctl TIOCGDEV is not known by the kernel
Boot logging started on /dev/ttyS1(/dev/console) at Tue Feb  9 10:51:49 2010
Trying manual resume from /dev/disk/by-id/scsi-3500000e015c26a80-part2
resume device /dev/disk/by-id/scsi-3500000e015c26a80-part2 not found (ignoring)
Trying manual resume from /dev/disk/by-id/scsi-3500000e015c26a80-part2
resume device /dev/disk/by-id/scsi-3500000e015c26a80-part2 not found (ignoring)
Waiting for device /dev/disk/by-id/scsi-3500000e015c26a80-part1 to appear: ....ehci_hcd 0000:00:03.2: Unlink after no-IRQ?  Controller is probably using the wrong IRQ.
...........usb 1-4: device not accepting address 2, error -110
usb 1-4: new high speed USB device using ehci_hcd and address 3
.............mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
..Could not find /dev/disk/by-id/scsi-3500000e015c26a80-part1.
Want me to fall back to /dev/disk/by-id/scsi-3500000e015c26a80-part1? (Y/n) 
usb 1-4: device not accepting address 3, error -110
usb 1-4: new high speed USB device using ehci_hcd and address 4
usb 1-4: device not accepting address 4, error -110
usb 1-4: new high speed USB device using ehci_hcd and address 5
usb 1-4: device not accepting address 5, error -110
hub 1-0:1.0: unable to enumerate USB device on port 4
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x12, page 0x0, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x1, page 0x2, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x10, page 0x0, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x11, page 0x0, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x12, page 0x0, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x1, page 0x2, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x10, page 0x0, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x11, page 0x0, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x12, page 0x0, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x1, page 0x2, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery


--------------040404030109070706020602--
