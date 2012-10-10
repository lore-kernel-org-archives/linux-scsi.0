From: vikas.chaudhary@qlogic.com
Subject: [PATCH 5/7] qla4xxx: Add get default DDB support using BSG.
Date: Wed, 10 Oct 2012 07:24:44 -0400
Message-ID: <1349868286-13650-6-git-send-email-vikas.chaudhary@qlogic.com>
References: <1349868286-13650-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:18862 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752099Ab2JJLnK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
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
 drivers/scsi/qla4xxx/ql4_bsg.c  |   79 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_bsg.h  |    1 +
 drivers/scsi/qla4xxx/ql4_glbl.h |    2 +
 drivers/scsi/qla4xxx/ql4_mbx.c  |   26 +++++++++++++
 4 files changed, 108 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_bsg.c b/drivers/scsi/qla4xxx/ql4_bsg.c
index f00b649..6fa8033 100644
--- a/drivers/scsi/qla4xxx/ql4_bsg.c
+++ b/drivers/scsi/qla4xxx/ql4_bsg.c
@@ -618,6 +618,82 @@ leave:
 	return rval;
 }
 
+static int qla4xxx_bsg_get_default_ddb(struct bsg_job *bsg_job)
+{
+	struct Scsi_Host *host = iscsi_job_to_shost(bsg_job);
+	struct scsi_qla_host *ha = to_qla_host(host);
+	struct iscsi_bsg_request *bsg_req = bsg_job->request;
+	struct iscsi_bsg_reply *bsg_reply = bsg_job->reply;
+	dma_addr_t fw_ddb_entry_dma;
+	struct dev_db_entry *fw_ddb_entry = NULL;
+	uint32_t options = 0, mbx_sts[MBOX_REG_COUNT];
+	uint8_t *fw_sts_ptr;
+	int rval = -EINVAL, ret;
+
+	bsg_reply->reply_payload_rcv_len = 0;
+	options = bsg_req->rqst_data.h_vendor.vendor_cmd[1];
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
+	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
+					  &fw_ddb_entry_dma, GFP_KERNEL);
+	if (!fw_ddb_entry) {
+		ql4_printk(KERN_ERR, ha,
+			   "%s: Unable to allocate dma buffer\n", __func__);
+		goto leave;
+	}
+
+	ret = qla4xxx_get_default_ddb_mbx_sts(ha, options, fw_ddb_entry_dma,
+					       mbx_sts);
+	if (ret == QLA_ERROR) {
+		ql4_printk(KERN_ERR, ha, "%s: Vendor request failed.\n",
+			   __func__);
+
+		fw_sts_ptr = ((uint8_t *)bsg_job->req->sense +
+					 sizeof(struct iscsi_bsg_reply));
+		memcpy(fw_sts_ptr, mbx_sts, sizeof(uint32_t));
+		bsg_reply->reply_payload_rcv_len = 0;
+		bsg_reply->result = DID_ERROR << 16;
+		rval = -EIO;
+	} else {
+		fw_sts_ptr = ((uint8_t *)bsg_job->req->sense) +
+					 sizeof(struct iscsi_bsg_reply);
+		memcpy(fw_sts_ptr, mbx_sts, sizeof(uint32_t));
+		bsg_job->reply_len = sizeof(struct iscsi_bsg_reply) +
+				     sizeof(uint32_t);
+		bsg_reply->reply_payload_rcv_len =
+		 sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+				    bsg_job->reply_payload.sg_cnt,
+				    fw_ddb_entry, sizeof(*fw_ddb_entry));
+		bsg_reply->result = DID_OK << 16;
+		rval = 0;
+	}
+
+	bsg_job_done(bsg_job, bsg_reply->result,
+		     bsg_reply->reply_payload_rcv_len);
+	rval = 0;
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
@@ -660,6 +736,9 @@ int qla4xxx_process_vendor_specific(struct bsg_job *bsg_job)
 	case QLISCSI_VND_DISABLE_ACB:
 		return qla4xxx_bsg_disable_acb(bsg_job);
 
+	case QLISCSI_VND_GET_DEFAULT_DDB:
+		return qla4xxx_bsg_get_default_ddb(bsg_job);
+
 	default:
 		ql4_printk(KERN_ERR, ha, "%s: invalid BSG vendor command: "
 			   "0x%x\n", __func__, bsg_req->msgcode);
diff --git a/drivers/scsi/qla4xxx/ql4_bsg.h b/drivers/scsi/qla4xxx/ql4_bsg.h
index 2fd5860..5c4d80c 100644
--- a/drivers/scsi/qla4xxx/ql4_bsg.h
+++ b/drivers/scsi/qla4xxx/ql4_bsg.h
@@ -18,5 +18,6 @@
 #define QLISCSI_VND_ABOUT_FIRMWARE	8
 #define QLISCSI_VND_SET_ACB		9
 #define QLISCSI_VND_DISABLE_ACB		10
+#define QLISCSI_VND_GET_DEFAULT_DDB	11
 
 #endif
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 2049c3a..98cc1fc 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -259,6 +259,8 @@ int qla4_8xxx_set_param(struct scsi_qla_host *ha, int param);
 int qla4_8xxx_update_idc_reg(struct scsi_qla_host *ha);
 int qla4_83xx_post_idc_ack(struct scsi_qla_host *ha);
 void qla4_83xx_disable_pause(struct scsi_qla_host *ha);
+int qla4xxx_get_default_ddb_mbx_sts(struct scsi_qla_host *ha, uint32_t options,
+				    dma_addr_t dma_addr, uint32_t *mbx_sts_reg);
 
 extern int ql4xextended_error_logging;
 extern int ql4xdontresethba;
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 0b4152d..944301c 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1275,6 +1275,32 @@ static int qla4xxx_get_default_ddb(struct scsi_qla_host *ha, uint32_t options,
 	return QLA_SUCCESS;
 }
 
+int qla4xxx_get_default_ddb_mbx_sts(struct scsi_qla_host *ha, uint32_t options,
+				    dma_addr_t dma_addr, uint32_t *mbx_sts_reg)
+{
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+	int status;
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	mbox_cmd[0] = MBOX_CMD_GET_DATABASE_ENTRY_DEFAULTS;
+	mbox_cmd[1] = options;
+	mbox_cmd[2] = LSDW(dma_addr);
+	mbox_cmd[3] = MSDW(dma_addr);
+
+	status = qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, MBOX_REG_COUNT,
+					 &mbox_cmd[0], &mbox_sts[0]);
+	if (status != QLA_SUCCESS) {
+		DEBUG2(ql4_printk(KERN_ERR, ha, "%s: failed status %04X\n",
+				  __func__, mbox_sts[0]));
+	}
+
+	memcpy(mbx_sts_reg, mbox_sts, sizeof(uint32_t) * MBOX_REG_COUNT);
+	return status;
+}
+
 int qla4xxx_req_ddb_entry(struct scsi_qla_host *ha, uint32_t ddb_index,
 			  uint32_t *mbx_sts)
 {
-- 
1.7.8.GIT

