From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 2/3] add scsi_host and scsi_target to scsi_bus
Date: Thu, 20 Sep 2007 13:47:23 +0200
Message-ID: <20070920114723.0FC853110BD@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:49940 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbXITLrY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2007 07:47:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: kay.sievers@vrfy.org, linux-scsi@vger.kernel.org

This patch implements scsi_host and scsi_target device types and
adds both to the scsi_bus.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hosts.c      |   12 ++++++++++--
 drivers/scsi/scsi_proc.c  |    7 ++++++-
 drivers/scsi/scsi_scan.c  |   14 ++++++++++----
 drivers/scsi/scsi_sysfs.c |   29 ++++++++++++++++++++++++-----
 4 files changed, 50 insertions(+), 12 deletions(-)

--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -279,6 +279,11 @@ static void scsi_host_dev_release(struct
 	kfree(shost);
 }
 
+struct device_type scsi_host_type = {
+	.name =		"scsi_host",
+	.release =	scsi_host_dev_release,
+};
+
 /**
  * scsi_host_alloc - register a scsi host adapter instance.
  * @sht:	pointer to scsi host template
@@ -372,7 +377,10 @@ struct Scsi_Host *scsi_host_alloc(struct
 	device_initialize(&shost->shost_gendev);
 	snprintf(shost->shost_gendev.bus_id, BUS_ID_SIZE, "host%d",
 		shost->host_no);
-	shost->shost_gendev.release = scsi_host_dev_release;
+#ifndef CONFIG_SYSFS_DEPRECATED
+	shost->shost_gendev.bus = &scsi_bus_type;
+#endif
+	shost->shost_gendev.type = &scsi_host_type;
 
 	class_device_initialize(&shost->shost_classdev);
 	shost->shost_classdev.dev = &shost->shost_gendev;
@@ -484,7 +492,7 @@ void scsi_exit_hosts(void)
 
 int scsi_is_host_device(const struct device *dev)
 {
-	return dev->release == scsi_host_dev_release;
+	return dev->type == &scsi_host_type;
 }
 EXPORT_SYMBOL(scsi_is_host_device);
 
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -146,10 +146,14 @@ void scsi_proc_host_rm(struct Scsi_Host 
 
 static int proc_print_scsidevice(struct device *dev, void *data)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
+	struct scsi_device *sdev;
 	struct seq_file *s = data;
 	int i;
 
+	if (!scsi_is_sdev_device(dev))
+		goto out;
+
+	sdev = to_scsi_device(dev);
 	seq_printf(s,
 		"Host: scsi%d Channel: %02d Id: %02d Lun: %02d\n  Vendor: ",
 		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
@@ -186,6 +190,7 @@ static int proc_print_scsidevice(struct 
 	else
 		seq_printf(s, "\n");
 
+out:
 	return 0;
 }
 
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -332,9 +332,14 @@ static void scsi_target_dev_release(stru
 	put_device(parent);
 }
 
+struct device_type scsi_target_type = {
+	.name =		"scsi_target",
+	.release =	scsi_target_dev_release,
+};
+
 int scsi_is_target_device(const struct device *dev)
 {
-	return dev->release == scsi_target_dev_release;
+	return dev->type == &scsi_target_type;
 }
 EXPORT_SYMBOL(scsi_is_target_device);
 
@@ -392,9 +397,12 @@ static struct scsi_target *scsi_alloc_ta
 	device_initialize(dev);
 	starget->reap_ref = 1;
 	dev->parent = get_device(parent);
-	dev->release = scsi_target_dev_release;
 	sprintf(dev->bus_id, "target%d:%d:%d",
 		shost->host_no, channel, id);
+#ifndef CONFIG_SYSFS_DEPRECATED
+	dev->bus = &scsi_bus_type;
+#endif
+	dev->type = &scsi_target_type;
 	starget->id = id;
 	starget->channel = channel;
 	INIT_LIST_HEAD(&starget->siblings);
@@ -468,8 +476,6 @@ static void scsi_target_reap_usercontext
 {
 	struct scsi_target *starget =
 		container_of(work, struct scsi_target, ew.work);
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	unsigned long flags;
 
 	transport_remove_device(&starget->dev);
 	device_del(&starget->dev);
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -21,6 +21,8 @@
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
+static struct device_type scsi_dev_type;
+
 static const struct {
 	enum scsi_device_state	value;
 	char			*name;
@@ -271,7 +273,12 @@ static struct class sdev_class = {
 /* all probing is done in the individual ->probe routines */
 static int scsi_bus_match(struct device *dev, struct device_driver *gendrv)
 {
-	struct scsi_device *sdp = to_scsi_device(dev);
+	struct scsi_device *sdp;
+
+	if (dev->type != &scsi_dev_type)
+		return 0;
+
+	sdp = to_scsi_device(dev);
 	if (sdp->no_uld_attach)
 		return 0;
 	return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;
@@ -287,10 +294,16 @@ static int scsi_bus_uevent(struct device
 
 static int scsi_bus_suspend(struct device * dev, pm_message_t state)
 {
-	struct device_driver *drv = dev->driver;
-	struct scsi_device *sdev = to_scsi_device(dev);
+	struct device_driver *drv;
+	struct scsi_device *sdev;
 	int err;
 
+	if (dev->type != &scsi_dev_type)
+		return 0;
+
+	drv = dev->driver;
+	sdev = to_scsi_device(dev);
+
 	err = scsi_device_quiesce(sdev);
 	if (err)
 		return err;
@@ -306,10 +319,16 @@ static int scsi_bus_suspend(struct devic
 
 static int scsi_bus_resume(struct device * dev)
 {
-	struct device_driver *drv = dev->driver;
-	struct scsi_device *sdev = to_scsi_device(dev);
+	struct device_driver *drv;
+	struct scsi_device *sdev;
 	int err = 0;
 
+	if (dev->type != &scsi_dev_type)
+		return 0;
+
+	drv = dev->driver;
+	sdev = to_scsi_device(dev);
+
 	if (drv && drv->resume)
 		err = drv->resume(dev);
 
