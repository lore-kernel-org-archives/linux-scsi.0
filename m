From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 03/10] drivers: convert drivers setting the change_queue_depth
	callback
Date: Thu, 03 Sep 2009 15:22:42 -0700
Message-ID: <20090903222242.24946.20040.stgit@vi1.jf.intel.com>
References: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5577 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185AbZICWWk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Sep 2009 18:22:40 -0400
In-Reply-To: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, Robert Love <robert.w.love@intel.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Mike Christie <michaelc@cs.wisc.edu>

This is a simple port of the drivers setting a change_queue_depth
callback but were not tracking queue fulls. In the patch I just have
these LLDs adjust the queue depth if the user was requesting it.

Patch is only compile tested.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/ata/libata-scsi.c             |    7 ++++++-
 drivers/ata/sata_nv.c                 |    2 +-
 drivers/message/fusion/mptscsih.c     |    9 +++++++--
 drivers/message/fusion/mptscsih.h     |    3 ++-
 drivers/s390/scsi/zfcp_scsi.c         |    5 ++++-
 drivers/scsi/3w-9xxx.c                |    5 ++++-
 drivers/scsi/3w-xxxx.c                |    5 ++++-
 drivers/scsi/53c700.c                 |    5 ++++-
 drivers/scsi/aacraid/linit.c          |    6 +++++-
 drivers/scsi/arcmsr/arcmsr_hba.c      |    5 ++++-
 drivers/scsi/hptiop.c                 |    5 ++++-
 drivers/scsi/ibmvscsi/ibmvfc.c        |    7 ++++++-
 drivers/scsi/ibmvscsi/ibmvscsi.c      |    7 ++++++-
 drivers/scsi/ipr.c                    |    7 ++++++-
 drivers/scsi/libfc/fc_fcp.c           |    4 +++-
 drivers/scsi/libiscsi.c               |    4 +++-
 drivers/scsi/libsas/sas_scsi_host.c   |    6 +++++-
 drivers/scsi/megaraid/megaraid_mbox.c |    7 ++++++-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c  |   10 +++++++---
 drivers/scsi/qla2xxx/qla_os.c         |    6 ++++--
 include/linux/libata.h                |    2 +-
 include/scsi/libfc.h                  |    2 +-
 include/scsi/libiscsi.h               |    3 ++-
 include/scsi/libsas.h                 |    3 ++-
 24 files changed, 97 insertions(+), 28 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d0dfeef..050fae6 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1212,6 +1212,7 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
  *	ata_scsi_change_queue_depth - SCSI callback for queue depth config
  *	@sdev: SCSI device to configure queue depth for
  *	@queue_depth: new queue depth
+ *	@reason: calling context
  *
  *	This is libata standard hostt->change_queue_depth callback.
  *	SCSI will call into this callback when user tries to set queue
@@ -1223,12 +1224,16 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
  *	RETURNS:
  *	Newly configured queue depth.
  */
-int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
+int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth,
+				int reason)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev;
 	unsigned long flags;
 
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -EOPNOTSUPP;
+
 	if (queue_depth < 1 || queue_depth == sdev->queue_depth)
 		return sdev->queue_depth;
 
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 86a4058..9bb4afb 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1963,7 +1963,7 @@ static int nv_swncq_slave_config(struct scsi_device *sdev)
 	ata_id_c_string(dev->id, model_num, ATA_ID_PROD, sizeof(model_num));
 
 	if (strncmp(model_num, "Maxtor", 6) == 0) {
-		ata_scsi_change_queue_depth(sdev, 1);
+		ata_scsi_change_queue_depth(sdev, 1, SCSI_QDEPTH_DEFAULT);
 		ata_dev_printk(dev, KERN_NOTICE,
 			"Disabling SWNCQ mode (depth %x)\n", sdev->queue_depth);
 	}
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 0e402eb..5af9edb 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2265,11 +2265,12 @@ mptscsih_slave_destroy(struct scsi_device *sdev)
  *	mptscsih_change_queue_depth - This function will set a devices queue depth
  *	@sdev: per scsi_device pointer
  *	@qdepth: requested queue depth
+ *	@reason: calling context
  *
  *	Adding support for new 'change_queue_depth' api.
 */
 int
-mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
+mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
 	MPT_SCSI_HOST		*hd = shost_priv(sdev->host);
 	VirtTarget 		*vtarget;
