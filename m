From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Fw: 2.6.6-rc3 ia64 smp_call_function() called with interrupts
 disabled
Date: Thu, 13 May 2004 21:56:54 +1000
Sender: linux-ia64-owner@vger.kernel.org
Message-ID: <40A36286.4020604@torque.net>
References: <20040502214525.5ad05bed.akpm@osdl.org> <20040503122948.GI2281@parcelfarce.linux.theplanet.co.uk> <20040503203512.GP2281@parcelfarce.linux.theplanet.co.uk>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070404030304070004020001"
Return-path: <linux-ia64-owner@vger.kernel.org>
In-Reply-To: <20040503203512.GP2281@parcelfarce.linux.theplanet.co.uk>
To: Matthew Wilcox <willy@debian.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org, James.Bottomley@steeleye.com
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070404030304070004020001
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Matthew Wilcox wrote:
> On Mon, May 03, 2004 at 01:29:48PM +0100, Matthew Wilcox wrote:
> 
>>How about the following patch?  Noet that vfree() handles a NULL argument,
>>so it's not necessary to check the pointer.
> 
> 
> That patch is crap -- it only frees the memory on the error path, not
> the normal exit.  Since I got confused by this function, it struck me
> as not unreasonable that somebody else might also get confused by it
> and split it into two parts.
> 
> I simplified some of the code.  The old code took the lock, scanned
> through looking for a free slot, dropped the lock, allocated an sdp,
> grabbed the lock and checked the slot was still free, branching back
> if it had raced.  This rewrite assumes that we will find a slot and
> allocates an sdp in advance.
> 
> Does anybody like this patch?  It survived booting on my test box which
> only has one scsi device.  More testing welcomed.

Sorry, I missed this thread. The change looks good and survived
about one hour of scsi_debug bashing (on i386). I also checked
it against the previous version.

Attached is my version with only a superficial change to 2
printk()s plus:
   - bump version number
   - introduce MODULE_VERSION
   - increase over allocation of sg_dev_arr from 6 to 32

Doug Gilbert

--------------070404030304070004020001
Content-Type: text/plain;
 name="sg266mw2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg266mw2.diff"

--- linux/drivers/scsi/sg.c	2004-05-10 23:08:46.000000000 +1000
+++ linux/drivers/scsi/sg.c266mw2	2004-05-13 14:56:06.000000000 +1000
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
@@ -69,7 +60,7 @@
 
 #ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
-static char *sg_version_str = "3.5.30 [20040124]";
+static char *sg_version_date = "20040513";
 
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
@@ -110,7 +101,7 @@
 #define SG_SECTOR_SZ 512
 #define SG_SECTOR_MSK (SG_SECTOR_SZ - 1)
 
-#define SG_DEV_ARR_LUMP 6	/* amount to over allocate sg_dev_arr by */
+#define SG_DEV_ARR_LUMP 32	/* amount to over allocate sg_dev_arr by */
 
 static int sg_add(struct class_device *);
 static void sg_remove(struct class_device *);
@@ -1333,85 +1324,44 @@
 
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
+	sdp = vmalloc(sizeof(Sg_device));
+	if (!sdp)
 		return -ENOMEM;
 
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
+		tmp_da = vmalloc(tmp_dev_max * sizeof(Sg_device *));
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
@@ -1421,6 +1371,55 @@
 	sg_nr_dev++;
 	sg_dev_arr[k] = sdp;
 	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
+	error = k;
+
+ out:
+	if (error < 0)
+		vfree(sdp);
+	vfree(old_sg_dev_arr);
+	return error;
+
+ expand_failed:
+	printk(KERN_ERR "sg_alloc: device array cannot be resized\n");
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
+	if (!disk)
+		return -ENOMEM;
+	disk->major = SCSI_GENERIC_MAJOR;
+
+	error = -ENOMEM;
+	cdev = cdev_alloc();
+	if (!cdev)
+		goto out;
+	cdev->owner = THIS_MODULE;
+	cdev->ops = &sg_fops;
+
+	error = sg_alloc(disk, scsidp);
+	if (error < 0)
+		goto out;
+	k = error;
+	sdp = sg_dev_arr[k];
 
 	devfs_mk_cdev(MKDEV(SCSI_GENERIC_MAJOR, k),
 			S_IFCHR | S_IRUSR | S_IWUSR | S_IRGRP,
@@ -1543,6 +1542,7 @@
 MODULE_AUTHOR("Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI generic (sg) driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(SG_VERSION_STR);
 
 MODULE_PARM_DESC(def_reserved_size, "size of buffer reserved for each fd");
 MODULE_PARM_DESC(allow_dio, "allow direct I/O (default: 0 (disallow))");
@@ -2844,7 +2844,8 @@
 
 static int sg_proc_seq_show_version(struct seq_file *s, void *v)
 {
-	seq_printf(s, "%d\t%s\n", sg_version_num, sg_version_str);
+	seq_printf(s, "%d\t%s [%s]\n", sg_version_num, SG_VERSION_STR,
+		   sg_version_date);
 	return 0;
 }
 

--------------070404030304070004020001--

