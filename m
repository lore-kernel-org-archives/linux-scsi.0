From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] proper replacements for ->proc_info
Date: Wed, 23 Apr 2003 21:21:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030423212157.A18850@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:60941 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S264412AbTDWTJ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Apr 2003 15:09:58 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Two new host template methods:

     int (* show_info)(struct Scsi_Host *, struct seq_file *);
     int (* store_info)(struct Scsi_Host *, const char *, size_t);

First one is used for reading of /proc/scsi/<driver>/<host>, second
for writing.  They get an explicit hosy pointer instead of the
integer number.  Read side outputs into the simple version of the
seq_file interface so lots of crappy string handling can go away,
write side isn't much different from the old version, just properly
split out.

->proc_info continues to work but I hope to move over all drivers
before 2.6.

scsi_debug and aic7xxx are the example drivers in this patch, more
will follow very soon.

btw, even this first patch already removes more code than it adds..


--- 1.58/drivers/scsi/hosts.h	Mon Mar 24 07:14:28 2003
+++ edited/drivers/scsi/hosts.h	Wed Apr 23 11:24:33 2003
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
@@ -265,6 +258,23 @@
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
+     * Allow user-commands to be written to /proc/scsi/<driver>/<host>.
+     * Optional.
+     */
+    int (* store_info)(struct Scsi_Host *, const char *, size_t);
+
+    /*
+     * Obsolete interface version of the two above.
+     */
+    int (* proc_info)(char *, char **, off_t, int, int, int);
 
     /*
      * This determines if we will use a non-interrupt driven
--- 1.31/drivers/scsi/scsi_debug.c	Mon Mar 31 15:52:02 2003
+++ edited/drivers/scsi/scsi_debug.c	Wed Apr 23 12:20:46 2003
@@ -40,6 +40,7 @@
 #include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
 #include <linux/moduleparam.h>
+#include <linux/seq_file.h>
 
 #include <linux/blk.h>
 #include "scsi.h"
@@ -1229,34 +1231,29 @@
 	return sdebug_info;
 }
 
-/* scsi_debug_proc_info
- * Used if the driver currently has no own support for /proc/scsi
- */
-static int scsi_debug_proc_info(char *buffer, char **start, off_t offset,
-				int length, int inode, int inout)
+static int scsi_debug_store_info(struct Scsi_Host *shost,
+				 const char *buffer, size_t length)
 {
-	int len, pos, begin;
-	int orig_length;
+	int minLen = length > 15 ? 15 : length, pos;
+	char arr[16];
 
-	orig_length = length;
+	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
+		return -EACCES;
 
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
+	memcpy(arr, buffer, minLen);
+	arr[minLen] = '\0';
+	if (1 != sscanf(arr, "%d", &pos))
+		return -EINVAL;
+	scsi_debug_opts = pos;
+	if (scsi_debug_every_nth > 0)
+                       scsi_debug_cmnd_count = 0;
+
+	return length;
+}
+
+static int scsi_debug_show_info(struct Scsi_Host *shost, struct seq_file *s)
+{
+	seq_printf(s, "scsi_debug adapter driver, %s\n"
 	    "num_tgts=%d, shared (ram) size=%d MB, opts=0x%x, "
 	    "every_nth=%d(curr:%d)\n"
 	    "delay=%d, max_luns=%d, scsi_level=%d\n"
@@ -1269,15 +1266,8 @@
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
+++ edited/drivers/scsi/scsi_debug.h	Wed Apr 23 12:18:49 2003
@@ -14,7 +14,8 @@
 static int scsi_debug_bus_reset(struct scsi_cmnd *);
 static int scsi_debug_device_reset(struct scsi_cmnd *);
 static int scsi_debug_host_reset(struct scsi_cmnd *);
-static int scsi_debug_proc_info(char *, char **, off_t, int, int, int);
+static int scsi_debug_store_info(struct Scsi_Host *, const char *, size_t);
+static int scsi_debug_show_info(struct Scsi_Host *, struct seq_file *);
 static const char * scsi_debug_info(struct Scsi_Host *);
 
 /*
@@ -25,7 +26,8 @@
 #define SCSI_DEBUG_MAX_CMD_LEN 16
 
 static Scsi_Host_Template sdebug_driver_template = {
-	.proc_info =		scsi_debug_proc_info,
+	.show_info =		scsi_debug_show_info,
+	.store_info =		scsi_debug_store_info,
 	.name =			"SCSI DEBUG",
 	.info =			scsi_debug_info,
 	.slave_alloc =		scsi_debug_slave_alloc,
--- 1.18/drivers/scsi/scsi_proc.c	Sun Feb 23 13:34:56 2003
+++ edited/drivers/scsi/scsi_proc.c	Wed Apr 23 13:55:26 2003
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
 #include <linux/errno.h>
+#include <linux/seq_file.h>
 #include <linux/blk.h>
 #include <asm/uaccess.h>
 
@@ -37,6 +39,58 @@
 EXPORT_SYMBOL(proc_scsi);
 
 
+static int proc_host_write(struct file *file, const char *buf,
+			   size_t count, loff_t *ppos)
+{
+	struct seq_file *m = file->private_data;
+	struct Scsi_Host *shost = m->private;
+	ssize_t res = -EFAULT;
+	char *page;
+
+	if (count > PROC_BLOCK_SIZE)
+		return -EOVERFLOW;
+
+	page = (char *)__get_free_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+
+	if (!copy_from_user(page, buf, count))
+		res = shost->hostt->store_info(shost, page, count);
+	free_page((unsigned long)page);
+	return res;
+}
+
+static int proc_host_show(struct seq_file *m, void *v)
+{
+	struct Scsi_Host *shost = m->private;
+	return shost->hostt->show_info(shost, m);
+}
+
+/*
+ * We need the seq_file even for O_WRONLY because proc_host_write
+ * dereferences it to get the host.  Storing the host directly in
+ * file->private_data would make O_RDWR impossible.
+ */
+static int proc_host_open(struct inode *inode, struct file *file)
+{
+	struct Scsi_Host *shost = PDE(inode)->data;
+
+	if ((file->f_mode & FMODE_READ) && !shost->hostt->show_info)
+		return -ENOSYS;
+	if ((file->f_mode & FMODE_WRITE) && !shost->hostt->store_info)
+		return -ENOSYS;
+
+	return single_open(file, proc_host_show, shost);
+}
+
+static struct file_operations proc_host_operations = {
+	.open		= proc_host_open,
+	.read           = seq_read,
+	.write		= proc_host_write,
+	.llseek         = seq_lseek,
+	.release        = single_release,
+};
+
 /* Used if the driver currently has no own support for /proc/scsi */
 static int generic_proc_info(char *buffer, char **start, off_t offset,
 			     int count, const char *(*info)(struct Scsi_Host *),
@@ -124,19 +178,24 @@
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
+		if (sht->show_info || sht->store_info) {
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
--- 1.28/drivers/scsi/aic7xxx/aic7xxx_osm.c	Sun Apr 20 17:14:29 2003
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.c	Wed Apr 23 12:29:37 2003
@@ -1268,7 +1268,8 @@
 Scsi_Host_Template aic7xxx_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "aic7xxx",
-	.proc_info		= ahc_linux_proc_info,
+	.show_info		= ahc_linux_show_info,
+	.store_info		= ahc_linux_store_info,
 	.info			= ahc_linux_info,
 	.queuecommand		= ahc_linux_queue,
 	.eh_abort_handler	= ahc_linux_abort,
@@ -4071,12 +4072,15 @@
 			printf("*): ");
 		else
 			printf("%d): ", target);
+#if 0	/* XXX(hch): need to come up with some fake seq_file stuff
+	   	     for this.  Should probably go into seq_file.c */
 		ahc_format_transinfo(&info, &tinfo->curr);
 		if (info.pos < info.length)
 			*info.buffer = '\0';
 		else
 			buf[info.length - 1] = '\0';
 		printf("%s", buf);
+#endif
 		break;
 	}
         case AC_SENT_BDR:
--- 1.35/drivers/scsi/aic7xxx/aic7xxx_osm.h	Sun Apr 20 17:14:29 2003
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.h	Wed Apr 23 12:31:01 2003
@@ -68,6 +68,7 @@
 #include <linux/smp_lock.h>
 #include <linux/version.h>
 #include <linux/module.h>
+#include <linux/seq_file.h>
 #include <asm/byteorder.h>
 #include <asm/io.h>
 
@@ -673,7 +674,7 @@
 	int pos;
 };
 
-void	ahc_format_transinfo(struct info_str *info,
+void	ahc_format_transinfo(struct seq_file *s,
 			     struct ahc_transinfo *tinfo);
 
 /******************************** Locking *************************************/
@@ -1022,7 +1023,9 @@
 	(((dev_softc)->dma_mask = mask) && 0)
 #endif
 /**************************** Proc FS Support *********************************/
-int	ahc_linux_proc_info(char *, char **, off_t, int, int, int);
+int	ahc_linux_show_info(struct Scsi_Host *host, struct seq_file *s);
+int	ahc_linux_store_info(struct Scsi_Host *host,
+				       const char *buffer, size_t length);
 
 /*************************** Domain Validation ********************************/
 #define AHC_DV_CMD(cmd) ((cmd)->scsi_done == ahc_linux_dv_complete)
===== drivers/scsi/aic7xxx/aic7xxx_proc.c 1.7 vs edited =====
--- 1.7/drivers/scsi/aic7xxx/aic7xxx_proc.c	Thu Feb 20 17:50:09 2003
+++ edited/drivers/scsi/aic7xxx/aic7xxx_proc.c	Wed Apr 23 12:32:47 2003
@@ -43,61 +43,15 @@
 #include "aic7xxx_inline.h"
 #include "aic7xxx_93cx6.h"
 
-static void	copy_mem_info(struct info_str *info, char *data, int len);
-static int	copy_info(struct info_str *info, char *fmt, ...);
 static void	ahc_dump_target_state(struct ahc_softc *ahc,
-				      struct info_str *info,
+				      struct seq_file *s,
 				      u_int our_id, char channel,
 				      u_int target_id, u_int target_offset);
-static void	ahc_dump_device_state(struct info_str *info,
+static void	ahc_dump_device_state(struct seq_file *s,
 				      struct ahc_linux_device *dev);
-static int	ahc_proc_write_seeprom(struct ahc_softc *ahc,
-				       char *buffer, int length);
-
-static void
-copy_mem_info(struct info_str *info, char *data, int len)
-{
-	if (info->pos + len > info->offset + info->length)
-		len = info->offset + info->length - info->pos;
-
-	if (info->pos + len < info->offset) {
-		info->pos += len;
-		return;
-	}
-
-	if (info->pos < info->offset) {
-		off_t partial;
-
-		partial = info->offset - info->pos;
-		data += partial;
-		info->pos += partial;
-		len  -= partial;
-	}
-
-	if (len > 0) {
-		memcpy(info->buffer, data, len);
-		info->pos += len;
-		info->buffer += len;
-	}
-}
-
-static int
-copy_info(struct info_str *info, char *fmt, ...)
-{
-	va_list args;
-	char buf[256];
-	int len;
-
-	va_start(args, fmt);
-	len = vsprintf(buf, fmt, args);
-	va_end(args);
-
-	copy_mem_info(info, buf, len);
-	return (len);
-}
 
 void
-ahc_format_transinfo(struct info_str *info, struct ahc_transinfo *tinfo)
+ahc_format_transinfo(struct seq_file *s, struct ahc_transinfo *tinfo)
 {
 	u_int speed;
 	u_int freq;
@@ -112,12 +66,12 @@
 	speed *= (0x01 << tinfo->width);
         mb = speed / 1000;
         if (mb > 0)
-		copy_info(info, "%d.%03dMB/s transfers", mb, speed % 1000);
+		seq_printf(s, "%d.%03dMB/s transfers", mb, speed % 1000);
         else
-		copy_info(info, "%dKB/s transfers", speed);
+		seq_printf(s, "%dKB/s transfers", speed);
 
 	if (freq != 0) {
-		copy_info(info, " (%d.%03dMHz%s, offset %d",
+		seq_printf(s, " (%d.%03dMHz%s, offset %d",
 			 freq / 1000, freq % 1000,
 			 (tinfo->ppr_options & MSG_EXT_PPR_DT_REQ) != 0
 			 ? " DT" : "", tinfo->offset);
@@ -125,19 +79,19 @@
 
 	if (tinfo->width > 0) {
 		if (freq != 0) {
-			copy_info(info, ", ");
+			seq_printf(s, ", ");
 		} else {
-			copy_info(info, " (");
+			seq_printf(s, " (");
 		}
-		copy_info(info, "%dbit)", 8 * (0x01 << tinfo->width));
+		seq_printf(s, "%dbit)", 8 * (0x01 << tinfo->width));
 	} else if (freq != 0) {
-		copy_info(info, ")");
+		seq_printf(s, ")");
 	}
-	copy_info(info, "\n");
+	seq_printf(s, "\n");
 }
 
 static void
-ahc_dump_target_state(struct ahc_softc *ahc, struct info_str *info,
+ahc_dump_target_state(struct ahc_softc *ahc, struct seq_file *s,
 		      u_int our_id, char channel, u_int target_id,
 		      u_int target_offset)
 {
@@ -148,18 +102,18 @@
 
 	tinfo = ahc_fetch_transinfo(ahc, channel, our_id,
 				    target_id, &tstate);
-	copy_info(info, "Channel %c Target %d Negotiation Settings\n",
+	seq_printf(s, "Channel %c Target %d Negotiation Settings\n",
 		  channel, target_id);
-	copy_info(info, "\tUser: ");
-	ahc_format_transinfo(info, &tinfo->user);
+	seq_printf(s, "\tUser: ");
+	ahc_format_transinfo(s, &tinfo->user);
 	targ = ahc->platform_data->targets[target_offset];
 	if (targ == NULL)
 		return;
 
-	copy_info(info, "\tGoal: ");
-	ahc_format_transinfo(info, &tinfo->goal);
-	copy_info(info, "\tCurr: ");
-	ahc_format_transinfo(info, &tinfo->curr);
+	seq_printf(s, "\tGoal: ");
+	ahc_format_transinfo(s, &tinfo->goal);
+	seq_printf(s, "\tCurr: ");
+	ahc_format_transinfo(s, &tinfo->curr);
 
 	for (lun = 0; lun < AHC_NUM_LUNS; lun++) {
 		struct ahc_linux_device *dev;
@@ -169,26 +123,28 @@
 		if (dev == NULL)
 			continue;
 
-		ahc_dump_device_state(info, dev);
+		ahc_dump_device_state(s, dev);
 	}
 }
 
 static void
-ahc_dump_device_state(struct info_str *info, struct ahc_linux_device *dev)
+ahc_dump_device_state(struct seq_file *s, struct ahc_linux_device *dev)
 {
-	copy_info(info, "\tChannel %c Target %d Lun %d Settings\n",
+	seq_printf(s, "\tChannel %c Target %d Lun %d Settings\n",
 		  dev->target->channel + 'A', dev->target->target, dev->lun);
 
-	copy_info(info, "\t\tCommands Queued %ld\n", dev->commands_issued);
-	copy_info(info, "\t\tCommands Active %d\n", dev->active);
-	copy_info(info, "\t\tCommand Openings %d\n", dev->openings);
-	copy_info(info, "\t\tMax Tagged Openings %d\n", dev->maxtags);
-	copy_info(info, "\t\tDevice Queue Frozen Count %d\n", dev->qfrozen);
+	seq_printf(s, "\t\tCommands Queued %ld\n", dev->commands_issued);
+	seq_printf(s, "\t\tCommands Active %d\n", dev->active);
+	seq_printf(s, "\t\tCommand Openings %d\n", dev->openings);
+	seq_printf(s, "\t\tMax Tagged Openings %d\n", dev->maxtags);
+	seq_printf(s, "\t\tDevice Queue Frozen Count %d\n", dev->qfrozen);
 }
 
-static int
-ahc_proc_write_seeprom(struct ahc_softc *ahc, char *buffer, int length)
+int
+ahc_linux_store_info(struct Scsi_Host *host,
+		const char *buffer, size_t length)
 {
+	struct ahc_softc *ahc = *(struct ahc_softc **)host->hostdata;
 	struct seeprom_descriptor sd;
 	int have_seeprom;
 	u_long s;
@@ -288,61 +244,33 @@
  * Return information to handle /proc support for the driver.
  */
 int
-ahc_linux_proc_info(char *buffer, char **start, off_t offset,
-		  int length, int hostno, int inout)
+ahc_linux_show_info(struct Scsi_Host *host, struct seq_file *s)
 {
-	struct	ahc_softc *ahc;
-	struct	info_str info;
+	struct ahc_softc *ahc = *(struct ahc_softc **)host->hostdata;
 	char	ahc_info[256];
-	u_long	s;
 	u_int	max_targ;
 	u_int	i;
-	int	retval;
-
-	retval = -EINVAL;
-	ahc_list_lock(&s);
-	TAILQ_FOREACH(ahc, &ahc_tailq, links) {
-		if (ahc->platform_data->host->host_no == hostno)
-			break;
-	}
-
-	if (ahc == NULL)
-		goto done;
 
-	 /* Has data been written to the file? */ 
-	if (inout == TRUE) {
-		retval = ahc_proc_write_seeprom(ahc, buffer, length);
-		goto done;
-	}
-
-	if (start)
-		*start = buffer;
-
-	info.buffer	= buffer;
-	info.length	= length;
-	info.offset	= offset;
-	info.pos	= 0;
-
-	copy_info(&info, "Adaptec AIC7xxx driver version: %s\n",
-		  AIC7XXX_DRIVER_VERSION);
-	copy_info(&info, "%s\n", ahc->description);
+	seq_printf(s, "Adaptec AIC7xxx driver version: %s\n",
+			AIC7XXX_DRIVER_VERSION);
+	seq_printf(s, "%s\n", ahc->description);
 	ahc_controller_info(ahc, ahc_info);
-	copy_info(&info, "%s\n\n", ahc_info);
+	seq_printf(s, "%s\n\n", ahc_info);
 
 	if (ahc->seep_config == NULL)
-		copy_info(&info, "No Serial EEPROM\n");
+		seq_printf(s, "No Serial EEPROM\n");
 	else {
-		copy_info(&info, "Serial EEPROM:\n");
+		seq_printf(s, "Serial EEPROM:\n");
 		for (i = 0; i < sizeof(*ahc->seep_config)/2; i++) {
 			if (((i % 8) == 0) && (i != 0)) {
-				copy_info(&info, "\n");
+				seq_printf(s, "\n");
 			}
-			copy_info(&info, "0x%.4x ",
+			seq_printf(s, "0x%.4x ",
 				  ((uint16_t*)ahc->seep_config)[i]);
 		}
-		copy_info(&info, "\n");
+		seq_printf(s, "\n");
 	}
-	copy_info(&info, "\n");
+	seq_printf(s, "\n");
 
 	max_targ = 15;
 	if ((ahc->features & (AHC_WIDE|AHC_TWIN)) == 0)
@@ -362,11 +290,8 @@
 			target_id = i % 8;
 		}
 
-		ahc_dump_target_state(ahc, &info, our_id,
-				      channel, target_id, i);
+		ahc_dump_target_state(ahc, s, our_id, channel, target_id, i);
 	}
-	retval = info.pos > info.offset ? info.pos - info.offset : 0;
-done:
-	ahc_list_unlock(&s);
-	return (retval);
+
+	return 0;
 }
