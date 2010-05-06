From: "Caspar Smit" <c.smit@truebit.nl>
Subject: RE: Still havind major MVSAS issues.
Date: Thu, 6 May 2010 14:14:22 +0200 (CEST)
Message-ID: <54009.87.210.74.220.1273148062.squirrel@ketsers.dhs.org>
References: <53271.87.210.74.220.1270040583.squirrel@ketsers.dhs.org>   
    <7BF8FE1BFB7440B29ECD3D15FB0A4E8C@usish.com.cn>   
    <1068.77.248.79.78.1270102668.squirrel@ketsers.dhs.org>   
    <CDBC7B5488B245E689B39330542DC434@usish.com.cn>   
    <1543.77.248.79.78.1270108509.squirrel@ketsers.dhs.org>   
    <4BB50A92.3030205@gmx.net> <4BB53983.5050309@cisco.com>   
    <43193.87.210.74.220.1270217681.squirrel@ketsers.dhs.org>   
    <1228.77.248.79.78.1270828327.squirrel@ketsers.dhs.org>   
    <6B62480106F2B34D8404CF2FDAA4D9EF7F36EFEE0C@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20100506141422_58458"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 80-69-81-65.colo.transip.net ([80.69.81.65]:42615 "EHLO
	ns1.emsolutions.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0EFMOa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2010 08:14:30 -0400
In-Reply-To: <6B62480106F2B34D8404CF2FDAA4D9EF7F36EFEE0C@CHN-HCLT-EVS06.HCLT.CORP.H
          CL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.in>
Cc: linux-scsi@vger.kernel.org

------=_20100506141422_58458
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

> Hi Caspar/Jelle,
>
> Please provide me the following details.
>
> 1. Is this is the problem with only WD SATA drives? (I don't have WD
SATA
> drives to reproduce this issue.)

No, I have the same error messages using Seagate 500Gb 2,5" SATA disks
(ST9500420AS) and also with 160Gb 2,5" Intel X-25 SATA SSD's (SSDSA2M160).

> 2. Whether the problem is with direct attached SATA drives or drives
connected in expanders also?

The contoller is connected to a backplane (SuperMicro SAS216A). As fas as
I know there are no expanders involved.

> 3. Could you please provide me the "dmesg" log or "/var/log/messages"
log.

See attachments.

> 4. How much the capacity of SATA drives connected to controller?

See point 1.

> 5. Your HBA is having 6440 chipset?

I have 3x SuperMicro AOC-SASLP-MV8 controllers in one system.

The user guide says it uses the Marvell 88SE6480 chipset.

This is the output of lspci.

#lspci |grep MV

04:00.0 SCSI storage controller: Marvell Technology Group Ltd.
MV64460/64461/64462 System Controller, Revision B (rev 01)
0c:00.0 SCSI storage controller: Marvell Technology Group Ltd.
MV64460/64461/64462 System Controller, Revision B (rev 01)
0e:00.0 SCSI storage controller: Marvell Technology Group Ltd.
MV64460/64461/64462 System Controller, Revision B (rev 01)

If you need anymore info, please let me know.

Thanks for all your efforts.

Kind regards,
Caspar Smit

>
> --Srini.
>
> -----Original Message-----
> From: Caspar Smit [mailto:c.smit@truebit.nl]
> Sent: Friday, April 09, 2010 9:22 PM
> To: Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech
> Cc: linux-scsi@vger.kernel.org
> Subject: Still havind major MVSAS issues.
>
> Hi Srinivas (and others),
>
> I'm still having troubles with SATA disks using the mvsas driver. Maybe
you read my previous posts about the WD disks.
>
> The problem is easyly recreated:
>
> 1) Create a software raidset (i used a 5 disk raid6 as a test)
>
> 2) Create an XFS filesystem on it. (mkfs.xfs -f /dev/md0)
>
> I used the 2.6.32 kernel source using your patch.
> I get these messages:
>
> [ 5855.816019] drivers/scsi/mvsas/mv_sas.c 1631:mvs_query_task:rc= 5 [
5857.820002] mvsas 0000:04:00.0: Phy7 : No sig fis
> [ 5858.024006] drivers/scsi/mvsas/mv_sas.c 1585:mvs_I_T_nexus_reset for
device[4]:rc= 0
> [ 5858.024014] ata12: translated ATA stat/err 0x01/04 to SCSI
SK/ASC/ASCQ
> 0xb/00/00
> [ 5858.028001] ata12.00: device reported invalid CHS sector 0
> [ 5858.028001] ata12: status=0x01 { Error }
> [ 5858.028001] ata12: error=0x04 { DriveStatusError }
> [ 7201.988017] ata18: translated ATA stat/err 0x01/04 to SCSI
SK/ASC/ASCQ
> 0xb/00/00
> [ 7201.988114] ata18: status=0x01 { Error }
> [ 7201.988276] ata18: error=0x04 { DriveStatusError }
>
> Especially the latest 3 messages I got loads more of those on another
set
> of disks. The creation of an XFS filesystem can take up to 15 minutes in
stead of the normal 15 seconds!
>
> When I use the stock 2.6.32 kernel driver without your patch i get these
errors:
>
> [ 6384.816015]
> /tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c
1669:mvs_abort_task:rc= 5
> [ 6384.816020]
> /tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c
1608:mvs_query_task:rc= 5
> [ 6415.804016]
> /tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c
1669:mvs_abort_task:rc= 5
> [ 6415.804021]
> /tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c
1608:mvs_query_task:rc= 5
> [ 6445.816017]
> /tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c
1669:mvs_abort_task:rc= 5
> [ 6445.816022]
> /tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c
1608:mvs_query_task:rc= 5
> [ 6476.804015]
> /tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c
1669:mvs_abort_task:rc= 5
> [ 6476.804020]
> /tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c
1608:mvs_query_task:rc= 5
>
> So there has definatly changed something with the patch.
>
> Further more during the detection of disks during boot I get these
messages for almost any SATA disk:
>
> Mar 31 14:34:17 test ata_id[3752]: main: HDIO_GET_IDENTITY failed for
'/dev/.tmp-8-112'
> Mar 31 14:34:17 test ata_id[3765]: main: HDIO_GET_IDENTITY failed for
'/dev/.tmp-8-128'
>
> If you need more info let me know.
>
> Kind regards,
> Caspar Smit
>
> DISCLAIMER:
> -----------------------------------------------------------------------------------------------------------------------
>
> The contents of this e-mail and any attachment(s) are confidential and
intended for the named recipient(s) only.
> It shall not attach any liability on the originator or HCL or its
affiliates. Any views or opinions presented in
> this email are solely those of the author and may not necessarily
reflect
> the opinions of HCL or its affiliates.
> Any form of reproduction, dissemination, copying, disclosure,
> modification, distribution and / or publication of
> this message without the prior written consent of the author of this
e-mail is strictly prohibited. If you have
> received this email in error please delete it and notify the sender
immediately. Before opening any mail and
> attachments please check them for viruses and defect.
>
> -----------------------------------------------------------------------------------------------------------------------
--
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


