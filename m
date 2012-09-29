From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 06/17] be2iscsi: Issue an FLR when driver is loaded.
Date: Sat, 29 Sep 2012 07:02:38 +0530
Message-ID: <3fb85609-1052-440a-88b9-d1f126d3fb53@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5839 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758342Ab2I2Bdl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2012 21:33:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Issue Function Level Reset everytime driver is loaded.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |   39 ++++++++++++---------------------------
 1 files changed, 12 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 82c69aa..0fb36b4 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -47,8 +47,6 @@
 static unsigned int be_iopoll_budget = 10;
 static unsigned int be_max_phys_size = 64;
 static unsigned int enable_msix = 1;
-static unsigned int gcrashmode = 0;
-static unsigned int num_hba = 0;
 
 MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
 MODULE_DESCRIPTION(DRV_DESC " " BUILD_STR);
@@ -4605,31 +4603,18 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 		goto hba_free;
 	}
 
-	if (!num_hba) {
-		real_offset = (u8 *)phba->csr_va + MPU_EP_SEMAPHORE;
-		value = readl((void *)real_offset);
-		if (value & 0x00010000) {
-			gcrashmode++;
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : Loading Driver in crashdump mode\n");
-			ret = beiscsi_cmd_reset_function(phba);
-			if (ret) {
-				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM_%d : Reset Failed. Aborting Crashdump\n");
-				goto hba_free;
-			}
-			ret = be_chk_reset_complete(phba);
-			if (ret) {
-				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM_%d : Failed to get out of reset."
-					    "Aborting Crashdump\n");
-				goto hba_free;
-			}
-		} else {
-			value |= 0x00010000;
-			writel(value, (void *)real_offset);
-			num_hba++;
-		}
+	ret = beiscsi_cmd_reset_function(phba);
+	if (ret) {
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+			    "BM_%d : Reset Failed. Aborting Crashdump\n");
+		goto hba_free;
+	}
+	ret = be_chk_reset_complete(phba);
+	if (ret) {
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+			    "BM_%d : Failed to get out of reset."
+			    "Aborting Crashdump\n");
+		goto hba_free;
 	}
 
 	spin_lock_init(&phba->io_sgl_lock);
-- 
1.7.2

