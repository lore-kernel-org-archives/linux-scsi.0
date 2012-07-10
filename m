From: Jon Mason <jdmason@kudzu.us>
Subject: [PATCH RESUBMIT 3/3] lpfc: remove unnecessary read of PCI_CAP_ID_EXP
Date: Tue, 10 Jul 2012 14:57:57 -0700
Message-ID: <1341957477-30946-4-git-send-email-jdmason@kudzu.us>
References: <1341957477-30946-1-git-send-email-jdmason@kudzu.us>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63114 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab2GJV5p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jul 2012 17:57:45 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so887639pbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jul 2012 14:57:45 -0700 (PDT)
In-Reply-To: <1341957477-30946-1-git-send-email-jdmason@kudzu.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>

The PCIE capability offset is saved during PCI bus walking.  It will
remove an unnecessary search in the PCI configuration space if this
value is referenced instead of reacquiring it.  Also, pci_is_pcie is a
better way of determining if the device is PCIE or not (as it uses the
same saved PCIE capability offset).

Signed-off-by: Jon Mason <jdmason@kudzu.us>
Cc: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 411ed48..f30b3d2 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4253,7 +4253,7 @@ lpfc_enable_pci_dev(struct lpfc_hba *phba)
 	pci_save_state(pdev);
 
 	/* PCIe EEH recovery on powerpc platforms needs fundamental reset */
-	if (pci_find_capability(pdev, PCI_CAP_ID_EXP))
+	if (pci_is_pcie(pdev))
 		pdev->needs_freset = 1;
 
 	return 0;
-- 
1.7.9.5

