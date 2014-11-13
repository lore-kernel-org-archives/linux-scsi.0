From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/7] scsi: avoid ->change_queue_depth indirection for queue full tracking
Date: Thu, 13 Nov 2014 18:59:01 +0100
Message-ID: <1415901546-8006-3-git-send-email-hch@lst.de>
References: <1415901546-8006-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54643 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933449AbaKMR7J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2014 12:59:09 -0500
In-Reply-To: <1415901546-8006-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>

All drivers use the implementation for ramping the queue up and down, so
instead of overloading the change_queue_depth method call the
implementation diretly if the driver opts into it by setting the
track_queue_depth flag in the host template.

Note that a few drivers validated the new queue depth in their
change_queue_depth method, but as we never go over the queue depth
set during slave_configure or the sysfs file this isn't nessecary
and can safely be removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |  1 +
 drivers/infiniband/ulp/srp/ib_srp.c      | 20 ++++++-------
 drivers/s390/scsi/zfcp_scsi.c            | 15 ++--------
 drivers/scsi/aic94xx/aic94xx_init.c      |  1 +
 drivers/scsi/be2iscsi/be_main.c          |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c        |  1 +
 drivers/scsi/bnx2i/bnx2i_iscsi.c         |  1 +
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c       |  1 +
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c       |  1 +
 drivers/scsi/fcoe/fcoe.c                 |  1 +
 drivers/scsi/fnic/fnic_main.c            |  1 +
 drivers/scsi/ibmvscsi/ibmvfc.c           |  1 +
 drivers/scsi/isci/init.c                 |  1 +
 drivers/scsi/iscsi_tcp.c                 |  1 +
 drivers/scsi/libfc/fc_fcp.c              | 14 +--------
 drivers/scsi/libiscsi.c                  | 14 +--------
 drivers/scsi/libsas/sas_scsi_host.c      | 17 ++---------
 drivers/scsi/lpfc/lpfc_scsi.c            | 23 ++-------------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c     | 10 ++-----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 10 ++-----
 drivers/scsi/mvsas/mv_init.c             |  1 +
 drivers/scsi/pm8001/pm8001_init.c        |  1 +
 drivers/scsi/qla2xxx/qla_os.c            | 48 ++-----------------------------
 drivers/scsi/qla4xxx/ql4_os.c            | 16 +++--------
 drivers/scsi/scsi_debug.c                | 49 ++++++++------------------------
 drivers/scsi/scsi_error.c                | 15 ++++------
 drivers/scsi/ufs/ufshcd.c                | 14 ++-------
 drivers/scsi/virtio_scsi.c               | 15 ++--------
 drivers/target/loopback/tcm_loop.c       | 15 ++--------
 include/scsi/scsi_host.h                 |  7 +++--
 30 files changed, 73 insertions(+), 244 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index f42ab14..812a289 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -922,6 +922,7 @@ static struct scsi_host_template iscsi_iser_sht = {
 	.use_clustering         = DISABLE_CLUSTERING,
 	.proc_name              = "iscsi_iser",
 	.this_id                = -1,
+	.track_queue_depth	= 1,
 };
 
 static struct iscsi_transport iscsi_iser_transport = {
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 57b5ff1..98a3035 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2402,7 +2402,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
  * srp_change_queue_depth - setting device queue depth
  * @sdev: scsi device struct
  * @qdepth: requested queue depth
- * @reason: SCSI_QDEPTH_DEFAULT/SCSI_QDEPTH_QFULL/SCSI_QDEPTH_RAMP_UP
+ * @reason: SCSI_QDEPTH_DEFAULT
  * (see include/scsi/scsi_host.h for definition)
  *
  * Returns queue depth.
@@ -2412,18 +2412,13 @@ srp_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
 	struct Scsi_Host *shost = sdev->host;
 	int max_depth;
-	if (reason == SCSI_QDEPTH_DEFAULT || reason == SCSI_QDEPTH_RAMP_UP) {
-		max_depth = shost->can_queue;
-		if (!sdev->tagged_supported)
-			max_depth = 1;
-		if (qdepth > max_depth)
-			qdepth = max_depth;
-		scsi_adjust_queue_depth(sdev, qdepth);
-	} else if (reason == SCSI_QDEPTH_QFULL)
-		scsi_track_queue_full(sdev, qdepth);
-	else
-		return -EOPNOTSUPP;
 
+	max_depth = shost->can_queue;
+	if (!sdev->tagged_supported)
+		max_depth = 1;
+	if (qdepth > max_depth)
+		qdepth = max_depth;
+	scsi_adjust_queue_depth(sdev, qdepth);
 	return sdev->queue_depth;
 }
 
