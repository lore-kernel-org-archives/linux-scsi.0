From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove remaining MAJOR_NR/DEVICE_NR junk
Date: Thu, 5 Dec 2002 15:09:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021205150926.A26999@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This was needed for blk.h in 2.4 but is entirely superflous in 2.5


--- 1.33/drivers/scsi/osst.c	Thu Nov 28 10:01:07 2002
+++ edited/drivers/scsi/osst.c	Thu Dec  5 00:41:13 2002
@@ -46,6 +46,7 @@
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
 #include <linux/version.h>
+#include <linux/blk.h>
 #include <asm/uaccess.h>
 #include <asm/dma.h>
 #include <asm/system.h>
@@ -59,8 +60,6 @@
    in the drivers are more widely classified, this may be changed to KERN_DEBUG. */
 #define OSST_DEB_MSG  KERN_NOTICE
 
-#define MAJOR_NR OSST_MAJOR
-#include <linux/blk.h>
 
 #include "scsi.h"
 #include "hosts.h"
@@ -5586,14 +5585,14 @@
 		tpnt->driverfs_dev_r[mode].parent = &SDp->sdev_driverfs_dev;
 		tpnt->driverfs_dev_r[mode].bus = SDp->sdev_driverfs_dev.bus;
 		tpnt->driverfs_dev_r[mode].driver_data =
-			(void *)(long)__mkdev(MAJOR_NR, dev_num + (mode << 5));
+			(void *)(long)__mkdev(OSST_MAJOR, dev_num + (mode << 5));
 		device_register(&tpnt->driverfs_dev_r[mode]);
 		device_create_file(&tpnt->driverfs_dev_r[mode], 
 				&dev_attr_type);
 		device_create_file(&tpnt->driverfs_dev_r[mode], &dev_attr_kdev);
 		tpnt->de_r[mode] =
 			devfs_register (SDp->de, name, DEVFS_FL_DEFAULT,
-					MAJOR_NR, dev_num + (mode << 5),
+					OSST_MAJOR, dev_num + (mode << 5),
 					S_IFCHR | S_IRUGO | S_IWUGO,
 					&osst_fops, NULL);
 		/*  No-rewind entry  */
@@ -5605,7 +5604,7 @@
 		tpnt->driverfs_dev_n[mode].parent= &SDp->sdev_driverfs_dev;
 		tpnt->driverfs_dev_n[mode].bus = SDp->sdev_driverfs_dev.bus;
 		tpnt->driverfs_dev_n[mode].driver_data =
-			(void *)(long)__mkdev(MAJOR_NR, dev_num + (mode << 5) + 128);
+			(void *)(long)__mkdev(OSST_MAJOR, dev_num + (mode << 5) + 128);
 		device_register(&tpnt->driverfs_dev_n[mode]);
 		device_create_file(&tpnt->driverfs_dev_n[mode], 
 				&dev_attr_type);
@@ -5613,7 +5612,7 @@
 				&dev_attr_kdev);
 		tpnt->de_n[mode] =
 			devfs_register (SDp->de, name, DEVFS_FL_DEFAULT,
-					MAJOR_NR, dev_num + (mode << 5) + 128,
+					OSST_MAJOR, dev_num + (mode << 5) + 128,
 					S_IFCHR | S_IRUGO | S_IWUGO,
 					&osst_fops, NULL);
 	}
@@ -5686,8 +5685,9 @@
 	 printk(OSST_DEB_MSG "osst :D: %d s/g segments, write threshold %d bytes.\n",
 			 max_sg_segs, osst_write_threshold);
 #endif
-	if ((register_chrdev(MAJOR_NR,"osst",&osst_fops) < 0) || scsi_register_device(&osst_template)) {
-		printk(KERN_ERR "osst :E: Unable to register major %d for OnStream tapes\n",MAJOR_NR);
+	if ((register_chrdev(OSST_MAJOR, "osst", &osst_fops) < 0) ||
+			scsi_register_device(&osst_template)) {
+		printk(KERN_ERR "osst :E: Unable to register major %d for OnStream tapes\n", OSST_MAJOR);
 		return 1;
 	}
 
@@ -5700,7 +5700,7 @@
 	OS_Scsi_Tape * STp;
 
 	scsi_unregister_device(&osst_template);
-	unregister_chrdev(MAJOR_NR, "osst");
+	unregister_chrdev(OSST_MAJOR, "osst");
 
 	if (os_scsi_tapes) {
 		for (i=0; i < osst_max_dev; ++i) {
--- 1.47/drivers/scsi/st.c	Thu Nov 28 10:36:39 2002
+++ edited/drivers/scsi/st.c	Thu Dec  5 00:40:02 2002
@@ -33,7 +33,7 @@
 #include <linux/ioctl.h>
 #include <linux/fcntl.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
+#include <linux/blk.h>
 #include <asm/uaccess.h>
 #include <asm/dma.h>
 #include <asm/system.h>
@@ -54,9 +54,6 @@
 #define DEBC(a)
 #endif
 
-#define MAJOR_NR SCSI_TAPE_MAJOR
-#define DEVICE_NR(device) (minor(device) & 0x7f)
-#include <linux/blk.h>
 
 #include "scsi.h"
 #include "hosts.h"
