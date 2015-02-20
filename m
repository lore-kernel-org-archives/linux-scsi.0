From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Concerns about "mpt2sas: Added Reply Descriptor Post Queue
 (RDPQ) Array support"
Date: Fri, 20 Feb 2015 18:19:21 +1100
Message-ID: <1424416761.27448.37.camel@kernel.crashing.org>
References: <1424408500.27448.25.camel@kernel.crashing.org>
	 <1424408769.27448.28.camel@kernel.crashing.org>
	 <1424409761.27448.32.camel@kernel.crashing.org>
	 <1424411110.16222.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424411110.16222.5.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-02-19 at 21:45 -0800, James Bottomley wrote:
> Ben, this is legal by design.  It was specifically designed for the
> aic79xx SCSI card, but can be used for a variety of other reasons.  The
> aic79xx hardware problem was that the DMA engine could address the whole
> of memory (it had two address modes, a 39 bit one and a 64 bit one) but
> the script engine that runs the mailboxes only had a 32 bit activation
> register (the activating write points at the physical address of the
> script to begin executing).  This meant that the scripts that run in
> memory had to be in the first 4GB of physical memory, hence the split
> mask.  The DMA mask specifies that the card can transfer from anywhere
> in physical memory, but the consistent_dma_mask says that the consistent
> allocation used to get scripts memory must come from the lower 4GB.

Right, ok, it looks like it's easy enough to support with ZONE_DMA32, I'm
testing patches to create it unconditionally on ppc64 (it used to depend
on us using swiotlb on embedded platforms) and I'll shoot that upstream
if it passes.

Ben.
