From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 8/8] dm-mpath: convert to request-based
Date: Fri, 03 Oct 2008 11:19:54 -0400 (EDT)
Message-ID: <20081003.111954.59650921.k-ueda@ct.jp.nec.com>
References: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: k-ueda@ct.jp.nec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, mbroz@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts dm-multipath target to request-based from bio-based.

Basically, the patch just converts the I/O unit from struct bio
to struct request.
In the course of the conversion, it also changes the I/O queueing
mechanism.  The change in the I/O queueing is described in details
as follows.

I/O queueing mechanism change
-----------------------------
In I/O submission, map_io(), there is no mechanism change from
bio-based, since the clone request is ready for retry as it is.
However, in I/O complition, do_end_io(), there is a mechanism change
from bio-based, since the clone request is not ready for retry.

In do_end_io() of bio-based, the clone bio has all needed memory
for resubmission.  So the target driver can queue it and resubmit
it later without memory allocations.
The mechanism has almost no overhead.

On the other hand, in do_end_io() of request-based, the clone request
doesn't have clone bios, so the target driver can't resubmit it
as it is.  To resubmit the clone request, memory allocation for
clone bios is needed, and it takes some overheads.
To avoid the overheads just for queueing, the target driver doesn't
queue the clone request inside itself.
Instead, the target driver asks dm core for queueing and remapping
the original request of the clone request, since the overhead for
queueing is just a freeing memory for the clone request.

As a result, the target driver doesn't need to record/restore
the information of the original request for resubmitting
the clone request.  So dm_bio_details in dm_mpath_io is removed.


multipath_busy()
---------------------
The target driver returns "busy", only when the following case:
  o The target driver will map I/Os, if map() function is called
  and
  o The mapped I/Os will wait on underlying device's queue due to
    their congestions, if map() function is called now.

