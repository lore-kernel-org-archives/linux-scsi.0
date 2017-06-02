From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 13/17] lpfc: Fix PRLI retry handling when target rejects it.
Date: Thu,  1 Jun 2017 21:07:07 -0700
Message-ID: <20170602040711.21046-14-jsmart2021@gmail.com>
References: <20170602040711.21046-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:35775 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbdFBEID (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 00:08:03 -0400
Received: by mail-qt0-f196.google.com with SMTP id r58so8205229qtb.2
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jun 2017 21:08:02 -0700 (PDT)
In-Reply-To: <20170602040711.21046-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

The nvmet driver was rejecting the initiator's PRLI because
its reg_rpi for the PLOGI was still outstanding.  The initiator
would resend the PRLI without delay and get the same answer.
The PRLI retries would exhaust causing the nvme initiator to
set the nvmet ndlp to UNMAPPED.

The driver's lpfc_els_retry handler did not have a policy for an
LS_RJT with explanation CMD_IN_PROGRESS for PRLI or NVME_PRLI.
This caused the delay to remain at 0 but retry set 1.

Fix: When the ELS response is LS_RJT, TPC and the command was PRLI
or NVME_PRLI, just set the delay to 1000 mS to get a 1 second
delay on the PRLI retry.  This was enough to allow the REG_RPI to
complete at the target.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 8e532b39ae93..a140318d6159 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3332,6 +3332,19 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		 */
 		switch (stat.un.b.lsRjtRsnCode) {
 		case LSRJT_UNABLE_TPC:
+			/* The driver has a VALID PLOGI but the rport has
+			 * rejected the PRLI - can't do it now.  Delay
+			 * for 1 second and try again - don't care about
+			 * the explanation.
+			 */
+			if (cmd == ELS_CMD_PRLI || cmd == ELS_CMD_NVMEPRLI) {
+				delay = 1000;
+				maxretry = lpfc_max_els_tries + 1;
+				retry = 1;
+				break;
+			}
+
+			/* Legacy bug fix code for targets with PLOGI delays. */
 			if (stat.un.b.lsRjtRsnCodeExp ==
 			    LSEXP_CMD_IN_PROGRESS) {
 				if (cmd == ELS_CMD_PLOGI) {
@@ -3350,9 +3363,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				retry = 1;
 				break;
 			}
-			if ((cmd == ELS_CMD_PLOGI) ||
-			    (cmd == ELS_CMD_PRLI) ||
-			    (cmd == ELS_CMD_NVMEPRLI)) {
+			if (cmd == ELS_CMD_PLOGI) {
 				delay = 1000;
 				maxretry = lpfc_max_els_tries + 1;
 				retry = 1;
-- 
2.11.0
