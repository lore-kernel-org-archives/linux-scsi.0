From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 05/14] megaraid_sas: Error handling for invalid ldcount provided by firmware in RAID map
Date: Fri,  5 Jan 2018 05:27:40 -0800
Message-ID: <1515158869-26693-6-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36808 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751731AbeAEN3V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 08:29:21 -0500
Received: by mail-pg0-f66.google.com with SMTP id j2so782082pgv.3
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jan 2018 05:29:21 -0800 (PST)
In-Reply-To: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Currently driver does not validate ldcount provided by firmware.
If the value is invalid, fail RAID map validation accordingly.
This issue is rare to hit in field and is fixed as part of code review.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index bfad9bfc313f..f2ffde430ec1 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -168,7 +168,7 @@ static struct MR_LD_SPAN *MR_LdSpanPtrGet(u32 ld, u32 span,
 /*
  * This function will Populate Driver Map using firmware raid map
  */
-void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
+static int MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 {
 	struct fusion_context *fusion = instance->ctrl_context;
 	struct MR_FW_RAID_MAP_ALL     *fw_map_old    = NULL;
@@ -259,7 +259,7 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 		ld_count = (u16)le16_to_cpu(fw_map_ext->ldCount);
 		if (ld_count > MAX_LOGICAL_DRIVES_EXT) {
 			dev_dbg(&instance->pdev->dev, "megaraid_sas: LD count exposed in RAID map in not valid\n");
-			return;
+			return 1;
 		}
 
 		pDrvRaidMap->ldCount = (__le16)cpu_to_le16(ld_count);
@@ -285,6 +285,12 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 			fusion->ld_map[(instance->map_id & 1)];
 		pFwRaidMap = &fw_map_old->raidMap;
 		ld_count = (u16)le32_to_cpu(pFwRaidMap->ldCount);
+		if (ld_count > MAX_LOGICAL_DRIVES) {
+			dev_dbg(&instance->pdev->dev,
+				"LD count exposed in RAID map in not valid\n");
+			return 1;
+		}
+
 		pDrvRaidMap->totalSize = pFwRaidMap->totalSize;
 		pDrvRaidMap->ldCount = (__le16)cpu_to_le16(ld_count);
 		pDrvRaidMap->fpPdIoTimeoutSec = pFwRaidMap->fpPdIoTimeoutSec;
@@ -300,6 +306,8 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 			sizeof(struct MR_DEV_HANDLE_INFO) *
 			MAX_RAIDMAP_PHYSICAL_DEVICES);
 	}
+
+	return 0;
 }
 
 /*
@@ -317,8 +325,8 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance)
 	u16 ld;
 	u32 expected_size;
 
-
-	MR_PopulateDrvRaidMap(instance);
+	if (MR_PopulateDrvRaidMap(instance))
+		return 0;
 
 	fusion = instance->ctrl_context;
 	drv_map = fusion->ld_drv_map[(instance->map_id & 1)];
-- 
2.14.1
