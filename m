From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] change sdev.access_count to an atomic_t
Date: Sat, 20 Sep 2003 10:32:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030920083256.GB20301@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:41197 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261668AbTITIdC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Sep 2003 04:33:02 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

For various reasons (e.g. the .my_devices lockdown) it's undesirable
to have scsi_device_{get,put} blocking.  Change .access_count to an
atomic_t to avoid the driver model r/w semaphore.

Sideeffects:

 - possible module reference leak in scsi_device_get when get_device
   fails fixes.
 - the access_count attribute is gone.  We already have this exposed
   to userspace in too many places given that this whole second
   refcount will go away once Al fixes the block layer.



diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Sat Sep 20 09:35:07 2003
+++ b/drivers/scsi/scsi.c	Sat Sep 20 09:35:07 2003
@@ -889,21 +889,24 @@
 int scsi_device_get(struct scsi_device *sdev)
 {
 	struct class *class = class_get(&sdev_class);
-	int error = -ENXIO;
 
-	if (class) {
-		down_write(&class->subsys.rwsem);
-		if (!test_bit(SDEV_DEL, &sdev->sdev_state))
-			if (try_module_get(sdev->host->hostt->module)) 
-				if (get_device(&sdev->sdev_gendev)) {
-					sdev->access_count++;
-					error = 0;
-				}
-		up_write(&class->subsys.rwsem);
-		class_put(&sdev_class);
-	}
+	if (!class)
+		goto out;
+	if (test_bit(SDEV_DEL, &sdev->sdev_state))
+		goto out;
+	if (!try_module_get(sdev->host->hostt->module))
+		goto out;
+	if (!get_device(&sdev->sdev_gendev))
+		goto out_put_module;
+	atomic_inc(&sdev->access_count);
+	class_put(&sdev_class);
+	return 0;
 
-	return error;
+ out_put_module:
+	module_put(sdev->host->hostt->module);
+ out:
+	class_put(&sdev_class);
+	return -ENXIO;
 }
 
 void scsi_device_put(struct scsi_device *sdev)
@@ -913,15 +916,11 @@
 	if (!class)
 		return;
 
-	down_write(&class->subsys.rwsem);
 	module_put(sdev->host->hostt->module);
-	if (--sdev->access_count == 0) {
+	if (atomic_dec_and_test(&sdev->access_count))
 		if (test_bit(SDEV_DEL, &sdev->sdev_state))
 			device_del(&sdev->sdev_gendev);
-	}
 	put_device(&sdev->sdev_gendev);
-	up_write(&class->subsys.rwsem);
-
 	class_put(&sdev_class);
 }
 
diff -Nru a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
--- a/drivers/scsi/scsi_proc.c	Sat Sep 20 09:35:07 2003
+++ b/drivers/scsi/scsi_proc.c	Sat Sep 20 09:35:07 2003
@@ -216,7 +216,7 @@
 	sdev = scsi_find_device(shost, channel, id, lun);
 	if (!sdev)
 		goto out;
-	if (sdev->access_count)
+	if (atomic_read(&sdev->access_count))
 		goto out;
 
 	scsi_remove_device(sdev);
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Sat Sep 20 09:35:07 2003
+++ b/drivers/scsi/scsi_scan.c	Sat Sep 20 09:35:07 2003
@@ -203,6 +203,7 @@
 		goto out;
 
 	memset(sdev, 0, sizeof(*sdev));
+	atomic_set(&sdev->access_count, 0);
 	sdev->vendor = scsi_null_device_strs;
 	sdev->model = scsi_null_device_strs;
 	sdev->rev = scsi_null_device_strs;
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	Sat Sep 20 09:35:07 2003
+++ b/drivers/scsi/scsi_sysfs.c	Sat Sep 20 09:35:07 2003
@@ -246,7 +246,6 @@
 sdev_rd_attr (queue_depth, "%d\n");
 sdev_rd_attr (type, "%d\n");
 sdev_rd_attr (scsi_level, "%d\n");
-sdev_rd_attr (access_count, "%d\n");
 sdev_rd_attr (vendor, "%.8s\n");
 sdev_rd_attr (model, "%.16s\n");
 sdev_rd_attr (rev, "%.4s\n");
@@ -265,17 +264,14 @@
 				 size_t count)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	int res = count;
 
-	if (sdev->access_count)
-		/*
-		 * FIXME and scsi_proc.c: racey use of access_count,
-		 * possibly add a new arg to scsi_remove_device.
-		 */
-		res = -EBUSY;
-	else
-		scsi_remove_device(sdev);
-	return res;
+	/*
+	 * FIXME and scsi_proc.c: racey use of access_count,
+	 */
+	if (atomic_read(&sdev->access_count))
+		return -EBUSY;
+	scsi_remove_device(sdev);
+	return count;
 };
 static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
 
@@ -285,7 +281,6 @@
 	&dev_attr_queue_depth,
 	&dev_attr_type,
 	&dev_attr_scsi_level,
-	&dev_attr_access_count,
 	&dev_attr_vendor,
 	&dev_attr_model,
 	&dev_attr_rev,
@@ -415,7 +410,7 @@
 	if (class) {
 		down_write(&class->subsys.rwsem);
 		set_bit(SDEV_DEL, &sdev->sdev_state);
-		if (sdev->access_count == 0)
+		if (atomic_read(&sdev->access_count))
 			device_del(&sdev->sdev_gendev);
 		up_write(&class->subsys.rwsem);
 	}
diff -Nru a/drivers/scsi/sg.c b/drivers/scsi/sg.c
--- a/drivers/scsi/sg.c	Sat Sep 20 09:35:07 2003
+++ b/drivers/scsi/sg.c	Sat Sep 20 09:35:07 2003
@@ -912,7 +912,7 @@
 	case SG_GET_VERSION_NUM:
 		return put_user(sg_version_num, (int *) arg);
 	case SG_GET_ACCESS_COUNT:
-		val = (sdp->device ? sdp->device->access_count : 0);
+		val = (sdp->device ? atomic_read(&sdp->device->access_count) : 0);
 		return put_user(val, (int *) arg);
 	case SG_GET_REQUEST_TABLE:
 		result = verify_area(VERIFY_WRITE, (void *) arg,
@@ -2899,7 +2899,7 @@
 			PRINT_PROC("%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",
 				   scsidp->host->host_no, scsidp->channel,
 				   scsidp->id, scsidp->lun, (int) scsidp->type,
-				   (int) scsidp->access_count,
+				   (int) atomic_read(&scsidp->access_count),
 				   (int) scsidp->queue_depth,
 				   (int) scsidp->device_busy,
 				   (int) scsidp->online);
diff -Nru a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h	Sat Sep 20 09:35:07 2003
+++ b/include/scsi/scsi_device.h	Sat Sep 20 09:35:07 2003
@@ -4,6 +4,7 @@
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <asm/atomic.h>
 
 struct request_queue;
 struct scsi_cmnd;
@@ -44,7 +45,7 @@
 					 * vendor-specific cmd's */
 	unsigned sector_size;	/* size in bytes */
 
-	int access_count;	/* Count of open channels/mounts */
+	atomic_t access_count;	/* Count of open channels/mounts */
 
 	void *hostdata;		/* available to low-level driver */
 	char devfs_name[256];	/* devfs junk */
