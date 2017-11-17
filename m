From: Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V10 1/4] dma-mapping: Rework dma_get_cache_alignment()
Date: Fri, 17 Nov 2017 12:27:52 +0800
Message-ID: <1510892872-32696-1-git-send-email-chenhc@lemote.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37756 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932695AbdKQE2M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2017 23:28:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-mips@linux-mips.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Huacai Chen <chenhc@lemote.com>, "Michael S . Tsirkin" <mst@redhat.com>, Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>, Michael Chan <michael.chan@broadcom.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ivan Mikhaylov <ivan@ru.ibm.com>, Tariq Toukan <tariqt@mellanox.com>, Andy Gross <agross@codeaurora.org>, Robert Baldyga <r.baldyga@hackerion.com>

Make dma_get_cache_alignment() to accept a 'dev' argument. As a result,
it can return different alignments due to different devices' I/O cache
coherency.

Currently, ARM/ARM64 and MIPS support coherent & noncoherent devices
co-exist. This may be extended in the future, so add a new function
pointer (i.e, get_cache_alignment) in 'struct dma_map_ops' as a generic
solution.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Michael Chan <michael.chan@broadcom.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ivan Mikhaylov <ivan@ru.ibm.com>
Cc: Tariq Toukan <tariqt@mellanox.com>
Cc: Andy Gross <agross@codeaurora.org>
Cc: Robert Baldyga <r.baldyga@hackerion.com>
Acked-by: Mark Greer <mgreer@animalcreek.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 drivers/infiniband/hw/mthca/mthca_main.c       |   2 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c |   2 +-
 drivers/net/ethernet/broadcom/b44.c            |  14 +-
 drivers/net/ethernet/ibm/emac/core.c           |  32 +++--
 drivers/net/ethernet/ibm/emac/core.h           |  14 +-
 drivers/net/ethernet/mellanox/mlx4/main.c      |   2 +-
 drivers/spi/spi-qup.c                          |   4 +-
 drivers/tty/serial/mpsc.c                      | 179 +++++++++++++------------
 drivers/tty/serial/samsung.c                   |  14 +-
 include/linux/dma-mapping.h                    |  20 ++-
 include/linux/ssb/ssb.h                        |   1 +
 11 files changed, 156 insertions(+), 128 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index f3e80de..b412f7f 100644
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
index a9806ba..7d5106b 100644
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
index 42e44fc..c1fa9d7 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -136,7 +136,6 @@ static void b44_init_rings(struct b44 *);
 
 static void b44_init_hw(struct b44 *, int);
 
-static int dma_desc_sync_size;
 static int instance;
 
 static const char b44_gstrings[][ETH_GSTRING_LEN] = {
@@ -151,7 +150,7 @@ static inline void b44_sync_dma_desc_for_device(struct ssb_device *sdev,
 						enum dma_data_direction dir)
 {
 	dma_sync_single_for_device(sdev->dma_dev, dma_base + offset,
-				   dma_desc_sync_size, dir);
+				   sdev->dma_desc_sync_size, dir);
 }
 
 static inline void b44_sync_dma_desc_for_cpu(struct ssb_device *sdev,
@@ -160,7 +159,7 @@ static inline void b44_sync_dma_desc_for_cpu(struct ssb_device *sdev,
 					     enum dma_data_direction dir)
 {
 	dma_sync_single_for_cpu(sdev->dma_dev, dma_base + offset,
-				dma_desc_sync_size, dir);
+				sdev->dma_desc_sync_size, dir);
 }
 
 static inline unsigned long br32(const struct b44 *bp, unsigned long reg)
