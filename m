From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/4] drop vmerge accounting
Date: Fri, 15 Aug 2008 14:26:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0808151423241.24727@hs20-bc2-1.build.redhat.com>
References: <20080808055405.GF20055@kernel.dk> <20080808151147J.fujita.tomonori@lab.ntt.co.jp>
 <20080808061537.GI20055@kernel.dk> <20080808152845N.fujita.tomonori@lab.ntt.co.jp>
 <20080808063527.GJ20055@kernel.dk> <Pine.LNX.4.64.0808081247430.11647@devserv.devel.redhat.com>
 <Pine.LNX.4.64.0808081254000.11647@devserv.devel.redhat.com>
 <20080815094800.GI20055@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbYHOS0x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Aug 2008 14:26:53 -0400
In-Reply-To: <20080815094800.GI20055@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, adel.gadllah@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com, pjones@redhat.com, viro@zeniv.linux.org.uk, dougg@torque.net

Remove max_hw_segs from MMC subsystems, because it is already being 
removed from the block layer. Most controller drivers set max_hw_segs 
equal to max_phys_segs. The only one that doesn't is sdhci.

I don't have any of the cards, I at least tried to compile the code.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/mmc/card/queue.c     |    5 ++---
 drivers/mmc/core/host.c      |    1 -
 drivers/mmc/host/atmel-mci.c |    1 -
 drivers/mmc/host/imxmmc.c    |    1 -
 drivers/mmc/host/mmci.c      |    1 -
 drivers/mmc/host/omap.c      |    1 -
 drivers/mmc/host/s3cmci.c    |    1 -
 drivers/mmc/host/sdhci.c     |    7 +++----
 drivers/mmc/host/tifm_sd.c   |    3 +--
 drivers/mmc/host/wbsd.c      |    1 -
 include/linux/mmc/host.h     |    1 -
 11 files changed, 6 insertions(+), 17 deletions(-)

