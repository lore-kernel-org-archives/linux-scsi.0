From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] convert the mid layer and the three transport classes to
	the generic one
Date: Tue, 11 Jan 2005 23:22:06 -0600
Message-ID: <1105507326.13912.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:15540 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261245AbVALFWF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2005 00:22:05 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j0C5LxH13622
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2005 00:21:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This basically removes our SCSI specific transport class mechanism and
makes use of the generic one instead.  The functionality all remains the
same.

James

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/01/11 16:26:32-06:00 jejb@titanic.il.steeleye.com 
#   move the SCSI transport classes over to the generic transport class
#   
#   This converts the three transport classes (SPI, FC and iSCSI) over to
#   the generic transport class code.
#   
#   It also converts the internals of the SCSI mid-layer to use generic
#   transport class trigger points and pulls out some of the duplicated code.
#   
#   Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
# 
# include/scsi/scsi_transport_spi.h
#   2005/01/11 16:26:19-06:00 jejb@titanic.il.steeleye.com +1 -0
#   move the SCSI transport classes over to the generic transport class
# 
# include/scsi/scsi_transport.h
#   2005/01/11 16:26:19-06:00 jejb@titanic.il.steeleye.com +11 -22
#   move the SCSI transport classes over to the generic transport class
# 
# include/scsi/scsi_host.h
#   2005/01/11 16:26:19-06:00 jejb@titanic.il.steeleye.com +3 -3
#   move the SCSI transport classes over to the generic transport class
# 
# include/scsi/scsi_device.h
#   2005/01/11 16:26:19-06:00 jejb@titanic.il.steeleye.com +4 -5
#   move the SCSI transport classes over to the generic transport class
# 
# drivers/scsi/scsi_transport_spi.c
#   2005/01/11 16:26:19-06:00 jejb@titanic.il.steeleye.com +92 -47
#   move the SCSI transport classes over to the generic transport class
# 
# drivers/scsi/scsi_transport_iscsi.c
#   2005/01/11 16:26:19-06:00 jejb@titanic.il.steeleye.com +53 -32
#   move the SCSI transport classes over to the generic transport class
# 
# drivers/scsi/scsi_transport_fc.c
#   2005/01/11 16:26:19-06:00 jejb@titanic.il.steeleye.com +67 -45
#   move the SCSI transport classes over to the generic transport class
# 
# drivers/scsi/scsi_sysfs.c
#   2005/01/11 16:26:19-06:00 jejb@titanic.il.steeleye.com +25 -106
#   move the SCSI transport classes over to the generic transport class
# 
# drivers/scsi/scsi_scan.c
#   2005/01/11 16:26:19-06:00 jejb@titanic.il.steeleye.com +6 -18
#   move the SCSI transport classes over to the generic transport class
# 
# drivers/scsi/scsi_priv.h
#   2005/01/11 16:26:19-06:00 jejb@titanic.il.steeleye.com +1 -1
#   move the SCSI transport classes over to the generic transport class
# 
# drivers/scsi/hosts.c
#   2005/01/11 16:26:19-06:00 jejb@titanic.il.steeleye.com +8 -13
#   move the SCSI transport classes over to the generic transport class
# 
diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	2005-01-11 23:17:31 -06:00
+++ b/drivers/scsi/hosts.c	2005-01-11 23:17:31 -06:00
@@ -28,6 +28,7 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/completion.h>
+#include <linux/transport_class.h>
 
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
@@ -79,15 +80,8 @@
 
 	set_bit(SHOST_DEL, &shost->shost_state);
 
-	if (shost->transportt->host_destroy)
-		shost->transportt->host_destroy(shost);
+	transport_unregister_device(&shost->shost_gendev);
 	class_device_unregister(&shost->shost_classdev);
-	if (shost->transport_classdev.class) {
-		if (shost->transportt->host_statistics)
-			sysfs_remove_group(&shost->transport_classdev.kobj,
-				shost->transportt->host_statistics);
- 		class_device_unregister(&shost->transport_classdev);
-	}
 	device_del(&shost->shost_gendev);
 }
 EXPORT_SYMBOL(scsi_remove_host);
@@ -135,9 +129,6 @@
 					 GFP_KERNEL)) == NULL)
 		goto out_del_classdev;
 
-	if (shost->transportt->host_setup)
-		shost->transportt->host_setup(shost);
-
 	error = scsi_sysfs_add_host(shost);
 	if (error)
 		goto out_destroy_host;
@@ -146,8 +137,6 @@
 	return error;
 
  out_destroy_host:
-	if (shost->transportt->host_destroy)
-		shost->transportt->host_destroy(shost);
  out_del_classdev:
 	class_device_del(&shost->shost_classdev);
  out_del_gendev:
@@ -397,3 +386,9 @@
 {
 	class_unregister(&shost_class);
 }
