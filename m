From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH 1/4] dm mpath: switch to using bitops for state flags
Date: Thu, 31 Mar 2016 16:04:23 -0400
Message-ID: <1459454666-76428-2-git-send-email-snitzer@redhat.com>
References: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757741AbcCaUE2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 16:04:28 -0400
In-Reply-To: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com
Cc: jmoyer@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, j-nomura@ce.jp.nec.com, hare@suse.de, sagig@dev.mellanox.co.il, Mike Snitzer <snitzer@redhat.com>

Mechanical change that doesn't make any real effort to reduce the use of
m->lock; that will come later (once atomics are used for counters, etc).

Suggested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c | 131 +++++++++++++++++++++++++++++---------------------
 1 file changed, 75 insertions(+), 56 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 677ba22..598d4a1 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -83,13 +83,7 @@ struct multipath {
 	struct priority_group *current_pg;
 	struct priority_group *next_pg;	/* Switch to this PG if set */
 
-	bool queue_io:1;		/* Must we queue all I/O? */
-	bool queue_if_no_path:1;	/* Queue I/O if last path fails? */
-	bool saved_queue_if_no_path:1;	/* Saved state during suspension */
-	bool retain_attached_hw_handler:1; /* If there's already a hw_handler present, don't change it. */
-	bool pg_init_disabled:1;	/* pg_init is not currently allowed */
-	bool pg_init_required:1;	/* pg_init needs calling? */
-	bool pg_init_delay_retry:1;	/* Delay pg_init retry? */
+	unsigned long flags;		/* Multipath state flags */
 
 	unsigned pg_init_retries;	/* Number of times to retry pg_init */
 	unsigned pg_init_count;		/* Number of times pg_init called */
@@ -122,6 +116,17 @@ static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
 static void trigger_event(struct work_struct *work);
 static void activate_path(struct work_struct *work);
 
+/*-----------------------------------------------
+ * Multipath state flags.
+ *-----------------------------------------------*/
+
+#define MPATHF_QUEUE_IO 0			/* Must we queue all I/O? */
+#define MPATHF_QUEUE_IF_NO_PATH 1		/* Queue I/O if last path fails? */
+#define MPATHF_SAVED_QUEUE_IF_NO_PATH 2		/* Saved state during suspension */
+#define MPATHF_RETAIN_ATTACHED_HW_HANDLER 3	/* If there's already a hw_handler present, don't change it. */
+#define MPATHF_PG_INIT_DISABLED 4		/* pg_init is not currently allowed */
+#define MPATHF_PG_INIT_REQUIRED 5		/* pg_init needs calling? */
+#define MPATHF_PG_INIT_DELAY_RETRY 6		/* Delay pg_init retry? */
 
 /*-----------------------------------------------
  * Allocation routines
@@ -189,7 +194,7 @@ static struct multipath *alloc_multipath(struct dm_target *ti, bool use_blk_mq)
 	if (m) {
 		INIT_LIST_HEAD(&m->priority_groups);
 		spin_lock_init(&m->lock);
-		m->queue_io = true;
+		set_bit(MPATHF_QUEUE_IO, &m->flags);
 		m->pg_init_delay_msecs = DM_PG_INIT_DELAY_DEFAULT;
 		INIT_WORK(&m->trigger_event, trigger_event);
 		init_waitqueue_head(&m->pg_init_wait);
@@ -274,17 +279,17 @@ static int __pg_init_all_paths(struct multipath *m)
 	struct pgpath *pgpath;
 	unsigned long pg_init_delay = 0;
 
-	if (m->pg_init_in_progress || m->pg_init_disabled)
+	if (m->pg_init_in_progress || test_bit(MPATHF_PG_INIT_DISABLED, &m->flags))
 		return 0;
 
 	m->pg_init_count++;
-	m->pg_init_required = false;
+	clear_bit(MPATHF_PG_INIT_REQUIRED, &m->flags);
 
 	/* Check here to reset pg_init_required */
 	if (!m->current_pg)
 		return 0;
 
-	if (m->pg_init_delay_retry)
+	if (test_bit(MPATHF_PG_INIT_DELAY_RETRY, &m->flags))
 		pg_init_delay = msecs_to_jiffies(m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT ?
 						 m->pg_init_delay_msecs : DM_PG_INIT_DELAY_MSECS);
 	list_for_each_entry(pgpath, &m->current_pg->pgpaths, list) {
@@ -304,11 +309,11 @@ static void __switch_pg(struct multipath *m, struct pgpath *pgpath)
 
 	/* Must we initialise the PG first, and queue I/O till it's ready? */
 	if (m->hw_handler_name) {
-		m->pg_init_required = true;
-		m->queue_io = true;
+		set_bit(MPATHF_PG_INIT_REQUIRED, &m->flags);
+		set_bit(MPATHF_QUEUE_IO, &m->flags);
 	} else {
-		m->pg_init_required = false;
-		m->queue_io = false;
+		clear_bit(MPATHF_PG_INIT_REQUIRED, &m->flags);
+		clear_bit(MPATHF_QUEUE_IO, &m->flags);
 	}
 
 	m->pg_init_count = 0;
@@ -337,7 +342,7 @@ static void __choose_pgpath(struct multipath *m, size_t nr_bytes)
 	bool bypassed = true;
 
 	if (!m->nr_valid_paths) {
-		m->queue_io = false;
+		clear_bit(MPATHF_QUEUE_IO, &m->flags);
 		goto failed;
 	}
 
@@ -365,7 +370,7 @@ static void __choose_pgpath(struct multipath *m, size_t nr_bytes)
 				continue;
 			if (!__choose_path_in_pg(m, pg, nr_bytes)) {
 				if (!bypassed)
-					m->pg_init_delay_retry = true;
+					set_bit(MPATHF_PG_INIT_DELAY_RETRY, &m->flags);
 				return;
 			}
 		}
@@ -389,8 +394,9 @@ failed:
  */
 static int __must_push_back(struct multipath *m)
 {
-	return (m->queue_if_no_path ||
-		(m->queue_if_no_path != m->saved_queue_if_no_path &&
+	return (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) ||
+		((test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) !=
+		  test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags)) &&
 		 dm_noflush_suspending(m->ti)));
 }
 
