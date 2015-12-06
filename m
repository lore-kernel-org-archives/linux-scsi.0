From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.4-rc3
Date: Sat, 05 Dec 2015 21:30:16 -0800
Message-ID: <1449379816.2191.14.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34538 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848AbbLFFaS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2015 00:30:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is quite a bumper crop of fixes:  Three from Arnd correcting
various build issues in some configurations, a lock recursion in
qla2xxx.  Two potentially exploitable issues in hpsa and mvsas, a
potential null deref in st, A revert of a bdi registration fix that
turned out to cause even more problems, a set of fixes to allow people
who only defined MPT2SAS to still work after the mpt2/mpt3sas merger and
a couple of fixes for issues turned up by the hyper-v storvsc driver.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:


Arnd Bergmann (3):
      scsi: hpsa: select CONFIG_SCSI_SAS_ATTR
      scsi: advansys needs ISA dma api for ISA support
      advansys: fix big-endian builds

Bart Van Assche (3):
      Revert "scsi: Fix a bdi reregistration race"
      Fix a memory leak in scsi_host_dev_release()
      qla2xxx: Fix rwlock recursion

Dan Carpenter (2):
      hpsa: logical vs bitwise AND typo
      mvsas: don't allow negative timeouts

Douglas Gilbert (1):
      scsi_debug: fix prevent_allow+verify regressions

James Bottomley (1):
      mpt3sas: fix Kconfig dependency problem for mpt2sas back compatibility

Martin K. Petersen (4):
      mpt3sas: Add dummy Kconfig option for backwards compatibility
      block/sd: Fix device-imposed transfer length limits
      MAINTAINERS: Add myself as co-maintainer of the SCSI subsystem.
      sd: Make discard granularity match logical block size when LBPRZ=1

Maurizio Lombardi (1):
      st: fix potential null pointer dereference.

Sreekanth Reddy (1):
      mpt3sas: Fix use sas_is_tlr_enabled API before enabling MPI2_SCSIIO_CONTROL_TLR_ON flag

Vitaly Kuznetsov (2):
      scsi_sysfs: protect against double execution of __scsi_remove_device()
      scsi: report 'INQUIRY result too short' once per host

And the diffstat:

 MAINTAINERS                          |  4 ++-
 block/blk-settings.c                 | 36 +++++++++----------
 block/blk-sysfs.c                    |  3 ++
 drivers/scsi/Kconfig                 |  2 ++
 drivers/scsi/advansys.c              |  2 +-
 drivers/scsi/hosts.c                 | 11 ++++++
 drivers/scsi/hpsa.c                  |  2 +-
 drivers/scsi/mpt3sas/Kconfig         |  9 +++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  3 +-
 drivers/scsi/mvsas/mv_init.c         |  4 +--
 drivers/scsi/qla2xxx/qla_nx.c        |  3 +-
 drivers/scsi/scsi_debug.c            |  9 ++---
 drivers/scsi/scsi_scan.c             |  9 +++--
 drivers/scsi/scsi_sysfs.c            | 22 ++++++------
 drivers/scsi/sd.c                    | 69 +++++++++++++++++++++++++-----------
 drivers/scsi/sd.h                    |  1 +
 drivers/scsi/st.c                    |  5 +--
 include/linux/blkdev.h               |  2 +-
 include/scsi/scsi_host.h             |  3 ++
 19 files changed, 129 insertions(+), 70 deletions(-)

With full diff below.

James

---

diff --git a/MAINTAINERS b/MAINTAINERS
index e9caa4b..8174cc2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9411,8 +9411,10 @@ F:	include/scsi/sg.h
 
 SCSI SUBSYSTEM
 M:	"James E.J. Bottomley" <JBottomley@odin.com>
-L:	linux-scsi@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
+M:	"Martin K. Petersen" <martin.petersen@oracle.com>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
+L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/
 F:	include/scsi/
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 7d8f129..dd49735 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -91,7 +91,8 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
 	lim->virt_boundary_mask = 0;
 	lim->max_segment_size = BLK_MAX_SEGMENT_SIZE;
