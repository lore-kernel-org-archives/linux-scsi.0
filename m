From: dann frazier <dannf@hp.com>
Subject: Re: mptsas, msi and the dl585 g2
Date: Thu, 9 Jul 2009 12:59:46 -0600
Message-ID: <20090709185945.GG2613@ldl.fc.hp.com>
References: <20090630180300.GA9971@ldl.fc.hp.com>
 <4A4A5B01.9040200@kernel.org>
 <20090703225708.GA30664@ldl.fc.hp.com>
 <4A4FADDC.30606@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="EVF5PPMfhYS0aIcm"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:5427 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbZGITAK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2009 15:00:10 -0400
Content-Disposition: inline
In-Reply-To: <4A4FADDC.30606@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 04, 2009 at 12:30:36PM -0700, Yinghai Lu wrote:
> dann frazier wrote:
> > On Tue, Jun 30, 2009 at 11:35:45AM -0700, Yinghai Lu wrote:
> >> dann frazier wrote:
> >>> hey,
> >>>  I'm finding problems when booting a dl585g2 w/ an LSISAS1068
> >>> controller. In brief, this system system stopped booting once MSI
> >>> became disabled by default in mptbase. Passing the parameter
> >>> 'mpt_msi_enable_sas=1' to mptbase allows it to work again (tested w/
> >>> 2.6.30).
> >>>
> >>>  The symptom is that the system starts up, and we see the following:
> >>>
> >>> ======== SNIP =========
> >>> [    6.941489] hub 3-2:1.0: USB hub found
> >>> [    6.943705] hub 3-2:1.0: 7 ports detected
> >>> [    6.992639] Copyright (c) 1999-2008 LSI Corporation
> >>> [    7.014262] Fusion MPT SAS Host driver 3.04.07
> >>> [    7.021685] mptsas 0000:42:01.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
> >>> [    7.026597] usb 1-6.3: new full speed USB device using ehci_hcd and address 3
> >>> [    7.071143] mptbase: ioc0: Initiating bringup
> >>> [    7.102198] usb 1-6.3: New USB device found, idVendor=0e34, idProduct=0204
> >>> [    7.119107] usb 1-6.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> >>> [    7.128171] usb 1-6.3: Product: iPort/USB I2C Host Adapter
> >>> [    7.160994] usb 1-6.3: Manufacturer: Silicon Labs
> >>> [    7.171468] usb 1-6.3: SerialNumber: 0001248
> >>> [    7.174931] usb 1-6.3: configuration #1 chosen from 1 choice
> >>> [    7.360010] ioc0: LSISAS1068 B0: Capabilities={Initiator}
> >>> [   40.581020] mptbase: ioc0: Initiating recovery
> >>> [   71.190560] Clocksource tsc unstable (delta = 4398041105588 ns)
> >>> [   81.190160] mptbase: ioc0: Initiating recovery
> >>> ======== SNIP =========
> >>>
> >>> These "Initiating recovery" messages are printed periodically, and the
> >>> system never recovers.
> >> Dann, that could be : ioapic routing in ACPI DSDT is not right somehow.
> >>
> >> please try to move the card to other slot to get some luck.
> >> or pci=routeirq could help too sometimes.
> > 
> > For the record, I tried moving the card to the other PCI-X slot and
> > the pci=routeirq boot param, but neither helped.
> > 
> 
> so 2.6.22.1 works on that system with pci=nomsi?
> 
> maybe your BIOS is too new, you may try the old BIOS.
> 
> updating BIOS is not always a option to deployed systems. maybe sustaining team could break sth.

Back with more info.

Both of the original bisects I did with cciss and mptsas appeared to
land on commits that just masked the issue. e.g., a cciss hang caused
by a bug w/ no logical drives, and mptsas switching toggling the MSI
default.

I tried to avoid these issues by doing another bisect w/ storage
attached to the cciss controller, and landed on this commit:

  --------------------------------------------------------------------
  commit 8d539108560ec121d59eee05160236488266221c
  Author: Linus Torvalds <torvalds@linux-foundation.org>
  Date:   Thu May 8 18:41:48 2008 -0700

      Revert "PCI: remove default PCI expansion ROM memory allocation"

  This reverts commit 9f8daccaa05c14e5643bdd4faf5aed9cc8e6f11e, which
  was  reported to break X startup (xf86-video-ati-6.8.0).
  --------------------------------------------------------------------

>From that, I found that pci=norom avoids the problem. But, again, this
is just a masking commit - things used to work before 9f8dacc was
there.

I did another bisect, this time keeping the norom patches out
entirely. This landed on:

  --------------------------------------------------------------------
  commit 30a18d6c3f1e774de656ebd8ff219d53e2ba4029
  Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
  Date:   Tue Feb 19 03:21:20 2008 -0800

      x86: multi pci root bus with different io resource range, on
      64-bit
  --------------------------------------------------------------------

This appears to be the commit that actually introduced the issue.
I've attached dmesg w/ PCI DEBUG enabled from both sides of this
changeset, as well as a diff w/o printk timestamps.

Also note that #ifdef'ing out x86_pci_root_bus_res_quirks() in
amd_bus.c seems to avoid the problem as well.

-- 
dann frazier


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="pre.dmesg"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.25 (dannf@dl585g2) (gcc version 4.3.2 (Deb=
ian 4.3.2-1.1) ) #68 SMP Thu Jul 9 12:25:31 MDT 2009
[    0.000000] Command line: root=3D/dev/disk/by-id/scsi-35000c50000d5ca0f-=
part1 ro console=3Dtty1 console=3DttyS1,115200=20
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e400 (usable)
[    0.000000]  BIOS-e820: 000000000009e400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fd4e000 (usable)
[    0.000000]  BIOS-e820: 000000007fd4e000 - 000000007fd56000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007fd56000 - 000000007fd57000 (usable)
[    0.000000]  BIOS-e820: 000000007fd57000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000047ffff000 (usable)
[    0.000000] Entering add_active_range(0, 0, 158) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 523598) 1 entries of 3200 =
used
[    0.000000] Entering add_active_range(0, 523606, 523607) 2 entries of 32=
00 used
[    0.000000] Entering add_active_range(0, 1048576, 4718591) 3 entries of =
3200 used
[    0.000000] max_pfn_mapped =3D 4718591
[    0.000000] x86: PAT support disabled.
[    0.000000] init_memory_mapping
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000F4F00, 0024 (r2 HP    )
[    0.000000] ACPI: XSDT 7FD4ED80, 0074 (r1 HP     ProLiant        2   =D2=
=04     162E)
[    0.000000] ACPI: FACP 7FD4EE00, 00F4 (r3 HP     A07             2   =D2=
=04     162E)
[    0.000000] ACPI: DSDT 7FD4EF00, 4A59 (r1 HP         DSDT        1 INTL =
20030228)
[    0.000000] ACPI: FACS 7FD4E100, 0040
[    0.000000] ACPI: SPCR 7FD4E140, 0050 (r1 HP     SPCRRBSU        1   =D2=
=04     162E)
[    0.000000] ACPI: HPET 7FD4E1C0, 0038 (r1 HP     ProLiant        2   =D2=
=04     162E)
[    0.000000] ACPI: SPMI 7FD4E200, 0040 (r5 HP     ProLiant        1   =D2=
=04     162E)
[    0.000000] ACPI: ERST 7FD4E240, 01D0 (r1 HP     ProLiant        1   =D2=
=04     162E)
[    0.000000] ACPI: APIC 7FD4E440, 00C6 (r1 HP     ProLiant        2      =
       0)
[    0.000000] ACPI: SRAT 7FD4E600, 01A0 (r1 AMD    FAM_F_10        2 AMD  =
       1)
[    0.000000] ACPI: FFFF 7FD4EA00, 0176 (r1 HP     ProLiant        1   =D2=
=04     162E)
[    0.000000] ACPI: BERT 7FD4EB80, 0030 (r1 HP     ProLiant        1   =D2=
=04     162E)
[    0.000000] ACPI: HEST 7FD4EBC0, 0170 (r1 HP     ProLiant        1   =D2=
=04     162E)
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 2 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 3 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 4 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 5 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 6 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 7 -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] Entering add_active_range(0, 0, 158) 0 entries of 3200 used
[    0.000000] SRAT: Node 0 PXM 0 100000-80000000
[    0.000000] Entering add_active_range(0, 256, 523598) 1 entries of 3200 =
used
[    0.000000] Entering add_active_range(0, 523606, 523607) 2 entries of 32=
00 used
[    0.000000] SRAT: Node 0 PXM 0 100000000-180000000
[    0.000000] Entering add_active_range(0, 1048576, 1572864) 3 entries of =
3200 used
[    0.000000] SRAT: Node 1 PXM 1 180000000-280000000
[    0.000000] Entering add_active_range(1, 1572864, 2621440) 4 entries of =
3200 used
[    0.000000] SRAT: Node 2 PXM 2 280000000-380000000
[    0.000000] Entering add_active_range(2, 2621440, 3670016) 5 entries of =
3200 used
[    0.000000] SRAT: Node 3 PXM 3 380000000-480000000
[    0.000000] Entering add_active_range(3, 3670016, 4718591) 6 entries of =
3200 used
[    0.000000] NUMA: Allocated memnodemap from 1a000 - 23080
[    0.000000] NUMA: Using 20 for the hash shift.
[    0.000000] Bootmem setup node 0 0000000000000000-0000000180000000
[    0.000000]   NODE_DATA [0000000000023080 - 000000000002b07f]
[    0.000000]   bootmap [000000000002c000 -  000000000005bfff] pages 30
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-a88afb] TEXT DATA BSS
[    0.000000]   early res: 3 [37d54000-37fef2b8] RAMDISK
[    0.000000]   early res: 4 [9e400-fffff] BIOS reserved
[    0.000000]   early res: 5 [8000-19fff] PGTABLE
[    0.000000]   early res: 6 [1a000-2307f] MEMNODEMAP
[    0.000000] Bootmem setup node 1 0000000180000000-0000000280000000
[    0.000000]   NODE_DATA [0000000180000000 - 0000000180007fff]
[    0.000000]   bootmap [0000000180008000 -  0000000180027fff] pages 20
[    0.000000] Bootmem setup node 2 0000000280000000-0000000380000000
[    0.000000]   NODE_DATA [0000000280000000 - 0000000280007fff]
[    0.000000]   bootmap [0000000280008000 -  0000000280027fff] pages 20
[    0.000000] Bootmem setup node 3 0000000380000000-000000047ffff000
[    0.000000]   NODE_DATA [0000000380000000 - 0000000380007fff]
[    0.000000]   bootmap [0000000380008000 -  0000000380027fff] pages 20
[    0.000000]  [ffffe20000000000-ffffe200049fffff] PMD -> [ffff81000120000=
0-ffff810003ffffff] on node 0
[    0.000000]  [ffffe20004a00000-ffffe200053fffff] PMD -> [ffff81000c00000=
0-ffff81000c9fffff] on node 0
[    0.000000]  [ffffe20005400000-ffffe20008bfffff] PMD -> [ffff81018020000=
0-ffff8101839fffff] on node 1
[    0.000000]  [ffffe20008c00000-ffffe2000c3fffff] PMD -> [ffff81028020000=
0-ffff8102839fffff] on node 2
[    0.000000]  [ffffe2000c400000-ffffe2000fbfffff] PMD -> [ffff81038020000=
0-ffff8103839fffff] on node 3
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  4718591
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[7] active PFN ranges
[    0.000000]     0:        0 ->      158
[    0.000000]     0:      256 ->   523598
[    0.000000]     0:   523606 ->   523607
[    0.000000]     0:  1048576 ->  1572864
[    0.000000]     1:  1572864 ->  2621440
[    0.000000]     2:  2621440 ->  3670016
[    0.000000]     3:  3670016 ->  4718591
[    0.000000] On node 0 totalpages: 1047789
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2313 pages reserved
[    0.000000]   DMA zone: 1629 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 505223 pages, LIFO batch:31
[    0.000000]   Normal zone: 7168 pages used for memmap
[    0.000000]   Normal zone: 517120 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] On node 1 totalpages: 1048576
[    0.000000]   DMA zone: 0 pages used for memmap
[    0.000000]   DMA32 zone: 0 pages used for memmap
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1034240 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] On node 2 totalpages: 1048576
[    0.000000]   DMA zone: 0 pages used for memmap
[    0.000000]   DMA32 zone: 0 pages used for memmap
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1034240 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] On node 3 totalpages: 1048575
[    0.000000]   DMA zone: 0 pages used for memmap
[    0.000000]   DMA32 zone: 0 pages used for memmap
[    0.000000]   Normal zone: 14335 pages used for memmap
[    0.000000]   Normal zone: 1034240 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xd9cf0000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 0, address 0xd9cf0000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xd9fd0000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 0, address 0xd9fd0000, GSI 24-=
30
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xd9fe0000] gsi_base[31])
[    0.000000] IOAPIC[2]: apic_id 10, version 0, address 0xd9fe0000, GSI 31=
-37
[    0.000000] ACPI: IOAPIC (id[0x0b] address[0xd9ff0000] gsi_base[38])
[    0.000000] IOAPIC[3]: apic_id 11, version 0, address 0xd9ff0000, GSI 38=
-61
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: NMI_SRC (dfl dfl global_irq 28)
[    0.000000] ACPI: NMI_SRC (dfl dfl global_irq 35)
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10228201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000=
9f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 000000007fd4e000 - 000000007fd=
56000
[    0.000000] PM: Registered nosave memory: 000000007fd57000 - 00000000800=
00000
[    0.000000] PM: Registered nosave memory: 0000000080000000 - 00000000e00=
00000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f00=
00000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec=
00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fed=
00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fee=
00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee=
10000
[    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ffc=
00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 00000001000=
00000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000=
:60000000)
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 44480 bytes of per cpu data
[    0.000000] NR_CPUS: 64, nr_cpu_ids: 8
[    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 4126692
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=3D/dev/disk/by-id/scsi-35000c50000=
d5ca0f-part1 ro console=3Dtty1 console=3DttyS1,115200=20
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000001] Marking TSC unstable due to TSCs unsynchronized
[    0.000003] time.c: Detected 2612.039 MHz processor.
[    0.000011] spurious 8259A interrupt: IRQ7.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty1] enabled
[    0.000999] console [ttyS1] enabled
[    0.000999] Checking aperture...
[    0.000999] Node 0: aperture @ 4000000 size 32 MB
[    0.000999] Aperture pointing to e820 RAM. Ignoring.
[    0.000999] No AGP bridge found
[    0.000999] Your BIOS doesn't leave a aperture memory hole
[    0.000999] Please enable the IOMMU option in the BIOS setup
[    0.000999] This costs you 64 MB of RAM
[    0.000999] Mapping aperture over 65536 KB of RAM @ 4000000
[    0.000999] PM: Registered nosave memory: 0000000004000000 - 00000000080=
00000
[    0.000999] Memory: 16466524k/18874364k available (4336k kernel code, 30=
7540k reserved, 2815k data, 404k init)
[    0.000999] CPA: page pool initialized 1 of 1 pages preallocated
[    0.000999] SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-1, MinObjects=
=3D4, CPUs=3D8, Nodes=3D4
[    0.000999] hpet clockevent registered
[    0.059992] Calibrating delay using timer specific routine.. 5226.25 Bog=
oMIPS (lpj=3D2613125)
[    0.061048] Security Framework initialized
[    0.061995] SELinux:  Initializing.
[    0.063002] SELinux:  Starting in permissive mode
[    0.063011] selinux_register_security:  Registering secondary module cap=
ability
[    0.063991] Capability LSM initialized as secondary
[    0.066692] Dentry cache hash table entries: 2097152 (order: 12, 1677721=
6 bytes)
[    0.080601] Inode-cache hash table entries: 1048576 (order: 11, 8388608 =
bytes)
[    0.087485] Mount-cache hash table entries: 256
[    0.088147] Initializing cgroup subsys ns
[    0.088519] Initializing cgroup subsys cpuacct
[    0.089010] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.089988] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.090988] CPU 0/0 -> Node 0
[    0.091995] CPU: Physical Processor ID: 0
[    0.092987] CPU: Processor Core ID: 0
[    0.094001] ACPI: Core revision 20070126
[    0.114009] CPU0: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
[    0.116983] Using local APIC timer interrupts.
[    0.118982] APIC timer calibration result 12557872
[    0.118984] Detected 12.557 MHz APIC timer.
[    0.120112] Booting processor 1/2 ip 6000
[    0.120112] Initializing CPU#1
[    0.120112] Calibrating delay using timer specific routine.. 5223.88 Bog=
oMIPS (lpj=3D2611941)
[    0.120112] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.120112] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.120112] CPU 1/2 -> Node 1
[    0.120112] CPU: Physical Processor ID: 1
[    0.120112] CPU: Processor Core ID: 0
[    0.120112] x86: PAT support disabled.
[    0.192341] CPU1: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
[    0.195052] Booting processor 2/4 ip 6000
[    0.195052] Initializing CPU#2
[    0.195052] Calibrating delay using timer specific routine.. 5223.84 Bog=
oMIPS (lpj=3D2611922)
[    0.195052] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.195052] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.195052] CPU 2/4 -> Node 2
[    0.195052] CPU: Physical Processor ID: 2
[    0.195052] CPU: Processor Core ID: 0
[    0.195052] x86: PAT support disabled.
[    0.267306] CPU2: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
[    0.270039] Booting processor 3/6 ip 6000
[    0.270039] Initializing CPU#3
[    0.270039] Calibrating delay using timer specific routine.. 5223.86 Bog=
oMIPS (lpj=3D2611930)
[    0.270039] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.270039] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.270039] CPU 3/6 -> Node 3
[    0.270039] CPU: Physical Processor ID: 3
[    0.270039] CPU: Processor Core ID: 0
[    0.270039] x86: PAT support disabled.
[    0.342371] CPU3: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
[    0.345016] Booting processor 4/1 ip 6000
[    0.345016] Initializing CPU#4
[    0.345016] Calibrating delay using timer specific routine.. 5223.82 Bog=
oMIPS (lpj=3D2611910)
[    0.345016] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.345016] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.345016] CPU 4/1 -> Node 0
[    0.345016] CPU: Physical Processor ID: 0
[    0.345016] CPU: Processor Core ID: 1
[    0.345016] x86: PAT support disabled.
[    0.417217] CPU4: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
[    0.420014] Booting processor 5/3 ip 6000
[    0.420014] Initializing CPU#5
[    0.420014] Calibrating delay using timer specific routine.. 5223.85 Bog=
oMIPS (lpj=3D2611926)
[    0.420014] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.420014] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.420014] CPU 5/3 -> Node 1
[    0.420014] CPU: Physical Processor ID: 1
[    0.420014] CPU: Processor Core ID: 1
[    0.420014] x86: PAT support disabled.
[    0.492337] CPU5: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
[    0.494997] Booting processor 6/5 ip 6000
[    0.494997] Initializing CPU#6
[    0.494997] Calibrating delay using timer specific routine.. 5223.87 Bog=
oMIPS (lpj=3D2611937)
[    0.494997] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.494997] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.494997] CPU 6/5 -> Node 2
[    0.494997] CPU: Physical Processor ID: 2
[    0.494997] CPU: Processor Core ID: 1
[    0.494997] x86: PAT support disabled.
[    0.567297] CPU6: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
[    0.569990] Booting processor 7/7 ip 6000
[    0.569990] Initializing CPU#7
[    0.569990] Calibrating delay using timer specific routine.. 5223.84 Bog=
oMIPS (lpj=3D2611921)
[    0.569990] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.569990] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.569990] CPU 7/7 -> Node 3
[    0.569990] CPU: Physical Processor ID: 3
[    0.569990] CPU: Processor Core ID: 1
[    0.569990] x86: PAT support disabled.
[    0.642314] CPU7: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
[    0.644907] Brought up 8 CPUs
[    0.645904] Total of 8 processors activated (41793.22 BogoMIPS).
[    1.088430] khelper used greatest stack depth: 6056 bytes left
[    1.088430] net_namespace: 1176 bytes
[    1.088561] Time: 12:28:07  Date: 07/09/09
[    1.088603] NET: Registered protocol family 16
[    1.182581] No dock devices found.
[    1.184445] bus: 00 to node: 00
[    1.184446] bus: 01 to node: 00
[    1.184447] bus: 02 to node: 00
[    1.184449] bus: 03 to node: 00
[    1.184450] bus: 04 to node: 00
[    1.184451] bus: 05 to node: 00
[    1.184452] bus: 06 to node: 00
[    1.184453] bus: 07 to node: 00
[    1.184454] bus: 08 to node: 00
[    1.184455] bus: 09 to node: 00
[    1.184456] bus: 0a to node: 00
[    1.184457] bus: 0b to node: 00
[    1.184458] bus: 0c to node: 00
[    1.184460] bus: 0d to node: 00
[    1.184461] bus: 0e to node: 00
[    1.184462] bus: 0f to node: 00
[    1.184463] bus: 10 to node: 00
[    1.184464] bus: 11 to node: 00
[    1.184465] bus: 12 to node: 00
[    1.184466] bus: 13 to node: 00
[    1.184467] bus: 14 to node: 00
[    1.184468] bus: 15 to node: 00
[    1.184469] bus: 16 to node: 00
[    1.184471] bus: 17 to node: 00
[    1.184472] bus: 18 to node: 00
[    1.184473] bus: 19 to node: 00
[    1.184474] bus: 1a to node: 00
[    1.184475] bus: 1b to node: 00
[    1.184476] bus: 1c to node: 00
[    1.184477] bus: 1d to node: 00
[    1.184478] bus: 1e to node: 00
[    1.184480] bus: 1f to node: 00
[    1.184481] bus: 20 to node: 00
[    1.184482] bus: 21 to node: 00
[    1.184483] bus: 22 to node: 00
[    1.184484] bus: 23 to node: 00
[    1.184485] bus: 24 to node: 00
[    1.184486] bus: 25 to node: 00
[    1.184487] bus: 26 to node: 00
[    1.184488] bus: 27 to node: 00
[    1.184489] bus: 28 to node: 00
[    1.184491] bus: 29 to node: 00
[    1.184492] bus: 2a to node: 00
[    1.184493] bus: 2b to node: 00
[    1.184494] bus: 2c to node: 00
[    1.184495] bus: 2d to node: 00
[    1.184496] bus: 2e to node: 00
[    1.184497] bus: 2f to node: 00
[    1.184498] bus: 30 to node: 00
[    1.184499] bus: 31 to node: 00
[    1.184501] bus: 32 to node: 00
[    1.184502] bus: 33 to node: 00
[    1.184503] bus: 34 to node: 00
[    1.184504] bus: 35 to node: 00
[    1.184505] bus: 36 to node: 00
[    1.184506] bus: 37 to node: 00
[    1.184507] bus: 38 to node: 00
[    1.184508] bus: 39 to node: 00
[    1.184509] bus: 3a to node: 00
[    1.184510] bus: 3b to node: 00
[    1.184512] bus: 3c to node: 00
[    1.184513] bus: 3d to node: 00
[    1.184514] bus: 3e to node: 00
[    1.184515] bus: 3f to node: 00
[    1.184516] bus: 40 to node: 01
[    1.184517] bus: 41 to node: 01
[    1.184518] bus: 42 to node: 01
[    1.184519] bus: 43 to node: 01
[    1.184520] bus: 44 to node: 01
[    1.184522] bus: 45 to node: 01
[    1.184523] bus: 46 to node: 01
[    1.184524] bus: 47 to node: 01
[    1.184525] bus: 48 to node: 01
[    1.184526] bus: 49 to node: 01
[    1.184527] bus: 4a to node: 01
[    1.184528] bus: 4b to node: 01
[    1.184529] bus: 4c to node: 01
[    1.184530] bus: 4d to node: 01
[    1.184531] bus: 4e to node: 01
[    1.184532] bus: 4f to node: 01
[    1.184534] bus: 50 to node: 01
[    1.184535] bus: 51 to node: 01
[    1.184536] bus: 52 to node: 01
[    1.184537] bus: 53 to node: 01
[    1.184538] bus: 54 to node: 01
[    1.184539] bus: 55 to node: 01
[    1.184540] bus: 56 to node: 01
[    1.184541] bus: 57 to node: 01
[    1.184542] bus: 58 to node: 01
[    1.184543] bus: 59 to node: 01
[    1.184545] bus: 5a to node: 01
[    1.184546] bus: 5b to node: 01
[    1.184547] bus: 5c to node: 01
[    1.184548] bus: 5d to node: 01
[    1.184549] bus: 5e to node: 01
[    1.184550] bus: 5f to node: 01
[    1.184551] bus: 60 to node: 01
[    1.184552] bus: 61 to node: 01
[    1.184553] bus: 62 to node: 01
[    1.184554] bus: 63 to node: 01
[    1.184556] bus: 64 to node: 01
[    1.184557] bus: 65 to node: 01
[    1.184558] bus: 66 to node: 01
[    1.184559] bus: 67 to node: 01
[    1.184560] bus: 68 to node: 01
[    1.184561] bus: 69 to node: 01
[    1.184562] bus: 6a to node: 01
[    1.184563] bus: 6b to node: 01
[    1.184564] bus: 6c to node: 01
[    1.184565] bus: 6d to node: 01
[    1.184566] bus: 6e to node: 01
[    1.184568] bus: 6f to node: 01
[    1.184569] bus: 70 to node: 01
[    1.184570] bus: 71 to node: 01
[    1.184571] bus: 72 to node: 01
[    1.184572] bus: 73 to node: 01
[    1.184573] bus: 74 to node: 01
[    1.184574] bus: 75 to node: 01
[    1.184575] bus: 76 to node: 01
[    1.184576] bus: 77 to node: 01
[    1.184577] bus: 78 to node: 01
[    1.184579] bus: 79 to node: 01
[    1.184580] bus: 7a to node: 01
[    1.184581] bus: 7b to node: 01
[    1.184582] bus: 7c to node: 01
[    1.184583] bus: 7d to node: 01
[    1.184584] bus: 7e to node: 01
[    1.184585] bus: 7f to node: 01
[    1.184610] ACPI: bus type pci registered
[    1.186388] PCI: Using configuration type 1 for base access
[    1.192116] ACPI: EC: Look up EC in DSDT
[    1.195709] ACPI: SSDT 7FD58000, 09BC (r2 HP     PNOWSSDT        2 HP   =
       1)
