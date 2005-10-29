From: James.Smart@Emulex.Com
Subject: [PATCH 1/15]  lpfc 8.1.0 : Cleanup code in lpfc_get_stats().
Date: Fri, 28 Oct 2005 20:28:56 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276A50@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:61136 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750846AbVJ2A26 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 20:28:58 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j9T0SvDp018491
	for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2005 17:28:57 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Cleanup code in lpfc_get_stats().

Fix: Cleanup white spaces in argument calls & initializations, prune
if statements, remove casting and remove redundant if checks.


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -229,7 +229,7 @@ lpfc_issue_lip (struct class_device *cde
 	if (mbxstatus == MBX_TIMEOUT)
 		pmboxq->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 	else
-		mempool_free( pmboxq, phba->mbox_mem_pool);
+		mempool_free(pmboxq, phba->mbox_mem_pool);
 
 	if (mbxstatus == MBXERR_ERROR)
 		return -EIO;
@@ -992,7 +992,7 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	struct fc_host_statistics *hs = &phba->link_stats;
 	LPFC_MBOXQ_t *pmboxq;
 	MAILBOX_t *pmb;
-	int rc=0;
+	int rc = 0;
 
 	pmboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!pmboxq)
@@ -1005,18 +1005,16 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	pmboxq->context1 = NULL;
 
 	if ((phba->fc_flag & FC_OFFLINE_MODE) ||
-	    (!(psli->sli_flag & LPFC_SLI2_ACTIVE))){
+		(!(psli->sli_flag & LPFC_SLI2_ACTIVE)))
 		rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_POLL);
-	} else
+	else
 		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
 
 	if (rc != MBX_SUCCESS) {
-		if (pmboxq) {
-			if (rc == MBX_TIMEOUT)
-				pmboxq->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-			else
-				mempool_free( pmboxq, phba->mbox_mem_pool);
-		}
+		if (rc == MBX_TIMEOUT)
+			pmboxq->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+		else
+			mempool_free(pmboxq, phba->mbox_mem_pool);
 		return NULL;
 	}
 
@@ -1027,24 +1025,22 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	hs->rx_frames = pmb->un.varRdStatus.rcvFrameCnt;
 	hs->rx_words = (pmb->un.varRdStatus.rcvByteCnt * 256);
 
-	memset((void *)pmboxq, 0, sizeof (LPFC_MBOXQ_t));
+	memset(pmboxq, 0, sizeof (LPFC_MBOXQ_t));
 	pmb->mbxCommand = MBX_READ_LNK_STAT;
 	pmb->mbxOwner = OWN_HOST;
 	pmboxq->context1 = NULL;
 
 	if ((phba->fc_flag & FC_OFFLINE_MODE) ||
-	    (!(psli->sli_flag & LPFC_SLI2_ACTIVE))) {
+	    (!(psli->sli_flag & LPFC_SLI2_ACTIVE)))
 		rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_POLL);
-	} else
+	else
 		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
 
 	if (rc != MBX_SUCCESS) {
-		if (pmboxq) {
-			if (rc == MBX_TIMEOUT)
-				pmboxq->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-			else
-				mempool_free( pmboxq, phba->mbox_mem_pool);
-		}
+		if (rc == MBX_TIMEOUT)
+			pmboxq->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+		else
+			mempool_free( pmboxq, phba->mbox_mem_pool);
 		return NULL;
 	}
 
