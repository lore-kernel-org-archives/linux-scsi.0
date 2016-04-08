From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.6-rc2
Date: Fri, 08 Apr 2016 16:29:41 -0700
Message-ID: <1460158181.2340.79.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of 8 fixes.  Two are trivial gcc-6 updates (brace
additions and unused variable removal).  There's a couple of cxlflash
regressions, a correction for sd being overly chatty on revalidation
(causing excess log increases).  A VPD issue which could crash USB
devices because they seem very intolerant to VPD inquiries, an ALUA
deadlock fix and a mpt3sas buffer overrun fix.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Arnd Bergmann (1):
      aacraid: add missing curly braces

Bart Van Assche (2):
      scsi_dh_alua: Fix a recently introduced deadlock
      scsi: Declare local symbols static

Calvin Owens (1):
      mpt3sas: Don't overreach ioc->reply_post[] during initialization

Hannes Reinecke (1):
      scsi: Do not attach VPD to devices that don't support it

Manoj N. Kumar (2):
      cxlflash: Move to exponential back-off when cmd_room is not available
      cxlflash: Fix regression issue with re-ordering patch

Martin K. Petersen (1):
      sd: Fix excessive capacity printing on devices with blocks bigger than 512 bytes

And the diffstat

 drivers/scsi/aacraid/linit.c               |   3 +-
 drivers/scsi/cxlflash/main.c               | 138 ++++++++++++++++++++---------
 drivers/scsi/cxlflash/main.h               |   5 +-
 drivers/scsi/device_handler/scsi_dh_alua.c |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c        |  33 ++++---
 drivers/scsi/scsi.c                        |   3 +-
 drivers/scsi/scsi_sysfs.c                  |   8 +-
 drivers/scsi/sd.c                          |  47 ++--------
 drivers/scsi/sd.h                          |   7 +-
 include/scsi/scsi_device.h                 |  25 ++++++
 10 files changed, 164 insertions(+), 109 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 21a67ed..ff6caab 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -452,10 +452,11 @@ static int aac_slave_configure(struct scsi_device *sdev)
 		else if (depth < 2)
 			depth = 2;
 		scsi_change_queue_depth(sdev, depth);
-	} else
+	} else {
 		scsi_change_queue_depth(sdev, 1);
 
 		sdev->tagged_supported = 1;
+	}
 
 	return 0;
 }
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 35968bd..8fb9643 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -289,7 +289,7 @@ static void context_reset(struct afu_cmd *cmd)
 		atomic64_set(&afu->room, room);
 		if (room)
 			goto write_rrin;
-		udelay(nretry);
+		udelay(1 << nretry);
 	} while (nretry++ < MC_ROOM_RETRY_CNT);
 
 	pr_err("%s: no cmd_room to send reset\n", __func__);
@@ -303,7 +303,7 @@ write_rrin:
 		if (rrin != 0x1)
 			break;
 		/* Double delay each time */
-		udelay(2 << nretry);
+		udelay(1 << nretry);
 	} while (nretry++ < MC_ROOM_RETRY_CNT);
 }
 
@@ -338,7 +338,7 @@ retry:
 			atomic64_set(&afu->room, room);
 			if (room)
 				goto write_ioarrin;
-			udelay(nretry);
+			udelay(1 << nretry);
 		} while (nretry++ < MC_ROOM_RETRY_CNT);
 
 		dev_err(dev, "%s: no cmd_room to send 0x%X\n",
@@ -352,7 +352,7 @@ retry:
 		 * afu->room.
 		 */
 		if (nretry++ < MC_ROOM_RETRY_CNT) {
-			udelay(nretry);
+			udelay(1 << nretry);
 			goto retry;
 		}
 
@@ -683,28 +683,23 @@ static void stop_afu(struct cxlflash_cfg *cfg)
 }
 
 /**
- * term_mc() - terminates the master context
+ * term_intr() - disables all AFU interrupts
  * @cfg:	Internal structure associated with the host.
  * @level:	Depth of allocation, where to begin waterfall tear down.
  *
  * Safe to call with AFU/MC in partially allocated/initialized state.
  */
