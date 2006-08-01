From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 5/6] lpfc 8.1.7 : ID String and Message fixes
Date: Tue, 01 Aug 2006 07:34:08 -0400
Message-ID: <1154432048.18162.16.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:2761 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S932664AbWHALeN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2006 07:34:13 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k71BYBj1000898
	for <linux-scsi@vger.kernel.org>; Tue, 1 Aug 2006 04:34:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


ID String and Message fixes
 - Fix switch symbolic name registration to match cross-OS values
 - Replace printk's with more standard lpfc_printf_log calls
 - Make all lpfc_printf_log message numbers unique


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2006-08-01 07:13:49.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2006-08-01 07:14:21.000000000 -0400
@@ -482,7 +482,7 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba 
 		if (CTrsp->CommandResponse.bits.CmdRsp ==
 		    be16_to_cpu(SLI_CT_RESPONSE_FS_ACC)) {
 			lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
-					"%d:0239 NameServer Rsp "
+					"%d:0208 NameServer Rsp "
 					"Data: x%x\n",
 					phba->brd_no,
 					phba->fc_flag);
@@ -589,13 +589,9 @@ lpfc_get_hba_sym_node_name(struct lpfc_h
 
 	lpfc_decode_firmware_rev(phba, fwrev, 0);
 
-	if (phba->Port[0]) {
-		sprintf(symbp, "Emulex %s Port %s FV%s DV%s", phba->ModelName,
-			phba->Port, fwrev, lpfc_release_version);
-	} else {
-		sprintf(symbp, "Emulex %s FV%s DV%s", phba->ModelName,
-			fwrev, lpfc_release_version);
-	}
+	sprintf(symbp, "Emulex %s FV%s DV%s", phba->ModelName,
+		fwrev, lpfc_release_version);
+	return;
 }
 
 /*
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2006-07-31 10:41:15.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2006-08-01 07:14:21.000000000 -0400
@@ -2839,7 +2839,7 @@ lpfc_els_rsp_rps_acc(struct lpfc_hba * p
 
 	/* Xmit ELS RPS ACC response tag <ulpIoTag> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"%d:0128 Xmit ELS RPS ACC response tag x%x "
+			"%d:0118 Xmit ELS RPS ACC response tag x%x "
 			"Data: x%x x%x x%x x%x x%x\n",
 			phba->brd_no,
 			elsiocb->iocb.ulpIoTag,
@@ -2948,7 +2948,7 @@ lpfc_els_rsp_rpl_acc(struct lpfc_hba * p
 
 	/* Xmit ELS RPL ACC response tag <ulpIoTag> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"%d:0128 Xmit ELS RPL ACC response tag x%x "
+			"%d:0120 Xmit ELS RPL ACC response tag x%x "
 			"Data: x%x x%x x%x x%x x%x\n",
 			phba->brd_no,
 			elsiocb->iocb.ulpIoTag,
@@ -3109,7 +3109,7 @@ lpfc_els_rcv_fan(struct lpfc_hba * phba,
 	struct lpfc_nodelist *ndlp, *next_ndlp;
 
 	/* FAN received */
