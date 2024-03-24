Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352192A65B3;
	Sun, 24 Mar 2024 23:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711324604; cv=none; b=Eodf7a8Yu/iA0Z/rcCEOmw2x2P8Zw9XjPqSORTBdio32vBIE3MpAYT9QjohNd0nIMzUlXagin5K4/g4xNDJk4JHRa6CEMlR4unNInDajUccrhl4H7Dl2HBeLpYDDWKMZH5OEmhvETlrCvTOyC1HsmZyj600BY9KmN+r6FU3toXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711324604; c=relaxed/simple;
	bh=4X5JDASsyVTqpZ1mOIk4YSbgd2kOuQOTKm1luQihzFY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dAu4A6cNbE6LNR2/nHQLvx/0gvJcsdYOPsxG/UOyWwQ0TT5Zqve2nipZA4h43ZH3grPuSpbyvdE5j8nZQLHxSB43oj7O4o6h1l4yiOB7pxI5gOx2ztImfffRDEI5z6lBN6JcG36QwsUhAuKp5+qS7H5tjwTOdgYB6DsBUgtzM1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AiAGPerO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AiAGPerO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8Ap781XzTEv6/N3Fz2uGluUK4bmcyE+i99tuUWvhx7k=; b=AiAGPerOJJbKRhNpuJsVUJbWmU
	YiCXZspsGoKuruGzkhXHiiyVNOI0Loafwt6J7055bgOgT1jWkIP3AlLWQCJzfIg5DEuQhyeElrsHh
	OUojqAL/iskl2rJR6f4LO0c6wQeTpj9lncLIYXijQOwKZ1TTLd69jX+0LnPqXUNDLZNDWpLyMfBH4
	0TUN7wXQwCDU7Dw7VjvYj4KhVtBPjRgM7rcf/vQAfFcA/AqookY3rH0oBWYMq7S5C0oVO3i58Jf2H
	0SoUGAFpU1+jYml+W1kBdGthgRKRmPFP+q0UdWjn2AhGHMe3nHBwmW18pDrUtn155JRbx1UolfBb0
	aB1fenLA==;
Received: from [210.13.83.2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roXhZ-0000000DzuH-28iC;
	Sun, 24 Mar 2024 23:56:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Brian King <brking@us.ibm.com>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	open-iscsi@googlegroups.com,
	megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-samsung-soc@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 23/23] block: remove now unused queue limits helpers
Date: Mon, 25 Mar 2024 07:54:48 +0800
Message-Id: <20240324235448.2039074-24-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240324235448.2039074-1-hch@lst.de>
References: <20240324235448.2039074-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c           | 245 ---------------------------------
 drivers/s390/block/dasd_eckd.c |   6 +-
 include/linux/blkdev.h         |  13 --
 include/linux/mmc/host.h       |   4 +-
 4 files changed, 5 insertions(+), 263 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index cdbaef159c4bc3..57cd1660815ec2 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -283,72 +283,6 @@ int queue_limits_set(struct request_queue *q, struct queue_limits *lim)
 }
 EXPORT_SYMBOL_GPL(queue_limits_set);
 
