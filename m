From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Concerns about "mpt2sas: Added Reply Descriptor Post Queue
 (RDPQ) Array support"
Date: Fri, 20 Feb 2015 16:06:09 +1100
Message-ID: <1424408769.27448.28.camel@kernel.crashing.org>
References: <1424408500.27448.25.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424408500.27448.25.camel@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-02-20 at 16:01 +1100, Benjamin Herrenschmidt wrote:
> Hi Sreekanth !
> 
> While looking at some (unrelated) issue where mtp2sas seems to be using
> 32-bit DMA instead of 64-bit DMA on some POWER platforms, I noticed this
> patch which was merged as 5fb1bf8aaa832e1e9ca3198de7bbecb8eff7db9c.
> 
> Can you confirm my understanding that you are:
> 
>  - Setting the DMA mask to 32-bit
> 
>  - Mapping pages for DMA
> 
>  - Changing the DMA mask to 64-bit
> 
> ?
> 
> If yes, then I don't think this is a legal thing to do and definitely
> not something supported by all architectures. It might work by accident,
> but there is no telling that any translation/DMA mapping provided before
> a call to set_dma_mask() is still valid after that call.
> 
> The architecture might have to completely reconfigure the iommu, for
> example on some PowerPC platforms, we switch from a remapped mapping to
> a direct linear map of all memory, all translations established before
> the switch might be lost (it depends on the specific implementation).
> 
> How does it work on x86 with DMAR ?

Note that even on powerpc platforms where it would work because we
maintain both 32-bit and 64-bit bypass windows in the device address
space simultaneously, you will leak iommu entries unless you also switch
back to 32-bit when freeing the 32-bit mappings... (and you would
probably crash if you tried to free a 64-bit mapping while in 32-bit
mode).

The iommu APIs weren't designed with that "switching mask" facility in
mind...

Ben.
