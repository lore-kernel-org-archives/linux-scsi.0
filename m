From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 2/2] dm: Add feature flag to control call to blk_abort_queue
Date: Mon,  3 May 2010 21:01:31 -0700
Message-ID: <1272945691-31649-3-git-send-email-andmike@linux.vnet.ibm.com>
References: <1272945691-31649-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45928 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab0EDECF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 00:02:05 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e6.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o443xu7T015711
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:59:56 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o44423h21855664
	for <linux-scsi@vger.kernel.org>; Tue, 4 May 2010 00:02:03 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o444226G032696
	for <linux-scsi@vger.kernel.org>; Tue, 4 May 2010 00:02:03 -0400
In-Reply-To: <1272945691-31649-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org

Add feature flag for no_abort_q.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/md/dm-mpath.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 4200d03..e55cb41 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -119,6 +119,10 @@ static void trigger_event(struct work_struct *work);
 static void activate_path(struct work_struct *work);
 static void deactivate_path(struct work_struct *work);
 
+enum multipath_feature_flags {
+	MP_FEATURE_NO_ABORT_Q = 0,
+};
+
 static int multipath_test_feature(struct multipath *m, unsigned feature)
 {
 	return test_bit(feature, &m->features);
@@ -156,7 +160,8 @@ static void deactivate_path(struct work_struct *work)
 	struct pgpath *pgpath =
 		container_of(work, struct pgpath, deactivate_path);
 
-	blk_abort_queue(pgpath->path.dev->bdev->bd_disk->queue);
+	if (!multipath_test_feature(pgpath->pg->m, MP_FEATURE_NO_ABORT_Q))
+		blk_abort_queue(pgpath->path.dev->bdev->bd_disk->queue);
 }
 
 static struct priority_group *alloc_priority_group(void)
@@ -822,6 +827,11 @@ static int parse_features(struct arg_set *as, struct multipath *m)
 			continue;
 		}
 
+		if (!strnicmp(param_name, MESG_STR("no_abort_q"))) {
+			multipath_set_feature(m, MP_FEATURE_NO_ABORT_Q);
+			continue;
+		}
+
 		if (!strnicmp(param_name, MESG_STR("pg_init_retries")) &&
 		    (argc >= 1)) {
 			r = read_param(_params + 1, shift(as),
@@ -1381,11 +1391,14 @@ static int multipath_status(struct dm_target *ti, status_type_t type,
 		DMEMIT("2 %u %u ", m->queue_size, m->pg_init_count);
 	else {
 		DMEMIT("%u ", m->queue_if_no_path +
-			      (m->pg_init_retries > 0) * 2);
+			      (m->pg_init_retries > 0) * 2 +
+			      multipath_test_feature(m, MP_FEATURE_NO_ABORT_Q));
 		if (m->queue_if_no_path)
 			DMEMIT("queue_if_no_path ");
 		if (m->pg_init_retries)
 			DMEMIT("pg_init_retries %u ", m->pg_init_retries);
+		if (multipath_test_feature(m, MP_FEATURE_NO_ABORT_Q))
+			DMEMIT("no_abort_q ");
 	}
 
 	if (!m->hw_handler_name || type == STATUSTYPE_INFO)
-- 
1.6.6.1

