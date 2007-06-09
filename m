From: michaelc@cs.wisc.edu
Subject: [PATCH 5/7] scsi-hw-handler: convert dm-mpath to scsi hw
	handlers
Date: Sat, 09 Jun 2007 14:08:02 -0500
Message-ID: <11814160881707-git-send-email-michaelc@cs.wisc.edu>
References: <11814160842916-git-send-email-michaelc@cs.wisc.edu>
	<11814160853812-git-send-email-michaelc@cs.wisc.edu>
	<1181416085774-git-send-email-michaelc@cs.wisc.edu>
	<11814160863051-git-send-email-michaelc@cs.wisc.edu>
	<11814160871580-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu,
	device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11814160871580-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-scsi@vger.kernel.org, dm-devel@redhat.com
Cc: Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

This patch converts dm-mpath to scsi hw handlers. It does
not add any new functionality and old behaviors and userspace
tools should be supported except we use the safe clariion
default instead of using the userspace setting.

This is just the dm-mpath parts which are necessary to use
REQ_TYPE_LINUX_BLOCK and REQ_LB_OP_TRANSITION. In later mails
I will send patches which remove old code and add more
functionality.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/md/dm-mpath.c |  199 +++++++++++++++++++++++++++----------------------
 1 files changed, 111 insertions(+), 88 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index de54b39..5655d16 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -7,7 +7,6 @@
 
 #include "dm.h"
 #include "dm-path-selector.h"
-#include "dm-hw-handler.h"
 #include "dm-bio-list.h"
 #include "dm-bio-record.h"
 
