From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi: use host wide tags by default
Date: Thu,  8 Oct 2015 09:28:04 +0100
Message-ID: <1444292884-8622-2-git-send-email-hch@lst.de>
References: <1444292884-8622-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49714 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbbJHIby (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2015 04:31:54 -0400
In-Reply-To: <1444292884-8622-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: axboe@kernel.dk

This patch changes the !blk-mq path to the same defaults as the blk-mq
I/O path by always enabling block tagging, and always using host wide
tags.  We've had blk-mq available for a few releases so bugs with
this mode should have been ironed out, and this ensures we get better
coverage of over tagging setup over different configs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/ata/libata-scsi.c                 |  3 -
 drivers/infiniband/ulp/srp/ib_srp.c       |  5 --
 drivers/message/fusion/mptsas.c           |  1 -
 drivers/scsi/53c700.c                     | 11 ++--
 drivers/scsi/advansys.c                   |  6 --
 drivers/scsi/aic7xxx/aic79xx_osm.c        |  1 -
 drivers/scsi/aic7xxx/aic7xxx_osm.c        |  1 -
 drivers/scsi/aic94xx/aic94xx_init.c       |  1 -
 drivers/scsi/bfa/bfad_im.c                |  2 -
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c         |  1 -
 drivers/scsi/csiostor/csio_scsi.c         |  2 -
 drivers/scsi/esas2r/esas2r_main.c         |  1 -
 drivers/scsi/esp_scsi.c                   |  1 -
 drivers/scsi/fcoe/fcoe.c                  |  1 -
 drivers/scsi/fnic/fnic_main.c             |  8 ---
 drivers/scsi/hosts.c                      |  7 +++
 drivers/scsi/hpsa.c                       | 10 +---
 drivers/scsi/ibmvscsi/ibmvfc.c            |  1 -
 drivers/scsi/ipr.c                        |  1 -
 drivers/scsi/isci/init.c                  |  1 -
 drivers/scsi/lpfc/lpfc_scsi.c             |  3 -
 drivers/scsi/megaraid/megaraid_sas_base.c |  8 ---
 drivers/scsi/mvsas/mv_init.c              |  1 -
 drivers/scsi/pm8001/pm8001_init.c         |  1 -
 drivers/scsi/pmcraid.c                    |  1 -
 drivers/scsi/qla2xxx/qla_os.c             |  1 -
 drivers/scsi/qla4xxx/ql4_os.c             |  8 ---
 drivers/scsi/scsi.c                       | 27 +--------
 drivers/scsi/scsi_scan.c                  |  3 +-
 drivers/scsi/snic/snic_main.c             | 10 ----
 drivers/scsi/stex.c                       |  8 ---
 drivers/scsi/ufs/ufshcd.c                 |  8 ---
 drivers/target/loopback/tcm_loop.c        |  1 -
 drivers/usb/storage/uas.c                 |  5 --
 include/scsi/scsi_host.h                  |  5 --
 include/scsi/scsi_tcq.h                   | 95 +++++++------------------------
 36 files changed, 39 insertions(+), 211 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 3131adc..3050fc7 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3705,9 +3705,6 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		 */
 		shost->max_host_blocked = 1;
 
-		if (scsi_init_shared_tag_map(shost, host->n_tags))
-			goto err_add;
-
 		rc = scsi_add_host_with_dma(ap->scsi_host,
 						&ap->tdev, ap->host->dev);
 		if (rc)
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 267dc4f..b8a214a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2745,7 +2745,6 @@ static struct scsi_host_template srp_template = {
 	.cmd_per_lun			= SRP_DEFAULT_CMD_SQ_SIZE,
 	.use_clustering			= ENABLE_CLUSTERING,
 	.shost_attrs			= srp_host_attrs,
-	.use_blk_tags			= 1,
 	.track_queue_depth		= 1,
 };
 
@@ -3169,10 +3168,6 @@ static ssize_t srp_create_target(struct device *dev,
 	if (ret)
 		goto out;
 
-	ret = scsi_init_shared_tag_map(target_host, target_host->can_queue);
-	if (ret)
-		goto out;
-
 	target->req_ring_size = target->queue_size - SRP_TSK_MGMT_SQ_SIZE;
 
 	if (!srp_conn_unique(target->srp_host, target)) {
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 005a88b..7ebccfa 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1994,7 +1994,6 @@ static struct scsi_host_template mptsas_driver_template = {
 	.cmd_per_lun			= 7,
 	.use_clustering			= ENABLE_CLUSTERING,
 	.shost_attrs			= mptscsih_host_attrs,
-	.use_blk_tags			= 1,
 };
 
 static int mptsas_get_linkerrors(struct sas_phy *phy)
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 82abfce..c80d680 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -325,7 +325,6 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	tpnt->slave_destroy = NCR_700_slave_destroy;
 	tpnt->slave_alloc = NCR_700_slave_alloc;
 	tpnt->change_queue_depth = NCR_700_change_queue_depth;
-	tpnt->use_blk_tags = 1;
 
 	if(tpnt->name == NULL)
 		tpnt->name = "53c700";
@@ -1107,7 +1106,9 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 			BUG();
 		}
 		if(hostdata->msgin[1] == A_SIMPLE_TAG_MSG) {
-			struct scsi_cmnd *SCp = scsi_find_tag(SDp, hostdata->msgin[2]);
+			struct scsi_cmnd *SCp;
+
+			SCp = scsi_host_find_tag(SDp->host, hostdata->msgin[2]);
 			if(unlikely(SCp == NULL)) {
 				printk(KERN_ERR "scsi%d: (%d:%d) no saved request for tag %d\n", 
 				       host->host_no, reselection_id, lun, hostdata->msgin[2]);
@@ -1119,7 +1120,9 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 				"reselection is tag %d, slot %p(%d)\n",
 				hostdata->msgin[2], slot, slot->tag);
 		} else {
-			struct scsi_cmnd *SCp = scsi_find_tag(SDp, SCSI_NO_TAG);
+			struct scsi_cmnd *SCp;
+
+			SCp = scsi_host_find_tag(SDp->host, SCSI_NO_TAG);
 			if(unlikely(SCp == NULL)) {
 				sdev_printk(KERN_ERR, SDp,
 					"no saved request for untagged cmd\n");
@@ -1823,7 +1826,7 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *)
 		       slot->tag, slot);
 	} else {
 		slot->tag = SCSI_NO_TAG;
-		/* must populate current_cmnd for scsi_find_tag to work */
+		/* must populate current_cmnd for scsi_host_find_tag to work */
 		SCp->device->current_cmnd = SCp;
 	}
 	/* sanity check: some of the commands generated by the mid-layer
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 4305178..519f9a4 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -10819,7 +10819,6 @@ static struct scsi_host_template advansys_template = {
 	 * by enabling clustering, I/O throughput increases as well.
 	 */
 	.use_clustering = ENABLE_CLUSTERING,
-	.use_blk_tags = 1,
 };
 
 static int advansys_wide_init_chip(struct Scsi_Host *shost)
