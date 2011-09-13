From: Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH] isci: Make warning messages unique
Date: Tue, 13 Sep 2011 13:54:41 -0600
Message-ID: <4E6FB501.9020608@canonical.com>
References: <4E6E6F94.4050502@canonical.com> <CABE8wwvkCG7coTpXWOYAo7xymRnKHQgr=TNVEUCgaC_YnjTpSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080401070708000908060508"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CABE8wwvkCG7coTpXWOYAo7xymRnKHQgr=TNVEUCgaC_YnjTpSw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: edmund.nadolski@intel.com, dave.jiang@intel.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080401070708000908060508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 09/13/2011 01:38 PM, Williams, Dan J wrote:
> On Mon, Sep 12, 2011 at 1:46 PM, Tim Gardner<tim.gardner@canonical.com>  wrote:
>> Hi,
>>
>> I've got a 2-way Sandybridge server with an 'Intel(R) C600 SAS Controller'.
>> The driver makes a boatload of dmesg noise with non-unique messages
>> distinguished only by the event code. For example, I've got 296 of these in
>> dmesg:
>>
>> (NULL device *): sci_phy_event_handler:735: PHY starting substate machine
>> received unexpected event_code b3402000
>>
>> In an effort to discover which of the 9 places from which this message was
>> emitted I added a line number.
>>
>> The next step is to decide if all of these really need to be dev_warn().
>
> Can you describe your storage layout?  I'd like to move these to
> dev_dbg() but I want to verify that the reports are benign.
>

