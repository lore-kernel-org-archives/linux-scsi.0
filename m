From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/9] scsi_dh: integrate into the core SCSI code
Date: Mon,  6 Jul 2015 16:15:00 +0200
Message-ID: <1436192105-44064-5-git-send-email-hare@suse.de>
References: <1436192105-44064-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbbGFOPJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2015 10:15:09 -0400
In-Reply-To: <1436192105-44064-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>

From: Christoph Hellwig <hch@lst.de>

Stop building scsi_dh as a separate module and integrate it fully into the
core SCSI code with explicit callouts at bus scan time.  For now the
callouts are placed at the same point as the old bus notifiers were called,
but in the future we will be able to look at ALUA INQUIRY data earlier on.

Note that this also means that the device handler modules need to be loaded
by the time we scan the bus.  The next patches will add support for
autoloading device handlers at bus scan time to make sure they are always
loaded if they are enabled in the kernel config.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/Makefile               |   2 +-
 drivers/scsi/device_handler/Kconfig |   2 +-
 drivers/scsi/scsi_dh.c              | 183 +++---------------------------------
 drivers/scsi/scsi_priv.h            |   9 ++
 drivers/scsi/scsi_sysfs.c           |  10 ++
 include/scsi/scsi_dh.h              |   2 +-
 6 files changed, 34 insertions(+), 174 deletions(-)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 22f54b0..ef260bb 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -171,7 +171,7 @@ scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
 scsi_mod-y			+= scsi_trace.o scsi_logging.o
 scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
-obj-$(CONFIG_SCSI_DH)		+= scsi_dh.o
+scsi_mod-$(CONFIG_SCSI_DH)	+= scsi_dh.o
 
 hv_storvsc-y			:= storvsc_drv.o
 
diff --git a/drivers/scsi/device_handler/Kconfig b/drivers/scsi/device_handler/Kconfig
index 69abd0a..e5647d5 100644
--- a/drivers/scsi/device_handler/Kconfig
+++ b/drivers/scsi/device_handler/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig SCSI_DH
-	tristate "SCSI Device Handlers"
+	bool "SCSI Device Handlers"
 	depends on SCSI
 	default n
 	help
diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 3c06c72..2d6a8bd 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -57,15 +57,8 @@ static struct scsi_device_handler *scsi_dh_lookup(const char *name)
 	return dh;
 }
 
-/*
- * device_handler_match_function - Match a device handler to a device
- * @sdev - SCSI device to be tested
- *
- * Tests @sdev against the match function of all registered device_handler.
- * Returns the found device handler or NULL if not found.
- */
 static struct scsi_device_handler *
-device_handler_match_function(struct scsi_device *sdev)
+device_handler_match(struct scsi_device *sdev)
 {
 	struct scsi_device_handler *tmp_dh, *found_dh = NULL;
 
@@ -81,29 +74,6 @@ device_handler_match_function(struct scsi_device *sdev)
 }
 
 /*
- * device_handler_match - Attach a device handler to a device
- * @scsi_dh - The device handler to match against or NULL
- * @sdev - SCSI device to be tested against @scsi_dh
- *
- * Tests @sdev against the device handler @scsi_dh or against
- * all registered device_handler if @scsi_dh == NULL.
- * Returns the found device handler or NULL if not found.
- */
-static struct scsi_device_handler *
-device_handler_match(struct scsi_device_handler *scsi_dh,
-		     struct scsi_device *sdev)
-{
-	struct scsi_device_handler *found_dh;
-
-	found_dh = device_handler_match_function(sdev);
-
-	if (scsi_dh && found_dh != scsi_dh)
-		found_dh = NULL;
-
-	return found_dh;
-}
-
-/*
  * scsi_dh_handler_attach - Attach a device handler to a device
  * @sdev - SCSI device the device handler should attach to
  * @scsi_dh - The device handler to attach
@@ -211,119 +181,26 @@ static struct device_attribute scsi_dh_state_attr =
 	__ATTR(dh_state, S_IRUGO | S_IWUSR, show_dh_state,
 	       store_dh_state);
 
-/*
- * scsi_dh_sysfs_attr_add - Callback for scsi_init_dh
- */
-static int scsi_dh_sysfs_attr_add(struct device *dev, void *data)
+int scsi_dh_add_device(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev;
+	struct scsi_device_handler *devinfo;
 	int err;
 
-	if (!scsi_is_sdev_device(dev))
-		return 0;
-
-	sdev = to_scsi_device(dev);
-
-	err = device_create_file(&sdev->sdev_gendev,
-				 &scsi_dh_state_attr);
-
-	return 0;
-}
-
-/*
- * scsi_dh_sysfs_attr_remove - Callback for scsi_exit_dh
- */
-static int scsi_dh_sysfs_attr_remove(struct device *dev, void *data)
-{
-	struct scsi_device *sdev;
-
-	if (!scsi_is_sdev_device(dev))
-		return 0;
-
-	sdev = to_scsi_device(dev);
-
-	device_remove_file(&sdev->sdev_gendev,
-			   &scsi_dh_state_attr);
-
-	return 0;
-}
+	err = device_create_file(&sdev->sdev_gendev, &scsi_dh_state_attr);
+	if (err)
+		return err;
 
