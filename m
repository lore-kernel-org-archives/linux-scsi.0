From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] proper replacements for ->proc_info
Date: Fri, 25 Apr 2003 12:27:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030425122754.A5030@lst.de>
References: <20030423212157.A18850@lst.de> <1051126145.1970.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:61197 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263205AbTDYKPw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 06:15:52 -0400
Content-Disposition: inline
In-Reply-To: <1051126145.1970.7.camel@mulgrave>; from James.Bottomley@SteelEye.com on Wed, Apr 23, 2003 at 03:29:01PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Apr 23, 2003 at 03:29:01PM -0400, James Bottomley wrote:
> On Wed, 2003-04-23 at 15:21, Christoph Hellwig wrote:
> > Two new host template methods:
> > 
> >      int (* show_info)(struct Scsi_Host *, struct seq_file *);
> >      int (* store_info)(struct Scsi_Host *, const char *, size_t);
> 
> 
> Well, this does look good, but by extension we could use something like
> this as a generic way to ship information to and from sysfs as well.
> 
> How about adding a "char *property" qualifier?  If it's null you just
> dump the whole lot (for /proc) but if it has a value, it's that specific
> property from sysfs.

Okay, after our off-list discussion here's a revised patch.  This one
removes ->store_info.  Most of the users of writing to the proc file
should be converted to sysfs for their parameters instead, and those
that do other things than that need an explicit mangment misc device
or something similar.

I've replaced aic7xx as example driver with 53c700 as aic7xxx falls
into the category of a complex write handler above.


--- 1.27/drivers/scsi/53c700.c	Mon Apr 21 18:03:28 2003
+++ edited/drivers/scsi/53c700.c	Thu Apr 24 13:19:42 2003
@@ -124,7 +124,7 @@
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <linux/sched.h>
-#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <asm/dma.h>
 #include <asm/system.h>
 #include <asm/io.h>
@@ -166,7 +166,7 @@
 STATIC int NCR_700_bus_reset(Scsi_Cmnd * SCpnt);
 STATIC int NCR_700_dev_reset(Scsi_Cmnd * SCpnt);
 STATIC int NCR_700_host_reset(Scsi_Cmnd * SCpnt);
-STATIC int NCR_700_proc_directory_info(char *, char **, off_t, int, int, int);
+STATIC int NCR_700_show_info(struct Scsi_Host *host, struct seq_file *s);
 STATIC void NCR_700_chip_setup(struct Scsi_Host *host);
 STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
 STATIC int NCR_700_slave_configure(Scsi_Device *SDpnt);
@@ -274,7 +274,7 @@
 	tpnt->sg_tablesize = NCR_700_SG_SEGMENTS;
 	tpnt->cmd_per_lun = NCR_700_CMD_PER_LUN;
 	tpnt->use_clustering = DISABLE_CLUSTERING;
-	tpnt->proc_info = NCR_700_proc_directory_info;
+	tpnt->show_info = NCR_700_show_info;
 	tpnt->slave_configure = NCR_700_slave_configure;
 	tpnt->slave_destroy = NCR_700_slave_destroy;
 	tpnt->use_blk_tcq = 1;
@@ -1703,41 +1703,27 @@
 	return retval;
 }
 
-/* FIXME: Need to put some proc information in and plumb it
- * into the scsi proc system */
 STATIC int
