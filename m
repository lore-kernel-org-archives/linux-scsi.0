From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 33/34] scsi proc_ops: convert wd33c93-based drivers
Date: Wed, 22 Feb 2012 22:46:24 +0300
Message-ID: <1329939985-26793-33-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59220 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785Ab2BVTrc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:47:32 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433763bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:47:32 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/a2091.c   |    2 +-
 drivers/scsi/a3000.c   |    2 +-
 drivers/scsi/gvp11.c   |    2 +-
 drivers/scsi/mvme147.c |    2 +-
 drivers/scsi/wd33c93.c |  228 ++++++++++++++++++++++++-----------------------
 drivers/scsi/wd33c93.h |    3 +-
 6 files changed, 121 insertions(+), 118 deletions(-)

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index 79a3063..8667f87 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -166,7 +166,7 @@ static int a2091_bus_reset(struct scsi_cmnd *cmd)
 static struct scsi_host_template a2091_scsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "Commodore A2091/A590 SCSI",
-	.proc_info		= wd33c93_proc_info,
+	.proc_ops		= &wd33c93_proc_ops,
 	.proc_name		= "A2901",
 	.queuecommand		= wd33c93_queuecommand,
 	.eh_abort_handler	= wd33c93_abort,
diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index e29fe0e..e74f99d 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -181,7 +181,7 @@ static int a3000_bus_reset(struct scsi_cmnd *cmd)
 static struct scsi_host_template amiga_a3000_scsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "Amiga 3000 built-in SCSI",
-	.proc_info		= wd33c93_proc_info,
+	.proc_ops		= &wd33c93_proc_ops,
 	.proc_name		= "A3000",
 	.queuecommand		= wd33c93_queuecommand,
 	.eh_abort_handler	= wd33c93_abort,
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 488fbc6..70aefaa 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -191,7 +191,7 @@ static int gvp11_bus_reset(struct scsi_cmnd *cmd)
 static struct scsi_host_template gvp11_scsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "GVP Series II SCSI",
-	.proc_info		= wd33c93_proc_info,
+	.proc_ops		= &wd33c93_proc_ops,
 	.proc_name		= "GVP11",
 	.queuecommand		= wd33c93_queuecommand,
 	.eh_abort_handler	= wd33c93_abort,
diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
index c29d0db..21d3c1c 100644
--- a/drivers/scsi/mvme147.c
+++ b/drivers/scsi/mvme147.c
@@ -76,7 +76,7 @@ int mvme147_detect(struct scsi_host_template *tpnt)
 	called++;
 
 	tpnt->proc_name = "MVME147";
-	tpnt->proc_info = &wd33c93_proc_info;
+	tpnt->proc_ops = &wd33c93_proc_ops;
 
 	instance = scsi_register(tpnt, sizeof(struct WD33C93_hostdata));
 	if (!instance)
diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index c0ee4ea..daad614 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -78,6 +78,8 @@
 
 #include <linux/module.h>
 
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/string.h>
 #include <linux/delay.h>
 #include <linux/init.h>
