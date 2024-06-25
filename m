Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71BB14AD23;
	Tue, 25 Jun 2024 15:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719327621; cv=none; b=Fd3+rD5iYrtir8NHIFu+lOr64rZCsNUqddM3A41waxcT1Vp3AqJPQjUethw4i8MMnC4u6bBiqj6aadYKblzZciUsOiZ6S82xB3E2MYyOj5Hg8cOO0J1Npq+GzZkevG7equ1Pb11Im2QXbXXuJbbvQcOGW9RjuCQAZe3Qd9U53yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719327621; c=relaxed/simple;
	bh=dBi9gC3DrQHkZ29StN7zA/gzYsF/K3gNg9PHu8xoYU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukBrp9dPZ7EIxNoFRw0aTbUDWa3Up2/cukqhm9lOuo8WP/9EPnp6+oWcv90/aTE6uiix9763hnYbYl4X7MbD+R5y0hn+LEZQIJPk2VbEddGjTL/4ryI4ydSs7nOoAbj2+roeI6I0KK/sGA8yz1t87nOCynoGyqPiZUj2x1xSoAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pm+h0Wtb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pm+h0Wtb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=R8mxb9YYIDG0XWhEgqFPtDzU2nRAEucTBtP/B7l4Maw=; b=pm+h0WtbB4ly2YChn7OSsWs4he
	ZMX3wFbYXHNVXwoRYkTgfj3J4CiBDrWWeWhawZflipuIwrXjfpW3y/Q/RxI9PLdu2IVHEFnQzUZO8
	gah6TtTI0foa80pdEji/4oofVd7yB4hogvUvd0yL5HFHuAnFtmF/YtijCaUH4aS3WZd53LdWbkWCs
	Zh+XG7Cocy5xnJsDLsuNfskYp3ABHcEpMgBHJvK6cE9VTR8jeX0SvyuHQC6MNQ8IXUfJzfkiwXFZ+
	cFORB/Kfv7XgtA5JU63DaCkJPVIqEZYRu2cmlRoygW7rostKxRAhkyEQ6peFmxGgX/cl3Yq4THOa8
	WxFzWtLw==;
Received: from [2001:4bb8:2c2:e897:e635:808f:2aad:e9c8] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sM7eZ-00000003Imh-2ZID;
	Tue, 25 Jun 2024 15:00:16 +0000
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
Subject: [PATCH 4/8] block: convert features and flags to __bitwise types
Date: Tue, 25 Jun 2024 16:59:49 +0200
Message-ID: <20240625145955.115252-5-hch@lst.de>
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

