From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 1/3] SCSI: convert to the new PM framework
Date: Wed, 16 Jun 2010 14:51:19 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1006161155590.1587-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60322 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752409Ab0FPSvU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2010 14:51:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1397) converts the SCSI midlayer to use the new PM
callbacks (struct dev_pm_ops).  A new source file, scsi_pm.c, is
created to hold the new callback routines, and the existing
suspend/resume code is moved there.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/Makefile
===================================================================
--- usb-2.6.orig/drivers/scsi/Makefile
+++ usb-2.6/drivers/scsi/Makefile
@@ -158,7 +158,8 @@ obj-$(CONFIG_SCSI_WAIT_SCAN)	+= scsi_wai
 scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
 				   scsicam.o scsi_error.o scsi_lib.o
 scsi_mod-$(CONFIG_SCSI_DMA)	+= scsi_lib_dma.o
-scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
+scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o \
+				   scsi_pm.o
 scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
Index: usb-2.6/drivers/scsi/scsi_priv.h
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_priv.h
+++ usb-2.6/drivers/scsi/scsi_priv.h
@@ -144,6 +144,13 @@ static inline void scsi_netlink_init(voi
 static inline void scsi_netlink_exit(void) {}
 #endif
 
+/* scsi_pm.c */
+#ifdef CONFIG_PM_OPS
+extern struct dev_pm_ops scsi_bus_pm_ops;
+#else
+#define scsi_bus_pm_ops		(*(struct dev_pm_ops *) NULL)
+#endif
+
 /* 
  * internal scsi timeout functions: for use by mid-layer and transport
  * classes.
Index: usb-2.6/drivers/scsi/scsi_pm.c
===================================================================
--- /dev/null
+++ usb-2.6/drivers/scsi/scsi_pm.c
@@ -0,0 +1,100 @@
+/*
+ *	scsi_pm.c	Copyright (C) 2010 Alan Stern
+ *
+ *	SCSI dynamic Power Management
+ *		Initial version: Alan Stern <stern@rowland.harvard.edu>
+ */
+
+#include <linux/pm_runtime.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_host.h>
+
+#include "scsi_priv.h"
+
+#ifdef CONFIG_PM_OPS
+
+static int scsi_dev_type_suspend(struct device *dev, pm_message_t msg)
+{
+	struct device_driver *drv;
+	int err;
+
+	err = scsi_device_quiesce(to_scsi_device(dev));
+	if (err == 0) {
+		drv = dev->driver;
+		if (drv && drv->suspend)
+			err = drv->suspend(dev, msg);
+	}
+	dev_dbg(dev, "scsi suspend: %d\n", err);
+	return err;
+}
+
+static int scsi_dev_type_resume(struct device *dev)
+{
+	struct device_driver *drv;
+	int err = 0;
+
+	drv = dev->driver;
+	if (drv && drv->resume)
+		err = drv->resume(dev);
+	scsi_device_resume(to_scsi_device(dev));
+	dev_dbg(dev, "scsi resume: %d\n", err);
+	return err;
+}
+
+#ifdef CONFIG_PM_SLEEP
+
+static int scsi_bus_suspend_common(struct device *dev, pm_message_t msg)
+{
+	int err = 0;
+
+	if (scsi_is_sdev_device(dev))
+		err = scsi_dev_type_suspend(dev, msg);
+	return err;
+}
+
+static int scsi_bus_resume_common(struct device *dev)
+{
+	int err = 0;
+
+	if (scsi_is_sdev_device(dev))
+		err = scsi_dev_type_resume(dev);
+	return err;
+}
+
+static int scsi_bus_suspend(struct device *dev)
+{
+	return scsi_bus_suspend_common(dev, PMSG_SUSPEND);
+}
+
+static int scsi_bus_freeze(struct device *dev)
+{
+	return scsi_bus_suspend_common(dev, PMSG_FREEZE);
+}
+
+static int scsi_bus_poweroff(struct device *dev)
+{
+	return scsi_bus_suspend_common(dev, PMSG_HIBERNATE);
+}
+
+#else /* CONFIG_PM_SLEEP */
+
+#define scsi_bus_resume_common		NULL
+#define scsi_bus_suspend		NULL
+#define scsi_bus_freeze			NULL
+#define scsi_bus_poweroff		NULL
+
+#endif /* CONFIG_PM_SLEEP */
+
+struct dev_pm_ops scsi_bus_pm_ops = {
+	.suspend =		scsi_bus_suspend,
+	.resume =		scsi_bus_resume_common,
+	.freeze =		scsi_bus_freeze,
+	.thaw =			scsi_bus_resume_common,
+	.poweroff =		scsi_bus_poweroff,
+	.restore =		scsi_bus_resume_common,
+};
+
+#endif /* CONFIG_PM_OPS */
Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -377,57 +377,11 @@ static int scsi_bus_uevent(struct device
 	return 0;
 }
 
-static int scsi_bus_suspend(struct device * dev, pm_message_t state)
-{
-	struct device_driver *drv;
-	struct scsi_device *sdev;
-	int err;
-
-	if (dev->type != &scsi_dev_type)
-		return 0;
-
-	drv = dev->driver;
-	sdev = to_scsi_device(dev);
-
-	err = scsi_device_quiesce(sdev);
-	if (err)
-		return err;
-
-	if (drv && drv->suspend) {
-		err = drv->suspend(dev, state);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
-static int scsi_bus_resume(struct device * dev)
-{
-	struct device_driver *drv;
-	struct scsi_device *sdev;
-	int err = 0;
-
-	if (dev->type != &scsi_dev_type)
-		return 0;
-
-	drv = dev->driver;
-	sdev = to_scsi_device(dev);
-
-	if (drv && drv->resume)
-		err = drv->resume(dev);
-
-	scsi_device_resume(sdev);
-
-	return err;
-}
-
 struct bus_type scsi_bus_type = {
         .name		= "scsi",
         .match		= scsi_bus_match,
 	.uevent		= scsi_bus_uevent,
-	.suspend	= scsi_bus_suspend,
-	.resume		= scsi_bus_resume,
+	.pm		= &scsi_bus_pm_ops,
 };
 EXPORT_SYMBOL_GPL(scsi_bus_type);
 

