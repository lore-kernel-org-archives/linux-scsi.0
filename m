From: Yijing Wang <wangyijing@huawei.com>
Subject: Re: Fail to probe qla2xxx fiber channel card while doing pci hotplug
Date: Mon, 17 Sep 2012 20:06:27 +0800
Message-ID: <50571243.4050001@huawei.com>
References: <505456FD.6040801@huawei.com> <CAErSpo6OkAV-wwKnpMRAvisQ_Jj=w9dxLbO3JxkX2A_Vd8QX=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:31955 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab2IQMHC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Sep 2012 08:07:02 -0400
In-Reply-To: <CAErSpo6OkAV-wwKnpMRAvisQ_Jj=w9dxLbO3JxkX2A_Vd8QX=Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, PCI <linux-pci@vger.kernel.org>

On 2012/9/16 11:30, Bjorn Helgaas wrote:
> On Sat, Sep 15, 2012 at 4:22 AM, Yijing Wang <wangyijing@huawei.com> =
wrote:
>> Hi all,
>>    I encountered a very strange problem when I hot plug a fiber chan=
nel card(using qla2xxx driver).
>> I did the hotplug in arch x86 machine, using pciehp driver for hotpl=
ug, this platform supports pci hot-plug triggering from both
>> sysfs and attention button. If a hot-plug slot is empty when system =
boot-up, then hotplug FC card in this slot is ok.
>> If a hot-plug slot has been embeded a FC card when system boot-up, h=
ot-remove this card is ok, but hot-add this card will fail.
>> I used
>> #modprobe qla2xxx ql2xextended_error_logging=3D0x7fffffff
>> to get all probe info. As bellow:
>>
>> Can anyone give me any suggestion for this problem?
>=20
> It sounds like you did this:
>=20
>   1) Power down system
>   2) Remove FC card from slot
>   3) Boot system
>   4) Hot-add FC card
>   5) Load qla2xxx driver
>   6) qla2xxx driver claims FC card
>   7) FC card works correctly
>=20
>   8) Power down system
>   9) Install FC card in slot
>  10) Boot system
>  11) Load qla2xxx driver
>  12) qla2xxx driver claims FC card
>  13) FC card works correctly
I rmmod qla2xxx driver here and modprobe qla2xxx ql2xextended_error_log=
ging=3D0x1e400000 again for get errors info
Also I modprobe pciehp pciehp_debug=3D1 for getting debug info
>  14) Hot-remove card
>  15) Hot-add card
>  16) qla2xxx driver claims FC card
>  17) FC card does not work
>=20
> and I assume the dmesg log you included is just from steps 15 and 16
> (correct me if I'm wrong).
>=20
> It would be useful to see the entire log showing all these events so
> we can compare the working cases with the non-working one.  If you us=
e
> the pciehp_debug module parameter, we should also see some pciehp
> events that would help me understand that driver.
>=20

Hi Bjorn,
   Thanks for your comments very much!

My steps:
1) power down system
2) Install FC card in slot
3) Boot system
4) Load qla2xxx driver
5) qla2xxx driver claims FC card
6) FC card works correctly(at least probe return ok, I don't know qla2x=
xx driver much..)
7) rmmod qla2xxx
8) modprobe qla2xxx ql2xextended_error_logging=3D0x1e400000(for get err=
ors info)
9) modprobe pciehp pciehp_debug=3D1
10) Hot-remove card
11) Hot-add card
12) qla2xxx driver claims FC card fail(probe return fail, setup chip fa=
il)
--------------------------------------so this is failed situation------=
----

--------------------------------------continue to hot-add fc card into =
empty slot(also support pci hp)
13) Install FC card in empty slot
14) Hot-add card
15) qla2xxx driver claims FC card ok (probe return ok)

btw:
If fc card firmware version 4.03, everything is ok (hot-plug in any slo=
ts(empty or not))
fc card firmware version is 4.04 or 5.04 , situation as same as 1)--->1=
2)


log info:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc1-0.27-default (root@linux-e8yf) (=
gcc version 4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux) ) #2 SM=
P Mon Sep 17 17:21:03 CST 2012
[    0.000000] Command line: root=3D/dev/disk/by-id/raid-ddf1_GG-part3 =
resume=3D/dev/disk/by-id/raid-ddf1_GG-part2 splash=3Dsilent crashkernel=
=3D256M-:128M vga=3D0x31a
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] u=
sable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] r=
eserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] r=
eserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000079aa4fff] u=
sable
[    0.000000] BIOS-e820: [mem 0x0000000079aa5000-0x0000000079b0dfff] A=
CPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000079b0e000-0x0000000079b19fff] A=
CPI data
[    0.000000] BIOS-e820: [mem 0x0000000079b1a000-0x0000000079b2ffff] r=
eserved
[    0.000000] BIOS-e820: [mem 0x0000000079b30000-0x0000000079b30fff] A=
CPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000079b31000-0x0000000079b41fff] r=
eserved
[    0.000000] BIOS-e820: [mem 0x0000000079b42000-0x0000000079b44fff] A=
CPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000079b45000-0x0000000079b7dfff] r=
eserved
[    0.000000] BIOS-e820: [mem 0x0000000079b7e000-0x0000000079b7ffff] u=
sable
[    0.000000] BIOS-e820: [mem 0x0000000079b80000-0x0000000079b80fff] A=
CPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000079b81000-0x0000000079bb7fff] r=
eserved
[    0.000000] BIOS-e820: [mem 0x0000000079bb8000-0x0000000079bc4fff] A=
CPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000079bc5000-0x0000000079bf2fff] r=
eserved
[    0.000000] BIOS-e820: [mem 0x0000000079bf3000-0x0000000079df5fff] A=
CPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000079df6000-0x0000000079ffffff] u=
sable
[    0.000000] BIOS-e820: [mem 0x0000000080000000-0x000000008fffffff] r=
eserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] r=
eserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] r=
eserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000107bffffff] u=
sable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: HUAWEI TECHNOLOGIES CO.,LTD. rh5885/CH91RGPUC, BIOS=
 RGPUC-BIOS-V019 09/15/2012
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> =
reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x107c000 max_arch_pfn =3D 0x40000000=
0
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00000000000 mask FF000000000 write-back
[    0.000000]   1 base 01000000000 mask FFF80000000 write-back
[    0.000000]   2 base 0007C000000 mask FFFFC000000 uncachable
[    0.000000]   3 base 00080000000 mask FFF80000000 uncachable
[    0.000000]   4 base 0107C000000 mask FFFFC000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x70106=
00070106
[    0.000000] e820: update [mem 0x7c000000-0xffffffff] usable =3D=3D> =
reserved
[    0.000000] e820: last_pfn =3D 0x7a000 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd470-0x000fd47f] mapped=
 at [ffff8800000fd470]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size =
28672
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x79ffffff]
[    0.000000]  [mem 0x00000000-0x3fffffff] page 1G
[    0.000000]  [mem 0x40000000-0x79ffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x79ffffff @ [mem 0x1=
fdfe000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x107bffffff]
[    0.000000]  [mem 0x100000000-0x103fffffff] page 1G
[    0.000000]  [mem 0x1040000000-0x107bffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x107bffffff @ [mem 0=
x79ffe000-0x79ffffff]
[    0.000000] RAMDISK: [mem 0x370e1000-0x37feffff]
[    0.000000] Reserving 128MB of memory at 752MB for crashkernel (Syst=
em RAM: 65372MB)
[    0.000000] ACPI: RSDP 00000000000f0420 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0000000079b0e0a0 0008C (v01 ALASKA    A M I 0=
1072009 AMI  00010013)
[    0.000000] ACPI: FACP 0000000079b17728 000F4 (v04 ALASKA    A M I 0=
1072009 AMI  00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two =
=46ACS tables! (20120711/tbfadt-394)
[    0.000000] ACPI BIOS Bug: Warning: 32/64X FACS address mismatch in =
=46ADT - 0x79BBCF40/0x0000000079BBCF80, using 32 (20120711/tbfadt-521)
[    0.000000] ACPI: DSDT 0000000079b0e1b8 0956A (v02 ALASKA    A M I 0=
0000015 INTL 20051117)
[    0.000000] ACPI: FACS 0000000079bbcf40 00040
[    0.000000] ACPI: APIC 0000000079b17820 00288 (v01 ALASKA    A M I 0=
1072009 AMI  00010013)
[    0.000000] ACPI: SSDT 0000000079b17aa8 00876 (v01 AMICPU     PROC 0=
0000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 0000000079b18320 0003C (v01 A M I  OEMMCFG. 0=
1072009 MSFT 00000097)
[    0.000000] ACPI: SRAT 0000000079b18360 007B0 (v01 A M I  AMI SRAT 0=
0000001 AMI. 00000000)
[    0.000000] ACPI: SLIT 0000000079b18b10 0003C (v01 A M I  AMI SLIT 0=
0000000 AMI. 00000000)
[    0.000000] ACPI: HPET 0000000079b18b50 00038 (v01 A M I  ICH7HPET 0=
1072009 AMI. 00000003)
[    0.000000] ACPI: SPMI 0000000079b18b88 00040 (v05 A M I   OEMSPMI 0=
0000000 AMI. 00000000)
[    0.000000] ACPI: EINJ 0000000079b18bc8 00130 (v01    AMI AMI EINJ 0=
0000000      00000000)
[    0.000000] ACPI: ERST 0000000079b18cf8 00210 (v01  AMIER AMI ERST 0=
0000000      00000000)
[    0.000000] ACPI: HEST 0000000079b18f08 000A8 (v01    AMI AMI HEST 0=
0000000      00000000)
[    0.000000] ACPI: BERT 0000000079b18fb0 00030 (v01    AMI AMI BERT 0=
0000000      00000000)
[    0.000000] ACPI: DMAR 0000000079b18fe0 000EC (v01 A M I   OEMDMAR 0=
0000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x20 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x21 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x22 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x23 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x24 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x25 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x30 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x31 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x32 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x33 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x40 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x41 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x42 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x43 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x44 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x45 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x50 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x51 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x52 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x53 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x60 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x61 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x62 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x63 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x64 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x65 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x70 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x71 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x72 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x73 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x87fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x880000000-0x107fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=3D2
[    0.000000] NUMA: Warning: node ids are out of bound, from=3D0 to=3D=
-1 distance=3D21
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000=
000-0x87fffffff] -> [mem 0x00000000-0x87fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x87fffffff]
[    0.000000]   NODE_DATA [mem 0x87ffda000-0x87fffffff]
[    0.000000] Initmem setup node 1 [mem 0x880000000-0x107bffffff]
[    0.000000]   NODE_DATA [mem 0x107bfd9000-0x107bffefff]
[    0.000000]  [ffffea0000000000-ffffea001dbfffff] PMD -> [ffff88085fe=
00000-ffff88087bdfffff] on node 0
[    0.000000]  [ffffea001dc00000-ffffea0039bfffff] PMD -> [ffff88105b6=
00000-ffff8810775fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x107bffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x79aa4fff]
[    0.000000]   node   0: [mem 0x79b7e000-0x79b7ffff]
[    0.000000]   node   0: [mem 0x79df6000-0x79ffffff]
[    0.000000]   node   0: [mem 0x100000000-0x87fffffff]
[    0.000000]   node   1: [mem 0x880000000-0x107bffffff]
[    0.000000] On node 0 totalpages: 8363070
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 7 pages reserved
[    0.000000]   DMA zone: 3918 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 480489 pages, LIFO batch:31
[    0.000000]   Normal zone: 107520 pages used for memmap
[    0.000000]   Normal zone: 7756800 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 8372224
[    0.000000]   Normal zone: 114464 pages used for memmap
[    0.000000]   Normal zone: 8257760 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x42] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x44] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x50] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x52] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x60] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x62] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x64] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x70] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x72] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x41] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x43] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x45] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x51] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x53] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x61] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x63] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x65] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x71] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x73] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x18] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1a] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1c] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1e] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x20] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x22] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x24] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x26] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x19] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1b] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1d] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1f] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x21] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x23] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x25] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x27] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GS=
I 0-23
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec81000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 2, version 32, address 0xfec81000, GS=
I 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high lev=
el)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 40 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 0000000=
00009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 0000000=
0000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000=
0000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000=
000100000
[    0.000000] PM: Registered nosave memory: 0000000079aa5000 - 0000000=
079b0e000
[    0.000000] PM: Registered nosave memory: 0000000079b0e000 - 0000000=
079b1a000
[    0.000000] PM: Registered nosave memory: 0000000079b1a000 - 0000000=
079b30000
[    0.000000] PM: Registered nosave memory: 0000000079b30000 - 0000000=
079b31000
[    0.000000] PM: Registered nosave memory: 0000000079b31000 - 0000000=
079b42000
[    0.000000] PM: Registered nosave memory: 0000000079b42000 - 0000000=
079b45000
[    0.000000] PM: Registered nosave memory: 0000000079b45000 - 0000000=
079b7e000
[    0.000000] PM: Registered nosave memory: 0000000079b80000 - 0000000=
079b81000
[    0.000000] PM: Registered nosave memory: 0000000079b81000 - 0000000=
079bb8000
[    0.000000] PM: Registered nosave memory: 0000000079bb8000 - 0000000=
079bc5000
[    0.000000] PM: Registered nosave memory: 0000000079bc5000 - 0000000=
079bf3000
[    0.000000] PM: Registered nosave memory: 0000000079bf3000 - 0000000=
079df6000
[    0.000000] PM: Registered nosave memory: 000000007a000000 - 0000000=
080000000
[    0.000000] PM: Registered nosave memory: 0000000080000000 - 0000000=
090000000
[    0.000000] PM: Registered nosave memory: 0000000090000000 - 0000000=
0fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 0000000=
0fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 0000000=
0ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000=
100000000
[    0.000000] e820: [mem 0x90000000-0xfed1bfff] available for PCI devi=
ces
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:40 nr_cpu_ids=
:40 nr_node_ids:2
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88087f800000 s79360 r=
8192 d23040 u262144
[    0.000000] pcpu-alloc: s79360 r8192 d23040 u262144 alloc=3D1*209715=
2
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 [0] 08 09 20 21 =
22 23 24 25
[    0.000000] pcpu-alloc: [0] 26 27 28 29 -- -- -- -- [1] 10 11 12 13 =
14 15 16 17
[    0.000000] pcpu-alloc: [1] 18 19 30 31 32 33 34 35 [1] 36 37 38 39 =
-- -- -- --
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  =
Total pages: 16498967
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=3D/dev/disk/by-id/raid-ddf1_GG=
-part3 resume=3D/dev/disk/by-id/raid-ddf1_GG-part2 splash=3Dsilent cras=
hkernel=3D256M-:128M vga=3D0x31a
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 65791704k/69140480k available (4425k kernel code=
, 2199304k absent, 1149472k reserved, 6586k data, 1352k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D4096 to nr_cpu_ids=3D=
40.
[    0.000000] NR_IRQS:262400 nr_irqs:1408 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 2399.901 MHz processor
[    0.000017] Calibrating delay loop (skipped), value calculated using=
 timer frequency.. 4799.80 BogoMIPS (lpj=3D9599604)
[    0.000023] pid_max: default: 40960 minimum: 320
[    0.000085] Security Framework initialized
[    0.000108] AppArmor: AppArmor initialized
[    0.004342] Dentry cache hash table entries: 8388608 (order: 14, 671=
08864 bytes)
[    0.024122] Inode-cache hash table entries: 4194304 (order: 13, 3355=
4432 bytes)
[    0.032657] Mount-cache hash table entries: 256
[    0.032992] Initializing cgroup subsys cpuacct
[    0.032996] Initializing cgroup subsys devices
[    0.032999] Initializing cgroup subsys freezer
[    0.033002] Initializing cgroup subsys net_cls
[    0.033005] Initializing cgroup subsys blkio
[    0.033007] Initializing cgroup subsys perf_event
[    0.033059] CPU: Physical Processor ID: 0
[    0.033061] CPU: Processor Core ID: 0
[    0.033077] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.033077] ENERGY_PERF_BIAS: View and update with x86_energy_perf_p=
olicy(8)
[    0.033083] mce: CPU supports 24 MCE banks
[    0.033107] CPU0: Thermal monitoring enabled (TM1)
[    0.033126] process: using mwait in idle threads
[    0.033132] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.033132] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.033132] tlb_flushall_shift is 0x6
[    0.034746] ACPI: Core revision 20120711
[    0.040752] Switched APIC routing to physical flat.
[    0.041266] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin=
2=3D-1
[    0.080888] smpboot: CPU0: Intel(R) Xeon(R) CPU E7- 8870  @ 2.40GHz =
stepping 02
[    0.185898] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere ev=
ents, Intel PMU driver.
[    0.185907] perf_event_intel: CPUID marked event: 'bus cycles' unava=
ilable
[    0.185910] ... version:                3
[    0.185912] ... bit width:              48
[    0.185914] ... generic registers:      4
[    0.185916] ... value mask:             0000ffffffffffff
[    0.185918] ... max period:             000000007fffffff
[    0.185920] ... fixed-purpose events:   3
[    0.185922] ... event mask:             000000070000000f
[    0.187074] NMI watchdog: enabled on all CPUs, permanently consumes =
one hw-PMU counter.
[    0.187669] smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 #6=
 #7 #8 #9 OK
