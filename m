Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490921F2384;
	Wed,  8 Jan 2025 09:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736328336; cv=none; b=d674HN3xyx1pswJtvgupbnK02qaIFmC1DFnDhDKH/WJOrnUiWDxZ9RH1jsCA+IFQZCi4aY2XMxQcKSXv+KeWBvIaPvXQ9C0OY21bzpBBf4RcKFbymJLKYahGfKp+sG/p6kssUfg9JmGycmi5gJ4rPVaiu+aLqiU54zb03rxsTkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736328336; c=relaxed/simple;
	bh=QpVRRNg1RcHCuUC4I0sll4KGd2gb9Xo5EKSV8CdL5HU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyf4ckAoIQYhPtdDUbUT5SW6jE0f0DHhc4Fpg0j+93Pr3kBhofPy2RG5q76m6o0E9x18qYNScXqnN2kr/Qak5y3s+3NPEx/4sqJQoestrH0LCB7E7uNusJgwxlhpBXwUEfKzFG0Re7mNTZTC5CrzapQA/4NJzRrBJ1PIwdXMfv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KWYgDPv3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KWYgDPv3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=LwJvUGOXy4RYeN1gInyDZ8xq1wnoFuIWs4w04cPwF5g=; b=KWYgDPv32bxwbsX2TNHy4e25Mn
	a2aPoHC7xtHGYbuPYtnEkjdheE29Oe5ggTj0WFLrdUtJVIolP6PZBfuZWL4D+MsLabwzKzCKHi4ae
	5tLB04a7EmXzEsHTnweX9/fpRZ1sBaCN2zRhlI/KifILKPJuc1YY1nEcI0ZgGoFNKxF60bdeHPwwx
	7yYGv4xUIpUc8od002+uHftudldNtZWg+7LHYRpnWihwi5UThcJ/EV9MXp2DA8zVAkkRUmV86kWG6
	rnSLBRN9fLa2DBfhf7L1EYY+rmKqaxTPGcQh+tdLtoHQN/2ECglmebOTCTc9cConoeUh5urQuZxgk
	yePVUnIw==;
Received: from 2a02-8389-2341-5b80-e44b-b36a-6403-8f06.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:e44b:b36a:6403:8f06] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tVSJh-00000007lU3-2wLx;
	Wed, 08 Jan 2025 09:25:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	nbd@other.debian.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 03/10] block: don't update BLK_FEAT_POLL in __blk_mq_update_nr_hw_queues
Date: Wed,  8 Jan 2025 10:25:00 +0100
Message-ID: <20250108092520.1325324-4-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250108092520.1325324-1-hch@lst.de>
References: <20250108092520.1325324-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When __blk_mq_update_nr_hw_queues changes the number of tag sets, it
might have to disable poll queues.  Currently it does so by adjusting
the BLK_FEAT_POLL, which is a bit against the intent of features that
describe hardware / driver capabilities, but more importantly causes
nasty lock order problems with the broadly held freeze when updating the
number of hardware queues and the limits lock.  Fix this by leaving
BLK_FEAT_POLL alone, and instead check for the number of poll queues in
the bio submission and poll handlers.  While this adds extra work to the
fast path, the variables are in cache lines used by these operations
anyway, so it should be cheap enough.

Fixes: 8023e144f9d6 ("block: move the poll flag to queue_limits")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c  | 17 ++++++++++++++---
 block/blk-mq.c    | 17 +----------------
 block/blk-sysfs.c |  6 +++++-
 block/blk.h       |  1 +
 4 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 666efe8fa202..4fb495d25c85 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -753,6 +753,18 @@ static blk_status_t blk_validate_atomic_write_op_size(struct request_queue *q,
 	return BLK_STS_OK;
 }
 