-static void term_mc(struct cxlflash_cfg *cfg, enum undo_level level)
+static void term_intr(struct cxlflash_cfg *cfg, enum undo_level level)
 {
-	int rc = 0;
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
 
 	if (!afu || !cfg->mcctx) {
-		dev_err(dev, "%s: returning from term_mc with NULL afu or MC\n",
-		       __func__);
+		dev_err(dev, "%s: returning with NULL afu or MC\n", __func__);
 		return;
 	}
 
 	switch (level) {
-	case UNDO_START:
-		rc = cxl_stop_context(cfg->mcctx);
-		BUG_ON(rc);
 	case UNMAP_THREE:
 		cxl_unmap_afu_irq(cfg->mcctx, 3, afu);
 	case UNMAP_TWO:
@@ -713,9 +708,34 @@ static void term_mc(struct cxlflash_cfg *cfg, enum undo_level level)
 		cxl_unmap_afu_irq(cfg->mcctx, 1, afu);
 	case FREE_IRQ:
 		cxl_free_afu_irqs(cfg->mcctx);
-	case RELEASE_CONTEXT:
-		cfg->mcctx = NULL;
+		/* fall through */
+	case UNDO_NOOP:
+		/* No action required */
+		break;
+	}
+}
+
+/**
+ * term_mc() - terminates the master context
+ * @cfg:	Internal structure associated with the host.
+ * @level:	Depth of allocation, where to begin waterfall tear down.
+ *
+ * Safe to call with AFU/MC in partially allocated/initialized state.
+ */
+static void term_mc(struct cxlflash_cfg *cfg)
+{
+	int rc = 0;
+	struct afu *afu = cfg->afu;
+	struct device *dev = &cfg->dev->dev;
+
+	if (!afu || !cfg->mcctx) {
+		dev_err(dev, "%s: returning with NULL afu or MC\n", __func__);
+		return;
 	}
+
+	rc = cxl_stop_context(cfg->mcctx);
+	WARN_ON(rc);
+	cfg->mcctx = NULL;
 }
 
 /**
@@ -726,10 +746,20 @@ static void term_mc(struct cxlflash_cfg *cfg, enum undo_level level)
  */
 static void term_afu(struct cxlflash_cfg *cfg)
 {
+	/*
+	 * Tear down is carefully orchestrated to ensure
+	 * no interrupts can come in when the problem state
+	 * area is unmapped.
+	 *
+	 * 1) Disable all AFU interrupts
+	 * 2) Unmap the problem state area
+	 * 3) Stop the master context
+	 */
+	term_intr(cfg, UNMAP_THREE);
 	if (cfg->afu)
 		stop_afu(cfg);
 
-	term_mc(cfg, UNDO_START);
+	term_mc(cfg);
 
 	pr_debug("%s: returning\n", __func__);
 }
@@ -1597,41 +1627,24 @@ static int start_afu(struct cxlflash_cfg *cfg)
 }
 
 /**
- * init_mc() - create and register as the master context
+ * init_intr() - setup interrupt handlers for the master context
  * @cfg:	Internal structure associated with the host.
  *
  * Return: 0 on success, -errno on failure
  */
-static int init_mc(struct cxlflash_cfg *cfg)
+static enum undo_level init_intr(struct cxlflash_cfg *cfg,
+				 struct cxl_context *ctx)
 {
-	struct cxl_context *ctx;
-	struct device *dev = &cfg->dev->dev;
 	struct afu *afu = cfg->afu;
+	struct device *dev = &cfg->dev->dev;
 	int rc = 0;
-	enum undo_level level;
-
-	ctx = cxl_get_context(cfg->dev);
-	if (unlikely(!ctx))
-		return -ENOMEM;
-	cfg->mcctx = ctx;
-
-	/* Set it up as a master with the CXL */
-	cxl_set_master(ctx);
-
-	/* During initialization reset the AFU to start from a clean slate */
-	rc = cxl_afu_reset(cfg->mcctx);
-	if (unlikely(rc)) {
-		dev_err(dev, "%s: initial AFU reset failed rc=%d\n",
-			__func__, rc);
-		level = RELEASE_CONTEXT;
-		goto out;
-	}
+	enum undo_level level = UNDO_NOOP;
 
 	rc = cxl_allocate_afu_irqs(ctx, 3);
 	if (unlikely(rc)) {
 		dev_err(dev, "%s: call to allocate_afu_irqs failed rc=%d!\n",
 			__func__, rc);
-		level = RELEASE_CONTEXT;
+		level = UNDO_NOOP;
 		goto out;
 	}
 
@@ -1661,8 +1674,47 @@ static int init_mc(struct cxlflash_cfg *cfg)
 		level = UNMAP_TWO;
 		goto out;
 	}
+out:
+	return level;
+}
 
