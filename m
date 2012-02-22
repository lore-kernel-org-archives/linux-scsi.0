From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 31/34] scsi proc_ops: convert NCR5380-based drivers
Date: Wed, 22 Feb 2012 22:46:22 +0300
Message-ID: <1329939985-26793-31-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39744 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab2BVTr3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:47:29 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so434475bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:47:28 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/NCR5380.c    |  100 ++++++++++++++++++++++----------------------
 drivers/scsi/NCR5380.h    |    3 +-
 drivers/scsi/arm/oak.c    |    4 +-
 drivers/scsi/atari_scsi.c |    2 +-
 drivers/scsi/atari_scsi.h |    2 +-
 drivers/scsi/dtc.c        |    2 +-
 drivers/scsi/dtc.h        |    2 +-
 drivers/scsi/mac_scsi.c   |    2 +-
 drivers/scsi/mac_scsi.h   |    2 +-
 drivers/scsi/pas16.c      |    2 +-
 drivers/scsi/pas16.h      |    2 +-
 drivers/scsi/t128.c       |    2 +-
 drivers/scsi/t128.h       |    2 +-
 13 files changed, 63 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 165e4dd86..ec9822d 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -86,6 +86,8 @@
  * 5.  Test linked command handling code after Eric is ready with 
  *      the high level code.
  */
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_transport_spi.h>
 
@@ -696,32 +698,36 @@ static void NCR5380_print_status(struct Scsi_Host *instance)
  */
 
 #undef SPRINTF
-#define SPRINTF(args...) do { if(pos < buffer + length-80) pos += sprintf(pos, ## args); } while(0)
-static
-char *lprint_Scsi_Cmnd(Scsi_Cmnd * cmd, char *pos, char *buffer, int length);
-static
-char *lprint_command(unsigned char *cmd, char *pos, char *buffer, int len);
-static
-char *lprint_opcode(int opcode, char *pos, char *buffer, int length);
-
-static int __maybe_unused NCR5380_proc_info(struct Scsi_Host *instance,
-	char *buffer, char **start, off_t offset, int length, int inout)
+#define SPRINTF(args...) seq_printf(m, ## args)
+
+static void lprint_opcode(struct seq_file *m, int opcode)
 {
-	char *pos = buffer;
-	struct NCR5380_hostdata *hostdata;
-	Scsi_Cmnd *ptr;
+	SPRINTF("%2d (0x%02x)", opcode, opcode);
+}
 
-	hostdata = (struct NCR5380_hostdata *) instance->hostdata;
+static void lprint_command(struct seq_file *m, unsigned char *command)
+{
+	int i, s;
+
+	lprint_opcode(m, command[0]);
+	for (i = 1, s = COMMAND_SIZE(command[0]); i < s; ++i)
+		SPRINTF("%02x ", command[i]);
+	SPRINTF("\n");
+}
+
+static void lprint_Scsi_Cmnd(struct seq_file *m, Scsi_Cmnd *cmd)
+{
+	SPRINTF("scsi%d : destination target %d, lun %d\n", cmd->device->host->host_no, cmd->device->id, cmd->device->lun);
+	SPRINTF("        command = ");
+	lprint_command(m, cmd->cmnd);
+}
+
+static int NCR5380_proc_show(struct seq_file *m, void *v)
+{
+	struct Scsi_Host *instance = m->private;
+	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *)instance->hostdata;
+	Scsi_Cmnd *ptr;
 
-	if (inout) {		/* Has data been written to the file ? */
-#ifdef DTC_PUBLIC_RELEASE
-		dtc_wmaxi = dtc_maxi = 0;
-#endif
-#ifdef PAS16_PUBLIC_RELEASE
-		pas_wmaxi = pas_maxi = 0;
-#endif
-		return (-ENOSYS);	/* Currently this is a no-op */
-	}
 	SPRINTF("NCR5380 core release=%d.   ", NCR5380_PUBLIC_RELEASE);
 	if (((struct NCR5380_hostdata *) instance->hostdata)->flags & FLAG_NCR53C400)
 		SPRINTF("ncr53c400 release=%d.  ", NCR53C400_PUBLIC_RELEASE);
