From: Jay Kallickal <jayamohank@gmail.com>
Subject: [PATCH 2/8] be2iscsi: Fix exposing Host in sysfs after adapter initialization is complete
Date: Mon,  5 May 2014 21:41:25 -0400
Message-ID: <1399340492-2136-2-git-send-email-jkallickal@emulex.com>
References: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:64366 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933469AbaEFBlq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2014 21:41:46 -0400
Received: by mail-pd0-f172.google.com with SMTP id g10so8675646pdj.17
        for <linux-scsi@vger.kernel.org>; Mon, 05 May 2014 18:41:46 -0700 (PDT)
In-Reply-To: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Before probe for function was completed, iSCSI Daemon had initiated login
 to target while OS was coming up. The targets which had node.startup=automatic,
 login process was initiated.Since function specific initialization was still in
 progress this lead to kernel panic.

 Fixed the issue by moving iscsi_host_add() call after adapter initialization
 is done.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 0d82229..a73af29 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -599,15 +599,7 @@ static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
 	pci_set_drvdata(pcidev, phba);
 	phba->interface_handle = 0xFFFFFFFF;
 
-	if (iscsi_host_add(shost, &phba->pcidev->dev))
-		goto free_devices;
-
 	return phba;
-
-free_devices:
-	pci_dev_put(phba->pcidev);
-	iscsi_host_free(phba->shost);
-	return NULL;
 }
 
 static void beiscsi_unmap_pci_function(struct beiscsi_hba *phba)
@@ -5621,6 +5613,9 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	}
 	hwi_enable_intr(phba);
 
+	if (iscsi_host_add(phba->shost, &phba->pcidev->dev))
+		goto free_blkenbld;
+
 	if (beiscsi_setup_boot_info(phba))
 		/*
 		 * log error but continue, because we may not be using
-- 
1.8.5.3

