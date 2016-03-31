From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH 4/4] dm mpath: eliminate use of spinlock in IO fast-paths
Date: Thu, 31 Mar 2016 16:04:26 -0400
Message-ID: <1459454666-76428-5-git-send-email-snitzer@redhat.com>
References: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757862AbcCaUEb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 16:04:31 -0400
In-Reply-To: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com
Cc: jmoyer@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, j-nomura@ce.jp.nec.com, hare@suse.de, sagig@dev.mellanox.co.il, Mike Snitzer <snitzer@redhat.com>

The primary motivation of this commit is to improve the scalability of
DM multipath on large NUMA systems where m->lock spinlock contention has
been proven to be a serious bottleneck on really fast storage.

The ability to atomically read a pointer, using lockless_dereference(),
is leveraged in this commit.  But all pointer writes are still protected
by the m->lock spinlock (which is fine since these all now occur in the
slow-path).

The following functions no longer require the m->lock spinlock in their
fast-path: multipath_busy(), __multipath_map(), and do_end_io()

And choose_pgpath() is modified to _not_ update m->current_pgpath unless
it also switches the path-group.  This is done to avoid needing to take
the m->lock everytime __multipath_map() calls choose_pgpath().
But m->current_pgpath will be reset if it is failed via fail_path().

Suggested-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c | 170 +++++++++++++++++++++++++++-----------------------
 1 file changed, 93 insertions(+), 77 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 54daf96..52baf8a 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -305,9 +305,21 @@ static int __pg_init_all_paths(struct multipath *m)
 	return atomic_read(&m->pg_init_in_progress);
 }
 