-	lim->max_sectors = lim->max_hw_sectors = BLK_SAFE_MAX_SECTORS;
+	lim->max_sectors = lim->max_dev_sectors = lim->max_hw_sectors =
+		BLK_SAFE_MAX_SECTORS;
 	lim->chunk_sectors = 0;
 	lim->max_write_same_sectors = 0;
 	lim->max_discard_sectors = 0;
@@ -127,6 +128,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->max_hw_sectors = UINT_MAX;
 	lim->max_segment_size = UINT_MAX;
 	lim->max_sectors = UINT_MAX;
+	lim->max_dev_sectors = UINT_MAX;
 	lim->max_write_same_sectors = UINT_MAX;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
@@ -214,8 +216,8 @@ void blk_queue_bounce_limit(struct request_queue *q, u64 max_addr)
 EXPORT_SYMBOL(blk_queue_bounce_limit);
 
 /**
- * blk_limits_max_hw_sectors - set hard and soft limit of max sectors for request
- * @limits: the queue limits
+ * blk_queue_max_hw_sectors - set max sectors for a request for this queue
+ * @q:  the request queue for the device
  * @max_hw_sectors:  max hardware sectors in the usual 512b unit
  *
  * Description:
@@ -224,13 +226,19 @@ EXPORT_SYMBOL(blk_queue_bounce_limit);
  *    the device driver based upon the capabilities of the I/O
  *    controller.
  *
+ *    max_dev_sectors is a hard limit imposed by the storage device for
+ *    READ/WRITE requests. It is set by the disk driver.
+ *
  *    max_sectors is a soft limit imposed by the block layer for
  *    filesystem type requests.  This value can be overridden on a
  *    per-device basis in /sys/block/<device>/queue/max_sectors_kb.
  *    The soft limit can not exceed max_hw_sectors.
  **/
-void blk_limits_max_hw_sectors(struct queue_limits *limits, unsigned int max_hw_sectors)
+void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_sectors)
 {
+	struct queue_limits *limits = &q->limits;
+	unsigned int max_sectors;
+
 	if ((max_hw_sectors << 9) < PAGE_CACHE_SIZE) {
 		max_hw_sectors = 1 << (PAGE_CACHE_SHIFT - 9);
 		printk(KERN_INFO "%s: set to minimum %d\n",
@@ -238,22 +246,9 @@ void blk_limits_max_hw_sectors(struct queue_limits *limits, unsigned int max_hw_
 	}
 
 	limits->max_hw_sectors = max_hw_sectors;
-	limits->max_sectors = min_t(unsigned int, max_hw_sectors,
-				    BLK_DEF_MAX_SECTORS);
-}
-EXPORT_SYMBOL(blk_limits_max_hw_sectors);
-
-/**
- * blk_queue_max_hw_sectors - set max sectors for a request for this queue
- * @q:  the request queue for the device
- * @max_hw_sectors:  max hardware sectors in the usual 512b unit
- *
- * Description:
- *    See description for blk_limits_max_hw_sectors().
- **/
-void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_sectors)
-{
-	blk_limits_max_hw_sectors(&q->limits, max_hw_sectors);
+	max_sectors = min_not_zero(max_hw_sectors, limits->max_dev_sectors);
+	max_sectors = min_t(unsigned int, max_sectors, BLK_DEF_MAX_SECTORS);
+	limits->max_sectors = max_sectors;
 }
 EXPORT_SYMBOL(blk_queue_max_hw_sectors);
 
@@ -527,6 +522,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 
 	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
 	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
+	t->max_dev_sectors = min_not_zero(t->max_dev_sectors, b->max_dev_sectors);
 	t->max_write_same_sectors = min(t->max_write_same_sectors,
 					b->max_write_same_sectors);
 	t->bounce_pfn = min_not_zero(t->bounce_pfn, b->bounce_pfn);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 565b8da..e140cc4 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -205,6 +205,9 @@ queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 	if (ret < 0)
 		return ret;
 
+	max_hw_sectors_kb = min_not_zero(max_hw_sectors_kb, (unsigned long)
+					 q->limits.max_dev_sectors >> 1);
+
 	if (max_sectors_kb > max_hw_sectors_kb || max_sectors_kb < page_kb)
 		return -EINVAL;
 
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 5f692ae..64eed87 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -364,6 +364,7 @@ config SCSI_HPSA
 	tristate "HP Smart Array SCSI driver"
 	depends on PCI && SCSI
 	select CHECK_SIGNATURE
+	select SCSI_SAS_ATTRS
 	help
 	  This driver supports HP Smart Array Controllers (circa 2009).
 	  It is a SCSI alternative to the cciss driver, which is a block
@@ -499,6 +500,7 @@ config SCSI_ADVANSYS
 	tristate "AdvanSys SCSI support"
 	depends on SCSI
 	depends on ISA || EISA || PCI
+	depends on ISA_DMA_API || !ISA
 	help
 	  This is a driver for all SCSI host adapters manufactured by
 	  AdvanSys. It is documented in the kernel source in
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 519f9a4..febbd83 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7803,7 +7803,7 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 		return ASC_BUSY;
 	}
 	scsiqp->sense_addr = cpu_to_le32(sense_addr);
