From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 28/47] qla2xxx: open-code qla2xxx_generic_reset()
Date: Wed, 28 Jun 2017 10:32:54 +0200
Message-ID: <1498638793-44672-29-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53812 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751505AbdF1IdY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:24 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Device and target reset will be using different calling sequences,
so there's not point in trying to combine both.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 106 ++++++++++++++++++++++++++++--------------
 1 file changed, 71 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a43f249..c068041 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1384,13 +1384,20 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 };
 
 static int
-__qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
-    struct scsi_cmnd *cmd, int (*do_reset)(struct fc_port *, uint64_t, int))
+qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
-	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
+	struct scsi_device *sdev = cmd->device;
+	scsi_qla_host_t *vha = shost_priv(sdev->host);
+	struct qla_hw_data *ha = vha->hw;
+	fc_port_t *fcport = (struct fc_port *) sdev->hostdata;
 	int err;
 
+	if (qla2x00_isp_reg_stat(ha)) {
+		ql_log(ql_log_info, vha, 0x803e,
+		    "PCI/Register disconnect, exiting.\n");
+		return FAILED;
+	}
+
 	if (!fcport) {
 		return FAILED;
 	}
@@ -1402,74 +1409,103 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	}
 
 	ql_log(ql_log_info, vha, 0x8009,
-	    "%s RESET ISSUED nexus=%ld:%d:%llu cmd=%p.\n", name, vha->host_no,
-	    cmd->device->id, cmd->device->lun, cmd);
+	    "DEVICE RESET ISSUED nexus=%ld:%d:%llu\n", vha->host_no,
+	    sdev->id, sdev->lun);
 
 	err = 0;
 	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800a,
-		    "Wait for hba online failed for cmd=%p.\n", cmd);
+		    "Wait for hba online failed.\n");
 		goto eh_reset_failed;
 	}
 	err = 2;
-	if (do_reset(fcport, cmd->device->lun, cmd->request->cpu + 1)
+	if (ha->isp_ops->lun_reset(fcport, sdev->lun, smp_processor_id() + 1)
 		!= QLA_SUCCESS) {
-		ql_log(ql_log_warn, vha, 0x800c,
-		    "do_reset failed for cmd=%p.\n", cmd);
+		ql_log(ql_log_warn, vha, 0x800c, "lun_reset failed.\n");
 		goto eh_reset_failed;
 	}
 	err = 3;
-	if (qla2x00_eh_wait_for_pending_commands(vha, cmd->device->id,
-	    cmd->device->lun, type) != QLA_SUCCESS) {
+	if (qla2x00_eh_wait_for_pending_commands(vha, sdev->id,
+		sdev->lun, WAIT_LUN) != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800d,
-		    "wait for pending cmds failed for cmd=%p.\n", cmd);
+		       "wait for pending cmds failed.\n");
 		goto eh_reset_failed;
 	}
 
 	ql_log(ql_log_info, vha, 0x800e,
-	    "%s RESET SUCCEEDED nexus:%ld:%d:%llu cmd=%p.\n", name,
-	    vha->host_no, cmd->device->id, cmd->device->lun, cmd);
+	    "DEVICE RESET SUCCEEDED nexus:%ld:%d:%llu\n",
+	    vha->host_no, sdev->id, sdev->lun);
 
 	return SUCCESS;
 
 eh_reset_failed:
 	ql_log(ql_log_info, vha, 0x800f,
-	    "%s RESET FAILED: %s nexus=%ld:%d:%llu cmd=%p.\n", name,
-	    reset_errors[err], vha->host_no, cmd->device->id, cmd->device->lun,
-	    cmd);
+	    "DEVICE RESET FAILED: %s nexus=%ld:%d:%llu\n",
+	    reset_errors[err], vha->host_no, sdev->id, sdev->lun);
 	return FAILED;
 }
 
 static int
-qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
+qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
+	struct scsi_device *sdev = cmd->device;
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+	scsi_qla_host_t *vha = shost_priv(rport_to_shost(rport));
 	struct qla_hw_data *ha = vha->hw;
+	fc_port_t *fcport = (struct fc_port *) rport->dd_data;
+	int err;
 
 	if (qla2x00_isp_reg_stat(ha)) {
-		ql_log(ql_log_info, vha, 0x803e,
+		ql_log(ql_log_info, vha, 0x803f,
 		    "PCI/Register disconnect, exiting.\n");
 		return FAILED;
 	}
 
-	return __qla2xxx_eh_generic_reset("DEVICE", WAIT_LUN, cmd,
-	    ha->isp_ops->lun_reset);
-}
+	if (!fcport) {
+		return FAILED;
+	}
 
-static int
-qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
-{
-	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
-	struct qla_hw_data *ha = vha->hw;
+	if (fcport->rport) {
+		err = fc_block_scsi_eh(fcport->rport);
+		if (err != 0)
+			return err;
+	}
 
-	if (qla2x00_isp_reg_stat(ha)) {
-		ql_log(ql_log_info, vha, 0x803f,
-		    "PCI/Register disconnect, exiting.\n");
-		return FAILED;
+	ql_log(ql_log_info, vha, 0x8009,
+	    "TARGET RESET ISSUED nexus=%ld:%d:0.\n", vha->host_no,
+	    cmd->device->id);
+
+	err = 0;
+	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x800a,
+		    "Wait for hba online failed.\n");
+		goto eh_reset_failed;
+	}
+	err = 2;
+	if (ha->isp_ops->target_reset(fcport, 0, smp_processor_id() + 1)
+	    != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x800c, "do_reset failed.\n");
+		goto eh_reset_failed;
+	}
+	err = 3;
+	if (qla2x00_eh_wait_for_pending_commands(vha, sdev->id,
+		0, WAIT_TARGET) != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x800d,
+		       "wait for pending cmds failed.\n");
+		goto eh_reset_failed;
 	}
 
-	return __qla2xxx_eh_generic_reset("TARGET", WAIT_TARGET, cmd,
-	    ha->isp_ops->target_reset);
+	ql_log(ql_log_info, vha, 0x800e,
+	    "TARGET RESET SUCCEEDED nexus:%ld:%d:0.\n",
+	    vha->host_no, sdev->id);
+
+	return SUCCESS;
+
+eh_reset_failed:
+	ql_log(ql_log_info, vha, 0x800f,
+	    "TARGET RESET FAILED: %s nexus=%ld:%d:0\n",
+	    reset_errors[err], vha->host_no, sdev->id);
+	return FAILED;
 }
 
 /**************************************************************************
-- 
1.8.5.6
