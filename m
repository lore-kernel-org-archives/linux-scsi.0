From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/11] scsi: always assign block layer tags if enabled
Date: Tue,  4 Nov 2014 08:54:13 +0100
Message-ID: <1415087656-9491-9-git-send-email-hch@lst.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34693 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbaKDHyU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 02:54:20 -0500
In-Reply-To: <1415087656-9491-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

Allow a driver to ask for block layer tags by setting .use_blk_tags in the
host template, in which case it will always see a valid value in
request->tag, similar to the behavior when using blk-mq.  This means even
SCSI "untagged" commands will now have a tag, which is especially useful
when using a host-wide tag map.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/scsi/scsi_mid_low_api.txt | 38 +--------------------------------
 drivers/message/fusion/mptsas.c         |  1 +
 drivers/scsi/53c700.c                   | 12 +++++------
 drivers/scsi/aic7xxx/aic79xx_osm.c      | 11 +++++-----
 drivers/scsi/aic7xxx/aic7xxx_osm.c      | 11 +++++-----
 drivers/scsi/aic94xx/aic94xx_init.c     |  1 +
 drivers/scsi/bfa/bfad_im.c              |  8 +++----
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c       |  1 +
 drivers/scsi/csiostor/csio_scsi.c       |  8 +++----
 drivers/scsi/esas2r/esas2r_main.c       | 12 +++++------
 drivers/scsi/esp_scsi.c                 |  6 +++---
 drivers/scsi/fcoe/fcoe.c                |  1 +
 drivers/scsi/fnic/fnic_main.c           |  3 ++-
 drivers/scsi/ibmvscsi/ibmvfc.c          | 11 +++++-----
 drivers/scsi/ipr.c                      |  1 +
 drivers/scsi/isci/init.c                |  1 +
 drivers/scsi/libfc/fc_fcp.c             |  7 +-----
 drivers/scsi/libsas/sas_scsi_host.c     | 11 +++-------
 drivers/scsi/lpfc/lpfc_scsi.c           |  7 +++---
 drivers/scsi/mvsas/mv_init.c            |  1 +
 drivers/scsi/pm8001/pm8001_init.c       |  1 +
 drivers/scsi/pmcraid.c                  |  4 ++--
 drivers/scsi/qla2xxx/qla_os.c           |  6 ++----
 drivers/scsi/qla4xxx/ql4_os.c           | 10 ++-------
 drivers/scsi/scsi.c                     | 12 ++++-------
 drivers/scsi/scsi_scan.c                |  6 ++++++
 drivers/scsi/stex.c                     | 10 ++-------
 drivers/scsi/tmscsim.c                  |  3 ++-
 drivers/scsi/ufs/ufshcd.c               |  5 +++--
 drivers/target/loopback/tcm_loop.c      |  2 +-
 drivers/usb/storage/uas.c               |  4 ++--
 include/scsi/scsi_host.h                |  5 +++++
 include/scsi/scsi_tcq.h                 | 34 -----------------------------
 33 files changed, 86 insertions(+), 168 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index d6a9bde..a671942 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -366,13 +366,11 @@ is initialized. The functions below are listed alphabetically and their
 names all start with "scsi_".
 
 Summary:
-   scsi_activate_tcq - turn on tag command queueing
    scsi_add_device - creates new scsi device (lu) instance
    scsi_add_host - perform sysfs registration and set up transport class
    scsi_adjust_queue_depth - change the queue depth on a SCSI device
    scsi_bios_ptable - return copy of block device's partition table
    scsi_block_requests - prevent further commands being queued to given host
-   scsi_deactivate_tcq - turn off tag command queueing
    scsi_host_alloc - return a new scsi_host instance whose refcount==1
    scsi_host_get - increments Scsi_Host instance's refcount
    scsi_host_put - decrements Scsi_Host instance's refcount (free if 0)
