From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 5/7] megaraid_sas : Make HBA operational after
 LD_MAP_SYNC DCMD in OCR path
Date: Mon, 17 Nov 2014 15:24:18 +0530
Message-ID: <201411170958.sAH9vxfw008970@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0065.outbound.protection.outlook.com ([65.55.169.65]:22127
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752347AbaKQJye (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2014 04:54:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

In OCR(Online Controller Reset) path, driver sets adapter state to MEGASAS_HBA_OPERATIONAL before getting new RAID map.
There will be a small window where IO will come from OS with old RAID map.
This patch will update adapter state to MEGASAS_HBA_OPERATIONAL, only after driver has new RAID map to avoid
any IOs getting build using old RAID map.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 98dfc1d..4e259ed 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2803,11 +2803,6 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 				}
 			}
 
-			clear_bit(MEGASAS_FUSION_IN_RESET,
-				  &instance->reset_flags);
-			instance->instancet->enable_intr(instance);
-			instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
-
 			if (megasas_get_ctrl_info(instance)) {
 				dev_info(&instance->pdev->dev,
 					"Failed from %s %d\n",
@@ -2825,6 +2820,11 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 			if (!megasas_get_map_info(instance))
 				megasas_sync_map_info(instance);
 
+			clear_bit(MEGASAS_FUSION_IN_RESET,
+				  &instance->reset_flags);
+			instance->instancet->enable_intr(instance);
+			instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
+
 			/* Restart SR-IOV heartbeat */
 			if (instance->requestorId) {
 				if (!megasas_sriov_start_heartbeat(instance, 0))
@@ -2841,14 +2841,14 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 			       "successful for scsi%d.\n",
 				instance->host->host_no);
 
-			if (instance->crash_dump_drv_support) {
-				if (instance->crash_dump_app_support)
-					megasas_set_crash_dump_params(instance,
-						MR_CRASH_BUF_TURN_ON);
-				else
-					megasas_set_crash_dump_params(instance,
-						MR_CRASH_BUF_TURN_OFF);
-			}
+			if (instance->crash_dump_drv_support &&
+				instance->crash_dump_app_support)
+				megasas_set_crash_dump_params(instance,
+					MR_CRASH_BUF_TURN_ON);
+			else
+				megasas_set_crash_dump_params(instance,
+					MR_CRASH_BUF_TURN_OFF);
+
 			retval = SUCCESS;
 			goto out;
 		}
-- 
1.7.1

