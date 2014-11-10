From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 5/7] megaraid_sas : Make HBA operational after LD_MAP_SYNC DCMD in OCR path
Date: Mon, 10 Nov 2014 17:51:34 +0530
Message-ID: <201411101224.sAACOwqK018063@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0087.outbound.protection.outlook.com ([65.55.169.87]:40142
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752298AbaKJMhe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2014 07:37:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, aradford@gmail.com

In OCR(Online Controller Reset) path, driver sets adapter state to MEGASAS_HBA_OPERATIONAL before getting new RAID map.
There will be a small window where IO will come from OS with old RAID map.
This patch will update adapter state to MEGASAS_HBA_OPERATIONAL, only after driver has new RAID map to avoid
any IOs getting build using old RAID map.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index b8411a1..aeb76d3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2801,11 +2801,6 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
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
@@ -2823,6 +2818,11 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
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
-- 
1.7.1

