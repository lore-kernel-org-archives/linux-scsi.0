From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 03/19] lpfc: move placement of target destroy on driver detach
Date: Wed, 24 Jan 2018 14:45:32 -0800
Message-ID: <20180124224548.9530-4-jsmart2021@gmail.com>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:32863 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933026AbeAXWqC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jan 2018 17:46:02 -0500
Received: by mail-qt0-f195.google.com with SMTP id d8so14699593qtm.0
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2018 14:46:01 -0800 (PST)
In-Reply-To: <20180124224548.9530-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Ensure nvme localports/targetports are torn down before
dismantling the adapter sli interface on driver detachment.
This aids leaving interfaces live while nvme may be making
callbacks to abort it.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 5b96bf0d3331..851d4e889042 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11503,13 +11503,6 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 	/* Remove FC host and then SCSI host with the physical port */
 	fc_remove_host(shost);
 	scsi_remove_host(shost);
-	/*
-	 * Bring down the SLI Layer. This step disables all interrupts,
-	 * clears the rings, discards all mailbox commands, and resets
-	 * the HBA FCoE function.
-	 */
-	lpfc_debugfs_terminate(vport);
-	lpfc_sli4_hba_unset(phba);
 
 	/* Perform ndlp cleanup on the physical port.  The nvme and nvmet
 	 * localports are destroyed after to cleanup all transport memory.
@@ -11518,6 +11511,13 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 	lpfc_nvmet_destroy_targetport(phba);
 	lpfc_nvme_destroy_localport(vport);
 
+	/*
+	 * Bring down the SLI Layer. This step disables all interrupts,
+	 * clears the rings, discards all mailbox commands, and resets
+	 * the HBA FCoE function.
+	 */
+	lpfc_debugfs_terminate(vport);
+	lpfc_sli4_hba_unset(phba);
 
 	lpfc_stop_hba_timers(phba);
 	spin_lock_irq(&phba->hbalock);
-- 
2.13.1
