From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next 2/2] sun3_scsi: switch to ->show_info()
Date: Wed, 10 Apr 2013 13:52:09 +0200
Message-ID: <1365594729-25759-2-git-send-email-geert@linux-m68k.org>
References: <1365594729-25759-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1365594729-25759-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Based on Al's changes to atari_scsi.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/8543326/

 drivers/scsi/sun3_NCR5380.c |  185 ++++++++++++++++++------------------------
 drivers/scsi/sun3_scsi.c    |    2 +-
 drivers/scsi/sun3_scsi.h    |    2 +-
 3 files changed, 81 insertions(+), 108 deletions(-)

diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 7e12a2e..636bbe0 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -661,121 +661,94 @@ static void __init NCR5380_print_options (struct Scsi_Host *instance)
  * Inputs : instance, pointer to this instance.  
  */
 
-static void NCR5380_print_status (struct Scsi_Host *instance)
+static void lprint_Scsi_Cmnd(Scsi_Cmnd *cmd)
 {
-    char *pr_bfr;
-    char *start;
-    int len;
-
-    NCR_PRINT(NDEBUG_ANY);
-    NCR_PRINT_PHASE(NDEBUG_ANY);
-
-    pr_bfr = (char *) __get_free_page(GFP_ATOMIC);
-    if (!pr_bfr) {
-	printk("NCR5380_print_status: no memory for print buffer\n");
-	return;
-    }
-    len = NCR5380_proc_info(instance, pr_bfr, &start, 0, PAGE_SIZE, 0);
-    pr_bfr[len] = 0;
-    printk("\n%s\n", pr_bfr);
-    free_page((unsigned long) pr_bfr);
+	int i, s;
+	unsigned char *command;
+	printk("scsi%d: destination target %d, lun %d\n",
+		H_NO(cmd), cmd->device->id, cmd->device->lun);
+	printk(KERN_CONT "        command = ");
+	command = cmd->cmnd;
+	printk(KERN_CONT "%2d (0x%02x)", command[0], command[0]);
+	for (i = 1, s = COMMAND_SIZE(command[0]); i < s; ++i)
+		printk(KERN_CONT " %02x", command[i]);
+	printk("\n");
 }
 