@@ -390,24 +388,6 @@ Summary:
 Details:
 
 /**
- * scsi_activate_tcq - turn on tag command queueing ("ordered" task attribute)
- * @sdev:       device to turn on TCQ for
- * @depth:      queue depth
- *
- *      Returns nothing
- *
- *      Might block: no
- *
- *      Notes: Eventually, it is hoped depth would be the maximum depth
- *      the device could cope with and the real queue depth
- *      would be adjustable from 0 to depth.
- *
- *      Defined (inline) in: include/scsi/scsi_tcq.h
- **/
-void scsi_activate_tcq(struct scsi_device *sdev, int depth)
-
-
-/**
  * scsi_add_device - creates new scsi device (lu) instance
  * @shost:   pointer to scsi host instance
  * @channel: channel number (rarely other than 0)
@@ -471,9 +451,7 @@ int scsi_add_host(struct Scsi_Host *shost, struct device * dev)
  *
  *      Notes: Can be invoked any time on a SCSI device controlled by this
  *      LLD. [Specifically during and after slave_configure() and prior to
- *      slave_destroy().] Can safely be invoked from interrupt code. Actual
- *      queue depth change may be delayed until the next command is being
- *      processed. See also scsi_activate_tcq() and scsi_deactivate_tcq().
+ *      slave_destroy().] Can safely be invoked from interrupt code.
  *
  *      Defined in: drivers/scsi/scsi.c [see source code for more notes]
  *
@@ -515,20 +493,6 @@ void scsi_block_requests(struct Scsi_Host * shost)
 
 
 /**
- * scsi_deactivate_tcq - turn off tag command queueing
- * @sdev:       device to turn off TCQ for
- * @depth:      queue depth (stored in sdev)
- *
- *      Returns nothing
- *
- *      Might block: no
- *
- *      Defined (inline) in: include/scsi/scsi_tcq.h
- **/
-void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
-
-
-/**
  * scsi_host_alloc - create a scsi host adapter instance and perform basic
  *                   initialization.
  * @sht:        pointer to scsi host template
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 0707fa2..5bdaae1 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1994,6 +1994,7 @@ static struct scsi_host_template mptsas_driver_template = {
 	.cmd_per_lun			= 7,
 	.use_clustering			= ENABLE_CLUSTERING,
 	.shost_attrs			= mptscsih_host_attrs,
+	.use_blk_tags			= 1,
 };
 
 static int mptsas_get_linkerrors(struct sas_phy *phy)
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 1b36fd3..497cbb1 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -327,6 +327,7 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	tpnt->slave_alloc = NCR_700_slave_alloc;
 	tpnt->change_queue_depth = NCR_700_change_queue_depth;
 	tpnt->change_queue_type = NCR_700_change_queue_type;
+	tpnt->use_blk_tags = 1;
 
 	if(tpnt->name == NULL)
 		tpnt->name = "53c700";
@@ -902,7 +903,7 @@ process_message(struct Scsi_Host *host,	struct NCR_700_Host_Parameters *hostdata
 			NCR_700_set_tag_neg_state(SCp->device, NCR_700_FINISHED_TAG_NEGOTIATION);
 			hostdata->tag_negotiated &= ~(1<<scmd_id(SCp));
 			SCp->device->tagged_supported = 0;
-			scsi_deactivate_tcq(SCp->device, host->cmd_per_lun);
+			scsi_adjust_queue_depth(SCp->device, 0, host->cmd_per_lun);
 		} else {
 			shost_printk(KERN_WARNING, host,
 				"(%d:%d) Unexpected REJECT Message %s\n",
@@ -2049,8 +2050,7 @@ NCR_700_slave_configure(struct scsi_device *SDp)
 
 	/* to do here: allocate memory; build a queue_full list */
 	if(SDp->tagged_supported) {
-		scsi_set_tag_type(SDp, MSG_ORDERED_TAG);
-		scsi_activate_tcq(SDp, NCR_700_DEFAULT_TAGS);
+		scsi_adjust_queue_depth(SDp, MSG_ORDERED_TAG, NCR_700_DEFAULT_TAGS);
 		NCR_700_set_tag_neg_state(SDp, NCR_700_START_TAG_NEGOTIATION);
 	} else {
 		/* initialise to default depth */
@@ -2094,8 +2094,6 @@ static int NCR_700_change_queue_type(struct scsi_device *SDp, int tag_type)
 	struct NCR_700_Host_Parameters *hostdata = 
 		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
 
-	scsi_set_tag_type(SDp, tag_type);
-
 	/* We have a global (per target) flag to track whether TCQ is
 	 * enabled, so we'll be turning it off for the entire target here.
 	 * our tag algorithm will fail if we mix tagged and untagged commands,
@@ -2106,12 +2104,12 @@ static int NCR_700_change_queue_type(struct scsi_device *SDp, int tag_type)
 	if (!tag_type) {
 		/* shift back to the default unqueued number of commands
 		 * (the user can still raise this) */
-		scsi_deactivate_tcq(SDp, SDp->host->cmd_per_lun);
+		scsi_adjust_queue_depth(SDp, 0, SDp->host->cmd_per_lun);
 		hostdata->tag_negotiated &= ~(1 << sdev_id(SDp));
 	} else {
 		/* Here, we cleared the negotiation flag above, so this
 		 * will force the driver to renegotiate */
-		scsi_activate_tcq(SDp, SDp->queue_depth);
+		scsi_adjust_queue_depth(SDp, tag_type, SDp->queue_depth);
 		if (change_tag)
 			NCR_700_set_tag_neg_state(SDp, NCR_700_START_TAG_NEGOTIATION);
 	}
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index d3b6d68..9fd6b56 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -925,6 +925,7 @@ struct scsi_host_template aic79xx_driver_template = {
 	.slave_configure	= ahd_linux_slave_configure,
 	.target_alloc		= ahd_linux_target_alloc,
 	.target_destroy		= ahd_linux_target_destroy,
+	.use_blk_tags		= 1,
 };
 
 /******************************** Bus DMA *************************************/
