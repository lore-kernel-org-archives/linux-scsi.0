From: Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH resend 1/2] be2iscsi: Remove unnecessary synchronize_irq() before free_irq()
Date: Fri,  4 Mar 2016 11:15:06 +0100
Message-ID: <1457086507-5937-1-git-send-email-lars@metafoo.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out-012.synserver.de ([212.40.185.12]:1043 "EHLO
	smtp-out-012.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbcCDKP3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2016 05:15:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Jitendra Bhivare <jitendra.bhivare@broadcom.com>, linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, Lars-Peter Clausen <lars@metafoo.de>

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
index b51e726..e89a0f8d 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5303,15 +5303,12 @@ static void beiscsi_quiesce(struct beiscsi_hba *phba,
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