[    0.321625] smpboot: Booting Node   1, Processors  #10 #11 #12 #13 #=
14 #15 #16 #17 #18 #19 OK
[    0.567593] smpboot: Booting Node   0, Processors  #20 #21 #22 #23 #=
24 #25 #26 #27 #28 #29 OK
[    0.716954] smpboot: Booting Node   1, Processors  #30 #31 #32 #33 #=
34 #35 #36 #37 #38 #39 OK
[    0.865333] Brought up 40 CPUs
[    0.865337] smpboot: Total of 40 processors activated (192001.00 Bog=
oMIPS)
[    1.096250] devtmpfs: initialized
[    1.106223] PM: Registering ACPI NVS region [mem 0x79aa5000-0x79b0df=
ff] (430080 bytes)
[    1.106241] PM: Registering ACPI NVS region [mem 0x79b30000-0x79b30f=
ff] (4096 bytes)
[    1.106245] PM: Registering ACPI NVS region [mem 0x79b42000-0x79b44f=
ff] (12288 bytes)
[    1.106248] PM: Registering ACPI NVS region [mem 0x79b80000-0x79b80f=
ff] (4096 bytes)
[    1.106252] PM: Registering ACPI NVS region [mem 0x79bb8000-0x79bc4f=
ff] (53248 bytes)
[    1.106256] PM: Registering ACPI NVS region [mem 0x79bf3000-0x79df5f=
ff] (2109440 bytes)
[    1.106514] dummy:
[    1.106550] RTC time: 11:08:09, date: 09/17/12
[    1.106788] NET: Registered protocol family 16
[    1.107112] ACPI: bus type pci registered
[    1.107198] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x8000=
0000-0x8fffffff] (base 0x80000000)
[    1.107204] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in=
 E820
[    1.136343] PCI: Using configuration type 1 for base access
[    1.139199] bio: create slab <bio-0> at 0
[    1.139608] ACPI: Added _OSI(Module Device)
[    1.139612] ACPI: Added _OSI(Processor Device)
[    1.139616] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.139618] ACPI: Added _OSI(Processor Aggregator Device)
[    1.141352] ACPI: EC: Look up EC in DSDT
[    1.143261] ACPI: Executed 1 blocks of module-level executable AML c=
ode
[    1.151937] ACPI: SSDT 0000000079bb9018 0257C (v01    AMI      IST 0=
0000001 MSFT 03000001)
[    1.153697] ACPI: Dynamic OEM Table Load:
[    1.153702] ACPI: SSDT           (null) 0257C (v01    AMI      IST 0=
0000001 MSFT 03000001)
[    1.153849] ACPI: SSDT 0000000079bb8818 007A4 (v01    AMI      CST 0=
0000001 MSFT 03000001)
[    1.154778] ACPI: Dynamic OEM Table Load:
[    1.154782] ACPI: SSDT           (null) 007A4 (v01    AMI      CST 0=
0000001 MSFT 03000001)
[    1.161166] ACPI: Interpreter enabled
[    1.161173] ACPI: (supports S0 S1 S3 S4 S5)
[    1.161201] ACPI: Using IOAPIC for interrupt routing
[    1.170662] ACPI: No dock devices found.
[    1.170702] HEST: Table parsing has been initialized.
[    1.170708] PCI: Using host bridge windows from ACPI; if necessary, =
use "pci=3Dnocrs" and report a bug
[    1.170996] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7f])
[    1.171332] PCI host bridge to bus 0000:00
[    1.171338] pci_bus 0000:00: busn_res: [bus 00-7f] is inserted under=
 domain [bus 00-ff]
[    1.171340] pci_bus 0000:00: root bus resource [bus 00-7f]
[    1.171343] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.171347] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.171350] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000=
bffff]
[    1.171353] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000=
dffff]
[    1.171357] pci_bus 0000:00: root bus resource [mem 0x7c000000-0xfbf=
fffff]
[    1.171372] pci 0000:00:00.0: [8086:3407] type 00 class 0x060000
[    1.171397] pci_read_bases: dev 0000:00:00.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.171431] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.171454] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[    1.171472] pci_read_bases: dev 0000:00:01.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.171511] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.171535] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[    1.171552] pci_read_bases: dev 0000:00:03.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.171592] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.171614] pci 0000:00:05.0: [8086:340c] type 01 class 0x060400
[    1.171632] pci_read_bases: dev 0000:00:05.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.171671] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    1.171694] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[    1.171711] pci_read_bases: dev 0000:00:07.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.171750] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    1.171772] pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
[    1.171789] pci_read_bases: dev 0000:00:09.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.171828] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    1.171852] pci 0000:00:13.0: [8086:342d] type 00 class 0x080020
[    1.171862] pci 0000:00:13.0: reg 10: [mem 0xfb124000-0xfb124fff]
[    1.171892] pci_read_bases: dev 0000:00:13.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.171911] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    1.171929] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[    1.171964] pci_read_bases: dev 0000:00:14.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.171993] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[    1.172028] pci_read_bases: dev 0000:00:14.1 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.172059] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[    1.172094] pci_read_bases: dev 0000:00:14.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.172121] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
[    1.172156] pci_read_bases: dev 0000:00:14.3 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.172174] pci 0000:00:15.0: [8086:342f] type 00 class 0x080020
[    1.172209] pci_read_bases: dev 0000:00:15.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.172234] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    1.172273] pci 0000:00:1a.0: reg 20: [io  0xf0e0-0xf0ff]
[    1.172289] pci_read_bases: dev 0000:00:1a.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.172327] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
[    1.172366] pci 0000:00:1a.1: reg 20: [io  0xf0c0-0xf0df]
[    1.172386] pci_read_bases: dev 0000:00:1a.1 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.172424] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    1.172464] pci 0000:00:1a.2: reg 20: [io  0xf0a0-0xf0bf]
[    1.172479] pci_read_bases: dev 0000:00:1a.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.172525] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    1.172545] pci 0000:00:1a.7: reg 10: [mem 0xfb123000-0xfb1233ff]
[    1.172591] pci_read_bases: dev 0000:00:1a.7 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.172635] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    1.172657] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    1.172679] pci_read_bases: dev 0000:00:1c.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.172728] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.172752] pci 0000:00:1c.1: [8086:3a42] type 01 class 0x060400
[    1.172773] pci_read_bases: dev 0000:00:1c.1 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.172822] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.172846] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[    1.172867] pci_read_bases: dev 0000:00:1c.4 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.172916] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.172942] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    1.172981] pci 0000:00:1d.0: reg 20: [io  0xf080-0xf09f]
[    1.172996] pci_read_bases: dev 0000:00:1d.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.173039] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    1.173079] pci 0000:00:1d.1: reg 20: [io  0xf060-0xf07f]
[    1.173094] pci_read_bases: dev 0000:00:1d.1 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.173133] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    1.173172] pci 0000:00:1d.2: reg 20: [io  0xf040-0xf05f]
[    1.173188] pci_read_bases: dev 0000:00:1d.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.173235] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    1.173254] pci 0000:00:1d.7: reg 10: [mem 0xfb122000-0xfb1223ff]
[    1.173300] pci_read_bases: dev 0000:00:1d.7 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.173345] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.173366] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    1.173390] pci_read_bases: dev 0000:00:1e.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.173431] pci 0000:00:1f.0: [8086:3a18] type 00 class 0x060100
[    1.173498] pci_read_bases: dev 0000:00:1f.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.173550] pci 0000:00:1f.2: [8086:3a22] type 00 class 0x010601
[    1.173567] pci 0000:00:1f.2: reg 10: [io  0xf130-0xf137]
[    1.173574] pci 0000:00:1f.2: reg 14: [io  0xf120-0xf123]
[    1.173582] pci 0000:00:1f.2: reg 18: [io  0xf110-0xf117]
[    1.173589] pci 0000:00:1f.2: reg 1c: [io  0xf100-0xf103]
[    1.173596] pci 0000:00:1f.2: reg 20: [io  0xf020-0xf03f]
[    1.173604] pci 0000:00:1f.2: reg 24: [mem 0xfb121000-0xfb1217ff]
[    1.173612] pci_read_bases: dev 0000:00:1f.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.173652] pci 0000:00:1f.2: PME# supported from D3hot
[    1.173671] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    1.173685] pci 0000:00:1f.3: reg 10: [mem 0xfb120000-0xfb1200ff 64b=
it]
[    1.173704] pci 0000:00:1f.3: reg 20: [io  0xf000-0xf01f]
[    1.173719] pci_read_bases: dev 0000:00:1f.3 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.173766] pci_bus 0000:01: busn_res: [bus 01-02] is inserted under=
 [bus 00-7f]
[    1.173785] pci 0000:01:00.0: [8086:10c9] type 00 class 0x020000
[    1.173796] pci 0000:01:00.0: reg 10: [mem 0xf6020000-0xf603ffff]
[    1.173805] pci 0000:01:00.0: reg 14: [mem 0xf5c00000-0xf5ffffff]
[    1.173814] pci 0000:01:00.0: reg 18: [io  0xe020-0xe03f]
[    1.173823] pci 0000:01:00.0: reg 1c: [mem 0xf60c4000-0xf60c7fff]
[    1.173846] pci 0000:01:00.0: reg 30: [mem 0xf5800000-0xf5bfffff pre=
f]
[    1.173848] pci_read_bases: dev 0000:01:00.0 flag 4e200 ROM [mem 0xf=
5800000-0xf5bfffff pref]
[    1.173895] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    1.173932] pci 0000:01:00.0: reg 184: [mem 0xf60a0000-0xf60a3fff 64=
bit]
[    1.173949] pci 0000:01:00.0: reg 190: [mem 0xf6080000-0xf6083fff 64=
bit]
[    1.173980] pci 0000:01:00.1: [8086:10c9] type 00 class 0x020000
[    1.173991] pci 0000:01:00.1: reg 10: [mem 0xf6000000-0xf601ffff]
[    1.173999] pci 0000:01:00.1: reg 14: [mem 0xf5400000-0xf57fffff]
[    1.174008] pci 0000:01:00.1: reg 18: [io  0xe000-0xe01f]
[    1.174017] pci 0000:01:00.1: reg 1c: [mem 0xf60c0000-0xf60c3fff]
[    1.174039] pci 0000:01:00.1: reg 30: [mem 0xf5000000-0xf53fffff pre=
f]
[    1.174042] pci_read_bases: dev 0000:01:00.1 flag 4e200 ROM [mem 0xf=
5000000-0xf53fffff pref]
[    1.174088] pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
[    1.174119] pci 0000:01:00.1: reg 184: [mem 0xf6060000-0xf6063fff 64=
bit]
[    1.174136] pci 0000:01:00.1: reg 190: [mem 0xf6040000-0xf6043fff 64=
bit]
[    1.180384] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    1.180395] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    1.180398] pci 0000:00:01.0:   bridge window [mem 0xf5000000-0xf60f=
ffff]
[    1.180403] pci 0000:00:01.0:   bridge window [mem 0xf3000000-0xf3ff=
ffff 64bit pref]
[    1.180436] pci_bus 0000:03: busn_res: [bus 03-04] is inserted under=
 [bus 00-7f]
[    1.180439] pci 0000:00:03.0: PCI bridge to [bus 03-04]
[    1.180443] pci 0000:00:03.0:   bridge window [io  0xd000-0xdfff]
[    1.180446] pci 0000:00:03.0:   bridge window [mem 0xfa000000-0xfaff=
ffff]
[    1.180451] pci 0000:00:03.0:   bridge window [mem 0xf2000000-0xf2ff=
ffff 64bit pref]
[    1.180483] pci_bus 0000:05: busn_res: [bus 05] is inserted under [b=
us 00-7f]
[    1.180486] pci 0000:00:05.0: PCI bridge to [bus 05]
[    1.180524] pci_bus 0000:06: busn_res: [bus 06-07] is inserted under=
 [bus 00-7f]
[    1.180527] pci 0000:00:07.0: PCI bridge to [bus 06-07]
[    1.180531] pci 0000:00:07.0:   bridge window [io  0xc000-0xcfff]
[    1.180534] pci 0000:00:07.0:   bridge window [mem 0xf9000000-0xf9ff=
ffff]
[    1.180538] pci 0000:00:07.0:   bridge window [mem 0xf1000000-0xf1ff=
ffff 64bit pref]
[    1.180570] pci_bus 0000:08: busn_res: [bus 08-09] is inserted under=
 [bus 00-7f]
[    1.180584] pci 0000:08:00.0: [1077:2532] type 00 class 0x0c0400
[    1.180594] pci 0000:08:00.0: reg 10: [io  0xb100-0xb1ff]
[    1.180604] pci 0000:08:00.0: reg 14: [mem 0xf8084000-0xf8087fff 64b=
it]
[    1.180628] pci 0000:08:00.0: reg 30: [mem 0xf8040000-0xf807ffff pre=
f]
[    1.180631] pci_read_bases: dev 0000:08:00.0 flag 4e200 ROM [mem 0xf=
8040000-0xf807ffff pref]
[    1.180695] pci 0000:08:00.1: [1077:2532] type 00 class 0x0c0400
[    1.180704] pci 0000:08:00.1: reg 10: [io  0xb000-0xb0ff]
[    1.180714] pci 0000:08:00.1: reg 14: [mem 0xf8080000-0xf8083fff 64b=
it]
[    1.180738] pci 0000:08:00.1: reg 30: [mem 0xf8000000-0xf803ffff pre=
f]
[    1.180740] pci_read_bases: dev 0000:08:00.1 flag 4e200 ROM [mem 0xf=
8000000-0xf803ffff pref]
[    1.188369] pci 0000:00:09.0: PCI bridge to [bus 08-09]
[    1.188379] pci 0000:00:09.0:   bridge window [io  0xb000-0xbfff]
[    1.188384] pci 0000:00:09.0:   bridge window [mem 0xf8000000-0xf8ff=
ffff]
[    1.188393] pci 0000:00:09.0:   bridge window [mem 0xf0000000-0xf0ff=
ffff 64bit pref]
[    1.188448] pci_bus 0000:0a: busn_res: [bus 0a] is inserted under [b=
us 00-7f]
[    1.188454] pci 0000:00:1c.0: PCI bridge to [bus 0a]
[    1.188503] pci_bus 0000:0b: busn_res: [bus 0b] is inserted under [b=
us 00-7f]
[    1.188526] pci 0000:0b:00.0: [19aa:e004] type 00 class 0x118000
[    1.188547] pci 0000:0b:00.0: reg 10: [mem 0xf7000000-0xf7ffffff]
[    1.188639] pci_read_bases: dev 0000:0b:00.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.196360] pci 0000:00:1c.1: PCI bridge to [bus 0b]
[    1.196375] pci 0000:00:1c.1:   bridge window [mem 0xf7000000-0xf7ff=
ffff]
[    1.196415] pci_bus 0000:0c: busn_res: [bus 0c] is inserted under [b=
us 00-7f]
[    1.196435] pci 0000:0c:00.0: [18ca:0027] type 00 class 0x030000
[    1.196449] pci 0000:0c:00.0: reg 10: [mem 0xec000000-0xefffffff pre=
f]
[    1.196461] pci 0000:0c:00.0: reg 14: [mem 0xfb000000-0xfb03ffff]
[    1.196472] pci 0000:0c:00.0: reg 18: [io  0xa000-0xa07f]
[    1.196515] pci_read_bases: dev 0000:0c:00.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.196572] pci 0000:0c:00.0: supports D1 D2
[    1.204345] pci 0000:00:1c.4: PCI bridge to [bus 0c]
[    1.204358] pci 0000:00:1c.4:   bridge window [io  0xa000-0xafff]
[    1.204362] pci 0000:00:1c.4:   bridge window [mem 0xfb000000-0xfb0f=
ffff]
[    1.204367] pci 0000:00:1c.4:   bridge window [mem 0xec000000-0xefff=
ffff 64bit pref]
[    1.204389] pci_bus 0000:0d: busn_res: [bus 0d] is inserted under [b=
us 00-7f]
[    1.204427] pci 0000:00:1e.0: PCI bridge to [bus 0d] (subtractive de=
code)
[    1.204438] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (s=
ubtractive decode)
[    1.204440] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (s=
ubtractive decode)
[    1.204442] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000b=
ffff] (subtractive decode)
[    1.204443] pci 0000:00:1e.0:   bridge window [mem 0x000c8000-0x000d=
ffff] (subtractive decode)
[    1.204445] pci 0000:00:1e.0:   bridge window [mem 0x7c000000-0xfbff=
ffff] (subtractive decode)
[    1.204478] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.204812] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
[    1.204895] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
[    1.204979] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
[    1.205055] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9._PRT]
[    1.205138] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    1.205296] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    1.205337] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    1.205382] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    1.205534]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.205740]  pci0000:00: ACPI _OSC control (0x1d) granted
[    1.219487] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 =
14 15)
[    1.219549] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 =
14 15)
[    1.219608] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 10 11 12 =
14 15)
[    1.219666] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 10 11 12 =
14 15)
[    1.219724] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 1=
4 15) *0
[    1.219783] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12 =
14 15)
[    1.219840] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 1=
4 15) *0
[    1.219901] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 =
14 15)
[    1.220035] vgaarb: device added: PCI:0000:0c:00.0,decodes=3Dio+mem,=
owns=3Dio+mem,locks=3Dnone
[    1.220048] vgaarb: loaded
[    1.220050] vgaarb: bridge control possible 0000:0c:00.0
[    1.220177] PCI: Using ACPI for IRQ routing
[    1.225951] PCI: Discovered peer bus fe
[    1.225954] PCI: root bus fe: using default resources
[    1.225956] PCI: Probing PCI hardware (bus fe)
[    1.225988] PCI host bridge to bus 0000:fe
[    1.225992] pci_bus 0000:fe: root bus resource [io  0x0000-0xffff]
[    1.225995] pci_bus 0000:fe: root bus resource [mem 0x00000000-0xfff=
ffffffff]
[    1.225999] pci_bus 0000:fe: No busn resource found for root bus, wi=
ll use [bus fe-ff]
[    1.226003] pci_bus 0000:fe: busn_res: [bus fe-ff] is inserted under=
 domain [bus 00-ff]