+
+int scsi_is_host_device(const struct device *dev)
+{
+	return dev->release == scsi_host_dev_release;
+}
+EXPORT_SYMBOL(scsi_is_host_device);
diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	2005-01-11 23:17:31 -06:00
+++ b/drivers/scsi/scsi_priv.h	2005-01-11 23:17:31 -06:00
@@ -146,7 +146,7 @@
 extern int scsi_sysfs_add_host(struct Scsi_Host *);
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
-extern int scsi_sysfs_device_initialize(struct scsi_device *);
+extern void scsi_sysfs_device_initialize(struct scsi_device *);
 extern int scsi_sysfs_target_initialize(struct scsi_device *);
 extern struct scsi_transport_template blank_transport_template;
 
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	2005-01-11 23:17:31 -06:00
+++ b/drivers/scsi/scsi_scan.c	2005-01-11 23:17:31 -06:00
@@ -254,10 +254,7 @@
 	sdev->request_queue->queuedata = sdev;
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 
-	if (shost->transportt->device_setup) {
-		if (shost->transportt->device_setup(sdev))
-			goto out_free_queue;
-	}
+	scsi_sysfs_device_initialize(sdev);
 
 	if (shost->hostt->slave_alloc) {
 		ret = shost->hostt->slave_alloc(sdev);
@@ -272,10 +269,6 @@
 		}
 	}
 
-	if (scsi_sysfs_device_initialize(sdev) != 0)
-		goto out_cleanup_slave;
-
-
 	/* NOTE: this target initialisation code depends critically on
 	 * lun scanning being sequential. */
 	if (scsi_sysfs_target_initialize(sdev))
@@ -288,13 +281,11 @@
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
 	spin_unlock_irqrestore(shost->host_lock, flags);
-out_cleanup_slave:
+
 	if (shost->hostt->slave_destroy)
 		shost->hostt->slave_destroy(sdev);
 out_device_destroy:
-	if (shost->transportt->device_destroy)
-		shost->transportt->device_destroy(sdev);
-out_free_queue:
+	transport_destroy_device(&sdev->sdev_gendev);
 	scsi_free_queue(sdev->request_queue);
 out_free_dev:
 	kfree(sdev);
@@ -629,8 +620,7 @@
 	if (*bflags & BLIST_NOT_LOCKABLE)
 		sdev->lockable = 0;
 
-	if (sdev->host->transportt->device_configure)
-		sdev->host->transportt->device_configure(sdev);
+	transport_configure_device(&sdev->sdev_gendev);
 
 	if (sdev->host->hostt->slave_configure)
 		sdev->host->hostt->slave_configure(sdev);
@@ -749,8 +739,7 @@
 	} else {
 		if (sdev->host->hostt->slave_destroy)
 			sdev->host->hostt->slave_destroy(sdev);
-		if (sdev->host->transportt->device_destroy)
-			sdev->host->transportt->device_destroy(sdev);
+		transport_destroy_device(&sdev->sdev_gendev);
 		put_device(&sdev->sdev_gendev);
 	}
  out:
@@ -1330,8 +1319,7 @@
 
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
-	if (sdev->host->transportt->device_destroy)
-		sdev->host->transportt->device_destroy(sdev);
+	transport_destroy_device(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_gendev);
 }
 EXPORT_SYMBOL(scsi_free_host_dev);
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	2005-01-11 23:17:31 -06:00
+++ b/drivers/scsi/scsi_sysfs.c	2005-01-11 23:17:31 -06:00
@@ -170,14 +170,12 @@
 
 	if (delete) {
 		struct scsi_target *starget = to_scsi_target(parent);
-		struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 		if (!starget->create) {
-			if (shost->transportt->target_destroy)
-				shost->transportt->target_destroy(starget);
+			transport_remove_device(&starget->dev);
 			device_del(parent);
-			if (starget->transport_classdev.class)
-				class_device_unregister(&starget->transport_classdev);
 		}
+		transport_destroy_device(&starget->dev);
+
 		put_device(parent);
 	}
 	if (sdev->request_queue)
@@ -553,7 +551,6 @@
  **/
 int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 {
-	struct class_device_attribute **attrs;
 	struct scsi_target *starget = sdev->sdev_target;
 	struct Scsi_Host *shost = sdev->host;
 	int error, i, create;
@@ -570,31 +567,7 @@
 			printk(KERN_ERR "Target device_add failed\n");
 			return error;
 		}
-		if (starget->transport_classdev.class) {
-			int i;
-			struct class_device_attribute **attrs =
-				sdev->host->transportt->target_attrs;
-
-			error = class_device_add(&starget->transport_classdev);
-			if (error) {
-				dev_printk(KERN_ERR, &starget->dev,
-					   "Target transport add failed\n");
-				return error;
-			}
-
-			/* take a reference for the transport_classdev; this
-			 * is released by the transport_class .release */
-			get_device(&starget->dev);
-			for (i = 0; attrs[i]; i++) {
-				error = class_device_create_file(&starget->transport_classdev,
-								 attrs[i]);
-				if (error) {
-					dev_printk(KERN_ERR, &starget->dev,
-						   "Target transport attr add failed\n");
-					return error;
-				}
-			}
-		}
+		transport_add_device(&starget->dev);
 	}
 
 	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
