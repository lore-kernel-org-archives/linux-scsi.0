Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68191C1975A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40D352467D
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JdPtfQR9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgCJJrP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 05:47:15 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:26501 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgCJJrP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 05:47:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583833637; x=1615369637;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yfpOi5iezkjuZIH6uqNUd0CVBezoyulmwxer0C/fB/Q=;
  b=JdPtfQR9Y7cN6FhdsJ7hiXi6tMh5lEb4v7ZGGCuBu+ybOkoA0Y5/0sLJ
   vlytwLgxOISRGHz+0Lu5RinDxrYkDAUml5a9qq6u9yuu0SYjJY5TzmDhk
   gB9Rusk/IRYP4/7ZwM4mYvkKAwgk8ZZAc3NjmAP+wu3l0JnTc25gGmACu
   K9DqkSDHv/He015uVMyJ0Xw1AQZ6EujKlhKKZctjxsso8AdJRHt4GSXx4
   zE8+o1tiPyplRxu78hY+Kf1eIlCpgyOL4ZoQIq5dEhvZaj5ixR6lw9dKJ
   ovuQfaibc30uUwJO2ekn0K3+ePLXy5cLT1TYHA+6JSFYr4qysHVnTsRTE
   A==;
IronPort-SDR: OWdGXEeCKjnGpv3BU1om/QQN4EF7GBn8FaADFOXtXB7MNd14rUqsA5foP/aQ5gZnDAkn/pvItQ
 yJhgMghyvv+FfaU0FEZCAok9Q0vI+s2TKsv+zfIDK/jAsTWq0Taix0LVeAEOQy7qRBe5LGmTWd
 0H7hmka2+NHYf0FlwfOizSBCj4S4kjXfeK1o22T5oU4YDc0/Taq3XJMUHe+Z7d2E5BmrxYem8S
 W1RuQEWGhCLFOmHor5GkVKRjbhTEMzG+k24Itf2cfEu2TJO9pSA8N3qVg8fZ3mHN/tWR2TyfUr
 wdA=
X-IronPort-AV: E=Sophos;i="5.70,536,1574092800"; 
   d="scan'208";a="234082777"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2020 17:47:17 +0800
IronPort-SDR: 6zFFAWiAs/XMpx8m5fgF8Lhd2jX+WvN8+KaWI0XpAuzU4B4teE949gTo1BTfXMyGRgZMcXRkOn
 /Dj5GrhsISZWN0p2sn82UJZX2Ggrfmw3hS5lvGkEheembA06KbEL45HhXxmbKY0yKWtZ9LSiBN
 9dTt7LlQ61kLYsTPgQhWAmFuSlHhdH9F+cmaCyjOo6UujyJLfzLDzvttfk6ejxUNpdKKT5yJBs
 zc0xII+83Q5H+AAxyfAIUsyFI+6Fm0d3dx0hLVnnyz7jRpv8xgbf9abWCP1Rnxrrd2Yw6CzvlK
 VAhAhMhKnqlgqA6z/T9MayyI
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 02:38:55 -0700
IronPort-SDR: HXNIdmb3heDpCnK+zeBX+pRn2tQ1h2qQb2bGROr/ab2DYnJVGovJOO6mmaYWOTl7hE0V0btJ42
 83/wnjwVvZIQStxYl89ttaYYPCj/eVcBV8bToPka2I770V5zHjasSaeYna5p9eiJNstGBWRCh/
 NW1ZU76jByjuZBWXWkjHTzne4/J1Gs1SPd7X1P9CkUxP8Oq2Ww286Z7N4j2W06A870nVRNy6LO
 EetewwokJdyq1Zx4d1P0ElKpcgEUcEFaPP5XjU5GlzaH/qyrbKjdcBUyS+yNsgwKC1qAVHMO7C
 Jyg=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Mar 2020 02:47:13 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 02/11] block: Introduce REQ_OP_ZONE_APPEND
