From: jsmart2021@gmail.com
Subject: [PATCH 05/20] lpfc: Fix crash during Hardware error recovery on SLI3 adapters
Date: Sat,  4 Mar 2017 09:30:25 -0800
Message-ID: <1488648640-5170-6-git-send-email-jsmart2021@gmail.com>
References: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36482 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752215AbdCDRa7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2017 12:30:59 -0500
Received: by mail-qk0-f193.google.com with SMTP id n141so10940199qke.3
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2017 09:30:54 -0800 (PST)
In-Reply-To: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

if REG_VPI fails, the driver was incorrectly issuing INIT_VFI
(a SLI4 command) on a SLI3 adapter.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 2d26440..d260a13 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8371,11 +8371,17 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			spin_lock_irq(shost->host_lock);
 			vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
 			spin_unlock_irq(shost->host_lock);
-			if (vport->port_type == LPFC_PHYSICAL_PORT
-				&& !(vport->fc_flag & FC_LOGO_RCVD_DID_CHNG))
-				lpfc_issue_init_vfi(vport);
-			else
+			if (mb->mbxStatus == MBX_NOT_FINISHED)
+				break;
+			if ((vport->port_type == LPFC_PHYSICAL_PORT) &&
+			    !(vport->fc_flag & FC_LOGO_RCVD_DID_CHNG)) {
+				if (phba->sli_rev == LPFC_SLI_REV4)
+					lpfc_issue_init_vfi(vport);
+				else
+					lpfc_initial_flogi(vport);
+			} else {
 				lpfc_initial_fdisc(vport);
+			}
 			break;
 		}
 	} else {
-- 
2.5.0
