From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] scsi: Align queue to ARCH_DMA_MINALIGN in
 non-coherent DMA mode
Date: Mon, 11 Sep 2017 00:39:06 -0700
Message-ID: <20170911073906.GA7074@infradead.org>
References: <1504774131-11691-1-git-send-email-chenhc@lemote.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1504774131-11691-1-git-send-email-chenhc@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Huacai Chen <chenhc@lemote.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Fuxin Zhang <zhangfx@lemote.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> +	if (plat_device_is_coherent(dev))

We can't just call platform device code.  We'll need a proper
DMA API call for this.

> +		blk_queue_dma_alignment(q, 0x04 - 1);
> +	else
> +		blk_queue_dma_alignment(q, dma_get_cache_alignment() - 1);

Which we already have with dma_get_cache_alignment, except that it
doesn't take a struct device pointer and doesn't call into dma_map
ops.  So please add a struct device argument to dma_get_cache_alignment,
and let it call into dma_map_ops where needed.

With that you can replace the above with:

	blk_queue_dma_alignment(q,
			max(0x04U, dma_get_cache_alignment(dev)) - 1);
