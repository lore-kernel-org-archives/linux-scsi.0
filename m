From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/7] scsi: drop reason argument from ->change_queue_depth
Date: Thu, 13 Nov 2014 18:59:03 +0100
Message-ID: <1415901546-8006-5-git-send-email-hch@lst.de>
References: <1415901546-8006-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54670 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbaKMR7K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2014 12:59:10 -0500
In-Reply-To: <1415901546-8006-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>

Drop the now unused reason argument from the ->change_queue_depth method.
Also add a return value to scsi_adjust_queue_depth, and rename it to
scsi_change_queue_depth now that it can be used as the default
->change_queue_depth implementation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/scsi/scsi_mid_low_api.txt   | 20 +++++++--------
 drivers/ata/libata-scsi.c                 | 17 ++++---------
 drivers/ata/sata_nv.c                     |  2 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c  |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c       |  7 ++----
 drivers/message/fusion/mptscsih.c         | 12 +++------
 drivers/message/fusion/mptscsih.h         |  3 +--
 drivers/s390/scsi/zfcp_scsi.c             | 11 ++-------
 drivers/scsi/3w-9xxx.c                    | 13 +---------
 drivers/scsi/3w-sas.c                     | 13 +---------
 drivers/scsi/3w-xxxx.c                    | 13 +---------
 drivers/scsi/53c700.c                     | 19 ++++++--------
 drivers/scsi/BusLogic.c                   |  4 +--
 drivers/scsi/aacraid/linit.c              | 18 ++++++--------
 drivers/scsi/advansys.c                   |  8 +++---
 drivers/scsi/aic7xxx/aic79xx_osm.c        |  4 +--
 drivers/scsi/aic7xxx/aic7xxx_osm.c        |  4 +--
 drivers/scsi/arcmsr/arcmsr_hba.c          |  9 ++-----
 drivers/scsi/be2iscsi/be_main.c           |  2 +-
 drivers/scsi/bfa/bfad_im.c                |  4 +--
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c         |  2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c          |  2 +-
 drivers/scsi/csiostor/csio_scsi.c         |  2 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c        |  2 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c        |  2 +-
 drivers/scsi/dpt_i2o.c                    |  2 +-
 drivers/scsi/eata.c                       |  6 ++---
 drivers/scsi/esas2r/esas2r.h              |  1 -
 drivers/scsi/esas2r/esas2r_main.c         | 11 +--------
 drivers/scsi/esp_scsi.c                   |  2 +-
 drivers/scsi/fcoe/fcoe.c                  |  2 +-
 drivers/scsi/fnic/fnic_main.c             |  4 +--
 drivers/scsi/hpsa.c                       | 16 +-----------
 drivers/scsi/hptiop.c                     |  8 ++----
 drivers/scsi/ibmvscsi/ibmvfc.c            |  9 ++-----
 drivers/scsi/ibmvscsi/ibmvscsi.c          | 10 ++------
 drivers/scsi/ipr.c                        | 10 +++-----
 drivers/scsi/ips.c                        |  2 +-
 drivers/scsi/iscsi_tcp.c                  |  2 +-
 drivers/scsi/libfc/fc_fcp.c               | 15 +----------
 drivers/scsi/libiscsi.c                   |  7 ------
 drivers/scsi/libsas/sas_scsi_host.c       | 12 ++++-----
 drivers/scsi/lpfc/lpfc_scsi.c             | 26 +++-----------------
 drivers/scsi/megaraid/megaraid_mbox.c     | 21 +---------------
 drivers/scsi/megaraid/megaraid_sas_base.c | 13 +---------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      | 10 +++-----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      | 10 +++-----
 drivers/scsi/ncr53c8xx.c                  |  2 +-
 drivers/scsi/pmcraid.c                    | 12 ++-------
 drivers/scsi/qla1280.c                    |  4 +--
 drivers/scsi/qla2xxx/qla_os.c             | 12 ++-------
 drivers/scsi/qla4xxx/ql4_os.c             |  4 +--
 drivers/scsi/scsi.c                       | 41 +++++++++++--------------------
 drivers/scsi/scsi_debug.c                 |  4 +--
 drivers/scsi/scsi_error.c                 |  2 +-
 drivers/scsi/scsi_scan.c                  |  2 +-
 drivers/scsi/scsi_sysfs.c                 |  3 +--
 drivers/scsi/storvsc_drv.c                |  2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c       |  2 +-
 drivers/scsi/tmscsim.c                    |  2 +-
 drivers/scsi/u14-34f.c                    | 10 ++++----
 drivers/scsi/ufs/ufshcd.c                 | 13 +++-------
 drivers/scsi/virtio_scsi.c                |  8 ++----
 drivers/scsi/vmw_pvscsi.c                 | 12 ++-------
 drivers/scsi/wd7000.c                     |  1 -
 drivers/target/loopback/tcm_loop.c        | 15 +----------
 drivers/usb/storage/uas.c                 |  2 +-
 include/linux/libata.h                    |  4 +--
 include/scsi/libfc.h                      |  1 -
 include/scsi/libiscsi.h                   |  2 --
 include/scsi/libsas.h                     |  3 +--
 include/scsi/scsi_device.h                |  2 +-
 include/scsi/scsi_host.h                  |  8 ++----
 73 files changed, 155 insertions(+), 412 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index bee7d86..731bc4f 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -149,7 +149,7 @@ scsi_add_host()  ---->
 scsi_scan_host()  -------+
                          |
                     slave_alloc()
-                    slave_configure() -->  scsi_adjust_queue_depth()
+                    slave_configure() -->  scsi_change_queue_depth()
                          |
                     slave_alloc()
                     slave_configure()
@@ -159,7 +159,7 @@ scsi_scan_host()  -------+
 ------------------------------------------------------------
 
 If the LLD wants to adjust the default queue settings, it can invoke
-scsi_adjust_queue_depth() in its slave_configure() routine.
+scsi_change_queue_depth() in its slave_configure() routine.
 
 *** For scsi devices that the mid level tries to scan but do not
     respond, a slave_alloc(), slave_destroy() pair is called.
@@ -203,7 +203,7 @@ LLD                   mid level                    LLD
 scsi_add_device()  ------+
                          |
                     slave_alloc()
-                    slave_configure()   [--> scsi_adjust_queue_depth()]
+                    slave_configure()   [--> scsi_change_queue_depth()]
 ------------------------------------------------------------
 
 In a similar fashion, an LLD may become aware that a SCSI device has been
@@ -261,7 +261,7 @@ init_this_scsi_driver() ----+
                             |                scsi_register()
                             |
                       slave_alloc()
-                      slave_configure()  -->  scsi_adjust_queue_depth()
+                      slave_configure()  -->  scsi_change_queue_depth()
                       slave_alloc()   ***
                       slave_destroy() ***
                             |
@@ -271,7 +271,7 @@ init_this_scsi_driver() ----+
                       slave_destroy() ***
 ------------------------------------------------------------
 
-The mid level invokes scsi_adjust_queue_depth() with "cmd_per_lun" for that
+The mid level invokes scsi_change_queue_depth() with "cmd_per_lun" for that
 host as the queue length. These settings can be overridden by a
 slave_configure() supplied by the LLD.
 
@@ -368,7 +368,7 @@ names all start with "scsi_".
 Summary:
    scsi_add_device - creates new scsi device (lu) instance
    scsi_add_host - perform sysfs registration and set up transport class
-   scsi_adjust_queue_depth - change the queue depth on a SCSI device
+   scsi_change_queue_depth - change the queue depth on a SCSI device
    scsi_bios_ptable - return copy of block device's partition table
    scsi_block_requests - prevent further commands being queued to given host
    scsi_host_alloc - return a new scsi_host instance whose refcount==1
@@ -436,7 +436,7 @@ int scsi_add_host(struct Scsi_Host *shost, struct device * dev)
 
 
 /**
- * scsi_adjust_queue_depth - allow LLD to change queue depth on a SCSI device
+ * scsi_change_queue_depth - allow LLD to change queue depth on a SCSI device
  * @sdev:       pointer to SCSI device to change queue depth on
  * @tags        Number of tags allowed if tagged queuing enabled,
  *              or number of commands the LLD can queue up
@@ -453,7 +453,7 @@ int scsi_add_host(struct Scsi_Host *shost, struct device * dev)
  *      Defined in: drivers/scsi/scsi.c [see source code for more notes]
  *
  **/
-void scsi_adjust_queue_depth(struct scsi_device *sdev, int tags)
+int scsi_change_queue_depth(struct scsi_device *sdev, int tags)
 
 
 /**
@@ -1214,7 +1214,7 @@ of interest:
                    for disk firmware uploads.
     cmd_per_lun  - maximum number of commands that can be queued on devices
                    controlled by the host. Overridden by LLD calls to
-                   scsi_adjust_queue_depth().
+                   scsi_change_queue_depth().
     unchecked_isa_dma - 1=>only use bottom 16 MB of ram (ISA DMA addressing
                    restriction), 0=>can use full 32 bit (or better) DMA
                    address space
@@ -1254,7 +1254,7 @@ struct scsi_cmnd
 Instances of this structure convey SCSI commands to the LLD and responses
 back to the mid level. The SCSI mid level will ensure that no more SCSI
 commands become queued against the LLD than are indicated by
-scsi_adjust_queue_depth() (or struct Scsi_Host::cmd_per_lun). There will
+scsi_change_queue_depth() (or struct Scsi_Host::cmd_per_lun). There will
 be at least one instance of struct scsi_cmnd available for each SCSI device.
 Members of interest:
     cmnd         - array containing SCSI command
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index c8bb6ab..de46385 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1164,7 +1164,7 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 
 		depth = min(sdev->host->can_queue, ata_id_queue_depth(dev->id));
 		depth = min(ATA_MAX_QUEUE - 1, depth);
-		scsi_adjust_queue_depth(sdev, depth);
+		scsi_change_queue_depth(sdev, depth);
 	}
 
 	blk_queue_flush_queueable(q, false);
@@ -1243,21 +1243,17 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
  *	@ap: ATA port to which the device change the queue depth
  *	@sdev: SCSI device to configure queue depth for
  *	@queue_depth: new queue depth
- *	@reason: calling context
  *
  *	libsas and libata have different approaches for associating a sdev to
  *	its ata_port.
  *
  */
 int __ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
