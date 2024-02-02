Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E519F42079;
	Fri,  2 Feb 2024 07:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859095; cv=none; b=gjneJhWcAHobxE/iXrebNAG+1hbhUCsfKfibWL+3rXelJaIU3v1hM/h7h/A+95jusHjcTwKQvFrInyvsKTBEX8+TZTBVik0PEG4/HLQ1cw6hRKkZnmeGB35eK9VDtCxBYHhFhMuxQfSYk+4SeZHBM258pDMIbvshKG3v1gn6kcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859095; c=relaxed/simple;
	bh=9DZEBXWXP/p0aDRWqP5vgkYgdSEP3Zph/XEePi0Ylp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qz7wpqKS/GJfMASzxZ6nVYmpgfmEyKmIfxMD5mjAriedg9j/S4gMupdNy/DuZsfOAOTYfPa1xhPFT+P9QLR4n+l4Q3qr1f2lYMacfItsnFofSnSPgSBHOH+gchMpn7J3azXRe5QIei8ENzIQj9elC60q4djLPLlquN6f7NOc548=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aQ1lBpoz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aQ1lBpoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52906C43390;
	Fri,  2 Feb 2024 07:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859094;
	bh=9DZEBXWXP/p0aDRWqP5vgkYgdSEP3Zph/XEePi0Ylp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQ1lBpozyUBJsqBVxDTkQvliIrhfATxUvFM0tCMK3Djk1k19ch48aihVhrEv2ukok
	 S3aW/L/J/5bgIniSGSHnWBOsABC3PlpcLoZePBSBfgN58cI7UN7BfXRztMiESa2zNB
	 8TF7A6t99AFzrZcH9B2PzAtX2k7swblwywVrocI39mjErRbib8xO7AyzW25J6sWlGE
	 Vw1dpiyrsHD4GO351WwrxbdqHw8dMxo/k/2OdiYY13AY7PiE+dh8nYzKkCn2uGEWs8
	 3XXktnpOn7dYrMFEYi5woe2/6vrBYw3Sd6OLTfFjoVydSgaQzUynvzPk7RlMb/EOxr
	 W58iFGI+IqPsA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 19/26] block: mq-deadline: Remove support for zone write locking
Date: Fri,  2 Feb 2024 16:30:57 +0900
Message-ID: <20240202073104.2418230-20-dlemoal@kernel.org>
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

With the block layer generic plugging of write operations for zoned
block devices, mq-deadline, or any other scheduler, can only ever
see at most one write operation per zone at any time. There is thus no
sequentiality requirements for these writes and thus no need to tightly
control the dispatching of write requests using zone write locking.

Remove all the code that implement this control in the mq-deadline
scheduler and remove advertizing support for the
ELEVATOR_F_ZBD_SEQ_WRITE elevator feature.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/mq-deadline.c | 176 ++------------------------------------------
 1 file changed, 6 insertions(+), 170 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 1b0de4fc3958..42d967849bec 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -90,7 +90,6 @@ struct deadline_data {
 	struct {
 		spinlock_t lock;
 		spinlock_t insert_lock;
-		spinlock_t zone_lock;
 	} ____cacheline_aligned_in_smp;
 
 	unsigned long run_state;
@@ -171,8 +170,7 @@ deadline_latter_request(struct request *rq)
 }
 
 /*
- * Return the first request for which blk_rq_pos() >= @pos. For zoned devices,
- * return the first request after the start of the zone containing @pos.
+ * Return the first request for which blk_rq_pos() >= @pos.
  */
 static inline struct request *deadline_from_pos(struct dd_per_prio *per_prio,
 				enum dd_data_dir data_dir, sector_t pos)
