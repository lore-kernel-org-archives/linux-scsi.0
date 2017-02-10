From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 06/39] megaraid_sas: RAID map is accessed for SYS PDs when use_seqnum_jbod_fp is not set
Date: Fri, 10 Feb 2017 00:59:06 -0800
Message-ID: <1486717179-23320-7-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:36221 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752558AbdBJJIu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2017 04:08:50 -0500
Received: by mail-pg0-f46.google.com with SMTP id v184so9023619pgv.3
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2017 01:08:49 -0800 (PST)
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
 drivers/scsi/megaraid/megaraid_sas_base.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 6ca49ef..67a205a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1756,28 +1756,31 @@ void megasas_update_sdev_properties(struct scsi_device *sdev)
 	fusion = instance->ctrl_context;
 	mr_device_priv_data = sdev->hostdata;
 
-	if (!fusion)
+	if (!fusion || !mr_device_priv_data)
 		return;
 
-	if (!MEGASAS_IS_LOGICAL(sdev) &&
-		instance->use_seqnum_jbod_fp) {
-		pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
-			sdev->id;
-		pd_sync = (void *)fusion->pd_seq_sync
-				[(instance->pd_seq_map_id - 1) & 1];
-		mr_device_priv_data->is_tm_capable =
-			pd_sync->seq[pd_index].capability.tmCapable;
-	} else {
+	if (MEGASAS_IS_LOGICAL(sdev)) {
 		device_id = ((sdev->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL)
 					+ sdev->id;
 		local_map_ptr = fusion->ld_drv_map[(instance->map_id & 1)];
 		ld = MR_TargetIdToLdGet(device_id, local_map_ptr);
+		if (ld >= instance->fw_supported_vd_count)
+			return;
 		raid = MR_LdRaidGet(ld, local_map_ptr);
 
 		if (raid->capability.ldPiMode == MR_PROT_INFO_TYPE_CONTROLLER)
-		blk_queue_update_dma_alignment(sdev->request_queue, 0x7);
+			blk_queue_update_dma_alignment(sdev->request_queue,
+						       0x7);
+
 		mr_device_priv_data->is_tm_capable =
 			raid->capability.tmCapable;
+	} else if (instance->use_seqnum_jbod_fp) {
+		pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
+				sdev->id;
+		pd_sync = (void *)fusion->pd_seq_sync
+				[(instance->pd_seq_map_id - 1) & 1];
+		mr_device_priv_data->is_tm_capable =
+				pd_sync->seq[pd_index].capability.tmCapable;
 	}
 }
 
-- 
2.8.3
