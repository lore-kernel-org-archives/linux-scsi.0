From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC 2/3] add fc transport events
Date: Thu, 27 May 2004 00:26:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B5980A.7060800@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040308000007010106090607"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46340 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S261682AbUE0H0J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 03:26:09 -0400
Received: from cs.wisc.edu ([199.108.226.254])
	(authenticated (0 bits))
	by sabe.cs.wisc.edu (8.11.3/8.11.3) with ESMTP id i4R7Q2w07603
	(using TLSv1/SSLv3 with cipher RC4-MD5 (128 bits) verified NO)
	for <linux-scsi@vger.kernel.org>; Thu, 27 May 2004 02:26:08 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------040308000007010106090607
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


02-sdev-transport-kobj.patch - converts the transport class_device in the
scsi_device to a kobject.

  drivers/scsi/scsi_scan.c   |    7 +++----
  drivers/scsi/scsi_sysfs.c  |   22 +++++-----------------
  include/scsi/scsi_device.h |    6 +++---
  3 files changed, 11 insertions(+), 24 deletions(-)

--------------040308000007010106090607
Content-Type: text/plain;
 name="02-sdev-transport-kobj.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02-sdev-transport-kobj.patch"

diff -aurp linux-2.6.7-rc1/drivers/scsi/scsi_scan.c linux-2.6.7-rc1-hotplug/drivers/scsi/scsi_scan.c
--- linux-2.6.7-rc1/drivers/scsi/scsi_scan.c	2004-05-26 22:47:18.000000000 -0700
+++ linux-2.6.7-rc1-hotplug/drivers/scsi/scsi_scan.c	2004-05-26 23:26:54.277965439 -0700
@@ -259,10 +259,9 @@ static struct scsi_device *scsi_alloc_sd
 			 "%d:%d:%d:%d", sdev->host->host_no,
 			 sdev->channel, sdev->id, sdev->lun);
 
-		class_device_initialize(&sdev->transport_classdev);
-		sdev->transport_classdev.dev = &sdev->sdev_gendev;
-		sdev->transport_classdev.class = sdev->host->transportt->class;
-		snprintf(sdev->transport_classdev.class_id, BUS_ID_SIZE,
+		kobject_init(&sdev->transport_kobj);
+		sdev->transport_kobj.parent = &sdev->host->transport_classdev.kobj;
+		snprintf(sdev->transport_kobj.name, KOBJ_NAME_LEN,
 			 "%d:%d:%d:%d", sdev->host->host_no,
 			 sdev->channel, sdev->id, sdev->lun);
 	} else
diff -aurp linux-2.6.7-rc1/drivers/scsi/scsi_sysfs.c linux-2.6.7-rc1-hotplug/drivers/scsi/scsi_sysfs.c
--- linux-2.6.7-rc1/drivers/scsi/scsi_sysfs.c	2004-05-26 22:47:18.000000000 -0700
+++ linux-2.6.7-rc1-hotplug/drivers/scsi/scsi_sysfs.c	2004-05-26 23:27:02.842773380 -0700
@@ -438,7 +438,6 @@ static int attr_add(struct device *dev, 
  **/
 int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 {
-	struct class_device_attribute **attrs;
 	int error, i;
 
 	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
@@ -459,8 +458,9 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	 * released by the sdev_class .release */
 	get_device(&sdev->sdev_gendev);
 
-	if (sdev->transport_classdev.class) {
-		error = class_device_add(&sdev->transport_classdev);
+	if (sdev->host->transportt->class) {
+		sdev->transport_kobj.ktype = sdev->host->transportt->sdev_attrs;
+		error = kobject_add(&sdev->transport_kobj);
 		if (error)
 			goto clean_device2;
 		/* take a reference for the transport_classdev; this
@@ -492,18 +492,6 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 		}
 	}
 
- 	if (sdev->transport_classdev.class) {
- 		attrs = sdev->host->transportt->attrs;
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
  out:
 	return error;
 
@@ -528,8 +516,8 @@ void scsi_remove_device(struct scsi_devi
 		return;
 
 	class_device_unregister(&sdev->sdev_classdev);
-	if (sdev->transport_classdev.class)
-		class_device_unregister(&sdev->transport_classdev);
+	if (sdev->host->transportt->class)
+		kobject_unregister(&sdev->transport_kobj);
 	device_del(&sdev->sdev_gendev);
 	scsi_device_set_state(sdev, SDEV_DEL);
 	if (sdev->host->hostt->slave_destroy)
diff -aurp linux-2.6.7-rc1/include/scsi/scsi_device.h linux-2.6.7-rc1-hotplug/include/scsi/scsi_device.h
--- linux-2.6.7-rc1/include/scsi/scsi_device.h	2004-05-26 22:47:18.000000000 -0700
+++ linux-2.6.7-rc1-hotplug/include/scsi/scsi_device.h	2004-05-26 23:26:32.000000000 -0700
@@ -117,7 +117,7 @@ struct scsi_device {
 	struct device		sdev_gendev;
 	struct class_device	sdev_classdev;
 
-	struct class_device	transport_classdev;
+	struct kobject		transport_kobj;
 
 	enum scsi_device_state sdev_state;
 	unsigned long		transport_data[0];
@@ -126,8 +126,8 @@ struct scsi_device {
 	container_of(d, struct scsi_device, sdev_gendev)
 #define	class_to_sdev(d)	\
 	container_of(d, struct scsi_device, sdev_classdev)
-#define transport_class_to_sdev(class_dev) \
-	container_of(class_dev, struct scsi_device, transport_classdev)
+#define transport_class_to_sdev(_kobj) \
+	container_of(_kobj, struct scsi_device, transport_kobj)
 
 extern struct scsi_device *scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint);

--------------040308000007010106090607--