@@ -1468,12 +1469,12 @@ ahd_platform_set_tags(struct ahd_softc *ahd, struct scsi_device *sdev,
 
 	switch ((dev->flags & (AHD_DEV_Q_BASIC|AHD_DEV_Q_TAGGED))) {
 	case AHD_DEV_Q_BASIC:
-		scsi_set_tag_type(sdev, MSG_SIMPLE_TASK);
-		scsi_activate_tcq(sdev, dev->openings + dev->active);
+		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TASK,
+				dev->openings + dev->active);
 		break;
 	case AHD_DEV_Q_TAGGED:
-		scsi_set_tag_type(sdev, MSG_ORDERED_TASK);
-		scsi_activate_tcq(sdev, dev->openings + dev->active);
+		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TASK,
+				dev->openings + dev->active);
 		break;
 	default:
 		/*
@@ -1482,7 +1483,7 @@ ahd_platform_set_tags(struct ahd_softc *ahd, struct scsi_device *sdev,
 		 * serially on the controller/device.  This should
 		 * remove some latency.
 		 */
-		scsi_deactivate_tcq(sdev, 1);
+		scsi_adjust_queue_depth(sdev, 0, 1);
 		break;
 	}
 }
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 33a5f95..f18b6d6 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -812,6 +812,7 @@ struct scsi_host_template aic7xxx_driver_template = {
 	.slave_configure	= ahc_linux_slave_configure,
 	.target_alloc		= ahc_linux_target_alloc,
 	.target_destroy		= ahc_linux_target_destroy,
+	.use_blk_tags		= 1,
 };
 
 /**************************** Tasklet Handler *********************************/
@@ -1334,12 +1335,12 @@ ahc_platform_set_tags(struct ahc_softc *ahc, struct scsi_device *sdev,
 	}
 	switch ((dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED))) {
 	case AHC_DEV_Q_BASIC:
-		scsi_set_tag_type(sdev, MSG_SIMPLE_TAG);
-		scsi_activate_tcq(sdev, dev->openings + dev->active);
+		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TASK,
+				dev->openings + dev->active);
 		break;
 	case AHC_DEV_Q_TAGGED:
-		scsi_set_tag_type(sdev, MSG_ORDERED_TAG);
-		scsi_activate_tcq(sdev, dev->openings + dev->active);
+		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TASK,
+				dev->openings + dev->active);
 		break;
 	default:
 		/*
@@ -1348,7 +1349,7 @@ ahc_platform_set_tags(struct ahc_softc *ahc, struct scsi_device *sdev,
 		 * serially on the controller/device.  This should
 		 * remove some latency.
 		 */
-		scsi_deactivate_tcq(sdev, 2);
+		scsi_adjust_queue_depth(sdev, 0, 2);
 		break;
 	}
 }
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index c56741f..579dc2f 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -83,6 +83,7 @@ static struct scsi_host_template aic94xx_sht = {
 	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
+	.use_blk_tags		= 1,
 };
 
 static int asd_map_memio(struct asd_ha_struct *asd_ha)
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 99280e8..d8e43c8 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -776,11 +776,7 @@ bfad_thread_workq(struct bfad_s *bfad)
 static int
 bfad_im_slave_configure(struct scsi_device *sdev)
 {
-	if (sdev->tagged_supported)
-		scsi_activate_tcq(sdev, bfa_lun_queue_depth);
-	else
-		scsi_deactivate_tcq(sdev, bfa_lun_queue_depth);
-
+	scsi_adjust_queue_depth(sdev, 0, bfa_lun_queue_depth);
 	return 0;
 }
 
