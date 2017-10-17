From: Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V8 1/5] dma-mapping: Rework dma_get_cache_alignment()
Date: Tue, 17 Oct 2017 16:05:38 +0800
Message-ID: <1508227542-13165-1-git-send-email-chenhc@lemote.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpbgsg2.qq.com ([54.254.200.128]:54887 "EHLO smtpbgsg2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757504AbdJQIEf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Oct 2017 04:04:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org, "Michael S . Tsirkin" <mst@mellanox.co.il>, Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>, Michael Chan <michael.chan@broadcom.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ivan Mikhaylov <ivan@>

Make dma_get_cache_alignment() to accept a 'dev' argument. As a result,
it can return different alignments due to different devices' I/O cache
coherency.

Currently, ARM/ARM64 and MIPS support coherent & noncoherent devices
co-exist. This may be extended in the future, so add a new function
pointer (i.e, get_cache_alignment) in 'struct dma_map_ops' as a generic
solution.

Cc: stable@vger.kernel.org
Cc: Michael S. Tsirkin <mst@mellanox.co.il>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Michael Chan <michael.chan@broadcom.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ivan Mikhaylov <ivan@ru.ibm.com>
Cc: Tariq Toukan <tariqt@mellanox.com>
Cc: Andy Gross <agross@codeaurora.org>
Cc: Mark A. Greer <mgreer@animalcreek.com>
Cc: Robert Baldyga <r.baldyga@hackerion.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 drivers/infiniband/hw/mthca/mthca_main.c       |  2 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c |  2 +-
 drivers/net/ethernet/broadcom/b44.c            |  8 +++----
 drivers/net/ethernet/ibm/emac/core.c           | 22 ++++++++++-------
 drivers/net/ethernet/ibm/emac/core.h           |  6 ++---
 drivers/net/ethernet/mellanox/mlx4/main.c      |  2 +-
 drivers/spi/spi-qup.c                          |  4 ++--
 drivers/tty/serial/mpsc.c                      | 33 ++++++++++++++++++--------
 drivers/tty/serial/samsung.c                   | 14 +++++------
 include/linux/dma-mapping.h                    | 17 +++++++++----
 10 files changed, 68 insertions(+), 42 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index e36a9bc..078fe8d 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -416,7 +416,7 @@ static int mthca_init_icm(struct mthca_dev *mdev,
 
 	/* CPU writes to non-reserved MTTs, while HCA might DMA to reserved mtts */
 	mdev->limits.reserved_mtts = ALIGN(mdev->limits.reserved_mtts * mdev->limits.mtt_seg_size,
-					   dma_get_cache_alignment()) / mdev->limits.mtt_seg_size;
+					   dma_get_cache_alignment(&mdev->pdev->dev)) / mdev->limits.mtt_seg_size;
 
 	mdev->mr_table.mtt_table = mthca_alloc_icm_table(mdev, init_hca->mtt_base,
 							 mdev->limits.mtt_seg_size,
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 9f389f3..1f6a9b7 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -484,7 +484,7 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
 	int ret = 0;
 	struct sg_table *sgt;
 	unsigned long contig_size;
-	unsigned long dma_align = dma_get_cache_alignment();
+	unsigned long dma_align = dma_get_cache_alignment(dev);
 
 	/* Only cache aligned DMA transfers are reliable */
 	if (!IS_ALIGNED(vaddr | size, dma_align)) {
diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index a1125d1..2f6ffe5 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -2344,6 +2344,10 @@ static int b44_init_one(struct ssb_device *sdev,
 	struct net_device *dev;
 	struct b44 *bp;
 	int err;
+	unsigned int dma_desc_align_size = dma_get_cache_alignment(sdev->dma_dev);
+
+	/* Setup paramaters for syncing RX/TX DMA descriptors */
+	dma_desc_sync_size = max_t(unsigned int, dma_desc_align_size, sizeof(struct dma_desc));
 
 	instance++;
 
@@ -2587,12 +2591,8 @@ static inline void b44_pci_exit(void)
 
 static int __init b44_init(void)
 {
-	unsigned int dma_desc_align_size = dma_get_cache_alignment();
 	int err;
 
-	/* Setup paramaters for syncing RX/TX DMA descriptors */
-	dma_desc_sync_size = max_t(unsigned int, dma_desc_align_size, sizeof(struct dma_desc));
-
 	err = b44_pci_init();
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 7feff24..b0c5319 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -1030,8 +1030,9 @@ static int emac_set_mac_address(struct net_device *ndev, void *sa)
 
 static int emac_resize_rx_ring(struct emac_instance *dev, int new_mtu)
 {
-	int rx_sync_size = emac_rx_sync_size(new_mtu);
-	int rx_skb_size = emac_rx_skb_size(new_mtu);
+	struct device *dma_dev = &dev->ofdev->dev;
+	int rx_skb_size = emac_rx_skb_size(dma_dev, new_mtu);
+	int rx_sync_size = emac_rx_sync_size(dma_dev, new_mtu);
 	int i, ret = 0;
 	int mr1_jumbo_bit_change = 0;
 
@@ -1115,20 +1116,21 @@ static int emac_resize_rx_ring(struct emac_instance *dev, int new_mtu)
 static int emac_change_mtu(struct net_device *ndev, int new_mtu)
 {
 	struct emac_instance *dev = netdev_priv(ndev);
+	struct device *dma_dev = &dev->ofdev->dev;
 	int ret = 0;
 
 	DBG(dev, "change_mtu(%d)" NL, new_mtu);
 
 	if (netif_running(ndev)) {
 		/* Check if we really need to reinitialize RX ring */
-		if (emac_rx_skb_size(ndev->mtu) != emac_rx_skb_size(new_mtu))
+		if (emac_rx_skb_size(dma_dev, ndev->mtu) != emac_rx_skb_size(dma_dev, new_mtu))
 			ret = emac_resize_rx_ring(dev, new_mtu);
 	}
 
 	if (!ret) {
 		ndev->mtu = new_mtu;
-		dev->rx_skb_size = emac_rx_skb_size(new_mtu);
-		dev->rx_sync_size = emac_rx_sync_size(new_mtu);
+		dev->rx_skb_size = emac_rx_skb_size(dma_dev, new_mtu);
+		dev->rx_sync_size = emac_rx_sync_size(dma_dev, new_mtu);
 	}
 
 	return ret;
@@ -1171,6 +1173,7 @@ static void emac_clean_rx_ring(struct emac_instance *dev)
 static inline int emac_alloc_rx_skb(struct emac_instance *dev, int slot,
 				    gfp_t flags)
 {
+	struct device *dma_dev = &dev->ofdev->dev;
 	struct sk_buff *skb = alloc_skb(dev->rx_skb_size, flags);
 	if (unlikely(!skb))
 		return -ENOMEM;
@@ -1649,11 +1652,12 @@ static inline void emac_recycle_rx_skb(struct emac_instance *dev, int slot,
 				       int len)
 {
 	struct sk_buff *skb = dev->rx_skb[slot];
+	struct device *dma_dev = &dev->ofdev->dev;
 
 	DBG2(dev, "recycle %d %d" NL, slot, len);
 
 	if (len)
-		dma_map_single(&dev->ofdev->dev, skb->data - 2,
+		dma_map_single(dma_dev, skb->data - 2,
 			       EMAC_DMA_ALIGN(len + 2), DMA_FROM_DEVICE);
 
 	dev->rx_desc[slot].data_len = 0;
@@ -1727,6 +1731,7 @@ static int emac_poll_rx(void *param, int budget)
 {
 	struct emac_instance *dev = param;
 	int slot = dev->rx_slot, received = 0;
+	struct device *dma_dev = &dev->ofdev->dev;
 
 	DBG2(dev, "poll_rx(%d)" NL, budget);
 
@@ -2998,6 +3003,7 @@ static int emac_probe(struct platform_device *ofdev)
 	struct emac_instance *dev;
 	struct device_node *np = ofdev->dev.of_node;
 	struct device_node **blist = NULL;
+	struct device *dma_dev = &ofdev->dev;
 	int err, i;
 
 	/* Skip unused/unwired EMACS.  We leave the check for an unused
@@ -3077,8 +3083,8 @@ static int emac_probe(struct platform_device *ofdev)
 		       np, dev->mal_dev->dev.of_node);
 		goto err_rel_deps;
 	}
-	dev->rx_skb_size = emac_rx_skb_size(ndev->mtu);
-	dev->rx_sync_size = emac_rx_sync_size(ndev->mtu);
+	dev->rx_skb_size = emac_rx_skb_size(dma_dev, ndev->mtu);
+	dev->rx_sync_size = emac_rx_sync_size(dma_dev, ndev->mtu);
 
 	/* Get pointers to BD rings */
 	dev->tx_desc =
diff --git a/drivers/net/ethernet/ibm/emac/core.h b/drivers/net/ethernet/ibm/emac/core.h
index 369de2c..68548a0 100644
--- a/drivers/net/ethernet/ibm/emac/core.h
+++ b/drivers/net/ethernet/ibm/emac/core.h
@@ -68,20 +68,20 @@ static inline int emac_rx_size(int mtu)
 		return mal_rx_size(ETH_DATA_LEN + EMAC_MTU_OVERHEAD);
 }
 
-#define EMAC_DMA_ALIGN(x)		ALIGN((x), dma_get_cache_alignment())
+#define EMAC_DMA_ALIGN(x)		ALIGN((x), dma_get_cache_alignment(dma_dev))
 
 #define EMAC_RX_SKB_HEADROOM		\
 	EMAC_DMA_ALIGN(CONFIG_IBM_EMAC_RX_SKB_HEADROOM)
 
 /* Size of RX skb for the given MTU */
-static inline int emac_rx_skb_size(int mtu)
+static inline int emac_rx_skb_size(struct device *dma_dev, int mtu)
 {
 	int size = max(mtu + EMAC_MTU_OVERHEAD, emac_rx_size(mtu));
 	return EMAC_DMA_ALIGN(size + 2) + EMAC_RX_SKB_HEADROOM;
 }
 
 /* RX DMA sync size */
-static inline int emac_rx_sync_size(int mtu)
+static inline int emac_rx_sync_size(struct device *dma_dev, int mtu)
 {
 	return EMAC_DMA_ALIGN(emac_rx_size(mtu) + 2);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index e61c99e..bc146dd 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -1660,7 +1660,7 @@ static int mlx4_init_icm(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap,
 	 */
 	dev->caps.reserved_mtts =
 		ALIGN(dev->caps.reserved_mtts * dev->caps.mtt_entry_sz,
-		      dma_get_cache_alignment()) / dev->caps.mtt_entry_sz;
+		      dma_get_cache_alignment(&dev->persist->pdev->dev)) / dev->caps.mtt_entry_sz;
 
 	err = mlx4_init_icm_table(dev, &priv->mr_table.mtt_table,
 				  init_hca->mtt_base,
diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index 974a8ce..e6da66e 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -862,7 +862,7 @@ static bool spi_qup_can_dma(struct spi_master *master, struct spi_device *spi,
 			    struct spi_transfer *xfer)
 {
 	struct spi_qup *qup = spi_master_get_devdata(master);
-	size_t dma_align = dma_get_cache_alignment();
+	size_t dma_align = dma_get_cache_alignment(qup->dev);
 	int n_words;
 
 	if (xfer->rx_buf) {
@@ -1038,7 +1038,7 @@ static int spi_qup_probe(struct platform_device *pdev)
 	master->transfer_one = spi_qup_transfer_one;
 	master->dev.of_node = pdev->dev.of_node;
 	master->auto_runtime_pm = true;
-	master->dma_alignment = dma_get_cache_alignment();
+	master->dma_alignment = dma_get_cache_alignment(dev);
 	master->max_dma_len = SPI_MAX_XFER;
 
 	platform_set_drvdata(pdev, master);
diff --git a/drivers/tty/serial/mpsc.c b/drivers/tty/serial/mpsc.c
index 67ffecc..c708457 100644
--- a/drivers/tty/serial/mpsc.c
+++ b/drivers/tty/serial/mpsc.c
@@ -81,19 +81,19 @@
  * Number of Tx & Rx descriptors must be powers of 2.
  */
 #define	MPSC_RXR_ENTRIES	32
-#define	MPSC_RXRE_SIZE		dma_get_cache_alignment()
+#define	MPSC_RXRE_SIZE		dma_get_cache_alignment(dma_dev)
 #define	MPSC_RXR_SIZE		(MPSC_RXR_ENTRIES * MPSC_RXRE_SIZE)
-#define	MPSC_RXBE_SIZE		dma_get_cache_alignment()
+#define	MPSC_RXBE_SIZE		dma_get_cache_alignment(dma_dev)
 #define	MPSC_RXB_SIZE		(MPSC_RXR_ENTRIES * MPSC_RXBE_SIZE)
 
 #define	MPSC_TXR_ENTRIES	32
-#define	MPSC_TXRE_SIZE		dma_get_cache_alignment()
+#define	MPSC_TXRE_SIZE		dma_get_cache_alignment(dma_dev)
 #define	MPSC_TXR_SIZE		(MPSC_TXR_ENTRIES * MPSC_TXRE_SIZE)
-#define	MPSC_TXBE_SIZE		dma_get_cache_alignment()
+#define	MPSC_TXBE_SIZE		dma_get_cache_alignment(dma_dev)
 #define	MPSC_TXB_SIZE		(MPSC_TXR_ENTRIES * MPSC_TXBE_SIZE)
 
 #define	MPSC_DMA_ALLOC_SIZE	(MPSC_RXR_SIZE + MPSC_RXB_SIZE + MPSC_TXR_SIZE \
-		+ MPSC_TXB_SIZE + dma_get_cache_alignment() /* for alignment */)
+		+ MPSC_TXB_SIZE + dma_get_cache_alignment(dma_dev) /* for alignment */)
 
 /* Rx and Tx Ring entry descriptors -- assume entry size is <= cacheline size */
 struct mpsc_rx_desc {
@@ -520,6 +520,7 @@ static uint mpsc_sdma_tx_active(struct mpsc_port_info *pi)
 static void mpsc_sdma_start_tx(struct mpsc_port_info *pi)
 {
 	struct mpsc_tx_desc *txre, *txre_p;
+	struct device *dma_dev = pi->port.dev;
 
 	/* If tx isn't running & there's a desc ready to go, start it */
 	if (!mpsc_sdma_tx_active(pi)) {
@@ -738,7 +739,7 @@ static void mpsc_init_hw(struct mpsc_port_info *pi)
 
 	mpsc_brg_init(pi, pi->brg_clk_src);
 	mpsc_brg_enable(pi);
-	mpsc_sdma_init(pi, dma_get_cache_alignment());	/* burst a cacheline */
+	mpsc_sdma_init(pi, dma_get_cache_alignment(pi->port.dev));	/* burst a cacheline */
 	mpsc_sdma_stop(pi);
 	mpsc_hw_init(pi);
 }
@@ -746,6 +747,7 @@ static void mpsc_init_hw(struct mpsc_port_info *pi)
 static int mpsc_alloc_ring_mem(struct mpsc_port_info *pi)
 {
 	int rc = 0;
+	struct device *dma_dev = pi->port.dev;
 
 	pr_debug("mpsc_alloc_ring_mem[%d]: Allocating ring mem\n",
 		pi->port.line);
@@ -769,6 +771,8 @@ static int mpsc_alloc_ring_mem(struct mpsc_port_info *pi)
 
 static void mpsc_free_ring_mem(struct mpsc_port_info *pi)
 {
+	struct device *dma_dev = pi->port.dev;
+
 	pr_debug("mpsc_free_ring_mem[%d]: Freeing ring mem\n", pi->port.line);
 
 	if (pi->dma_region) {
@@ -784,6 +788,7 @@ static void mpsc_init_rings(struct mpsc_port_info *pi)
 {
 	struct mpsc_rx_desc *rxre;
 	struct mpsc_tx_desc *txre;
+	struct device *dma_dev = pi->port.dev;
 	dma_addr_t dp, dp_p;
 	u8 *bp, *bp_p;
 	int i;
@@ -798,8 +803,8 @@ static void mpsc_init_rings(struct mpsc_port_info *pi)
 	 * Descriptors & buffers are multiples of cacheline size and must be
 	 * cacheline aligned.
 	 */
-	dp = ALIGN((u32)pi->dma_region, dma_get_cache_alignment());
-	dp_p = ALIGN((u32)pi->dma_region_p, dma_get_cache_alignment());
+	dp = ALIGN((u32)pi->dma_region, dma_get_cache_alignment(dma_dev));
+	dp_p = ALIGN((u32)pi->dma_region_p, dma_get_cache_alignment(dma_dev));
 
 	/*
 	 * Partition dma region into rx ring descriptor, rx buffers,
@@ -936,6 +941,7 @@ static int serial_polled;
 static int mpsc_rx_intr(struct mpsc_port_info *pi, unsigned long *flags)
 {
 	struct mpsc_rx_desc *rxre;
+	struct device *dma_dev = pi->port.dev;
 	struct tty_port *port = &pi->port.state->port;
 	u32	cmdstat, bytes_in, i;
 	int	rc = 0;
@@ -1091,6 +1097,7 @@ static int mpsc_rx_intr(struct mpsc_port_info *pi, unsigned long *flags)
 static void mpsc_setup_tx_desc(struct mpsc_port_info *pi, u32 count, u32 intr)
 {
 	struct mpsc_tx_desc *txre;
+	struct device *dma_dev = pi->port.dev;
 
 	txre = (struct mpsc_tx_desc *)(pi->txr
 			+ (pi->txr_head * MPSC_TXRE_SIZE));
@@ -1113,6 +1120,7 @@ static void mpsc_setup_tx_desc(struct mpsc_port_info *pi, u32 count, u32 intr)
 
 static void mpsc_copy_tx_data(struct mpsc_port_info *pi)
 {
+	struct device *dma_dev = pi->port.dev;
 	struct circ_buf *xmit = &pi->port.state->xmit;
 	u8 *bp;
 	u32 i;
@@ -1166,6 +1174,7 @@ static void mpsc_copy_tx_data(struct mpsc_port_info *pi)
 static int mpsc_tx_intr(struct mpsc_port_info *pi)
 {
 	struct mpsc_tx_desc *txre;
+	struct device *dma_dev = pi->port.dev;
 	int rc = 0;
 	unsigned long iflags;
 
@@ -1360,6 +1369,7 @@ static int mpsc_startup(struct uart_port *port)
 {
 	struct mpsc_port_info *pi =
 		container_of(port, struct mpsc_port_info, port);
+	struct device *dma_dev = pi->port.dev;
 	u32 flag = 0;
 	int rc;
 
@@ -1555,9 +1565,10 @@ static void mpsc_put_poll_char(struct uart_port *port,
 
 static int mpsc_get_poll_char(struct uart_port *port)
 {
+	struct mpsc_rx_desc *rxre;
 	struct mpsc_port_info *pi =
 		container_of(port, struct mpsc_port_info, port);
-	struct mpsc_rx_desc *rxre;
+	struct device *dma_dev = pi->port.dev;
 	u32	cmdstat, bytes_in, i;
 	u8	*bp;
 
@@ -1706,6 +1717,7 @@ static const struct uart_ops mpsc_pops = {
 static void mpsc_console_write(struct console *co, const char *s, uint count)
 {
 	struct mpsc_port_info *pi = &mpsc_ports[co->index];
+	struct device *dma_dev = pi->port.dev;
 	u8 *bp, *dp, add_cr = 0;
 	int i;
 	unsigned long iflags;
@@ -2024,7 +2036,8 @@ static void mpsc_drv_unmap_regs(struct mpsc_port_info *pi)
 static void mpsc_drv_get_platform_data(struct mpsc_port_info *pi,
 		struct platform_device *pd, int num)
 {
-	struct mpsc_pdata	*pdata;
+	struct mpsc_pdata *pdata;
+	struct device *dma_dev = pi->port.dev;
 
 	pdata = dev_get_platdata(&pd->dev);
 
diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 8aca18c..9df918e5 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -241,7 +241,7 @@ static void enable_tx_dma(struct s3c24xx_uart_port *ourport)
 	/* Enable tx dma mode */
 	ucon = rd_regl(port, S3C2410_UCON);
 	ucon &= ~(S3C64XX_UCON_TXBURST_MASK | S3C64XX_UCON_TXMODE_MASK);
-	ucon |= (dma_get_cache_alignment() >= 16) ?
+	ucon |= (dma_get_cache_alignment(port->dev) >= 16) ?
 		S3C64XX_UCON_TXBURST_16 : S3C64XX_UCON_TXBURST_1;
 	ucon |= S3C64XX_UCON_TXMODE_DMA;
 	wr_regl(port,  S3C2410_UCON, ucon);
@@ -292,7 +292,7 @@ static int s3c24xx_serial_start_tx_dma(struct s3c24xx_uart_port *ourport,
 	if (ourport->tx_mode != S3C24XX_TX_DMA)
 		enable_tx_dma(ourport);
 
-	dma->tx_size = count & ~(dma_get_cache_alignment() - 1);
+	dma->tx_size = count & ~(dma_get_cache_alignment(port->dev) - 1);
 	dma->tx_transfer_addr = dma->tx_addr + xmit->tail;
 
 	dma_sync_single_for_device(ourport->port.dev, dma->tx_transfer_addr,
@@ -332,7 +332,7 @@ static void s3c24xx_serial_start_next_tx(struct s3c24xx_uart_port *ourport)
 
 	if (!ourport->dma || !ourport->dma->tx_chan ||
 	    count < ourport->min_dma_size ||
-	    xmit->tail & (dma_get_cache_alignment() - 1))
+	    xmit->tail & (dma_get_cache_alignment(port->dev) - 1))
 		s3c24xx_serial_start_tx_pio(ourport);
 	else
 		s3c24xx_serial_start_tx_dma(ourport, count);
@@ -718,8 +718,8 @@ static irqreturn_t s3c24xx_serial_tx_chars(int irq, void *id)
 
 	if (ourport->dma && ourport->dma->tx_chan &&
 	    count >= ourport->min_dma_size) {
-		int align = dma_get_cache_alignment() -
-			(xmit->tail & (dma_get_cache_alignment() - 1));
+		int align = dma_get_cache_alignment(port->dev) -
+			(xmit->tail & (dma_get_cache_alignment(port->dev) - 1));
 		if (count-align >= ourport->min_dma_size) {
 			dma_count = count-align;
 			count = align;
@@ -870,7 +870,7 @@ static int s3c24xx_serial_request_dma(struct s3c24xx_uart_port *p)
 	dma->tx_conf.direction		= DMA_MEM_TO_DEV;
 	dma->tx_conf.dst_addr_width	= DMA_SLAVE_BUSWIDTH_1_BYTE;
 	dma->tx_conf.dst_addr		= p->port.mapbase + S3C2410_UTXH;
-	if (dma_get_cache_alignment() >= 16)
+	if (dma_get_cache_alignment(p->port.dev) >= 16)
 		dma->tx_conf.dst_maxburst = 16;
 	else
 		dma->tx_conf.dst_maxburst = 1;
@@ -1849,7 +1849,7 @@ static int s3c24xx_serial_probe(struct platform_device *pdev)
 	 * so find minimal transfer size suitable for DMA mode
 	 */
 	ourport->min_dma_size = max_t(int, ourport->port.fifosize,
-				    dma_get_cache_alignment());
+				    dma_get_cache_alignment(ourport->port.dev));
 
 	dbg("%s: initialising port %p...\n", __func__, ourport);
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 29ce981..1326023 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -131,6 +131,7 @@ struct dma_map_ops {
 #ifdef ARCH_HAS_DMA_GET_REQUIRED_MASK
 	u64 (*get_required_mask)(struct device *dev);
 #endif
+	int (*get_cache_alignment)(struct device *dev);
 	int is_phys;
 };
 
@@ -697,12 +698,18 @@ static inline void *dma_zalloc_coherent(struct device *dev, size_t size,
 }
 
 #ifdef CONFIG_HAS_DMA
-static inline int dma_get_cache_alignment(void)
-{
-#ifdef ARCH_DMA_MINALIGN
-	return ARCH_DMA_MINALIGN;
+
+#ifndef ARCH_DMA_MINALIGN
+#define ARCH_DMA_MINALIGN 1
 #endif
-	return 1;
+
+static inline int dma_get_cache_alignment(struct device *dev)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+	if (dev && ops && ops->get_cache_alignment)
+		return ops->get_cache_alignment(dev);
+
+	return ARCH_DMA_MINALIGN; /* compatible behavior */
 }
 #endif
 
-- 
2.7.0