@@ -2281,6 +2282,9 @@ mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 	starget = scsi_target(sdev);
 	vtarget = starget->hostdata;
 
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -EOPNOTSUPP;
+
 	if (ioc->bus_type == SPI) {
 		if (!(vtarget->tflags & MPT_TARGET_FLAGS_Q_YES))
 			max_depth = 1;
@@ -2347,7 +2351,8 @@ mptscsih_slave_configure(struct scsi_device *sdev)
 		    ioc->name, vtarget->negoFlags, vtarget->maxOffset,
 		    vtarget->minSyncFactor));
 
-	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH);
+	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH,
+				    SCSI_QDEPTH_DEFAULT);
 	dsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		"tagged %d, simple %d, ordered %d\n",
 		ioc->name,sdev->tagged_supported, sdev->simple_tags,
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index e0b33e0..45a5ff3 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -128,7 +128,8 @@ extern int mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_F
 extern int mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 extern int mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
-extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
+extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth,
+				       int reason);
 extern u8 mptscsih_raid_id_to_num(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern struct device_attribute *mptscsih_host_attrs[];
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 6925a17..bdff1bf 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -28,8 +28,11 @@ char *zfcp_get_fcp_sns_info_ptr(struct fcp_rsp_iu *fcp_rsp_iu)
 	return fcp_sns_info_ptr;
 }
 
-static int zfcp_scsi_change_queue_depth(struct scsi_device *sdev, int depth)
+static int zfcp_scsi_change_queue_depth(struct scsi_device *sdev, int depth,
+					int reason)
 {
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -EOPNOTSUPP;
 	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
 	return sdev->queue_depth;
 }
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 36c21b1..f7d52d8 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -186,8 +186,11 @@ static ssize_t twa_show_stats(struct device *dev,
 } /* End twa_show_stats() */
 
 /* This function will set a devices queue depth */