-	rc = 0;
+/**
+ * init_mc() - create and register as the master context
+ * @cfg:	Internal structure associated with the host.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static int init_mc(struct cxlflash_cfg *cfg)
+{
+	struct cxl_context *ctx;
+	struct device *dev = &cfg->dev->dev;
+	int rc = 0;
+	enum undo_level level;
+
+	ctx = cxl_get_context(cfg->dev);
+	if (unlikely(!ctx)) {
+		rc = -ENOMEM;
+		goto ret;
+	}
+	cfg->mcctx = ctx;
+
+	/* Set it up as a master with the CXL */
+	cxl_set_master(ctx);
+
+	/* During initialization reset the AFU to start from a clean slate */
+	rc = cxl_afu_reset(cfg->mcctx);
+	if (unlikely(rc)) {
+		dev_err(dev, "%s: initial AFU reset failed rc=%d\n",
+			__func__, rc);
+		goto ret;
+	}
+
+	level = init_intr(cfg, ctx);
+	if (unlikely(level)) {
+		dev_err(dev, "%s: setting up interrupts failed rc=%d\n",
+			__func__, rc);
+		goto out;
+	}
 
 	/* This performs the equivalent of the CXL_IOCTL_START_WORK.
 	 * The CXL_IOCTL_GET_PROCESS_ELEMENT is implicit in the process
@@ -1678,7 +1730,7 @@ ret:
 	pr_debug("%s: returning rc=%d\n", __func__, rc);
 	return rc;
 out:
-	term_mc(cfg, level);
+	term_intr(cfg, level);
 	goto ret;
 }
 
@@ -1751,7 +1803,8 @@ out:
 err2:
 	kref_put(&afu->mapcount, afu_unmap);
 err1:
-	term_mc(cfg, UNDO_START);
+	term_intr(cfg, UNMAP_THREE);
+	term_mc(cfg);
 	goto out;
 }
 
@@ -2488,8 +2541,7 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
 		if (unlikely(rc))
 			dev_err(dev, "%s: Failed to mark user contexts!(%d)\n",
 				__func__, rc);
-		stop_afu(cfg);
-		term_mc(cfg, UNDO_START);
+		term_afu(cfg);
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
 		cfg->state = STATE_FAILTERM;
diff --git a/drivers/scsi/cxlflash/main.h b/drivers/scsi/cxlflash/main.h
index 0faed42..eb9d8f7 100644
--- a/drivers/scsi/cxlflash/main.h
+++ b/drivers/scsi/cxlflash/main.h
@@ -79,12 +79,11 @@
 #define WWPN_BUF_LEN	(WWPN_LEN + 1)
 
 enum undo_level {
-	RELEASE_CONTEXT = 0,
+	UNDO_NOOP = 0,
 	FREE_IRQ,
 	UNMAP_ONE,
 	UNMAP_TWO,
-	UNMAP_THREE,
-	UNDO_START
+	UNMAP_THREE
 };
 
 struct dev_dependent_vals {
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index a404a41..8eaed05 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1112,9 +1112,9 @@ static void alua_bus_detach(struct scsi_device *sdev)
 	h->sdev = NULL;
 	spin_unlock(&h->pg_lock);
 	if (pg) {
-		spin_lock(&pg->lock);
+		spin_lock_irq(&pg->lock);
 		list_del_rcu(&h->node);
-		spin_unlock(&pg->lock);
+		spin_unlock_irq(&pg->lock);
 		kref_put(&pg->kref, release_port_group);
 	}
 	sdev->handler_data = NULL;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index e4db5fb..8c44b9c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5030,7 +5030,7 @@ _base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc, int sleep_flag,
 static int
 _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 {
-	int r, i;
+	int r, i, index;
 	unsigned long	flags;
 	u32 reply_address;
 	u16 smid;
@@ -5039,8 +5039,7 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 	struct _event_ack_list *delayed_event_ack, *delayed_event_ack_next;
 	u8 hide_flag;
 	struct adapter_reply_queue *reply_q;
-	long reply_post_free;
-	u32 reply_post_free_sz, index = 0;
+	Mpi2ReplyDescriptorsUnion_t *reply_post_free_contig;
 
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
 	    __func__));
@@ -5124,27 +5123,27 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 		_base_assign_reply_queues(ioc);
 
 	/* initialize Reply Post Free Queue */
