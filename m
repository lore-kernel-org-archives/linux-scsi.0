From: Ian Jackson <Ian.Jackson@eu.citrix.com>
Subject: linux 3.14.34 failure to detect disks on C600 storage controller
Date: Tue, 14 Apr 2015 17:54:02 +0100
Message-ID: <21805.17962.549697.310148@mariner.uk.xensource.com>
References: <21799.53853.642030.924852@mariner.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.citrix.com ([66.165.176.89]:13206 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932869AbbDNQyK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Apr 2015 12:54:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Intel SCU Linux support <intel-linux-scu@intel.com>, Lukasz Dorau <lukasz.dorau@intel.com>, Maciej Patelczyk <maciej.patelczyk@intel.com>, Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Vrabel <david.vrabel@citrix.com>

I have a pair of test machines in the new Xen Project test colo which
do not detect their disk with the 3.14.* kernel branch we are using.

The machines are based on a Gigabyte motherboard with an Intel C600
storage controller.  Debian's 3.2.0-4 (i386 or amd64) detects the
controller and its disks just fine.

>From /var/log/dmesg (Debian 3.2.0-4 amd64):

[    2.699118] isci: Intel(R) C600 SAS Controller Driver - version 1.0.0
[    2.705814] isci 0000:01:00.0: driver configured for rev: 6 silicon
[    2.712077] isci 0000:01:00.0: OEM parameter table found in OROM
[    2.718082] isci 0000:01:00.0: OEM SAS parameters (version: 1.0) loaded (platform)
...
[    2.761254] isci 0000:01:00.0: setting latency timer to 64
[    2.763557] scsi0 : isci
[    2.766516] isci 0000:01:00.0: irq 72 for MSI/MSI-X
[    2.766523] isci 0000:01:00.0: irq 73 for MSI/MSI-X

>From lspci -v:

01:00.0 Serial Attached SCSI controller: Intel Corporation C602 chipset 4-Port SATA Storage Control Unit (rev 06)
        Subsystem: Giga-byte Technology Device 1d6b
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at fb47c000 (64-bit, prefetchable) [size=16K]
        Memory at fb000000 (64-bit, prefetchable) [size=4M]
        I/O ports at e000 [size=256]
        Capabilities: [98] Power Management version 3
        Capabilities: [c4] Express Endpoint, MSI 00
        Capabilities: [a0] MSI-X: Enable+ Count=2 Masked-
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [138] Alternative Routing-ID Interpretation (ARI)
        Capabilities: [180] Transaction Processing Hints
        Capabilities: [140] Single Root I/O Virtualization (SR-IOV)
        Kernel driver in use: isci

However, an osstest-built 3.14.34 (eg, 413cb08cebe9) does not.
CONFIG_SCSI_ISCI is set to `m' and the module is loaded.  I still get
this:

[    3.366283] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[    3.366303] isci 0000:01:00.0: driver configured for rev: 6 silicon
[    3.366307] isci 0000:01:00.0: OEM parameter table found in OROM
[    3.366309] isci 0000:01:00.0: OEM SAS parameters (version: 1.0) loaded (platform)
[    3.367373] isci 0000:01:00.0: SCU controller 0: phy 3-0 cables: {short, short, short, short}
[    3.369991] scsi6 : isci

But the disk is not detected.  The complete boot logfile is below.

A web search found this
  https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=746642#33
  https://git.kernel.org/cgit/linux/kernel/git/bwh/linux-3.2.y.git/commit/?id=2e59f013993a74bf31366a59bcf36be830d0f058
So I tried reverting ddfadd77, but to no avail.

My kernel build information is here:
  http://logs.test-lab.xenproject.org/osstest/logs/50086/build-amd64-pvops/info.html
in particular:
  http://logs.test-lab.xenproject.org/osstest/logs/50086/build-amd64-pvops/build/config

Any suggestions would be appreciated.

Thanks,
Ian.

Apr  9 18:34:10.925079 Loading Linux 3.14.34+ ...
Apr  9 18:34:10.948813 Loading initial ramdisk ...
Apr  9 18:34:11.092927 [    0.000000] Initializing cgroup subsys cpuse
Apr  9 18:34:11.636854 <Modem lines changed: -CTS>
t
Apr  9 18:34:11.644797 [    0.000000] Initializing cgroup subsys cpu
Apr  9 18:34:11.644830 [    0.000000] Initializing cgroup subsys cpuacct
Apr  9 18:34:11.652831 [    0.000000] Linux version 3.14.34+ (osstest@chardonnay1) (gcc version 4.7.2 (Debian 4.7.2-5) ) #1 SMP Fri Mar 13 18:20:37 GMT 2015
Apr  9 18:34:11.660849 [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.14.34+ root=/dev/mapper/chardonnay1-root ro BOOTIF=01-90-2b-34-31-3d-a2 console=ttyS0,115200
Apr  9 18:34:11.676804 [    0.000000] e820: BIOS-provided physical RAM map:
Apr  9 18:34:11.676838 [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008efff] usable
Apr  9 18:34:11.684805 [    0.000000] BIOS-e820: [mem 0x000000000008f000-0x000000000009ffff] reserved
Apr  9 18:34:11.692817 [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
Apr  9 18:34:11.700826 [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007d181fff] usable
Apr  9 18:34:11.708803 [    0.000000] BIOS-e820: [mem 0x000000007d182000-0x000000007d42efff] reserved
Apr  9 18:34:11.716794 [    0.000000] BIOS-e820: [mem 0x000000007d42f000-0x000000007d547fff] ACPI data
Apr  9 18:34:11.716831 [    0.000000] BIOS-e820: [mem 0x000000007d548000-0x000000007d76bfff] ACPI NVS
Apr  9 18:34:11.724803 [    0.000000] BIOS-e820: [mem 0x000000007d76c000-0x000000007f2eafff] reserved
Apr  9 18:34:11.732804 [    0.000000] BIOS-e820: [mem 0x000000007f2eb000-0x000000007f2ebfff] usable
Apr  9 18:34:11.740807 [    0.000000] BIOS-e820: [mem 0x000000007f2ec000-0x000000007f371fff] ACPI NVS
Apr  9 18:34:11.748797 [    0.000000] BIOS-e820: [mem 0x000000007f372000-0x000000007f7fffff] usable
Apr  9 18:34:11.756799 [    0.000000] BIOS-e820: [mem 0x0000000080000000-0x000000008fffffff] reserved
Apr  9 18:34:11.764810 [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
Apr  9 18:34:11.764851 [    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
Apr  9 18:34:11.772805 [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000027fffffff] usable
Apr  9 18:34:11.780802 [    0.000000] NX (Execute Disable) protection: active
Apr  9 18:34:11.788801 [    0.000000] SMBIOS 2.7 present.
Apr  9 18:34:11.788835 [    0.000000] e820: last_pfn = 0x280000 max_arch_pfn = 0x400000000
Apr  9 18:34:11.796799 [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Apr  9 18:34:11.804795 [    0.000000] e820: last_pfn = 0x7f800 max_arch_pfn = 0x400000000
Apr  9 18:34:11.812791 [    0.000000] found SMP MP-table at [mem 0x000fd890-0x000fd89f] mapped at [ffff8800000fd890]
Apr  9 18:34:11.820809 [    0.000000] Scanning 1 areas for low memory corruption
Apr  9 18:34:11.820848 [    0.000000] Using GB pages for direct mapping
Apr  9 18:34:11.828796 [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
Apr  9 18:34:11.828836 [    0.000000] init_memory_mapping: [mem 0x27fe00000-0x27fffffff]
Apr  9 18:34:11.836817 [    0.000000] init_memory_mapping: [mem 0x27c000000-0x27fdfffff]
Apr  9 18:34:11.844799 [    0.000000] init_memory_mapping: [mem 0x200000000-0x27bffffff]
Apr  9 18:34:11.852790 [    0.000000] init_memory_mapping: [mem 0x00100000-0x7d181fff]
Apr  9 18:34:11.852827 [    0.000000] init_memory_mapping: [mem 0x7f2eb000-0x7f2ebfff]
Apr  9 18:34:11.860991 [    0.000000] init_memory_mapping: [mem 0x7f372000-0x7f7fffff]
Apr  9 18:34:11.868988 [    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
Apr  9 18:34:11.869025 [    0.000000] RAMDISK: [mem 0x360f8000-0x37073fff]
Apr  9 18:34:11.876959 [    0.000000] ACPI: RSDP 00000000000f04a0 000024 (v02    GBT)
Apr  9 18:34:11.884964 [    0.000000] ACPI: XSDT 000000007d468088 000094 (v01 GBT    GBTUACPI 01072009 AMI  00010013)
Apr  9 18:34:11.892929 [    0.000000] ACPI: FACP 000000007d476508 00010C (v05 GBT    GBTUACPI 01072009 AMI  00010013)
Apr  9 18:34:11.900857 [    0.000000] ACPI: DSDT 000000007d4681b0 00E353 (v02 GBT    GBTUACPI 00000026 INTL 20051117)
Apr  9 18:34:11.908855 [    0.000000] ACPI: FACS 000000007d763080 000040
Apr  9 18:34:11.908891 [    0.000000] ACPI: APIC 000000007d476618 000090 (v03 GBT    GBTUACPI 01072009 AMI  00010013)
Apr  9 18:34:11.916866 [    0.000000] ACPI: FPDT 000000007d4766a8 000044 (v01 GBT    GBTUACPI 01072009 AMI  00010013)
Apr  9 18:34:11.932839 [    0.000000] ACPI: MCFG 000000007d4766f0 00003C (v01 GBT    GBTUACPI 01072009 MSFT 00000097)
Apr  9 18:34:11.940840 [    0.000000] ACPI: SLIC 000000007d476730 000176 (v01 GBT    GBTUACPI 01072009 AMI  00010013)
Apr  9 18:34:11.948838 [    0.000000] ACPI: HPET 000000007d4768a8 000038 (v01 GBT    GBTUACPI 01072009 AMI. 00000005)
Apr  9 18:34:11.956845 [    0.000000] ACPI: PRAD 000000007d4768e0 0000BE (v02 PRADID  PRADTID 00000001 MSFT 03000001)
Apr  9 18:34:11.964843 [    0.000000] ACPI: SPMI 000000007d4769a0 000040 (v05 GBT    GBTUACPI 00000000 AMI. 00000000)
Apr  9 18:34:11.972844 [    0.000000] ACPI: SSDT 000000007d4769e0 0D0CB0 (v02 GBT    GBTUACPI 00004000 INTL 20051117)
Apr  9 18:34:11.980851 [    0.000000] ACPI: EINJ 000000007d547690 000130 (v01 GBT    GBTUACPI 00000000      00000000)
Apr  9 18:34:11.988842 [    0.000000] ACPI: ERST 000000007d5477c0 000230 (v01 GBT    GBTUACPI 00000000      00000000)
Apr  9 18:34:11.996860 [    0.000000] ACPI: HEST 000000007d5479f0 0000A8 (v01 GBT    GBTUACPI 00000000      00000000)
Apr  9 18:34:12.004851 [    0.000000] ACPI: BERT 000000007d547a98 000030 (v01 GBT    GBTUACPI 00000000      00000000)
Apr  9 18:34:12.012850 [    0.000000] ACPI: DMAR 000000007d547ac8 00009C (v01 GBT    GBTUACPI 00000001 INTL 00000001)
Apr  9 18:34:12.021005 [    0.000000] Zone ranges:
Apr  9 18:34:12.021037 [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
Apr  9 18:34:12.029001 [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
Apr  9 18:34:12.029055 [    0.000000]   Normal   [mem 0x100000000-0x27fffffff]
Apr  9 18:34:12.036961 [    0.000000] Movable zone start for each node
Apr  9 18:34:12.044953 [    0.000000] Early memory node ranges
Apr  9 18:34:12.044997 [    0.000000]   node   0: [mem 0x00001000-0x0008efff]
Apr  9 18:34:12.053010 [    0.000000]   node   0: [mem 0x00100000-0x7d181fff]
Apr  9 18:34:12.053047 [    0.000000]   node   0: [mem 0x7f2eb000-0x7f2ebfff]
Apr  9 18:34:12.061012 [    0.000000]   node   0: [mem 0x7f372000-0x7f7fffff]
Apr  9 18:34:12.068962 [    0.000000]   node   0: [mem 0x100000000-0x27fffffff]
Apr  9 18:34:12.069009 [    0.000000] ACPI: PM-Timer IO Port: 0x408
Apr  9 18:34:12.076967 [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Apr  9 18:34:12.077016 [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
Apr  9 18:34:12.084997 [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
Apr  9 18:34:12.092968 [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
Apr  9 18:34:12.100958 [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
Apr  9 18:34:12.101007 [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Apr  9 18:34:12.108984 [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
Apr  9 18:34:12.116947 [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
Apr  9 18:34:12.124898 [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
Apr  9 18:34:12.124950 [    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
Apr  9 18:34:12.132933 [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec01000] gsi_base[24])
Apr  9 18:34:12.140925 [    0.000000] IOAPIC[1]: apic_id 2, version 32, address 0xfec01000, GSI 24-47
Apr  9 18:34:12.148848 [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Apr  9 18:34:12.156846 [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Apr  9 18:34:12.156890 [    0.000000] Using ACPI (MADT) for SMP configuration information
Apr  9 18:34:12.164855 [    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
Apr  9 18:34:12.172879 [    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
Apr  9 18:34:12.172904 [    0.000000] PM: Registered nosave memory: [mem 0x0008f000-0x0009ffff]
Apr  9 18:34:12.180877 [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
Apr  9 18:34:12.188844 [    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
Apr  9 18:34:12.196849 [    0.000000] PM: Registered nosave memory: [mem 0x7d182000-0x7d42efff]
Apr  9 18:34:12.205067 [    0.000000] PM: Registered nosave memory: [mem 0x7d42f000-0x7d547fff]
Apr  9 18:34:12.205113 [    0.000000] PM: Registered nosave memory: [mem 0x7d548000-0x7d76bfff]
Apr  9 18:34:12.213027 [    0.000000] PM: Registered nosave memory: [mem 0x7d76c000-0x7f2eafff]
Apr  9 18:34:12.221026 [    0.000000] PM: Registered nosave memory: [mem 0x7f2ec000-0x7f371fff]
Apr  9 18:34:12.229024 [    0.000000] PM: Registered nosave memory: [mem 0x7f800000-0x7fffffff]
Apr  9 18:34:12.237033 [    0.000000] PM: Registered nosave memory: [mem 0x80000000-0x8fffffff]
Apr  9 18:34:12.237072 [    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xfed1bfff]
Apr  9 18:34:12.245001 [    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
Apr  9 18:34:12.252876 [    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
Apr  9 18:34:12.260969 [    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
Apr  9 18:34:12.269037 [    0.000000] e820: [mem 0x90000000-0xfed1bfff] available for PCI devices
Apr  9 18:34:12.277055 [    0.000000] Booting paravirtualized kernel on bare hardware
Apr  9 18:34:12.277096 [    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
Apr  9 18:34:12.285062 [    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88027fc00000 s79040 r8192 d23360 u524288
Apr  9 18:34:12.293054 [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2053681
Apr  9 18:34:12.301035 [    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.14.34+ root=/dev/mapper/chardonnay1-root ro BOOTIF=01-90-2b-34-31-3d-a2 console=ttyS0,115200
Apr  9 18:34:12.316995 [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
Apr  9 18:34:12.325006 [    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Apr  9 18:34:12.325053 [    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Apr  9 18:34:12.333016 [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
Apr  9 18:34:12.340996 [    0.000000] Memory: 8103956K/8345212K available (7832K kernel code, 778K rwdata, 2516K rodata, 1064K init, 1020K bss, 241256K reserved)
Apr  9 18:34:12.357057 [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Apr  9 18:34:12.357098 [    0.000000] Hierarchical RCU implementation.
Apr  9 18:34:12.364992 [    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=4.
Apr  9 18:34:12.373011 [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
Apr  9 18:34:12.380965 [    0.000000] NR_IRQS:4352 nr_irqs:1024 16
Apr  9 18:34:12.381000 [    0.000000] Console: colour VGA+ 80x25
Apr  9 18:34:12.381043 [    0.000000] console [ttyS0] enabled
Apr  9 18:34:12.388979 [    0.000000] tsc: Fast TSC calibration using PIT
Apr  9 18:34:12.420874 [    0.000000] tsc: Detected 1799.938 MHz processor
Apr  9 18:34:12.420913 [    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 3599.87 BogoMIPS (lpj=1799938)
Apr  9 18:34:12.428994 [    0.010637] pid_max: default: 32768 minimum: 301
Apr  9 18:34:12.436995 [    0.015262] ACPI: Core revision 20131218
Apr  9 18:34:12.444849 [    0.051894] ACPI: All ACPI Tables successfully acquired
Apr  9 18:34:12.477038 [    0.057396] Security Framework initialized
Apr  9 18:34:12.485031 [    0.061506] SELinux:  Initializing.
Apr  9 18:34:12.485066 [    0.065021] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
Apr  9 18:34:12.493020 [    0.071897] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
Apr  9 18:34:12.501006 [    0.079444] Initializing cgroup subsys freezer
Apr  9 18:34:12.508946 [    0.083925] CPU: Physical Processor ID: 0
Apr  9 18:34:12.508968 [    0.087941] CPU: Processor Core ID: 0
Apr  9 18:34:12.516985 [    0.092727] mce: CPU supports 21 MCE banks
Apr  9 18:34:12.517011 [    0.096865] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
Apr  9 18:34:12.524944 [    0.096865] Last level dTLB entries: 4KB 512, 2MB 0, 4MB 0, 1GB 4
Apr  9 18:34:12.532885 [    0.096865] tlb_flushall_shift: 6
Apr  9 18:34:12.532922 [    0.111898] Freeing SMP alternatives memory: 28K (ffffffff81dce000 - ffffffff81dd5000)
Apr  9 18:34:12.540956 [    0.121883] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Apr  9 18:34:12.548866 [    0.137891] smpboot: CPU0: Intel(R) Xeon(R) CPU E5-2403 v2 @ 1.80GHz (fam: 06, model: 3e, stepping: 04)
Apr  9 18:34:12.572980 [    0.147351] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
Apr  9 18:34:12.580818 [    0.157750] ... version:                3
Apr  9 18:34:12.580849 [    0.161762] ... bit width:              48
Apr  9 18:34:12.588860 [    0.165853] ... generic registers:      8
Apr  9 18:34:12.588901 [    0.169860] ... value mask:             0000ffffffffffff
Apr  9 18:34:12.597023 [    0.175172] ... max period:             0000ffffffffffff
Apr  9 18:34:12.604958 [    0.180479] ... fixed-purpose events:   3
Apr  9 18:34:12.604989 [    0.184491] ... event mask:             00000007000000ff
Apr  9 18:34:12.613012 [    0.190059] x86: Booting SMP configuration:
Apr  9 18:34:12.613061 [    0.194245] .... node  #0, CPUs:      #1 #2 #3
Apr  9 18:34:12.660859 [    0.242125] x86: Booted up 1 node, 4 CPUs
Apr  9 18:34:12.669015 [    0.246324] smpboot: Total of 4 processors activated (14399.50 BogoMIPS)
Apr  9 18:34:12.676855 [    0.259207] devtmpfs: initialized
Apr  9 18:34:12.684998 [    0.265653] PM: Registering ACPI NVS region [mem 0x7d548000-0x7d76bfff] (2244608 bytes)
Apr  9 18:34:12.693020 [    0.273691] PM: Registering ACPI NVS region [mem 0x7f2ec000-0x7f371fff] (548864 bytes)
Apr  9 18:34:12.701031 [    0.281896] RTC time: 18:34:12, date: 04/09/15
Apr  9 18:34:12.709017 [    0.286381] NET: Registered protocol family 16
Apr  9 18:34:12.709054 [    0.291175] cpuidle: using governor ladder
Apr  9 18:34:12.716998 [    0.295275] cpuidle: using governor menu
Apr  9 18:34:12.724987 [    0.299239] ACPI: bus type PCI registered
Apr  9 18:34:12.725023 [    0.303342] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
Apr  9 18:34:12.732994 [    0.312640] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
Apr  9 18:34:12.740817 [    0.319879] PCI: Using configuration type 1 for base access
Apr  9 18:34:12.748923 [    0.335001] bio: create slab <bio-0> at 0
Apr  9 18:34:12.756967 [    0.339182] ACPI: Added _OSI(Module Device)
Apr  9 18:34:12.765054 [    0.343367] ACPI: Added _OSI(Processor Device)
Apr  9 18:34:12.773013 [    0.347812] ACPI: Added _OSI(3.0 _SCP Extensions)
Apr  9 18:34:12.773050 [    0.352511] ACPI: Added _OSI(Processor Aggregator Device)
Apr  9 18:34:12.780843 [    0.377310] ACPI: Executed 1 blocks of module-level executable AML code
Apr  9 18:34:12.805002 [    0.575008] ACPI: Interpreter enabled
Apr  9 18:34:12.996813 [    0.578687] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
Apr  9 18:34:13.012889 [    0.587936] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20131218/hwxface-580)
Apr  9 18:34:13.020825 [    0.597209] ACPI: (supports S0 S1 S4 S5)
Apr  9 18:34:13.020855 [    0.601128] ACPI: Using IOAPIC for interrupt routing
Apr  9 18:34:13.028828 [    0.606184] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Apr  9 18:34:13.036936 [    0.615640] ACPI: No dock devices found.
Apr  9 18:34:13.045051 [    0.647674] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
Apr  9 18:34:13.076834 [    0.653854] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
Apr  9 18:34:13.084831 [    0.662179] acpi PNP0A08:00: _OSC: platform does not support [AER]
Apr  9 18:34:13.092807 [    0.668498] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
Apr  9 18:34:13.100811 [    0.676409] PCI host bridge to bus 0000:00
Apr  9 18:34:13.100830 [    0.680507] pci_bus 0000:00: root bus resource [bus 00-fe]
Apr  9 18:34:13.108810 [    0.685992] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
Apr  9 18:34:13.116843 [    0.692172] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
Apr  9 18:34:13.116865 [    0.698353] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
Apr  9 18:34:13.124859 [    0.704534] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
Apr  9 18:34:13.132850 [    0.710714] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
Apr  9 18:34:13.140802 [    0.717589] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
Apr  9 18:34:13.148796 [    0.724463] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfbffffff]
Apr  9 18:34:13.156804 [    0.732849] pci 0000:00:1a.0: System wakeup disabled by ACPI
Apr  9 18:34:13.156826 [    0.738716] pci 0000:00:1c.0: System wakeup disabled by ACPI
Apr  9 18:34:13.164809 [    0.744576] pci 0000:00:1c.1: System wakeup disabled by ACPI
Apr  9 18:34:13.172822 [    0.750438] pci 0000:00:1c.2: System wakeup disabled by ACPI
Apr  9 18:34:13.180795 [    0.756336] pci 0000:00:1d.0: System wakeup disabled by ACPI
Apr  9 18:34:13.180818 [    0.762149] pci 0000:00:1e.0: System wakeup disabled by ACPI
Apr  9 18:34:13.188794 [    0.769004] pci 0000:00:11.0: PCI bridge to [bus 01]
Apr  9 18:34:13.196856 [    0.775993] pci 0000:00:1c.0: PCI bridge to [bus 02]
Apr  9 18:34:13.204928 [    0.782997] pci 0000:00:1c.1: PCI bridge to [bus 03]
Apr  9 18:34:13.212948 [    0.788339] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
Apr  9 18:34:13.220929 [    0.798343] pci 0000:00:1c.2: PCI bridge to [bus 04-05]
Apr  9 18:34:13.228924 [    0.804057] pci 0000:04:00.0: PCI bridge to [bus 05]
Apr  9 18:34:13.228943 [    0.809152] pci 0000:00:1e.0: PCI bridge to [bus 06] (subtractive decode)
Apr  9 18:34:13.236910 [    0.816285] ACPI: PCI Root Bridge [UNC0] (domain 0000 [bus ff])
Apr  9 18:34:13.244896 [    0.822210] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
Apr  9 18:34:13.252819 [    0.830406] acpi PNP0A03:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
Apr  9 18:34:13.260815 [    0.838476] PCI host bridge to bus 0000:ff
Apr  9 18:34:13.260834 [    0.842580] pci_bus 0000:ff: root bus resource [bus ff]
Apr  9 18:34:13.268819 [    0.850569] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
Apr  9 18:34:13.276877 [    0.857879] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
Apr  9 18:34:13.284884 [    0.865176] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15)
Apr  9 18:34:13.292876 [    0.872293] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
Apr  9 18:34:13.300977 [    0.879408] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
Apr  9 18:34:13.308885 [    0.886918] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
Apr  9 18:34:13.316918 [    0.894406] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
Apr  9 18:34:13.324932 [    0.901905] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
Apr  9 18:34:13.332862 [    0.910435] ACPI: Enabled 4 GPEs in block 00 to 3F
Apr  9 18:34:13.332883 [    0.915568] vgaarb: device added: PCI:0000:05:00.0,decodes=io+mem,owns=io+mem,locks=none
Apr  9 18:34:13.348936 [    0.923659] vgaarb: loaded
Apr  9 18:34:13.348955 [    0.926365] vgaarb: bridge control possible 0000:05:00.0
Apr  9 18:34:13.356892 [    0.931832] SCSI subsystem initialized
Apr  9 18:34:13.356911 [    0.935850] ACPI: bus type USB registered
Apr  9 18:34:13.364911 [    0.939931] usbcore: registered new interface driver usbfs
Apr  9 18:34:13.364932 [    0.945451] usbcore: registered new interface driver hub
Apr  9 18:34:13.372934 [    0.950800] usbcore: registered new device driver usb
Apr  9 18:34:13.380901 [    0.955964] pps_core: LinuxPPS API ver. 1 registered
Apr  9 18:34:13.380922 [    0.960925] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
Apr  9 18:34:13.388864 [    0.970080] PTP clock support registered
Apr  9 18:34:13.396838 [    0.974206] Advanced Linux Sound Architecture Driver Initialized.
Apr  9 18:34:13.404824 [    0.980303] PCI: Using ACPI for IRQ routing
Apr  9 18:34:13.404845 [    0.992118] cfg80211: Calling CRDA to update world regulatory domain
Apr  9 18:34:13.420860 [    0.998508] NetLabel: Initializing
Apr  9 18:34:13.420880 [    1.001910] NetLabel:  domain hash size = 128
Apr  9 18:34:13.428862 [    1.006270] NetLabel:  protocols = UNLABELED CIPSOv4
Apr  9 18:34:13.428884 [    1.011254] NetLabel:  unlabeled traffic allowed by default
Apr  9 18:34:13.436927 [    1.016978] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
Apr  9 18:34:13.444935 [    1.023319] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
Apr  9 18:34:13.452903 [    1.031178] Switched to clocksource hpet
Apr  9 18:34:13.452923 [    1.040114] pnp: PnP ACPI init
Apr  9 18:34:13.460825 [    1.043188] ACPI: bus type PNP registered
Apr  9 18:34:13.468929 [    1.047397] system 00:00: [mem 0xfc000000-0xfcffffff] has been reserved
Apr  9 18:34:13.476890 [    1.054011] system 00:00: [mem 0xfd000000-0xfdffffff] has been reserved
Apr  9 18:34:13.484920 [    1.060624] system 00:00: [mem 0xfe000000-0xfeafffff] has been reserved
Apr  9 18:34:13.484942 [    1.067236] system 00:00: [mem 0xfeb00000-0xfebfffff] has been reserved
Apr  9 18:34:13.492883 [    1.073852] system 00:00: [mem 0xfed00400-0xfed3ffff] could not be reserved
Apr  9 18:34:13.500907 [    1.080811] system 00:00: [mem 0xfed45000-0xfedfffff] has been reserved
Apr  9 18:34:13.508845 [    1.087541] system 00:01: [mem 0xfbffc000-0xfbffdfff] has been reserved
Apr  9 18:34:13.516833 [    1.094343] system 00:02: [io  0x0a00-0x0a1f] has been reserved
Apr  9 18:34:13.524850 [    1.100265] system 00:02: [io  0x0a20-0x0a2f] has been reserved
Apr  9 18:34:13.524872 [    1.106183] system 00:02: [io  0x0a30-0x0a3f] has been reserved
Apr  9 18:34:13.532865 [    1.112968] system 00:08: [io  0x04d0-0x04d1] has been reserved
Apr  9 18:34:13.540844 [    1.119343] system 00:0b: [io  0x0400-0x0453] could not be reserved
Apr  9 18:34:13.548842 [    1.125611] system 00:0b: [io  0x0458-0x047f] has been reserved
Apr  9 18:34:13.556858 [    1.131532] system 00:0b: [io  0x1180-0x119f] has been reserved
Apr  9 18:34:13.556881 [    1.137452] system 00:0b: [io  0x0500-0x057f] has been reserved
Apr  9 18:34:13.564853 [    1.143371] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
Apr  9 18:34:13.572856 [    1.149984] system 00:0b: [mem 0xfec00000-0xfecfffff] could not be reserved
Apr  9 18:34:13.580847 [    1.156947] system 00:0b: [mem 0xfed08000-0xfed08fff] has been reserved
Apr  9 18:34:13.588858 [    1.163560] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
Apr  9 18:34:13.588881 [    1.170286] system 00:0c: [io  0x0454-0x0457] has been reserved
Apr  9 18:34:13.596918 [    1.176726] pnp: PnP ACPI: found 14 devices
Apr  9 18:34:13.604862 [    1.180915] ACPI: bus type PNP unregistered
Apr  9 18:34:13.604884 [    1.194417] pci 0000:00:11.0: PCI bridge to [bus 01]
Apr  9 18:34:13.620859 [    1.199388] pci 0000:00:11.0:   bridge window [io  0xe000-0xefff]
Apr  9 18:34:13.628864 [    1.205485] pci 0000:00:11.0:   bridge window [mem 0xfbe00000-0xfbefffff]
Apr  9 18:34:13.636846 [    1.212270] pci 0000:00:11.0:   bridge window [mem 0xfb000000-0xfb4fffff 64bit pref]
Apr  9 18:34:13.644840 [    1.220014] pci 0000:00:1c.0: PCI bridge to [bus 02]
Apr  9 18:34:13.644862 [    1.224984] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
Apr  9 18:34:13.652837 [    1.231082] pci 0000:00:1c.0:   bridge window [mem 0xfbd00000-0xfbdfffff]
Apr  9 18:34:13.660818 [    1.237871] pci 0000:00:1c.1: PCI bridge to [bus 03]
Apr  9 18:34:13.660840 [    1.242841] pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
Apr  9 18:34:13.668832 [    1.248936] pci 0000:00:1c.1:   bridge window [mem 0xfbc00000-0xfbcfffff]
Apr  9 18:34:13.676845 [    1.255728] pci 0000:04:00.0: PCI bridge to [bus 05]
Apr  9 18:34:13.684845 [    1.260700] pci 0000:04:00.0:   bridge window [io  0xb000-0xbfff]
Apr  9 18:34:13.684866 [    1.266797] pci 0000:04:00.0:   bridge window [mem 0xfbb00000-0xfbbfffff]
Apr  9 18:34:13.692852 [    1.273592] pci 0000:04:00.0:   bridge window [mem 0xfa000000-0xfaffffff 64bit pref]
Apr  9 18:34:13.700867 [    1.281335] pci 0000:00:1c.2: PCI bridge to [bus 04-05]
Apr  9 18:34:13.708849 [    1.286565] pci 0000:00:1c.2:   bridge window [io  0xb000-0xbfff]
Apr  9 18:34:13.716843 [    1.292660] pci 0000:00:1c.2:   bridge window [mem 0xfbb00000-0xfbbfffff]
Apr  9 18:34:13.724845 [    1.299447] pci 0000:00:1c.2:   bridge window [mem 0xfa000000-0xfaffffff 64bit pref]
Apr  9 18:34:13.724872 [    1.307191] pci 0000:00:1e.0: PCI bridge to [bus 06]
Apr  9 18:34:13.732874 [    1.312262] NET: Registered protocol family 2
Apr  9 18:34:13.740846 [    1.316828] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
Apr  9 18:34:13.748840 [    1.324168] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Apr  9 18:34:13.748863 [    1.331089] TCP: Hash tables configured (established 65536 bind 65536)
Apr  9 18:34:13.756870 [    1.337637] TCP: reno registered
Apr  9 18:34:13.764840 [    1.340874] UDP hash table entries: 4096 (order: 5, 131072 bytes)
Apr  9 18:34:13.764862 [    1.346993] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
Apr  9 18:34:13.772852 [    1.353595] NET: Registered protocol family 1
Apr  9 18:34:13.780937 [    1.358027] RPC: Registered named UNIX socket transport module.
Apr  9 18:34:13.788949 [    1.363947] RPC: Registered udp transport module.
Apr  9 18:34:13.788970 [    1.368652] RPC: Registered tcp transport module.
Apr  9 18:34:13.796912 [    1.373361] RPC: Registered tcp NFSv4.1 backchannel transport module.
Apr  9 18:34:13.804797 [    1.410492] Unpacking initramfs...
Apr  9 18:34:13.836787 [    1.736570] Freeing initrd memory: 15856K (ffff8800360f8000 - ffff880037074000)
Apr  9 18:34:14.164871 [    1.743887] dmar: Host address width 46
Apr  9 18:34:14.172857 [    1.747731] dmar: DRHD base: 0x000000fbffc000 flags: 0x1
Apr  9 18:34:14.172883 [    1.753077] dmar: IOMMU 0: reg_base_addr fbffc000 ver 1:0 cap d2078c106f0466 ecap f020de
Apr  9 18:34:14.180853 [    1.761172] dmar: RMRR base: 0x0000007f1b6000 end: 0x0000007f1c3fff
Apr  9 18:34:14.188823 [    1.767442] dmar: ATSR flags: 0x0
Apr  9 18:34:14.188845 [    1.770760] dmar: RHSA base: 0x000000fbffc000 proximity domain: 0x0
Apr  9 18:34:14.196811 [    1.777033] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Apr  9 18:34:14.204801 [    1.783468] software IO TLB [mem 0x79182000-0x7d182000] (64MB) mapped at [ffff880079182000-ffff88007d181fff]
Apr  9 18:34:14.212812 [    1.793604] kvm: already loaded the other module
Apr  9 18:34:14.220807 [    1.798702] microcode: CPU0 sig=0x306e4, pf=0x8, revision=0x416
Apr  9 18:34:14.228805 [    1.804626] microcode: CPU1 sig=0x306e4, pf=0x8, revision=0x416
Apr  9 18:34:14.228828 [    1.810550] microcode: CPU2 sig=0x306e4, pf=0x8, revision=0x416
Apr  9 18:34:14.236811 [    1.816472] microcode: CPU3 sig=0x306e4, pf=0x8, revision=0x416
Apr  9 18:34:14.244802 [    1.822447] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Apr  9 18:34:14.252800 [    1.831772] Scanning for low memory corruption every 60 seconds
Apr  9 18:34:14.260796 [    1.838217] futex hash table entries: 1024 (order: 4, 65536 bytes)
Apr  9 18:34:14.268791 [    1.844453] audit: initializing netlink subsys (disabled)
Apr  9 18:34:14.268813 [    1.849864] audit: type=2000 audit(1428604452.358:1): initialized
Apr  9 18:34:14.276785 [    1.879641] HugeTLB registered 2 MB page size, pre-allocated 0 pages
Apr  9 18:34:14.308777 [    1.889980] VFS: Disk quotas dquot_6.5.2
Apr  9 18:34:14.316803 [    1.893984] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Apr  9 18:34:14.324808 [    1.901003] NFS: Registering the id_resolver key type
Apr  9 18:34:14.324830 [    1.906064] Key type id_resolver registered
Apr  9 18:34:14.332797 [    1.910250] Key type id_legacy registered
Apr  9 18:34:14.332816 [    1.914337] msgmni has been set to 15859
Apr  9 18:34:14.340798 [    1.918786] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
Apr  9 18:34:14.348801 [    1.926177] io scheduler noop registered
Apr  9 18:34:14.348820 [    1.930103] io scheduler deadline registered
Apr  9 18:34:14.356794 [    1.934438] io scheduler cfq registered (default)
Apr  9 18:34:14.356814 [    1.940215] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Apr  9 18:34:14.364798 [    1.946058] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
Apr  9 18:34:14.372807 [    1.954240] ACPI: Power Button [PWRB]
Apr  9 18:34:14.380807 [    1.957979] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
Apr  9 18:34:14.388787 [    1.965376] ACPI: Power Button [PWRF]
Apr  9 18:34:14.388806 [    1.975032] xenfs: not registering filesystem on non-xen platform
Apr  9 18:34:14.404826 [    1.981299] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Apr  9 18:34:14.412753 Apr  9 18:34:14.412768 <Modem lines changed: -DSR>
[    2.008160] 00:03: ttyS0 at I/O 0x
Apr  9 18:34:14.428844 <Modem lines changed: +DSR>
3f8 (irq = 4, base_baud = 115200) is a 16550A
Apr  9 18:34:14.436826 [    2.036170] 00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
Apr  9 18:34:14.468901 [    2.044265] Non-volatile memory driver v1.3
Apr  9 18:34:14.468934 [    2.049716] loop: module loaded
Apr  9 18:34:14.476894 [    2.053172] nbd: registered device at major 43
Apr  9 18:34:14.476914 [    2.060292] ahci 0000:00:1f.2: forcing PORTS_IMPL to 0x3f
Apr  9 18:34:14.484971 [    2.065782] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
Apr  9 18:34:14.492928 [    2.073957] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
Apr  9 18:34:14.500858 [    2.083151] scsi0 : ahci
Apr  9 18:34:14.508839 [    2.085990] scsi1 : ahci
Apr  9 18:34:14.508857 [    2.088737] scsi2 : ahci
Apr  9 18:34:14.508871 [    2.091559] scsi3 : ahci
Apr  9 18:34:14.516890 [    2.094320] scsi4 : ahci
Apr  9 18:34:14.516907 [    2.097088] scsi5 : ahci
Apr  9 18:34:14.524920 [    2.099834] ata1: SATA max UDMA/133 abar m2048@0xfbf02000 port 0xfbf02100 irq 68
Apr  9 18:34:14.524946 [    2.107225] ata2: SATA max UDMA/133 abar m2048@0xfbf02000 port 0xfbf02180 irq 68
Apr  9 18:34:14.532906 [    2.114619] ata3: SATA max UDMA/133 abar m2048@0xfbf02000 port 0xfbf02200 irq 68
Apr  9 18:34:14.540916 [    2.122011] ata4: SATA max UDMA/133 abar m2048@0xfbf02000 port 0xfbf02280 irq 68
Apr  9 18:34:14.548920 [    2.129408] ata5: SATA max UDMA/133 abar m2048@0xfbf02000 port 0xfbf02300 irq 68
Apr  9 18:34:14.556975 [    2.136800] ata6: SATA max UDMA/133 abar m2048@0xfbf02000 port 0xfbf02380 irq 68
Apr  9 18:34:14.564923 [    2.144699] tun: Universal TUN/TAP device driver, 1.6
Apr  9 18:34:14.572918 [    2.149757] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Apr  9 18:34:14.580922 [    2.156138] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
Apr  9 18:34:14.580946 [    2.162232] e100: Copyright(c) 1999-2006 Intel Corporation
Apr  9 18:34:14.588969 [    2.167805] sky2: driver version 1.30
Apr  9 18:34:14.588997 [    2.171827] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Apr  9 18:34:14.597096 [    2.178356] ehci-pci: EHCI PCI platform driver
Apr  9 18:34:14.605262 [    2.182939] ehci-pci 0000:00:1a.0: EHCI Host Controller
Apr  9 18:34:14.612967 [    2.188277] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
Apr  9 18:34:14.621008 [    2.195679] ehci-pci 0000:00:1a.0: debug port 2
Apr  9 18:34:14.621081 [    2.204108] ehci-pci 0000:00:1a.0: irq 16, io mem 0xfbf04000
Apr  9 18:34:14.628938 [    2.215427] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
Apr  9 18:34:14.644863 [    2.221222] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
Apr  9 18:34:14.653002 [    2.228010] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr  9 18:34:14.653052 [    2.235229] usb usb1: Product: EHCI Host Controller
Apr  9 18:34:14.660951 [    2.240111] usb usb1: Manufacturer: Linux 3.14.34+ ehci_hcd
Apr  9 18:34:14.668826 [    2.245683] usb usb1: SerialNumber: 0000:00:1a.0
Apr  9 18:34:14.668863 [    2.250521] hub 1-0:1.0: USB hub found
Apr  9 18:34:14.676898 [    2.254282] hub 1-0:1.0: 2 ports detected
Apr  9 18:34:14.676934 [    2.258494] ehci-pci 0000:00:1d.0: EHCI Host Controller
Apr  9 18:34:14.685002 [    2.263871] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
Apr  9 18:34:14.693022 [    2.271276] ehci-pci 0000:00:1d.0: debug port 2
Apr  9 18:34:14.700953 [    2.279712] ehci-pci 0000:00:1d.0: irq 23, io mem 0xfbf03000
Apr  9 18:34:14.708862 [    2.290440] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
Apr  9 18:34:14.717025 [    2.296209] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
Apr  9 18:34:14.724982 [    2.303000] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr  9 18:34:14.733037 [    2.310218] usb usb2: Product: EHCI Host Controller
Apr  9 18:34:14.733074 [    2.315100] usb usb2: Manufacturer: Linux 3.14.34+ ehci_hcd
Apr  9 18:34:14.741203 [    2.320673] usb usb2: SerialNumber: 0000:00:1d.0
Apr  9 18:34:14.749039 [    2.325539] hub 2-0:1.0: USB hub found
Apr  9 18:34:14.749091 [    2.329295] hub 2-0:1.0: 2 ports detected
Apr  9 18:34:14.757035 [    2.333467] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Apr  9 18:34:14.765039 [    2.339653] ohci-pci: OHCI PCI platform driver
Apr  9 18:34:14.765082 [    2.344202] uhci_hcd: USB Universal Host Controller Interface driver
Apr  9 18:34:14.772879 [    2.350696] usbcore: registered new interface driver usblp
Apr  9 18:34:14.780894 [    2.356292] usbcore: registered new interface driver usb-storage
Apr  9 18:34:14.780953 [    2.362605] i8042: PNP: No PS/2 controller found. Probing ports directly.
Apr  9 18:34:14.789122 [    2.369828] serio: i8042 KBD port at 0x60,0x64 irq 1
Apr  9 18:34:14.797129 [    2.374807] serio: i8042 AUX port at 0x60,0x64 irq 12
Apr  9 18:34:14.805043 [    2.380047] mousedev: PS/2 mouse device common for all mice
Apr  9 18:34:14.805113 [    2.385917] rtc_cmos 00:06: RTC can wake from S4
Apr  9 18:34:14.812906 [    2.390794] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
Apr  9 18:34:14.821080 [    2.396913] rtc_cmos 00:06: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Apr  9 18:34:14.829021 [    2.404788] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
Apr  9 18:34:14.829062 [    2.410915] device-mapper: uevent: version 1.0.3
Apr  9 18:34:14.837017 [    2.415727] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
Apr  9 18:34:14.844969 [    2.424277] hidraw: raw HID events driver (C) Jiri Kosina
Apr  9 18:34:14.852870 [    2.430552] usbcore: registered new interface driver usbhid
Apr  9 18:34:14.860976 [    2.436127] usbhid: USB HID core driver
Apr  9 18:34:14.861013 [    2.440624] Netfilter messages via NETLINK v0.30.
Apr  9 18:34:14.869011 [    2.445346] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Apr  9 18:34:14.869053 [    2.451571] ctnetlink v0.93: registering with nfnetlink.
Apr  9 18:34:14.877017 [    2.456974] ip_tables: (C) 2000-2006 Netfilter Core Team
Apr  9 18:34:14.885024 [    2.462312] TCP: cubic registered
Apr  9 18:34:14.885058 [    2.465633] Initializing XFRM netlink socket
Apr  9 18:34:14.893116 [    2.470162] NET: Registered protocol family 10
Apr  9 18:34:14.893174 [    2.474850] ip6_tables: (C) 2000-2006 Netfilter Core Team
Apr  9 18:34:14.901165 [    2.480287] sit: IPv6 over IPv4 tunneling driver
Apr  9 18:34:14.909028 [    2.485157] NET: Registered protocol family 17
Apr  9 18:34:14.909082 [    2.489638] Key type dns_resolver registered
Apr  9 18:34:14.917038 [    2.494520] registered taskstats version 1
Apr  9 18:34:14.917074 [    2.499199]   Magic number: 11:601:594
Apr  9 18:34:14.924931 [    2.503120] console [netcon0] enabled
Apr  9 18:34:14.924967 [    2.506783] netconsole: network logging started
Apr  9 18:34:14.932976 [    2.511883] ALSA device list:
Apr  9 18:34:14.933009 [    2.514857]   No soundcards found.
Apr  9 18:34:14.941089 Apr  9 18:34:14.941114 <Modem lines changed: +CTS>
[    2.565585] usb 1-1: new high-speed USB device number 2 using ehci-pci
Apr  9 18:34:14.996828 [    2.685905] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
Apr  9 18:34:15.117017 [    2.692617] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Apr  9 18:34:15.125045 [    2.700092] hub 1-1:1.0: USB hub found
Apr  9 18:34:15.125135 [    2.703910] hub 1-1:1.0: 6 ports detected
Apr  9 18:34:15.133044 [    2.798579] tsc: Refined TSC clocksource calibration: 1800.000 MHz
Apr  9 18:34:15.228789 [    2.810601] usb 2-1: new high-speed USB device number 2 using ehci-pci
Apr  9 18:34:15.236808 [    2.930953] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
Apr  9 18:34:15.356952 [    2.937660] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Apr  9 18:34:15.364827 [    2.945142] hub 2-1:1.0: USB hub found
Apr  9 18:34:15.372797 [    2.948956] hub 2-1:1.0: 8 ports detected
Apr  9 18:34:15.372832 [    3.027785] usb 1-1.1: new high-speed USB device number 3 using ehci-pci
Apr  9 18:34:15.452913 [    3.120740] usb 1-1.1: New USB device found, idVendor=0624, idProduct=0248
Apr  9 18:34:15.548845 [    3.127618] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Apr  9 18:34:15.556992 [    3.134931] usb 1-1.1: Product: Gadget USB HUB
Apr  9 18:34:15.557029 [    3.139378] usb 1-1.1: Manufacturer: no manufacturer
Apr  9 18:34:15.564911 [    3.144345] usb 1-1.1: SerialNumber: 0123456789
Apr  9 18:34:15.572971 [    3.149372] hub 1-1.1:1.0: USB hub found
Apr  9 18:34:15.573006 [    3.150621] ata1: failed to resume link (SControl 0)
Apr  9 18:34:15.581001 [    3.150636] ata1: SATA link down (SStatus 0 SControl 0)
Apr  9 18:34:15.581039 [    3.150649] ata4: failed to resume link (SControl 0)
Apr  9 18:34:15.589017 [    3.150666] ata4: SATA link down (SStatus 0 SControl 0)
Apr  9 18:34:15.596946 [    3.150679] ata3: failed to resume link (SControl 0)
Apr  9 18:34:15.596983 [    3.150696] ata3: SATA link down (SStatus 0 SControl 0)
Apr  9 18:34:15.604824 [    3.150706] ata5: failed to resume link (SControl 0)
Apr  9 18:34:15.612814 [    3.150724] ata5: SATA link down (SStatus 0 SControl 0)
Apr  9 18:34:15.612855 [    3.150735] ata6: failed to resume link (SControl 0)
Apr  9 18:34:15.620818 [    3.150754] ata6: SATA link down (SStatus 0 SControl 0)
Apr  9 18:34:15.628850 [    3.153618] ata2: failed to resume link (SControl 0)
Apr  9 18:34:15.628886 [    3.153635] ata2: SATA link down (SStatus 0 SControl 0)
Apr  9 18:34:15.636814 [    3.214757] hub 1-1.1:1.0: 5 ports detected
Apr  9 18:34:15.636850 [    3.215107] Freeing unused kernel memory: 1064K (ffffffff81cc4000 - ffffffff81dce000)
Apr  9 18:34:15.644855 [    3.215108] Write protecting the kernel read-only data: 12288k
Apr  9 18:34:15.652825 [    3.233673] Freeing unused kernel memory: 348K (ffff8800017a9000 - ffff880001800000)
Apr  9 18:34:15.660818 [    3.245627] Freeing unused kernel memory: 1580K (ffff880001a75000 - ffff880001c00000)
Apr  9 18:34:15.676913 Loading, please wait...
Apr  9 18:34:15.676944 [    3.265080] udevd[1263]: starting version 175
Apr  9 18:34:15.692787 [    3.362353] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
Apr  9 18:34:15.788883 [    3.366283] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
Apr  9 18:34:15.796886 [    3.366303] isci 0000:01:00.0: driver configured for rev: 6 silicon
Apr  9 18:34:15.804992 [    3.366307] isci 0000:01:00.0: OEM parameter table found in OROM
Apr  9 18:34:15.805032 [    3.366309] isci 0000:01:00.0: OEM SAS parameters (version: 1.0) loaded (platform)
Apr  9 18:34:15.813022 [    3.367373] isci 0000:01:00.0: SCU controller 0: phy 3-0 cables: {short, short, short, short}
Apr  9 18:34:15.821015 [    3.369991] scsi6 : isci
Apr  9 18:34:15.829047 [    3.405587] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
Apr  9 18:34:15.829087 [    3.411873] e1000e 0000:02:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
Apr  9 18:34:15.844832 [    3.494874] usb 1-1.1.1: new high-speed USB device number 4 using ehci-pci
Apr  9 18:34:15.924808 [    3.522442] e1000e 0000:02:00.0 eth0: registered PHC clock
Apr  9 18:34:15.948818 [    3.527939] e1000e 0000:02:00.0 eth0: (PCI Express:2.5GT/s:Width x1) 90:2b:34:31:3d:a2
Apr  9 18:34:15.956829 [    3.535862] e1000e 0000:02:00.0 eth0: Intel(R) PRO/1000 Network Connection
Apr  9 18:34:15.964817 [    3.542833] e1000e 0000:02:00.0 eth0: MAC: 3, PHY: 8, PBA No: FFFFFF-0FF
Apr  9 18:34:15.972828 [    3.549720] e1000e 0000:03:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
Apr  9 18:34:15.980866 [    3.577273] usb 1-1.1.1: New USB device found, idVendor=0624, idProduct=0249
Apr  9 18:34:16.005018 [    3.584331] usb 1-1.1.1: New USB device strings: Mfr=4, Product=5, SerialNumber=6
Apr  9 18:34:16.012988 [    3.591813] usb 1-1.1.1: Product: Keyboard/Mouse Function
Apr  9 18:34:16.020990 [    3.597216] usb 1-1.1.1: Manufacturer: Avocent
Apr  9 18:34:16.021038 [    3.601669] usb 1-1.1.1: SerialNumber: 20120124
Apr  9 18:34:16.028977 [    3.607453] input: Avocent Keyboard/Mouse Function as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/0003:0624:0249.0001/input/input5
Apr  9 18:34:16.044990 [    3.621693] hid-generic 0003:0624:0249.0001: input,hidraw0: USB HID v1.00 Keyboard [Avocent Keyboard/Mouse Function] on usb-0000:00:1a.0-1.1.1/input0
Apr  9 18:34:16.052941 [    3.636032] input: Avocent Keyboard/Mouse Function as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.1/0003:0624:0249.0002/input/input6
Apr  9 18:34:16.068826 [    3.650007] hid-generic 0003:0624:0249.0002: input,hidraw1: USB HID v1.00 Mouse [Avocent Keyboard/Mouse Function] on usb-0000:00:1a.0-1.1.1/input1
Apr  9 18:34:16.084810 [    3.664016] input: Avocent Keyboard/Mouse Function as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.2/0003:0624:0249.0003/input/input7
Apr  9 18:34:16.100997 [    3.670742] e1000e 0000:03:00.0 eth1: registered PHC clock
Apr  9 18:34:16.101036 [    3.670744] e1000e 0000:03:00.0 eth1: (PCI Express:2.5GT/s:Width x1) 90:2b:34:31:3d:a3
Apr  9 18:34:16.109018 [    3.670746] e1000e 0000:03:00.0 eth1: Intel(R) PRO/1000 Network Connection
Apr  9 18:34:16.117005 [    3.670831] e1000e 0000:03:00.0 eth1: MAC: 3, PHY: 8, PBA No: FFFFFF-0FF
Apr  9 18:34:16.124983 [    3.705181] hid-generic 0003:0624:0249.0003: input,hidraw2: USB HID v1.00 Mouse [Avocent Keyboard/Mouse Function] on usb-0000:00:1a.0-1.1.1/input2
Apr  9 18:34:16.140779 [    3.804936] Switched to clocksource tsc
Apr  9 18:34:16.228931 Begin: Loading essential drivers ... done.
Apr  9 18:34:16.812861 Begin: Running /scripts/init-premoun[    4.391810] random: lvm urandom read with 9 bits of entropy available
Apr  9 18:34:16.820844 t ... done.
Apr  9 18:34:16.820873 Begin: Mounting root file system ... Begin: Running /scripts/local-top ...   Volume group "chardonnay1" not found
Apr  9 18:34:16.828812   Skipping volume group chardonnay1
Apr  9 18:34:16.836786 Unable to find LVM volume chardonnay1/root
Apr  9 18:34:16.836806   Volume group "chardonnay1" not found
Apr  9 18:34:16.844820   Skipping volume group chardonnay1
Apr  9 18:34:16.844854 Unable to find LVM volume chardonnay1/swap_1
Apr  9 18:34:16.852805 done.
Apr  9 18:34:16.852834 Begin: Waiting for root file system ... done.
Apr  9 18:34:46.992813 Gave up waiting for root device.  Common problems:
Apr  9 18:34:47.000825  - Boot args (cat /proc/cmdline)
Apr  9 18:34:47.000861    - Check rootdelay= (did the system wait long enough?)
Apr  9 18:34:47.008811    - Check root= (did the system wait for the right device?)
Apr  9 18:34:47.008851  - Missing modules (cat /proc/modules; ls /dev)
Apr  9 18:34:47.016825 ALERT!  /dev/mapper/chardonnay1-root does not exist.  Dropping to a shell!
Apr  9 18:34:47.024939 
Apr  9 18:34:47.024967 
Apr  9 18:34:47.024989 BusyBox v1.20.2 (Debian 1:1.20.0-7) built-in shell (ash)
Apr  9 18:34:47.025023 Enter 'help' for a list of built-in commands.
Apr  9 18:34:47.032867 
Apr  9 18:34:47.032895 /bin/sh: can't access tty; job control turned off