@@ -606,25 +579,15 @@
 		printk(KERN_INFO "error 1\n");
 		return error;
 	}
-
 	error = class_device_add(&sdev->sdev_classdev);
 	if (error) {
 		printk(KERN_INFO "error 2\n");
 		goto clean_device;
 	}
+
 	/* take a reference for the sdev_classdev; this is
 	 * released by the sdev_class .release */
 	get_device(&sdev->sdev_gendev);
-	if (sdev->transport_classdev.class) {
-		error = class_device_add(&sdev->transport_classdev);
-		if (error)
-			goto clean_device2;
-		/* take a reference for the transport_classdev; this
-		 * is released by the transport_class .release */
-		get_device(&sdev->sdev_gendev);
-		
-	}
-
 	if (sdev->host->hostt->sdev_attrs) {
 		for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
 			error = attr_add(&sdev->sdev_gendev,
@@ -650,27 +613,16 @@
 		}
 	}
 
- 	if (sdev->transport_classdev.class) {
- 		attrs = sdev->host->transportt->device_attrs;
- 		for (i = 0; attrs[i]; i++) {
- 			error = class_device_create_file(&sdev->transport_classdev,
- 							 attrs[i]);
- 			if (error) {
- 				scsi_remove_device(sdev);
-				goto out;
-			}
- 		}
- 	}
-
+	transport_add_device(&sdev->sdev_gendev);
  out:
 	return error;
 
- clean_device2:
 	class_device_del(&sdev->sdev_classdev);
  clean_device:
 	scsi_device_set_state(sdev, SDEV_CANCEL);
 
 	device_del(&sdev->sdev_gendev);
+	transport_destroy_device(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_gendev);
 
 	return error;
@@ -689,14 +641,11 @@
 		goto out;
 
 	class_device_unregister(&sdev->sdev_classdev);
-	if (sdev->transport_classdev.class)
-		class_device_unregister(&sdev->transport_classdev);
 	device_del(&sdev->sdev_gendev);
 	scsi_device_set_state(sdev, SDEV_DEL);
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
-	if (sdev->host->transportt->device_destroy)
-		sdev->host->transportt->device_destroy(sdev);
+	transport_unregister_device(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_gendev);
 
 out:
@@ -786,41 +735,11 @@
 		}
 	}
 
-	class_device_initialize(&shost->transport_classdev);
-	shost->transport_classdev.class = shost->transportt->host_class;
-	shost->transport_classdev.dev = &shost->shost_gendev;
-	snprintf(shost->transport_classdev.class_id, BUS_ID_SIZE,
-		 "host%d", shost->host_no);
-
-	if (shost->transport_classdev.class) {
-		struct class_device_attribute **attrs =
-			shost->transportt->host_attrs;
-		error = class_device_add(&shost->transport_classdev);
-		if (error)
-			return error;
-		/* take a reference for the transport_classdev; this
-		 * is released by the transport_class .release */
-		get_device(&shost->shost_gendev);
-		for (i = 0; attrs[i]; i++) {
- 			error = class_device_create_file(&shost->transport_classdev,
- 							 attrs[i]);
- 			if (error)
-				return error;
- 		}
-
-		if (shost->transportt->host_statistics) {
-			error = sysfs_create_group(
-					&shost->transport_classdev.kobj,
-					shost->transportt->host_statistics);
-			if (error)
-				return error;
-		}
- 	}
-
+	transport_register_device(&shost->shost_gendev);
 	return 0;
 }
 
-int scsi_sysfs_device_initialize(struct scsi_device *sdev)
+void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 {
 	device_initialize(&sdev->sdev_gendev);
 	sdev->sdev_gendev.bus = &scsi_bus_type;
@@ -836,14 +755,14 @@
 		 "%d:%d:%d:%d", sdev->host->host_no,
 		 sdev->channel, sdev->id, sdev->lun);
 
-	class_device_initialize(&sdev->transport_classdev);
-	sdev->transport_classdev.dev = &sdev->sdev_gendev;
-	sdev->transport_classdev.class = sdev->host->transportt->device_class;
-	snprintf(sdev->transport_classdev.class_id, BUS_ID_SIZE,
-		 "%d:%d:%d:%d", sdev->host->host_no,
-		 sdev->channel, sdev->id, sdev->lun);
-	return 0;
+	transport_setup_device(&sdev->sdev_gendev);
+}
+
+int scsi_is_sdev_device(const struct device *dev)
+{
+	return dev->release == scsi_device_dev_release;
 }