@@ -411,7 +417,7 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 	spin_lock_irq(&m->lock);
 
 	/* Do we need to select a new pgpath? */
-	if (!m->current_pgpath || !m->queue_io)
+	if (!m->current_pgpath || !test_bit(MPATHF_QUEUE_IO, &m->flags))
 		__choose_pgpath(m, nr_bytes);
 
 	pgpath = m->current_pgpath;
@@ -420,7 +426,8 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 		if (!__must_push_back(m))
 			r = -EIO;	/* Failed */
 		goto out_unlock;
-	} else if (m->queue_io || m->pg_init_required) {
+	} else if (test_bit(MPATHF_QUEUE_IO, &m->flags) ||
+		   test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags)) {
 		__pg_init_all_paths(m);
 		goto out_unlock;
 	}
@@ -503,11 +510,22 @@ static int queue_if_no_path(struct multipath *m, bool queue_if_no_path,
 
 	spin_lock_irqsave(&m->lock, flags);
 
-	if (save_old_value)
-		m->saved_queue_if_no_path = m->queue_if_no_path;
+	if (save_old_value) {
+		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
+			set_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
+		else
+			clear_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
+	} else {
+		if (queue_if_no_path)
+			set_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
+		else
+			clear_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
+	}
+	if (queue_if_no_path)
+		set_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
 	else
-		m->saved_queue_if_no_path = queue_if_no_path;
-	m->queue_if_no_path = queue_if_no_path;
+		clear_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
+
 	spin_unlock_irqrestore(&m->lock, flags);
 
 	if (!queue_if_no_path)
@@ -600,10 +618,10 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 		goto bad;
 	}
 
-	if (m->retain_attached_hw_handler || m->hw_handler_name)
+	if (test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags) || m->hw_handler_name)
 		q = bdev_get_queue(p->path.dev->bdev);
 
-	if (m->retain_attached_hw_handler) {
+	if (test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags)) {
 retain:
 		attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
 		if (attached_handler_name) {
@@ -808,7 +826,7 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 		}
 
 		if (!strcasecmp(arg_name, "retain_attached_hw_handler")) {
-			m->retain_attached_hw_handler = true;
+			set_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags);
 			continue;
 		}
 
@@ -944,20 +962,16 @@ static void multipath_wait_for_pg_init_completion(struct multipath *m)
 
 static void flush_multipath_work(struct multipath *m)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&m->lock, flags);
-	m->pg_init_disabled = true;
-	spin_unlock_irqrestore(&m->lock, flags);
+	set_bit(MPATHF_PG_INIT_DISABLED, &m->flags);
+	smp_mb__after_atomic();
 
 	flush_workqueue(kmpath_handlerd);
 	multipath_wait_for_pg_init_completion(m);
 	flush_workqueue(kmultipathd);
 	flush_work(&m->trigger_event);
 
-	spin_lock_irqsave(&m->lock, flags);
-	m->pg_init_disabled = false;
-	spin_unlock_irqrestore(&m->lock, flags);
+	clear_bit(MPATHF_PG_INIT_DISABLED, &m->flags);
+	smp_mb__after_atomic();
 }
 
 static void multipath_dtr(struct dm_target *ti)
@@ -1152,8 +1166,8 @@ static bool pg_init_limit_reached(struct multipath *m, struct pgpath *pgpath)
 
 	spin_lock_irqsave(&m->lock, flags);
 
