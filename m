From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: scsi_dh: convert __ATTR macro to DEVICE_ATTR_RW and snprintf show
 method cleanup
Date: Fri, 26 Jun 2015 06:28:04 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3F8EAA11@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:34805 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbbFZG3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2015 02:29:17 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James Bottomley (JBottomley@Odin.com)" <JBottomley@Odin.com>


Converted dh_state to use DEVICE_ATTR_RW macro
instead of __ATTR.  That forced a change to the associated
show/store function names and the name of the attribute.

Changed usage of snprintf in show function to scnprintf per
Documentation/filesystems/sysfs.txt.

Signed-off-by: Shane Seymour <shane.seymour@hp.com>
---
--- a/drivers/scsi/device_handler/scsi_dh.c	2015-06-25 15:52:15.616031320 -0500
+++ b/drivers/scsi/device_handler/scsi_dh.c	2015-06-25 18:10:54.246839220 -0500
@@ -174,7 +174,7 @@ static void scsi_dh_handler_detach(struc
  * Functions for sysfs attribute 'dh_state'
  */
 static ssize_t
-store_dh_state(struct device *dev, struct device_attribute *attr,
+dh_state_store(struct device *dev, struct device_attribute *attr,
 	       const char *buf, size_t count)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
@@ -215,19 +215,17 @@ store_dh_state(struct device *dev, struc
 }
 
 static ssize_t
-show_dh_state(struct device *dev, struct device_attribute *attr, char *buf)
+dh_state_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 
 	if (!sdev->scsi_dh_data)
-		return snprintf(buf, 20, "detached\n");
+		return scnprintf(buf, 20, "detached\n");
 
-	return snprintf(buf, 20, "%s\n", sdev->scsi_dh_data->scsi_dh->name);
+	return scnprintf(buf, 20, "%s\n", sdev->scsi_dh_data->scsi_dh->name);
 }
 
-static struct device_attribute scsi_dh_state_attr =
-	__ATTR(dh_state, S_IRUGO | S_IWUSR, show_dh_state,
-	       store_dh_state);
+static DEVICE_ATTR_RW(dh_state);
 
 /*
  * scsi_dh_sysfs_attr_add - Callback for scsi_init_dh
@@ -243,7 +241,7 @@ static int scsi_dh_sysfs_attr_add(struct
 	sdev = to_scsi_device(dev);
 
 	err = device_create_file(&sdev->sdev_gendev,
-				 &scsi_dh_state_attr);
+		&dev_attr_dh_state);
 
 	return 0;
 }
@@ -261,7 +259,7 @@ static int scsi_dh_sysfs_attr_remove(str
 	sdev = to_scsi_device(dev);
 
 	device_remove_file(&sdev->sdev_gendev,
-			   &scsi_dh_state_attr);
+		&dev_attr_dh_state);
 
 	return 0;
 }
@@ -283,13 +281,13 @@ static int scsi_dh_notifier(struct notif
 	sdev = to_scsi_device(dev);
 
 	if (action == BUS_NOTIFY_ADD_DEVICE) {
-		err = device_create_file(dev, &scsi_dh_state_attr);
+		err = device_create_file(dev, &dev_attr_dh_state);
 		/* don't care about err */
 		devinfo = device_handler_match(NULL, sdev);
 		if (devinfo)
 			err = scsi_dh_handler_attach(sdev, devinfo);
 	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
-		device_remove_file(dev, &scsi_dh_state_attr);
+		device_remove_file(dev, &dev_attr_dh_state);
 		scsi_dh_handler_detach(sdev, NULL);
 	}
 	return err;
