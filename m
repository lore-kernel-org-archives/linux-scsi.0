From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 1/7] be2iscsi: Modification of  iscsi_eh_target_reset
Date: Thu, 18 Feb 2010 07:17:16 +0530
Message-ID: <20100218014705.GA31130@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:34933 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932164Ab0BRBrL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Feb 2010 20:47:11 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

       The iscsi_eh_target_reset has been mdified to attemt
target reset only. If it fails, then iscsi_eh_session_reset
will be called.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    2 +-
 drivers/scsi/be2iscsi/be_main.c          |    2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c         |    2 +-
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c       |    2 +-
 drivers/scsi/iscsi_tcp.c                 |    2 +-
 drivers/scsi/libiscsi.c                  |   24 +++++++++++++++++++-----
 include/scsi/libiscsi.h                  |    2 ++
 7 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 5f7a6fc..7e73c48 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -596,7 +596,7 @@ static struct scsi_host_template iscsi_iser_sht = {
 	.cmd_per_lun            = ISER_DEF_CMD_PER_LUN,
 	.eh_abort_handler       = iscsi_eh_abort,
 	.eh_device_reset_handler= iscsi_eh_device_reset,
-	.eh_target_reset_handler= iscsi_eh_target_reset,
+	.eh_target_reset_handler= iscsi_eh_recover_target,
 	.target_alloc		= iscsi_target_alloc,
 	.use_clustering         = DISABLE_CLUSTERING,
 	.proc_name              = "iscsi_iser",
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 7c22616..4d269b4 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -79,7 +79,7 @@ static struct scsi_host_template beiscsi_sht = {
 	.slave_configure = beiscsi_slave_configure,
 	.target_alloc = iscsi_target_alloc,
 	.eh_device_reset_handler = iscsi_eh_device_reset,
-	.eh_target_reset_handler = iscsi_eh_target_reset,
+	.eh_target_reset_handler = iscsi_eh_session_reset,
 	.sg_tablesize = BEISCSI_SGLIST_ELEMENTS,
 	.can_queue = BE2_IO_DEPTH,
 	.this_id = -1,
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 1c4d121..cb71dc9 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1989,7 +1989,7 @@ static struct scsi_host_template bnx2i_host_template = {
 	.queuecommand		= iscsi_queuecommand,
 	.eh_abort_handler	= iscsi_eh_abort,
 	.eh_device_reset_handler = iscsi_eh_device_reset,
-	.eh_target_reset_handler = iscsi_eh_target_reset,
+	.eh_target_reset_handler = iscsi_eh_recover_target,
 	.change_queue_depth	= iscsi_change_queue_depth,
 	.can_queue		= 1024,
 	.max_sectors		= 127,
diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index 412853c..b7c3058 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -915,7 +915,7 @@ static struct scsi_host_template cxgb3i_host_template = {
 	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
 	.eh_abort_handler	= iscsi_eh_abort,
 	.eh_device_reset_handler = iscsi_eh_device_reset,
-	.eh_target_reset_handler = iscsi_eh_target_reset,
+	.eh_target_reset_handler = iscsi_eh_recover_target,
 	.target_alloc		= iscsi_target_alloc,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.this_id		= -1,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 8a89ba9..310a5a7 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -874,7 +874,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
 	.eh_abort_handler       = iscsi_eh_abort,
 	.eh_device_reset_handler= iscsi_eh_device_reset,
-	.eh_target_reset_handler= iscsi_eh_target_reset,
+	.eh_target_reset_handler= iscsi_eh_recover_target,
 	.use_clustering         = DISABLE_CLUSTERING,
 	.slave_alloc            = iscsi_sw_tcp_slave_alloc,
 	.slave_configure        = iscsi_sw_tcp_slave_configure,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 703eb6a..9604b8d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2338,7 +2338,7 @@ EXPORT_SYMBOL_GPL(iscsi_session_recovery_timedout);
  * This function will wait for a relogin, session termination from
  * userspace, or a recovery/replacement timeout.
  */
-static int iscsi_eh_session_reset(struct scsi_cmnd *sc)
+int iscsi_eh_session_reset(struct scsi_cmnd *sc)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
@@ -2389,6 +2389,7 @@ failed:
 	mutex_unlock(&session->eh_mutex);
 	return SUCCESS;
 }
+EXPORT_SYMBOL_GPL(iscsi_eh_session_reset);
 
 static void iscsi_prep_tgt_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
 {
@@ -2403,8 +2404,7 @@ static void iscsi_prep_tgt_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
  * iscsi_eh_target_reset - reset target
  * @sc: scsi command
  *
- * This will attempt to send a warm target reset. If that fails
- * then we will drop the session and attempt ERL0 recovery.
+ * This will attempt to send a warm target reset.
  */
 int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 {
@@ -2449,7 +2449,6 @@ int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 		break;
 	case TMF_TIMEDOUT:
 		spin_unlock_bh(&session->lock);
-		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 		goto done;
 	default:
 		conn->tmf_state = TMF_INITIAL;
@@ -2476,12 +2475,27 @@ done:
 	ISCSI_DBG_EH(session, "tgt %s reset result = %s\n", session->targetname,
 		     rc == SUCCESS ? "SUCCESS" : "FAILED");
 	mutex_unlock(&session->eh_mutex);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(iscsi_eh_target_reset);
+
+/**
+ * iscsi_eh_recover_target - reset target and possibly the session
+ * @sc: scsi command
+ *
+ * This will attempt to send a warm target reset. If that fails,
+ * we will escalate to ERL0 session recovery.
+ */
+int iscsi_eh_recover_target(struct scsi_cmnd *sc)
+{
+	int rc;
 
+	rc = iscsi_eh_target_reset(sc);	
 	if (rc == FAILED)
 		rc = iscsi_eh_session_reset(sc);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(iscsi_eh_target_reset);
+EXPORT_SYMBOL_GPL(iscsi_eh_recover_target);
 
 /*
  * Pre-allocate a pool of @max items of @item_size. By default, the pool
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index ff92b46..278fd1b 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -338,6 +338,8 @@ struct iscsi_host {
 extern int iscsi_change_queue_depth(struct scsi_device *sdev, int depth,
 				    int reason);
 extern int iscsi_eh_abort(struct scsi_cmnd *sc);
+extern int iscsi_eh_recover_target(struct scsi_cmnd *sc);
+extern int iscsi_eh_session_reset(struct scsi_cmnd *sc);
 extern int iscsi_eh_target_reset(struct scsi_cmnd *sc);
 extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
 extern int iscsi_queuecommand(struct scsi_cmnd *sc,
-- 
1.6.4