@@ -755,48 +761,42 @@ static int __maybe_unused NCR5380_proc_info(struct Scsi_Host *instance,
 	if (!hostdata->connected)
 		SPRINTF("scsi%d: no currently connected command\n", instance->host_no);
 	else
-		pos = lprint_Scsi_Cmnd((Scsi_Cmnd *) hostdata->connected, pos, buffer, length);
+		lprint_Scsi_Cmnd(m, (Scsi_Cmnd *) hostdata->connected);
 	SPRINTF("scsi%d: issue_queue\n", instance->host_no);
 	for (ptr = (Scsi_Cmnd *) hostdata->issue_queue; ptr; ptr = (Scsi_Cmnd *) ptr->host_scribble)
-		pos = lprint_Scsi_Cmnd(ptr, pos, buffer, length);
+		lprint_Scsi_Cmnd(m, ptr);
 
 	SPRINTF("scsi%d: disconnected_queue\n", instance->host_no);
 	for (ptr = (Scsi_Cmnd *) hostdata->disconnected_queue; ptr; ptr = (Scsi_Cmnd *) ptr->host_scribble)
-		pos = lprint_Scsi_Cmnd(ptr, pos, buffer, length);
+		lprint_Scsi_Cmnd(m, ptr);
 	spin_unlock_irq(instance->host_lock);
 	
-	*start = buffer;
-	if (pos - buffer < offset)
-		return 0;
-	else if (pos - buffer - offset < length)
-		return pos - buffer - offset;
-	return length;
+	return 0;
 }
 
-static char *lprint_Scsi_Cmnd(Scsi_Cmnd * cmd, char *pos, char *buffer, int length)
+static int NCR5380_proc_open(struct inode *inode, struct file *file)
 {
-	SPRINTF("scsi%d : destination target %d, lun %d\n", cmd->device->host->host_no, cmd->device->id, cmd->device->lun);
-	SPRINTF("        command = ");
-	pos = lprint_command(cmd->cmnd, pos, buffer, length);
-	return (pos);
+	return single_open(file, NCR5380_proc_show, PDE(inode)->data);
 }
 
-static char *lprint_command(unsigned char *command, char *pos, char *buffer, int length)
+static ssize_t NCR5380_proc_write(struct file *file, const char __user *buf, size_t count, loff_t *pos)
 {
-	int i, s;
-	pos = lprint_opcode(command[0], pos, buffer, length);
-	for (i = 1, s = COMMAND_SIZE(command[0]); i < s; ++i)
-		SPRINTF("%02x ", command[i]);
-	SPRINTF("\n");
-	return (pos);
-}
-
-static char *lprint_opcode(int opcode, char *pos, char *buffer, int length)
-{
-	SPRINTF("%2d (0x%02x)", opcode, opcode);
-	return (pos);
+#ifdef DTC_PUBLIC_RELEASE
+	dtc_wmaxi = dtc_maxi = 0;
+#endif
+#ifdef PAS16_PUBLIC_RELEASE
+	pas_wmaxi = pas_maxi = 0;
+#endif
+	return -ENOSYS;
 }
 