@@ -804,6 +800,7 @@ struct scsi_host_template bfad_im_scsi_host_template = {
 	.shost_attrs = bfad_im_host_attrs,
 	.max_sectors = BFAD_MAX_SECTORS,
 	.vendor_id = BFA_PCI_VENDOR_ID_BROCADE,
+	.use_blk_tags = 1,
 };
 
 struct scsi_host_template bfad_im_vport_template = {
@@ -825,6 +822,7 @@ struct scsi_host_template bfad_im_vport_template = {
 	.use_clustering = ENABLE_CLUSTERING,
 	.shost_attrs = bfad_im_vport_attrs,
 	.max_sectors = BFAD_MAX_SECTORS,
+	.use_blk_tags = 1,
 };
 
 bfa_status_t
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 3c6dc8a..cd2e610 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2790,6 +2790,7 @@ static struct scsi_host_template bnx2fc_shost_template = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.sg_tablesize		= BNX2FC_MAX_BDS_PER_CMD,
 	.max_sectors		= 1024,
+	.use_blk_tags		= 1,
 };
 
 static struct libfc_function_template bnx2fc_libfc_fcn_templ = {
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 8231505..f73155d 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2241,11 +2241,7 @@ csio_slave_alloc(struct scsi_device *sdev)
 static int
 csio_slave_configure(struct scsi_device *sdev)
 {
-	if (sdev->tagged_supported)
-		scsi_activate_tcq(sdev, csio_lun_qdepth);
-	else
-		scsi_deactivate_tcq(sdev, csio_lun_qdepth);
-
+	scsi_adjust_queue_depth(sdev, 0, csio_lun_qdepth);
 	return 0;
 }
 
@@ -2290,6 +2286,7 @@ struct scsi_host_template csio_fcoe_shost_template = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= csio_fcoe_lport_attrs,
 	.max_sectors		= CSIO_MAX_SECTOR_SIZE,
+	.use_blk_tags		= 1,
 };
 
 struct scsi_host_template csio_fcoe_shost_vport_template = {
@@ -2309,6 +2306,7 @@ struct scsi_host_template csio_fcoe_shost_vport_template = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= csio_fcoe_vport_attrs,
 	.max_sectors		= CSIO_MAX_SECTOR_SIZE,
+	.use_blk_tags		= 1,
 };
 
 /*
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index be09c62..a020b09 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -260,6 +260,7 @@ static struct scsi_host_template driver_template = {
 	.change_queue_depth		= esas2r_change_queue_depth,
 	.change_queue_type		= scsi_change_queue_type,
 	.max_sectors			= 0xFFFF,
+	.use_blk_tags			= 1,
 };
 
 int sgl_page_size = 512;
@@ -1278,13 +1279,10 @@ int esas2r_slave_configure(struct scsi_device *dev)
 	esas2r_log_dev(ESAS2R_LOG_INFO, &(dev->sdev_gendev),
 		       "esas2r_slave_configure()");
 
-	if (dev->tagged_supported) {
-		scsi_set_tag_type(dev, MSG_SIMPLE_TAG);
-		scsi_activate_tcq(dev, cmd_per_lun);
-	} else {
-		scsi_set_tag_type(dev, 0);
-		scsi_deactivate_tcq(dev, cmd_per_lun);
-	}
+	if (dev->tagged_supported)
+		scsi_adjust_queue_depth(dev, MSG_SIMPLE_TAG, cmd_per_lun);
+	else
+		scsi_adjust_queue_depth(dev, 0, cmd_per_lun);
 
 	return 0;
 }
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index b23101b..66b6ce1 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2419,10 +2419,9 @@ static int esp_slave_configure(struct scsi_device *dev)
 		queue_depth = dev->host->cmd_per_lun;
 
 	if (goal_tags) {
-		scsi_set_tag_type(dev, MSG_ORDERED_TAG);
-		scsi_activate_tcq(dev, queue_depth);
+		scsi_adjust_queue_depth(dev, MSG_ORDERED_TAG, queue_depth);
 	} else {
-		scsi_deactivate_tcq(dev, queue_depth);
+		scsi_adjust_queue_depth(dev, 0, queue_depth);
 	}
 	tp->flags |= ESP_TGT_DISCONNECT;
 
@@ -2631,6 +2630,7 @@ struct scsi_host_template scsi_esp_template = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.max_sectors		= 0xffff,
 	.skip_settle_delay	= 1,
+	.use_blk_tags		= 1,
 };
 EXPORT_SYMBOL(scsi_esp_template);
 
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 86956cc..a3eeb68 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -288,6 +288,7 @@ static struct scsi_host_template fcoe_shost_template = {
 	.use_clustering = ENABLE_CLUSTERING,
 	.sg_tablesize = SG_ALL,
 	.max_sectors = 0xffff,
+	.use_blk_tags = 1,
 };
 
 /**
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 8581ce6..2a6c98b 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -100,7 +100,7 @@ static int fnic_slave_alloc(struct scsi_device *sdev)
 	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
 
-	scsi_activate_tcq(sdev, fnic_max_qdepth);
+	scsi_adjust_queue_depth(sdev, 0, fnic_max_qdepth);
 	return 0;
 }
 
@@ -121,6 +121,7 @@ static struct scsi_host_template fnic_host_template = {
 	.sg_tablesize = FNIC_MAX_SG_DESC_CNT,
 	.max_sectors = 0xffff,
 	.shost_attrs = fnic_attrs,
+	.use_blk_tags = 1,
 };
 
 static void
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index a964f8c..4723d89 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2888,11 +2888,11 @@ static int ibmvfc_slave_configure(struct scsi_device *sdev)
 	if (sdev->type == TYPE_DISK)
 		sdev->allow_restart = 1;
 
-	if (sdev->tagged_supported) {
-		scsi_set_tag_type(sdev, MSG_SIMPLE_TAG);
-		scsi_activate_tcq(sdev, sdev->queue_depth);
-	} else
-		scsi_deactivate_tcq(sdev, sdev->queue_depth);
+	if (sdev->tagged_supported)
+		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG,
+				sdev->queue_depth);
+	else
+		scsi_adjust_queue_depth(sdev, 0, sdev->queue_depth);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	return 0;
 }
@@ -3108,6 +3108,7 @@ static struct scsi_host_template driver_template = {
 	.max_sectors = IBMVFC_MAX_SECTORS,
 	.use_clustering = ENABLE_CLUSTERING,
 	.shost_attrs = ibmvfc_attrs,
+	.use_blk_tags = 1,
 };
 
 /**
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index d6485a1..aa7359e 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6410,6 +6410,7 @@ static struct scsi_host_template driver_template = {
 	.sdev_attrs = ipr_dev_attrs,
 	.proc_name = IPR_NAME,
 	.no_write_same = 1,
+	.use_blk_tags = 1,
 };
 
 /**
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 2e890b1..8975620 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -172,6 +172,7 @@ static struct scsi_host_template isci_sht = {
 	.target_destroy			= sas_target_destroy,
 	.ioctl				= sas_ioctl,
 	.shost_attrs			= isci_host_attrs,
+	.use_blk_tags			= 1,
 };
 
 static struct sas_domain_function_template isci_transport_ops  = {
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index f3043ad..d4bb642 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2160,12 +2160,7 @@ int fc_slave_alloc(struct scsi_device *sdev)
 	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
 
-	if (sdev->tagged_supported)
-		scsi_activate_tcq(sdev, FC_FCP_DFLT_QUEUE_DEPTH);
-	else
-		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev),
-					FC_FCP_DFLT_QUEUE_DEPTH);
-
+	scsi_adjust_queue_depth(sdev, 0, FC_FCP_DFLT_QUEUE_DEPTH);
 	return 0;
 }
 EXPORT_SYMBOL(fc_slave_alloc);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 24e477d..eee21a0 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -940,15 +940,13 @@ int sas_slave_configure(struct scsi_device *scsi_dev)
 	sas_read_port_mode_page(scsi_dev);
 
 	if (scsi_dev->tagged_supported) {
-		scsi_set_tag_type(scsi_dev, MSG_SIMPLE_TAG);
-		scsi_activate_tcq(scsi_dev, SAS_DEF_QD);
+		scsi_adjust_queue_depth(scsi_dev, MSG_SIMPLE_TAG, SAS_DEF_QD);
 	} else {
 		SAS_DPRINTK("device %llx, LUN %llx doesn't support "
 			    "TCQ\n", SAS_ADDR(dev->sas_addr),
 			    scsi_dev->lun);
 		scsi_dev->tagged_supported = 0;
-		scsi_set_tag_type(scsi_dev, 0);
-		scsi_deactivate_tcq(scsi_dev, 1);
+		scsi_adjust_queue_depth(scsi_dev, 0, 1);
 	}
 
 	scsi_dev->allow_restart = 1;
@@ -991,10 +989,7 @@ int sas_change_queue_type(struct scsi_device *scsi_dev, int qt)
 	if (!scsi_dev->tagged_supported)
 		return 0;
 
-	scsi_deactivate_tcq(scsi_dev, 1);
-
-	scsi_set_tag_type(scsi_dev, qt);
-	scsi_activate_tcq(scsi_dev, scsi_dev->queue_depth);
+	scsi_adjust_queue_depth(scsi_dev, qt, scsi_dev->queue_depth);
 
 	return qt;
 }
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 4a15006..a24106a 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5598,10 +5598,7 @@ lpfc_slave_configure(struct scsi_device *sdev)
 	struct lpfc_vport *vport = (struct lpfc_vport *) sdev->host->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	if (sdev->tagged_supported)
-		scsi_activate_tcq(sdev, vport->cfg_lun_queue_depth);
-	else
-		scsi_deactivate_tcq(sdev, vport->cfg_lun_queue_depth);
+	scsi_adjust_queue_depth(sdev, 0, vport->cfg_lun_queue_depth);
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
 		lpfc_sli_handle_fast_ring_event(phba,
@@ -5986,6 +5983,7 @@ struct scsi_host_template lpfc_template = {
 	.vendor_id		= LPFC_NL_VENDOR_ID,
 	.change_queue_depth	= lpfc_change_queue_depth,
 	.change_queue_type	= scsi_change_queue_type,
+	.use_blk_tags		= 1,
 };
 
 struct scsi_host_template lpfc_vport_template = {
@@ -6009,4 +6007,5 @@ struct scsi_host_template lpfc_vport_template = {
 	.max_sectors		= 0xFFFF,
 	.change_queue_depth	= lpfc_change_queue_depth,
 	.change_queue_type	= scsi_change_queue_type,
+	.use_blk_tags		= 1,
 };
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index eacee48..d3c1fa5 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -76,6 +76,7 @@ static struct scsi_host_template mvs_sht = {
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= mvst_host_attrs,
+	.use_blk_tags		= 1,
 };
 
 static struct sas_domain_function_template mvs_transport_ops = {
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 666bf5a..3ff759a 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -89,6 +89,7 @@ static struct scsi_host_template pm8001_sht = {
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= pm8001_host_attrs,
+	.use_blk_tags		= 1,
 };
 
 /**
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index d5fb31fa..71f9f59 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -251,7 +251,6 @@ static int pmcraid_slave_configure(struct scsi_device *scsi_dev)
 
 	if (scsi_dev->tagged_supported &&
 	    (RES_IS_GSCSI(res->cfg_entry) || RES_IS_VSET(res->cfg_entry))) {
-		scsi_activate_tcq(scsi_dev, scsi_dev->queue_depth);
 		scsi_adjust_queue_depth(scsi_dev, MSG_SIMPLE_TAG,
 					scsi_dev->host->cmd_per_lun);
 	} else {
@@ -4295,7 +4294,8 @@ static struct scsi_host_template pmcraid_host_template = {
 	.cmd_per_lun = PMCRAID_MAX_CMD_PER_LUN,
 	.use_clustering = ENABLE_CLUSTERING,
 	.shost_attrs = pmcraid_host_attrs,
-	.proc_name = PMCRAID_DRIVER_NAME
+	.proc_name = PMCRAID_DRIVER_NAME,
+	.use_blk_tags = 1,
 };
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1e34fcf..eb04653 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -269,6 +269,7 @@ struct scsi_host_template qla2xxx_driver_template = {
 	.shost_attrs		= qla2x00_host_attrs,
 
 	.supported_mode		= MODE_INITIATOR,
+	.use_blk_tags		= 1,
 };
 
 static struct scsi_transport_template *qla2xxx_transport_template = NULL;
@@ -1404,10 +1405,7 @@ qla2xxx_slave_configure(struct scsi_device *sdev)
 	if (IS_T10_PI_CAPABLE(vha->hw))
 		blk_queue_update_dma_alignment(sdev->request_queue, 0x7);
 
-	if (sdev->tagged_supported)
-		scsi_activate_tcq(sdev, req->max_q_depth);
-	else
-		scsi_deactivate_tcq(sdev, req->max_q_depth);
+	scsi_adjust_queue_depth(sdev, 0, req->max_q_depth);
 	return 0;
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 199fcf7..f3119c1 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -163,7 +163,6 @@ static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_slave_alloc(struct scsi_device *device);
 static int qla4xxx_slave_configure(struct scsi_device *device);
-static void qla4xxx_slave_destroy(struct scsi_device *sdev);
 static umode_t qla4_attr_is_visible(int param_type, int param);
 static int qla4xxx_host_reset(struct Scsi_Host *shost, int reset_type);
 static int qla4xxx_change_queue_depth(struct scsi_device *sdev, int qdepth,
@@ -206,7 +205,6 @@ static struct scsi_host_template qla4xxx_driver_template = {
 
 	.slave_configure	= qla4xxx_slave_configure,
 	.slave_alloc		= qla4xxx_slave_alloc,
-	.slave_destroy		= qla4xxx_slave_destroy,
 	.change_queue_depth	= qla4xxx_change_queue_depth,
 
 	.this_id		= -1,
@@ -218,6 +216,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.shost_attrs		= qla4xxx_host_attrs,
 	.host_reset		= qla4xxx_host_reset,
 	.vendor_id		= SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_QLOGIC,
+	.use_blk_tags		= 1,
 };
 
 static struct iscsi_transport qla4xxx_iscsi_transport = {
@@ -9065,7 +9064,7 @@ static int qla4xxx_slave_alloc(struct scsi_device *sdev)
 	if (ql4xmaxqdepth != 0 && ql4xmaxqdepth <= 0xffffU)
 		queue_depth = ql4xmaxqdepth;
 
-	scsi_activate_tcq(sdev, queue_depth);
+	scsi_adjust_queue_depth(sdev, 0, queue_depth);
 	return 0;
 }
 
@@ -9075,11 +9074,6 @@ static int qla4xxx_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
-static void qla4xxx_slave_destroy(struct scsi_device *sdev)
-{
-	scsi_deactivate_tcq(sdev, 1);
-}
-
 static int qla4xxx_change_queue_depth(struct scsi_device *sdev, int qdepth,
 				      int reason)
 {
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 22c449e..a3426f1 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -864,16 +864,12 @@ EXPORT_SYMBOL(scsi_track_queue_full);
  */
 int scsi_change_queue_type(struct scsi_device *sdev, int tag_type)
 {
-	if (sdev->tagged_supported) {
-		scsi_set_tag_type(sdev, tag_type);
-		if (tag_type)
-			scsi_activate_tcq(sdev, sdev->queue_depth);
-		else
-			scsi_deactivate_tcq(sdev, sdev->queue_depth);
-	} else
-		tag_type = 0;
+	if (!sdev->tagged_supported)
+		return 0;
 
+	scsi_adjust_queue_depth(sdev, tag_type, sdev->queue_depth);
 	return tag_type;
+
 }
 EXPORT_SYMBOL(scsi_change_queue_type);
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index b1aa164..408891c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -286,6 +286,12 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	}
 	WARN_ON_ONCE(!blk_get_queue(sdev->request_queue));
 	sdev->request_queue->queuedata = sdev;
