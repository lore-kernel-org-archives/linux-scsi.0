From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PULL] libsas updates for 3.2
Date: Wed, 28 Sep 2011 19:01:04 -0700
Message-ID: <1317261664.22593.15.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60865 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab1I2CBF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2011 22:01:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@parallels.com>
Cc: Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, Dave Jiang <dave.jiang@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>

The following changes since commit 41e9a69641fb3fa86fa9277a179f3ad261d072f7:

  [SCSI] ipr: Stop reading adapter dump prematurely (2011-09-22 15:30:28 +0400)

are available in the git repository at:
  git://github.com:djbw/linux.git libsas

These have all appeared on the mailing list previously save for the last
one "libsas: remove unused ata_task_resp fields" (just a cleanup).

Just a convenience branch since isci's atapi support needed the lun
scanning fixup as a baseline.

Dan Williams (7):
      libsas: disable scanning lun > 0 on ata devices
      libsas: fix ->change_queue_{depth|type} for sata devices
      libsas: dynamic queue depth
      mvsas: remove mvs_slave_{alloc|configure}
      pm8001: remove pm8001_slave_{alloc|configure}
      libsas: fix try_test_sas_gpio_gp_bit() build error
      libsas: remove unused ata_task_resp fields

 drivers/ata/libata-core.c           |    1 +
 drivers/ata/libata-scsi.c           |   44 +++++++++++++++++++++++------------
 drivers/scsi/libsas/sas_ata.c       |    4 ---
 drivers/scsi/libsas/sas_scsi_host.c |   42 +++++++++++++++++++--------------
 drivers/scsi/mvsas/mv_init.c        |    4 +-
 drivers/scsi/mvsas/mv_sas.c         |   30 -----------------------
 drivers/scsi/mvsas/mv_sas.h         |    2 -
 drivers/scsi/pm8001/pm8001_init.c   |    4 +-
 drivers/scsi/pm8001/pm8001_sas.c    |   31 +-----------------------
 drivers/scsi/pm8001/pm8001_sas.h    |    2 -
 drivers/scsi/scsi_transport_sas.c   |   10 ++++++-
 include/linux/libata.h              |    2 +
 include/scsi/libsas.h               |   14 +++++-----
 13 files changed, 76 insertions(+), 114 deletions(-)

commit 7705375e944ea94be7941b740efd0a77bb109cb1
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Sep 29 09:01:39 2011 +0000

    libsas: remove unused ata_task_resp fields
    
    Commit 1e34c838 "libsas: remove spurious sata control register read/write"
    removed the routines to retrieve the sata control register, now remove the
    unused data structure fields to remove any remaining confusion.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f285bc55c2a465b8a93109cceeb300a3d7352ef0
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat Sep 24 07:44:19 2011 +0000

    libsas: fix try_test_sas_gpio_gp_bit() build error
    
    If the user has disabled CONFIG_SCSI_SAS_HOST_SMP then libsas drivers
    will not be receiving smp-gpio frames and do not need this lookup code.
    
    Reported-by: Randy Dunlap <rdunlap@xenotime.net>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
    Acked-by: Randy Dunlap <rdunlap@xenotime.net>

commit 5927faeffe630f55037abd2056bdb9509224c9ff
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Sep 21 08:06:51 2011 +0000

    pm8001: remove pm8001_slave_{alloc|configure}
    
    libsas handles:
    1/ limiting ata scanning to lun0
    2/ changes to /sys/block/<sdX>/device/queue_depth for ata devices
    
    libata handles turning off ncq globally via kernel command line
    (libata.force=noncq) or sysfs (echo 1 >
    /sys/block/<sdX>/device/queue_depth).  A lldd specific compile option is
    not necessary.
    
    Cc: Jack Wang <jack_wang@usish.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
    Reviewed-by: Jack Wang <jack_wang@usish.com>

