From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH V2 1/3] scsi: mptxsas: try 64 bit DMA when 32 bit DMA
 fails
Date: Mon, 9 Nov 2015 18:22:22 -0500
Message-ID: <56412AAE.80004@codeaurora.org>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
 <4041362.9GKaSPm9gs@wuerfel> <5640A8A8.90203@codeaurora.org>
 <6940177.lD0iNnWRJy@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6940177.lD0iNnWRJy@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, timur@codeaurora.org, cov@codeaurora.org, jcm@redhat.com, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, linux-arm-msm@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, agross@codeaurora.org, MPT-FusionLinux.pdl@avagotech.com
List-Id: linux-scsi@vger.kernel.org



On 11/9/2015 9:33 AM, Arnd Bergmann wrote:
> On Monday 09 November 2015 09:07:36 Sinan Kaya wrote:
>>
>> On 11/9/2015 3:59 AM, Arnd Bergmann wrote:
>>> On Monday 09 November 2015 08:09:39 Hannes Reinecke wrote:
>>>> On 11/09/2015 02:57 AM, Sinan Kaya wrote:
>>>>> Current code gives up when 32 bit DMA is not supported.
>>>>> This problem has been observed on systems without any
>>>>> memory below 4 gig.
>>>>>
>>>>> This patch tests 64 bit support before bailing out to find
>>>>> a working combination.
>>>>>
>>>> That feels decidedly odd.
>>>>
>>>> Why do you probe for 64bit if 32bit fails?
>>>
>>> 32-bit DMA mask on PCI cannot fail, we rely on that in all sorts
>>> of places. If the machine has all of its RAM visible above 4GB
>>> PCI bus addresses, it must use an IOMMU.
>>
>> Can you be specific? PCIe does not have this limitation. It supports 32
>> bit and 64 bit TLPs.
>>
>> I have not seen any limitation so far in the OS either.
>
> See Documentation/DMA-API-HOWTO.txt
>
> All PCI devices start out with a 32-bit DMA mask, and Linux assumes it
> can always fall back to a 32-bit mask if a smaller mask (needed for
> some devices that only support DMA on a subset of the 4GB) or larger
> mask (needed to address high memory but can fail when the PCI host
> does not support it) cannot be set.
>
>> Using IOMMU is fine but not required if the endpoint is a true 64 bit
>> supporting endpoint. This endpoint supports 64bit too.
>
> There are two aspects here:
>
> a) setting a 32-bit mask should not have failed. Any device that actually
>     needs 32-bit DMA will make the same call and the platform must
>     guarantee that this works. If you have a broken platform that can't
>     do this, complain to your board vendor so they wire up the RAM
>     properly, with at least the first 2GB visible to low PCI bus
>     addresses.
>
> b) If the platform has any memory above 4GB and the supports high DMA,
>     it should never have asked for the 32-bit mask before trying the
>     64-bit mask first. This is only a performance optimization, but the
>     driver seems to do the right thing, so I assume there is something
>     wrong with the platform code.
>
>>>> Typically it's the other way round, on the grounds that 64bit DMA
>>>> should be preferred over 32bit.
>>>> Can you explain why it needs to be done the other way round here?
>>>
>>> Something else is odd here, the driver already checks for
>>> dma_get_required_mask(), which will return the smallest mask
>>> that fits all of RAM. If the machine has any memory above 4GB,
>>> it already uses the 64-bit mask, and only falls back to
>>> the 32-bit mask if that fails or if all memory fits within the
>>> first 4GB.
>>>
>>
>> I'll add some prints in the code to get to the bottom of it. I think the
>> code is checking more than just the required mask and failing in one of
>> the other conditions. At least that DMA comparison code was more than
>> what I have ever seen.
>
> Ok. That should take care of b) above, but we still have a bug with a)
> that will come back to bite you if you don't address it right.
>
> 	Arnd
>

B should have worked and it doesn't. B works for other drivers but not 
for this particular one.

As you said,
"it should never have asked for the 32-bit mask before trying the
64-bit mask first."

this is the problem.

This HW doesn't have support for a. If I need a, I am required to use 
IOMMU. Here is what I found.

mpt2sas version 20.100.00.00 loaded
sizeof(dma_addr_t):8
ioc->dma_mask :0
dma_get_required_mask(&pdev->dev) :7fffffffff
mpt2sas0: no suitable DMA mask for 0002:01:00.0
mpt2sas0: failure at 
drivers/scsi/mpt2sas/mpt2sas_scsih.c:8498/_scsih_probe()!


Here is the code.

if (ioc->dma_mask)
	consistent_dma_mask = DMA_BIT_MASK(64);
else
	consistent_dma_mask = DMA_BIT_MASK(32); 	<-- why here?

if (sizeof(dma_addr_t) > 4) {			<-- true
	const uint64_t required_mask =
	    dma_get_required_mask(&pdev->dev);
	if ((required_mask > DMA_BIT_MASK(32)) &&	<-- true
	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) && <-- true
	    !pci_set_consistent_dma_mask(pdev, consistent_dma_mask)) { <-- false
		ioc->base_add_sg_single = &_base_add_sg_single_64;
		ioc->sge_size = sizeof(Mpi2SGESimple64_t);
		ioc->dma_mask = 64;
		goto out;
	}
}

ioc->dma_mask is 0 and the driver is trying to use 32 bit even though 64 
bit supported by the platform.

I think the proper fix is to pass the required_mask back to 
consistent_dma_mask rather than using ioc->dma_mask and guessing.

pci_set_consistent_dma_mask(pdev, required_mask)

My code was just a band aid for broken code.

The driver worked after that changing the above line only.

mpt2sas_version_20.100.00.00_loaded
sizeof(dma_addr_t) :8
ioc->dma_mask :0
dma_get_required_mask(&pdev->dev) :7fffffffff
mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (16411112 kB)
mpt2sas0: MSI-X vectors supported: 1, no of cores: 24, max_msix_vectors: 8
mpt2sas0: IO-APIC enabled: IRQ 105
mpt2sas0: iomem(0x00000a01005c0000), mapped(0xffff0000008d8000), size(16384)
mpt2sas0: ioport(0x0000000000000000), size(0)
mpt2sas0: Allocated physical memory: size(3392 kB)
mpt2sas0: Current Controller Queue Depth(1483), Max Controller Queue 
Depth(1720)
mpt2sas0: Scatter Gather Elements per IO(128)
mpt2sas0: LSISAS2004: FWVersion(17.00.01.00), ChipRevision(0x03), 
BiosVersion(07.33.0
mpt2sas0: Protocol=(Initiator), Capabilities=(Raid,TLR,EEDP,Snapshot 
Buffer,Diag Trac
scsi host0: Fusion MPT SAS Host
mpt2sas0: sending port enable !!
mpt2sas0: host_add: handle(0x0001), sas_addr(0x500062b0002de4f0), phys(8)
mpt2sas0: port enable: SUCCESS
scsi 0:0:0:0: Direct-Access     ATA      Samsung SSD 845D 3X3Q PQ: 0 ANSI: 6
scsi 0:0:0:0: SATA: handle(0x0009), sas_addr(0x4433221101000000), 
phy(1), device_name



-- 
Sinan Kaya
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