+EXPORT_SYMBOL(scsi_is_sdev_device);
 
 int scsi_sysfs_target_initialize(struct scsi_device *sdev)
 {
@@ -886,12 +805,6 @@
 		dev->release = scsi_target_dev_release;
 		sprintf(dev->bus_id, "target%d:%d:%d",
 			shost->host_no, sdev->channel, sdev->id);
-		class_device_initialize(&starget->transport_classdev);
-		starget->transport_classdev.dev = &starget->dev;
-		starget->transport_classdev.class = shost->transportt->target_class;
-		snprintf(starget->transport_classdev.class_id, BUS_ID_SIZE,
-			 "target%d:%d:%d",
-			 shost->host_no, sdev->channel, sdev->id);
 		starget->id = sdev->id;
 		starget->channel = sdev->channel;
 		create = starget->create = 1;
@@ -907,10 +820,16 @@
 	sdev->sdev_target = starget;
 	list_add_tail(&sdev->siblings, &shost->__devices);
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	if (create && shost->transportt->target_setup)
-		shost->transportt->target_setup(starget);
+	if (create)
+		transport_setup_device(&starget->dev);
 	return 0;
 }
+
+int scsi_is_target_device(const struct device *dev)
+{
+	return dev->release == scsi_target_dev_release;
+}
+EXPORT_SYMBOL(scsi_is_target_device);
 
 /* A blank transport template that is used in drivers that don't
  * yet implement Transport Attributes */
diff -Nru a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2005-01-11 23:17:31 -06:00
+++ b/drivers/scsi/scsi_transport_fc.c	2005-01-11 23:17:31 -06:00
@@ -180,8 +180,6 @@
 
 
 
-static void transport_class_release(struct class_device *class_dev);
-static void host_class_release(struct class_device *class_dev);
 static void fc_timeout_blocked_host(void *data);
 static void fc_timeout_blocked_tgt(void *data);
 
@@ -207,32 +205,9 @@
 
 #define to_fc_internal(tmpl)	container_of(tmpl, struct fc_internal, t)
 
-struct class fc_transport_class = {
-	.name = "fc_transport",
-	.release = transport_class_release,
-};
-
-struct class fc_host_class = {
-	.name = "fc_host",
-	.release = host_class_release,
-};
-
-static __init int fc_transport_init(void)
-{
-	int error = class_register(&fc_host_class);
-	if (error)
-		return error;
-	return class_register(&fc_transport_class);
-}
-
-static void __exit fc_transport_exit(void)
-{
-	class_unregister(&fc_transport_class);
-	class_unregister(&fc_host_class);
-}
-
-static int fc_setup_starget_transport_attrs(struct scsi_target *starget)
+static int fc_add_target(struct device *dev)
 {
+	struct scsi_target *starget = to_scsi_target(dev);
 	/* 
 	 * Set default values easily detected by the midlayer as
 	 * failure cases.  The scsi lldd is responsible for initializing
@@ -247,15 +222,24 @@
 	return 0;
 }
 
-static void fc_destroy_starget(struct scsi_target *starget)
+static int fc_remove_target(struct device *dev)
 {
+	struct scsi_target *starget = to_scsi_target(dev);
 	/* Stop the target timer */
 	if (cancel_delayed_work(&fc_starget_dev_loss_work(starget)))
 		flush_scheduled_work();
+	return 0;
 }
 
-static int fc_setup_host_transport_attrs(struct Scsi_Host *shost)
+static DECLARE_TRANSPORT_CLASS(fc_transport_class,
+			       "fc_transport",
+			       fc_add_target,
+			       fc_remove_target,
+			       NULL);
+
+static int fc_add_host(struct device *dev)
 {
+	struct Scsi_Host *shost = dev_to_shost(dev);
 	/* 
 	 * Set default values easily detected by the midlayer as
 	 * failure cases.  The scsi lldd is responsible for initializing
@@ -287,26 +271,35 @@
 	return 0;
 }
 
-static void fc_destroy_host(struct Scsi_Host *shost)
+static int fc_remove_host(struct device *dev)
 {
+	struct Scsi_Host *shost = dev_to_shost(dev);
 	/* Stop the host timer */
 	if (cancel_delayed_work(&fc_host_link_down_work(shost)))
 		flush_scheduled_work();
+	return 0;
 }
 
-static void transport_class_release(struct class_device *class_dev)
+static DECLARE_TRANSPORT_CLASS(fc_host_class,
+			       "fc_host",
+			       fc_add_host,
+			       fc_remove_host,
+			       NULL);
+
+static __init int fc_transport_init(void)
 {
-	struct scsi_target *starget = transport_class_to_starget(class_dev);
-	put_device(&starget->dev);
+	int error = transport_class_register(&fc_host_class);
+	if (error)
+		return error;
+	return transport_class_register(&fc_transport_class);
 }
 
-static void host_class_release(struct class_device *class_dev)
+static void __exit fc_transport_exit(void)
 {
-	struct Scsi_Host *shost = transport_class_to_shost(class_dev);
-	put_device(&shost->shost_gendev);
+	transport_class_unregister(&fc_transport_class);
+	transport_class_unregister(&fc_host_class);
 }
 
