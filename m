From: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 3/3] qla2xxx: Run queuecommand outside the host_lock
Date: Fri, 1 Apr 2011 16:22:09 -0400
Message-ID: <20110401202209.GN4183@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20926 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab1DAUWM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2011 16:22:12 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The qla2xxx driver still uses the host_lock, but only to protect against
some rare events like rport deletion.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f27724d..61340e1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -506,7 +506,7 @@ qla24xx_fw_version_str(struct scsi_qla_host *vha, char *str)
 
 static inline srb_t *
 qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
-    struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+    struct scsi_cmnd *cmd)
 {
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
@@ -520,16 +520,15 @@ qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
 	sp->cmd = cmd;
 	sp->flags = 0;
 	CMD_SP(cmd) = (void *)sp;
-	cmd->scsi_done = done;
 	sp->ctx = NULL;
 
 	return sp;
 }
 
 static int
-qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+qla2xxx_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
+	scsi_qla_host_t *vha = shost_priv(shost);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmd->device));
 	struct qla_hw_data *ha = vha->hw;
@@ -537,7 +536,6 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *)
 	srb_t *sp;
 	int rval;
 
-	spin_unlock_irq(vha->host->host_lock);
 	if (ha->flags.eeh_busy) {
 		if (ha->flags.pci_channel_io_perm_failure)
 			cmd->result = DID_NO_CONNECT << 16;
@@ -569,7 +567,7 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *)
 		goto qc24_target_busy;
 	}
 
-	sp = qla2x00_get_new_sp(base_vha, fcport, cmd, done);
+	sp = qla2x00_get_new_sp(base_vha, fcport, cmd);
 	if (!sp)
 		goto qc24_host_busy_lock;
 
@@ -577,8 +575,6 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *)
 	if (rval != QLA_SUCCESS)
 		goto qc24_host_busy_free_sp;
 
-	spin_lock_irq(vha->host->host_lock);
-
 	return 0;
 
 qc24_host_busy_free_sp:
@@ -586,23 +582,17 @@ qc24_host_busy_free_sp:
 	mempool_free(sp, ha->srb_mempool);
 
 qc24_host_busy_lock:
-	spin_lock_irq(vha->host->host_lock);
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
