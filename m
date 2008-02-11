From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/1] cciss: procfs updates to display info about many volumes
Date: Mon, 11 Feb 2008 16:09:06 -0600
Message-ID: <20080211220906.GA24835@roadking.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:47530 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667AbYBKWJI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Feb 2008 17:09:08 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>

Patch 1 of 1

This patch allows us to display information about all of the logical volumes
configured on a particular without stepping on memory even when there are
many volumes (128 or more) configured. This patch replaces the one submitted
on 20071214. See
http://groups.google.com/group/linux.kernel/browse_thread/thread/49a50244b19f8855/ba3dc95b23391521?hl=en&lnk=gst&q=cciss#ba3dc95b23391521
which has not been merged. That patch displayed information about only the
first logical volume on each controller and had negative side effects for some
installers.
Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
--------------------------------------------------------------------------------
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 9715be3..b7cda85 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -33,6 +33,7 @@
 #include <linux/blkpg.h>
 #include <linux/timer.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/hdreg.h>
 #include <linux/spinlock.h>
@@ -174,8 +175,6 @@ static int sendcmd_withirq(__u8 cmd, int ctlr, void *buff, size_t size,
 static void fail_all_cmds(unsigned long ctlr);
 
 #ifdef CONFIG_PROC_FS
-static int cciss_proc_get_info(char *buffer, char **start, off_t offset,
-			       int length, int *eof, void *data);
 static void cciss_procinit(int i);
 #else
 static void cciss_procinit(int i)
@@ -240,24 +239,44 @@ static inline CommandList_struct *removeQ(CommandList_struct **Qptr,
  */
 #define ENG_GIG 1000000000
 #define ENG_GIG_FACTOR (ENG_GIG/512)
+#define ENGAGE_SCSI	"engage scsi"
 static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
 	"UNKNOWN"
 };
 
 static struct proc_dir_entry *proc_cciss;
 
-static int cciss_proc_get_info(char *buffer, char **start, off_t offset,
-			       int length, int *eof, void *data)
+static void cciss_seq_show_header(struct seq_file *seq)
 {
-	off_t pos = 0;
-	off_t len = 0;
-	int size, i, ctlr;
-	ctlr_info_t *h = (ctlr_info_t *) data;
-	drive_info_struct *drv;
-	unsigned long flags;
-	sector_t vol_sz, vol_sz_frac;
+	ctlr_info_t *h = seq->private;
+
+	seq_printf(seq, "%s: HP %s Controller\n"
+		"Board ID: 0x%08lx\n"
+		"Firmware Version: %c%c%c%c\n"
+		"IRQ: %d\n"
+		"Logical drives: %d\n"
+		"Current Q depth: %d\n"
+		"Current # commands on controller: %d\n"
+		"Max Q depth since init: %d\n"
+		"Max # commands on controller since init: %d\n"
+		"Max SG entries since init: %d\n",
+		h->devname,
+		h->product_name,
+		(unsigned long)h->board_id,
+		h->firm_ver[0], h->firm_ver[1], h->firm_ver[2],
+		h->firm_ver[3], (unsigned int)h->intr[SIMPLE_MODE_INT],
+		h->num_luns,
+		h->Qdepth, h->commands_outstanding,
+		h->maxQsinceinit, h->max_outstanding, h->maxSG);
+
+	cciss_seq_tape_report(seq, h->ctlr);
+}
 
-	ctlr = h->ctlr;
+static void *cciss_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	ctlr_info_t *h = seq->private;
+	unsigned ctlr = h->ctlr;
+	unsigned long flags;
 
 	/* prevent displaying bogus info during configuration
 	 * or deconfiguration of a logical volume
@@ -265,115 +284,150 @@ static int cciss_proc_get_info(char *buffer, char **start, off_t offset,
 	spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
 	if (h->busy_configuring) {
 		spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
-		return -EBUSY;
+		return ERR_PTR(-EBUSY);
 	}
 	h->busy_configuring = 1;
 	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
 
-	size = sprintf(buffer, "%s: HP %s Controller\n"
-		       "Board ID: 0x%08lx\n"
-		       "Firmware Version: %c%c%c%c\n"
-		       "IRQ: %d\n"
-		       "Logical drives: %d\n"
-		       "Max sectors: %d\n"
-		       "Current Q depth: %d\n"
-		       "Current # commands on controller: %d\n"
-		       "Max Q depth since init: %d\n"
-		       "Max # commands on controller since init: %d\n"
-		       "Max SG entries since init: %d\n\n",
-		       h->devname,
-		       h->product_name,
-		       (unsigned long)h->board_id,
-		       h->firm_ver[0], h->firm_ver[1], h->firm_ver[2],
-		       h->firm_ver[3], (unsigned int)h->intr[SIMPLE_MODE_INT],
-		       h->num_luns,
-		       h->cciss_max_sectors,
-		       h->Qdepth, h->commands_outstanding,
-		       h->maxQsinceinit, h->max_outstanding, h->maxSG);
-
-	pos += size;
-	len += size;
-	cciss_proc_tape_report(ctlr, buffer, &pos, &len);
-	for (i = 0; i <= h->highest_lun; i++) {
-
-		drv = &h->drv[i];
-		if (drv->heads == 0)
-			continue;
+	if (*pos == 0)
+		cciss_seq_show_header(seq);
 
-		vol_sz = drv->nr_blocks;
-		vol_sz_frac = sector_div(vol_sz, ENG_GIG_FACTOR);
-		vol_sz_frac *= 100;
-		sector_div(vol_sz_frac, ENG_GIG_FACTOR);
+	return pos;
+}
+
+static int cciss_seq_show(struct seq_file *seq, void *v)
+{
+	sector_t vol_sz, vol_sz_frac;
+	ctlr_info_t *h = seq->private;
+	unsigned ctlr = h->ctlr;
+	loff_t *pos = v;
+	drive_info_struct *drv = &h->drv[*pos];
+
+	if (*pos > h->highest_lun)
+		return 0;
+
+	if (drv->heads == 0)
+		return 0;
+
+	vol_sz = drv->nr_blocks;
+	vol_sz_frac = sector_div(vol_sz, ENG_GIG_FACTOR);
+	vol_sz_frac *= 100;
+	sector_div(vol_sz_frac, ENG_GIG_FACTOR);
+
+	if (drv->raid_level > 5)
+		drv->raid_level = RAID_UNKNOWN;
+	seq_printf(seq, "cciss/c%dd%d:"
+			"\t%4u.%02uGB\tRAID %s\n",
+			ctlr, (int) *pos, (int)vol_sz, (int)vol_sz_frac,
+			raid_label[drv->raid_level]);
+	return 0;
+}
+
+static void *cciss_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	ctlr_info_t *h = seq->private;
+
+	if (*pos > h->highest_lun)
+		return NULL;
+	*pos += 1;
+
+	return pos;
+}
+
+static void cciss_seq_stop(struct seq_file *seq, void *v)
+{
+	ctlr_info_t *h = seq->private;
+
+	/* Only reset h->busy_configuring if we succeeded in setting
+	 * it during cciss_seq_start. */
+	if (v == ERR_PTR(-EBUSY))
+		return;
 
-		if (drv->raid_level > 5)
-			drv->raid_level = RAID_UNKNOWN;
-		size = sprintf(buffer + len, "cciss/c%dd%d:"
-			       "\t%4u.%02uGB\tRAID %s\n",
-			       ctlr, i, (int)vol_sz, (int)vol_sz_frac,
-			       raid_label[drv->raid_level]);
-		pos += size;
-		len += size;
-	}
-
-	*eof = 1;
-	*start = buffer + offset;
-	len -= offset;
-	if (len > length)
-		len = length;
 	h->busy_configuring = 0;
