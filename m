From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 15/20] lpfc: Fix nvme target failure after 2nd adapter reset
Date: Wed, 23 Aug 2017 16:55:44 -0700
Message-ID: <20170823235549.2883-16-jsmart2021@gmail.com>
References: <20170823235549.2883-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34386 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751936AbdHWX4b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 19:56:31 -0400
Received: by mail-wm0-f68.google.com with SMTP id 69so1074791wmh.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 16:56:30 -0700 (PDT)
In-Reply-To: <20170823235549.2883-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

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
v3:
  rework indentation per review comment
---
 drivers/scsi/lpfc/lpfc_init.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c22b88a08c1b..b21ac2bb0dd3 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3047,7 +3047,7 @@ lpfc_online(struct lpfc_hba *phba)
 {
 	struct lpfc_vport *vport;
 	struct lpfc_vport **vports;
-	int i;
+	int i, error = 0;
 	bool vpis_cleared = false;
 
 	if (!phba)
@@ -3071,6 +3071,18 @@ lpfc_online(struct lpfc_hba *phba)
 		if (!phba->sli4_hba.max_cfg_param.vpi_used)
 			vpis_cleared = true;
 		spin_unlock_irq(&phba->hbalock);
+
+		/* Reestablish the local initiator port.
+		 * The offline process destroyed the previous lport.
+		 */
+		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME &&
+				!phba->nvmet_support) {
+			error = lpfc_nvme_create_localport(phba->pport);
+			if (error)
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"6132 NVME restore reg failed "
+					"on nvmei error x%x\n", error);
+		}
 	} else {
 		lpfc_sli_queue_init(phba);
 		if (lpfc_sli_hba_setup(phba)) {	/* Initialize SLI2/SLI3 HBA */
-- 
2.13.1