-	lpfc_printf_log(phba, KERN_INFO, LOG_ELS, "%d:265 FAN received\n",
+	lpfc_printf_log(phba, KERN_INFO, LOG_ELS, "%d:0265 FAN received\n",
 								phba->brd_no);
 
 	icmd = &cmdiocb->iocb;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2006-07-31 10:41:15.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2006-08-01 07:14:21.000000000 -0400
@@ -1782,7 +1782,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 				/* LOG change to REGLOGIN */
 				/* FIND node DID reglogin */
 				lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
-						"%d:0931 FIND node DID reglogin"
+						"%d:0901 FIND node DID reglogin"
 						" Data: x%p x%x x%x x%x\n",
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
@@ -1805,7 +1805,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 				/* LOG change to PRLI */
 				/* FIND node DID prli */
 				lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
-						"%d:0931 FIND node DID prli "
+						"%d:0902 FIND node DID prli "
 						"Data: x%p x%x x%x x%x\n",
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
@@ -1828,7 +1828,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 				/* LOG change to NPR */
 				/* FIND node DID npr */
 				lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
-						"%d:0931 FIND node DID npr "
+						"%d:0903 FIND node DID npr "
 						"Data: x%p x%x x%x x%x\n",
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
@@ -1851,7 +1851,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 				/* LOG change to UNUSED */
 				/* FIND node DID unused */
 				lpfc_printf_log(phba, KERN_INFO, LOG_NODE,
-						"%d:0931 FIND node DID unused "
+						"%d:0905 FIND node DID unused "
 						"Data: x%p x%x x%x x%x\n",
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
@@ -2335,7 +2335,7 @@ lpfc_disc_timeout_handler(struct lpfc_hb
 		initlinkmbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 		if (!initlinkmbox) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
-					"%d:0226 Device Discovery "
+					"%d:0206 Device Discovery "
 					"completion error\n",
 					phba->brd_no);
 			phba->hba_state = LPFC_HBA_ERROR;
@@ -2365,7 +2365,7 @@ lpfc_disc_timeout_handler(struct lpfc_hb
 		if (!clearlambox) {
 			clrlaerr = 1;
 			lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
-					"%d:0226 Device Discovery "
+					"%d:0207 Device Discovery "
 					"completion error\n",
 					phba->brd_no);
 			phba->hba_state = LPFC_HBA_ERROR;
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2006-07-31 10:41:15.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2006-08-01 07:14:21.000000000 -0400
@@ -179,7 +179,7 @@ lpfc_els_abort(struct lpfc_hba * phba, s
 
 	/* Abort outstanding I/O on NPort <nlp_DID> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
-			"%d:0201 Abort outstanding I/O on NPort x%x "
+			"%d:0205 Abort outstanding I/O on NPort x%x "
 			"Data: x%x x%x x%x\n",
 			phba->brd_no, ndlp->nlp_DID, ndlp->nlp_flag,
 			ndlp->nlp_state, ndlp->nlp_rpi);
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2006-07-31 10:41:15.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2006-08-01 07:14:21.000000000 -0400
@@ -1104,7 +1104,7 @@ lpfc_reset_bus_handler(struct scsi_cmnd 
 					  ndlp->rport->dd_data);
 		if (ret != SUCCESS) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
-				"%d:0713 Bus Reset on target %d failed\n",
+				"%d:0700 Bus Reset on target %d failed\n",
 				phba->brd_no, i);
 			err_count++;
 		}
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2006-08-01 07:13:49.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2006-08-01 07:14:21.000000000 -0400
@@ -970,9 +970,11 @@ void lpfc_sli_poll_fcp_ring(struct lpfc_
 			 * resources need to be recovered.
 			 */
 			if (unlikely(irsp->ulpCommand == CMD_XRI_ABORTED_CX)) {
-				printk(KERN_INFO "%s: IOCB cmd 0x%x processed."
-				       " Skipping completion\n", __FUNCTION__,
-				       irsp->ulpCommand);
+				lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+						"%d:0314 IOCB cmd 0x%x"
+						" processed. Skipping"
+						" completion", phba->brd_no,
+						irsp->ulpCommand);
 				break;
 			}
 
@@ -1105,7 +1107,7 @@ lpfc_sli_handle_fast_ring_event(struct l
 		if (unlikely(irsp->ulpStatus)) {
 			/* Rsp ring <ringno> error: IOCB */
 			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
-				"%d:0326 Rsp Ring %d error: IOCB Data: "
+				"%d:0336 Rsp Ring %d error: IOCB Data: "
 				"x%x x%x x%x x%x x%x x%x x%x x%x\n",
 				phba->brd_no, pring->ringno,
 				irsp->un.ulpWord[0], irsp->un.ulpWord[1],
@@ -1123,9 +1125,11 @@ lpfc_sli_handle_fast_ring_event(struct l
 			 * resources need to be recovered.
 			 */
 			if (unlikely(irsp->ulpCommand == CMD_XRI_ABORTED_CX)) {
-				printk(KERN_INFO "%s: IOCB cmd 0x%x processed. "
-				       "Skipping completion\n", __FUNCTION__,
-				       irsp->ulpCommand);
+				lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+						"%d:0333 IOCB cmd 0x%x"
+						" processed. Skipping"
+						" completion\n", phba->brd_no,
+						irsp->ulpCommand);
 				break;
 			}
 
@@ -1156,7 +1160,7 @@ lpfc_sli_handle_fast_ring_event(struct l
 			} else {
 				/* Unknown IOCB command */
 				lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-					"%d:0321 Unknown IOCB command "
+					"%d:0334 Unknown IOCB command "
 					"Data: x%x, x%x x%x x%x x%x\n",
 					phba->brd_no, type, irsp->ulpCommand,
 					irsp->ulpStatus, irsp->ulpIoTag,
@@ -1239,7 +1243,7 @@ lpfc_sli_handle_slow_ring_event(struct l
 		lpfc_printf_log(phba,
 				KERN_ERR,
 				LOG_SLI,
-				"%d:0312 Ring %d handler: portRspPut %d "
+				"%d:0303 Ring %d handler: portRspPut %d "
 				"is bigger then rsp ring %d\n",
 				phba->brd_no,
 				pring->ringno, portRspPut, portRspMax);
@@ -1384,7 +1388,7 @@ lpfc_sli_handle_slow_ring_event(struct l
 					lpfc_printf_log(phba,
 						KERN_ERR,
 						LOG_SLI,
-						"%d:0321 Unknown IOCB command "
+						"%d:0335 Unknown IOCB command "
 						"Data: x%x x%x x%x x%x\n",
 						phba->brd_no,
 						irsp->ulpCommand,
@@ -1759,7 +1763,7 @@ lpfc_sli_brdrestart(struct lpfc_hba * ph
 
 	/* Restart HBA */
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
-			"%d:0328 Restart HBA Data: x%x x%x\n", phba->brd_no,
+			"%d:0337 Restart HBA Data: x%x x%x\n", phba->brd_no,
 			phba->hba_state, psli->sli_flag);
 
 	word0 = 0;
@@ -3016,7 +3020,7 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 
 		if (timeleft == 0) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-					"%d:0329 IOCB wait timeout error - no "
+					"%d:0338 IOCB wait timeout error - no "
 					"wake response Data x%x\n",
 					phba->brd_no, timeout);
 			retval = IOCB_TIMEDOUT;


