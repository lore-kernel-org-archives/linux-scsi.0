From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 05/10] scsi_dh: Use SCSI device handler in dm-multipath
Date: Thu, 01 May 2008 14:50:11 -0700
Message-ID: <20080501215011.27759.66973.sendpatchset@chandra-ubuntu>
References: <20080501214941.27759.95121.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43849 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762031AbYEAVtK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 May 2008 17:49:10 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m41Ln9I9028582
	for <linux-scsi@vger.kernel.org>; Thu, 1 May 2008 17:49:09 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m41Ln9wm311658
	for <linux-scsi@vger.kernel.org>; Thu, 1 May 2008 17:49:09 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m41Ln9LG023887
	for <linux-scsi@vger.kernel.org>; Thu, 1 May 2008 17:49:09 -0400
In-Reply-To: <20080501214941.27759.95121.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, andmike@us.ibm.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dwysocha@redhat.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, Chandra Seetharaman <sekharan@us.ibm.com>

Subject: [PATCH 05/10] scsi_dh: Use SCSI device handler in dm-multipath

From: Chandra Seetharaman <sekharan@us.ibm.com>

This patch converts dm-mpath to use scsi device handlers instead of 
dm's hardware handlers.

This patch does not add any new functionality. Old behaviors remain and
userspace tools work as is except that arguments supplied with hardware
handler are ignored.

One behavioral exception is: Activation of a path is synchronous in this
patch, opposed to the older behavior of being asynchronous (changed in
patch 07: scsi_dh: Add a single threaded workqueue for initializing a path)

Note: There is no need to get a reference for the device handler module
(as it was done in the dm hardware handler case) here as the reference
is held when the device was first found. Instead we check and make sure
that support for the specified device is present at table load time.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/md/Kconfig    |    1 	1 +	0 -	0 !
 drivers/md/dm-mpath.c |  226 	111 +	115 -	0 !
 2 files changed, 112 insertions(+), 115 deletions(-)

Index: linux-2.6.25/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.25.orig/drivers/md/dm-mpath.c
+++ linux-2.6.25/drivers/md/dm-mpath.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/workqueue.h>
+#include <scsi/scsi_dh.h>
 #include <asm/atomic.h>
 
 #define DM_MSG_PREFIX "multipath"
@@ -61,7 +62,7 @@ struct multipath {
 
 	spinlock_t lock;
 
-	struct hw_handler hw_handler;
+	const char *hw_handler_name;
 	unsigned nr_priority_groups;
 	struct list_head priority_groups;
 	unsigned pg_init_required;	/* pg_init needs calling? */
@@ -109,6 +110,7 @@ static struct kmem_cache *_mpio_cache;
 static struct workqueue_struct *kmultipathd;
 static void process_queued_ios(struct work_struct *work);
 static void trigger_event(struct work_struct *work);
+static void pg_init_done(struct dm_path *, int);
 
 
 /*-----------------------------------------------
@@ -193,18 +195,13 @@ static struct multipath *alloc_multipath
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
@@ -216,12 +213,10 @@ static void free_multipath(struct multip
 
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
@@ -409,7 +404,6 @@ static void process_queued_ios(struct wo
 {
 	struct multipath *m =
 		container_of(work, struct multipath, process_queued_ios);
-	struct hw_handler *hwh = &m->hw_handler;
 	struct pgpath *pgpath = NULL;
 	unsigned init_required = 0, must_queue = 1;
 	unsigned long flags;
@@ -438,8 +432,11 @@ static void process_queued_ios(struct wo
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
 
-	if (init_required)
-		hwh->type->pg_init(hwh, pgpath->pg->bypassed, &pgpath->path);
+	if (init_required) {
+		struct dm_path *path = &pgpath->path;
+		int ret = scsi_dh_activate(bdev_get_queue(path->dev->bdev));
+		pg_init_done(path, ret);
+	}
 
 	if (!must_queue)
 		dispatch_queued_ios(m);
@@ -652,8 +649,6 @@ static struct priority_group *parse_prio
 
 static int parse_hw_handler(struct arg_set *as, struct multipath *m)
 {
-	int r;
-	struct hw_handler_type *hwht;
 	unsigned hw_argc;
 	struct dm_target *ti = m->ti;
 
@@ -661,30 +656,18 @@ static int parse_hw_handler(struct arg_s
 		{0, 1024, "invalid number of hardware handler args"},
 	};
 
-	r = read_param(_params, shift(as), &hw_argc, &ti->error);
-	if (r)
+	if (read_param(_params, shift(as), &hw_argc, &ti->error))
 		return -EINVAL;
 
 	if (!hw_argc)
 		return 0;
 
-	hwht = dm_get_hw_handler(shift(as));
-	if (!hwht) {
+	m->hw_handler_name = kstrdup(shift(as), GFP_KERNEL);
+	request_module("scsi_dh_%s", m->hw_handler_name);
+	if (scsi_dh_handler_exist(m->hw_handler_name) == 0) {
 		ti->error = "unknown hardware handler type";
 		return -EINVAL;
 	}
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
 	consume(as, hw_argc - 1);
 
 	return 0;
@@ -1063,14 +1046,74 @@ void dm_pg_init_complete(struct dm_path 
 	spin_unlock_irqrestore(&m->lock, flags);
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
+		DMERR("Cannot failover device because scsi_dh_%s was not "
+		      "loaded.", m->hw_handler_name);
+		/*
+		 * Fail path for now, so we do not ping pong
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
+		if (pg_init_limit_reached(m, pgpath))
+			fail_path(pgpath);
+		errors = 0;
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
 /*
  * end_io handling
  */
 static int do_end_io(struct multipath *m, struct bio *bio,
 		     int error, struct dm_mpath_io *mpio)
 {
-	struct hw_handler *hwh = &m->hw_handler;
-	unsigned err_flags = MP_FAIL_PATH;	/* Default behavior */
 	unsigned long flags;
 
 	if (!error)
@@ -1097,19 +1140,8 @@ static int do_end_io(struct multipath *m
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
@@ -1194,7 +1226,6 @@ static int multipath_status(struct dm_ta
 	int sz = 0;
 	unsigned long flags;
 	struct multipath *m = (struct multipath *) ti->private;
-	struct hw_handler *hwh = &m->hw_handler;
 	struct priority_group *pg;
 	struct pgpath *p;
 	unsigned pg_num;
@@ -1214,12 +1245,10 @@ static int multipath_status(struct dm_ta
 			DMEMIT("pg_init_retries %u ", m->pg_init_retries);
 	}
 
-	if (hwh->type && hwh->type->status)
-		sz += hwh->type->status(hwh, type, result + sz, maxlen - sz);
-	else if (!hwh->type || type == STATUSTYPE_INFO)
+	if (!m->hw_handler_name || type == STATUSTYPE_INFO)
 		DMEMIT("0 ");
 	else
-		DMEMIT("1 %s ", hwh->type->name);
+		DMEMIT("1 %s ", m->hw_handler_name);
 
 	DMEMIT("%u ", m->nr_priority_groups);
 
Index: linux-2.6.25/drivers/md/Kconfig
===================================================================
--- linux-2.6.25.orig/drivers/md/Kconfig
+++ linux-2.6.25/drivers/md/Kconfig
@@ -252,6 +252,7 @@ config DM_ZERO
 config DM_MULTIPATH
 	tristate "Multipath target"
 	depends on BLK_DEV_DM
+	select SCSI_DH
 	---help---
 	  Allow volume managers to support multipath hardware.
 
