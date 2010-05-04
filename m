From: giridhar.malavali@qlogic.com
Subject: [PATCH 07/16] qla2xxx: Cleanup FCP-command-status processing debug statements.
Date: Tue,  4 May 2010 15:01:27 -0700
Message-ID: <1273010496-43045-8-git-send-email-giridhar.malavali@qlogic.com>
References: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47173 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1760228Ab0EDWBl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 18:01:41 -0400
In-Reply-To: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Migrate to a consistent set of debug entries during status-IOCB
handling:

* group CS_TIMEOUT handling with CS_PORT_UNAVAILABLE and the like
  (more regrouping of common behaviour).

* drop CS_DATA_OVERRUN handling as it now falls into the
  'default' case (still returns DID_ERROR).

* consolidate CS_RESET and CS_ABORTED handling, as we the only
  functional difference was a printk() (still returns DID_RESET).

* dropped all the earlier inconsistent [qla_]printk()s sprinkled
  throught the needlessly large case-statement.  Failure case
  I/Os are now logged with a 'standard' format:

	<command failure details>
	<command generic details>

  so, for example a dropped-frame is logged as:

	qla2xxx 0000:13:00.0: scsi(16:0:0) Dropped frame(s) detected (4000 of 4000 bytes).
	qla2xxx 0000:13:00.0: scsi(16:0:0) FCP command status: 0x15-0x18 (70018) \
    oxid=78 ser=76 cdb=280000 len=4000 rsp_info=0 resid=0 fw_resid=4000

  which should now convey all relevant information.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |  192 +++++++++++++---------------------------
 1 files changed, 63 insertions(+), 129 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index a1968eb..b92f9a6 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1283,6 +1283,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	struct sts_entry_24xx *sts24;
 	uint16_t	comp_status;
 	uint16_t	scsi_status;
+	uint16_t	ox_id;
 	uint8_t		lscsi_status;
 	int32_t		resid;
 	uint32_t	sense_len, rsp_info_len, resid_len, fw_resid_len;
@@ -1291,6 +1292,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	uint32_t handle;
 	uint16_t que;
 	struct req_que *req;
+	int logit = 1;
 
 	sts = (sts_entry_t *) pkt;
 	sts24 = (struct sts_entry_24xx *) pkt;
@@ -1320,9 +1322,9 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		sp = NULL;
 
 	if (sp == NULL) {
-		DEBUG2(printk("scsi(%ld): Status Entry invalid handle.\n",
-		    vha->host_no));
-		qla_printk(KERN_WARNING, ha, "Status Entry invalid handle.\n");
+		qla_printk(KERN_WARNING, ha,
+		    "scsi(%ld): Invalid status handle (0x%x).\n", vha->host_no,
+		    sts->handle);
 
 		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		qla2xxx_wake_dpc(vha);
@@ -1330,10 +1332,9 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	}
 	cp = sp->cmd;
 	if (cp == NULL) {
-		DEBUG2(printk("scsi(%ld): Command already returned back to OS "
-		    "pkt->handle=%d sp=%p.\n", vha->host_no, handle, sp));
 		qla_printk(KERN_WARNING, ha,
-		    "Command is NULL: already returned to OS (sp=%p)\n", sp);
+		    "scsi(%ld): Command already returned (0x%x/%p).\n",
+		    vha->host_no, sts->handle, sp);
 
 		return;
 	}
@@ -1342,6 +1343,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 	fcport = sp->fcport;
 
