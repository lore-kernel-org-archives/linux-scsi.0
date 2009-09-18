From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: mptsas/iommu/pciehp : PCIe hotplug of LSISAS1064E  fails with
	intel_iommu=on
Date: Thu, 17 Sep 2009 22:49:43 -0600
Message-ID: <20090918044943.GA337@lackof.org>
References: <C2866F9FC4CB034EB51A633DF168598605D68925@ssbarcelone> <20090911163933.GC2907@lackof.org> <C2866F9FC4CB034EB51A633DF168598605DC7E0E@ssbarcelone>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <C2866F9FC4CB034EB51A633DF168598605DC7E0E@ssbarcelone>
Sender: linux-pci-owner@vger.kernel.org
To: "Isabelle, Francois" <Francois.Isabelle@ca.kontron.com>
Cc: linux-scsi@vger.kernel.org, iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org, DL-MPTFusionLinux@lsi.com, Grant Grundler <grundler@parisc-linux.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 16, 2009 at 12:04:27PM -0400, Isabelle, Francois wrote:
> >>PrimeIocFifos calls pci_alloc_consistent() and has debug code to du=
mp
> >>the DMA resource allocated (both virtual and DMA addresses). Off ha=
nd
> >>I don't know how to enable that but it would be the next step.
>=20
> With mpt_debug_level=3D0x8060 , I was able to get the allocation code=
 to be more verbose, see below.

Cool - noted.

> >>> DRHD: handling fault status reg 2
> >>> DMAR:[DMA Read] Request device [06:00.0] fault addr fffc2000
>=20
> >>fffc2000 seems to be an unusual address to DMA from/to.
> >>Is fffc2000 reserved address space for the IOMMU?
> >> (ACPI DMAR info should tell us this)
>=20
> It seems to be the actual address (see below); however I think there =
might be some kind of page overlap between the 'reply buffer' and 'requ=
est buffer' ...
>=20
> mptbase: ioc0: ReplyBuffers @ ffff88003b180000[00000000fffc0000]
> mptbase: ioc0: RequestBuffers @ ffff88003b182800[00000000fffc2800]

Excellent. This corresponds with:
                dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ReplyBuffers=
 @ %p[%p]\n",
                        ioc->name, ioc->reply_frames, (void *)(ulong)al=
loc_dma));

alloc_dma is the DMA Mapped address.

I don't believe the two ranges overlap based on this output:
> mptbase: ioc0: ReplyBuffer sz=3D80 bytes, ReplyDepth=3D128
> mptbase: ioc0: ReplyBuffer sz=3D10240[2800] bytes

that you included at the bottom of the email.


>=20
> > > > > DMAR:[fault reason 06] PTE Read access is not set
> > > > It's also odd that "Read Access is not set" for something (ioc_=
init)
> > > > that I think should be bi-directional.
>=20
> Wouldn't that depend on the IOMMU driver? Or is the device driver sup=
posed to set protections?

Yes - IOMMU support owns that. Anything allocated/mapped with
pci_alloc_consistent() needs to have both read and write permissions
for both Host and PCI target. This definitely not a device driver
problem. Just need to verify the access was to that range.
I've lost track of the original address that was the problem.

> When we compare the 2 'init' we see differences in the 'mem_phys' ent=
ry, which I think is weird, especially if it should match the PCI memor=
y region of the device
> >>      Region 1: Memory at dbffc000 (64-bit, non-prefetchable) [size=
=3D16K]
> >>      Region 3: Memory at dbfe0000 (64-bit, non-prefetchable) [size=
=3D64K]
>=20
> mptbase: ioc0: mem =3D ffffc90012e40000, mem_phys =3D dbffc000
> mptbase: ioc0: facts @ ffff88003dc2541c, pfacts[0] @ ffff88003dc2546c
> ...
> mptbase: ioc1: mem =3D ffffc90012e48000, mem_phys =3D d8010000
> mptbase: ioc1: facts @ ffff88003d21041c, pfacts[0] @ ffff88003d21046c

The Region 1 and Region 3 are for the same controller (ioc0).
Not for two different controllers. The second controller should
have it's own pair of Region 1 and Region 3 configuration space registe=
rs.

