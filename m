From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 03/11] megaraid_sas : Update threshold based reply post
 host index register
Date: Sat, 6 Sep 2014 18:55:47 +0530
Message-ID: <201409061328.s86DS5EM012885@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0060.outbound.protection.outlook.com ([157.56.110.60]:24768
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751284AbaIFNuN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Sep 2014 09:50:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, aradford@gmail.com

Current driver updates reply post host index to let firmware know that replies are processed,
while returning from ISR function, only if there is no oustanding replies in reply queue.

Driver will free the request frame immediately from ISR but reply post host index is not yet updated.
It means freed request can be used by submission path and there may be a tight loop in request/reply
path. In such condition, firmware may crash when it tries to post reply and there is no free 
reply post descriptor.

Eventually two things needs to be change to avoid this issue.

Increase reply queue depth (double than request queue) to accommodate worst case scenario.
Update reply post host index to firmware once it reach to some pre-defined threshold value.

This change will make sure that firmware will always have some buffer of reply descriptor and 
will never find empty reply descriptor in completion path.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 23 ++++++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  1 +
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index c69c1ac..f30297d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -971,7 +971,7 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 
 	max_cmd = instance->max_fw_cmds;
 
-	fusion->reply_q_depth = ((max_cmd + 1 + 15)/16)*16;
+	fusion->reply_q_depth = (((max_cmd * 2) + 1 + 15)/16)*16;
 
 	fusion->request_alloc_sz =
 		sizeof(union MEGASAS_REQUEST_DESCRIPTOR_UNION) *max_cmd;
@@ -1876,6 +1876,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 	u32 status, extStatus, device_id;
 	union desc_value d_val;
 	struct LD_LOAD_BALANCE_INFO *lbinfo;
+	int threshold_reply_count = 0;
 
 	fusion = instance->ctrl_context;
 
@@ -1963,6 +1964,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 
 		desc->Words = ULLONG_MAX;
 		num_completed++;
+		threshold_reply_count++;
 
 		/* Get the next reply descriptor */
 		if (!fusion->last_reply_idx[MSIxIndex])
@@ -1982,6 +1984,25 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 
 		if (reply_descript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED)
 			break;
+		/*
+		 * Write to reply post host index register after completing threshold
+		 * number of reply counts and still there are more replies in reply queue
+		 * pending to be completed
+		 */
+		if (threshold_reply_count >= THRESHOLD_REPLY_COUNT) {
+			if ((instance->pdev->device ==
+				PCI_DEVICE_ID_LSI_INVADER) ||
+				(instance->pdev->device ==
+				PCI_DEVICE_ID_LSI_FURY))
+				writel(((MSIxIndex & 0x7) << 24) |
+					fusion->last_reply_idx[MSIxIndex],
+					instance->reply_post_host_index_addr[MSIxIndex/8]);
+			else
+				writel((MSIxIndex << 24) |
+					fusion->last_reply_idx[MSIxIndex],
+					instance->reply_post_host_index_addr[0]);
+			threshold_reply_count = 0;
+		}
 	}
 
 	if (!num_completed)
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index e76af54..d660c4d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -86,6 +86,7 @@ enum MR_RAID_FLAGS_IO_SUB_TYPE {
 
 #define MEGASAS_FP_CMD_LEN	16
 #define MEGASAS_FUSION_IN_RESET 0
+#define THRESHOLD_REPLY_COUNT 50
 
 /*
  * Raid Context structure which describes MegaRAID specific IO Parameters
-- 
1.8.3.1

