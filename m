From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: Re: [PATCH] eata: remove driver_lock
Date: Sun, 10 Aug 2014 22:12:34 +0930
Message-ID: <53E768BA.7000308@internode.on.net>
References: <1405326393-18559-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55643 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbaHJMnV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Aug 2014 08:43:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1XGST0-0000JR-Nw
	for linux-scsi@vger.kernel.org; Sun, 10 Aug 2014 14:43:18 +0200
Received: from ppp14-2-5-76.lns21.adl2.internode.on.net ([14.2.5.76])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sun, 10 Aug 2014 14:43:18 +0200
Received: from arthur.marsh by ppp14-2-5-76.lns21.adl2.internode.on.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sun, 10 Aug 2014 14:43:18 +0200
In-Reply-To: <1405326393-18559-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Christoph Hellwig wrote, on 14/07/14 17:56:
> port_detect is only called from the module_init routine and thus implicitly
> serialized, so remove the driver lock which was held over potentially
> sleeping function calls.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Arthur Marsh <arthur.marsh@internode.on.net>
> Tested-by: Arthur Marsh <arthur.marsh@internode.on.net>
> ---
>   drivers/scsi/eata.c | 9 ---------
>   1 file changed, 9 deletions(-)
>
> diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
> index 03372cf..980898e 100644
> --- a/drivers/scsi/eata.c
> +++ b/drivers/scsi/eata.c
> @@ -837,7 +837,6 @@ struct hostdata {
>   static struct Scsi_Host *sh[MAX_BOARDS];
>   static const char *driver_name = "EATA";
>   static char sha[MAX_BOARDS];
> -static DEFINE_SPINLOCK(driver_lock);
>
>   /* Initialize num_boards so that ihdlr can work while detect is in progress */
>   static unsigned int num_boards = MAX_BOARDS;
> @@ -1097,8 +1096,6 @@ static int port_detect(unsigned long port_base, unsigned int j,
>   		goto fail;
>   	}
>
> -	spin_lock_irq(&driver_lock);
> -
>   	if (do_dma(port_base, 0, READ_CONFIG_PIO)) {
>   #if defined(DEBUG_DETECT)
>   		printk("%s: detect, do_dma failed at 0x%03lx.\n", name,
> @@ -1265,10 +1262,7 @@ static int port_detect(unsigned long port_base, unsigned int j,
>   	}
>   #endif
>
> -	spin_unlock_irq(&driver_lock);
>   	sh[j] = shost = scsi_register(tpnt, sizeof(struct hostdata));
> -	spin_lock_irq(&driver_lock);
> -
>   	if (shost == NULL) {
>   		printk("%s: unable to register host, detaching.\n", name);
>   		goto freedma;
> @@ -1345,8 +1339,6 @@ static int port_detect(unsigned long port_base, unsigned int j,
>   	else
>   		sprintf(dma_name, "DMA %u", dma_channel);
>
> -	spin_unlock_irq(&driver_lock);
> -
>   	for (i = 0; i < shost->can_queue; i++)
>   		ha->cp[i].cp_dma_addr = pci_map_single(ha->pdev,
>   							  &ha->cp[i],
> @@ -1439,7 +1431,6 @@ static int port_detect(unsigned long port_base, unsigned int j,
>         freeirq:
>   	free_irq(irq, &sha[j]);
>         freelock:
> -	spin_unlock_irq(&driver_lock);
>   	release_region(port_base, REGION_SIZE);
>         fail:
>   	return 0;
>

Not sure if this is related but it only appeared in the last few days in 
Linus' git master:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.0+ (root@am64) (gcc version 4.9.1 
(Debian 4.9.1-5) ) #1141 SMP Sun Aug 10 20:50:33 ACST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000005fffbfff] usable
[    0.000000] BIOS-e820: [mem 0x000000005fffc000-0x000000005fffefff] 
ACPI data
[    0.000000] BIOS-e820: [mem 0x000000005ffff000-0x000000005fffffff] 
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffff0000-0x00000000ffffffff] 
reserved
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] SMBIOS 2.3 present.
[    0.000000] DMI: System Manufacturer System Name/P4S800, BIOS ASUS 
P4S800 ACPI BIOS Revision 1011 Beta 001 08/30/2005
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x5fffc max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 040000000 mask FE0000000 write-back
[    0.000000]   2 base 0C0000000 mask FF0000000 write-combining
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 
0x7010600070106
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37000000-0x373fffff]
[    0.000000]  [mem 0x37000000-0x373fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x30000000-0x36ffffff]
[    0.000000]  [mem 0x30000000-0x36ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x2fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x2fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x37400000-0x377fdfff]
[    0.000000]  [mem 0x37400000-0x377fdfff] page 4k
[    0.000000] BRK [0x01f50000, 0x01f50fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x5f19d000-0x5fff1fff]
[    0.000000] Allocated new RAMDISK: [mem 0x369a9000-0x377fd7ad]
[    0.000000] Move RAMDISK from [mem 0x5f19d000-0x5fff17ad] to [mem 
0x369a9000-0x377fd7ad]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000F5710 000014 (v00 ASUS  )
[    0.000000] ACPI: RSDT 0x5FFFC000 000030 (v01 ASUS   P4S800 
42302E31 MSFT 31313031)
[    0.000000] ACPI: FACP 0x5FFFC0C0 000074 (v01 ASUS   P4S800 
42302E31 MSFT 31313031)
[    0.000000] ACPI: DSDT 0x5FFFC134 0025D4 (v01 ASUS   P4S800 
00001000 MSFT 0100000B)
[    0.000000] ACPI: FACS 0x5FFFF000 000040
[    0.000000] ACPI: BOOT 0x5FFFC030 000028 (v01 ASUS   P4S800 
42302E31 MSFT 31313031)
[    0.000000] ACPI: APIC 0x5FFFC058 000068 (v01 ASUS   P4S800 
42302E31 MSFT 31313031)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 647MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] BRK [0x01f51000, 0x01f51fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0x5fffbfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x5fffbfff]
[    0.000000] On node 0 totalpages: 393114
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 223230 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1296 pages used for memmap
[    0.000000]   HighMem zone: 165886 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xe408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 128, address 0xfec00000, 
GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x60000000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 
nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @f5d12000 s35840 r0 d21504 
u57344
[    0.000000] pcpu-alloc: s35840 r0 d21504 u57344 alloc=14*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 391338
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.16.0 
root=UUID=96c96a61-8615-4715-86d0-09cb8c62638c ro
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 
bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0005fffc)
[    0.000000] Initializing Movable for node 0 (00000000:00000000)
[    0.000000] Memory: 1528328K/1572456K available (4409K kernel code, 
512K rwdata, 1976K rodata, 488K init, 8224K bss, 44128K reserved, 
663544K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc16bf000 - 0xc1739000   ( 488 kB)
[    0.000000]       .data : 0xc144ea0d - 0xc16be000   (2493 kB)
[    0.000000]       .text : 0xc1000000 - 0xc144ea0d   (4410 kB)
[    0.000000] Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=2.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=f5808000 soft=f580a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, 
Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 4911 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] allocated 3145728 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't 
want memory cgroups
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2999.897 MHz processor
[    0.000066] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 5999.79 BogoMIPS (lpj=11999588)
[    0.000154] pid_max: default: 32768 minimum: 301
[    0.000275] ACPI: Core revision 20140724
[    0.004000] ACPI: All ACPI Tables successfully acquired
[    0.004000] Security Framework initialized
[    0.004000] AppArmor: AppArmor disabled by boot time parameter
[    0.004000] Yama: becoming mindful.
[    0.004000] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.004000] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 
bytes)
[    0.004000] Initializing cgroup subsys memory
[    0.004000] Initializing cgroup subsys devices
[    0.004000] Initializing cgroup subsys freezer
[    0.004000] Initializing cgroup subsys net_cls
[    0.004000] Initializing cgroup subsys blkio
[    0.004000] Initializing cgroup subsys perf_event
[    0.004000] Initializing cgroup subsys net_prio
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] mce: CPU supports 4 MCE banks
[    0.004000] CPU0: Thermal LVT vector (0xfa) already installed
[    0.004000] Last level iTLB entries: 4KB 64, 2MB 64, 4MB 64
[    0.004000] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 64, 1GB 0
[    0.004000] Freeing SMP alternatives memory: 20K (c1739000 - c173e000)
[    0.004000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.004000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.042423] smpboot: CPU0: Intel(R) Pentium(R) 4 CPU 3.00GHz (fam: 
0f, model: 03, stepping: 04)
[    0.044000] Performance Events: Netburst events, Broken PMU hardware 
detected, using software events only.
[    0.044000] Failed to access perfctr msr (MSR 300 is fc29bd727e)
[    0.044000] CPU 1 irqstacks, hard=f500e000 soft=f5010000
[    0.044000] x86: Booting SMP configuration:
[    0.044000] .... node  #0, CPUs:      #1
[    0.004000] Initializing CPU#1
[    0.004000] CPU1: Thermal LVT vector (0xfa) already installed
[    0.054124] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.056169] x86: Booted up 1 node, 2 CPUs
[    0.056214] smpboot: Total of 2 processors activated (11999.58 BogoMIPS)
[    0.057698] devtmpfs: initialized
[    0.062342] PM: Registering ACPI NVS region [mem 
0x5ffff000-0x5fffffff] (4096 bytes)
[    0.062342] reboot: ASUS P4S800 series board detected. Selecting 
BIOS-method for reboots.
[    0.062342] pinctrl core: initialized pinctrl subsystem
[    0.064126] NET: Registered protocol family 16
[    0.064887] cpuidle: using governor ladder
[    0.064934] cpuidle: using governor menu
[    0.065102] ACPI: bus type PCI registered
[    0.065147] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.067171] PCI: PCI BIOS revision 2.10 entry at 0xf10c0, last bus=1
[    0.067216] PCI: Using configuration type 1 for base access
[    0.080441] ACPI: Added _OSI(Module Device)
[    0.080441] ACPI: Added _OSI(Processor Device)
[    0.080441] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.080441] ACPI: Added _OSI(Processor Aggregator Device)
[    0.096440] ACPI: Interpreter enabled
[    0.096520] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep 
State [\_S2_] (20140724/hwxface-580)
[    0.096639] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep 
State [\_S3_] (20140724/hwxface-580)
[    0.096807] ACPI: (supports S0 S1 S4 S5)
[    0.096850] ACPI: Using IOAPIC for interrupt routing
[    0.097644] PCI: Ignoring host bridge windows from ACPI; if 
necessary, use "pci=use_crs" and report a bug
[    0.115163] acpi LNXCPU:00: Invalid PBLK length [5]
[    0.115842] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.116524] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.117185] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.117844] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.118502] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.119160] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.119817] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.120488] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.121133] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.121187] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments 
MSI]
[    0.121305] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.122201] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] 
(ignored)
[    0.122207] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] 
(ignored)
[    0.122212] acpi PNP0A03:00: host bridge window [mem 
0x000a0000-0x000bffff] (ignored)
[    0.122216] acpi PNP0A03:00: host bridge window [mem 
0x000c8000-0x000dffff] (ignored)
[    0.122220] acpi PNP0A03:00: host bridge window [mem 
0x60000000-0xfebfffff] (ignored)
[    0.122225] PCI: root bus 00: using default resources
[    0.122266] acpi PNP0A03:00: fail to add MMCONFIG information, can't 
access extended PCI configuration space under this bridge.
[    0.123043] PCI host bridge to bus 0000:00
[    0.123099] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.123144] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.123189] pci_bus 0000:00: root bus resource [mem 
0x00000000-0xffffffff]
[    0.123280] pci 0000:00:00.0: [1039:0648] type 00 class 0x060000
[    0.123300] pci 0000:00:00.0: reg 0x10: [mem 0xc0000000-0xcfffffff]
[    0.123757] pci 0000:00:01.0: [1039:0003] type 01 class 0x060400
[    0.124068] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.124337] pci 0000:00:02.0: [1039:0963] type 00 class 0x060100
[    0.124719] pci 0000:00:02.1: [1039:0016] type 00 class 0x0c0500
[    0.124799] pci 0000:00:02.1: reg 0x20: [io  0xe600-0xe61f]
[    0.125085] pci 0000:00:02.5: [1039:5513] type 00 class 0x010180
[    0.125185] pci 0000:00:02.5: reg 0x20: [io  0xa400-0xa40f]
[    0.125223] pci 0000:00:02.5: legacy IDE quirk: reg 0x10: [io 
0x01f0-0x01f7]
[    0.125269] pci 0000:00:02.5: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.125313] pci 0000:00:02.5: legacy IDE quirk: reg 0x18: [io 
0x0170-0x0177]
[    0.125358] pci 0000:00:02.5: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.125685] pci 0000:00:03.0: [1039:7001] type 00 class 0x0c0310
[    0.125711] pci 0000:00:03.0: reg 0x10: [mem 0xbe800000-0xbe800fff]
[    0.125905] pci 0000:00:03.0: System wakeup disabled by ACPI
[    0.126168] pci 0000:00:03.1: [1039:7001] type 00 class 0x0c0310
[    0.126195] pci 0000:00:03.1: reg 0x10: [mem 0xbe000000-0xbe000fff]
[    0.126387] pci 0000:00:03.1: System wakeup disabled by ACPI
[    0.126655] pci 0000:00:03.3: [1039:7002] type 00 class 0x0c0320
[    0.126686] pci 0000:00:03.3: reg 0x10: [mem 0xbd800000-0xbd800fff]
[    0.126818] pci 0000:00:03.3: PME# supported from D0 D3hot D3cold
[    0.126965] pci 0000:00:03.3: System wakeup disabled by ACPI
[    0.127245] pci 0000:00:04.0: [1039:0900] type 00 class 0x020000
[    0.127277] pci 0000:00:04.0: reg 0x10: [io  0x8800-0x88ff]
[    0.127296] pci 0000:00:04.0: reg 0x14: [mem 0xbd000000-0xbd000fff]
[    0.127369] pci 0000:00:04.0: reg 0x30: [mem 0xdffe0000-0xdfffffff pref]
[    0.127422] pci 0000:00:04.0: supports D1 D2
[    0.127426] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.127727] pci 0000:00:0a.0: [1102:0004] type 00 class 0x040100
[    0.127759] pci 0000:00:0a.0: reg 0x10: [io  0x8400-0x843f]
[    0.127891] pci 0000:00:0a.0: supports D1 D2
[    0.128161] pci 0000:00:0a.1: [1102:7003] type 00 class 0x098000
[    0.128191] pci 0000:00:0a.1: reg 0x10: [io  0x8000-0x8007]
[    0.128323] pci 0000:00:0a.1: supports D1 D2
[    0.128580] pci 0000:00:0a.2: [1102:4001] type 00 class 0x0c0010
[    0.128613] pci 0000:00:0a.2: reg 0x10: [mem 0xbc800000-0xbc8007ff]
[    0.128631] pci 0000:00:0a.2: reg 0x14: [mem 0xbc000000-0xbc003fff]
[    0.128753] pci 0000:00:0a.2: supports D1 D2
[    0.128757] pci 0000:00:0a.2: PME# supported from D0 D1 D2 D3hot
[    0.129065] pci 0000:00:0b.0: [10ec:8169] type 00 class 0x020000
[    0.129097] pci 0000:00:0b.0: reg 0x10: [io  0x7800-0x78ff]
[    0.129116] pci 0000:00:0b.0: reg 0x14: [mem 0xbb800000-0xbb8000ff]
[    0.129188] pci 0000:00:0b.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    0.129240] pci 0000:00:0b.0: supports D1 D2
[    0.129244] pci 0000:00:0b.0: PME# supported from D1 D2 D3hot
[    0.129526] pci 0000:00:0c.0: [1044:a400] type 00 class 0x010000
[    0.129552] pci 0000:00:0c.0: reg 0x10: [io  0x7400-0x741f]
[    0.129639] pci 0000:00:0c.0: reg 0x30: [mem 0x00000000-0x00007fff pref]
[    0.130085] pci 0000:01:00.0: [1002:5964] type 00 class 0x030000
[    0.130118] pci 0000:01:00.0: reg 0x10: [mem 0xf0000000-0xf7ffffff pref]
[    0.130135] pci 0000:01:00.0: reg 0x14: [io  0xd800-0xd8ff]
[    0.130151] pci 0000:01:00.0: reg 0x18: [mem 0xbf800000-0xbf80ffff]
[    0.130203] pci 0000:01:00.0: reg 0x30: [mem 0xeffe0000-0xefffffff pref]
[    0.130268] pci 0000:01:00.0: supports D1 D2
[    0.130475] pci 0000:01:00.1: [1002:5d44] type 00 class 0x038000
[    0.130499] pci 0000:01:00.1: reg 0x10: [mem 0xe0000000-0xe7ffffff pref]
[    0.130513] pci 0000:01:00.1: reg 0x14: [mem 0xbf000000-0xbf00ffff]
[    0.130602] pci 0000:01:00.1: supports D1 D2
[    0.130861] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.130911] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.130919] pci 0000:00:01.0:   bridge window [mem 0xbf000000-0xbfffffff]
[    0.130927] pci 0000:00:01.0:   bridge window [mem 
0xe0000000-0xfebfffff pref]
[    0.130942] pci_bus 0000:00: on NUMA node 0
[    0.134572] vgaarb: device added: 
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.134572] vgaarb: loaded
[    0.134572] vgaarb: bridge control possible 0000:01:00.0
[    0.134572] PCI: Using ACPI for IRQ routing
[    0.134572] PCI: pci_cache_line_size set to 64 bytes
[    0.134572] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    0.134572] e820: reserve RAM buffer [mem 0x5fffc000-0x5fffffff]
[    0.136650] Switched to clocksource refined-jiffies
[    0.156582] pnp: PnP ACPI init
[    0.157211] system 00:00: [mem 0x00000000-0x0009ffff] could not be 
reserved
[    0.157263] system 00:00: [mem 0x000f0000-0x000fffff] could not be 
reserved
[    0.157311] system 00:00: [mem 0x00100000-0x5fffffff] could not be 
reserved
[    0.157359] system 00:00: [mem 0xfec00000-0xfec000ff] could not be 
reserved
[    0.157406] system 00:00: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.157535] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.158293] system 00:01: [io  0xe400-0xe47f] has been reserved
[    0.158341] system 00:01: [io  0xe480-0xe4ff] has been reserved
[    0.158388] system 00:01: [io  0xe600-0xe61f] has been reserved
[    0.158433] system 00:01: [io  0x0480-0x048f] has been reserved
[    0.158480] system 00:01: [mem 0xffee0000-0xffefffff] has been reserved
[    0.158530] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.158748] system 00:02: [mem 0xfffe0000-0xffffffff] could not be 
reserved
[    0.158801] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.159042] system 00:03: [io  0x04d0-0x04d1] has been reserved
[    0.159094] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.159438] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.160830] pnp 00:05: [dma 3]
[    0.160983] pnp 00:05: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.161848] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.162072] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.162400] pnp 00:08: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.163335] system 00:09: [io  0x0295-0x0296] has been reserved
[    0.163388] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.163444] pnp: PnP ACPI: found 10 devices
[    0.208987] Switched to clocksource acpi_pm
[    0.209080] pci 0000:00:0b.0: BAR 6: assigned [mem 
0x60000000-0x6001ffff pref]
[    0.209137] pci 0000:00:0c.0: BAR 6: assigned [mem 
0x60020000-0x60027fff pref]
[    0.209192] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.209238] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.209289] pci 0000:00:01.0:   bridge window [mem 0xbf000000-0xbfffffff]
[    0.209338] pci 0000:00:01.0:   bridge window [mem 
0xe0000000-0xfebfffff pref]
[    0.209398] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.209402] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.209406] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.209410] pci_bus 0000:01: resource 1 [mem 0xbf000000-0xbfffffff]
[    0.209414] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xfebfffff pref]
[    0.209580] NET: Registered protocol family 2
[    0.210731] TCP established hash table entries: 8192 (order: 3, 32768 
bytes)
[    0.210852] TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
[    0.211771] TCP: Hash tables configured (established 8192 bind 8192)
[    0.211929] TCP: reno registered
[    0.211976] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    0.211976] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    0.211976] NET: Registered protocol family 1
[    0.325101] pci 0000:01:00.0: Boot video device
[    0.325114] PCI: CLS 32 bytes, default 64
[    0.325493] Unpacking initramfs...
[    0.874415] Freeing initrd memory: 14676K (f69a9000 - f77fe000)
[    0.874613] Simple Boot Flag at 0x3a set to 0x1
[    0.875354] microcode: CPU0 sig=0xf34, pf=0x4, revision=0x17
[    0.875439] microcode: CPU1 sig=0xf34, pf=0x4, revision=0x17
[    0.875760] microcode: Microcode Update Driver: v2.00 
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.877258] futex hash table entries: 512 (order: 4, 65536 bytes)
[    0.877428] audit: initializing netlink subsys (disabled)
[    0.877591] audit: type=2000 audit(1407708024.875:1): initialized
[    0.878595] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.879190] VFS: Disk quotas dquot_6.5.2
[    0.879287] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.879811] msgmni has been set to 1717
[    0.881526] alg: No test for stdrng (krng)
[    0.881666] bounce: pool size: 64 pages
[    0.881763] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 252)
[    0.882008] io scheduler noop registered
[    0.882055] io scheduler deadline registered
[    0.882148] io scheduler cfq registered (default)
[    0.882653] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.882897] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.883390] GHES: HEST is not enabled!
[    0.883659] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.904488] 00:06: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) 
is a 16550A
[    0.906568] Linux agpgart interface v0.103
[    0.906916] agpgart-sis 0000:00:00.0: SiS chipset [1039/0648]
[    0.924536] agpgart-sis 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    0.925055] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] 
at 0x60,0x64 irq 1,12
[    0.925795] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.925891] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.926951] mousedev: PS/2 mouse device common for all mice
[    0.927422] rtc_cmos 00:04: RTC can wake from S4
[    0.927958] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    0.928073] rtc_cmos 00:04: alarms up to one month, 242 bytes nvram
[    0.928393] TCP: cubic registered
[    0.928597] NET: Registered protocol family 10
[    0.929753] mip6: Mobile IPv6
[    0.929823] NET: Registered protocol family 17
[    0.929880] mpls_gso: MPLS GSO support
[    0.930801] Using IPI No-Shortcut mode
[    0.931489] registered taskstats version 1
[    0.933064] rtc_cmos 00:04: setting system clock to 2014-08-10 
22:00:26 UTC (1407708026)
[    0.933427] PM: Hibernation image not present or could not be loaded.
[    0.934254] Freeing unused kernel memory: 488K (c16bf000 - c1739000)
[    0.934352] Write protecting the kernel text: 4412k
[    0.934593] Write protecting the kernel read-only data: 1980k
[    0.948804] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input0
[    1.043259] systemd-udevd[63]: starting version 208
[    1.045786] random: systemd-udevd urandom read with 0 bits of entropy 
available
[    1.115834] ACPI: bus type USB registered
[    1.116242] usbcore: registered new interface driver usbfs
[    1.117192] usbcore: registered new interface driver hub
[    1.118047] usbcore: registered new device driver usb
[    1.120384] SCSI subsystem initialized
[    1.123363] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.127546] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.128744] ehci-pci: EHCI PCI platform driver
[    1.132881] libata version 3.00 loaded.
[    1.133856] ehci-pci 0000:00:03.3: EHCI Host Controller
[    1.135842] ehci-pci 0000:00:03.3: new USB bus registered, assigned 
bus number 1
[    1.138930] ehci-pci 0000:00:03.3: irq 23, io mem 0xbd800000
[    1.148578] ehci-pci 0000:00:03.3: USB 2.0 started, EHCI 1.00
[    1.149860] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.149932] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.149998] usb usb1: Product: EHCI Host Controller
[    1.150054] usb usb1: Manufacturer: Linux 3.16.0+ ehci_hcd
[    1.150113] usb usb1: SerialNumber: 0000:00:03.3
[    1.152763] sis900.c: v1.08.10 Apr. 2 2006
[    1.153195] hub 1-0:1.0: USB hub found
[    1.153354] hub 1-0:1.0: 6 ports detected
[    1.157615] pata_sis 0000:00:02.5: version 0.5.2
[    1.157824] pata_sis 0000:00:02.5: SiS 962/963 MuTIOL IDE UDMA133 
controller
[    1.163387] ohci-pci: OHCI PCI platform driver
[    1.166704] scsi host0: pata_sis
[    1.175319] EATA0: warning, DMA protocol support not asserted.
[    1.175401] EATA0: IRQ 11 mapped to IO-APIC IRQ 16.
[    1.175446] ------------[ cut here ]------------
[    1.175496] WARNING: CPU: 0 PID: 66 at kernel/locking/lockdep.c:2744 
lockdep_trace_alloc+0xd3/0xd5()
[    1.175548] DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
[    1.175584] Modules linked in: eata(+) r8169(+) firewire_ohci(+) 
ohci_pci(+) firewire_core crc_itu_t sis900(+) mii floppy(+) pata_sis(+) 
ehci_pci ohci_hcd libata ehci_hcd usbcore usb_common scsi_mod
[    1.176090] CPU: 0 PID: 66 Comm: systemd-udevd Not tainted 3.16.0+ #1141
[    1.176090] Hardware name: System Manufacturer System Name/P4S800, 
BIOS ASUS P4S800 ACPI BIOS Revision 1011 Beta 001 08/30/2005
[    1.176090]  00000000 00000000 f43e7a40 c1446a24 f43e7a84 f43e7a74 
c1043f4a c159c994
[    1.176603]  f43e7aa0 00000042 c159ec53 00000ab8 c107f845 00000ab8 
c107f845 00000082
[    1.176603]  f712c800 000080d0 f43e7a8c c1043f8f 00000009 f43e7a84 
c159c994 f43e7aa0
[    1.176603] Call Trace:
[    1.176603]  [<c1446a24>] dump_stack+0x41/0x52
[    1.176603]  [<c1043f4a>] warn_slowpath_common+0x7d/0x94
[    1.176603]  [<c107f845>] ? lockdep_trace_alloc+0xd3/0xd5
[    1.176603]  [<c107f845>] ? lockdep_trace_alloc+0xd3/0xd5
[    1.176603]  [<c1043f8f>] warn_slowpath_fmt+0x2e/0x30
[    1.176603]  [<c107f845>] lockdep_trace_alloc+0xd3/0xd5
[    1.176603]  [<c11421ea>] kmem_cache_alloc_trace+0x24/0x3f7
[    1.176603]  [<c108cdee>] ? vprintk_emit+0x2d9/0x633
[    1.176603]  [<c123d2b1>] ? radix_tree_lookup+0x14/0x16
[    1.176603]  [<f814650d>] ? eata2x_eh_host_reset+0x4d8/0x4d8 [eata]
[    1.176603]  [<c1090287>] request_threaded_irq+0x63/0x107
[    1.176603]  [<f81481ac>] port_detect+0xa66/0xf14 [eata]
[    1.176603]  [<c1030d66>] ? ioapic_write_entry+0x17/0x43
[    1.176603]  [<c107cb76>] ? trace_hardirqs_on_caller+0x12f/0x1b7
[    1.176603]  [<c107cc09>] ? trace_hardirqs_on+0xb/0xd
[    1.176603]  [<c1030d8b>] ? ioapic_write_entry+0x3c/0x43
[    1.176603]  [<c1031c3c>] ? io_apic_setup_irq_pin+0x175/0x319
[    1.176603]  [<c107cb76>] ? trace_hardirqs_on_caller+0x12f/0x1b7
[    1.176603]  [<c1032d7f>] ? io_apic_setup_irq_pin_once+0x83/0xd1
[    1.176603]  [<c107ce2a>] ? debug_check_no_locks_freed+0x9d/0x152
[    1.176603]  [<c1142514>] ? kmem_cache_alloc_trace+0x34e/0x3f7
[    1.176603]  [<c134d1bc>] ? pci_conf1_read+0x43/0xdd
[    1.176603]  [<c144064c>] ? klist_next+0x1b/0xef
[    1.176603]  [<c144071e>] ? klist_next+0xed/0xef
[    1.176603]  [<c144c5b4>] ? _raw_spin_unlock+0x1d/0x20
[    1.176603]  [<c144071e>] ? klist_next+0xed/0xef
[    1.176603]  [<c126b586>] ? pci_do_find_bus+0x36/0x36
[    1.176603]  [<c12ffeb8>] ? bus_find_device+0x5b/0x7d
[    1.176603]  [<c12fde7b>] ? put_device+0xf/0x11
[    1.176603]  [<c126a0d2>] ? pci_dev_put+0xf/0x11
[    1.176603]  [<c126b71e>] ? pci_get_dev_by_id+0x3f/0x8a
[    1.176603]  [<c126b586>] ? pci_do_find_bus+0x36/0x36
[    1.176603]  [<c126b864>] ? pci_get_class+0x46/0x48
[    1.176603]  [<f8148733>] eata2x_detect+0xd9/0x3ef [eata]
[    1.176603]  [<c107cb76>] ? trace_hardirqs_on_caller+0x12f/0x1b7
[    1.176603]  [<f8024000>] ? 0xf8024000
[    1.176603]  [<f8024054>] init_this_scsi_driver+0x54/0x1000 [eata]
[    1.176603]  [<f8024000>] ? 0xf8024000
[    1.176603]  [<c1000452>] do_one_initcall+0x9c/0x1c4
[    1.176603]  [<f8024000>] ? 0xf8024000
[    1.176603]  [<c107cc09>] ? trace_hardirqs_on+0xb/0xd
[    1.176603]  [<c1134787>] ? __vunmap+0x77/0xcd
[    1.176603]  [<c10b39d7>] load_module+0x1cd3/0x256a
[    1.176603]  [<c10b43d4>] SyS_finit_module+0x6e/0xa7
[    1.176603]  [<c10797ce>] ? up_write+0x16/0x32
[    1.176603]  [<c111b474>] ? vm_mmap_pgoff+0x75/0x92
[    1.176603]  [<c144d02a>] syscall_call+0x7/0x7
[    1.176603] ---[ end trace 0a1b5d775e787003 ]---
[    1.181449] EATA/DMA 2.0x: Copyright (C) 1994-2003 Dario Ballabio.
[    1.181508] EATA config options -> tm:1, lc:y, mq:16, rs:y, et:n, 
ip:n, ep:n, pp:y.
[    1.181579] EATA0: 2.0C, PCI 0x7410, IRQ 16, BMST, SG 122, MB 64.
[    1.181632] EATA0: wide SCSI support enabled, max_id 16, max_lun 8.
[    1.181684] EATA0: SCSI channel 0 enabled, host target ID 7.
[    1.181751] scsi host2: EATA/DMA 2.0x rev. 8.10.00

Arthur.