-			     int queue_depth, int reason)
+			     int queue_depth)
 {
 	struct ata_device *dev;
 	unsigned long flags;
 
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
-
 	if (queue_depth < 1 || queue_depth == sdev->queue_depth)
 		return sdev->queue_depth;
 
@@ -1282,15 +1278,13 @@ int __ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
 	if (sdev->queue_depth == queue_depth)
 		return -EINVAL;
 
-	scsi_adjust_queue_depth(sdev, queue_depth);
-	return queue_depth;
+	return scsi_change_queue_depth(sdev, queue_depth);
 }
 
 /**
  *	ata_scsi_change_queue_depth - SCSI callback for queue depth config
  *	@sdev: SCSI device to configure queue depth for
  *	@queue_depth: new queue depth
- *	@reason: calling context
  *
  *	This is libata standard hostt->change_queue_depth callback.
  *	SCSI will call into this callback when user tries to set queue
@@ -1302,12 +1296,11 @@ int __ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
  *	RETURNS:
  *	Newly configured queue depth.
  */
-int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth,
-				int reason)
+int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 
-	return __ata_change_queue_depth(ap, sdev, queue_depth, reason);
+	return __ata_change_queue_depth(ap, sdev, queue_depth);
 }
 
 /**
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index cdf99fa..1db6f5c 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1951,7 +1951,7 @@ static int nv_swncq_slave_config(struct scsi_device *sdev)
 	ata_id_c_string(dev->id, model_num, ATA_ID_PROD, sizeof(model_num));
 
 	if (strncmp(model_num, "Maxtor", 6) == 0) {
-		ata_scsi_change_queue_depth(sdev, 1, SCSI_QDEPTH_DEFAULT);
+		ata_scsi_change_queue_depth(sdev, 1);
 		ata_dev_notice(dev, "Disabling SWNCQ mode (depth %x)\n",
 			       sdev->queue_depth);
 	}
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 812a289..20ca6a6 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -911,7 +911,7 @@ static struct scsi_host_template iscsi_iser_sht = {
 	.module                 = THIS_MODULE,
 	.name                   = "iSCSI Initiator over iSER",
 	.queuecommand           = iscsi_queuecommand,
-	.change_queue_depth	= iscsi_change_queue_depth,
+	.change_queue_depth	= scsi_change_queue_depth,
 	.sg_tablesize           = ISCSI_ISER_SG_TABLESIZE,
 	.max_sectors		= 1024,
 	.cmd_per_lun            = ISER_DEF_CMD_PER_LUN,
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 8d13a19..5461924 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2402,18 +2402,15 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
  * srp_change_queue_depth - setting device queue depth
  * @sdev: scsi device struct
  * @qdepth: requested queue depth
- * @reason: SCSI_QDEPTH_DEFAULT
- * (see include/scsi/scsi_host.h for definition)
  *
  * Returns queue depth.
  */
 static int
-srp_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
+srp_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
 	if (!sdev->tagged_supported)
 		qdepth = 1;