+	ox_id = 0;
 	sense_len = rsp_info_len = resid_len = fw_resid_len = 0;
 	if (IS_FWI2_CAPABLE(ha)) {
 		if (scsi_status & SS_SENSE_LEN_VALID)
@@ -1355,6 +1357,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		rsp_info = sts24->data;
 		sense_data = sts24->data;
 		host_to_fcp_swap(sts24->data, sizeof(sts24->data));
+		ox_id = le16_to_cpu(sts24->ox_id);
 	} else {
 		if (scsi_status & SS_SENSE_LEN_VALID)
 			sense_len = le16_to_cpu(sts->req_sense_length);
@@ -1371,17 +1374,13 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		if (IS_FWI2_CAPABLE(ha))
 			sense_data += rsp_info_len;
 		if (rsp_info_len > 3 && rsp_info[3]) {
-			DEBUG2(printk("scsi(%ld:%d:%d:%d) FCP I/O protocol "
-			    "failure (%x/%02x%02x%02x%02x%02x%02x%02x%02x)..."
-			    "retrying command\n", vha->host_no,
-			    cp->device->channel, cp->device->id,
-			    cp->device->lun, rsp_info_len, rsp_info[0],
-			    rsp_info[1], rsp_info[2], rsp_info[3], rsp_info[4],
-			    rsp_info[5], rsp_info[6], rsp_info[7]));
+			DEBUG2(qla_printk(KERN_INFO, ha,
+			    "scsi(%ld:%d:%d): FCP I/O protocol failure "
+			    "(0x%x/0x%x).\n", vha->host_no, cp->device->id,
+			    cp->device->lun, rsp_info_len, rsp_info[3]));
 
 			cp->result = DID_BUS_BUSY << 16;
-			qla2x00_sp_compl(ha, sp);
-			return;
+			goto out;
 		}
 	}
 
@@ -1408,12 +1407,10 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 			    ((unsigned)(scsi_bufflen(cp) - resid) <
 			     cp->underflow)) {
 				qla_printk(KERN_INFO, ha,
-					   "scsi(%ld:%d:%d:%d): Mid-layer underflow "
-					   "detected (%x of %x bytes)...returning "
-					   "error status.\n", vha->host_no,
-					   cp->device->channel, cp->device->id,
-					   cp->device->lun, resid,
-					   scsi_bufflen(cp));
+				    "scsi(%ld:%d:%d): Mid-layer underflow "
+				    "detected (0x%x of 0x%x bytes).\n",
+				    vha->host_no, cp->device->id,
+				    cp->device->lun, resid, scsi_bufflen(cp));
 
 				cp->result = DID_ERROR << 16;
 				break;
@@ -1422,12 +1419,12 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		cp->result = DID_OK << 16 | lscsi_status;
 
 		if (lscsi_status == SAM_STAT_TASK_SET_FULL) {
-			DEBUG2(printk(KERN_INFO
-			    "scsi(%ld): QUEUE FULL status detected "
-			    "0x%x-0x%x.\n", vha->host_no, comp_status,
-			    scsi_status));
+			DEBUG2(qla_printk(KERN_INFO, ha,
+			    "scsi(%ld:%d:%d) QUEUE FULL detected.\n",
+			    vha->host_no, cp->device->id, cp->device->lun));
 			break;
 		}
+		logit = 0;
 		if (lscsi_status != SS_CHECK_CONDITION)
 			break;
 
@@ -1439,23 +1436,14 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		break;
 
 	case CS_DATA_UNDERRUN:
