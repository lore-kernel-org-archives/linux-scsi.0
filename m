From: vikas.chaudhary@qlogic.com
Subject: [PATCH 2/7] qla4xxx: Added new BSG command QLISCSI_VND_ABOUT_FIRMWARE
Date: Wed, 10 Oct 2012 07:24:41 -0400
Message-ID: <1349868286-13650-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1349868286-13650-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:36660 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753320Ab2JJLnJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2012 07:43:09 -0400
In-Reply-To: <1349868286-13650-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_bsg.c  |   62 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_bsg.h  |    1 +
 drivers/scsi/qla4xxx/ql4_glbl.h |    2 +-
 drivers/scsi/qla4xxx/ql4_init.c |    2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c  |    8 ++++-
 5 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_bsg.c b/drivers/scsi/qla4xxx/ql4_bsg.c
index 8acdc58..e2c58aa 100644
--- a/drivers/scsi/qla4xxx/ql4_bsg.c
+++ b/drivers/scsi/qla4xxx/ql4_bsg.c
@@ -446,6 +446,65 @@ leave:
 	return rval;
 }
 
+static int qla4xxx_bsg_about_firmware(struct bsg_job *bsg_job)
+{
+	struct Scsi_Host *host = iscsi_job_to_shost(bsg_job);
+	struct scsi_qla_host *ha = to_qla_host(host);
+	struct iscsi_bsg_reply *bsg_reply = bsg_job->reply;
+	uint8_t  *about_fw = NULL;
+	uint32_t len = 0;
+	int rval = -EINVAL;
+
+	bsg_reply->reply_payload_rcv_len = 0;
+
+	if (unlikely(pci_channel_offline(ha->pdev)))
+		goto exit_about_firmware;
+
+	if (ql4xxx_reset_active(ha)) {
+		ql4_printk(KERN_ERR, ha, "%s: reset active\n", __func__);
+		rval = -EBUSY;
+		goto exit_about_firmware;
+	}
+
+	len = bsg_job->reply_payload.payload_len;
+	if (len < sizeof(struct about_fw_info) + (sizeof(uint32_t) << 3)) {
+		ql4_printk(KERN_ERR, ha, "%s: invalid fw detail len %d\n",
+			   __func__, len);
+		rval = -EINVAL;
+		goto exit_about_firmware;
+	}
+
+	about_fw = kmalloc(len, GFP_KERNEL);
+	if (!about_fw) {
+		ql4_printk(KERN_ERR, ha, "%s: Unable to allocate memory for about_fw\n",
+			   __func__);
+		rval = -ENOMEM;
+		goto exit_about_firmware;
+	}
+
+	memset(about_fw, 0, len);
+	rval = qla4xxx_about_firmware(ha, about_fw);
+	if (rval) {
+		ql4_printk(KERN_ERR, ha, "%s: about firmware failed\n",
+			   __func__);
+		bsg_reply->result = DID_ERROR << 16;
+		rval = -EIO;
+	} else {
+		bsg_reply->reply_payload_rcv_len =
+			sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+					    bsg_job->reply_payload.sg_cnt,
+					    about_fw, len);
+		bsg_reply->result = DID_OK << 16;
+	}
+
+	bsg_job_done(bsg_job, bsg_reply->result,
+		     bsg_reply->reply_payload_rcv_len);
+
+	kfree(about_fw);
+exit_about_firmware:
+	return rval;
+}
+
 /**
  * qla4xxx_process_vendor_specific - handle vendor specific bsg request
  * @job: iscsi_bsg_job to handle
@@ -479,6 +538,9 @@ int qla4xxx_process_vendor_specific(struct bsg_job *bsg_job)
 	case QLISCSI_VND_GET_ACB:
 		return qla4xxx_bsg_get_acb(bsg_job);
 
+	case QLISCSI_VND_ABOUT_FIRMWARE:
+		return qla4xxx_bsg_about_firmware(bsg_job);
+
 	default:
 		ql4_printk(KERN_ERR, ha, "%s: invalid BSG vendor command: "
 			   "0x%x\n", __func__, bsg_req->msgcode);
diff --git a/drivers/scsi/qla4xxx/ql4_bsg.h b/drivers/scsi/qla4xxx/ql4_bsg.h
index c6a03645..c530213 100644
--- a/drivers/scsi/qla4xxx/ql4_bsg.h
+++ b/drivers/scsi/qla4xxx/ql4_bsg.h
@@ -15,5 +15,6 @@
 #define QLISCSI_VND_UPDATE_NVRAM	5
 #define QLISCSI_VND_RESTORE_DEFAULTS	6
 #define QLISCSI_VND_GET_ACB		7
+#define QLISCSI_VND_ABOUT_FIRMWARE	8
 
 #endif
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 57a5a3c..2049c3a 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -65,7 +65,7 @@ u16 rd_nvram_word(struct scsi_qla_host *ha, int offset);
 u8 rd_nvram_byte(struct scsi_qla_host *ha, int offset);
 void qla4xxx_get_crash_record(struct scsi_qla_host *ha);
 int qla4xxx_is_nvram_configuration_valid(struct scsi_qla_host *ha);
-int qla4xxx_about_firmware(struct scsi_qla_host *ha);
+int qla4xxx_about_firmware(struct scsi_qla_host *ha, uint8_t *fw_info);
 void qla4xxx_interrupt_service_routine(struct scsi_qla_host *ha,
 				       uint32_t intr_status);
 int qla4xxx_init_rings(struct scsi_qla_host *ha);
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 1aca1b4..7a09145 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -935,7 +935,7 @@ int qla4xxx_initialize_adapter(struct scsi_qla_host *ha, int is_reset)
 	if (ha->isp_ops->start_firmware(ha) == QLA_ERROR)
 		goto exit_init_hba;
 
-	if (qla4xxx_about_firmware(ha) == QLA_ERROR)
+	if (qla4xxx_about_firmware(ha, NULL) == QLA_ERROR)
 		goto exit_init_hba;
 
 	if (ha->isp_ops->get_sys_info(ha) == QLA_ERROR)
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 3d41034..0b4152d 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1192,7 +1192,7 @@ int qla4xxx_get_flash(struct scsi_qla_host * ha, dma_addr_t dma_addr,
  * Mailboxes 2 & 3 may hold an address for data. Make sure that we write 0 to
  * those mailboxes, if unused.
  **/
-int qla4xxx_about_firmware(struct scsi_qla_host *ha)
+int qla4xxx_about_firmware(struct scsi_qla_host *ha, uint8_t *fw_info)
 {
 	struct about_fw_info *about_fw = NULL;
 	dma_addr_t about_fw_dma;
@@ -1240,6 +1240,12 @@ int qla4xxx_about_firmware(struct scsi_qla_host *ha)
 	ha->bootload_build = le16_to_cpu(about_fw->bootload_build);
 	status = QLA_SUCCESS;
 
+	if (fw_info) {
+		memcpy(fw_info, about_fw, sizeof(struct about_fw_info));
+		memcpy(fw_info + sizeof(struct about_fw_info), &mbox_sts[0],
+		       sizeof(mbox_sts));
+	}
+
 exit_about_fw:
 	dma_free_coherent(&ha->pdev->dev, sizeof(struct about_fw_info),
 			  about_fw, about_fw_dma);
-- 
1.7.8.GIT

