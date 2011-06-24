From: michaelc@cs.wisc.edu
Subject: [PATCH 1/4] iscsi_boot_sysfs: have this module check for null on destruction
Date: Fri, 24 Jun 2011 15:11:52 -0500
Message-ID: <1308946315-9240-2-git-send-email-michaelc@cs.wisc.edu>
References: <1308946315-9240-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089Ab1FXUKK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jun 2011 16:10:10 -0400
In-Reply-To: <1308946315-9240-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This moves the check for NULL boot_sets to the iscsi_boot_sysfs
module instead of having the drivers do it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |    6 ++----
 drivers/scsi/iscsi_boot_sysfs.c |    3 +++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 94b9a07..ef49c7e 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -420,8 +420,7 @@ static int beiscsi_setup_boot_info(struct beiscsi_hba *phba)
 	return 0;
 
 free_kset:
-	if (phba->boot_kset)
-		iscsi_boot_destroy_kset(phba->boot_kset);
+	iscsi_boot_destroy_kset(phba->boot_kset);
 	return -ENOMEM;
 }
 
@@ -4150,8 +4149,7 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 			    phba->ctrl.mbox_mem_alloced.size,
 			    phba->ctrl.mbox_mem_alloced.va,
 			    phba->ctrl.mbox_mem_alloced.dma);
-	if (phba->boot_kset)
-		iscsi_boot_destroy_kset(phba->boot_kset);
+	iscsi_boot_destroy_kset(phba->boot_kset);
 	iscsi_host_remove(phba->shost);
 	pci_dev_put(phba->pcidev);
 	iscsi_host_free(phba->shost);
diff --git a/drivers/scsi/iscsi_boot_sysfs.c b/drivers/scsi/iscsi_boot_sysfs.c
index df6bff7..4274ce9 100644
--- a/drivers/scsi/iscsi_boot_sysfs.c
+++ b/drivers/scsi/iscsi_boot_sysfs.c
@@ -472,6 +472,9 @@ void iscsi_boot_destroy_kset(struct iscsi_boot_kset *boot_kset)
 {
 	struct iscsi_boot_kobj *boot_kobj, *tmp_kobj;
 
+	if (!boot_kset)
+		return;
+
 	list_for_each_entry_safe(boot_kobj, tmp_kobj,
 				 &boot_kset->kobj_list, list)
 		iscsi_boot_remove_kobj(boot_kobj);
-- 
1.7.2.3

