From: vikas.chaudhary@qlogic.com
Subject: [PATCH 4/7] qla4xxx: Invoke DisableACB using BSG
Date: Wed, 10 Oct 2012 07:24:43 -0400
Message-ID: <1349868286-13650-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1349868286-13650-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:6878 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753344Ab2JJLnJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
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
 drivers/scsi/qla4xxx/ql4_bsg.c |   42 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_bsg.h |    1 +
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_bsg.c b/drivers/scsi/qla4xxx/ql4_bsg.c
index fbe077a..f00b649 100644
--- a/drivers/scsi/qla4xxx/ql4_bsg.c
+++ b/drivers/scsi/qla4xxx/ql4_bsg.c
@@ -579,6 +579,45 @@ leave:
 	return rval;
 }
 
+static int qla4xxx_bsg_disable_acb(struct bsg_job *bsg_job)
+{
+	struct Scsi_Host *host = iscsi_job_to_shost(bsg_job);
+	struct scsi_qla_host *ha = to_qla_host(host);
+	struct iscsi_bsg_reply *bsg_reply = bsg_job->reply;
+	int rval = -EINVAL;
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
+	rval = qla4xxx_disable_acb(ha);
+	if (rval) {
+		ql4_printk(KERN_ERR, ha, "%s: disable acb failed\n", __func__);
+		bsg_reply->result = DID_ERROR << 16;
+		rval = -EIO;
+	} else {
+		bsg_reply->result = DID_OK << 16;
+		wait_for_completion_timeout(&ha->disable_acb_comp,
+					    DISABLE_ACB_TOV * HZ);
+	}
+
+	bsg_job_done(bsg_job, bsg_reply->result,
+		     bsg_reply->reply_payload_rcv_len);
+leave:
+	return rval;
+}
+
 /**
  * qla4xxx_process_vendor_specific - handle vendor specific bsg request
  * @job: iscsi_bsg_job to handle
@@ -618,6 +657,9 @@ int qla4xxx_process_vendor_specific(struct bsg_job *bsg_job)
 	case QLISCSI_VND_SET_ACB:
 		return qla4xxx_bsg_set_acb(bsg_job);
 
+	case QLISCSI_VND_DISABLE_ACB:
+		return qla4xxx_bsg_disable_acb(bsg_job);
+
 	default:
 		ql4_printk(KERN_ERR, ha, "%s: invalid BSG vendor command: "
 			   "0x%x\n", __func__, bsg_req->msgcode);
diff --git a/drivers/scsi/qla4xxx/ql4_bsg.h b/drivers/scsi/qla4xxx/ql4_bsg.h
index 36d4979..2fd5860 100644
--- a/drivers/scsi/qla4xxx/ql4_bsg.h
+++ b/drivers/scsi/qla4xxx/ql4_bsg.h
@@ -17,5 +17,6 @@
 #define QLISCSI_VND_GET_ACB		7
 #define QLISCSI_VND_ABOUT_FIRMWARE	8
 #define QLISCSI_VND_SET_ACB		9
+#define QLISCSI_VND_DISABLE_ACB		10
 
 #endif
-- 
1.7.8.GIT

