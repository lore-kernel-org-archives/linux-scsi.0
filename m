From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [APPENDIX PATCH 13/13] dm-mpath: convert to request-based
Date: Fri, 15 Feb 2008 17:33:53 -0500 (EST)
Message-ID: <20080215.173353.107941754.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762825AbYBOWdt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 17:33:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

This patch converts dm-multipath target to request-based from bio-based.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm-mpath.c     |  228 +++++++++++++++++++++++++++++++++-------------
 drivers/md/dm-rq-record.h |   36 +++++++
 2 files changed, 204 insertions(+), 60 deletions(-)

Index: 2.6.25-rc1/drivers/md/dm-mpath.c
===================================================================
--- 2.6.25-rc1.orig/drivers/md/dm-mpath.c
+++ 2.6.25-rc1/drivers/md/dm-mpath.c
@@ -8,8 +8,7 @@
 #include "dm.h"
 #include "dm-path-selector.h"
 #include "dm-hw-handler.h"
-#include "dm-bio-list.h"
-#include "dm-bio-record.h"
+#include "dm-rq-record.h"
 #include "dm-uevent.h"
 
 #include <linux/ctype.h>
@@ -80,7 +79,7 @@ struct multipath {
 	unsigned pg_init_count;		/* Number of times pg_init called */
 
 	struct work_struct process_queued_ios;
-	struct bio_list queued_ios;
+	struct list_head queued_ios;
 	unsigned queue_size;
 
 	struct work_struct trigger_event;
@@ -89,22 +88,22 @@ struct multipath {
 	 * We must use a mempool of dm_mpath_io structs so that we
 	 * can resubmit bios on error.
 	 */
-	mempool_t *mpio_pool;
+	mempool_t *mpio_pool; /* REMOVE ME */
 };
 
 /*
  * Context information attached to each bio we process.
  */
-struct dm_mpath_io {
+struct dm_mpath_io { /* REMOVE ME */
 	struct pgpath *pgpath;
-	struct dm_bio_details details;
+	struct dm_rq_details details;
 };
 
 typedef int (*action_fn) (struct pgpath *pgpath);
 
 #define MIN_IOS 256	/* Mempool size */
 
-static struct kmem_cache *_mpio_cache;
+static struct kmem_cache *_mpio_cache; /* REMOVE ME */
 
 static struct workqueue_struct *kmultipathd;
 static void process_queued_ios(struct work_struct *work);
@@ -174,6 +173,7 @@ static struct multipath *alloc_multipath
 	m = kzalloc(sizeof(*m), GFP_KERNEL);
 	if (m) {
 		INIT_LIST_HEAD(&m->priority_groups);
+		INIT_LIST_HEAD(&m->queued_ios);
 		spin_lock_init(&m->lock);
 		m->queue_io = 1;
 		INIT_WORK(&m->process_queued_ios, process_queued_ios);
@@ -304,12 +304,13 @@ static int __must_push_back(struct multi
 		dm_noflush_suspending(m->ti));
 }
 
-static int map_io(struct multipath *m, struct bio *bio,
+static int map_io(struct multipath *m, struct request *clone,
 		  struct dm_mpath_io *mpio, unsigned was_queued)
 {
 	int r = DM_MAPIO_REMAPPED;
 	unsigned long flags;
 	struct pgpath *pgpath;
+	struct block_device *bdev;
 
 	spin_lock_irqsave(&m->lock, flags);
 
@@ -326,19 +327,28 @@ static int map_io(struct multipath *m, s
 	if ((pgpath && m->queue_io) ||
 	    (!pgpath && m->queue_if_no_path)) {
 		/* Queue for the daemon to resubmit */
-		bio_list_add(&m->queued_ios, bio);
+		list_add_tail(&clone->queuelist, &m->queued_ios);
 		m->queue_size++;
 		if ((m->pg_init_required && !m->pg_init_in_progress) ||
 		    !m->queue_io)
 			queue_work(kmultipathd, &m->process_queued_ios);
 		pgpath = NULL;
+		clone->q = NULL;
+		clone->rq_disk = NULL;
 		r = DM_MAPIO_SUBMITTED;
-	} else if (pgpath)
-		bio->bi_bdev = pgpath->path.dev->bdev;
-	else if (__must_push_back(m))
+	} else if (pgpath) {
+		bdev = pgpath->path.dev->bdev;
+		clone->q = bdev_get_queue(bdev);
+		clone->rq_disk = bdev->bd_disk;
+	} else if (__must_push_back(m)) {
+		clone->q = NULL;
+		clone->rq_disk = NULL;
 		r = DM_MAPIO_REQUEUE;
-	else
+	} else {
+		clone->q = NULL;
+		clone->rq_disk = NULL;
 		r = -EIO;	/* Failed */
+	}
 
 	mpio->pgpath = pgpath;
 
@@ -378,30 +388,28 @@ static void dispatch_queued_ios(struct m
 {
 	int r;
 	unsigned long flags;
-	struct bio *bio = NULL, *next;
 	struct dm_mpath_io *mpio;
 	union map_info *info;
+	struct request *clone, *n;
+	LIST_HEAD(cl);
 
 	spin_lock_irqsave(&m->lock, flags);
-	bio = bio_list_get(&m->queued_ios);
+	list_splice_init(&m->queued_ios, &cl);
 	spin_unlock_irqrestore(&m->lock, flags);
 
-	while (bio) {
-		next = bio->bi_next;
-		bio->bi_next = NULL;
+	list_for_each_entry_safe(clone, n, &cl, queuelist) {
+		list_del_init(&clone->queuelist);
 
-		info = dm_get_mapinfo(bio);
+		info = dm_get_rq_mapinfo(clone);
 		mpio = info->ptr;
 
-		r = map_io(m, bio, mpio, 1);
+		r = map_io(m, clone, mpio, 1);
 		if (r < 0)
-			bio_endio(bio, r);
+			blk_end_request(clone, r, blk_rq_bytes(clone));
 		else if (r == DM_MAPIO_REMAPPED)
-			generic_make_request(bio);
+			dm_dispatch_request(clone->q, clone);
 		else if (r == DM_MAPIO_REQUEUE)
-			bio_endio(bio, -EIO);
-
-		bio = next;
+			blk_end_request(clone, -EIO, blk_rq_bytes(clone));
 	}
 }
 
@@ -813,21 +821,26 @@ static void multipath_dtr(struct dm_targ
 }
 
 /*
- * Map bios, recording original fields for later in case we have to resubmit
+ * Map cloned requests
  */
-static int multipath_map(struct dm_target *ti, struct bio *bio,
+static int multipath_map(struct dm_target *ti, struct request *clone,
 			 union map_info *map_context)
 {
 	int r;
 	struct dm_mpath_io *mpio;
 	struct multipath *m = (struct multipath *) ti->private;
 
-	mpio = mempool_alloc(m->mpio_pool, GFP_NOIO);
-	dm_bio_record(&mpio->details, bio);
+	mpio = mempool_alloc(m->mpio_pool, GFP_ATOMIC);
+	if (!mpio)
+		/* ENOMEM, requeue */
+		return DM_MAPIO_REQUEUE;
+	memset(mpio, 0, sizeof(*mpio));
 
+	clone->cmd_flags |= REQ_FAILFAST;
+	dm_rq_record(&mpio->details, clone);
 	map_context->ptr = mpio;
-	bio->bi_rw |= (1 << BIO_RW_FAILFAST);
-	r = map_io(m, bio, mpio, 0);
+
+	r = map_io(m, clone, mpio, 0);
 	if (r < 0 || r == DM_MAPIO_REQUEUE)
 		mempool_free(mpio, m->mpio_pool);
 
@@ -1063,25 +1076,37 @@ void dm_pg_init_complete(struct dm_path 
 	spin_unlock_irqrestore(&m->lock, flags);
 }
 
+static void multipath_queue_in_tgt(struct dm_target *ti, struct request *clone,
+				   union map_info *map_context)
+{
+	struct multipath *m = (struct multipath *) ti->private;
+	struct dm_mpath_io *mpio = (struct dm_mpath_io *) map_context->ptr;
+	unsigned long flags = 0UL;
+
+	dm_rq_restore(&mpio->details, clone);
+
+	/* queue for the daemon to resubmit or fail */
+	spin_lock_irqsave(&m->lock, flags);
+	list_add_tail(&clone->queuelist, &m->queued_ios);
+	m->queue_size++;
+	if (!m->queue_io)
+		queue_work(kmultipathd, &m->process_queued_ios);
+	spin_unlock_irqrestore(&m->lock, flags);
+}
+
 /*
  * end_io handling
  */
-static int do_end_io(struct multipath *m, struct bio *bio,
-		     int error, struct dm_mpath_io *mpio)
+static int do_end_io(struct multipath *m, struct request *clone, int error,
+		     struct dm_mpath_io *mpio)
 {
 	struct hw_handler *hwh = &m->hw_handler;
 	unsigned err_flags = MP_FAIL_PATH;	/* Default behavior */
-	unsigned long flags;
+	unsigned long flags = 0UL;
 
-	if (!error)
+	if (!clone->errors && !error)
 		return 0;	/* I/O complete */
 
-	if ((error == -EWOULDBLOCK) && bio_rw_ahead(bio))
-		return error;
-
-	if (error == -EOPNOTSUPP)
-		return error;
-
 	spin_lock_irqsave(&m->lock, flags);
 	if (!m->nr_valid_paths) {
 		if (__must_push_back(m)) {
@@ -1097,8 +1122,8 @@ static int do_end_io(struct multipath *m
 	}
 	spin_unlock_irqrestore(&m->lock, flags);
 
-	if (hwh->type && hwh->type->error)
-		err_flags = hwh->type->error(hwh, bio);
+	if (hwh->type && hwh->type->error_rq)
+		err_flags = hwh->type->error_rq(hwh, clone);
 
 	if (mpio->pgpath) {
 		if (err_flags & MP_FAIL_PATH)
@@ -1112,21 +1137,14 @@ static int do_end_io(struct multipath *m
 		return -EIO;
 
       requeue:
-	dm_bio_restore(&mpio->details, bio);
-
-	/* queue for the daemon to resubmit or fail */
-	spin_lock_irqsave(&m->lock, flags);
-	bio_list_add(&m->queued_ios, bio);
-	m->queue_size++;
-	if (!m->queue_io)
-		queue_work(kmultipathd, &m->process_queued_ios);
-	spin_unlock_irqrestore(&m->lock, flags);
-
 	return DM_ENDIO_INCOMPLETE;	/* io not complete */
 }
 
-static int multipath_end_io(struct dm_target *ti, struct bio *bio,
-			    int error, union map_info *map_context)
+/*
+ * clone->q's lock must be held
+ */
+static int multipath_end_io_first(struct dm_target *ti, struct request *clone,
+				  int error, union map_info *map_context)
 {
 	struct multipath *m = ti->private;
 	struct dm_mpath_io *mpio = map_context->ptr;
@@ -1134,18 +1152,28 @@ static int multipath_end_io(struct dm_ta
 	struct path_selector *ps;
 	int r;
 
-	r  = do_end_io(m, bio, error, mpio);
+	r  = do_end_io(m, clone, error, mpio);
 	if (pgpath) {
 		ps = &pgpath->pg->ps;
 		if (ps->type->end_io)
 			ps->type->end_io(ps, &pgpath->path);
 	}
-	if (r != DM_ENDIO_INCOMPLETE)
-		mempool_free(mpio, m->mpio_pool);
 
 	return r;
 }
 
+static int multipath_end_io(struct dm_target *ti, struct request *clone,
+			    int error, union map_info *map_context)
+{
+	struct multipath *m = (struct multipath *) ti->private;
+	struct dm_mpath_io *mpio = (struct dm_mpath_io *) map_context->ptr;
+
+	if (mpio)
+		mempool_free(mpio, m->mpio_pool);
+
+	return 0;
+}
+
 /*
  * Suspend can't complete until all the I/O is processed so if
  * the last path fails we must error any remaining I/O.
@@ -1380,6 +1408,83 @@ static int multipath_ioctl(struct dm_tar
 					 bdev->bd_disk, cmd, arg);
 }
 
+static int __pgpath_congested(struct pgpath *pgpath)
+{
+	struct request_queue *q = bdev_get_queue(pgpath->path.dev->bdev);
+
+	if (dm_underlying_device_congested(q))
+		return 1;
+
+	return 0;
+}
+
+#if 0
+#define READY_PATH_EXIST	0
+#define ALL_PATH_CONGESTED	1
+#define NO_ACTIVE_PATH		2
+
+static int __pg_congested(struct priority_group *pg)
+{
+	int r = READY_PATH_EXIST, has_active = 0, has_ready = 0;
+	struct pgpath *pgpath;
+
+	list_for_each_entry(pgpath, &pg->list, list) {
+		if (pgpath->path.is_active) {
+			has_active = 1;
+
+			if (!__pgpath_congested(pgpath))
+				has_ready = 1;
+		}
+	}
+
+	if (!has_active)
+		r = NO_ACTIVE_PATH;
+	else if (!has_ready)
+		r = ALL_PATH_CONGESTED;
+
+	return r;
+}
+#endif
+
+static int multipath_congested(struct dm_target *ti)
+{
+	int r = 0;
+	struct multipath *m = (struct multipath *) ti->private;
+	unsigned long flags = 0UL;
+
+	spin_lock_irqsave(&m->lock, flags);
+
+	if (m->current_pgpath && m->repeat_count > 1) {
+		/* m->current_pgpath is surely used at next mapping time. */
+		if (__pgpath_congested(m->current_pgpath))
+			r = 1;
+
+		goto out;
+	}
+
+	/*
+	 * We are here means that path selection is executed
+	 * at next mapping time.
+	 * We run the path selection here and check congestion status
+	 * of the next path.
+	 * And increment repeat_count to avoid path selection again
+	 * in map_io(). (This is a hack for pre-decrementing repeat_count
+	 * in map_io().  Needs to be fixed this repeat_count bug.)
+	 */
+	__choose_pgpath(m);
+	if (m->current_pgpath) {
+		if (__pgpath_congested(m->current_pgpath))
+			r = 1;
+
+		m->repeat_count++;
+	}
+
+out:
+	spin_unlock_irqrestore(&m->lock, flags);
+
+	return r;
+}
+
 /*-----------------------------------------------------------------
  * Module setup
  *---------------------------------------------------------------*/
@@ -1389,13 +1494,16 @@ static struct target_type multipath_targ
 	.module = THIS_MODULE,
 	.ctr = multipath_ctr,
 	.dtr = multipath_dtr,
-	.map = multipath_map,
-	.end_io = multipath_end_io,
+	.map_rq = multipath_map,
+	.rq_end_io_first = multipath_end_io_first,
+	.rq_end_io = multipath_end_io,
+	.queue_in_tgt = multipath_queue_in_tgt,
 	.presuspend = multipath_presuspend,
 	.resume = multipath_resume,
 	.status = multipath_status,
 	.message = multipath_message,
 	.ioctl  = multipath_ioctl,
+	.congested = multipath_congested,
 };
 
 static int __init dm_multipath_init(void)
Index: 2.6.25-rc1/drivers/md/dm-rq-record.h
===================================================================
--- /dev/null
+++ 2.6.25-rc1/drivers/md/dm-rq-record.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright (C) 2007 NEC Corporation.
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef DM_RQ_RECORD_H
+#define DM_RQ_RECORD_H
+
+#include <linux/blkdev.h>
+
+/*
+ * There are lots of mutable fields in the request struct that get
+ * changed by the lower levels of the block layer.  Some targets,
+ * such as multipath, may wish to resubmit a request on error.  The
+ * functions in this file help the target record and restore the
+ * original request state.
+ */
+struct dm_rq_details {
+	unsigned int cmd_flags;
+	int ref_count;
+};
+
+static inline void dm_rq_record(struct dm_rq_details *rd, struct request *rq)
+{
+	rd->cmd_flags = rq->cmd_flags;
+	rd->ref_count = rq->ref_count;
+}
+
+static inline void dm_rq_restore(struct dm_rq_details *rd, struct request *rq)
+{
+	rq->cmd_flags = rd->cmd_flags;
+	rq->ref_count = rd->ref_count;
+}
+
+#endif
