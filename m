From: giridhar.malavali@qlogic.com
Subject: [PATCH 8/9] qla2xxx: Properly handle UNDERRUN completion statuses.
Date: Tue, 13 Oct 2009 15:16:52 -0700
Message-ID: <1255472213-472-9-git-send-email-giridhar.malavali@qlogic.com>
References: <1255472213-472-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:49706 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1760783AbZJMWY7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2009 18:24:59 -0400
In-Reply-To: <1255472213-472-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Lalit Chandivade <lalit.chandivade@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Correct issues where the lower scsi-status would be improperly
cleared, instead, allow the midlayer to process the status after
the proper residual-count checks are performed.  Finally,
validate firmware status flags prior to assigning values from the
FCP_RSP frame.

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Michael Hernandez <michael.hernandez@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |  120 +++++++++++++++++++---------------------
 1 files changed, 57 insertions(+), 63 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 4d758d2..8049873 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1353,16 +1353,22 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 	sense_len = rsp_info_len = resid_len = fw_resid_len = 0;
 	if (IS_FWI2_CAPABLE(ha)) {
-		sense_len = le32_to_cpu(sts24->sense_len);
-		rsp_info_len = le32_to_cpu(sts24->rsp_data_len);
-		resid_len = le32_to_cpu(sts24->rsp_residual_count);
-		fw_resid_len = le32_to_cpu(sts24->residual_len);
+		if (scsi_status & SS_SENSE_LEN_VALID)
+			sense_len = le32_to_cpu(sts24->sense_len);
+		if (scsi_status & SS_RESPONSE_INFO_LEN_VALID)
+			rsp_info_len = le32_to_cpu(sts24->rsp_data_len);
+		if (scsi_status & (SS_RESIDUAL_UNDER | SS_RESIDUAL_OVER))
+			resid_len = le32_to_cpu(sts24->rsp_residual_count);
+		if (comp_status == CS_DATA_UNDERRUN)
+			fw_resid_len = le32_to_cpu(sts24->residual_len);
 		rsp_info = sts24->data;
 		sense_data = sts24->data;
 		host_to_fcp_swap(sts24->data, sizeof(sts24->data));
 	} else {
-		sense_len = le16_to_cpu(sts->req_sense_length);
-		rsp_info_len = le16_to_cpu(sts->rsp_info_len);
+		if (scsi_status & SS_SENSE_LEN_VALID)
+			sense_len = le16_to_cpu(sts->req_sense_length);
+		if (scsi_status & SS_RESPONSE_INFO_LEN_VALID)
+			rsp_info_len = le16_to_cpu(sts->rsp_info_len);
 		resid_len = le32_to_cpu(sts->residual_length);
 		rsp_info = sts->rsp_info;
 		sense_data = sts->req_sense_data;
@@ -1449,38 +1455,62 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		break;
 
 	case CS_DATA_UNDERRUN:
-		resid = resid_len;
+		DEBUG2(printk(KERN_INFO
+		    "scsi(%ld:%d:%d) UNDERRUN status detected 0x%x-0x%x. "
+		    "resid=0x%x fw_resid=0x%x cdb=0x%x os_underflow=0x%x\n",
+		    vha->host_no, cp->device->id, cp->device->lun, comp_status,
+		    scsi_status, resid_len, fw_resid_len, cp->cmnd[0],
+		    cp->underflow));
+
 		/* Use F/W calculated residual length. */
-		if (IS_FWI2_CAPABLE(ha)) {
-			if (!(scsi_status & SS_RESIDUAL_UNDER)) {
-				lscsi_status = 0;
-			} else if (resid != fw_resid_len) {
-				scsi_status &= ~SS_RESIDUAL_UNDER;
-				lscsi_status = 0;
+		resid = IS_FWI2_CAPABLE(ha) ? fw_resid_len : resid_len;
+		scsi_set_resid(cp, resid);
+		if (scsi_status & SS_RESIDUAL_UNDER) {
+			if (IS_FWI2_CAPABLE(ha) && fw_resid_len != resid_len) {
+				DEBUG2(printk(
+				    "scsi(%ld:%d:%d:%d) Dropped frame(s) "
+				    "detected (%x of %x bytes)...residual "
+				    "length mismatch...retrying command.\n",
+				    vha->host_no, cp->device->channel,
+				    cp->device->id, cp->device->lun, resid,
+				    scsi_bufflen(cp)));
+
+				cp->result = DID_ERROR << 16 | lscsi_status;
+				break;
 			}
-			resid = fw_resid_len;
-		}
 
-		if (scsi_status & SS_RESIDUAL_UNDER) {
-			scsi_set_resid(cp, resid);
-		} else {
-			DEBUG2(printk(KERN_INFO
-			    "scsi(%ld:%d:%d) UNDERRUN status detected "
-			    "0x%x-0x%x. resid=0x%x fw_resid=0x%x cdb=0x%x "
-			    "os_underflow=0x%x\n", vha->host_no,
-			    cp->device->id, cp->device->lun, comp_status,
-			    scsi_status, resid_len, resid, cp->cmnd[0],
-			    cp->underflow));
+			if (!lscsi_status &&
+			    ((unsigned)(scsi_bufflen(cp) - resid) <
+			    cp->underflow)) {
+				qla_printk(KERN_INFO, ha,
+				    "scsi(%ld:%d:%d:%d): Mid-layer underflow "
+				    "detected (%x of %x bytes)...returning "
+				    "error status.\n", vha->host_no,
+				    cp->device->channel, cp->device->id,
+				    cp->device->lun, resid, scsi_bufflen(cp));
 
+				cp->result = DID_ERROR << 16;
+				break;
+			}
+		} else if (!lscsi_status) {
+			DEBUG2(printk(
+			    "scsi(%ld:%d:%d:%d) Dropped frame(s) detected "
+			    "(%x of %x bytes)...firmware reported underrun..."
+			    "retrying command.\n", vha->host_no,
+			    cp->device->channel, cp->device->id,
+			    cp->device->lun, resid, scsi_bufflen(cp)));
+
+			cp->result = DID_ERROR << 16;
+			break;
 		}
 
+		cp->result = DID_OK << 16 | lscsi_status;
+
 		/*
 		 * Check to see if SCSI Status is non zero. If so report SCSI
 		 * Status.
 		 */
 		if (lscsi_status != 0) {
-			cp->result = DID_OK << 16 | lscsi_status;
-
 			if (lscsi_status == SAM_STAT_TASK_SET_FULL) {
 				DEBUG2(printk(KERN_INFO
 				    "scsi(%ld): QUEUE FULL status detected "
@@ -1507,42 +1537,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 				break;
 
 			qla2x00_handle_sense(sp, sense_data, sense_len, rsp);
-		} else {
-			/*
-			 * If RISC reports underrun and target does not report
-			 * it then we must have a lost frame, so tell upper
-			 * layer to retry it by reporting an error.
-			 */
-			if (!(scsi_status & SS_RESIDUAL_UNDER)) {
-				DEBUG2(printk("scsi(%ld:%d:%d:%d) Dropped "
-					      "frame(s) detected (%x of %x bytes)..."
-					      "retrying command.\n",
-					vha->host_no, cp->device->channel,
-					cp->device->id, cp->device->lun, resid,
-					scsi_bufflen(cp)));
-
-				scsi_set_resid(cp, resid);
-				cp->result = DID_ERROR << 16;
-				break;
-			}
-
-			/* Handle mid-layer underflow */
-			if ((unsigned)(scsi_bufflen(cp) - resid) <
-			    cp->underflow) {
-				qla_printk(KERN_INFO, ha,
-					   "scsi(%ld:%d:%d:%d): Mid-layer underflow "
-					   "detected (%x of %x bytes)...returning "
-					   "error status.\n", vha->host_no,
-					   cp->device->channel, cp->device->id,
-					   cp->device->lun, resid,
-					   scsi_bufflen(cp));
-
-				cp->result = DID_ERROR << 16;
-				break;
-			}
-
-			/* Everybody online, looking good... */
-			cp->result = DID_OK << 16;
 		}
 		break;
 
-- 
1.6.2.rc1.30.gd43c

