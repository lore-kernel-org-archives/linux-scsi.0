From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 13/13] dm-mpath: convert to request-based
Date: Wed, 19 Mar 2008 18:12:12 -0500 (EST)
Message-ID: <20080319.181212.106439712.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, michaelc@cs.wisc.edu, hare@suse.de, agk@redhat.com, linux-kernel@vger.kernel.org
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch converts dm-multipath target to request-based from bio-based.

In I/O completion, the clone request doesn't have clone bios,
so the target driver can't resubmit it as it is, even if the target
driver wants to retry it using another path.
To resubmit the clone request, memory allocation for clone bios is
needed.  There is no big benefit to resubmit the clone request.

So the target driver doesn't requeue a clone in the target queue.
Instead, the target driver ask dm core for requeueing and remapping
the original request of the clone (do_end_io()).
As a result, the target driver don't need to record/restore
the information of the original request for resubmitting the clone.


Actual path selection is done at congestion state checking time
(multipath_congested()), since we'd like to check the path which
will be definitely used for next I/O.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm-mpath.c |  175 +++++++++++++++++++++++++++++++-------------------
 1 files changed, 109 insertions(+), 66 deletions(-)

Index: 2.6.25-rc5/drivers/md/dm-mpath.c
===================================================================
--- 2.6.25-rc5.orig/drivers/md/dm-mpath.c
+++ 2.6.25-rc5/drivers/md/dm-mpath.c
@@ -8,8 +8,6 @@
 #include "dm.h"
 #include "dm-path-selector.h"
 #include "dm-hw-handler.h"
-#include "dm-bio-list.h"
-#include "dm-bio-record.h"
 #include "dm-uevent.h"
 
 #include <linux/ctype.h>