-	scsi_adjust_queue_depth(sdev, qdepth);
-	return sdev->queue_depth;
+	return scsi_change_queue_depth(sdev, qdepth);
 }
 
 static int srp_send_tsk_mgmt(struct srp_rdma_ch *ch, u64 req_tag,
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index dee06d6..6c9fc11 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2311,12 +2311,11 @@ mptscsih_slave_destroy(struct scsi_device *sdev)
  *	mptscsih_change_queue_depth - This function will set a devices queue depth
  *	@sdev: per scsi_device pointer
  *	@qdepth: requested queue depth
- *	@reason: calling context
  *
  *	Adding support for new 'change_queue_depth' api.
 */
 int
-mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
+mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
 	MPT_SCSI_HOST		*hd = shost_priv(sdev->host);
 	VirtTarget 		*vtarget;
@@ -2327,9 +2326,6 @@ mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 	starget = scsi_target(sdev);
 	vtarget = starget->hostdata;
 
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
-
 	if (ioc->bus_type == SPI) {
 		if (!(vtarget->tflags & MPT_TARGET_FLAGS_Q_YES))
 			max_depth = 1;
@@ -2347,8 +2343,7 @@ mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 	if (qdepth > max_depth)
 		qdepth = max_depth;
 
-	scsi_adjust_queue_depth(sdev, qdepth);
-	return sdev->queue_depth;
+	return scsi_change_queue_depth(sdev, qdepth);
 }
 
 /*
@@ -2392,8 +2387,7 @@ mptscsih_slave_configure(struct scsi_device *sdev)
 		    ioc->name, vtarget->negoFlags, vtarget->maxOffset,
 		    vtarget->minSyncFactor));
 
-	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH,
-				    SCSI_QDEPTH_DEFAULT);
+	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH);
 	dsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		"tagged %d, simple %d\n",
 		ioc->name,sdev->tagged_supported, sdev->simple_tags));
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index e1b1a19..2baeefd 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -128,8 +128,7 @@ extern int mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_F
 extern int mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 extern int mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
-extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth,
-				       int reason);
+extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
 extern u8 mptscsih_raid_id_to_num(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern struct device_attribute *mptscsih_host_attrs[];
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 179bf3d..75f4bfc 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -32,13 +32,6 @@ static bool allow_lun_scan = 1;
 module_param(allow_lun_scan, bool, 0600);
 MODULE_PARM_DESC(allow_lun_scan, "For NPIV, scan and attach all storage LUNs");
 
-static int zfcp_scsi_change_queue_depth(struct scsi_device *sdev, int depth,
-					int reason)
-{
-	scsi_adjust_queue_depth(sdev, depth);
-	return sdev->queue_depth;
-}
-
 static void zfcp_scsi_slave_destroy(struct scsi_device *sdev)
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
@@ -54,7 +47,7 @@ static void zfcp_scsi_slave_destroy(struct scsi_device *sdev)
 static int zfcp_scsi_slave_configure(struct scsi_device *sdp)
 {
 	if (sdp->tagged_supported)
-		scsi_adjust_queue_depth(sdp, default_depth);
+		scsi_change_queue_depth(sdp, default_depth);
 	return 0;
 }
 
@@ -293,7 +286,7 @@ static struct scsi_host_template zfcp_scsi_host_template = {
 	.slave_alloc		 = zfcp_scsi_slave_alloc,
 	.slave_configure	 = zfcp_scsi_slave_configure,
 	.slave_destroy		 = zfcp_scsi_slave_destroy,
-	.change_queue_depth	 = zfcp_scsi_change_queue_depth,
+	.change_queue_depth	 = scsi_change_queue_depth,
 	.proc_name		 = "zfcp",
 	.can_queue		 = 4096,
 	.this_id		 = -1,
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 1cf3703..cd4129f 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -189,17 +189,6 @@ static ssize_t twa_show_stats(struct device *dev,
 	return len;
 } /* End twa_show_stats() */
 
-/* This function will set a devices queue depth */
-static int twa_change_queue_depth(struct scsi_device *sdev, int queue_depth,
-				  int reason)
-{
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
-
-	scsi_adjust_queue_depth(sdev, queue_depth);
-	return queue_depth;
-} /* End twa_change_queue_depth() */
-
 /* Create sysfs 'stats' entry */
 static struct device_attribute twa_host_stats_attr = {
 	.attr = {
@@ -2014,7 +2003,7 @@ static struct scsi_host_template driver_template = {
 	.queuecommand		= twa_scsi_queue,
 	.eh_host_reset_handler	= twa_scsi_eh_reset,
 	.bios_param		= twa_scsi_biosparam,
-	.change_queue_depth	= twa_change_queue_depth,
+	.change_queue_depth	= scsi_change_queue_depth,
 	.can_queue		= TW_Q_LENGTH-2,
 	.slave_configure	= twa_slave_configure,
 	.this_id		= -1,
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 547756b..2361772 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -191,17 +191,6 @@ static ssize_t twl_show_stats(struct device *dev,
 	return len;
 } /* End twl_show_stats() */
 
-/* This function will set a devices queue depth */
-static int twl_change_queue_depth(struct scsi_device *sdev, int queue_depth,
-				  int reason)
-{
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
-
-	scsi_adjust_queue_depth(sdev, queue_depth);
-	return queue_depth;
-} /* End twl_change_queue_depth() */
-
 /* stats sysfs attribute initializer */
 static struct device_attribute twl_host_stats_attr = {
 	.attr = {
@@ -1588,7 +1577,7 @@ static struct scsi_host_template driver_template = {
 	.queuecommand		= twl_scsi_queue,
 	.eh_host_reset_handler	= twl_scsi_eh_reset,
 	.bios_param		= twl_scsi_biosparam,
-	.change_queue_depth	= twl_change_queue_depth,
+	.change_queue_depth	= scsi_change_queue_depth,
 	.can_queue		= TW_Q_LENGTH-2,
 	.slave_configure	= twl_slave_configure,
 	.this_id		= -1,
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 261a4c1..c75f204 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -523,17 +523,6 @@ static ssize_t tw_show_stats(struct device *dev, struct device_attribute *attr,
 	return len;
 } /* End tw_show_stats() */
 
-/* This function will set a devices queue depth */
-static int tw_change_queue_depth(struct scsi_device *sdev, int queue_depth,
-				 int reason)
-{
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
-
-	scsi_adjust_queue_depth(sdev, queue_depth);
-	return queue_depth;
-} /* End tw_change_queue_depth() */
-
 /* Create sysfs 'stats' entry */
 static struct device_attribute tw_host_stats_attr = {
 	.attr = {
@@ -2268,7 +2257,7 @@ static struct scsi_host_template driver_template = {
 	.queuecommand		= tw_scsi_queue,
 	.eh_host_reset_handler	= tw_scsi_eh_reset,
 	.bios_param		= tw_scsi_biosparam,
-	.change_queue_depth	= tw_change_queue_depth,
+	.change_queue_depth	= scsi_change_queue_depth,
 	.can_queue		= TW_Q_LENGTH-2,
 	.slave_configure	= tw_slave_configure,
 	.this_id		= -1,
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index d7557b9..aa915da 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -175,7 +175,7 @@ STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
 STATIC int NCR_700_slave_alloc(struct scsi_device *SDpnt);
 STATIC int NCR_700_slave_configure(struct scsi_device *SDpnt);
 STATIC void NCR_700_slave_destroy(struct scsi_device *SDpnt);
-static int NCR_700_change_queue_depth(struct scsi_device *SDpnt, int depth, int reason);
+static int NCR_700_change_queue_depth(struct scsi_device *SDpnt, int depth);
 static int NCR_700_change_queue_type(struct scsi_device *SDpnt, int depth);
 
 STATIC struct device_attribute *NCR_700_dev_attrs[];
@@ -904,7 +904,7 @@ process_message(struct Scsi_Host *host,	struct NCR_700_Host_Parameters *hostdata
 			hostdata->tag_negotiated &= ~(1<<scmd_id(SCp));
 
 			SCp->device->tagged_supported = 0;
-			scsi_adjust_queue_depth(SCp->device, host->cmd_per_lun);
+			scsi_change_queue_depth(SCp->device, host->cmd_per_lun);
 			scsi_set_tag_type(SCp->device, 0);
 		} else {
 			shost_printk(KERN_WARNING, host,
@@ -2052,7 +2052,7 @@ NCR_700_slave_configure(struct scsi_device *SDp)
 
 	/* to do here: allocate memory; build a queue_full list */
 	if(SDp->tagged_supported) {
-		scsi_adjust_queue_depth(SDp, NCR_700_DEFAULT_TAGS);
+		scsi_change_queue_depth(SDp, NCR_700_DEFAULT_TAGS);
 		NCR_700_set_tag_neg_state(SDp, NCR_700_START_TAG_NEGOTIATION);
 	}
 
@@ -2075,16 +2075,11 @@ NCR_700_slave_destroy(struct scsi_device *SDp)
 }
 
 static int
-NCR_700_change_queue_depth(struct scsi_device *SDp, int depth, int reason)
+NCR_700_change_queue_depth(struct scsi_device *SDp, int depth)
 {
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
-
 	if (depth > NCR_700_MAX_TAGS)
 		depth = NCR_700_MAX_TAGS;
-
-	scsi_adjust_queue_depth(SDp, depth);
-	return depth;
+	return scsi_change_queue_depth(SDp, depth);
 }
 
 static int NCR_700_change_queue_type(struct scsi_device *SDp, int tag_type)
@@ -2105,12 +2100,12 @@ static int NCR_700_change_queue_type(struct scsi_device *SDp, int tag_type)
 	if (!tag_type) {
 		/* shift back to the default unqueued number of commands
 		 * (the user can still raise this) */
-		scsi_adjust_queue_depth(SDp, SDp->host->cmd_per_lun);
+		scsi_change_queue_depth(SDp, SDp->host->cmd_per_lun);
 		hostdata->tag_negotiated &= ~(1 << sdev_id(SDp));
 	} else {
 		/* Here, we cleared the negotiation flag above, so this
 		 * will force the driver to renegotiate */
-		scsi_adjust_queue_depth(SDp, SDp->queue_depth);
+		scsi_change_queue_depth(SDp, SDp->queue_depth);
 		if (change_tag)
 			NCR_700_set_tag_neg_state(SDp, NCR_700_START_TAG_NEGOTIATION);
 	}
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 5aa476b..8d66a64 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2327,12 +2327,12 @@ static int blogic_slaveconfig(struct scsi_device *dev)
 		if (qdepth == 0)
 			qdepth = BLOGIC_MAX_AUTO_TAG_DEPTH;
 		adapter->qdepth[tgt_id] = qdepth;
-		scsi_adjust_queue_depth(dev, qdepth);
+		scsi_change_queue_depth(dev, qdepth);
 	} else {
 		adapter->tagq_ok &= ~(1 << tgt_id);
 		qdepth = adapter->untag_qdepth;
 		adapter->qdepth[tgt_id] = qdepth;
-		scsi_adjust_queue_depth(dev, qdepth);
+		scsi_change_queue_depth(dev, qdepth);
 	}
 	qdepth = 0;
 	for (tgt_id = 0; tgt_id < adapter->maxdev; tgt_id++)
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 41b9c68..d11c23a 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -462,9 +462,9 @@ static int aac_slave_configure(struct scsi_device *sdev)
 			depth = 256;
 		else if (depth < 2)
 			depth = 2;
-		scsi_adjust_queue_depth(sdev, depth);
+		scsi_change_queue_depth(sdev, depth);
 	} else
-		scsi_adjust_queue_depth(sdev, 1);
+		scsi_change_queue_depth(sdev, 1);
 
 	return 0;
 }
@@ -478,12 +478,8 @@ static int aac_slave_configure(struct scsi_device *sdev)
  *	total capacity and the queue depth supported by the target device.
  */
 
-static int aac_change_queue_depth(struct scsi_device *sdev, int depth,
-				  int reason)
+static int aac_change_queue_depth(struct scsi_device *sdev, int depth)
 {
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
-
 	if (sdev->tagged_supported && (sdev->type == TYPE_DISK) &&
 	    (sdev_channel(sdev) == CONTAINER_CHANNEL)) {
 		struct scsi_device * dev;
@@ -504,10 +500,10 @@ static int aac_change_queue_depth(struct scsi_device *sdev, int depth,
 			depth = 256;
 		else if (depth < 2)
 			depth = 2;
-		scsi_adjust_queue_depth(sdev, depth);
-	} else
-		scsi_adjust_queue_depth(sdev, 1);
-	return sdev->queue_depth;
+		return scsi_change_queue_depth(sdev, depth);
+	}
+
+	return scsi_change_queue_depth(sdev, 1);
 }
 
 static ssize_t aac_show_raid_level(struct device *dev, struct device_attribute *attr, char *buf)
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ae4840e..6719a33 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7706,7 +7706,7 @@ advansys_narrow_slave_configure(struct scsi_device *sdev, ASC_DVC_VAR *asc_dvc)
 				asc_dvc->cfg->can_tagged_qng |= tid_bit;
 				asc_dvc->use_tagged_qng |= tid_bit;
 			}
-			scsi_adjust_queue_depth(sdev, 
+			scsi_change_queue_depth(sdev, 
 						asc_dvc->max_dvc_qng[sdev->id]);
 		}
 	} else {
@@ -7847,10 +7847,8 @@ advansys_wide_slave_configure(struct scsi_device *sdev, ADV_DVC_VAR *adv_dvc)
 		}
 	}
 
-	if ((adv_dvc->tagqng_able & tidmask) && sdev->tagged_supported) {
-		scsi_adjust_queue_depth(sdev,
-					adv_dvc->max_dvc_qng);
-	}
+	if ((adv_dvc->tagqng_able & tidmask) && sdev->tagged_supported)
+		scsi_change_queue_depth(sdev, adv_dvc->max_dvc_qng);
 }
 
 /*
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 80cb4fd..d5c7b19 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1470,7 +1470,7 @@ ahd_platform_set_tags(struct ahd_softc *ahd, struct scsi_device *sdev,
 	switch ((dev->flags & (AHD_DEV_Q_BASIC|AHD_DEV_Q_TAGGED))) {
 	case AHD_DEV_Q_BASIC:
 	case AHD_DEV_Q_TAGGED:
-		scsi_adjust_queue_depth(sdev,
+		scsi_change_queue_depth(sdev,
 				dev->openings + dev->active);
 		break;
 	default:
@@ -1480,7 +1480,7 @@ ahd_platform_set_tags(struct ahd_softc *ahd, struct scsi_device *sdev,
 		 * serially on the controller/device.  This should
 		 * remove some latency.
 		 */
-		scsi_adjust_queue_depth(sdev, 1);
+		scsi_change_queue_depth(sdev, 1);
 		break;
 	}
 }
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index a6a27d5..8836011 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1336,7 +1336,7 @@ ahc_platform_set_tags(struct ahc_softc *ahc, struct scsi_device *sdev,
 	switch ((dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED))) {
 	case AHC_DEV_Q_BASIC:
 	case AHC_DEV_Q_TAGGED:
-		scsi_adjust_queue_depth(sdev,
+		scsi_change_queue_depth(sdev,
 				dev->openings + dev->active);
 	default:
 		/*
@@ -1345,7 +1345,7 @@ ahc_platform_set_tags(struct ahc_softc *ahc, struct scsi_device *sdev,
 		 * serially on the controller/device.  This should
 		 * remove some latency.
 		 */
-		scsi_adjust_queue_depth(sdev, 2);
+		scsi_change_queue_depth(sdev, 2);
 		break;
 	}
 }
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 209f771..914c39f 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -114,16 +114,11 @@ static void arcmsr_hardware_reset(struct AdapterControlBlock *acb);
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
 static void arcmsr_free_irq(struct pci_dev *, struct AdapterControlBlock *);
-static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev,
-					  int queue_depth, int reason)
+static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev, int queue_depth)
 {
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
-
 	if (queue_depth > ARCMSR_MAX_CMD_PERLUN)
 		queue_depth = ARCMSR_MAX_CMD_PERLUN;
-	scsi_adjust_queue_depth(sdev, queue_depth);
-	return queue_depth;
+	return scsi_change_queue_depth(sdev, queue_depth);
 }
 
 static struct scsi_host_template arcmsr_scsi_host_template = {
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index d9b999a..f319340 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -556,7 +556,7 @@ static struct scsi_host_template beiscsi_sht = {
 	.name = "Emulex 10Gbe open-iscsi Initiator Driver",
 	.proc_name = DRV_NAME,
 	.queuecommand = iscsi_queuecommand,
-	.change_queue_depth = iscsi_change_queue_depth,
+	.change_queue_depth = scsi_change_queue_depth,
 	.slave_configure = beiscsi_slave_configure,
 	.target_alloc = iscsi_target_alloc,
 	.eh_abort_handler = beiscsi_eh_abort,
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 87b09cd2..7223b00 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -776,7 +776,7 @@ bfad_thread_workq(struct bfad_s *bfad)
 static int
 bfad_im_slave_configure(struct scsi_device *sdev)
 {
-	scsi_adjust_queue_depth(sdev, bfa_lun_queue_depth);
+	scsi_change_queue_depth(sdev, bfa_lun_queue_depth);
 	return 0;
 }
 
@@ -866,7 +866,7 @@ bfad_ramp_up_qdepth(struct bfad_itnim_s *itnim, struct scsi_device *sdev)
 			if (bfa_lun_queue_depth > tmp_sdev->queue_depth) {
 				if (tmp_sdev->id != sdev->id)
 					continue;
-				scsi_adjust_queue_depth(tmp_sdev,
+				scsi_change_queue_depth(tmp_sdev,
 					tmp_sdev->queue_depth + 1);
 
 				itnim->last_ramp_up_time = jiffies;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index cc53797..386c2cf 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2784,7 +2784,7 @@ static struct scsi_host_template bnx2fc_shost_template = {
 	.eh_target_reset_handler = bnx2fc_eh_target_reset, /* tgt reset */
 	.eh_host_reset_handler	= fc_eh_host_reset,
 	.slave_alloc		= fc_slave_alloc,
-	.change_queue_depth	= fc_change_queue_depth,
+	.change_queue_depth	= scsi_change_queue_depth,
 	.change_queue_type	= scsi_change_queue_type,
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 9de1c20..e53078d 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2259,7 +2259,7 @@ static struct scsi_host_template bnx2i_host_template = {
 	.eh_abort_handler	= iscsi_eh_abort,
 	.eh_device_reset_handler = iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_recover_target,
-	.change_queue_depth	= iscsi_change_queue_depth,
+	.change_queue_depth	= scsi_change_queue_depth,
 	.target_alloc		= iscsi_target_alloc,
 	.can_queue		= 2048,
 	.max_sectors		= 127,
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 44a8cc5..4d0b6ce 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2241,7 +2241,7 @@ csio_slave_alloc(struct scsi_device *sdev)
 static int
 csio_slave_configure(struct scsi_device *sdev)
 {
-	scsi_adjust_queue_depth(sdev, csio_lun_qdepth);
+	scsi_change_queue_depth(sdev, csio_lun_qdepth);
 	return 0;
 }
 
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 99ea67d..3db4c63 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -86,7 +86,7 @@ static struct scsi_host_template cxgb3i_host_template = {
 	.proc_name	= DRV_MODULE_NAME,
 	.can_queue	= CXGB3I_SCSI_HOST_QDEPTH,
 	.queuecommand	= iscsi_queuecommand,
-	.change_queue_depth = iscsi_change_queue_depth,
+	.change_queue_depth = scsi_change_queue_depth,
 	.sg_tablesize	= SG_ALL,
 	.max_sectors	= 0xFFFF,
 	.cmd_per_lun	= ISCSI_DEF_CMD_PER_LUN,
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index af86e8f..efe42ef 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -89,7 +89,7 @@ static struct scsi_host_template cxgb4i_host_template = {
 	.proc_name	= DRV_MODULE_NAME,
 	.can_queue	= CXGB4I_SCSI_HOST_QDEPTH,
 	.queuecommand	= iscsi_queuecommand,
-	.change_queue_depth = iscsi_change_queue_depth,
+	.change_queue_depth = scsi_change_queue_depth,
 	.sg_tablesize	= SG_ALL,
 	.max_sectors	= 0xFFFF,
 	.cmd_per_lun	= ISCSI_DEF_CMD_PER_LUN,
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 1af8d54..0bf9769 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -415,7 +415,7 @@ static int adpt_slave_configure(struct scsi_device * device)
 	pHba = (adpt_hba *) host->hostdata[0];
 
 	if (host->can_queue && device->tagged_supported) {
-		scsi_adjust_queue_depth(device,
+		scsi_change_queue_depth(device,
 				host->can_queue - 1);
 	}
 	return 0;
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index bc0f918..227dd2c 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -952,12 +952,12 @@ static int eata2x_slave_configure(struct scsi_device *dev)
 		} else {
 			tag_suffix = ", no tags";
 		}
-		scsi_adjust_queue_depth(dev, tqd);
+		scsi_change_queue_depth(dev, tqd);
 	} else if (TLDEV(dev->type) && linked_comm) {
-		scsi_adjust_queue_depth(dev, tqd);
+		scsi_change_queue_depth(dev, tqd);
 		tag_suffix = ", untagged";
 	} else {
-		scsi_adjust_queue_depth(dev, utqd);
+		scsi_change_queue_depth(dev, utqd);
 		tag_suffix = "";
 	}
 
diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index 1941d83..b6030e3 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -972,7 +972,6 @@ u8 handle_hba_ioctl(struct esas2r_adapter *a,
 		    struct atto_ioctl *ioctl_hba);
 int esas2r_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd);
 int esas2r_show_info(struct seq_file *m, struct Scsi_Host *sh);
-int esas2r_change_queue_depth(struct scsi_device *dev, int depth, int reason);
 long esas2r_proc_ioctl(struct file *fp, unsigned int cmd, unsigned long arg);
 
 /* SCSI error handler (eh) functions */
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 30fce64..593ff8a 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -254,7 +254,7 @@ static struct scsi_host_template driver_template = {
 	.use_clustering			= ENABLE_CLUSTERING,
 	.emulated			= 0,
 	.proc_name			= ESAS2R_DRVR_NAME,
-	.change_queue_depth		= esas2r_change_queue_depth,
+	.change_queue_depth		= scsi_change_queue_depth,
 	.change_queue_type		= scsi_change_queue_type,
 	.max_sectors			= 0xFFFF,
 	.use_blk_tags			= 1,
@@ -1257,15 +1257,6 @@ int esas2r_target_reset(struct scsi_cmnd *cmd)
 	return esas2r_dev_targ_reset(cmd, true);
 }
 
-int esas2r_change_queue_depth(struct scsi_device *dev, int depth, int reason)
-{
-	esas2r_log(ESAS2R_LOG_INFO, "change_queue_depth %p, %d", dev, depth);
-
-	scsi_adjust_queue_depth(dev, depth);
-
-	return dev->queue_depth;
-}
-
 void esas2r_log_request_failure(struct esas2r_adapter *a,
 				struct esas2r_request *rq)
 {
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 38c23e0..7e7687f 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2407,7 +2407,7 @@ static int esp_slave_configure(struct scsi_device *dev)
 		/* XXX make this configurable somehow XXX */
 		int goal_tags = min(ESP_DEFAULT_TAGS, ESP_MAX_TAG);
 
-		scsi_adjust_queue_depth(dev, goal_tags);
+		scsi_change_queue_depth(dev, goal_tags);
 	}
 
 	tp->flags |= ESP_TGT_DISCONNECT;
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 9722986..308a016 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -280,7 +280,7 @@ static struct scsi_host_template fcoe_shost_template = {
 	.eh_device_reset_handler = fc_eh_device_reset,
 	.eh_host_reset_handler = fc_eh_host_reset,
 	.slave_alloc = fc_slave_alloc,
-	.change_queue_depth = fc_change_queue_depth,
+	.change_queue_depth = scsi_change_queue_depth,
 	.change_queue_type = scsi_change_queue_type,
 	.this_id = -1,
 	.cmd_per_lun = 3,
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 10d7767..a64c62e 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -98,7 +98,7 @@ static int fnic_slave_alloc(struct scsi_device *sdev)
 	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
 
-	scsi_adjust_queue_depth(sdev, fnic_max_qdepth);
+	scsi_change_queue_depth(sdev, fnic_max_qdepth);
 	return 0;
 }
 
@@ -110,7 +110,7 @@ static struct scsi_host_template fnic_host_template = {
 	.eh_device_reset_handler = fnic_device_reset,
 	.eh_host_reset_handler = fnic_host_reset,
 	.slave_alloc = fnic_slave_alloc,
-	.change_queue_depth = fc_change_queue_depth,
+	.change_queue_depth = scsi_change_queue_depth,
 	.change_queue_type = scsi_change_queue_type,
 	.this_id = -1,
 	.cmd_per_lun = 3,
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f3c04b7..f0b7266 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -214,8 +214,6 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static void hpsa_scan_start(struct Scsi_Host *);
 static int hpsa_scan_finished(struct Scsi_Host *sh,
 	unsigned long elapsed_time);
-static int hpsa_change_queue_depth(struct scsi_device *sdev,
-	int qdepth, int reason);
 
 static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd);
 static int hpsa_eh_abort_handler(struct scsi_cmnd *scsicmd);
@@ -670,7 +668,7 @@ static struct scsi_host_template hpsa_driver_template = {
 	.queuecommand		= hpsa_scsi_queue_command,
 	.scan_start		= hpsa_scan_start,
 	.scan_finished		= hpsa_scan_finished,
-	.change_queue_depth	= hpsa_change_queue_depth,
+	.change_queue_depth	= scsi_change_queue_depth,
 	.this_id		= -1,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.eh_abort_handler	= hpsa_eh_abort_handler,
@@ -4152,18 +4150,6 @@ static int hpsa_scan_finished(struct Scsi_Host *sh,
 	return finished;
 }
 
-static int hpsa_change_queue_depth(struct scsi_device *sdev,
-	int qdepth, int reason)
-{
-	struct ctlr_info *h = sdev_to_hba(sdev);
-
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -ENOTSUPP;
-
-	scsi_adjust_queue_depth(sdev, qdepth);
-	return sdev->queue_depth;
-}
-
 static void hpsa_unregister_scsi(struct ctlr_info *h)
 {
 	/* we are being forcibly unloaded, and may not refuse. */
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 1518931..e995218 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1118,17 +1118,13 @@ static int hptiop_reset(struct scsi_cmnd *scp)
 }
 
 static int hptiop_adjust_disk_queue_depth(struct scsi_device *sdev,
-					  int queue_depth, int reason)
+					  int queue_depth)
 {
 	struct hptiop_hba *hba = (struct hptiop_hba *)sdev->host->hostdata;
 
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
-
 	if (queue_depth > hba->max_requests)
 		queue_depth = hba->max_requests;
-	scsi_adjust_queue_depth(sdev, queue_depth);
-	return queue_depth;
+	return scsi_change_queue_depth(sdev, queue_depth);
 }
 
 static ssize_t hptiop_show_version(struct device *dev,
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 381449d..f58c6d8 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2900,17 +2900,12 @@ static int ibmvfc_slave_configure(struct scsi_device *sdev)
  * Return value:
  * 	actual depth set
  **/
-static int ibmvfc_change_queue_depth(struct scsi_device *sdev, int qdepth,
-				     int reason)
+static int ibmvfc_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
-
 	if (qdepth > IBMVFC_MAX_CMDS_PER_LUN)
 		qdepth = IBMVFC_MAX_CMDS_PER_LUN;
 
-	scsi_adjust_queue_depth(sdev, qdepth);
-	return sdev->queue_depth;
+	return scsi_change_queue_depth(sdev, qdepth);
 }
 
 static ssize_t ibmvfc_show_host_partition_name(struct device *dev,
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index e8c3cdf..acea5d6 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1941,17 +1941,11 @@ static int ibmvscsi_slave_configure(struct scsi_device *sdev)
  * Return value:
  * 	actual depth set
  **/
-static int ibmvscsi_change_queue_depth(struct scsi_device *sdev, int qdepth,
-				       int reason)
+static int ibmvscsi_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
-
 	if (qdepth > IBMVSCSI_MAX_CMDS_PER_LUN)
 		qdepth = IBMVSCSI_MAX_CMDS_PER_LUN;
-
-	scsi_adjust_queue_depth(sdev, qdepth);
-	return sdev->queue_depth;
+	return scsi_change_queue_depth(sdev, qdepth);
 }
 
 /* ------------------------------------------------------------
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index d8d1662..5402943 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4328,16 +4328,12 @@ static int ipr_free_dump(struct ipr_ioa_cfg *ioa_cfg) { return 0; };
  * Return value:
  * 	actual depth set
  **/
-static int ipr_change_queue_depth(struct scsi_device *sdev, int qdepth,
-				  int reason)
+static int ipr_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)sdev->host->hostdata;
 	struct ipr_resource_entry *res;
 	unsigned long lock_flags = 0;
 
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
-
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *)sdev->hostdata;
 
@@ -4345,7 +4341,7 @@ static int ipr_change_queue_depth(struct scsi_device *sdev, int qdepth,
 		qdepth = IPR_MAX_CMD_PER_ATA_LUN;
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
-	scsi_adjust_queue_depth(sdev, qdepth);
+	scsi_change_queue_depth(sdev, qdepth);
 	return sdev->queue_depth;
 }
 
@@ -4752,7 +4748,7 @@ static int ipr_slave_configure(struct scsi_device *sdev)
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
 		if (ap) {
-			scsi_adjust_queue_depth(sdev, IPR_MAX_CMD_PER_ATA_LUN);
+			scsi_change_queue_depth(sdev, IPR_MAX_CMD_PER_ATA_LUN);
 			ata_sas_slave_configure(sdev, ap);
 		}
 
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 454741a..e5c2843 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1210,7 +1210,7 @@ ips_slave_configure(struct scsi_device * SDptr)
 		min = ha->max_cmds / 2;
 		if (ha->enq->ucLogDriveCount <= 2)
 			min = ha->max_cmds - 1;
-		scsi_adjust_queue_depth(SDptr, min);
+		scsi_change_queue_depth(SDptr, min);
 	}
 
 	SDptr->skip_ms_page_8 = 1;
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index a575d84..0b8af18 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -952,7 +952,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.module			= THIS_MODULE,
 	.name			= "iSCSI Initiator over TCP/IP",
 	.queuecommand           = iscsi_queuecommand,
-	.change_queue_depth	= iscsi_change_queue_depth,
+	.change_queue_depth	= scsi_change_queue_depth,
 	.can_queue		= ISCSI_DEF_XMIT_CMDS_MAX - 1,
 	.sg_tablesize		= 4096,
 	.max_sectors		= 0xFFFF,
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 0d2d024..c679594 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2160,25 +2160,12 @@ int fc_slave_alloc(struct scsi_device *sdev)
 	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
 
-	scsi_adjust_queue_depth(sdev, FC_FCP_DFLT_QUEUE_DEPTH);
+	scsi_change_queue_depth(sdev, FC_FCP_DFLT_QUEUE_DEPTH);
 	return 0;
 }
 EXPORT_SYMBOL(fc_slave_alloc);
 
 /**
- * fc_change_queue_depth() - Change a device's queue depth
- * @sdev:   The SCSI device whose queue depth is to change
- * @qdepth: The new queue depth
- * @reason: The resason for the change
- */
-int fc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
-{
-	scsi_adjust_queue_depth(sdev, qdepth);
-	return sdev->queue_depth;
-}
-EXPORT_SYMBOL(fc_change_queue_depth);
-
-/**
  * fc_fcp_destory() - Tear down the FCP layer for a given local port
  * @lport: The local port that no longer needs the FCP layer
  */
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 79e9774..8053f24 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1771,13 +1771,6 @@ fault:
 }
 EXPORT_SYMBOL_GPL(iscsi_queuecommand);
 
-int iscsi_change_queue_depth(struct scsi_device *sdev, int depth, int reason)
-{
-	scsi_adjust_queue_depth(sdev, depth);
-	return sdev->queue_depth;
-}
-EXPORT_SYMBOL_GPL(iscsi_change_queue_depth);
-
 int iscsi_target_alloc(struct scsi_target *starget)
 {
 	struct iscsi_cls_session *cls_session = starget_to_session(starget);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 914e411..b492293 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -940,12 +940,12 @@ int sas_slave_configure(struct scsi_device *scsi_dev)
 	sas_read_port_mode_page(scsi_dev);
 
 	if (scsi_dev->tagged_supported) {
-		scsi_adjust_queue_depth(scsi_dev, SAS_DEF_QD);
+		scsi_change_queue_depth(scsi_dev, SAS_DEF_QD);
 	} else {
 		SAS_DPRINTK("device %llx, LUN %llx doesn't support "
 			    "TCQ\n", SAS_ADDR(dev->sas_addr),
 			    scsi_dev->lun);
-		scsi_adjust_queue_depth(scsi_dev, 1);
+		scsi_change_queue_depth(scsi_dev, 1);
 	}
 
 	scsi_dev->allow_restart = 1;
@@ -953,18 +953,16 @@ int sas_slave_configure(struct scsi_device *scsi_dev)
 	return 0;
 }
 
-int sas_change_queue_depth(struct scsi_device *sdev, int depth, int reason)
+int sas_change_queue_depth(struct scsi_device *sdev, int depth)
 {
 	struct domain_device *dev = sdev_to_domain_dev(sdev);
 
 	if (dev_is_sata(dev))
-		return __ata_change_queue_depth(dev->sata_dev.ap, sdev, depth,
-						reason);
+		return __ata_change_queue_depth(dev->sata_dev.ap, sdev, depth);
 
 	if (!sdev->tagged_supported)
 		depth = 1;
-	scsi_adjust_queue_depth(sdev, depth);
-	return depth;
+	return scsi_change_queue_depth(sdev, depth);
 }
 
 int sas_change_queue_type(struct scsi_device *scsi_dev, int type)
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 5228549..fd85952 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -243,23 +243,6 @@ lpfc_update_stats(struct lpfc_hba *phba, struct  lpfc_scsi_buf *lpfc_cmd)
 }
 
 /**
- * lpfc_change_queue_depth - Alter scsi device queue depth
- * @sdev: Pointer the scsi device on which to change the queue depth.
- * @qdepth: New queue depth to set the sdev to.
- * @reason: The reason for the queue depth change.
- *
- * This function is called by the midlayer and the LLD to alter the queue
- * depth for a scsi device. This function sets the queue depth to the new
- * value and sends an event out to log the queue depth change.
- **/
-static int
-lpfc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
-{
-	scsi_adjust_queue_depth(sdev, qdepth);
-	return sdev->queue_depth;
-}
-
-/**
  * lpfc_rampdown_queue_depth - Post RAMP_DOWN_QUEUE event to worker thread
  * @phba: The Hba for which this call is being executed.
  *
@@ -344,8 +327,7 @@ lpfc_ramp_down_queue_handler(struct lpfc_hba *phba)
 				else
 					new_queue_depth = sdev->queue_depth -
 								new_queue_depth;
-				lpfc_change_queue_depth(sdev, new_queue_depth,
-							SCSI_QDEPTH_DEFAULT);
+				scsi_change_queue_depth(sdev, new_queue_depth);
 			}
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
@@ -5513,7 +5495,7 @@ lpfc_slave_configure(struct scsi_device *sdev)
 	struct lpfc_vport *vport = (struct lpfc_vport *) sdev->host->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	scsi_adjust_queue_depth(sdev, vport->cfg_lun_queue_depth);
+	scsi_change_queue_depth(sdev, vport->cfg_lun_queue_depth);
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
 		lpfc_sli_handle_fast_ring_event(phba,
@@ -5896,7 +5878,7 @@ struct scsi_host_template lpfc_template = {
 	.shost_attrs		= lpfc_hba_attrs,
 	.max_sectors		= 0xFFFF,
 	.vendor_id		= LPFC_NL_VENDOR_ID,
-	.change_queue_depth	= lpfc_change_queue_depth,
+	.change_queue_depth	= scsi_change_queue_depth,
 	.change_queue_type	= scsi_change_queue_type,
 	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
@@ -5921,7 +5903,7 @@ struct scsi_host_template lpfc_vport_template = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= lpfc_vport_attrs,
 	.max_sectors		= 0xFFFF,
-	.change_queue_depth	= lpfc_change_queue_depth,
+	.change_queue_depth	= scsi_change_queue_depth,
 	.change_queue_type	= scsi_change_queue_type,
 	.use_blk_tags		= 1,
 	.track_queue_depth	= 1,
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index d56eb9d..f0987f2 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -332,25 +332,6 @@ static struct device_attribute *megaraid_sdev_attrs[] = {
 	NULL,
 };
 
-/**
- * megaraid_change_queue_depth - Change the device's queue depth
- * @sdev:	scsi device struct
- * @qdepth:	depth to set
- * @reason:	calling context
- *
- * Return value:
- * 	actual depth set
- */
-static int megaraid_change_queue_depth(struct scsi_device *sdev, int qdepth,
-				       int reason)
-{
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
-
-	scsi_adjust_queue_depth(sdev, qdepth);
-	return sdev->queue_depth;
-}
-
 /*
  * Scsi host template for megaraid unified driver
  */
