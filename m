From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH] SCSI: amd_iommu dma_boundary overflow
Date: Wed, 20 Feb 2013 09:37:26 +0000
Message-ID: <1361353044.2581.16.camel@dabdike.int.hansenpartnership.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
	 <1361327453-1838-1-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0.parallels.com ([199.115.104.20]:44806 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714Ab3BTJhb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Feb 2013 04:37:31 -0500
In-Reply-To: <1361327453-1838-1-git-send-email-eddie.wai@broadcom.com>
Content-Language: en-US
Content-ID: <719EEEDA1975AB408C99A9439EF2837E@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Joerg Roedel <joro@8bytes.org>

This is a bit tricky, since AMD laid off the team who were maintaining
this, but I added to the cc' one of the original maintainers in the
hopes they can take a look.

James


On Tue, 2013-02-19 at 18:30 -0800, Eddie Wai wrote:
> Hello,
> 
> For a 64-bit DMA capable PCIe storage HBA running under the 64-bit
> AMD-VI IOMMU environment, the amd_iommu code was observed to hit an
> overflow when it tries to page align the dma_parms->segment_boundary_mask.
> This overflow would eventually trigger the BUG_ON in the iommu-helper's
> iommu_is_span_boundary is_power_of_2 check.
> 
> A little back tracking shows that since the device is 64-bit DMA capable,
> the pcidev->dma_mask was correctly set to DMA_BIT_MASK(64).  This dma_mask
> was then transferred to the SCSI host's dma_boundary param (by the iSCSI
> driver) and was eventually used to populate the q->limits.seg_boundary_mask
> (via blk_queue_segment_boundary) and the dma_parms->segment_boundary_mask
> (via dma_set_seg_boundary) during the scsi queue allocation.
> 
> The code seems correct as it make sense to impose the same hardware
> segment boundary limit on both the blk queue and the DMA code.  It would
> be an easy alternative to simply prevent the shost->dma_boundary from
> being set to DMA_BIT_MASK(64), but it seems more correct to fix the
> amd_iommu code itself to detect and handle this max 64-bit mask condition.
> 
> Please let me know your comments.
> 
> Thanks,
> Eddie
> 
> Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
> ---
>  drivers/iommu/amd_iommu.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> index d90a421..63185a1 100644
> --- a/drivers/iommu/amd_iommu.c
> +++ b/drivers/iommu/amd_iommu.c
> @@ -1526,11 +1526,14 @@ static unsigned long dma_ops_area_alloc(struct device *dev,
>  	unsigned long boundary_size;
>  	unsigned long address = -1;
>  	unsigned long limit;
> +	unsigned long mask;
>  
>  	next_bit >>= PAGE_SHIFT;
>  
> -	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
> -			PAGE_SIZE) >> PAGE_SHIFT;
> +	mask = dma_get_seg_boundary(dev);
> +	boundary_size = mask + 1 ?
> +			ALIGN(mask + 1, PAGE_SIZE) >> PAGE_SHIFT :
> +			1UL << (BITS_PER_LONG - PAGE_SHIFT);
>  
>  	for (;i < max_index; ++i) {
>  		unsigned long offset = dom->aperture[i]->offset >> PAGE_SHIFT;

