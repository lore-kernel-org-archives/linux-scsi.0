From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: hpsa driver bug crack kernel down!
Date: Mon, 14 Apr 2014 15:01:07 +0800
Message-ID: <534B87B3.1060401@linux.intel.com>
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>	 <1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>	 <1397084904.9519.62.camel@dabdike> <1397085044.9519.63.camel@dabdike>	 <1397086817.2608.25.camel@buesod1.americas.hpqcorp.net>	 <1397087425.9519.67.camel@dabdike>	 <1397089180.2608.27.camel@buesod1.americas.hpqcorp.net>	 <CAErSpo4H=hcro8sMnt2MzDDVCROpASuUTQWBw37OxodHTyOfyw@mail.gmail.com>	 <1397111557.2608.29.camel@buesod1.americas.hpqcorp.net>	 <20140410071535.GX13491@8bytes.org>	 <1397119587.19944.14.camel@shinybook.infradead.org> <1397146781.2608.46.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1397146781.2608.46.camel@buesod1.americas.hpqcorp.net>
Sender: linux-pci-owner@vger.kernel.org
To: Davidlohr Bueso <davidlohr@hp.com>, "Woodhouse, David" <david.woodhouse@intel.com>
Cc: "joro@8bytes.org" <joro@8bytes.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bhe@redhat.com" <bhe@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "bhelgaas@google.com" <bhelgaas@google.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>
List-Id: linux-scsi@vger.kernel.org

Hi Davidlohr,
	Thanks for the information!
	According to lspci output, device 0000:02:00.2 is HP ILO
controller, device 0000:03:00.0 is RAID controller. Both ILO and
RAID controllers need to access reserved memory range
[0x7f61e000 - 0x7f61ffff] in physical mode.

	According to dmesg output, BIOS has reserved memory and
IOMMU has setup 1:1 mapping for ILO and RAID controller to access
this range. Related log messages as below:
BIOS-e820: [mem 0x000000007f61d000-0x000000008fffffff] reserved
IOMMU: Setting RMRR:
IOMMU: Setting identity map for device 0000:03:00.0 [0x7f61e000 -
0x7f61ffff]
IOMMU: Setting identity map for device 0000:02:00.0 [0x7f61e000 -
0x7f61ffff]
IOMMU: Setting identity map for device 0000:02:00.2 [0x7f61e000 -
0x7f61ffff]
=09
	From the screenshot, device 0000:02:00.2 fails to access
memory address 0x7f61e000. That indicates IOMMU driver fails to
setup 1:1 mapping for Reserved Memory Range for ILO controller.
So could you please help to check whether you could observe boot
messages like "IOMMU: Setting identity map for device 0000:02:00.2
[0x7f61e000 - 0x7f61ffff]" with the failure kernel image?

	It would be great if boot messages could be saved when
failing to boot, so we could get more information from log.

	BTW, I have double checked related code, and still can't
find a reliable explanation for the regression:(

Thanks!
Gerry

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
