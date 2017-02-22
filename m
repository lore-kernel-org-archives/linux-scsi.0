From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 3/3] mpt3sas: scsi-mq interrupt steering
Date: Wed, 22 Feb 2017 11:33:35 +0100
Message-ID: <1487759615-3989-4-git-send-email-hare@suse.de>
References: <1487759615-3989-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49835 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932109AbdBVKdj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 05:33:39 -0500
In-Reply-To: <1487759615-3989-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The device has several reply queues, so this patch implements
correct scsi-mq interrupt steering to take advantage of full
blk-mq support.
However, as performance results are inconclusive this patch
also adds a module parameter 'enable_scsi_mq' to expose all
completion queues via scsi-mq; default is off.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 26 +++++++++++++++++++-----
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  2 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 38 ++++++++++++++++++++++++++++++++++--
 3 files changed, 59 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 7125296..b959306 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2350,12 +2350,24 @@ struct scsiio_tracker *
 	struct scsi_cmnd *scmd)
 {
 	struct scsiio_tracker *request = scsi_cmd_priv(scmd);
-	unsigned int tag = scmd->request->tag;
+	unsigned int tag;
 	u16 smid;
+	u16 hwq = 0;
 
-	smid = tag + 1;
+	if (ioc->shost->use_blk_mq) {
+		u32 unique_tag = blk_mq_unique_tag(scmd->request);
+		hwq = blk_mq_unique_tag_to_hwq(unique_tag);
+		tag = blk_mq_unique_tag_to_tag(unique_tag);
+		smid = (tag * ioc->shost->nr_hw_queues) + hwq + 1;
+	} else {
+		tag = scmd->request->tag;
+		smid = tag + 1;
+	}
 	request->cb_idx = cb_idx;
-	request->msix_io = mpt3sas_base_get_msix_index(ioc);
+	if (ioc->shost->nr_hw_queues > 1)
+		request->msix_io = hwq;
+	else
+		request->msix_io = mpt3sas_base_get_msix_index(ioc);
 	request->smid = smid;
 	INIT_LIST_HEAD(&request->chain_list);
 	return smid;
@@ -3521,9 +3533,13 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 	 * with some internal commands that could be outstanding
 	 */
 	ioc->shost->can_queue = ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT;
+	if (ioc->expose_all_queues_flag) {
+		ioc->shost->nr_hw_queues = ioc->reply_queue_count;
+		ioc->shost->can_queue /= ioc->reply_queue_count;
+	}
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT
-		"scsi host: can_queue depth (%d)\n",
-		ioc->name, ioc->shost->can_queue));
+		"scsi host: can_queue depth (%d), nr_hw_queues (%d)\n",
+		ioc->name, ioc->shost->can_queue, ioc->shost->nr_hw_queues));
 
 
 	/* contiguous pool for request and chains, 16 byte align, one extra "
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index a6dcb67..df2535a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -819,6 +819,7 @@ struct reply_post_struct {
  * @fw_event_lock:
  * @fw_event_list: list of fw events
  * @aen_event_read_flag: event log was read
+ * @expose_all_queues_flag: expose all reply queues to scsi mq
  * @broadcast_aen_busy: broadcast aen waiting to be serviced
  * @shost_recovery: host reset in progress
  * @ioc_reset_in_progress_lock:
@@ -981,6 +982,7 @@ struct MPT3SAS_ADAPTER {
 
 	 /* misc flags */
 	int		aen_event_read_flag;
+	int		expose_all_queues_flag;
 	u8		broadcast_aen_busy;
 	u16		broadcast_aen_pending;
 	u8		shost_recovery;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index f19f324..0ff507b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -54,6 +54,7 @@
 #include <linux/interrupt.h>
 #include <linux/aer.h>
 #include <linux/raid_class.h>
+#include <linux/blk-mq-pci.h>
 #include <asm/unaligned.h>
 
 #include "mpt3sas_base.h"
@@ -147,6 +148,10 @@ static int _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 module_param(prot_mask, int, 0);
 MODULE_PARM_DESC(prot_mask, " host protection capabilities mask, def=7 ");
 
+static int enable_scsi_mq;
+module_param(enable_scsi_mq, int, S_IRUGO);
+MODULE_PARM_DESC(enable_scsi_mq,
+	"Enable scsi-mq (single queue=0/all queues=1/default=0)");
 
 /* raid transport support */
 struct raid_template *mpt3sas_raid_template;
@@ -1076,7 +1081,15 @@ struct scsi_cmnd *
 
 	if (smid > 0  &&
 	    smid <= ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT) {
-		u32 unique_tag = smid - 1;
+		u32 unique_tag;
+
+		if (ioc->shost->use_blk_mq) {
+			u16 hwq = (smid - 1) % ioc->shost->nr_hw_queues;
+			u16 tag = (smid - 1) / ioc->shost->nr_hw_queues;
+
+			unique_tag = blk_mq_make_unique_tag(hwq, tag);
+		} else
+			unique_tag = smid - 1;
 
 		scmd = scsi_host_find_tag(ioc->shost, unique_tag);
 		if (scmd) {
@@ -4035,6 +4048,11 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
 	if (raid_device && raid_device->direct_io_enabled)
 		mpt3sas_setup_direct_io(ioc, scmd, raid_device, mpi_request);
 
+	if (shost_use_blk_mq(ioc->shost) && (ioc->shost->nr_hw_queues > 1)) {
+		u32 unique_tag = blk_mq_unique_tag(scmd->request);
+
+		msix_task = blk_mq_unique_tag_to_hwq(unique_tag);
+	}
 	if (likely(mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST)) {
 		if (sas_target_priv_data->flags & MPT_TARGET_FASTPATH_IO) {
 			mpi_request->IoFlags = cpu_to_le16(scmd->cmd_len |
@@ -8435,6 +8453,16 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	return 1;
 }
 
+static int scsih_map_queues(struct Scsi_Host *shost)
+{
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+
+	if (shost->nr_hw_queues > 1)
+		return blk_mq_pci_map_queues(&shost->tag_set, ioc->pdev);
+
+	return -EINVAL;
+}
+
 /* shost template for SAS 2.0 HBA devices */
 static struct scsi_host_template mpt2sas_driver_template = {
 	.module				= THIS_MODULE,
@@ -8448,6 +8476,7 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	.slave_destroy			= scsih_slave_destroy,
 	.scan_finished			= scsih_scan_finished,
 	.scan_start			= scsih_scan_start,
+	.map_queues			= scsih_map_queues,
 	.change_queue_depth		= scsih_change_queue_depth,
 	.eh_abort_handler		= scsih_abort,
 	.eh_device_reset_handler	= scsih_dev_reset,
@@ -8714,7 +8743,12 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	shost->max_lun = max_lun;
 	shost->transportt = mpt3sas_transport_template;
 	shost->unique_id = ioc->id;
-
+	if (!shost->use_blk_mq)
+		enable_scsi_mq = 0;
+	else
+		shost->nr_hw_queues = 1;
+	if (enable_scsi_mq)
+		ioc->expose_all_queues_flag = 1;
 	if (max_sectors != 0xFFFF) {
 		if (max_sectors < 64) {
 			shost->max_sectors = 64;
-- 
1.8.5.6