-	return len;
 }
 
-static int
-cciss_proc_write(struct file *file, const char __user *buffer,
-		 unsigned long count, void *data)
+static struct seq_operations cciss_seq_ops = {
+	.start = cciss_seq_start,
+	.show  = cciss_seq_show,
+	.next  = cciss_seq_next,
+	.stop  = cciss_seq_stop,
+};
+
+static int cciss_seq_open(struct inode *inode, struct file *file)
 {
-	unsigned char cmd[80];
-	int len;
-#ifdef CONFIG_CISS_SCSI_TAPE
-	ctlr_info_t *h = (ctlr_info_t *) data;
-	int rc;
+	int ret = seq_open(file, &cciss_seq_ops);
+	struct seq_file *seq = file->private_data;
+
+	if (!ret)
+		seq->private = PDE(inode)->data;
+
+	return ret;
+}
+
+static ssize_t
+cciss_proc_write(struct file *file, const char __user *buf,
+		 size_t length, loff_t *ppos)
+{
+	struct seq_file *seq = file->private_data;
+	ctlr_info_t *h = seq->private;
+	int err, rc;
+	char *buffer;
+
+#ifndef CONFIG_CISS_SCSI_TAPE
+	return -EINVAL;
 #endif
 
-	if (count > sizeof(cmd) - 1)
+	if (!buf || length > PAGE_SIZE - 1)
 		return -EINVAL;
-	if (copy_from_user(cmd, buffer, count))
-		return -EFAULT;
-	cmd[count] = '\0';
-	len = strlen(cmd);	// above 3 lines ensure safety
-	if (len && cmd[len - 1] == '\n')
-		cmd[--len] = '\0';
-#	ifdef CONFIG_CISS_SCSI_TAPE
-	if (strcmp("engage scsi", cmd) == 0) {
+
+	buffer = (char *)__get_free_page(GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	err = -EFAULT;
+	if (copy_from_user(buffer, buf, length))
+		goto out;
+	buffer[length] = '\0';
+
+	if (strncmp(ENGAGE_SCSI, buffer, sizeof ENGAGE_SCSI - 1) == 0) {
 		rc = cciss_engage_scsi(h->ctlr);
 		if (rc != 0)
-			return -rc;
-		return count;
-	}
+			err = -rc;
+		else
+			err = length;
+	} else
+		err = -EINVAL;
 	/* might be nice to have "disengage" too, but it's not
 	   safely possible. (only 1 module use count, lock issues.) */
-#	endif
-	return -EINVAL;
+out:
+	free_page((unsigned long)buffer);
+	return err;
 }
 
-/*
- * Get us a file in /proc/cciss that says something about each controller.
- * Create /proc/cciss if it doesn't exist yet.
- */
+static struct file_operations cciss_proc_fops = {
+	.owner	 = THIS_MODULE,
+	.open    = cciss_seq_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = seq_release,
+	.write	 = cciss_proc_write,
+};
+
 static void __devinit cciss_procinit(int i)
 {
 	struct proc_dir_entry *pde;
 
-	if (proc_cciss == NULL) {
+	if (proc_cciss == NULL)
 		proc_cciss = proc_mkdir("cciss", proc_root_driver);
-		if (!proc_cciss)
-			return;
-	}
+	if (!proc_cciss)
+		return;
+	pde = create_proc_entry(hba[i]->devname, S_IWUSR | S_IRUSR |
+					S_IRGRP | S_IROTH, proc_cciss);
+	if (!pde)
+		return;
 
-	pde = create_proc_read_entry(hba[i]->devname,
-				     S_IWUSR | S_IRUSR | S_IRGRP | S_IROTH,
-				     proc_cciss, cciss_proc_get_info, hba[i]);
-	pde->write_proc = cciss_proc_write;
+	pde->proc_fops = &cciss_proc_fops;
+	pde->data = hba[i];
 }
 #endif				/* CONFIG_PROC_FS */
 
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 55178e9..d08a6a8 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -1404,21 +1404,18 @@ cciss_engage_scsi(int ctlr)
 }
 
 static void