[    1.199622] ACPI: Interpreter enabled
[    1.200296] ACPI: (supports S0 S4 S5)
[    1.202295] ACPI: Using IOAPIC for interrupt routing
[    1.210458] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.211353] PCI: Scanning bus 0000:00
[    1.211374] PCI: Found 0000:00:00.0 [10de/005e] 000580 00
[    1.211404] PCI: Found 0000:00:01.0 [10de/0051] 000601 00
[    1.211415] pci 0000:00:01.0: calling nvidia_force_enable_hpet+0x0/0xa3()
[    1.211436] PCI: Found 0000:00:02.0 [10de/005a] 000c03 00
[    1.211458] PCI: Found 0000:00:02.1 [10de/005b] 000c03 00
[    1.211486] PCI: Found 0000:00:06.0 [10de/0053] 000101 00
[    1.211504] PCI: Found 0000:00:09.0 [10de/005c] 000604 01
[    1.211520] PCI: Found 0000:00:0c.0 [10de/005d] 000604 01
[    1.211535] PCI: Found 0000:00:0d.0 [10de/005d] 000604 01
[    1.211552] PCI: Found 0000:00:0e.0 [10de/005d] 000604 01
[    1.211572] PCI: Found 0000:00:18.0 [1022/1100] 000600 00
[    1.211583] PCI: Found 0000:00:18.1 [1022/1101] 000600 00
[    1.211593] PCI: Found 0000:00:18.2 [1022/1102] 000600 00
[    1.211605] PCI: Found 0000:00:18.3 [1022/1103] 000600 00
[    1.211619] PCI: Found 0000:00:19.0 [1022/1100] 000600 00
[    1.211631] PCI: Found 0000:00:19.1 [1022/1101] 000600 00
[    1.211641] PCI: Found 0000:00:19.2 [1022/1102] 000600 00
[    1.211653] PCI: Found 0000:00:19.3 [1022/1103] 000600 00
[    1.211669] PCI: Found 0000:00:1a.0 [1022/1100] 000600 00
[    1.211680] PCI: Found 0000:00:1a.1 [1022/1101] 000600 00
[    1.211691] PCI: Found 0000:00:1a.2 [1022/1102] 000600 00
[    1.211703] PCI: Found 0000:00:1a.3 [1022/1103] 000600 00
[    1.211719] PCI: Found 0000:00:1b.0 [1022/1100] 000600 00
[    1.211732] PCI: Found 0000:00:1b.1 [1022/1101] 000600 00
[    1.211744] PCI: Found 0000:00:1b.2 [1022/1102] 000600 00
[    1.211759] PCI: Found 0000:00:1b.3 [1022/1103] 000600 00
[    1.211772] PCI: Fixups for bus 0000:00
[    1.211775] PCI: Scanning behind PCI bridge 0000:00:09.0, config 010100,=
 pass 0
[    1.211779] PCI: Scanning bus 0000:01
[    1.211795] PCI: Found 0000:01:03.0 [1002/515e] 000300 00
[    1.211835] PCI: Found 0000:01:04.0 [0e11/b203] 000880 00
[    1.211877] PCI: Found 0000:01:04.2 [0e11/b204] 000880 00
[    1.211927] PCI: Found 0000:01:04.4 [103c/3300] 000c03 00
[    1.211974] PCI: Found 0000:01:04.6 [103c/3302] 000c07 00
[    1.212022] PCI: Fixups for bus 0000:01
[    1.212024] PCI: Transparent bridge - 0000:00:09.0
[    1.212296] PCI: Bus scan for 0000:01 returning with max=3D01
[    1.212298] PCI: Scanning behind PCI bridge 0000:00:0c.0, config 0a0800,=
 pass 0
[    1.212302] PCI: Scanning bus 0000:08
[    1.212329] PCI: Fixups for bus 0000:08
[    1.212333] PCI: Bus scan for 0000:08 returning with max=3D08
[    1.212335] PCI: Scanning behind PCI bridge 0000:00:0d.0, config 070500,=
 pass 0
[    1.212341] PCI: Scanning bus 0000:05
[    1.212368] PCI: Fixups for bus 0000:05
[    1.212372] PCI: Bus scan for 0000:05 returning with max=3D05
[    1.212374] PCI: Scanning behind PCI bridge 0000:00:0e.0, config 040200,=
 pass 0
[    1.212377] PCI: Scanning bus 0000:02
[    1.212404] PCI: Fixups for bus 0000:02
[    1.212408] PCI: Bus scan for 0000:02 returning with max=3D02
[    1.212411] PCI: Scanning behind PCI bridge 0000:00:09.0, config 010100,=
 pass 1
[    1.212413] PCI: Scanning behind PCI bridge 0000:00:0c.0, config 0a0800,=
 pass 1
[    1.212416] PCI: Scanning behind PCI bridge 0000:00:0d.0, config 070500,=
 pass 1
[    1.212419] PCI: Scanning behind PCI bridge 0000:00:0e.0, config 040200,=
 pass 1
[    1.212422] PCI: Bus scan for 0000:00 returning with max=3D0a
[    1.212428] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.212529] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
[    1.212670] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE0._PRT]
[    1.212796] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE1._PRT]
[    1.212922] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE2._PRT]
[    1.216542] ACPI: PCI Root Bridge [PCI1] (0000:40)
[    1.217349] PCI: Scanning bus 0000:40
[    1.217368] PCI: Found 0000:40:00.0 [10de/005e] 000580 00
[    1.217400] PCI: Found 0000:40:01.0 [10de/00d3] 000580 00
[    1.217438] PCI: Found 0000:40:0b.0 [10de/005d] 000604 01
[    1.217459] PCI: Found 0000:40:0c.0 [10de/005d] 000604 01
[    1.217481] PCI: Found 0000:40:0d.0 [10de/005d] 000604 01
[    1.217502] PCI: Found 0000:40:0e.0 [10de/005d] 000604 01
[    1.217527] PCI: Found 0000:40:10.0 [1022/7458] 000604 01
[    1.217542] PCI: Found 0000:40:10.1 [1022/7459] 000800 00
[    1.217574] PCI: Found 0000:40:11.0 [1022/7458] 000604 01
[    1.217590] PCI: Found 0000:40:11.1 [1022/7459] 000800 00
[    1.217618] PCI: Fixups for bus 0000:40
[    1.217620] PCI: Scanning behind PCI bridge 0000:40:0b.0, config 514f40,=
 pass 0
[    1.217626] PCI: Scanning bus 0000:4f
[    1.217650] PCI: Fixups for bus 0000:4f
[    1.217656] PCI: Bus scan for 0000:4f returning with max=3D4f
[    1.217658] PCI: Scanning behind PCI bridge 0000:40:0c.0, config 4e4c40,=
 pass 0
[    1.217662] PCI: Scanning bus 0000:4c
[    1.217687] PCI: Fixups for bus 0000:4c
[    1.217692] PCI: Bus scan for 0000:4c returning with max=3D4c
[    1.217695] PCI: Scanning behind PCI bridge 0000:40:0d.0, config 4b4940,=
 pass 0
[    1.217699] PCI: Scanning bus 0000:49
[    1.217723] PCI: Fixups for bus 0000:49
[    1.217728] PCI: Bus scan for 0000:49 returning with max=3D49
[    1.217731] PCI: Scanning behind PCI bridge 0000:40:0e.0, config 484640,=
 pass 0
[    1.217735] PCI: Scanning bus 0000:46
[    1.217759] PCI: Fixups for bus 0000:46
[    1.217764] PCI: Bus scan for 0000:46 returning with max=3D46
[    1.217767] PCI: Scanning behind PCI bridge 0000:40:10.0, config 414140,=
 pass 0
[    1.217772] PCI: Scanning bus 0000:41
[    1.217790] PCI: Found 0000:41:01.0 [14e4/164a] 000200 00
[    1.217828] PCI: Found 0000:41:02.0 [14e4/164a] 000200 00
[    1.217866] PCI: Fixups for bus 0000:41
[    1.217872] PCI: Bus scan for 0000:41 returning with max=3D41
[    1.217875] PCI: Scanning behind PCI bridge 0000:40:11.0, config 454240,=
 pass 0
[    1.217878] PCI: Scanning bus 0000:42
[    1.217897] PCI: Found 0000:42:01.0 [1000/0054] 000100 00
[    1.217936] PCI: Found 0000:42:02.0 [103c/3220] 000104 00
[    1.217975] PCI: Fixups for bus 0000:42
[    1.217980] PCI: Bus scan for 0000:42 returning with max=3D42
[    1.217983] PCI: Scanning behind PCI bridge 0000:40:0b.0, config 514f40,=
 pass 1
[    1.217986] PCI: Scanning behind PCI bridge 0000:40:0c.0, config 4e4c40,=
 pass 1
[    1.217990] PCI: Scanning behind PCI bridge 0000:40:0d.0, config 4b4940,=
 pass 1
[    1.217993] PCI: Scanning behind PCI bridge 0000:40:0e.0, config 484640,=
 pass 1
[    1.217996] PCI: Scanning behind PCI bridge 0000:40:10.0, config 414140,=
 pass 1
[    1.218000] PCI: Scanning behind PCI bridge 0000:40:11.0, config 454240,=
 pass 1
[    1.218003] PCI: Bus scan for 0000:40 returning with max=3D51
[    1.218010] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.BRGA._PRT]
[    1.218126] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.BRGB._PRT]
[    1.218341] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE0._PRT]
[    1.218487] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE1._PRT]
[    1.218632] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE2._PRT]
[    1.218778] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE3._PRT]
[    1.220812] ACPI: PCI Interrupt Link [LNKW] (IRQs 16) *0, disabled.
[    1.223402] ACPI: PCI Interrupt Link [LNKX] (IRQs 17) *0, disabled.
[    1.226455] ACPI: PCI Interrupt Link [LNKY] (IRQs 18) *0, disabled.
[    1.229697] ACPI: PCI Interrupt Link [LNKZ] (IRQs 19) *0, disabled.
[    1.234435] ACPI: PCI Interrupt Link [LNU0] (IRQs 22) *5
[    1.237452] ACPI: PCI Interrupt Link [LNU2] (IRQs 23) *10
[    1.240770] ACPI: PCI Interrupt Link [LNKA] (IRQs 54) *0, disabled.
[    1.244451] ACPI: PCI Interrupt Link [LNKB] (IRQs 55) *0, disabled.
[    1.247408] ACPI: PCI Interrupt Link [LNKC] (IRQs 56) *0, disabled.
[    1.251447] ACPI: PCI Interrupt Link [LNKD] (IRQs 57) *0, disabled.
[    1.253787] Linux Plug and Play Support v0.97 (c) Adam Belay
[    1.254334] pnp: PnP ACPI init
[    1.255292] ACPI: bus type pnp registered
[    1.261061] pnp: PnP ACPI: found 16 devices
[    1.261286] ACPI: ACPI bus type pnp unregistered
[    1.262685] SCSI subsystem initialized
[    1.263532] libata version 3.00 loaded.
[    1.263691] usbcore: registered new interface driver usbfs
[    1.265306] usbcore: registered new interface driver hub
[    1.266353] usbcore: registered new device driver usb
[    1.267672] PCI: Using ACPI for IRQ routing
[    1.276302] NetLabel: Initializing
[    1.277284] NetLabel:  domain hash size =3D 128
[    1.278283] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    1.279294] NetLabel:  unlabeled traffic allowed by default
[    1.280284] DMAR:parse DMAR table failure.
[    1.281391] PCI-DMA: Disabling AGP.
[    1.284054] PCI-DMA: aperture base @ 4000000 size 65536 KB
[    1.284282] PCI-DMA: using GART IOMMU.
[    1.285284] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.286907] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    1.290281] hpet0: 3 32-bit timers, 25000000 Hz
[    1.293022] ACPI: RTC can wake from S4
[    1.293288] Switched to high resolution mode on CPU 0
[    2.725661] Switched to high resolution mode on CPU 4
[    3.352629] Switched to high resolution mode on CPU 1
[    3.352629] Switched to high resolution mode on CPU 5
[    3.352629] Switched to high resolution mode on CPU 2
[    3.352629] Switched to high resolution mode on CPU 6
[    3.352629] Switched to high resolution mode on CPU 3
[    3.352629] Switched to high resolution mode on CPU 7
[    3.352629] system 00:01: ioport range 0x408-0x40f has been reserved
[    3.388529] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    3.423688] system 00:01: ioport range 0x700-0x73f has been reserved
[    3.459756] system 00:01: ioport range 0x800-0x8fe has been reserved
[    3.495519] system 00:01: ioport range 0x900-0x9fe has been reserved
[    3.531540] system 00:01: ioport range 0x9ff-0x9ff has been reserved
[    3.567536] system 00:01: ioport range 0xa00-0xafe has been reserved
[    3.590680] system 00:01: ioport range 0xaff-0xaff has been reserved
[    3.626541] system 00:01: ioport range 0xb00-0xbfe has been reserved
[    3.662526] system 00:01: ioport range 0xbff-0xbff has been reserved
[    3.698548] system 00:01: ioport range 0xc80-0xc83 has been reserved
[    3.734557] system 00:01: ioport range 0xcd4-0xcd7 has been reserved
[    3.770555] system 00:01: ioport range 0xcf9-0xcf9 could not be reserved
[    3.797525] system 00:01: ioport range 0xf50-0xf58 has been reserved
[    3.834520] system 00:01: ioport range 0xca0-0xca1 has been reserved
[    3.864128] system 00:01: ioport range 0xca4-0xca5 has been reserved
[    3.900454] system 00:01: ioport range 0xc00-0xc03 has been reserved
[    3.936551] system 00:01: ioport range 0x2f8-0x2ff has been reserved
[    3.972510]   got res [d9d00000:d9d1ffff] bus [d9d00000:d9d1ffff] flags =
27200 for BAR 6 of 0000:01:03.0
[    3.972513]   got res [d9d20000:d9d2ffff] bus [d9d20000:d9d2ffff] flags =
27200 for BAR 6 of 0000:01:04.2
[    3.972516] PCI: Bridge: 0000:00:09.0
[    3.992515]   IO window: 1000-2fff
[    4.012496]   MEM window: 0xd9d00000-0xd9efffff
[    4.037514]   PREFETCH window: 0x00000000d0000000-0x00000000d7ffffff
[    4.074774] PCI: Bridge: 0000:00:0c.0
[    4.094929]   IO window: disabled.
[    4.114657]   MEM window: disabled.
[    4.133531]   PREFETCH window: disabled.
[    4.156511] PCI: Bridge: 0000:00:0d.0
[    4.176430]   IO window: disabled.
[    4.197533]   MEM window: disabled.
[    4.216509]   PREFETCH window: disabled.
[    4.229402] PCI: Bridge: 0000:00:0e.0
[    4.238533]   IO window: disabled.
[    4.258529]   MEM window: disabled.
[    4.277504]   PREFETCH window: disabled.
[    4.287668] PCI: Setting latency timer of device 0000:00:09.0 to 64
[    4.287676] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    4.287680] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    4.287686] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    4.287693] PCI: Bridge: 0000:40:0b.0
[    4.307503]   IO window: disabled.
[    4.327512]   MEM window: disabled.
[    4.346513]   PREFETCH window: disabled.
[    4.369482] PCI: Bridge: 0000:40:0c.0
[    4.389473]   IO window: disabled.
[    4.409485]   MEM window: disabled.
[    4.428488]   PREFETCH window: disabled.
[    4.451874] PCI: Bridge: 0000:40:0d.0
[    4.461515]   IO window: disabled.
[    4.481522]   MEM window: disabled.
[    4.486756]   PREFETCH window: disabled.
[    4.509625] PCI: Bridge: 0000:40:0e.0
[    4.520352]   IO window: disabled.
[    4.539524]   MEM window: disabled.
[    4.559516]   PREFETCH window: disabled.
[    4.582507]   got res [88000000:8801ffff] bus [88000000:8801ffff] flags =
27200 for BAR 6 of 0000:41:01.0
[    4.582510]   got res [88020000:8803ffff] bus [88020000:8803ffff] flags =
27200 for BAR 6 of 0000:41:02.0
[    4.582512] PCI: Bridge: 0000:40:10.0
[    4.602523]   IO window: disabled.
[    4.615159]   MEM window: 0xda000000-0xddffffff
[    4.640481]   PREFETCH window: 0x0000000088000000-0x00000000880fffff
[    4.678495]   got res [88200000:883fffff] bus [88200000:883fffff] flags =
27200 for BAR 6 of 0000:42:01.0
[    4.678498]   got res [88100000:8813ffff] bus [88100000:8813ffff] flags =
27200 for BAR 6 of 0000:42:02.0
[    4.678500] PCI: Bridge: 0000:40:11.0
[    4.681178]   IO window: 3000-3fff
[    4.700521]   MEM window: 0xdfe00000-0xdfefffff
[    4.725474]   PREFETCH window: 0x0000000088100000-0x00000000883fffff
[    4.763491] PCI: Setting latency timer of device 0000:40:0b.0 to 64
[    4.763497] PCI: Setting latency timer of device 0000:40:0c.0 to 64
[    4.763504] PCI: Setting latency timer of device 0000:40:0d.0 to 64
[    4.763511] PCI: Setting latency timer of device 0000:40:0e.0 to 64
[    4.763545] NET: Registered protocol family 2
[    4.797927] IP route cache hash table entries: 524288 (order: 10, 419430=
4 bytes)
[    4.844411] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    4.893908] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    4.932131] TCP: Hash tables configured (established 524288 bind 65536)
[    4.950137] TCP reno registered
[    4.970657] NET: Registered protocol family 1
[    4.988167] checking if image is initramfs... it is
[    5.154400] Freeing initrd memory: 2668k freed
[    5.184553] microcode: CPU0 not a capable Intel processor
[    5.189397] microcode: CPU1 not a capable Intel processor
[    5.200319] microcode: CPU2 not a capable Intel processor
[    5.230377] microcode: CPU3 not a capable Intel processor
[    5.230377] microcode: CPU4 not a capable Intel processor
[    5.286358] microcode: CPU5 not a capable Intel processor
[    5.317838] microcode: CPU6 not a capable Intel processor
[    5.347929] microcode: CPU7 not a capable Intel processor
[    5.385623] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet=
=2Eco.uk>
[    5.408176] audit: initializing netlink socket (disabled)
[    5.438396] type=3D2000 audit(1247142486.936:1): initialized
[    5.455629] Total HugeTLB memory allocated, 0
[    5.483721] VFS: Disk quotas dquot_6.5.1
[    5.496000] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.522917] SELinux:  Registering netfilter hooks
[    5.523129] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    5.541903] io scheduler noop registered
[    5.564642] io scheduler anticipatory registered
[    5.587007] io scheduler deadline registered
[    5.611782] io scheduler cfq registered (default)
[    5.637654] pci 0000:00:00.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.637676] pci 0000:00:00.0: Enabling HT MSI Mapping
[    5.644615] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.644622] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.644626] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xaf()
[    5.644631] pci 0000:00:01.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.644637] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.644640] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.644643] pci 0000:00:01.0: calling pci_fixup_video+0x0/0xaf()
[    5.644647] pci 0000:00:02.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.644655] pci 0000:00:02.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.644657] pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.655224] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xaf()
[    5.655228] pci 0000:00:02.1: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.655237] pci 0000:00:02.1: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.655240] pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0x447()
[    5.655247] pci 0000:00:02.1: EHCI: BIOS handoff
[    5.666221] pci 0000:00:02.1: calling pci_fixup_video+0x0/0xaf()
[    5.666225] pci 0000:00:06.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.666233] pci 0000:00:06.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.666235] pci 0000:00:06.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.666238] pci 0000:00:06.0: calling pci_fixup_video+0x0/0xaf()
[    5.666242] pci 0000:00:09.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.666249] pci 0000:00:09.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.666251] pci 0000:00:09.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.666254] pci 0000:00:09.0: calling pci_fixup_video+0x0/0xaf()
[    5.666258] pci 0000:00:0c.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.666267] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    5.694224] pci 0000:00:0c.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/=
0x7a()
[    5.694232] pci 0000:00:0c.0: Found enabled HT MSI Mapping
[    5.712408] pci 0000:00:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_ca=
p+0x0/0x6a()
[    5.712411] pci 0000:00:0c.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.712414] pci 0000:00:0c.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.712417] pci 0000:00:0c.0: calling pci_fixup_video+0x0/0xaf()
[    5.712421] pci 0000:00:0d.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.712430] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    5.720120] pci 0000:00:0d.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/=
0x7a()
[    5.720127] pci 0000:00:0d.0: Found enabled HT MSI Mapping
[    5.729153] pci 0000:00:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_ca=
p+0x0/0x6a()
[    5.729156] pci 0000:00:0d.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.729159] pci 0000:00:0d.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.729162] pci 0000:00:0d.0: calling pci_fixup_video+0x0/0xaf()
[    5.729166] pci 0000:00:0e.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.729175] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    5.757220] pci 0000:00:0e.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/=
0x7a()
[    5.757227] pci 0000:00:0e.0: Found enabled HT MSI Mapping
[    5.789219] pci 0000:00:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_ca=
p+0x0/0x6a()
[    5.789222] pci 0000:00:0e.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789225] pci 0000:00:0e.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789227] pci 0000:00:0e.0: calling pci_fixup_video+0x0/0xaf()
[    5.789231] pci 0000:00:18.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789234] pci 0000:00:18.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789237] pci 0000:00:18.0: calling pci_fixup_video+0x0/0xaf()
[    5.789241] pci 0000:00:18.1: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789244] pci 0000:00:18.1: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789247] pci 0000:00:18.1: calling pci_fixup_video+0x0/0xaf()
[    5.789251] pci 0000:00:18.2: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789254] pci 0000:00:18.2: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789256] pci 0000:00:18.2: calling pci_fixup_video+0x0/0xaf()
[    5.789261] pci 0000:00:18.3: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789263] pci 0000:00:18.3: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789266] pci 0000:00:18.3: calling pci_fixup_video+0x0/0xaf()
[    5.789270] pci 0000:00:19.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789273] pci 0000:00:19.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789276] pci 0000:00:19.0: calling pci_fixup_video+0x0/0xaf()
[    5.789280] pci 0000:00:19.1: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789282] pci 0000:00:19.1: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789285] pci 0000:00:19.1: calling pci_fixup_video+0x0/0xaf()
[    5.789290] pci 0000:00:19.2: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789292] pci 0000:00:19.2: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789295] pci 0000:00:19.2: calling pci_fixup_video+0x0/0xaf()
[    5.789299] pci 0000:00:19.3: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789302] pci 0000:00:19.3: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789305] pci 0000:00:19.3: calling pci_fixup_video+0x0/0xaf()
[    5.789309] pci 0000:00:1a.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789311] pci 0000:00:1a.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789314] pci 0000:00:1a.0: calling pci_fixup_video+0x0/0xaf()
[    5.789318] pci 0000:00:1a.1: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789321] pci 0000:00:1a.1: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789324] pci 0000:00:1a.1: calling pci_fixup_video+0x0/0xaf()
[    5.789328] pci 0000:00:1a.2: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789331] pci 0000:00:1a.2: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789334] pci 0000:00:1a.2: calling pci_fixup_video+0x0/0xaf()
[    5.789338] pci 0000:00:1a.3: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789341] pci 0000:00:1a.3: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789343] pci 0000:00:1a.3: calling pci_fixup_video+0x0/0xaf()
[    5.789348] pci 0000:00:1b.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789350] pci 0000:00:1b.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789353] pci 0000:00:1b.0: calling pci_fixup_video+0x0/0xaf()
[    5.789357] pci 0000:00:1b.1: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789360] pci 0000:00:1b.1: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789363] pci 0000:00:1b.1: calling pci_fixup_video+0x0/0xaf()
[    5.789367] pci 0000:00:1b.2: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789370] pci 0000:00:1b.2: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789373] pci 0000:00:1b.2: calling pci_fixup_video+0x0/0xaf()
[    5.789377] pci 0000:00:1b.3: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789379] pci 0000:00:1b.3: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789382] pci 0000:00:1b.3: calling pci_fixup_video+0x0/0xaf()
[    5.789386] pci 0000:01:03.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789389] pci 0000:01:03.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789392] pci 0000:01:03.0: calling pci_fixup_video+0x0/0xaf()
[    5.789396] pci 0000:01:03.0: Boot video device
[    5.789399] pci 0000:01:04.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789402] pci 0000:01:04.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789405] pci 0000:01:04.0: calling pci_fixup_video+0x0/0xaf()
[    5.789409] pci 0000:01:04.2: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789411] pci 0000:01:04.2: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789414] pci 0000:01:04.2: calling pci_fixup_video+0x0/0xaf()
[    5.789418] pci 0000:01:04.4: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.789421] pci 0000:01:04.4: calling quirk_usb_early_handoff+0x0/0x447()
[    5.789428] pci 0000:01:04.4: uhci_check_and_reset_hc: legsup =3D 0x0010
[    5.789429] pci 0000:01:04.4: Performing full reset
[    5.789439] pci 0000:01:04.4: HCRESET not completed yet!
[    5.819124] pci 0000:01:04.4: calling pci_fixup_video+0x0/0xaf()
[    5.819128] pci 0000:01:04.6: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.819131] pci 0000:01:04.6: calling quirk_usb_early_handoff+0x0/0x447()
[    5.819134] pci 0000:01:04.6: calling pci_fixup_video+0x0/0xaf()
[    5.819139] pci 0000:40:00.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.819151] pci 0000:40:00.0: Enabling HT MSI Mapping
[    5.837123] pci 0000:40:00.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.837126] pci 0000:40:00.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.837129] pci 0000:40:00.0: calling pci_fixup_video+0x0/0xaf()
[    5.837133] pci 0000:40:01.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.837139] pci 0000:40:01.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.837142] pci 0000:40:01.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.837145] pci 0000:40:01.0: calling pci_fixup_video+0x0/0xaf()
[    5.837149] pci 0000:40:0b.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.837159] pci 0000:40:0b.0: Enabling HT MSI Mapping
[    5.855364] pci 0000:40:0b.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/=
0x7a()
[    5.855371] pci 0000:40:0b.0: Found enabled HT MSI Mapping
[    5.871444] pci 0000:40:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_ca=
p+0x0/0x6a()
[    5.871447] pci 0000:40:0b.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.871450] pci 0000:40:0b.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.871453] pci 0000:40:0b.0: calling pci_fixup_video+0x0/0xaf()
[    5.871457] pci 0000:40:0c.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.871467] pci 0000:40:0c.0: Enabling HT MSI Mapping
[    5.899129] pci 0000:40:0c.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/=
0x7a()
[    5.899137] pci 0000:40:0c.0: Found enabled HT MSI Mapping
[    5.931121] pci 0000:40:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_ca=
p+0x0/0x6a()
[    5.931125] pci 0000:40:0c.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.931127] pci 0000:40:0c.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.931130] pci 0000:40:0c.0: calling pci_fixup_video+0x0/0xaf()
[    5.931134] pci 0000:40:0d.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.931144] pci 0000:40:0d.0: Enabling HT MSI Mapping
[    5.941704] pci 0000:40:0d.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/=
0x7a()
[    5.941711] pci 0000:40:0d.0: Found enabled HT MSI Mapping
[    5.973118] pci 0000:40:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_ca=
p+0x0/0x6a()
[    5.973122] pci 0000:40:0d.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.973124] pci 0000:40:0d.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.973127] pci 0000:40:0d.0: calling pci_fixup_video+0x0/0xaf()
[    5.973132] pci 0000:40:0e.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.973141] pci 0000:40:0e.0: Enabling HT MSI Mapping
[    6.001113] pci 0000:40:0e.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/=
0x7a()
[    6.001120] pci 0000:40:0e.0: Found enabled HT MSI Mapping
[    6.033111] pci 0000:40:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_ca=
p+0x0/0x6a()
[    6.033115] pci 0000:40:0e.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    6.033117] pci 0000:40:0e.0: calling quirk_usb_early_handoff+0x0/0x447()
[    6.033120] pci 0000:40:0e.0: calling pci_fixup_video+0x0/0xaf()
[    6.033125] pci 0000:40:10.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    6.033127] pci 0000:40:10.0: calling quirk_usb_early_handoff+0x0/0x447()
[    6.033130] pci 0000:40:10.0: calling pci_fixup_video+0x0/0xaf()
[    6.033135] pci 0000:40:10.1: calling quirk_cardbus_legacy+0x0/0x1d()
[    6.033137] pci 0000:40:10.1: calling quirk_usb_early_handoff+0x0/0x447()
[    6.033140] pci 0000:40:10.1: calling pci_fixup_video+0x0/0xaf()
[    6.033144] pci 0000:40:11.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    6.033147] pci 0000:40:11.0: calling quirk_usb_early_handoff+0x0/0x447()
[    6.033150] pci 0000:40:11.0: calling pci_fixup_video+0x0/0xaf()
[    6.033154] pci 0000:40:11.1: calling quirk_cardbus_legacy+0x0/0x1d()
[    6.033157] pci 0000:40:11.1: calling quirk_usb_early_handoff+0x0/0x447()
[    6.033160] pci 0000:40:11.1: calling pci_fixup_video+0x0/0xaf()
[    6.033165] pci 0000:41:01.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    6.033167] pci 0000:41:01.0: calling quirk_usb_early_handoff+0x0/0x447()
[    6.033170] pci 0000:41:01.0: calling pci_fixup_video+0x0/0xaf()
[    6.033174] pci 0000:41:02.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    6.033177] pci 0000:41:02.0: calling quirk_usb_early_handoff+0x0/0x447()
[    6.033180] pci 0000:41:02.0: calling pci_fixup_video+0x0/0xaf()
[    6.033184] pci 0000:42:01.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    6.033187] pci 0000:42:01.0: calling quirk_usb_early_handoff+0x0/0x447()
[    6.033190] pci 0000:42:01.0: calling pci_fixup_video+0x0/0xaf()
[    6.033194] pci 0000:42:02.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    6.033197] pci 0000:42:02.0: calling quirk_usb_early_handoff+0x0/0x447()
[    6.033200] pci 0000:42:02.0: calling pci_fixup_video+0x0/0xaf()
[    6.033443] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    6.033459] assign_interrupt_mode Found MSI capability
[    6.052207] Allocate Port Service[0000:00:0c.0:pcie00]
[    6.053277] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    6.053290] assign_interrupt_mode Found MSI capability
[    6.079464] Allocate Port Service[0000:00:0d.0:pcie00]
[    6.079544] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    6.079556] assign_interrupt_mode Found MSI capability
[    6.109173] Allocate Port Service[0000:00:0e.0:pcie00]
[    6.109173] PCI: Setting latency timer of device 0000:40:0b.0 to 64
[    6.109195] assign_interrupt_mode Found MSI capability
[    6.134444] Allocate Port Service[0000:40:0b.0:pcie00]
[    6.134557] PCI: Setting latency timer of device 0000:40:0c.0 to 64
[    6.134575] assign_interrupt_mode Found MSI capability
[    6.163478] Allocate Port Service[0000:40:0c.0:pcie00]
[    6.163562] PCI: Setting latency timer of device 0000:40:0d.0 to 64
[    6.163581] assign_interrupt_mode Found MSI capability
[    6.192057] Allocate Port Service[0000:40:0d.0:pcie00]
[    6.193061] PCI: Setting latency timer of device 0000:40:0e.0 to 64
[    6.193079] assign_interrupt_mode Found MSI capability
[    6.222003] Allocate Port Service[0000:40:0e.0:pcie00]
[    6.223184] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    6.256181] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00=
/input/input0
[    6.300997] ACPI: Power Button (FF) [PWRF]
[    6.326163] ACPI: ACPI0007:00 is registered as cooling_device0
[    6.348810] ACPI: ACPI0007:01 is registered as cooling_device1
[    6.365295] ACPI: ACPI0007:02 is registered as cooling_device2
[    6.373940] ACPI: ACPI0007:03 is registered as cooling_device3
[    6.406765] ACPI: ACPI0007:04 is registered as cooling_device4
[    6.440714] ACPI: ACPI0007:05 is registered as cooling_device5
[    6.473667] ACPI: ACPI0007:06 is registered as cooling_device6
[    6.496598] ACPI: ACPI0007:07 is registered as cooling_device7
[    6.540851] hpet_resources: 0xfed00000 is busy
[    6.541011] Non-volatile memory driver v1.2
[    6.563623] Linux agpgart interface v0.103
[    6.588627] [drm] Initialized drm 1.1.0 20060810
[    6.615550] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sha=
ring enabled
[    6.907490] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    7.189215] serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
[    7.213505] 00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    7.246638] brd: module loaded
[    7.265662] loop: module loaded
[    7.282964] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
[    7.308127] Copyright (c) 1999-2006 Intel Corporation.
[    7.338048] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[    7.363751] e100: Copyright(c) 1999-2006 Intel Corporation
[    7.396076] Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v1.7.4 (F=
ebruary 18, 2008)
[    7.442111] ACPI: PCI Interrupt 0000:41:01.0[A] -> GSI 31 (level, low) -=
> IRQ 31
[    7.816164] eth0: Broadcom NetXtreme II BCM5706 1000Base-T (A2) PCI-X 64=
-bit 100MHz found at mem dc000000, IRQ 31, node addr 00:1b:78:be:d1:50
[    7.846814] ACPI: PCI Interrupt 0000:41:02.0[A] -> GSI 32 (level, low) -=
> IRQ 32
[    8.219180] eth1: Broadcom NetXtreme II BCM5706 1000Base-T (A2) PCI-X 64=
-bit 100MHz found at mem da000000, IRQ 32, node addr 00:1b:78:be:d1:52
[    8.292662] console [netcon0] enabled
[    8.313040] netconsole: network logging started
[    8.340103] input: Macintosh mouse button emulation as /devices/virtual/=
input/input1
[    8.385503] Loading iSCSI transport class v2.0-869.
[    8.412684] Driver 'sd' needs updating - please use bus_type methods
[    8.449063] Driver 'sr' needs updating - please use bus_type methods
[    8.463577] pata_amd 0000:00:06.0: version 0.3.10
[    8.463619] PCI: Setting latency timer of device 0000:00:06.0 to 64
[    8.463740] scsi0 : pata_amd
[    8.465551] scsi1 : pata_amd
[    8.481296] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x500 irq =
14
[    8.520248] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x508 irq =
15
[    8.725233] ata1.00: ATAPI: TEAC    DV-W28ECW, G.C4, max MWDMA2
[    8.758420] ata1: nv_mode_filter: 0x39f&0xfffff->0x39f, BIOS=3D0x0 (0x0)=
 ACPI=3D0x0
