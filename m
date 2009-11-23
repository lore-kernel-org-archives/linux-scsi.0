From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 25/27] scsi proc_fops: convert in2000
Date: Mon, 23 Nov 2009 04:48:10 +0300
Message-ID: <20091123014810.GY31711@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45780 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbZKWBt2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2009 20:49:28 -0500
Received: by ewy19 with SMTP id 19so1405652ewy.21
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2009 17:49:33 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/in2000.c |  191 ++++++++++++++++++++++++--------------------------
 1 file changed, 93 insertions(+), 98 deletions(-)

--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -119,6 +119,7 @@
 #include <linux/string.h>
 #include <linux/delay.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/ioport.h>
 #include <linux/stat.h>
 
@@ -2165,161 +2166,156 @@ static int in2000_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 	return 0;
 }
 
-
-static int in2000_proc_info(struct Scsi_Host *instance, char *buf, char **start, off_t off, int len, int in)
-{
-
 #ifdef PROC_INTERFACE
-
-	char *bp;
-	char tbuf[128];
+static int in2000_proc_show(struct seq_file *m, void *v)
+{
+	struct Scsi_Host *instance = m->private;
 	unsigned long flags;
 	struct IN2000_hostdata *hd;
 	Scsi_Cmnd *cmd;
-	int x, i;
-	static int stop = 0;
+	int x;
 
 	hd = (struct IN2000_hostdata *) instance->hostdata;
 
-/* If 'in' is TRUE we need to _read_ the proc file. We accept the following
- * keywords (same format as command-line, but only ONE per read):
- *    debug
- *    disconnect
- *    period
- *    resync
- *    proc
- */
-
-	if (in) {
-		buf[len] = '\0';
-		bp = buf;
-		if (!strncmp(bp, "debug:", 6)) {
-			bp += 6;
-			hd->args = simple_strtoul(bp, NULL, 0) & DB_MASK;
-		} else if (!strncmp(bp, "disconnect:", 11)) {
-			bp += 11;
-			x = simple_strtoul(bp, NULL, 0);
-			if (x < DIS_NEVER || x > DIS_ALWAYS)
-				x = DIS_ADAPTIVE;
-			hd->disconnect = x;
-		} else if (!strncmp(bp, "period:", 7)) {
-			bp += 7;
-			x = simple_strtoul(bp, NULL, 0);
-			hd->default_sx_per = sx_table[round_period((unsigned int) x)].period_ns;
-		} else if (!strncmp(bp, "resync:", 7)) {
-			bp += 7;
-			x = simple_strtoul(bp, NULL, 0);
-			for (i = 0; i < 7; i++)
-				if (x & (1 << i))
-					hd->sync_stat[i] = SS_UNSET;
-		} else if (!strncmp(bp, "proc:", 5)) {
-			bp += 5;
-			hd->proc = simple_strtoul(bp, NULL, 0);
-		} else if (!strncmp(bp, "level2:", 7)) {
-			bp += 7;
-			hd->level2 = simple_strtoul(bp, NULL, 0);
-		}
-		return len;
-	}
-
 	spin_lock_irqsave(instance->host_lock, flags);
-	bp = buf;
-	*bp = '\0';
 	if (hd->proc & PR_VERSION) {
-		sprintf(tbuf, "\nVersion %s - %s. Compiled %s %s", IN2000_VERSION, IN2000_DATE, __DATE__, __TIME__);
-		strcat(bp, tbuf);
+		seq_printf(m, "\nVersion %s - %s. Compiled %s %s", IN2000_VERSION, IN2000_DATE, __DATE__, __TIME__);
 	}
 	if (hd->proc & PR_INFO) {
-		sprintf(tbuf, "\ndip_switch=%02x: irq=%d io=%02x floppy=%s sync/DOS5=%s", (hd->dip_switch & 0x7f), instance->irq, hd->io_base, (hd->dip_switch & 0x40) ? "Yes" : "No", (hd->dip_switch & 0x20) ? "Yes" : "No");
-		strcat(bp, tbuf);
-		strcat(bp, "\nsync_xfer[] =       ");
+		seq_printf(m, "\ndip_switch=%02x: irq=%d io=%02x floppy=%s sync/DOS5=%s", (hd->dip_switch & 0x7f), instance->irq, hd->io_base, (hd->dip_switch & 0x40) ? "Yes" : "No", (hd->dip_switch & 0x20) ? "Yes" : "No");
+		seq_printf(m, "\nsync_xfer[] =       ");
 		for (x = 0; x < 7; x++) {
-			sprintf(tbuf, "\t%02x", hd->sync_xfer[x]);
-			strcat(bp, tbuf);
+			seq_printf(m, "\t%02x", hd->sync_xfer[x]);
 		}
-		strcat(bp, "\nsync_stat[] =       ");
+		seq_printf(m, "\nsync_stat[] =       ");
 		for (x = 0; x < 7; x++) {
-			sprintf(tbuf, "\t%02x", hd->sync_stat[x]);
-			strcat(bp, tbuf);
+			seq_printf(m, "\t%02x", hd->sync_stat[x]);
 		}
 	}
 #ifdef PROC_STATISTICS
 	if (hd->proc & PR_STATISTICS) {
-		strcat(bp, "\ncommands issued:    ");
+		seq_printf(m, "\ncommands issued:    ");
 		for (x = 0; x < 7; x++) {
-			sprintf(tbuf, "\t%ld", hd->cmd_cnt[x]);
-			strcat(bp, tbuf);
+			seq_printf(m, "\t%ld", hd->cmd_cnt[x]);
 		}
-		strcat(bp, "\ndisconnects allowed:");
+		seq_printf(m, "\ndisconnects allowed:");
 		for (x = 0; x < 7; x++) {
-			sprintf(tbuf, "\t%ld", hd->disc_allowed_cnt[x]);
-			strcat(bp, tbuf);
+			seq_printf(m, "\t%ld", hd->disc_allowed_cnt[x]);
 		}
-		strcat(bp, "\ndisconnects done:   ");
+		seq_printf(m, "\ndisconnects done:   ");
 		for (x = 0; x < 7; x++) {
-			sprintf(tbuf, "\t%ld", hd->disc_done_cnt[x]);
-			strcat(bp, tbuf);
+			seq_printf(m, "\t%ld", hd->disc_done_cnt[x]);
 		}
-		sprintf(tbuf, "\ninterrupts:      \t%ld", hd->int_cnt);
-		strcat(bp, tbuf);
+		seq_printf(m, "\ninterrupts:      \t%ld", hd->int_cnt);
 	}
 #endif
 	if (hd->proc & PR_CONNECTED) {
-		strcat(bp, "\nconnected:     ");
+		seq_printf(m, "\nconnected:     ");
 		if (hd->connected) {
 			cmd = (Scsi_Cmnd *) hd->connected;
-			sprintf(tbuf, " %ld-%d:%d(%02x)", cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
-			strcat(bp, tbuf);
+			seq_printf(m, " %ld-%d:%d(%02x)", cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 		}
 	}
 	if (hd->proc & PR_INPUTQ) {
-		strcat(bp, "\ninput_Q:       ");
+		seq_printf(m, "\ninput_Q:       ");
 		cmd = (Scsi_Cmnd *) hd->input_Q;
 		while (cmd) {
-			sprintf(tbuf, " %ld-%d:%d(%02x)", cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
-			strcat(bp, tbuf);
+			seq_printf(m, " %ld-%d:%d(%02x)", cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			cmd = (Scsi_Cmnd *) cmd->host_scribble;
 		}
 	}
 	if (hd->proc & PR_DISCQ) {
-		strcat(bp, "\ndisconnected_Q:");
+		seq_printf(m, "\ndisconnected_Q:");
 		cmd = (Scsi_Cmnd *) hd->disconnected_Q;
 		while (cmd) {
-			sprintf(tbuf, " %ld-%d:%d(%02x)", cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
-			strcat(bp, tbuf);
+			seq_printf(m, " %ld-%d:%d(%02x)", cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			cmd = (Scsi_Cmnd *) cmd->host_scribble;
 		}
 	}
 	if (hd->proc & PR_TEST) {
 		;		/* insert your own custom function here */
 	}
-	strcat(bp, "\n");
+	seq_putc(m, '\n');
 	spin_unlock_irqrestore(instance->host_lock, flags);
-	*start = buf;
-	if (stop) {
-		stop = 0;
-		return 0;	/* return 0 to signal end-of-file */
-	}
-	if (off > 0x40000)	/* ALWAYS stop after 256k bytes have been read */
-		stop = 1;
-	if (hd->proc & PR_STOP)	/* stop every other time */
-		stop = 1;
-	return strlen(bp);
+	return 0;
+}
 
-#else				/* PROC_INTERFACE */
+static int in2000_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, in2000_proc_show, PDE(inode)->data);
+}
 
-	return 0;
+static ssize_t in2000_proc_write(struct file *file, const char __user *buf, size_t count, loff_t *pos)
+{
+	struct Scsi_Host *instance = PDE(file->f_path.dentry->d_inode)->data;
+	struct IN2000_hostdata *hd = (struct IN2000_hostdata *)instance->hostdata;
+	char cmd[42], *bp;
+	size_t len;
+	int x, i;
+
+	len = min(count, sizeof(cmd) - 1);
+	if (copy_from_user(cmd, buf, len))
+		return -EFAULT;
+	cmd[len] = '\0';
 
-#endif				/* PROC_INTERFACE */
+	/*
+	 * We accept the following keywords (same format as command-line,
+	 * but only ONE per read):
+	 *    debug
+	 *    disconnect
+	 *    period
+	 *    resync
+	 *    proc
+	 */
+	bp = cmd;
+	if (!strncmp(bp, "debug:", 6)) {
+		bp += 6;
+		hd->args = simple_strtoul(bp, NULL, 0) & DB_MASK;
+	} else if (!strncmp(bp, "disconnect:", 11)) {
+		bp += 11;
+		x = simple_strtoul(bp, NULL, 0);
+		if (x < DIS_NEVER || x > DIS_ALWAYS)
+			x = DIS_ADAPTIVE;
+		hd->disconnect = x;
+	} else if (!strncmp(bp, "period:", 7)) {
+		bp += 7;
+		x = simple_strtoul(bp, NULL, 0);
+		hd->default_sx_per = sx_table[round_period((unsigned int) x)].period_ns;
+	} else if (!strncmp(bp, "resync:", 7)) {
+		bp += 7;
+		x = simple_strtoul(bp, NULL, 0);
+		for (i = 0; i < 7; i++)
+			if (x & (1 << i))
+				hd->sync_stat[i] = SS_UNSET;
+	} else if (!strncmp(bp, "proc:", 5)) {
+		bp += 5;
+		hd->proc = simple_strtoul(bp, NULL, 0);
+	} else if (!strncmp(bp, "level2:", 7)) {
+		bp += 7;
+		hd->level2 = simple_strtoul(bp, NULL, 0);
+	}
 
+	return count;
 }
 
+static const struct file_operations in2000_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= in2000_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= in2000_proc_write,
+};
+#endif
+
 MODULE_LICENSE("GPL");
 
 
 static struct scsi_host_template driver_template = {
 	.proc_name       		= "in2000",
-	.proc_info       		= in2000_proc_info,
+#ifdef PROC_INTERFACE
+	.proc_fops			= &in2000_proc_fops,
+#endif
 	.name            		= "Always IN2000",
 	.detect          		= in2000_detect, 
 	.release			= in2000_release,
-- 
1.6.5.2

