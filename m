Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8D842AB7;
	Fri,  2 Feb 2024 07:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859096; cv=none; b=BHig5Fioubjd1fq/o97qXjhj4ASmvSKi9wBo+sBTqsfUH9pXXvlj1QyUlViQ6aATSB6hVen+UXyu2wOFaa4oxuRDTYOWXrjqGF4LejjJOHJhCHlYrs+ZECIm3OgddKdrttOtbGcvoPvqJzVBMT4B7DHyltMAevPoHSengWEzQi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859096; c=relaxed/simple;
	bh=fofUUcc8wQ9qUnO4/3RCDmwbVSj5ASsNnOYNGT2KGL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLPn21pGbXq63v822Kd3eQYXKfLeW4SJeN72DNJLGjnO5akq0vBoFcbDsp+7QpmBIwQcIjmcJxCQvn7+GoxvYcrHkJFe0saXM5G8FwA2INZynJhieqmXNoSDoguf6Jf+z8c1C3reg7ObtH/nsdUD+eh0zB6bFX0GlaXYCjxJR1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jRdtJ1f9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jRdtJ1f9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB471C433F1;
	Fri,  2 Feb 2024 07:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859095;
	bh=fofUUcc8wQ9qUnO4/3RCDmwbVSj5ASsNnOYNGT2KGL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRdtJ1f921lo+aA9uHJiB59SwUY9Bmej2073snNAi4lSdmqd20hv6TGpt4Vw0Xres
	 RpHKfWn4a1+NIdLF6nBaBfE6/nesYt7H8BYtRk2MZTpjYrRIpaaIEdN+VM5t7C19iX
	 54B+Jm1roadcy7vPEtFcBbNWy2xf3lk/4NA5FniKZkM/oYW5MK4DXA/9GOWPvLwRES
	 yyc2Hgd0zcNr8CsLnRi/LmM3fRHPmsqa9wrwuoeeHgEHnKckP80H3fP6GOK6FSrzzv
	 kI92MZJtBbKyept02omenXxAK0vzy8wGOOMOAj0Hzay4dHKmuE8IDQAR2nKjSLKY2Y
	 okH7GFa90j+Vw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 20/26] block: Remove elevator required features
Date: Fri,  2 Feb 2024 16:30:58 +0900
Message-ID: <20240202073104.2418230-21-dlemoal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202073104.2418230-1-dlemoal@kernel.org>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
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
---
 block/blk-settings.c   | 16 ---------------
 block/elevator.c       | 46 +++++-------------------------------------
 block/elevator.h       |  1 -
 include/linux/blkdev.h | 10 ---------
 4 files changed, 5 insertions(+), 68 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index f00bcb595444..b4537237fc5f 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -857,22 +857,6 @@ void blk_queue_write_cache(struct request_queue *q, bool wc, bool fua)
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
index a39ebf075d26..cb90a59d35cb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -448,8 +448,6 @@ struct request_queue {
 
 	atomic_t		nr_active_requests_shared_tags;
 
-	unsigned int		required_elevator_features;
-
 	struct blk_mq_tags	*sched_shared_tags;
 
 	struct list_head	icq_list;
@@ -925,14 +923,6 @@ disk_alloc_independent_access_ranges(struct gendisk *disk, int nr_ia_ranges);
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
2.43.0