-
 /*
  * Remote Port (Target) Attribute Management
  */
@@ -716,6 +709,35 @@
 	.attrs = fc_statistics_attrs,
 };
 
+static int fc_host_match(struct attribute_container *cont,
+			  struct device *dev)
+{
+	struct Scsi_Host *shost;
+
+	if (!scsi_is_host_device(dev))
+		return 0;
+
+	shost = dev_to_shost(dev);
+	if (!shost->transportt  || shost->transportt->host_attrs.class
+	    != &fc_host_class.class)
+		return 0;
+	return 1;
+}
+
+static int fc_target_match(struct attribute_container *cont,
+			    struct device *dev)
+{
+	struct Scsi_Host *shost;
+
+	if (!scsi_is_target_device(dev))
+		return 0;
+
+	shost = dev_to_shost(dev->parent);
+	if (!shost->transportt  || shost->transportt->host_attrs.class
+	    != &fc_host_class.class)
+		return 0;
+	return 1;
+}
 
 
 struct scsi_transport_template *
@@ -730,16 +752,16 @@
 
 	memset(i, 0, sizeof(struct fc_internal));
 
-	i->t.target_attrs = &i->starget_attrs[0];
-	i->t.target_class = &fc_transport_class;
-	i->t.target_setup = &fc_setup_starget_transport_attrs;
-	i->t.target_destroy = &fc_destroy_starget;
+	i->t.target_attrs.attrs = &i->starget_attrs[0];
+	i->t.target_attrs.class = &fc_transport_class.class;
+	i->t.target_attrs.match = fc_target_match;
+	attribute_container_register(&i->t.target_attrs);
 	i->t.target_size = sizeof(struct fc_starget_attrs);
 
-	i->t.host_attrs = &i->host_attrs[0];
-	i->t.host_class = &fc_host_class;
-	i->t.host_setup = &fc_setup_host_transport_attrs;
-	i->t.host_destroy = &fc_destroy_host;
+	i->t.host_attrs.attrs = &i->host_attrs[0];
+	i->t.host_attrs.class = &fc_host_class.class;
+	i->t.host_attrs.match = fc_host_match;
+	attribute_container_register(&i->t.host_attrs);
 	i->t.host_size = sizeof(struct fc_host_attrs);
 
 	if (ft->get_fc_host_stats)
diff -Nru a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
--- a/drivers/scsi/scsi_transport_iscsi.c	2005-01-11 23:17:31 -06:00
+++ b/drivers/scsi/scsi_transport_iscsi.c	2005-01-11 23:17:31 -06:00
@@ -40,28 +40,17 @@
 
 #define to_iscsi_internal(tmpl) container_of(tmpl, struct iscsi_internal, t)
 
-static void iscsi_transport_class_release(struct class_device *class_dev)
-{
-	struct scsi_target *starget = transport_class_to_starget(class_dev);
-	put_device(&starget->dev);
-}
-
-struct class iscsi_transport_class = {
-	.name = "iscsi_transport_class",
-	.release = iscsi_transport_class_release,
-};
-
-static void iscsi_host_class_release(struct class_device *class_dev)
-{
-	struct Scsi_Host *shost = transport_class_to_shost(class_dev);
-	put_device(&shost->shost_gendev);
-}
-
-struct class iscsi_host_class = {
-	.name = "iscsi_host",
-	.release = iscsi_host_class_release,
-};
-
+static DECLARE_TRANSPORT_CLASS(iscsi_transport_class,
+			       "iscsi_transport",
+			       NULL,
+			       NULL,
+			       NULL);
+
+static DECLARE_TRANSPORT_CLASS(iscsi_host_class,
+			       "iscsi_host",
+			       NULL,
+			       NULL,
+			       NULL);
 /*
  * iSCSI target and session attrs
  */
@@ -265,6 +254,36 @@
 		count++;						\
 	}
 
