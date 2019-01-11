From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ibmvscsi: use GFP_ATOMIC with dma_alloc_coherent in
 map_sg_data
Date: Fri, 11 Jan 2019 10:27:28 -0800
Message-ID: <20190111182728.GB5469@infradead.org>
References: <1547089136-20264-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <20190110150703.GA26696@infradead.org>
 <4c5a470e-fa98-1ffd-7f55-5a4ffb3a692a@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4c5a470e-fa98-1ffd-7f55-5a4ffb3a692a@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, james.bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 10, 2019 at 03:15:35PM -0800, Tyrel Datwyler wrote:
> On a secondary note I was unaware of the GFP_ATOMIC limitations. Should this be
> added to the documentation somewhere? I don't see any mention here form
> DMA-API-HOWTO.txt.

The DMA documentation unfortauntely doesn't seem very good.  It's been
on my todo list to eventually update it, but I'm still discoverying
various warts.

GFP_ATOMIC allocations generally work fine on DMA coherent
architectures, but tend to cause problems on a lot of non-coherent
ones with the notable exceptions of arm and arm64 that go to great
length to introduce special pools for them.  But that code is rarely
exercised, so I found various bugs e.g. in the arm64 iommu code for
this case.

But more importantly there really should be no need for the coherent
allocation from irq context - we only need coherent for descriptors
that don't have clear ownership, and aything allocated in the I/O path
generally has that.
