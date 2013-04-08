From: Baruch Even <baruch@ev-en.org>
Subject: Re: mpt2sas + raid10 goes boom
Date: Mon, 8 Apr 2013 23:15:37 +0300
Message-ID: <CAC9+anJ4pdJ7EVwDQY-QpVOVr-L3xf5STuVaZ=i9bkFz5KuO3g@mail.gmail.com>
References: <5162C25C.3090707@matthiasprager.de> <5162F827.7010603@matthiasprager.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:45335 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935904Ab3DHUQB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Apr 2013 16:16:01 -0400
Received: by mail-ea0-f177.google.com with SMTP id q14so2444974eaj.36
        for <linux-scsi@vger.kernel.org>; Mon, 08 Apr 2013 13:15:58 -0700 (PDT)
In-Reply-To: <5162F827.7010603@matthiasprager.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Prager <linux@matthiasprager.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-ext4@vger.kernel.org, Chris Dunlop <chris@onthe.net.au>

There may be two different issues or they may be related, the log_info
code seems to indicate a software issue more than a hardware one, the
crc counter is definitely a hardware issue but if it grows at one per
hour it's hardly an issue if it grows at 100 a second you have an
issue, in between, it depends. Even these numbers are just out of hot
air.

Since you own the hardware of lsi you should be able to check with LSI
support staff about the log info error code that you received, unless
it's a built-in chip on the motherboard. I had ok experience with
sending a request through their website and they require the card
serial number to answer.


Baruch

