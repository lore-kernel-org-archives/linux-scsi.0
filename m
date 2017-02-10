From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 05/39] megaraid_sas: Refactor MEGASAS_IS_LOGICAL macro using sdev
Date: Fri, 10 Feb 2017 00:59:05 -0800
Message-ID: <1486717179-23320-6-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:36450 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752030AbdBJJKc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2017 04:10:32 -0500
Received: by mail-pg0-f43.google.com with SMTP id v184so9036164pgv.3
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2017 01:10:22 -0800 (PST)
In-Reply-To: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  4 ++--
 drivers/scsi/megaraid/megaraid_sas_base.c   | 20 ++++++++++----------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 12 ++++++------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index f5c4742..dff877f 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2301,8 +2301,8 @@ struct megasas_instance_template {
 			    struct megasas_cmd *cmd);
 };
 
-#define MEGASAS_IS_LOGICAL(scp)						\
-	((scp->device->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1)
+#define MEGASAS_IS_LOGICAL(sdev)					\
+	((sdev->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1)
 
 #define MEGASAS_DEV_INDEX(scp)						\
 	(((scp->device->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) +	\
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3ed876a..6ca49ef 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1279,7 +1279,7 @@ megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	u16 flags = 0;
 	struct megasas_pthru_frame *pthru;
 
-	is_logical = MEGASAS_IS_LOGICAL(scp);
+	is_logical = MEGASAS_IS_LOGICAL(scp->device);
 	device_id = MEGASAS_DEV_INDEX(scp);
 	pthru = (struct megasas_pthru_frame *)cmd->frame;
 
@@ -1519,11 +1519,11 @@ inline int megasas_cmd_type(struct scsi_cmnd *cmd)
 	case WRITE_6:
 	case READ_16:
 	case WRITE_16:
-		ret = (MEGASAS_IS_LOGICAL(cmd)) ?
+		ret = (MEGASAS_IS_LOGICAL(cmd->device)) ?
 			READ_WRITE_LDIO : READ_WRITE_SYSPDIO;
 		break;
 	default:
-		ret = (MEGASAS_IS_LOGICAL(cmd)) ?
+		ret = (MEGASAS_IS_LOGICAL(cmd->device)) ?
 			NON_READ_WRITE_LDIO : NON_READ_WRITE_SYSPDIO;
 	}
 	return ret;
@@ -1699,15 +1699,16 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 
 	scmd->result = 0;
 
-	if (MEGASAS_IS_LOGICAL(scmd) &&
+	if (MEGASAS_IS_LOGICAL(scmd->device) &&
 	    (scmd->device->id >= instance->fw_supported_vd_count ||
 		scmd->device->lun)) {
 		scmd->result = DID_BAD_TARGET << 16;
 		goto out_done;
 	}
 
-	if ((scmd->cmnd[0] == SYNCHRONIZE_CACHE) && MEGASAS_IS_LOGICAL(scmd) &&
-		(!instance->fw_sync_cache_support)) {
+	if ((scmd->cmnd[0] == SYNCHRONIZE_CACHE) &&
+	    MEGASAS_IS_LOGICAL(scmd->device) &&
+	    (!instance->fw_sync_cache_support)) {
 		scmd->result = DID_OK << 16;
 		goto out_done;
 	}
@@ -1758,7 +1759,7 @@ void megasas_update_sdev_properties(struct scsi_device *sdev)
 	if (!fusion)
 		return;
 
-	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS &&
+	if (!MEGASAS_IS_LOGICAL(sdev) &&
 		instance->use_seqnum_jbod_fp) {
 		pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
 			sdev->id;
@@ -1826,8 +1827,7 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 
 	instance = megasas_lookup_instance(sdev->host->host_no);
 	if (instance->pd_list_not_supported) {
-		if (sdev->channel < MEGASAS_MAX_PD_CHANNELS &&
-			sdev->type == TYPE_DISK) {
+		if (!MEGASAS_IS_LOGICAL(sdev) && sdev->type == TYPE_DISK) {
 			pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
 				sdev->id;
 			if (instance->pd_list[pd_index].driveState !=
@@ -1854,7 +1854,7 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
 
 	instance = megasas_lookup_instance(sdev->host->host_no);
-	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS) {
+	if (!MEGASAS_IS_LOGICAL(sdev)) {
 		/*
 		 * Open the OS scan to the SYSTEM PD
 		 */
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 24b72c5..675afc9 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3581,13 +3581,13 @@ static u16 megasas_get_tm_devhandle(struct scsi_device *sdev)
 	instance = (struct megasas_instance *)sdev->host->hostdata;
 	fusion = instance->ctrl_context;
 
-	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS) {
+	if (!MEGASAS_IS_LOGICAL(sdev)) {
 		if (instance->use_seqnum_jbod_fp) {
-				pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
-						sdev->id;
-				pd_sync = (void *)fusion->pd_seq_sync
-						[(instance->pd_seq_map_id - 1) & 1];
-				devhandle = pd_sync->seq[pd_index].devHandle;
+			pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL)
+				    + sdev->id;
+			pd_sync = (void *)fusion->pd_seq_sync
+					[(instance->pd_seq_map_id - 1) & 1];
+			devhandle = pd_sync->seq[pd_index].devHandle;
 		} else
 			sdev_printk(KERN_ERR, sdev, "Firmware expose tmCapable"
 				" without JBOD MAP support from %s %d\n", __func__, __LINE__);
-- 
2.8.3