-	scsiqp->sense_len = cpu_to_le32(SCSI_SENSE_BUFFERSIZE);
+	scsiqp->sense_len = SCSI_SENSE_BUFFERSIZE;
 
 	/* Build ADV_SCSI_REQ_Q */
 
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 323982f..82ac1cd 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -333,6 +333,17 @@ static void scsi_host_dev_release(struct device *dev)
 		kfree(queuedata);
 	}
 
+	if (shost->shost_state == SHOST_CREATED) {
+		/*
+		 * Free the shost_dev device name here if scsi_host_alloc()
+		 * and scsi_host_put() have been called but neither
+		 * scsi_host_add() nor scsi_host_remove() has been called.
+		 * This avoids that the memory allocated for the shost_dev
+		 * name is leaked.
+		 */
+		kfree(dev_name(&shost->shost_dev));
+	}
+
 	scsi_destroy_command_freelist(shost);
 	if (shost_use_blk_mq(shost)) {
 		if (shost->tag_set.tags)
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6a8f958..a386036 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8671,7 +8671,7 @@ static void hpsa_disable_rld_caching(struct ctlr_info *h)
 	if ((rc != 0)  || (c->err_info->CommandStatus != 0))
 		goto errout;
 
-	if (*options && HPSA_DIAG_OPTS_DISABLE_RLD_CACHING)
+	if (*options & HPSA_DIAG_OPTS_DISABLE_RLD_CACHING)
 		goto out;
 
 errout:
diff --git a/drivers/scsi/mpt3sas/Kconfig b/drivers/scsi/mpt3sas/Kconfig
index 2906146..b736dbc 100644
--- a/drivers/scsi/mpt3sas/Kconfig
+++ b/drivers/scsi/mpt3sas/Kconfig
@@ -71,3 +71,12 @@ config SCSI_MPT3SAS_MAX_SGE
 	MAX_PHYS_SEGMENTS in most kernels.  However in SuSE kernels this
 	can be 256. However, it may decreased down to 16.  Decreasing this
 	parameter will reduce memory requirements on a per controller instance.
+
+config SCSI_MPT2SAS
+	tristate "Legacy MPT2SAS config option"
+	default n
+	select SCSI_MPT3SAS
+	depends on PCI && SCSI
+	---help---
+	Dummy config option for backwards compatiblity: configure the MPT3SAS
+	driver instead.
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index d95206b..9ab77b0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3905,8 +3905,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	 * We do not expose raid functionality to upper layer for warpdrive.
 	 */
 	if (!ioc->is_warpdrive && !scsih_is_raid(&scmd->device->sdev_gendev)
-	    && (sas_device_priv_data->flags & MPT_DEVICE_TLR_ON) &&
-	    scmd->cmd_len != 32)
+	    && sas_is_tlr_enabled(scmd->device) && scmd->cmd_len != 32)
 		mpi_control |= MPI2_SCSIIO_CONTROL_TLR_ON;
 
 	smid = mpt3sas_base_get_smid_scsiio(ioc, ioc->scsi_io_cb_idx, scmd);
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 90fdf0e..675e7fa 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -758,7 +758,7 @@ mvs_store_interrupt_coalescing(struct device *cdev,
 			struct device_attribute *attr,
 			const char *buffer, size_t size)
 {
-	int val = 0;
+	unsigned int val = 0;
 	struct mvs_info *mvi = NULL;
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
@@ -766,7 +766,7 @@ mvs_store_interrupt_coalescing(struct device *cdev,
 	if (buffer == NULL)
 		return size;
 
-	if (sscanf(buffer, "%d", &val) != 1)
+	if (sscanf(buffer, "%u", &val) != 1)
 		return -EINVAL;
 
 	if (val >= 0x10000) {
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index eb0cc54..b6b4cfd 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -433,7 +433,7 @@ qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, ulong off_in,
 	if (off_in < QLA82XX_PCI_CRBSPACE)
 		return -1;
 
-	*off_out = (void __iomem *)(off_in - QLA82XX_PCI_CRBSPACE);
+	off_in -= QLA82XX_PCI_CRBSPACE;
 
 	/* Try direct map */
 	m = &crb_128M_2M_map[CRB_BLK(off_in)].sub_block[CRB_SUBBLK(off_in)];
@@ -443,6 +443,7 @@ qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha, ulong off_in,
 		return 0;
 	}
 	/* Not in direct map, use crb window */
+	*off_out = (void __iomem *)off_in;
 	return 1;
 }
 
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index dfcc45b..d09d602 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -465,8 +465,9 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 	     0} },
 	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* MAINT OUT */
 	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
