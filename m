From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 51/78] ncr5380: Remove command list debug code
Date: Sun, 03 Jan 2016 16:05:52 +1100
Message-ID: <20160103050514.541837450@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline; filename=ncr5380-remove-cmd-list-debug-code
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Some NCR5380 hosts offer a .show_info method to access the contents of
the various command list data structures from a procfs file. When NDEBUG
is set, the same information is sent to the console during EH.

The two core drivers, atari_NCR5380.c and NCR5380.c differ here. Because
it is just for debugging, the easiest way to fix the discrepancy is
simply remove this code.

The only remaining users of NCR5380_show_info() and NCR5380_write_info()
are drivers that define PSEUDO_DMA. The others have no use for the
.show_info method, so don't initialize it.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |   70 ++------------------------------
 drivers/scsi/arm/oak.c       |    2 
 drivers/scsi/atari_NCR5380.c |   94 +------------------------------------------
 drivers/scsi/atari_scsi.c    |    2 
 drivers/scsi/g_NCR5380.c     |    1 
 drivers/scsi/sun3_scsi.c     |    2 
 6 files changed, 9 insertions(+), 162 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:04:09.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:04:12.000000000 +1100
@@ -558,22 +558,6 @@ static void prepare_info(struct Scsi_Hos
 	         "");
 }
 
