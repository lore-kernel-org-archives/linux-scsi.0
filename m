From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2] lpfc: Fix possible NULL pointer dereference
Date: Fri, 29 Jul 2016 15:30:56 +0200
Message-ID: <1469799056-7708-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbcG2NbB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2016 09:31:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Tyrel Datwyler <turtle.in.the.kernel@gmail.com>, James Smart <james.smart@broadcom.com>, Johannes Thumshirn <jthumshirn@suse.de>

Check for the existence of piocb->vport before accessing it.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
Changes to v1:
* Fix spelling of piocb (Tyrel)
* re-introduce the BU() assertion if piocb->vport is NULL (Tyrel)


 drivers/scsi/lpfc/lpfc_sli.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 70edf21..3d04ef1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1323,21 +1323,18 @@ lpfc_sli_ringtxcmpl_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 {
 	lockdep_assert_held(&phba->hbalock);
 
+	BUG_ON(!piocb || !piocb->vport);
+
 	list_add_tail(&piocb->list, &pring->txcmplq);
 	piocb->iocb_flag |= LPFC_IO_ON_TXCMPLQ;
 
 	if ((unlikely(pring->ringno == LPFC_ELS_RING)) &&
 	   (piocb->iocb.ulpCommand != CMD_ABORT_XRI_CN) &&
 	   (piocb->iocb.ulpCommand != CMD_CLOSE_XRI_CN) &&
-	 (!(piocb->vport->load_flag & FC_UNLOADING))) {
-		if (!piocb->vport)
-			BUG();
-		else
-			mod_timer(&piocb->vport->els_tmofunc,
-				jiffies +
-				msecs_to_jiffies(1000 * (phba->fc_ratov << 1)));
-	}
-
+	    (!(piocb->vport->load_flag & FC_UNLOADING)))
+		mod_timer(&piocb->vport->els_tmofunc,
+			  jiffies +
+			  msecs_to_jiffies(1000 * (phba->fc_ratov << 1)));
 
 	return 0;
 }
-- 
1.8.5.6