+static int iscsi_host_match(struct attribute_container *cont,
+			  struct device *dev)
+{
+	struct Scsi_Host *shost;
+
+	if (!scsi_is_host_device(dev))
+		return 0;
+
+	shost = dev_to_shost(dev);
+	if (!shost->transportt  || shost->transportt->host_attrs.class
+	    != &iscsi_host_class.class)
+		return 0;
+	return 1;
+}
+
+static int iscsi_target_match(struct attribute_container *cont,
+			    struct device *dev)
+{
+	struct Scsi_Host *shost;
+
+	if (!scsi_is_target_device(dev))
+		return 0;
+
+	shost = dev_to_shost(dev->parent);
+	if (!shost->transportt  || shost->transportt->host_attrs.class
+	    != &iscsi_host_class.class)
+		return 0;
+	return 1;
+}
+
 struct scsi_transport_template *
 iscsi_attach_transport(struct iscsi_function_template *fnt)
 {
@@ -278,9 +297,10 @@
 	memset(i, 0, sizeof(struct iscsi_internal));
 	i->fnt = fnt;
 
-	i->t.target_attrs = &i->session_attrs[0];
-	i->t.target_class = &iscsi_transport_class;
-	i->t.target_setup = NULL;
+	i->t.target_attrs.attrs = &i->session_attrs[0];
+	i->t.target_attrs.class = &iscsi_transport_class.class;
+	i->t.target_attrs.match = iscsi_target_match;
+	attribute_container_register(&i->t.target_attrs);
 	i->t.target_size = sizeof(struct iscsi_class_session);
 
 	SETUP_SESSION_RD_ATTR(tsih);
@@ -307,9 +327,10 @@
 	BUG_ON(count > ISCSI_SESSION_ATTRS);
 	i->session_attrs[count] = NULL;
 
-	i->t.host_attrs = &i->host_attrs[0];
-	i->t.host_class = &iscsi_host_class;
-	i->t.host_setup = NULL;
+	i->t.host_attrs.attrs = &i->host_attrs[0];
+	i->t.host_attrs.class = &iscsi_host_class.class;
+	i->t.host_attrs.match = iscsi_host_match;
+	attribute_container_register(&i->t.host_attrs);
 	i->t.host_size = 0;
 
 	count = 0;
@@ -334,17 +355,17 @@
 
 static __init int iscsi_transport_init(void)
 {
-	int err = class_register(&iscsi_transport_class);
+	int err = transport_class_register(&iscsi_transport_class);
 
 	if (err)
 		return err;
-	return class_register(&iscsi_host_class);
+	return transport_class_register(&iscsi_host_class);
 }
 
 static void __exit iscsi_transport_exit(void)
 {
-	class_unregister(&iscsi_host_class);
-	class_unregister(&iscsi_transport_class);
+	transport_class_unregister(&iscsi_host_class);
+	transport_class_unregister(&iscsi_transport_class);
 }
 
 module_init(iscsi_transport_init);
diff -Nru a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
--- a/drivers/scsi/scsi_transport_spi.c	2005-01-11 23:17:31 -06:00
+++ b/drivers/scsi/scsi_transport_spi.c	2005-01-11 23:17:31 -06:00
@@ -2,6 +2,7 @@
  *  Parallel SCSI (SPI) transport specific attributes exported to sysfs.
  *
  *  Copyright (c) 2003 Silicon Graphics, Inc.  All rights reserved.
+ *  Copyright (c) 2004, 2005 James Bottomley <James.Bottomley@SteelEye.com>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -36,9 +37,6 @@
 
 #define SPI_PRINTK(x, l, f, a...)	dev_printk(l, &(x)->dev, f , ##a)
 
-static void transport_class_release(struct class_device *class_dev);
-static void host_class_release(struct class_device *class_dev);
-
 #define SPI_NUM_ATTRS 10	/* increase this if you add attributes */
 #define SPI_OTHER_ATTRS 1	/* Increase this if you add "always
 				 * on" attributes */
@@ -118,40 +116,39 @@
 	return SPI_SIGNAL_UNKNOWN;
 }
 
+static int spi_host_setup(struct device *dev)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
 
-struct class spi_transport_class = {
-	.name = "spi_transport",
-	.release = transport_class_release,
-};
-
-struct class spi_host_class = {
-	.name = "spi_host",
-	.release = host_class_release,
-};
+	spi_signalling(shost) = SPI_SIGNAL_UNKNOWN;
 
-static __init int spi_transport_init(void)
-{
-	int error = class_register(&spi_host_class);
-	if (error)
-		return error;
-	return class_register(&spi_transport_class);
+	return 0;
 }
 
-static void __exit spi_transport_exit(void)
-{
-	class_unregister(&spi_transport_class);
-	class_unregister(&spi_host_class);
-}
+static DECLARE_TRANSPORT_CLASS(spi_host_class,
+			       "spi_host",
+			       spi_host_setup,
+			       NULL,
+			       NULL);
 
-static int spi_setup_host_attrs(struct Scsi_Host *shost)
+static int spi_host_match(struct attribute_container *cont,
+			  struct device *dev)
 {
-	spi_signalling(shost) = SPI_SIGNAL_UNKNOWN;
+	struct Scsi_Host *shost;
 
-	return 0;
+	if (!scsi_is_host_device(dev))
+		return 0;
+
+	shost = dev_to_shost(dev);
+	if (!shost->transportt  || shost->transportt->host_attrs.class
+	    != &spi_host_class.class)
+		return 0;
+	return 1;
 }
 
-static int spi_configure_device(struct scsi_device *sdev)
+static int spi_device_configure(struct device *dev)
 {
+	struct scsi_device *sdev = to_scsi_device(dev);
 	struct scsi_target *starget = sdev->sdev_target;
 
 	/* Populate the target capability fields with the values
@@ -167,8 +164,10 @@
 	return 0;
 }
 
-static int spi_setup_transport_attrs(struct scsi_target *starget)
+static int spi_setup_transport_attrs(struct device *dev)
 {
+	struct scsi_target *starget = to_scsi_target(dev);
+
 	spi_period(starget) = -1;	/* illegal value */
 	spi_offset(starget) = 0;	/* async */
 	spi_width(starget) = 0;	/* narrow */
@@ -186,18 +185,6 @@
 	return 0;
 }
 
