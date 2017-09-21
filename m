From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH V6 1/3] dma-mapping: Introduce device_is_coherent() as a
 helper
Date: Thu, 21 Sep 2017 11:47:30 +0100
Message-ID: <5e792b21-1d63-9200-b36a-c423385e2a2e@arm.com>
References: <1505811161-25246-1-git-send-email-chenhc@lemote.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:44542 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751675AbdIUKre (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Sep 2017 06:47:34 -0400
In-Reply-To: <1505811161-25246-1-git-send-email-chenhc@lemote.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Huacai Chen <chenhc@lemote.com>, Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On 19/09/17 09:52, Huacai Chen wrote:
> We will use device_is_coherent() as a helper function, which will be
> used in the next patch.
> 
> There is a MIPS-specific plat_device_is_coherent(), but we need a more
> generic solution, so add and use a new function pointer in dma_map_ops.

I think we're heading in the right direction with the series, but I
still don't like this patch. I can pretty much guarantee that driver
authors *will* abuse a generic device_is_coherent() API to mean "I can
skip other DMA API calls and just use virt_to_phys()".

I think it would be far better to allow architectures to provide their
own override of dma_get_cache_alignment(), and let the coherency detail
remain internal to the relevant arch implementations.

[...]
> @@ -697,6 +698,15 @@ static inline void *dma_zalloc_coherent(struct device *dev, size_t size,
>  }
>  
>  #ifdef CONFIG_HAS_DMA
> +static inline int device_is_coherent(struct device *dev)
> +{
> +	const struct dma_map_ops *ops = get_dma_ops(dev);
> +	if (ops && ops->device_is_coherent)
> +		return ops->device_is_coherent(dev);
> +	else
> +		return 1;    /* compatible behavior */

That is also quite scary - if someone now adds a new
dma_get_cache_alignemnt() call and dutifully passes a non-NULL device,
they will now get back an alignment of 1 on all non-coherent platforms
except MIPS: hello data corruption.

Robin.

> +}
> +
>  static inline int dma_get_cache_alignment(void)
>  {
>  #ifdef ARCH_DMA_MINALIGN
> 
