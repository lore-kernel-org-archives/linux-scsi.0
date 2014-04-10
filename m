From: Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>
Subject: Re: hpsa driver bug crack kernel down!
Date: Thu, 10 Apr 2014 09:19:41 -0700
Message-ID: <1397146781.2608.46.camel@buesod1.americas.hpqcorp.net>
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>
	<1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>
	<1397084904.9519.62.camel@dabdike> <1397085044.9519.63.camel@dabdike>
	<1397086817.2608.25.camel@buesod1.americas.hpqcorp.net>
	<1397087425.9519.67.camel@dabdike>
	<1397089180.2608.27.camel@buesod1.americas.hpqcorp.net>
	<CAErSpo4H=hcro8sMnt2MzDDVCROpASuUTQWBw37OxodHTyOfyw@mail.gmail.com>
	<1397111557.2608.29.camel@buesod1.americas.hpqcorp.net>
	<20140410071535.GX13491@8bytes.org>
	<1397119587.19944.14.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-FfuNmsYTl1N+c+eFRY71"
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1397119587.19944.14.camel-Fexsq3y4057IgHVZqg5X0TlWvGAXklZc@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Woodhouse, David" <david.woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org" <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "scameron-3C9H9nn4BS4HL6m8NFMY+dBPR1lH4CV8@public.gmane.org" <scameron-3C9H9nn4BS4HL6m8NFMY+dBPR1lH4CV8@public.gmane.org>, "bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


--=-FfuNmsYTl1N+c+eFRY71
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-04-10 at 08:46 +0000, Woodhouse, David wrote:
> On Thu, 2014-04-10 at 09:15 +0200, Joerg Roedel wrote:
> > [+ David, VT-d maintainer ]
> >=20
> > Jiang, David, can you please have a look into this issue?
> >=20
>=20
> > > > >> > > > > DMAR:[fault reason 02] Present bit in context entry is=
 clear
> > > > >> > > > > dmar: DRHD: handling fault status reg 602
> > > > >> > > > > dmar: DMAR:[DMA Read] Request device [02:00.0] fault a=
ddr 7f61e000
>=20
> That "Present bit in context entry is clear" fault means that we have
> not set up *any* mappings for this PCI device=E2=80=A6 on this IOMMU.
>=20
> > > Yes, specifically (finally done bisecting):
> > >=20
> > > commit 2e45528930388658603ea24d49cf52867b928d3e
> > > Author: Jiang Liu <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > Date:   Wed Feb 19 14:07:36 2014 +0800
> > >=20
> > >     iommu/vt-d: Unify the way to process DMAR device scope array
>=20
> This commit is about how we decide which IOMMU a given PCI device is
> attached to.
>=20
> Thus, my first guess would be that we are quite happily setting up the
> requested DMA maps on the *wrong* IOMMU, and then taking faults when th=
e
> device actually tries to do DMA.
>=20
> However, I'm not 100% convinced of that. The fault address looks
> suspiciously like a true physical address, not a virtual bus address of
> the type that we'd normally allocate for a dma_map_* operation. Those
> would start at 0xfffff000 and work downwards, typically.
>=20
> Do you have 'iommu=3Dpt' on the kernel command line?=20

No.

> Can I see the full
> dmesg as this system boots, and also a copy of the DMAR table?

Attaching a dmesg from one of the kernels that boots. It doesn't appear
to have much of the related information... is there any debug config
option I can enable that might give you more data?

--=-FfuNmsYTl1N+c+eFRY71
Content-Disposition: attachment; filename="dmesg.out"
Content-Type: text/plain; name="dmesg.out"; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Initializing cgroup subsys cpuacct
Linux version 3.14.0-rc5+ (dave-GvaBMKWW3fkc7PGRc4A5KQ@public.gmane.org) (gcc version 4.4.7 20120313 =
(Red Hat 4.4.7-4) (GCC) ) #6 SMP Thu Apr 10 00:00:58 MDT 2014
Command line: ro root=3DUUID=3Dde19eaac-628e-4772-8f23-6ba0b0484517 rd_NO=
_LUKS rd_NO_LVM LANG=3Den_US.UTF-8 rd_NO_MD SYSFONT=3Dlatarcyrheb-sun16 c=
rashkernel=3D320M  KEYBOARDTYPE=3Dpc KEYTABLE=3Dus rd_NO_DM rhgb ramdisk_=
size=3D131072
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x00000000000953ff] usable
BIOS-e820: [mem 0x0000000000095400-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x000000007f5a1fff] usable
BIOS-e820: [mem 0x000000007f5a2000-0x000000007f61bfff] ACPI data
BIOS-e820: [mem 0x000000007f61c000-0x000000007f61cfff] usable
BIOS-e820: [mem 0x000000007f61d000-0x000000008fffffff] reserved
BIOS-e820: [mem 0x00000000fec00000-0x00000000fee0ffff] reserved
BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
BIOS-e820: [mem 0x0000000100000000-0x000000207fffffff] usable
BIOS-e820: [mem 0x0000008000000000-0x0000009fffffffff] usable
BIOS-e820: [mem 0x0000010000000000-0x0000011fffffffff] usable
BIOS-e820: [mem 0x0000018000000000-0x0000019fffffffff] usable
BIOS-e820: [mem 0x0000020000000000-0x0000021fffffffff] usable
BIOS-e820: [mem 0x0000028000000000-0x0000029fffffffff] usable
BIOS-e820: [mem 0x0000030000000000-0x0000031fffffffff] usable
BIOS-e820: [mem 0x0000038000000000-0x0000039fffffffff] usable
NX (Execute Disable) protection: active
SMBIOS 2.7 present.
DMI: HP ProLiant DL980 G7, BIOS P66 07/29/2013
e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
No AGP bridge found
e820: last_pfn =3D 0x3a000000 max_arch_pfn =3D 0x400000000
MTRR default type: write-back
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 00080000000 mask FFF80000000 uncachable
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
  8 disabled
  9 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
x2apic enabled by BIOS, switching to x2apic ops
e820: last_pfn =3D 0x7f61d max_arch_pfn =3D 0x400000000
found SMP MP-table at [mem 0x000f4f80-0x000f4f8f] mapped at [ffff8800000f=
4f80]
Base memory trampoline at [ffff88000008e000] 8e000 size 28672
Using GB pages for direct mapping
init_memory_mapping: [mem 0x00000000-0x000fffff]
 [mem 0x00000000-0x000fffff] page 4k
BRK [0x01f59000, 0x01f59fff] PGTABLE
BRK [0x01f5a000, 0x01f5afff] PGTABLE
BRK [0x01f5b000, 0x01f5bfff] PGTABLE
init_memory_mapping: [mem 0x39fffe00000-0x39fffffffff]
 [mem 0x39fffe00000-0x39fffffffff] page 1G
BRK [0x01f5c000, 0x01f5cfff] PGTABLE
init_memory_mapping: [mem 0x39ffc000000-0x39fffdfffff]
 [mem 0x39ffc000000-0x39fffdfffff] page 1G
init_memory_mapping: [mem 0x39f80000000-0x39ffbffffff]
 [mem 0x39f80000000-0x39ffbffffff] page 1G
init_memory_mapping: [mem 0x39000000000-0x39f7fffffff]
 [mem 0x39000000000-0x39f7fffffff] page 1G
init_memory_mapping: [mem 0x20000000000-0x21fffffffff]
 [mem 0x20000000000-0x21fffffffff] page 1G
BRK [0x01f5d000, 0x01f5dfff] PGTABLE
init_memory_mapping: [mem 0x28000000000-0x29fffffffff]
 [mem 0x28000000000-0x29fffffffff] page 1G
BRK [0x01f5e000, 0x01f5efff] PGTABLE
init_memory_mapping: [mem 0x30000000000-0x31fffffffff]
 [mem 0x30000000000-0x31fffffffff] page 1G
init_memory_mapping: [mem 0x38000000000-0x38fffffffff]
 [mem 0x38000000000-0x38fffffffff] page 1G
init_memory_mapping: [mem 0x00100000-0x7f5a1fff]
 [mem 0x00100000-0x001fffff] page 4k
 [mem 0x00200000-0x7f3fffff] page 2M
 [mem 0x7f400000-0x7f5a1fff] page 4k
init_memory_mapping: [mem 0x7f61c000-0x7f61cfff]
 [mem 0x7f61c000-0x7f61cfff] page 4k
init_memory_mapping: [mem 0x100000000-0x207fffffff]
 [mem 0x100000000-0x207fffffff] page 1G
init_memory_mapping: [mem 0x8000000000-0x9fffffffff]
 [mem 0x8000000000-0x9fffffffff] page 1G
init_memory_mapping: [mem 0x10000000000-0x11fffffffff]
 [mem 0x10000000000-0x11fffffffff] page 1G
init_memory_mapping: [mem 0x18000000000-0x19fffffffff]
 [mem 0x18000000000-0x19fffffffff] page 1G
