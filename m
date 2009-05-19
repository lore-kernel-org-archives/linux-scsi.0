From: michaelc@cs.wisc.edu
Subject: [RFC PATCH 3/4] drivers: convert drivers setting the change_queue_depth callback
Date: Tue, 19 May 2009 00:52:46 -0500
Message-ID: <1242712370448-git-send-email-michaelc@cs.wisc.edu>
References: <12427123671020-git-send-email-michaelc@cs.wisc.edu>
 <12427123683166-git-send-email-michaelc@cs.wisc.edu>
 <1242712369913-git-send-email-michaelc@cs.wisc.edu>
 <12427123692457-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57049 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbZESFww (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2009 01:52:52 -0400
In-Reply-To: <12427123692457-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This is a simple port of the drivers setting a change_queue_depth
callback but were not tracking queue fulls. In the patch I just have
these LLDs adjust the queue depth if the user was requesting it.

Patch is only compile tested.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/ata/libata-scsi.c             |    6 +++++-
 drivers/ata/sata_nv.c                 |    2 +-
 drivers/message/fusion/mptscsih.c     |    8 ++++++--
 drivers/message/fusion/mptscsih.h     |    3 ++-
 drivers/scsi/3w-9xxx.c                |    5 ++++-
 drivers/scsi/3w-xxxx.c                |    5 ++++-
 drivers/scsi/53c700.c                 |    5 ++++-
 drivers/scsi/aacraid/linit.c          |    6 +++++-
 drivers/scsi/arcmsr/arcmsr_hba.c      |    5 ++++-
 drivers/scsi/hptiop.c                 |    5 ++++-
 drivers/scsi/ibmvscsi/ibmvfc.c        |    7 ++++++-
 drivers/scsi/ibmvscsi/ibmvscsi.c      |    7 ++++++-
 drivers/scsi/ipr.c                    |    7 ++++++-
 drivers/scsi/libsas/sas_scsi_host.c   |    6 +++++-
 drivers/scsi/megaraid/megaraid_mbox.c |    7 ++++++-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c  |   10 +++++++---
 include/linux/libata.h                |    2 +-
 include/scsi/libsas.h                 |    3 ++-
 18 files changed, 78 insertions(+), 21 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 68d9132..45eecb9 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1223,12 +1223,16 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
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
 
+	if (reason != SCSI_QDEPTH_SYSFS_REQ)
+		return -EOPNOTSUPP;
+
 	if (queue_depth < 1 || queue_depth == sdev->queue_depth)
 		return sdev->queue_depth;
 
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 6cda12b..a1c09d9 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1931,7 +1931,7 @@ static int nv_swncq_slave_config(struct scsi_device *sdev)
 	ata_id_c_string(dev->id, model_num, ATA_ID_PROD, sizeof(model_num));
 
 	if (strncmp(model_num, "Maxtor", 6) == 0) {
-		ata_scsi_change_queue_depth(sdev, 1);
+		ata_scsi_change_queue_depth(sdev, 1, SCSI_QDEPTH_SYSFS_REQ);
 		ata_dev_printk(dev, KERN_NOTICE,
 			"Disabling SWNCQ mode (depth %x)\n", sdev->queue_depth);
 	}
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index e62c6bc..f201846 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2393,7 +2393,7 @@ mptscsih_slave_destroy(struct scsi_device *sdev)
  *	Adding support for new 'change_queue_depth' api.
 */
 int
-mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
+mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
 	MPT_SCSI_HOST		*hd = shost_priv(sdev->host);
 	VirtTarget 		*vtarget;
@@ -2405,6 +2405,9 @@ mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 	starget = scsi_target(sdev);
 	vtarget = starget->hostdata;
 
+	if (reason != SCSI_QDEPTH_SYSFS_REQ)
+		return -EOPNOTSUPP;
+
 	if (ioc->bus_type == SPI) {
 		if (!(vtarget->tflags & MPT_TARGET_FLAGS_Q_YES))
 			max_depth = 1;
@@ -2457,7 +2460,8 @@ mptscsih_slave_configure(struct scsi_device *sdev)
 		    sdev->ppr, sdev->inquiry_len));
 
 	vdevice->configured_lun = 1;