[    8.781313] ata1.00: configured for MWDMA2
[    8.804086] ata2: port disabled. ignoring.
[    8.816510] scsi 0:0:0:0: CD-ROM            TEAC     DV-W28ECW        G.=
C4 PQ: 0 ANSI: 5
[    8.891267] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    8.926113] Uniform CD-ROM driver Revision: 3.20
[    8.951875] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    8.951994] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    8.982145] ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
[    8.982435] ACPI: PCI Interrupt Link [LNU2] enabled at IRQ 23
[    9.014796] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LNU2] -> GSI 23=
 (level, high) -> IRQ 23
[    9.047330] PCI: Setting latency timer of device 0000:00:02.1 to 64
[    9.047332] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    9.076313] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus =
number 1
[    9.119356] ehci_hcd 0000:00:02.1: reset hcs_params 0x10148a dbg=3D1 cc=
=3D1 pcc=3D4 !ppc ports=3D10
[    9.119363] ehci_hcd 0000:00:02.1: reset portroute 0 0 0 0 0 0 0 0 0 0=
=20
[    9.119365] ehci_hcd 0000:00:02.1: reset hcc_params a086 caching frame 2=
56/512/1024 park
[    9.119386] ehci_hcd 0000:00:02.1: park 0
[    9.119390] ehci_hcd 0000:00:02.1: reset command 080b12 park=3D3 ithresh=
=3D8 Periodic period=3D1024 Reset HALT
[    9.119392] ehci_hcd 0000:00:02.1: bogus port configuration: cc=3D1 x pc=
c=3D4 < ports=3D10
[    9.119398] ehci_hcd 0000:00:02.1: debug port 1
[    9.144196] PCI: cache line size of 64 is not supported by device 0000:0=
0:02.1
[    9.144198] ehci_hcd 0000:00:02.1: supports USB remote wakeup
[    9.144208] ehci_hcd 0000:00:02.1: irq 23, io mem 0xd9cd0000
[    9.177210] ehci_hcd 0000:00:02.1: reset command 080b02 park=3D3 ithresh=
=3D8 period=3D1024 Reset HALT
[    9.177214] ehci_hcd 0000:00:02.1: init command 010009 (park)=3D0 ithres=
h=3D1 period=3D256 RUN
[    9.182213] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10=
 Dec 2004
[    9.224526] usb usb1: default language 0x0409
[    9.224544] usb usb1: uevent
[    9.224596] usb usb1: usb_probe_device
[    9.224718] usb usb1: configuration #1 chosen from 1 choice
[    9.251790] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    9.251800] usb 1-0:1.0: uevent
[    9.251845] hub 1-0:1.0: usb_probe_interface
[    9.251847] hub 1-0:1.0: usb_probe_interface - got id
[    9.251849] hub 1-0:1.0: USB hub found
[    9.273301] hub 1-0:1.0: 10 ports detected
[    9.296584] hub 1-0:1.0: standalone hub
[    9.296585] hub 1-0:1.0: no power switching (usb 1.0)
[    9.296587] hub 1-0:1.0: individual port over-current protection
[    9.296589] hub 1-0:1.0: power on to power good time: 20ms
[    9.296593] hub 1-0:1.0: local power source is good
[    9.296595] hub 1-0:1.0: trying to enable port power on non-switchable h=
ub
[    9.392436] hub 1-0:1.0: state 7 ports 10 chg 0000 evt 0000
[    9.397652] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    9.397652] ehci_hcd 0000:00:02.1: GetStatus port 6 status 001803 POWER =
sig=3Dj CSC CONNECT
[    9.397658] hub 1-0:1.0: port 6, status 0501, change 0001, 480 Mb/s
[    9.436121] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    9.466835] usb usb1: Product: EHCI Host Controller
[    9.494689] usb usb1: Manufacturer: Linux 2.6.25 ehci_hcd
[    9.501872] hub 1-0:1.0: debounce: port 6: total 100ms stable 100ms stat=
us 0x501
[    9.525704] usb usb1: SerialNumber: 0000:00:02.1
[    9.552753] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHC=
I) Driver
[    9.552756] ohci_hcd: block sizes: ed 80 td 96
[    9.552977] ACPI: PCI Interrupt Link [LNU0] enabled at IRQ 22
[    9.553085] ehci_hcd 0000:00:02.1: port 6 high speed
[    9.553088] ehci_hcd 0000:00:02.1: GetStatus port 6 status 001005 POWER =
sig=3Dse0 PE CONNECT
[    9.568193] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNU0] -> GSI 22=
 (level, high) -> IRQ 22
[    9.603879] usb 1-6: new high speed USB device using ehci_hcd and addres=
s 2
[    9.642682] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    9.642684] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    9.652831] ehci_hcd 0000:00:02.1: port 6 high speed
[    9.652836] ehci_hcd 0000:00:02.1: GetStatus port 6 status 001005 POWER =
sig=3Dse0 PE CONNECT
[    9.662780] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus =
number 2
[    9.695829] ohci_hcd 0000:00:02.0: created debug files
[    9.695835] ohci_hcd 0000:00:02.0: irq 22, io mem 0xd9ce0000
[    9.717165] usb 1-6: uevent
[    9.726877] usb 1-6: usb_probe_device
[    9.726971] usb 1-6: configuration #1 chosen from 1 choice
[    9.734881] usb 1-6: adding 1-6:1.0 (config #1, interface 0)
[    9.734890] usb 1-6:1.0: uevent
[    9.734947] hub 1-6:1.0: usb_probe_interface
[    9.734949] hub 1-6:1.0: usb_probe_interface - got id
[    9.734951] hub 1-6:1.0: USB hub found
[    9.755882] hub 1-6:1.0: 4 ports detected
[    9.778237] hub 1-6:1.0: standalone hub
[    9.778239] hub 1-6:1.0: individual port power switching
[    9.778241] hub 1-6:1.0: individual port over-current protection
[    9.779662] ohci_hcd 0000:00:02.0: OHCI controller state
[    9.779665] ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers
[    9.779667] ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=3Doperatio=
nal CBSR=3D3
[    9.779670] ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=3D0
[    9.779672] ohci_hcd 0000:00:02.0: intrstatus 0x00000004 SF
[    9.779674] ohci_hcd 0000:00:02.0: intrenable 0x8000004a MIE RHSC RD WDH
[    9.779677] ohci_hcd 0000:00:02.0: hcca frame #0003
[    9.779680] ohci_hcd 0000:00:02.0: roothub.a 0100120a POTPGT=3D1 NOCP NP=
S NDP=3D10(10)
[    9.779683] ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=3D0000 DR=3D0=
000
[    9.779685] ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
[    9.779688] ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
[    9.779691] ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
[    9.779693] ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
[    9.779696] ohci_hcd 0000:00:02.0: roothub.portstatus [3] 0x00000100 PPS
[    9.779698] ohci_hcd 0000:00:02.0: roothub.portstatus [4] 0x00000100 PPS
[    9.779701] ohci_hcd 0000:00:02.0: roothub.portstatus [5] 0x00000100 PPS
[    9.779703] ohci_hcd 0000:00:02.0: roothub.portstatus [6] 0x00000100 PPS
[    9.779706] ohci_hcd 0000:00:02.0: roothub.portstatus [7] 0x00000100 PPS
[    9.779709] ohci_hcd 0000:00:02.0: roothub.portstatus [8] 0x00000100 PPS
[    9.779711] ohci_hcd 0000:00:02.0: roothub.portstatus [9] 0x00000100 PPS
[    9.779719] usb usb2: default language 0x0409
[    9.779735] usb usb2: uevent
[    9.779735] hub 1-6:1.0: TT per port
[    9.779738] hub 1-6:1.0: TT requires at most 8 FS bit times (666 ns)
[    9.779740] hub 1-6:1.0: Port indicators are supported
[    9.779742] hub 1-6:1.0: power on to power good time: 100ms
[    9.779819] usb usb2: usb_probe_device
[    9.779897] usb usb2: configuration #1 chosen from 1 choice
[    9.780000] hub 1-6:1.0: local power source is good
[    9.780003] hub 1-6:1.0: enabling power on all ports
[    9.810776] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    9.810786] usb 2-0:1.0: uevent
[    9.810836] hub 2-0:1.0: usb_probe_interface
[    9.810838] hub 2-0:1.0: usb_probe_interface - got id
[    9.810840] hub 2-0:1.0: USB hub found
[    9.832798] hub 2-0:1.0: 10 ports detected
[    9.855792] hub 2-0:1.0: standalone hub
[    9.855793] hub 2-0:1.0: no power switching (usb 1.0)
[    9.855794] hub 2-0:1.0: no over-current protection
[    9.855796] hub 2-0:1.0: power on to power good time: 2ms
[    9.855799] hub 2-0:1.0: local power source is good
[    9.855801] hub 2-0:1.0: trying to enable port power on non-switchable h=
ub
[    9.881674] usb 1-6: link qh256-0001/ffff81007f802140 start 255 [1/0 us]
[    9.881685] usb 1-6: New USB device found, idVendor=3D04b4, idProduct=3D=
6560
[    9.919407] usb 1-6: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    9.959429] hub 1-6:1.0: state 7 ports 4 chg 0000 evt 0000
[    9.960235] hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
[    9.960235] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    9.998292] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   10.030452] usb usb2: Product: OHCI Host Controller
[   10.057298] usb usb2: Manufacturer: Linux 2.6.25 ohci_hcd
[   10.088307] usb usb2: SerialNumber: 0000:00:02.0
[   10.115362] USB Universal Host Controller Interface driver v3.0
[   10.148925] ACPI: PCI Interrupt Link [LNKX] enabled at IRQ 17
[   10.181312] ACPI: PCI Interrupt 0000:01:04.4[B] -> Link [LNKX] -> GSI 17=
 (level, high) -> IRQ 17