-/**
- * blk_queue_bounce_limit - set bounce buffer limit for queue
- * @q: the request queue for the device
- * @bounce: bounce limit to enforce
- *
- * Description:
- *    Force bouncing for ISA DMA ranges or highmem.
- *
- *    DEPRECATED, don't use in new code.
- **/
-void blk_queue_bounce_limit(struct request_queue *q, enum blk_bounce bounce)
-{
-	q->limits.bounce = bounce;
-}
-EXPORT_SYMBOL(blk_queue_bounce_limit);
-
-/**
- * blk_queue_max_hw_sectors - set max sectors for a request for this queue
- * @q:  the request queue for the device
- * @max_hw_sectors:  max hardware sectors in the usual 512b unit
- *
- * Description:
- *    Enables a low level driver to set a hard upper limit,
- *    max_hw_sectors, on the size of requests.  max_hw_sectors is set by
- *    the device driver based upon the capabilities of the I/O
- *    controller.
- *
- *    max_dev_sectors is a hard limit imposed by the storage device for
- *    READ/WRITE requests. It is set by the disk driver.
- *
- *    max_sectors is a soft limit imposed by the block layer for
- *    filesystem type requests.  This value can be overridden on a
- *    per-device basis in /sys/block/<device>/queue/max_sectors_kb.
- *    The soft limit can not exceed max_hw_sectors.
- **/
-void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_sectors)
-{
-	struct queue_limits *limits = &q->limits;
-	unsigned int max_sectors;
-
-	if ((max_hw_sectors << 9) < PAGE_SIZE) {
-		max_hw_sectors = 1 << (PAGE_SHIFT - 9);
-		pr_info("%s: set to minimum %u\n", __func__, max_hw_sectors);
-	}
-
-	max_hw_sectors = round_down(max_hw_sectors,
-				    limits->logical_block_size >> SECTOR_SHIFT);
-	limits->max_hw_sectors = max_hw_sectors;
-
-	max_sectors = min_not_zero(max_hw_sectors, limits->max_dev_sectors);
-
-	if (limits->max_user_sectors)
-		max_sectors = min(max_sectors, limits->max_user_sectors);
-	else
-		max_sectors = min(max_sectors, BLK_DEF_MAX_SECTORS_CAP);
-
-	max_sectors = round_down(max_sectors,
-				 limits->logical_block_size >> SECTOR_SHIFT);
-	limits->max_sectors = max_sectors;
-
-	if (!q->disk)
-		return;
-	q->disk->bdi->io_pages = max_sectors >> (PAGE_SHIFT - 9);
-}
-EXPORT_SYMBOL(blk_queue_max_hw_sectors);
-
 /**
  * blk_queue_chunk_sectors - set size of the chunk for this queue
  * @q:  the request queue for the device
@@ -435,65 +369,6 @@ void blk_queue_max_zone_append_sectors(struct request_queue *q,
 }
 EXPORT_SYMBOL_GPL(blk_queue_max_zone_append_sectors);
 
-/**
- * blk_queue_max_segments - set max hw segments for a request for this queue
- * @q:  the request queue for the device
- * @max_segments:  max number of segments
- *
- * Description:
- *    Enables a low level driver to set an upper limit on the number of
- *    hw data segments in a request.
- **/
-void blk_queue_max_segments(struct request_queue *q, unsigned short max_segments)
-{
-	if (!max_segments) {
-		max_segments = 1;
-		pr_info("%s: set to minimum %u\n", __func__, max_segments);
-	}
-
-	q->limits.max_segments = max_segments;
-}
-EXPORT_SYMBOL(blk_queue_max_segments);
-
-/**
- * blk_queue_max_discard_segments - set max segments for discard requests
- * @q:  the request queue for the device
- * @max_segments:  max number of segments
- *
- * Description:
- *    Enables a low level driver to set an upper limit on the number of
- *    segments in a discard request.
- **/
-void blk_queue_max_discard_segments(struct request_queue *q,
-		unsigned short max_segments)
-{
-	q->limits.max_discard_segments = max_segments;
-}
-EXPORT_SYMBOL_GPL(blk_queue_max_discard_segments);
-
-/**
- * blk_queue_max_segment_size - set max segment size for blk_rq_map_sg
- * @q:  the request queue for the device
- * @max_size:  max size of segment in bytes
- *
- * Description:
- *    Enables a low level driver to set an upper limit on the size of a
- *    coalesced segment
- **/
-void blk_queue_max_segment_size(struct request_queue *q, unsigned int max_size)
-{
-	if (max_size < PAGE_SIZE) {
-		max_size = PAGE_SIZE;
-		pr_info("%s: set to minimum %u\n", __func__, max_size);
-	}
-
-	/* see blk_queue_virt_boundary() for the explanation */
-	WARN_ON_ONCE(q->limits.virt_boundary_mask);
-
-	q->limits.max_segment_size = max_size;
-}
-EXPORT_SYMBOL(blk_queue_max_segment_size);
-
 /**
  * blk_queue_logical_block_size - set logical block size for the queue
  * @q:  the request queue for the device
@@ -660,29 +535,6 @@ void blk_limits_io_opt(struct queue_limits *limits, unsigned int opt)
 }
 EXPORT_SYMBOL(blk_limits_io_opt);
 
-/**
- * blk_queue_io_opt - set optimal request size for the queue
- * @q:	the request queue for the device
- * @opt:  optimal request size in bytes
- *
- * Description:
- *   Storage devices may report an optimal I/O size, which is the
- *   device's preferred unit for sustained I/O.  This is rarely reported
- *   for disk drives.  For RAID arrays it is usually the stripe width or
- *   the internal track size.  A properly aligned multiple of
- *   optimal_io_size is the preferred request size for workloads where
- *   sustained throughput is desired.
- */
-void blk_queue_io_opt(struct request_queue *q, unsigned int opt)
-{
-	blk_limits_io_opt(&q->limits, opt);
-	if (!q->disk)
-		return;
-	q->disk->bdi->ra_pages =
-		max(queue_io_opt(q) * 2 / PAGE_SIZE, VM_READAHEAD_PAGES);
-}
-EXPORT_SYMBOL(blk_queue_io_opt);
-
 static int queue_limit_alignment_offset(const struct queue_limits *lim,
 		sector_t sector)
 {
@@ -932,81 +784,6 @@ void blk_queue_update_dma_pad(struct request_queue *q, unsigned int mask)
 }
 EXPORT_SYMBOL(blk_queue_update_dma_pad);
 