@@ -60,9 +59,9 @@ struct multipath {
 
 	spinlock_t lock;
 
-	struct hw_handler hw_handler;
 	unsigned nr_priority_groups;
 	struct list_head priority_groups;
+	char *hw_handler_name;
 	unsigned pg_init_required;	/* pg_init needs calling? */
 	unsigned pg_init_in_progress;	/* Only one pg_init allowed at once */
 
@@ -106,6 +105,9 @@ static struct kmem_cache *_mpio_cache;
 struct workqueue_struct *kmultipathd;
 static void process_queued_ios(struct work_struct *work);
 static void trigger_event(struct work_struct *work);
+static void bypass_pg(struct multipath *m, struct priority_group *pg,
+		      int bypassed);
+static int fail_path(struct pgpath *pgpath);
 
 
 /*-----------------------------------------------
@@ -190,18 +192,13 @@ static struct multipath *alloc_multipath
 static void free_multipath(struct multipath *m)
 {
 	struct priority_group *pg, *tmp;
-	struct hw_handler *hwh = &m->hw_handler;
 
 	list_for_each_entry_safe(pg, tmp, &m->priority_groups, list) {
 		list_del(&pg->list);
 		free_priority_group(pg, m->ti);
 	}
 
-	if (hwh->type) {
-		hwh->type->destroy(hwh);
-		dm_put_hw_handler(hwh->type);
-	}
-
+	kfree(m->hw_handler_name);
 	mempool_destroy(m->mpio_pool);
 	kfree(m);
 }
@@ -213,12 +210,10 @@ static void free_multipath(struct multip
 
 static void __switch_pg(struct multipath *m, struct pgpath *pgpath)
 {
-	struct hw_handler *hwh = &m->hw_handler;
-
 	m->current_pg = pgpath->pg;
 
 	/* Must we initialise the PG first, and queue I/O till it's ready? */
-	if (hwh->type && hwh->type->pg_init) {
+	if (m->hw_handler_name) {
 		m->pg_init_required = 1;
 		m->queue_io = 1;
 	} else {
@@ -400,11 +395,106 @@ static void dispatch_queued_ios(struct m
 	}
 }
 
+static void __pg_init_done(struct dm_path *path, int errors)
+{
+	struct pgpath *pgpath = path_to_pgpath(path);
+	struct priority_group *pg = pgpath->pg;
+	struct multipath *m = pg->m;
+	unsigned long flags;
+
+	if (blkerr_transport_err(errors)) {
+		/*
+		 * Old dm behavior had us fail a path on any error.
+		 * In future patches, since we have finer grained errors now,
+		 * we do not have to fail the path on the first transient
+		 * error.
+		 */
+		fail_path(pgpath);
+		goto cleanup;
+	}
+
+	/* device or driver problems */
+	switch (errors) {
+	case BLKERR_OK:
+		break;
+	case BLKERR_NOSYS:
+		if (!m->hw_handler_name) {
+			errors = 0;
+			break;
+		}
+		DMERR("Cannot failover device because hw-%s may not be "
+		      "loaded.", m->hw_handler_name);
+		/*
+		 * Fail path for now, so we do not ping poing
+		 */
+		fail_path(pgpath);
+		break;
+	case BLKERR_DEV_TEMP_BUSY:
+		/*
+		 * Probably doing something like FW upgrade on the
+		 * controller so try the other pg.
+		 */
+		bypass_pg(m, pg, 1);
+		break;
+	/* TODO: For BLKERR_RETRY we should wait a couple seconds */
+	case BLKERR_RETRY:
+	case BLKERR_IMM_RETRY:
+	case BLKERR_RES_TEMP_UNAVAIL:
+		break;
+	default:
+		/*
+		 * We probably do not want to fail the path for a device
+		 * error, but this is what the old dm did. In future
+		 * patches we can do more advanced handling.
+		 */
+		fail_path(pgpath);
+	}
+
+cleanup:
+	spin_lock_irqsave(&m->lock, flags);
+	if (errors) {
+		DMERR("Could not failover device. Error %d.", errors);
+		m->current_pgpath = NULL;
+		m->current_pg = NULL;
+	} else if (!m->pg_init_required) {
+		m->queue_io = 0;
+		pg->bypassed = 0;
+	}
+
+	m->pg_init_in_progress = 0;
+	queue_work(kmultipathd, &m->process_queued_ios);
+	spin_unlock_irqrestore(&m->lock, flags);
+}
+
+static void pg_init_done(struct request *req, int err)
+{
+	__pg_init_done(req->end_io_data, req->errors);
+	__blk_put_request(req->q, req);
+}
+
+static void pg_init(struct dm_path *path)
+{
+	struct request *req;
+
+	req = blk_get_request(bdev_get_queue(path->dev->bdev), 1, GFP_NOIO);
+	if (!req) {
+		/* retry later */
+		__pg_init_done(path, BLKERR_RES_TEMP_UNAVAIL);
+		return;
+	}
+
+	req->cmd[0] = REQ_LB_OP_TRANSITION;
+	req->cmd_type = REQ_TYPE_LINUX_BLOCK;
+	req->end_io_data = path;
+	/* TODO: does this need to be configurable or is it HW specific? */
+	req->retries = 5;
+	blk_execute_rq_nowait(req->q, NULL, req, 1, pg_init_done);
+}
+
 static void process_queued_ios(struct work_struct *work)
 {
 	struct multipath *m =
 		container_of(work, struct multipath, process_queued_ios);
-	struct hw_handler *hwh = &m->hw_handler;
 	struct pgpath *pgpath = NULL;
 	unsigned init_required = 0, must_queue = 1;
 	unsigned long flags;
@@ -433,7 +523,7 @@ out:
 	spin_unlock_irqrestore(&m->lock, flags);
 
 	if (init_required)
-		hwh->type->pg_init(hwh, pgpath->pg->bypassed, &pgpath->path);
+		pg_init(&pgpath->path);
 
 	if (!must_queue)
 		dispatch_queued_ios(m);
@@ -646,10 +736,9 @@ static struct priority_group *parse_prio
 
 static int parse_hw_handler(struct arg_set *as, struct multipath *m)
 {
+	struct dm_target *ti = m->ti;
 	int r;
-	struct hw_handler_type *hwht;
 	unsigned hw_argc;
-	struct dm_target *ti = m->ti;
 
 	static struct param _params[] = {
 		{0, 1024, "invalid number of hardware handler args"},
@@ -662,25 +751,9 @@ static int parse_hw_handler(struct arg_s
 	if (!hw_argc)
 		return 0;
 
-	hwht = dm_get_hw_handler(shift(as));
-	if (!hwht) {
-		ti->error = "unknown hardware handler type";
-		return -EINVAL;
-	}
-
-	m->hw_handler.md = dm_table_get_md(ti->table);
-	dm_put(m->hw_handler.md);
-
-	r = hwht->create(&m->hw_handler, hw_argc - 1, as->argv);
-	if (r) {
-		dm_put_hw_handler(hwht);
-		ti->error = "hardware handler constructor failed";
-		return r;
-	}
-
-	m->hw_handler.type = hwht;
+	m->hw_handler_name = kstrdup(shift(as), GFP_KERNEL);
+	request_module("hw-%s", m->hw_handler_name);
 	consume(as, hw_argc - 1);
-
 	return 0;
 }
 
@@ -979,45 +1052,11 @@ static int bypass_pg_num(struct multipat
 }
 
 /*
- * pg_init must call this when it has completed its initialisation
- */
-void dm_pg_init_complete(struct dm_path *path, unsigned err_flags)
-{
-	struct pgpath *pgpath = path_to_pgpath(path);
-	struct priority_group *pg = pgpath->pg;
-	struct multipath *m = pg->m;
-	unsigned long flags;
-
-	/* We insist on failing the path if the PG is already bypassed. */
-	if (err_flags && pg->bypassed)
-		err_flags |= MP_FAIL_PATH;
-
-	if (err_flags & MP_FAIL_PATH)
-		fail_path(pgpath);
-
-	if (err_flags & MP_BYPASS_PG)
-		bypass_pg(m, pg, 1);
-
-	spin_lock_irqsave(&m->lock, flags);
-	if (err_flags) {
-		m->current_pgpath = NULL;
-		m->current_pg = NULL;
-	} else if (!m->pg_init_required)
-		m->queue_io = 0;
-
-	m->pg_init_in_progress = 0;
-	queue_work(kmultipathd, &m->process_queued_ios);
-	spin_unlock_irqrestore(&m->lock, flags);
-}
-
-/*
  * end_io handling
  */
 static int do_end_io(struct multipath *m, struct bio *bio,
 		     int error, struct mpath_io *mpio)
 {
-	struct hw_handler *hwh = &m->hw_handler;
-	unsigned err_flags = MP_FAIL_PATH;	/* Default behavior */
 	unsigned long flags;
 
 	if (!error)
@@ -1044,19 +1083,8 @@ static int do_end_io(struct multipath *m
 	}
 	spin_unlock_irqrestore(&m->lock, flags);
 
-	if (hwh->type && hwh->type->error)
-		err_flags = hwh->type->error(hwh, bio);
-
-	if (mpio->pgpath) {
-		if (err_flags & MP_FAIL_PATH)
-			fail_path(mpio->pgpath);
-
-		if (err_flags & MP_BYPASS_PG)
-			bypass_pg(m, mpio->pgpath->pg, 1);
-	}
-
-	if (err_flags & MP_ERROR_IO)
-		return -EIO;
+	if (mpio->pgpath)
+		fail_path(mpio->pgpath);
 
       requeue:
 	dm_bio_restore(&mpio->details, bio);
@@ -1141,7 +1169,6 @@ static int multipath_status(struct dm_ta
 	int sz = 0;
 	unsigned long flags;
 	struct multipath *m = (struct multipath *) ti->private;
-	struct hw_handler *hwh = &m->hw_handler;
 	struct priority_group *pg;
 	struct pgpath *p;
 	unsigned pg_num;
@@ -1157,12 +1184,10 @@ static int multipath_status(struct dm_ta
 	else
 		DMEMIT("0 ");
 
-	if (hwh->type && hwh->type->status)
-		sz += hwh->type->status(hwh, type, result + sz, maxlen - sz);
-	else if (!hwh->type || type == STATUSTYPE_INFO)
-		DMEMIT("0 ");
+	if (m->hw_handler_name)
+		DMEMIT("1 %s ", m->hw_handler_name);
 	else
-		DMEMIT("1 %s ", hwh->type->name);
+		DMEMIT("0 ");
 
 	DMEMIT("%u ", m->nr_priority_groups);
 
@@ -1387,8 +1412,6 @@ static void __exit dm_multipath_exit(voi
 	kmem_cache_destroy(_mpio_cache);
 }
 
-EXPORT_SYMBOL_GPL(dm_pg_init_complete);
-
 module_init(dm_multipath_init);
 module_exit(dm_multipath_exit);
 
-- 
1.4.1.1
