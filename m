From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sg driver against lk 2.6.6
Date: Sun, 16 May 2004 12:21:01 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40A6D00D.7070306@torque.net>
References: <20040502214525.5ad05bed.akpm@osdl.org> <20040503122948.GI2281@parcelfarce.linux.theplanet.co.uk> <20040503203512.GP2281@parcelfarce.linux.theplanet.co.uk> <40A36286.4020604@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090901010408080203090009"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:54539 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264865AbUEPCVm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 May 2004 22:21:42 -0400
In-Reply-To: <40A36286.4020604@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: Matthew Wilcox <willy@debian.org>, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

This is a multi-part message in MIME format.
--------------090901010408080203090009
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

subject was: 2.6.6-rc3 ia64 smp_call_function() called with
              interrupts disabled

Douglas Gilbert wrote:
> Matthew Wilcox wrote:
<snip>
>>
>> Does anybody like this patch?  It survived booting on my test box which
>> only has one scsi device.  More testing welcomed.
> 
> 
> Sorry, I missed this thread. The change looks good and survived
> about one hour of scsi_debug bashing (on i386). I also checked
> it against the previous version.
> 
> Attached is my version with only a superficial change to 2
> printk()s plus:
>   - bump version number
>   - introduce MODULE_VERSION
>   - increase over allocation of sg_dev_arr from 6 to 32

Here are some further refinements to this patch with help
from Pat Mansfield:
     - replace vmalloc() with kmalloc(,GFP_KERNEL)
     - bump max sg devices from 8192 to 32768

Tested to 16k devices (and 8k devices on a box with 512MB
ram), Patch is against lk 2.6.6 (or 2.6.6-bk1).

Doug Gilbert


--------------090901010408080203090009
Content-Type: text/plain;
 name="sg266mw3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg266mw3.diff"

--- linux/drivers/scsi/sg.c	2004-05-10 23:08:46.000000000 +1000
+++ linux/drivers/scsi/sg.c266mw3	2004-05-16 11:55:07.000000000 +1000
@@ -7,7 +7,7 @@
  * Original driver (sg.c):
  *        Copyright (C) 1992 Lawrence Foard
  * Version 2 and 3 extensions to driver:
- *        Copyright (C) 1998 - 2002 Douglas Gilbert
+ *        Copyright (C) 1998 - 2004 Douglas Gilbert
  *
  *  Modified  19-JAN-1998  Richard Gooch <rgooch@atnf.csiro.au>  Devfs support
  *
@@ -17,27 +17,18 @@
  * any later version.
  *
  */
-#include <linux/config.h>
-static int sg_version_num = 30530;	/* 2 digits for each component */
+
+static int sg_version_num = 30531;	/* 2 digits for each component */
+#define SG_VERSION_STR "3.5.31"
+
 /*
  *  D. P. Gilbert (dgilbert@interlog.com, dougg@triode.net.au), notes:
  *      - scsi logging is available via SCSI_LOG_TIMEOUT macros. First
  *        the kernel/module needs to be built with CONFIG_SCSI_LOGGING
  *        (otherwise the macros compile to empty statements).
- *        Then before running the program to be debugged enter:
- *          # echo "scsi log timeout 7" > /proc/scsi/scsi
- *        This will send copious output to the console and the log which
- *        is usually /var/log/messages. To turn off debugging enter:
- *          # echo "scsi log timeout 0" > /proc/scsi/scsi
- *        The 'timeout' token was chosen because it is relatively unused.
- *        The token 'hlcomplete' should be used but that triggers too
- *        much output from the sd device driver. To dump the current
- *        state of the SCSI mid level data structures enter:
- *          # echo "scsi dump 1" > /proc/scsi/scsi
- *        To dump the state of sg's data structures use:
- *          # cat /proc/scsi/sg/debug
  *
  */
+#include <linux/config.h>
 #include <linux/module.h>
 
 #include <linux/fs.h>
@@ -51,7 +42,6 @@
 #include <linux/fcntl.h>
 #include <linux/init.h>
 #include <linux/poll.h>
-#include <linux/vmalloc.h>
 #include <linux/smp_lock.h>
 #include <linux/moduleparam.h>
 #include <linux/devfs_fs_kernel.h>
@@ -69,7 +59,7 @@
 
 #ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
-static char *sg_version_str = "3.5.30 [20040124]";
+static char *sg_version_date = "20040516";
 
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
@@ -82,7 +72,7 @@
 #define SG_ALLOW_DIO_DEF 0
 #define SG_ALLOW_DIO_CODE /* compile out by commenting this define */
 
