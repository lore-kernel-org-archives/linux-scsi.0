From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ibmvscsi: use GFP_ATOMIC with dma_alloc_coherent in
 map_sg_data
Date: Thu, 10 Jan 2019 07:07:03 -0800
Message-ID: <20190110150703.GA26696@infradead.org>
References: <1547089136-20264-1-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1547089136-20264-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 09, 2019 at 06:58:56PM -0800, Tyrel Datwyler wrote:
> While mapping DMA for scatter list when a scsi command is queued the
> existing call to dma_alloc_coherent() in our map_sg_data() function
> passes zero for the gfp_flags parameter. We are most definitly in atomic
> context at this point as queue_command() is called in softirq context
> and further we have a spinlock holding the scsi host lock.
> 
> Fix this by passing GFP_ATOMIC to dma_alloc_coherent() to prevent any
> sort of sleeping in atomic context deadlock.

This is a pretty clear sign you should not be using dma_alloc_coherent
to start with.  GFP_ATOMIC support in many of the implementations either
doesn't work at all or is severly constrained.  Given that the
descriptor is written by the OS and read by the hardware exactly once
there is no point in having the coherent mapping to start with.