> ..and we see differences in the chain buffers..
>=20
> mptbase: ioc0: ReqToChain alloc  @ ffff88003d4d8800, sz=3D1108 bytes
> mptbase: ioc0: RequestNB alloc  @ ffff88003e3f3000, sz=3D1108 bytes
> mptbase: ioc0: ChainToChain alloc @ ffff88003db14000, sz=3D4572 bytes
>=20
> mptbase: ioc1: ReqToChain alloc  @ ffff88003d2aa000, sz=3D1108 bytes
> mptbase: ioc1: RequestNB alloc  @ ffff88003d268800, sz=3D1108 bytes
> mptbase: ioc1: ChainToChain alloc @ ffff88003dfda000, sz=3D4572 bytes

I'm not sure what you are comparing with the previous 6 lines of output=
=2E
The two controller (ioc0 and ioc1) are required to have different
chain buffers.

> The other thing that is now obvious is that the device name has
> changed (ioc1 instead of ioc0);

Yes - good catch.

> this makes me think that the whole
> problem is probably more closely related to the resources unallocatio=
n,
> maybe a missing 'unlink' operation of some kind... I'm looking into
> this, but I could still use some help if anyone has an idea.

I'd be looking for why the ioc number changed. It should be resuming
with the same instance number since it's the same physical device.

hth,
grant

