From: James.Smart@Emulex.Com
Subject: [PATCH 2 of 12] Update Emulex lpfc driver to rev 8.0.29
Date: Sat, 25 Jun 2005 10:34:04 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F4147@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:37310 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261238AbVFYOeG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jun 2005 10:34:06 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j5PEY59P008165
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jun 2005 07:34:06 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix issue where all hosts log nodev message for other initiators

Fix issue where all hosts connected to SAN get spammed with nodev
message when other initiators go away.  Display nodev message only
when FC targets go away.  However this behavior will be overridden if
LOG_DISCOVERY is set.

Signed-off-by: James Smart <James.Smart@emulex.com>

---

 scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_hbadisc.c |   24 ++++++----
 1 files changed, 16 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_hbadisc.c~nodevmsg drivers/scsi/lpfc/lpfc_hbadisc.c
--- scsi-misc-2.6-20050620/drivers/scsi/lpfc/lpfc_hbadisc.c~nodevmsg	2005-06-25 09:41:51.000000000 -0400
+++ scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_hbadisc.c	2005-06-25 09:41:51.000000000 -0400
@@ -61,14 +61,7 @@ static void lpfc_disc_timeout_handler(st
 static void
 lpfc_process_nodev_timeout(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
-	if (!(ndlp->nlp_type & NLP_FABRIC)) {
-		/* Nodev timeout on NPort <nlp_DID> */
-		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
-			"%d:0203 Nodev timeout on NPort x%x "
-			"Data: x%x x%x x%x\n",
-			phba->brd_no, ndlp->nlp_DID, ndlp->nlp_flag,
-			ndlp->nlp_state, ndlp->nlp_rpi);
-	}
+	int warn_on = 0;
 
 	spin_lock_irq(phba->host->host_lock);
 	if (!(ndlp->nlp_flag & NLP_NODEV_TMO)) {
@@ -79,12 +72,27 @@ lpfc_process_nodev_timeout(struct lpfc_h
 	ndlp->nlp_flag &= ~NLP_NODEV_TMO;
 
 	if (ndlp->nlp_sid != NLP_NO_SID) {
+		warn_on = 1;
 		/* flush the target */
 		lpfc_sli_abort_iocb(phba, &phba->sli.ring[phba->sli.fcp_ring],
 			ndlp->nlp_sid, 0, 0, LPFC_CTX_TGT);
 	}
 	spin_unlock_irq(phba->host->host_lock);
 
+	if (warn_on) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
+				"%d:0203 Nodev timeout on NPort x%x "
+				"Data: x%x x%x x%x\n",
+				phba->brd_no, ndlp->nlp_DID, ndlp->nlp_flag,
+				ndlp->nlp_state, ndlp->nlp_rpi);
+	} else {
+		lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
+				"%d:0204 Nodev timeout on NPort x%x "
+				"Data: x%x x%x x%x\n",
+				phba->brd_no, ndlp->nlp_DID, ndlp->nlp_flag,
+				ndlp->nlp_state, ndlp->nlp_rpi);
+	}
+
 	lpfc_disc_state_machine(phba, ndlp, NULL, NLP_EVT_DEVICE_RM);
 	return;
 }
_