Date:   Tue, 10 Mar 2020 18:46:44 +0900
Message-Id: <20200310094653.33257-3-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Define REQ_OP_ZONE_APPEND to append-write sectors to a zone of a zoned
block device. This is a no-merge write operation.

A zone append write BIO must:
* Target a zoned block device
* Have a sector position indicating the start sector of the target zone
* The target zone must be a sequential write zone
* The BIO must not cross a zone boundary
* The BIO size must not be split to ensure that a single range of LBAs
  is written with a single command.

Implement these checks in generic_make_request_checks() using the
helper function blk_check_zone_append(). To avoid write append BIO
splitting, introduce the new max_zone_append_sectors queue limit
attribute and ensure that a BIO size is always lower than this limit.
Export this new limit through sysfs.

Finally, make sure that the bio sector position indicates the actual
write position as indicated by the device on completion.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/bio.c               |  4 ++++
 block/blk-core.c          | 49 +++++++++++++++++++++++++++++++++++++++
 block/blk-settings.c      | 16 +++++++++++++
 block/blk-sysfs.c         | 13 +++++++++++
 include/linux/bio.h       |  1 +
 include/linux/blk_types.h |  2 ++
 include/linux/blkdev.h    | 11 +++++++++
 7 files changed, 96 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 94d697217887..5bff80fc2ad9 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1895,6 +1895,10 @@ struct bio *bio_split(struct bio *bio, int sectors,
 	BUG_ON(sectors <= 0);
 	BUG_ON(sectors >= bio_sectors(bio));
 
+	/* Zone append commands cannot be split */
+	if (WARN_ON_ONCE(bio_op(bio) == REQ_OP_ZONE_APPEND))
+		return NULL;
+
 	split = bio_clone_fast(bio, gfp, bs);
 	if (!split)
 		return NULL;
diff --git a/block/blk-core.c b/block/blk-core.c
index 60dc9552ef8d..544c5a130ac5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -135,6 +135,7 @@ static const char *const blk_op_name[] = {
 	REQ_OP_NAME(ZONE_OPEN),
 	REQ_OP_NAME(ZONE_CLOSE),
 	REQ_OP_NAME(ZONE_FINISH),
+	REQ_OP_NAME(ZONE_APPEND),
 	REQ_OP_NAME(WRITE_SAME),
 	REQ_OP_NAME(WRITE_ZEROES),
 	REQ_OP_NAME(SCSI_IN),
@@ -239,6 +240,16 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 		bio_set_flag(bio, BIO_QUIET);
 
 	bio_advance(bio, nbytes);
+	if (req_op(rq) == REQ_OP_ZONE_APPEND && error == BLK_STS_OK) {
+		/*
+		 * Partial completions cannot be supported as the BIO
+		 * fragments may end up not being written sequentially.
+		 */
+		if (bio->bi_iter.bi_size)
+			bio->bi_status = BLK_STS_IOERR;
+		else
+			bio->bi_iter.bi_sector = rq->__sector;
+	}
 
 	/* don't actually finish bio if it's part of flush sequence */
 	if (bio->bi_iter.bi_size == 0 && !(rq->rq_flags & RQF_FLUSH_SEQ))
@@ -865,6 +876,39 @@ static inline int blk_partition_remap(struct bio *bio)
 	return ret;
 }
 
+/*
+ * Check write append to a zoned block device.
+ */
+static inline blk_status_t blk_check_zone_append(struct request_queue *q,
+						 struct bio *bio)
+{
+	sector_t pos = bio->bi_iter.bi_sector;
+	int nr_sectors = bio_sectors(bio);
+
+	/* Only applicable to zoned block devices */
+	if (!blk_queue_is_zoned(q))
+		return BLK_STS_NOTSUPP;
+
+	/* The bio sector must point to the start of a sequential zone */
+	if (pos & (blk_queue_zone_sectors(q) - 1) ||
+	    !blk_queue_zone_is_seq(q, pos))
+		return BLK_STS_IOERR;
+
+	/*
+	 * Not allowed to cross zone boundaries. Otherwise, the BIO will be
+	 * split and could result in non-contiguous sectors being written in
+	 * different zones.
+	 */
+	if (blk_queue_zone_no(q, pos) != blk_queue_zone_no(q, pos + nr_sectors))
+		return BLK_STS_IOERR;
+
+	/* Make sure the BIO is small enough and will not get split */
+	if (nr_sectors > q->limits.max_zone_append_sectors)
+		return BLK_STS_IOERR;
+
+	return BLK_STS_OK;
+}
+
 static noinline_for_stack bool
 generic_make_request_checks(struct bio *bio)
 {
@@ -937,6 +981,11 @@ generic_make_request_checks(struct bio *bio)
 		if (!q->limits.max_write_same_sectors)
 			goto not_supported;
 		break;
+	case REQ_OP_ZONE_APPEND:
+		status = blk_check_zone_append(q, bio);
+		if (status != BLK_STS_OK)
+			goto end_io;
+		break;
 	case REQ_OP_ZONE_RESET:
 	case REQ_OP_ZONE_OPEN:
 	case REQ_OP_ZONE_CLOSE:
diff --git a/block/blk-settings.c b/block/blk-settings.c
index c8eda2e7b91e..1345dbe5a245 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -48,6 +48,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->chunk_sectors = 0;
 	lim->max_write_same_sectors = 0;
 	lim->max_write_zeroes_sectors = 0;
+	lim->max_zone_append_sectors = 0;
 	lim->max_discard_sectors = 0;
 	lim->max_hw_discard_sectors = 0;
 	lim->discard_granularity = 0;
@@ -83,6 +84,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->max_dev_sectors = UINT_MAX;
 	lim->max_write_same_sectors = UINT_MAX;
 	lim->max_write_zeroes_sectors = UINT_MAX;
+	lim->max_zone_append_sectors = UINT_MAX;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
 
@@ -257,6 +259,18 @@ void blk_queue_max_write_zeroes_sectors(struct request_queue *q,
 }
 EXPORT_SYMBOL(blk_queue_max_write_zeroes_sectors);
 
+/**
+ * blk_queue_max_zone_append_sectors - set max sectors for a single zone append
+ * @q:  the request queue for the device
+ * @max_zone_append_sectors: maximum number of sectors to write per command
+ **/
+void blk_queue_max_zone_append_sectors(struct request_queue *q,
+		unsigned int max_zone_append_sectors)
+{
+	q->limits.max_zone_append_sectors = max_zone_append_sectors;
+}
+EXPORT_SYMBOL_GPL(blk_queue_max_zone_append_sectors);
+
 /**
  * blk_queue_max_segments - set max hw segments for a request for this queue
  * @q:  the request queue for the device
@@ -506,6 +520,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 					b->max_write_same_sectors);
 	t->max_write_zeroes_sectors = min(t->max_write_zeroes_sectors,
 					b->max_write_zeroes_sectors);
+	t->max_zone_append_sectors = min(t->max_zone_append_sectors,
+					b->max_zone_append_sectors);
 	t->bounce_pfn = min_not_zero(t->bounce_pfn, b->bounce_pfn);
 
 	t->seg_boundary_mask = min_not_zero(t->seg_boundary_mask,
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index fca9b158f4a0..02643e149d5e 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -218,6 +218,13 @@ static ssize_t queue_write_zeroes_max_show(struct request_queue *q, char *page)
 		(unsigned long long)q->limits.max_write_zeroes_sectors << 9);
 }
 
+static ssize_t queue_zone_append_max_show(struct request_queue *q, char *page)
+{
+	unsigned long long max_sectors = q->limits.max_zone_append_sectors;
+
+	return sprintf(page, "%llu\n", max_sectors << SECTOR_SHIFT);
+}
+
 static ssize_t
 queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 {
@@ -639,6 +646,11 @@ static struct queue_sysfs_entry queue_write_zeroes_max_entry = {
 	.show = queue_write_zeroes_max_show,
 };
 
+static struct queue_sysfs_entry queue_zone_append_max_entry = {
+	.attr = {.name = "zone_append_max_bytes", .mode = 0444 },
+	.show = queue_zone_append_max_show,
+};
+
 static struct queue_sysfs_entry queue_nonrot_entry = {
 	.attr = {.name = "rotational", .mode = 0644 },
 	.show = queue_show_nonrot,
@@ -749,6 +761,7 @@ static struct attribute *queue_attrs[] = {
 	&queue_discard_zeroes_data_entry.attr,
 	&queue_write_same_max_entry.attr,
 	&queue_write_zeroes_max_entry.attr,
+	&queue_zone_append_max_entry.attr,
 	&queue_nonrot_entry.attr,
 	&queue_zoned_entry.attr,
 	&queue_nr_zones_entry.attr,
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 853d92ceee64..ef640fd76c23 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -74,6 +74,7 @@ static inline bool bio_no_advance_iter(struct bio *bio)
 {
 	return bio_op(bio) == REQ_OP_DISCARD ||
 	       bio_op(bio) == REQ_OP_SECURE_ERASE ||
+	       bio_op(bio) == REQ_OP_ZONE_APPEND ||
 	       bio_op(bio) == REQ_OP_WRITE_SAME ||
 	       bio_op(bio) == REQ_OP_WRITE_ZEROES;
 }
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 70254ae11769..ae809f07aa27 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -296,6 +296,8 @@ enum req_opf {
 	REQ_OP_ZONE_CLOSE	= 11,
 	/* Transition a zone to full */
 	REQ_OP_ZONE_FINISH	= 12,
+	/* write data at the current zone write pointer */
+	REQ_OP_ZONE_APPEND	= 13,
 
 	/* SCSI passthrough using struct scsi_request */
 	REQ_OP_SCSI_IN		= 32,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 25b63f714619..36111b10d514 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -336,6 +336,7 @@ struct queue_limits {
 	unsigned int		max_hw_discard_sectors;
 	unsigned int		max_write_same_sectors;
 	unsigned int		max_write_zeroes_sectors;
+	unsigned int		max_zone_append_sectors;
 	unsigned int		discard_granularity;
 	unsigned int		discard_alignment;
 
@@ -757,6 +758,9 @@ static inline bool rq_mergeable(struct request *rq)
 	if (req_op(rq) == REQ_OP_WRITE_ZEROES)
 		return false;
 
+	if (req_op(rq) == REQ_OP_ZONE_APPEND)
+		return false;
+
 	if (rq->cmd_flags & REQ_NOMERGE_FLAGS)
 		return false;
 	if (rq->rq_flags & RQF_NOMERGE_FLAGS)
@@ -1088,6 +1092,8 @@ extern void blk_queue_max_write_same_sectors(struct request_queue *q,
 extern void blk_queue_max_write_zeroes_sectors(struct request_queue *q,
 		unsigned int max_write_same_sectors);
 extern void blk_queue_logical_block_size(struct request_queue *, unsigned int);
+extern void blk_queue_max_zone_append_sectors(struct request_queue *q,
+		unsigned int max_zone_append_sectors);
 extern void blk_queue_physical_block_size(struct request_queue *, unsigned int);
 extern void blk_queue_alignment_offset(struct request_queue *q,
 				       unsigned int alignment);
@@ -1301,6 +1307,11 @@ static inline unsigned int queue_max_segment_size(const struct request_queue *q)
 	return q->limits.max_segment_size;
 }
 
+static inline unsigned int queue_max_zone_append_sectors(const struct request_queue *q)
+{
+	return q->limits.max_zone_append_sectors;
+}
+
 static inline unsigned queue_logical_block_size(const struct request_queue *q)
 {
 	int retval = 512;
-- 
2.24.1