-/**
- * blk_queue_segment_boundary - set boundary rules for segment merging
- * @q:  the request queue for the device
- * @mask:  the memory boundary mask
- **/
-void blk_queue_segment_boundary(struct request_queue *q, unsigned long mask)
-{
-	if (mask < PAGE_SIZE - 1) {
-		mask = PAGE_SIZE - 1;
-		pr_info("%s: set to minimum %lx\n", __func__, mask);
-	}
-
-	q->limits.seg_boundary_mask = mask;
-}
-EXPORT_SYMBOL(blk_queue_segment_boundary);
-
-/**
- * blk_queue_virt_boundary - set boundary rules for bio merging
- * @q:  the request queue for the device
- * @mask:  the memory boundary mask
- **/
-void blk_queue_virt_boundary(struct request_queue *q, unsigned long mask)
-{
-	q->limits.virt_boundary_mask = mask;
-
-	/*
-	 * Devices that require a virtual boundary do not support scatter/gather
-	 * I/O natively, but instead require a descriptor list entry for each
-	 * page (which might not be idential to the Linux PAGE_SIZE).  Because
-	 * of that they are not limited by our notion of "segment size".
-	 */
-	if (mask)
-		q->limits.max_segment_size = UINT_MAX;
-}
-EXPORT_SYMBOL(blk_queue_virt_boundary);
-
-/**
- * blk_queue_dma_alignment - set dma length and memory alignment
- * @q:     the request queue for the device
- * @mask:  alignment mask
- *
- * description:
- *    set required memory and length alignment for direct dma transactions.
- *    this is used when building direct io requests for the queue.
- *
- **/
-void blk_queue_dma_alignment(struct request_queue *q, int mask)
-{
-	q->limits.dma_alignment = mask;
-}
-EXPORT_SYMBOL(blk_queue_dma_alignment);
-
-/**
- * blk_queue_update_dma_alignment - update dma length and memory alignment
- * @q:     the request queue for the device
- * @mask:  alignment mask
- *
- * description:
- *    update required memory and length alignment for direct dma transactions.
- *    If the requested alignment is larger than the current alignment, then
- *    the current queue alignment is updated to the new value, otherwise it
- *    is left alone.  The design of this is to allow multiple objects
- *    (driver, device, transport etc) to set their respective
- *    alignments without having them interfere.
- *
- **/
-void blk_queue_update_dma_alignment(struct request_queue *q, int mask)
-{
-	BUG_ON(mask > PAGE_SIZE);
-
-	if (mask > q->limits.dma_alignment)
-		q->limits.dma_alignment = mask;
-}
-EXPORT_SYMBOL(blk_queue_update_dma_alignment);
-
 /**
  * blk_set_queue_depth - tell the block layer about the device queue depth
  * @q:		the request queue for the device
@@ -1060,28 +837,6 @@ void blk_queue_required_elevator_features(struct request_queue *q,
 }
 EXPORT_SYMBOL_GPL(blk_queue_required_elevator_features);
 
-/**
- * blk_queue_can_use_dma_map_merging - configure queue for merging segments.
- * @q:		the request queue for the device
- * @dev:	the device pointer for dma
- *
- * Tell the block layer about merging the segments by dma map of @q.
- */
-bool blk_queue_can_use_dma_map_merging(struct request_queue *q,
-				       struct device *dev)
-{
-	unsigned long boundary = dma_get_merge_boundary(dev);
-
-	if (!boundary)
-		return false;
-
-	/* No need to update max_segment_size. see blk_queue_virt_boundary() */
-	blk_queue_virt_boundary(q, boundary);
-
-	return true;
-}
-EXPORT_SYMBOL_GPL(blk_queue_can_use_dma_map_merging);
-
 /**
  * disk_set_zoned - inidicate a zoned device
  * @disk:	gendisk to configure
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 180a008d38eaaf..2f16f543079b4f 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -4561,9 +4561,9 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 	len_to_track_end = 0;
 	/*
 	 * A tidaw can address 4k of memory, but must not cross page boundaries
-	 * We can let the block layer handle this by setting
-	 * blk_queue_segment_boundary to page boundaries and
-	 * blk_max_segment_size to page size when setting up the request queue.
+	 * We can let the block layer handle this by setting seg_boundary_mask
+	 * to page boundaries and max_segment_size to page size when setting up
+	 * the request queue.
 	 * For write requests, a TIDAW must not cross track boundaries, because
 	 * we have to set the CBC flag on the last tidaw for each track.
 	 */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c3e8f7cf96be9e..7a1e96c5bb1106 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -895,15 +895,9 @@ int queue_limits_set(struct request_queue *q, struct queue_limits *lim);
 /*
  * Access functions for manipulating queue properties
  */
