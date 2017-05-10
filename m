From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 02/15] lpfc: Fix system crash when port is reset.
Date: Wed, 10 May 2017 12:07:00 -0700
Message-ID: <20170510190713.30171-3-jsmart2021@gmail.com>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33769 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753885AbdEJTH0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2017 15:07:26 -0400
Received: by mail-qk0-f196.google.com with SMTP id o85so735589qkh.0
        for <linux-scsi@vger.kernel.org>; Wed, 10 May 2017 12:07:25 -0700 (PDT)
In-Reply-To: <20170510190713.30171-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

The driver panic when using the els_wq during port reset.

Check for NULL els_wq before dereferencing.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h         | 8 ++++++--
 drivers/scsi/lpfc/lpfc_hbadisc.c | 6 +++---
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 6d7840b096e6..62571fa9c6ad 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1228,7 +1228,11 @@ lpfc_sli_read_hs(struct lpfc_hba *phba)
 static inline struct lpfc_sli_ring *
 lpfc_phba_elsring(struct lpfc_hba *phba)
 {
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		return phba->sli4_hba.els_wq->pring;
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		if (phba->sli4_hba.els_wq)
+			return phba->sli4_hba.els_wq->pring;
+		else
+			return NULL;
+	}
 	return &phba->sli.sli3_ring[LPFC_ELS_RING];
 }
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 0482c5580331..dcc9b3858778 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -693,9 +693,9 @@ lpfc_work_done(struct lpfc_hba *phba)
 	pring = lpfc_phba_elsring(phba);
 	status = (ha_copy & (HA_RXMASK  << (4*LPFC_ELS_RING)));
 	status >>= (4*LPFC_ELS_RING);
-	if ((status & HA_RXMASK) ||
-	    (pring->flag & LPFC_DEFERRED_RING_EVENT) ||
-	    (phba->hba_flag & HBA_SP_QUEUE_EVT)) {
+	if (pring && (status & HA_RXMASK ||
+		      pring->flag & LPFC_DEFERRED_RING_EVENT ||
+		      phba->hba_flag & HBA_SP_QUEUE_EVT)) {
 		if (pring->flag & LPFC_STOP_IOCB_EVENT) {
 			pring->flag |= LPFC_DEFERRED_RING_EVENT;
 			/* Set the lpfc data pending flag */
-- 
2.11.0
