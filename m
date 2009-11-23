From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 15/27] scsi proc_fops: convert aic79xx
Date: Mon, 23 Nov 2009 04:39:22 +0300
Message-ID: <20091123013922.GO31711@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40145 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbZKWBkj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2009 20:40:39 -0500
Received: by ewy19 with SMTP id 19so1401878ewy.21
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2009 17:40:44 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org

In ahd_send_async() remove unused buffer and buffer initialization.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/aic7xxx/aic79xx_osm.c  |    8 -
 drivers/scsi/aic7xxx/aic79xx_osm.h  |   13 --
 drivers/scsi/aic7xxx/aic79xx_proc.c |  216 ++++++++++++++----------------------
 3 files changed, 92 insertions(+), 145 deletions(-)

--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -903,7 +903,7 @@ struct scsi_host_template aic79xx_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "aic79xx",
 	.proc_name		= "aic79xx",
-	.proc_info		= ahd_linux_proc_info,
+	.proc_fops		= &ahd_linux_proc_fops,
 	.info			= ahd_linux_info,
 	.queuecommand		= ahd_linux_queue,
 	.eh_abort_handler	= ahd_linux_abort,
@@ -1699,19 +1699,13 @@ ahd_send_async(struct ahd_softc *ahd, char channel,
 	switch (code) {
 	case AC_TRANSFER_NEG:
 	{
-		char	buf[80];
 		struct  scsi_target *starget;
-		struct	info_str info;
 		struct	ahd_initiator_tinfo *tinfo;
 		struct	ahd_tmode_tstate *tstate;
 		unsigned int target_ppr_options;
 
 		BUG_ON(target == CAM_TARGET_WILDCARD);
 
-		info.buffer = buf;
-		info.length = sizeof(buf);
-		info.offset = 0;
-		info.pos = 0;
 		tinfo = ahd_fetch_transinfo(ahd, channel, ahd->our_id,
 					    target, &tstate);
 
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -49,6 +49,8 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <asm/byteorder.h>
 #include <asm/io.h>
@@ -386,14 +388,6 @@ void ahd_insb(struct ahd_softc * ahd, long port,
 int		ahd_linux_register_host(struct ahd_softc *,
 					struct scsi_host_template *);
 
-/*************************** Pretty Printing **********************************/
-struct info_str {
-	char *buffer;
-	int length;
-	off_t offset;
-	int pos;
-};
-
 /******************************** Locking *************************************/
 static inline void
 ahd_lockinit(struct ahd_softc *ahd)
@@ -520,8 +514,7 @@ ahd_flush_device_writes(struct ahd_softc *ahd)
 }
 
 /**************************** Proc FS Support *********************************/
-int	ahd_linux_proc_info(struct Scsi_Host *, char *, char **,
-			    off_t, int, int);
+extern const struct file_operations ahd_linux_proc_fops;
 
 /*********************** Transaction Access Wrappers **************************/
 static inline void ahd_cmd_set_transaction_status(struct scsi_cmnd *, uint32_t);
--- a/drivers/scsi/aic7xxx/aic79xx_proc.c
+++ b/drivers/scsi/aic7xxx/aic79xx_proc.c
@@ -42,16 +42,8 @@
 #include "aic79xx_osm.h"
 #include "aic79xx_inline.h"
 
-static void	copy_mem_info(struct info_str *info, char *data, int len);
-static int	copy_info(struct info_str *info, char *fmt, ...);
-static void	ahd_dump_target_state(struct ahd_softc *ahd,
-				      struct info_str *info,
-				      u_int our_id, char channel,
-				      u_int target_id);
-static void	ahd_dump_device_state(struct info_str *info,
+static void	ahd_dump_device_state(struct seq_file *m,
 				      struct scsi_device *sdev);
-static int	ahd_proc_write_seeprom(struct ahd_softc *ahd,
-				       char *buffer, int length);
 
 /*
  * Table of syncrates that don't follow the "divisible by 4"
@@ -93,58 +85,15 @@ ahd_calc_syncsrate(u_int period_factor)
 	return (10000000 / (period_factor * 4 * 10));
 }
 
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
-
 static void
-ahd_format_transinfo(struct info_str *info, struct ahd_transinfo *tinfo)
+ahd_format_transinfo(struct seq_file *m, struct ahd_transinfo *tinfo)
 {
 	u_int speed;
 	u_int freq;
 	u_int mb;
 
 	if (tinfo->period == AHD_PERIOD_UNKNOWN) {
-		copy_info(info, "Renegotiation Pending\n");
+		seq_printf(m, "Renegotiation Pending\n");
 		return;
 	}
         speed = 3300;
@@ -156,34 +105,34 @@ ahd_format_transinfo(struct info_str *info, struct ahd_transinfo *tinfo)
 	speed *= (0x01 << tinfo->width);
         mb = speed / 1000;
         if (mb > 0)
-		copy_info(info, "%d.%03dMB/s transfers", mb, speed % 1000);
+		seq_printf(m, "%d.%03dMB/s transfers", mb, speed % 1000);
         else
-		copy_info(info, "%dKB/s transfers", speed);
+		seq_printf(m, "%dKB/s transfers", speed);
 
 	if (freq != 0) {
 		int	printed_options;
 
 		printed_options = 0;
-		copy_info(info, " (%d.%03dMHz", freq / 1000, freq % 1000);
+		seq_printf(m, " (%d.%03dMHz", freq / 1000, freq % 1000);
 		if ((tinfo->ppr_options & MSG_EXT_PPR_RD_STRM) != 0) {
-			copy_info(info, " RDSTRM");
+			seq_printf(m, " RDSTRM");
 			printed_options++;
 		}
 		if ((tinfo->ppr_options & MSG_EXT_PPR_DT_REQ) != 0) {
-			copy_info(info, "%s", printed_options ? "|DT" : " DT");
+			seq_printf(m, "%s", printed_options ? "|DT" : " DT");
 			printed_options++;
 		}
 		if ((tinfo->ppr_options & MSG_EXT_PPR_IU_REQ) != 0) {
-			copy_info(info, "%s", printed_options ? "|IU" : " IU");
+			seq_printf(m, "%s", printed_options ? "|IU" : " IU");
 			printed_options++;
 		}
 		if ((tinfo->ppr_options & MSG_EXT_PPR_RTI) != 0) {
-			copy_info(info, "%s",
+			seq_printf(m, "%s",
 				  printed_options ? "|RTI" : " RTI");
 			printed_options++;
 		}
 		if ((tinfo->ppr_options & MSG_EXT_PPR_QAS_REQ) != 0) {
-			copy_info(info, "%s",
+			seq_printf(m, "%s",
 				  printed_options ? "|QAS" : " QAS");
 			printed_options++;
 		}
@@ -191,19 +140,19 @@ ahd_format_transinfo(struct info_str *info, struct ahd_transinfo *tinfo)
 
 	if (tinfo->width > 0) {
 		if (freq != 0) {
-			copy_info(info, ", ");
+			seq_printf(m, ", ");
 		} else {
-			copy_info(info, " (");
+			seq_printf(m, " (");
 		}
-		copy_info(info, "%dbit)", 8 * (0x01 << tinfo->width));
+		seq_printf(m, "%dbit)", 8 * (0x01 << tinfo->width));
 	} else if (freq != 0) {
-		copy_info(info, ")");
+		seq_printf(m, ")");
 	}
-	copy_info(info, "\n");
+	seq_putc(m, '\n');
 }
 
 static void
-ahd_dump_target_state(struct ahd_softc *ahd, struct info_str *info,
+ahd_dump_target_state(struct ahd_softc *ahd, struct seq_file *m,
 		      u_int our_id, char channel, u_int target_id)
 {
 	struct  scsi_target *starget;
@@ -213,17 +162,17 @@ ahd_dump_target_state(struct ahd_softc *ahd, struct info_str *info,
 
 	tinfo = ahd_fetch_transinfo(ahd, channel, our_id,
 				    target_id, &tstate);
-	copy_info(info, "Target %d Negotiation Settings\n", target_id);
-	copy_info(info, "\tUser: ");
-	ahd_format_transinfo(info, &tinfo->user);
+	seq_printf(m, "Target %d Negotiation Settings\n", target_id);
+	seq_printf(m, "\tUser: ");
+	ahd_format_transinfo(m, &tinfo->user);
 	starget = ahd->platform_data->starget[target_id];
 	if (starget == NULL)
 		return;
 
-	copy_info(info, "\tGoal: ");
-	ahd_format_transinfo(info, &tinfo->goal);
-	copy_info(info, "\tCurr: ");
-	ahd_format_transinfo(info, &tinfo->curr);
+	seq_printf(m, "\tGoal: ");
+	ahd_format_transinfo(m, &tinfo->goal);
+	seq_printf(m, "\tCurr: ");
+	ahd_format_transinfo(m, &tinfo->curr);
 
 	for (lun = 0; lun < AHD_NUM_LUNS; lun++) {
 		struct scsi_device *dev;
@@ -233,37 +182,37 @@ ahd_dump_target_state(struct ahd_softc *ahd, struct info_str *info,
 		if (dev == NULL)
 			continue;
 
-		ahd_dump_device_state(info, dev);
+		ahd_dump_device_state(m, dev);
 	}
 }
 
 static void
-ahd_dump_device_state(struct info_str *info, struct scsi_device *sdev)
+ahd_dump_device_state(struct seq_file *m, struct scsi_device *sdev)
 {
 	struct ahd_linux_device *dev = scsi_transport_device_data(sdev);
 
-	copy_info(info, "\tChannel %c Target %d Lun %d Settings\n",
+	seq_printf(m, "\tChannel %c Target %d Lun %d Settings\n",
 		  sdev->sdev_target->channel + 'A',
 		  sdev->sdev_target->id, sdev->lun);
 
-	copy_info(info, "\t\tCommands Queued %ld\n", dev->commands_issued);
-	copy_info(info, "\t\tCommands Active %d\n", dev->active);
-	copy_info(info, "\t\tCommand Openings %d\n", dev->openings);
-	copy_info(info, "\t\tMax Tagged Openings %d\n", dev->maxtags);
-	copy_info(info, "\t\tDevice Queue Frozen Count %d\n", dev->qfrozen);
+	seq_printf(m, "\t\tCommands Queued %ld\n", dev->commands_issued);
+	seq_printf(m, "\t\tCommands Active %d\n", dev->active);
+	seq_printf(m, "\t\tCommand Openings %d\n", dev->openings);
+	seq_printf(m, "\t\tMax Tagged Openings %d\n", dev->maxtags);
+	seq_printf(m, "\t\tDevice Queue Frozen Count %d\n", dev->qfrozen);
 }
 
 static int
-ahd_proc_write_seeprom(struct ahd_softc *ahd, char *buffer, int length)
+ahd_proc_write_seeprom(struct ahd_softc *ahd, struct seeprom_config *sc)
 {
 	ahd_mode_state saved_modes;
 	int have_seeprom;
 	u_long s;
 	int paused;
-	int written;
+	int rv;
 
+	rv = -EINVAL;
 	/* Default to failure. */
-	written = -EINVAL;
 	ahd_lock(ahd, &s);
 	paused = ahd_is_paused(ahd);
 	if (!paused)
@@ -271,12 +220,8 @@ ahd_proc_write_seeprom(struct ahd_softc *ahd, char *buffer, int length)
 
 	saved_modes = ahd_save_modes(ahd);
 	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
-	if (length != sizeof(struct seeprom_config)) {
-		printf("ahd_proc_write_seeprom: incorrect buffer size\n");
-		goto done;
-	}
 
-	have_seeprom = ahd_verify_cksum((struct seeprom_config*)buffer);
+	have_seeprom = ahd_verify_cksum(sc);
 	if (have_seeprom == 0) {
 		printf("ahd_proc_write_seeprom: cksum verification failed\n");
 		goto done;
@@ -300,13 +245,13 @@ ahd_proc_write_seeprom(struct ahd_softc *ahd, char *buffer, int length)
 		}
 		printf("aic79xx: Writing Serial EEPROM\n");
 		start_addr = 32 * (ahd->channel - 'A');
-		ahd_write_seeprom(ahd, (u_int16_t *)buffer, start_addr,
+		ahd_write_seeprom(ahd, (u_int16_t *)sc, start_addr,
 				  sizeof(struct seeprom_config)/2);
 		ahd_read_seeprom(ahd, (uint16_t *)ahd->seep_config,
 				 start_addr, sizeof(struct seeprom_config)/2,
 				 /*ByteStream*/FALSE);
 		ahd_release_seeprom(ahd);
-		written = length;
+		rv = 0;
 	}
 
 done:
@@ -314,70 +259,86 @@ done:
 	if (!paused)
 		ahd_unpause(ahd);
 	ahd_unlock(ahd, &s);
-	return (written);
+	return rv;
+}
+
+static ssize_t ahd_linux_proc_write(struct file *file, const char __user *buf,
+				    size_t count, loff_t *pos)
+{
+	struct Scsi_Host *shost = PDE(file->f_path.dentry->d_inode)->data;
+	struct ahd_softc *ahd = *(struct ahd_softc **)shost->hostdata;
+	struct seeprom_config sc;
+	int rv;
+
+	if (count != sizeof(struct seeprom_config))
+		return -EINVAL;
+	if (copy_from_user(&sc, buf, sizeof(struct seeprom_config)))
+		return -EFAULT;
+
+	rv = ahd_proc_write_seeprom(ahd, &sc);
+	if (rv < 0)
+		return rv;
+	return count;
 }
+
 /*
  * Return information to handle /proc support for the driver.
  */
-int
-ahd_linux_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
-		    off_t offset, int length, int inout)
+static int ahd_linux_proc_show(struct seq_file *m, void *v)
 {
+	struct Scsi_Host *shost = m->private;
 	struct	ahd_softc *ahd = *(struct ahd_softc **)shost->hostdata;
-	struct	info_str info;
 	char	ahd_info[256];
 	u_int	max_targ;
 	u_int	i;
-	int	retval;
-
-	 /* Has data been written to the file? */ 
-	if (inout == TRUE) {
-		retval = ahd_proc_write_seeprom(ahd, buffer, length);
-		goto done;
-	}
 
-	if (start)
-		*start = buffer;
-
-	info.buffer	= buffer;
-	info.length	= length;
-	info.offset	= offset;
-	info.pos	= 0;
-
-	copy_info(&info, "Adaptec AIC79xx driver version: %s\n",
+	seq_printf(m, "Adaptec AIC79xx driver version: %s\n",
 		  AIC79XX_DRIVER_VERSION);
-	copy_info(&info, "%s\n", ahd->description);
+	seq_printf(m, "%s\n", ahd->description);
 	ahd_controller_info(ahd, ahd_info);
-	copy_info(&info, "%s\n", ahd_info);
-	copy_info(&info, "Allocated SCBs: %d, SG List Length: %d\n\n",
+	seq_printf(m, "%s\n", ahd_info);
+	seq_printf(m, "Allocated SCBs: %d, SG List Length: %d\n\n",
 		  ahd->scb_data.numscbs, AHD_NSEG);
 
 	max_targ = 16;
 
 	if (ahd->seep_config == NULL)
-		copy_info(&info, "No Serial EEPROM\n");
+		seq_printf(m, "No Serial EEPROM\n");
 	else {
-		copy_info(&info, "Serial EEPROM:\n");
+		seq_printf(m, "Serial EEPROM:\n");
 		for (i = 0; i < sizeof(*ahd->seep_config)/2; i++) {
 			if (((i % 8) == 0) && (i != 0)) {
-				copy_info(&info, "\n");
+				seq_putc(m, '\n');
 			}
-			copy_info(&info, "0x%.4x ",
+			seq_printf(m, "0x%.4x ",
 				  ((uint16_t*)ahd->seep_config)[i]);
 		}
-		copy_info(&info, "\n");
+		seq_putc(m, '\n');
 	}
-	copy_info(&info, "\n");
+	seq_putc(m, '\n');
 
 	if ((ahd->features & AHD_WIDE) == 0)
 		max_targ = 8;
 
 	for (i = 0; i < max_targ; i++) {
 
-		ahd_dump_target_state(ahd, &info, ahd->our_id, 'A',
+		ahd_dump_target_state(ahd, m, ahd->our_id, 'A',
 				      /*target_id*/i);
 	}
-	retval = info.pos > info.offset ? info.pos - info.offset : 0;
-done:
-	return (retval);
+
+	return 0;
 }
+
+static int ahd_linux_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ahd_linux_proc_show, PDE(inode)->data);
+}
+
+const struct file_operations ahd_linux_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ahd_linux_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= ahd_linux_proc_write,
+};
-- 
1.6.5.2