@@ -184,14 +182,6 @@ static inline struct request *deadline_from_pos(struct dd_per_prio *per_prio,
 		return NULL;
 
 	rq = rb_entry_rq(node);
-	/*
-	 * A zoned write may have been requeued with a starting position that
-	 * is below that of the most recently dispatched request. Hence, for
-	 * zoned writes, start searching from the start of a zone.
-	 */
-	if (blk_rq_is_seq_zoned_write(rq))
-		pos = round_down(pos, rq->q->limits.chunk_sectors);
-
 	while (node) {
 		rq = rb_entry_rq(node);
 		if (blk_rq_pos(rq) >= pos) {
@@ -322,36 +312,6 @@ static inline bool deadline_check_fifo(struct dd_per_prio *per_prio,
 	return time_is_before_eq_jiffies((unsigned long)rq->fifo_time);
 }
 
-/*
- * Check if rq has a sequential request preceding it.
- */
-static bool deadline_is_seq_write(struct deadline_data *dd, struct request *rq)
-{
-	struct request *prev = deadline_earlier_request(rq);
-
-	if (!prev)
-		return false;
-
-	return blk_rq_pos(prev) + blk_rq_sectors(prev) == blk_rq_pos(rq);
-}
-
-/*
- * Skip all write requests that are sequential from @rq, even if we cross
- * a zone boundary.
- */
-static struct request *deadline_skip_seq_writes(struct deadline_data *dd,
-						struct request *rq)
-{
-	sector_t pos = blk_rq_pos(rq);
-
-	do {
-		pos += blk_rq_sectors(rq);
-		rq = deadline_latter_request(rq);
-	} while (rq && blk_rq_pos(rq) == pos);
-
-	return rq;
-}
-
 /*
  * For the specified data direction, return the next request to
  * dispatch using arrival ordered lists.
@@ -360,40 +320,10 @@ static struct request *
 deadline_fifo_request(struct deadline_data *dd, struct dd_per_prio *per_prio,
 		      enum dd_data_dir data_dir)
 {
-	struct request *rq, *rb_rq, *next;
-	unsigned long flags;
-
 	if (list_empty(&per_prio->fifo_list[data_dir]))
 		return NULL;
 
-	rq = rq_entry_fifo(per_prio->fifo_list[data_dir].next);
-	if (data_dir == DD_READ || !blk_queue_is_zoned(rq->q))
-		return rq;
-
-	/*
-	 * Look for a write request that can be dispatched, that is one with
-	 * an unlocked target zone. For some HDDs, breaking a sequential
-	 * write stream can lead to lower throughput, so make sure to preserve
-	 * sequential write streams, even if that stream crosses into the next
-	 * zones and these zones are unlocked.
-	 */
-	spin_lock_irqsave(&dd->zone_lock, flags);
-	list_for_each_entry_safe(rq, next, &per_prio->fifo_list[DD_WRITE],
-				 queuelist) {
-		/* Check whether a prior request exists for the same zone. */
-		rb_rq = deadline_from_pos(per_prio, data_dir, blk_rq_pos(rq));
-		if (rb_rq && blk_rq_pos(rb_rq) < blk_rq_pos(rq))
-			rq = rb_rq;
-		if (blk_req_can_dispatch_to_zone(rq) &&
-		    (blk_queue_nonrot(rq->q) ||
-		     !deadline_is_seq_write(dd, rq)))
-			goto out;
-	}
-	rq = NULL;
-out:
-	spin_unlock_irqrestore(&dd->zone_lock, flags);
-
-	return rq;
+	return rq_entry_fifo(per_prio->fifo_list[data_dir].next);
 }
 
 /*
@@ -404,36 +334,8 @@ static struct request *
 deadline_next_request(struct deadline_data *dd, struct dd_per_prio *per_prio,
 		      enum dd_data_dir data_dir)
 {
-	struct request *rq;
-	unsigned long flags;
-
-	rq = deadline_from_pos(per_prio, data_dir,
-			       per_prio->latest_pos[data_dir]);
-	if (!rq)
-		return NULL;
-
-	if (data_dir == DD_READ || !blk_queue_is_zoned(rq->q))
-		return rq;
-
-	/*
-	 * Look for a write request that can be dispatched, that is one with
-	 * an unlocked target zone. For some HDDs, breaking a sequential
-	 * write stream can lead to lower throughput, so make sure to preserve
-	 * sequential write streams, even if that stream crosses into the next
-	 * zones and these zones are unlocked.
-	 */
-	spin_lock_irqsave(&dd->zone_lock, flags);
-	while (rq) {
-		if (blk_req_can_dispatch_to_zone(rq))
-			break;
-		if (blk_queue_nonrot(rq->q))
-			rq = deadline_latter_request(rq);
-		else
-			rq = deadline_skip_seq_writes(dd, rq);
-	}
-	spin_unlock_irqrestore(&dd->zone_lock, flags);
-
-	return rq;
+	return deadline_from_pos(per_prio, data_dir,
+				 per_prio->latest_pos[data_dir]);
 }
 
 /*
@@ -539,10 +441,6 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
 		rq = next_rq;
 	}
 
-	/*
-	 * For a zoned block device, if we only have writes queued and none of
-	 * them can be dispatched, rq will be NULL.
-	 */
 	if (!rq)
 		return NULL;
 
@@ -563,10 +461,6 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
 	prio = ioprio_class_to_prio[ioprio_class];
 	dd->per_prio[prio].latest_pos[data_dir] = blk_rq_pos(rq);
 	dd->per_prio[prio].stats.dispatched++;
-	/*
-	 * If the request needs its target zone locked, do it.
-	 */
-	blk_req_zone_write_lock(rq);
 	rq->rq_flags |= RQF_STARTED;
 	return rq;
 }
