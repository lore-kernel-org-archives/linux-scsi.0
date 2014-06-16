From: bradley.grove@gmail.com
Subject: [PATCH] pm80xx: Fix hibernation issue
Date: Mon, 16 Jun 2014 15:30:11 -0400
Message-ID: <1402947011-3642-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:48460 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaFPTa0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jun 2014 15:30:26 -0400
Received: by mail-qa0-f43.google.com with SMTP id k15so8148186qaq.30
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2014 12:30:26 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, xjtuwjp@gmail.com, ebrown@attotech.com, pcullen@attotech.com, Bradley Grove <bgrove@attotech.com>

From: Bradley Grove <bgrove@attotech.com>

During hibernation, the HBA firmware may lose power and forget the device
id info.   This causes the HBA to reject IO upon resume.   The fix is
to call the libsas power management routines to make the domain device
forgetful.

This patch also changes the value of pm8001_flags during resume to allow
completions to work.

This fixes bug 76681: https://bugzilla.kernel.org/show_bug.cgi?id=76681

Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index c4f31b21..9f51a1f 100644
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
@@ -1026,7 +1027,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	rc = pci_go_44(pdev);
 	if (rc)
 		goto err_out_disable;
-
+	sas_prep_resume_ha(sha);
 	/* chip soft rst only for spc */
 	if (pm8001_ha->chip_id == chip_8001) {
 		PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
@@ -1058,7 +1059,12 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 		for (i = 1; i < pm8001_ha->number_of_intr; i++)
 			PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, i);
 	}
+	pm8001_ha->flags = PM8001F_INIT_TIME;
 	scsi_unblock_requests(pm8001_ha->shost);
+	pm8001_scan_start(pm8001_ha->shost);
+	msleep(100);
+	sas_resume_ha(sha);
+	pm8001_ha->flags = PM8001F_RUN_TIME;
 	return 0;
 
 err_out_disable:
-- 
1.9.3

