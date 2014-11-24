From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] scsi: remove ->change_queue_type method
Date: Mon, 24 Nov 2014 15:36:18 +0100
Message-ID: <1416839781-26988-2-git-send-email-hch@lst.de>
References: <1416839781-26988-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46865 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301AbaKXOgd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 09:36:33 -0500
In-Reply-To: <1416839781-26988-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>

Since we got rid of ordered tag support in 2010 the prime use case of
switching on and off ordered tags has been obsolete.  The other function
of enabling/dsiabling tagging entirely has only been correctly implemented
by the 53c700 driver and isn't generally useful.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/srp/ib_srp.c  |  1 -
 drivers/scsi/53c700.c                | 35 -----------------------------------
 drivers/scsi/aic94xx/aic94xx_init.c  |  1 -
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c    |  1 -
 drivers/scsi/esas2r/esas2r_main.c    |  1 -
 drivers/scsi/fcoe/fcoe.c             |  1 -
 drivers/scsi/fnic/fnic_main.c        |  1 -
 drivers/scsi/ibmvscsi/ibmvfc.c       |  1 -
 drivers/scsi/ipr.c                   | 25 -------------------------
 drivers/scsi/isci/init.c             |  1 -
 drivers/scsi/libsas/sas_scsi_host.c  |  8 --------
 drivers/scsi/lpfc/lpfc_scsi.c        |  2 --
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |  1 -
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  1 -
 drivers/scsi/mvsas/mv_init.c         |  1 -
 drivers/scsi/pm8001/pm8001_init.c    |  1 -
 drivers/scsi/pmcraid.c               |  1 -
 drivers/scsi/qla2xxx/qla_os.c        |  1 -
 drivers/scsi/scsi.c                  | 16 ----------------
 drivers/scsi/scsi_debug.c            | 27 ---------------------------
 drivers/scsi/scsi_sysfs.c            | 30 ++++--------------------------
 drivers/target/loopback/tcm_loop.c   |  1 -
 include/scsi/libsas.h                |  1 -
 include/scsi/scsi_host.h             | 13 -------------
 include/scsi/scsi_tcq.h              |  3 ---
 25 files changed, 4 insertions(+), 171 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 5461924..a164036 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2740,7 +2740,6 @@ static struct scsi_host_template srp_template = {
 	.info				= srp_target_info,
 	.queuecommand			= srp_queuecommand,
 	.change_queue_depth             = srp_change_queue_depth,
-	.change_queue_type              = scsi_change_queue_type,
 	.eh_abort_handler		= srp_abort,
 	.eh_device_reset_handler	= srp_reset_device,
 	.eh_host_reset_handler		= srp_reset_host,
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index aa915da..e722911 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -176,7 +176,6 @@ STATIC int NCR_700_slave_alloc(struct scsi_device *SDpnt);
 STATIC int NCR_700_slave_configure(struct scsi_device *SDpnt);
 STATIC void NCR_700_slave_destroy(struct scsi_device *SDpnt);
 static int NCR_700_change_queue_depth(struct scsi_device *SDpnt, int depth);
-static int NCR_700_change_queue_type(struct scsi_device *SDpnt, int depth);
 
 STATIC struct device_attribute *NCR_700_dev_attrs[];
 
@@ -326,7 +325,6 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	tpnt->slave_destroy = NCR_700_slave_destroy;
 	tpnt->slave_alloc = NCR_700_slave_alloc;
 	tpnt->change_queue_depth = NCR_700_change_queue_depth;
-	tpnt->change_queue_type = NCR_700_change_queue_type;
 	tpnt->use_blk_tags = 1;
 
 	if(tpnt->name == NULL)
@@ -2082,39 +2080,6 @@ NCR_700_change_queue_depth(struct scsi_device *SDp, int depth)
 	return scsi_change_queue_depth(SDp, depth);
 }
 
