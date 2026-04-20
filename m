Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1571C39DBDA
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 11:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776683382; cv=none; b=ql55HU/ly+V14pF6B5XRUaICA+lcPy49WkmaSSn5FgirCabwwndq/3dAQQgjgsnAn4fGglLaWLfo4+MD3vwOLa/j9chVdmUNbMRJK/+gMi6X1NW8jHec+C+12UxdBgqI6FDo4xmsUOz/rFhOQ6l2BX4r4vXnkLE/2rUEFGHtip0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776683382; c=relaxed/simple;
	bh=nl1aqVOb79THOq+kvA/tNmvXgAps2ZBooXiI+VlgR6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZJeCZhF8bBPEj232aM+1igtWL/5HcRlzkMBY3o5ZilYnZ1pcQQd+3ZZMa9jfWALZx1GSl8MoMkWZHIgaFpBxcLwL6Mj+MIObtvMTQIcj9VpysofvzusXpUQiTRk5WOkk2vO3C+5a1Viy9uatCUsJvO4jefSUM6jM0QIyo0yG3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=PdZErTla; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="PdZErTla"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-35fc0d7c310so1976924a91.1
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 04:09:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776683373; x=1777288173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bN5D6CtCL/4qcrnc58EabHMmVTmQ3dJAnIrlmZy8Pxw=;
        b=JOQgs14T2vm7nFm6mxV05pfHPVf/bfkH3EB+O/taTHvX3HhBCwCofOZTxGPkoDf5HP
         FjFU/jjmKbc7TidKNJwOjC97lxvNjtID8mru3CkdroZ8M/hbvk03/mC6FFK6hWGjOirE
         r2t5hly1GDaGl8TzE/k9a+U1HRsBrEA7RanNRmySbCQZ78USzU9/CFsy+s26p3kkqQH6
         vcaSlgWriWOXGxYIeDaY0gvYeVODt2SfRZOYFBKfsobuqSoEoM9PUVmWA5owAbsChLBF
         FzSU8mKP7Y3dLky7eANqhgvdZ5iWVqsFhYMmWCTSdKXN/xLrrClTdoaF4aRTIikzY/st
         i8jg==
X-Gm-Message-State: AOJu0YzLv5cP4wrwEFMHo4oKq0kJDb1geLtp0e6+5NADmBx4PJXmds44
	Y/eTlOFdWSXj8V99nPpwE8x5CYVOCzK/lvg469FQP0boSY/EusO00+cuqSQU04PPhQfaYnM4EJx
	RkX3NAHPdeCCWMXIMU+A/2q5R7r4Zf4cIaj4kxFdLBtQ+NBhQ4k8I2No45Z5AY48rN7c0Bji6kZ
	P1wGKmCZwUpLe9WFRFq02e/3mEjU1ZAQo7ie5Zvk0IIcLaKgj9EY5RGboRFkQe4Xp6vCiWsNbVR
	vXFxb7lmSEx/OFC
X-Gm-Gg: AeBDieuopaCfQsbpe5Ehkkum2ZoKEVa3M0geaFhF3L+5rGOcQoP6ELbWM+rEmZaDjfl
	HRU1hR30HaY3VH7FthCfbQ3NBJe1n0NkwPOrw6IKnBIVqqAIISysoTLWdDqxjko7wHjKO5Ev3eC
	iikAb+phorqiPP+fL+c7I7dVhk+0qkiH+tGlQq+vX9mlUtvBrQC6snFm3JGp+f5petFT5X6fxLc
	BH+f4XyoxL8dM6LcWPS7S1UVdm5nSI+Vn55dSDWgy+phdg90mhnqIpRqxIEGbi7FPSJKRe1Jd2b
	lD+Fqe8rbEHlDpjQILB/XJWi5KKS4QADxHOarlBKptr43y623G+FdlaUHbiAYBt1g/l6skbdCdR
	FONaMdPr4hD9/3PGCvmy+j8T+x54av49v9uZVX4ClEP8dJxhLbUL61vzaBUprybFxKju7R2pVem
	jYSpmdkHQkC0pOZnh+yQPmg8xKLiU09gihR7Ajq3bJ4f/pWZXCDm62tjegj7wecu46UZE=