... and let sparse help us catch mismatches or abuses.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-sysfs.c      |  6 +--
 include/linux/blkdev.h | 85 +++++++++++++++++++++---------------------
 2 files changed, 46 insertions(+), 45 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 6db65886e7ed5a..2d033275da6ea4 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -288,7 +288,7 @@ static ssize_t queue_dma_alignment_show(struct request_queue *q, char *page)
 }
 
 static ssize_t queue_feature_store(struct request_queue *q, const char *page,
-		size_t count, unsigned int feature)
+		size_t count, blk_features_t feature)
 {
 	struct queue_limits lim;
 	unsigned long val;
@@ -418,7 +418,7 @@ static ssize_t queue_poll_delay_store(struct request_queue *q, const char *page,
 
 static ssize_t queue_poll_show(struct request_queue *q, char *page)
 {
-	return queue_var_show(q->limits.features & BLK_FEAT_POLL, page);
+	return queue_var_show(!!(q->limits.features & BLK_FEAT_POLL), page);
 }
 
 static ssize_t queue_poll_store(struct request_queue *q, const char *page,
@@ -493,7 +493,7 @@ static ssize_t queue_fua_show(struct request_queue *q, char *page)
 
 static ssize_t queue_dax_show(struct request_queue *q, char *page)
 {
-	return queue_var_show(blk_queue_dax(q), page);
+	return queue_var_show(!!blk_queue_dax(q), page);
 }
 
 #define QUEUE_RO_ENTRY(_prefix, _name)			\
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1a7e9d9c16d78b..b37826b350a2e3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -283,55 +283,56 @@ static inline bool blk_op_is_passthrough(blk_opf_t op)
 }
 
 /* flags set by the driver in queue_limits.features */
-enum {
-	/* supports a volatile write cache */
-	BLK_FEAT_WRITE_CACHE			= (1u << 0),
+typedef unsigned int __bitwise blk_features_t;
 
-	/* supports passing on the FUA bit */
-	BLK_FEAT_FUA				= (1u << 1),
+/* supports a volatile write cache */
+#define BLK_FEAT_WRITE_CACHE		((__force blk_features_t)(1u << 0))
 
-	/* rotational device (hard drive or floppy) */
-	BLK_FEAT_ROTATIONAL			= (1u << 2),
+/* supports passing on the FUA bit */
+#define BLK_FEAT_FUA			((__force blk_features_t)(1u << 1))
 
-	/* contributes to the random number pool */
-	BLK_FEAT_ADD_RANDOM			= (1u << 3),
+/* rotational device (hard drive or floppy) */
+#define BLK_FEAT_ROTATIONAL		((__force blk_features_t)(1u << 2))
 
-	/* do disk/partitions IO accounting */
-	BLK_FEAT_IO_STAT			= (1u << 4),
+/* contributes to the random number pool */
+#define BLK_FEAT_ADD_RANDOM		((__force blk_features_t)(1u << 3))
 
-	/* don't modify data until writeback is done */
-	BLK_FEAT_STABLE_WRITES			= (1u << 5),
+/* do disk/partitions IO accounting */
+#define BLK_FEAT_IO_STAT		((__force blk_features_t)(1u << 4))
 
-	/* always completes in submit context */
-	BLK_FEAT_SYNCHRONOUS			= (1u << 6),
+/* don't modify data until writeback is done */
+#define BLK_FEAT_STABLE_WRITES		((__force blk_features_t)(1u << 5))
 
-	/* supports REQ_NOWAIT */
-	BLK_FEAT_NOWAIT				= (1u << 7),
+/* always completes in submit context */
+#define BLK_FEAT_SYNCHRONOUS		((__force blk_features_t)(1u << 6))
 
-	/* supports DAX */
-	BLK_FEAT_DAX				= (1u << 8),
+/* supports REQ_NOWAIT */
+#define BLK_FEAT_NOWAIT			((__force blk_features_t)(1u << 7))
 
-	/* supports I/O polling */
-	BLK_FEAT_POLL				= (1u << 9),
+/* supports DAX */
+#define BLK_FEAT_DAX			((__force blk_features_t)(1u << 8))
 
-	/* is a zoned device */
-	BLK_FEAT_ZONED				= (1u << 10),
+/* supports I/O polling */
+#define BLK_FEAT_POLL			((__force blk_features_t)(1u << 9))
 
-	/* supports Zone Reset All */
-	BLK_FEAT_ZONE_RESETALL			= (1u << 11),
+/* is a zoned device */
+#define BLK_FEAT_ZONED			((__force blk_features_t)(1u << 10))
 
-	/* supports PCI(e) p2p requests */
-	BLK_FEAT_PCI_P2PDMA			= (1u << 12),
+/* supports Zone Reset All */
+#define BLK_FEAT_ZONE_RESETALL		((__force blk_features_t)(1u << 11))
 
-	/* skip this queue in blk_mq_(un)quiesce_tagset */
-	BLK_FEAT_SKIP_TAGSET_QUIESCE		= (1u << 13),
+/* supports PCI(e) p2p requests */
+#define BLK_FEAT_PCI_P2PDMA		((__force blk_features_t)(1u << 12))
 
-	/* bounce all highmem pages */
-	BLK_FEAT_BOUNCE_HIGH			= (1u << 14),
+/* skip this queue in blk_mq_(un)quiesce_tagset */
+#define BLK_FEAT_SKIP_TAGSET_QUIESCE	((__force blk_features_t)(1u << 13))
 
-	/* undocumented magic for bcache */
-	BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE	= (1u << 15),
-};
+/* bounce all highmem pages */
+#define BLK_FEAT_BOUNCE_HIGH		((__force blk_features_t)(1u << 14))
+
+/* undocumented magic for bcache */
+#define BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE \
+	((__force blk_features_t)(1u << 15))
 
 /*
  * Flags automatically inherited when stacking limits.
@@ -342,17 +343,17 @@ enum {
 	 BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE)
 
 /* internal flags in queue_limits.flags */
-enum {
-	/* do not send FLUSH/FUA commands despite advertising a write cache */
-	BLK_FLAG_WRITE_CACHE_DISABLED		= (1u << 0),
+typedef unsigned int __bitwise blk_flags_t;
 
-	/* I/O topology is misaligned */
-	BLK_FLAG_MISALIGNED			= (1u << 1),
-};
+/* do not send FLUSH/FUA commands despite advertising a write cache */
+#define BLK_FLAG_WRITE_CACHE_DISABLED	((__force blk_flags_t)(1u << 0))
+
+/* I/O topology is misaligned */
+#define BLK_FLAG_MISALIGNED		((__force blk_flags_t)(1u << 1))
 
 struct queue_limits {
-	unsigned int		features;
-	unsigned int		flags;
+	blk_features_t		features;
+	blk_flags_t		flags;
 	unsigned long		seg_boundary_mask;
 	unsigned long		virt_boundary_mask;
 
-- 
2.43.0

