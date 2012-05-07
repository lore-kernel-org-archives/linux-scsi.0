From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43213] New: sata_svw failed to kdump with pending IOs
Date: Mon, 7 May 2012 04:05:02 GMT
Message-ID: <bug-43213-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:39834 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2EGEFD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2012 00:05:03 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q47452rf028361
	for <linux-scsi@vger.kernel.org>; Mon, 7 May 2012 04:05:02 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=43213

           Summary: sata_svw failed to kdump with pending IOs
           Product: SCSI Drivers
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: caiqian@redhat.com
        Regression: No


After running IO-intensive workloads in the normal kernel, manually
triggering kdump ends up hanging below. Kernel version - 3.2.7.

# stress --cpu 8 --io 4 --vm 2 --hdd 1
# echo c >/proc/sysrq-trigger

[ 1294.535701] SysRq : Trigger a crash
[ 1294.536016] BUG: unable to handle kernel NULL pointer dereference at        
  \
(null) [ 1294.536016] IP: [] sysrq_handle_crash+0x16/0x20
[ 1294.536016] PGD 23741d067 PUD 23741c067 PMD 0 
[ 1294.536016] Oops: 0002 [#1] SMP 
[ 1294.536016] CPU 0 
[ 1294.536016] Modules linked in: lockd amd64_edac_mod joydev edac_core tg3
e100 mii \
serio_raw edac_mce_amd k8temp shpchp i2c_piix4 sunrpc ata_generic pata_acpi
sata_svw \
pata_serverworks radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last
unloaded: \
scsi_wait_scan] [ 1294.536016] 
[ 1294.536016] Pid: 1115, comm: bash Not tainted 3.2.7-1.fc16.x86_64 #1 empty \
empty/Tyan Transport GT24-B3992 [ 1294.536016] RIP: 0010:[]  [] \
sysrq_handle_crash+0x16/0x20 [ 1294.536016] RSP: 0018:ffff88023792de38  EFLAGS:
\
00010092 [ 1294.536016] RAX: 0000000000000010 RBX: 0000000000000063 RCX: \
0000000000002721 [ 1294.536016] RDX: 0000000000000000 RSI: 0000000000000046
RDI: \
0000000000000063 [ 1294.536016] RBP: ffff88023792de38 R08: 0000000000000000
R09: \
0000000000000100 [ 1294.536016] R10: 0000000000000000 R11: 0000000000000001
R12: \
ffffffff81a75220 [ 1294.536016] R13: 0000000000000286 R14: 0000000000000007
R15: \
0000000000000000 [ 1294.536016] FS:  00007f4afd42c700(0000)
GS:ffff88013bc00000(0000) \
knlGS:0000000000000000 [ 1294.536016] CS:  0010 DS: 0000 ES: 0000 CR0: \
0000000080050033 [ 1294.536016] CR2: 0000000000000000 CR3: 000000023740b000
CR4: \
00000000000006f0 [ 1294.536016] DR0: 0000000000000000 DR1: 0000000000000000
DR2: \
0000000000000000 [ 1294.536016] DR3: 0000000000000000 DR6: 00000000ffff0ff0
DR7: \
0000000000000400 [ 1294.536016] Process bash (pid: 1115, threadinfo
ffff88023792c000, \
task ffff880234085c80) [ 1294.536016] Stack:
[ 1294.536016]  ffff88023792de78 ffffffff81363151 ffff8801372dc200
0000000000000002
[ 1294.536016]  ffff880236e09400 00007f4afd435000 0000000000000002
fffffffffffffffb
[ 1294.536016]  ffff88023792dea8 ffffffff8136320a 0000000000000002
00007f4afd435000
[ 1294.536016] Call Trace:
[ 1294.536016]  [] __handle_sysrq+0x121/0x190
[ 1294.536016]  [] write_sysrq_trigger+0x4a/0x50
[ 1294.536016]  [] proc_reg_write+0x7a/0xb0
[ 1294.536016]  [] vfs_write+0xb3/0x180
[ 1294.536016]  [] sys_write+0x4a/0x90
[ 1294.536016]  [] system_call_fastpath+0x16/0x1b
[ 1294.536016] Code: d0 88 81 23 39 da 81 5d c3 66 66 66 2e 0f 1f 84 00 00 00
00 00 \
55 48 89 e5 66 66 66 66 90 c7 05 31 62 95 00 01 00 00 00 0f ae f8  04 25 00 00
00 00 \
01 5d c3 55 48 89 e5 53 48 83 ec 08 66 66  [ 1294.536016] RIP  [] \
sysrq_handle_crash+0x16/0x20 [ 1294.536016]  RSP 
[ 1294.536016] CR2: 0000000000000000
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.7-1.fc16.x86_64 \
(mockbuild@x86-05.phx2.fedoraproject.org) (gcc version 4.6.2 20111027 (Red Hat
\
4.6.2-1) (GCC) ) #1 SMP Tue Feb 21 01:40:47 UTC 2012 [    0.000000] Command
line: \
BOOT_IMAGE=/vmlinuz-3.2.7-1.fc16.x86_64 root=/dev/mapper/vg_tyangt2413-lv_root
ro \
rd.lvm.lv=vg_tyangt2413/lv_swap rd.dm=0 rd.lvm.lv=vg_tyangt2413/lv_root
KEYTABLE=us \
SYSFONT=latarcyrheb-sun16 rd.md=0 rd.luks=0 LANG=en_US.UTF-8
console=ttyS0,115200 \
irqpoll nr_cpus=1 reset_devices cgroup_disable=memory mce=off  memmap=exactmap
\
memmap=573K@64K memmap=130479K@754237K elfcorehdr=884716K memmap=64K$0K \
memmap=3K$637K memmap=128K$896K memmap=56K#3145664K memmap=8K#3145720K \
memmap=12K$4173824K memmap=4K$4175872K [    0.000000] BIOS-provided physical
RAM map:
[    0.000000]  BIOS-e820: 0000000000000100 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfff0000 (usable)
[    0.000000]  BIOS-e820: 00000000bfff0000 - 00000000bfffe000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfffe000 - 00000000c0000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec03000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000240000000 (usable)
[    0.000000] last_pfn = 0x240000 max_arch_pfn = 0x400000000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] user-defined physical RAM map:
[    0.000000]  user: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  user: 0000000000010000 - 000000000009f400 (usable)
[    0.000000]  user: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  user: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  user: 000000002e08f400 - 0000000035ffb000 (usable)
[    0.000000]  user: 00000000bfff0000 - 00000000c0000000 (ACPI data)
[    0.000000]  user: 00000000fec00000 - 00000000fec03000 (reserved)
[    0.000000]  user: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000] DMI 2.3 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x35ffb max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] init_memory_mapping: 0000000000000000-0000000035ffb000
[    0.000000] RAMDISK: 35baf000 - 35fef000
[    0.000000] ACPI: RSDP 00000000000f7a10 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bfff0100 0004C (v01 A M I  OEMXSDT  09000622
MSFT \
00000097) [    0.000000] ACPI: FACP 00000000bfff0290 000F4 (v03 A M I  OEMFACP 
\
09000622 MSFT 00000097) [    0.000000] ACPI: DSDT 00000000bfff0410 037E2 (v01 
0AAAA \
0AAAA000 00000000 INTL 02002026) [    0.000000] ACPI: FACS 00000000bfffe000
00040
[    0.000000] ACPI: APIC 00000000bfff0390 00080 (v01 A M I  OEMAPIC  09000622
MSFT \
00000097) [    0.000000] ACPI: OEMB 00000000bfffe040 00056 (v01 A M I  AMI_OEM 
\
09000622 MSFT 00000097) [    0.000000] ACPI: SRAT 00000000bfff3c00 00110 (v01
AMD    \
HAMMER   00000001 AMD  00000001) [    0.000000] ACPI: SSDT 00000000bfff3d10
004F0 \
(v01 A M I  POWERNOW 00000001 AMD  00000001) [    0.000000] SRAT: PXM 0 -> APIC
0x00 \
-> Node 0 [    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x02 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x03 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] SRAT: Node 0 PXM 0 100000-c0000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-140000000
[    0.000000] SRAT: Node 1 PXM 1 140000000-240000000
[    0.000000] NUMA: Node 0 [0,a0000) + [100000,35ffb000) -> [0,35ffb000)
[    0.000000] Initmem setup node 0 0000000000000000-0000000035ffb000
[    0.000000]   NODE_DATA [0000000035b9b000 - 0000000035baefff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x0002e090 -> 0x00035ffb
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x508
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1
\
ignored. [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 2/0x2
\
ignored. [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 3/0x3
\
ignored. [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-15
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfec01000] gsi_base[16])
[    0.000000] IOAPIC[1]: apic_id 5, version 17, address 0xfec01000, GSI 16-31
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec02000] gsi_base[32])
[    0.000000] IOAPIC[2]: apic_id 6, version 17, address 0xfec02000, GSI 32-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] 4 Processors exceeds NR_CPUS limit of 1
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009f000 -
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 -
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 -
0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000000100000 -
000000002e090000
[    0.000000] Allocating PCI resources starting at 35ffb000 (gap:
35ffb000:89ff5000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:1 \
nr_node_ids:2 [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880035800000
s83072 \
r8192 d23424 u2097152 [    0.000000] Built 1 zonelists in Node order, mobility
\
grouping on.  Total pages: 29300 [    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.2.7-1.fc16.x86_64 \
root=/dev/mapper/vg_tyangt2413-lv_root ro rd.lvm.lv=vg_tyangt2413/lv_swap
rd.dm=0 \
rd.lvm.lv=vg_tyangt2413/lv_root KEYTABLE=us SYSFONT=latarcyrheb-sun16 rd.md=0 \
rd.luks=0 LANG=en_US.UTF-8 console=ttyS0,115200 irqpoll nr_cpus=1 reset_devices
\
cgroup_disable=memory mce=off  memmap=exactmap memmap=573K@64K
memmap=130479K@754237K \
elfcorehdr=884716K memmap=64K$0K memmap=3K$637K memmap=128K$896K
memmap=56K#3145664K \
memmap=8K#3145720K memmap=12K$4173824K memmap=4K$4175872K [    0.000000]
Misrouted \
IRQ fixup and polling support enabled [    0.000000] This may significantly
impact \
system performance [    0.000000] Disabling memory control group subsystem
[    0.000000] PID hash table entries: 512 (order: 0, 4096 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ c0000000 size 128 MB
[    0.000000] Node 1: aperture @ c0000000 size 128 MB
[    0.000000] Memory: 106200k/884716k available (6075k kernel code, 753668k
absent, \
24848k reserved, 5014k data, 1596k init) [    0.000000] SLUB: Genslabs=15, \
HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=2 [    0.000000]
Hierarchical RCU \
implementation. [    0.000000]         RCU dyntick-idle grace-period
acceleration is \
enabled. [    0.000000] NR_IRQS:16640 nr_irqs:256 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Spurious LAPIC timer interrupt on cpu 0
[    0.000000] do_IRQ: 0.89 No irq handler for vector (irq -1)
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2592.989 MHz processor.
[    0.002002] Calibrating delay loop (skipped), value calculated using timer \
frequency.. 5185.97 BogoMIPS (lpj=2592989) [    0.004005] pid_max: default:
32768 \
minimum: 301 [    0.005025] Security Framework initialized
[    0.006011] SELinux:  Initializing.
[    0.007077] Dentry cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.008080] Inode-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.009044] Mount-cache hash table entries: 256
[    0.011008] Initializing cgroup subsys cpuacct
[    0.012007] Initializing cgroup subsys memory
[    0.013016] Initializing cgroup subsys devices
[    0.014004] Initializing cgroup subsys freezer
[    0.015004] Initializing cgroup subsys net_cls
[    0.016004] Initializing cgroup subsys blkio
[    0.017008] Initializing cgroup subsys perf_event
[    0.018044] CPU: Physical Processor ID: 0
[    0.019004] CPU: Processor Core ID: 0
[    0.020004] using AMD E400 aware idle routine
[    0.021030] SMP alternatives: switching to UP code
[    0.027727] Freeing SMP alternatives: 24k freed
[    0.028012] ACPI: Core revision 20110623
[    0.031337] ftrace: allocating 22803 entries in 90 pages
[    0.033969] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.044041] CPU0: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
[    0.047996] Performance Events: Broken BIOS detected, complain to your
hardware \
vendor. [    0.048997] [Firmware Bug]: the BIOS has corrupted hw-PMU resources
(MSR \
c0010000 is 530076) [    0.049997] AMD PMU driver.
[    0.050998] ... version:                0
[    0.051996] ... bit width:              48
[    0.052996] ... generic registers:      4
[    0.053996] ... value mask:             0000ffffffffffff
[    0.054996] ... max period:             00007fffffffffff
[    0.055996] ... fixed-purpose events:   0
[    0.056996] ... event mask:             000000000000000f
[    0.058181] NMI watchdog enabled, takes one hw-pmu counter.
[    0.059021] Brought up 1 CPUs
[    0.059997] Total of 1 processors activated (5185.97 BogoMIPS).
[    0.062613] devtmpfs: initialized
[    0.064780] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.065031] RTC time:  0:46:05, date: 02/27/12
[    0.066026] NET: Registered protocol family 16
[    0.067075] TOM: 00000000c0000000 aka 3072M
[    0.068002] TOM2: 0000000240000000 aka 9216M
[    0.069081] ACPI: bus type pci registered
[    0.070051] PCI: Using configuration type 1 for base access
[    0.072696] bio: create slab  at 0
[    0.073056] ACPI: Added _OSI(Module Device)
[    0.073995] ACPI: Added _OSI(Processor Device)
[    0.075000] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.075995] ACPI: Added _OSI(Processor Aggregator Device)
[    0.078776] ACPI: Executed 1 blocks of module-level executable AML code
[    0.081662] ACPI Warning: Incorrect checksum in table [OEMB] - 0x50, should
be \
0x4D (20110623/tbutils-314) [    0.084128] ACPI: Interpreter enabled
[    0.084996] ACPI: (supports S0 S1 S4 S5)
[    0.086995] ACPI: Using IOAPIC for interrupt routing
[    0.093230] ACPI: No dock devices found.
[    0.093994] HEST: Table not found.
[    0.094995] PCI: Ignoring host bridge windows from ACPI; if necessary, use \
"pci=use_crs" and report a bug [    0.096050] ACPI: PCI Root Bridge [PCI0]
(domain \
0000 [bus 00-ff]) [    0.097171] pci 0000:00:01.0: Enabling HT MSI Mapping
[    0.099898] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.100043] pci 0000:01:0d.0: PCI bridge to [bus 02-02]
[    0.101035] pci 0000:00:06.0: PCI bridge to [bus 03-03]
[    0.102161] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    0.103013] pci 0000:00:08.0: PCI bridge to [bus 05-05]
[    0.104008] pci 0000:00:09.0: PCI bridge to [bus 06-06]
[    0.105007] pci 0000:00:0a.0: PCI bridge to [bus 07-07]
[    0.106007] pci 0000:00:0b.0: PCI bridge to [bus 08-08]
[    0.107249]  pci0000:00: Unable to request _OSC control (_OSC support mask:
0x1e)
[    0.113660] ACPI: PCI Interrupt Link [LN00] (IRQs 3 4 5 7 9 11 12 14 15) *0,
\
disabled. [    0.117220] ACPI: PCI Interrupt Link [LN01] (IRQs 1 3 4 5 6 7 9 11
12 14 \
15) *0, disabled. [    0.122217] ACPI: PCI Interrupt Link [LN02] (IRQs 1 3 4 5
6 7 9 \
11 12 14 15) *0, disabled. [    0.127999] ACPI: PCI Interrupt Link [LN03] (IRQs
1 3 4 \
5 6 7 9 11 12 14 15) *0, disabled. [    0.133220] ACPI: PCI Interrupt Link
[LN04] \
(IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled. [    0.138021] ACPI: PCI
Interrupt \
Link [LN05] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled. [    0.143219] ACPI:
PCI \
Interrupt Link [LN06] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled. [   
0.148210] \
ACPI: PCI Interrupt Link [LN07] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    \
0.153217] ACPI: PCI Interrupt Link [LN08] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0,
\
disabled. [    0.158211] ACPI: PCI Interrupt Link [LN09] (IRQs 1 3 4 5 6 7 9 11
12 14 \
15) *0, disabled. [    0.164005] ACPI: PCI Interrupt Link [LN10] (IRQs 1 3 4 5
6 7 9 \
11 12 14 15) *0, disabled. [    0.169213] ACPI: PCI Interrupt Link [LN11] (IRQs
1 3 4 \
5 6 7 9 11 12 14 15) *0, disabled. [    0.174017] ACPI: PCI Interrupt Link
[LN12] \
(IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled. [    0.179214] ACPI: PCI
Interrupt \
Link [LN13] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled. [    0.184213] ACPI:
PCI \
Interrupt Link [LN14] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled. [   
0.189213] \
ACPI: PCI Interrupt Link [LN15] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    \
0.194212] ACPI: PCI Interrupt Link [LN16] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0,
\
disabled. [    0.199014] ACPI: PCI Interrupt Link [LN17] (IRQs 1 3 4 5 6 7 9 11
12 14 \
15) *0, disabled. [    0.204211] ACPI: PCI Interrupt Link [LN18] (IRQs 1 3 4 5
6 7 9 \
11 12 14 15) *0, disabled. [    0.209207] ACPI: PCI Interrupt Link [LN19] (IRQs
1 3 4 \
5 6 7 9 11 12 14 15) *0, disabled. [    0.214209] ACPI: PCI Interrupt Link
[LN20] \
(IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled. [    0.219201] ACPI: PCI
Interrupt \
Link [LN21] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled. [    0.224208] ACPI:
PCI \
Interrupt Link [LN22] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled. [   
0.229202] \
ACPI: PCI Interrupt Link [LN23] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    \
0.234009] ACPI: PCI Interrupt Link [LN24] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0,
\
disabled. [    0.239206] ACPI: PCI Interrupt Link [LN25] (IRQs 1 3 4 5 6 7 9 11
12 14 \
15) *0, disabled. [    0.244202] ACPI: PCI Interrupt Link [LN26] (IRQs 1 3 4 5
6 7 9 \
11 12 14 15) *0, disabled. [    0.249204] ACPI: PCI Interrupt Link [LN27] (IRQs
1 3 4 \
5 6 7 9 11 12 14 15) *0, disabled. [    0.254204] ACPI: PCI Interrupt Link
[LN28] \
(IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled. [    0.260005] ACPI: PCI
Interrupt \
Link [LN29] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled. [    0.265202] ACPI:
PCI \
Interrupt Link [LN30] (IRQs 1 3 4 5 6 7 9 11 12 14 15) *0, disabled. [   
0.270015] \
ACPI: PCI Interrupt Link [LNUS] (IRQs *10) [    0.272304] ACPI: PCI Interrupt
Link \
[LNSA] (IRQs *11) [    0.274364] vgaarb: device added: \
PCI:0000:00:0c.0,decodes=io+mem,owns=io+mem,locks=none [    0.274972] vgaarb:
loaded
[    0.275968] vgaarb: bridge control possible 0000:00:0c.0
[    0.277039] SCSI subsystem initialized
[    0.278081] usbcore: registered new interface driver usbfs
[    0.278983] usbcore: registered new interface driver hub
[    0.279991] usbcore: registered new device driver usb
[    0.281021] PCI: Using ACPI for IRQ routing
[    0.283040] NetLabel: Initializing
[    0.283967] NetLabel:  domain hash size = 128
[    0.284967] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.285978] NetLabel:  unlabeled traffic allowed by default
[    0.294202] pnp: PnP ACPI init
[    0.294983] ACPI: bus type pnp registered
[    0.297373] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.297967] system 00:07: [io  0x0c00-0x0c01] has been reserved
[    0.298966] system 00:07: [io  0x0cd6-0x0cd7] has been reserved
[    0.299965] system 00:07: [io  0x0cd4-0x0cd5] has been reserved
[    0.300965] system 00:07: [io  0x0cd8-0x0cdf] has been reserved
[    0.301965] system 00:07: [io  0x040b] has been reserved
[    0.302965] system 00:07: [io  0x04d6] has been reserved
[    0.303965] system 00:07: [io  0x0c06-0x0c07] has been reserved
[    0.304965] system 00:07: [io  0x0c14] has been reserved
[    0.305964] system 00:07: [io  0x0c49] has been reserved
[    0.306964] system 00:07: [io  0x0c4a] has been reserved
[    0.307964] system 00:07: [io  0x0c50-0x0c51] has been reserved
[    0.308964] system 00:07: [io  0x0c52] has been reserved
[    0.309964] system 00:07: [io  0x0c6c] has been reserved
[    0.310964] system 00:07: [io  0x0c6f] has been reserved
[    0.311964] system 00:07: [io  0x0500-0x057f] has been reserved
[    0.313103] system 00:08: [io  0x0580-0x058f] has been reserved
[    0.313964] system 00:08: [io  0x0590-0x0593] has been reserved
[    0.314963] system 00:08: [io  0x0700-0x0703] has been reserved
[    0.315963] system 00:08: [io  0x0ca0-0x0caf] has been reserved
[    0.316964] system 00:08: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.317963] system 00:08: [mem 0xfec01000-0xfec01fff] could not be reserved
[    0.318963] system 00:08: [mem 0xfec02000-0xfec02fff] could not be reserved
[    0.319962] system 00:08: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.320962] system 00:08: [mem 0xfff00000-0xffffffff] has been reserved
[    0.321962] system 00:08: [mem 0xff780000-0xffbfffff] has been reserved
[    0.322962] system 00:08: [mem 0xfebfe000-0xfebfefff] has been reserved
[    0.324175] system 00:09: [io  0x0600-0x061f] has been reserved
[    0.324962] system 00:09: [io  0x0520-0x053f] has been reserved
[    0.325961] system 00:09: [io  0x0540-0x054f] has been reserved
[    0.326961] system 00:09: [io  0x0640-0x065f] has been reserved
[    0.328024] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    0.329086] system 00:0b: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.329962] system 00:0b: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.330961] system 00:0b: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.332396] pnp: PnP ACPI: found 12 devices
[    0.332960] ACPI: ACPI bus type pnp unregistered
[    0.340418] Switching to clocksource acpi_pm
[    0.340976] pci 0000:04:04.0: no compatible bridge window for [mem \
0x86630000-0x8663ffff pref] [    0.349589] pci 0000:04:04.1: no compatible
bridge \
window for [mem 0x4d000000-0x4d00ffff pref] [    0.358231] pci 0000:01:0d.0:
PCI \
bridge to [bus 02-02] [    0.363463] pci 0000:00:01.0: PCI bridge to [bus
01-02]
[    0.368691] pci 0000:00:01.0:   bridge window [io  0xa000-0xbfff]
[    0.374784] pci 0000:00:01.0:   bridge window [mem 0xff400000-0xff4fffff]
[    0.381579] pci 0000:00:06.0: PCI bridge to [bus 03-03]
[    0.386818] pci 0000:04:04.0: BAR 6: assigned [mem 0xcfe00000-0xcfe0ffff
pref]
[    0.394040] pci 0000:04:04.1: BAR 6: assigned [mem 0xcfe10000-0xcfe1ffff
pref]
[    0.401266] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    0.406493] pci 0000:00:07.0:   bridge window [mem 0xff500000-0xff5fffff]
[    0.413277] pci 0000:00:07.0:   bridge window [mem 0xcfe00000-0xcfefffff
64bit \
pref] [    0.421019] pci 0000:00:08.0: PCI bridge to [bus 05-05]
[    0.426255] pci 0000:00:09.0: PCI bridge to [bus 06-06]
[    0.431489] pci 0000:00:0a.0: PCI bridge to [bus 07-07]
[    0.436723] pci 0000:00:0b.0: PCI bridge to [bus 08-08]
[    0.442042] NET: Registered protocol family 2
[    0.446438] IP route cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.453409] TCP established hash table entries: 4096 (order: 4, 65536 bytes)
[    0.460496] TCP bind hash table entries: 4096 (order: 4, 65536 bytes)
[    0.466974] TCP: Hash tables configured (established 4096 bind 4096)
[    0.473329] TCP reno registered
[    0.476476] UDP hash table entries: 128 (order: 0, 4096 bytes)
[    0.482313] UDP-Lite hash table entries: 128 (order: 0, 4096 bytes)
[    0.488621] NET: Registered protocol family 1
[    0.493056] pci 0000:00:02.0: disabled boot interrupts on device [1166:0205]
[    0.602048] pci 0000:00:04.0: Firmware left e100 interrupts enabled;
disabling
[    0.609282] pci 0000:00:08.0: Found enabled HT MSI Mapping
[    0.614771] pci 0000:00:09.0: Found enabled HT MSI Mapping
[    0.620265] pci 0000:00:0a.0: Found enabled HT MSI Mapping
[    0.625759] pci 0000:00:0b.0: Found enabled HT MSI Mapping
[    0.631328] Unpacking initramfs...
[    0.720906] Freeing initrd memory: 4352k freed
[    0.728462] Intel AES-NI instructions are not detected.
[    0.733849] audit: initializing netlink socket (disabled)
[    0.739268] type=2000 audit(1330303564.739:1): initialized
[    0.763039] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.771107] VFS: Disk quotas dquot_6.5.2
[    0.775077] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.782023] msgmni has been set to 215
[    0.786109] alg: No test for stdrng (krng)
[    0.790222] NET: Registered protocol family 38
[    0.794719] Block layer SCSI generic (bsg) driver version 0.4 loaded (major
253)
[    0.802138] io scheduler noop registered
[    0.806073] io scheduler deadline registered
[    0.810381] io scheduler cfq registered (default)
[    0.815519] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.821128] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.827749] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.834469] input: Power Button as \
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0 [    0.842648] ACPI:
Power \
Button [PWRB] [    0.846359] input: Power Button as \
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1 [    0.853755] ACPI: Power Button
\
[PWRF] [    0.857479] input: Sleep Button as \
/devices/LNXSYSTM:00/LNXSLPBN:00/input/input2 [    0.864875] ACPI: Sleep Button
\
[SLPF] [    0.870137] ERST: Table is not found!
[    0.873809] GHES: HEST is not enabled!
[    0.877628] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.904512] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.931131] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.957891] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.984095] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.989953] Non-volatile memory driver v1.3
[    0.994146] Linux agpgart interface v0.103
[    0.998916] loop: module loaded
[    1.002189] Fixed MDIO Bus: probed
[    1.005636] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.012219] ehci_hcd 0000:00:03.2: PCI INT A -> GSI 10 (level, low) -> IRQ
10
[    1.019369] ehci_hcd 0000:00:03.2: EHCI Host Controller
[    1.024647] ehci_hcd 0000:00:03.2: new USB bus registered, assigned bus
number 1
[    1.053035] ehci_hcd 0000:00:03.2: irq 10, io mem 0xff6ea000
[    1.064018] ehci_hcd 0000:00:03.2: USB 2.0 started, EHCI 1.00
[    1.069786] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.076573] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.083793] usb usb1: Product: EHCI Host Controller
[    1.088679] usb usb1: Manufacturer: Linux 3.2.7-1.fc16.x86_64 ehci_hcd
[    1.095206] usb usb1: SerialNumber: 0000:00:03.2
[    1.099915] hub 1-0:1.0: USB hub found
[    1.103678] hub 1-0:1.0: 4 ports detected
[    1.107785] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.114017] ohci_hcd 0000:00:03.0: PCI INT A -> GSI 10 (level, low) -> IRQ
10
[    1.121168] ohci_hcd 0000:00:03.0: OHCI Host Controller
[    1.126439] ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus
number 2
[    1.133846] ohci_hcd 0000:00:03.0: irq 10, io mem 0xff6e8000
[    1.194038] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    1.200827] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.208046] usb usb2: Product: OHCI Host Controller
[    1.212925] usb usb2: Manufacturer: Linux 3.2.7-1.fc16.x86_64 ohci_hcd
[    1.219450] usb usb2: SerialNumber: 0000:00:03.0
[    1.224154] hub 2-0:1.0: USB hub found
[    1.227915] hub 2-0:1.0: 2 ports detected
[    1.232019] ohci_hcd 0000:00:03.1: PCI INT A -> GSI 10 (level, low) -> IRQ
10
[    1.239167] ohci_hcd 0000:00:03.1: OHCI Host Controller
[    1.244427] ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus
number 3
[    1.251836] ohci_hcd 0000:00:03.1: irq 10, io mem 0xff6e9000
[    1.312038] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.318832] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.326061] usb usb3: Product: OHCI Host Controller
[    1.330949] usb usb3: Manufacturer: Linux 3.2.7-1.fc16.x86_64 ohci_hcd
[    1.337482] usb usb3: SerialNumber: 0000:00:03.1
[    1.342224] hub 3-0:1.0: USB hub found
[    1.345996] hub 3-0:1.0: 2 ports detected
[    1.350077] uhci_hcd: USB Universal Host Controller Interface driver
[    1.356494] usbcore: registered new interface driver usbserial
[    1.362337] USB Serial support registered for generic
[    1.654019] usb 2-1: new low-speed USB device number 2 using ohci_hcd
[    1.736019] Refined TSC clocksource calibration: 2593.500 MHz.
[    1.741854] Switching to clocksource tsc
[    1.848045] usb 2-1: New USB device found, idVendor=0624, idProduct=0307
[    1.854749] usb 2-1: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[    1.861879] usb 2-1: Product: Avocent DSRIQ-USB
[    1.866411] usb 2-1: Manufacturer: Avocent
[    1.880096] usbcore: registered new interface driver usbserial_generic
[    1.886634] usbserial: USB Serial Driver core
[    1.891040] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.900287] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.905249] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.910377] mousedev: PS/2 mouse device common for all mice
[    1.916129] rtc_cmos 00:02: RTC can wake from S4
[    1.920862] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.927007] rtc0: alarms up to one year, y3k, 114 bytes nvram
[    1.932818] device-mapper: uevent: version 1.0.3
[    1.937496] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: \
dm-devel@redhat.com [    1.946492] cpuidle: using governor ladder
[    1.950594] cpuidle: using governor menu
[    1.954774] EFI Variables Facility v0.08 2004-May-17
[    1.965307] input: Avocent Avocent DSRIQ-USB as \
/devices/pci0000:00/0000:00:03.0/usb2/2-1/2-1:1.0/input/input3 [    1.975769] \
generic-usb 0003:0624:0307.0001: input,hidraw0: USB HID v1.10 Keyboard [Avocent
\
Avocent DSRIQ-USB] on usb-0000:00:03.0-1/input0 [    1.995428] input: Avocent
Avocent \
DSRIQ-USB as /devices/pci0000:00/0000:00:03.0/usb2/2-1/2-1:1.1/input/input4 [  
 \
2.005502] generic-usb 0003:0624:0307.0002: input,hidraw1: USB HID v1.10 Mouse \
[Avocent Avocent DSRIQ-USB] on usb-0000:00:03.0-1/input1 [    2.017762]
usbcore: \
registered new interface driver usbhid [    2.023333] usbhid: USB HID core
driver
[    2.027223] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.032547] TCP cubic registered
[    2.035775] Initializing XFRM netlink socket
[    2.040152] NET: Registered protocol family 10
[    2.044754] Mobile IPv6
[    2.047209] NET: Registered protocol family 17
[    2.051669] Registering the dns_resolver key type
[    2.056473] registered taskstats version 1
[    2.060804]   Magic number: 0:237:760
[    2.064555] rtc_cmos 00:02: setting system clock to 2012-02-27 00:46:08 UTC
\
(1330303568) [    2.072638] powernow-k8: Found 1 Dual-Core AMD Opteron(tm)
Processor \
8218 (1 cpu cores) (version 2.20.00) [    2.082232] powernow-k8: fid 0x12 (2600
MHz), \
vid 0xa [    2.087282] powernow-k8: fid 0x10 (2400 MHz), vid 0xc
[    2.092334] powernow-k8: fid 0xe (2200 MHz), vid 0xe
[    2.097301] powernow-k8: fid 0xc (2000 MHz), vid 0x10
[    2.102354] powernow-k8: fid 0xa (1800 MHz), vid 0x10
[    2.107405] powernow-k8: fid 0x2 (1000 MHz), vid 0x12
[    2.112777] Initializing network drop monitor service
[    2.120657] Freeing unused kernel memory: 1596k freed
[    2.126415] Write protecting the kernel read-only data: 10240k
[    2.132530] Freeing unused kernel memory: 52k freed
[    2.142301] Freeing unused kernel memory: 1552k freed
Mounting proc filesystem
Mounting sysfs filesystem
Creating /dev
Creating initial device nodes
Free memory/T[    2.157544] EDAC MC: Ver: 2.1.0
otal memory (free %): 90620 / 11[    2.163803] tg3.c:v3.121 (November 2, 2011)
3776 ( 79.6477 )[    2.168548] tg3 0000:04:04.0: PCI INT A -> GSI 26 (level,
low) -> \
IRQ 26

