From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 8/9] lpfc 8.1.11 :  Misc Fixes
Date: Sat, 02 Dec 2006 13:35:43 -0500
Message-ID: <1165084543.27443.29.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:57559 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1759467AbWLBQHI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Dec 2006 11:07:08 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id kB2G71ar009324
	for <linux-scsi@vger.kernel.org>; Sat, 2 Dec 2006 08:07:08 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Misc Fixes:
 - Prevent references to NULL node list element in reset routines.
 - Add missing IOCB types to switch tables
 - Reset the card on Port Error 5
 - Fix infinite loop in LUN reset

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2006-12-02 12:24:39.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2006-12-02 12:38:28.000000000 -0500
@@ -1294,6 +1294,10 @@ typedef struct {		/* FireFly BIU registe
 #define CMD_FCP_IREAD_CX        0x1B
 #define CMD_FCP_ICMND_CR        0x1C
 #define CMD_FCP_ICMND_CX        0x1D
+#define CMD_FCP_TSEND_CX        0x1F
+#define CMD_FCP_TRECEIVE_CX     0x21
+#define CMD_FCP_TRSP_CX	        0x23
+#define CMD_FCP_AUTO_TRSP_CX    0x29
 
 #define CMD_ADAPTER_MSG         0x20
 #define CMD_ADAPTER_DUMP        0x22
@@ -1320,6 +1324,9 @@ typedef struct {		/* FireFly BIU registe
 #define CMD_FCP_IREAD64_CX      0x9B
 #define CMD_FCP_ICMND64_CR      0x9C
 #define CMD_FCP_ICMND64_CX      0x9D
+#define CMD_FCP_TSEND64_CX      0x9F
+#define CMD_FCP_TRECEIVE64_CX   0xA1
+#define CMD_FCP_TRSP64_CX       0xA3
 
 #define CMD_GEN_REQUEST64_CR    0xC2
 #define CMD_GEN_REQUEST64_CX    0xC3
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2006-12-02 12:30:44.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2006-12-02 12:38:28.000000000 -0500
@@ -519,7 +519,8 @@ lpfc_handle_eratt(struct lpfc_hba * phba
 	struct lpfc_sli_ring  *pring;
 	uint32_t event_data;
 
-	if (phba->work_hs & HS_FFER6) {
+	if (phba->work_hs & HS_FFER6 ||
+	    phba->work_hs & HS_FFER5) {
 		/* Re-establishing Link */
 		lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
 				"%d:1301 Re-establishing Link "
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2006-12-02 12:07:50.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2006-12-02 12:38:28.000000000 -0500
@@ -679,6 +679,9 @@ lpfc_scsi_tgt_reset(struct lpfc_scsi_buf
 	struct lpfc_iocbq *iocbqrsp;
 	int ret;
 
+	if (!rdata->pnode)
+		return FAILED;
+
 	lpfc_cmd->rdata = rdata;
 	ret = lpfc_scsi_prep_task_mgmt_cmd(phba, lpfc_cmd, lun,
 					   FCP_TARGET_RESET);
@@ -985,20 +988,34 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 
 	lpfc_block_error_handler(cmnd);
 	spin_lock_irq(shost->host_lock);
+	loopcnt = 0;
 	/*
 	 * If target is not in a MAPPED state, delay the reset until
 	 * target is rediscovered or devloss timeout expires.
 	 */
 	while ( 1 ) {
 		if (!pnode)
-			break;
+			return FAILED;
 
 		if (pnode->nlp_state != NLP_STE_MAPPED_NODE) {
 			spin_unlock_irq(phba->host->host_lock);
 			schedule_timeout_uninterruptible(msecs_to_jiffies(500));
 			spin_lock_irq(phba->host->host_lock);
+			loopcnt++;
+			rdata = cmnd->device->hostdata;
+			if (!rdata ||
+				(loopcnt > ((phba->cfg_devloss_tmo * 2) + 1))) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
+		   			"%d:0721 LUN Reset rport failure:"
+					" cnt x%x rdata x%p\n",
+		   			phba->brd_no, loopcnt, rdata);
+				goto out;
+			}
+			pnode = rdata->pnode;
+			if (!pnode)
+				return FAILED;
 		}
-		if ((pnode) && (pnode->nlp_state == NLP_STE_MAPPED_NODE))
+		if (pnode->nlp_state == NLP_STE_MAPPED_NODE)
 			break;
 	}
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2006-12-02 11:57:08.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2006-12-02 12:38:28.000000000 -0500
@@ -117,6 +117,10 @@ lpfc_sli_iocb_cmd_type(uint8_t iocb_cmnd
 	case CMD_FCP_IREAD_CX:
 	case CMD_FCP_ICMND_CR:
 	case CMD_FCP_ICMND_CX:
+	case CMD_FCP_TSEND_CX:
+	case CMD_FCP_TRSP_CX:
+	case CMD_FCP_TRECEIVE_CX:
+	case CMD_FCP_AUTO_TRSP_CX:
 	case CMD_ADAPTER_MSG:
 	case CMD_ADAPTER_DUMP:
 	case CMD_XMIT_SEQUENCE64_CR:
@@ -131,6 +135,9 @@ lpfc_sli_iocb_cmd_type(uint8_t iocb_cmnd
 	case CMD_FCP_IREAD64_CX:
 	case CMD_FCP_ICMND64_CR:
 	case CMD_FCP_ICMND64_CX:
+	case CMD_FCP_TSEND64_CX:
+	case CMD_FCP_TRSP64_CX:
+	case CMD_FCP_TRECEIVE64_CX:
 	case CMD_GEN_REQUEST64_CR:
 	case CMD_GEN_REQUEST64_CX:
 	case CMD_XMIT_ELS_RSP64_CX:


