From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] lpfc: Fix possible NULL pointer dereference
Date: Wed, 15 Jun 2016 15:00:08 +0200
Message-ID: <1465995608-53252-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56753 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbcFONAN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2016 09:00:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>

Check for the existance of pciob->vport before accessing it.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_sli.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 70edf21..134078f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1329,15 +1329,10 @@ lpfc_sli_ringtxcmpl_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
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
+	    piocb->vport && !(piocb->vport->load_flag & FC_UNLOADING))
+		mod_timer(&piocb->vport->els_tmofunc,
+			  jiffies +
+			  msecs_to_jiffies(1000 * (phba->fc_ratov << 1)));
 
 	return 0;
 }
-- 
1.8.5.6

