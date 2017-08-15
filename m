From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] megaraid_sas: Fallback to older scanning if no disks are found
Date: Tue, 15 Aug 2017 14:05:40 +0200
Message-ID: <1502798740-69337-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51182 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752381AbdHOMFo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 08:05:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

commit 21c9e160a51383d4cb0b882398534b0c95c0cc3b implemented a
new driver lookup using the MR_DCMD_LD_LIST_QUERY firmware command.
However, this command might not work properly on older firmware,
causing the command to return no drives instead of an error.
This causes a regression on older firmware as the driver will
no longer detect any drives.
This patch checks if MR_DCMD_LD_LIST_QUERY return no drives,
and falls back to the original method if so.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 39b08fc..a1cf2c3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4502,7 +4502,6 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 		dev_info(&instance->pdev->dev,
 			"DCMD not supported by firmware - %s %d\n",
 				__func__, __LINE__);
-		ret = megasas_get_ld_list(instance);
 		break;
 	case DCMD_TIMEOUT:
 		switch (dcmd_timeout_ocr_possible(instance)) {
@@ -4530,6 +4529,14 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 		break;
 	case DCMD_SUCCESS:
 		tgtid_count = le32_to_cpu(ci->count);
+		/*
+		 * Some older firmware return '0' if the LD LIST QUERY
+		 * command is not supported.
+		 */
+		if (tgtid_count == 0) {
+			ret = DCMD_FAILED;
+			break;
+		}
 
 		if ((tgtid_count > (instance->fw_supported_vd_count)))
 			break;
@@ -5146,7 +5153,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	struct megasas_register_set __iomem *reg_set;
 	struct megasas_ctrl_info *ctrl_info = NULL;
 	unsigned long bar_list;
-	int i, j, loop, fw_msix_count = 0;
+	int i, j, loop, fw_msix_count = 0, ret;
 	struct IOV_111 *iovPtr;
 	struct fusion_context *fusion;
 
@@ -5384,8 +5391,11 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		}
 	}
 
-	if (megasas_ld_list_query(instance,
-				  MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
+	ret = megasas_ld_list_query(instance,
+				    MR_LD_QUERY_TYPE_EXPOSED_TO_HOST);
+	if (ret == DCMD_FAILED)
+		ret = megasas_get_ld_list(instance);
+	if (ret)
 		goto fail_get_ld_pd_list;
 
 	/*
@@ -7426,8 +7436,12 @@ static inline void megasas_remove_scsi_device(struct scsi_device *sdev)
 		case MR_EVT_LD_DELETED:
 		case MR_EVT_LD_CREATED:
 			if (!instance->requestorId ||
-				(instance->requestorId && megasas_get_ld_vf_affiliation(instance, 0)))
+			    (instance->requestorId &&
+			     megasas_get_ld_vf_affiliation(instance, 0))) {
 				dcmd_ret = megasas_ld_list_query(instance, MR_LD_QUERY_TYPE_EXPOSED_TO_HOST);
+				if (dcmd_ret == DCMD_FAILED)
+					dcmd_ret = megasas_get_ld_list(instance);
+			}
 
 			if (dcmd_ret == DCMD_SUCCESS)
 				doscan = SCAN_VD_CHANNEL;
@@ -7443,8 +7457,11 @@ static inline void megasas_remove_scsi_device(struct scsi_device *sdev)
 				break;
 
 			if (!instance->requestorId ||
-				(instance->requestorId && megasas_get_ld_vf_affiliation(instance, 0)))
+			    (instance->requestorId && megasas_get_ld_vf_affiliation(instance, 0))) {
 				dcmd_ret = megasas_ld_list_query(instance, MR_LD_QUERY_TYPE_EXPOSED_TO_HOST);
+				if (dcmd_ret == DCMD_FAILED)
+					dcmd_ret = megasas_get_ld_list(instance);
+			}
 
 			if (dcmd_ret != DCMD_SUCCESS)
 				break;
-- 
1.8.5.6
