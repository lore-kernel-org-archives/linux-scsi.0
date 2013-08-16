From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 2/4] qla4xxx: Implementation of ACB configuration during Loopback for ISP8042
Date: Fri, 16 Aug 2013 07:03:03 -0400
Message-ID: <1376650985-11416-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1376650985-11416-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:42162 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754366Ab3HPMGI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Aug 2013 08:06:08 -0400
In-Reply-To: <1376650985-11416-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Nilesh Javali <nilesh.javali@qlogic.com>

From: Nilesh Javali <nilesh.javali@qlogic.com>

While loopback diagnostic is in progress, disable the ACB which resets
all the active connections to target. Disable ACB would filter out all
the DHCP multicast and broadcast packets which otherwise cause the
diagnostic test to take longer time to complete or failures in some
other cases.

Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |   3 +
 drivers/scsi/qla4xxx/ql4_fw.h   |   6 ++
 drivers/scsi/qla4xxx/ql4_glbl.h |   6 ++
 drivers/scsi/qla4xxx/ql4_isr.c  |  34 +++++++++--
 drivers/scsi/qla4xxx/ql4_mbx.c  | 132 +++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla4xxx/ql4_os.c   |  31 +++++++++-
 6 files changed, 203 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index bd01af5..cf0f30c 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -205,6 +205,7 @@
 
 #define MAX_RESET_HA_RETRIES		2
 #define FW_ALIVE_WAIT_TOV		3
+#define IDC_EXTEND_TOV			8
 
 #define CMD_SP(Cmnd)			((Cmnd)->SCp.ptr)
 
@@ -562,6 +563,7 @@ struct scsi_qla_host {
 #define DPC_HA_UNRECOVERABLE		21 /* 0x00080000 ISP-82xx only*/
 #define DPC_HA_NEED_QUIESCENT		22 /* 0x00100000 ISP-82xx only*/
 #define DPC_POST_IDC_ACK		23 /* 0x00200000 */
+#define DPC_RESTORE_ACB			24 /* 0x01000000 */
 
 	struct Scsi_Host *host; /* pointer to host data */
 	uint32_t tot_ddbs;
@@ -786,6 +788,7 @@ struct scsi_qla_host {
 							   and ISP8042 */
 	uint32_t pf_bit;
 	struct qla4_83xx_idc_information idc_info;
+	struct addr_ctrl_blk *saved_acb;
 };
 
 struct ql4_task_data {
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 9a46f59..7aa1323 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -458,6 +458,7 @@ struct qla_flt_region {
 #define MBOX_CMD_GET_CONN_EVENT_LOG		0x0077
 
 #define MBOX_CMD_IDC_ACK			0x0101
+#define MBOX_CMD_IDC_TIME_EXTEND		0x0102
 #define MBOX_CMD_PORT_RESET			0x0120
 #define MBOX_CMD_SET_PORT_CONFIG		0x0122
 
@@ -502,6 +503,7 @@ struct qla_flt_region {
 #define MBOX_ASTS_SYSTEM_WARNING_EVENT		0x8036
 #define MBOX_ASTS_IDC_COMPLETE			0x8100
 #define MBOX_ASTS_IDC_REQUEST_NOTIFICATION	0x8101
+#define MBOX_ASTS_IDC_TIME_EXTEND_NOTIFICATION	0x8102
 #define MBOX_ASTS_DCBX_CONF_CHANGE		0x8110
 #define MBOX_ASTS_TXSCVR_INSERTED		0x8130
 #define MBOX_ASTS_TXSCVR_REMOVED		0x8131
@@ -512,6 +514,10 @@ struct qla_flt_region {
 #define MBOX_ASTS_IPSEC_SYSTEM_FATAL_ERROR	0x8022
 #define MBOX_ASTS_SUBNET_STATE_CHANGE		0x8027
 
+/* ACB Configuration Defines */
+#define ACB_CONFIG_DISABLE		0x00
+#define ACB_CONFIG_SET			0x01
+
 /* ACB State Defines */
 #define ACB_STATE_UNCONFIGURED	0x00
 #define ACB_STATE_INVALID	0x01
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 4a42800..f9963de 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -266,6 +266,12 @@ int qla4xxx_get_default_ddb(struct scsi_qla_host *ha, uint32_t options,
 			    dma_addr_t dma_addr);
 int qla4xxx_get_uni_chap_at_index(struct scsi_qla_host *ha, char *username,
 				  char *password, uint16_t chap_index);
+int qla4xxx_disable_acb(struct scsi_qla_host *ha);
+int qla4xxx_set_acb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
+		    uint32_t *mbox_sts, dma_addr_t acb_dma);
+int qla4xxx_get_acb(struct scsi_qla_host *ha, dma_addr_t acb_dma,
+		    uint32_t acb_type, uint32_t len);
+int qla4_84xx_config_acb(struct scsi_qla_host *ha, int acb_config);
 
 extern int ql4xextended_error_logging;
 extern int ql4xdontresethba;
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index fbd415d..4fefa34 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -745,17 +745,23 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 			 * mbox_sts[3] = new ACB state */
 			if ((mbox_sts[3] == ACB_STATE_VALID) &&
 			    ((mbox_sts[2] == ACB_STATE_TENTATIVE) ||
-			    (mbox_sts[2] == ACB_STATE_ACQUIRING)))
+			    (mbox_sts[2] == ACB_STATE_ACQUIRING))) {
 				set_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags);
-			else if ((mbox_sts[3] == ACB_STATE_ACQUIRING) &&
-				 (mbox_sts[2] == ACB_STATE_VALID)) {
+			} else if ((mbox_sts[3] == ACB_STATE_ACQUIRING) &&
+				   (mbox_sts[2] == ACB_STATE_VALID)) {
 				if (is_qla80XX(ha))
 					set_bit(DPC_RESET_HA_FW_CONTEXT,
 						&ha->dpc_flags);
 				else
 					set_bit(DPC_RESET_HA, &ha->dpc_flags);
-			} else if ((mbox_sts[3] == ACB_STATE_UNCONFIGURED))
+			} else if (mbox_sts[3] == ACB_STATE_DISABLING) {
+				ql4_printk(KERN_INFO, ha, "scsi%ld: %s: ACB in disabling state\n",
+					   ha->host_no, __func__);
+			} else if ((mbox_sts[3] == ACB_STATE_UNCONFIGURED)) {
 				complete(&ha->disable_acb_comp);
+				ql4_printk(KERN_INFO, ha, "scsi%ld: %s: ACB state unconfigured\n",
+					   ha->host_no, __func__);
+			}
 			break;
 
 		case MBOX_ASTS_MAC_ADDRESS_CHANGED:
@@ -869,10 +875,15 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 						  "scsi:%ld: AEN %04x IDC Complete notification\n",
 						  ha->host_no, mbox_sts[0]));
 
