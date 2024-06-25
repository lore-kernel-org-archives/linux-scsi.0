Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F29172BD4;
	Tue, 25 Jun 2024 15:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719327635; cv=none; b=fwSiMzhzjxw28GAuDFJx8dR4Neufk2v2v4pNBPGUWOsQ+5QwgsYPYS18bC4dx6O4ajLYJjXtE3HH5DF9w6XshQitVpci4WHhcH4WwasnGopP1U46QqwgWOjVm/USY+SXBjsTFea5cGpRdMDux0jtYsAFINu/+YDMiVvdcL06PS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719327635; c=relaxed/simple;
	bh=zVBP4Cu0/dpyRDGnoxj7Jux4WsGQKWo/gPMjOJoSirw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFFiX1feYjbhWPlZx7PHQOWMuL7Osoap9lXtjMxN/QU1zW3xJLCV7Dl2Ov3hoH4GO9CHlcRTHBDz6I7PUKkp7+DGcIPD7eZjRdnkjl0gi1j3j4xotPrgLcLVjpBzbolr0YtY89Al3TiiQb3CkqsoXdsXjgxq7dS+GiADEYk6F7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lI2qMqkG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lI2qMqkG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zRT1CYNvoO7tMNqGIj3uWkqCcX1V4Wx4UfwKk5yrZes=; b=lI2qMqkGdaGoEQCGWfQGrspK6A
	8et7sI2q4ssMClYCVxLKCagk8UgfXj3IFcJ9RYtPbPpwLISw2WL4IsLp9xnQ81p++VDnue/vcxTVX
	U/IYcMDZwLfjIfyvdrHnTwR/ZdpGw+Jb0eieJpmy4ckK6fs8K80xY5GlZx8t62ggcyRLujmFxgqQZ
	G86DbsfaJ9x9V/wftE/JL83TbBWQP7WjK2cI6D9KCCEr1xGFgee1es1D3pj+/i33N3etaD6doMGN/
	qx6DUVKHHJvwWpGCZ+6fFb7Ffems4tjRbT8BiANGV6lvWas+u+/9tKb1/XmfzAI8y96FO4d1hEAJk
	yLuz8fQg==;
Received: from [2001:4bb8:2c2:e897:e635:808f:2aad:e9c8] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sM7en-00000003IyZ-3Vo1;
	Tue, 25 Jun 2024 15:00:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 8/8] block: move dma_pad_mask into queue_limits
Date: Tue, 25 Jun 2024 16:59:53 +0200
Message-ID: <20240625145955.115252-9-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240625145955.115252-1-hch@lst.de>
References: <20240625145955.115252-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

dma_pad_mask is a queue_limits by all ways of looking at it, so move it
there and set it through the atomic queue limits APIs.

Add a little helper that takes the alignment and pad into account to
simply the code that is touched a bit.

