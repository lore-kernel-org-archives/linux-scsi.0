From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V6 1/3] dma-mapping: Introduce device_is_coherent() as
        ahelper
Date: Fri, 22 Sep 2017 15:49:16 +0200
Message-ID: <20170922134916.GA20335@lst.de>
References: <1505811161-25246-1-git-send-email-chenhc@lemote.com> <5e792b21-1d63-9200-b36a-c423385e2a2e@arm.com> <tencent_6FDFA013608B41F6241AD9D7@qq.com> <9213ab49-b6e6-d513-6d35-1fe2294aad68@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9213ab49-b6e6-d513-6d35-1fe2294aad68@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robin Murphy <robin.murphy@arm.com>
Cc: =?utf-8?B?6ZmI5Y2O5omN?= <chenhc@lemote.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel <linux-kernel@vger.kernel.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, stable <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 22, 2017 at 02:44:51PM +0100, Robin Murphy wrote:
> Not quite - I mean instead of adding an ops->device_is_coherent callback
> (which cannot really have a safe fallback value either way) and trying
> to enforce that dma_get_cache_alignment() should be the only valid
> caller, just add an ops->get_cache_alignment callback directly.

Exactly - and then fall back to ARCH_DMA_MINALIGN/1 if the ops vector
is not provided, to keep the existing behavior.