@@ -363,7 +344,7 @@ static struct scsi_host_template megaraid_template_g = {
 	.eh_device_reset_handler	= megaraid_reset_handler,
 	.eh_bus_reset_handler		= megaraid_reset_handler,
 	.eh_host_reset_handler		= megaraid_reset_handler,
-	.change_queue_depth		= megaraid_change_queue_depth,
+	.change_queue_depth		= scsi_change_queue_depth,
 	.use_clustering			= ENABLE_CLUSTERING,
 	.no_write_same			= 1,
 	.sdev_attrs			= megaraid_sdev_attrs,
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 445a649..0358b90 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2586,17 +2586,6 @@ megasas_service_aen(struct megasas_instance *instance, struct megasas_cmd *cmd)
 	}
 }
 
-static int megasas_change_queue_depth(struct scsi_device *sdev,
-				      int queue_depth, int reason)
-{
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
-
-	scsi_adjust_queue_depth(sdev, queue_depth);
-
-	return queue_depth;
-}
-
 static ssize_t
 megasas_fw_crash_buffer_store(struct device *cdev,
 	struct device_attribute *attr, const char *buf, size_t count)
@@ -2761,7 +2750,7 @@ static struct scsi_host_template megasas_template = {
 	.shost_attrs = megaraid_host_attrs,
 	.bios_param = megasas_bios_param,
 	.use_clustering = ENABLE_CLUSTERING,
-	.change_queue_depth = megasas_change_queue_depth,
+	.change_queue_depth = scsi_change_queue_depth,
 	.no_write_same = 1,
 };
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index b006e1e..12229de 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1222,20 +1222,18 @@ _scsih_adjust_queue_depth(struct scsi_device *sdev, int qdepth)
 		max_depth = 1;
 	if (qdepth > max_depth)
 		qdepth = max_depth;