+
+	if (!shost_use_blk_mq(sdev->host) &&
+	    (shost->bqt || shost->hostt->use_blk_tags)) {
+		blk_queue_init_tags(sdev->request_queue,
+				    sdev->host->cmd_per_lun, shost->bqt);
+	}
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 
 	scsi_sysfs_device_initialize(sdev);
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 713af13..b5eae4f 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -549,7 +549,7 @@ stex_slave_alloc(struct scsi_device *sdev)
 	/* Cheat: usually extracted from Inquiry data */
 	sdev->tagged_supported = 1;
 
-	scsi_activate_tcq(sdev, sdev->host->can_queue);
+	scsi_adjust_queue_depth(sdev, 0, sdev->host->can_queue);
 
 	return 0;
 }
@@ -565,12 +565,6 @@ stex_slave_config(struct scsi_device *sdev)
 	return 0;
 }
 
-static void
-stex_slave_destroy(struct scsi_device *sdev)
-{
-	scsi_deactivate_tcq(sdev, 1);
-}
-
 static int
 stex_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
@@ -1390,10 +1384,10 @@ static struct scsi_host_template driver_template = {
 	.queuecommand			= stex_queuecommand,
 	.slave_alloc			= stex_slave_alloc,
 	.slave_configure		= stex_slave_config,
-	.slave_destroy			= stex_slave_destroy,
 	.eh_abort_handler		= stex_abort,
 	.eh_host_reset_handler		= stex_reset,
 	.this_id			= -1,
+	.use_blk_tags			= 1,
 };
 
 static struct pci_device_id stex_pci_tbl[] = {
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 5478124..6369f9a 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2187,7 +2187,7 @@ static int dc390_slave_configure(struct scsi_device *sdev)
 	acb->scan_devices = 0;
 	if (sdev->tagged_supported && (dcb->DevMode & TAG_QUEUEING_)) {
 		dcb->SyncMode |= EN_TAG_QUEUEING;
-		scsi_activate_tcq(sdev, acb->TagMaxNum);
+		scsi_adjust_queue_depth(sdev, 0, acb->TagMaxNum);
 	}
 
 	return 0;
@@ -2209,6 +2209,7 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.max_sectors		= 0x4000, /* 8MiB = 16 * 1024 * 512 */
+	.use_blk_tags		= 1,
 };
 
 /***********************************************************************
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9da3191..48c7f9e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2695,7 +2695,8 @@ static void ufshcd_set_queue_depth(struct scsi_device *sdev)
 
 	dev_dbg(hba->dev, "%s: activate tcq with queue depth %d\n",
 			__func__, lun_qdepth);
-	scsi_activate_tcq(sdev, lun_qdepth);
+	if (sdev->tagged_supported)
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), lun_qdepth);
 }
 
 /*
@@ -2842,7 +2843,6 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
 	struct ufs_hba *hba;
 
 	hba = shost_priv(sdev->host);
-	scsi_deactivate_tcq(sdev, hba->nutrs);
 	/* Drop the reference as it won't be needed anymore */
 	if (ufshcd_scsi_to_upiu_lun(sdev->lun) == UFS_UPIU_UFS_DEVICE_WLUN)
 		hba->sdev_ufs_device = NULL;
