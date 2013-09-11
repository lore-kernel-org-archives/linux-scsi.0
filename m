From: Jon Mason <jdmason@kudzu.us>
Subject: [PATCH RESUBMIT 1/1] lpfc: remove unnecessary read of PCI_CAP_ID_EXP
Date: Wed, 11 Sep 2013 15:38:13 -0700
Message-ID: <1378939093-17274-2-git-send-email-jdmason@kudzu.us>
References: <1378939093-17274-1-git-send-email-jdmason@kudzu.us>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:46300 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab3IKWhC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Sep 2013 18:37:02 -0400
Received: by mail-pa0-f48.google.com with SMTP id kp13so236707pab.21
        for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2013 15:37:01 -0700 (PDT)
In-Reply-To: <1378939093-17274-1-git-send-email-jdmason@kudzu.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>

The PCIE capability offset is saved during PCI bus walking.  It will
remove an unnecessary search in the PCI configuration space if this
value is referenced instead of reacquiring it.  Also, pci_is_pcie is a
better way of determining if the device is PCIE or not (as it uses the
same saved PCIE capability offset).

Signed-off-by: Jon Mason <jdmason@kudzu.us>
Acked-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 501147c..4d0f570 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4545,7 +4545,7 @@ lpfc_enable_pci_dev(struct lpfc_hba *phba)
 	pci_save_state(pdev);
 
 	/* PCIe EEH recovery on powerpc platforms needs fundamental reset */
-	if (pci_find_capability(pdev, PCI_CAP_ID_EXP))
+	if (pci_is_pcie(pdev))
 		pdev->needs_freset = 1;
 
 	return 0;
-- 
1.7.10.4