-	scsi_adjust_queue_depth(sdev, qdepth);
+	scsi_change_queue_depth(sdev, qdepth);
 }
 
 /**
  * _scsih_change_queue_depth - setting device queue depth
  * @sdev: scsi device struct
  * @qdepth: requested queue depth
- * @reason: SCSI_QDEPTH_DEFAULT
- * (see include/scsi/scsi_host.h for definition)
  *
  * Returns queue depth.
  */
 static int
-_scsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
+_scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
 	_scsih_adjust_queue_depth(sdev, qdepth);
 
@@ -2077,7 +2075,7 @@ _scsih_slave_configure(struct scsi_device *sdev)
 			    r_level, raid_device->handle,
 			    (unsigned long long)raid_device->wwid,
 			    raid_device->num_pds, ds);
-		_scsih_change_queue_depth(sdev, qdepth, SCSI_QDEPTH_DEFAULT);
+		_scsih_change_queue_depth(sdev, qdepth);
 		/* raid transport support */
 		if (!ioc->is_warpdrive)
 			_scsih_set_level(sdev, raid_device->volume_type);
@@ -2142,7 +2140,7 @@ _scsih_slave_configure(struct scsi_device *sdev)
 		_scsih_display_sata_capabilities(ioc, handle, sdev);
 
 
