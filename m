From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH V7 1/2] dma-mapping: Rework dma_get_cache_alignment()
Date: Mon, 25 Sep 2017 13:57:19 +0100
Message-ID: <82d60f2b-1c5a-9f64-7e94-0d84e7e2fc33@arm.com>
References: <1506332766-23966-1-git-send-email-chenhc@lemote.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1506332766-23966-1-git-send-email-chenhc@lemote.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Huacai Chen <chenhc@lemote.com>, Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Roland Dreier <rolandd@cisco.com>, Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>, Michael Chan <michael.chan@broadcom.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ivan Mikhaylov <ivan@ru.ibm.com>, Tariq Toukan <tariqt@mellanox.com>, Andy Gross <agross@codeaurora.org>, "Mark A . Greer" <mgreer@mvista.com>, Robert Baldyga <r.baldyga@>
List-Id: linux-scsi@vger.kernel.org

On 25/09/17 10:46, Huacai Chen wrote:
> Make dma_get_cache_alignment() to accept a 'dev' argument. As a result,
> it can return different alignments due to different devices' I/O cache
> coherency.
> 
> Currently, MIPS is the only architecture which support coherent & non-
> coherent devices co-exist. This may be changed in the future, so add a
> new get_cache_alignment() function pointer in 'struct dma_map_ops' as a
> generic solution.

FWIW, ARM and arm64 have also supported per-device coherency for quite
some time.

> For compatibility (always return ARCH_DMA_MINALIGN), make all existing
> callers pass a NULL dev argument to dma_get_cache_alignment().
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhc@lemote.co> ---
>  arch/mips/cavium-octeon/dma-octeon.c           |  3 ++-
>  arch/mips/include/asm/dma-mapping.h            |  2 ++
>  arch/mips/loongson64/common/dma-swiotlb.c      |  1 +
>  arch/mips/mm/dma-default.c                     | 11 ++++++++++-
>  arch/mips/netlogic/common/nlm-dma.c            |  3 ++-
>  drivers/infiniband/hw/mthca/mthca_main.c       |  2 +-
>  drivers/media/v4l2-core/videobuf2-dma-contig.c |  2 +-
>  drivers/net/ethernet/broadcom/b44.c            |  2 +-
>  drivers/net/ethernet/ibm/emac/core.h           |  2 +-
>  drivers/net/ethernet/mellanox/mlx4/main.c      |  2 +-
>  drivers/spi/spi-qup.c                          |  4 ++--
>  drivers/tty/serial/mpsc.c                      | 16 ++++++++--------
>  drivers/tty/serial/samsung.c                   | 14 +++++++-------
>  include/linux/dma-mapping.h                    | 17 ++++++++++++-----
>  14 files changed, 51 insertions(+), 30 deletions(-)

I think it might be neater to split this into two patches - one making
the treewide prototype change, then introducing the .get_cache_alignemnt
callback separately - but that's only my personal preference.