@@ -2342,6 +2341,11 @@ static int b44_init_one(struct ssb_device *sdev,
 	struct net_device *dev;
 	struct b44 *bp;
 	int err;
+	unsigned int dma_desc_align_size = dma_get_cache_alignment(sdev->dma_dev);
+
+	/* Setup paramaters for syncing RX/TX DMA descriptors */
+	sdev->dma_desc_sync_size =
+		max_t(unsigned int, dma_desc_align_size, sizeof(struct dma_desc));
 
 	instance++;
 
@@ -2585,12 +2589,8 @@ static inline void b44_pci_exit(void)
 
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
index 7feff24..8dcebb2 100644
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
 
@@ -1074,7 +1075,7 @@ static int emac_resize_rx_ring(struct emac_instance *dev, int new_mtu)
 		BUG_ON(!dev->rx_skb[i]);
 		dev_kfree_skb(dev->rx_skb[i]);
 
-		skb_reserve(skb, EMAC_RX_SKB_HEADROOM + 2);
+		skb_reserve(skb, EMAC_RX_SKB_HEADROOM(dma_dev) + 2);
 		dev->rx_desc[i].data_ptr =
 		    dma_map_single(&dev->ofdev->dev, skb->data - 2, rx_sync_size,
 				   DMA_FROM_DEVICE) + 2;
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
@@ -1178,7 +1181,7 @@ static inline int emac_alloc_rx_skb(struct emac_instance *dev, int slot,
 	dev->rx_skb[slot] = skb;
 	dev->rx_desc[slot].data_len = 0;
 
-	skb_reserve(skb, EMAC_RX_SKB_HEADROOM + 2);
+	skb_reserve(skb, EMAC_RX_SKB_HEADROOM(dma_dev) + 2);
 	dev->rx_desc[slot].data_ptr =
 	    dma_map_single(&dev->ofdev->dev, skb->data - 2, dev->rx_sync_size,
 			   DMA_FROM_DEVICE) + 2;
@@ -1649,12 +1652,13 @@ static inline void emac_recycle_rx_skb(struct emac_instance *dev, int slot,
 				       int len)
 {
 	struct sk_buff *skb = dev->rx_skb[slot];
+	struct device *dma_dev = &dev->ofdev->dev;
 
 	DBG2(dev, "recycle %d %d" NL, slot, len);
 
 	if (len)
-		dma_map_single(&dev->ofdev->dev, skb->data - 2,
-			       EMAC_DMA_ALIGN(len + 2), DMA_FROM_DEVICE);
+		dma_map_single(dma_dev, skb->data - 2,
+			       EMAC_DMA_ALIGN(dma_dev, len + 2), DMA_FROM_DEVICE);
 
 	dev->rx_desc[slot].data_len = 0;
 	wmb();
@@ -1727,6 +1731,7 @@ static int emac_poll_rx(void *param, int budget)
 {
 	struct emac_instance *dev = param;
 	int slot = dev->rx_slot, received = 0;
+	struct device *dma_dev = &dev->ofdev->dev;
 
 	DBG2(dev, "poll_rx(%d)" NL, budget);
 
@@ -1763,11 +1768,11 @@ static int emac_poll_rx(void *param, int budget)
 
 		if (len && len < EMAC_RX_COPY_THRESH) {
 			struct sk_buff *copy_skb =
-			    alloc_skb(len + EMAC_RX_SKB_HEADROOM + 2, GFP_ATOMIC);
+			    alloc_skb(len + EMAC_RX_SKB_HEADROOM(dma_dev) + 2, GFP_ATOMIC);
 			if (unlikely(!copy_skb))
 				goto oom;
 
-			skb_reserve(copy_skb, EMAC_RX_SKB_HEADROOM + 2);
+			skb_reserve(copy_skb, EMAC_RX_SKB_HEADROOM(dma_dev) + 2);
 			memcpy(copy_skb->data - 2, skb->data - 2, len + 2);
 			emac_recycle_rx_skb(dev, slot, len);
 			skb = copy_skb;
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
index 369de2c..8107c32 100644
--- a/drivers/net/ethernet/ibm/emac/core.h
+++ b/drivers/net/ethernet/ibm/emac/core.h
@@ -68,22 +68,22 @@ static inline int emac_rx_size(int mtu)
 		return mal_rx_size(ETH_DATA_LEN + EMAC_MTU_OVERHEAD);
 }
 
-#define EMAC_DMA_ALIGN(x)		ALIGN((x), dma_get_cache_alignment())
+#define EMAC_DMA_ALIGN(d, x)		ALIGN((x), dma_get_cache_alignment(d))
 
-#define EMAC_RX_SKB_HEADROOM		\
-	EMAC_DMA_ALIGN(CONFIG_IBM_EMAC_RX_SKB_HEADROOM)
+#define EMAC_RX_SKB_HEADROOM(d)		\
+	EMAC_DMA_ALIGN(d, CONFIG_IBM_EMAC_RX_SKB_HEADROOM)
 
 /* Size of RX skb for the given MTU */
-static inline int emac_rx_skb_size(int mtu)
+static inline int emac_rx_skb_size(struct device *dev, int mtu)
 {
 	int size = max(mtu + EMAC_MTU_OVERHEAD, emac_rx_size(mtu));
-	return EMAC_DMA_ALIGN(size + 2) + EMAC_RX_SKB_HEADROOM;
+	return EMAC_DMA_ALIGN(dev, size + 2) + EMAC_RX_SKB_HEADROOM;
 }
 
 /* RX DMA sync size */
-static inline int emac_rx_sync_size(int mtu)
+static inline int emac_rx_sync_size(struct device *dev, int mtu)
 {
-	return EMAC_DMA_ALIGN(emac_rx_size(mtu) + 2);
+	return EMAC_DMA_ALIGN(dev, emac_rx_size(mtu) + 2);
 }
 
 /* Driver statistcs is split into two parts to make it more cache friendly:
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 4d84cab..22491cc 100644
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
index 1f60d6f..00a0161 100644
--- a/drivers/tty/serial/mpsc.c
+++ b/drivers/tty/serial/mpsc.c
@@ -79,19 +79,19 @@
  * Number of Tx & Rx descriptors must be powers of 2.
  */
 #define	MPSC_RXR_ENTRIES	32
-#define	MPSC_RXRE_SIZE		dma_get_cache_alignment()
-#define	MPSC_RXR_SIZE		(MPSC_RXR_ENTRIES * MPSC_RXRE_SIZE)
-#define	MPSC_RXBE_SIZE		dma_get_cache_alignment()
-#define	MPSC_RXB_SIZE		(MPSC_RXR_ENTRIES * MPSC_RXBE_SIZE)
+#define	MPSC_RXRE_SIZE(d)	dma_get_cache_alignment(d)
+#define	MPSC_RXR_SIZE(d)	(MPSC_RXR_ENTRIES * MPSC_RXRE_SIZE(d))
+#define	MPSC_RXBE_SIZE(d)	dma_get_cache_alignment(d)
+#define	MPSC_RXB_SIZE(d)	(MPSC_RXR_ENTRIES * MPSC_RXBE_SIZE(d))
 
 #define	MPSC_TXR_ENTRIES	32
-#define	MPSC_TXRE_SIZE		dma_get_cache_alignment()
-#define	MPSC_TXR_SIZE		(MPSC_TXR_ENTRIES * MPSC_TXRE_SIZE)
-#define	MPSC_TXBE_SIZE		dma_get_cache_alignment()
-#define	MPSC_TXB_SIZE		(MPSC_TXR_ENTRIES * MPSC_TXBE_SIZE)
+#define	MPSC_TXRE_SIZE(d)	dma_get_cache_alignment(d)
+#define	MPSC_TXR_SIZE(d)	(MPSC_TXR_ENTRIES * MPSC_TXRE_SIZE(d))
+#define	MPSC_TXBE_SIZE(d)	dma_get_cache_alignment(d)
+#define	MPSC_TXB_SIZE(d)	(MPSC_TXR_ENTRIES * MPSC_TXBE_SIZE(d))
 
-#define	MPSC_DMA_ALLOC_SIZE	(MPSC_RXR_SIZE + MPSC_RXB_SIZE + MPSC_TXR_SIZE \
-		+ MPSC_TXB_SIZE + dma_get_cache_alignment() /* for alignment */)
+#define	MPSC_DMA_ALLOC_SIZE(d)	(MPSC_RXR_SIZE(d) + MPSC_RXB_SIZE(d) + MPSC_TXR_SIZE(d) \
+		+ MPSC_TXB_SIZE(d) + dma_get_cache_alignment(d) /* for alignment */)
 
 /* Rx and Tx Ring entry descriptors -- assume entry size is <= cacheline size */
 struct mpsc_rx_desc {
@@ -518,22 +518,23 @@ static uint mpsc_sdma_tx_active(struct mpsc_port_info *pi)
 static void mpsc_sdma_start_tx(struct mpsc_port_info *pi)
 {
 	struct mpsc_tx_desc *txre, *txre_p;
+	struct device *dma_dev = pi->port.dev;
 
 	/* If tx isn't running & there's a desc ready to go, start it */
 	if (!mpsc_sdma_tx_active(pi)) {
 		txre = (struct mpsc_tx_desc *)(pi->txr
-				+ (pi->txr_tail * MPSC_TXRE_SIZE));
-		dma_cache_sync(pi->port.dev, (void *)txre, MPSC_TXRE_SIZE,
+				+ (pi->txr_tail * MPSC_TXRE_SIZE(dma_dev)));
+		dma_cache_sync(pi->port.dev, (void *)txre, MPSC_TXRE_SIZE(dma_dev),
 				DMA_FROM_DEVICE);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 		if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 			invalidate_dcache_range((ulong)txre,
-					(ulong)txre + MPSC_TXRE_SIZE);
+					(ulong)txre + MPSC_TXRE_SIZE(dma_dev));
 #endif
 
 		if (be32_to_cpu(txre->cmdstat) & SDMA_DESC_CMDSTAT_O) {
 			txre_p = (struct mpsc_tx_desc *)
-				(pi->txr_p + (pi->txr_tail * MPSC_TXRE_SIZE));
+				(pi->txr_p + (pi->txr_tail * MPSC_TXRE_SIZE(dma_dev)));
 
 			mpsc_sdma_set_tx_ring(pi, txre_p);
 			mpsc_sdma_cmd(pi, SDMA_SDCM_STD | SDMA_SDCM_TXD);
@@ -736,7 +737,7 @@ static void mpsc_init_hw(struct mpsc_port_info *pi)
 
 	mpsc_brg_init(pi, pi->brg_clk_src);
 	mpsc_brg_enable(pi);
-	mpsc_sdma_init(pi, dma_get_cache_alignment());	/* burst a cacheline */
+	mpsc_sdma_init(pi, dma_get_cache_alignment(pi->port.dev));	/* burst a cacheline */
 	mpsc_sdma_stop(pi);
 	mpsc_hw_init(pi);
 }
@@ -744,6 +745,7 @@ static void mpsc_init_hw(struct mpsc_port_info *pi)
 static int mpsc_alloc_ring_mem(struct mpsc_port_info *pi)
 {
 	int rc = 0;
+	struct device *dma_dev = pi->port.dev;
 
 	pr_debug("mpsc_alloc_ring_mem[%d]: Allocating ring mem\n",
 		pi->port.line);
@@ -753,7 +755,7 @@ static int mpsc_alloc_ring_mem(struct mpsc_port_info *pi)
 			printk(KERN_ERR "MPSC: Inadequate DMA support\n");
 			rc = -ENXIO;
 		} else if ((pi->dma_region = dma_alloc_attrs(pi->port.dev,
-						MPSC_DMA_ALLOC_SIZE,
+						MPSC_DMA_ALLOC_SIZE(dma_dev),
 						&pi->dma_region_p, GFP_KERNEL,
 						DMA_ATTR_NON_CONSISTENT))
 				== NULL) {
@@ -767,10 +769,12 @@ static int mpsc_alloc_ring_mem(struct mpsc_port_info *pi)
 
 static void mpsc_free_ring_mem(struct mpsc_port_info *pi)
 {
+	struct device *dma_dev = pi->port.dev;
+
 	pr_debug("mpsc_free_ring_mem[%d]: Freeing ring mem\n", pi->port.line);
 
 	if (pi->dma_region) {
-		dma_free_attrs(pi->port.dev, MPSC_DMA_ALLOC_SIZE,
+		dma_free_attrs(pi->port.dev, MPSC_DMA_ALLOC_SIZE(dma_dev),
 				pi->dma_region, pi->dma_region_p,
 				DMA_ATTR_NON_CONSISTENT);
 		pi->dma_region = NULL;
@@ -782,6 +786,7 @@ static void mpsc_init_rings(struct mpsc_port_info *pi)
 {
 	struct mpsc_rx_desc *rxre;
 	struct mpsc_tx_desc *txre;
+	struct device *dma_dev = pi->port.dev;
 	dma_addr_t dp, dp_p;
 	u8 *bp, *bp_p;
 	int i;
@@ -790,14 +795,14 @@ static void mpsc_init_rings(struct mpsc_port_info *pi)
 
 	BUG_ON(pi->dma_region == NULL);
 
-	memset(pi->dma_region, 0, MPSC_DMA_ALLOC_SIZE);
+	memset(pi->dma_region, 0, MPSC_DMA_ALLOC_SIZE(dma_dev));
 
 	/*
 	 * Descriptors & buffers are multiples of cacheline size and must be
 	 * cacheline aligned.
 	 */
-	dp = ALIGN((u32)pi->dma_region, dma_get_cache_alignment());
-	dp_p = ALIGN((u32)pi->dma_region_p, dma_get_cache_alignment());
+	dp = ALIGN((u32)pi->dma_region, dma_get_cache_alignment(dma_dev));
+	dp_p = ALIGN((u32)pi->dma_region_p, dma_get_cache_alignment(dma_dev));
 
 	/*
 	 * Partition dma region into rx ring descriptor, rx buffers,
@@ -805,20 +810,20 @@ static void mpsc_init_rings(struct mpsc_port_info *pi)
 	 */
 	pi->rxr = dp;
 	pi->rxr_p = dp_p;
-	dp += MPSC_RXR_SIZE;
-	dp_p += MPSC_RXR_SIZE;
+	dp += MPSC_RXR_SIZE(dma_dev);
+	dp_p += MPSC_RXR_SIZE(dma_dev);
 
 	pi->rxb = (u8 *)dp;
 	pi->rxb_p = (u8 *)dp_p;
-	dp += MPSC_RXB_SIZE;
-	dp_p += MPSC_RXB_SIZE;
+	dp += MPSC_RXB_SIZE(dma_dev);
+	dp_p += MPSC_RXB_SIZE(dma_dev);
 
 	pi->rxr_posn = 0;
 
 	pi->txr = dp;
 	pi->txr_p = dp_p;
-	dp += MPSC_TXR_SIZE;
-	dp_p += MPSC_TXR_SIZE;
+	dp += MPSC_TXR_SIZE(dma_dev);
+	dp_p += MPSC_TXR_SIZE(dma_dev);
 
 	pi->txb = (u8 *)dp;
 	pi->txb_p = (u8 *)dp_p;
@@ -835,18 +840,18 @@ static void mpsc_init_rings(struct mpsc_port_info *pi)
 	for (i = 0; i < MPSC_RXR_ENTRIES; i++) {
 		rxre = (struct mpsc_rx_desc *)dp;
 
-		rxre->bufsize = cpu_to_be16(MPSC_RXBE_SIZE);
+		rxre->bufsize = cpu_to_be16(MPSC_RXBE_SIZE(dma_dev));
 		rxre->bytecnt = cpu_to_be16(0);
 		rxre->cmdstat = cpu_to_be32(SDMA_DESC_CMDSTAT_O
 				| SDMA_DESC_CMDSTAT_EI | SDMA_DESC_CMDSTAT_F
 				| SDMA_DESC_CMDSTAT_L);
-		rxre->link = cpu_to_be32(dp_p + MPSC_RXRE_SIZE);
+		rxre->link = cpu_to_be32(dp_p + MPSC_RXRE_SIZE(dma_dev));
 		rxre->buf_ptr = cpu_to_be32(bp_p);
 
-		dp += MPSC_RXRE_SIZE;
-		dp_p += MPSC_RXRE_SIZE;
-		bp += MPSC_RXBE_SIZE;
-		bp_p += MPSC_RXBE_SIZE;
+		dp += MPSC_RXRE_SIZE(dma_dev);
+		dp_p += MPSC_RXRE_SIZE(dma_dev);
+		bp += MPSC_RXBE_SIZE(dma_dev);
+		bp_p += MPSC_RXBE_SIZE(dma_dev);
 	}
 	rxre->link = cpu_to_be32(pi->rxr_p);	/* Wrap last back to first */
 
@@ -859,23 +864,23 @@ static void mpsc_init_rings(struct mpsc_port_info *pi)
 	for (i = 0; i < MPSC_TXR_ENTRIES; i++) {
 		txre = (struct mpsc_tx_desc *)dp;
 
-		txre->link = cpu_to_be32(dp_p + MPSC_TXRE_SIZE);
+		txre->link = cpu_to_be32(dp_p + MPSC_TXRE_SIZE(dma_dev));
 		txre->buf_ptr = cpu_to_be32(bp_p);
 
-		dp += MPSC_TXRE_SIZE;
-		dp_p += MPSC_TXRE_SIZE;
-		bp += MPSC_TXBE_SIZE;
-		bp_p += MPSC_TXBE_SIZE;
+		dp += MPSC_TXRE_SIZE(dma_dev);
+		dp_p += MPSC_TXRE_SIZE(dma_dev);
+		bp += MPSC_TXBE_SIZE(dma_dev);
+		bp_p += MPSC_TXBE_SIZE(dma_dev);
 	}
 	txre->link = cpu_to_be32(pi->txr_p);	/* Wrap last back to first */
 
 	dma_cache_sync(pi->port.dev, (void *)pi->dma_region,
-			MPSC_DMA_ALLOC_SIZE, DMA_BIDIRECTIONAL);
+			MPSC_DMA_ALLOC_SIZE(dma_dev), DMA_BIDIRECTIONAL);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 		if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 			flush_dcache_range((ulong)pi->dma_region,
 					(ulong)pi->dma_region
-					+ MPSC_DMA_ALLOC_SIZE);
+					+ MPSC_DMA_ALLOC_SIZE(dma_dev));
 #endif
 
 	return;
@@ -934,6 +939,7 @@ static int serial_polled;
 static int mpsc_rx_intr(struct mpsc_port_info *pi, unsigned long *flags)
 {
 	struct mpsc_rx_desc *rxre;
+	struct device *dma_dev = pi->port.dev;
 	struct tty_port *port = &pi->port.state->port;
 	u32	cmdstat, bytes_in, i;
 	int	rc = 0;
@@ -942,14 +948,14 @@ static int mpsc_rx_intr(struct mpsc_port_info *pi, unsigned long *flags)
 
 	pr_debug("mpsc_rx_intr[%d]: Handling Rx intr\n", pi->port.line);
 
-	rxre = (struct mpsc_rx_desc *)(pi->rxr + (pi->rxr_posn*MPSC_RXRE_SIZE));
+	rxre = (struct mpsc_rx_desc *)(pi->rxr + (pi->rxr_posn*MPSC_RXRE_SIZE(dma_dev)));
 
-	dma_cache_sync(pi->port.dev, (void *)rxre, MPSC_RXRE_SIZE,
+	dma_cache_sync(pi->port.dev, (void *)rxre, MPSC_RXRE_SIZE(dma_dev),
 			DMA_FROM_DEVICE);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 	if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 		invalidate_dcache_range((ulong)rxre,
-				(ulong)rxre + MPSC_RXRE_SIZE);
+				(ulong)rxre + MPSC_RXRE_SIZE(dma_dev));
 #endif
 
 	/*
@@ -977,13 +983,13 @@ static int mpsc_rx_intr(struct mpsc_port_info *pi, unsigned long *flags)
 			 */
 		}
 
-		bp = pi->rxb + (pi->rxr_posn * MPSC_RXBE_SIZE);
-		dma_cache_sync(pi->port.dev, (void *)bp, MPSC_RXBE_SIZE,
+		bp = pi->rxb + (pi->rxr_posn * MPSC_RXBE_SIZE(dma_dev));
+		dma_cache_sync(pi->port.dev, (void *)bp, MPSC_RXBE_SIZE(dma_dev),
 				DMA_FROM_DEVICE);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 		if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 			invalidate_dcache_range((ulong)bp,
-					(ulong)bp + MPSC_RXBE_SIZE);
+					(ulong)bp + MPSC_RXBE_SIZE(dma_dev));
 #endif
 
 		/*
@@ -1054,24 +1060,24 @@ static int mpsc_rx_intr(struct mpsc_port_info *pi, unsigned long *flags)
 				| SDMA_DESC_CMDSTAT_EI | SDMA_DESC_CMDSTAT_F
 				| SDMA_DESC_CMDSTAT_L);
 		wmb();
-		dma_cache_sync(pi->port.dev, (void *)rxre, MPSC_RXRE_SIZE,
+		dma_cache_sync(pi->port.dev, (void *)rxre, MPSC_RXRE_SIZE(dma_dev),
 				DMA_BIDIRECTIONAL);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 		if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 			flush_dcache_range((ulong)rxre,
-					(ulong)rxre + MPSC_RXRE_SIZE);
+					(ulong)rxre + MPSC_RXRE_SIZE(dma_dev));
 #endif
 
 		/* Advance to next descriptor */
 		pi->rxr_posn = (pi->rxr_posn + 1) & (MPSC_RXR_ENTRIES - 1);
 		rxre = (struct mpsc_rx_desc *)
-			(pi->rxr + (pi->rxr_posn * MPSC_RXRE_SIZE));
-		dma_cache_sync(pi->port.dev, (void *)rxre, MPSC_RXRE_SIZE,
+			(pi->rxr + (pi->rxr_posn * MPSC_RXRE_SIZE(dma_dev)));
+		dma_cache_sync(pi->port.dev, (void *)rxre, MPSC_RXRE_SIZE(dma_dev),
 				DMA_FROM_DEVICE);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 		if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 			invalidate_dcache_range((ulong)rxre,
-					(ulong)rxre + MPSC_RXRE_SIZE);
+					(ulong)rxre + MPSC_RXRE_SIZE(dma_dev));
 #endif
 		rc = 1;
 	}
@@ -1089,9 +1095,10 @@ static int mpsc_rx_intr(struct mpsc_port_info *pi, unsigned long *flags)
 static void mpsc_setup_tx_desc(struct mpsc_port_info *pi, u32 count, u32 intr)
 {
 	struct mpsc_tx_desc *txre;
+	struct device *dma_dev = pi->port.dev;
 
 	txre = (struct mpsc_tx_desc *)(pi->txr
-			+ (pi->txr_head * MPSC_TXRE_SIZE));
+			+ (pi->txr_head * MPSC_TXRE_SIZE(dma_dev)));
 
 	txre->bytecnt = cpu_to_be16(count);
 	txre->shadow = txre->bytecnt;
@@ -1100,17 +1107,18 @@ static void mpsc_setup_tx_desc(struct mpsc_port_info *pi, u32 count, u32 intr)
 			| SDMA_DESC_CMDSTAT_L
 			| ((intr) ? SDMA_DESC_CMDSTAT_EI : 0));
 	wmb();
-	dma_cache_sync(pi->port.dev, (void *)txre, MPSC_TXRE_SIZE,
+	dma_cache_sync(pi->port.dev, (void *)txre, MPSC_TXRE_SIZE(dma_dev),
 			DMA_BIDIRECTIONAL);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 	if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 		flush_dcache_range((ulong)txre,
-				(ulong)txre + MPSC_TXRE_SIZE);
+				(ulong)txre + MPSC_TXRE_SIZE(dma_dev));
 #endif
 }
 
 static void mpsc_copy_tx_data(struct mpsc_port_info *pi)
 {
+	struct device *dma_dev = pi->port.dev;
 	struct circ_buf *xmit = &pi->port.state->xmit;
 	u8 *bp;
 	u32 i;
@@ -1127,17 +1135,17 @@ static void mpsc_copy_tx_data(struct mpsc_port_info *pi)
 			 * CHR_1.  Instead, just put it in-band with
 			 * all the other Tx data.
 			 */
-			bp = pi->txb + (pi->txr_head * MPSC_TXBE_SIZE);
+			bp = pi->txb + (pi->txr_head * MPSC_TXBE_SIZE(dma_dev));
 			*bp = pi->port.x_char;
 			pi->port.x_char = 0;
 			i = 1;
 		} else if (!uart_circ_empty(xmit)
 				&& !uart_tx_stopped(&pi->port)) {
-			i = min((u32)MPSC_TXBE_SIZE,
+			i = min((u32)MPSC_TXBE_SIZE(dma_dev),
 				(u32)uart_circ_chars_pending(xmit));
 			i = min(i, (u32)CIRC_CNT_TO_END(xmit->head, xmit->tail,
 				UART_XMIT_SIZE));
-			bp = pi->txb + (pi->txr_head * MPSC_TXBE_SIZE);
+			bp = pi->txb + (pi->txr_head * MPSC_TXBE_SIZE(dma_dev));
 			memcpy(bp, &xmit->buf[xmit->tail], i);
 			xmit->tail = (xmit->tail + i) & (UART_XMIT_SIZE - 1);
 
@@ -1147,12 +1155,12 @@ static void mpsc_copy_tx_data(struct mpsc_port_info *pi)
 			return;
 		}
 
-		dma_cache_sync(pi->port.dev, (void *)bp, MPSC_TXBE_SIZE,
+		dma_cache_sync(pi->port.dev, (void *)bp, MPSC_TXBE_SIZE(dma_dev),
 				DMA_BIDIRECTIONAL);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 		if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 			flush_dcache_range((ulong)bp,
-					(ulong)bp + MPSC_TXBE_SIZE);
+					(ulong)bp + MPSC_TXBE_SIZE(dma_dev));
 #endif
 		mpsc_setup_tx_desc(pi, i, 1);
 
@@ -1164,6 +1172,7 @@ static void mpsc_copy_tx_data(struct mpsc_port_info *pi)
 static int mpsc_tx_intr(struct mpsc_port_info *pi)
 {
 	struct mpsc_tx_desc *txre;
+	struct device *dma_dev = pi->port.dev;
 	int rc = 0;
 	unsigned long iflags;
 
@@ -1171,14 +1180,14 @@ static int mpsc_tx_intr(struct mpsc_port_info *pi)
 
 	if (!mpsc_sdma_tx_active(pi)) {
 		txre = (struct mpsc_tx_desc *)(pi->txr
-				+ (pi->txr_tail * MPSC_TXRE_SIZE));
+				+ (pi->txr_tail * MPSC_TXRE_SIZE(dma_dev)));
 
-		dma_cache_sync(pi->port.dev, (void *)txre, MPSC_TXRE_SIZE,
+		dma_cache_sync(pi->port.dev, (void *)txre, MPSC_TXRE_SIZE(dma_dev),
 				DMA_FROM_DEVICE);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 		if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 			invalidate_dcache_range((ulong)txre,
-					(ulong)txre + MPSC_TXRE_SIZE);
+					(ulong)txre + MPSC_TXRE_SIZE(dma_dev));
 #endif
 
 		while (!(be32_to_cpu(txre->cmdstat) & SDMA_DESC_CMDSTAT_O)) {
@@ -1191,13 +1200,13 @@ static int mpsc_tx_intr(struct mpsc_port_info *pi)
 				break;
 
 			txre = (struct mpsc_tx_desc *)(pi->txr
-					+ (pi->txr_tail * MPSC_TXRE_SIZE));
+					+ (pi->txr_tail * MPSC_TXRE_SIZE(dma_dev)));
 			dma_cache_sync(pi->port.dev, (void *)txre,
-					MPSC_TXRE_SIZE, DMA_FROM_DEVICE);
+					MPSC_TXRE_SIZE(dma_dev), DMA_FROM_DEVICE);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 			if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 				invalidate_dcache_range((ulong)txre,
-						(ulong)txre + MPSC_TXRE_SIZE);
+						(ulong)txre + MPSC_TXRE_SIZE(dma_dev));
 #endif
 		}
 
@@ -1358,6 +1367,7 @@ static int mpsc_startup(struct uart_port *port)
 {
 	struct mpsc_port_info *pi =
 		container_of(port, struct mpsc_port_info, port);
+	struct device *dma_dev = pi->port.dev;
 	u32 flag = 0;
 	int rc;
 
@@ -1379,7 +1389,7 @@ static int mpsc_startup(struct uart_port *port)
 
 		mpsc_sdma_intr_unmask(pi, 0xf);
 		mpsc_sdma_set_rx_ring(pi, (struct mpsc_rx_desc *)(pi->rxr_p
-					+ (pi->rxr_posn * MPSC_RXRE_SIZE)));
+					+ (pi->rxr_posn * MPSC_RXRE_SIZE(dma_dev))));
 	}
 
 	return rc;
@@ -1553,9 +1563,10 @@ static void mpsc_put_poll_char(struct uart_port *port,
 
 static int mpsc_get_poll_char(struct uart_port *port)
 {
+	struct mpsc_rx_desc *rxre;
 	struct mpsc_port_info *pi =
 		container_of(port, struct mpsc_port_info, port);
-	struct mpsc_rx_desc *rxre;
+	struct device *dma_dev = pi->port.dev;
 	u32	cmdstat, bytes_in, i;
 	u8	*bp;
 
@@ -1573,13 +1584,13 @@ static int mpsc_get_poll_char(struct uart_port *port)
 
 	while (poll_cnt == 0) {
 		rxre = (struct mpsc_rx_desc *)(pi->rxr +
-		       (pi->rxr_posn*MPSC_RXRE_SIZE));
+		       (pi->rxr_posn*MPSC_RXRE_SIZE(dma_dev)));
 		dma_cache_sync(pi->port.dev, (void *)rxre,
-			       MPSC_RXRE_SIZE, DMA_FROM_DEVICE);
+			       MPSC_RXRE_SIZE(dma_dev), DMA_FROM_DEVICE);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 		if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 			invalidate_dcache_range((ulong)rxre,
-			(ulong)rxre + MPSC_RXRE_SIZE);
+			(ulong)rxre + MPSC_RXRE_SIZE(dma_dev));
 #endif
 		/*
 		 * Loop through Rx descriptors handling ones that have
@@ -1589,13 +1600,13 @@ static int mpsc_get_poll_char(struct uart_port *port)
 		       !((cmdstat = be32_to_cpu(rxre->cmdstat)) &
 			 SDMA_DESC_CMDSTAT_O)){
 			bytes_in = be16_to_cpu(rxre->bytecnt);
-			bp = pi->rxb + (pi->rxr_posn * MPSC_RXBE_SIZE);
+			bp = pi->rxb + (pi->rxr_posn * MPSC_RXBE_SIZE(dma_dev));
 			dma_cache_sync(pi->port.dev, (void *) bp,
-				       MPSC_RXBE_SIZE, DMA_FROM_DEVICE);
+				       MPSC_RXBE_SIZE(dma_dev), DMA_FROM_DEVICE);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 			if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 				invalidate_dcache_range((ulong)bp,
-					(ulong)bp + MPSC_RXBE_SIZE);
+					(ulong)bp + MPSC_RXBE_SIZE(dma_dev));
 #endif
 			if ((unlikely(cmdstat & (SDMA_DESC_CMDSTAT_BR |
 			 SDMA_DESC_CMDSTAT_FR | SDMA_DESC_CMDSTAT_OR))) &&
@@ -1617,24 +1628,24 @@ static int mpsc_get_poll_char(struct uart_port *port)
 						    SDMA_DESC_CMDSTAT_L);
 			wmb();
 			dma_cache_sync(pi->port.dev, (void *)rxre,
-				       MPSC_RXRE_SIZE, DMA_BIDIRECTIONAL);
+				       MPSC_RXRE_SIZE(dma_dev), DMA_BIDIRECTIONAL);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 			if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 				flush_dcache_range((ulong)rxre,
-					   (ulong)rxre + MPSC_RXRE_SIZE);
+					   (ulong)rxre + MPSC_RXRE_SIZE(dma_dev));
 #endif
 
 			/* Advance to next descriptor */
 			pi->rxr_posn = (pi->rxr_posn + 1) &
 				(MPSC_RXR_ENTRIES - 1);
 			rxre = (struct mpsc_rx_desc *)(pi->rxr +
-				       (pi->rxr_posn * MPSC_RXRE_SIZE));
+				       (pi->rxr_posn * MPSC_RXRE_SIZE(dma_dev)));
 			dma_cache_sync(pi->port.dev, (void *)rxre,
-				       MPSC_RXRE_SIZE, DMA_FROM_DEVICE);
+				       MPSC_RXRE_SIZE(dma_dev), DMA_FROM_DEVICE);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 			if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 				invalidate_dcache_range((ulong)rxre,
-						(ulong)rxre + MPSC_RXRE_SIZE);
+						(ulong)rxre + MPSC_RXRE_SIZE(dma_dev));
 #endif
 		}
 
