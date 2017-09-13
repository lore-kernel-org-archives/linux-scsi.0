From: Nikola Pajkovsky <npajkovsky@suse.cz>
Subject: [PATCH] scsi: aacraid: error: testing array offset 'bus' after use
Date: Wed, 13 Sep 2017 10:46:17 +0200
Message-ID: <abd8be3220061294f53ed45a7487f9ea95f7aaac.1505292255.git.npajkovsky@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fix possible indexing array of bound for &aac->hba_map[bus][cid],
where bus and cid boundary check happens later.

Fixes: 0d643ff3c353 ("scsi: aacraid: use aac_tmf_callback for reset fib")
Signed-off-by: Nikola Pajkovsky <npajkovsky@suse.cz>
---
 drivers/scsi/aacraid/linit.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 87cc4a93e637..62beb2596466 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -906,12 +906,14 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
 
 	bus = aac_logical_to_phys(scmd_channel(cmd));
 	cid = scmd_id(cmd);
-	info = &aac->hba_map[bus][cid];
-	if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS ||
-	    info->devtype != AAC_DEVTYPE_NATIVE_RAW)
+
+	if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS)
 		return FAILED;
 
-	if (info->reset_state > 0)
+	info = &aac->hba_map[bus][cid];
+
+	if (info->devtype != AAC_DEVTYPE_NATIVE_RAW &&
+	    info->reset_state > 0)
 		return FAILED;
 
 	pr_err("%s: Host adapter reset request. SCSI hang ?\n",
@@ -962,12 +964,14 @@ static int aac_eh_target_reset(struct scsi_cmnd *cmd)
 
 	bus = aac_logical_to_phys(scmd_channel(cmd));
 	cid = scmd_id(cmd);
-	info = &aac->hba_map[bus][cid];
-	if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS ||
-	    info->devtype != AAC_DEVTYPE_NATIVE_RAW)
+
+	if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS)
 		return FAILED;
 
-	if (info->reset_state > 0)
+	info = &aac->hba_map[bus][cid];
+
+	if (info->devtype != AAC_DEVTYPE_NATIVE_RAW &&
+	    info->reset_state > 0)
 		return FAILED;
 
 	pr_err("%s: Host adapter reset request. SCSI hang ?\n",
-- 
2.13.5