-	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* VERIFY */
-	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{0, 0x2f, 0, F_D_OUT_MAYBE | FF_DIRECT_IO, NULL, NULL, /* VERIFY(10) */
+	    {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xc7,
+	     0, 0, 0, 0, 0, 0} },
 	{1, 0x7f, 0x9, F_SA_HIGH | F_D_IN | FF_DIRECT_IO, resp_read_dt0,
 	    vl_iarr, {32,  0xc7, 0, 0, 0, 0, 0x1f, 0x18, 0x0, 0x9, 0xfe, 0,
 		      0xff, 0xff, 0xff, 0xff} },/* VARIABLE LENGTH, READ(32) */
@@ -477,8 +478,8 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 	    {10,  0x13, 0xff, 0xff, 0, 0, 0, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0,
 	     0} },
 /* 20 */
-	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* ALLOW REMOVAL */
-	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{0, 0x1e, 0, 0, NULL, NULL, /* ALLOW REMOVAL */
+	    {6,  0, 0, 0, 0x3, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{0, 0x1, 0, 0, resp_start_stop, NULL, /* REWIND ?? */
 	    {6,  0x1, 0, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* ATA_PT */
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 8324539..054923e 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -701,9 +701,12 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 * strings.
 	 */
 	if (sdev->inquiry_len < 36) {
-		sdev_printk(KERN_INFO, sdev,
-			    "scsi scan: INQUIRY result too short (%d),"
-			    " using 36\n", sdev->inquiry_len);
+		if (!sdev->host->short_inquiry) {
+			shost_printk(KERN_INFO, sdev->host,
+				    "scsi scan: INQUIRY result too short (%d),"
+				    " using 36\n", sdev->inquiry_len);
+			sdev->host->short_inquiry = 1;
+		}
 		sdev->inquiry_len = 36;
 	}
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 8d23122..21930c9 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1102,6 +1102,14 @@ void __scsi_remove_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
 
+	/*
+	 * This cleanup path is not reentrant and while it is impossible
+	 * to get a new reference with scsi_device_get() someone can still
+	 * hold a previously acquired one.
+	 */
+	if (sdev->sdev_state == SDEV_DEL)
+		return;
+
 	if (sdev->is_visible) {
 		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
 			return;
@@ -1110,7 +1118,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
 		scsi_dh_remove_device(sdev);
-	}
+		device_del(dev);
+	} else
+		put_device(&sdev->sdev_dev);
 
 	/*
 	 * Stop accepting new requests and wait until all queuecommand() and
@@ -1121,16 +1131,6 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	blk_cleanup_queue(sdev->request_queue);
 	cancel_work_sync(&sdev->requeue_work);
 
-	/*
-	 * Remove the device after blk_cleanup_queue() has been called such
-	 * a possible bdi_register() call with the same name occurs after
-	 * blk_cleanup_queue() has called bdi_destroy().
-	 */
-	if (sdev->is_visible)
-		device_del(dev);
-	else
-		put_device(&sdev->sdev_dev);
-
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5451980..3d22fc3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -638,11 +638,24 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 	unsigned int max_blocks = 0;
 
 	q->limits.discard_zeroes_data = 0;
-	q->limits.discard_alignment = sdkp->unmap_alignment *
-		logical_block_size;
-	q->limits.discard_granularity =
-		max(sdkp->physical_block_size,
-		    sdkp->unmap_granularity * logical_block_size);
+
+	/*
+	 * When LBPRZ is reported, discard alignment and granularity
+	 * must be fixed to the logical block size. Otherwise the block
+	 * layer will drop misaligned portions of the request which can
+	 * lead to data corruption. If LBPRZ is not set, we honor the
+	 * device preference.
+	 */
+	if (sdkp->lbprz) {
+		q->limits.discard_alignment = 0;
+		q->limits.discard_granularity = 1;
+	} else {
+		q->limits.discard_alignment = sdkp->unmap_alignment *
+			logical_block_size;
+		q->limits.discard_granularity =
+			max(sdkp->physical_block_size,
+			    sdkp->unmap_granularity * logical_block_size);
+	}
 
 	sdkp->provisioning_mode = mode;
 
@@ -2321,11 +2334,8 @@ got_data:
 		}
 	}
 
-	if (sdkp->capacity > 0xffffffff) {
+	if (sdkp->capacity > 0xffffffff)
 		sdp->use_16_for_rw = 1;
-		sdkp->max_xfer_blocks = SD_MAX_XFER_BLOCKS;
-	} else
-		sdkp->max_xfer_blocks = SD_DEF_XFER_BLOCKS;
 
 	/* Rescale capacity to 512-byte units */
 	if (sector_size == 4096)
@@ -2642,7 +2652,6 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 {
 	unsigned int sector_sz = sdkp->device->sector_size;
 	const int vpd_len = 64;
-	u32 max_xfer_length;
 	unsigned char *buffer = kmalloc(vpd_len, GFP_KERNEL);
 
 	if (!buffer ||
@@ -2650,14 +2659,11 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 	    scsi_get_vpd_page(sdkp->device, 0xb0, buffer, vpd_len))
 		goto out;
 
-	max_xfer_length = get_unaligned_be32(&buffer[8]);
-	if (max_xfer_length)
-		sdkp->max_xfer_blocks = max_xfer_length;
-
 	blk_queue_io_min(sdkp->disk->queue,
 			 get_unaligned_be16(&buffer[6]) * sector_sz);
-	blk_queue_io_opt(sdkp->disk->queue,
-			 get_unaligned_be32(&buffer[12]) * sector_sz);
+
+	sdkp->max_xfer_blocks = get_unaligned_be32(&buffer[8]);
+	sdkp->opt_xfer_blocks = get_unaligned_be32(&buffer[12]);
 
 	if (buffer[3] == 0x3c) {
 		unsigned int lba_count, desc_count;
@@ -2806,6 +2812,11 @@ static int sd_try_extended_inquiry(struct scsi_device *sdp)
 	return 0;
 }
 
+static inline u32 logical_to_sectors(struct scsi_device *sdev, u32 blocks)
+{
+	return blocks << (ilog2(sdev->sector_size) - 9);
+}
+
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -2815,8 +2826,9 @@ static int sd_revalidate_disk(struct gendisk *disk)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
 	struct scsi_device *sdp = sdkp->device;
+	struct request_queue *q = sdkp->disk->queue;
 	unsigned char *buffer;
-	unsigned int max_xfer;
+	unsigned int dev_max, rw_max;
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
 				      "sd_revalidate_disk\n"));
