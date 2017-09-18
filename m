From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V5 3/3] scsi: Align queue to ARCH_DMA_MINALIGN
 innon-coherent DMA mode
Date: Mon, 18 Sep 2017 08:50:29 -0700
Message-ID: <20170918155029.GB16672@infradead.org>
References: <1505708574-5281-1-git-send-email-chenhc@lemote.com>
 <20170918052051.GA29118@infradead.org>
 <tencent_60D582B525876E48323D6E48@qq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <tencent_60D582B525876E48323D6E48@qq.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?6ZmI5Y2O5omN?= <chenhc@lemote.com>
Cc: Christoph Hellwig <hch@infradead.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 18, 2017 at 03:03:30PM +0800, 陈华才 wrote:
> I don't think dma_get_cache_alignment is the "absolute minimum alignment" in all cases. At least on MIPS/Loongson, if we use I/O coherent mode (Cached DMA mode), align block queue to 4Bytes is enough. If we align block queue  to dma_get_cache_alignment in I/O coherent mode, there are peformance lost because we cannot use zero-copy in most cases (user buffers are usually not aligned).

If you systems is I/O coherent it should report 1 ARCH_DMA_MINALIGN /
dma_get_cache_alignment().

Note that many drivers only support 512 byte aligned mappings for
block I/O and they've done pretty fine so far.