-cciss_proc_tape_report(int ctlr, unsigned char *buffer, off_t *pos, off_t *len)
+cciss_seq_tape_report(struct seq_file *seq, int ctlr)
 {
 	unsigned long flags;
-	int size;
-
-	*pos = *pos -1; *len = *len - 1; // cut off the last trailing newline
 
 	CPQ_TAPE_LOCK(ctlr, flags);
-	size = sprintf(buffer + *len, 
+	seq_printf(seq,
 		"Sequential access devices: %d\n\n",
 			ccissscsi[ctlr].ndevices);
 	CPQ_TAPE_UNLOCK(ctlr, flags);
-	*pos += size; *len += size;
 }
 
+
 /* Need at least one of these error handlers to keep ../scsi/hosts.c from 
  * complaining.  Doing a host- or bus-reset can't do anything good here. 
  * Despite what it might say in scsi_error.c, there may well be commands
@@ -1498,6 +1495,6 @@ static int  cciss_eh_abort_handler(struct scsi_cmnd *scsicmd)
 #define cciss_scsi_setup(cntl_num)
 #define cciss_unregister_scsi(ctlr)
 #define cciss_register_scsi(ctlr)
-#define cciss_proc_tape_report(ctlr, buffer, pos, len)
+#define cciss_seq_tape_report(struct seq_file *seq, int ctlr)
 
 #endif /* CONFIG_CISS_SCSI_TAPE */
