From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 24/26] qla2xxx: Correct several PCI-EEH issues.
Date: Tue, 24 Mar 2009 09:08:18 -0700
Message-ID: <1237910900-30817-25-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29880 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762387AbZCXQIs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:48 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

From: Seokmann Ju <seokmann.ju@qlogic.com>

In addition to checking for potentially unnecessary iomem
readX()/writeX() operations, a pci_channel_io_perm_failure should
not trigger a full internal removal.  Found during additional
testing with pSeries blade systems.

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    9 ++++++++-
 drivers/scsi/qla2xxx/qla_mbx.c  |    3 +++
 drivers/scsi/qla2xxx/qla_os.c   |    9 +++++++--
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index cac4441..47ff974 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1282,7 +1282,10 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 	if (!fcport)
 		return;
 
-	qla2x00_abort_fcport_cmds(fcport);
+	if (unlikely(pci_channel_offline(fcport->vha->hw->pdev)))
+		qla2x00_abort_all_cmds(fcport->vha, DID_NO_CONNECT << 16);
+	else
+		qla2x00_abort_fcport_cmds(fcport);
 
 	/*
 	 * Transport has effectively 'deleted' the rport, clear
@@ -1302,6 +1305,10 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 	if (!fcport)
 		return;
 
+	if (unlikely(pci_channel_offline(fcport->vha->hw->pdev))) {
+		qla2x00_abort_all_cmds(fcport->vha, DID_NO_CONNECT << 16);
+		return;
+	}
 	/*
 	 * At this point all fcport's software-states are cleared.  Perform any
 	 * final cleanup of firmware resources (PCBs and XCBs).
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 951537e..e67c166 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -45,6 +45,9 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
+	if (ha->pdev->error_state > pci_channel_io_frozen)
+		return QLA_FUNCTION_TIMEOUT;
+
 	reg = ha->iobase;
 	io_lock_on = base_vha->flags.init_done;
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7e038e4..efe2992 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -407,7 +407,10 @@ qla2xxx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	int rval;
 
 	if (unlikely(pci_channel_offline(ha->pdev))) {
-		cmd->result = DID_REQUEUE << 16;
+		if (ha->pdev->error_state == pci_channel_io_frozen)
+			cmd->result = DID_REQUEUE << 16;
+		else
+			cmd->result = DID_NO_CONNECT << 16;
 		goto qc24_fail_command;
 	}
 
@@ -2990,6 +2993,8 @@ qla2x00_release_firmware(void)
 static pci_ers_result_t
 qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 {
+	scsi_qla_host_t *base_vha = pci_get_drvdata(pdev);
+
 	switch (state) {
 	case pci_channel_io_normal:
 		return PCI_ERS_RESULT_CAN_RECOVER;
@@ -2997,7 +3002,7 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 		pci_disable_device(pdev);
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
-		qla2x00_remove_one(pdev);
+		qla2x00_abort_all_cmds(base_vha, DID_NO_CONNECT << 16);
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 	return PCI_ERS_RESULT_NEED_RESET;
-- 
1.6.2.rc0.55.g30aa4f