@@ -2864,11 +2876,26 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 */
 	sd_set_flush_flag(sdkp);
 
-	max_xfer = sdkp->max_xfer_blocks;
-	max_xfer <<= ilog2(sdp->sector_size) - 9;
+	/* Initial block count limit based on CDB TRANSFER LENGTH field size. */
+	dev_max = sdp->use_16_for_rw ? SD_MAX_XFER_BLOCKS : SD_DEF_XFER_BLOCKS;
+
+	/* Some devices report a maximum block count for READ/WRITE requests. */
+	dev_max = min_not_zero(dev_max, sdkp->max_xfer_blocks);
+	q->limits.max_dev_sectors = logical_to_sectors(sdp, dev_max);
+
+	/*
+	 * Use the device's preferred I/O size for reads and writes
+	 * unless the reported value is unreasonably large (or garbage).
+	 */
+	if (sdkp->opt_xfer_blocks && sdkp->opt_xfer_blocks <= dev_max &&
+	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS)
+		rw_max = q->limits.io_opt =
+			logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
+	else
+		rw_max = BLK_DEF_MAX_SECTORS;
 
-	sdkp->disk->queue->limits.max_sectors =
-		min_not_zero(queue_max_hw_sectors(sdkp->disk->queue), max_xfer);
+	/* Combine with controller limits */
+	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
 
 	set_capacity(disk, sdkp->capacity);
 	sd_config_write_same(sdkp);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 63ba5ca..5f2a84a 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -67,6 +67,7 @@ struct scsi_disk {
 	atomic_t	openers;
 	sector_t	capacity;	/* size in 512-byte sectors */
 	u32		max_xfer_blocks;
+	u32		opt_xfer_blocks;
 	u32		max_ws_blocks;
 	u32		max_unmap_blocks;
 	u32		unmap_granularity;
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e0a1e52..2e52295 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4083,6 +4083,7 @@ static int create_one_cdev(struct scsi_tape *tape, int mode, int rew)
 	}
 	cdev->owner = THIS_MODULE;
 	cdev->ops = &st_fops;
