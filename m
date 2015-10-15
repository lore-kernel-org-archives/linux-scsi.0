From: sumit.saxena@avagotech.com
Subject: [PATCH 09/12] megaraid_sas : Make PI enabled VD 8 byte DMA
 aligned
Date: Thu, 15 Oct 2015 13:40:44 +0530
Message-ID: <201510150818.t9F8I3u4029657@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([199.3.246.48]:42989 "EHLO
	rndsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbbJOIUi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2015 04:20:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |   34 +++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 43e6193..c74d7c5 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1725,8 +1725,42 @@ static struct megasas_instance *megasas_lookup_instance(u16 host_no)
 	return NULL;
 }
 
+/*
+* megasas_set_dma_alignment - Set DMA alignment for PI enabled VD
+*
+* @sdev: OS provided scsi device
+*
+* Returns void
+*/
+static void megasas_set_dma_alignment(struct scsi_device *sdev)
+{
+	u32 device_id, ld;
+	struct megasas_instance *instance;
+	struct fusion_context *fusion;
+	struct MR_LD_RAID *raid;
+	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
+
+	instance = megasas_lookup_instance(sdev->host->host_no);
+	fusion = instance->ctrl_context;
+
+	if (!fusion)
+		return;
+
+	if (sdev->channel >= MEGASAS_MAX_PD_CHANNELS) {
+		device_id = ((sdev->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL)
+					+ sdev->id;
+		local_map_ptr = fusion->ld_drv_map[(instance->map_id & 1)];
+		ld = MR_TargetIdToLdGet(device_id, local_map_ptr);
+		raid = MR_LdRaidGet(ld, local_map_ptr);
+
+		if (raid->capability.ldPiMode == MR_PROT_INFO_TYPE_CONTROLLER)
+			blk_queue_update_dma_alignment(sdev->request_queue, 0x7);
+	}
+}
+
 static int megasas_slave_configure(struct scsi_device *sdev)
 {
+	megasas_set_dma_alignment(sdev);
 	/*
 	 * The RAID firmware may require extended timeouts.
 	 */
-- 
1.7.1

