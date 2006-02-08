From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 3/22] lpfc 8.1.2 : Remove unused SLI_IOCB_HIGH_PRIORITY
Date: Wed, 08 Feb 2006 10:41:08 -0500
Message-ID: <43EA1114.3040702@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:20621 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030438AbWBHPlN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 10:41:13 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k18FfBrf011801
	for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2006 07:41:12 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Remove unused SLI_IOCB_HIGH_PRIORITY


Signed-off-by: James Smart <James.Smart@emulex.com>

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

