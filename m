From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 15/20] lpfc: Fix nvme target failure after 2nd adapter reset
Date: Fri,  4 Aug 2017 17:47:26 -0700
Message-ID: <20170805004731.1335-16-jsmart2021@gmail.com>
References: <20170805004731.1335-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33585 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752684AbdHEAsI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 20:48:08 -0400
Received: by mail-pf0-f194.google.com with SMTP id c65so3209614pfl.0
        for <linux-scsi@vger.kernel.org>; Fri, 04 Aug 2017 17:48:08 -0700 (PDT)
In-Reply-To: <20170805004731.1335-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

Fix nvme target failure after 2nd adapter reset

The nonrecovery occurred because the lpfc nvme initiator
function did not reestablish its localport creation with the nvme
host transport in lpfc_oneline.  Because of that, an NVME rport
binding could not take place.

Corrected by recreating the localport in the adapter reset recovery
routine.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 897eb62ed4e6..659662777b65 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3048,7 +3048,7 @@ lpfc_online(struct lpfc_hba *phba)
 {
 	struct lpfc_vport *vport;
 	struct lpfc_vport **vports;
-	int i;
+	int i, error = 0;
 	bool vpis_cleared = false;
 
 	if (!phba)
@@ -3072,6 +3072,22 @@ lpfc_online(struct lpfc_hba *phba)
 		if (!phba->sli4_hba.max_cfg_param.vpi_used)
 			vpis_cleared = true;
 		spin_unlock_irq(&phba->hbalock);
+
+		/* Reestablish the local initiator port.
+		 * The offline process destroyed the previous lport.
+		 */
+		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
+			if (!phba->nvmet_support) {
+				error = lpfc_nvme_create_localport(phba->pport);
+				if (error) {
+					lpfc_printf_log(phba, KERN_ERR,
+							LOG_INIT,
+							"6132 NVME restore reg "
+							"failed on nvmei error "
+							"x%x\n", error);
+				}
+			}
+		}
 	} else {
 		lpfc_sli_queue_init(phba);
 		if (lpfc_sli_hba_setup(phba)) {	/* Initialize SLI2/SLI3 HBA */
-- 
2.13.1