[    1.226009] pci 0000:fe:00.0: [8086:2b00] type 00 class 0x060000
[    1.226024] pci_read_bases: dev 0000:fe:00.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226039] pci 0000:fe:00.2: [8086:2b02] type 00 class 0x060000
[    1.226053] pci_read_bases: dev 0000:fe:00.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226066] pci 0000:fe:00.4: [8086:2b22] type 00 class 0x060000
[    1.226080] pci_read_bases: dev 0000:fe:00.4 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226094] pci 0000:fe:00.6: [8086:2b2a] type 00 class 0x060000
[    1.226108] pci_read_bases: dev 0000:fe:00.6 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226122] pci 0000:fe:01.0: [8086:2b04] type 00 class 0x060000
[    1.226136] pci_read_bases: dev 0000:fe:01.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226152] pci 0000:fe:02.0: [8086:2b08] type 00 class 0x060000
[    1.226166] pci_read_bases: dev 0000:fe:02.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226182] pci 0000:fe:03.0: [8086:2b0c] type 00 class 0x060000
[    1.226196] pci_read_bases: dev 0000:fe:03.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226212] pci 0000:fe:04.0: [8086:2b10] type 00 class 0x060000
[    1.226226] pci_read_bases: dev 0000:fe:04.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226242] pci 0000:fe:05.0: [8086:2b14] type 00 class 0x060000
[    1.226256] pci_read_bases: dev 0000:fe:05.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226269] pci 0000:fe:05.2: [8086:2b16] type 00 class 0x060000
[    1.226283] pci_read_bases: dev 0000:fe:05.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226297] pci 0000:fe:05.4: [8086:2b13] type 00 class 0x060000
[    1.226311] pci_read_bases: dev 0000:fe:05.4 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226324] pci 0000:fe:05.6: [8086:2b53] type 00 class 0x060000
[    1.226338] pci_read_bases: dev 0000:fe:05.6 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226352] pci 0000:fe:06.0: [8086:2b18] type 00 class 0x060000
[    1.226366] pci_read_bases: dev 0000:fe:06.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226382] pci 0000:fe:07.0: [8086:2b1c] type 00 class 0x060000
[    1.226396] pci_read_bases: dev 0000:fe:07.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226410] pci 0000:fe:07.2: [8086:2b1e] type 00 class 0x060000
[    1.226424] pci_read_bases: dev 0000:fe:07.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226437] pci 0000:fe:07.4: [8086:2b1b] type 00 class 0x060000
[    1.226451] pci_read_bases: dev 0000:fe:07.4 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226465] pci 0000:fe:07.6: [8086:2b5b] type 00 class 0x060000
[    1.226479] pci_read_bases: dev 0000:fe:07.6 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226492] pci 0000:fe:08.0: [8086:2b20] type 00 class 0x060000
[    1.226506] pci_read_bases: dev 0000:fe:08.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226522] pci 0000:fe:09.0: [8086:2b24] type 00 class 0x060000
[    1.226536] pci_read_bases: dev 0000:fe:09.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226553] pci 0000:fe:0a.0: [8086:2b28] type 00 class 0x060000
[    1.226567] pci_read_bases: dev 0000:fe:0a.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226587] pci 0000:fe:0b.0: [8086:2b2c] type 00 class 0x060000
[    1.226601] pci_read_bases: dev 0000:fe:0b.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226617] pci 0000:fe:0c.0: [8086:2b30] type 00 class 0x060000
[    1.226631] pci_read_bases: dev 0000:fe:0c.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226648] pci 0000:fe:0d.0: [8086:2b34] type 00 class 0x060000
[    1.226662] pci_read_bases: dev 0000:fe:0d.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226678] pci 0000:fe:0e.0: [8086:2b38] type 00 class 0x060000
[    1.226692] pci_read_bases: dev 0000:fe:0e.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226709] pci 0000:fe:0f.0: [8086:2b3c] type 00 class 0x060000
[    1.226723] pci_read_bases: dev 0000:fe:0f.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226739] pci 0000:fe:10.0: [8086:2b40] type 00 class 0x060000
[    1.226753] pci_read_bases: dev 0000:fe:10.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226766] pci 0000:fe:10.2: [8086:2b42] type 00 class 0x060000
[    1.226780] pci_read_bases: dev 0000:fe:10.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226794] pci 0000:fe:10.4: [8086:2b32] type 00 class 0x060000
[    1.226808] pci_read_bases: dev 0000:fe:10.4 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226821] pci 0000:fe:10.6: [8086:2b3a] type 00 class 0x060000
[    1.226835] pci_read_bases: dev 0000:fe:10.6 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226848] pci 0000:fe:11.0: [8086:2b44] type 00 class 0x060000
[    1.226862] pci_read_bases: dev 0000:fe:11.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226875] pci 0000:fe:11.2: [8086:2b46] type 00 class 0x060000
[    1.226889] pci_read_bases: dev 0000:fe:11.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226903] pci 0000:fe:11.4: [8086:2b36] type 00 class 0x060000
[    1.226917] pci_read_bases: dev 0000:fe:11.4 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226930] pci 0000:fe:11.6: [8086:2b3e] type 00 class 0x060000
[    1.226944] pci_read_bases: dev 0000:fe:11.6 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226958] pci 0000:fe:12.0: [8086:2b48] type 00 class 0x060000
[    1.226971] pci_read_bases: dev 0000:fe:12.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.226989] pci 0000:fe:13.0: [8086:2b4c] type 00 class 0x060000
[    1.227003] pci_read_bases: dev 0000:fe:13.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.227020] pci 0000:fe:14.0: [8086:2b50] type 00 class 0x060000
[    1.227034] pci_read_bases: dev 0000:fe:14.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.227047] pci 0000:fe:14.2: [8086:2b52] type 00 class 0x060000
[    1.227061] pci_read_bases: dev 0000:fe:14.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.227078] pci 0000:fe:17.0: [8086:2b5c] type 00 class 0x060000
[    1.227092] pci_read_bases: dev 0000:fe:17.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.227105] pci 0000:fe:17.2: [8086:2b5e] type 00 class 0x060000
[    1.227119] pci_read_bases: dev 0000:fe:17.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.227135] pci 0000:fe:18.0: [8086:2b60] type 00 class 0x060000
[    1.227149] pci_read_bases: dev 0000:fe:18.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.227163] pci 0000:fe:18.2: [8086:2b62] type 00 class 0x060000
[    1.227177] pci_read_bases: dev 0000:fe:18.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.227193] pci 0000:fe:19.0: [8086:2b64] type 00 class 0x060000
[    1.227207] pci_read_bases: dev 0000:fe:19.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.227220] pci 0000:fe:19.2: [8086:2b66] type 00 class 0x060000
[    1.227234] pci_read_bases: dev 0000:fe:19.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.227250] pci 0000:fe:1a.0: [8086:2b68] type 00 class 0x060000
[    1.227264] pci_read_bases: dev 0000:fe:1a.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.227282] pci 0000:fe:1b.0: [8086:2b6c] type 00 class 0x060000
[    1.227296] pci_read_bases: dev 0000:fe:1b.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.227314] pci_bus 0000:fe: busn_res: [bus fe-ff] end is updated to=
 fe
