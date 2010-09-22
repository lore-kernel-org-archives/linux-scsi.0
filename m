From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: [PATCH] block: set the bounce_pfn to the actual DMA limit
 rather than to max memory
Date: Wed, 22 Sep 2010 16:06:32 -0700
Message-ID: <20100922230632.GA7478@us.ibm.com>
References: <c9516154fabc03112353.1285107750@malahal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42460 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab0IVXGf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2010 19:06:35 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o8MMoSY0020681
	for <linux-scsi@vger.kernel.org>; Wed, 22 Sep 2010 18:50:28 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o8MN6YMU365264
	for <linux-scsi@vger.kernel.org>; Wed, 22 Sep 2010 19:06:34 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o8MN6XR8003805
	for <linux-scsi@vger.kernel.org>; Wed, 22 Sep 2010 19:06:34 -0400
Content-Disposition: inline
In-Reply-To: <c9516154fabc03112353.1285107750@malahal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaxboe@fusionio.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org

Jens, any comments on this patch?

Thanks, Malahal.

Malahal Naineni [malahal@us.ibm.com] wrote:
> The bounce_pfn of the request queue in 64 bit systems is set to the
> current max_low_pfn. Adding more memory later makes this incorrect.
> Memory allocated beyond this boot time max_low_pfn appear to require
> bounce buffers (bounce buffers are actually not allocated but used in
> calculating segments that may result in "over max segments limit"
> errors).
> 
> Signed-off-by: Malahal Naineni (malahal@us.ibm.com)
> 
> diff -r 09daf852c1c5 -r c9516154fabc block/blk-settings.c
> --- a/block/blk-settings.c	Thu Sep 09 12:10:43 2010 -0700
> +++ b/block/blk-settings.c	Mon Sep 13 10:15:24 2010 -0700
> @@ -214,16 +214,14 @@ void blk_queue_bounce_limit(struct reque
>  	 */
>  	if (b_pfn < (min_t(u64, 0xffffffffUL, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
>  		dma = 1;
> -	q->limits.bounce_pfn = max_low_pfn;
>  #else
>  	if (b_pfn < blk_max_low_pfn)
>  		dma = 1;
> +#endif
>  	q->limits.bounce_pfn = b_pfn;
> -#endif
>  	if (dma) {
>  		init_emergency_isa_pool();
>  		q->limits.bounce_gfp = GFP_NOIO | GFP_DMA;
> -		q->limits.bounce_pfn = b_pfn;
>  	}
>  }
>  EXPORT_SYMBOL(blk_queue_bounce_limit);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