RAMDISK: [mem 0x37a23000-0x37feffff]
ACPI: RSDP 00000000000f4f00 000024 (v02 HP    )
ACPI: XSDT 000000007f5a8970 0000E4 (v01 HP     ProLiant 00000002   =D2? 0=
000162E)
ACPI: FACP 000000007f5a8ab0 0000F4 (v03 HP     ProLiant 00000002   =D2? 0=
000162E)
ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, us=
ing default 16 (20131218/tbfadt-684)
ACPI: DSDT 000000007f5a8bb0 0025E0 (v01 HP         DSDT 00000001 INTL 200=
30228)
ACPI: FACS 000000007f5a2140 000040
ACPI: SPCR 000000007f5a2180 000050 (v01 HP     SPCRRBSU 00000001   =D2? 0=
000162E)
ACPI: MCFG 000000007f5a2200 00003C (v01 HP     ProLiant 00000001      000=
00000)
ACPI: HPET 000000007f5a2240 000038 (v01 HP     ProLiant 00000002   =D2? 0=
000162E)
ACPI: FFFF 000000007f5a2280 000064 (v02 HP     ProLiant 00000002   =D2? 0=
000162E)
ACPI: SPMI 000000007f5a2300 000040 (v05 HP     ProLiant 00000001   =D2? 0=
000162E)
ACPI: ERST 000000007f5a2340 0001D0 (v01 HP     ProLiant 00000001   =D2? 0=
000162E)
ACPI: APIC 000000007f5a2ac0 000A76 (v03 HP     ProLiant 00000002      000=
00000)
ACPI: SRAT 000000007f5a4800 0032B0 (v03 HP     Proliant 00000001   =D2? 0=
000162E)
ACPI: FFFF 000000007f5a7ac0 000176 (v01 HP     ProLiant 00000001   =D2? 0=
000162E)
ACPI: BERT 000000007f5a7c40 000030 (v01 HP     ProLiant 00000001   =D2? 0=
000162E)
ACPI: HEST 000000007f5a7c80 0000BC (v01 HP     ProLiant 00000001   =D2? 0=
000162E)
ACPI: DMAR 000000007f5a7d40 0002F4 (v01 HP     ProLiant 00000001   =D2? 0=
000162E)
ACPI: SLIT 000000007f5a8880 00006C (v01 HP     ProLiant 00000001      000=
00000)
ACPI: RASF 000000007f5a8940 000030 (v01 HP     ProLiant 00000001      000=
00000)
ACPI: SSDT 000000007f5ab190 000D82 (v01 HP        SSDT1 00000001 INTL 200=
90625)
ACPI: SSDT 000000007f5abf12 0009BB (v01 HP        SSDT4 00000001 INTL 200=
90625)
ACPI: SSDT 000000007f5ac900 000125 (v03     HP  CRSPCI0 00000002   HP 000=
00001)
ACPI: SSDT 000000007f5aca40 000076 (v03     HP  CRSPCI1 00000002   HP 000=
00001)
ACPI: SSDT 000000007f5acac0 000076 (v03     HP  CRSPCI2 00000002   HP 000=
00001)
ACPI: SSDT 000000007f5acb40 002195 (v01 HP        CPU_D 00000001 INTL 200=
90625)
ACPI: SSDT 000000007f5aed00 0010BB (v01 HP          pcc 00000001 INTL 200=
90625)
ACPI: SSDT 000000007f5afdc0 000377 (v01     HP     pmab 00000001 INTL 200=
90625)
ACPI: SSDT 000000007f5b0140 015BA4 (v01  INTEL PPM RCM  00000001 INTL 200=
61109)
ACPI: Local APIC address 0xfee00000
System requires x2apic physical mode
Setting APIC routing to physical x2apic.
SRAT: PXM 0 -> APIC 0x0000 -> Node 0
SRAT: PXM 0 -> APIC 0x0001 -> Node 0
SRAT: PXM 0 -> APIC 0x0002 -> Node 0
SRAT: PXM 0 -> APIC 0x0003 -> Node 0
SRAT: PXM 0 -> APIC 0x0004 -> Node 0
SRAT: PXM 0 -> APIC 0x0005 -> Node 0
SRAT: PXM 0 -> APIC 0x0010 -> Node 0
SRAT: PXM 0 -> APIC 0x0011 -> Node 0
SRAT: PXM 0 -> APIC 0x0012 -> Node 0
SRAT: PXM 0 -> APIC 0x0013 -> Node 0
SRAT: PXM 0 -> APIC 0x0020 -> Node 0
SRAT: PXM 0 -> APIC 0x0021 -> Node 0
SRAT: PXM 0 -> APIC 0x0022 -> Node 0
SRAT: PXM 0 -> APIC 0x0023 -> Node 0
SRAT: PXM 0 -> APIC 0x0024 -> Node 0
SRAT: PXM 0 -> APIC 0x0025 -> Node 0
SRAT: PXM 0 -> APIC 0x0030 -> Node 0
SRAT: PXM 0 -> APIC 0x0031 -> Node 0
SRAT: PXM 0 -> APIC 0x0032 -> Node 0
SRAT: PXM 0 -> APIC 0x0033 -> Node 0
SRAT: PXM 1 -> APIC 0x0040 -> Node 1
SRAT: PXM 1 -> APIC 0x0041 -> Node 1
SRAT: PXM 1 -> APIC 0x0042 -> Node 1
SRAT: PXM 1 -> APIC 0x0043 -> Node 1
SRAT: PXM 1 -> APIC 0x0044 -> Node 1
SRAT: PXM 1 -> APIC 0x0045 -> Node 1
SRAT: PXM 1 -> APIC 0x0050 -> Node 1
SRAT: PXM 1 -> APIC 0x0051 -> Node 1
SRAT: PXM 1 -> APIC 0x0052 -> Node 1
SRAT: PXM 1 -> APIC 0x0053 -> Node 1
SRAT: PXM 1 -> APIC 0x0060 -> Node 1
SRAT: PXM 1 -> APIC 0x0061 -> Node 1
SRAT: PXM 1 -> APIC 0x0062 -> Node 1
SRAT: PXM 1 -> APIC 0x0063 -> Node 1
SRAT: PXM 1 -> APIC 0x0064 -> Node 1
SRAT: PXM 1 -> APIC 0x0065 -> Node 1
SRAT: PXM 1 -> APIC 0x0070 -> Node 1
SRAT: PXM 1 -> APIC 0x0071 -> Node 1
SRAT: PXM 1 -> APIC 0x0072 -> Node 1
SRAT: PXM 1 -> APIC 0x0073 -> Node 1
SRAT: PXM 2 -> APIC 0x0080 -> Node 2
SRAT: PXM 2 -> APIC 0x0081 -> Node 2
SRAT: PXM 2 -> APIC 0x0082 -> Node 2
SRAT: PXM 2 -> APIC 0x0083 -> Node 2
SRAT: PXM 2 -> APIC 0x0084 -> Node 2
SRAT: PXM 2 -> APIC 0x0085 -> Node 2
SRAT: PXM 2 -> APIC 0x0090 -> Node 2
SRAT: PXM 2 -> APIC 0x0091 -> Node 2
SRAT: PXM 2 -> APIC 0x0092 -> Node 2
SRAT: PXM 2 -> APIC 0x0093 -> Node 2
SRAT: PXM 2 -> APIC 0x00a0 -> Node 2
SRAT: PXM 2 -> APIC 0x00a1 -> Node 2
SRAT: PXM 2 -> APIC 0x00a2 -> Node 2
SRAT: PXM 2 -> APIC 0x00a3 -> Node 2
SRAT: PXM 2 -> APIC 0x00a4 -> Node 2
SRAT: PXM 2 -> APIC 0x00a5 -> Node 2
SRAT: PXM 2 -> APIC 0x00b0 -> Node 2
SRAT: PXM 2 -> APIC 0x00b1 -> Node 2
SRAT: PXM 2 -> APIC 0x00b2 -> Node 2
SRAT: PXM 2 -> APIC 0x00b3 -> Node 2
SRAT: PXM 3 -> APIC 0x00c0 -> Node 3
SRAT: PXM 3 -> APIC 0x00c1 -> Node 3
SRAT: PXM 3 -> APIC 0x00c2 -> Node 3
SRAT: PXM 3 -> APIC 0x00c3 -> Node 3
SRAT: PXM 3 -> APIC 0x00c4 -> Node 3
SRAT: PXM 3 -> APIC 0x00c5 -> Node 3
SRAT: PXM 3 -> APIC 0x00d0 -> Node 3
SRAT: PXM 3 -> APIC 0x00d1 -> Node 3
SRAT: PXM 3 -> APIC 0x00d2 -> Node 3
SRAT: PXM 3 -> APIC 0x00d3 -> Node 3
SRAT: PXM 3 -> APIC 0x00e0 -> Node 3
SRAT: PXM 3 -> APIC 0x00e1 -> Node 3
SRAT: PXM 3 -> APIC 0x00e2 -> Node 3
SRAT: PXM 3 -> APIC 0x00e3 -> Node 3
SRAT: PXM 3 -> APIC 0x00e4 -> Node 3
SRAT: PXM 3 -> APIC 0x00e5 -> Node 3
SRAT: PXM 3 -> APIC 0x00f0 -> Node 3
SRAT: PXM 3 -> APIC 0x00f1 -> Node 3
SRAT: PXM 3 -> APIC 0x00f2 -> Node 3
SRAT: PXM 3 -> APIC 0x00f3 -> Node 3
SRAT: PXM 4 -> APIC 0x0100 -> Node 4
SRAT: PXM 4 -> APIC 0x0101 -> Node 4
SRAT: PXM 4 -> APIC 0x0102 -> Node 4
SRAT: PXM 4 -> APIC 0x0103 -> Node 4
SRAT: PXM 4 -> APIC 0x0104 -> Node 4
SRAT: PXM 4 -> APIC 0x0105 -> Node 4
SRAT: PXM 4 -> APIC 0x0110 -> Node 4
SRAT: PXM 4 -> APIC 0x0111 -> Node 4
SRAT: PXM 4 -> APIC 0x0112 -> Node 4
SRAT: PXM 4 -> APIC 0x0113 -> Node 4
SRAT: PXM 4 -> APIC 0x0120 -> Node 4
SRAT: PXM 4 -> APIC 0x0121 -> Node 4
SRAT: PXM 4 -> APIC 0x0122 -> Node 4
SRAT: PXM 4 -> APIC 0x0123 -> Node 4
SRAT: PXM 4 -> APIC 0x0124 -> Node 4
SRAT: PXM 4 -> APIC 0x0125 -> Node 4
SRAT: PXM 4 -> APIC 0x0130 -> Node 4
SRAT: PXM 4 -> APIC 0x0131 -> Node 4
SRAT: PXM 4 -> APIC 0x0132 -> Node 4
SRAT: PXM 4 -> APIC 0x0133 -> Node 4
SRAT: PXM 5 -> APIC 0x0140 -> Node 5
SRAT: PXM 5 -> APIC 0x0141 -> Node 5
SRAT: PXM 5 -> APIC 0x0142 -> Node 5
SRAT: PXM 5 -> APIC 0x0143 -> Node 5
SRAT: PXM 5 -> APIC 0x0144 -> Node 5
SRAT: PXM 5 -> APIC 0x0145 -> Node 5
SRAT: PXM 5 -> APIC 0x0150 -> Node 5
SRAT: PXM 5 -> APIC 0x0151 -> Node 5
SRAT: PXM 5 -> APIC 0x0152 -> Node 5
SRAT: PXM 5 -> APIC 0x0153 -> Node 5
SRAT: PXM 5 -> APIC 0x0160 -> Node 5
SRAT: PXM 5 -> APIC 0x0161 -> Node 5
SRAT: PXM 5 -> APIC 0x0162 -> Node 5
SRAT: PXM 5 -> APIC 0x0163 -> Node 5
SRAT: PXM 5 -> APIC 0x0164 -> Node 5
SRAT: PXM 5 -> APIC 0x0165 -> Node 5
SRAT: PXM 5 -> APIC 0x0170 -> Node 5
SRAT: PXM 5 -> APIC 0x0171 -> Node 5
SRAT: PXM 5 -> APIC 0x0172 -> Node 5
SRAT: PXM 5 -> APIC 0x0173 -> Node 5
SRAT: PXM 6 -> APIC 0x0180 -> Node 6
SRAT: PXM 6 -> APIC 0x0181 -> Node 6
SRAT: PXM 6 -> APIC 0x0182 -> Node 6
SRAT: PXM 6 -> APIC 0x0183 -> Node 6
SRAT: PXM 6 -> APIC 0x0184 -> Node 6
SRAT: PXM 6 -> APIC 0x0185 -> Node 6
SRAT: PXM 6 -> APIC 0x0190 -> Node 6
SRAT: PXM 6 -> APIC 0x0191 -> Node 6
SRAT: PXM 6 -> APIC 0x0192 -> Node 6
SRAT: PXM 6 -> APIC 0x0193 -> Node 6
SRAT: PXM 6 -> APIC 0x01a0 -> Node 6
SRAT: PXM 6 -> APIC 0x01a1 -> Node 6
SRAT: PXM 6 -> APIC 0x01a2 -> Node 6
SRAT: PXM 6 -> APIC 0x01a3 -> Node 6
SRAT: PXM 6 -> APIC 0x01a4 -> Node 6
SRAT: PXM 6 -> APIC 0x01a5 -> Node 6
SRAT: PXM 6 -> APIC 0x01b0 -> Node 6
SRAT: PXM 6 -> APIC 0x01b1 -> Node 6
SRAT: PXM 6 -> APIC 0x01b2 -> Node 6
SRAT: PXM 6 -> APIC 0x01b3 -> Node 6
SRAT: PXM 7 -> APIC 0x01c0 -> Node 7
SRAT: PXM 7 -> APIC 0x01c1 -> Node 7
SRAT: PXM 7 -> APIC 0x01c2 -> Node 7
SRAT: PXM 7 -> APIC 0x01c3 -> Node 7
SRAT: PXM 7 -> APIC 0x01c4 -> Node 7
SRAT: PXM 7 -> APIC 0x01c5 -> Node 7
SRAT: PXM 7 -> APIC 0x01d0 -> Node 7
SRAT: PXM 7 -> APIC 0x01d1 -> Node 7
SRAT: PXM 7 -> APIC 0x01d2 -> Node 7
SRAT: PXM 7 -> APIC 0x01d3 -> Node 7
SRAT: PXM 7 -> APIC 0x01e0 -> Node 7
SRAT: PXM 7 -> APIC 0x01e1 -> Node 7
SRAT: PXM 7 -> APIC 0x01e2 -> Node 7
SRAT: PXM 7 -> APIC 0x01e3 -> Node 7
SRAT: PXM 7 -> APIC 0x01e4 -> Node 7
SRAT: PXM 7 -> APIC 0x01e5 -> Node 7
SRAT: PXM 7 -> APIC 0x01f0 -> Node 7
SRAT: PXM 7 -> APIC 0x01f1 -> Node 7
SRAT: PXM 7 -> APIC 0x01f2 -> Node 7
SRAT: PXM 7 -> APIC 0x01f3 -> Node 7
SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
SRAT: Node 0 PXM 0 [mem 0x100000000-0x207fffffff]
SRAT: Node 1 PXM 1 [mem 0x8000000000-0x9fffffffff]
SRAT: Node 2 PXM 2 [mem 0x10000000000-0x11fffffffff]
SRAT: Node 3 PXM 3 [mem 0x18000000000-0x19fffffffff]
SRAT: Node 4 PXM 4 [mem 0x20000000000-0x21fffffffff]
SRAT: Node 5 PXM 5 [mem 0x28000000000-0x29fffffffff]
SRAT: Node 6 PXM 6 [mem 0x30000000000-0x31fffffffff]
SRAT: Node 7 PXM 7 [mem 0x38000000000-0x39fffffffff]
NUMA: Initialized distance table, cnt=3D8
NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-0x207fffffff]=
 -> [mem 0x00000000-0x207fffffff]
Initmem setup node 0 [mem 0x00000000-0x207fffffff]
  NODE_DATA [mem 0x207ffd9000-0x207fffffff]
Initmem setup node 1 [mem 0x8000000000-0x9fffffffff]
  NODE_DATA [mem 0x9ffffd9000-0x9fffffffff]
Initmem setup node 2 [mem 0x10000000000-0x11fffffffff]
  NODE_DATA [mem 0x11ffffd9000-0x11fffffffff]