X-Received: by 2002:a17:90b:33c7:b0:35e:577a:73a9 with SMTP id 98e67ed59e1d1-361404ae4e1mr14412300a91.26.1776683373070;
        Mon, 20 Apr 2026 04:09:33 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-90.dlp.protect.broadcom.com. [144.49.247.90])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2b5fab113f4sm5859345ad.45.2026.04.20.04.09.32
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Apr 2026 04:09:33 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2b24cd2e2b3so28078335ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 04:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1776683371; x=1777288171; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bN5D6CtCL/4qcrnc58EabHMmVTmQ3dJAnIrlmZy8Pxw=;
        b=PdZErTlax3ILO0sVa49/pKsHxKs3P4ak75xm61o6KHszweRPAPKRxCOobWlqxuosdy
         vYnl0m3EdMgDIQ9/Q1ksaS97fNQIxphOFP4DSlAF34z+Ce+K6hG6EMr5Xx7dbHCMvpoL
         LjPQwHEvqYmTmmuJgZlMOUkRoieJWjaIhVC8U=
X-Received: by 2002:a17:903:1a88:b0:2b4:5b9e:4edd with SMTP id d9443c01a7336-2b5f9e9a500mr138947385ad.9.1776683371271;
        Mon, 20 Apr 2026 04:09:31 -0700 (PDT)
X-Received: by 2002:a17:903:1a88:b0:2b4:5b9e:4edd with SMTP id d9443c01a7336-2b5f9e9a500mr138947085ad.9.1776683370718;
        Mon, 20 Apr 2026 04:09:30 -0700 (PDT)
Received: from sumit_ws.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa1739fsm103115415ad.22.2026.04.20.04.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 04:09:30 -0700 (PDT)
From: Sumit Saxena <sumit.saxena@broadcom.com>
To: martin.petersen@oracle.com,
	axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	Bart Van Assche <bvanassche@acm.org>,
	Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH v2 2/3] block: drop shared-tag fairness throttling
Date: Mon, 20 Apr 2026 17:08:38 +0530
Message-ID: <20260420113846.1401374-3-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260420113846.1401374-1-sumit.saxena@broadcom.com>
References: <20260420113846.1401374-1-sumit.saxena@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Bart Van Assche <bvanassche@acm.org>

Original patch [1] by Bart Van Assche; this version is rebased onto the
current tree.  In testing it improves IOPS by roughly 16-18% by removing
the fair-sharing throttle on shared tag queues.

This patch removes the following code and structure members:
- The function hctx_may_queue().
- blk_mq_hw_ctx.nr_active and request_queue.nr_active_requests_shared_tags
  and also all the code that modifies these two member variables.

[1]: https://lore.kernel.org/linux-block/20240529213921.3166462-1-bvanassche@acm.org/

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 block/blk-core.c       |   2 -
 block/blk-mq-debugfs.c |  22 ++++++++-
 block/blk-mq-tag.c     |   4 --
 block/blk-mq.c         |  17 +------
 block/blk-mq.h         | 100 -----------------------------------------
 include/linux/blk-mq.h |   6 ---
 include/linux/blkdev.h |   2 -
 7 files changed, 22 insertions(+), 131 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 474700ffaa1c..430907b26fc4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -421,8 +421,6 @@ struct request_queue *blk_alloc_queue(struct queue_limits *lim, int node_id)
 
 	q->node = node_id;
 
-	atomic_set(&q->nr_active_requests_shared_tags, 0);
-
 	timer_setup(&q->timeout, blk_rq_timed_out_timer, 0);
 	INIT_WORK(&q->timeout_work, blk_timeout_work);
 	INIT_LIST_HEAD(&q->icq_list);
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 28167c9baa55..6ef922d7abc1 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -467,11 +467,31 @@ static int hctx_sched_tags_bitmap_show(void *data, struct seq_file *m)
 	return 0;
 }
 
+struct count_active_params {
+	struct blk_mq_hw_ctx	*hctx;
+	int			*active;
+};
+
+static bool hctx_count_active(struct request *rq, void *data)
+{
+	const struct count_active_params *params = data;
+
+	if (rq->mq_hctx == params->hctx)
+		(*params->active)++;
+
+	return true;
+}
+
 static int hctx_active_show(void *data, struct seq_file *m)
 {
 	struct blk_mq_hw_ctx *hctx = data;
+	int active = 0;
+	struct count_active_params params = { .hctx = hctx, .active = &active };
+
+	blk_mq_all_tag_iter(hctx->sched_tags ?: hctx->tags, hctx_count_active,
+			    &params);
 
-	seq_printf(m, "%d\n", __blk_mq_active_requests(hctx));
+	seq_printf(m, "%d\n", active);
 	return 0;
 }
 
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 33946cdb5716..bfd27cc6249b 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -109,10 +109,6 @@ void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
 static int __blk_mq_get_tag(struct blk_mq_alloc_data *data,
 			    struct sbitmap_queue *bt)
 {
-	if (!data->q->elevator && !(data->flags & BLK_MQ_REQ_RESERVED) &&
-			!hctx_may_queue(data->hctx, bt))
-		return BLK_MQ_NO_TAG;
-
 	if (data->shallow_depth)
 		return sbitmap_queue_get_shallow(bt, data->shallow_depth);
 	else
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9af8c3dec3f6..3c54000bc554 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -489,8 +489,6 @@ __blk_mq_alloc_requests_batch(struct blk_mq_alloc_data *data)
 		}
 	} while (data->nr_tags > nr);
 
