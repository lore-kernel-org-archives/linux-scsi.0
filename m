From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup
 / early userspace transition
Date: Wed, 31 Jul 2013 20:40:46 +0200
Message-ID: <51F95A2E.60805@fastmail.fm>
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm> <87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm> <87fvuxdqes.fsf@spindle.srvr.nix> <yq1txjdhree.fsf@sermon.lab.mkp.net> <51F80167.1080004@fastmail.fm> <yq1zjt3h11y.fsf@sermon.lab.mkp.net> <51F94E8D.5040908@fastmail.fm>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040009010701010601060502"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <51F94E8D.5040908@fastmail.fm>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Nix <nix@esperi.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, nick.cheng@areca.com.tw, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040009010701010601060502
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 07/31/2013 07:51 PM, Bernd Schubert wrote:
> On 07/31/2013 05:15 AM, Martin K. Petersen wrote:
>>>>>>> "Bernd" == Bernd Schubert <bernd.schubert@fastmail.fm> writes:
>>
>> Bernd,
>>
>>>> Product revision level: R001 
>>
>> It's clearly not verbatim passthrough...
>>
>> Bernd> Besides the firmware, the difference might be that I'm exporting
>> Bernd> single disks without any areca-raidset in between.  I can try to
>> Bernd> confirm that tomorrow, I just need the system as it is till
>> Bernd> tomorrow noon.
>>
>> That would be a great data point. I don't have any Areca boards.
>>
> 
> Just tested it, areca-raidset does not make a difference, but the
> firmware version does. After downgrading to 1.46 I have the same issue.
> 
> It is getting a bit late for me, but as this a pure development system,
> which is also booted over nfs, I can investigate it tomorrow.
> 


I couldn't resist and captured a few logs, see attachment. Is
0xffff88007feff180 the VPD inquiry? Can't we just cancel that command if
submitting it fails and then turn off VPD inquiry for this controller?

--------------040009010701010601060502
Content-Type: text/x-log;
 name="kern.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kern.log"