-	_scsih_change_queue_depth(sdev, qdepth, SCSI_QDEPTH_DEFAULT);
+	_scsih_change_queue_depth(sdev, qdepth);
 
 	if (ssp_target) {
 		sas_read_port_mode_page(sdev);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 568dcae..de175b9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1090,20 +1090,18 @@ _scsih_adjust_queue_depth(struct scsi_device *sdev, int qdepth)
 		max_depth = 1;
 	if (qdepth > max_depth)
 		qdepth = max_depth;
-	scsi_adjust_queue_depth(sdev, qdepth);
+	scsi_change_queue_depth(sdev, qdepth);
 }
 
 /**
  * _scsih_change_queue_depth - setting device queue depth
  * @sdev: scsi device struct
  * @qdepth: requested queue depth
- * @reason: SCSI_QDEPTH_DEFAULT
- * (see include/scsi/scsi_host.h for definition)
  *
  * Returns queue depth.
  */
 static int
-_scsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
+_scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
 	_scsih_adjust_queue_depth(sdev, qdepth);
 
@@ -1734,7 +1732,7 @@ _scsih_slave_configure(struct scsi_device *sdev)
 			 raid_device->num_pds, ds);
 
 
-		_scsih_change_queue_depth(sdev, qdepth, SCSI_QDEPTH_DEFAULT);
+		_scsih_change_queue_depth(sdev, qdepth);
 
 /* raid transport support */
 		_scsih_set_level(sdev, raid_device->volume_type);
@@ -1800,7 +1798,7 @@ _scsih_slave_configure(struct scsi_device *sdev)
 		_scsih_display_sata_capabilities(ioc, handle, sdev);
 
 
