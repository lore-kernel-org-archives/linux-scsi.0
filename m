From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Concerns about "mpt2sas: Added Reply Descriptor Post Queue
 (RDPQ) Array support"
Date: Thu, 19 Feb 2015 21:45:10 -0800
Message-ID: <1424411110.16222.5.camel@HansenPartnership.com>
References: <1424408500.27448.25.camel@kernel.crashing.org>
	 <1424408769.27448.28.camel@kernel.crashing.org>
	 <1424409761.27448.32.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424409761.27448.32.camel@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-02-20 at 16:22 +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2015-02-20 at 16:06 +1100, Benjamin Herrenschmidt wrote:
> 
> > Note that even on powerpc platforms where it would work because we
> > maintain both 32-bit and 64-bit bypass windows in the device address
> > space simultaneously, you will leak iommu entries unless you also switch
> > back to 32-bit when freeing the 32-bit mappings... (and you would
> > probably crash if you tried to free a 64-bit mapping while in 32-bit
> > mode).
> > 
> > The iommu APIs weren't designed with that "switching mask" facility in
> > mind...
> 
> Looking a bit more closely, you basically do
> 
>  - set_dma_mask(64-bit)
>  - set_consistent_dma_mask(32-bit)
> 
> Now, I don't know how x86 will react to the conflicting masks, but on
> ppc64, I'm pretty sure the second one will barf. IE, the first one will
> establish a set of direct mapping ops which give you a bypass of the
> iommu to all of memory. The second one will then do a
> dma_supported(mask) call which will hit the direct ops, and they will
> fail since a 32-bit mask cannot address the bypass completely.
> 
> Are architectures really required to support such mismatching dma_mask
> and consistent_dma_mask ? what a bloody trainwreck ... :-(

Ben, this is legal by design.  It was specifically designed for the
aic79xx SCSI card, but can be used for a variety of other reasons.  The
aic79xx hardware problem was that the DMA engine could address the whole
of memory (it had two address modes, a 39 bit one and a 64 bit one) but
the script engine that runs the mailboxes only had a 32 bit activation
register (the activating write points at the physical address of the
script to begin executing).  This meant that the scripts that run in
memory had to be in the first 4GB of physical memory, hence the split
mask.  The DMA mask specifies that the card can transfer from anywhere
in physical memory, but the consistent_dma_mask says that the consistent
allocation used to get scripts memory must come from the lower 4GB.

James
