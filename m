From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 12/14] lpfc: The linux driver does not reinitiate
 discovery after a failed FLOGI
Date: Mon, 31 Aug 2015 16:48:19 -0400
Message-ID: <55e4bd93.oKGQ536ViqN6PeJn%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:32887 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbbHaUsg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 16:48:36 -0400
Received: by qgp105 with SMTP id 105so21787880qgp.0
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2015 13:48:35 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by smtp.gmail.com with ESMTPSA id m18sm9508071qgd.24.2015.08.31.13.48.34
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 31 Aug 2015 13:48:34 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The linux driver does not reinitiate discovery after a failed FLOGI

Forgot to clear FCF Discovery in-progress flag upon FLOGI failures.
Thus we didn't restart FLOGI.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 759fa9b..3feeb44 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1026,9 +1026,11 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 stop_rr_fcf_flogi:
 		/* FLOGI failure */
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
-				"2858 FLOGI failure Status:x%x/x%x TMO:x%x\n",
+				"2858 FLOGI failure Status:x%x/x%x TMO:x%x "
+				"Data x%x x%x\n",
 				irsp->ulpStatus, irsp->un.ulpWord[4],
-				irsp->ulpTimeout);
+				irsp->ulpTimeout, phba->hba_flag,
+				phba->fcf.fcf_flag);
 
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb))
@@ -1152,6 +1154,9 @@ stop_rr_fcf_flogi:
 	}
 
 flogifail:
+	spin_lock_irq(&phba->hbalock);
+	phba->fcf.fcf_flag &= ~FCF_DISCOVERY;
+	spin_unlock_irq(&phba->hbalock);
 	lpfc_nlp_put(ndlp);
 
 	if (!lpfc_error_lost_link(irsp)) {
-- 
1.7.11.7

