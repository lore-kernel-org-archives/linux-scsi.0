From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 3/22] lpfc 8.1.2: Remove unused SLI_IOCB_HIGH_PRIORITY
Date: Tue, 28 Feb 2006 19:25:13 -0500
Message-ID: <20060301002513.GA15372@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:41894 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S932734AbWCAAZP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:15 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210PDD2015378
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:13 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PDUF015377
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:13 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove unused SLI_IOCB_HIGH_PRIORITY

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -61,7 +61,6 @@ struct lpfc_iocbq {
 };
 
 #define SLI_IOCB_RET_IOCB      1	/* Return IOCB if cmd ring full */
-#define SLI_IOCB_HIGH_PRIORITY 2	/* High priority command */
 
 #define IOCB_SUCCESS        0
 #define IOCB_BUSY           1
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2237,16 +2237,6 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phb
 		   !(phba->sli.sli_flag & LPFC_PROCESS_LA)))
 		goto iocb_busy;
 
-	/*
-	 * Check to see if this is a high priority command.
-	 * If so bypass tx queue processing.
-	 */
-	if (unlikely((flag & SLI_IOCB_HIGH_PRIORITY) &&
-		     (iocb = lpfc_sli_next_iocb_slot(phba, pring)))) {
-		lpfc_sli_submit_iocb(phba, pring, iocb, piocb);
-		piocb = NULL;
-	}
-
 	while ((iocb = lpfc_sli_next_iocb_slot(phba, pring)) &&
 	       (nextiocb = lpfc_sli_next_iocb(phba, pring, &piocb)))
 		lpfc_sli_submit_iocb(phba, pring, iocb, nextiocb);
