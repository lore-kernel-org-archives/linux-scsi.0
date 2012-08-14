From: James Smart <james.smart@emulex.com>
Subject: [PATCH 04/12] lpfc 8.3.34: Fix parameter field in CQE to mask for
 LOCAL_REJECT status
Date: Tue, 14 Aug 2012 14:25:43 -0400
Message-ID: <1344968743.4432.19.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:26694 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2HNS0H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2012 14:26:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix parameter field in CQE to mask for LOCAL_REJECT status

Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c  |    6 +++---
 lpfc_ct.c   |   16 +++++++++++-----
 lpfc_els.c  |   17 +++++++++++------
 lpfc_hw.h   |    1 +
 lpfc_hw4.h  |    2 +-
 lpfc_scsi.c |    2 +-
 lpfc_sli.c  |   17 ++++++++++-------
 7 files changed, 38 insertions(+), 23 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2012-08-11 12:18:39.483937201 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2012-08-11 12:24:51.903924265 -0400
@@ -195,7 +195,7 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_h
 
 	if (rsp->ulpStatus) {
 		if (rsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
-			switch (rsp->un.ulpWord[4] & 0xff) {
+			switch (rsp->un.ulpWord[4] & IOERR_PARAM_MASK) {
 			case IOERR_SEQUENCE_TIMEOUT:
 				rc = -ETIMEDOUT;
 				break;
@@ -1234,7 +1234,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *p
 
 	if (rsp->ulpStatus) {
 		if (rsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
-			switch (rsp->un.ulpWord[4] & 0xff) {
+			switch (rsp->un.ulpWord[4] & IOERR_PARAM_MASK) {
 			case IOERR_SEQUENCE_TIMEOUT:
 				rc = -ETIMEDOUT;
 				break;
@@ -4798,7 +4798,7 @@ lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *
 	menlo_resp->xri = rsp->ulpContext;
 	if (rsp->ulpStatus) {
 		if (rsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
-			switch (rsp->un.ulpWord[4] & 0xff) {
+			switch (rsp->un.ulpWord[4] & IOERR_PARAM_MASK) {
 			case IOERR_SEQUENCE_TIMEOUT:
 				rc = -ETIMEDOUT;
 				break;
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2012-07-22 10:46:05.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2012-08-11 12:24:51.907924266 -0400
@@ -104,7 +104,8 @@ lpfc_ct_unsol_event(struct lpfc_hba *phb
 	if (unlikely(icmd->ulpStatus == IOSTAT_NEED_BUFFER)) {
 		lpfc_sli_hbqbuf_add_hbqs(phba, LPFC_ELS_HBQ);
 	} else if ((icmd->ulpStatus == IOSTAT_LOCAL_REJECT) &&
-		((icmd->un.ulpWord[4] & 0xff) == IOERR_RCV_BUFFER_WAITING)) {
+		   ((icmd->un.ulpWord[4] & IOERR_PARAM_MASK) ==
+		   IOERR_RCV_BUFFER_WAITING)) {
 		/* Not enough posted buffers; Try posting more buffers */
 		phba->fc_stat.NoRcvBuf++;
 		if (!(phba->sli3_options & LPFC_SLI3_HBQ_ENABLED))
@@ -633,7 +634,8 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba
 		/* Check for retry */
 		if (vport->fc_ns_retry < LPFC_MAX_NS_RETRY) {
 			if (irsp->ulpStatus != IOSTAT_LOCAL_REJECT ||
-			    irsp->un.ulpWord[4] != IOERR_NO_RESOURCES)
+			    (irsp->un.ulpWord[4] && IOERR_PARAM_MASK) !=
+			    IOERR_NO_RESOURCES)
 				vport->fc_ns_retry++;
 
 			/* CT command is being retried */
@@ -783,7 +785,9 @@ lpfc_cmpl_ct_cmd_gff_id(struct lpfc_hba
 		if (cmdiocb->retry < LPFC_MAX_NS_RETRY) {
 			retry = 1;
 			if (irsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
-				switch (irsp->un.ulpWord[4]) {
+				switch ((irsp->un.ulpWord[4] &
+					IOERR_PARAM_MASK)) {
+
 				case IOERR_NO_RESOURCES:
 					/* We don't increment the retry
 					 * count for this case.
@@ -908,8 +912,10 @@ lpfc_cmpl_ct(struct lpfc_hba *phba, stru
 				 cmdcode, irsp->ulpStatus, irsp->un.ulpWord[4]);
 
 		if ((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
-			((irsp->un.ulpWord[4] == IOERR_SLI_DOWN) ||
-			 (irsp->un.ulpWord[4] == IOERR_SLI_ABORTED)))
+			(((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) ==
+			  IOERR_SLI_DOWN) ||
+			 ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) ==
+			  IOERR_SLI_ABORTED)))
 			goto out;
 
 		retry = cmdiocb->retry;
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2012-08-11 12:24:51.408924283 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2012-08-11 12:24:51.912924266 -0400
@@ -962,7 +962,8 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 			if ((phba->fcoe_cvl_eventtag_attn ==
 			     phba->fcoe_cvl_eventtag) &&
 			    (irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
-			    (irsp->un.ulpWord[4] == IOERR_SLI_ABORTED))
+			    ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) ==
+			    IOERR_SLI_ABORTED))
 				goto stop_rr_fcf_flogi;
 			else
 				phba->fcoe_cvl_eventtag_attn =
@@ -1108,8 +1109,10 @@ flogifail:
 		/* Start discovery */
 		lpfc_disc_start(vport);
 	} else if (((irsp->ulpStatus != IOSTAT_LOCAL_REJECT) ||
-			((irsp->un.ulpWord[4] != IOERR_SLI_ABORTED) &&
-			(irsp->un.ulpWord[4] != IOERR_SLI_DOWN))) &&
+			(((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) !=
+			 IOERR_SLI_ABORTED) &&
+			((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) !=
+			 IOERR_SLI_DOWN))) &&
 			(phba->link_state != LPFC_CLEAR_LA)) {
 		/* If FLOGI failed enable link interrupt. */
 		lpfc_issue_clear_la(phba, vport);
@@ -3070,7 +3073,7 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 		}
 		break;
 	case IOSTAT_LOCAL_REJECT:
-		switch ((irsp->un.ulpWord[4] & 0xff)) {
+		switch ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK)) {
 		case IOERR_LOOP_OPEN_FAILURE:
 			if (cmd == ELS_CMD_FLOGI) {
 				if (PCI_DEVICE_ID_HORNET ==
@@ -3277,7 +3280,8 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 
 		if (((cmd == ELS_CMD_PLOGI) || (cmd == ELS_CMD_ADISC)) &&
 			((irsp->ulpStatus != IOSTAT_LOCAL_REJECT) ||
-			((irsp->un.ulpWord[4] & 0xff) != IOERR_NO_RESOURCES))) {
+			((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) !=
+			IOERR_NO_RESOURCES))) {
 			/* Don't reset timer for no resources */
 
 			/* If discovery / RSCN timer is running, reset it */
@@ -6870,7 +6874,8 @@ lpfc_els_unsol_event(struct lpfc_hba *ph
 	if (icmd->ulpStatus == IOSTAT_NEED_BUFFER) {
 		lpfc_sli_hbqbuf_add_hbqs(phba, LPFC_ELS_HBQ);
 	} else if (icmd->ulpStatus == IOSTAT_LOCAL_REJECT &&
-	    (icmd->un.ulpWord[4] & 0xff) == IOERR_RCV_BUFFER_WAITING) {
+		   (icmd->un.ulpWord[4] & IOERR_PARAM_MASK) ==
+		   IOERR_RCV_BUFFER_WAITING) {
 		phba->fc_stat.NoRcvBuf++;
 		/* Not enough posted buffers; Try posting more buffers */
 		if (!(phba->sli3_options & LPFC_SLI3_HBQ_ENABLED))
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2012-08-11 12:24:51.631924276 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2012-08-11 12:24:51.920924266 -0400
@@ -344,7 +344,7 @@ struct lpfc_cqe {
  * Define mask value for xri_aborted and wcqe completed CQE extended status.
  * Currently, extended status is limited to 9 bits (0x0 -> 0x103) .
  */
-#define WCQE_PARAM_MASK		0x1FF;
+#define WCQE_PARAM_MASK		0x1FF
 
 /* completion queue entry for wqe completions */
 struct lpfc_wcqe_complete {
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2012-08-11 12:18:40.448937168 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2012-08-11 12:24:51.921924266 -0400
@@ -3245,6 +3245,7 @@ typedef struct {
 #define IOERR_SLI_DOWN                0x101  /* ulpStatus  - Driver defined */
 #define IOERR_SLI_BRESET              0x102
 #define IOERR_SLI_ABORTED             0x103
+#define IOERR_PARAM_MASK              0x1ff
 } PARM_ERR;
 
 typedef union {
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-08-11 12:18:39.848937190 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-08-11 12:24:51.928924265 -0400
@@ -3615,7 +3615,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba
 	cmd = lpfc_cmd->pCmd;
 	shost = cmd->device->host;
 
-	lpfc_cmd->result = pIocbOut->iocb.un.ulpWord[4];
+	lpfc_cmd->result = (pIocbOut->iocb.un.ulpWord[4] & IOERR_PARAM_MASK);
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
 	/* pick up SLI4 exhange busy status from HBA */
 	lpfc_cmd->exch_busy = pIocbOut->iocb_flag & LPFC_EXCHANGE_BUSY;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-08-11 12:24:51.436924282 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-08-11 12:24:51.943924265 -0400
@@ -2963,7 +2963,8 @@ lpfc_sli_handle_fast_ring_event(struct l
 			 * queuedepths of the SCSI device.
 			 */
 			if ((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
-				(irsp->un.ulpWord[4] == IOERR_NO_RESOURCES)) {
+			    ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) ==
+			     IOERR_NO_RESOURCES)) {
 				spin_unlock_irqrestore(&phba->hbalock, iflag);
 				phba->lpfc_rampdown_queue_depth(phba);
 				spin_lock_irqsave(&phba->hbalock, iflag);
@@ -3135,7 +3136,8 @@ lpfc_sli_sp_handle_rspiocb(struct lpfc_h
 		 * queuedepths of the SCSI device.
 		 */
 		if ((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
-		    (irsp->un.ulpWord[4] == IOERR_NO_RESOURCES)) {
+		    ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) ==
+		     IOERR_NO_RESOURCES)) {
 			spin_unlock_irqrestore(&phba->hbalock, iflag);
 			phba->lpfc_rampdown_queue_depth(phba);
 			spin_lock_irqsave(&phba->hbalock, iflag);
@@ -8642,7 +8644,7 @@ lpfc_sli4_abts_err_handler(struct lpfc_h
 	 * LOCAL_REJECT and 0 for a failed ABTS exchange and later OCe and
 	 * LPe FW releases returned LOCAL_REJECT and SEQUENCE_TIMEOUT.
 	 */
-	ext_status = axri->parameter & WCQE_PARAM_MASK;
+	ext_status = axri->parameter & IOERR_PARAM_MASK;
 	if ((bf_get(lpfc_wcqe_xa_status, axri) == IOSTAT_LOCAL_REJECT) &&
 	    ((ext_status == IOERR_SEQUENCE_TIMEOUT) || (ext_status == 0)))
 		lpfc_sli_abts_recover_port(vport, ndlp);
@@ -11579,11 +11581,12 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc
 		/* If resource errors reported from HBA, reduce queue
 		 * depth of the SCSI device.
 		 */
-		if ((bf_get(lpfc_wcqe_c_status, wcqe) ==
-		     IOSTAT_LOCAL_REJECT) &&
-		    (wcqe->parameter == IOERR_NO_RESOURCES)) {
+		if (((bf_get(lpfc_wcqe_c_status, wcqe) ==
+		     IOSTAT_LOCAL_REJECT)) &&
+		    ((wcqe->parameter & IOERR_PARAM_MASK) ==
+		     IOERR_NO_RESOURCES))
 			phba->lpfc_rampdown_queue_depth(phba);
-		}
+
 		/* Log the error status */
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"0373 FCP complete error: status=x%x, "