Loading joydev.ko module
Loading edac_core.ko module
Loading tg3.ko module
[    2.297926] tg3 0000:04:04.0: eth0: Tigon3 [partno(BCM95780) rev 8003] \
(PCIX:133MHz:64-bit) MAC address 00:e0:81:46:70:52 [    2.308887] tg3
0000:04:04.0: \
eth0: attached PHY is 5780 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    \
2.318711] tg3 0000:04:04.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0]
TSOcap[1] \
[    2.326622] tg3 0000:04:04.0: eth0: dma_rwctrl[76144000] dma_mask[40-bit] [ 
  \
2.333614] tg3 0000:04:04.1: PCI INT B -> GSI 27 (level, low) -> IRQ 27 [   
2.362600] \
tg3 0000:04:04.1: eth1: Tigon3 [partno(BCM95780) rev 8003] (PCIX:133MHz:64-bit)
MAC \
address 00:e0:81:46:70:53 [    2.373563] tg3 0000:04:04.1: eth1: attached PHY
is 5780 \
(10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0]) [    2.383381] tg3
0000:04:04.1: \
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1] [    2.391293] tg3 \
0000:04:04.1: eth1: dma_rwctrl[76144000] dma_mask[40-bit] Loading mii.ko module
Loading s[    2.400313] MCE: In-kernel MCE decoding enabled.
erio_raw.ko modu[    2.406532] k8temp 0000:00:18.3: Temperature readouts might
be \
wrong - check erratum #141 le
Loading edac[    2.415643] k8temp 0000:00:19.3: Temperature readouts might be
wrong - \
check erratum #141 _mce_amd.ko module
Loading k8te[    2.426335] shpchp: Standard Hot Plug PCI Controller Driver
version: \
0.4 mp.ko module
Loading shpchp.ko module
Loading sunrpc.ko module[    2.438896] RPC: Registered named UNIX socket
transport \
module.

[    2.445870] RPC: Registered udp transport module.
[    2.450720] RPC: Registered tcp transport module.
[    2.455425] RPC: Registered tcp NFSv4.1 backchannel transport module.
Loading ata_generic.ko module
L[    2.464264] sata_svw 0000:01:0e.0: PCI INT A -> GSI 11 (level, low) -> IRQ
11
oading pata_acpi.ko module
Loading sata_svw.ko [    2.474714] scsi0 : sata_svw
module
[    2.479412] scsi1 : sata_svw
[    2.482926] scsi2 : sata_svw
[    2.486253] scsi3 : sata_svw
[    2.489403] ata1: SATA max UDMA/133 mmio m8192@0xff4fe000 port 0xff4fe000
irq 11
[    2.496806] ata2: SATA max UDMA/133 mmio m8192@0xff4fe000 port 0xff4fe100
irq 11
[    2.504202] ata3: SATA max UDMA/133 mmio m8192@0xff4fe000 port 0xff4fe200
irq 11
[    2.511596] ata4: SATA max UDMA/133 mmio m8192@0xff4fe000 port 0xff4fe300
irq 11
[    2.706499] Marking TSC unstable due to cpufreq changes
[    2.708562] Switching to clocksource acpi_pm
[    2.824051] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
