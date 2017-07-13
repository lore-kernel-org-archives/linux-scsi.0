From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.14 RFC PATCH 2/2] dm rq: eliminate historic blk-mq and .request_fn queue stacking restrictions
Date: Thu, 13 Jul 2017 17:12:17 -0400
Message-ID: <20170713211217.52361-3-snitzer@redhat.com>
References: <20170713211217.52361-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170713211217.52361-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: hch@lst.de
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Currently if dm_mod.use_blk_mq=Y (or a DM-multipath table is loaded with
queue_mode=mq) and all underlying devices are not blk-mq, DM core will
fail with the error:
  "table load rejected: all devices are not blk-mq request-stackable"

This all-blk-mq-or-nothing approach is too cut-throat because it
prevents access to data stored on what could have been a previously
working multipath setup (e.g. if user decides to try dm_mod.use_blk_mq=Y
or queue_mode=mq only to find their underlying devices aren't blk-mq).

This restriction, and others like not being able to stack a top-level
blk-mq request-queue ontop of old .request_fn device(s), can be removed
thanks to commit eb8db831be ("dm: always defer request allocation to the
owner of the request_queue").

Now that request-based DM will always rely on the target (multipath) to
call blk_get_request() to create a clone request it is possible to
support all 4 permutations of stacking old .request_fn and blk-mq
request_queues.

Depends-on: eb8db831be ("dm: always defer request allocation to the owner of the request_queue")
Reported-by: Ewan Milne <emilne@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-rq.c    |  5 -----
 drivers/md/dm-table.c | 31 +++----------------------------
 drivers/md/dm.h       |  1 -
 3 files changed, 3 insertions(+), 34 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 95bb44c..d64677b 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -782,11 +782,6 @@ int dm_mq_init_request_queue(struct mapped_device *md, struct dm_table *t)
 	struct dm_target *immutable_tgt;
 	int err;
 
-	if (!dm_table_all_blk_mq_devices(t)) {
-		DMERR("request-based dm-mq may only be stacked on blk-mq device(s)");
-		return -EINVAL;
-	}
-
 	md->tag_set = kzalloc_node(sizeof(struct blk_mq_tag_set), GFP_KERNEL, md->numa_node_id);
 	if (!md->tag_set)
 		return -ENOMEM;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a39bcd9..e630768 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -46,7 +46,6 @@ struct dm_table {
 
 	bool integrity_supported:1;
 	bool singleton:1;
-	bool all_blk_mq:1;
 	unsigned integrity_added:1;
 
 	/*
@@ -910,7 +909,6 @@ static int dm_table_determine_type(struct dm_table *t)
 {
 	unsigned i;
 	unsigned bio_based = 0, request_based = 0, hybrid = 0;
-	unsigned sq_count = 0, mq_count = 0;
 	struct dm_target *tgt;
 	struct dm_dev_internal *dd;
 	struct list_head *devices = dm_table_get_devices(t);
@@ -985,11 +983,9 @@ static int dm_table_determine_type(struct dm_table *t)
 		int srcu_idx;
 		struct dm_table *live_table = dm_get_live_table(t->md, &srcu_idx);
 
-		/* inherit live table's type and all_blk_mq */
-		if (live_table) {
+		/* inherit live table's type */
+		if (live_table)
 			t->type = live_table->type;
-			t->all_blk_mq = live_table->all_blk_mq;
-		}
 		dm_put_live_table(t->md, srcu_idx);
 		return 0;
 	}
@@ -999,25 +995,9 @@ static int dm_table_determine_type(struct dm_table *t)
 		struct request_queue *q = bdev_get_queue(dd->dm_dev->bdev);
 
 		if (!blk_queue_stackable(q)) {
-			DMERR("table load rejected: including"
-			      " non-request-stackable devices");
+			DMERR("table load rejected: includes non-request-stackable devices");
 			return -EINVAL;
 		}
-
-		if (q->mq_ops)
-			mq_count++;
-		else
-			sq_count++;
-	}
-	if (sq_count && mq_count) {
-		DMERR("table load rejected: not all devices are blk-mq request-stackable");
-		return -EINVAL;
-	}
-	t->all_blk_mq = mq_count > 0;
-
-	if (t->type == DM_TYPE_MQ_REQUEST_BASED && !t->all_blk_mq) {
-		DMERR("table load rejected: all devices are not blk-mq request-stackable");
-		return -EINVAL;
 	}
 
 	return 0;
@@ -1067,11 +1047,6 @@ bool dm_table_request_based(struct dm_table *t)
 	return __table_type_request_based(dm_table_get_type(t));
 }
 
-bool dm_table_all_blk_mq_devices(struct dm_table *t)
-{
-	return t->all_blk_mq;
-}
-
 static int dm_table_alloc_md_mempools(struct dm_table *t, struct mapped_device *md)
 {
 	enum dm_queue_mode type = dm_table_get_type(t);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 38c84c0..c484c4d 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -70,7 +70,6 @@ struct dm_target *dm_table_get_immutable_target(struct dm_table *t);
 struct dm_target *dm_table_get_wildcard_target(struct dm_table *t);
 bool dm_table_bio_based(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
-bool dm_table_all_blk_mq_devices(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
 
-- 
2.10.1
