From: tndave <tushar.n.dave@oracle.com>
Subject: Re: [PATCH] qlogicpti: Fix compiler warnings
Date: Wed, 23 Nov 2016 17:08:23 -0800
Message-ID: <f551b4db-610a-441d-e01d-1be258f7408e@oracle.com>
References: <1479936597-29061-1-git-send-email-tushar.n.dave@oracle.com>
 <1479941859.2417.28.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <1479941859.2417.28.camel@HansenPartnership.com>
Sender: sparclinux-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, thomas.tai@oracle.com, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 11/23/2016 02:57 PM, James Bottomley wrote:
> On Wed, 2016-11-23 at 13:29 -0800, Tushar Dave wrote:
>> qlogicpti uses '__u32' for dma handle while invoking kernel DMA APIs,
>> instead of using dma_addr_t. This hasn't caused any 'incompatible
>> pointer type' warning on SPARC because until now dma_addr_t is of
>> type u32. However, recent changes in SPARC ATU (iommu) enabled 64bit
>> DMA and therefore dma_addr_t became of type u64. This makes
>> 'incompatible pointer type' warnings inevitable.
>>
>> e.g.
>> drivers/scsi/qlogicpti.c: In function ‘qpti_map_queues’:
>> drivers/scsi/qlogicpti.c:813: warning: passing argument 3 of
>> ‘dma_alloc_coherent’ from incompatible pointer type
>> ./include/linux/dma-mapping.h:445: note: expected ‘dma_addr_t *’ but
>> argument is of type ‘__u32 *’
>> drivers/scsi/qlogicpti.c:822: warning: passing argument 3 of
>> ‘dma_alloc_coherent’ from incompatible pointer type
>> ./include/linux/dma-mapping.h:445: note: expected ‘dma_addr_t *’ but
>> argument is of type ‘__u32 *’
>>
>> This patch resolves above compiler warnings.
>
> There appears to be no point to the first three hunks of this diff:
>
> (ushort)(x << 16)
> (ushort)(x & 0xffff)
>
> return the same thing whether the type of x is u32 or u64, so there was
> no need to alter the original code.
Agree, will make the change.
>
> What's the guarantee, since the device descriptors only cope with 32
> bits of physical address, that this driver never gets any dma
> address beyond its addressable range?  Is it that the sbus can never
> be attached to this ATU type IOMMU?  If so, saying that in the log
> would be useful.
Thanks for catching this.
As per my understanding, I think, all DMA map/unmap go through
ATU (iommu) in sun4v sparc. To guarantee that driver doesn't get DMA
address beyond its addressable range , driver must set dma mask before
requesting any DMA mapping!

I will investigate further and send v2.

Thanks for the review.

-Tushar


>
> James
>
>