[    1.228186] PCI: Discovered peer bus ff
[    1.228189] PCI: root bus ff: using default resources
[    1.228190] PCI: Probing PCI hardware (bus ff)
[    1.228214] PCI host bridge to bus 0000:ff
[    1.228218] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    1.228223] pci_bus 0000:ff: root bus resource [mem 0x00000000-0xfff=
ffffffff]
[    1.228226] pci_bus 0000:ff: No busn resource found for root bus, wi=
ll use [bus ff-ff]
[    1.228230] pci_bus 0000:ff: busn_res: [bus ff] is inserted under do=
main [bus 00-ff]
[    1.228236] pci 0000:ff:00.0: [8086:2b00] type 00 class 0x060000
[    1.228249] pci_read_bases: dev 0000:ff:00.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228263] pci 0000:ff:00.2: [8086:2b02] type 00 class 0x060000
[    1.228276] pci_read_bases: dev 0000:ff:00.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228293] pci 0000:ff:00.4: [8086:2b22] type 00 class 0x060000
[    1.228306] pci_read_bases: dev 0000:ff:00.4 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228319] pci 0000:ff:00.6: [8086:2b2a] type 00 class 0x060000
[    1.228331] pci_read_bases: dev 0000:ff:00.6 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228344] pci 0000:ff:01.0: [8086:2b04] type 00 class 0x060000
[    1.228357] pci_read_bases: dev 0000:ff:01.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228372] pci 0000:ff:02.0: [8086:2b08] type 00 class 0x060000
[    1.228384] pci_read_bases: dev 0000:ff:02.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228399] pci 0000:ff:03.0: [8086:2b0c] type 00 class 0x060000
[    1.228412] pci_read_bases: dev 0000:ff:03.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228427] pci 0000:ff:04.0: [8086:2b10] type 00 class 0x060000
[    1.228439] pci_read_bases: dev 0000:ff:04.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228454] pci 0000:ff:05.0: [8086:2b14] type 00 class 0x060000
[    1.228467] pci_read_bases: dev 0000:ff:05.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228479] pci 0000:ff:05.2: [8086:2b16] type 00 class 0x060000
[    1.228492] pci_read_bases: dev 0000:ff:05.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228504] pci 0000:ff:05.4: [8086:2b13] type 00 class 0x060000
[    1.228517] pci_read_bases: dev 0000:ff:05.4 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228529] pci 0000:ff:05.6: [8086:2b53] type 00 class 0x060000
[    1.228542] pci_read_bases: dev 0000:ff:05.6 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228555] pci 0000:ff:06.0: [8086:2b18] type 00 class 0x060000
[    1.228567] pci_read_bases: dev 0000:ff:06.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228586] pci 0000:ff:07.0: [8086:2b1c] type 00 class 0x060000
[    1.228598] pci_read_bases: dev 0000:ff:07.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228611] pci 0000:ff:07.2: [8086:2b1e] type 00 class 0x060000
[    1.228623] pci_read_bases: dev 0000:ff:07.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228635] pci 0000:ff:07.4: [8086:2b1b] type 00 class 0x060000
[    1.228648] pci_read_bases: dev 0000:ff:07.4 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228660] pci 0000:ff:07.6: [8086:2b5b] type 00 class 0x060000
[    1.228673] pci_read_bases: dev 0000:ff:07.6 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228685] pci 0000:ff:08.0: [8086:2b20] type 00 class 0x060000
[    1.228698] pci_read_bases: dev 0000:ff:08.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228713] pci 0000:ff:09.0: [8086:2b24] type 00 class 0x060000
[    1.228726] pci_read_bases: dev 0000:ff:09.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228741] pci 0000:ff:0a.0: [8086:2b28] type 00 class 0x060000
[    1.228754] pci_read_bases: dev 0000:ff:0a.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228769] pci 0000:ff:0b.0: [8086:2b2c] type 00 class 0x060000
[    1.228782] pci_read_bases: dev 0000:ff:0b.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228797] pci 0000:ff:0c.0: [8086:2b30] type 00 class 0x060000
[    1.228810] pci_read_bases: dev 0000:ff:0c.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228825] pci 0000:ff:0d.0: [8086:2b34] type 00 class 0x060000
[    1.228838] pci_read_bases: dev 0000:ff:0d.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228853] pci 0000:ff:0e.0: [8086:2b38] type 00 class 0x060000
[    1.228866] pci_read_bases: dev 0000:ff:0e.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228881] pci 0000:ff:0f.0: [8086:2b3c] type 00 class 0x060000
[    1.228894] pci_read_bases: dev 0000:ff:0f.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228910] pci 0000:ff:10.0: [8086:2b40] type 00 class 0x060000
[    1.228922] pci_read_bases: dev 0000:ff:10.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228935] pci 0000:ff:10.2: [8086:2b42] type 00 class 0x060000
[    1.228947] pci_read_bases: dev 0000:ff:10.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228959] pci 0000:ff:10.4: [8086:2b32] type 00 class 0x060000
[    1.228972] pci_read_bases: dev 0000:ff:10.4 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.228985] pci 0000:ff:10.6: [8086:2b3a] type 00 class 0x060000
[    1.228997] pci_read_bases: dev 0000:ff:10.6 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.229010] pci 0000:ff:11.0: [8086:2b44] type 00 class 0x060000
[    1.229022] pci_read_bases: dev 0000:ff:11.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.229035] pci 0000:ff:11.2: [8086:2b46] type 00 class 0x060000
[    1.229047] pci_read_bases: dev 0000:ff:11.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.229060] pci 0000:ff:11.4: [8086:2b36] type 00 class 0x060000
[    1.229072] pci_read_bases: dev 0000:ff:11.4 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.229085] pci 0000:ff:11.6: [8086:2b3e] type 00 class 0x060000
[    1.229097] pci_read_bases: dev 0000:ff:11.6 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.229110] pci 0000:ff:12.0: [8086:2b48] type 00 class 0x060000
[    1.229122] pci_read_bases: dev 0000:ff:12.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.229140] pci 0000:ff:13.0: [8086:2b4c] type 00 class 0x060000
[    1.229152] pci_read_bases: dev 0000:ff:13.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.229169] pci 0000:ff:15.0: [8086:2b54] type 00 class 0x060000
[    1.229182] pci_read_bases: dev 0000:ff:15.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.229195] pci 0000:ff:15.2: [8086:2b56] type 00 class 0x060000
[    1.229207] pci_read_bases: dev 0000:ff:15.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.229223] pci 0000:ff:17.0: [8086:2b5c] type 00 class 0x060000
[    1.229236] pci_read_bases: dev 0000:ff:17.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.229249] pci 0000:ff:17.2: [8086:2b5e] type 00 class 0x060000
[    1.229261] pci_read_bases: dev 0000:ff:17.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.229277] pci 0000:ff:18.0: [8086:2b60] type 00 class 0x060000
[    1.229289] pci_read_bases: dev 0000:ff:18.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.229303] pci 0000:ff:18.2: [8086:2b62] type 00 class 0x060000
[    1.229315] pci_read_bases: dev 0000:ff:18.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.229331] pci 0000:ff:19.0: [8086:2b64] type 00 class 0x060000
[    1.229343] pci_read_bases: dev 0000:ff:19.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.229357] pci 0000:ff:19.2: [8086:2b66] type 00 class 0x060000
[    1.229369] pci_read_bases: dev 0000:ff:19.2 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.229388] pci 0000:ff:1a.0: [8086:2b68] type 00 class 0x060000
[    1.229401] pci_read_bases: dev 0000:ff:1a.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.229418] pci 0000:ff:1b.0: [8086:2b6c] type 00 class 0x060000
[    1.229431] pci_read_bases: dev 0000:ff:1b.0 flag 0 ROM [??? 0x00000=
000 flags 0x0]
[    1.229447] pci_bus 0000:ff: busn_res: [bus ff] end is updated to ff
[    1.230310] PCI: pci_cache_line_size set to 64 bytes
[    1.230553] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    1.230555] e820: reserve RAM buffer [mem 0x79aa5000-0x7bffffff]
[    1.230559] e820: reserve RAM buffer [mem 0x79b80000-0x7bffffff]
[    1.230562] e820: reserve RAM buffer [mem 0x7a000000-0x7bffffff]
[    1.230681] NetLabel: Initializing
[    1.230684] NetLabel:  domain hash size =3D 128
[    1.230686] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    1.230700] NetLabel:  unlabeled traffic allowed by default
[    1.230716] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.230722] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    1.232780] Switching to clocksource hpet
[    1.235084] AppArmor: AppArmor Filesystem Enabled
[    1.235111] pnp: PnP ACPI init
[    1.235127] ACPI: bus type pnp registered
[    1.235328] pnp 00:00: [bus 00-7f]
[    1.235331] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.235333] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.235335] pnp 00:00: [io  0x0d00-0xffff window]
[    1.235338] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.235340] pnp 00:00: [mem 0x000c8000-0x000dffff window]
[    1.235342] pnp 00:00: [mem 0x7c000000-0xfbffffff window]
[    1.235344] pnp 00:00: [mem 0x00000000 window]
[    1.235410] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a0=
3 (active)
[    1.235425] pnp 00:01: [mem 0xfc000000-0xfcffffff]
[    1.235427] pnp 00:01: [mem 0xfd000000-0xfdffffff]
[    1.235429] pnp 00:01: [mem 0xfe000000-0xfe9fffff]
[    1.235431] pnp 00:01: [mem 0xfea00000-0xfea0001f]
[    1.235433] pnp 00:01: [mem 0xfeb00000-0xfebfffff]
[    1.235435] pnp 00:01: [mem 0xfed00400-0xfed3ffff]
[    1.235437] pnp 00:01: [mem 0xfed45000-0xfedfffff]
[    1.235532] system 00:01: [mem 0xfc000000-0xfcffffff] has been reser=
ved
[    1.235537] system 00:01: [mem 0xfd000000-0xfdffffff] has been reser=
ved
[    1.235540] system 00:01: [mem 0xfe000000-0xfe9fffff] has been reser=
ved
[    1.235544] system 00:01: [mem 0xfea00000-0xfea0001f] has been reser=
ved
[    1.235548] system 00:01: [mem 0xfeb00000-0xfebfffff] has been reser=
ved
[    1.235552] system 00:01: [mem 0xfed00400-0xfed3ffff] could not be r=
eserved
[    1.235555] system 00:01: [mem 0xfed45000-0xfedfffff] has been reser=
ved
[    1.235560] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (ac=
tive)
[    1.235766] pnp 00:02: [dma 4]
[    1.235768] pnp 00:02: [io  0x0000-0x000f]
[    1.235770] pnp 00:02: [io  0x0081-0x0083]
[    1.235772] pnp 00:02: [io  0x0087]
[    1.235774] pnp 00:02: [io  0x0089-0x008b]
[    1.235776] pnp 00:02: [io  0x008f]
[    1.235778] pnp 00:02: [io  0x00c0-0x00df]
[    1.235823] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (activ=
e)
[    1.235838] pnp 00:03: [io  0x0070-0x0071]
[    1.235849] pnp 00:03: [irq 8]
[    1.235881] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (activ=
e)
[    1.235891] pnp 00:04: [io  0x0061]
[    1.235922] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (activ=
e)
[    1.235943] pnp 00:05: [io  0x0010-0x001f]
[    1.235946] pnp 00:05: [io  0x0022-0x003f]
[    1.235948] pnp 00:05: [io  0x0044-0x005f]
[    1.235950] pnp 00:05: [io  0x0062-0x0063]
[    1.235952] pnp 00:05: [io  0x0065-0x006f]
[    1.235953] pnp 00:05: [io  0x0072-0x007f]
[    1.235955] pnp 00:05: [io  0x0080]
[    1.235957] pnp 00:05: [io  0x0084-0x0086]
[    1.235959] pnp 00:05: [io  0x0088]
[    1.235961] pnp 00:05: [io  0x008c-0x008e]
[    1.235962] pnp 00:05: [io  0x0090-0x009f]
[    1.235964] pnp 00:05: [io  0x00a2-0x00bf]
[    1.235966] pnp 00:05: [io  0x00e0-0x00ef]
[    1.235968] pnp 00:05: [io  0x04d0-0x04d1]
[    1.236066] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    1.236072] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (ac=
tive)
[    1.236083] pnp 00:06: [io  0x00f0-0x00ff]
[    1.236090] pnp 00:06: [irq 13]
[    1.236123] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (activ=
e)
[    1.236385] pnp 00:07: [io  0x0400-0x047f]
[    1.236387] pnp 00:07: [io  0x1180-0x119f]
[    1.236389] pnp 00:07: [io  0x0500-0x057f]
[    1.236391] pnp 00:07: [mem 0xfed1c000-0xfed1ffff]
[    1.236393] pnp 00:07: [mem 0xfec00000-0xfecfffff]
[    1.236395] pnp 00:07: [mem 0xff000000-0xffffffff]
[    1.236491] system 00:07: [io  0x0400-0x047f] has been reserved
[    1.236496] system 00:07: [io  0x1180-0x119f] has been reserved
[    1.236500] system 00:07: [io  0x0500-0x057f] has been reserved
[    1.236504] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reser=
ved
[    1.236508] system 00:07: [mem 0xfec00000-0xfecfffff] could not be r=
eserved
[    1.236512] system 00:07: [mem 0xff000000-0xffffffff] has been reser=
ved
[    1.236516] system 00:07: Plug and Play ACPI device, IDs PNP0c01 (ac=
tive)
[    1.236635] pnp 00:08: [mem 0xfed00000-0xfed003ff]
[    1.236677] pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (activ=
e)
[    1.236896] pnp: PnP ACPI: found 9 devices
[    1.236899] ACPI: ACPI bus type pnp unregistered
[    1.245073] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [=
bus 0a] add_size 1000
[    1.245077] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fff=
ff 64bit pref] to [bus 0a] add_size 200000
[    1.245080] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fff=
ff] to [bus 0a] add_size 200000
[    1.245088] pci 0000:00:1c.1: bridge window [io  0x1000-0x0fff] to [=
bus 0b] add_size 1000
[    1.245091] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fff=
ff 64bit pref] to [bus 0b] add_size 200000
[    1.245116] pci 0000:00:1c.0: res[14]=3D[mem 0x00100000-0x000fffff] =
get_res_add_size add_size 200000
[    1.245118] pci 0000:00:1c.0: res[15]=3D[mem 0x00100000-0x000fffff 6=
4bit pref] get_res_add_size add_size 200000
[    1.245120] pci 0000:00:1c.1: res[15]=3D[mem 0x00100000-0x000fffff 6=
4bit pref] get_res_add_size add_size 200000
[    1.245122] pci 0000:00:1c.0: res[13]=3D[io  0x1000-0x0fff] get_res_=
add_size add_size 1000
[    1.245124] pci 0000:00:1c.1: res[13]=3D[io  0x1000-0x0fff] get_res_=
add_size add_size 1000
[    1.245128] pci 0000:00:1c.0: BAR 14: assigned [mem 0x7c000000-0x7c1=
fffff]
[    1.245133] pci 0000:00:1c.0: BAR 15: assigned [mem 0x7c200000-0x7c3=
fffff 64bit pref]
[    1.245137] pci 0000:00:1c.1: BAR 15: assigned [mem 0x7c400000-0x7c5=
fffff 64bit pref]
[    1.245142] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    1.245145] pci 0000:00:1c.1: BAR 13: assigned [io  0x3000-0x3fff]
[    1.245150] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    1.245154] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    1.245159] pci 0000:00:01.0:   bridge window [mem 0xf5000000-0xf60f=
ffff]
[    1.245164] pci 0000:00:01.0:   bridge window [mem 0xf3000000-0xf3ff=
ffff 64bit pref]
[    1.245170] pci 0000:00:03.0: PCI bridge to [bus 03-04]
[    1.245174] pci 0000:00:03.0:   bridge window [io  0xd000-0xdfff]
[    1.245179] pci 0000:00:03.0:   bridge window [mem 0xfa000000-0xfaff=
ffff]
[    1.245183] pci 0000:00:03.0:   bridge window [mem 0xf2000000-0xf2ff=
ffff 64bit pref]
[    1.245189] pci 0000:00:05.0: PCI bridge to [bus 05]
[    1.245198] pci 0000:00:07.0: PCI bridge to [bus 06-07]
[    1.245202] pci 0000:00:07.0:   bridge window [io  0xc000-0xcfff]
[    1.245207] pci 0000:00:07.0:   bridge window [mem 0xf9000000-0xf9ff=
ffff]
[    1.245211] pci 0000:00:07.0:   bridge window [mem 0xf1000000-0xf1ff=
ffff 64bit pref]
[    1.245218] pci 0000:00:09.0: PCI bridge to [bus 08-09]
[    1.245221] pci 0000:00:09.0:   bridge window [io  0xb000-0xbfff]
[    1.245226] pci 0000:00:09.0:   bridge window [mem 0xf8000000-0xf8ff=
ffff]
[    1.245230] pci 0000:00:09.0:   bridge window [mem 0xf0000000-0xf0ff=
ffff 64bit pref]
[    1.245237] pci 0000:00:1c.0: PCI bridge to [bus 0a]
[    1.245241] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    1.245246] pci 0000:00:1c.0:   bridge window [mem 0x7c000000-0x7c1f=
ffff]
[    1.245251] pci 0000:00:1c.0:   bridge window [mem 0x7c200000-0x7c3f=
ffff 64bit pref]
[    1.245258] pci 0000:00:1c.1: PCI bridge to [bus 0b]
[    1.245262] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    1.245267] pci 0000:00:1c.1:   bridge window [mem 0xf7000000-0xf7ff=
ffff]
[    1.245272] pci 0000:00:1c.1:   bridge window [mem 0x7c400000-0x7c5f=
ffff 64bit pref]
[    1.245279] pci 0000:00:1c.4: PCI bridge to [bus 0c]
[    1.245283] pci 0000:00:1c.4:   bridge window [io  0xa000-0xafff]
[    1.245288] pci 0000:00:1c.4:   bridge window [mem 0xfb000000-0xfb0f=
ffff]
[    1.245293] pci 0000:00:1c.4:   bridge window [mem 0xec000000-0xefff=
ffff 64bit pref]
[    1.245300] pci 0000:00:1e.0: PCI bridge to [bus 0d]
[    1.245405] pci 0000:00:1e.0: setting latency timer to 64
[    1.245410] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.245412] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.245413] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.245415] pci_bus 0000:00: resource 7 [mem 0x000c8000-0x000dffff]
[    1.245417] pci_bus 0000:00: resource 8 [mem 0x7c000000-0xfbffffff]
[    1.245419] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    1.245421] pci_bus 0000:01: resource 1 [mem 0xf5000000-0xf60fffff]
[    1.245422] pci_bus 0000:01: resource 2 [mem 0xf3000000-0xf3ffffff 6=
4bit pref]
[    1.245424] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    1.245426] pci_bus 0000:03: resource 1 [mem 0xfa000000-0xfaffffff]
[    1.245428] pci_bus 0000:03: resource 2 [mem 0xf2000000-0xf2ffffff 6=
4bit pref]
[    1.245430] pci_bus 0000:06: resource 0 [io  0xc000-0xcfff]
[    1.245431] pci_bus 0000:06: resource 1 [mem 0xf9000000-0xf9ffffff]
[    1.245433] pci_bus 0000:06: resource 2 [mem 0xf1000000-0xf1ffffff 6=
4bit pref]
[    1.245435] pci_bus 0000:08: resource 0 [io  0xb000-0xbfff]
[    1.245437] pci_bus 0000:08: resource 1 [mem 0xf8000000-0xf8ffffff]
[    1.245438] pci_bus 0000:08: resource 2 [mem 0xf0000000-0xf0ffffff 6=
4bit pref]
[    1.245440] pci_bus 0000:0a: resource 0 [io  0x2000-0x2fff]
[    1.245442] pci_bus 0000:0a: resource 1 [mem 0x7c000000-0x7c1fffff]
[    1.245444] pci_bus 0000:0a: resource 2 [mem 0x7c200000-0x7c3fffff 6=
4bit pref]
[    1.245445] pci_bus 0000:0b: resource 0 [io  0x3000-0x3fff]
[    1.245447] pci_bus 0000:0b: resource 1 [mem 0xf7000000-0xf7ffffff]
[    1.245449] pci_bus 0000:0b: resource 2 [mem 0x7c400000-0x7c5fffff 6=
4bit pref]
[    1.245451] pci_bus 0000:0c: resource 0 [io  0xa000-0xafff]
[    1.245453] pci_bus 0000:0c: resource 1 [mem 0xfb000000-0xfb0fffff]
[    1.245455] pci_bus 0000:0c: resource 2 [mem 0xec000000-0xefffffff 6=
4bit pref]
[    1.245457] pci_bus 0000:0d: resource 4 [io  0x0000-0x0cf7]
[    1.245458] pci_bus 0000:0d: resource 5 [io  0x0d00-0xffff]
[    1.245460] pci_bus 0000:0d: resource 6 [mem 0x000a0000-0x000bffff]
[    1.245462] pci_bus 0000:0d: resource 7 [mem 0x000c8000-0x000dffff]
[    1.245464] pci_bus 0000:0d: resource 8 [mem 0x7c000000-0xfbffffff]
[    1.245466] pci_bus 0000:fe: resource 4 [io  0x0000-0xffff]
[    1.245468] pci_bus 0000:fe: resource 5 [mem 0x00000000-0xffffffffff=
f]
[    1.245471] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[    1.245472] pci_bus 0000:ff: resource 5 [mem 0x00000000-0xffffffffff=
f]
[    1.245810] NET: Registered protocol family 2
[    1.246936] TCP established hash table entries: 524288 (order: 11, 8=
388608 bytes)
[    1.249025] TCP bind hash table entries: 65536 (order: 8, 1048576 by=
tes)
[    1.249280] TCP: Hash tables configured (established 524288 bind 655=
36)
[    1.249315] TCP: reno registered
[    1.249398] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
[    1.249741] UDP-Lite hash table entries: 32768 (order: 8, 1048576 by=
tes)
[    1.250324] NET: Registered protocol family 1
[    2.846339] pci 0000:00:1a.7: EHCI: BIOS handoff failed (BIOS bug?) =
01010001
[    4.443896] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) =
01010001
[    4.444039] pci 0000:0c:00.0: Boot video device
[    4.444171] PCI: CLS 64 bytes, default 64
[    4.444225] Unpacking initramfs...
[    4.743569] Freeing initrd memory: 15420k freed
[    4.747538] PCI-DMA: Using software bounce buffering for IO (SWIOTLB=
)
[    4.747544] software IO TLB [mem 0x75aa5000-0x79aa4fff] (64MB) mappe=
d at [ffff880075aa5000-ffff880079aa4fff]
[    4.750810] audit: initializing netlink socket (disabled)
[    4.750844] type=3D2000 audit(1347880092.408:1): initialized
[    4.779615] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.782309] VFS: Disk quotas dquot_6.5.2
[    4.782405] Dquot-cache hash table entries: 512 (order 0, 4096 bytes=
)
[    4.782663] msgmni has been set to 32768
[    4.782902] alg: No test for stdrng (krng)
[    4.782978] Block layer SCSI generic (bsg) driver version 0.4 loaded=
 (major 252)
