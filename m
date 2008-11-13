From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [RFC][PATCH] Handle multipath paths in a path group properly
	during pg_init (was "RE: [dm-devel] DM does not activate the paths if there
	are more than one path in path group during failover")
Date: Thu, 13 Nov 2008 15:48:58 -0800
Message-ID: <1226620138.8998.64.camel@chandra-ubuntu>
References: <1225944321.14830.1109.camel@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF45BE759CF@cosmail01.lsi.com>
	 <20081111005920.GN16649@agk.fab.redhat.com>
	 <E463DF2B2E584B4A82673F53D62C2EF45BE75B7F@cosmail01.lsi.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:42463 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbYKMXtG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2008 18:49:06 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mADNmUko023246
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2008 16:48:30 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mADNn5jt105730
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2008 16:49:05 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mADNn4rS025831
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2008 16:49:04 -0700
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF45BE75B7F@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Mike Anderson <andmike@us.ibm.com>

The problem reported by Moger Babu was caused due to the architectural
change made when we moved from dm hardware handler to SCSI hardware
handler.

Thanks Babu for finding and reporting the bug.

All of the hardware handlers, do have a state now, and they are set to
active and (some form of) inactive. All of them have prep_fn, which use
this "state" to fail the I/O without it ever being sent to the device.

As Babu has noted in his email, the pg_init/activate is sent on only one
path and the "state" of that path is changed appropriately to "active"
while other paths in the same path group are never changed as they never
got an "activate".

Attached is a patch (compiled, tested, but not clean yet), which makes
changes in the dm-multipath layer to send an "activate" on each paths in
the path groups.

Mike (Anderson) and I had a discussion about whether to implement this
in the dm-mulitpath layer or in the SCSI hardware handler layer and we
came to a conclusion that it is best suited to be in the dm-mulitpath
layer as it is the one that knows the relationship between different
paths.

If it were to be done at the Hardware handler layer, then the hardware
handler may end up having a different notion of the path relationship
and hence may not work as expected by the dm-multipath layer.

Please provide your feedback on this approach and any additional
comments.
----------

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

---
Index: linux-2.6.28-rc3/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.28-rc3.orig/drivers/md/dm-mpath.c
+++ linux-2.6.28-rc3/drivers/md/dm-mpath.c
@@ -36,6 +36,7 @@ struct pgpath {
 
 	struct dm_path path;
 	struct work_struct deactivate_path;
+	struct work_struct activate_path;
 };
 
 #define path_to_pgpath(__pgp) container_of((__pgp), struct pgpath, path)
@@ -65,8 +66,6 @@ struct multipath {
 	spinlock_t lock;
 
 	const char *hw_handler_name;
-	struct work_struct activate_path;
-	struct pgpath *pgpath_to_activate;
 	unsigned nr_priority_groups;
 	struct list_head priority_groups;
 	unsigned pg_init_required;	/* pg_init needs calling? */
@@ -129,6 +128,7 @@ static struct pgpath *alloc_pgpath(void)
 	if (pgpath) {
 		pgpath->is_active = 1;
 		INIT_WORK(&pgpath->deactivate_path, deactivate_path);
+		INIT_WORK(&pgpath->activate_path, activate_path);
 	}
 
 	return pgpath;
@@ -170,10 +170,6 @@ static void free_pgpaths(struct list_hea
 		if (m->hw_handler_name)
 			scsi_dh_detach(bdev_get_queue(pgpath->path.dev->bdev));
 		dm_put_device(ti, pgpath->path.dev);
-		spin_lock_irqsave(&m->lock, flags);
-		if (m->pgpath_to_activate == pgpath)
-			m->pgpath_to_activate = NULL;
-		spin_unlock_irqrestore(&m->lock, flags);
 		free_pgpath(pgpath);
 	}
 }
@@ -203,7 +199,6 @@ static struct multipath *alloc_multipath
 		m->queue_io = 1;
 		INIT_WORK(&m->process_queued_ios, process_queued_ios);
 		INIT_WORK(&m->trigger_event, trigger_event);
-		INIT_WORK(&m->activate_path, activate_path);
 		m->mpio_pool = mempool_create_slab_pool(MIN_IOS, _mpio_cache);
 		if (!m->mpio_pool) {
 			kfree(m);
@@ -428,8 +423,8 @@ static void process_queued_ios(struct wo
 {
 	struct multipath *m =
 		container_of(work, struct multipath, process_queued_ios);
-	struct pgpath *pgpath = NULL;
-	unsigned init_required = 0, must_queue = 1;
+	struct pgpath *pgpath = NULL, *tmp;
+	unsigned must_queue = 1;
 	unsigned long flags;
 
 	spin_lock_irqsave(&m->lock, flags);
@@ -447,19 +442,15 @@ static void process_queued_ios(struct wo
 		must_queue = 0;
 
 	if (m->pg_init_required && !m->pg_init_in_progress && pgpath) {
-		m->pgpath_to_activate = pgpath;
 		m->pg_init_count++;
 		m->pg_init_required = 0;
-		m->pg_init_in_progress = 1;
-		init_required = 1;
+		list_for_each_entry(tmp, &pgpath->pg->pgpaths, list) {
+			queue_work(kmpath_handlerd, &tmp->activate_path);
+			m->pg_init_in_progress++;
+		}
 	}
-
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
-
-	if (init_required)
-		queue_work(kmpath_handlerd, &m->activate_path);
-
 	if (!must_queue)
 		dispatch_queued_ios(m);
 }
@@ -1111,27 +1102,20 @@ static void pg_init_done(struct dm_path 
 		pg->bypassed = 0;
 	}
 
-	m->pg_init_in_progress = 0;
-	queue_work(kmultipathd, &m->process_queued_ios);
+	m->pg_init_in_progress--;
+	if (!m->pg_init_in_progress)
+		queue_work(kmultipathd, &m->process_queued_ios);
 	spin_unlock_irqrestore(&m->lock, flags);
 }
 
 static void activate_path(struct work_struct *work)
 {
 	int ret;
-	struct multipath *m =
-		container_of(work, struct multipath, activate_path);
-	struct dm_path *path;
-	unsigned long flags;
+	struct pgpath *pgpath =
+		container_of(work, struct pgpath, activate_path);
 
-	spin_lock_irqsave(&m->lock, flags);
-	path = &m->pgpath_to_activate->path;
-	m->pgpath_to_activate = NULL;
-	spin_unlock_irqrestore(&m->lock, flags);
-	if (!path)
-		return;
-	ret = scsi_dh_activate(bdev_get_queue(path->dev->bdev));
-	pg_init_done(path, ret);
+	ret = scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev));
+	pg_init_done(&pgpath->path, ret);
 }
 
 /*


