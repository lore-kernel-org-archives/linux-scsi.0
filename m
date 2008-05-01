From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 07/10] scsi_dh: Add a single threaded workqueue for initializing paths
Date: Thu, 01 May 2008 14:50:22 -0700
Message-ID: <20080501215022.27759.4186.sendpatchset@chandra-ubuntu>
References: <20080501214941.27759.95121.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50838 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759485AbYEAVtW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 May 2008 17:49:22 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m41LnLBn020249
	for <linux-scsi@vger.kernel.org>; Thu, 1 May 2008 17:49:21 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m41LnLs0254638
	for <linux-scsi@vger.kernel.org>; Thu, 1 May 2008 17:49:21 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m41LnKlw024670
	for <linux-scsi@vger.kernel.org>; Thu, 1 May 2008 17:49:21 -0400
In-Reply-To: <20080501214941.27759.95121.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, andmike@us.ibm.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dwysocha@redhat.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, Chandra Seetharaman <sekharan@us.ibm.com>

Subject: [PATCH 07/10] scsi_dh: Add a single threaded workqueue for initializing paths

From: Chandra Seetharaman <sekharan@us.ibm.com>

Before this patch set (SCSI hardware handlers), initialization of a
path was done asynchronously. Doing that requires a workqueue in each 
device/hardware handler module and leads to unneccessary complication
in the device handler code, making it difficult to read the code and
follow the state diagram.

Moving that workqueue to this level makes the device handler code simpler.
Hence, the workqueue is moved to dm level.

A new workqueue is added instead of adding it to the existing workqueue
(kmpathd) for the following reasons:
	1. Device activation has to happen faster, stacking them along
	   with the other workqueue might lead to unnecessary delay
	   in the activation of the path.
	2. The effect could be felt the other way too. i.e the current
	   events that are handled by the existing workqueue might get
	   a delayed response.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
Index: linux-2.6.25/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.25.orig/drivers/md/dm-mpath.c
+++ linux-2.6.25/drivers/md/dm-mpath.c
@@ -63,6 +63,7 @@ struct multipath {
 	spinlock_t lock;
 
 	const char *hw_handler_name;
+	struct work_struct activate_path;
 	unsigned nr_priority_groups;
 	struct list_head priority_groups;
 	unsigned pg_init_required;	/* pg_init needs calling? */
@@ -107,10 +108,10 @@ typedef int (*action_fn) (struct pgpath 
 
 static struct kmem_cache *_mpio_cache;
 
-static struct workqueue_struct *kmultipathd;
+static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
 static void process_queued_ios(struct work_struct *work);
 static void trigger_event(struct work_struct *work);
-static void pg_init_done(struct dm_path *, int);
+static void activate_path(struct work_struct *work);
 
 
 /*-----------------------------------------------
@@ -180,6 +181,7 @@ static struct multipath *alloc_multipath
 		m->queue_io = 1;
 		INIT_WORK(&m->process_queued_ios, process_queued_ios);
 		INIT_WORK(&m->trigger_event, trigger_event);
+		INIT_WORK(&m->activate_path, activate_path);
 		m->mpio_pool = mempool_create_slab_pool(MIN_IOS, _mpio_cache);
 		if (!m->mpio_pool) {
 			kfree(m);
@@ -432,11 +434,8 @@ static void process_queued_ios(struct wo
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
 
-	if (init_required) {
-		struct dm_path *path = &pgpath->path;
-		int ret = scsi_dh_activate(bdev_get_queue(path->dev->bdev));
-		pg_init_done(path, ret);
-	}
+	if (init_required)
+		queue_work(kmpath_handlerd, &m->activate_path);
 
 	if (!must_queue)
 		dispatch_queued_ios(m);
@@ -795,6 +794,7 @@ static void multipath_dtr(struct dm_targ
 {
 	struct multipath *m = (struct multipath *) ti->private;
 
+	flush_workqueue(kmpath_handlerd);
 	flush_workqueue(kmultipathd);
 	free_multipath(m);
 }
@@ -1112,6 +1112,17 @@ static void pg_init_done(struct dm_path 
 	spin_unlock_irqrestore(&m->lock, flags);
 }
 
+static void activate_path(struct work_struct *work)
+{
+	int ret;
+	struct multipath *m =
+		container_of(work, struct multipath, activate_path);
+	struct dm_path *path = &m->current_pgpath->path;
+
+	ret = scsi_dh_activate(bdev_get_queue(path->dev->bdev));
+	pg_init_done(path, ret);
+}
+
 /*
  * end_io handling
  */
@@ -1455,6 +1466,21 @@ static int __init dm_multipath_init(void
 		return -ENOMEM;
 	}
 
+	/*
+	 * A separate workqueue is used to handle the device handlers
+	 * to avoid overloading existing workqueue. Overloading the
+	 * old workqueue would also create a bottleneck in the
+	 * path of the storage hardware device activation.
+	 */
+	kmpath_handlerd = create_singlethread_workqueue("kmpath_handlerd");
+	if (!kmpath_handlerd) {
+		DMERR("failed to create workqueue kmpath_handlerd");
+		destroy_workqueue(kmultipathd);
+		dm_unregister_target(&multipath_target);
+		kmem_cache_destroy(_mpio_cache);
+		return -ENOMEM;
+	}
+
 	DMINFO("version %u.%u.%u loaded",
 	       multipath_target.version[0], multipath_target.version[1],
 	       multipath_target.version[2]);
@@ -1466,6 +1492,7 @@ static void __exit dm_multipath_exit(voi
 {
 	int r;
 
+	destroy_workqueue(kmpath_handlerd);
 	destroy_workqueue(kmultipathd);
 
 	r = dm_unregister_target(&multipath_target);