Note that there never was any need for the > check in
blk_queue_update_dma_pad, this probably was just copy and paste from
dma_update_dma_alignment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity.c     |  2 +-
 block/blk-map.c           |  2 +-
 block/blk-settings.c      | 17 -----------------
 drivers/ata/libata-scsi.c |  3 +--
 drivers/ata/pata_macio.c  |  4 ++--
 drivers/scsi/scsi_lib.c   |  4 ++--
 drivers/ufs/core/ufshcd.c |  9 +++++----
 include/linux/blkdev.h    | 12 ++++++++----
 8 files changed, 20 insertions(+), 33 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 173ffd4d623788..356ca0d3d62f5a 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -312,7 +312,7 @@ int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes,
 			   u32 seed)
 {
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-	unsigned int align = q->dma_pad_mask | queue_dma_alignment(q);
+	unsigned int align = blk_lim_dma_alignment_and_pad(&q->limits);
 	struct page *stack_pages[UIO_FASTIOV], **pages = stack_pages;
 	struct bio_vec stack_vec[UIO_FASTIOV], *bvec = stack_vec;
 	unsigned int direction, nr_bvecs;
diff --git a/block/blk-map.c b/block/blk-map.c
index 71210cdb34426d..bce144091128f6 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -634,7 +634,7 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 			const struct iov_iter *iter, gfp_t gfp_mask)
 {
 	bool copy = false, map_bvec = false;
-	unsigned long align = q->dma_pad_mask | queue_dma_alignment(q);
+	unsigned long align = blk_lim_dma_alignment_and_pad(&q->limits);
 	struct bio *bio = NULL;
 	struct iov_iter i;
 	int ret = -EINVAL;
diff --git a/block/blk-settings.c b/block/blk-settings.c
index c692e80bb4f890..2e559cf97cc834 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -768,23 +768,6 @@ bool queue_limits_stack_integrity(struct queue_limits *t,
 }
 EXPORT_SYMBOL_GPL(queue_limits_stack_integrity);
 
-/**
- * blk_queue_update_dma_pad - update pad mask
- * @q:     the request queue for the device
- * @mask:  pad mask
- *
- * Update dma pad mask.
- *
- * Appending pad buffer to a request modifies the last entry of a
- * scatter list such that it includes the pad buffer.
- **/
-void blk_queue_update_dma_pad(struct request_queue *q, unsigned int mask)
-{
-	if (mask > q->dma_pad_mask)
-		q->dma_pad_mask = mask;
-}
-EXPORT_SYMBOL(blk_queue_update_dma_pad);
-
 /**
  * blk_set_queue_depth - tell the block layer about the device queue depth
  * @q:		the request queue for the device
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index cdf29b178ddc1e..682971c4cbe418 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1024,7 +1024,6 @@ EXPORT_SYMBOL_GPL(ata_scsi_dma_need_drain);
 int ata_scsi_dev_config(struct scsi_device *sdev, struct queue_limits *lim,
 		struct ata_device *dev)
 {
-	struct request_queue *q = sdev->request_queue;
 	int depth = 1;
 
 	if (!ata_id_has_unload(dev->id))
@@ -1038,7 +1037,7 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct queue_limits *lim,
 		sdev->sector_size = ATA_SECT_SIZE;
 
 		/* set DMA padding */
-		blk_queue_update_dma_pad(q, ATA_DMA_PAD_SZ - 1);
+		lim->dma_pad_mask = ATA_DMA_PAD_SZ - 1;
 
 		/* make room for appending the drain */
 		lim->max_segments--;
diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index 3cb455a32d9266..1b85e8bf4ef91b 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -816,7 +816,7 @@ static int pata_macio_device_configure(struct scsi_device *sdev,
 	/* OHare has issues with non cache aligned DMA on some chipsets */
 	if (priv->kind == controller_ohare) {
 		lim->dma_alignment = 31;
-		blk_queue_update_dma_pad(sdev->request_queue, 31);
+		lim->dma_pad_mask = 31;
 
 		/* Tell the world about it */
 		ata_dev_info(dev, "OHare alignment limits applied\n");
@@ -831,7 +831,7 @@ static int pata_macio_device_configure(struct scsi_device *sdev,
 	if (priv->kind == controller_sh_ata6 || priv->kind == controller_k2_ata6) {
 		/* Allright these are bad, apply restrictions */
 		lim->dma_alignment = 15;
-		blk_queue_update_dma_pad(sdev->request_queue, 15);
+		lim->dma_pad_mask = 15;
 
 		/* We enable MWI and hack cache line size directly here, this
 		 * is specific to this chipset and not normal values, we happen
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e2f7bfb2b9e450..3958a6d14bf457 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1139,9 +1139,9 @@ blk_status_t scsi_alloc_sgtables(struct scsi_cmnd *cmd)
 	 */
 	count = __blk_rq_map_sg(rq->q, rq, cmd->sdb.table.sgl, &last_sg);
 
-	if (blk_rq_bytes(rq) & rq->q->dma_pad_mask) {
+	if (blk_rq_bytes(rq) & rq->q->limits.dma_pad_mask) {
 		unsigned int pad_len =
-			(rq->q->dma_pad_mask & ~blk_rq_bytes(rq)) + 1;
+			(rq->q->limits.dma_pad_mask & ~blk_rq_bytes(rq)) + 1;
 
 		last_sg->length += pad_len;
 		cmd->extra_len += pad_len;
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0cf07194bbe89d..62d20eef13537d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5193,17 +5193,18 @@ static int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth)
 }
 
 /**
- * ufshcd_slave_configure - adjust SCSI device configurations
+ * ufshcd_device_configure - adjust SCSI device configurations
  * @sdev: pointer to SCSI device
  *
  * Return: 0 (success).
  */
-static int ufshcd_slave_configure(struct scsi_device *sdev)
+static int ufshcd_device_configure(struct scsi_device *sdev,
+		struct queue_limits *lim)
 {
 	struct ufs_hba *hba = shost_priv(sdev->host);
 	struct request_queue *q = sdev->request_queue;
 
-	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
+	lim->dma_pad_mask = PRDT_DATA_BYTE_COUNT_PAD - 1;
 
 	/*
 	 * Block runtime-pm until all consumers are added.
@@ -8907,7 +8908,7 @@ static const struct scsi_host_template ufshcd_driver_template = {
 	.queuecommand		= ufshcd_queuecommand,
 	.mq_poll		= ufshcd_poll,
 	.slave_alloc		= ufshcd_slave_alloc,
-	.slave_configure	= ufshcd_slave_configure,
+	.device_configure	= ufshcd_device_configure,
 	.slave_destroy		= ufshcd_slave_destroy,
 	.change_queue_depth	= ufshcd_change_queue_depth,
 	.eh_abort_handler	= ufshcd_abort,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 94fcbc91231208..a53e3434e1a28c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -401,6 +401,7 @@ struct queue_limits {
 	 * due to possible offsets.
 	 */
 	unsigned int		dma_alignment;
+	unsigned int		dma_pad_mask;
 
 	struct blk_integrity	integrity;
 };
@@ -509,8 +510,6 @@ struct request_queue {
 	 */
 	int			id;
 
-	unsigned int		dma_pad_mask;
-
 	/*
 	 * queue settings
 	 */
@@ -981,7 +980,6 @@ extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			    sector_t offset);
 void queue_limits_stack_bdev(struct queue_limits *t, struct block_device *bdev,
 		sector_t offset, const char *pfx);
-extern void blk_queue_update_dma_pad(struct request_queue *, unsigned int);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 
 struct blk_independent_access_ranges *
@@ -1433,10 +1431,16 @@ static inline bool bdev_iter_is_aligned(struct block_device *bdev,
 				   bdev_logical_block_size(bdev) - 1);
 }
 
+static inline int blk_lim_dma_alignment_and_pad(struct queue_limits *lim)
+{
+	return lim->dma_alignment | lim->dma_pad_mask;
+}
+
 static inline int blk_rq_aligned(struct request_queue *q, unsigned long addr,
 				 unsigned int len)
 {
-	unsigned int alignment = queue_dma_alignment(q) | q->dma_pad_mask;
+	unsigned int alignment = blk_lim_dma_alignment_and_pad(&q->limits);
+
 	return !(addr & alignment) && !(len & alignment);
 }
 
-- 
2.43.0

