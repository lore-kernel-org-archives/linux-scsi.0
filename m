From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 08/10] osduld: use filp_open() when looking up an osd-device
Date: Sun, 24 May 2009 20:05:05 +0300
Message-ID: <1243184705-17111-1-git-send-email-bharrosh@panasas.com>
References: <4A197CB5.60709@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:1338 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754350AbZEXRFH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 May 2009 13:05:07 -0400
In-Reply-To: <4A197CB5.60709@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>
Cc: Jeff Garzik <jeff@garzik.org>, Al Viro <viro@ZenIV.linux.org.uk>

This patch was inspired by Al Viro, for simplifying and fixing the
retrieval of osd-devices by in-kernel users, eg: file systems.
In-Kernel users, now, go through the same path user-mode does by
opening a file on the osd char-device and though holding a reference
to both the device and the Module.

A file pointer was added to the osd_dev structure which is now
allocated for each user. The internal osd_dev is no longer exposed
outside of the uld. I wanted to do that for a long time so each
libosd user can have his own defaults on the device.

The API is left the same, so user code need not change.

It is no longer needed to open/close a file handle on the osd
char-device from user-mode, before mounting an exofs on it.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>
---
 drivers/scsi/osd/osd_uld.c   |   66 +++++++++++++++++++-----------------------
 include/scsi/osd_initiator.h |    1 +
 2 files changed, 31 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index 22b59e1..0bdef33 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -49,6 +49,7 @@
 #include <linux/device.h>
 #include <linux/idr.h>
 #include <linux/major.h>
+#include <linux/file.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_driver.h>
@@ -175,10 +176,9 @@ static const struct file_operations osd_fops = {
 
 struct osd_dev *osduld_path_lookup(const char *name)
 {
-	struct path path;
-	struct inode *inode;
-	struct cdev *cdev;
-	struct osd_uld_device *uninitialized_var(oud);
+	struct osd_uld_device *oud;
+	struct osd_dev *od;
+	struct file *file;
 	int error;
 
 	if (!name || !*name) {
@@ -186,52 +186,46 @@ struct osd_dev *osduld_path_lookup(const char *name)
 		return ERR_PTR(-EINVAL);
 	}
 
-	error = kern_path(name, LOOKUP_FOLLOW, &path);
-	if (error) {
-		OSD_ERR("path_lookup of %s failed=>%d\n", name, error);
-		return ERR_PTR(error);
-	}
+	od = kzalloc(sizeof(*od), GFP_KERNEL);
+	if (!od)
+		return ERR_PTR(-ENOMEM);
 
-	inode = path.dentry->d_inode;
-	error = -EINVAL; /* Not the right device e.g osd_uld_device */
-	if (!S_ISCHR(inode->i_mode)) {
-		OSD_DEBUG("!S_ISCHR()\n");
-		goto out;
+	file = filp_open(name, O_RDWR, 0);
+	if (IS_ERR(file)) {
+		error = PTR_ERR(file);
+		goto free_od;
 	}
 
-	cdev = inode->i_cdev;
-	if (!cdev) {
-		OSD_ERR("Before mounting an OSD Based filesystem\n");
-		OSD_ERR("  user-mode must open+close the %s device\n", name);
-		OSD_ERR("  Example: bash: echo < %s\n", name);
-		goto out;
+	if (file->f_op != &osd_fops){
+		error = -EINVAL;
+		goto close_file;
 	}
 
-	/* The Magic wand. Is it our char-dev */
-	/* TODO: Support sg devices */
-	if (cdev->owner != THIS_MODULE) {
-		OSD_ERR("Error mounting %s - is not an OSD device\n", name);
-		goto out;
-	}
+	oud = file->private_data;
 
-	oud = container_of(cdev, struct osd_uld_device, cdev);
+	*od = oud->od;
+	od->file = file;
 
-	__uld_get(oud);
-	error = 0;
+	return od;
 
-out:
-	path_put(&path);
-	return error ? ERR_PTR(error) : &oud->od;
+close_file:
+	fput(file);
+free_od:
+	kfree(od);
+	return ERR_PTR(error);
 }
 EXPORT_SYMBOL(osduld_path_lookup);
 
 void osduld_put_device(struct osd_dev *od)
 {
-	if (od) {
-		struct osd_uld_device *oud = container_of(od,
-						struct osd_uld_device, od);
 
-		__uld_put(oud);
+	if (od && !IS_ERR(od)) {
+		struct osd_uld_device *oud = od->file->private_data;
+
+		BUG_ON(od->scsi_device != oud->od.scsi_device);
+
+		fput(od->file);
+		kfree(od);
 	}
 }
 EXPORT_SYMBOL(osduld_put_device);
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index b44dc53..02bd9f7 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -48,6 +48,7 @@ enum osd_std_version {
  */
 struct osd_dev {
 	struct scsi_device *scsi_device;
+	struct file *file;
 	unsigned def_timeout;
 
 #ifdef OSD_VER1_SUPPORT
-- 
1.6.2.1