On Mon, Apr 8, 2013 at 8:02 PM, Matthias Prager <linux@matthiasprager.de> wrote:
> Hello everyone,
>
> 24h after rebooting with the 3.8.6 kernel I'm again getting:
> 'mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)'
>
> Looking at the extended smart output (I only used -a before,
> now -x), there seem to have been CRC errors between the
> controller and the drive. Maybe it really is a hardware issue?
> Then again, the data which was transferred during the time
> of the error messages checks out (I dropped the caches before I
> reread it).
>
> Well in any case I don't find the error messages all too
> helpful ;-) (maybe I just don't know how to read them).
>
> ---
> Matthias
>
> Following: dmesg und smart output
>
> ----------------------------------------------------------------------
> dmesg output (interesting lines start at timecode 86758)
> current uptime is about 92880s
> ----------------------------------------------------------------------
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.8.6-gentoo (root@pserver) (gcc version 4.6.3 (Gentoo 4.6.3 p1.11, pie-0.5.2) ) #2 SMP Sun Apr 7 16:57:19 CEST 2013
> [    0.000000] Command line: root=UUID=3e4f1b6a-63ab-4023-8bff-d57738361e22 scsi_mod.scan=sync scandelay=5 consoleblank=0
> [    0.000000] Disabled fast string operations
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000007f7ff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000007f800-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000ca000-0x00000000000cbfff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007feeffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007fef0000-0x000000007fefefff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x000000007feff000-0x000000007fefffff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x000000007ff00000-0x000000007fffffff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffe0000-0x00000000ffffffff] reserved
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 06/22/2012
> [    0.000000] Hypervisor detected: VMware
> [    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x80000 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-7FFFF write-back
> [    0.000000]   80000-BFFFF uncachable
> [    0.000000]   C0000-CBFFF write-protect
> [    0.000000]   CC000-EFFFF uncachable
> [    0.000000]   F0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0000000000 mask FF80000000 write-back
> [    0.000000]   1 disabled
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
> [    0.000000] found SMP MP-table at [mem 0x000f6bf0-0x000f6bff] mapped at [ffff8800000f6bf0]
> [    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
> [    0.000000] Base memory trampoline at [ffff880000079000] 79000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x7fffffff]
> [    0.000000]  [mem 0x00000000-0x7fffffff] page 2M
> [    0.000000] kernel direct mapping tables up to 0x7fffffff @ [mem 0x1fffd000-0x1fffffff]
> [    0.000000] ACPI: RSDP 00000000000f6b80 00024 (v02 PTLTD )
> [    0.000000] ACPI: XSDT 000000007fef009e 0005C (v01 INTEL  440BX    06040000 VMW  01324272)
> [    0.000000] ACPI: FACP 000000007fefee98 000F4 (v04 INTEL  440BX    06040000 PTL  000F4240)
> [    0.000000] ACPI: DSDT 000000007fef02fc 0EB9C (v01 PTLTD  Custom   06040000 MSFT 03000001)
> [    0.000000] ACPI: FACS 000000007fefffc0 00040
> [    0.000000] ACPI: BOOT 000000007fef02d4 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
> [    0.000000] ACPI: APIC 000000007fef0276 0005E (v01 PTLTD  ? APIC   06040000  LTP 00000000)
> [    0.000000] ACPI: MCFG 000000007fef023a 0003C (v01 PTLTD  $PCITBL$ 06040000  LTP 00000001)
> [    0.000000] ACPI: SRAT 000000007fef019a 000A0 (v02 VMWARE MEMPLUG  06040000 VMW  00000001)
> [    0.000000] ACPI: HPET 000000007fef0162 00038 (v01 VMWARE VMW HPET 06040000 VMW  00000001)
> [    0.000000] ACPI: WAET 000000007fef013a 00028 (v01 VMWARE VMW WAET 06040000 VMW  00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88007d600000-ffff88007f5fffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00010000-0x0007efff]
> [    0.000000]   node   0: [mem 0x00100000-0x7feeffff]
> [    0.000000]   node   0: [mem 0x7ff00000-0x7fffffff]
> [    0.000000] On node 0 totalpages: 524127
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 6 pages reserved
> [    0.000000]   DMA zone: 3881 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 8128 pages used for memmap
> [    0.000000]   DMA32 zone: 512048 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x1008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086af01 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x80000000-0xdfffffff] available for PCI devices
> [    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88007fc00000 s73600 r8192 d20608 u1048576
> [    0.000000] pcpu-alloc: s73600 r8192 d20608 u1048576 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 515929
> [    0.000000] Kernel command line: root=UUID=3e4f1b6a-63ab-4023-8bff-d57738361e22 scsi_mod.scan=sync scandelay=5 consoleblank=0
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.000000] __ex_table already sorted, skipping sort
> [    0.000000] xsave: enabled xstate_bv 0x3, cntxt size 0x240
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Memory: 2046020k/2097152k available (5602k kernel code, 644k absent, 50488k reserved, 2921k data, 5012k init)
> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]  CONFIG_RCU_FANOUT set to non-default value of 4
> [    0.000000]  RCU restricting CPUs from NR_CPUS=16 to nr_cpu_ids=2.
> [    0.000000] NR_IRQS:4352 nr_irqs:512 16
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] hpet clockevent registered
> [    0.000000] TSC freq read from hypervisor : 2660.000 MHz
> [    0.000000] tsc: Detected 2660.000 MHz processor
> [    0.000003] Calibrating delay loop (skipped) preset value.. 5320.00 BogoMIPS (lpj=26600000)
> [    0.000180] pid_max: default: 32768 minimum: 301
> [    0.000319] Mount-cache hash table entries: 256
> [    0.000683] Initializing cgroup subsys cpuacct
> [    0.000783] Initializing cgroup subsys devices
> [    0.000882] Initializing cgroup subsys freezer
> [    0.001017] Initializing cgroup subsys blkio
> [    0.001206] Disabled fast string operations
> [    0.001303] CPU: Physical Processor ID: 0
> [    0.001393] CPU: Processor Core ID: 0
> [    0.001501] mce: CPU supports 0 MCE banks
> [    0.001650] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
> Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
> tlb_flushall_shift: -1
> [    0.002193] Freeing SMP alternatives: 28k freed
> [    0.002337] ACPI: Core revision 20121018
> [    0.014176] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.114058] smpboot: CPU0: Intel(R) Core(TM)2 Quad CPU    Q9400  @ 2.66GHz (fam: 06, model: 17, stepping: 0a)
> [    0.228912] Performance Events: 4-deep LBR, Core2 events, core PMU driver.
> [    0.229185] perf_event_intel: CPUID marked event: 'cpu cycles' unavailable
> [    0.229312] perf_event_intel: CPUID marked event: 'instructions' unavailable
> [    0.229441] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
> [    0.229569] perf_event_intel: CPUID marked event: 'cache references' unavailable
> [    0.229703] perf_event_intel: CPUID marked event: 'cache misses' unavailable
> [    0.229832] perf_event_intel: CPUID marked event: 'branch instructions' unavailable
> [    0.229969] perf_event_intel: CPUID marked event: 'branch misses' unavailable
> [    0.230102] ... version:                1
> [    0.230192] ... bit width:              40
> [    0.230284] ... generic registers:      2
> [    0.230374] ... value mask:             000000ffffffffff
> [    0.230484] ... max period:             000000007fffffff
> [    0.230594] ... fixed-purpose events:   0
> [    0.230685] ... event mask:             0000000000000003
> [    0.231174] smpboot: Booting Node   0, Processors  #1 OK
> [    0.242511] Disabled fast string operations
> [    0.242547] mce: CPU supports 0 MCE banks
> [    0.242682] Skipped synchronization checks as TSC is reliable.
> [    0.243020] Brought up 2 CPUs
> [    0.243105] smpboot: Total of 2 processors activated (10640.00 BogoMIPS)
> [    0.244163] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
> [    0.244436] x86 PAT enabled: cpu 1, old 0x0, new 0x7010600070106
> [    0.245535] devtmpfs: initialized
> [    0.246178] xor: automatically using best checksumming function:
> [    0.343452]    generic_sse:  9604.800 MB/sec
> [    0.343588] atomic64 test passed for x86-64 platform with CX8 and with SSE
> [    0.343821] NET: Registered protocol family 16
> [    0.346012] ACPI: bus type pci registered
> [    0.346231] dca service started, version 1.12.1
> [    0.346640] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
> [    0.346832] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
> [    0.356083] PCI: Using configuration type 1 for base access
> [    0.378256] bio: create slab <bio-0> at 0
> [    0.542952] raid6: sse2x1    4647 MB/s
> [    0.712511] raid6: sse2x2    5014 MB/s
> [    0.882081] raid6: sse2x4    7820 MB/s
> [    0.882181] raid6: using algorithm sse2x4 (7820 MB/s)
> [    0.882289] raid6: using ssse3x2 recovery algorithm
> [    0.882556] ACPI: Added _OSI(Module Device)
> [    0.882652] ACPI: Added _OSI(Processor Device)
> [    0.882749] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.882849] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.885439] ACPI: EC: Look up EC in DSDT
> [    0.891982] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    0.982374] ACPI: Interpreter enabled
> [    0.982501] ACPI: (supports S0 S5)
> [    0.982709] ACPI: Using IOAPIC for interrupt routing
> [    1.378254] ACPI: No dock devices found.
> [    1.378363] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    1.379239] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    1.379362] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    1.380012] pci_root PNP0A03:00: Requesting ACPI _OSC control (0x1d)
> [    1.380445] pci_root PNP0A03:00: ACPI _OSC control (0x15) granted
> [    1.382011] PCI host bridge to bus 0000:00
> [    1.382109] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    1.382220] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    1.382350] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
> [    1.382479] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
> [    1.382608] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
> [    1.382736] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
> [    1.382864] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
> [    1.382992] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    1.383121] pci_bus 0000:00: root bus resource [io  0x0d00-0xfeff]
> [    1.383298] pci 0000:00:00.0: [8086:7190] type 00 class 0x060000
> [    1.383762] pci 0000:00:01.0: [8086:7191] type 01 class 0x060400
> [    1.384135] pci 0000:00:07.0: [8086:7110] type 00 class 0x060100
> [    1.384689] pci 0000:00:07.1: [8086:7111] type 00 class 0x01018a
> [    1.386455] pci 0000:00:07.1: reg 20: [io  0x10c0-0x10cf]
> [    1.387266] pci 0000:00:07.3: [8086:7113] type 00 class 0x068000
> [    1.389243] pci 0000:00:07.3: quirk: [io  0x1000-0x103f] claimed by PIIX4 ACPI
> [    1.389391] pci 0000:00:07.3: quirk: [io  0x1040-0x104f] claimed by PIIX4 SMB
> [    1.389731] pci 0000:00:07.7: [15ad:0740] type 00 class 0x088000
> [    1.390465] pci 0000:00:07.7: reg 10: [io  0x1080-0x10bf]
> [    1.391156] pci 0000:00:07.7: reg 14: [mem 0xd0000000-0xd0001fff 64bit]
> [    1.394286] pci 0000:00:0f.0: [15ad:0405] type 00 class 0x030000
> [    1.395777] pci 0000:00:0f.0: reg 10: [io  0x10d0-0x10df]
> [    1.397090] pci 0000:00:0f.0: reg 14: [mem 0xd8000000-0xdbffffff pref]
> [    1.398383] pci 0000:00:0f.0: reg 18: [mem 0xd0800000-0xd0ffffff]
> [    1.403604] pci 0000:00:0f.0: reg 30: [mem 0x00000000-0x00007fff pref]
> [    1.403902] pci 0000:00:11.0: [15ad:0790] type 01 class 0x060401
> [    1.404501] pci 0000:00:15.0: [15ad:07a0] type 01 class 0x060400
> [    1.405153] pci 0000:00:15.0: PME# supported from D0 D3hot D3cold
> [    1.405392] pci 0000:00:15.1: [15ad:07a0] type 01 class 0x060400
> [    1.406011] pci 0000:00:15.1: PME# supported from D0 D3hot D3cold
> [    1.406223] pci 0000:00:15.2: [15ad:07a0] type 01 class 0x060400
> [    1.406835] pci 0000:00:15.2: PME# supported from D0 D3hot D3cold
> [    1.407048] pci 0000:00:15.3: [15ad:07a0] type 01 class 0x060400
> [    1.407660] pci 0000:00:15.3: PME# supported from D0 D3hot D3cold
> [    1.407874] pci 0000:00:15.4: [15ad:07a0] type 01 class 0x060400
> [    1.408487] pci 0000:00:15.4: PME# supported from D0 D3hot D3cold
> [    1.408704] pci 0000:00:15.5: [15ad:07a0] type 01 class 0x060400
> [    1.409318] pci 0000:00:15.5: PME# supported from D0 D3hot D3cold
> [    1.409530] pci 0000:00:15.6: [15ad:07a0] type 01 class 0x060400
> [    1.410147] pci 0000:00:15.6: PME# supported from D0 D3hot D3cold
> [    1.410359] pci 0000:00:15.7: [15ad:07a0] type 01 class 0x060400
> [    1.410985] pci 0000:00:15.7: PME# supported from D0 D3hot D3cold
> [    1.411198] pci 0000:00:16.0: [15ad:07a0] type 01 class 0x060400
> [    1.411811] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> [    1.412024] pci 0000:00:16.1: [15ad:07a0] type 01 class 0x060400
> [    1.412636] pci 0000:00:16.1: PME# supported from D0 D3hot D3cold
> [    1.412849] pci 0000:00:16.2: [15ad:07a0] type 01 class 0x060400
> [    1.413464] pci 0000:00:16.2: PME# supported from D0 D3hot D3cold
> [    1.413677] pci 0000:00:16.3: [15ad:07a0] type 01 class 0x060400
> [    1.414290] pci 0000:00:16.3: PME# supported from D0 D3hot D3cold
> [    1.414503] pci 0000:00:16.4: [15ad:07a0] type 01 class 0x060400
> [    1.415116] pci 0000:00:16.4: PME# supported from D0 D3hot D3cold
> [    1.415331] pci 0000:00:16.5: [15ad:07a0] type 01 class 0x060400
> [    1.415943] pci 0000:00:16.5: PME# supported from D0 D3hot D3cold
> [    1.416161] pci 0000:00:16.6: [15ad:07a0] type 01 class 0x060400
> [    1.416773] pci 0000:00:16.6: PME# supported from D0 D3hot D3cold
> [    1.416986] pci 0000:00:16.7: [15ad:07a0] type 01 class 0x060400
> [    1.417597] pci 0000:00:16.7: PME# supported from D0 D3hot D3cold
> [    1.417809] pci 0000:00:17.0: [15ad:07a0] type 01 class 0x060400
> [    1.418422] pci 0000:00:17.0: PME# supported from D0 D3hot D3cold
> [    1.418635] pci 0000:00:17.1: [15ad:07a0] type 01 class 0x060400
> [    1.419248] pci 0000:00:17.1: PME# supported from D0 D3hot D3cold
> [    1.419461] pci 0000:00:17.2: [15ad:07a0] type 01 class 0x060400
> [    1.420074] pci 0000:00:17.2: PME# supported from D0 D3hot D3cold
> [    1.420287] pci 0000:00:17.3: [15ad:07a0] type 01 class 0x060400
> [    1.420924] pci 0000:00:17.3: PME# supported from D0 D3hot D3cold
> [    1.421137] pci 0000:00:17.4: [15ad:07a0] type 01 class 0x060400
> [    1.421748] pci 0000:00:17.4: PME# supported from D0 D3hot D3cold
> [    1.421963] pci 0000:00:17.5: [15ad:07a0] type 01 class 0x060400
> [    1.422573] pci 0000:00:17.5: PME# supported from D0 D3hot D3cold
> [    1.422786] pci 0000:00:17.6: [15ad:07a0] type 01 class 0x060400
> [    1.423400] pci 0000:00:17.6: PME# supported from D0 D3hot D3cold
> [    1.423612] pci 0000:00:17.7: [15ad:07a0] type 01 class 0x060400
> [    1.424225] pci 0000:00:17.7: PME# supported from D0 D3hot D3cold
> [    1.424438] pci 0000:00:18.0: [15ad:07a0] type 01 class 0x060400
> [    1.425049] pci 0000:00:18.0: PME# supported from D0 D3hot D3cold
> [    1.425262] pci 0000:00:18.1: [15ad:07a0] type 01 class 0x060400
> [    1.425875] pci 0000:00:18.1: PME# supported from D0 D3hot D3cold
> [    1.426091] pci 0000:00:18.2: [15ad:07a0] type 01 class 0x060400
> [    1.426701] pci 0000:00:18.2: PME# supported from D0 D3hot D3cold
> [    1.426914] pci 0000:00:18.3: [15ad:07a0] type 01 class 0x060400
> [    1.427524] pci 0000:00:18.3: PME# supported from D0 D3hot D3cold
> [    1.427736] pci 0000:00:18.4: [15ad:07a0] type 01 class 0x060400
> [    1.428348] pci 0000:00:18.4: PME# supported from D0 D3hot D3cold
> [    1.428561] pci 0000:00:18.5: [15ad:07a0] type 01 class 0x060400
> [    1.429173] pci 0000:00:18.5: PME# supported from D0 D3hot D3cold
> [    1.429385] pci 0000:00:18.6: [15ad:07a0] type 01 class 0x060400
> [    1.429999] pci 0000:00:18.6: PME# supported from D0 D3hot D3cold
> [    1.430211] pci 0000:00:18.7: [15ad:07a0] type 01 class 0x060400
> [    1.430833] pci 0000:00:18.7: PME# supported from D0 D3hot D3cold
> [    1.431353] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    1.431979] pci 0000:00:11.0: PCI bridge to [bus 02] (subtractive decode)
> [    1.432126] pci 0000:00:11.0:   bridge window [io  0x2000-0x3fff]
> [    1.432146] pci 0000:00:11.0:   bridge window [mem 0xd1900000-0xd23fffff]
> [    1.432184] pci 0000:00:11.0:   bridge window [mem 0xdc400000-0xdc9fffff 64bit pref]
> [    1.432186] pci 0000:00:11.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
> [    1.432188] pci 0000:00:11.0:   bridge window [mem 0x000cc000-0x000cffff] (subtractive decode)
> [    1.432189] pci 0000:00:11.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
> [    1.432191] pci 0000:00:11.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
> [    1.432193] pci 0000:00:11.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
> [    1.432195] pci 0000:00:11.0:   bridge window [mem 0x80000000-0xfebfffff] (subtractive decode)
> [    1.432196] pci 0000:00:11.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
> [    1.432198] pci 0000:00:11.0:   bridge window [io  0x0d00-0xfeff] (subtractive decode)
> [    1.432645] pci 0000:03:00.0: [15ad:07c0] type 00 class 0x010700
> [    1.434682] pci 0000:03:00.0: reg 10: [io  0x4008-0x400f]
> [    1.436783] pci 0000:03:00.0: reg 14: [mem 0xd2400000-0xd2407fff 64bit]
> [    1.444705] pci 0000:03:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
> [    1.445056] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
> [    1.445186] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> [    1.445450] pci 0000:00:15.0: PCI bridge to [bus 03]
> [    1.445574] pci 0000:00:15.0:   bridge window [io  0x4000-0x4fff]
> [    1.445595] pci 0000:00:15.0:   bridge window [mem 0xd2400000-0xd24fffff]
> [    1.445635] pci 0000:00:15.0:   bridge window [mem 0xd4400000-0xd44fffff 64bit pref]
> [    1.446138] pci 0000:04:00.0: [1000:0072] type 00 class 0x010700
> [    1.447517] pci 0000:04:00.0: reg 10: [io  0x8000-0x80ff]
> [    1.448866] pci 0000:04:00.0: reg 14: [mem 0xd2800000-0xd2803fff 64bit]
> [    1.450201] pci 0000:04:00.0: reg 1c: [mem 0xd2840000-0xd287ffff 64bit]
> [    1.453256] pci 0000:04:00.0: supports D1 D2
> [    1.453484] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> [    1.453741] pci 0000:00:15.1: PCI bridge to [bus 04]
> [    1.453866] pci 0000:00:15.1:   bridge window [io  0x8000-0x8fff]
> [    1.453887] pci 0000:00:15.1:   bridge window [mem 0xd2800000-0xd28fffff]
> [    1.453924] pci 0000:00:15.1:   bridge window [mem 0xd4800000-0xd48fffff 64bit pref]
> [    1.454335] pci 0000:00:15.2: PCI bridge to [bus 05]
> [    1.454459] pci 0000:00:15.2:   bridge window [io  0xc000-0xcfff]
> [    1.454479] pci 0000:00:15.2:   bridge window [mem 0xd2c00000-0xd2cfffff]
> [    1.454517] pci 0000:00:15.2:   bridge window [mem 0xdcb00000-0xdcbfffff 64bit pref]
> [    1.454907] pci 0000:00:15.3: PCI bridge to [bus 06]
> [    1.455048] pci 0000:00:15.3:   bridge window [mem 0xd3000000-0xd30fffff]
> [    1.455086] pci 0000:00:15.3:   bridge window [mem 0xdcd00000-0xdcdfffff 64bit pref]
> [    1.455475] pci 0000:00:15.4: PCI bridge to [bus 07]
> [    1.455616] pci 0000:00:15.4:   bridge window [mem 0xd3400000-0xd34fffff]
> [    1.455653] pci 0000:00:15.4:   bridge window [mem 0xdcf00000-0xdcffffff 64bit pref]
> [    1.456047] pci 0000:00:15.5: PCI bridge to [bus 08]
> [    1.456189] pci 0000:00:15.5:   bridge window [mem 0xd3800000-0xd38fffff]
> [    1.456226] pci 0000:00:15.5:   bridge window [mem 0xdd100000-0xdd1fffff 64bit pref]
> [    1.456615] pci 0000:00:15.6: PCI bridge to [bus 09]
> [    1.456755] pci 0000:00:15.6:   bridge window [mem 0xd3c00000-0xd3cfffff]
> [    1.456793] pci 0000:00:15.6:   bridge window [mem 0xdd300000-0xdd3fffff 64bit pref]
> [    1.457180] pci 0000:00:15.7: PCI bridge to [bus 0a]
> [    1.457321] pci 0000:00:15.7:   bridge window [mem 0xd4000000-0xd40fffff]
> [    1.457358] pci 0000:00:15.7:   bridge window [mem 0xdd500000-0xdd5fffff 64bit pref]
> [    1.457836] pci 0000:0b:00.0: [8086:10bd] type 00 class 0x020000
> [    1.458884] pci 0000:0b:00.0: reg 10: [mem 0xd2520000-0xd253ffff]
> [    1.459831] pci 0000:0b:00.0: reg 14: [mem 0xd2502000-0xd2502fff]
> [    1.460789] pci 0000:0b:00.0: reg 18: [io  0x5000-0x501f]
> [    1.465021] pci 0000:0b:00.0: PME# supported from D0 D3hot D3cold
> [    1.465142] pci 0000:00:16.0: PCI bridge to [bus 0b]
> [    1.465295] pci 0000:00:16.0:   bridge window [io  0x5000-0x5fff]
> [    1.465331] pci 0000:00:16.0:   bridge window [mem 0xd2500000-0xd25fffff]
> [    1.465370] pci 0000:00:16.0:   bridge window [mem 0xd4500000-0xd45fffff 64bit pref]
> [    1.465920] pci 0000:0c:00.0: [8086:2922] type 00 class 0x010601
> [    1.466709] pci 0000:0c:00.0: reg 10: [io  0x9038-0x903f]
> [    1.467358] pci 0000:0c:00.0: reg 14: [io  0x9030-0x9033]
> [    1.468007] pci 0000:0c:00.0: reg 18: [io  0x9028-0x902f]
> [    1.468653] pci 0000:0c:00.0: reg 1c: [io  0x9024-0x9027]
> [    1.469305] pci 0000:0c:00.0: reg 20: [io  0x9000-0x901f]
> [    1.469986] pci 0000:0c:00.0: reg 24: [mem 0xd2900000-0xd29007ff]
> [    1.471125] pci 0000:0c:00.0: PME# supported from D3hot
> [    1.471267] pci 0000:00:16.1: PCI bridge to [bus 0c]
> [    1.471411] pci 0000:00:16.1:   bridge window [io  0x9000-0x9fff]
> [    1.471431] pci 0000:00:16.1:   bridge window [mem 0xd2900000-0xd29fffff]
> [    1.471468] pci 0000:00:16.1:   bridge window [mem 0xd4900000-0xd49fffff 64bit pref]
> [    1.471870] pci 0000:00:16.2: PCI bridge to [bus 0d]
> [    1.471994] pci 0000:00:16.2:   bridge window [io  0xd000-0xdfff]
> [    1.472015] pci 0000:00:16.2:   bridge window [mem 0xd2d00000-0xd2dfffff]
> [    1.472052] pci 0000:00:16.2:   bridge window [mem 0xd4b00000-0xd4bfffff 64bit pref]
> [    1.472440] pci 0000:00:16.3: PCI bridge to [bus 0e]
> [    1.472581] pci 0000:00:16.3:   bridge window [mem 0xd3100000-0xd31fffff]
> [    1.472619] pci 0000:00:16.3:   bridge window [mem 0xd4d00000-0xd4dfffff 64bit pref]
> [    1.473012] pci 0000:00:16.4: PCI bridge to [bus 0f]
> [    1.473153] pci 0000:00:16.4:   bridge window [mem 0xd3500000-0xd35fffff]
> [    1.473191] pci 0000:00:16.4:   bridge window [mem 0xd4f00000-0xd4ffffff 64bit pref]
> [    1.473578] pci 0000:00:16.5: PCI bridge to [bus 10]
> [    1.473719] pci 0000:00:16.5:   bridge window [mem 0xd3900000-0xd39fffff]
> [    1.473757] pci 0000:00:16.5:   bridge window [mem 0xd5100000-0xd51fffff 64bit pref]
> [    1.474145] pci 0000:00:16.6: PCI bridge to [bus 11]
> [    1.474286] pci 0000:00:16.6:   bridge window [mem 0xd3d00000-0xd3dfffff]
> [    1.474324] pci 0000:00:16.6:   bridge window [mem 0xd5300000-0xd53fffff 64bit pref]
> [    1.474711] pci 0000:00:16.7: PCI bridge to [bus 12]
> [    1.474852] pci 0000:00:16.7:   bridge window [mem 0xd4100000-0xd41fffff]
> [    1.474890] pci 0000:00:16.7:   bridge window [mem 0xd5500000-0xd55fffff 64bit pref]
> [    1.475354] pci 0000:13:00.0: [15ad:07b0] type 00 class 0x020000
> [    1.476672] pci 0000:13:00.0: reg 10: [mem 0xd2604000-0xd2604fff]
> [    1.477935] pci 0000:13:00.0: reg 14: [mem 0xd2603000-0xd2603fff]
> [    1.479230] pci 0000:13:00.0: reg 18: [mem 0xd2600000-0xd2601fff]
> [    1.480530] pci 0000:13:00.0: reg 1c: [io  0x6000-0x600f]
> [    1.484338] pci 0000:13:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
> [    1.484688] pci 0000:13:00.0: supports D1 D2
> [    1.484690] pci 0000:13:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    1.484825] pci 0000:13:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> [    1.486264] pci 0000:00:17.0: PCI bridge to [bus 13]
> [    1.486391] pci 0000:00:17.0:   bridge window [io  0x6000-0x6fff]
> [    1.486411] pci 0000:00:17.0:   bridge window [mem 0xd2600000-0xd26fffff]
> [    1.486448] pci 0000:00:17.0:   bridge window [mem 0xd4600000-0xd46fffff 64bit pref]
> [    1.486860] pci 0000:00:17.1: PCI bridge to [bus 14]
> [    1.486986] pci 0000:00:17.1:   bridge window [io  0xa000-0xafff]
> [    1.487006] pci 0000:00:17.1:   bridge window [mem 0xd2a00000-0xd2afffff]
> [    1.487043] pci 0000:00:17.1:   bridge window [mem 0xdca00000-0xdcafffff 64bit pref]
> [    1.487431] pci 0000:00:17.2: PCI bridge to [bus 15]
> [    1.487556] pci 0000:00:17.2:   bridge window [io  0xe000-0xefff]
> [    1.487576] pci 0000:00:17.2:   bridge window [mem 0xd2e00000-0xd2efffff]
> [    1.487614] pci 0000:00:17.2:   bridge window [mem 0xdcc00000-0xdccfffff 64bit pref]
> [    1.488002] pci 0000:00:17.3: PCI bridge to [bus 16]
> [    1.488145] pci 0000:00:17.3:   bridge window [mem 0xd3200000-0xd32fffff]
> [    1.488182] pci 0000:00:17.3:   bridge window [mem 0xdce00000-0xdcefffff 64bit pref]
> [    1.488569] pci 0000:00:17.4: PCI bridge to [bus 17]
> [    1.488711] pci 0000:00:17.4:   bridge window [mem 0xd3600000-0xd36fffff]
> [    1.488749] pci 0000:00:17.4:   bridge window [mem 0xdd000000-0xdd0fffff 64bit pref]
> [    1.489139] pci 0000:00:17.5: PCI bridge to [bus 18]
> [    1.489282] pci 0000:00:17.5:   bridge window [mem 0xd3a00000-0xd3afffff]
> [    1.489319] pci 0000:00:17.5:   bridge window [mem 0xdd200000-0xdd2fffff 64bit pref]
> [    1.489707] pci 0000:00:17.6: PCI bridge to [bus 19]
> [    1.489851] pci 0000:00:17.6:   bridge window [mem 0xd3e00000-0xd3efffff]
> [    1.489888] pci 0000:00:17.6:   bridge window [mem 0xdd400000-0xdd4fffff 64bit pref]
> [    1.490276] pci 0000:00:17.7: PCI bridge to [bus 1a]
> [    1.490419] pci 0000:00:17.7:   bridge window [mem 0xd4200000-0xd42fffff]
> [    1.490456] pci 0000:00:17.7:   bridge window [mem 0xdd600000-0xdd6fffff 64bit pref]
> [    1.490948] pci 0000:1b:00.0: [1000:0072] type 00 class 0x010700
> [    1.492279] pci 0000:1b:00.0: reg 10: [io  0x7000-0x70ff]
> [    1.493613] pci 0000:1b:00.0: reg 14: [mem 0xd2700000-0xd2703fff 64bit]
> [    1.494940] pci 0000:1b:00.0: reg 1c: [mem 0xd2740000-0xd277ffff 64bit]
> [    1.497900] pci 0000:1b:00.0: supports D1 D2
> [    1.498141] pci 0000:1b:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> [    1.498398] pci 0000:00:18.0: PCI bridge to [bus 1b]
> [    1.498524] pci 0000:00:18.0:   bridge window [io  0x7000-0x7fff]
> [    1.498544] pci 0000:00:18.0:   bridge window [mem 0xd2700000-0xd27fffff]
> [    1.498581] pci 0000:00:18.0:   bridge window [mem 0xd4700000-0xd47fffff 64bit pref]
> [    1.498997] pci 0000:00:18.1: PCI bridge to [bus 1c]
> [    1.499123] pci 0000:00:18.1:   bridge window [io  0xb000-0xbfff]
> [    1.499143] pci 0000:00:18.1:   bridge window [mem 0xd2b00000-0xd2bfffff]
> [    1.499180] pci 0000:00:18.1:   bridge window [mem 0xd4a00000-0xd4afffff 64bit pref]
> [    1.499570] pci 0000:00:18.2: PCI bridge to [bus 1d]
> [    1.499695] pci 0000:00:18.2:   bridge window [io  0xf000-0xffff]
> [    1.499716] pci 0000:00:18.2:   bridge window [mem 0xd2f00000-0xd2ffffff]
> [    1.499754] pci 0000:00:18.2:   bridge window [mem 0xd4c00000-0xd4cfffff 64bit pref]
> [    1.500141] pci 0000:00:18.3: PCI bridge to [bus 1e]
> [    1.500284] pci 0000:00:18.3:   bridge window [mem 0xd3300000-0xd33fffff]
> [    1.500321] pci 0000:00:18.3:   bridge window [mem 0xd4e00000-0xd4efffff 64bit pref]
> [    1.500734] pci 0000:00:18.4: PCI bridge to [bus 1f]
> [    1.500878] pci 0000:00:18.4:   bridge window [mem 0xd3700000-0xd37fffff]
> [    1.500915] pci 0000:00:18.4:   bridge window [mem 0xd5000000-0xd50fffff 64bit pref]
> [    1.501303] pci 0000:00:18.5: PCI bridge to [bus 20]
> [    1.501446] pci 0000:00:18.5:   bridge window [mem 0xd3b00000-0xd3bfffff]
> [    1.501484] pci 0000:00:18.5:   bridge window [mem 0xd5200000-0xd52fffff 64bit pref]
> [    1.501873] pci 0000:00:18.6: PCI bridge to [bus 21]
> [    1.502016] pci 0000:00:18.6:   bridge window [mem 0xd3f00000-0xd3ffffff]
> [    1.502053] pci 0000:00:18.6:   bridge window [mem 0xd5400000-0xd54fffff 64bit pref]
> [    1.502439] pci 0000:00:18.7: PCI bridge to [bus 22]
> [    1.502583] pci 0000:00:18.7:   bridge window [mem 0xd4300000-0xd43fffff]
> [    1.502620] pci 0000:00:18.7:   bridge window [mem 0xd5600000-0xd56fffff 64bit pref]
> [    1.504428] pci_bus 0000:00: on NUMA node 0
> [    1.513360] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9 10 11 14 15)
> [    1.513953] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *7 9 10 11 14 15)
> [    1.514532] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 14 15)
> [    1.515108] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 14 15)
> [    1.515961] vgaarb: device added: PCI:0000:00:0f.0,decodes=io+mem,owns=io+mem,locks=none
> [    1.516120] vgaarb: loaded
> [    1.516202] vgaarb: bridge control possible 0000:00:0f.0
> [    1.516601] SCSI subsystem initialized
> [    1.516698] ACPI: bus type scsi registered
> [    1.517128] libata version 3.00 loaded.
> [    1.517135] ACPI: bus type usb registered
> [    1.517418] usbcore: registered new interface driver usbfs
> [    1.517607] usbcore: registered new interface driver hub
> [    1.517863] usbcore: registered new device driver usb
> [    1.518366] PCI: Using ACPI for IRQ routing
> [    1.578191] PCI: pci_cache_line_size set to 64 bytes
> [    1.578234] pci 0000:00:18.2: no compatible bridge window for [io  0xf000-0xffff]
> [    1.579300] e820: reserve RAM buffer [mem 0x0007f800-0x0007ffff]
> [    1.579303] e820: reserve RAM buffer [mem 0x7fef0000-0x7fffffff]
> [    1.580059] HPET: 16 timers in total, 0 timers will be used for per-cpu timer
> [    1.580282] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
> [    1.581015] hpet0: 16 comparators, 64-bit 14.318180 MHz counter
> [    1.584420] Switching to clocksource hpet
> [    1.584608] FS-Cache: Loaded
> [    1.594857] pnp: PnP ACPI init
> [    1.594970] ACPI: bus type pnp registered
> [    1.595483] system 00:00: [io  0x1000-0x103f] has been reserved
> [    1.595621] system 00:00: [io  0x1040-0x104f] has been reserved
> [    1.595740] system 00:00: [io  0x0cf0-0x0cf1] has been reserved
> [    1.595864] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    1.595883] pnp 00:01: [dma 4]
> [    1.595999] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
> [    1.596111] pnp 00:02: Plug and Play ACPI device, IDs PNP0001 (active)
> [    1.596231] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    1.596337] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
> [    1.596446] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 (active)
> [    1.596552] pnp 00:06: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    1.596890] system 00:07: [mem 0xfed00000-0xfed003ff] has been reserved
> [    1.597027] system 00:07: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
> [    1.604487] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
> [    1.609309] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
> [    1.612286] system 00:0a: [io  0x1060-0x107f] has been reserved
> [    1.612417] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
> [    1.612544] system 00:0a: [mem 0xd0200000-0xd03fffff] has been reserved
> [    1.612671] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    2.064134] pnp: PnP ACPI: found 11 devices
> [    2.064252] ACPI: ACPI bus type pnp unregistered
> [    2.069635] pci 0000:00:15.3: bridge window [io  0x1000-0x0fff] to [bus 06] add_size 1000
> [    2.069698] pci 0000:00:15.4: bridge window [io  0x1000-0x0fff] to [bus 07] add_size 1000
> [    2.069755] pci 0000:00:15.5: bridge window [io  0x1000-0x0fff] to [bus 08] add_size 1000
> [    2.069811] pci 0000:00:15.6: bridge window [io  0x1000-0x0fff] to [bus 09] add_size 1000
> [    2.069867] pci 0000:00:15.7: bridge window [io  0x1000-0x0fff] to [bus 0a] add_size 1000
> [    2.070079] pci 0000:00:16.3: bridge window [io  0x1000-0x0fff] to [bus 0e] add_size 1000
> [    2.070134] pci 0000:00:16.4: bridge window [io  0x1000-0x0fff] to [bus 0f] add_size 1000
> [    2.070195] pci 0000:00:16.5: bridge window [io  0x1000-0x0fff] to [bus 10] add_size 1000
> [    2.070251] pci 0000:00:16.6: bridge window [io  0x1000-0x0fff] to [bus 11] add_size 1000
> [    2.070324] pci 0000:00:16.7: bridge window [io  0x1000-0x0fff] to [bus 12] add_size 1000
> [    2.070538] pci 0000:00:17.3: bridge window [io  0x1000-0x0fff] to [bus 16] add_size 1000
> [    2.070593] pci 0000:00:17.4: bridge window [io  0x1000-0x0fff] to [bus 17] add_size 1000
> [    2.070648] pci 0000:00:17.5: bridge window [io  0x1000-0x0fff] to [bus 18] add_size 1000
> [    2.070704] pci 0000:00:17.6: bridge window [io  0x1000-0x0fff] to [bus 19] add_size 1000
> [    2.070759] pci 0000:00:17.7: bridge window [io  0x1000-0x0fff] to [bus 1a] add_size 1000
> [    2.070918] pci 0000:00:18.2: bridge window [io  0x1000-0x0fff] to [bus 1d] add_size 1000
> [    2.070973] pci 0000:00:18.3: bridge window [io  0x1000-0x0fff] to [bus 1e] add_size 1000
> [    2.071028] pci 0000:00:18.4: bridge window [io  0x1000-0x0fff] to [bus 1f] add_size 1000
> [    2.071084] pci 0000:00:18.5: bridge window [io  0x1000-0x0fff] to [bus 20] add_size 1000
> [    2.071139] pci 0000:00:18.6: bridge window [io  0x1000-0x0fff] to [bus 21] add_size 1000
> [    2.071195] pci 0000:00:18.7: bridge window [io  0x1000-0x0fff] to [bus 22] add_size 1000
> [    2.071216] pci 0000:00:15.3: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071218] pci 0000:00:15.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071220] pci 0000:00:15.5: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071222] pci 0000:00:15.6: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071224] pci 0000:00:15.7: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071226] pci 0000:00:16.3: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071228] pci 0000:00:16.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071230] pci 0000:00:16.5: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071232] pci 0000:00:16.6: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071234] pci 0000:00:16.7: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071236] pci 0000:00:17.3: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071237] pci 0000:00:17.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071239] pci 0000:00:17.5: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071241] pci 0000:00:17.6: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071243] pci 0000:00:17.7: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071245] pci 0000:00:18.2: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071247] pci 0000:00:18.3: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071249] pci 0000:00:18.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071250] pci 0000:00:18.5: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071256] pci 0000:00:18.6: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071258] pci 0000:00:18.7: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    2.071264] pci 0000:00:0f.0: BAR 6: assigned [mem 0x80000000-0x80007fff pref]
> [    2.071421] pci 0000:00:15.3: BAR 13: can't assign io (size 0x1000)
> [    2.071547] pci 0000:00:15.4: BAR 13: can't assign io (size 0x1000)
> [    2.071670] pci 0000:00:15.5: BAR 13: can't assign io (size 0x1000)
> [    2.071794] pci 0000:00:15.6: BAR 13: can't assign io (size 0x1000)
> [    2.071917] pci 0000:00:15.7: BAR 13: can't assign io (size 0x1000)
> [    2.072040] pci 0000:00:16.3: BAR 13: can't assign io (size 0x1000)
> [    2.072163] pci 0000:00:16.4: BAR 13: can't assign io (size 0x1000)
> [    2.072287] pci 0000:00:16.5: BAR 13: can't assign io (size 0x1000)
> [    2.072409] pci 0000:00:16.6: BAR 13: can't assign io (size 0x1000)
> [    2.072532] pci 0000:00:16.7: BAR 13: can't assign io (size 0x1000)
> [    2.072655] pci 0000:00:17.3: BAR 13: can't assign io (size 0x1000)
> [    2.072779] pci 0000:00:17.4: BAR 13: can't assign io (size 0x1000)
> [    2.072901] pci 0000:00:17.5: BAR 13: can't assign io (size 0x1000)
> [    2.073025] pci 0000:00:17.6: BAR 13: can't assign io (size 0x1000)
> [    2.073148] pci 0000:00:17.7: BAR 13: can't assign io (size 0x1000)
> [    2.073272] pci 0000:00:18.2: BAR 13: can't assign io (size 0x1000)
> [    2.073467] pci 0000:00:18.3: BAR 13: can't assign io (size 0x1000)
> [    2.073592] pci 0000:00:18.4: BAR 13: can't assign io (size 0x1000)
> [    2.073715] pci 0000:00:18.5: BAR 13: can't assign io (size 0x1000)
> [    2.073838] pci 0000:00:18.6: BAR 13: can't assign io (size 0x1000)
> [    2.073960] pci 0000:00:18.7: BAR 13: can't assign io (size 0x1000)
> [    2.074087] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    2.074313] pci 0000:00:11.0: PCI bridge to [bus 02]
> [    2.074431] pci 0000:00:11.0:   bridge window [io  0x2000-0x3fff]
> [    2.074579] pci 0000:00:11.0:   bridge window [mem 0xd1900000-0xd23fffff]
> [    2.074727] pci 0000:00:11.0:   bridge window [mem 0xdc400000-0xdc9fffff 64bit pref]
> [    2.074925] pci 0000:03:00.0: BAR 6: assigned [mem 0xd4400000-0xd440ffff pref]
> [    2.075063] pci 0000:00:15.0: PCI bridge to [bus 03]
> [    2.075179] pci 0000:00:15.0:   bridge window [io  0x4000-0x4fff]
> [    2.075328] pci 0000:00:15.0:   bridge window [mem 0xd2400000-0xd24fffff]
> [    2.075476] pci 0000:00:15.0:   bridge window [mem 0xd4400000-0xd44fffff 64bit pref]
> [    2.075708] pci 0000:00:15.1: PCI bridge to [bus 04]
> [    2.075826] pci 0000:00:15.1:   bridge window [io  0x8000-0x8fff]
> [    2.075978] pci 0000:00:15.1:   bridge window [mem 0xd2800000-0xd28fffff]
> [    2.076124] pci 0000:00:15.1:   bridge window [mem 0xd4800000-0xd48fffff 64bit pref]
> [    2.076314] pci 0000:00:15.2: PCI bridge to [bus 05]
> [    2.076431] pci 0000:00:15.2:   bridge window [io  0xc000-0xcfff]
> [    2.076579] pci 0000:00:15.2:   bridge window [mem 0xd2c00000-0xd2cfffff]
> [    2.076728] pci 0000:00:15.2:   bridge window [mem 0xdcb00000-0xdcbfffff 64bit pref]
> [    2.076918] pci 0000:00:15.3: PCI bridge to [bus 06]
> [    2.077052] pci 0000:00:15.3:   bridge window [mem 0xd3000000-0xd30fffff]
> [    2.077201] pci 0000:00:15.3:   bridge window [mem 0xdcd00000-0xdcdfffff 64bit pref]
> [    2.077389] pci 0000:00:15.4: PCI bridge to [bus 07]
> [    2.077524] pci 0000:00:15.4:   bridge window [mem 0xd3400000-0xd34fffff]
> [    2.077672] pci 0000:00:15.4:   bridge window [mem 0xdcf00000-0xdcffffff 64bit pref]
> [    2.077860] pci 0000:00:15.5: PCI bridge to [bus 08]
> [    2.077995] pci 0000:00:15.5:   bridge window [mem 0xd3800000-0xd38fffff]
> [    2.078143] pci 0000:00:15.5:   bridge window [mem 0xdd100000-0xdd1fffff 64bit pref]
> [    2.078331] pci 0000:00:15.6: PCI bridge to [bus 09]
> [    2.078465] pci 0000:00:15.6:   bridge window [mem 0xd3c00000-0xd3cfffff]
> [    2.078613] pci 0000:00:15.6:   bridge window [mem 0xdd300000-0xdd3fffff 64bit pref]
> [    2.078802] pci 0000:00:15.7: PCI bridge to [bus 0a]
> [    2.078937] pci 0000:00:15.7:   bridge window [mem 0xd4000000-0xd40fffff]
> [    2.079087] pci 0000:00:15.7:   bridge window [mem 0xdd500000-0xdd5fffff 64bit pref]
> [    2.079275] pci 0000:00:16.0: PCI bridge to [bus 0b]
> [    2.079397] pci 0000:00:16.0:   bridge window [io  0x5000-0x5fff]
> [    2.079544] pci 0000:00:16.0:   bridge window [mem 0xd2500000-0xd25fffff]
> [    2.079692] pci 0000:00:16.0:   bridge window [mem 0xd4500000-0xd45fffff 64bit pref]
> [    2.079880] pci 0000:00:16.1: PCI bridge to [bus 0c]
> [    2.079996] pci 0000:00:16.1:   bridge window [io  0x9000-0x9fff]
> [    2.080144] pci 0000:00:16.1:   bridge window [mem 0xd2900000-0xd29fffff]
> [    2.080294] pci 0000:00:16.1:   bridge window [mem 0xd4900000-0xd49fffff 64bit pref]
> [    2.080481] pci 0000:00:16.2: PCI bridge to [bus 0d]
> [    2.080598] pci 0000:00:16.2:   bridge window [io  0xd000-0xdfff]
> [    2.080746] pci 0000:00:16.2:   bridge window [mem 0xd2d00000-0xd2dfffff]
> [    2.080894] pci 0000:00:16.2:   bridge window [mem 0xd4b00000-0xd4bfffff 64bit pref]
> [    2.081081] pci 0000:00:16.3: PCI bridge to [bus 0e]
> [    2.081215] pci 0000:00:16.3:   bridge window [mem 0xd3100000-0xd31fffff]
> [    2.081364] pci 0000:00:16.3:   bridge window [mem 0xd4d00000-0xd4dfffff 64bit pref]
> [    2.081551] pci 0000:00:16.4: PCI bridge to [bus 0f]
> [    2.081688] pci 0000:00:16.4:   bridge window [mem 0xd3500000-0xd35fffff]
> [    2.082484] pci 0000:00:16.4:   bridge window [mem 0xd4f00000-0xd4ffffff 64bit pref]
> [    2.082696] pci 0000:00:16.5: PCI bridge to [bus 10]
> [    2.082834] pci 0000:00:16.5:   bridge window [mem 0xd3900000-0xd39fffff]
> [    2.082982] pci 0000:00:16.5:   bridge window [mem 0xd5100000-0xd51fffff 64bit pref]
> [    2.083171] pci 0000:00:16.6: PCI bridge to [bus 11]
> [    2.083347] pci 0000:00:16.6:   bridge window [mem 0xd3d00000-0xd3dfffff]
> [    2.083503] pci 0000:00:16.6:   bridge window [mem 0xd5300000-0xd53fffff 64bit pref]
> [    2.083694] pci 0000:00:16.7: PCI bridge to [bus 12]
> [    2.083829] pci 0000:00:16.7:   bridge window [mem 0xd4100000-0xd41fffff]
> [    2.083978] pci 0000:00:16.7:   bridge window [mem 0xd5500000-0xd55fffff 64bit pref]
> [    2.084170] pci 0000:13:00.0: BAR 6: assigned [mem 0xd4600000-0xd460ffff pref]
> [    2.084319] pci 0000:00:17.0: PCI bridge to [bus 13]
> [    2.084437] pci 0000:00:17.0:   bridge window [io  0x6000-0x6fff]
> [    2.084585] pci 0000:00:17.0:   bridge window [mem 0xd2600000-0xd26fffff]
> [    2.084733] pci 0000:00:17.0:   bridge window [mem 0xd4600000-0xd46fffff 64bit pref]
> [    2.084920] pci 0000:00:17.1: PCI bridge to [bus 14]
> [    2.085037] pci 0000:00:17.1:   bridge window [io  0xa000-0xafff]
> [    2.085184] pci 0000:00:17.1:   bridge window [mem 0xd2a00000-0xd2afffff]
> [    2.085333] pci 0000:00:17.1:   bridge window [mem 0xdca00000-0xdcafffff 64bit pref]
> [    2.085524] pci 0000:00:17.2: PCI bridge to [bus 15]
> [    2.085641] pci 0000:00:17.2:   bridge window [io  0xe000-0xefff]
> [    2.085789] pci 0000:00:17.2:   bridge window [mem 0xd2e00000-0xd2efffff]
> [    2.085936] pci 0000:00:17.2:   bridge window [mem 0xdcc00000-0xdccfffff 64bit pref]
> [    2.086124] pci 0000:00:17.3: PCI bridge to [bus 16]
> [    2.086258] pci 0000:00:17.3:   bridge window [mem 0xd3200000-0xd32fffff]
> [    2.086406] pci 0000:00:17.3:   bridge window [mem 0xdce00000-0xdcefffff 64bit pref]
> [    2.086594] pci 0000:00:17.4: PCI bridge to [bus 17]
> [    2.086728] pci 0000:00:17.4:   bridge window [mem 0xd3600000-0xd36fffff]
> [    2.086876] pci 0000:00:17.4:   bridge window [mem 0xdd000000-0xdd0fffff 64bit pref]
> [    2.087063] pci 0000:00:17.5: PCI bridge to [bus 18]
> [    2.087197] pci 0000:00:17.5:   bridge window [mem 0xd3a00000-0xd3afffff]
> [    2.087351] pci 0000:00:17.5:   bridge window [mem 0xdd200000-0xdd2fffff 64bit pref]
> [    2.087539] pci 0000:00:17.6: PCI bridge to [bus 19]
> [    2.087676] pci 0000:00:17.6:   bridge window [mem 0xd3e00000-0xd3efffff]
> [    2.087825] pci 0000:00:17.6:   bridge window [mem 0xdd400000-0xdd4fffff 64bit pref]
> [    2.088016] pci 0000:00:17.7: PCI bridge to [bus 1a]
> [    2.088150] pci 0000:00:17.7:   bridge window [mem 0xd4200000-0xd42fffff]
> [    2.088300] pci 0000:00:17.7:   bridge window [mem 0xdd600000-0xdd6fffff 64bit pref]
> [    2.088487] pci 0000:00:18.0: PCI bridge to [bus 1b]
> [    2.088604] pci 0000:00:18.0:   bridge window [io  0x7000-0x7fff]
> [    2.088753] pci 0000:00:18.0:   bridge window [mem 0xd2700000-0xd27fffff]
> [    2.088900] pci 0000:00:18.0:   bridge window [mem 0xd4700000-0xd47fffff 64bit pref]
> [    2.089087] pci 0000:00:18.1: PCI bridge to [bus 1c]
> [    2.089204] pci 0000:00:18.1:   bridge window [io  0xb000-0xbfff]
> [    2.089352] pci 0000:00:18.1:   bridge window [mem 0xd2b00000-0xd2bfffff]
> [    2.089500] pci 0000:00:18.1:   bridge window [mem 0xd4a00000-0xd4afffff 64bit pref]
> [    2.089688] pci 0000:00:18.2: PCI bridge to [bus 1d]
> [    2.089822] pci 0000:00:18.2:   bridge window [mem 0xd2f00000-0xd2ffffff]
> [    2.089969] pci 0000:00:18.2:   bridge window [mem 0xd4c00000-0xd4cfffff 64bit pref]
> [    2.090157] pci 0000:00:18.3: PCI bridge to [bus 1e]
> [    2.090294] pci 0000:00:18.3:   bridge window [mem 0xd3300000-0xd33fffff]
> [    2.090442] pci 0000:00:18.3:   bridge window [mem 0xd4e00000-0xd4efffff 64bit pref]
> [    2.090629] pci 0000:00:18.4: PCI bridge to [bus 1f]
> [    2.090763] pci 0000:00:18.4:   bridge window [mem 0xd3700000-0xd37fffff]
> [    2.090911] pci 0000:00:18.4:   bridge window [mem 0xd5000000-0xd50fffff 64bit pref]
> [    2.091098] pci 0000:00:18.5: PCI bridge to [bus 20]
> [    2.091232] pci 0000:00:18.5:   bridge window [mem 0xd3b00000-0xd3bfffff]
> [    2.091383] pci 0000:00:18.5:   bridge window [mem 0xd5200000-0xd52fffff 64bit pref]
> [    2.092747] pci 0000:00:18.6: PCI bridge to [bus 21]
> [    2.092884] pci 0000:00:18.6:   bridge window [mem 0xd3f00000-0xd3ffffff]
> [    2.093034] pci 0000:00:18.6:   bridge window [mem 0xd5400000-0xd54fffff 64bit pref]
> [    2.093224] pci 0000:00:18.7: PCI bridge to [bus 22]
> [    2.093383] pci 0000:00:18.7:   bridge window [mem 0xd4300000-0xd43fffff]
> [    2.093532] pci 0000:00:18.7:   bridge window [mem 0xd5600000-0xd56fffff 64bit pref]
> [    2.093759] pci 0000:00:01.0: setting latency timer to 64
> [    2.094670] pci_bus 0000:00: resource 4 [mem 0x000a0000-0x000bffff]
> [    2.094672] pci_bus 0000:00: resource 5 [mem 0x000cc000-0x000cffff]
> [    2.094673] pci_bus 0000:00: resource 6 [mem 0x000d0000-0x000d3fff]
> [    2.094675] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
> [    2.094676] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
> [    2.094678] pci_bus 0000:00: resource 9 [mem 0x80000000-0xfebfffff]
> [    2.094683] pci_bus 0000:00: resource 10 [io  0x0000-0x0cf7]
> [    2.094684] pci_bus 0000:00: resource 11 [io  0x0d00-0xfeff]
> [    2.094687] pci_bus 0000:02: resource 0 [io  0x2000-0x3fff]
> [    2.094688] pci_bus 0000:02: resource 1 [mem 0xd1900000-0xd23fffff]
> [    2.094690] pci_bus 0000:02: resource 2 [mem 0xdc400000-0xdc9fffff 64bit pref]
> [    2.094692] pci_bus 0000:02: resource 4 [mem 0x000a0000-0x000bffff]
> [    2.094693] pci_bus 0000:02: resource 5 [mem 0x000cc000-0x000cffff]
> [    2.094695] pci_bus 0000:02: resource 6 [mem 0x000d0000-0x000d3fff]
> [    2.094696] pci_bus 0000:02: resource 7 [mem 0x000d4000-0x000d7fff]
> [    2.094698] pci_bus 0000:02: resource 8 [mem 0x000d8000-0x000dbfff]
> [    2.094700] pci_bus 0000:02: resource 9 [mem 0x80000000-0xfebfffff]
> [    2.094701] pci_bus 0000:02: resource 10 [io  0x0000-0x0cf7]
> [    2.094703] pci_bus 0000:02: resource 11 [io  0x0d00-0xfeff]
> [    2.094705] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
> [    2.094706] pci_bus 0000:03: resource 1 [mem 0xd2400000-0xd24fffff]
> [    2.094708] pci_bus 0000:03: resource 2 [mem 0xd4400000-0xd44fffff 64bit pref]
> [    2.094710] pci_bus 0000:04: resource 0 [io  0x8000-0x8fff]
> [    2.094711] pci_bus 0000:04: resource 1 [mem 0xd2800000-0xd28fffff]
> [    2.094713] pci_bus 0000:04: resource 2 [mem 0xd4800000-0xd48fffff 64bit pref]
> [    2.094715] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
> [    2.094716] pci_bus 0000:05: resource 1 [mem 0xd2c00000-0xd2cfffff]
> [    2.094718] pci_bus 0000:05: resource 2 [mem 0xdcb00000-0xdcbfffff 64bit pref]
> [    2.094720] pci_bus 0000:06: resource 1 [mem 0xd3000000-0xd30fffff]
> [    2.094722] pci_bus 0000:06: resource 2 [mem 0xdcd00000-0xdcdfffff 64bit pref]
> [    2.094723] pci_bus 0000:07: resource 1 [mem 0xd3400000-0xd34fffff]
> [    2.094725] pci_bus 0000:07: resource 2 [mem 0xdcf00000-0xdcffffff 64bit pref]
> [    2.094727] pci_bus 0000:08: resource 1 [mem 0xd3800000-0xd38fffff]
> [    2.094728] pci_bus 0000:08: resource 2 [mem 0xdd100000-0xdd1fffff 64bit pref]
> [    2.094730] pci_bus 0000:09: resource 1 [mem 0xd3c00000-0xd3cfffff]
> [    2.094732] pci_bus 0000:09: resource 2 [mem 0xdd300000-0xdd3fffff 64bit pref]
> [    2.094734] pci_bus 0000:0a: resource 1 [mem 0xd4000000-0xd40fffff]
> [    2.094736] pci_bus 0000:0a: resource 2 [mem 0xdd500000-0xdd5fffff 64bit pref]
> [    2.094737] pci_bus 0000:0b: resource 0 [io  0x5000-0x5fff]
> [    2.094739] pci_bus 0000:0b: resource 1 [mem 0xd2500000-0xd25fffff]
> [    2.094741] pci_bus 0000:0b: resource 2 [mem 0xd4500000-0xd45fffff 64bit pref]
> [    2.094742] pci_bus 0000:0c: resource 0 [io  0x9000-0x9fff]
> [    2.094746] pci_bus 0000:0c: resource 1 [mem 0xd2900000-0xd29fffff]
> [    2.094748] pci_bus 0000:0c: resource 2 [mem 0xd4900000-0xd49fffff 64bit pref]
> [    2.094750] pci_bus 0000:0d: resource 0 [io  0xd000-0xdfff]
> [    2.094751] pci_bus 0000:0d: resource 1 [mem 0xd2d00000-0xd2dfffff]
> [    2.094753] pci_bus 0000:0d: resource 2 [mem 0xd4b00000-0xd4bfffff 64bit pref]
> [    2.094755] pci_bus 0000:0e: resource 1 [mem 0xd3100000-0xd31fffff]
> [    2.094756] pci_bus 0000:0e: resource 2 [mem 0xd4d00000-0xd4dfffff 64bit pref]
> [    2.094758] pci_bus 0000:0f: resource 1 [mem 0xd3500000-0xd35fffff]
> [    2.094760] pci_bus 0000:0f: resource 2 [mem 0xd4f00000-0xd4ffffff 64bit pref]
> [    2.094762] pci_bus 0000:10: resource 1 [mem 0xd3900000-0xd39fffff]
> [    2.094763] pci_bus 0000:10: resource 2 [mem 0xd5100000-0xd51fffff 64bit pref]
> [    2.094765] pci_bus 0000:11: resource 1 [mem 0xd3d00000-0xd3dfffff]
> [    2.094767] pci_bus 0000:11: resource 2 [mem 0xd5300000-0xd53fffff 64bit pref]
> [    2.094769] pci_bus 0000:12: resource 1 [mem 0xd4100000-0xd41fffff]
> [    2.094770] pci_bus 0000:12: resource 2 [mem 0xd5500000-0xd55fffff 64bit pref]
> [    2.094772] pci_bus 0000:13: resource 0 [io  0x6000-0x6fff]
> [    2.094774] pci_bus 0000:13: resource 1 [mem 0xd2600000-0xd26fffff]
> [    2.094776] pci_bus 0000:13: resource 2 [mem 0xd4600000-0xd46fffff 64bit pref]
> [    2.094777] pci_bus 0000:14: resource 0 [io  0xa000-0xafff]
> [    2.094779] pci_bus 0000:14: resource 1 [mem 0xd2a00000-0xd2afffff]
> [    2.094781] pci_bus 0000:14: resource 2 [mem 0xdca00000-0xdcafffff 64bit pref]
> [    2.094782] pci_bus 0000:15: resource 0 [io  0xe000-0xefff]
> [    2.094784] pci_bus 0000:15: resource 1 [mem 0xd2e00000-0xd2efffff]
> [    2.094786] pci_bus 0000:15: resource 2 [mem 0xdcc00000-0xdccfffff 64bit pref]
> [    2.094787] pci_bus 0000:16: resource 1 [mem 0xd3200000-0xd32fffff]
> [    2.094789] pci_bus 0000:16: resource 2 [mem 0xdce00000-0xdcefffff 64bit pref]
> [    2.094791] pci_bus 0000:17: resource 1 [mem 0xd3600000-0xd36fffff]
> [    2.094792] pci_bus 0000:17: resource 2 [mem 0xdd000000-0xdd0fffff 64bit pref]
> [    2.094794] pci_bus 0000:18: resource 1 [mem 0xd3a00000-0xd3afffff]
> [    2.094796] pci_bus 0000:18: resource 2 [mem 0xdd200000-0xdd2fffff 64bit pref]
> [    2.094798] pci_bus 0000:19: resource 1 [mem 0xd3e00000-0xd3efffff]
> [    2.094799] pci_bus 0000:19: resource 2 [mem 0xdd400000-0xdd4fffff 64bit pref]
> [    2.094801] pci_bus 0000:1a: resource 1 [mem 0xd4200000-0xd42fffff]
> [    2.094803] pci_bus 0000:1a: resource 2 [mem 0xdd600000-0xdd6fffff 64bit pref]
> [    2.094805] pci_bus 0000:1b: resource 0 [io  0x7000-0x7fff]
> [    2.094808] pci_bus 0000:1b: resource 1 [mem 0xd2700000-0xd27fffff]
> [    2.094810] pci_bus 0000:1b: resource 2 [mem 0xd4700000-0xd47fffff 64bit pref]
> [    2.094812] pci_bus 0000:1c: resource 0 [io  0xb000-0xbfff]
> [    2.094814] pci_bus 0000:1c: resource 1 [mem 0xd2b00000-0xd2bfffff]
> [    2.094815] pci_bus 0000:1c: resource 2 [mem 0xd4a00000-0xd4afffff 64bit pref]
> [    2.094817] pci_bus 0000:1d: resource 1 [mem 0xd2f00000-0xd2ffffff]
> [    2.094819] pci_bus 0000:1d: resource 2 [mem 0xd4c00000-0xd4cfffff 64bit pref]
> [    2.094820] pci_bus 0000:1e: resource 1 [mem 0xd3300000-0xd33fffff]
> [    2.094822] pci_bus 0000:1e: resource 2 [mem 0xd4e00000-0xd4efffff 64bit pref]
> [    2.094824] pci_bus 0000:1f: resource 1 [mem 0xd3700000-0xd37fffff]
> [    2.094826] pci_bus 0000:1f: resource 2 [mem 0xd5000000-0xd50fffff 64bit pref]
> [    2.094827] pci_bus 0000:20: resource 1 [mem 0xd3b00000-0xd3bfffff]
> [    2.094829] pci_bus 0000:20: resource 2 [mem 0xd5200000-0xd52fffff 64bit pref]
> [    2.094831] pci_bus 0000:21: resource 1 [mem 0xd3f00000-0xd3ffffff]
> [    2.094832] pci_bus 0000:21: resource 2 [mem 0xd5400000-0xd54fffff 64bit pref]
> [    2.094834] pci_bus 0000:22: resource 1 [mem 0xd4300000-0xd43fffff]
> [    2.094836] pci_bus 0000:22: resource 2 [mem 0xd5600000-0xd56fffff 64bit pref]
> [    2.094873] NET: Registered protocol family 2
> [    2.095107] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
> [    2.095416] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
> [    2.095852] TCP: Hash tables configured (established 16384 bind 16384)
> [    2.096070] TCP: reno registered
> [    2.096770] UDP hash table entries: 1024 (order: 3, 32768 bytes)
> [    2.096913] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
> [    2.097145] NET: Registered protocol family 1
> [    2.097259] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    2.097470] pci 0000:00:0f.0: Boot video device
> [    2.097798] PCI: CLS mismatch (32 != 64), using 64 bytes
> [    2.106273] Simple Boot Flag at 0x36 set to 0x80
> [    2.106389] Switching to clocksource tsc
> [    2.107515] microcode: CPU0 sig=0x1067a, pf=0x1, revision=0xa0b
> [    2.107660] microcode: CPU1 sig=0x1067a, pf=0x1, revision=0xa0b
> [    2.107922] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    2.108750] AVX or AES-NI instructions are not detected.
> [    2.108861] AVX instructions are not detected.
> [    2.108959] AVX instructions are not detected.
> [    2.109954] AVX instructions are not detected.
> [    2.111142] AVX instructions are not detected.
> [    2.111367] sha1_ssse3: Using SSSE3 optimized SHA-1 implementation
> [    2.112792] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    2.122120] NTFS driver 2.1.30 [Flags: R/W].
> [    2.123194] Btrfs loaded
> [    2.123303] msgmni has been set to 3996
> [    2.127918] NET: Registered protocol family 38
> [    2.128048] async_tx: api initialized (async)
> [    2.128358] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
> [    2.128555] io scheduler noop registered
> [    2.128677] io scheduler deadline registered (default)
> [    2.128789] io scheduler cfq registered
> [    2.129289] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
> [    2.129415] crc32: self tests passed, processed 225944 bytes in 177483 nsec
> [    2.129741] crc32c: CRC_LE_BITS = 64
> [    2.129831] crc32c: self tests passed, processed 225944 bytes in 88599 nsec
> [    2.130643] pcieport 0000:00:15.0: irq 40 for MSI/MSI-X
> [    2.131618] pcieport 0000:00:15.1: irq 41 for MSI/MSI-X
> [    2.132582] pcieport 0000:00:15.2: irq 42 for MSI/MSI-X
> [    2.133628] pcieport 0000:00:15.3: irq 43 for MSI/MSI-X
> [    2.134599] pcieport 0000:00:15.4: irq 44 for MSI/MSI-X
> [    2.135558] pcieport 0000:00:15.5: irq 45 for MSI/MSI-X
> [    2.136516] pcieport 0000:00:15.6: irq 46 for MSI/MSI-X
> [    2.137476] pcieport 0000:00:15.7: irq 47 for MSI/MSI-X
> [    2.138431] pcieport 0000:00:16.0: irq 48 for MSI/MSI-X
> [    2.139397] pcieport 0000:00:16.1: irq 49 for MSI/MSI-X
> [    2.140388] pcieport 0000:00:16.2: irq 50 for MSI/MSI-X
> [    2.141368] pcieport 0000:00:16.3: irq 51 for MSI/MSI-X
> [    2.142325] pcieport 0000:00:16.4: irq 52 for MSI/MSI-X
> [    2.143346] pcieport 0000:00:16.5: irq 53 for MSI/MSI-X
> [    2.144303] pcieport 0000:00:16.6: irq 54 for MSI/MSI-X
> [    2.145255] pcieport 0000:00:16.7: irq 55 for MSI/MSI-X
> [    2.146219] pcieport 0000:00:17.0: irq 56 for MSI/MSI-X
> [    2.147176] pcieport 0000:00:17.1: irq 57 for MSI/MSI-X
> [    2.148140] pcieport 0000:00:17.2: irq 58 for MSI/MSI-X
> [    2.149156] pcieport 0000:00:17.3: irq 59 for MSI/MSI-X
> [    2.150112] pcieport 0000:00:17.4: irq 60 for MSI/MSI-X
> [    2.151067] pcieport 0000:00:17.5: irq 61 for MSI/MSI-X
> [    2.152022] pcieport 0000:00:17.6: irq 62 for MSI/MSI-X
> [    2.152973] pcieport 0000:00:17.7: irq 63 for MSI/MSI-X
> [    2.153956] pcieport 0000:00:18.0: irq 64 for MSI/MSI-X
> [    2.154918] pcieport 0000:00:18.1: irq 65 for MSI/MSI-X
> [    2.155877] pcieport 0000:00:18.2: irq 66 for MSI/MSI-X
> [    2.156829] pcieport 0000:00:18.3: irq 67 for MSI/MSI-X
> [    2.157789] pcieport 0000:00:18.4: irq 68 for MSI/MSI-X
> [    2.158740] pcieport 0000:00:18.5: irq 69 for MSI/MSI-X
> [    2.159693] pcieport 0000:00:18.6: irq 70 for MSI/MSI-X
> [    2.160648] pcieport 0000:00:18.7: irq 71 for MSI/MSI-X
> [    2.161566] pcieport 0000:00:15.0: Signaling PME through PCIe PME interrupt
> [    2.161705] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
> [    2.161849] pcie_pme 0000:00:15.0:pcie01: service driver pcie_pme loaded
> [    2.161952] pcieport 0000:00:15.1: Signaling PME through PCIe PME interrupt
> [    2.162084] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
> [    2.162229] pcie_pme 0000:00:15.1:pcie01: service driver pcie_pme loaded
> [    2.162333] pcieport 0000:00:15.2: Signaling PME through PCIe PME interrupt
> [    2.162485] pcie_pme 0000:00:15.2:pcie01: service driver pcie_pme loaded
> [    2.162585] pcieport 0000:00:15.3: Signaling PME through PCIe PME interrupt
> [    2.162736] pcie_pme 0000:00:15.3:pcie01: service driver pcie_pme loaded
> [    2.162838] pcieport 0000:00:15.4: Signaling PME through PCIe PME interrupt
> [    2.162989] pcie_pme 0000:00:15.4:pcie01: service driver pcie_pme loaded
> [    2.163093] pcieport 0000:00:15.5: Signaling PME through PCIe PME interrupt
> [    2.163320] pcie_pme 0000:00:15.5:pcie01: service driver pcie_pme loaded
> [    2.163422] pcieport 0000:00:15.6: Signaling PME through PCIe PME interrupt
> [    2.163579] pcie_pme 0000:00:15.6:pcie01: service driver pcie_pme loaded
> [    2.163680] pcieport 0000:00:15.7: Signaling PME through PCIe PME interrupt
> [    2.163832] pcie_pme 0000:00:15.7:pcie01: service driver pcie_pme loaded
> [    2.163933] pcieport 0000:00:16.0: Signaling PME through PCIe PME interrupt
> [    2.164068] pci 0000:0b:00.0: Signaling PME through PCIe PME interrupt
> [    2.164221] pcie_pme 0000:00:16.0:pcie01: service driver pcie_pme loaded
> [    2.164324] pcieport 0000:00:16.1: Signaling PME through PCIe PME interrupt
> [    2.164457] pci 0000:0c:00.0: Signaling PME through PCIe PME interrupt
> [    2.164601] pcie_pme 0000:00:16.1:pcie01: service driver pcie_pme loaded
> [    2.164701] pcieport 0000:00:16.2: Signaling PME through PCIe PME interrupt
> [    2.164853] pcie_pme 0000:00:16.2:pcie01: service driver pcie_pme loaded
> [    2.164954] pcieport 0000:00:16.3: Signaling PME through PCIe PME interrupt
> [    2.165106] pcie_pme 0000:00:16.3:pcie01: service driver pcie_pme loaded
> [    2.165207] pcieport 0000:00:16.4: Signaling PME through PCIe PME interrupt
> [    2.165358] pcie_pme 0000:00:16.4:pcie01: service driver pcie_pme loaded
> [    2.165459] pcieport 0000:00:16.5: Signaling PME through PCIe PME interrupt
> [    2.165610] pcie_pme 0000:00:16.5:pcie01: service driver pcie_pme loaded
> [    2.165710] pcieport 0000:00:16.6: Signaling PME through PCIe PME interrupt
> [    2.165861] pcie_pme 0000:00:16.6:pcie01: service driver pcie_pme loaded
> [    2.165962] pcieport 0000:00:16.7: Signaling PME through PCIe PME interrupt
> [    2.166114] pcie_pme 0000:00:16.7:pcie01: service driver pcie_pme loaded
> [    2.166215] pcieport 0000:00:17.0: Signaling PME through PCIe PME interrupt
> [    2.166347] pci 0000:13:00.0: Signaling PME through PCIe PME interrupt
> [    2.166494] pcie_pme 0000:00:17.0:pcie01: service driver pcie_pme loaded
> [    2.166594] pcieport 0000:00:17.1: Signaling PME through PCIe PME interrupt
> [    2.166745] pcie_pme 0000:00:17.1:pcie01: service driver pcie_pme loaded
> [    2.166847] pcieport 0000:00:17.2: Signaling PME through PCIe PME interrupt
> [    2.166999] pcie_pme 0000:00:17.2:pcie01: service driver pcie_pme loaded
> [    2.167101] pcieport 0000:00:17.3: Signaling PME through PCIe PME interrupt
> [    2.167253] pcie_pme 0000:00:17.3:pcie01: service driver pcie_pme loaded
> [    2.167353] pcieport 0000:00:17.4: Signaling PME through PCIe PME interrupt
> [    2.167504] pcie_pme 0000:00:17.4:pcie01: service driver pcie_pme loaded
> [    2.167605] pcieport 0000:00:17.5: Signaling PME through PCIe PME interrupt
> [    2.167757] pcie_pme 0000:00:17.5:pcie01: service driver pcie_pme loaded
> [    2.167859] pcieport 0000:00:17.6: Signaling PME through PCIe PME interrupt
> [    2.168663] pcie_pme 0000:00:17.6:pcie01: service driver pcie_pme loaded
> [    2.168764] pcieport 0000:00:17.7: Signaling PME through PCIe PME interrupt
> [    2.168915] pcie_pme 0000:00:17.7:pcie01: service driver pcie_pme loaded
> [    2.169017] pcieport 0000:00:18.0: Signaling PME through PCIe PME interrupt
> [    2.169149] pci 0000:1b:00.0: Signaling PME through PCIe PME interrupt
> [    2.169303] pcie_pme 0000:00:18.0:pcie01: service driver pcie_pme loaded
> [    2.169405] pcieport 0000:00:18.1: Signaling PME through PCIe PME interrupt
> [    2.169556] pcie_pme 0000:00:18.1:pcie01: service driver pcie_pme loaded
> [    2.169656] pcieport 0000:00:18.2: Signaling PME through PCIe PME interrupt
> [    2.169807] pcie_pme 0000:00:18.2:pcie01: service driver pcie_pme loaded
> [    2.169908] pcieport 0000:00:18.3: Signaling PME through PCIe PME interrupt
> [    2.170062] pcie_pme 0000:00:18.3:pcie01: service driver pcie_pme loaded
> [    2.170163] pcieport 0000:00:18.4: Signaling PME through PCIe PME interrupt
> [    2.170318] pcie_pme 0000:00:18.4:pcie01: service driver pcie_pme loaded
> [    2.170419] pcieport 0000:00:18.5: Signaling PME through PCIe PME interrupt
> [    2.170572] pcie_pme 0000:00:18.5:pcie01: service driver pcie_pme loaded
> [    2.170675] pcieport 0000:00:18.6: Signaling PME through PCIe PME interrupt
> [    2.170828] pcie_pme 0000:00:18.6:pcie01: service driver pcie_pme loaded
> [    2.170928] pcieport 0000:00:18.7: Signaling PME through PCIe PME interrupt
> [    2.171081] pcie_pme 0000:00:18.7:pcie01: service driver pcie_pme loaded
> [    2.233171] Serial: 8250/16550 driver, 2 ports, IRQ sharing enabled
> [    2.258153] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    2.283266] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> [    2.284358] Real Time Clock Driver v1.12b
> [    2.284937] Linux agpgart interface v0.103
> [    2.285159] agpgart-intel 0000:00:00.0: Intel 440BX Chipset
> [    2.286270] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x0
> [    2.295339] intel_idle: does not run on family 6 model 23
> [    2.295500] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
> [    2.295927] ACPI: AC Adapter [ACAD] (on-line)
> [    2.296287] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    2.296428] ACPI: Power Button [PWRF]
> [    2.393345] GHES: HEST is not enabled!
> [    2.393451] ERST DBG: ERST support is disabled.
> [    2.393557] ioatdma: Intel(R) QuickData Technology Driver 4.00
> [    2.397815] brd: module loaded
> [    2.399928] loop: module loaded
> [    2.401711] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
> [    2.401988] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
> [    2.402209] megasas: 06.504.01.00-rc1 Mon. Oct. 1 17:00:00 PDT 2012
> [    2.402432] mpt2sas version 14.100.00.00 loaded
> [    2.402760] scsi0 : Fusion MPT SAS Host
> [    2.403657] mpt2sas0: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (2046048 kB)
> [    2.404343] mpt2sas 0000:04:00.0: irq 72 for MSI/MSI-X
> [    2.404608] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 72
> [    2.404719] mpt2sas0: iomem(0x00000000d2800000), mapped(0xffffc90000028000), size(16384)
> [    2.404866] mpt2sas0: ioport(0x0000000000008000), size(256)
> [    3.482116] mpt2sas0: Allocated physical memory: size(2267 kB)
> [    3.482261] mpt2sas0: Current Controller Queue Depth(1483), Max Controller Queue Depth(1720)
> [    3.482409] mpt2sas0: Scatter Gather Elements per IO(128)
> [    4.058953] mpt2sas0: LSISAS2008: FWVersion(15.00.00.00), ChipRevision(0x02), BiosVersion(07.29.00.00)
> [    4.059165] mpt2sas0: Protocol=(Initiator), Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
> [    4.059809] mpt2sas0: sending port enable !!
> [    5.415081] floppy0: no floppy controllers found
> [    5.615630] mpt2sas0: host_add: handle(0x0001), sas_addr(0x500605b0026e1700), phys(8)
> [   10.741633] mpt2sas0: port enable: SUCCESS
> [   10.754019] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD153WI  0003 PQ: 0 ANSI: 6
> [   10.754222] scsi 0:0:0:0: SATA: handle(0x0009), sas_addr(0x4433221100000000), phy(0), device_name(0x50024e90035141f8)
> [   10.754494] scsi 0:0:0:0: SATA: enclosure_logical_id(0x500605b0026e1700), slot(3)
> [   10.754776] scsi 0:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
> [   10.754978] scsi 0:0:0:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> [   10.768278] scsi 0:0:1:0: Direct-Access     ATA      SAMSUNG HD203WI  0003 PQ: 0 ANSI: 6
> [   10.768485] scsi 0:0:1:0: SATA: handle(0x000a), sas_addr(0x4433221102000000), phy(2), device_name(0x50024e90030a1b80)
> [   10.768757] scsi 0:0:1:0: SATA: enclosure_logical_id(0x500605b0026e1700), slot(1)
> [   10.769043] scsi 0:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
> [   10.769246] scsi 0:0:1:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> [   10.782491] scsi 0:0:2:0: Direct-Access     ATA      SAMSUNG HD203WI  0003 PQ: 0 ANSI: 6
> [   10.782701] scsi 0:0:2:0: SATA: handle(0x000b), sas_addr(0x4433221103000000), phy(3), device_name(0x50024e9003d0c097)
> [   10.782972] scsi 0:0:2:0: SATA: enclosure_logical_id(0x500605b0026e1700), slot(0)
> [   10.783251] scsi 0:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
> [   10.783453] scsi 0:0:2:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> [   10.787018] scsi 0:0:3:0: Direct-Access     ATA      ST31500541AS     CC35 PQ: 0 ANSI: 6
> [   10.787275] scsi 0:0:3:0: SATA: handle(0x000c), sas_addr(0x4433221101000000), phy(1), device_name(0x5000c5001b6da52d)
> [   10.787547] scsi 0:0:3:0: SATA: enclosure_logical_id(0x500605b0026e1700), slot(2)
> [   10.787825] scsi 0:0:3:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
> [   10.788027] scsi 0:0:3:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> [   10.791521] scsi 0:0:4:0: Direct-Access     ATA      Hitachi HDS5C302 A800 PQ: 0 ANSI: 6
> [   10.791721] scsi 0:0:4:0: SATA: handle(0x000d), sas_addr(0x4433221104000000), phy(4), device_name(0x5000cca369c8d933)
> [   10.791992] scsi 0:0:4:0: SATA: enclosure_logical_id(0x500605b0026e1700), slot(7)
> [   10.792269] scsi 0:0:4:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
> [   10.792478] scsi 0:0:4:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> [   10.795858] scsi 0:0:5:0: Direct-Access     ATA      Hitachi HDS5C302 A800 PQ: 0 ANSI: 6
> [   10.796058] scsi 0:0:5:0: SATA: handle(0x000e), sas_addr(0x4433221105000000), phy(5), device_name(0x5000cca369c89aa8)
> [   10.796334] scsi 0:0:5:0: SATA: enclosure_logical_id(0x500605b0026e1700), slot(6)
> [   10.796615] scsi 0:0:5:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
> [   10.796818] scsi 0:0:5:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> [   10.811014] scsi 0:0:6:0: Direct-Access     ATA      SAMSUNG HD154UI  1118 PQ: 0 ANSI: 6
> [   10.811217] scsi 0:0:6:0: SATA: handle(0x000f), sas_addr(0x4433221106000000), phy(6), device_name(0x50024e900200ccc1)
> [   10.811498] scsi 0:0:6:0: SATA: enclosure_logical_id(0x500605b0026e1700), slot(5)
> [   10.811804] scsi 0:0:6:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
> [   10.812007] scsi 0:0:6:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> [   10.825258] scsi 0:0:7:0: Direct-Access     ATA      SAMSUNG HD153WI  0003 PQ: 0 ANSI: 6
> [   10.825463] scsi 0:0:7:0: SATA: handle(0x0010), sas_addr(0x4433221107000000), phy(7), device_name(0x50024e9003557848)
> [   10.825734] scsi 0:0:7:0: SATA: enclosure_logical_id(0x500605b0026e1700), slot(4)
> [   10.826012] scsi 0:0:7:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
> [   10.826214] scsi 0:0:7:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> [   10.827342] scsi1 : Fusion MPT SAS Host
> [   10.828297] mpt2sas1: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (2046048 kB)
> [   10.829226] mpt2sas 0000:1b:00.0: irq 73 for MSI/MSI-X
> [   10.829561] mpt2sas1-msix0: PCI-MSI-X enabled: IRQ 73
> [   10.829711] mpt2sas1: iomem(0x00000000d2700000), mapped(0xffffc90000030000), size(16384)
> [   10.829903] mpt2sas1: ioport(0x0000000000007000), size(256)
> [   11.901246] mpt2sas1: Allocated physical memory: size(2267 kB)
> [   11.901428] mpt2sas1: Current Controller Queue Depth(1483), Max Controller Queue Depth(1720)
> [   11.901626] mpt2sas1: Scatter Gather Elements per IO(128)
> [   12.477927] mpt2sas1: LSISAS2008: FWVersion(15.00.00.00), ChipRevision(0x02), BiosVersion(07.29.00.00)
> [   12.478205] mpt2sas1: Protocol=(Initiator), Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
> [   12.479036] mpt2sas1: sending port enable !!
> [   14.079107] mpt2sas1: host_add: handle(0x0001), sas_addr(0x500605b0024ee080), phys(8)
> [   19.200431] mpt2sas1: port enable: SUCCESS
> [   19.205203] scsi 1:0:0:0: Direct-Access     ATA      ST3750330NS      SN06 PQ: 0 ANSI: 6
> [   19.205410] scsi 1:0:0:0: SATA: handle(0x000c), sas_addr(0x4433221102000000), phy(2), device_name(0x5000c5000266bb02)
> [   19.205684] scsi 1:0:0:0: SATA: enclosure_logical_id(0x500605b0024ee080), slot(1)
> [   19.205978] scsi 1:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
> [   19.206183] scsi 1:0:0:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> [   19.220097] scsi 1:0:1:0: Direct-Access     ATA      SAMSUNG HD154UI  1118 PQ: 0 ANSI: 6
> [   19.220308] scsi 1:0:1:0: SATA: handle(0x0009), sas_addr(0x4433221100000000), phy(0), device_name(0x50024e9002a049ef)
> [   19.220592] scsi 1:0:1:0: SATA: enclosure_logical_id(0x500605b0024ee080), slot(3)
> [   19.220903] scsi 1:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
> [   19.221109] scsi 1:0:1:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> [   19.227877] scsi 1:0:2:0: Direct-Access     ATA      WDC WD15EADS-00P 0A01 PQ: 0 ANSI: 6
> [   19.228081] scsi 1:0:2:0: SATA: handle(0x000a), sas_addr(0x4433221101000000), phy(1), device_name(0x50014ee057149fdf)
> [   19.228360] scsi 1:0:2:0: SATA: enclosure_logical_id(0x500605b0024ee080), slot(2)
> [   19.228643] scsi 1:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
> [   19.228850] scsi 1:0:2:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> [   19.230736] scsi 1:0:3:0: Direct-Access     ATA      ST3000DM001-9YN1 CC4H PQ: 0 ANSI: 6
> [   19.230936] scsi 1:0:3:0: SATA: handle(0x000b), sas_addr(0x4433221104000000), phy(4), device_name(0x5000c50046fa4ce6)
> [   19.231207] scsi 1:0:3:0: SATA: enclosure_logical_id(0x500605b0024ee080), slot(7)
> [   19.231495] scsi 1:0:3:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
> [   19.231697] scsi 1:0:3:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> [   19.235608] scsi 1:0:4:0: Direct-Access     ATA      ST3750330NS      SN06 PQ: 0 ANSI: 6
> [   19.235808] scsi 1:0:4:0: SATA: handle(0x000d), sas_addr(0x4433221103000000), phy(3), device_name(0x5000c5000267abee)
> [   19.236080] scsi 1:0:4:0: SATA: enclosure_logical_id(0x500605b0024ee080), slot(0)
> [   19.236364] scsi 1:0:4:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
> [   19.236570] scsi 1:0:4:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> [   19.238464] scsi 1:0:5:0: Direct-Access     ATA      ST3000DM001-9YN1 CC4H PQ: 0 ANSI: 6
> [   19.238664] scsi 1:0:5:0: SATA: handle(0x000e), sas_addr(0x4433221105000000), phy(5), device_name(0x5000c5004a3de1a5)
> [   19.238936] scsi 1:0:5:0: SATA: enclosure_logical_id(0x500605b0024ee080), slot(6)
> [   19.239215] scsi 1:0:5:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
> [   19.239418] scsi 1:0:5:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> [   19.253314] scsi 1:0:6:0: Direct-Access     ATA      SAMSUNG HD154UI  1118 PQ: 0 ANSI: 6
> [   19.253515] scsi 1:0:6:0: SATA: handle(0x000f), sas_addr(0x4433221106000000), phy(6), device_name(0x50024e9203fd8476)
> [   19.253789] scsi 1:0:6:0: SATA: enclosure_logical_id(0x500605b0024ee080), slot(5)
> [   19.254070] scsi 1:0:6:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
> [   19.254274] scsi 1:0:6:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> [   19.268175] scsi 1:0:7:0: Direct-Access     ATA      SAMSUNG HD154UI  1118 PQ: 0 ANSI: 6
> [   19.268377] scsi 1:0:7:0: SATA: handle(0x0010), sas_addr(0x4433221107000000), phy(7), device_name(0x50024e9002a049f7)
> [   19.268649] scsi 1:0:7:0: SATA: enclosure_logical_id(0x500605b0024ee080), slot(4)
> [   19.268930] scsi 1:0:7:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
> [   19.269132] scsi 1:0:7:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
> [   19.269975] VMware PVSCSI driver - version 1.0.2.0-k
> [   19.270191] vmw_pvscsi: using 64bit dma
> [   19.270790] vmw_pvscsi 0000:03:00.0: vmw_pvscsi: host->max_id: 16
> [   19.272186] vmw_pvscsi 0000:03:00.0: irq 74 for MSI/MSI-X
> [   19.272321] vmw_pvscsi: using MSI-X
> [   19.272521] scsi2 : VMware PVSCSI storage adapter rev 2, req/cmp/msg rings: 8/8/1 pages, cmd_per_lun=64
> [   19.273066] vmw_pvscsi 0000:03:00.0: VMware PVSCSI rev 2 host #2
> [   19.273364] scsi 2:0:0:0: Direct-Access     VMware   Virtual disk     1.0  PQ: 0 ANSI: 2
> [   19.277231] sd 0:0:4:0: [sde] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
> [   19.277601] sd 0:0:5:0: [sdf] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
> [   19.277820] sd 0:0:3:0: [sdd] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
> [   19.278731] sd 1:0:3:0: [sdl] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
> [   19.278928] sd 1:0:3:0: [sdl] 4096-byte physical blocks
> [   19.279190] sd 1:0:5:0: [sdn] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
> [   19.279286] sd 1:0:0:0: [sdi] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
> [   19.279577] sd 1:0:5:0: [sdn] 4096-byte physical blocks
> [   19.280171] sd 2:0:0:0: [sdq] 69206016 512-byte logical blocks: (35.4 GB/33.0 GiB)
> [   19.280299] sd 1:0:4:0: [sdm] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
> [   19.280598] sd 2:0:0:0: [sdq] Write Protect is off
> [   19.280742] sd 2:0:0:0: [sdq] Mode Sense: 61 00 00 00
> [   19.280772] sd 2:0:0:0: [sdq] Cache data unavailable
> [   19.280890] sd 1:0:2:0: [sdk] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
> [   19.281098] sd 2:0:0:0: [sdq] Assuming drive cache: write through
> [   19.281104] sd 0:0:0:0: [sda] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
> [   19.281516] sd 0:0:1:0: [sdb] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
> [   19.281728] sd 2:0:0:0: [sdq] Cache data unavailable
> [   19.281838] sd 2:0:0:0: [sdq] Assuming drive cache: write through
> [   19.282016] sd 0:0:2:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
> [   19.282455] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [   19.282658]  sdq: sdq1 sdq2 sdq3
> [   19.282763] sd 0:0:1:0: Attached scsi generic sg1 type 0
> [   19.282944] sd 0:0:7:0: [sdh] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
> [   19.283154] sd 0:0:2:0: Attached scsi generic sg2 type 0
> [   19.283283] sd 0:0:6:0: [sdg] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
> [   19.283324] sd 2:0:0:0: [sdq] Cache data unavailable
> [   19.283325] sd 2:0:0:0: [sdq] Assuming drive cache: write through
> [   19.283326] sd 2:0:0:0: [sdq] Attached SCSI disk
> [   19.283874] sd 0:0:3:0: Attached scsi generic sg3 type 0
> [   19.284112] sd 0:0:4:0: Attached scsi generic sg4 type 0
> [   19.284169] sd 1:0:1:0: [sdj] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
> [   19.284492] sd 0:0:5:0: Attached scsi generic sg5 type 0
> [   19.284714] sd 0:0:6:0: Attached scsi generic sg6 type 0
> [   19.284933] sd 0:0:7:0: Attached scsi generic sg7 type 0
> [   19.285165] sd 1:0:0:0: Attached scsi generic sg8 type 0
> [   19.285383] sd 1:0:1:0: Attached scsi generic sg9 type 0
> [   19.285642] sd 1:0:2:0: Attached scsi generic sg10 type 0
> [   19.285697] sd 1:0:6:0: [sdo] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
> [   19.286006] sd 1:0:3:0: Attached scsi generic sg11 type 0
> [   19.286261] sd 1:0:4:0: Attached scsi generic sg12 type 0
> [   19.286335] sd 1:0:7:0: [sdp] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
> [   19.286657] sd 1:0:5:0: Attached scsi generic sg13 type 0
> [   19.286881] sd 1:0:6:0: Attached scsi generic sg14 type 0
> [   19.287099] sd 1:0:7:0: Attached scsi generic sg15 type 0
> [   19.287331] sd 2:0:0:0: Attached scsi generic sg16 type 0
> [   19.287476] ahci 0000:0c:00.0: version 3.0
> [   19.287712] ahci 0000:0c:00.0: irq 75 for MSI/MSI-X
> [   19.287991] ahci 0000:0c:00.0: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
> [   19.288142] ahci 0000:0c:00.0: flags: 64bit ncq sntf pm led clo pio slum part ccc ems
> [   19.299087] sd 1:0:2:0: [sdk] Write Protect is off
> [   19.299200] sd 1:0:2:0: [sdk] Mode Sense: 7f 00 10 08
> [   19.305232] sd 1:0:2:0: [sdk] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   19.315594] sd 0:0:6:0: [sdg] Write Protect is off
> [   19.315737] sd 0:0:6:0: [sdg] Mode Sense: 7f 00 10 08
> [   19.315998] sd 1:0:1:0: [sdj] Write Protect is off
> [   19.316138] sd 1:0:1:0: [sdj] Mode Sense: 7f 00 10 08
> [   19.317524] sd 1:0:6:0: [sdo] Write Protect is off
> [   19.317665] sd 1:0:6:0: [sdo] Mode Sense: 7f 00 10 08
> [   19.318456] sd 1:0:7:0: [sdp] Write Protect is off
> [   19.318620] sd 1:0:7:0: [sdp] Mode Sense: 7f 00 10 08
> [   19.328347] sd 0:0:6:0: [sdg] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   19.328793] sd 1:0:1:0: [sdj] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   19.330277] sd 1:0:6:0: [sdo] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   19.331231] sd 1:0:7:0: [sdp] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   19.332466] sd 0:0:3:0: [sdd] Write Protect is off
> [   19.332608] sd 0:0:3:0: [sdd] Mode Sense: 7f 00 10 08
> [   19.334576] sd 0:0:3:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   19.344029] sd 1:0:3:0: [sdl] Write Protect is off
> [   19.344174] sd 1:0:3:0: [sdl] Mode Sense: 7f 00 10 08
> [   19.344775] sd 1:0:3:0: [sdl] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   19.345128] sd 1:0:5:0: [sdn] Write Protect is off
> [   19.345273] sd 1:0:5:0: [sdn] Mode Sense: 7f 00 10 08
> [   19.345888] sd 1:0:5:0: [sdn] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   19.346226]  sdk: unknown partition table
> [   19.375143] sd 1:0:2:0: [sdk] Attached SCSI disk
> [   19.382002] scsi3 : ahci
> [   19.382342] scsi4 : ahci
> [   19.382662] scsi5 : ahci
> [   19.383023] scsi6 : ahci
> [   19.383475] scsi7 : ahci
> [   19.383797] scsi8 : ahci
> [   19.384085] ata1: SATA max UDMA/133 abar m2048@0xd2900000 port 0xd2900100 irq 75
> [   19.384293] ata2: SATA max UDMA/133 abar m2048@0xd2900000 port 0xd2900180 irq 75
> [   19.384480] ata3: SATA max UDMA/133 abar m2048@0xd2900000 port 0xd2900200 irq 75
> [   19.384663] ata4: SATA max UDMA/133 abar m2048@0xd2900000 port 0xd2900280 irq 75
> [   19.384853] ata5: SATA max UDMA/133 abar m2048@0xd2900000 port 0xd2900300 irq 75
> [   19.385037] ata6: SATA max UDMA/133 abar m2048@0xd2900000 port 0xd2900380 irq 75
> [   19.385663] ata_piix 0000:00:07.1: version 2.13
> [   19.386697] scsi9 : ata_piix
> [   19.387047] scsi10 : ata_piix
> [   19.387332] ata7: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0x10c0 irq 14
> [   19.387507] ata8: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0x10c8 irq 15
> [   19.388339] tun: Universal TUN/TAP device driver, 1.6
> [   19.388484] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [   19.388771] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
> [   19.388948] e1000: Copyright (c) 1999-2006 Intel Corporation.
> [   19.389189] e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
> [   19.389344] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
> [   19.389960] e1000e 0000:0b:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
> [   19.390134] sd 1:0:4:0: [sdm] Write Protect is off
> [   19.390137] sd 1:0:4:0: [sdm] Mode Sense: 7f 00 10 08
> [   19.390647] e1000e 0000:0b:00.0: irq 76 for MSI/MSI-X
> [   19.392769] sd 1:0:4:0: [sdm] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   19.400907]  sdj: unknown partition table
> [   19.402162]  sdo: unknown partition table
> [   19.403861] sd 1:0:0:0: [sdi] Write Protect is off
> [   19.404003] sd 1:0:0:0: [sdi] Mode Sense: 7f 00 10 08
> [   19.406821] sd 1:0:0:0: [sdi] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   19.407909]  sdd: unknown partition table
> [   19.408375]  sdg: unknown partition table
> [   19.410291]  sdp: unknown partition table
> [   19.415858]  sdn: unknown partition table
> [   19.417595]  sdl: unknown partition table
> [   19.452160] sd 1:0:1:0: [sdj] Attached SCSI disk
> [   19.453439] sd 1:0:6:0: [sdo] Attached SCSI disk
> [   19.459709] sd 0:0:6:0: [sdg] Attached SCSI disk
> [   19.462061] sd 1:0:7:0: [sdp] Attached SCSI disk
> [   19.476509] sd 0:0:3:0: [sdd] Attached SCSI disk
> [   19.478772] sd 1:0:5:0: [sdn] Attached SCSI disk
> [   19.485975] sd 1:0:3:0: [sdl] Attached SCSI disk
> [   19.501032] sd 0:0:4:0: [sde] Write Protect is off
> [   19.501180] sd 0:0:4:0: [sde] Mode Sense: 7f 00 10 08
> [   19.502994] sd 0:0:4:0: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   19.511752]  sdm:
> [   19.514801] sd 0:0:5:0: [sdf] Write Protect is off
> [   19.514944] sd 0:0:5:0: [sdf] Mode Sense: 7f 00 10 08
> [   19.516753] sd 0:0:5:0: [sdf] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   19.551177]  sdi: unknown partition table
> [   19.588103] sd 0:0:0:0: [sda] Write Protect is off
> [   19.588251] sd 0:0:0:0: [sda] Mode Sense: 7f 00 10 08
> [   19.588688] sd 0:0:1:0: [sdb] Write Protect is off
> [   19.588830] sd 0:0:1:0: [sdb] Mode Sense: 7f 00 10 08
> [   19.589544] ata8.00: ATAPI: VMware Virtual IDE CDROM Drive, 00000001, max UDMA/33
> [   19.591861] sd 0:0:7:0: [sdh] Write Protect is off
> [   19.592357] sd 0:0:7:0: [sdh] Mode Sense: 7f 00 10 08
> [   19.596501] sd 0:0:2:0: [sdc] Write Protect is off
> [   19.596643] sd 0:0:2:0: [sdc] Mode Sense: 7f 00 10 08
> [   19.599582] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   19.600640] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   19.603926] sd 0:0:7:0: [sdh] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   19.608291] sd 0:0:2:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [   19.629455] ata8.00: configured for UDMA/33
> [   19.633760] sd 1:0:4:0: [sdm] Attached SCSI disk
> [   19.705811] sd 1:0:0:0: [sdi] Attached SCSI disk
> [   19.719140] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   19.719340] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   19.720683] ata2.00: ATA-8: ST32000542AS, CC35, max UDMA/133
> [   19.721498] ata2.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   19.722983] ata2.00: configured for UDMA/133
> [   19.729111] ata3: SATA link down (SStatus 0 SControl 300)
> [   19.729281] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   19.729458] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   19.729638] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   19.730693] ata1.00: ATA-8: ST32000542AS, CC35, max UDMA/133
> [   19.730848] ata1.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   19.731851] e1000e 0000:0b:00.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:15:17:ca:c8:35
> [   19.732050] e1000e 0000:0b:00.0 eth0: Intel(R) PRO/1000 Network Connection
> [   19.732258] e1000e 0000:0b:00.0 eth0: MAC: 7, PHY: 6, PBA No: 0070FF-0FF
> [   19.732458] ata1.00: configured for UDMA/133
> [   19.732501] VMware vmxnet3 virtual NIC driver - version 1.1.29.0-k-NAPI
> [   19.732534] # of Tx queues : 2, # of Rx queues : 2
> [   19.733086] vmxnet3 0000:13:00.0 (unregistered net_device): features: sg csum vlan jf tso tsoIPv6 lro highDMA
> [   19.741600] vmxnet3 0000:13:00.0: irq 77 for MSI/MSI-X
> [   19.741629] vmxnet3 0000:13:00.0: irq 78 for MSI/MSI-X
> [   19.741656] vmxnet3 0000:13:00.0: irq 79 for MSI/MSI-X
> [   19.741801] RSS is enabled.
> [   19.741896]  sde: unknown partition table
> [   19.742231] eth1: NIC Link is Up 10000 Mbps
> [   19.742274] Fusion MPT base driver 3.04.20
> [   19.742274] Copyright (c) 1999-2008 LSI Corporation
> [   19.742289] Fusion MPT SAS Host driver 3.04.20
> [   19.742334] Fusion MPT misc device (ioctl) driver 3.04.20
> [   19.742383] mptctl: Registered with Fusion MPT base driver
> [   19.742384] mptctl: /dev/mptctl @ (major,minor=10,220)
> [   19.742394] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [   19.742395] ehci-pci: EHCI PCI platform driver
> [   19.742428] uhci_hcd: USB Universal Host Controller Interface driver
> [   19.742468] Initializing USB Mass Storage driver...
> [   19.742501] usbcore: registered new interface driver usb-storage
> [   19.742501] USB Mass Storage support registered.
> [   19.742526] usbcore: registered new interface driver ums-cypress
> [   19.742606] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUS] at 0x60,0x64 irq 1,12
> [   19.743493] serio: i8042 KBD port at 0x60,0x64 irq 1
> [   19.743496] serio: i8042 AUX port at 0x60,0x64 irq 12
> [   19.743690] mousedev: PS/2 mouse device common for all mice
> [   19.743871] i2c /dev entries driver
> [   19.744103] piix4_smbus 0000:00:07.3: Host SMBus controller not enabled!
> [   19.744730] scsi 3:0:0:0: Direct-Access     ATA      ST32000542AS     CC35 PQ: 0 ANSI: 5
> [   19.744756] md: raid1 personality registered for level 1
> [   19.744757] md: raid6 personality registered for level 6
> [   19.744757] md: raid5 personality registered for level 5
> [   19.744758] md: raid4 personality registered for level 4
> [   19.744759] EDAC MC: Ver: 3.0.0
> [   19.745573] sd 3:0:0:0: [sdr] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
> [   19.745753] sd 3:0:0:0: [sdr] Write Protect is off
> [   19.745859] sd 3:0:0:0: [sdr] Mode Sense: 00 3a 00 00
> [   19.745876] sd 3:0:0:0: [sdr] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   19.746230] sd 3:0:0:0: Attached scsi generic sg17 type 0
> [   19.746517] scsi 4:0:0:0: Direct-Access     ATA      ST32000542AS     CC35 PQ: 0 ANSI: 5
> [   19.746614] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [   19.746660] cpuidle: using governor ladder
> [   19.746661] cpuidle: using governor menu
> [   19.747131] usbcore: registered new interface driver usbhid
> [   19.747251] usbhid: USB HID core driver
> [   19.748318]  sdf: unknown partition table
> [   19.749130] ata6.00: ATA-8: ST3500320NS, SN16, max UDMA/133
> [   19.749285] ata6.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   19.750610] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input2
> [   19.750615] TCP: bic registered
> [   19.750616] TCP: cubic registered
> [   19.750617] TCP: vegas registered
> [   19.750617] TCP: yeah registered
> [   19.750618] Initializing XFRM netlink socket
> [   19.750624] NET: Registered protocol family 17
> [   19.750642] 8021q: 802.1Q VLAN Support v1.8
> [   19.750656] Key type dns_resolver registered
> [   19.751544] sd 4:0:0:0: [sds] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
> [   19.751757] sd 4:0:0:0: [sds] Write Protect is off
> [   19.751799] sd 4:0:0:0: Attached scsi generic sg18 type 0
> [   19.751979] sd 4:0:0:0: [sds] Mode Sense: 00 3a 00 00
> [   19.752027] sd 4:0:0:0: [sds] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   19.752337] registered taskstats version 1
> [   19.758792] ata5.00: ATA-8: ST3750330NS, SN06, max UDMA/133
> [   19.758937] ata5.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   19.759108] ata4.00: ATA-8: ST3750330NS, SN06, max UDMA/133
> [   19.759230] ata4.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   19.791666] ata6.00: configured for UDMA/133
> [   19.797724]  sds: unknown partition table
> [   19.798357] sd 4:0:0:0: [sds] Attached SCSI disk
> [   19.799055]  sdr: unknown partition table
> [   19.799585] sd 3:0:0:0: [sdr] Attached SCSI disk
> [   19.801628] ata5.00: configured for UDMA/133
> [   19.801802] ata4.00: configured for UDMA/133
> [   19.802090] scsi 6:0:0:0: Direct-Access     ATA      ST3750330NS      SN06 PQ: 0 ANSI: 5
> [   19.802686] sd 6:0:0:0: [sdt] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
> [   19.803020] sd 6:0:0:0: [sdt] Write Protect is off
> [   19.803165] sd 6:0:0:0: [sdt] Mode Sense: 00 3a 00 00
> [   19.803194] sd 6:0:0:0: Attached scsi generic sg19 type 0
> [   19.803215] sd 6:0:0:0: [sdt] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   19.803925] scsi 7:0:0:0: Direct-Access     ATA      ST3750330NS      SN06 PQ: 0 ANSI: 5
> [   19.804553] sd 7:0:0:0: [sdu] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
> [   19.804639] sd 7:0:0:0: Attached scsi generic sg20 type 0
> [   19.804999] scsi 8:0:0:0: Direct-Access     ATA      ST3500320NS      SN16 PQ: 0 ANSI: 5
> [   19.805014] sd 7:0:0:0: [sdu] Write Protect is off
> [   19.805017] sd 7:0:0:0: [sdu] Mode Sense: 00 3a 00 00
> [   19.805036] sd 7:0:0:0: [sdu] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   19.805959] sd 8:0:0:0: [sdv] 976773168 512-byte logical blocks: (500 GB/465 GiB)
> [   19.806211] sd 8:0:0:0: [sdv] Write Protect is off
> [   19.806220] sd 8:0:0:0: Attached scsi generic sg21 type 0
> [   19.806495] sd 8:0:0:0: [sdv] Mode Sense: 00 3a 00 00
> [   19.806539] sd 8:0:0:0: [sdv] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   19.807130] scsi 10:0:0:0: CD-ROM            NECVMWar VMware IDE CDR10 1.00 PQ: 0 ANSI: 5
> [   19.809083] sr0: scsi3-mmc drive: 1x/1x writer dvd-ram cd/rw xa/form2 cdda tray
> [   19.809284] cdrom: Uniform CD-ROM driver Revision: 3.20
> [   19.809794] sr 10:0:0:0: Attached scsi CD-ROM sr0
> [   19.810164] sr 10:0:0:0: Attached scsi generic sg22 type 5
> [   19.813547]  sdt: unknown partition table
> [   19.814194] sd 6:0:0:0: [sdt] Attached SCSI disk
> [   19.823844]  sdv: sdv1
> [   19.824627] sd 8:0:0:0: [sdv] Attached SCSI disk
> [   19.847128]  sdu: sdu1 sdu2 sdu3
> [   19.848390] sd 7:0:0:0: [sdu] Attached SCSI disk
> [   19.917359]  sda: unknown partition table
> [   19.917940]  sdb: unknown partition table
> [   19.921111]  sdh: unknown partition table
> [   19.925746]  sdc: unknown partition table
> [   19.966367] sd 0:0:4:0: [sde] Attached SCSI disk
> [   19.980097] sd 0:0:5:0: [sdf] Attached SCSI disk
> [   20.227232] sd 0:0:0:0: [sda] Attached SCSI disk
> [   20.228288] sd 0:0:1:0: [sdb] Attached SCSI disk
> [   20.231223] sd 0:0:7:0: [sdh] Attached SCSI disk
> [   20.235942] sd 0:0:2:0: [sdc] Attached SCSI disk
> [   20.243382] Freeing unused kernel memory: 5012k freed
> [   21.313504] fuse init (API version 7.20)
> [   27.072949] kjournald starting.  Commit interval 5 seconds
> [   27.072995] EXT3-fs (sdq3): mounted filesystem with writeback data mode
> [   29.699661] systemd-udevd[3525]: starting version 200
> [   30.203054] systemd-udevd[3543]: renamed network interface eth1 to lan1
> [   30.242859] systemd-udevd[3546]: renamed network interface eth0 to lan0
> [   31.866077] md: md1 stopped.
> [   31.869556] md: bind<sdn>
> [   31.869696] md: bind<sdl>
> [   31.869708] md: kicking non-fresh sdn from array!
> [   31.869711] md: unbind<sdn>
> [   31.918575] md: export_rdev(sdn)
> [   31.939625] md/raid1:md1: active with 1 out of 2 mirrors
> [   31.939663] md1: detected capacity change from 0 to 3000591933440
> [   31.942756]  md1: unknown partition table
> [   31.946230] md: md2 stopped.
> [   31.947422] md: bind<sdg>
> [   31.947567] md: bind<sdh>
> [   31.951433] md/raid1:md2: active with 2 out of 2 mirrors
> [   31.951457] md2: detected capacity change from 0 to 1500300861440
> [   31.954741] md: md3 stopped.
> [   31.955320] md: bind<sdf>
> [   31.955428] md: bind<sde>
> [   31.955440] md: kicking non-fresh sdf from array!
> [   31.955443] md: unbind<sdf>
> [   31.965514]  md2: unknown partition table
> [   32.008360] md: export_rdev(sdf)
> [   32.010465] md/raid1:md3: active with 1 out of 2 mirrors
> [   32.010494] md3: detected capacity change from 0 to 2000397746176
> [   32.033057]  md3: unknown partition table
> [   32.042643] md: md5 stopped.
> [   32.043387] md: bind<sda>
> [   32.043632] md: bind<sdd>
> [   32.046110] md/raid1:md5: active with 2 out of 2 mirrors
> [   32.046137] md5: detected capacity change from 0 to 1500300722176
> [   32.050165] md: md6 stopped.
> [   32.051161] md: bind<sdt>
> [   32.053964] md/raid1:md6: active with 1 out of 2 mirrors
> [   32.053979] md6: detected capacity change from 0 to 750155186176
> [   32.057422] md: md7 stopped.
> [   32.057957] md: bind<sdb>
> [   32.058070] md: bind<sdc>
> [   32.059649]  md6: unknown partition table
> [   32.064274] md/raid1:md7: active with 2 out of 2 mirrors
> [   32.064296] md7: detected capacity change from 0 to 2000397746176
> [   32.066581] md: md8 stopped.
> [   32.067231] md: bind<sdo>
> [   32.067375] md: bind<sdk>
> [   32.069419]  md5: unknown partition table
> [   32.072742] md/raid1:md8: active with 2 out of 2 mirrors
> [   32.072759] md8: detected capacity change from 0 to 1500300722176
> [   32.074794] md: md9 stopped.
> [   32.075536] md: bind<sds>
> [   32.075682] md: bind<sdr>
> [   32.080667]  md7: unknown partition table
> [   32.087598] md/raid1:md9: active with 2 out of 2 mirrors
> [   32.087616] md9: detected capacity change from 0 to 2000397746176
> [   32.089452] md: md10 stopped.
> [   32.090898] md: bind<sdm>
> [   32.091091]  md8: unknown partition table
> [   32.091346] md: bind<sdi>
> [   32.099606]  md9: unknown partition table
> [   32.105237] md/raid1:md10: active with 2 out of 2 mirrors
> [   32.105257] md10: detected capacity change from 0 to 750155186176
> [   32.106611] md: md11 stopped.
> [   32.107394] md: bind<sdp>
> [   32.107523] md: bind<sdj>
> [   32.113077]  md10: unknown partition table
> [   32.118190] md/raid1:md11: active with 2 out of 2 mirrors
> [   32.118209] md11: detected capacity change from 0 to 1500300722176
> [   32.142907]  md11: unknown partition table
> [   34.370261] EXT3-fs (sdq3): using internal journal
> [   34.864750] Adding 8385924k swap on /dev/sdq2.  Priority:-1 extents:1 across:8385924k
> [   35.121453] EXT4-fs (md1): mounted filesystem with writeback data mode. Opts: journal_async_commit,commit=15
> [   35.194966] EXT4-fs (md2): mounted filesystem with writeback data mode. Opts: journal_async_commit,commit=15
> [   35.236842] EXT4-fs (md3): mounted filesystem with writeback data mode. Opts: journal_async_commit,commit=15
> [   35.295148] EXT4-fs (md5): mounted filesystem with writeback data mode. Opts: journal_async_commit,commit=15
> [   35.336072] EXT4-fs (md6): mounted filesystem with writeback data mode. Opts: journal_async_commit,commit=15
> [   35.412323] EXT4-fs (md7): mounted filesystem with writeback data mode. Opts: journal_async_commit,commit=15
> [   35.456402] EXT4-fs (md8): mounted filesystem with writeback data mode. Opts: journal_async_commit,commit=15
> [   35.540471] EXT4-fs (md9): mounted filesystem with writeback data mode. Opts: journal_async_commit,commit=15
> [   35.604302] EXT4-fs (md10): mounted filesystem with writeback data mode. Opts: journal_async_commit,commit=15
> [   35.675730] EXT4-fs (md11): mounted filesystem with writeback data mode. Opts: journal_async_commit,commit=15
> [   35.689768] EXT4-fs (sdv1): mounted filesystem with writeback data mode. Opts: journal_async_commit,commit=60
> [   42.275101] lan1: intr type 3, mode 0, 3 vectors allocated
> [   42.275889] lan1: NIC Link is Up 10000 Mbps
> [   42.276330] 8021q: adding VLAN 0 to HW filter on device lan1
> [   42.927309] device lan1 entered promiscuous mode
> [   42.949866] device tap0 entered promiscuous mode
> [   42.973319] device tap1 entered promiscuous mode
> [   42.995714] device tap2 entered promiscuous mode
> [   43.015868] device tap3 entered promiscuous mode
> [   43.027467] device br0 entered promiscuous mode
> [   43.030903] br0: port 1(lan1) entered forwarding state
> [   43.030908] br0: port 1(lan1) entered forwarding state
> [   43.951195] e1000e 0000:0b:00.0: irq 76 for MSI/MSI-X
> [   44.058455] e1000e 0000:0b:00.0: irq 76 for MSI/MSI-X
> [   46.772200] e1000e: lan0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
> [   58.013152] br0: port 1(lan1) entered forwarding state
> [  105.358588] br0: port 2(tap0) entered forwarding state
> [  105.358605] br0: port 2(tap0) entered forwarding state
> [  105.458772] br0: port 3(tap1) entered forwarding state
> [  105.458787] br0: port 3(tap1) entered forwarding state
> [  105.572746] br0: port 4(tap2) entered forwarding state
> [  105.572762] br0: port 4(tap2) entered forwarding state
> [  105.698660] br0: port 5(tap3) entered forwarding state
> [  105.698677] br0: port 5(tap3) entered forwarding state
> [  120.337182] br0: port 2(tap0) entered forwarding state
> [  120.466855] br0: port 3(tap1) entered forwarding state
> [  120.536672] br0: port 4(tap2) entered forwarding state
> [  120.696297] br0: port 5(tap3) entered forwarding state
> [86758.017995] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86758.165543] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86758.414850] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86759.163021] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86759.412376] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86759.661760] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86759.661791] sd 0:0:4:0: [sde] Unhandled error code
> [86759.661793] sd 0:0:4:0: [sde]
> [86759.661795] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [86759.661797] sd 0:0:4:0: [sde] CDB:
> [86759.661798] Write(10): 2a 00 05 c2 2e 70 00 02 00 00
> [86759.661806] end_request: I/O error, dev sde, sector 96611952
> [86759.661882] Buffer I/O error on device md3, logical block 12076238
> [86759.661890] Buffer I/O error on device md3, logical block 12076239
> [86759.661892] Buffer I/O error on device md3, logical block 12076240
> [86759.661894] Buffer I/O error on device md3, logical block 12076241
> [86759.661895] Buffer I/O error on device md3, logical block 12076242
> [86759.661897] Buffer I/O error on device md3, logical block 12076243
> [86759.661899] Buffer I/O error on device md3, logical block 12076244
> [86759.661901] Buffer I/O error on device md3, logical block 12076245
> [86759.661902] Buffer I/O error on device md3, logical block 12076246
> [86759.661904] Buffer I/O error on device md3, logical block 12076247
> [86759.661906] Buffer I/O error on device md3, logical block 12076248
> [86759.661907] Buffer I/O error on device md3, logical block 12076249
> [86759.661909] Buffer I/O error on device md3, logical block 12076250
> [86759.661911] Buffer I/O error on device md3, logical block 12076251
> [86759.661912] Buffer I/O error on device md3, logical block 12076252
> [86759.661914] Buffer I/O error on device md3, logical block 12076253
> [86759.661916] Buffer I/O error on device md3, logical block 12076254
> [86759.661917] Buffer I/O error on device md3, logical block 12076255
> [86759.661919] Buffer I/O error on device md3, logical block 12076256
> [86759.661921] Buffer I/O error on device md3, logical block 12076257
> [86759.661922] Buffer I/O error on device md3, logical block 12076258
> [86759.661924] Buffer I/O error on device md3, logical block 12076259
> [86759.661926] Buffer I/O error on device md3, logical block 12076260
> [86759.661927] Buffer I/O error on device md3, logical block 12076261
> [86759.661929] Buffer I/O error on device md3, logical block 12076262
> [86759.661931] Buffer I/O error on device md3, logical block 12076263
> [86759.661932] Buffer I/O error on device md3, logical block 12076264
> [86759.661934] Buffer I/O error on device md3, logical block 12076265
> [86759.661936] Buffer I/O error on device md3, logical block 12076266
> [86759.661937] Buffer I/O error on device md3, logical block 12076267
> [86759.661939] Buffer I/O error on device md3, logical block 12076268
> [86759.661941] Buffer I/O error on device md3, logical block 12076269
> [86759.661942] Buffer I/O error on device md3, logical block 12076270
> [86759.661944] Buffer I/O error on device md3, logical block 12076271
> [86759.661945] Buffer I/O error on device md3, logical block 12076272
> [86759.661947] Buffer I/O error on device md3, logical block 12076273
> [86759.661949] Buffer I/O error on device md3, logical block 12076274
> [86759.661950] Buffer I/O error on device md3, logical block 12076275
> [86759.661952] Buffer I/O error on device md3, logical block 12076276
> [86759.661953] Buffer I/O error on device md3, logical block 12076277
> [86759.661955] Buffer I/O error on device md3, logical block 12076278
> [86759.661957] Buffer I/O error on device md3, logical block 12076279
> [86759.661958] Buffer I/O error on device md3, logical block 12076280
> [86759.661960] Buffer I/O error on device md3, logical block 12076281
> [86759.661964] Buffer I/O error on device md3, logical block 12076282
> [86759.661966] Buffer I/O error on device md3, logical block 12076283
> [86759.661968] Buffer I/O error on device md3, logical block 12076284
> [86759.661970] Buffer I/O error on device md3, logical block 12076285
> [86759.661971] Buffer I/O error on device md3, logical block 12076286
> [86759.661973] Buffer I/O error on device md3, logical block 12076287
> [86759.661974] Buffer I/O error on device md3, logical block 12076288
> [86759.661976] Buffer I/O error on device md3, logical block 12076289
> [86759.661978] Buffer I/O error on device md3, logical block 12076290
> [86759.661979] Buffer I/O error on device md3, logical block 12076291
> [86759.661981] Buffer I/O error on device md3, logical block 12076292
> [86759.661983] Buffer I/O error on device md3, logical block 12076293
> [86759.661987] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673461 (offset 3932160 size 229376 starting block 12076238)
> [86759.661992] Buffer I/O error on device md3, logical block 12076294
> [86759.661995] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673461 (offset 4161536 size 4096 starting block 12076294)
> [86759.662031] md3: WRITE SAME failed. Manually zeroing.
> [86760.444396] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86760.444400] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86760.647412] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86760.907193] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86761.655337] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86761.914658] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86762.154091] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86762.154108] sd 0:0:4:0: [sde] Unhandled error code
> [86762.154110] sd 0:0:4:0: [sde]
> [86762.154112] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [86762.154114] sd 0:0:4:0: [sde] CDB:
> [86762.154115] Write(10): 2a 00 05 c1 1f f8 00 00 08 00
> [86762.154123] end_request: I/O error, dev sde, sector 96542712
> [86762.154193] md3: WRITE SAME failed. Manually zeroing.
> [86762.931541] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86762.931561] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86762.931564] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86763.142072] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86763.142075] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86763.404021] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86764.180162] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86764.399424] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86764.648819] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86765.396994] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86765.646332] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86765.905702] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86765.905719] sd 0:0:4:0: [sde] Unhandled error code
> [86765.905721] sd 0:0:4:0: [sde]
> [86765.905723] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [86765.905725] sd 0:0:4:0: [sde] CDB:
> [86765.905726] Write(10): 2a 00 05 c1 14 a0 00 00 48 00
> [86765.905734] end_request: I/O error, dev sde, sector 96539808
> [86765.905808] Buffer I/O error on device md3, logical block 12067220
> [86765.905823] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673461 (offset 6258688 size 4096 starting block 12067220)
> [86765.905854] md3: WRITE SAME failed. Manually zeroing.
> [86766.659369] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86766.659375] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86766.659377] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86766.896938] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86767.142586] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86767.900709] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86768.140086] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86768.389476] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86768.389494] sd 0:0:4:0: [sde] Unhandled error code
> [86768.389496] sd 0:0:4:0: [sde]
> [86768.389497] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [86768.389499] sd 0:0:4:0: [sde] CDB:
> [86768.389500] Write(10): 2a 00 05 c1 3b 08 00 00 48 00
> [86768.389508] end_request: I/O error, dev sde, sector 96549640
> [86768.389564] Buffer I/O error on device md3, logical block 12068449
> [86768.389573] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673461 (offset 7307264 size 4096 starting block 12068449)
> [86768.389596] md3: WRITE SAME failed. Manually zeroing.
> [86769.166249] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86769.387007] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86769.636335] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86770.384461] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86770.633850] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86770.893236] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86770.893253] sd 0:0:4:0: [sde] Unhandled error code
> [86770.893255] sd 0:0:4:0: [sde]
> [86770.893256] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [86770.893258] sd 0:0:4:0: [sde] CDB:
> [86770.893260] Write(10): 2a 00 05 c1 3b 50 00 00 48 00
> [86770.893268] end_request: I/O error, dev sde, sector 96549712
> [86770.893327] Buffer I/O error on device md3, logical block 12068458
> [86770.893337] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673461 (offset 8355840 size 4096 starting block 12068458)
> [86770.893360] md3: WRITE SAME failed. Manually zeroing.
> [86891.366844] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86891.591910] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86891.841255] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86892.589431] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86892.838819] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86893.088175] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86893.088191] sd 0:0:4:0: [sde] Unhandled error code
> [86893.088193] sd 0:0:4:0: [sde]
> [86893.088195] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [86893.088197] sd 0:0:4:0: [sde] CDB:
> [86893.088198] Write(10): 2a 00 06 42 0a b0 00 03 48 00
> [86893.088206] end_request: I/O error, dev sde, sector 104991408
> [86893.088264] Buffer I/O error on device md3, logical block 13123670
> [86893.088270] Buffer I/O error on device md3, logical block 13123671
> [86893.088272] Buffer I/O error on device md3, logical block 13123672
> [86893.088273] Buffer I/O error on device md3, logical block 13123673
> [86893.088284] Buffer I/O error on device md3, logical block 13123674
> [86893.088286] Buffer I/O error on device md3, logical block 13123675
> [86893.088288] Buffer I/O error on device md3, logical block 13123676
> [86893.088290] Buffer I/O error on device md3, logical block 13123677
> [86893.088292] Buffer I/O error on device md3, logical block 13123678
> [86893.088293] Buffer I/O error on device md3, logical block 13123679
> [86893.088295] Buffer I/O error on device md3, logical block 13123680
> [86893.088297] Buffer I/O error on device md3, logical block 13123681
> [86893.088298] Buffer I/O error on device md3, logical block 13123682
> [86893.088300] Buffer I/O error on device md3, logical block 13123683
> [86893.088302] Buffer I/O error on device md3, logical block 13123684
> [86893.088303] Buffer I/O error on device md3, logical block 13123685
> [86893.088305] Buffer I/O error on device md3, logical block 13123686
> [86893.088307] Buffer I/O error on device md3, logical block 13123687
> [86893.088308] Buffer I/O error on device md3, logical block 13123688
> [86893.088310] Buffer I/O error on device md3, logical block 13123689
> [86893.088312] Buffer I/O error on device md3, logical block 13123690
> [86893.088314] Buffer I/O error on device md3, logical block 13123691
> [86893.088315] Buffer I/O error on device md3, logical block 13123692
> [86893.088317] Buffer I/O error on device md3, logical block 13123693
> [86893.088319] Buffer I/O error on device md3, logical block 13123694
> [86893.088320] Buffer I/O error on device md3, logical block 13123695
> [86893.088322] Buffer I/O error on device md3, logical block 13123696
> [86893.088324] Buffer I/O error on device md3, logical block 13123697
> [86893.088325] Buffer I/O error on device md3, logical block 13123698
> [86893.088327] Buffer I/O error on device md3, logical block 13123699
> [86893.088328] Buffer I/O error on device md3, logical block 13123700
> [86893.088330] Buffer I/O error on device md3, logical block 13123701
> [86893.088331] Buffer I/O error on device md3, logical block 13123702
> [86893.088333] Buffer I/O error on device md3, logical block 13123703
> [86893.088334] Buffer I/O error on device md3, logical block 13123704
> [86893.088336] Buffer I/O error on device md3, logical block 13123705
> [86893.088338] Buffer I/O error on device md3, logical block 13123706
> [86893.088340] Buffer I/O error on device md3, logical block 13123707
> [86893.088341] Buffer I/O error on device md3, logical block 13123708
> [86893.088343] Buffer I/O error on device md3, logical block 13123709
> [86893.088345] Buffer I/O error on device md3, logical block 13123710
> [86893.088347] Buffer I/O error on device md3, logical block 13123711
> [86893.088348] Buffer I/O error on device md3, logical block 13123712
> [86893.088350] Buffer I/O error on device md3, logical block 13123713
> [86893.088352] Buffer I/O error on device md3, logical block 13123714
> [86893.088353] Buffer I/O error on device md3, logical block 13123715
> [86893.088355] Buffer I/O error on device md3, logical block 13123716
> [86893.088356] Buffer I/O error on device md3, logical block 13123717
> [86893.088358] Buffer I/O error on device md3, logical block 13123718
> [86893.088359] Buffer I/O error on device md3, logical block 13123719
> [86893.088361] Buffer I/O error on device md3, logical block 13123720
> [86893.088362] Buffer I/O error on device md3, logical block 13123721
> [86893.088364] Buffer I/O error on device md3, logical block 13123722
> [86893.088366] Buffer I/O error on device md3, logical block 13123723
> [86893.088367] Buffer I/O error on device md3, logical block 13123724
> [86893.088369] Buffer I/O error on device md3, logical block 13123725
> [86893.088371] Buffer I/O error on device md3, logical block 13123726
> [86893.088372] Buffer I/O error on device md3, logical block 13123727
> [86893.088374] Buffer I/O error on device md3, logical block 13123728
> [86893.088376] Buffer I/O error on device md3, logical block 13123729
> [86893.088377] Buffer I/O error on device md3, logical block 13123730
> [86893.088382] Buffer I/O error on device md3, logical block 13123731
> [86893.088384] Buffer I/O error on device md3, logical block 13123732
> [86893.088386] Buffer I/O error on device md3, logical block 13123733
> [86893.088387] Buffer I/O error on device md3, logical block 13123734
> [86893.088389] Buffer I/O error on device md3, logical block 13123735
> [86893.088390] Buffer I/O error on device md3, logical block 13123736
> [86893.088392] Buffer I/O error on device md3, logical block 13123737
> [86893.088394] Buffer I/O error on device md3, logical block 13123738
> [86893.088395] Buffer I/O error on device md3, logical block 13123739
> [86893.088397] Buffer I/O error on device md3, logical block 13123740
> [86893.088399] Buffer I/O error on device md3, logical block 13123741
> [86893.088400] Buffer I/O error on device md3, logical block 13123742
> [86893.088402] Buffer I/O error on device md3, logical block 13123743
> [86893.088403] Buffer I/O error on device md3, logical block 13123744
> [86893.088405] Buffer I/O error on device md3, logical block 13123745
> [86893.088407] Buffer I/O error on device md3, logical block 13123746
> [86893.088408] Buffer I/O error on device md3, logical block 13123747
> [86893.088410] Buffer I/O error on device md3, logical block 13123748
> [86893.088412] Buffer I/O error on device md3, logical block 13123749
> [86893.088413] Buffer I/O error on device md3, logical block 13123750
> [86893.088415] Buffer I/O error on device md3, logical block 13123751
> [86893.088417] Buffer I/O error on device md3, logical block 13123752
> [86893.088418] Buffer I/O error on device md3, logical block 13123753
> [86893.088420] Buffer I/O error on device md3, logical block 13123754
> [86893.088421] Buffer I/O error on device md3, logical block 13123755
> [86893.088423] Buffer I/O error on device md3, logical block 13123756
> [86893.088425] Buffer I/O error on device md3, logical block 13123757
> [86893.088426] Buffer I/O error on device md3, logical block 13123758
> [86893.088428] Buffer I/O error on device md3, logical block 13123759
> [86893.088429] Buffer I/O error on device md3, logical block 13123760
> [86893.088431] Buffer I/O error on device md3, logical block 13123761
> [86893.088432] Buffer I/O error on device md3, logical block 13123762
> [86893.088434] Buffer I/O error on device md3, logical block 13123763
> [86893.088436] Buffer I/O error on device md3, logical block 13123764
> [86893.088437] Buffer I/O error on device md3, logical block 13123765
> [86893.088441] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673461 (offset 9011200 size 393216 starting block 13123670)
> [86893.088447] Buffer I/O error on device md3, logical block 13123766
> [86893.088450] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673461 (offset 9404416 size 4096 starting block 13123766)
> [86893.088475] md3: WRITE SAME failed. Manually zeroing.
> [86893.860199] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86894.084839] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86894.334252] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86895.082384] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86895.331712] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86895.581115] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86895.581132] sd 0:0:4:0: [sde] Unhandled error code
> [86895.581134] sd 0:0:4:0: [sde]
> [86895.581135] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [86895.581137] sd 0:0:4:0: [sde] CDB:
> [86895.581139] Write(10): 2a 00 06 42 11 f8 00 04 00 00
> [86895.581146] end_request: I/O error, dev sde, sector 104993272
> [86895.581211] Buffer I/O error on device md3, logical block 13123903
> [86895.581218] Buffer I/O error on device md3, logical block 13123904
> [86895.581231] Buffer I/O error on device md3, logical block 13123905
> [86895.581233] Buffer I/O error on device md3, logical block 13123906
> [86895.581235] Buffer I/O error on device md3, logical block 13123907
> [86895.581237] Buffer I/O error on device md3, logical block 13123908
> [86895.581239] Buffer I/O error on device md3, logical block 13123909
> [86895.581241] Buffer I/O error on device md3, logical block 13123910
> [86895.581243] Buffer I/O error on device md3, logical block 13123911
> [86895.581244] Buffer I/O error on device md3, logical block 13123912
> [86895.581246] Buffer I/O error on device md3, logical block 13123913
> [86895.581247] Buffer I/O error on device md3, logical block 13123914
> [86895.581249] Buffer I/O error on device md3, logical block 13123915
> [86895.581251] Buffer I/O error on device md3, logical block 13123916
> [86895.581253] Buffer I/O error on device md3, logical block 13123917
> [86895.581255] Buffer I/O error on device md3, logical block 13123918
> [86895.581256] Buffer I/O error on device md3, logical block 13123919
> [86895.581258] Buffer I/O error on device md3, logical block 13123920
> [86895.581260] Buffer I/O error on device md3, logical block 13123921
> [86895.581262] Buffer I/O error on device md3, logical block 13123922
> [86895.581263] Buffer I/O error on device md3, logical block 13123923
> [86895.581265] Buffer I/O error on device md3, logical block 13123924
> [86895.581267] Buffer I/O error on device md3, logical block 13123925
> [86895.581269] Buffer I/O error on device md3, logical block 13123926
> [86895.581270] Buffer I/O error on device md3, logical block 13123927
> [86895.581272] Buffer I/O error on device md3, logical block 13123928
> [86895.581274] Buffer I/O error on device md3, logical block 13123929
> [86895.581275] Buffer I/O error on device md3, logical block 13123930
> [86895.581277] Buffer I/O error on device md3, logical block 13123931
> [86895.581279] Buffer I/O error on device md3, logical block 13123932
> [86895.581280] Buffer I/O error on device md3, logical block 13123933
> [86895.581282] Buffer I/O error on device md3, logical block 13123934
> [86895.581284] Buffer I/O error on device md3, logical block 13123935
> [86895.581286] Buffer I/O error on device md3, logical block 13123936
> [86895.581287] Buffer I/O error on device md3, logical block 13123937
> [86895.581289] Buffer I/O error on device md3, logical block 13123938
> [86895.581291] Buffer I/O error on device md3, logical block 13123939
> [86895.581292] Buffer I/O error on device md3, logical block 13123940
> [86895.581294] Buffer I/O error on device md3, logical block 13123941
> [86895.581296] Buffer I/O error on device md3, logical block 13123942
> [86895.581298] Buffer I/O error on device md3, logical block 13123943
> [86895.581299] Buffer I/O error on device md3, logical block 13123944
> [86895.581301] Buffer I/O error on device md3, logical block 13123945
> [86895.581303] Buffer I/O error on device md3, logical block 13123946
> [86895.581304] Buffer I/O error on device md3, logical block 13123947
> [86895.581306] Buffer I/O error on device md3, logical block 13123948
> [86895.581308] Buffer I/O error on device md3, logical block 13123949
> [86895.581310] Buffer I/O error on device md3, logical block 13123950
> [86895.581312] Buffer I/O error on device md3, logical block 13123951
> [86895.581313] Buffer I/O error on device md3, logical block 13123952
> [86895.581315] Buffer I/O error on device md3, logical block 13123953
> [86895.581316] Buffer I/O error on device md3, logical block 13123954
> [86895.581318] Buffer I/O error on device md3, logical block 13123955
> [86895.581320] Buffer I/O error on device md3, logical block 13123956
> [86895.581322] Buffer I/O error on device md3, logical block 13123957
> [86895.581323] Buffer I/O error on device md3, logical block 13123958
> [86895.581325] Buffer I/O error on device md3, logical block 13123959
> [86895.581327] Buffer I/O error on device md3, logical block 13123960
> [86895.581328] Buffer I/O error on device md3, logical block 13123961
> [86895.581332] Buffer I/O error on device md3, logical block 13123962
> [86895.581335] Buffer I/O error on device md3, logical block 13123963
> [86895.581337] Buffer I/O error on device md3, logical block 13123964
> [86895.581338] Buffer I/O error on device md3, logical block 13123965
> [86895.581340] Buffer I/O error on device md3, logical block 13123966
> [86895.581342] Buffer I/O error on device md3, logical block 13123967
> [86895.581344] Buffer I/O error on device md3, logical block 13123968
> [86895.581346] Buffer I/O error on device md3, logical block 13123969
> [86895.581348] Buffer I/O error on device md3, logical block 13123970
> [86895.581349] Buffer I/O error on device md3, logical block 13123971
> [86895.581351] Buffer I/O error on device md3, logical block 13123972
> [86895.581353] Buffer I/O error on device md3, logical block 13123973
> [86895.581355] Buffer I/O error on device md3, logical block 13123974
> [86895.581357] Buffer I/O error on device md3, logical block 13123975
> [86895.581358] Buffer I/O error on device md3, logical block 13123976
> [86895.581360] Buffer I/O error on device md3, logical block 13123977
> [86895.581362] Buffer I/O error on device md3, logical block 13123978
> [86895.581363] Buffer I/O error on device md3, logical block 13123979
> [86895.581365] Buffer I/O error on device md3, logical block 13123980
> [86895.581367] Buffer I/O error on device md3, logical block 13123981
> [86895.581369] Buffer I/O error on device md3, logical block 13123982
> [86895.581370] Buffer I/O error on device md3, logical block 13123983
> [86895.581372] Buffer I/O error on device md3, logical block 13123984
> [86895.581374] Buffer I/O error on device md3, logical block 13123985
> [86895.581376] Buffer I/O error on device md3, logical block 13123986
> [86895.581377] Buffer I/O error on device md3, logical block 13123987
> [86895.581379] Buffer I/O error on device md3, logical block 13123988
> [86895.581380] Buffer I/O error on device md3, logical block 13123989
> [86895.581382] Buffer I/O error on device md3, logical block 13123990
> [86895.581384] Buffer I/O error on device md3, logical block 13123991
> [86895.581385] Buffer I/O error on device md3, logical block 13123992
> [86895.581387] Buffer I/O error on device md3, logical block 13123993
> [86895.581389] Buffer I/O error on device md3, logical block 13123994
> [86895.581390] Buffer I/O error on device md3, logical block 13123995
> [86895.581392] Buffer I/O error on device md3, logical block 13123996
> [86895.581393] Buffer I/O error on device md3, logical block 13123997
> [86895.581395] Buffer I/O error on device md3, logical block 13123998
> [86895.581397] Buffer I/O error on device md3, logical block 13123999
> [86895.581398] Buffer I/O error on device md3, logical block 13124000
> [86895.581400] Buffer I/O error on device md3, logical block 13124001
> [86895.581401] Buffer I/O error on device md3, logical block 13124002
> [86895.581403] Buffer I/O error on device md3, logical block 13124003
> [86895.581405] Buffer I/O error on device md3, logical block 13124004
> [86895.581406] Buffer I/O error on device md3, logical block 13124005
> [86895.581408] Buffer I/O error on device md3, logical block 13124006
> [86895.581410] Buffer I/O error on device md3, logical block 13124007
> [86895.581411] Buffer I/O error on device md3, logical block 13124008
> [86895.581413] Buffer I/O error on device md3, logical block 13124009
> [86895.581415] Buffer I/O error on device md3, logical block 13124010
> [86895.581416] Buffer I/O error on device md3, logical block 13124011
> [86895.581418] Buffer I/O error on device md3, logical block 13124012
> [86895.581420] Buffer I/O error on device md3, logical block 13124013
> [86895.581422] Buffer I/O error on device md3, logical block 13124014
> [86895.581423] Buffer I/O error on device md3, logical block 13124015
> [86895.581425] Buffer I/O error on device md3, logical block 13124016
> [86895.581427] Buffer I/O error on device md3, logical block 13124017
> [86895.581429] Buffer I/O error on device md3, logical block 13124018
> [86895.581433] Buffer I/O error on device md3, logical block 13124019
> [86895.581435] Buffer I/O error on device md3, logical block 13124020
> [86895.581437] Buffer I/O error on device md3, logical block 13124021
> [86895.581441] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673461 (offset 9965568 size 487424 starting block 13123903)
> [86895.581450] Buffer I/O error on device md3, logical block 13124022
> [86895.581453] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673461 (offset 10452992 size 4096 starting block 13124022)
> [86895.581505] md3: WRITE SAME failed. Manually zeroing.
> [86896.346103] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86896.578623] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86896.827956] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86897.576090] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86897.825447] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86898.074866] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86898.074882] sd 0:0:4:0: [sde] Unhandled error code
> [86898.074884] sd 0:0:4:0: [sde]
> [86898.074885] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [86898.074887] sd 0:0:4:0: [sde] CDB:
> [86898.074889] Write(10): 2a 00 06 42 19 f8 00 04 00 00
> [86898.074896] end_request: I/O error, dev sde, sector 104995320
> [86898.074955] Buffer I/O error on device md3, logical block 13124159
> [86898.074961] Buffer I/O error on device md3, logical block 13124160
> [86898.074963] Buffer I/O error on device md3, logical block 13124161
> [86898.074964] Buffer I/O error on device md3, logical block 13124162
> [86898.074966] Buffer I/O error on device md3, logical block 13124163
> [86898.074968] Buffer I/O error on device md3, logical block 13124164
> [86898.074970] Buffer I/O error on device md3, logical block 13124165
> [86898.074971] Buffer I/O error on device md3, logical block 13124166
> [86898.074973] Buffer I/O error on device md3, logical block 13124167
> [86898.074975] Buffer I/O error on device md3, logical block 13124168
> [86898.074977] Buffer I/O error on device md3, logical block 13124169
> [86898.074979] Buffer I/O error on device md3, logical block 13124170
> [86898.074980] Buffer I/O error on device md3, logical block 13124171
> [86898.074982] Buffer I/O error on device md3, logical block 13124172
> [86898.074984] Buffer I/O error on device md3, logical block 13124173
> [86898.074986] Buffer I/O error on device md3, logical block 13124174
> [86898.074988] Buffer I/O error on device md3, logical block 13124175
> [86898.074990] Buffer I/O error on device md3, logical block 13124176
> [86898.074991] Buffer I/O error on device md3, logical block 13124177
> [86898.074993] Buffer I/O error on device md3, logical block 13124178
> [86898.074994] Buffer I/O error on device md3, logical block 13124179
> [86898.074997] Buffer I/O error on device md3, logical block 13124180
> [86898.074999] Buffer I/O error on device md3, logical block 13124181
> [86898.075000] Buffer I/O error on device md3, logical block 13124182
> [86898.075002] Buffer I/O error on device md3, logical block 13124183
> [86898.075004] Buffer I/O error on device md3, logical block 13124184
> [86898.075006] Buffer I/O error on device md3, logical block 13124185
> [86898.075008] Buffer I/O error on device md3, logical block 13124186
> [86898.075009] Buffer I/O error on device md3, logical block 13124187
> [86898.075011] Buffer I/O error on device md3, logical block 13124188
> [86898.075013] Buffer I/O error on device md3, logical block 13124189
> [86898.075014] Buffer I/O error on device md3, logical block 13124190
> [86898.075016] Buffer I/O error on device md3, logical block 13124191
> [86898.075018] Buffer I/O error on device md3, logical block 13124192
> [86898.075029] Buffer I/O error on device md3, logical block 13124193
> [86898.075031] Buffer I/O error on device md3, logical block 13124194
> [86898.075033] Buffer I/O error on device md3, logical block 13124195
> [86898.075034] Buffer I/O error on device md3, logical block 13124196
> [86898.075036] Buffer I/O error on device md3, logical block 13124197
> [86898.075038] Buffer I/O error on device md3, logical block 13124198
> [86898.075039] Buffer I/O error on device md3, logical block 13124199
> [86898.075041] Buffer I/O error on device md3, logical block 13124200
> [86898.075043] Buffer I/O error on device md3, logical block 13124201
> [86898.075044] Buffer I/O error on device md3, logical block 13124202
> [86898.075046] Buffer I/O error on device md3, logical block 13124203
> [86898.075048] Buffer I/O error on device md3, logical block 13124204
> [86898.075050] Buffer I/O error on device md3, logical block 13124205
> [86898.075051] Buffer I/O error on device md3, logical block 13124206
> [86898.075053] Buffer I/O error on device md3, logical block 13124207
> [86898.075055] Buffer I/O error on device md3, logical block 13124208
> [86898.075057] Buffer I/O error on device md3, logical block 13124209
> [86898.075058] Buffer I/O error on device md3, logical block 13124210
> [86898.075060] Buffer I/O error on device md3, logical block 13124211
> [86898.075062] Buffer I/O error on device md3, logical block 13124212
> [86898.075064] Buffer I/O error on device md3, logical block 13124213
> [86898.075065] Buffer I/O error on device md3, logical block 13124214
> [86898.075067] Buffer I/O error on device md3, logical block 13124215
> [86898.075069] Buffer I/O error on device md3, logical block 13124216
> [86898.075071] Buffer I/O error on device md3, logical block 13124217
> [86898.075072] Buffer I/O error on device md3, logical block 13124218
> [86898.075074] Buffer I/O error on device md3, logical block 13124219
> [86898.075076] Buffer I/O error on device md3, logical block 13124220
> [86898.075077] Buffer I/O error on device md3, logical block 13124221
> [86898.075079] Buffer I/O error on device md3, logical block 13124222
> [86898.075081] Buffer I/O error on device md3, logical block 13124223
> [86898.075083] Buffer I/O error on device md3, logical block 13124224
> [86898.075085] Buffer I/O error on device md3, logical block 13124225
> [86898.075086] Buffer I/O error on device md3, logical block 13124226
> [86898.075088] Buffer I/O error on device md3, logical block 13124227
> [86898.075090] Buffer I/O error on device md3, logical block 13124228
> [86898.075092] Buffer I/O error on device md3, logical block 13124229
> [86898.075093] Buffer I/O error on device md3, logical block 13124230
> [86898.075095] Buffer I/O error on device md3, logical block 13124231
> [86898.075097] Buffer I/O error on device md3, logical block 13124232
> [86898.075099] Buffer I/O error on device md3, logical block 13124233
> [86898.075100] Buffer I/O error on device md3, logical block 13124234
> [86898.075102] Buffer I/O error on device md3, logical block 13124235
> [86898.075104] Buffer I/O error on device md3, logical block 13124236
> [86898.075106] Buffer I/O error on device md3, logical block 13124237
> [86898.075107] Buffer I/O error on device md3, logical block 13124238
> [86898.075109] Buffer I/O error on device md3, logical block 13124239
> [86898.075111] Buffer I/O error on device md3, logical block 13124240
> [86898.075112] Buffer I/O error on device md3, logical block 13124241
> [86898.075114] Buffer I/O error on device md3, logical block 13124242
> [86898.075116] Buffer I/O error on device md3, logical block 13124243
> [86898.075118] Buffer I/O error on device md3, logical block 13124244
> [86898.075119] Buffer I/O error on device md3, logical block 13124245
> [86898.075121] Buffer I/O error on device md3, logical block 13124246
> [86898.075122] Buffer I/O error on device md3, logical block 13124247
> [86898.075124] Buffer I/O error on device md3, logical block 13124248
> [86898.075126] Buffer I/O error on device md3, logical block 13124249
> [86898.075130] Buffer I/O error on device md3, logical block 13124250
> [86898.075132] Buffer I/O error on device md3, logical block 13124251
> [86898.075133] Buffer I/O error on device md3, logical block 13124252
> [86898.075135] Buffer I/O error on device md3, logical block 13124253
> [86898.075137] Buffer I/O error on device md3, logical block 13124254
> [86898.075138] Buffer I/O error on device md3, logical block 13124255
> [86898.075140] Buffer I/O error on device md3, logical block 13124256
> [86898.075142] Buffer I/O error on device md3, logical block 13124257
> [86898.075143] Buffer I/O error on device md3, logical block 13124258
> [86898.075145] Buffer I/O error on device md3, logical block 13124259
> [86898.075146] Buffer I/O error on device md3, logical block 13124260
> [86898.075148] Buffer I/O error on device md3, logical block 13124261
> [86898.075149] Buffer I/O error on device md3, logical block 13124262
> [86898.075151] Buffer I/O error on device md3, logical block 13124263
> [86898.075153] Buffer I/O error on device md3, logical block 13124264
> [86898.075154] Buffer I/O error on device md3, logical block 13124265
> [86898.075156] Buffer I/O error on device md3, logical block 13124266
> [86898.075157] Buffer I/O error on device md3, logical block 13124267
> [86898.075159] Buffer I/O error on device md3, logical block 13124268
> [86898.075161] Buffer I/O error on device md3, logical block 13124269
> [86898.075162] Buffer I/O error on device md3, logical block 13124270
> [86898.075164] Buffer I/O error on device md3, logical block 13124271
> [86898.075165] Buffer I/O error on device md3, logical block 13124272
> [86898.075167] Buffer I/O error on device md3, logical block 13124273
> [86898.075169] Buffer I/O error on device md3, logical block 13124274
> [86898.075171] Buffer I/O error on device md3, logical block 13124275
> [86898.075172] Buffer I/O error on device md3, logical block 13124276
> [86898.075174] Buffer I/O error on device md3, logical block 13124277
> [86898.075178] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673461 (offset 11014144 size 487424 starting block 13124159)
> [86898.075185] Buffer I/O error on device md3, logical block 13124278
> [86898.075188] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673461 (offset 11501568 size 4096 starting block 13124278)
> [86898.075226] md3: WRITE SAME failed. Manually zeroing.
> [86898.872336] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86899.072345] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86899.321760] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86900.069858] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86900.319223] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86900.568620] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86900.568636] sd 0:0:4:0: [sde] Unhandled error code
> [86900.568638] sd 0:0:4:0: [sde]
> [86900.568640] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [86900.568642] sd 0:0:4:0: [sde] CDB:
> [86900.568643] Write(10): 2a 00 06 42 21 f8 00 04 00 00
> [86900.568651] end_request: I/O error, dev sde, sector 104997368
> [86900.568711] Buffer I/O error on device md3, logical block 13124415
> [86900.568718] Buffer I/O error on device md3, logical block 13124416
> [86900.568720] Buffer I/O error on device md3, logical block 13124417
> [86900.568722] Buffer I/O error on device md3, logical block 13124418
> [86900.568724] Buffer I/O error on device md3, logical block 13124419
> [86900.568726] Buffer I/O error on device md3, logical block 13124420
> [86900.568728] Buffer I/O error on device md3, logical block 13124421
> [86900.568730] Buffer I/O error on device md3, logical block 13124422
> [86900.568732] Buffer I/O error on device md3, logical block 13124423
> [86900.568746] Buffer I/O error on device md3, logical block 13124424
> [86900.568748] Buffer I/O error on device md3, logical block 13124425
> [86900.568750] Buffer I/O error on device md3, logical block 13124426
> [86900.568752] Buffer I/O error on device md3, logical block 13124427
> [86900.568754] Buffer I/O error on device md3, logical block 13124428
> [86900.568756] Buffer I/O error on device md3, logical block 13124429
> [86900.568758] Buffer I/O error on device md3, logical block 13124430
> [86900.568760] Buffer I/O error on device md3, logical block 13124431
> [86900.568761] Buffer I/O error on device md3, logical block 13124432
> [86900.568763] Buffer I/O error on device md3, logical block 13124433
> [86900.568765] Buffer I/O error on device md3, logical block 13124434
> [86900.568767] Buffer I/O error on device md3, logical block 13124435
> [86900.568769] Buffer I/O error on device md3, logical block 13124436
> [86900.568771] Buffer I/O error on device md3, logical block 13124437
> [86900.568773] Buffer I/O error on device md3, logical block 13124438
> [86900.568775] Buffer I/O error on device md3, logical block 13124439
> [86900.568776] Buffer I/O error on device md3, logical block 13124440
> [86900.568778] Buffer I/O error on device md3, logical block 13124441
> [86900.568780] Buffer I/O error on device md3, logical block 13124442
> [86900.568782] Buffer I/O error on device md3, logical block 13124443
> [86900.568783] Buffer I/O error on device md3, logical block 13124444
> [86900.568785] Buffer I/O error on device md3, logical block 13124445
> [86900.568787] Buffer I/O error on device md3, logical block 13124446
> [86900.568789] Buffer I/O error on device md3, logical block 13124447
> [86900.568790] Buffer I/O error on device md3, logical block 13124448
> [86900.568792] Buffer I/O error on device md3, logical block 13124449
> [86900.568794] Buffer I/O error on device md3, logical block 13124450
> [86900.568796] Buffer I/O error on device md3, logical block 13124451
> [86900.568797] Buffer I/O error on device md3, logical block 13124452
> [86900.568799] Buffer I/O error on device md3, logical block 13124453
> [86900.568801] Buffer I/O error on device md3, logical block 13124454
> [86900.568803] Buffer I/O error on device md3, logical block 13124455
> [86900.568804] Buffer I/O error on device md3, logical block 13124456
> [86900.568806] Buffer I/O error on device md3, logical block 13124457
> [86900.568808] Buffer I/O error on device md3, logical block 13124458
> [86900.568809] Buffer I/O error on device md3, logical block 13124459
> [86900.568811] Buffer I/O error on device md3, logical block 13124460
> [86900.568813] Buffer I/O error on device md3, logical block 13124461
> [86900.568815] Buffer I/O error on device md3, logical block 13124462
> [86900.568817] Buffer I/O error on device md3, logical block 13124463
> [86900.568818] Buffer I/O error on device md3, logical block 13124464
> [86900.568820] Buffer I/O error on device md3, logical block 13124465
> [86900.568822] Buffer I/O error on device md3, logical block 13124466
> [86900.568824] Buffer I/O error on device md3, logical block 13124467
> [86900.568825] Buffer I/O error on device md3, logical block 13124468
> [86900.568827] Buffer I/O error on device md3, logical block 13124469
> [86900.568829] Buffer I/O error on device md3, logical block 13124470
> [86900.568830] Buffer I/O error on device md3, logical block 13124471
> [86900.568832] Buffer I/O error on device md3, logical block 13124472
> [86900.568834] Buffer I/O error on device md3, logical block 13124473
> [86900.568836] Buffer I/O error on device md3, logical block 13124474
> [86900.568838] Buffer I/O error on device md3, logical block 13124475
> [86900.568840] Buffer I/O error on device md3, logical block 13124476
> [86900.568841] Buffer I/O error on device md3, logical block 13124477
> [86900.568843] Buffer I/O error on device md3, logical block 13124478
> [86900.568845] Buffer I/O error on device md3, logical block 13124479
> [86900.568847] Buffer I/O error on device md3, logical block 13124480
> [86900.568851] Buffer I/O error on device md3, logical block 13124481
> [86900.568853] Buffer I/O error on device md3, logical block 13124482
> [86900.568855] Buffer I/O error on device md3, logical block 13124483
> [86900.568857] Buffer I/O error on device md3, logical block 13124484
> [86900.568858] Buffer I/O error on device md3, logical block 13124485
> [86900.568860] Buffer I/O error on device md3, logical block 13124486
> [86900.568862] Buffer I/O error on device md3, logical block 13124487
> [86900.568863] Buffer I/O error on device md3, logical block 13124488
> [86900.568865] Buffer I/O error on device md3, logical block 13124489
> [86900.568867] Buffer I/O error on device md3, logical block 13124490
> [86900.568868] Buffer I/O error on device md3, logical block 13124491
> [86900.568870] Buffer I/O error on device md3, logical block 13124492
> [86900.568872] Buffer I/O error on device md3, logical block 13124493
> [86900.568873] Buffer I/O error on device md3, logical block 13124494
> [86900.568875] Buffer I/O error on device md3, logical block 13124495
> [86900.568877] Buffer I/O error on device md3, logical block 13124496
> [86900.568878] Buffer I/O error on device md3, logical block 13124497
> [86900.568880] Buffer I/O error on device md3, logical block 13124498
> [86900.568882] Buffer I/O error on device md3, logical block 13124499
> [86900.568884] Buffer I/O error on device md3, logical block 13124500
> [86900.568885] Buffer I/O error on device md3, logical block 13124501
> [86900.568887] Buffer I/O error on device md3, logical block 13124502
> [86900.568889] Buffer I/O error on device md3, logical block 13124503
> [86900.568891] Buffer I/O error on device md3, logical block 13124504
> [86900.568892] Buffer I/O error on device md3, logical block 13124505
> [86900.568894] Buffer I/O error on device md3, logical block 13124506
> [86900.568895] Buffer I/O error on device md3, logical block 13124507
> [86900.568897] Buffer I/O error on device md3, logical block 13124508
> [86900.568899] Buffer I/O error on device md3, logical block 13124509
> [86900.568901] Buffer I/O error on device md3, logical block 13124510
> [86900.568902] Buffer I/O error on device md3, logical block 13124511
> [86900.568904] Buffer I/O error on device md3, logical block 13124512
> [86900.568906] Buffer I/O error on device md3, logical block 13124513
> [86900.568907] Buffer I/O error on device md3, logical block 13124514
> [86900.568909] Buffer I/O error on device md3, logical block 13124515
> [86900.568911] Buffer I/O error on device md3, logical block 13124516
> [86900.568912] Buffer I/O error on device md3, logical block 13124517
> [86900.568914] Buffer I/O error on device md3, logical block 13124518
> [86900.568916] Buffer I/O error on device md3, logical block 13124519
> [86900.568918] Buffer I/O error on device md3, logical block 13124520
> [86900.568919] Buffer I/O error on device md3, logical block 13124521
> [86900.568921] Buffer I/O error on device md3, logical block 13124522
> [86900.568923] Buffer I/O error on device md3, logical block 13124523
> [86900.568924] Buffer I/O error on device md3, logical block 13124524
> [86900.568926] Buffer I/O error on device md3, logical block 13124525
> [86900.568928] Buffer I/O error on device md3, logical block 13124526
> [86900.568930] Buffer I/O error on device md3, logical block 13124527
> [86900.568931] Buffer I/O error on device md3, logical block 13124528
> [86900.568933] Buffer I/O error on device md3, logical block 13124529
> [86900.568935] Buffer I/O error on device md3, logical block 13124530
> [86900.568936] Buffer I/O error on device md3, logical block 13124531
> [86900.568938] Buffer I/O error on device md3, logical block 13124532
> [86900.568940] Buffer I/O error on device md3, logical block 13124533
> [86900.568944] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673461 (offset 12062720 size 487424 starting block 13124415)
> [86900.568951] Buffer I/O error on device md3, logical block 13124534
> [86900.568957] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673461 (offset 12550144 size 4096 starting block 13124534)
> [86900.568997] md3: WRITE SAME failed. Manually zeroing.
> [86901.337898] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86901.566970] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86901.816312] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86902.564449] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86902.813848] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86903.063183] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86903.063201] sd 0:0:4:0: [sde] Unhandled error code
> [86903.063203] sd 0:0:4:0: [sde]
> [86903.063204] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [86903.063206] sd 0:0:4:0: [sde] CDB:
> [86903.063207] Write(10): 2a 00 06 42 2a b0 00 03 48 00
> [86903.063215] end_request: I/O error, dev sde, sector 104999600
> [86903.063275] Buffer I/O error on device md3, logical block 13124694
> [86903.063281] Buffer I/O error on device md3, logical block 13124695
> [86903.063283] Buffer I/O error on device md3, logical block 13124696
> [86903.063285] Buffer I/O error on device md3, logical block 13124697
> [86903.063286] Buffer I/O error on device md3, logical block 13124698
> [86903.063288] Buffer I/O error on device md3, logical block 13124699
> [86903.063290] Buffer I/O error on device md3, logical block 13124700
> [86903.063292] Buffer I/O error on device md3, logical block 13124701
> [86903.063294] Buffer I/O error on device md3, logical block 13124702
> [86903.063295] Buffer I/O error on device md3, logical block 13124703
> [86903.063297] Buffer I/O error on device md3, logical block 13124704
> [86903.063299] Buffer I/O error on device md3, logical block 13124705
> [86903.063301] Buffer I/O error on device md3, logical block 13124706
> [86903.063302] Buffer I/O error on device md3, logical block 13124707
> [86903.063304] Buffer I/O error on device md3, logical block 13124708
> [86903.063306] Buffer I/O error on device md3, logical block 13124709
> [86903.063308] Buffer I/O error on device md3, logical block 13124710
> [86903.063310] Buffer I/O error on device md3, logical block 13124711
> [86903.063311] Buffer I/O error on device md3, logical block 13124712
> [86903.063313] Buffer I/O error on device md3, logical block 13124713
> [86903.063315] Buffer I/O error on device md3, logical block 13124714
> [86903.063317] Buffer I/O error on device md3, logical block 13124715
> [86903.063318] Buffer I/O error on device md3, logical block 13124716
> [86903.063320] Buffer I/O error on device md3, logical block 13124717
> [86903.063322] Buffer I/O error on device md3, logical block 13124718
> [86903.063324] Buffer I/O error on device md3, logical block 13124719
> [86903.063325] Buffer I/O error on device md3, logical block 13124720
> [86903.063327] Buffer I/O error on device md3, logical block 13124721
> [86903.063329] Buffer I/O error on device md3, logical block 13124722
> [86903.063331] Buffer I/O error on device md3, logical block 13124723
> [86903.063332] Buffer I/O error on device md3, logical block 13124724
> [86903.063334] Buffer I/O error on device md3, logical block 13124725
> [86903.063336] Buffer I/O error on device md3, logical block 13124726
> [86903.063337] Buffer I/O error on device md3, logical block 13124727
> [86903.063339] Buffer I/O error on device md3, logical block 13124728
> [86903.063341] Buffer I/O error on device md3, logical block 13124729
> [86903.063342] Buffer I/O error on device md3, logical block 13124730
> [86903.063344] Buffer I/O error on device md3, logical block 13124731
> [86903.063346] Buffer I/O error on device md3, logical block 13124732
> [86903.063348] Buffer I/O error on device md3, logical block 13124733
> [86903.063350] Buffer I/O error on device md3, logical block 13124734
> [86903.063360] Buffer I/O error on device md3, logical block 13124735
> [86903.063363] Buffer I/O error on device md3, logical block 13124736
> [86903.063364] Buffer I/O error on device md3, logical block 13124737
> [86903.063366] Buffer I/O error on device md3, logical block 13124738
> [86903.063368] Buffer I/O error on device md3, logical block 13124739
> [86903.063370] Buffer I/O error on device md3, logical block 13124740
> [86903.063371] Buffer I/O error on device md3, logical block 13124741
> [86903.063373] Buffer I/O error on device md3, logical block 13124742
> [86903.063375] Buffer I/O error on device md3, logical block 13124743
> [86903.063376] Buffer I/O error on device md3, logical block 13124744
> [86903.063378] Buffer I/O error on device md3, logical block 13124745
> [86903.063380] Buffer I/O error on device md3, logical block 13124746
> [86903.063382] Buffer I/O error on device md3, logical block 13124747
> [86903.063384] Buffer I/O error on device md3, logical block 13124748
> [86903.063386] Buffer I/O error on device md3, logical block 13124749
> [86903.063387] Buffer I/O error on device md3, logical block 13124750
> [86903.063389] Buffer I/O error on device md3, logical block 13124751
> [86903.063391] Buffer I/O error on device md3, logical block 13124752
> [86903.063392] Buffer I/O error on device md3, logical block 13124753
> [86903.063394] Buffer I/O error on device md3, logical block 13124754
> [86903.063396] Buffer I/O error on device md3, logical block 13124755
> [86903.063397] Buffer I/O error on device md3, logical block 13124756
> [86903.063399] Buffer I/O error on device md3, logical block 13124757
> [86903.063401] Buffer I/O error on device md3, logical block 13124758
> [86903.063403] Buffer I/O error on device md3, logical block 13124759
> [86903.063404] Buffer I/O error on device md3, logical block 13124760
> [86903.063406] Buffer I/O error on device md3, logical block 13124761
> [86903.063408] Buffer I/O error on device md3, logical block 13124762
> [86903.063409] Buffer I/O error on device md3, logical block 13124763
> [86903.063411] Buffer I/O error on device md3, logical block 13124764
> [86903.063413] Buffer I/O error on device md3, logical block 13124765
> [86903.063414] Buffer I/O error on device md3, logical block 13124766
> [86903.063416] Buffer I/O error on device md3, logical block 13124767
> [86903.063418] Buffer I/O error on device md3, logical block 13124768
> [86903.063419] Buffer I/O error on device md3, logical block 13124769
> [86903.063421] Buffer I/O error on device md3, logical block 13124770
> [86903.063422] Buffer I/O error on device md3, logical block 13124771
> [86903.063424] Buffer I/O error on device md3, logical block 13124772
> [86903.063426] Buffer I/O error on device md3, logical block 13124773
> [86903.063427] Buffer I/O error on device md3, logical block 13124774
> [86903.063429] Buffer I/O error on device md3, logical block 13124775
> [86903.063431] Buffer I/O error on device md3, logical block 13124776
> [86903.063433] Buffer I/O error on device md3, logical block 13124777
> [86903.063434] Buffer I/O error on device md3, logical block 13124778
> [86903.063436] Buffer I/O error on device md3, logical block 13124779
> [86903.063438] Buffer I/O error on device md3, logical block 13124780
> [86903.063440] Buffer I/O error on device md3, logical block 13124781
> [86903.063442] Buffer I/O error on device md3, logical block 13124782
> [86903.063443] Buffer I/O error on device md3, logical block 13124783
> [86903.063445] Buffer I/O error on device md3, logical block 13124784
> [86903.063447] Buffer I/O error on device md3, logical block 13124785
> [86903.063448] Buffer I/O error on device md3, logical block 13124786
> [86903.063450] Buffer I/O error on device md3, logical block 13124787
> [86903.063452] Buffer I/O error on device md3, logical block 13124788
> [86903.063453] Buffer I/O error on device md3, logical block 13124789
> [86903.063458] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673461 (offset 13205504 size 393216 starting block 13124694)
> [86903.063466] Buffer I/O error on device md3, logical block 13124790
> [86903.063470] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673461 (offset 13598720 size 4096 starting block 13124790)
> [86903.063509] md3: WRITE SAME failed. Manually zeroing.
> [86903.833283] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86904.059866] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86904.309258] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86905.057362] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86905.306778] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86905.556111] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [86905.556130] sd 0:0:4:0: [sde] Unhandled error code
> [86905.556133] sd 0:0:4:0: [sde]
> [86905.556134] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [86905.556136] sd 0:0:4:0: [sde] CDB:
> [86905.556137] Write(10): 2a 00 06 42 31 f8 00 04 00 00
> [86905.556145] end_request: I/O error, dev sde, sector 105001464
> [86905.556195] Buffer I/O error on device md3, logical block 13124927
> [86905.556200] Buffer I/O error on device md3, logical block 13124928
> [86905.556201] Buffer I/O error on device md3, logical block 13124929
> [86905.556203] Buffer I/O error on device md3, logical block 13124930
> [86905.556205] Buffer I/O error on device md3, logical block 13124931
> [86905.556207] Buffer I/O error on device md3, logical block 13124932
> [86905.556208] Buffer I/O error on device md3, logical block 13124933
> [86905.556210] Buffer I/O error on device md3, logical block 13124934
> [86905.556212] Buffer I/O error on device md3, logical block 13124935
> [86905.556213] Buffer I/O error on device md3, logical block 13124936
> [86905.556215] Buffer I/O error on device md3, logical block 13124937
> [86905.556217] Buffer I/O error on device md3, logical block 13124938
> [86905.556219] Buffer I/O error on device md3, logical block 13124939
> [86905.556221] Buffer I/O error on device md3, logical block 13124940
> [86905.556222] Buffer I/O error on device md3, logical block 13124941
> [86905.556224] Buffer I/O error on device md3, logical block 13124942
> [86905.556226] Buffer I/O error on device md3, logical block 13124943
> [86905.556228] Buffer I/O error on device md3, logical block 13124944
> [86905.556229] Buffer I/O error on device md3, logical block 13124945
> [86905.556231] Buffer I/O error on device md3, logical block 13124946
> [86905.556233] Buffer I/O error on device md3, logical block 13124947
> [86905.556235] Buffer I/O error on device md3, logical block 13124948
> [86905.556236] Buffer I/O error on device md3, logical block 13124949
> [86905.556238] Buffer I/O error on device md3, logical block 13124950
> [86905.556240] Buffer I/O error on device md3, logical block 13124951
> [86905.556242] Buffer I/O error on device md3, logical block 13124952
> [86905.556243] Buffer I/O error on device md3, logical block 13124953
> [86905.556245] Buffer I/O error on device md3, logical block 13124954
> [86905.556247] Buffer I/O error on device md3, logical block 13124955
> [86905.556248] Buffer I/O error on device md3, logical block 13124956
> [86905.556250] Buffer I/O error on device md3, logical block 13124957
> [86905.556252] Buffer I/O error on device md3, logical block 13124958
> [86905.556253] Buffer I/O error on device md3, logical block 13124959
> [86905.556255] Buffer I/O error on device md3, logical block 13124960
> [86905.556257] Buffer I/O error on device md3, logical block 13124961
> [86905.556258] Buffer I/O error on device md3, logical block 13124962
> [86905.556260] Buffer I/O error on device md3, logical block 13124963
> [86905.556262] Buffer I/O error on device md3, logical block 13124964
> [86905.556263] Buffer I/O error on device md3, logical block 13124965
> [86905.556272] Buffer I/O error on device md3, logical block 13124966
> [86905.556275] Buffer I/O error on device md3, logical block 13124967
> [86905.556276] Buffer I/O error on device md3, logical block 13124968
> [86905.556278] Buffer I/O error on device md3, logical block 13124969
> [86905.556280] Buffer I/O error on device md3, logical block 13124970
> [86905.556281] Buffer I/O error on device md3, logical block 13124971
> [86905.556283] Buffer I/O error on device md3, logical block 13124972
> [86905.556285] Buffer I/O error on device md3, logical block 13124973
> [86905.556286] Buffer I/O error on device md3, logical block 13124974
> [86905.556288] Buffer I/O error on device md3, logical block 13124975
> [86905.556290] Buffer I/O error on device md3, logical block 13124976
> [86905.556291] Buffer I/O error on device md3, logical block 13124977
> [86905.556293] Buffer I/O error on device md3, logical block 13124978
> [86905.556295] Buffer I/O error on device md3, logical block 13124979
> [86905.556297] Buffer I/O error on device md3, logical block 13124980
> [86905.556298] Buffer I/O error on device md3, logical block 13124981
> [86905.556300] Buffer I/O error on device md3, logical block 13124982
> [86905.556302] Buffer I/O error on device md3, logical block 13124983
> [86905.556304] Buffer I/O error on device md3, logical block 13124984
> [86905.556305] Buffer I/O error on device md3, logical block 13124985
> [86905.556307] Buffer I/O error on device md3, logical block 13124986
> [86905.556308] Buffer I/O error on device md3, logical block 13124987
> [86905.556310] Buffer I/O error on device md3, logical block 13124988
> [86905.556311] Buffer I/O error on device md3, logical block 13124989
> [86905.556313] Buffer I/O error on device md3, logical block 13124990
> [86905.556315] Buffer I/O error on device md3, logical block 13124991
> [86905.556317] Buffer I/O error on device md3, logical block 13124992
> [86905.556318] Buffer I/O error on device md3, logical block 13124993
> [86905.556320] Buffer I/O error on device md3, logical block 13124994
> [86905.556321] Buffer I/O error on device md3, logical block 13124995
> [86905.556323] Buffer I/O error on device md3, logical block 13124996
> [86905.556325] Buffer I/O error on device md3, logical block 13124997
> [86905.556326] Buffer I/O error on device md3, logical block 13124998
> [86905.556328] Buffer I/O error on device md3, logical block 13124999
> [86905.556330] Buffer I/O error on device md3, logical block 13125000
> [86905.556331] Buffer I/O error on device md3, logical block 13125001
> [86905.556333] Buffer I/O error on device md3, logical block 13125002
> [86905.556334] Buffer I/O error on device md3, logical block 13125003
> [86905.556336] Buffer I/O error on device md3, logical block 13125004
> [86905.556337] Buffer I/O error on device md3, logical block 13125005
> [86905.556339] Buffer I/O error on device md3, logical block 13125006
> [86905.556341] Buffer I/O error on device md3, logical block 13125007
> [86905.556342] Buffer I/O error on device md3, logical block 13125008
> [86905.556344] Buffer I/O error on device md3, logical block 13125009
> [86905.556346] Buffer I/O error on device md3, logical block 13125010
> [86905.556347] Buffer I/O error on device md3, logical block 13125011
> [86905.556349] Buffer I/O error on device md3, logical block 13125012
> [86905.556350] Buffer I/O error on device md3, logical block 13125013
> [86905.556352] Buffer I/O error on device md3, logical block 13125014
> [86905.556354] Buffer I/O error on device md3, logical block 13125015
> [86905.556355] Buffer I/O error on device md3, logical block 13125016
> [86905.556357] Buffer I/O error on device md3, logical block 13125017
> [86905.556359] Buffer I/O error on device md3, logical block 13125018
> [86905.556360] Buffer I/O error on device md3, logical block 13125019
> [86905.556362] Buffer I/O error on device md3, logical block 13125020
> [86905.556363] Buffer I/O error on device md3, logical block 13125021
> [86905.556365] Buffer I/O error on device md3, logical block 13125022
> [86905.556370] Buffer I/O error on device md3, logical block 13125023
> [86905.556372] Buffer I/O error on device md3, logical block 13125024
> [86905.556374] Buffer I/O error on device md3, logical block 13125025
> [86905.556375] Buffer I/O error on device md3, logical block 13125026
> [86905.556377] Buffer I/O error on device md3, logical block 13125027
> [86905.556379] Buffer I/O error on device md3, logical block 13125028
> [86905.556380] Buffer I/O error on device md3, logical block 13125029
> [86905.556382] Buffer I/O error on device md3, logical block 13125030
> [86905.556384] Buffer I/O error on device md3, logical block 13125031
> [86905.556385] Buffer I/O error on device md3, logical block 13125032
> [86905.556387] Buffer I/O error on device md3, logical block 13125033
> [86905.556389] Buffer I/O error on device md3, logical block 13125034
> [86905.556390] Buffer I/O error on device md3, logical block 13125035
> [86905.556392] Buffer I/O error on device md3, logical block 13125036
> [86905.556394] Buffer I/O error on device md3, logical block 13125037
> [86905.556395] Buffer I/O error on device md3, logical block 13125038
> [86905.556397] Buffer I/O error on device md3, logical block 13125039
> [86905.556399] Buffer I/O error on device md3, logical block 13125040
> [86905.556401] Buffer I/O error on device md3, logical block 13125041
> [86905.556402] Buffer I/O error on device md3, logical block 13125042
> [86905.556404] Buffer I/O error on device md3, logical block 13125043
> [86905.556406] Buffer I/O error on device md3, logical block 13125044
> [86905.556408] Buffer I/O error on device md3, logical block 13125045
> [86905.556412] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673461 (offset 14159872 size 487424 starting block 13124927)
> [86905.556416] Buffer I/O error on device md3, logical block 13125046
> [86905.556423] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673461 (offset 14647296 size 4096 starting block 13125046)
> [86905.556451] md3: WRITE SAME failed. Manually zeroing.
> [87065.930525] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87066.153387] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87066.402712] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87067.150878] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87067.400216] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87067.649593] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87067.649609] sd 0:0:4:0: [sde] Unhandled error code
> [87067.649611] sd 0:0:4:0: [sde]
> [87067.649612] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87067.649614] sd 0:0:4:0: [sde] CDB:
> [87067.649616] Write(10): 2a 00 53 5e 49 c0 00 00 40 00
> [87067.649623] end_request: I/O error, dev sde, sector 1398688192
> [87067.649690] md3: WRITE SAME failed. Manually zeroing.
> [87068.504413] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87068.647115] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87068.896489] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87069.644645] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87069.893983] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87070.143351] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87070.143367] sd 0:0:4:0: [sde] Unhandled error code
> [87070.143369] sd 0:0:4:0: [sde]
> [87070.143371] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87070.143373] sd 0:0:4:0: [sde] CDB:
> [87070.143374] Write(10): 2a 00 06 57 87 c0 00 00 40 00
> [87070.143389] end_request: I/O error, dev sde, sector 106399680
> [87070.143476] md3: WRITE SAME failed. Manually zeroing.
> [87070.929678] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87071.140854] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87071.390237] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87072.138353] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87072.387747] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87072.637118] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87072.637135] sd 0:0:4:0: [sde] Unhandled error code
> [87072.637137] sd 0:0:4:0: [sde]
> [87072.637138] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87072.637140] sd 0:0:4:0: [sde] CDB:
> [87072.637141] Write(10): 2a 00 06 57 52 00 00 00 40 00
> [87072.637149] end_request: I/O error, dev sde, sector 106385920
> [87072.637224] md3: WRITE SAME failed. Manually zeroing.
> [87073.393512] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87073.393515] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87073.393518] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87073.636258] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87073.884056] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87074.632200] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87074.881520] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87075.130903] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87075.130920] sd 0:0:4:0: [sde] Unhandled error code
> [87075.130923] sd 0:0:4:0: [sde]
> [87075.130924] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87075.130926] sd 0:0:4:0: [sde] CDB:
> [87075.130927] Write(10): 2a 00 06 57 52 00 00 00 80 00
> [87075.130935] end_request: I/O error, dev sde, sector 106385920
> [87075.131005] Buffer I/O error on device md3, logical block 13297984
> [87075.131013] Buffer I/O error on device md3, logical block 13297985
> [87075.131015] Buffer I/O error on device md3, logical block 13297986
> [87075.131017] Buffer I/O error on device md3, logical block 13297987
> [87075.131019] Buffer I/O error on device md3, logical block 13297988
> [87075.131021] Buffer I/O error on device md3, logical block 13297989
> [87075.131022] Buffer I/O error on device md3, logical block 13297990
> [87075.131024] Buffer I/O error on device md3, logical block 13297991
> [87075.131029] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673460 (offset 2097152 size 32768 starting block 13297984)
> [87075.131066] md3: WRITE SAME failed. Manually zeroing.
> [87075.882311] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87075.882315] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87075.882317] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87076.112414] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87076.112420] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87076.376237] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87077.125919] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87077.375298] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87077.624677] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87077.624693] sd 0:0:4:0: [sde] Unhandled error code
> [87077.624695] sd 0:0:4:0: [sde]
> [87077.624703] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87077.624705] sd 0:0:4:0: [sde] CDB:
> [87077.624706] Write(10): 2a 00 06 57 52 40 00 00 80 00
> [87077.624714] end_request: I/O error, dev sde, sector 106385984
> [87077.624771] Buffer I/O error on device md3, logical block 13297992
> [87077.624777] Buffer I/O error on device md3, logical block 13297993
> [87077.624778] Buffer I/O error on device md3, logical block 13297994
> [87077.624780] Buffer I/O error on device md3, logical block 13297995
> [87077.624782] Buffer I/O error on device md3, logical block 13297996
> [87077.624784] Buffer I/O error on device md3, logical block 13297997
> [87077.624786] Buffer I/O error on device md3, logical block 13297998
> [87077.624788] Buffer I/O error on device md3, logical block 13297999
> [87077.624792] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673460 (offset 3145728 size 32768 starting block 13297992)
> [87077.624816] md3: WRITE SAME failed. Manually zeroing.
> [87078.381229] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87078.381232] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87078.381236] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87078.623193] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87078.871578] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87079.619710] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87079.869044] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87080.118462] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87080.118478] sd 0:0:4:0: [sde] Unhandled error code
> [87080.118480] sd 0:0:4:0: [sde]
> [87080.118481] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87080.118483] sd 0:0:4:0: [sde] CDB:
> [87080.118485] Write(10): 2a 00 06 57 52 80 00 00 80 00
> [87080.118493] end_request: I/O error, dev sde, sector 106386048
> [87080.118544] Buffer I/O error on device md3, logical block 13298000
> [87080.118548] Buffer I/O error on device md3, logical block 13298001
> [87080.118550] Buffer I/O error on device md3, logical block 13298002
> [87080.118552] Buffer I/O error on device md3, logical block 13298003
> [87080.118554] Buffer I/O error on device md3, logical block 13298004
> [87080.118556] Buffer I/O error on device md3, logical block 13298005
> [87080.118557] Buffer I/O error on device md3, logical block 13298006
> [87080.118559] Buffer I/O error on device md3, logical block 13298007
> [87080.118564] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673460 (offset 4194304 size 32768 starting block 13298000)
> [87080.118583] md3: WRITE SAME failed. Manually zeroing.
> [87200.658907] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87200.817183] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87201.066578] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87201.814734] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87202.064100] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87202.313410] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87202.313435] sd 0:0:4:0: [sde] Unhandled error code
> [87202.313440] sd 0:0:4:0: [sde]
> [87202.313441] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87202.313446] sd 0:0:4:0: [sde] CDB:
> [87202.313448] Write(10): 2a 00 07 c2 d0 a0 00 03 c0 00
> [87202.313456] end_request: I/O error, dev sde, sector 130207904
> [87202.313503] Buffer I/O error on device md3, logical block 16275732
> [87202.313512] Buffer I/O error on device md3, logical block 16275733
> [87202.313515] Buffer I/O error on device md3, logical block 16275734
> [87202.313517] Buffer I/O error on device md3, logical block 16275735
> [87202.313518] Buffer I/O error on device md3, logical block 16275736
> [87202.313520] Buffer I/O error on device md3, logical block 16275737
> [87202.313522] Buffer I/O error on device md3, logical block 16275738
> [87202.313524] Buffer I/O error on device md3, logical block 16275739
> [87202.313525] Buffer I/O error on device md3, logical block 16275740
> [87202.313527] Buffer I/O error on device md3, logical block 16275741
> [87202.313529] Buffer I/O error on device md3, logical block 16275742
> [87202.313531] Buffer I/O error on device md3, logical block 16275743
> [87202.313532] Buffer I/O error on device md3, logical block 16275744
> [87202.313534] Buffer I/O error on device md3, logical block 16275745
> [87202.313536] Buffer I/O error on device md3, logical block 16275746
> [87202.313538] Buffer I/O error on device md3, logical block 16275747
> [87202.313539] Buffer I/O error on device md3, logical block 16275748
> [87202.313541] Buffer I/O error on device md3, logical block 16275749
> [87202.313543] Buffer I/O error on device md3, logical block 16275750
> [87202.313544] Buffer I/O error on device md3, logical block 16275751
> [87202.313546] Buffer I/O error on device md3, logical block 16275752
> [87202.313548] Buffer I/O error on device md3, logical block 16275753
> [87202.313549] Buffer I/O error on device md3, logical block 16275754
> [87202.313551] Buffer I/O error on device md3, logical block 16275755
> [87202.313553] Buffer I/O error on device md3, logical block 16275756
> [87202.313554] Buffer I/O error on device md3, logical block 16275757
> [87202.313556] Buffer I/O error on device md3, logical block 16275758
> [87202.313558] Buffer I/O error on device md3, logical block 16275759
> [87202.313559] Buffer I/O error on device md3, logical block 16275760
> [87202.313561] Buffer I/O error on device md3, logical block 16275761
> [87202.313562] Buffer I/O error on device md3, logical block 16275762
> [87202.313564] Buffer I/O error on device md3, logical block 16275763
> [87202.313566] Buffer I/O error on device md3, logical block 16275764
> [87202.313567] Buffer I/O error on device md3, logical block 16275765
> [87202.313569] Buffer I/O error on device md3, logical block 16275766
> [87202.313571] Buffer I/O error on device md3, logical block 16275767
> [87202.313573] Buffer I/O error on device md3, logical block 16275768
> [87202.313574] Buffer I/O error on device md3, logical block 16275769
> [87202.313576] Buffer I/O error on device md3, logical block 16275770
> [87202.313577] Buffer I/O error on device md3, logical block 16275771
> [87202.313579] Buffer I/O error on device md3, logical block 16275772
> [87202.313581] Buffer I/O error on device md3, logical block 16275773
> [87202.313582] Buffer I/O error on device md3, logical block 16275774
> [87202.313584] Buffer I/O error on device md3, logical block 16275775
> [87202.313585] Buffer I/O error on device md3, logical block 16275776
> [87202.313587] Buffer I/O error on device md3, logical block 16275777
> [87202.313589] Buffer I/O error on device md3, logical block 16275778
> [87202.313590] Buffer I/O error on device md3, logical block 16275779
> [87202.313592] Buffer I/O error on device md3, logical block 16275780
> [87202.313594] Buffer I/O error on device md3, logical block 16275781
> [87202.313596] Buffer I/O error on device md3, logical block 16275782
> [87202.313597] Buffer I/O error on device md3, logical block 16275783
> [87202.313599] Buffer I/O error on device md3, logical block 16275784
> [87202.313601] Buffer I/O error on device md3, logical block 16275785
> [87202.313607] Buffer I/O error on device md3, logical block 16275786
> [87202.313609] Buffer I/O error on device md3, logical block 16275787
> [87202.313611] Buffer I/O error on device md3, logical block 16275788
> [87202.313612] Buffer I/O error on device md3, logical block 16275789
> [87202.313616] Buffer I/O error on device md3, logical block 16275790
> [87202.313619] Buffer I/O error on device md3, logical block 16275791
> [87202.313620] Buffer I/O error on device md3, logical block 16275792
> [87202.313622] Buffer I/O error on device md3, logical block 16275793
> [87202.313624] Buffer I/O error on device md3, logical block 16275794
> [87202.313625] Buffer I/O error on device md3, logical block 16275795
> [87202.313627] Buffer I/O error on device md3, logical block 16275796
> [87202.313628] Buffer I/O error on device md3, logical block 16275797
> [87202.313630] Buffer I/O error on device md3, logical block 16275798
> [87202.313632] Buffer I/O error on device md3, logical block 16275799
> [87202.313633] Buffer I/O error on device md3, logical block 16275800
> [87202.313635] Buffer I/O error on device md3, logical block 16275801
> [87202.313636] Buffer I/O error on device md3, logical block 16275802
> [87202.313638] Buffer I/O error on device md3, logical block 16275803
> [87202.313639] Buffer I/O error on device md3, logical block 16275804
> [87202.313641] Buffer I/O error on device md3, logical block 16275805
> [87202.313643] Buffer I/O error on device md3, logical block 16275806
> [87202.313644] Buffer I/O error on device md3, logical block 16275807
> [87202.313646] Buffer I/O error on device md3, logical block 16275808
> [87202.313647] Buffer I/O error on device md3, logical block 16275809
> [87202.313649] Buffer I/O error on device md3, logical block 16275810
> [87202.313651] Buffer I/O error on device md3, logical block 16275811
> [87202.313652] Buffer I/O error on device md3, logical block 16275812
> [87202.313654] Buffer I/O error on device md3, logical block 16275813
> [87202.313656] Buffer I/O error on device md3, logical block 16275814
> [87202.313657] Buffer I/O error on device md3, logical block 16275815
> [87202.313659] Buffer I/O error on device md3, logical block 16275816
> [87202.313660] Buffer I/O error on device md3, logical block 16275817
> [87202.313662] Buffer I/O error on device md3, logical block 16275818
> [87202.313664] Buffer I/O error on device md3, logical block 16275819
> [87202.313665] Buffer I/O error on device md3, logical block 16275820
> [87202.313667] Buffer I/O error on device md3, logical block 16275821
> [87202.313669] Buffer I/O error on device md3, logical block 16275822
> [87202.313670] Buffer I/O error on device md3, logical block 16275823
> [87202.313672] Buffer I/O error on device md3, logical block 16275824
> [87202.313673] Buffer I/O error on device md3, logical block 16275825
> [87202.313675] Buffer I/O error on device md3, logical block 16275826
> [87202.313677] Buffer I/O error on device md3, logical block 16275827
> [87202.313678] Buffer I/O error on device md3, logical block 16275828
> [87202.313680] Buffer I/O error on device md3, logical block 16275829
> [87202.313682] Buffer I/O error on device md3, logical block 16275830
> [87202.313683] Buffer I/O error on device md3, logical block 16275831
> [87202.313685] Buffer I/O error on device md3, logical block 16275832
> [87202.313687] Buffer I/O error on device md3, logical block 16275833
> [87202.313694] Buffer I/O error on device md3, logical block 16275834
> [87202.313696] Buffer I/O error on device md3, logical block 16275835
> [87202.313697] Buffer I/O error on device md3, logical block 16275836
> [87202.313699] Buffer I/O error on device md3, logical block 16275837
> [87202.313701] Buffer I/O error on device md3, logical block 16275838
> [87202.313702] Buffer I/O error on device md3, logical block 16275839
> [87202.313704] Buffer I/O error on device md3, logical block 16275840
> [87202.313706] Buffer I/O error on device md3, logical block 16275841
> [87202.313707] Buffer I/O error on device md3, logical block 16275842
> [87202.313709] Buffer I/O error on device md3, logical block 16275843
> [87202.313713] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673460 (offset 5832704 size 458752 starting block 16275732)
> [87202.313735] md3: WRITE SAME failed. Manually zeroing.
> [87203.085932] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87203.311030] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87203.560379] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87204.308511] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87204.557908] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87204.807280] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87204.807297] sd 0:0:4:0: [sde] Unhandled error code
> [87204.807299] sd 0:0:4:0: [sde]
> [87204.807301] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87204.807303] sd 0:0:4:0: [sde] CDB:
> [87204.807304] Write(10): 2a 00 07 c2 d8 60 00 04 00 00
> [87204.807312] end_request: I/O error, dev sde, sector 130209888
> [87204.807355] Buffer I/O error on device md3, logical block 16275980
> [87204.807360] Buffer I/O error on device md3, logical block 16275981
> [87204.807362] Buffer I/O error on device md3, logical block 16275982
> [87204.807364] Buffer I/O error on device md3, logical block 16275983
> [87204.807366] Buffer I/O error on device md3, logical block 16275984
> [87204.807367] Buffer I/O error on device md3, logical block 16275985
> [87204.807369] Buffer I/O error on device md3, logical block 16275986
> [87204.807371] Buffer I/O error on device md3, logical block 16275987
> [87204.807372] Buffer I/O error on device md3, logical block 16275988
> [87204.807374] Buffer I/O error on device md3, logical block 16275989
> [87204.807376] Buffer I/O error on device md3, logical block 16275990
> [87204.807377] Buffer I/O error on device md3, logical block 16275991
> [87204.807379] Buffer I/O error on device md3, logical block 16275992
> [87204.807381] Buffer I/O error on device md3, logical block 16275993
> [87204.807382] Buffer I/O error on device md3, logical block 16275994
> [87204.807384] Buffer I/O error on device md3, logical block 16275995
> [87204.807386] Buffer I/O error on device md3, logical block 16275996
> [87204.807387] Buffer I/O error on device md3, logical block 16275997
> [87204.807389] Buffer I/O error on device md3, logical block 16275998
> [87204.807391] Buffer I/O error on device md3, logical block 16275999
> [87204.807392] Buffer I/O error on device md3, logical block 16276000
> [87204.807394] Buffer I/O error on device md3, logical block 16276001
> [87204.807396] Buffer I/O error on device md3, logical block 16276002
> [87204.807397] Buffer I/O error on device md3, logical block 16276003
> [87204.807399] Buffer I/O error on device md3, logical block 16276004
> [87204.807401] Buffer I/O error on device md3, logical block 16276005
> [87204.807402] Buffer I/O error on device md3, logical block 16276006
> [87204.807404] Buffer I/O error on device md3, logical block 16276007
> [87204.807406] Buffer I/O error on device md3, logical block 16276008
> [87204.807407] Buffer I/O error on device md3, logical block 16276009
> [87204.807409] Buffer I/O error on device md3, logical block 16276010
> [87204.807411] Buffer I/O error on device md3, logical block 16276011
> [87204.807412] Buffer I/O error on device md3, logical block 16276012
> [87204.807414] Buffer I/O error on device md3, logical block 16276013
> [87204.807416] Buffer I/O error on device md3, logical block 16276014
> [87204.807417] Buffer I/O error on device md3, logical block 16276015
> [87204.807419] Buffer I/O error on device md3, logical block 16276016
> [87204.807421] Buffer I/O error on device md3, logical block 16276017
> [87204.807422] Buffer I/O error on device md3, logical block 16276018
> [87204.807424] Buffer I/O error on device md3, logical block 16276019
> [87204.807425] Buffer I/O error on device md3, logical block 16276020
> [87204.807427] Buffer I/O error on device md3, logical block 16276021
> [87204.807429] Buffer I/O error on device md3, logical block 16276022
> [87204.807433] Buffer I/O error on device md3, logical block 16276023
> [87204.807435] Buffer I/O error on device md3, logical block 16276024
> [87204.807437] Buffer I/O error on device md3, logical block 16276025
> [87204.807439] Buffer I/O error on device md3, logical block 16276026
> [87204.807441] Buffer I/O error on device md3, logical block 16276027
> [87204.807442] Buffer I/O error on device md3, logical block 16276028
> [87204.807444] Buffer I/O error on device md3, logical block 16276029
> [87204.807446] Buffer I/O error on device md3, logical block 16276030
> [87204.807447] Buffer I/O error on device md3, logical block 16276031
> [87204.807449] Buffer I/O error on device md3, logical block 16276032
> [87204.807451] Buffer I/O error on device md3, logical block 16276033
> [87204.807452] Buffer I/O error on device md3, logical block 16276034
> [87204.807454] Buffer I/O error on device md3, logical block 16276035
> [87204.807456] Buffer I/O error on device md3, logical block 16276036
> [87204.807457] Buffer I/O error on device md3, logical block 16276037
> [87204.807459] Buffer I/O error on device md3, logical block 16276038
> [87204.807461] Buffer I/O error on device md3, logical block 16276039
> [87204.807462] Buffer I/O error on device md3, logical block 16276040
> [87204.807464] Buffer I/O error on device md3, logical block 16276041
> [87204.807466] Buffer I/O error on device md3, logical block 16276042
> [87204.807467] Buffer I/O error on device md3, logical block 16276043
> [87204.807469] Buffer I/O error on device md3, logical block 16276044
> [87204.807471] Buffer I/O error on device md3, logical block 16276045
> [87204.807472] Buffer I/O error on device md3, logical block 16276046
> [87204.807474] Buffer I/O error on device md3, logical block 16276047
> [87204.807475] Buffer I/O error on device md3, logical block 16276048
> [87204.807477] Buffer I/O error on device md3, logical block 16276049
> [87204.807479] Buffer I/O error on device md3, logical block 16276050
> [87204.807480] Buffer I/O error on device md3, logical block 16276051
> [87204.807482] Buffer I/O error on device md3, logical block 16276052
> [87204.807484] Buffer I/O error on device md3, logical block 16276053
> [87204.807485] Buffer I/O error on device md3, logical block 16276054
> [87204.807487] Buffer I/O error on device md3, logical block 16276055
> [87204.807489] Buffer I/O error on device md3, logical block 16276056
> [87204.807490] Buffer I/O error on device md3, logical block 16276057
> [87204.807492] Buffer I/O error on device md3, logical block 16276058
> [87204.807494] Buffer I/O error on device md3, logical block 16276059
> [87204.807495] Buffer I/O error on device md3, logical block 16276060
> [87204.807497] Buffer I/O error on device md3, logical block 16276061
> [87204.807498] Buffer I/O error on device md3, logical block 16276062
> [87204.807500] Buffer I/O error on device md3, logical block 16276063
> [87204.807502] Buffer I/O error on device md3, logical block 16276064
> [87204.807503] Buffer I/O error on device md3, logical block 16276065
> [87204.807505] Buffer I/O error on device md3, logical block 16276066
> [87204.807507] Buffer I/O error on device md3, logical block 16276067
> [87204.807508] Buffer I/O error on device md3, logical block 16276068
> [87204.807510] Buffer I/O error on device md3, logical block 16276069
> [87204.807511] Buffer I/O error on device md3, logical block 16276070
> [87204.807513] Buffer I/O error on device md3, logical block 16276071
> [87204.807514] Buffer I/O error on device md3, logical block 16276072
> [87204.807516] Buffer I/O error on device md3, logical block 16276073
> [87204.807518] Buffer I/O error on device md3, logical block 16276074
> [87204.807519] Buffer I/O error on device md3, logical block 16276075
> [87204.807521] Buffer I/O error on device md3, logical block 16276076
> [87204.807523] Buffer I/O error on device md3, logical block 16276077
> [87204.807525] Buffer I/O error on device md3, logical block 16276078
> [87204.807526] Buffer I/O error on device md3, logical block 16276079
> [87204.807530] Buffer I/O error on device md3, logical block 16276080
> [87204.807533] Buffer I/O error on device md3, logical block 16276081
> [87204.807534] Buffer I/O error on device md3, logical block 16276082
> [87204.807536] Buffer I/O error on device md3, logical block 16276083
> [87204.807538] Buffer I/O error on device md3, logical block 16276084
> [87204.807540] Buffer I/O error on device md3, logical block 16276085
> [87204.807541] Buffer I/O error on device md3, logical block 16276086
> [87204.807543] Buffer I/O error on device md3, logical block 16276087
> [87204.807545] Buffer I/O error on device md3, logical block 16276088
> [87204.807547] Buffer I/O error on device md3, logical block 16276089
> [87204.807548] Buffer I/O error on device md3, logical block 16276090
> [87204.807550] Buffer I/O error on device md3, logical block 16276091
> [87204.807552] Buffer I/O error on device md3, logical block 16276092
> [87204.807553] Buffer I/O error on device md3, logical block 16276093
> [87204.807555] Buffer I/O error on device md3, logical block 16276094
> [87204.807557] Buffer I/O error on device md3, logical block 16276095
> [87204.807559] Buffer I/O error on device md3, logical block 16276096
> [87204.807561] Buffer I/O error on device md3, logical block 16276097
> [87204.807562] Buffer I/O error on device md3, logical block 16276098
> [87204.807564] Buffer I/O error on device md3, logical block 16276099
> [87204.807568] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673460 (offset 6848512 size 491520 starting block 16275980)
> [87204.807596] md3: WRITE SAME failed. Manually zeroing.
> [87205.574898] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87205.803861] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87206.053269] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87206.801394] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87207.050759] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87207.300105] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87207.300123] sd 0:0:4:0: [sde] Unhandled error code
> [87207.300125] sd 0:0:4:0: [sde]
> [87207.300127] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87207.300129] sd 0:0:4:0: [sde] CDB:
> [87207.300130] Write(10): 2a 00 07 c4 43 40 00 00 40 00
> [87207.300138] end_request: I/O error, dev sde, sector 130302784
> [87207.300199] md3: WRITE SAME failed. Manually zeroing.
> [87208.112799] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87208.297645] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87208.547010] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87209.295116] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87209.544493] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87209.793873] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87209.793890] sd 0:0:4:0: [sde] Unhandled error code
> [87209.793892] sd 0:0:4:0: [sde]
> [87209.793893] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87209.793895] sd 0:0:4:0: [sde] CDB:
> [87209.793897] Write(10): 2a 00 07 c5 55 40 00 00 40 00
> [87209.793905] end_request: I/O error, dev sde, sector 130372928
> [87209.793964] md3: WRITE SAME failed. Manually zeroing.
> [87210.577584] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87210.791390] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87211.040757] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87211.788908] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87212.038250] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87212.287623] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87212.287779] sd 0:0:4:0: [sde] Unhandled error code
> [87212.287781] sd 0:0:4:0: [sde]
> [87212.287782] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87212.287784] sd 0:0:4:0: [sde] CDB:
> [87212.287786] Write(10): 2a 00 07 c4 43 80 00 00 40 00
> [87212.287793] end_request: I/O error, dev sde, sector 130302848
> [87212.287851] md3: WRITE SAME failed. Manually zeroing.
> [87213.061013] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87213.285138] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87213.534508] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87214.282688] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87214.532027] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87214.781370] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87214.781389] sd 0:0:4:0: [sde] Unhandled error code
> [87214.781391] sd 0:0:4:0: [sde]
> [87214.781393] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87214.781395] sd 0:0:4:0: [sde] CDB:
> [87214.781396] Write(10): 2a 00 07 c4 43 c0 00 00 40 00
> [87214.781404] end_request: I/O error, dev sde, sector 130302912
> [87214.781475] md3: WRITE SAME failed. Manually zeroing.
> [87238.595459] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87238.722439] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87238.971764] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87239.719882] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87239.969242] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87240.218632] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87240.218649] sd 0:0:4:0: [sde] Unhandled error code
> [87240.218651] sd 0:0:4:0: [sde]
> [87240.218653] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87240.218655] sd 0:0:4:0: [sde] CDB:
> [87240.218661] Write(10): 2a 00 0b 42 ba f0 00 04 00 00
> [87240.218670] end_request: I/O error, dev sde, sector 188922608
> [87240.218732] Buffer I/O error on device md3, logical block 23615070
> [87240.218740] Buffer I/O error on device md3, logical block 23615071
> [87240.218741] Buffer I/O error on device md3, logical block 23615072
> [87240.218743] Buffer I/O error on device md3, logical block 23615073
> [87240.218745] Buffer I/O error on device md3, logical block 23615074
> [87240.218746] Buffer I/O error on device md3, logical block 23615075
> [87240.218748] Buffer I/O error on device md3, logical block 23615076
> [87240.218750] Buffer I/O error on device md3, logical block 23615077
> [87240.218752] Buffer I/O error on device md3, logical block 23615078
> [87240.218754] Buffer I/O error on device md3, logical block 23615079
> [87240.218756] Buffer I/O error on device md3, logical block 23615080
> [87240.218758] Buffer I/O error on device md3, logical block 23615081
> [87240.218759] Buffer I/O error on device md3, logical block 23615082
> [87240.218761] Buffer I/O error on device md3, logical block 23615083
> [87240.218763] Buffer I/O error on device md3, logical block 23615084
> [87240.218764] Buffer I/O error on device md3, logical block 23615085
> [87240.218766] Buffer I/O error on device md3, logical block 23615086
> [87240.218768] Buffer I/O error on device md3, logical block 23615087
> [87240.218769] Buffer I/O error on device md3, logical block 23615088
> [87240.218781] Buffer I/O error on device md3, logical block 23615089
> [87240.218784] Buffer I/O error on device md3, logical block 23615090
> [87240.218786] Buffer I/O error on device md3, logical block 23615091
> [87240.218788] Buffer I/O error on device md3, logical block 23615092
> [87240.218789] Buffer I/O error on device md3, logical block 23615093
> [87240.218791] Buffer I/O error on device md3, logical block 23615094
> [87240.218793] Buffer I/O error on device md3, logical block 23615095
> [87240.218795] Buffer I/O error on device md3, logical block 23615096
> [87240.218796] Buffer I/O error on device md3, logical block 23615097
> [87240.218798] Buffer I/O error on device md3, logical block 23615098
> [87240.218800] Buffer I/O error on device md3, logical block 23615099
> [87240.218801] Buffer I/O error on device md3, logical block 23615100
> [87240.218803] Buffer I/O error on device md3, logical block 23615101
> [87240.218805] Buffer I/O error on device md3, logical block 23615102
> [87240.218806] Buffer I/O error on device md3, logical block 23615103
> [87240.218812] Buffer I/O error on device md3, logical block 23615104
> [87240.218814] Buffer I/O error on device md3, logical block 23615105
> [87240.218815] Buffer I/O error on device md3, logical block 23615106
> [87240.218817] Buffer I/O error on device md3, logical block 23615107
> [87240.218819] Buffer I/O error on device md3, logical block 23615108
> [87240.218820] Buffer I/O error on device md3, logical block 23615109
> [87240.218822] Buffer I/O error on device md3, logical block 23615110
> [87240.218824] Buffer I/O error on device md3, logical block 23615111
> [87240.218825] Buffer I/O error on device md3, logical block 23615112
> [87240.218827] Buffer I/O error on device md3, logical block 23615113
> [87240.218829] Buffer I/O error on device md3, logical block 23615114
> [87240.218830] Buffer I/O error on device md3, logical block 23615115
> [87240.218832] Buffer I/O error on device md3, logical block 23615116
> [87240.218834] Buffer I/O error on device md3, logical block 23615117
> [87240.218835] Buffer I/O error on device md3, logical block 23615118
> [87240.218837] Buffer I/O error on device md3, logical block 23615119
> [87240.218839] Buffer I/O error on device md3, logical block 23615120
> [87240.218840] Buffer I/O error on device md3, logical block 23615121
> [87240.218842] Buffer I/O error on device md3, logical block 23615122
> [87240.218843] Buffer I/O error on device md3, logical block 23615123
> [87240.218845] Buffer I/O error on device md3, logical block 23615124
> [87240.218847] Buffer I/O error on device md3, logical block 23615125
> [87240.218848] Buffer I/O error on device md3, logical block 23615126
> [87240.218850] Buffer I/O error on device md3, logical block 23615127
> [87240.218852] Buffer I/O error on device md3, logical block 23615128
> [87240.218853] Buffer I/O error on device md3, logical block 23615129
> [87240.218855] Buffer I/O error on device md3, logical block 23615130
> [87240.218857] Buffer I/O error on device md3, logical block 23615131
> [87240.218858] Buffer I/O error on device md3, logical block 23615132
> [87240.218860] Buffer I/O error on device md3, logical block 23615133
> [87240.218862] Buffer I/O error on device md3, logical block 23615134
> [87240.218863] Buffer I/O error on device md3, logical block 23615135
> [87240.218865] Buffer I/O error on device md3, logical block 23615136
> [87240.218866] Buffer I/O error on device md3, logical block 23615137
> [87240.218868] Buffer I/O error on device md3, logical block 23615138
> [87240.218870] Buffer I/O error on device md3, logical block 23615139
> [87240.218871] Buffer I/O error on device md3, logical block 23615140
> [87240.218873] Buffer I/O error on device md3, logical block 23615141
> [87240.218875] Buffer I/O error on device md3, logical block 23615142
> [87240.218876] Buffer I/O error on device md3, logical block 23615143
> [87240.218878] Buffer I/O error on device md3, logical block 23615144
> [87240.218879] Buffer I/O error on device md3, logical block 23615145
> [87240.218884] Buffer I/O error on device md3, logical block 23615146
> [87240.218886] Buffer I/O error on device md3, logical block 23615147
> [87240.218888] Buffer I/O error on device md3, logical block 23615148
> [87240.218890] Buffer I/O error on device md3, logical block 23615149
> [87240.218892] Buffer I/O error on device md3, logical block 23615150
> [87240.218893] Buffer I/O error on device md3, logical block 23615151
> [87240.218895] Buffer I/O error on device md3, logical block 23615152
> [87240.218897] Buffer I/O error on device md3, logical block 23615153
> [87240.218898] Buffer I/O error on device md3, logical block 23615154
> [87240.218900] Buffer I/O error on device md3, logical block 23615155
> [87240.218902] Buffer I/O error on device md3, logical block 23615156
> [87240.218903] Buffer I/O error on device md3, logical block 23615157
> [87240.218905] Buffer I/O error on device md3, logical block 23615158
> [87240.218906] Buffer I/O error on device md3, logical block 23615159
> [87240.218908] Buffer I/O error on device md3, logical block 23615160
> [87240.218910] Buffer I/O error on device md3, logical block 23615161
> [87240.218911] Buffer I/O error on device md3, logical block 23615162
> [87240.218913] Buffer I/O error on device md3, logical block 23615163
> [87240.218915] Buffer I/O error on device md3, logical block 23615164
> [87240.218916] Buffer I/O error on device md3, logical block 23615165
> [87240.218918] Buffer I/O error on device md3, logical block 23615166
> [87240.218919] Buffer I/O error on device md3, logical block 23615167
> [87240.218921] Buffer I/O error on device md3, logical block 23615168
> [87240.218922] Buffer I/O error on device md3, logical block 23615169
> [87240.218924] Buffer I/O error on device md3, logical block 23615170
> [87240.218926] Buffer I/O error on device md3, logical block 23615171
> [87240.218927] Buffer I/O error on device md3, logical block 23615172
> [87240.218929] Buffer I/O error on device md3, logical block 23615173
> [87240.218930] Buffer I/O error on device md3, logical block 23615174
> [87240.218932] Buffer I/O error on device md3, logical block 23615175
> [87240.218934] Buffer I/O error on device md3, logical block 23615176
> [87240.218935] Buffer I/O error on device md3, logical block 23615177
> [87240.218937] Buffer I/O error on device md3, logical block 23615178
> [87240.218939] Buffer I/O error on device md3, logical block 23615179
> [87240.218941] Buffer I/O error on device md3, logical block 23615180
> [87240.218942] Buffer I/O error on device md3, logical block 23615181
> [87240.218944] Buffer I/O error on device md3, logical block 23615182
> [87240.218946] Buffer I/O error on device md3, logical block 23615183
> [87240.218948] Buffer I/O error on device md3, logical block 23615184
> [87240.218949] Buffer I/O error on device md3, logical block 23615185
> [87240.218951] Buffer I/O error on device md3, logical block 23615186
> [87240.218953] Buffer I/O error on device md3, logical block 23615187
> [87240.218954] Buffer I/O error on device md3, logical block 23615188
> [87240.218956] Buffer I/O error on device md3, logical block 23615189
> [87240.218960] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673460 (offset 12091392 size 491520 starting block 23615070)
> [87240.219008] md3: WRITE SAME failed. Manually zeroing.
> [87245.765556] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87245.953374] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87246.202749] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87246.950900] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87247.200293] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87247.449656] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87247.449676] sd 0:0:4:0: [sde] Unhandled error code
> [87247.449678] sd 0:0:4:0: [sde]
> [87247.449684] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87247.449686] sd 0:0:4:0: [sde] CDB:
> [87247.449688] Write(10): 2a 00 47 1b dc 70 00 00 08 00
> [87247.449694] end_request: I/O error, dev sde, sector 1193008240
> [87247.449765] md3: WRITE SAME failed. Manually zeroing.
> [87256.365380] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87256.421712] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87256.421714] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87256.668017] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87257.409842] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87257.666269] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87257.666272] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87257.916815] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87257.916818] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87257.916836] sd 0:0:4:0: [sde] Unhandled error code
> [87257.916838] sd 0:0:4:0: [sde]
> [87257.916840] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87257.916842] sd 0:0:4:0: [sde] CDB:
> [87257.916843] Write(10): 2a 00 0b 42 c6 30 00 00 c0 00
> [87257.916851] end_request: I/O error, dev sde, sector 188925488
> [87257.916914] Buffer I/O error on device md3, logical block 23615430
> [87257.916920] Buffer I/O error on device md3, logical block 23615431
> [87257.916922] Buffer I/O error on device md3, logical block 23615432
> [87257.916924] Buffer I/O error on device md3, logical block 23615433
> [87257.916925] Buffer I/O error on device md3, logical block 23615434
> [87257.916927] Buffer I/O error on device md3, logical block 23615435
> [87257.916929] Buffer I/O error on device md3, logical block 23615436
> [87257.916931] Buffer I/O error on device md3, logical block 23615437
> [87257.916932] Buffer I/O error on device md3, logical block 23615438
> [87257.916934] Buffer I/O error on device md3, logical block 23615439
> [87257.916936] Buffer I/O error on device md3, logical block 23615440
> [87257.916937] Buffer I/O error on device md3, logical block 23615441
> [87257.916939] Buffer I/O error on device md3, logical block 23615442
> [87257.916940] Buffer I/O error on device md3, logical block 23615443
> [87257.916942] Buffer I/O error on device md3, logical block 23615444
> [87257.916944] Buffer I/O error on device md3, logical block 23615445
> [87257.916948] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673460 (offset 13565952 size 65536 starting block 23615430)
> [87257.916963] md3: WRITE SAME failed. Manually zeroing.
> [87274.606492] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87274.880956] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87275.629086] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87275.878480] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87276.127828] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87276.876003] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87276.876019] sd 0:0:4:0: [sde] Unhandled error code
> [87276.876021] sd 0:0:4:0: [sde]
> [87276.876023] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87276.876024] sd 0:0:4:0: [sde] CDB:
> [87276.876026] Write(10): 2a 00 0b 42 ce b0 00 00 40 00
> [87276.876034] end_request: I/O error, dev sde, sector 188927664
> [87276.876097] md3: WRITE SAME failed. Manually zeroing.
> [87289.014408] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87289.095550] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87289.344927] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87290.093054] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87290.342448] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87290.591807] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87290.591825] sd 0:0:4:0: [sde] Unhandled error code
> [87290.591827] sd 0:0:4:0: [sde]
> [87290.591829] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87290.591831] sd 0:0:4:0: [sde] CDB:
> [87290.591832] Write(10): 2a 00 0b 42 d5 f0 00 01 00 00
> [87290.591840] end_request: I/O error, dev sde, sector 188929520
> [87290.591893] Buffer I/O error on device md3, logical block 23615934
> [87290.591897] Buffer I/O error on device md3, logical block 23615935
> [87290.591899] Buffer I/O error on device md3, logical block 23615936
> [87290.591900] Buffer I/O error on device md3, logical block 23615937
> [87290.591902] Buffer I/O error on device md3, logical block 23615938
> [87290.591904] Buffer I/O error on device md3, logical block 23615939
> [87290.591905] Buffer I/O error on device md3, logical block 23615940
> [87290.591907] Buffer I/O error on device md3, logical block 23615941
> [87290.591909] Buffer I/O error on device md3, logical block 23615942
> [87290.591911] Buffer I/O error on device md3, logical block 23615943
> [87290.591912] Buffer I/O error on device md3, logical block 23615944
> [87290.591914] Buffer I/O error on device md3, logical block 23615945
> [87290.591916] Buffer I/O error on device md3, logical block 23615946
> [87290.591917] Buffer I/O error on device md3, logical block 23615947
> [87290.591919] Buffer I/O error on device md3, logical block 23615948
> [87290.591920] Buffer I/O error on device md3, logical block 23615949
> [87290.591922] Buffer I/O error on device md3, logical block 23615950
> [87290.591924] Buffer I/O error on device md3, logical block 23615951
> [87290.591926] Buffer I/O error on device md3, logical block 23615952
> [87290.591927] Buffer I/O error on device md3, logical block 23615953
> [87290.591929] Buffer I/O error on device md3, logical block 23615954
> [87290.591931] Buffer I/O error on device md3, logical block 23615955
> [87290.591933] Buffer I/O error on device md3, logical block 23615956
> [87290.591934] Buffer I/O error on device md3, logical block 23615957
> [87290.591938] EXT4-fs warning (device md3): ext4_end_bio:317: I/O error writing to inode 43673460 (offset 15630336 size 98304 starting block 23615934)
> [87290.591952] md3: WRITE SAME failed. Manually zeroing.
> [87298.996452] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87299.070413] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87299.261571] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87299.327959] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87299.327961] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87300.054919] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87300.305261] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87300.305265] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87300.305280] sd 0:0:4:0: [sde] Unhandled error code
> [87300.305283] sd 0:0:4:0: [sde]
> [87300.305284] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87300.305286] sd 0:0:4:0: [sde] CDB:
> [87300.305287] Write(10): 2a 00 47 1b e7 c0 00 00 28 00
> [87300.305295] end_request: I/O error, dev sde, sector 1193011136
> [87300.305363] md3: WRITE SAME failed. Manually zeroing.
> [87308.776789] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87309.045482] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87309.294834] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87310.042973] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87310.292336] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87310.541740] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87310.541761] sd 0:0:4:0: [sde] Unhandled error code
> [87310.541763] sd 0:0:4:0: [sde]
> [87310.541764] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87310.541765] sd 0:0:4:0: [sde] CDB:
> [87310.541766] Write(10): 2a 00 47 1b e7 e8 00 00 18 00
> [87310.541773] end_request: I/O error, dev sde, sector 1193011176
> [87310.541832] md3: WRITE SAME failed. Manually zeroing.
> [87311.302882] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87311.302888] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87311.526254] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87311.786125] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87311.786131] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87312.523028] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87312.773493] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87312.773496] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87313.025342] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87313.025345] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87313.025370] sd 0:0:4:0: [sde] Unhandled error code
> [87313.025371] sd 0:0:4:0: [sde]
> [87313.025372] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87313.025374] sd 0:0:4:0: [sde] CDB:
> [87313.025375] Write(10): 2a 00 47 1b e9 c0 00 00 18 00
> [87313.025382] end_request: I/O error, dev sde, sector 1193011648
> [87313.025439] md3: WRITE SAME failed. Manually zeroing.
> [87313.898904] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87313.898907] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87314.025543] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87314.281657] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87315.029792] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87315.279157] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87315.528558] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87315.528578] sd 0:0:4:0: [sde] Unhandled error code
> [87315.528580] sd 0:0:4:0: [sde]
> [87315.528581] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87315.528582] sd 0:0:4:0: [sde] CDB:
> [87315.528583] Write(10): 2a 00 47 1b cf a0 00 00 10 00
> [87315.528590] end_request: I/O error, dev sde, sector 1193004960
> [87315.528677] md3: WRITE SAME failed. Manually zeroing.
> [87316.307061] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87316.307065] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87316.532650] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87316.532654] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87316.703369] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87316.703373] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87316.776276] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87316.776279] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87317.511771] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87317.511774] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87317.763712] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87317.763717] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> [87317.763734] sd 0:0:4:0: [sde] Unhandled error code
> [87317.763737] sd 0:0:4:0: [sde]
> [87317.763738] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> [87317.763740] sd 0:0:4:0: [sde] CDB:
> [87317.763741] Write(10): 2a 00 47 1b ea 98 00 00 28 00
> [87317.763749] end_request: I/O error, dev sde, sector 1193011864
> [87317.763819] md3: WRITE SAME failed. Manually zeroing.
> ----------------------------------------------------------------------
>
>
> ----------------------------------------------------------------------
> smartctl -x output of drive sde
> ----------------------------------------------------------------------
> smartctl 6.0 2012-10-10 r3643 [x86_64-linux-3.8.6-gentoo] (local build)
> Copyright (C) 2002-12, Bruce Allen, Christian Franke, www.smartmontools.org
>
> === START OF INFORMATION SECTION ===
> Model Family:     Hitachi Deskstar 5K3000
> Device Model:     Hitachi HDS5C3020ALA632
> Serial Number:    ML0220F30MGE5D
> LU WWN Device Id: 5 000cca 369c8d933
> Firmware Version: ML6OA800
> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    5940 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 2.6, 6.0 Gb/s (current: 6.0 Gb/s)
> Local Time is:    Mon Apr  8 18:29:50 2013 CEST
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM feature is:   Unavailable
> APM feature is:   Disabled
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
>
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
>
> General SMART Values:
> Offline data collection status:  (0x82) Offline data collection activity
>                                         was completed without error.
>                                         Auto Offline Data Collection: Enabled.
> Self-test execution status:      (   0) The previous self-test routine completed
>                                         without error or no self-test has ever
>                                         been run.
> Total time to complete Offline
> data collection:                (21777) seconds.
> Offline data collection
> capabilities:                    (0x5b) SMART execute Offline immediate.
>                                         Auto Offline data collection on/off support.
>                                         Suspend Offline collection upon new
>                                         command.
>                                         Offline surface scan supported.
>                                         Self-test supported.
>                                         No Conveyance Self-test supported.
>                                         Selective Self-test supported.
> SMART capabilities:            (0x0003) Saves SMART data before entering
>                                         power-saving mode.
>                                         Supports SMART auto save timer.
> Error logging capability:        (0x01) Error logging supported.
>                                         General Purpose Logging supported.
> Short self-test routine
> recommended polling time:        (   1) minutes.
> Extended self-test routine
> recommended polling time:        ( 363) minutes.
> SCT capabilities:              (0x003d) SCT Status supported.
>                                         SCT Error Recovery Control supported.
>                                         SCT Feature Control supported.
>                                         SCT Data Table supported.
>
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>   1 Raw_Read_Error_Rate     PO-R--   100   100   016    -    0
>   2 Throughput_Performance  P-S---   136   136   054    -    93
>   3 Spin_Up_Time            POS---   134   134   024    -    406 (Average 409)
>   4 Start_Stop_Count        -O--C-   100   100   000    -    2762
>   5 Reallocated_Sector_Ct   PO--CK   100   100   005    -    0
>   7 Seek_Error_Rate         PO-R--   100   100   067    -    0
>   8 Seek_Time_Performance   P-S---   144   144   020    -    30
>   9 Power_On_Hours          -O--C-   098   098   000    -    16967
>  10 Spin_Retry_Count        PO--C-   100   100   060    -    0
>  12 Power_Cycle_Count       -O--CK   100   100   000    -    68
> 192 Power-Off_Retract_Count -O--CK   098   098   000    -    2762
> 193 Load_Cycle_Count        -O--C-   098   098   000    -    2762
> 194 Temperature_Celsius     -O----   250   250   000    -    24 (Min/Max 19/42)
> 196 Reallocated_Event_Count -O--CK   100   100   000    -    0
> 197 Current_Pending_Sector  -O---K   100   100   000    -    0
> 198 Offline_Uncorrectable   ---R--   100   100   000    -    0
> 199 UDMA_CRC_Error_Count    -O-R--   200   200   000    -    4
>                             ||||||_ K auto-keep
>                             |||||__ C event count
>                             ||||___ R error rate
>                             |||____ S speed/performance
>                             ||_____ O updated online
>                             |______ P prefailure warning
>
> General Purpose Log Directory Version 1
> SMART           Log Directory Version 1 [multi-sector log support]
> GP/S  Log at address 0x00 has    1 sectors [Log Directory]
> SMART Log at address 0x01 has    1 sectors [Summary SMART error log]
> GP    Log at address 0x03 has    1 sectors [Ext. Comprehensive SMART error log]
> GP    Log at address 0x04 has    7 sectors [Device Statistics log]
> SMART Log at address 0x06 has    1 sectors [SMART self-test log]
> GP    Log at address 0x07 has    1 sectors [Extended self-test log]
> GP    Log at address 0x08 has    2 sectors [Power Conditions log]
> SMART Log at address 0x09 has    1 sectors [Selective self-test log]
> GP    Log at address 0x10 has    1 sectors [NCQ Command Error log]
> GP    Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
> GP    Log at address 0x20 has    1 sectors [Streaming performance log]
> GP    Log at address 0x21 has    1 sectors [Write stream error log]
> GP    Log at address 0x22 has    1 sectors [Read stream error log]
> GP/S  Log at address 0x80 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x81 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x82 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x83 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x84 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x85 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x86 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x87 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x88 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x89 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x8a has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x8b has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x8c has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x8d has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x8e has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x8f has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x90 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x91 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x92 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x93 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x94 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x95 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x96 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x97 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x98 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x99 has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x9a has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x9b has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x9c has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x9d has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x9e has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0x9f has   16 sectors [Host vendor specific log]
> GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
> GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]
>
> SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
> Device Error Count: 4
>         CR     = Command Register
>         FEATR  = Features Register
>         COUNT  = Count (was: Sector Count) Register
>         LBA_48 = Upper bytes of LBA High/Mid/Low Registers ]  ATA-8
>         LH     = LBA High (was: Cylinder High) Register    ]   LBA
>         LM     = LBA Mid (was: Cylinder Low) Register      ] Register
>         LL     = LBA Low (was: Sector Number) Register     ]
>         DV     = Device (was: Device/Head) Register
>         DC     = Device Control Register
>         ER     = Error register
>         ST     = Status register
> Powered_Up_Time is measured from power on, and printed as
> DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
> SS=sec, and sss=millisec. It "wraps" after 49.710 days.
>
> Error 4 [3] occurred at disk power-on lifetime: 16966 hours (706 days + 22 hours)
>   When the command that caused the error occurred, the device was active or idle.
>
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   84 -- 51 03 48 00 00 06 42 2a b0 06 00  Error: ICRC, ABRT at LBA = 0x06422ab0 = 104999600
>
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
>   61 03 48 00 41 00 00 06 42 2d b8 46 ff  1d+01:22:58.997  WRITE FPDMA QUEUED
>   61 03 48 00 18 00 00 06 42 2a b0 40 00  1d+01:22:58.994  WRITE FPDMA QUEUED
>   61 00 b8 00 10 00 00 06 42 29 f8 40 00  1d+01:22:58.994  WRITE FPDMA QUEUED
>   61 04 00 00 08 00 00 06 42 25 f8 40 00  1d+01:22:58.994  WRITE FPDMA QUEUED
>   61 00 40 00 00 00 00 06 42 25 b8 40 00  1d+01:22:58.994  WRITE FPDMA QUEUED
>
> Error 3 [2] occurred at disk power-on lifetime: 16966 hours (706 days + 22 hours)
>   When the command that caused the error occurred, the device was active or idle.
>
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   84 -- 51 00 41 00 00 06 42 2d b7 06 00  Error: ICRC, ABRT at LBA = 0x06422db7 = 105000375
>
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
>   61 03 48 00 41 00 00 06 42 2d b8 46 ff  1d+01:22:58.997  WRITE FPDMA QUEUED
>   61 03 48 00 18 00 00 06 42 2a b0 40 00  1d+01:22:58.994  WRITE FPDMA QUEUED
>   61 00 b8 00 10 00 00 06 42 29 f8 40 00  1d+01:22:58.994  WRITE FPDMA QUEUED
>   61 04 00 00 08 00 00 06 42 25 f8 40 00  1d+01:22:58.994  WRITE FPDMA QUEUED
>   61 00 40 00 00 00 00 06 42 25 b8 40 00  1d+01:22:58.994  WRITE FPDMA QUEUED
>
> Error 2 [1] occurred at disk power-on lifetime: 16966 hours (706 days + 22 hours)
>   When the command that caused the error occurred, the device was active or idle.
>
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   84 -- 51 02 00 00 00 05 c2 2e 70 05 00  Error: ICRC, ABRT at LBA = 0x05c22e70 = 96611952
>
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
>   61 02 00 00 39 00 00 05 c2 30 38 45 ff  1d+01:20:36.214  WRITE FPDMA QUEUED
>   61 02 00 00 08 00 00 05 c2 2e 70 40 00  1d+01:20:36.211  WRITE FPDMA QUEUED
>   61 04 00 00 00 00 00 05 c2 2a 70 40 00  1d+01:20:36.211  WRITE FPDMA QUEUED
>   61 00 02 00 00 00 00 00 00 00 08 c0 00  1d+01:20:36.208  WRITE FPDMA QUEUED
>   ea 00 00 00 00 00 00 00 00 00 00 00 00  1d+01:20:36.208  FLUSH CACHE EXT
>
> Error 1 [0] occurred at disk power-on lifetime: 16966 hours (706 days + 22 hours)
>   When the command that caused the error occurred, the device was active or idle.
>
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   84 -- 51 00 39 00 00 05 c2 30 37 05 00  Error: ICRC, ABRT at LBA = 0x05c23037 = 96612407
>
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
>   61 02 00 00 39 00 00 05 c2 30 38 45 ff  1d+01:20:36.214  WRITE FPDMA QUEUED
>   61 02 00 00 08 00 00 05 c2 2e 70 40 00  1d+01:20:36.211  WRITE FPDMA QUEUED
>   61 04 00 00 00 00 00 05 c2 2a 70 40 00  1d+01:20:36.211  WRITE FPDMA QUEUED
>   61 00 02 00 00 00 00 00 00 00 08 c0 00  1d+01:20:36.208  WRITE FPDMA QUEUED
>   ea 00 00 00 00 00 00 00 00 00 00 00 00  1d+01:20:36.208  FLUSH CACHE EXT
>
> SMART Extended Self-test Log Version: 1 (1 sectors)
> Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
> # 1  Extended offline    Completed without error       00%     16827         -
> # 2  Extended offline    Interrupted (host reset)      20%     16416         -
> # 3  Extended offline    Completed without error       00%     16083         -
> # 4  Extended offline    Completed without error       00%     13568         -
> # 5  Extended offline    Completed without error       00%     13237         -
> # 6  Extended offline    Completed without error       00%     12559         -
> # 7  Extended offline    Completed without error       00%     11863         -
>
> SMART Selective self-test log data structure revision number 1
>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>     1        0        0  Not_testing
>     2        0        0  Not_testing
>     3        0        0  Not_testing
>     4        0        0  Not_testing
>     5        0        0  Not_testing
> Selective self-test flags (0x0):
>   After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute delay.
>
> SCT Status Version:                  3
> SCT Version (vendor specific):       256 (0x0100)
> SCT Support Level:                   1
> Device State:                        Active (0)
> Current Temperature:                    25 Celsius
> Power Cycle Min/Max Temperature:     22/29 Celsius
> Lifetime    Min/Max Temperature:     19/42 Celsius
> Under/Over Temperature Limit Count:   0/0
> SCT Temperature History Version:     2
> Temperature Sampling Period:         1 minute
> Temperature Logging Interval:        1 minute
> Min/Max recommended Temperature:      0/60 Celsius
> Min/Max Temperature Limit:           -40/70 Celsius
> Temperature History Size (Index):    128 (104)
>
> Index    Estimated Time   Temperature Celsius
>  105    2013-04-08 16:22    22  ***
>  ...    ..( 51 skipped).    ..  ***
>   29    2013-04-08 17:14    22  ***
>   30    2013-04-08 17:15    23  ****
>   31    2013-04-08 17:16    22  ***
>   32    2013-04-08 17:17    22  ***
>   33    2013-04-08 17:18    23  ****
>   34    2013-04-08 17:19    23  ****
>   35    2013-04-08 17:20    24  *****
>  ...    ..(  2 skipped).    ..  *****
>   38    2013-04-08 17:23    24  *****
>   39    2013-04-08 17:24    25  ******
>  ...    ..(  4 skipped).    ..  ******
>   44    2013-04-08 17:29    25  ******
>   45    2013-04-08 17:30    26  *******
>  ...    ..(  5 skipped).    ..  *******
>   51    2013-04-08 17:36    26  *******
>   52    2013-04-08 17:37    27  ********
>  ...    ..( 16 skipped).    ..  ********
>   69    2013-04-08 17:54    27  ********
>   70    2013-04-08 17:55    28  *********
>   71    2013-04-08 17:56    27  ********
>   72    2013-04-08 17:57    27  ********
>   73    2013-04-08 17:58    28  *********
>  ...    ..(  6 skipped).    ..  *********
>   80    2013-04-08 18:05    28  *********
>   81    2013-04-08 18:06    27  ********
>  ...    ..(  2 skipped).    ..  ********
>   84    2013-04-08 18:09    27  ********
>   85    2013-04-08 18:10    26  *******
>  ...    ..(  4 skipped).    ..  *******
>   90    2013-04-08 18:15    26  *******
>   91    2013-04-08 18:16    25  ******
>  ...    ..(  7 skipped).    ..  ******
>   99    2013-04-08 18:24    25  ******
>  100    2013-04-08 18:25    24  *****
>  ...    ..(  3 skipped).    ..  *****
>  104    2013-04-08 18:29    24  *****
>
> SCT Error Recovery Control:
>            Read: Disabled
>           Write: Disabled
>
> Device Statistics (GP Log 0x04)
> Page Offset Size         Value  Description
>   1  =====  =                =  == General Statistics (rev 1) ==
>   1  0x008  4               68  Lifetime Power-On Resets
>   1  0x010  4            16967  Power-on Hours
>   1  0x018  6      16068241062  Logical Sectors Written
>   1  0x020  6         59818229  Number of Write Commands
>   1  0x028  6    1763338701262  Logical Sectors Read
>   1  0x030  6       2701082815  Number of Read Commands
>   3  =====  =                =  == Rotating Media Statistics (rev 1) ==
>   3  0x008  4             6000  Spindle Motor Power-on Hours
>   3  0x010  4             6000  Head Flying Hours
>   3  0x018  4             2762  Head Load Events
>   3  0x020  4                0  Number of Reallocated Logical Sectors
>   3  0x028  4                1  Read Recovery Attempts
>   3  0x030  4               38  Number of Mechanical Start Failures
>   4  =====  =                =  == General Errors Statistics (rev 1) ==
>   4  0x008  4                0  Number of Reported Uncorrectable Errors
>   4  0x010  4              211  Resets Between Cmd Acceptance and Completion
>   5  =====  =                =  == Temperature Statistics (rev 1) ==
>   5  0x008  1               25  Current Temperature
>   5  0x010  1               24~ Average Short Term Temperature
>   5  0x018  1               23~ Average Long Term Temperature
>   5  0x020  1               42  Highest Temperature
>   5  0x028  1               19  Lowest Temperature
>   5  0x030  1               37~ Highest Average Short Term Temperature
>   5  0x038  1               20~ Lowest Average Short Term Temperature
>   5  0x040  1               34~ Highest Average Long Term Temperature
>   5  0x048  1               23~ Lowest Average Long Term Temperature
>   5  0x050  4                0  Time in Over-Temperature
>   5  0x058  1               60  Specified Maximum Operating Temperature
>   5  0x060  4                0  Time in Under-Temperature
>   5  0x068  1                0  Specified Minimum Operating Temperature
>   6  =====  =                =  == Transport Statistics (rev 1) ==
>   6  0x008  4             2603  Number of Hardware Resets
>   6  0x010  4             1003  Number of ASR Events
>   6  0x018  4                4  Number of Interface CRC Errors
>                               |_ ~ normalized value
>
> SATA Phy Event Counters (GP Log 0x11)
> ID      Size     Value  Description
> 0x0001  2            0  Command failed due to ICRC error
> 0x0002  2            0  R_ERR response for data FIS
> 0x0003  2            0  R_ERR response for device-to-host data FIS
> 0x0004  2            0  R_ERR response for host-to-device data FIS
> 0x0005  2            0  R_ERR response for non-data FIS
> 0x0006  2            0  R_ERR response for device-to-host non-data FIS
> 0x0007  2            0  R_ERR response for host-to-device non-data FIS
> 0x0009  2          208  Transition from drive PhyRdy to drive PhyNRdy
> 0x000a  2          208  Device-to-host register FISes sent due to a COMRESET
> 0x000b  2            0  CRC errors within host-to-device FIS
> 0x000d  2            0  Non-CRC errors within host-to-device FIS
> ----------------------------------------------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