@@ -2766,6 +2761,7 @@ static struct scsi_host_template srp_template = {
 	.use_clustering			= ENABLE_CLUSTERING,
 	.shost_attrs			= srp_host_attrs,
 	.use_blk_tags			= 1,
+	.track_queue_depth		= 1,
 };
 
 static int srp_sdev_count(struct Scsi_Host *host)
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index b5dfa51..179bf3d 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -35,19 +35,7 @@ MODULE_PARM_DESC(allow_lun_scan, "For NPIV, scan and attach all storage LUNs");
 static int zfcp_scsi_change_queue_depth(struct scsi_device *sdev, int depth,
 					int reason)
 {
-	switch (reason) {
-	case SCSI_QDEPTH_DEFAULT:
-		scsi_adjust_queue_depth(sdev, depth);
-		break;
-	case SCSI_QDEPTH_QFULL:
-		scsi_track_queue_full(sdev, depth);
-		break;
-	case SCSI_QDEPTH_RAMP_UP:
-		scsi_adjust_queue_depth(sdev, depth);
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
+	scsi_adjust_queue_depth(sdev, depth);
 	return sdev->queue_depth;
 }
 
@@ -320,6 +308,7 @@ static struct scsi_host_template zfcp_scsi_host_template = {
 	.use_clustering		 = 1,
 	.shost_attrs		 = zfcp_sysfs_shost_attrs,
 	.sdev_attrs		 = zfcp_sysfs_sdev_attrs,
+	.track_queue_depth	 = 1,
 };
 
 /**
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 579dc2f..a64cf93 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -84,6 +84,7 @@ static struct scsi_host_template aic94xx_sht = {
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.use_blk_tags		= 1,
+	.track_queue_depth	= 1,
 };
 
 static int asd_map_memio(struct asd_ha_struct *asd_ha)
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 30d74a0..d9b999a 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -570,7 +570,7 @@ static struct scsi_host_template beiscsi_sht = {
 	.cmd_per_lun = BEISCSI_CMD_PER_LUN,
 	.use_clustering = ENABLE_CLUSTERING,
 	.vendor_id = SCSI_NL_VID_TYPE_PCI | BE_VENDOR_ID,
-
+	.track_queue_depth = 1,
 };
 
 static struct scsi_transport_template *beiscsi_scsi_transport;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 2262c75..cc53797 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2792,6 +2792,7 @@ static struct scsi_host_template bnx2fc_shost_template = {
 	.sg_tablesize		= BNX2FC_MAX_BDS_PER_CMD,
 	.max_sectors		= 1024,
 	.use_blk_tags		= 1,
+	.track_queue_depth	= 1,
 };
 
 static struct libfc_function_template bnx2fc_libfc_fcn_templ = {
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 7a36388..9de1c20 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2268,6 +2268,7 @@ static struct scsi_host_template bnx2i_host_template = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.sg_tablesize		= ISCSI_MAX_BDS_PER_CMD,
 	.shost_attrs		= bnx2i_dev_attributes,
+	.track_queue_depth	= 1,
 };
 
 struct iscsi_transport bnx2i_iscsi_transport = {
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 49692a1..99ea67d 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -96,6 +96,7 @@ static struct scsi_host_template cxgb3i_host_template = {
 	.target_alloc	= iscsi_target_alloc,
 	.use_clustering	= DISABLE_CLUSTERING,
 	.this_id	= -1,
+	.track_queue_depth = 1,
 };
 
 static struct iscsi_transport cxgb3i_iscsi_transport = {
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 81bb3bd..af86e8f 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -99,6 +99,7 @@ static struct scsi_host_template cxgb4i_host_template = {
 	.target_alloc	= iscsi_target_alloc,
 	.use_clustering	= DISABLE_CLUSTERING,
 	.this_id	= -1,
+	.track_queue_depth = 1,
 };
 
 static struct iscsi_transport cxgb4i_iscsi_transport = {
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index a3eeb68..9722986 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -289,6 +289,7 @@ static struct scsi_host_template fcoe_shost_template = {
 	.sg_tablesize = SG_ALL,
 	.max_sectors = 0xffff,
 	.use_blk_tags = 1,
+	.track_queue_depth = 1,
 };
 
 /**
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index cf1560c..10d7767 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -120,6 +120,7 @@ static struct scsi_host_template fnic_host_template = {
 	.max_sectors = 0xffff,
 	.shost_attrs = fnic_attrs,
 	.use_blk_tags = 1,
+	.track_queue_depth = 1,
 };
 
 static void
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 147b80e..381449d 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3103,6 +3103,7 @@ static struct scsi_host_template driver_template = {
 	.use_clustering = ENABLE_CLUSTERING,
 	.shost_attrs = ibmvfc_attrs,
 	.use_blk_tags = 1,
+	.track_queue_depth = 1,
 };
 
 /**
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 8975620..a81e546 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -173,6 +173,7 @@ static struct scsi_host_template isci_sht = {
 	.ioctl				= sas_ioctl,
 	.shost_attrs			= isci_host_attrs,
 	.use_blk_tags			= 1,
+	.track_queue_depth		= 1,
 };
 
 static struct sas_domain_function_template isci_transport_ops  = {
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 427af0f..a575d84 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -966,6 +966,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.target_alloc		= iscsi_target_alloc,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
+	.track_queue_depth	= 1,
 };
 
 static struct iscsi_transport iscsi_sw_tcp_transport = {
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index bf954ee..0d2d024 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2173,19 +2173,7 @@ EXPORT_SYMBOL(fc_slave_alloc);
  */
 int fc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
-	switch (reason) {
-	case SCSI_QDEPTH_DEFAULT:
-		scsi_adjust_queue_depth(sdev, qdepth);
-		break;
-	case SCSI_QDEPTH_QFULL:
-		scsi_track_queue_full(sdev, qdepth);
-		break;
-	case SCSI_QDEPTH_RAMP_UP:
-		scsi_adjust_queue_depth(sdev, qdepth);
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
+	scsi_adjust_queue_depth(sdev, qdepth);
 	return sdev->queue_depth;
 }
 EXPORT_SYMBOL(fc_change_queue_depth);
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index d521624..79e9774 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1773,19 +1773,7 @@ EXPORT_SYMBOL_GPL(iscsi_queuecommand);
 
 int iscsi_change_queue_depth(struct scsi_device *sdev, int depth, int reason)
 {
-	switch (reason) {
-	case SCSI_QDEPTH_DEFAULT:
-		scsi_adjust_queue_depth(sdev, depth);
-		break;
-	case SCSI_QDEPTH_QFULL:
-		scsi_track_queue_full(sdev, depth);
-		break;
-	case SCSI_QDEPTH_RAMP_UP:
-		scsi_adjust_queue_depth(sdev, depth);
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
+	scsi_adjust_queue_depth(sdev, depth);
 	return sdev->queue_depth;
 }
 EXPORT_SYMBOL_GPL(iscsi_change_queue_depth);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 89e8b68..914e411 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -961,20 +961,9 @@ int sas_change_queue_depth(struct scsi_device *sdev, int depth, int reason)
 		return __ata_change_queue_depth(dev->sata_dev.ap, sdev, depth,
 						reason);
 
-	switch (reason) {
-	case SCSI_QDEPTH_DEFAULT:
-	case SCSI_QDEPTH_RAMP_UP:
-		if (!sdev->tagged_supported)
-			depth = 1;
-		scsi_adjust_queue_depth(sdev, depth);
-		break;
-	case SCSI_QDEPTH_QFULL:
-		scsi_track_queue_full(sdev, depth);
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
+	if (!sdev->tagged_supported)
+		depth = 1;
+	scsi_adjust_queue_depth(sdev, depth);
 	return depth;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 80351ff..5228549 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -255,26 +255,7 @@ lpfc_update_stats(struct lpfc_hba *phba, struct  lpfc_scsi_buf *lpfc_cmd)
 static int
 lpfc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
-	struct lpfc_vport *vport = (struct lpfc_vport *) sdev->host->hostdata;
-
-	switch (reason) {
-	case SCSI_QDEPTH_DEFAULT:
-		/* change request from sysfs, fall through */
-	case SCSI_QDEPTH_RAMP_UP:
-		scsi_adjust_queue_depth(sdev, qdepth);
-		break;
-	case SCSI_QDEPTH_QFULL:
-		if (scsi_track_queue_full(sdev, qdepth) == 0)
-			return sdev->queue_depth;
-
-		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
-				 "0711 detected queue full - lun queue "
-				 "depth adjusted to %d.\n", sdev->queue_depth);
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
+	scsi_adjust_queue_depth(sdev, qdepth);
 	return sdev->queue_depth;
 }
 
@@ -5918,6 +5899,7 @@ struct scsi_host_template lpfc_template = {
 	.change_queue_depth	= lpfc_change_queue_depth,
 	.change_queue_type	= scsi_change_queue_type,
 	.use_blk_tags		= 1,
+	.track_queue_depth	= 1,
 };
 
 struct scsi_host_template lpfc_vport_template = {
@@ -5942,4 +5924,5 @@ struct scsi_host_template lpfc_vport_template = {
 	.change_queue_depth	= lpfc_change_queue_depth,
 	.change_queue_type	= scsi_change_queue_type,
 	.use_blk_tags		= 1,
+	.track_queue_depth	= 1,
 };
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 42fef91..b006e1e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1229,7 +1229,7 @@ _scsih_adjust_queue_depth(struct scsi_device *sdev, int qdepth)
  * _scsih_change_queue_depth - setting device queue depth
  * @sdev: scsi device struct
  * @qdepth: requested queue depth
- * @reason: SCSI_QDEPTH_DEFAULT/SCSI_QDEPTH_QFULL/SCSI_QDEPTH_RAMP_UP
+ * @reason: SCSI_QDEPTH_DEFAULT
  * (see include/scsi/scsi_host.h for definition)
  *
  * Returns queue depth.
@@ -1237,12 +1237,7 @@ _scsih_adjust_queue_depth(struct scsi_device *sdev, int qdepth)
 static int
 _scsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
-	if (reason == SCSI_QDEPTH_DEFAULT || reason == SCSI_QDEPTH_RAMP_UP)
-		_scsih_adjust_queue_depth(sdev, qdepth);
-	else if (reason == SCSI_QDEPTH_QFULL)
-		scsi_track_queue_full(sdev, qdepth);
-	else
-		return -EOPNOTSUPP;
+	_scsih_adjust_queue_depth(sdev, qdepth);
 
 	if (sdev->inquiry_len > 7)
 		sdev_printk(KERN_INFO, sdev, "qdepth(%d), tagged(%d), "
@@ -7637,6 +7632,7 @@ static struct scsi_host_template scsih_driver_template = {
 	.use_clustering			= ENABLE_CLUSTERING,
 	.shost_attrs			= mpt2sas_host_attrs,
 	.sdev_attrs			= mpt2sas_dev_attrs,
+	.track_queue_depth		= 1,
 };
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b23c2e7..568dcae 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1097,7 +1097,7 @@ _scsih_adjust_queue_depth(struct scsi_device *sdev, int qdepth)
  * _scsih_change_queue_depth - setting device queue depth
  * @sdev: scsi device struct
  * @qdepth: requested queue depth
- * @reason: SCSI_QDEPTH_DEFAULT/SCSI_QDEPTH_QFULL/SCSI_QDEPTH_RAMP_UP
+ * @reason: SCSI_QDEPTH_DEFAULT
  * (see include/scsi/scsi_host.h for definition)
  *
  * Returns queue depth.
@@ -1105,12 +1105,7 @@ _scsih_adjust_queue_depth(struct scsi_device *sdev, int qdepth)
 static int
 _scsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
-	if (reason == SCSI_QDEPTH_DEFAULT || reason == SCSI_QDEPTH_RAMP_UP)
-		_scsih_adjust_queue_depth(sdev, qdepth);
-	else if (reason == SCSI_QDEPTH_QFULL)
-		scsi_track_queue_full(sdev, qdepth);
-	else
-		return -EOPNOTSUPP;
+	_scsih_adjust_queue_depth(sdev, qdepth);
 
 	if (sdev->inquiry_len > 7)
 		sdev_printk(KERN_INFO, sdev, "qdepth(%d), tagged(%d), " \
@@ -7266,6 +7261,7 @@ static struct scsi_host_template scsih_driver_template = {
 	.use_clustering			= ENABLE_CLUSTERING,
 	.shost_attrs			= mpt3sas_host_attrs,
 	.sdev_attrs			= mpt3sas_dev_attrs,
+	.track_queue_depth		= 1,
 };
 
 /**
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index d3c1fa5..ac7c030 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -77,6 +77,7 @@ static struct scsi_host_template mvs_sht = {
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= mvst_host_attrs,
 	.use_blk_tags		= 1,
+	.track_queue_depth	= 1,
 };
 
 static struct sas_domain_function_template mvs_transport_ops = {
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 3ff759a..19ae6ca 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -90,6 +90,7 @@ static struct scsi_host_template pm8001_sht = {
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= pm8001_host_attrs,
 	.use_blk_tags		= 1,
+	.track_queue_depth	= 1,
 };
 
 /**
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 33166eb..20049b1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -270,6 +270,7 @@ struct scsi_host_template qla2xxx_driver_template = {
 
 	.supported_mode		= MODE_INITIATOR,
 	.use_blk_tags		= 1,
+	.track_queue_depth	= 1,
 };
 
 static struct scsi_transport_template *qla2xxx_transport_template = NULL;
@@ -1415,55 +1416,10 @@ qla2xxx_slave_destroy(struct scsi_device *sdev)
 	sdev->hostdata = NULL;
 }
 
-static void qla2x00_handle_queue_full(struct scsi_device *sdev, int qdepth)
-{
-	fc_port_t *fcport = (struct fc_port *) sdev->hostdata;
-
-	if (!scsi_track_queue_full(sdev, qdepth))
-		return;
-
-	ql_dbg(ql_dbg_io, fcport->vha, 0x3029,
-	    "Queue depth adjusted-down to %d for nexus=%ld:%d:%llu.\n",
-	    sdev->queue_depth, fcport->vha->host_no, sdev->id, sdev->lun);
-}
-
-static void qla2x00_adjust_sdev_qdepth_up(struct scsi_device *sdev, int qdepth)
-{
-	fc_port_t *fcport = sdev->hostdata;
-	struct scsi_qla_host *vha = fcport->vha;
-	struct req_que *req = NULL;
-
-	req = vha->req;
-	if (!req)
-		return;
-
-	if (req->max_q_depth <= sdev->queue_depth || req->max_q_depth < qdepth)
-		return;
-
-	scsi_adjust_queue_depth(sdev, qdepth);
-
-	ql_dbg(ql_dbg_io, vha, 0x302a,
-	    "Queue depth adjusted-up to %d for nexus=%ld:%d:%llu.\n",
-	    sdev->queue_depth, fcport->vha->host_no, sdev->id, sdev->lun);
-}
-
 static int
 qla2x00_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
-	switch (reason) {
-	case SCSI_QDEPTH_DEFAULT:
-		scsi_adjust_queue_depth(sdev, qdepth);
-		break;
-	case SCSI_QDEPTH_QFULL:
-		qla2x00_handle_queue_full(sdev, qdepth);
-		break;
-	case SCSI_QDEPTH_RAMP_UP:
-		qla2x00_adjust_sdev_qdepth_up(sdev, qdepth);
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
+	scsi_adjust_queue_depth(sdev, qdepth);
 	return sdev->queue_depth;
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index f8724f2..2bfde37 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -164,8 +164,6 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_slave_alloc(struct scsi_device *device);
 static umode_t qla4_attr_is_visible(int param_type, int param);
 static int qla4xxx_host_reset(struct Scsi_Host *shost, int reset_type);
-static int qla4xxx_change_queue_depth(struct scsi_device *sdev, int qdepth,
-				      int reason);
 
 /*
  * iSCSI Flash DDB sysfs entry points
@@ -203,7 +201,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.eh_timed_out		= qla4xxx_eh_cmd_timed_out,
 
 	.slave_alloc		= qla4xxx_slave_alloc,
-	.change_queue_depth	= qla4xxx_change_queue_depth,
+	.change_queue_depth	= iscsi_change_queue_depth,
 
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
@@ -9065,15 +9063,6 @@ static int qla4xxx_slave_alloc(struct scsi_device *sdev)
 	return 0;
 }
 
-static int qla4xxx_change_queue_depth(struct scsi_device *sdev, int qdepth,
-				      int reason)
-{
-	if (!ql4xqfulltracking)
-		return -EOPNOTSUPP;
-
-	return iscsi_change_queue_depth(sdev, qdepth, reason);
-}
-
 /**
  * qla4xxx_del_from_active_array - returns an active srb
  * @ha: Pointer to host adapter structure.
@@ -9873,6 +9862,9 @@ static int __init qla4xxx_module_init(void)
 {
 	int ret;
 
+	if (ql4xqfulltracking)
+		qla4xxx_driver_template.track_queue_depth = 1;
+
 	/* Allocate cache for SRBs. */
 	srb_cachep = kmem_cache_create("qla4xxx_srbs", sizeof(struct srb), 0,
 				       SLAB_HWCACHE_ALIGN, NULL);
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index fce393f..84cf82e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4472,7 +4472,6 @@ static int
 sdebug_change_qdepth(struct scsi_device *sdev, int qdepth, int reason)
 {
 	int num_in_q = 0;
-	int bad = 0;
 	unsigned long iflags;
 	struct sdebug_dev_info *devip;
 
@@ -4484,43 +4483,18 @@ sdebug_change_qdepth(struct scsi_device *sdev, int qdepth, int reason)
 	}
 	num_in_q = atomic_read(&devip->num_in_q);
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
-	if (reason == SCSI_QDEPTH_DEFAULT || reason == SCSI_QDEPTH_RAMP_UP) {
-		if (qdepth < 1)
-			qdepth = 1;
-		/* allow to exceed max host queued_arr elements for testing */
-		if (qdepth > SCSI_DEBUG_CANQUEUE + 10)
-			qdepth = SCSI_DEBUG_CANQUEUE + 10;
-		scsi_adjust_queue_depth(sdev, qdepth);
-	} else if (reason == SCSI_QDEPTH_QFULL)
-		scsi_track_queue_full(sdev, qdepth);
-	else
-		bad = 1;
-	if (bad)
-		sdev_printk(KERN_WARNING, sdev,
-			    "%s: unknown reason=0x%x\n", __func__, reason);
+
+	if (qdepth < 1)
+		qdepth = 1;
+	/* allow to exceed max host queued_arr elements for testing */
+	if (qdepth > SCSI_DEBUG_CANQUEUE + 10)
+		qdepth = SCSI_DEBUG_CANQUEUE + 10;
+	scsi_adjust_queue_depth(sdev, qdepth);
+
 	if (SCSI_DEBUG_OPT_Q_NOISE & scsi_debug_opts) {
-		if (SCSI_QDEPTH_QFULL == reason)
-			sdev_printk(KERN_INFO, sdev,
-			    "%s: -> %d, num_in_q=%d, reason: queue full\n",
-				    __func__, qdepth, num_in_q);
-		else {
-			const char *cp;
-
-			switch (reason) {
-			case SCSI_QDEPTH_DEFAULT:
-				cp = "default (sysfs ?)";
-				break;
-			case SCSI_QDEPTH_RAMP_UP:
-				cp = "ramp up";
-				break;
-			default:
-				cp = "unknown";
-				break;
-			}
-			sdev_printk(KERN_INFO, sdev,
-				    "%s: qdepth=%d, num_in_q=%d, reason: %s\n",
-				    __func__, qdepth, num_in_q, cp);
-		}
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: qdepth=%d, num_in_q=%d\n",
+			    __func__, qdepth, num_in_q);
 	}
 	return sdev->queue_depth;
 }
@@ -4576,6 +4550,7 @@ static struct scsi_host_template sdebug_driver_template = {
 	.max_sectors =		-1U,
 	.use_clustering = 	DISABLE_CLUSTERING,
 	.module =		THIS_MODULE,
+	.track_queue_depth =	1,
 };
 
 static int sdebug_driver_probe(struct device * dev)
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a6f6b92..2d0f515 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -610,7 +610,7 @@ static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
 	struct scsi_host_template *sht = sdev->host->hostt;
 	struct scsi_device *tmp_sdev;
 
-	if (!sht->change_queue_depth ||
+	if (!sht->track_queue_depth ||
 	    sdev->queue_depth >= sdev->max_queue_depth)
 		return;
 
@@ -631,12 +631,8 @@ static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
 		    tmp_sdev->id != sdev->id ||
 		    tmp_sdev->queue_depth == sdev->max_queue_depth)
 			continue;
-		/*
-		 * call back into LLD to increase queue_depth by one
-		 * with ramp up reason code.
-		 */
-		sht->change_queue_depth(tmp_sdev, tmp_sdev->queue_depth + 1,
-					SCSI_QDEPTH_RAMP_UP);
+
+		scsi_adjust_queue_depth(tmp_sdev, tmp_sdev->queue_depth + 1);
 		sdev->last_queue_ramp_up = jiffies;
 	}
 }
@@ -646,7 +642,7 @@ static void scsi_handle_queue_full(struct scsi_device *sdev)
 	struct scsi_host_template *sht = sdev->host->hostt;
 	struct scsi_device *tmp_sdev;
 
-	if (!sht->change_queue_depth)
+	if (!sht->track_queue_depth)
 		return;
 
 	shost_for_each_device(tmp_sdev, sdev->host) {
@@ -658,8 +654,7 @@ static void scsi_handle_queue_full(struct scsi_device *sdev)
 		 * the device when we got the queue full so we start
 		 * from the highest possible value and work our way down.
 		 */
-		sht->change_queue_depth(tmp_sdev, tmp_sdev->queue_depth - 1,
-					SCSI_QDEPTH_QFULL);
+		scsi_track_queue_full(tmp_sdev, tmp_sdev->queue_depth - 1);
 	}
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 362b818..e96ab25 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2800,18 +2800,7 @@ static int ufshcd_change_queue_depth(struct scsi_device *sdev,
 	if (depth > hba->nutrs)
 		depth = hba->nutrs;
 
-	switch (reason) {
-	case SCSI_QDEPTH_DEFAULT:
-	case SCSI_QDEPTH_RAMP_UP:
-		scsi_adjust_queue_depth(sdev, depth);
-		break;
-	case SCSI_QDEPTH_QFULL:
-		scsi_track_queue_full(sdev, depth);
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
+	scsi_adjust_queue_depth(sdev, depth);
 	return depth;
 }
 
@@ -4231,6 +4220,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.can_queue		= UFSHCD_CAN_QUEUE,
 	.max_host_blocked	= 1,
 	.use_blk_tags		= 1,
+	.track_queue_depth	= 1,
 };
 
 static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 355afbc..b9ef4b0 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -677,18 +677,7 @@ static int virtscsi_change_queue_depth(struct scsi_device *sdev,
 	struct Scsi_Host *shost = sdev->host;
 	int max_depth = shost->cmd_per_lun;
 
-	switch (reason) {
-	case SCSI_QDEPTH_QFULL: /* Drop qdepth in response to BUSY state */
-		scsi_track_queue_full(sdev, qdepth);
-		break;
-	case SCSI_QDEPTH_RAMP_UP: /* Raise qdepth after BUSY state resolved */
-	case SCSI_QDEPTH_DEFAULT: /* Manual change via sysfs */
-		scsi_adjust_queue_depth(sdev, min(max_depth, qdepth));
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
+	scsi_adjust_queue_depth(sdev, min(max_depth, qdepth));
 	return sdev->queue_depth;
 }
 
@@ -756,6 +745,7 @@ static struct scsi_host_template virtscsi_host_template_single = {
 	.use_clustering = ENABLE_CLUSTERING,
 	.target_alloc = virtscsi_target_alloc,
 	.target_destroy = virtscsi_target_destroy,
+	.track_queue_depth = 1,
 };
 
 static struct scsi_host_template virtscsi_host_template_multi = {
@@ -774,6 +764,7 @@ static struct scsi_host_template virtscsi_host_template_multi = {
 	.use_clustering = ENABLE_CLUSTERING,
 	.target_alloc = virtscsi_target_alloc,
 	.target_destroy = virtscsi_target_destroy,
+	.track_queue_depth = 1,
 };
 
 #define virtscsi_config_get(vdev, fld) \
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 0ed9664..670b75a 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -119,19 +119,7 @@ static int tcm_loop_change_queue_depth(
 	int depth,
 	int reason)
 {
-	switch (reason) {
-	case SCSI_QDEPTH_DEFAULT:
-		scsi_adjust_queue_depth(sdev, depth);
-		break;
-	case SCSI_QDEPTH_QFULL:
-		scsi_track_queue_full(sdev, depth);
-		break;
-	case SCSI_QDEPTH_RAMP_UP:
-		scsi_adjust_queue_depth(sdev, depth);
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
+	scsi_adjust_queue_depth(sdev, depth);
 	return sdev->queue_depth;
 }
 
@@ -423,6 +411,7 @@ static struct scsi_host_template tcm_loop_driver_template = {
 	.slave_alloc		= tcm_loop_slave_alloc,
 	.module			= THIS_MODULE,
 	.use_blk_tags		= 1,
+	.track_queue_depth	= 1,
 };
 
 static int tcm_loop_driver_probe(struct device *dev)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 61a81bf..a0b13a5 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -48,8 +48,6 @@ struct blk_queue_tags;
 
 enum {
 	SCSI_QDEPTH_DEFAULT,	/* default requested change, e.g. from sysfs */
-	SCSI_QDEPTH_QFULL,	/* scsi-ml requested due to queue full */
-	SCSI_QDEPTH_RAMP_UP,	/* scsi-ml requested due to threshold event */
 };
 
 struct scsi_host_template {
@@ -427,6 +425,11 @@ struct scsi_host_template {
 	unsigned use_blk_tags:1;
 
 	/*
+	 * Track QUEUE_FULL events and reduce queue depth on demand.
+	 */
+	unsigned track_queue_depth:1;
+
+	/*
 	 * This specifies the mode that a LLD supports.
 	 */
 	unsigned supported_mode:2;
-- 
1.9.1