[   10.221424] uhci_hcd 0000:01:04.4: UHCI Host Controller
[   10.251423] uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus =
number 3
[   10.294454] uhci_hcd 0000:01:04.4: detected 8 ports
[   10.321291] uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 =
ports
[   10.362287] uhci_hcd 0000:01:04.4: uhci_check_and_reset_hc: cmd =3D 0x00=
00
[   10.362289] uhci_hcd 0000:01:04.4: Performing full reset
[   10.362297] uhci_hcd 0000:01:04.4: HCRESET not completed yet!
[   10.381555] uhci_hcd 0000:01:04.4: irq 17, io base 0x00001800
[   10.414353] usb usb3: default language 0x0409
[   10.414367] usb usb3: uevent
[   10.414414] usb usb3: usb_probe_device
[   10.414494] usb usb3: configuration #1 chosen from 1 choice
[   10.446292] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[   10.446302] usb 3-0:1.0: uevent
[   10.446348] hub 3-0:1.0: usb_probe_interface
[   10.446349] hub 3-0:1.0: usb_probe_interface - got id
[   10.446351] hub 3-0:1.0: USB hub found
[   10.468282] hub 3-0:1.0: 2 ports detected
[   10.490342] hub 3-0:1.0: standalone hub
[   10.490344] hub 3-0:1.0: no power switching (usb 1.0)
[   10.490345] hub 3-0:1.0: individual port over-current protection
[   10.490347] hub 3-0:1.0: power on to power good time: 2ms
[   10.490350] hub 3-0:1.0: local power source is good
[   10.490352] hub 3-0:1.0: trying to enable port power on non-switchable h=
ub
[   10.590194] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   10.590424] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   10.590424] uhci_hcd 0000:01:04.4: port 1 portsc 0083,00
[   10.590432] hub 3-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[   10.628546] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   10.670675] usb usb3: Product: UHCI Host Controller
[   10.694773] hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms stat=
us 0x101
[   10.697498] usb usb3: Manufacturer: Linux 2.6.25 uhci_hcd
[   10.728533] usb usb3: SerialNumber: 0000:01:04.4
[   10.796334] usb 3-1: new full speed USB device using uhci_hcd and addres=
s 2
[   10.961946] usb 3-1: skipped 1 descriptor after interface
[   10.961948] usb 3-1: skipped 1 descriptor after interface
[   10.965184] usb 3-1: default language 0x0409
[   10.971680] usb 3-1: uevent
[   10.971739] usb 3-1: usb_probe_device
[   10.971830] usb 3-1: configuration #1 chosen from 1 choice
[   10.995165] usb 3-1: adding 3-1:1.0 (config #1, interface 0)
[   10.995175] usb 3-1:1.0: uevent
[   10.998525] usb 3-1: adding 3-1:1.1 (config #1, interface 1)
[   10.998534] usb 3-1:1.1: uevent
[   11.001734] usb 3-1: New USB device found, idVendor=3D03f0, idProduct=3D=
1027
[   11.031285] usb 3-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[   11.071040] usb 3-1: Product: Virtual Keyboard
[   11.095214] usb 3-1: Manufacturer: HP
[   11.113327] uhci_hcd 0000:01:04.4: port 2 portsc 0083,00
[   11.113332] hub 3-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[   11.211491] ohci_hcd 0000:00:02.0: auto-stop root hub
[   11.216886] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms stat=
us 0x101
[   11.318873] usb 3-2: new full speed USB device using uhci_hcd and addres=
s 3
[   11.401868] uhci_hcd 0000:01:04.4: port 2 portsc 0083,00
[   11.401877] hub 3-0:1.0: unable to enumerate USB device on port 2
[   11.415960] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   11.415960] usbcore: registered new interface driver usblp
[   11.446985] Initializing USB Mass Storage driver...
[   11.474089] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004
[   11.474096] uhci_hcd 0000:01:04.4: port 2 portsc 0083,00
[   11.474101] hub 3-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[   11.474101] usbcore: registered new interface driver usb-storage
[   11.509030] USB Mass Storage support registered.
[   11.578421] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms stat=
us 0x101
[   11.680410] usb 3-2: new full speed USB device using uhci_hcd and addres=
s 4
[   11.849956] usb 3-2: default language 0x0409
[   11.856448] usb 3-2: uevent
[   11.856504] usb 3-2: usb_probe_device
[   11.856588] usb 3-2: configuration #1 chosen from 1 choice
[   11.869108] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
[   11.869118] usb 3-2:1.0: uevent
[   11.869177] hub 3-2:1.0: usb_probe_interface
[   11.869179] hub 3-2:1.0: usb_probe_interface - got id
[   11.869180] hub 3-2:1.0: USB hub found
[   11.889941] hub 3-2:1.0: 7 ports detected
[   11.912733] hub 3-2:1.0: standalone hub
[   11.912734] hub 3-2:1.0: ganged power switching
[   11.912736] hub 3-2:1.0: individual port over-current protection
[   11.912738] hub 3-2:1.0: power on to power good time: 100ms
[   11.916892] hub 3-2:1.0: local power source is good
[   11.916894] hub 3-2:1.0: enabling power on all ports
[   12.032289] uhci_hcd 0000:01:04.4: reserve dev 4 ep81-INT, period 128, p=
hase 0, 12 us
[   12.035577] usb 3-2: New USB device found, idVendor=3D03f0, idProduct=3D=
1327
[   12.073548] usb 3-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[   12.103747] usb 3-2: Product: Virtual Hub
[   12.125541] usb 3-2: Manufacturer: HP
[   12.139220] hub 3-2:1.0: state 7 ports 7 chg 0000 evt 0000
[   12.154877] usb 3-2: remote wakeup needed for autosuspend
[   12.154877] usbcore: registered new interface driver libusual
[   12.187100] PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64=
 irq 1,12
[   12.195222] hub 1-6:1.0: hub_suspend
[   12.195227] usb 1-6: unlink qh256-0001/ffff81007f802140 start 255 [1/0 u=
s]
[   12.195436] usb 1-6: usb auto-suspend
[   12.206218] hub 2-0:1.0: hub_suspend
[   12.206222] usb usb2: bus auto-suspend
[   12.206225] ohci_hcd 0000:00:02.0: suspend root hub
[   12.231753] serio: i8042 KBD port at 0x60,0x64 irq 1
[   12.260053] serio: i8042 AUX port at 0x60,0x64 irq 12
[   12.293267] mice: PS/2 mouse device common for all mice
[   12.393237] rtc_cmos 00:0a: rtc core: registered rtc_cmos as rtc0
[   12.426885] rtc0: alarms up to one year, y3k
[   12.458019] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised:=
 dm-devel@redhat.com
[   12.507113] cpuidle: using governor ladder
[   12.511303] cpuidle: using governor menu
[   12.533768] usbcore: registered new interface driver hiddev
[   12.565765] usbhid 3-1:1.0: usb_probe_interface
[   12.565767] usbhid 3-1:1.0: usb_probe_interface - got id
[   12.571399] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:09=
=2E0/0000:01:04.4/usb3/3-1/3-1:1.0/input/input2
[   12.616887] uhci_hcd 0000:01:04.4: reserve dev 2 ep81-INT, period 8, pha=
se 4, 17 us
[   12.620001] input,hidraw0: USB HID v1.01 Keyboard [HP Virtual Keyboard] =
on usb-0000:01:04.4-1
[   12.630755] usbhid 3-1:1.1: usb_probe_interface
[   12.630757] usbhid 3-1:1.1: usb_probe_interface - got id
[   12.635969] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:09=
=2E0/0000:01:04.4/usb3/3-1/3-1:1.1/input/input3
[   12.683986] input,hidraw1: USB HID v1.01 Mouse [HP Virtual Keyboard] on =
usb-0000:01:04.4-1
[   12.708442] usbcore: registered new interface driver usbhid
[   12.718396] usbhid: v2.6:USB HID core driver
[   12.730735] Advanced Linux Sound Architecture Driver Version 1.0.16.
[   12.767567] ALSA device list:
[   12.783209]   No soundcards found.
[   12.796002] Netfilter messages via NETLINK v0.30.
[   12.818719] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   12.854350] ctnetlink v0.93: registering with nfnetlink.
[   12.886023] ip_tables: (C) 2000-2006 Netfilter Core Team
[   12.896166] TCP cubic registered
[   12.907754] Initializing XFRM netlink socket
[   12.933087] NET: Registered protocol family 10
[   12.949187] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   12.980414] IPv6 over IPv4 tunneling driver
[   13.005315] NET: Registered protocol family 17
[   13.032151] RPC: Registered udp transport module.
[   13.057597] RPC: Registered tcp transport module.
[   13.086872] registered taskstats version 1
[   13.111519]   Magic number: 1:878:480
[   13.131798] Freeing unused kernel memory: 404k freed
[   13.161489] Write protecting the kernel read-only data: 6388k
[   13.205623] blacklist used greatest stack depth: 5960 bytes left
[   13.272433] usb usb2: uevent
[   13.272459] usb 2-0:1.0: uevent
[   13.272549] usb usb1: uevent
[   13.272565] usb 1-0:1.0: uevent
[   13.272596] usb 1-6: uevent
[   13.272613] usb 1-6:1.0: uevent
[   13.272915] usb usb3: uevent
[   13.272932] usb 3-0:1.0: uevent
[   13.272966] usb 3-1: uevent
[   13.272983] usb 3-1:1.0: uevent
[   13.273071] usb 3-1:1.1: uevent
[   13.273191] usb 3-2: uevent
[   13.273209] usb 3-2:1.0: uevent
[   13.439005] cdrom_id used greatest stack depth: 5752 bytes left
[   13.439005] Fusion MPT base driver 3.04.06
[   13.457302] Copyright (c) 1999-2007 LSI Corporation
[   13.490146] Fusion MPT SAS Host driver 3.04.06
[   13.551998] ACPI: PCI Interrupt 0000:42:01.0[A] -> GSI 24 (level, low) -=
> IRQ 24
[   13.578063] mptbase: ioc0: Initiating bringup
[   13.880672] ioc0: LSISAS1068 B0: Capabilities=3D{Initiator}
[   13.891967] mptbase: ioc0: PCI-MSI enabled
[   14.221645] hub 1-0:1.0: hub_suspend
[   14.221658] usb usb1: bus auto-suspend
[   14.221661] ehci_hcd 0000:00:02.1: suspend root hub
[   37.116157] scsi2 : ioc0: LSISAS1068 B0, FwRev=3D01142100h, Ports=3D1, M=
axQ=3D511, IRQ=3D2296
[   37.192228] scsi 2:0:0:0: Direct-Access     HP       DG036A9BB6       HP=
D0 PQ: 0 ANSI: 5
[   37.240348] sd 2:0:0:0: [sda] 71132960 512-byte hardware sectors (36420 =
MB)
[   37.281548] sd 2:0:0:0: [sda] Write Protect is off
[   37.308076] sd 2:0:0:0: [sda] Mode Sense: cf 00 10 08
[   37.309193] sd 2:0:0:0: [sda] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   37.358843] sd 2:0:0:0: [sda] 71132960 512-byte hardware sectors (36420 =
MB)
[   37.390584] sd 2:0:0:0: [sda] Write Protect is off
[   37.417070] sd 2:0:0:0: [sda] Mode Sense: cf 00 10 08
[   37.418192] sd 2:0:0:0: [sda] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   37.467355]  sda: unknown partition table
[   37.498571] sd 2:0:0:0: [sda] Attached SCSI disk
[   37.515091] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   37.547004] scsi 2:0:1:0: Direct-Access     HP       DG036A9BB6       HP=
D0 PQ: 0 ANSI: 5
[   37.563238] sd 2:0:1:0: [sdb] 71132960 512-byte hardware sectors (36420 =
MB)
[   37.603658] sd 2:0:1:0: [sdb] Write Protect is off
[   37.606247] sd 2:0:1:0: [sdb] Mode Sense: cf 00 10 08
[   37.607792] sd 2:0:1:0: [sdb] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   37.657320] sd 2:0:1:0: [sdb] 71132960 512-byte hardware sectors (36420 =
MB)
[   37.698053] sd 2:0:1:0: [sdb] Write Protect is off
[   37.719056] sd 2:0:1:0: [sdb] Mode Sense: cf 00 10 08
[   37.720179] sd 2:0:1:0: [sdb] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   37.769658]  sdb: unknown partition table
[   37.796433] sd 2:0:1:0: [sdb] Attached SCSI disk
[   37.812559] sd 2:0:1:0: Attached scsi generic sg2 type 0
[   37.845644] scsi 2:0:2:0: Direct-Access     HP       DG036A9BB6       HP=
D0 PQ: 0 ANSI: 5
[   37.892862] sd 2:0:2:0: [sdc] 71132960 512-byte hardware sectors (36420 =
MB)
[   37.933268] sd 2:0:2:0: [sdc] Write Protect is off
[   37.960364] sd 2:0:2:0: [sdc] Mode Sense: cf 00 10 08
[   37.961772] sd 2:0:2:0: [sdc] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   38.002426] sd 2:0:2:0: [sdc] 71132960 512-byte hardware sectors (36420 =
MB)
[   38.034287] sd 2:0:2:0: [sdc] Write Protect is off
[   38.061673] sd 2:0:2:0: [sdc] Mode Sense: cf 00 10 08
[   38.062802] sd 2:0:2:0: [sdc] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   38.111810]  sdc: unknown partition table
[   38.143735] sd 2:0:2:0: [sdc] Attached SCSI disk
[   38.170949] sd 2:0:2:0: Attached scsi generic sg3 type 0
[   38.193002] scsi 2:0:3:0: Direct-Access     HP       DG036A9BB6       HP=
D0 PQ: 0 ANSI: 5
[   38.241046] sd 2:0:3:0: [sdd] 71132960 512-byte hardware sectors (36420 =
MB)
[   38.281113] sd 2:0:3:0: [sdd] Write Protect is off
[   38.308612] sd 2:0:3:0: [sdd] Mode Sense: cf 00 10 08
[   38.310061] sd 2:0:3:0: [sdd] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   38.359811] sd 2:0:3:0: [sdd] 71132960 512-byte hardware sectors (36420 =
MB)
[   38.400494] sd 2:0:3:0: [sdd] Write Protect is off
[   38.427897] sd 2:0:3:0: [sdd] Mode Sense: cf 00 10 08
[   38.429016] sd 2:0:3:0: [sdd] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   38.470830]  sdd: unknown partition table
[   38.504217] sd 2:0:3:0: [sdd] Attached SCSI disk
[   38.521865] sd 2:0:3:0: Attached scsi generic sg4 type 0
[   38.548118] scsi 2:0:4:0: Direct-Access     HP       DG072A8B54       HP=
D7 PQ: 0 ANSI: 5
[   38.584811] sd 2:0:4:0: [sde] 143374738 512-byte hardware sectors (73408=
 MB)
[   38.624570] sd 2:0:4:0: [sde] Write Protect is off
[   38.651330] sd 2:0:4:0: [sde] Mode Sense: db 00 10 08
[   38.652911] sd 2:0:4:0: [sde] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   38.692371] sd 2:0:4:0: [sde] 143374738 512-byte hardware sectors (73408=
 MB)
[   38.723877] sd 2:0:4:0: [sde] Write Protect is off
[   38.750671] sd 2:0:4:0: [sde] Mode Sense: db 00 10 08
[   38.752304] sd 2:0:4:0: [sde] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   38.801145]  sde: unknown partition table
[   38.826062] sd 2:0:4:0: [sde] Attached SCSI disk
[   38.853042] sd 2:0:4:0: Attached scsi generic sg5 type 0
[   38.884752] scsi 2:0:5:0: Direct-Access     HP       DG072A8B54       HP=
D7 PQ: 0 ANSI: 5
[   38.932258] sd 2:0:5:0: [sdf] 143374738 512-byte hardware sectors (73408=
 MB)
[   38.952473] sd 2:0:5:0: [sdf] Write Protect is off
[   38.979207] sd 2:0:5:0: [sdf] Mode Sense: db 00 10 08
[   38.980801] sd 2:0:5:0: [sdf] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   39.030235] sd 2:0:5:0: [sdf] 143374738 512-byte hardware sectors (73408=
 MB)
[   39.066378] sd 2:0:5:0: [sdf] Write Protect is off
[   39.093536] sd 2:0:5:0: [sdf] Mode Sense: db 00 10 08
[   39.094819] sd 2:0:5:0: [sdf] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   39.143703]  sdf: sdf1 sdf2 < sdf5 >
[   39.179850] sd 2:0:5:0: [sdf] Attached SCSI disk
[   39.205591] sd 2:0:5:0: Attached scsi generic sg6 type 0
[   39.217358] scsi 2:0:6:0: Direct-Access     HP       DG072A8B54       HP=
D7 PQ: 0 ANSI: 5
[   39.264821] sd 2:0:6:0: [sdg] 143374738 512-byte hardware sectors (73408=
 MB)
[   39.305985] sd 2:0:6:0: [sdg] Write Protect is off
[   39.332757] sd 2:0:6:0: [sdg] Mode Sense: db 00 10 08
[   39.334373] sd 2:0:6:0: [sdg] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   39.383811] sd 2:0:6:0: [sdg] 143374738 512-byte hardware sectors (73408=
 MB)
[   39.415310] sd 2:0:6:0: [sdg] Write Protect is off
[   39.442123] sd 2:0:6:0: [sdg] Mode Sense: db 00 10 08
[   39.443405] sd 2:0:6:0: [sdg] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   39.492261]  sdg: unknown partition table
[   39.514245] sd 2:0:6:0: [sdg] Attached SCSI disk
[   39.541132] sd 2:0:6:0: Attached scsi generic sg7 type 0
[   39.573641] scsi 2:0:7:0: Direct-Access     HP       DG072A8B54       HP=
D7 PQ: 0 ANSI: 5
[   39.622449] sd 2:0:7:0: [sdh] 143374738 512-byte hardware sectors (73408=
 MB)
[   39.642322] sd 2:0:7:0: [sdh] Write Protect is off
[   39.669452] sd 2:0:7:0: [sdh] Mode Sense: db 00 10 08
[   39.671453] sd 2:0:7:0: [sdh] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   39.702515] sd 2:0:7:0: [sdh] 143374738 512-byte hardware sectors (73408=
 MB)
[   39.723055] sd 2:0:7:0: [sdh] Write Protect is off
[   39.749792] sd 2:0:7:0: [sdh] Mode Sense: db 00 10 08
[   39.751424] sd 2:0:7:0: [sdh] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   39.800335]  sdh: sdh1
[   39.815333] sd 2:0:7:0: [sdh] Attached SCSI disk
[   39.841218] sd 2:0:7:0: Attached scsi generic sg8 type 0
[   39.873299] modprobe used greatest stack depth: 3336 bytes left
[   40.083342] kjournald starting.  Commit interval 5 seconds
[   40.083342] EXT3-fs: mounted filesystem with ordered data mode.
[   41.015076] udevd version 125 started
[   41.139110] usb usb2: uevent
[   41.139131] usb 2-0:1.0: uevent
[   41.139227] usb usb1: uevent
[   41.139245] usb 1-0:1.0: uevent
[   41.139276] usb 1-6: uevent
[   41.139293] usb 1-6:1.0: uevent
[   41.139605] usb usb3: uevent
[   41.139623] usb 3-0:1.0: uevent
[   41.139657] usb 3-1: uevent
[   41.139676] usb 3-1:1.0: uevent
[   41.139766] usb 3-1:1.1: uevent
[   41.139893] usb 3-2: uevent
[   41.139917] usb 3-2:1.0: uevent
[   42.693342] Adding 2963952k swap on /dev/sdf5.  Priority:-1 extents:1 ac=
ross:2963952k
[   43.025504] EXT3 FS on sdf1, internal journal
[   44.935689] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   48.073373] bnx2: eth0 NIC Copper Link is Up, 1000 Mbps full duplex
[   48.113743] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   58.545280] eth0: no IPv6 routers present

--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="post.dmesg"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.25 (dannf@dl585g2) (gcc version 4.3.2 (Deb=
ian 4.3.2-1.1) ) #67 SMP Thu Jul 9 12:11:29 MDT 2009
[    0.000000] Command line: root=3D/dev/disk/by-id/scsi-35000c50000d5ca0f-=
part1 ro console=3Dtty1 console=3DttyS1,115200=20
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e400 (usable)
[    0.000000]  BIOS-e820: 000000000009e400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fd4e000 (usable)
[    0.000000]  BIOS-e820: 000000007fd4e000 - 000000007fd56000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007fd56000 - 000000007fd57000 (usable)
[    0.000000]  BIOS-e820: 000000007fd57000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000047ffff000 (usable)
[    0.000000] Entering add_active_range(0, 0, 158) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 523598) 1 entries of 3200 =
used
[    0.000000] Entering add_active_range(0, 523606, 523607) 2 entries of 32=
00 used
[    0.000000] Entering add_active_range(0, 1048576, 4718591) 3 entries of =
3200 used
[    0.000000] max_pfn_mapped =3D 4718591
[    0.000000] x86: PAT support disabled.
[    0.000000] init_memory_mapping
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000F4F00, 0024 (r2 HP    )
[    0.000000] ACPI: XSDT 7FD4ED80, 0074 (r1 HP     ProLiant        2   =D2=
=04     162E)
[    0.000000] ACPI: FACP 7FD4EE00, 00F4 (r3 HP     A07             2   =D2=
=04     162E)
[    0.000000] ACPI: DSDT 7FD4EF00, 4A59 (r1 HP         DSDT        1 INTL =
20030228)
[    0.000000] ACPI: FACS 7FD4E100, 0040
[    0.000000] ACPI: SPCR 7FD4E140, 0050 (r1 HP     SPCRRBSU        1   =D2=
=04     162E)
[    0.000000] ACPI: HPET 7FD4E1C0, 0038 (r1 HP     ProLiant        2   =D2=
=04     162E)
[    0.000000] ACPI: SPMI 7FD4E200, 0040 (r5 HP     ProLiant        1   =D2=
=04     162E)
[    0.000000] ACPI: ERST 7FD4E240, 01D0 (r1 HP     ProLiant        1   =D2=
=04     162E)
[    0.000000] ACPI: APIC 7FD4E440, 00C6 (r1 HP     ProLiant        2      =
       0)
[    0.000000] ACPI: SRAT 7FD4E600, 01A0 (r1 AMD    FAM_F_10        2 AMD  =
       1)
