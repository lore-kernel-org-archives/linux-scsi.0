From: <Sumit.Saxena@lsi.com>
Subject: [PATCH 04/12] megaraid_sas : Free event detail memory without
 device ID check
Date: Wed, 22 May 2013 12:30:54 +0530
Message-ID: <201305221231.r4MCVA8o012048@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:21578
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755815Ab3EVMbi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 May 2013 08:31:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, kashyap.desai@lsi.com, aradford@gmail.com

Free event detail memory from more common place, instead of doing it for limited device types.

Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: Adam Radford <aradford@gmail.com>
---
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index c79daf5..5beea2f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4599,10 +4599,6 @@ static void megasas_detach_one(struct pci_dev *pdev)
 		break;
 	default:
 		megasas_release_mfi(instance);
-		pci_free_consistent(pdev,
-				    sizeof(struct megasas_evt_detail),
-				    instance->evt_detail,
-				    instance->evt_detail_h);
 		pci_free_consistent(pdev, sizeof(u32),
 				    instance->producer,
 				    instance->producer_h);
@@ -4612,6 +4608,9 @@ static void megasas_detach_one(struct pci_dev *pdev)
 		break;
 	}
 
+	if (instance->evt_detail)
+		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
+				instance->evt_detail, instance->evt_detail_h);
 	scsi_host_put(host);
 
 	pci_set_drvdata(pdev, NULL);

