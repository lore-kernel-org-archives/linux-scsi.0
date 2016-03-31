From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH 2/4] dm mpath: use atomic_t for counting members of 'struct multipath'
Date: Thu, 31 Mar 2016 16:04:24 -0400
Message-ID: <1459454666-76428-3-git-send-email-snitzer@redhat.com>
References: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757781AbcCaUE3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 16:04:29 -0400
In-Reply-To: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com
Cc: jmoyer@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, j-nomura@ce.jp.nec.com, hare@suse.de, sagig@dev.mellanox.co.il, Mike Snitzer <snitzer@redhat.com>

The use of atomic_t for nr_valid_paths, pg_init_in_progress and
pg_init_count will allow relaxing the use of the m->lock spinlock.

Suggested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c | 61 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 28 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 598d4a1..780e5d0 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -76,9 +76,6 @@ struct multipath {
 
 	wait_queue_head_t pg_init_wait;	/* Wait for pg_init completion */
 
-	unsigned pg_init_in_progress;	/* Only one pg_init allowed at once */
-
-	unsigned nr_valid_paths;	/* Total number of usable paths */
 	struct pgpath *current_pgpath;
 	struct priority_group *current_pg;
 	struct priority_group *next_pg;	/* Switch to this PG if set */
@@ -86,9 +83,12 @@ struct multipath {
 	unsigned long flags;		/* Multipath state flags */
 
 	unsigned pg_init_retries;	/* Number of times to retry pg_init */
-	unsigned pg_init_count;		/* Number of times pg_init called */
 	unsigned pg_init_delay_msecs;	/* Number of msecs before pg_init retry */
 
+	atomic_t nr_valid_paths;	/* Total number of usable paths */
+	atomic_t pg_init_in_progress;	/* Only one pg_init allowed at once */
+	atomic_t pg_init_count;		/* Number of times pg_init called */
+
 	struct work_struct trigger_event;
 
 	/*
@@ -195,6 +195,9 @@ static struct multipath *alloc_multipath(struct dm_target *ti, bool use_blk_mq)
 		INIT_LIST_HEAD(&m->priority_groups);
 		spin_lock_init(&m->lock);
 		set_bit(MPATHF_QUEUE_IO, &m->flags);
+		atomic_set(&m->nr_valid_paths, 0);
+		atomic_set(&m->pg_init_in_progress, 0);
+		atomic_set(&m->pg_init_count, 0);
 		m->pg_init_delay_msecs = DM_PG_INIT_DELAY_DEFAULT;
 		INIT_WORK(&m->trigger_event, trigger_event);
 		init_waitqueue_head(&m->pg_init_wait);
@@ -279,10 +282,10 @@ static int __pg_init_all_paths(struct multipath *m)
 	struct pgpath *pgpath;
 	unsigned long pg_init_delay = 0;
 
-	if (m->pg_init_in_progress || test_bit(MPATHF_PG_INIT_DISABLED, &m->flags))
+	if (atomic_read(&m->pg_init_in_progress) || test_bit(MPATHF_PG_INIT_DISABLED, &m->flags))
 		return 0;
 
-	m->pg_init_count++;
+	atomic_inc(&m->pg_init_count);
 	clear_bit(MPATHF_PG_INIT_REQUIRED, &m->flags);
 
 	/* Check here to reset pg_init_required */
@@ -298,9 +301,9 @@ static int __pg_init_all_paths(struct multipath *m)
 			continue;
 		if (queue_delayed_work(kmpath_handlerd, &pgpath->activate_path,
 				       pg_init_delay))
-			m->pg_init_in_progress++;
+			atomic_inc(&m->pg_init_in_progress);
 	}
-	return m->pg_init_in_progress;
+	return atomic_read(&m->pg_init_in_progress);
 }
 
 static void __switch_pg(struct multipath *m, struct pgpath *pgpath)
@@ -316,7 +319,7 @@ static void __switch_pg(struct multipath *m, struct pgpath *pgpath)
 		clear_bit(MPATHF_QUEUE_IO, &m->flags);
 	}
 