commit fd56b6575a84348210d8c54e3a1789e10a38080e
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Sep 21 08:06:45 2011 +0000

    mvsas: remove mvs_slave_{alloc|configure}
    
    libsas now handles:
    1/ limiting ata scanning to lun0
    2/ maximizing the queue_depth of sas devices (up to 256, mvsas only
       supports 64)
    3/ changes to /sys/block/<sdX>/device/queue_depth for ata devices
    
    Cc: Xiangliang Yu <yuxiangl@marvell.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
    Reviewed-by: Jack Wang <jack_wang@usish.com>

commit bcee480902f491143823e3fb18a25aa675f63f26
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Sep 21 08:06:40 2011 +0000

    libsas: dynamic queue depth
    
    The queue-depth for libsas-attached devices initializes to 32 and can
    only be increased manually via sysfs to a max of 64, while mpt2sas
    attached devices initialize to 254 and dynamically float via the
    midlayer ->change_queue_depth interface.
    
    No performance regression was observed with this change on the isci
    driver.
    
    Cc: Christoph Hellwig <hch@lst.de>
    Cc: Mark Salyzyn <msalyzyn@us.xyratex.com>
    Cc: Xiangliang Yu <yuxiangl@marvell.com>
    Cc: Jack Wang <jack_wang@usish.com>
    Cc: Mark Salyzyn <msalyzyn@us.xyratex.com>
    Cc: Luben Tuikov <ltuikov@yahoo.com>
    Tested-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
    Acked-by: Christoph Hellwig <hch@infradead.org>
    Reviewed-by: Jack Wang <jack_wang@usish.com>
    Acked-by: Mark Salyzyn <mark_salyzyn@us.xyratex.com>

commit e68549cb99499cbbc7a110cf7050df254adbc994
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Sep 21 08:06:35 2011 +0000

    libsas: fix ->change_queue_{depth|type} for sata devices
    
    Pass queue_depth change requests to libata, and prevent queue_type
    changes for ATA devices.
    
    Otherwise:
    1/ we do not honor the libata specific restrictions on the queue depth
    2/ libsas drivers that do not set sdev->tagged_supported are unable to
       change the queue_depth of ata devices via sysfs
    
    Cc: Tejun Heo <tj@kernel.org>
    Cc: Xiangliang Yu <yuxiangl@marvell.com>
    Cc: Jack Wang <jack_wang@usish.com>
    Cc: Mark Salyzyn <msalyzyn@us.xyratex.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
    Acked-by: Christoph Hellwig <hch@infradead.org>
    Reviewed-by: Jack Wang <jack_wang@usish.com>
    Acked-by: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
    Acked-by: Jeff Garzik <jgarzik@redhat.com>

commit 3d4a22cc894df33ab0d9d63a799118d4732e92da
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Sep 21 08:06:30 2011 +0000

    libsas: disable scanning lun > 0 on ata devices
    
    Currently mvsas and pm8001 have custom ->slave_alloc implementations to
    achieve this.  Uplevel it for all libsas drivers as isci encounters problems
    with atapi devices when scanning past lun0.
    
    Just do what Darrick suggested [1], and limit the scan for ata devices.
    
    [1] http://marc.info/?l=linux-scsi&m=116604101119861&w=2
    
    Cc: Darrick Wong <djwong@us.ibm.com>
    Cc: Xiangliang Yu <yuxiangl@marvell.com>
    Cc: Jack Wang <jack_wang@usish.com>
    Cc: Mark Salyzyn <msalyzyn@us.xyratex.com>
    Cc: Luben Tuikov <ltuikov@yahoo.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
    Acked-by: Christoph Hellwig <hch@infradead.org>
    Reviewed-by: Jack Wang <jack_wang@usish.com>
    Acked-by: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
    Acked-by: Jeff Garzik <jgarzik@redhat.com>

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4a3a5ae..d26c7f4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6713,6 +6713,7 @@ EXPORT_SYMBOL_GPL(ata_scsi_queuecmd);
 EXPORT_SYMBOL_GPL(ata_scsi_slave_config);
 EXPORT_SYMBOL_GPL(ata_scsi_slave_destroy);
 EXPORT_SYMBOL_GPL(ata_scsi_change_queue_depth);