-/*
- * scsi_dh_notifier - notifier chain callback
- */
-static int scsi_dh_notifier(struct notifier_block *nb,
-			    unsigned long action, void *data)
-{
-	struct device *dev = data;
-	struct scsi_device *sdev;
-	int err = 0;
-	struct scsi_device_handler *devinfo = NULL;
-
-	if (!scsi_is_sdev_device(dev))
-		return 0;
-
-	sdev = to_scsi_device(dev);
-
-	if (action == BUS_NOTIFY_ADD_DEVICE) {
-		err = device_create_file(dev, &scsi_dh_state_attr);
-		/* don't care about err */
-		devinfo = device_handler_match(NULL, sdev);
-		if (devinfo)
-			err = scsi_dh_handler_attach(sdev, devinfo);
-	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
-		device_remove_file(dev, &scsi_dh_state_attr);
-		if (sdev->scsi_dh_data)
-			scsi_dh_handler_detach(sdev);
-	}
+	devinfo = device_handler_match(sdev);
+	if (devinfo)
+		err = scsi_dh_handler_attach(sdev, devinfo);
 	return err;
 }
 
-/*
- * scsi_dh_notifier_add - Callback for scsi_register_device_handler
- */
-static int scsi_dh_notifier_add(struct device *dev, void *data)
+void scsi_dh_remove_device(struct scsi_device *sdev)
 {
-	struct scsi_device_handler *scsi_dh = data;
-	struct scsi_device *sdev;
-
-	if (!scsi_is_sdev_device(dev))
-		return 0;
-
-	if (!get_device(dev))
-		return 0;
-
-	sdev = to_scsi_device(dev);
-
-	if (device_handler_match(scsi_dh, sdev))
-		scsi_dh_handler_attach(sdev, scsi_dh);
-
-	put_device(dev);
-
-	return 0;
-}
-
-/*
- * scsi_dh_notifier_remove - Callback for scsi_unregister_device_handler
- */
-static int scsi_dh_notifier_remove(struct device *dev, void *data)
-{
-	struct scsi_device_handler *scsi_dh = data;
-	struct scsi_device *sdev;
-
-	if (!scsi_is_sdev_device(dev))
-		return 0;
-
-	if (!get_device(dev))
-		return 0;
-
-	sdev = to_scsi_device(dev);
-
-	if (sdev->scsi_dh_data && sdev->scsi_dh_data->scsi_dh == scsi_dh)
+	if (sdev->scsi_dh_data)
 		scsi_dh_handler_detach(sdev);
-
-	put_device(dev);
-
-	return 0;
+	device_remove_file(&sdev->sdev_gendev, &scsi_dh_state_attr);
 }
 
 /*
@@ -345,7 +222,6 @@ int scsi_register_device_handler(struct scsi_device_handler *scsi_dh)
 	list_add(&scsi_dh->list, &scsi_dh_list);
 	spin_unlock(&list_lock);
 
-	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh, scsi_dh_notifier_add);
 	printk(KERN_INFO "%s: device handler registered\n", scsi_dh->name);
 
 	return SCSI_DH_OK;
@@ -361,13 +237,9 @@ EXPORT_SYMBOL_GPL(scsi_register_device_handler);
  */
 int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh)
 {
-
 	if (!__scsi_dh_lookup(scsi_dh->name))
 		return -ENODEV;
 
-	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh,
-			 scsi_dh_notifier_remove);
-
 	spin_lock(&list_lock);
 	list_del(&scsi_dh->list);
 	spin_unlock(&list_lock);
