From: "Isabelle, Francois" <Francois.Isabelle@ca.kontron.com>
Subject: RE: mptsas/iommu/pciehp : PCIe hotplug of LSISAS1064E  fails withintel_iommu=on
Date: Fri, 18 Sep 2009 16:53:44 -0400
Message-ID: <C2866F9FC4CB034EB51A633DF168598605DC8790@ssbarcelone>
References: <C2866F9FC4CB034EB51A633DF168598605D68925@ssbarcelone> <20090911163933.GC2907@lackof.org> <C2866F9FC4CB034EB51A633DF168598605DC7E0E@ssbarcelone> <20090918044943.GA337@lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20090918044943.GA337@lackof.org>
Sender: linux-pci-owner@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-scsi@vger.kernel.org, iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org, DL-MPTFusionLinux@lsi.com
List-Id: linux-scsi@vger.kernel.org


> Yes - IOMMU support owns that. Anything allocated/mapped with
> pci_alloc_consistent() needs to have both read and write permissions
> for both Host and PCI target. This definitely not a device driver
> problem. Just need to verify the access was to that range.
> I've lost track of the original address that was the problem.

It was 0xfffc2000, which is in the range allocated (alloc_dma)

>>> I'd be looking for why the ioc number changed. It should be resumin=
g
>> with the same instance number since it's the same physical device.

Yes , that's what I though as well.

I tried to trace the expected call sequence , it seems like pci resourc=
es are correctly unassigned.

The folling sequence is executed on removal:

pci_remove_bus_device
pci_stop_dev
MPT:detach
pci_destroy_devs
pci_free_resources

I figured out that the ioc 'id' is not decremented in mpt_detach() and =
that it's used for some kind of reverse lookup by mptsas.c and by mpt_v=
erify_adapter(), mostly used for mptclt. But it appears to be almost on=
ly cosmetical...

=2E..
On the IOMMU side, I see that it sets mapping (CONTEXT_TT_MULTI_LEVEL))=
 for the SAS controller.

#ipmitool  picmg policy set 2 1 0
deb64:~# pciehp 0000:00:04.0:pcie04: Card present on Slot(52)
pciehp 0000:00:04.0:pcie04: Latch close on Slot(52)
pciehp 0000:00:04.0:pcie04: Button pressed on Slot(52)
pciehp 0000:00:04.0:pcie04: PCI slot #52 - powering on due to button pr=
ess.
=46usion MPT base driver 3.04.12
Copyright (c) 1999-2008 LSI Corporation
=46usion MPT SAS Host driver 3.04.12
mptsas 0000:06:00.0: enabling device (0000 -> 0002)
mptsas 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
mptbase: ioc0: Initiating bringup
ioc0: LSISAS1064E B3: Capabilities=3D{Initiator}
IOMMU: get valid domain for 0000:06:00.0
IOMMU: mapping 0000:06:00.0
IOMMU: lsi 06:00.0
IOMMU: continue mapping for 06:00.0
IOMMU: mapping for 06:00.0 completed
IOMMU: mapping no upstream  0000:06:00.0
scsi7 : ioc0: LSISAS1064E B3, FwRev=3D011b0000h, Ports=3D1, MaxQ=3D277,=
 IRQ=3D16

=2E..
I looked at the driver correctness for alloc/free of dma memory, and it=
 seems the play by the book as long as the DMA goes. With some extra de=
bugging I get:


ptbase: ioc0: ChainBuffer sz=3D128 bytes, ChainDepth=3D1143
mptbase: ioc0: ChainBuffer sz=3D146304[23b80] bytes num_chain=3D1143
IOMMU:alloc coherent
IOMMU:succeeded 000000003bc00000(ffff88003bc00000) 192512 ffffffff
mptbase: ioc0: Total alloc @ ffff88003bc00000[00000000fffc0000], sz=3D1=
92000[2ee00] bytes
mptbase: ioc0: ReplyBuffers @ ffff88003bc00000[00000000fffc0000]
mptbase: ioc0: RequestBuffers @ ffff88003bc02800[00000000fffc2800]
mptbase: ioc0: ChainBuffers @ ffff88003bc0b280(00000000fffcb280)
IOMMU:alloc coherent
IOMMU:succeeded 000000003d1f8000(ffff88003d1f8000) 20480 ffffffff
mptbase: ioc0: SenseBuffers @ ffff88003d1f8000[00000000fffb8000]
mptbase: ioc0: ReplyBuffers @ ffff88003bc00000[00000000fffc0000]
mptbase: ioc0: SendIocInit
mptbase: ioc0: facts.MsgVersion=3D105
mptbase: ioc0: Sending Port(0)Enable (req @ ffff88003da6da98)
mptbase: ioc0: Wait IOC_OPERATIONAL state (cnt=3D0)

The DMA memory is freed on removal:

mptbase: ioc0: free  @ ffff88003bc00000, sz=3D192000 bytes
IOMMU:free coherent
IOMMU:free coherent
mptsas 0000:06:00.0: PCI INT A disabled

However, I see the 'free' called  at mptbase.c:4596 uses the allocated =
size (192000) rather than the page padded size(192512) really allocated=
 by the IOMMU engine, but I doubt it could be the cause for this proble=
m.
=2E..

So I'm starting to think the IOMMU driver messes up the mapping tables =
in some way on deallocation/reallocation operations.

I must admist I don't fully understand the impact of this change: http:=
//kerneltrap.org/mailarchive/git-commits-head/2009/7/3/6134073

But seeing these lines=20
-			dma_set_pte_readable(pte);
-			dma_set_pte_writable(pte);

I can't believe it's not related to this message:

DMAR:[DMA Read] Request device [06:00.0] fault addr fffc3000
DMAR:[fault reason 06] PTE Read access is not set

=2E.. this still needs some investigation.

Thank you

=46ran=E7ois Isabelle | Software Designer | Kontron Canada | T 450 437 =
5682 |F 450 437 8053 | E francois.isabelle@ca.kontron.com