-static int NCR_700_change_queue_type(struct scsi_device *SDp, int tag_type)
-{
-	int change_tag = ((tag_type ==0 &&  scsi_get_tag_type(SDp) != 0)
-			  || (tag_type != 0 && scsi_get_tag_type(SDp) == 0));
-	struct NCR_700_Host_Parameters *hostdata = 
-		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
-
-	/* We have a global (per target) flag to track whether TCQ is
-	 * enabled, so we'll be turning it off for the entire target here.
-	 * our tag algorithm will fail if we mix tagged and untagged commands,
-	 * so quiesce the device before doing this */
-	if (change_tag)
-		scsi_target_quiesce(SDp->sdev_target);
-
-	scsi_set_tag_type(SDp, tag_type);
-	if (!tag_type) {
-		/* shift back to the default unqueued number of commands
-		 * (the user can still raise this) */
-		scsi_change_queue_depth(SDp, SDp->host->cmd_per_lun);
-		hostdata->tag_negotiated &= ~(1 << sdev_id(SDp));
-	} else {
-		/* Here, we cleared the negotiation flag above, so this
-		 * will force the driver to renegotiate */
-		scsi_change_queue_depth(SDp, SDp->queue_depth);
-		if (change_tag)
-			NCR_700_set_tag_neg_state(SDp, NCR_700_START_TAG_NEGOTIATION);
-	}
-	if (change_tag)
-		scsi_target_resume(SDp->sdev_target);
-
-	return tag_type;
-}
-
 static ssize_t
 NCR_700_show_active_tags(struct device *dev, struct device_attribute *attr, char *buf)
 {
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index a64cf93..617ee73 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -71,7 +71,6 @@ static struct scsi_host_template aic94xx_sht = {
 	.scan_finished		= asd_scan_finished,
 	.scan_start		= asd_scan_start,
 	.change_queue_depth	= sas_change_queue_depth,
-	.change_queue_type	= sas_change_queue_type,
 	.bios_param		= sas_bios_param,
 	.can_queue		= 1,
 	.cmd_per_lun		= 1,
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 386c2cf..17a29e9 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2785,7 +2785,6 @@ static struct scsi_host_template bnx2fc_shost_template = {
 	.eh_host_reset_handler	= fc_eh_host_reset,
 	.slave_alloc		= fc_slave_alloc,
 	.change_queue_depth	= scsi_change_queue_depth,
-	.change_queue_type	= scsi_change_queue_type,
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 593ff8a..7e1c21e 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -255,7 +255,6 @@ static struct scsi_host_template driver_template = {
 	.emulated			= 0,
 	.proc_name			= ESAS2R_DRVR_NAME,
 	.change_queue_depth		= scsi_change_queue_depth,
-	.change_queue_type		= scsi_change_queue_type,
 	.max_sectors			= 0xFFFF,
 	.use_blk_tags			= 1,
 };
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 308a016..49df213 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -281,7 +281,6 @@ static struct scsi_host_template fcoe_shost_template = {
 	.eh_host_reset_handler = fc_eh_host_reset,
 	.slave_alloc = fc_slave_alloc,
 	.change_queue_depth = scsi_change_queue_depth,
-	.change_queue_type = scsi_change_queue_type,
 	.this_id = -1,
 	.cmd_per_lun = 3,
 	.can_queue = FCOE_MAX_OUTSTANDING_COMMANDS,
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 0c1f817..8a0d4d7 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -111,7 +111,6 @@ static struct scsi_host_template fnic_host_template = {
 	.eh_host_reset_handler = fnic_host_reset,
 	.slave_alloc = fnic_slave_alloc,
 	.change_queue_depth = scsi_change_queue_depth,
-	.change_queue_type = scsi_change_queue_type,
 	.this_id = -1,
 	.cmd_per_lun = 3,
 	.can_queue = FNIC_DFLT_IO_REQ,
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index f58c6d8..6e35964 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3089,7 +3089,6 @@ static struct scsi_host_template driver_template = {
 	.target_alloc = ibmvfc_target_alloc,
 	.scan_finished = ibmvfc_scan_finished,
 	.change_queue_depth = ibmvfc_change_queue_depth,
-	.change_queue_type = scsi_change_queue_type,
 	.cmd_per_lun = 16,
 	.can_queue = IBMVFC_MAX_REQUESTS_DEFAULT,
 	.this_id = -1,
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 5402943..c35ef5f 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4346,30 +4346,6 @@ static int ipr_change_queue_depth(struct scsi_device *sdev, int qdepth)
 }
 
 /**
- * ipr_change_queue_type - Change the device's queue type
- * @dsev:		scsi device struct
- * @tag_type:	type of tags to use
- *
- * Return value:
- * 	actual queue type set
- **/
-static int ipr_change_queue_type(struct scsi_device *sdev, int tag_type)
-{
-	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)sdev->host->hostdata;
-	struct ipr_resource_entry *res;
-	unsigned long lock_flags = 0;
-
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	res = (struct ipr_resource_entry *)sdev->hostdata;
-	if (res && ipr_is_gscsi(res))
-		tag_type = scsi_change_queue_type(sdev, tag_type);
-	else
-		tag_type = 0;
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-	return tag_type;
-}
-
-/**
  * ipr_show_adapter_handle - Show the adapter's resource handle for this device
  * @dev:	device struct
  * @attr:	device attribute structure
@@ -6302,7 +6278,6 @@ static struct scsi_host_template driver_template = {
 	.target_alloc = ipr_target_alloc,
 	.target_destroy = ipr_target_destroy,
 	.change_queue_depth = ipr_change_queue_depth,
-	.change_queue_type = ipr_change_queue_type,
 	.bios_param = ipr_biosparam,
 	.can_queue = IPR_MAX_COMMANDS,
 	.this_id = -1,
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index a81e546..4a93002 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -158,7 +158,6 @@ static struct scsi_host_template isci_sht = {
 	.scan_finished			= isci_host_scan_finished,
 	.scan_start			= isci_host_start,
 	.change_queue_depth		= sas_change_queue_depth,
-	.change_queue_type		= sas_change_queue_type,
 	.bios_param			= sas_bios_param,
 	.can_queue			= ISCI_CAN_QUEUE_VAL,
 	.cmd_per_lun			= 1,
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index b492293..8f32ec1 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -965,13 +965,6 @@ int sas_change_queue_depth(struct scsi_device *sdev, int depth)
 	return scsi_change_queue_depth(sdev, depth);
 }
 
-int sas_change_queue_type(struct scsi_device *scsi_dev, int type)
-{
-	if (dev_is_sata(sdev_to_domain_dev(scsi_dev)))
-		return -EINVAL;
-	return scsi_change_queue_type(scsi_dev, type);
-}
-
 int sas_bios_param(struct scsi_device *scsi_dev,
 			  struct block_device *bdev,
 			  sector_t capacity, int *hsc)
@@ -1185,7 +1178,6 @@ EXPORT_SYMBOL_GPL(sas_queuecommand);
 EXPORT_SYMBOL_GPL(sas_target_alloc);
 EXPORT_SYMBOL_GPL(sas_slave_configure);
 EXPORT_SYMBOL_GPL(sas_change_queue_depth);
-EXPORT_SYMBOL_GPL(sas_change_queue_type);
 EXPORT_SYMBOL_GPL(sas_bios_param);
 EXPORT_SYMBOL_GPL(sas_task_abort);
 EXPORT_SYMBOL_GPL(sas_phy_reset);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index fd85952..4f9222e 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5879,7 +5879,6 @@ struct scsi_host_template lpfc_template = {
 	.max_sectors		= 0xFFFF,
 	.vendor_id		= LPFC_NL_VENDOR_ID,
 	.change_queue_depth	= scsi_change_queue_depth,
-	.change_queue_type	= scsi_change_queue_type,
 	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
@@ -5904,7 +5903,6 @@ struct scsi_host_template lpfc_vport_template = {
 	.shost_attrs		= lpfc_vport_attrs,
 	.max_sectors		= 0xFFFF,
 	.change_queue_depth	= scsi_change_queue_depth,
-	.change_queue_type	= scsi_change_queue_type,
 	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 8431eb1..6a1c036 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -7592,7 +7592,6 @@ static struct scsi_host_template scsih_driver_template = {
 	.scan_finished			= _scsih_scan_finished,
 	.scan_start			= _scsih_scan_start,
 	.change_queue_depth 		= _scsih_change_queue_depth,
-	.change_queue_type		= scsi_change_queue_type,
 	.eh_abort_handler		= _scsih_abort,
 	.eh_device_reset_handler	= _scsih_dev_reset,
 	.eh_target_reset_handler	= _scsih_target_reset,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a2b6099..94261ee 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7229,7 +7229,6 @@ static struct scsi_host_template scsih_driver_template = {
 	.scan_finished			= _scsih_scan_finished,
 	.scan_start			= _scsih_scan_start,
 	.change_queue_depth		= _scsih_change_queue_depth,
-	.change_queue_type		= scsi_change_queue_type,
 	.eh_abort_handler		= _scsih_abort,
 	.eh_device_reset_handler	= _scsih_dev_reset,
 	.eh_target_reset_handler	= _scsih_target_reset,
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index ac7c030..3cc89be 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -63,7 +63,6 @@ static struct scsi_host_template mvs_sht = {
 	.scan_finished		= mvs_scan_finished,
 	.scan_start		= mvs_scan_start,
 	.change_queue_depth	= sas_change_queue_depth,
-	.change_queue_type	= sas_change_queue_type,
 	.bios_param		= sas_bios_param,
 	.can_queue		= 1,
 	.cmd_per_lun		= 1,
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 19ae6ca..134e049 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -76,7 +76,6 @@ static struct scsi_host_template pm8001_sht = {
 	.scan_finished		= pm8001_scan_finished,
 	.scan_start		= pm8001_scan_start,
 	.change_queue_depth	= sas_change_queue_depth,
-	.change_queue_type	= sas_change_queue_type,
 	.bios_param		= sas_bios_param,
 	.can_queue		= 1,
 	.cmd_per_lun		= 1,
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index b1b1f66..8c27b6a 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4251,7 +4251,6 @@ static struct scsi_host_template pmcraid_host_template = {
 	.slave_configure = pmcraid_slave_configure,
 	.slave_destroy = pmcraid_slave_destroy,
 	.change_queue_depth = pmcraid_change_queue_depth,
-	.change_queue_type  = scsi_change_queue_type,
 	.can_queue = PMCRAID_MAX_IO_CMD,
 	.this_id = -1,
 	.sg_tablesize = PMCRAID_MAX_IOADLS,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6b4d923..12ca291 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -258,7 +258,6 @@ struct scsi_host_template qla2xxx_driver_template = {
 	.scan_finished		= qla2xxx_scan_finished,
 	.scan_start		= qla2xxx_scan_start,
 	.change_queue_depth	= scsi_change_queue_depth,
-	.change_queue_type	= scsi_change_queue_type,
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 5ea15fc..72282ae 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -832,22 +832,6 @@ int scsi_track_queue_full(struct scsi_device *sdev, int depth)
 EXPORT_SYMBOL(scsi_track_queue_full);
 
 /**
- * scsi_change_queue_type() - Change a device's queue type
- * @sdev:     The SCSI device whose queue depth is to change
- * @tag_type: Identifier for queue type
- */
-int scsi_change_queue_type(struct scsi_device *sdev, int tag_type)
-{
-	if (!sdev->tagged_supported)
-		return 0;
-
-	scsi_set_tag_type(sdev, tag_type);
-	return tag_type;
-
-}
-EXPORT_SYMBOL(scsi_change_queue_type);
-
-/**
  * scsi_vpd_inquiry - Request a device provide us with a VPD page
  * @sdev: The device to ask
  * @buffer: Where to put the result
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ce71b6d..169c84f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4499,32 +4499,6 @@ sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
 	return sdev->queue_depth;
 }
 
-static int
-sdebug_change_qtype(struct scsi_device *sdev, int qtype)
-{
-	qtype = scsi_change_queue_type(sdev, qtype);
-	if (SCSI_DEBUG_OPT_Q_NOISE & scsi_debug_opts) {
-		const char *cp;
-
-		switch (qtype) {
-		case 0:
-			cp = "untagged";
-			break;
-		case MSG_SIMPLE_TAG:
-			cp = "simple tags";
-			break;
-		case MSG_ORDERED_TAG:
-			cp = "ordered tags";
-			break;
-		default:
-			cp = "unknown";
-			break;
-		}
-		sdev_printk(KERN_INFO, sdev, "%s: to %s\n", __func__, cp);
-	}
-	return qtype;
-}
-
 static struct scsi_host_template sdebug_driver_template = {
 	.show_info =		scsi_debug_show_info,
 	.write_info =		scsi_debug_write_info,
@@ -4537,7 +4511,6 @@ static struct scsi_host_template sdebug_driver_template = {
 	.ioctl =		scsi_debug_ioctl,
 	.queuecommand =		sdebug_queuecommand_lock_or_not,
 	.change_queue_depth =	sdebug_change_qdepth,
-	.change_queue_type =	sdebug_change_qtype,
 	.eh_abort_handler =	scsi_debug_abort,
 	.eh_device_reset_handler = scsi_debug_device_reset,
 	.eh_target_reset_handler = scsi_debug_target_reset,
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 1cb64a8..1ac38e7 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -738,30 +738,12 @@ store_queue_type_field(struct device *dev, struct device_attribute *attr,
 		       const char *buf, size_t count)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	struct scsi_host_template *sht = sdev->host->hostt;
-	int tag_type = 0, retval;
-	int prev_tag_type = scsi_get_tag_type(sdev);
-
-	if (!sdev->tagged_supported || !sht->change_queue_type)
-		return -EINVAL;
 
-	/*
-	 * We're never issueing order tags these days, but allow the value
-	 * for backwards compatibility.
-	 */
-	if (strncmp(buf, "ordered", 7) == 0 ||
-	    strncmp(buf, "simple", 6) == 0)
-		tag_type = MSG_SIMPLE_TAG;
-	else if (strncmp(buf, "none", 4) != 0)
+	if (!sdev->tagged_supported)
 		return -EINVAL;
-
-	if (tag_type == prev_tag_type)
-		return count;
-
-	retval = sht->change_queue_type(sdev, tag_type);
-	if (retval < 0)
-		return retval;
-
+		
+	sdev_printk(KERN_INFO, sdev,
+		    "ignoring write to deprecated queue_type attribute");
 	return count;
 }
 
@@ -938,10 +920,6 @@ static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
 	    !sdev->host->hostt->change_queue_depth)
 		return 0;
 
-	if (attr == &dev_attr_queue_type.attr &&
-	    !sdev->host->hostt->change_queue_type)
-		return S_IRUGO;
-
 	return attr->mode;
 }
 
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 4d1b722..24e2c94 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -385,7 +385,6 @@ static struct scsi_host_template tcm_loop_driver_template = {
 	.name			= "TCM_Loopback",
 	.queuecommand		= tcm_loop_queuecommand,
 	.change_queue_depth	= scsi_change_queue_depth,
-	.change_queue_type	= scsi_change_queue_type,
 	.eh_abort_handler = tcm_loop_abort_task,
 	.eh_device_reset_handler = tcm_loop_device_reset,
 	.eh_target_reset_handler = tcm_loop_target_reset,
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 1f8b33e..6afabbc 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -705,7 +705,6 @@ extern int sas_queuecommand(struct Scsi_Host * ,struct scsi_cmnd *);
 extern int sas_target_alloc(struct scsi_target *);
 extern int sas_slave_configure(struct scsi_device *);
 extern int sas_change_queue_depth(struct scsi_device *, int new_depth);
-extern int sas_change_queue_type(struct scsi_device *, int qt);
 extern int sas_bios_param(struct scsi_device *,
 			  struct block_device *,
 			  sector_t capacity, int *hsc);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index c8a462e..c2fa8b4 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -278,19 +278,6 @@ struct scsi_host_template {
 	int (* change_queue_depth)(struct scsi_device *, int);
 
 	/*
-	 * Fill in this function to allow the changing of tag types
-	 * (this also allows the enabling/disabling of tag command
-	 * queueing).  An error should only be returned if something
-	 * went wrong in the driver while trying to set the tag type.
-	 * If the driver doesn't support the requested tag type, then
-	 * it should set the closest type it does support without
-	 * returning an error.  Returns the actual tag type set.
-	 *
-	 * Status: OPTIONAL
-	 */
-	int (* change_queue_type)(struct scsi_device *, int);
-
-	/*
 	 * This function determines the BIOS parameters for a given
 	 * harddisk.  These tend to be numbers that are made up by
 	 * the host adapter.  Parameters:
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index fe4a702..59578be 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -15,9 +15,6 @@
 
 
 #ifdef CONFIG_BLOCK
-
-int scsi_change_queue_type(struct scsi_device *sdev, int tag_type);
-
 /**
  * scsi_get_tag_type - get the type of tag the device supports
  * @sdev:	the scsi device
-- 
1.9.1

