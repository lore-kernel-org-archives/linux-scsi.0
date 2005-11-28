From: James.Smart@Emulex.Com
Subject: [PATCH 3/11]  lpfc 8.1.1 : Fixes for short cable pulls
Date: Mon, 28 Nov 2005 11:41:33 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C47@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:31733 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751290AbVK1Qlf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 11:41:35 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id jASGfYs3014105
	for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2005 08:41:34 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com


Fixes for short cable pulls.

Cause: Link bounces were causing discovery ELS's to be killed.
  Driver was not properly flushing ELS commands upon the subsequent
  link bounces. Thus, processing of ELS post link bounce erroneously
  assumed discovery failure and device loss.

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2005-11-24 10:07:36.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2005-11-28 10:15:37.000000000 -0500
@@ -720,6 +720,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba * ph
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
 		if ((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
 		   ((irsp->un.ulpWord[4] == IOERR_SLI_ABORTED) ||
+		   (irsp->un.ulpWord[4] == IOERR_LINK_DOWN) ||
 		   (irsp->un.ulpWord[4] == IOERR_SLI_DOWN))) {
 			disc = (ndlp->nlp_flag & NLP_NPR_2B_DISC);
 		}
@@ -869,6 +870,7 @@ lpfc_cmpl_els_prli(struct lpfc_hba * phb
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
 		if ((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
 		   ((irsp->un.ulpWord[4] == IOERR_SLI_ABORTED) ||
+		   (irsp->un.ulpWord[4] == IOERR_LINK_DOWN) ||
 		   (irsp->un.ulpWord[4] == IOERR_SLI_DOWN))) {
 			goto out;
 		}
@@ -1054,6 +1056,7 @@ lpfc_cmpl_els_adisc(struct lpfc_hba * ph
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
 		if ((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
 		   ((irsp->un.ulpWord[4] == IOERR_SLI_ABORTED) ||
+		   (irsp->un.ulpWord[4] == IOERR_LINK_DOWN) ||
 		   (irsp->un.ulpWord[4] == IOERR_SLI_DOWN))) {
 			disc = (ndlp->nlp_flag & NLP_NPR_2B_DISC);
 		}
@@ -1205,6 +1208,7 @@ lpfc_cmpl_els_logo(struct lpfc_hba * phb
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
 		if ((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
 		   ((irsp->un.ulpWord[4] == IOERR_SLI_ABORTED) ||
+		   (irsp->un.ulpWord[4] == IOERR_LINK_DOWN) ||
 		   (irsp->un.ulpWord[4] == IOERR_SLI_DOWN))) {
 			goto out;
 		}
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2005-11-28 09:44:43.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2005-11-28 10:15:37.000000000 -0500
@@ -563,6 +563,8 @@ lpfc_handle_latt(struct lpfc_hba * phba)
 
 	rc = -EIO;
 
+	/* Cleanup any outstanding ELS commands */
+	lpfc_els_flush_cmd(phba);
 
 	psli->slistat.link_event++;
 	lpfc_read_la(phba, pmb, mp);