Index: linux-2.6.27-rc3-devel/drivers/mmc/card/queue.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/mmc/card/queue.c	2008-08-15 19:48:52.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/mmc/card/queue.c	2008-08-15 19:49:10.000000000 +0200
@@ -133,7 +133,7 @@ int mmc_init_queue(struct mmc_queue *mq,
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
 
 #ifdef CONFIG_MMC_BLOCK_BOUNCE
-	if (host->max_hw_segs == 1) {
+	if (host->max_phys_segs == 1) {
 		unsigned int bouncesz;
 
 		bouncesz = MMC_QUEUE_BOUNCESZ;
@@ -175,8 +175,7 @@ int mmc_init_queue(struct mmc_queue *mq,
 	if (!mq->bounce_buf) {
 		blk_queue_bounce_limit(mq->queue, limit);
 		blk_queue_max_sectors(mq->queue, host->max_req_size / 512);
-	/* TODO: drop host->max_hw_segs */
-		blk_queue_max_phys_segments(mq->queue, min(host->max_phys_segs, host->max_hw_segs));
+		blk_queue_max_phys_segments(mq->queue, host->max_phys_segs);
 		blk_queue_max_segment_size(mq->queue, host->max_seg_size);
 
 		mq->sg = kmalloc(sizeof(struct scatterlist) *
Index: linux-2.6.27-rc3-devel/drivers/mmc/core/host.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/mmc/core/host.c	2008-08-15 19:49:17.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/mmc/core/host.c	2008-08-15 19:49:19.000000000 +0200
@@ -89,7 +89,6 @@ struct mmc_host *mmc_alloc_host(int extr
 	 * By default, hosts do not support SGIO or large requests.
 	 * They have to set these according to their abilities.
 	 */
-	host->max_hw_segs = 1;
 	host->max_phys_segs = 1;
 	host->max_seg_size = PAGE_CACHE_SIZE;
 
Index: linux-2.6.27-rc3-devel/drivers/mmc/host/atmel-mci.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/mmc/host/atmel-mci.c	2008-08-15 19:51:36.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/mmc/host/atmel-mci.c	2008-08-15 19:51:40.000000000 +0200
@@ -1037,7 +1037,6 @@ static int __init atmci_probe(struct pla
 	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
 	mmc->caps |= MMC_CAP_4_BIT_DATA;
 
-	mmc->max_hw_segs = 64;
 	mmc->max_phys_segs = 64;
 	mmc->max_req_size = 32768 * 512;
 	mmc->max_blk_size = 32768;
Index: linux-2.6.27-rc3-devel/drivers/mmc/host/imxmmc.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/mmc/host/imxmmc.c	2008-08-15 19:49:33.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/mmc/host/imxmmc.c	2008-08-15 19:49:35.000000000 +0200
@@ -958,7 +958,6 @@ static int imxmci_probe(struct platform_
 	mmc->caps = MMC_CAP_4_BIT_DATA;
 
 	/* MMC core transfer sizes tunable parameters */
-	mmc->max_hw_segs = 64;
 	mmc->max_phys_segs = 64;
 	mmc->max_seg_size = 64*512;	/* default PAGE_CACHE_SIZE */
 	mmc->max_req_size = 64*512;	/* default PAGE_CACHE_SIZE */
Index: linux-2.6.27-rc3-devel/drivers/mmc/host/mmci.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/mmc/host/mmci.c	2008-08-15 19:49:43.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/mmc/host/mmci.c	2008-08-15 19:50:30.000000000 +0200
@@ -539,7 +539,6 @@ static int mmci_probe(struct amba_device
 	/*
 	 * We can do SGIO
 	 */
-	mmc->max_hw_segs = 16;
 	mmc->max_phys_segs = NR_SG;
 
 	/*
Index: linux-2.6.27-rc3-devel/drivers/mmc/host/omap.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/mmc/host/omap.c	2008-08-15 19:50:37.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/mmc/host/omap.c	2008-08-15 19:50:42.000000000 +0200
@@ -1336,7 +1336,6 @@ static int __init mmc_omap_new_slot(stru
 	 * normally used (except e.g. for reading SD registers).
 	 */
 	mmc->max_phys_segs = 32;
-	mmc->max_hw_segs = 32;
 	mmc->max_blk_size = 2048;	/* BLEN is 11 bits (+1) */
 	mmc->max_blk_count = 2048;	/* NBLK is 11 bits (+1) */
 	mmc->max_req_size = mmc->max_blk_size * mmc->max_blk_count;
Index: linux-2.6.27-rc3-devel/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/mmc/host/s3cmci.c	2008-08-15 19:49:25.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/mmc/host/s3cmci.c	2008-08-15 19:49:29.000000000 +0200
@@ -1288,7 +1288,6 @@ static int __devinit s3cmci_probe(struct
 	mmc->max_seg_size	= mmc->max_req_size;
 
 	mmc->max_phys_segs	= 128;
-	mmc->max_hw_segs	= 128;
 
 	dbg(host, dbg_debug,
 	    "probe: mode:%s mapped mci_base:%p irq:%u irq_cd:%u dma:%u.\n",
Index: linux-2.6.27-rc3-devel/drivers/mmc/host/sdhci.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/mmc/host/sdhci.c	2008-08-15 19:50:46.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/mmc/host/sdhci.c	2008-08-15 19:51:05.000000000 +0200
@@ -1628,12 +1628,11 @@ int sdhci_add_host(struct sdhci_host *ho
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
Index: linux-2.6.27-rc3-devel/drivers/mmc/host/tifm_sd.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/mmc/host/tifm_sd.c	2008-08-15 19:51:11.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/mmc/host/tifm_sd.c	2008-08-15 19:51:22.000000000 +0200
@@ -978,11 +978,10 @@ static int tifm_sd_probe(struct tifm_dev
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
Index: linux-2.6.27-rc3-devel/drivers/mmc/host/wbsd.c
===================================================================
--- linux-2.6.27-rc3-devel.orig/drivers/mmc/host/wbsd.c	2008-08-15 19:51:27.000000000 +0200
+++ linux-2.6.27-rc3-devel/drivers/mmc/host/wbsd.c	2008-08-15 19:51:31.000000000 +0200
@@ -1234,7 +1234,6 @@ static int __devinit wbsd_alloc_mmc(stru
 	 * Maximum number of segments. Worst case is one sector per segment
 	 * so this will be 64kB/512.
 	 */
-	mmc->max_hw_segs = 128;
 	mmc->max_phys_segs = 128;
 
 	/*
Index: linux-2.6.27-rc3-devel/include/linux/mmc/host.h
===================================================================
--- linux-2.6.27-rc3-devel.orig/include/linux/mmc/host.h	2008-08-15 19:48:18.000000000 +0200
+++ linux-2.6.27-rc3-devel/include/linux/mmc/host.h	2008-08-15 19:48:27.000000000 +0200
@@ -119,7 +119,6 @@ struct mmc_host {
 
 	/* host specific block data */
 	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
-	unsigned short		max_hw_segs;	/* see blk_queue_max_hw_segments */
 	unsigned short		max_phys_segs;	/* see blk_queue_max_phys_segments */
 	unsigned short		unused;
 	unsigned int		max_req_size;	/* maximum number of bytes in one req */

