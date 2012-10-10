From: vikas.chaudhary@qlogic.com
Subject: [PATCH 3/7] qla4xxx: Invoke Set Address Control Block using BSG
Date: Wed, 10 Oct 2012 07:24:42 -0400
Message-ID: <1349868286-13650-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1349868286-13650-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:40665 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753366Ab2JJLnJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2012 07:43:09 -0400
In-Reply-To: <1349868286-13650-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_bsg.c |   77 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_bsg.h |    1 +
 2 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_bsg.c b/drivers/scsi/qla4xxx/ql4_bsg.c
index e2c58aa..fbe077a 100644
--- a/drivers/scsi/qla4xxx/ql4_bsg.c
+++ b/drivers/scsi/qla4xxx/ql4_bsg.c
@@ -505,6 +505,80 @@ exit_about_firmware:
 	return rval;
 }
 
+static int qla4xxx_bsg_set_acb(struct bsg_job *bsg_job)
+{
+	struct Scsi_Host *host = iscsi_job_to_shost(bsg_job);
+	struct scsi_qla_host *ha = to_qla_host(host);
+	struct iscsi_bsg_request *bsg_req = bsg_job->request;
+	struct iscsi_bsg_reply *bsg_reply = bsg_job->reply;
+	uint32_t acb_type = 0;
+	uint32_t len = 0;
+	dma_addr_t acb_dma;
+	struct addr_ctrl_blk *acb = NULL;
+	int rval = -EINVAL;
+	uint32_t mbox_cmd[MBOX_REG_COUNT];
+	uint32_t mbox_sts[MBOX_REG_COUNT];
+
+	bsg_reply->reply_payload_rcv_len = 0;
+
+	if (unlikely(pci_channel_offline(ha->pdev)))
+		goto leave;
+
+	/* Only 4022 and above adapters are supported */
+	if (is_qla4010(ha))
+		goto leave;
+
+	if (ql4xxx_reset_active(ha)) {
+		ql4_printk(KERN_ERR, ha, "%s: reset active\n", __func__);
+		rval = -EBUSY;
+		goto leave;
+	}
+
+	acb_type = bsg_req->rqst_data.h_vendor.vendor_cmd[1];
+	len = bsg_job->request_payload.payload_len;
+	if (len < sizeof(struct addr_ctrl_blk)) {
+		ql4_printk(KERN_ERR, ha, "%s: invalid acb len %d\n",
+			   __func__, len);
+		rval = -EINVAL;
+		goto leave;
+	}
+
+	acb = dma_alloc_coherent(&ha->pdev->dev, len, &acb_dma, GFP_KERNEL);
+	if (!acb) {
+		ql4_printk(KERN_ERR, ha, "%s: dma alloc failed for acb data\n",
+			   __func__);
+		rval = -ENOMEM;
+		goto leave;
+	}
+
+	memset(acb, 0, len);
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+			  bsg_job->request_payload.sg_cnt, acb, len);
+
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
+	/* TODO: Current set ACB implementation lacks acb_type */
+	rval = qla4xxx_set_acb(ha, &mbox_cmd[0], &mbox_sts[0], acb_dma);
+	if (rval) {
+		ql4_printk(KERN_ERR, ha, "%s: set acb failed\n", __func__);
+		bsg_reply->result = DID_ERROR << 16;
+		rval = -EIO;
+	} else {
+		bsg_reply->result = DID_OK << 16;
+		/* Update local copy */
+		memset(acb, 0, len);
+		qla4xxx_update_local_ifcb(ha, &mbox_cmd[0], &mbox_sts[0], acb,
+					  acb_dma);
+	}
+
+	bsg_job_done(bsg_job, bsg_reply->result,
+		     bsg_reply->reply_payload_rcv_len);
+	dma_free_coherent(&ha->pdev->dev, len, acb, acb_dma);
+leave:
+	return rval;
+}
+
 /**
  * qla4xxx_process_vendor_specific - handle vendor specific bsg request
  * @job: iscsi_bsg_job to handle
@@ -541,6 +615,9 @@ int qla4xxx_process_vendor_specific(struct bsg_job *bsg_job)
 	case QLISCSI_VND_ABOUT_FIRMWARE:
 		return qla4xxx_bsg_about_firmware(bsg_job);
 
+	case QLISCSI_VND_SET_ACB:
+		return qla4xxx_bsg_set_acb(bsg_job);
+
 	default:
 		ql4_printk(KERN_ERR, ha, "%s: invalid BSG vendor command: "
 			   "0x%x\n", __func__, bsg_req->msgcode);
diff --git a/drivers/scsi/qla4xxx/ql4_bsg.h b/drivers/scsi/qla4xxx/ql4_bsg.h
index c530213..36d4979 100644
--- a/drivers/scsi/qla4xxx/ql4_bsg.h
+++ b/drivers/scsi/qla4xxx/ql4_bsg.h
@@ -16,5 +16,6 @@
 #define QLISCSI_VND_RESTORE_DEFAULTS	6
 #define QLISCSI_VND_GET_ACB		7
 #define QLISCSI_VND_ABOUT_FIRMWARE	8
+#define QLISCSI_VND_SET_ACB		9
 
 #endif
-- 
1.7.8.GIT