-
-/******************************************/
-/*
- * /proc/scsi/[dtc pas16 t128 generic]/[0-ASC_NUM_BOARD_SUPPORTED]
- *
- * *buffer: I/O buffer
- * **start: if inout == FALSE pointer into buffer where user read should start
- * offset: current offset
- * length: length of buffer
- * hostno: Scsi_Host host_no
- * inout: TRUE - user is writing; FALSE - user is reading
- *
- * Return the number of bytes read from or written
-*/
-
-#undef SPRINTF
-#define SPRINTF(fmt,args...) \
-  do { if (pos + strlen(fmt) + 20 /* slop */ < buffer + length) \
-	 pos += sprintf(pos, fmt , ## args); } while(0)
-static
-char *lprint_Scsi_Cmnd(struct scsi_cmnd *cmd, char *pos, char *buffer,
-		       int length);
-
-static int NCR5380_proc_info(struct Scsi_Host *instance, char *buffer,
-			     char **start, off_t offset, int length, int inout)
+static void NCR5380_print_status(struct Scsi_Host *instance)
 {
-    char *pos = buffer;
-    struct NCR5380_hostdata *hostdata;
-    struct scsi_cmnd *ptr;
-    unsigned long flags;
-    off_t begin = 0;
-#define check_offset()				\
-    do {					\
-	if (pos - buffer < offset - begin) {	\
-	    begin += pos - buffer;		\
-	    pos = buffer;			\
-	}					\
-    } while (0)
-
-    hostdata = (struct NCR5380_hostdata *)instance->hostdata;
-
-    if (inout) { /* Has data been written to the file ? */
-	return(-ENOSYS);  /* Currently this is a no-op */
-    }
-    SPRINTF("NCR5380 core release=%d.\n", NCR5380_PUBLIC_RELEASE);
-    check_offset();
-    local_irq_save(flags);
-    SPRINTF("NCR5380: coroutine is%s running.\n", main_running ? "" : "n't");
-    check_offset();
-    if (!hostdata->connected)
-	SPRINTF("scsi%d: no currently connected command\n", HOSTNO);
-    else
-	pos = lprint_Scsi_Cmnd ((struct scsi_cmnd *) hostdata->connected,
-				pos, buffer, length);
-    SPRINTF("scsi%d: issue_queue\n", HOSTNO);
-    check_offset();
-    for (ptr = (struct scsi_cmnd *) hostdata->issue_queue; ptr; ptr = NEXT(ptr))
-    {
-	pos = lprint_Scsi_Cmnd (ptr, pos, buffer, length);
-	check_offset();
-    }
-
-    SPRINTF("scsi%d: disconnected_queue\n", HOSTNO);
-    check_offset();
-    for (ptr = (struct scsi_cmnd *) hostdata->disconnected_queue; ptr;
-	 ptr = NEXT(ptr)) {
-	pos = lprint_Scsi_Cmnd (ptr, pos, buffer, length);
-	check_offset();
-    }
+	struct NCR5380_hostdata *hostdata;
+	Scsi_Cmnd *ptr;
+	unsigned long flags;
+
+	NCR_PRINT(NDEBUG_ANY);
+	NCR_PRINT_PHASE(NDEBUG_ANY);
+
+	hostdata = (struct NCR5380_hostdata *)instance->hostdata;
+
+	printk("\nNCR5380 core release=%d.\n", NCR5380_PUBLIC_RELEASE);
+	local_irq_save(flags);
+	printk("NCR5380: coroutine is%s running.\n",
+		main_running ? "" : "n't");
+	if (!hostdata->connected)
+		printk("scsi%d: no currently connected command\n", HOSTNO);
+	else
+		lprint_Scsi_Cmnd((Scsi_Cmnd *) hostdata->connected);
+	printk("scsi%d: issue_queue\n", HOSTNO);
+	for (ptr = (Scsi_Cmnd *)hostdata->issue_queue; ptr; ptr = NEXT(ptr))
+		lprint_Scsi_Cmnd(ptr);
+
+	printk("scsi%d: disconnected_queue\n", HOSTNO);
+	for (ptr = (Scsi_Cmnd *) hostdata->disconnected_queue; ptr;
+	     ptr = NEXT(ptr))
+		lprint_Scsi_Cmnd(ptr);
 
-    local_irq_restore(flags);
-    *start = buffer + (offset - begin);
-    if (pos - buffer < offset - begin)
-	return 0;
-    else if (pos - buffer - (offset - begin) < length)
-	return pos - buffer - (offset - begin);
-    return length;
+	local_irq_restore(flags);
+	printk("\n");
 }
 
-static char *lprint_Scsi_Cmnd(struct scsi_cmnd *cmd, char *pos, char *buffer,
-			      int length)
+static void show_Scsi_Cmnd(Scsi_Cmnd *cmd, struct seq_file *m)
 {
-    int i, s;
-    unsigned char *command;
-    SPRINTF("scsi%d: destination target %d, lun %d\n",
-	    H_NO(cmd), cmd->device->id, cmd->device->lun);
-    SPRINTF("        command = ");
-    command = cmd->cmnd;
-    SPRINTF("%2d (0x%02x)", command[0], command[0]);
-    for (i = 1, s = COMMAND_SIZE(command[0]); i < s; ++i)
-	SPRINTF(" %02x", command[i]);
-    SPRINTF("\n");
-    return pos;
+	int i, s;
+	unsigned char *command;
+	seq_printf(m, "scsi%d: destination target %d, lun %d\n",
+		H_NO(cmd), cmd->device->id, cmd->device->lun);
+	seq_printf(m, "        command = ");
+	command = cmd->cmnd;
+	seq_printf(m, "%2d (0x%02x)", command[0], command[0]);
+	for (i = 1, s = COMMAND_SIZE(command[0]); i < s; ++i)
+		seq_printf(m, " %02x", command[i]);
+	seq_printf(m, "\n");
 }
 
+static int NCR5380_show_info(struct seq_file *m, struct Scsi_Host *instance)
+{
+	struct NCR5380_hostdata *hostdata;
+	Scsi_Cmnd *ptr;
+	unsigned long flags;
+
+	hostdata = (struct NCR5380_hostdata *)instance->hostdata;
+
+	seq_printf(m, "NCR5380 core release=%d.\n", NCR5380_PUBLIC_RELEASE);
+	local_irq_save(flags);
+	seq_printf(m, "NCR5380: coroutine is%s running.\n",
+		main_running ? "" : "n't");
+	if (!hostdata->connected)
+		seq_printf(m, "scsi%d: no currently connected command\n", HOSTNO);
+	else
+		show_Scsi_Cmnd((Scsi_Cmnd *) hostdata->connected, m);
+	seq_printf(m, "scsi%d: issue_queue\n", HOSTNO);
+	for (ptr = (Scsi_Cmnd *)hostdata->issue_queue; ptr; ptr = NEXT(ptr))
+		show_Scsi_Cmnd(ptr, m);
+
+	seq_printf(m, "scsi%d: disconnected_queue\n", HOSTNO);
+	for (ptr = (Scsi_Cmnd *) hostdata->disconnected_queue; ptr;
+	     ptr = NEXT(ptr))
+		show_Scsi_Cmnd(ptr, m);
+
+	local_irq_restore(flags);
+	return 0;
+}
 
 /* 
  * Function : void NCR5380_init (struct Scsi_Host *instance)
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index b0dc034..e2c009b 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -626,7 +626,7 @@ static int sun3scsi_dma_finish(int write_flag)
 #include "sun3_NCR5380.c"
 
 static struct scsi_host_template driver_template = {
-	.proc_info		= sun3scsi_proc_info,
+	.show_info		= sun3scsi_show_info,
 	.name			= SUN3_SCSI_NAME,
 	.detect			= sun3scsi_detect,
 	.release		= sun3scsi_release,
diff --git a/drivers/scsi/sun3_scsi.h b/drivers/scsi/sun3_scsi.h
index bcefd84..a8da9c7 100644
--- a/drivers/scsi/sun3_scsi.h
+++ b/drivers/scsi/sun3_scsi.h
@@ -100,7 +100,7 @@ static int sun3scsi_release (struct Scsi_Host *);
 #define NCR5380_queue_command sun3scsi_queue_command
 #define NCR5380_bus_reset sun3scsi_bus_reset
 #define NCR5380_abort sun3scsi_abort
-#define NCR5380_proc_info sun3scsi_proc_info
+#define NCR5380_show_info sun3scsi_show_info
 #define NCR5380_dma_xfer_len(i, cmd, phase) \
         sun3scsi_dma_xfer_len(cmd->SCp.this_residual,cmd,((phase) & SR_IO) ? 0 : 1)
 
-- 
1.7.0.4