-	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH);
+	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH,
+				    SCSI_QDEPTH_SYSFS_REQ);
 
 	dsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		"Queue depth=%d, tflags=%x\n",
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 319aa30..6404c10 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -124,7 +124,8 @@ extern int mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_F
 extern int mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 extern int mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
-extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
+extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth,
+				       int reason);
 extern void mptscsih_timer_expired(unsigned long data);
 extern int mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout);
 extern u8 mptscsih_raid_id_to_num(MPT_ADAPTER *ioc, u8 channel, u8 id);
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 36c21b1..c3d49b3 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -186,8 +186,11 @@ static ssize_t twa_show_stats(struct device *dev,
 } /* End twa_show_stats() */
 
 /* This function will set a devices queue depth */
-static int twa_change_queue_depth(struct scsi_device *sdev, int queue_depth)
+static int twa_change_queue_depth(struct scsi_device *sdev, int queue_depth,
+				  int reason)
 {
+	if (reason != SCSI_QDEPTH_SYSFS_REQ)
+		return -EOPNOTSUPP;
 	if (queue_depth > TW_Q_LENGTH-2)
 		queue_depth = TW_Q_LENGTH-2;
 	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index faa0fcf..5bc1251 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -521,8 +521,11 @@ static ssize_t tw_show_stats(struct device *dev, struct device_attribute *attr,
 } /* End tw_show_stats() */
 
 /* This function will set a devices queue depth */
-static int tw_change_queue_depth(struct scsi_device *sdev, int queue_depth)
+static int tw_change_queue_depth(struct scsi_device *sdev, int queue_depth,
+				 int reason)
 {
+	if (reason != SCSI_QDEPTH_SYSFS_REQ)
+		return -EOPNOTSUPP;
 	if (queue_depth > TW_Q_LENGTH-2)
 		queue_depth = TW_Q_LENGTH-2;
 	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index f5a9add..8fea91a 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -2082,8 +2082,11 @@ NCR_700_slave_destroy(struct scsi_device *SDp)
 }
 
 static int
-NCR_700_change_queue_depth(struct scsi_device *SDp, int depth)
+NCR_700_change_queue_depth(struct scsi_device *SDp, int depth, int reason)
 {
+	if (reason != SCSI_QDEPTH_SYSFS_REQ)
+		return -EOPNOTSUPP;
+
 	if (depth > NCR_700_MAX_TAGS)
 		depth = NCR_700_MAX_TAGS;
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 9b97c3e..0b4605a 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -472,8 +472,12 @@ static int aac_slave_configure(struct scsi_device *sdev)
  *	total capacity and the queue depth supported by the target device.
  */
 
-static int aac_change_queue_depth(struct scsi_device *sdev, int depth)
+static int aac_change_queue_depth(struct scsi_device *sdev, int depth,
+				  int reason)
 {
+	if (reason != SCSI_QDEPTH_SYSFS_REQ)
+		return -EOPNOTSUPP;
+
 	if (sdev->tagged_supported && (sdev->type == TYPE_DISK) &&
 	    (sdev_channel(sdev) == CONTAINER_CHANNEL)) {
 		struct scsi_device * dev;
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 80aac01..a3d0ded 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -98,8 +98,11 @@ static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb);
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
 static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev,
-								int queue_depth)
+					  int queue_depth, int reason)
 {
+	if (reason != SCSI_QDEPTH_SYSFS_REQ)
+		return -EOPNOTSUPP;
+
 	if (queue_depth > ARCMSR_MAX_CMD_PERLUN)
 		queue_depth = ARCMSR_MAX_CMD_PERLUN;
 	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index c596ab5..a2f3c41 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -847,10 +847,13 @@ static int hptiop_reset(struct scsi_cmnd *scp)
 }
 
 static int hptiop_adjust_disk_queue_depth(struct scsi_device *sdev,
-						int queue_depth)
+					  int queue_depth, int reason)
 {
 	struct hptiop_hba *hba = (struct hptiop_hba *)sdev->host->hostdata;
 
+	if (reason != SCSI_QDEPTH_SYSFS_REQ)
+		return -EOPNOTSUPP;
+
 	if (queue_depth > hba->max_requests)
 		queue_depth = hba->max_requests;
 	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index ea4abee..4e39afa 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2388,12 +2388,17 @@ static int ibmvfc_slave_configure(struct scsi_device *sdev)
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
+	if (reason != SCSI_QDEPTH_SYSFS_REQ)
+		return -EOPNOTSUPP;
+
 	if (qdepth > IBMVFC_MAX_CMDS_PER_LUN)
 		qdepth = IBMVFC_MAX_CMDS_PER_LUN;
 
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index c9aa761..6ac1698 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1455,12 +1455,17 @@ static int ibmvscsi_slave_configure(struct scsi_device *sdev)
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
+	if (reason != SCSI_QDEPTH_SYSFS_REQ)
+		return -EOPNOTSUPP;
+
 	if (qdepth > IBMVSCSI_MAX_CMDS_PER_LUN)
 		qdepth = IBMVSCSI_MAX_CMDS_PER_LUN;
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index dd689de..aa04fb5 100644
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
 
+	if (reason != SCSI_QDEPTH_SYSFS_REQ)
+		return -EOPNOTSUPP;
+
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *)sdev->hostdata;
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 1c558d3..84230ae 100644
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
 