-	if (!(data->rq_flags & RQF_SCHED_TAGS))
-		blk_mq_add_active_requests(data->hctx, nr);
 	/* caller already holds a reference, add for remainder */
 	percpu_ref_get_many(&data->q->q_usage_counter, nr - 1);
 	data->nr_tags -= nr;
@@ -587,8 +585,6 @@ static struct request *__blk_mq_alloc_requests(struct blk_mq_alloc_data *data)
 		goto retry;
 	}
 
-	if (!(data->rq_flags & RQF_SCHED_TAGS))
-		blk_mq_inc_active_requests(data->hctx);
 	rq = blk_mq_rq_ctx_init(data, blk_mq_tags_from_data(data), tag);
 	blk_mq_rq_time_init(rq, alloc_time_ns);
 	return rq;
@@ -763,8 +759,6 @@ struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
 	tag = blk_mq_get_tag(&data);
 	if (tag == BLK_MQ_NO_TAG)
 		goto out_queue_exit;
-	if (!(data.rq_flags & RQF_SCHED_TAGS))
-		blk_mq_inc_active_requests(data.hctx);
 	rq = blk_mq_rq_ctx_init(&data, blk_mq_tags_from_data(&data), tag);
 	blk_mq_rq_time_init(rq, alloc_time_ns);
 	rq->__data_len = 0;
@@ -807,10 +801,8 @@ static void __blk_mq_free_request(struct request *rq)
 	blk_pm_mark_last_busy(rq);
 	rq->mq_hctx = NULL;
 
-	if (rq->tag != BLK_MQ_NO_TAG) {
-		blk_mq_dec_active_requests(hctx);
+	if (rq->tag != BLK_MQ_NO_TAG)
 		blk_mq_put_tag(hctx->tags, ctx, rq->tag);
-	}
 	if (sched_tag != BLK_MQ_NO_TAG)
 		blk_mq_put_tag(hctx->sched_tags, ctx, sched_tag);
 	blk_mq_sched_restart(hctx);
@@ -1188,8 +1180,6 @@ static inline void blk_mq_flush_tag_batch(struct blk_mq_hw_ctx *hctx,
 {
 	struct request_queue *q = hctx->queue;
 
-	blk_mq_sub_active_requests(hctx, nr_tags);
-
 	blk_mq_put_tags(hctx->tags, tag_array, nr_tags);
 	percpu_ref_put_many(&q->q_usage_counter, nr_tags);
 }
@@ -1875,9 +1865,6 @@ bool __blk_mq_alloc_driver_tag(struct request *rq)
 	if (blk_mq_tag_is_reserved(rq->mq_hctx->sched_tags, rq->internal_tag)) {
 		bt = &rq->mq_hctx->tags->breserved_tags;
 		tag_offset = 0;
-	} else {
-		if (!hctx_may_queue(rq->mq_hctx, bt))
-			return false;
 	}
 
 	tag = __sbitmap_queue_get(bt);
@@ -1885,7 +1872,6 @@ bool __blk_mq_alloc_driver_tag(struct request *rq)
 		return false;
 
 	rq->tag = tag + tag_offset;
-	blk_mq_inc_active_requests(rq->mq_hctx);
 	return true;
 }
 
@@ -4037,7 +4023,6 @@ blk_mq_alloc_hctx(struct request_queue *q, struct blk_mq_tag_set *set,
 	if (!zalloc_cpumask_var_node(&hctx->cpumask, gfp, node))
 		goto free_hctx;
 
-	atomic_set(&hctx->nr_active, 0);
 	if (node == NUMA_NO_NODE)
 		node = set->numa_node;
 	hctx->numa_node = node;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index aa15d31aaae9..8dfb67c55f5d 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -291,70 +291,9 @@ static inline int blk_mq_get_rq_budget_token(struct request *rq)
 	return -1;
 }
 