-static int twa_change_queue_depth(struct scsi_device *sdev, int queue_depth)
+static int twa_change_queue_depth(struct scsi_device *sdev, int queue_depth,
+				  int reason)
 {
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -EOPNOTSUPP;
 	if (queue_depth > TW_Q_LENGTH-2)
 		queue_depth = TW_Q_LENGTH-2;
 	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index faa0fcf..927f5ce 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -521,8 +521,11 @@ static ssize_t tw_show_stats(struct device *dev, struct device_attribute *attr,
 } /* End tw_show_stats() */
 
 /* This function will set a devices queue depth */
-static int tw_change_queue_depth(struct scsi_device *sdev, int queue_depth)
+static int tw_change_queue_depth(struct scsi_device *sdev, int queue_depth,
+				 int reason)
 {
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -EOPNOTSUPP;
 	if (queue_depth > TW_Q_LENGTH-2)
 		queue_depth = TW_Q_LENGTH-2;
 	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index f5a9add..a5a493d 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -2082,8 +2082,11 @@ NCR_700_slave_destroy(struct scsi_device *SDp)
 }
 
 static int
-NCR_700_change_queue_depth(struct scsi_device *SDp, int depth)
+NCR_700_change_queue_depth(struct scsi_device *SDp, int depth, int reason)
 {
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -EOPNOTSUPP;
+
 	if (depth > NCR_700_MAX_TAGS)
 		depth = NCR_700_MAX_TAGS;
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 9b97c3e..e9373a2 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -472,8 +472,12 @@ static int aac_slave_configure(struct scsi_device *sdev)
  *	total capacity and the queue depth supported by the target device.
  */
 
-static int aac_change_queue_depth(struct scsi_device *sdev, int depth)
+static int aac_change_queue_depth(struct scsi_device *sdev, int depth,
+				  int reason)
 {
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -EOPNOTSUPP;
+
 	if (sdev->tagged_supported && (sdev->type == TYPE_DISK) &&
 	    (sdev_channel(sdev) == CONTAINER_CHANNEL)) {
 		struct scsi_device * dev;
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 80aac01..47d5d19 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -98,8 +98,11 @@ static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb);
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
 static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev,
-								int queue_depth)
+					  int queue_depth, int reason)
 {
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -EOPNOTSUPP;
+
 	if (queue_depth > ARCMSR_MAX_CMD_PERLUN)
 		queue_depth = ARCMSR_MAX_CMD_PERLUN;
 	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index c596ab5..19620e9 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -847,10 +847,13 @@ static int hptiop_reset(struct scsi_cmnd *scp)
 }
 
 static int hptiop_adjust_disk_queue_depth(struct scsi_device *sdev,
-						int queue_depth)
+					  int queue_depth, int reason)
 {
 	struct hptiop_hba *hba = (struct hptiop_hba *)sdev->host->hostdata;
 
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -EOPNOTSUPP;
+
 	if (queue_depth > hba->max_requests)
 		queue_depth = hba->max_requests;
 	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index bb2c696..07e2e35 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2478,12 +2478,17 @@ static int ibmvfc_slave_configure(struct scsi_device *sdev)
  * ibmvfc_change_queue_depth - Change the device's queue depth
  * @sdev:	scsi device struct
  * @qdepth:	depth to set
+ * @reason:	calling context
  *
  * Return value:
  * 	actual depth set
  **/
-static int ibmvfc_change_queue_depth(struct scsi_device *sdev, int qdepth)
+static int ibmvfc_change_queue_depth(struct scsi_device *sdev, int qdepth,
+				     int reason)
 {
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -EOPNOTSUPP;
+
 	if (qdepth > IBMVFC_MAX_CMDS_PER_LUN)
 		qdepth = IBMVFC_MAX_CMDS_PER_LUN;
 
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 9928704..15fa8c7 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1638,12 +1638,17 @@ static int ibmvscsi_slave_configure(struct scsi_device *sdev)
  * ibmvscsi_change_queue_depth - Change the device's queue depth
  * @sdev:	scsi device struct
  * @qdepth:	depth to set
+ * @reason:	calling context
  *
  * Return value:
  * 	actual depth set
  **/
-static int ibmvscsi_change_queue_depth(struct scsi_device *sdev, int qdepth)
+static int ibmvscsi_change_queue_depth(struct scsi_device *sdev, int qdepth,
+				       int reason)
 {
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -EOPNOTSUPP;
+
 	if (qdepth > IBMVSCSI_MAX_CMDS_PER_LUN)
 		qdepth = IBMVSCSI_MAX_CMDS_PER_LUN;
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 5f04550..d40d5c7 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3367,16 +3367,21 @@ static int ipr_free_dump(struct ipr_ioa_cfg *ioa_cfg) { return 0; };
  * ipr_change_queue_depth - Change the device's queue depth
  * @sdev:	scsi device struct
  * @qdepth:	depth to set
+ * @reason:	calling context
  *
  * Return value:
  * 	actual depth set
  **/
-static int ipr_change_queue_depth(struct scsi_device *sdev, int qdepth)
+static int ipr_change_queue_depth(struct scsi_device *sdev, int qdepth,
+				  int reason)
 {
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)sdev->host->hostdata;
 	struct ipr_resource_entry *res;
 	unsigned long lock_flags = 0;
 
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -EOPNOTSUPP;
+
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *)sdev->hostdata;
 
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 7d5ffcb..20b88cd 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2062,8 +2062,10 @@ int fc_slave_alloc(struct scsi_device *sdev)
 }
 EXPORT_SYMBOL(fc_slave_alloc);
 
-int fc_change_queue_depth(struct scsi_device *sdev, int qdepth)
+int fc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -EOPNOTSUPP;
 	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
 	return sdev->queue_depth;
 }
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index a751f62..dc4f86a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1539,8 +1539,10 @@ fault:
 }
 EXPORT_SYMBOL_GPL(iscsi_queuecommand);
 
-int iscsi_change_queue_depth(struct scsi_device *sdev, int depth)
+int iscsi_change_queue_depth(struct scsi_device *sdev, int depth, int reason)
 {
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -EOPNOTSUPP;
 	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
 	return sdev->queue_depth;
 }
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 1c558d3..14b1319 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -820,10 +820,14 @@ void sas_slave_destroy(struct scsi_device *scsi_dev)
 		ata_port_disable(dev->sata_dev.ap);
 }
 