-#define SG_MAX_DEVS 8192
+#define SG_MAX_DEVS 32768
 
 /*
  * Suppose you want to calculate the formula muldiv(x,m,d)=int(x * m / d)
@@ -110,7 +100,7 @@
 #define SG_SECTOR_SZ 512
 #define SG_SECTOR_MSK (SG_SECTOR_SZ - 1)
 
-#define SG_DEV_ARR_LUMP 6	/* amount to over allocate sg_dev_arr by */
+#define SG_DEV_ARR_LUMP 32	/* amount to over allocate sg_dev_arr by */
 
 static int sg_add(struct class_device *);
 static void sg_remove(struct class_device *);
@@ -1333,85 +1323,46 @@
 
 static int sg_sysfs_valid = 0;
 
-static int
-sg_add(struct class_device *cl_dev)
+static int sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 {
-	struct scsi_device *scsidp = to_scsi_device(cl_dev->dev);
-	struct gendisk *disk;
-	Sg_device *sdp = NULL;
+	Sg_device *sdp;
 	unsigned long iflags;
-	struct cdev * cdev = NULL;
+	void *old_sg_dev_arr = NULL;
 	int k, error;
 
-	disk = alloc_disk(1);
-	if (!disk)
+	sdp = kmalloc(sizeof(Sg_device), GFP_KERNEL);
+	if (!sdp) {
+		printk(KERN_WARNING "kmalloc Sg_device failure\n");
 		return -ENOMEM;
+	}
 
-	cdev = cdev_alloc();
-	if (! cdev)
-		return -ENOMEM;
 	write_lock_irqsave(&sg_dev_arr_lock, iflags);
-	if (sg_nr_dev >= sg_dev_max) {	/* try to resize */
+	if (unlikely(sg_nr_dev >= sg_dev_max)) {	/* try to resize */
 		Sg_device **tmp_da;
 		int tmp_dev_max = sg_nr_dev + SG_DEV_ARR_LUMP;
-
 		write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
-		tmp_da = (Sg_device **)vmalloc(
-				tmp_dev_max * sizeof(Sg_device *));
-		if (NULL == tmp_da) {
-			printk(KERN_ERR
-			       "sg_add: device array cannot be resized\n");
-			error = -ENOMEM;
-			goto out;
-		}
+
+		tmp_da = kmalloc(tmp_dev_max * sizeof(Sg_device *), GFP_KERNEL);
+		if (unlikely(!tmp_da))
+			goto expand_failed;
+
 		write_lock_irqsave(&sg_dev_arr_lock, iflags);
-		memset(tmp_da, 0, tmp_dev_max * sizeof (Sg_device *));
-		memcpy(tmp_da, sg_dev_arr,
-		       sg_dev_max * sizeof (Sg_device *));
-		vfree((char *) sg_dev_arr);
+		memset(tmp_da, 0, tmp_dev_max * sizeof(Sg_device *));
+		memcpy(tmp_da, sg_dev_arr, sg_dev_max * sizeof(Sg_device *));
+		old_sg_dev_arr = sg_dev_arr;
 		sg_dev_arr = tmp_da;
 		sg_dev_max = tmp_dev_max;
 	}
 
-find_empty_slot:
 	for (k = 0; k < sg_dev_max; k++)
 		if (!sg_dev_arr[k])
 			break;
-	if (k >= SG_MAX_DEVS) {
-		write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
-		printk(KERN_WARNING
-		       "Unable to attach sg device <%d, %d, %d, %d>"
-		       " type=%d, minor number exceeds %d\n",
-		       scsidp->host->host_no, scsidp->channel, scsidp->id,
-		       scsidp->lun, scsidp->type, SG_MAX_DEVS - 1);
-		if (NULL != sdp)
-			vfree((char *) sdp);
-		error = -ENODEV;
-		goto out;
-	}
-	if (k < sg_dev_max) {
-		if (NULL == sdp) {
-			write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
-			sdp = (Sg_device *)vmalloc(sizeof(Sg_device));
-			write_lock_irqsave(&sg_dev_arr_lock, iflags);
-			if (!sg_dev_arr[k])
-				goto find_empty_slot;
-		}
-	} else
-		sdp = NULL;
-	if (NULL == sdp) {
-		write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
-		printk(KERN_ERR "sg_add: Sg_device cannot be allocated\n");
-		error = -ENOMEM;
-		goto out;
-	}
+	if (unlikely(k >= SG_MAX_DEVS))
+		goto overflow;
 
-	SCSI_LOG_TIMEOUT(3, printk("sg_add: dev=%d \n", k));
 	memset(sdp, 0, sizeof(*sdp));
+	SCSI_LOG_TIMEOUT(3, printk("sg_alloc: dev=%d \n", k));
 	sprintf(disk->disk_name, "sg%d", k);
-	cdev->owner = THIS_MODULE;
-	cdev->ops = &sg_fops;
-	disk->major = SCSI_GENERIC_MAJOR;
 	disk->first_minor = k;
 	sdp->disk = disk;
 	sdp->device = scsidp;
@@ -1421,6 +1372,61 @@
 	sg_nr_dev++;
 	sg_dev_arr[k] = sdp;
 	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
+	error = k;
+
+ out:
+	if (error < 0)
+		kfree(sdp);
+	kfree(old_sg_dev_arr);
+	return error;
+
+ expand_failed:
+	printk(KERN_WARNING "sg_alloc: device array cannot be resized\n");
+	error = -ENOMEM;
+	goto out;
+
+ overflow:
+	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
+	printk(KERN_WARNING
+	       "Unable to attach sg device <%d, %d, %d, %d> type=%d, minor "
+	       "number exceeds %d\n", scsidp->host->host_no, scsidp->channel,
+	       scsidp->id, scsidp->lun, scsidp->type, SG_MAX_DEVS - 1);
+	error = -ENODEV;
+	goto out;
+}
+
+static int
+sg_add(struct class_device *cl_dev)
+{
+	struct scsi_device *scsidp = to_scsi_device(cl_dev->dev);
+	struct gendisk *disk;
+	Sg_device *sdp = NULL;
+	struct cdev * cdev = NULL;
+	int error, k;
+
+	disk = alloc_disk(1);
+	if (!disk) {
+		printk(KERN_WARNING "alloc_disk failed\n");
+		return -ENOMEM;
+	}
+	disk->major = SCSI_GENERIC_MAJOR;
+
+	error = -ENOMEM;
+	cdev = cdev_alloc();
+	if (!cdev) {
+		printk(KERN_WARNING "cdev_alloc failed\n");
+		goto out;
+	}
+	cdev->owner = THIS_MODULE;
+	cdev->ops = &sg_fops;
+
+	error = sg_alloc(disk, scsidp);
+	if (error < 0) {
+		printk(KERN_WARNING "sg_alloc failed\n");
+		goto out;
+	}
+	k = error;
+	sdp = sg_dev_arr[k];
 
 	devfs_mk_cdev(MKDEV(SCSI_GENERIC_MAJOR, k),
 			S_IFCHR | S_IRUSR | S_IWUSR | S_IRGRP,
@@ -1526,7 +1532,7 @@
 		put_disk(sdp->disk);
 		sdp->disk = NULL;
 		if (NULL == sdp->headfp)
-			vfree((char *) sdp);
+			kfree((char *) sdp);
 	}
 
 	if (delay)
@@ -1543,6 +1549,7 @@
 MODULE_AUTHOR("Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI generic (sg) driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(SG_VERSION_STR);
 
 MODULE_PARM_DESC(def_reserved_size, "size of buffer reserved for each fd");
 MODULE_PARM_DESC(allow_dio, "allow direct I/O (default: 0 (disallow))");
@@ -1590,7 +1597,7 @@
 	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0),
 				 SG_MAX_DEVS);
 	if (sg_dev_arr != NULL) {
-		vfree((char *) sg_dev_arr);
+		kfree((char *) sg_dev_arr);
 		sg_dev_arr = NULL;
 	}
 	sg_dev_max = 0;
@@ -2495,7 +2502,7 @@
 			}
 			if (k < maxd)
 				sg_dev_arr[k] = NULL;
-			vfree((char *) sdp);
+			kfree((char *) sdp);
 			res = 1;
 		}
 		write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
@@ -2844,7 +2851,8 @@
 
 static int sg_proc_seq_show_version(struct seq_file *s, void *v)
 {
-	seq_printf(s, "%d\t%s\n", sg_version_num, sg_version_str);
+	seq_printf(s, "%d\t%s [%s]\n", sg_version_num, SG_VERSION_STR,
+		   sg_version_date);
 	return 0;
 }
 

--------------090901010408080203090009--

