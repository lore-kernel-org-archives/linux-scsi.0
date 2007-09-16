From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 03/17] advansys: Restructure asc_execute_scsi_cmnd()
Date: Sun, 16 Sep 2007 09:37:34 -0600
Message-ID: <1189957068581-git-send-email-matthew@wil.cx>
References: <1189867145.3339.3.camel@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:34849 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbXIPPhj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Sep 2007 11:37:39 -0400
In-Reply-To: <1189867145.3339.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

The wide and narrow boards share identical handling of the return value,
except for some trivial error messages.  Move the handling to the common
end of the function.  Also move variable declarations to the arms of
the `if' that they're used in and delete some pointless comments.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  131 ++++++++++++++---------------------------------
 1 files changed, 39 insertions(+), 92 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 737c0e4..3dd7856 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -11331,80 +11331,26 @@ static int AdvExeScsiQueue(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
  */
 static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 {
-	asc_board_t *boardp;
-	ASC_DVC_VAR *asc_dvc_varp;
-	ADV_DVC_VAR *adv_dvc_varp;
-	ADV_SCSI_REQ_Q *adv_scsiqp;
-	int ret;
+	int ret, err_code;
+	asc_board_t *boardp = ASC_BOARDP(scp->device->host);
 
-	ASC_DBG2(1, "asc_execute_scsi_cmnd: scp 0x%lx, done 0x%lx\n",
-		 (ulong)scp, (ulong)scp->scsi_done);
-
-	boardp = ASC_BOARDP(scp->device->host);
+	ASC_DBG1(1, "asc_execute_scsi_cmnd: scp 0x%p\n", scp);
 
 	if (ASC_NARROW_BOARD(boardp)) {
-		/*
-		 * Build and execute Narrow Board request.
-		 */
-
-		asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
+		ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
 
-		/*
-		 * Build Asc Library request structure using the
-		 * global structures 'asc_scsi_req' and 'asc_sg_head'.
-		 *
-		 * If an error is returned, then the request has been
-		 * queued on the board done queue. It will be completed
-		 * by the caller.
-		 *
-		 * asc_build_req() can not return ASC_BUSY.
-		 */
+		/* asc_build_req() can not return ASC_BUSY. */
 		if (asc_build_req(boardp, scp) == ASC_ERROR) {
 			ASC_STATS(scp->device->host, build_error);
 			return ASC_ERROR;
 		}
 
-		switch (ret = AscExeScsiQueue(asc_dvc_varp, &asc_scsi_q)) {
-		case ASC_NOERROR:
-			ASC_STATS(scp->device->host, exe_noerror);
-			/*
-			 * Increment monotonically increasing per device
-			 * successful request counter. Wrapping doesn't matter.
-			 */
-			boardp->reqcnt[scp->device->id]++;
-			ASC_DBG(1, "asc_execute_scsi_cmnd: AscExeScsiQueue(), "
-				"ASC_NOERROR\n");
-			break;
-		case ASC_BUSY:
-			ASC_STATS(scp->device->host, exe_busy);
-			break;
-		case ASC_ERROR:
-			ASC_PRINT2("asc_execute_scsi_cmnd: board %d: "
-				"AscExeScsiQueue() ASC_ERROR, err_code 0x%x\n",
-				boardp->id, asc_dvc_varp->err_code);
-			ASC_STATS(scp->device->host, exe_error);
-			scp->result = HOST_BYTE(DID_ERROR);
-			break;
-		default:
-			ASC_PRINT2("asc_execute_scsi_cmnd: board %d: "
-				"AscExeScsiQueue() unknown, err_code 0x%x\n",
-				boardp->id, asc_dvc_varp->err_code);
-			ASC_STATS(scp->device->host, exe_unknown);
-			scp->result = HOST_BYTE(DID_ERROR);
-			break;
-		}
+		ret = AscExeScsiQueue(asc_dvc, &asc_scsi_q);
+		err_code = asc_dvc->err_code;
 	} else {
-		/*
-		 * Build and execute Wide Board request.
-		 */
-		adv_dvc_varp = &boardp->dvc_var.adv_dvc_var;
+		ADV_DVC_VAR *adv_dvc = &boardp->dvc_var.adv_dvc_var;
+		ADV_SCSI_REQ_Q *adv_scsiqp;
 
-		/*
-		 * Build and get a pointer to an Adv Library request structure.
-		 *
-		 * If the request is successfully built then send it below,
-		 * otherwise return with an error.
-		 */
 		switch (adv_build_req(boardp, scp, &adv_scsiqp)) {
 		case ASC_NOERROR:
 			ASC_DBG(3, "asc_execute_scsi_cmnd: adv_build_req "
@@ -11428,35 +11374,36 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 			return ASC_ERROR;
 		}
 
-		switch (ret = AdvExeScsiQueue(adv_dvc_varp, adv_scsiqp)) {
-		case ASC_NOERROR:
-			ASC_STATS(scp->device->host, exe_noerror);
-			/*
-			 * Increment monotonically increasing per device
-			 * successful request counter. Wrapping doesn't matter.
-			 */
-			boardp->reqcnt[scp->device->id]++;
-			ASC_DBG(1, "asc_execute_scsi_cmnd: AdvExeScsiQueue(), "
-				"ASC_NOERROR\n");
-			break;
-		case ASC_BUSY:
-			ASC_STATS(scp->device->host, exe_busy);
-			break;
-		case ASC_ERROR:
-			ASC_PRINT2("asc_execute_scsi_cmnd: board %d: "
-				"AdvExeScsiQueue() ASC_ERROR, err_code 0x%x\n",
-				boardp->id, adv_dvc_varp->err_code);
-			ASC_STATS(scp->device->host, exe_error);
-			scp->result = HOST_BYTE(DID_ERROR);
-			break;
-		default:
-			ASC_PRINT2("asc_execute_scsi_cmnd: board %d: "
-				"AdvExeScsiQueue() unknown, err_code 0x%x\n",
-				boardp->id, adv_dvc_varp->err_code);
-			ASC_STATS(scp->device->host, exe_unknown);
-			scp->result = HOST_BYTE(DID_ERROR);
-			break;
-		}
+		ret = AdvExeScsiQueue(adv_dvc, adv_scsiqp);
+		err_code = adv_dvc->err_code;
+	}
+
+	switch (ret) {
+	case ASC_NOERROR:
+		ASC_STATS(scp->device->host, exe_noerror);
+		/*
+		 * Increment monotonically increasing per device
+		 * successful request counter. Wrapping doesn't matter.
+		 */
+		boardp->reqcnt[scp->device->id]++;
+		ASC_DBG(1, "asc_execute_scsi_cmnd: ExeScsiQueue(), "
+			"ASC_NOERROR\n");
+		break;
+	case ASC_BUSY:
+		ASC_STATS(scp->device->host, exe_busy);
+		break;
+	case ASC_ERROR:
+		ASC_PRINT2("asc_execute_scsi_cmnd: board %d: ExeScsiQueue() "
+			   "ASC_ERROR, err_code 0x%x\n", boardp->id, err_code);
+		ASC_STATS(scp->device->host, exe_error);
+		scp->result = HOST_BYTE(DID_ERROR);
+		break;
+	default:
+		ASC_PRINT2("asc_execute_scsi_cmnd: board %d: ExeScsiQueue() "
+			   "unknown, err_code 0x%x\n", boardp->id, err_code);
+		ASC_STATS(scp->device->host, exe_unknown);
+		scp->result = HOST_BYTE(DID_ERROR);
+		break;
 	}
 
 	ASC_DBG(1, "asc_execute_scsi_cmnd: end\n");
-- 
1.5.2.4