@@ -80,7 +78,7 @@ struct multipath {
 	unsigned pg_init_count;		/* Number of times pg_init called */
 
 	struct work_struct process_queued_ios;
-	struct bio_list queued_ios;
+	struct list_head queued_ios;
 	unsigned queue_size;
 
 	struct work_struct trigger_event;
@@ -97,7 +95,6 @@ struct multipath {
  */
 struct dm_mpath_io {
 	struct pgpath *pgpath;
-	struct dm_bio_details details;
 };
 
 typedef int (*action_fn) (struct pgpath *pgpath);
@@ -174,6 +171,7 @@ static struct multipath *alloc_multipath
 	m = kzalloc(sizeof(*m), GFP_KERNEL);
 	if (m) {
 		INIT_LIST_HEAD(&m->priority_groups);
+		INIT_LIST_HEAD(&m->queued_ios);
 		spin_lock_init(&m->lock);
 		m->queue_io = 1;
 		INIT_WORK(&m->process_queued_ios, process_queued_ios);
@@ -304,12 +302,13 @@ static int __must_push_back(struct multi
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
 
@@ -326,19 +325,28 @@ static int map_io(struct multipath *m, s
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
 
@@ -378,30 +386,29 @@ static void dispatch_queued_ios(struct m
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
-		if (r < 0)
-			bio_endio(bio, r);
-		else if (r == DM_MAPIO_REMAPPED)
-			generic_make_request(bio);
-		else if (r == DM_MAPIO_REQUEUE)
-			bio_endio(bio, -EIO);
-
-		bio = next;
+		r = map_io(m, clone, mpio, 1);
+		if (r < 0 || r == DM_MAPIO_REQUEUE) {
+			mempool_free(mpio, m->mpio_pool);
+			if (r == DM_MAPIO_REQUEUE)
+				r = DM_ENDIO_REQUEUE;
+			dm_end_request(clone, r);
+		} else if (r == DM_MAPIO_REMAPPED)
+			dm_dispatch_request(clone);
 	}
 }
 
@@ -813,21 +820,25 @@ static void multipath_dtr(struct dm_targ
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
 
 	map_context->ptr = mpio;
-	bio->bi_rw |= (1 << BIO_RW_FAILFAST);
-	r = map_io(m, bio, mpio, 0);
+	clone->cmd_flags |= REQ_FAILFAST;
+
+	r = map_io(m, clone, mpio, 0);
 	if (r < 0 || r == DM_MAPIO_REQUEUE)
 		mempool_free(mpio, m->mpio_pool);
 
@@ -1066,39 +1077,34 @@ void dm_pg_init_complete(struct dm_path 
 /*
  * end_io handling
  */
-static int do_end_io(struct multipath *m, struct bio *bio,
+static int do_end_io(struct multipath *m, struct request *clone,
 		     int error, struct dm_mpath_io *mpio)
 {
 	struct hw_handler *hwh = &m->hw_handler;
 	unsigned err_flags = MP_FAIL_PATH;	/* Default behavior */
 	unsigned long flags;
+	int r;
 
-	if (!error)
+	if (!error && !clone->errors)
 		return 0;	/* I/O complete */
 
-	if ((error == -EWOULDBLOCK) && bio_rw_ahead(bio))
-		return error;
-
 	if (error == -EOPNOTSUPP)
 		return error;
 
 	spin_lock_irqsave(&m->lock, flags);
 	if (!m->nr_valid_paths) {
-		if (__must_push_back(m)) {
-			spin_unlock_irqrestore(&m->lock, flags);
-			return DM_ENDIO_REQUEUE;
-		} else if (!m->queue_if_no_path) {
-			spin_unlock_irqrestore(&m->lock, flags);
-			return -EIO;
-		} else {
-			spin_unlock_irqrestore(&m->lock, flags);
-			goto requeue;
-		}
+		if (__must_push_back(m) || m->queue_if_no_path)
+			r = DM_ENDIO_REQUEUE;
+		else
+			r = -EIO;
+
+		spin_unlock_irqrestore(&m->lock, flags);
+		return r;
 	}
 	spin_unlock_irqrestore(&m->lock, flags);
 
-	if (hwh->type && hwh->type->error)
-		err_flags = hwh->type->error(hwh, bio);
+	if (hwh->type && hwh->type->error_rq)
+		err_flags = hwh->type->error_rq(hwh, clone);
 
 	if (mpio->pgpath) {
 		if (err_flags & MP_FAIL_PATH)
@@ -1111,21 +1117,10 @@ static int do_end_io(struct multipath *m
 	if (err_flags & MP_ERROR_IO)
 		return -EIO;
 
-      requeue:
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
-	return DM_ENDIO_INCOMPLETE;	/* io not complete */
+	return DM_ENDIO_REQUEUE;
 }
 
-static int multipath_end_io(struct dm_target *ti, struct bio *bio,
+static int multipath_end_io(struct dm_target *ti, struct request *clone,
 			    int error, union map_info *map_context)
 {
 	struct multipath *m = ti->private;
@@ -1134,14 +1129,13 @@ static int multipath_end_io(struct dm_ta
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
+	mempool_free(mpio, m->mpio_pool);
 
 	return r;
 }
@@ -1380,6 +1374,54 @@ static int multipath_ioctl(struct dm_tar
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
+static int multipath_congested(struct dm_target *ti)
+{
+	int congested = 0;
+	struct multipath *m = (struct multipath *) ti->private;
+	unsigned long flags;
+
+	spin_lock_irqsave(&m->lock, flags);
+
+	if (m->current_pgpath && m->repeat_count > 1) {
+		/* m->current_pgpath is surely used at next mapping time. */
+		if (__pgpath_congested(m->current_pgpath))
+			congested = 1;
+
+		goto out;
+	}
+
+	/*
+	 * We are here means that path selection will be executed
+	 * at next mapping time.
+	 * We run the path selection here and check congestion status
+	 * of the next path.
+	 * And increment repeat_count to avoid path selection again
+	 * in map_io().
+	 */
+	__choose_pgpath(m);
+	if (m->current_pgpath) {
+		if (__pgpath_congested(m->current_pgpath))
+			congested = 1;
+
+		m->repeat_count++;
+	}
+
+out:
+	spin_unlock_irqrestore(&m->lock, flags);
+
+	return congested;
+}
+
 /*-----------------------------------------------------------------
  * Module setup
  *---------------------------------------------------------------*/
@@ -1389,13 +1431,14 @@ static struct target_type multipath_targ
 	.module = THIS_MODULE,
 	.ctr = multipath_ctr,
 	.dtr = multipath_dtr,
-	.map = multipath_map,
-	.end_io = multipath_end_io,
+	.map_rq = multipath_map,
+	.rq_end_io = multipath_end_io,
 	.presuspend = multipath_presuspend,
 	.resume = multipath_resume,
 	.status = multipath_status,
 	.message = multipath_message,
 	.ioctl  = multipath_ioctl,
+	.congested = multipath_congested,
 };
 
 static int __init dm_multipath_init(void)
