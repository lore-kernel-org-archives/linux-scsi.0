From: Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/2] be2iscsi: Remove unnecessary synchronize_irq() before free_irq()
Date: Sat,  5 Dec 2015 11:53:47 +0100
Message-ID: <1449312828-24539-1-git-send-email-lars@metafoo.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out-198.synserver.de ([212.40.185.198]:1108 "EHLO
	smtp-out-188.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753897AbbLELAn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Dec 2015 06:00:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Ketan Mukadam <ketan.mukadam@avagotech.com>, John Soni Jose <sony.john@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@avagotech.com, Lars-Peter Clausen <lars@metafoo.de>

Calling synchronize_irq() right before free_irq() is quite useless. On one
hand the IRQ can easily fire again before free_irq() is entered, on the
other hand free_irq() itself calls synchronize_irq() internally (in a race
condition free way), before any state associated with the IRQ is freed.

Patch was generated using the following semantic patch:
// <smpl>
@@
expression irq;
@@
-synchronize_irq(irq);
 free_irq(irq, ...);
// </smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/scsi/be2iscsi/be_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index fe0c514..c4dd858 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5279,15 +5279,12 @@ static void beiscsi_quiesce(struct beiscsi_hba *phba,
 	if (phba->msix_enabled) {
 		for (i = 0; i <= phba->num_cpus; i++) {
 			msix_vec = phba->msix_entries[i].vector;
-			synchronize_irq(msix_vec);
 			free_irq(msix_vec, &phwi_context->be_eq[i]);
 			kfree(phba->msi_name[i]);
 		}
 	} else
-		if (phba->pcidev->irq) {
-			synchronize_irq(phba->pcidev->irq);
+		if (phba->pcidev->irq)
 			free_irq(phba->pcidev->irq, phba);
-		}
 	pci_disable_msix(phba->pcidev);
 	cancel_delayed_work_sync(&phba->beiscsi_hw_check_task);
 
-- 
2.1.4

