From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 3/6] lpfc 8.1.4 : Fixed a timer panic due to timer firing
	after freeing ndlp
Date: Tue, 07 Mar 2006 15:04:06 -0500
Message-ID: <1141761847.25430.17.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:38092 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932307AbWCGUEL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Mar 2006 15:04:11 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k27K49rf021508
	for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2006 12:04:10 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fixed a timer panic due to timer firing after freeing ndlp


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -68,6 +68,15 @@ lpfc_process_nodev_timeout(struct lpfc_h
 		return;
 	}
 
+	/*
+	 * If a discovery event readded nodev_timer after timer
+	 * firing and before processing the timer, cancel the
+	 * nlp_tmofunc.
+	 */
+	spin_unlock_irq(phba->host->host_lock);
+	del_timer_sync(&ndlp->nlp_tmofunc);
+	spin_lock_irq(phba->host->host_lock);
+
 	ndlp->nlp_flag &= ~NLP_NODEV_TMO;
 
 	if (ndlp->nlp_sid != NLP_NO_SID) {
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1523,6 +1523,12 @@ lpfc_els_retry_delay_handler(struct lpfc
 
 	ndlp->nlp_flag &= ~NLP_DELAY_TMO;
 	spin_unlock_irq(phba->host->host_lock);
+	/*
+	 * If a discovery event readded nlp_delayfunc after timer
+	 * firing and before processing the timer, cancel the
+	 * nlp_delayfunc.
+	 */
+	del_timer_sync(&ndlp->nlp_delayfunc);
 	retry = ndlp->nlp_retry;
 
 	switch (cmd) {


