From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 5/7] scsi_dh: Use SCSI device handler in
	dm-multipath
Date: Thu, 17 Apr 2008 14:19:28 -0700
Message-ID: <20080417211928.24530.80015.sendpatchset@chandra-ubuntu>
References: <20080417211856.24530.30975.sendpatchset@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080417211856.24530.30975.sendpatchset@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, asson_ronald@emc.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, jens.axboe@oracle.com, agk@redhat.com
List-Id: linux-scsi@vger.kernel.org

Subject: scsi_dh: Use SCSI device handler in dm-multipath

From: Chandra Seetharaman <sekharan@us.ibm.com>

This patch converts dm-mpath to scsi hw handlers. It does
not add any new functionality and old behaviors and userspace
tools work as is except we use the safe clariion default instead
of using the userspace setting.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/md/Kconfig    |    1 	1 +	0 -	0 !
 drivers/md/dm-mpath.c |  226 	111 +	115 -	0 !
 2 files changed, 112 insertions(+), 115 deletions(-)

Index: linux-2.6.25-rc8-mm2/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.25-rc8-mm2.orig/drivers/md/dm-mpath.c
+++ linux-2.6.25-rc8-mm2/drivers/md/dm-mpath.c
@@ -7,7 +7,6 @@
 
 #include "dm.h"
 #include "dm-path-selector.h"
-#include "dm-hw-handler.h"
 #include "dm-bio-list.h"
 #include "dm-bio-record.h"
 #include "dm-uevent.h"
@@ -20,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/workqueue.h>
+#include <scsi/scsi_dh.h>
 #include <asm/atomic.h>
 
 #define DM_MSG_PREFIX "multipath"