Initmem setup node 3 [mem 0x18000000000-0x19fffffffff]
  NODE_DATA [mem 0x19ffffd9000-0x19fffffffff]
Initmem setup node 4 [mem 0x20000000000-0x21fffffffff]
  NODE_DATA [mem 0x21ffffd9000-0x21fffffffff]
Initmem setup node 5 [mem 0x28000000000-0x29fffffffff]
  NODE_DATA [mem 0x29ffffd9000-0x29fffffffff]
Initmem setup node 6 [mem 0x30000000000-0x31fffffffff]
  NODE_DATA [mem 0x31ffffd9000-0x31fffffffff]
Initmem setup node 7 [mem 0x38000000000-0x39fffffffff]
  NODE_DATA [mem 0x39ffffd1000-0x39fffff7fff]
Reserving 320MB of memory at 560MB for crashkernel (System RAM: 1048565MB=
)
 [ffffea0000000000-ffffea0071bfffff] PMD -> [ffff881fffe00000-ffff88206fd=
fffff] on node 0
 [ffffea01c0000000-ffffea022fffffff] PMD -> [ffff889f7fe00000-ffff889fefd=
fffff] on node 1
 [ffffea0380000000-ffffea03efffffff] PMD -> [ffff891f7fe00000-ffff891fefd=
fffff] on node 2
 [ffffea0540000000-ffffea05afffffff] PMD -> [ffff899f7fe00000-ffff899fefd=
fffff] on node 3
 [ffffea0700000000-ffffea076fffffff] PMD -> [ffff8a1f7fe00000-ffff8a1fefd=
fffff] on node 4
 [ffffea08c0000000-ffffea092fffffff] PMD -> [ffff8a9f7fe00000-ffff8a9fefd=
fffff] on node 5
 [ffffea0a80000000-ffffea0aefffffff] PMD -> [ffff8b1f7fe00000-ffff8b1fefd=
fffff] on node 6
 [ffffea0c40000000-ffffea0cafffffff] PMD -> [ffff8b9f7f600000-ffff8b9fef5=
fffff] on node 7
Zone ranges:
  DMA      [mem 0x00001000-0x00ffffff]
  DMA32    [mem 0x01000000-0xffffffff]
  Normal   [mem 0x100000000-0x39fffffffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00001000-0x00094fff]
  node   0: [mem 0x00100000-0x7f5a1fff]
  node   0: [mem 0x7f61c000-0x7f61cfff]
  node   0: [mem 0x100000000-0x207fffffff]
  node   1: [mem 0x8000000000-0x9fffffffff]
  node   2: [mem 0x10000000000-0x11fffffffff]
  node   3: [mem 0x18000000000-0x19fffffffff]
  node   4: [mem 0x20000000000-0x21fffffffff]
  node   5: [mem 0x28000000000-0x29fffffffff]
  node   6: [mem 0x30000000000-0x31fffffffff]
  node   7: [mem 0x38000000000-0x39fffffffff]
On node 0 totalpages: 33551671
  DMA zone: 56 pages used for memmap
  DMA zone: 22 pages reserved
  DMA zone: 3988 pages, LIFO batch:0
  DMA32 zone: 7076 pages used for memmap
  DMA32 zone: 517539 pages, LIFO batch:31
  Normal zone: 451584 pages used for memmap
  Normal zone: 33030144 pages, LIFO batch:31
On node 1 totalpages: 33554432
  Normal zone: 458752 pages used for memmap
  Normal zone: 33554432 pages, LIFO batch:31
On node 2 totalpages: 33554432
  Normal zone: 458752 pages used for memmap
  Normal zone: 33554432 pages, LIFO batch:31
On node 3 totalpages: 33554432
  Normal zone: 458752 pages used for memmap
  Normal zone: 33554432 pages, LIFO batch:31
On node 4 totalpages: 33554432
  Normal zone: 458752 pages used for memmap
  Normal zone: 33554432 pages, LIFO batch:31
On node 5 totalpages: 33554432
  Normal zone: 458752 pages used for memmap
  Normal zone: 33554432 pages, LIFO batch:31
On node 6 totalpages: 33554432
  Normal zone: 458752 pages used for memmap
  Normal zone: 33554432 pages, LIFO batch:31
On node 7 totalpages: 33554432
  Normal zone: 458752 pages used for memmap
  Normal zone: 33554432 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x908