-	_scsih_change_queue_depth(sdev, qdepth, SCSI_QDEPTH_DEFAULT);
+	_scsih_change_queue_depth(sdev, qdepth);
 
 	if (ssp_target) {
 		sas_read_port_mode_page(sdev);
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 9c331b7..5b93ed8 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -7997,7 +7997,7 @@ static int ncr53c8xx_slave_configure(struct scsi_device *device)
 	if (depth_to_use > MAX_TAGS)
 		depth_to_use = MAX_TAGS;
 
-	scsi_adjust_queue_depth(device, depth_to_use);
+	scsi_change_queue_depth(device, depth_to_use);
 
 	/*
 	**	Since the queue depth is not tunable under Linux,
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index d8b9ba2..b1b1f66 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -285,23 +285,15 @@ static void pmcraid_slave_destroy(struct scsi_device *scsi_dev)
  * pmcraid_change_queue_depth - Change the device's queue depth
  * @scsi_dev: scsi device struct
  * @depth: depth to set
- * @reason: calling context
  *
  * Return value
  *	actual depth set
  */
-static int pmcraid_change_queue_depth(struct scsi_device *scsi_dev, int depth,
-				      int reason)
+static int pmcraid_change_queue_depth(struct scsi_device *scsi_dev, int depth)
 {
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
-
 	if (depth > PMCRAID_MAX_CMD_PER_LUN)
 		depth = PMCRAID_MAX_CMD_PER_LUN;
-
-	scsi_adjust_queue_depth(scsi_dev, depth);
-
-	return scsi_dev->queue_depth;
+	return scsi_change_queue_depth(scsi_dev, depth);
 }
 
 /**
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index adedb6e..c68a66e 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1224,9 +1224,9 @@ qla1280_slave_configure(struct scsi_device *device)
 
 	if (device->tagged_supported &&
 	    (ha->bus_settings[bus].qtag_enables & (BIT_0 << target))) {
-		scsi_adjust_queue_depth(device, ha->bus_settings[bus].hiwat);
+		scsi_change_queue_depth(device, ha->bus_settings[bus].hiwat);
 	} else {
-		scsi_adjust_queue_depth(device, default_depth);
+		scsi_change_queue_depth(device, default_depth);
 	}
 
 	nv->bus[bus].target[target].parameter.enable_sync = device->sdtr;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 20049b1..6b4d923 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -236,7 +236,6 @@ static int qla2xxx_eh_target_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_bus_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_host_reset(struct scsi_cmnd *);
 
-static int qla2x00_change_queue_depth(struct scsi_device *, int, int);
 static void qla2x00_clear_drv_active(struct qla_hw_data *);
 static void qla2x00_free_device(scsi_qla_host_t *);
 static void qla83xx_disable_laser(scsi_qla_host_t *vha);
@@ -258,7 +257,7 @@ struct scsi_host_template qla2xxx_driver_template = {
 	.slave_destroy		= qla2xxx_slave_destroy,
 	.scan_finished		= qla2xxx_scan_finished,
 	.scan_start		= qla2xxx_scan_start,
-	.change_queue_depth	= qla2x00_change_queue_depth,
+	.change_queue_depth	= scsi_change_queue_depth,
 	.change_queue_type	= scsi_change_queue_type,
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
@@ -1406,7 +1405,7 @@ qla2xxx_slave_configure(struct scsi_device *sdev)
 	if (IS_T10_PI_CAPABLE(vha->hw))
 		blk_queue_update_dma_alignment(sdev->request_queue, 0x7);
 
-	scsi_adjust_queue_depth(sdev, req->max_q_depth);
+	scsi_change_queue_depth(sdev, req->max_q_depth);
 	return 0;
 }
 
@@ -1416,13 +1415,6 @@ qla2xxx_slave_destroy(struct scsi_device *sdev)
 	sdev->hostdata = NULL;
 }
 
-static int
-qla2x00_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
-{
-	scsi_adjust_queue_depth(sdev, qdepth);
-	return sdev->queue_depth;
-}
-
 /**
  * qla2x00_config_dma_addressing() - Configure OS DMA addressing method.
  * @ha: HA context
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 2bfde37..6d25879 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -201,7 +201,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.eh_timed_out		= qla4xxx_eh_cmd_timed_out,
 
 	.slave_alloc		= qla4xxx_slave_alloc,
-	.change_queue_depth	= iscsi_change_queue_depth,
+	.change_queue_depth	= scsi_change_queue_depth,
 
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
@@ -9059,7 +9059,7 @@ static int qla4xxx_slave_alloc(struct scsi_device *sdev)
 	if (ql4xmaxqdepth != 0 && ql4xmaxqdepth <= 0xffffU)
 		queue_depth = ql4xmaxqdepth;
 
-	scsi_adjust_queue_depth(sdev, queue_depth);
+	scsi_change_queue_depth(sdev, queue_depth);
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 106fa2f..5ea15fc 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -742,30 +742,18 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 }
 
 /**
- * scsi_adjust_queue_depth - Let low level drivers change a device's queue depth
+ * scsi_change_queue_depth - change a device's queue depth
  * @sdev: SCSI Device in question
- * @tags: Number of tags allowed if tagged queueing enabled,
- *        or number of commands the low level driver can
- *        queue up in non-tagged mode (as per cmd_per_lun).
+ * @depth: number of commands allowed to be queued to the driver
  *
- * Returns:	Nothing
- *
- * Lock Status:	None held on entry
- *
- * Notes:	Low level drivers may call this at any time and we will do
- * 		the right thing depending on whether or not the device is
- * 		currently active and whether or not it even has the
- * 		command blocks built yet.
+ * Sets the device queue depth and returns the new value.
  */
-void scsi_adjust_queue_depth(struct scsi_device *sdev, int tags)
+int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
 {
 	unsigned long flags;
 
-	/*
-	 * refuse to set tagged depth to an unworkable size
-	 */
-	if (tags <= 0)
-		return;
+	if (depth <= 0)
+		goto out;
 
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 
@@ -780,15 +768,17 @@ void scsi_adjust_queue_depth(struct scsi_device *sdev, int tags)
 	 */
 	if (!shost_use_blk_mq(sdev->host) && !sdev->host->bqt) {
 		if (blk_queue_tagged(sdev->request_queue) &&
-		    blk_queue_resize_tags(sdev->request_queue, tags) != 0)
-			goto out;
+		    blk_queue_resize_tags(sdev->request_queue, depth) != 0)
+			goto out_unlock;
 	}
 
-	sdev->queue_depth = tags;
- out:
+	sdev->queue_depth = depth;
+out_unlock:
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+out:
+	return sdev->queue_depth;
 }
-EXPORT_SYMBOL(scsi_adjust_queue_depth);
+EXPORT_SYMBOL(scsi_change_queue_depth);
 
 /**
  * scsi_track_queue_full - track QUEUE_FULL events to adjust queue depth
@@ -833,12 +823,11 @@ int scsi_track_queue_full(struct scsi_device *sdev, int depth)
 	if (sdev->last_queue_full_depth < 8) {
 		/* Drop back to untagged */
 		scsi_set_tag_type(sdev, 0);
-		scsi_adjust_queue_depth(sdev, sdev->host->cmd_per_lun);
+		scsi_change_queue_depth(sdev, sdev->host->cmd_per_lun);
 		return -1;
 	}
 
-	scsi_adjust_queue_depth(sdev, depth);
-	return depth;
+	return scsi_change_queue_depth(sdev, depth);
 }
 EXPORT_SYMBOL(scsi_track_queue_full);
 
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 84cf82e..ce71b6d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4469,7 +4469,7 @@ sdebug_queuecommand_lock_or_not(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 }
 
 static int
-sdebug_change_qdepth(struct scsi_device *sdev, int qdepth, int reason)
+sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
 {
 	int num_in_q = 0;
 	unsigned long iflags;
@@ -4489,7 +4489,7 @@ sdebug_change_qdepth(struct scsi_device *sdev, int qdepth, int reason)
 	/* allow to exceed max host queued_arr elements for testing */
 	if (qdepth > SCSI_DEBUG_CANQUEUE + 10)
 		qdepth = SCSI_DEBUG_CANQUEUE + 10;
-	scsi_adjust_queue_depth(sdev, qdepth);
+	scsi_change_queue_depth(sdev, qdepth);
 
 	if (SCSI_DEBUG_OPT_Q_NOISE & scsi_debug_opts) {
 		sdev_printk(KERN_INFO, sdev,
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2d0f515..1f63559 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -632,7 +632,7 @@ static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
 		    tmp_sdev->queue_depth == sdev->max_queue_depth)
 			continue;
 
-		scsi_adjust_queue_depth(tmp_sdev, tmp_sdev->queue_depth + 1);
+		scsi_change_queue_depth(tmp_sdev, tmp_sdev->queue_depth + 1);
 		sdev->last_queue_ramp_up = jiffies;
 	}
 }
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index d97597e..0af7133 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -292,7 +292,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 		blk_queue_init_tags(sdev->request_queue,
 				    sdev->host->cmd_per_lun, shost->bqt);
 	}