-				if (qla4_83xx_loopback_in_progress(ha))
+				if (qla4_83xx_loopback_in_progress(ha)) {
 					set_bit(AF_LOOPBACK, &ha->flags);
-				else
+				} else {
 					clear_bit(AF_LOOPBACK, &ha->flags);
+					if (ha->saved_acb)
+						set_bit(DPC_RESTORE_ACB,
+							&ha->dpc_flags);
+				}
+				qla4xxx_wake_dpc(ha);
 			}
 			break;
 
@@ -887,6 +898,17 @@ static void qla4xxx_isr_decode_mailbox(struct scsi_qla_host * ha,
 					  ha->host_no, mbox_sts[0]));
 			break;
 
+		case MBOX_ASTS_IDC_TIME_EXTEND_NOTIFICATION:
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+					  "scsi%ld: AEN %04x, mbox_sts[1]=%08x, mbox_sts[2]=%08x, mbox_sts[3]=%08x, mbox_sts[4]=%08x mbox_sts[5]=%08x\n",
+					  ha->host_no, mbox_sts[0], mbox_sts[1],
+					  mbox_sts[2], mbox_sts[3], mbox_sts[4],
+					  mbox_sts[5]));
+			DEBUG2(ql4_printk(KERN_INFO, ha,
+					  "scsi%ld: AEN %04x Received IDC Extend Timeout notification\n",
+					  ha->host_no, mbox_sts[0]));
+			break;
+
 		case MBOX_ASTS_INITIALIZATION_FAILED:
 			DEBUG2(ql4_printk(KERN_INFO, ha,
 					  "scsi%ld: AEN %04x, mbox_sts[3]=%08x\n",
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index e39895c..fa1a06a 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1736,6 +1736,45 @@ int qla4xxx_conn_close_sess_logout(struct scsi_qla_host *ha,
 	return status;
 }
 
+/**
+ * qla4_84xx_extend_idc_tmo - Extend IDC Timeout.
+ * @ha: Pointer to host adapter structure.
+ * @ext_tmo: idc timeout value
+ *
+ * Requests firmware to extend the idc timeout value.
+ **/
+static int qla4_84xx_extend_idc_tmo(struct scsi_qla_host *ha, uint32_t ext_tmo)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	int status;
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+	ext_tmo &= 0xf;
+
+	mbox_cmd[0] = MBOX_CMD_IDC_TIME_EXTEND;
+	mbox_cmd[1] = ((ha->idc_info.request_desc & 0xfffff0ff) |
+		       (ext_tmo << 8));		/* new timeout */
+	mbox_cmd[2] = ha->idc_info.info1;
+	mbox_cmd[3] = ha->idc_info.info2;
+	mbox_cmd[4] = ha->idc_info.info3;
+
+	status = qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, MBOX_REG_COUNT,
+					 mbox_cmd, mbox_sts);
+	if (status != QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+				  "scsi%ld: %s: failed status %04X\n",
+				  ha->host_no, __func__, mbox_sts[0]));
+		return QLA_ERROR;
+	} else {
+		ql4_printk(KERN_INFO, ha, "%s: IDC timeout extended by %d secs\n",
+			   __func__, ext_tmo);
+	}
+
+	return QLA_SUCCESS;
+}
+
 int qla4xxx_disable_acb(struct scsi_qla_host *ha)
 {
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
@@ -1752,6 +1791,23 @@ int qla4xxx_disable_acb(struct scsi_qla_host *ha)
 		DEBUG2(ql4_printk(KERN_WARNING, ha, "%s: MBOX_CMD_DISABLE_ACB "
 				  "failed w/ status %04X %04X %04X", __func__,
 				  mbox_sts[0], mbox_sts[1], mbox_sts[2]));
+	} else {
+		if (is_qla8042(ha) &&
+		    (mbox_sts[0] != MBOX_STS_COMMAND_COMPLETE)) {
+			/*
+			 * Disable ACB mailbox command takes time to complete
+			 * based on the total number of targets connected.
+			 * For 512 targets, it took approximately 5 secs to
+			 * complete. Setting the timeout value to 8, with the 3
+			 * secs buffer.
+			 */
+			qla4_84xx_extend_idc_tmo(ha, IDC_EXTEND_TOV);
+			if (!wait_for_completion_timeout(&ha->disable_acb_comp,
+							 IDC_EXTEND_TOV * HZ)) {
+				ql4_printk(KERN_WARNING, ha, "%s: Disable ACB Completion not received\n",
+					   __func__);
+			}
+		}
 	}
 	return status;
 }