@@ -1704,6 +1715,7 @@ static const struct uart_ops mpsc_pops = {
 static void mpsc_console_write(struct console *co, const char *s, uint count)
 {
 	struct mpsc_port_info *pi = &mpsc_ports[co->index];
+	struct device *dma_dev = pi->port.dev;
 	u8 *bp, *dp, add_cr = 0;
 	int i;
 	unsigned long iflags;
@@ -1721,9 +1733,9 @@ static void mpsc_console_write(struct console *co, const char *s, uint count)
 		udelay(100);
 
 	while (count > 0) {
-		bp = dp = pi->txb + (pi->txr_head * MPSC_TXBE_SIZE);
+		bp = dp = pi->txb + (pi->txr_head * MPSC_TXBE_SIZE(dma_dev));
 
-		for (i = 0; i < MPSC_TXBE_SIZE; i++) {
+		for (i = 0; i < MPSC_TXBE_SIZE(dma_dev); i++) {
 			if (count == 0)
 				break;
 
@@ -1742,12 +1754,12 @@ static void mpsc_console_write(struct console *co, const char *s, uint count)
 			count--;
 		}
 
-		dma_cache_sync(pi->port.dev, (void *)bp, MPSC_TXBE_SIZE,
+		dma_cache_sync(pi->port.dev, (void *)bp, MPSC_TXBE_SIZE(dma_dev),
 				DMA_BIDIRECTIONAL);
 #if defined(CONFIG_PPC32) && !defined(CONFIG_NOT_COHERENT_CACHE)
 		if (pi->cache_mgmt) /* GT642[46]0 Res #COMM-2 */
 			flush_dcache_range((ulong)bp,
-					(ulong)bp + MPSC_TXBE_SIZE);
+					(ulong)bp + MPSC_TXBE_SIZE(dma_dev));
 #endif
 		mpsc_setup_tx_desc(pi, i, 0);
 		pi->txr_head = (pi->txr_head + 1) & (MPSC_TXR_ENTRIES - 1);
@@ -2022,7 +2034,8 @@ static void mpsc_drv_unmap_regs(struct mpsc_port_info *pi)
 static void mpsc_drv_get_platform_data(struct mpsc_port_info *pi,
 		struct platform_device *pd, int num)
 {
-	struct mpsc_pdata	*pdata;
+	struct mpsc_pdata *pdata;
+	struct device *dma_dev = pi->port.dev;
 
 	pdata = dev_get_platdata(&pd->dev);
 
@@ -2030,7 +2043,7 @@ static void mpsc_drv_get_platform_data(struct mpsc_port_info *pi,
 	pi->port.iotype = UPIO_MEM;
 	pi->port.line = num;
 	pi->port.type = PORT_MPSC;
-	pi->port.fifosize = MPSC_TXBE_SIZE;
+	pi->port.fifosize = MPSC_TXBE_SIZE(dma_dev);
 	pi->port.membase = pi->mpsc_base;
 	pi->port.mapbase = (ulong)pi->mpsc_base;
 	pi->port.ops = &mpsc_pops;
diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index f9fecc5..963ee99 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -238,7 +238,7 @@ static void enable_tx_dma(struct s3c24xx_uart_port *ourport)
 	/* Enable tx dma mode */
 	ucon = rd_regl(port, S3C2410_UCON);
 	ucon &= ~(S3C64XX_UCON_TXBURST_MASK | S3C64XX_UCON_TXMODE_MASK);
-	ucon |= (dma_get_cache_alignment() >= 16) ?
+	ucon |= (dma_get_cache_alignment(port->dev) >= 16) ?
 		S3C64XX_UCON_TXBURST_16 : S3C64XX_UCON_TXBURST_1;
 	ucon |= S3C64XX_UCON_TXMODE_DMA;
 	wr_regl(port,  S3C2410_UCON, ucon);
@@ -289,7 +289,7 @@ static int s3c24xx_serial_start_tx_dma(struct s3c24xx_uart_port *ourport,
 	if (ourport->tx_mode != S3C24XX_TX_DMA)
 		enable_tx_dma(ourport);
 
-	dma->tx_size = count & ~(dma_get_cache_alignment() - 1);
+	dma->tx_size = count & ~(dma_get_cache_alignment(port->dev) - 1);
 	dma->tx_transfer_addr = dma->tx_addr + xmit->tail;
 
 	dma_sync_single_for_device(ourport->port.dev, dma->tx_transfer_addr,
@@ -329,7 +329,7 @@ static void s3c24xx_serial_start_next_tx(struct s3c24xx_uart_port *ourport)
 
 	if (!ourport->dma || !ourport->dma->tx_chan ||
 	    count < ourport->min_dma_size ||
-	    xmit->tail & (dma_get_cache_alignment() - 1))
+	    xmit->tail & (dma_get_cache_alignment(port->dev) - 1))
 		s3c24xx_serial_start_tx_pio(ourport);
 	else
 		s3c24xx_serial_start_tx_dma(ourport, count);
@@ -715,8 +715,8 @@ static irqreturn_t s3c24xx_serial_tx_chars(int irq, void *id)
 
 	if (ourport->dma && ourport->dma->tx_chan &&
 	    count >= ourport->min_dma_size) {
-		int align = dma_get_cache_alignment() -
-			(xmit->tail & (dma_get_cache_alignment() - 1));
+		int align = dma_get_cache_alignment(port->dev) -
+			(xmit->tail & (dma_get_cache_alignment(port->dev) - 1));
 		if (count-align >= ourport->min_dma_size) {
 			dma_count = count-align;
 			count = align;
@@ -867,7 +867,7 @@ static int s3c24xx_serial_request_dma(struct s3c24xx_uart_port *p)
 	dma->tx_conf.direction		= DMA_MEM_TO_DEV;
 	dma->tx_conf.dst_addr_width	= DMA_SLAVE_BUSWIDTH_1_BYTE;
 	dma->tx_conf.dst_addr		= p->port.mapbase + S3C2410_UTXH;
-	if (dma_get_cache_alignment() >= 16)
+	if (dma_get_cache_alignment(p->port.dev) >= 16)
 		dma->tx_conf.dst_maxburst = 16;
 	else
 		dma->tx_conf.dst_maxburst = 1;
@@ -1846,7 +1846,7 @@ static int s3c24xx_serial_probe(struct platform_device *pdev)
 	 * so find minimal transfer size suitable for DMA mode
 	 */
 	ourport->min_dma_size = max_t(int, ourport->port.fifosize,
-				    dma_get_cache_alignment());
+				    dma_get_cache_alignment(ourport->port.dev));
 
 	dbg("%s: initialising port %p...\n", __func__, ourport);
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index e8f8e8f..9ec4850 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -133,6 +133,7 @@ struct dma_map_ops {
 #ifdef ARCH_HAS_DMA_GET_REQUIRED_MASK
 	u64 (*get_required_mask)(struct device *dev);
 #endif
+	int (*get_cache_alignment)(struct device *dev);
 	int is_phys;
 };
 
@@ -704,15 +705,22 @@ static inline void *dma_zalloc_coherent(struct device *dev, size_t size,
 	return ret;
 }
 
-#ifdef CONFIG_HAS_DMA
-static inline int dma_get_cache_alignment(void)
+
+#ifndef ARCH_DMA_MINALIGN
+#define ARCH_DMA_MINALIGN 1
+#endif
+
+static inline int dma_get_cache_alignment(struct device *dev)
 {
-#ifdef ARCH_DMA_MINALIGN
-	return ARCH_DMA_MINALIGN;
+#ifdef CONFIG_HAS_DMA
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (dev && ops && ops->get_cache_alignment)
+		return ops->get_cache_alignment(dev);
 #endif
-	return 1;
+
+	return ARCH_DMA_MINALIGN; /* compatible behavior */
 }
-#endif
 
 /* flags for the coherent memory api */
 #define DMA_MEMORY_EXCLUSIVE		0x01
diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index 3b43655..049b1a4 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -277,6 +277,7 @@ struct ssb_device {
 
 	u8 core_index;
 	unsigned int irq;
+	unsigned int dma_desc_sync_size;
 
 	/* Internal-only stuff follows. */
 	void *drvdata;		/* Per-device data */
-- 
2.7.0
