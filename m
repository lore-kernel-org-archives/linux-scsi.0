From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] sg driver against lk 2.6.1-bk6
Date: Mon, 26 Jan 2004 22:01:04 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40150180.80001@torque.net>
References: <400E706A.1050008@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000909060202030301000308"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:22544 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261270AbUAZMDo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2004 07:03:44 -0500
Received: from torque.net (d-238-115.stlucia.uq.net.au [203.101.238.115])
	by bunyip.cc.uq.edu.au (8.12.10/8.12.10) with ESMTP id i0QC3dci013742
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2004 22:03:40 +1000 (GMT+1000)
In-Reply-To: <400E706A.1050008@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000909060202030301000308
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Douglas Gilbert wrote:
> This patch is against the sg driver found in lk 2.6.1-bk6 .
> It is an update on the sg patch sent in the "devices with more
> than one node" thread:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=107415435300783&w=2

Attached is an updated patch adding the cdev_unmap() call
which Kai Makisara reported as required. This should apply
against lk 2.6.1-bk6 up to the current lk 2.6.2-rc2 .

Doug Gilbert



--------------000909060202030301000308
Content-Type: text/plain;
 name="sg_261rc1_simp.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_261rc1_simp.diff"

--- linux/drivers/scsi/sg.c	2004-01-10 15:53:59.000000000 +1000
+++ linux/drivers/scsi/sg.c261rc1_simp	2004-01-24 22:17:15.000000000 +1000
@@ -58,10 +58,6 @@
 #include <linux/cdev.h>
 #include <linux/seq_file.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
-#include <asm/system.h>
-
 #include <linux/blkdev.h>
 #include "scsi.h"
 #include "hosts.h"
@@ -73,7 +69,7 @@
 
 #ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
-static char *sg_version_str = "3.5.30 [20031010]";
+static char *sg_version_str = "3.5.30 [20040124]";
 
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
@@ -1333,6 +1329,10 @@
 	.fasync = sg_fasync,
 };
 
+static struct class_simple * sg_sysfs_class;
+
+static int sg_sysfs_valid = 0;
+
 static int
 sg_add(struct class_device *cl_dev)
 {
@@ -1360,7 +1360,7 @@
 				tmp_dev_max * sizeof(Sg_device *));
 		if (NULL == tmp_da) {
 			printk(KERN_ERR
-			       "sg_attach: device array cannot be resized\n");
+			       "sg_add: device array cannot be resized\n");
 			error = -ENOMEM;
 			goto out;
 		}
@@ -1401,12 +1401,12 @@
 		sdp = NULL;
 	if (NULL == sdp) {
 		write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
-		printk(KERN_ERR "sg_attach: Sg_device cannot be allocated\n");
+		printk(KERN_ERR "sg_add: Sg_device cannot be allocated\n");
 		error = -ENOMEM;
 		goto out;
 	}
 
-	SCSI_LOG_TIMEOUT(3, printk("sg_attach: dev=%d \n", k));
+	SCSI_LOG_TIMEOUT(3, printk("sg_add: dev=%d \n", k));
 	memset(sdp, 0, sizeof(*sdp));
 	sprintf(disk->disk_name, "sg%d", k);
 	strncpy(cdev->kobj.name, disk->disk_name, KOBJ_NAME_LEN);
@@ -1432,16 +1432,24 @@
 		goto out;
 	}
 	sdp->cdev = cdev;
-	error = sysfs_create_link(&cdev->kobj, &scsidp->sdev_gendev.kobj, 
-				  "device");
-	if (error)
-		printk(KERN_ERR "sg_attach: unable to make symlink 'device'"
-		       " for sg%d\n", k);
-	error = sysfs_create_link(&scsidp->sdev_gendev.kobj, &cdev->kobj, 
-				  "generic");
-	if (error)
-		printk(KERN_ERR "sg_attach: unable to make symlink 'generic'"
-		       " back to sg%d\n", k);
+	if (sg_sysfs_valid) {
+		struct class_device * sg_class_member;
+
+		sg_class_member = class_simple_device_add(sg_sysfs_class, 
+				MKDEV(SCSI_GENERIC_MAJOR, k), 
+				cl_dev->dev, "%s", 
+				disk->disk_name);
+		if (NULL == sg_class_member)
+			printk(KERN_WARNING "sg_add: "
+				"class_simple_device_add failed\n");
+		class_set_devdata(sg_class_member, sdp);
+		error = sysfs_create_link(&scsidp->sdev_gendev.kobj, 
+					  &sg_class_member->kobj, "generic");
+		if (error)
+			printk(KERN_ERR "sg_add: unable to make symlink "
+					"'generic' back to sg%d\n", k);
+	} else
+		printk(KERN_WARNING "sg_add: sg_sys INvalid\n");
 
 	printk(KERN_NOTICE
 	       "Attached scsi generic sg%d at scsi%d, channel"
@@ -1512,7 +1520,8 @@
 
 	if (sdp) {
 		sysfs_remove_link(&scsidp->sdev_gendev.kobj, "generic");
-		sysfs_remove_link(&sdp->cdev->kobj, "device");
+		class_simple_device_remove(MKDEV(SCSI_GENERIC_MAJOR, k));
+		cdev_unmap(MKDEV(SCSI_GENERIC_MAJOR, k), 1);
 		cdev_del(sdp->cdev);
 		sdp->cdev = NULL;
 		devfs_remove("%s/generic", scsidp->devfs_name);
@@ -1538,6 +1547,7 @@
 MODULE_LICENSE("GPL");
 
 MODULE_PARM_DESC(def_reserved_size, "size of buffer reserved for each fd");
+MODULE_PARM_DESC(allow_dio, "allow direct I/O (default: 0 (disallow))");
 
 static int __init
 init_sg(void)
@@ -1551,16 +1561,23 @@
 				    SG_MAX_DEVS, "sg");
 	if (rc)
 		return rc;
+        sg_sysfs_class = class_simple_create(THIS_MODULE, "scsi_generic");
+        if ( IS_ERR(sg_sysfs_class) ) {
+		rc = PTR_ERR(sg_sysfs_class);
+		goto err_out;
+        }
+	sg_sysfs_valid = 1;
 	rc = scsi_register_interface(&sg_interface);
-	if (rc) {
-		unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0),
-				         SG_MAX_DEVS);
-		return rc;
-	}
+	if (0 == rc) {
 #ifdef CONFIG_SCSI_PROC_FS
-	sg_proc_init();
+		sg_proc_init();
 #endif				/* CONFIG_SCSI_PROC_FS */
-	return 0;
+		return 0;
+	}
+	class_simple_destroy(sg_sysfs_class);
+err_out:
+	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0), SG_MAX_DEVS);
+	return rc;
 }
 
 static void __exit
@@ -1570,6 +1587,8 @@
 	sg_proc_cleanup();
 #endif				/* CONFIG_SCSI_PROC_FS */
 	scsi_unregister_interface(&sg_interface);
+	class_simple_destroy(sg_sysfs_class);
+	sg_sysfs_valid = 0;
 	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0),
 				 SG_MAX_DEVS);
 	if (sg_dev_arr != NULL) {

--------------000909060202030301000308--