------=_20100506141422_58458
Content-Type: text/plain; name="dmesg.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32-bpo.4-amd64 (Debian 2.6.32-11~bpo50+1) (norbert@tretkowski.de) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Thu Apr 8 10:20:24 UTC 2010
[    0.000000] Command line: root=/dev/sda1 ro elevator=deadline edd=off 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009b800 (usable)
[    0.000000]  BIOS-e820: 000000000009b800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff50000 (usable)
[    0.000000]  BIOS-e820: 00000000cff50000 - 00000000cff61000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cff61000 - 00000000cff62000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cff62000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] DMI present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E3FFF uncachable
[    0.000000]   E4000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00D0000000 mask 3FF0000000 uncachable
[    0.000000]   1 base 00E0000000 mask 3FE0000000 uncachable
[    0.000000]   2 base 0000000000 mask 3F00000000 write-back
[    0.000000]   3 base 0100000000 mask 3FE0000000 write-back
[    0.000000]   4 base 0120000000 mask 3FF0000000 write-back
[    0.000000]   5 base 00CFF80000 mask 3FFFF80000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000cff80000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcff50 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000cff50000
[    0.000000]  0000000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cff50000 page 4k
[    0.000000] kernel direct mapping tables up to cff50000 @ 10000-16000
[    0.000000] init_memory_mapping: 0000000100000000-0000000130000000
[    0.000000]  0100000000 - 0130000000 page 2M
[    0.000000] kernel direct mapping tables up to 130000000 @ 14000-1a000
[    0.000000] RAMDISK: 37d40000 - 37fefbd0
[    0.000000] ACPI: RSDP 00000000000f6d60 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 00000000cff59bce 000D4 (v01 PTLTD  ? XSDT   06040000  LTP 00000000)
[    0.000000] ACPI: FACP 00000000cff60300 000F4 (v03 INTEL  STOAKLEY 06040000 PTL  00000003)
[    0.000000] ACPI: DSDT 00000000cff5b790 04AFC (v01  Intel SEABURG  06040000 MSFT 03000001)
[    0.000000] ACPI: FACS 00000000cff61fc0 00040
[    0.000000] ACPI: DMAR 00000000cff603f4 00110 (v01 Intel  OEMDMAR  06040000 LOHR 00000001)
[    0.000000] ACPI: TCPA 00000000cff60504 00032 (v01 Intel  STOAKLEY 06040000 LOHR 0000005A)
[    0.000000] ACPI: APIC 00000000cff60536 00090 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: MCFG 00000000cff605c6 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: HPET 00000000cff60602 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
[    0.000000] ACPI: BOOT 00000000cff6063a 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SPCR 00000000cff60662 00050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
[    0.000000] ACPI: ERST 00000000cff606b2 00590 (v01 SMCI   ERSTTBL  06040000 SMCI 00000001)
[    0.000000] ACPI: HEST 00000000cff60c42 000A8 (v01 SMCI   HESTTBL  06040000 SMCI 00000001)
[    0.000000] ACPI: BERT 00000000cff60cea 00030 (v01 SMCI   BERTTBL  06040000 SMCI 00000001)
[    0.000000] ACPI: EINJ 00000000cff60d1a 00170 (v01 SMCI   EINJTBL  06040000 SMCI 00000001)
[    0.000000] ACPI: SLIC 00000000cff60e8a 00176 (v01 OEM_ID OEMTABLE 06040000  LTP 00000000)
[    0.000000] ACPI: SSDT 00000000cff5b531 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff5b48b 000A6 (v01  PmRef  Cpu7Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff5b3e5 000A6 (v01  PmRef  Cpu6Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff5b33f 000A6 (v01  PmRef  Cpu5Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff5b299 000A6 (v01  PmRef  Cpu4Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff5b1f3 000A6 (v01  PmRef  Cpu3Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff5b14d 000A6 (v01  PmRef  Cpu2Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff5b0a7 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000cff59ca2 01405 (v01  PmRef    CpuPm 00003000 INTL 20050228)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000130000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000130000000
[    0.000000]   NODE_DATA [0000000000015000 - 000000000001cfff]
[    0.000000]   bootmap [000000000001d000 -  0000000000042fff] pages 26
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0130000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 000166ea94]    TEXT DATA BSS ==> [0001000000 - 000166ea94]
[    0.000000]   #3 [0037d40000 - 0037fefbd0]          RAMDISK ==> [0037d40000 - 0037fefbd0]
[    0.000000]   #4 [000009b800 - 0000100000]    BIOS reserved ==> [000009b800 - 0000100000]
[    0.000000]   #5 [000166f000 - 000166f1ac]              BRK ==> [000166f000 - 000166f1ac]
[    0.000000]   #6 [0000010000 - 0000014000]          PGTABLE ==> [0000010000 - 0000014000]
[    0.000000]   #7 [0000014000 - 0000015000]          PGTABLE ==> [0000014000 - 0000015000]
[    0.000000] found SMP MP-table at [ffff8800000f6d90] f6d90
[    0.000000]  [ffffea0000000000-ffffea00043fffff] PMD -> [ffff880001800000-ffff8800051fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00130000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009b
[    0.000000]     0: 0x00000100 -> 0x000cff50
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 1048283
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 108 pages reserved
[    0.000000]   DMA zone: 3815 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833416 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfec89000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 5, version 32, address 0xfec89000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 48
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cff50000 - 00000000cff61000
[    0.000000] PM: Registered nosave memory: 00000000cff61000 - 00000000cff62000
[    0.000000] PM: Registered nosave memory: 00000000cff62000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:10000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880005400000 s89880 r8192 d20712 u524288
[    0.000000] pcpu-alloc: s89880 r8192 d20712 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1031151
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sda1 ro elevator=deadline edd=off 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff88000559d000 - ffff88000959d000
[    0.000000] software IO TLB at phys 0x559d000 - 0x959d000
[    0.000000] Memory: 4057552k/4980736k available (3032k kernel code, 787604k absent, 135580k reserved, 1854k data, 580k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:848
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2000.178 MHz processor.
[    0.004006] Calibrating delay loop (skipped), value calculated using timer frequency.. 4000.35 BogoMIPS (lpj=8000712)
[    0.004162] Security Framework initialized
[    0.004235] SELinux:  Disabled at boot.
[    0.004637] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.009638] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.010711] Mount-cache hash table entries: 256
[    0.010942] Initializing cgroup subsys ns
[    0.011010] Initializing cgroup subsys cpuacct
[    0.011080] Initializing cgroup subsys devices
[    0.011148] Initializing cgroup subsys freezer
[    0.011216] Initializing cgroup subsys net_cls
[    0.011310] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.011423] CPU: L2 cache: 6144K
[    0.011490] CPU 0/0x0 -> Node 0
[    0.011555] CPU: Physical Processor ID: 0
[    0.011622] CPU: Processor Core ID: 0
[    0.011690] mce: CPU supports 6 MCE banks
[    0.011762] CPU0: Thermal monitoring enabled (TM2)
[    0.011833] using mwait in idle threads.
[    0.012007] Performance Events: Core2 events, Intel PMU driver.
[    0.012170] ... version:                2
[    0.012237] ... bit width:              40
[    0.012303] ... generic registers:      2
[    0.012370] ... value mask:             000000ffffffffff
[    0.012439] ... max period:             000000007fffffff
[    0.012508] ... fixed-purpose events:   3
[    0.012574] ... event mask:             0000000700000003
[    0.016025] ACPI: Core revision 20090903
[    0.027400] DMAR: Host address width 38
[    0.027469] DMAR: DRHD base: 0x000000fe710000 flags: 0x0
[    0.027544] IOMMU fe710000: ver 1:0 cap 900800c2f0462 ecap e01
[    0.027616] DMAR: DRHD base: 0x000000fe712000 flags: 0x0
[    0.027695] IOMMU fe712000: ver 1:0 cap 900800c2f0462 ecap e01
[    0.027766] DMAR: DRHD base: 0x000000fe714000 flags: 0x0
[    0.027840] IOMMU fe714000: ver 1:0 cap 900800c2f0462 ecap e01
[    0.027912] DMAR: DRHD base: 0x000000fe716000 flags: 0x0
[    0.027985] IOMMU fe716000: ver 1:0 cap 900800c2f0462 ecap e01
[    0.028005] DMAR: DRHD base: 0x000000fe719000 flags: 0x0
[    0.028080] IOMMU fe719000: ver 1:0 cap 900800c2f0462 ecap e01
[    0.028151] DMAR: DRHD base: 0x000000fe71a000 flags: 0x0
[    0.028228] IOMMU fe71a000: ver 1:0 cap 4900800c2f0462 ecap e01
[    0.028300] DMAR: DRHD base: 0x000000fe718000 flags: 0x1
[    0.028374] IOMMU fe718000: ver 1:0 cap 900800c2f0462 ecap e01
[    0.028445] DMAR: RMRR base: 0x000000cff6b000 end: 0x000000cff72fff
[    0.028517] DMAR: No ATSR found
[    0.028590] Setting APIC routing to flat
[    0.029038] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.068868] CPU0: Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz stepping 0a
[    0.072001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.008000] Initializing CPU#1
[    0.008000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.008000] CPU: L2 cache: 6144K
[    0.008000] CPU 1/0x1 -> Node 0
[    0.008000] CPU: Physical Processor ID: 0
[    0.008000] CPU: Processor Core ID: 1
[    0.008000] CPU1: Thermal monitoring enabled (TM2)
[    0.156101] CPU1: Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz stepping 0a
[    0.156725] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.160123] Booting processor 2 APIC 0x2 ip 0x6000
[    0.008000] Initializing CPU#2
[    0.008000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.008000] CPU: L2 cache: 6144K
[    0.008000] CPU 2/0x2 -> Node 0
[    0.008000] CPU: Physical Processor ID: 0
[    0.008000] CPU: Processor Core ID: 2
[    0.008000] CPU2: Thermal monitoring enabled (TM2)
[    0.248103] CPU2: Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz stepping 0a
[    0.248726] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.252078] Booting processor 3 APIC 0x3 ip 0x6000
[    0.008000] Initializing CPU#3
[    0.008000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.008000] CPU: L2 cache: 6144K
[    0.008000] CPU 3/0x3 -> Node 0
[    0.008000] CPU: Physical Processor ID: 0
[    0.008000] CPU: Processor Core ID: 3
[    0.008000] CPU3: Thermal monitoring enabled (TM2)
[    0.340057] CPU3: Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz stepping 0a
[    0.340680] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.344014] Brought up 4 CPUs
[    0.344081] Total of 4 processors activated (16000.79 BogoMIPS).
[    0.348022] CPU0 attaching sched-domain:
[    0.348026]  domain 0: span 0-1 level MC
[    0.348029]   groups: 0 1
[    0.348033]   domain 1: span 0-3 level CPU
[    0.348036]    groups: 0-1 (cpu_power = 2048) 2-3 (cpu_power = 2048)
[    0.348044] CPU1 attaching sched-domain:
[    0.348046]  domain 0: span 0-1 level MC
[    0.348048]   groups: 1 0
[    0.348052]   domain 1: span 0-3 level CPU
[    0.348054]    groups: 0-1 (cpu_power = 2048) 2-3 (cpu_power = 2048)
[    0.348060] CPU2 attaching sched-domain:
[    0.348062]  domain 0: span 2-3 level MC
[    0.348064]   groups: 2 3
[    0.348067]   domain 1: span 0-3 level CPU
[    0.348069]    groups: 2-3 (cpu_power = 2048) 0-1 (cpu_power = 2048)
[    0.348075] CPU3 attaching sched-domain:
[    0.348077]  domain 0: span 2-3 level MC
[    0.348079]   groups: 3 2
[    0.348083]   domain 1: span 0-3 level CPU
[    0.348085]    groups: 2-3 (cpu_power = 2048) 0-1 (cpu_power = 2048)
[    0.348260] devtmpfs: initialized
[    0.352140] regulator: core version 0.5
[    0.352147] NET: Registered protocol family 16
[    0.352317] ACPI: bus type pci registered
[    0.352468] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 16
[    0.352541] PCI: MCFG area at e0000000 reserved in E820
[    0.353429] PCI: Using MMCONFIG at e0000000 - e10fffff
[    0.353498] PCI: Using configuration type 1 for base access
[    0.353960] bio: create slab <bio-0> at 0
[    0.353960] ACPI: EC: Look up EC in DSDT
[    0.356088] ACPI Warning for \_SB_._OSC: Return type mismatch - found Integer, expected Buffer (20090903/nspredef-1006)
[    0.356277] \_SB_:_OSC evaluation returned wrong type
[    0.356278] _OSC request data:1 7 
[    0.358158] ACPI: Interpreter enabled
[    0.358227] ACPI: (supports S0 S1 S4 S5)
[    0.358489] ACPI: Using IOAPIC for interrupt routing
[    0.362674] ACPI: No dock devices found.
[    0.363721] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.363863] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.363936] pci 0000:00:00.0: PME# disabled
[    0.364051] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.364123] pci 0000:00:01.0: PME# disabled
[    0.364240] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.364312] pci 0000:00:03.0: PME# disabled
[    0.364427] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.364499] pci 0000:00:05.0: PME# disabled
[    0.364613] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.364685] pci 0000:00:07.0: PME# disabled
[    0.364800] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.364872] pci 0000:00:09.0: PME# disabled
[    0.364968] pci 0000:00:0f.0: reg 10 64bit mmio: [0xfe700000-0xfe703fff]
[    0.365274] pci 0000:00:1d.0: reg 20 io port: [0x1800-0x181f]
[    0.365322] pci 0000:00:1d.1: reg 20 io port: [0x1820-0x183f]
[    0.365369] pci 0000:00:1d.2: reg 20 io port: [0x1840-0x185f]
[    0.365415] pci 0000:00:1d.3: reg 20 io port: [0x1860-0x187f]
[    0.365467] pci 0000:00:1d.7: reg 10 32bit mmio: [0xd8b04000-0xd8b043ff]
[    0.365515] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.365589] pci 0000:00:1d.7: PME# disabled
[    0.365785] pci 0000:00:1f.2: reg 10 io port: [0x18a0-0x18a7]
[    0.365790] pci 0000:00:1f.2: reg 14 io port: [0x1894-0x1897]
[    0.365796] pci 0000:00:1f.2: reg 18 io port: [0x1898-0x189f]
[    0.365802] pci 0000:00:1f.2: reg 1c io port: [0x1890-0x1893]
[    0.365807] pci 0000:00:1f.2: reg 20 io port: [0x1880-0x188f]
[    0.365813] pci 0000:00:1f.2: reg 24 32bit mmio: [0xd8b04400-0xd8b047ff]
[    0.365832] pci 0000:00:1f.2: PME# supported from D3hot
[    0.365903] pci 0000:00:1f.2: PME# disabled
[    0.366012] pci 0000:00:1f.3: reg 20 io port: [0x1100-0x111f]
[    0.366126] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.366198] pci 0000:02:00.0: PME# disabled
[    0.366314] pci 0000:02:00.3: PME# supported from D0 D3hot D3cold
[    0.366386] pci 0000:02:00.3: PME# disabled
[    0.366469] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.366610] pci 0000:00:03.0: bridge io port: [0x2000-0x2fff]
[    0.366613] pci 0000:00:03.0: bridge 32bit mmio: [0xd8500000-0xd86fffff]
[    0.366666] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.366739] pci 0000:03:00.0: PME# disabled
[    0.366819] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.366939] pci 0000:02:00.0: bridge io port: [0x2000-0x2fff]
[    0.366943] pci 0000:02:00.0: bridge 32bit mmio: [0xd8600000-0xd86fffff]
[    0.366992] pci 0000:04:00.0: reg 18 io port: [0x2000-0x207f]
[    0.367009] pci 0000:04:00.0: reg 20 64bit mmio: [0xd8600000-0xd860ffff]
[    0.367016] pci 0000:04:00.0: reg 30 32bit mmio pref: [0x000000-0x03ffff]
[    0.367045] pci 0000:04:00.0: supports D1
[    0.367047] pci 0000:04:00.0: PME# supported from D0 D1 D3hot
[    0.367120] pci 0000:04:00.0: PME# disabled
[    0.367208] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.367352] pci 0000:03:00.0: bridge io port: [0x2000-0x2fff]
[    0.367356] pci 0000:03:00.0: bridge 32bit mmio: [0xd8600000-0xd86fffff]
[    0.367463] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.367537] pci 0000:06:00.0: PME# disabled
[    0.367617] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.367753] pci 0000:00:05.0: bridge io port: [0x3000-0x4fff]
[    0.367756] pci 0000:00:05.0: bridge 32bit mmio: [0xd8000000-0xd81fffff]
[    0.367812] pci 0000:07:00.0: PME# supported from D0 D3hot D3cold
[    0.367886] pci 0000:07:00.0: PME# disabled
[    0.367968] pci 0000:07:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.368050] pci 0000:07:01.0: PME# supported from D0 D3hot D3cold
[    0.368124] pci 0000:07:01.0: PME# disabled
[    0.368205] pci 0000:07:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.368332] pci 0000:06:00.0: bridge io port: [0x3000-0x4fff]
[    0.368337] pci 0000:06:00.0: bridge 32bit mmio: [0xd8000000-0xd81fffff]
[    0.368386] pci 0000:08:00.0: reg 10 32bit mmio: [0xd8020000-0xd803ffff]
[    0.368394] pci 0000:08:00.0: reg 14 32bit mmio: [0xd8000000-0xd801ffff]
[    0.368402] pci 0000:08:00.0: reg 18 io port: [0x3000-0x301f]
[    0.368426] pci 0000:08:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
[    0.368458] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    0.368532] pci 0000:08:00.0: PME# disabled
[    0.368654] pci 0000:08:00.1: reg 10 32bit mmio: [0xd8060000-0xd807ffff]
[    0.368662] pci 0000:08:00.1: reg 14 32bit mmio: [0xd8040000-0xd805ffff]
[    0.368669] pci 0000:08:00.1: reg 18 io port: [0x3020-0x303f]
[    0.368694] pci 0000:08:00.1: reg 30 32bit mmio pref: [0x000000-0x01ffff]
[    0.368726] pci 0000:08:00.1: PME# supported from D0 D3hot D3cold
[    0.368800] pci 0000:08:00.1: PME# disabled
[    0.368900] pci 0000:08:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.369068] pci 0000:07:00.0: bridge io port: [0x3000-0x3fff]
[    0.369074] pci 0000:07:00.0: bridge 32bit mmio: [0xd8000000-0xd80fffff]
[    0.369124] pci 0000:09:00.0: reg 10 32bit mmio: [0xd8120000-0xd813ffff]
[    0.369132] pci 0000:09:00.0: reg 14 32bit mmio: [0xd8100000-0xd811ffff]
[    0.369140] pci 0000:09:00.0: reg 18 io port: [0x4000-0x401f]
[    0.369164] pci 0000:09:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
[    0.369196] pci 0000:09:00.0: PME# supported from D0 D3hot
[    0.369269] pci 0000:09:00.0: PME# disabled
[    0.369388] pci 0000:09:00.1: reg 10 32bit mmio: [0xd8160000-0xd817ffff]
[    0.369396] pci 0000:09:00.1: reg 14 32bit mmio: [0xd8140000-0xd815ffff]
[    0.369404] pci 0000:09:00.1: reg 18 io port: [0x4020-0x403f]
[    0.369428] pci 0000:09:00.1: reg 30 32bit mmio pref: [0x000000-0x01ffff]
[    0.369461] pci 0000:09:00.1: PME# supported from D0 D3hot
[    0.369534] pci 0000:09:00.1: PME# disabled
[    0.369634] pci 0000:09:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.369802] pci 0000:07:01.0: bridge io port: [0x4000-0x4fff]
[    0.369807] pci 0000:07:01.0: bridge 32bit mmio: [0xd8100000-0xd81fffff]
[    0.369858] pci 0000:0a:00.0: reg 10 32bit mmio: [0xd8200000-0xd821ffff]
[    0.369892] pci 0000:0a:00.0: PME# supported from D0 D3hot D3cold
[    0.369965] pci 0000:0a:00.0: PME# disabled
[    0.376058] pci 0000:00:07.0: bridge io port: [0x5000-0x6fff]
[    0.376061] pci 0000:00:07.0: bridge 32bit mmio: [0xd8200000-0xd84fffff]
[    0.376127] pci 0000:0b:01.0: PME# supported from D0 D3hot D3cold
[    0.376199] pci 0000:0b:01.0: PME# disabled
[    0.376347] pci 0000:0b:08.0: PME# supported from D0 D3hot D3cold
[    0.376419] pci 0000:0b:08.0: PME# disabled
[    0.376567] pci 0000:0b:09.0: PME# supported from D0 D3hot D3cold
[    0.376640] pci 0000:0b:09.0: PME# disabled
[    0.376763] pci 0000:0a:00.0: bridge io port: [0x5000-0x6fff]
[    0.376767] pci 0000:0a:00.0: bridge 32bit mmio: [0xd8300000-0xd84fffff]
[    0.376819] pci 0000:0c:00.0: reg 18 io port: [0x5000-0x507f]
[    0.376835] pci 0000:0c:00.0: reg 20 64bit mmio: [0xd8300000-0xd830ffff]
[    0.376843] pci 0000:0c:00.0: reg 30 32bit mmio pref: [0x000000-0x03ffff]
[    0.376871] pci 0000:0c:00.0: supports D1
[    0.376873] pci 0000:0c:00.0: PME# supported from D0 D1 D3hot
[    0.376945] pci 0000:0c:00.0: PME# disabled
[    0.377034] pci 0000:0c:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.377189] pci 0000:0b:01.0: bridge io port: [0x5000-0x5fff]
[    0.377193] pci 0000:0b:01.0: bridge 32bit mmio: [0xd8300000-0xd83fffff]
[    0.377296] pci 0000:0e:00.0: reg 18 io port: [0x6000-0x607f]
[    0.377313] pci 0000:0e:00.0: reg 20 64bit mmio: [0xd8400000-0xd840ffff]
[    0.377320] pci 0000:0e:00.0: reg 30 32bit mmio pref: [0x000000-0x03ffff]
[    0.377349] pci 0000:0e:00.0: supports D1
[    0.377350] pci 0000:0e:00.0: PME# supported from D0 D1 D3hot
[    0.377423] pci 0000:0e:00.0: PME# disabled
[    0.377512] pci 0000:0e:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.377670] pci 0000:0b:09.0: bridge io port: [0x6000-0x6fff]
[    0.377674] pci 0000:0b:09.0: bridge 32bit mmio: [0xd8400000-0xd84fffff]
[    0.377732] pci 0000:0f:00.0: reg 10 32bit mmio: [0xd8740000-0xd875ffff]
[    0.377739] pci 0000:0f:00.0: reg 14 32bit mmio: [0xd8720000-0xd873ffff]
[    0.377746] pci 0000:0f:00.0: reg 18 io port: [0x7000-0x701f]
[    0.377752] pci 0000:0f:00.0: reg 1c 32bit mmio: [0xd8700000-0xd8703fff]
[    0.377767] pci 0000:0f:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
[    0.377796] pci 0000:0f:00.0: PME# supported from D0 D3hot D3cold
[    0.377869] pci 0000:0f:00.0: PME# disabled
[    0.377982] pci 0000:0f:00.1: reg 10 32bit mmio: [0xd8780000-0xd879ffff]
[    0.377989] pci 0000:0f:00.1: reg 14 32bit mmio: [0xd8760000-0xd877ffff]
[    0.377995] pci 0000:0f:00.1: reg 18 io port: [0x7020-0x703f]
[    0.378002] pci 0000:0f:00.1: reg 1c 32bit mmio: [0xd8704000-0xd8707fff]
[    0.378016] pci 0000:0f:00.1: reg 30 32bit mmio pref: [0x000000-0x01ffff]
[    0.378045] pci 0000:0f:00.1: PME# supported from D0 D3hot D3cold
[    0.378118] pci 0000:0f:00.1: PME# disabled
[    0.384084] pci 0000:00:09.0: bridge io port: [0x7000-0x7fff]
[    0.384087] pci 0000:00:09.0: bridge 32bit mmio: [0xd8700000-0xd87fffff]
[    0.384130] pci 0000:10:01.0: reg 10 32bit mmio pref: [0xd0000000-0xd7ffffff]
[    0.384137] pci 0000:10:01.0: reg 14 io port: [0x8000-0x80ff]
[    0.384144] pci 0000:10:01.0: reg 18 32bit mmio: [0xd8800000-0xd880ffff]
[    0.384165] pci 0000:10:01.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
[    0.384185] pci 0000:10:01.0: supports D1 D2
[    0.384235] pci 0000:00:1e.0: transparent bridge
[    0.384305] pci 0000:00:1e.0: bridge io port: [0x8000-0x8fff]
[    0.384309] pci 0000:00:1e.0: bridge 32bit mmio: [0xd8800000-0xd88fffff]
[    0.384315] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xd0000000-0xd7ffffff]
[    0.384336] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.384533] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.384602] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.384645] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3.BMF0._PRT]
[    0.384698] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3.BMF0.BPD0._PRT]
[    0.384775] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.384838] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
[    0.384901] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.384964] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.394280] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 14 15) *12
[    0.394982] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 *4 5 6 7 10 11 14 15)
[    0.395636] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.396281] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.397042] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.397695] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 *5 6 7 10 11 14 15)
[    0.398303] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 11 14 15)
[    0.398957] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 10 11 14 15) *3
[    0.399642] vgaarb: device added: PCI:0000:10:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.399731] vgaarb: loaded
[    0.399822] PCI: Using ACPI for IRQ routing
[    0.400192] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.400445] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.412006] Switching to clocksource tsc
[    0.413433] pnp: PnP ACPI init
[    0.413526] ACPI: bus type pnp registered
[    0.416321] pnp: PnP ACPI: found 10 devices
[    0.416389] ACPI: ACPI bus type pnp unregistered
[    0.416470] system 00:01: ioport range 0x295-0x296 has been reserved
[    0.416542] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.416614] system 00:01: ioport range 0x800-0x80f has been reserved
[    0.416687] system 00:01: ioport range 0xca0-0xca1 has been reserved
[    0.416759] system 00:01: ioport range 0x1000-0x107f has been reserved
[    0.416832] system 00:01: ioport range 0x1180-0x11bf has been reserved
[    0.416905] system 00:01: ioport range 0xfe00-0xfe00 has been reserved
[    0.416979] system 00:01: iomem range 0xe0000000-0xefffffff has been reserved
[    0.423412] system 00:01: iomem range 0xfee00000-0xfee0ffff could not be reserved
[    0.423501] system 00:01: iomem range 0xfec89000-0xfec89fff could not be reserved
[    0.423589] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.423663] system 00:01: iomem range 0xfe000000-0xfe01ffff has been reserved
[    0.423737] system 00:01: iomem range 0xfe600000-0xfe6fffff has been reserved
[    0.423811] system 00:01: iomem range 0xfed20000-0xfed44fff has been reserved
[    0.423894] system 00:01: iomem range 0xfed45000-0xfed8ffff has been reserved
[    0.428842] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.428913] pci 0000:00:01.0:   IO window: disabled
[    0.428984] pci 0000:00:01.0:   MEM window: disabled
[    0.429053] pci 0000:00:01.0:   PREFETCH window: disabled
[    0.429127] pci 0000:03:00.0: PCI bridge, secondary bus 0000:04
[    0.429199] pci 0000:03:00.0:   IO window: 0x2000-0x2fff
[    0.429272] pci 0000:03:00.0:   MEM window: 0xd8600000-0xd86fffff
[    0.429345] pci 0000:03:00.0:   PREFETCH window: 0xd8900000-0xd89fffff
[    0.429420] pci 0000:02:00.0: PCI bridge, secondary bus 0000:03
[    0.429492] pci 0000:02:00.0:   IO window: 0x2000-0x2fff
[    0.429564] pci 0000:02:00.0:   MEM window: 0xd8600000-0xd86fffff
[    0.429637] pci 0000:02:00.0:   PREFETCH window: 0xd8900000-0xd89fffff
[    0.429712] pci 0000:02:00.3: PCI bridge, secondary bus 0000:05
[    0.429782] pci 0000:02:00.3:   IO window: disabled
[    0.429853] pci 0000:02:00.3:   MEM window: disabled
[    0.429923] pci 0000:02:00.3:   PREFETCH window: disabled
[    0.429996] pci 0000:00:03.0: PCI bridge, secondary bus 0000:02
[    0.430068] pci 0000:00:03.0:   IO window: 0x2000-0x2fff
[    0.430139] pci 0000:00:03.0:   MEM window: 0xd8500000-0xd86fffff
[    0.430211] pci 0000:00:03.0:   PREFETCH window: 0xd8900000-0xd89fffff
[    0.430288] pci 0000:07:00.0: PCI bridge, secondary bus 0000:08
[    0.430360] pci 0000:07:00.0:   IO window: 0x3000-0x3fff
[    0.430434] pci 0000:07:00.0:   MEM window: 0xd8000000-0xd80fffff
[    0.430508] pci 0000:07:00.0:   PREFETCH window: 0xd8c00000-0xd8cfffff
[    0.430586] pci 0000:07:01.0: PCI bridge, secondary bus 0000:09
[    0.430657] pci 0000:07:01.0:   IO window: 0x4000-0x4fff
[    0.430731] pci 0000:07:01.0:   MEM window: 0xd8100000-0xd81fffff
[    0.430805] pci 0000:07:01.0:   PREFETCH window: 0xd8d00000-0xd8dfffff
[    0.430882] pci 0000:06:00.0: PCI bridge, secondary bus 0000:07
[    0.430954] pci 0000:06:00.0:   IO window: 0x3000-0x4fff
[    0.431028] pci 0000:06:00.0:   MEM window: 0xd8000000-0xd81fffff
[    0.431102] pci 0000:06:00.0:   PREFETCH window: 0xd8c00000-0xd8dfffff
[    0.431179] pci 0000:00:05.0: PCI bridge, secondary bus 0000:06
[    0.431250] pci 0000:00:05.0:   IO window: 0x3000-0x4fff
[    0.431322] pci 0000:00:05.0:   MEM window: 0xd8000000-0xd81fffff
[    0.431394] pci 0000:00:05.0:   PREFETCH window: 0xd8c00000-0xd8dfffff
[    0.431472] pci 0000:0b:08.0: BAR 14: can't allocate mem resource [0xd8500000-0xd84fffff]
[    0.431562] pci 0000:0b:08.0: BAR 13: can't allocate I/O resource [0x7000-0x6fff]
[    0.431650] pci 0000:0b:01.0: PCI bridge, secondary bus 0000:0c
[    0.431722] pci 0000:0b:01.0:   IO window: 0x5000-0x5fff
[    0.431794] pci 0000:0b:01.0:   MEM window: 0xd8300000-0xd83fffff
[    0.431877] pci 0000:0b:01.0:   PREFETCH window: 0xd8e00000-0xd8ffffff
[    0.431952] pci 0000:0b:08.0: PCI bridge, secondary bus 0000:0d
[    0.432023] pci 0000:0b:08.0:   IO window: disabled
[    0.432094] pci 0000:0b:08.0:   MEM window: disabled
[    0.432164] pci 0000:0b:08.0:   PREFETCH window: 0x000000d9000000-0x000000d91fffff
[    0.432256] pci 0000:0b:09.0: PCI bridge, secondary bus 0000:0e
[    0.432328] pci 0000:0b:09.0:   IO window: 0x6000-0x6fff
[    0.432400] pci 0000:0b:09.0:   MEM window: 0xd8400000-0xd84fffff
[    0.432473] pci 0000:0b:09.0:   PREFETCH window: 0xd9200000-0xd93fffff
[    0.432548] pci 0000:0a:00.0: PCI bridge, secondary bus 0000:0b
[    0.432620] pci 0000:0a:00.0:   IO window: 0x5000-0x6fff
[    0.432692] pci 0000:0a:00.0:   MEM window: 0xd8300000-0xd84fffff
[    0.432765] pci 0000:0a:00.0:   PREFETCH window: 0xd8e00000-0xd93fffff
[    0.432840] pci 0000:00:07.0: PCI bridge, secondary bus 0000:0a
[    0.432912] pci 0000:00:07.0:   IO window: 0x5000-0x6fff
[    0.432983] pci 0000:00:07.0:   MEM window: 0xd8200000-0xd84fffff
[    0.433056] pci 0000:00:07.0:   PREFETCH window: 0xd8e00000-0xd93fffff
[    0.433131] pci 0000:00:09.0: PCI bridge, secondary bus 0000:0f
[    0.433203] pci 0000:00:09.0:   IO window: 0x7000-0x7fff
[    0.433274] pci 0000:00:09.0:   MEM window: 0xd8700000-0xd87fffff
[    0.433347] pci 0000:00:09.0:   PREFETCH window: 0xd8a00000-0xd8afffff
[    0.433422] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:10
[    0.433493] pci 0000:00:1e.0:   IO window: 0x8000-0x8fff
[    0.433566] pci 0000:00:1e.0:   MEM window: 0xd8800000-0xd88fffff
[    0.433639] pci 0000:00:1e.0:   PREFETCH window: 0x000000d0000000-0x000000d7ffffff
[    0.433737]   alloc irq_desc for 24 on node -1
[    0.433740]   alloc kstat_irqs on node -1
[    0.433746] pci 0000:00:01.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
[    0.433820] pci 0000:00:01.0: setting latency timer to 64
[    0.433826]   alloc irq_desc for 26 on node -1
[    0.433828]   alloc kstat_irqs on node -1
[    0.433836] pci 0000:00:03.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
[    0.433909] pci 0000:00:03.0: setting latency timer to 64
[    0.433919] pci 0000:02:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
[    0.433993] pci 0000:02:00.0: setting latency timer to 64
[    0.434000] pci 0000:03:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
[    0.434074] pci 0000:03:00.0: setting latency timer to 64
[    0.434083] pci 0000:02:00.3: setting latency timer to 64
[    0.434088]   alloc irq_desc for 28 on node -1
[    0.434090]   alloc kstat_irqs on node -1
[    0.434095] pci 0000:00:05.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[    0.434168] pci 0000:00:05.0: setting latency timer to 64
[    0.434178] pci 0000:06:00.0: setting latency timer to 64
[    0.434188] pci 0000:07:00.0: setting latency timer to 64
[    0.434199] pci 0000:07:01.0: setting latency timer to 64
[    0.434205]   alloc irq_desc for 30 on node -1
[    0.434206]   alloc kstat_irqs on node -1
[    0.434211] pci 0000:00:07.0: PCI INT A -> GSI 30 (level, low) -> IRQ 30
[    0.434284] pci 0000:00:07.0: setting latency timer to 64
[    0.434292] pci 0000:0a:00.0: PCI INT A -> GSI 30 (level, low) -> IRQ 30
[    0.434366] pci 0000:0a:00.0: setting latency timer to 64
[    0.434373]   alloc irq_desc for 37 on node -1
[    0.434375]   alloc kstat_irqs on node -1
[    0.434379] pci 0000:0b:01.0: PCI INT A -> GSI 37 (level, low) -> IRQ 37
[    0.434453] pci 0000:0b:01.0: setting latency timer to 64
[    0.434461] pci 0000:0b:08.0: PCI INT A -> GSI 30 (level, low) -> IRQ 30
[    0.434534] pci 0000:0b:08.0: setting latency timer to 64
[    0.434542] pci 0000:0b:09.0: PCI INT A -> GSI 37 (level, low) -> IRQ 37
[    0.434616] pci 0000:0b:09.0: setting latency timer to 64
[    0.434625]   alloc irq_desc for 32 on node -1
[    0.434627]   alloc kstat_irqs on node -1
[    0.434631] pci 0000:00:09.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
[    0.434705] pci 0000:00:09.0: setting latency timer to 64
[    0.434711] pci 0000:00:1e.0: setting latency timer to 64
[    0.434715] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.434717] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.434720] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
[    0.434722] pci_bus 0000:02: resource 1 mem: [0xd8500000-0xd86fffff]
[    0.434725] pci_bus 0000:02: resource 2 pref mem [0xd8900000-0xd89fffff]
[    0.434727] pci_bus 0000:03: resource 0 io:  [0x2000-0x2fff]
[    0.434730] pci_bus 0000:03: resource 1 mem: [0xd8600000-0xd86fffff]
[    0.434732] pci_bus 0000:03: resource 2 pref mem [0xd8900000-0xd89fffff]
[    0.434735] pci_bus 0000:04: resource 0 io:  [0x2000-0x2fff]
[    0.434737] pci_bus 0000:04: resource 1 mem: [0xd8600000-0xd86fffff]
[    0.434739] pci_bus 0000:04: resource 2 pref mem [0xd8900000-0xd89fffff]
[    0.434742] pci_bus 0000:06: resource 0 io:  [0x3000-0x4fff]
[    0.434744] pci_bus 0000:06: resource 1 mem: [0xd8000000-0xd81fffff]
[    0.434747] pci_bus 0000:06: resource 2 pref mem [0xd8c00000-0xd8dfffff]
[    0.434749] pci_bus 0000:07: resource 0 io:  [0x3000-0x4fff]
[    0.434752] pci_bus 0000:07: resource 1 mem: [0xd8000000-0xd81fffff]
[    0.434754] pci_bus 0000:07: resource 2 pref mem [0xd8c00000-0xd8dfffff]
[    0.434756] pci_bus 0000:08: resource 0 io:  [0x3000-0x3fff]
[    0.434759] pci_bus 0000:08: resource 1 mem: [0xd8000000-0xd80fffff]
[    0.434761] pci_bus 0000:08: resource 2 pref mem [0xd8c00000-0xd8cfffff]
[    0.434763] pci_bus 0000:09: resource 0 io:  [0x4000-0x4fff]
[    0.434766] pci_bus 0000:09: resource 1 mem: [0xd8100000-0xd81fffff]
[    0.434768] pci_bus 0000:09: resource 2 pref mem [0xd8d00000-0xd8dfffff]
[    0.434771] pci_bus 0000:0a: resource 0 io:  [0x5000-0x6fff]
[    0.434773] pci_bus 0000:0a: resource 1 mem: [0xd8200000-0xd84fffff]
[    0.434775] pci_bus 0000:0a: resource 2 pref mem [0xd8e00000-0xd93fffff]
[    0.434778] pci_bus 0000:0b: resource 0 io:  [0x5000-0x6fff]
[    0.434780] pci_bus 0000:0b: resource 1 mem: [0xd8300000-0xd84fffff]
[    0.434782] pci_bus 0000:0b: resource 2 pref mem [0xd8e00000-0xd93fffff]
[    0.434785] pci_bus 0000:0c: resource 0 io:  [0x5000-0x5fff]
[    0.434787] pci_bus 0000:0c: resource 1 mem: [0xd8300000-0xd83fffff]
[    0.434789] pci_bus 0000:0c: resource 2 pref mem [0xd8e00000-0xd8ffffff]
[    0.434792] pci_bus 0000:0d: resource 2 pref mem [0xd9000000-0xd91fffff]
[    0.434794] pci_bus 0000:0e: resource 0 io:  [0x6000-0x6fff]
[    0.434797] pci_bus 0000:0e: resource 1 mem: [0xd8400000-0xd84fffff]
[    0.434799] pci_bus 0000:0e: resource 2 pref mem [0xd9200000-0xd93fffff]
[    0.434802] pci_bus 0000:0f: resource 0 io:  [0x7000-0x7fff]
[    0.434804] pci_bus 0000:0f: resource 1 mem: [0xd8700000-0xd87fffff]
[    0.434806] pci_bus 0000:0f: resource 2 pref mem [0xd8a00000-0xd8afffff]
[    0.434809] pci_bus 0000:10: resource 0 io:  [0x8000-0x8fff]
[    0.434811] pci_bus 0000:10: resource 1 mem: [0xd8800000-0xd88fffff]
[    0.434813] pci_bus 0000:10: resource 2 pref mem [0xd0000000-0xd7ffffff]
[    0.434816] pci_bus 0000:10: resource 3 io:  [0x00-0xffff]
[    0.434818] pci_bus 0000:10: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.434851] NET: Registered protocol family 2
[    0.435098] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.436245] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.439953] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.440533] TCP: Hash tables configured (established 524288 bind 65536)
[    0.440606] TCP reno registered
[    0.440806] NET: Registered protocol family 1
[    0.441011] pci 0000:00:1f.0: rerouting interrupts for [8086:2670]
[    0.441114] pci 0000:0f:00.0: Disabling L0s
[    0.441184] pci 0000:0f:00.1: Disabling L0s
[    0.441256] pci 0000:10:01.0: Boot video device
[    0.441312] Unpacking initramfs...
[    0.511858] Freeing initrd memory: 2750k freed
[    0.512768] Simple Boot Flag at 0x41 set to 0x1
[    0.513282] audit: initializing netlink socket (disabled)
[    0.513363] type=2000 audit(1272981743.511:1): initialized
[    0.513832] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.515362] VFS: Disk quotas dquot_6.5.2
[    0.515483] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.515641] msgmni has been set to 7930
[    0.515969] alg: No test for stdrng (krng)
[    0.516086] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.516175] io scheduler noop registered
[    0.516242] io scheduler anticipatory registered
[    0.516311] io scheduler deadline registered (default)
[    0.516410] io scheduler cfq registered
[    0.516645]   alloc irq_desc for 48 on node -1
[    0.516647]   alloc kstat_irqs on node -1
[    0.516658] pcieport 0000:00:01.0: irq 48 for MSI/MSI-X
[    0.516665] pcieport 0000:00:01.0: setting latency timer to 64
[    0.516756]   alloc irq_desc for 49 on node -1
[    0.516758]   alloc kstat_irqs on node -1
[    0.516763] pcieport 0000:00:03.0: irq 49 for MSI/MSI-X
[    0.516769] pcieport 0000:00:03.0: setting latency timer to 64
[    0.516853]   alloc irq_desc for 50 on node -1
[    0.516855]   alloc kstat_irqs on node -1
[    0.516861] pcieport 0000:00:05.0: irq 50 for MSI/MSI-X
[    0.516866] pcieport 0000:00:05.0: setting latency timer to 64
[    0.516950]   alloc irq_desc for 51 on node -1
[    0.516952]   alloc kstat_irqs on node -1
[    0.516958] pcieport 0000:00:07.0: irq 51 for MSI/MSI-X
[    0.516963] pcieport 0000:00:07.0: setting latency timer to 64
[    0.517055]   alloc irq_desc for 52 on node -1
[    0.517057]   alloc kstat_irqs on node -1
[    0.517062] pcieport 0000:00:09.0: irq 52 for MSI/MSI-X
[    0.517068] pcieport 0000:00:09.0: setting latency timer to 64
[    0.517153] pcieport 0000:02:00.0: setting latency timer to 64
[    0.517242]   alloc irq_desc for 53 on node -1
[    0.517244]   alloc kstat_irqs on node -1
[    0.517251] pcieport 0000:03:00.0: irq 53 for MSI/MSI-X
[    0.517258] pcieport 0000:03:00.0: setting latency timer to 64
[    0.517330] pcieport 0000:06:00.0: setting latency timer to 64
[    0.517425]   alloc irq_desc for 54 on node -1
[    0.517427]   alloc kstat_irqs on node -1
[    0.517435] pcieport 0000:07:00.0: irq 54 for MSI/MSI-X
[    0.517443] pcieport 0000:07:00.0: setting latency timer to 64
[    0.517542]   alloc irq_desc for 55 on node -1
[    0.517543]   alloc kstat_irqs on node -1
[    0.517551] pcieport 0000:07:01.0: irq 55 for MSI/MSI-X
[    0.517559] pcieport 0000:07:01.0: setting latency timer to 64
[    0.517664]   alloc irq_desc for 56 on node -1
[    0.517665]   alloc kstat_irqs on node -1
[    0.517673] pcieport 0000:0a:00.0: irq 56 for MSI/MSI-X
[    0.517680] pcieport 0000:0a:00.0: setting latency timer to 64
[    0.517794]   alloc irq_desc for 57 on node -1
[    0.517796]   alloc kstat_irqs on node -1
[    0.517803] pcieport 0000:0b:01.0: irq 57 for MSI/MSI-X
[    0.517811] pcieport 0000:0b:01.0: setting latency timer to 64
[    0.517934]   alloc irq_desc for 58 on node -1
[    0.517936]   alloc kstat_irqs on node -1
[    0.517944] pcieport 0000:0b:08.0: irq 58 for MSI/MSI-X
[    0.517951] pcieport 0000:0b:08.0: setting latency timer to 64
[    0.518080]   alloc irq_desc for 59 on node -1
[    0.518082]   alloc kstat_irqs on node -1
[    0.518089] pcieport 0000:0b:09.0: irq 59 for MSI/MSI-X
[    0.518096] pcieport 0000:0b:09.0: setting latency timer to 64
[    0.518189] aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
[    0.518196] aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
[    0.518202] aer 0000:00:05.0:pcie02: AER service couldn't init device: no _OSC support
[    0.518207] aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
[    0.518213] aer 0000:00:09.0:pcie02: AER service couldn't init device: no _OSC support
[    0.519727] Linux agpgart interface v0.103
[    0.519852] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.520287] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[    0.520430] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    0.772190] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.772334] mice: PS/2 mouse device common for all mice
[    0.772440] rtc_cmos 00:05: RTC can wake from S4
[    0.772538] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.772633] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.772715] cpuidle: using governor ladder
[    0.772782] cpuidle: using governor menu
[    0.772852] No iBFT detected.
[    0.773234] TCP cubic registered
[    0.773405] NET: Registered protocol family 10
[    0.773932] lo: Disabled Privacy Extensions
[    0.774272] Mobile IPv6
[    0.774338] NET: Registered protocol family 17
[    0.774480] PM: Resume from disk failed.
[    0.774484] registered taskstats version 1
[    0.775253] rtc_cmos 00:05: setting system clock to 2010-05-04 14:02:24 UTC (1272981744)
[    0.775394] Freeing unused kernel memory: 580k freed
[    0.775650] Write protecting the kernel read-only data: 4156k
[    0.791287] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    0.801423] SCSI subsystem initialized
[    0.816768] libata version 3.00 loaded.
[    0.820405] ata_piix 0000:00:1f.2: version 2.13
[    0.820420]   alloc irq_desc for 17 on node -1
[    0.820422]   alloc kstat_irqs on node -1
[    0.820430] ata_piix 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.820506] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    0.975856] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.975917] scsi0 : ata_piix
[    0.976054] scsi1 : ata_piix
[    0.976152] ata1: SATA max UDMA/133 cmd 0x18a0 ctl 0x1894 bmdma 0x1880 irq 17
[    0.976225] ata2: SATA max UDMA/133 cmd 0x1898 ctl 0x1890 bmdma 0x1888 irq 17
[    1.148205] ata1.00: ATA-7: TS32GSSD25S-M, V090331, max UDMA/133
[    1.148278] ata1.00: 62586880 sectors, multi 1: LBA48 NCQ (depth 0/1)
[    1.156225] ata1.00: configured for UDMA/133
[    1.156384] scsi 0:0:0:0: Direct-Access     ATA      TS32GSSD25S-M    V090 PQ: 0 ANSI: 5
[    1.161331] sd 0:0:0:0: [sda] 62586880 512-byte logical blocks: (32.0 GB/29.8 GiB)
[    1.161457] sd 0:0:0:0: [sda] Write Protect is off
[    1.161539] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.161561] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.161776]  sda: sda1 sda2 < sda5 >
[    1.162829] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.178743] dca service started, version 1.12.1
[    1.181796] Intel(R) Gigabit Ethernet Network Driver - version 1.3.16-k2
[    1.181869] Copyright (c) 2007-2009 Intel Corporation.
[    1.181979] igb 0000:0f:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
[    1.182072] igb 0000:0f:00.0: setting latency timer to 64
[    1.182340]   alloc irq_desc for 60 on node -1
[    1.182342]   alloc kstat_irqs on node -1
[    1.182350] igb 0000:0f:00.0: irq 60 for MSI/MSI-X
[    1.182352]   alloc irq_desc for 61 on node -1
[    1.182354]   alloc kstat_irqs on node -1
[    1.182357] igb 0000:0f:00.0: irq 61 for MSI/MSI-X
[    1.182359]   alloc irq_desc for 62 on node -1
[    1.182361]   alloc kstat_irqs on node -1
[    1.182364] igb 0000:0f:00.0: irq 62 for MSI/MSI-X
[    1.182366]   alloc irq_desc for 63 on node -1
[    1.182368]   alloc kstat_irqs on node -1
[    1.182371] igb 0000:0f:00.0: irq 63 for MSI/MSI-X
[    1.182377]   alloc irq_desc for 64 on node -1
[    1.182379]   alloc kstat_irqs on node -1
[    1.182382] igb 0000:0f:00.0: irq 64 for MSI/MSI-X
[    1.182384]   alloc irq_desc for 65 on node -1
[    1.182385]   alloc kstat_irqs on node -1
[    1.182389] igb 0000:0f:00.0: irq 65 for MSI/MSI-X
[    1.182391]   alloc irq_desc for 66 on node -1
[    1.182392]   alloc kstat_irqs on node -1
[    1.182396] igb 0000:0f:00.0: irq 66 for MSI/MSI-X
[    1.182398]   alloc irq_desc for 67 on node -1
[    1.182399]   alloc kstat_irqs on node -1
[    1.182403] igb 0000:0f:00.0: irq 67 for MSI/MSI-X
[    1.182405]   alloc irq_desc for 68 on node -1
[    1.182407]   alloc kstat_irqs on node -1
[    1.182410] igb 0000:0f:00.0: irq 68 for MSI/MSI-X
[    1.375124] igb 0000:0f:00.0: Intel(R) Gigabit Ethernet Network Connection
[    1.375198] igb 0000:0f:00.0: eth0: (PCIe:2.5Gb/s:Width x4) 00:30:48:b9:46:a6
[    1.375345] igb 0000:0f:00.0: eth0: PBA No: ffffff-0ff
[    1.375414] igb 0000:0f:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    1.375520]   alloc irq_desc for 46 on node -1
[    1.375522]   alloc kstat_irqs on node -1
[    1.375528] igb 0000:0f:00.1: PCI INT B -> GSI 46 (level, low) -> IRQ 46
[    1.375617] igb 0000:0f:00.1: setting latency timer to 64
[    1.375855]   alloc irq_desc for 69 on node -1
[    1.375857]   alloc kstat_irqs on node -1
[    1.375861] igb 0000:0f:00.1: irq 69 for MSI/MSI-X
[    1.375864]   alloc irq_desc for 70 on node -1
[    1.375866]   alloc kstat_irqs on node -1
[    1.375869] igb 0000:0f:00.1: irq 70 for MSI/MSI-X
[    1.375871]   alloc irq_desc for 71 on node -1
[    1.375873]   alloc kstat_irqs on node -1
[    1.375876] igb 0000:0f:00.1: irq 71 for MSI/MSI-X
[    1.375878]   alloc irq_desc for 72 on node -1
[    1.375879]   alloc kstat_irqs on node -1
[    1.375883] igb 0000:0f:00.1: irq 72 for MSI/MSI-X
[    1.375885]   alloc irq_desc for 73 on node -1
[    1.375886]   alloc kstat_irqs on node -1
[    1.375889] igb 0000:0f:00.1: irq 73 for MSI/MSI-X
[    1.375891]   alloc irq_desc for 74 on node -1
[    1.375893]   alloc kstat_irqs on node -1
[    1.375896] igb 0000:0f:00.1: irq 74 for MSI/MSI-X
[    1.375898]   alloc irq_desc for 75 on node -1
[    1.375899]   alloc kstat_irqs on node -1
[    1.375903] igb 0000:0f:00.1: irq 75 for MSI/MSI-X
[    1.375905]   alloc irq_desc for 76 on node -1
[    1.375906]   alloc kstat_irqs on node -1
[    1.375909] igb 0000:0f:00.1: irq 76 for MSI/MSI-X
[    1.375911]   alloc irq_desc for 77 on node -1
[    1.375913]   alloc kstat_irqs on node -1
[    1.375916] igb 0000:0f:00.1: irq 77 for MSI/MSI-X
[    1.559131] igb 0000:0f:00.1: Intel(R) Gigabit Ethernet Network Connection
[    1.559205] igb 0000:0f:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 00:30:48:b9:46:a7
[    1.559351] igb 0000:0f:00.1: eth1: PBA No: ffffff-0ff
[    1.559421] igb 0000:0f:00.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    1.563815] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    1.570262] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    1.570381] e1000e 0000:08:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[    1.570475] e1000e 0000:08:00.0: setting latency timer to 64
[    1.570594]   alloc irq_desc for 78 on node -1
[    1.570596]   alloc kstat_irqs on node -1
[    1.570610] e1000e 0000:08:00.0: irq 78 for MSI/MSI-X
[    1.751110] 0000:08:00.0: eth2: (PCI Express:2.5GB/s:Width x4) 00:15:17:bb:6f:6c
[    1.751198] 0000:08:00.0: eth2: Intel(R) PRO/1000 Network Connection
[    1.751349] 0000:08:00.0: eth2: MAC: 0, PHY: 4, PBA No: d47316-004
[    1.751447]   alloc irq_desc for 36 on node -1
[    1.751449]   alloc kstat_irqs on node -1
[    1.751454] e1000e 0000:08:00.1: PCI INT B -> GSI 36 (level, low) -> IRQ 36
[    1.751546] e1000e 0000:08:00.1: setting latency timer to 64
[    1.751643]   alloc irq_desc for 79 on node -1
[    1.751645]   alloc kstat_irqs on node -1
[    1.751656] e1000e 0000:08:00.1: irq 79 for MSI/MSI-X
[    1.927118] 0000:08:00.1: eth3: (PCI Express:2.5GB/s:Width x4) 00:15:17:bb:6f:6d
[    1.927206] 0000:08:00.1: eth3: Intel(R) PRO/1000 Network Connection
[    1.927357] 0000:08:00.1: eth3: MAC: 0, PHY: 4, PBA No: d47316-004
[    1.927454] e1000e 0000:09:00.0: PCI INT A -> GSI 36 (level, low) -> IRQ 36
[    1.927545] e1000e 0000:09:00.0: setting latency timer to 64
[    1.927641]   alloc irq_desc for 80 on node -1
[    1.927643]   alloc kstat_irqs on node -1
[    1.927654] e1000e 0000:09:00.0: irq 80 for MSI/MSI-X
[    2.103170] 0000:09:00.0: eth4: (PCI Express:2.5GB/s:Width x4) 00:15:17:bb:6f:6e
[    2.103258] 0000:09:00.0: eth4: Intel(R) PRO/1000 Network Connection
[    2.103409] 0000:09:00.0: eth4: MAC: 0, PHY: 4, PBA No: d47316-004
[    2.103504]   alloc irq_desc for 44 on node -1
[    2.103506]   alloc kstat_irqs on node -1
[    2.103512] e1000e 0000:09:00.1: PCI INT B -> GSI 44 (level, low) -> IRQ 44
[    2.103602] e1000e 0000:09:00.1: setting latency timer to 64
[    2.103699]   alloc irq_desc for 81 on node -1
[    2.103700]   alloc kstat_irqs on node -1
[    2.103711] e1000e 0000:09:00.1: irq 81 for MSI/MSI-X
[    2.279209] 0000:09:00.1: eth5: (PCI Express:2.5GB/s:Width x4) 00:15:17:bb:6f:6f
[    2.279296] 0000:09:00.1: eth5: Intel(R) PRO/1000 Network Connection
[    2.279447] 0000:09:00.1: eth5: MAC: 0, PHY: 4, PBA No: d47316-004
[    2.295993] mvsas 0000:04:00.0: mvsas: driver version 0.8.2
[    2.296074] mvsas 0000:04:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
[    2.296149] mvsas 0000:04:00.0: setting latency timer to 64
[    2.297824] mvsas 0000:04:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
[    8.079220] scsi2 : mvsas
[    8.079776] mvsas 0000:0c:00.0: mvsas: driver version 0.8.2
[    8.079861] mvsas 0000:0c:00.0: PCI INT A -> GSI 37 (level, low) -> IRQ 37
[    8.079937] mvsas 0000:0c:00.0: setting latency timer to 64
[    8.081935] mvsas 0000:0c:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
[    8.286910] ata3.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[    8.286982] ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    8.318342] ata3.00: configured for UDMA/133
[    8.318476] scsi 2:0:0:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[    8.548479] ata4.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[    8.548552] ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    8.560269] ata4.00: configured for UDMA/133
[    8.560377] scsi 2:0:1:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[    8.823591] ata5.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[    8.823664] ata5.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    8.835417] ata5.00: configured for UDMA/133
[    8.835525] scsi 2:0:2:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[    9.070146] ata6.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[    9.070219] ata6.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    9.081977] ata6.00: configured for UDMA/133
[    9.082085] scsi 2:0:3:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[    9.337820] ata7.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[    9.337892] ata7.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    9.349607] ata7.00: configured for UDMA/133
[    9.349713] scsi 2:0:4:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[    9.602546] ata8.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[    9.602619] ata8.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    9.614210] ata8.00: configured for UDMA/133
[    9.614316] scsi 2:0:5:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[    9.855620] ata9.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[    9.855693] ata9.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    9.867278] ata9.00: configured for UDMA/133
[    9.867384] scsi 2:0:6:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[   10.111015] ata10.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[   10.111087] ata10.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   10.122845] ata10.00: configured for UDMA/133
[   10.122951] scsi 2:0:7:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[   10.123231] sd 2:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   10.123307] sd 2:0:1:0: [sdc] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   10.123347] sd 2:0:1:0: [sdc] Write Protect is off
[   10.123349] sd 2:0:1:0: [sdc] Mode Sense: 00 3a 00 00
[   10.123376] sd 2:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.123418] sd 2:0:2:0: [sdd] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   10.123474] sd 2:0:2:0: [sdd] Write Protect is off
[   10.123476] sd 2:0:2:0: [sdd] Mode Sense: 00 3a 00 00
[   10.123524]  sdc:
[   10.123530] sd 2:0:2:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.123587] sd 2:0:3:0: [sde] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   10.123634] sd 2:0:3:0: [sde] Write Protect is off
[   10.123637] sd 2:0:3:0: [sde] Mode Sense: 00 3a 00 00
[   10.123660] sd 2:0:3:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.123694]  sdd:
[   10.123805] sd 2:0:4:0: [sdf] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   10.123828]  sde:
[   10.123851] sd 2:0:4:0: [sdf] Write Protect is off
[   10.123853] sd 2:0:4:0: [sdf] Mode Sense: 00 3a 00 00
[   10.123881] sd 2:0:4:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.123886] sd 2:0:5:0: [sdg] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   10.123923] sd 2:0:5:0: [sdg] Write Protect is off
[   10.123925] sd 2:0:5:0: [sdg] Mode Sense: 00 3a 00 00
[   10.123945] sd 2:0:5:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.124051]  sdf:
[   10.124109]  sdg:
[   10.124122] sd 2:0:6:0: [sdh] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   10.124171] sd 2:0:6:0: [sdh] Write Protect is off
[   10.124179] sd 2:0:7:0: [sdi] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   10.124190] sd 2:0:6:0: [sdh] Mode Sense: 00 3a 00 00
[   10.124215] sd 2:0:6:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.124231] sd 2:0:7:0: [sdi] Write Protect is off
[   10.124234] sd 2:0:7:0: [sdi] Mode Sense: 00 3a 00 00
[   10.124253] sd 2:0:7:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.124348]  sdh:
[   10.124396]  sdi:
[   10.125530] sd 2:0:0:0: [sdb] Write Protect is off
[   10.125659] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   10.125679] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.125892]  sdb: sde1
[   10.149361] sd 2:0:3:0: [sde] Attached SCSI disk
[   10.150749]  sdh1
[   10.151047] sd 2:0:6:0: [sdh] Attached SCSI disk
[   10.152554]  sdg1
[   10.152743]  sdf1
[   10.152825] sd 2:0:5:0: [sdg] Attached SCSI disk
[   10.153084] sd 2:0:4:0: [sdf] Attached SCSI disk
[   10.170071]  sdi1
[   10.170340] sd 2:0:7:0: [sdi] Attached SCSI disk
[   10.174730]  sdd1
[   10.175006] sd 2:0:2:0: [sdd] Attached SCSI disk
[   10.179730]  sdb1
[   10.180001] sd 2:0:0:0: [sdb] Attached SCSI disk
[   10.180520]  sdc1
[   10.180802] sd 2:0:1:0: [sdc] Attached SCSI disk
[   13.863221] scsi3 : mvsas
[   13.863719] mvsas 0000:0e:00.0: mvsas: driver version 0.8.2
[   13.863806] mvsas 0000:0e:00.0: PCI INT A -> GSI 37 (level, low) -> IRQ 37
[   13.863882] mvsas 0000:0e:00.0: setting latency timer to 64
[   13.865893] mvsas 0000:0e:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
[   14.118335] ata11.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[   14.118407] ata11.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   14.120811] ata11.00: configured for UDMA/133
[   14.120923] scsi 3:0:0:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[   14.378559] ata12.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[   14.378632] ata12.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   14.381043] ata12.00: configured for UDMA/133
[   14.381151] scsi 3:0:1:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[   14.634148] ata13.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[   14.634221] ata13.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   14.636724] ata13.00: configured for UDMA/133
[   14.636831] scsi 3:0:2:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[   14.882425] ata14.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[   14.882497] ata14.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   14.885183] ata14.00: configured for UDMA/133
[   14.885290] scsi 3:0:3:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[   15.140534] ata15.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[   15.140607] ata15.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   15.143051] ata15.00: configured for UDMA/133
[   15.143157] scsi 3:0:4:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[   15.393875] ata16.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[   15.393948] ata16.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   15.396384] ata16.00: configured for UDMA/133
[   15.396490] scsi 3:0:5:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[   15.643306] ata17.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[   15.643378] ata17.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   15.645785] ata17.00: configured for UDMA/133
[   15.645891] scsi 3:0:6:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[   15.898177] ata18.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[   15.898250] ata18.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   15.900763] ata18.00: configured for UDMA/133
[   15.900869] scsi 3:0:7:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[   15.901148] sd 3:0:0:0: [sdj] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   15.901243] sd 3:0:1:0: [sdk] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   15.901277] sd 3:0:0:0: [sdj] Write Protect is off
[   15.901280] sd 3:0:0:0: [sdj] Mode Sense: 00 3a 00 00
[   15.901301] sd 3:0:0:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.901356] sd 3:0:2:0: [sdl] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   15.901404] sd 3:0:2:0: [sdl] Write Protect is off
[   15.901406] sd 3:0:2:0: [sdl] Mode Sense: 00 3a 00 00
[   15.901428] sd 3:0:2:0: [sdl] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.901454]  sdj:
[   15.901557]  sdl:
[   15.901960] sd 3:0:3:0: [sdm] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   15.901982] sd 3:0:4:0: [sdn] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   15.902021] sd 3:0:5:0: [sdo] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   15.902031] sd 3:0:3:0: [sdm] Write Protect is off
[   15.902033] sd 3:0:3:0: [sdm] Mode Sense: 00 3a 00 00
[   15.902037] sd 3:0:4:0: [sdn] Write Protect is off
[   15.902040] sd 3:0:4:0: [sdn] Mode Sense: 00 3a 00 00
[   15.902066] sd 3:0:3:0: [sdm] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.902080] sd 3:0:4:0: [sdn] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.902084] sd 3:0:5:0: [sdo] Write Protect is off
[   15.902086] sd 3:0:5:0: [sdo] Mode Sense: 00 3a 00 00
[   15.902106] sd 3:0:5:0: [sdo] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.902267]  sdm:
[   15.902326]  sdn:
[   15.902330] sd 3:0:6:0: [sdp] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   15.902389]  sdo:
[   15.902395] sd 3:0:6:0: [sdp] Write Protect is off
[   15.902405] sd 3:0:7:0: [sdq] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   15.902415] sd 3:0:6:0: [sdp] Mode Sense: 00 3a 00 00
[   15.902439] sd 3:0:6:0: [sdp] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.902458] sd 3:0:7:0: [sdq] Write Protect is off
[   15.902460] sd 3:0:7:0: [sdq] Mode Sense: 00 3a 00 00
[   15.902480] sd 3:0:7:0: [sdq] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.902574]  sdp:
[   15.902626]  sdq:
[   15.909750] sd 3:0:1:0: [sdk] Write Protect is off
[   15.909879] sd 3:0:1:0: [sdk] Mode Sense: 00 3a 00 00
[   15.909899] sd 3:0:1:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.910090]  sdk: sdo1
[   15.928430]  sdm1
[   15.928772] sd 3:0:3:0: [sdm] Attached SCSI disk
[   15.928780] sd 3:0:5:0: [sdo] Attached SCSI disk
[   15.929308]  sdq1
[   15.929595] sd 3:0:7:0: [sdq] Attached SCSI disk
[   15.930218]  sdp1
[   15.930362]  sdn1
[   15.930684] sd 3:0:6:0: [sdp] Attached SCSI disk
[   15.930692] sd 3:0:4:0: [sdn] Attached SCSI disk
[   15.956862]  sdj1
[   15.957134] sd 3:0:0:0: [sdj] Attached SCSI disk
[   15.961095]  sdk1
[   15.961369] sd 3:0:1:0: [sdk] Attached SCSI disk
[   15.977514]  sdl1
[   15.977786] sd 3:0:2:0: [sdl] Attached SCSI disk
[   19.567221] scsi4 : mvsas
[   19.567757] drivers/scsi/mvsas/mv_sas.c 1259:set wide port phy map 1
[   19.577726] drivers/scsi/mvsas/mv_sas.c 1259:set wide port phy map 2
[   19.697697] scsi 4:0:0:0: Direct-Access     SEAGATE  ST9300603SS      0006 PQ: 0 ANSI: 5
[   19.698712] scsi 4:0:1:0: Direct-Access     SEAGATE  ST9300603SS      0004 PQ: 0 ANSI: 5
[   19.699766] ata19.00: ATA-7: INTEL SSDSA2M160G2GC, 2CV102G9, max UDMA/133
[   19.699840] ata19.00: 312581808 sectors, multi 1: LBA48 NCQ (depth 31/32)
[   19.700250] ata19.00: configured for UDMA/133
[   19.700363] scsi 4:0:2:0: Direct-Access     ATA      INTEL SSDSA2M160 2CV1 PQ: 0 ANSI: 5
[   19.760427] ata20.00: ATA-8: WDC WD5000BEVT-22A0RT0, 01.01A01, max UDMA/133
[   19.760505] ata20.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   19.763423] ata20.00: configured for UDMA/133
[   19.763561] scsi 4:0:3:0: Direct-Access     ATA      WDC WD5000BEVT-2 01.0 PQ: 0 ANSI: 5
[   19.764327] ata21.00: ATA-7: INTEL SSDSA2M160G2GC, 2CV102G9, max UDMA/133
[   19.764401] ata21.00: 312581808 sectors, multi 1: LBA48 NCQ (depth 31/32)
[   19.764808] ata21.00: configured for UDMA/133
[   19.764918] scsi 4:0:4:0: Direct-Access     ATA      INTEL SSDSA2M160 2CV1 PQ: 0 ANSI: 5
[   19.765583] ata22.00: ATA-7: INTEL SSDSA2M160G2GC, 2CV102G9, max UDMA/133
[   19.765657] ata22.00: 312581808 sectors, multi 1: LBA48 NCQ (depth 31/32)
[   19.766063] ata22.00: configured for UDMA/133
[   19.766174] scsi 4:0:5:0: Direct-Access     ATA      INTEL SSDSA2M160 2CV1 PQ: 0 ANSI: 5
[   19.766883] ata23.00: ATA-7: INTEL SSDSA2M160G2GC, 2CV102G9, max UDMA/133
[   19.766958] ata23.00: 312581808 sectors, multi 1: LBA48 NCQ (depth 31/32)
[   19.767364] ata23.00: configured for UDMA/133
[   19.767474] scsi 4:0:6:0: Direct-Access     ATA      INTEL SSDSA2M160 2CV1 PQ: 0 ANSI: 5
[   19.768143] ata24.00: ATA-7: INTEL SSDSA2M160G2GC, 2CV102G9, max UDMA/133
[   19.768218] ata24.00: 312581808 sectors, multi 1: LBA48 NCQ (depth 31/32)
[   19.768629] ata24.00: configured for UDMA/133
[   19.768740] scsi 4:0:7:0: Direct-Access     ATA      INTEL SSDSA2M160 2CV1 PQ: 0 ANSI: 5
[   20.075342] md: linear personality registered for level -1
[   20.078172] md: multipath personality registered for level -4
[   20.080678] md: raid0 personality registered for level 0
[   20.084431] md: raid1 personality registered for level 1
[   20.086750] async_tx: api initialized (async)
[   20.088194] xor: automatically using best checksumming function: generic_sse
[   20.105001]    generic_sse:  7667.000 MB/sec
[   20.105069] xor: using function: generic_sse (7667.000 MB/sec)
[   20.173029] raid6: int64x1   1668 MB/s
[   20.241010] raid6: int64x2   2231 MB/s
[   20.309024] raid6: int64x4   1809 MB/s
[   20.377009] raid6: int64x8   1481 MB/s
[   20.445013] raid6: sse2x1    3231 MB/s
[   20.513007] raid6: sse2x2    5378 MB/s
[   20.574152] sd 4:0:2:0: [sdt] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[   20.574266] sd 4:0:3:0: [sdu] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   20.574302] sd 4:0:2:0: [sdt] Write Protect is off
[   20.574305] sd 4:0:2:0: [sdt] Mode Sense: 00 3a 00 00
[   20.574326] sd 4:0:2:0: [sdt] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   20.574472]  sdt:
[   20.574829] sd 4:0:0:0: [sdr] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   20.575060]  unknown partition table
[   20.575298] sd 4:0:2:0: [sdt] Attached SCSI disk
[   20.575355] sd 4:0:3:0: [sdu] Write Protect is off
[   20.575357] sd 4:0:3:0: [sdu] Mode Sense: 00 3a 00 00
[   20.575377] sd 4:0:3:0: [sdu] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   20.575494]  sdu:
[   20.575605] sd 4:0:4:0: [sdv] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[   20.575793] sd 4:0:4:0: [sdv] Write Protect is off
[   20.575862] sd 4:0:4:0: [sdv] Mode Sense: 00 3a 00 00
[   20.575883] sd 4:0:4:0: [sdv] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   20.576090]  sdv:
[   20.576337] sd 4:0:0:0: [sdr] Write Protect is off
[   20.576337]  sdv1
[   20.576531] sd 4:0:0:0: [sdr] Mode Sense: bb 00 10 08
[   20.576676] sd 4:0:4:0: [sdv] Attached SCSI disk
[   20.576766] sd 4:0:5:0: [sdw] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[   20.576891] sd 4:0:5:0: [sdw] Write Protect is off
[   20.576961] sd 4:0:5:0: [sdw] Mode Sense: 00 3a 00 00
[   20.576982] sd 4:0:5:0: [sdw] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   20.577185]  sdw: sdw1
[   20.577715] sd 4:0:5:0: [sdw] Attached SCSI disk
[   20.577745] sd 4:0:0:0: [sdr] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   20.578045] sd 4:0:6:0: [sdx] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[   20.578170] sd 4:0:6:0: [sdx] Write Protect is off
[   20.581003] raid6: sse2x4    6124 MB/s
[   20.581005] raid6: using algorithm sse2x4 (6124 MB/s)
[   20.581015] sd 4:0:1:0: [sds] Spinning up disk...
[   20.582713] sd 4:0:7:0: [sdy] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[   20.582809] sd 4:0:7:0: [sdy] Write Protect is off
[   20.582812] sd 4:0:7:0: [sdy] Mode Sense: 00 3a 00 00
[   20.582835] sd 4:0:7:0: [sdy] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   20.582982]  sdy:
[   20.585129] sd 4:0:6:0: [sdx] Mode Sense: 00 3a 00 00
[   20.585146]  sdy1
[   20.585435] sd 4:0:7:0: [sdy] Attached SCSI disk
[   20.587227] sd 4:0:6:0: [sdx] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   20.587435]  sdx:
[   20.587682]  sdr: sdx1
[   20.588226] sd 4:0:6:0: [sdx] Attached SCSI disk
[   20.606932]  unknown partition table
[   20.610770] sd 4:0:0:0: [sdr] Attached SCSI disk
[   20.619931]  unknown partition table
[   20.620160] sd 4:0:3:0: [sdu] Attached SCSI disk
[   21.588016] .ready
[   21.588950] sd 4:0:1:0: [sds] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   21.590319] sd 4:0:1:0: [sds] Write Protect is off
[   21.590390] sd 4:0:1:0: [sds] Mode Sense: bb 00 10 08
[   21.591604] sd 4:0:1:0: [sds] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   21.594651]  sds: unknown partition table
[   21.616283] sd 4:0:1:0: [sds] Attached SCSI disk
[   21.621228] md: raid6 personality registered for level 6
[   21.621300] md: raid5 personality registered for level 5
[   21.621369] md: raid4 personality registered for level 4
[   21.630219] md: raid10 personality registered for level 10
[   22.235758] md: md1 stopped.
[   22.235847] mdadm[1315]: segfault at 4 ip 00000000004204c5 sp 00007fff8ab36ce0 error 4 in mdadm[400000+4b000]
[   22.294697] device-mapper: uevent: version 1.0.3
[   22.294889] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[   22.309410] PM: Starting manual resume from disk
[   22.309480] PM: Resume from partition 8:5
[   22.309482] PM: Checking hibernation image.
[   22.310028] PM: Error -22 checking image file
[   22.310029] PM: Resume from disk failed.
[   22.313978] kjournald starting.  Commit interval 5 seconds
[   22.313985] EXT3-fs: mounted filesystem with ordered data mode.
[   22.549432] udevd version 125 started
[   22.835671] processor LNXCPU:00: registered as cooling_device0
[   22.836849] processor LNXCPU:01: registered as cooling_device1
[   22.838191] processor LNXCPU:02: registered as cooling_device2
[   22.853750] processor LNXCPU:03: registered as cooling_device3
[   22.892303] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/PNP0C0C:00/input/input2
[   22.892403] ACPI: Power Button [PWRB]
[   22.892518] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[   22.892607] ACPI: Power Button [PWRF]
[   23.015348] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   23.022556] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   23.656246] EDAC MC: Ver: 2.1.0 Apr  8 2010
[   23.677107] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   23.677245]   alloc irq_desc for 33 on node -1
[   23.677247]   alloc kstat_irqs on node -1
[   23.677256] ioatdma 0000:00:0f.0: PCI INT A -> GSI 33 (level, low) -> IRQ 33
[   23.677403] ioatdma 0000:00:0f.0: setting latency timer to 64
[   23.677451]   alloc irq_desc for 82 on node -1
[   23.677452]   alloc kstat_irqs on node -1
[   23.677459] ioatdma 0000:00:0f.0: irq 82 for MSI/MSI-X
[   23.677461]   alloc irq_desc for 83 on node -1
[   23.677463]   alloc kstat_irqs on node -1
[   23.677466] ioatdma 0000:00:0f.0: irq 83 for MSI/MSI-X
[   23.677469]   alloc irq_desc for 84 on node -1
[   23.677470]   alloc kstat_irqs on node -1
[   23.677473] ioatdma 0000:00:0f.0: irq 84 for MSI/MSI-X
[   23.677475]   alloc irq_desc for 85 on node -1
[   23.677477]   alloc kstat_irqs on node -1
[   23.677481] ioatdma 0000:00:0f.0: irq 85 for MSI/MSI-X
[   23.678119] igb 0000:0f:00.0: DCA enabled
[   23.678248] igb 0000:0f:00.1: DCA enabled
[   23.679359] EDAC MC0: Giving out device to 'i5400_edac.c' 'I5400': DEV 0000:00:10.0
[   23.679475] EDAC PCI0: Giving out device to module 'i5400_edac' controller 'EDAC PCI controller': DEV '0000:00:10.0' (POLLED)
[   23.729065] usbcore: registered new interface driver usbfs
[   23.729163] usbcore: registered new interface driver hub
[   23.733722] usbcore: registered new device driver usb
[   23.737732] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   23.737843]   alloc irq_desc for 23 on node -1
[   23.737845]   alloc kstat_irqs on node -1
[   23.737854] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[   23.737953] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   23.737956] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   23.738050] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[   23.738164] ehci_hcd 0000:00:1d.7: debug port 1
[   23.742117] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[   23.742386] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd8b04000
[   23.751300] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   23.760025] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   23.760123] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   23.760196] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.760283] usb usb1: Product: EHCI Host Controller
[   23.760352] usb usb1: Manufacturer: Linux 2.6.32-bpo.4-amd64 ehci_hcd
[   23.760424] usb usb1: SerialNumber: 0000:00:1d.7
[   23.760583] usb usb1: configuration #1 chosen from 1 choice
[   23.760682] hub 1-0:1.0: USB hub found
[   23.760755] hub 1-0:1.0: 8 ports detected
[   23.813575] uhci_hcd: USB Universal Host Controller Interface driver
[   23.813722]   alloc irq_desc for 20 on node -1
[   23.813724]   alloc kstat_irqs on node -1
[   23.813734] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   23.813816] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   23.813820] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   23.813906] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   23.814033] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001800
[   23.814149] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   23.814230] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.814319] usb usb2: Product: UHCI Host Controller
[   23.814388] usb usb2: Manufacturer: Linux 2.6.32-bpo.4-amd64 uhci_hcd
[   23.814463] usb usb2: SerialNumber: 0000:00:1d.0
[   23.814639] usb usb2: configuration #1 chosen from 1 choice
[   23.814740] hub 2-0:1.0: USB hub found
[   23.814814] hub 2-0:1.0: 2 ports detected
[   23.814933]   alloc irq_desc for 21 on node -1
[   23.814935]   alloc kstat_irqs on node -1
[   23.814939] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[   23.815017] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   23.815020] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   23.815098] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[   23.815212] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00001820
[   23.815313] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   23.821882] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.821972] usb usb3: Product: UHCI Host Controller
[   23.822043] usb usb3: Manufacturer: Linux 2.6.32-bpo.4-amd64 uhci_hcd
[   23.822122] usb usb3: SerialNumber: 0000:00:1d.1
[   23.854598] Error: Driver 'pcspkr' is already registered, aborting...
[   23.859782] usb usb3: configuration #1 chosen from 1 choice
[   23.859892] hub 3-0:1.0: USB hub found
[   23.859972] hub 3-0:1.0: 2 ports detected
[   23.860142]   alloc irq_desc for 18 on node -1
[   23.860145]   alloc kstat_irqs on node -1
[   23.860154] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   23.860743]   alloc irq_desc for 22 on node -1
[   23.860745]   alloc kstat_irqs on node -1
[   23.860755] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[   23.860837] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   23.860840] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   23.860921] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   23.861045] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001840
[   23.861157] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   23.861231] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.861319] usb usb4: Product: UHCI Host Controller
[   23.861388] usb usb4: Manufacturer: Linux 2.6.32-bpo.4-amd64 uhci_hcd
[   23.861461] usb usb4: SerialNumber: 0000:00:1d.2
[   23.861540] intel_rng: FWH not detected
[   23.861687] usb usb4: configuration #1 chosen from 1 choice
[   23.861783] hub 4-0:1.0: USB hub found
[   23.861855] hub 4-0:1.0: 2 ports detected
[   23.861981] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[   23.862058] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[   23.862061] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   23.862136] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[   23.862247] uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001860
[   23.862348] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   23.862421] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.862508] usb usb5: Product: UHCI Host Controller
[   23.862577] usb usb5: Manufacturer: Linux 2.6.32-bpo.4-amd64 uhci_hcd
[   23.862649] usb usb5: SerialNumber: 0000:00:1d.3
[   23.862769] usb usb5: configuration #1 chosen from 1 choice
[   23.862866] hub 5-0:1.0: USB hub found
[   23.862937] hub 5-0:1.0: 2 ports detected
[   25.453987] Adding 4096564k swap on /dev/sda5.  Priority:-1 extents:1 across:4096564k SS
[   25.491207] EXT3 FS on sda1, internal journal
[   26.512205] netconsole: local port 6665
[   26.512277] netconsole: local IP 192.168.0.12
[   26.512345] netconsole: interface eth0
[   26.512411] netconsole: remote port 6666
[   26.512478] netconsole: remote IP 192.168.0.10
[   26.512555] netconsole: remote ethernet address 00:30:48:88:36:c6
[   26.512691] netconsole: device eth0 not up yet, forcing it
[   26.524322] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   26.528976] igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   26.529710] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   26.532508] netconsole: carrier detect appears untrustworthy, waiting 4 seconds
[   30.669845] console [netcon0] enabled
[   30.669913] netconsole: network logging started
[   30.690160] loop: module loaded
[   30.892186] w83627hf: Found W83627HF chip at 0x290
[   31.217681] md: md1 stopped.
[   31.227758] md: bind<sds>
[   31.227976] md: bind<sdr>
[   31.271964] raid1: raid set md1 active with 2 out of 2 mirrors
[   31.272063] md1: detected capacity change from 0 to 299999887360
[   31.273783]  md1: unknown partition table
[   31.527014] md: md0 stopped.
[   31.528042] md: bind<sdw1>
[   31.528304] md: bind<sdx1>
[   31.528559] md: bind<sdy1>
[   31.528809] md: bind<sdv1>
[   31.573520] raid5: device sdv1 operational as raid disk 0
[   31.573594] raid5: device sdx1 operational as raid disk 2
[   31.573665] raid5: device sdw1 operational as raid disk 1
[   31.574126] raid5: allocated 3230kB for md0
[   31.574233] 0: w=1 pa=0 pr=3 m=1 a=2 r=3 op1=0 op2=0
[   31.574304] 2: w=2 pa=0 pr=3 m=1 a=2 r=3 op1=0 op2=0
[   31.574375] 1: w=3 pa=0 pr=3 m=1 a=2 r=3 op1=0 op2=0
[   31.574446] raid5: raid level 5 set md0 active with 3 out of 3 devices, algorithm 2
[   31.574534] RAID5 conf printout:
[   31.574600]  --- rd:3 wd:3
[   31.574666]  disk 0, o:1, dev:sdv1
[   31.574734]  disk 1, o:1, dev:sdw1
[   31.574801]  disk 2, o:1, dev:sdx1
[   31.574892] md0: detected capacity change from 0 to 16450322432
[   31.575987]  md0: unknown partition table
[   31.793580] md: md127 stopped.
[   31.794266] md: bind<sdu>
[   31.837644] raid1: raid set md127 active with 1 out of 2 mirrors
[   31.837739] md127: detected capacity change from 0 to 500107771904
[   31.838825]  md127: unknown partition table
[   32.057721] md: md126 stopped.
[   32.062279] md: bind<sdd1>
[   32.062527] md: bind<sdc1>
[   32.062761] md: bind<sdb1>
[   32.063000] md: bind<sdi1>
[   32.063237] md: bind<sdh1>
[   32.063472] md: bind<sdk1>
[   32.063788] md: bind<sdf1>
[   32.064017] md: bind<sdm1>
[   32.064253] md: bind<sdl1>
[   32.064495] md: bind<sdg1>
[   32.064846] md: bind<sdj1>
[   32.065071] md: bind<sdq1>
[   32.065402] md: bind<sdp1>
[   32.065736] md: bind<sdo1>
[   32.065979] md: bind<sdn1>
[   32.066212] md: bind<sde1>
[   32.066299] md: md126 stopped.
[   32.066374] md: unbind<sde1>
[   32.096007] md: export_rdev(sde1)
[   32.096086] md: unbind<sdn1>
[   32.128007] md: export_rdev(sdn1)
[   32.128089] md: unbind<sdo1>
[   32.144007] md: export_rdev(sdo1)
[   32.144083] md: unbind<sdp1>
[   32.172009] md: export_rdev(sdp1)
[   32.172087] md: unbind<sdq1>
[   32.204007] md: export_rdev(sdq1)
[   32.204082] md: unbind<sdj1>
[   32.236006] md: export_rdev(sdj1)
[   32.236089] md: unbind<sdg1>
[   32.268006] md: export_rdev(sdg1)
[   32.268082] md: unbind<sdl1>
[   32.300008] md: export_rdev(sdl1)
[   32.300087] md: unbind<sdm1>
[   32.332007] md: export_rdev(sdm1)
[   32.332083] md: unbind<sdf1>
[   32.364007] md: export_rdev(sdf1)
[   32.364086] md: unbind<sdk1>
[   32.396007] md: export_rdev(sdk1)
[   32.396083] md: unbind<sdh1>
[   32.428007] md: export_rdev(sdh1)
[   32.428086] md: unbind<sdi1>
[   32.460007] md: export_rdev(sdi1)
[   32.460083] md: unbind<sdb1>
[   32.476009] md: export_rdev(sdb1)
[   32.476091] md: unbind<sdc1>
[   32.488008] md: export_rdev(sdc1)
[   32.488084] md: unbind<sdd1>
[   32.504009] md: export_rdev(sdd1)
[   32.568859] md: md126 stopped.
[   32.572489] md: bind<sdd1>
[   32.572728] md: bind<sdc1>
[   32.572967] md: bind<sdb1>
[   32.573199] md: bind<sdi1>
[   32.573446] md: bind<sdh1>
[   32.573682] md: bind<sdk1>
[   32.573990] md: bind<sdf1>
[   32.574231] md: bind<sdm1>
[   32.574471] md: bind<sdl1>
[   32.574708] md: bind<sdg1>
[   32.575047] md: bind<sdj1>
[   32.575282] md: bind<sdq1>
[   32.575602] md: bind<sdp1>
[   32.575934] md: bind<sdo1>
[   32.576266] md: bind<sdn1>
[   32.576491] md: bind<sde1>
[   32.576576] md: md126 stopped.
[   32.576650] md: unbind<sde1>
[   32.608007] md: export_rdev(sde1)
[   32.608083] md: unbind<sdn1>
[   32.640005] md: export_rdev(sdn1)
[   32.640084] md: unbind<sdo1>
[   32.672006] md: export_rdev(sdo1)
[   32.672081] md: unbind<sdp1>
[   32.704006] md: export_rdev(sdp1)
[   32.704084] md: unbind<sdq1>
[   32.736006] md: export_rdev(sdq1)
[   32.736081] md: unbind<sdj1>
[   32.768006] md: export_rdev(sdj1)
[   32.768084] md: unbind<sdg1>
[   32.804009] md: export_rdev(sdg1)
[   32.804087] md: unbind<sdl1>
[   32.824012] md: export_rdev(sdl1)
[   32.824092] md: unbind<sdm1>
[   32.856007] md: export_rdev(sdm1)
[   32.856083] md: unbind<sdf1>
[   32.888007] md: export_rdev(sdf1)
[   32.888086] md: unbind<sdk1>
[   32.904009] md: export_rdev(sdk1)
[   32.904088] md: unbind<sdh1>
[   32.920006] md: export_rdev(sdh1)
[   32.920086] md: unbind<sdi1>
[   32.932007] md: export_rdev(sdi1)
[   32.932083] md: unbind<sdb1>
[   32.960008] md: export_rdev(sdb1)
[   32.960092] md: unbind<sdc1>
[   32.980009] md: export_rdev(sdc1)
[   32.980085] md: unbind<sdd1>
[   33.008009] md: export_rdev(sdd1)
[   36.660506] eth0: no IPv6 routers present
[   39.280196] RPC: Registered udp transport module.
[   39.280278] RPC: Registered tcp transport module.
[   39.280348] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   39.304055] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   39.329513] svc: failed to register lockdv1 RPC service (errno 97).
[   39.330163] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   39.337003] NFSD: starting 90-second grace period
[   83.579264] iSCSI Enterprise Target Software - version 1.4.20.1
[   83.579427] iscsi_trgt: Registered io type fileio
[   83.579497] iscsi_trgt: Registered io type blockio
[   83.579568] iscsi_trgt: Registered io type nullio
[127107.616125] igb: eth0 NIC Link is Down
[127110.000477] igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[162440.178712] md: md127 stopped.
[162440.178792] md: unbind<sdu>
[162440.193513] md: export_rdev(sdu)
[162440.193848] md127: detected capacity change from 500107771904 to 0
[163354.981793] md: md2 stopped.
[163355.065936] md: bind<sdd1>
[163355.066192] md: bind<sdc1>
[163355.066443] md: bind<sdb1>
[163355.066696] md: bind<sdi1>
[163355.066948] md: bind<sdh1>
[163355.067200] md: bind<sdk1>
[163355.067451] md: bind<sdf1>
[163355.067790] md: bind<sdm1>
[163355.068089] md: bind<sdl1>
[163355.068360] md: bind<sdg1>
[163355.068609] md: bind<sdj1>
[163355.068933] md: bind<sdq1>
[163355.069268] md: bind<sdp1>
[163355.070109] md: bind<sdo1>
[163355.070456] md: bind<sdn1>
[163355.070698] md: bind<sde1>
[163417.377269] md: md2 stopped.
[163417.377355] md: unbind<sde1>
[163417.400514] md: export_rdev(sde1)
[163417.400602] md: unbind<sdn1>
[163417.436010] md: export_rdev(sdn1)
[163417.436096] md: unbind<sdo1>
[163417.456013] md: export_rdev(sdo1)
[163417.456098] md: unbind<sdp1>
[163417.488011] md: export_rdev(sdp1)
[163417.488093] md: unbind<sdq1>
[163417.536013] md: export_rdev(sdq1)
[163417.536102] md: unbind<sdj1>
[163417.564513] md: export_rdev(sdj1)
[163417.571017] md: unbind<sdg1>
[163417.580509] md: export_rdev(sdg1)
[163417.580595] md: unbind<sdl1>
[163417.596008] md: export_rdev(sdl1)
[163417.596090] md: unbind<sdm1>
[163417.608009] md: export_rdev(sdm1)
[163417.608093] md: unbind<sdf1>
[163417.640007] md: export_rdev(sdf1)
[163417.640087] md: unbind<sdk1>
[163417.672006] md: export_rdev(sdk1)
[163417.672090] md: unbind<sdh1>
[163417.704007] md: export_rdev(sdh1)
[163417.704086] md: unbind<sdi1>
[163417.736007] md: export_rdev(sdi1)
[163417.736090] md: unbind<sdb1>
[163417.768007] md: export_rdev(sdb1)
[163417.768087] md: unbind<sdc1>
[163417.800007] md: export_rdev(sdc1)
[163417.800090] md: unbind<sdd1>
[163417.832006] md: export_rdev(sdd1)
[163418.910422] md: md2 stopped.
[163419.427649] md: bind<sdd1>
[163419.427892] md: bind<sdc1>
[163419.428142] md: bind<sdb1>
[163419.428397] md: bind<sdi1>
[163419.428640] md: bind<sdh1>
[163419.428895] md: bind<sdk1>
[163419.429151] md: bind<sdf1>
[163419.429401] md: bind<sdm1>
[163419.429734] md: bind<sdl1>
[163419.429976] md: bind<sdg1>
[163419.430221] md: bind<sdj1>
[163419.430461] md: bind<sdq1>
[163419.430706] md: bind<sdp1>
[163419.430952] md: bind<sdo1>
[163419.431198] md: bind<sdn1>
[163419.453964] md: bind<sde1>
[163419.454085] md: kicking non-fresh sdn1 from array!
[163419.454159] md: unbind<sdn1>
[163419.476007] md: export_rdev(sdn1)
[163419.476088] md: kicking non-fresh sdj1 from array!
[163419.476160] md: unbind<sdj1>
[163419.508007] md: export_rdev(sdj1)
[163419.552645] raid5: device sde1 operational as raid disk 0
[163419.552718] raid5: device sdo1 operational as raid disk 14
[163419.552790] raid5: device sdp1 operational as raid disk 13
[163419.552861] raid5: device sdq1 operational as raid disk 12
[163419.552933] raid5: device sdg1 operational as raid disk 10
[163419.553010] raid5: device sdl1 operational as raid disk 9
[163419.553081] raid5: device sdm1 operational as raid disk 8
[163419.553152] raid5: device sdf1 operational as raid disk 7
[163419.553223] raid5: device sdk1 operational as raid disk 6
[163419.553295] raid5: device sdh1 operational as raid disk 5
[163419.553366] raid5: device sdi1 operational as raid disk 4
[163419.553437] raid5: device sdb1 operational as raid disk 3
[163419.553509] raid5: device sdc1 operational as raid disk 2
[163419.553580] raid5: device sdd1 operational as raid disk 1
[163419.554787] raid5: allocated 15854kB for md2
[163419.554893] 0: w=1 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
[163419.554965] 14: w=2 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
[163419.555037] 13: w=3 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
[163419.555109] 12: w=4 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
[163419.555180] 10: w=5 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
[163419.555252] 9: w=6 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
[163419.555324] 8: w=7 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
[163419.555396] 7: w=8 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
[163419.555467] 6: w=9 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
[163419.555538] 5: w=10 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
[163419.555610] 4: w=11 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
[163419.555682] 3: w=12 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
[163419.555754] 2: w=13 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
[163419.555825] 1: w=14 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
[163419.555901] raid5: raid level 5 set md2 active with 14 out of 15 devices, algorithm 2
[163419.555990] RAID5 conf printout:
[163419.556066]  --- rd:15 wd:14
[163419.556133]  disk 0, o:1, dev:sde1
[163419.556201]  disk 1, o:1, dev:sdd1
[163419.556269]  disk 2, o:1, dev:sdc1
[163419.556336]  disk 3, o:1, dev:sdb1
[163419.556404]  disk 4, o:1, dev:sdi1
[163419.556471]  disk 5, o:1, dev:sdh1
[163419.556539]  disk 6, o:1, dev:sdk1
[163419.556607]  disk 7, o:1, dev:sdf1
[163419.556674]  disk 8, o:1, dev:sdm1
[163419.556742]  disk 9, o:1, dev:sdl1
[163419.556809]  disk 10, o:1, dev:sdg1
[163419.556881]  disk 12, o:1, dev:sdq1
[163419.556948]  disk 13, o:1, dev:sdp1
[163419.557016]  disk 14, o:1, dev:sdo1
[163419.557139] md2: detected capacity change from 0 to 7001471188992
[163419.557397]  md2: unknown partition table
[163613.792018] drivers/scsi/mvsas/mv_sas.c 1631:mvs_query_task:rc= 5
[163615.796001] mvsas 0000:04:00.0: Phy6 : No sig fis
[163616.000007] drivers/scsi/mvsas/mv_sas.c 1585:mvs_I_T_nexus_reset for device[6]:rc= 0
[163616.000015] ata9: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
[163616.000111] ata9: status=0x01 { Error }
[163616.000274] ata9: error=0x04 { DriveStatusError }
------=_20100506141422_58458
Content-Type: text/plain; name="messages.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="messages.txt"

