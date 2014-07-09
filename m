From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Subject: [PATCH 3/8][RESEND] pm8001: Fix hibernation issue
Date: Wed,  9 Jul 2014 17:20:23 +0530
Message-ID: <1404906623-15741-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:41570 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755690AbaGILvU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2014 07:51:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com, rickard_strandqvist@spectrumdigital.se, bgrove@attotech.com, mlombard@redhat.com, thenzl@redhat.com

From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>

During hibernation, the HBA firmware may lose power and forget the device
id info.   This causes the HBA to reject IO upon resume.   The fix is
to call the libsas power management routines to make the domain device
forgetful.

This fixes bug 76681: https://bugzilla.kernel.org/show_bug.cgi?id=76681

Signed-off-by: Bradley Grove <bgrove@attotech.com>
Acked-by: Jack Wang <xjtuwjp@gmail.com>
---
 drivers/scsi/pm8001/pm8001_init.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index c4f31b2..86cf03a 100644
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
1.7.1

