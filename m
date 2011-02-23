From: madhu.iyengar@qlogic.com
Subject: [PATCH 09/13] qla2xxx: Adjust FCP_RSP response-info field check after TMF completion.
Date: Wed, 23 Feb 2011 15:27:14 -0800
Message-ID: <1298503638-22396-10-git-send-email-madhu.iyengar@qlogic.com>
References: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52635 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755200Ab1BWXab (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2011 18:30:31 -0500
In-Reply-To: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Based on reading of the FCP2/4 specification, the driver cannot
expect the storage device to send FCP_RSP information. Instead,
the driver should interpret the data which is present in the frame
to base decisions on the success or failure of the system.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |   29 +++++++++++++----------------
 1 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b4a82b5..7a7c0ec 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2462,22 +2462,19 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 		    "-- completion status (%x).\n", __func__,
 		    vha->host_no, le16_to_cpu(sts->comp_status)));
 		rval = QLA_FUNCTION_FAILED;
-	} else if (!(le16_to_cpu(sts->scsi_status) &
-	    SS_RESPONSE_INFO_LEN_VALID)) {
-		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- no response info (%x).\n", __func__, vha->host_no,
-		    le16_to_cpu(sts->scsi_status)));
-		rval = QLA_FUNCTION_FAILED;
-	} else if (le32_to_cpu(sts->rsp_data_len) < 4) {
-		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- not enough response info (%d).\n", __func__,
-		    vha->host_no, le32_to_cpu(sts->rsp_data_len)));
-		rval = QLA_FUNCTION_FAILED;
-	} else if (sts->data[3]) {
-		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- response (%x).\n", __func__,
-		    vha->host_no, sts->data[3]));
-		rval = QLA_FUNCTION_FAILED;
+	} else if (le16_to_cpu(sts->scsi_status) &
+	    SS_RESPONSE_INFO_LEN_VALID) {
+		if (le32_to_cpu(sts->rsp_data_len) < 4) {
+			DEBUG2_3_11(printk("%s(%ld): ignoring inconsistent "
+			    "data length -- not enough response info (%d).\n",
+			    __func__, vha->host_no,
+			    le32_to_cpu(sts->rsp_data_len)));
+		} else if (sts->data[3]) {
+			DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
+			    "-- response (%x).\n", __func__,
+			    vha->host_no, sts->data[3]));
+			rval = QLA_FUNCTION_FAILED;
+		}
 	}
 
 	/* Issue marker IOCB. */
-- 
1.6.0.2

