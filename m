From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 16/27] scsi proc_fops: convert aic7xxx
Date: Mon, 23 Nov 2009 04:39:59 +0300
Message-ID: <20091123013959.GP31711@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59758 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZKWBlQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2009 20:41:16 -0500
Received: by ewy19 with SMTP id 19so1402140ewy.21
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2009 17:41:21 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org

In ahc_send_async() remove unused buffer and initialization.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/aic7xxx/aic7xxx_osm.c  |    8 -
 drivers/scsi/aic7xxx/aic7xxx_osm.h  |   13 --
 drivers/scsi/aic7xxx/aic7xxx_proc.c |  205 ++++++++++++++----------------------
 3 files changed, 85 insertions(+), 141 deletions(-)

--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -800,7 +800,7 @@ struct scsi_host_template aic7xxx_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "aic7xxx",
 	.proc_name		= "aic7xxx",
-	.proc_info		= ahc_linux_proc_info,
+	.proc_fops		= &ahc_linux_proc_fops,
 	.info			= ahc_linux_info,
 	.queuecommand		= ahc_linux_queue,
 	.eh_abort_handler	= ahc_linux_abort,
@@ -1628,10 +1628,8 @@ ahc_send_async(struct ahc_softc *ahc, char channel,
 	switch (code) {
 	case AC_TRANSFER_NEG:
 	{
-		char	buf[80];
 		struct	scsi_target *starget;
 		struct	ahc_linux_target *targ;
-		struct	info_str info;
 		struct	ahc_initiator_tinfo *tinfo;
 		struct	ahc_tmode_tstate *tstate;
 		int	target_offset;
@@ -1639,10 +1637,6 @@ ahc_send_async(struct ahc_softc *ahc, char channel,
 
 		BUG_ON(target == CAM_TARGET_WILDCARD);
 
-		info.buffer = buf;
-		info.length = sizeof(buf);
-		info.offset = 0;
-		info.pos = 0;
 		tinfo = ahc_fetch_transinfo(ahc, channel,
 						channel == 'A' ? ahc->our_id
 							       : ahc->our_id_b,
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -66,6 +66,8 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <asm/byteorder.h>
 #include <asm/io.h>
@@ -390,14 +392,6 @@ void ahc_insb(struct ahc_softc * ahc, long port,
 int		ahc_linux_register_host(struct ahc_softc *,
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
 /* Lock protecting internal data structures */
 
@@ -530,8 +524,7 @@ ahc_flush_device_writes(struct ahc_softc *ahc)
 }
 
 /**************************** Proc FS Support *********************************/
-int	ahc_linux_proc_info(struct Scsi_Host *, char *, char **,
-			    off_t, int, int);
+extern const struct file_operations ahc_linux_proc_fops;
 
 /*************************** Domain Validation ********************************/
 /*********************** Transaction Access Wrappers *************************/
--- a/drivers/scsi/aic7xxx/aic7xxx_proc.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_proc.c
@@ -43,16 +43,8 @@
 #include "aic7xxx_inline.h"
 #include "aic7xxx_93cx6.h"
 
-static void	copy_mem_info(struct info_str *info, char *data, int len);
-static int	copy_info(struct info_str *info, char *fmt, ...);
-static void	ahc_dump_target_state(struct ahc_softc *ahc,
-				      struct info_str *info,
-				      u_int our_id, char channel,
-				      u_int target_id, u_int target_offset);
-static void	ahc_dump_device_state(struct info_str *info,
+static void	ahc_dump_device_state(struct seq_file *m,
 				      struct scsi_device *dev);
-static int	ahc_proc_write_seeprom(struct ahc_softc *ahc,
-				       char *buffer, int length);
 
 /*
  * Table of syncrates that don't follow the "divisible by 4"
@@ -94,51 +86,8 @@ ahc_calc_syncsrate(u_int period_factor)
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
-ahc_format_transinfo(struct info_str *info, struct ahc_transinfo *tinfo)
+ahc_format_transinfo(struct seq_file *m, struct ahc_transinfo *tinfo)
 {
 	u_int speed;
 	u_int freq;
@@ -153,12 +102,12 @@ ahc_format_transinfo(struct info_str *info, struct ahc_transinfo *tinfo)
 	speed *= (0x01 << tinfo->width);
         mb = speed / 1000;
         if (mb > 0)
-		copy_info(info, "%d.%03dMB/s transfers", mb, speed % 1000);
+		seq_printf(m, "%d.%03dMB/s transfers", mb, speed % 1000);
         else
-		copy_info(info, "%dKB/s transfers", speed);
+		seq_printf(m, "%dKB/s transfers", speed);
 
 	if (freq != 0) {
-		copy_info(info, " (%d.%03dMHz%s, offset %d",
+		seq_printf(m, " (%d.%03dMHz%s, offset %d",
 			 freq / 1000, freq % 1000,
 			 (tinfo->ppr_options & MSG_EXT_PPR_DT_REQ) != 0
 			 ? " DT" : "", tinfo->offset);
@@ -166,19 +115,19 @@ ahc_format_transinfo(struct info_str *info, struct ahc_transinfo *tinfo)
 
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
-ahc_dump_target_state(struct ahc_softc *ahc, struct info_str *info,
+ahc_dump_target_state(struct ahc_softc *ahc, struct seq_file *m,
 		      u_int our_id, char channel, u_int target_id,
 		      u_int target_offset)
 {
@@ -190,18 +139,18 @@ ahc_dump_target_state(struct ahc_softc *ahc, struct info_str *info,
 	tinfo = ahc_fetch_transinfo(ahc, channel, our_id,
 				    target_id, &tstate);
 	if ((ahc->features & AHC_TWIN) != 0)
-		copy_info(info, "Channel %c ", channel);
-	copy_info(info, "Target %d Negotiation Settings\n", target_id);
-	copy_info(info, "\tUser: ");
-	ahc_format_transinfo(info, &tinfo->user);
+		seq_printf(m, "Channel %c ", channel);
+	seq_printf(m, "Target %d Negotiation Settings\n", target_id);
+	seq_printf(m, "\tUser: ");
+	ahc_format_transinfo(m, &tinfo->user);
 	starget = ahc->platform_data->starget[target_offset];
 	if (!starget)
 		return;
 
-	copy_info(info, "\tGoal: ");
-	ahc_format_transinfo(info, &tinfo->goal);
-	copy_info(info, "\tCurr: ");
-	ahc_format_transinfo(info, &tinfo->curr);
+	seq_printf(m, "\tGoal: ");
+	ahc_format_transinfo(m, &tinfo->goal);
+	seq_printf(m, "\tCurr: ");
+	ahc_format_transinfo(m, &tinfo->curr);
 
 	for (lun = 0; lun < AHC_NUM_LUNS; lun++) {
 		struct scsi_device *sdev;
@@ -211,48 +160,43 @@ ahc_dump_target_state(struct ahc_softc *ahc, struct info_str *info,
 		if (sdev == NULL)
 			continue;
 
-		ahc_dump_device_state(info, sdev);
+		ahc_dump_device_state(m, sdev);
 	}
 }
 
 static void
-ahc_dump_device_state(struct info_str *info, struct scsi_device *sdev)
+ahc_dump_device_state(struct seq_file *m, struct scsi_device *sdev)
 {
 	struct ahc_linux_device *dev = scsi_transport_device_data(sdev);
 
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
-ahc_proc_write_seeprom(struct ahc_softc *ahc, char *buffer, int length)
+ahc_proc_write_seeprom(struct ahc_softc *ahc, struct seeprom_config *sc)
 {
 	struct seeprom_descriptor sd;
 	int have_seeprom;
 	u_long s;
 	int paused;
-	int written;
+	int rv;
 
 	/* Default to failure. */
-	written = -EINVAL;
+	rv = -EINVAL;
 	ahc_lock(ahc, &s);
 	paused = ahc_is_paused(ahc);
 	if (!paused)
 		ahc_pause(ahc);
 
-	if (length != sizeof(struct seeprom_config)) {
-		printf("ahc_proc_write_seeprom: incorrect buffer size\n");
-		goto done;
-	}
-
-	have_seeprom = ahc_verify_cksum((struct seeprom_config*)buffer);
+	have_seeprom = ahc_verify_cksum(sc);
 	if (have_seeprom == 0) {
 		printf("ahc_proc_write_seeprom: cksum verification failed\n");
 		goto done;
@@ -311,7 +255,7 @@ ahc_proc_write_seeprom(struct ahc_softc *ahc, char *buffer, int length)
 		}
 		printf("aic7xxx: Writing Serial EEPROM\n");
 		start_addr = 32 * (ahc->channel - 'A');
-		ahc_write_seeprom(&sd, (u_int16_t *)buffer, start_addr,
+		ahc_write_seeprom(&sd, (u_int16_t *)sc, start_addr,
 				  sizeof(struct seeprom_config)/2);
 		ahc_read_seeprom(&sd, (uint16_t *)ahc->seep_config,
 				 start_addr, sizeof(struct seeprom_config)/2);
@@ -319,67 +263,69 @@ ahc_proc_write_seeprom(struct ahc_softc *ahc, char *buffer, int length)
 		if ((ahc->chip & AHC_VL) == 0)
 			ahc_release_seeprom(&sd);
 #endif
-		written = length;
+		rv = 0;
 	}
 
 done:
 	if (!paused)
 		ahc_unpause(ahc);
 	ahc_unlock(ahc, &s);
-	return (written);
+	return rv;
+}
+
+static ssize_t ahc_linux_proc_write(struct file *file, const char __user *buf,
+				    size_t count, loff_t *pos)
+{
+	struct Scsi_Host *shost = PDE(file->f_path.dentry->d_inode)->data;
+	struct ahc_softc *ahc = *(struct ahc_softc **)shost->hostdata;
+	struct seeprom_config sc;
+	int rv;
+
+	if (count != sizeof(struct seeprom_config))
+		return -EINVAL;
+	if (copy_from_user(&sc, buf, sizeof(struct seeprom_config)))
+		return -EFAULT;
+
+	rv = ahc_proc_write_seeprom(ahc, &sc);
+	if (rv < 0)
+		return rv;
+	return count;
 }
 
 /*
  * Return information to handle /proc support for the driver.
  */
-int
-ahc_linux_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
-		    off_t offset, int length, int inout)
+static int ahc_linux_proc_show(struct seq_file *m, void *v)
 {
+	struct Scsi_Host *shost = m->private;
 	struct	ahc_softc *ahc = *(struct ahc_softc **)shost->hostdata;
-	struct	info_str info;
 	char	ahc_info[256];
 	u_int	max_targ;
 	u_int	i;
-	int	retval;
-
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
 
-	copy_info(&info, "Adaptec AIC7xxx driver version: %s\n",
+	seq_printf(m, "Adaptec AIC7xxx driver version: %s\n",
 		  AIC7XXX_DRIVER_VERSION);
-	copy_info(&info, "%s\n", ahc->description);
+	seq_printf(m, "%s\n", ahc->description);
 	ahc_controller_info(ahc, ahc_info);
-	copy_info(&info, "%s\n", ahc_info);
-	copy_info(&info, "Allocated SCBs: %d, SG List Length: %d\n\n",
+	seq_printf(m, "%s\n", ahc_info);
+	seq_printf(m, "Allocated SCBs: %d, SG List Length: %d\n\n",
 		  ahc->scb_data->numscbs, AHC_NSEG);
 
 
 	if (ahc->seep_config == NULL)
-		copy_info(&info, "No Serial EEPROM\n");
+		seq_printf(m, "No Serial EEPROM\n");
 	else {
-		copy_info(&info, "Serial EEPROM:\n");
+		seq_printf(m, "Serial EEPROM:\n");
 		for (i = 0; i < sizeof(*ahc->seep_config)/2; i++) {
 			if (((i % 8) == 0) && (i != 0)) {
-				copy_info(&info, "\n");
+				seq_putc(m, '\n');
 			}
-			copy_info(&info, "0x%.4x ",
+			seq_printf(m, "0x%.4x ",
 				  ((uint16_t*)ahc->seep_config)[i]);
 		}
-		copy_info(&info, "\n");
+		seq_putc(m, '\n');
 	}
-	copy_info(&info, "\n");
+	seq_putc(m, '\n');
 
 	max_targ = 16;
 	if ((ahc->features & (AHC_WIDE|AHC_TWIN)) == 0)
@@ -399,10 +345,22 @@ ahc_linux_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 			target_id = i % 8;
 		}
 
-		ahc_dump_target_state(ahc, &info, our_id,
+		ahc_dump_target_state(ahc, m, our_id,
 				      channel, target_id, i);
 	}
-	retval = info.pos > info.offset ? info.pos - info.offset : 0;
-done:
-	return (retval);
+	return 0;
 }
+
+static int ahc_linux_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ahc_linux_proc_show, PDE(inode)->data);
+}
+
+const struct file_operations ahc_linux_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ahc_linux_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= ahc_linux_proc_write,
+};
-- 
1.6.5.2

