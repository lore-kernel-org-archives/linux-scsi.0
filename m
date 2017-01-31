From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/10] mpt3sas: scsi-mq interrupt steering
Date: Tue, 31 Jan 2017 10:26:00 +0100
Message-ID: <1485854760-122683-11-git-send-email-hare@suse.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46427 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751696AbdAaJ01 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Jan 2017 04:26:27 -0500
In-Reply-To: <1485854760-122683-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Enable all queues and implement correct I/O steering for scsi-mq.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  |  8 ++++++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 19 +++++++++++++++++++
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index f6564a3..84f808d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3560,9 +3560,13 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 	 * with some internal commands that could be outstanding
 	 */
 	ioc->shost->can_queue = ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT;
+	if (ioc->shost->nr_hw_queues > 1) {
+		ioc->shost->nr_hw_queues = ioc->msix_vector_count;
+		ioc->shost->can_queue /= ioc->msix_vector_count;
+	}
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT
-		"scsi host: can_queue depth (%d)\n",
-		ioc->name, ioc->shost->can_queue));
+		"scsi host: can_queue depth (%d), nr_hw_queues (%d)\n",
+		ioc->name, ioc->shost->can_queue, ioc->shost->nr_hw_queues));
 
 
 	/* contiguous pool for request and chains, 16 byte align, one extra "
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 8c451aa..e43f928 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -54,6 +54,7 @@
 #include <linux/interrupt.h>
 #include <linux/aer.h>
 #include <linux/raid_class.h>
+#include <linux/blk-mq-pci.h>
 #include <asm/unaligned.h>
 
 #include "mpt3sas_base.h"
@@ -4255,6 +4256,11 @@ void _flush_running(struct request *req, void *data, bool reserved)
 		mpt3sas_setup_direct_io(ioc, scmd, raid_device, mpi_request,
 		    smid);
 
+	if (shost_use_blk_mq(ioc->shost) && (ioc->shost->nr_hw_queues > 1)) {
+		u32 unique_tag = blk_mq_unique_tag(scmd->request);
+
+		msix_task = blk_mq_unique_tag_to_hwq(unique_tag);
+	}
 	if (likely(mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST)) {
 		if (sas_target_priv_data->flags & MPT_TARGET_FASTPATH_IO) {
 			mpi_request->IoFlags = cpu_to_le16(scmd->cmd_len |
@@ -8775,6 +8781,16 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
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
@@ -8788,6 +8804,7 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	.slave_destroy			= scsih_slave_destroy,
 	.scan_finished			= scsih_scan_finished,
 	.scan_start			= scsih_scan_start,
+	.map_queues			= scsih_map_queues,
 	.change_queue_depth		= scsih_change_queue_depth,
 	.eh_abort_handler		= scsih_abort,
 	.eh_device_reset_handler	= scsih_dev_reset,
@@ -9054,6 +9071,8 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	shost->max_lun = max_lun;
 	shost->transportt = mpt3sas_transport_template;
 	shost->unique_id = ioc->id;
+	if (shost->use_blk_mq)
+		shost->nr_hw_queues = num_online_cpus();
 
 	if (max_sectors != 0xFFFF) {
 		if (max_sectors < 64) {
-- 
1.8.5.6

