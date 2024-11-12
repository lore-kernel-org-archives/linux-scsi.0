Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71304206E65;
	Tue, 12 Nov 2024 17:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731430866; cv=none; b=ArA/x07CKZLSlQoNkgPlzxKrInqKQcvPw6B2pbUQyng94k29Hc4NwiI3JmblVJb9+Yns+ptaSfuZeC125J26VS7kzEJt9+rb5fZSfKFx2/E13RTHmGUeN8s7SBgNF6hMOOftTHgoeFlKg6f81ZSscriIfnv2Fwpf1Q8X2FA8ZMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731430866; c=relaxed/simple;
	bh=MC5HvBbEp6BT6Tvk5VO/HLCaWqUYmaXhtYqbil/pxk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gotibY5oUxE7cjFvsLFrh+UYYfs4YRULHGg/wsw5mD0m8Ao+K5UboUB9Zz96VBh149ZOyzd55vln5iSxF0QmozHRAhYNNkGjWf+OuTtmVDyDCdqMXmZ6Yba09A11uB7t9iFDd06ZUXdEZ5pvOKNAROnQylG44Sg8smtHv1a7n4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n7SrAPfx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n7SrAPfx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=h91R7tAqcivyHE/FFigi4ZXnSPIeEu6s1dQp9XI8hjA=; b=n7SrAPfx6eH/M0NhXI6oMma1H2
	stFUL3PM8rxFb49ot7pRhvqnp3wBpviMGj5TaaLFebrH1EGYBmLXxWpGf0Cy4CgGpNMnqZVLXNHqY
	l5zW07QKmglYUMGQlc0n/OleuvaGQS0YCyA0uMtZ0S70KnDjf3Z5txOUgybwtztJZ7ipZcHvLdkw+
	WRo2pq3/1mQVFKSDzsxfJIR5Fn7TFpngnRkKyMwMRiQbXVQ9Vekg1QCpKjlThCYe5ngdY9fJ6wg1U
	reYldYBT/1/CxBQzTcMdmn/RzFbhl6CyTDpCgu41W6PYfSTujDuli0p3/VC+NolOna0sv2cxKGzn7
	1oUuQmEA==;
Received: from 2a02-8389-2341-5b80-9a3d-4734-1162-bba0.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9a3d:4734:1162:bba0] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tAuGD-00000004Gab-362R;
	Tue, 12 Nov 2024 17:01:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 2/2] block: remove the ioprio field from struct request
Date: Tue, 12 Nov 2024 18:00:39 +0100
Message-ID: <20241112170050.1612998-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241112170050.1612998-1-hch@lst.de>
References: <20241112170050.1612998-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The request ioprio is only initialized from the first attached bio,
so requests without a bio already never set it.  Directly use the
bio field instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-merge.c            | 10 ++++------
 block/blk-mq.c               |  3 +--
 include/linux/blk-mq.h       |  7 +++----
 include/trace/events/block.h |  6 +++---
 4 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2306014c108d..df36f83f3738 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -871,11 +871,10 @@ static struct request *attempt_merge(struct request_queue *q,
 		/* Don't merge requests with different write hints. */
 		if (req->bio->bi_write_hint != next->bio->bi_write_hint)
 			return NULL;
+		if (req->bio->bi_ioprio != next->bio->bi_ioprio)
+			return NULL;
 	}
 
-	if (req->ioprio != next->ioprio)
-		return NULL;
-
 	if (!blk_atomic_write_mergeable_rqs(req, next))
 		return NULL;
 
@@ -1007,11 +1006,10 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 		/* Don't merge requests with different write hints. */
 		if (rq->bio->bi_write_hint != bio->bi_write_hint)
 			return false;
+		if (rq->bio->bi_ioprio != bio->bi_ioprio)
+			return false;
 	}
 
-	if (rq->ioprio != bio_prio(bio))
-		return false;
-
 	if (blk_atomic_write_mergeable_rq_bio(rq, bio) == false)
 		return false;
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 65e6b86d341c..3c6cadba75e3 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -842,7 +842,7 @@ static void blk_print_req_error(struct request *req, blk_status_t status)
 		blk_op_str(req_op(req)),
 		(__force u32)(req->cmd_flags & ~REQ_OP_MASK),
 		req->nr_phys_segments,
-		IOPRIO_PRIO_CLASS(req->ioprio));
+		IOPRIO_PRIO_CLASS(req_get_ioprio(req)));
 }
 
 /*
@@ -3306,7 +3306,6 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 		rq->special_vec = rq_src->special_vec;
 	}
 	rq->nr_phys_segments = rq_src->nr_phys_segments;
-	rq->ioprio = rq_src->ioprio;
 
 	if (rq->bio && blk_crypto_rq_bio_prep(rq, rq->bio, gfp_mask) < 0)
 		goto free_and_out;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2804fe181d9d..a28264442948 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -156,8 +156,6 @@ struct request {
 	struct blk_crypto_keyslot *crypt_keyslot;
 #endif
 
-	unsigned short ioprio;
-
 	enum mq_rq_state state;
 	atomic_t ref;
 
@@ -221,7 +219,9 @@ static inline bool blk_rq_is_passthrough(struct request *rq)
 
 static inline unsigned short req_get_ioprio(struct request *req)
 {
-	return req->ioprio;
+	if (req->bio)
+		return req->bio->bi_ioprio;
+	return 0;
 }
 
 #define rq_data_dir(rq)		(op_is_write(req_op(rq)) ? WRITE : READ)
@@ -984,7 +984,6 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
 	rq->nr_phys_segments = nr_segs;
 	rq->__data_len = bio->bi_iter.bi_size;
 	rq->bio = rq->biotail = bio;
-	rq->ioprio = bio_prio(bio);
 }
 
 void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 1527d5d45e01..bd0ea07338eb 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -99,7 +99,7 @@ TRACE_EVENT(block_rq_requeue,
 		__entry->dev	   = rq->q->disk ? disk_devt(rq->q->disk) : 0;
 		__entry->sector    = blk_rq_trace_sector(rq);
 		__entry->nr_sector = blk_rq_trace_nr_sectors(rq);
-		__entry->ioprio    = rq->ioprio;
+		__entry->ioprio    = req_get_ioprio(rq);
 
 		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags);
 		__get_str(cmd)[0] = '\0';
@@ -136,7 +136,7 @@ DECLARE_EVENT_CLASS(block_rq_completion,
 		__entry->sector    = blk_rq_pos(rq);
 		__entry->nr_sector = nr_bytes >> 9;
 		__entry->error     = blk_status_to_errno(error);
-		__entry->ioprio    = rq->ioprio;
+		__entry->ioprio    = req_get_ioprio(rq);
 
 		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags);
 		__get_str(cmd)[0] = '\0';
@@ -209,7 +209,7 @@ DECLARE_EVENT_CLASS(block_rq,
 		__entry->sector    = blk_rq_trace_sector(rq);
 		__entry->nr_sector = blk_rq_trace_nr_sectors(rq);
 		__entry->bytes     = blk_rq_bytes(rq);
-		__entry->ioprio	   = rq->ioprio;
+		__entry->ioprio	   = req_get_ioprio(rq);
 
 		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags);
 		__get_str(cmd)[0] = '\0';
-- 
2.45.2

