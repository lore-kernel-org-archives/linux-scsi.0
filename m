From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/11] scsi: provide a generic change_queue_type method
Date: Mon, 10 Nov 2014 16:56:20 +0100
Message-ID: <1415634990-3023-2-git-send-email-hch@lst.de>
References: <1415634990-3023-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59069 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaKJP4e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2014 10:56:34 -0500
In-Reply-To: <1415634990-3023-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

Most drivers use exactly the same implementation, so provide it as a
library function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/infiniband/ulp/srp/ib_srp.c  | 24 +-----------------------
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c    |  2 +-
 drivers/scsi/esas2r/esas2r.h         |  1 -
 drivers/scsi/esas2r/esas2r_main.c    | 20 +-------------------
 drivers/scsi/fcoe/fcoe.c             |  2 +-
 drivers/scsi/fnic/fnic_main.c        |  2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c       | 25 +------------------------
 drivers/scsi/ipr.c                   | 20 +++-----------------
 drivers/scsi/libfc/fc_fcp.c          | 20 --------------------
 drivers/scsi/lpfc/lpfc_scsi.c        | 24 ++----------------------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 24 +-----------------------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 25 +------------------------
 drivers/scsi/pmcraid.c               | 14 ++++----------
 drivers/scsi/qla2xxx/qla_os.c        | 18 +-----------------
 drivers/scsi/scsi.c                  | 20 ++++++++++++++++++++
 drivers/scsi/scsi_debug.c            |  9 +--------
 drivers/target/loopback/tcm_loop.c   | 17 +----------------
 include/scsi/libfc.h                 |  1 -
 include/scsi/scsi_tcq.h              |  2 ++
 19 files changed, 42 insertions(+), 228 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 62d2a18..51670d7 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2259,28 +2259,6 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 }
 
 /**
- * srp_change_queue_type - changing device queue tag type
- * @sdev: scsi device struct
- * @tag_type: requested tag type
- *
- * Returns queue tag type.
- */
-static int
-srp_change_queue_type(struct scsi_device *sdev, int tag_type)
-{
-	if (sdev->tagged_supported) {
-		scsi_set_tag_type(sdev, tag_type);
-		if (tag_type)
-			scsi_activate_tcq(sdev, sdev->queue_depth);
-		else
-			scsi_deactivate_tcq(sdev, sdev->queue_depth);
-	} else
-		tag_type = 0;
-
-	return tag_type;
-}
-
-/**
  * srp_change_queue_depth - setting device queue depth
  * @sdev: scsi device struct
  * @qdepth: requested queue depth
@@ -2600,7 +2578,7 @@ static struct scsi_host_template srp_template = {
 	.info				= srp_target_info,
 	.queuecommand			= srp_queuecommand,
 	.change_queue_depth             = srp_change_queue_depth,
-	.change_queue_type              = srp_change_queue_type,
+	.change_queue_type              = scsi_change_queue_type,
 	.eh_abort_handler		= srp_abort,
 	.eh_device_reset_handler	= srp_reset_device,
 	.eh_host_reset_handler		= srp_reset_host,
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 79e5c94..3c6dc8a 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2784,7 +2784,7 @@ static struct scsi_host_template bnx2fc_shost_template = {
 	.eh_host_reset_handler	= fc_eh_host_reset,
 	.slave_alloc		= fc_slave_alloc,
 	.change_queue_depth	= fc_change_queue_depth,
-	.change_queue_type	= fc_change_queue_type,
+	.change_queue_type	= scsi_change_queue_type,
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index 3fd305d..20ab211 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -976,7 +976,6 @@ int esas2r_slave_alloc(struct scsi_device *dev);
 int esas2r_slave_configure(struct scsi_device *dev);
 void esas2r_slave_destroy(struct scsi_device *dev);
 int esas2r_change_queue_depth(struct scsi_device *dev, int depth, int reason);
-int esas2r_change_queue_type(struct scsi_device *dev, int type);
 long esas2r_proc_ioctl(struct file *fp, unsigned int cmd, unsigned long arg);
 
 /* SCSI error handler (eh) functions */
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 45aa684..be09c62 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -258,7 +258,7 @@ static struct scsi_host_template driver_template = {
 	.slave_alloc			= esas2r_slave_alloc,
 	.slave_destroy			= esas2r_slave_destroy,
 	.change_queue_depth		= esas2r_change_queue_depth,
-	.change_queue_type		= esas2r_change_queue_type,
+	.change_queue_type		= scsi_change_queue_type,
 	.max_sectors			= 0xFFFF,
 };
 
