From: <jayamohan.kallickal@emulex.com>
Subject: [PATCH 4/5] be2iscsi: check before destroy
Date: Fri, 25 Mar 2011 14:24:00 -0700
Message-ID: <f790abc7-bcb9-49d2-8a6d-1cb7cd976ce0@exht1.ad.emulex.com>
References: <1301088242-29477-1-git-send-email-jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:59774 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755220Ab1CYVZN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Mar 2011 17:25:13 -0400
In-Reply-To: <1301088242-29477-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

     This patch checks if boot_kset is created before
	 attempting to destroy it.

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 7fe38a4..91b354d 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -420,7 +420,8 @@ static int beiscsi_setup_boot_info(struct beiscsi_hba *phba)
 	return 0;
 
 free_kset:
-	iscsi_boot_destroy_kset(phba->boot_kset);
+	if (phba->boot_kset)
+		iscsi_boot_destroy_kset(phba->boot_kset);
 	return -ENOMEM;
 }
 
@@ -4144,10 +4145,11 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 			    phba->ctrl.mbox_mem_alloced.size,
 			    phba->ctrl.mbox_mem_alloced.va,
 			    phba->ctrl.mbox_mem_alloced.dma);
+	if (phba->boot_kset)
+		iscsi_boot_destroy_kset(phba->boot_kset);
 	iscsi_host_remove(phba->shost);
 	pci_dev_put(phba->pcidev);
 	iscsi_host_free(phba->shost);
-	iscsi_boot_destroy_kset(phba->boot_kset);
 }
 
 static void beiscsi_msix_enable(struct beiscsi_hba *phba)
-- 
1.7.4.1

