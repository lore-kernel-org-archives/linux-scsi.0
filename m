From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Concerns about "mpt2sas: Added Reply Descriptor Post Queue
 (RDPQ) Array support"
Date: Fri, 20 Feb 2015 18:16:42 +1100
Message-ID: <1424416602.27448.36.camel@kernel.crashing.org>
References: <1424408500.27448.25.camel@kernel.crashing.org>
	 <1424408769.27448.28.camel@kernel.crashing.org>
	 <1424409761.27448.32.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424409761.27448.32.camel@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-02-20 at 16:22 +1100, Benjamin Herrenschmidt wrote:

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

Oh well, looks like x86 supports it and it won't be too hard to support
it on ppc64 as well. We even had some code along those lines for FSL
platforms with an ifdef due to the amount of drivers that used to fail
setting the consistent mask properly but that seems to be mostly fixed
nowadays.

Ben.