-static void transport_class_release(struct class_device *class_dev)
-{
-	struct scsi_target *starget = transport_class_to_starget(class_dev);
-	put_device(&starget->dev);
-}
-
-static void host_class_release(struct class_device *class_dev)
-{
-	struct Scsi_Host *shost = transport_class_to_shost(class_dev);
-	put_device(&shost->shost_gendev);
-}
-
 #define spi_transport_show_function(field, format_string)		\
 									\
 static ssize_t								\
@@ -788,6 +775,48 @@
 	i->host_attrs[count] = &i->private_host_attrs[count];		\
 	count++
 
+static int spi_device_match(struct attribute_container *cont,
+			    struct device *dev)
+{
+	struct scsi_device *sdev;
+	struct Scsi_Host *shost;
+
+	if (!scsi_is_sdev_device(dev))
+		return 0;
+
+	sdev = to_scsi_device(dev);
+	shost = sdev->host;
+	if (!shost->transportt  || shost->transportt->host_attrs.class
+	    != &spi_host_class.class)
+		return 0;
+	return 1;
+}
+
+static int spi_target_match(struct attribute_container *cont,
+			    struct device *dev)
+{
+	struct Scsi_Host *shost;
+
+	if (!scsi_is_target_device(dev))
+		return 0;
+
+	shost = dev_to_shost(dev->parent);
+	if (!shost->transportt  || shost->transportt->host_attrs.class
+	    != &spi_host_class.class)
+		return 0;
+	return 1;
+}
+
+static DECLARE_TRANSPORT_CLASS(spi_transport_class,
+			       "spi_transport",
+			       spi_setup_transport_attrs,
+			       NULL,
+			       NULL);
+
+static DECLARE_ANON_TRANSPORT_CLASS(spi_device_class,
+				    spi_device_match,
+				    spi_device_configure);
+
 struct scsi_transport_template *
 spi_attach_transport(struct spi_function_template *ft)
 {
@@ -800,14 +829,15 @@
 	memset(i, 0, sizeof(struct spi_internal));
 
 
-	i->t.target_attrs = &i->attrs[0];
-	i->t.target_class = &spi_transport_class;
-	i->t.target_setup = &spi_setup_transport_attrs;
-	i->t.device_configure = &spi_configure_device;
+	i->t.target_attrs.class = &spi_transport_class.class;
+	i->t.target_attrs.attrs = &i->attrs[0];
+	i->t.target_attrs.match = spi_target_match;
+	attribute_container_register(&i->t.target_attrs);
 	i->t.target_size = sizeof(struct spi_transport_attrs);
-	i->t.host_attrs = &i->host_attrs[0];
-	i->t.host_class = &spi_host_class;
-	i->t.host_setup = &spi_setup_host_attrs;
+	i->t.host_attrs.class = &spi_host_class.class;
+	i->t.host_attrs.attrs = &i->host_attrs[0];
+	i->t.host_attrs.match = spi_host_match;
+	attribute_container_register(&i->t.host_attrs);
 	i->t.host_size = sizeof(struct spi_host_attrs);
 	i->f = ft;
 
@@ -849,6 +879,21 @@
 }
 EXPORT_SYMBOL(spi_release_transport);
 
+static __init int spi_transport_init(void)
+{
+	int error = transport_class_register(&spi_transport_class);
+	if (error)
+		return error;
+	error = anon_transport_class_register(&spi_device_class);
+	return transport_class_register(&spi_host_class);
+}
+
+static void __exit spi_transport_exit(void)
+{
+	transport_class_unregister(&spi_transport_class);
+	anon_transport_class_unregister(&spi_device_class);
+	transport_class_unregister(&spi_host_class);
+}
 
 MODULE_AUTHOR("Martin Hicks");
 MODULE_DESCRIPTION("SPI Transport Attributes");
diff -Nru a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h	2005-01-11 23:17:31 -06:00
+++ b/include/scsi/scsi_device.h	2005-01-11 23:17:31 -06:00
@@ -123,8 +123,6 @@
 	struct device		sdev_gendev;
 	struct class_device	sdev_classdev;
 
-	struct class_device	transport_classdev;
-
 	enum scsi_device_state sdev_state;
 	unsigned long		sdev_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
@@ -133,7 +131,7 @@
 #define	class_to_sdev(d)	\
 	container_of(d, struct scsi_device, sdev_classdev)
 #define transport_class_to_sdev(class_dev) \