+inline bool bdev_can_poll(struct block_device *bdev)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	if (!(q->limits.features & BLK_FEAT_POLL))
+		return false;
+
+	if (queue_is_mq(q))
+		return q->tag_set->map[HCTX_TYPE_POLL].nr_queues;
+	return true;
+}
+
 /**
  * submit_bio_noacct - re-submit a bio to the block device layer for I/O
  * @bio:  The bio describing the location in memory and on the device.
@@ -805,8 +817,7 @@ void submit_bio_noacct(struct bio *bio)
 		}
 	}
 
-	if (!(q->limits.features & BLK_FEAT_POLL) &&
-			(bio->bi_opf & REQ_POLLED)) {
+	if ((bio->bi_opf & REQ_POLLED) && !bdev_can_poll(bdev)) {
 		bio_clear_polled(bio);
 		goto not_supported;
 	}
@@ -935,7 +946,7 @@ int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags)
 		return 0;
 
 	q = bdev_get_queue(bdev);
-	if (cookie == BLK_QC_T_NONE || !(q->limits.features & BLK_FEAT_POLL))
+	if (cookie == BLK_QC_T_NONE || !bdev_can_poll(bdev))
 		return 0;
 
 	blk_flush_plug(current->plug, false);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2e6132f778fd..f795d81b6b38 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4320,12 +4320,6 @@ void blk_mq_release(struct request_queue *q)
 	blk_mq_sysfs_deinit(q);
 }
 
-static bool blk_mq_can_poll(struct blk_mq_tag_set *set)
-{
-	return set->nr_maps > HCTX_TYPE_POLL &&
-		set->map[HCTX_TYPE_POLL].nr_queues;
-}
-
 struct request_queue *blk_mq_alloc_queue(struct blk_mq_tag_set *set,
 		struct queue_limits *lim, void *queuedata)
 {
@@ -4336,7 +4330,7 @@ struct request_queue *blk_mq_alloc_queue(struct blk_mq_tag_set *set,
 	if (!lim)
 		lim = &default_lim;
 	lim->features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT;
-	if (blk_mq_can_poll(set))
+	if (set->nr_maps > HCTX_TYPE_POLL)
 		lim->features |= BLK_FEAT_POLL;
 
 	q = blk_alloc_queue(lim, set->numa_node);
@@ -5024,8 +5018,6 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 fallback:
 	blk_mq_update_queue_map(set);
 	list_for_each_entry(q, &set->tag_list, tag_set_list) {
-		struct queue_limits lim;
-
 		blk_mq_realloc_hw_ctxs(set, q);
 
 		if (q->nr_hw_queues != set->nr_hw_queues) {
@@ -5039,13 +5031,6 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 			set->nr_hw_queues = prev_nr_hw_queues;
 			goto fallback;
 		}
-		lim = queue_limits_start_update(q);
-		if (blk_mq_can_poll(set))
-			lim.features |= BLK_FEAT_POLL;
-		else
-			lim.features &= ~BLK_FEAT_POLL;
-		if (queue_limits_commit_update(q, &lim) < 0)
-			pr_warn("updating the poll flag failed\n");
 		blk_mq_map_swqueue(q);
 	}
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 767598e719ab..54488af6c001 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -245,10 +245,14 @@ static ssize_t queue_##_name##_show(struct gendisk *disk, char *page)	\
 		!!(disk->queue->limits.features & _feature));		\
 }
 
-QUEUE_SYSFS_FEATURE_SHOW(poll, BLK_FEAT_POLL);
 QUEUE_SYSFS_FEATURE_SHOW(fua, BLK_FEAT_FUA);
 QUEUE_SYSFS_FEATURE_SHOW(dax, BLK_FEAT_DAX);
 
+static ssize_t queue_poll_show(struct gendisk *disk, char *page)
+{
+	return sysfs_emit(page, "%u\n", bdev_can_poll(disk->part0));
+}
+
 static ssize_t queue_zoned_show(struct gendisk *disk, char *page)
 {
 	if (blk_queue_is_zoned(disk->queue))
diff --git a/block/blk.h b/block/blk.h
index 4904b86d5fec..c8fdbb22d483 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -589,6 +589,7 @@ int truncate_bdev_range(struct block_device *bdev, blk_mode_t mode,
 long blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
 int blkdev_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
 long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
+bool bdev_can_poll(struct block_device *bdev);
 
 extern const struct address_space_operations def_blk_aops;
 
-- 
2.45.2