Otherwise (and modulo Christoph's comments), I'd say we're nearly there.

Thanks,
Robin.

> diff --git a/arch/mips/cavium-octeon/dma-octeon.c b/arch/mips/cavium-octeon/dma-octeon.c
> index c64bd87..7978237 100644
> --- a/arch/mips/cavium-octeon/dma-octeon.c
> +++ b/arch/mips/cavium-octeon/dma-octeon.c
> @@ -324,7 +324,8 @@ static struct octeon_dma_map_ops _octeon_pci_dma_map_ops = {
>  		.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
>  		.sync_sg_for_device = octeon_dma_sync_sg_for_device,
>  		.mapping_error = swiotlb_dma_mapping_error,
> -		.dma_supported = swiotlb_dma_supported
> +		.dma_supported = swiotlb_dma_supported,
> +		.get_cache_alignment = mips_get_cache_alignment
>  	},
>  };
>  
> diff --git a/arch/mips/include/asm/dma-mapping.h b/arch/mips/include/asm/dma-mapping.h
> index aba7138..e2c5d9e 100644
> --- a/arch/mips/include/asm/dma-mapping.h
> +++ b/arch/mips/include/asm/dma-mapping.h
> @@ -39,4 +39,6 @@ static inline void arch_setup_dma_ops(struct device *dev, u64 dma_base,
>  #endif
>  }
>  
> +int mips_get_cache_alignment(struct device *dev);
> +
>  #endif /* _ASM_DMA_MAPPING_H */
> diff --git a/arch/mips/loongson64/common/dma-swiotlb.c b/arch/mips/loongson64/common/dma-swiotlb.c
> index 34486c1..09cb8a4 100644
> --- a/arch/mips/loongson64/common/dma-swiotlb.c
> +++ b/arch/mips/loongson64/common/dma-swiotlb.c
> @@ -119,6 +119,7 @@ static const struct dma_map_ops loongson_dma_map_ops = {
>  	.sync_sg_for_device = loongson_dma_sync_sg_for_device,
>  	.mapping_error = swiotlb_dma_mapping_error,
>  	.dma_supported = loongson_dma_supported,
> +	.get_cache_alignment = mips_get_cache_alignment
>  };
>  
>  void __init plat_swiotlb_setup(void)
> diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
> index c01bd20..c49987e 100644
> --- a/arch/mips/mm/dma-default.c
> +++ b/arch/mips/mm/dma-default.c
> @@ -394,6 +394,14 @@ void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
>  
>  EXPORT_SYMBOL(dma_cache_sync);
>  
> +int mips_get_cache_alignment(struct device *dev)
> +{
> +	if (plat_device_is_coherent(dev))
> +		return 1;
> +	else
> +		return ARCH_DMA_MINALIGN;
> +}
> +
>  static const struct dma_map_ops mips_default_dma_map_ops = {
>  	.alloc = mips_dma_alloc_coherent,
>  	.free = mips_dma_free_coherent,
> @@ -407,7 +415,8 @@ static const struct dma_map_ops mips_default_dma_map_ops = {
>  	.sync_sg_for_cpu = mips_dma_sync_sg_for_cpu,
>  	.sync_sg_for_device = mips_dma_sync_sg_for_device,
>  	.mapping_error = mips_dma_mapping_error,
> -	.dma_supported = mips_dma_supported
> +	.dma_supported = mips_dma_supported,
> +	.get_cache_alignment = mips_get_cache_alignment
>  };
>  
>  const struct dma_map_ops *mips_dma_map_ops = &mips_default_dma_map_ops;
> diff --git a/arch/mips/netlogic/common/nlm-dma.c b/arch/mips/netlogic/common/nlm-dma.c
> index 0ec9d9d..1e107ac 100644
> --- a/arch/mips/netlogic/common/nlm-dma.c
> +++ b/arch/mips/netlogic/common/nlm-dma.c
> @@ -79,7 +79,8 @@ const struct dma_map_ops nlm_swiotlb_dma_ops = {
>  	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
>  	.sync_sg_for_device = swiotlb_sync_sg_for_device,
>  	.mapping_error = swiotlb_dma_mapping_error,
> -	.dma_supported = swiotlb_dma_supported
> +	.dma_supported = swiotlb_dma_supported,
> +	.get_cache_alignment = mips_get_cache_alignment
>  };
>  
>  void __init plat_swiotlb_setup(void)
> diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
> index e36a9bc..cac5fac 100644
> --- a/drivers/infiniband/hw/mthca/mthca_main.c
> +++ b/drivers/infiniband/hw/mthca/mthca_main.c
> @@ -416,7 +416,7 @@ static int mthca_init_icm(struct mthca_dev *mdev,
>  
>  	/* CPU writes to non-reserved MTTs, while HCA might DMA to reserved mtts */
>  	mdev->limits.reserved_mtts = ALIGN(mdev->limits.reserved_mtts * mdev->limits.mtt_seg_size,
> -					   dma_get_cache_alignment()) / mdev->limits.mtt_seg_size;
> +					   dma_get_cache_alignment(NULL)) / mdev->limits.mtt_seg_size;
>  
>  	mdev->mr_table.mtt_table = mthca_alloc_icm_table(mdev, init_hca->mtt_base,
>  							 mdev->limits.mtt_seg_size,
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index 9f389f3..7f54739 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -484,7 +484,7 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
>  	int ret = 0;
>  	struct sg_table *sgt;
>  	unsigned long contig_size;
> -	unsigned long dma_align = dma_get_cache_alignment();
> +	unsigned long dma_align = dma_get_cache_alignment(NULL);
>  
>  	/* Only cache aligned DMA transfers are reliable */
>  	if (!IS_ALIGNED(vaddr | size, dma_align)) {
> diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
> index a1125d1..291d6af 100644
> --- a/drivers/net/ethernet/broadcom/b44.c
> +++ b/drivers/net/ethernet/broadcom/b44.c
> @@ -2587,7 +2587,7 @@ static inline void b44_pci_exit(void)
>  
>  static int __init b44_init(void)
>  {
> -	unsigned int dma_desc_align_size = dma_get_cache_alignment();
> +	unsigned int dma_desc_align_size = dma_get_cache_alignment(NULL);
>  	int err;
>  
>  	/* Setup paramaters for syncing RX/TX DMA descriptors */
> diff --git a/drivers/net/ethernet/ibm/emac/core.h b/drivers/net/ethernet/ibm/emac/core.h
> index 369de2c..236bf37 100644
> --- a/drivers/net/ethernet/ibm/emac/core.h
> +++ b/drivers/net/ethernet/ibm/emac/core.h
> @@ -68,7 +68,7 @@ static inline int emac_rx_size(int mtu)
>  		return mal_rx_size(ETH_DATA_LEN + EMAC_MTU_OVERHEAD);
>  }
>  
> -#define EMAC_DMA_ALIGN(x)		ALIGN((x), dma_get_cache_alignment())
> +#define EMAC_DMA_ALIGN(x)		ALIGN((x), dma_get_cache_alignment(NULL))
>  
>  #define EMAC_RX_SKB_HEADROOM		\
>  	EMAC_DMA_ALIGN(CONFIG_IBM_EMAC_RX_SKB_HEADROOM)
> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> index e61c99e..56b1449 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> @@ -1660,7 +1660,7 @@ static int mlx4_init_icm(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap,
>  	 */
>  	dev->caps.reserved_mtts =
>  		ALIGN(dev->caps.reserved_mtts * dev->caps.mtt_entry_sz,
> -		      dma_get_cache_alignment()) / dev->caps.mtt_entry_sz;
> +		      dma_get_cache_alignment(NULL)) / dev->caps.mtt_entry_sz;
>  
>  	err = mlx4_init_icm_table(dev, &priv->mr_table.mtt_table,
>  				  init_hca->mtt_base,
> diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
> index 974a8ce..0c698c3 100644
> --- a/drivers/spi/spi-qup.c
> +++ b/drivers/spi/spi-qup.c
> @@ -862,7 +862,7 @@ static bool spi_qup_can_dma(struct spi_master *master, struct spi_device *spi,
>  			    struct spi_transfer *xfer)
>  {
>  	struct spi_qup *qup = spi_master_get_devdata(master);
> -	size_t dma_align = dma_get_cache_alignment();
> +	size_t dma_align = dma_get_cache_alignment(NULL);
>  	int n_words;
>  
>  	if (xfer->rx_buf) {
> @@ -1038,7 +1038,7 @@ static int spi_qup_probe(struct platform_device *pdev)
>  	master->transfer_one = spi_qup_transfer_one;
>  	master->dev.of_node = pdev->dev.of_node;
>  	master->auto_runtime_pm = true;
> -	master->dma_alignment = dma_get_cache_alignment();
> +	master->dma_alignment = dma_get_cache_alignment(NULL);
>  	master->max_dma_len = SPI_MAX_XFER;
>  
>  	platform_set_drvdata(pdev, master);
> diff --git a/drivers/tty/serial/mpsc.c b/drivers/tty/serial/mpsc.c
> index 67ffecc..e2f792a 100644
> --- a/drivers/tty/serial/mpsc.c
> +++ b/drivers/tty/serial/mpsc.c
> @@ -81,19 +81,19 @@
>   * Number of Tx & Rx descriptors must be powers of 2.
>   */
>  #define	MPSC_RXR_ENTRIES	32
> -#define	MPSC_RXRE_SIZE		dma_get_cache_alignment()
> +#define	MPSC_RXRE_SIZE		dma_get_cache_alignment(NULL)
>  #define	MPSC_RXR_SIZE		(MPSC_RXR_ENTRIES * MPSC_RXRE_SIZE)
> -#define	MPSC_RXBE_SIZE		dma_get_cache_alignment()
> +#define	MPSC_RXBE_SIZE		dma_get_cache_alignment(NULL)
>  #define	MPSC_RXB_SIZE		(MPSC_RXR_ENTRIES * MPSC_RXBE_SIZE)
>  
>  #define	MPSC_TXR_ENTRIES	32
> -#define	MPSC_TXRE_SIZE		dma_get_cache_alignment()
> +#define	MPSC_TXRE_SIZE		dma_get_cache_alignment(NULL)
>  #define	MPSC_TXR_SIZE		(MPSC_TXR_ENTRIES * MPSC_TXRE_SIZE)
> -#define	MPSC_TXBE_SIZE		dma_get_cache_alignment()
> +#define	MPSC_TXBE_SIZE		dma_get_cache_alignment(NULL)
>  #define	MPSC_TXB_SIZE		(MPSC_TXR_ENTRIES * MPSC_TXBE_SIZE)
>  
>  #define	MPSC_DMA_ALLOC_SIZE	(MPSC_RXR_SIZE + MPSC_RXB_SIZE + MPSC_TXR_SIZE \
> -		+ MPSC_TXB_SIZE + dma_get_cache_alignment() /* for alignment */)
> +		+ MPSC_TXB_SIZE + dma_get_cache_alignment(NULL) /* for alignment */)
>  
>  /* Rx and Tx Ring entry descriptors -- assume entry size is <= cacheline size */
>  struct mpsc_rx_desc {
> @@ -738,7 +738,7 @@ static void mpsc_init_hw(struct mpsc_port_info *pi)
>  
>  	mpsc_brg_init(pi, pi->brg_clk_src);
>  	mpsc_brg_enable(pi);
> -	mpsc_sdma_init(pi, dma_get_cache_alignment());	/* burst a cacheline */
> +	mpsc_sdma_init(pi, dma_get_cache_alignment(NULL));	/* burst a cacheline */
>  	mpsc_sdma_stop(pi);
>  	mpsc_hw_init(pi);
>  }
> @@ -798,8 +798,8 @@ static void mpsc_init_rings(struct mpsc_port_info *pi)
>  	 * Descriptors & buffers are multiples of cacheline size and must be
>  	 * cacheline aligned.
>  	 */
> -	dp = ALIGN((u32)pi->dma_region, dma_get_cache_alignment());
> -	dp_p = ALIGN((u32)pi->dma_region_p, dma_get_cache_alignment());
> +	dp = ALIGN((u32)pi->dma_region, dma_get_cache_alignment(NULL));
> +	dp_p = ALIGN((u32)pi->dma_region_p, dma_get_cache_alignment(NULL));
>  
>  	/*
>  	 * Partition dma region into rx ring descriptor, rx buffers,
> diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
> index 8aca18c..b40a681 100644
> --- a/drivers/tty/serial/samsung.c
> +++ b/drivers/tty/serial/samsung.c
> @@ -241,7 +241,7 @@ static void enable_tx_dma(struct s3c24xx_uart_port *ourport)
>  	/* Enable tx dma mode */
>  	ucon = rd_regl(port, S3C2410_UCON);
>  	ucon &= ~(S3C64XX_UCON_TXBURST_MASK | S3C64XX_UCON_TXMODE_MASK);
> -	ucon |= (dma_get_cache_alignment() >= 16) ?
> +	ucon |= (dma_get_cache_alignment(NULL) >= 16) ?
>  		S3C64XX_UCON_TXBURST_16 : S3C64XX_UCON_TXBURST_1;
>  	ucon |= S3C64XX_UCON_TXMODE_DMA;
>  	wr_regl(port,  S3C2410_UCON, ucon);
> @@ -292,7 +292,7 @@ static int s3c24xx_serial_start_tx_dma(struct s3c24xx_uart_port *ourport,
>  	if (ourport->tx_mode != S3C24XX_TX_DMA)
>  		enable_tx_dma(ourport);
>  
> -	dma->tx_size = count & ~(dma_get_cache_alignment() - 1);
> +	dma->tx_size = count & ~(dma_get_cache_alignment(NULL) - 1);
>  	dma->tx_transfer_addr = dma->tx_addr + xmit->tail;
>  
>  	dma_sync_single_for_device(ourport->port.dev, dma->tx_transfer_addr,
> @@ -332,7 +332,7 @@ static void s3c24xx_serial_start_next_tx(struct s3c24xx_uart_port *ourport)
>  
>  	if (!ourport->dma || !ourport->dma->tx_chan ||
>  	    count < ourport->min_dma_size ||
> -	    xmit->tail & (dma_get_cache_alignment() - 1))
> +	    xmit->tail & (dma_get_cache_alignment(NULL) - 1))
>  		s3c24xx_serial_start_tx_pio(ourport);
>  	else
>  		s3c24xx_serial_start_tx_dma(ourport, count);
> @@ -718,8 +718,8 @@ static irqreturn_t s3c24xx_serial_tx_chars(int irq, void *id)
>  
>  	if (ourport->dma && ourport->dma->tx_chan &&
>  	    count >= ourport->min_dma_size) {
> -		int align = dma_get_cache_alignment() -
> -			(xmit->tail & (dma_get_cache_alignment() - 1));
> +		int align = dma_get_cache_alignment(NULL) -
> +			(xmit->tail & (dma_get_cache_alignment(NULL) - 1));
>  		if (count-align >= ourport->min_dma_size) {
>  			dma_count = count-align;
>  			count = align;
> @@ -870,7 +870,7 @@ static int s3c24xx_serial_request_dma(struct s3c24xx_uart_port *p)
>  	dma->tx_conf.direction		= DMA_MEM_TO_DEV;
>  	dma->tx_conf.dst_addr_width	= DMA_SLAVE_BUSWIDTH_1_BYTE;
>  	dma->tx_conf.dst_addr		= p->port.mapbase + S3C2410_UTXH;
> -	if (dma_get_cache_alignment() >= 16)
> +	if (dma_get_cache_alignment(NULL) >= 16)
>  		dma->tx_conf.dst_maxburst = 16;
>  	else
>  		dma->tx_conf.dst_maxburst = 1;
> @@ -1849,7 +1849,7 @@ static int s3c24xx_serial_probe(struct platform_device *pdev)
>  	 * so find minimal transfer size suitable for DMA mode
>  	 */
>  	ourport->min_dma_size = max_t(int, ourport->port.fifosize,
> -				    dma_get_cache_alignment());
> +				    dma_get_cache_alignment(NULL));
>  
>  	dbg("%s: initialising port %p...\n", __func__, ourport);
>  
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 29ce981..1326023 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -131,6 +131,7 @@ struct dma_map_ops {
>  #ifdef ARCH_HAS_DMA_GET_REQUIRED_MASK
>  	u64 (*get_required_mask)(struct device *dev);
>  #endif
> +	int (*get_cache_alignment)(struct device *dev);
>  	int is_phys;
>  };
>  
> @@ -697,12 +698,18 @@ static inline void *dma_zalloc_coherent(struct device *dev, size_t size,
>  }
>  
>  #ifdef CONFIG_HAS_DMA
> -static inline int dma_get_cache_alignment(void)
> -{
> -#ifdef ARCH_DMA_MINALIGN
> -	return ARCH_DMA_MINALIGN;
> +
> +#ifndef ARCH_DMA_MINALIGN
> +#define ARCH_DMA_MINALIGN 1
>  #endif
> -	return 1;
> +
> +static inline int dma_get_cache_alignment(struct device *dev)
> +{
> +	const struct dma_map_ops *ops = get_dma_ops(dev);
> +	if (dev && ops && ops->get_cache_alignment)
> +		return ops->get_cache_alignment(dev);
> +
> +	return ARCH_DMA_MINALIGN; /* compatible behavior */
>  }
>  #endif
>  
> 
