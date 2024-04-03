Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1116D1AF;
	Wed,  3 Apr 2024 08:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712133805; cv=none; b=BZ3OhSxYbyjc29kTfaGjXbAoye/mEbP2blHHhlvxtcb1HZBhKmlEi3rj+5US0EYd9F+L++mAGhrjmEVE97MOvz1TIu8srgUVpADyVm7blhU76acoIWPNmT1nNcxvXhPBs70E6dHftCHg/So9WQIVUzq8+jPTvgx+LqDEepJMh2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712133805; c=relaxed/simple;
	bh=TXtaYLuJs9UaufwdB3NCWLtaNb7jImqjLmv+5VK4YLo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zp6LCeOSTMllWybF4DRv3sxIjdw9d7qWt22a5Nf1t9+P4qT2MSUJtPskjPbHHmi7rPYTExt8FlhIQ3ScZ2v/rTZKdivXbguPU08/nmy7QC7UYciJXHeXBP4jPBzJOxxNNrrtXM5FSddHi3V7pND92aeUa84WXbbYcrhjaDB8E1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ik0Munqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ik0Munqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEC3C433B1;
	Wed,  3 Apr 2024 08:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712133805;
	bh=TXtaYLuJs9UaufwdB3NCWLtaNb7jImqjLmv+5VK4YLo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Ik0Munqhs/Xj113EHa90elIQEUUp+Z3UktPsri6QXAvAUhi2VQX7S1IonNXbZWXeW
	 YzPvpVJAR7RULfR5lppYOVN5F1spffkzhMrcJvK00RcgsYdXKJbO4PMs2+clUgCRvJ
	 ZOry1C4KcjErTOON1pl7pGH9OFOBucgVHAEDj2hKeJf/LBqlOZPu+xpSwiQm5GpS8w
	 WBejUK2oPqw7RvkxDecWympeRVJI1Ewt4wpLXTrSeh2y6kB//dpheR2FLC9eELYb19
	 4NkdRIWRawrlviNkk7fPo0sxNar2ez1RcGxrbrGqbhGQ6uIohZJRIyJr3YSJ5fd+U+
	 66i/FTUvMCT3g==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v5 22/28] block: Remove elevator required features
Date: Wed,  3 Apr 2024 17:42:41 +0900
Message-ID: <20240403084247.856481-23-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403084247.856481-1-dlemoal@kernel.org>
References: <20240403084247.856481-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only elevator feature ever implemented is ELEVATOR_F_ZBD_SEQ_WRITE
for signaling that a scheduler implements zone write locking to tightly
control the dispatching order of write operations to zoned block
devices. With the removal of zone write locking support in mq-deadline
and the reliance of all block device drivers on the block layer zone
write plugging to control ordering of write operations to zones, the
elevator feature ELEVATOR_F_ZBD_SEQ_WRITE is completely unused.
Remove it, and also remove the now unused code for filtering the
possible schedulers for a block device based on required features.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-settings.c   | 16 ---------------
 block/elevator.c       | 46 +++++-------------------------------------
 block/elevator.h       |  1 -
 include/linux/blkdev.h | 10 ---------
 4 files changed, 5 insertions(+), 68 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index c0197e1e7485..715f4b6356c4 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -1052,22 +1052,6 @@ void blk_queue_write_cache(struct request_queue *q, bool wc, bool fua)
 }
 EXPORT_SYMBOL_GPL(blk_queue_write_cache);
 
