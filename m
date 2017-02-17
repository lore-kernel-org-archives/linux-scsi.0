From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 3/3] mpt3sas: scsi-mq interrupt steering
Date: Fri, 17 Feb 2017 09:26:01 +0100
Message-ID: <1487319961-97476-4-git-send-email-hare@suse.de>
References: <1487319961-97476-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34907 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754721AbdBQI0E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 03:26:04 -0500
In-Reply-To: <1487319961-97476-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The device has several reply queues, so this patch implements
correct scsi-mq interrupt steering to take advantage of full
blk-mq support.
However, as performance results are inconclusive this patch
also adds a module parameter 'use_blk_mq' to enable full
mq support; the parameter itself is off by default.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 22 +++++++++++++++++-----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 27 ++++++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 96adf84..10102de 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -865,12 +865,15 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 struct scsiio_tracker *
 mpt3sas_get_st_from_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
+	u16 hwq, tag;
 	u32 unique_tag;
 	struct scsi_cmnd *cmd;
 
 	WARN_ON(!smid);
 	WARN_ON(smid >= ioc->hi_priority_smid);
-	unique_tag = smid - 1;
+	hwq = (smid - 1) % ioc->shost->nr_hw_queues;
+	tag = (smid - 1) / ioc->shost->nr_hw_queues;
+	unique_tag = blk_mq_make_unique_tag(hwq, tag);
 	cmd = scsi_host_find_tag(ioc->shost, unique_tag);
 	if (cmd)
 		return scsi_cmd_priv(cmd);
@@ -2347,6 +2350,7 @@ struct scsiio_tracker *
 {
 	struct scsiio_tracker *request;
 	u16 smid;
+	u16 hwq = 0;
 
 	if (!scmd) {
 		smid = 1;
@@ -2356,11 +2360,15 @@ struct scsiio_tracker *
 		u16 tag = blk_mq_unique_tag_to_tag(unique_tag);
 
 		WARN_ON(tag < ioc->shost->reserved_cmds);
+		hwq = blk_mq_unique_tag_to_hwq(unique_tag);
+		smid = (tag * ioc->shost->nr_hw_queues) + hwq + 1;
 		request = scsi_cmd_priv(scmd);
-		smid = tag + 1;
 	}
 	request->cb_idx = cb_idx;
-	request->msix_io = mpt3sas_base_get_msix_index(ioc);
+	if (scmd && ioc->shost->nr_hw_queues > 1)
+		request->msix_io = hwq;
+	else
+		request->msix_io = mpt3sas_base_get_msix_index(ioc);
 	request->smid = smid;
 	INIT_LIST_HEAD(&request->chain_list);
 	return request->smid;
@@ -3527,9 +3535,13 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
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
index 77ab449..c68d7a7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -54,6 +54,7 @@
 #include <linux/interrupt.h>
 #include <linux/aer.h>
 #include <linux/raid_class.h>
+#include <linux/blk-mq-pci.h>
 #include <asm/unaligned.h>
 
 #include "mpt3sas_base.h"
@@ -147,6 +148,11 @@ static int _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 module_param(prot_mask, int, 0);
 MODULE_PARM_DESC(prot_mask, " host protection capabilities mask, def=7 ");
 
+static int use_blk_mq;
+module_param(use_blk_mq, int, S_IRUGO);
+MODULE_PARM_DESC(use_blk_mq,
+	"Enable scsi-mq (single queue=0/all queues=1/default=0)");
+
 /* raid transport support */
 struct raid_template *mpt3sas_raid_template;
 struct raid_template *mpt2sas_raid_template;
@@ -1072,7 +1078,9 @@ struct _sas_node *
 _scsih_scsi_lookup_get_clear(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
 	if (smid > 0) {
-		u32 unique_tag = smid - 1;
+		u16 hwq = (smid - 1) % ioc->shost->nr_hw_queues;
+		u16 tag = (smid - 1) / ioc->shost->nr_hw_queues;
+		u32 unique_tag = blk_mq_make_unique_tag(hwq, tag);
 
 		return scsi_host_find_tag(ioc->shost, unique_tag);
 	}
@@ -4150,6 +4158,11 @@ void _flush_running(struct request *req, void *data, bool reserved)
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
@@ -8545,6 +8558,16 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
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
@@ -8558,6 +8581,7 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	.slave_destroy			= scsih_slave_destroy,
 	.scan_finished			= scsih_scan_finished,
 	.scan_start			= scsih_scan_start,
+	.map_queues			= scsih_map_queues,
 	.change_queue_depth		= scsih_change_queue_depth,
 	.eh_abort_handler		= scsih_abort,
 	.eh_device_reset_handler	= scsih_dev_reset,
@@ -8825,6 +8849,7 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	shost->transportt = mpt3sas_transport_template;
 	shost->unique_id = ioc->id;
 	shost->use_blk_mq = 1;
+	shost->nr_hw_queues = use_blk_mq ? num_online_cpus() : 1;
 
 	if (max_sectors != 0xFFFF) {
 		if (max_sectors < 64) {
-- 
1.8.5.6
