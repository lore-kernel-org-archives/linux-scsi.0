From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 01/17] lpfc: FLOGI failures are reported when connected to a private loop.
Date: Thu,  9 Nov 2017 17:08:18 -0800
Message-ID: <20171110010834.4542-2-jsmart2021@gmail.com>
References: <20171110010834.4542-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:53872 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755266AbdKJBIo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2017 20:08:44 -0500
Received: by mail-qk0-f194.google.com with SMTP id y23so10085685qkb.10
        for <linux-scsi@vger.kernel.org>; Thu, 09 Nov 2017 17:08:44 -0800 (PST)
In-Reply-To: <20171110010834.4542-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

When the HBA is connected to a private loop, the driver
reports FLOGI loop-open failure as functional error. This is
an expected condition.

Mark loop-open failure as a warning instead of error.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v2:
  Reworked printf. v1 printed 2 messages if not a loop open failure.
  This prints a single message if not a loop open failure. A single
  message still exists if a loop open failure if warnings enabled.
---
 drivers/scsi/lpfc/lpfc_els.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b14f7c5653cd..c81cdc637e64 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1030,30 +1030,31 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 stop_rr_fcf_flogi:
 		/* FLOGI failure */
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
-				"2858 FLOGI failure Status:x%x/x%x TMO:x%x "
-				"Data x%x x%x\n",
-				irsp->ulpStatus, irsp->un.ulpWord[4],
-				irsp->ulpTimeout, phba->hba_flag,
-				phba->fcf.fcf_flag);
+		if (!(irsp->ulpStatus == IOSTAT_LOCAL_REJECT &&
+		      ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) ==
+					IOERR_LOOP_OPEN_FAILURE)))
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+					"2858 FLOGI failure Status:x%x/x%x "
+					"TMO:x%x Data x%x x%x\n",
+					irsp->ulpStatus, irsp->un.ulpWord[4],
+					irsp->ulpTimeout, phba->hba_flag,
+					phba->fcf.fcf_flag);
 
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb))
 			goto out;
 
-		/* FLOGI failure */
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
-				 "0100 FLOGI failure Status:x%x/x%x TMO:x%x\n",
-				 irsp->ulpStatus, irsp->un.ulpWord[4],
-				 irsp->ulpTimeout);
-
-
 		/* If this is not a loop open failure, bail out */
 		if (!(irsp->ulpStatus == IOSTAT_LOCAL_REJECT &&
 		      ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) ==
 					IOERR_LOOP_OPEN_FAILURE)))
 			goto flogifail;
 
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
+				 "0150 FLOGI failure Status:x%x/x%x TMO:x%x\n",
+				 irsp->ulpStatus, irsp->un.ulpWord[4],
+				 irsp->ulpTimeout);
+
 		/* FLOGI failed, so there is no fabric */
 		spin_lock_irq(shost->host_lock);
 		vport->fc_flag &= ~(FC_FABRIC | FC_PUBLIC_LOOP);
-- 
2.13.1
