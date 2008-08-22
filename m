From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/4] drop vmerge accounting
Date: Fri, 22 Aug 2008 17:35:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0808221734400.12039@hs20-bc2-1.build.redhat.com>
References: <20080808055405.GF20055@kernel.dk> <20080808151147J.fujita.tomonori@lab.ntt.co.jp>
 <20080808061537.GI20055@kernel.dk> <20080808152845N.fujita.tomonori@lab.ntt.co.jp>
 <20080808063527.GJ20055@kernel.dk> <Pine.LNX.4.64.0808081247430.11647@devserv.devel.redhat.com>
 <Pine.LNX.4.64.0808081254000.11647@devserv.devel.redhat.com>
 <20080815094800.GI20055@kernel.dk> <Pine.LNX.4.64.0808151418240.24727@hs20-bc2-1.build.redhat.com>
 <20080822112942.67404141@mjolnir.drzeus.cx> <20080822093322.GF20055@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203AbYHVVfx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2008 17:35:53 -0400
In-Reply-To: <20080822093322.GF20055@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, adel.gadllah@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com, pjones@redhat.com, viro@zeniv.linux.org.uk, dougg@torque.net

Remove max_hw_segs variable from MMC layer.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index a6529ce..0733a1b 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -133,7 +133,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
 
 #ifdef CONFIG_MMC_BLOCK_BOUNCE
-	if (host->max_hw_segs == 1) {
+	if (host->max_phys_segs == 1) {
 		unsigned int bouncesz;
 
 		bouncesz = MMC_QUEUE_BOUNCESZ;
@@ -175,8 +175,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 	if (!mq->bounce_buf) {
 		blk_queue_bounce_limit(mq->queue, limit);
 		blk_queue_max_sectors(mq->queue, host->max_req_size / 512);
-	/* TODO: drop host->max_hw_segs */
-		blk_queue_max_phys_segments(mq->queue, min(host->max_phys_segs, host->max_hw_segs));
+		blk_queue_max_phys_segments(mq->queue, host->max_phys_segs);
 		blk_queue_max_segment_size(mq->queue, host->max_seg_size);
 
 		mq->sg = kmalloc(sizeof(struct scatterlist) *
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 6da80fd..27a02fd 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -89,7 +89,6 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 	 * By default, hosts do not support SGIO or large requests.
 	 * They have to set these according to their abilities.
 	 */
-	host->max_hw_segs = 1;
 	host->max_phys_segs = 1;
 	host->max_seg_size = PAGE_CACHE_SIZE;
 
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 0bd06f5..1d2293e 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1037,7 +1037,6 @@ static int __init atmci_probe(struct platform_device *pdev)
 	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
 	mmc->caps |= MMC_CAP_4_BIT_DATA;
 
-	mmc->max_hw_segs = 64;
 	mmc->max_phys_segs = 64;
 	mmc->max_req_size = 32768 * 512;
 	mmc->max_blk_size = 32768;
diff --git a/drivers/mmc/host/imxmmc.c b/drivers/mmc/host/imxmmc.c
index 2f0fcdb..f97c90a 100644
--- a/drivers/mmc/host/imxmmc.c
+++ b/drivers/mmc/host/imxmmc.c
@@ -958,7 +958,6 @@ static int imxmci_probe(struct platform_device *pdev)
 	mmc->caps = MMC_CAP_4_BIT_DATA;
 
 	/* MMC core transfer sizes tunable parameters */
-	mmc->max_hw_segs = 64;
 	mmc->max_phys_segs = 64;
 	mmc->max_seg_size = 64*512;	/* default PAGE_CACHE_SIZE */
 	mmc->max_req_size = 64*512;	/* default PAGE_CACHE_SIZE */
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 696cf36..a2384f6 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -539,7 +539,6 @@ static int mmci_probe(struct amba_device *dev, void *id)
 	/*
 	 * We can do SGIO
 	 */
-	mmc->max_hw_segs = 16;
 	mmc->max_phys_segs = NR_SG;
 
 	/*
diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index c160288..066ad03 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1336,7 +1336,6 @@ static int __init mmc_omap_new_slot(struct mmc_omap_host *host, int id)
 	 * normally used (except e.g. for reading SD registers).
 	 */
 	mmc->max_phys_segs = 32;
-	mmc->max_hw_segs = 32;
 	mmc->max_blk_size = 2048;	/* BLEN is 11 bits (+1) */
 	mmc->max_blk_count = 2048;	/* NBLK is 11 bits (+1) */
 	mmc->max_req_size = mmc->max_blk_size * mmc->max_blk_count;
diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index ae16d84..4b91999 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1291,7 +1291,6 @@ static int __devinit s3cmci_probe(struct platform_device *pdev, int is2440)
 	mmc->max_seg_size	= mmc->max_req_size;
 
 	mmc->max_phys_segs	= 128;
-	mmc->max_hw_segs	= 128;
 
 	dbg(host, dbg_debug,
 	    "probe: mode:%s mapped mci_base:%p irq:%u irq_cd:%u dma:%u.\n",
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index e3a8133..8de2024 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1628,12 +1628,11 @@ int sdhci_add_host(struct sdhci_host *host)
 	 * can do scatter/gather or not.
 	 */
 	if (host->flags & SDHCI_USE_ADMA)
-		mmc->max_hw_segs = 128;
+		mmc->max_phys_segs = 128;
 	else if (host->flags & SDHCI_USE_DMA)
-		mmc->max_hw_segs = 1;
+		mmc->max_phys_segs = 1;
 	else /* PIO */
-		mmc->max_hw_segs = 128;
-	mmc->max_phys_segs = 128;
+		mmc->max_phys_segs = 128;
 
 	/*
 	 * Maximum number of sectors in one transfer. Limited by DMA boundary
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index 1384484..5700c1a 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -978,11 +978,10 @@ static int tifm_sd_probe(struct tifm_dev *sock)
 	mmc->f_max = 24000000;
 
 	mmc->max_blk_count = 2048;
-	mmc->max_hw_segs = mmc->max_blk_count;
+	mmc->max_phys_segs = mmc->max_blk_count;
 	mmc->max_blk_size = min(TIFM_MMCSD_MAX_BLOCK_SIZE, PAGE_SIZE);
 	mmc->max_seg_size = mmc->max_blk_count * mmc->max_blk_size;
 	mmc->max_req_size = mmc->max_seg_size;
-	mmc->max_phys_segs = mmc->max_hw_segs;
 
 	sock->card_event = tifm_sd_card_event;
 	sock->data_event = tifm_sd_data_event;
diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index adda379..034ccc4 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -1234,7 +1234,6 @@ static int __devinit wbsd_alloc_mmc(struct device *dev)
 	 * Maximum number of segments. Worst case is one sector per segment
 	 * so this will be 64kB/512.
 	 */
-	mmc->max_hw_segs = 128;
 	mmc->max_phys_segs = 128;
 
 	/*
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 9c288c9..e11b957 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -119,7 +119,6 @@ struct mmc_host {
 
 	/* host specific block data */
 	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
-	unsigned short		max_hw_segs;	/* see blk_queue_max_hw_segments */
 	unsigned short		max_phys_segs;	/* see blk_queue_max_phys_segments */
 	unsigned short		unused;
 	unsigned int		max_req_size;	/* maximum number of bytes in one req */
