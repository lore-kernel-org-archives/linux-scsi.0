From: michaelc@cs.wisc.edu
Subject: [PATCH 4/7] libiscsi: rename host reset to target reset
Date: Wed, 24 Sep 2008 11:46:12 -0500
Message-ID: <1222274775-8834-5-git-send-email-michaelc@cs.wisc.edu>
References: <1222274775-8834-1-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-2-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-3-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-4-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53703 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbYIXQq3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2008 12:46:29 -0400
In-Reply-To: <1222274775-8834-4-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

I had this in my patchset to add target reset support, but
it got dropped due to patching conflicts. This initial patch
just renames the function and users. We are actually just
dropping the session, and so this does not have anything to do
with the host exactly. It does for software iscsi because
we allocate a host per session, but for cxgb3i this makes no
sense.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    2 +-
 drivers/scsi/iscsi_tcp.c                 |    2 +-
 drivers/scsi/libiscsi.c                  |   10 +++++-----
 include/scsi/libiscsi.h                  |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 0474da1..1e5b644 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -598,7 +598,7 @@ static struct scsi_host_template iscsi_iser_sht = {
 	.cmd_per_lun            = ISCSI_MAX_CMD_PER_LUN,
 	.eh_abort_handler       = iscsi_eh_abort,
 	.eh_device_reset_handler= iscsi_eh_device_reset,
-	.eh_host_reset_handler	= iscsi_eh_host_reset,
+	.eh_target_reset_handler= iscsi_eh_target_reset,
 	.use_clustering         = DISABLE_CLUSTERING,
 	.proc_name              = "iscsi_iser",
 	.this_id                = -1,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 752f428..4f096de 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1909,7 +1909,7 @@ static struct scsi_host_template iscsi_sht = {
 	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
 	.eh_abort_handler       = iscsi_eh_abort,
 	.eh_device_reset_handler= iscsi_eh_device_reset,
-	.eh_host_reset_handler	= iscsi_eh_host_reset,
+	.eh_target_reset_handler= iscsi_eh_target_reset,
 	.use_clustering         = DISABLE_CLUSTERING,
 	.slave_configure        = iscsi_tcp_slave_configure,
 	.proc_name		= "iscsi_tcp",
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 3907818..e3e57cc 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1367,7 +1367,7 @@ void iscsi_session_recovery_timedout(struct iscsi_cls_session *cls_session)
 }
 EXPORT_SYMBOL_GPL(iscsi_session_recovery_timedout);
 
-int iscsi_eh_host_reset(struct scsi_cmnd *sc)
+int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
@@ -1381,7 +1381,7 @@ int iscsi_eh_host_reset(struct scsi_cmnd *sc)
 	spin_lock_bh(&session->lock);
 	if (session->state == ISCSI_STATE_TERMINATE) {
 failed:
-		debug_scsi("failing host reset: session terminated "
+		debug_scsi("failing target reset: session terminated "
 			   "[CID %d age %d]\n", conn->id, session->age);
 		spin_unlock_bh(&session->lock);
 		mutex_unlock(&session->eh_mutex);
@@ -1396,7 +1396,7 @@ failed:
 	 */
 	iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 
-	debug_scsi("iscsi_eh_host_reset wait for relogin\n");
+	debug_scsi("iscsi_eh_target_reset wait for relogin\n");
 	wait_event_interruptible(conn->ehwait,
 				 session->state == ISCSI_STATE_TERMINATE ||
 				 session->state == ISCSI_STATE_LOGGED_IN ||
@@ -1408,14 +1408,14 @@ failed:
 	spin_lock_bh(&session->lock);
 	if (session->state == ISCSI_STATE_LOGGED_IN)
 		iscsi_session_printk(KERN_INFO, session,
-				     "host reset succeeded\n");
+				     "target reset succeeded\n");
 	else
 		goto failed;
 	spin_unlock_bh(&session->lock);
 	mutex_unlock(&session->eh_mutex);
 	return SUCCESS;
 }
-EXPORT_SYMBOL_GPL(iscsi_eh_host_reset);
+EXPORT_SYMBOL_GPL(iscsi_eh_target_reset);
 
 static void iscsi_tmf_timedout(unsigned long data)
 {
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 7d8cd15..61e53f1 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -313,7 +313,7 @@ struct iscsi_host {
  */
 extern int iscsi_change_queue_depth(struct scsi_device *sdev, int depth);
 extern int iscsi_eh_abort(struct scsi_cmnd *sc);
-extern int iscsi_eh_host_reset(struct scsi_cmnd *sc);
+extern int iscsi_eh_target_reset(struct scsi_cmnd *sc);
 extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
 extern int iscsi_queuecommand(struct scsi_cmnd *sc,
 			      void (*done)(struct scsi_cmnd *));
-- 
1.5.4.1