-/**
- *	NCR5380_print_status 	-	dump controller info
- *	@instance: controller to dump
- *
- *	Print commands in the various queues, called from NCR5380_abort 
- *	and NCR5380_debug to aid debugging.
- *
- *	Locks: called functions disable irqs
- */
-
-static void __maybe_unused NCR5380_print_status(struct Scsi_Host *instance)
-{
-	NCR5380_dprint(NDEBUG_ANY, instance);
-	NCR5380_dprint_phase(NDEBUG_ANY, instance);
-}
-
 #ifdef PSEUDO_DMA
 /******************************************/
 /*
@@ -598,65 +582,19 @@ static int __maybe_unused NCR5380_write_
 	hostdata->spin_max_w = 0;
 	return 0;
 }
-#endif
-
-static
-void lprint_Scsi_Cmnd(struct scsi_cmnd *cmd, struct seq_file *m);
-static
-void lprint_command(unsigned char *cmd, struct seq_file *m);
-static
-void lprint_opcode(int opcode, struct seq_file *m);
 
 static int __maybe_unused NCR5380_show_info(struct seq_file *m,
 	struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata;
-	struct scsi_cmnd *ptr;
-	unsigned long flags;
 
 	hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 
-#ifdef PSEUDO_DMA
 	seq_printf(m, "Highwater I/O busy spin counts: write %d, read %d\n",
 	        hostdata->spin_max_w, hostdata->spin_max_r);
-#endif
-	spin_lock_irqsave(&hostdata->lock, flags);
-	if (!hostdata->connected)
-		seq_printf(m, "scsi%d: no currently connected command\n", instance->host_no);
-	else
-		lprint_Scsi_Cmnd((struct scsi_cmnd *) hostdata->connected, m);
-	seq_printf(m, "scsi%d: issue_queue\n", instance->host_no);
-	for (ptr = (struct scsi_cmnd *) hostdata->issue_queue; ptr; ptr = (struct scsi_cmnd *) ptr->host_scribble)
-		lprint_Scsi_Cmnd(ptr, m);
-
-	seq_printf(m, "scsi%d: disconnected_queue\n", instance->host_no);
-	for (ptr = (struct scsi_cmnd *) hostdata->disconnected_queue; ptr; ptr = (struct scsi_cmnd *) ptr->host_scribble)
-		lprint_Scsi_Cmnd(ptr, m);
-	spin_unlock_irqrestore(&hostdata->lock, flags);
 	return 0;
 }
-
-static void lprint_Scsi_Cmnd(struct scsi_cmnd *cmd, struct seq_file *m)
-{
-	seq_printf(m, "scsi%d : destination target %d, lun %llu\n", cmd->device->host->host_no, cmd->device->id, cmd->device->lun);
-	seq_puts(m, "        command = ");
-	lprint_command(cmd->cmnd, m);
-}
-
-static void lprint_command(unsigned char *command, struct seq_file *m)
-{
-	int i, s;
-	lprint_opcode(command[0], m);
-	for (i = 1, s = COMMAND_SIZE(command[0]); i < s; ++i)
-		seq_printf(m, "%02x ", command[i]);
-	seq_putc(m, '\n');
-}
-
-static void lprint_opcode(int opcode, struct seq_file *m)
-{
-	seq_printf(m, "%2d (0x%02x)", opcode, opcode);
-}
-
+#endif
 
 /**
  *	NCR5380_init	-	initialise an NCR5380
@@ -2335,7 +2273,8 @@ static int NCR5380_abort(struct scsi_cmn
 
 	spin_lock_irqsave(&hostdata->lock, flags);
 
-	NCR5380_print_status(instance);
+	NCR5380_dprint(NDEBUG_ANY, instance);
+	NCR5380_dprint_phase(NDEBUG_ANY, instance);
 
 	dprintk(NDEBUG_ABORT, "scsi%d : abort called\n", instance->host_no);
 	dprintk(NDEBUG_ABORT, "        basr 0x%X, sr 0x%X\n", NCR5380_read(BUS_AND_STATUS_REG), NCR5380_read(STATUS_REG));
@@ -2490,8 +2429,9 @@ static int NCR5380_bus_reset(struct scsi
 
 #if (NDEBUG & NDEBUG_ANY)
 	scmd_printk(KERN_INFO, cmd, "performing bus reset\n");
-	NCR5380_print_status(instance);
 #endif
+	NCR5380_dprint(NDEBUG_ANY, instance);
+	NCR5380_dprint_phase(NDEBUG_ANY, instance);
 
 	do_reset(instance);
 
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:04:09.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:04:12.000000000 +1100
@@ -657,94 +657,6 @@ static void prepare_info(struct Scsi_Hos
 }
 
 /**
- * NCR5380_print_status - dump controller info
- * @instance: controller to dump
- *
- * Print commands in the various queues, called from NCR5380_abort
- * to aid debugging.
- */
-
-static void lprint_Scsi_Cmnd(struct scsi_cmnd *cmd)
-{
-	int i, s;
-	unsigned char *command;
-	printk("scsi%d: destination target %d, lun %llu\n",
-		H_NO(cmd), cmd->device->id, cmd->device->lun);
-	printk(KERN_CONT "        command = ");
-	command = cmd->cmnd;
-	printk(KERN_CONT "%2d (0x%02x)", command[0], command[0]);
-	for (i = 1, s = COMMAND_SIZE(command[0]); i < s; ++i)
-		printk(KERN_CONT " %02x", command[i]);
-	printk("\n");
-}
-
-static void __maybe_unused NCR5380_print_status(struct Scsi_Host *instance)
-{
-	struct NCR5380_hostdata *hostdata;
-	struct scsi_cmnd *ptr;
-
-	NCR5380_dprint(NDEBUG_ANY, instance);
-	NCR5380_dprint_phase(NDEBUG_ANY, instance);
-
-	hostdata = (struct NCR5380_hostdata *)instance->hostdata;
-
-	if (!hostdata->connected)
-		printk("scsi%d: no currently connected command\n", HOSTNO);
-	else
-		lprint_Scsi_Cmnd((struct scsi_cmnd *) hostdata->connected);
-	printk("scsi%d: issue_queue\n", HOSTNO);
-	for (ptr = (struct scsi_cmnd *)hostdata->issue_queue; ptr; ptr = NEXT(ptr))
-		lprint_Scsi_Cmnd(ptr);
-
-	printk("scsi%d: disconnected_queue\n", HOSTNO);
-	for (ptr = (struct scsi_cmnd *) hostdata->disconnected_queue; ptr;
-	     ptr = NEXT(ptr))
-		lprint_Scsi_Cmnd(ptr);
-	printk("\n");
-}
-
-static void show_Scsi_Cmnd(struct scsi_cmnd *cmd, struct seq_file *m)
-{
-	int i, s;
-	unsigned char *command;
-	seq_printf(m, "scsi%d: destination target %d, lun %llu\n",
-		H_NO(cmd), cmd->device->id, cmd->device->lun);
-	seq_puts(m, "        command = ");
-	command = cmd->cmnd;
-	seq_printf(m, "%2d (0x%02x)", command[0], command[0]);
-	for (i = 1, s = COMMAND_SIZE(command[0]); i < s; ++i)
-		seq_printf(m, " %02x", command[i]);
-	seq_putc(m, '\n');
-}
-
-static int __maybe_unused NCR5380_show_info(struct seq_file *m,
-                                            struct Scsi_Host *instance)
-{
-	struct NCR5380_hostdata *hostdata;
-	struct scsi_cmnd *ptr;
-	unsigned long flags;
-
-	hostdata = (struct NCR5380_hostdata *)instance->hostdata;
-
-	spin_lock_irqsave(&hostdata->lock, flags);
-	if (!hostdata->connected)
-		seq_printf(m, "scsi%d: no currently connected command\n", HOSTNO);
-	else
-		show_Scsi_Cmnd((struct scsi_cmnd *) hostdata->connected, m);
-	seq_printf(m, "scsi%d: issue_queue\n", HOSTNO);
-	for (ptr = (struct scsi_cmnd *)hostdata->issue_queue; ptr; ptr = NEXT(ptr))
-		show_Scsi_Cmnd(ptr, m);
-
-	seq_printf(m, "scsi%d: disconnected_queue\n", HOSTNO);
-	for (ptr = (struct scsi_cmnd *) hostdata->disconnected_queue; ptr;
-	     ptr = NEXT(ptr))
-		show_Scsi_Cmnd(ptr, m);
-
-	spin_unlock_irqrestore(&hostdata->lock, flags);
-	return 0;
-}
-
-/**
  * NCR5380_init - initialise an NCR5380
  * @instance: adapter to configure
  * @flags: control flags
@@ -2617,7 +2529,8 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 
 	spin_lock_irqsave(&hostdata->lock, flags);
 
-	NCR5380_print_status(instance);
+	NCR5380_dprint(NDEBUG_ANY, instance);
+	NCR5380_dprint_phase(NDEBUG_ANY, instance);
 
 	dprintk(NDEBUG_ABORT, "scsi%d: abort called basr 0x%02x, sr 0x%02x\n", HOSTNO,
 		    NCR5380_read(BUS_AND_STATUS_REG),
@@ -2815,8 +2728,9 @@ static int NCR5380_bus_reset(struct scsi
 
 #if (NDEBUG & NDEBUG_ANY)
 	scmd_printk(KERN_INFO, cmd, "performing bus reset\n");
-	NCR5380_print_status(instance);
 #endif
+	NCR5380_dprint(NDEBUG_ANY, instance);
+	NCR5380_dprint_phase(NDEBUG_ANY, instance);
 
 	do_reset(instance);
 
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2016-01-03 16:04:00.000000000 +1100
+++ linux/drivers/scsi/arm/oak.c	2016-01-03 16:04:12.000000000 +1100
@@ -28,7 +28,6 @@
 
 #define NCR5380_queue_command		oakscsi_queue_command
 #define NCR5380_info			oakscsi_info
-#define NCR5380_show_info		oakscsi_show_info
 
 #define NCR5380_implementation_fields	\
 	void __iomem *base
@@ -104,7 +103,6 @@ printk("reading %p len %d\n", addr, len)
 
 static struct scsi_host_template oakscsi_template = {
 	.module			= THIS_MODULE,
-	.show_info		= oakscsi_show_info,
 	.name			= "Oak 16-bit SCSI",
 	.info			= oakscsi_info,
 	.queuecommand		= oakscsi_queue_command,
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2016-01-03 16:04:03.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2016-01-03 16:04:12.000000000 +1100
@@ -97,7 +97,6 @@
 
 #define NCR5380_queue_command           atari_scsi_queue_command
 #define NCR5380_abort                   atari_scsi_abort
-#define NCR5380_show_info               atari_scsi_show_info
 #define NCR5380_info                    atari_scsi_info
 
 #define NCR5380_dma_read_setup(instance, data, count) \
@@ -774,7 +773,6 @@ static int atari_scsi_bus_reset(struct s
 static struct scsi_host_template atari_scsi_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= DRV_MODULE_NAME,
-	.show_info		= atari_scsi_show_info,
 	.name			= "Atari native SCSI",
 	.info			= atari_scsi_info,
 	.queuecommand		= atari_scsi_queue_command,
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-01-03 16:04:08.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-01-03 16:04:12.000000000 +1100
@@ -715,7 +715,6 @@ static int generic_NCR5380_dma_xfer_len(
 
 static struct scsi_host_template driver_template = {
 	.proc_name		= DRV_MODULE_NAME,
-	.show_info		= generic_NCR5380_show_info,
 	.name			= "Generic NCR5380/NCR53C400 SCSI",
 	.detect			= generic_NCR5380_detect,
 	.release		= generic_NCR5380_release_resources,
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2016-01-03 16:04:03.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2016-01-03 16:04:12.000000000 +1100
@@ -53,7 +53,6 @@
 #define NCR5380_queue_command           sun3scsi_queue_command
 #define NCR5380_bus_reset               sun3scsi_bus_reset
 #define NCR5380_abort                   sun3scsi_abort
-#define NCR5380_show_info               sun3scsi_show_info
 #define NCR5380_info                    sun3scsi_info
 
 #define NCR5380_dma_read_setup(instance, data, count) \
@@ -459,7 +458,6 @@ static int sun3scsi_dma_finish(int write
 static struct scsi_host_template sun3_scsi_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= DRV_MODULE_NAME,
-	.show_info		= sun3scsi_show_info,
 	.name			= SUN3_SCSI_NAME,
 	.info			= sun3scsi_info,
 	.queuecommand		= sun3scsi_queue_command,