-	if (m->pg_init_count <= m->pg_init_retries && !m->pg_init_disabled)
-		m->pg_init_required = true;
+	if (m->pg_init_count <= m->pg_init_retries && !test_bit(MPATHF_PG_INIT_DISABLED, &m->flags))
+		set_bit(MPATHF_PG_INIT_REQUIRED, &m->flags);
 	else
 		limit_reached = true;
 
@@ -1219,19 +1233,23 @@ static void pg_init_done(void *data, int errors)
 			m->current_pgpath = NULL;
 			m->current_pg = NULL;
 		}
-	} else if (!m->pg_init_required)
+	} else if (!test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags))
 		pg->bypassed = false;
 
 	if (--m->pg_init_in_progress)
 		/* Activations of other paths are still on going */
 		goto out;
 
-	if (m->pg_init_required) {
-		m->pg_init_delay_retry = delay_retry;
+	if (test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags)) {
+		if (delay_retry)
+			set_bit(MPATHF_PG_INIT_DELAY_RETRY, &m->flags);
+		else
+			clear_bit(MPATHF_PG_INIT_DELAY_RETRY, &m->flags);
+
 		if (__pg_init_all_paths(m))
 			goto out;
 	}
-	m->queue_io = false;
+	clear_bit(MPATHF_QUEUE_IO, &m->flags);
 
 	/*
 	 * Wake up any thread waiting to suspend.
@@ -1300,7 +1318,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
 
 	spin_lock_irqsave(&m->lock, flags);
 	if (!m->nr_valid_paths) {
-		if (!m->queue_if_no_path) {
+		if (!test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
 			if (!__must_push_back(m))
 				r = -EIO;
 		} else {
@@ -1364,11 +1382,12 @@ static void multipath_postsuspend(struct dm_target *ti)
 static void multipath_resume(struct dm_target *ti)
 {
 	struct multipath *m = ti->private;
-	unsigned long flags;
 
-	spin_lock_irqsave(&m->lock, flags);
-	m->queue_if_no_path = m->saved_queue_if_no_path;
-	spin_unlock_irqrestore(&m->lock, flags);
+	if (test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags))
+		set_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
+	else
+		clear_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
+	smp_mb__after_atomic();
 }
 
 /*
@@ -1402,19 +1421,19 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 
 	/* Features */
 	if (type == STATUSTYPE_INFO)
-		DMEMIT("2 %u %u ", m->queue_io, m->pg_init_count);
+		DMEMIT("2 %u %u ", test_bit(MPATHF_QUEUE_IO, &m->flags), m->pg_init_count);
 	else {
-		DMEMIT("%u ", m->queue_if_no_path +
+		DMEMIT("%u ", test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) +
 			      (m->pg_init_retries > 0) * 2 +
 			      (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT) * 2 +
-			      m->retain_attached_hw_handler);
-		if (m->queue_if_no_path)
+			      test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags));
+		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
 			DMEMIT("queue_if_no_path ");
 		if (m->pg_init_retries)
 			DMEMIT("pg_init_retries %u ", m->pg_init_retries);
 		if (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT)
 			DMEMIT("pg_init_delay_msecs %u ", m->pg_init_delay_msecs);
-		if (m->retain_attached_hw_handler)
+		if (test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags))
 			DMEMIT("retain_attached_hw_handler ");
 	}
 
@@ -1572,7 +1591,7 @@ static int multipath_prepare_ioctl(struct dm_target *ti,
 		__choose_pgpath(m, 0);
 
 	if (m->current_pgpath) {
-		if (!m->queue_io) {
+		if (!test_bit(MPATHF_QUEUE_IO, &m->flags)) {
 			*bdev = m->current_pgpath->path.dev->bdev;
 			*mode = m->current_pgpath->path.dev->mode;
 			r = 0;
@@ -1582,7 +1601,7 @@ static int multipath_prepare_ioctl(struct dm_target *ti,
 		}
 	} else {
 		/* No path is available */
-		if (m->queue_if_no_path)
+		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
 			r = -ENOTCONN;
 		else
 			r = -EIO;
@@ -1596,7 +1615,7 @@ static int multipath_prepare_ioctl(struct dm_target *ti,
 			/* Path status changed, redo selection */
 			__choose_pgpath(m, 0);
 		}
-		if (m->pg_init_required)
+		if (test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags))
 			__pg_init_all_paths(m);
 		spin_unlock_irqrestore(&m->lock, flags);
 		dm_table_run_md_queue_async(m->ti->table);
@@ -1657,7 +1676,7 @@ static int multipath_busy(struct dm_target *ti)
 
 	/* pg_init in progress or no paths available */
 	if (m->pg_init_in_progress ||
-	    (!m->nr_valid_paths && m->queue_if_no_path)) {
+	    (!m->nr_valid_paths && test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))) {
 		busy = true;
 		goto out;
 	}
-- 
2.6.4 (Apple Git-63)