+EXPORT_SYMBOL_GPL(__ata_change_queue_depth);
 EXPORT_SYMBOL_GPL(sata_scr_valid);
 EXPORT_SYMBOL_GPL(sata_scr_read);
 EXPORT_SYMBOL_GPL(sata_scr_write);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 46d087f..19ba770 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1215,25 +1215,15 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
 }
 
 /**
- *	ata_scsi_change_queue_depth - SCSI callback for queue depth config
- *	@sdev: SCSI device to configure queue depth for
- *	@queue_depth: new queue depth
- *	@reason: calling context
- *
- *	This is libata standard hostt->change_queue_depth callback.
- *	SCSI will call into this callback when user tries to set queue
- *	depth via sysfs.
+ *	__ata_change_queue_depth - helper for ata_scsi_change_queue_depth
  *
- *	LOCKING:
- *	SCSI layer (we don't care)
+ *	libsas and libata have different approaches for associating a sdev to
+ *	its ata_port.
  *
- *	RETURNS:
- *	Newly configured queue depth.
  */
-int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth,
-				int reason)
+int __ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
+			     int queue_depth, int reason)
 {
-	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev;
 	unsigned long flags;
 
@@ -1269,6 +1259,30 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth,
 }
 
 /**
+ *	ata_scsi_change_queue_depth - SCSI callback for queue depth config
+ *	@sdev: SCSI device to configure queue depth for
+ *	@queue_depth: new queue depth
+ *	@reason: calling context
+ *
+ *	This is libata standard hostt->change_queue_depth callback.
+ *	SCSI will call into this callback when user tries to set queue
+ *	depth via sysfs.
+ *
+ *	LOCKING:
+ *	SCSI layer (we don't care)
+ *
+ *	RETURNS:
+ *	Newly configured queue depth.
+ */
+int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth,
+				int reason)
+{
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+
+	return __ata_change_queue_depth(ap, sdev, queue_depth, reason);
+}
+
+/**
  *	ata_scsi_start_stop_xlat - Translate SCSI START STOP UNIT command
  *	@qc: Storage for translated ATA taskfile
  *
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index db9238f..83118d0 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -121,10 +121,6 @@ static void sas_ata_task_done(struct sas_task *task)
 			if (unlikely(link->eh_info.err_mask))
 				qc->flags |= ATA_QCFLAG_FAILED;
 		}
-
-		dev->sata_dev.sstatus = resp->sstatus;
-		dev->sata_dev.serror = resp->serror;
-		dev->sata_dev.scontrol = resp->scontrol;
 	} else {
 		ac = sas_to_ata_err(stat);
 		if (ac) {
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index d625577..ebd1417 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -761,8 +761,7 @@ int sas_target_alloc(struct scsi_target *starget)
 	return 0;
 }
 
-#define SAS_DEF_QD 32
-#define SAS_MAX_QD 64
+#define SAS_DEF_QD 256
 
 int sas_slave_configure(struct scsi_device *scsi_dev)
 {
@@ -805,31 +804,38 @@ void sas_slave_destroy(struct scsi_device *scsi_dev)
 		dev->sata_dev.ap->link.device[0].class = ATA_DEV_NONE;
 }
 
-int sas_change_queue_depth(struct scsi_device *scsi_dev, int new_depth,
-			   int reason)
+int sas_change_queue_depth(struct scsi_device *sdev, int depth, int reason)
 {
-	int res = min(new_depth, SAS_MAX_QD);
+	struct domain_device *dev = sdev_to_domain_dev(sdev);
 
-	if (reason != SCSI_QDEPTH_DEFAULT)
+	if (dev_is_sata(dev))
+		return __ata_change_queue_depth(dev->sata_dev.ap, sdev, depth,
+						reason);
+
+	switch (reason) {
+	case SCSI_QDEPTH_DEFAULT:
+	case SCSI_QDEPTH_RAMP_UP:
+		if (!sdev->tagged_supported)
+			depth = 1;
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
+		break;
+	case SCSI_QDEPTH_QFULL:
+		scsi_track_queue_full(sdev, depth);
+		break;
+	default:
 		return -EOPNOTSUPP;
-
-	if (scsi_dev->tagged_supported)
-		scsi_adjust_queue_depth(scsi_dev, scsi_get_tag_type(scsi_dev),
-					res);
-	else {
-		struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
-		sas_printk("device %llx LUN %x queue depth changed to 1\n",
-			   SAS_ADDR(dev->sas_addr),
-			   scsi_dev->lun);
-		scsi_adjust_queue_depth(scsi_dev, 0, 1);
-		res = 1;
 	}
 
-	return res;
+	return depth;
 }
 
 int sas_change_queue_type(struct scsi_device *scsi_dev, int qt)
 {
+	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
+
+	if (dev_is_sata(dev))
+		return -EINVAL;
+
 	if (!scsi_dev->tagged_supported)
 		return 0;
 
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 4e9af66..052861b 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -59,7 +59,7 @@ static struct scsi_host_template mvs_sht = {
 	.name			= DRV_NAME,
 	.queuecommand		= sas_queuecommand,
 	.target_alloc		= sas_target_alloc,
-	.slave_configure	= mvs_slave_configure,
+	.slave_configure	= sas_slave_configure,
 	.slave_destroy		= sas_slave_destroy,
 	.scan_finished		= mvs_scan_finished,
 	.scan_start		= mvs_scan_start,
@@ -74,7 +74,7 @@ static struct scsi_host_template mvs_sht = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
-	.slave_alloc		= mvs_slave_alloc,
+	.slave_alloc		= sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= mvst_host_attrs,
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 4196eee..f2ac01f 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -276,36 +276,6 @@ static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
 				   PORTE_BYTES_DMAED);
 }
 
-int mvs_slave_alloc(struct scsi_device *scsi_dev)
-{
-	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
-	if (dev_is_sata(dev)) {
-		/* We don't need to rescan targets
-		 * if REPORT_LUNS request is failed
-		 */
-		if (scsi_dev->lun > 0)
-			return -ENXIO;
-		scsi_dev->tagged_supported = 1;
-	}
-
-	return sas_slave_alloc(scsi_dev);
-}
-
-int mvs_slave_configure(struct scsi_device *sdev)
-{
-	struct domain_device *dev = sdev_to_domain_dev(sdev);
-	int ret = sas_slave_configure(sdev);
-
-	if (ret)
-		return ret;
-	if (!dev_is_sata(dev)) {
-		sas_change_queue_depth(sdev,
-			MVS_QUEUE_SIZE,
-			SCSI_QDEPTH_DEFAULT);
-	}
-	return 0;
-}
-
 void mvs_scan_start(struct Scsi_Host *shost)
 {
 	int i, j;
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 44d7885..21ee8b0 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -459,8 +459,6 @@ int mvs_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 			void *funcdata);
 void __devinit mvs_set_sas_addr(struct mvs_info *mvi, int port_id,
 				u32 off_lo, u32 off_hi, u64 sas_addr);