[    0.000000] ACPI: FFFF 7FD4EA00, 0176 (r1 HP     ProLiant        1   =D2=
=04     162E)
[    0.000000] ACPI: BERT 7FD4EB80, 0030 (r1 HP     ProLiant        1   =D2=
=04     162E)
[    0.000000] ACPI: HEST 7FD4EBC0, 0170 (r1 HP     ProLiant        1   =D2=
=04     162E)
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 2 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 3 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 4 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 5 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 6 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 7 -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] Entering add_active_range(0, 0, 158) 0 entries of 3200 used
[    0.000000] SRAT: Node 0 PXM 0 100000-80000000
[    0.000000] Entering add_active_range(0, 256, 523598) 1 entries of 3200 =
used
[    0.000000] Entering add_active_range(0, 523606, 523607) 2 entries of 32=
00 used
[    0.000000] SRAT: Node 0 PXM 0 100000000-180000000
[    0.000000] Entering add_active_range(0, 1048576, 1572864) 3 entries of =
3200 used
[    0.000000] SRAT: Node 1 PXM 1 180000000-280000000
[    0.000000] Entering add_active_range(1, 1572864, 2621440) 4 entries of =
3200 used
[    0.000000] SRAT: Node 2 PXM 2 280000000-380000000
[    0.000000] Entering add_active_range(2, 2621440, 3670016) 5 entries of =
3200 used
[    0.000000] SRAT: Node 3 PXM 3 380000000-480000000
[    0.000000] Entering add_active_range(3, 3670016, 4718591) 6 entries of =
3200 used
[    0.000000] NUMA: Allocated memnodemap from 1a000 - 23080
[    0.000000] NUMA: Using 20 for the hash shift.
[    0.000000] Bootmem setup node 0 0000000000000000-0000000180000000
[    0.000000]   NODE_DATA [0000000000023080 - 000000000002b07f]
[    0.000000]   bootmap [000000000002c000 -  000000000005bfff] pages 30
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-a8a97b] TEXT DATA BSS
[    0.000000]   early res: 3 [37d54000-37fef2ed] RAMDISK
[    0.000000]   early res: 4 [9e400-fffff] BIOS reserved
[    0.000000]   early res: 5 [8000-19fff] PGTABLE
[    0.000000]   early res: 6 [1a000-2307f] MEMNODEMAP
[    0.000000] Bootmem setup node 1 0000000180000000-0000000280000000
[    0.000000]   NODE_DATA [0000000180000000 - 0000000180007fff]
[    0.000000]   bootmap [0000000180008000 -  0000000180027fff] pages 20
[    0.000000] Bootmem setup node 2 0000000280000000-0000000380000000
[    0.000000]   NODE_DATA [0000000280000000 - 0000000280007fff]
[    0.000000]   bootmap [0000000280008000 -  0000000280027fff] pages 20
[    0.000000] Bootmem setup node 3 0000000380000000-000000047ffff000
[    0.000000]   NODE_DATA [0000000380000000 - 0000000380007fff]
[    0.000000]   bootmap [0000000380008000 -  0000000380027fff] pages 20
[    0.000000]  [ffffe20000000000-ffffe200049fffff] PMD -> [ffff81000120000=
0-ffff810003ffffff] on node 0
[    0.000000]  [ffffe20004a00000-ffffe200053fffff] PMD -> [ffff81000c00000=
0-ffff81000c9fffff] on node 0
[    0.000000]  [ffffe20005400000-ffffe20008bfffff] PMD -> [ffff81018020000=
0-ffff8101839fffff] on node 1
[    0.000000]  [ffffe20008c00000-ffffe2000c3fffff] PMD -> [ffff81028020000=
0-ffff8102839fffff] on node 2
[    0.000000]  [ffffe2000c400000-ffffe2000fbfffff] PMD -> [ffff81038020000=
0-ffff8103839fffff] on node 3
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  4718591
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[7] active PFN ranges
[    0.000000]     0:        0 ->      158
[    0.000000]     0:      256 ->   523598
[    0.000000]     0:   523606 ->   523607
[    0.000000]     0:  1048576 ->  1572864
[    0.000000]     1:  1572864 ->  2621440
[    0.000000]     2:  2621440 ->  3670016
[    0.000000]     3:  3670016 ->  4718591
[    0.000000] On node 0 totalpages: 1047789
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2315 pages reserved
[    0.000000]   DMA zone: 1627 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 505223 pages, LIFO batch:31
[    0.000000]   Normal zone: 7168 pages used for memmap
[    0.000000]   Normal zone: 517120 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] On node 1 totalpages: 1048576
[    0.000000]   DMA zone: 0 pages used for memmap
[    0.000000]   DMA32 zone: 0 pages used for memmap
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1034240 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] On node 2 totalpages: 1048576
[    0.000000]   DMA zone: 0 pages used for memmap
[    0.000000]   DMA32 zone: 0 pages used for memmap
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1034240 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] On node 3 totalpages: 1048575
[    0.000000]   DMA zone: 0 pages used for memmap
[    0.000000]   DMA32 zone: 0 pages used for memmap
[    0.000000]   Normal zone: 14335 pages used for memmap
[    0.000000]   Normal zone: 1034240 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xd9cf0000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 0, address 0xd9cf0000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xd9fd0000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 0, address 0xd9fd0000, GSI 24-=
30
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xd9fe0000] gsi_base[31])
[    0.000000] IOAPIC[2]: apic_id 10, version 0, address 0xd9fe0000, GSI 31=
-37
[    0.000000] ACPI: IOAPIC (id[0x0b] address[0xd9ff0000] gsi_base[38])
[    0.000000] IOAPIC[3]: apic_id 11, version 0, address 0xd9ff0000, GSI 38=
-61
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: NMI_SRC (dfl dfl global_irq 28)
[    0.000000] ACPI: NMI_SRC (dfl dfl global_irq 35)
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10228201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000=
9f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 000000007fd4e000 - 000000007fd=
56000
[    0.000000] PM: Registered nosave memory: 000000007fd57000 - 00000000800=
00000
[    0.000000] PM: Registered nosave memory: 0000000080000000 - 00000000e00=
00000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f00=
00000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec=
00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fed=
00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fee=
00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee=
10000
[    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ffc=
00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 00000001000=
00000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000=
:60000000)
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 44480 bytes of per cpu data
[    0.000000] NR_CPUS: 64, nr_cpu_ids: 8
[    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 4126690
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=3D/dev/disk/by-id/scsi-35000c50000=
d5ca0f-part1 ro console=3Dtty1 console=3DttyS1,115200=20
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000001] Marking TSC unstable due to TSCs unsynchronized
[    0.000003] time.c: Detected 2612.040 MHz processor.
[    0.000011] spurious 8259A interrupt: IRQ7.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty1] enabled
[    0.000999] console [ttyS1] enabled
[    0.000999] Checking aperture...
[    0.000999] Node 0: aperture @ 4000000 size 32 MB
[    0.000999] Aperture pointing to e820 RAM. Ignoring.
[    0.000999] No AGP bridge found
[    0.000999] Your BIOS doesn't leave a aperture memory hole
[    0.000999] Please enable the IOMMU option in the BIOS setup
[    0.000999] This costs you 64 MB of RAM
[    0.000999] Mapping aperture over 65536 KB of RAM @ 4000000
[    0.000999] PM: Registered nosave memory: 0000000004000000 - 00000000080=
00000
[    0.000999] Memory: 16466516k/18874364k available (4337k kernel code, 30=
7548k reserved, 2815k data, 408k init)
[    0.000999] CPA: page pool initialized 1 of 1 pages preallocated
[    0.000999] SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-1, MinObjects=
=3D4, CPUs=3D8, Nodes=3D4
[    0.000999] hpet clockevent registered
[    0.059992] Calibrating delay using timer specific routine.. 5226.24 Bog=
oMIPS (lpj=3D2613121)
[    0.061048] Security Framework initialized
[    0.061995] SELinux:  Initializing.
[    0.063003] SELinux:  Starting in permissive mode
[    0.063011] selinux_register_security:  Registering secondary module cap=
ability
[    0.063991] Capability LSM initialized as secondary
[    0.067041] Dentry cache hash table entries: 2097152 (order: 12, 1677721=
6 bytes)
[    0.081003] Inode-cache hash table entries: 1048576 (order: 11, 8388608 =
bytes)
[    0.087903] Mount-cache hash table entries: 256
[    0.088238] Initializing cgroup subsys ns
[    0.088611] Initializing cgroup subsys cpuacct
[    0.089011] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.089988] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.090988] CPU 0/0 -> Node 0
[    0.091995] CPU: Physical Processor ID: 0
[    0.092987] CPU: Processor Core ID: 0
[    0.094002] ACPI: Core revision 20070126
[    0.114232] CPU0: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
[    0.116983] Using local APIC timer interrupts.
[    0.118982] APIC timer calibration result 12557873
[    0.118984] Detected 12.557 MHz APIC timer.
[    0.120112] Booting processor 1/2 ip 6000
[    0.120112] Initializing CPU#1
[    0.120112] Calibrating delay using timer specific routine.. 5223.83 Bog=
oMIPS (lpj=3D2611917)
[    0.120112] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.120112] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.120112] CPU 1/2 -> Node 1
[    0.120112] CPU: Physical Processor ID: 1
[    0.120112] CPU: Processor Core ID: 0
[    0.120112] x86: PAT support disabled.
[    0.192316] CPU1: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
[    0.195051] Booting processor 2/4 ip 6000
[    0.195051] Initializing CPU#2
[    0.195051] Calibrating delay using timer specific routine.. 5223.89 Bog=
oMIPS (lpj=3D2611947)
[    0.195051] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.195051] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.195051] CPU 2/4 -> Node 2
[    0.195051] CPU: Physical Processor ID: 2
[    0.195051] CPU: Processor Core ID: 0
[    0.195051] x86: PAT support disabled.
[    0.267330] CPU2: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
[    0.270040] Booting processor 3/6 ip 6000
[    0.270040] Initializing CPU#3
[    0.270040] Calibrating delay using timer specific routine.. 5223.89 Bog=
oMIPS (lpj=3D2611949)
[    0.270040] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.270040] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.270040] CPU 3/6 -> Node 3
[    0.270040] CPU: Physical Processor ID: 3
[    0.270040] CPU: Processor Core ID: 0
[    0.270040] x86: PAT support disabled.
[    0.342374] CPU3: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
[    0.345019] Booting processor 4/1 ip 6000
[    0.345019] Initializing CPU#4
[    0.345019] Calibrating delay using timer specific routine.. 5223.81 Bog=
oMIPS (lpj=3D2611905)
[    0.345019] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.345019] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.345019] CPU 4/1 -> Node 0
[    0.345019] CPU: Physical Processor ID: 0
[    0.345019] CPU: Processor Core ID: 1
[    0.345019] x86: PAT support disabled.
[    0.417284] CPU4: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
[    0.420010] Booting processor 5/3 ip 6000
[    0.420010] Initializing CPU#5
[    0.420010] Calibrating delay using timer specific routine.. 5223.87 Bog=
oMIPS (lpj=3D2611939)
[    0.420010] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.420010] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.420010] CPU 5/3 -> Node 1
[    0.420010] CPU: Physical Processor ID: 1
[    0.420010] CPU: Processor Core ID: 1
[    0.420010] x86: PAT support disabled.
[    0.492270] CPU5: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
[    0.494997] Booting processor 6/5 ip 6000
[    0.494997] Initializing CPU#6
[    0.494997] Calibrating delay using timer specific routine.. 5223.85 Bog=
oMIPS (lpj=3D2611928)
[    0.494997] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.494997] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.494997] CPU 6/5 -> Node 2
[    0.494997] CPU: Physical Processor ID: 2
[    0.494997] CPU: Processor Core ID: 1
[    0.494997] x86: PAT support disabled.
[    0.567298] CPU6: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
[    0.569991] Booting processor 7/7 ip 6000
[    0.569991] Initializing CPU#7
[    0.569991] Calibrating delay using timer specific routine.. 5223.84 Bog=
oMIPS (lpj=3D2611923)
[    0.569991] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.569991] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.569991] CPU 7/7 -> Node 3
[    0.569991] CPU: Physical Processor ID: 3
[    0.569991] CPU: Processor Core ID: 1
[    0.569991] x86: PAT support disabled.
[    0.642353] CPU7: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
[    0.644908] Brought up 8 CPUs
[    0.645904] Total of 8 processors activated (41793.25 BogoMIPS).
[    1.067964] khelper used greatest stack depth: 6056 bytes left
[    1.067964] net_namespace: 1176 bytes
[    1.068097] Time: 12:14:05  Date: 07/09/09
[    1.068141] NET: Registered protocol family 16
[    1.154526] No dock devices found.
[    1.155479] TOM: 0000000080000000 aka 2048M
[    1.156318] TOM2: 0000000480000000 aka 18432M
[    1.157317] bus: 00 to node: 00
[    1.157318] bus: 01 to node: 00
[    1.157320] bus: 02 to node: 00
[    1.157321] bus: 03 to node: 00
[    1.157322] bus: 04 to node: 00
[    1.157323] bus: 05 to node: 00
[    1.157324] bus: 06 to node: 00
[    1.157325] bus: 07 to node: 00
[    1.157326] bus: 08 to node: 00
[    1.157327] bus: 09 to node: 00
[    1.157328] bus: 0a to node: 00
[    1.157330] bus: 0b to node: 00
[    1.157331] bus: 0c to node: 00
[    1.157332] bus: 0d to node: 00
[    1.157333] bus: 0e to node: 00
[    1.157334] bus: 0f to node: 00
[    1.157335] bus: 10 to node: 00
[    1.157336] bus: 11 to node: 00
[    1.157337] bus: 12 to node: 00
[    1.157338] bus: 13 to node: 00
[    1.157340] bus: 14 to node: 00
[    1.157341] bus: 15 to node: 00
[    1.157342] bus: 16 to node: 00
[    1.157343] bus: 17 to node: 00
[    1.157344] bus: 18 to node: 00
[    1.157345] bus: 19 to node: 00
[    1.157346] bus: 1a to node: 00
[    1.157347] bus: 1b to node: 00
[    1.157349] bus: 1c to node: 00
[    1.157350] bus: 1d to node: 00
[    1.157351] bus: 1e to node: 00
[    1.157352] bus: 1f to node: 00
[    1.157353] bus: 20 to node: 00
[    1.157354] bus: 21 to node: 00
[    1.157355] bus: 22 to node: 00
[    1.157356] bus: 23 to node: 00
[    1.157358] bus: 24 to node: 00
[    1.157359] bus: 25 to node: 00
[    1.157360] bus: 26 to node: 00
[    1.157361] bus: 27 to node: 00
[    1.157362] bus: 28 to node: 00
[    1.157363] bus: 29 to node: 00
[    1.157364] bus: 2a to node: 00
[    1.157365] bus: 2b to node: 00
[    1.157366] bus: 2c to node: 00
[    1.157368] bus: 2d to node: 00
[    1.157369] bus: 2e to node: 00
[    1.157370] bus: 2f to node: 00
[    1.157371] bus: 30 to node: 00
[    1.157372] bus: 31 to node: 00
[    1.157373] bus: 32 to node: 00
[    1.157374] bus: 33 to node: 00
[    1.157375] bus: 34 to node: 00
[    1.157376] bus: 35 to node: 00
[    1.157378] bus: 36 to node: 00
[    1.157379] bus: 37 to node: 00
[    1.157380] bus: 38 to node: 00
[    1.157381] bus: 39 to node: 00
[    1.157382] bus: 3a to node: 00
[    1.157383] bus: 3b to node: 00
[    1.157384] bus: 3c to node: 00
[    1.157385] bus: 3d to node: 00
[    1.157386] bus: 3e to node: 00
[    1.157388] bus: 3f to node: 00
[    1.157389] bus: 40 to node: 01
[    1.157390] bus: 41 to node: 01
[    1.157391] bus: 42 to node: 01
[    1.157392] bus: 43 to node: 01
[    1.157393] bus: 44 to node: 01
[    1.157394] bus: 45 to node: 01
[    1.157395] bus: 46 to node: 01
[    1.157397] bus: 47 to node: 01
[    1.157398] bus: 48 to node: 01
[    1.157399] bus: 49 to node: 01
[    1.157400] bus: 4a to node: 01
[    1.157401] bus: 4b to node: 01
[    1.157402] bus: 4c to node: 01
[    1.157403] bus: 4d to node: 01
[    1.157404] bus: 4e to node: 01
[    1.157405] bus: 4f to node: 01
[    1.157406] bus: 50 to node: 01
[    1.157408] bus: 51 to node: 01
[    1.157409] bus: 52 to node: 01
[    1.157410] bus: 53 to node: 01
[    1.157411] bus: 54 to node: 01
[    1.157412] bus: 55 to node: 01
[    1.157413] bus: 56 to node: 01
[    1.157414] bus: 57 to node: 01
[    1.157415] bus: 58 to node: 01
[    1.157416] bus: 59 to node: 01
[    1.157418] bus: 5a to node: 01
[    1.157419] bus: 5b to node: 01
[    1.157420] bus: 5c to node: 01
[    1.157421] bus: 5d to node: 01
[    1.157422] bus: 5e to node: 01
[    1.157423] bus: 5f to node: 01
[    1.157424] bus: 60 to node: 01
[    1.157425] bus: 61 to node: 01
[    1.157427] bus: 62 to node: 01
[    1.157428] bus: 63 to node: 01
[    1.157429] bus: 64 to node: 01
[    1.157430] bus: 65 to node: 01
[    1.157431] bus: 66 to node: 01
[    1.157432] bus: 67 to node: 01
[    1.157433] bus: 68 to node: 01
[    1.157434] bus: 69 to node: 01
[    1.157435] bus: 6a to node: 01
[    1.157436] bus: 6b to node: 01
[    1.157438] bus: 6c to node: 01
[    1.157439] bus: 6d to node: 01
[    1.157440] bus: 6e to node: 01
[    1.157441] bus: 6f to node: 01
[    1.157442] bus: 70 to node: 01
[    1.157443] bus: 71 to node: 01
[    1.157444] bus: 72 to node: 01
[    1.157445] bus: 73 to node: 01
[    1.157446] bus: 74 to node: 01
[    1.157448] bus: 75 to node: 01
[    1.157449] bus: 76 to node: 01
[    1.157450] bus: 77 to node: 01
[    1.157451] bus: 78 to node: 01
[    1.157452] bus: 79 to node: 01
[    1.157453] bus: 7a to node: 01
[    1.157454] bus: 7b to node: 01
[    1.157455] bus: 7c to node: 01
[    1.157457] bus: 7d to node: 01
[    1.157458] bus: 7e to node: 01
[    1.157459] bus: 7f to node: 01
[    1.157461] bus: [00,3f] on node 0 link 1
[    1.157462] bus: 00 index 0 io port: [0, 2fff]
[    1.157464] bus: 00 index 1 mmio: [80000000, d9efffff]
[    1.157465] bus: 00 index 2 mmio: [dff00000, e3ffffff]
[    1.157467] bus: 00 index 3 mmio: [a0000, bffff]
[    1.157468] bus: 00 index 4 mmio: [e8000000, ffffffff]
[    1.157470] bus: 00 index 5 mmio: [480000000, fbffffffff]
[    1.157472] bus: [40,7f] on node 1 link 2
[    1.157473] bus: 40 index 0 io port: [3000, ffff]
[    1.157475] bus: 40 index 1 mmio: [d9f00000, dfefffff]
[    1.157476] bus: 40 index 2 mmio: [e4000000, e7ffffff]
[    1.157501] ACPI: bus type pci registered
[    1.158417] PCI: Using configuration type 1 for base access
[    1.164586] ACPI: EC: Look up EC in DSDT
[    1.167975] ACPI: SSDT 7FD58000, 09BC (r2 HP     PNOWSSDT        2 HP   =
       1)
[    1.169901] ACPI: Interpreter enabled
[    1.170315] ACPI: (supports S0 S4 S5)
[    1.172314] ACPI: Using IOAPIC for interrupt routing
[    1.180145] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.180375] PCI: Scanning bus 0000:00
[    1.180393] PCI: Found 0000:00:00.0 [10de/005e] 000580 00
[    1.180421] PCI: Found 0000:00:01.0 [10de/0051] 000601 00
[    1.180432] pci 0000:00:01.0: calling nvidia_force_enable_hpet+0x0/0xa3()
[    1.180451] PCI: Found 0000:00:02.0 [10de/005a] 000c03 00
[    1.180473] PCI: Found 0000:00:02.1 [10de/005b] 000c03 00
[    1.180499] PCI: Found 0000:00:06.0 [10de/0053] 000101 00
[    1.180516] PCI: Found 0000:00:09.0 [10de/005c] 000604 01
[    1.180530] PCI: Found 0000:00:0c.0 [10de/005d] 000604 01
[    1.180545] PCI: Found 0000:00:0d.0 [10de/005d] 000604 01
[    1.180562] PCI: Found 0000:00:0e.0 [10de/005d] 000604 01
[    1.180584] PCI: Found 0000:00:18.0 [1022/1100] 000600 00
[    1.180595] PCI: Found 0000:00:18.1 [1022/1101] 000600 00
[    1.180605] PCI: Found 0000:00:18.2 [1022/1102] 000600 00
[    1.180617] PCI: Found 0000:00:18.3 [1022/1103] 000600 00
[    1.180632] PCI: Found 0000:00:19.0 [1022/1100] 000600 00
[    1.180644] PCI: Found 0000:00:19.1 [1022/1101] 000600 00
[    1.180655] PCI: Found 0000:00:19.2 [1022/1102] 000600 00
[    1.181322] PCI: Found 0000:00:19.3 [1022/1103] 000600 00
[    1.181337] PCI: Found 0000:00:1a.0 [1022/1100] 000600 00
[    1.181350] PCI: Found 0000:00:1a.1 [1022/1101] 000600 00
[    1.181361] PCI: Found 0000:00:1a.2 [1022/1102] 000600 00
[    1.181373] PCI: Found 0000:00:1a.3 [1022/1103] 000600 00
[    1.181390] PCI: Found 0000:00:1b.0 [1022/1100] 000600 00
[    1.181403] PCI: Found 0000:00:1b.1 [1022/1101] 000600 00
[    1.181415] PCI: Found 0000:00:1b.2 [1022/1102] 000600 00
[    1.181432] PCI: Found 0000:00:1b.3 [1022/1103] 000600 00
[    1.181445] PCI: Fixups for bus 0000:00
[    1.181448] PCI: Scanning behind PCI bridge 0000:00:09.0, config 010100,=
 pass 0
[    1.181452] PCI: Scanning bus 0000:01
[    1.181469] PCI: Found 0000:01:03.0 [1002/515e] 000300 00
[    1.181510] PCI: Found 0000:01:04.0 [0e11/b203] 000880 00
[    1.181552] PCI: Found 0000:01:04.2 [0e11/b204] 000880 00
[    1.181600] PCI: Found 0000:01:04.4 [103c/3300] 000c03 00
[    1.181646] PCI: Found 0000:01:04.6 [103c/3302] 000c07 00
[    1.181695] PCI: Fixups for bus 0000:01
[    1.181696] PCI: Transparent bridge - 0000:00:09.0
[    1.182314] PCI: Bus scan for 0000:01 returning with max=3D01
[    1.182317] PCI: Scanning behind PCI bridge 0000:00:0c.0, config 0a0800,=
 pass 0
[    1.182320] PCI: Scanning bus 0000:08
[    1.182347] PCI: Fixups for bus 0000:08
[    1.182351] PCI: Bus scan for 0000:08 returning with max=3D08
[    1.182354] PCI: Scanning behind PCI bridge 0000:00:0d.0, config 070500,=
 pass 0
[    1.182359] PCI: Scanning bus 0000:05
[    1.182386] PCI: Fixups for bus 0000:05
[    1.182391] PCI: Bus scan for 0000:05 returning with max=3D05
[    1.182393] PCI: Scanning behind PCI bridge 0000:00:0e.0, config 040200,=
 pass 0
[    1.182396] PCI: Scanning bus 0000:02
[    1.182423] PCI: Fixups for bus 0000:02
[    1.182427] PCI: Bus scan for 0000:02 returning with max=3D02
[    1.182430] PCI: Scanning behind PCI bridge 0000:00:09.0, config 010100,=
 pass 1
[    1.182432] PCI: Scanning behind PCI bridge 0000:00:0c.0, config 0a0800,=
 pass 1
[    1.182435] PCI: Scanning behind PCI bridge 0000:00:0d.0, config 070500,=
 pass 1
[    1.182438] PCI: Scanning behind PCI bridge 0000:00:0e.0, config 040200,=
 pass 1
[    1.182441] PCI: Bus scan for 0000:00 returning with max=3D0a
[    1.182446] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.182552] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
[    1.183339] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE0._PRT]
[    1.183469] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE1._PRT]
[    1.183600] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE2._PRT]
[    1.186751] ACPI: PCI Root Bridge [PCI1] (0000:40)
[    1.187368] PCI: Scanning bus 0000:40
[    1.187387] PCI: Found 0000:40:00.0 [10de/005e] 000580 00
[    1.187420] PCI: Found 0000:40:01.0 [10de/00d3] 000580 00
[    1.187458] PCI: Found 0000:40:0b.0 [10de/005d] 000604 01
[    1.187481] PCI: Found 0000:40:0c.0 [10de/005d] 000604 01
[    1.187503] PCI: Found 0000:40:0d.0 [10de/005d] 000604 01
[    1.187525] PCI: Found 0000:40:0e.0 [10de/005d] 000604 01
[    1.187549] PCI: Found 0000:40:10.0 [1022/7458] 000604 01
[    1.187565] PCI: Found 0000:40:10.1 [1022/7459] 000800 00
[    1.187599] PCI: Found 0000:40:11.0 [1022/7458] 000604 01
[    1.187615] PCI: Found 0000:40:11.1 [1022/7459] 000800 00
[    1.187644] PCI: Fixups for bus 0000:40
[    1.187646] PCI: Scanning behind PCI bridge 0000:40:0b.0, config 514f40,=
 pass 0
[    1.187651] PCI: Scanning bus 0000:4f
[    1.187675] PCI: Fixups for bus 0000:4f
[    1.187681] PCI: Bus scan for 0000:4f returning with max=3D4f
[    1.187684] PCI: Scanning behind PCI bridge 0000:40:0c.0, config 4e4c40,=
 pass 0
[    1.187687] PCI: Scanning bus 0000:4c
[    1.187712] PCI: Fixups for bus 0000:4c
[    1.187717] PCI: Bus scan for 0000:4c returning with max=3D4c
[    1.187720] PCI: Scanning behind PCI bridge 0000:40:0d.0, config 4b4940,=
 pass 0
[    1.187724] PCI: Scanning bus 0000:49
[    1.187748] PCI: Fixups for bus 0000:49
[    1.187754] PCI: Bus scan for 0000:49 returning with max=3D49
[    1.187756] PCI: Scanning behind PCI bridge 0000:40:0e.0, config 484640,=
 pass 0
[    1.188313] PCI: Scanning bus 0000:46
[    1.188338] PCI: Fixups for bus 0000:46
[    1.188343] PCI: Bus scan for 0000:46 returning with max=3D46
[    1.188346] PCI: Scanning behind PCI bridge 0000:40:10.0, config 414140,=
 pass 0
[    1.188351] PCI: Scanning bus 0000:41
[    1.188370] PCI: Found 0000:41:01.0 [14e4/164a] 000200 00
[    1.188409] PCI: Found 0000:41:02.0 [14e4/164a] 000200 00
[    1.188448] PCI: Fixups for bus 0000:41
[    1.188453] PCI: Bus scan for 0000:41 returning with max=3D41
[    1.188456] PCI: Scanning behind PCI bridge 0000:40:11.0, config 454240,=
 pass 0
[    1.188460] PCI: Scanning bus 0000:42
[    1.188479] PCI: Found 0000:42:01.0 [1000/0054] 000100 00
[    1.188518] PCI: Found 0000:42:02.0 [103c/3220] 000104 00
[    1.188557] PCI: Fixups for bus 0000:42
[    1.188562] PCI: Bus scan for 0000:42 returning with max=3D42
[    1.188565] PCI: Scanning behind PCI bridge 0000:40:0b.0, config 514f40,=
 pass 1
[    1.188569] PCI: Scanning behind PCI bridge 0000:40:0c.0, config 4e4c40,=
 pass 1
[    1.188572] PCI: Scanning behind PCI bridge 0000:40:0d.0, config 4b4940,=
 pass 1
[    1.188575] PCI: Scanning behind PCI bridge 0000:40:0e.0, config 484640,=
 pass 1
[    1.188579] PCI: Scanning behind PCI bridge 0000:40:10.0, config 414140,=
 pass 1
[    1.188582] PCI: Scanning behind PCI bridge 0000:40:11.0, config 454240,=
 pass 1
