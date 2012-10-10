From: vikas.chaudhary@qlogic.com
Subject: [PATCH 6/7] qla4xxx: Add get DDB support using BSG.
Date: Wed, 10 Oct 2012 07:24:45 -0400
Message-ID: <1349868286-13650-7-git-send-email-vikas.chaudhary@qlogic.com>
References: <1349868286-13650-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:63090 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751718Ab2JJLnK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2012 07:43:10 -0400
In-Reply-To: <1349868286-13650-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_bsg.c  |   84 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_bsg.h  |    1 +
 drivers/scsi/qla4xxx/ql4_glbl.h |    4 ++
 drivers/scsi/qla4xxx/ql4_mbx.c  |   40 ++++++++++++++++++
 4 files changed, 129 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_bsg.c b/drivers/scsi/qla4xxx/ql4_bsg.c
index 6fa8033..f72f11d 100644
--- a/drivers/scsi/qla4xxx/ql4_bsg.c
+++ b/drivers/scsi/qla4xxx/ql4_bsg.c
@@ -694,6 +694,87 @@ leave:
 	return rval;
 }
 
+static int qla4xxx_bsg_get_ddb(struct bsg_job *bsg_job)
+{
+	struct Scsi_Host *host = iscsi_job_to_shost(bsg_job);
+	struct scsi_qla_host *ha = to_qla_host(host);
+	struct iscsi_bsg_request *bsg_req = bsg_job->request;
+	struct iscsi_bsg_reply *bsg_reply = bsg_job->reply;
+	dma_addr_t fw_ddb_entry_dma;
+	struct dev_db_entry *fw_ddb_entry = NULL;
+	uint32_t ddb_index;
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	uint8_t *fw_sts_ptr;
+	int max_ddbs, rval = -EINVAL, ret;
+
+	bsg_reply->reply_payload_rcv_len = 0;
+	ddb_index = bsg_req->rqst_data.h_vendor.vendor_cmd[1];
+
+	if (unlikely(pci_channel_offline(ha->pdev)))
+		goto leave;
+
+	if (ql4xxx_reset_active(ha)) {
+		ql4_printk(KERN_ERR, ha, "%s: reset active\n", __func__);
+		rval = -EBUSY;
+		goto leave;
+	}
+
+	if (bsg_job->reply_payload.payload_len < sizeof(*fw_ddb_entry)) {
+		ql4_printk(KERN_ERR, ha, "%s: invalid payload len %d\n",
+			   __func__, bsg_job->reply_payload.payload_len);
+		rval = -EINVAL;
+		goto leave;
+	}
+
+	max_ddbs =  is_qla40XX(ha) ? MAX_DEV_DB_ENTRIES_40XX :
+				     MAX_DEV_DB_ENTRIES;
+	if (ddb_index > max_ddbs)
+		goto leave;
+
+	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+					  &fw_ddb_entry_dma, GFP_KERNEL);
+	if (!fw_ddb_entry) {
+		ql4_printk(KERN_ERR, ha,
+			   "%s: Unable to allocate dma buffer\n", __func__);
+		goto leave;
+	}
+
+	ret = qla4xxx_get_fwddb_mbx_sts(ha, ddb_index, fw_ddb_entry,
+					fw_ddb_entry_dma, mbox_sts);
+	if (ret == QLA_ERROR) {
+		ql4_printk(KERN_ERR, ha, "%s: Vendor request failed.\n",
+			   __func__);
+
+		fw_sts_ptr = ((uint8_t *)bsg_job->req->sense +
+					       sizeof(struct iscsi_bsg_reply));
+		memcpy(fw_sts_ptr, mbox_sts, sizeof(uint32_t) * MBOX_REG_COUNT);
+		bsg_reply->reply_payload_rcv_len = 0;
+		bsg_reply->result = DID_ERROR << 16;
+		rval = -EIO;
+	} else {
+		fw_sts_ptr = ((uint8_t *)bsg_job->req->sense) +
+					       sizeof(struct iscsi_bsg_reply);
+		memcpy(fw_sts_ptr, mbox_sts, sizeof(mbox_sts));
+		bsg_job->reply_len = sizeof(struct iscsi_bsg_reply) +
+					   sizeof(mbox_sts);
+		bsg_reply->reply_payload_rcv_len =
+		       sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+					  bsg_job->reply_payload.sg_cnt,
+					  fw_ddb_entry, sizeof(*fw_ddb_entry));
+		bsg_reply->result = DID_OK << 16;
+		rval = 0;
+	}
+
+	bsg_job_done(bsg_job, bsg_reply->result,
+		     bsg_reply->reply_payload_rcv_len);
+
+leave:
+	if (fw_ddb_entry)
+		dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+				  fw_ddb_entry, fw_ddb_entry_dma);
+	return rval;
+}
+
 /**
  * qla4xxx_process_vendor_specific - handle vendor specific bsg request
  * @job: iscsi_bsg_job to handle
@@ -739,6 +820,9 @@ int qla4xxx_process_vendor_specific(struct bsg_job *bsg_job)
 	case QLISCSI_VND_GET_DEFAULT_DDB:
 		return qla4xxx_bsg_get_default_ddb(bsg_job);
 
+	case QLISCSI_VND_GET_DDB:
+		return qla4xxx_bsg_get_ddb(bsg_job);
+
 	default:
 		ql4_printk(KERN_ERR, ha, "%s: invalid BSG vendor command: "
 			   "0x%x\n", __func__, bsg_req->msgcode);
diff --git a/drivers/scsi/qla4xxx/ql4_bsg.h b/drivers/scsi/qla4xxx/ql4_bsg.h
index 5c4d80c..ec92550 100644
--- a/drivers/scsi/qla4xxx/ql4_bsg.h
+++ b/drivers/scsi/qla4xxx/ql4_bsg.h
@@ -19,5 +19,6 @@
 #define QLISCSI_VND_SET_ACB		9
 #define QLISCSI_VND_DISABLE_ACB		10
 #define QLISCSI_VND_GET_DEFAULT_DDB	11
+#define QLISCSI_VND_GET_DDB		12
 
 #endif
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 98cc1fc..3825708 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -261,6 +261,10 @@ int qla4_83xx_post_idc_ack(struct scsi_qla_host *ha);
 void qla4_83xx_disable_pause(struct scsi_qla_host *ha);
 int qla4xxx_get_default_ddb_mbx_sts(struct scsi_qla_host *ha, uint32_t options,
 				    dma_addr_t dma_addr, uint32_t *mbx_sts_reg);
+int qla4xxx_get_fwddb_mbx_sts(struct scsi_qla_host *ha, uint16_t fw_ddb_index,
+			      struct dev_db_entry *fw_ddb_entry,
+			      dma_addr_t fw_ddb_entry_dma,
+			      uint32_t *mbox_sts_reg);
 
 extern int ql4xextended_error_logging;
 extern int ql4xdontresethba;
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 944301c..548e41d 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -2037,3 +2037,43 @@ int qla4_83xx_post_idc_ack(struct scsi_qla_host *ha)
 
 	return status;
 }
+
+int qla4xxx_get_fwddb_mbx_sts(struct scsi_qla_host *ha,
+			      uint16_t fw_ddb_index,
+			      struct dev_db_entry *fw_ddb_entry,
+			      dma_addr_t fw_ddb_entry_dma,
+			      uint32_t *mbox_sts_reg)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	int status = QLA_ERROR;
+
+	/* Make sure the device index is valid */
+	if (fw_ddb_index >= MAX_DDB_ENTRIES) {
+		ql4_printk(KERN_ERR, ha, "%s: ddb [%d] out of range.\n",
+			   __func__, fw_ddb_index);
+		goto exit_get_fwddb;
+	}
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_GET_DATABASE_ENTRY;
+	mbox_cmd[1] = (uint32_t) fw_ddb_index;
+	mbox_cmd[2] = LSDW(fw_ddb_entry_dma);
+	mbox_cmd[3] = MSDW(fw_ddb_entry_dma);
+	mbox_cmd[4] = sizeof(struct dev_db_entry);
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, MBOX_REG_COUNT,
+				    &mbox_cmd[0], &mbox_sts[0]) == QLA_ERROR) {
+		ql4_printk(KERN_ERR, ha, "MBOX_CMD_GET_DATABASE_ENTRY failed with status 0x%04X\n",
+			   mbox_sts[0]);
+		goto exit_get_fwddb;
+	}
+
+	memcpy(mbox_sts_reg, mbox_sts, sizeof(uint32_t) * MBOX_REG_COUNT);
+	status = QLA_SUCCESS;
+
+exit_get_fwddb:
+	return status;
+}
-- 
1.7.8.GIT

