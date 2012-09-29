From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 08/17] be2iscsi: Fix return value
Date: Sat, 29 Sep 2012 07:03:09 +0530
Message-ID: <41e809db-b7d9-4c84-ad79-bfae4cf834e6@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:52562 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758342Ab2I2BeQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2012 21:34:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Fix return value and typo in the message displayed.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 0ce96a0..c7f9929 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4386,13 +4386,13 @@ static int beiscsi_bsg_request(struct bsg_job *job)
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 				    "BM_%d : Failed to allocate memory for "
 				    "beiscsi_bsg_request\n");
-			return -EIO;
+			return -ENOMEM;
 		}
 		tag = mgmt_vendor_specific_fw_cmd(&phba->ctrl, phba, job,
 						  &nonemb_cmd);
 		if (!tag) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BM_%d : be_cmd_get_mac_addr Failed\n");
+				    "BM_%d : MBX Tag Allocation Failed\n");
 
 			pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 					    nonemb_cmd.va, nonemb_cmd.dma);
@@ -4416,11 +4416,13 @@ static int beiscsi_bsg_request(struct bsg_job *job)
 				    nonemb_cmd.va, nonemb_cmd.dma);
 		if (status || extd_status) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BM_%d : be_cmd_get_mac_addr Failed"
+				    "BM_%d : MBX Cmd Failed"
 				    " status = %d extd_status = %d\n",
 				    status, extd_status);
 
 			return -EIO;
+		} else {
+			rc = 0;
 		}
 		break;
 
-- 
1.7.2

