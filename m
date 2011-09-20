From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5/5] pm8001: remove pm8001_slave_{alloc|configure}
Date: Tue, 20 Sep 2011 15:11:03 -0700
Message-ID: <20110920221100.1094.11223.stgit@localhost6.localdomain6>
References: <20110920220819.1094.12265.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:57303 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112Ab1ITWLF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Sep 2011 18:11:05 -0400
In-Reply-To: <20110920220819.1094.12265.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: jgarzik@pobox.com, JBottomley@parallels.com, Jack Wang <jack_wang@usish.com>

libsas handles:
1/ limiting ata scanning to lun0
2/ changes to /sys/block/<sdX>/device/queue_depth for ata devices

libata handles turning off ncq globally via kernel command line
(libata.force=noncq) or sysfs (echo 1 >
/sys/block/<sdX>/device/queue_depth).  A lldd specific compile option is
not necessary.

Cc: Jack Wang <jack_wang@usish.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/pm8001/pm8001_init.c |    4 ++--
 drivers/scsi/pm8001/pm8001_sas.c  |   31 +------------------------------
 drivers/scsi/pm8001/pm8001_sas.h  |    2 --
 3 files changed, 3 insertions(+), 34 deletions(-)

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