In other cases, the target driver doesn't return "busy".
Otherwise, dm core will keep the I/Os and the target driver can't
do what it wants.
(e.g. the target driver can't map I/Os now, so wants to kill I/Os.)


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-mpath.c |  192 +++++++++++++++++++++++++++++++++-----------------
 1 files changed, 127 insertions(+), 65 deletions(-)

Index: 2.6.27-rc8/drivers/md/dm-mpath.c
===================================================================
--- 2.6.27-rc8.orig/drivers/md/dm-mpath.c
+++ 2.6.27-rc8/drivers/md/dm-mpath.c
@@ -7,8 +7,6 @@
 
 #include "dm.h"
 #include "dm-path-selector.h"
-#include "dm-bio-list.h"
-#include "dm-bio-record.h"
 #include "dm-uevent.h"
 
 #include <linux/ctype.h>
@@ -83,7 +81,7 @@ struct multipath {
 	unsigned pg_init_count;		/* Number of times pg_init called */
 
 	struct work_struct process_queued_ios;
-	struct bio_list queued_ios;
+	struct list_head queued_ios;
 	unsigned queue_size;
 
 	struct work_struct trigger_event;
@@ -100,7 +98,6 @@ struct multipath {
  */
 struct dm_mpath_io {
 	struct pgpath *pgpath;
-	struct dm_bio_details details;
 };
 
 typedef int (*action_fn) (struct pgpath *pgpath);
@@ -186,6 +183,7 @@ static struct multipath *alloc_multipath
 	m = kzalloc(sizeof(*m), GFP_KERNEL);
 	if (m) {
 		INIT_LIST_HEAD(&m->priority_groups);
+		INIT_LIST_HEAD(&m->queued_ios);
 		spin_lock_init(&m->lock);
 		m->queue_io = 1;
 		INIT_WORK(&m->process_queued_ios, process_queued_ios);
@@ -310,12 +308,13 @@ static int __must_push_back(struct multi
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
 
@@ -332,16 +331,18 @@ static int map_io(struct multipath *m, s
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
 		r = DM_MAPIO_SUBMITTED;
-	} else if (pgpath)
-		bio->bi_bdev = pgpath->path.dev->bdev;
-	else if (__must_push_back(m))
+	} else if (pgpath) {
+		bdev = pgpath->path.dev->bdev;
+		clone->q = bdev_get_queue(bdev);
+		clone->rq_disk = bdev->bd_disk;
+	} else if (__must_push_back(m))
 		r = DM_MAPIO_REQUEUE;
 	else
 		r = -EIO;	/* Failed */
@@ -384,30 +385,31 @@ static void dispatch_queued_ios(struct m
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
+		if (r < 0) {
+			mempool_free(mpio, m->mpio_pool);
+			dm_kill_request(clone, r);
+		} else if (r == DM_MAPIO_REMAPPED)
+			dm_dispatch_request(clone);
+		else if (r == DM_MAPIO_REQUEUE) {
+			mempool_free(mpio, m->mpio_pool);
+			dm_requeue_request(clone);
+		}
 	}
 }
 
@@ -824,21 +826,24 @@ static void multipath_dtr(struct dm_targ
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
+	r = map_io(m, clone, mpio, 0);
 	if (r < 0 || r == DM_MAPIO_REQUEUE)
 		mempool_free(mpio, m->mpio_pool);
 
@@ -1119,53 +1124,41 @@ static void activate_path(struct work_st
 /*
  * end_io handling
  */
-static int do_end_io(struct multipath *m, struct bio *bio,
+static int do_end_io(struct multipath *m, struct request *clone,
 		     int error, struct dm_mpath_io *mpio)
 {
+	/*
+	 * We don't queue any clone request inside the multipath target
+	 * during end I/O handling, since those clone requests don't have
+	 * bio clones.  If we queue them inside the multipath target,
+	 * we need to make bio clones, that requires memory allocation.
+	 * (See drivers/md/dm.c:end_clone_bio() about why the clone requests
+	 *  don't have bio clones.)
+	 * Instead of queueing the clone request here, we queue the original
+	 * request into dm core, which will remake a clone request and
+	 * clone bios for it and resubmit it later.
+	 */
+	int r = DM_ENDIO_REQUEUE;
 	unsigned long flags;
 
-	if (!error)
+	if (!error && !clone->errors)
 		return 0;	/* I/O complete */
 
-	if ((error == -EWOULDBLOCK) && bio_rw_ahead(bio))
-		return error;
-
 	if (error == -EOPNOTSUPP)
 		return error;
 
-	spin_lock_irqsave(&m->lock, flags);
-	if (!m->nr_valid_paths) {
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
-	}
-	spin_unlock_irqrestore(&m->lock, flags);
-
 	if (mpio->pgpath)
 		fail_path(mpio->pgpath);
 
-      requeue:
-	dm_bio_restore(&mpio->details, bio);
-
-	/* queue for the daemon to resubmit or fail */
 	spin_lock_irqsave(&m->lock, flags);
-	bio_list_add(&m->queued_ios, bio);
-	m->queue_size++;
-	if (!m->queue_io)
-		queue_work(kmultipathd, &m->process_queued_ios);
+	if (!m->nr_valid_paths && !m->queue_if_no_path && !__must_push_back(m))
+		r = -EIO;
 	spin_unlock_irqrestore(&m->lock, flags);
 
-	return DM_ENDIO_INCOMPLETE;	/* io not complete */
+	return r;
 }
 
-static int multipath_end_io(struct dm_target *ti, struct bio *bio,
+static int multipath_end_io(struct dm_target *ti, struct request *clone,
 			    int error, union map_info *map_context)
 {
 	struct multipath *m = ti->private;
@@ -1174,14 +1167,13 @@ static int multipath_end_io(struct dm_ta
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
@@ -1417,6 +1409,75 @@ static int multipath_ioctl(struct dm_tar
 					 bdev->bd_disk, cmd, arg);
 }
 
+static int __pgpath_busy(struct pgpath *pgpath)
+{
+	struct request_queue *q = bdev_get_queue(pgpath->path.dev->bdev);
+
+	return dm_underlying_device_busy(q);
+}
+
+/*
+ * We return "busy", only when we can map I/Os but underlying devices
+ * are busy (so even if we map I/Os now, the I/Os will wait on
+ * the underlying queue).
+ * In other words, if we want to kill I/Os or queue them inside us
+ * due to map unavailability, we don't return "busy".  Otherwise,
+ * dm core won't give us the I/Os and we can't do what we want.
+ */
+static int multipath_busy(struct dm_target *ti)
+{
+	int busy = 0, has_active = 0;
+	struct multipath *m = (struct multipath *) ti->private;
+	struct priority_group *pg;
+	struct pgpath *pgpath;
+	unsigned long flags;
+
+	spin_lock_irqsave(&m->lock, flags);
+
+	/* Guess which priority_group will be used at next mapping time */
+	if (unlikely(!m->current_pgpath && m->next_pg))
+		pg = m->next_pg;
+	else if (likely(m->current_pg))
+		pg = m->current_pg;
+	else
+		/*
+		 * We don't know which pg will be used at next mapping time.
+		 * We don't call __choose_pgpath() here to avoid to trigger
+		 * pg_init just by busy checking.
+		 * So we don't know whether underlying devices we will be using
+		 * at next mapping time are busy or not. Just try mapping.
+		 */
+		goto out;
+
+	/*
+	 * If there is one non-busy active path at least, the path selector
+	 * will be able to select it. So we consider such a pg as not busy.
+	 */
+	busy = 1;
+	list_for_each_entry(pgpath, &pg->pgpaths, list)
+		if (pgpath->is_active) {
+			has_active = 1;
+
+			if (!__pgpath_busy(pgpath)) {
+				busy = 0;
+				break;
+			}
+		}
+
+	if (!has_active)
+		/*
+		 * No active path in this pg, so this pg won't be used and
+		 * the current_pg will be changed at next mapping time.
+		 * We need to try mapping to determine it.
+		 */
+		busy = 0;
+
+out:
+	spin_unlock_irqrestore(&m->lock, flags);
+
+	return busy;
+}
+
 /*-----------------------------------------------------------------
  * Module setup
  *---------------------------------------------------------------*/
@@ -1426,13 +1487,14 @@ static struct target_type multipath_targ
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
+	.busy = multipath_busy,
 };
 
 static int __init dm_multipath_init(void)