-void blk_queue_bounce_limit(struct request_queue *q, enum blk_bounce limit);
-extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_chunk_sectors(struct request_queue *, unsigned int);
-extern void blk_queue_max_segments(struct request_queue *, unsigned short);
-extern void blk_queue_max_discard_segments(struct request_queue *,
-		unsigned short);
 void blk_queue_max_secure_erase_sectors(struct request_queue *q,
 		unsigned int max_sectors);
-extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
 extern void blk_queue_max_discard_sectors(struct request_queue *q,
 		unsigned int max_discard_sectors);
 extern void blk_queue_max_write_zeroes_sectors(struct request_queue *q,
@@ -920,7 +914,6 @@ void disk_update_readahead(struct gendisk *disk);
 extern void blk_limits_io_min(struct queue_limits *limits, unsigned int min);
 extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
 extern void blk_limits_io_opt(struct queue_limits *limits, unsigned int opt);
-extern void blk_queue_io_opt(struct request_queue *q, unsigned int opt);
 extern void blk_set_queue_depth(struct request_queue *q, unsigned int depth);
 extern void blk_set_stacking_limits(struct queue_limits *lim);
 extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
@@ -928,10 +921,6 @@ extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 void queue_limits_stack_bdev(struct queue_limits *t, struct block_device *bdev,
 		sector_t offset, const char *pfx);
 extern void blk_queue_update_dma_pad(struct request_queue *, unsigned int);
-extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
-extern void blk_queue_virt_boundary(struct request_queue *, unsigned long);
-extern void blk_queue_dma_alignment(struct request_queue *, int);
-extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern void blk_queue_write_cache(struct request_queue *q, bool enabled, bool fua);
 
@@ -948,8 +937,6 @@ void disk_set_independent_access_ranges(struct gendisk *disk,
 
 extern void blk_queue_required_elevator_features(struct request_queue *q,
 						 unsigned int features);
-extern bool blk_queue_can_use_dma_map_merging(struct request_queue *q,
-					      struct device *dev);
 
 bool __must_check blk_get_queue(struct request_queue *);
 extern void blk_put_queue(struct request_queue *);
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 5894bf912f7bdb..88c6a76042ee73 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -433,8 +433,8 @@ struct mmc_host {
 	mmc_pm_flag_t		pm_caps;	/* supported pm features */
 
 	/* host specific block data */
-	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
-	unsigned short		max_segs;	/* see blk_queue_max_segments */
+	unsigned int		max_seg_size;	/* lim->max_segment_size */
+	unsigned short		max_segs;	/* lim->max_segments */
 	unsigned short		unused;
 	unsigned int		max_req_size;	/* maximum number of bytes in one req */
 	unsigned int		max_blk_size;	/* maximum size of one mmc block */
-- 
2.39.2

