From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] libata,libsas: expose ata_sas_change_queue_depth() and use
	it
Date: Mon, 03 Mar 2008 11:27:28 -0600
Message-ID: <1204565248.3043.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The current libsas implementation of change_queue_depth() only really
pays attention to the SAS queuing requirements.  If we plumb in a libata
variant, we can make sure we're doing correct queue depth modifications
on SATA devices.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0562b0a..d99403c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -962,13 +962,14 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
 }
 
 /**
- *	ata_scsi_change_queue_depth - SCSI callback for queue depth config
+ *	ata_sas_change_queue_depth - SAS callback for queue depth config
  *	@sdev: SCSI device to configure queue depth for
+ *	@dev: The ATA device whose depth is to be changed
  *	@queue_depth: new queue depth
  *
- *	This is libata standard hostt->change_queue_depth callback.
- *	SCSI will call into this callback when user tries to set queue
- *	depth via sysfs.
+ *	This is standard hostt->change_queue_depth callback for SAS
+ *	devices using libata for SATA tasks.  SCSI will call into this
+ *	callback when user tries to set queue depth via sysfs.
  *
  *	LOCKING:
  *	SCSI layer (we don't care)
@@ -976,16 +977,16 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
  *	RETURNS:
  *	Newly configured queue depth.
  */
-int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
+int ata_sas_change_queue_depth(struct scsi_device *sdev,
+			       struct ata_device *dev,
+			       int queue_depth)
 {
-	struct ata_port *ap = ata_shost_to_port(sdev->host);
-	struct ata_device *dev;
+	struct ata_port *ap = dev->link->ap;
 	unsigned long flags;
 
 	if (queue_depth < 1 || queue_depth == sdev->queue_depth)
 		return sdev->queue_depth;
 
-	dev = ata_scsi_find_dev(ap, sdev);
 	if (!dev || !ata_dev_enabled(dev))
 		return sdev->queue_depth;
 
@@ -1009,6 +1010,35 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
 	scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, queue_depth);
 	return queue_depth;
 }
+EXPORT_SYMBOL_GPL(ata_sas_change_queue_depth);
+
+/**
+ *	ata_scsi_change_queue_depth - SCSI callback for queue depth config
+ *	@sdev: SCSI device to configure queue depth for
+ *	@queue_depth: new queue depth
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
+int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
+{
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	struct ata_device *dev;
+
+	if (queue_depth < 1 || queue_depth == sdev->queue_depth)
+		return sdev->queue_depth;
+
+	dev = ata_scsi_find_dev(ap, sdev);
+
+	return ata_sas_change_queue_depth(sdev, dev, queue_depth);
+}
 
 /* XXX: for spindown warning */
 static void ata_delayed_done_timerfn(unsigned long arg)
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 601ec5b..99a6dee 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -823,6 +833,10 @@ void sas_slave_destroy(struct scsi_device *scsi_dev)
 int sas_change_queue_depth(struct scsi_device *scsi_dev, int new_depth)
 {
 	int res = min(new_depth, SAS_MAX_QD);
+	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
+
+	if (dev_is_sata(dev))
+		return ata_sas_change_queue_depth(scsi_dev, dev->sata_dev.ap->link.device, res);
 
 	if (scsi_dev->tagged_supported)
 		scsi_adjust_queue_depth(scsi_dev, scsi_get_tag_type(scsi_dev),
diff --git a/include/linux/libata.h b/include/linux/libata.h
index a05f600..b5c75aa 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -913,6 +913,7 @@ extern int ata_scsi_slave_config(struct scsi_device *sdev);
 extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth);
+int ata_sas_change_queue_depth(struct scsi_device *, struct ata_device *, int);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);
 extern int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
 extern u8 ata_irq_on(struct ata_port *ap);