-	container_of(class_dev, struct scsi_device, transport_classdev)
+	to_scsi_device(class_dev->dev)
 
 /*
  * scsi_target: representation of a scsi target, for now, this is only
@@ -146,7 +144,6 @@
 	unsigned int		channel;
 	unsigned int		id; /* target id ... replace
 				     * scsi_device.id eventually */
-	struct class_device	transport_classdev;
 	unsigned long		create:1; /* signal that it needs to be added */
 	unsigned long		starget_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
@@ -157,7 +154,7 @@
 	return to_scsi_target(sdev->sdev_gendev.parent);
 }
 #define transport_class_to_starget(class_dev) \
-	container_of(class_dev, struct scsi_target, transport_classdev)
+	to_scsi_target(class_dev->dev)
 
 extern struct scsi_device *__scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint, void *hostdata);
@@ -224,6 +221,8 @@
 extern void scsi_target_quiesce(struct scsi_target *);
 extern void scsi_target_resume(struct scsi_target *);
 extern const char *scsi_device_state_name(enum scsi_device_state);
+extern int scsi_is_sdev_device(const struct device *);
+extern int scsi_is_target_device(const struct device *);
 static inline int scsi_device_online(struct scsi_device *sdev)
 {
 	return sdev->sdev_state != SDEV_OFFLINE;
diff -Nru a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	2005-01-11 23:17:31 -06:00
+++ b/include/scsi/scsi_host.h	2005-01-11 23:17:31 -06:00
@@ -528,7 +528,6 @@
 	 * separately
 	 */
 	void *shost_data;
-	struct class_device transport_classdev;
 
 	/*
 	 * We should ensure that this is aligned, both for better performance
@@ -542,8 +541,6 @@
 	container_of(d, struct Scsi_Host, shost_gendev)
 #define		class_to_shost(d)	\
 	container_of(d, struct Scsi_Host, shost_classdev)
-#define		transport_class_to_shost(class_dev) \
-	container_of(class_dev, struct Scsi_Host, transport_classdev)
 
 
 extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
@@ -578,6 +575,7 @@
 extern void scsi_unblock_requests(struct Scsi_Host *);
 extern void scsi_block_requests(struct Scsi_Host *);
 
+struct class_container;
 /*
  * These two functions are used to allocate and free a pseudo device
  * which will connect to the host adapter itself rather than any
@@ -587,6 +585,8 @@
  */
 extern void scsi_free_host_dev(struct scsi_device *);
 extern struct scsi_device *scsi_get_host_dev(struct Scsi_Host *);
+int scsi_is_host_device(const struct device *);
+
 
 /* legacy interfaces */
 extern struct Scsi_Host *scsi_register(struct scsi_host_template *, int);
diff -Nru a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
--- a/include/scsi/scsi_transport.h	2005-01-11 23:17:31 -06:00
+++ b/include/scsi/scsi_transport.h	2005-01-11 23:17:31 -06:00
@@ -20,31 +20,16 @@
 #ifndef SCSI_TRANSPORT_H
 #define SCSI_TRANSPORT_H
 
-struct scsi_transport_template {
-	/* The NULL terminated list of transport attributes
-	 * that should be exported.
-	 */
-	struct class_device_attribute **device_attrs;
-	struct class_device_attribute **target_attrs;
-	struct class_device_attribute **host_attrs;
-
+#include <linux/transport_class.h>
 
-	/* The transport class that the device is in */
-	struct class *device_class;
-	struct class *target_class;
-	struct class *host_class;
+struct scsi_transport_template {
+	/* The statistics attached to the host class only */
 	struct attribute_group *host_statistics;
 
-	/* Constructor functions */
-	int (*device_setup)(struct scsi_device *);
-	int (*device_configure)(struct scsi_device *);
-	int (*target_setup)(struct scsi_target *);
-	int (*host_setup)(struct Scsi_Host *);
-
-	/* Destructor functions */
-	void (*device_destroy)(struct scsi_device *);
-	void (*target_destroy)(struct scsi_target *);
-	void (*host_destroy)(struct Scsi_Host *);
+	/* the attribute containers */
+	struct attribute_container host_attrs;
+	struct attribute_container target_attrs;
+	struct attribute_container device_attrs;
 
 	/* The size of the specific transport attribute structure (a
 	 * space of this size will be left at the end of the
@@ -53,5 +38,9 @@
 	int	target_size;
 	int	host_size;
 };
+
+#define transport_class_to_shost(tc) \
+	dev_to_shost((tc)->dev)
+
 
 #endif /* SCSI_TRANSPORT_H */
diff -Nru a/include/scsi/scsi_transport_spi.h b/include/scsi/scsi_transport_spi.h
--- a/include/scsi/scsi_transport_spi.h	2005-01-11 23:17:31 -06:00
+++ b/include/scsi/scsi_transport_spi.h	2005-01-11 23:17:31 -06:00
@@ -21,6 +21,7 @@
 #define SCSI_TRANSPORT_SPI_H
 
 #include <linux/config.h>
+#include <linux/transport_class.h>
 
 struct scsi_transport_template;
 