@@ -2158,8 +2214,80 @@ int qla4_83xx_post_idc_ack(struct scsi_qla_host *ha)
 		ql4_printk(KERN_ERR, ha, "%s: failed status %04X\n", __func__,
 			   mbox_sts[0]);
 	else
-	       DEBUG2(ql4_printk(KERN_INFO, ha, "%s: IDC ACK posted\n",
-				 __func__));
+	       ql4_printk(KERN_INFO, ha, "%s: IDC ACK posted\n", __func__);
 
 	return status;
 }
+
+int qla4_84xx_config_acb(struct scsi_qla_host *ha, int acb_config)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	struct addr_ctrl_blk *acb = NULL;
+	uint32_t acb_len = sizeof(struct addr_ctrl_blk);
+	int rval = QLA_SUCCESS;
+	dma_addr_t acb_dma;
+
+	acb = dma_alloc_coherent(&ha->pdev->dev,
+				 sizeof(struct addr_ctrl_blk),
+				 &acb_dma, GFP_KERNEL);
+	if (!acb) {
+		ql4_printk(KERN_ERR, ha, "%s: Unable to alloc acb\n", __func__);
+		rval = QLA_ERROR;
+		goto exit_config_acb;
+	}
+	memset(acb, 0, acb_len);
+
+	switch (acb_config) {
+	case ACB_CONFIG_DISABLE:
+		rval = qla4xxx_get_acb(ha, acb_dma, 0, acb_len);
+		if (rval != QLA_SUCCESS)
+			goto exit_free_acb;
+
+		rval = qla4xxx_disable_acb(ha);
+		if (rval != QLA_SUCCESS)
+			goto exit_free_acb;
+
+		if (!ha->saved_acb)
+			ha->saved_acb = kzalloc(acb_len, GFP_KERNEL);
+
+		if (!ha->saved_acb) {
+			ql4_printk(KERN_ERR, ha, "%s: Unable to alloc acb\n",
+				   __func__);
+			rval = QLA_ERROR;
+			goto exit_config_acb;
+		}
+		memcpy(ha->saved_acb, acb, acb_len);
+		break;
+	case ACB_CONFIG_SET:
+
+		if (!ha->saved_acb) {
+			ql4_printk(KERN_ERR, ha, "%s: Can't set ACB, Saved ACB not available\n",
+				   __func__);
+			rval = QLA_ERROR;
+			goto exit_free_acb;
+		}
+
+		memcpy(acb, ha->saved_acb, acb_len);
+		kfree(ha->saved_acb);
+		ha->saved_acb = NULL;
+
+		rval = qla4xxx_set_acb(ha, &mbox_cmd[0], &mbox_sts[0], acb_dma);
+		if (rval != QLA_SUCCESS)
+			goto exit_free_acb;
+
+		break;
+	default:
+		ql4_printk(KERN_ERR, ha, "%s: Invalid ACB Configuration\n",
+			   __func__);
+	}
+
+exit_free_acb:
+	dma_free_coherent(&ha->pdev->dev, sizeof(struct addr_ctrl_blk), acb,
+			  acb_dma);
+exit_config_acb:
+	DEBUG2(ql4_printk(KERN_INFO, ha,
+			  "%s %s\n", __func__,
+			  rval == QLA_SUCCESS ? "SUCCEEDED" : "FAILED"));
+	return rval;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 4f9651a..6956de9d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2671,6 +2671,8 @@ static int qla4xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	    !test_bit(AF_ONLINE, &ha->flags) ||
 	    !test_bit(AF_LINK_UP, &ha->flags) ||
 	    test_bit(AF_LOOPBACK, &ha->flags) ||