@@ -537,34 +409,3 @@ const char *scsi_dh_attached_handler_name(struct request_queue *q, gfp_t gfp)
 	return handler_name;
 }
 EXPORT_SYMBOL_GPL(scsi_dh_attached_handler_name);
-
-static struct notifier_block scsi_dh_nb = {
-	.notifier_call = scsi_dh_notifier
-};
-
-static int __init scsi_dh_init(void)
-{
-	int r;
-
-	r = bus_register_notifier(&scsi_bus_type, &scsi_dh_nb);
-
-	if (!r)
-		bus_for_each_dev(&scsi_bus_type, NULL, NULL,
-				 scsi_dh_sysfs_attr_add);
-
-	return r;
-}
-
-static void __exit scsi_dh_exit(void)
-{
-	bus_for_each_dev(&scsi_bus_type, NULL, NULL,
-			 scsi_dh_sysfs_attr_remove);
-	bus_unregister_notifier(&scsi_bus_type, &scsi_dh_nb);
-}
-
-module_init(scsi_dh_init);
-module_exit(scsi_dh_exit);
-
-MODULE_DESCRIPTION("SCSI device handler");
-MODULE_AUTHOR("Chandra Seetharaman <sekharan@us.ibm.com>");
-MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index e3902fc..644bb73 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -170,6 +170,15 @@ static inline void scsi_autopm_put_host(struct Scsi_Host *h) {}
 extern struct async_domain scsi_sd_pm_domain;
 extern struct async_domain scsi_sd_probe_domain;
 
+/* scsi_dh.c */
+#ifdef CONFIG_SCSI_DH
+int scsi_dh_add_device(struct scsi_device *sdev);
+void scsi_dh_remove_device(struct scsi_device *sdev);
+#else
+static inline int scsi_dh_add_device(struct scsi_device *sdev) { return 0; }
+static inline void scsi_dh_remove_device(struct scsi_device *sdev) { }
+#endif
+
 /* 
  * internal scsi timeout functions: for use by mid-layer and transport
  * classes.
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 1ac38e7..c8a120f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1030,11 +1030,20 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 				"failed to add device: %d\n", error);
 		return error;
 	}
+
+	error = scsi_dh_add_device(sdev);
+	if (error) {
+		sdev_printk(KERN_INFO, sdev,
+				"failed to add device handler: %d\n", error);
+		return error;
+	}
+
 	device_enable_async_suspend(&sdev->sdev_dev);
 	error = device_add(&sdev->sdev_dev);
 	if (error) {
 		sdev_printk(KERN_INFO, sdev,
 				"failed to add class device: %d\n", error);
+		scsi_dh_remove_device(sdev);
 		device_del(&sdev->sdev_gendev);
 		return error;
 	}
@@ -1074,6 +1083,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		bsg_unregister_queue(sdev->request_queue);
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
+		scsi_dh_remove_device(sdev);
 		device_del(dev);
 	} else
 		put_device(&sdev->sdev_dev);
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index 966b921..3a37b4c45 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -55,7 +55,7 @@ enum {
 	SCSI_DH_NOSYS,
 	SCSI_DH_DRIVER_MAX,
 };
-#if defined(CONFIG_SCSI_DH) || defined(CONFIG_SCSI_DH_MODULE)
+#ifdef CONFIG_SCSI_DH
 extern int scsi_dh_activate(struct request_queue *, activate_complete, void *);
 extern int scsi_dh_attach(struct request_queue *, const char *);
 extern const char *scsi_dh_attached_handler_name(struct request_queue *, gfp_t);
-- 
1.8.5.2

