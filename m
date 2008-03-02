From: michaelc@cs.wisc.edu
Subject: [PATCH 2/9] iscsi: user per target can_queue and return SCSI_MLQUEUE_TARGET_BUSY
Date: Sun,  2 Mar 2008 03:03:15 -0600
Message-ID: <1204448602-5435-2-git-send-email-michaelc@cs.wisc.edu>
References: <1204448602-5435-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbYCBJEL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Mar 2008 04:04:11 -0500
In-Reply-To: <1204448602-5435-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, david.somayajulu@qlogic.com, andrew.vasquez@qlogic.com, James.Smart@Emulex.com, Eric.Moore@lsil.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This hooks iscsi_tcp and libiscsi into the target->can_queue
code and it has libiscsi use SCSI_MLQUEUE_TARGET_BUSY.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    1 +
 drivers/scsi/iscsi_tcp.c                 |    1 +
 drivers/scsi/libiscsi.c                  |   31 +++++++++++++++++++----------
 include/scsi/libiscsi.h                  |    1 +
 4 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index be1b9fb..c818707 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -552,6 +552,7 @@ static struct scsi_host_template iscsi_iser_sht = {
 	.sg_tablesize           = ISCSI_ISER_SG_TABLESIZE,
 	.max_sectors		= 1024,
 	.cmd_per_lun            = ISCSI_MAX_CMD_PER_LUN,
+	.slave_alloc		= iscsi_slave_alloc,
 	.eh_abort_handler       = iscsi_eh_abort,
 	.eh_device_reset_handler= iscsi_eh_device_reset,
 	.eh_host_reset_handler	= iscsi_eh_host_reset,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 8a17867..c63e0e8 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1936,6 +1936,7 @@ static struct scsi_host_template iscsi_sht = {
 	.eh_device_reset_handler= iscsi_eh_device_reset,
 	.eh_host_reset_handler	= iscsi_eh_host_reset,
 	.use_clustering         = DISABLE_CLUSTERING,
+	.slave_alloc		= iscsi_slave_alloc,
 	.slave_configure        = iscsi_tcp_slave_configure,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index bdd7de7..156ec1a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1021,13 +1021,7 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		goto fault;
 	}
 
-	/*
-	 * ISCSI_STATE_FAILED is a temp. state. The recovery
-	 * code will decide what is best to do with command queued
-	 * during this time
-	 */
-	if (session->state != ISCSI_STATE_LOGGED_IN &&
-	    session->state != ISCSI_STATE_FAILED) {
+	if (session->state != ISCSI_STATE_LOGGED_IN) {
 		/*
 		 * to handle the race between when we set the recovery state
 		 * and block the session we requeue here (commands could
@@ -1035,10 +1029,10 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		 * up because the block code is not locked)
 		 */
 		switch (session->state) {
+		case ISCSI_STATE_FAILED:
 		case ISCSI_STATE_IN_RECOVERY:
 			reason = FAILURE_SESSION_IN_RECOVERY;
-			sc->result = DID_IMM_RETRY << 16;
-			break;
+			goto reject;
 		case ISCSI_STATE_LOGGING_OUT:
 			reason = FAILURE_SESSION_LOGGING_OUT;
 			sc->result = DID_IMM_RETRY << 16;
@@ -1097,7 +1091,7 @@ reject:
 	spin_unlock(&session->lock);
 	debug_scsi("cmd 0x%x rejected (%d)\n", sc->cmnd[0], reason);
 	spin_lock(host->host_lock);
-	return SCSI_MLQUEUE_HOST_BUSY;
+	return SCSI_MLQUEUE_TARGET_BUSY;
 
 fault:
 	spin_unlock(&session->lock);
@@ -1118,6 +1112,21 @@ int iscsi_change_queue_depth(struct scsi_device *sdev, int depth)
 }
 EXPORT_SYMBOL_GPL(iscsi_change_queue_depth);
 
+int iscsi_slave_alloc(struct scsi_device *sdev)
+{
+	struct scsi_target *starget = scsi_target(sdev);
+	struct iscsi_cls_session *cls_session = starget_to_session(starget);
+	struct iscsi_session *session;
+
+	if (!cls_session || iscsi_session_chkready(cls_session))
+		return -ENXIO;
+
+	session = class_to_transport_session(cls_session);
+	starget->can_queue = session->cmds_max;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iscsi_slave_alloc);
+
 void iscsi_session_recovery_timedout(struct iscsi_cls_session *cls_session)
 {
 	struct iscsi_session *session = class_to_transport_session(cls_session);
@@ -1724,7 +1733,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit,
 		return NULL;
 
 	/* the iscsi layer takes one task for reserve */
-	shost->can_queue = cmds_max - 1;
+	shost->can_queue = cmds_max;
 	shost->cmd_per_lun = qdepth;
 	shost->max_id = 1;
 	shost->max_channel = 0;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 7b90b63..3c2bdc4 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -308,6 +308,7 @@ struct iscsi_session {
 /*
  * scsi host template
  */
+extern int iscsi_slave_alloc(struct scsi_device *sdev);
 extern int iscsi_change_queue_depth(struct scsi_device *sdev, int depth);
 extern int iscsi_eh_abort(struct scsi_cmnd *sc);
 extern int iscsi_eh_host_reset(struct scsi_cmnd *sc);
-- 
1.5.4.1