+	if (reason != SCSI_QDEPTH_SYSFS_REQ)
+		return -EOPNOTSUPP;
+
 	if (scsi_dev->tagged_supported)
 		scsi_adjust_queue_depth(scsi_dev, scsi_get_tag_type(scsi_dev),
 					res);
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 234f0b7..dc17d75 100644
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
+	if (reason != SCSI_QDEPTH_SYSFS_REQ)
+		return -EOPNOTSUPP;
+
 	if (qdepth > MBOX_MAX_SCSI_CMDS)
 		qdepth = MBOX_MAX_SCSI_CMDS;
 	scsi_adjust_queue_depth(sdev, 0, qdepth);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index e3a7967..d5e1a3d 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1050,16 +1050,20 @@ _scsih_build_scatter_gather(struct MPT2SAS_ADAPTER *ioc,
  * scsih_change_queue_depth - setting device queue depth
  * @sdev: scsi device struct
  * @qdepth: requested queue depth
+ * @reason: calling context
  *
  * Returns queue depth.
  */
 static int
-scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
+scsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 {
 	struct Scsi_Host *shost = sdev->host;
 	int max_depth;
 	int tag_type;
 
+	if (reason != SCSI_QDEPTH_SYSFS_REQ)
+		return -EOPNOTSUPP;
+
 	max_depth = shost->can_queue;
 	if (!sdev->tagged_supported)
 		max_depth = 1;
@@ -1489,7 +1493,7 @@ scsih_slave_configure(struct scsi_device *sdev)
 		    r_level, raid_device->handle,
 		    (unsigned long long)raid_device->wwid,
 		    raid_device->num_pds, ds);
-		scsih_change_queue_depth(sdev, qdepth);
+		scsih_change_queue_depth(sdev, qdepth, SCSI_QDEPTH_SYSFS_REQ);
 		return 0;
 	}
 
@@ -1535,7 +1539,7 @@ scsih_slave_configure(struct scsi_device *sdev)
 			scsih_display_sata_capabilities(ioc, sas_device, sdev);
 	}
 
-	scsih_change_queue_depth(sdev, qdepth);
+	scsih_change_queue_depth(sdev, qdepth, SCSI_QDEPTH_SYSFS_REQ);
 
 	if (ssp_target)
 		sas_read_port_mode_page(sdev);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 3d501db..026cf2e 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1008,7 +1008,7 @@ extern int ata_std_bios_param(struct scsi_device *sdev,
 extern int ata_scsi_slave_config(struct scsi_device *sdev);
 extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
-				       int queue_depth);
+				       int queue_depth, int reason);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);
 extern int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
 
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
-- 
1.6.0.6