[    4.783048] io scheduler noop registered
[    4.783054] io scheduler deadline registered
[    4.783182] io scheduler cfq registered (default)
[    4.783655] pcieport 0000:00:01.0: irq 64 for MSI/MSI-X
[    4.783782] pcieport 0000:00:03.0: irq 65 for MSI/MSI-X
[    4.783899] pcieport 0000:00:05.0: irq 66 for MSI/MSI-X
[    4.784005] pcieport 0000:00:07.0: irq 67 for MSI/MSI-X
[    4.784125] pcieport 0000:00:09.0: irq 68 for MSI/MSI-X
[    4.784251] pcieport 0000:00:1c.0: irq 69 for MSI/MSI-X
[    4.784380] pcieport 0000:00:1c.1: irq 70 for MSI/MSI-X
[    4.784504] pcieport 0000:00:1c.4: irq 71 for MSI/MSI-X
[    4.784636] aer 0000:00:01.0:pcie02: service driver aer loaded
[    4.784661] aer 0000:00:03.0:pcie02: service driver aer loaded
[    4.784687] aer 0000:00:05.0:pcie02: service driver aer loaded
[    4.784712] aer 0000:00:07.0:pcie02: service driver aer loaded
[    4.784736] aer 0000:00:09.0:pcie02: service driver aer loaded
[    4.784752] pcieport 0000:00:01.0: Signaling PME through PCIe PME in=
terrupt
[    4.784756] pci 0000:01:00.0: Signaling PME through PCIe PME interru=
pt
[    4.784760] pci 0000:01:00.1: Signaling PME through PCIe PME interru=
pt
[    4.784765] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme lo=
aded
[    4.784774] pcieport 0000:00:03.0: Signaling PME through PCIe PME in=
terrupt
[    4.784779] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme lo=
aded
[    4.784788] pcieport 0000:00:05.0: Signaling PME through PCIe PME in=
terrupt
[    4.784793] pcie_pme 0000:00:05.0:pcie01: service driver pcie_pme lo=
aded
[    4.784803] pcieport 0000:00:07.0: Signaling PME through PCIe PME in=
terrupt
[    4.784808] pcie_pme 0000:00:07.0:pcie01: service driver pcie_pme lo=
aded
[    4.784817] pcieport 0000:00:09.0: Signaling PME through PCIe PME in=
terrupt
[    4.784820] pci 0000:08:00.0: Signaling PME through PCIe PME interru=
pt
[    4.784824] pci 0000:08:00.1: Signaling PME through PCIe PME interru=
pt
[    4.784829] pcie_pme 0000:00:09.0:pcie01: service driver pcie_pme lo=
aded
[    4.784850] pcieport 0000:00:1c.0: Signaling PME through PCIe PME in=
terrupt
[    4.784856] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme lo=
aded
[    4.784877] pcieport 0000:00:1c.1: Signaling PME through PCIe PME in=
terrupt
[    4.784881] pci 0000:0b:00.0: Signaling PME through PCIe PME interru=
pt
[    4.784886] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme lo=
aded
[    4.784907] pcieport 0000:00:1c.4: Signaling PME through PCIe PME in=
terrupt
[    4.784911] pci 0000:0c:00.0: Signaling PME through PCIe PME interru=
pt
[    4.784916] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme lo=
aded
[    4.784933] ioapic: probe of 0000:00:13.0 failed with error -22
[    4.784940] ioapic: probe of 0000:00:15.0 failed with error -22
[    4.785017] vesafb: mode is 1280x1024x16, linelength=3D2560, pages=3D=
2
[    4.785020] vesafb: scrolling: redraw
[    4.785024] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[    4.785706] vesafb: framebuffer at 0xec000000, mapped to 0xffffc9001=
6c00000, using 5120k, total 65472k
[    4.892589] Console: switching to colour frame buffer device 160x64
[    5.000109] fb0: VESA VGA frame buffer device
[    5.000648] intel_idle: MWAIT substates: 0x1120
[    5.000650] intel_idle: v0.4 model 0x2F
[    5.000651] intel_idle: lapic_timer_reliable_states 0xffffffff
[    5.001033] ERST: Can not request iomem region <0x        79b4203f-0=
x        79b4403f> for ERST.
[    5.002252] [Firmware Warn]: GHES: Poll interval is 0 for generic ha=
rdware error source: 1, disabled.
[    5.003524] GHES: APEI firmware first mode is enabled by WHEA _OSC.
[    5.004341] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    5.025468] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    5.026943] Non-volatile memory driver v1.3
[    5.027454] Linux agpgart interface v0.103
[    5.028188] libphy: Fixed MDIO Bus: probed
[    5.028718] i8042: PNP: No PS/2 controller found. Probing ports dire=
ctly.
[    5.030394] i8042: No controller found
[    5.030927] mousedev: PS/2 mouse device common for all mice
[    5.032444] cpuidle: using governor ladder
[    5.033814] cpuidle: using governor menu
[    5.034290] EFI Variables Facility v0.08 2004-May-17
[    5.035217] TCP: cubic registered
[    5.035639] Key type dns_resolver registered
[    5.037409] PM: Checking hibernation image partition /dev/disk/by-id=
/raid-ddf1_GG-part2
[    5.037414] PM: Hibernation image not present or could not be loaded=
=2E
[    5.037431] registered taskstats version 1
[    5.040188]   Magic number: 12:525:125
[    5.040814] acpi device:00: hash matches
[    5.048577] Freeing unused kernel memory: 1352k freed
[    5.049619] Write protecting the kernel read-only data: 10240k
[    5.061542] Freeing unused kernel memory: 1708k freed
[    5.071889] Freeing unused kernel memory: 1972k freed
[    5.148908] SCSI subsystem initialized
[    5.163265] ACPI: bus type scsi registered
[    5.163956] libata version 3.00 loaded.
[    5.180808] ahci 0000:00:1f.2: version 3.0
[    5.180881] ahci 0000:00:1f.2: irq 72 for MSI/MSI-X
[    5.180945] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbp=
s 0x3f impl SATA mode
[    5.181907] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slu=
m part ccc ems sxs
[    5.182859] ahci 0000:00:1f.2: setting latency timer to 64
[    5.223400] scsi0 : ahci
[    5.226032] scsi1 : ahci
[    5.226646] scsi2 : ahci
[    5.227263] scsi3 : ahci
[    5.227777] scsi4 : ahci
[    5.228316] scsi5 : ahci
[    5.228652] ata1: SATA max UDMA/133 abar m2048@0xfb121000 port 0xfb1=
21100 irq 72
[    5.229518] ata2: SATA max UDMA/133 abar m2048@0xfb121000 port 0xfb1=
21180 irq 72
[    5.230383] ata3: SATA max UDMA/133 abar m2048@0xfb121000 port 0xfb1=
21200 irq 72
[    5.231310] ata4: SATA max UDMA/133 abar m2048@0xfb121000 port 0xfb1=
21280 irq 72
[    5.257720] ata5: SATA max UDMA/133 abar m2048@0xfb121000 port 0xfb1=
21300 irq 72
[    5.283995] ata6: SATA max UDMA/133 abar m2048@0xfb121000 port 0xfb1=
21380 irq 72
[    5.626195] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.652047] ata2: SATA link down (SStatus 0 SControl 300)
[    5.677820] ata4: SATA link down (SStatus 0 SControl 300)
[    5.704534] ata6: SATA link down (SStatus 0 SControl 300)
[    5.730580] ata5: SATA link down (SStatus 0 SControl 300)
[    5.745941] tsc: Refined TSC clocksource calibration: 2400.084 MHz
[    5.745946] Switching to clocksource tsc
[    5.810008] ata3: SATA link down (SStatus 0 SControl 300)
[    5.810036] ata1.00: ATA-8: STEC    MACH16 M16ISD2-100UCT, 00000108,=
 max UDMA/133
[    5.810038] ata1.00: 195371568 sectors, multi 1: LBA48 NCQ (depth 31=
/32), AA
[    5.810286] ata1.00: configured for UDMA/133
[    5.810737] scsi 0:0:0:0: Direct-Access     ATA      STEC    MACH16 =
M 0000 PQ: 0 ANSI: 5
[    5.959208] device-mapper: uevent: version 1.0.3
[    5.989162] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initiali=
sed: dm-devel@redhat.com
[    6.060869] rdac: device handler registered
[    6.104105] hp_sw: device handler registered
[    6.145240] emc: device handler registered
[    6.188187] alua: device handler registered
[    6.248998] udev: starting version 147
[    6.297844] ACPI: Requesting acpi_cpufreq
[    6.331072] ACPI: bus type usb registered
[    6.331193] sd 0:0:0:0: [sda] 195371568 512-byte logical blocks: (10=
0 GB/93.1 GiB)
[    6.331252] sd 0:0:0:0: [sda] Write Protect is off
[    6.331254] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.331275] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enab=
led, doesn't support DPO or FUA
[    6.332014]  sda: sda1 sda2 sda3
[    6.332472] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.491148] usbcore: registered new interface driver usbfs
[    6.517344] usbcore: registered new interface driver hub
[    6.543277] usbcore: registered new device driver usb
[    6.553626] ata1.00: exception Emask 0x10 SAct 0x6 SErr 0x800000 act=
ion 0x6 frozen
[    6.553627] ata1.00: irq_stat 0x08000000, interface fatal error
[    6.553629] ata1: SError: { LinkSeq }
[    6.553631] ata1.00: failed command: READ FPDMA QUEUED
[    6.553635] ata1.00: cmd 60/08:08:00:20:45/00:00:00:00:00/40 tag 1 n=
cq 4096 in
[    6.553635]          res 50/00:08:00:20:45/00:00:00:00:00/40 Emask 0=
x10 (ATA bus error)
[    6.553637] ata1.00: status: { DRDY }
[    6.553638] ata1.00: failed command: READ FPDMA QUEUED
[    6.553641] ata1.00: cmd 60/08:10:00:e8:04/00:00:00:00:00/40 tag 2 n=
cq 4096 in
[    6.553641]          res 50/00:08:00:20:45/00:00:00:00:00/40 Emask 0=
x10 (ATA bus error)
[    6.553642] ata1.00: status: { DRDY }
[    6.553646] ata1: hard resetting link
[    6.872254] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.872732] ata1.00: configured for UDMA/133
[    6.872741] sd 0:0:0:0: [sda]
[    6.872742] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[    6.872743] sd 0:0:0:0: [sda]
[    6.872745] Sense Key : Aborted Command [current] [descriptor]
[    6.872747] Descriptor sense data with sense descriptors (in hex):
[    6.872750]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[    6.872752]         00 45 20 00
[    6.872753] sd 0:0:0:0: [sda]
[    6.872754] Add. Sense: No additional sense information
[    6.872755] sd 0:0:0:0: [sda] CDB:
[    6.872758] Read(10): 28 00 00 45 20 00 00 00 08 00
[    6.872760] end_request: I/O error, dev sda, sector 4530176
[    6.872761] Buffer I/O error on device sda3, logical block 0
[    6.872771] sd 0:0:0:0: [sda]
[    6.872771] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[    6.872772] sd 0:0:0:0: [sda]
[    6.872773] Sense Key : Aborted Command [current] [descriptor]
[    6.872774] Descriptor sense data with sense descriptors (in hex):
[    6.872778]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[    6.872779]         00 45 20 00
[    6.872780] sd 0:0:0:0: [sda]
[    6.872781] Add. Sense: No additional sense information
[    6.872782] sd 0:0:0:0: [sda] CDB:
[    6.872784] Read(10): 28 00 00 04 e8 00 00 00 08 00
[    6.872785] end_request: I/O error, dev sda, sector 321536
[    6.872786] Buffer I/O error on device sda2, logical block 0
[    6.872794] ata1: EH complete
[    6.890282] ata1.00: exception Emask 0x10 SAct 0x7 SErr 0x800000 act=
ion 0x6 frozen
[    6.890283] ata1.00: irq_stat 0x08000000, interface fatal error
[    6.890285] ata1: SError: { LinkSeq }
[    6.890287] ata1.00: failed command: READ FPDMA QUEUED
[    6.890291] ata1.00: cmd 60/08:00:00:00:00/00:00:00:00:00/40 tag 0 n=
cq 4096 in
[    6.890291]          res 50/00:10:a0:23:45/00:00:00:00:00/40 Emask 0=
x10 (ATA bus error)
[    6.890292] ata1.00: status: { DRDY }
[    6.890293] ata1.00: failed command: READ FPDMA QUEUED
[    6.890297] ata1.00: cmd 60/08:08:70:eb:04/00:00:00:00:00/40 tag 1 n=
cq 4096 in
[    6.890297]          res 50/00:10:a0:23:45/00:00:00:00:00/40 Emask 0=
x10 (ATA bus error)
[    6.890297] ata1.00: status: { DRDY }
[    6.890299] ata1.00: failed command: READ FPDMA QUEUED
[    6.890302] ata1.00: cmd 60/08:10:a0:23:45/00:00:00:00:00/40 tag 2 n=
cq 4096 in
[    6.890302]          res 50/00:10:a0:23:45/00:00:00:00:00/40 Emask 0=
x10 (ATA bus error)
[    6.890303] ata1.00: status: { DRDY }
[    6.890305] ata1: hard resetting link
[    7.207740] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.208175] ata1.00: configured for UDMA/133
[    7.208182] sd 0:0:0:0: [sda]
[    7.208182] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[    7.208184] sd 0:0:0:0: [sda]
[    7.208185] Sense Key : Aborted Command [current] [descriptor]
[    7.208186] Descriptor sense data with sense descriptors (in hex):
[    7.208190]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[    7.208191]         00 45 23 a0
[    7.208192] sd 0:0:0:0: [sda]
[    7.208193] Add. Sense: No additional sense information
[    7.208194] sd 0:0:0:0: [sda] CDB:
[    7.208197] Read(10): 28 00 00 00 00 00 00 00 08 00
[    7.208198] end_request: I/O error, dev sda, sector 0
[    7.208199] Buffer I/O error on device sda, logical block 0
[    7.208207] sd 0:0:0:0: [sda]
[    7.208208] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[    7.208209] sd 0:0:0:0: [sda]
[    7.208210] Sense Key : Aborted Command [current] [descriptor]
[    7.208211] Descriptor sense data with sense descriptors (in hex):
[    7.208214]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[    7.208215]         00 45 23 a0
[    7.208216] sd 0:0:0:0: [sda]
[    7.208217] Add. Sense: No additional sense information
[    7.208218] sd 0:0:0:0: [sda] CDB:
[    7.208221] Read(10): 28 00 00 04 eb 70 00 00 08 00
[    7.208222] end_request: I/O error, dev sda, sector 322416
[    7.208223] Buffer I/O error on device sda2, logical block 110
[    7.208230] sd 0:0:0:0: [sda]
[    7.208230] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[    7.208231] sd 0:0:0:0: [sda]
[    7.208233] Sense Key : Aborted Command [current] [descriptor]
[    7.208233] Descriptor sense data with sense descriptors (in hex):
[    7.208237]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[    7.208238]         00 45 23 a0
[    7.208239] sd 0:0:0:0: [sda]
[    7.208240] Add. Sense: No additional sense information
[    7.208241] sd 0:0:0:0: [sda] CDB:
[    7.208244] Read(10): 28 00 00 45 23 a0 00 00 08 00
[    7.208245] end_request: I/O error, dev sda, sector 4531104
[    7.208246] Buffer I/O error on device sda3, logical block 116
[    7.208251] ata1: EH complete
[    9.443913] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driv=
er
[    9.474534] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    9.474538] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    9.505133] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned =
bus number 1
[    9.539886] ehci_hcd 0000:00:1a.7: debug port 1
[    9.570397] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supp=
orted
[    9.570425] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfb123000
[    9.612122] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    9.642303] usb usb1: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0002
[    9.672648] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1
[    9.703044] usb usb1: Product: EHCI Host Controller
[    9.733391] usb usb1: Manufacturer: Linux 3.6.0-rc1-0.27-default ehc=
i_hcd
[    9.763941] usb usb1: SerialNumber: 0000:00:1a.7
[    9.794624] hub 1-0:1.0: USB hub found
[    9.824582] hub 1-0:1.0: 6 ports detected
[    9.854607] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    9.854610] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    9.884525] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned =
bus number 2
[    9.918593] ehci_hcd 0000:00:1d.7: debug port 1
[    9.948149] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supp=
orted
[    9.948167] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfb122000
[    9.987507] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   10.016896] usb usb2: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0002
[   10.046689] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1
[   10.076253] usb usb2: Product: EHCI Host Controller
[   10.105903] usb usb2: Manufacturer: Linux 3.6.0-rc1-0.27-default ehc=
i_hcd
[   10.135797] usb usb2: SerialNumber: 0000:00:1d.7
[   10.165629] hub 2-0:1.0: USB hub found
[   10.195179] hub 2-0:1.0: 6 ports detected
[   10.238009] uhci_hcd: USB Universal Host Controller Interface driver
[   10.268418] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   10.268421] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   10.297357] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned =
bus number 3
[   10.326490] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000f0e0
[   10.355321] usb usb3: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0001
[   10.384578] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1
[   10.414160] usb usb3: Product: UHCI Host Controller
[   10.443676] usb usb3: Manufacturer: Linux 3.6.0-rc1-0.27-default uhc=
i_hcd
[   10.473651] usb usb3: SerialNumber: 0000:00:1a.0
[   10.503690] hub 3-0:1.0: USB hub found
[   10.533377] hub 3-0:1.0: 2 ports detected
[   10.562939] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   10.562942] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   10.592529] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned =
bus number 4
[   10.622384] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000f0c0
[   10.652120] usb usb4: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0001
[   10.682035] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1
[   10.711904] usb usb4: Product: UHCI Host Controller
[   10.741568] usb usb4: Manufacturer: Linux 3.6.0-rc1-0.27-default uhc=
i_hcd
[   10.771684] usb usb4: SerialNumber: 0000:00:1a.1
[   10.802430] hub 4-0:1.0: USB hub found
[   10.832523] hub 4-0:1.0: 2 ports detected
[   10.862619] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   10.862622] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   10.892795] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned =
bus number 5
[   10.923251] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000f0a0
[   10.953475] usb usb5: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0001
[   10.983963] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1
[   11.014490] usb usb5: Product: UHCI Host Controller
[   11.044901] usb usb5: Manufacturer: Linux 3.6.0-rc1-0.27-default uhc=
i_hcd
[   11.075668] usb usb5: SerialNumber: 0000:00:1a.2
[   11.106522] hub 5-0:1.0: USB hub found
[   11.136710] hub 5-0:1.0: 2 ports detected
[   11.166894] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   11.166897] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   11.197395] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned =
bus number 6
[   11.228216] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080
[   11.259018] usb usb6: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0001
[   11.290133] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1
[   11.321298] usb usb6: Product: UHCI Host Controller
[   11.352312] usb usb6: Manufacturer: Linux 3.6.0-rc1-0.27-default uhc=
i_hcd
[   11.383622] usb usb6: SerialNumber: 0000:00:1d.0
[   11.414947] hub 6-0:1.0: USB hub found
[   11.445684] hub 6-0:1.0: 2 ports detected
[   11.476358] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   11.476361] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   11.507014] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned =
bus number 7
[   11.538125] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060
[   11.569198] usb usb7: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0001
[   11.600373] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1
[   11.631622] usb usb7: Product: UHCI Host Controller
[   11.662705] usb usb7: Manufacturer: Linux 3.6.0-rc1-0.27-default uhc=
i_hcd
[   11.693914] usb usb7: SerialNumber: 0000:00:1d.1
[   11.725274] hub 7-0:1.0: USB hub found
[   11.756179] hub 7-0:1.0: 2 ports detected
[   11.787170] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   11.787173] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   11.818206] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned =
bus number 8
[   11.849534] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040
[   11.880756] usb usb8: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0001
[   11.912425] usb usb8: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1
[   11.944284] usb usb8: Product: UHCI Host Controller
[   11.975785] usb usb8: Manufacturer: Linux 3.6.0-rc1-0.27-default uhc=
i_hcd
[   12.007582] usb usb8: SerialNumber: 0000:00:1d.2
[   12.039448] hub 8-0:1.0: USB hub found
[   12.070777] hub 8-0:1.0: 2 ports detected
[   12.298915] xgifb: module is from the staging directory, the quality=
 is unknown, you have been warned.
