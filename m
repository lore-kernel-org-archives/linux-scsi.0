From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 3/3] mpt3sas: scsi-mq interrupt steering
Date: Tue, 21 Feb 2017 13:30:15 +0100
Message-ID: <1487680215-3879-4-git-send-email-hare@suse.de>
References: <1487680215-3879-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59442 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752123AbdBUMaT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Feb 2017 07:30:19 -0500
In-Reply-To: <1487680215-3879-1-git-send-email-hare@suse.de>
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
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 31 +++++++++++++++++++++++--------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 34 +++++++++++++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 24b5350..b5fe640 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -872,7 +872,13 @@ struct scsiio_tracker *
 	    WARN_ON(smid >= ioc->hi_priority_smid))
 		return NULL;
 
-	unique_tag = smid - 1;
+	if (!ioc->shost->use_blk_mq)
+		unique_tag = smid - 1;
+	else {
+		u16 hwq = (smid - 1) % ioc->shost->nr_hw_queues;
+		u16 tag = (smid - 1) / ioc->shost->nr_hw_queues;
+		unique_tag = blk_mq_make_unique_tag(hwq, tag);
+	}
 	cmd = scsi_host_find_tag(ioc->shost, unique_tag);
 	if (cmd)
 		return scsi_cmd_priv(cmd);
@@ -2351,17 +2357,22 @@ struct scsiio_tracker *
 	struct scsiio_tracker *request = scsi_cmd_priv(scmd);
 	unsigned int tag;
 	u16 smid;
+	u16 hwq = 0;
 
 	if (ioc->shost->use_blk_mq) {
 		u32 unique_tag = blk_mq_unique_tag(scmd->request);
-
+		hwq = blk_mq_unique_tag_to_hwq(unique_tag);
 		tag = blk_mq_unique_tag_to_tag(unique_tag);
-	} else
+		smid = (tag * ioc->shost->nr_hw_queues) + hwq + 1;
+	} else {
 		tag = scmd->request->tag;
-
-	smid = tag + 1;
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
@@ -3528,9 +3539,13 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 	 */
 	ioc->shost->reserved_cmds = INTERNAL_SCSIIO_CMDS_COUNT;
 	ioc->shost->can_queue = ioc->scsiio_depth - ioc->shost->reserved_cmds;
+	if (ioc->shost->nr_hw_queues > 1) {
+		ioc->shost->nr_hw_queues = ioc->reply_queue_count;
+		ioc->shost->can_queue /= ioc->reply_queue_count;
+	}
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT
-		"scsi host: can_queue depth (%d)\n",
-		ioc->name, ioc->shost->can_queue));
+		"scsi host: can_queue depth (%d), nr_hw_queues (%d)\n",
+		ioc->name, ioc->shost->can_queue, ioc->shost->nr_hw_queues));
 
 
 	/* contiguous pool for request and chains, 16 byte align, one extra "
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 839add2..474bccc 100644
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
@@ -1075,7 +1080,15 @@ struct scsi_cmnd *
 	struct scsiio_tracker *st;
 
 	if (smid > 0) {
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
@@ -4139,6 +4152,11 @@ static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
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
@@ -8536,6 +8554,16 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
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
@@ -8549,6 +8577,7 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	.slave_destroy			= scsih_slave_destroy,
 	.scan_finished			= scsih_scan_finished,
 	.scan_start			= scsih_scan_start,
+	.map_queues			= scsih_map_queues,
 	.change_queue_depth		= scsih_change_queue_depth,
 	.eh_abort_handler		= scsih_abort,
 	.eh_device_reset_handler	= scsih_dev_reset,
@@ -8815,6 +8844,9 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	shost->max_lun = max_lun;
 	shost->transportt = mpt3sas_transport_template;
 	shost->unique_id = ioc->id;
+	if (!shost->use_blk_mq)
+		enable_scsi_mq = 0;
+	shost->nr_hw_queues = enable_scsi_mq ? num_online_cpus() : 1;
 
 	if (max_sectors != 0xFFFF) {
 		if (max_sectors < 64) {
-- 
1.8.5.6
