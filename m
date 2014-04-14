From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: hpsa driver bug crack kernel down!
Date: Mon, 14 Apr 2014 16:57:47 +0800
Message-ID: <534BA30B.5040102@linux.intel.com>
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>	 <1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>	 <1397084904.9519.62.camel@dabdike> <1397085044.9519.63.camel@dabdike>	 <1397086817.2608.25.camel@buesod1.americas.hpqcorp.net>	 <1397087425.9519.67.camel@dabdike>	 <1397089180.2608.27.camel@buesod1.americas.hpqcorp.net>	 <CAErSpo4H=hcro8sMnt2MzDDVCROpASuUTQWBw37OxodHTyOfyw@mail.gmail.com>	 <1397111557.2608.29.camel@buesod1.americas.hpqcorp.net>	 <20140410071535.GX13491@8bytes.org>	 <1397119587.19944.14.camel@shinybook.infradead.org> <1397146781.2608.46.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1397146781.2608.46.camel@buesod1.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <davidlohr@hp.com>, "Woodhouse, David" <david.woodhouse@intel.com>
Cc: "joro@8bytes.org" <joro@8bytes.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bhe@redhat.com" <bhe@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "bhelgaas@google.com" <bhelgaas@google.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>
List-Id: linux-scsi@vger.kernel.org

Hi all,
	I guess I found the root cause. It's a bug in matching
device scope, variable 'level' should be decreased when walking up PCI
topology.
	Could you please help to test following patch?
Thanks!
Gerry

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index f445c10..1f8308c 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -152,7 +152,7 @@ dmar_alloc_pci_notify_info(struct pci_dev *dev,
unsigned long event)
        info->seg =3D pci_domain_nr(dev->bus);
        info->level =3D level;
        if (event =3D=3D BUS_NOTIFY_ADD_DEVICE) {
-               for (tmp =3D dev, level--; tmp; tmp =3D tmp->bus->self)=
 {
+               for (tmp =3D dev, level--; tmp; level--, tmp =3D
tmp->bus->self) {
                        info->path[level].device =3D PCI_SLOT(tmp->devf=
n);
                        info->path[level].function =3D PCI_FUNC(tmp->de=
vfn);
                        if (pci_is_root_bus(tmp->bus))


On 2014/4/11 0:19, Davidlohr Bueso wrote:
> On Thu, 2014-04-10 at 08:46 +0000, Woodhouse, David wrote:
>> On Thu, 2014-04-10 at 09:15 +0200, Joerg Roedel wrote:
>>> [+ David, VT-d maintainer ]
>>>
>>> Jiang, David, can you please have a look into this issue?
>>>
>>
>>>>>>>>>>> DMAR:[fault reason 02] Present bit in context entry is clea=
r
>>>>>>>>>>> dmar: DRHD: handling fault status reg 602
>>>>>>>>>>> dmar: DMAR:[DMA Read] Request device [02:00.0] fault addr 7=
f61e000
>>
>> That "Present bit in context entry is clear" fault means that we hav=
e
>> not set up *any* mappings for this PCI device=E2=80=A6 on this IOMMU=
=2E
>>
>>>> Yes, specifically (finally done bisecting):
>>>>
>>>> commit 2e45528930388658603ea24d49cf52867b928d3e
>>>> Author: Jiang Liu <jiang.liu@linux.intel.com>
>>>> Date:   Wed Feb 19 14:07:36 2014 +0800
>>>>
>>>>     iommu/vt-d: Unify the way to process DMAR device scope array
>>
>> This commit is about how we decide which IOMMU a given PCI device is
>> attached to.
>>
>> Thus, my first guess would be that we are quite happily setting up t=
he
>> requested DMA maps on the *wrong* IOMMU, and then taking faults when=
 the
>> device actually tries to do DMA.
>>
>> However, I'm not 100% convinced of that. The fault address looks
>> suspiciously like a true physical address, not a virtual bus address=
 of
>> the type that we'd normally allocate for a dma_map_* operation. Thos=
e
>> would start at 0xfffff000 and work downwards, typically.
>>
>> Do you have 'iommu=3Dpt' on the kernel command line?=20
>=20
> No.
>=20
>> Can I see the full
>> dmesg as this system boots, and also a copy of the DMAR table?
>=20
> Attaching a dmesg from one of the kernels that boots. It doesn't appe=
ar
> to have much of the related information... is there any debug config
> option I can enable that might give you more data?
>=20