[   12.306039] xgifb 0000:0c:00.0: Relocate IO address: a000 [0000a030]
[   12.306050] xgifb 0000:0c:00.0: chipid =3D 32
[   12.306056] xgifb: SR14=3D51 DramSzie 2000000 ChannelNum 1
[   12.306069] xgifb 0000:0c:00.0: Unable request memory size 2000000
[   12.306071] xgifb 0000:0c:00.0: Fatal error: Unable to reserve frame=
 buffer memory. Is there another framebuffer driver active?
[   12.393193] ata1.00: exception Emask 0x10 SAct 0x3 SErr 0x800000 act=
ion 0x6 frozen
[   12.393194] ata1.00: irq_stat 0x08000008, interface fatal error
[   12.393195] ata1: SError: { LinkSeq }
[   12.393197] ata1.00: failed command: READ FPDMA QUEUED
[   12.393202] ata1.00: cmd 60/08:00:00:e7:04/00:00:00:00:00/40 tag 0 n=
cq 4096 in
[   12.393202]          res 50/00:08:00:1f:45/00:00:00:00:00/40 Emask 0=
x10 (ATA bus error)
[   12.393203] ata1.00: status: { DRDY }
[   12.393205] ata1.00: failed command: READ FPDMA QUEUED
[   12.393209] ata1.00: cmd 60/08:08:80:1f:a2/00:00:0b:00:00/40 tag 1 n=
cq 4096 in
[   12.393209]          res 50/00:08:00:1f:45/00:00:00:00:00/40 Emask 0=
x10 (ATA bus error)
[   12.393210] ata1.00: status: { DRDY }
[   12.393215] ata1: hard resetting link
[   12.411808] usb 8-1: new full-speed USB device number 2 using uhci_h=
cd
[   12.564762] usb 8-1: New USB device found, idVendor=3D12d1, idProduc=
t=3D0003
[   12.564764] usb 8-1: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D0
[   12.564766] usb 8-1: Product: HUAWEI Keyboard/Mouse KVM 1.1=E7=A8=B0
[   12.564767] usb 8-1: Manufacturer: Huawei Tehnologies
[   12.711275] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   12.711547] ata1.00: configured for UDMA/133
[   12.711556] sd 0:0:0:0: [sda]
[   12.711557] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[   12.711559] sd 0:0:0:0: [sda]
[   12.711561] Sense Key : Aborted Command [current] [descriptor]
[   12.711562] Descriptor sense data with sense descriptors (in hex):
[   12.711568]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[   12.711570]         00 45 1f 00
[   12.711571] sd 0:0:0:0: [sda]
[   12.711572] Add. Sense: No additional sense information
[   12.711574] sd 0:0:0:0: [sda] CDB:
[   12.711578] Read(10): 28 00 00 04 e7 00 00 00 08 00
[   12.711580] end_request: I/O error, dev sda, sector 321280
[   12.711587] Buffer I/O error on device dm-1, logical block 39904
[   12.711597] sd 0:0:0:0: [sda]
[   12.711598] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[   12.711600] sd 0:0:0:0: [sda]
[   12.711602] Sense Key : Aborted Command [current] [descriptor]
[   12.711603] Descriptor sense data with sense descriptors (in hex):
[   12.711608]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[   12.711610]         00 45 1f 00
[   12.711612] sd 0:0:0:0: [sda]
[   12.711613] Add. Sense: No additional sense information
[   12.711614] sd 0:0:0:0: [sda] CDB:
[   12.711618] Read(10): 28 00 0b a2 1f 80 00 00 08 00
[   12.711619] end_request: I/O error, dev sda, sector 195174272
[   12.711621] Buffer I/O error on device dm-3, logical block 23830512
[   12.711638] ata1: EH complete
[   12.723530] ata1: limiting SATA link speed to 1.5 Gbps
[   12.723532] ata1.00: exception Emask 0x10 SAct 0x1 SErr 0x800000 act=
ion 0x6 frozen
[   12.723532] ata1.00: irq_stat 0x08000000, interface fatal error
[   12.723534] ata1: SError: { LinkSeq }
[   12.723535] ata1.00: failed command: READ FPDMA QUEUED
[   12.723539] ata1.00: cmd 60/08:00:48:03:00/00:00:00:00:00/40 tag 0 n=
cq 4096 in
[   12.723539]          res 50/00:00:40:03:00/00:00:00:00:00/40 Emask 0=
x10 (ATA bus error)
[   12.723540] ata1.00: status: { DRDY }
[   12.723543] ata1: hard resetting link
[   13.042923] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   13.043345] ata1.00: configured for UDMA/133
[   13.043352] sd 0:0:0:0: [sda]
[   13.043353] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[   13.043354] sd 0:0:0:0: [sda]
[   13.043355] Sense Key : Aborted Command [current] [descriptor]
[   13.043356] Descriptor sense data with sense descriptors (in hex):
[   13.043360]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[   13.043361]         00 00 03 40
[   13.043362] sd 0:0:0:0: [sda]
[   13.043363] Add. Sense: No additional sense information
[   13.043364] sd 0:0:0:0: [sda] CDB:
[   13.043367] Read(10): 28 00 00 00 03 48 00 00 08 00
[   13.043368] end_request: I/O error, dev sda, sector 840
[   13.043372] Buffer I/O error on device dm-0, logical block 105
[   13.043383] ata1: EH complete
[   13.746047] usbcore: registered new interface driver usbhid
[   13.746048] usbhid: USB HID core driver
[   15.068244] PM: Marking nosave pages: [mem 0x0009d000-0x000fffff]
[   15.068248] PM: Marking nosave pages: [mem 0x79aa5000-0x79b7dfff]
[   15.068253] PM: Marking nosave pages: [mem 0x79b80000-0x79df5fff]
[   15.068262] PM: Marking nosave pages: [mem 0x7a000000-0xffffffff]
[   15.069696] PM: Basic memory bitmaps created
[   15.321986] PM: Basic memory bitmaps freed
[   15.330909] PM: Starting manual resume from disk
[   15.330913] PM: Hibernation image partition 253:2 present
[   15.330913] PM: Looking for hibernation image.
[   15.331072] PM: Image not found (code -22)
[   15.331073] PM: Hibernation image not present or could not be loaded=
=2E
[   15.457753] kjournald starting.  Commit interval 5 seconds
[   15.457947] EXT3-fs (dm-3): using internal journal
[   15.457949] EXT3-fs (dm-3): mounted filesystem with ordered data mod=
e
[   16.289096] udev: starting version 147
[   16.343367] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PN=
P0C0E:00/input/input0
[   16.343452] ACPI: Sleep Button [SLPB]
[   16.343538] input: Power Button as /devices/LNXSYSTM:00/device:00/PN=
P0C0C:00/input/input1
[   16.343599] ACPI: Power Button [PWRB]
[   16.343654] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/=
input/input2
[   16.343709] ACPI: Power Button [PWRF]
[   16.345423] dca service started, version 1.12.1
[   16.613483] rtc_cmos 00:03: RTC can wake from S4
[   16.649939] EDAC MC: Ver: 3.0.0
[   16.650012] input: PC Speaker as /devices/platform/pcspkr/input/inpu=
t3
[   16.650056] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   16.650206] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[   16.650243] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet =
irqs
[   16.835415] input: Huawei Tehnologies HUAWEI Keyboard/Mouse KVM 1.1=E7=
=A8=B0 as /devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1:1.0/input/input=
4
[   16.874260] igb: Intel(R) Gigabit Ethernet Network Driver - version =
4.0.1-k
[   16.874260] igb: Copyright (c) 2007-2012 Intel Corporation.
[   16.874338] microcode: CPU0 sig=3D0x206f2, pf=3D0x4, revision=3D0x36
[   16.874664] hid-generic 0003:12D1:0003.0001: input,hidraw0: USB HID =
v1.10 Keyboard [Huawei Tehnologies HUAWEI Keyboard/Mouse KVM 1.1=E7=A8=B0=
] on usb-0000:00:1d.2-1/input0
[   16.874823] input: Huawei Tehnologies HUAWEI Keyboard/Mouse KVM 1.1=E7=
=A8=B0 as /devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1:1.1/input/input=
5
[   16.875124] hid-generic 0003:12D1:0003.0002: input,hidraw1: USB HID =
v1.10 Mouse [Huawei Tehnologies HUAWEI Keyboard/Mouse KVM 1.1=E7=A8=B0]=
 on usb-0000:00:1d.2-1/input1
[   16.881103] microcode: CPU1 sig=3D0x206f2, pf=3D0x4, revision=3D0x36
[   16.885356] microcode: CPU2 sig=3D0x206f2, pf=3D0x4, revision=3D0x36
[   16.889385] microcode: CPU3 sig=3D0x206f2, pf=3D0x4, revision=3D0x36
[   16.893455] microcode: CPU4 sig=3D0x206f2, pf=3D0x4, revision=3D0x36
[   16.897770] microcode: CPU5 sig=3D0x206f2, pf=3D0x4, revision=3D0x36
[   16.901952] microcode: CPU6 sig=3D0x206f2, pf=3D0x4, revision=3D0x36
[   16.905973] microcode: CPU7 sig=3D0x206f2, pf=3D0x4, revision=3D0x36
[   16.910072] microcode: CPU8 sig=3D0x206f2, pf=3D0x4, revision=3D0x36
[   16.914186] microcode: CPU9 sig=3D0x206f2, pf=3D0x4, revision=3D0x36
[   16.952435] microcode: CPU10 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   16.952656] igb 0000:01:00.0: irq 73 for MSI/MSI-X
[   16.952665] igb 0000:01:00.0: irq 74 for MSI/MSI-X
[   16.952674] igb 0000:01:00.0: irq 75 for MSI/MSI-X
[   16.952683] igb 0000:01:00.0: irq 76 for MSI/MSI-X
[   16.952697] igb 0000:01:00.0: irq 77 for MSI/MSI-X
[   16.952705] igb 0000:01:00.0: irq 78 for MSI/MSI-X
[   16.952714] igb 0000:01:00.0: irq 79 for MSI/MSI-X
[   16.952723] igb 0000:01:00.0: irq 80 for MSI/MSI-X
[   16.952732] igb 0000:01:00.0: irq 81 for MSI/MSI-X
[   16.956456] microcode: CPU11 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   16.961126] microcode: CPU12 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   16.965221] microcode: CPU13 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   16.969285] microcode: CPU14 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   16.973587] microcode: CPU15 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   16.977889] microcode: CPU16 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   16.982236] microcode: CPU17 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   16.986763] microcode: CPU18 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   16.991049] microcode: CPU19 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   16.995499] microcode: CPU20 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   16.999983] microcode: CPU21 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   17.004468] microcode: CPU22 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   17.008685] microcode: CPU23 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   17.013000] microcode: CPU24 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   17.016949] microcode: CPU25 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   17.021310] microcode: CPU26 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   17.025607] microcode: CPU27 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   17.029654] microcode: CPU28 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   17.033854] microcode: CPU29 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   17.038096] microcode: CPU30 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   17.042051] microcode: CPU31 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   17.046285] microcode: CPU32 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   17.050608] microcode: CPU33 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   17.054859] microcode: CPU34 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   17.059236] microcode: CPU35 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   17.063479] microcode: CPU36 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   17.067845] microcode: CPU37 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   17.071958] microcode: CPU38 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   17.072785] ACPI Warning: 0x0000000000000460-0x000000000000047f Syst=
emIO conflicts with Region \_SB_.PCI0.HEC2.TCOS 1 (20120711/utaddress-2=
51)
[   17.072788] ACPI: If an ACPI driver is available for this device, yo=
u should use it instead of the native driver
[   17.072788] lpc_ich: Resource conflict(s) found affecting iTCO_wdt
[   17.076534] microcode: CPU39 sig=3D0x206f2, pf=3D0x4, revision=3D0x3=
6
[   17.081025] microcode: Microcode Update Driver: v2.00 <tigran@aivazi=
an.fsnet.co.uk>, Peter Oruba
[   17.144878] igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Conn=
ection
[   17.144881] igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x4) 90:e2:ba=
:01:33:8a
[   17.144957] igb 0000:01:00.0: eth0: PBA No: E43709-006
[   17.144959] igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s),=
 8 tx queue(s)
[   17.145299] igb 0000:01:00.1: irq 82 for MSI/MSI-X
[   17.145308] igb 0000:01:00.1: irq 83 for MSI/MSI-X
[   17.145317] igb 0000:01:00.1: irq 84 for MSI/MSI-X
[   17.145326] igb 0000:01:00.1: irq 85 for MSI/MSI-X
[   17.145335] igb 0000:01:00.1: irq 86 for MSI/MSI-X
[   17.145344] igb 0000:01:00.1: irq 87 for MSI/MSI-X
[   17.145354] igb 0000:01:00.1: irq 88 for MSI/MSI-X
[   17.145363] igb 0000:01:00.1: irq 89 for MSI/MSI-X
[   17.145371] igb 0000:01:00.1: irq 90 for MSI/MSI-X
[   17.336571] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Conn=
ection
[   17.336574] igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 90:e2:ba=
:01:33:8b
[   17.336652] igb 0000:01:00.1: eth1: PBA No: E43709-006
[   17.336654] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s),=
 8 tx queue(s)
[   18.568315] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA =
Driver: 8.04.00.03-k.
[   18.568354] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   18.568364] qla2xxx [0000:08:00.0]-001d: : Found an ISP2532 irq 32 i=
obase 0xffffc90016b86000.
[   18.568902] qla2xxx 0000:08:00.0: irq 91 for MSI/MSI-X
[   18.568911] qla2xxx 0000:08:00.0: irq 92 for MSI/MSI-X
[   18.637912] scsi6 : qla2xxx
[   18.985620] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni=
)
[   23.638697] qla2xxx [0000:08:00.0]-00fb:6: QLogic QLE2562 - PCI-Expr=
ess Dual Channel 8Gb Fibre Channel HBA.
[   23.665497] qla2xxx [0000:08:00.0]-00fc:6: ISP2532: PCIe (5.0GT/s x8=
) @ 0000:08:00.0 hdma+ host#=3D6 fw=3D5.06.03 (90d5).
[   23.693846] qla2xxx [0000:08:00.1]-001d: : Found an ISP2532 irq 42 i=
obase 0xffffc90016bca000.
[   23.720604] qla2xxx 0000:08:00.1: irq 93 for MSI/MSI-X
[   23.720625] qla2xxx 0000:08:00.1: irq 94 for MSI/MSI-X
[   23.778918] scsi7 : qla2xxx
[   28.802755] qla2xxx [0000:08:00.1]-00fb:7: QLogic QLE2562 - PCI-Expr=
ess Dual Channel 8Gb Fibre Channel HBA.
[   28.827476] qla2xxx [0000:08:00.1]-00fc:7: ISP2532: PCIe (5.0GT/s x8=
) @ 0000:08:00.1 hdma+ host#=3D7 fw=3D5.06.03 (90d5).
[   28.927872] Adding 2104316k swap on /dev/mapper/ddf1_GG_part2.  Prio=
rity:-1 extents:1 across:2104316k SS
[   30.259598] loop: module loaded
[   30.307799] kjournald starting.  Commit interval 5 seconds
[   30.307952] EXT3-fs (dm-1): using internal journal
[   30.307954] EXT3-fs (dm-1): mounted filesystem with ordered data mod=
e
[   31.006697] fuse init (API version 7.19)
[   39.767378] qla2xxx [0000:08:00.0]-8038:6: Cable is unplugged...
[   44.907533] qla2xxx [0000:08:00.1]-8038:7: Cable is unplugged...
[   65.807967] auditd (4714): /proc/4714/oom_adj is deprecated, please =
use /proc/4714/oom_score_adj instead.
[   66.736140] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[  632.836197] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[  632.857042] pciehp: Using ACPI for slot detection.
[  632.857053] pciehp 0000:00:01.0:pcie04: Hotplug Controller:
[  632.857056] pciehp 0000:00:01.0:pcie04:   Seg/Bus/Dev/Func/IRQ : 000=
0:00:01.0 IRQ 64
[  632.857058] pciehp 0000:00:01.0:pcie04:   Vendor ID            : 0x8=
086
[  632.857060] pciehp 0000:00:01.0:pcie04:   Device ID            : 0x3=
408
[  632.857062] pciehp 0000:00:01.0:pcie04:   Subsystem ID         : 0x9=
000
[  632.857064] pciehp 0000:00:01.0:pcie04:   Subsystem Vendor ID  : 0x8=
000
[  632.857065] pciehp 0000:00:01.0:pcie04:   PCIe Cap offset      : 0x9=
0
[  632.857069] pciehp 0000:00:01.0:pcie04:   PCI resource [13]     : [i=
o  0xe000-0xefff]
[  632.857071] pciehp 0000:00:01.0:pcie04:   PCI resource [14]     : [m=
em 0xf5000000-0xf60fffff]
[  632.857073] pciehp 0000:00:01.0:pcie04:   PCI resource [15]     : [m=
em 0xf3000000-0xf3ffffff 64bit pref]
[  632.857075] pciehp 0000:00:01.0:pcie04: Slot Capabilities      : 0x0=
008fd5b
[  632.857077] pciehp 0000:00:01.0:pcie04:   Physical Slot Number : 1
[  632.857078] pciehp 0000:00:01.0:pcie04:   Attention Button     : yes
[  632.857080] pciehp 0000:00:01.0:pcie04:   Power Controller     : yes
[  632.857082] pciehp 0000:00:01.0:pcie04:   MRL Sensor           :  no
[  632.857083] pciehp 0000:00:01.0:pcie04:   Attention Indicator  : yes
[  632.857085] pciehp 0000:00:01.0:pcie04:   Power Indicator      : yes
[  632.857086] pciehp 0000:00:01.0:pcie04:   Hot-Plug Surprise    :  no
[  632.857088] pciehp 0000:00:01.0:pcie04:   EMI Present          :  no
[  632.857089] pciehp 0000:00:01.0:pcie04:   Command Completed    : yes
[  632.857092] pciehp 0000:00:01.0:pcie04: Slot Status            : 0x0=
040
[  632.857094] pciehp 0000:00:01.0:pcie04: Slot Control           : 0x0=
1cf
[  632.857096] pciehp 0000:00:01.0:pcie04: Link Active Reporting suppor=
ted
[  634.452185] pciehp 0000:00:01.0:pcie04: Command not completed in 100=
0 msec
[  634.452194] pciehp 0000:00:01.0:pcie04: HPC vendor_id 8086 device_id=
 3408 ss_vid 8000 ss_did 9000
