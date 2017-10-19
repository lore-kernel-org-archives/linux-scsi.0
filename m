From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V8 4/5] libsas: Align SMP req/resp to
        dma_get_cache_alignment()
Date: Thu, 19 Oct 2017 17:12:14 +0200
Message-ID: <20171019151214.GD24204@lst.de>
References: <1508227542-13165-1-git-send-email-chenhc@lemote.com> <CGME20171017080448epcas5p2c7c53292d84838f6d06e78abf4416729@epcas5p2.samsung.com> <1508227542-13165-4-git-send-email-chenhc@lemote.com> <286bf838-4d2f-a25f-baf9-ef3ac9b37d93@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <286bf838-4d2f-a25f-baf9-ef3ac9b37d93@samsung.com>
Sender: linux-ide-owner@vger.kernel.org
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Huacai Chen <chenhc@lemote.com>, Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 17, 2017 at 01:55:43PM +0200, Marek Szyprowski wrote:
> If I remember correctly, kernel guarantees that each kmalloced buffer is
> always at least aligned to the CPU cache line, so CPU cache can be
> invalidated on the allocated buffer without corrupting anything else.

Yes, from slab.h:

/*
 * Some archs want to perform DMA into kmalloc caches and need a guaranteed
 * alignment larger than the alignment of a 64-bit integer.
 * Setting ARCH_KMALLOC_MINALIGN in arch headers allows that.
 */
#if defined(ARCH_DMA_MINALIGN) && ARCH_DMA_MINALIGN > 8
#define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN
#define KMALLOC_MIN_SIZE ARCH_DMA_MINALIGN
#define KMALLOC_SHIFT_LOW ilog2(ARCH_DMA_MINALIGN)
#else
#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
#endif

Mips sets this for a few subarchitectures, but it seems like you need
to set it for yours as well.
