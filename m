From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Bugme-new] [Bug 10226] New: BusLogic Flashpoint SCSI Adapter
 not working with x86_64 kernels
Date: Wed, 12 Mar 2008 13:03:17 +0200
Message-ID: <47D7B875.4020606@panasas.com>
References: <bug-10226-10286@http.bugzilla.kernel.org/> <20080311134440.fb1609cb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:2211 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750925AbYCLLEX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2008 07:04:23 -0400
In-Reply-To: <20080311134440.fb1609cb.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, us-@gmx.de

On Tue, Mar 11 2008 at 22:44 +0200, Andrew Morton <akpm@linux-foundation.org> wrote:
> I thought that scsi-related bugzilla reports were being autosent to
> linux-scsi but afacit that isn't working.  Is it supposed to be?
> 
> Anyway, have a bug!  We don't appear to have a buslogic maintainer?
> 
> On Tue, 11 Mar 2008 13:24:49 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> 
>> http://bugzilla.kernel.org/show_bug.cgi?id=10226
>>
>>            Summary: BusLogic Flashpoint SCSI Adapter not working with x86_64
>>                     kernels
>>            Product: SCSI Drivers
>>            Version: 2.5
>>      KernelVersion: 2.6.24.3
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: BUSLOGIC
>>         AssignedTo: scsi_drivers-buslogic@kernel-bugs.osdl.org
>>         ReportedBy: us-@gmx.de
>>
>>
>> Latest working kernel version: unknown
>>
>> Earliest failing kernel version: unknown (but 2.6.18 fails, too)
>>
>> Distribution: Debian Etch
>>
>> Hardware Environment: BusLogic Flashpoint BT-950 UW-SCSI on ASUS M2NPV-VM with
>> Athlon64 Brisbane
>>
>> Software Environment: Minimal Debian installation (just the netinstall image
>> plus build environment to be able to build the kernel)
>>
>> Problem Description:
>> BusLogic Flashpoint Adapter doesn't work with kernels compiled for x86_64.
>> 'dmesg' shows
>>
>> BusLogic: FlashPoint Host Adapter detected at PCI Bus 4 Device 8
>> BusLogic: I/O Address 0xCC00 PCI Address 0xFDBFE000, irq 16, but FlashPoint
>> BusLogic: support was omitted in this kernel configuration.
>>
>> even though CONFIG_SCSI_OMIT_FLASHPOINT was not set.
>> The SCSi Adapter works fine with a kernel compiled with the same configuration
>> for i686. 'dmesg' in that case shows 
>>
>> SCSI subsystem initialized
>> ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
>> ACPI: PCI Interrupt 0000:04:08.0[A] -> Link [APC1] -> GSI 16 (level, low) ->
>> IRQ
>>  18
>> scsi: ***** BusLogic SCSI Driver Version 2.1.16 of 18 July 2002 *****
>> scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
>> scsi0: Configuring BusLogic Model BT-950 PCI Wide Ultra SCSI Host Adapter
>> scsi0:   Firmware Version: 5.02, I/O Address: 0xCC00, IRQ Channel: 18/Level
>> scsi0:   PCI Bus: 4, Device: 8, Address: 0xFDBFE000, Host Adapter SCSI ID: 7
>> scsi0:   Parity Checking: Enabled, Extended Translation: Enabled
>> scsi0:   Synchronous Negotiation: FSFFFFN#FFFFFFFF, Wide Negotiation: Enabled
>> scsi0:   Disconnect/Reconnect: Enabled, Tagged Queuing: Enabled
>> scsi0:   Driver Queue Depth: 255, Scatter/Gather Limit: 128 segments
>> scsi0:   Tagged Queue Depth: Automatic, Untagged Queue Depth: 3
>> scsi0:   SCSI Bus Termination: High Enabled, SCAM: Disabled
>> scsi0: *** BusLogic BT-950 Initialized Successfully ***
>> scsi0 : BusLogic BT-950
>>
>> Steps to reproduce:
>> Try using a Buslogic Flashpoint SCSI Adapter on a kernel built for x86_64.
>>
>> Additional info:
>> 'lspci' shows
>> 04:08.0 SCSI storage controller: BusLogic Flashpoint LT (rev 01)
>>
>> The .config was pretty much what I got by calling 'make menuconfig' in a virgin
>> kernel source tree. 
>>
>> The complete 'dmesg' output is:
>> Linux version 2.6.24.3-64bit (root@speddo) (gcc version 4.1.2 20061115
>> (prerelease) (Debian 4.1.1-21)) #2 SMP Tue Mar 11 19:54:11 CET 2008
>> Command line: root=/dev/hda13 ro
>> BIOS-provided physical RAM map:
>>  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
>>  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
>>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>>  BIOS-e820: 0000000000100000 - 00000000cdee0000 (usable)
>>  BIOS-e820: 00000000cdee0000 - 00000000cdee3000 (ACPI NVS)
>>  BIOS-e820: 00000000cdee3000 - 00000000cdef0000 (ACPI data)
>>  BIOS-e820: 00000000cdef0000 - 00000000cdf00000 (reserved)
>>  BIOS-e820: 00000000ce000000 - 00000000d0000000 (reserved)
>>  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>>  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
>>  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
>> Entering add_active_range(0, 0, 159) 0 entries of 3200 used
>> Entering add_active_range(0, 256, 843488) 1 entries of 3200 used
>> Entering add_active_range(0, 1048576, 1245184) 2 entries of 3200 used
>> end_pfn_map = 1245184
>> DMI 2.4 present.
>> ACPI: RSDP 000F7530, 0024 (r2 Nvidia)
>> ACPI: XSDT CDEE30C0, 004C (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
>> ACPI: FACP CDEEB4C0, 00F4 (r3 Nvidia ASUSACPI 42302E31 AWRD        0)
>> ACPI: DSDT CDEE3240, 821D (r1 NVIDIA ASUSACPI     1000 MSFT  3000000)
>> ACPI: FACS CDEE0000, 0040
>> ACPI: SSDT CDEEB6C0, 0206 (r1 PTLTD  POWERNOW        1  LTP        1)
>> ACPI: HPET CDEEB940, 0038 (r1 Nvidia ASUSACPI 42302E31 AWRD       98)
>> ACPI: MCFG CDEEB9C0, 003C (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
>> ACPI: APIC CDEEB600, 007C (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
>> Scanning NUMA topology in Northbridge 24
>> CPU has 2 num_cores
>> No NUMA configuration found
>> Faking a node at 0000000000000000-0000000130000000
>> Entering add_active_range(0, 0, 159) 0 entries of 3200 used
>> Entering add_active_range(0, 256, 843488) 1 entries of 3200 used
>> Entering add_active_range(0, 1048576, 1245184) 2 entries of 3200 used
>> Bootmem setup node 0 0000000000000000-0000000130000000
>> Zone PFN ranges:
>>   DMA             0 ->     4096
>>   DMA32        4096 ->  1048576
>>   Normal    1048576 ->  1245184
>> Movable zone start PFN for each node
>> early_node_map[3] active PFN ranges
>>     0:        0 ->      159
>>     0:      256 ->   843488
>>     0:  1048576 ->  1245184
>> On node 0 totalpages: 1039999
>>   DMA zone: 56 pages used for memmap
>>   DMA zone: 1022 pages reserved
>>   DMA zone: 2921 pages, LIFO batch:0
>>   DMA32 zone: 14280 pages used for memmap
>>   DMA32 zone: 825112 pages, LIFO batch:31
>>   Normal zone: 2688 pages used for memmap
>>   Normal zone: 193920 pages, LIFO batch:31
>>   Movable zone: 0 pages used for memmap
>> ACPI: PM-Timer IO Port: 0x4008
>> ACPI: Local APIC address 0xfee00000
>> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
>> Processor #0 (Bootup-CPU)
>> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
>> Processor #1
>> ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
>> ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
>> ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
>> IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
>> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
>> ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
>> ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
>> ACPI: IRQ0 used by override.
>> ACPI: IRQ2 used by override.
>> ACPI: IRQ9 used by override.
>> ACPI: IRQ14 used by override.
>> ACPI: IRQ15 used by override.
>> Setting APIC routing to flat
>> ACPI: HPET id: 0x10de8201 base: 0xfefff000
>> Using ACPI (MADT) for SMP configuration information
>> Allocating PCI resources starting at d1000000 (gap: d0000000:10000000)
>> SMP: Allowing 2 CPUs, 0 hotplug CPUs
>> PERCPU: Allocating 33120 bytes of per cpu data
>> Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1021953
>> Policy zone: Normal
>> Kernel command line: root=/dev/hda13 ro
>> Initializing CPU#0
>> PID hash table entries: 4096 (order: 12, 32768 bytes)
>> Extended CMOS year: 2000
>> hpet clockevent registered
>> TSC calibrated against HPET
>> Marking TSC unstable due to TSCs unsynchronized
>> time.c: Detected 2104.387 MHz processor.
>> Console: colour VGA+ 80x25
>> console [tty0] enabled
>> Checking aperture...
>> CPU 0: aperture @ 4ea6000000 size 32 MB
>> Aperture too small (32 MB)
>> No AGP bridge found
>> Your BIOS doesn't leave a aperture memory hole
>> Please enable the IOMMU option in the BIOS setup
>> This costs you 64 MB of RAM
>> Mapping aperture over 65536 KB of RAM @ 4000000
>> Memory: 4020884k/4980736k available (2086k kernel code, 139112k reserved, 999k
>> data, 312k init)
>> Calibrating delay using timer specific routine.. 4212.28 BogoMIPS (lpj=8424572)
>> Security Framework initialized
>> SELinux:  Disabled at boot.
>> Capability LSM initialized
>> Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
>> Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
>> Mount-cache hash table entries: 256
>> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
>> CPU: L2 Cache: 512K (64 bytes/line)
>> CPU 0/0 -> Node 0
>> CPU: Physical Processor ID: 0
>> CPU: Processor Core ID: 0
>> SMP alternatives: switching to UP code
>> ACPI: Core revision 20070126
>> Using local APIC timer interrupts.
>> APIC timer calibration result 12526131
>> Detected 12.526 MHz APIC timer.
>> SMP alternatives: switching to SMP code
>> Booting processor 1/2 APIC 0x1
>> Initializing CPU#1
>> Calibrating delay using timer specific routine.. 4208.81 BogoMIPS (lpj=8417631)
>> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
>> CPU: L2 Cache: 512K (64 bytes/line)
>> CPU 1/1 -> Node 0
>> CPU: Physical Processor ID: 0
>> CPU: Processor Core ID: 1
>> AMD Athlon(tm) 64 X2 Dual Core Processor 4000+ stepping 01
>> Brought up 2 CPUs
>> CPU0 attaching sched-domain:
>>  domain 0: span 00000003
>>   groups: 00000001 00000002
>>   domain 1: span 00000003
>>    groups: 00000003
>> CPU1 attaching sched-domain:
>>  domain 0: span 00000003
>>   groups: 00000002 00000001
>>   domain 1: span 00000003
>>    groups: 00000003
>> net_namespace: 120 bytes
>> NET: Registered protocol family 16
>> ACPI: bus type pci registered
>> PCI: Using MMCONFIG at e0000000 - efffffff
>> PCI: No mmconfig possible on device 00:18
>> ACPI: EC: Look up EC in DSDT
>> ACPI: Interpreter enabled
>> ACPI: (supports S0 S1 S3 S5)
>> ACPI: Using IOAPIC for interrupt routing
>> ACPI: PCI Root Bridge [PCI0] (0000:00)
>> PCI: Transparent bridge - 0000:00:10.0
>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
>> ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 *11 14 15)
>> ACPI: PCI Interrupt Link [LNK2] (IRQs *5 7 9 10 11 14 15)
>> ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled.
>> ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
>> ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
>> ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 10 11 14 15) *0, disabled.
>> ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 *10 11 14 15)
>> ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
>> ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 10 11 14 15) *0, disabled.
>> ACPI: PCI Interrupt Link [LUBB] (IRQs 5 7 9 10 11 14 15) *0, disabled.
>> ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 10 *11 14 15)
>> ACPI: PCI Interrupt Link [LACI] (IRQs 5 7 9 10 11 14 15) *0, disabled.
>> ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 10 *11 14 15)
>> ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
>> ACPI: PCI Interrupt Link [LMCI] (IRQs 5 7 9 10 11 14 15) *0, disabled.
>> ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 10 11 14 15) *0, disabled.
>> ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
>> ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
>> ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 10 11 14 15) *0, disabled.
>> ACPI: PCI Interrupt Link [LFID] (IRQs 5 7 9 10 11 14 15) *0, disabled.
>> ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0
>> ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
>> ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
>> ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
>> ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
>> ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0, disabled.
>> ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0
>> ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
>> ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
>> ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
>> ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
>> ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0, disabled.
>> ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
>> ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
>> ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
>> ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
>> ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
>> ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
>> ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
>> ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
>> ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
>> Linux Plug and Play Support v0.97 (c) Adam Belay
>> pnp: PnP ACPI init
>> ACPI: bus type pnp registered
>> pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
>> pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
>> pnp 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
>> pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
>> pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
>> pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
>> pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
>> pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
>> pnp 00:08: Plug and Play ACPI device, IDs PNP0700 (active)
>> pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
>> pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
>> pnp 00:0b: Plug and Play ACPI device, IDs PNP0400 (active)
>> pnp 00:0c: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
>> pnp 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
>> pnpacpi: exceeded the max number of mem resources: 12
>> pnp 00:0e: Plug and Play ACPI device, IDs PNP0c01 (active)
>> pnp: PnP ACPI: found 15 devices
>> ACPI: ACPI bus type pnp unregistered
>> usbcore: registered new interface driver usbfs
>> usbcore: registered new interface driver hub
>> usbcore: registered new device driver usb
>> PCI: Using ACPI for IRQ routing
>> PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
>> NET: Registered protocol family 8
>> NET: Registered protocol family 20
>> PCI-DMA: Disabling AGP.
>> PCI-DMA: aperture base @ 4000000 size 65536 KB
>> PCI-DMA: using GART IOMMU.
>> PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
>> hpet0: at MMIO 0xfefff000, IRQs 2, 8, 31
>> hpet0: 3 32-bit timers, 25000000 Hz
>> Time: hpet clocksource has been installed.
>> pnp: the driver 'system' has been registered
>> system 00:01: ioport range 0x4000-0x407f has been reserved
>> system 00:01: ioport range 0x4080-0x40ff has been reserved
>> system 00:01: ioport range 0x4400-0x447f has been reserved
>> system 00:01: ioport range 0x4480-0x44ff has been reserved
>> system 00:01: ioport range 0x4800-0x487f has been reserved
>> system 00:01: ioport range 0x4880-0x48ff has been reserved
>> system 00:01: ioport range 0x2000-0x207f has been reserved
>> system 00:01: ioport range 0x2080-0x20ff has been reserved
>> system 00:01: iomem range 0xce000000-0xcfffffff could not be reserved
>> system 00:01: driver attached
>> system 00:02: ioport range 0x4d0-0x4d1 has been reserved
>> system 00:02: ioport range 0x800-0x87f has been reserved
>> system 00:02: ioport range 0x290-0x297 has been reserved
>> system 00:02: driver attached
>> system 00:0d: iomem range 0xe0000000-0xefffffff could not be reserved
>> system 00:0d: driver attached
>> system 00:0e: iomem range 0xd3800-0xd3fff has been reserved
>> system 00:0e: iomem range 0xf0000-0xf7fff could not be reserved
>> system 00:0e: iomem range 0xf8000-0xfbfff could not be reserved
>> system 00:0e: iomem range 0xfc000-0xfffff could not be reserved
>> system 00:0e: iomem range 0xfefff000-0xfefff0ff has been reserved
>> system 00:0e: iomem range 0xcdee0000-0xcdefffff could not be reserved
>> system 00:0e: iomem range 0xffff0000-0xffffffff has been reserved
>> system 00:0e: iomem range 0x0-0x9ffff could not be reserved
>> system 00:0e: iomem range 0x100000-0xcdedffff could not be reserved
>> system 00:0e: iomem range 0xcdef0000-0xcfeeffff could not be reserved
>> system 00:0e: iomem range 0xfec00000-0xfec00fff has been reserved
>> system 00:0e: iomem range 0xfee00000-0xfeefffff could not be reserved
>> system 00:0e: driver attached
>> PCI: Bridge: 0000:00:02.0
>>   IO window: b000-bfff
>>   MEM window: fde00000-fdefffff
>>   PREFETCH window: fdd00000-fddfffff
>> PCI: Bridge: 0000:00:03.0
>>   IO window: e000-efff
>>   MEM window: fdc00000-fdcfffff
>>   PREFETCH window: fd900000-fd9fffff
>> PCI: Bridge: 0000:00:04.0
>>   IO window: d000-dfff
>>   MEM window: fd800000-fd8fffff
>>   PREFETCH window: fd700000-fd7fffff
>> PCI: Bridge: 0000:00:10.0
>>   IO window: c000-cfff
>>   MEM window: fdb00000-fdbfffff
>>   PREFETCH window: fda00000-fdafffff
>> PCI: Setting latency timer of device 0000:00:02.0 to 64
>> PCI: Setting latency timer of device 0000:00:03.0 to 64
>> PCI: Setting latency timer of device 0000:00:04.0 to 64
>> PCI: Setting latency timer of device 0000:00:10.0 to 64
>> NET: Registered protocol family 2
>> IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
>> TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
>> TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
>> TCP: Hash tables configured (established 524288 bind 65536)
>> TCP reno registered
>> checking if image is initramfs... it is
>> Freeing initrd memory: 1116k freed
>> audit: initializing netlink socket (disabled)
>> audit(1205268115.600:1): initialized
>> VFS: Disk quotas dquot_6.5.1
>> Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
>> io scheduler noop registered
>> io scheduler anticipatory registered
>> io scheduler deadline registered
>> io scheduler cfq registered (default)
>> Boot video device is 0000:00:05.0
>> PCI: Setting latency timer of device 0000:00:02.0 to 64
>> assign_interrupt_mode Found MSI capability
>> Allocate Port Service[0000:00:02.0:pcie00]
>> Allocate Port Service[0000:00:02.0:pcie03]
>> PCI: Setting latency timer of device 0000:00:03.0 to 64
>> assign_interrupt_mode Found MSI capability
>> Allocate Port Service[0000:00:03.0:pcie00]
>> Allocate Port Service[0000:00:03.0:pcie03]
>> PCI: Setting latency timer of device 0000:00:04.0 to 64
>> assign_interrupt_mode Found MSI capability
>> Allocate Port Service[0000:00:04.0:pcie00]
>> Allocate Port Service[0000:00:04.0:pcie03]
>> Real Time Clock Driver v1.12ac
>> hpet_resources: 0xfefff000 is busy
>> Linux agpgart interface v0.102
>> Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
>> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>> serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
>> pnp: the driver 'serial' has been registered
>> 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>> serial 00:09: driver attached
>> 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
>> serial 00:0a: driver attached
>> RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
>> pnp: the driver 'i8042 kbd' has been registered
>> i8042 kbd 00:0c: driver attached
>> pnp: the driver 'i8042 aux' has been registered
>> PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
>> PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot
>> with i8042.nopnp
>> serio: i8042 KBD port at 0x60,0x64 irq 1
>> mice: PS/2 mouse device common for all mice
>> TCP bic registered
>> NET: Registered protocol family 1
>> NET: Registered protocol family 17
>> Freeing unused kernel memory: 312k freed
>> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
>> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
>> NFORCE-MCP51: IDE controller (0x10de:0x0265 rev 0xa1) at  PCI slot 0000:00:0d.0
>> NFORCE-MCP51: not 100% native mode: will probe irqs later
>> NFORCE-MCP51: BIOS didn't set cable bits correctly. Enabling workaround.
>> NFORCE-MCP51: 0000:00:0d.0 (rev a1) UDMA133 controller
>>     ide0: BM-DMA at 0xf400-0xf407, BIOS settings: hda:DMA, hdb:DMA
>>     ide1: BM-DMA at 0xf408-0xf40f, BIOS settings: hdc:DMA, hdd:DMA
>> Probing IDE interface ide0...
>> input: AT Translated Set 2 keyboard as /class/input/input0
>> hdb: HDS722516VLAT80, ATA DISK drive
>> hda: SAMSUNG SP2514N, ATA DISK drive
>> hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
>> hda: UDMA/100 mode selected
>> hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
>> hdb: UDMA/100 mode selected
>> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
>> Probing IDE interface ide1...
>> hdc: PIONEER DVD-RW DVR-109, ATAPI CD/DVD-ROM drive
>> hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
>> hdc: UDMA/66 mode selected
>> ide1 at 0x170-0x177,0x376 on irq 15
>> hda: max request size: 512KiB
>> hda: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=30401/255/63
>> hda: cache flushes supported
>>  hda: hda1 hda2 < hda5 hda6 hda7 hda8 hda9 hda10 hda11 hda12 hda13 >
>> hdb: max request size: 512KiB
>> hdb: 321672960 sectors (164696 MB) w/7938KiB Cache, CHS=20023/255/63
>> hdb: cache flushes supported
>>  hdb: hdb1 hdb2
>> kjournald starting.  Commit interval 5 seconds
>> EXT3-fs: mounted filesystem with ordered data mode.
>> input: Power Button (FF) as /class/input/input1
>> ACPI: Power Button (FF) [PWRF]
>> input: Power Button (CM) as /class/input/input2
>> ACPI: Power Button (CM) [PWRB]
>> ACPI: Thermal Zone [THRM] (40 C)
>> input: PC Speaker as /class/input/input3
>> ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
>> ACPI: PCI Interrupt Link [APCF] enabled at IRQ 23
>> ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [APCF] -> GSI 23 (level, low) ->
>> IRQ 23
>> PCI: Setting latency timer of device 0000:00:0b.0 to 64
>> ohci_hcd 0000:00:0b.0: OHCI Host Controller
>> ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus number 1
>> ohci_hcd 0000:00:0b.0: irq 23, io mem 0xfe02f000
>> usb usb1: configuration #1 chosen from 1 choice
>> hub 1-0:1.0: USB hub found
>> hub 1-0:1.0: 8 ports detected
>> SCSI subsystem initialized
>> ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
>> ACPI: PCI Interrupt 0000:04:08.0[A] -> Link [APC1] -> GSI 16 (level, low) ->
>> IRQ 16
>> BusLogic: FlashPoint Host Adapter detected at PCI Bus 4 Device 8
>> BusLogic: I/O Address 0xCC00 PCI Address 0xFDBFE000, irq 16, but FlashPoint
>> BusLogic: support was omitted in this kernel configuration.
>> Floppy drive(s): fd0 is 1.44M
>> pnp: the driver 'parport_pc' has been registered
>> parport_pc 00:0b: reported by Plug and Play ACPI
>> parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
>> FDC 0 is a post-1991 82077
>> ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
>> ACPI: PCI Interrupt 0000:00:0b.1[B] -> Link [APCL] -> GSI 22 (level, low) ->
>> IRQ 22
>> PCI: Setting latency timer of device 0000:00:0b.1 to 64
>> ehci_hcd 0000:00:0b.1: EHCI Host Controller
>> ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus number 2
>> ehci_hcd 0000:00:0b.1: debug port 1
>> PCI: cache line size of 64 is not supported by device 0000:00:0b.1
>> ehci_hcd 0000:00:0b.1: irq 22, io mem 0xfe02e000
>> ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
>> usb usb2: configuration #1 chosen from 1 choice
>> hub 2-0:1.0: USB hub found
>> hub 2-0:1.0: 8 ports detected
>> ACPI: Fan [FAN] (on)
>> hdc: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2000kB Cache
>> Uniform CD-ROM driver Revision: 3.20
>> parport_pc 00:0b: driver attached
>> i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
>> i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
>> ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
>> ACPI: PCI Interrupt 0000:04:05.0[A] -> Link [APC4] -> GSI 19 (level, low) ->
>> IRQ 19
>> gameport: EMU10K1 is pci0000:04:09.1/gameport0, io 0xc400, speed 1037kHz
>> ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[fdbff000-fdbff7ff] 
>> Max Packet=[2048]  IR/IT contexts=[4/8]
>> forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
>> ACPI: PCI Interrupt Link [APCH] enabled at IRQ 21
>> ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [APCH] -> GSI 21 (level, low) ->
>> IRQ 21
>> PCI: Setting latency timer of device 0000:00:14.0 to 64
>> forcedeth 0000:00:14.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:1b:fc:9f:66:58
>> forcedeth 0000:00:14.0: highdma pwrctl timirq gbit lnktim desc-v3
>> ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
>> ACPI: PCI Interrupt 0000:04:09.0[A] -> Link [APC2] -> GSI 17 (level, low) ->
>> IRQ 17
>> ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 20
>> ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [AAZA] -> GSI 20 (level, low) ->
>> IRQ 20
>> PCI: Setting latency timer of device 0000:00:10.1 to 64
>> usb 1-2: new low speed USB device using ohci_hcd and address 2
>> usb 1-2: configuration #1 chosen from 1 choice
>> ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d80001557022]
>> usb 1-4: new full speed USB device using ohci_hcd and address 3
>> Adding 1959888k swap on /dev/hda7.  Priority:-1 extents:1 across:1959888k
>> Adding 1004020k swap on /dev/hdb1.  Priority:-2 extents:1 across:1004020k
>> EXT3 FS on hda13, internal journal
>> usb 1-4: configuration #1 chosen from 1 choice
>> usbcore: registered new interface driver hiddev
>> input: Logitech Optical USB Mouse as /class/input/input4
>> input: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:0b.0-2
>> usbcore: registered new interface driver usbhid
>> drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
>> usbcore: registered new interface driver snd-usb-audio
>> loop: module loaded
>> device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised:
>> dm-devel@redhat.com
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
>> device-mapper: ioctl: error adding target to table
>> NET: Registered protocol family 10
>> lo: Disabled Privacy Extensions
>> eth0: no IPv6 routers present
>>
>>
>> -- 
>> Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
>> ------- You are receiving this mail because: -------
>> You are on the CC list for the bug, or are watching someone who is.
> --

An attached config file could help.
It looks like you need ISA_DMA_API && VIRT_TO_BUS enabled are they?

