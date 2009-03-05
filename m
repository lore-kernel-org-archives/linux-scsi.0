From: michaelc@cs.wisc.edu
Subject: [PATCH 07/14] libiscsi: don't cap queue depth in iscsi modules
Date: Thu,  5 Mar 2009 14:46:01 -0600
Message-ID: <12362859754088-git-send-email-michaelc@cs.wisc.edu>
References: <12362859683749-git-send-email-michaelc@cs.wisc.edu>
 <12362859693831-git-send-email-michaelc@cs.wisc.edu>
 <12362859702687-git-send-email-michaelc@cs.wisc.edu>
 <123628597367-git-send-email-michaelc@cs.wisc.edu>
 <12362859734023-git-send-email-michaelc@cs.wisc.edu>
 <12362859743025-git-send-email-michaelc@cs.wisc.edu>
 <12362859742776-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52781 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbZCEUqT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 15:46:19 -0500
In-Reply-To: <12362859742776-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

There is no need to cap the queue depth in the modules. We set
this in userspace and can do that there. For performance testing
with ram based targets, this is helpful since we can have very
high queue depths.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    4 ++--
 drivers/infiniband/ulp/iser/iscsi_iser.h |    2 +-
 drivers/scsi/libiscsi.c                  |    9 +--------
 include/scsi/libiscsi.h                  |    3 +--
 4 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 4338f54..5f79c0a 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -404,7 +404,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	struct Scsi_Host *shost;
 	struct iser_conn *ib_conn;
 
-	shost = iscsi_host_alloc(&iscsi_iser_sht, 0, ISCSI_MAX_CMD_PER_LUN);
+	shost = iscsi_host_alloc(&iscsi_iser_sht, 0, ISER_DEF_CMD_PER_LUN);
 	if (!shost)
 		return NULL;
 	shost->transportt = iscsi_iser_scsi_transport;
@@ -596,7 +596,7 @@ static struct scsi_host_template iscsi_iser_sht = {
 	.change_queue_depth	= iscsi_change_queue_depth,
 	.sg_tablesize           = ISCSI_ISER_SG_TABLESIZE,
 	.max_sectors		= 1024,
-	.cmd_per_lun            = ISCSI_MAX_CMD_PER_LUN,
+	.cmd_per_lun            = ISER_DEF_CMD_PER_LUN,
 	.eh_abort_handler       = iscsi_eh_abort,
 	.eh_device_reset_handler= iscsi_eh_device_reset,
 	.eh_target_reset_handler= iscsi_eh_target_reset,
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 8611195..9d529ca 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -93,7 +93,7 @@
 
 					/* support upto 512KB in one RDMA */
 #define ISCSI_ISER_SG_TABLESIZE         (0x80000 >> SHIFT_4K)
-#define ISCSI_ISER_MAX_LUN		256
+#define ISER_DEF_CMD_PER_LUN		128
 
 /* QP settings */
 /* Maximal bounds on received asynchronous PDUs */
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 701457c..a5168a6 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1451,8 +1451,6 @@ EXPORT_SYMBOL_GPL(iscsi_queuecommand);
 
 int iscsi_change_queue_depth(struct scsi_device *sdev, int depth)
 {
-	if (depth > ISCSI_MAX_CMD_PER_LUN)
-		depth = ISCSI_MAX_CMD_PER_LUN;
 	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
 	return sdev->queue_depth;
 }
@@ -2062,13 +2060,8 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 	if (!shost)
 		return NULL;
 
-	if (qdepth > ISCSI_MAX_CMD_PER_LUN || qdepth < 1) {
-		if (qdepth != 0)
-			printk(KERN_ERR "iscsi: invalid queue depth of %d. "
-			       "Queue depth must be between 1 and %d.\n",
-			       qdepth, ISCSI_MAX_CMD_PER_LUN);
+	if (qdepth == 0)
 		qdepth = ISCSI_DEF_CMD_PER_LUN;
-	}
 	shost->cmd_per_lun = qdepth;
 
 	ihost = shost_priv(shost);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 67542aa..898de4a 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -48,8 +48,7 @@ struct device;
 #define ISCSI_DEF_XMIT_CMDS_MAX	128	/* must be power of 2 */
 #define ISCSI_MGMT_CMDS_MAX	15
 
-#define ISCSI_DEF_CMD_PER_LUN		32
-#define ISCSI_MAX_CMD_PER_LUN		128
+#define ISCSI_DEF_CMD_PER_LUN	32
 
 /* Task Mgmt states */
 enum {
-- 
1.6.0.6

