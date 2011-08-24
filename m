From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Subject: [PATCH 2/3] be2iscsi: Adding a shutdown Routine V2
Date: Wed, 24 Aug 2011 16:05:31 -0700
Message-ID: <07b8ca07-7bdf-40ef-8551-f08083e6fa7e@exht1.ad.emulex.com>
References: <1314227133-3678-1-git-send-email-jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:5729 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752029Ab1HXXGR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Aug 2011 19:06:17 -0400
In-Reply-To: <1314227133-3678-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

This patch adds a shutdown routine. It fixes a bug where when be2net
and be2iscsi are both used be2iscsi was not cleaning up its resources
properly causing be2net to fail to get loaded when the system is
rebooted.

Removed typecasting and phba = NULL assignment as suggested by Mike and Eike.

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |   36 ++++++++++++++++++++++++++++--------
 1 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 04970eb..8570436 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4119,9 +4119,8 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 	return beiscsi_iotask(task, sg, num_sg, xferlen, writedir);
 }
 
-static void beiscsi_remove(struct pci_dev *pcidev)
+static void beiscsi_quiesce(struct beiscsi_hba *phba)
 {
-	struct beiscsi_hba *phba = NULL;
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
 	struct be_eq_obj *pbe_eq;
@@ -4129,12 +4128,6 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 	u8 *real_offset = 0;
 	u32 value = 0;
 
-	phba = (struct beiscsi_hba *)pci_get_drvdata(pcidev);
-	if (!phba) {
-		dev_err(&pcidev->dev, "beiscsi_remove called with no phba\n");
-		return;
-	}
-
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
 	hwi_disable_intr(phba);
@@ -4170,12 +4163,38 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 			    phba->ctrl.mbox_mem_alloced.size,
 			    phba->ctrl.mbox_mem_alloced.va,
 			    phba->ctrl.mbox_mem_alloced.dma);
+}
+
+static void beiscsi_remove(struct pci_dev *pcidev)
+{
+
+	struct beiscsi_hba *phba = pci_get_drvdata(pcidev);
+
+	if (!phba) {
+		dev_err(&pcidev->dev, "beiscsi_remove called with no phba\n");
+		return;
+	}
+
+	beiscsi_quiesce(phba);
 	iscsi_boot_destroy_kset(phba->boot_kset);
 	iscsi_host_remove(phba->shost);
 	pci_dev_put(phba->pcidev);
 	iscsi_host_free(phba->shost);
 }
 
+static void beiscsi_shutdown(struct pci_dev *pcidev)
+{
+
+	struct beiscsi_hba *phba = pci_get_drvdata(pcidev);
+
+	if (!phba) {
+		dev_err(&pcidev->dev, "beiscsi_shutdown called with no phba\n");
+		return;
+	}
+
+	beiscsi_quiesce(phba);
+}
+
 static void beiscsi_msix_enable(struct beiscsi_hba *phba)
 {
 	int i, status;
@@ -4411,6 +4430,7 @@ static struct pci_driver beiscsi_pci_driver = {
 	.name = DRV_NAME,
 	.probe = beiscsi_dev_probe,
 	.remove = beiscsi_remove,
+	.shutdown = beiscsi_shutdown,
 	.id_table = beiscsi_pci_id_table
 };
 
-- 
1.7.1

