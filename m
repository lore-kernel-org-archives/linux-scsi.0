From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [RESEND] [PATCH 11/13] pm80xx: WWN Modification for PM8081/88/89
 controllers
Date: Sat, 02 Mar 2013 08:52:54 -0800
Message-ID: <51322E66.7020701@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050401090802030101080200"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:54023 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822Ab3CBQwL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Mar 2013 11:52:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sangeetha.Gnanasekaran@pmcs.com, Vishwanath.Maram@pmcs.com, jack_wang@usish.com, Harry.Yang@pmcs.com

This is a multi-part message in MIME format.
--------------050401090802030101080200
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From ce9a8bdcd9bf1ab662683c6de1f460c807d8f120 Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Tue, 5 Feb 2013 12:07:19 +0530
Subject: [PATCH 11/13] pm80xx: WWN Modification for PM8081/88/89 controllers

Individual WWN read operations based on controller.
PM8081 - Read WWN from Flash VPD.
PM8088/89 - Read WWN from EEPROM.
PM8001 - Read WWN from NVM.

Signed-off-by: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
Ack-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/pm8001/pm8001_init.c |   43 +++++++++++++++++++++++++++++++------
 1 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index a9e6db0..b884a58 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1566,21 +1566,50 @@ static void  pm8001_post_sas_ha_init(struct Scsi_Host *shost,
  */
 static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
 {
-	u8 i;
+	u8 i, j;
 #ifdef PM8001_READ_VPD
+	/* For new SPC controllers WWN is stored in flash vpd
+	*  For SPC/SPCve controllers WWN is stored in EEPROM
+	*  For Older SPC WWN is stored in NVMD
+	*/
 	DECLARE_COMPLETION_ONSTACK(completion);
 	struct pm8001_ioctl_payload payload;
+	u16 deviceid;
+	pci_read_config_word(pm8001_ha->pdev, PCI_DEVICE_ID, &deviceid);
 	pm8001_ha->nvmd_completion = &completion;
-	payload.minor_function = 0;
-	payload.length = 128;
-	payload.func_specific = kzalloc(128, GFP_KERNEL);
+
+	if (pm8001_ha->chip_id == chip_8001) {
+		if (deviceid == 0x8081) {
+			payload.minor_function = 4;
+			payload.length = 4096;
+		} else {
+			payload.minor_function = 0;
+			payload.length = 128;
+		}
+	} else {
+		payload.minor_function = 1;
+		payload.length = 4096;
+	}
+	payload.offset = 0;
+	payload.func_specific = kzalloc(payload.length, GFP_KERNEL);
 	PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
 	wait_for_completion(&completion);
+
+	for (i = 0, j = 0; i <= 7; i++, j++) {
+		if (pm8001_ha->chip_id == chip_8001) {
+			if (deviceid == 0x8081)
+				pm8001_ha->sas_addr[j] =
+					payload.func_specific[0x704 + i];
+		} else
+			pm8001_ha->sas_addr[j] =
+					payload.func_specific[0x804 + i];
+	}
+
 	for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
-		memcpy(&pm8001_ha->phy[i].dev_sas_addr, pm8001_ha->sas_addr,
-			SAS_ADDR_SIZE);
+		memcpy(&pm8001_ha->phy[i].dev_sas_addr,
+			pm8001_ha->sas_addr, SAS_ADDR_SIZE);
 		PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("phy %d sas_addr = %016llx \n", i,
+			pm8001_printk("phy %d sas_addr = %016llx\n", i,
 			pm8001_ha->phy[i].dev_sas_addr));
 	}
 #else
-- 
1.7.1


--------------050401090802030101080200
Content-Type: text/plain; charset=windows-1252;
 name="0011-pm80xx-WWN-Modification-for-PM8081-88-89-controllers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0011-pm80xx-WWN-Modification-for-PM8081-88-89-controllers.pa";
 filename*1="tch"

>From ce9a8bdcd9bf1ab662683c6de1f460c807d8f120 Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Tue, 5 Feb 2013 12:07:19 +0530
Subject: [PATCH 11/13] pm80xx: WWN Modification for PM8081/88/89 controllers

Individual WWN read operations based on controller.
PM8081 - Read WWN from Flash VPD.
PM8088/89 - Read WWN from EEPROM.
PM8001 - Read WWN from NVM.

Signed-off-by: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
Ack-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/pm8001/pm8001_init.c |   43 +++++++++++++++++++++++++++++++------
 1 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index a9e6db0..b884a58 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1566,21 +1566,50 @@ static void  pm8001_post_sas_ha_init(struct Scsi_Host *shost,
  */
 static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
 {
-	u8 i;
+	u8 i, j;
 #ifdef PM8001_READ_VPD
+	/* For new SPC controllers WWN is stored in flash vpd
+	*  For SPC/SPCve controllers WWN is stored in EEPROM
+	*  For Older SPC WWN is stored in NVMD
+	*/
 	DECLARE_COMPLETION_ONSTACK(completion);
 	struct pm8001_ioctl_payload payload;
+	u16 deviceid;
+	pci_read_config_word(pm8001_ha->pdev, PCI_DEVICE_ID, &deviceid);
 	pm8001_ha->nvmd_completion = &completion;
-	payload.minor_function = 0;
-	payload.length = 128;
-	payload.func_specific = kzalloc(128, GFP_KERNEL);
+
+	if (pm8001_ha->chip_id == chip_8001) {
+		if (deviceid == 0x8081) {
+			payload.minor_function = 4;
+			payload.length = 4096;
+		} else {
+			payload.minor_function = 0;
+			payload.length = 128;
+		}
+	} else {
+		payload.minor_function = 1;
+		payload.length = 4096;
+	}
+	payload.offset = 0;
+	payload.func_specific = kzalloc(payload.length, GFP_KERNEL);
 	PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
 	wait_for_completion(&completion);
+
+	for (i = 0, j = 0; i <= 7; i++, j++) {
+		if (pm8001_ha->chip_id == chip_8001) {
+			if (deviceid == 0x8081)
+				pm8001_ha->sas_addr[j] =
+					payload.func_specific[0x704 + i];
+		} else
+			pm8001_ha->sas_addr[j] =
+					payload.func_specific[0x804 + i];
+	}
+
 	for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
-		memcpy(&pm8001_ha->phy[i].dev_sas_addr, pm8001_ha->sas_addr,
-			SAS_ADDR_SIZE);
+		memcpy(&pm8001_ha->phy[i].dev_sas_addr,
+			pm8001_ha->sas_addr, SAS_ADDR_SIZE);
 		PM8001_INIT_DBG(pm8001_ha,
-			pm8001_printk("phy %d sas_addr = %016llx \n", i,
+			pm8001_printk("phy %d sas_addr = %016llx\n", i,
 			pm8001_ha->phy[i].dev_sas_addr));
 	}
 #else
-- 
1.7.1


--------------050401090802030101080200--
