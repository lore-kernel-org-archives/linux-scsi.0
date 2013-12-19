From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH 1/2] pm80xx: Read saved WWN from NVMD for ATTO pm8001 based HBAs.
Date: Thu, 19 Dec 2013 10:50:56 -0500
Message-ID: <1387468257-3177-2-git-send-email-bgrove@attotech.com>
References: <1387468257-3177-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:12269 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754488Ab3LSPva (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2013 10:51:30 -0500
In-Reply-To: <1387468257-3177-1-git-send-email-bgrove@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, xjtuwjp@gmail.com, vasanthalakshmi.tharmarajan@pmcs.com, suresh.thiagarajan@pmcs.com, viswas.g@pmcs.com, Bradley Grove <bgrove@attotech.com>

Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 73a120d..cb89d15 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -625,7 +625,7 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
 	pm8001_ha->nvmd_completion = &completion;
 
 	if (pm8001_ha->chip_id == chip_8001) {
-		if (deviceid == 0x8081) {
+		if (deviceid == 0x8081 || deviceid == 0x0042) {
 			payload.minor_function = 4;
 			payload.length = 4096;
 		} else {
@@ -646,6 +646,9 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
 			if (deviceid == 0x8081)
 				pm8001_ha->sas_addr[j] =
 					payload.func_specific[0x704 + i];
+			else if (deviceid == 0x0042)
+				pm8001_ha->sas_addr[j] =
+					payload.func_specific[0x010 + i];
 		} else
 			pm8001_ha->sas_addr[j] =
 					payload.func_specific[0x804 + i];
@@ -1072,10 +1075,7 @@ err_out_enable:
  */
 static struct pci_device_id pm8001_pci_table[] = {
 	{ PCI_VDEVICE(PMC_Sierra, 0x8001), chip_8001 },
-	{
-		PCI_DEVICE(0x117c, 0x0042),
-		.driver_data = chip_8001
-	},
+	{ PCI_VDEVICE(ATTO, 0x0042), chip_8001 },
 	/* Support for SPC/SPCv/SPCve controllers */
 	{ PCI_VDEVICE(ADAPTEC2, 0x8001), chip_8001 },
 	{ PCI_VDEVICE(PMC_Sierra, 0x8008), chip_8008 },
-- 
1.8.3.1

