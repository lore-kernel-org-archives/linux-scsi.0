From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 1/2] dm: Add feature flags to dm-mpath
Date: Mon,  3 May 2010 21:01:30 -0700
Message-ID: <1272945691-31649-2-git-send-email-andmike@linux.vnet.ibm.com>
References: <1272945691-31649-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41348 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab0EDECC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 00:02:02 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e9.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o443nB7u016535
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:49:11 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o44421ad118728
	for <linux-scsi@vger.kernel.org>; Tue, 4 May 2010 00:02:01 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o444216J032559
	for <linux-scsi@vger.kernel.org>; Tue, 4 May 2010 00:02:01 -0400
In-Reply-To: <1272945691-31649-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org

Add a feature flag attribute to the multipath structure.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/md/dm-mpath.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 826bce7..4200d03 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -82,6 +82,7 @@ struct multipath {
 	unsigned saved_queue_if_no_path;/* Saved state during suspension */
 	unsigned pg_init_retries;	/* Number of times to retry pg_init */
 	unsigned pg_init_count;		/* Number of times pg_init called */
+	unsigned long features;
 
 	struct work_struct process_queued_ios;
 	struct list_head queued_ios;
@@ -118,6 +119,15 @@ static void trigger_event(struct work_struct *work);
 static void activate_path(struct work_struct *work);
 static void deactivate_path(struct work_struct *work);
 
+static int multipath_test_feature(struct multipath *m, unsigned feature)
+{
+	return test_bit(feature, &m->features);
+}
+
+static void multipath_set_feature(struct multipath *m, unsigned feature)
+{
+	set_bit(feature, &m->features);
+}
 
 /*-----------------------------------------------
  * Allocation routines
-- 
1.6.6.1