-static void __switch_pg(struct multipath *m, struct pgpath *pgpath)
+static int pg_init_all_paths(struct multipath *m)
 {
-	m->current_pg = pgpath->pg;
+	int r;
+	unsigned long flags;
+
+	spin_lock_irqsave(&m->lock, flags);
+	r = __pg_init_all_paths(m);
+	spin_unlock_irqrestore(&m->lock, flags);
+
+	return r;
+}
+
+static void __switch_pg(struct multipath *m, struct priority_group *pg)
+{
+	m->current_pg = pg;
 
 	/* Must we initialise the PG first, and queue I/O till it's ready? */
 	if (m->hw_handler_name) {
@@ -321,26 +333,36 @@ static void __switch_pg(struct multipath *m, struct pgpath *pgpath)
 	atomic_set(&m->pg_init_count, 0);
 }
 
-static int __choose_path_in_pg(struct multipath *m, struct priority_group *pg,
-			       size_t nr_bytes)
+static struct pgpath *choose_path_in_pg(struct multipath *m,
+					struct priority_group *pg,
+					size_t nr_bytes)
 {
+	unsigned long flags;
 	struct dm_path *path;
+	struct pgpath *pgpath;
 
 	path = pg->ps.type->select_path(&pg->ps, nr_bytes);
 	if (!path)
-		return -ENXIO;
+		return ERR_PTR(-ENXIO);
 
-	m->current_pgpath = path_to_pgpath(path);
+	pgpath = path_to_pgpath(path);
 
-	if (m->current_pg != pg)
-		__switch_pg(m, m->current_pgpath);
+	if (unlikely(lockless_dereference(m->current_pg) != pg)) {
+		/* Only update current_pgpath if pg changed */
+		spin_lock_irqsave(&m->lock, flags);
+		m->current_pgpath = pgpath;
+		__switch_pg(m, pg);
+		spin_unlock_irqrestore(&m->lock, flags);
+	}
 
-	return 0;
+	return pgpath;
 }
 
-static void __choose_pgpath(struct multipath *m, size_t nr_bytes)
+static struct pgpath *choose_pgpath(struct multipath *m, size_t nr_bytes)
 {
+	unsigned long flags;
 	struct priority_group *pg;
+	struct pgpath *pgpath;
 	bool bypassed = true;
 
 	if (!atomic_read(&m->nr_valid_paths)) {
@@ -349,16 +371,28 @@ static void __choose_pgpath(struct multipath *m, size_t nr_bytes)
 	}
 
 	/* Were we instructed to switch PG? */
-	if (m->next_pg) {
+	if (lockless_dereference(m->next_pg)) {
+		spin_lock_irqsave(&m->lock, flags);
 		pg = m->next_pg;
+		if (!pg) {
+			spin_unlock_irqrestore(&m->lock, flags);
+			goto check_current_pg;
+		}
 		m->next_pg = NULL;
-		if (!__choose_path_in_pg(m, pg, nr_bytes))
-			return;
+		spin_unlock_irqrestore(&m->lock, flags);
+		pgpath = choose_path_in_pg(m, pg, nr_bytes);
+		if (!IS_ERR_OR_NULL(pgpath))
+			return pgpath;
 	}
 
 	/* Don't change PG until it has no remaining paths */
-	if (m->current_pg && !__choose_path_in_pg(m, m->current_pg, nr_bytes))
-		return;
+check_current_pg:
+	pg = lockless_dereference(m->current_pg);
+	if (pg) {
+		pgpath = choose_path_in_pg(m, pg, nr_bytes);
+		if (!IS_ERR_OR_NULL(pgpath))
+			return pgpath;
+	}
 
 	/*
 	 * Loop through priority groups until we find a valid path.
@@ -370,31 +404,34 @@ static void __choose_pgpath(struct multipath *m, size_t nr_bytes)
 		list_for_each_entry(pg, &m->priority_groups, list) {
 			if (pg->bypassed == bypassed)
 				continue;
-			if (!__choose_path_in_pg(m, pg, nr_bytes)) {
+			pgpath = choose_path_in_pg(m, pg, nr_bytes);
+			if (!IS_ERR_OR_NULL(pgpath)) {
 				if (!bypassed)
 					set_bit(MPATHF_PG_INIT_DELAY_RETRY, &m->flags);
-				return;
+				return pgpath;
 			}
 		}
 	} while (bypassed--);
 
 failed:
+	spin_lock_irqsave(&m->lock, flags);
 	m->current_pgpath = NULL;
 	m->current_pg = NULL;
+	spin_unlock_irqrestore(&m->lock, flags);
+
+	return NULL;
 }
 
 /*
  * Check whether bios must be queued in the device-mapper core rather
  * than here in the target.
  *
- * m->lock must be held on entry.
- *
  * If m->queue_if_no_path and m->saved_queue_if_no_path hold the
  * same value then we are not between multipath_presuspend()
  * and multipath_resume() calls and we have no need to check
  * for the DMF_NOFLUSH_SUSPENDING flag.
  */
-static int __must_push_back(struct multipath *m)
+static int must_push_back(struct multipath *m)
 {
 	return (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) ||
 		((test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) !=
@@ -416,36 +453,31 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 	struct block_device *bdev;
 	struct dm_mpath_io *mpio;
 
-	spin_lock_irq(&m->lock);
-
 	/* Do we need to select a new pgpath? */
-	if (!m->current_pgpath || !test_bit(MPATHF_QUEUE_IO, &m->flags))
-		__choose_pgpath(m, nr_bytes);
-
-	pgpath = m->current_pgpath;
+	pgpath = lockless_dereference(m->current_pgpath);
+	if (!pgpath || !test_bit(MPATHF_QUEUE_IO, &m->flags))
+		pgpath = choose_pgpath(m, nr_bytes);
 
 	if (!pgpath) {
-		if (!__must_push_back(m))
+		if (!must_push_back(m))
 			r = -EIO;	/* Failed */
-		goto out_unlock;
+		return r;
 	} else if (test_bit(MPATHF_QUEUE_IO, &m->flags) ||
 		   test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags)) {
-		__pg_init_all_paths(m);
-		goto out_unlock;
+		pg_init_all_paths(m);
+		return r;
 	}
 
 	mpio = set_mpio(m, map_context);
 	if (!mpio)
 		/* ENOMEM, requeue */
-		goto out_unlock;
+		return r;
 
 	mpio->pgpath = pgpath;
 	mpio->nr_bytes = nr_bytes;
 
 	bdev = pgpath->path.dev->bdev;
 
-	spin_unlock_irq(&m->lock);
-
 	if (clone) {
 		/*
 		 * Old request-based interface: allocated clone is passed in.
@@ -477,11 +509,6 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 					      &pgpath->path,
 					      nr_bytes);
 	return DM_MAPIO_REMAPPED;
-
-out_unlock:
-	spin_unlock_irq(&m->lock);
-
-	return r;
 }
 
 static int multipath_map(struct dm_target *ti, struct request *clone,
@@ -1308,7 +1335,6 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	 * clone bios for it and resubmit it later.
 	 */
 	int r = DM_ENDIO_REQUEUE;
-	unsigned long flags;
 
 	if (!error && !clone->errors)
 		return 0;	/* I/O complete */
@@ -1319,17 +1345,15 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	if (mpio->pgpath)
 		fail_path(mpio->pgpath);
 
-	spin_lock_irqsave(&m->lock, flags);
 	if (!atomic_read(&m->nr_valid_paths)) {
 		if (!test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
-			if (!__must_push_back(m))
+			if (!must_push_back(m))
 				r = -EIO;
 		} else {
 			if (error == -EBADE)
 				r = error;
 		}
 	}
-	spin_unlock_irqrestore(&m->lock, flags);
 
 	return r;
 }
@@ -1586,18 +1610,17 @@ static int multipath_prepare_ioctl(struct dm_target *ti,
 		struct block_device **bdev, fmode_t *mode)
 {
 	struct multipath *m = ti->private;
-	unsigned long flags;
+	struct pgpath *current_pgpath;
 	int r;
 
-	spin_lock_irqsave(&m->lock, flags);
-
-	if (!m->current_pgpath)
-		__choose_pgpath(m, 0);
+	current_pgpath = lockless_dereference(m->current_pgpath);
+	if (!current_pgpath)
+		current_pgpath = choose_pgpath(m, 0);
 
-	if (m->current_pgpath) {
+	if (current_pgpath) {
 		if (!test_bit(MPATHF_QUEUE_IO, &m->flags)) {
-			*bdev = m->current_pgpath->path.dev->bdev;
-			*mode = m->current_pgpath->path.dev->mode;
+			*bdev = current_pgpath->path.dev->bdev;
+			*mode = current_pgpath->path.dev->mode;
 			r = 0;
 		} else {
 			/* pg_init has not started or completed */
@@ -1611,17 +1634,13 @@ static int multipath_prepare_ioctl(struct dm_target *ti,
 			r = -EIO;
 	}
 
-	spin_unlock_irqrestore(&m->lock, flags);
-
 	if (r == -ENOTCONN) {
-		spin_lock_irqsave(&m->lock, flags);
-		if (!m->current_pg) {
+		if (!lockless_dereference(m->current_pg)) {
 			/* Path status changed, redo selection */
-			__choose_pgpath(m, 0);
+			(void) choose_pgpath(m, 0);
 		}
 		if (test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags))
-			__pg_init_all_paths(m);
-		spin_unlock_irqrestore(&m->lock, flags);
+			pg_init_all_paths(m);
 		dm_table_run_md_queue_async(m->ti->table);
 	}
 
@@ -1672,39 +1691,37 @@ static int multipath_busy(struct dm_target *ti)
 {
 	bool busy = false, has_active = false;
 	struct multipath *m = ti->private;
-	struct priority_group *pg;
+	struct priority_group *pg, *next_pg;
 	struct pgpath *pgpath;
-	unsigned long flags;
-
-	spin_lock_irqsave(&m->lock, flags);
 
 	/* pg_init in progress or no paths available */
 	if (atomic_read(&m->pg_init_in_progress) ||
-	    (!atomic_read(&m->nr_valid_paths) && test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))) {
-		busy = true;
-		goto out;
-	}
+	    (!atomic_read(&m->nr_valid_paths) && test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)))
+		return true;
+
 	/* Guess which priority_group will be used at next mapping time */
-	if (unlikely(!m->current_pgpath && m->next_pg))
-		pg = m->next_pg;
-	else if (likely(m->current_pg))
-		pg = m->current_pg;
-	else
+	pg = lockless_dereference(m->current_pg);
+	next_pg = lockless_dereference(m->next_pg);
+	if (unlikely(!lockless_dereference(m->current_pgpath) && next_pg))
+		pg = next_pg;
+
+	if (!pg) {
 		/*
 		 * We don't know which pg will be used at next mapping time.
-		 * We don't call __choose_pgpath() here to avoid to trigger
+		 * We don't call choose_pgpath() here to avoid to trigger
 		 * pg_init just by busy checking.
 		 * So we don't know whether underlying devices we will be using
 		 * at next mapping time are busy or not. Just try mapping.
 		 */
-		goto out;
+		return busy;
+	}
 
 	/*
 	 * If there is one non-busy active path at least, the path selector
 	 * will be able to select it. So we consider such a pg as not busy.
 	 */
 	busy = true;
-	list_for_each_entry(pgpath, &pg->pgpaths, list)
+	list_for_each_entry(pgpath, &pg->pgpaths, list) {
 		if (pgpath->is_active) {
 			has_active = true;
 			if (!pgpath_busy(pgpath)) {
@@ -1712,17 +1729,16 @@ static int multipath_busy(struct dm_target *ti)
 				break;
 			}
 		}
+	}
 
-	if (!has_active)
+	if (!has_active) {
 		/*
 		 * No active path in this pg, so this pg won't be used and
 		 * the current_pg will be changed at next mapping time.
 		 * We need to try mapping to determine it.
 		 */
 		busy = false;
-
-out:
-	spin_unlock_irqrestore(&m->lock, flags);
+	}
 
 	return busy;
 }
-- 
2.6.4 (Apple Git-63)

