From: Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH resend 1/2] be2iscsi: Remove unnecessary synchronize_irq() before free_irq()
Date: Tue,  2 Feb 2016 21:02:27 +0100
Message-ID: <1454443348-12783-1-git-send-email-lars@metafoo.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out-195.synserver.de ([212.40.185.195]:1336 "EHLO
	smtp-out-195.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbcBCMEO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2016 07:04:14 -0500
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
index 70179e1..4b4d79d 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5308,15 +5308,12 @@ static void beiscsi_quiesce(struct beiscsi_hba *phba,
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

