From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 2/7] scsi/g_NCR5380: Remove obfuscating macros
Date: Sat, 29 Nov 2014 01:34:13 +0100
Message-ID: <1417221258-4937-3-git-send-email-linux@rasmusvillemoes.dk>
References: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The macros PRINTP/ANDP make the code harder to read and depend on a
specific identifier name in the surrounding scope. Nuke them.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/scsi/g_NCR5380.c | 66 ++++++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index b331272..802b64c 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -741,12 +741,9 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
  
 #include "NCR5380.c"
 
-#define PRINTP(x) seq_printf(m, x)
-#define ANDP ,
-
 static void sprint_opcode(struct seq_file *m, int opcode)
 {
-	PRINTP("0x%02x " ANDP opcode);
+	seq_printf(m, "0x%02x ", opcode);
 }
 
 static void sprint_command(struct seq_file *m, unsigned char *command)
@@ -754,8 +751,8 @@ static void sprint_command(struct seq_file *m, unsigned char *command)
 	int i, s;
 	sprint_opcode(m, command[0]);
 	for (i = 1, s = COMMAND_SIZE(command[0]); i < s; ++i)
-		PRINTP("%02x " ANDP command[i]);
-	PRINTP("\n");
+		seq_printf(m, "%02x ", command[i]);
+	seq_printf(m, "\n");
 }
 
 /**
@@ -768,8 +765,8 @@ static void sprint_command(struct seq_file *m, unsigned char *command)
 
 static void sprint_Scsi_Cmnd(struct seq_file *m, Scsi_Cmnd * cmd)
 {
-	PRINTP("host number %d destination target %d, lun %llu\n" ANDP cmd->device->host->host_no ANDP cmd->device->id ANDP cmd->device->lun);
-	PRINTP("        command = ");
+	seq_printf(m, "host number %d destination target %d, lun %llu\n", cmd->device->host->host_no, cmd->device->id, cmd->device->lun);
+	seq_printf(m, "        command = ");
 	sprint_command(m, cmd->cmnd);
 }
 
@@ -806,40 +803,40 @@ static int generic_NCR5380_show_info(struct seq_file *m, struct Scsi_Host *scsi_
 	hostdata = (struct NCR5380_hostdata *) scsi_ptr->hostdata;
 
 	spin_lock_irqsave(scsi_ptr->host_lock, flags);
-	PRINTP("SCSI host number %d : %s\n" ANDP scsi_ptr->host_no ANDP scsi_ptr->hostt->name);
-	PRINTP("Generic NCR5380 driver version %d\n" ANDP GENERIC_NCR5380_PUBLIC_RELEASE);
-	PRINTP("NCR5380 core version %d\n" ANDP NCR5380_PUBLIC_RELEASE);
+	seq_printf(m, "SCSI host number %d : %s\n", scsi_ptr->host_no, scsi_ptr->hostt->name);
+	seq_printf(m, "Generic NCR5380 driver version %d\n", GENERIC_NCR5380_PUBLIC_RELEASE);
+	seq_printf(m, "NCR5380 core version %d\n", NCR5380_PUBLIC_RELEASE);
 #ifdef NCR53C400
-	PRINTP("NCR53C400 extension version %d\n" ANDP NCR53C400_PUBLIC_RELEASE);
-	PRINTP("NCR53C400 card%s detected\n" ANDP(((struct NCR5380_hostdata *) scsi_ptr->hostdata)->flags & FLAG_NCR53C400) ? "" : " not");
+	seq_printf(m, "NCR53C400 extension version %d\n", NCR53C400_PUBLIC_RELEASE);
+	seq_printf(m, "NCR53C400 card%s detected\n", (((struct NCR5380_hostdata *) scsi_ptr->hostdata)->flags & FLAG_NCR53C400) ? "" : " not");
 # if NCR53C400_PSEUDO_DMA
-	PRINTP("NCR53C400 pseudo DMA used\n");
+	seq_printf(m, "NCR53C400 pseudo DMA used\n");
 # endif
 #else
-	PRINTP("NO NCR53C400 driver extensions\n");
+	seq_printf(m, "NO NCR53C400 driver extensions\n");
 #endif
-	PRINTP("Using %s mapping at %s 0x%lx, " ANDP STRVAL(NCR5380_map_config) ANDP STRVAL(NCR5380_map_name) ANDP scsi_ptr->NCR5380_instance_name);
+	seq_printf(m, "Using %s mapping at %s 0x%lx, ", STRVAL(NCR5380_map_config), STRVAL(NCR5380_map_name), scsi_ptr->NCR5380_instance_name);
 	if (scsi_ptr->irq == SCSI_IRQ_NONE)
-		PRINTP("no interrupt\n");
+		seq_printf(m, "no interrupt\n");
 	else
-		PRINTP("on interrupt %d\n" ANDP scsi_ptr->irq);
+		seq_printf(m, "on interrupt %d\n", scsi_ptr->irq);
 
 #ifdef NCR5380_STATS
 	if (hostdata->connected || hostdata->issue_queue || hostdata->disconnected_queue)
-		PRINTP("There are commands pending, transfer rates may be crud\n");
+		seq_printf(m, "There are commands pending, transfer rates may be crud\n");
 	if (hostdata->pendingr)
-		PRINTP("  %d pending reads" ANDP hostdata->pendingr);
+		seq_printf(m, "  %d pending reads", hostdata->pendingr);
 	if (hostdata->pendingw)
-		PRINTP("  %d pending writes" ANDP hostdata->pendingw);
+		seq_printf(m, "  %d pending writes", hostdata->pendingw);
 	if (hostdata->pendingr || hostdata->pendingw)
-		PRINTP("\n");
+		seq_printf(m, "\n");
 	shost_for_each_device(dev, scsi_ptr) {
 		unsigned long br = hostdata->bytes_read[dev->id];
 		unsigned long bw = hostdata->bytes_write[dev->id];
 		long tr = hostdata->time_read[dev->id] / HZ;
 		long tw = hostdata->time_write[dev->id] / HZ;
 
-		PRINTP("  T:%d %s " ANDP dev->id ANDP scsi_device_type(dev->type));
+		seq_printf(m, "  T:%d %s ", dev->id, scsi_device_type(dev->type));
 		for (i = 0; i < 8; i++)
 			if (dev->vendor[i] >= 0x20)
 				seq_putc(m, dev->vendor[i]);
@@ -853,37 +850,37 @@ static int generic_NCR5380_show_info(struct seq_file *m, struct Scsi_Host *scsi_
 				seq_putc(m, dev->rev[i]);
 		seq_putc(m, ' ');
 
-		PRINTP("\n%10ld kb read    in %5ld secs" ANDP br / 1024 ANDP tr);
+		seq_printf(m, "\n%10ld kb read    in %5ld secs", br / 1024, tr);
 		if (tr)
-			PRINTP(" @ %5ld bps" ANDP br / tr);
+			seq_printf(m, " @ %5ld bps", br / tr);
 
-		PRINTP("\n%10ld kb written in %5ld secs" ANDP bw / 1024 ANDP tw);
+		seq_printf(m, "\n%10ld kb written in %5ld secs", bw / 1024, tw);
 		if (tw)
-			PRINTP(" @ %5ld bps" ANDP bw / tw);
-		PRINTP("\n");
+			seq_printf(m, " @ %5ld bps", bw / tw);
+		seq_printf(m, "\n");
 	}
 #endif
 
 	status = NCR5380_read(STATUS_REG);
 	if (!(status & SR_REQ))
-		PRINTP("REQ not asserted, phase unknown.\n");
+		seq_printf(m, "REQ not asserted, phase unknown.\n");
 	else {
 		for (i = 0; (phases[i].value != PHASE_UNKNOWN) && (phases[i].value != (status & PHASE_MASK)); ++i);
-		PRINTP("Phase %s\n" ANDP phases[i].name);
+		seq_printf(m, "Phase %s\n", phases[i].name);
 	}
 
 	if (!hostdata->connected) {
-		PRINTP("No currently connected command\n");
+		seq_printf(m, "No currently connected command\n");
 	} else {
 		sprint_Scsi_Cmnd(m, (Scsi_Cmnd *) hostdata->connected);
 	}
 
-	PRINTP("issue_queue\n");
+	seq_printf(m, "issue_queue\n");
 
 	for (ptr = (Scsi_Cmnd *) hostdata->issue_queue; ptr; ptr = (Scsi_Cmnd *) ptr->host_scribble)
 		sprint_Scsi_Cmnd(m, ptr);
 
-	PRINTP("disconnected_queue\n");
+	seq_printf(m, "disconnected_queue\n");
 
 	for (ptr = (Scsi_Cmnd *) hostdata->disconnected_queue; ptr; ptr = (Scsi_Cmnd *) ptr->host_scribble)
 		sprint_Scsi_Cmnd(m, ptr);
@@ -892,9 +889,6 @@ static int generic_NCR5380_show_info(struct seq_file *m, struct Scsi_Host *scsi_
 	return 0;
 }
 
-#undef PRINTP
-#undef ANDP
-
 static struct scsi_host_template driver_template = {
 	.show_info      	= generic_NCR5380_show_info,
 	.name           	= "Generic NCR5380/NCR53C400 Scsi Driver",
-- 
2.0.4