>=20
> Following is the complete MPTSAS init log.
>=20
> =3D=3D=3D=3D First time init  =3D=3D=3D
>=20
> mptsas 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> mptbase: ioc0: : 32 BIT PCI BUS DMA ADDRESSING SUPPORTED
> mptbase: ioc0: mem =3D ffffc90012e40000, mem_phys =3D dbffc000
> mptbase: ioc0: facts @ ffff88003dc2541c, pfacts[0] @ ffff88003dc2546c
> mptbase: ioc0: Initiating bringup
> mptbase: ioc0: IOC is in READY state
> mptbase: ioc0: Sending get IocFacts request req_sz=3D12 reply_sz=3D80
> mptbase: ioc0: NB_for_64_byte_frame=3D2 NBShiftFactor=3D5 BlockSize=3D=
8
> mptbase: ioc0: reply_sz=3D 80, reply_depth=3D 128
> mptbase: ioc0: req_sz  =3D128, req_depth  =3D 277
> mptbase: ioc0: Sending get PortFacts(0) request
> ioc0: LSISAS1064E B3: Capabilities=3D{Initiator}
> mptsas 0000:06:00.0: setting latency timer to 64
> mptbase: ioc0: installed at interrupt 16
> mptbase: ioc0: PrimeIocFifos
> mptbase: ioc0: ReqToChain alloc  @ ffff88003d4d8800, sz=3D1108 bytes
> mptbase: ioc0: RequestNB alloc  @ ffff88003e3f3000, sz=3D1108 bytes
> mptbase: ioc0: num_sge=3D25 numSGE=3D520
> mptbase: ioc0: Now numSGE=3D128 num_sge=3D130 num_chain=3D9
> mptbase: ioc0: ChainToChain alloc @ ffff88003db14000, sz=3D4572 bytes
> mptbase: ioc0: ReplyBuffer sz=3D80 bytes, ReplyDepth=3D128
> mptbase: ioc0: ReplyBuffer sz=3D10240[2800] bytes
> mptbase: ioc0: RequestBuffer sz=3D128 bytes, RequestDepth=3D277
> mptbase: ioc0: RequestBuffer sz=3D35456[8a80] bytes
> mptbase: ioc0: ChainBuffer sz=3D128 bytes, ChainDepth=3D1143
> mptbase: ioc0: ChainBuffer sz=3D146304[23b80] bytes num_chain=3D1143
> mptbase: ioc0: Total alloc @ ffff88003b180000[00000000fffc0000], sz=3D=
192000[2ee00] bytes
> mptbase: ioc0: ReplyBuffers @ ffff88003b180000[00000000fffc0000]
> mptbase: ioc0: RequestBuffers @ ffff88003b182800[00000000fffc2800]
> mptbase: ioc0: ChainBuffers @ ffff88003b18b280(00000000fffcb280)
> mptbase: ioc0: SenseBuffers @ ffff88003d2f8000[00000000fffb8000]
> mptbase: ioc0: ReplyBuffers @ ffff88003b180000[00000000fffc0000]
> mptbase: ioc0: SendIocInit
> mptbase: ioc0: facts.MsgVersion=3D105
> mptbase: ioc0: Sending Port(0)Enable (req @ ffff88003cc63a98)
> mptbase: ioc0: Wait IOC_OPERATIONAL state (cnt=3D0)
> mptbase: ioc0: SendEventNotification
> scsi15 : ioc0: LSISAS1064E B3, FwRev=3D011b0000h, Ports=3D1, MaxQ=3D2=
77, IRQ=3D16
>=20
> =3D=3D=3D=3D Reinit after PCIe Hotplug  =3D=3D=3D=20
>=20
> tsas 0000:06:00.0: enabling device (0000 -> 0002)
> mptsas 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> mptbase: ioc1: : 32 BIT PCI BUS DMA ADDRESSING SUPPORTED
> mptbase: ioc1: mem =3D ffffc90012e48000, mem_phys =3D d8010000
> mptbase: ioc1: facts @ ffff88003d21041c, pfacts[0] @ ffff88003d21046c
> mptbase: ioc1: Initiating bringup
> mptbase: ioc1: IOC is in READY state
> mptbase: ioc1: Sending get IocFacts request req_sz=3D12 reply_sz=3D80
> mptbase: ioc1: NB_for_64_byte_frame=3D2 NBShiftFactor=3D5 BlockSize=3D=
8
> mptbase: ioc1: reply_sz=3D 80, reply_depth=3D 128
> mptbase: ioc1: req_sz  =3D128, req_depth  =3D 277
> mptbase: ioc1: Sending get PortFacts(0) request
> ioc1: LSISAS1064E B3: Capabilities=3D{Initiator}
> mptsas 0000:06:00.0: setting latency timer to 64
> mptbase: ioc1: installed at interrupt 16
> mptbase: ioc1: PrimeIocFifos
> mptbase: ioc1: ReqToChain alloc  @ ffff88003d2aa000, sz=3D1108 bytes
> mptbase: ioc1: RequestNB alloc  @ ffff88003d268800, sz=3D1108 bytes
> mptbase: ioc1: num_sge=3D25 numSGE=3D520
> mptbase: ioc1: Now numSGE=3D128 num_sge=3D130 num_chain=3D9
> mptbase: ioc1: ChainToChain alloc @ ffff88003dfda000, sz=3D4572 bytes
> mptbase: ioc1: ReplyBuffer sz=3D80 bytes, ReplyDepth=3D128
> mptbase: ioc1: ReplyBuffer sz=3D10240[2800] bytes                  =3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D> (2800h bytes)
> mptbase: ioc1: RequestBuffer sz=3D128 bytes, RequestDepth=3D277
> mptbase: ioc1: RequestBuffer sz=3D35456[8a80] bytes
> mptbase: ioc1: ChainBuffer sz=3D128 bytes, ChainDepth=3D1143
> mptbase: ioc1: ChainBuffer sz=3D146304[23b80] bytes num_chain=3D1143
> mptbase: ioc1: Total alloc @ ffff88003b180000[00000000fffc0000], sz=3D=
192000[2ee00] bytes
> mptbase: ioc1: ReplyBuffers @ ffff88003b180000[00000000fffc0000]
> mptbase: ioc1: RequestBuffers @ ffff88003b182800[00000000fffc2800]
> mptbase: ioc1: ChainBuffers @ ffff88003b18b280(00000000fffcb280)
> mptbase: ioc1: SenseBuffers @ ffff88003d2f8000[00000000fffb8000]
> mptbase: ioc1: ReplyBuffers @ ffff88003b180000[00000000fffc0000] =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D>  (2800h bytes)
> mptbase: ioc1: SendIocInit
> mptbase: ioc1: facts.MsgVersion=3D105
> mptbase: ioc1: Sending Port(0)Enable (req @ ffff88003e28d880)
> deb64:~#
>=20
>=20
> b64:~# mptbase: ioc1: WARNING - Issuing Reset from mpt_config!!
> mptbase: ioc1: Initiating recovery
> mptbase: ioc1: WARNING - IOC is in FAULT state!!!
> mptbase: ioc1: WARNING -            FAULT code =3D 2000h
> mptbase: ioc1: Recovered from IOC FAULT
> mptbase: ioc1: PrimeIocFifos
> mptbase: ioc1: SendIocInit
> mptbase: ioc1: SendEventNotification
> mptbase: ioc1: Attempting Retry Config request type 0x1, page 0x2, ac=
tion 0
> DRHD: handling fault status reg 102
> DMAR:[DMA Read] Request device [06:00.0] fault addr fffc2000
> DMAR:[fault reason 06] PTE Read access is not set
>=20
>=20
> Thank you
>=20
> Fran=E7ois Isabelle | Software Designer | Kontron Canada | T 450 437 =
5682 |F 450 437 8053 | E francois.isabelle@ca.kontron.com