@@ -1268,24 +1268,6 @@ int esas2r_change_queue_depth(struct scsi_device *dev, int depth, int reason)
 	return dev->queue_depth;
 }
 
-int esas2r_change_queue_type(struct scsi_device *dev, int type)
-{
-	esas2r_log(ESAS2R_LOG_INFO, "change_queue_type %p, %d", dev, type);
-
-	if (dev->tagged_supported) {
-		scsi_set_tag_type(dev, type);
-
-		if (type)
-			scsi_activate_tcq(dev, dev->queue_depth);
-		else
-			scsi_deactivate_tcq(dev, dev->queue_depth);
-	} else {
-		type = 0;
-	}
-
-	return type;
-}
-
 int esas2r_slave_alloc(struct scsi_device *dev)
 {
 	return 0;
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 4a8ac7d..86956cc 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -281,7 +281,7 @@ static struct scsi_host_template fcoe_shost_template = {
 	.eh_host_reset_handler = fc_eh_host_reset,
 	.slave_alloc = fc_slave_alloc,
 	.change_queue_depth = fc_change_queue_depth,
-	.change_queue_type = fc_change_queue_type,
+	.change_queue_type = scsi_change_queue_type,
 	.this_id = -1,
 	.cmd_per_lun = 3,
 	.can_queue = FCOE_MAX_OUTSTANDING_COMMANDS,
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 8c56fdc..8581ce6 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -113,7 +113,7 @@ static struct scsi_host_template fnic_host_template = {
 	.eh_host_reset_handler = fnic_host_reset,
 	.slave_alloc = fnic_slave_alloc,
 	.change_queue_depth = fc_change_queue_depth,
-	.change_queue_type = fc_change_queue_type,
+	.change_queue_type = scsi_change_queue_type,
 	.this_id = -1,
 	.cmd_per_lun = 3,
 	.can_queue = FNIC_DFLT_IO_REQ,
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 598c42c..48d19a3 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2929,29 +2929,6 @@ static int ibmvfc_change_queue_depth(struct scsi_device *sdev, int qdepth,
 	return sdev->queue_depth;
 }
 
-/**
- * ibmvfc_change_queue_type - Change the device's queue type
- * @sdev:		scsi device struct
- * @tag_type:	type of tags to use
- *
- * Return value:
- * 	actual queue type set
- **/
-static int ibmvfc_change_queue_type(struct scsi_device *sdev, int tag_type)
-{
-	if (sdev->tagged_supported) {
-		scsi_set_tag_type(sdev, tag_type);
-
-		if (tag_type)
-			scsi_activate_tcq(sdev, sdev->queue_depth);
-		else
-			scsi_deactivate_tcq(sdev, sdev->queue_depth);
-	} else
-		tag_type = 0;
-
-	return tag_type;
-}
-
 static ssize_t ibmvfc_show_host_partition_name(struct device *dev,
 						 struct device_attribute *attr, char *buf)
 {
@@ -3133,7 +3110,7 @@ static struct scsi_host_template driver_template = {
 	.target_alloc = ibmvfc_target_alloc,
 	.scan_finished = ibmvfc_scan_finished,
 	.change_queue_depth = ibmvfc_change_queue_depth,
-	.change_queue_type = ibmvfc_change_queue_type,
+	.change_queue_type = scsi_change_queue_type,
 	.cmd_per_lun = 16,
 	.can_queue = IBMVFC_MAX_REQUESTS_DEFAULT,
 	.this_id = -1,
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 2a9578c..3d689f6 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4364,24 +4364,10 @@ static int ipr_change_queue_type(struct scsi_device *sdev, int tag_type)
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *)sdev->hostdata;
-
-	if (res) {
-		if (ipr_is_gscsi(res) && sdev->tagged_supported) {
-			/*
-			 * We don't bother quiescing the device here since the
-			 * adapter firmware does it for us.
-			 */
-			scsi_set_tag_type(sdev, tag_type);
-
-			if (tag_type)
-				scsi_activate_tcq(sdev, sdev->queue_depth);
-			else
-				scsi_deactivate_tcq(sdev, sdev->queue_depth);
-		} else
-			tag_type = 0;
-	} else
+	if (res && ipr_is_gscsi(res))
+		tag_type = scsi_change_queue_type(sdev, tag_type);
+	else
 		tag_type = 0;
-
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	return tag_type;
 }
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 1d7e76e..f3043ad 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2196,26 +2196,6 @@ int fc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 EXPORT_SYMBOL(fc_change_queue_depth);
 
 /**
- * fc_change_queue_type() - Change a device's queue type
- * @sdev:     The SCSI device whose queue depth is to change
- * @tag_type: Identifier for queue type
- */
-int fc_change_queue_type(struct scsi_device *sdev, int tag_type)
-{
-	if (sdev->tagged_supported) {
-		scsi_set_tag_type(sdev, tag_type);
-		if (tag_type)
-			scsi_activate_tcq(sdev, sdev->queue_depth);
-		else
-			scsi_deactivate_tcq(sdev, sdev->queue_depth);
-	} else
-		tag_type = 0;
-
-	return tag_type;
-}
-EXPORT_SYMBOL(fc_change_queue_type);
-
-/**
  * fc_fcp_destory() - Tear down the FCP layer for a given local port
  * @lport: The local port that no longer needs the FCP layer
  */
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index b99399f..2896e52 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -345,26 +345,6 @@ lpfc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 }
 
 /**
- * lpfc_change_queue_type() - Change a device's scsi tag queuing type
- * @sdev: Pointer the scsi device whose queue depth is to change
- * @tag_type: Identifier for queue tag type
- */
-static int
-lpfc_change_queue_type(struct scsi_device *sdev, int tag_type)
-{
-	if (sdev->tagged_supported) {
-		scsi_set_tag_type(sdev, tag_type);
-		if (tag_type)
-			scsi_activate_tcq(sdev, sdev->queue_depth);
-		else
-			scsi_deactivate_tcq(sdev, sdev->queue_depth);
-	} else
-		tag_type = 0;
-
-	return tag_type;
-}
-
-/**
  * lpfc_rampdown_queue_depth - Post RAMP_DOWN_QUEUE event to worker thread
  * @phba: The Hba for which this call is being executed.
  *
@@ -6019,7 +5999,7 @@ struct scsi_host_template lpfc_template = {
 	.max_sectors		= 0xFFFF,
 	.vendor_id		= LPFC_NL_VENDOR_ID,
 	.change_queue_depth	= lpfc_change_queue_depth,
-	.change_queue_type	= lpfc_change_queue_type,
+	.change_queue_type	= scsi_change_queue_type,
 };
 
 struct scsi_host_template lpfc_vport_template = {
@@ -6042,5 +6022,5 @@ struct scsi_host_template lpfc_vport_template = {
 	.shost_attrs		= lpfc_vport_attrs,
 	.max_sectors		= 0xFFFF,
 	.change_queue_depth	= lpfc_change_queue_depth,
-	.change_queue_type	= lpfc_change_queue_type,
+	.change_queue_type	= scsi_change_queue_type,
 };
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index c80ed04..ec36b91 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1255,28 +1255,6 @@ _scsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 }
 
 /**
- * _scsih_change_queue_type - changing device queue tag type
- * @sdev: scsi device struct
- * @tag_type: requested tag type
- *
- * Returns queue tag type.
- */
-static int
-_scsih_change_queue_type(struct scsi_device *sdev, int tag_type)
-{
-	if (sdev->tagged_supported) {
-		scsi_set_tag_type(sdev, tag_type);
-		if (tag_type)
-			scsi_activate_tcq(sdev, sdev->queue_depth);
-		else
-			scsi_deactivate_tcq(sdev, sdev->queue_depth);
-	} else
-		tag_type = 0;
-
-	return tag_type;
-}
-
-/**
  * _scsih_target_alloc - target add routine
  * @starget: scsi target struct
  *
@@ -7653,7 +7631,7 @@ static struct scsi_host_template scsih_driver_template = {
 	.scan_finished			= _scsih_scan_finished,
 	.scan_start			= _scsih_scan_start,
 	.change_queue_depth 		= _scsih_change_queue_depth,
-	.change_queue_type		= _scsih_change_queue_type,
+	.change_queue_type		= scsi_change_queue_type,
 	.eh_abort_handler		= _scsih_abort,
 	.eh_device_reset_handler	= _scsih_dev_reset,
 	.eh_target_reset_handler	= _scsih_target_reset,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 857276b..52464ac 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1123,29 +1123,6 @@ _scsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 }
 
 /**
- * _scsih_change_queue_type - changing device queue tag type
- * @sdev: scsi device struct
- * @tag_type: requested tag type
- *
- * Returns queue tag type.
- */
-static int
-_scsih_change_queue_type(struct scsi_device *sdev, int tag_type)
-{
-	if (sdev->tagged_supported) {
-		scsi_set_tag_type(sdev, tag_type);
-		if (tag_type)
-			scsi_activate_tcq(sdev, sdev->queue_depth);
-		else
-			scsi_deactivate_tcq(sdev, sdev->queue_depth);
-	} else
-		tag_type = 0;
-
-	return tag_type;
-}
-
-
-/**
  * _scsih_target_alloc - target add routine
  * @starget: scsi target struct
  *
@@ -7284,7 +7261,7 @@ static struct scsi_host_template scsih_driver_template = {
 	.scan_finished			= _scsih_scan_finished,
 	.scan_start			= _scsih_scan_start,
 	.change_queue_depth		= _scsih_change_queue_depth,
-	.change_queue_type		= _scsih_change_queue_type,
+	.change_queue_type		= scsi_change_queue_type,
 	.eh_abort_handler		= _scsih_abort,
 	.eh_device_reset_handler	= _scsih_dev_reset,
 	.eh_target_reset_handler	= _scsih_target_reset,
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index bcb64eb..2233ed6 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -321,16 +321,10 @@ static int pmcraid_change_queue_type(struct scsi_device *scsi_dev, int tag)
 	struct pmcraid_resource_entry *res;
 
 	res = (struct pmcraid_resource_entry *)scsi_dev->hostdata;
-
-	if ((res) && scsi_dev->tagged_supported &&
-	    (RES_IS_GSCSI(res->cfg_entry) || RES_IS_VSET(res->cfg_entry))) {
-		scsi_set_tag_type(scsi_dev, tag);
-
-		if (tag)
-			scsi_activate_tcq(scsi_dev, scsi_dev->queue_depth);
-		else
-			scsi_deactivate_tcq(scsi_dev, scsi_dev->queue_depth);
-	} else
+	if (res && scsi_dev->tagged_supported &&
+	    (RES_IS_GSCSI(res->cfg_entry) || RES_IS_VSET(res->cfg_entry)))
+	    	tag = scsi_change_queue_type(scsi_dev, tag);
+	else
 		tag = 0;
 
 	return tag;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index db3dbd9..5e75574 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -237,7 +237,6 @@ static int qla2xxx_eh_bus_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_host_reset(struct scsi_cmnd *);
 
 static int qla2x00_change_queue_depth(struct scsi_device *, int, int);
-static int qla2x00_change_queue_type(struct scsi_device *, int);
 static void qla2x00_clear_drv_active(struct qla_hw_data *);
 static void qla2x00_free_device(scsi_qla_host_t *);
 static void qla83xx_disable_laser(scsi_qla_host_t *vha);
@@ -260,7 +259,7 @@ struct scsi_host_template qla2xxx_driver_template = {
 	.scan_finished		= qla2xxx_scan_finished,
 	.scan_start		= qla2xxx_scan_start,
 	.change_queue_depth	= qla2x00_change_queue_depth,
-	.change_queue_type	= qla2x00_change_queue_type,
+	.change_queue_type	= scsi_change_queue_type,
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
@@ -1473,21 +1472,6 @@ qla2x00_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 	return sdev->queue_depth;
 }
 
-static int
-qla2x00_change_queue_type(struct scsi_device *sdev, int tag_type)
-{
-	if (sdev->tagged_supported) {
-		scsi_set_tag_type(sdev, tag_type);
-		if (tag_type)
-			scsi_activate_tcq(sdev, sdev->queue_depth);
-		else
-			scsi_deactivate_tcq(sdev, sdev->queue_depth);
-	} else
-		tag_type = 0;
-
-	return tag_type;
-}
-
 /**
  * qla2x00_config_dma_addressing() - Configure OS DMA addressing method.
  * @ha: HA context
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index bc52bbd..9baeff0 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -867,6 +867,26 @@ int scsi_track_queue_full(struct scsi_device *sdev, int depth)
 EXPORT_SYMBOL(scsi_track_queue_full);
 
 /**
+ * scsi_change_queue_type() - Change a device's queue type
+ * @sdev:     The SCSI device whose queue depth is to change
+ * @tag_type: Identifier for queue type
+ */
+int scsi_change_queue_type(struct scsi_device *sdev, int tag_type)
+{
+	if (sdev->tagged_supported) {
+		scsi_set_tag_type(sdev, tag_type);
+		if (tag_type)
+			scsi_activate_tcq(sdev, sdev->queue_depth);
+		else
+			scsi_deactivate_tcq(sdev, sdev->queue_depth);
+	} else
+		tag_type = 0;
+
+	return tag_type;
+}
+EXPORT_SYMBOL(scsi_change_queue_type);
+
+/**
  * scsi_vpd_inquiry - Request a device provide us with a VPD page
  * @sdev: The device to ask
  * @buffer: Where to put the result
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 238e06f..7bcace2 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4532,14 +4532,7 @@ sdebug_change_qdepth(struct scsi_device *sdev, int qdepth, int reason)
 static int
 sdebug_change_qtype(struct scsi_device *sdev, int qtype)
 {
-	if (sdev->tagged_supported) {
-		scsi_set_tag_type(sdev, qtype);
-		if (qtype)
-			scsi_activate_tcq(sdev, sdev->queue_depth);
-		else
-			scsi_deactivate_tcq(sdev, sdev->queue_depth);
-	} else
-		qtype = 0;
+	qtype = scsi_change_queue_type(sdev, qtype);
 	if (SCSI_DEBUG_OPT_Q_NOISE & scsi_debug_opts) {
 		const char *cp;
 
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index ab3ab27..3b9c768 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -135,21 +135,6 @@ static int tcm_loop_change_queue_depth(
 	return sdev->queue_depth;
 }
 
-static int tcm_loop_change_queue_type(struct scsi_device *sdev, int tag)
-{
-	if (sdev->tagged_supported) {
-		scsi_set_tag_type(sdev, tag);
-
-		if (tag)
-			scsi_activate_tcq(sdev, sdev->queue_depth);
-		else
-			scsi_deactivate_tcq(sdev, sdev->queue_depth);
-	} else
-		tag = 0;
-
-	return tag;
-}
-
 /*
  * Locate the SAM Task Attr from struct scsi_cmnd *
  */
@@ -451,7 +436,7 @@ static struct scsi_host_template tcm_loop_driver_template = {
 	.name			= "TCM_Loopback",
 	.queuecommand		= tcm_loop_queuecommand,
 	.change_queue_depth	= tcm_loop_change_queue_depth,
-	.change_queue_type	= tcm_loop_change_queue_type,
+	.change_queue_type	= scsi_change_queue_type,
 	.eh_abort_handler = tcm_loop_abort_task,
 	.eh_device_reset_handler = tcm_loop_device_reset,
 	.eh_target_reset_handler = tcm_loop_target_reset,
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 52beadf..2e0cf56 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -1106,7 +1106,6 @@ int fc_eh_device_reset(struct scsi_cmnd *);
 int fc_eh_host_reset(struct scsi_cmnd *);
 int fc_slave_alloc(struct scsi_device *);
 int fc_change_queue_depth(struct scsi_device *, int qdepth, int reason);
-int fc_change_queue_type(struct scsi_device *, int tag_type);
 
 /*
  * ELS/CT interface
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index 7529c6a..1712dab 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -16,6 +16,8 @@
 
 #ifdef CONFIG_BLOCK
 
+int scsi_change_queue_type(struct scsi_device *sdev, int tag_type);
+
 /**
  * scsi_get_tag_type - get the type of tag the device supports
  * @sdev:	the scsi device
-- 
1.9.1

