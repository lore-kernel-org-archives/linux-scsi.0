From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/5] libsas: fix ->change_queue_{depth|type} for sata devices
Date: Tue, 20 Sep 2011 15:10:33 -0700
Message-ID: <20110920221024.1094.58367.stgit@localhost6.localdomain6>
References: <20110920220819.1094.12265.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3865 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab1ITWKe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Sep 2011 18:10:34 -0400
In-Reply-To: <20110920220819.1094.12265.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: jgarzik@pobox.com, JBottomley@parallels.com, Jack Wang <jack_wang@usish.com>, Tejun Heo <tj@kernel.org>, Xiangliang Yu <yuxiangl@marvell.com>, Mark Salyzyn <msalyzyn@us.xyratex.com>

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
---
 drivers/ata/libata-core.c           |    1 +
 drivers/ata/libata-scsi.c           |   44 +++++++++++++++++++++++------------
 drivers/scsi/libsas/sas_scsi_host.c |   11 ++++++++-
 include/linux/libata.h              |    2 ++
 4 files changed, 42 insertions(+), 16 deletions(-)

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
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index eeba76c..4c6923c 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -831,8 +831,13 @@ void sas_slave_destroy(struct scsi_device *scsi_dev)
 int sas_change_queue_depth(struct scsi_device *scsi_dev, int new_depth,
 			   int reason)
 {
+	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
 	int res = min(new_depth, SAS_MAX_QD);
 
+	if (dev_is_sata(dev))
+		return __ata_change_queue_depth(dev->sata_dev.ap, scsi_dev,
+						new_depth, reason);
+
 	if (reason != SCSI_QDEPTH_DEFAULT)
 		return -EOPNOTSUPP;
 
@@ -840,7 +845,6 @@ int sas_change_queue_depth(struct scsi_device *scsi_dev, int new_depth,
 		scsi_adjust_queue_depth(scsi_dev, scsi_get_tag_type(scsi_dev),
 					res);
 	else {
-		struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
 		sas_printk("device %llx LUN %x queue depth changed to 1\n",
 			   SAS_ADDR(dev->sas_addr),
 			   scsi_dev->lun);
@@ -853,6 +857,11 @@ int sas_change_queue_depth(struct scsi_device *scsi_dev, int new_depth,
 
 int sas_change_queue_type(struct scsi_device *scsi_dev, int qt)
 {
+	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
+
+	if (dev_is_sata(dev))
+		return -EINVAL;
+
 	if (!scsi_dev->tagged_supported)
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

