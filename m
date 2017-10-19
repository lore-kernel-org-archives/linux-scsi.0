From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V8 3/5] scsi: Align block queue to
        dma_get_cache_alignment()
Date: Thu, 19 Oct 2017 17:10:08 +0200
Message-ID: <20171019151008.GC24204@lst.de>
References: <1508227542-13165-1-git-send-email-chenhc@lemote.com> <1508227542-13165-3-git-send-email-chenhc@lemote.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508227542-13165-3-git-send-email-chenhc@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Huacai Chen <chenhc@lemote.com>
Cc: Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 17, 2017 at 04:05:40PM +0800, Huacai Chen wrote:
> In non-coherent DMA mode, kernel uses cache flushing operations to
> maintain I/O coherency, so scsi's block queue should be aligned to
> ARCH_DMA_MINALIGN. Otherwise, If a DMA buffer and a kernel structure
> share a same cache line, and if the kernel structure has dirty data,
> cache_invalidate (no writeback) will cause data corruption.

Looks fine to, and I like cleaning up the arcane 0x03 as wel.
