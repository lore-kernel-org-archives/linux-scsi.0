From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH V2 1/3] scsi: mptxsas: try 64 bit DMA when 32 bit DMA fails
Date: Mon, 09 Nov 2015 15:33:34 +0100
Message-ID: <6940177.lD0iNnWRJy@wuerfel>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org> <4041362.9GKaSPm9gs@wuerfel> <5640A8A8.90203@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5640A8A8.90203@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, timur@codeaurora.org, cov@codeaurora.org, jcm@redhat.com, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, linux-arm-msm@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, agross@codeaurora.org, MPT-FusionLinux.pdl@avagotech.com
List-Id: linux-scsi@vger.kernel.org

On Monday 09 November 2015 09:07:36 Sinan Kaya wrote:
> 
> On 11/9/2015 3:59 AM, Arnd Bergmann wrote:
> > On Monday 09 November 2015 08:09:39 Hannes Reinecke wrote:
> >> On 11/09/2015 02:57 AM, Sinan Kaya wrote:
> >>> Current code gives up when 32 bit DMA is not supported.
> >>> This problem has been observed on systems without any
> >>> memory below 4 gig.
> >>>
> >>> This patch tests 64 bit support before bailing out to find
> >>> a working combination.
> >>>
> >> That feels decidedly odd.
> >>
> >> Why do you probe for 64bit if 32bit fails?
> >
> > 32-bit DMA mask on PCI cannot fail, we rely on that in all sorts
> > of places. If the machine has all of its RAM visible above 4GB
> > PCI bus addresses, it must use an IOMMU.
> 
> Can you be specific? PCIe does not have this limitation. It supports 32 
> bit and 64 bit TLPs.
> 
> I have not seen any limitation so far in the OS either.

See Documentation/DMA-API-HOWTO.txt

All PCI devices start out with a 32-bit DMA mask, and Linux assumes it
can always fall back to a 32-bit mask if a smaller mask (needed for
some devices that only support DMA on a subset of the 4GB) or larger
mask (needed to address high memory but can fail when the PCI host
does not support it) cannot be set.

> Using IOMMU is fine but not required if the endpoint is a true 64 bit 
> supporting endpoint. This endpoint supports 64bit too.

There are two aspects here:

a) setting a 32-bit mask should not have failed. Any device that actually
   needs 32-bit DMA will make the same call and the platform must
   guarantee that this works. If you have a broken platform that can't
   do this, complain to your board vendor so they wire up the RAM
   properly, with at least the first 2GB visible to low PCI bus
   addresses.

b) If the platform has any memory above 4GB and the supports high DMA,
   it should never have asked for the 32-bit mask before trying the
   64-bit mask first. This is only a performance optimization, but the
   driver seems to do the right thing, so I assume there is something
   wrong with the platform code.

> >> Typically it's the other way round, on the grounds that 64bit DMA
> >> should be preferred over 32bit.
> >> Can you explain why it needs to be done the other way round here?
> >
> > Something else is odd here, the driver already checks for
> > dma_get_required_mask(), which will return the smallest mask
> > that fits all of RAM. If the machine has any memory above 4GB,
> > it already uses the 64-bit mask, and only falls back to
> > the 32-bit mask if that fails or if all memory fits within the
> > first 4GB.
> >
> 
> I'll add some prints in the code to get to the bottom of it. I think the 
> code is checking more than just the required mask and failing in one of 
> the other conditions. At least that DMA comparison code was more than 
> what I have ever seen.

Ok. That should take care of b) above, but we still have a bug with a)
that will come back to bite you if you don't address it right.

	Arnd