-	reply_post_free_sz = ioc->reply_post_queue_depth *
-	    sizeof(Mpi2DefaultReplyDescriptor_t);
-	reply_post_free = (long)ioc->reply_post[index].reply_post_free;
+	index = 0;
+	reply_post_free_contig = ioc->reply_post[0].reply_post_free;
 	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
+		/*
+		 * If RDPQ is enabled, switch to the next allocation.
+		 * Otherwise advance within the contiguous region.
+		 */
+		if (ioc->rdpq_array_enable) {
+			reply_q->reply_post_free =
+				ioc->reply_post[index++].reply_post_free;
+		} else {
+			reply_q->reply_post_free = reply_post_free_contig;
+			reply_post_free_contig += ioc->reply_post_queue_depth;
+		}
+
 		reply_q->reply_post_host_index = 0;
-		reply_q->reply_post_free = (Mpi2ReplyDescriptorsUnion_t *)
-		    reply_post_free;
 		for (i = 0; i < ioc->reply_post_queue_depth; i++)
 			reply_q->reply_post_free[i].Words =
 			    cpu_to_le64(ULLONG_MAX);
 		if (!_base_is_controller_msix_enabled(ioc))
 			goto skip_init_reply_post_free_queue;
-		/*
-		 * If RDPQ is enabled, switch to the next allocation.
-		 * Otherwise advance within the contiguous region.
-		 */
-		if (ioc->rdpq_array_enable)
-			reply_post_free = (long)
-			    ioc->reply_post[++index].reply_post_free;
-		else
-			reply_post_free += reply_post_free_sz;
 	}
  skip_init_reply_post_free_queue:
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index b1bf42b..1deb6ad 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -784,8 +784,9 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 	int pg83_supported = 0;
 	unsigned char __rcu *vpd_buf, *orig_vpd_buf = NULL;
 
-	if (sdev->skip_vpd_pages)
+	if (!scsi_device_supports_vpd(sdev))
 		return;
+
 retry_pg0:
 	vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
 	if (!vpd_buf)
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 92ffd24..2b642b1 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -81,6 +81,7 @@ const char *scsi_host_state_name(enum scsi_host_state state)
 	return name;
 }
 
+#ifdef CONFIG_SCSI_DH
 static const struct {
 	unsigned char	value;
 	char		*name;
@@ -94,7 +95,7 @@ static const struct {
 	{ SCSI_ACCESS_STATE_TRANSITIONING, "transitioning" },
 };
 
-const char *scsi_access_state_name(unsigned char state)
+static const char *scsi_access_state_name(unsigned char state)
 {
 	int i;
 	char *name = NULL;
@@ -107,6 +108,7 @@ const char *scsi_access_state_name(unsigned char state)
 	}
 	return name;
 }
+#endif
 
 static int check_set(unsigned long long *val, char *src)
 {
@@ -226,7 +228,7 @@ show_shost_state(struct device *dev, struct device_attribute *attr, char *buf)
 }
 
 /* DEVICE_ATTR(state) clashes with dev_attr_state for sdev */
-struct device_attribute dev_attr_hstate =
+static struct device_attribute dev_attr_hstate =
 	__ATTR(state, S_IRUGO | S_IWUSR, show_shost_state, store_shost_state);
 
 static ssize_t
@@ -401,7 +403,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	NULL
 };
 
-struct attribute_group scsi_shost_attr_group = {
+static struct attribute_group scsi_shost_attr_group = {
 	.attrs =	scsi_sysfs_shost_attrs,
 };
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5a5457a..974ca5b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1275,18 +1275,19 @@ static int sd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdp = sdkp->device;
 	struct Scsi_Host *host = sdp->host;
+	sector_t capacity = logical_to_sectors(sdp, sdkp->capacity);
 	int diskinfo[4];
 
 	/* default to most commonly used values */
-        diskinfo[0] = 0x40;	/* 1 << 6 */
-       	diskinfo[1] = 0x20;	/* 1 << 5 */
-       	diskinfo[2] = sdkp->capacity >> 11;
-	
+	diskinfo[0] = 0x40;	/* 1 << 6 */
+	diskinfo[1] = 0x20;	/* 1 << 5 */
+	diskinfo[2] = capacity >> 11;
+
 	/* override with calculated, extended default, or driver values */
 	if (host->hostt->bios_param)
-		host->hostt->bios_param(sdp, bdev, sdkp->capacity, diskinfo);
+		host->hostt->bios_param(sdp, bdev, capacity, diskinfo);
 	else
-		scsicam_bios_param(bdev, sdkp->capacity, diskinfo);
+		scsicam_bios_param(bdev, capacity, diskinfo);
 
 	geo->heads = diskinfo[0];
 	geo->sectors = diskinfo[1];
@@ -2337,14 +2338,6 @@ got_data:
 	if (sdkp->capacity > 0xffffffff)
 		sdp->use_16_for_rw = 1;
 
-	/* Rescale capacity to 512-byte units */
-	if (sector_size == 4096)
-		sdkp->capacity <<= 3;
-	else if (sector_size == 2048)
-		sdkp->capacity <<= 2;
-	else if (sector_size == 1024)
-		sdkp->capacity <<= 1;
-
 	blk_queue_physical_block_size(sdp->request_queue,
 				      sdkp->physical_block_size);
 	sdkp->device->sector_size = sector_size;
@@ -2795,28 +2788,6 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 		sdkp->ws10 = 1;
 }
 
