From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/5] megaraid_sas: avoid calling megasas_lookup_instance()
Date: Fri, 11 Nov 2016 10:44:49 +0100
Message-ID: <1478857492-4581-3-git-send-email-hare@suse.de>
References: <1478857492-4581-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60658 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754760AbcKKJpF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Nov 2016 04:45:05 -0500
In-Reply-To: <1478857492-4581-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

It's quite pointless to call megasas_lookup_instance() if we can
derive a pointer to the structure directly.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  3 ++-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 24 +++++++++++-------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  2 +-
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 8f1d2b4..296e692 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2375,7 +2375,8 @@ void megasas_return_mfi_mpt_pthr(struct megasas_instance *instance,
 int megasas_cmd_type(struct scsi_cmnd *cmd);
 void megasas_setup_jbod_map(struct megasas_instance *instance);
 
-void megasas_update_sdev_properties(struct scsi_device *sdev);
+void megasas_update_sdev_properties(struct megasas_instance *instance,
+				    struct scsi_device *sdev);
 int megasas_reset_fusion(struct Scsi_Host *shost, int reason);
 int megasas_task_abort_fusion(struct scsi_cmnd *scmd);
 int megasas_reset_target_fusion(struct scsi_cmnd *scmd);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e7e3efd..d580406 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1736,22 +1736,22 @@ static struct megasas_instance *megasas_lookup_instance(u16 host_no)
 /*
 * megasas_update_sdev_properties - Update sdev structure based on controller's FW capabilities
 *
+* @instance: Megasas instance
 * @sdev: OS provided scsi device
 *
 * Returns void
 */
-void megasas_update_sdev_properties(struct scsi_device *sdev)
+void megasas_update_sdev_properties(struct megasas_instance *instance,
+				    struct scsi_device *sdev)
 {
 	u16 pd_index = 0;
 	u32 device_id, ld;
-	struct megasas_instance *instance;
 	struct fusion_context *fusion;
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
 	struct MR_PD_CFG_SEQ_NUM_SYNC *pd_sync;
 	struct MR_LD_RAID *raid;
 	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
 
-	instance = megasas_lookup_instance(sdev->host->host_no);
 	fusion = instance->ctrl_context;
 	mr_device_priv_data = sdev->hostdata;
 
@@ -1780,13 +1780,11 @@ void megasas_update_sdev_properties(struct scsi_device *sdev)
 	}
 }
 
-static void megasas_set_device_queue_depth(struct scsi_device *sdev)
+static void megasas_set_device_queue_depth(struct megasas_instance *instance,
+					   struct scsi_device *sdev)
 {
 	u16				pd_index = 0;
 	int		ret = DCMD_FAILED;
-	struct megasas_instance *instance;
-
-	instance = megasas_lookup_instance(sdev->host->host_no);
 
 	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS) {
 		pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) + sdev->id;
@@ -1822,9 +1820,9 @@ static void megasas_set_device_queue_depth(struct scsi_device *sdev)
 static int megasas_slave_configure(struct scsi_device *sdev)
 {
 	u16 pd_index = 0;
-	struct megasas_instance *instance;
+	struct megasas_instance *instance = (struct megasas_instance *)
+		sdev->host->hostdata;
 
-	instance = megasas_lookup_instance(sdev->host->host_no);
 	if (instance->pd_list_not_supported) {
 		if (sdev->channel < MEGASAS_MAX_PD_CHANNELS &&
 			sdev->type == TYPE_DISK) {
@@ -1835,8 +1833,8 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 				return -ENXIO;
 		}
 	}
-	megasas_set_device_queue_depth(sdev);
-	megasas_update_sdev_properties(sdev);
+	megasas_set_device_queue_depth(instance, sdev);
+	megasas_update_sdev_properties(instance, sdev);
 
 	/*
 	 * The RAID firmware may require extended timeouts.
@@ -1850,10 +1848,10 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 static int megasas_slave_alloc(struct scsi_device *sdev)
 {
 	u16 pd_index = 0;
-	struct megasas_instance *instance ;
+	struct megasas_instance *instance = (struct megasas_instance *)
+		sdev->host->hostdata;
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
 
-	instance = megasas_lookup_instance(sdev->host->host_no);
 	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS) {
 		/*
 		 * Open the OS scan to the SYSTEM PD
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 2159f6a..38137de 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3535,7 +3535,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 			megasas_setup_jbod_map(instance);
 
 			shost_for_each_device(sdev, shost)
-				megasas_update_sdev_properties(sdev);
+				megasas_update_sdev_properties(instance, sdev);
 
 			clear_bit(MEGASAS_FUSION_IN_RESET,
 				  &instance->reset_flags);
-- 
1.8.5.6