Jul 31 20:08:33 fslab1 kernel: [    0.000000] Linux version 3.11.0-rc1+ (schubert@fsdevel2) (gcc version 4.7.2 (Debian 4.7.2-5) ) #18 SMP Fri Jul 19 17:10:20 CEST 2013
Jul 31 20:08:33 fslab1 kernel: [    0.000000] Command line: crashkernel=256M console=tty0 console=ttyS0,115200 rw hpet=force
Jul 31 20:08:33 fslab1 kernel: [    0.000000] e820: BIOS-provided physical RAM map:
Jul 31 20:08:33 fslab1 kernel: [    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009fbff] usable
Jul 31 20:08:33 fslab1 kernel: [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
Jul 31 20:08:33 fslab1 kernel: [    0.000000] BIOS-e820: [mem 0x00000000000e6000-0x00000000000fffff] reserved
Jul 31 20:08:33 fslab1 kernel: [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cbfcffff] usable
Jul 31 20:08:33 fslab1 kernel: [    0.000000] BIOS-e820: [mem 0x00000000cbfd0000-0x00000000cbfddfff] ACPI data
Jul 31 20:08:33 fslab1 kernel: [    0.000000] BIOS-e820: [mem 0x00000000cbfde000-0x00000000cbffffff] ACPI NVS
Jul 31 20:08:33 fslab1 kernel: [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
Jul 31 20:08:33 fslab1 kernel: [    0.000000] BIOS-e820: [mem 0x00000000ff780000-0x00000000ffffffff] reserved
Jul 31 20:08:33 fslab1 kernel: [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000001ffffffff] usable
Jul 31 20:08:33 fslab1 kernel: [    0.000000] NX (Execute Disable) protection: active
Jul 31 20:08:33 fslab1 kernel: [    0.000000] SMBIOS 2.3 present.
Jul 31 20:08:33 fslab1 kernel: [    0.000000] No AGP bridge found
Jul 31 20:08:33 fslab1 kernel: [    0.000000] e820: last_pfn = 0x200000 max_arch_pfn = 0x400000000
Jul 31 20:08:33 fslab1 kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Jul 31 20:08:33 fslab1 kernel: [    0.000000] e820: last_pfn = 0xcbfd0 max_arch_pfn = 0x400000000
Jul 31 20:08:33 fslab1 kernel: [    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
Jul 31 20:08:33 fslab1 kernel: [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
Jul 31 20:08:33 fslab1 kernel: [    0.000000] init_memory_mapping: [mem 0x1ffe00000-0x1ffffffff]
Jul 31 20:08:33 fslab1 kernel: [    0.000000] init_memory_mapping: [mem 0x1fc000000-0x1ffdfffff]
Jul 31 20:08:33 fslab1 kernel: [    0.000000] init_memory_mapping: [mem 0x180000000-0x1fbffffff]
Jul 31 20:08:33 fslab1 kernel: [    0.000000] init_memory_mapping: [mem 0x00100000-0xcbfcffff]
Jul 31 20:08:33 fslab1 kernel: [    0.000000] init_memory_mapping: [mem 0x100000000-0x17fffffff]
Jul 31 20:08:33 fslab1 kernel: [    0.000000] RAMDISK: [mem 0x7f3a0000-0x7fff4fff]
Jul 31 20:08:33 fslab1 kernel: [    0.000000] Reserving 256MB of memory at 640MB for crashkernel (System RAM: 7359MB)
Jul 31 20:08:33 fslab1 kernel: [    0.000000] ACPI: RSDP 00000000000f88a0 00014 (v00 ACPIAM)
Jul 31 20:08:33 fslab1 kernel: [    0.000000] ACPI: RSDT 00000000cbfd0000 00038 (v01 A M I  OEMRSDT  04000607 MSFT 00000097)
Jul 31 20:08:33 fslab1 kernel: [    0.000000] ACPI: FACP 00000000cbfd0200 00084 (v02 A M I  OEMFACP  04000607 MSFT 00000097)
Jul 31 20:08:33 fslab1 kernel: [    0.000000] ACPI: DSDT 00000000cbfd0410 057C8 (v01  1ACAI 1ACAI003 00000003 INTL 02002026)
Jul 31 20:08:33 fslab1 kernel: [    0.000000] ACPI: FACS 00000000cbfde000 00040
Jul 31 20:08:33 fslab1 kernel: [    0.000000] ACPI: APIC 00000000cbfd0390 00078 (v01 A M I  OEMAPIC  04000607 MSFT 00000097)
Jul 31 20:08:33 fslab1 kernel: [    0.000000] ACPI: OEMB 00000000cbfde040 00073 (v01 A M I  AMI_OEM  04000607 MSFT 00000097)
Jul 31 20:08:33 fslab1 kernel: [    0.000000] ACPI: SRAT 00000000cbfd5be0 00110 (v01 A M I  OEMSRAT  04000607 MSFT 00000097)
Jul 31 20:08:33 fslab1 kernel: [    0.000000] ACPI: MCFG 00000000cbfd5cf0 0003C (v01 A M I  OEMMCFG  04000607 MSFT 00000097)
Jul 31 20:08:33 fslab1 kernel: [    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
Jul 31 20:08:33 fslab1 kernel: [    0.000000] SRAT: PXM 1 -> APIC 0x01 -> Node 1
Jul 31 20:08:33 fslab1 kernel: [    0.000000] SRAT: Node 0 PXM 0 [mem 0x00100000-0xcbffffff]
Jul 31 20:08:33 fslab1 kernel: [    0.000000] SRAT: Node 1 PXM 1 [mem 0x100000000-0x1ffffffff]
Jul 31 20:08:33 fslab1 kernel: [    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0xffffffff]
Jul 31 20:08:33 fslab1 kernel: [    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009fbff]
Jul 31 20:08:33 fslab1 kernel: [    0.000000] NUMA: Node 0 [mem 0x00100000-0xcbffffff] + [mem 0x00000000-0x0009fbff] -> [mem 0x00000000-0xcbffffff]
Jul 31 20:08:33 fslab1 kernel: [    0.000000] Initmem setup node 0 [mem 0x00000000-0xcbffffff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000]   NODE_DATA [mem 0xcbfcb000-0xcbfcffff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Initmem setup node 1 [mem 0x100000000-0x1ffffffff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000]   NODE_DATA [mem 0x1ffff5000-0x1ffff9fff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Zone ranges:
Jul 31 20:08:34 fslab1 kernel: [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000]   Normal   [mem 0x100000000-0x1ffffffff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Movable zone start for each node
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Early memory node ranges
Jul 31 20:08:34 fslab1 kernel: [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000]   node   0: [mem 0x00100000-0xcbfcffff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000]   node   1: [mem 0x100000000-0x1ffffffff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Nvidia board detected. Ignoring ACPI timer override.
Jul 31 20:08:34 fslab1 kernel: [    0.000000] If you got timer trouble try acpi_use_timer_override
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Detected use of extended apic ids on hypertransport bus
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Detected use of extended apic ids on hypertransport bus
Jul 31 20:08:34 fslab1 kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x4008
Jul 31 20:08:34 fslab1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Jul 31 20:08:34 fslab1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Jul 31 20:08:34 fslab1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
Jul 31 20:08:34 fslab1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
Jul 31 20:08:34 fslab1 kernel: [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Jul 31 20:08:34 fslab1 kernel: [    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
Jul 31 20:08:34 fslab1 kernel: [    0.000000] ACPI: IOAPIC (id[0x03] address[0xdf6fc000] gsi_base[24])
Jul 31 20:08:34 fslab1 kernel: [    0.000000] IOAPIC[1]: apic_id 3, version 17, address 0xdf6fc000, GSI 24-47
Jul 31 20:08:34 fslab1 kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Jul 31 20:08:34 fslab1 kernel: [    0.000000] ACPI: BIOS IRQ0 override ignored.
Jul 31 20:08:34 fslab1 kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Jul 31 20:08:34 fslab1 kernel: [    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
Jul 31 20:08:34 fslab1 kernel: [    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000e5fff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000] PM: Registered nosave memory: [mem 0x000e6000-0x000fffff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000] PM: Registered nosave memory: [mem 0xcbfd0000-0xcbfddfff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000] PM: Registered nosave memory: [mem 0xcbfde000-0xcbffffff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000] PM: Registered nosave memory: [mem 0xcc000000-0xfebfffff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xff77ffff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000] PM: Registered nosave memory: [mem 0xff780000-0xffffffff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000] e820: [mem 0xcc000000-0xfebfffff] available for PCI devices
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Booting paravirtualized kernel on bare hardware
Jul 31 20:08:34 fslab1 kernel: [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:2
Jul 31 20:08:34 fslab1 kernel: [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff8800cbc00000 s85824 r8192 d20672 u1048576
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 1858229
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Policy zone: Normal
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Kernel command line: crashkernel=256M console=tty0 console=ttyS0,115200 rw hpet=force
Jul 31 20:08:34 fslab1 kernel: [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Checking aperture...
Jul 31 20:08:34 fslab1 kernel: [    0.000000] No AGP bridge found
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Node 0: aperture @ 8000000 size 64 MB
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Aperture pointing to e820 RAM. Ignoring.
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Your BIOS doesn't leave a aperture memory hole
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Please enable the IOMMU option in the BIOS setup
Jul 31 20:08:34 fslab1 kernel: [    0.000000] This costs you 64 MB of RAM
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Mapping aperture over 65536 KB of RAM @ c0000000
Jul 31 20:08:34 fslab1 kernel: [    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xc3ffffff]
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Memory: 7014524K/7536056K available (5420K kernel code, 877K rwdata, 1724K rodata, 988K init, 784K bss, 521532K reserved)
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Hierarchical RCU implementation.
Jul 31 20:08:34 fslab1 kernel: [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
Jul 31 20:08:34 fslab1 kernel: [    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
Jul 31 20:08:34 fslab1 kernel: [    0.000000] NR_IRQS:33024 nr_irqs:1024 16
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Console: colour VGA+ 80x25
Jul 31 20:08:34 fslab1 kernel: [    0.000000] console [tty0] enabled
Jul 31 20:08:34 fslab1 kernel: [    0.000000] console [ttyS0] enabled
Jul 31 20:08:34 fslab1 kernel: [    0.000000] Enabling automatic NUMA balancing. Configure with numa_balancing= or sysctl
Jul 31 20:08:34 fslab1 kernel: [    0.000000] tsc: Fast TSC calibration using PIT
Jul 31 20:08:34 fslab1 kernel: [    0.000000] tsc: Detected 2399.870 MHz processor
Jul 31 20:08:34 fslab1 kernel: [    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
Jul 31 20:08:34 fslab1 kernel: [    0.016000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4799.74 BogoMIPS (lpj=9599480)
Jul 31 20:08:34 fslab1 kernel: [    0.020002] pid_max: default: 32768 minimum: 301
Jul 31 20:08:34 fslab1 kernel: [    0.024069] Security Framework initialized
Jul 31 20:08:34 fslab1 kernel: [    0.028011] TOMOYO Linux initialized
Jul 31 20:08:34 fslab1 kernel: [    0.032749] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Jul 31 20:08:34 fslab1 kernel: [    0.042558] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Jul 31 20:08:34 fslab1 kernel: [    0.048413] Mount-cache hash table entries: 256
Jul 31 20:08:34 fslab1 kernel: [    0.052285] Initializing cgroup subsys devices
Jul 31 20:08:34 fslab1 kernel: [    0.056005] Initializing cgroup subsys freezer
Jul 31 20:08:34 fslab1 kernel: [    0.060003] Initializing cgroup subsys net_cls
Jul 31 20:08:34 fslab1 kernel: [    0.064003] Initializing cgroup subsys blkio
Jul 31 20:08:34 fslab1 kernel: [    0.068040] mce: CPU supports 5 MCE banks
Jul 31 20:08:34 fslab1 kernel: [    0.072011] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
Jul 31 20:08:34 fslab1 kernel: [    0.072011] Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4
Jul 31 20:08:34 fslab1 kernel: [    0.072011] tlb_flushall_shift: 4
Jul 31 20:08:34 fslab1 kernel: [    0.076080] Freeing SMP alternatives memory: 20K (ffffffff818d1000 - ffffffff818d6000)
Jul 31 20:08:34 fslab1 kernel: [    0.080869] ACPI: Core revision 20130517
Jul 31 20:08:34 fslab1 kernel: [    0.090913] ACPI: All ACPI Tables successfully acquired
Jul 31 20:08:34 fslab1 kernel: [    0.096847] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
Jul 31 20:08:34 fslab1 kernel: [    0.142648] smpboot: CPU0: AMD Opteron(tm) Processor 250 (fam: 0f, model: 25, stepping: 01)
Jul 31 20:08:34 fslab1 kernel: [    0.152000] Performance Events: AMD PMU driver.
Jul 31 20:08:34 fslab1 kernel: [    0.152003] ... version:                0
Jul 31 20:08:34 fslab1 kernel: [    0.156001] ... bit width:              48
Jul 31 20:08:34 fslab1 kernel: [    0.160001] ... generic registers:      4
Jul 31 20:08:34 fslab1 kernel: [    0.164001] ... value mask:             0000ffffffffffff
Jul 31 20:08:34 fslab1 kernel: [    0.168001] ... max period:             00007fffffffffff
Jul 31 20:08:34 fslab1 kernel: [    0.172001] ... fixed-purpose events:   0
Jul 31 20:08:34 fslab1 kernel: [    0.176001] ... event mask:             000000000000000f
Jul 31 20:08:34 fslab1 kernel: [    0.181636] smpboot: Booting Node   1, Processors  #1
Jul 31 20:08:34 fslab1 kernel: [    0.276085] Brought up 2 CPUs
Jul 31 20:08:34 fslab1 kernel: [    0.279349] smpboot: Total of 2 processors activated (9600.02 BogoMIPS)
Jul 31 20:08:34 fslab1 kernel: [    0.280640] devtmpfs: initialized
Jul 31 20:08:34 fslab1 kernel: [    0.289066] PM: Registering ACPI NVS region [mem 0xcbfde000-0xcbffffff] (139264 bytes)
Jul 31 20:08:34 fslab1 kernel: [    0.293555] regulator-dummy: no parameters
Jul 31 20:08:34 fslab1 kernel: [    0.296095] NET: Registered protocol family 16
Jul 31 20:08:34 fslab1 kernel: [    0.300154] TOM: 00000000cc000000 aka 3264M
Jul 31 20:08:34 fslab1 kernel: [    0.304023] TOM2: 0000000200000000 aka 8192M
Jul 31 20:08:34 fslab1 kernel: [    0.308057] ACPI: bus type PCI registered
Jul 31 20:08:34 fslab1 kernel: [    0.312081] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
Jul 31 20:08:34 fslab1 kernel: [    0.316003] PCI: not using MMCONFIG
Jul 31 20:08:34 fslab1 kernel: [    0.320001] PCI: Using configuration type 1 for base access
Jul 31 20:08:34 fslab1 kernel: [    0.328152] bio: create slab <bio-0> at 0
Jul 31 20:08:34 fslab1 kernel: [    0.332071] ACPI: Added _OSI(Module Device)
Jul 31 20:08:34 fslab1 kernel: [    0.336003] ACPI: Added _OSI(Processor Device)
Jul 31 20:08:34 fslab1 kernel: [    0.340002] ACPI: Added _OSI(3.0 _SCP Extensions)
Jul 31 20:08:34 fslab1 kernel: [    0.344002] ACPI: Added _OSI(Processor Aggregator Device)
Jul 31 20:08:34 fslab1 kernel: [    0.355183] ACPI: Executed 1 blocks of module-level executable AML code
Jul 31 20:08:34 fslab1 kernel: [    0.366682] ACPI: Interpreter enabled
Jul 31 20:08:34 fslab1 kernel: [    0.368013] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130517/hwxface-571)
Jul 31 20:08:34 fslab1 kernel: [    0.378260] ACPI: (supports S0 S1 S3 S4 S5)
Jul 31 20:08:34 fslab1 kernel: [    0.380002] ACPI: Using IOAPIC for interrupt routing
Jul 31 20:08:34 fslab1 kernel: [    0.384036] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
Jul 31 20:08:34 fslab1 kernel: [    0.393168] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
Jul 31 20:08:34 fslab1 kernel: [    0.409180] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
Jul 31 20:08:34 fslab1 kernel: [    0.412192] ACPI: No dock devices found.
Jul 31 20:08:34 fslab1 kernel: [    0.433752] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-03])
Jul 31 20:08:34 fslab1 kernel: [    0.440537] PCI host bridge to bus 0000:00
Jul 31 20:08:34 fslab1 kernel: [    0.444004] pci_bus 0000:00: root bus resource [bus 00-03]
Jul 31 20:08:34 fslab1 kernel: [    0.448002] pci_bus 0000:00: root bus resource [io  0x6000-0xcfff]
Jul 31 20:08:34 fslab1 kernel: [    0.452002] pci_bus 0000:00: root bus resource [io  0x0000-0x4fff]
Jul 31 20:08:34 fslab1 kernel: [    0.456002] pci_bus 0000:00: root bus resource [mem 0xcc000000-0xdf4fffff]
Jul 31 20:08:34 fslab1 kernel: [    0.460002] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xe7ffffff]
Jul 31 20:08:34 fslab1 kernel: [    0.464002] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
Jul 31 20:08:34 fslab1 kernel: [    0.468002] pci_bus 0000:00: root bus resource [mem 0xec000000-0xffffffff]
Jul 31 20:08:34 fslab1 kernel: [    0.472002] pci_bus 0000:00: root bus resource [mem 0x200000000-0xfcffffffff]
Jul 31 20:08:34 fslab1 kernel: [    0.476421] pci 0000:00:02.0: System wakeup disabled by ACPI
Jul 31 20:08:34 fslab1 kernel: [    0.480126] pci 0000:00:02.1: System wakeup disabled by ACPI
Jul 31 20:08:34 fslab1 kernel: [    0.484587] pci 0000:00:09.0: System wakeup disabled by ACPI
Jul 31 20:08:34 fslab1 kernel: [    0.488125] pci 0000:00:0a.0: System wakeup disabled by ACPI
Jul 31 20:08:34 fslab1 kernel: [    0.492140] pci 0000:00:0d.0: System wakeup disabled by ACPI
Jul 31 20:08:34 fslab1 kernel: [    0.496138] pci 0000:00:0e.0: System wakeup disabled by ACPI
Jul 31 20:08:34 fslab1 kernel: [    0.501134] pci 0000:00:09.0: PCI bridge to [bus 03] (subtractive decode)
Jul 31 20:08:34 fslab1 kernel: [    0.504073] pci 0000:00:0d.0: PCI bridge to [bus 02]
Jul 31 20:08:34 fslab1 kernel: [    0.508456] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
Jul 31 20:08:34 fslab1 kernel: [    0.512007] pci 0000:00:0e.0: PCI bridge to [bus 01]
Jul 31 20:08:34 fslab1 kernel: [    0.516018] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
Jul 31 20:08:34 fslab1 kernel: [    0.520002] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
Jul 31 20:08:34 fslab1 kernel: [    0.528158] ACPI: PCI Root Bridge [PCIB] (domain 0000 [bus 80-84])
Jul 31 20:08:34 fslab1 kernel: [    0.532537] PCI host bridge to bus 0000:80
Jul 31 20:08:34 fslab1 kernel: [    0.536008] pci_bus 0000:80: root bus resource [bus 80-84]
Jul 31 20:08:34 fslab1 kernel: [    0.540002] pci_bus 0000:80: root bus resource [io  0xd000-0xffff]
Jul 31 20:08:34 fslab1 kernel: [    0.544002] pci_bus 0000:80: root bus resource [io  0x5000-0x5fff]
Jul 31 20:08:34 fslab1 kernel: [    0.548002] pci_bus 0000:80: root bus resource [mem 0xdf500000-0xdfffffff]
Jul 31 20:08:34 fslab1 kernel: [    0.552002] pci_bus 0000:80: root bus resource [mem 0xe8000000-0xebffffff]
Jul 31 20:08:34 fslab1 kernel: [    0.556498] pci 0000:80:0a.0: System wakeup disabled by ACPI
Jul 31 20:08:34 fslab1 kernel: [    0.560117] pci 0000:80:0d.0: System wakeup disabled by ACPI
Jul 31 20:08:34 fslab1 kernel: [    0.564118] pci 0000:80:0e.0: System wakeup disabled by ACPI
Jul 31 20:08:34 fslab1 kernel: [    0.568100] pci 0000:80:0d.0: PCI bridge to [bus 84]
Jul 31 20:08:34 fslab1 kernel: [    0.580011] pci 0000:80:0e.0: PCI bridge to [bus 81-83]
Jul 31 20:08:34 fslab1 kernel: [    0.584230] pci 0000:81:00.0: PCI bridge to [bus 83]
Jul 31 20:08:34 fslab1 kernel: [    0.588083] pci 0000:81:00.2: PCI bridge to [bus 82]
Jul 31 20:08:34 fslab1 kernel: [    0.592017] acpi PNP0A03:01: ACPI _OSC support notification failed, disabling PCIe ASPM
Jul 31 20:08:34 fslab1 kernel: [    0.596002] acpi PNP0A03:01: Unable to request _OSC control (_OSC support mask: 0x08)
Jul 31 20:08:34 fslab1 kernel: [    0.600264] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *0, disabled.
Jul 31 20:08:34 fslab1 kernel: [    0.607035] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
Jul 31 20:08:34 fslab1 kernel: [    0.611042] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 *18 19)
Jul 31 20:08:34 fslab1 kernel: [    0.617516] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 *19)
Jul 31 20:08:34 fslab1 kernel: [    0.621820] ACPI: PCI Interrupt Link [LNKE] (IRQs 16 17 18 19) *0, disabled.
Jul 31 20:08:34 fslab1 kernel: [    0.627031] ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22) *0, disabled.
Jul 31 20:08:34 fslab1 kernel: [    0.630729] ACPI: PCI Interrupt Link [LUS1] (IRQs 20 21 22) *0, disabled.
Jul 31 20:08:34 fslab1 kernel: [    0.637814] ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22) *0, disabled.
Jul 31 20:08:34 fslab1 kernel: [    0.645379] ACPI: PCI Interrupt Link [LKLN] (IRQs 20 21 22) *0, disabled.
Jul 31 20:08:34 fslab1 kernel: [    0.652381] ACPI: PCI Interrupt Link [LAUI] (IRQs 20 21 22) *0, disabled.
Jul 31 20:08:34 fslab1 kernel: [    0.658729] ACPI: PCI Interrupt Link [LKMO] (IRQs 20 21 22) *0, disabled.
Jul 31 20:08:34 fslab1 kernel: [    0.662728] ACPI: PCI Interrupt Link [LKSM] (IRQs 20 21 22) *0, disabled.
Jul 31 20:08:34 fslab1 kernel: [    0.670428] ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 *22)
Jul 31 20:08:34 fslab1 kernel: [    0.676526] ACPI: PCI Interrupt Link [LTIE] (IRQs 20 *21 22)
Jul 31 20:08:34 fslab1 kernel: [    0.681546] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22) *0, disabled.
Jul 31 20:08:34 fslab1 kernel: [    0.689833] ACPI: PCI Interrupt Link [LN2A] (IRQs 40 41 42 *43)
Jul 31 20:08:34 fslab1 kernel: [    0.696386] ACPI: PCI Interrupt Link [LN2B] (IRQs 40 41 42 43) *0, disabled.
Jul 31 20:08:34 fslab1 kernel: [    0.704046] ACPI: PCI Interrupt Link [LN2C] (IRQs 40 41 42 43) *0, disabled.
Jul 31 20:08:34 fslab1 kernel: [    0.711035] ACPI: PCI Interrupt Link [LN2D] (IRQs 40 41 42 43) *0, disabled.
Jul 31 20:08:34 fslab1 kernel: [    0.715036] ACPI: PCI Interrupt Link [LK2N] (IRQs 44 45 46 47) *0, disabled.
Jul 31 20:08:34 fslab1 kernel: [    0.722734] ACPI: PCI Interrupt Link [LT3D] (IRQs 44 45 46 *47)
Jul 31 20:08:34 fslab1 kernel: [    0.729222] ACPI: PCI Interrupt Link [LT2E] (IRQs 44 45 *46 47)
Jul 31 20:08:34 fslab1 kernel: [    0.734021] vgaarb: device added: PCI:0000:03:01.0,decodes=io+mem,owns=none,locks=none
Jul 31 20:08:34 fslab1 kernel: [    0.740009] vgaarb: loaded
Jul 31 20:08:34 fslab1 kernel: [    0.744001] vgaarb: bridge control possible 0000:03:01.0
Jul 31 20:08:34 fslab1 kernel: [    0.752056] ACPI: bus type USB registered
Jul 31 20:08:34 fslab1 kernel: [    0.756035] usbcore: registered new interface driver usbfs
Jul 31 20:08:34 fslab1 kernel: [    0.760017] usbcore: registered new interface driver hub
Jul 31 20:08:34 fslab1 kernel: [    0.764015] usbcore: registered new device driver usb
Jul 31 20:08:34 fslab1 kernel: [    0.772091] PCI: Using ACPI for IRQ routing
Jul 31 20:08:34 fslab1 kernel: [    0.782618] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Jul 31 20:08:34 fslab1 kernel: [    0.788006] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
Jul 31 20:08:34 fslab1 kernel: [    0.793156] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
Jul 31 20:08:34 fslab1 kernel: [    0.802018] Switched to clocksource hpet
Jul 31 20:08:34 fslab1 kernel: [    0.814071] pnp: PnP ACPI init
Jul 31 20:08:34 fslab1 kernel: [    0.817232] ACPI: bus type PNP registered
Jul 31 20:08:34 fslab1 kernel: [    0.824057] pnp 00:08: disabling [mem 0xdfefc000-0xdfefcfff] because it overlaps 0000:80:0e.0 BAR 15 [mem 0xdf700000-0xdfefffff 64bit pref]
Jul 31 20:08:34 fslab1 kernel: [    0.836670] pnp 00:08: disabling [mem 0xdfefd000-0xdfefd3ff] because it overlaps 0000:80:0e.0 BAR 15 [mem 0xdf700000-0xdfefffff 64bit pref]
Jul 31 20:08:34 fslab1 kernel: [    0.849289] pnp 00:08: disabling [mem 0xdfefe000-0xdfefe3ff] because it overlaps 0000:80:0e.0 BAR 15 [mem 0xdf700000-0xdfefffff 64bit pref]
Jul 31 20:08:34 fslab1 kernel: [    0.861907] pnp 00:08: disabling [mem 0xdfeff000-0xdfefffff] because it overlaps 0000:80:0e.0 BAR 15 [mem 0xdf700000-0xdfefffff 64bit pref]
Jul 31 20:08:34 fslab1 kernel: [    0.874527] pnp 00:08: disabling [mem 0xdfefc000-0xdfefcfff disabled] because it overlaps 0000:81:00.0 BAR 15 [mem 0xdf700000-0xdfefffff 64bit pref]
Jul 31 20:08:34 fslab1 kernel: [    0.887928] pnp 00:08: disabling [mem 0xdfefd000-0xdfefd3ff disabled] because it overlaps 0000:81:00.0 BAR 15 [mem 0xdf700000-0xdfefffff 64bit pref]
Jul 31 20:08:34 fslab1 kernel: [    0.901325] pnp 00:08: disabling [mem 0xdfefe000-0xdfefe3ff disabled] because it overlaps 0000:81:00.0 BAR 15 [mem 0xdf700000-0xdfefffff 64bit pref]
Jul 31 20:08:34 fslab1 kernel: [    0.914723] pnp 00:08: disabling [mem 0xdfeff000-0xdfefffff disabled] because it overlaps 0000:81:00.0 BAR 15 [mem 0xdf700000-0xdfefffff 64bit pref]
Jul 31 20:08:34 fslab1 kernel: [    0.928158] system 00:08: [io  0x0190-0x0193] has been reserved
Jul 31 20:08:34 fslab1 kernel: [    0.934144] system 00:08: [io  0x04d0-0x04d1] has been reserved
Jul 31 20:08:34 fslab1 kernel: [    0.940134] system 00:08: [io  0x4000-0x40ff window] could not be reserved
Jul 31 20:08:34 fslab1 kernel: [    0.947076] system 00:08: [io  0x4400-0x44ff window] has been reserved
Jul 31 20:08:34 fslab1 kernel: [    0.953672] system 00:08: [io  0x4800-0x48ff window] has been reserved
Jul 31 20:08:34 fslab1 kernel: [    0.960269] system 00:08: [mem 0xffb80000-0xfffffffe] has been reserved
Jul 31 20:08:34 fslab1 kernel: [    0.966948] system 00:08: [mem 0xfefff000-0xfeffffff] has been reserved
Jul 31 20:08:34 fslab1 kernel: [    0.973769] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
Jul 31 20:08:34 fslab1 kernel: [    0.980802] system 00:09: [mem 0xfee00000-0xfeefffff] has been reserved
Jul 31 20:08:34 fslab1 kernel: [    0.988019] system 00:0a: [io  0x0680-0x06ff] has been reserved
Jul 31 20:08:34 fslab1 kernel: [    0.994005] system 00:0a: [io  0x0295-0x0296] has been reserved
Jul 31 20:08:34 fslab1 kernel: [    0.999992] system 00:0a: [io  0x0778-0x077f] has been reserved
Jul 31 20:08:34 fslab1 kernel: [    1.005981] system 00:0a: [io  0x0b78-0x0b7f] has been reserved
Jul 31 20:08:34 fslab1 kernel: [    1.011970] system 00:0a: [io  0x0f78-0x0f7f] has been reserved
Jul 31 20:08:34 fslab1 kernel: [    1.018080] system 00:0b: [mem 0xe0000000-0xefffffff] could not be reserved
Jul 31 20:08:34 fslab1 kernel: [    1.025421] system 00:0c: [mem 0x00000000-0x0009ffff] could not be reserved
Jul 31 20:08:34 fslab1 kernel: [    1.032454] system 00:0c: [mem 0x000c0000-0x000dffff] could not be reserved
Jul 31 20:08:34 fslab1 kernel: [    1.039482] system 00:0c: [mem 0x000e0000-0x000fffff] could not be reserved
Jul 31 20:08:34 fslab1 kernel: [    1.046511] system 00:0c: [mem 0x00100000-0xcbffffff] could not be reserved
Jul 31 20:08:34 fslab1 kernel: [    1.054233] pnp: PnP ACPI: found 13 devices
Jul 31 20:08:34 fslab1 kernel: [    1.058478] ACPI: bus type PNP unregistered
Jul 31 20:08:34 fslab1 kernel: [    1.069953] pci 0000:00:09.0: PCI bridge to [bus 03]
Jul 31 20:08:34 fslab1 kernel: [    1.074982] pci 0000:00:09.0:   bridge window [io  0x8000-0x8fff]
Jul 31 20:08:34 fslab1 kernel: [    1.081139] pci 0000:00:09.0:   bridge window [mem 0xcc200000-0xce2fffff]
Jul 31 20:08:34 fslab1 kernel: [    1.087995] pci 0000:00:09.0:   bridge window [mem 0xcf400000-0xdf3fffff pref]
Jul 31 20:08:34 fslab1 kernel: [    1.095310] pci 0000:00:0d.0: PCI bridge to [bus 02]
Jul 31 20:08:34 fslab1 kernel: [    1.100342] pci 0000:00:0e.0: PCI bridge to [bus 01]
Jul 31 20:08:34 fslab1 kernel: [    1.105366] pci 0000:00:0e.0:   bridge window [mem 0xcc000000-0xcc1fffff]
Jul 31 20:08:34 fslab1 kernel: [    1.112218] pci 0000:00:0e.0:   bridge window [mem 0xce400000-0xcf3fffff 64bit pref]
Jul 31 20:08:34 fslab1 kernel: [    1.120057] pci 0000:80:0d.0: PCI bridge to [bus 84]
Jul 31 20:08:34 fslab1 kernel: [    1.125087] pci 0000:81:00.0: PCI bridge to [bus 83]
Jul 31 20:08:34 fslab1 kernel: [    1.130119] pci 0000:81:00.0:   bridge window [mem 0xdf500000-0xdf5fffff]
Jul 31 20:08:34 fslab1 kernel: [    1.136971] pci 0000:81:00.0:   bridge window [mem 0xdf700000-0xdfefffff 64bit pref]
Jul 31 20:08:34 fslab1 kernel: [    1.144806] pci 0000:81:00.2: PCI bridge to [bus 82]
Jul 31 20:08:34 fslab1 kernel: [    1.149840] pci 0000:80:0e.0: PCI bridge to [bus 81-83]
Jul 31 20:08:34 fslab1 kernel: [    1.155131] pci 0000:80:0e.0:   bridge window [mem 0xdf500000-0xdf5fffff]
Jul 31 20:08:34 fslab1 kernel: [    1.161983] pci 0000:80:0e.0:   bridge window [mem 0xdf700000-0xdfefffff 64bit pref]
Jul 31 20:08:34 fslab1 kernel: [    1.169981] NET: Registered protocol family 2
Jul 31 20:08:34 fslab1 kernel: [    1.174716] TCP established hash table entries: 65536 (order: 8, 1048576 bytes)
Jul 31 20:08:34 fslab1 kernel: [    1.182724] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Jul 31 20:08:34 fslab1 kernel: [    1.190089] TCP: Hash tables configured (established 65536 bind 65536)
Jul 31 20:08:34 fslab1 kernel: [    1.196759] TCP: reno registered
Jul 31 20:08:34 fslab1 kernel: [    1.200067] UDP hash table entries: 4096 (order: 5, 131072 bytes)
Jul 31 20:08:34 fslab1 kernel: [    1.206307] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
Jul 31 20:08:34 fslab1 kernel: [    1.213101] NET: Registered protocol family 1
Jul 31 20:08:34 fslab1 kernel: [    1.217681] RPC: Registered named UNIX socket transport module.
Jul 31 20:08:34 fslab1 kernel: [    1.223669] RPC: Registered udp transport module.
Jul 31 20:08:34 fslab1 kernel: [    1.228432] RPC: Registered tcp transport module.
Jul 31 20:08:34 fslab1 kernel: [    1.233197] RPC: Registered tcp NFSv4.1 backchannel transport module.
Jul 31 20:08:34 fslab1 kernel: [    1.240128] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 22
Jul 31 20:08:34 fslab1 kernel: [    1.246433] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 21
Jul 31 20:08:34 fslab1 kernel: [    1.252465] pci 0000:00:00.0: Found enabled HT MSI Mapping
Jul 31 20:08:34 fslab1 kernel: [    1.258025] pci 0000:00:0d.0: Found disabled HT MSI Mapping
Jul 31 20:08:34 fslab1 kernel: [    1.263669] pci 0000:00:00.0: Found enabled HT MSI Mapping
Jul 31 20:08:34 fslab1 kernel: [    1.269220] pci 0000:00:0d.0: Linking AER extended capability
Jul 31 20:08:34 fslab1 kernel: [    1.275065] pci 0000:00:00.0: Found enabled HT MSI Mapping
Jul 31 20:08:34 fslab1 kernel: [    1.280623] pci 0000:00:0e.0: Found disabled HT MSI Mapping
Jul 31 20:08:34 fslab1 kernel: [    1.286264] pci 0000:00:00.0: Found enabled HT MSI Mapping
Jul 31 20:08:34 fslab1 kernel: [    1.291813] pci 0000:00:0e.0: Linking AER extended capability
Jul 31 20:08:34 fslab1 kernel: [    1.297734] pci 0000:80:00.0: Found disabled HT MSI Mapping
Jul 31 20:08:34 fslab1 kernel: [    1.303368] pci 0000:80:0d.0: Enabling HT MSI Mapping
Jul 31 20:08:34 fslab1 kernel: [    1.308492] pci 0000:80:0d.0: Found enabled HT MSI Mapping
Jul 31 20:08:34 fslab1 kernel: [    1.314043] pci 0000:80:0d.0: Linking AER extended capability
Jul 31 20:08:34 fslab1 kernel: [    1.319881] pci 0000:80:00.0: Found disabled HT MSI Mapping
Jul 31 20:08:34 fslab1 kernel: [    1.325525] pci 0000:80:0e.0: Enabling HT MSI Mapping
Jul 31 20:08:34 fslab1 kernel: [    1.330642] pci 0000:80:0e.0: Found enabled HT MSI Mapping
Jul 31 20:08:34 fslab1 kernel: [    1.336195] pci 0000:80:0e.0: Linking AER extended capability
Jul 31 20:08:34 fslab1 kernel: [    1.342004] pci 0000:81:00.0: rerouting interrupts for [8086:0370]
Jul 31 20:08:34 fslab1 kernel: [    1.348247] pci 0000:81:00.2: rerouting interrupts for [8086:0372]
Jul 31 20:08:34 fslab1 kernel: [    1.354572] Unpacking initramfs...
Jul 31 20:08:34 fslab1 kernel: [    1.655909] Freeing initrd memory: 12628K (ffff88007f3a0000 - ffff88007fff5000)
Jul 31 20:08:34 fslab1 kernel: [    1.663966] PCI-DMA: Disabling AGP.
Jul 31 20:08:34 fslab1 kernel: [    1.667644] PCI-DMA: aperture base @ c0000000 size 65536 KB
Jul 31 20:08:34 fslab1 kernel: [    1.673282] PCI-DMA: using GART IOMMU.
Jul 31 20:08:34 fslab1 kernel: [    1.677100] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
Jul 31 20:08:34 fslab1 kernel: [    1.688613] audit: initializing netlink socket (disabled)
Jul 31 20:08:34 fslab1 kernel: [    1.694108] type=2000 audit(1375294092.692:1): initialized
Jul 31 20:08:34 fslab1 kernel: [    1.713587] bounce pool size: 64 pages
Jul 31 20:08:34 fslab1 kernel: [    1.717423] HugeTLB registered 2 MB page size, pre-allocated 0 pages
Jul 31 20:08:34 fslab1 kernel: [    1.724372] zbud: loaded
Jul 31 20:08:34 fslab1 kernel: [    1.728071] VFS: Disk quotas dquot_6.5.2
Jul 31 20:08:34 fslab1 kernel: [    1.732090] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Jul 31 20:08:34 fslab1 kernel: [    1.738841] NFS: Registering the id_resolver key type
Jul 31 20:08:34 fslab1 kernel: [    1.743971] Key type id_resolver registered
Jul 31 20:08:34 fslab1 kernel: [    1.748213] Key type id_legacy registered
Jul 31 20:08:34 fslab1 kernel: [    1.752304] msgmni has been set to 13853
Jul 31 20:08:34 fslab1 kernel: [    1.756673] alg: No test for stdrng (krng)
Jul 31 20:08:34 fslab1 kernel: [    1.760878] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Jul 31 20:08:34 fslab1 kernel: [    1.768371] io scheduler noop registered
Jul 31 20:08:34 fslab1 kernel: [    1.772358] io scheduler deadline registered
Jul 31 20:08:34 fslab1 kernel: [    1.776713] io scheduler cfq registered (default)
Jul 31 20:08:34 fslab1 kernel: [    1.782154] GHES: HEST is not enabled!
Jul 31 20:08:34 fslab1 kernel: [    1.786043] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Jul 31 20:08:34 fslab1 kernel: [    1.812687] 00:04: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Jul 31 20:08:34 fslab1 kernel: [    1.838689] 00:05: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Jul 31 20:08:34 fslab1 kernel: [    1.844697] Linux agpgart interface v0.103
Jul 31 20:08:34 fslab1 kernel: [    1.848981] i8042: PNP: No PS/2 controller found. Probing ports directly.
Jul 31 20:08:34 fslab1 kernel: [    1.857936] serio: i8042 KBD port at 0x60,0x64 irq 1
Jul 31 20:08:34 fslab1 kernel: [    1.862968] serio: i8042 AUX port at 0x60,0x64 irq 12
Jul 31 20:08:34 fslab1 kernel: [    1.868249] mousedev: PS/2 mouse device common for all mice
Jul 31 20:08:34 fslab1 kernel: [    1.873934] usbcore: registered new interface driver keyspan_remote
Jul 31 20:08:34 fslab1 kernel: [    1.880291] rtc_cmos 00:01: RTC can wake from S4
Jul 31 20:08:34 fslab1 kernel: [    1.885127] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
Jul 31 20:08:34 fslab1 kernel: [    1.891316] rtc_cmos 00:01: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
Jul 31 20:08:34 fslab1 kernel: [    1.898994] cpuidle: using governor ladder
Jul 31 20:08:34 fslab1 kernel: [    1.903155] cpuidle: using governor menu
Jul 31 20:08:34 fslab1 kernel: [    1.907219] drop_monitor: Initializing network drop monitor service
Jul 31 20:08:34 fslab1 kernel: [    1.913631] TCP: cubic registered
Jul 31 20:08:34 fslab1 kernel: [    1.917058] NET: Registered protocol family 10
Jul 31 20:08:34 fslab1 kernel: [    1.921814] mip6: Mobile IPv6
Jul 31 20:08:34 fslab1 kernel: [    1.924846] NET: Registered protocol family 17
Jul 31 20:08:34 fslab1 kernel: [    1.929387] Key type dns_resolver registered
Jul 31 20:08:34 fslab1 kernel: [    1.934040] registered taskstats version 1
Jul 31 20:08:34 fslab1 kernel: [    1.939145] rtc_cmos 00:01: setting system clock to 2013-07-31 18:08:14 UTC (1375294094)
Jul 31 20:08:34 fslab1 kernel: [    1.948695] Freeing unused kernel memory: 988K (ffffffff817da000 - ffffffff818d1000)
Jul 31 20:08:34 fslab1 kernel: [    2.106009] SCSI subsystem initialized
Jul 31 20:08:34 fslab1 kernel: [    2.115488] ACPI: bus type ATA registered
Jul 31 20:08:34 fslab1 kernel: [    2.188996] Floppy drive(s): fd0 is 1.44M
Jul 31 20:08:34 fslab1 kernel: [    2.194201] ACPI: PCI Interrupt Link [LTID] enabled at IRQ 20
Jul 31 20:08:34 fslab1 kernel: [    2.201286] sata_nv 0000:00:07.0: Using ADMA mode
Jul 31 20:08:34 fslab1 kernel: [    2.206240] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
Jul 31 20:08:34 fslab1 kernel: [    2.213403] e1000: Copyright (c) 1999-2006 Intel Corporation.
Jul 31 20:08:34 fslab1 kernel: [    2.219331] scsi0 : sata_nv
Jul 31 20:08:34 fslab1 kernel: [    2.223958] scsi1 : sata_nv
Jul 31 20:08:34 fslab1 kernel: [    2.224596] FDC 0 is a post-1991 82077
Jul 31 20:08:34 fslab1 kernel: [    2.231190] ata1: SATA max UDMA/133 cmd 0xc800 ctl 0xc400 bmdma 0xb800 irq 20
Jul 31 20:08:34 fslab1 kernel: [    2.238400] ata2: SATA max UDMA/133 cmd 0xc000 ctl 0xbc00 bmdma 0xb808 irq 20
Jul 31 20:08:34 fslab1 kernel: [    2.245626] e1000 0000:03:02.0: enabling device (0000 -> 0003)
Jul 31 20:08:34 fslab1 kernel: [    2.251764] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 19
Jul 31 20:08:34 fslab1 kernel: [    2.257996] ACPI: PCI Interrupt Link [LTIE] enabled at IRQ 21
Jul 31 20:08:34 fslab1 kernel: [    2.263813] sata_nv 0000:00:08.0: Using ADMA mode
Jul 31 20:08:34 fslab1 kernel: [    2.268950] scsi2 : sata_nv
Jul 31 20:08:34 fslab1 kernel: [    2.271903] scsi3 : sata_nv
Jul 31 20:08:34 fslab1 kernel: [    2.274851] ata3: SATA max UDMA/133 cmd 0xb400 ctl 0xb000 bmdma 0xa400 irq 21
Jul 31 20:08:34 fslab1 kernel: [    2.282057] ata4: SATA max UDMA/133 cmd 0xac00 ctl 0xa800 bmdma 0xa408 irq 21
Jul 31 20:08:34 fslab1 kernel: [    2.289611] ACPI: PCI Interrupt Link [LT3D] enabled at IRQ 47
Jul 31 20:08:34 fslab1 kernel: [    2.295435] sata_nv 0000:80:07.0: Using ADMA mode
Jul 31 20:08:34 fslab1 kernel: [    2.525162] scsi4 : sata_nv
Jul 31 20:08:34 fslab1 kernel: [    2.528129] scsi5 : sata_nv
Jul 31 20:08:34 fslab1 kernel: [    2.531064] ata5: SATA max UDMA/133 cmd 0xf800 ctl 0xf400 bmdma 0xe800 irq 47
Jul 31 20:08:34 fslab1 kernel: [    2.538268] ata6: SATA max UDMA/133 cmd 0xf000 ctl 0xec00 bmdma 0xe808 irq 47
Jul 31 20:08:34 fslab1 kernel: [    2.545874] scsi6 : pata_amd
Jul 31 20:08:34 fslab1 kernel: [    2.549228] scsi7 : pata_amd
Jul 31 20:08:34 fslab1 kernel: [    2.552533] ata7: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x3000 irq 14
Jul 31 20:08:34 fslab1 kernel: [    2.559562] ata8: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x3008 irq 15
Jul 31 20:08:34 fslab1 kernel: [    2.566907] ACPI: PCI Interrupt Link [LT2E] enabled at IRQ 46
Jul 31 20:08:34 fslab1 kernel: [    2.576024] ata1: SATA link down (SStatus 0 SControl 300)
Jul 31 20:08:34 fslab1 kernel: [    2.579853] sata_nv 0000:80:08.0: Using ADMA mode
Jul 31 20:08:34 fslab1 kernel: [    2.580211] scsi8 : sata_nv
Jul 31 20:08:34 fslab1 kernel: [    2.580301] scsi9 : sata_nv
Jul 31 20:08:34 fslab1 kernel: [    2.580375] ata9: SATA max UDMA/133 cmd 0xe400 ctl 0xe000 bmdma 0xd400 irq 46
Jul 31 20:08:34 fslab1 kernel: [    2.580377] ata10: SATA max UDMA/133 cmd 0xdc00 ctl 0xd800 bmdma 0xd408 irq 46
Jul 31 20:08:34 fslab1 kernel: [    2.714106] e1000 0000:03:02.0 eth0: (PCI:33MHz:32-bit) 00:0e:0c:b8:c7:59
Jul 31 20:08:34 fslab1 kernel: [    2.720969] e1000 0000:03:02.0 eth0: Intel(R) PRO/1000 Network Connection
Jul 31 20:08:34 fslab1 kernel: [    2.741599] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
Jul 31 20:08:34 fslab1 kernel: [    2.760039] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jul 31 20:08:34 fslab1 kernel: [    2.806774] ata3.00: ATA-7: ST3808110AS, 3.AAE, max UDMA/133
Jul 31 20:08:34 fslab1 kernel: [    2.812496] ata3.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
Jul 31 20:08:34 fslab1 kernel: [    2.856018] ata5: SATA link down (SStatus 0 SControl 300)
Jul 31 20:08:34 fslab1 kernel: [    2.881741] ata3.00: configured for UDMA/133
Jul 31 20:08:34 fslab1 kernel: [    2.888017] ata9: SATA link down (SStatus 0 SControl 300)
Jul 31 20:08:34 fslab1 kernel: [    2.916015] ata2: SATA link down (SStatus 0 SControl 300)
Jul 31 20:08:34 fslab1 kernel: [    2.921630] scsi 2:0:0:0: Direct-Access     ATA      ST3808110AS      3.AA PQ: 0 ANSI: 5
Jul 31 20:08:34 fslab1 kernel: [    2.929821] ata3: DMA mask 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
Jul 31 20:08:34 fslab1 kernel: [    2.978730] scsi 2:0:0:0: Attached scsi generic sg0 type 0
Jul 31 20:08:34 fslab1 kernel: [    3.252021] ata4: SATA link down (SStatus 0 SControl 300)
Jul 31 20:08:34 fslab1 kernel: [    3.568016] ata6: SATA link down (SStatus 0 SControl 300)
Jul 31 20:08:34 fslab1 kernel: [    4.048016] ata10: SATA link down (SStatus 0 SControl 300)
Jul 31 20:08:34 fslab1 kernel: [    6.773704] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
Jul 31 20:08:34 fslab1 kernel: [    6.781132] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Jul 31 20:08:34 fslab1 kernel: [    9.265986] Not activating Mandatory Access Control as /sbin/tomoyo-init does not exist.
Jul 31 20:08:34 fslab1 kernel: [    9.453482] fuse init (API version 7.22)
Jul 31 20:08:34 fslab1 kernel: [   10.290548] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Jul 31 20:08:34 fslab1 kernel: [   10.310898] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Jul 31 20:08:34 fslab1 kernel: [   10.327763] ohci-pci: OHCI PCI platform driver
Jul 31 20:08:34 fslab1 kernel: [   10.332633] ohci-pci 0000:00:02.0: OHCI PCI host controller
Jul 31 20:08:34 fslab1 kernel: [   10.338316] ohci-pci 0000:00:02.0: new USB bus registered, assigned bus number 1
Jul 31 20:08:34 fslab1 kernel: [   10.349119] ohci-pci 0000:00:02.0: irq 22, io mem 0xce3fb000
Jul 31 20:08:34 fslab1 kernel: [   10.386389] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
Jul 31 20:08:34 fslab1 kernel: [   10.396640] ACPI: Power Button [PWRB]
Jul 31 20:08:34 fslab1 kernel: [   10.410050] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
Jul 31 20:08:34 fslab1 kernel: [   10.416922] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jul 31 20:08:34 fslab1 kernel: [   10.424358] usb usb1: Product: OHCI PCI host controller
Jul 31 20:08:34 fslab1 kernel: [   10.429652] usb usb1: Manufacturer: Linux 3.11.0-rc1+ ohci_hcd
Jul 31 20:08:34 fslab1 kernel: [   10.435671] usb usb1: SerialNumber: 0000:00:02.0
Jul 31 20:08:34 fslab1 kernel: [   10.444386] hub 1-0:1.0: USB hub found
Jul 31 20:08:34 fslab1 kernel: [   10.444467] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
Jul 31 20:08:34 fslab1 kernel: [   10.444473] ACPI: Power Button [PWRF]
Jul 31 20:08:34 fslab1 kernel: [   10.461485] hub 1-0:1.0: 10 ports detected
Jul 31 20:08:34 fslab1 kernel: [   10.467594] ACPI Warning: 0x0000000000004c00-0x0000000000004c3f SystemIO conflicts with Region \_SB_.PCI0.SMBU.SMRG 1 (20130517/utaddress-251)
Jul 31 20:08:34 fslab1 kernel: [   10.480723] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Jul 31 20:08:34 fslab1 kernel: [   10.491140] i2c i2c-0: nForce2 SMBus adapter at 0x4c40
Jul 31 20:08:34 fslab1 kernel: [   10.502302] ehci-pci: EHCI PCI platform driver
Jul 31 20:08:34 fslab1 kernel: [   10.511877] ehci-pci 0000:00:02.1: EHCI Host Controller
Jul 31 20:08:34 fslab1 kernel: [   10.517916] ehci-pci 0000:00:02.1: new USB bus registered, assigned bus number 2
Jul 31 20:08:34 fslab1 kernel: [   10.525748] ehci-pci 0000:00:02.1: debug port 1
Jul 31 20:08:34 fslab1 kernel: [   10.532191] ehci-pci 0000:00:02.1: irq 21, io mem 0xce3e0000
Jul 31 20:08:34 fslab1 kernel: [   10.548033] ehci-pci 0000:00:02.1: USB 2.0 started, EHCI 1.00
Jul 31 20:08:34 fslab1 kernel: [   10.554173] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
Jul 31 20:08:34 fslab1 kernel: [   10.561040] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Jul 31 20:08:34 fslab1 kernel: [   10.568495] usb usb2: Product: EHCI Host Controller
Jul 31 20:08:34 fslab1 kernel: [   10.573444] usb usb2: Manufacturer: Linux 3.11.0-rc1+ ehci_hcd
Jul 31 20:08:34 fslab1 kernel: [   10.579476] usb usb2: SerialNumber: 0000:00:02.1
Jul 31 20:08:34 fslab1 kernel: [   10.586237] hub 2-0:1.0: USB hub found
Jul 31 20:08:34 fslab1 kernel: [   10.590358] hub 2-0:1.0: 10 ports detected
Jul 31 20:08:34 fslab1 kernel: [   10.596130] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Jul 31 20:08:34 fslab1 kernel: [   10.615412] EDAC MC: Ver: 3.0.0
Jul 31 20:08:34 fslab1 kernel: [   10.631605] microcode: AMD CPU family 0xf not supported
Jul 31 20:08:34 fslab1 kernel: [   10.632102] MCE: In-kernel MCE decoding enabled.
Jul 31 20:08:34 fslab1 kernel: [   10.651281] AMD64 EDAC driver v3.4.0
Jul 31 20:08:34 fslab1 kernel: [   10.655993] ib_mthca: Mellanox InfiniBand HCA driver v1.0 (April 4, 2008)
Jul 31 20:08:34 fslab1 kernel: [   10.663005] ib_mthca: Initializing 0000:01:00.0
Jul 31 20:08:34 fslab1 kernel: [   10.667805] hub 1-0:1.0: USB hub found
Jul 31 20:08:34 fslab1 kernel: [   10.671747] hub 1-0:1.0: 10 ports detected
Jul 31 20:08:34 fslab1 kernel: [   10.676493] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 18
Jul 31 20:08:34 fslab1 kernel: [   10.694669] [Firmware Bug]: powernow-k8: No compatible ACPI _PSS objects found.
Jul 31 20:08:34 fslab1 kernel: [   10.694669] [Firmware Bug]: powernow-k8: First, make sure Cool'N'Quiet is enabled in the BIOS.
Jul 31 20:08:34 fslab1 kernel: [   10.694669] [Firmware Bug]: powernow-k8: If that doesn't help, try upgrading your BIOS.
Jul 31 20:08:34 fslab1 kernel: [   10.718812] microcode: AMD CPU family 0xf not supported
Jul 31 20:08:34 fslab1 kernel: [   10.727616] input: PC Speaker as /devices/platform/pcspkr/input/input2
Jul 31 20:08:34 fslab1 kernel: [   10.745647] sd 2:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
Jul 31 20:08:34 fslab1 kernel: [   10.754107] [Firmware Bug]: powernow-k8: No compatible ACPI _PSS objects found.
Jul 31 20:08:34 fslab1 kernel: [   10.754107] [Firmware Bug]: powernow-k8: First, make sure Cool'N'Quiet is enabled in the BIOS.
Jul 31 20:08:34 fslab1 kernel: [   10.754107] [Firmware Bug]: powernow-k8: If that doesn't help, try upgrading your BIOS.
Jul 31 20:08:34 fslab1 kernel: [   10.754396] sd 2:0:0:0: [sda] Write Protect is off
Jul 31 20:08:34 fslab1 kernel: [   10.754421] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 31 20:08:34 fslab1 kernel: [   10.822492]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
Jul 31 20:08:34 fslab1 kernel: [   10.829826] sd 2:0:0:0: [sda] Attached SCSI disk
Jul 31 20:08:34 fslab1 kernel: [   13.135832] EDAC amd64: DRAM ECC enabled.
Jul 31 20:08:34 fslab1 kernel: [   13.139917] EDAC amd64: K8 revE or earlier detected (node 0).
Jul 31 20:08:34 fslab1 kernel: [   13.145774] EDAC amd64: CS0: Registered Double data rate SDRAM
Jul 31 20:08:34 fslab1 kernel: [   13.151669] EDAC amd64: CS2: Registered Double data rate SDRAM
Jul 31 20:08:34 fslab1 kernel: [   13.157706] EDAC MC0: Giving out device to 'amd64_edac' 'K8': DEV 0000:00:18.2
Jul 31 20:08:34 fslab1 kernel: [   13.165947] EDAC amd64: DRAM ECC enabled.
Jul 31 20:08:34 fslab1 kernel: [   13.170065] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Jul 31 20:08:34 fslab1 kernel: [   13.176865] EDAC amd64: K8 revE or earlier detected (node 1).
Jul 31 20:08:34 fslab1 kernel: [   13.182728] EDAC amd64: CS0: Registered Double data rate SDRAM
Jul 31 20:08:34 fslab1 kernel: [   13.188639] EDAC amd64: CS2: Registered Double data rate SDRAM
Jul 31 20:08:34 fslab1 kernel: [   13.194904] EDAC MC1: Giving out device to 'amd64_edac' 'K8': DEV 0000:00:19.2
Jul 31 20:08:34 fslab1 kernel: [   13.202318] EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
Jul 31 20:08:34 fslab1 kernel: [   14.155673] loop: module loaded
Jul 31 20:08:34 fslab1 kernel: [   14.196967] netif_napi_add() called with weight 100 on device 
Jul 31 20:08:34 fslab1 kernel: [   16.334799] device-mapper: uevent: version 1.0.3
Jul 31 20:08:34 fslab1 kernel: [   16.339905] device-mapper: ioctl: 4.25.0-ioctl (2013-06-26) initialised: dm-devel@redhat.com
Jul 31 20:08:34 fslab1 kernel: [   17.809080] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Jul 31 20:08:43 fslab1 kernel: [   31.408701] rc.local (3571): /proc/319/oom_adj is deprecated, please use /proc/319/oom_score_adj instead.
Jul 31 20:08:43 fslab1 kernel: [   31.433045] IPv6: ADDRCONF(NETDEV_UP): ib0: link is not ready
Jul 31 20:08:44 fslab1 kernel: [   31.439754] IPv6: ADDRCONF(NETDEV_CHANGE): ib0: link becomes ready
Jul 31 20:12:30 fslab1 kernel: [  258.324616] ACPI: PCI Interrupt Link [LN2A] enabled at IRQ 43
Jul 31 20:12:30 fslab1 kernel: [  258.330738] Error handler scsi_eh_10 sleeping
Jul 31 20:12:30 fslab1 kernel: [  258.344062] Areca RAID Controller10: F/W V1.46 2009-01-06 & Model ARC-1260
Jul 31 20:12:30 fslab1 kernel: [  258.364021] scsi10 : Areca SATA Host Adapter RAID Controller( RAID6 capable)
Jul 31 20:12:30 fslab1 kernel: [  258.364021]  Driver Version 1.20.00.15 2010/08/05
Jul 31 20:12:31 fslab1 kernel: [  258.376015] scsi host10: scsi_scan_host_selected: <4294967295:4294967295:4294967295>
Jul 31 20:12:31 fslab1 kernel: [  258.383880] scsi 10:0:0:0: scsi scan: INQUIRY pass 1 length 36
Jul 31 20:12:31 fslab1 kernel: [  258.389914] scsi 10:0:0:0: Send: 
Jul 31 20:12:31 fslab1 kernel: [  258.393275] 0xffff88007feff180 
Jul 31 20:12:31 fslab1 kernel: [  258.396524] scsi 10:0:0:0: CDB: 
Jul 31 20:12:31 fslab1 kernel: [  258.399789] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:31 fslab1 kernel: [  258.403916] buffer = 0xffff8800bebf4ec0, bufflen = 36, queuecommand 0xffffffffa029a350
Jul 31 20:12:31 fslab1 kernel: [  258.411879] leaving scsi_dispatch_cmnd()
Jul 31 20:12:31 fslab1 kernel: [  258.415852] scsi 10:0:0:0: Done: 
Jul 31 20:12:31 fslab1 kernel: [  258.419208] 0xffff88007feff180 SUCCESS
Jul 31 20:12:31 fslab1 kernel: [  258.423035] scsi 10:0:0:0:  
Jul 31 20:12:31 fslab1 kernel: [  258.425949] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 31 20:12:31 fslab1 kernel: [  258.432007] scsi 10:0:0:0: CDB: 
Jul 31 20:12:31 fslab1 kernel: [  258.435266] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:31 fslab1 kernel: [  258.439394] scsi 10:0:0:0: scsi host busy 1 failed 0
Jul 31 20:12:31 fslab1 kernel: [  258.444423] scsi 10:0:0:0: Notifying upper driver of completion (result 10000)
Jul 31 20:12:31 fslab1 kernel: [  258.451736] 0 sectors total, 36 bytes done.
Jul 31 20:12:31 fslab1 kernel: [  258.456119] scsi scan: INQUIRY failed with code 0x10000
Jul 31 20:12:31 fslab1 kernel: [  258.461571] scsi 10:0:1:0: scsi scan: INQUIRY pass 1 length 36
Jul 31 20:12:31 fslab1 kernel: [  258.467602] scsi 10:0:1:0: Send: 
Jul 31 20:12:31 fslab1 kernel: [  258.471002] 0xffff88007feff180 
Jul 31 20:12:31 fslab1 kernel: [  258.474244] scsi 10:0:1:0: CDB: 
Jul 31 20:12:31 fslab1 kernel: [  258.477535] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:31 fslab1 kernel: [  258.481684] buffer = 0xffff8800bebf4ec0, bufflen = 36, queuecommand 0xffffffffa029a350
Jul 31 20:12:31 fslab1 kernel: [  258.489694] leaving scsi_dispatch_cmnd()
Jul 31 20:12:31 fslab1 kernel: [  258.493691] scsi 10:0:1:0: Done: 
Jul 31 20:12:31 fslab1 kernel: [  258.497071] 0xffff88007feff180 SUCCESS
Jul 31 20:12:31 fslab1 kernel: [  258.500932] scsi 10:0:1:0:  
Jul 31 20:12:31 fslab1 kernel: [  258.503870] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:31 fslab1 kernel: [  258.509248] scsi 10:0:1:0: CDB: 
Jul 31 20:12:33 fslab1 kernel: [  258.512537] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:33 fslab1 kernel: [  258.516684] scsi 10:0:1:0: scsi host busy 1 failed 0
Jul 31 20:12:33 fslab1 kernel: [  258.521715] scsi 10:0:1:0: Notifying upper driver of completion (result 0)
Jul 31 20:12:33 fslab1 kernel: [  258.528658] 0 sectors total, 36 bytes done.
Jul 31 20:12:33 fslab1 kernel: [  258.532955] scsi scan: INQUIRY successful with code 0x0
Jul 31 20:12:33 fslab1 kernel: [  258.538263] scsi 10:0:1:0: scsi scan: INQUIRY pass 2 length 96
Jul 31 20:12:33 fslab1 kernel: [  258.544302] scsi 10:0:1:0: Send: 
Jul 31 20:12:33 fslab1 kernel: [  258.547673] 0xffff88007feff180 
Jul 31 20:12:33 fslab1 kernel: [  258.550923] scsi 10:0:1:0: CDB: 
Jul 31 20:12:33 fslab1 kernel: [  258.554214] Inquiry: 12 00 00 00 60 00
Jul 31 20:12:33 fslab1 kernel: [  258.558361] buffer = 0xffff8800bebf4ec0, bufflen = 96, queuecommand 0xffffffffa029a350
Jul 31 20:12:33 fslab1 kernel: [  258.566372] leaving scsi_dispatch_cmnd()
Jul 31 20:12:33 fslab1 kernel: [  258.570370] scsi 10:0:1:0: Done: 
Jul 31 20:12:33 fslab1 kernel: [  258.573747] 0xffff88007feff180 SUCCESS
Jul 31 20:12:33 fslab1 kernel: [  258.577593] scsi 10:0:1:0:  
Jul 31 20:12:33 fslab1 kernel: [  258.580534] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:33 fslab1 kernel: [  258.585908] scsi 10:0:1:0: CDB: 
Jul 31 20:12:33 fslab1 kernel: [  258.589198] Inquiry: 12 00 00 00 60 00
Jul 31 20:12:33 fslab1 kernel: [  258.593338] scsi 10:0:1:0: scsi host busy 1 failed 0
Jul 31 20:12:33 fslab1 kernel: [  258.598367] scsi 10:0:1:0: Notifying upper driver of completion (result 0)
Jul 31 20:12:33 fslab1 kernel: [  258.605309] 0 sectors total, 96 bytes done.
Jul 31 20:12:33 fslab1 kernel: [  258.609574] scsi scan: INQUIRY successful with code 0x0
Jul 31 20:12:33 fslab1 kernel: [  258.614905] scsi 10:0:1:0: scsi scan: peripheral qualifier of 3, device not added
Jul 31 20:12:33 fslab1 kernel: [  258.622479] scsi 10:0:1:0: scsi scan: consider passing scsi_mod.dev_flags=Hitachi:HDS724040KLSA80:0x240 or 0x1000240
Jul 31 20:12:33 fslab1 kernel: [  258.633125] scsi scan: Sending REPORT LUNS to host 10 channel 0 id 1 (try 0)
Jul 31 20:12:33 fslab1 kernel: [  258.640252] scsi 10:0:1:0: Send: 
Jul 31 20:12:33 fslab1 kernel: [  258.643626] 0xffff88007feff180 
Jul 31 20:12:33 fslab1 kernel: [  258.646874] scsi 10:0:1:0: CDB: 
Jul 31 20:12:33 fslab1 kernel: [  258.650167] Report luns: a0 00 00 00 00 00 00 00 10 00 00 00
Jul 31 20:12:33 fslab1 kernel: [  258.656481] buffer = 0xffff8800bebf4ec0, bufflen = 4096, queuecommand 0xffffffffa029a350
Jul 31 20:12:33 fslab1 kernel: [  258.664667] leaving scsi_dispatch_cmnd()
Jul 31 20:12:33 fslab1 kernel: [  258.668659] scsi 10:0:1:0: Done: 
Jul 31 20:12:33 fslab1 kernel: [  258.672036] 0xffff88007feff180 SUCCESS
Jul 31 20:12:33 fslab1 kernel: [  258.675888] scsi 10:0:1:0:  
Jul 31 20:12:33 fslab1 kernel: [  258.678828] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:33 fslab1 kernel: [  258.684202] scsi 10:0:1:0: CDB: 
Jul 31 20:12:33 fslab1 kernel: [  258.687486] Report luns: a0 00 00 00 00 00 00 00 10 00 00 00
Jul 31 20:12:33 fslab1 kernel: [  258.693807] scsi 10:0:1:0: scsi host busy 1 failed 0
Jul 31 20:12:33 fslab1 kernel: [  258.698837] scsi 10:0:1:0: Notifying upper driver of completion (result 0)
Jul 31 20:12:33 fslab1 kernel: [  258.705778] 8 sectors total, 4096 bytes done.
Jul 31 20:12:33 fslab1 kernel: [  258.710221] scsi scan: REPORT LUNS successful (try 0) result 0x0
Jul 31 20:12:33 fslab1 kernel: [  258.716299] scsi 10:0:1:0: scsi scan: REPORT LUN scan
Jul 31 20:12:33 fslab1 kernel: [  258.721474] scsi 10:0:1:5: scsi scan: INQUIRY pass 1 length 36
Jul 31 20:12:33 fslab1 kernel: [  258.727419] scsi 10:0:1:5: Send: 
Jul 31 20:12:33 fslab1 kernel: [  258.730820] 0xffff88007feff180 
Jul 31 20:12:33 fslab1 kernel: [  258.734070] scsi 10:0:1:5: CDB: 
Jul 31 20:12:33 fslab1 kernel: [  258.737359] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:33 fslab1 kernel: [  258.741500] buffer = 0xffff8800bebf4ec0, bufflen = 36, queuecommand 0xffffffffa029a350
Jul 31 20:12:33 fslab1 kernel: [  258.749510] leaving scsi_dispatch_cmnd()
Jul 31 20:12:33 fslab1 kernel: [  258.753507] scsi 10:0:1:5: Done: 
Jul 31 20:12:33 fslab1 kernel: [  258.756886] 0xffff88007feff180 SUCCESS
Jul 31 20:12:33 fslab1 kernel: [  258.760736] scsi 10:0:1:5:  
Jul 31 20:12:33 fslab1 kernel: [  258.763669] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:33 fslab1 kernel: [  258.769049] scsi 10:0:1:5: CDB: 
Jul 31 20:12:33 fslab1 kernel: [  258.772335] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:33 fslab1 kernel: [  258.776476] scsi 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:12:33 fslab1 kernel: [  258.781507] scsi 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:12:33 fslab1 kernel: [  258.788448] 0 sectors total, 36 bytes done.
Jul 31 20:12:33 fslab1 kernel: [  258.792713] scsi scan: INQUIRY successful with code 0x0
Jul 31 20:12:33 fslab1 kernel: [  258.798037] scsi 10:0:1:5: scsi scan: INQUIRY pass 2 length 96
Jul 31 20:12:34 fslab1 kernel: [  258.803951] scsi 10:0:1:5: Send: 
Jul 31 20:12:34 fslab1 kernel: [  258.807328] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  258.810565] scsi 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  258.813857] Inquiry: 12 00 00 00 60 00
Jul 31 20:12:34 fslab1 kernel: [  258.818005] buffer = 0xffff8800bebf4ec0, bufflen = 96, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  258.826016] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  258.830012] scsi 10:0:1:5: Done: 
Jul 31 20:12:34 fslab1 kernel: [  258.833390] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  258.837236] scsi 10:0:1:5:  
Jul 31 20:12:34 fslab1 kernel: [  258.840178] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  258.845552] scsi 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  258.848839] Inquiry: 12 00 00 00 60 00
Jul 31 20:12:34 fslab1 kernel: [  258.852988] scsi 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  258.858020] scsi 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:12:34 fslab1 kernel: [  258.864961] 0 sectors total, 96 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  258.869224] scsi scan: INQUIRY successful with code 0x0
Jul 31 20:12:34 fslab1 kernel: [  258.874519] scsi 10:0:1:5: Direct-Access     Hitachi  HDS724040KLSA80  R001 PQ: 0 ANSI: 5
Jul 31 20:12:34 fslab1 kernel: [  258.882816] scsi 10:0:2:0: scsi scan: INQUIRY pass 1 length 36
Jul 31 20:12:34 fslab1 kernel: [  258.888722] scsi 10:0:2:0: Send: 
Jul 31 20:12:34 fslab1 kernel: [  258.892098] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  258.895334] scsi 10:0:2:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  258.898626] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  258.902773] buffer = 0xffff8800bebf4ec0, bufflen = 36, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  258.910785] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  258.914778] scsi 10:0:2:0: Done: 
Jul 31 20:12:34 fslab1 kernel: [  258.918152] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  258.921996] scsi 10:0:2:0:  
Jul 31 20:12:34 fslab1 kernel: [  258.924939] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  258.931008] scsi 10:0:2:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  258.934294] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  258.938444] scsi 10:0:2:0: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  258.943474] scsi 10:0:2:0: Notifying upper driver of completion (result 10000)
Jul 31 20:12:34 fslab1 kernel: [  258.950787] 0 sectors total, 36 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  258.955121] scsi scan: INQUIRY failed with code 0x10000
Jul 31 20:12:34 fslab1 kernel: [  258.960477] scsi 10:0:3:0: scsi scan: INQUIRY pass 1 length 36
Jul 31 20:12:34 fslab1 kernel: [  258.966418] scsi 10:0:3:0: Send: 
Jul 31 20:12:34 fslab1 kernel: [  258.969819] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  258.973069] scsi 10:0:3:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  258.976359] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  258.980500] buffer = 0xffff8800bebf4ec0, bufflen = 36, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  258.988512] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  258.992508] scsi 10:0:3:0: Done: 
Jul 31 20:12:34 fslab1 kernel: [  258.995883] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  258.999733] scsi 10:0:3:0:  
Jul 31 20:12:34 fslab1 kernel: [  259.002674] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  259.008744] scsi 10:0:3:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.012032] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.016192] scsi 10:0:3:0: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  259.021218] scsi 10:0:3:0: Notifying upper driver of completion (result 10000)
Jul 31 20:12:34 fslab1 kernel: [  259.028531] 0 sectors total, 36 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  259.032826] scsi scan: INQUIRY failed with code 0x10000
Jul 31 20:12:34 fslab1 kernel: [  259.038170] scsi 10:0:4:0: scsi scan: INQUIRY pass 1 length 36
Jul 31 20:12:34 fslab1 kernel: [  259.044081] scsi 10:0:4:0: Send: 
Jul 31 20:12:34 fslab1 kernel: [  259.047453] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  259.050702] scsi 10:0:4:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.053994] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.058133] buffer = 0xffff8800bebf4ec0, bufflen = 36, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  259.066145] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  259.070138] scsi 10:0:4:0: Done: 
Jul 31 20:12:34 fslab1 kernel: [  259.073511] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  259.077356] scsi 10:0:4:0:  
Jul 31 20:12:34 fslab1 kernel: [  259.080297] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  259.086367] scsi 10:0:4:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.089653] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.093810] scsi 10:0:4:0: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  259.098841] scsi 10:0:4:0: Notifying upper driver of completion (result 10000)
Jul 31 20:12:34 fslab1 kernel: [  259.106155] 0 sectors total, 36 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  259.110408] scsi scan: INQUIRY failed with code 0x10000
Jul 31 20:12:34 fslab1 kernel: [  259.115724] scsi 10:0:5:0: scsi scan: INQUIRY pass 1 length 36
Jul 31 20:12:34 fslab1 kernel: [  259.122501] scsi 10:0:5:0: Send: 
Jul 31 20:12:34 fslab1 kernel: [  259.125880] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  259.129131] scsi 10:0:5:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.132422] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.136571] buffer = 0xffff8800bebf4ec0, bufflen = 36, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  259.144583] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  259.148579] scsi 10:0:5:0: Done: 
Jul 31 20:12:34 fslab1 kernel: [  259.151955] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  259.155804] scsi 10:0:5:0:  
Jul 31 20:12:34 fslab1 kernel: [  259.158748] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  259.164824] scsi 10:0:5:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.168109] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.172267] scsi 10:0:5:0: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  259.177299] scsi 10:0:5:0: Notifying upper driver of completion (result 10000)
Jul 31 20:12:34 fslab1 kernel: [  259.184611] 0 sectors total, 36 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  259.188888] scsi scan: INQUIRY failed with code 0x10000
Jul 31 20:12:34 fslab1 kernel: [  259.194231] scsi 10:0:6:0: scsi scan: INQUIRY pass 1 length 36
Jul 31 20:12:34 fslab1 kernel: [  259.200145] scsi 10:0:6:0: Send: 
Jul 31 20:12:34 fslab1 kernel: [  259.203514] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  259.206765] scsi 10:0:6:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.210055] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.214203] buffer = 0xffff8800bebf4ec0, bufflen = 36, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  259.222215] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  259.226208] scsi 10:0:6:0: Done: 
Jul 31 20:12:34 fslab1 kernel: [  259.229582] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  259.233436] scsi 10:0:6:0:  
Jul 31 20:12:34 fslab1 kernel: [  259.236377] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  259.242447] scsi 10:0:6:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.245732] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.249873] scsi 10:0:6:0: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  259.254904] scsi 10:0:6:0: Notifying upper driver of completion (result 10000)
Jul 31 20:12:34 fslab1 kernel: [  259.262217] 0 sectors total, 36 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  259.266494] scsi scan: INQUIRY failed with code 0x10000
Jul 31 20:12:34 fslab1 kernel: [  259.271851] scsi 10:0:7:0: scsi scan: INQUIRY pass 1 length 36
Jul 31 20:12:34 fslab1 kernel: [  259.277794] scsi 10:0:7:0: Send: 
Jul 31 20:12:34 fslab1 kernel: [  259.281189] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  259.284439] scsi 10:0:7:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.287726] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.291879] buffer = 0xffff8800bebf4ec0, bufflen = 36, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  259.299892] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  259.303887] scsi 10:0:7:0: Done: 
Jul 31 20:12:34 fslab1 kernel: [  259.307266] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  259.311111] scsi 10:0:7:0:  
Jul 31 20:12:34 fslab1 kernel: [  259.314053] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  259.320124] scsi 10:0:7:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.323405] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.327557] scsi 10:0:7:0: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  259.332589] scsi 10:0:7:0: Notifying upper driver of completion (result 10000)
Jul 31 20:12:34 fslab1 kernel: [  259.339900] 0 sectors total, 36 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  259.344160] scsi scan: INQUIRY failed with code 0x10000
Jul 31 20:12:34 fslab1 kernel: [  259.349497] scsi 10:0:8:0: scsi scan: INQUIRY pass 1 length 36
Jul 31 20:12:34 fslab1 kernel: [  259.355409] scsi 10:0:8:0: Send: 
Jul 31 20:12:34 fslab1 kernel: [  259.358784] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  259.362020] scsi 10:0:8:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.365310] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.369460] buffer = 0xffff8800bebf4ec0, bufflen = 36, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  259.377470] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  259.381463] scsi 10:0:8:0: Done: 
Jul 31 20:12:34 fslab1 kernel: [  259.384836] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  259.388689] scsi 10:0:8:0:  
Jul 31 20:12:34 fslab1 kernel: [  259.391630] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  259.397705] scsi 10:0:8:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.400998] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.405154] scsi 10:0:8:0: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  259.410186] scsi 10:0:8:0: Notifying upper driver of completion (result 10000)
Jul 31 20:12:34 fslab1 kernel: [  259.417497] 0 sectors total, 36 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  259.421744] scsi scan: INQUIRY failed with code 0x10000
Jul 31 20:12:34 fslab1 kernel: [  259.427067] scsi 10:0:9:0: scsi scan: INQUIRY pass 1 length 36
Jul 31 20:12:34 fslab1 kernel: [  259.432977] scsi 10:0:9:0: Send: 
Jul 31 20:12:34 fslab1 kernel: [  259.436366] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  259.439609] scsi 10:0:9:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.442901] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.447049] buffer = 0xffff8800bebf4ec0, bufflen = 36, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  259.455060] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  259.459057] scsi 10:0:9:0: Done: 
Jul 31 20:12:34 fslab1 kernel: [  259.462435] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  259.466280] scsi 10:0:9:0:  
Jul 31 20:12:34 fslab1 kernel: [  259.469222] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  259.475292] scsi 10:0:9:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.478577] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.482727] scsi 10:0:9:0: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  259.487757] scsi 10:0:9:0: Notifying upper driver of completion (result 10000)
Jul 31 20:12:34 fslab1 kernel: [  259.495069] 0 sectors total, 36 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  259.499327] scsi scan: INQUIRY failed with code 0x10000
Jul 31 20:12:34 fslab1 kernel: [  259.504665] scsi 10:0:10:0: scsi scan: INQUIRY pass 1 length 36
Jul 31 20:12:34 fslab1 kernel: [  259.510664] scsi 10:0:10:0: Send: 
Jul 31 20:12:34 fslab1 kernel: [  259.514126] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  259.517362] scsi 10:0:10:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.520740] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.524888] buffer = 0xffff8800bebf4ec0, bufflen = 36, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  259.532899] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  259.536892] scsi 10:0:10:0: Done: 
Jul 31 20:12:34 fslab1 kernel: [  259.540353] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  259.544210] scsi 10:0:10:0:  
Jul 31 20:12:34 fslab1 kernel: [  259.547232] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  259.553305] scsi 10:0:10:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.556679] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.560817] scsi 10:0:10:0: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  259.565935] scsi 10:0:10:0: Notifying upper driver of completion (result 10000)
Jul 31 20:12:34 fslab1 kernel: [  259.573335] 0 sectors total, 36 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  259.577611] scsi scan: INQUIRY failed with code 0x10000
Jul 31 20:12:34 fslab1 kernel: [  259.582974] scsi 10:0:11:0: scsi scan: INQUIRY pass 1 length 36
Jul 31 20:12:34 fslab1 kernel: [  259.588969] scsi 10:0:11:0: Send: 
Jul 31 20:12:34 fslab1 kernel: [  259.592451] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  259.595690] scsi 10:0:11:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.599066] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.603214] buffer = 0xffff8800bebf4ec0, bufflen = 36, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  259.611224] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  259.615222] scsi 10:0:11:0: Done: 
Jul 31 20:12:34 fslab1 kernel: [  259.618686] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  259.622542] scsi 10:0:11:0:  
Jul 31 20:12:34 fslab1 kernel: [  259.625571] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  259.631641] scsi 10:0:11:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.635013] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.639162] scsi 10:0:11:0: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  259.644279] scsi 10:0:11:0: Notifying upper driver of completion (result 10000)
Jul 31 20:12:34 fslab1 kernel: [  259.651678] 0 sectors total, 36 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  259.655948] scsi scan: INQUIRY failed with code 0x10000
Jul 31 20:12:34 fslab1 kernel: [  259.661285] scsi 10:0:12:0: scsi scan: INQUIRY pass 1 length 36
Jul 31 20:12:34 fslab1 kernel: [  259.667289] scsi 10:0:12:0: Send: 
Jul 31 20:12:34 fslab1 kernel: [  259.670763] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  259.674015] scsi 10:0:12:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.677414] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.681635] buffer = 0xffff8800bebf4ec0, bufflen = 36, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  259.689651] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  259.693655] scsi 10:0:12:0: Done: 
Jul 31 20:12:34 fslab1 kernel: [  259.697121] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  259.700980] scsi 10:0:12:0:  
Jul 31 20:12:34 fslab1 kernel: [  259.704010] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  259.710079] scsi 10:0:12:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.713450] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.717598] scsi 10:0:12:0: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  259.722718] scsi 10:0:12:0: Notifying upper driver of completion (result 10000)
Jul 31 20:12:34 fslab1 kernel: [  259.730117] 0 sectors total, 36 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  259.734370] scsi scan: INQUIRY failed with code 0x10000
Jul 31 20:12:34 fslab1 kernel: [  259.739700] scsi 10:0:13:0: scsi scan: INQUIRY pass 1 length 36
Jul 31 20:12:34 fslab1 kernel: [  259.745696] scsi 10:0:13:0: Send: 
Jul 31 20:12:34 fslab1 kernel: [  259.749183] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  259.752435] scsi 10:0:13:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.755809] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.760214] buffer = 0xffff8800bebf4ec0, bufflen = 36, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  259.768283] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  259.772344] scsi 10:0:13:0: Done: 
Jul 31 20:12:34 fslab1 kernel: [  259.775806] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  259.779653] scsi 10:0:13:0:  
Jul 31 20:12:34 fslab1 kernel: [  259.782680] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  259.788751] scsi 10:0:13:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.792123] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.796280] scsi 10:0:13:0: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  259.801397] scsi 10:0:13:0: Notifying upper driver of completion (result 10000)
Jul 31 20:12:34 fslab1 kernel: [  259.808798] 0 sectors total, 36 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  259.813150] scsi scan: INQUIRY failed with code 0x10000
Jul 31 20:12:34 fslab1 kernel: [  259.818550] scsi 10:0:14:0: scsi scan: INQUIRY pass 1 length 36
Jul 31 20:12:34 fslab1 kernel: [  259.824543] scsi 10:0:14:0: Send: 
Jul 31 20:12:34 fslab1 kernel: [  259.828015] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  259.831256] scsi 10:0:14:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.834634] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.838789] buffer = 0xffff8800bebf4ec0, bufflen = 36, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  259.846800] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  259.850793] scsi 10:0:14:0: Done: 
Jul 31 20:12:34 fslab1 kernel: [  259.854254] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  259.858988] scsi 10:0:14:0:  
Jul 31 20:12:34 fslab1 kernel: [  259.862012] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  259.868083] scsi 10:0:14:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.871451] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.875604] scsi 10:0:14:0: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  259.880721] scsi 10:0:14:0: Notifying upper driver of completion (result 10000)
Jul 31 20:12:34 fslab1 kernel: [  259.888120] 0 sectors total, 36 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  259.892390] scsi scan: INQUIRY failed with code 0x10000
Jul 31 20:12:34 fslab1 kernel: [  259.897723] scsi 10:0:15:0: scsi scan: INQUIRY pass 1 length 36
Jul 31 20:12:34 fslab1 kernel: [  259.903755] scsi 10:0:15:0: Send: 
Jul 31 20:12:34 fslab1 kernel: [  259.907246] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  259.910499] scsi 10:0:15:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.913878] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.918025] buffer = 0xffff8800bebf4ec0, bufflen = 36, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  259.926036] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  259.930033] scsi 10:0:15:0: Done: 
Jul 31 20:12:34 fslab1 kernel: [  259.933498] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  259.937353] scsi 10:0:15:0:  
Jul 31 20:12:34 fslab1 kernel: [  259.940382] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  259.946452] scsi 10:0:15:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.949824] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.953981] scsi 10:0:15:0: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  259.959098] scsi 10:0:15:0: Notifying upper driver of completion (result 10000)
Jul 31 20:12:34 fslab1 kernel: [  259.966499] 0 sectors total, 36 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  259.970766] scsi scan: INQUIRY failed with code 0x10000
Jul 31 20:12:34 fslab1 kernel: [  259.976109] scsi 10:0:16:0: scsi scan: INQUIRY pass 1 length 36
Jul 31 20:12:34 fslab1 kernel: [  259.982106] scsi 10:0:16:0: Send: 
Jul 31 20:12:34 fslab1 kernel: [  259.985575] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  259.988826] scsi 10:0:16:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  259.992204] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  259.996342] buffer = 0xffff8800bebf4ec0, bufflen = 36, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  260.004354] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  260.008342] scsi 10:0:16:0: Done: 
Jul 31 20:12:34 fslab1 kernel: [  260.011802] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  260.015654] scsi 10:0:16:0:  
Jul 31 20:12:34 fslab1 kernel: [  260.018680] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  260.024056] scsi 10:0:16:0: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.027427] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  260.031580] scsi 10:0:16:0: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  260.036695] scsi 10:0:16:0: Notifying upper driver of completion (result 0)
Jul 31 20:12:34 fslab1 kernel: [  260.043725] 0 sectors total, 36 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  260.047990] scsi scan: INQUIRY successful with code 0x0
Jul 31 20:12:34 fslab1 kernel: [  260.053322] scsi 10:0:16:0: Processor         Areca    RAID controller  R001 PQ: 0 ANSI: 0
Jul 31 20:12:34 fslab1 kernel: [  260.061704] scsi scan: Sequential scan oftarget10:0:16
Jul 31 20:12:34 fslab1 kernel: [  260.066963] scsi 10:0:16:1: scsi scan: INQUIRY pass 1 length 36
Jul 31 20:12:34 fslab1 kernel: [  260.072991] scsi 10:0:16:1: Send: 
Jul 31 20:12:34 fslab1 kernel: [  260.076475] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  260.079715] scsi 10:0:16:1: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.083092] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  260.087239] buffer = 0xffff8800bebf4ec0, bufflen = 36, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  260.095254] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  260.099239] scsi 10:0:16:1: Done: 
Jul 31 20:12:34 fslab1 kernel: [  260.102703] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  260.106549] scsi 10:0:16:1:  
Jul 31 20:12:34 fslab1 kernel: [  260.109578] Result: hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  260.115474] scsi 10:0:16:1: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.118847] Inquiry: 12 00 00 00 24 00
Jul 31 20:12:34 fslab1 kernel: [  260.122996] scsi 10:0:16:1: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  260.128113] scsi 10:0:16:1: Notifying upper driver of completion (result 30000)
Jul 31 20:12:34 fslab1 kernel: [  260.135512] 0 sectors total, 36 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  260.139776] scsi scan: INQUIRY failed with code 0x30000
Jul 31 20:12:34 fslab1 kernel: [  260.145179] sd 10:0:1:5: sd_probe
Jul 31 20:12:34 fslab1 kernel: [  260.148626] sd 10:0:1:5: [sdb] sd_revalidate_disk
Jul 31 20:12:34 fslab1 kernel: [  260.153424] sd 10:0:1:5: Send: 
Jul 31 20:12:34 fslab1 kernel: [  260.156646] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  260.159906] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.163026] Test Unit Ready: 00 00 00 00 00 00
Jul 31 20:12:34 fslab1 kernel: [  260.167951] buffer = 0x          (null), bufflen = 0, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  260.175877] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  260.179884] sd 10:0:1:5: Done: 
Jul 31 20:12:34 fslab1 kernel: [  260.183087] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  260.186940] sd 10:0:1:5:  
Jul 31 20:12:34 fslab1 kernel: [  260.189706] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  260.195081] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.198195] Test Unit Ready: 00 00 00 00 00 00
Jul 31 20:12:34 fslab1 kernel: [  260.203039] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  260.207895] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:12:34 fslab1 kernel: [  260.214663] 0 sectors total, 0 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  260.218863] sg_alloc: dev=1 
Jul 31 20:12:34 fslab1 kernel: [  260.221878] sd 10:0:1:5: Attached scsi generic sg1 type 0
Jul 31 20:12:34 fslab1 kernel: [  260.227355] sd 10:0:1:5: Send: 
Jul 31 20:12:34 fslab1 kernel: [  260.230581] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  260.233833] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.236966] Read capacity(16): 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
Jul 31 20:12:34 fslab1 kernel: [  260.245107] buffer = 0xffff8800bebf4ec0, bufflen = 32, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  260.253121] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  260.257239] sg_alloc: dev=2 
Jul 31 20:12:34 fslab1 kernel: [  260.260184] sd 10:0:1:5: Done: 
Jul 31 20:12:34 fslab1 kernel: [  260.263382] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  260.267243] sd 10:0:1:5:  
Jul 31 20:12:34 fslab1 kernel: [  260.270009] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  260.275383] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.278497] Read capacity(16): 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
Jul 31 20:12:34 fslab1 kernel: [  260.286585] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  260.291441] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:12:34 fslab1 kernel: [  260.298208] 0 sectors total, 32 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  260.302468] sd 10:0:1:5: [sdb] 781422768 512-byte logical blocks: (400 GB/372 GiB)
Jul 31 20:12:34 fslab1 kernel: [  260.310179] sd 10:0:1:5: Send: 
Jul 31 20:12:34 fslab1 kernel: [  260.313384] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  260.316665] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.319803] Inquiry: 12 01 00 00 40 00
Jul 31 20:12:34 fslab1 kernel: [  260.323960] buffer = 0xffff8800bebf4ec0, bufflen = 64, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  260.332000] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  260.336032] sd 10:0:1:5: Done: 
Jul 31 20:12:34 fslab1 kernel: [  260.339230] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  260.343088] sd 10:0:1:5:  
Jul 31 20:12:34 fslab1 kernel: [  260.345856] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  260.351232] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.354344] Inquiry: 12 01 00 00 40 00
Jul 31 20:12:34 fslab1 kernel: [  260.358494] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  260.363351] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:12:34 fslab1 kernel: [  260.370118] 0 sectors total, 64 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  260.374457] scsi 10:0:16:0: Attached scsi generic sg2 type 3
Jul 31 20:12:34 fslab1 kernel: [  260.380288] sd 10:0:1:5: Send: 
Jul 31 20:12:34 fslab1 kernel: [  260.383523] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  260.386774] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.389922] Inquiry: 12 01 00 00 40 00
Jul 31 20:12:34 fslab1 kernel: [  260.394109] buffer = 0xffff8800bebf4ec0, bufflen = 64, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  260.402150] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  260.406172] sd 10:0:1:5: Done: 
Jul 31 20:12:34 fslab1 kernel: [  260.409378] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  260.413237] sd 10:0:1:5:  
Jul 31 20:12:34 fslab1 kernel: [  260.416000] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  260.421380] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.424494] Inquiry: 12 01 00 00 40 00
Jul 31 20:12:34 fslab1 kernel: [  260.428642] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  260.433501] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:12:34 fslab1 kernel: [  260.440267] 0 sectors total, 64 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  260.444526] sd 10:0:1:5: Send: 
Jul 31 20:12:34 fslab1 kernel: [  260.447726] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  260.451007] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.454125] Mode Sense(6): 1a 00 3f 00 04 00
Jul 31 20:12:34 fslab1 kernel: [  260.458892] buffer = 0xffff8800bebf4ec0, bufflen = 4, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  260.466816] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  260.470814] sd 10:0:1:5: Done: 
Jul 31 20:12:34 fslab1 kernel: [  260.474019] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  260.477865] sd 10:0:1:5:  
Jul 31 20:12:34 fslab1 kernel: [  260.480632] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  260.486008] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.489121] Mode Sense(6): 1a 00 3f 00 04 00
Jul 31 20:12:34 fslab1 kernel: [  260.493799] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  260.498656] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:12:34 fslab1 kernel: [  260.505424] 0 sectors total, 4 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  260.509608] sd 10:0:1:5: [sdb] Write Protect is off
Jul 31 20:12:34 fslab1 kernel: [  260.514586] sd 10:0:1:5: Send: 
Jul 31 20:12:34 fslab1 kernel: [  260.517789] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  260.521040] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.524155] Mode Sense(6): 1a 00 08 00 04 00
Jul 31 20:12:34 fslab1 kernel: [  260.528833] buffer = 0xffff8800bebf4ec0, bufflen = 4, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  260.536759] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  260.540756] sd 10:0:1:5: Done: 
Jul 31 20:12:34 fslab1 kernel: [  260.543955] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  260.547807] sd 10:0:1:5:  
Jul 31 20:12:34 fslab1 kernel: [  260.550575] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  260.555948] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.559063] Mode Sense(6): 1a 00 08 00 04 00
Jul 31 20:12:34 fslab1 kernel: [  260.563733] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  260.568588] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:12:34 fslab1 kernel: [  260.575357] 0 sectors total, 4 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  260.579539] sd 10:0:1:5: Send: 
Jul 31 20:12:34 fslab1 kernel: [  260.582770] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  260.586022] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.589141] Mode Sense(6): 1a 00 08 00 20 00
Jul 31 20:12:34 fslab1 kernel: [  260.593807] buffer = 0xffff8800bebf4ec0, bufflen = 32, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  260.602706] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  260.606696] sd 10:0:1:5: Done: 
Jul 31 20:12:34 fslab1 kernel: [  260.609896] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  260.613750] sd 10:0:1:5:  
Jul 31 20:12:34 fslab1 kernel: [  260.616517] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  260.621893] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.625008] Mode Sense(6): 1a 00 08 00 20 00
Jul 31 20:12:34 fslab1 kernel: [  260.629684] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  260.634541] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:12:34 fslab1 kernel: [  260.641309] 0 sectors total, 32 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  260.645555] sd 10:0:1:5: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 31 20:12:34 fslab1 kernel: [  260.654786] sd 10:0:1:5: Send: 
Jul 31 20:12:34 fslab1 kernel: [  260.657990] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  260.661226] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.664342] Report supported operation codes: a3 0c 01 12 00 00 00 00 02 00 00 00
Jul 31 20:12:34 fslab1 kernel: [  260.672515] buffer = 0xffff8800bebf4ec0, bufflen = 512, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  260.680612] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  260.684608] sd 10:0:1:5: Done: 
Jul 31 20:12:34 fslab1 kernel: [  260.687810] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  260.691668] sd 10:0:1:5:  
Jul 31 20:12:34 fslab1 kernel: [  260.694436] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  260.699810] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.702923] Report supported operation codes: a3 0c 01 12 00 00 00 00 02 00 00 00
Jul 31 20:12:34 fslab1 kernel: [  260.711099] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  260.715954] sd 10:0:1:5: Notifying upper driver of completion (result 8000000)
Jul 31 20:12:34 fslab1 kernel: [  260.723268] 1 sectors total, 512 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  260.727622] sd 10:0:1:5: Send: 
Jul 31 20:12:34 fslab1 kernel: [  260.730855] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  260.734107] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.737225] Inquiry: 12 01 00 02 00 00
Jul 31 20:12:34 fslab1 kernel: [  260.741364] buffer = 0xffff8800bebf4ec0, bufflen = 512, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  260.749461] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  260.753453] sd 10:0:1:5: Done: 
Jul 31 20:12:34 fslab1 kernel: [  260.756653] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  260.760506] sd 10:0:1:5:  
Jul 31 20:12:34 fslab1 kernel: [  260.763273] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  260.768650] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.771761] Inquiry: 12 01 00 02 00 00
Jul 31 20:12:34 fslab1 kernel: [  260.775907] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  260.780762] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:12:34 fslab1 kernel: [  260.787530] 1 sectors total, 512 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  260.791950] sd 10:0:1:5: [sdb] sd_open
Jul 31 20:12:34 fslab1 kernel: [  260.795762] scsi_block_when_processing_errors: rtn: 1
Jul 31 20:12:34 fslab1 kernel: [  260.800900] sd 10:0:1:5: [sdb] sd_revalidate_disk
Jul 31 20:12:34 fslab1 kernel: [  260.805723] sd 10:0:1:5: Send: 
Jul 31 20:12:34 fslab1 kernel: [  260.808952] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  260.812197] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.815311] Test Unit Ready: 00 00 00 00 00 00
Jul 31 20:12:34 fslab1 kernel: [  260.820173] buffer = 0x          (null), bufflen = 0, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  260.828101] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  260.832095] sd 10:0:1:5: Done: 
Jul 31 20:12:34 fslab1 kernel: [  260.835297] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  260.839155] sd 10:0:1:5:  
Jul 31 20:12:34 fslab1 kernel: [  260.841924] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  260.847298] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.850413] Test Unit Ready: 00 00 00 00 00 00
Jul 31 20:12:34 fslab1 kernel: [  260.855257] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  260.860112] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:12:34 fslab1 kernel: [  260.866881] 0 sectors total, 0 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  260.871065] sd 10:0:1:5: Send: 
Jul 31 20:12:34 fslab1 kernel: [  260.874271] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  260.877520] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.880636] Read capacity(16): 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
Jul 31 20:12:34 fslab1 kernel: [  260.888713] buffer = 0xffff8800bebf4ec0, bufflen = 32, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  260.896723] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  260.900716] sd 10:0:1:5: Done: 
Jul 31 20:12:34 fslab1 kernel: [  260.903910] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  260.907753] sd 10:0:1:5:  
Jul 31 20:12:34 fslab1 kernel: [  260.910520] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  260.915896] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.919009] Read capacity(16): 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
Jul 31 20:12:34 fslab1 kernel: [  260.927079] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  260.931934] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:12:34 fslab1 kernel: [  260.938702] 0 sectors total, 32 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  260.942951] sd 10:0:1:5: Send: 
Jul 31 20:12:34 fslab1 kernel: [  260.946159] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  260.949403] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.952518] Inquiry: 12 01 00 00 40 00
Jul 31 20:12:34 fslab1 kernel: [  260.956668] buffer = 0xffff8800bebf4ec0, bufflen = 64, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  260.964678] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  260.968671] sd 10:0:1:5: Done: 
Jul 31 20:12:34 fslab1 kernel: [  260.971867] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  260.975719] sd 10:0:1:5:  
Jul 31 20:12:34 fslab1 kernel: [  260.978485] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  260.983861] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  260.986974] Inquiry: 12 01 00 00 40 00
Jul 31 20:12:34 fslab1 kernel: [  260.991125] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  260.995980] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:12:34 fslab1 kernel: [  261.002748] 0 sectors total, 64 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  261.007002] sd 10:0:1:5: Send: 
Jul 31 20:12:34 fslab1 kernel: [  261.010203] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  261.013448] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  261.016566] Inquiry: 12 01 00 00 40 00
Jul 31 20:12:34 fslab1 kernel: [  261.020705] buffer = 0xffff8800bebf4ec0, bufflen = 64, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  261.028716] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  261.032814] sd 10:0:1:5: Done: 
Jul 31 20:12:34 fslab1 kernel: [  261.036017] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  261.039869] sd 10:0:1:5:  
Jul 31 20:12:34 fslab1 kernel: [  261.042637] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  261.048010] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  261.051121] Inquiry: 12 01 00 00 40 00
Jul 31 20:12:34 fslab1 kernel: [  261.055274] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  261.060131] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:12:34 fslab1 kernel: [  261.066899] 0 sectors total, 64 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  261.071156] sd 10:0:1:5: Send: 
Jul 31 20:12:34 fslab1 kernel: [  261.074385] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  261.077633] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  261.080752] Mode Sense(6): 1a 00 3f 00 04 00
Jul 31 20:12:34 fslab1 kernel: [  261.085429] buffer = 0xffff8800bebf4ec0, bufflen = 4, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  261.093352] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  261.097350] sd 10:0:1:5: Done: 
Jul 31 20:12:34 fslab1 kernel: [  261.100553] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  261.104404] sd 10:0:1:5:  
Jul 31 20:12:34 fslab1 kernel: [  261.107163] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  261.112534] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  261.115645] Mode Sense(6): 1a 00 3f 00 04 00
Jul 31 20:12:34 fslab1 kernel: [  261.120318] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  261.125174] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:12:34 fslab1 kernel: [  261.131942] 0 sectors total, 4 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  261.136135] sd 10:0:1:5: Send: 
Jul 31 20:12:34 fslab1 kernel: [  261.139357] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  261.142607] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  261.145728] Mode Sense(6): 1a 00 08 00 04 00
Jul 31 20:12:34 fslab1 kernel: [  261.150401] buffer = 0xffff8800bebf4ec0, bufflen = 4, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  261.158325] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  261.162317] sd 10:0:1:5: Done: 
Jul 31 20:12:34 fslab1 kernel: [  261.165517] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  261.169365] sd 10:0:1:5:  
Jul 31 20:12:34 fslab1 kernel: [  261.172132] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  261.177508] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  261.180620] Mode Sense(6): 1a 00 08 00 04 00
Jul 31 20:12:34 fslab1 kernel: [  261.185290] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  261.190147] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:12:34 fslab1 kernel: [  261.196915] 0 sectors total, 4 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  261.201083] sd 10:0:1:5: Send: 
Jul 31 20:12:34 fslab1 kernel: [  261.204283] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  261.207521] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  261.210637] Mode Sense(6): 1a 00 08 00 20 00
Jul 31 20:12:34 fslab1 kernel: [  261.215306] buffer = 0xffff8800bebf4ec0, bufflen = 32, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  261.223318] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  261.227309] sd 10:0:1:5: Done: 
Jul 31 20:12:34 fslab1 kernel: [  261.230510] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  261.234356] sd 10:0:1:5:  
Jul 31 20:12:34 fslab1 kernel: [  261.237123] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  261.242497] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  261.245612] Mode Sense(6): 1a 00 08 00 20 00
Jul 31 20:12:34 fslab1 kernel: [  261.250283] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  261.255138] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:12:34 fslab1 kernel: [  261.261906] 0 sectors total, 32 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  261.266161] sd 10:0:1:5: Send: 
Jul 31 20:12:34 fslab1 kernel: [  261.269373] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  261.272616] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  261.275728] Inquiry: 12 01 00 02 00 00
Jul 31 20:12:34 fslab1 kernel: [  261.279882] buffer = 0xffff8800bebf4ec0, bufflen = 512, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  261.287978] leaving scsi_dispatch_cmnd()
Jul 31 20:12:34 fslab1 kernel: [  261.291974] sd 10:0:1:5: Done: 
Jul 31 20:12:34 fslab1 kernel: [  261.295183] 0xffff88007feff180 SUCCESS
Jul 31 20:12:34 fslab1 kernel: [  261.299036] sd 10:0:1:5:  
Jul 31 20:12:34 fslab1 kernel: [  261.301802] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:12:34 fslab1 kernel: [  261.307178] sd 10:0:1:5: CDB: 
Jul 31 20:12:34 fslab1 kernel: [  261.310291] Inquiry: 12 01 00 02 00 00
Jul 31 20:12:34 fslab1 kernel: [  261.314442] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:12:34 fslab1 kernel: [  261.319297] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:12:34 fslab1 kernel: [  261.326942] 1 sectors total, 512 bytes done.
Jul 31 20:12:34 fslab1 kernel: [  261.331334] sd 10:0:1:5: [sdb] sd_prep_fn: block=0, count=8
Jul 31 20:12:34 fslab1 kernel: [  261.335274] sd 10:0:1:5: [sdb] block=0
Jul 31 20:12:34 fslab1 kernel: [  261.335274] sd 10:0:1:5: [sdb] reading 8/8 512 byte blocks.
Jul 31 20:12:34 fslab1 kernel: [  261.346421] sd 10:0:1:5: [sdb] Send: 
Jul 31 20:12:34 fslab1 kernel: [  261.350160] 0xffff88007feff180 
Jul 31 20:12:34 fslab1 kernel: [  261.353413] sd 10:0:1:5: [sdb] CDB: 
Jul 31 20:12:34 fslab1 kernel: [  261.357053] Read(10): 28 00 00 00 00 00 00 00 08 00
Jul 31 20:12:34 fslab1 kernel: [  261.362498] buffer = 0xffff8800bebf4ec0, bufflen = 4096, queuecommand 0xffffffffa029a350
Jul 31 20:12:34 fslab1 kernel: [  261.370683] leaving scsi_dispatch_cmnd()
Jul 31 20:13:04 fslab1 kernel: [  291.840015] sd 10:0:1:5: [sdb] Done: 
Jul 31 20:13:04 fslab1 kernel: [  291.843744] 0xffff88007feff180 TIMEOUT
Jul 31 20:13:04 fslab1 kernel: [  291.844005] sd 10:0:1:5: [sdb]  
Jul 31 20:13:04 fslab1 kernel: [  291.844005] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:13:04 fslab1 kernel: [  291.844005] sd 10:0:1:5: [sdb] CDB: 
Jul 31 20:13:04 fslab1 kernel: [  291.844005] Read(10): 28 00 00 00 00 00 00 00 08 00
Jul 31 20:13:04 fslab1 kernel: [  291.844005] sd 10:0:1:5: [sdb] scsi host busy 1 failed 0
Jul 31 20:13:04 fslab1 kernel: [  291.844005] Waking error handler thread
Jul 31 20:13:04 fslab1 kernel: [  291.874609] Error handler scsi_eh_10 waking up
Jul 31 20:13:04 fslab1 kernel: [  291.879339] sd 10:0:1:5: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Jul 31 20:13:04 fslab1 kernel: [  291.886311] Total of 1 commands on 1 devices require eh work
Jul 31 20:13:04 fslab1 kernel: [  291.892039] scsi_eh_10: aborting cmd:0xffff88007feff180
Jul 31 20:13:04 fslab1 kernel: [  291.897356] arcmsr10: abort device command of scsi id = 1 lun = 5 
Jul 31 20:13:07 fslab1 kernel: [  295.132027] scsi_eh_10: aborting cmd failed:0xffff88007feff180
Jul 31 20:13:07 fslab1 kernel: [  295.137949] scsi_eh_10: Sending BDR sdev: 0xffff8800bebcf000
Jul 31 20:13:07 fslab1 kernel: [  295.143719] scsi_eh_10: BDR failed sdev:0xffff8800bebcf000
Jul 31 20:13:07 fslab1 kernel: [  295.149274] scsi_eh_10: Sending target reset to target 1
Jul 31 20:13:07 fslab1 kernel: [  295.154654] scsi_eh_10: Target reset failed target: 1
Jul 31 20:13:07 fslab1 kernel: [  295.159768] scsi_eh_10: Sending BRST chan: 0
Jul 31 20:13:07 fslab1 kernel: [  295.164100] scsi_try_bus_reset: Snd Bus RST
Jul 31 20:13:07 fslab1 kernel: [  295.168350] arcmsr: executing bus reset eh.....num_resets = 0, num_aborts = 1 
Jul 31 20:13:39 fslab1 kernel: [  327.172022] arcmsr10: wait 'abort all outstanding command' timeout 
Jul 31 20:13:39 fslab1 kernel: [  327.178383] arcmsr10: executing hw bus reset .....
Jul 31 20:13:52 fslab1 kernel: [  340.192020] arcmsr10: waiting for hw bus reset return, retry=0
Jul 31 20:14:02 fslab1 kernel: [  350.200023] arcmsr10: waiting for hw bus reset return, retry=1
Jul 31 20:14:12 fslab1 kernel: [  360.208022] arcmsr10: waiting for hw bus reset return, retry=2
Jul 31 20:14:22 fslab1 kernel: [  370.216022] arcmsr10: waiting for hw bus reset return, retry=3
Jul 31 20:14:32 fslab1 kernel: [  380.240050] Areca RAID Controller10: F/W V1.46 2009-01-06 & Model ARC-1260
Jul 31 20:14:32 fslab1 kernel: [  380.260013] arcmsr: scsi  bus reset eh returns with success
Jul 31 20:14:42 fslab1 kernel: [  390.268027] sd 10:0:1:5: [sdb] Send: 
Jul 31 20:14:42 fslab1 kernel: [  390.271757] 0xffff88007feff180 
Jul 31 20:14:43 fslab1 kernel: [  390.275016] sd 10:0:1:5: [sdb] CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.278657] Test Unit Ready: 00 00 00 00 00 00
Jul 31 20:14:43 fslab1 kernel: [  390.278659] buffer = 0x          (null), bufflen = 0, queuecommand 0xffffffffa029a350
Jul 31 20:14:43 fslab1 kernel: [  390.283177] scsi_eh_done scmd: ffff88007feff180 result: 0
Jul 31 20:14:43 fslab1 kernel: [  390.283189] sd 10:0:1:5: [sdb] Done: 
Jul 31 20:14:43 fslab1 kernel: [  390.283191] 0xffff88007feff180 UNKNOWN
Jul 31 20:14:43 fslab1 kernel: [  390.283192] sd 10:0:1:5: [sdb]  
Jul 31 20:14:43 fslab1 kernel: [  390.283193] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:14:43 fslab1 kernel: [  390.283195] sd 10:0:1:5: [sdb] CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.283198] Test Unit Ready: 00 00 00 00 00 00
Jul 31 20:14:43 fslab1 kernel: [  390.283199] sd 10:0:1:5: [sdb] scsi host busy 1 failed 1
Jul 31 20:14:43 fslab1 kernel: [  390.283201] scsi_send_eh_cmnd: scmd: ffff88007feff180, timeleft: 2499
Jul 31 20:14:43 fslab1 kernel: [  390.283202] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Jul 31 20:14:43 fslab1 kernel: [  390.283204] scsi_eh_tur: scmd ffff88007feff180 rtn 2002
Jul 31 20:14:43 fslab1 kernel: [  390.283205] scsi_eh_10: flush retry cmd: ffff88007feff180
Jul 31 20:14:43 fslab1 kernel: [  390.283207] Inserting command ffff88007feff180 into mlqueue
Jul 31 20:14:43 fslab1 kernel: [  390.283217] scsi_restart_operations: waking up host to restart
Jul 31 20:14:43 fslab1 kernel: [  390.283229] Error handler scsi_eh_10 sleeping
Jul 31 20:14:43 fslab1 kernel: [  390.292011] sd 10:0:1:5: unblocking device at zero depth
Jul 31 20:14:43 fslab1 kernel: [  390.292015] sd 10:0:1:5: [sdb] Send: 
Jul 31 20:14:43 fslab1 kernel: [  390.292016] 0xffff88007feff180 
Jul 31 20:14:43 fslab1 kernel: [  390.292017] sd 10:0:1:5: [sdb] CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.292022] Read(10): 28 00 00 00 00 00 00 00 08 00
Jul 31 20:14:43 fslab1 kernel: [  390.292023] buffer = 0xffff8800bebf4ec0, bufflen = 4096, queuecommand 0xffffffffa029a350
Jul 31 20:14:43 fslab1 kernel: [  390.292026] leaving scsi_dispatch_cmnd()
Jul 31 20:14:43 fslab1 kernel: [  390.296576] sd 10:0:1:5: [sdb] Done: 
Jul 31 20:14:43 fslab1 kernel: [  390.296578] 0xffff88007feff180 SUCCESS
Jul 31 20:14:43 fslab1 kernel: [  390.296580] sd 10:0:1:5: [sdb]  
Jul 31 20:14:43 fslab1 kernel: [  390.296581] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:14:43 fslab1 kernel: [  390.296583] sd 10:0:1:5: [sdb] CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.296588] Read(10): 28 00 00 00 00 00 00 00 08 00
Jul 31 20:14:43 fslab1 kernel: [  390.296590] sd 10:0:1:5: [sdb] scsi host busy 1 failed 0
Jul 31 20:14:43 fslab1 kernel: [  390.296593] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:14:43 fslab1 kernel: [  390.296594] sd 10:0:1:5: [sdb]  
Jul 31 20:14:43 fslab1 kernel: [  390.296595] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:14:43 fslab1 kernel: [  390.296597] 8 sectors total, 4096 bytes done.
Jul 31 20:14:43 fslab1 kernel: [  390.448438]  sdb: sdb1
Jul 31 20:14:43 fslab1 kernel: [  390.451006] sd 10:0:1:5: [sdb] sd_release
Jul 31 20:14:43 fslab1 kernel: [  390.455305] sd 10:0:1:5: [sdb] sd_revalidate_disk
Jul 31 20:14:43 fslab1 kernel: [  390.460083] sd 10:0:1:5: [sdb] sd_check_events
Jul 31 20:14:43 fslab1 kernel: [  390.464624] scsi_block_when_processing_errors: rtn: 1
Jul 31 20:14:43 fslab1 kernel: [  390.469781] sd 10:0:1:5: Send: 
Jul 31 20:14:43 fslab1 kernel: [  390.473004] 0xffff88007feff180 
Jul 31 20:14:43 fslab1 kernel: [  390.476249] sd 10:0:1:5: CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.479362] Test Unit Ready: 00 00 00 00 00 00
Jul 31 20:14:43 fslab1 kernel: [  390.484273] buffer = 0x          (null), bufflen = 0, queuecommand 0xffffffffa029a350
Jul 31 20:14:43 fslab1 kernel: [  390.492210] leaving scsi_dispatch_cmnd()
Jul 31 20:14:43 fslab1 kernel: [  390.496224] sd 10:0:1:5: Done: 
Jul 31 20:14:43 fslab1 kernel: [  390.499426] 0xffff88007feff180 SUCCESS
Jul 31 20:14:43 fslab1 kernel: [  390.503278] sd 10:0:1:5:  
Jul 31 20:14:43 fslab1 kernel: [  390.506042] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:14:43 fslab1 kernel: [  390.511415] sd 10:0:1:5: CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.514526] Test Unit Ready: 00 00 00 00 00 00
Jul 31 20:14:43 fslab1 kernel: [  390.519369] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:14:43 fslab1 kernel: [  390.524222] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:14:43 fslab1 kernel: [  390.530986] 0 sectors total, 0 bytes done.
Jul 31 20:14:43 fslab1 kernel: [  390.535159] sd 10:0:1:5: Send: 
Jul 31 20:14:43 fslab1 kernel: [  390.538380] 0xffff88007feff180 
Jul 31 20:14:43 fslab1 kernel: [  390.541626] sd 10:0:1:5: CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.544760] Read capacity(16): 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
Jul 31 20:14:43 fslab1 kernel: [  390.552920] buffer = 0xffff8800bebf4ec0, bufflen = 32, queuecommand 0xffffffffa029a350
Jul 31 20:14:43 fslab1 kernel: [  390.560928] leaving scsi_dispatch_cmnd()
Jul 31 20:14:43 fslab1 kernel: [  390.564937] sd 10:0:1:5: Send: 
Jul 31 20:14:43 fslab1 kernel: [  390.568142] sd 10:0:1:5: Done: 
Jul 31 20:14:43 fslab1 kernel: [  390.571341] 0xffff88007feff180 SUCCESS
Jul 31 20:14:43 fslab1 kernel: [  390.575196] sd 10:0:1:5:  
Jul 31 20:14:43 fslab1 kernel: [  390.577962] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:14:43 fslab1 kernel: [  390.583334] sd 10:0:1:5: CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.586446] Read capacity(16): 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
Jul 31 20:14:43 fslab1 kernel: [  390.594521] sd 10:0:1:5: scsi host busy 2 failed 0
Jul 31 20:14:43 fslab1 kernel: [  390.599374] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:14:43 fslab1 kernel: [  390.606136] 0 sectors total, 32 bytes done.
Jul 31 20:14:43 fslab1 kernel: [  390.610388] 0xffff88007feff480 
Jul 31 20:14:43 fslab1 kernel: [  390.613651] sd 10:0:1:5: CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.616769] Test Unit Ready: 00 00 00 00 00 00
Jul 31 20:14:43 fslab1 kernel: [  390.621631] buffer = 0x          (null), bufflen = 0, queuecommand 0xffffffffa029a350
Jul 31 20:14:43 fslab1 kernel: [  390.629551] leaving scsi_dispatch_cmnd()
Jul 31 20:14:43 fslab1 kernel: [  390.633587] sd 10:0:1:5: Done: 
Jul 31 20:14:43 fslab1 kernel: [  390.636792] 0xffff88007feff480 SUCCESS
Jul 31 20:14:43 fslab1 kernel: [  390.640641] sd 10:0:1:5:  
Jul 31 20:14:43 fslab1 kernel: [  390.643407] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:14:43 fslab1 kernel: [  390.648781] sd 10:0:1:5: CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.651891] Test Unit Ready: 00 00 00 00 00 00
Jul 31 20:14:43 fslab1 kernel: [  390.656742] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:14:43 fslab1 kernel: [  390.661595] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:14:43 fslab1 kernel: [  390.668361] 0 sectors total, 0 bytes done.
Jul 31 20:14:43 fslab1 kernel: [  390.672525] sd 10:0:1:5: Send: 
Jul 31 20:14:43 fslab1 kernel: [  390.675721] 0xffff88007feff480 
Jul 31 20:14:43 fslab1 kernel: [  390.678981] sd 10:0:1:5: CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.682093] Inquiry: 12 01 00 00 40 00
Jul 31 20:14:43 fslab1 kernel: [  390.686239] buffer = 0xffff8800bebf4ec0, bufflen = 64, queuecommand 0xffffffffa029a350
Jul 31 20:14:43 fslab1 kernel: [  390.694244] leaving scsi_dispatch_cmnd()
Jul 31 20:14:43 fslab1 kernel: [  390.698245] sd 10:0:1:5: Done: 
Jul 31 20:14:43 fslab1 kernel: [  390.701450] 0xffff88007feff480 SUCCESS
Jul 31 20:14:43 fslab1 kernel: [  390.705294] sd 10:0:1:5:  
Jul 31 20:14:43 fslab1 kernel: [  390.708061] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:14:43 fslab1 kernel: [  390.713431] sd 10:0:1:5: CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.716543] Inquiry: 12 01 00 00 40 00
Jul 31 20:14:43 fslab1 kernel: [  390.720690] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:14:43 fslab1 kernel: [  390.725543] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:14:43 fslab1 kernel: [  390.732308] 0 sectors total, 64 bytes done.
Jul 31 20:14:43 fslab1 kernel: [  390.736565] sd 10:0:1:5: Send: 
Jul 31 20:14:43 fslab1 kernel: [  390.739764] 0xffff88007feff480 
Jul 31 20:14:43 fslab1 kernel: [  390.743011] sd 10:0:1:5: CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.746126] Inquiry: 12 01 00 00 40 00
Jul 31 20:14:43 fslab1 kernel: [  390.750272] buffer = 0xffff8800bebf4ec0, bufflen = 64, queuecommand 0xffffffffa029a350
Jul 31 20:14:43 fslab1 kernel: [  390.758278] leaving scsi_dispatch_cmnd()
Jul 31 20:14:43 fslab1 kernel: [  390.762276] sd 10:0:1:5: Done: 
Jul 31 20:14:43 fslab1 kernel: [  390.762290] sd 10:0:1:5: [sdb] sd_open
Jul 31 20:14:43 fslab1 kernel: [  390.762293] scsi_block_when_processing_errors: rtn: 1
Jul 31 20:14:43 fslab1 kernel: [  390.762308] sd 10:0:1:5: [sdb] sd_ioctl: disk=sdb, cmd=0x2285
Jul 31 20:14:43 fslab1 kernel: [  390.762310] scsi_block_when_processing_errors: rtn: 1
Jul 31 20:14:43 fslab1 kernel: [  390.762313] sd 10:0:1:5: [sdb] sd_ioctl: disk=sdb, cmd=0x2285
Jul 31 20:14:43 fslab1 kernel: [  390.762314] scsi_block_when_processing_errors: rtn: 1
Jul 31 20:14:43 fslab1 kernel: [  390.762354] sd 10:0:1:5: [sdb] Send: 
Jul 31 20:14:43 fslab1 kernel: [  390.762355] 0xffff8801f9aa8ec0 
Jul 31 20:14:43 fslab1 kernel: [  390.762357] sd 10:0:1:5: [sdb] CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.762360] Inquiry: 12 00 00 00 fe 00
Jul 31 20:14:43 fslab1 kernel: [  390.762362] buffer = 0xffff8801f94e1980, bufflen = 254, queuecommand 0xffffffffa029a350
Jul 31 20:14:43 fslab1 kernel: [  390.762366] leaving scsi_dispatch_cmnd()
Jul 31 20:14:43 fslab1 kernel: [  390.822613] 0xffff88007feff480 SUCCESS
Jul 31 20:14:43 fslab1 kernel: [  390.826458] sd 10:0:1:5:  
Jul 31 20:14:43 fslab1 kernel: [  390.829221] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:14:43 fslab1 kernel: [  390.834594] sd 10:0:1:5: CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.837706] Inquiry: 12 01 00 00 40 00
Jul 31 20:14:43 fslab1 kernel: [  390.841845] sd 10:0:1:5: scsi host busy 2 failed 0
Jul 31 20:14:43 fslab1 kernel: [  390.846697] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:14:43 fslab1 kernel: [  390.854338] 0 sectors total, 64 bytes done.
Jul 31 20:14:43 fslab1 kernel: [  390.858594] sd 10:0:1:5: [sdb] Done: 
Jul 31 20:14:43 fslab1 kernel: [  390.862315] 0xffff8801f9aa8ec0 SUCCESS
Jul 31 20:14:43 fslab1 kernel: [  390.866160] sd 10:0:1:5: [sdb]  
Jul 31 20:14:43 fslab1 kernel: [  390.869446] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:14:43 fslab1 kernel: [  390.874817] sd 10:0:1:5: [sdb] CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.878449] Inquiry: 12 00 00 00 fe 00
Jul 31 20:14:43 fslab1 kernel: [  390.882598] sd 10:0:1:5: [sdb] scsi host busy 1 failed 0
Jul 31 20:14:43 fslab1 kernel: [  390.887972] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:14:43 fslab1 kernel: [  390.894733] 0 sectors total, 254 bytes done.
Jul 31 20:14:43 fslab1 kernel: [  390.899095] sd 10:0:1:5: [sdb] sd_check_events
Jul 31 20:14:43 fslab1 kernel: [  390.899108] sd 10:0:1:5: Send: 
Jul 31 20:14:43 fslab1 kernel: [  390.899109] 0xffff88007feff480 
Jul 31 20:14:43 fslab1 kernel: [  390.899111] sd 10:0:1:5: CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.899114] Mode Sense(6): 1a 00 3f 00 04 00
Jul 31 20:14:43 fslab1 kernel: [  390.899115] buffer = 0xffff8800bebf4ec0, bufflen = 4, queuecommand 0xffffffffa029a350
Jul 31 20:14:43 fslab1 kernel: [  390.899116] leaving scsi_dispatch_cmnd()
Jul 31 20:14:43 fslab1 kernel: [  390.899141] sd 10:0:1:5: Done: 
Jul 31 20:14:43 fslab1 kernel: [  390.899142] 0xffff88007feff480 SUCCESS
Jul 31 20:14:43 fslab1 kernel: [  390.899143] sd 10:0:1:5:  
Jul 31 20:14:43 fslab1 kernel: [  390.899144] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:14:43 fslab1 kernel: [  390.899145] sd 10:0:1:5: CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.899148] Mode Sense(6): 1a 00 3f 00 04 00
Jul 31 20:14:43 fslab1 kernel: [  390.899149] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:14:43 fslab1 kernel: [  390.899151] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:14:43 fslab1 kernel: [  390.899151] 0 sectors total, 4 bytes done.
Jul 31 20:14:43 fslab1 kernel: [  390.899163] sd 10:0:1:5: Send: 
Jul 31 20:14:43 fslab1 kernel: [  390.899164] 0xffff88007feff480 
Jul 31 20:14:43 fslab1 kernel: [  390.899165] sd 10:0:1:5: CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.899168] Mode Sense(6): 1a 00 08 00 04 00
Jul 31 20:14:43 fslab1 kernel: [  390.899169] buffer = 0xffff8800bebf4ec0, bufflen = 4, queuecommand 0xffffffffa029a350
Jul 31 20:14:43 fslab1 kernel: [  390.899170] leaving scsi_dispatch_cmnd()
Jul 31 20:14:43 fslab1 kernel: [  390.899189] sd 10:0:1:5: Done: 
Jul 31 20:14:43 fslab1 kernel: [  390.899190] 0xffff88007feff480 SUCCESS
Jul 31 20:14:43 fslab1 kernel: [  390.899191] sd 10:0:1:5:  
Jul 31 20:14:43 fslab1 kernel: [  390.899192] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:14:43 fslab1 kernel: [  390.899193] sd 10:0:1:5: CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.899195] Mode Sense(6): 1a 00 08 00 04 00
Jul 31 20:14:43 fslab1 kernel: [  390.899197] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:14:43 fslab1 kernel: [  390.899199] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:14:43 fslab1 kernel: [  390.899199] 0 sectors total, 4 bytes done.
Jul 31 20:14:43 fslab1 kernel: [  390.899210] sd 10:0:1:5: Send: 
Jul 31 20:14:43 fslab1 kernel: [  390.899210] 0xffff88007feff480 
Jul 31 20:14:43 fslab1 kernel: [  390.899212] sd 10:0:1:5: CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.899214] Mode Sense(6): 1a 00 08 00 20 00
Jul 31 20:14:43 fslab1 kernel: [  390.899215] buffer = 0xffff8800bebf4ec0, bufflen = 32, queuecommand 0xffffffffa029a350
Jul 31 20:14:43 fslab1 kernel: [  390.899216] leaving scsi_dispatch_cmnd()
Jul 31 20:14:43 fslab1 kernel: [  390.899235] sd 10:0:1:5: Done: 
Jul 31 20:14:43 fslab1 kernel: [  390.899236] 0xffff88007feff480 SUCCESS
Jul 31 20:14:43 fslab1 kernel: [  390.899237] sd 10:0:1:5:  
Jul 31 20:14:43 fslab1 kernel: [  390.899238] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:14:43 fslab1 kernel: [  390.899239] sd 10:0:1:5: CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.899242] Mode Sense(6): 1a 00 08 00 20 00
Jul 31 20:14:43 fslab1 kernel: [  390.899243] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:14:43 fslab1 kernel: [  390.899244] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:14:43 fslab1 kernel: [  390.899245] 0 sectors total, 32 bytes done.
Jul 31 20:14:43 fslab1 kernel: [  390.899256] sd 10:0:1:5: Send: 
Jul 31 20:14:43 fslab1 kernel: [  390.899257] 0xffff88007feff480 
Jul 31 20:14:43 fslab1 kernel: [  390.899258] sd 10:0:1:5: CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.899261] Inquiry: 12 01 00 02 00 00
Jul 31 20:14:43 fslab1 kernel: [  390.899262] buffer = 0xffff8800bebf4ec0, bufflen = 512, queuecommand 0xffffffffa029a350
Jul 31 20:14:43 fslab1 kernel: [  390.899263] leaving scsi_dispatch_cmnd()
Jul 31 20:14:43 fslab1 kernel: [  390.899292] sd 10:0:1:5: Done: 
Jul 31 20:14:43 fslab1 kernel: [  390.899293] 0xffff88007feff480 SUCCESS
Jul 31 20:14:43 fslab1 kernel: [  390.899294] sd 10:0:1:5:  
Jul 31 20:14:43 fslab1 kernel: [  390.899295] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:14:43 fslab1 kernel: [  390.899296] sd 10:0:1:5: CDB: 
Jul 31 20:14:43 fslab1 kernel: [  390.899299] Inquiry: 12 01 00 02 00 00
Jul 31 20:14:43 fslab1 kernel: [  390.899300] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:14:43 fslab1 kernel: [  390.899302] sd 10:0:1:5: Notifying upper driver of completion (result 0)
Jul 31 20:14:43 fslab1 kernel: [  390.899302] 1 sectors total, 512 bytes done.
Jul 31 20:14:43 fslab1 kernel: [  390.899311] sd 10:0:1:5: [sdb] Attached SCSI disk
Jul 31 20:14:43 fslab1 kernel: [  391.164008] scsi_block_when_processing_errors: rtn: 1
Jul 31 20:14:43 fslab1 kernel: [  391.169231] sd 10:0:1:5: [sdb] sd_release
Jul 31 20:14:43 fslab1 kernel: [  391.173321] sd 10:0:1:5: Send: 
Jul 31 20:14:43 fslab1 kernel: [  391.176534] 0xffff8801f9aa8dc0 
Jul 31 20:14:43 fslab1 kernel: [  391.179784] sd 10:0:1:5: CDB: 
Jul 31 20:14:43 fslab1 kernel: [  391.182900] Test Unit Ready: 00 00 00 00 00 00
Jul 31 20:14:43 fslab1 kernel: [  391.187770] buffer = 0x          (null), bufflen = 0, queuecommand 0xffffffffa029a350
Jul 31 20:14:43 fslab1 kernel: [  391.195696] leaving scsi_dispatch_cmnd()
Jul 31 20:15:14 fslab1 kernel: [  421.856014] sd 10:0:1:5: Done: 
Jul 31 20:15:14 fslab1 kernel: [  421.859227] 0xffff8801f9aa8dc0 TIMEOUT
Jul 31 20:15:14 fslab1 kernel: [  421.860002] sd 10:0:1:5:  
Jul 31 20:15:14 fslab1 kernel: [  421.860002] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Jul 31 20:15:14 fslab1 kernel: [  421.860002] sd 10:0:1:5: CDB: 
Jul 31 20:15:14 fslab1 kernel: [  421.860002] Test Unit Ready: 00 00 00 00 00 00
Jul 31 20:15:14 fslab1 kernel: [  421.860002] sd 10:0:1:5: scsi host busy 1 failed 0
Jul 31 20:15:14 fslab1 kernel: [  421.860002] Waking error handler thread
Jul 31 20:15:14 fslab1 kernel: [  421.887932] Error handler scsi_eh_10 waking up
Jul 31 20:15:14 fslab1 kernel: [  421.892573] sd 10:0:1:5: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Jul 31 20:15:14 fslab1 kernel: [  421.899523] Total of 1 commands on 1 devices require eh work
Jul 31 20:15:14 fslab1 kernel: [  421.905251] scsi_eh_10: aborting cmd:0xffff8801f9aa8dc0
Jul 31 20:15:14 fslab1 kernel: [  421.910542] arcmsr10: abort device command of scsi id = 1 lun = 5 
Jul 31 20:15:17 fslab1 kernel: [  425.148016] scsi_eh_10: aborting cmd failed:0xffff8801f9aa8dc0
Jul 31 20:15:17 fslab1 kernel: [  425.153933] scsi_eh_10: Sending BDR sdev: 0xffff8800bebcf000
Jul 31 20:15:17 fslab1 kernel: [  425.159665] scsi_eh_10: BDR failed sdev:0xffff8800bebcf000
Jul 31 20:15:17 fslab1 kernel: [  425.159667] scsi_eh_10: Sending target reset to target 1
Jul 31 20:15:17 fslab1 kernel: [  425.159668] scsi_eh_10: Target reset failed target: 1
Jul 31 20:15:17 fslab1 kernel: [  425.159669] scsi_eh_10: Sending BRST chan: 0
Jul 31 20:15:17 fslab1 kernel: [  425.159670] scsi_try_bus_reset: Snd Bus RST
Jul 31 20:15:17 fslab1 kernel: [  425.159672] arcmsr: executing bus reset eh.....num_resets = 1, num_aborts = 2 
Jul 31 20:15:49 fslab1 kernel: [  457.164014] arcmsr10: wait 'abort all outstanding command' timeout 

--------------040009010701010601060502--