-static inline void __blk_mq_add_active_requests(struct blk_mq_hw_ctx *hctx,
-						int val)
-{
-	if (blk_mq_is_shared_tags(hctx->flags))
-		atomic_add(val, &hctx->queue->nr_active_requests_shared_tags);
-	else
-		atomic_add(val, &hctx->nr_active);
-}
-
-static inline void __blk_mq_inc_active_requests(struct blk_mq_hw_ctx *hctx)
-{
-	__blk_mq_add_active_requests(hctx, 1);
-}
-
-static inline void __blk_mq_sub_active_requests(struct blk_mq_hw_ctx *hctx,
-		int val)
-{
-	if (blk_mq_is_shared_tags(hctx->flags))
-		atomic_sub(val, &hctx->queue->nr_active_requests_shared_tags);
-	else
-		atomic_sub(val, &hctx->nr_active);
-}
-
-static inline void __blk_mq_dec_active_requests(struct blk_mq_hw_ctx *hctx)
-{
-	__blk_mq_sub_active_requests(hctx, 1);
-}
-
-static inline void blk_mq_add_active_requests(struct blk_mq_hw_ctx *hctx,
-					      int val)
-{
-	if (hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
-		__blk_mq_add_active_requests(hctx, val);
-}
-
-static inline void blk_mq_inc_active_requests(struct blk_mq_hw_ctx *hctx)
-{
-	if (hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
-		__blk_mq_inc_active_requests(hctx);
-}
-
-static inline void blk_mq_sub_active_requests(struct blk_mq_hw_ctx *hctx,
-					      int val)
-{
-	if (hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
-		__blk_mq_sub_active_requests(hctx, val);
-}
-
-static inline void blk_mq_dec_active_requests(struct blk_mq_hw_ctx *hctx)
-{
-	if (hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
-		__blk_mq_dec_active_requests(hctx);
-}
-
-static inline int __blk_mq_active_requests(struct blk_mq_hw_ctx *hctx)
-{
-	if (blk_mq_is_shared_tags(hctx->flags))
-		return atomic_read(&hctx->queue->nr_active_requests_shared_tags);
-	return atomic_read(&hctx->nr_active);
-}
 static inline void __blk_mq_put_driver_tag(struct blk_mq_hw_ctx *hctx,
 					   struct request *rq)
 {
-	blk_mq_dec_active_requests(hctx);
 	blk_mq_put_tag(hctx->tags, rq->mq_ctx, rq->tag);
 	rq->tag = BLK_MQ_NO_TAG;
 }
@@ -396,45 +335,6 @@ static inline void blk_mq_free_requests(struct list_head *list)
 	}
 }
 
-/*
- * For shared tag users, we track the number of currently active users
- * and attempt to provide a fair share of the tag depth for each of them.
- */
-static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
-				  struct sbitmap_queue *bt)
-{
-	unsigned int depth, users;
-
-	if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
-		return true;
-
-	/*
-	 * Don't try dividing an ant
-	 */
-	if (bt->sb.depth == 1)
-		return true;
-
-	if (blk_mq_is_shared_tags(hctx->flags)) {
-		struct request_queue *q = hctx->queue;
-
-		if (!test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags))
-			return true;
-	} else {
-		if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
-			return true;
-	}
-
-	users = READ_ONCE(hctx->tags->active_queues);
-	if (!users)
-		return true;
-
-	/*
-	 * Allow at least some tags
-	 */
-	depth = max((bt->sb.depth + users - 1) / users, 4U);
-	return __blk_mq_active_requests(hctx) < depth;
-}
-
 /* run the code block in @dispatch_ops with rcu/srcu read lock held */
 #define __blk_mq_run_dispatch_ops(q, check_sleep, dispatch_ops)	\
 do {								\
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 18a2388ba581..ccbb07559402 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -432,12 +432,6 @@ struct blk_mq_hw_ctx {
 	/** @queue_num: Index of this hardware queue. */
 	unsigned int		queue_num;
 
-	/**
-	 * @nr_active: Number of active requests. Only used when a tag set is
-	 * shared across request queues.
-	 */
-	atomic_t		nr_active;
-
 	/** @cpuhp_online: List to store request if CPU is going to die */
 	struct hlist_node	cpuhp_online;
 	/** @cpuhp_dead: List to store request if some CPU die. */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d463b9b5a0a5..0dd2a32068ec 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -561,8 +561,6 @@ struct request_queue {
 	struct timer_list	timeout;
 	struct work_struct	timeout_work;
 
-	atomic_t		nr_active_requests_shared_tags;
-
 	struct blk_mq_tags	*sched_shared_tags;
 
 	struct list_head	icq_list;
-- 
2.43.7

