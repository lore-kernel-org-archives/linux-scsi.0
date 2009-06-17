From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][SCST]: Fix for possible race on the main SCST module unload
 in sysfs
Date: Wed, 17 Jun 2009 20:25:23 +0400
Message-ID: <4A3918F3.5010303@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:51636 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbZFQQ0L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2009 12:26:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scst-devel@lists.sourceforge.net, Daniel Debonzi <debonzi@linux.vnet.ibm.com>

This patch implements waiting on the main SCST module unload until no
objects in SCST's sysfs hierarchy have external references. It prevents
a race, when SCST sysfs code unloaded too early.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>

 scst_sysfs.c |   45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

Index: scst/src/scst_sysfs.c
===================================================================
--- scst/src/scst_sysfs.c	(revision 887)
+++ scst/src/scst_sysfs.c	(working copy)
@@ -13,7 +13,9 @@
 
 static DEFINE_MUTEX(scst_sysfs_mutex);
 
-static struct kobject *scst_sysfs_root_kobj;
+static DECLARE_COMPLETION(scst_sysfs_root_release_completion);
+
+static struct kobject scst_sysfs_root_kobj;
 static struct kobject *scst_targets_kobj;
 static struct kobject *scst_devices_kobj;
 static struct kobject *scst_sgv_kobj;
@@ -21,7 +23,10 @@ static struct kobject *scst_back_drivers
 
 static struct sysfs_ops scst_sysfs_ops;
 
-static void scst_sysfs_release(struct kobject *kobj);
+static void scst_sysfs_release(struct kobject *kobj)
+{
+	kfree(kobj);
+}
 
 int scst_create_tgtt_sysfs(struct scst_tgt_template *tgtt)
 {
@@ -344,9 +349,9 @@ static struct attribute *scst_sysfs_root
 	NULL,
 };
 
-static void scst_sysfs_release(struct kobject *kobj)
+static void scst_sysfs_root_release(struct kobject *kobj)
 {
-	kfree(kobj);
+	complete_all(&scst_sysfs_root_release_completion);
 }
 
 static ssize_t scst_show(struct kobject *kobj, struct attribute *attr,
@@ -374,7 +379,7 @@ static struct sysfs_ops scst_sysfs_ops =
 
 static struct kobj_type scst_sysfs_root_ktype = {
 	.sysfs_ops = &scst_sysfs_ops,
-	.release = scst_sysfs_release,
+	.release = scst_sysfs_root_release,
 	.default_attrs = scst_sysfs_root_default_attrs,
 };
 
@@ -385,23 +390,18 @@ int __init scst_sysfs_init(void)
 
 	TRACE_ENTRY();
 
-	scst_sysfs_root_kobj = kzalloc(sizeof(*scst_sysfs_root_kobj),
-					GFP_KERNEL);
-	if (!scst_sysfs_root_kobj)
-		goto sysfs_root_error;
-
-	retval = kobject_init_and_add(scst_sysfs_root_kobj,
+	retval = kobject_init_and_add(&scst_sysfs_root_kobj,
 			&scst_sysfs_root_ktype, kernel_kobj, "%s", "scst_tgt");
 	if (retval != 0)
 		goto sysfs_root_add_error;
 
 	scst_targets_kobj = kobject_create_and_add("targets",
-				scst_sysfs_root_kobj);
+				&scst_sysfs_root_kobj);
 	if (!scst_targets_kobj)
 		goto targets_kobj_error;
 
 	scst_devices_kobj = kobject_create_and_add("devices",
-				scst_sysfs_root_kobj);
+				&scst_sysfs_root_kobj);
 	if (!scst_devices_kobj)
 		goto devices_kobj_error;
 
@@ -410,12 +410,12 @@ int __init scst_sysfs_init(void)
 		goto sgv_kobj_error;
 
 	retval = kobject_init_and_add(scst_sgv_kobj, &sgv_ktype,
-			scst_sysfs_root_kobj, "%s", "sgv");
+			&scst_sysfs_root_kobj, "%s", "sgv");
 	if (retval != 0)
 		goto sgv_kobj_add_error;
 
 	scst_back_drivers_kobj = kobject_create_and_add("back_drivers",
-					scst_sysfs_root_kobj);
+					&scst_sysfs_root_kobj);
 	if (!scst_back_drivers_kobj)
 		goto back_drivers_kobj_error;
 
@@ -439,12 +439,11 @@ devices_kobj_error:
 	kobject_put(scst_targets_kobj);
 
 targets_kobj_error:
-	kobject_del(scst_sysfs_root_kobj);
+	kobject_del(&scst_sysfs_root_kobj);
 
 sysfs_root_add_error:
-	kobject_put(scst_sysfs_root_kobj);
+	kobject_put(&scst_sysfs_root_kobj);
 
-sysfs_root_error:
 	if (retval == 0)
 		retval = -EINVAL;
 	goto out;
@@ -454,6 +453,8 @@ void __exit scst_sysfs_cleanup(void)
 {
 	TRACE_ENTRY();
 
+	PRINT_INFO("%s", "Exiting SCST sysfs hierarchy...");
+
 	kobject_del(scst_sgv_kobj);
 	kobject_put(scst_sgv_kobj);
 
@@ -466,8 +467,12 @@ void __exit scst_sysfs_cleanup(void)
 	kobject_del(scst_back_drivers_kobj);
 	kobject_put(scst_back_drivers_kobj);
 
-	kobject_del(scst_sysfs_root_kobj);
-	kobject_put(scst_sysfs_root_kobj);
+	kobject_del(&scst_sysfs_root_kobj);
+	kobject_put(&scst_sysfs_root_kobj);
+
+	wait_for_completion(&scst_sysfs_root_release_completion);
+
+	PRINT_INFO("%s", "Exiting SCST sysfs hierarchy done");
 
 	TRACE_EXIT();
 	return;

-- 
Home page of SCST and target drivers: http://scst.sourceforge.net