-int sas_change_queue_depth(struct scsi_device *scsi_dev, int new_depth)
+int sas_change_queue_depth(struct scsi_device *scsi_dev, int new_depth,
+			   int reason)
 {
 	int res = min(new_depth, SAS_MAX_QD);
 
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -EOPNOTSUPP;
+
 	if (scsi_dev->tagged_supported)
 		scsi_adjust_queue_depth(scsi_dev, scsi_get_tag_type(scsi_dev),
 					res);
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 234f0b7..fd181c2 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -335,12 +335,17 @@ static struct device_attribute *megaraid_sdev_attrs[] = {
  * megaraid_change_queue_depth - Change the device's queue depth
  * @sdev:	scsi device struct
  * @qdepth:	depth to set
+ * @reason:	calling context
  *
  * Return value:
  * 	actual depth set
  */
-static int megaraid_change_queue_depth(struct scsi_device *sdev, int qdepth)
+static int megaraid_change_queue_depth(struct scsi_device *sdev, int qdepth,
+				       int reason)
 {
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -EOPNOTSUPP;
+
 	if (qdepth > MBOX_MAX_SCSI_CMDS)
 		qdepth = MBOX_MAX_SCSI_CMDS;
 	scsi_adjust_queue_depth(sdev, 0, qdepth);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 2e9a444..6e6ee0d 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1085,16 +1085,20 @@ _scsih_build_scatter_gather(struct MPT2SAS_ADAPTER *ioc,
  * _scsih_change_queue_depth - setting device queue depth
  * @sdev: scsi device struct
  * @qdepth: requested queue depth
+ * @reason: calling context
  *
  * Returns queue depth.
  */
 static int
-_scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
+_scsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
 	struct Scsi_Host *shost = sdev->host;
 	int max_depth;
 	int tag_type;
 
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -EOPNOTSUPP;
+
 	max_depth = shost->can_queue;
 	if (!sdev->tagged_supported)
 		max_depth = 1;
@@ -1524,7 +1528,7 @@ _scsih_slave_configure(struct scsi_device *sdev)
 		    r_level, raid_device->handle,
 		    (unsigned long long)raid_device->wwid,
 		    raid_device->num_pds, ds);
-		_scsih_change_queue_depth(sdev, qdepth);
+		_scsih_change_queue_depth(sdev, qdepth, SCSI_QDEPTH_DEFAULT);
 		return 0;
 	}
 
@@ -1570,7 +1574,7 @@ _scsih_slave_configure(struct scsi_device *sdev)
 			_scsih_display_sata_capabilities(ioc, sas_device, sdev);
 	}
 
-	_scsih_change_queue_depth(sdev, qdepth);
+	_scsih_change_queue_depth(sdev, qdepth, SCSI_QDEPTH_DEFAULT);
 
 	if (ssp_target)
 		sas_read_port_mode_page(sdev);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d7b2713..c05c460 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -137,7 +137,7 @@ static int qla2xxx_eh_target_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_bus_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_host_reset(struct scsi_cmnd *);
 
-static int qla2x00_change_queue_depth(struct scsi_device *, int);
+static int qla2x00_change_queue_depth(struct scsi_device *, int, int);
 static int qla2x00_change_queue_type(struct scsi_device *, int);
 
 struct scsi_host_template qla2xxx_driver_template = {
@@ -1223,8 +1223,10 @@ qla2xxx_slave_destroy(struct scsi_device *sdev)
 }
 
 static int
-qla2x00_change_queue_depth(struct scsi_device *sdev, int qdepth)
+qla2x00_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -EOPNOTSUPP;
 	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
 	return sdev->queue_depth;
 }
diff --git a/include/linux/libata.h b/include/linux/libata.h
index e5b6e33..a4744c8 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1010,7 +1010,7 @@ extern int ata_std_bios_param(struct scsi_device *sdev,
 extern int ata_scsi_slave_config(struct scsi_device *sdev);
 extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
-				       int queue_depth);
+				       int queue_depth, int reason);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);
 extern int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index c2b928c..861a3b5 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -904,7 +904,7 @@ int fc_slave_alloc(struct scsi_device *sdev);
 /*
  * Adjust the queue depth.
  */
-int fc_change_queue_depth(struct scsi_device *sdev, int qdepth);
+int fc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason);
 
 /*
  * Change the tag type.
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 61afeb5..b0188b6 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -332,7 +332,8 @@ struct iscsi_host {
 /*
  * scsi host template
  */
-extern int iscsi_change_queue_depth(struct scsi_device *sdev, int depth);
+extern int iscsi_change_queue_depth(struct scsi_device *sdev, int depth,
+				    int reason);
 extern int iscsi_eh_abort(struct scsi_cmnd *sc);
 extern int iscsi_eh_target_reset(struct scsi_cmnd *sc);
 extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index e78d3b6..9eaa3f0 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -634,7 +634,8 @@ extern int sas_target_alloc(struct scsi_target *);
 extern int sas_slave_alloc(struct scsi_device *);
 extern int sas_slave_configure(struct scsi_device *);
 extern void sas_slave_destroy(struct scsi_device *);
-extern int sas_change_queue_depth(struct scsi_device *, int new_depth);
+extern int sas_change_queue_depth(struct scsi_device *, int new_depth,
+				  int reason);
 extern int sas_change_queue_type(struct scsi_device *, int qt);
 extern int sas_bios_param(struct scsi_device *,
 			  struct block_device *,