@@ -61,9 +61,14 @@ struct multipath {
 
 	spinlock_t lock;
 
-	struct hw_handler hw_handler;
 	unsigned nr_priority_groups;
 	struct list_head priority_groups;
+
+	/* Fields used by hardware handler usage */
+	char *hw_handler_name;
+	struct work_struct activate_passive_path;
+	struct dm_path *path_to_activate;
+
 	unsigned pg_init_required;	/* pg_init needs calling? */
 	unsigned pg_init_in_progress;	/* Only one pg_init allowed at once */
 
@@ -106,9 +111,13 @@ typedef int (*action_fn) (struct pgpath 
 
 static struct kmem_cache *_mpio_cache;
 
-static struct workqueue_struct *kmultipathd;
+static struct workqueue_struct *kmultipathd, *hw_handlerd;
 static void process_queued_ios(struct work_struct *work);
 static void trigger_event(struct work_struct *work);
+static void activate_passive_path(struct work_struct *work);
+static void bypass_pg(struct multipath *m, struct priority_group *pg,
+		      int bypassed);
+static int fail_path(struct pgpath *pgpath);
 
 
 /*-----------------------------------------------
@@ -178,6 +187,7 @@ static struct multipath *alloc_multipath
 		m->queue_io = 1;
 		INIT_WORK(&m->process_queued_ios, process_queued_ios);
 		INIT_WORK(&m->trigger_event, trigger_event);
+		INIT_WORK(&m->activate_passive_path, activate_passive_path);
 		m->mpio_pool = mempool_create_slab_pool(MIN_IOS, _mpio_cache);
 		if (!m->mpio_pool) {
 			kfree(m);
@@ -193,18 +203,13 @@ static struct multipath *alloc_multipath
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
@@ -216,12 +221,10 @@ static void free_multipath(struct multip
 
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
@@ -405,11 +408,86 @@ static void dispatch_queued_ios(struct m
 	}
 }
 
+static void pg_init_done(struct dm_path *path, int errors)
+{
+	struct pgpath *pgpath = path_to_pgpath(path);
+	struct priority_group *pg = pgpath->pg;
+	struct multipath *m = pg->m;
+	unsigned long flags;
+
+	/* device or driver problems */
+	switch (errors) {
+	case SCSI_DH_OK:
+		break;
+	case SCSI_DH_NOSYS:
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
+	case SCSI_DH_DEV_TEMP_BUSY:
+		/*
+		 * Probably doing something like FW upgrade on the
+		 * controller so try the other pg.
+		 */
+		bypass_pg(m, pg, 1);
+		break;
+	/* TODO: For SCSI_DH_RETRY we should wait a couple seconds */
+	case SCSI_DH_RETRY:
+	case SCSI_DH_IMM_RETRY:
+	case SCSI_DH_RES_TEMP_UNAVAIL:
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
+static void activate_passive_path(struct work_struct *work)
+{
+	int ret;
+	struct multipath *m =
+		container_of(work, struct multipath, activate_passive_path);
+	struct dm_path *path = m->path_to_activate;
+
+	ret = scsi_dh_activate(bdev_get_queue(path->dev->bdev));
+	pg_init_done(path, ret);
+}
+
+static void pg_init(struct multipath *m, struct dm_path *path)
+{
+	m->path_to_activate = path;
+	queue_work(hw_handlerd, &m->activate_passive_path);
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
@@ -439,7 +517,7 @@ out:
 	spin_unlock_irqrestore(&m->lock, flags);
 
 	if (init_required)
-		hwh->type->pg_init(hwh, pgpath->pg->bypassed, &pgpath->path);
+		pg_init(m, &pgpath->path);
 
 	if (!must_queue)
 		dispatch_queued_ios(m);
@@ -652,10 +730,9 @@ static struct priority_group *parse_prio
 
 static int parse_hw_handler(struct arg_set *as, struct multipath *m)
 {
+	struct dm_target *ti = m->ti;
 	int r;
-	struct hw_handler_type *hwht;
 	unsigned hw_argc;
-	struct dm_target *ti = m->ti;
 
 	static struct param _params[] = {
 		{0, 1024, "invalid number of hardware handler args"},
@@ -668,25 +745,9 @@ static int parse_hw_handler(struct arg_s
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
+	request_module("scsi_dh_%s", m->hw_handler_name);
 	consume(as, hw_argc - 1);
-
 	return 0;
 }
 
@@ -808,6 +869,7 @@ static void multipath_dtr(struct dm_targ
 {
 	struct multipath *m = (struct multipath *) ti->private;
 
+	flush_workqueue(hw_handlerd);
 	flush_workqueue(kmultipathd);
 	free_multipath(m);
 }
@@ -1006,71 +1068,11 @@ static int bypass_pg_num(struct multipat
 }
 
 /*
- * Should we retry pg_init immediately?
- */
-static int pg_init_limit_reached(struct multipath *m, struct pgpath *pgpath)
-{
-	unsigned long flags;
-	int limit_reached = 0;
-
-	spin_lock_irqsave(&m->lock, flags);
-
-	if (m->pg_init_count <= m->pg_init_retries)
-		m->pg_init_required = 1;
-	else
-		limit_reached = 1;
-
-	spin_unlock_irqrestore(&m->lock, flags);
-
-	return limit_reached;
-}
-
-/*
- * pg_init must call this when it has completed its initialisation
- */
-void dm_pg_init_complete(struct dm_path *path, unsigned err_flags)
-{
-	struct pgpath *pgpath = path_to_pgpath(path);
-	struct priority_group *pg = pgpath->pg;
-	struct multipath *m = pg->m;
-	unsigned long flags;
-
-	/*
-	 * If requested, retry pg_init until maximum number of retries exceeded.
-	 * If retry not requested and PG already bypassed, always fail the path.
-	 */
-	if (err_flags & MP_RETRY) {
-		if (pg_init_limit_reached(m, pgpath))
-			err_flags |= MP_FAIL_PATH;
-	} else if (err_flags && pg->bypassed)
-		err_flags |= MP_FAIL_PATH;
-
-	if (err_flags & MP_FAIL_PATH)
-		fail_path(pgpath);
-
-	if (err_flags & MP_BYPASS_PG)
-		bypass_pg(m, pg, 1);
-
-	spin_lock_irqsave(&m->lock, flags);
-	if (err_flags & ~MP_RETRY) {
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
 		     int error, struct dm_mpath_io *mpio)
 {
-	struct hw_handler *hwh = &m->hw_handler;
-	unsigned err_flags = MP_FAIL_PATH;	/* Default behavior */
 	unsigned long flags;
 
 	if (!error)
@@ -1097,19 +1099,8 @@ static int do_end_io(struct multipath *m
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
@@ -1194,7 +1185,6 @@ static int multipath_status(struct dm_ta
 	int sz = 0;
 	unsigned long flags;
 	struct multipath *m = (struct multipath *) ti->private;
-	struct hw_handler *hwh = &m->hw_handler;
 	struct priority_group *pg;
 	struct pgpath *p;
 	unsigned pg_num;
@@ -1214,12 +1204,10 @@ static int multipath_status(struct dm_ta
 			DMEMIT("pg_init_retries %u ", m->pg_init_retries);
 	}
 
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
 
@@ -1422,6 +1410,15 @@ static int __init dm_multipath_init(void
 		return -ENOMEM;
 	}
 
+	hw_handlerd = create_workqueue("khwhandlerd");
+	if (!hw_handlerd) {
+		DMERR("failed to create workqueue khwhandlerd");
+		destroy_workqueue(kmultipathd);
+		dm_unregister_target(&multipath_target);
+		kmem_cache_destroy(_mpio_cache);
+		return -ENOMEM;
+	}
+
 	DMINFO("version %u.%u.%u loaded",
 	       multipath_target.version[0], multipath_target.version[1],
 	       multipath_target.version[2]);
@@ -1433,6 +1430,7 @@ static void __exit dm_multipath_exit(voi
 {
 	int r;
 
+	destroy_workqueue(hw_handlerd);
 	destroy_workqueue(kmultipathd);
 
 	r = dm_unregister_target(&multipath_target);
@@ -1441,8 +1439,6 @@ static void __exit dm_multipath_exit(voi
 	kmem_cache_destroy(_mpio_cache);
 }
 
-EXPORT_SYMBOL_GPL(dm_pg_init_complete);
-
 module_init(dm_multipath_init);
 module_exit(dm_multipath_exit);
 
Index: linux-2.6.25-rc8-mm2/drivers/md/Kconfig
===================================================================
--- linux-2.6.25-rc8-mm2.orig/drivers/md/Kconfig
+++ linux-2.6.25-rc8-mm2/drivers/md/Kconfig
@@ -252,6 +252,7 @@ config DM_ZERO
 config DM_MULTIPATH
 	tristate "Multipath target"
 	depends on BLK_DEV_DM
+	select SCSI_DH
 	---help---
 	  Allow volume managers to support multipath hardware.
 