[    1.188585] PCI: Bus scan for 0000:40 returning with max=3D51
[    1.188592] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.BRGA._PRT]
[    1.188691] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.BRGB._PRT]
[    1.188865] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE0._PRT]
[    1.189005] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE1._PRT]
[    1.189143] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE2._PRT]
[    1.189280] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE3._PRT]
[    1.191319] ACPI: PCI Interrupt Link [LNKW] (IRQs 16) *0, disabled.
[    1.195468] ACPI: PCI Interrupt Link [LNKX] (IRQs 17) *0, disabled.
[    1.199466] ACPI: PCI Interrupt Link [LNKY] (IRQs 18) *0, disabled.
[    1.202849] ACPI: PCI Interrupt Link [LNKZ] (IRQs 19) *0, disabled.
[    1.206461] ACPI: PCI Interrupt Link [LNU0] (IRQs 22) *5
[    1.209410] ACPI: PCI Interrupt Link [LNU2] (IRQs 23) *10
[    1.212438] ACPI: PCI Interrupt Link [LNKA] (IRQs 54) *0, disabled.
[    1.215781] ACPI: PCI Interrupt Link [LNKB] (IRQs 55) *0, disabled.
[    1.218772] ACPI: PCI Interrupt Link [LNKC] (IRQs 56) *0, disabled.
[    1.221785] ACPI: PCI Interrupt Link [LNKD] (IRQs 57) *0, disabled.
[    1.225491] Linux Plug and Play Support v0.97 (c) Adam Belay
[    1.226350] pnp: PnP ACPI init
[    1.227310] ACPI: bus type pnp registered
[    1.233440] pnp: PnP ACPI: found 16 devices
[    1.234304] ACPI: ACPI bus type pnp unregistered
[    1.236350] SCSI subsystem initialized
[    1.237556] libata version 3.00 loaded.
[    1.237710] usbcore: registered new interface driver usbfs
[    1.238361] usbcore: registered new interface driver hub
[    1.239370] usbcore: registered new device driver usb
[    1.241382] PCI: Using ACPI for IRQ routing
[    1.250320] NetLabel: Initializing
[    1.251302] NetLabel:  domain hash size =3D 128
[    1.252301] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    1.253313] NetLabel:  unlabeled traffic allowed by default
[    1.254303] DMAR:parse DMAR table failure.
[    1.255415] PCI-DMA: Disabling AGP.
[    1.258094] PCI-DMA: aperture base @ 4000000 size 65536 KB
[    1.258300] PCI-DMA: using GART IOMMU.
[    1.259302] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.261586] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    1.264702] hpet0: 3 32-bit timers, 25000000 Hz
[    1.267306] Switched to high resolution mode on CPU 0
[    2.526693] Switched to high resolution mode on CPU 4
[    3.107667] Switched to high resolution mode on CPU 1
[    3.107667] Switched to high resolution mode on CPU 5
[    3.107667] Switched to high resolution mode on CPU 2
[    3.107667] Switched to high resolution mode on CPU 6
[    3.107667] Switched to high resolution mode on CPU 3
[    3.107667] Switched to high resolution mode on CPU 7
[    3.107667] ACPI: RTC can wake from S4
[    3.132946] system 00:01: ioport range 0x408-0x40f has been reserved
[    3.157904] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    3.194551] system 00:01: ioport range 0x700-0x73f has been reserved
[    3.198288] system 00:01: ioport range 0x800-0x8fe has been reserved
[    3.228149] system 00:01: ioport range 0x900-0x9fe has been reserved
[    3.264581] system 00:01: ioport range 0x9ff-0x9ff has been reserved
[    3.293219] system 00:01: ioport range 0xa00-0xafe has been reserved
[    3.329567] system 00:01: ioport range 0xaff-0xaff has been reserved
[    3.355566] system 00:01: ioport range 0xb00-0xbfe has been reserved
[    3.391978] system 00:01: ioport range 0xbff-0xbff has been reserved
[    3.427525] system 00:01: ioport range 0xc80-0xc83 has been reserved
[    3.455298] system 00:01: ioport range 0xcd4-0xcd7 has been reserved
[    3.491561] system 00:01: ioport range 0xcf9-0xcf9 could not be reserved
[    3.529549] system 00:01: ioport range 0xf50-0xf58 has been reserved
[    3.565510] system 00:01: ioport range 0xca0-0xca1 has been reserved
[    3.569256] system 00:01: ioport range 0xca4-0xca5 has been reserved
[    3.605550] system 00:01: ioport range 0xc00-0xc03 has been reserved
[    3.631447] system 00:01: ioport range 0x2f8-0x2ff has been reserved
[    3.668986]   got res [d9d00000:d9d1ffff] bus [d9d00000:d9d1ffff] flags =
27200 for BAR 6 of 0000:01:03.0
[    3.668989]   got res [d9d20000:d9d2ffff] bus [d9d20000:d9d2ffff] flags =
27200 for BAR 6 of 0000:01:04.2
[    3.668992] PCI: Bridge: 0000:00:09.0
[    3.689347]   IO window: 1000-2fff
[    3.709284]   MEM window: 0xd9d00000-0xd9efffff
[    3.734192]   PREFETCH window: 0x00000000d0000000-0x00000000d7ffffff
[    3.767539] PCI: Bridge: 0000:00:0c.0
[    3.787162]   IO window: disabled.
[    3.807282]   MEM window: disabled.
[    3.826178]   PREFETCH window: disabled.
[    3.849160] PCI: Bridge: 0000:00:0d.0
[    3.869163]   IO window: disabled.
[    3.889162]   MEM window: disabled.
[    3.908154]   PREFETCH window: disabled.
[    3.931165] PCI: Bridge: 0000:00:0e.0
[    3.951170]   IO window: disabled.
[    3.971163]   MEM window: disabled.
[    3.973611]   PREFETCH window: disabled.
[    3.981136] PCI: Setting latency timer of device 0000:00:09.0 to 64
[    3.981143] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    3.981148] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    3.981153] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    3.981159] PCI: Bridge: 0000:40:0b.0
[    3.992176]   IO window: disabled.
[    4.011147]   MEM window: disabled.
[    4.030575]   PREFETCH window: disabled.
[    4.053147] PCI: Bridge: 0000:40:0c.0
[    4.073161]   IO window: disabled.
[    4.093148]   MEM window: disabled.
[    4.112140]   PREFETCH window: disabled.
[    4.135135] PCI: Bridge: 0000:40:0d.0
[    4.155193]   IO window: disabled.
[    4.174183]   MEM window: disabled.
[    4.193165]   PREFETCH window: disabled.
[    4.199609] PCI: Bridge: 0000:40:0e.0
[    4.220147]   IO window: disabled.
[    4.240068]   MEM window: disabled.
[    4.257315]   PREFETCH window: disabled.
[    4.279139]   got res [d9f00000:d9f1ffff] bus [d9f00000:d9f1ffff] flags =
27200 for BAR 6 of 0000:41:01.0
[    4.279142]   got res [d9f20000:d9f3ffff] bus [d9f20000:d9f3ffff] flags =
27200 for BAR 6 of 0000:41:02.0
[    4.279144] PCI: Bridge: 0000:40:10.0
[    4.299135]   IO window: disabled.
[    4.319148]   MEM window: 0xda000000-0xddffffff
[    4.333140]   PREFETCH window: 0x00000000d9f00000-0x00000000d9ffffff
[    4.370170]   got res [de000000:de1fffff] bus [de000000:de1fffff] flags =
27200 for BAR 6 of 0000:42:01.0
[    4.370173]   got res [de200000:de23ffff] bus [de200000:de23ffff] flags =
27200 for BAR 6 of 0000:42:02.0
[    4.370175] PCI: Bridge: 0000:40:11.0
[    4.390143]   IO window: 3000-3fff
[    4.410177]   MEM window: 0xdfe00000-0xdfefffff
[    4.435157]   PREFETCH window: 0x00000000de000000-0x00000000de2fffff
[    4.472159] PCI: Setting latency timer of device 0000:40:0b.0 to 64
[    4.472165] PCI: Setting latency timer of device 0000:40:0c.0 to 64
[    4.472172] PCI: Setting latency timer of device 0000:40:0d.0 to 64
[    4.472178] PCI: Setting latency timer of device 0000:40:0e.0 to 64
[    4.472212] NET: Registered protocol family 2
[    4.494783] IP route cache hash table entries: 524288 (order: 10, 419430=
4 bytes)
[    4.531692] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    4.581320] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    4.610273] TCP: Hash tables configured (established 524288 bind 65536)
[    4.647561] TCP reno registered
[    4.668827] NET: Registered protocol family 1
[    4.688834] checking if image is initramfs... it is
[    4.882738] Freeing initrd memory: 2668k freed
[    4.913830] microcode: CPU0 not a capable Intel processor
[    4.927851] microcode: CPU1 not a capable Intel processor
[    4.940553] microcode: CPU2 not a capable Intel processor
[    4.971303] microcode: CPU3 not a capable Intel processor
[    4.971303] microcode: CPU4 not a capable Intel processor
[    5.017031] microcode: CPU5 not a capable Intel processor
[    5.054072] microcode: CPU6 not a capable Intel processor
[    5.083505] microcode: CPU7 not a capable Intel processor
[    5.104468] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet=
=2Eco.uk>
[    5.147060] audit: initializing netlink socket (disabled)
[    5.167030] type=3D2000 audit(1247141644.906:1): initialized
[    5.195810] Total HugeTLB memory allocated, 0
[    5.223594] VFS: Disk quotas dquot_6.5.1
[    5.237709] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.275549] SELinux:  Registering netfilter hooks
[    5.275747] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    5.318451] io scheduler noop registered
[    5.340224] io scheduler anticipatory registered
[    5.356173] io scheduler deadline registered
[    5.379496] io scheduler cfq registered (default)
[    5.405233] pci 0000:00:00.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.405256] pci 0000:00:00.0: Enabling HT MSI Mapping
[    5.434249] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.434256] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.434260] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xaf()
[    5.434265] pci 0000:00:01.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.434272] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.434274] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.434277] pci 0000:00:01.0: calling pci_fixup_video+0x0/0xaf()
[    5.434281] pci 0000:00:02.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.434289] pci 0000:00:02.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.434292] pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.444865] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xaf()
[    5.444870] pci 0000:00:02.1: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.444879] pci 0000:00:02.1: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.444882] pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0x447()
[    5.444889] pci 0000:00:02.1: EHCI: BIOS handoff
[    5.456422] pci 0000:00:02.1: calling pci_fixup_video+0x0/0xaf()
[    5.456427] pci 0000:00:06.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.456434] pci 0000:00:06.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.456437] pci 0000:00:06.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.456440] pci 0000:00:06.0: calling pci_fixup_video+0x0/0xaf()
[    5.456444] pci 0000:00:09.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.456450] pci 0000:00:09.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.456453] pci 0000:00:09.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.456456] pci 0000:00:09.0: calling pci_fixup_video+0x0/0xaf()
[    5.456460] pci 0000:00:0c.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.456469] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    5.476827] pci 0000:00:0c.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/=
0x7a()
[    5.476834] pci 0000:00:0c.0: Found enabled HT MSI Mapping
[    5.493134] pci 0000:00:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_ca=
p+0x0/0x6a()
[    5.493138] pci 0000:00:0c.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.493140] pci 0000:00:0c.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.493143] pci 0000:00:0c.0: calling pci_fixup_video+0x0/0xaf()
[    5.493148] pci 0000:00:0d.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.493156] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    5.517594] pci 0000:00:0d.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/=
0x7a()
[    5.517600] pci 0000:00:0d.0: Found enabled HT MSI Mapping
[    5.549104] pci 0000:00:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_ca=
p+0x0/0x6a()
[    5.549107] pci 0000:00:0d.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.549110] pci 0000:00:0d.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.549113] pci 0000:00:0d.0: calling pci_fixup_video+0x0/0xaf()
[    5.549117] pci 0000:00:0e.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.549125] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    5.577105] pci 0000:00:0e.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/=
0x7a()
[    5.577111] pci 0000:00:0e.0: Found enabled HT MSI Mapping
[    5.609127] pci 0000:00:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_ca=
p+0x0/0x6a()
[    5.609130] pci 0000:00:0e.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609133] pci 0000:00:0e.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609135] pci 0000:00:0e.0: calling pci_fixup_video+0x0/0xaf()
[    5.609139] pci 0000:00:18.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609142] pci 0000:00:18.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609145] pci 0000:00:18.0: calling pci_fixup_video+0x0/0xaf()
[    5.609149] pci 0000:00:18.1: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609151] pci 0000:00:18.1: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609154] pci 0000:00:18.1: calling pci_fixup_video+0x0/0xaf()
[    5.609158] pci 0000:00:18.2: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609161] pci 0000:00:18.2: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609163] pci 0000:00:18.2: calling pci_fixup_video+0x0/0xaf()
[    5.609167] pci 0000:00:18.3: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609170] pci 0000:00:18.3: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609173] pci 0000:00:18.3: calling pci_fixup_video+0x0/0xaf()
[    5.609177] pci 0000:00:19.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609179] pci 0000:00:19.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609182] pci 0000:00:19.0: calling pci_fixup_video+0x0/0xaf()
[    5.609186] pci 0000:00:19.1: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609189] pci 0000:00:19.1: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609191] pci 0000:00:19.1: calling pci_fixup_video+0x0/0xaf()
[    5.609195] pci 0000:00:19.2: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609198] pci 0000:00:19.2: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609201] pci 0000:00:19.2: calling pci_fixup_video+0x0/0xaf()
[    5.609205] pci 0000:00:19.3: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609207] pci 0000:00:19.3: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609210] pci 0000:00:19.3: calling pci_fixup_video+0x0/0xaf()
[    5.609214] pci 0000:00:1a.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609216] pci 0000:00:1a.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609219] pci 0000:00:1a.0: calling pci_fixup_video+0x0/0xaf()
[    5.609223] pci 0000:00:1a.1: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609226] pci 0000:00:1a.1: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609229] pci 0000:00:1a.1: calling pci_fixup_video+0x0/0xaf()
[    5.609233] pci 0000:00:1a.2: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609235] pci 0000:00:1a.2: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609238] pci 0000:00:1a.2: calling pci_fixup_video+0x0/0xaf()
[    5.609242] pci 0000:00:1a.3: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609245] pci 0000:00:1a.3: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609247] pci 0000:00:1a.3: calling pci_fixup_video+0x0/0xaf()
[    5.609251] pci 0000:00:1b.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609254] pci 0000:00:1b.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609257] pci 0000:00:1b.0: calling pci_fixup_video+0x0/0xaf()
[    5.609261] pci 0000:00:1b.1: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609263] pci 0000:00:1b.1: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609266] pci 0000:00:1b.1: calling pci_fixup_video+0x0/0xaf()
[    5.609270] pci 0000:00:1b.2: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609272] pci 0000:00:1b.2: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609275] pci 0000:00:1b.2: calling pci_fixup_video+0x0/0xaf()
[    5.609279] pci 0000:00:1b.3: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609282] pci 0000:00:1b.3: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609285] pci 0000:00:1b.3: calling pci_fixup_video+0x0/0xaf()
[    5.609289] pci 0000:01:03.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609292] pci 0000:01:03.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609295] pci 0000:01:03.0: calling pci_fixup_video+0x0/0xaf()
[    5.609299] pci 0000:01:03.0: Boot video device
[    5.609302] pci 0000:01:04.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609305] pci 0000:01:04.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609307] pci 0000:01:04.0: calling pci_fixup_video+0x0/0xaf()
[    5.609312] pci 0000:01:04.2: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609314] pci 0000:01:04.2: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609317] pci 0000:01:04.2: calling pci_fixup_video+0x0/0xaf()
[    5.609321] pci 0000:01:04.4: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.609324] pci 0000:01:04.4: calling quirk_usb_early_handoff+0x0/0x447()
[    5.609330] pci 0000:01:04.4: uhci_check_and_reset_hc: legsup =3D 0x0010
[    5.609332] pci 0000:01:04.4: Performing full reset
[    5.609341] pci 0000:01:04.4: HCRESET not completed yet!
[    5.640051] pci 0000:01:04.4: calling pci_fixup_video+0x0/0xaf()
[    5.640056] pci 0000:01:04.6: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.640058] pci 0000:01:04.6: calling quirk_usb_early_handoff+0x0/0x447()
[    5.640061] pci 0000:01:04.6: calling pci_fixup_video+0x0/0xaf()
[    5.640066] pci 0000:40:00.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.640078] pci 0000:40:00.0: Enabling HT MSI Mapping
[    5.660764] pci 0000:40:00.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.660767] pci 0000:40:00.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.660770] pci 0000:40:00.0: calling pci_fixup_video+0x0/0xaf()
[    5.660775] pci 0000:40:01.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.660781] pci 0000:40:01.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.660784] pci 0000:40:01.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.660787] pci 0000:40:01.0: calling pci_fixup_video+0x0/0xaf()
[    5.661762] pci 0000:40:0b.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.661772] pci 0000:40:0b.0: Enabling HT MSI Mapping
[    5.682727] pci 0000:40:0b.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/=
0x7a()
[    5.682734] pci 0000:40:0b.0: Found enabled HT MSI Mapping
[    5.714012] pci 0000:40:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_ca=
p+0x0/0x6a()
[    5.714015] pci 0000:40:0b.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.714018] pci 0000:40:0b.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.714021] pci 0000:40:0b.0: calling pci_fixup_video+0x0/0xaf()
[    5.714026] pci 0000:40:0c.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.714035] pci 0000:40:0c.0: Enabling HT MSI Mapping
[    5.728255] pci 0000:40:0c.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/=
0x7a()
[    5.728262] pci 0000:40:0c.0: Found enabled HT MSI Mapping
[    5.759979] pci 0000:40:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_ca=
p+0x0/0x6a()
[    5.759982] pci 0000:40:0c.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.759985] pci 0000:40:0c.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.759988] pci 0000:40:0c.0: calling pci_fixup_video+0x0/0xaf()
[    5.759992] pci 0000:40:0d.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.760002] pci 0000:40:0d.0: Enabling HT MSI Mapping
[    5.788012] pci 0000:40:0d.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/=
0x7a()
[    5.788019] pci 0000:40:0d.0: Found enabled HT MSI Mapping
[    5.811750] pci 0000:40:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_ca=
p+0x0/0x6a()
[    5.811753] pci 0000:40:0d.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.811756] pci 0000:40:0d.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.811758] pci 0000:40:0d.0: calling pci_fixup_video+0x0/0xaf()
[    5.811763] pci 0000:40:0e.0: calling nv_msi_ht_cap_quirk+0x0/0x106()
[    5.811773] pci 0000:40:0e.0: Enabling HT MSI Mapping
[    5.840025] pci 0000:40:0e.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/=
0x7a()
[    5.840032] pci 0000:40:0e.0: Found enabled HT MSI Mapping
[    5.871169] pci 0000:40:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_ca=
p+0x0/0x6a()
[    5.871172] pci 0000:40:0e.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.871175] pci 0000:40:0e.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.871178] pci 0000:40:0e.0: calling pci_fixup_video+0x0/0xaf()
[    5.871182] pci 0000:40:10.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.871185] pci 0000:40:10.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.871188] pci 0000:40:10.0: calling pci_fixup_video+0x0/0xaf()
[    5.871193] pci 0000:40:10.1: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.871196] pci 0000:40:10.1: calling quirk_usb_early_handoff+0x0/0x447()
[    5.871199] pci 0000:40:10.1: calling pci_fixup_video+0x0/0xaf()
[    5.871203] pci 0000:40:11.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.871206] pci 0000:40:11.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.871209] pci 0000:40:11.0: calling pci_fixup_video+0x0/0xaf()
[    5.871214] pci 0000:40:11.1: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.871216] pci 0000:40:11.1: calling quirk_usb_early_handoff+0x0/0x447()
[    5.871219] pci 0000:40:11.1: calling pci_fixup_video+0x0/0xaf()
[    5.871224] pci 0000:41:01.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.871226] pci 0000:41:01.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.871229] pci 0000:41:01.0: calling pci_fixup_video+0x0/0xaf()
[    5.871234] pci 0000:41:02.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.871237] pci 0000:41:02.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.871239] pci 0000:41:02.0: calling pci_fixup_video+0x0/0xaf()
[    5.871244] pci 0000:42:01.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.871246] pci 0000:42:01.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.871249] pci 0000:42:01.0: calling pci_fixup_video+0x0/0xaf()
[    5.871253] pci 0000:42:02.0: calling quirk_cardbus_legacy+0x0/0x1d()
[    5.871256] pci 0000:42:02.0: calling quirk_usb_early_handoff+0x0/0x447()
[    5.871259] pci 0000:42:02.0: calling pci_fixup_video+0x0/0xaf()
[    5.874572] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    5.874588] assign_interrupt_mode Found MSI capability
[    5.903122] Allocate Port Service[0000:00:0c.0:pcie00]
[    5.903221] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    5.903234] assign_interrupt_mode Found MSI capability
[    5.932146] Allocate Port Service[0000:00:0d.0:pcie00]
[    5.932218] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    5.932231] assign_interrupt_mode Found MSI capability
[    5.961108] Allocate Port Service[0000:00:0e.0:pcie00]
[    5.961108] PCI: Setting latency timer of device 0000:40:0b.0 to 64
[    5.961130] assign_interrupt_mode Found MSI capability
[    5.990044] Allocate Port Service[0000:40:0b.0:pcie00]
[    5.990155] PCI: Setting latency timer of device 0000:40:0c.0 to 64
[    5.990173] assign_interrupt_mode Found MSI capability
[    6.019152] Allocate Port Service[0000:40:0c.0:pcie00]
[    6.019234] PCI: Setting latency timer of device 0000:40:0d.0 to 64
[    6.019252] assign_interrupt_mode Found MSI capability
[    6.049013] Allocate Port Service[0000:40:0d.0:pcie00]
[    6.049097] PCI: Setting latency timer of device 0000:40:0e.0 to 64
[    6.049115] assign_interrupt_mode Found MSI capability
[    6.078003] Allocate Port Service[0000:40:0e.0:pcie00]
[    6.078235] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    6.098382] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00=
/input/input0
[    6.143161] ACPI: Power Button (FF) [PWRF]
[    6.168099] ACPI: ACPI0007:00 is registered as cooling_device0
[    6.200739] ACPI: ACPI0007:01 is registered as cooling_device1
[    6.233713] ACPI: ACPI0007:02 is registered as cooling_device2
[    6.266724] ACPI: ACPI0007:03 is registered as cooling_device3
[    6.299689] ACPI: ACPI0007:04 is registered as cooling_device4
[    6.303212] ACPI: ACPI0007:05 is registered as cooling_device5
[    6.323859] ACPI: ACPI0007:06 is registered as cooling_device6
[    6.343922] ACPI: ACPI0007:07 is registered as cooling_device7
[    6.388814] hpet_resources: 0xfed00000 is busy
[    6.388974] Non-volatile memory driver v1.2
[    6.412222] Linux agpgart interface v0.103
[    6.436361] [drm] Initialized drm 1.1.0 20060810
[    6.462673] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sha=
ring enabled
[    6.743341] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    6.999126] serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
[    7.033765] 00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    7.038325] brd: module loaded
[    7.056647] loop: module loaded
[    7.074198] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
[    7.108972] Copyright (c) 1999-2006 Intel Corporation.
[    7.125220] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[    7.158167] e100: Copyright(c) 1999-2006 Intel Corporation
[    7.189153] Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v1.7.4 (F=
ebruary 18, 2008)
[    7.225170] ACPI: PCI Interrupt 0000:41:01.0[A] -> GSI 31 (level, low) -=
> IRQ 31
[    7.599225] eth0: Broadcom NetXtreme II BCM5706 1000Base-T (A2) PCI-X 64=
-bit 100MHz found at mem dc000000, IRQ 31, node addr 00:1b:78:be:d1:50
[    7.613869] ACPI: PCI Interrupt 0000:41:02.0[A] -> GSI 32 (level, low) -=
> IRQ 32
[    7.976895] eth1: Broadcom NetXtreme II BCM5706 1000Base-T (A2) PCI-X 64=
-bit 100MHz found at mem da000000, IRQ 32, node addr 00:1b:78:be:d1:52
[    8.050856] console [netcon0] enabled
[    8.070300] netconsole: network logging started
[    8.095549] input: Macintosh mouse button emulation as /devices/virtual/=
input/input1
[    8.140617] Loading iSCSI transport class v2.0-869.
[    8.168436] Driver 'sd' needs updating - please use bus_type methods
[    8.204889] Driver 'sr' needs updating - please use bus_type methods
[    8.226141] pata_amd 0000:00:06.0: version 0.3.10
[    8.226184] PCI: Setting latency timer of device 0000:00:06.0 to 64
[    8.226303] scsi0 : pata_amd
[    8.230905] scsi1 : pata_amd
[    8.246852] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x500 irq =
14
[    8.276628] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x508 irq =
15
[    8.479173] ata1.00: ATAPI: TEAC    DV-W28ECW, G.C4, max MWDMA2
[    8.491911] ata1: nv_mode_filter: 0x39f&0xfffff->0x39f, BIOS=3D0x0 (0x0)=
 ACPI=3D0x0
