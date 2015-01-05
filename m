From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 3/8] megaraid_sas : Fix the problem of non-existing VD
 exposed to host
Date: Mon, 5 Jan 2015 20:06:08 +0530
Message-ID: <201501051440.t05EeAgb029989@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0077.outbound.protection.outlook.com ([65.55.169.77]:48880
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753392AbbAEOvY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jan 2015 09:51:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

This patch will address the issue of SCSI device created at OS level for non existing VD. ldTgtIdtoLd[] array has size 256
for Extended VD firmware and 128 for legacy firmware. Accessing indices beyond array size(OS will send TUR, INQUIRY.. commands
upto device index 255), may return valid LD value and that particular SCSI command will be SUCCESS and creating SCSI device
for non existing target(VD).

For legacy firmware(64 VD firmware), invalidates LD(by setting LD value to 0xff) in LdTgtIdtoLd[] array for device index beyond
127, so that invalid LD(0xff) value should be returned beyond device index beyond 127.

Cc: <stable@vger.kernel.org>

Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c     |    3 +++
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   14 ++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 7cae1c2..4f72287 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -212,6 +212,9 @@ void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 		for (i = 0; i < MAX_RAIDMAP_LOGICAL_DRIVES + MAX_RAIDMAP_VIEWS; i++)
 			pDrvRaidMap->ldTgtIdToLd[i] =
 				(u8)pFwRaidMap->ldTgtIdToLd[i];
+		for (i = (MAX_RAIDMAP_LOGICAL_DRIVES + MAX_RAIDMAP_VIEWS);
+			i < MAX_LOGICAL_DRIVES_EXT; i++)
+			pDrvRaidMap->ldTgtIdToLd[i] = 0xff;
 		for (i = 0; i < ld_count; i++) {
 			pDrvRaidMap->ldSpanMap[i] = pFwRaidMap->ldSpanMap[i];
 #if VD_EXT_DEBUG
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index bd0e0cb..fe60743 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1725,9 +1725,19 @@ megasas_build_dcdb_fusion(struct megasas_instance *instance,
 		if (scmd->device->channel < MEGASAS_MAX_PD_CHANNELS)
 			goto NonFastPath;
 
+		/*
+		 * For older firmware, Driver should not access ldTgtIdToLd
+		 * beyond index 127 and for Extended VD firmware, ldTgtIdToLd
+		 * should not go beyond 255.
+		 */
+
+		if ((!fusion->fast_path_io) ||
+			(device_id >= instance->fw_supported_vd_count))
+			goto NonFastPath;
+
 		ld = MR_TargetIdToLdGet(device_id, local_map_ptr);
-		if ((ld >= instance->fw_supported_vd_count) ||
-			(!fusion->fast_path_io))
+
+		if (ld >= instance->fw_supported_vd_count)
 			goto NonFastPath;
 
 		raid = MR_LdRaidGet(ld, local_map_ptr);
-- 
1.7.3

