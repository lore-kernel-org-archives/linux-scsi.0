From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCH 08/10] qla4xxx: qla4xxx_flush_active_srbs defn before use
Date: Mon, 07 Aug 2006 10:38:04 -0500
Message-ID: <20060807153804.31019.84560.stgit@bebe.enoyolf.org>
References: <20060807153640.31019.50863.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:42658 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S932169AbWHGPk0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Aug 2006 11:40:26 -0400
In-Reply-To: <20060807153640.31019.50863.stgit@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

From: Doug Maxey <dwm@enoyolf.org>

- move the defn to before the call.

Signed-off-by: Doug Maxey <dwm@enoyolf.org>
---

 drivers/scsi/qla4xxx/ql4_os.c |   55 ++++++++++++++++++++---------------------
 1 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 71498c7..7c48e54 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -44,7 +44,6 @@ MODULE_PARM_DESC(extended_error_logging,
  * SCSI host template entry points
  */
 
-static void qla4xxx_flush_active_srbs(struct scsi_qla_host *ha);
 void qla4xxx_config_dma_addressing(struct scsi_qla_host *ha);
 
 static int qla4xxx_iospace_config(struct scsi_qla_host *ha);
@@ -842,6 +841,33 @@ static int qla4xxx_topcat_reset(struct s
 }
 
 /**
+ * qla4xxx_flush_active_srbs - returns all outstanding i/o requests to O.S.
+ * @ha: Pointer to host adapter structure.
+ *
+ * This routine is called just prior to a HARD RESET to return all
+ * outstanding commands back to the Operating System.
+ * Caller should make sure that the following locks are released
+ * before this calling routine: Hardware lock, and io_request_lock.
+ **/
+static void qla4xxx_flush_active_srbs(struct scsi_qla_host *ha)
+{
+	struct srb *srb;
+	int i;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	for (i = 1; i < MAX_SRBS; i++) {
+		if ((srb = ha->active_srb_array[i]) != NULL) {
+			del_from_active_array(ha, i);
+			srb->cmd->result = DID_RESET << 16;
+			qla4xxx_srb_compl(ha, srb);
+		}
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+}
+
+/**
  * qla4xxx_hard_reset - performs HBA Hard Reset
  * @ha: Pointer to host adapter structure.
  **/
@@ -1701,33 +1727,6 @@ static int qla4xxx_eh_bus_reset(struct s
 }
 
 /**
- * qla4xxx_flush_active_srbs - returns all outstanding i/o requests to O.S.
- * @ha: Pointer to host adapter structure.
- *
- * This routine is called just prior to a HARD RESET to return all
- * outstanding commands back to the Operating System.
- * Caller should make sure that the following locks are released
- * before this calling routine: Hardware lock, and io_request_lock.
- **/
-static void qla4xxx_flush_active_srbs(struct scsi_qla_host *ha)
-{
-	struct srb *srb;
-	int i;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (i = 1; i < MAX_SRBS; i++) {
-		if ((srb = ha->active_srb_array[i]) != NULL) {
-			del_from_active_array(ha, i);
-			srb->cmd->result = DID_RESET << 16;
-			qla4xxx_srb_compl(ha, srb);
-		}
-	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-}
-
-/**
  * qla4xxx_eh_host_reset - kernel callback
  * @cmd: Pointer to Linux's SCSI command structure
  *
