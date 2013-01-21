From: vikas.chaudhary@qlogic.com
Subject: [PATCH 05/10] qla4xxx: Throttle active IOCBs to firmware limits
Date: Sun, 20 Jan 2013 23:51:00 -0500
Message-ID: <1358743865-435-6-git-send-email-vikas.chaudhary@qlogic.com>
References: <1358743865-435-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:43430 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750885Ab3AUFLj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jan 2013 00:11:39 -0500
In-Reply-To: <1358743865-435-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Karen Higgins <karen.higgins@qlogic.com>

From: Karen Higgins <karen.higgins@qlogic.com>

Problem:
QLA4xxx firmware may assert if given more IOCBs than it can handle.

Solution:
The driver was updated to throttle the number of active IOCBs based
on the total number of IOCB buffers received from get_firmware_status
mbx_sts[2].

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |    2 ++
 drivers/scsi/qla4xxx/ql4_iocb.c |    2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c  |   20 ++++++++++++++++++--
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 8f41937..ad58062 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -136,6 +136,7 @@
 #define RESPONSE_QUEUE_DEPTH		64
 #define QUEUE_SIZE			64
 #define DMA_BUFFER_SIZE			512
+#define IOCB_HIWAT_CUSHION		4
 
 /*
  * Misc
@@ -540,6 +541,7 @@ struct scsi_qla_host {
 	uint32_t tot_ddbs;
 
 	uint16_t iocb_cnt;
+	uint16_t iocb_hiwat;
 
 	/* SRB cache. */
 #define SRB_MIN_REQ	128
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index f48f37a..14fec97 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -316,7 +316,7 @@ int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb)
 		goto queuing_error;
 
 	/* total iocbs active */
-	if ((ha->iocb_cnt + req_cnt) >= REQUEST_QUEUE_DEPTH)
+	if ((ha->iocb_cnt + req_cnt) >= ha->iocb_hiwat)
 		goto queuing_error;
 
 	/* Build command packet */
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 1c57c22..81e738d 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -697,8 +697,24 @@ int qla4xxx_get_firmware_status(struct scsi_qla_host * ha)
 		return QLA_ERROR;
 	}
 
-	ql4_printk(KERN_INFO, ha, "%ld firmware IOCBs available (%d).\n",
-	    ha->host_no, mbox_sts[2]);
+	/* High-water mark of IOCBs */
+	ha->iocb_hiwat = mbox_sts[2];
+	DEBUG2(ql4_printk(KERN_INFO, ha,
+			  "%s: firmware IOCBs available = %d\n", __func__,
+			  ha->iocb_hiwat));
+
+	if (ha->iocb_hiwat > IOCB_HIWAT_CUSHION)
+		ha->iocb_hiwat -= IOCB_HIWAT_CUSHION;
+
+	/* Ideally, we should not enter this code, as the # of firmware
+	 * IOCBs is hard-coded in the firmware. We set a default
+	 * iocb_hiwat here just in case */
+	if (ha->iocb_hiwat == 0) {
+		ha->iocb_hiwat = REQUEST_QUEUE_DEPTH / 4;
+		DEBUG2(ql4_printk(KERN_WARNING, ha,
+				  "%s: Setting IOCB's to = %d\n", __func__,
+				  ha->iocb_hiwat));
+	}
 
 	return QLA_SUCCESS;
 }
-- 
1.7.8.GIT