ACPI: Local APIC address 0xfee00000
System requires x2apic physical mode
ACPI: X2APIC (apic_id[0x00] uid[0x00] enabled)
ACPI: X2APIC (apic_id[0x02] uid[0x02] enabled)
ACPI: X2APIC (apic_id[0x04] uid[0x04] enabled)
ACPI: X2APIC (apic_id[0x10] uid[0x06] enabled)
ACPI: X2APIC (apic_id[0x12] uid[0x08] enabled)
ACPI: X2APIC (apic_id[0x20] uid[0x0a] enabled)
ACPI: X2APIC (apic_id[0x22] uid[0x0c] enabled)
ACPI: X2APIC (apic_id[0x24] uid[0x0e] enabled)
ACPI: X2APIC (apic_id[0x30] uid[0x10] enabled)
ACPI: X2APIC (apic_id[0x32] uid[0x12] enabled)
ACPI: X2APIC (apic_id[0x40] uid[0x14] enabled)
ACPI: X2APIC (apic_id[0x42] uid[0x16] enabled)
ACPI: X2APIC (apic_id[0x44] uid[0x18] enabled)
ACPI: X2APIC (apic_id[0x50] uid[0x1a] enabled)
ACPI: X2APIC (apic_id[0x52] uid[0x1c] enabled)
ACPI: X2APIC (apic_id[0x60] uid[0x1e] enabled)
ACPI: X2APIC (apic_id[0x62] uid[0x20] enabled)
ACPI: X2APIC (apic_id[0x64] uid[0x22] enabled)
ACPI: X2APIC (apic_id[0x70] uid[0x24] enabled)
ACPI: X2APIC (apic_id[0x72] uid[0x26] enabled)
ACPI: X2APIC (apic_id[0x80] uid[0x28] enabled)
ACPI: X2APIC (apic_id[0x82] uid[0x2a] enabled)
ACPI: X2APIC (apic_id[0x84] uid[0x2c] enabled)
ACPI: X2APIC (apic_id[0x90] uid[0x2e] enabled)
ACPI: X2APIC (apic_id[0x92] uid[0x30] enabled)
ACPI: X2APIC (apic_id[0xa0] uid[0x32] enabled)
ACPI: X2APIC (apic_id[0xa2] uid[0x34] enabled)
ACPI: X2APIC (apic_id[0xa4] uid[0x36] enabled)
ACPI: X2APIC (apic_id[0xb0] uid[0x38] enabled)
ACPI: X2APIC (apic_id[0xb2] uid[0x3a] enabled)
ACPI: X2APIC (apic_id[0xc0] uid[0x3c] enabled)
ACPI: X2APIC (apic_id[0xc2] uid[0x3e] enabled)
ACPI: X2APIC (apic_id[0xc4] uid[0x40] enabled)
ACPI: X2APIC (apic_id[0xd0] uid[0x42] enabled)
ACPI: X2APIC (apic_id[0xd2] uid[0x44] enabled)
ACPI: X2APIC (apic_id[0xe0] uid[0x46] enabled)
ACPI: X2APIC (apic_id[0xe2] uid[0x48] enabled)
ACPI: X2APIC (apic_id[0xe4] uid[0x4a] enabled)
ACPI: X2APIC (apic_id[0xf0] uid[0x4c] enabled)
ACPI: X2APIC (apic_id[0xf2] uid[0x4e] enabled)
ACPI: X2APIC (apic_id[0x100] uid[0x50] enabled)
ACPI: X2APIC (apic_id[0x102] uid[0x52] enabled)
ACPI: X2APIC (apic_id[0x104] uid[0x54] enabled)
ACPI: X2APIC (apic_id[0x110] uid[0x56] enabled)
ACPI: X2APIC (apic_id[0x112] uid[0x58] enabled)
ACPI: X2APIC (apic_id[0x120] uid[0x5a] enabled)
ACPI: X2APIC (apic_id[0x122] uid[0x5c] enabled)
ACPI: X2APIC (apic_id[0x124] uid[0x5e] enabled)
ACPI: X2APIC (apic_id[0x130] uid[0x60] enabled)
ACPI: X2APIC (apic_id[0x132] uid[0x62] enabled)
ACPI: X2APIC (apic_id[0x140] uid[0x64] enabled)
ACPI: X2APIC (apic_id[0x142] uid[0x66] enabled)
ACPI: X2APIC (apic_id[0x144] uid[0x68] enabled)
ACPI: X2APIC (apic_id[0x150] uid[0x6a] enabled)
ACPI: X2APIC (apic_id[0x152] uid[0x6c] enabled)
ACPI: X2APIC (apic_id[0x160] uid[0x6e] enabled)
ACPI: X2APIC (apic_id[0x162] uid[0x70] enabled)
ACPI: X2APIC (apic_id[0x164] uid[0x72] enabled)
ACPI: X2APIC (apic_id[0x170] uid[0x74] enabled)
ACPI: X2APIC (apic_id[0x172] uid[0x76] enabled)
ACPI: X2APIC (apic_id[0x180] uid[0x78] enabled)
ACPI: X2APIC (apic_id[0x182] uid[0x7a] enabled)
ACPI: X2APIC (apic_id[0x184] uid[0x7c] enabled)
ACPI: X2APIC (apic_id[0x190] uid[0x7e] enabled)
ACPI: X2APIC (apic_id[0x192] uid[0x80] enabled)
ACPI: X2APIC (apic_id[0x1a0] uid[0x82] enabled)
ACPI: X2APIC (apic_id[0x1a2] uid[0x84] enabled)
ACPI: X2APIC (apic_id[0x1a4] uid[0x86] enabled)
ACPI: X2APIC (apic_id[0x1b0] uid[0x88] enabled)
ACPI: X2APIC (apic_id[0x1b2] uid[0x8a] enabled)
ACPI: X2APIC (apic_id[0x1c0] uid[0x8c] enabled)
ACPI: X2APIC (apic_id[0x1c2] uid[0x8e] enabled)
ACPI: X2APIC (apic_id[0x1c4] uid[0x90] enabled)
ACPI: X2APIC (apic_id[0x1d0] uid[0x92] enabled)
ACPI: X2APIC (apic_id[0x1d2] uid[0x94] enabled)
ACPI: X2APIC (apic_id[0x1e0] uid[0x96] enabled)
ACPI: X2APIC (apic_id[0x1e2] uid[0x98] enabled)
ACPI: X2APIC (apic_id[0x1e4] uid[0x9a] enabled)
ACPI: X2APIC (apic_id[0x1f0] uid[0x9c] enabled)
ACPI: X2APIC (apic_id[0x1f2] uid[0x9e] enabled)
ACPI: X2APIC (apic_id[0x01] uid[0x01] enabled)
ACPI: X2APIC (apic_id[0x03] uid[0x03] enabled)
ACPI: X2APIC (apic_id[0x05] uid[0x05] enabled)
ACPI: X2APIC (apic_id[0x11] uid[0x07] enabled)
ACPI: X2APIC (apic_id[0x13] uid[0x09] enabled)
ACPI: X2APIC (apic_id[0x21] uid[0x0b] enabled)
ACPI: X2APIC (apic_id[0x23] uid[0x0d] enabled)
ACPI: X2APIC (apic_id[0x25] uid[0x0f] enabled)
ACPI: X2APIC (apic_id[0x31] uid[0x11] enabled)
ACPI: X2APIC (apic_id[0x33] uid[0x13] enabled)
ACPI: X2APIC (apic_id[0x41] uid[0x15] enabled)
ACPI: X2APIC (apic_id[0x43] uid[0x17] enabled)
ACPI: X2APIC (apic_id[0x45] uid[0x19] enabled)
ACPI: X2APIC (apic_id[0x51] uid[0x1b] enabled)
ACPI: X2APIC (apic_id[0x53] uid[0x1d] enabled)
ACPI: X2APIC (apic_id[0x61] uid[0x1f] enabled)
ACPI: X2APIC (apic_id[0x63] uid[0x21] enabled)
ACPI: X2APIC (apic_id[0x65] uid[0x23] enabled)
ACPI: X2APIC (apic_id[0x71] uid[0x25] enabled)
ACPI: X2APIC (apic_id[0x73] uid[0x27] enabled)
ACPI: X2APIC (apic_id[0x81] uid[0x29] enabled)
ACPI: X2APIC (apic_id[0x83] uid[0x2b] enabled)
ACPI: X2APIC (apic_id[0x85] uid[0x2d] enabled)
ACPI: X2APIC (apic_id[0x91] uid[0x2f] enabled)
ACPI: X2APIC (apic_id[0x93] uid[0x31] enabled)
ACPI: X2APIC (apic_id[0xa1] uid[0x33] enabled)
ACPI: X2APIC (apic_id[0xa3] uid[0x35] enabled)
ACPI: X2APIC (apic_id[0xa5] uid[0x37] enabled)
ACPI: X2APIC (apic_id[0xb1] uid[0x39] enabled)
ACPI: X2APIC (apic_id[0xb3] uid[0x3b] enabled)
ACPI: X2APIC (apic_id[0xc1] uid[0x3d] enabled)
ACPI: X2APIC (apic_id[0xc3] uid[0x3f] enabled)
ACPI: X2APIC (apic_id[0xc5] uid[0x41] enabled)
ACPI: X2APIC (apic_id[0xd1] uid[0x43] enabled)
ACPI: X2APIC (apic_id[0xd3] uid[0x45] enabled)
ACPI: X2APIC (apic_id[0xe1] uid[0x47] enabled)
ACPI: X2APIC (apic_id[0xe3] uid[0x49] enabled)
ACPI: X2APIC (apic_id[0xe5] uid[0x4b] enabled)
ACPI: X2APIC (apic_id[0xf1] uid[0x4d] enabled)
ACPI: X2APIC (apic_id[0xf3] uid[0x4f] enabled)
ACPI: X2APIC (apic_id[0x101] uid[0x51] enabled)
ACPI: X2APIC (apic_id[0x103] uid[0x53] enabled)
ACPI: X2APIC (apic_id[0x105] uid[0x55] enabled)
ACPI: X2APIC (apic_id[0x111] uid[0x57] enabled)
ACPI: X2APIC (apic_id[0x113] uid[0x59] enabled)
ACPI: X2APIC (apic_id[0x121] uid[0x5b] enabled)
ACPI: X2APIC (apic_id[0x123] uid[0x5d] enabled)
ACPI: X2APIC (apic_id[0x125] uid[0x5f] enabled)
ACPI: X2APIC (apic_id[0x131] uid[0x61] enabled)
ACPI: X2APIC (apic_id[0x133] uid[0x63] enabled)
ACPI: X2APIC (apic_id[0x141] uid[0x65] enabled)
ACPI: X2APIC (apic_id[0x143] uid[0x67] enabled)
ACPI: X2APIC (apic_id[0x145] uid[0x69] enabled)
ACPI: X2APIC (apic_id[0x151] uid[0x6b] enabled)
ACPI: X2APIC (apic_id[0x153] uid[0x6d] enabled)
ACPI: X2APIC (apic_id[0x161] uid[0x6f] enabled)
ACPI: X2APIC (apic_id[0x163] uid[0x71] enabled)
ACPI: X2APIC (apic_id[0x165] uid[0x73] enabled)
ACPI: X2APIC (apic_id[0x171] uid[0x75] enabled)
ACPI: X2APIC (apic_id[0x173] uid[0x77] enabled)
ACPI: X2APIC (apic_id[0x181] uid[0x79] enabled)
ACPI: X2APIC (apic_id[0x183] uid[0x7b] enabled)
ACPI: X2APIC (apic_id[0x185] uid[0x7d] enabled)
ACPI: X2APIC (apic_id[0x191] uid[0x7f] enabled)
ACPI: X2APIC (apic_id[0x193] uid[0x81] enabled)
ACPI: X2APIC (apic_id[0x1a1] uid[0x83] enabled)
ACPI: X2APIC (apic_id[0x1a3] uid[0x85] enabled)
ACPI: X2APIC (apic_id[0x1a5] uid[0x87] enabled)
ACPI: X2APIC (apic_id[0x1b1] uid[0x89] enabled)
ACPI: X2APIC (apic_id[0x1b3] uid[0x8b] enabled)
ACPI: X2APIC (apic_id[0x1c1] uid[0x8d] enabled)
ACPI: X2APIC (apic_id[0x1c3] uid[0x8f] enabled)
ACPI: X2APIC (apic_id[0x1c5] uid[0x91] enabled)
ACPI: X2APIC (apic_id[0x1d1] uid[0x93] enabled)
ACPI: X2APIC (apic_id[0x1d3] uid[0x95] enabled)
ACPI: X2APIC (apic_id[0x1e1] uid[0x97] enabled)
ACPI: X2APIC (apic_id[0x1e3] uid[0x99] enabled)
ACPI: X2APIC (apic_id[0x1e5] uid[0x9b] enabled)
ACPI: X2APIC (apic_id[0x1f1] uid[0x9d] enabled)
ACPI: X2APIC (apic_id[0x1f3] uid[0x9f] enabled)
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x00] address[0xfec08000] gsi_base[24])
IOAPIC[1]: apic_id 0, version 32, address 0xfec08000, GSI 24-47
ACPI: IOAPIC (id[0x0a] address[0xfec10000] gsi_base[48])
IOAPIC[2]: apic_id 10, version 32, address 0xfec10000, GSI 48-71
ACPI: IOAPIC (id[0x0c] address[0xfec20000] gsi_base[72])
IOAPIC[3]: apic_id 12, version 32, address 0xfec20000, GSI 72-95
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
smpboot: Allowing 160 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 112
PM: Registered nosave memory: [mem 0x00095000-0x00095fff]
PM: Registered nosave memory: [mem 0x00096000-0x0009ffff]
PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
PM: Registered nosave memory: [mem 0x7f5a2000-0x7f61bfff]
PM: Registered nosave memory: [mem 0x7f61d000-0x8fffffff]
PM: Registered nosave memory: [mem 0x90000000-0xfebfffff]
PM: Registered nosave memory: [mem 0xfec00000-0xfee0ffff]
PM: Registered nosave memory: [mem 0xfee10000-0xff7fffff]
PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
PM: Registered nosave memory: [mem 0x2080000000-0x7fffffffff]
PM: Registered nosave memory: [mem 0xa000000000-0xffffffffff]
PM: Registered nosave memory: [mem 0x12000000000-0x17fffffffff]
PM: Registered nosave memory: [mem 0x1a000000000-0x1ffffffffff]
PM: Registered nosave memory: [mem 0x22000000000-0x27fffffffff]
PM: Registered nosave memory: [mem 0x2a000000000-0x2ffffffffff]
PM: Registered nosave memory: [mem 0x32000000000-0x37fffffffff]
e820: [mem 0x90000000-0xfebfffff] available for PCI devices
setup_percpu: NR_CPUS:8192 nr_cpumask_bits:160 nr_cpu_ids:160 nr_node_ids=
:8
PERCPU: Embedded 27 pages/cpu @ffff88207f800000 s80320 r8192 d22080 u2621=
44
pcpu-alloc: s80320 r8192 d22080 u262144 alloc=3D1*2097152
pcpu-alloc: [0] 000 001 002 003 004 005 006 007=20
pcpu-alloc: [0] 008 009 080 081 082 083 084 085=20
pcpu-alloc: [0] 086 087 088 089 --- --- --- ---=20
pcpu-alloc: [1] 010 011 012 013 014 015 016 017=20
pcpu-alloc: [1] 018 019 090 091 092 093 094 095=20
pcpu-alloc: [1] 096 097 098 099 --- --- --- ---=20
pcpu-alloc: [2] 020 021 022 023 024 025 026 027=20
pcpu-alloc: [2] 028 029 100 101 102 103 104 105=20
pcpu-alloc: [2] 106 107 108 109 --- --- --- ---=20
pcpu-alloc: [3] 030 031 032 033 034 035 036 037=20
pcpu-alloc: [3] 038 039 110 111 112 113 114 115=20
pcpu-alloc: [3] 116 117 118 119 --- --- --- ---=20
pcpu-alloc: [4] 040 041 042 043 044 045 046 047=20
pcpu-alloc: [4] 048 049 120 121 122 123 124 125=20
pcpu-alloc: [4] 126 127 128 129 --- --- --- ---=20
pcpu-alloc: [5] 050 051 052 053 054 055 056 057=20
pcpu-alloc: [5] 058 059 130 131 132 133 134 135=20
pcpu-alloc: [5] 136 137 138 139 --- --- --- ---=20
pcpu-alloc: [6] 060 061 062 063 064 065 066 067=20
pcpu-alloc: [6] 068 069 140 141 142 143 144 145=20
pcpu-alloc: [6] 146 147 148 149 --- --- --- ---=20
pcpu-alloc: [7] 070 071 072 073 074 075 076 077=20
pcpu-alloc: [7] 078 079 150 151 152 153 154 155=20
pcpu-alloc: [7] 156 157 158 159 --- --- --- ---=20
Built 8 zonelists in Zone order, mobility grouping on.  Total pages: 2647=
62693
Policy zone: Normal
Kernel command line: ro root=3DUUID=3Dde19eaac-628e-4772-8f23-6ba0b048451=
7 rd_NO_LUKS rd_NO_LVM LANG=3Den_US.UTF-8 rd_NO_MD SYSFONT=3Dlatarcyrheb-=
sun16 crashkernel=3D320M  KEYBOARDTYPE=3Dpc KEYTABLE=3Dus rd_NO_DM rhgb r=
amdisk_size=3D131072
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Memory: 1058615288K/1073730780K available (5653K kernel code, 1188K rwdat=
a, 2704K rodata, 1832K init, 2412K bss, 15115492K reserved)
Hierarchical RCU implementation.
	RCU restricting CPUs from NR_CPUS=3D8192 to nr_cpu_ids=3D160.
RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=3D160
NR_IRQS:524544 nr_irqs:3184 16
ACPI: Core revision 20131218
ACPI: All ACPI Tables successfully acquired
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
tsc: Fast TSC calibration using PIT
tsc: Detected 2394.130 MHz processor
Calibrating delay loop (skipped), value calculated using timer frequency.=
. 4788.26 BogoMIPS (lpj=3D2394130)
pid_max: default: 163840 minimum: 1280
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 134217728 (order: 18, 1073741824 bytes)
Inode-cache hash table entries: 67108864 (order: 17, 536870912 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
Initializing cgroup subsys perf_event
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
mce: CPU supports 24 MCE banks
CPU0: Thermal monitoring enabled (TM1)
Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
tlb_flushall_shift: 6
Freeing SMP alternatives memory: 20K (ffffffff81cf5000 - ffffffff81cfa000=
)
ftrace: allocating 23083 entries in 91 pages
dmar: Host address width 44
dmar: DRHD base: 0x000000b0000000 flags: 0x0
dmar: IOMMU 0: reg_base_addr b0000000 ver 1:0 cap c90780106f0462 ecap f02=
07e
dmar: DRHD base: 0x000000ac000000 flags: 0x0
dmar: IOMMU 1: reg_base_addr ac000000 ver 1:0 cap c90780106f0462 ecap f02=
07e
dmar: DRHD base: 0x000000a8000000 flags: 0x1
dmar: IOMMU 2: reg_base_addr a8000000 ver 1:0 cap c90780106f0462 ecap f02=
07e
dmar: RMRR base: 0x0000007f7ee000 end: 0x0000007f7effff
dmar: RMRR base: 0x0000007f7e7000 end: 0x0000007f7ecfff
dmar: RMRR base: 0x0000007f61e000 end: 0x0000007f61ffff
dmar: ATSR flags: 0x0
dmar: ATSR flags: 0x0
dmar: ATSR flags: 0x0
IOAPIC id 10 under DRHD base  0xac000000 IOMMU 1
IOAPIC id 12 under DRHD base  0xb0000000 IOMMU 0
IOAPIC id 8 under DRHD base  0xa8000000 IOMMU 2
IOAPIC id 0 under DRHD base  0xa8000000 IOMMU 2
Queued invalidation will be enabled to support x2apic and Intr-remapping.
Enabled IRQ remapping in x2apic mode
System requires x2apic physical mode
..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
smpboot: CPU0: Intel(R) Xeon(R) CPU E7- 2870  @ 2.40GHz (fam: 06, model: =
2f, stepping: 02)
Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Broken BIOS=
 detected, complain to your hardware vendor.
[Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 38d is 330)
Intel PMU driver.
perf_event_intel: CPUID marked event: 'bus cycles' unavailable
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
x86: Booting SMP configuration:
.... node  #0, CPUs:          #1
NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counte=
r.
   #2   #3   #4   #5   #6   #7   #8   #9
.... node  #1, CPUs:    #10  #11  #12  #13  #14  #15  #16  #17  #18  #19
.... node  #2, CPUs:    #20  #21  #22  #23  #24  #25  #26  #27  #28  #29
.... node  #3, CPUs:    #30  #31  #32  #33  #34  #35  #36  #37  #38  #39
.... node  #4, CPUs:    #40  #41  #42  #43  #44  #45  #46  #47  #48  #49
.... node  #5, CPUs:    #50  #51  #52  #53  #54  #55  #56  #57  #58  #59
.... node  #6, CPUs:    #60  #61  #62  #63  #64  #65  #66  #67  #68  #69
.... node  #7, CPUs:    #70  #71  #72  #73  #74  #75  #76  #77  #78  #79
.... node  #0, CPUs:    #80  #81  #82  #83  #84  #85  #86  #87  #88  #89
.... node  #1, CPUs:    #90  #91  #92  #93  #94  #95  #96  #97  #98  #99
.... node  #2, CPUs:   #100 #101 #102 #103 #104 #105 #106 #107 #108 #109
.... node  #3, CPUs:   #110 #111 #112 #113 #114 #115 #116 #117 #118 #119
.... node  #4, CPUs:   #120 #121 #122 #123 #124 #125 #126 #127 #128 #129
.... node  #5, CPUs:   #130 #131 #132 #133 #134 #135 #136 #137 #138 #139
.... node  #6, CPUs:   #140 #141 #142 #143 #144 #145 #146 #147 #148 #149
.... node  #7, CPUs:   #150 #151 #152 #153 #154 #155 #156 #157 #158 #159
x86: Booted up 8 nodes, 160 CPUs
smpboot: Total of 160 processors activated (766072.00 BogoMIPS)
perf samples too long (20616 > 2500), lowering kernel.perf_event_max_samp=
le_rate to 50000
perf samples too long (5477 > 2500), lowering kernel.perf_event_max_sampl=
e_rate to 25000
INFO: NMI handler (perf_event_nmi_handler) took too long to run: 2.272 ms=
ecs
INFO: NMI handler (perf_event_nmi_handler) took too long to run: 187.119 =
msecs
perf samples too long (20548 > 10000), lowering kernel.perf_event_max_sam=
ple_rate to 13000
perf samples too long (24581 > 19230), lowering kernel.perf_event_max_sam=
ple_rate to 7000
devtmpfs: initialized
regulator-dummy: no parameters
NET: Registered protocol family 16
cpuidle: using governor ladder
cpuidle: using governor menu
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type PCI registered
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] =
(base 0x80000000)
PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
\_SB_:_OSC invalid UUID
_OSC request data:1 1f=20
ACPI: Interpreter enabled
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131=
218/hwxface-580)
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131=
218/hwxface-580)
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20131=
218/hwxface-580)
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
HEST: Table parsing has been initialized.
PCI: Using host bridge windows from ACPI; if necessary, use "pci=3Dnocrs"=
 and report a bug
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-17])
acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments =
MSI]
acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME AER PCI=
eCapability]
acpi PNP0A08:00: _OSC: not requesting control; platform does not support =
[PCIeCapability]
acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
acpi PNP0A08:00: _OSC: platform willing to grant []
acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [bus 00-17]
pci_bus 0000:00: root bus resource [mem 0x90000000-0xa8ffffff]
pci_bus 0000:00: root bus resource [io  0x1000-0x4fff]
pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0x0fff]
pci_bus 0000:00: root bus resource [mem 0xfed00000-0xfed03fff]
pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
pci_bus 0000:00: root bus resource [io  0x03b0-0x03bb]
pci_bus 0000:00: root bus resource [io  0x03c0-0x03df]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci 0000:00:00.0: [8086:3407] type 00 class 0x060000
pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: [8086:3409] type 01 class 0x060400
pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:04.0: [8086:340b] type 01 class 0x060400
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: [8086:340c] type 01 class 0x060400
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: [8086:340d] type 01 class 0x060400
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:08.0: [8086:340f] type 01 class 0x060400
pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
pci 0000:00:0a.0: [8086:3411] type 01 class 0x060400
pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
pci 0000:00:1d.0: reg 0x20: [io  0x1000-0x101f]
pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
pci 0000:00:1d.1: reg 0x20: [io  0x1020-0x103f]
pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
pci 0000:00:1d.2: reg 0x20: [io  0x1040-0x105f]
pci 0000:00:1d.3: [8086:3a39] type 00 class 0x0c0300
pci 0000:00:1d.3: reg 0x20: [io  0x1060-0x107f]
pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
pci 0000:00:1d.7: reg 0x10: [mem 0x9a600000-0x9a6003ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
pci 0000:00:1f.0: [8086:3a18] type 00 class 0x060100
pci 0000:00:01.0: PCI bridge to [bus 0e-10]
pci 0000:00:02.0: PCI bridge to [bus 14]
pci 0000:04:00.0: [4040:0100] type 00 class 0x020000
pci 0000:04:00.0: reg 0x10: [mem 0x90000000-0x901fffff 64bit]
pci 0000:04:00.0: reg 0x20: [mem 0x92000000-0x93ffffff 64bit]
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.1: [4040:0100] type 00 class 0x020000
pci 0000:04:00.1: reg 0x10: [mem 0x90200000-0x903fffff 64bit]
pci 0000:04:00.1: reg 0x20: [mem 0x94000000-0x95ffffff 64bit]
pci 0000:04:00.1: PME# supported from D0 D3hot D3cold
pci 0000:04:00.2: [4040:0100] type 00 class 0x020000
pci 0000:04:00.2: reg 0x10: [mem 0x90400000-0x905fffff 64bit]
pci 0000:04:00.2: reg 0x20: [mem 0x96000000-0x97ffffff 64bit]
pci 0000:04:00.2: PME# supported from D0 D3hot D3cold
pci 0000:04:00.3: [4040:0100] type 00 class 0x020000
pci 0000:04:00.3: reg 0x10: [mem 0x90600000-0x907fffff 64bit]
pci 0000:04:00.3: reg 0x20: [mem 0x98000000-0x99ffffff 64bit]
pci 0000:04:00.3: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PCI bridge to [bus 04]
pci 0000:00:03.0:   bridge window [mem 0x90000000-0x99ffffff]
pci 0000:00:04.0: PCI bridge to [bus 15]
pci 0000:00:05.0: PCI bridge to [bus 11-13]
pci 0000:00:06.0: PCI bridge to [bus 16]
pci 0000:00:07.0: PCI bridge to [bus 0b-0d]
pci 0000:00:08.0: PCI bridge to [bus 17]
pci 0000:00:09.0: PCI bridge to [bus 08-0a]
pci 0000:00:0a.0: PCI bridge to [bus 05-07]
pci 0000:03:00.0: [103c:323a] type 00 class 0x010400
pci 0000:03:00.0: reg 0x10: [mem 0x9a000000-0x9a1fffff 64bit]
pci 0000:03:00.0: reg 0x18: [mem 0x9a200000-0x9a200fff 64bit]
pci 0000:03:00.0: reg 0x20: [io  0x4000-0x40ff]
pci 0000:03:00.0: reg 0x30: [mem 0x00000000-0x0007ffff pref]
pci 0000:03:00.0: supports D1
pci 0000:03:00.0: PME# supported from D0
pci 0000:00:1c.0: PCI bridge to [bus 03]
pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:1c.0:   bridge window [mem 0x9a000000-0x9a2fffff]
pci 0000:02:00.0: [103c:3306] type 00 class 0x088000
pci 0000:02:00.0: reg 0x10: [io  0x3000-0x30ff]
pci 0000:02:00.0: reg 0x14: [mem 0x9a300000-0x9a3001ff]
pci 0000:02:00.0: reg 0x18: [io  0x3400-0x34ff]
pci 0000:02:00.2: [103c:3307] type 00 class 0x088000
pci 0000:02:00.2: reg 0x10: [io  0x3800-0x38ff]
pci 0000:02:00.2: reg 0x14: [mem 0x9a300800-0x9a3008ff]
pci 0000:02:00.2: reg 0x18: [mem 0x9a400000-0x9a4fffff]
pci 0000:02:00.2: reg 0x1c: [mem 0x9a380000-0x9a3fffff]
pci 0000:02:00.2: reg 0x20: [mem 0x9a308000-0x9a30ffff]
pci 0000:02:00.2: reg 0x24: [mem 0x9a310000-0x9a317fff]
pci 0000:02:00.2: reg 0x30: [mem 0x00000000-0x0000ffff pref]
pci 0000:02:00.2: PME# supported from D0 D3hot D3cold
pci 0000:02:00.4: [103c:3300] type 00 class 0x0c0300
pci 0000:02:00.4: reg 0x20: [io  0x3c00-0x3c1f]
pci 0000:00:1c.4: PCI bridge to [bus 02]
pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.4:   bridge window [mem 0x9a300000-0x9a4fffff]
pci 0000:01:03.0: [1002:515e] type 00 class 0x030000
pci 0000:01:03.0: reg 0x10: [mem 0xa0000000-0xa7ffffff pref]
pci 0000:01:03.0: reg 0x14: [io  0x2000-0x20ff]
pci 0000:01:03.0: reg 0x18: [mem 0x9a500000-0x9a50ffff]
pci 0000:01:03.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
pci 0000:01:03.0: supports D1 D2
pci 0000:00:1e.0: PCI bridge to [bus 01] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1e.0:   bridge window [mem 0x9a500000-0x9a5fffff]
pci 0000:00:1e.0:   bridge window [mem 0xa0000000-0xa7ffffff 64bit pref]
pci 0000:00:1e.0:   bridge window [mem 0x90000000-0xa8ffffff] (subtractiv=
e decode)
pci 0000:00:1e.0:   bridge window [io  0x1000-0x4fff] (subtractive decode=
)
pci 0000:00:1e.0:   bridge window [io  0x0000-0x03af] (subtractive decode=
)
pci 0000:00:1e.0:   bridge window [io  0x03e0-0x0cf7] (subtractive decode=
)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0x0fff] (subtractive decode=
)
pci 0000:00:1e.0:   bridge window [mem 0xfed00000-0xfed03fff] (subtractiv=
e decode)
pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractiv=
e decode)
pci 0000:00:1e.0:   bridge window [io  0x03b0-0x03bb] (subtractive decode=
)
pci 0000:00:1e.0:   bridge window [io  0x03c0-0x03df] (subtractive decode=
)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractiv=
e decode)
pci_bus 0000:00: on NUMA node 0 (pxm 0)
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 7 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs *5 7 10 11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 5 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 5 7 *10 11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 5 *7 10 11)
ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 50-67])
acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments =
MSI]
acpi PNP0A08:01: _OSC: platform does not support [PCIeHotplug PME AER PCI=
eCapability]
acpi PNP0A08:01: _OSC: not requesting control; platform does not support =
[PCIeCapability]
acpi PNP0A08:01: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
acpi PNP0A08:01: _OSC: platform willing to grant []
acpi PNP0A08:01: _OSC failed (AE_SUPPORT); disabling ASPM
PCI host bridge to bus 0000:50
pci_bus 0000:50: root bus resource [bus 50-67]
pci_bus 0000:50: root bus resource [mem 0xac000000-0xacffffff]
pci 0000:50:00.0: [8086:3420] type 01 class 0x060400
pci 0000:50:00.0: PME# supported from D0 D3hot D3cold
pci 0000:50:01.0: [8086:3408] type 01 class 0x060400
pci 0000:50:01.0: PME# supported from D0 D3hot D3cold
pci 0000:50:02.0: [8086:3409] type 01 class 0x060400
pci 0000:50:02.0: PME# supported from D0 D3hot D3cold
pci 0000:50:03.0: [8086:340a] type 01 class 0x060400
pci 0000:50:03.0: PME# supported from D0 D3hot D3cold
pci 0000:50:04.0: [8086:340b] type 01 class 0x060400
pci 0000:50:04.0: PME# supported from D0 D3hot D3cold
pci 0000:50:05.0: [8086:340c] type 01 class 0x060400
pci 0000:50:05.0: PME# supported from D0 D3hot D3cold
pci 0000:50:06.0: [8086:340d] type 01 class 0x060400
pci 0000:50:06.0: PME# supported from D0 D3hot D3cold
pci 0000:50:07.0: [8086:340e] type 01 class 0x060400
pci 0000:50:07.0: PME# supported from D0 D3hot D3cold
pci 0000:50:08.0: [8086:340f] type 01 class 0x060400
pci 0000:50:08.0: PME# supported from D0 D3hot D3cold
pci 0000:50:09.0: [8086:3410] type 01 class 0x060400
pci 0000:50:09.0: PME# supported from D0 D3hot D3cold
pci 0000:50:0a.0: [8086:3411] type 01 class 0x060400
pci 0000:50:0a.0: PME# supported from D0 D3hot D3cold
pci 0000:50:14.0: [8086:342e] type 00 class 0x080000
pci 0000:50:00.0: PCI bridge to [bus 51-53]
pci 0000:50:01.0: PCI bridge to [bus 5a-5c]
pci 0000:50:02.0: PCI bridge to [bus 63]
pci 0000:50:03.0: PCI bridge to [bus 60-62]
pci 0000:50:04.0: PCI bridge to [bus 64]
pci 0000:50:05.0: PCI bridge to [bus 5d-5f]
pci 0000:50:06.0: PCI bridge to [bus 65]
pci 0000:50:07.0: PCI bridge to [bus 57-59]
pci 0000:50:08.0: PCI bridge to [bus 66]
pci 0000:50:09.0: PCI bridge to [bus 54-56]
pci 0000:50:0a.0: PCI bridge to [bus 67]
pci_bus 0000:50: on NUMA node 2 (pxm 2)
ACPI: PCI Root Bridge [PCI2] (domain 0000 [bus a0-c1])
acpi PNP0A08:02: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments =
MSI]
acpi PNP0A08:02: _OSC: platform does not support [PCIeHotplug PME AER PCI=
eCapability]
acpi PNP0A08:02: _OSC: not requesting control; platform does not support =
[PCIeCapability]
acpi PNP0A08:02: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
acpi PNP0A08:02: _OSC: platform willing to grant []
acpi PNP0A08:02: _OSC failed (AE_SUPPORT); disabling ASPM
PCI host bridge to bus 0000:a0
pci_bus 0000:a0: root bus resource [bus a0-c1]
pci_bus 0000:a0: root bus resource [mem 0xb0000000-0xb0ffffff]
pci 0000:a0:00.0: [8086:3420] type 01 class 0x060400
pci 0000:a0:00.0: PME# supported from D0 D3hot D3cold
pci 0000:a0:01.0: [8086:3408] type 01 class 0x060400
pci 0000:a0:01.0: PME# supported from D0 D3hot D3cold
pci 0000:a0:02.0: [8086:3409] type 01 class 0x060400
pci 0000:a0:02.0: PME# supported from D0 D3hot D3cold
pci 0000:a0:03.0: [8086:340a] type 01 class 0x060400
pci 0000:a0:03.0: PME# supported from D0 D3hot D3cold
pci 0000:a0:04.0: [8086:340b] type 01 class 0x060400
pci 0000:a0:04.0: PME# supported from D0 D3hot D3cold
pci 0000:a0:05.0: [8086:340c] type 01 class 0x060400
pci 0000:a0:05.0: PME# supported from D0 D3hot D3cold
pci 0000:a0:06.0: [8086:340d] type 01 class 0x060400
pci 0000:a0:06.0: PME# supported from D0 D3hot D3cold
pci 0000:a0:07.0: [8086:340e] type 01 class 0x060400
pci 0000:a0:07.0: PME# supported from D0 D3hot D3cold
pci 0000:a0:08.0: [8086:340f] type 01 class 0x060400
pci 0000:a0:08.0: PME# supported from D0 D3hot D3cold
pci 0000:a0:09.0: [8086:3410] type 01 class 0x060400
pci 0000:a0:09.0: PME# supported from D0 D3hot D3cold
pci 0000:a0:0a.0: [8086:3411] type 01 class 0x060400
pci 0000:a0:0a.0: PME# supported from D0 D3hot D3cold
pci 0000:a0:14.0: [8086:342e] type 00 class 0x080000
pci 0000:a0:00.0: PCI bridge to [bus b0-b2]
pci 0000:a0:01.0: PCI bridge to [bus a7-a9]
pci 0000:a0:02.0: PCI bridge to [bus b3-b5]
pci 0000:a0:03.0: PCI bridge to [bus ad-af]
pci 0000:a0:04.0: PCI bridge to [bus b6-b8]
pci 0000:a0:05.0: PCI bridge to [bus aa-ac]
pci 0000:a0:06.0: PCI bridge to [bus b9-bb]
pci 0000:a0:07.0: PCI bridge to [bus a4-a6]
pci 0000:a0:08.0: PCI bridge to [bus bc-be]
pci 0000:a0:09.0: PCI bridge to [bus a1-a3]
pci 0000:a0:0a.0: PCI bridge to [bus bf-c1]
pci_bus 0000:a0: on NUMA node 4 (pxm 4)
vgaarb: device added: PCI:0000:01:03.0,decodes=3Dio+mem,owns=3Dio+mem,loc=
ks=3Dnone
vgaarb: loaded
vgaarb: bridge control possible 0000:01:03.0
SCSI subsystem initialized
libata version 3.00 loaded.
ACPI: bus type USB registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: Discovered peer bus 7c
PCI: root bus 7c: using default resources
PCI: Probing PCI hardware (bus 7c)
PCI host bridge to bus 0000:7c
pci_bus 0000:7c: root bus resource [io  0x0000-0xffff]
pci_bus 0000:7c: root bus resource [mem 0x00000000-0xfffffffffff]
pci_bus 0000:7c: No busn resource found for root bus, will use [bus 7c-ff=
]
pci 0000:7c:00.0: [103c:403c] type 00 class 0xff0000
pci 0000:7c:08.0: [103c:403c] type 00 class 0xff0000
pci_bus 0000:7c: busn_res: [bus 7c-ff] end can not be updated to 7c
PCI: Discovered peer bus 82
PCI: root bus 82: using default resources
PCI: Probing PCI hardware (bus 82)
PCI host bridge to bus 0000:82
pci_bus 0000:82: root bus resource [io  0x0000-0xffff]
pci_bus 0000:82: root bus resource [mem 0x00000000-0xfffffffffff]
pci_bus 0000:82: No busn resource found for root bus, will use [bus 82-ff=
]
pci 0000:82:00.0: [103c:403c] type 00 class 0xff0000
pci 0000:82:08.0: [103c:403c] type 00 class 0xff0000
pci_bus 0000:82: busn_res: [bus 82-ff] end can not be updated to 82
PCI: pci_cache_line_size set to 64 bytes
e820: reserve RAM buffer [mem 0x00095400-0x0009ffff]
e820: reserve RAM buffer [mem 0x7f5a2000-0x7fffffff]
e820: reserve RAM buffer [mem 0x7f61d000-0x7fffffff]
NetLabel: Initializing
NetLabel:  domain hash size =3D 128
NetLabel:  protocols =3D UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switched to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type PNP registered
system 00:00: [io  0x0408-0x040f] has been reserved
system 00:00: [io  0x04d0-0x04d1] has been reserved
system 00:00: [io  0x0700-0x071f] has been reserved
system 00:00: [io  0x0880-0x08ff] has been reserved
system 00:00: [io  0x0900-0x097f] has been reserved
system 00:00: [io  0x0cd0-0x0cd3] has been reserved
system 00:00: [io  0x0cd4-0x0cd7] has been reserved
system 00:00: [io  0x0f50-0x0f58] has been reserved
system 00:00: [io  0x0ca0-0x0ca1] has been reserved
system 00:00: [io  0x0ca4-0x0ca5] has been reserved
system 00:00: [io  0x02f8-0x02ff] has been reserved
system 00:00: [mem 0x80000000-0x8fffffff] has been reserved
system 00:00: [mem 0xfe000000-0xfebfffff] has been reserved
system 00:00: [mem 0xa8000000-0xa8001fff] could not be reserved
system 00:00: [mem 0xac000000-0xac001fff] could not be reserved
system 00:00: [mem 0xb0000000-0xb0001fff] could not be reserved
system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:01: Plug and Play ACPI device, IDs IPI0001 (active)
pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:03: [dma 7]
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:05: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:06: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
pnp 00:07: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp: PnP ACPI: found 9 devices
ACPI: bus type PNP unregistered
pci 0000:00:1c.0: BAR 15: assigned [mem 0x9a700000-0x9a7fffff pref]
pci 0000:00:1c.4: BAR 15: assigned [mem 0x9a800000-0x9a8fffff pref]
pci 0000:00:01.0: PCI bridge to [bus 0e-10]
pci 0000:00:02.0: PCI bridge to [bus 14]
pci 0000:00:03.0: PCI bridge to [bus 04]
pci 0000:00:03.0:   bridge window [mem 0x90000000-0x99ffffff]
pci 0000:00:04.0: PCI bridge to [bus 15]
pci 0000:00:05.0: PCI bridge to [bus 11-13]
pci 0000:00:06.0: PCI bridge to [bus 16]
pci 0000:00:07.0: PCI bridge to [bus 0b-0d]
pci 0000:00:08.0: PCI bridge to [bus 17]
pci 0000:00:09.0: PCI bridge to [bus 08-0a]
pci 0000:00:0a.0: PCI bridge to [bus 05-07]
pci 0000:03:00.0: BAR 6: assigned [mem 0x9a700000-0x9a77ffff pref]
pci 0000:00:1c.0: PCI bridge to [bus 03]
pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:1c.0:   bridge window [mem 0x9a000000-0x9a2fffff]
pci 0000:00:1c.0:   bridge window [mem 0x9a700000-0x9a7fffff pref]
pci 0000:02:00.2: BAR 6: assigned [mem 0x9a800000-0x9a80ffff pref]
pci 0000:00:1c.4: PCI bridge to [bus 02]
pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.4:   bridge window [mem 0x9a300000-0x9a4fffff]
pci 0000:00:1c.4:   bridge window [mem 0x9a800000-0x9a8fffff pref]
pci 0000:01:03.0: BAR 6: assigned [mem 0x9a520000-0x9a53ffff pref]
pci 0000:00:1e.0: PCI bridge to [bus 01]
pci 0000:00:1e.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1e.0:   bridge window [mem 0x9a500000-0x9a5fffff]
pci 0000:00:1e.0:   bridge window [mem 0xa0000000-0xa7ffffff 64bit pref]
pci_bus 0000:00: resource 4 [mem 0x90000000-0xa8ffffff]
pci_bus 0000:00: resource 5 [io  0x1000-0x4fff]
pci_bus 0000:00: resource 6 [io  0x0000-0x03af]
pci_bus 0000:00: resource 7 [io  0x03e0-0x0cf7]
pci_bus 0000:00: resource 8 [io  0x0d00-0x0fff]
pci_bus 0000:00: resource 9 [mem 0xfed00000-0xfed03fff]
pci_bus 0000:00: resource 10 [mem 0xfed40000-0xfed44fff]
pci_bus 0000:00: resource 11 [io  0x03b0-0x03bb]
pci_bus 0000:00: resource 12 [io  0x03c0-0x03df]
pci_bus 0000:00: resource 13 [mem 0x000a0000-0x000bffff]
pci_bus 0000:04: resource 1 [mem 0x90000000-0x99ffffff]
pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:03: resource 1 [mem 0x9a000000-0x9a2fffff]
pci_bus 0000:03: resource 2 [mem 0x9a700000-0x9a7fffff pref]
pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:02: resource 1 [mem 0x9a300000-0x9a4fffff]
pci_bus 0000:02: resource 2 [mem 0x9a800000-0x9a8fffff pref]
pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:01: resource 1 [mem 0x9a500000-0x9a5fffff]
pci_bus 0000:01: resource 2 [mem 0xa0000000-0xa7ffffff 64bit pref]
pci_bus 0000:01: resource 4 [mem 0x90000000-0xa8ffffff]
pci_bus 0000:01: resource 5 [io  0x1000-0x4fff]
pci_bus 0000:01: resource 6 [io  0x0000-0x03af]
pci_bus 0000:01: resource 7 [io  0x03e0-0x0cf7]
pci_bus 0000:01: resource 8 [io  0x0d00-0x0fff]
pci_bus 0000:01: resource 9 [mem 0xfed00000-0xfed03fff]
pci_bus 0000:01: resource 10 [mem 0xfed40000-0xfed44fff]
pci_bus 0000:01: resource 11 [io  0x03b0-0x03bb]
pci_bus 0000:01: resource 12 [io  0x03c0-0x03df]
pci_bus 0000:01: resource 13 [mem 0x000a0000-0x000bffff]
pci 0000:50:00.0: PCI bridge to [bus 51-53]
pci 0000:50:01.0: PCI bridge to [bus 5a-5c]
pci 0000:50:02.0: PCI bridge to [bus 63]
pci 0000:50:03.0: PCI bridge to [bus 60-62]
pci 0000:50:04.0: PCI bridge to [bus 64]
pci 0000:50:05.0: PCI bridge to [bus 5d-5f]
pci 0000:50:06.0: PCI bridge to [bus 65]
pci 0000:50:07.0: PCI bridge to [bus 57-59]
pci 0000:50:08.0: PCI bridge to [bus 66]
pci 0000:50:09.0: PCI bridge to [bus 54-56]
pci 0000:50:0a.0: PCI bridge to [bus 67]
pci_bus 0000:50: resource 4 [mem 0xac000000-0xacffffff]
pci 0000:a0:00.0: PCI bridge to [bus b0-b2]
pci 0000:a0:01.0: PCI bridge to [bus a7-a9]
pci 0000:a0:02.0: PCI bridge to [bus b3-b5]
pci 0000:a0:03.0: PCI bridge to [bus ad-af]
pci 0000:a0:04.0: PCI bridge to [bus b6-b8]
pci 0000:a0:05.0: PCI bridge to [bus aa-ac]
pci 0000:a0:06.0: PCI bridge to [bus b9-bb]
pci 0000:a0:07.0: PCI bridge to [bus a4-a6]
pci 0000:a0:08.0: PCI bridge to [bus bc-be]
pci 0000:a0:09.0: PCI bridge to [bus a1-a3]
pci 0000:a0:0a.0: PCI bridge to [bus bf-c1]
pci_bus 0000:a0: resource 4 [mem 0xb0000000-0xb0ffffff]
pci_bus 0000:7c: resource 4 [io  0x0000-0xffff]
pci_bus 0000:7c: resource 5 [mem 0x00000000-0xfffffffffff]
pci_bus 0000:82: resource 4 [io  0x0000-0xffff]
pci_bus 0000:82: resource 5 [mem 0x00000000-0xfffffffffff]
NET: Registered protocol family 2
TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP: reno registered
UDP hash table entries: 65536 (order: 9, 2097152 bytes)
UDP-Lite hash table entries: 65536 (order: 9, 2097152 bytes)
NET: Registered protocol family 1
pci 0000:01:03.0: Boot video device
PCI: CLS 64 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 5940K (ffff880037a23000 - ffff880037ff0000)
IOMMU 1 0xac000000: using Queued invalidation
IOMMU 0 0xb0000000: using Queued invalidation
IOMMU 2 0xa8000000: using Queued invalidation
IOMMU: Setting RMRR:
IOMMU: Setting identity map for device 0000:03:00.0 [0x7f61e000 - 0x7f61f=
fff]
IOMMU: Setting identity map for device 0000:02:00.0 [0x7f61e000 - 0x7f61f=
fff]
IOMMU: Setting identity map for device 0000:02:00.2 [0x7f61e000 - 0x7f61f=
fff]
IOMMU: Setting identity map for device 0000:00:1d.0 [0x7f7e7000 - 0x7f7ec=
fff]
IOMMU: Setting identity map for device 0000:00:1d.1 [0x7f7e7000 - 0x7f7ec=
fff]
IOMMU: Setting identity map for device 0000:00:1d.2 [0x7f7e7000 - 0x7f7ec=
fff]
IOMMU: Setting identity map for device 0000:00:1d.3 [0x7f7e7000 - 0x7f7ec=
fff]
IOMMU: Setting identity map for device 0000:02:00.0 [0x7f7e7000 - 0x7f7ec=
fff]
IOMMU: Setting identity map for device 0000:02:00.2 [0x7f7e7000 - 0x7f7ec=
fff]
IOMMU: Setting identity map for device 0000:02:00.4 [0x7f7e7000 - 0x7f7ec=
fff]
IOMMU: Setting identity map for device 0000:00:1d.7 [0x7f7ee000 - 0x7f7ef=
fff]
IOMMU: Prepare 0-16MiB unity mapping for LPC
IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
futex hash table entries: 65536 (order: 10, 4194304 bytes)
audit: initializing netlink subsys (disabled)
audit: type=3D2000 audit(1397110209.557:1): initialized
bounce pool size: 64 pages
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 32768
SELinux:  Registering netfilter hooks
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:1c.0: irq 115 for MSI/MSI-X
pcieport 0000:00:1c.4: irq 116 for MSI/MSI-X
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
intel_idle: MWAIT substates: 0x1120
intel_idle: v0.4 model 0x2F
intel_idle: lapic_timer_reliable_states 0xffffffff
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (8 C)
ERST: Failed to get Error Log Address Range.
GHES: APEI firmware first mode is enabled by WHEA _OSC.
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
00:07: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3, base_baud =3D 115200) is a 165=
50A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
brd: module loaded
loop: module loaded
libphy: Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-pci: EHCI PCI platform driver
ehci-pci 0000:00:1d.7: EHCI Host Controller
ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci-pci 0000:00:1d.7: debug port 1
ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
ehci-pci 0000:00:1d.7: irq 20, io mem 0x9a600000
ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.14.0-rc5+ ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci-pci: OHCI PCI platform driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001000
usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 3.14.0-rc5+ uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: irq 23, io base 0x00001020
usb usb3: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb3: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 3.14.0-rc5+ uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001040
usb usb4: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb4: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 3.14.0-rc5+ uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: detected 2 ports
uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001060
usb usb5: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb5: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 3.14.0-rc5+ uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:02:00.4: UHCI Host Controller
uhci_hcd 0000:02:00.4: new USB bus registered, assigned bus number 6
uhci_hcd 0000:02:00.4: detected 8 ports
uhci_hcd 0000:02:00.4: port count misdetected? forcing to 2 ports
uhci_hcd 0000:02:00.4: irq 17, io base 0x00003c00
usb usb6: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb6: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 3.14.0-rc5+ uhci_hcd
usb usb6: SerialNumber: 0000:02:00.4
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1=
,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:08: RTC can wake from S4
rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
rtc_cmos 00:08: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
hidraw: raw HID events driver (C) Jiri Kosina
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
drop_monitor: Initializing network drop monitor service
TCP: cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
IMA: No TPM chip found, activating TPM-bypass!
rtc_cmos 00:08: setting system clock to 2014-04-10 06:10:13 UTC (13971102=
13)
Freeing unused kernel memory: 1832K (ffffffff81b2b000 - ffffffff81cf5000)
Write protecting the kernel read-only data: 10240k
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/inp=
ut/input1
Freeing unused kernel memory: 480K (ffff880001588000 - ffff880001600000)
Freeing unused kernel memory: 1392K (ffff8800018a4000 - ffff880001a00000)
dracut: dracut-004-303.el6
dracut: rd_NO_LUKS: removing cryptoluks activation
udev: starting version 147
udevd (1035): /proc/1035/oom_adj is deprecated, please use /proc/1035/oom=
_score_adj instead.
usb 6-1: new full-speed USB device number 2 using uhci_hcd
usb 6-1: New USB device found, idVendor=3D03f0, idProduct=3D7029
usb 6-1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 6-1: Product: Virtual Keyboard=20
usb 6-1: Manufacturer: HP=20
input: HP  Virtual Keyboard  as /devices/pci0000:00/0000:00:1c.4/0000:02:=
00.4/usb6/6-1/6-1:1.0/0003:03F0:7029.0001/input/input4
hid-generic 0003:03F0:7029.0001: input,hidraw0: USB HID v1.01 Keyboard [H=
P  Virtual Keyboard ] on usb-0000:02:00.4-1/input0
input: HP  Virtual Keyboard  as /devices/pci0000:00/0000:00:1c.4/0000:02:=
00.4/usb6/6-1/6-1:1.1/0003:03F0:7029.0002/input/input5
hid-generic 0003:03F0:7029.0002: input,hidraw1: USB HID v1.01 Mouse [HP  =
Virtual Keyboard ] on usb-0000:02:00.4-1/input1
tsc: Refined TSC clocksource calibration: 2393.999 MHz
[drm] Initialized drm 1.1.0 20060810
[drm] radeon kernel modesetting enabled.
[drm] initializing kernel modesetting (RV100 0x1002:0x515E 0x103C:0x31FB)=
.
[drm] register mmio base: 0x9A500000
[drm] register mmio size: 65536
radeon 0000:01:03.0: VRAM: 128M 0x00000000A0000000 - 0x00000000A7FFFFFF (=
64M used)
radeon 0000:01:03.0: GTT: 512M 0x0000000080000000 - 0x000000009FFFFFFF
[drm] Detected VRAM RAM=3D128M, BAR=3D128M
[drm] RAM width 16bits DDR
[TTM] Zone  kernel: Available graphics memory: 529345452 kiB
[TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[TTM] Initializing pool allocator
[TTM] Initializing DMA pool allocator
[drm] radeon: 64M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] GART: num cpu pages 131072, num gpu pages 131072
[drm] PCI GART of 512M enabled (table at 0x00000000FFF00000).
radeon 0000:01:03.0: WB disabled
radeon 0000:01:03.0: fence driver on ring 0 use gpu addr 0x00000000800000=
00 and cpu addr 0xffff88007f021000
[drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[drm] Driver supports precise vblank timestamp query.
[drm] radeon: irq initialized.
[drm] Loading R100 Microcode
[drm] radeon: ring at 0x0000000080001000
[drm] ring test succeeded in 1 usecs
[drm] ib test succeeded in 0 usecs
[drm] No TV DAC info found in BIOS
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   VGA-1
[drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[drm]   Encoders:
[drm]     CRT1: INTERNAL_DAC1
[drm] Connector 1:
[drm]   VGA-2
[drm]   DDC: 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c
[drm]   Encoders:
[drm]     CRT2: INTERNAL_DAC2
[drm] fb mappable at 0xA0040000
[drm] vram apper at 0xA0000000
[drm] size 786432
[drm] fb depth is 8
[drm]    pitch is 1024
fbcon: radeondrmfb (fb0) is primary device
input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/=
input/input3
Console: switching to colour frame buffer device 128x48
radeon 0000:01:03.0: fb0: radeondrmfb frame buffer device
radeon 0000:01:03.0: registered panic notifier
[drm] Initialized radeon 2.37.0 20080528 for 0000:01:03.0 on minor 0
dracut: Starting plymouth daemon
Switched to clocksource tsc
HP HPSA Driver (v 3.4.0-1)
hpsa 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
hpsa 0000:03:00.0: MSIX
hpsa 0000:03:00.0: irq 117 for MSI/MSI-X
hpsa 0000:03:00.0: irq 118 for MSI/MSI-X
hpsa 0000:03:00.0: irq 119 for MSI/MSI-X
hpsa 0000:03:00.0: irq 120 for MSI/MSI-X
hpsa 0000:03:00.0: irq 121 for MSI/MSI-X
hpsa 0000:03:00.0: irq 122 for MSI/MSI-X
hpsa 0000:03:00.0: irq 123 for MSI/MSI-X
hpsa 0000:03:00.0: irq 124 for MSI/MSI-X
hpsa 0000:03:00.0: hpsa0: <0x323a> at IRQ 117 using DAC
scsi0 : hpsa
hpsa 0000:03:00.0: RAID              device c0b3t0l0 added.
hpsa 0000:03:00.0: Direct-Access     device c0b0t0l0 added.
scsi 0:3:0:0: RAID              HP       P410i            3.66 PQ: 0 ANSI=
: 5
scsi 0:0:0:0: Direct-Access     HP       LOGICAL VOLUME   3.66 PQ: 0 ANSI=
: 5
sd 0:0:0:0: [sda] 429925920 512-byte logical blocks: (220 GB/205 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 6b 00 00 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: disabled, doesn't su=
pport DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
end_request: critical medium error, dev sda, sector 2168
Buffer I/O error on device sda1, logical block 15
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
end_request: critical medium error, dev sda, sector 2168
Buffer I/O error on device sda1, logical block 15
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
end_request: critical medium error, dev sda, sector 2168
Buffer I/O error on device sda1, logical block 15
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
end_request: critical medium error, dev sda, sector 2168
Buffer I/O error on device sda1, logical block 15
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
end_request: critical medium error, dev sda, sector 2168
Buffer I/O error on device sda1, logical block 15
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
end_request: critical medium error, dev sda, sector 2176
Buffer I/O error on device sda1, logical block 16
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
end_request: critical medium error, dev sda, sector 2176
Buffer I/O error on device sda1, logical block 16
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
end_request: critical medium error, dev sda, sector 2176
Buffer I/O error on device sda1, logical block 16
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
end_request: critical medium error, dev sda, sector 2176
Buffer I/O error on device sda1, logical block 16
random: nonblocking pool is initialized
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 09 00 00 00 08 00
end_request: critical medium error, dev sda, sector 2304
Buffer I/O error on device sda1, logical block 32
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
Buffer I/O error on device sda1, logical block 16
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
Buffer I/O error on device sda1, logical block 16
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
Buffer I/O error on device sda1, logical block 16
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
Buffer I/O error on device sda1, logical block 16
EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
dracut: Mounted root filesystem /dev/sda2
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
audit: type=3D1404 audit(1397110220.915:2): selinux=3D0 auid=3D4294967295=
 ses=3D4294967295
dracut:=20
dracut: Switching root
readahead: starting
udev: starting version 147
WARNING! power/level is deprecated; use power/control instead
wmi: Mapper loaded
QLogic/NetXen Network Driver v4.0.82
netxen_nic 0000:04:00.0: 2MB memory map
netxen_nic 0000:04:00.0: Direct firmware load failed with error -2
netxen_nic 0000:04:00.0: Falling back to user helper
netxen_nic 0000:04:00.0: Direct firmware load failed with error -2
netxen_nic 0000:04:00.0: Falling back to user helper
netxen_nic 0000:04:00.0: Gen2 strapping detected
netxen_nic 0000:04:00.0: using 64-bit dma mask
netxen_nic: failed card response code:0x10
netxen_nic 0000:04:00.0: Can't get template size 16843009
netxen_nic 0000:04:00.0: Failed to setup minidump rcode =3D -5
netxen_nic: NX3031 Gigabit Ethernet Board S/N =FF=FF=FF=FF=FF=FF=FF=FF=FF=
=FF=FF=FF=FF=FF=FF=FF=FF=FF=FF=FF=FF=FF=FF=FF=FF=FF=FF=FF=FF=FF=FF=FFNX30=
31 Gigabit Ethernet  Chip rev 0x42
netxen_nic 0000:04:00.0: Driver v4.0.82, firmware v4.0.555 [legacy]
netxen_nic 0000:04:00.0: irq 125 for MSI/MSI-X
netxen_nic 0000:04:00.0: irq 126 for MSI/MSI-X
netxen_nic 0000:04:00.0: irq 127 for MSI/MSI-X
netxen_nic 0000:04:00.0: irq 128 for MSI/MSI-X
netxen_nic 0000:04:00.0: using msi-x interrupts
netxen_nic 0000:04:00.0: eth0: GbE port initialized
netxen_nic 0000:04:00.1: 2MB memory map
netxen_nic 0000:04:00.1: using 64-bit dma mask
netxen_nic: failed card response code:0x10
netxen_nic 0000:04:00.1: Can't get template size 16843009
netxen_nic 0000:04:00.1: Failed to setup minidump rcode =3D -5
netxen_nic 0000:04:00.1: Driver v4.0.82, firmware v4.0.555 [legacy]
netxen_nic 0000:04:00.1: irq 129 for MSI/MSI-X
netxen_nic 0000:04:00.1: irq 130 for MSI/MSI-X
netxen_nic 0000:04:00.1: irq 131 for MSI/MSI-X
netxen_nic 0000:04:00.1: irq 132 for MSI/MSI-X
netxen_nic 0000:04:00.1: using msi-x interrupts
netxen_nic 0000:04:00.1: eth1: GbE port initialized
netxen_nic 0000:04:00.2: 2MB memory map
netxen_nic 0000:04:00.2: using 64-bit dma mask
netxen_nic: failed card response code:0x10
netxen_nic 0000:04:00.2: Can't get template size 16843009
netxen_nic 0000:04:00.2: Failed to setup minidump rcode =3D -5
netxen_nic 0000:04:00.2: Driver v4.0.82, firmware v4.0.555 [legacy]
netxen_nic 0000:04:00.2: irq 133 for MSI/MSI-X
netxen_nic 0000:04:00.2: irq 134 for MSI/MSI-X
netxen_nic 0000:04:00.2: irq 135 for MSI/MSI-X
netxen_nic 0000:04:00.2: irq 136 for MSI/MSI-X
netxen_nic 0000:04:00.2: using msi-x interrupts
netxen_nic 0000:04:00.2: eth2: GbE port initialized
netxen_nic 0000:04:00.3: 2MB memory map
netxen_nic 0000:04:00.3: using 64-bit dma mask
netxen_nic: failed card response code:0x10
netxen_nic 0000:04:00.3: Can't get template size 16843009
netxen_nic 0000:04:00.3: Failed to setup minidump rcode =3D -5
netxen_nic 0000:04:00.3: Driver v4.0.82, firmware v4.0.555 [legacy]
netxen_nic 0000:04:00.3: irq 137 for MSI/MSI-X
netxen_nic 0000:04:00.3: irq 138 for MSI/MSI-X
netxen_nic 0000:04:00.3: irq 139 for MSI/MSI-X
netxen_nic 0000:04:00.3: irq 140 for MSI/MSI-X
netxen_nic 0000:04:00.3: using msi-x interrupts
netxen_nic 0000:04:00.3: eth3: GbE port initialized
EDAC MC: Ver: 3.0.0
hpwdt 0000:02:00.0: HP Watchdog Timer Driver: NMI decoding initialized, a=
llow kernel dump: ON (default =3D 0/OFF)
hpwdt 0000:02:00.0: HP Watchdog Timer Driver: 1.3.3, timer margin: 30 sec=
onds (nowayout=3D0).
ACPI Warning: SystemIO range 0x0000000000000928-0x000000000000092f confli=
cts with OpRegion 0x0000000000000920-0x000000000000092f (\SGPE) (20131218=
/utaddress-258)
ACPI: If an ACPI driver is available for this device, you should use it i=
nstead of the native driver
lpc_ich: Resource conflict(s) found affecting gpio_ich
input: PC Speaker as /devices/platform/pcspkr/input/input6
scsi 0:3:0:0: Attached scsi generic sg0 type 12
sd 0:0:0:0: Attached scsi generic sg1 type 0
microcode: CPU0 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU1 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU2 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU3 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU4 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU5 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU6 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU7 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU8 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU9 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU10 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU11 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU12 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU13 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU14 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU15 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU16 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU17 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU18 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU19 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU20 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU21 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU22 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU23 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU24 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU25 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU26 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU27 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU28 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU29 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU30 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU31 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU32 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU33 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU34 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU35 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU36 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU37 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU38 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU39 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU40 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU41 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU42 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU43 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU44 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU45 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU46 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU47 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU48 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU49 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU50 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU51 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU52 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU53 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU54 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU55 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU56 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU57 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU58 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU59 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU60 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU61 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU62 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU63 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU64 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU65 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU66 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU67 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU68 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU69 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU70 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU71 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU72 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU73 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU74 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU75 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU76 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU77 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU78 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU79 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU80 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU81 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU82 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU83 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU84 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU85 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU86 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU87 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU88 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU89 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU90 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU91 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU92 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU93 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU94 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU95 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU96 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU97 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU98 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU99 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU100 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU101 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU102 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU103 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU104 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU105 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU106 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU107 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU108 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU109 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU110 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU111 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU112 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU113 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU114 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU115 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU116 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU117 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU118 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU119 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU120 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU121 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU122 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU123 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU124 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU125 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU126 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU127 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU128 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU129 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU130 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU131 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU132 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU133 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU134 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU135 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU136 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU137 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU138 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU139 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU140 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU141 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU142 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU143 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU144 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU145 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU146 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU147 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU148 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU149 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU150 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU151 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU152 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU153 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU154 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU155 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU156 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU157 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU158 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: CPU159 sig=3D0x206f2, pf=3D0x4, revision=3D0x37
microcode: Microcode Update Driver: v2.00 <tigran-ppwZ4lME3+KI6QP4U9MhSdBc4/FLrbF6@public.gmane.org>, =
Peter Oruba
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
blk_update_request: 4 callbacks suppressed
end_request: critical medium error, dev sda, sector 2168
Buffer I/O error on device sda1, logical block 15
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
end_request: critical medium error, dev sda, sector 2168
Buffer I/O error on device sda1, logical block 15
ipmi message handler version 39.2
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
IPMI System Interface driver.
ipmi_si: probing via ACPI
ipmi_si 00:01: [io  0x0ca2-0x0ca3] regsize 1 spacing 1 irq 0
ipmi_si: Adding ACPI-specified kcs state machine
ipmi_si: probing via SMBIOS
ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
ipmi_si: Adding SMBIOS-specified kcs state machine duplicate interface
ipmi_si: probing via SPMI
ipmi_si: SPMI: io 0xca2 regsize 1 spacing 1 irq 0
ipmi_si: Adding SPMI-specified kcs state machine duplicate interface
ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, sl=
ave address 0x0, irq 0
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
end_request: critical medium error, dev sda, sector 2168
Buffer I/O error on device sda1, logical block 15
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
end_request: critical medium error, dev sda, sector 2168
Buffer I/O error on device sda1, logical block 15
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
end_request: critical medium error, dev sda, sector 2168
Buffer I/O error on device sda1, logical block 15
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
end_request: critical medium error, dev sda, sector 2176
Buffer I/O error on device sda1, logical block 16
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
end_request: critical medium error, dev sda, sector 2176
Buffer I/O error on device sda1, logical block 16
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
end_request: critical medium error, dev sda, sector 2176
Buffer I/O error on device sda1, logical block 16
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
end_request: critical medium error, dev sda, sector 2176
Buffer I/O error on device sda1, logical block 16
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 09 00 00 00 08 00
end_request: critical medium error, dev sda, sector 2304
Buffer I/O error on device sda1, logical block 32
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
ipmi_si 00:01: Found new BMC (man_id: 0x00000b, prod_id: 0x2000, dev_id: =
0x13)
ipmi_si 00:01: IPMI kcs interface initialized
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
iTCO_vendor_support: vendor-support=3D0
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIO=
S
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
Floppy drive(s): fd0 is 1.44M
floppy0: no floppy controllers found
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk-zC7DfRvBq/JWk0Htik3J/w@public.gmane.org>
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@red=
hat.com
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
blk_update_request: 4 callbacks suppressed
end_request: critical medium error, dev sda, sector 2168
quiet_error: 4 callbacks suppressed
Buffer I/O error on device sda1, logical block 15
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
end_request: critical medium error, dev sda, sector 2168
Buffer I/O error on device sda1, logical block 15
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
end_request: critical medium error, dev sda, sector 2168
Buffer I/O error on device sda1, logical block 15
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
end_request: critical medium error, dev sda, sector 2168
Buffer I/O error on device sda1, logical block 15
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
end_request: critical medium error, dev sda, sector 2168
Buffer I/O error on device sda1, logical block 15
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
end_request: critical medium error, dev sda, sector 2176
Buffer I/O error on device sda1, logical block 16
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
end_request: critical medium error, dev sda, sector 2176
Buffer I/O error on device sda1, logical block 16
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
end_request: critical medium error, dev sda, sector 2176
Buffer I/O error on device sda1, logical block 16
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
end_request: critical medium error, dev sda, sector 2176
Buffer I/O error on device sda1, logical block 16
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 09 00 00 00 08 00
end_request: critical medium error, dev sda, sector 2304
Buffer I/O error on device sda1, logical block 32
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
EXT4-fs (sda2): re-mounted. Opts: (null)
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 78 00 00 08 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 09 00 00 00 08 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 80 00 00 08 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 00 00 00 f8 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 f8 00 00 08 00
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda] =20
Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
sd 0:0:0:0: [sda] =20
Sense Key : Medium Error [current]=20
sd 0:0:0:0: [sda] =20
Add. Sense: Unrecovered read error
sd 0:0:0:0: [sda] CDB:=20
Read(10): 28 00 00 00 08 60 00 00 08 00
blk_update_request: 20 callbacks suppressed
end_request: critical medium error, dev sda, sector 2144
quiet_error: 50 callbacks suppressed
Buffer I/O error on device sda1, logical block 12
Adding 16777212k swap on /dev/sda1.  Priority:-1 extents:1 across:1677721=
2k=20
NET: Registered protocol family 10
ip6_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
netxen_nic: eth0 NIC Link is up
IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
netxen_nic: eth1 NIC Link is up
IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
IPv6: ADDRCONF(NETDEV_UP): eth2: link is not ready
netxen_nic: eth2 NIC Link is up
IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
IPv6: ADDRCONF(NETDEV_UP): eth3: link is not ready
netxen_nic: eth3 NIC Link is up
IPv6: ADDRCONF(NETDEV_CHANGE): eth3: link becomes ready
8021q: 802.1Q VLAN Support v1.8
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pcc-cpufreq: (v1.10.00) driver loaded with frequency limits: 1064 MHz, 24=
00 MHz
cpufreq: __cpufreq_add_dev: ->get() failed
Bridge firewalling registered
device virbr0-nic entered promiscuous mode
device virbr0-nic left promiscuous mode
virbr0: port 1(virbr0-nic) entered disabled state
Ebtables v2.0 registered
EXT4-fs (sda2): error count: 46806
EXT4-fs (sda2): initial error at 1381280707: ext4_wait_block_bitmap:471
EXT4-fs (sda2): last error at 1397017904: __ext4_get_inode_loc:3905: inod=
e 8394597: block 33554838

--=-FfuNmsYTl1N+c+eFRY71
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-FfuNmsYTl1N+c+eFRY71--