-		DEBUG2(printk(KERN_INFO
-		    "scsi(%ld:%d:%d) UNDERRUN status detected 0x%x-0x%x. "
-		    "resid=0x%x fw_resid=0x%x cdb=0x%x os_underflow=0x%x\n",
-		    vha->host_no, cp->device->id, cp->device->lun, comp_status,
-		    scsi_status, resid_len, fw_resid_len, cp->cmnd[0],
-		    cp->underflow));
-
 		/* Use F/W calculated residual length. */
 		resid = IS_FWI2_CAPABLE(ha) ? fw_resid_len : resid_len;
 		scsi_set_resid(cp, resid);
 		if (scsi_status & SS_RESIDUAL_UNDER) {
 			if (IS_FWI2_CAPABLE(ha) && fw_resid_len != resid_len) {
-				DEBUG2(printk(
-				    "scsi(%ld:%d:%d:%d) Dropped frame(s) "
-				    "detected (%x of %x bytes)...residual "
-				    "length mismatch...retrying command.\n",
-				    vha->host_no, cp->device->channel,
+				DEBUG2(qla_printk(KERN_INFO, ha,
+				    "scsi(%ld:%d:%d) Dropped frame(s) detected "
+				    "(0x%x of 0x%x bytes).\n", vha->host_no,
 				    cp->device->id, cp->device->lun, resid,
 				    scsi_bufflen(cp)));
 
@@ -1467,21 +1455,18 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 			    ((unsigned)(scsi_bufflen(cp) - resid) <
 			    cp->underflow)) {
 				qla_printk(KERN_INFO, ha,
-				    "scsi(%ld:%d:%d:%d): Mid-layer underflow "
-				    "detected (%x of %x bytes)...returning "
-				    "error status.\n", vha->host_no,
-				    cp->device->channel, cp->device->id,
+				    "scsi(%ld:%d:%d): Mid-layer underflow "
+				    "detected (0x%x of 0x%x bytes).\n",
+				    vha->host_no, cp->device->id,
 				    cp->device->lun, resid, scsi_bufflen(cp));
 
 				cp->result = DID_ERROR << 16;
 				break;
 			}
 		} else if (!lscsi_status) {
-			DEBUG2(printk(
-			    "scsi(%ld:%d:%d:%d) Dropped frame(s) detected "
-			    "(%x of %x bytes)...firmware reported underrun..."
-			    "retrying command.\n", vha->host_no,
-			    cp->device->channel, cp->device->id,
+			DEBUG2(qla_printk(KERN_INFO, ha,
+			    "scsi(%ld:%d:%d) Dropped frame(s) detected (0x%x "
+			    "of 0x%x bytes).\n", vha->host_no, cp->device->id,
 			    cp->device->lun, resid, scsi_bufflen(cp)));
 
 			cp->result = DID_ERROR << 16;
@@ -1489,6 +1474,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		}
 
 		cp->result = DID_OK << 16 | lscsi_status;
+		logit = 0;
 
 		/*
 		 * Check to see if SCSI Status is non zero. If so report SCSI
@@ -1496,10 +1482,11 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		 */
 		if (lscsi_status != 0) {
 			if (lscsi_status == SAM_STAT_TASK_SET_FULL) {
-				DEBUG2(printk(KERN_INFO
-				    "scsi(%ld): QUEUE FULL status detected "
-				    "0x%x-0x%x.\n", vha->host_no, comp_status,
-				    scsi_status));
+				DEBUG2(qla_printk(KERN_INFO, ha,
+				    "scsi(%ld:%d:%d) QUEUE FULL detected.\n",
+				    vha->host_no, cp->device->id,
+				    cp->device->lun));
+				logit = 1;
 				break;
 			}
 			if (lscsi_status != SS_CHECK_CONDITION)
@@ -1513,109 +1500,56 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		}
 		break;
 
-	case CS_DATA_OVERRUN:
-		DEBUG2(printk(KERN_INFO
-		    "scsi(%ld:%d:%d): OVERRUN status detected 0x%x-0x%x\n",
-		    vha->host_no, cp->device->id, cp->device->lun, comp_status,
-		    scsi_status));
-		DEBUG2(printk(KERN_INFO
-		    "CDB: 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x\n",
-		    cp->cmnd[0], cp->cmnd[1], cp->cmnd[2], cp->cmnd[3],
-		    cp->cmnd[4], cp->cmnd[5]));
-		DEBUG2(printk(KERN_INFO
-		    "PID=0x%lx req=0x%x xtra=0x%x -- returning DID_ERROR "
-		    "status!\n",
-		    cp->serial_number, scsi_bufflen(cp), resid_len));
-
-		cp->result = DID_ERROR << 16;
-		break;
-
 	case CS_PORT_LOGGED_OUT:
 	case CS_PORT_CONFIG_CHG:
 	case CS_PORT_BUSY:
 	case CS_INCOMPLETE:
 	case CS_PORT_UNAVAILABLE:
-		/*
-		 * If the port is in Target Down state, return all IOs for this
-		 * Target with DID_NO_CONNECT ELSE Queue the IOs in the
-		 * retry_queue.
-		 */
-		DEBUG2(printk("scsi(%ld:%d:%d): status_entry: Port Down "
-		    "pid=%ld, compl status=0x%x, port state=0x%x\n",
-		    vha->host_no, cp->device->id, cp->device->lun,
-		    cp->serial_number, comp_status,
-		    atomic_read(&fcport->state)));
-
+	case CS_TIMEOUT:
 		/*
 		 * We are going to have the fc class block the rport
 		 * while we try to recover so instruct the mid layer
 		 * to requeue until the class decides how to handle this.
 		 */
 		cp->result = DID_TRANSPORT_DISRUPTED << 16;
+
+		if (comp_status == CS_TIMEOUT) {
+			if (IS_FWI2_CAPABLE(ha))
+				break;
+			else if ((le16_to_cpu(sts->status_flags) &
+			    SF_LOGOUT_SENT) == 0)
+				break;
+		}
+
+		DEBUG2(qla_printk(KERN_INFO, ha,
+			"scsi(%ld:%d:%d) Port down status: port-state=0x%x\n",
+			vha->host_no, cp->device->id, cp->device->lun,
+			atomic_read(&fcport->state)));
+
 		if (atomic_read(&fcport->state) == FCS_ONLINE)
 			qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
 		break;
 
 	case CS_RESET:
-		DEBUG2(printk(KERN_INFO
-		    "scsi(%ld): RESET status detected 0x%x-0x%x.\n",
-		    vha->host_no, comp_status, scsi_status));
-
-		cp->result = DID_RESET << 16;
-		break;
-
 	case CS_ABORTED:
-		/*
-		 * hv2.19.12 - DID_ABORT does not retry the request if we
-		 * aborted this request then abort otherwise it must be a
-		 * reset.
-		 */
-		DEBUG2(printk(KERN_INFO
-		    "scsi(%ld): ABORT status detected 0x%x-0x%x.\n",
-		    vha->host_no, comp_status, scsi_status));
-
 		cp->result = DID_RESET << 16;
 		break;
-
-	case CS_TIMEOUT:
-		/*
-		 * We are going to have the fc class block the rport
-		 * while we try to recover so instruct the mid layer
-		 * to requeue until the class decides how to handle this.
-		 */
-		cp->result = DID_TRANSPORT_DISRUPTED << 16;
-
-		if (IS_FWI2_CAPABLE(ha)) {
-			DEBUG2(printk(KERN_INFO
-			    "scsi(%ld:%d:%d:%d): TIMEOUT status detected "
-			    "0x%x-0x%x\n", vha->host_no, cp->device->channel,
-			    cp->device->id, cp->device->lun, comp_status,
-			    scsi_status));
-			break;
-		}
-		DEBUG2(printk(KERN_INFO
-		    "scsi(%ld:%d:%d:%d): TIMEOUT status detected 0x%x-0x%x "
-		    "sflags=%x.\n", vha->host_no, cp->device->channel,
-		    cp->device->id, cp->device->lun, comp_status, scsi_status,
-		    le16_to_cpu(sts->status_flags)));
-
-		/* Check to see if logout occurred. */
-		if ((le16_to_cpu(sts->status_flags) & SF_LOGOUT_SENT))
-			qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
-		break;
-
 	default:
-		DEBUG3(printk("scsi(%ld): Error detected (unknown status) "
-		    "0x%x-0x%x.\n", vha->host_no, comp_status, scsi_status));
-		qla_printk(KERN_INFO, ha,
-		    "Unknown status detected 0x%x-0x%x.\n",
-		    comp_status, scsi_status);
-
 		cp->result = DID_ERROR << 16;
 		break;
 	}
 
-	/* Place command on done queue. */
+out:
+	if (logit)
+		DEBUG2(qla_printk(KERN_INFO, ha,
+		    "scsi(%ld:%d:%d) FCP command status: 0x%x-0x%x (0x%x) "
+		    "oxid=0x%x ser=0x%lx cdb=%02x%02x%02x len=0x%x "
+		    "rsp_info=0x%x resid=0x%x fw_resid=0x%x\n", vha->host_no,
+		    cp->device->id, cp->device->lun, comp_status, scsi_status,
+		    cp->result, ox_id, cp->serial_number, cp->cmnd[0],
+		    cp->cmnd[1], cp->cmnd[2], scsi_bufflen(cp), rsp_info_len,
+		    resid_len, fw_resid_len));
+
 	if (rsp->status_srb == NULL)
 		qla2x00_sp_compl(ha, sp);
 }
-- 
1.6.2.rc1.30.gd43c