@@ -11211,11 +11210,6 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
 		/* Set maximum number of queues the adapter can handle. */
 		shost->can_queue = adv_dvc_varp->max_host_qng;
 	}
-	ret = scsi_init_shared_tag_map(shost, shost->can_queue);
-	if (ret) {
-		shost_printk(KERN_ERR, shost, "init tag map failed\n");
-		goto err_free_dma;
-	}
 
 	/*
 	 * Set the maximum number of scatter-gather elements the
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index ce96a0b..2588b8f 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -925,7 +925,6 @@ struct scsi_host_template aic79xx_driver_template = {
 	.slave_configure	= ahd_linux_slave_configure,
 	.target_alloc		= ahd_linux_target_alloc,
 	.target_destroy		= ahd_linux_target_destroy,
-	.use_blk_tags		= 1,
 };
 
 /******************************** Bus DMA *************************************/
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index a2f2c77..b846a46 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -812,7 +812,6 @@ struct scsi_host_template aic7xxx_driver_template = {
 	.slave_configure	= ahc_linux_slave_configure,
 	.target_alloc		= ahc_linux_target_alloc,
 	.target_destroy		= ahc_linux_target_destroy,
-	.use_blk_tags		= 1,
 };
 
 /**************************** Tasklet Handler *********************************/
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 31e8576..ab1ef3c 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -73,7 +73,6 @@ static struct scsi_host_template aic94xx_sht = {
 	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
-	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
 
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 8367c11..299c6f8 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -800,7 +800,6 @@ struct scsi_host_template bfad_im_scsi_host_template = {
 	.shost_attrs = bfad_im_host_attrs,
 	.max_sectors = BFAD_MAX_SECTORS,
 	.vendor_id = BFA_PCI_VENDOR_ID_BROCADE,
-	.use_blk_tags = 1,
 };
 
 struct scsi_host_template bfad_im_vport_template = {
@@ -822,7 +821,6 @@ struct scsi_host_template bfad_im_vport_template = {
 	.use_clustering = ENABLE_CLUSTERING,
 	.shost_attrs = bfad_im_vport_attrs,
 	.max_sectors = BFAD_MAX_SECTORS,
-	.use_blk_tags = 1,
 };
 
 bfa_status_t
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 98d06d1..c741d1c8 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2797,7 +2797,6 @@ static struct scsi_host_template bnx2fc_shost_template = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.sg_tablesize		= BNX2FC_MAX_BDS_PER_CMD,
 	.max_sectors		= 1024,
-	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
 
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 2c4562d..c2a6f9f 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2283,7 +2283,6 @@ struct scsi_host_template csio_fcoe_shost_template = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= csio_fcoe_lport_attrs,
 	.max_sectors		= CSIO_MAX_SECTOR_SIZE,
-	.use_blk_tags		= 1,
 };
 
 struct scsi_host_template csio_fcoe_shost_vport_template = {
@@ -2303,7 +2302,6 @@ struct scsi_host_template csio_fcoe_shost_vport_template = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= csio_fcoe_vport_attrs,
 	.max_sectors		= CSIO_MAX_SECTOR_SIZE,
-	.use_blk_tags		= 1,
 };
 
 /*
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 31f8966..33581ba 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -256,7 +256,6 @@ static struct scsi_host_template driver_template = {
 	.proc_name			= ESAS2R_DRVR_NAME,
 	.change_queue_depth		= scsi_change_queue_depth,
 	.max_sectors			= 0xFFFF,
-	.use_blk_tags			= 1,
 };
 
 int sgl_page_size = 512;
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 065b25d..71cb05b 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2694,7 +2694,6 @@ struct scsi_host_template scsi_esp_template = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.max_sectors		= 0xffff,
 	.skip_settle_delay	= 1,
-	.use_blk_tags		= 1,
 };
 EXPORT_SYMBOL(scsi_esp_template);
 
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index d3eb80c..1d7eb60 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -287,7 +287,6 @@ static struct scsi_host_template fcoe_shost_template = {
 	.use_clustering = ENABLE_CLUSTERING,
 	.sg_tablesize = SG_ALL,
 	.max_sectors = 0xffff,
-	.use_blk_tags = 1,
 	.track_queue_depth = 1,
 };
 
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 8a0d4d7..58ce902 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -118,7 +118,6 @@ static struct scsi_host_template fnic_host_template = {
 	.sg_tablesize = FNIC_MAX_SG_DESC_CNT,
 	.max_sectors = 0xffff,
 	.shost_attrs = fnic_attrs,
-	.use_blk_tags = 1,
 	.track_queue_depth = 1,
 };
 
@@ -697,13 +696,6 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	fnic->fnic_max_tag_id = host->can_queue;
 
-	err = scsi_init_shared_tag_map(host, fnic->fnic_max_tag_id);
-	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			  "Unable to alloc shared tag map\n");
-		goto err_out_dev_close;
-	}
-
 	host->max_lun = fnic->config.luns_per_tgt;
 	host->max_id = FNIC_MAX_FCP_TARGET;
 	host->max_cmd_len = FCOE_MAX_CMD_LEN;
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8bb173e..323982f 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -217,6 +217,13 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 		error = scsi_mq_setup_tags(shost);
 		if (error)
 			goto fail;
+	} else {
+		shost->bqt = blk_init_tags(shost->can_queue,
+				shost->hostt->tag_alloc_policy);
+		if (!shost->bqt) {
+			error = -ENOMEM;
+			goto fail;
+		}
 	}
 
 	/*
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 40669f8..7506b65 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4983,7 +4983,6 @@ static int hpsa_scan_finished(struct Scsi_Host *sh,
 static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 {
 	struct Scsi_Host *sh;
-	int error;
 
 	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(h));
 	if (sh == NULL) {
@@ -5004,14 +5003,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 	sh->hostdata[0] = (unsigned long) h;
 	sh->irq = h->intr[h->intr_mode];
 	sh->unique_id = sh->irq;
-	error = scsi_init_shared_tag_map(sh, sh->can_queue);
-	if (error) {
-		dev_err(&h->pdev->dev,
-			"%s: scsi_init_shared_tag_map failed for controller %d\n",
-			__func__, h->ctlr);
-			scsi_host_put(sh);
-			return error;
-	}
+
 	h->scsi_host = sh;
 	return 0;
 }
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 057d277..6aa317c 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3095,7 +3095,6 @@ static struct scsi_host_template driver_template = {
 	.max_sectors = IBMVFC_MAX_SECTORS,
 	.use_clustering = ENABLE_CLUSTERING,
 	.shost_attrs = ibmvfc_attrs,
-	.use_blk_tags = 1,
 	.track_queue_depth = 1,
 };
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index b62836d..4f2c167 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6502,7 +6502,6 @@ static struct scsi_host_template driver_template = {
 	.shost_attrs = ipr_ioa_attrs,
 	.sdev_attrs = ipr_dev_attrs,
 	.proc_name = IPR_NAME,
-	.use_blk_tags = 1,
 };
 
 /**
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 0dfcabe..2f973df 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -170,7 +170,6 @@ static struct scsi_host_template isci_sht = {
 	.target_destroy			= sas_target_destroy,
 	.ioctl				= sas_ioctl,
 	.shost_attrs			= isci_host_attrs,
-	.use_blk_tags			= 1,
 	.track_queue_depth		= 1,
 };
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index e5eb40d..d3665cf 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5926,7 +5926,6 @@ struct scsi_host_template lpfc_template_s3 = {
 	.max_sectors		= 0xFFFF,
 	.vendor_id		= LPFC_NL_VENDOR_ID,
 	.change_queue_depth	= scsi_change_queue_depth,
-	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
 
@@ -5952,7 +5951,6 @@ struct scsi_host_template lpfc_template = {
 	.max_sectors		= 0xFFFF,
 	.vendor_id		= LPFC_NL_VENDOR_ID,
 	.change_queue_depth	= scsi_change_queue_depth,
-	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
 
@@ -5976,6 +5974,5 @@ struct scsi_host_template lpfc_vport_template = {
 	.shost_attrs		= lpfc_vport_attrs,
 	.max_sectors		= 0xFFFF,
 	.change_queue_depth	= scsi_change_queue_depth,
-	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index eaa81e5..3b3f480 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5049,7 +5049,6 @@ static int megasas_start_aen(struct megasas_instance *instance)
 static int megasas_io_attach(struct megasas_instance *instance)
 {
 	struct Scsi_Host *host = instance->host;
-	u32 error;
 
 	/*
 	 * Export parameters required by SCSI mid-layer
@@ -5099,13 +5098,6 @@ static int megasas_io_attach(struct megasas_instance *instance)
 		host->hostt->eh_device_reset_handler = NULL;
 		host->hostt->eh_bus_reset_handler = NULL;
 	}
-	error = scsi_init_shared_tag_map(host, host->can_queue);
-	if (error) {
-		dev_err(&instance->pdev->dev,
-			"Failed to shared tag from %s %d\n",
-			__func__, __LINE__);
-		return -ENODEV;
-	}
 
 	/*
 	 * Notify the mid-layer about the new controller
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index f466a6a..1b069a3 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -65,7 +65,6 @@ static struct scsi_host_template mvs_sht = {
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= mvst_host_attrs,
-	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
 
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 5c0356f..e64b8bf 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -88,7 +88,6 @@ static struct scsi_host_template pm8001_sht = {
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= pm8001_host_attrs,
-	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
 
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index ed31d8c..48d6224 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4254,7 +4254,6 @@ static struct scsi_host_template pmcraid_host_template = {
 	.use_clustering = ENABLE_CLUSTERING,
 	.shost_attrs = pmcraid_host_attrs,
 	.proc_name = PMCRAID_DRIVER_NAME,
-	.use_blk_tags = 1,
 };
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 913a725..26614c2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -267,7 +267,6 @@ struct scsi_host_template qla2xxx_driver_template = {
 	.shost_attrs		= qla2x00_host_attrs,
 
 	.supported_mode		= MODE_INITIATOR,
-	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6d25879..01c3610 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -212,7 +212,6 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.shost_attrs		= qla4xxx_host_attrs,
 	.host_reset		= qla4xxx_host_reset,
 	.vendor_id		= SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_QLOGIC,
-	.use_blk_tags		= 1,
 };
 
 static struct iscsi_transport qla4xxx_iscsi_transport = {
@@ -8697,13 +8696,6 @@ static int qla4xxx_probe_adapter(struct pci_dev *pdev,
 	host->can_queue = MAX_SRBS ;
 	host->transportt = qla4xxx_scsi_transport;
 
-	ret = scsi_init_shared_tag_map(host, MAX_SRBS);
-	if (ret) {
-		ql4_printk(KERN_WARNING, ha,
-			   "%s: scsi_init_shared_tag_map failed\n", __func__);
-		goto probe_failed;
-	}
-
 	pci_set_drvdata(pdev, ha);
 
 	ret = scsi_add_host(host, &pdev->dev);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 207d6a7..d07fb65 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -616,32 +616,11 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
  */
 int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
 {
-	unsigned long flags;
-
-	if (depth <= 0)
-		goto out;
-
-	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-
-	/*
-	 * Check to see if the queue is managed by the block layer.
-	 * If it is, and we fail to adjust the depth, exit.
-	 *
-	 * Do not resize the tag map if it is a host wide share bqt,
-	 * because the size should be the hosts's can_queue. If there
-	 * is more IO than the LLD's can_queue (so there are not enuogh
-	 * tags) request_fn's host queue ready check will handle it.
-	 */
-	if (!shost_use_blk_mq(sdev->host) && !sdev->host->bqt) {
-		if (blk_queue_tagged(sdev->request_queue) &&
-		    blk_queue_resize_tags(sdev->request_queue, depth) != 0)
-			goto out_unlock;
+	if (depth > 0) {
+		sdev->queue_depth = depth;
+		wmb();
 	}
 
-	sdev->queue_depth = depth;
-out_unlock:
-	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
-out:
 	return sdev->queue_depth;
 }
 EXPORT_SYMBOL(scsi_change_queue_depth);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f9f3f82..998f378 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -274,8 +274,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	WARN_ON_ONCE(!blk_get_queue(sdev->request_queue));
 	sdev->request_queue->queuedata = sdev;
 
-	if (!shost_use_blk_mq(sdev->host) &&
-	    (shost->bqt || shost->hostt->use_blk_tags)) {
+	if (!shost_use_blk_mq(sdev->host)) {
 		blk_queue_init_tags(sdev->request_queue,
 				    sdev->host->cmd_per_lun, shost->bqt,
 				    shost->hostt->tag_alloc_policy);
diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index b2b87ce..2b3c253 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -124,7 +124,6 @@ static struct scsi_host_template snic_host_template = {
 	.sg_tablesize = SNIC_MAX_SG_DESC_CNT,
 	.max_sectors = 0x800,
 	.shost_attrs = snic_attrs,
-	.use_blk_tags = 1,
 	.track_queue_depth = 1,
 	.cmd_size = sizeof(struct snic_internal_io_state),
 	.proc_name = "snic_scsi",
@@ -533,15 +532,6 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	snic->max_tag_id = shost->can_queue;
 
-	ret = scsi_init_shared_tag_map(shost, snic->max_tag_id);
-	if (ret) {
-		SNIC_HOST_ERR(shost,
-			      "Unable to alloc shared tag map. %d\n",
-			      ret);
-
-		goto err_dev_close;
-	}
-
 	shost->max_lun = snic->config.luns_per_tgt;
 	shost->max_id = SNIC_MAX_TARGET;
 
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 98a62bc..56353cd 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1374,7 +1374,6 @@ static struct scsi_host_template driver_template = {
 	.eh_abort_handler		= stex_abort,
 	.eh_host_reset_handler		= stex_reset,
 	.this_id			= -1,
-	.use_blk_tags			= 1,
 };
 
 static struct pci_device_id stex_pci_tbl[] = {
@@ -1659,13 +1658,6 @@ static int stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto out_free_irq;
 
-	err = scsi_init_shared_tag_map(host, host->can_queue);
-	if (err) {
-		printk(KERN_ERR DRV_NAME "(%s): init shared queue failed\n",
-			pci_name(pdev));
-		goto out_free_irq;
-	}
-
 	pci_set_drvdata(pdev, hba);
 
 	err = scsi_add_host(host, &pdev->dev);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b0ade73..9065eb4 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4355,7 +4355,6 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
 	.can_queue		= UFSHCD_CAN_QUEUE,
 	.max_host_blocked	= 1,
-	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
 
@@ -5619,13 +5618,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		hba->is_irq_enabled = true;
 	}
 
-	/* Enable SCSI tag mapping */
-	err = scsi_init_shared_tag_map(host, host->can_queue);
-	if (err) {
-		dev_err(hba->dev, "init shared queue failed\n");
-		goto exit_gating;
-	}
-
 	err = scsi_add_host(host, hba->dev);
 	if (err) {
 		dev_err(hba->dev, "scsi_add_host failed\n");
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index a556bde..e482c1b 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -377,7 +377,6 @@ static struct scsi_host_template tcm_loop_driver_template = {
 	.use_clustering		= DISABLE_CLUSTERING,
 	.slave_alloc		= tcm_loop_slave_alloc,
 	.module			= THIS_MODULE,
-	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
 
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index f689219..2850663 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -812,7 +812,6 @@ static struct scsi_host_template uas_host_template = {
 	.this_id = -1,
 	.sg_tablesize = SG_NONE,
 	.skip_settle_delay = 1,
-	.use_blk_tags = 1,
 };
 
 #define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
@@ -929,10 +928,6 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	if (result)
 		goto set_alt0;
 
-	result = scsi_init_shared_tag_map(shost, devinfo->qdepth - 2);
-	if (result)
-		goto free_streams;
-
 	usb_set_intfdata(intf, shost);
 	result = scsi_add_host(shost, &intf->dev);
 	if (result)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index e113c75..ed52712 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -406,11 +406,6 @@ struct scsi_host_template {
 	int tag_alloc_policy;
 
 	/*
-	 * Let the block layer assigns tags to all commands.
-	 */
-	unsigned use_blk_tags:1;
-
-	/*
 	 * Track QUEUE_FULL events and reduce queue depth on demand.
 	 */
 	unsigned track_queue_depth:1;
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index b27977e..4416b10 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -10,91 +10,36 @@
 
 
 #ifdef CONFIG_BLOCK
-static inline struct scsi_cmnd *scsi_mq_find_tag(struct Scsi_Host *shost,
-						 int unique_tag)
-{
-	u16 hwq = blk_mq_unique_tag_to_hwq(unique_tag);
-	struct request *req = NULL;
-
-	if (hwq < shost->tag_set.nr_hw_queues)
-		req = blk_mq_tag_to_rq(shost->tag_set.tags[hwq],
-				       blk_mq_unique_tag_to_tag(unique_tag));
-	return req ? (struct scsi_cmnd *)req->special : NULL;
-}
-
-/**
- * scsi_find_tag - find a tagged command by device
- * @SDpnt:	pointer to the ScSI device
- * @tag:	tag generated by blk_mq_unique_tag()
- *
- * Notes:
- *	Only works with tags allocated by the generic blk layer.
- **/
-static inline struct scsi_cmnd *scsi_find_tag(struct scsi_device *sdev, int tag)
-{
-        struct request *req;
-
-        if (tag != SCSI_NO_TAG) {
-		if (shost_use_blk_mq(sdev->host))
-			return scsi_mq_find_tag(sdev->host, tag);
-
-		req = blk_queue_find_tag(sdev->request_queue, tag);
-	        return req ? (struct scsi_cmnd *)req->special : NULL;
-	}
-
-	/* single command, look in space */
-	return sdev->current_cmnd;
-}
-
-
-/**
- * scsi_init_shared_tag_map - create a shared tag map
- * @shost:	the host to share the tag map among all devices
- * @depth:	the total depth of the map
- */
-static inline int scsi_init_shared_tag_map(struct Scsi_Host *shost, int depth)
-{
-	/*
-	 * We always have a shared tag map around when using blk-mq.
-	 */
-	if (shost_use_blk_mq(shost))
-		return 0;
-
-	/*
-	 * If the shared tag map isn't already initialized, do it now.
-	 * This saves callers from having to check ->bqt when setting up
-	 * devices on the shared host (for libata)
-	 */
-	if (!shost->bqt) {
-		shost->bqt = blk_init_tags(depth,
-			shost->hostt->tag_alloc_policy);
-		if (!shost->bqt)
-			return -ENOMEM;
-	}
-
-	return 0;
-}
-
 /**
  * scsi_host_find_tag - find the tagged command by host
  * @shost:	pointer to scsi_host
- * @tag:	tag generated by blk_mq_unique_tag()
+ * @tag:	tag
  *
- * Notes:
- *	Only works with tags allocated by the generic blk layer.
+ * Note: for devices using multiple hardware queues tag must have been
+ * generated by blk_mq_unique_tag().
  **/
 static inline struct scsi_cmnd *scsi_host_find_tag(struct Scsi_Host *shost,
-						int tag)
+		int tag)
 {
-	struct request *req;
+	struct request *req = NULL;
 
-	if (tag != SCSI_NO_TAG) {
-		if (shost_use_blk_mq(shost))
-			return scsi_mq_find_tag(shost, tag);
+	if (tag == SCSI_NO_TAG)
+		return NULL;
+
+	if (shost_use_blk_mq(shost)) {
+		u16 hwq = blk_mq_unique_tag_to_hwq(tag);
+
+		if (hwq < shost->tag_set.nr_hw_queues) {
+			req = blk_mq_tag_to_rq(shost->tag_set.tags[hwq],
+				blk_mq_unique_tag_to_tag(tag));
+		}
+	} else {
 		req = blk_map_queue_find_tag(shost->bqt, tag);
-		return req ? (struct scsi_cmnd *)req->special : NULL;
 	}
-	return NULL;
+
+	if (!req)
+		return NULL;
+	return req->special;
 }
 
 #endif /* CONFIG_BLOCK */
-- 
1.9.1

