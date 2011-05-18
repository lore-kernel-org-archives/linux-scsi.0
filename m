From: vikas.chaudhary@qlogic.com
Subject: [PATCH 08/10] qla4xxx: Remove host_lock in queuecommand function
Date: Tue, 17 May 2011 23:17:10 -0700
Message-ID: <1305699432-13225-9-git-send-email-vikas.chaudhary@qlogic.com>
References: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:50942 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754525Ab1ERGXq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 02:23:46 -0400
In-Reply-To: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   26 +++++++-------------------
 1 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 9c1c845..9bfe9ce 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -412,8 +412,7 @@ void qla4xxx_mark_all_devices_missing(struct scsi_qla_host *ha)
 
 static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
 				       struct ddb_entry *ddb_entry,
-				       struct scsi_cmnd *cmd,
-				       void (*done)(struct scsi_cmnd *))
+				       struct scsi_cmnd *cmd)
 {
 	struct srb *srb;
 
@@ -427,7 +426,6 @@ static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
 	srb->cmd = cmd;
 	srb->flags = 0;
 	CMD_SP(cmd) = (void *)srb;
-	cmd->scsi_done = done;
 
 	return srb;
 }
@@ -458,9 +456,8 @@ void qla4xxx_srb_compl(struct kref *ref)
 
 /**
  * qla4xxx_queuecommand - scsi layer issues scsi command to driver.
+ * @host: scsi host
  * @cmd: Pointer to Linux's SCSI command structure
- * @done_fn: Function that the driver calls to notify the SCSI mid-layer
- *	that the command has been processed.
  *
  * Remarks:
  * This routine is invoked by Linux to send a SCSI command to the driver.
@@ -470,10 +467,9 @@ void qla4xxx_srb_compl(struct kref *ref)
  * completion handling).   Unfortunely, it sometimes calls the scheduler
  * in interrupt context which is a big NO! NO!.
  **/
-static int qla4xxx_queuecommand_lck(struct scsi_cmnd *cmd,
-				void (*done)(struct scsi_cmnd *))
+static int qla4xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
-	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
+	struct scsi_qla_host *ha = to_qla_host(host);
 	struct ddb_entry *ddb_entry = cmd->device->hostdata;
 	struct iscsi_cls_session *sess = ddb_entry->sess;
 	struct srb *srb;
@@ -515,37 +511,29 @@ static int qla4xxx_queuecommand_lck(struct scsi_cmnd *cmd,
 	    test_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags))
 		goto qc_host_busy;
 
-	spin_unlock_irq(ha->host->host_lock);
-
-	srb = qla4xxx_get_new_srb(ha, ddb_entry, cmd, done);
+	srb = qla4xxx_get_new_srb(ha, ddb_entry, cmd);
 	if (!srb)
-		goto qc_host_busy_lock;
+		goto qc_host_busy;
 
 	rval = qla4xxx_send_command_to_isp(ha, srb);
 	if (rval != QLA_SUCCESS)
 		goto qc_host_busy_free_sp;
 
-	spin_lock_irq(ha->host->host_lock);
 	return 0;
 
 qc_host_busy_free_sp:
 	qla4xxx_srb_free_dma(ha, srb);
 	mempool_free(srb, ha->srb_mempool);
 
-qc_host_busy_lock:
-	spin_lock_irq(ha->host->host_lock);
-
 qc_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
 
 qc_fail_command:
-	done(cmd);
+	cmd->scsi_done(cmd);
 
 	return 0;
 }
 
-static DEF_SCSI_QCMD(qla4xxx_queuecommand)
-
 /**
  * qla4xxx_mem_free - frees memory allocated to adapter
  * @ha: Pointer to host adapter structure.
-- 
1.7.3.2