Its a couple of 500GB Western Digital SATA drives (I think) in SAS bays. 
Not sure what the boot drive is. See attached dmesg.

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------080401070708000908060508
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-1-generic (root@sb) (gcc version 4.6.1 (Ubuntu/Linaro 4.6.1-7ubuntu2) ) #1 SMP Mon Sep 12 19:43:37 UTC 2011 (Ubuntu 3.1.0-1.1-generic 3.1.0-rc5)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.1.0-1-generic root=UUID=f3b004db-d6ba-46ca-8df6-47fb90219128 ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f400 (usable)
[    0.000000]  BIOS-e820: 000000000008f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000a9841000 (usable)
[    0.000000]  BIOS-e820: 00000000a9841000 - 00000000a9a42000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000a9a42000 - 00000000aa963000 (usable)
[    0.000000]  BIOS-e820: 00000000aa963000 - 00000000ba9e4000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000ba9e4000 - 00000000bad03000 (usable)
[    0.000000]  BIOS-e820: 00000000bad03000 - 00000000bad11000 (reserved)
[    0.000000]  BIOS-e820: 00000000bad11000 - 00000000bad1f000 (usable)
[    0.000000]  BIOS-e820: 00000000bad1f000 - 00000000bad21000 (reserved)
[    0.000000]  BIOS-e820: 00000000bad21000 - 00000000bb678000 (usable)
[    0.000000]  BIOS-e820: 00000000bb678000 - 00000000bb689000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb689000 - 00000000bb6cf000 (usable)
[    0.000000]  BIOS-e820: 00000000bb6cf000 - 00000000bb6d2000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb6d2000 - 00000000bb6fc000 (usable)
[    0.000000]  BIOS-e820: 00000000bb6fc000 - 00000000bb6fe000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb6fe000 - 00000000bb736000 (usable)
[    0.000000]  BIOS-e820: 00000000bb736000 - 00000000bb73a000 (reserved)
[    0.000000]  BIOS-e820: 00000000bb73a000 - 00000000bda06000 (usable)
[    0.000000]  BIOS-e820: 00000000bda06000 - 00000000bdc06000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdc06000 - 00000000bdce3000 (usable)
[    0.000000]  BIOS-e820: 00000000bdce3000 - 00000000bdde7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bdde7000 - 00000000bde0f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bde0f000 - 00000000bde8a000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bde8a000 - 00000000bdf06000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdf06000 - 00000000bdf07000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bdf07000 - 00000000bdf80000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdf80000 - 00000000bdf83000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bdf83000 - 00000000bdf84000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdf84000 - 00000000bdf9f000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bdf9f000 - 00000000bdfa7000 (ACPI NVS)
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
[    0.000000] DMI: Intel Corporation S2600CP/S2600CP, BIOS SE5C600.86B.99.99.x032.072520111118 07/25/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x840000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-through
[    0.000000]   D4000-D7FFF write-protect
[    0.000000]   D8000-E7FFF uncachable
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
[    0.000000] found SMP MP-table at [ffff8800000fccd0] fccd0
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000008a000] 8a000 size 20480
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000be000000
[    0.000000]  0000000000 - 0080000000 page 1G
[    0.000000]  0080000000 - 00be000000 page 2M
[    0.000000] kernel direct mapping tables up to be000000 @ bdffe000-be000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000840000000
[    0.000000]  0100000000 - 0840000000 page 1G
[    0.000000] kernel direct mapping tables up to 840000000 @ 83ffff000-840000000
[    0.000000] RAMDISK: 363a6000 - 371cb000
[    0.000000] ACPI: RSDP 00000000000f0410 00024 (v02 INTEL )
[    0.000000] ACPI: XSDT 00000000bdf9cd98 000BC (v01 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: FACP 00000000bdf9c798 000F4 (v04 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: DSDT 00000000bdf84018 16820 (v02 INTEL   S2600CP 00000099 INTL 20100331)
[    0.000000] ACPI: FACS 00000000bdf9cf40 00040
[    0.000000] ACPI: APIC 00000000bdf9b718 0066A (v03 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: SPMI 00000000bdf9eb18 00040 (v05 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: MCFG 00000000bdf9ea98 0003C (v01 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: WDDT 00000000bdf9ef18 00040 (v01 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: SRAT 00000000bdf82c18 002A8 (v03 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: SLIT 00000000bdf9ee98 00030 (v01 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: MSCT 00000000bdf81f18 00090 (v01 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: HPET 00000000bdf9ee18 00038 (v01 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: SSDT 00000000bdf9ed18 0002B (v02 INTEL   S2600CP 00001000 INTL 20100331)
[    0.000000] ACPI: SSDT 00000000bde0f018 7A0C4 (v02 INTEL   S2600CP 00004000 INTL 20100331)
[    0.000000] ACPI: HEST 00000000bdf9de18 000A8 (v01 INTEL   S2600CP 00000001 INTL 00000001)
[    0.000000] ACPI: BERT 00000000bdf9ed98 00030 (v01 INTEL   S2600CP 00000001 INTL 00000001)
[    0.000000] ACPI: ERST 00000000bdf06c98 00230 (v01 INTEL   S2600CP 00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 00000000bdf9c618 00130 (v01 INTEL   S2600CP 00000001 INTL 00000001)
[    0.000000] ACPI: BDAT 00000000bdf9ec98 00030 (v01 INTEL   S2600CP 06222004 INTL 20090903)
[    0.000000] ACPI: SSDT 00000000bdf80018 00EBD (v02 INTEL   S2600CP 00000002 INTL 20100331)
[    0.000000] ACPI: SSDT 00000000bdf9ec18 00045 (v02 INTEL   S2600CP 00000001 INTL 20100331)
[    0.000000] ACPI: SSDT 00000000bdf9cc18 00155 (v02 INTEL   S2600CP 00000003 INTL 20100331)
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
[    0.000000]   NODE_DATA [000000043fffb000 - 000000043fffffff]
[    0.000000] Initmem setup node 1 0000000440000000-0000000840000000
[    0.000000]   NODE_DATA [000000083fffa000 - 000000083fffefff]
[    0.000000]  [ffffea0000000000-ffffea0010ffffff] PMD -> [ffff880430000000-ffff88043fdfffff] on node 0
[    0.000000]  [ffffea0011000000-ffffea0020ffffff] PMD -> [ffff88082f600000-ffff88083f5fffff] on node 1
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00840000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[14] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000008f
[    0.000000]     0: 0x00000100 -> 0x000a9841
[    0.000000]     0: 0x000a9a42 -> 0x000aa963
[    0.000000]     0: 0x000ba9e4 -> 0x000bad03
[    0.000000]     0: 0x000bad11 -> 0x000bad1f
[    0.000000]     0: 0x000bad21 -> 0x000bb678
[    0.000000]     0: 0x000bb689 -> 0x000bb6cf
[    0.000000]     0: 0x000bb6d2 -> 0x000bb6fc
[    0.000000]     0: 0x000bb6fe -> 0x000bb736
[    0.000000]     0: 0x000bb73a -> 0x000bda06
[    0.000000]     0: 0x000bdc06 -> 0x000bdce3
[    0.000000]     0: 0x000bdfa7 -> 0x000be000
[    0.000000]     0: 0x00100000 -> 0x00440000
[    0.000000]     1: 0x00440000 -> 0x00840000
[    0.000000] On node 0 totalpages: 4118543
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3898 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 690384 pages, LIFO batch:31
[    0.000000]   Normal zone: 53248 pages used for memmap
[    0.000000]   Normal zone: 3354624 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 4194304
[    0.000000]   Normal zone: 65536 pages used for memmap
[    0.000000]   Normal zone: 4128768 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: X2APIC (apic_id[0x00] uid[0x00] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x01] uid[0x01] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x02] uid[0x02] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x03] uid[0x03] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x04] uid[0x04] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x05] uid[0x05] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x06] uid[0x06] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x07] uid[0x07] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x08] uid[0x08] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x09] uid[0x09] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x0a] uid[0x0a] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x0b] uid[0x0b] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x0c] uid[0x0c] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x0d] uid[0x0d] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x0e] uid[0x0e] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x0f] uid[0x0f] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x10] uid[0x10] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x11] uid[0x11] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x12] uid[0x12] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x13] uid[0x13] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x14] uid[0x14] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x15] uid[0x15] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x16] uid[0x16] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x17] uid[0x17] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x18] uid[0x18] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x19] uid[0x19] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x1a] uid[0x1a] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x1b] uid[0x1b] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x1c] uid[0x1c] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x1d] uid[0x1d] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x1e] uid[0x1e] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x1f] uid[0x1f] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x20] uid[0x20] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x21] uid[0x21] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x22] uid[0x22] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x23] uid[0x23] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x24] uid[0x24] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x25] uid[0x25] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x26] uid[0x26] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x27] uid[0x27] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x28] uid[0x28] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x29] uid[0x29] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x2a] uid[0x2a] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x2b] uid[0x2b] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x2c] uid[0x2c] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x2d] uid[0x2d] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x2e] uid[0x2e] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x2f] uid[0x2f] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x30] uid[0x30] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x31] uid[0x31] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x32] uid[0x32] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x33] uid[0x33] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x34] uid[0x34] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x35] uid[0x35] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x36] uid[0x36] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x37] uid[0x37] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x38] uid[0x38] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x39] uid[0x39] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x3a] uid[0x3a] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x3b] uid[0x3b] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x3c] uid[0x3c] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x3d] uid[0x3d] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x3e] uid[0x3e] disabled)
[    0.000000] ACPI: X2APIC (apic_id[0x3f] uid[0x3f] disabled)
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
[    0.000000] SMP: Allowing 128 CPUs, 96 hotplug CPUs
[    0.000000] nr_irqs_gsi: 88
[    0.000000] PM: Registered nosave memory: 000000000008f000 - 0000000000090000
[    0.000000] PM: Registered nosave memory: 0000000000090000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000a9841000 - 00000000a9a42000
[    0.000000] PM: Registered nosave memory: 00000000aa963000 - 00000000ba9e4000
[    0.000000] PM: Registered nosave memory: 00000000bad03000 - 00000000bad11000
[    0.000000] PM: Registered nosave memory: 00000000bad1f000 - 00000000bad21000
[    0.000000] PM: Registered nosave memory: 00000000bb678000 - 00000000bb689000
[    0.000000] PM: Registered nosave memory: 00000000bb6cf000 - 00000000bb6d2000
[    0.000000] PM: Registered nosave memory: 00000000bb6fc000 - 00000000bb6fe000
[    0.000000] PM: Registered nosave memory: 00000000bb736000 - 00000000bb73a000
[    0.000000] PM: Registered nosave memory: 00000000bda06000 - 00000000bdc06000
[    0.000000] PM: Registered nosave memory: 00000000bdce3000 - 00000000bdde7000
[    0.000000] PM: Registered nosave memory: 00000000bdde7000 - 00000000bde0f000
[    0.000000] PM: Registered nosave memory: 00000000bde0f000 - 00000000bde8a000
[    0.000000] PM: Registered nosave memory: 00000000bde8a000 - 00000000bdf06000
[    0.000000] PM: Registered nosave memory: 00000000bdf06000 - 00000000bdf07000
[    0.000000] PM: Registered nosave memory: 00000000bdf07000 - 00000000bdf80000
[    0.000000] PM: Registered nosave memory: 00000000bdf80000 - 00000000bdf83000
[    0.000000] PM: Registered nosave memory: 00000000bdf83000 - 00000000bdf84000
[    0.000000] PM: Registered nosave memory: 00000000bdf84000 - 00000000bdf9f000
[    0.000000] PM: Registered nosave memory: 00000000bdf9f000 - 00000000bdfa7000
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
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:128 nr_node_ids:2
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88042f800000 s81280 r8192 d21120 u131072
[    0.000000] pcpu-alloc: s81280 r8192 d21120 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 000 001 002 003 004 005 006 007 016 017 018 019 020 021 022 023 
[    0.000000] pcpu-alloc: [0] 032 034 036 038 040 042 044 046 048 050 052 054 056 058 060 062 
[    0.000000] pcpu-alloc: [0] 064 066 068 070 072 074 076 078 080 082 084 086 088 090 092 094 
[    0.000000] pcpu-alloc: [0] 096 098 100 102 104 106 108 110 112 114 116 118 120 122 124 126 
[    0.000000] pcpu-alloc: [1] 008 009 010 011 012 013 014 015 024 025 026 027 028 029 030 031 
[    0.000000] pcpu-alloc: [1] 033 035 037 039 041 043 045 047 049 051 053 055 057 059 061 063 
[    0.000000] pcpu-alloc: [1] 065 067 069 071 073 075 077 079 081 083 085 087 089 091 093 095 
[    0.000000] pcpu-alloc: [1] 097 099 101 103 105 107 109 111 113 115 117 119 121 123 125 127 
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 8177674
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.1.0-1-generic root=UUID=f3b004db-d6ba-46ca-8df6-47fb90219128 ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 32618992k/34603008k available (6240k kernel code, 1351620k absent, 632396k reserved, 6836k data, 984k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=128, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:16640 nr_irqs:2520 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 267386880 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.010000] Detected 2294.485 MHz processor.
[    0.000060] Calibrating delay loop (skipped), value calculated using timer frequency.. 4588.97 BogoMIPS (lpj=22944850)
[    0.000263] pid_max: default: 131072 minimum: 1024
[    0.000624] Security Framework initialized
[    0.000742] AppArmor: AppArmor initialized
[    0.000839] Yama: becoming mindful.
[    0.006407] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.020060] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.026968] Mount-cache hash table entries: 256
[    0.027655] Initializing cgroup subsys cpuacct
[    0.027776] Initializing cgroup subsys memory
[    0.027957] Initializing cgroup subsys devices
[    0.028055] Initializing cgroup subsys freezer
[    0.028154] Initializing cgroup subsys net_cls
[    0.028252] Initializing cgroup subsys blkio
[    0.028364] Initializing cgroup subsys perf_event
[    0.028607] CPU: Physical Processor ID: 0
[    0.028704] CPU: Processor Core ID: 0
[    0.028807] mce: CPU supports 20 MCE banks
[    0.028961] CPU0: Thermal monitoring enabled (TM1)
[    0.029102] using mwait in idle threads.
[    0.033935] ACPI: Core revision 20110623
[    0.096969] ftrace: allocating 25921 entries in 102 pages
[    0.116412] Not enabling x2apic, Intr-remapping init failed.
[    0.116517] Switched APIC routing to physical flat.
[    0.117181] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.217231] CPU0: Genuine Intel(R) CPU  @ 2.30GHz stepping 02
[    0.336885] Performance Events: PEBS fmt1+, SandyBridge events, Intel PMU driver.
[    0.337191] ... version:                3
[    0.337287] ... bit width:              48
[    0.337383] ... generic registers:      4
[    0.337479] ... value mask:             0000ffffffffffff
[    0.337580] ... max period:             000000007fffffff
[    0.337680] ... fixed-purpose events:   3
[    0.337776] ... event mask:             000000070000000f
[    0.339209] Booting Node   0, Processors  #1
[    0.339338] smpboot cpu 1: start_ip = 8a000
[    0.527156]  #2
[    0.527223] smpboot cpu 2: start_ip = 8a000
[    0.707014]  #3
[    0.707081] smpboot cpu 3: start_ip = 8a000
[    0.886877]  #4
[    0.886943] smpboot cpu 4: start_ip = 8a000
[    1.066770]  #5
[    1.066836] smpboot cpu 5: start_ip = 8a000
[    1.246626]  #6
[    1.246692] smpboot cpu 6: start_ip = 8a000
[    1.426491]  #7
[    1.426558] smpboot cpu 7: start_ip = 8a000
[    1.606384]  Ok.
[    1.606476] Booting Node   1, Processors  #8
[    1.606604] smpboot cpu 8: start_ip = 8a000
[    1.786267]  #9
[    1.786331] smpboot cpu 9: start_ip = 8a000
[    1.966145]  #10
[    1.966209] smpboot cpu 10: start_ip = 8a000
[    2.145996]  #11
[    2.146060] smpboot cpu 11: start_ip = 8a000
[    2.325857]  #12
[    2.325920] smpboot cpu 12: start_ip = 8a000
[    2.505831]  #13
[    2.505894] smpboot cpu 13: start_ip = 8a000
[    2.685702]  #14
[    2.685765] smpboot cpu 14: start_ip = 8a000
[    2.865569]  #15
[    2.865633] smpboot cpu 15: start_ip = 8a000
[    3.045400]  Ok.
[    3.045489] Booting Node   0, Processors  #16
[    3.045616] smpboot cpu 16: start_ip = 8a000
[    3.225324]  #17
[    3.225391] smpboot cpu 17: start_ip = 8a000
[    3.405190]  #18
[    3.405256] smpboot cpu 18: start_ip = 8a000
[    3.585137]  #19
[    3.585203] smpboot cpu 19: start_ip = 8a000
[    3.764937]  #20
[    3.765003] smpboot cpu 20: start_ip = 8a000
[    3.944880]  #21
[    3.944947] smpboot cpu 21: start_ip = 8a000
[    4.124781]  #22
[    4.124847] smpboot cpu 22: start_ip = 8a000
[    4.304632]  #23
[    4.304698] smpboot cpu 23: start_ip = 8a000
[    4.484481]  Ok.
[    4.484575] Booting Node   1, Processors  #24
[    4.484702] smpboot cpu 24: start_ip = 8a000
[    4.664333]  #25
[    4.664396] smpboot cpu 25: start_ip = 8a000
[    4.844248]  #26
[    4.844312] smpboot cpu 26: start_ip = 8a000
[    5.024126]  #27
[    5.024190] smpboot cpu 27: start_ip = 8a000
[    5.203946]  #28
[    5.204010] smpboot cpu 28: start_ip = 8a000
[    5.383886]  #29
[    5.383950] smpboot cpu 29: start_ip = 8a000
[    5.563767]  #30
[    5.563831] smpboot cpu 30: start_ip = 8a000
[    5.743588]  #31
[    5.743652] smpboot cpu 31: start_ip = 8a000
[    5.923416] Brought up 32 CPUs
[    5.923516] Total of 32 processors activated (146856.94 BogoMIPS).
[    5.999247] devtmpfs: initialized
[    5.999665] PM: Registering ACPI NVS region at a9841000 (2101248 bytes)
[    5.999851] PM: Registering ACPI NVS region at aa963000 (268963840 bytes)
[    6.007952] PM: Registering ACPI NVS region at bda06000 (2097152 bytes)
[    6.008138] PM: Registering ACPI NVS region at bdde7000 (163840 bytes)
[    6.008251] PM: Registering ACPI NVS region at bde8a000 (507904 bytes)
[    6.008374] PM: Registering ACPI NVS region at bdf07000 (495616 bytes)
[    6.008498] PM: Registering ACPI NVS region at bdf83000 (4096 bytes)
[    6.008602] PM: Registering ACPI NVS region at bdf9f000 (32768 bytes)
[    6.011305] print_constraints: dummy: 
[    6.011447] RTC time: 19:48:00, date: 09/13/11
[    6.011714] NET: Registered protocol family 16
[    6.012026] Trying to unpack rootfs image as initramfs...
[    6.012049] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    6.012053] ACPI: bus type pci registered
[    6.012224] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    6.012229] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
[    6.234634] PCI: Using configuration type 1 for base access
[    6.236518] bio: create slab <bio-0> at 0
[    6.236994] ACPI: Added _OSI(Module Device)
[    6.237092] ACPI: Added _OSI(Processor Device)
[    6.237190] ACPI: Added _OSI(3.0 _SCP Extensions)
[    6.237290] ACPI: Added _OSI(Processor Aggregator Device)
[    6.251430] ACPI: EC: Look up EC in DSDT
[    6.266189] ACPI: Executed 1 blocks of module-level executable AML code
[    6.491945] Freeing initrd memory: 14484k freed
[    6.571277] ACPI: Interpreter enabled
[    6.571378] ACPI: (supports S0 S1 S5)
[    6.571672] ACPI: Using IOAPIC for interrupt routing
[    6.598204] ACPI: No dock devices found.
[    6.598365] HEST: Table parsing has been initialized.
[    6.598468] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    6.599244] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7e])
[    6.599859] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    6.599966] pci_root PNP0A08:00: host bridge window [io  0x0000-0xbfff]
[    6.600072] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    6.600206] pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000c3fff]
[    6.600341] pci_root PNP0A08:00: host bridge window [mem 0x000c4000-0x000c7fff]
[    6.600475] pci_root PNP0A08:00: host bridge window [mem 0x000c8000-0x000cbfff]
[    6.600610] pci_root PNP0A08:00: host bridge window [mem 0x000cc000-0x000cffff]
[    6.600744] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
[    6.600878] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    6.601012] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    6.601146] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
[    6.601280] pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x000e3fff]
[    6.601415] pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x000e7fff]
[    6.601549] pci_root PNP0A08:00: host bridge window [mem 0x000e8000-0x000ebfff]
[    6.601683] pci_root PNP0A08:00: host bridge window [mem 0x000ec000-0x000effff]
[    6.601817] pci_root PNP0A08:00: host bridge window [mem 0x000f0000-0x000fffff]
[    6.601952] pci_root PNP0A08:00: host bridge window [mem 0xd0000000-0xebffffff]
[    6.602086] pci_root PNP0A08:00: host bridge window [mem 0x3c0000000000-0x3c007fffffff]
[    6.602226] pci_root PNP0A08:00: host bridge window expanded to [io  0x0000-0xbfff]; [io  0x0000-0xbfff] ignored
[    6.602382] pci_root PNP0A08:00: ignoring host bridge window [mem 0x000d0000-0x000d3fff] (conflicts with Adapter ROM [mem 0x000c8000-0x000d15ff])
[    6.602536] pci_root PNP0A08:00: ignoring host bridge window [mem 0x000d4000-0x000d7fff] (conflicts with Adapter ROM [mem 0x000d3800-0x000d47ff])
[    6.602709] pci 0000:00:00.0: [8086:3c00] type 0 class 0x000600
[    6.602789] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    6.602795] pci 0000:00:00.0: PME# disabled
[    6.602838] pci 0000:00:01.0: [8086:3c02] type 1 class 0x000604
[    6.602910] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    6.602916] pci 0000:00:01.0: PME# disabled
[    6.602954] pci 0000:00:01.1: [8086:3c03] type 1 class 0x000604
[    6.603026] pci 0000:00:01.1: PME# supported from D0 D3hot D3cold
[    6.603032] pci 0000:00:01.1: PME# disabled
[    6.603076] pci 0000:00:02.0: [8086:3c04] type 1 class 0x000604
[    6.603148] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    6.603153] pci 0000:00:02.0: PME# disabled
[    6.603190] pci 0000:00:02.2: [8086:3c06] type 1 class 0x000604
[    6.603263] pci 0000:00:02.2: PME# supported from D0 D3hot D3cold
[    6.603269] pci 0000:00:02.2: PME# disabled
[    6.603311] pci 0000:00:03.0: [8086:3c08] type 1 class 0x000604
[    6.603382] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    6.603388] pci 0000:00:03.0: PME# disabled
[    6.603425] pci 0000:00:03.2: [8086:3c0a] type 1 class 0x000604
[    6.603496] pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
[    6.603501] pci 0000:00:03.2: PME# disabled
[    6.603546] pci 0000:00:04.0: [8086:3c20] type 0 class 0x000880
[    6.603566] pci 0000:00:04.0: reg 10: [mem 0xebf90000-0xebf93fff 64bit]
[    6.603664] pci 0000:00:04.1: [8086:3c21] type 0 class 0x000880
[    6.603684] pci 0000:00:04.1: reg 10: [mem 0xebf80000-0xebf83fff 64bit]
[    6.603780] pci 0000:00:04.2: [8086:3c22] type 0 class 0x000880
[    6.603800] pci 0000:00:04.2: reg 10: [mem 0xebf70000-0xebf73fff 64bit]
[    6.603897] pci 0000:00:04.3: [8086:3c23] type 0 class 0x000880
[    6.603916] pci 0000:00:04.3: reg 10: [mem 0xebf60000-0xebf63fff 64bit]
[    6.604013] pci 0000:00:04.4: [8086:3c24] type 0 class 0x000880
[    6.604033] pci 0000:00:04.4: reg 10: [mem 0xebf50000-0xebf53fff 64bit]
[    6.604129] pci 0000:00:04.5: [8086:3c25] type 0 class 0x000880
[    6.604149] pci 0000:00:04.5: reg 10: [mem 0xebf40000-0xebf43fff 64bit]
[    6.604247] pci 0000:00:04.6: [8086:3c26] type 0 class 0x000880
[    6.604267] pci 0000:00:04.6: reg 10: [mem 0xebf30000-0xebf33fff 64bit]
[    6.604364] pci 0000:00:04.7: [8086:3c27] type 0 class 0x000880
[    6.604384] pci 0000:00:04.7: reg 10: [mem 0xebf20000-0xebf23fff 64bit]
[    6.604481] pci 0000:00:05.0: [8086:3c28] type 0 class 0x000880
[    6.604581] pci 0000:00:05.2: [8086:3c2a] type 0 class 0x000880
[    6.604678] pci 0000:00:05.4: [8086:3c2c] type 0 class 0x000800
[    6.604696] pci 0000:00:05.4: reg 10: [mem 0xd1e60000-0xd1e60fff]
[    6.604784] pci 0000:00:05.6: [8086:3c40] type 0 class 0x001101
[    6.604882] pci 0000:00:06.0: [8086:3c60] type 0 class 0x000880
[    6.604979] pci 0000:00:06.1: [8086:3c61] type 0 class 0x000600
[    6.605051] pci 0000:00:06.2: [8086:3c62] type 0 class 0x000600
[    6.605123] pci 0000:00:06.3: [8086:3c63] type 0 class 0x000600
[    6.605198] pci 0000:00:06.4: [8086:3c64] type 0 class 0x000600
[    6.605272] pci 0000:00:06.5: [8086:3c65] type 0 class 0x000600
[    6.605344] pci 0000:00:06.6: [8086:3c66] type 0 class 0x000600
[    6.605416] pci 0000:00:06.7: [8086:3c67] type 0 class 0x000600
[    6.605488] pci 0000:00:07.0: [8086:3c68] type 0 class 0x000600
[    6.605561] pci 0000:00:07.1: [8086:3c69] type 0 class 0x000600
[    6.605633] pci 0000:00:07.2: [8086:3c6a] type 0 class 0x000600
[    6.605705] pci 0000:00:07.3: [8086:3c6b] type 0 class 0x000600
[    6.605779] pci 0000:00:07.4: [8086:3c6c] type 0 class 0x000600
[    6.605880] pci 0000:00:16.0: [8086:1d3a] type 0 class 0x000780
[    6.605908] pci 0000:00:16.0: reg 10: [mem 0xd1e50000-0xd1e5000f 64bit]
[    6.605979] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    6.605984] pci 0000:00:16.0: PME# disabled
[    6.606009] pci 0000:00:16.1: [8086:1d3b] type 0 class 0x000780
[    6.606037] pci 0000:00:16.1: reg 10: [mem 0xd1e40000-0xd1e4000f 64bit]
[    6.606108] pci 0000:00:16.1: PME# supported from D0 D3hot D3cold
[    6.606113] pci 0000:00:16.1: PME# disabled
[    6.606159] pci 0000:00:1a.0: [8086:1d2d] type 0 class 0x000c03
[    6.606187] pci 0000:00:1a.0: reg 10: [mem 0xd1e20000-0xd1e203ff]
[    6.606281] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    6.606287] pci 0000:00:1a.0: PME# disabled
[    6.606318] pci 0000:00:1c.0: [8086:1d10] type 1 class 0x000604
[    6.606400] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    6.606406] pci 0000:00:1c.0: PME# disabled
[    6.606448] pci 0000:00:1c.7: [8086:1d1e] type 1 class 0x000604
[    6.606530] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    6.606536] pci 0000:00:1c.7: PME# disabled
[    6.606572] pci 0000:00:1d.0: [8086:1d26] type 0 class 0x000c03
[    6.606600] pci 0000:00:1d.0: reg 10: [mem 0xd1e10000-0xd1e103ff]
[    6.606695] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    6.606701] pci 0000:00:1d.0: PME# disabled
[    6.606727] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    6.606806] pci 0000:00:1f.0: [8086:1d40] type 0 class 0x000601
[    6.606951] pci 0000:00:1f.2: [8086:1d02] type 0 class 0x000106
[    6.606978] pci 0000:00:1f.2: reg 10: [io  0x3070-0x3077]
[    6.606989] pci 0000:00:1f.2: reg 14: [io  0x3060-0x3063]
[    6.607001] pci 0000:00:1f.2: reg 18: [io  0x3050-0x3057]
[    6.607012] pci 0000:00:1f.2: reg 1c: [io  0x3040-0x3043]
[    6.607024] pci 0000:00:1f.2: reg 20: [io  0x3020-0x303f]
[    6.607036] pci 0000:00:1f.2: reg 24: [mem 0xd1e00000-0xd1e007ff]
[    6.607083] pci 0000:00:1f.2: PME# supported from D3hot
[    6.607088] pci 0000:00:1f.2: PME# disabled
[    6.607112] pci 0000:00:1f.3: [8086:1d22] type 0 class 0x000c05
[    6.607134] pci 0000:00:1f.3: reg 10: [mem 0xebf10000-0xebf100ff 64bit]
[    6.607163] pci 0000:00:1f.3: reg 20: [io  0x3000-0x301f]
[    6.607265] pci 0000:01:00.0: [8086:1d74] type 1 class 0x000604
[    6.607279] pci 0000:01:00.0: reg 10: [mem 0xd1d00000-0xd1d03fff]
[    6.607327] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    6.607332] pci 0000:01:00.0: PME# disabled
[    6.607355] pci 0000:00:01.0: PCI bridge to [bus 01-03]
[    6.607459] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    6.607465] pci 0000:00:01.0:   bridge window [mem 0xd1c00000-0xd1dfffff]
[    6.607474] pci 0000:00:01.0:   bridge window [mem 0xeb000000-0xeb9fffff 64bit pref]
[    6.607534] pci 0000:02:08.0: [8086:1d3f] type 1 class 0x000604
[    6.607599] pci 0000:02:08.0: PME# supported from D0 D3hot D3cold
[    6.607605] pci 0000:02:08.0: PME# disabled
[    6.607647] pci 0000:01:00.0: PCI bridge to [bus 02-03]
[    6.607750] pci 0000:01:00.0:   bridge window [io  0x2000-0x2fff]
[    6.607755] pci 0000:01:00.0:   bridge window [mem 0xd1c00000-0xd1cfffff]
[    6.607763] pci 0000:01:00.0:   bridge window [mem 0xeb000000-0xeb9fffff 64bit pref]
[    6.607826] pci 0000:03:00.0: [8086:1d60] type 0 class 0x000107
[    6.607845] pci 0000:03:00.0: reg 10: [mem 0xeb800000-0xeb807fff 64bit pref]
[    6.607862] pci 0000:03:00.0: reg 18: [mem 0xeb000000-0xeb7fffff 64bit pref]
[    6.607873] pci 0000:03:00.0: reg 20: [io  0x2000-0x21ff]
[    6.607948] pci 0000:03:00.0: reg 164: [mem 0xeb810000-0xeb817fff 64bit pref]
[    6.607992] pci 0000:03:00.3: [8086:1d70] type 0 class 0x000c05
[    6.608007] pci 0000:03:00.3: reg 10: [mem 0xd1c10000-0xd1c10fff]
[    6.608044] pci 0000:03:00.3: reg 20: [io  0x2220-0x223f]
[    6.608088] pci 0000:03:00.3: PME# supported from D0 D3hot D3cold
[    6.608094] pci 0000:03:00.3: PME# disabled
[    6.608121] pci 0000:03:00.4: [8086:1d71] type 0 class 0x000c05
[    6.608136] pci 0000:03:00.4: reg 10: [mem 0xd1c00000-0xd1c00fff]
[    6.608173] pci 0000:03:00.4: reg 20: [io  0x2200-0x221f]
[    6.608217] pci 0000:03:00.4: PME# supported from D0 D3hot D3cold
[    6.608223] pci 0000:03:00.4: PME# disabled
[    6.608249] pci 0000:02:08.0: PCI bridge to [bus 03-03]
[    6.608352] pci 0000:02:08.0:   bridge window [io  0x2000-0x2fff]
[    6.608358] pci 0000:02:08.0:   bridge window [mem 0xd1c00000-0xd1cfffff]
[    6.608366] pci 0000:02:08.0:   bridge window [mem 0xeb000000-0xeb9fffff 64bit pref]
[    6.608436] pci 0000:00:01.1: PCI bridge to [bus 04-04]
[    6.608599] pci 0000:00:02.0: PCI bridge to [bus 05-05]
[    6.608762] pci 0000:00:02.2: PCI bridge to [bus 06-06]
[    6.608924] pci 0000:00:03.0: PCI bridge to [bus 07-07]
[    6.609087] pci 0000:00:03.2: PCI bridge to [bus 08-08]
[    6.609286] pci 0000:09:00.0: [8086:150e] type 0 class 0x000200
[    6.609310] pci 0000:09:00.0: reg 10: [mem 0xd1a80000-0xd1afffff]
[    6.609341] pci 0000:09:00.0: reg 18: [io  0x1060-0x107f]
[    6.609359] pci 0000:09:00.0: reg 1c: [mem 0xd1b30000-0xd1b33fff]
[    6.609455] pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
[    6.609462] pci 0000:09:00.0: PME# disabled
[    6.609528] pci 0000:09:00.1: [8086:150e] type 0 class 0x000200
[    6.609552] pci 0000:09:00.1: reg 10: [mem 0xd1a00000-0xd1a7ffff]
[    6.609583] pci 0000:09:00.1: reg 18: [io  0x1040-0x105f]
[    6.609601] pci 0000:09:00.1: reg 1c: [mem 0xd1b20000-0xd1b23fff]
[    6.609697] pci 0000:09:00.1: PME# supported from D0 D3hot D3cold
[    6.609704] pci 0000:09:00.1: PME# disabled
[    6.609762] pci 0000:09:00.2: [8086:150e] type 0 class 0x000200
[    6.609785] pci 0000:09:00.2: reg 10: [mem 0xd1980000-0xd19fffff]
[    6.609817] pci 0000:09:00.2: reg 18: [io  0x1020-0x103f]
[    6.609835] pci 0000:09:00.2: reg 1c: [mem 0xd1b10000-0xd1b13fff]
[    6.609931] pci 0000:09:00.2: PME# supported from D0 D3hot D3cold
[    6.609938] pci 0000:09:00.2: PME# disabled
[    6.609996] pci 0000:09:00.3: [8086:150e] type 0 class 0x000200
[    6.610019] pci 0000:09:00.3: reg 10: [mem 0xd1900000-0xd197ffff]
[    6.610051] pci 0000:09:00.3: reg 18: [io  0x1000-0x101f]
[    6.610068] pci 0000:09:00.3: reg 1c: [mem 0xd1b00000-0xd1b03fff]
[    6.610164] pci 0000:09:00.3: PME# supported from D0 D3hot D3cold
[    6.610171] pci 0000:09:00.3: PME# disabled
[    6.610229] pci 0000:00:1c.0: PCI bridge to [bus 09-09]
[    6.610333] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    6.610339] pci 0000:00:1c.0:   bridge window [mem 0xd1900000-0xd1bfffff]
[    6.610430] pci 0000:0a:00.0: [102b:0522] type 0 class 0x000300
[    6.610459] pci 0000:0a:00.0: reg 10: [mem 0xd0000000-0xd0ffffff]
[    6.610480] pci 0000:0a:00.0: reg 14: [mem 0xd1810000-0xd1813fff]
[    6.610501] pci 0000:0a:00.0: reg 18: [mem 0xd1000000-0xd17fffff]
[    6.610574] pci 0000:0a:00.0: reg 30: [mem 0xd1800000-0xd180ffff pref]
[    6.610661] pci 0000:00:1c.7: PCI bridge to [bus 0a-0a]
[    6.610767] pci 0000:00:1c.7:   bridge window [mem 0xd0000000-0xd18fffff]
[    6.610857] pci 0000:00:1e.0: PCI bridge to [bus 0b-0b] (subtractive decode)
[    6.610974] pci 0000:00:1e.0:   bridge window [io  0x0000-0xbfff] (subtractive decode)
[    6.610978] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    6.610983] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000c3fff] (subtractive decode)
[    6.610987] pci 0000:00:1e.0:   bridge window [mem 0x000c4000-0x000c7fff] (subtractive decode)
[    6.610991] pci 0000:00:1e.0:   bridge window [mem 0x000c8000-0x000cbfff] (subtractive decode)
[    6.610995] pci 0000:00:1e.0:   bridge window [mem 0x000cc000-0x000cffff] (subtractive decode)
[    6.610999] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    6.611003] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    6.611007] pci 0000:00:1e.0:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
[    6.611011] pci 0000:00:1e.0:   bridge window [mem 0x000e4000-0x000e7fff] (subtractive decode)
[    6.611015] pci 0000:00:1e.0:   bridge window [mem 0x000e8000-0x000ebfff] (subtractive decode)
[    6.611020] pci 0000:00:1e.0:   bridge window [mem 0x000ec000-0x000effff] (subtractive decode)
[    6.611024] pci 0000:00:1e.0:   bridge window [mem 0x000f0000-0x000fffff] (subtractive decode)
[    6.611028] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xebffffff] (subtractive decode)
[    6.611033] pci 0000:00:1e.0:   bridge window [mem 0x3c0000000000-0x3c007fffffff] (subtractive decode)
[    6.611087] pci 0000:00:01.0: Dev MPS 256 MPSS 256 MRRS 128
[    6.611197] pci 0000:00:01.0: Dev MPS 256 MPSS 256 MRRS 128
[    6.611301] pci 0000:01:00.0: Dev MPS 256 MPSS 256 MRRS 256
[    6.611407] pci 0000:01:00.0: Dev MPS 256 MPSS 256 MRRS 256
[    6.611511] pci 0000:02:08.0: Dev MPS 256 MPSS 256 MRRS 256
[    6.611617] pci 0000:02:08.0: Dev MPS 256 MPSS 256 MRRS 256
[    6.611721] pci 0000:03:00.0: Dev MPS 256 MPSS 1024 MRRS 1024
[    6.611835] pci 0000:03:00.0: Dev MPS 256 MPSS 256 MRRS 128
[    6.611939] pci 0000:03:00.3: Dev MPS 256 MPSS 256 MRRS 128
[    6.612049] pci 0000:03:00.3: Dev MPS 256 MPSS 256 MRRS 128
[    6.612153] pci 0000:03:00.4: Dev MPS 256 MPSS 256 MRRS 128
[    6.612263] pci 0000:03:00.4: Dev MPS 256 MPSS 256 MRRS 128
[    6.612367] pci 0000:00:01.1: Dev MPS 128 MPSS 256 MRRS 128
[    6.612478] pci 0000:00:01.1: Dev MPS 256 MPSS 256 MRRS 128
[    6.612582] pci 0000:00:02.0: Dev MPS 128 MPSS 256 MRRS 128
[    6.612693] pci 0000:00:02.0: Dev MPS 256 MPSS 256 MRRS 128
[    6.612803] pci 0000:00:02.2: Dev MPS 128 MPSS 256 MRRS 128
[    6.612914] pci 0000:00:02.2: Dev MPS 256 MPSS 256 MRRS 128
[    6.613019] pci 0000:00:03.0: Dev MPS 128 MPSS 256 MRRS 128
[    6.613130] pci 0000:00:03.0: Dev MPS 256 MPSS 256 MRRS 128
[    6.613234] pci 0000:00:03.2: Dev MPS 128 MPSS 256 MRRS 128
[    6.613344] pci 0000:00:03.2: Dev MPS 256 MPSS 256 MRRS 128
[    6.613449] pci 0000:00:1c.0: Dev MPS 128 MPSS 128 MRRS 128
[    6.613556] pci 0000:00:1c.0: Dev MPS 128 MPSS 128 MRRS 128
[    6.613662] pci 0000:09:00.0: Dev MPS 128 MPSS 512 MRRS 128
[    6.613771] pci 0000:09:00.0: Dev MPS 128 MPSS 128 MRRS 128
[    6.613877] pci 0000:09:00.1: Dev MPS 128 MPSS 512 MRRS 128
[    6.613986] pci 0000:09:00.1: Dev MPS 128 MPSS 128 MRRS 128
[    6.614092] pci 0000:09:00.2: Dev MPS 128 MPSS 512 MRRS 128
[    6.614201] pci 0000:09:00.2: Dev MPS 128 MPSS 128 MRRS 128
[    6.615707] pci 0000:09:00.3: Dev MPS 128 MPSS 512 MRRS 128
[    6.615816] pci 0000:09:00.3: Dev MPS 128 MPSS 128 MRRS 128
[    6.615921] pci 0000:00:1c.7: Dev MPS 128 MPSS 128 MRRS 128
[    6.616028] pci 0000:00:1c.7: Dev MPS 128 MPSS 128 MRRS 128
[    6.616134] pci 0000:0a:00.0: Dev MPS 128 MPSS 256 MRRS 128
[    6.616245] pci 0000:0a:00.0: Dev MPS 128 MPSS 128 MRRS 128
[    6.616347] pci_bus 0000:00: on NUMA node 0 (pxm 0)
[    6.616353] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    6.616650] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    6.616736] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP08._PRT]
[    6.616790] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    6.616837] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10.EPCU._PRT]
[    6.616887] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10.EPCU.EVSP._PRT]
[    6.616981] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    6.617075] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    6.617173] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
[    6.617275] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR18._PRT]
[    6.617374] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR16._PRT]
[    6.617722]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    6.618387]  pci0000:00: ACPI _OSC control (0x15) granted
[    6.640865] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-fe])
[    6.641442] pci_root PNP0A08:01: host bridge window [io  0xc000-0xffff]
[    6.641550] pci_root PNP0A08:01: host bridge window [mem 0xec000000-0xfbffffff]
[    6.641684] pci_root PNP0A08:01: host bridge window [mem 0x3c0080000000-0x3c00ffffffff]
[    6.641845] pci 0000:80:02.0: [8086:3c04] type 1 class 0x000604
[    6.641924] pci 0000:80:02.0: PME# supported from D0 D3hot D3cold
[    6.641930] pci 0000:80:02.0: PME# disabled
[    6.641976] pci 0000:80:04.0: [8086:3c20] type 0 class 0x000880
[    6.641998] pci 0000:80:04.0: reg 10: [mem 0xfbf70000-0xfbf73fff 64bit]
[    6.642101] pci 0000:80:04.1: [8086:3c21] type 0 class 0x000880
[    6.642122] pci 0000:80:04.1: reg 10: [mem 0xfbf60000-0xfbf63fff 64bit]
[    6.642229] pci 0000:80:04.2: [8086:3c22] type 0 class 0x000880
[    6.642249] pci 0000:80:04.2: reg 10: [mem 0xfbf50000-0xfbf53fff 64bit]
[    6.642352] pci 0000:80:04.3: [8086:3c23] type 0 class 0x000880
[    6.642373] pci 0000:80:04.3: reg 10: [mem 0xfbf40000-0xfbf43fff 64bit]
[    6.642476] pci 0000:80:04.4: [8086:3c24] type 0 class 0x000880
[    6.642497] pci 0000:80:04.4: reg 10: [mem 0xfbf30000-0xfbf33fff 64bit]
[    6.642599] pci 0000:80:04.5: [8086:3c25] type 0 class 0x000880
[    6.642620] pci 0000:80:04.5: reg 10: [mem 0xfbf20000-0xfbf23fff 64bit]
[    6.642734] pci 0000:80:04.6: [8086:3c26] type 0 class 0x000880
[    6.642755] pci 0000:80:04.6: reg 10: [mem 0xfbf10000-0xfbf13fff 64bit]
[    6.642857] pci 0000:80:04.7: [8086:3c27] type 0 class 0x000880
[    6.642878] pci 0000:80:04.7: reg 10: [mem 0xfbf00000-0xfbf03fff 64bit]
[    6.642980] pci 0000:80:05.0: [8086:3c28] type 0 class 0x000880
[    6.643084] pci 0000:80:05.2: [8086:3c2a] type 0 class 0x000880
[    6.643190] pci 0000:80:05.4: [8086:3c2c] type 0 class 0x000800
[    6.643209] pci 0000:80:05.4: reg 10: [mem 0xec000000-0xec000fff]
[    6.643302] pci 0000:80:05.6: [8086:3c40] type 0 class 0x001101
[    6.643405] pci 0000:80:06.0: [8086:3c60] type 0 class 0x000880
[    6.643508] pci 0000:80:06.1: [8086:3c61] type 0 class 0x000600
[    6.643584] pci 0000:80:06.2: [8086:3c62] type 0 class 0x000600
[    6.643660] pci 0000:80:06.3: [8086:3c63] type 0 class 0x000600
[    6.643736] pci 0000:80:06.4: [8086:3c64] type 0 class 0x000600
[    6.643812] pci 0000:80:06.5: [8086:3c65] type 0 class 0x000600
[    6.643891] pci 0000:80:06.6: [8086:3c66] type 0 class 0x000600
[    6.643967] pci 0000:80:06.7: [8086:3c67] type 0 class 0x000600
[    6.644043] pci 0000:80:07.0: [8086:3c68] type 0 class 0x000600
[    6.644119] pci 0000:80:07.1: [8086:3c69] type 0 class 0x000600
[    6.644201] pci 0000:80:07.2: [8086:3c6a] type 0 class 0x000600
[    6.644277] pci 0000:80:07.3: [8086:3c6b] type 0 class 0x000600
[    6.644353] pci 0000:80:07.4: [8086:3c6c] type 0 class 0x000600
[    6.644510] pci 0000:80:02.0: PCI bridge to [bus 81-81]
[    6.644632] pci 0000:80:02.0: Dev MPS 128 MPSS 256 MRRS 128
[    6.644744] pci 0000:80:02.0: Dev MPS 256 MPSS 256 MRRS 128
[    6.644845] pci_bus 0000:80: on NUMA node 1 (pxm 1)
[    6.644851] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
[    6.644982] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.BR44._PRT]
[    6.645182]  pci0000:80: Requesting ACPI _OSC control (0x1d)
[    6.645626]  pci0000:80: ACPI _OSC control (0x15) granted
[    6.649574] ACPI: PCI Root Bridge [UCR0] (domain 0000 [bus 7f])
[    6.649791] pci 0000:7f:08.0: [8086:3c80] type 0 class 0x000880
[    6.649856] pci 0000:7f:08.2: [8086:3c41] type 0 class 0x001101
[    6.649917] pci 0000:7f:08.3: [8086:3c83] type 0 class 0x000880
[    6.649988] pci 0000:7f:08.4: [8086:3c84] type 0 class 0x000880
[    6.650063] pci 0000:7f:08.5: [8086:3c85] type 0 class 0x000880
[    6.650132] pci 0000:7f:08.6: [8086:3c86] type 0 class 0x000880
[    6.650202] pci 0000:7f:08.7: [8086:3c87] type 0 class 0x000880
[    6.650274] pci 0000:7f:09.0: [8086:3c90] type 0 class 0x000880
[    6.650332] pci 0000:7f:09.2: [8086:3c42] type 0 class 0x001101
[    6.650396] pci 0000:7f:09.3: [8086:3c93] type 0 class 0x000880
[    6.650467] pci 0000:7f:09.4: [8086:3c94] type 0 class 0x000880
[    6.650549] pci 0000:7f:09.5: [8086:3c95] type 0 class 0x000880
[    6.650618] pci 0000:7f:09.6: [8086:3c96] type 0 class 0x000880
[    6.650685] pci 0000:7f:0a.0: [8086:3cc0] type 0 class 0x000880
[    6.650738] pci 0000:7f:0a.1: [8086:3cc1] type 0 class 0x000880
[    6.650790] pci 0000:7f:0a.2: [8086:3cc2] type 0 class 0x000880
[    6.650843] pci 0000:7f:0a.3: [8086:3cd0] type 0 class 0x000880
[    6.650899] pci 0000:7f:0a.4: [8086:3cc4] type 0 class 0x000880
[    6.650952] pci 0000:7f:0a.5: [8086:3cc5] type 0 class 0x000880
[    6.651005] pci 0000:7f:0a.6: [8086:3cc6] type 0 class 0x000880
[    6.651058] pci 0000:7f:0a.7: [8086:3cc7] type 0 class 0x000880
[    6.651110] pci 0000:7f:0b.0: [8086:3ce0] type 0 class 0x000880
[    6.651161] pci 0000:7f:0b.2: [8086:3ce2] type 0 class 0x000880
[    6.651211] pci 0000:7f:0b.3: [8086:3ce3] type 0 class 0x000880
[    6.651265] pci 0000:7f:0c.0: [8086:3ce8] type 0 class 0x000880
[    6.651320] pci 0000:7f:0c.1: [8086:3ce8] type 0 class 0x000880
[    6.651372] pci 0000:7f:0c.2: [8086:3ce8] type 0 class 0x000880
[    6.651424] pci 0000:7f:0c.3: [8086:3ce8] type 0 class 0x000880
[    6.651478] pci 0000:7f:0c.6: [8086:3cf4] type 0 class 0x000880
[    6.651530] pci 0000:7f:0c.7: [8086:3cf6] type 0 class 0x000880
[    6.651582] pci 0000:7f:0d.0: [8086:3ce8] type 0 class 0x000880
[    6.651634] pci 0000:7f:0d.1: [8086:3ce8] type 0 class 0x000880
[    6.651686] pci 0000:7f:0d.2: [8086:3ce8] type 0 class 0x000880
[    6.651741] pci 0000:7f:0d.3: [8086:3ce8] type 0 class 0x000880
[    6.651795] pci 0000:7f:0d.6: [8086:3cf5] type 0 class 0x000880
[    6.651849] pci 0000:7f:0e.0: [8086:3ca0] type 0 class 0x000880
[    6.651909] pci 0000:7f:0e.1: [8086:3c46] type 0 class 0x001101
[    6.651968] pci 0000:7f:0e.2: [8086:3c70] type 0 class 0x000880
[    6.652038] pci 0000:7f:0f.0: [8086:3ca8] type 0 class 0x000880
[    6.652109] pci 0000:7f:0f.1: [8086:3c71] type 0 class 0x000880
[    6.652181] pci 0000:7f:0f.2: [8086:3caa] type 0 class 0x000880
[    6.652255] pci 0000:7f:0f.3: [8086:3cab] type 0 class 0x000880
[    6.652327] pci 0000:7f:0f.4: [8086:3cac] type 0 class 0x000880
[    6.652398] pci 0000:7f:0f.5: [8086:3cad] type 0 class 0x000880
[    6.652467] pci 0000:7f:0f.6: [8086:3cae] type 0 class 0x000880
[    6.652525] pci 0000:7f:0f.7: [8086:3caf] type 0 class 0x000880
[    6.652587] pci 0000:7f:10.0: [8086:3cb0] type 0 class 0x000880
[    6.652659] pci 0000:7f:10.1: [8086:3cb1] type 0 class 0x000880
[    6.652739] pci 0000:7f:10.2: [8086:3cb2] type 0 class 0x000880
[    6.652814] pci 0000:7f:10.3: [8086:3cb3] type 0 class 0x000880
[    6.652886] pci 0000:7f:10.4: [8086:3cb4] type 0 class 0x000880
[    6.652961] pci 0000:7f:10.5: [8086:3cb5] type 0 class 0x000880
[    6.653033] pci 0000:7f:10.6: [8086:3cb6] type 0 class 0x000880
[    6.653104] pci 0000:7f:10.7: [8086:3cb7] type 0 class 0x000880
[    6.653173] pci 0000:7f:11.0: [8086:3cb8] type 0 class 0x000880
[    6.653231] pci 0000:7f:11.1: [8086:3cb9] type 0 class 0x000880
[    6.653289] pci 0000:7f:11.2: [8086:3cba] type 0 class 0x000880
[    6.653351] pci 0000:7f:11.3: [8086:3cbb] type 0 class 0x000880
[    6.653410] pci 0000:7f:11.4: [8086:3cbc] type 0 class 0x000880
[    6.653469] pci 0000:7f:11.5: [8086:3cbd] type 0 class 0x000880
[    6.653527] pci 0000:7f:11.6: [8086:3cbe] type 0 class 0x000880
[    6.653586] pci 0000:7f:11.7: [8086:3cbf] type 0 class 0x000880
[    6.653646] pci 0000:7f:13.0: [8086:3ce4] type 0 class 0x000880
[    6.653698] pci 0000:7f:13.1: [8086:3c43] type 0 class 0x001101
[    6.653754] pci 0000:7f:13.4: [8086:3ce6] type 0 class 0x001101
[    6.653810] pci 0000:7f:13.5: [8086:3c44] type 0 class 0x001101
[    6.653864] pci 0000:7f:13.6: [8086:3c45] type 0 class 0x000880
[    6.653952]  pci0000:7f: Requesting ACPI _OSC control (0x1d)
[    6.654056]  pci0000:7f: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    6.654194] ACPI _OSC control for PCIe not granted, disabling ASPM
[    6.656568] ACPI: PCI Root Bridge [UCR1] (domain 0000 [bus ff])
[    6.656785] pci 0000:ff:08.0: [8086:3c80] type 0 class 0x000880
[    6.656849] pci 0000:ff:08.2: [8086:3c41] type 0 class 0x001101
[    6.656915] pci 0000:ff:08.3: [8086:3c83] type 0 class 0x000880
[    6.656991] pci 0000:ff:08.4: [8086:3c84] type 0 class 0x000880
[    6.657071] pci 0000:ff:08.5: [8086:3c85] type 0 class 0x000880
[    6.657146] pci 0000:ff:08.6: [8086:3c86] type 0 class 0x000880
[    6.657226] pci 0000:ff:08.7: [8086:3c87] type 0 class 0x000880
[    6.657304] pci 0000:ff:09.0: [8086:3c90] type 0 class 0x000880
[    6.657366] pci 0000:ff:09.2: [8086:3c42] type 0 class 0x001101
[    6.657431] pci 0000:ff:09.3: [8086:3c93] type 0 class 0x000880
[    6.657507] pci 0000:ff:09.4: [8086:3c94] type 0 class 0x000880
[    6.657588] pci 0000:ff:09.5: [8086:3c95] type 0 class 0x000880
[    6.657662] pci 0000:ff:09.6: [8086:3c96] type 0 class 0x000880
[    6.657735] pci 0000:ff:0a.0: [8086:3cc0] type 0 class 0x000880
[    6.657795] pci 0000:ff:0a.1: [8086:3cc1] type 0 class 0x000880
[    6.657852] pci 0000:ff:0a.2: [8086:3cc2] type 0 class 0x000880
[    6.657910] pci 0000:ff:0a.3: [8086:3cd0] type 0 class 0x000880
[    6.657967] pci 0000:ff:0a.4: [8086:3cc4] type 0 class 0x000880
[    6.658024] pci 0000:ff:0a.5: [8086:3cc5] type 0 class 0x000880
[    6.658081] pci 0000:ff:0a.6: [8086:3cc6] type 0 class 0x000880
[    6.658138] pci 0000:ff:0a.7: [8086:3cc7] type 0 class 0x000880
[    6.658194] pci 0000:ff:0b.0: [8086:3ce0] type 0 class 0x000880
[    6.658253] pci 0000:ff:0b.2: [8086:3ce2] type 0 class 0x000880
[    6.658307] pci 0000:ff:0b.3: [8086:3ce3] type 0 class 0x000880
[    6.658366] pci 0000:ff:0c.0: [8086:3ce8] type 0 class 0x000880
[    6.658421] pci 0000:ff:0c.1: [8086:3ce8] type 0 class 0x000880
[    6.658477] pci 0000:ff:0c.2: [8086:3ce8] type 0 class 0x000880
[    6.658534] pci 0000:ff:0c.3: [8086:3ce8] type 0 class 0x000880
[    6.658592] pci 0000:ff:0c.6: [8086:3cf4] type 0 class 0x000880
[    6.658647] pci 0000:ff:0c.7: [8086:3cf6] type 0 class 0x000880
[    6.658707] pci 0000:ff:0d.0: [8086:3ce8] type 0 class 0x000880
[    6.658763] pci 0000:ff:0d.1: [8086:3ce8] type 0 class 0x000880
[    6.658819] pci 0000:ff:0d.2: [8086:3ce8] type 0 class 0x000880
[    6.658875] pci 0000:ff:0d.3: [8086:3ce8] type 0 class 0x000880
[    6.658933] pci 0000:ff:0d.6: [8086:3cf5] type 0 class 0x000880
[    6.658991] pci 0000:ff:0e.0: [8086:3ca0] type 0 class 0x000880
[    6.659055] pci 0000:ff:0e.1: [8086:3c46] type 0 class 0x001101
[    6.659118] pci 0000:ff:0e.2: [8086:3c70] type 0 class 0x000880
[    6.659197] pci 0000:ff:0f.0: [8086:3ca8] type 0 class 0x000880
[    6.659274] pci 0000:ff:0f.1: [8086:3c71] type 0 class 0x000880
[    6.659351] pci 0000:ff:0f.2: [8086:3caa] type 0 class 0x000880
[    6.659427] pci 0000:ff:0f.3: [8086:3cab] type 0 class 0x000880
[    6.659503] pci 0000:ff:0f.4: [8086:3cac] type 0 class 0x000880
[    6.659584] pci 0000:ff:0f.5: [8086:3cad] type 0 class 0x000880
[    6.659657] pci 0000:ff:0f.6: [8086:3cae] type 0 class 0x000880
[    6.659720] pci 0000:ff:0f.7: [8086:3caf] type 0 class 0x000880
[    6.659790] pci 0000:ff:10.0: [8086:3cb0] type 0 class 0x000880
[    6.659869] pci 0000:ff:10.1: [8086:3cb1] type 0 class 0x000880
[    6.659946] pci 0000:ff:10.2: [8086:3cb2] type 0 class 0x000880
[    6.660023] pci 0000:ff:10.3: [8086:3cb3] type 0 class 0x000880
[    6.660100] pci 0000:ff:10.4: [8086:3cb4] type 0 class 0x000880
[    6.660178] pci 0000:ff:10.5: [8086:3cb5] type 0 class 0x000880
[    6.660255] pci 0000:ff:10.6: [8086:3cb6] type 0 class 0x000880
[    6.660333] pci 0000:ff:10.7: [8086:3cb7] type 0 class 0x000880
[    6.660410] pci 0000:ff:11.0: [8086:3cb8] type 0 class 0x000880
[    6.660473] pci 0000:ff:11.1: [8086:3cb9] type 0 class 0x000880
[    6.660536] pci 0000:ff:11.2: [8086:3cba] type 0 class 0x000880
[    6.660599] pci 0000:ff:11.3: [8086:3cbb] type 0 class 0x000880
[    6.660662] pci 0000:ff:11.4: [8086:3cbc] type 0 class 0x000880
[    6.660725] pci 0000:ff:11.5: [8086:3cbd] type 0 class 0x000880
[    6.660787] pci 0000:ff:11.6: [8086:3cbe] type 0 class 0x000880
[    6.660850] pci 0000:ff:11.7: [8086:3cbf] type 0 class 0x000880
[    6.660919] pci 0000:ff:13.0: [8086:3ce4] type 0 class 0x000880
[    6.660976] pci 0000:ff:13.1: [8086:3c43] type 0 class 0x001101
[    6.661038] pci 0000:ff:13.4: [8086:3ce6] type 0 class 0x001101
[    6.661096] pci 0000:ff:13.5: [8086:3c44] type 0 class 0x001101
[    6.661153] pci 0000:ff:13.6: [8086:3c45] type 0 class 0x000880
[    6.661246]  pci0000:ff: Requesting ACPI _OSC control (0x1d)
[    6.661350]  pci0000:ff: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    6.661487] ACPI _OSC control for PCIe not granted, disabling ASPM
[    6.664083] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    6.664874] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 10 11 12 14 15)
[    6.665659] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15)
[    6.666446] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
[    6.667235] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
[    6.668027] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12 14 15)
[    6.668811] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *10 11 12 14 15)
[    6.669593] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
[    6.670524] vgaarb: device added: PCI:0000:0a:00.0,decodes=io+mem,owns=io+mem,locks=none
[    6.670753] vgaarb: loaded
[    6.670844] vgaarb: bridge control possible 0000:0a:00.0
[    6.671144] i2c-core: driver [aat2870] using legacy suspend method
[    6.671248] i2c-core: driver [aat2870] using legacy resume method
[    6.671446] SCSI subsystem initialized
[    6.671668] libata version 3.00 loaded.
[    6.671740] usbcore: registered new interface driver usbfs
[    6.671854] usbcore: registered new interface driver hub
[    6.672008] usbcore: registered new device driver usb
[    6.672333] PCI: Using ACPI for IRQ routing
[    6.679093] PCI: pci_cache_line_size set to 64 bytes
[    6.679824] reserve RAM buffer: 000000000008f400 - 000000000008ffff 
[    6.679828] reserve RAM buffer: 00000000a9841000 - 00000000abffffff 
[    6.679832] reserve RAM buffer: 00000000aa963000 - 00000000abffffff 
[    6.679835] reserve RAM buffer: 00000000bad03000 - 00000000bbffffff 
[    6.679842] reserve RAM buffer: 00000000bad1f000 - 00000000bbffffff 
[    6.679847] reserve RAM buffer: 00000000bb678000 - 00000000bbffffff 
[    6.679852] reserve RAM buffer: 00000000bb6cf000 - 00000000bbffffff 
[    6.679857] reserve RAM buffer: 00000000bb6fc000 - 00000000bbffffff 
[    6.679861] reserve RAM buffer: 00000000bb736000 - 00000000bbffffff 
[    6.679864] reserve RAM buffer: 00000000bda06000 - 00000000bfffffff 
[    6.679872] reserve RAM buffer: 00000000bdce3000 - 00000000bfffffff 
[    6.679879] reserve RAM buffer: 00000000be000000 - 00000000bfffffff 
[    6.680124] NetLabel: Initializing
[    6.680219] NetLabel:  domain hash size = 128
[    6.680316] NetLabel:  protocols = UNLABELED CIPSOv4
[    6.680434] NetLabel:  unlabeled traffic allowed by default
[    6.680605] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    6.681213] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    6.683454] Switching to clocksource hpet
[    6.692685] Switched to NOHz mode on CPU #0
[    6.692843] Switched to NOHz mode on CPU #6
[    6.692851] Switched to NOHz mode on CPU #7
[    6.692882] Switched to NOHz mode on CPU #27
[    6.692895] Switched to NOHz mode on CPU #5
[    6.692923] Switched to NOHz mode on CPU #30
[    6.692948] Switched to NOHz mode on CPU #23
[    6.692958] Switched to NOHz mode on CPU #17
[    6.693010] Switched to NOHz mode on CPU #28
[    6.693057] Switched to NOHz mode on CPU #19
[    6.693076] Switched to NOHz mode on CPU #22
[    6.693091] Switched to NOHz mode on CPU #16
[    6.693107] Switched to NOHz mode on CPU #2
[    6.693126] Switched to NOHz mode on CPU #21
[    6.693151] Switched to NOHz mode on CPU #11
[    6.693191] Switched to NOHz mode on CPU #18
[    6.693215] Switched to NOHz mode on CPU #24
[    6.693227] Switched to NOHz mode on CPU #3
[    6.693242] Switched to NOHz mode on CPU #1
[    6.693259] Switched to NOHz mode on CPU #8
[    6.693268] Switched to NOHz mode on CPU #4
[    6.693282] Switched to NOHz mode on CPU #20
[    6.693303] Switched to NOHz mode on CPU #26
[    6.693322] Switched to NOHz mode on CPU #9
[    6.693328] Switched to NOHz mode on CPU #25
[    6.693334] Switched to NOHz mode on CPU #12
[    6.693339] Switched to NOHz mode on CPU #14
[    6.693344] Switched to NOHz mode on CPU #10
[    6.693350] Switched to NOHz mode on CPU #15
[    6.693375] Switched to NOHz mode on CPU #31
[    6.693401] Switched to NOHz mode on CPU #29
[    6.693406] Switched to NOHz mode on CPU #13
[    6.696672] AppArmor: AppArmor Filesystem Enabled
[    6.696796] pnp: PnP ACPI init
[    6.696907] ACPI: bus type pnp registered
[    6.697296] pnp 00:00: [bus 00-7e]
[    6.697301] pnp 00:00: [io  0x0000-0x0cf7 window]
[    6.697304] pnp 00:00: [io  0x0cf8-0x0cff]
[    6.697308] pnp 00:00: [io  0x0000-0xbfff window]
[    6.697311] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    6.697315] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    6.697318] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    6.697322] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    6.697325] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    6.697329] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    6.697332] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    6.697335] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    6.697339] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    6.697342] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    6.697346] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    6.697349] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    6.697353] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    6.697356] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    6.697360] pnp 00:00: [mem 0xd0000000-0xebffffff window]
[    6.697363] pnp 00:00: [mem 0x3c0000000000-0x3c007fffffff window]
[    6.697367] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    6.697484] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    6.697506] pnp 00:01: [io  0x0000-0x001f]
[    6.697510] pnp 00:01: [io  0x0081-0x0091]
[    6.697512] pnp 00:01: [io  0x0093-0x009f]
[    6.697515] pnp 00:01: [io  0x00c0-0x00df]
[    6.697519] pnp 00:01: [dma 4]
[    6.697546] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    6.697560] pnp 00:02: [mem 0xff000000-0xffffffff]
[    6.697591] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    6.697712] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    6.697742] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    6.697758] pnp 00:04: [io  0x00f0]
[    6.697773] pnp 00:04: [irq 13]
[    6.697799] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    6.697844] pnp 00:05: [io  0x002e-0x002f]
[    6.697847] pnp 00:05: [io  0x004e-0x004f]
[    6.697850] pnp 00:05: [io  0x0061]
[    6.697853] pnp 00:05: [io  0x0063]
[    6.697860] pnp 00:05: [io  0x0065]
[    6.697863] pnp 00:05: [io  0x0067]
[    6.697865] pnp 00:05: [io  0x0070]
[    6.697868] pnp 00:05: [io  0x0080]
[    6.697871] pnp 00:05: [io  0x0092]
[    6.697873] pnp 00:05: [io  0x00b2-0x00b3]
[    6.697876] pnp 00:05: [io  0x0680-0x069f]
[    6.697879] pnp 00:05: [io  0xffff]
[    6.697882] pnp 00:05: [io  0xffff]
[    6.697885] pnp 00:05: [io  0xffff]
[    6.697887] pnp 00:05: [io  0x0400-0x0453]
[    6.697890] pnp 00:05: [io  0x0458-0x047f]
[    6.697893] pnp 00:05: [io  0x0500-0x057f]
[    6.697896] pnp 00:05: [io  0x0600-0x061f]
[    6.697899] pnp 00:05: [io  0x0ca2-0x0ca5]
[    6.697901] pnp 00:05: [io  0x0cf9]
[    6.698098] system 00:05: [io  0x0680-0x069f] has been reserved
[    6.698203] system 00:05: [io  0xffff] has been reserved
[    6.698305] system 00:05: [io  0xffff] has been reserved
[    6.698406] system 00:05: [io  0xffff] has been reserved
[    6.698508] system 00:05: [io  0x0400-0x0453] has been reserved
[    6.698611] system 00:05: [io  0x0458-0x047f] has been reserved
[    6.698715] system 00:05: [io  0x0500-0x057f] has been reserved
[    6.698819] system 00:05: [io  0x0600-0x061f] has been reserved
[    6.698922] system 00:05: [io  0x0ca2-0x0ca5] has been reserved
[    6.699026] system 00:05: [io  0x0cf9] could not be reserved
[    6.699130] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    6.699145] pnp 00:06: [io  0x0070-0x0077]
[    6.699154] pnp 00:06: [irq 8]
[    6.699182] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    6.699228] pnp 00:07: [io  0x0454-0x0457]
[    6.699407] system 00:07: [io  0x0454-0x0457] has been reserved
[    6.699513] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    6.699896] pnp 00:08: [io  0x03f8-0x03ff]
[    6.699905] pnp 00:08: [irq 4]
[    6.699908] pnp 00:08: [dma 0 disabled]
[    6.700015] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    6.700303] pnp 00:09: [io  0x02f8-0x02ff]
[    6.700312] pnp 00:09: [irq 3]
[    6.700315] pnp 00:09: [dma 0 disabled]
[    6.700410] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    6.701052] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    6.701056] pnp 00:0a: [mem 0xebfff000-0xebffffff]
[    6.701059] pnp 00:0a: [mem 0xc0000000-0xcfffffff]
[    6.701062] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
[    6.701066] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    6.701069] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    6.701073] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    6.701077] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    6.701080] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
[    6.701083] pnp 00:0a: [mem 0xff000000-0xffffffff]
[    6.701086] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
[    6.701092] pnp 00:0a: [mem 0xfec00000-0xfecfffff]
[    6.701096] pnp 00:0a: [mem 0xd1e70000-0xd1e70fff]
[    6.701099] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    6.701301] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    6.701410] system 00:0a: [mem 0xebfff000-0xebffffff] has been reserved
[    6.701516] system 00:0a: [mem 0xc0000000-0xcfffffff] has been reserved
[    6.701622] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    6.701729] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    6.701835] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
[    6.701943] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
[    6.702050] system 00:0a: [mem 0xfec00000-0xfecfffff] could not be reserved
[    6.702157] system 00:0a: [mem 0xd1e70000-0xd1e70fff] has been reserved
[    6.702264] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    6.702751] pnp 00:0b: [bus 80-fe]
[    6.702755] pnp 00:0b: [io  0xc000-0xffff window]
[    6.702759] pnp 00:0b: [mem 0xec000000-0xfbffffff window]
[    6.702763] pnp 00:0b: [mem 0x3c0080000000-0x3c00ffffffff window]
[    6.702885] pnp 00:0b: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    6.702979] pnp 00:0c: [mem 0x00000000-0x0009cfff]
[    6.703219] system 00:0c: [mem 0x00000000-0x0009cfff] could not be reserved
[    6.703328] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    6.703740] pnp 00:0d: [bus 7f]
[    6.703852] pnp 00:0d: Plug and Play ACPI device, IDs PNP0a03 (active)
[    6.703919] pnp 00:0e: [bus ff]
[    6.704025] pnp 00:0e: Plug and Play ACPI device, IDs PNP0a03 (active)
[    6.704114] pnp: PnP ACPI: found 15 devices
[    6.704212] ACPI: ACPI bus type pnp unregistered
[    6.712532] PCI: max bus depth: 3 pci_try_num: 4
[    6.712648] pci 0000:02:08.0: PCI bridge to [bus 03-03]
[    6.712752] pci 0000:02:08.0:   bridge window [io  0x2000-0x2fff]
[    6.712859] pci 0000:02:08.0:   bridge window [mem 0xd1c00000-0xd1cfffff]
[    6.712968] pci 0000:02:08.0:   bridge window [mem 0xeb000000-0xeb9fffff 64bit pref]
[    6.713108] pci 0000:01:00.0: PCI bridge to [bus 02-03]
[    6.713210] pci 0000:01:00.0:   bridge window [io  0x2000-0x2fff]
[    6.713316] pci 0000:01:00.0:   bridge window [mem 0xd1c00000-0xd1cfffff]
[    6.713424] pci 0000:01:00.0:   bridge window [mem 0xeb000000-0xeb9fffff 64bit pref]
[    6.713563] pci 0000:00:01.0: PCI bridge to [bus 01-03]
[    6.713674] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    6.713781] pci 0000:00:01.0:   bridge window [mem 0xd1c00000-0xd1dfffff]
[    6.713890] pci 0000:00:01.0:   bridge window [mem 0xeb000000-0xeb9fffff 64bit pref]
[    6.714030] pci 0000:00:01.1: PCI bridge to [bus 04-04]
[    6.714141] pci 0000:00:02.0: PCI bridge to [bus 05-05]
[    6.714252] pci 0000:00:02.2: PCI bridge to [bus 06-06]
[    6.714363] pci 0000:00:03.0: PCI bridge to [bus 07-07]
[    6.714474] pci 0000:00:03.2: PCI bridge to [bus 08-08]
[    6.714587] pci 0000:00:1c.0: PCI bridge to [bus 09-09]
[    6.714689] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    6.714796] pci 0000:00:1c.0:   bridge window [mem 0xd1900000-0xd1bfffff]
[    6.714911] pci 0000:00:1c.7: PCI bridge to [bus 0a-0a]
[    6.715016] pci 0000:00:1c.7:   bridge window [mem 0xd0000000-0xd18fffff]
[    6.715130] pci 0000:00:1e.0: PCI bridge to [bus 0b-0b]
[    6.715246] pci 0000:80:02.0: PCI bridge to [bus 81-81]
[    6.715433] pci 0000:00:01.0: PCI INT A -> GSI 47 (level, low) -> IRQ 47
[    6.715543] pci 0000:00:01.0: setting latency timer to 64
[    6.715596] pci 0000:01:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
[    6.715704] pci 0000:01:00.0: setting latency timer to 64
[    6.715713] pci 0000:02:08.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
[    6.715821] pci 0000:02:08.0: setting latency timer to 64
[    6.715830] pci 0000:00:01.1: PCI INT A -> GSI 47 (level, low) -> IRQ 47
[    6.715937] pci 0000:00:01.1: setting latency timer to 64
[    6.715946] pci 0000:00:02.0: PCI INT A -> GSI 47 (level, low) -> IRQ 47
[    6.716054] pci 0000:00:02.0: setting latency timer to 64
[    6.716062] pci 0000:00:02.2: PCI INT A -> GSI 47 (level, low) -> IRQ 47
[    6.716170] pci 0000:00:02.2: setting latency timer to 64
[    6.716178] pci 0000:00:03.0: PCI INT A -> GSI 47 (level, low) -> IRQ 47
[    6.716286] pci 0000:00:03.0: setting latency timer to 64
[    6.716294] pci 0000:00:03.2: PCI INT A -> GSI 47 (level, low) -> IRQ 47
[    6.716402] pci 0000:00:03.2: setting latency timer to 64
[    6.716435] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.716543] pci 0000:00:1c.0: setting latency timer to 64
[    6.716575] pci 0000:00:1c.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    6.716683] pci 0000:00:1c.7: setting latency timer to 64
[    6.716692] pci 0000:00:1e.0: setting latency timer to 64
[    6.716750] pci 0000:80:02.0: PCI INT A -> GSI 71 (level, low) -> IRQ 71
[    6.716859] pci 0000:80:02.0: setting latency timer to 64
[    6.716870] pci_bus 0000:00: resource 4 [io  0x0000-0xbfff]
[    6.716874] pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff]
[    6.716878] pci_bus 0000:00: resource 6 [mem 0x000c0000-0x000c3fff]
[    6.716881] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000c7fff]
[    6.716885] pci_bus 0000:00: resource 8 [mem 0x000c8000-0x000cbfff]
[    6.716888] pci_bus 0000:00: resource 9 [mem 0x000cc000-0x000cffff]
[    6.716892] pci_bus 0000:00: resource 10 [mem 0x000d8000-0x000dbfff]
[    6.716896] pci_bus 0000:00: resource 11 [mem 0x000dc000-0x000dffff]
[    6.716900] pci_bus 0000:00: resource 12 [mem 0x000e0000-0x000e3fff]
[    6.716903] pci_bus 0000:00: resource 13 [mem 0x000e4000-0x000e7fff]
[    6.716907] pci_bus 0000:00: resource 14 [mem 0x000e8000-0x000ebfff]
[    6.716911] pci_bus 0000:00: resource 15 [mem 0x000ec000-0x000effff]
[    6.716914] pci_bus 0000:00: resource 16 [mem 0x000f0000-0x000fffff]
[    6.716918] pci_bus 0000:00: resource 17 [mem 0xd0000000-0xebffffff]
[    6.716922] pci_bus 0000:00: resource 18 [mem 0x3c0000000000-0x3c007fffffff]
[    6.716926] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    6.716930] pci_bus 0000:01: resource 1 [mem 0xd1c00000-0xd1dfffff]
[    6.716934] pci_bus 0000:01: resource 2 [mem 0xeb000000-0xeb9fffff 64bit pref]
[    6.716938] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    6.716941] pci_bus 0000:02: resource 1 [mem 0xd1c00000-0xd1cfffff]
[    6.716945] pci_bus 0000:02: resource 2 [mem 0xeb000000-0xeb9fffff 64bit pref]
[    6.716949] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
[    6.716952] pci_bus 0000:03: resource 1 [mem 0xd1c00000-0xd1cfffff]
[    6.716956] pci_bus 0000:03: resource 2 [mem 0xeb000000-0xeb9fffff 64bit pref]
[    6.716962] pci_bus 0000:09: resource 0 [io  0x1000-0x1fff]
[    6.716965] pci_bus 0000:09: resource 1 [mem 0xd1900000-0xd1bfffff]
[    6.716969] pci_bus 0000:0a: resource 1 [mem 0xd0000000-0xd18fffff]
[    6.716973] pci_bus 0000:0b: resource 4 [io  0x0000-0xbfff]
[    6.716976] pci_bus 0000:0b: resource 5 [mem 0x000a0000-0x000bffff]
[    6.716980] pci_bus 0000:0b: resource 6 [mem 0x000c0000-0x000c3fff]
[    6.716984] pci_bus 0000:0b: resource 7 [mem 0x000c4000-0x000c7fff]
[    6.716987] pci_bus 0000:0b: resource 8 [mem 0x000c8000-0x000cbfff]
[    6.716991] pci_bus 0000:0b: resource 9 [mem 0x000cc000-0x000cffff]
[    6.716995] pci_bus 0000:0b: resource 10 [mem 0x000d8000-0x000dbfff]
[    6.716998] pci_bus 0000:0b: resource 11 [mem 0x000dc000-0x000dffff]
[    6.717002] pci_bus 0000:0b: resource 12 [mem 0x000e0000-0x000e3fff]
[    6.717006] pci_bus 0000:0b: resource 13 [mem 0x000e4000-0x000e7fff]
[    6.717009] pci_bus 0000:0b: resource 14 [mem 0x000e8000-0x000ebfff]
[    6.717013] pci_bus 0000:0b: resource 15 [mem 0x000ec000-0x000effff]
[    6.717017] pci_bus 0000:0b: resource 16 [mem 0x000f0000-0x000fffff]
[    6.717020] pci_bus 0000:0b: resource 17 [mem 0xd0000000-0xebffffff]
[    6.717024] pci_bus 0000:0b: resource 18 [mem 0x3c0000000000-0x3c007fffffff]
[    6.717028] pci_bus 0000:80: resource 4 [io  0xc000-0xffff]
[    6.717032] pci_bus 0000:80: resource 5 [mem 0xec000000-0xfbffffff]
[    6.717036] pci_bus 0000:80: resource 6 [mem 0x3c0080000000-0x3c00ffffffff]
[    6.717141] NET: Registered protocol family 2
[    6.718262] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    6.721013] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    6.723581] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    6.723960] TCP: Hash tables configured (established 524288 bind 65536)
[    6.724066] TCP reno registered
[    6.724245] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    6.724600] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
[    6.725577] NET: Registered protocol family 1
[    6.783641] pci 0000:0a:00.0: Boot video device
[    6.784014] PCI: CLS 64 bytes, default 64
[    6.784018] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    6.784124] Placing 64MB software IO TLB between ffff8800a5841000 - ffff8800a9841000
[    6.784259] software IO TLB at phys 0xa5841000 - 0xa9841000
[    6.787586] audit: initializing netlink socket (disabled)
[    6.787699] type=2000 audit(1315943280.310:1): initialized
[    6.917383] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    7.102511] VFS: Disk quotas dquot_6.5.2
[    7.102863] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    7.104465] fuse init (API version 7.17)
[    7.104761] msgmni has been set to 32768
[    7.105620] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    7.105840] io scheduler noop registered
[    7.105936] io scheduler deadline registered
[    7.106124] io scheduler cfq registered (default)
[    7.107005] pcieport 0000:00:01.0: setting latency timer to 64
[    7.107104] pcieport 0000:00:01.0: irq 88 for MSI/MSI-X
[    7.107302] pcieport 0000:00:01.1: setting latency timer to 64
[    7.107374] pcieport 0000:00:01.1: irq 89 for MSI/MSI-X
[    7.107526] pcieport 0000:00:02.0: setting latency timer to 64
[    7.107598] pcieport 0000:00:02.0: irq 90 for MSI/MSI-X
[    7.107758] pcieport 0000:00:02.2: setting latency timer to 64
[    7.107829] pcieport 0000:00:02.2: irq 91 for MSI/MSI-X
[    7.107973] pcieport 0000:00:03.0: setting latency timer to 64
[    7.108043] pcieport 0000:00:03.0: irq 92 for MSI/MSI-X
[    7.108186] pcieport 0000:00:03.2: setting latency timer to 64
[    7.108261] pcieport 0000:00:03.2: irq 93 for MSI/MSI-X
[    7.108412] pcieport 0000:00:1c.0: setting latency timer to 64
[    7.108487] pcieport 0000:00:1c.0: irq 94 for MSI/MSI-X
[    7.108636] pcieport 0000:00:1c.7: setting latency timer to 64
[    7.108710] pcieport 0000:00:1c.7: irq 95 for MSI/MSI-X
[    7.109082] pcieport 0000:80:02.0: setting latency timer to 64
[    7.109200] pcieport 0000:80:02.0: irq 96 for MSI/MSI-X
[    7.109489] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    7.109598] pcieport 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    7.111128] pcieport 0000:02:08.0: Signaling PME through PCIe PME interrupt
[    7.111234] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    7.111346] pci 0000:03:00.3: Signaling PME through PCIe PME interrupt
[    7.111451] pci 0000:03:00.4: Signaling PME through PCIe PME interrupt
[    7.111559] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    7.111610] pcieport 0000:00:01.1: Signaling PME through PCIe PME interrupt
[    7.111719] pcie_pme 0000:00:01.1:pcie01: service driver pcie_pme loaded
[    7.111749] pcieport 0000:00:02.0: Signaling PME through PCIe PME interrupt
[    7.111857] pcie_pme 0000:00:02.0:pcie01: service driver pcie_pme loaded
[    7.111882] pcieport 0000:00:02.2: Signaling PME through PCIe PME interrupt
[    7.111990] pcie_pme 0000:00:02.2:pcie01: service driver pcie_pme loaded
[    7.112014] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[    7.112123] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[    7.112147] pcieport 0000:00:03.2: Signaling PME through PCIe PME interrupt
[    7.112255] pcie_pme 0000:00:03.2:pcie01: service driver pcie_pme loaded
[    7.112279] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    7.112385] pci 0000:09:00.0: Signaling PME through PCIe PME interrupt
[    7.112490] pci 0000:09:00.1: Signaling PME through PCIe PME interrupt
[    7.112595] pci 0000:09:00.2: Signaling PME through PCIe PME interrupt
[    7.112701] pci 0000:09:00.3: Signaling PME through PCIe PME interrupt
[    7.112809] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    7.112843] pcieport 0000:00:1c.7: Signaling PME through PCIe PME interrupt
[    7.112949] pci 0000:0a:00.0: Signaling PME through PCIe PME interrupt
[    7.113057] pcie_pme 0000:00:1c.7:pcie01: service driver pcie_pme loaded
[    7.113084] pcieport 0000:80:02.0: Signaling PME through PCIe PME interrupt
[    7.113193] pcie_pme 0000:80:02.0:pcie01: service driver pcie_pme loaded
[    7.113254] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    7.113452] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    7.113679] intel_idle: MWAIT substates: 0x21120
[    7.113682] intel_idle: v0.4 model 0x2D
[    7.113685] intel_idle: lapic_timer_reliable_states 0xffffffff
[    7.114118] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    7.114258] ACPI: Power Button [PWRF]
[    7.114402] ACPI: acpi_idle yielding to intel_idle
[    7.237317] ERST: Error Record Serialization Table (ERST) support is initialized.
[    7.237819] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
[    7.238084] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    7.258960] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    7.423884] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    7.666792] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    7.782958] Refined TSC clocksource calibration: 2294.470 MHz.
[    7.783068] Switching to clocksource tsc
[    7.823806] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    7.963450] Linux agpgart interface v0.103
[    7.967649] brd: module loaded
[    7.969564] loop: module loaded
[    7.970486] Fixed MDIO Bus: probed
[    7.970618] PPP generic driver version 2.4.2
[    7.970787] tun: Universal TUN/TAP device driver, 1.6
[    7.970890] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    7.971118] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.971367] ehci_hcd 0000:00:1a.0: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[    7.971560] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    7.971566] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    7.971776] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    7.971955] ehci_hcd 0000:00:1a.0: debug port 2
[    7.975956] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    7.975978] ehci_hcd 0000:00:1a.0: irq 22, io mem 0xd1e20000
[    7.992779] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    7.993070] hub 1-0:1.0: USB hub found
[    7.993171] hub 1-0:1.0: 2 ports detected
[    7.993635] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    7.993772] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    7.993777] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    7.993958] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    7.994123] ehci_hcd 0000:00:1d.0: debug port 2
[    7.998089] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    7.998115] ehci_hcd 0000:00:1d.0: irq 20, io mem 0xd1e10000
[    8.012778] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    8.013043] hub 2-0:1.0: USB hub found
[    8.013142] hub 2-0:1.0: 2 ports detected
[    8.013464] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    8.013618] uhci_hcd: USB Universal Host Controller Interface driver
[    8.013849] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    8.312596] usb 1-1: new high speed USB device number 2 using ehci_hcd
[    8.462984] hub 1-1:1.0: USB hub found
[    8.463197] hub 1-1:1.0: 6 ports detected
[    8.529399] i8042: Can't read CTR while initializing i8042
[    8.529509] i8042: probe of i8042 failed with error -5
[    8.529741] mousedev: PS/2 mouse device common for all mice
[    8.530008] rtc_cmos 00:06: RTC can wake from S4
[    8.530261] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    8.530406] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    8.530720] device-mapper: uevent: version 1.0.3
[    8.530964] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
[    8.532395] cpuidle: using governor ladder
[    8.534612] cpuidle: using governor menu
[    8.534713] EFI Variables Facility v0.08 2004-May-17
[    8.535230] TCP cubic registered
[    8.535610] NET: Registered protocol family 10
[    8.537046] NET: Registered protocol family 17
[    8.537168] Registering the dns_resolver key type
[    8.537447] PM: Hibernation image not present or could not be loaded.
[    8.537481] registered taskstats version 1
[    8.582447] usb 2-1: new high speed USB device number 2 using ehci_hcd
[    8.641060]   Magic number: 11:797:849
[    8.641222] graphics fbcon: hash matches
[    8.641566] rtc_cmos 00:06: setting system clock to 2011-09-13 19:48:03 UTC (1315943283)
[    8.653367] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    8.653481] EDD information not available.
[    8.655041] Freeing unused kernel memory: 984k freed
[    8.655443] Write protecting the kernel read-only data: 12288k
[    8.660552] Freeing unused kernel memory: 1932k freed
[    8.664638] Freeing unused kernel memory: 1324k freed
[    8.684823] udevd[191]: starting version 173
[    8.692820] md: linear personality registered for level -1
[    8.698249] md: multipath personality registered for level -4
[    8.699606] md: raid0 personality registered for level 0
[    8.701395] md: raid1 personality registered for level 1
[    8.703283] async_tx: api initialized (async)
[    8.723159] isci: Intel(R) C600 SAS Controller Driver
[    8.723332] isci 0000:03:00.0: driver configured for rev: 4 silicon
[    8.723437] isci 0000:03:00.0: OEM parameter table found in OROM
[    8.723535] isci 0000:03:00.0: OEM SAS parameters (version: 1.0) loaded (platform)
[    8.723673] isci 0000:03:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
[    8.724424] dca service started, version 1.12.1
[    8.725467] Intel(R) Gigabit Ethernet Network Driver - version 3.0.6-k
[    8.725567] Copyright (c) 2007-2011 Intel Corporation.
[    8.727747] isci 0000:03:00.0: setting latency timer to 64
[    8.727777] igb 0000:09:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.727891] igb 0000:09:00.0: setting latency timer to 64
[    8.728460] igb 0000:09:00.0: irq 97 for MSI/MSI-X
[    8.728474] igb 0000:09:00.0: irq 98 for MSI/MSI-X
[    8.728489] igb 0000:09:00.0: irq 99 for MSI/MSI-X
[    8.728503] igb 0000:09:00.0: irq 100 for MSI/MSI-X
[    8.728517] igb 0000:09:00.0: irq 101 for MSI/MSI-X
[    8.728532] igb 0000:09:00.0: irq 102 for MSI/MSI-X
[    8.728546] igb 0000:09:00.0: irq 103 for MSI/MSI-X
[    8.728560] igb 0000:09:00.0: irq 104 for MSI/MSI-X
[    8.728575] igb 0000:09:00.0: irq 105 for MSI/MSI-X
[    8.728632] ahci 0000:00:1f.2: version 3.0
[    8.728663] ahci 0000:00:1f.2: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    8.728809] ahci 0000:00:1f.2: irq 106 for MSI/MSI-X
[    8.728870] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3 impl SATA mode
[    8.729001] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
[    8.729133] ahci 0000:00:1f.2: setting latency timer to 64
[    8.731489] scsi0 : isci
[    8.732972] hub 2-1:1.0: USB hub found
[    8.733148] hub 2-1:1.0: 8 ports detected
[    8.734961] scsi1 : isci
[    8.736077] isci 0000:03:00.0: irq 107 for MSI/MSI-X
[    8.736097] isci 0000:03:00.0: irq 108 for MSI/MSI-X
[    8.736115] isci 0000:03:00.0: irq 109 for MSI/MSI-X
[    8.736133] isci 0000:03:00.0: irq 110 for MSI/MSI-X
[    8.743120] scsi2 : ahci
[    8.743332] scsi3 : ahci
[    8.743604] scsi4 : ahci
[    8.743854] scsi5 : ahci
[    8.744126] scsi6 : ahci
[    8.744396] scsi7 : ahci
[    8.744542] ata1: SATA max UDMA/133 abar m2048@0xd1e00000 port 0xd1e00100 irq 106
[    8.744671] ata2: SATA max UDMA/133 abar m2048@0xd1e00000 port 0xd1e00180 irq 106
[    8.744801] ata3: DUMMY
[    8.744886] ata4: DUMMY
[    8.744972] ata5: DUMMY
[    8.745058] ata6: DUMMY
[    8.812376] usb 1-1.4: new low speed USB device number 3 using ehci_hcd
[    8.824936] igb 0000:09:00.0: Intel(R) Gigabit Ethernet Network Connection
[    8.825039] igb 0000:09:00.0: eth0: (PCIe:5.0Gb/s:Width x4) 00:15:17:fe:3a:b6
[    8.825212] igb 0000:09:00.0: eth0: PBA No: 0050FF-0FF
[    8.825306] igb 0000:09:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[    8.825707] igb 0000:09:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    8.825836] igb 0000:09:00.1: setting latency timer to 64
[    8.826438] igb 0000:09:00.1: irq 111 for MSI/MSI-X
[    8.826452] igb 0000:09:00.1: irq 112 for MSI/MSI-X
[    8.826466] igb 0000:09:00.1: irq 113 for MSI/MSI-X
[    8.826480] igb 0000:09:00.1: irq 114 for MSI/MSI-X
[    8.826504] igb 0000:09:00.1: irq 115 for MSI/MSI-X
[    8.826519] igb 0000:09:00.1: irq 116 for MSI/MSI-X
[    8.826533] igb 0000:09:00.1: irq 117 for MSI/MSI-X
[    8.826546] igb 0000:09:00.1: irq 118 for MSI/MSI-X
[    8.826560] igb 0000:09:00.1: irq 119 for MSI/MSI-X
[    8.872220] raid6: int64x1   2305 MB/s
[    8.935036] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    8.935198] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    8.935339] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    8.935480] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    8.935621] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    8.935762] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    8.935903] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    8.936043] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    8.936184] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    8.936325] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    8.936466] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    8.936607] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    8.936747] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    8.936888] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    8.937029] (NULL device *): sci_phy_event_handler:591: PHY starting substate machine received unexpected event_code 33402000
[    8.942794] igb 0000:09:00.1: Intel(R) Gigabit Ethernet Network Connection
[    8.942896] igb 0000:09:00.1: eth1: (PCIe:5.0Gb/s:Width x4) 00:15:17:fe:3a:b7
[    8.943069] igb 0000:09:00.1: eth1: PBA No: 0050FF-0FF
[    8.943163] igb 0000:09:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[    8.943475] igb 0000:09:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    8.943588] igb 0000:09:00.2: setting latency timer to 64
[    8.944138] igb 0000:09:00.2: irq 120 for MSI/MSI-X
[    8.944152] igb 0000:09:00.2: irq 121 for MSI/MSI-X
[    8.944166] igb 0000:09:00.2: irq 122 for MSI/MSI-X
[    8.944179] igb 0000:09:00.2: irq 123 for MSI/MSI-X
[    8.944193] igb 0000:09:00.2: irq 124 for MSI/MSI-X
[    8.944207] igb 0000:09:00.2: irq 125 for MSI/MSI-X
[    8.944221] igb 0000:09:00.2: irq 126 for MSI/MSI-X
[    8.944246] igb 0000:09:00.2: irq 127 for MSI/MSI-X
[    8.944260] igb 0000:09:00.2: irq 128 for MSI/MSI-X
[    8.960129] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    8.993958] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    8.997246] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.012248] usb 2-1.4: new full speed USB device number 3 using ehci_hcd
[    9.025689] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.025849] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.025997] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.037446] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.041528] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.041682] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.042099] raid6: int64x2   2982 MB/s
[    9.052043] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.052197] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.057910] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.065875] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.069640] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.069807] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.072710] igb 0000:09:00.2: Intel(R) Gigabit Ethernet Network Connection
[    9.072813] igb 0000:09:00.2: eth2: (PCIe:5.0Gb/s:Width x4) 00:15:17:fe:3a:b8
[    9.072986] igb 0000:09:00.2: eth2: PBA No: 0050FF-0FF
[    9.073081] igb 0000:09:00.2: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[    9.073442] igb 0000:09:00.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    9.073578] igb 0000:09:00.3: setting latency timer to 64
[    9.074137] igb 0000:09:00.3: irq 129 for MSI/MSI-X
[    9.074152] igb 0000:09:00.3: irq 130 for MSI/MSI-X
[    9.074166] igb 0000:09:00.3: irq 131 for MSI/MSI-X
[    9.074180] igb 0000:09:00.3: irq 132 for MSI/MSI-X
[    9.074194] igb 0000:09:00.3: irq 133 for MSI/MSI-X
[    9.074208] igb 0000:09:00.3: irq 134 for MSI/MSI-X
[    9.074221] igb 0000:09:00.3: irq 135 for MSI/MSI-X
[    9.074235] igb 0000:09:00.3: irq 136 for MSI/MSI-X
[    9.074257] igb 0000:09:00.3: irq 137 for MSI/MSI-X
[    9.088168] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.092097] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    9.092261] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    9.092306] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.094722] ata1.00: ATA-8: WDC WD1002FAEX-00Z3A0, 05.01D05, max UDMA/133
[    9.094842] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    9.094999] ata2.00: ATAPI: ATAPI   iHAS124   B, AL0K, max UDMA/100
[    9.095902] ata2.00: configured for UDMA/100
[    9.097701] ata1.00: configured for UDMA/133
[    9.097842] scsi: waiting for bus probes to complete ...
[    9.101987] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.109519] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.117996] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.124291] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.128060] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.132324] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1002FAEX-0 05.0 PQ: 0 ANSI: 5
[    9.132682] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    9.132725] sd 2:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    9.132787] sd 2:0:0:0: [sda] Write Protect is off
[    9.132790] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    9.132816] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.132859] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.134152] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.134312] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.136908] scsi 3:0:0:0: CD-ROM            ATAPI    iHAS124   B      AL0K PQ: 0 ANSI: 5
[    9.140389] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.140565] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    9.140696] cdrom: Uniform CD-ROM driver Revision: 3.20
[    9.140751] input: CHICONY USB Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input1
[    9.140945] generic-usb 0003:04F2:0112.0001: input,hidraw0: USB HID v1.10 Keyboard [CHICONY USB Keyboard] on usb-0000:00:1a.0-1.4/input0
[    9.141081] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    9.141190] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    9.141459] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.142007] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.144071] input: CHICONY USB Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.1/input/input2
[    9.144532] generic-usb 0003:04F2:0112.0002: input,hidraw1: USB HID v1.10 Mouse [CHICONY USB Keyboard] on usb-0000:00:1a.0-1.4/input1
[    9.145606] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.0/input/input3
[    9.145996] generic-usb 0003:046B:FF10.0003: input,hidraw2: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.0-1.4/input0
[    9.146295] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.146991] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.1/input/input4
[    9.147504] generic-usb 0003:046B:FF10.0004: input,hidraw3: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.0-1.4/input1
[    9.147692] usbcore: registered new interface driver usbhid
[    9.147787] usbhid: USB HID core driver
[    9.153606] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.156912]  sda: sda1 sda2 < sda5 >
[    9.157399] (NULL device *): sci_phy_event_handler:591: PHY starting substate machine received unexpected event_code 33402000
[    9.157786] sd 2:0:0:0: [sda] Attached SCSI disk
[    9.160346] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.160489] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.174783] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.180431] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.188617] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.189816] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.189963] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.193416] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.201606] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.205584] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.209900] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.211987] raid6: int64x4   2530 MB/s
[    9.217434] (NULL device *): sci_phy_event_handler:591: PHY starting substate machine received unexpected event_code 33402000
[    9.217586] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.222638] igb 0000:09:00.3: Intel(R) Gigabit Ethernet Network Connection
[    9.222741] igb 0000:09:00.3: eth3: (PCIe:5.0Gb/s:Width x4) 00:15:17:fe:3a:b9
[    9.222921] igb 0000:09:00.3: eth3: PBA No: 0050FF-0FF
[    9.223016] igb 0000:09:00.3: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[    9.224314] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.236919] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.252410] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.268351] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.268511] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.270045] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.273919] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.274895] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.278156] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.301820] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.337772] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.337933] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.338427] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.345632] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.345798] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.349889] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.352401] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.353599] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.355134] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.355281] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.357967] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.360691] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.360857] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.361569] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.361731] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.362335] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.364948] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.366153] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.372593] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.377613] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.378160] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.380560] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.380726] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.381899] raid6: int64x8   2016 MB/s
[    9.385582] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.416584] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.417561] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.418112] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.424661] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.426953] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.429788] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.429954] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.432413] (NULL device *): sci_phy_event_handler:694: PHY starting substate machine received unexpected event_code 33402000
[    9.432574] (NULL device *): sci_phy_event_handler:694: PHY starting substate machine received unexpected event_code 33402000
[    9.432715] (NULL device *): sci_phy_event_handler:694: PHY starting substate machine received unexpected event_code 33402000
[    9.432856] (NULL device *): sci_phy_event_handler:694: PHY starting substate machine received unexpected event_code 33402000
[    9.432996] (NULL device *): sci_phy_event_handler:694: PHY starting substate machine received unexpected event_code 33402000
[    9.433137] (NULL device *): sci_phy_event_handler:694: PHY starting substate machine received unexpected event_code 33402000
[    9.433278] (NULL device *): sci_phy_event_handler:694: PHY starting substate machine received unexpected event_code 33402000
[    9.433419] (NULL device *): sci_phy_event_handler:694: PHY starting substate machine received unexpected event_code 33402000
[    9.490481] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    9.490641] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    9.490782] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    9.490923] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    9.491071] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    9.491219] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code 33402000
[    9.542548] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.545604] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.550846] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.551771] raid6: sse2x1    6594 MB/s
[    9.554994] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.577695] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.582825] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.582986] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.583127] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.585665] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.587300] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.589489] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.598546] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.598712] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.601778] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.607280] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.611205] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.611371] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.627031] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.635327] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.635493] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.637510] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.639262] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.685652] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.695144] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.697768] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.702573] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.702734] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.710864] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.713815] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.721653] raid6: sse2x2    8039 MB/s
[    9.723967] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.726804] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.726964] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.731065] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.731231] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.731380] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.742850] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.757581] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.757747] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.759218] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.761521] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.763044] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.771116] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.771282] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.774065] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.783894] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.785634] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.789786] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.797860] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.798848] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.811504] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.820024] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code 33402000
[    9.823408] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.829739] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.837594] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.837767] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.837916] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.851217] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.851384] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.853751] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.865537] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.865703] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.883440] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.883601] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.889555] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.889721] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.889869] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.890975] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.891541] raid6: sse2x4    9351 MB/s
[    9.891643] raid6: using algorithm sse2x4 (9351 MB/s)
[    9.893151] xor: automatically using best checksumming function: generic_sse
[    9.898817] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.898978] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.899119] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.901512] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.915206] (NULL device *): sci_phy_event_handler:662: PHY starting substate machine received unexpected event_code b3402000
[    9.932126] (NULL device *): sci_phy_event_handler:694: PHY starting substate machine received unexpected event_code b3402000
[    9.933540] (NULL device *): sci_phy_event_handler:694: PHY starting substate machine received unexpected event_code b3402000
[    9.933701] (NULL device *): sci_phy_event_handler:694: PHY starting substate machine received unexpected event_code b3402000
[    9.933842] (NULL device *): sci_phy_event_handler:694: PHY starting substate machine received unexpected event_code b3402000
[    9.933983] (NULL device *): sci_phy_event_handler:694: PHY starting substate machine received unexpected event_code b3402000
[    9.934123] (NULL device *): sci_phy_event_handler:694: PHY starting substate machine received unexpected event_code b3402000
[    9.934264] (NULL device *): sci_phy_event_handler:694: PHY starting substate machine received unexpected event_code b3402000
[    9.934405] (NULL device *): sci_phy_event_handler:694: PHY starting substate machine received unexpected event_code b3402000
[    9.934547] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code b3402000
[    9.934688] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code b3402000
[    9.934829] (NULL device *): sci_phy_event_handler:735: PHY starting substate machine received unexpected event_code b3402000
[    9.941510]    generic_sse: 11113.200 MB/sec
[    9.941613] xor: using function: generic_sse (11113.200 MB/sec)
[    9.943580] md: raid6 personality registered for level 6
[    9.943683] md: raid5 personality registered for level 5
[    9.943780] md: raid4 personality registered for level 4
[    9.949037] md: raid10 personality registered for level 10
[   10.031603] sas: phy-1:2 added to port-1:0, phy_mask:0x4 (ffffffff00000001)
[   10.031625] sas: DOING DISCOVERY on port 0, pid:536
[   10.034121] sas: Enter sas_scsi_recover_host
[   10.034126] ata7: sas eh calling libata port error handler
[   10.034134] sas: sas_ata_hard_reset: Found ATA device.
[   10.044759] ata7.00: native sectors (1) is smaller than sectors (976773168)
[   10.044863] ata7.00: ATA-8: WDC WD5000AAKX-001CA0, 15.01H15, max UDMA/133
[   10.044963] ata7.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   10.046943] ata7.00: configured for UDMA/133
[   10.047046] sas: --- Exit sas_scsi_recover_host
[   10.047222] scsi 1:0:0:0: Direct-Access     ATA      WDC WD5000AAKX-0 15.0 PQ: 0 ANSI: 5
[   10.047528] sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   10.047579] sd 1:0:0:0: Attached scsi generic sg2 type 0
[   10.047724] sas: DONE DISCOVERY on port 0, pid:536, result:0
[   10.047819] sd 1:0:0:0: [sdb] Write Protect is off
[   10.047917] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   10.047942] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.052833]  sdb: unknown partition table
[   10.053191] sd 1:0:0:0: [sdb] Attached SCSI disk
[   10.054465] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   10.102767] md: bind<sdb>
[   10.551291] sas: phy-1:3 added to port-1:1, phy_mask:0x8 (ffffffff00000002)
[   10.551303] sas: DOING DISCOVERY on port 1, pid:535
[   10.554881] sas: Enter sas_scsi_recover_host
[   10.554885] ata7: sas eh calling libata port error handler
[   10.554898] ata8: sas eh calling libata port error handler
[   10.554902] sas: sas_ata_hard_reset: Found ATA device.
[   10.562687] ata8.00: native sectors (1) is smaller than sectors (976773168)
[   10.562814] ata8.00: ATA-7: WDC WD5000AAJS-00TKA0, 12.01C01, max UDMA/133
[   10.562914] ata8.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   10.564836] ata8.00: configured for UDMA/133
[   10.564963] sas: --- Exit sas_scsi_recover_host
[   10.581275] scsi 1:0:1:0: Direct-Access     ATA      WDC WD5000AAJS-0 12.0 PQ: 0 ANSI: 5
[   10.581635] sd 1:0:1:0: [sdc] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   10.581679] sd 1:0:1:0: Attached scsi generic sg3 type 0
[   10.581910] sas: DONE DISCOVERY on port 1, pid:535, result:0
[   10.581952] sd 1:0:1:0: [sdc] Write Protect is off
[   10.582057] sd 1:0:1:0: [sdc] Mode Sense: 00 3a 00 00
[   10.582086] sd 1:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.589814]  sdc: unknown partition table
[   10.590160] sd 1:0:1:0: [sdc] Attached SCSI disk
[   13.971010] Adding 33530876k swap on /dev/sda5.  Priority:-1 extents:1 across:33530876k 
[   13.985493] udevd[671]: starting version 173
[   14.054028] md: bind<sdc>
[   14.148159] type=1400 audit(1315943288.995:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=804 comm="apparmor_parser"
[   14.148170] type=1400 audit(1315943288.995:3): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=844 comm="apparmor_parser"
[   14.148180] type=1400 audit(1315943288.995:4): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=1208 comm="apparmor_parser"
[   14.148483] type=1400 audit(1315943288.995:5): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=804 comm="apparmor_parser"
[   14.148500] type=1400 audit(1315943288.995:6): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=844 comm="apparmor_parser"
[   14.148510] type=1400 audit(1315943288.995:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1208 comm="apparmor_parser"
[   14.148527] type=1400 audit(1315943288.995:8): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=841 comm="apparmor_parser"
[   14.148537] type=1400 audit(1315943288.995:9): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=814 comm="apparmor_parser"
[   14.148686] type=1400 audit(1315943288.995:10): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=804 comm="apparmor_parser"
[   14.148709] type=1400 audit(1315943288.995:11): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=844 comm="apparmor_parser"
[   14.229199] bio: create slab <bio-1> at 1
[   14.229206] md/raid0:md0: looking at sdc
[   14.229208] md/raid0:md0:   comparing sdc(976771072) with sdc(976771072)
[   14.229210] md/raid0:md0:   END
[   14.229211] md/raid0:md0:   ==> UNIQUE
[   14.229213] md/raid0:md0: 1 zones
[   14.229214] md/raid0:md0: looking at sdb
[   14.229216] md/raid0:md0:   comparing sdb(976771072) with sdc(976771072)
[   14.229217] md/raid0:md0:   EQUAL
[   14.229219] md/raid0:md0: FINAL 1 zones
[   14.229222] md/raid0:md0: done.
[   14.229224] md/raid0:md0: md_size is 1953542144 sectors.
[   14.229226] ******* md0 configuration *********
[   14.229227] zone0=[sdb/sdc/]
[   14.229229]         zone offset=0kb device offset=0kb size=976771072kb
[   14.229231] **********************************
[   14.229231] 
[   14.229241] md0: detected capacity change from 0 to 1000213577728
[   14.240361]  md0: unknown partition table
[   14.249734] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   14.250256] igb: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   14.251267] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   14.509929] lp: driver loaded but no devices found
[   14.732435] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   14.732676] ioatdma 0000:00:04.0: PCI INT A -> GSI 31 (level, low) -> IRQ 31
[   14.732773] ioatdma 0000:00:04.0: setting latency timer to 64
[   14.732983] ioatdma 0000:00:04.0: irq 138 for MSI/MSI-X
[   14.733353] igb 0000:09:00.0: DCA enabled
[   14.733394] igb 0000:09:00.1: DCA enabled
[   14.733519] ioatdma 0000:00:04.1: PCI INT B -> GSI 39 (level, low) -> IRQ 39
[   14.733554] ioatdma 0000:00:04.1: setting latency timer to 64
[   14.733668] ioatdma 0000:00:04.1: irq 139 for MSI/MSI-X
[   14.733896] igb 0000:09:00.2: DCA enabled
[   14.733935] igb 0000:09:00.3: DCA enabled
[   14.734030] ioatdma 0000:00:04.2: PCI INT C -> GSI 31 (level, low) -> IRQ 31
[   14.734061] ioatdma 0000:00:04.2: setting latency timer to 64
[   14.734174] ioatdma 0000:00:04.2: irq 140 for MSI/MSI-X
[   14.734431] ioatdma 0000:00:04.3: PCI INT D -> GSI 39 (level, low) -> IRQ 39
[   14.734463] ioatdma 0000:00:04.3: setting latency timer to 64
[   14.734575] ioatdma 0000:00:04.3: irq 141 for MSI/MSI-X
[   14.734853] ioatdma 0000:00:04.4: PCI INT A -> GSI 31 (level, low) -> IRQ 31
[   14.734878] ioatdma 0000:00:04.4: setting latency timer to 64
[   14.734994] ioatdma 0000:00:04.4: irq 142 for MSI/MSI-X
[   14.735269] ioatdma 0000:00:04.5: PCI INT B -> GSI 39 (level, low) -> IRQ 39
[   14.735320] ioatdma 0000:00:04.5: setting latency timer to 64
[   14.735485] ioatdma 0000:00:04.5: irq 143 for MSI/MSI-X
[   14.735755] ioatdma 0000:00:04.6: PCI INT C -> GSI 31 (level, low) -> IRQ 31
[   14.735806] ioatdma 0000:00:04.6: setting latency timer to 64
[   14.735967] ioatdma 0000:00:04.6: irq 144 for MSI/MSI-X
[   14.736253] ioatdma 0000:00:04.7: PCI INT D -> GSI 39 (level, low) -> IRQ 39
[   14.736304] ioatdma 0000:00:04.7: setting latency timer to 64
[   14.736470] ioatdma 0000:00:04.7: irq 145 for MSI/MSI-X
[   14.736818] ioatdma 0000:80:04.0: PCI INT A -> GSI 55 (level, low) -> IRQ 55
[   14.736893] ioatdma 0000:80:04.0: setting latency timer to 64
[   14.737095] ioatdma 0000:80:04.0: irq 146 for MSI/MSI-X
[   14.737563] ioatdma 0000:80:04.1: PCI INT B -> GSI 63 (level, low) -> IRQ 63
[   14.737591] ioatdma 0000:80:04.1: setting latency timer to 64
[   14.737707] ioatdma 0000:80:04.1: irq 147 for MSI/MSI-X
[   14.738189] ioatdma 0000:80:04.2: PCI INT C -> GSI 55 (level, low) -> IRQ 55
[   14.738244] ioatdma 0000:80:04.2: setting latency timer to 64
[   14.738362] ioatdma 0000:80:04.2: irq 148 for MSI/MSI-X
[   14.738701] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[   14.738785] ioatdma 0000:80:04.3: PCI INT D -> GSI 63 (level, low) -> IRQ 63
[   14.738841] ioatdma 0000:80:04.3: setting latency timer to 64
[   14.738954] ioatdma 0000:80:04.3: irq 149 for MSI/MSI-X
[   14.739381] ioatdma 0000:80:04.4: PCI INT A -> GSI 55 (level, low) -> IRQ 55
[   14.739409] ioatdma 0000:80:04.4: setting latency timer to 64
[   14.739521] ioatdma 0000:80:04.4: irq 150 for MSI/MSI-X
[   14.740059] ioatdma 0000:80:04.5: PCI INT B -> GSI 63 (level, low) -> IRQ 63
[   14.740115] ioatdma 0000:80:04.5: setting latency timer to 64
[   14.740233] ioatdma 0000:80:04.5: irq 151 for MSI/MSI-X
[   14.740714] ioatdma 0000:80:04.6: PCI INT C -> GSI 55 (level, low) -> IRQ 55
[   14.740742] ioatdma 0000:80:04.6: setting latency timer to 64
[   14.740859] ioatdma 0000:80:04.6: irq 152 for MSI/MSI-X
[   14.741235] ioatdma 0000:80:04.7: PCI INT D -> GSI 63 (level, low) -> IRQ 63
[   14.741263] ioatdma 0000:80:04.7: setting latency timer to 64
[   14.741379] ioatdma 0000:80:04.7: irq 153 for MSI/MSI-X
[   14.754349] mei: module is from the staging directory, the quality is unknown, you have been warned.
[   14.755288] mei 0000:00:16.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   14.755293] mei 0000:00:16.0: setting latency timer to 64
[   14.883202] EXT4-fs (md0): mounted filesystem with ordered data mode. Opts: errors=remount-ro
[   16.458509] init: udev-fallback-graphics main process (1685) terminated with status 1
[   16.470654] init: plymouth-splash main process (1693) terminated with status 1
[   24.981771] eth0: no IPv6 routers present

--------------080401070708000908060508--
