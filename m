From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 2/2] iscsi_transport: wait on session in error handler path
Date: Thu, 22 Jul 2010 16:59:49 +0530 (IST)
Message-ID: <alpine.OSX.1.00.1007221657480.1395@Vikas.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:38056
	"HELO Vikas.local" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with SMTP id S1757210Ab0GVL3x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2010 07:29:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com

From: Mike Christie <michaelc@cs.wisc.edu>

wait for session to come online in eh_device_reset_handler
and eh_target_reset_handler

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c       |   11 ++++++++++-
 drivers/scsi/scsi_transport_iscsi.c |   32 ++++++++++++++++++++++++++++++++
 include/scsi/scsi_transport_iscsi.h |    2 ++
 3 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 686103d..468f81d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2020,6 +2020,11 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 	if (!ddb_entry)
 		return ret;
 
+	ret = iscsi_block_scsi_eh(cmd);
+	if (ret)
+		return ret;
+	ret = FAILED;
+
 	ql4_printk(KERN_INFO, ha,
 		   "scsi%ld:%d:%d:%d: DEVICE RESET ISSUED.\n", ha->host_no,
 		   cmd->device->channel, cmd->device->id, cmd->device->lun);
@@ -2072,11 +2077,15 @@ static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd)
 {
 	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
 	struct ddb_entry *ddb_entry = cmd->device->hostdata;
-	int stat;
+	int stat, ret;
 
 	if (!ddb_entry)
 		return FAILED;
 
+	ret = iscsi_block_scsi_eh(cmd);
+	if (ret)
+		return ret;
+
 	starget_printk(KERN_INFO, scsi_target(cmd->device),
 		       "WARM TARGET RESET ISSUED.\n");
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index d4b9662..e84026d 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -30,6 +30,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/iscsi_if.h>
+#include <scsi/scsi_cmnd.h>
 
 #define ISCSI_SESSION_ATTRS 23
 #define ISCSI_CONN_ATTRS 13
@@ -534,6 +535,37 @@ static void iscsi_scan_session(struct work_struct *work)
 	atomic_dec(&ihost->nr_scans);
 }
 
+/**
+ * iscsi_block_scsi_eh - block scsi eh until session state has transistioned
+ * cmd: scsi cmd passed to scsi eh handler
+ *
+ * If the session is down this function will wait for the recovery
+ * timer to fire or for the session to be logged back in. If the
+ * recovery timer fires then FAST_IO_FAIL is returned. The caller
+ * should pass this error value to the scsi eh.
+ */
+int iscsi_block_scsi_eh(struct scsi_cmnd *cmd)
+{
+	struct iscsi_cls_session *session =
+			starget_to_session(scsi_target(cmd->device));
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&session->lock, flags);
+	while (session->state != ISCSI_SESSION_LOGGED_IN) {
+		if (session->state == ISCSI_SESSION_FREE) {
+			ret = FAST_IO_FAIL;
+			break;
+		}
+		spin_unlock_irqrestore(&session->lock, flags);
+		msleep(1000);
+		spin_lock_irqsave(&session->lock, flags);
+	}
+	spin_unlock_irqrestore(&session->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iscsi_block_scsi_eh);
+
 static void session_recovery_timedout(struct work_struct *work)
 {
 	struct iscsi_cls_session *session =
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 349c7f3..7fff94b 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -32,6 +32,7 @@ struct scsi_transport_template;
 struct iscsi_transport;
 struct iscsi_endpoint;
 struct Scsi_Host;
+struct scsi_cmnd;
 struct iscsi_cls_conn;
 struct iscsi_conn;
 struct iscsi_task;
@@ -255,5 +256,6 @@ extern int iscsi_scan_finished(struct Scsi_Host *shost, unsigned long time);
 extern struct iscsi_endpoint *iscsi_create_endpoint(int dd_size);
 extern void iscsi_destroy_endpoint(struct iscsi_endpoint *ep);
 extern struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle);
+extern int iscsi_block_scsi_eh(struct scsi_cmnd *cmd);
 
 #endif
-- 
1.7.0.5

