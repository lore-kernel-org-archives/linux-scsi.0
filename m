From: Douglas Gilbert <dougg@torque.net>
Subject: Re: devices with more than one node
Date: Thu, 15 Jan 2004 18:04:42 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4006499A.4070302@torque.net>
References: <20040113193842.GA29887@suse.de> <20040113194631.GA3818@kroah.com> <20040113211122.GA28100@suse.de> <20040113212058.GA2595@kroah.com> <20040113150147.A9902@beaverton.ibm.com> <20040113231813.GA7409@kroah.com> <1074042776.4004979822819@wwws.torque.net> <20040114030847.GG4339@linnie.riede.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050705090309060006000204"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [192.43.230.1] ([192.43.230.1]:57731 "EHLO yoyo.aarnet.edu.au")
	by vger.kernel.org with ESMTP id S266470AbUAOILZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2004 03:11:25 -0500
In-Reply-To: <20040114030847.GG4339@linnie.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: wrlk@riede.org
Cc: linux-scsi@vger.kernel.org, Kai.Makisara@kolumbus.fi, greg@kroah.com

This is a multi-part message in MIME format.
--------------050705090309060006000204
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Willem Riede wrote:
> On 2004.01.13 20:12, dougg@torque.net wrote:
> 
>>Quoting Greg KH <greg@kroah.com>:
>>
>>
>>>For scsi generic you should create a scsi generic class (scsi_generic?)
>>>and create the individual sg devices in that directory (feel free to use
>>>the simple_class.c code that is currently in the -mm tree if you want,
>>>it makes it much simpler)
>>
>>Does any device use the simple_class.c code yet?
> 
> 
> I did in osst, see 
> http://marc.theaimsgroup.com/?l=linux-kernel&m=107275923222124&w=2

Here is an sg patch against lk 2.6.1-mm2 that uses
simple_add_class_device() as suggested by Greg and
demonstrated by Willem in osst. The patch will apply
clean against the sg driver in lk 2.6.1 but will not
compile as the mm series defines simple_add_class_device().

So this patch is not meant to be placed in the mainline
kernel yet. It is for Kai and Willem to consider and
for others to critique.

The cdev stuff is still in place (and I assume Greg
will soon be removing its sysfs visibility). The symlinks
that Greg objected to (in /sys/cdev/major/sg* directories)
have been dropped. A reverse symlink called "generic" has
been redirected from the scsi device to the corresponding
/sys/class/scsi_generic/sg<n> directory.

To test it I modded scsi_debug to fake OnStream tape
drives and ran a 2.6.1-mm2 kernel. The attached
output of "cd /sys/class; tree scsi* osst" is instructive.
Two peculiar entries are:
     scsi_generic/sg0/driver -> ../../../bus/scsi/drivers/osst
     scsi_generic/sg1/driver -> ../../../bus/scsi/drivers/osst

This symlink only appears if the osst driver is loaded
_before_ the sg driver! It is also left dangling by
"rmmod osst". It seems that sysfs is still not happy
with multiple drivers controlling the one device. The scsi
subsystem solution to this is to relegate sg to be a
sysfs "non" driver. Hence sg has no entry under
/sys/bus/scsi/drivers and thus no obvious place to
put its driver parameters. Sg driver parameters could be
placed in the /sys/class/scsi_generic directory (with
class_create_file() ). Suggestions?

Doug Gilbert

--------------050705090309060006000204
Content-Type: text/plain;
 name="sg_261mm2_simp.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_261mm2_simp.diff"

--- linux/drivers/scsi/sg.c	2004-01-10 15:53:59.000000000 +1000
+++ linux/drivers/scsi/sg.c261mm2_simp	2004-01-15 16:53:02.156514584 +1000
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
+static char *sg_version_str = "3.5.30 [20040115]";
 
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
@@ -1333,6 +1329,14 @@
 	.fasync = sg_fasync,
 };
 
+static struct class sg_sysfs_class = {
+        .name           = "scsi_generic",
+//      .hotplug        = tbd,
+//      .release        = tbd,
+};
+
+static int sg_sysfs_valid = 0;
+
 static int
 sg_add(struct class_device *cl_dev)
 {
@@ -1360,7 +1364,7 @@
 				tmp_dev_max * sizeof(Sg_device *));
 		if (NULL == tmp_da) {
 			printk(KERN_ERR
-			       "sg_attach: device array cannot be resized\n");
+			       "sg_add: device array cannot be resized\n");
 			error = -ENOMEM;
 			goto out;
 		}