-	m->pg_init_count = 0;
+	atomic_set(&m->pg_init_count, 0);
 }
 
 static int __choose_path_in_pg(struct multipath *m, struct priority_group *pg,
@@ -341,7 +344,7 @@ static void __choose_pgpath(struct multipath *m, size_t nr_bytes)
 	struct priority_group *pg;
 	bool bypassed = true;
 
-	if (!m->nr_valid_paths) {
+	if (!atomic_read(&m->nr_valid_paths)) {
 		clear_bit(MPATHF_QUEUE_IO, &m->flags);
 		goto failed;
 	}
@@ -902,6 +905,7 @@ static int multipath_ctr(struct dm_target *ti, unsigned int argc,
 	/* parse the priority groups */
 	while (as.argc) {
 		struct priority_group *pg;
+		unsigned nr_valid_paths = atomic_read(&m->nr_valid_paths);
 
 		pg = parse_priority_group(&as, m);
 		if (IS_ERR(pg)) {
@@ -909,7 +913,9 @@ static int multipath_ctr(struct dm_target *ti, unsigned int argc,
 			goto bad;
 		}
 
-		m->nr_valid_paths += pg->nr_pgpaths;
+		nr_valid_paths += pg->nr_pgpaths;
+		atomic_set(&m->nr_valid_paths, nr_valid_paths);
+
 		list_add_tail(&pg->list, &m->priority_groups);
 		pg_count++;
 		pg->pg_num = pg_count;
@@ -939,19 +945,14 @@ static int multipath_ctr(struct dm_target *ti, unsigned int argc,
 static void multipath_wait_for_pg_init_completion(struct multipath *m)
 {
 	DECLARE_WAITQUEUE(wait, current);
-	unsigned long flags;
 
 	add_wait_queue(&m->pg_init_wait, &wait);
 
 	while (1) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 
-		spin_lock_irqsave(&m->lock, flags);
-		if (!m->pg_init_in_progress) {
-			spin_unlock_irqrestore(&m->lock, flags);
+		if (!atomic_read(&m->pg_init_in_progress))
 			break;
-		}
-		spin_unlock_irqrestore(&m->lock, flags);
 
 		io_schedule();
 	}
@@ -1001,13 +1002,13 @@ static int fail_path(struct pgpath *pgpath)
 	pgpath->is_active = false;
 	pgpath->fail_count++;
 
-	m->nr_valid_paths--;
+	atomic_dec(&m->nr_valid_paths);
 
 	if (pgpath == m->current_pgpath)
 		m->current_pgpath = NULL;
 
 	dm_path_uevent(DM_UEVENT_PATH_FAILED, m->ti,
-		      pgpath->path.dev->name, m->nr_valid_paths);
+		       pgpath->path.dev->name, atomic_read(&m->nr_valid_paths));
 
 	schedule_work(&m->trigger_event);
 
@@ -1025,6 +1026,7 @@ static int reinstate_path(struct pgpath *pgpath)
 	int r = 0, run_queue = 0;
 	unsigned long flags;
 	struct multipath *m = pgpath->pg->m;
+	unsigned nr_valid_paths;
 
 	spin_lock_irqsave(&m->lock, flags);
 
@@ -1039,16 +1041,17 @@ static int reinstate_path(struct pgpath *pgpath)
 
 	pgpath->is_active = true;
 
-	if (!m->nr_valid_paths++) {
+	nr_valid_paths = atomic_inc_return(&m->nr_valid_paths);
+	if (nr_valid_paths == 1) {
 		m->current_pgpath = NULL;
 		run_queue = 1;
 	} else if (m->hw_handler_name && (m->current_pg == pgpath->pg)) {
 		if (queue_work(kmpath_handlerd, &pgpath->activate_path.work))
-			m->pg_init_in_progress++;
+			atomic_inc(&m->pg_init_in_progress);
 	}
 
 	dm_path_uevent(DM_UEVENT_PATH_REINSTATED, m->ti,
-		      pgpath->path.dev->name, m->nr_valid_paths);
+		       pgpath->path.dev->name, nr_valid_paths);
 
 	schedule_work(&m->trigger_event);
 
@@ -1166,7 +1169,8 @@ static bool pg_init_limit_reached(struct multipath *m, struct pgpath *pgpath)
 
 	spin_lock_irqsave(&m->lock, flags);
 
-	if (m->pg_init_count <= m->pg_init_retries && !test_bit(MPATHF_PG_INIT_DISABLED, &m->flags))
+	if (atomic_read(&m->pg_init_count) <= m->pg_init_retries &&
+	    !test_bit(MPATHF_PG_INIT_DISABLED, &m->flags))
 		set_bit(MPATHF_PG_INIT_REQUIRED, &m->flags);
 	else
 		limit_reached = true;
@@ -1236,7 +1240,7 @@ static void pg_init_done(void *data, int errors)
 	} else if (!test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags))
 		pg->bypassed = false;
 
-	if (--m->pg_init_in_progress)
+	if (atomic_dec_return(&m->pg_init_in_progress) > 0)
 		/* Activations of other paths are still on going */
 		goto out;
 
@@ -1317,7 +1321,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
 		fail_path(mpio->pgpath);
 
 	spin_lock_irqsave(&m->lock, flags);
-	if (!m->nr_valid_paths) {
+	if (!atomic_read(&m->nr_valid_paths)) {
 		if (!test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
 			if (!__must_push_back(m))
 				r = -EIO;
@@ -1421,7 +1425,8 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 
 	/* Features */
 	if (type == STATUSTYPE_INFO)
-		DMEMIT("2 %u %u ", test_bit(MPATHF_QUEUE_IO, &m->flags), m->pg_init_count);
+		DMEMIT("2 %u %u ", test_bit(MPATHF_QUEUE_IO, &m->flags),
+		       atomic_read(&m->pg_init_count));
 	else {
 		DMEMIT("%u ", test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) +
 			      (m->pg_init_retries > 0) * 2 +
@@ -1675,8 +1680,8 @@ static int multipath_busy(struct dm_target *ti)
 	spin_lock_irqsave(&m->lock, flags);
 
 	/* pg_init in progress or no paths available */
-	if (m->pg_init_in_progress ||
-	    (!m->nr_valid_paths && test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))) {
+	if (atomic_read(&m->pg_init_in_progress) ||
+	    (!atomic_read(&m->nr_valid_paths) && test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))) {
 		busy = true;
 		goto out;
 	}
-- 
2.6.4 (Apple Git-63)

