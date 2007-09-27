From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/5] add dma_max_segment_size option to scsi_host_template
Date: Thu, 27 Sep 2007 02:31:14 -0400
Message-ID: <46FB4E32.30405@garzik.org>
References: <46FA3061.9060408@garzik.org>	<20070925200037W.tomof@acm.org>	<46FA6FBE.2060100@garzik.org> <20070926023531I.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:51658 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493AbXI0Gbd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Sep 2007 02:31:33 -0400
In-Reply-To: <20070926023531I.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, hch@infradead.org, gregkh@suse.de, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote:
> You are right. scsi_debug's pseudo-bus works.
> 
> But probabaly, scsi_debug doesn't need to call
> blk_queue_max_segment_size now.

Either way works for me.  :)


>> Maybe dev_set_max_seg() is a better name, if people get really picky (I 
>> don't care).
> 
> How about dma_set_max_seg_size()?
> 
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index a417a6f..7adadfb 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1554,6 +1554,7 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
>  					 request_fn_proc *request_fn)
>  {
>  	struct request_queue *q;
> +	struct device *dev = shost->shost_gendev.parent;
>  
>  	q = blk_init_queue(request_fn, NULL);
>  	if (!q)
> @@ -1565,6 +1566,9 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
>  	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
>  	blk_queue_segment_boundary(q, shost->dma_boundary);
>  
> +	if (dev->max_segment_size)
> +		blk_queue_max_segment_size(q, dev->max_segment_size);
> +
>  	if (!shost->use_clustering)
>  		clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
>  	return q;
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 3a38d1f..8046b60 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -443,6 +443,13 @@ struct device {
>  
>  	struct dma_coherent_mem	*dma_mem; /* internal for coherent mem
>  					     override */
> +
> +	/*
> +	 * a low level driver may set these to teach IOMMU code about
> +	 * sg limitations.
> +	 */
> +	unsigned int max_segment_size;
> +
>  	/* arch specific additions */
>  	struct dev_archdata	archdata;
>  
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 2dc21cb..30404b8 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -31,6 +31,11 @@ static inline int valid_dma_direction(int dma_direction)
>  		(dma_direction == DMA_FROM_DEVICE));
>  }
>  
> +static inline void dma_set_max_seg_size(struct device *dev, unsigned int size)
> +{
> +	dev->max_segment_size = size;
> +}
> +

Definitely moving in the right direction, IMO.  I would suggest a few 
minor changes to dma_set_max_seg_size(), to permit platforms to override 
the default behavior, and to get people into the habit of checking the 
return value (since it might matter in the future):

1) surround with #ifndef ARCH_HAS_DMA_MAX_SEG

2) change return value to 'int'

3) unconditionally return zero, for now.

Otherwise, approach and code look good to me.

	Jeff