[  634.452203] pciehp 0000:00:01.0:pcie04: Registering domain:bus:dev=3D=
0000:01:00 sun=3D1
[  635.450610] pciehp 0000:00:01.0:pcie04: Command not completed in 100=
0 msec
[  635.450621] pciehp 0000:00:01.0:pcie04: pciehp_get_power_status: SLO=
TCTRL a8 value read 1f9
[  635.450626] pciehp 0000:00:01.0:pcie04: service driver pciehp loaded
[  635.450654] pciehp 0000:00:03.0:pcie04: Hotplug Controller:
[  635.450660] pciehp 0000:00:03.0:pcie04:   Seg/Bus/Dev/Func/IRQ : 000=
0:00:03.0 IRQ 65
[  635.450664] pciehp 0000:00:03.0:pcie04:   Vendor ID            : 0x8=
086
[  635.450668] pciehp 0000:00:03.0:pcie04:   Device ID            : 0x3=
40a
[  635.450672] pciehp 0000:00:03.0:pcie04:   Subsystem ID         : 0x9=
000
[  635.450675] pciehp 0000:00:03.0:pcie04:   Subsystem Vendor ID  : 0x8=
000
[  635.450679] pciehp 0000:00:03.0:pcie04:   PCIe Cap offset      : 0x9=
0
[  635.450684] pciehp 0000:00:03.0:pcie04:   PCI resource [13]     : [i=
o  0xd000-0xdfff]
[  635.450689] pciehp 0000:00:03.0:pcie04:   PCI resource [14]     : [m=
em 0xfa000000-0xfaffffff]
[  635.450694] pciehp 0000:00:03.0:pcie04:   PCI resource [15]     : [m=
em 0xf2000000-0xf2ffffff 64bit pref]
[  635.450698] pciehp 0000:00:03.0:pcie04: Slot Capabilities      : 0x0=
010fd5b
[  635.450702] pciehp 0000:00:03.0:pcie04:   Physical Slot Number : 2
[  635.450706] pciehp 0000:00:03.0:pcie04:   Attention Button     : yes
[  635.450710] pciehp 0000:00:03.0:pcie04:   Power Controller     : yes
[  635.450713] pciehp 0000:00:03.0:pcie04:   MRL Sensor           :  no
[  635.450717] pciehp 0000:00:03.0:pcie04:   Attention Indicator  : yes
[  635.450720] pciehp 0000:00:03.0:pcie04:   Power Indicator      : yes
[  635.450724] pciehp 0000:00:03.0:pcie04:   Hot-Plug Surprise    :  no
[  635.450727] pciehp 0000:00:03.0:pcie04:   EMI Present          :  no
[  635.450731] pciehp 0000:00:03.0:pcie04:   Command Completed    : yes
[  635.450735] pciehp 0000:00:03.0:pcie04: Slot Status            : 0x0=
000
[  635.450740] pciehp 0000:00:03.0:pcie04: Slot Control           : 0x0=
7cf
[  635.450745] pciehp 0000:00:03.0:pcie04: Link Active Reporting suppor=
ted
[  637.048224] pciehp 0000:00:03.0:pcie04: Command not completed in 100=
0 msec
[  637.048232] pciehp 0000:00:03.0:pcie04: HPC vendor_id 8086 device_id=
 340a ss_vid 8000 ss_did 9000
[  637.048239] pciehp 0000:00:03.0:pcie04: Registering domain:bus:dev=3D=
0000:03:00 sun=3D2
[  638.046614] pciehp 0000:00:03.0:pcie04: Command not completed in 100=
0 msec
[  638.046625] pciehp 0000:00:03.0:pcie04: pciehp_get_power_status: SLO=
TCTRL a8 value read 7f9
[  638.046629] pciehp 0000:00:03.0:pcie04: service driver pciehp loaded
[  638.046657] pciehp 0000:00:07.0:pcie04: Hotplug Controller:
[  638.046663] pciehp 0000:00:07.0:pcie04:   Seg/Bus/Dev/Func/IRQ : 000=
0:00:07.0 IRQ 67
[  638.046667] pciehp 0000:00:07.0:pcie04:   Vendor ID            : 0x8=
086
[  638.046671] pciehp 0000:00:07.0:pcie04:   Device ID            : 0x3=
40e
[  638.046675] pciehp 0000:00:07.0:pcie04:   Subsystem ID         : 0x9=
000
[  638.046679] pciehp 0000:00:07.0:pcie04:   Subsystem Vendor ID  : 0x8=
000
[  638.046682] pciehp 0000:00:07.0:pcie04:   PCIe Cap offset      : 0x9=
0
[  638.046688] pciehp 0000:00:07.0:pcie04:   PCI resource [13]     : [i=
o  0xc000-0xcfff]
[  638.046692] pciehp 0000:00:07.0:pcie04:   PCI resource [14]     : [m=
em 0xf9000000-0xf9ffffff]
[  638.046697] pciehp 0000:00:07.0:pcie04:   PCI resource [15]     : [m=
em 0xf1000000-0xf1ffffff 64bit pref]
[  638.046701] pciehp 0000:00:07.0:pcie04: Slot Capabilities      : 0x0=
01825db
[  638.046705] pciehp 0000:00:07.0:pcie04:   Physical Slot Number : 3
[  638.046708] pciehp 0000:00:07.0:pcie04:   Attention Button     : yes
[  638.046712] pciehp 0000:00:07.0:pcie04:   Power Controller     : yes
[  638.046716] pciehp 0000:00:07.0:pcie04:   MRL Sensor           :  no
[  638.046719] pciehp 0000:00:07.0:pcie04:   Attention Indicator  : yes
[  638.046722] pciehp 0000:00:07.0:pcie04:   Power Indicator      : yes
[  638.046726] pciehp 0000:00:07.0:pcie04:   Hot-Plug Surprise    :  no
[  638.046729] pciehp 0000:00:07.0:pcie04:   EMI Present          :  no
[  638.046733] pciehp 0000:00:07.0:pcie04:   Command Completed    : yes
[  638.046738] pciehp 0000:00:07.0:pcie04: Slot Status            : 0x0=
000
[  638.046742] pciehp 0000:00:07.0:pcie04: Slot Control           : 0x0=
7cf
[  638.046747] pciehp 0000:00:07.0:pcie04: Link Active Reporting suppor=
ted
[  639.644234] pciehp 0000:00:07.0:pcie04: Command not completed in 100=
0 msec
[  639.644242] pciehp 0000:00:07.0:pcie04: HPC vendor_id 8086 device_id=
 340e ss_vid 8000 ss_did 9000
[  639.644250] pciehp 0000:00:07.0:pcie04: Registering domain:bus:dev=3D=
0000:06:00 sun=3D3
[  640.642659] pciehp 0000:00:07.0:pcie04: Command not completed in 100=
0 msec
[  640.642670] pciehp 0000:00:07.0:pcie04: pciehp_get_power_status: SLO=
TCTRL a8 value read 7f9
[  640.642674] pciehp 0000:00:07.0:pcie04: service driver pciehp loaded
[  640.642701] pciehp 0000:00:09.0:pcie04: Hotplug Controller:
[  640.642707] pciehp 0000:00:09.0:pcie04:   Seg/Bus/Dev/Func/IRQ : 000=
0:00:09.0 IRQ 68
[  640.642711] pciehp 0000:00:09.0:pcie04:   Vendor ID            : 0x8=
086
[  640.642715] pciehp 0000:00:09.0:pcie04:   Device ID            : 0x3=
410
[  640.642719] pciehp 0000:00:09.0:pcie04:   Subsystem ID         : 0x9=
000
[  640.642723] pciehp 0000:00:09.0:pcie04:   Subsystem Vendor ID  : 0x8=
000
[  640.642727] pciehp 0000:00:09.0:pcie04:   PCIe Cap offset      : 0x9=
0
[  640.642732] pciehp 0000:00:09.0:pcie04:   PCI resource [13]     : [i=
o  0xb000-0xbfff]
[  640.642736] pciehp 0000:00:09.0:pcie04:   PCI resource [14]     : [m=
em 0xf8000000-0xf8ffffff]
[  640.642741] pciehp 0000:00:09.0:pcie04:   PCI resource [15]     : [m=
em 0xf0000000-0xf0ffffff 64bit pref]
[  640.642745] pciehp 0000:00:09.0:pcie04: Slot Capabilities      : 0x0=
020fd5b
[  640.642749] pciehp 0000:00:09.0:pcie04:   Physical Slot Number : 4
[  640.642753] pciehp 0000:00:09.0:pcie04:   Attention Button     : yes
[  640.642756] pciehp 0000:00:09.0:pcie04:   Power Controller     : yes
[  640.642760] pciehp 0000:00:09.0:pcie04:   MRL Sensor           :  no
[  640.642763] pciehp 0000:00:09.0:pcie04:   Attention Indicator  : yes
[  640.642767] pciehp 0000:00:09.0:pcie04:   Power Indicator      : yes
[  640.642770] pciehp 0000:00:09.0:pcie04:   Hot-Plug Surprise    :  no
[  640.642774] pciehp 0000:00:09.0:pcie04:   EMI Present          :  no
[  640.642777] pciehp 0000:00:09.0:pcie04:   Command Completed    : yes
[  640.642782] pciehp 0000:00:09.0:pcie04: Slot Status            : 0x0=
040
[  640.642787] pciehp 0000:00:09.0:pcie04: Slot Control           : 0x0=
1cf
[  640.642791] pciehp 0000:00:09.0:pcie04: Link Active Reporting suppor=
ted
[  642.240292] pciehp 0000:00:09.0:pcie04: Command not completed in 100=
0 msec
[  642.240301] pciehp 0000:00:09.0:pcie04: HPC vendor_id 8086 device_id=
 3410 ss_vid 8000 ss_did 9000
[  642.240308] pciehp 0000:00:09.0:pcie04: Registering domain:bus:dev=3D=
0000:08:00 sun=3D4
[  643.238744] pciehp 0000:00:09.0:pcie04: Command not completed in 100=
0 msec
[  643.238755] pciehp 0000:00:09.0:pcie04: pciehp_get_power_status: SLO=
TCTRL a8 value read 1f9
[  643.238759] pciehp 0000:00:09.0:pcie04: service driver pciehp loaded
[  643.238815] pciehp: pcie_port_service_register =3D 0
[  643.238819] pciehp: PCI Express Hot Plug Controller Driver version: =
0.4
[  725.450809] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA =
Driver: 8.04.00.03-k-debug.
[  725.450906] qla2xxx [0000:08:00.0]-001d: : Found an ISP2532 irq 32 i=
obase 0xffffc90016b86000.
[  725.451419] qla2xxx 0000:08:00.0: irq 91 for MSI/MSI-X
[  725.451438] qla2xxx 0000:08:00.0: irq 92 for MSI/MSI-X
[  725.517575] scsi8 : qla2xxx
[  725.517635] qla2xxx [0000:08:00.0]-4800:8: DPC handler sleeping.
[  726.515358] qla2xxx [0000:08:00.0]-480f:8: Loop resync scheduled.
[  730.517257] qla2xxx [0000:08:00.0]-00fb:8: QLogic QLE2562 - PCI-Expr=
ess Dual Channel 8Gb Fibre Channel HBA.
[  730.517269] qla2xxx [0000:08:00.0]-00fc:8: ISP2532: PCIe (5.0GT/s x8=
) @ 0000:08:00.0 hdma+ host#=3D8 fw=3D5.06.03 (90d5).
[  730.519095] qla2xxx [0000:08:00.1]-001d: : Found an ISP2532 irq 42 i=
obase 0xffffc90016bd2000.
[  730.519692] qla2xxx 0000:08:00.1: irq 93 for MSI/MSI-X
[  730.519712] qla2xxx 0000:08:00.1: irq 94 for MSI/MSI-X
[  730.578008] scsi9 : qla2xxx
[  730.578108] qla2xxx [0000:08:00.1]-4800:9: DPC handler sleeping.
[  731.575527] qla2xxx [0000:08:00.1]-480f:9: Loop resync scheduled.
[  735.577429] qla2xxx [0000:08:00.1]-00fb:9: QLogic QLE2562 - PCI-Expr=
ess Dual Channel 8Gb Fibre Channel HBA.
[  735.577441] qla2xxx [0000:08:00.1]-00fc:9: ISP2532: PCIe (5.0GT/s x8=
) @ 0000:08:00.1 hdma+ host#=3D9 fw=3D5.06.03 (90d5).
[  746.645827] qla2xxx [0000:08:00.0]-8038:8: Cable is unplugged...
[  746.645835] qla2xxx [0000:08:00.0]-883a:8: fw_state=3D4 (3, f000, 0,=
 4) curr time=3D10001b4f5.
[  746.645839] qla2xxx [0000:08:00.0]-286c:8: qla2x00_loop_resync *** F=
AILED ***.
[  746.645842] qla2xxx [0000:08:00.0]-4810:8: Loop resync end.
[  746.645846] qla2xxx [0000:08:00.0]-4800:8: DPC handler sleeping.
[  751.706248] qla2xxx [0000:08:00.1]-8038:9: Cable is unplugged...
[  751.706255] qla2xxx [0000:08:00.1]-883a:9: fw_state=3D4 (3, 3000, 0,=
 4) curr time=3D10001b9e8.
[  751.706259] qla2xxx [0000:08:00.1]-286c:9: qla2x00_loop_resync *** F=
AILED ***.
[  751.706262] qla2xxx [0000:08:00.1]-4810:9: Loop resync end.
[  751.706265] qla2xxx [0000:08:00.1]-4800:9: DPC handler sleeping.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dhot-remove fc card (installed=
 before system boot up)=3D=3D
[  761.787817] pciehp 0000:00:09.0:pcie04: get_power_status: physical_s=
lot =3D 4
[  761.787827] pciehp 0000:00:09.0:pcie04: pciehp_get_power_status: SLO=
TCTRL a8 value read 1f9
[  764.445998] pciehp 0000:00:09.0:pcie04: disable_slot: physical_slot =
=3D 4
[  764.446010] pciehp 0000:00:09.0:pcie04: pciehp_get_power_status: SLO=
TCTRL a8 value read 1f9
[  764.446015] pciehp 0000:00:09.0:pcie04: pciehp_unconfigure_device: d=
omain:bus:dev =3D 0000:08:00
[  764.446239] qla2xxx [0000:08:00.0]-4811:8: DPC handler exiting.
[  764.447765] qla2xxx [0000:08:00.1]-4811:9: DPC handler exiting.
[  764.448753] pciehp 0000:00:09.0:pcie04: __pciehp_link_set: lnk_ctrl =
=3D 50
[  764.448760] pciehp 0000:00:09.0:pcie04: check_link_active: lnk_statu=
s =3D f842
[  764.462849] pciehp 0000:00:09.0:pcie04: pcie_isr: intr_loc 10
[  764.462873] pciehp 0000:00:09.0:pcie04: pciehp_power_off_slot: SLOTC=
TRL a8 write cmd 400
[  765.464060] pciehp 0000:00:09.0:pcie04: pcie_isr: intr_loc 10
[  765.464160] pciehp 0000:00:09.0:pcie04: pciehp_green_led_off: SLOTCT=
RL a8 write cmd 300


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dhot-add fc card again(in o=
riginal slot)=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  769.274623] pciehp 0000:00:09.0:pcie04: enable_slot: physical_slot =3D=
 4