@@ -766,7 +660,6 @@ static int dd_init_sched(struct request_queue *q, struct elevator_type *e)
 
 	spin_lock_init(&dd->lock);
 	spin_lock_init(&dd->insert_lock);
-	spin_lock_init(&dd->zone_lock);
 
 	INIT_LIST_HEAD(&dd->at_head);
 	INIT_LIST_HEAD(&dd->at_tail);
@@ -879,12 +772,6 @@ static void dd_insert_request(struct request_queue *q, struct request *rq,
 
 	lockdep_assert_held(&dd->lock);
 
-	/*
-	 * This may be a requeue of a write request that has locked its
-	 * target zone. If it is the case, this releases the zone lock.
-	 */
-	blk_req_zone_write_unlock(rq);
-
 	prio = ioprio_class_to_prio[ioprio_class];
 	per_prio = &dd->per_prio[prio];
 	if (!rq->elv.priv[0]) {
@@ -916,18 +803,6 @@ static void dd_insert_request(struct request_queue *q, struct request *rq,
 		 */
 		rq->fifo_time = jiffies + dd->fifo_expire[data_dir];
 		insert_before = &per_prio->fifo_list[data_dir];
-#ifdef CONFIG_BLK_DEV_ZONED
-		/*
-		 * Insert zoned writes such that requests are sorted by
-		 * position per zone.
-		 */
-		if (blk_rq_is_seq_zoned_write(rq)) {
-			struct request *rq2 = deadline_latter_request(rq);
-
-			if (rq2 && blk_rq_zone_no(rq2) == blk_rq_zone_no(rq))
-				insert_before = &rq2->queuelist;
-		}
-#endif
 		list_add_tail(&rq->queuelist, insert_before);
 	}
 }
@@ -956,33 +831,8 @@ static void dd_prepare_request(struct request *rq)
 	rq->elv.priv[0] = NULL;
 }
 
-static bool dd_has_write_work(struct blk_mq_hw_ctx *hctx)
-{
-	struct deadline_data *dd = hctx->queue->elevator->elevator_data;
-	enum dd_prio p;
-
-	for (p = 0; p <= DD_PRIO_MAX; p++)
-		if (!list_empty_careful(&dd->per_prio[p].fifo_list[DD_WRITE]))
-			return true;
-
-	return false;
-}
-
 /*
  * Callback from inside blk_mq_free_request().
- *
- * For zoned block devices, write unlock the target zone of
- * completed write requests. Do this while holding the zone lock
- * spinlock so that the zone is never unlocked while deadline_fifo_request()
- * or deadline_next_request() are executing. This function is called for
- * all requests, whether or not these requests complete successfully.
- *
- * For a zoned block device, __dd_dispatch_request() may have stopped
- * dispatching requests if all the queued requests are write requests directed
- * at zones that are already locked due to on-going write requests. To ensure
- * write request dispatch progress in this case, mark the queue as needing a
- * restart to ensure that the queue is run again after completion of the
- * request and zones being unlocked.
  */
 static void dd_finish_request(struct request *rq)
 {
@@ -997,21 +847,8 @@ static void dd_finish_request(struct request *rq)
 	 * called dd_insert_requests(). Skip requests that bypassed I/O
 	 * scheduling. See also blk_mq_request_bypass_insert().
 	 */
-	if (!rq->elv.priv[0])
-		return;
-
-	atomic_inc(&per_prio->stats.completed);
-
-	if (blk_queue_is_zoned(q)) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&dd->zone_lock, flags);
-		blk_req_zone_write_unlock(rq);
-		spin_unlock_irqrestore(&dd->zone_lock, flags);
-
-		if (dd_has_write_work(rq->mq_hctx))
-			blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
-	}
+	if (rq->elv.priv[0])
+		atomic_inc(&per_prio->stats.completed);
 }
 
 static bool dd_has_work_for_prio(struct dd_per_prio *per_prio)
@@ -1339,7 +1176,6 @@ static struct elevator_type mq_deadline = {
 	.elevator_attrs = deadline_attrs,
 	.elevator_name = "mq-deadline",
 	.elevator_alias = "deadline",
-	.elevator_features = ELEVATOR_F_ZBD_SEQ_WRITE,
 	.elevator_owner = THIS_MODULE,
 };
 MODULE_ALIAS("mq-deadline-iosched");
-- 
2.43.0

