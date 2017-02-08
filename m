From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 09/39] megaraid_sas: change issue_dcmd to return void from int
Date: Wed,  8 Feb 2017 01:29:03 -0800
Message-ID: <1486546173-20713-10-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33886 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754101AbdBHJao (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 04:30:44 -0500
Received: by mail-pf0-f179.google.com with SMTP id e4so40970407pfg.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2017 01:30:22 -0800 (PST)
In-Reply-To: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

fix in v2 : 
1. split patches into two as discussed below 
http://marc.info/?l=linux-scsi&m=148638999110404&w=2
2. issue_dcmd return type changed from int to void.


With the changes to remove checks for a valid request descriptor,
issue_dcmd will now always return DCMD_SUCCESS. This patch changes
return type of issue_dcmd to void and change all callers
appropriately.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 19 +++++++++++--------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  8 ++++----
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index dff877f..d9049d5 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2297,7 +2297,7 @@ struct megasas_instance_template {
 	u32 (*init_adapter)(struct megasas_instance *);
 	u32 (*build_and_issue_cmd) (struct megasas_instance *,
 				    struct scsi_cmnd *);
-	int (*issue_dcmd)(struct megasas_instance *instance,
+	void (*issue_dcmd)(struct megasas_instance *instance,
 			    struct megasas_cmd *cmd);
 };
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 80fcdf5..23fb78a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -202,12 +202,12 @@ void megasas_fusion_ocr_wq(struct work_struct *work);
 static int megasas_get_ld_vf_affiliation(struct megasas_instance *instance,
 					 int initial);
 
-int
+void
 megasas_issue_dcmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 {
 	instance->instancet->fire_cmd(instance,
 		cmd->frame_phys_addr, 0, instance->reg_set);
-	return 0;
+	return;
 }
 
 /**
@@ -995,13 +995,14 @@ megasas_issue_polled(struct megasas_instance *instance, struct megasas_cmd *cmd)
 	frame_hdr->cmd_status = MFI_STAT_INVALID_STATUS;
 	frame_hdr->flags |= cpu_to_le16(MFI_FRAME_DONT_POST_IN_REPLY_QUEUE);
 
-	if ((atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) ||
-		(instance->instancet->issue_dcmd(instance, cmd))) {
+	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
 		dev_err(&instance->pdev->dev, "Failed from %s %d\n",
 			__func__, __LINE__);
 		return DCMD_NOT_FIRED;
 	}
 
+	instance->instancet->issue_dcmd(instance, cmd);
+
 	return wait_and_poll(instance, cmd, instance->requestorId ?
 			MEGASAS_ROUTINE_WAIT_TIME_VF : MFI_IO_TIMEOUT_SECS);
 }
@@ -1023,13 +1024,14 @@ megasas_issue_blocked_cmd(struct megasas_instance *instance,
 	int ret = 0;
 	cmd->cmd_status_drv = MFI_STAT_INVALID_STATUS;
 
-	if ((atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) ||
-		(instance->instancet->issue_dcmd(instance, cmd))) {
+	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
 		dev_err(&instance->pdev->dev, "Failed from %s %d\n",
 			__func__, __LINE__);
 		return DCMD_NOT_FIRED;
 	}
 
+	instance->instancet->issue_dcmd(instance, cmd);
+
 	if (timeout) {
 		ret = wait_event_timeout(instance->int_cmd_wait_q,
 				cmd->cmd_status_drv != MFI_STAT_INVALID_STATUS, timeout * HZ);
@@ -1087,13 +1089,14 @@ megasas_issue_blocked_abort_cmd(struct megasas_instance *instance,
 	cmd->sync_cmd = 1;
 	cmd->cmd_status_drv = MFI_STAT_INVALID_STATUS;
 
-	if ((atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) ||
-		(instance->instancet->issue_dcmd(instance, cmd))) {
+	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
 		dev_err(&instance->pdev->dev, "Failed from %s %d\n",
 			__func__, __LINE__);
 		return DCMD_NOT_FIRED;
 	}
 
+	instance->instancet->issue_dcmd(instance, cmd);
+
 	if (timeout) {
 		ret = wait_event_timeout(instance->abort_cmd_wait_q,
 				cmd->cmd_status_drv != MFI_STAT_INVALID_STATUS, timeout * HZ);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index b6c5dc5..c38fde0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1115,7 +1115,7 @@ megasas_get_map_info(struct megasas_instance *instance)
 int
 megasas_sync_map_info(struct megasas_instance *instance)
 {
-	int ret = 0, i;
+	int i;
 	struct megasas_cmd *cmd;
 	struct megasas_dcmd_frame *dcmd;
 	u32 size_sync_info, num_lds;
@@ -1184,7 +1184,7 @@ megasas_sync_map_info(struct megasas_instance *instance)
 
 	instance->instancet->issue_dcmd(instance, cmd);
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -2981,7 +2981,7 @@ build_mpt_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
  * @cmd:			mfi cmd pointer
  *
  */
-int
+void
 megasas_issue_dcmd_fusion(struct megasas_instance *instance,
 			  struct megasas_cmd *cmd)
 {
@@ -2990,7 +2990,7 @@ megasas_issue_dcmd_fusion(struct megasas_instance *instance,
 	req_desc = build_mpt_cmd(instance, cmd);
 
 	megasas_fire_cmd_fusion(instance, req_desc);
-	return DCMD_SUCCESS;
+	return;
 }
 
 /**
-- 
2.8.3