@@ -1978,7 +1980,7 @@ wd33c93_init(struct Scsi_Host *instance, const wd33c93_regs regs,
 
 #ifdef PROC_INTERFACE
 	hostdata->proc = PR_VERSION | PR_INFO | PR_STATISTICS |
-	    PR_CONNECTED | PR_INPUTQ | PR_DISCQ | PR_STOP;
+	    PR_CONNECTED | PR_INPUTQ | PR_DISCQ;
 #ifdef PROC_STATISTICS
 	hostdata->dma_cnt = 0;
 	hostdata->pio_cnt = 0;
@@ -2054,179 +2056,181 @@ wd33c93_init(struct Scsi_Host *instance, const wd33c93_regs regs,
 	printk("           Version %s - %s\n", WD33C93_VERSION, WD33C93_DATE);
 }
 
-int
-wd33c93_proc_info(struct Scsi_Host *instance, char *buf, char **start, off_t off, int len, int in)
+static int wd33c93_proc_show(struct seq_file *m, void *v)
 {
+	struct Scsi_Host *instance = m->private;
 
 #ifdef PROC_INTERFACE
 
-	char *bp;
-	char tbuf[128];
 	struct WD33C93_hostdata *hd;
 	struct scsi_cmnd *cmd;
 	int x;
-	static int stop = 0;
 
 	hd = (struct WD33C93_hostdata *) instance->hostdata;
 
-/* If 'in' is TRUE we need to _read_ the proc file. We accept the following
- * keywords (same format as command-line, but arguments are not optional):
- *    debug
- *    disconnect
- *    period
- *    resync
- *    proc
- *    nodma
- *    level2
- *    burst
- *    fast
- *    nosync
- */
-
-	if (in) {
-		buf[len] = '\0';
-		for (bp = buf; *bp; ) {
-			while (',' == *bp || ' ' == *bp)
-				++bp;
-		if (!strncmp(bp, "debug:", 6)) {
-				hd->args = simple_strtoul(bp+6, &bp, 0) & DB_MASK;
-		} else if (!strncmp(bp, "disconnect:", 11)) {
-				x = simple_strtoul(bp+11, &bp, 0);
-			if (x < DIS_NEVER || x > DIS_ALWAYS)
-				x = DIS_ADAPTIVE;
-			hd->disconnect = x;
-		} else if (!strncmp(bp, "period:", 7)) {
-			x = simple_strtoul(bp+7, &bp, 0);
-			hd->default_sx_per =
-				hd->sx_table[round_period((unsigned int) x,
-							  hd->sx_table)].period_ns;
-		} else if (!strncmp(bp, "resync:", 7)) {
-				set_resync(hd, (int)simple_strtoul(bp+7, &bp, 0));
-		} else if (!strncmp(bp, "proc:", 5)) {
-				hd->proc = simple_strtoul(bp+5, &bp, 0);
-		} else if (!strncmp(bp, "nodma:", 6)) {
-				hd->no_dma = simple_strtoul(bp+6, &bp, 0);
-		} else if (!strncmp(bp, "level2:", 7)) {
-				hd->level2 = simple_strtoul(bp+7, &bp, 0);
-			} else if (!strncmp(bp, "burst:", 6)) {
-				hd->dma_mode =
-					simple_strtol(bp+6, &bp, 0) ? CTRL_BURST:CTRL_DMA;
-			} else if (!strncmp(bp, "fast:", 5)) {
-				x = !!simple_strtol(bp+5, &bp, 0);
-				if (x != hd->fast)
-					set_resync(hd, 0xff);
-				hd->fast = x;
-			} else if (!strncmp(bp, "nosync:", 7)) {
-				x = simple_strtoul(bp+7, &bp, 0);
-				set_resync(hd, x ^ hd->no_sync);
-				hd->no_sync = x;
-			} else {
-				break; /* unknown keyword,syntax-error,... */
-			}
-		}
-		return len;
-	}
-
 	spin_lock_irq(&hd->lock);
-	bp = buf;
-	*bp = '\0';
 	if (hd->proc & PR_VERSION) {
-		sprintf(tbuf, "\nVersion %s - %s.",
+		seq_printf(m, "\nVersion %s - %s.\n",
 			WD33C93_VERSION, WD33C93_DATE);
-		strcat(bp, tbuf);
 	}
 	if (hd->proc & PR_INFO) {
-		sprintf(tbuf, "\nclock_freq=%02x no_sync=%02x no_dma=%d"
-			" dma_mode=%02x fast=%d",
+		seq_printf(m, "clock_freq=%02x no_sync=%02x no_dma=%d"
+			" dma_mode=%02x fast=%d\n",
 			hd->clock_freq, hd->no_sync, hd->no_dma, hd->dma_mode, hd->fast);
-		strcat(bp, tbuf);
-		strcat(bp, "\nsync_xfer[] =       ");
+		seq_printf(m, "sync_xfer[] =       ");
 		for (x = 0; x < 7; x++) {
-			sprintf(tbuf, "\t%02x", hd->sync_xfer[x]);
-			strcat(bp, tbuf);
+			seq_printf(m, "\t%02x", hd->sync_xfer[x]);
 		}
-		strcat(bp, "\nsync_stat[] =       ");
+		seq_putc(m, '\n');
+		seq_printf(m, "sync_stat[] =       ");
 		for (x = 0; x < 7; x++) {
-			sprintf(tbuf, "\t%02x", hd->sync_stat[x]);
-			strcat(bp, tbuf);
+			seq_printf(m, "\t%02x", hd->sync_stat[x]);
 		}
+		seq_putc(m, '\n');
 	}
 #ifdef PROC_STATISTICS
 	if (hd->proc & PR_STATISTICS) {
-		strcat(bp, "\ncommands issued:    ");
+		seq_printf(m, "commands issued:    ");
 		for (x = 0; x < 7; x++) {
-			sprintf(tbuf, "\t%ld", hd->cmd_cnt[x]);
-			strcat(bp, tbuf);
+			seq_printf(m, "\t%ld", hd->cmd_cnt[x]);
 		}
-		strcat(bp, "\ndisconnects allowed:");
+		seq_putc(m, '\n');
+		seq_printf(m, "disconnects allowed:");
 		for (x = 0; x < 7; x++) {
-			sprintf(tbuf, "\t%ld", hd->disc_allowed_cnt[x]);
-			strcat(bp, tbuf);
+			seq_printf(m, "\t%ld", hd->disc_allowed_cnt[x]);
 		}
-		strcat(bp, "\ndisconnects done:   ");
+		seq_putc(m, '\n');
+		seq_printf(m, "disconnects done:   ");
 		for (x = 0; x < 7; x++) {
-			sprintf(tbuf, "\t%ld", hd->disc_done_cnt[x]);
-			strcat(bp, tbuf);
+			seq_printf(m, "\t%ld", hd->disc_done_cnt[x]);
 		}
-		sprintf(tbuf,
-			"\ninterrupts: %ld, DATA_PHASE ints: %ld DMA, %ld PIO",
+		seq_putc(m, '\n');
+		seq_printf(m,
+			"interrupts: %ld, DATA_PHASE ints: %ld DMA, %ld PIO\n",
 			hd->int_cnt, hd->dma_cnt, hd->pio_cnt);
-		strcat(bp, tbuf);
 	}
 #endif
 	if (hd->proc & PR_CONNECTED) {
-		strcat(bp, "\nconnected:     ");
+		seq_printf(m, "connected:     ");
 		if (hd->connected) {
 			cmd = (struct scsi_cmnd *) hd->connected;
-			sprintf(tbuf, " %d:%d(%02x)",
+			seq_printf(m, " %d:%d(%02x)",
 				cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
-			strcat(bp, tbuf);
+			seq_putc(m, '\n');
 		}
 	}
 	if (hd->proc & PR_INPUTQ) {
-		strcat(bp, "\ninput_Q:       ");
+		seq_printf(m, "input_Q:       ");
 		cmd = (struct scsi_cmnd *) hd->input_Q;
 		while (cmd) {
-			sprintf(tbuf, " %d:%d(%02x)",
+			seq_printf(m, " %d:%d(%02x)",
 				cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
-			strcat(bp, tbuf);
 			cmd = (struct scsi_cmnd *) cmd->host_scribble;
 		}
+		seq_putc(m, '\n');
 	}
 	if (hd->proc & PR_DISCQ) {
-		strcat(bp, "\ndisconnected_Q:");
+		seq_printf(m, "disconnected_Q:");
 		cmd = (struct scsi_cmnd *) hd->disconnected_Q;
 		while (cmd) {
-			sprintf(tbuf, " %d:%d(%02x)",
+			seq_printf(m, " %d:%d(%02x)",
 				cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
-			strcat(bp, tbuf);
 			cmd = (struct scsi_cmnd *) cmd->host_scribble;
 		}
+		seq_putc(m, '\n');
 	}
-	strcat(bp, "\n");
 	spin_unlock_irq(&hd->lock);
-	*start = buf;
-	if (stop) {
-		stop = 0;
-		return 0;
-	}
-	if (off > 0x40000)	/* ALWAYS stop after 256k bytes have been read */
-		stop = 1;
-	if (hd->proc & PR_STOP)	/* stop every other time */
-		stop = 1;
-	return strlen(bp);
 
-#else				/* PROC_INTERFACE */
+#endif				/* PROC_INTERFACE */
 
 	return 0;
+}
 
-#endif				/* PROC_INTERFACE */
+static int wd33c93_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wd33c93_proc_show, PDE(inode)->data);
+}
 
+static ssize_t wd33c93_proc_write(struct file *file, const char __user *buf, size_t count, loff_t *pos)
+{
+	struct Scsi_Host *instance = PDE(file->f_path.dentry->d_inode)->data;
+	struct WD33C93_hostdata *hd = (struct WD33C93_hostdata *)instance->hostdata;
+	char kbuf[42], *bp;
+	size_t len;
+	int x;
+
+	len = min(count, sizeof(kbuf) - 1);
+	if (copy_from_user(kbuf, buf, len))
+		return -EFAULT;
+	kbuf[len] = '\0';
+
+	/*
+	 * We accept the following keywords (same format as command-line,
+	 * but arguments are not optional):
+	 *    debug
+	 *    disconnect
+	 *    period
+	 *    resync
+	 *    proc
+	 *    nodma
+	 *    level2
+	 *    burst
+	 *    fast
+	 *    nosync
+	 */
+	for (bp = kbuf; *bp; ) {
+		while (',' == *bp || ' ' == *bp)
+			++bp;
+		if (!strncmp(bp, "debug:", 6)) {
+			hd->args = simple_strtoul(bp+6, &bp, 0) & DB_MASK;
+		} else if (!strncmp(bp, "disconnect:", 11)) {
+			x = simple_strtoul(bp+11, &bp, 0);
+			if (x < DIS_NEVER || x > DIS_ALWAYS)
+				x = DIS_ADAPTIVE;
+			hd->disconnect = x;
+		} else if (!strncmp(bp, "period:", 7)) {
+			x = simple_strtoul(bp+7, &bp, 0);
+			hd->default_sx_per =
+				hd->sx_table[round_period((unsigned int) x,
+						hd->sx_table)].period_ns;
+		} else if (!strncmp(bp, "resync:", 7)) {
+			set_resync(hd, (int)simple_strtoul(bp+7, &bp, 0));
+		} else if (!strncmp(bp, "proc:", 5)) {
+			hd->proc = simple_strtoul(bp+5, &bp, 0);
+		} else if (!strncmp(bp, "nodma:", 6)) {
+			hd->no_dma = simple_strtoul(bp+6, &bp, 0);
+		} else if (!strncmp(bp, "level2:", 7)) {
+			hd->level2 = simple_strtoul(bp+7, &bp, 0);
+		} else if (!strncmp(bp, "burst:", 6)) {
+			hd->dma_mode =
+				simple_strtol(bp+6, &bp, 0) ? CTRL_BURST:CTRL_DMA;
+		} else if (!strncmp(bp, "fast:", 5)) {
+			x = !!simple_strtol(bp+5, &bp, 0);
+			if (x != hd->fast)
+				set_resync(hd, 0xff);
+			hd->fast = x;
+		} else if (!strncmp(bp, "nosync:", 7)) {
+			x = simple_strtoul(bp+7, &bp, 0);
+			set_resync(hd, x ^ hd->no_sync);
+			hd->no_sync = x;
+		} else {
+			break; /* unknown keyword,syntax-error,... */
+		}
+	}
+	return count;
 }
 
+const struct file_operations wd33c93_proc_ops = {
+	.open		= wd33c93_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= wd33c93_proc_write,
+};
+
 EXPORT_SYMBOL(wd33c93_host_reset);
 EXPORT_SYMBOL(wd33c93_init);
 EXPORT_SYMBOL(wd33c93_abort);
 EXPORT_SYMBOL(wd33c93_queuecommand);
 EXPORT_SYMBOL(wd33c93_intr);
-EXPORT_SYMBOL(wd33c93_proc_info);
+EXPORT_SYMBOL(wd33c93_proc_ops);
diff --git a/drivers/scsi/wd33c93.h b/drivers/scsi/wd33c93.h
index 3b463d7..49974b2 100644
--- a/drivers/scsi/wd33c93.h
+++ b/drivers/scsi/wd33c93.h
@@ -337,7 +337,6 @@ struct WD33C93_hostdata {
 #define PR_INPUTQ    1<<4
 #define PR_DISCQ     1<<5
 #define PR_TEST      1<<6
-#define PR_STOP      1<<7
 
 
 void wd33c93_init (struct Scsi_Host *instance, const wd33c93_regs regs,
@@ -345,7 +344,7 @@ void wd33c93_init (struct Scsi_Host *instance, const wd33c93_regs regs,
 int wd33c93_abort (struct scsi_cmnd *cmd);
 int wd33c93_queuecommand (struct Scsi_Host *h, struct scsi_cmnd *cmd);
 void wd33c93_intr (struct Scsi_Host *instance);
-int wd33c93_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
+extern const struct file_operations wd33c93_proc_ops;
 int wd33c93_host_reset (struct scsi_cmnd *);
 
 #endif /* WD33C93_H */
-- 
1.7.3.4

