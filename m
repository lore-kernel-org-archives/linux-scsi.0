From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 4/5] mvsas: remove mvs_slave_{alloc|configure}
Date: Tue, 20 Sep 2011 15:10:55 -0700
Message-ID: <20110920221051.1094.39578.stgit@localhost6.localdomain6>
References: <20110920220819.1094.12265.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20110920220819.1094.12265.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Xiangliang Yu <yuxiangl@marvell.com>, jgarzik@pobox.com, JBottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

libsas now handles:
1/ limiting ata scanning to lun0
2/ maximizing the queue_depth of sas devices (up to 256, mvsas only
   supports 64)
3/ changes to /sys/block/<sdX>/device/queue_depth for ata devices

Cc: Xiangliang Yu <yuxiangl@marvell.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/mvsas/mv_init.c |    4 ++--
 drivers/scsi/mvsas/mv_sas.c  |   30 ------------------------------
 drivers/scsi/mvsas/mv_sas.h  |    2 --
 3 files changed, 2 insertions(+), 34 deletions(-)

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