@@ -4235,6 +4235,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
 	.can_queue		= UFSHCD_CAN_QUEUE,
 	.max_host_blocked	= 1,
+	.use_blk_tags		= 1,
 };
 
 static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index e30932f..120a851 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -407,7 +407,6 @@ static int tcm_loop_slave_alloc(struct scsi_device *sd)
 static int tcm_loop_slave_configure(struct scsi_device *sd)
 {
 	if (sd->tagged_supported) {
-		scsi_activate_tcq(sd, sd->queue_depth);
 		scsi_adjust_queue_depth(sd, MSG_SIMPLE_TAG,
 					sd->host->cmd_per_lun);
 	} else {
@@ -437,6 +436,7 @@ static struct scsi_host_template tcm_loop_driver_template = {
 	.slave_alloc		= tcm_loop_slave_alloc,
 	.slave_configure	= tcm_loop_slave_configure,
 	.module			= THIS_MODULE,
+	.use_blk_tags		= 1,
 };
 
 static int tcm_loop_driver_probe(struct device *dev)
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 1bc5df4..ee69b82 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -799,8 +799,7 @@ static int uas_slave_configure(struct scsi_device *sdev)
 	if (devinfo->flags & US_FL_NO_REPORT_OPCODES)
 		sdev->no_report_opcodes = 1;
 
-	scsi_set_tag_type(sdev, MSG_ORDERED_TAG);
-	scsi_activate_tcq(sdev, devinfo->qdepth - 2);
+	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, devinfo->qdepth - 2);
 	return 0;
 }
 
