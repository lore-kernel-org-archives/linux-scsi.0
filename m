From: Sheng Yang <sheng@linux.intel.com>
Subject: Re: KVM x86_64 with SR-IOV..? (device passthrough with LIO-Target v3.0)
Date: Wed, 6 May 2009 11:51:08 +0800
Message-ID: <200905061151.09853.sheng@linux.intel.com>
References: <1241122974.32740.539.camel@haakon2.linux-iscsi.org> <1241522895.32740.1080.camel@haakon2.linux-iscsi.org> <1241545547.32740.1108.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1241545547.32740.1108.camel@haakon2.linux-iscsi.org>
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Yu Zhao <yu.zhao@intel.com>, kvm-devel <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, Douglas Gilbert <dgilbert@interlog.com>, Greg KH <greg@kroah.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wednesday 06 May 2009 01:45:47 Nicholas A. Bellinger wrote:
> On Tue, 2009-05-05 at 04:28 -0700, Nicholas A. Bellinger wrote:
> > On Tue, 2009-05-05 at 03:43 -0700, Nicholas A. Bellinger wrote:
> > > On Tue, 2009-05-05 at 09:42 +0800, Yu Zhao wrote:
> > > > Hi,
> > > >
> > > > The VF also works in the host if the VF driver is programed properly.
> > > > So it would be easier to develop the VF driver in the host and then
> > > > verify the VF driver in the guest.
> > > >
> > > > BTW, I didn't see the SR-IOV is enabled in your dmesg, did you select
> > > > the CONFIG_PCI_IOV in the kernel .config?
> > > >
> > > > Thanks,
> > > > Yu
> > >
> > > Greetings Yu and Sheng,
> > >
> > > So the original attachment was for the v2.6.29-fc11 host kernel output,
> > > I ended up jumping to v2.6.30-rc3 (and making sure CONFIG_PCI_IOV was
> > > enabled) for KVM host with kvm-85 and now things are looking quite
> > > stable for me.
> > >
> > > So far I have been able to successfully push LIO-Target v3.0 traffic
> > > *inside* a v2.6.29.2 KVM guest via the onboard e1000e (02:00.0) port
> > > from another Linux/iSCSI Initiator machine using a Intel 1 Gb/sec port.
> > > I am running badblocks tests to iSCSI Logical Units for RAMDISK_DR and
> > > FILEIO storage objects (in the KVM Guest), and they are passing
> > > validation and I am seeing ~500 Mb/sec of throughput and very low CPU
> > > usage in the KVM guests.
> >
> > Ok I am seeing another issue with the e1000e port on 02:00.0..:
> >
> > As i start to push multiple badblocks tests RAMDISK_DR iSCSI Logical
> > units into KVM Guest running LIO v2.6.29.2 from the external Linux/iSCSI
> > Initiator machine, after about 100 GB of iSCSI traffic, I see the
> > following exception in KVM host v2.6.30-rc3:
> >
> > DRHD: handling fault status reg 2
> > DMAR:[DMA Write] Request device [02:00.0] fault addr 7fc958b010000
> > DMAR:[fault reason 04] Access beyond MGAW
> > pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
> > pci-stub 0000:02:00.0: irq 60 for MSI/MSI-X
> > pci-stub 0000:02:00.0: irq 61 for MSI/MSI-X
> >
> > I am able to restart the LIO-Target KVM Guest and the Linux/iSCSI
> > Initiators are able to reconnect..  Wow, very cool..
> >
> > Not sure if this is a bug in the target_core_mod RAMDISK_DR subsystem
> > plugin (mapping struct iovec to internally allocated struct page) or
> > what.  I will have to look at the DMAR code to understand what this
> > exception means..
>
> Greetings Yu, Sheng and Co,
>
> So I have been making progress this morning..  So far, I have hooked up
> a LSI mpt-function PCIe SAS adapter into the KVM guest with a Sandisk
> SATA SSD 32 GB drive.  It is using MSI interrupts (not MSI-X) and I am
> able to push ~70 MB/sec from a 2nd Linux/iSCSI Initiator machine
> (running Open-iSCSI) with the 1500 byte MTUs on e1000e ports from within
> the KVM guest.

Is MSI-X can't be enabled or the device only have MSI capability? Just 
curious...

> The interesting thing is that I am having to use IBLOCK export (using
> using submit_bio(), and complete emulation of SCSI control path) for
> SATA SSD in order to get I/O running stable  Using the pSCSI export I am
> getting immediate exceptions from scsi_execute_async() in the v2.6.29.2
> KVM guest..  

Didn't see exception in the log below... (And buried with iscsi log I can't 
understand. Looking forward for the help from others...) Any thing notable 
show in the host side? I think the target to get pSCSI work well now?

BTW: Maybe you can try the patch from Marcelo titled "[patch 0/4] use 
smp_send_reschedule in vcpu_kick / assigned dev host intx race fix".

-- 
regards
Yang, Sheng


> Using a 2nd SAS disk I am able to use target_core_mod/pSCSI
> export and push badblocks and LTP disktest traffic however..

