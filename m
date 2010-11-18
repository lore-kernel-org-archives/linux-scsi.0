From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3] dm mpath: add feature flag to control call to blk_abort_queue
Date: Thu, 18 Nov 2010 10:48:37 -0500
Message-ID: <1290095317-15684-1-git-send-email-snitzer@redhat.com>
References: <20101118072032.GA13390@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab0KRPsv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 10:48:51 -0500
In-Reply-To: <20101118072032.GA13390@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org, Mike Anderson <andmike@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>

Add 'features' member to 'struct multipath' and introduce
MPF_ABORT_QUEUE as the first feature flag.  If "abort_queue_on_fail"
is provided during mpath device configuration the MPF_ABORT_QUEUE
feature flag will be set and blk_abort_queue() will be called during
path failure to allow for lower latency path failures.

But this feature has been disabled by default due to a race (between
blk_abort_queue and scsi_request_fn) that can lead to list corruption,
from: https://www.redhat.com/archives/dm-devel/2010-November/msg00085.html

"the cmd gets blk_abort_queued/timedout run on it and the scsi eh
somehow is able to complete and run scsi_queue_insert while
scsi_request_fn is still trying to process the request."

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/md/dm-mpath.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-mpath.c
+++ linux-2.6/drivers/md/dm-mpath.c
@@ -56,8 +56,14 @@ struct priority_group {
 	struct list_head pgpaths;
 };
 
+/*
+ * Bits for the m->features
+ */
+#define MPF_ABORT_QUEUE 0
+
 /* Multipath context */
 struct multipath {
+	unsigned long features;
 	struct list_head list;
 	struct dm_target *ti;
 
@@ -146,7 +152,8 @@ static void deactivate_path(struct work_
 	struct pgpath *pgpath =
 		container_of(work, struct pgpath, deactivate_path);
 
-	blk_abort_queue(pgpath->path.dev->bdev->bd_disk->queue);
+	if (test_bit(MPF_ABORT_QUEUE, &pgpath->pg->m->features))
+		blk_abort_queue(pgpath->path.dev->bdev->bd_disk->queue);
 }
 
 static struct priority_group *alloc_priority_group(void)
@@ -813,6 +820,11 @@ static int parse_features(struct arg_set
 			continue;
 		}
 
+		if (!strnicmp(param_name, MESG_STR("abort_queue_on_fail"))) {
+			set_bit(MPF_ABORT_QUEUE, &m->features);
+			continue;
+		}
+
 		if (!strnicmp(param_name, MESG_STR("pg_init_retries")) &&
 		    (argc >= 1)) {
 			r = read_param(_params + 1, shift(as),
@@ -1382,11 +1394,14 @@ static int multipath_status(struct dm_ta
 		DMEMIT("2 %u %u ", m->queue_size, m->pg_init_count);
 	else {
 		DMEMIT("%u ", m->queue_if_no_path +
-			      (m->pg_init_retries > 0) * 2);
+			      (m->pg_init_retries > 0) * 2 +
+			      test_bit(MPF_ABORT_QUEUE, &m->features));
 		if (m->queue_if_no_path)
 			DMEMIT("queue_if_no_path ");
 		if (m->pg_init_retries)
 			DMEMIT("pg_init_retries %u ", m->pg_init_retries);
+		if (test_bit(MPF_ABORT_QUEUE, &m->features))
+			DMEMIT("abort_queue_on_fail ");
 	}
 
 	if (!m->hw_handler_name || type == STATUSTYPE_INFO)
@@ -1655,7 +1670,7 @@ out:
  *---------------------------------------------------------------*/
 static struct target_type multipath_target = {
 	.name = "multipath",
-	.version = {1, 1, 1},
+	.version = {1, 2, 0},
 	.module = THIS_MODULE,
 	.ctr = multipath_ctr,
 	.dtr = multipath_dtr,
