From: madhu.iyengar@qlogic.com
Subject: [PATCH 01/13] qla2xxx: Remove host_lock in queuecommand function
Date: Wed, 23 Feb 2011 15:27:06 -0800
Message-ID: <1298503638-22396-2-git-send-email-madhu.iyengar@qlogic.com>
References: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52606 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755026Ab1BWXa3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2011 18:30:29 -0500
In-Reply-To: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

From: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

Also in qla_os.c, rename the function, remove DEF_SCSI_QCMD, etc.

Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f27724d..0627453 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -506,7 +506,7 @@ qla24xx_fw_version_str(struct scsi_qla_host *vha, char *str)
 
 static inline srb_t *
 qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
-    struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+	struct scsi_cmnd *cmd)
 {
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
@@ -520,14 +520,13 @@ qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
 	sp->cmd = cmd;
 	sp->flags = 0;
 	CMD_SP(cmd) = (void *)sp;
-	cmd->scsi_done = done;
 	sp->ctx = NULL;
 
 	return sp;
 }
 
 static int
-qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
@@ -537,7 +536,6 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *)
 	srb_t *sp;
 	int rval;
 
-	spin_unlock_irq(vha->host->host_lock);
 	if (ha->flags.eeh_busy) {
 		if (ha->flags.pci_channel_io_perm_failure)
 			cmd->result = DID_NO_CONNECT << 16;
@@ -569,40 +567,32 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *)
 		goto qc24_target_busy;
 	}
 
-	sp = qla2x00_get_new_sp(base_vha, fcport, cmd, done);
+	sp = qla2x00_get_new_sp(base_vha, fcport, cmd);
 	if (!sp)
-		goto qc24_host_busy_lock;
+		goto qc24_host_busy;
 
 	rval = ha->isp_ops->start_scsi(sp);
 	if (rval != QLA_SUCCESS)
 		goto qc24_host_busy_free_sp;
 
-	spin_lock_irq(vha->host->host_lock);
-
 	return 0;
 
 qc24_host_busy_free_sp:
 	qla2x00_sp_free_dma(sp);
 	mempool_free(sp, ha->srb_mempool);
 
-qc24_host_busy_lock:
-	spin_lock_irq(vha->host->host_lock);
+qc24_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
 
 qc24_target_busy:
-	spin_lock_irq(vha->host->host_lock);
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 qc24_fail_command:
-	spin_lock_irq(vha->host->host_lock);
-	done(cmd);
+	cmd->scsi_done(cmd);
 
 	return 0;
 }
 
-static DEF_SCSI_QCMD(qla2xxx_queuecommand)
-
-
 /*
  * qla2x00_eh_wait_on_command
  *    Waits for the command to be returned by the Firmware for some
-- 
1.6.0.2

