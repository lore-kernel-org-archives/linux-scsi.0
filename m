From: giridhar.malavali@qlogic.com
Subject: [PATCH 6/9] qla2xxx: Properly check FCP_RSP response-info field after TMF completion.
Date: Tue, 13 Oct 2009 15:16:50 -0700
Message-ID: <1255472213-472-7-git-send-email-giridhar.malavali@qlogic.com>
References: <1255472213-472-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:49694 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1761500AbZJMWYQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2009 18:24:16 -0400
In-Reply-To: <1255472213-472-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Original code discarded response-info field information and
assumed the command completed successfully without verifying the
target's status within the FCP_RSP packet.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index a10d41b..791f792 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2318,6 +2318,7 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 {
 	int		rval, rval2;
 	struct tsk_mgmt_cmd *tsk;
+	struct sts_entry_24xx *sts;
 	dma_addr_t	tsk_dma;
 	scsi_qla_host_t *vha;
 	struct qla_hw_data *ha;
@@ -2357,20 +2358,37 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 		    sizeof(tsk->p.tsk.lun));
 	}
 
+	sts = &tsk->p.sts;
 	rval = qla2x00_issue_iocb(vha, tsk, tsk_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue %s Reset IOCB "
 		    "(%x).\n", __func__, vha->host_no, name, rval));
-	} else if (tsk->p.sts.entry_status != 0) {
+	} else if (sts->entry_status != 0) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
 		    "-- error status (%x).\n", __func__, vha->host_no,
-		    tsk->p.sts.entry_status));
+		    sts->entry_status));
 		rval = QLA_FUNCTION_FAILED;
-	} else if (tsk->p.sts.comp_status !=
+	} else if (sts->comp_status !=
 	    __constant_cpu_to_le16(CS_COMPLETE)) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
 		    "-- completion status (%x).\n", __func__,
-		    vha->host_no, le16_to_cpu(tsk->p.sts.comp_status)));
+		    vha->host_no, le16_to_cpu(sts->comp_status)));
+		rval = QLA_FUNCTION_FAILED;
+	} else if (!(le16_to_cpu(sts->scsi_status) &
+	    SS_RESPONSE_INFO_LEN_VALID)) {
+		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
+		    "-- no response info (%x).\n", __func__, vha->host_no,
+		    le16_to_cpu(sts->scsi_status)));
+		rval = QLA_FUNCTION_FAILED;
+	} else if (le32_to_cpu(sts->rsp_data_len) < 4) {
+		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
+		    "-- not enough response info (%d).\n", __func__,
+		    vha->host_no, le32_to_cpu(sts->rsp_data_len)));
+		rval = QLA_FUNCTION_FAILED;
+	} else if (sts->data[3]) {
+		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
+		    "-- response (%x).\n", __func__,
+		    vha->host_no, sts->data[3]));
 		rval = QLA_FUNCTION_FAILED;
 	}
 
-- 
1.6.2.rc1.30.gd43c

