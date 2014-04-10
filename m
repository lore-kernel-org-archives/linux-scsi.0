From: Linda Knippers <linda.knippers@hp.com>
Subject: Re: hpsa driver bug crack kernel down!
Date: Thu, 10 Apr 2014 11:36:51 -0400
Message-ID: <5346BA93.5090904@hp.com>
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>	<1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>	<1397084904.9519.62.camel@dabdike>	<1397085044.9519.63.camel@dabdike>	<1397086817.2608.25.camel@buesod1.americas.hpqcorp.net>	<1397087425.9519.67.camel@dabdike>	<1397089180.2608.27.camel@buesod1.americas.hpqcorp.net>	<CAErSpo4H=hcro8sMnt2MzDDVCROpASuUTQWBw37OxodHTyOfyw@mail.gmail.com>	<1397111557.2608.29.camel@buesod1.americas.hpqcorp.net>	<20140410071535.GX13491@8bytes.org>	<1397119587.19944.14.camel@shinybook.infradead.org> <CAErSpo6EORf02WS1UqP8EMWfHij7W2J5B3ZOoBT90txV85uZZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CAErSpo6EORf02WS1UqP8EMWfHij7W2J5B3ZOoBT90txV85uZZw@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>, "Woodhouse, David" <david.woodhouse@intel.com>
Cc: "bhe@redhat.com" <bhe@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "davidlohr@hp.com" <davidlohr@hp.com>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On 4/10/2014 11:14 AM, Bjorn Helgaas wrote:
> On Thu, Apr 10, 2014 at 2:46 AM, Woodhouse, David
> <david.woodhouse@intel.com> wrote:
>=20
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
>=20
> I like the "wrong IOMMU (or no IOMMU at all)" theory.  If we didn't
> connect the device with an IOMMU at all, that would explain the devic=
e
> DMAing directly to a physical address, wouldn't it?
>=20
>> Do you have 'iommu=3Dpt' on the kernel command line? Can I see the f=
ull
>> dmesg as this system boots, and also a copy of the DMAR table?

This will be really helpful information.  This box has devices with
RMRR records and if they're not set up correctly, DMAR faults can occur=
=2E

>>
>> We should also rate-limit DMA faults, which would avoid the lockup
>> failure mode. Bjorn, what should an IOMMU driver *do* when it detect=
s
>> that a device is creating an endless stream of DMA faults and isn't
>> aborting the transaction?
>=20
> You mentioned that POWER with EEH does something intelligent in this
> case, but I'm not familiar with that code.  We have AER support, whic=
h
> can result in resetting a device, but I think DMA faults are reported
> differently, and I don't think there's any nice existing way for PCI
> to deal with them.  Maybe there should be, though.
>=20
> Bjorn
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
>=20
