From: madhu.iyengar@qlogic.com
Subject: [PATCH 12/13] qla2xxx: Check return value of fc_block_scsi_eh()
Date: Wed, 23 Feb 2011 15:27:17 -0800
Message-ID: <1298503638-22396-13-git-send-email-madhu.iyengar@qlogic.com>
References: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52638 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755206Ab1BWXab (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2011 18:30:31 -0500
In-Reply-To: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

The fc_block_scsi_eh() might return with status FAST_IO_FAIL
indicating I/O has been terminated due to fast_io_fail timeout.
In this case the rport is still blocked, so any error recovery
will be failing on this port. Hence we need to check if the
return value from fc_block_scsi_eh() is something other than 0,
in which case it should just return with that status.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   29 ++++++++++++++++++++---------
 1 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7e576c5..6c002fb 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -811,17 +811,20 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	srb_t *sp;
-	int ret = SUCCESS;
+	int ret;
 	unsigned int id, lun;
 	unsigned long flags;
 	int wait = 0;
 	struct qla_hw_data *ha = vha->hw;
 
-	fc_block_scsi_eh(cmd);
-
 	if (!CMD_SP(cmd))
 		return SUCCESS;
 
+	ret = fc_block_scsi_eh(cmd);
+	if (ret != 0)
+		return ret;
+	ret = SUCCESS;
+
 	id = cmd->device->id;
 	lun = cmd->device->lun;
 
@@ -930,11 +933,13 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	int err;
 
-	fc_block_scsi_eh(cmd);
-
 	if (!fcport)
 		return FAILED;
 
+	err = fc_block_scsi_eh(cmd);
+	if (err != 0)
+		return err;
+
 	qla_printk(KERN_INFO, vha->hw, "scsi(%ld:%d:%d): %s RESET ISSUED.\n",
 	    vha->host_no, cmd->device->id, cmd->device->lun, name);
 
@@ -1008,14 +1013,17 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 	int ret = FAILED;
 	unsigned int id, lun;
 
-	fc_block_scsi_eh(cmd);
-
 	id = cmd->device->id;
 	lun = cmd->device->lun;
 
 	if (!fcport)
 		return ret;
 
+	ret = fc_block_scsi_eh(cmd);
+	if (ret != 0)
+		return ret;
+	ret = FAILED;
+
 	qla_printk(KERN_INFO, vha->hw,
 	    "scsi(%ld:%d:%d): BUS RESET ISSUED.\n", vha->host_no, id, lun);
 
@@ -1068,14 +1076,17 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	unsigned int id, lun;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
-	fc_block_scsi_eh(cmd);
-
 	id = cmd->device->id;
 	lun = cmd->device->lun;
 
 	if (!fcport)
 		return ret;
 
+	ret = fc_block_scsi_eh(cmd);
+	if (ret != 0)
+		return ret;
+	ret = FAILED;
+
 	qla_printk(KERN_INFO, ha,
 	    "scsi(%ld:%d:%d): ADAPTER RESET ISSUED.\n", vha->host_no, id, lun);
 
-- 
1.6.0.2