+static const struct file_operations __maybe_unused NCR5380_proc_ops = {
+	.open		= NCR5380_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= NCR5380_proc_write,
+};
 
 /**
  *	NCR5380_init	-	initialise an NCR5380
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index fd40a32..00445e2 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -314,8 +314,7 @@ static void NCR5380_print(struct Scsi_Host *instance);
 static int NCR5380_abort(Scsi_Cmnd * cmd);
 static int NCR5380_bus_reset(Scsi_Cmnd * cmd);
 static int NCR5380_queue_command(struct Scsi_Host *, struct scsi_cmnd *);
-static int __maybe_unused NCR5380_proc_info(struct Scsi_Host *instance,
-	char *buffer, char **start, off_t offset, int length, int inout);
+static const struct file_operations __maybe_unused NCR5380_proc_ops;
 
 static void NCR5380_reselect(struct Scsi_Host *instance);
 static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag);
diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
index 849cdf8..d738399 100644
--- a/drivers/scsi/arm/oak.c
+++ b/drivers/scsi/arm/oak.c
@@ -31,7 +31,7 @@
 #define NCR5380_write(reg, value)	writeb(value, _base + ((reg) << 2))
 #define NCR5380_intr			oakscsi_intr
 #define NCR5380_queue_command		oakscsi_queue_command
-#define NCR5380_proc_info		oakscsi_proc_info
+#define NCR5380_proc_ops		oakscsi_proc_ops
 
 #define NCR5380_implementation_fields	\
 	void __iomem *base
@@ -115,7 +115,7 @@ printk("reading %p len %d\n", addr, len);
 
 static struct scsi_host_template oakscsi_template = {
 	.module			= THIS_MODULE,
-	.proc_info		= oakscsi_proc_info,
+	.proc_ops		= &oakscsi_proc_ops,
 	.name			= "Oak 16-bit SCSI",
 	.info			= oakscsi_info,
 	.queuecommand		= oakscsi_queue_command,
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 04a154f..0674d17 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -1090,7 +1090,7 @@ static void atari_scsi_falcon_reg_write(unsigned char reg, unsigned char value)
 #include "atari_NCR5380.c"
 
 static struct scsi_host_template driver_template = {
-	.proc_info		= atari_scsi_proc_info,
+	.proc_ops		= &atari_scsi_proc_ops,
 	.name			= "Atari native SCSI",
 	.detect			= atari_scsi_detect,
 	.release		= atari_scsi_release,
diff --git a/drivers/scsi/atari_scsi.h b/drivers/scsi/atari_scsi.h
index efadb8d..0e12195 100644
--- a/drivers/scsi/atari_scsi.h
+++ b/drivers/scsi/atari_scsi.h
@@ -52,7 +52,7 @@ int atari_scsi_release (struct Scsi_Host *);
 #define NCR5380_intr atari_scsi_intr
 #define NCR5380_queue_command atari_scsi_queue_command
 #define NCR5380_abort atari_scsi_abort
-#define NCR5380_proc_info atari_scsi_proc_info
+#define NCR5380_proc_ops atari_scsi_proc_ops
 #define NCR5380_dma_read_setup(inst,d,c) atari_scsi_dma_setup (inst, d, c, 0)
 #define NCR5380_dma_write_setup(inst,d,c) atari_scsi_dma_setup (inst, d, c, 1)
 #define NCR5380_dma_residual(inst) atari_scsi_dma_residual( inst )
diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
index c2677ba..b98b1f1 100644
--- a/drivers/scsi/dtc.c
+++ b/drivers/scsi/dtc.c
@@ -217,7 +217,7 @@ static int __init dtc_detect(struct scsi_host_template * tpnt)
 	int sig, count;
 
 	tpnt->proc_name = "dtc3x80";
-	tpnt->proc_info = &dtc_proc_info;
+	tpnt->proc_ops = &dtc_proc_ops;
 
 	for (count = 0; current_override < NO_OVERRIDES; ++current_override) {
 		addr = 0;
diff --git a/drivers/scsi/dtc.h b/drivers/scsi/dtc.h
index cdc6212..e1ef490 100644
--- a/drivers/scsi/dtc.h
+++ b/drivers/scsi/dtc.h
@@ -88,7 +88,7 @@ static int dtc_bus_reset(Scsi_Cmnd *);
 #define NCR5380_queue_command		dtc_queue_command
 #define NCR5380_abort			dtc_abort
 #define NCR5380_bus_reset		dtc_bus_reset
-#define NCR5380_proc_info		dtc_proc_info 
+#define NCR5380_proc_ops		dtc_proc_ops
 
 /* 15 12 11 10
    1001 1100 0000 0000 */
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 2bccfbe..1c2e2a1 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -562,7 +562,7 @@ static int macscsi_pwrite (struct Scsi_Host *instance,
 
 static struct scsi_host_template driver_template = {
 	.proc_name			= "Mac5380",
-	.proc_info			= macscsi_proc_info,
+	.proc_ops			= &macscsi_proc_ops,
 	.name				= "Macintosh NCR5380 SCSI",
 	.detect				= macscsi_detect,
 	.release			= macscsi_release,
diff --git a/drivers/scsi/mac_scsi.h b/drivers/scsi/mac_scsi.h
index d26e331..1e6f673 100644
--- a/drivers/scsi/mac_scsi.h
+++ b/drivers/scsi/mac_scsi.h
@@ -72,7 +72,7 @@
 #define NCR5380_queue_command macscsi_queue_command
 #define NCR5380_abort macscsi_abort
 #define NCR5380_bus_reset macscsi_bus_reset
-#define NCR5380_proc_info macscsi_proc_info
+#define NCR5380_proc_ops macscsi_proc_ops
 
 #define BOARD_NORMAL	0
 #define BOARD_NCR53C400	1
diff --git a/drivers/scsi/pas16.c b/drivers/scsi/pas16.c
index f2018b4..25c42b1 100644
--- a/drivers/scsi/pas16.c
+++ b/drivers/scsi/pas16.c
@@ -389,7 +389,7 @@ int __init pas16_detect(struct scsi_host_template * tpnt)
     int  count;
 
     tpnt->proc_name = "pas16";
-    tpnt->proc_info = &pas16_proc_info;
+    tpnt->proc_ops = &pas16_proc_ops;
 
     if (pas16_addr != 0) {
 	overrides[0].io_port = pas16_addr;
diff --git a/drivers/scsi/pas16.h b/drivers/scsi/pas16.h
index a04281c..ecec4d9 100644
--- a/drivers/scsi/pas16.h
+++ b/drivers/scsi/pas16.h
@@ -163,7 +163,7 @@ static int pas16_bus_reset(Scsi_Cmnd *);
 #define NCR5380_queue_command pas16_queue_command
 #define NCR5380_abort pas16_abort
 #define NCR5380_bus_reset pas16_bus_reset
-#define NCR5380_proc_info pas16_proc_info
+#define NCR5380_proc_ops pas16_proc_ops
 
 /* 15 14 12 10 7 5 3 
    1101 0100 1010 1000 */
diff --git a/drivers/scsi/t128.c b/drivers/scsi/t128.c
index 041eaaa..1ba9b1b 100644
--- a/drivers/scsi/t128.c
+++ b/drivers/scsi/t128.c
@@ -202,7 +202,7 @@ int __init t128_detect(struct scsi_host_template * tpnt){
     int sig, count;
 
     tpnt->proc_name = "t128";
-    tpnt->proc_info = &t128_proc_info;
+    tpnt->proc_ops = &t128_proc_ops;
 
     for (count = 0; current_override < NO_OVERRIDES; ++current_override) {
 	base = 0;
diff --git a/drivers/scsi/t128.h b/drivers/scsi/t128.h
index ada1115..4992f7d 100644
--- a/drivers/scsi/t128.h
+++ b/drivers/scsi/t128.h
@@ -140,7 +140,7 @@ static int t128_bus_reset(struct scsi_cmnd *);
 #define NCR5380_queue_command t128_queue_command
 #define NCR5380_abort t128_abort
 #define NCR5380_bus_reset t128_bus_reset
-#define NCR5380_proc_info t128_proc_info
+#define NCR5380_proc_ops t128_proc_ops
 
 /* 15 14 12 10 7 5 3
    1101 0100 1010 1000 */
-- 
1.7.3.4