@@ -1401,12 +1405,12 @@
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
@@ -1432,16 +1436,24 @@
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
+		sg_class_member = simple_add_class_device(&sg_sysfs_class, 
+				MKDEV(SCSI_GENERIC_MAJOR, k), 
+				cl_dev->dev, "%s", 
+				disk->disk_name);
+		if (NULL == sg_class_member)
+			printk(KERN_WARNING "sg_add: "
+				"simple_add_class_devive failed\n");
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
@@ -1512,7 +1524,7 @@
 
 	if (sdp) {
 		sysfs_remove_link(&scsidp->sdev_gendev.kobj, "generic");
-		sysfs_remove_link(&sdp->cdev->kobj, "device");
+		simple_remove_class_device(MKDEV(SCSI_GENERIC_MAJOR, k));
 		cdev_del(sdp->cdev);
 		sdp->cdev = NULL;
 		devfs_remove("%s/generic", scsidp->devfs_name);
@@ -1538,6 +1550,7 @@
 MODULE_LICENSE("GPL");
 
 MODULE_PARM_DESC(def_reserved_size, "size of buffer reserved for each fd");
+MODULE_PARM_DESC(allow_dio, "allow direct I/O (default: 0 (disallow))");
 
 static int __init
 init_sg(void)
@@ -1551,16 +1564,21 @@
 				    SG_MAX_DEVS, "sg");
 	if (rc)
 		return rc;
+	rc = class_register(&sg_sysfs_class);
+	if (rc)
+		goto err_out;
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
+	class_unregister(&sg_sysfs_class);
+err_out:
+	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0), SG_MAX_DEVS);
+	return rc;
 }
 
 static void __exit
@@ -1570,6 +1588,8 @@
 	sg_proc_cleanup();
 #endif				/* CONFIG_SCSI_PROC_FS */
 	scsi_unregister_interface(&sg_interface);
+	class_unregister(&sg_sysfs_class);
+	sg_sysfs_valid = 0;
 	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0),
 				 SG_MAX_DEVS);
 	if (sg_dev_arr != NULL) {

--------------050705090309060006000204
Content-Type: text/plain;
 name="scsi_tree.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_tree.txt"

scsi_device
|-- 2:0:0:0
|   |-- device -> ../../../devices/pseudo_0/adapter0/host2/2:0:0:0
|   `-- driver -> ../../../bus/scsi/drivers/osst
`-- 2:0:1:0
    |-- device -> ../../../devices/pseudo_0/adapter0/host2/2:0:1:0
    `-- driver -> ../../../bus/scsi/drivers/osst
scsi_generic
|-- sg0
|   |-- dev
|   |-- device -> ../../../devices/pseudo_0/adapter0/host2/2:0:0:0
|   `-- driver -> ../../../bus/scsi/drivers/osst
`-- sg1
    |-- dev
    |-- device -> ../../../devices/pseudo_0/adapter0/host2/2:0:1:0
    `-- driver -> ../../../bus/scsi/drivers/osst
scsi_host
`-- host2
    |-- cmd_per_lun
    |-- device -> ../../../devices/pseudo_0/adapter0/host2
    |-- host_busy
    |-- scan
    |-- sg_tablesize
    |-- unchecked_isa_dma
    `-- unique_id
osst
|-- osst0
|   |-- ADR_rev
|   |-- BOT_frame
|   |-- EOD_frame
|   |-- capacity
|   |-- dev
|   |-- device -> ../../../devices/pseudo_0/adapter0/host2/2:0:0:0
|   |-- driver -> ../../../bus/scsi/drivers/osst
|   |-- file_count
|   `-- media_version
`-- osst1
    |-- ADR_rev
    |-- BOT_frame
    |-- EOD_frame
    |-- capacity
    |-- dev
    |-- device -> ../../../devices/pseudo_0/adapter0/host2/2:0:1:0
    |-- driver -> ../../../bus/scsi/drivers/osst
    |-- file_count
    `-- media_version

20 directories, 22 files

--------------050705090309060006000204--