-	scsi_adjust_queue_depth(sdev, sdev->host->cmd_per_lun);
+	scsi_change_queue_depth(sdev, sdev->host->cmd_per_lun);
 
 	scsi_sysfs_device_initialize(sdev);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index bffd5ab..1cb64a8 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -880,8 +880,7 @@ sdev_store_queue_depth(struct device *dev, struct device_attribute *attr,
 	if (depth < 1 || depth > sht->can_queue)
 		return -EINVAL;
 
-	retval = sht->change_queue_depth(sdev, depth,
-					 SCSI_QDEPTH_DEFAULT);
+	retval = sht->change_queue_depth(sdev, depth);
 	if (retval < 0)
 		return retval;
 
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index ff8befb..e3ba251 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1429,7 +1429,7 @@ static void storvsc_device_destroy(struct scsi_device *sdevice)
 
 static int storvsc_device_configure(struct scsi_device *sdevice)
 {
-	scsi_adjust_queue_depth(sdevice, STORVSC_MAX_IO_REQUESTS);
+	scsi_change_queue_depth(sdevice, STORVSC_MAX_IO_REQUESTS);
 
 	blk_queue_max_segment_size(sdevice->request_queue, PAGE_SIZE);
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 3557b38..5d00e51 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -820,7 +820,7 @@ static int sym53c8xx_slave_configure(struct scsi_device *sdev)
 	if (reqtags > SYM_CONF_MAX_TAG)
 		reqtags = SYM_CONF_MAX_TAG;
 	depth_to_use = reqtags ? reqtags : 1;
-	scsi_adjust_queue_depth(sdev, depth_to_use);
+	scsi_change_queue_depth(sdev, depth_to_use);
 	lp->s.scdev_depth = depth_to_use;
 	sym_tune_dev_queuing(tp, sdev->lun, reqtags);
 
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 844c9a0..6c3c2ce 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2194,7 +2194,7 @@ static int dc390_slave_configure(struct scsi_device *sdev)
 
 	if (sdev->tagged_supported && (dcb->DevMode & TAG_QUEUEING_)) {
 		dcb->SyncMode |= EN_TAG_QUEUEING;
-		scsi_adjust_queue_depth(sdev, acb->TagMaxNum);
+		scsi_change_queue_depth(sdev, acb->TagMaxNum);
 	}
 
 	return 0;
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index aa0f403..14eb50b 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -696,25 +696,25 @@ static int u14_34f_slave_configure(struct scsi_device *dev) {
    if (TLDEV(dev->type) && dev->tagged_supported)
 
       if (tag_mode == TAG_SIMPLE) {
-         scsi_adjust_queue_depth(dev, tqd);
+         scsi_change_queue_depth(dev, tqd);
          tag_suffix = ", simple tags";
          }
       else if (tag_mode == TAG_ORDERED) {
-         scsi_adjust_queue_depth(dev, tqd);
+         scsi_change_queue_depth(dev, tqd);
          tag_suffix = ", ordered tags";
          }
       else {
-         scsi_adjust_queue_depth(dev, tqd);
+         scsi_change_queue_depth(dev, tqd);
          tag_suffix = ", no tags";
          }
 
    else if (TLDEV(dev->type) && linked_comm) {
-      scsi_adjust_queue_depth(dev, tqd);
+      scsi_change_queue_depth(dev, tqd);
       tag_suffix = ", untagged";
       }
 
    else {
-      scsi_adjust_queue_depth(dev, utqd);
+      scsi_change_queue_depth(dev, utqd);
       tag_suffix = "";
       }
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e96ab25..0c4f98e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2695,7 +2695,7 @@ static void ufshcd_set_queue_depth(struct scsi_device *sdev)
 
 	dev_dbg(hba->dev, "%s: activate tcq with queue depth %d\n",
 			__func__, lun_qdepth);
-	scsi_adjust_queue_depth(sdev, lun_qdepth);
+	scsi_change_queue_depth(sdev, lun_qdepth);
 }
 
 /*
@@ -2787,21 +2787,16 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
  * ufshcd_change_queue_depth - change queue depth
  * @sdev: pointer to SCSI device
  * @depth: required depth to set
- * @reason: reason for changing the depth
  *
- * Change queue depth according to the reason and make sure
- * the max. limits are not crossed.
+ * Change queue depth and make sure the max. limits are not crossed.
  */
-static int ufshcd_change_queue_depth(struct scsi_device *sdev,
-		int depth, int reason)
+static int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth)
 {
 	struct ufs_hba *hba = shost_priv(sdev->host);
 
 	if (depth > hba->nutrs)
 		depth = hba->nutrs;
-
-	scsi_adjust_queue_depth(sdev, depth);
-	return depth;
+	return scsi_change_queue_depth(sdev, depth);
 }
 
 /**
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index b9ef4b0..2b1db1d 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -668,17 +668,13 @@ static int virtscsi_device_reset(struct scsi_cmnd *sc)
  * virtscsi_change_queue_depth() - Change a virtscsi target's queue depth
  * @sdev:	Virtscsi target whose queue depth to change
  * @qdepth:	New queue depth
- * @reason:	Reason for the queue depth change.
  */
-static int virtscsi_change_queue_depth(struct scsi_device *sdev,
-				       int qdepth,
-				       int reason)
+static int virtscsi_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
 	struct Scsi_Host *shost = sdev->host;
 	int max_depth = shost->cmd_per_lun;
 
-	scsi_adjust_queue_depth(sdev, min(max_depth, qdepth));
-	return sdev->queue_depth;
+	return scsi_change_queue_depth(sdev, min(max_depth, qdepth));
 }
 
 static int virtscsi_abort(struct scsi_cmnd *sc)
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 03ad24b..ade1f1d 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -504,19 +504,11 @@ static void pvscsi_setup_all_rings(const struct pvscsi_adapter *adapter)
 	}
 }
 
-static int pvscsi_change_queue_depth(struct scsi_device *sdev,
-				     int qdepth,
-				     int reason)
+static int pvscsi_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		/*
-		 * We support only changing default.
-		 */
-		return -EOPNOTSUPP;
-
 	if (!sdev->tagged_supported)
 		qdepth = 1;
-	scsi_adjust_queue_depth(sdev, qdepth);
+	scsi_change_queue_depth(sdev, qdepth);
 
 	if (sdev->inquiry_len > 7)
 		sdev_printk(KERN_INFO, sdev,
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 3267423..f94d736 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1653,7 +1653,6 @@ static struct scsi_host_template driver_template = {
 	.can_queue		= WD7000_Q,
 	.this_id		= 7,
 	.sg_tablesize		= WD7000_SG,
-	.cmd_per_lun		= 1,
 	.unchecked_isa_dma	= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 };
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 670b75a..4d1b722 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -110,19 +110,6 @@ static struct device_driver tcm_loop_driverfs = {
  */
 struct device *tcm_loop_primary;
 
-/*
- * Copied from drivers/scsi/libfc/fc_fcp.c:fc_change_queue_depth() and
- * drivers/scsi/libiscsi.c:iscsi_change_queue_depth()
- */
-static int tcm_loop_change_queue_depth(
-	struct scsi_device *sdev,
-	int depth,
-	int reason)
-{
-	scsi_adjust_queue_depth(sdev, depth);
-	return sdev->queue_depth;
-}
-
 static void tcm_loop_submission_work(struct work_struct *work)
 {
 	struct tcm_loop_cmd *tl_cmd =
@@ -397,7 +384,7 @@ static struct scsi_host_template tcm_loop_driver_template = {
 	.proc_name		= "tcm_loopback",
 	.name			= "TCM_Loopback",
 	.queuecommand		= tcm_loop_queuecommand,
-	.change_queue_depth	= tcm_loop_change_queue_depth,
+	.change_queue_depth	= scsi_change_queue_depth,
 	.change_queue_type	= scsi_change_queue_type,
 	.eh_abort_handler = tcm_loop_abort_task,
 	.eh_device_reset_handler = tcm_loop_device_reset,
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 33f211b..4047edf 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -799,7 +799,7 @@ static int uas_slave_configure(struct scsi_device *sdev)
 	if (devinfo->flags & US_FL_NO_REPORT_OPCODES)
 		sdev->no_report_opcodes = 1;
 
-	scsi_adjust_queue_depth(sdev, devinfo->qdepth - 2);
+	scsi_change_queue_depth(sdev, devinfo->qdepth - 2);
 	return 0;
 }
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index bd5fefe..bfbc817 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1191,9 +1191,9 @@ extern void ata_scsi_unlock_native_capacity(struct scsi_device *sdev);
 extern int ata_scsi_slave_config(struct scsi_device *sdev);
 extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
-				       int queue_depth, int reason);
+				       int queue_depth);
 extern int __ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
-				    int queue_depth, int reason);
+				    int queue_depth);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);
 extern int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
 extern void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 2e0cf56..93d14da 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -1105,7 +1105,6 @@ int fc_eh_abort(struct scsi_cmnd *);
 int fc_eh_device_reset(struct scsi_cmnd *);
 int fc_eh_host_reset(struct scsi_cmnd *);
 int fc_slave_alloc(struct scsi_device *);
-int fc_change_queue_depth(struct scsi_device *, int qdepth, int reason);
 
 /*
  * ELS/CT interface
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 728c9ad..4d1c46a 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -378,8 +378,6 @@ struct iscsi_host {
 /*
  * scsi host template
  */
-extern int iscsi_change_queue_depth(struct scsi_device *sdev, int depth,
-				    int reason);
 extern int iscsi_eh_abort(struct scsi_cmnd *sc);
 extern int iscsi_eh_recover_target(struct scsi_cmnd *sc);
 extern int iscsi_eh_session_reset(struct scsi_cmnd *sc);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index ef7872c..1f8b33e 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -704,8 +704,7 @@ int sas_queue_up(struct sas_task *task);
 extern int sas_queuecommand(struct Scsi_Host * ,struct scsi_cmnd *);
 extern int sas_target_alloc(struct scsi_target *);
 extern int sas_slave_configure(struct scsi_device *);
-extern int sas_change_queue_depth(struct scsi_device *, int new_depth,
-				  int reason);
+extern int sas_change_queue_depth(struct scsi_device *, int new_depth);
 extern int sas_change_queue_type(struct scsi_device *, int qt);
 extern int sas_bios_param(struct scsi_device *,
 			  struct block_device *,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 0aeaa00..6364e23 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -380,7 +380,7 @@ extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
 #define __shost_for_each_device(sdev, shost) \
 	list_for_each_entry((sdev), &((shost)->__devices), siblings)
 
-extern void scsi_adjust_queue_depth(struct scsi_device *, int);
+extern int scsi_change_queue_depth(struct scsi_device *, int);
 extern int scsi_track_queue_full(struct scsi_device *, int);
 
 extern int scsi_set_medium_removal(struct scsi_device *, char);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index a0b13a5..c8a462e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -46,10 +46,6 @@ struct blk_queue_tags;
 #define DISABLE_CLUSTERING 0
 #define ENABLE_CLUSTERING 1
 
-enum {
-	SCSI_QDEPTH_DEFAULT,	/* default requested change, e.g. from sysfs */
-};
-
 struct scsi_host_template {
 	struct module *module;
 	const char *name;
@@ -193,7 +189,7 @@ struct scsi_host_template {
 	 * Things currently recommended to be handled at this time include:
 	 *
 	 * 1.  Setting the device queue depth.  Proper setting of this is
-	 *     described in the comments for scsi_adjust_queue_depth.
+	 *     described in the comments for scsi_change_queue_depth.
 	 * 2.  Determining if the device supports the various synchronous
 	 *     negotiation protocols.  The device struct will already have
 	 *     responded to INQUIRY and the results of the standard items
@@ -279,7 +275,7 @@ struct scsi_host_template {
 	 *
 	 * Status: OPTIONAL
 	 */
-	int (* change_queue_depth)(struct scsi_device *, int, int);
+	int (* change_queue_depth)(struct scsi_device *, int);
 
 	/*
 	 * Fill in this function to allow the changing of tag types
-- 
1.9.1

