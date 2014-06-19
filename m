From: bradley.grove@gmail.com
Subject: [PATCH V2] pm80xx: Fix hibernation issue
Date: Thu, 19 Jun 2014 11:13:20 -0400
Message-ID: <1403190800-15022-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:52481 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534AbaFSPOR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2014 11:14:17 -0400
Received: by mail-qc0-f177.google.com with SMTP id r5so2275057qcx.22
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jun 2014 08:14:16 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bradley Grove <bgrove@attotech.com>, JBottomley@parallels.com, xjtuwjp@gmail.com, ebrown@attotech.com, pcullen@attotech.com

From: Bradley Grove <bgrove@attotech.com>

During hibernation, the HBA firmware may lose power and forget the device
id info.   This causes the HBA to reject IO upon resume.   The fix is
to call the libsas power management routines to make the domain device
forgetful.

This fixes bug 76681: https://bugzilla.kernel.org/show_bug.cgi?id=76681

Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index c4f31b21..86cf03a 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -957,6 +957,7 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	int  i, j;
 	u32 device_state;
 	pm8001_ha = sha->lldd_ha;
+	sas_suspend_ha(sha);
 	flush_workqueue(pm8001_wq);
 	scsi_block_requests(pm8001_ha->shost);
 	if (!pdev->pm_cap) {
@@ -1006,6 +1007,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	int rc;
 	u8 i = 0, j;
 	u32 device_state;
+	DECLARE_COMPLETION_ONSTACK(completion);
 	pm8001_ha = sha->lldd_ha;
 	device_state = pdev->current_state;
 
@@ -1026,7 +1028,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	rc = pci_go_44(pdev);
 	if (rc)
 		goto err_out_disable;
-
+	sas_prep_resume_ha(sha);
 	/* chip soft rst only for spc */
 	if (pm8001_ha->chip_id == chip_8001) {
 		PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
@@ -1058,7 +1060,13 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 		for (i = 1; i < pm8001_ha->number_of_intr; i++)
 			PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, i);
 	}
-	scsi_unblock_requests(pm8001_ha->shost);
+	pm8001_ha->flags = PM8001F_RUN_TIME;
+	for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
+		pm8001_ha->phy[i].enable_completion = &completion;
+		PM8001_CHIP_DISP->phy_start_req(pm8001_ha, i);
+		wait_for_completion(&completion);
+	}
+	sas_resume_ha(sha);
 	return 0;
 
 err_out_disable:
-- 
1.9.3

