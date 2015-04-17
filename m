From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH, RFC] scsi: use host wide tags by default
Date: Fri, 17 Apr 2015 22:11:11 +0200
Message-ID: <1429301471-5666-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34244 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbbDQUME (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2015 16:12:04 -0400
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
---
 drivers/ata/libata-scsi.c           |  3 --
 drivers/infiniband/ulp/srp/ib_srp.c |  7 +--
 drivers/message/fusion/mptsas.c     |  1 -
 drivers/scsi/53c700.c               |  9 ++--
 drivers/scsi/aic7xxx/aic79xx_osm.c  |  1 -
 drivers/scsi/aic7xxx/aic7xxx_osm.c  |  1 -
 drivers/scsi/aic94xx/aic94xx_init.c |  1 -
 drivers/scsi/bfa/bfad_im.c          |  2 -
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c   |  1 -
 drivers/scsi/csiostor/csio_scsi.c   |  2 -
 drivers/scsi/esas2r/esas2r_main.c   |  1 -
 drivers/scsi/esp_scsi.c             |  1 -
 drivers/scsi/fcoe/fcoe.c            |  1 -
 drivers/scsi/fnic/fnic_main.c       |  8 ----
 drivers/scsi/fnic/fnic_scsi.c       | 16 +++----
 drivers/scsi/hosts.c                |  7 +++
 drivers/scsi/ibmvscsi/ibmvfc.c      |  1 -
 drivers/scsi/ipr.c                  |  1 -
 drivers/scsi/isci/init.c            |  1 -
 drivers/scsi/lpfc/lpfc_scsi.c       |  3 --
 drivers/scsi/mvsas/mv_init.c        |  1 -
 drivers/scsi/pm8001/pm8001_init.c   |  1 -
 drivers/scsi/pmcraid.c              |  1 -
 drivers/scsi/qla2xxx/qla_os.c       |  1 -
 drivers/scsi/qla4xxx/ql4_os.c       | 14 ++----
 drivers/scsi/scsi.c                 | 28 ++---------
 drivers/scsi/scsi_scan.c            |  3 +-
 drivers/scsi/stex.c                 |  8 ----
 drivers/scsi/ufs/ufshcd.c           |  8 ----
 drivers/target/loopback/tcm_loop.c  |  1 -
 drivers/usb/storage/uas.c           |  5 --
 include/scsi/scsi_host.h            |  5 --
 include/scsi/scsi_tcq.h             | 96 ++++++++-----------------------------
 33 files changed, 51 insertions(+), 189 deletions(-)

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
index 0747c05..f6957e7 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1740,7 +1740,7 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
 			ch->tsk_mgmt_status = rsp->data[3];
 		complete(&ch->tsk_mgmt_done);
 	} else {
-		scmnd = scsi_host_find_tag(target->scsi_host, rsp->tag);
+		scmnd = scsi_find_tag(target->scsi_host, rsp->tag);
 		if (scmnd) {
 			req = (void *)scmnd->host_scribble;
 			scmnd = srp_claim_req(ch, req, NULL, scmnd);
@@ -2750,7 +2750,6 @@ static struct scsi_host_template srp_template = {
 	.cmd_per_lun			= SRP_DEFAULT_CMD_SQ_SIZE,
 	.use_clustering			= ENABLE_CLUSTERING,
 	.shost_attrs			= srp_host_attrs,
-	.use_blk_tags			= 1,
 	.track_queue_depth		= 1,
 };
 
@@ -3173,10 +3172,6 @@ static ssize_t srp_create_target(struct device *dev,
 	if (ret)
 		goto err;
 
-	ret = scsi_init_shared_tag_map(target_host, target_host->can_queue);
-	if (ret)
-		goto err;
-
 	target->req_ring_size = target->queue_size - SRP_TSK_MGMT_SQ_SIZE;
 
 	if (!srp_conn_unique(target->srp_host, target)) {
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 5bdaae1..0707fa2 100644
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
index 82abfce..941a424 100644
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
+			SCp = scsi_find_tag(SDp->host, hostdata->msgin[2]);
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
+			SCp = scsi_find_tag(SDp->host, SCSI_NO_TAG);
 			if(unlikely(SCp == NULL)) {
 				sdev_printk(KERN_ERR, SDp,
 					"no saved request for untagged cmd\n");
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
index 02a2512..f46596d 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -74,7 +74,6 @@ static struct scsi_host_template aic94xx_sht = {
 	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
-	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
 
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 7223b00..e7f62f1 100644
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
index ec193a8..65fb18e 100644
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
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 155b286..b448ebb 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -808,7 +808,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 		return;
 	}
 
-	sc = scsi_host_find_tag(fnic->lport->host, id);
+	sc = scsi_find_tag(fnic->lport->host, id);
 	WARN_ON_ONCE(!sc);
 	if (!sc) {
 		atomic64_inc(&fnic_stats->io_stats.sc_null);
@@ -1025,7 +1025,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 		return;
 	}
 
-	sc = scsi_host_find_tag(fnic->lport->host, id & FNIC_TAG_MASK);
+	sc = scsi_find_tag(fnic->lport->host, id & FNIC_TAG_MASK);
 	WARN_ON_ONCE(!sc);
 	if (!sc) {
 		atomic64_inc(&fnic_stats->io_stats.sc_null);
@@ -1288,7 +1288,7 @@ static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
 
 		io_lock = fnic_io_lock_tag(fnic, i);
 		spin_lock_irqsave(io_lock, flags);
-		sc = scsi_host_find_tag(fnic->lport->host, i);
+		sc = scsi_find_tag(fnic->lport->host, i);
 		if (!sc) {
 			spin_unlock_irqrestore(io_lock, flags);
 			continue;
@@ -1374,7 +1374,7 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
 	if (id >= fnic->fnic_max_tag_id)
 		return;
 
-	sc = scsi_host_find_tag(fnic->lport->host, id);
+	sc = scsi_find_tag(fnic->lport->host, id);
 	if (!sc)
 		return;
 
@@ -1490,7 +1490,7 @@ static void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 		abt_tag = tag;
 		io_lock = fnic_io_lock_tag(fnic, tag);
 		spin_lock_irqsave(io_lock, flags);
-		sc = scsi_host_find_tag(fnic->lport->host, tag);
+		sc = scsi_find_tag(fnic->lport->host, tag);
 		if (!sc) {
 			spin_unlock_irqrestore(io_lock, flags);
 			continue;
@@ -1635,7 +1635,7 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
 		abt_tag = tag;
 		io_lock = fnic_io_lock_tag(fnic, tag);
 		spin_lock_irqsave(io_lock, flags);
-		sc = scsi_host_find_tag(fnic->lport->host, tag);
+		sc = scsi_find_tag(fnic->lport->host, tag);
 		if (!sc) {
 			spin_unlock_irqrestore(io_lock, flags);
 			continue;
@@ -2017,7 +2017,7 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 	for (tag = 0; tag < fnic->fnic_max_tag_id; tag++) {
 		io_lock = fnic_io_lock_tag(fnic, tag);
 		spin_lock_irqsave(io_lock, flags);
-		sc = scsi_host_find_tag(fnic->lport->host, tag);
+		sc = scsi_find_tag(fnic->lport->host, tag);
 		/*
 		 * ignore this lun reset cmd or cmds that do not belong to
 		 * this lun
@@ -2675,7 +2675,7 @@ int fnic_is_abts_pending(struct fnic *fnic, struct scsi_cmnd *lr_sc)
 
 	/* walk again to check, if IOs are still pending in fw */
 	for (tag = 0; tag < fnic->fnic_max_tag_id; tag++) {
-		sc = scsi_host_find_tag(fnic->lport->host, tag);
+		sc = scsi_find_tag(fnic->lport->host, tag);
 		/*
 		 * ignore this lun reset cmd or cmds that do not belong to
 		 * this lun
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
index 8827448..f7f48e91 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6489,7 +6489,6 @@ static struct scsi_host_template driver_template = {
 	.shost_attrs = ipr_ioa_attrs,
 	.sdev_attrs = ipr_dev_attrs,
 	.proc_name = IPR_NAME,
-	.use_blk_tags = 1,
 };
 
 /**
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index cd41b63..41261ef 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -171,7 +171,6 @@ static struct scsi_host_template isci_sht = {
 	.target_destroy			= sas_target_destroy,
 	.ioctl				= sas_ioctl,
 	.shost_attrs			= isci_host_attrs,
-	.use_blk_tags			= 1,
 	.track_queue_depth		= 1,
 };
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index cb73cf9..39a1052 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5880,7 +5880,6 @@ struct scsi_host_template lpfc_template_s3 = {
 	.max_sectors		= 0xFFFF,
 	.vendor_id		= LPFC_NL_VENDOR_ID,
 	.change_queue_depth	= scsi_change_queue_depth,
-	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
 
@@ -5906,7 +5905,6 @@ struct scsi_host_template lpfc_template = {
 	.max_sectors		= 0xFFFF,
 	.vendor_id		= LPFC_NL_VENDOR_ID,
 	.change_queue_depth	= scsi_change_queue_depth,
-	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
 
@@ -5930,6 +5928,5 @@ struct scsi_host_template lpfc_vport_template = {
 	.shost_attrs		= lpfc_vport_attrs,
 	.max_sectors		= 0xFFFF,
 	.change_queue_depth	= scsi_change_queue_depth,
-	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 53030b0..bdf99e3 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -66,7 +66,6 @@ static struct scsi_host_template mvs_sht = {
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= mvst_host_attrs,
-	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
 
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 6555591..ce2cd6b 100644
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
index 7462dd7..edf41be 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -267,7 +267,6 @@ struct scsi_host_template qla2xxx_driver_template = {
 	.shost_attrs		= qla2x00_host_attrs,
 
 	.supported_mode		= MODE_INITIATOR,
-	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6d25879..05c5d7b 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -212,7 +212,6 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.shost_attrs		= qla4xxx_host_attrs,
 	.host_reset		= qla4xxx_host_reset,
 	.vendor_id		= SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_QLOGIC,
-	.use_blk_tags		= 1,
 };
 
 static struct iscsi_transport qla4xxx_iscsi_transport = {
@@ -4601,7 +4600,7 @@ static int qla4xxx_cmd_wait(struct scsi_qla_host *ha)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 		/* Find a command that hasn't completed. */
 		for (index = 0; index < ha->host->can_queue; index++) {
-			cmd = scsi_host_find_tag(ha->host, index);
+			cmd = scsi_find_tag(ha->host, index);
 			/*
 			 * We cannot just check if the index is valid,
 			 * becase if we are run from the scsi eh, then
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
@@ -9076,7 +9068,7 @@ struct srb *qla4xxx_del_from_active_array(struct scsi_qla_host *ha,
 	struct srb *srb = NULL;
 	struct scsi_cmnd *cmd = NULL;
 
-	cmd = scsi_host_find_tag(ha->host, index);
+	cmd = scsi_find_tag(ha->host, index);
 	if (!cmd)
 		return srb;
 
@@ -9176,7 +9168,7 @@ static int qla4xxx_eh_wait_for_commands(struct scsi_qla_host *ha,
 	 * in the active array
 	 */
 	for (cnt = 0; cnt < ha->host->can_queue; cnt++) {
-		cmd = scsi_host_find_tag(ha->host, cnt);
+		cmd = scsi_find_tag(ha->host, cnt);
 		if (cmd && stgt == scsi_target(cmd->device) &&
 		    (!sdev || sdev == cmd->device)) {
 			if (!qla4xxx_eh_wait_on_command(ha, cmd)) {
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3833bf5..72a72f9 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -662,32 +662,14 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
  */
 int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
 {
-	unsigned long flags;
-
-	if (depth <= 0)
-		goto out;
-
-	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+	if (depth > 0) {
+		unsigned long flags;
 
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
+		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
+		sdev->queue_depth = depth;
+		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 	}
 
-	sdev->queue_depth = depth;
-out_unlock:
-	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
-out:
 	return sdev->queue_depth;
 }
 EXPORT_SYMBOL(scsi_change_queue_depth);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 60aae01..6f002be 100644
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
index 648a446..decd2a2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4253,7 +4253,6 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
 	.can_queue		= UFSHCD_CAN_QUEUE,
 	.max_host_blocked	= 1,
-	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
 
@@ -5517,13 +5516,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
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
index c36bd7c..e3536bd 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -380,7 +380,6 @@ static struct scsi_host_template tcm_loop_driver_template = {
 	.use_clustering		= DISABLE_CLUSTERING,
 	.slave_alloc		= tcm_loop_slave_alloc,
 	.module			= THIS_MODULE,
-	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
 };
 
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 6cdabdc..8db79fe 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -805,7 +805,6 @@ static struct scsi_host_template uas_host_template = {
 	.sg_tablesize = SG_NONE,
 	.cmd_per_lun = 1,	/* until we override it */
 	.skip_settle_delay = 1,
-	.use_blk_tags = 1,
 };
 
 #define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
@@ -922,10 +921,6 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
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
index b27977e..ebe9a6c 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -10,91 +10,35 @@
 
 
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
 /**
- * scsi_find_tag - find a tagged command by device
- * @SDpnt:	pointer to the ScSI device
- * @tag:	tag generated by blk_mq_unique_tag()
+ * scsi_find_tag - find the tagged command by host
+ * @shost:	pointer to scsi_host
+ * @tag:	tag
  *
- * Notes:
- *	Only works with tags allocated by the generic blk layer.
+ * Note: for devices using multiple hardware queues tag must have been
+ * generated by blk_mq_unique_tag().
  **/
-static inline struct scsi_cmnd *scsi_find_tag(struct scsi_device *sdev, int tag)
+static inline struct scsi_cmnd *scsi_find_tag(struct Scsi_Host *shost, int tag)
 {
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
+	struct request *req = NULL;
 
-	return 0;
-}
+	if (tag == SCSI_NO_TAG)
+		return NULL;
 
-/**
- * scsi_host_find_tag - find the tagged command by host
- * @shost:	pointer to scsi_host
- * @tag:	tag generated by blk_mq_unique_tag()
- *
- * Notes:
- *	Only works with tags allocated by the generic blk layer.
- **/
-static inline struct scsi_cmnd *scsi_host_find_tag(struct Scsi_Host *shost,
-						int tag)
-{
-	struct request *req;
+	if (shost_use_blk_mq(shost)) {
+		u16 hwq = blk_mq_unique_tag_to_hwq(tag);
 
-	if (tag != SCSI_NO_TAG) {
-		if (shost_use_blk_mq(shost))
-			return scsi_mq_find_tag(shost, tag);
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

