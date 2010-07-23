From: giridhar.malavali@qlogic.com
Subject: [PATCH 14/17] qla2xxx: Rearranged and cleaned up the code for processing the pending commands.
Date: Fri, 23 Jul 2010 15:28:35 +0500
Message-ID: <1279880918-62876-15-git-send-email-giridhar.malavali@qlogic.com>
References: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47967 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755708Ab0GWJ7v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2010 05:59:51 -0400
In-Reply-To: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, madhu.iyengar@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>


Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |   10 +++++++-
 drivers/scsi/qla2xxx/qla_gbl.h  |    5 ++-
 drivers/scsi/qla2xxx/qla_init.c |    9 ++++++-
 drivers/scsi/qla2xxx/qla_os.c   |   41 ++++++--------------------------------
 4 files changed, 25 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 7e11ccf..84e9c6b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2981,9 +2981,15 @@ typedef struct scsi_qla_host {
 
 #define	QLA_DSDS_PER_IOCB	37
 
+#define CMD_SP(Cmnd)		((Cmnd)->SCp.ptr)
+
+enum nexus_wait_type {
+	WAIT_HOST = 0,
+	WAIT_TARGET,
+	WAIT_LUN,
+};
+
 #include "qla_gbl.h"
 #include "qla_dbg.h"
 #include "qla_inline.h"
-
-#define CMD_SP(Cmnd)		((Cmnd)->SCp.ptr)
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 8b0a8ca..4688ad2 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -292,7 +292,9 @@ extern int
 qla24xx_abort_target(struct fc_port *, unsigned int, int);
 extern int
 qla24xx_lun_reset(struct fc_port *, unsigned int, int);
-
+extern int
+qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *, unsigned int,
+	unsigned int, enum nexus_wait_type);
 extern int
 qla2x00_system_error(scsi_qla_host_t *);
 
@@ -569,7 +571,6 @@ extern int qla82xx_mbx_intr_enable(scsi_qla_host_t *);
 extern int qla82xx_mbx_intr_disable(scsi_qla_host_t *);
 extern void qla82xx_start_iocbs(srb_t *);
 extern int qla82xx_fcoe_ctx_reset(scsi_qla_host_t *);
-extern void qla82xx_wait_for_pending_commands(scsi_qla_host_t *);
 
 /* BSG related functions */
 extern int qla24xx_bsg_request(struct fc_bsg_job *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f6b1052..9b58a79 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3833,8 +3833,13 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 	}
 
 	/* Make sure for ISP 82XX IO DMA is complete */
-	if (IS_QLA82XX(ha))
-		qla82xx_wait_for_pending_commands(vha);
+	if (IS_QLA82XX(ha)) {
+		if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0,
+			WAIT_HOST) == QLA_SUCCESS) {
+			DEBUG2(qla_printk(KERN_INFO, ha,
+			"Done wait for pending commands\n"));
+		}
+	}
 
 	/* Requeue all commands in outstanding command list. */
 	qla2x00_abort_all_cmds(vha, DID_RESET << 16);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index fcdbf7a..86d352a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -903,24 +903,17 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	return ret;
 }
 
-enum nexus_wait_type {
-	WAIT_HOST = 0,
-	WAIT_TARGET,
-	WAIT_LUN,
-};
-
-static int
+int
 qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
-	unsigned int l, srb_t *sp, enum nexus_wait_type type)
+	unsigned int l, enum nexus_wait_type type)
 {
 	int cnt, match, status;
 	unsigned long flags;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
+	srb_t *sp;
 
 	status = QLA_SUCCESS;
-	if (!sp)
-		return status;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	req = vha->req;
@@ -958,24 +951,6 @@ qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
 	return status;
 }
 
-void qla82xx_wait_for_pending_commands(scsi_qla_host_t *vha)
-{
-	int cnt;
-	srb_t *sp;
-	struct req_que *req = vha->req;
-
-	DEBUG2(qla_printk(KERN_INFO, vha->hw,
-		"Waiting for pending commands\n"));
-	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-		sp = req->outstanding_cmds[cnt];
-		if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0,
-			sp, WAIT_HOST) == QLA_SUCCESS) {
-			DEBUG2(qla_printk(KERN_INFO, vha->hw,
-				"Done wait for pending commands\n"));
-		}
-	}
-}
-
 static char *reset_errors[] = {
 	"HBA not online",
 	"HBA not ready",
@@ -1011,7 +986,7 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 		goto eh_reset_failed;
 	err = 3;
 	if (qla2x00_eh_wait_for_pending_commands(vha, cmd->device->id,
-	    cmd->device->lun, (srb_t *) CMD_SP(cmd), type) != QLA_SUCCESS)
+	    cmd->device->lun, type) != QLA_SUCCESS)
 		goto eh_reset_failed;
 
 	qla_printk(KERN_INFO, vha->hw, "scsi(%ld:%d:%d): %s RESET SUCCEEDED.\n",
@@ -1019,7 +994,7 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 
 	return SUCCESS;
 
- eh_reset_failed:
+eh_reset_failed:
 	qla_printk(KERN_INFO, vha->hw, "scsi(%ld:%d:%d): %s RESET FAILED: %s.\n"
 	    , vha->host_no, cmd->device->id, cmd->device->lun, name,
 	    reset_errors[err]);
@@ -1069,7 +1044,6 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 	int ret = FAILED;
 	unsigned int id, lun;
 	unsigned long serial;
-	srb_t *sp = (srb_t *) CMD_SP(cmd);
 
 	fc_block_scsi_eh(cmd);
 
@@ -1096,7 +1070,7 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 		goto eh_bus_reset_done;
 
 	/* Flush outstanding commands. */
-	if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0, sp, WAIT_HOST) !=
+	if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0, WAIT_HOST) !=
 	    QLA_SUCCESS)
 		ret = FAILED;
 
@@ -1131,7 +1105,6 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	int ret = FAILED;
 	unsigned int id, lun;
 	unsigned long serial;
-	srb_t *sp = (srb_t *) CMD_SP(cmd);
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	fc_block_scsi_eh(cmd);
@@ -1186,7 +1159,7 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	}
 
 	/* Waiting for command to be returned to OS.*/
-	if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0, sp, WAIT_HOST) ==
+	if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0, WAIT_HOST) ==
 		QLA_SUCCESS)
 		ret = SUCCESS;
 
-- 
1.6.0.2

