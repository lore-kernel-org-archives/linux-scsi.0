From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 1/2] be2iscsi : Fix kernel panic during reboot/shutdown
Date: Fri, 26 Sep 2014 15:13:55 -0400
Message-ID: <4bc79dd1-5ea1-4956-8520-86ed5a8c78a1@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:14006 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbaIZJqa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2014 05:46:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 In the reboot/shutdown path, workqueue was destroyed after the
 adapter resource were freed. The task associated with workqueue
 was getting executed after resources were freed. This lead to
 kernel panic.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index db2bd4d..30d74a0 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5223,6 +5223,7 @@ static void beiscsi_quiesce(struct beiscsi_hba *phba,
 			free_irq(phba->pcidev->irq, phba);
 		}
 	pci_disable_msix(phba->pcidev);
+	cancel_delayed_work_sync(&phba->beiscsi_hw_check_task);
 
 	for (i = 0; i < phba->num_cpus; i++) {
 		pbe_eq = &phwi_context->be_eq[i];
@@ -5244,7 +5245,6 @@ static void beiscsi_quiesce(struct beiscsi_hba *phba,
 		hwi_cleanup(phba);
 	}
 
-	cancel_delayed_work_sync(&phba->beiscsi_hw_check_task);
 }
 
 static void beiscsi_remove(struct pci_dev *pcidev)
-- 
1.7.1

