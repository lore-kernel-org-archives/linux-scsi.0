From: michaelc@cs.wisc.edu
Subject: [PATCH 09/17] be2iscsi:Fix the function return values.
Date: Tue, 20 Mar 2012 20:48:00 -0500
Message-ID: <1332294488-13684-10-git-send-email-michaelc@cs.wisc.edu>
References: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030355Ab2CUBsa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 21:48:30 -0400
In-Reply-To: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

	This patch fixes the return value

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 2e08496..52277f7 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -541,8 +541,7 @@ static int be_ctrl_init(struct beiscsi_hba *phba, struct pci_dev *pdev)
 						  &mbox_mem_alloc->dma);
 	if (!mbox_mem_alloc->va) {
 		beiscsi_unmap_pci_function(phba);
-		status = -ENOMEM;
-		return status;
+		return -ENOMEM;
 	}
 
 	mbox_mem_align->size = sizeof(struct be_mcc_mailbox);
@@ -3209,7 +3208,7 @@ static int hwi_init_port(struct beiscsi_hba *phba)
 error:
 	shost_printk(KERN_ERR, phba->shost, "hwi_init_port failed");
 	hwi_cleanup(phba);
-	return -ENOMEM;
+	return status;
 }
 
 static int hwi_init_controller(struct beiscsi_hba *phba)
@@ -3284,7 +3283,7 @@ static int beiscsi_init_controller(struct beiscsi_hba *phba)
 
 free_init:
 	beiscsi_free_mem(phba);
-	return -ENOMEM;
+	return ret;
 }
 
 static int beiscsi_init_sgl_handle(struct beiscsi_hba *phba)
-- 
1.7.7.6