-int mvs_slave_alloc(struct scsi_device *scsi_dev);
-int mvs_slave_configure(struct scsi_device *sdev);
 void mvs_scan_start(struct Scsi_Host *shost);
 int mvs_scan_finished(struct Scsi_Host *shost, unsigned long time);
 int mvs_queue_command(struct sas_task *task, const int num,
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 172cefb..c21a216 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -61,7 +61,7 @@ static struct scsi_host_template pm8001_sht = {
 	.name			= DRV_NAME,
 	.queuecommand		= sas_queuecommand,
 	.target_alloc		= sas_target_alloc,
-	.slave_configure	= pm8001_slave_configure,
+	.slave_configure	= sas_slave_configure,
 	.slave_destroy		= sas_slave_destroy,
 	.scan_finished		= pm8001_scan_finished,
 	.scan_start		= pm8001_scan_start,
@@ -76,7 +76,7 @@ static struct scsi_host_template pm8001_sht = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
-	.slave_alloc		= pm8001_slave_alloc,
+	.slave_alloc		= sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= pm8001_host_attrs,
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 7dbbf8b..9068f12 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -216,20 +216,6 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 	return rc;
 }
 
-int pm8001_slave_alloc(struct scsi_device *scsi_dev)
-{
-	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
-	if (dev_is_sata(dev)) {
-		/* We don't need to rescan targets
-		* if REPORT_LUNS request is failed
-		*/
-		if (scsi_dev->lun > 0)
-			return -ENXIO;
-		scsi_dev->tagged_supported = 1;
-	}
-	return sas_slave_alloc(scsi_dev);
-}
-
 /**
   * pm8001_scan_start - we should enable all HBA phys by sending the phy_start
   * command to HBA.
@@ -314,22 +300,7 @@ static int pm8001_task_prep_ssp(struct pm8001_hba_info *pm8001_ha,
 {
 	return PM8001_CHIP_DISP->ssp_io_req(pm8001_ha, ccb);
 }
-int pm8001_slave_configure(struct scsi_device *sdev)
-{
-	struct domain_device *dev = sdev_to_domain_dev(sdev);
-	int ret = sas_slave_configure(sdev);
-	if (ret)
-		return ret;
-	if (dev_is_sata(dev)) {
-	#ifdef PM8001_DISABLE_NCQ
-		struct ata_port *ap = dev->sata_dev.ap;
-		struct ata_device *adev = ap->link.device;
-		adev->flags |= ATA_DFLAG_NCQ_OFF;
-		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, 1);
-	#endif
-	}
-	return 0;
-}
+
  /* Find the local port id that's attached to this device */
 static int sas_find_local_port_id(struct domain_device *dev)
 {
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index b97c8ab..93959fe 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -471,8 +471,6 @@ void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
 	struct sas_task *task, struct pm8001_ccb_info *ccb, u32 ccb_idx);
 int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 	void *funcdata);