-/**
- * blk_queue_required_elevator_features - Set a queue required elevator features
- * @q:		the request queue for the target device
- * @features:	Required elevator features OR'ed together
- *
- * Tell the block layer that for the device controlled through @q, only the
- * only elevators that can be used are those that implement at least the set of
- * features specified by @features.
- */
-void blk_queue_required_elevator_features(struct request_queue *q,
-					  unsigned int features)
-{
-	q->required_elevator_features = features;
-}
-EXPORT_SYMBOL_GPL(blk_queue_required_elevator_features);
-
 /**
  * blk_queue_can_use_dma_map_merging - configure queue for merging segments.
  * @q:		the request queue for the device
diff --git a/block/elevator.c b/block/elevator.c
index 5ff093cb3cf8..f64ebd726e58 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -83,13 +83,6 @@ bool elv_bio_merge_ok(struct request *rq, struct bio *bio)
 }
 EXPORT_SYMBOL(elv_bio_merge_ok);
 
-static inline bool elv_support_features(struct request_queue *q,
-		const struct elevator_type *e)
-{
-	return (q->required_elevator_features & e->elevator_features) ==
-		q->required_elevator_features;
-}
-
 /**
  * elevator_match - Check whether @e's name or alias matches @name
  * @e: Scheduler to test
@@ -120,7 +113,7 @@ static struct elevator_type *elevator_find_get(struct request_queue *q,
 
 	spin_lock(&elv_list_lock);
 	e = __elevator_find(name);
-	if (e && (!elv_support_features(q, e) || !elevator_tryget(e)))
+	if (e && (!elevator_tryget(e)))
 		e = NULL;
 	spin_unlock(&elv_list_lock);
 	return e;
@@ -580,34 +573,8 @@ static struct elevator_type *elevator_get_default(struct request_queue *q)
 }
 
 /*
- * Get the first elevator providing the features required by the request queue.
- * Default to "none" if no matching elevator is found.
- */
-static struct elevator_type *elevator_get_by_features(struct request_queue *q)
-{
-	struct elevator_type *e, *found = NULL;
-
-	spin_lock(&elv_list_lock);
-
-	list_for_each_entry(e, &elv_list, list) {
-		if (elv_support_features(q, e)) {
-			found = e;
-			break;
-		}
-	}
-
-	if (found && !elevator_tryget(found))
-		found = NULL;
-
-	spin_unlock(&elv_list_lock);
-	return found;
-}
-
-/*
- * For a device queue that has no required features, use the default elevator
- * settings. Otherwise, use the first elevator available matching the required
- * features. If no suitable elevator is find or if the chosen elevator
- * initialization fails, fall back to the "none" elevator (no elevator).
+ * Use the default elevator settings. If the chosen elevator initialization
+ * fails, fall back to the "none" elevator (no elevator).
  */
 void elevator_init_mq(struct request_queue *q)
 {
@@ -622,10 +589,7 @@ void elevator_init_mq(struct request_queue *q)
 	if (unlikely(q->elevator))
 		return;
 
-	if (!q->required_elevator_features)
-		e = elevator_get_default(q);
-	else
-		e = elevator_get_by_features(q);
+	e = elevator_get_default(q);
 	if (!e)
 		return;
 
@@ -781,7 +745,7 @@ ssize_t elv_iosched_show(struct request_queue *q, char *name)
 	list_for_each_entry(e, &elv_list, list) {
 		if (e == cur)
 			len += sprintf(name+len, "[%s] ", e->elevator_name);
-		else if (elv_support_features(q, e))
+		else
 			len += sprintf(name+len, "%s ", e->elevator_name);
 	}
 	spin_unlock(&elv_list_lock);
diff --git a/block/elevator.h b/block/elevator.h
index 7ca3d7b6ed82..e9a050a96e53 100644
--- a/block/elevator.h
+++ b/block/elevator.h
@@ -74,7 +74,6 @@ struct elevator_type
 	struct elv_fs_entry *elevator_attrs;
 	const char *elevator_name;
 	const char *elevator_alias;
-	const unsigned int elevator_features;
 	struct module *elevator_owner;
 #ifdef CONFIG_BLK_DEBUG_FS
 	const struct blk_mq_debugfs_attr *queue_debugfs_attrs;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 19f59e0e5f29..618d354ceb94 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -453,8 +453,6 @@ struct request_queue {
 
 	atomic_t		nr_active_requests_shared_tags;
 
-	unsigned int		required_elevator_features;
-
 	struct blk_mq_tags	*sched_shared_tags;
 
 	struct list_head	icq_list;
@@ -959,14 +957,6 @@ disk_alloc_independent_access_ranges(struct gendisk *disk, int nr_ia_ranges);
 void disk_set_independent_access_ranges(struct gendisk *disk,
 				struct blk_independent_access_ranges *iars);
 
-/*
- * Elevator features for blk_queue_required_elevator_features:
- */
-/* Supports zoned block devices sequential write constraint */
-#define ELEVATOR_F_ZBD_SEQ_WRITE	(1U << 0)
-
-extern void blk_queue_required_elevator_features(struct request_queue *q,
-						 unsigned int features);
 extern bool blk_queue_can_use_dma_map_merging(struct request_queue *q,
 					      struct device *dev);
 
-- 
2.44.0