+	    test_bit(DPC_POST_IDC_ACK, &ha->dpc_flags) ||
+	    test_bit(DPC_RESTORE_ACB, &ha->dpc_flags) ||
 	    test_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags))
 		goto qc_host_busy;
 
@@ -3863,8 +3865,35 @@ static void qla4xxx_do_dpc(struct work_struct *work)
 			qla4_8xxx_device_state_handler(ha);
 		}
 
-		if (test_and_clear_bit(DPC_POST_IDC_ACK, &ha->dpc_flags))
+		if (test_bit(DPC_POST_IDC_ACK, &ha->dpc_flags)) {
+			if (is_qla8042(ha)) {
+				if (ha->idc_info.info2 &
+				    ENABLE_INTERNAL_LOOPBACK) {
+					ql4_printk(KERN_INFO, ha, "%s: Disabling ACB\n",
+						   __func__);
+					status = qla4_84xx_config_acb(ha,
+							    ACB_CONFIG_DISABLE);
+					if (status != QLA_SUCCESS) {
+						ql4_printk(KERN_INFO, ha, "%s: ACB config failed\n",
+							   __func__);
+					}
+				}
+			}
 			qla4_83xx_post_idc_ack(ha);
+			clear_bit(DPC_POST_IDC_ACK, &ha->dpc_flags);
+		}
+
+		if (is_qla8042(ha) &&
+		    test_bit(DPC_RESTORE_ACB, &ha->dpc_flags)) {
+			ql4_printk(KERN_INFO, ha, "%s: Restoring ACB\n",
+				   __func__);
+			if (qla4_84xx_config_acb(ha, ACB_CONFIG_SET) !=
+			    QLA_SUCCESS) {
+				ql4_printk(KERN_INFO, ha, "%s: ACB config failed ",
+					   __func__);
+			}
+			clear_bit(DPC_RESTORE_ACB, &ha->dpc_flags);
+		}
 
 		if (test_and_clear_bit(DPC_HA_NEED_QUIESCENT, &ha->dpc_flags)) {
 			qla4_8xxx_need_qsnt_handler(ha);
-- 
1.8.2.GIT

