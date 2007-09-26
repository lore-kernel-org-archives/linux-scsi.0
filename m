From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 3/5] add sg segment limitation info to device structure
Date: Wed, 26 Sep 2007 09:05:58 -0700
Message-ID: <20070926160558.GA10819@suse.de>
References: <20070925142157B.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbXIZQND (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2007 12:13:03 -0400
Content-Disposition: inline
In-Reply-To: <20070925142157B.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Wed, Sep 26, 2007 at 05:58:01PM +0900, FUJITA Tomonori wrote:
> iommu code merges sg segments without considering lld's sg segment
> restrictions. iommu code can't access to the limitations because they
> are in request_queue. This patch adds max_segment_size to device
> structure. seg_boundary_mask will be added too later.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  include/linux/device.h |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
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

Does this really need to be here?  Can't it go into the bus specific
device that needs this?

thanks,

greg k-h