+	STm->cdevs[rew] = cdev;
 
 	error = cdev_add(cdev, cdev_devno, 1);
 	if (error) {
@@ -4091,7 +4092,6 @@ static int create_one_cdev(struct scsi_tape *tape, int mode, int rew)
 		pr_err("st%d: Device not attached.\n", dev_num);
 		goto out_free;
 	}
-	STm->cdevs[rew] = cdev;
 
 	i = mode << (4 - ST_NBR_MODE_BITS);
 	snprintf(name, 10, "%s%s%s", rew ? "n" : "",
@@ -4110,8 +4110,9 @@ static int create_one_cdev(struct scsi_tape *tape, int mode, int rew)
 	return 0;
 out_free:
 	cdev_del(STm->cdevs[rew]);
-	STm->cdevs[rew] = NULL;
 out:
+	STm->cdevs[rew] = NULL;
+	STm->devs[rew] = NULL;
 	return error;
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3fe27f8..a5f9643 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -254,6 +254,7 @@ struct queue_limits {
 	unsigned long		virt_boundary_mask;
 
 	unsigned int		max_hw_sectors;
+	unsigned int		max_dev_sectors;
 	unsigned int		chunk_sectors;
 	unsigned int		max_sectors;
 	unsigned int		max_segment_size;
@@ -958,7 +959,6 @@ extern struct request_queue *blk_init_allocated_queue(struct request_queue *,
 extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
-extern void blk_limits_max_hw_sectors(struct queue_limits *, unsigned int);
 extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_chunk_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_max_segments(struct request_queue *, unsigned short);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index ed52712..fcfa3d7 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -668,6 +668,9 @@ struct Scsi_Host {
 	unsigned use_blk_mq:1;
 	unsigned use_cmd_list:1;
 
+	/* Host responded with short (<36 bytes) INQUIRY result */
+	unsigned short_inquiry:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */



