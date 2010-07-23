From: giridhar.malavali@qlogic.com
Subject: [PATCH 06/17] qla2xxx: Correct extended sense-data handling.
Date: Fri, 23 Jul 2010 15:28:27 +0500
Message-ID: <1279880918-62876-7-git-send-email-giridhar.malavali@qlogic.com>
References: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47944 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755135Ab0GWJ7Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2010 05:59:16 -0400
In-Reply-To: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, madhu.iyengar@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Earlier implementation did not take into account the varying
sizes of data buffers returned from structures sts_entry_t and
sts_entry_24xx.  Sense-data after the 20th byte could be
incorrect.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ba971ac..88b5774 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1320,8 +1320,9 @@ qla2x00_process_response_queue(struct rsp_que *rsp)
 }
 
 static inline void
-qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t sense_len,
-	struct rsp_que *rsp)
+
+qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t par_sense_len,
+    uint32_t sense_len, struct rsp_que *rsp)
 {
 	struct scsi_cmnd *cp = sp->cmd;
 
@@ -1330,8 +1331,8 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t sense_len,
 
 	sp->request_sense_length = sense_len;
 	sp->request_sense_ptr = cp->sense_buffer;
-	if (sp->request_sense_length > 32)
-		sense_len = 32;
+	if (sp->request_sense_length > par_sense_len)
+		sense_len = par_sense_len;
 
 	memcpy(cp->sense_buffer, sense_data, sense_len);
 
@@ -1438,7 +1439,8 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	uint16_t	ox_id;
 	uint8_t		lscsi_status;
 	int32_t		resid;
-	uint32_t	sense_len, rsp_info_len, resid_len, fw_resid_len;
+	uint32_t sense_len, par_sense_len, rsp_info_len, resid_len,
+	    fw_resid_len;
 	uint8_t		*rsp_info, *sense_data;
 	struct qla_hw_data *ha = vha->hw;
 	uint32_t handle;
@@ -1496,7 +1498,8 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	fcport = sp->fcport;
 
 	ox_id = 0;
-	sense_len = rsp_info_len = resid_len = fw_resid_len = 0;
+	sense_len = par_sense_len = rsp_info_len = resid_len =
+	    fw_resid_len = 0;
 	if (IS_FWI2_CAPABLE(ha)) {
 		if (scsi_status & SS_SENSE_LEN_VALID)
 			sense_len = le32_to_cpu(sts24->sense_len);
@@ -1510,6 +1513,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		sense_data = sts24->data;
 		host_to_fcp_swap(sts24->data, sizeof(sts24->data));
 		ox_id = le16_to_cpu(sts24->ox_id);
+		par_sense_len = sizeof(sts24->data);
 	} else {
 		if (scsi_status & SS_SENSE_LEN_VALID)
 			sense_len = le16_to_cpu(sts->req_sense_length);
@@ -1518,13 +1522,16 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		resid_len = le32_to_cpu(sts->residual_length);
 		rsp_info = sts->rsp_info;
 		sense_data = sts->req_sense_data;
+		par_sense_len = sizeof(sts->req_sense_data);
 	}
 
 	/* Check for any FCP transport errors. */
 	if (scsi_status & SS_RESPONSE_INFO_LEN_VALID) {
 		/* Sense data lies beyond any FCP RESPONSE data. */
-		if (IS_FWI2_CAPABLE(ha))
+		if (IS_FWI2_CAPABLE(ha)) {
 			sense_data += rsp_info_len;
+			par_sense_len -= rsp_info_len;
+		}
 		if (rsp_info_len > 3 && rsp_info[3]) {
 			DEBUG2(qla_printk(KERN_INFO, ha,
 			    "scsi(%ld:%d:%d): FCP I/O protocol failure "
@@ -1584,7 +1591,8 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		if (!(scsi_status & SS_SENSE_LEN_VALID))
 			break;
 
-		qla2x00_handle_sense(sp, sense_data, sense_len, rsp);
+		qla2x00_handle_sense(sp, sense_data, par_sense_len, sense_len,
+		    rsp);
 		break;
 
 	case CS_DATA_UNDERRUN:
@@ -1648,7 +1656,8 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 			if (!(scsi_status & SS_SENSE_LEN_VALID))
 				break;
 
-			qla2x00_handle_sense(sp, sense_data, sense_len, rsp);
+			qla2x00_handle_sense(sp, sense_data, par_sense_len,
+			    sense_len, rsp);
 		}
 		break;
 
-- 
1.6.0.2

