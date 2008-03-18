From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 1/8] add scsi_host and scsi_target to scsi_bus
Date: Tue, 18 Mar 2008 14:32:28 +0100
Message-ID: <20080318133228.49532159153@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbYCRNcd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Mar 2008 09:32:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


This patch implements scsi_host and scsi_target device types
and adds both to the scsi_bus.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/scsi/hosts.c      |   12 ++++++++++--
 drivers/scsi/scsi_proc.c  |    7 ++++++-
 drivers/scsi/scsi_scan.c  |   12 ++++++++++--
 drivers/scsi/scsi_sysfs.c |   29 ++++++++++++++++++++++++-----
 4 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8cfb70a..577e604 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -278,6 +278,11 @@ static void scsi_host_dev_release(struct device *dev)
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
@@ -378,7 +383,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	device_initialize(&shost->shost_gendev);
 	snprintf(shost->shost_gendev.bus_id, BUS_ID_SIZE, "host%d",
 		shost->host_no);
-	shost->shost_gendev.release = scsi_host_dev_release;
+#ifndef CONFIG_SYSFS_DEPRECATED
+	shost->shost_gendev.bus = &scsi_bus_type;
+#endif
+	shost->shost_gendev.type = &scsi_host_type;
 
 	device_initialize(&shost->shost_dev);
 	shost->shost_dev.parent = &shost->shost_gendev;
@@ -491,7 +499,7 @@ void scsi_exit_hosts(void)
 
 int scsi_is_host_device(const struct device *dev)
 {
-	return dev->release == scsi_host_dev_release;
+	return dev->type == &scsi_host_type;
 }
 EXPORT_SYMBOL(scsi_is_host_device);
 
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index ed39515..3a1c99d 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -190,10 +190,14 @@ void scsi_proc_host_rm(struct Scsi_Host *shost)
  */
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
@@ -230,6 +234,7 @@ static int proc_print_scsidevice(struct device *dev, void *data)
 	else
 		seq_printf(s, "\n");
 
+out:
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e67c14e..e1644b2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -331,9 +331,14 @@ static void scsi_target_dev_release(struct device *dev)
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
 
@@ -391,9 +396,12 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
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
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 4e1e7ad..15928f3 100644
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
@@ -336,7 +338,12 @@ static struct class sdev_class = {
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
@@ -352,10 +359,16 @@ static int scsi_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 
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
@@ -371,10 +384,16 @@ static int scsi_bus_suspend(struct device * dev, pm_message_t state)
 
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
 
-- 
1.5.2.4