-int pm8001_slave_alloc(struct scsi_device *scsi_dev);
-int pm8001_slave_configure(struct scsi_device *sdev);
 void pm8001_scan_start(struct Scsi_Host *shost);
 int pm8001_scan_finished(struct Scsi_Host *shost, unsigned long time);
 int pm8001_queue_command(struct sas_task *task, const int num,
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index c6fcf76..9d9330a 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1545,8 +1545,14 @@ int sas_rphy_add(struct sas_rphy *rphy)
 
 	if (identify->device_type == SAS_END_DEVICE &&
 	    rphy->scsi_target_id != -1) {
-		scsi_scan_target(&rphy->dev, 0,
-				rphy->scsi_target_id, SCAN_WILD_CARD, 0);
+		int lun;
+
+		if (identify->target_port_protocols & SAS_PROTOCOL_SSP)
+			lun = SCAN_WILD_CARD;
+		else
+			lun = 0;
+
+		scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id, lun, 0);
 	}
 
 	return 0;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index efd6f98..23fa829 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1052,6 +1052,8 @@ extern int ata_scsi_slave_config(struct scsi_device *sdev);
 extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth, int reason);
+extern int __ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
+				    int queue_depth, int reason);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);
 extern int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
 extern void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index af0a1de..0d78bfa 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -168,9 +168,6 @@ struct sata_device {
 	struct ata_port *ap;
 	struct ata_host ata_host;
 	struct ata_taskfile tf;
-	u32 sstatus;
-	u32 serror;
-	u32 scontrol;
 };
 
 /* ---------- Domain device ---------- */
@@ -410,7 +407,14 @@ static inline unsigned int to_sas_gpio_od(int device, int bit)
 	return 3 * device + bit;
 }
 
+#ifdef CONFIG_SCSI_SAS_HOST_SMP
 int try_test_sas_gpio_gp_bit(unsigned int od, u8 *data, u8 index, u8 count);
+#else
+static inline int try_test_sas_gpio_gp_bit(unsigned int od, u8 *data, u8 index, u8 count)
+{
+	return -1;
+}
+#endif
 
 /* ---------- Tasks ---------- */
 /*
@@ -472,10 +476,6 @@ enum exec_status {
 struct ata_task_resp {
 	u16  frame_len;
 	u8   ending_fis[24];	  /* dev to host or data-in */
-	u32  sstatus;
-	u32  serror;
-	u32  scontrol;
-	u32  sactive;
 };
 
 #define SAS_STATUS_BUF_SIZE 96