> Here is a bit about the the setup looks,
>
> *) Linux/iSCSI Initiator node accessing KVM Guest LIO-Target v3.0
> storage:
>
> subjekt:~# lsscsi
> [6:0:0:0]    disk    ATA      ST3250820AS      3.AA  /dev/sda
> [10:0:0:0]   cd/dvd  PIONEER  DVD-ROM DVD-305  1.06  /dev/scd1
> [18:0:0:0]   cd/dvd  TOSHIBA  DVD/HD  X807616  MC08  /dev/scd2
> [32:0:0:0]   disk    LIO-ORG  RAMDISK-DR       3.0   /dev/sdb
> [32:0:0:1]   disk    LIO-ORG  RAMDISK-DR       3.0   /dev/sdc
> [32:0:0:2]   disk    LIO-ORG  FILEIO           3.0   /dev/sdd
> [32:0:0:3]   disk    LIO-ORG  IBLOCK           3.0   /dev/sde
>
> subjekt:~# sg_inq -i /dev/sde
> VPD INQUIRY: Device Identification page
>   Designation descriptor number 1, descriptor length: 20
>     id_type: NAA,  code_set: Binary
>     associated with the addressed logical unit
>       NAA 6, IEEE Company_id: 0x1405
>       Vendor Specific Identifier: 0xa97e4ce21
>       Vendor Specific Identifier Extension: 0xc0711de829b000c2
>       [0x6001405a97e4ce21c0711de829b000c2]
>   Designation descriptor number 2, descriptor length: 52
>     id_type: T10 vendor identification,  code_set: ASCII
>     associated with the addressed logical unit
>       vendor id: LIO-ORG
>       vendor specific: IBLOCK:a97e4ce21c0711de829b000c2943d57b
>   Designation descriptor number 3, descriptor length: 8
>     transport: Internet SCSI (iSCSI)
>     id_type: Relative target port,  code_set: Binary
>     associated with the target port
>       Relative target port: 0x1
>   Designation descriptor number 4, descriptor length: 8
>     transport: Internet SCSI (iSCSI)
>     id_type: Target port group,  code_set: Binary
>     associated with the target port
>       Target port group: 0x0
>   Designation descriptor number 5, descriptor length: 8
>     id_type: Logical unit group,  code_set: Binary
>     associated with the addressed logical unit
>       Logical unit group: 0x0
>   Designation descriptor number 6, descriptor length: 80
>     transport: Internet SCSI (iSCSI)
>     id_type: SCSI name string,  code_set: UTF-8
>     associated with the target port
>       SCSI name string:
> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6,t,0x0001
>
> The SATA SSD is available as /dev/sde on the Linux/iSCSI Initiator node,
> the 2nd SAS disk was removed from the dmesg below as having multiple
> drives on the mpt-function card made it start to hiccup..
>
> --nab
>
> *) From with the LIO-Target KVM gest:
>
> lenny64guest1:~# lspci
> 00:00.0 Host bridge: Intel Corporation 440FX - 82441FX PMC [Natoma] (rev
> 02) 00:01.0 ISA bridge: Intel Corporation 82371SB PIIX3 ISA [Natoma/Triton
> II] 00:01.1 IDE interface: Intel Corporation 82371SB PIIX3 IDE
> [Natoma/Triton II] 00:01.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4
> ACPI (rev 03) 00:02.0 VGA compatible controller: Cirrus Logic GD 5446
> 00:03.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL-8139/8139C/8139C+ (rev 20) 00:04.0 RAM memory: Qumranet, Inc. Device
> 1002
> 00:05.0 Ethernet controller: Intel Corporation 82574L Gigabit Network
> Connection 00:06.0 SCSI storage controller: LSI Logic / Symbios Logic
> SAS1068E PCI-Express Fusion-MPT SAS (rev 02)
>
>
> *) Dmesg from LIO-Target KVM guest:
>
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 2.6.29.2 (root@lenny64guest1) (gcc version
> 4.3.2 (Debian 4.3.2-1.1) ) #2 SMP Mon May 4 01:22:53 PDT 2009 [   
> 0.000000] Command line: root=/dev/hda1 ro
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   Centaur CentaurHauls
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
> [    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
> [    0.000000]  BIOS-e820: 000000007fff0000 - 0000000080000000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
> [    0.000000] DMI 2.4 present.
> [    0.000000] last_pfn = 0x7fff0 max_arch_pfn = 0x100000000
> [    0.000000] init_memory_mapping: 0000000000000000-000000007fff0000
> [    0.000000]  0000000000 - 007fe00000 page 2M
> [    0.000000]  007fe00000 - 007fff0000 page 4k
> [    0.000000] kernel direct mapping tables up to 7fff0000 @ 8000-c000
> [    0.000000] last_map_addr: 7fff0000 end: 7fff0000
> [    0.000000] RAMDISK: 379c8000 - 37fef480
> [    0.000000] ACPI: RSDP 000FBE50, 0014 (r0 QEMU  )
> [    0.000000] ACPI: RSDT 7FFF0000, 002C (r1 QEMU   QEMURSDT        1 QEMU 
>       1) [    0.000000] ACPI: FACP 7FFF002C, 0074 (r1 QEMU   QEMUFACP      
>  1 QEMU        1) [    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does
> not match PM1_EVT_LEN (4) [    0.000000] ACPI: DSDT 7FFF0100, 2540 (r1  
> BXPC   BXDSDT        1 INTL 20061109) [    0.000000] ACPI: FACS 7FFF00C0,
> 0040
> [    0.000000] ACPI: APIC 7FFF2640, 00E0 (r1 QEMU   QEMUAPIC        1 QEMU 
>       1) [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at 0000000000000000-000000007fff0000
> [    0.000000] Bootmem setup node 0 0000000000000000-000000007fff0000
> [    0.000000]   NODE_DATA [0000000000001000 - 0000000000005fff]
> [    0.000000]   bootmap [000000000000a000 -  0000000000019fff] pages 10
> [    0.000000] (6 early reservations) ==> bootmem [0000000000 - 007fff0000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
> [0000000000 - 0000001000] [    0.000000]   #1 [0000006000 - 0000008000]    
>   TRAMPOLINE ==> [0000006000 - 0000008000] [    0.000000]   #2 [0000200000
> - 000070493c]    TEXT DATA BSS ==> [0000200000 - 000070493c] [    0.000000]
>   #3 [00379c8000 - 0037fef480]          RAMDISK ==> [00379c8000 -
> 0037fef480] [    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved
> ==> [000009fc00 - 0000100000] [    0.000000]   #5 [0000008000 - 000000a000]
>          PGTABLE ==> [0000008000 - 000000a000] [    0.000000] found SMP
> MP-table at [ffff8800000fbd10] 000fbd10
> [    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD ->
> [ffff880001200000-ffff880002dfffff] on node 0 [    0.000000] Zone PFN
> ranges:
> [    0.000000]   DMA      0x00000000 -> 0x00001000
> [    0.000000]   DMA32    0x00001000 -> 0x00100000
> [    0.000000]   Normal   0x00100000 -> 0x00100000
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[2] active PFN ranges
> [    0.000000]     0: 0x00000000 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x0007fff0
> [    0.000000] On node 0 totalpages: 524175
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 1387 pages reserved
> [    0.000000]   DMA zone: 2556 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 7112 pages used for memmap
> [    0.000000]   DMA32 zone: 513064 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] disabled)
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI
> 0-23 [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high
> level) [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high
> level) [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10
> high level) [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq
> 11 high level) [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] SMP: Allowing 16 CPUs, 14 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 24
> [    0.000000] PM: Registered nosave memory: 000000000009f000 -
> 00000000000a0000 [    0.000000] PM: Registered nosave memory:
> 00000000000a0000 - 00000000000e8000 [    0.000000] PM: Registered nosave
> memory: 00000000000e8000 - 0000000000100000 [    0.000000] Allocating PCI
> resources starting at 88000000 (gap: 80000000:7ffbc000) [    0.000000]
> NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:16 nr_node_ids:1 [    0.000000]
> PERCPU: Allocating 49152 bytes of per cpu data
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on. 
> Total pages: 515620 [    0.000000] Policy zone: DMA32
> [    0.000000] Kernel command line: root=/dev/hda1 ro
> [    0.000000] Initializing CPU#0
> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2266.815 MHz processor.
> [    0.004000] Console: colour VGA+ 80x25
> [    0.004000] console [tty0] enabled
> [    0.004000] Checking aperture...
> [    0.004000] No AGP bridge found
> [    0.004000] Calgary: detecting Calgary via BIOS EBDA area
> [    0.004000] Calgary: Unable to locate Rio Grande table in EBDA -
> bailing! [    0.004000] Memory: 2055644k/2097088k available (2463k kernel
> code, 388k absent, 41056k reserved, 1259k data, 464k init) [    0.004013]
> Calibrating delay loop (skipped), value calculated using timer frequency..
> 4533.63 BogoMIPS (lpj=9067260) [    0.004985] Security Framework
> initialized
> [    0.005422] SELinux:  Disabled at boot.
> [    0.005995] Dentry cache hash table entries: 262144 (order: 9, 2097152
> bytes) [    0.007887] Inode-cache hash table entries: 131072 (order: 8,
> 1048576 bytes) [    0.008603] Mount-cache hash table entries: 256
> [    0.009309] Initializing cgroup subsys ns
> [    0.009739] Initializing cgroup subsys cpuacct
> [    0.010172] Initializing cgroup subsys devices
> [    0.010655] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.011229] CPU: L2 cache: 2048K
> [    0.011633] CPU 0/0x0 -> Node 0
> [    0.012061] ACPI: Core revision 20081204
> [    0.013529] Setting APIC routing to flat
> [    0.015117] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
> [    0.055398] CPU0: Intel QEMU Virtual CPU version 0.10.0 stepping 03
> [    0.273970] Booting processor 1 APIC 0x1 ip 0x6000
> [    0.004000] Initializing CPU#1
> [    0.004000] Calibrating delay using timer specific routine.. 4533.28
> BogoMIPS (lpj=9066565) [    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.004000] CPU: L2 cache: 2048K
> [    0.004000] CPU 1/0x1 -> Node 0
> [    0.364147] CPU1: Intel QEMU Virtual CPU version 0.10.0 stepping 03
> [    0.367429] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> [    0.372036] Brought up 2 CPUs
> [    0.372442] Total of 2 processors activated (9066.91 BogoMIPS).
> [    0.373176] CPU0 attaching sched-domain:
> [    0.373181]  domain 0: span 0-1 level CPU
> [    0.373183]   groups: 0 1
> [    0.373186] CPU1 attaching sched-domain:
> [    0.373187]  domain 0: span 0-1 level CPU
> [    0.373188]   groups: 1 0
> [    0.373255] net_namespace: 1888 bytes
> [    0.373255] NET: Registered protocol family 16
> [    0.373269] ACPI: bus type pci registered
> [    0.376082] PCI: Using configuration type 1 for base access
> [    0.380281] bio: create slab <bio-0> at 0
> [    0.381293] ACPI: EC: Look up EC in DSDT
> [    0.383292] ACPI: Interpreter enabled
> [    0.383693] ACPI: (supports S0 S3 S4 S5)
> [    0.384763] ACPI: Using IOAPIC for interrupt routing
> [    0.388691] ACPI: No dock devices found.
> [    0.388729] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.393074] pci 0000:00:01.1: reg 20 io port: [0xc000-0xc00f]
> [    0.393406] pci 0000:00:01.3: quirk: region b000-b03f claimed by PIIX4
> ACPI [    0.393920] pci 0000:00:01.3: quirk: region b100-b10f claimed by
> PIIX4 SMB [    0.395842] pci 0000:00:02.0: reg 10 32bit mmio:
> [0xf0000000-0xf1ffffff] [    0.396508] pci 0000:00:02.0: reg 14 32bit mmio:
> [0xf2000000-0xf2000fff] [    0.401611] pci 0000:00:03.0: reg 10 io port:
> [0xc100-0xc1ff]
> [    0.401674] pci 0000:00:03.0: reg 14 32bit mmio: [0xf2001000-0xf20010ff]
> [    0.401903] pci 0000:00:04.0: reg 10 io port: [0xc200-0xc21f]
> [    0.403518] pci 0000:00:05.0: reg 10 32bit mmio: [0xf2020000-0xf203ffff]
> [    0.404059] pci 0000:00:05.0: reg 18 io port: [0xc220-0xc23f]
> [    0.404368] pci 0000:00:05.0: reg 1c 32bit mmio: [0xf2040000-0xf2043fff]
> [    0.405176] pci 0000:00:06.0: reg 10 io port: [0xc300-0xc3ff]
> [    0.405474] pci 0000:00:06.0: reg 14 32bit mmio: [0xf2044000-0xf2047fff]
> [    0.405804] pci 0000:00:06.0: reg 1c 32bit mmio: [0xf2050000-0xf205ffff]
> [    0.405948] pci 0000:00:06.0: reg 30 32bit mmio: [0x200000-0x3fffff]
> [    0.406577] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.408281] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
> [    0.412098] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
> [    0.413393] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
> [    0.414571] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
> [    0.416142] usbcore: registered new interface driver usbfs
> [    0.416504] usbcore: registered new interface driver hub
> [    0.416504] usbcore: registered new device driver usb
> [    0.416508] PCI: Using ACPI for IRQ routing
> [    0.452044] pnp: PnP ACPI init
> [    0.452515] ACPI: bus type pnp registered
> [    0.454439] pnp: PnP ACPI: found 7 devices
> [    0.454918] ACPI: ACPI bus type pnp unregistered
> [    0.460804] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
> [    0.460807] pci_bus 0000:00: resource 1 mem:
> [0x000000-0xffffffffffffffff] [    0.460969] NET: Registered protocol
> family 2
> [    0.508246] IP route cache hash table entries: 65536 (order: 7, 524288
> bytes) [    0.537526] TCP established hash table entries: 262144 (order:
> 10, 4194304 bytes) [    0.542048] TCP bind hash table entries: 65536
> (order: 8, 1048576 bytes) [    0.543577] TCP: Hash tables configured
> (established 262144 bind 65536) [    0.544332] TCP reno registered
> [    0.556665] NET: Registered protocol family 1
> [    0.557476] checking if image is initramfs... it is
> [    0.980042] Switched to high resolution mode on CPU 1
> [    0.983993] Switched to high resolution mode on CPU 0
> [    1.028987] Freeing initrd memory: 6301k freed
> [    1.032241] audit: initializing netlink socket (disabled)
> [    1.032745] type=2000 audit(1241543237.032:1): initialized
> [    1.035249] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    1.036055] VFS: Disk quotas dquot_6.5.2
> [    1.036182] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    1.036182] msgmni has been set to 4027
> [    1.036182] alg: No test for stdrng (krng)
> [    1.036182] Block layer SCSI generic (bsg) driver version 0.4 loaded
> (major 253) [    1.036182] io scheduler noop registered
> [    1.036182] io scheduler anticipatory registered
> [    1.036182] io scheduler deadline registered
> [    1.040223] io scheduler cfq registered (default)
> [    1.040692] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    1.041194] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [    1.041681] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [    1.042183] pci 0000:00:02.0: Boot video device
> [    1.048876] Linux agpgart interface v0.103
> [    1.049315] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    1.050082] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    1.051351] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    1.054962] brd: module loaded
> [    1.055662] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64
> irq 1,12 [    1.111469] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    1.112044] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    1.112901] mice: PS/2 mouse device common for all mice
> [    1.114216] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
> [    1.114828] rtc0: alarms up to one day, 114 bytes nvram
> [    1.115363] input: AT Translated Set 2 keyboard as /class/input/input0
> [    1.115934] cpuidle: using governor ladder
> [    1.116448] cpuidle: using governor menu
> [    1.116926] No iBFT detected.
> [    1.117634] TCP cubic registered
> [    1.118088] NET: Registered protocol family 17
> [    1.118873] registered taskstats version 1
> [    1.119543] rtc_cmos 00:01: setting system clock to 2009-05-05 17:07:17
> UTC (1241543237) [    1.120418] Freeing unused kernel memory: 464k freed
> [    1.193327] processor ACPI_CPU:00: registered as cooling_device0
> [    1.194273] processor ACPI_CPU:01: registered as cooling_device1
> [    1.392735] Uniform Multi-Platform E-IDE driver
> [    1.413020] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
> [    1.413531] virtio-pci 0000:00:04.0: PCI INT A -> Link[LNKD] -> GSI 11
> (level, high) -> IRQ 11 [    1.415182] 8139too Fast Ethernet driver 0.9.28
> [    1.415673] 8139too 0000:00:03.0: This (id 10ec:8139 rev 20) is an
> enhanced 8139C+ chip, use 8139cp [    1.418181] e1000e: Intel(R) PRO/1000
> Network Driver - 0.3.3.3-k6 [    1.418680] e1000e: Copyright (c) 1999-2008
> Intel Corporation.
> [    1.419758] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
> [    1.420328] e1000e 0000:00:05.0: PCI INT A -> Link[LNKA] -> GSI 10
> (level, high) -> IRQ 10 [    1.421130] e1000e 0000:00:05.0: setting latency
> timer to 64
> [    1.421963] e1000e 0000:00:05.0: irq 24 for MSI/MSI-X
> [    1.421999] e1000e 0000:00:05.0: irq 25 for MSI/MSI-X
> [    1.422033] e1000e 0000:00:05.0: irq 26 for MSI/MSI-X
> [    1.431733] SCSI subsystem initialized
> [    1.445624] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
> [    1.453420] Fusion MPT base driver 3.04.07
> [    1.453849] Copyright (c) 1999-2008 LSI Corporation
> [    1.461332] Fusion MPT SAS Host driver 3.04.07
> [    1.464878] FDC 0 is a S82078B
> [    1.549697] 0000:00:05.0: eth0: (PCI Express:2.5GB/s:Width x1)
> 00:e0:81:c0:90:b2 [    1.550752] 0000:00:05.0: eth0: Intel(R) PRO/1000
> Network Connection [    1.551549] 0000:00:05.0: eth0: MAC: 3, PHY: 8, PBA
> No: ffffff-0ff [    1.553336] ACPI: PCI Interrupt Link [LNKC] enabled at
> IRQ 11
> [    1.553940] udev: renamed network interface eth0 to eth1
> [    1.554683] 8139cp 0000:00:03.0: PCI INT A -> Link[LNKC] -> GSI 11
> (level, high) -> IRQ 11 [    1.557146] eth0: RTL-8139C+ at
> 0xffffc2000096a000, 52:54:00:12:34:56, IRQ 11 [    1.560485] 8139cp
> 0000:00:03.0: setting latency timer to 64
> [    1.560904] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
> [    1.561607] mptsas 0000:00:06.0: PCI INT A -> Link[LNKB] -> GSI 10
> (level, high) -> IRQ 10 [    1.563379] mptbase: ioc0: Initiating bringup
> [    1.634659] mptbase: ioc0: WARNING - Unexpected doorbell active!
> [    5.343913] ioc0: LSISAS1068E B1: Capabilities={Initiator}
> [    5.345428] mptsas 0000:00:06.0: setting latency timer to 64
> [   22.874565] scsi0 : ioc0: LSISAS1068E B1, FwRev=010f0000h, Ports=1,
> MaxQ=511, IRQ=10 [   22.903281] scsi 0:0:0:0: Direct-Access     ATA     
> SanDisk SSD SATA 1.20 PQ: 0 ANSI: 5 [   22.906530] piix 0000:00:01.1: IDE
> controller (0x8086:0x7010 rev 0x00) [   22.908623] piix 0000:00:01.1: not
> 100% native mode: will probe irqs later [   22.909390] PIIX_IDE
> 0000:00:01.1: setting latency timer to 64
> [   22.909410]     ide0: BM-DMA at 0xc000-0xc007
> [   22.910045]     ide1: BM-DMA at 0xc008-0xc00f
> [   22.910666] Probing IDE interface ide0...
> [   22.933264] Driver 'sd' needs updating - please use bus_type methods
> [   22.936186] sd 0:0:0:0: [sda] 62533296 512-byte hardware sectors: (32.0
> GB/29.8 GiB) [   22.938165] sd 0:0:0:0: [sda] Write Protect is off
> [   22.938808] sd 0:0:0:0: [sda] Mode Sense: 73 00 00 08
> [   22.940775] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
> doesn't support DPO or FUA [   22.942194] sd 0:0:0:0: [sda] 62533296
> 512-byte hardware sectors: (32.0 GB/29.8 GiB) [   22.944225] sd 0:0:0:0:
> [sda] Write Protect is off
> [   22.944879] sd 0:0:0:0: [sda] Mode Sense: 73 00 00 08
> [   22.946734] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
> doesn't support DPO or FUA [   22.947886]  sda: unknown partition table
> [   22.951811] sd 0:0:0:0: [sda] Attached SCSI disk
> [   23.211126] hda: QEMU HARDDISK, ATA DISK drive
> [   23.883187] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO2
> [   23.883289] hda: MWDMA2 mode selected
> [   23.884023] Probing IDE interface ide1...
> [   24.283042] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
> [   24.955145] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
> [   24.955199] hdc: MWDMA2 mode selected
> [   24.955978] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [   24.956812] isa bounce pool size: 16 pages
> [   24.957471] ide1 at 0x170-0x177,0x376 on irq 15
> [   24.974924] libata version 3.00 loaded.
> [   24.992633] ide-gd driver 1.18
> [   24.993261] hda: max request size: 512KiB
> [   24.993874] hda: 16384000 sectors (8388 MB) w/256KiB Cache,
> CHS=16253/255/63 [   25.000639] ide-cd driver 5.00
> [   25.007111] hda: cache flushes supported
> [   25.007753]  hda: hda1 hda2 < hda5 >
> [   25.010488] ide-cd: hdc: ATAPI 4X CD-ROM drive, 512kB Cache
> [   25.011858] Uniform CD-ROM driver Revision: 3.20
> [   25.110990] PM: Starting manual resume from disk
> [   25.129340] EXT3-fs: INFO: recovery required on readonly filesystem.
> [   25.130052] EXT3-fs: write access will be enabled during recovery.
> [   26.128769] kjournald starting.  Commit interval 5 seconds
> [   26.129481] EXT3-fs: recovery complete.
> [   26.130963] EXT3-fs: mounted filesystem with ordered data mode.
> [   26.335166] udevd version 125 started
> [   26.631975] input: Power Button (FF) as /class/input/input1
> [   26.666993] ACPI: Power Button (FF) [PWRF]
> [   26.681253] parport_pc 00:05: reported by Plug and Play ACPI
> [   26.681824] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
> [   26.723397] input: PC Speaker as /class/input/input2
> [   26.724903] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100,
> revision 0 [   26.949233] input: ImExPS/2 Generic Explorer Mouse as
> /class/input/input3 [   58.566336] Adding 393552k swap on /dev/hda5. 
> Priority:-1 extents:1 across:393552k [   58.594239] EXT3 FS on hda1,
> internal journal
> [   59.613114] loop: module loaded
> [   60.681886] eth0: link up, 100Mbps, full-duplex, lpa 0x05E1
> [   63.746408] NET: Registered protocol family 10
> [   63.748013] lo: Disabled Privacy Extensions
> [   73.968880] eth0: no IPv6 routers present
> [  233.617434] ADDRCONF(NETDEV_UP): eth1_rename: link is not ready
> [  236.587594] e1000e: eth1_rename NIC Link is Up 1000 Mbps Full Duplex,
> Flow Control: RX/TX [  236.595715] ADDRCONF(NETDEV_CHANGE): eth1_rename:
> link becomes ready [  243.146435] TARGET_CORE[0]: Loading Generic Kernel
> Storage Engine: v3.0.0 on Linux/x86_64 on 2.6.29.2 [  243.147955]
> TARGET_CORE[0]: Initialized ConfigFS Fabric Infrastructure: v1.0.0 on
> Linux/x86_64 on 2.6.29.2 [  243.149107] SE_PC[0] - Registered Plugin Class:
> TRANSPORT
> [  243.149830] PLUGIN_TRANSPORT[1] - pscsi registered
> [  243.150492] PLUGIN_TRANSPORT[2] - stgt registered
> [  243.151183] CORE_STGT[0]: Bus Initalization complete
> [  243.151838] PLUGIN_TRANSPORT[4] - iblock registered
> [  243.152483] PLUGIN_TRANSPORT[5] - rd_dr registered
> [  243.153126] PLUGIN_TRANSPORT[6] - rd_mcp registered
> [  243.155097] PLUGIN_TRANSPORT[7] - fileio registered
> [  243.155743] SE_PC[1] - Registered Plugin Class: OBJ
> [  243.156372] PLUGIN_OBJ[1] - dev registered
> [  243.160265] Target_Core_ConfigFS: Located se_plugin: ffff88007c4318e0
> plugin_name: iblock hba_type: 4 plugin_dep_id: 0 [  243.161454] CORE_HBA[0]
> - Linux-iSCSI.org iBlock HBA Driver 3.0 on Generic Target Core Stack v3.0 [
>  243.162630] CORE_HBA[0] - Attached iBlock HBA: 0 to Generic Target Core
> TCQ Depth: 512 [  243.163681] CORE_HBA[0] - Attached HBA to Generic Target
> Core
> [  243.164496] IBLOCK: Allocated ib_dev for ssd_test0
> [  243.165152] Target_Core_ConfigFS: Allocated se_subsystem_dev_t:
> ffff88007c022000 se_dev_su_ptr: ffff88007c444c00 [  243.166753]
> Target_Core_ConfigFS: Set emulated VPD Unit Serial:
> a97e4ce21c0711de829b000c2943d57b [  243.167947] IBLOCK: Referencing Major:
> 8
> [  243.168541] IBLOCK: Referencing Minor: 0
> [  243.169225] IBLOCK: Claiming ffff88007c444c00 Major:Minor - 8:0
> [  243.170021] bio: create slab <bio-1> at 1
> [  243.170656] IBLOCK: Created bio_set() for major/minor: 8:0
> [  243.171325] iblock: Using SPC3_PERSISTENT_RESERVATIONS emulation
> [  243.172012] iblock: Enabling ALUA Emulation for SPC-3 device
> [  243.172696] iblock: Adding to default ALUA LU Group:
> core/alua/lu_gps/default_lu_gp [  243.173802] CORE_iBLOCK[0] - Activating
> Device with TCQ: 0 at Major: 8 Minor 0 [  243.175345]   Vendor: LIO-ORG  
> Model: IBLOCK            Revision: 3.0 [  243.181019]   Type:  
> Direct-Access                      ANSI SCSI revision: 05 [  243.182592]
> T10 VPD Unit Serial Number: a97e4ce21c0711de829b000c2943d57b [  243.183397]
> T10 VPD Page Length: 72
> [  243.183983] T10 VPD Identifer Length: 16
> [  243.184588] T10 VPD Identifier Association: addressed logical unit
> [  243.185286] T10 VPD Identifier Type: NAA
> [  243.186965] T10 VPD Binary Device Identifier:
> 36001405a97e4ce21c0711de829b000c2 [  243.187993] T10 VPD Identifer Length:
> 48
> [  243.188602] T10 VPD Identifier Association: addressed logical unit
> [  243.189303] T10 VPD Identifier Type: T10 Vendor ID based
> [  243.190037] T10 VPD ASCII Device Identifier: LIO-ORG
> [  243.191029] Target_Core_ConfigFS: Registered se_dev->se_dev_ptr:
> ffff88007c5d1400 [  243.193246] Target_Core_ConfigFS: Located se_plugin:
> ffff88007c431838 plugin_name: pscsi hba_type: 1 plugin_dep_id: 0 [ 
> 243.194482] CORE_HBA[1] - Linux-iSCSI.org SCSI HBA Driver v3.0 on Generic
> Target Core Stack v3.0 [  243.195580] CORE_HBA[1] - MPT SPI Host
> [  243.196170] CORE_HBA[1] - Attached SCSI HBA to Generic Target Core with
> TCQ Depth: 127 MaxSectors: 8192 [  243.197292] CORE_HBA[1] - Attached HBA
> to Generic Target Core
> [  243.198125] PSCSI: Allocated pdv: ffff88007c42aa00 for sda
> [  243.198803] Target_Core_ConfigFS: Allocated se_subsystem_dev_t:
> ffff88007c582000 se_dev_su_ptr: ffff88007c42aa00 [  243.201132] PSCSI:
> Allocated pdv: ffff88007d064140 for sdb
> [  243.201952] Target_Core_ConfigFS: Allocated se_subsystem_dev_t:
> ffff88007c1d9800 se_dev_su_ptr: ffff88007d064140 [  243.203550] PSCSI[0]:
> Referencing SCSI Channel ID: 0
> [  243.204200] PSCSI[0]: Referencing SCSI Target ID: 1
> [  243.204841] PSCSI[0]: Referencing SCSI LUN ID: 0
> [  243.205550] Unable to locate 0:0:1:0
> [  243.208465] Target_Core_ConfigFS: Located se_plugin: ffff88007c431918
> plugin_name: rd_dr hba_type: 5 plugin_dep_id: 0 [  243.209674] CORE_HBA[2]
> - Linux-iSCSI.org Ramdisk HBA Driver v3.0 on Generic Target Core Stack v3.0
> [  243.210802] CORE_HBA[2] - Attached Ramdisk HBA: 0 to Generic Target Core
> TCQ Depth: 256 MaxSectors: 1024 [  243.211942] CORE_HBA[2] - Attached HBA
> to Generic Target Core
> [  243.212774] Target_Core_ConfigFS: Allocated se_subsystem_dev_t:
> ffff88007c59c800 se_dev_su_ptr: ffff88007c4374c0 [  243.214315] RAMDISK:
> Referencing Page Count: 32768
> [  243.224608] CORE_RD[0] - Built Ramdisk Device ID: 0 space of 32768 pages
> in 17 tables [  243.225795] rd_dr: Using SPC3_PERSISTENT_RESERVATIONS
> emulation [  243.226490] rd_dr: Enabling ALUA Emulation for SPC-3 device
> [  243.227165] rd_dr: Adding to default ALUA LU Group:
> core/alua/lu_gps/default_lu_gp [  243.228212] CORE_RD[0] - Activating
> Device with TCQ: 0 at Ramdisk Device ID: 0 [  243.229792]   Vendor: LIO-ORG
>   Model: RAMDISK-DR        Revision: 3.0 [  243.235413]   Type:  
> Direct-Access                      ANSI SCSI revision: 05 [  243.236861]
> T10 VPD Unit Serial Number: 1234567890:2_0
> [  243.237599] T10 VPD Page Length: 38
> [  243.238220] T10 VPD Identifer Length: 34
> [  243.238860] T10 VPD Identifier Association: addressed logical unit
> [  243.239540] T10 VPD Identifier Type: T10 Vendor ID based
> [  243.240190] T10 VPD ASCII Device Identifier: LIO-ORG
> [  243.241083] CORE_RD[0] - Added LIO DIRECT Ramdisk Device ID: 0 of 32768
> pages in 17 tables, 134217728 total bytes [  243.242336]
> Target_Core_ConfigFS: Registered se_dev->se_dev_ptr: ffff88007c5d1000 [ 
> 243.244650] Target_Core_ConfigFS: Located se_plugin: ffff88007c431918
> plugin_name: rd_dr hba_type: 5 plugin_dep_id: 1 [  243.245895] CORE_HBA[3]
> - Linux-iSCSI.org Ramdisk HBA Driver v3.0 on Generic Target Core Stack v3.0
> [  243.247006] CORE_HBA[3] - Attached Ramdisk HBA: 1 to Generic Target Core
> TCQ Depth: 256 MaxSectors: 1024 [  243.248131] CORE_HBA[3] - Attached HBA
> to Generic Target Core
> [  243.248838] Target_Core_ConfigFS: Allocated se_subsystem_dev_t:
> ffff88007c18c000 se_dev_su_ptr: ffff88007c973940 [  243.252447] RAMDISK:
> Referencing Page Count: 32768
> [  243.262801] CORE_RD[1] - Built Ramdisk Device ID: 0 space of 32768 pages
> in 17 tables [  243.263870] rd_dr: Using SPC3_PERSISTENT_RESERVATIONS
> emulation [  243.264555] rd_dr: Enabling ALUA Emulation for SPC-3 device
> [  243.265231] rd_dr: Adding to default ALUA LU Group:
> core/alua/lu_gps/default_lu_gp [  243.266342] CORE_RD[1] - Activating
> Device with TCQ: 0 at Ramdisk Device ID: 0 [  243.267625]   Vendor: LIO-ORG
>   Model: RAMDISK-DR        Revision: 3.0 [  243.273342]   Type:  
> Direct-Access                      ANSI SCSI revision: 05 [  243.274807]
> T10 VPD Unit Serial Number: 1234567890:3_0
> [  243.275527] T10 VPD Page Length: 38
> [  243.276125] T10 VPD Identifer Length: 34
> [  243.276734] T10 VPD Identifier Association: addressed logical unit
> [  243.277439] T10 VPD Identifier Type: T10 Vendor ID based
> [  243.278173] T10 VPD ASCII Device Identifier: LIO-ORG
> [  243.278891] CORE_RD[1] - Added LIO DIRECT Ramdisk Device ID: 0 of 32768
> pages in 17 tables, 134217728 total bytes [  243.280067]
> Target_Core_ConfigFS: Registered se_dev->se_dev_ptr: ffff880037943400 [ 
> 243.282480] Target_Core_ConfigFS: Located se_plugin: ffff88007c431988
> plugin_name: fileio hba_type: 7 plugin_dep_id: 0 [  243.320107] CORE_HBA[4]
> - Linux-iSCSI.org FILEIO HBA Driver 3.0 on Generic Target Core Stack v3.0 [
>  243.321211] CORE_HBA[4] - Attached FILEIO HBA: 0 to Generic Target Core
> with TCQ Depth: 256 MaxSectors: 1024 [  243.322383] CORE_HBA[4] - Attached
> HBA to Generic Target Core
> [  243.323284] FILEIO: Allocated fd_dev for ffff88007bd61ee0
> [  243.323964] Target_Core_ConfigFS: Allocated se_subsystem_dev_t:
> ffff88007d1b6000 se_dev_su_ptr: ffff88007c444000 [  243.325456]
> Target_Core_ConfigFS: Set emulated VPD Unit Serial:
> 66e418b4e9ab11dd8f51000c2943d57b [  243.340857] FILEIO: Referencing Path:
> /tmp/fileio
> [  243.341504] FILEIO: Referencing Size: 134217728 bytes
> [  243.342298] fileio: Using SPC3_PERSISTENT_RESERVATIONS emulation
> [  243.342998] fileio: Enabling ALUA Emulation for SPC-3 device
> [  243.343668] fileio: Adding to default ALUA LU Group:
> core/alua/lu_gps/default_lu_gp [  243.344706] CORE_FILE[0] - Activating
> Device with TCQ: 0 at FILEIO Device ID: 0 [  243.346260]   Vendor: LIO-ORG 
>  Model: FILEIO            Revision: 3.0 [  243.351966]   Type:  
> Direct-Access                      ANSI SCSI revision: 05 [  243.353392]
> T10 VPD Unit Serial Number: 66e418b4e9ab11dd8f51000c2943d57b [  243.354363]
> T10 VPD Page Length: 72
> [  243.354961] T10 VPD Identifer Length: 16
> [  243.355569] T10 VPD Identifier Association: addressed logical unit
> [  243.356304] T10 VPD Identifier Type: NAA
> [  243.356904] T10 VPD Binary Device Identifier:
> 3600140566e418b4e9ab11dd8f51000c2 [  243.358048] T10 VPD Identifer Length:
> 48
> [  243.358649] T10 VPD Identifier Association: addressed logical unit
> [  243.359351] T10 VPD Identifier Type: T10 Vendor ID based
> [  243.360007] T10 VPD ASCII Device Identifier: LIO-ORG
> [  243.360730] CORE_FILE[0] - Added LIO FILEIO Device ID: 0 at /tmp/fileio,
> 134217728 total bytes [  243.361913] Target_Core_ConfigFS: Registered
> se_dev->se_dev_ptr: ffff880037943c00 [  243.364168] Target_Core_ConfigFS:
> REGISTER -> group: ffffffffa02a0180 name: iscsi [  243.446323]
> Linux-iSCSI.org iSCSI Target Core Stack v3.0.0 on Linux/x86_64 on 2.6.29.2
> [  243.447405] <<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API
> >>>>>>>>>>>>>>>>>>>>>> [  243.448132] Initialized struct
> target_fabric_configfs: ffff88006b554000 for iscsi [  243.449150]
> <<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>>>>>> [  243.449919]
> LIO_TARGET[0] - Set fabric -> lio_target_fabric_configfs [  243.451519]
> iscsi_allocate_thread_sets:195: ***OPS*** Spawned 4 thread set(s) (8 total
> threads). [  243.452909] TARGET_CORE[iSCSI]: Allocated Discovery
> se_portal_group_t for endpoint: None, Portal Tag: 0 [  243.454075] CORE[0]
> - Allocated Discovery TPG
> [  243.454698] Loading Complete.
> [  243.455569] Target_Core_ConfigFS: REGISTER -> Located fabric: iscsi
> [  243.456279] Target_Core_ConfigFS: REGISTER -> ffffffffa02ddbb0
> [  243.456959] Target_Core_ConfigFS: REGISTER -> Allocated Fabric: iscsi
> [  243.457695] Target_Core_ConfigFS: REGISTER -> Set tf->tf_fabric for
> iscsi [  243.458610] lio_target_call_coreaddtiqn(): name:
> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6 [ 
> 243.459839] CORE[0] - Added iSCSI Target IQN:
> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6 [ 
> 243.461031] LIO_Target_ConfigFS: REGISTER ->
> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6 [ 
> 243.462213] LIO_Target_ConfigFS: REGISTER -> Allocated Node:
> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6 [ 
> 243.463621] lio_target_tiqn_addtpg() called: name tpgt_1
> [  243.464283] lio_target_tiqn_addtpg() parent name:
> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6 [ 
> 243.465439] lio_target_tiqn_addtpg() Using TPGT: 1
> [  243.466206] TARGET_CORE[iSCSI]: Allocated Normal se_portal_group_t for
> endpoint: iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6,
> Portal Tag: 1 [  243.467824]
> CORE[iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6]_TPG[
>1] - Added iSCSI Target Portal Group [  243.469018] LIO_Target_ConfigFS:
> REGISTER ->
> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6 [ 
> 243.536626] LIO_Target_ConfigFS: REGISTER -> Allocated TPG: tpgt_1 [ 
> 243.537704] LIO_Target_ConfigFS: REGISTER ->
> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6 TPGT: 1
> PORTAL: 192.168.0.117:3260 [  243.539129] CORE[0] - Added Network Portal:
> 192.168.0.117:3260 on TCP on network device: None [  243.540238]
> CORE[iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6] -
> Added Network Portal: 192.168.0.117:3260,1 on TCP on network device: None [
>  243.541925]
> CORE[iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6]_TPG[
>1] - Incremented np_exports to 1 [  243.543104] LIO_Target_ConfigFS:
> addnptotpg done!
> [  243.649897] SCTP: Hash tables configured (established 65536 bind 65536)
> [  243.704216] CORE[0] - Added Network Portal: 192.168.0.117:3260 on SCTP
> on network device: None [  243.733493]
> CORE[iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6] -
> Added Network Portal: 192.168.0.117:3260,1 on SCTP on network device: None
> [  243.735142]
> CORE[iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6]_TPG[
>1] - Incremented np_exports to 1 [  243.737456] LIO_Target_ConfigFS:
> REGISTER ->
> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6 TPGT: 1
> LUN: 0 [  243.739831] rd_dr/iSCSI: Adding to default ALUA Target Port
> Group: core/alua/tg_pt_gps/default_tg_pt_gp [  243.740953]
> iSCSI_TPG[1]_LUN[0] - Activated iSCSI Logical Unit from CORE HBA: 2 [ 
> 243.742029] LIO_Target_ConfigFS: Created Port Symlink ramdisk -> lun_0 [ 
> 243.744038] LIO_Target_ConfigFS: REGISTER ->
> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6 TPGT: 1
> LUN: 1 [  243.746304] rd_dr/iSCSI: Adding to default ALUA Target Port
> Group: core/alua/tg_pt_gps/default_tg_pt_gp [  243.747436]
> iSCSI_TPG[1]_LUN[1] - Activated iSCSI Logical Unit from CORE HBA: 3 [ 
> 243.748468] LIO_Target_ConfigFS: Created Port Symlink ramdisk -> lun_1 [ 
> 243.750509] LIO_Target_ConfigFS: REGISTER ->
> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6 TPGT: 1
> LUN: 2 [  243.752754] fileio/iSCSI: Adding to default ALUA Target Port
> Group: core/alua/tg_pt_gps/default_tg_pt_gp [  243.753924]
> iSCSI_TPG[1]_LUN[2] - Activated iSCSI Logical Unit from CORE HBA: 4 [ 
> 243.754957] LIO_Target_ConfigFS: Created Port Symlink fileio -> lun_2 [ 
> 243.757089] LIO_Target_ConfigFS: REGISTER ->
> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6 TPGT: 1
> LUN: 3 [  243.759370] iblock/iSCSI: Adding to default ALUA Target Port
> Group: core/alua/tg_pt_gps/default_tg_pt_gp [  243.760507]
> iSCSI_TPG[1]_LUN[3] - Activated iSCSI Logical Unit from CORE HBA: 0 [ 
> 243.761525] LIO_Target_ConfigFS: Created Port Symlink ssd_test0 -> lun_3 [ 
> 243.762761] Disabling iSCSI Authentication Methods for TPG: 1.
> [  243.763566] iSCSI_TPG[1] - Generate Initiator Portal Group ACLs: Enabled
> [  243.764414] iSCSI_TPG[1] - Demo Mode Write Protect bit: OFF
> [  243.765196] iSCSI_TPG[1] - Set Default CmdSN TCQ Depth to 4
> [  243.832368] iSCSI_TPG[1] - Enabled iSCSI Target Portal Group
> [  244.173472] Received iSCSI login request from 192.168.0.116 on TCP
> Network Portal 192.168.0.117:3260 [  244.174664] Located Storage Object:
> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6 [ 
> 244.175776] Located Portal Group Object: 1
> [  244.176405] TARGET_CORE[iSCSI]->TPG[1]_LUN[0] - Adding READ-WRITE access
> for LUN in Demo Mode [  244.177423] TARGET_CORE[iSCSI]->TPG[1]_LUN[1] -
> Adding READ-WRITE access for LUN in Demo Mode [  244.178656]
> TARGET_CORE[iSCSI]->TPG[1]_LUN[2] - Adding READ-WRITE access for LUN in
> Demo Mode [  244.179756] TARGET_CORE[iSCSI]->TPG[1]_LUN[3] - Adding
> READ-WRITE access for LUN in Demo Mode [  244.180854] iSCSI_TPG[1] - Added
> DYNAMIC ACL with TCQ Depth: 4 for iSCSI Initiator Node:
> iqn.1993-08.org.debian:01.2fed72c26a4c [  244.182213]
> ------------------------------------------------------------------ [ 
> 244.183240] HeaderDigest:                 None
> [  244.183860] DataDigest:                   None
> [  244.184479] MaxRecvDataSegmentLength:     131072
> [  244.185099] IFMarker:                     No
> [  244.185779] OFMarker:                     No
> [  244.186394]
> ------------------------------------------------------------------ [ 
> 244.187422]
> ------------------------------------------------------------------ [ 
> 244.188435] MaxConnections:               1
> [  244.189056] TargetName:                  
> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6 [ 
> 244.191890] InitiatorName:               
> iqn.1993-08.org.debian:01.2fed72c26a4c [  244.192934] TargetAlias:         
>         LIO Target
> [  244.193622] InitiatorAlias:               subjekt
> [  244.194272] TargetPortalGroupTag:         1
> [  244.194878] InitialR2T:                   Yes
> [  244.195485] ImmediateData:                Yes
> [  244.196107] MaxBurstLength:               262144
> [  244.196741] FirstBurstLength:             65536
> [  244.197356] DefaultTime2Wait:             2
> [  244.198038] DefaultTime2Retain:           0
> [  244.198648] MaxOutstandingR2T:            1
> [  244.199266] DataPDUInOrder:               Yes
> [  244.199883] DataSequenceInOrder:          Yes
> [  244.200499] ErrorRecoveryLevel:           0
> [  244.201115] SessionType:                  Normal
> [  244.201812]
> ------------------------------------------------------------------ [ 
> 244.202838] TARGET_CORE[iSCSI]: Registered fabric_sess_ptr:
> ffff88006b597e00 [  244.203564] iSCSI Login successful on CID: 0 from
> 192.168.0.116 to 192.168.0.117:3260,1 [  244.204621] Incremented iSCSI
> Connection count to 1 from node: iqn.1993-08.org.debian:01.2fed72c26a4c [ 
> 244.205800] Established iSCSI session from node:
> iqn.1993-08.org.debian:01.2fed72c26a4c [  244.238865] Incremented number of
> active iSCSI sessions to 1 on iSCSI Target Portal Group: 1 [  247.041588]
> eth1_rename: no IPv6 routers present
> [  248.739907] Received iSCSI login request from 192.168.0.111 on TCP
> Network Portal 192.168.0.117:3260 [  248.742799] Located Storage Object:
> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6 [ 
> 248.743981] Located Portal Group Object: 1
> [  248.744635] TARGET_CORE[iSCSI]->TPG[1]_LUN[0] - Adding READ-WRITE access
> for LUN in Demo Mode [  248.745818] TARGET_CORE[iSCSI]->TPG[1]_LUN[1] -
> Adding READ-WRITE access for LUN in Demo Mode [  248.746927]
> TARGET_CORE[iSCSI]->TPG[1]_LUN[2] - Adding READ-WRITE access for LUN in
> Demo Mode [  248.748017] TARGET_CORE[iSCSI]->TPG[1]_LUN[3] - Adding
> READ-WRITE access for LUN in Demo Mode [  248.749122] iSCSI_TPG[1] - Added
> DYNAMIC ACL with TCQ Depth: 4 for iSCSI Initiator Node:
> iqn.1993-08.org.debian:01:2dadf92d0ef [  248.750565]
> ------------------------------------------------------------------ [ 
> 248.751597] HeaderDigest:                 None
> [  248.752230] DataDigest:                   None
> [  248.752861] MaxRecvDataSegmentLength:     131072
> [  248.753543] IFMarker:                     No
> [  248.754171] OFMarker:                     No
> [  248.754785]
> ------------------------------------------------------------------ [ 
> 248.755822]
> ------------------------------------------------------------------ [ 
> 248.756853] MaxConnections:               1
> [  248.757510] TargetName:                  
> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6 [ 
> 248.758690] InitiatorName:               
> iqn.1993-08.org.debian:01:2dadf92d0ef [  248.759742] TargetAlias:          
>        LIO Target
> [  248.760397] InitiatorAlias:               ubuntu
> [  248.761034] TargetPortalGroupTag:         1
> [  248.761731] InitialR2T:                   Yes
> [  248.762352] ImmediateData:                Yes
> [  248.762972] MaxBurstLength:               262144
> [  248.763604] FirstBurstLength:             65536
> [  248.764233] DefaultTime2Wait:             2
> [  248.764844] DefaultTime2Retain:           0
> [  248.765453] MaxOutstandingR2T:            1
> [  248.767078] DataPDUInOrder:               Yes
> [  248.767698] DataSequenceInOrder:          Yes
> [  248.768319] ErrorRecoveryLevel:           0
> [  248.768926] SessionType:                  Normal
> [  248.769681]
> ------------------------------------------------------------------ [ 
> 248.770703] TARGET_CORE[iSCSI]: Registered fabric_sess_ptr:
> ffff88006b597000 [  248.771412] iSCSI Login successful on CID: 0 from
> 192.168.0.111 to 192.168.0.117:3260,1 [  248.772470] Incremented iSCSI
> Connection count to 1 from node: iqn.1993-08.org.debian:01:2dadf92d0ef [ 
> 248.773644] Established iSCSI session from node:
> iqn.1993-08.org.debian:01:2dadf92d0ef [  248.774694] Incremented number of
> active iSCSI sessions to 2 on iSCSI Target Portal Group: 1


