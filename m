From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V5 3/3] scsi: Align queue to ARCH_DMA_MINALIGN in
 non-coherent DMA mode
Date: Sun, 17 Sep 2017 22:20:51 -0700
Message-ID: <20170918052051.GA29118@infradead.org>
References: <1505708574-5281-1-git-send-email-chenhc@lemote.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1505708574-5281-1-git-send-email-chenhc@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Huacai Chen <chenhc@lemote.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Please send all patches in the series to the same to and cc lists.

On Mon, Sep 18, 2017 at 12:22:54PM +0800, Huacai Chen wrote:
> In non-coherent DMA mode, kernel uses cache flushing operations to
> maintain I/O coherency, so scsi's block queue should be aligned to
> ARCH_DMA_MINALIGN. Otherwise, it will cause data corruption, at least
> on MIPS:
> 
>         Step 1, dma_map_single
>         Step 2, cache_invalidate (no writeback)
>         Step 3, dma_from_device
>         Step 4, dma_unmap_single
> 
> If a DMA buffer and a kernel structure share a same cache line, and if
> the kernel structure has dirty data, cache_invalidate (no writeback)
> will cause data lost.

And as said before we must _always_ align to dma_get_cache_alignment.
This is even documented in Documentation/DMA-API.txt:

------------------------------ snip ------------------------------

        int
        dma_get_cache_alignment(void)

Returns the processor cache alignment.  This is the absolute minimum
alignment *and* width that you must observe when either mapping
memory or doing partial flushes.

------------------------------ snip ------------------------------

> +	if (device_is_coherent(dev))
> +		blk_queue_dma_alignment(q, 0x04 - 1);
> +	else
> +		blk_queue_dma_alignment(q, dma_get_cache_alignment() - 1);

So as said before this should become something like:

	blk_queue_dma_alignment(q, max(0x04, dma_get_cache_alignment()) - 1);