@@ -824,6 +823,7 @@ static struct scsi_host_template uas_host_template = {
 	 * allocator.
 	 */
 	.disable_blk_mq = true,
+	.use_blk_tags = 1,
 };
 
 #define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 8bf2cb0..0762ebe 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -422,6 +422,11 @@ struct scsi_host_template {
 	unsigned char present;
 
 	/*
+	 * Let the block layer assigns tags to all commands.
+	 */
+	unsigned use_blk_tags:1;
+
+	/*
 	 * This specifies the mode that a LLD supports.
 	 */
 	unsigned supported_mode:2;
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index 6124127..070adef 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -45,40 +45,6 @@ static inline void scsi_set_tag_type(struct scsi_device *sdev, int tag)
 		break;
 	}
 }
-/**
- * scsi_activate_tcq - turn on tag command queueing
- * @SDpnt:	device to turn on TCQ for
- * @depth:	queue depth
- *
- * Notes:
- *	Eventually, I hope depth would be the maximum depth
- *	the device could cope with and the real queue depth
- *	would be adjustable from 0 to depth.
- **/
-static inline void scsi_activate_tcq(struct scsi_device *sdev, int depth)
-{
-	if (!sdev->tagged_supported)
-		return;
-
-	if (shost_use_blk_mq(sdev->host))
-		queue_flag_set_unlocked(QUEUE_FLAG_QUEUED, sdev->request_queue);
-	else if (!blk_queue_tagged(sdev->request_queue))
-		blk_queue_init_tags(sdev->request_queue, depth,
-				    sdev->host->bqt);
-
-	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
-}
-
-/**
- * scsi_deactivate_tcq - turn off tag command queueing
- * @SDpnt:	device to turn off TCQ for
- **/
-static inline void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
-{
-	if (blk_queue_tagged(sdev->request_queue))
-		blk_queue_free_tags(sdev->request_queue);
-	scsi_adjust_queue_depth(sdev, 0, depth);
-}
 
 static inline struct scsi_cmnd *scsi_mq_find_tag(struct Scsi_Host *shost,
 		unsigned int hw_ctx, int tag)
-- 
1.9.1

