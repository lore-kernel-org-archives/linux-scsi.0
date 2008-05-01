From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 08/10] scsi_dh: Remove dm_pg_init_complete
Date: Thu, 01 May 2008 14:50:28 -0700
Message-ID: <20080501215028.27759.23808.sendpatchset@chandra-ubuntu>
References: <20080501214941.27759.95121.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:36246 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761192AbYEAVt2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 17:49:28 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m41Lkhl9013037
	for <linux-scsi@vger.kernel.org>; Thu, 1 May 2008 17:46:43 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m41LnRxt145156
	for <linux-scsi@vger.kernel.org>; Thu, 1 May 2008 15:49:27 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m423nQu4018696
	for <linux-scsi@vger.kernel.org>; Thu, 1 May 2008 21:49:27 -0600
In-Reply-To: <20080501214941.27759.95121.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, andmike@us.ibm.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dwysocha@redhat.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, Chandra Seetharaman <sekharan@us.ibm.com>

Subject: [PATCH 08/10] scsi_dh: Remove dm_pg_init_complete

From: Chandra Seetharaman <sekharan@us.ibm.com>

This patch just removes the dm layer's path initialization completion
routine.  This is separated from the other patch(scsi_dh: Use SCSI
device handler in dm-multipath) Just to make that patch more readable.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
Index: linux-2.6.25/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.25.orig/drivers/md/dm-mpath.c
+++ linux-2.6.25/drivers/md/dm-mpath.c
@@ -7,7 +7,6 @@
 
 #include "dm.h"
 #include "dm-path-selector.h"
-#include "dm-hw-handler.h"
 #include "dm-bio-list.h"
 #include "dm-bio-record.h"
 #include "dm-uevent.h"
@@ -1012,44 +1011,6 @@ static int pg_init_limit_reached(struct 
 	return limit_reached;
 }
 
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
 static void pg_init_done(struct dm_path *path, int errors)
 {
 	struct pgpath *pgpath = path_to_pgpath(path);
@@ -1501,8 +1462,6 @@ static void __exit dm_multipath_exit(voi
 	kmem_cache_destroy(_mpio_cache);
 }
 
-EXPORT_SYMBOL_GPL(dm_pg_init_complete);
-
 module_init(dm_multipath_init);
 module_exit(dm_multipath_exit);
 
