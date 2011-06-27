From: Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 03/19] lpfc: remove unnecessary read of PCI_CAP_ID_EXP
Date: Mon, 27 Jun 2011 12:39:06 -0500
Message-ID: <1309196346-15749-1-git-send-email-jdmason@kudzu.us>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37202 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab1F0RjL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2011 13:39:11 -0400
Received: by pwj7 with SMTP id 7so3081367pwj.19
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2011 10:39:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org

The PCIE capability offset is saved during PCI bus walking.  It will
remove an unnecessary search in the PCI configuration space if this
value is referenced instead of reacquiring it.  Also, pci_is_pcie is a
better way of determining if the device is PCIE or not (as it uses the
same saved PCIE capability offset).

Signed-off-by: Jon Mason <jdmason@kudzu.us>
---
 drivers/scsi/lpfc/lpfc_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 148b98d..9000ad0 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3970,7 +3970,7 @@ lpfc_enable_pci_dev(struct lpfc_hba *phba)
 	pci_save_state(pdev);
 
 	/* PCIe EEH recovery on powerpc platforms needs fundamental reset */
-	if (pci_find_capability(pdev, PCI_CAP_ID_EXP))
+	if (pci_is_pcie(pdev))
 		pdev->needs_freset = 1;
 
 	return 0;
-- 
1.7.5.4

