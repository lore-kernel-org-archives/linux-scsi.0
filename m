Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD8D3BBEC;
	Thu, 28 Mar 2024 00:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711586694; cv=none; b=mF3HebdZI/cHapKnbOYC6G/y30WaKbYQ8bP/VbGSg6PdAVNvikLg5RPJynrjhg75ssqMZlj9ok1GbRM42CmnxEgY3/nNBpC+qv/P9Iqap06Ks511ODWYbeM8pn9gT6dNBBsEM79CyIDEU24yhDcRsdnk5NeLmKzsWA9GHe8dgdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711586694; c=relaxed/simple;
	bh=m3oUWLSIli6q56abreD7fZMa8Y3DnbI0ZjGhY4Oqd3w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouRmxQUrSym6As0YU38WtPY8KTNqkzL9IFpuEsjkoNs1qe6SfsThr45GKG41o1htQQw3OGQ69rn7WmL/s5mfsGrfzuAvVo/9nS20wWrTR2vzFwfBtH9AQpFYBIZf3SFdp11wAPvPtBWegkcGBDfdK7nny06crgCaaQl74lEaLFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kWaeTg/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kWaeTg/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74560C433F1;
	Thu, 28 Mar 2024 00:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711586693;
	bh=m3oUWLSIli6q56abreD7fZMa8Y3DnbI0ZjGhY4Oqd3w=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kWaeTg/hvDrUNgH9c4K2S6u72LFSXiIwysk58BrdTlp0vFUiS7+ziQWxqbqUuRuk8
	 +STtFmFPCgEU2iaM+thD6z1+NgZbdvb6Qb+yZQQr0cKXnN+JAnvFSMX461VIv8Xa8e
	 8RvwmUqxVlV+SBSmVYiKFKqSOBqcja5TSLC+DMECW538zajhpdKTPUJWRIxmqJwziw
	 x3xgSQU++DGQuQQUwnQ7QRLxNgIukTGlo+PlYOEmU0WKY0kvNpKX3e+vjocC7xwTFF
	 yN/7HGlV+/P874HQXltXFl6WHjKZaT29fdv6SvNMbbAlsF6erTraKlkKu4piAxLGpH
	 th9k4+eT5iXuw==
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
Subject: [PATCH v3 24/30] block: Remove elevator required features
Date: Thu, 28 Mar 2024 09:44:03 +0900
Message-ID: <20240328004409.594888-25-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328004409.594888-1-dlemoal@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
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
---
 block/blk-settings.c   | 16 ---------------
 block/elevator.c       | 46 +++++-------------------------------------
 block/elevator.h       |  1 -
 include/linux/blkdev.h | 10 ---------
 4 files changed, 5 insertions(+), 68 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 82c61d2e4bb8..31d882ac72d4 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -1053,22 +1053,6 @@ void blk_queue_write_cache(struct request_queue *q, bool wc, bool fua)
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
index d93005ca59e8..8798435d22c4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -454,8 +454,6 @@ struct request_queue {
 
 	atomic_t		nr_active_requests_shared_tags;
 
-	unsigned int		required_elevator_features;
-
 	struct blk_mq_tags	*sched_shared_tags;
 
 	struct list_head	icq_list;
@@ -960,14 +958,6 @@ disk_alloc_independent_access_ranges(struct gendisk *disk, int nr_ia_ranges);
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