[    8.514793] ata1.00: configured for MWDMA2
[    8.537803] ata2: port disabled. ignoring.
[    8.552915] scsi 0:0:0:0: CD-ROM            TEAC     DV-W28ECW        G.=
C4 PQ: 0 ANSI: 5
[    8.627128] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    8.665496] Uniform CD-ROM driver Revision: 3.20
[    8.692642] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    8.692766] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    8.713454] ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
[    8.713749] ACPI: PCI Interrupt Link [LNU2] enabled at IRQ 23
[    8.745193] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LNU2] -> GSI 23=
 (level, high) -> IRQ 23
[    8.785342] PCI: Setting latency timer of device 0000:00:02.1 to 64
[    8.785345] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    8.805245] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus =
number 1
[    8.829871] ehci_hcd 0000:00:02.1: reset hcs_params 0x10148a dbg=3D1 cc=
=3D1 pcc=3D4 !ppc ports=3D10
[    8.829878] ehci_hcd 0000:00:02.1: reset portroute 0 0 0 0 0 0 0 0 0 0=
=20
[    8.829880] ehci_hcd 0000:00:02.1: reset hcc_params a086 caching frame 2=
56/512/1024 park
[    8.829902] ehci_hcd 0000:00:02.1: park 0
[    8.829905] ehci_hcd 0000:00:02.1: reset command 080b12 park=3D3 ithresh=
=3D8 Periodic period=3D1024 Reset HALT
[    8.829908] ehci_hcd 0000:00:02.1: bogus port configuration: cc=3D1 x pc=
c=3D4 < ports=3D10
[    8.829913] ehci_hcd 0000:00:02.1: debug port 1
[    8.855208] PCI: cache line size of 64 is not supported by device 0000:0=
0:02.1
[    8.855210] ehci_hcd 0000:00:02.1: supports USB remote wakeup
[    8.855219] ehci_hcd 0000:00:02.1: irq 23, io mem 0xd9cd0000
[    8.888167] ehci_hcd 0000:00:02.1: reset command 080b02 park=3D3 ithresh=
=3D8 period=3D1024 Reset HALT
[    8.888171] ehci_hcd 0000:00:02.1: init command 010009 (park)=3D0 ithres=
h=3D1 period=3D256 RUN
[    8.894170] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10=
 Dec 2004
[    8.936145] usb usb1: default language 0x0409
[    8.937117] usb usb1: uevent
[    8.937169] usb usb1: usb_probe_device
[    8.937295] usb usb1: configuration #1 chosen from 1 choice
[    8.968925] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    8.968934] usb 1-0:1.0: uevent
[    8.968980] hub 1-0:1.0: usb_probe_interface
[    8.968981] hub 1-0:1.0: usb_probe_interface - got id
[    8.968983] hub 1-0:1.0: USB hub found
[    8.990904] hub 1-0:1.0: 10 ports detected
[    9.013879] hub 1-0:1.0: standalone hub
[    9.013881] hub 1-0:1.0: no power switching (usb 1.0)
[    9.013882] hub 1-0:1.0: individual port over-current protection
[    9.013884] hub 1-0:1.0: power on to power good time: 20ms
[    9.013888] hub 1-0:1.0: local power source is good
[    9.013891] hub 1-0:1.0: trying to enable port power on non-switchable h=
ub
[    9.103750] hub 1-0:1.0: state 7 ports 10 chg 0000 evt 0000
[    9.114950] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    9.114950] ehci_hcd 0000:00:02.1: GetStatus port 6 status 001803 POWER =
sig=3Dj CSC CONNECT
[    9.114956] hub 1-0:1.0: port 6, status 0501, change 0001, 480 Mb/s
[    9.152699] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    9.194839] usb usb1: Product: EHCI Host Controller
[    9.219168] hub 1-0:1.0: debounce: port 6: total 100ms stable 100ms stat=
us 0x501
[    9.221695] usb usb1: Manufacturer: Linux 2.6.25 ehci_hcd
[    9.252670] usb usb1: SerialNumber: 0000:00:02.1
[    9.270381] ehci_hcd 0000:00:02.1: port 6 high speed
[    9.270384] ehci_hcd 0000:00:02.1: GetStatus port 6 status 001005 POWER =
sig=3Dse0 PE CONNECT
[    9.279732] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHC=
I) Driver
[    9.279735] ohci_hcd: block sizes: ed 80 td 96
[    9.280773] ACPI: PCI Interrupt Link [LNU0] enabled at IRQ 22
[    9.312498] ACPI: PCI Interrupt 0000:00:02.0[A] -> <6>usb 1-6: new high =
speed USB device using ehci_hcd and address 2
[    9.365557] ehci_hcd 0000:00:02.1: port 6 high speed
[    9.365562] ehci_hcd 0000:00:02.1: GetStatus port 6 status 001005 POWER =
sig=3Dse0 PE CONNECT
[    9.373617] Link [LNU0] -> GSI 22 (level, high) -> IRQ 22
[    9.404457] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    9.404459] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    9.434597] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus =
number 2
[    9.434597] usb 1-6: uevent
[    9.471234] ohci_hcd 0000:00:02.0: created debug files
[    9.471240] ohci_hcd 0000:00:02.0: irq 22, io mem 0xd9ce0000
[    9.475648] usb 1-6: usb_probe_device
[    9.475741] usb 1-6: configuration #1 chosen from 1 choice
[    9.475815] usb 1-6: adding 1-6:1.0 (config #1, interface 0)
[    9.475824] usb 1-6:1.0: uevent
[    9.475874] hub 1-6:1.0: usb_probe_interface
[    9.475875] hub 1-6:1.0: usb_probe_interface - got id
[    9.475877] hub 1-6:1.0: USB hub found
[    9.475938] hub 1-6:1.0: 4 ports detected
[    9.475940] hub 1-6:1.0: standalone hub
[    9.475941] hub 1-6:1.0: individual port power switching
[    9.475943] hub 1-6:1.0: individual port over-current protection
[    9.476125] hub 1-6:1.0: TT per port
[    9.476127] hub 1-6:1.0: TT requires at most 8 FS bit times (666 ns)
[    9.476128] hub 1-6:1.0: Port indicators are supported
[    9.476130] hub 1-6:1.0: power on to power good time: 100ms
[    9.476312] hub 1-6:1.0: local power source is good
[    9.476315] hub 1-6:1.0: enabling power on all ports
[    9.577266] usb 1-6: link qh256-0001/ffff81007f802140 start 255 [1/0 us]
[    9.577277] usb 1-6: New USB device found, idVendor=3D04b4, idProduct=3D=
6560
[    9.604084] usb 1-6: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    9.623069] hub 1-6:1.0: state 7 ports 4 chg 0000 evt 0000
[    9.627467] ohci_hcd 0000:00:02.0: OHCI controller state
[    9.627470] ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers
[    9.627473] ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=3Doperatio=
nal CBSR=3D3
[    9.627475] ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=3D0
[    9.627477] ohci_hcd 0000:00:02.0: intrstatus 0x00000004 SF
[    9.627480] ohci_hcd 0000:00:02.0: intrenable 0x8000004a MIE RHSC RD WDH
[    9.627483] ohci_hcd 0000:00:02.0: hcca frame #0003
[    9.627485] ohci_hcd 0000:00:02.0: roothub.a 0100120a POTPGT=3D1 NOCP NP=
S NDP=3D10(10)
[    9.627488] ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=3D0000 DR=3D0=
000
[    9.627490] ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
[    9.627493] ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
[    9.627495] ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
[    9.627498] ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
[    9.627500] ohci_hcd 0000:00:02.0: roothub.portstatus [3] 0x00000100 PPS
[    9.627503] ohci_hcd 0000:00:02.0: roothub.portstatus [4] 0x00000100 PPS
[    9.627505] ohci_hcd 0000:00:02.0: roothub.portstatus [5] 0x00000100 PPS
[    9.627508] ohci_hcd 0000:00:02.0: roothub.portstatus [6] 0x00000100 PPS
[    9.627510] ohci_hcd 0000:00:02.0: roothub.portstatus [7] 0x00000100 PPS
[    9.627513] ohci_hcd 0000:00:02.0: roothub.portstatus [8] 0x00000100 PPS
[    9.627515] ohci_hcd 0000:00:02.0: roothub.portstatus [9] 0x00000100 PPS
[    9.627524] usb usb2: default language 0x0409
[    9.627539] usb usb2: uevent
[    9.627597] usb usb2: usb_probe_device
[    9.627679] usb usb2: configuration #1 chosen from 1 choice
[    9.641804] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    9.641812] usb 2-0:1.0: uevent
[    9.641865] hub 2-0:1.0: usb_probe_interface
[    9.641867] hub 2-0:1.0: usb_probe_interface - got id
[    9.641868] hub 2-0:1.0: USB hub found
[    9.663311] hub 2-0:1.0: 10 ports detected
[    9.679872] hub 2-0:1.0: standalone hub
[    9.679873] hub 2-0:1.0: no power switching (usb 1.0)
[    9.679875] hub 2-0:1.0: no over-current protection
[    9.679876] hub 2-0:1.0: power on to power good time: 2ms
[    9.679880] hub 2-0:1.0: local power source is good
[    9.679881] hub 2-0:1.0: trying to enable port power on non-switchable h=
ub
[    9.778257] hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
[    9.780949] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    9.815959] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    9.856843] usb usb2: Product: OHCI Host Controller
[    9.883695] usb usb2: Manufacturer: Linux 2.6.25 ohci_hcd
[    9.904720] usb usb2: SerialNumber: 0000:00:02.0
[    9.914216] USB Universal Host Controller Interface driver v3.0
[    9.948255] ACPI: PCI Interrupt Link [LNKX] enabled at IRQ 17
[    9.980720] ACPI: PCI Interrupt 0000:01:04.4[B] -> Link [LNKX] -> GSI 17=
 (level, high) -> IRQ 17
[   10.017120] uhci_hcd 0000:01:04.4: UHCI Host Controller
[   10.045783] uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus =
number 3
[   10.088845] uhci_hcd 0000:01:04.4: detected 8 ports
[   10.091750] uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 =
ports
[   10.131707] uhci_hcd 0000:01:04.4: uhci_check_and_reset_hc: cmd =3D 0x00=
00
[   10.131709] uhci_hcd 0000:01:04.4: Performing full reset
[   10.131718] uhci_hcd 0000:01:04.4: HCRESET not completed yet!
[   10.164672] uhci_hcd 0000:01:04.4: irq 17, io base 0x00001800
[   10.197706] usb usb3: default language 0x0409
[   10.197721] usb usb3: uevent
[   10.197771] usb usb3: usb_probe_device
[   10.198692] usb usb3: configuration #1 chosen from 1 choice
[   10.230882] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[   10.230894] usb 3-0:1.0: uevent
[   10.230951] hub 3-0:1.0: usb_probe_interface
[   10.230952] hub 3-0:1.0: usb_probe_interface - got id
[   10.230954] hub 3-0:1.0: USB hub found
[   10.251654] hub 3-0:1.0: 2 ports detected
[   10.273897] hub 3-0:1.0: standalone hub
[   10.273899] hub 3-0:1.0: no power switching (usb 1.0)
[   10.273900] hub 3-0:1.0: individual port over-current protection
[   10.273902] hub 3-0:1.0: power on to power good time: 2ms
[   10.273905] hub 3-0:1.0: local power source is good
[   10.273906] hub 3-0:1.0: trying to enable port power on non-switchable h=
ub
[   10.370239] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   10.373984] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   10.373984] uhci_hcd 0000:01:04.4: port 1 portsc 0083,00
[   10.373991] hub 3-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[   10.411772] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[   10.453897] usb usb3: Product: UHCI Host Controller
[   10.478321] hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms stat=
us 0x101
[   10.480787] usb usb3: Manufacturer: Linux 2.6.25 uhci_hcd
[   10.511855] usb usb3: SerialNumber: 0000:01:04.4
[   10.579880] usb 3-1: new full speed USB device using uhci_hcd and addres=
s 2
[   10.746982] usb 3-1: skipped 1 descriptor after interface
[   10.746984] usb 3-1: skipped 1 descriptor after interface
[   10.750221] usb 3-1: default language 0x0409
[   10.756719] usb 3-1: uevent
[   10.756777] usb 3-1: usb_probe_device
[   10.756874] usb 3-1: configuration #1 chosen from 1 choice
[   10.776914] usb 3-1: adding 3-1:1.0 (config #1, interface 0)
[   10.776925] usb 3-1:1.0: uevent
[   10.780310] usb 3-1: adding 3-1:1.1 (config #1, interface 1)
[   10.780320] usb 3-1:1.1: uevent
[   10.783498] usb 3-1: New USB device found, idVendor=3D03f0, idProduct=3D=
1027
[   10.821005] usb 3-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[   10.853788] usb 3-1: Product: Virtual Keyboard
[   10.860738] usb 3-1: Manufacturer: HP
[   10.869997] uhci_hcd 0000:01:04.4: port 2 portsc 0083,00
[   10.870003] hub 3-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[   10.973554] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms stat=
us 0x101
[   10.979704] ohci_hcd 0000:00:02.0: auto-stop root hub
[   11.075546] usb 3-2: new full speed USB device using uhci_hcd and addres=
s 3
[   11.150540] uhci_hcd 0000:01:04.4: port 2 portsc 0083,00
[   11.150550] hub 3-0:1.0: unable to enumerate USB device on port 2
[   11.175480] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004
[   11.175494] uhci_hcd 0000:01:04.4: port 2 portsc 0083,00
[   11.175499] hub 3-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[   11.279096] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms stat=
us 0x101
[   11.381084] usb 3-2: new full speed USB device using uhci_hcd and addres=
s 4
[   11.530595] usb 3-2: default language 0x0409
[   11.537085] usb 3-2: uevent
[   11.537142] usb 3-2: usb_probe_device
[   11.537226] usb 3-2: configuration #1 chosen from 1 choice
[   11.570049] usb 3-2: adding 3-2:1.0 (config #1, interface 0)
[   11.570059] usb 3-2:1.0: uevent
[   11.570115] hub 3-2:1.0: usb_probe_interface
[   11.570117] hub 3-2:1.0: usb_probe_interface - got id
[   11.570119] hub 3-2:1.0: USB hub found
[   11.594448] hub 3-2:1.0: 7 ports detected
[   11.617214] hub 3-2:1.0: standalone hub
[   11.617216] hub 3-2:1.0: ganged power switching
[   11.617217] hub 3-2:1.0: individual port over-current protection
[   11.617219] hub 3-2:1.0: power on to power good time: 100ms
[   11.621442] hub 3-2:1.0: local power source is good
[   11.621444] hub 3-2:1.0: enabling power on all ports
[   11.737081] uhci_hcd 0000:01:04.4: reserve dev 4 ep81-INT, period 128, p=
hase 0, 12 us
[   11.740175] usb 3-2: New USB device found, idVendor=3D03f0, idProduct=3D=
1327
[   11.778093] usb 3-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[   11.786932] usb 3-2: Product: Virtual Hub
[   11.800002] usb 3-2: Manufacturer: HP
[   11.820048] hub 3-2:1.0: state 7 ports 7 chg 0000 evt 0000
[   11.835746] usb 3-2: remote wakeup needed for autosuspend
[   11.835746] usbcore: registered new interface driver usblp
[   11.856431] Initializing USB Mass Storage driver...
[   11.885465] usbcore: registered new interface driver usb-storage
[   11.920375] USB Mass Storage support registered.
[   11.947403] usbcore: registered new interface driver libusual
[   11.962044] hub 1-6:1.0: hub_suspend
[   11.962048] usb 1-6: unlink qh256-0001/ffff81007f802140 start 255 [1/0 u=
s]
[   11.962151] usb 1-6: usb auto-suspend
[   11.973039] hub 2-0:1.0: hub_suspend
[   11.973042] usb usb2: bus auto-suspend
[   11.973045] ohci_hcd 0000:00:02.0: suspend root hub
[   11.980380] PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64=
 irq 1,12
[   12.022295] serio: i8042 KBD port at 0x60,0x64 irq 1
[   12.050544] serio: i8042 AUX port at 0x60,0x64 irq 12
[   12.060940] mice: PS/2 mouse device common for all mice
[   12.166673] rtc_cmos 00:0a: rtc core: registered rtc_cmos as rtc0
[   12.201262] rtc0: alarms up to one year, y3k
[   12.216302] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised:=
 dm-devel@redhat.com
[   12.266196] cpuidle: using governor ladder
[   12.268468] cpuidle: using governor menu
[   12.291067] usbcore: registered new interface driver hiddev
[   12.306290] usbhid 3-1:1.0: usb_probe_interface
[   12.306292] usbhid 3-1:1.0: usb_probe_interface - got id
[   12.310425] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:09=
=2E0/0000:01:04.4/usb3/3-1/3-1:1.0/input/input2
[   12.354996] uhci_hcd 0000:01:04.4: reserve dev 2 ep81-INT, period 8, pha=
se 4, 17 us
[   12.358118] input,hidraw0: USB HID v1.01 Keyboard [HP Virtual Keyboard] =
on usb-0000:01:04.4-1
[   12.388803] usbhid 3-1:1.1: usb_probe_interface
[   12.388805] usbhid 3-1:1.1: usb_probe_interface - got id
[   12.393977] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:09=
=2E0/0000:01:04.4/usb3/3-1/3-1:1.1/input/input3
[   12.454616] input,hidraw1: USB HID v1.01 Mouse [HP Virtual Keyboard] on =
usb-0000:01:04.4-1
[   12.473262] usbcore: registered new interface driver usbhid
[   12.476588] usbhid: v2.6:USB HID core driver
[   12.500072] Advanced Linux Sound Architecture Driver Version 1.0.16.
[   12.527395] ALSA device list:
[   12.543006]   No soundcards found.
[   12.563124] Netfilter messages via NETLINK v0.30.
[   12.589129] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   12.616927] ctnetlink v0.93: registering with nfnetlink.
[   12.648277] ip_tables: (C) 2000-2006 Netfilter Core Team
[   12.678672] TCP cubic registered
[   12.693037] Initializing XFRM netlink socket
[   12.707789] NET: Registered protocol family 10
[   12.725226] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   12.755181] IPv6 over IPv4 tunneling driver
[   12.780301] NET: Registered protocol family 17
[   12.806591] RPC: Registered udp transport module.
[   12.811471] RPC: Registered tcp transport module.
[   12.837768] registered taskstats version 1
[   12.847549]   Magic number: 1:122:228
[   12.868044] Freeing unused kernel memory: 408k freed
[   12.897702] Write protecting the kernel read-only data: 6388k
[   12.924198] framebuffer used greatest stack depth: 5960 bytes left
[   13.011397] usb usb2: uevent
[   13.011416] usb 2-0:1.0: uevent
[   13.011507] usb usb1: uevent
[   13.011523] usb 1-0:1.0: uevent
[   13.011553] usb 1-6: uevent
[   13.011570] usb 1-6:1.0: uevent
[   13.011869] usb usb3: uevent
[   13.011887] usb 3-0:1.0: uevent
[   13.011922] usb 3-1: uevent
[   13.011939] usb 3-1:1.0: uevent
[   13.012026] usb 3-1:1.1: uevent
[   13.012144] usb 3-2: uevent
[   13.012161] usb 3-2:1.0: uevent
[   13.175784] cdrom_id used greatest stack depth: 5600 bytes left
[   13.175784] Fusion MPT base driver 3.04.06
[   13.192260] Copyright (c) 1999-2007 LSI Corporation
[   13.225574] Fusion MPT SAS Host driver 3.04.06
[   13.271656] ACPI: PCI Interrupt 0000:42:01.0[A] -> GSI 24 (level, low) -=
> IRQ 24
[   13.313693] mptbase: ioc0: Initiating bringup
[   13.615399] ioc0: LSISAS1068 B0: Capabilities=3D{Initiator}
[   13.631958] mptbase: ioc0: PCI-MSI enabled
[   13.982332] hub 1-0:1.0: hub_suspend
[   13.982343] usb usb1: bus auto-suspend
[   13.982346] ehci_hcd 0000:00:02.1: suspend root hub
[   36.872494] scsi2 : ioc0: LSISAS1068 B0, FwRev=3D01142100h, Ports=3D1, M=
axQ=3D511, IRQ=3D2296
[   36.948001] scsi 2:0:0:0: Direct-Access     HP       DG036A9BB6       HP=
D0 PQ: 0 ANSI: 5
[   36.995195] sd 2:0:0:0: [sda] 71132960 512-byte hardware sectors (36420 =
MB)
[   37.035914] sd 2:0:0:0: [sda] Write Protect is off
[   37.063054] sd 2:0:0:0: [sda] Mode Sense: cf 00 10 08
[   37.065147] sd 2:0:0:0: [sda] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   37.114806] sd 2:0:0:0: [sda] 71132960 512-byte hardware sectors (36420 =
MB)
[   37.155485] sd 2:0:0:0: [sda] Write Protect is off
[   37.182018] sd 2:0:0:0: [sda] Mode Sense: cf 00 10 08
[   37.183138] sd 2:0:0:0: [sda] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   37.211143]  sda: unknown partition table
[   37.242517] sd 2:0:0:0: [sda] Attached SCSI disk
[   37.268186] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   37.292685] scsi 2:0:1:0: Direct-Access     HP       DG036A9BB6       HP=
D0 PQ: 0 ANSI: 5
[   37.340726] sd 2:0:1:0: [sdb] 71132960 512-byte hardware sectors (36420 =
MB)
[   37.371636] sd 2:0:1:0: [sdb] Write Protect is off
[   37.388666] sd 2:0:1:0: [sdb] Mode Sense: cf 00 10 08
[   37.390775] sd 2:0:1:0: [sdb] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   37.404759] sd 2:0:1:0: [sdb] 71132960 512-byte hardware sectors (36420 =
MB)
[   37.446150] sd 2:0:1:0: [sdb] Write Protect is off
[   37.472626] sd 2:0:1:0: [sdb] Mode Sense: cf 00 10 08
[   37.473746] sd 2:0:1:0: [sdb] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   37.522861]  sdb: unknown partition table
[   37.552684] sd 2:0:1:0: [sdb] Attached SCSI disk
[   37.580599] sd 2:0:1:0: Attached scsi generic sg2 type 0
[   37.613265] scsi 2:0:2:0: Direct-Access     HP       DG036A9BB6       HP=
D0 PQ: 0 ANSI: 5
[   37.662039] sd 2:0:2:0: [sdc] 71132960 512-byte hardware sectors (36420 =
MB)
[   37.676116] sd 2:0:2:0: [sdc] Write Protect is off
[   37.702860] sd 2:0:2:0: [sdc] Mode Sense: cf 00 10 08
[   37.704950] sd 2:0:2:0: [sdc] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   37.754616] sd 2:0:2:0: [sdc] 71132960 512-byte hardware sectors (36420 =
MB)
[   37.795366] sd 2:0:2:0: [sdc] Write Protect is off
[   37.821828] sd 2:0:2:0: [sdc] Mode Sense: cf 00 10 08
[   37.822944] sd 2:0:2:0: [sdc] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   37.872012]  sdc: unknown partition table
[   37.902934] sd 2:0:2:0: [sdc] Attached SCSI disk
[   37.930861] sd 2:0:2:0: Attached scsi generic sg3 type 0
[   37.963216] scsi 2:0:3:0: Direct-Access     HP       DG036A9BB6       HP=
D0 PQ: 0 ANSI: 5
[   38.010873] sd 2:0:3:0: [sdd] 71132960 512-byte hardware sectors (36420 =
MB)
[   38.050878] sd 2:0:3:0: [sdd] Write Protect is off
[   38.077471] sd 2:0:3:0: [sdd] Mode Sense: cf 00 10 08
[   38.078682] sd 2:0:3:0: [sdd] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   38.107238] sd 2:0:3:0: [sdd] 71132960 512-byte hardware sectors (36420 =
MB)
[   38.147982] sd 2:0:3:0: [sdd] Write Protect is off
[   38.175436] sd 2:0:3:0: [sdd] Mode Sense: cf 00 10 08
[   38.176556] sd 2:0:3:0: [sdd] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   38.204641]  sdd: unknown partition table
[   38.234909] sd 2:0:3:0: [sdd] Attached SCSI disk
[   38.254170] sd 2:0:3:0: Attached scsi generic sg4 type 0
[   38.275322] scsi 2:0:4:0: Direct-Access     HP       DG072A8B54       HP=
D7 PQ: 0 ANSI: 5
[   38.323289] sd 2:0:4:0: [sde] 143374738 512-byte hardware sectors (73408=
 MB)
[   38.363997] sd 2:0:4:0: [sde] Write Protect is off
[   38.384391] sd 2:0:4:0: [sde] Mode Sense: db 00 10 08
[   38.386277] sd 2:0:4:0: [sde] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   38.415095] sd 2:0:4:0: [sde] 143374738 512-byte hardware sectors (73408=
 MB)
[   38.456634] sd 2:0:4:0: [sde] Write Protect is off
[   38.483460] sd 2:0:4:0: [sde] Mode Sense: db 00 10 08
[   38.484738] sd 2:0:4:0: [sde] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   38.525386]  sde: unknown partition table
[   38.553861] sd 2:0:4:0: [sde] Attached SCSI disk
[   38.580430] sd 2:0:4:0: Attached scsi generic sg5 type 0
[   38.611775] scsi 2:0:5:0: Direct-Access     HP       DG072A8B54       HP=
D7 PQ: 0 ANSI: 5
[   38.659335] sd 2:0:5:0: [sdf] 143374738 512-byte hardware sectors (73408=
 MB)
[   38.701158] sd 2:0:5:0: [sdf] Write Protect is off
[   38.718765] sd 2:0:5:0: [sdf] Mode Sense: db 00 10 08
[   38.720965] sd 2:0:5:0: [sdf] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   38.754862] sd 2:0:5:0: [sdf] 143374738 512-byte hardware sectors (73408=
 MB)
[   38.796063] sd 2:0:5:0: [sdf] Write Protect is off
[   38.820986] sd 2:0:5:0: [sdf] Mode Sense: db 00 10 08
[   38.822262] sd 2:0:5:0: [sdf] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   38.833360]  sdf: sdf1 sdf2 < sdf5 >
[   38.865851] sd 2:0:5:0: [sdf] Attached SCSI disk
[   38.868565] sd 2:0:5:0: Attached scsi generic sg6 type 0
[   38.899883] scsi 2:0:6:0: Direct-Access     HP       DG072A8B54       HP=
D7 PQ: 0 ANSI: 5
[   38.948252] sd 2:0:6:0: [sdg] 143374738 512-byte hardware sectors (73408=
 MB)
[   38.984043] sd 2:0:6:0: [sdg] Write Protect is off
[   38.990480] sd 2:0:6:0: [sdg] Mode Sense: db 00 10 08
[   38.991953] sd 2:0:6:0: [sdg] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   39.025658] sd 2:0:6:0: [sdg] 143374738 512-byte hardware sectors (73408=
 MB)
[   39.064015] sd 2:0:6:0: [sdg] Write Protect is off
[   39.090491] sd 2:0:6:0: [sdg] Mode Sense: db 00 10 08
[   39.091771] sd 2:0:6:0: [sdg] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   39.121438]  sdg: unknown partition table
[   39.151611] sd 2:0:6:0: [sdg] Attached SCSI disk
[   39.178617] sd 2:0:6:0: Attached scsi generic sg7 type 0
[   39.210845] scsi 2:0:7:0: Direct-Access     HP       DG072A8B54       HP=
D7 PQ: 0 ANSI: 5
[   39.226616] sd 2:0:7:0: [sdh] 143374738 512-byte hardware sectors (73408=
 MB)
[   39.267495] sd 2:0:7:0: [sdh] Write Protect is off
[   39.294680] sd 2:0:7:0: [sdh] Mode Sense: db 00 10 08
[   39.296412] sd 2:0:7:0: [sdh] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   39.337384] sd 2:0:7:0: [sdh] 143374738 512-byte hardware sectors (73408=
 MB)
[   39.347909] sd 2:0:7:0: [sdh] Write Protect is off
[   39.374711] sd 2:0:7:0: [sdh] Mode Sense: db 00 10 08
[   39.375989] sd 2:0:7:0: [sdh] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
[   39.424924]  sdh: sdh1
[   39.445631] sd 2:0:7:0: [sdh] Attached SCSI disk
[   39.472528] sd 2:0:7:0: Attached scsi generic sg8 type 0
[   39.504437] modprobe used greatest stack depth: 3336 bytes left
[   39.766451] kjournald starting.  Commit interval 5 seconds
[   39.766451] EXT3-fs: mounted filesystem with ordered data mode.
[   40.721346] udevd version 125 started
[   40.801447] usb usb2: uevent
[   40.801468] usb 2-0:1.0: uevent
[   40.801564] usb usb1: uevent
[   40.801581] usb 1-0:1.0: uevent
[   40.801613] usb 1-6: uevent
[   40.801630] usb 1-6:1.0: uevent
[   40.801935] usb usb3: uevent
[   40.801953] usb 3-0:1.0: uevent
[   40.801986] usb 3-1: uevent
[   40.802005] usb 3-1:1.0: uevent
[   40.802097] usb 3-1:1.1: uevent
[   40.802214] usb 3-2: uevent
[   40.802232] usb 3-2:1.0: uevent
[   41.925475] Adding 2963952k swap on /dev/sdf5.  Priority:-1 extents:1 ac=
ross:2963952k
[   42.264323] EXT3 FS on sdf1, internal journal
[   44.441511] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   47.533354] bnx2: eth0 NIC Copper Link is Up, 1000 Mbps full duplex
[   47.570707] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   58.202303] eth0: no IPv6 routers present

--EVF5PPMfhYS0aIcm
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.diff"

--- pre.dmesg.trimmed	2009-07-09 12:35:10.000000000 -0600
+++ post.dmesg.trimmed	2009-07-09 12:35:17.000000000 -0600
@@ -1,6 +1,6 @@
 Initializing cgroup subsys cpuset
 Initializing cgroup subsys cpu
-Linux version 2.6.25 (dannf@dl585g2) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #68 SMP Thu Jul 9 12:25:31 MDT 2009
+Linux version 2.6.25 (dannf@dl585g2) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #67 SMP Thu Jul 9 12:11:29 MDT 2009
 Command line: root=/dev/disk/by-id/scsi-35000c50000d5ca0f-part1 ro console=tty1 console=ttyS1,115200 
 BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009e400 (usable)
@@ -65,8 +65,8 @@
   bootmap [000000000002c000 -  000000000005bfff] pages 30
   early res: 0 [0-fff] BIOS data page
   early res: 1 [6000-7fff] TRAMPOLINE
-  early res: 2 [200000-a88afb] TEXT DATA BSS
-  early res: 3 [37d54000-37fef2b8] RAMDISK
+  early res: 2 [200000-a8a97b] TEXT DATA BSS
+  early res: 3 [37d54000-37fef2ed] RAMDISK
   early res: 4 [9e400-fffff] BIOS reserved
   early res: 5 [8000-19fff] PGTABLE
   early res: 6 [1a000-2307f] MEMNODEMAP
@@ -99,8 +99,8 @@
     3:  3670016 ->  4718591
 On node 0 totalpages: 1047789
   DMA zone: 56 pages used for memmap
-  DMA zone: 2313 pages reserved
-  DMA zone: 1629 pages, LIFO batch:0
+  DMA zone: 2315 pages reserved
+  DMA zone: 1627 pages, LIFO batch:0
   DMA32 zone: 14280 pages used for memmap
   DMA32 zone: 505223 pages, LIFO batch:31
   Normal zone: 7168 pages used for memmap
@@ -175,7 +175,7 @@
 SMP: Allowing 8 CPUs, 0 hotplug CPUs
 PERCPU: Allocating 44480 bytes of per cpu data
 NR_CPUS: 64, nr_cpu_ids: 8
-Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 4126692
+Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 4126690
 Policy zone: Normal
 Kernel command line: root=/dev/disk/by-id/scsi-35000c50000d5ca0f-part1 ro console=tty1 console=ttyS1,115200 
 Initializing CPU#0
@@ -183,7 +183,7 @@
 Extended CMOS year: 2000
 TSC calibrated against PM_TIMER
 Marking TSC unstable due to TSCs unsynchronized
-time.c: Detected 2612.039 MHz processor.
+time.c: Detected 2612.040 MHz processor.
 spurious 8259A interrupt: IRQ7.
 Console: colour VGA+ 80x25
 console [tty1] enabled
@@ -197,11 +197,11 @@
 This costs you 64 MB of RAM
 Mapping aperture over 65536 KB of RAM @ 4000000
 PM: Registered nosave memory: 0000000004000000 - 0000000008000000
-Memory: 16466524k/18874364k available (4336k kernel code, 307540k reserved, 2815k data, 404k init)
+Memory: 16466516k/18874364k available (4337k kernel code, 307548k reserved, 2815k data, 408k init)
 CPA: page pool initialized 1 of 1 pages preallocated
 SLUB: Genslabs=13, HWalign=64, Order=0-1, MinObjects=4, CPUs=8, Nodes=4
 hpet clockevent registered
-Calibrating delay using timer specific routine.. 5226.25 BogoMIPS (lpj=2613125)
+Calibrating delay using timer specific routine.. 5226.24 BogoMIPS (lpj=2613121)
 Security Framework initialized
 SELinux:  Initializing.
 SELinux:  Starting in permissive mode
@@ -220,11 +220,11 @@
 ACPI: Core revision 20070126
 CPU0: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
 Using local APIC timer interrupts.
-APIC timer calibration result 12557872
+APIC timer calibration result 12557873
 Detected 12.557 MHz APIC timer.
 Booting processor 1/2 ip 6000
 Initializing CPU#1
-Calibrating delay using timer specific routine.. 5223.88 BogoMIPS (lpj=2611941)
+Calibrating delay using timer specific routine.. 5223.83 BogoMIPS (lpj=2611917)
 CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
 CPU: L2 Cache: 1024K (64 bytes/line)
 CPU 1/2 -> Node 1
@@ -234,7 +234,7 @@
 CPU1: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
 Booting processor 2/4 ip 6000
 Initializing CPU#2
-Calibrating delay using timer specific routine.. 5223.84 BogoMIPS (lpj=2611922)
+Calibrating delay using timer specific routine.. 5223.89 BogoMIPS (lpj=2611947)
 CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
 CPU: L2 Cache: 1024K (64 bytes/line)
 CPU 2/4 -> Node 2
@@ -244,7 +244,7 @@
 CPU2: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
 Booting processor 3/6 ip 6000
 Initializing CPU#3
-Calibrating delay using timer specific routine.. 5223.86 BogoMIPS (lpj=2611930)
+Calibrating delay using timer specific routine.. 5223.89 BogoMIPS (lpj=2611949)
 CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
 CPU: L2 Cache: 1024K (64 bytes/line)
 CPU 3/6 -> Node 3
@@ -254,7 +254,7 @@
 CPU3: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
 Booting processor 4/1 ip 6000
 Initializing CPU#4
-Calibrating delay using timer specific routine.. 5223.82 BogoMIPS (lpj=2611910)
+Calibrating delay using timer specific routine.. 5223.81 BogoMIPS (lpj=2611905)
 CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
 CPU: L2 Cache: 1024K (64 bytes/line)
 CPU 4/1 -> Node 0
@@ -264,7 +264,7 @@
 CPU4: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
 Booting processor 5/3 ip 6000
 Initializing CPU#5
-Calibrating delay using timer specific routine.. 5223.85 BogoMIPS (lpj=2611926)
+Calibrating delay using timer specific routine.. 5223.87 BogoMIPS (lpj=2611939)
 CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
 CPU: L2 Cache: 1024K (64 bytes/line)
 CPU 5/3 -> Node 1
@@ -274,7 +274,7 @@
 CPU5: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
 Booting processor 6/5 ip 6000
 Initializing CPU#6
-Calibrating delay using timer specific routine.. 5223.87 BogoMIPS (lpj=2611937)
+Calibrating delay using timer specific routine.. 5223.85 BogoMIPS (lpj=2611928)
 CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
 CPU: L2 Cache: 1024K (64 bytes/line)
 CPU 6/5 -> Node 2
@@ -284,7 +284,7 @@
 CPU6: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
 Booting processor 7/7 ip 6000
 Initializing CPU#7
-Calibrating delay using timer specific routine.. 5223.84 BogoMIPS (lpj=2611921)
+Calibrating delay using timer specific routine.. 5223.84 BogoMIPS (lpj=2611923)
 CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
 CPU: L2 Cache: 1024K (64 bytes/line)
 CPU 7/7 -> Node 3
@@ -293,12 +293,14 @@
 x86: PAT support disabled.
 CPU7: Dual-Core AMD Opteron(tm) Processor 8218 stepping 03
 Brought up 8 CPUs
-Total of 8 processors activated (41793.22 BogoMIPS).
+Total of 8 processors activated (41793.25 BogoMIPS).
 khelper used greatest stack depth: 6056 bytes left
 net_namespace: 1176 bytes
-Time: 12:28:07  Date: 07/09/09
+Time: 12:14:05  Date: 07/09/09
 NET: Registered protocol family 16
 No dock devices found.
+TOM: 0000000080000000 aka 2048M
+TOM2: 0000000480000000 aka 18432M
 bus: 00 to node: 00
 bus: 01 to node: 00
 bus: 02 to node: 00
@@ -427,6 +429,17 @@
 bus: 7d to node: 01
 bus: 7e to node: 01
 bus: 7f to node: 01
+bus: [00,3f] on node 0 link 1
+bus: 00 index 0 io port: [0, 2fff]
+bus: 00 index 1 mmio: [80000000, d9efffff]
+bus: 00 index 2 mmio: [dff00000, e3ffffff]
+bus: 00 index 3 mmio: [a0000, bffff]
+bus: 00 index 4 mmio: [e8000000, ffffffff]
+bus: 00 index 5 mmio: [480000000, fbffffffff]
+bus: [40,7f] on node 1 link 2
+bus: 40 index 0 io port: [3000, ffff]
+bus: 40 index 1 mmio: [d9f00000, dfefffff]
+bus: 40 index 2 mmio: [e4000000, e7ffffff]
 ACPI: bus type pci registered
 PCI: Using configuration type 1 for base access
 ACPI: EC: Look up EC in DSDT
@@ -581,7 +594,6 @@
 PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
 hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
 hpet0: 3 32-bit timers, 25000000 Hz
-ACPI: RTC can wake from S4
 Switched to high resolution mode on CPU 0
 Switched to high resolution mode on CPU 4
 Switched to high resolution mode on CPU 1
@@ -590,6 +602,7 @@
 Switched to high resolution mode on CPU 6
 Switched to high resolution mode on CPU 3
 Switched to high resolution mode on CPU 7
+ACPI: RTC can wake from S4
 system 00:01: ioport range 0x408-0x40f has been reserved
 system 00:01: ioport range 0x4d0-0x4d1 has been reserved
 system 00:01: ioport range 0x700-0x73f has been reserved
@@ -646,18 +659,18 @@
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
-  got res [88000000:8801ffff] bus [88000000:8801ffff] flags 27200 for BAR 6 of 0000:41:01.0
-  got res [88020000:8803ffff] bus [88020000:8803ffff] flags 27200 for BAR 6 of 0000:41:02.0
+  got res [d9f00000:d9f1ffff] bus [d9f00000:d9f1ffff] flags 27200 for BAR 6 of 0000:41:01.0
+  got res [d9f20000:d9f3ffff] bus [d9f20000:d9f3ffff] flags 27200 for BAR 6 of 0000:41:02.0
 PCI: Bridge: 0000:40:10.0
   IO window: disabled.
   MEM window: 0xda000000-0xddffffff
-  PREFETCH window: 0x0000000088000000-0x00000000880fffff
-  got res [88200000:883fffff] bus [88200000:883fffff] flags 27200 for BAR 6 of 0000:42:01.0
-  got res [88100000:8813ffff] bus [88100000:8813ffff] flags 27200 for BAR 6 of 0000:42:02.0
+  PREFETCH window: 0x00000000d9f00000-0x00000000d9ffffff
+  got res [de000000:de1fffff] bus [de000000:de1fffff] flags 27200 for BAR 6 of 0000:42:01.0
+  got res [de200000:de23ffff] bus [de200000:de23ffff] flags 27200 for BAR 6 of 0000:42:02.0
 PCI: Bridge: 0000:40:11.0
   IO window: 3000-3fff
   MEM window: 0xdfe00000-0xdfefffff
-  PREFETCH window: 0x0000000088100000-0x00000000883fffff
+  PREFETCH window: 0x00000000de000000-0x00000000de2fffff
 PCI: Setting latency timer of device 0000:40:0b.0 to 64
 PCI: Setting latency timer of device 0000:40:0c.0 to 64
 PCI: Setting latency timer of device 0000:40:0d.0 to 64
@@ -681,7 +694,7 @@
 microcode: CPU7 not a capable Intel processor
 IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
 audit: initializing netlink socket (disabled)
-type=2000 audit(1247142486.936:1): initialized
+type=2000 audit(1247141644.906:1): initialized
 Total HugeTLB memory allocated, 0
 VFS: Disk quotas dquot_6.5.1
 Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
@@ -986,24 +999,24 @@
 hub 1-0:1.0: port 6, status 0501, change 0001, 480 Mb/s
 usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb1: Product: EHCI Host Controller
-usb usb1: Manufacturer: Linux 2.6.25 ehci_hcd
 hub 1-0:1.0: debounce: port 6: total 100ms stable 100ms status 0x501
+usb usb1: Manufacturer: Linux 2.6.25 ehci_hcd
 usb usb1: SerialNumber: 0000:00:02.1
+ehci_hcd 0000:00:02.1: port 6 high speed
+ehci_hcd 0000:00:02.1: GetStatus port 6 status 001005 POWER sig=se0 PE CONNECT
 ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
 ohci_hcd: block sizes: ed 80 td 96
 ACPI: PCI Interrupt Link [LNU0] enabled at IRQ 22
+ACPI: PCI Interrupt 0000:00:02.0[A] -> <6>usb 1-6: new high speed USB device using ehci_hcd and address 2
 ehci_hcd 0000:00:02.1: port 6 high speed
 ehci_hcd 0000:00:02.1: GetStatus port 6 status 001005 POWER sig=se0 PE CONNECT
-ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNU0] -> GSI 22 (level, high) -> IRQ 22
-usb 1-6: new high speed USB device using ehci_hcd and address 2
+Link [LNU0] -> GSI 22 (level, high) -> IRQ 22
 PCI: Setting latency timer of device 0000:00:02.0 to 64
 ohci_hcd 0000:00:02.0: OHCI Host Controller
-ehci_hcd 0000:00:02.1: port 6 high speed
-ehci_hcd 0000:00:02.1: GetStatus port 6 status 001005 POWER sig=se0 PE CONNECT
 ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
+usb 1-6: uevent
 ohci_hcd 0000:00:02.0: created debug files
 ohci_hcd 0000:00:02.0: irq 22, io mem 0xd9ce0000
-usb 1-6: uevent
 usb 1-6: usb_probe_device
 usb 1-6: configuration #1 chosen from 1 choice
 usb 1-6: adding 1-6:1.0 (config #1, interface 0)
@@ -1015,6 +1028,16 @@
 hub 1-6:1.0: standalone hub
 hub 1-6:1.0: individual port power switching
 hub 1-6:1.0: individual port over-current protection
+hub 1-6:1.0: TT per port
+hub 1-6:1.0: TT requires at most 8 FS bit times (666 ns)
+hub 1-6:1.0: Port indicators are supported
+hub 1-6:1.0: power on to power good time: 100ms
+hub 1-6:1.0: local power source is good
+hub 1-6:1.0: enabling power on all ports
+usb 1-6: link qh256-0001/ffff81007f802140 start 255 [1/0 us]
+usb 1-6: New USB device found, idVendor=04b4, idProduct=6560
+usb 1-6: New USB device strings: Mfr=0, Product=0, SerialNumber=0
+hub 1-6:1.0: state 7 ports 4 chg 0000 evt 0000
 ohci_hcd 0000:00:02.0: OHCI controller state
 ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers
 ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=operational CBSR=3
@@ -1037,14 +1060,8 @@
 ohci_hcd 0000:00:02.0: roothub.portstatus [9] 0x00000100 PPS
 usb usb2: default language 0x0409
 usb usb2: uevent
-hub 1-6:1.0: TT per port
-hub 1-6:1.0: TT requires at most 8 FS bit times (666 ns)
-hub 1-6:1.0: Port indicators are supported
-hub 1-6:1.0: power on to power good time: 100ms
 usb usb2: usb_probe_device
 usb usb2: configuration #1 chosen from 1 choice
-hub 1-6:1.0: local power source is good
-hub 1-6:1.0: enabling power on all ports
 usb usb2: adding 2-0:1.0 (config #1, interface 0)
 usb 2-0:1.0: uevent
 hub 2-0:1.0: usb_probe_interface
@@ -1057,10 +1074,6 @@
 hub 2-0:1.0: power on to power good time: 2ms
 hub 2-0:1.0: local power source is good
 hub 2-0:1.0: trying to enable port power on non-switchable hub
-usb 1-6: link qh256-0001/ffff81007f802140 start 255 [1/0 us]
-usb 1-6: New USB device found, idVendor=04b4, idProduct=6560
-usb 1-6: New USB device strings: Mfr=0, Product=0, SerialNumber=0
-hub 1-6:1.0: state 7 ports 4 chg 0000 evt 0000
 hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
 usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
@@ -1120,19 +1133,14 @@
 usb 3-1: Manufacturer: HP
 uhci_hcd 0000:01:04.4: port 2 portsc 0083,00
 hub 3-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
-ohci_hcd 0000:00:02.0: auto-stop root hub
 hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
+ohci_hcd 0000:00:02.0: auto-stop root hub
 usb 3-2: new full speed USB device using uhci_hcd and address 3
 uhci_hcd 0000:01:04.4: port 2 portsc 0083,00
 hub 3-0:1.0: unable to enumerate USB device on port 2
-hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
-usbcore: registered new interface driver usblp
-Initializing USB Mass Storage driver...
 hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004
 uhci_hcd 0000:01:04.4: port 2 portsc 0083,00
 hub 3-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
-usbcore: registered new interface driver usb-storage
-USB Mass Storage support registered.
 hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
 usb 3-2: new full speed USB device using uhci_hcd and address 4
 usb 3-2: default language 0x0409
@@ -1158,14 +1166,18 @@
 usb 3-2: Manufacturer: HP
 hub 3-2:1.0: state 7 ports 7 chg 0000 evt 0000
 usb 3-2: remote wakeup needed for autosuspend
+usbcore: registered new interface driver usblp
+Initializing USB Mass Storage driver...
+usbcore: registered new interface driver usb-storage
+USB Mass Storage support registered.
 usbcore: registered new interface driver libusual
-PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
 hub 1-6:1.0: hub_suspend
 usb 1-6: unlink qh256-0001/ffff81007f802140 start 255 [1/0 us]
 usb 1-6: usb auto-suspend
 hub 2-0:1.0: hub_suspend
 usb usb2: bus auto-suspend
 ohci_hcd 0000:00:02.0: suspend root hub
+PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
 serio: i8042 KBD port at 0x60,0x64 irq 1
 serio: i8042 AUX port at 0x60,0x64 irq 12
 mice: PS/2 mouse device common for all mice
@@ -1202,10 +1214,10 @@
 RPC: Registered udp transport module.
 RPC: Registered tcp transport module.
 registered taskstats version 1
-  Magic number: 1:878:480
-Freeing unused kernel memory: 404k freed
+  Magic number: 1:122:228
+Freeing unused kernel memory: 408k freed
 Write protecting the kernel read-only data: 6388k
-blacklist used greatest stack depth: 5960 bytes left
+framebuffer used greatest stack depth: 5960 bytes left
 usb usb2: uevent
 usb 2-0:1.0: uevent
 usb usb1: uevent
@@ -1219,7 +1231,7 @@
 usb 3-1:1.1: uevent
 usb 3-2: uevent
 usb 3-2:1.0: uevent
-cdrom_id used greatest stack depth: 5752 bytes left
+cdrom_id used greatest stack depth: 5600 bytes left
 Fusion MPT base driver 3.04.06
 Copyright (c) 1999-2007 LSI Corporation
 Fusion MPT SAS Host driver 3.04.06

--EVF5PPMfhYS0aIcm--
