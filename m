From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V9 1/4] dma-mapping: Rework dma_get_cache_alignment()
Date: Fri, 10 Nov 2017 13:30:59 +0100
Message-ID: <20171110123059.GA9296@lst.de>
References: <1508742767-28366-1-git-send-email-chenhc@lemote.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508742767-28366-1-git-send-email-chenhc@lemote.com>
Sender: stable-owner@vger.kernel.org
To: Huacai Chen <chenhc@lemote.com>
Cc: Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>, Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>, Michael Chan <michael.chan@broadcom.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ivan Mikhaylov <ivan@ru.ibm.com>, Tariq Toukan <tariqt@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

> diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
> index a1125d1..2f6ffe5 100644
> --- a/drivers/net/ethernet/broadcom/b44.c
> +++ b/drivers/net/ethernet/broadcom/b44.c
> @@ -2344,6 +2344,10 @@ static int b44_init_one(struct ssb_device *sdev,
>  	struct net_device *dev;
>  	struct b44 *bp;
>  	int err;
> +	unsigned int dma_desc_align_size = dma_get_cache_alignment(sdev->dma_dev);
> +
> +	/* Setup paramaters for syncing RX/TX DMA descriptors */
> +	dma_desc_sync_size = max_t(unsigned int, dma_desc_align_size, sizeof(struct dma_desc));
>  
>  	instance++;
>  
> @@ -2587,12 +2591,8 @@ static inline void b44_pci_exit(void)
>  
>  static int __init b44_init(void)
>  {
> -	unsigned int dma_desc_align_size = dma_get_cache_alignment();
>  	int err;
>  
> -	/* Setup paramaters for syncing RX/TX DMA descriptors */
> -	dma_desc_sync_size = max_t(unsigned int, dma_desc_align_size, sizeof(struct dma_desc));
> -

This looks wrong - you override a global variable for each probed
device.