-static int sd_try_extended_inquiry(struct scsi_device *sdp)
-{
-	/* Attempt VPD inquiry if the device blacklist explicitly calls
-	 * for it.
-	 */
-	if (sdp->try_vpd_pages)
-		return 1;
-	/*
-	 * Although VPD inquiries can go to SCSI-2 type devices,
-	 * some USB ones crash on receiving them, and the pages
-	 * we currently ask for are for SPC-3 and beyond
-	 */
-	if (sdp->scsi_level > SCSI_SPC_2 && !sdp->skip_vpd_pages)
-		return 1;
-	return 0;
-}
-
-static inline u32 logical_to_sectors(struct scsi_device *sdev, u32 blocks)
-{
-	return blocks << (ilog2(sdev->sector_size) - 9);
-}
-
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -2856,7 +2827,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
 
-		if (sd_try_extended_inquiry(sdp)) {
+		if (scsi_device_supports_vpd(sdp)) {
 			sd_read_block_provisioning(sdkp);
 			sd_read_block_limits(sdkp);
 			sd_read_block_characteristics(sdkp);
@@ -2900,7 +2871,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	/* Combine with controller limits */
 	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
 
-	set_capacity(disk, sdkp->capacity);
+	set_capacity(disk, logical_to_sectors(sdp, sdkp->capacity));
 	sd_config_write_same(sdkp);
 	kfree(buffer);
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 5f2a84a..654630b 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -65,7 +65,7 @@ struct scsi_disk {
 	struct device	dev;
 	struct gendisk	*disk;
 	atomic_t	openers;
-	sector_t	capacity;	/* size in 512-byte sectors */
+	sector_t	capacity;	/* size in logical blocks */
 	u32		max_xfer_blocks;
 	u32		opt_xfer_blocks;
 	u32		max_ws_blocks;
@@ -146,6 +146,11 @@ static inline int scsi_medium_access_command(struct scsi_cmnd *scmd)
 	return 0;
 }
 
+static inline sector_t logical_to_sectors(struct scsi_device *sdev, sector_t blocks)
+{
+	return blocks << (ilog2(sdev->sector_size) - 9);
+}
+
 /*
  * A DIF-capable target device can be formatted with different
  * protection schemes.  Currently 0 through 3 are defined:
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c067019..74d79bd 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -516,6 +516,31 @@ static inline int scsi_device_tpgs(struct scsi_device *sdev)
 	return sdev->inquiry ? (sdev->inquiry[5] >> 4) & 0x3 : 0;
 }
 
+/**
+ * scsi_device_supports_vpd - test if a device supports VPD pages
+ * @sdev: the &struct scsi_device to test
+ *
+ * If the 'try_vpd_pages' flag is set it takes precedence.
+ * Otherwise we will assume VPD pages are supported if the
+ * SCSI level is at least SPC-3 and 'skip_vpd_pages' is not set.
+ */
+static inline int scsi_device_supports_vpd(struct scsi_device *sdev)
+{
+	/* Attempt VPD inquiry if the device blacklist explicitly calls
+	 * for it.
+	 */
+	if (sdev->try_vpd_pages)
+		return 1;
+	/*
+	 * Although VPD inquiries can go to SCSI-2 type devices,
+	 * some USB ones crash on receiving them, and the pages
+	 * we currently ask for are for SPC-3 and beyond
+	 */
+	if (sdev->scsi_level > SCSI_SPC_2 && !sdev->skip_vpd_pages)
+		return 1;
+	return 0;
+}
+
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
 	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
 #define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"
