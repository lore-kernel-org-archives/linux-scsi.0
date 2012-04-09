From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Cannot detect SATA disk's FUA/DPO feature
Date: Mon, 9 Apr 2012 16:34:12 +0800
Message-ID: <20120409083412.GA4927@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="CE+1k2dSO48ffgeK"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61863 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab2DII17 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Apr 2012 04:27:59 -0400
Received: by iagz16 with SMTP id z16so5606229iag.19
        for <linux-scsi@vger.kernel.org>; Mon, 09 Apr 2012 01:27:58 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi list,

Recently I meet a problem in upstream kernel, which the problem is that
disk driver can not detect FUA/DPO feature of SATA disk.  This machine
has two SATA disks, one is C400-MTFDDAK256M and another is WDC
WD1002FAEX-0, both of them are plugged into mainboard.  I read the data
sheet and both of them support FUA feature.  I am not sure whether this
is a bug or not in kernel.  Meanwhile, I have tested in SAS disk and
kernel displays that the disk supports FUA feature in dmesg.

When we detect FUA feature for SAS disk in kernel, we will use SCSI
command set to detect FUA feature.  Namely, in current kernel, we use
FUA bit to check whether this SAS disk supports FUA feature or not.
However, SATA disk uses ATA command set.  So in current kernel, this
method doesn't detect whether or not SATA disk supports FUA feature.  Am
I missing something?

I put dmesg file in attachment.  Hopefully it is useful.

Regards,
Zheng

--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.0-rc7 (root@rh2285_snb2) (gcc version 4.4.5 20110214 (Red Hat 4.4.5-6) (GCC) ) #1 SMP Mon Apr 2 03:14:40 CST 2012
[    0.000000] Command line: ro root=UUID=039bf3fc-7c78-4716-af1a-cb204cca9649 rd_NO_LUKS rd_NO_LVM rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us crashkernel=auto hda=noprobe rhgb quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
[    0.000000]  BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000b9612000 (usable)
[    0.000000]  BIOS-e820: 00000000b9612000 - 00000000b968d000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000b968d000 - 00000000b9783000 (usable)
[    0.000000]  BIOS-e820: 00000000b9783000 - 00000000b9986000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000b9986000 - 00000000bac27000 (usable)
[    0.000000]  BIOS-e820: 00000000bac27000 - 00000000bac35000 (reserved)
[    0.000000]  BIOS-e820: 00000000bac35000 - 00000000bda01000 (usable)
[    0.000000]  BIOS-e820: 00000000bda01000 - 00000000bdc01000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdc01000 - 00000000bdce0000 (usable)
[    0.000000]  BIOS-e820: 00000000bdce0000 - 00000000bdde7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bdde7000 - 00000000bde81000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bde81000 - 00000000bde82000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bde82000 - 00000000bdefa000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdefa000 - 00000000bdefb000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bdefb000 - 00000000bdefd000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdefd000 - 00000000bdefe000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bdefe000 - 00000000bdeff000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdeff000 - 00000000bdf1a000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bdf1a000 - 00000000bdfa7000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdfa7000 - 00000000be000000 (usable)
[    0.000000]  BIOS-e820: 00000000be000000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed19000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffa20000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000840000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Intel Corporation S2600CP/S2600CP, BIOS SE5C600.86B.99.99.x036.091920111209 09/19/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x840000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-through
[    0.000000]   CC000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask 3FFF80000000 write-back
[    0.000000]   1 base 000080000000 mask 3FFFC0000000 write-back
[    0.000000]   2 base 000100000000 mask 3FFF00000000 write-back
[    0.000000]   3 base 000200000000 mask 3FFE00000000 write-back
[    0.000000]   4 base 000400000000 mask 3FFC00000000 write-back
[    0.000000]   5 base 000800000000 mask 3FFFC0000000 write-back
[    0.000000]   6 base 0000FF800000 mask 3FFFFF800000 write-protect
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbe000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fcd20] fcd20
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 20480
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000be000000
[    0.000000]  0000000000 - 0080000000 page 1G
[    0.000000]  0080000000 - 00be000000 page 2M
[    0.000000] kernel direct mapping tables up to be000000 @ 1fffe000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000840000000
[    0.000000]  0100000000 - 0840000000 page 1G
[    0.000000] kernel direct mapping tables up to 840000000 @ bdfff000-be000000
[    0.000000] RAMDISK: 37350000 - 37ff0000
[    0.000000] crashkernel: memory value expected
[    0.000000] ACPI: RSDP 00000000000f0410 00024 (v02 INTEL )
[    0.000000] ACPI: XSDT 00000000bdf17d98 000B4 (v01 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: FACP 00000000bdf17918 000F4 (v04 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI Warning: Invalid length for Pm1aControlBlock: 32, using default 16 (20120111/tbfadt-629)
[    0.000000] ACPI: DSDT 00000000bdeff018 168AA (v02 INTEL   S2600CP 00000099 INTL 20100331)
[    0.000000] ACPI: FACS 00000000bdf17f40 00040
[    0.000000] ACPI: APIC 00000000bdf16718 0066A (v03 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: SPMI 00000000bdf19b98 00040 (v05 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: MCFG 00000000bdf19b18 0003C (v01 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: WDDT 00000000bdf19f18 00040 (v01 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: SRAT 00000000bdefdc18 002A8 (v03 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: SLIT 00000000bdf19e98 00030 (v01 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: MSCT 00000000bdf18e18 00090 (v01 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: HPET 00000000bdf19e18 00038 (v01 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: SSDT 00000000bdf19d18 0002B (v02 INTEL   S2600CP 00001000 INTL 20100331)
[    0.000000] ACPI: SSDT 00000000b9612018 7A0C4 (v02 INTEL   S2600CP 00004000 INTL 20100331)
[    0.000000] ACPI: HEST 00000000bde81f18 000A8 (v01 INTEL   S2600CP 00000001 INTL 00000001)
[    0.000000] ACPI: BERT 00000000bdf19d98 00030 (v01 INTEL   S2600CP 00000001 INTL 00000001)
[    0.000000] ACPI: ERST 00000000bde81c98 00230 (v01 INTEL   S2600CP 00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 00000000bdf17798 00130 (v01 INTEL   S2600CP 00000001 INTL 00000001)
[    0.000000] ACPI: SSDT 00000000bdefa018 00F98 (v02 INTEL   S2600CP 00000002 INTL 20100331)
[    0.000000] ACPI: SSDT 00000000bdf19c98 00045 (v02 INTEL   S2600CP 00000001 INTL 20100331)
[    0.000000] ACPI: SSDT 00000000bdf16e18 00181 (v02 INTEL   S2600CP 00000003 INTL 20100331)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x08 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x09 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0c -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0d -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0e -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0f -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x28 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x29 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2c -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2d -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2e -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2f -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 0-c0000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-440000000
[    0.000000] SRAT: Node 1 PXM 1 440000000-840000000
[    0.000000] NUMA: Initialized distance table, cnt=2
[    0.000000] NUMA: Node 0 [0,c0000000) + [100000000,440000000) -> [0,440000000)
[    0.000000] Initmem setup node 0 0000000000000000-0000000440000000
[    0.000000]   NODE_DATA [000000043ffec000 - 000000043fffffff]
[    0.000000] Initmem setup node 1 0000000440000000-0000000840000000
[    0.000000]   NODE_DATA [000000083ffeb000 - 000000083fffefff]
[    0.000000]  [ffffea0000000000-ffffea000edfffff] PMD -> [ffff88042fe00000-ffff88043ddfffff] on node 0
[    0.000000]  [ffffea000ee00000-ffffea001cdfffff] PMD -> [ffff88082f600000-ffff88083d5fffff] on node 1
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00840000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009b
[    0.000000]     0: 0x00000100 -> 0x000b9612
[    0.000000]     0: 0x000b968d -> 0x000b9783
[    0.000000]     0: 0x000b9986 -> 0x000bac27
[    0.000000]     0: 0x000bac35 -> 0x000bda01
[    0.000000]     0: 0x000bdc01 -> 0x000bdce0
[    0.000000]     0: 0x000bdfa7 -> 0x000be000
[    0.000000]     0: 0x00100000 -> 0x00440000
[    0.000000]     1: 0x00440000 -> 0x00840000
[    0.000000] On node 0 totalpages: 4184120
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3918 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 757989 pages, LIFO batch:31
[    0.000000]   Normal zone: 46592 pages used for memmap
[    0.000000]   Normal zone: 3361280 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 4194304
[    0.000000]   Normal zone: 57344 pages used for memmap
[    0.000000]   Normal zone: 4136960 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: X2APIC (apic_id[0x00] uid[0x00] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x01] uid[0x01] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x02] uid[0x02] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x03] uid[0x03] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x04] uid[0x04] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x05] uid[0x05] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x06] uid[0x06] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x07] uid[0x07] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x08] uid[0x08] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x09] uid[0x09] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0a] uid[0x0a] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0b] uid[0x0b] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0c] uid[0x0c] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0d] uid[0x0d] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0e] uid[0x0e] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0f] uid[0x0f] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x10] uid[0x10] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x11] uid[0x11] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x12] uid[0x12] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x13] uid[0x13] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x14] uid[0x14] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x15] uid[0x15] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x16] uid[0x16] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x17] uid[0x17] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x18] uid[0x18] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x19] uid[0x19] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1a] uid[0x1a] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1b] uid[0x1b] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1c] uid[0x1c] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1d] uid[0x1d] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1e] uid[0x1e] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1f] uid[0x1f] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x20] uid[0x20] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x21] uid[0x21] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x22] uid[0x22] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x23] uid[0x23] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x24] uid[0x24] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x25] uid[0x25] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x26] uid[0x26] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x27] uid[0x27] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x28] uid[0x28] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x29] uid[0x29] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2a] uid[0x2a] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2b] uid[0x2b] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2c] uid[0x2c] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2d] uid[0x2d] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2e] uid[0x2e] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2f] uid[0x2f] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x30] uid[0x30] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x31] uid[0x31] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x32] uid[0x32] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x33] uid[0x33] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x34] uid[0x34] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x35] uid[0x35] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x36] uid[0x36] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x37] uid[0x37] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x38] uid[0x38] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x39] uid[0x39] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3a] uid[0x3a] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3b] uid[0x3b] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3c] uid[0x3c] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3d] uid[0x3d] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3e] uid[0x3e] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3f] uid[0x3f] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x08] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x0a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x0c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x28] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x2a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x2c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x2e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x09] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x0b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x0d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x0f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x29] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x2b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x2d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x2f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec3f000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 1, version 32, address 0xfec3f000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec7f000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 2, version 32, address 0xfec7f000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 64 CPUs, 32 hotplug CPUs
[    0.000000] nr_irqs_gsi: 88
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000b9612000 - 00000000b968d000
[    0.000000] PM: Registered nosave memory: 00000000b9783000 - 00000000b9986000
[    0.000000] PM: Registered nosave memory: 00000000bac27000 - 00000000bac35000
[    0.000000] PM: Registered nosave memory: 00000000bda01000 - 00000000bdc01000
[    0.000000] PM: Registered nosave memory: 00000000bdce0000 - 00000000bdde7000
[    0.000000] PM: Registered nosave memory: 00000000bdde7000 - 00000000bde81000
[    0.000000] PM: Registered nosave memory: 00000000bde81000 - 00000000bde82000
[    0.000000] PM: Registered nosave memory: 00000000bde82000 - 00000000bdefa000
[    0.000000] PM: Registered nosave memory: 00000000bdefa000 - 00000000bdefb000
[    0.000000] PM: Registered nosave memory: 00000000bdefb000 - 00000000bdefd000
[    0.000000] PM: Registered nosave memory: 00000000bdefd000 - 00000000bdefe000
[    0.000000] PM: Registered nosave memory: 00000000bdefe000 - 00000000bdeff000
[    0.000000] PM: Registered nosave memory: 00000000bdeff000 - 00000000bdf1a000
[    0.000000] PM: Registered nosave memory: 00000000bdf1a000 - 00000000bdfa7000
[    0.000000] PM: Registered nosave memory: 00000000be000000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed19000
[    0.000000] PM: Registered nosave memory: 00000000fed19000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffa20000
[    0.000000] PM: Registered nosave memory: 00000000ffa20000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:2ec00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:64 nr_node_ids:2
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88043fa00000 s81984 r8192 d24512 u131072
[    0.000000] pcpu-alloc: s81984 r8192 d24512 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 16 17 18 19 20 21 22 23 
[    0.000000] pcpu-alloc: [0] 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 
[    0.000000] pcpu-alloc: [1] 08 09 10 11 12 13 14 15 24 25 26 27 28 29 30 31 
[    0.000000] pcpu-alloc: [1] 33 35 37 39 41 43 45 47 49 51 53 55 57 59 61 63 
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 8260147
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: ro root=UUID=039bf3fc-7c78-4716-af1a-cb204cca9649 rd_NO_LUKS rd_NO_LVM rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us crashkernel=auto hda=noprobe rhgb quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 32954336k/34603008k available (5303k kernel code, 1089312k absent, 559360k reserved, 5689k data, 1096k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:16640 nr_irqs:2008 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 134217728 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2693.485 MHz processor.
[    0.000027] Calibrating delay loop (skipped), value calculated using timer frequency.. 5386.97 BogoMIPS (lpj=2693485)
[    0.000030] pid_max: default: 65536 minimum: 512
[    0.000091] Security Framework initialized
[    0.000098] SELinux:  Initializing.
[    0.000112] SELinux:  Starting in permissive mode
[    0.002859] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.009532] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.012119] Mount-cache hash table entries: 256
[    0.012318] Initializing cgroup subsys cpuacct
[    0.012320] Initializing cgroup subsys memory
[    0.012350] Initializing cgroup subsys devices
[    0.012352] Initializing cgroup subsys freezer
[    0.012353] Initializing cgroup subsys net_cls
[    0.012355] Initializing cgroup subsys blkio
[    0.012362] Initializing cgroup subsys perf_event
[    0.012418] CPU: Physical Processor ID: 0
[    0.012419] CPU: Processor Core ID: 0
[    0.012424] mce: CPU supports 20 MCE banks
[    0.012451] CPU0: Thermal monitoring enabled (TM1)
[    0.012466] using mwait in idle threads.
[    0.013680] ACPI: Core revision 20120111
[    0.059596] ftrace: allocating 21173 entries in 83 pages
[    0.070828] Switched APIC routing to physical flat.
[    0.071438] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.081436] CPU0: Genuine Intel(R) CPU  @ 2.70GHz stepping 05
[    0.182931] Performance Events: PEBS fmt1+, SandyBridge events, Intel PMU driver.
[    0.182936] ... version:                3
[    0.182937] ... bit width:              48
[    0.182938] ... generic registers:      4
[    0.182939] ... value mask:             0000ffffffffffff
[    0.182941] ... max period:             000000007fffffff
[    0.182942] ... fixed-purpose events:   3
[    0.182943] ... event mask:             000000070000000f
[    0.183986] NMI watchdog enabled, takes one hw-pmu counter.
[    0.184108] Booting Node   0, Processors  #1
[    0.184110] smpboot cpu 1: start_ip = 96000
[    0.217071] NMI watchdog enabled, takes one hw-pmu counter.
[    0.217213]  #2
[    0.217214] smpboot cpu 2: start_ip = 96000
[    0.248461] NMI watchdog enabled, takes one hw-pmu counter.
[    0.248599]  #3
[    0.248600] smpboot cpu 3: start_ip = 96000
[    0.279848] NMI watchdog enabled, takes one hw-pmu counter.
[    0.279991]  #4
[    0.279992] smpboot cpu 4: start_ip = 96000
[    0.311239] NMI watchdog enabled, takes one hw-pmu counter.
[    0.311374]  #5
[    0.311375] smpboot cpu 5: start_ip = 96000
[    0.342623] NMI watchdog enabled, takes one hw-pmu counter.
[    0.342762]  #6
[    0.342763] smpboot cpu 6: start_ip = 96000
[    0.374007] NMI watchdog enabled, takes one hw-pmu counter.
[    0.374153]  #7
[    0.374155] smpboot cpu 7: start_ip = 96000
[    0.405403] NMI watchdog enabled, takes one hw-pmu counter.
[    0.405604]  Ok.
[    0.405605] Booting Node   1, Processors  #8
[    0.405607] smpboot cpu 8: start_ip = 96000
[    0.496813] NMI watchdog enabled, takes one hw-pmu counter.
[    0.496977]  #9
[    0.496978] smpboot cpu 9: start_ip = 96000
[    0.528604] NMI watchdog enabled, takes one hw-pmu counter.
[    0.528779]  #10
[    0.528780] smpboot cpu 10: start_ip = 96000
[    0.560409] NMI watchdog enabled, takes one hw-pmu counter.
[    0.560558]  #11
[    0.560559] smpboot cpu 11: start_ip = 96000
[    0.592288] NMI watchdog enabled, takes one hw-pmu counter.
[    0.592431]  #12
[    0.592432] smpboot cpu 12: start_ip = 96000
[    0.624160] NMI watchdog enabled, takes one hw-pmu counter.
[    0.624307]  #13
[    0.624308] smpboot cpu 13: start_ip = 96000
[    0.655933] NMI watchdog enabled, takes one hw-pmu counter.
[    0.656081]  #14
[    0.656082] smpboot cpu 14: start_ip = 96000
[    0.687707] NMI watchdog enabled, takes one hw-pmu counter.
[    0.687849]  #15
[    0.687850] smpboot cpu 15: start_ip = 96000
[    0.719478] NMI watchdog enabled, takes one hw-pmu counter.
[    0.719595]  Ok.
[    0.719596] Booting Node   0, Processors  #16
[    0.719598] smpboot cpu 16: start_ip = 96000
[    0.750857] NMI watchdog enabled, takes one hw-pmu counter.
[    0.751000]  #17
[    0.751002] smpboot cpu 17: start_ip = 96000
[    0.782236] NMI watchdog enabled, takes one hw-pmu counter.
[    0.782378]  #18
[    0.782379] smpboot cpu 18: start_ip = 96000
[    0.813611] NMI watchdog enabled, takes one hw-pmu counter.
[    0.813756]  #19
[    0.813757] smpboot cpu 19: start_ip = 96000
[    0.844989] NMI watchdog enabled, takes one hw-pmu counter.
[    0.845128]  #20
[    0.845129] smpboot cpu 20: start_ip = 96000
[    0.876367] NMI watchdog enabled, takes one hw-pmu counter.
[    0.876508]  #21
[    0.876509] smpboot cpu 21: start_ip = 96000
[    0.907742] NMI watchdog enabled, takes one hw-pmu counter.
[    0.907884]  #22
[    0.907885] smpboot cpu 22: start_ip = 96000
[    0.939119] NMI watchdog enabled, takes one hw-pmu counter.
[    0.939261]  #23
[    0.939262] smpboot cpu 23: start_ip = 96000
[    0.970496] NMI watchdog enabled, takes one hw-pmu counter.
[    0.970681]  Ok.
[    0.970682] Booting Node   1, Processors  #24
[    0.970683] smpboot cpu 24: start_ip = 96000
[    1.002309] NMI watchdog enabled, takes one hw-pmu counter.
[    1.002454]  #25
[    1.002455] smpboot cpu 25: start_ip = 96000
[    1.034082] NMI watchdog enabled, takes one hw-pmu counter.
[    1.034225]  #26
[    1.034226] smpboot cpu 26: start_ip = 96000
[    1.065851] NMI watchdog enabled, takes one hw-pmu counter.
[    1.065986]  #27
[    1.065987] smpboot cpu 27: start_ip = 96000
[    1.097715] NMI watchdog enabled, takes one hw-pmu counter.
[    1.097851]  #28
[    1.097852] smpboot cpu 28: start_ip = 96000
[    1.129577] NMI watchdog enabled, takes one hw-pmu counter.
[    1.129720]  #29
[    1.129721] smpboot cpu 29: start_ip = 96000
[    1.161347] NMI watchdog enabled, takes one hw-pmu counter.
[    1.161481]  #30
[    1.161482] smpboot cpu 30: start_ip = 96000
[    1.193108] NMI watchdog enabled, takes one hw-pmu counter.
[    1.193250]  #31
[    1.193251] smpboot cpu 31: start_ip = 96000
[    1.224878] NMI watchdog enabled, takes one hw-pmu counter.
[    1.224903] Brought up 32 CPUs
[    1.224906] Total of 32 processors activated (172371.61 BogoMIPS).
[    1.280088] devtmpfs: initialized
[    1.285087] PM: Registering ACPI NVS region at b9783000 (2109440 bytes)
[    1.285165] PM: Registering ACPI NVS region at bda01000 (2097152 bytes)
[    1.285245] PM: Registering ACPI NVS region at bdde7000 (630784 bytes)
[    1.285280] PM: Registering ACPI NVS region at bde82000 (491520 bytes)
[    1.285300] PM: Registering ACPI NVS region at bdefb000 (8192 bytes)
[    1.285302] PM: Registering ACPI NVS region at bdefe000 (4096 bytes)
[    1.285304] PM: Registering ACPI NVS region at bdf1a000 (577536 bytes)
[    1.286053] print_constraints: dummy: 
[    1.286085] RTC time:  4:22:57, date: 04/02/12
[    1.286218] NET: Registered protocol family 16
[    1.286392] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    1.286394] ACPI: bus type pci registered
[    1.286475] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    1.286478] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
[    1.364022] PCI: Using configuration type 1 for base access
[    1.365937] bio: create slab <bio-0> at 0
[    1.366191] ACPI: Added _OSI(Module Device)
[    1.366193] ACPI: Added _OSI(Processor Device)
[    1.366195] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.366196] ACPI: Added _OSI(Processor Aggregator Device)
[    1.372479] ACPI: EC: Look up EC in DSDT
[    1.379130] ACPI: Executed 1 blocks of module-level executable AML code
[    1.527717] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.541532] ACPI: Interpreter enabled
[    1.541535] ACPI: (supports S0 S1 S5)
[    1.541556] ACPI: Using IOAPIC for interrupt routing
[    1.565611] ACPI: No dock devices found.
[    1.565704] HEST: Table parsing has been initialized.
[    1.565711] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.566757] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7e])
[    1.567486] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.567490] pci_root PNP0A08:00: host bridge window [io  0x0000-0xbfff]
[    1.567495] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.567498] pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000c3fff]
[    1.567502] pci_root PNP0A08:00: host bridge window [mem 0x000c4000-0x000c7fff]
[    1.567506] pci_root PNP0A08:00: host bridge window [mem 0x000c8000-0x000cbfff]
[    1.567510] pci_root PNP0A08:00: host bridge window [mem 0x000cc000-0x000cffff]
[    1.567513] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
[    1.567517] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    1.567521] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    1.567525] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
[    1.567528] pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x000e3fff]
[    1.567532] pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x000e7fff]
[    1.567536] pci_root PNP0A08:00: host bridge window [mem 0x000e8000-0x000ebfff]
[    1.567539] pci_root PNP0A08:00: host bridge window [mem 0x000ec000-0x000effff]
[    1.567543] pci_root PNP0A08:00: host bridge window [mem 0x000f0000-0x000fffff]
[    1.567547] pci_root PNP0A08:00: host bridge window [mem 0xd0000000-0xebffffff]
[    1.567551] pci_root PNP0A08:00: host bridge window [mem 0x3c0000000000-0x3c007fffffff]
[    1.567558] pci_root PNP0A08:00: host bridge window expanded to [io  0x0000-0xbfff]; [io  0x0000-0xbfff] ignored
[    1.567567] pci_root PNP0A08:00: ignoring host bridge window [mem 0x000c8000-0x000cbfff] (conflicts with Adapter ROM [mem 0x000cb800-0x000cc7ff])
[    1.567573] pci_root PNP0A08:00: ignoring host bridge window [mem 0x000cc000-0x000cffff] (conflicts with Adapter ROM [mem 0x000cb800-0x000cc7ff])
[    1.567637] PCI host bridge to bus 0000:00
[    1.567641] pci_bus 0000:00: root bus resource [io  0x0000-0xbfff]
[    1.567645] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.567648] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    1.567652] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    1.567655] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    1.567658] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    1.567662] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    1.567665] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    1.567669] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    1.567672] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    1.567676] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
[    1.567679] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
[    1.567683] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff]
[    1.567687] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xebffffff]
[    1.567690] pci_bus 0000:00: root bus resource [mem 0x3c0000000000-0x3c007fffffff]
[    1.567713] pci 0000:00:00.0: [8086:3c00] type 0 class 0x000600
[    1.567793] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.567831] pci 0000:00:01.0: [8086:3c02] type 1 class 0x000604
[    1.567924] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.567962] pci 0000:00:02.0: [8086:3c04] type 1 class 0x000604
[    1.568053] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    1.568095] pci 0000:00:02.2: [8086:3c06] type 1 class 0x000604
[    1.568186] pci 0000:00:02.2: PME# supported from D0 D3hot D3cold
[    1.568233] pci 0000:00:03.0: [8086:3c08] type 1 class 0x000604
[    1.568324] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.568365] pci 0000:00:03.2: [8086:3c0a] type 1 class 0x000604
[    1.568455] pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
[    1.568497] pci 0000:00:04.0: [8086:3c20] type 0 class 0x000880
[    1.568517] pci 0000:00:04.0: reg 10: [mem 0xebf90000-0xebf93fff 64bit]
[    1.568630] pci 0000:00:04.1: [8086:3c21] type 0 class 0x000880
[    1.568650] pci 0000:00:04.1: reg 10: [mem 0xebf80000-0xebf83fff 64bit]
[    1.568763] pci 0000:00:04.2: [8086:3c22] type 0 class 0x000880
[    1.568783] pci 0000:00:04.2: reg 10: [mem 0xebf70000-0xebf73fff 64bit]
[    1.568897] pci 0000:00:04.3: [8086:3c23] type 0 class 0x000880
[    1.568917] pci 0000:00:04.3: reg 10: [mem 0xebf60000-0xebf63fff 64bit]
[    1.569027] pci 0000:00:04.4: [8086:3c24] type 0 class 0x000880
[    1.569047] pci 0000:00:04.4: reg 10: [mem 0xebf50000-0xebf53fff 64bit]
[    1.569159] pci 0000:00:04.5: [8086:3c25] type 0 class 0x000880
[    1.569178] pci 0000:00:04.5: reg 10: [mem 0xebf40000-0xebf43fff 64bit]
[    1.569292] pci 0000:00:04.6: [8086:3c26] type 0 class 0x000880
[    1.569311] pci 0000:00:04.6: reg 10: [mem 0xebf30000-0xebf33fff 64bit]
[    1.569423] pci 0000:00:04.7: [8086:3c27] type 0 class 0x000880
[    1.569443] pci 0000:00:04.7: reg 10: [mem 0xebf20000-0xebf23fff 64bit]
[    1.569551] pci 0000:00:05.0: [8086:3c28] type 0 class 0x000880
[    1.569659] pci 0000:00:05.2: [8086:3c2a] type 0 class 0x000880
[    1.569767] pci 0000:00:05.4: [8086:3c2c] type 0 class 0x000800
[    1.569784] pci 0000:00:05.4: reg 10: [mem 0xd0e60000-0xd0e60fff]
[    1.569899] pci 0000:00:11.0: [8086:1d3e] type 1 class 0x000604
[    1.570017] pci 0000:00:11.0: PME# supported from D0 D3hot D3cold
[    1.570064] pci 0000:00:16.0: [8086:1d3a] type 0 class 0x000780
[    1.570091] pci 0000:00:16.0: reg 10: [mem 0xd0e50000-0xd0e5000f 64bit]
[    1.570177] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.570209] pci 0000:00:16.1: [8086:1d3b] type 0 class 0x000780
[    1.570237] pci 0000:00:16.1: reg 10: [mem 0xd0e40000-0xd0e4000f 64bit]
[    1.570323] pci 0000:00:16.1: PME# supported from D0 D3hot D3cold
[    1.570371] pci 0000:00:1a.0: [8086:1d2d] type 0 class 0x000c03
[    1.570398] pci 0000:00:1a.0: reg 10: [mem 0xd0e20000-0xd0e203ff]
[    1.570514] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.570549] pci 0000:00:1c.0: [8086:1d10] type 1 class 0x000604
[    1.570653] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.570697] pci 0000:00:1c.7: [8086:1d1e] type 1 class 0x000604
[    1.570802] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    1.570842] pci 0000:00:1d.0: [8086:1d26] type 0 class 0x000c03
[    1.570870] pci 0000:00:1d.0: reg 10: [mem 0xd0e10000-0xd0e103ff]
[    1.570986] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.571017] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    1.571103] pci 0000:00:1f.0: [8086:1d41] type 0 class 0x000601
[    1.571264] pci 0000:00:1f.2: [8086:1d02] type 0 class 0x000106
[    1.571290] pci 0000:00:1f.2: reg 10: [io  0x3070-0x3077]
[    1.571302] pci 0000:00:1f.2: reg 14: [io  0x3060-0x3063]
[    1.571313] pci 0000:00:1f.2: reg 18: [io  0x3050-0x3057]
[    1.571325] pci 0000:00:1f.2: reg 1c: [io  0x3040-0x3043]
[    1.571336] pci 0000:00:1f.2: reg 20: [io  0x3020-0x303f]
[    1.571347] pci 0000:00:1f.2: reg 24: [mem 0xd0e00000-0xd0e007ff]
[    1.571412] pci 0000:00:1f.2: PME# supported from D3hot
[    1.571440] pci 0000:00:1f.3: [8086:1d22] type 0 class 0x000c05
[    1.571461] pci 0000:00:1f.3: reg 10: [mem 0xebf10000-0xebf100ff 64bit]
[    1.571490] pci 0000:00:1f.3: reg 20: [io  0x3000-0x301f]
[    1.571583] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.571667] pci 0000:02:00.0: [1c5f:0002] type 0 class 0x000180
[    1.571683] pci 0000:02:00.0: reg 10: [mem 0xd0c00000-0xd0c00fff]
[    1.571738] pci 0000:02:00.0: reg 30: [mem 0xd0b00000-0xd0bfffff pref]
[    1.571787] pci 0000:02:00.0: PME# supported from D0
[    1.573217] pci 0000:00:02.0: PCI bridge to [bus 02-02]
[    1.573226] pci 0000:00:02.0:   bridge window [mem 0xd0b00000-0xd0cfffff]
[    1.573289] pci 0000:00:02.2: PCI bridge to [bus 03-03]
[    1.573354] pci 0000:00:03.0: PCI bridge to [bus 04-04]
[    1.573419] pci 0000:00:03.2: PCI bridge to [bus 05-05]
[    1.573517] pci 0000:06:00.0: [8086:1d69] type 0 class 0x000107
[    1.573541] pci 0000:06:00.0: reg 10: [mem 0xebc00000-0xebc03fff 64bit pref]
[    1.573561] pci 0000:06:00.0: reg 18: [mem 0xeb800000-0xebbfffff 64bit pref]
[    1.573575] pci 0000:06:00.0: reg 20: [io  0x2000-0x20ff]
[    1.573700] pci 0000:06:00.0: reg 164: [mem 0xebc10000-0xebc13fff 64bit pref]
[    1.573762] pci 0000:06:00.3: [8086:1d70] type 0 class 0x000c05
[    1.573782] pci 0000:06:00.3: reg 10: [mem 0xd0d00000-0xd0d00fff]
[    1.573832] pci 0000:06:00.3: reg 20: [io  0x2100-0x211f]
[    1.573919] pci 0000:06:00.3: PME# supported from D0 D3hot D3cold
[    1.573975] pci 0000:00:11.0: PCI bridge to [bus 06-06]
[    1.573981] pci 0000:00:11.0:   bridge window [io  0x2000-0x2fff]
[    1.573987] pci 0000:00:11.0:   bridge window [mem 0xd0d00000-0xd0dfffff]
[    1.573997] pci 0000:00:11.0:   bridge window [mem 0xeb800000-0xebcfffff 64bit pref]
[    1.574090] pci 0000:07:00.0: [8086:1521] type 0 class 0x000200
[    1.574113] pci 0000:07:00.0: reg 10: [mem 0xd0960000-0xd097ffff]
[    1.574145] pci 0000:07:00.0: reg 18: [io  0x1060-0x107f]
[    1.574162] pci 0000:07:00.0: reg 1c: [mem 0xd09b0000-0xd09b3fff]
[    1.574294] pci 0000:07:00.0: PME# supported from D0 D3hot D3cold
[    1.574358] pci 0000:07:00.0: reg 184: [mem 0xd0aa0000-0xd0aa3fff]
[    1.574398] pci 0000:07:00.0: reg 190: [mem 0xd0a80000-0xd0a83fff]
[    1.574462] pci 0000:07:00.1: [8086:1521] type 0 class 0x000200
[    1.574485] pci 0000:07:00.1: reg 10: [mem 0xd0940000-0xd095ffff]
[    1.574517] pci 0000:07:00.1: reg 18: [io  0x1040-0x105f]
[    1.574534] pci 0000:07:00.1: reg 1c: [mem 0xd09a0000-0xd09a3fff]
[    1.574663] pci 0000:07:00.1: PME# supported from D0 D3hot D3cold
[    1.574720] pci 0000:07:00.1: reg 184: [mem 0xd0a60000-0xd0a63fff]
[    1.574761] pci 0000:07:00.1: reg 190: [mem 0xd0a40000-0xd0a43fff]
[    1.574825] pci 0000:07:00.2: [8086:1521] type 0 class 0x000200
[    1.574848] pci 0000:07:00.2: reg 10: [mem 0xd0920000-0xd093ffff]
[    1.574880] pci 0000:07:00.2: reg 18: [io  0x1020-0x103f]
[    1.574897] pci 0000:07:00.2: reg 1c: [mem 0xd0990000-0xd0993fff]
[    1.575025] pci 0000:07:00.2: PME# supported from D0 D3hot D3cold
[    1.575082] pci 0000:07:00.2: reg 184: [mem 0xd0a20000-0xd0a23fff]
[    1.575122] pci 0000:07:00.2: reg 190: [mem 0xd0a00000-0xd0a03fff]
[    1.575186] pci 0000:07:00.3: [8086:1521] type 0 class 0x000200
[    1.575212] pci 0000:07:00.3: reg 10: [mem 0xd0900000-0xd091ffff]
[    1.575243] pci 0000:07:00.3: reg 18: [io  0x1000-0x101f]
[    1.575261] pci 0000:07:00.3: reg 1c: [mem 0xd0980000-0xd0983fff]
[    1.575389] pci 0000:07:00.3: PME# supported from D0 D3hot D3cold
[    1.575446] pci 0000:07:00.3: reg 184: [mem 0xd09e0000-0xd09e3fff]
[    1.575485] pci 0000:07:00.3: reg 190: [mem 0xd09c0000-0xd09c3fff]
[    1.577221] pci 0000:00:1c.0: PCI bridge to [bus 07-08]
[    1.577227] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    1.577233] pci 0000:00:1c.0:   bridge window [mem 0xd0900000-0xd0afffff]
[    1.577327] pci 0000:09:00.0: [102b:0522] type 0 class 0x000300
[    1.577356] pci 0000:09:00.0: reg 10: [mem 0xea000000-0xeaffffff pref]
[    1.577377] pci 0000:09:00.0: reg 14: [mem 0xd0810000-0xd0813fff]
[    1.577398] pci 0000:09:00.0: reg 18: [mem 0xd0000000-0xd07fffff]
[    1.577471] pci 0000:09:00.0: reg 30: [mem 0xd0800000-0xd080ffff pref]
[    1.577592] pci 0000:09:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.577607] pci 0000:00:1c.7: PCI bridge to [bus 09-09]
[    1.577615] pci 0000:00:1c.7:   bridge window [mem 0xd0000000-0xd08fffff]
[    1.577624] pci 0000:00:1c.7:   bridge window [mem 0xea000000-0xeaffffff 64bit pref]
[    1.577709] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a] (subtractive decode)
[    1.577723] pci 0000:00:1e.0:   bridge window [io  0x0000-0xbfff] (subtractive decode)
[    1.577730] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.577734] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000c3fff] (subtractive decode)
[    1.577738] pci 0000:00:1e.0:   bridge window [mem 0x000c4000-0x000c7fff] (subtractive decode)
[    1.577743] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    1.577747] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    1.577751] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    1.577755] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    1.577760] pci 0000:00:1e.0:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
[    1.577764] pci 0000:00:1e.0:   bridge window [mem 0x000e4000-0x000e7fff] (subtractive decode)
[    1.577768] pci 0000:00:1e.0:   bridge window [mem 0x000e8000-0x000ebfff] (subtractive decode)
[    1.577772] pci 0000:00:1e.0:   bridge window [mem 0x000ec000-0x000effff] (subtractive decode)
[    1.577777] pci 0000:00:1e.0:   bridge window [mem 0x000f0000-0x000fffff] (subtractive decode)
[    1.577781] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xebffffff] (subtractive decode)
[    1.577785] pci 0000:00:1e.0:   bridge window [mem 0x3c0000000000-0x3c007fffffff] (subtractive decode)
[    1.577837] pci_bus 0000:00: on NUMA node 0 (pxm 0)
[    1.577844] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.578415] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EVRP._PRT]
[    1.578511] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    1.578642] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP08._PRT]
[    1.578739] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    1.578842] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    1.579005] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
[    1.579170] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR18._PRT]
[    1.579335] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR16._PRT]
[    1.579879]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.580807]  pci0000:00: ACPI _OSC control (0x15) granted
[    1.605720] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-fe])
[    1.606405] pci_root PNP0A08:01: host bridge window [io  0xc000-0xffff]
[    1.606410] pci_root PNP0A08:01: host bridge window [mem 0xec000000-0xfbffffff]
[    1.606415] pci_root PNP0A08:01: host bridge window [mem 0x3c0080000000-0x3c00ffffffff]
[    1.606474] PCI host bridge to bus 0000:80
[    1.606478] pci_bus 0000:80: root bus resource [io  0xc000-0xffff]
[    1.606481] pci_bus 0000:80: root bus resource [mem 0xec000000-0xfbffffff]
[    1.606485] pci_bus 0000:80: root bus resource [mem 0x3c0080000000-0x3c00ffffffff]
[    1.606511] pci 0000:80:02.0: [8086:3c04] type 1 class 0x000604
[    1.606610] pci 0000:80:02.0: PME# supported from D0 D3hot D3cold
[    1.606658] pci 0000:80:04.0: [8086:3c20] type 0 class 0x000880
[    1.606680] pci 0000:80:04.0: reg 10: [mem 0xfbf70000-0xfbf73fff 64bit]
[    1.606802] pci 0000:80:04.1: [8086:3c21] type 0 class 0x000880
[    1.606823] pci 0000:80:04.1: reg 10: [mem 0xfbf60000-0xfbf63fff 64bit]
[    1.606939] pci 0000:80:04.2: [8086:3c22] type 0 class 0x000880
[    1.606960] pci 0000:80:04.2: reg 10: [mem 0xfbf50000-0xfbf53fff 64bit]
[    1.607078] pci 0000:80:04.3: [8086:3c23] type 0 class 0x000880
[    1.607098] pci 0000:80:04.3: reg 10: [mem 0xfbf40000-0xfbf43fff 64bit]
[    1.607218] pci 0000:80:04.4: [8086:3c24] type 0 class 0x000880
[    1.607239] pci 0000:80:04.4: reg 10: [mem 0xfbf30000-0xfbf33fff 64bit]
[    1.607357] pci 0000:80:04.5: [8086:3c25] type 0 class 0x000880
[    1.607378] pci 0000:80:04.5: reg 10: [mem 0xfbf20000-0xfbf23fff 64bit]
[    1.607494] pci 0000:80:04.6: [8086:3c26] type 0 class 0x000880
[    1.607514] pci 0000:80:04.6: reg 10: [mem 0xfbf10000-0xfbf13fff 64bit]
[    1.607632] pci 0000:80:04.7: [8086:3c27] type 0 class 0x000880
[    1.607653] pci 0000:80:04.7: reg 10: [mem 0xfbf00000-0xfbf03fff 64bit]
[    1.607769] pci 0000:80:05.0: [8086:3c28] type 0 class 0x000880
[    1.607883] pci 0000:80:05.2: [8086:3c2a] type 0 class 0x000880
[    1.607995] pci 0000:80:05.4: [8086:3c2c] type 0 class 0x000800
[    1.608014] pci 0000:80:05.4: reg 10: [mem 0xec600000-0xec600fff]
[    1.608201] pci 0000:81:00.0: [1000:0072] type 0 class 0x000107
[    1.608215] pci 0000:81:00.0: reg 10: [io  0xc000-0xc0ff]
[    1.608229] pci 0000:81:00.0: reg 14: [mem 0xec4c0000-0xec4c3fff 64bit]
[    1.608244] pci 0000:81:00.0: reg 1c: [mem 0xec480000-0xec4bffff 64bit]
[    1.608262] pci 0000:81:00.0: reg 30: [mem 0xec000000-0xec07ffff pref]
[    1.608313] pci 0000:81:00.0: supports D1 D2
[    1.608343] pci 0000:81:00.0: reg 174: [mem 0xec4d0000-0xec4d3fff 64bit]
[    1.608354] pci 0000:81:00.0: reg 17c: [mem 0xec080000-0xec0bffff 64bit]
[    1.610193] pci 0000:80:02.0: PCI bridge to [bus 81-81]
[    1.610200] pci 0000:80:02.0:   bridge window [io  0xc000-0xcfff]
[    1.610205] pci 0000:80:02.0:   bridge window [mem 0xec000000-0xec5fffff]
[    1.610222] pci_bus 0000:80: on NUMA node 1 (pxm 1)
[    1.610228] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
[    1.610496] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.BR44._PRT]
[    1.610842]  pci0000:80: Requesting ACPI _OSC control (0x1d)
[    1.611467]  pci0000:80: ACPI _OSC control (0x15) granted
[    1.614619] ACPI: PCI Root Bridge [UCR0] (domain 0000 [bus 7f])
[    1.614693] PCI: root bus 7f: using default resources
[    1.614751] PCI host bridge to bus 0000:7f
[    1.614755] pci_bus 0000:7f: root bus resource [io  0x0000-0xffff]
[    1.614759] pci_bus 0000:7f: root bus resource [mem 0x00000000-0x3fffffffffff]
[    1.614779] pci 0000:7f:08.0: [8086:3c80] type 0 class 0x000880
[    1.614846] pci 0000:7f:08.3: [8086:3c83] type 0 class 0x000880
[    1.614923] pci 0000:7f:08.4: [8086:3c84] type 0 class 0x000880
[    1.615005] pci 0000:7f:09.0: [8086:3c90] type 0 class 0x000880
[    1.615069] pci 0000:7f:09.3: [8086:3c93] type 0 class 0x000880
[    1.615146] pci 0000:7f:09.4: [8086:3c94] type 0 class 0x000880
[    1.615233] pci 0000:7f:0a.0: [8086:3cc0] type 0 class 0x000880
[    1.615288] pci 0000:7f:0a.1: [8086:3cc1] type 0 class 0x000880
[    1.615342] pci 0000:7f:0a.2: [8086:3cc2] type 0 class 0x000880
[    1.615397] pci 0000:7f:0a.3: [8086:3cd0] type 0 class 0x000880
[    1.615459] pci 0000:7f:0b.0: [8086:3ce0] type 0 class 0x000880
[    1.615513] pci 0000:7f:0b.3: [8086:3ce3] type 0 class 0x000880
[    1.615569] pci 0000:7f:0c.0: [8086:3ce8] type 0 class 0x000880
[    1.615622] pci 0000:7f:0c.1: [8086:3ce8] type 0 class 0x000880
[    1.615676] pci 0000:7f:0c.2: [8086:3ce8] type 0 class 0x000880
[    1.615732] pci 0000:7f:0c.3: [8086:3ce8] type 0 class 0x000880
[    1.615788] pci 0000:7f:0c.6: [8086:3cf4] type 0 class 0x000880
[    1.615842] pci 0000:7f:0c.7: [8086:3cf6] type 0 class 0x000880
[    1.615895] pci 0000:7f:0d.0: [8086:3ce8] type 0 class 0x000880
[    1.615949] pci 0000:7f:0d.1: [8086:3ce8] type 0 class 0x000880
[    1.616003] pci 0000:7f:0d.2: [8086:3ce8] type 0 class 0x000880
[    1.616057] pci 0000:7f:0d.3: [8086:3ce8] type 0 class 0x000880
[    1.616113] pci 0000:7f:0d.6: [8086:3cf5] type 0 class 0x000880
[    1.616168] pci 0000:7f:0e.0: [8086:3ca0] type 0 class 0x000880
[    1.616233] pci 0000:7f:0e.1: [8086:3c46] type 0 class 0x001101
[    1.616305] pci 0000:7f:0f.0: [8086:3ca8] type 0 class 0x000880
[    1.616381] pci 0000:7f:0f.1: [8086:3c71] type 0 class 0x000880
[    1.616457] pci 0000:7f:0f.2: [8086:3caa] type 0 class 0x000880
[    1.616534] pci 0000:7f:0f.3: [8086:3cab] type 0 class 0x000880
[    1.616609] pci 0000:7f:0f.4: [8086:3cac] type 0 class 0x000880
[    1.616685] pci 0000:7f:0f.5: [8086:3cad] type 0 class 0x000880
[    1.616759] pci 0000:7f:0f.6: [8086:3cae] type 0 class 0x000880
[    1.616822] pci 0000:7f:10.0: [8086:3cb0] type 0 class 0x000880
[    1.616903] pci 0000:7f:10.1: [8086:3cb1] type 0 class 0x000880
[    1.616979] pci 0000:7f:10.2: [8086:3cb2] type 0 class 0x000880
[    1.617055] pci 0000:7f:10.3: [8086:3cb3] type 0 class 0x000880
[    1.617131] pci 0000:7f:10.4: [8086:3cb4] type 0 class 0x000880
[    1.617210] pci 0000:7f:10.5: [8086:3cb5] type 0 class 0x000880
[    1.617286] pci 0000:7f:10.6: [8086:3cb6] type 0 class 0x000880
[    1.617362] pci 0000:7f:10.7: [8086:3cb7] type 0 class 0x000880
[    1.617434] pci 0000:7f:11.0: [8086:3cb8] type 0 class 0x000880
[    1.617505] pci 0000:7f:13.0: [8086:3ce4] type 0 class 0x000880
[    1.617559] pci 0000:7f:13.1: [8086:3c43] type 0 class 0x001101
[    1.617616] pci 0000:7f:13.4: [8086:3ce6] type 0 class 0x001101
[    1.617670] pci 0000:7f:13.5: [8086:3c44] type 0 class 0x001101
[    1.617726] pci 0000:7f:13.6: [8086:3c45] type 0 class 0x000880
[    1.617800]  pci0000:7f: Requesting ACPI _OSC control (0x1d)
[    1.617806]  pci0000:7f: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    1.617809] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.619682] ACPI: PCI Root Bridge [UCR1] (domain 0000 [bus ff])
[    1.619760] PCI: root bus ff: using default resources
[    1.619813] PCI host bridge to bus 0000:ff
[    1.619817] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    1.619821] pci_bus 0000:ff: root bus resource [mem 0x00000000-0x3fffffffffff]
[    1.619839] pci 0000:ff:08.0: [8086:3c80] type 0 class 0x000880
[    1.619910] pci 0000:ff:08.3: [8086:3c83] type 0 class 0x000880
[    1.619992] pci 0000:ff:08.4: [8086:3c84] type 0 class 0x000880
[    1.620080] pci 0000:ff:09.0: [8086:3c90] type 0 class 0x000880
[    1.620148] pci 0000:ff:09.3: [8086:3c93] type 0 class 0x000880
[    1.620234] pci 0000:ff:09.4: [8086:3c94] type 0 class 0x000880
[    1.620322] pci 0000:ff:0a.0: [8086:3cc0] type 0 class 0x000880
[    1.620380] pci 0000:ff:0a.1: [8086:3cc1] type 0 class 0x000880
[    1.620439] pci 0000:ff:0a.2: [8086:3cc2] type 0 class 0x000880
[    1.620498] pci 0000:ff:0a.3: [8086:3cd0] type 0 class 0x000880
[    1.620560] pci 0000:ff:0b.0: [8086:3ce0] type 0 class 0x000880
[    1.620618] pci 0000:ff:0b.3: [8086:3ce3] type 0 class 0x000880
[    1.620678] pci 0000:ff:0c.0: [8086:3ce8] type 0 class 0x000880
[    1.620737] pci 0000:ff:0c.1: [8086:3ce8] type 0 class 0x000880
[    1.620796] pci 0000:ff:0c.2: [8086:3ce8] type 0 class 0x000880
[    1.620854] pci 0000:ff:0c.3: [8086:3ce8] type 0 class 0x000880
[    1.620914] pci 0000:ff:0c.6: [8086:3cf4] type 0 class 0x000880
[    1.620972] pci 0000:ff:0c.7: [8086:3cf6] type 0 class 0x000880
[    1.621030] pci 0000:ff:0d.0: [8086:3ce8] type 0 class 0x000880
[    1.621088] pci 0000:ff:0d.1: [8086:3ce8] type 0 class 0x000880
[    1.621147] pci 0000:ff:0d.2: [8086:3ce8] type 0 class 0x000880
[    1.621208] pci 0000:ff:0d.3: [8086:3ce8] type 0 class 0x000880
[    1.621267] pci 0000:ff:0d.6: [8086:3cf5] type 0 class 0x000880
[    1.621327] pci 0000:ff:0e.0: [8086:3ca0] type 0 class 0x000880
[    1.621393] pci 0000:ff:0e.1: [8086:3c46] type 0 class 0x001101
[    1.621470] pci 0000:ff:0f.0: [8086:3ca8] type 0 class 0x000880
[    1.621549] pci 0000:ff:0f.1: [8086:3c71] type 0 class 0x000880
[    1.621630] pci 0000:ff:0f.2: [8086:3caa] type 0 class 0x000880
[    1.621712] pci 0000:ff:0f.3: [8086:3cab] type 0 class 0x000880
[    1.621793] pci 0000:ff:0f.4: [8086:3cac] type 0 class 0x000880
[    1.621872] pci 0000:ff:0f.5: [8086:3cad] type 0 class 0x000880
[    1.621950] pci 0000:ff:0f.6: [8086:3cae] type 0 class 0x000880
[    1.622017] pci 0000:ff:10.0: [8086:3cb0] type 0 class 0x000880
[    1.622098] pci 0000:ff:10.1: [8086:3cb1] type 0 class 0x000880
[    1.622182] pci 0000:ff:10.2: [8086:3cb2] type 0 class 0x000880
[    1.622263] pci 0000:ff:10.3: [8086:3cb3] type 0 class 0x000880
[    1.622344] pci 0000:ff:10.4: [8086:3cb4] type 0 class 0x000880
[    1.622426] pci 0000:ff:10.5: [8086:3cb5] type 0 class 0x000880
[    1.622508] pci 0000:ff:10.6: [8086:3cb6] type 0 class 0x000880
[    1.622589] pci 0000:ff:10.7: [8086:3cb7] type 0 class 0x000880
[    1.622670] pci 0000:ff:11.0: [8086:3cb8] type 0 class 0x000880
[    1.622746] pci 0000:ff:13.0: [8086:3ce4] type 0 class 0x000880
[    1.622804] pci 0000:ff:13.1: [8086:3c43] type 0 class 0x001101
[    1.622866] pci 0000:ff:13.4: [8086:3ce6] type 0 class 0x001101
[    1.622925] pci 0000:ff:13.5: [8086:3c44] type 0 class 0x001101
[    1.622983] pci 0000:ff:13.6: [8086:3c45] type 0 class 0x000880
[    1.623061]  pci0000:ff: Requesting ACPI _OSC control (0x1d)
[    1.623066]  pci0000:ff: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    1.623069] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.624978] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    1.625100] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    1.625219] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 10 11 12 14 15)
[    1.625329] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
[    1.625438] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
[    1.625545] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12 14 15)
[    1.625653] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *10 11 12 14 15)
[    1.625764] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
[    1.625991] vgaarb: device added: PCI:0000:09:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.626085] vgaarb: loaded
[    1.626087] vgaarb: bridge control possible 0000:09:00.0
[    1.626496] SCSI subsystem initialized
[    1.626611] libata version 3.00 loaded.
[    1.626714] usbcore: registered new interface driver usbfs
[    1.626740] usbcore: registered new interface driver hub
[    1.626789] usbcore: registered new device driver usb
[    1.626927] PCI: Using ACPI for IRQ routing
[    1.633620] PCI: pci_cache_line_size set to 64 bytes
[    1.634197] reserve RAM buffer: 000000000009bc00 - 000000000009ffff 
[    1.634202] reserve RAM buffer: 00000000b9612000 - 00000000bbffffff 
[    1.634208] reserve RAM buffer: 00000000b9783000 - 00000000bbffffff 
[    1.634213] reserve RAM buffer: 00000000bac27000 - 00000000bbffffff 
[    1.634217] reserve RAM buffer: 00000000bda01000 - 00000000bfffffff 
[    1.634228] reserve RAM buffer: 00000000bdce0000 - 00000000bfffffff 
[    1.634238] reserve RAM buffer: 00000000be000000 - 00000000bfffffff 
[    1.634477] NetLabel: Initializing
[    1.634480] NetLabel:  domain hash size = 128
[    1.634483] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.634504] NetLabel:  unlabeled traffic allowed by default
[    1.634529] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.634540] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.636680] Switching to clocksource hpet
[    1.652622] pnp: PnP ACPI init
[    1.652647] ACPI: bus type pnp registered
[    1.653089] pnp 00:00: [bus 00-7e]
[    1.653094] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.653098] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.653102] pnp 00:00: [io  0x0000-0xbfff window]
[    1.653106] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.653111] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    1.653115] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    1.653119] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    1.653123] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    1.653126] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    1.653130] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    1.653134] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    1.653137] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    1.653141] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    1.653144] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    1.653148] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    1.653152] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    1.653155] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    1.653159] pnp 00:00: [mem 0xd0000000-0xebffffff window]
[    1.653163] pnp 00:00: [mem 0x3c0000000000-0x3c007fffffff window]
[    1.653167] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    1.653309] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.653343] pnp 00:01: [io  0x0000-0x001f]
[    1.653346] pnp 00:01: [io  0x0081-0x0091]
[    1.653349] pnp 00:01: [io  0x0093-0x009f]
[    1.653353] pnp 00:01: [io  0x00c0-0x00df]
[    1.653356] pnp 00:01: [dma 4]
[    1.653393] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.653411] pnp 00:02: [mem 0xff000000-0xffffffff]
[    1.653446] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    1.653628] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.653667] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.653689] pnp 00:04: [io  0x00f0]
[    1.653702] pnp 00:04: [irq 13]
[    1.653737] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.653793] pnp 00:05: [io  0x002e-0x002f]
[    1.653796] pnp 00:05: [io  0x004e-0x004f]
[    1.653799] pnp 00:05: [io  0x0061]
[    1.653802] pnp 00:05: [io  0x0063]
[    1.653806] pnp 00:05: [io  0x0065]
[    1.653809] pnp 00:05: [io  0x0067]
[    1.653812] pnp 00:05: [io  0x0070]
[    1.653815] pnp 00:05: [io  0x0080]
[    1.653818] pnp 00:05: [io  0x0092]
[    1.653821] pnp 00:05: [io  0x00b2-0x00b3]
[    1.653824] pnp 00:05: [io  0x0680-0x069f]
[    1.653827] pnp 00:05: [io  0xffff]
[    1.653830] pnp 00:05: [io  0xffff]
[    1.653833] pnp 00:05: [io  0xffff]
[    1.653836] pnp 00:05: [io  0x0400-0x0453]
[    1.653839] pnp 00:05: [io  0x0458-0x047f]
[    1.653842] pnp 00:05: [io  0x0500-0x057f]
[    1.653846] pnp 00:05: [io  0x0600-0x061f]
[    1.653850] pnp 00:05: [io  0x0ca2-0x0ca5]
[    1.653853] pnp 00:05: [io  0x0cf9]
[    1.654097] system 00:05: [io  0x0680-0x069f] has been reserved
[    1.654102] system 00:05: [io  0xffff] has been reserved
[    1.654106] system 00:05: [io  0xffff] has been reserved
[    1.654110] system 00:05: [io  0xffff] has been reserved
[    1.654115] system 00:05: [io  0x0400-0x0453] has been reserved
[    1.654119] system 00:05: [io  0x0458-0x047f] has been reserved
[    1.654123] system 00:05: [io  0x0500-0x057f] has been reserved
[    1.654128] system 00:05: [io  0x0600-0x061f] has been reserved
[    1.654132] system 00:05: [io  0x0ca2-0x0ca5] has been reserved
[    1.654137] system 00:05: [io  0x0cf9] could not be reserved
[    1.654142] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.654162] pnp 00:06: [io  0x0070-0x0077]
[    1.654171] pnp 00:06: [irq 8]
[    1.654209] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.654276] pnp 00:07: [io  0x0454-0x0457]
[    1.654478] system 00:07: [io  0x0454-0x0457] has been reserved
[    1.654483] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    1.655116] pnp 00:08: [io  0x03f8-0x03ff]
[    1.655126] pnp 00:08: [irq 4]
[    1.655129] pnp 00:08: [dma 0 disabled]
[    1.655252] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.655743] pnp 00:09: [io  0x02f8-0x02ff]
[    1.655752] pnp 00:09: [irq 3]
[    1.655755] pnp 00:09: [dma 0 disabled]
[    1.655873] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.656834] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    1.656839] pnp 00:0a: [mem 0xebfff000-0xebffffff]
[    1.656842] pnp 00:0a: [mem 0xc0000000-0xcfffffff]
[    1.656846] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
[    1.656850] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    1.656854] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    1.656859] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    1.656863] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    1.656867] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
[    1.656870] pnp 00:0a: [mem 0xff000000-0xffffffff]
[    1.656874] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
[    1.656877] pnp 00:0a: [mem 0xfec00000-0xfecfffff]
[    1.656880] pnp 00:0a: [mem 0xd0e70000-0xd0e70fff]
[    1.656884] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    1.657084] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.657090] system 00:0a: [mem 0xebfff000-0xebffffff] has been reserved
[    1.657095] system 00:0a: [mem 0xc0000000-0xcfffffff] has been reserved
[    1.657100] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.657104] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.657109] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
[    1.657114] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.657119] system 00:0a: [mem 0xfec00000-0xfecfffff] could not be reserved
[    1.657124] system 00:0a: [mem 0xd0e70000-0xd0e70fff] has been reserved
[    1.657129] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.657882] pnp 00:0b: [bus 80-fe]
[    1.657886] pnp 00:0b: [io  0xc000-0xffff window]
[    1.657899] pnp 00:0b: [mem 0xec000000-0xfbffffff window]
[    1.657904] pnp 00:0b: [mem 0x3c0080000000-0x3c00ffffffff window]
[    1.658031] pnp 00:0b: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.658170] pnp 00:0c: [mem 0x00000000-0x0009cfff]
[    1.658432] system 00:0c: [mem 0x00000000-0x0009cfff] could not be reserved
[    1.658438] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.659018] pnp 00:0d: [bus 7f]
[    1.659141] pnp 00:0d: Plug and Play ACPI device, IDs PNP0a03 (active)
[    1.659242] pnp 00:0e: [bus ff]
[    1.659359] pnp 00:0e: Plug and Play ACPI device, IDs PNP0a03 (active)
[    1.659510] pnp: PnP ACPI: found 15 devices
[    1.659513] ACPI: ACPI bus type pnp unregistered
[    1.667936] PCI: max bus depth: 1 pci_try_num: 2
[    1.668039] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.668054] pci 0000:00:02.0: PCI bridge to [bus 02-02]
[    1.668061] pci 0000:00:02.0:   bridge window [mem 0xd0b00000-0xd0cfffff]
[    1.668071] pci 0000:00:02.2: PCI bridge to [bus 03-03]
[    1.668085] pci 0000:00:03.0: PCI bridge to [bus 04-04]
[    1.668099] pci 0000:00:03.2: PCI bridge to [bus 05-05]
[    1.668113] pci 0000:00:11.0: PCI bridge to [bus 06-06]
[    1.668118] pci 0000:00:11.0:   bridge window [io  0x2000-0x2fff]
[    1.668126] pci 0000:00:11.0:   bridge window [mem 0xd0d00000-0xd0dfffff]
[    1.668133] pci 0000:00:11.0:   bridge window [mem 0xeb800000-0xebcfffff 64bit pref]
[    1.668144] pci 0000:00:1c.0: PCI bridge to [bus 07-08]
[    1.668149] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    1.668156] pci 0000:00:1c.0:   bridge window [mem 0xd0900000-0xd0afffff]
[    1.668168] pci 0000:00:1c.7: PCI bridge to [bus 09-09]
[    1.668175] pci 0000:00:1c.7:   bridge window [mem 0xd0000000-0xd08fffff]
[    1.668181] pci 0000:00:1c.7:   bridge window [mem 0xea000000-0xeaffffff 64bit pref]
[    1.668191] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a]
[    1.668209] pci 0000:80:02.0: PCI bridge to [bus 81-81]
[    1.668213] pci 0000:80:02.0:   bridge window [io  0xc000-0xcfff]
[    1.668220] pci 0000:80:02.0:   bridge window [mem 0xec000000-0xec5fffff]
[    1.668350] pci 0000:00:1e.0: setting latency timer to 64
[    1.668387] pci_bus 0000:00: resource 4 [io  0x0000-0xbfff]
[    1.668391] pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff]
[    1.668394] pci_bus 0000:00: resource 6 [mem 0x000c0000-0x000c3fff]
[    1.668398] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000c7fff]
[    1.668402] pci_bus 0000:00: resource 8 [mem 0x000d0000-0x000d3fff]
[    1.668405] pci_bus 0000:00: resource 9 [mem 0x000d4000-0x000d7fff]
[    1.668409] pci_bus 0000:00: resource 10 [mem 0x000d8000-0x000dbfff]
[    1.668413] pci_bus 0000:00: resource 11 [mem 0x000dc000-0x000dffff]
[    1.668416] pci_bus 0000:00: resource 12 [mem 0x000e0000-0x000e3fff]
[    1.668420] pci_bus 0000:00: resource 13 [mem 0x000e4000-0x000e7fff]
[    1.668423] pci_bus 0000:00: resource 14 [mem 0x000e8000-0x000ebfff]
[    1.668427] pci_bus 0000:00: resource 15 [mem 0x000ec000-0x000effff]
[    1.668430] pci_bus 0000:00: resource 16 [mem 0x000f0000-0x000fffff]
[    1.668434] pci_bus 0000:00: resource 17 [mem 0xd0000000-0xebffffff]
[    1.668438] pci_bus 0000:00: resource 18 [mem 0x3c0000000000-0x3c007fffffff]
[    1.668442] pci_bus 0000:02: resource 1 [mem 0xd0b00000-0xd0cfffff]
[    1.668447] pci_bus 0000:06: resource 0 [io  0x2000-0x2fff]
[    1.668450] pci_bus 0000:06: resource 1 [mem 0xd0d00000-0xd0dfffff]
[    1.668454] pci_bus 0000:06: resource 2 [mem 0xeb800000-0xebcfffff 64bit pref]
[    1.668458] pci_bus 0000:07: resource 0 [io  0x1000-0x1fff]
[    1.668461] pci_bus 0000:07: resource 1 [mem 0xd0900000-0xd0afffff]
[    1.668465] pci_bus 0000:09: resource 1 [mem 0xd0000000-0xd08fffff]
[    1.668469] pci_bus 0000:09: resource 2 [mem 0xea000000-0xeaffffff 64bit pref]
[    1.668473] pci_bus 0000:0a: resource 4 [io  0x0000-0xbfff]
[    1.668476] pci_bus 0000:0a: resource 5 [mem 0x000a0000-0x000bffff]
[    1.668480] pci_bus 0000:0a: resource 6 [mem 0x000c0000-0x000c3fff]
[    1.668483] pci_bus 0000:0a: resource 7 [mem 0x000c4000-0x000c7fff]
[    1.668487] pci_bus 0000:0a: resource 8 [mem 0x000d0000-0x000d3fff]
[    1.668490] pci_bus 0000:0a: resource 9 [mem 0x000d4000-0x000d7fff]
[    1.668494] pci_bus 0000:0a: resource 10 [mem 0x000d8000-0x000dbfff]
[    1.668498] pci_bus 0000:0a: resource 11 [mem 0x000dc000-0x000dffff]
[    1.668501] pci_bus 0000:0a: resource 12 [mem 0x000e0000-0x000e3fff]
[    1.668505] pci_bus 0000:0a: resource 13 [mem 0x000e4000-0x000e7fff]
[    1.668508] pci_bus 0000:0a: resource 14 [mem 0x000e8000-0x000ebfff]
[    1.668512] pci_bus 0000:0a: resource 15 [mem 0x000ec000-0x000effff]
[    1.668515] pci_bus 0000:0a: resource 16 [mem 0x000f0000-0x000fffff]
[    1.668519] pci_bus 0000:0a: resource 17 [mem 0xd0000000-0xebffffff]
[    1.668523] pci_bus 0000:0a: resource 18 [mem 0x3c0000000000-0x3c007fffffff]
[    1.668527] pci_bus 0000:80: resource 4 [io  0xc000-0xffff]
[    1.668530] pci_bus 0000:80: resource 5 [mem 0xec000000-0xfbffffff]
[    1.668534] pci_bus 0000:80: resource 6 [mem 0x3c0080000000-0x3c00ffffffff]
[    1.668538] pci_bus 0000:81: resource 0 [io  0xc000-0xcfff]
[    1.668541] pci_bus 0000:81: resource 1 [mem 0xec000000-0xec5fffff]
[    1.668546] pci_bus 0000:7f: resource 4 [io  0x0000-0xffff]
[    1.668549] pci_bus 0000:7f: resource 5 [mem 0x00000000-0x3fffffffffff]
[    1.668555] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[    1.668558] pci_bus 0000:ff: resource 5 [mem 0x00000000-0x3fffffffffff]
[    1.668928] NET: Registered protocol family 2
[    1.669860] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    1.672829] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.675228] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.675485] TCP: Hash tables configured (established 524288 bind 65536)
[    1.675489] TCP reno registered
[    1.675588] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    1.675853] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
[    1.676588] NET: Registered protocol family 1
[    1.718940] pci 0000:09:00.0: Boot video device
[    1.719188] PCI: CLS 64 bytes, default 64
[    1.719290] Trying to unpack rootfs image as initramfs...
[    2.167943] Freeing initrd memory: 12928k freed
[    2.172234] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.172240] Placing 64MB software IO TLB between ffff8800b5612000 - ffff8800b9612000
[    2.172244] software IO TLB at phys 0xb5612000 - 0xb9612000
[    2.179594] audit: initializing netlink socket (disabled)
[    2.179619] type=2000 audit(1333340577.423:1): initialized
[    2.215939] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.220459] VFS: Disk quotas dquot_6.5.2
[    2.220593] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.221034] msgmni has been set to 32768
[    2.221143] SELinux:  Registering netfilter hooks
[    2.222365] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.222407] io scheduler noop registered
[    2.222409] io scheduler deadline registered
[    2.222501] io scheduler cfq registered (default)
[    2.222922] pcieport 0000:00:01.0: irq 88 for MSI/MSI-X
[    2.223088] pcieport 0000:00:02.0: irq 89 for MSI/MSI-X
[    2.223252] pcieport 0000:00:02.2: irq 90 for MSI/MSI-X
[    2.223417] pcieport 0000:00:03.0: irq 91 for MSI/MSI-X
[    2.223574] pcieport 0000:00:03.2: irq 92 for MSI/MSI-X
[    2.223736] pcieport 0000:00:11.0: irq 93 for MSI/MSI-X
[    2.223913] pcieport 0000:00:1c.0: irq 94 for MSI/MSI-X
[    2.224086] pcieport 0000:00:1c.7: irq 95 for MSI/MSI-X
[    2.224282] pcieport 0000:80:02.0: irq 96 for MSI/MSI-X
[    2.224472] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    2.224480] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    2.224510] pcieport 0000:00:02.0: Signaling PME through PCIe PME interrupt
[    2.224514] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    2.224520] pcie_pme 0000:00:02.0:pcie01: service driver pcie_pme loaded
[    2.224553] pcieport 0000:00:02.2: Signaling PME through PCIe PME interrupt
[    2.224559] pcie_pme 0000:00:02.2:pcie01: service driver pcie_pme loaded
[    2.224588] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[    2.224594] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[    2.224624] pcieport 0000:00:03.2: Signaling PME through PCIe PME interrupt
[    2.224651] pcie_pme 0000:00:03.2:pcie01: service driver pcie_pme loaded
[    2.224691] pcieport 0000:00:11.0: Signaling PME through PCIe PME interrupt
[    2.224692] pci 0000:06:00.0: Signaling PME through PCIe PME interrupt
[    2.224694] pci 0000:06:00.3: Signaling PME through PCIe PME interrupt
[    2.224698] pcie_pme 0000:00:11.0:pcie01: service driver pcie_pme loaded
[    2.224715] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    2.224716] pci 0000:07:00.0: Signaling PME through PCIe PME interrupt
[    2.224718] pci 0000:07:00.1: Signaling PME through PCIe PME interrupt
[    2.224719] pci 0000:07:00.2: Signaling PME through PCIe PME interrupt
[    2.224737] pci 0000:07:00.3: Signaling PME through PCIe PME interrupt
[    2.224743] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    2.224773] pcieport 0000:00:1c.7: Signaling PME through PCIe PME interrupt
[    2.224776] pci 0000:09:00.0: Signaling PME through PCIe PME interrupt
[    2.224783] pcie_pme 0000:00:1c.7:pcie01: service driver pcie_pme loaded
[    2.224815] pcieport 0000:80:02.0: Signaling PME through PCIe PME interrupt
[    2.224819] pci 0000:81:00.0: Signaling PME through PCIe PME interrupt
[    2.224824] pcie_pme 0000:80:02.0:pcie01: service driver pcie_pme loaded
[    2.224904] ioapic: probe of 0000:00:05.4 failed with error -22
[    2.224963] ioapic: probe of 0000:80:05.4 failed with error -22
[    2.224995] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.225058] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.225062] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    2.227151] intel_idle: MWAIT substates: 0x21120
[    2.227154] intel_idle: v0.4 model 0x2D
[    2.227156] intel_idle: lapic_timer_reliable_states 0xffffffff
[    2.227446] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.227454] ACPI: Power Button [PWRF]
[    2.496700] ERST: Error Record Serialization Table (ERST) support is initialized.
[    2.497028] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
[    2.497031] XENFS: not registering filesystem on non-xen platform
[    2.497166] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.761624] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.026480] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.047657] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.068510] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.069357] Non-volatile memory driver v1.3
[    3.069360] Linux agpgart interface v0.103
[    3.073145] brd: module loaded
[    3.074852] loop: module loaded
[    3.075312] Fixed MDIO Bus: probed
[    3.075456] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.075626] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.075630] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    3.075718] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    3.075746] ehci_hcd 0000:00:1a.0: debug port 2
[    3.079638] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    3.079653] ehci_hcd 0000:00:1a.0: irq 22, io mem 0xd0e20000
[    3.085253] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    3.085302] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.085304] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.085306] usb usb1: Product: EHCI Host Controller
[    3.085307] usb usb1: Manufacturer: Linux 3.3.0-rc7 ehci_hcd
[    3.085309] usb usb1: SerialNumber: 0000:00:1a.0
[    3.085451] hub 1-0:1.0: USB hub found
[    3.085455] hub 1-0:1.0: 2 ports detected
[    3.085659] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.085676] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    3.085719] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    3.085741] ehci_hcd 0000:00:1d.0: debug port 2
[    3.089611] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    3.089625] ehci_hcd 0000:00:1d.0: irq 20, io mem 0xd0e10000
[    3.095243] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    3.095286] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.095288] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.095290] usb usb2: Product: EHCI Host Controller
[    3.095291] usb usb2: Manufacturer: Linux 3.3.0-rc7 ehci_hcd
[    3.095292] usb usb2: SerialNumber: 0000:00:1d.0
[    3.095427] hub 2-0:1.0: USB hub found
[    3.095429] hub 2-0:1.0: 2 ports detected
[    3.095565] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.095608] uhci_hcd: USB Universal Host Controller Interface driver
[    3.095808] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    3.174383] Refined TSC clocksource calibration: 2693.509 MHz.
[    3.174390] Switching to clocksource tsc
[    3.609219] i8042: Can't read CTR while initializing i8042
[    3.609329] i8042: probe of i8042 failed with error -5
[    3.609443] mousedev: PS/2 mouse device common for all mice
[    3.609758] rtc_cmos 00:06: RTC can wake from S4
[    3.609922] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    3.609962] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    3.611231] cpuidle: using governor ladder
[    3.612829] cpuidle: using governor menu
[    3.612833] EFI Variables Facility v0.08 2004-May-17
[    3.613232] usbcore: registered new interface driver usbhid
[    3.613235] usbhid: USB HID core driver
[    3.613238] AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>
[    3.613672] Netfilter messages via NETLINK v0.30.
[    3.613681] nfnl_acct: registering with nfnetlink.
[    3.613746] TCP cubic registered
[    3.613749] Initializing XFRM netlink socket
[    3.613760] NET: Registered protocol family 17
[    3.613788] Registering the dns_resolver key type
[    3.613817] openvswitch: Open vSwitch switching datapath
[    3.614237] PM: Hibernation image not present or could not be loaded.
[    3.614265] registered taskstats version 1
[    3.616152] IMA: No TPM chip found, activating TPM-bypass!
[    3.618117]   Magic number: 8:380:362
[    3.618170] msr msr1: hash matches
[    3.618178] machinecheck machinecheck18: hash matches
[    3.618495] rtc_cmos 00:06: setting system clock to 2012-04-02 04:22:59 UTC (1333340579)
[    3.618753] Initializing network drop monitor service
[    3.621763] Freeing unused kernel memory: 1096k freed
[    3.622197] Write protecting the kernel read-only data: 10240k
[    3.626588] Freeing unused kernel memory: 824k freed
[    3.635096] Freeing unused kernel memory: 1672k freed
[    3.656053] dracut: dracut-004-53.el6
[    3.666146] dracut: rd_NO_LUKS: removing cryptoluks activation
[    3.673120] udev: starting version 147
[    3.673412] udevd (230): /proc/230/oom_adj is deprecated, please use /proc/230/oom_score_adj instead.
[    3.773411] dracut: Starting plymouth daemon
[    3.810964] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    3.882534] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[    3.882660] isci 0000:06:00.0: driver configured for rev: 5 silicon
[    3.882672] isci 0000:06:00.0: OEM parameter table found in OROM
[    3.882677] isci 0000:06:00.0: OEM SAS parameters (version: 1.1) loaded (platform)
[    3.884250] isci 0000:06:00.0: SCU controller 0: phy 3-0 cables: {short, short, short, short}
[    3.886507] scsi0 : isci
[    3.887080] isci 0000:06:00.0: irq 97 for MSI/MSI-X
[    3.887088] isci 0000:06:00.0: irq 98 for MSI/MSI-X
[    3.907410] ahci 0000:00:1f.2: version 3.0
[    3.907532] ahci 0000:00:1f.2: irq 99 for MSI/MSI-X
[    3.907583] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3 impl SATA mode
[    3.907586] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
[    3.907590] ahci 0000:00:1f.2: setting latency timer to 64
[    3.911279] scsi1 : ahci
[    3.911410] scsi2 : ahci
[    3.911533] scsi3 : ahci
[    3.911634] scsi4 : ahci
[    3.911715] scsi5 : ahci
[    3.911821] scsi6 : ahci
[    3.911856] ata1: SATA max UDMA/133 abar m2048@0xd0e00000 port 0xd0e00100 irq 99
[    3.911863] ata2: SATA max UDMA/133 abar m2048@0xd0e00000 port 0xd0e00180 irq 99
[    3.911864] ata3: DUMMY
[    3.911865] ata4: DUMMY
[    3.911866] ata5: DUMMY
[    3.911867] ata6: DUMMY
[    3.925243] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    3.925248] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.925624] hub 1-1:1.0: USB hub found
[    3.925683] hub 1-1:1.0: 6 ports detected
[    4.027833] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    4.142336] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    4.142338] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.142711] hub 2-1:1.0: USB hub found
[    4.142853] hub 2-1:1.0: 8 ports detected
[    4.216800] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    4.216834] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    4.217394] ata2.00: ATA-9: C400-MTFDDAK256MAM, 0009, max UDMA/100
[    4.217397] ata2.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.217943] ata2.00: configured for UDMA/100
[    4.218995] ata1.00: ATA-8: WDC WD1002FAEX-00Y9A0, 05.01D05, max UDMA/133
[    4.218998] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.220824] ata1.00: configured for UDMA/133
[    4.220913] scsi: waiting for bus probes to complete ...
[    4.294133] scsi 1:0:0:0: Direct-Access     ATA      WDC WD1002FAEX-0 05.0 PQ: 0 ANSI: 5
[    4.294655] sd 1:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    4.294748] sd 1:0:0:0: [sda] Write Protect is off
[    4.294753] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.294796] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.294862] scsi 2:0:0:0: Direct-Access     ATA      C400-MTFDDAK256M 0009 PQ: 0 ANSI: 5
[    4.295164] sd 2:0:0:0: [sdb] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    4.295256] sd 2:0:0:0: [sdb] Write Protect is off
[    4.295260] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.295291] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.298197]  sdb: sdb1
[    4.298524] sd 2:0:0:0: [sdb] Attached SCSI disk
[    4.323982]  sda: sda1 sda2 sda3 sda4 < sda5 >
[    4.324720] sd 1:0:0:0: [sda] Attached SCSI disk
[    4.403621] mpt2sas version 12.100.00.00 loaded
[    4.404058] scsi7 : Fusion MPT SAS Host
[    4.404467] mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (32970856 kB)
[    4.404594] mpt2sas 0000:81:00.0: irq 100 for MSI/MSI-X
[    4.404619] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 100
[    4.404621] mpt2sas0: iomem(0x00000000ec4c0000), mapped(0xffffc90013f70000), size(16384)
[    4.404623] mpt2sas0: ioport(0x000000000000c000), size(256)
[    4.417716] usb 2-1.4: new full-speed USB device number 3 using ehci_hcd
[    4.504522] usb 2-1.4: New USB device found, idVendor=046b, idProduct=ff10
[    4.504525] usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.504527] usb 2-1.4: Product: Virtual Keyboard and Mouse
[    4.504529] usb 2-1.4: Manufacturer: American Megatrends Inc.
[    4.504530] usb 2-1.4: SerialNumber: serial
[    4.505929] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.0/input/input1
[    4.506109] generic-usb 0003:046B:FF10.0001: input,hidraw0: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.0-1.4/input0
[    4.507024] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.1/input/input2
[    4.507367] generic-usb 0003:046B:FF10.0002: input,hidraw1: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.0-1.4/input1
[    4.522609] mpt2sas0: Allocated physical memory: size(7235 kB)
[    4.522612] mpt2sas0: Current Controller Queue Depth(3211), Max Controller Queue Depth(3440)
[    4.522614] mpt2sas0: Scatter Gather Elements per IO(128)
[    4.581936] mpt2sas0: LSISAS2008: FWVersion(09.00.00.00), ChipRevision(0x03), BiosVersion(00.00.00.00)
[    4.581939] mpt2sas0: Intel 720 Series SSD
[    4.581941] mpt2sas0: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
[    4.582163] mpt2sas0: sending port enable !!
[    5.050684] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    5.102865] dracut: Mounted root filesystem /dev/sda2
[    5.181301] dracut: Loading SELinux policy
[    5.349089] SELinux:  Disabled at runtime.
[    5.349109] SELinux:  Unregistering netfilter hooks
[    5.401242] type=1404 audit(1333340581.282:2): selinux=0 auid=4294967295 ses=4294967295
[    5.429262] dracut: /sbin/load_policy: Can't load policy: No such file or directory
[    5.559555] dracut: Switching root
[    5.928612] readahead-collector: starting
[    6.152204] mpt2sas0: host_add: handle(0x0001), sas_addr(0x50015179595d991a), phys(8)
[    6.153452] scsi 7:0:0:0: Direct-Access     HITACHI  HUSSL4010ASS600  a172 PQ: 0 ANSI: 6
[    6.153471] scsi 7:0:0:0: SSP: handle(0x0009), sas_addr(0x5000cca0130362e5), phy(0), device_name(0xa0cc0050e7620313)
[    6.153474] scsi 7:0:0:0: SSP: enclosure_logical_id(0x50015179595d991a), slot(0)
[    6.153476] scsi 7:0:0:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
[    6.154871] scsi 7:0:1:0: Direct-Access     HITACHI  HUSSL4010ASS600  a172 PQ: 0 ANSI: 6
[    6.154878] scsi 7:0:1:0: SSP: handle(0x000a), sas_addr(0x5000cca0130362de), phy(5), device_name(0xa0cc0050df620313)
[    6.154893] scsi 7:0:1:0: SSP: enclosure_logical_id(0x50015179595d991a), slot(5)
[    6.154895] scsi 7:0:1:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
[    6.156297] scsi 7:0:2:0: Direct-Access     HITACHI  HUSSL4010ASS600  a172 PQ: 0 ANSI: 6
[    6.156314] scsi 7:0:2:0: SSP: handle(0x000b), sas_addr(0x5000cca0130362e1), phy(7), device_name(0xa0cc0050e3620313)
[    6.156317] scsi 7:0:2:0: SSP: enclosure_logical_id(0x50015179595d991a), slot(7)
[    6.156319] scsi 7:0:2:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
[    6.251369] udev: starting version 147
[    6.320045] WARNING! power/level is deprecated; use power/control instead
[    6.383836] dca service started, version 1.12.1
[    6.401572] scsi 7:0:3:0: Direct-Access     HITACHI  HUSSL4010ASS600  a172 PQ: 0 ANSI: 6
[    6.401580] scsi 7:0:3:0: SSP: handle(0x000c), sas_addr(0x5000cca0130362d9), phy(3), device_name(0xa0cc0050db620313)
[    6.401583] scsi 7:0:3:0: SSP: enclosure_logical_id(0x50015179595d991a), slot(3)
[    6.401586] scsi 7:0:3:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
[    6.469379] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    6.470083] ioatdma 0000:00:04.0: irq 101 for MSI/MSI-X
[    6.470964] ioatdma 0000:00:04.1: irq 102 for MSI/MSI-X
[    6.471926] ioatdma 0000:00:04.2: irq 103 for MSI/MSI-X
[    6.472817] ioatdma 0000:00:04.3: irq 104 for MSI/MSI-X
[    6.473255] ioatdma 0000:00:04.4: irq 105 for MSI/MSI-X
[    6.473629] ioatdma 0000:00:04.5: irq 106 for MSI/MSI-X
[    6.474637] ioatdma 0000:00:04.6: irq 107 for MSI/MSI-X
[    6.475456] ioatdma 0000:00:04.7: irq 108 for MSI/MSI-X
[    6.476183] ioatdma 0000:80:04.0: irq 109 for MSI/MSI-X
[    6.477182] ioatdma 0000:80:04.1: irq 110 for MSI/MSI-X
[    6.478679] ioatdma 0000:80:04.2: irq 111 for MSI/MSI-X
[    6.479586] ioatdma 0000:80:04.3: irq 112 for MSI/MSI-X
[    6.480210] ioatdma 0000:80:04.4: irq 113 for MSI/MSI-X
[    6.481971] ioatdma 0000:80:04.5: irq 114 for MSI/MSI-X
[    6.483749] ioatdma 0000:80:04.6: irq 115 for MSI/MSI-X
[    6.485553] ioatdma 0000:80:04.7: irq 116 for MSI/MSI-X
[   11.272541] mpt2sas0: port enable: SUCCESS
[   11.273358] sd 7:0:0:0: [sdc] 195371568 512-byte logical blocks: (100 GB/93.1 GiB)
[   11.273621] sd 7:0:1:0: [sdd] 195371568 512-byte logical blocks: (100 GB/93.1 GiB)
[   11.274017] sd 7:0:2:0: [sde] 195371568 512-byte logical blocks: (100 GB/93.1 GiB)
[   11.274070] sd 7:0:0:0: [sdc] Write Protect is off
[   11.274073] sd 7:0:0:0: [sdc] Mode Sense: f7 00 10 08
[   11.274177] sd 7:0:3:0: [sdf] 195371568 512-byte logical blocks: (100 GB/93.1 GiB)
[   11.274298] sd 7:0:1:0: [sdd] Write Protect is off
[   11.274300] sd 7:0:1:0: [sdd] Mode Sense: f7 00 10 08
[   11.274533] sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   11.274826] sd 7:0:1:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   11.274880] sd 7:0:2:0: [sde] Write Protect is off
[   11.274883] sd 7:0:2:0: [sde] Mode Sense: f7 00 10 08
[   11.275269] sd 7:0:3:0: [sdf] Write Protect is off
[   11.275272] sd 7:0:3:0: [sdf] Mode Sense: f7 00 10 08
[   11.275434] sd 7:0:2:0: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   11.275724] sd 7:0:3:0: [sdf] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   11.276811]  sdc: unknown partition table
[   11.276943]  sdd: unknown partition table
[   11.277554]  sde: unknown partition table
[   11.278253]  sdf: unknown partition table
[   11.278539] sd 7:0:0:0: [sdc] Attached SCSI disk
[   11.278544] sd 7:0:1:0: [sdd] Attached SCSI disk
[   11.279384] sd 7:0:2:0: [sde] Attached SCSI disk
[   11.280494] sd 7:0:3:0: [sdf] Attached SCSI disk
[   13.411468] ACPI Warning: 0x0000000000003000-0x000000000000301f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120111/utaddress-251)
[   13.411475] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   13.498111] igb: Intel(R) Gigabit Ethernet Network Driver - version 3.2.10-k
[   13.498113] igb: Copyright (c) 2007-2012 Intel Corporation.
[   13.498740] igb 0000:07:00.0: irq 117 for MSI/MSI-X
[   13.498750] igb 0000:07:00.0: irq 118 for MSI/MSI-X
[   13.498758] igb 0000:07:00.0: irq 119 for MSI/MSI-X
[   13.498766] igb 0000:07:00.0: irq 120 for MSI/MSI-X
[   13.498774] igb 0000:07:00.0: irq 121 for MSI/MSI-X
[   13.498783] igb 0000:07:00.0: irq 122 for MSI/MSI-X
[   13.498791] igb 0000:07:00.0: irq 123 for MSI/MSI-X
[   13.498799] igb 0000:07:00.0: irq 124 for MSI/MSI-X
[   13.498807] igb 0000:07:00.0: irq 125 for MSI/MSI-X
[   13.567953] igb 0000:07:00.0: DCA enabled
[   13.568040] igb 0000:07:00.0: Intel(R) Gigabit Ethernet Network Connection
[   13.568043] igb 0000:07:00.0: eth0: (PCIe:5.0Gb/s:Width x4) 00:1e:67:23:cc:d9
[   13.568116] igb 0000:07:00.0: eth0: PBA No: 006600-000
[   13.568118] igb 0000:07:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   13.568729] igb 0000:07:00.1: irq 126 for MSI/MSI-X
[   13.568738] igb 0000:07:00.1: irq 127 for MSI/MSI-X
[   13.568752] igb 0000:07:00.1: irq 128 for MSI/MSI-X
[   13.568760] igb 0000:07:00.1: irq 129 for MSI/MSI-X
[   13.568768] igb 0000:07:00.1: irq 130 for MSI/MSI-X
[   13.568777] igb 0000:07:00.1: irq 131 for MSI/MSI-X
[   13.568785] igb 0000:07:00.1: irq 132 for MSI/MSI-X
[   13.568793] igb 0000:07:00.1: irq 133 for MSI/MSI-X
[   13.568801] igb 0000:07:00.1: irq 134 for MSI/MSI-X
[   13.619872] igb 0000:07:00.1: DCA enabled
[   13.619959] igb 0000:07:00.1: Intel(R) Gigabit Ethernet Network Connection
[   13.619961] igb 0000:07:00.1: eth1: (PCIe:5.0Gb/s:Width x4) 00:1e:67:23:cc:da
[   13.620035] igb 0000:07:00.1: eth1: PBA No: 006600-000
[   13.620036] igb 0000:07:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   13.620628] igb 0000:07:00.2: irq 135 for MSI/MSI-X
[   13.620636] igb 0000:07:00.2: irq 136 for MSI/MSI-X
[   13.620644] igb 0000:07:00.2: irq 137 for MSI/MSI-X
[   13.620652] igb 0000:07:00.2: irq 138 for MSI/MSI-X
[   13.620660] igb 0000:07:00.2: irq 139 for MSI/MSI-X
[   13.620668] igb 0000:07:00.2: irq 140 for MSI/MSI-X
[   13.620676] igb 0000:07:00.2: irq 141 for MSI/MSI-X
[   13.620685] igb 0000:07:00.2: irq 142 for MSI/MSI-X
[   13.620699] igb 0000:07:00.2: irq 143 for MSI/MSI-X
[   13.673772] igb 0000:07:00.2: DCA enabled
[   13.673860] igb 0000:07:00.2: Intel(R) Gigabit Ethernet Network Connection
[   13.673862] igb 0000:07:00.2: eth2: (PCIe:5.0Gb/s:Width x4) 00:1e:67:23:cc:db
[   13.673935] igb 0000:07:00.2: eth2: PBA No: 006600-000
[   13.673937] igb 0000:07:00.2: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   13.674571] igb 0000:07:00.3: irq 144 for MSI/MSI-X
[   13.674581] igb 0000:07:00.3: irq 145 for MSI/MSI-X
[   13.674589] igb 0000:07:00.3: irq 146 for MSI/MSI-X
[   13.674597] igb 0000:07:00.3: irq 147 for MSI/MSI-X
[   13.674605] igb 0000:07:00.3: irq 148 for MSI/MSI-X
[   13.674613] igb 0000:07:00.3: irq 149 for MSI/MSI-X
[   13.674621] igb 0000:07:00.3: irq 150 for MSI/MSI-X
[   13.674630] igb 0000:07:00.3: irq 151 for MSI/MSI-X
[   13.674638] igb 0000:07:00.3: irq 152 for MSI/MSI-X
[   13.727723] igb 0000:07:00.3: DCA enabled
[   13.727810] igb 0000:07:00.3: Intel(R) Gigabit Ethernet Network Connection
[   13.727812] igb 0000:07:00.3: eth3: (PCIe:5.0Gb/s:Width x4) 00:1e:67:23:cc:dc
[   13.727886] igb 0000:07:00.3: eth3: PBA No: 006600-000
[   13.727887] igb 0000:07:00.3: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   13.813714] iTCO_vendor_support: vendor-support=0
[   13.825749] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[   13.825884] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[   13.851420] sd 1:0:0:0: Attached scsi generic sg0 type 0
[   13.851595] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   13.851770] sd 7:0:0:0: Attached scsi generic sg2 type 0
[   13.851908] sd 7:0:1:0: Attached scsi generic sg3 type 0
[   13.852060] sd 7:0:2:0: Attached scsi generic sg4 type 0
[   13.852180] sd 7:0:3:0: Attached scsi generic sg5 type 0
[   14.219805] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   14.241562] wmi: Mapper loaded
[   14.292098] microcode: CPU0 sig=0x206d5, pf=0x1, revision=0x50b
[   14.376989] microcode: CPU1 sig=0x206d5, pf=0x1, revision=0x50b
[   14.383998] microcode: CPU2 sig=0x206d5, pf=0x1, revision=0x50b
[   14.391586] microcode: CPU3 sig=0x206d5, pf=0x1, revision=0x50b
[   14.398642] microcode: CPU4 sig=0x206d5, pf=0x1, revision=0x50b
[   14.405636] microcode: CPU5 sig=0x206d5, pf=0x1, revision=0x50b
[   14.411935] microcode: CPU6 sig=0x206d5, pf=0x1, revision=0x50b
[   14.418622] microcode: CPU7 sig=0x206d5, pf=0x1, revision=0x50b
[   14.424922] microcode: CPU8 sig=0x206d5, pf=0x1, revision=0x50b
[   14.431258] microcode: CPU9 sig=0x206d5, pf=0x1, revision=0x50b
[   14.438087] microcode: CPU10 sig=0x206d5, pf=0x1, revision=0x50b
[   14.444391] microcode: CPU11 sig=0x206d5, pf=0x1, revision=0x50b
[   14.450818] microcode: CPU12 sig=0x206d5, pf=0x1, revision=0x50b
[   14.457392] microcode: CPU13 sig=0x206d5, pf=0x1, revision=0x50b
[   14.464175] microcode: CPU14 sig=0x206d5, pf=0x1, revision=0x50b
[   14.470488] microcode: CPU15 sig=0x206d5, pf=0x1, revision=0x50b
[   14.477224] microcode: CPU16 sig=0x206d5, pf=0x1, revision=0x50b
[   14.483119] microcode: CPU17 sig=0x206d5, pf=0x1, revision=0x50b
[   14.489253] microcode: CPU18 sig=0x206d5, pf=0x1, revision=0x50b
[   14.495963] microcode: CPU19 sig=0x206d5, pf=0x1, revision=0x50b
[   14.501996] microcode: CPU20 sig=0x206d5, pf=0x1, revision=0x50b
[   14.508112] microcode: CPU21 sig=0x206d5, pf=0x1, revision=0x50b
[   14.514477] microcode: CPU22 sig=0x206d5, pf=0x1, revision=0x50b
[   14.520831] microcode: CPU23 sig=0x206d5, pf=0x1, revision=0x50b
[   14.527491] microcode: CPU24 sig=0x206d5, pf=0x1, revision=0x50b
[   14.533523] microcode: CPU25 sig=0x206d5, pf=0x1, revision=0x50b
[   14.539966] microcode: CPU26 sig=0x206d5, pf=0x1, revision=0x50b
[   14.546621] microcode: CPU27 sig=0x206d5, pf=0x1, revision=0x50b
[   14.553232] microcode: CPU28 sig=0x206d5, pf=0x1, revision=0x50b
[   14.559499] microcode: CPU29 sig=0x206d5, pf=0x1, revision=0x50b
[   14.565905] microcode: CPU30 sig=0x206d5, pf=0x1, revision=0x50b
[   14.573066] microcode: CPU31 sig=0x206d5, pf=0x1, revision=0x50b
[   14.580457] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   14.932070] device-mapper: uevent: version 1.0.3
[   14.932249] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[   15.408786] EXT4-fs (sda2): re-mounted. Opts: (null)
[   15.616662] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   15.697475] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[   15.704347] ata2.00: exception Emask 0x50 SAct 0x1 SErr 0x280900 action 0x6 frozen
[   15.704349] ata2.00: irq_stat 0x08000000, interface fatal error
[   15.704352] ata2: SError: { UnrecovData HostInt 10B8B BadCRC }
[   15.704355] ata2.00: failed command: READ FPDMA QUEUED
[   15.704359] ata2.00: cmd 60/08:00:c2:03:00/00:00:00:00:00/40 tag 0 ncq 4096 in
[   15.704359]          res 40/00:04:c2:03:00/00:00:00:00:00/40 Emask 0x50 (ATA bus error)
[   15.704361] ata2.00: status: { DRDY }
[   15.704365] ata2: hard resetting link
[   16.722151] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   16.723135] ata2.00: configured for UDMA/100
[   16.723150] ata2: EH complete
[   16.741251] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
[   16.944429] Adding 2097148k swap on /dev/sda3.  Priority:-1 extents:1 across:2097148k 
[   21.408399] igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   22.832670] ipmi message handler version 39.2
[   22.856677] IPMI System Interface driver.
[   22.856756] ipmi_si: probing via SMBIOS
[   22.856760] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[   22.856764] ipmi_si: Adding SMBIOS-specified kcs state machine
[   22.856769] ipmi_si: probing via SPMI
[   22.856772] ipmi_si: SPMI: io 0xca2 regsize 1 spacing 1 irq 0
[   22.856775] ipmi_si: Adding SPMI-specified kcs state machine duplicate interface
[   22.856781] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
[   22.940264] ipmi_si ipmi_si.0: Found new BMC (man_id: 0x000157, prod_id: 0x004a, dev_id: 0x21)
[   22.940279] ipmi_si ipmi_si.0: IPMI kcs interface initialized
[   22.952545] ipmi device interface
[   33.691583] type=1305 audit(1333311809.584:44739): auid=4294967295 ses=4294967295 op="remove rule" key=(null) list=4 res=1
[   33.691592] type=1305 audit(1333311809.584:44740): audit_enabled=0 old=1 auid=4294967295 ses=4294967295 res=1
[   34.142224] readahead-collector: sorting
[   34.218734] readahead-collector: finished

--CE+1k2dSO48ffgeK--