-NCR_700_proc_directory_info(char *proc_buf, char **startp,
-			 off_t offset, int bytes_available,
-			 int host_no, int write)
+NCR_700_show_info(struct Scsi_Host *host, struct seq_file *s)
 {
-	static char buf[4096];	/* 1 page should be sufficient */
-	int len = 0;
-	struct Scsi_Host *host;
 	struct NCR_700_Host_Parameters *hostdata;
-	Scsi_Device *SDp;
-
-	host = scsi_host_hn_get(host_no);
-	if(host == NULL)
-		return 0;
+	struct scsi_device *sdev;
 
-	if(write) {
-		/* FIXME: Clear internal statistics here */
-		return 0;
-	}
 	hostdata = (struct NCR_700_Host_Parameters *)host->hostdata[0];
-	len += sprintf(&buf[len], "Total commands outstanding: %d\n", hostdata->command_slot_count);
-	len += sprintf(&buf[len],"\
+
+	seq_printf(s,  "Total commands outstanding: %d\n",
+			hostdata->command_slot_count);
+	seq_printf(s, "\
 Target	Active  Next Tag\n\
 ======	======  ========\n");
-	list_for_each_entry(SDp, &host->my_devices, siblings) {
-		len += sprintf(&buf[len]," %2d:%2d   %4d      %4d\n", SDp->id, SDp->lun, NCR_700_get_depth(SDp), SDp->current_tag);
+	list_for_each_entry(sdev, &host->my_devices, siblings) {
+		seq_printf(s, " %2d:%2d   %4d      %4d\n",
+				sdev->id, sdev->lun,
+				NCR_700_get_depth(sdev),
+				sdev->current_tag);
 	}
-	if((len -= offset) <= 0)
-		return 0;
-	if(len > bytes_available)
-		len = bytes_available;
-	memcpy(proc_buf, buf + offset, len);
-	return len;
+
+	return 0;
 }
 
 STATIC int
--- 1.58/drivers/scsi/hosts.h	Mon Mar 24 07:14:28 2003
+++ edited/drivers/scsi/hosts.h	Wed Apr 23 22:45:29 2003
@@ -63,13 +63,6 @@
     /* The pointer to the /proc/scsi directory entry */
     struct proc_dir_entry *proc_dir;
 
-    /* proc-fs info function.
-     * Can be used to export driver statistics and other infos to the world
-     * outside the kernel ie. userspace and it also provides an interface
-     * to feed the driver with information. Check eata_dma_proc.c for reference
-     */
-    int (*proc_info)(char *, char **, off_t, int, int, int);
-
     /*
      * The name pointer is a pointer to the name of the SCSI
      * device detected.
@@ -265,6 +258,17 @@
      */
     int (* bios_param)(struct scsi_device *, struct block_device *,
 		    sector_t, int []);
+
+    /*
+     * Show host information in /proc/scsi/<driver>/<host>.
+     * Optional.
+     */
+    int (* show_info)(struct Scsi_Host *, struct seq_file *);
+
+    /*
+     * DON'T USE.
+     */
+    int (* proc_info)(char *, char **, off_t, int, int, int);
 
     /*
      * This determines if we will use a non-interrupt driven
--- 1.31/drivers/scsi/scsi_debug.c	Mon Mar 31 15:52:02 2003
+++ edited/drivers/scsi/scsi_debug.c	Thu Apr 24 13:24:09 2003
@@ -36,7 +36,7 @@
 #include <linux/genhd.h>
 #include <linux/fs.h>
 #include <linux/init.h>
-#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
 #include <linux/moduleparam.h>
@@ -866,7 +867,7 @@
 static void timer_intr_handler(unsigned long indx)
 {
 	struct sdebug_queued_cmd * sqcp;
-	unsigned int iflags;
+	unsigned long iflags;
 
 	if (indx >= SCSI_DEBUG_CANQUEUE) {
 		printk(KERN_ERR "scsi_debug:timer_intr_handler: indx too "
@@ -1229,34 +1230,9 @@
 	return sdebug_info;
 }
 
-/* scsi_debug_proc_info
- * Used if the driver currently has no own support for /proc/scsi
- */
-static int scsi_debug_proc_info(char *buffer, char **start, off_t offset,
-				int length, int inode, int inout)
+static int scsi_debug_show_info(struct Scsi_Host *shost, struct seq_file *s)
 {
-	int len, pos, begin;
-	int orig_length;
-
-	orig_length = length;
-
-	if (inout == 1) {
-		char arr[16];
-		int minLen = length > 15 ? 15 : length;
-
-		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
-			return -EACCES;
-		memcpy(arr, buffer, minLen);
-		arr[minLen] = '\0';
-		if (1 != sscanf(arr, "%d", &pos))
-			return -EINVAL;
-		scsi_debug_opts = pos;
-		if (scsi_debug_every_nth > 0)
-                        scsi_debug_cmnd_count = 0;
-		return length;
-	}
-	begin = 0;
-	pos = len = sprintf(buffer, "scsi_debug adapter driver, %s\n"
+	seq_printf(s, "scsi_debug adapter driver, %s\n"
 	    "num_tgts=%d, shared (ram) size=%d MB, opts=0x%x, "
 	    "every_nth=%d(curr:%d)\n"
 	    "delay=%d, max_luns=%d, scsi_level=%d\n"
@@ -1269,15 +1245,8 @@
 	    scsi_debug_max_luns, scsi_debug_scsi_level,
 	    SECT_SIZE, sdebug_cylinders_per, sdebug_heads, sdebug_sectors_per,
 	    num_aborts, num_dev_resets, num_bus_resets, num_host_resets);
-	if (pos < offset) {
-		len = 0;
-		begin = pos;
-	}
-	*start = buffer + (offset - begin);	/* Start of wanted data */
-	len -= (offset - begin);
-	if (len > length)
-		len = length;
-	return len;
+
+	return 0;
 }
 
 static ssize_t sdebug_delay_show(struct device_driver * ddp, char * buf) 
--- 1.12/drivers/scsi/scsi_debug.h	Sun Mar 16 10:05:12 2003
+++ edited/drivers/scsi/scsi_debug.h	Thu Apr 24 13:24:22 2003
@@ -14,7 +14,7 @@
 static int scsi_debug_bus_reset(struct scsi_cmnd *);
 static int scsi_debug_device_reset(struct scsi_cmnd *);
 static int scsi_debug_host_reset(struct scsi_cmnd *);
-static int scsi_debug_proc_info(char *, char **, off_t, int, int, int);
+static int scsi_debug_show_info(struct Scsi_Host *, struct seq_file *);
 static const char * scsi_debug_info(struct Scsi_Host *);
 
 /*
@@ -25,7 +25,7 @@
 #define SCSI_DEBUG_MAX_CMD_LEN 16
 
 static Scsi_Host_Template sdebug_driver_template = {
-	.proc_info =		scsi_debug_proc_info,
+	.show_info =		scsi_debug_show_info,
 	.name =			"SCSI DEBUG",
 	.info =			scsi_debug_info,
 	.slave_alloc =		scsi_debug_slave_alloc,
--- 1.18/drivers/scsi/scsi_proc.c	Sun Feb 23 13:34:56 2003
+++ edited/drivers/scsi/scsi_proc.c	Thu Apr 24 12:33:20 2003
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
 #include <linux/errno.h>
+#include <linux/seq_file.h>
 #include <linux/blk.h>
 #include <asm/uaccess.h>
 
@@ -37,6 +39,24 @@
 EXPORT_SYMBOL(proc_scsi);
 
 
+static int proc_host_show(struct seq_file *m, void *v)
+{
+	struct Scsi_Host *shost = m->private;
+	return shost->hostt->show_info(shost, m);
+}
+
+static int proc_host_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_host_show, PDE(inode)->data);
+}
+
+static struct file_operations proc_host_operations = {
+	.open		= proc_host_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = single_release,
+};
+
 /* Used if the driver currently has no own support for /proc/scsi */
 static int generic_proc_info(char *buffer, char **start, off_t offset,
 			     int count, const char *(*info)(struct Scsi_Host *),
@@ -124,19 +144,24 @@
 		sht->proc_dir->owner = sht->module;
 	}
 
-	sprintf(name,"%d", shost->host_no);
-	p = create_proc_read_entry(name, S_IFREG | S_IRUGO | S_IWUSR,
-			shost->hostt->proc_dir, proc_scsi_read, shost);
-	if (!p) {
-		printk(KERN_ERR "%s: Failed to register host %d in"
-		       "%s\n", __FUNCTION__, shost->host_no,
-		       shost->hostt->proc_name);
-		return;
+	sprintf(name, "%d", shost->host_no);
+	p = create_proc_entry(name, S_IFREG | S_IRUGO | S_IWUSR,
+				shost->hostt->proc_dir);
+	if (p) {
+		p->owner = shost->hostt->module;
+		p->data = shost;
+
+		if (sht->show_info) {
+			p->proc_fops = &proc_host_operations;
+		} else {
+			p->read_proc = proc_scsi_read;
+			p->write_proc = proc_scsi_write;
+		}
+	} else {
+		printk(KERN_ERR
+		    "Failed to register scsi%d with procfs.\n",
+		    shost->host_no);
 	} 
-
-	p->write_proc = proc_scsi_write;
-	p->owner = shost->hostt->module;
-
 }
 
 void scsi_proc_host_rm(struct Scsi_Host *shost)
