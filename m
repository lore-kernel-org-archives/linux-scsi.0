From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V7 1/2] dma-mapping: Rework dma_get_cache_alignment()
Date: Mon, 25 Sep 2017 14:51:07 +0200
Message-ID: <20170925125107.GC8130@lst.de>
References: <1506332766-23966-1-git-send-email-chenhc@lemote.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1506332766-23966-1-git-send-email-chenhc@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Huacai Chen <chenhc@lemote.com>
Cc: Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Roland Dreier <rolandd@cisco.com>, Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>, Michael Chan <michael.chan@broadcom.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ivan Mikhaylov <ivan@ru.ibm.com>, Tariq Toukan <tariqt@mellanox.com>, Andy Gross <agross@codeaurora.o>
List-Id: linux-scsi@vger.kernel.org

> index aba7138..e2c5d9e 100644
> --- a/arch/mips/include/asm/dma-mapping.h
> +++ b/arch/mips/include/asm/dma-mapping.h
> @@ -39,4 +39,6 @@ static inline void arch_setup_dma_ops(struct device *dev, u64 dma_base,
>  #endif
>  }
>  
> +int mips_get_cache_alignment(struct device *dev);

All the other mips generic dma helpers are prefixed mips_dma_*
so it might make sense to follow that.

Also please don't add arch-local helpers to asm/dma-mapping.h - this
is a header used by linux/dma-mapping.h and should not contain
implementation details if avoidable.

> +					   dma_get_cache_alignment(NULL)) / mdev->limits.mtt_seg_size;

As said before - please don't pass NULL to this function but the proper
device, which would be &mdev->pdev->dev in this case for example.