May  5 06:25:18 supernas01 syslogd 1.5.0#5: restart.
May  5 06:43:02 supernas01 -- MARK --
May  5 07:03:02 supernas01 -- MARK --
May  5 07:23:02 supernas01 -- MARK --
May  5 07:43:02 supernas01 -- MARK --
May  5 08:03:02 supernas01 -- MARK --
May  5 08:23:02 supernas01 -- MARK --
May  5 08:43:02 supernas01 -- MARK --
May  5 09:03:02 supernas01 -- MARK --
May  5 09:23:02 supernas01 -- MARK --
May  5 09:43:02 supernas01 -- MARK --
May  5 10:03:02 supernas01 -- MARK --
May  5 10:23:02 supernas01 -- MARK --
May  5 10:43:02 supernas01 -- MARK --
May  5 11:03:02 supernas01 -- MARK --
May  5 11:23:02 supernas01 -- MARK --
May  5 11:43:02 supernas01 -- MARK --
May  5 12:03:02 supernas01 -- MARK --
May  5 12:23:02 supernas01 -- MARK --
May  5 12:43:02 supernas01 -- MARK --
May  5 13:03:02 supernas01 -- MARK --
May  5 13:23:02 supernas01 -- MARK --
May  5 13:43:02 supernas01 -- MARK --
May  5 14:03:02 supernas01 -- MARK --
May  5 14:23:02 supernas01 -- MARK --
May  5 14:43:02 supernas01 -- MARK --
May  5 15:03:02 supernas01 -- MARK --
May  5 15:23:02 supernas01 -- MARK --
May  5 15:43:02 supernas01 -- MARK --
May  5 16:03:02 supernas01 -- MARK --
May  5 16:23:02 supernas01 -- MARK --
May  5 16:43:02 supernas01 -- MARK --
May  5 17:03:02 supernas01 -- MARK --
May  5 17:23:02 supernas01 -- MARK --
May  5 17:43:02 supernas01 -- MARK --
May  5 18:03:02 supernas01 -- MARK --
May  5 18:23:02 supernas01 -- MARK --
May  5 18:43:02 supernas01 -- MARK --
May  5 19:03:02 supernas01 -- MARK --
May  5 19:23:02 supernas01 -- MARK --
May  5 19:43:02 supernas01 -- MARK --
May  5 20:03:02 supernas01 -- MARK --
May  5 20:23:02 supernas01 -- MARK --
May  5 20:43:02 supernas01 -- MARK --
May  5 21:03:02 supernas01 -- MARK --
May  5 21:23:02 supernas01 -- MARK --
May  5 21:43:02 supernas01 -- MARK --
May  5 22:03:02 supernas01 -- MARK --
May  5 22:23:02 supernas01 -- MARK --
May  5 22:43:02 supernas01 -- MARK --
May  5 23:03:02 supernas01 -- MARK --
May  5 23:23:02 supernas01 -- MARK --
May  5 23:43:02 supernas01 -- MARK --
May  6 00:03:02 supernas01 -- MARK --
May  6 00:23:02 supernas01 -- MARK --
May  6 00:43:02 supernas01 -- MARK --
May  6 01:03:02 supernas01 -- MARK --
May  6 01:23:02 supernas01 -- MARK --
May  6 01:43:02 supernas01 -- MARK --
May  6 02:03:02 supernas01 -- MARK --
May  6 02:23:02 supernas01 -- MARK --
May  6 02:43:02 supernas01 -- MARK --
May  6 03:03:02 supernas01 -- MARK --
May  6 03:20:51 supernas01 kernel: [127107.616125] igb: eth0 NIC Link is Down
May  6 03:20:54 supernas01 kernel: [127110.000477] igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
May  6 03:43:02 supernas01 -- MARK --
May  6 04:03:02 supernas01 -- MARK --
May  6 04:23:02 supernas01 -- MARK --
May  6 04:43:02 supernas01 -- MARK --
May  6 05:03:02 supernas01 -- MARK --
May  6 05:23:02 supernas01 -- MARK --
May  6 05:43:02 supernas01 -- MARK --
May  6 06:03:02 supernas01 -- MARK --
May  6 06:23:02 supernas01 -- MARK --
May  6 06:25:16 supernas01 syslogd 1.5.0#5: restart.
May  6 06:43:02 supernas01 -- MARK --
May  6 07:03:02 supernas01 -- MARK --
May  6 07:23:02 supernas01 -- MARK --
May  6 07:43:02 supernas01 -- MARK --
May  6 08:03:02 supernas01 -- MARK --
May  6 08:23:02 supernas01 -- MARK --
May  6 08:43:02 supernas01 -- MARK --
May  6 09:03:02 supernas01 -- MARK --
May  6 09:23:02 supernas01 -- MARK --
May  6 09:43:02 supernas01 -- MARK --
May  6 10:03:02 supernas01 -- MARK --
May  6 10:23:02 supernas01 -- MARK --
May  6 10:43:02 supernas01 -- MARK --
May  6 11:03:02 supernas01 -- MARK --
May  6 11:23:02 supernas01 -- MARK --
May  6 11:43:02 supernas01 -- MARK --
May  6 12:03:02 supernas01 -- MARK --
May  6 12:23:02 supernas01 -- MARK --
May  6 12:43:02 supernas01 -- MARK --
May  6 13:03:02 supernas01 -- MARK --
May  6 13:09:44 supernas01 kernel: [162440.178712] md: md127 stopped.
May  6 13:09:44 supernas01 kernel: [162440.178792] md: unbind<sdu>
May  6 13:09:44 supernas01 kernel: [162440.193513] md: export_rdev(sdu)
May  6 13:09:44 supernas01 kernel: [162440.193848] md127: detected capacity change from 500107771904 to 0
May  6 13:23:02 supernas01 -- MARK --
May  6 13:24:59 supernas01 kernel: [163354.981793] md: md2 stopped.
May  6 13:24:59 supernas01 kernel: [163355.065936] md: bind<sdd1>
May  6 13:24:59 supernas01 kernel: [163355.066192] md: bind<sdc1>
May  6 13:24:59 supernas01 kernel: [163355.066443] md: bind<sdb1>
May  6 13:24:59 supernas01 kernel: [163355.066696] md: bind<sdi1>
May  6 13:24:59 supernas01 kernel: [163355.066948] md: bind<sdh1>
May  6 13:24:59 supernas01 kernel: [163355.067200] md: bind<sdk1>
May  6 13:24:59 supernas01 kernel: [163355.067451] md: bind<sdf1>
May  6 13:24:59 supernas01 kernel: [163355.067790] md: bind<sdm1>
May  6 13:24:59 supernas01 kernel: [163355.068089] md: bind<sdl1>
May  6 13:24:59 supernas01 kernel: [163355.068360] md: bind<sdg1>
May  6 13:24:59 supernas01 kernel: [163355.068609] md: bind<sdj1>
May  6 13:24:59 supernas01 kernel: [163355.068933] md: bind<sdq1>
May  6 13:24:59 supernas01 kernel: [163355.069268] md: bind<sdp1>
May  6 13:24:59 supernas01 kernel: [163355.070109] md: bind<sdo1>
May  6 13:24:59 supernas01 kernel: [163355.070456] md: bind<sdn1>
May  6 13:24:59 supernas01 kernel: [163355.070698] md: bind<sde1>
May  6 13:26:01 supernas01 kernel: [163417.377269] md: md2 stopped.
May  6 13:26:01 supernas01 kernel: [163417.377355] md: unbind<sde1>
May  6 13:26:01 supernas01 kernel: [163417.400514] md: export_rdev(sde1)
May  6 13:26:01 supernas01 kernel: [163417.400602] md: unbind<sdn1>
May  6 13:26:01 supernas01 kernel: [163417.436010] md: export_rdev(sdn1)
May  6 13:26:01 supernas01 kernel: [163417.436096] md: unbind<sdo1>
May  6 13:26:01 supernas01 kernel: [163417.456013] md: export_rdev(sdo1)
May  6 13:26:01 supernas01 kernel: [163417.456098] md: unbind<sdp1>
May  6 13:26:01 supernas01 kernel: [163417.488011] md: export_rdev(sdp1)
May  6 13:26:01 supernas01 kernel: [163417.488093] md: unbind<sdq1>
May  6 13:26:01 supernas01 kernel: [163417.536013] md: export_rdev(sdq1)
May  6 13:26:01 supernas01 kernel: [163417.536102] md: unbind<sdj1>
May  6 13:26:01 supernas01 kernel: [163417.564513] md: export_rdev(sdj1)
May  6 13:26:01 supernas01 kernel: [163417.571017] md: unbind<sdg1>
May  6 13:26:01 supernas01 kernel: [163417.580509] md: export_rdev(sdg1)
May  6 13:26:01 supernas01 kernel: [163417.580595] md: unbind<sdl1>
May  6 13:26:01 supernas01 kernel: [163417.596008] md: export_rdev(sdl1)
May  6 13:26:01 supernas01 kernel: [163417.596090] md: unbind<sdm1>
May  6 13:26:01 supernas01 kernel: [163417.608009] md: export_rdev(sdm1)
May  6 13:26:01 supernas01 kernel: [163417.608093] md: unbind<sdf1>
May  6 13:26:01 supernas01 kernel: [163417.640007] md: export_rdev(sdf1)
May  6 13:26:01 supernas01 kernel: [163417.640087] md: unbind<sdk1>
May  6 13:26:01 supernas01 kernel: [163417.672006] md: export_rdev(sdk1)
May  6 13:26:01 supernas01 kernel: [163417.672090] md: unbind<sdh1>
May  6 13:26:01 supernas01 kernel: [163417.704007] md: export_rdev(sdh1)
May  6 13:26:01 supernas01 kernel: [163417.704086] md: unbind<sdi1>
May  6 13:26:01 supernas01 kernel: [163417.736007] md: export_rdev(sdi1)
May  6 13:26:01 supernas01 kernel: [163417.736090] md: unbind<sdb1>
May  6 13:26:01 supernas01 kernel: [163417.768007] md: export_rdev(sdb1)
May  6 13:26:01 supernas01 kernel: [163417.768087] md: unbind<sdc1>
May  6 13:26:01 supernas01 kernel: [163417.800007] md: export_rdev(sdc1)
May  6 13:26:01 supernas01 kernel: [163417.800090] md: unbind<sdd1>
May  6 13:26:02 supernas01 kernel: [163417.832006] md: export_rdev(sdd1)
May  6 13:26:03 supernas01 kernel: [163418.910422] md: md2 stopped.
May  6 13:26:03 supernas01 kernel: [163419.427649] md: bind<sdd1>
May  6 13:26:03 supernas01 kernel: [163419.427892] md: bind<sdc1>
May  6 13:26:03 supernas01 kernel: [163419.428142] md: bind<sdb1>
May  6 13:26:03 supernas01 kernel: [163419.428397] md: bind<sdi1>
May  6 13:26:03 supernas01 kernel: [163419.428640] md: bind<sdh1>
May  6 13:26:03 supernas01 kernel: [163419.428895] md: bind<sdk1>
May  6 13:26:03 supernas01 kernel: [163419.429151] md: bind<sdf1>
May  6 13:26:03 supernas01 kernel: [163419.429401] md: bind<sdm1>
May  6 13:26:03 supernas01 kernel: [163419.429734] md: bind<sdl1>
May  6 13:26:03 supernas01 kernel: [163419.429976] md: bind<sdg1>
May  6 13:26:03 supernas01 kernel: [163419.430221] md: bind<sdj1>
May  6 13:26:03 supernas01 kernel: [163419.430461] md: bind<sdq1>
May  6 13:26:03 supernas01 kernel: [163419.430706] md: bind<sdp1>
May  6 13:26:03 supernas01 kernel: [163419.430952] md: bind<sdo1>
May  6 13:26:03 supernas01 kernel: [163419.431198] md: bind<sdn1>
May  6 13:26:03 supernas01 kernel: [163419.453964] md: bind<sde1>
May  6 13:26:03 supernas01 kernel: [163419.454085] md: kicking non-fresh sdn1 from array!
May  6 13:26:03 supernas01 kernel: [163419.454159] md: unbind<sdn1>
May  6 13:26:03 supernas01 kernel: [163419.476007] md: export_rdev(sdn1)
May  6 13:26:03 supernas01 kernel: [163419.476088] md: kicking non-fresh sdj1 from array!
May  6 13:26:03 supernas01 kernel: [163419.476160] md: unbind<sdj1>
May  6 13:26:03 supernas01 kernel: [163419.508007] md: export_rdev(sdj1)
May  6 13:26:03 supernas01 kernel: [163419.552645] raid5: device sde1 operational as raid disk 0
May  6 13:26:03 supernas01 kernel: [163419.552718] raid5: device sdo1 operational as raid disk 14
May  6 13:26:03 supernas01 kernel: [163419.552790] raid5: device sdp1 operational as raid disk 13
May  6 13:26:03 supernas01 kernel: [163419.552861] raid5: device sdq1 operational as raid disk 12
May  6 13:26:03 supernas01 kernel: [163419.552933] raid5: device sdg1 operational as raid disk 10
May  6 13:26:03 supernas01 kernel: [163419.553010] raid5: device sdl1 operational as raid disk 9
May  6 13:26:03 supernas01 kernel: [163419.553081] raid5: device sdm1 operational as raid disk 8
May  6 13:26:03 supernas01 kernel: [163419.553152] raid5: device sdf1 operational as raid disk 7
May  6 13:26:03 supernas01 kernel: [163419.553223] raid5: device sdk1 operational as raid disk 6
May  6 13:26:03 supernas01 kernel: [163419.553295] raid5: device sdh1 operational as raid disk 5
May  6 13:26:03 supernas01 kernel: [163419.553366] raid5: device sdi1 operational as raid disk 4
May  6 13:26:03 supernas01 kernel: [163419.553437] raid5: device sdb1 operational as raid disk 3
May  6 13:26:03 supernas01 kernel: [163419.553509] raid5: device sdc1 operational as raid disk 2
May  6 13:26:03 supernas01 kernel: [163419.553580] raid5: device sdd1 operational as raid disk 1
May  6 13:26:03 supernas01 kernel: [163419.554787] raid5: allocated 15854kB for md2
May  6 13:26:03 supernas01 kernel: [163419.554893] 0: w=1 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
May  6 13:26:03 supernas01 kernel: [163419.554965] 14: w=2 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
May  6 13:26:03 supernas01 kernel: [163419.555037] 13: w=3 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
May  6 13:26:03 supernas01 kernel: [163419.555109] 12: w=4 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
May  6 13:26:03 supernas01 kernel: [163419.555180] 10: w=5 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
May  6 13:26:03 supernas01 kernel: [163419.555252] 9: w=6 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
May  6 13:26:03 supernas01 kernel: [163419.555324] 8: w=7 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
May  6 13:26:03 supernas01 kernel: [163419.555396] 7: w=8 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
May  6 13:26:03 supernas01 kernel: [163419.555467] 6: w=9 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
May  6 13:26:03 supernas01 kernel: [163419.555538] 5: w=10 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
May  6 13:26:03 supernas01 kernel: [163419.555610] 4: w=11 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
May  6 13:26:03 supernas01 kernel: [163419.555682] 3: w=12 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
May  6 13:26:03 supernas01 kernel: [163419.555754] 2: w=13 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
May  6 13:26:03 supernas01 kernel: [163419.555825] 1: w=14 pa=0 pr=15 m=1 a=2 r=15 op1=0 op2=0
May  6 13:26:03 supernas01 kernel: [163419.555990] RAID5 conf printout:
May  6 13:26:03 supernas01 kernel: [163419.556066]  --- rd:15 wd:14
May  6 13:26:03 supernas01 kernel: [163419.556133]  disk 0, o:1, dev:sde1
May  6 13:26:03 supernas01 kernel: [163419.556201]  disk 1, o:1, dev:sdd1
May  6 13:26:03 supernas01 kernel: [163419.556269]  disk 2, o:1, dev:sdc1
May  6 13:26:03 supernas01 kernel: [163419.556336]  disk 3, o:1, dev:sdb1
May  6 13:26:03 supernas01 kernel: [163419.556404]  disk 4, o:1, dev:sdi1
May  6 13:26:03 supernas01 kernel: [163419.556471]  disk 5, o:1, dev:sdh1
May  6 13:26:03 supernas01 kernel: [163419.556539]  disk 6, o:1, dev:sdk1
May  6 13:26:03 supernas01 kernel: [163419.556607]  disk 7, o:1, dev:sdf1
May  6 13:26:03 supernas01 kernel: [163419.556674]  disk 8, o:1, dev:sdm1
May  6 13:26:03 supernas01 kernel: [163419.556742]  disk 9, o:1, dev:sdl1
May  6 13:26:03 supernas01 kernel: [163419.556809]  disk 10, o:1, dev:sdg1
May  6 13:26:03 supernas01 kernel: [163419.556881]  disk 12, o:1, dev:sdq1
May  6 13:26:03 supernas01 kernel: [163419.556948]  disk 13, o:1, dev:sdp1
May  6 13:26:03 supernas01 kernel: [163419.557016]  disk 14, o:1, dev:sdo1
May  6 13:26:03 supernas01 kernel: [163419.557139] md2: detected capacity change from 0 to 7001471188992
May  6 13:26:03 supernas01 kernel: [163419.557397]  md2: unknown partition table
May  6 13:29:20 supernas01 kernel: [163616.000111] ata9: status=0x01 { Error }
May  6 13:29:20 supernas01 kernel: [163616.000274] ata9: error=0x04 { DriveStatusError }
May  6 13:43:02 supernas01 -- MARK --
May  6 14:03:02 supernas01 -- MARK --
------=_20100506141422_58458
Content-Type: text/plain; name="lspci.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="lspci.txt"

04:00.0 SCSI storage controller: Marvell Technology Group Ltd. MV64460/64461/64462 System Controller, Revision B (rev 01)
0c:00.0 SCSI storage controller: Marvell Technology Group Ltd. MV64460/64461/64462 System Controller, Revision B (rev 01)
0e:00.0 SCSI storage controller: Marvell Technology Group Ltd. MV64460/64461/64462 System Controller, Revision B (rev 01)
------=_20100506141422_58458--

