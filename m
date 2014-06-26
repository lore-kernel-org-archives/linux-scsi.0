From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 4/4] pm8001: more fixes to honor return value
Date: Thu, 26 Jun 2014 17:17:36 +0200
Message-ID: <1403795856-4300-4-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757139AbaFZPSH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2014 11:18:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: AnandKumar.Santhanam@pmcs.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com, Tomas Henzl <thenzl@redhat.com>

The driver ignores the return value in a lot of places, fix
it at least somewhere (and release the resources in such cases),
to avoid that bad things happen. 
A memory leak is fixed too.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c  |  5 ++++-
 drivers/scsi/pm8001/pm8001_init.c | 22 ++++++++++++++++++++--
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index fe5eee4..211ffd6 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -397,7 +397,10 @@ static ssize_t pm8001_ctl_bios_version_show(struct device *cdev,
 	payload.func_specific = kzalloc(4096, GFP_KERNEL);
 	if (!payload.func_specific)
 		return -ENOMEM;
-	PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
+	if (PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload)) {
+		kfree(payload.func_specific);
+		return -ENOMEM;
+	}
 	wait_for_completion(&completion);
 	virt_addr = pm8001_ha->memoryMap.region[NVMD].virt_ptr;
 	for (bios_index = BIOSOFFSET; bios_index < BIOS_OFFSET_LIMIT;
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 3b485d4..9d02a01 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -622,6 +622,8 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
 	DECLARE_COMPLETION_ONSTACK(completion);
 	struct pm8001_ioctl_payload payload;
 	u16 deviceid;
+	int rc;
+
 	pci_read_config_word(pm8001_ha->pdev, PCI_DEVICE_ID, &deviceid);
 	pm8001_ha->nvmd_completion = &completion;
 
@@ -639,7 +641,16 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
 	}
 	payload.offset = 0;
 	payload.func_specific = kzalloc(payload.length, GFP_KERNEL);
-	PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
+	if (!payload.func_specific) {
+		PM8001_INIT_DBG(pm8001_ha, pm8001_printk("mem alloc fail\n"));
+		return;
+	}
+	rc = PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
+	if (rc) {
+		kfree(payload.func_specific);
+		PM8001_INIT_DBG(pm8001_ha, pm8001_printk("nvmd failed\n"));
+		return;
+	}
 	wait_for_completion(&completion);
 
 	for (i = 0, j = 0; i <= 7; i++, j++) {
@@ -662,6 +673,7 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
 			pm8001_printk("phy %d sas_addr = %016llx\n", i,
 			pm8001_ha->phy[i].dev_sas_addr));
 	}
+	kfree(payload.func_specific);
 #else
 	for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
 		pm8001_ha->phy[i].dev_sas_addr = 0x50010c600047f9d0ULL;
@@ -685,6 +697,7 @@ static int pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
 	/*OPTION ROM FLASH read for the SPC cards */
 	DECLARE_COMPLETION_ONSTACK(completion);
 	struct pm8001_ioctl_payload payload;
+	int rc;
 
 	pm8001_ha->nvmd_completion = &completion;
 	/* SAS ADDRESS read from flash / EEPROM */
@@ -695,7 +708,12 @@ static int pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
 	if (!payload.func_specific)
 		return -ENOMEM;
 	/* Read phy setting values from flash */
-	PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
+	rc = PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
+	if (rc) {
+		kfree(payload.func_specific);
+		PM8001_INIT_DBG(pm8001_ha, pm8001_printk("nvmd failed\n"));
+		return -ENOMEM;
+	}
 	wait_for_completion(&completion);
 	pm8001_set_phy_profile(pm8001_ha, sizeof(u8), payload.func_specific);
 	kfree(payload.func_specific);
-- 
1.8.3.1