[  769.274634] pciehp 0000:00:09.0:pcie04: pciehp_get_power_status: SLO=
TCTRL a8 value read 7f9
[  769.275037] pciehp 0000:00:09.0:pcie04: pcie_isr: intr_loc 10
[  769.275136] pciehp 0000:00:09.0:pcie04: pciehp_power_on_slot: SLOTCT=
RL a8 write cmd 0
[  769.275143] pciehp 0000:00:09.0:pcie04: __pciehp_link_set: lnk_ctrl =
=3D 40
[  769.276781] pciehp 0000:00:09.0:pcie04: pcie_isr: intr_loc 10
[  769.276800] pciehp 0000:00:09.0:pcie04: pciehp_green_led_blink: SLOT=
CTRL a8 write cmd 200
[  769.417697] pciehp 0000:00:09.0:pcie04: check_link_active: lnk_statu=
s =3D f042
[  769.521549] pciehp 0000:00:09.0:pcie04: pciehp_check_link_status: ln=
k_status =3D f042
[  769.521577] pci 0000:08:00.0: [1077:2532] type 00 class 0x0c0400
[  769.521597] pci 0000:08:00.0: reg 10: [io  0x0000-0x00ff]
[  769.521614] pci 0000:08:00.0: reg 14: [mem 0x00000000-0x00003fff 64b=
it]
[  769.521650] pci 0000:08:00.0: reg 30: [mem 0x00000000-0x0003ffff pre=
f]
[  769.521655] pci_read_bases: dev 0000:08:00.0 flag 4e200 ROM [mem 0x0=
0000000-0x0003ffff pref]
[  769.521748] pci 0000:08:00.1: [1077:2532] type 00 class 0x0c0400
[  769.521762] pci 0000:08:00.1: reg 10: [io  0x0000-0x00ff]
[  769.521779] pci 0000:08:00.1: reg 14: [mem 0x00000000-0x00003fff 64b=
it]
[  769.521814] pci 0000:08:00.1: reg 30: [mem 0x00000000-0x0003ffff pre=
f]
[  769.521819] pci_read_bases: dev 0000:08:00.1 flag 4e200 ROM [mem 0x0=
0000000-0x0003ffff pref]
[  769.529451] assign_requested_resources_sorted: prepare to assign res=
ource for rom, name 0000:08:00.0, [mem 0x00000000-0x0003ffff pref]
[  769.529463] pci 0000:08:00.0: BAR 6: assigned [mem 0xf0000000-0xf003=
ffff pref]
[  769.529468] assign_requested_resources_sorted: prepare to assign res=
ource for rom, name 0000:08:00.1, [mem 0x00000000-0x0003ffff pref]
[  769.529474] pci 0000:08:00.1: BAR 6: assigned [mem 0xf0040000-0xf007=
ffff pref]
[  769.529479] pci 0000:08:00.0: BAR 1: assigned [mem 0xf8000000-0xf800=
3fff 64bit]
[  769.529492] pci 0000:08:00.1: BAR 1: assigned [mem 0xf8004000-0xf800=
7fff 64bit]
[  769.529504] pci 0000:08:00.0: BAR 0: assigned [io  0xb000-0xb0ff]
[  769.529511] pci 0000:08:00.1: BAR 0: assigned [io  0xb400-0xb4ff]
[  769.529520] pcieport 0000:00:09.0: PCI bridge to [bus 08-09]
[  769.529525] pcieport 0000:00:09.0:   bridge window [io  0xb000-0xbff=
f]
[  769.529532] pcieport 0000:00:09.0:   bridge window [mem 0xf8000000-0=
xf8ffffff]
[  769.529538] pcieport 0000:00:09.0:   bridge window [mem 0xf0000000-0=
xf0ffffff 64bit pref]
[  769.529903] qla2xxx 0000:08:00.0: enabling device (0104 -> 0106)
[  769.531289] qla2xxx [0000:08:00.0]-001d: : Found an ISP2532 irq 32 i=
obase 0xffffc90016bcc000.
[  769.531748] qla2xxx 0000:08:00.0: irq 91 for MSI/MSI-X
[  769.531768] qla2xxx 0000:08:00.0: irq 92 for MSI/MSI-X
[  799.503673] qla2xxx [0000:08:00.0]-d008:10: No buffer available for =
dump.
[  799.503682] qla2xxx [0000:08:00.0]-101c:10: Mailbox cmd timeout occu=
rred, cmd=3D0xb, mb[0]=3D0xb, eeh_busy=3D0x0. Scheduling ISP abort.
[  799.503689] qla2xxx [0000:08:00.0]-0098:10: Failed to load segment 0=
 of firmware.
[  829.853242] qla2xxx [0000:08:00.0]-d008:10: No buffer available for =
dump.
[  829.853249] qla2xxx [0000:08:00.0]-008f:10: Failed to load segment 0=
 of firmware.
[  829.853253] qla2xxx [0000:08:00.0]-00cf:10: Setup chip ****FAILED***=
*.
[  829.853258] qla2xxx [0000:08:00.0]-00d6:10: Failed to initialize ada=
pter - Adapter flags 2.
[  829.853893] qla2xxx 0000:08:00.1: enabling device (0104 -> 0106)
[  829.855251] qla2xxx [0000:08:00.1]-001d: : Found an ISP2532 irq 42 i=
obase 0xffffc90016b88000.
[  829.855828] qla2xxx 0000:08:00.1: irq 91 for MSI/MSI-X
[  829.855849] qla2xxx 0000:08:00.1: irq 92 for MSI/MSI-X
[  859.827388] qla2xxx [0000:08:00.1]-d008:11: No buffer available for =
dump.
[  859.827395] qla2xxx [0000:08:00.1]-101c:11: Mailbox cmd timeout occu=
rred, cmd=3D0xb, mb[0]=3D0xb, eeh_busy=3D0x0. Scheduling ISP abort.
[  859.827400] qla2xxx [0000:08:00.1]-0098:11: Failed to load segment 0=
 of firmware.
[  890.176829] qla2xxx [0000:08:00.1]-d008:11: No buffer available for =
dump.
[  890.176837] qla2xxx [0000:08:00.1]-008f:11: Failed to load segment 0=
 of firmware.
[  890.176841] qla2xxx [0000:08:00.1]-00cf:11: Setup chip ****FAILED***=
*.
[  890.176845] qla2xxx [0000:08:00.1]-00d6:11: Failed to initialize ada=
pter - Adapter flags 2.
[  890.177672] pciehp 0000:00:09.0:pcie04: pcie_isr: intr_loc 10
[  890.177762] pciehp 0000:00:09.0:pcie04: pciehp_green_led_on: SLOTCTR=
L a8 write cmd 100


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3Dhot-add fc card in empty slot while booting system=
=3D=3D=3D=3D=3D=3D
[  972.524804] pciehp 0000:00:07.0:pcie04: pcie_isr: intr_loc 8
[  972.524811] pciehp 0000:00:07.0:pcie04: Presence/Notify input change
[  972.524817] pciehp 0000:00:07.0:pcie04: Card present on Slot(3)
[  975.648202] pciehp 0000:00:03.0:pcie04: pcie_isr: intr_loc 1
[  975.648209] pciehp 0000:00:03.0:pcie04: Attention button interrupt r=
eceived
[  975.648214] pciehp 0000:00:03.0:pcie04: Button pressed on Slot(2)
[  975.648240] pciehp 0000:00:03.0:pcie04: pciehp_get_power_status: SLO=
TCTRL a8 value read 7f9
[  975.648244] pciehp 0000:00:03.0:pcie04: PCI slot #2 - powering on du=
e to button press.
[  975.648582] pciehp 0000:00:03.0:pcie04: pcie_isr: intr_loc 10
[  975.648601] pciehp 0000:00:03.0:pcie04: pciehp_green_led_blink: SLOT=
CTRL a8 write cmd 200
[  975.648606] pciehp 0000:00:03.0:pcie04: pciehp_set_attention_status:=
 SLOTCTRL a8 write cmd c0
[  976.644581] pciehp 0000:00:03.0:pcie04: Command not completed in 100=
0 msec
[  981.640952] pciehp 0000:00:03.0:pcie04: No adapter on slot(2)
[  981.641992] pciehp 0000:00:03.0:pcie04: pcie_isr: intr_loc 10
[  981.642010] pciehp 0000:00:03.0:pcie04: pciehp_green_led_off: SLOTCT=
RL a8 write cmd 300
[  984.099266] pciehp 0000:00:07.0:pcie04: pcie_isr: intr_loc 1
[  984.099272] pciehp 0000:00:07.0:pcie04: Attention button interrupt r=
eceived
[  984.099277] pciehp 0000:00:07.0:pcie04: Button pressed on Slot(3)
[  984.099304] pciehp 0000:00:07.0:pcie04: pciehp_get_power_status: SLO=
TCTRL a8 value read 7f9
[  984.099308] pciehp 0000:00:07.0:pcie04: PCI slot #3 - powering on du=
e to button press.
[  984.099640] pciehp 0000:00:07.0:pcie04: pcie_isr: intr_loc 10
[  984.099658] pciehp 0000:00:07.0:pcie04: pciehp_green_led_blink: SLOT=
CTRL a8 write cmd 200
[  984.099664] pciehp 0000:00:07.0:pcie04: pciehp_set_attention_status:=
 SLOTCTRL a8 write cmd c0
[  985.095655] pciehp 0000:00:07.0:pcie04: Command not completed in 100=
0 msec
[  990.092026] pciehp 0000:00:07.0:pcie04: pciehp_get_power_status: SLO=
TCTRL a8 value read 6f9
[  990.093050] pciehp 0000:00:07.0:pcie04: pcie_isr: intr_loc 10
[  990.093072] pciehp 0000:00:07.0:pcie04: pciehp_power_on_slot: SLOTCT=
RL a8 write cmd 0
[  990.093080] pciehp 0000:00:07.0:pcie04: __pciehp_link_set: lnk_ctrl =
=3D 0
[  991.090503] pciehp 0000:00:07.0:pcie04: Command not completed in 100=
0 msec
[  991.090511] pciehp 0000:00:07.0:pcie04: pciehp_green_led_blink: SLOT=
CTRL a8 write cmd 200
[  991.090518] pciehp 0000:00:07.0:pcie04: check_link_active: lnk_statu=
s =3D b042
[  991.194324] pciehp 0000:00:07.0:pcie04: pciehp_check_link_status: ln=
k_status =3D b042
[  991.194357] pci 0000:06:00.0: [1077:2532] type 00 class 0x0c0400
[  991.194377] pci 0000:06:00.0: reg 10: [io  0x0000-0x00ff]
[  991.194395] pci 0000:06:00.0: reg 14: [mem 0x00000000-0x00003fff 64b=
it]
[  991.194431] pci 0000:06:00.0: reg 30: [mem 0x00000000-0x0003ffff pre=
f]
[  991.194436] pci_read_bases: dev 0000:06:00.0 flag 4e200 ROM [mem 0x0=
0000000-0x0003ffff pref]
[  991.194529] pci 0000:06:00.1: [1077:2532] type 00 class 0x0c0400
[  991.194544] pci 0000:06:00.1: reg 10: [io  0x0000-0x00ff]
[  991.194561] pci 0000:06:00.1: reg 14: [mem 0x00000000-0x00003fff 64b=
it]
[  991.194596] pci 0000:06:00.1: reg 30: [mem 0x00000000-0x0003ffff pre=
f]
[  991.194601] pci_read_bases: dev 0000:06:00.1 flag 4e200 ROM [mem 0x0=
0000000-0x0003ffff pref]
[  991.202330] assign_requested_resources_sorted: prepare to assign res=
ource for rom, name 0000:06:00.0, [mem 0x00000000-0x0003ffff pref]
[  991.202341] pci 0000:06:00.0: BAR 6: assigned [mem 0xf1000000-0xf103=
ffff pref]
[  991.202347] assign_requested_resources_sorted: prepare to assign res=
ource for rom, name 0000:06:00.1, [mem 0x00000000-0x0003ffff pref]
[  991.202352] pci 0000:06:00.1: BAR 6: assigned [mem 0xf1040000-0xf107=
ffff pref]
[  991.202357] pci 0000:06:00.0: BAR 1: assigned [mem 0xf9000000-0xf900=
3fff 64bit]
[  991.202370] pci 0000:06:00.1: BAR 1: assigned [mem 0xf9004000-0xf900=
7fff 64bit]
[  991.202383] pci 0000:06:00.0: BAR 0: assigned [io  0xc000-0xc0ff]
[  991.202390] pci 0000:06:00.1: BAR 0: assigned [io  0xc400-0xc4ff]
[  991.202398] pcieport 0000:00:07.0: PCI bridge to [bus 06-07]
[  991.202403] pcieport 0000:00:07.0:   bridge window [io  0xc000-0xcff=
f]
[  991.202411] pcieport 0000:00:07.0:   bridge window [mem 0xf9000000-0=
xf9ffffff]
[  991.202417] pcieport 0000:00:07.0:   bridge window [mem 0xf1000000-0=
xf1ffffff 64bit pref]
[  991.202771] qla2xxx 0000:06:00.0: enabling device (0104 -> 0106)
[  991.204287] qla2xxx [0000:06:00.0]-001d: : Found an ISP2532 irq 30 i=
obase 0xffffc90016bca000.
[  991.204686] qla2xxx 0000:06:00.0: irq 91 for MSI/MSI-X
[  991.204708] qla2xxx 0000:06:00.0: irq 92 for MSI/MSI-X
[  991.263354] scsi12 : qla2xxx
[  991.263445] qla2xxx [0000:06:00.0]-4800:12: DPC handler sleeping.
[  992.260700] qla2xxx [0000:06:00.0]-480f:12: Loop resync scheduled.
[  996.262600] qla2xxx [0000:06:00.0]-00fb:12: QLogic QLE2562 - PCI-Exp=
ress Dual Channel 8Gb Fibre Channel HBA.
[  996.262612] qla2xxx [0000:06:00.0]-00fc:12: ISP2532: PCIe (5.0GT/s x=
8) @ 0000:06:00.0 hdma+ host#=3D12 fw=3D5.06.03 (90d5).
[  996.262886] qla2xxx 0000:06:00.1: enabling device (0104 -> 0106)
[  996.264163] qla2xxx [0000:06:00.1]-001d: : Found an ISP2532 irq 37 i=
obase 0xffffc90016bd6000.
[  996.264753] qla2xxx 0000:06:00.1: irq 93 for MSI/MSI-X
[  996.264779] qla2xxx 0000:06:00.1: irq 94 for MSI/MSI-X
[  996.323064] scsi13 : qla2xxx
[  996.323171] qla2xxx [0000:06:00.1]-4800:13: DPC handler sleeping.
[  997.320860] qla2xxx [0000:06:00.1]-480f:13: Loop resync scheduled.
[ 1001.322799] qla2xxx [0000:06:00.1]-00fb:13: QLogic QLE2562 - PCI-Exp=
ress Dual Channel 8Gb Fibre Channel HBA.
[ 1001.322811] qla2xxx [0000:06:00.1]-00fc:13: ISP2532: PCIe (5.0GT/s x=
8) @ 0000:06:00.1 hdma+ host#=3D13 fw=3D5.06.03 (90d5).
[ 1001.323230] pciehp 0000:00:07.0:pcie04: pcie_isr: intr_loc 10
[ 1001.323245] pciehp 0000:00:07.0:pcie04: pciehp_green_led_on: SLOTCTR=
L a8 write cmd 100
[ 1012.391342] qla2xxx [0000:06:00.0]-8038:12: Cable is unplugged...
[ 1012.391349] qla2xxx [0000:06:00.0]-883a:12: fw_state=3D4 (3, 7000, 0=
, 4) curr time=3D10002b8df.
[ 1012.391354] qla2xxx [0000:06:00.0]-286c:12: qla2x00_loop_resync *** =
=46AILED ***.
[ 1012.391357] qla2xxx [0000:06:00.0]-4810:12: Loop resync end.
[ 1012.391361] qla2xxx [0000:06:00.0]-4800:12: DPC handler sleeping.
[ 1017.451595] qla2xxx [0000:06:00.1]-8038:13: Cable is unplugged...
[ 1017.451602] qla2xxx [0000:06:00.1]-883a:13: fw_state=3D4 (3, f000, 0=
, 4) curr time=3D10002bdd2.
[ 1017.451606] qla2xxx [0000:06:00.1]-286c:13: qla2x00_loop_resync *** =
=46AILED ***.
[ 1017.451609] qla2xxx [0000:06:00.1]-4810:13: Loop resync end.
[ 1017.451613] qla2xxx [0000:06:00.1]-4800:13: DPC handler sleeping.














>=20


--=20
Thanks!
Yijing

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
