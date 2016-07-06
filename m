From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 16/19] qla2xxx: Disable the adapter and skip error recovery in case of register disconnect.
Date: Wed, 6 Jul 2016 11:14:32 -0400
Message-ID: <1467818075-15246-17-git-send-email-himanshu.madhani@qlogic.com>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:33890 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754730AbcGFP76 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 11:59:58 -0400
In-Reply-To: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@qlogic.com>

If there is error recovery going on due to command timeout and
there is register disconnect, then disable the adapter.

Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |  3 +++
 drivers/scsi/qla2xxx/qla_dbg.c  |  2 +-
 drivers/scsi/qla2xxx/qla_os.c   | 55 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 8b06ce8..fe7469c 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1769,6 +1769,9 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 	if (!fcport)
 		return;
 
+	if (test_bit(UNLOADING, &fcport->vha->dpc_flags))
+		return;
+
 	if (test_bit(ABORT_ISP_ACTIVE, &fcport->vha->dpc_flags))
 		return;
 
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 1a04270..97b0a9d 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -41,7 +41,7 @@
  * |                              |                    | 0x70ad-0x70ae  |
  * |                              |                    | 0x70d0-0x70d6	|
  * |                              |                    | 0x70d7-0x70db  |
- * | Task Management              |       0x803d       | 0x8000,0x800b  |
+ * | Task Management              |       0x8042       | 0x8000,0x800b  |
  * |                              |                    | 0x8019         |
  * |                              |                    | 0x8025,0x8026  |
  * |                              |                    | 0x8031,0x8032  |
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index dc7e583..2674f4c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -943,6 +943,30 @@ sp_get(struct srb *sp)
 	atomic_inc(&sp->ref_count);
 }
 
+#define ISP_REG_DISCONNECT 0xffffffffU
+/**************************************************************************
+* qla2x00_isp_reg_stat
+*
+* Description:
+*	Read the host status register of ISP before aborting the command.
+*
+* Input:
+*	ha = pointer to host adapter structure.
+*
+*
+* Returns:
+*	Either true or false.
+*
+* Note:	Return true if there is register disconnect.
+**************************************************************************/
+static inline
+uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
+{
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+
+	return ((RD_REG_DWORD(&reg->host_status)) == ISP_REG_DISCONNECT);
+}
+
 /**************************************************************************
 * qla2xxx_eh_abort
 *
@@ -970,6 +994,11 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	int rval, wait = 0;
 	struct qla_hw_data *ha = vha->hw;
 
+	if (qla2x00_isp_reg_stat(ha)) {
+		ql_log(ql_log_info, vha, 0x8042,
+		    "PCI/Register disconnect, exiting.\n");
+		return FAILED;
+	}
 	if (!CMD_SP(cmd))
 		return SUCCESS;
 
@@ -1153,6 +1182,12 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	struct qla_hw_data *ha = vha->hw;
 
+	if (qla2x00_isp_reg_stat(ha)) {
+		ql_log(ql_log_info, vha, 0x803e,
+		    "PCI/Register disconnect, exiting.\n");
+		return FAILED;
+	}
+
 	return __qla2xxx_eh_generic_reset("DEVICE", WAIT_LUN, cmd,
 	    ha->isp_ops->lun_reset);
 }
@@ -1163,6 +1198,12 @@ qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	struct qla_hw_data *ha = vha->hw;
 
+	if (qla2x00_isp_reg_stat(ha)) {
+		ql_log(ql_log_info, vha, 0x803f,
+		    "PCI/Register disconnect, exiting.\n");
+		return FAILED;
+	}
+
 	return __qla2xxx_eh_generic_reset("TARGET", WAIT_TARGET, cmd,
 	    ha->isp_ops->target_reset);
 }
@@ -1190,6 +1231,13 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 	int ret = FAILED;
 	unsigned int id;
 	uint64_t lun;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (qla2x00_isp_reg_stat(ha)) {
+		ql_log(ql_log_info, vha, 0x8040,
+		    "PCI/Register disconnect, exiting.\n");
+		return FAILED;
+	}
 
 	id = cmd->device->id;
 	lun = cmd->device->lun;
@@ -1259,6 +1307,13 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	uint64_t lun;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
+	if (qla2x00_isp_reg_stat(ha)) {
+		ql_log(ql_log_info, vha, 0x8041,
+		    "PCI/Register disconnect, exiting.\n");
+		schedule_work(&ha->board_disable);
+		return SUCCESS;
+	}
+
 	id = cmd->device->id;
 	lun = cmd->device->lun;
 
-- 
2.7.2

