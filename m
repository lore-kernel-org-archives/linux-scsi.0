From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 12/29] ncr5380: Cleanup host info() methods
Date: Thu, 02 Oct 2014 16:56:40 +1000
Message-ID: <20141002065631.136827342@telegraphics.com.au>
References: <20141002065628.256592712@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33725 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbaJBNEA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 09:04:00 -0400
Content-Disposition: inline; filename=ncr5380-info-methods
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org

If the host->info() method is not set, then host->name is used by default.
For atari_scsi, that is exactly the same text. So remove the redundant
info() method. Keep sun3_scsi.c in line with atari_scsi.

Some NCR5380 drivers return an empty string from the info() method
(arm/cumana_1.c arm/oak.c mac_scsi.c) while other drivers use the default
(dmx3191d dtc.c g_NCR5380.c pas16.c t128.c).

Implement a common info() method to replace a lot of duplicated code which
the various drivers use to announce the same information.

This replaces most of the (deprecated) show_info() output and all of the
NCR5380_print_info() output. This also eliminates a bunch of code in
g_NCR5380 which just duplicates functionality in the core driver.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   75 ++++++++++++++---------
 drivers/scsi/NCR5380.h       |    3 
 drivers/scsi/arm/cumana_1.c  |   14 ----
 drivers/scsi/arm/oak.c       |   14 ----
 drivers/scsi/atari_NCR5380.c |   58 +++++++++++-------
 drivers/scsi/atari_scsi.c    |   24 -------
 drivers/scsi/atari_scsi.h    |    1 
 drivers/scsi/dmx3191d.c      |    1 
 drivers/scsi/dtc.c           |   10 ---
 drivers/scsi/dtc.h           |    1 
 drivers/scsi/g_NCR5380.c     |  135 -------------------------------------------
 drivers/scsi/g_NCR5380.h     |    2 
 drivers/scsi/mac_scsi.c      |   14 ----
 drivers/scsi/mac_scsi.h      |    1 
 drivers/scsi/pas16.c         |   12 ---
 drivers/scsi/pas16.h         |    1 
 drivers/scsi/sun3_NCR5380.c  |   60 +++++++++++--------
 drivers/scsi/sun3_scsi.c     |   18 -----
 drivers/scsi/sun3_scsi.h     |    1 
 drivers/scsi/t128.c          |   11 ---
 drivers/scsi/t128.h          |    1 
 21 files changed, 137 insertions(+), 320 deletions(-)

Index: linux/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux.orig/drivers/scsi/arm/cumana_1.c	2014-10-02 16:55:58.000000000 +1000
+++ linux/drivers/scsi/arm/cumana_1.c	2014-10-02 16:56:05.000000000 +1000
@@ -29,6 +29,7 @@
 #define NCR5380_write(reg, value)	cumanascsi_write(_instance, reg, value)
 #define NCR5380_intr			cumanascsi_intr
 #define NCR5380_queue_command		cumanascsi_queue_command
+#define NCR5380_info			cumanascsi_info
 
 #define NCR5380_implementation_fields	\
 	unsigned ctrl;			\
@@ -41,11 +42,6 @@ void cumanascsi_setup(char *str, int *in
 {
 }
 
-const char *cumanascsi_info(struct Scsi_Host *spnt)
-{
-	return "";
-}
-
 #define CTRL	0x16fc
 #define STAT	0x2004
 #define L(v)	(((v)<<16)|((v) & 0x0000ffff))
@@ -266,14 +262,6 @@ static int cumanascsi1_probe(struct expa
 		goto out_unmap;
 	}
 
-	printk("scsi%d: at port 0x%08lx irq %d",
-		host->host_no, host->io_port, host->irq);
-	printk(" options CAN_QUEUE=%d CMD_PER_LUN=%d release=%d",
-		host->can_queue, host->cmd_per_lun, CUMANASCSI_PUBLIC_RELEASE);
-	printk("\nscsi%d:", host->host_no);
-	NCR5380_print_options(host);
-	printk("\n");
-
 	ret = scsi_add_host(host, &ec->dev);
 	if (ret)
 		goto out_free_irq;
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2014-10-02 16:55:58.000000000 +1000
+++ linux/drivers/scsi/arm/oak.c	2014-10-02 16:56:05.000000000 +1000
@@ -29,6 +29,7 @@
 #define NCR5380_read(reg)		readb(_base + ((reg) << 2))
 #define NCR5380_write(reg, value)	writeb(value, _base + ((reg) << 2))
 #define NCR5380_queue_command		oakscsi_queue_command
+#define NCR5380_info			oakscsi_info
 #define NCR5380_show_info		oakscsi_show_info
 #define NCR5380_write_info		oakscsi_write_info
 
@@ -40,11 +41,6 @@
 #undef START_DMA_INITIATOR_RECEIVE_REG
 #define START_DMA_INITIATOR_RECEIVE_REG	(128 + 7)
 
-const char * oakscsi_info (struct Scsi_Host *spnt)
-{
-	return "";
-}
-
 #define STAT	((128 + 16) << 2)
 #define DATA	((128 + 8) << 2)
 
@@ -153,14 +149,6 @@ static int oakscsi_probe(struct expansio
 
 	NCR5380_init(host, 0);
 
-	printk("scsi%d: at port 0x%08lx irqs disabled",
-		host->host_no, host->io_port);
-	printk(" options CAN_QUEUE=%d  CMD_PER_LUN=%d release=%d",
-		host->can_queue, host->cmd_per_lun, OAKSCSI_PUBLIC_RELEASE);
-	printk("\nscsi%d:", host->host_no);
-	NCR5380_print_options(host);
-	printk("\n");
-
 	ret = scsi_add_host(host, &ec->dev);
 	if (ret)
 		goto out_unmap;
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2014-10-02 16:55:58.000000000 +1000
+++ linux/drivers/scsi/atari_scsi.c	2014-10-02 16:56:05.000000000 +1000
@@ -699,21 +699,6 @@ static int __init atari_scsi_detect(stru
 #endif
 	}
 
-	printk(KERN_INFO "scsi%d: options CAN_QUEUE=%d CMD_PER_LUN=%d SCAT-GAT=%d "
-#ifdef SUPPORT_TAGS
-			"TAGGED-QUEUING=%s "
-#endif
-			"HOSTID=%d",
-			instance->host_no, instance->hostt->can_queue,
-			instance->hostt->cmd_per_lun,
-			instance->hostt->sg_tablesize,
-#ifdef SUPPORT_TAGS
-			setup_use_tagged_queuing ? "yes" : "no",
-#endif
-			instance->hostt->this_id );
-	NCR5380_print_options(instance);
-	printk("\n");
-
 	called = 1;
 	return 1;
 }
@@ -815,15 +800,6 @@ static void __init atari_scsi_reset_boot
 }
 #endif
 
-
-static const char *atari_scsi_info(struct Scsi_Host *host)
-{
-	/* atari_scsi_detect() is verbose enough... */
-	static const char string[] = "Atari native SCSI";
-	return string;
-}
-
-
 #if defined(REAL_DMA)
 
 static unsigned long atari_scsi_dma_setup(struct Scsi_Host *instance,
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2014-10-02 16:56:02.000000000 +1000
+++ linux/drivers/scsi/mac_scsi.c	2014-10-02 16:56:05.000000000 +1000
@@ -236,16 +236,6 @@ int __init macscsi_detect(struct scsi_ho
 	    instance->irq = IRQ_NONE;
 	}
 
-    printk(KERN_INFO "scsi%d: generic 5380 at port %lX irq", instance->host_no, instance->io_port);
-    if (instance->irq == IRQ_NONE)
-	printk (KERN_INFO "s disabled");
-    else
-	printk (KERN_INFO " %d", instance->irq);
-    printk(KERN_INFO " options CAN_QUEUE=%d CMD_PER_LUN=%d release=%d",
-	   instance->can_queue, instance->cmd_per_lun, MACSCSI_PUBLIC_RELEASE);
-    printk(KERN_INFO "\nscsi%d:", instance->host_no);
-    NCR5380_print_options(instance);
-    printk("\n");
     called = 1;
     return 1;
 }
@@ -297,10 +287,6 @@ static void mac_scsi_reset_boot(struct S
 }
 #endif
 
-const char * macscsi_info (struct Scsi_Host *spnt) {
-	return "";
-}
-
 /* 
    Pseudo-DMA: (Ove Edlund)
    The code attempts to catch bus errors that occur if one for example
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2014-10-02 16:56:02.000000000 +1000
+++ linux/drivers/scsi/sun3_scsi.c	2014-10-02 16:56:05.000000000 +1000
@@ -286,19 +286,6 @@ static int __init sun3scsi_detect(struct
 #endif
 	}
 	
-	pr_info("scsi%d: %s at port %lX irq", instance->host_no,
-		tpnt->proc_name, instance->io_port);
-	if (instance->irq == IRQ_NONE)
-		printk ("s disabled");
-	else
-		printk (" %d", instance->irq);
-	printk(" options CAN_QUEUE=%d CMD_PER_LUN=%d release=%d",
-	       instance->can_queue, instance->cmd_per_lun,
-	       SUN3SCSI_PUBLIC_RELEASE);
-	printk("\nscsi%d:", instance->host_no);
-	NCR5380_print_options(instance);
-	printk("\n");
-
 	dregs->csr = 0;
 	udelay(SUN3_DMA_DELAY);
 	dregs->csr = CSR_SCSI | CSR_FIFO | CSR_INTR;
@@ -380,11 +367,6 @@ static void sun3_scsi_reset_boot(struct
 }
 #endif
 
-static const char *sun3scsi_info(struct Scsi_Host *spnt)
-{
-    return "";
-}
-
 // safe bits for the CSR
 #define CSR_GOOD 0x060f
 
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2014-10-02 16:56:04.000000000 +1000
+++ linux/drivers/scsi/NCR5380.c	2014-10-02 16:56:05.000000000 +1000
@@ -610,47 +610,71 @@ static int __init __maybe_unused NCR5380
 }
 
 /**
- *	NCR58380_print_options	-	show options
- *	@instance: unused for now
+ *	NCR58380_info - report driver and host information
+ *	@instance: relevant scsi host instance
  *
- *	Called by probe code indicating the NCR5380 driver options that 
- *	were selected. At some point this will switch to runtime options
- *	read from the adapter in question
+ *	For use as the host template info() handler.
  *
  *	Locks: none
  */
 
-static void __init __maybe_unused
-NCR5380_print_options(struct Scsi_Host *instance)
+static const char *NCR5380_info(struct Scsi_Host *instance)
 {
-	printk(" generic options"
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+
+	return hostdata->info;
+}
+
+static void prepare_info(struct Scsi_Host *instance)
+{
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+
+	snprintf(hostdata->info, sizeof(hostdata->info),
+	         "%s, io_port 0x%lx, n_io_port %d, "
+	         "base 0x%lx, irq %d, "
+	         "can_queue %d, cmd_per_lun %d, "
+	         "sg_tablesize %d, this_id %d, "
+	         "flags { %s%s%s}, "
+#if defined(USLEEP_POLL) && defined(USLEEP_WAITLONG)
+	         "USLEEP_POLL %d, USLEEP_WAITLONG %d, "
+#endif
+	         "options { %s} ",
+	         instance->hostt->name, instance->io_port, instance->n_io_port,
+	         instance->base, instance->irq,
+	         instance->can_queue, instance->cmd_per_lun,
+	         instance->sg_tablesize, instance->this_id,
+	         hostdata->flags & FLAG_NCR53C400     ? "NCR53C400 "     : "",
+	         hostdata->flags & FLAG_DTC3181E      ? "DTC3181E "      : "",
+	         hostdata->flags & FLAG_NO_PSEUDO_DMA ? "NO_PSEUDO_DMA " : "",
+#if defined(USLEEP_POLL) && defined(USLEEP_WAITLONG)
+	         USLEEP_POLL, USLEEP_WAITLONG,
+#endif
 #ifdef AUTOPROBE_IRQ
-	       " AUTOPROBE_IRQ"
+	         "AUTOPROBE_IRQ "
 #endif
 #ifdef DIFFERENTIAL
-	       " DIFFERENTIAL"
+	         "DIFFERENTIAL "
 #endif
 #ifdef REAL_DMA
-	       " REAL DMA"
+	         "REAL_DMA "
 #endif
 #ifdef REAL_DMA_POLL
-	       " REAL DMA POLL"
+	         "REAL_DMA_POLL "
 #endif
 #ifdef PARITY
-	       " PARITY"
+	         "PARITY "
 #endif
 #ifdef PSEUDO_DMA
-	       " PSEUDO DMA"
+	         "PSEUDO_DMA "
 #endif
 #ifdef UNSAFE
-	       " UNSAFE "
+	         "UNSAFE "
 #endif
-	    );
-	printk(" USLEEP_POLL=%d USLEEP_SLEEP=%d", USLEEP_POLL, USLEEP_SLEEP);
-	printk(" generic release=%d", NCR5380_PUBLIC_RELEASE);
-	if (((struct NCR5380_hostdata *) instance->hostdata)->flags & FLAG_NCR53C400) {
-		printk(" ncr53c400 release=%d", NCR53C400_PUBLIC_RELEASE);
-	}
+#ifdef NCR53C400
+	         "NCR53C400 "
+#endif
+	         "");
+	hostdata->info[sizeof(hostdata->info) - 1] = '\0';
 }
 
 /**
@@ -728,13 +752,6 @@ static int __maybe_unused NCR5380_show_i
 	SPRINTF("PAS16 release=%d", PAS16_PUBLIC_RELEASE);
 #endif
 
-	SPRINTF("\nBase Addr: 0x%05lX    ", (long) instance->base);
-	SPRINTF("io_port: %04x      ", (int) instance->io_port);
-	if (instance->irq == IRQ_NONE)
-		SPRINTF("IRQ: None.\n");
-	else
-		SPRINTF("IRQ: %d.\n", instance->irq);
-
 #ifdef DTC_PUBLIC_RELEASE
 	SPRINTF("Highwater I/O busy_spin_counts -- write: %d  read: %d\n", dtc_wmaxi, dtc_maxi);
 #endif
@@ -842,6 +859,8 @@ static int NCR5380_init(struct Scsi_Host
 	hostdata->host = instance;
 	hostdata->time_expires = 0;
 
+	prepare_info(instance);
+
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(TARGET_COMMAND_REG, 0);
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2014-10-02 16:56:04.000000000 +1000
+++ linux/drivers/scsi/NCR5380.h	2014-10-02 16:56:05.000000000 +1000
@@ -269,6 +269,7 @@ struct NCR5380_hostdata {
 	volatile Scsi_Cmnd *selecting;
 	struct delayed_work coroutine;		/* our co-routine */
 	struct scsi_eh_save ses;
+	char info[256];
 };
 
 #ifdef __KERNEL__
@@ -303,7 +304,7 @@ static void NCR5380_information_transfer
 static irqreturn_t NCR5380_intr(int irq, void *dev_id);
 #endif
 static void NCR5380_main(struct work_struct *work);
-static void __maybe_unused NCR5380_print_options(struct Scsi_Host *instance);
+static const char *NCR5380_info(struct Scsi_Host *instance);
 static void NCR5380_reselect(struct Scsi_Host *instance);
 static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd *cmd);
 #if defined(PSEUDO_DMA) || defined(REAL_DMA) || defined(REAL_DMA_POLL)
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2014-10-02 16:56:02.000000000 +1000
+++ linux/drivers/scsi/dtc.c	2014-10-02 16:56:05.000000000 +1000
@@ -281,15 +281,6 @@ found:
 		printk("scsi%d : irq = %d\n", instance->host_no, instance->irq);
 #endif
 
-		printk(KERN_INFO "scsi%d : at 0x%05X", instance->host_no, (int) instance->base);
-		if (instance->irq == IRQ_NONE)
-			printk(" interrupts disabled");
-		else
-			printk(" irq %d", instance->irq);
-		printk(" options CAN_QUEUE=%d  CMD_PER_LUN=%d release=%d", CAN_QUEUE, CMD_PER_LUN, DTC_PUBLIC_RELEASE);
-		NCR5380_print_options(instance);
-		printk("\n");
-
 		++current_override;
 		++count;
 	}
@@ -461,6 +452,7 @@ static struct scsi_host_template driver_
 	.proc_name			= "dtc3x80",
 	.show_info			= dtc_show_info,
 	.write_info			= dtc_write_info,
+	.info				= dtc_info,
 	.queuecommand			= dtc_queue_command,
 	.eh_abort_handler		= dtc_abort,
 	.eh_bus_reset_handler		= dtc_bus_reset,
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2014-10-02 16:56:04.000000000 +1000
+++ linux/drivers/scsi/g_NCR5380.c	2014-10-02 16:56:05.000000000 +1000
@@ -446,15 +446,6 @@ static int __init generic_NCR5380_detect
 			printk(KERN_INFO "scsi%d : please jumper the board for a free IRQ.\n", instance->host_no);
 		}
 
-		printk(KERN_INFO "scsi%d : at " STRVAL(NCR5380_map_name) " 0x%x", instance->host_no, (unsigned int) instance->NCR5380_instance_name);
-		if (instance->irq == IRQ_NONE)
-			printk(" interrupts disabled");
-		else
-			printk(" irq %d", instance->irq);
-		printk(" options CAN_QUEUE=%d  CMD_PER_LUN=%d release=%d", CAN_QUEUE, CMD_PER_LUN, GENERIC_NCR5380_PUBLIC_RELEASE);
-		NCR5380_print_options(instance);
-		printk("\n");
-
 		++current_override;
 		++count;
 	}
@@ -462,19 +453,6 @@ static int __init generic_NCR5380_detect
 }
 
 /**
- *	generic_NCR5380_info	-	reporting string
- *	@host: NCR5380 to report on
- *
- *	Report driver information for the NCR5380
- */
- 	
-static const char *generic_NCR5380_info(struct Scsi_Host *host)
-{
-	static const char string[] = "Generic NCR5380/53C400 Driver";
-	return string;
-}
-
-/**
  *	generic_NCR5380_release_resources	-	free resources
  *	@instance: host adapter to clean up 
  *
@@ -720,120 +698,9 @@ static inline int NCR5380_pwrite(struct
  
 #include "NCR5380.c"
 
-#define PRINTP(x) seq_printf(m, x)
-#define ANDP ,
-
-static void sprint_opcode(struct seq_file *m, int opcode)
-{
-	PRINTP("0x%02x " ANDP opcode);
-}
-
-static void sprint_command(struct seq_file *m, unsigned char *command)
-{
-	int i, s;
-	sprint_opcode(m, command[0]);
-	for (i = 1, s = COMMAND_SIZE(command[0]); i < s; ++i)
-		PRINTP("%02x " ANDP command[i]);
-	PRINTP("\n");
-}
-
-/**
- *	sprintf_Scsi_Cmnd	-	print a scsi command
- *	@m: seq_fil to print into
- *	@cmd: SCSI command block
- *	
- *	Print out the target and command data in hex
- */
-
-static void sprint_Scsi_Cmnd(struct seq_file *m, Scsi_Cmnd * cmd)
-{
-	PRINTP("host number %d destination target %d, lun %d\n" ANDP cmd->device->host->host_no ANDP cmd->device->id ANDP cmd->device->lun);
-	PRINTP("        command = ");
-	sprint_command(m, cmd->cmnd);
-}
-
-/**
- *	generic_NCR5380_proc_info	-	/proc for NCR5380 driver
- *	@buffer: buffer to print into
- *	@start: start position
- *	@offset: offset into buffer
- *	@len: length
- *	@hostno: instance to affect
- *	@inout: read/write
- *
- *	Provide the procfs information for the 5380 controller. We fill
- *	this with useful debugging information including the commands
- *	being executed, disconnected command queue and the statistical
- *	data
- *
- *	Locks: global cli/lock for queue walk
- */
- 
-static int generic_NCR5380_show_info(struct seq_file *m, struct Scsi_Host *scsi_ptr)
-{
-	NCR5380_local_declare();
-	unsigned long flags;
-	unsigned char status;
-	int i;
-	Scsi_Cmnd *ptr;
-	struct NCR5380_hostdata *hostdata;
-
-	NCR5380_setup(scsi_ptr);
-	hostdata = (struct NCR5380_hostdata *) scsi_ptr->hostdata;
-
-	spin_lock_irqsave(scsi_ptr->host_lock, flags);
-	PRINTP("SCSI host number %d : %s\n" ANDP scsi_ptr->host_no ANDP scsi_ptr->hostt->name);
-	PRINTP("Generic NCR5380 driver version %d\n" ANDP GENERIC_NCR5380_PUBLIC_RELEASE);
-	PRINTP("NCR5380 core version %d\n" ANDP NCR5380_PUBLIC_RELEASE);
-#ifdef NCR53C400
-	PRINTP("NCR53C400 extension version %d\n" ANDP NCR53C400_PUBLIC_RELEASE);
-	PRINTP("NCR53C400 card%s detected\n" ANDP(((struct NCR5380_hostdata *) scsi_ptr->hostdata)->flags & FLAG_NCR53C400) ? "" : " not");
-# if NCR53C400_PSEUDO_DMA
-	PRINTP("NCR53C400 pseudo DMA used\n");
-# endif
-#else
-	PRINTP("NO NCR53C400 driver extensions\n");
-#endif
-	PRINTP("Using %s mapping at %s 0x%lx, " ANDP STRVAL(NCR5380_map_config) ANDP STRVAL(NCR5380_map_name) ANDP scsi_ptr->NCR5380_instance_name);
-	if (scsi_ptr->irq == IRQ_NONE)
-		PRINTP("no interrupt\n");
-	else
-		PRINTP("on interrupt %d\n" ANDP scsi_ptr->irq);
-
-	status = NCR5380_read(STATUS_REG);
-	if (!(status & SR_REQ))
-		PRINTP("REQ not asserted, phase unknown.\n");
-	else {
-		for (i = 0; (phases[i].value != PHASE_UNKNOWN) && (phases[i].value != (status & PHASE_MASK)); ++i);
-		PRINTP("Phase %s\n" ANDP phases[i].name);
-	}
-
-	if (!hostdata->connected) {
-		PRINTP("No currently connected command\n");
-	} else {
-		sprint_Scsi_Cmnd(m, (Scsi_Cmnd *) hostdata->connected);
-	}
-
-	PRINTP("issue_queue\n");
-
-	for (ptr = (Scsi_Cmnd *) hostdata->issue_queue; ptr; ptr = (Scsi_Cmnd *) ptr->host_scribble)
-		sprint_Scsi_Cmnd(m, ptr);
-
-	PRINTP("disconnected_queue\n");
-
-	for (ptr = (Scsi_Cmnd *) hostdata->disconnected_queue; ptr; ptr = (Scsi_Cmnd *) ptr->host_scribble)
-		sprint_Scsi_Cmnd(m, ptr);
-
-	spin_unlock_irqrestore(scsi_ptr->host_lock, flags);
-	return 0;
-}
-
-#undef PRINTP
-#undef ANDP
-
 static struct scsi_host_template driver_template = {
 	.show_info      	= generic_NCR5380_show_info,
-	.name           	= "Generic NCR5380/NCR53C400 Scsi Driver",
+	.name           	= "Generic NCR5380/NCR53C400 SCSI",
 	.detect         	= generic_NCR5380_detect,
 	.release        	= generic_NCR5380_release_resources,
 	.info           	= generic_NCR5380_info,
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2014-10-02 16:56:02.000000000 +1000
+++ linux/drivers/scsi/pas16.c	2014-10-02 16:56:05.000000000 +1000
@@ -438,17 +438,6 @@ static int __init pas16_detect(struct sc
 	printk("scsi%d : irq = %d\n", instance->host_no, instance->irq);
 #endif
 
-	printk("scsi%d : at 0x%04x", instance->host_no, (int) 
-	    instance->io_port);
-	if (instance->irq == IRQ_NONE)
-	    printk (" interrupts disabled");
-	else 
-	    printk (" irq %d", instance->irq);
-	printk(" options CAN_QUEUE=%d  CMD_PER_LUN=%d release=%d",
-	    CAN_QUEUE, CMD_PER_LUN, PAS16_PUBLIC_RELEASE);
-	NCR5380_print_options(instance);
-	printk("\n");
-
 	++current_override;
 	++count;
     }
@@ -588,6 +577,7 @@ static struct scsi_host_template driver_
 	.proc_name      = "pas16",
 	.show_info      = pas16_show_info,
 	.write_info     = pas16_write_info,
+	.info           = pas16_info,
 	.queuecommand   = pas16_queue_command,
 	.eh_abort_handler = pas16_abort,
 	.eh_bus_reset_handler = pas16_bus_reset,
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2014-10-02 16:56:02.000000000 +1000
+++ linux/drivers/scsi/t128.c	2014-10-02 16:56:05.000000000 +1000
@@ -249,16 +249,6 @@ found:
 	printk("scsi%d : irq = %d\n", instance->host_no, instance->irq);
 #endif
 
-	printk("scsi%d : at 0x%08lx", instance->host_no, instance->base);
-	if (instance->irq == IRQ_NONE)
-	    printk (" interrupts disabled");
-	else 
-	    printk (" irq %d", instance->irq);
-	printk(" options CAN_QUEUE=%d  CMD_PER_LUN=%d release=%d",
-	    CAN_QUEUE, CMD_PER_LUN, T128_PUBLIC_RELEASE);
-	NCR5380_print_options(instance);
-	printk("\n");
-
 	++current_override;
 	++count;
     }
@@ -411,6 +401,7 @@ static struct scsi_host_template driver_
 	.proc_name      = "t128",
 	.show_info      = t128_show_info,
 	.write_info     = t128_write_info,
+	.info           = t128_info,
 	.queuecommand   = t128_queue_command,
 	.eh_abort_handler = t128_abort,
 	.eh_bus_reset_handler    = t128_bus_reset,
Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2014-10-02 16:56:02.000000000 +1000
+++ linux/drivers/scsi/dmx3191d.c	2014-10-02 16:56:05.000000000 +1000
@@ -57,6 +57,7 @@
 static struct scsi_host_template dmx3191d_driver_template = {
 	.proc_name		= DMX3191D_DRIVER_NAME,
 	.name			= "Domex DMX3191D",
+	.info			= NCR5380_info,
 	.queuecommand		= NCR5380_queue_command,
 	.eh_abort_handler	= NCR5380_abort,
 	.eh_bus_reset_handler	= NCR5380_bus_reset,
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2014-10-02 16:56:00.000000000 +1000
+++ linux/drivers/scsi/g_NCR5380.h	2014-10-02 16:56:05.000000000 +1000
@@ -100,6 +100,8 @@
 #define NCR5380_bus_reset generic_NCR5380_bus_reset
 #define NCR5380_pread generic_NCR5380_pread
 #define NCR5380_pwrite generic_NCR5380_pwrite
+#define NCR5380_info generic_NCR5380_info
+#define NCR5380_show_info generic_NCR5380_show_info
 
 #define BOARD_NCR5380	0
 #define BOARD_NCR53C400	1
Index: linux/drivers/scsi/dtc.h
===================================================================
--- linux.orig/drivers/scsi/dtc.h	2014-10-02 16:56:00.000000000 +1000
+++ linux/drivers/scsi/dtc.h	2014-10-02 16:56:05.000000000 +1000
@@ -65,6 +65,7 @@
 #define NCR5380_queue_command		dtc_queue_command
 #define NCR5380_abort			dtc_abort
 #define NCR5380_bus_reset		dtc_bus_reset
+#define NCR5380_info			dtc_info
 #define NCR5380_show_info		dtc_show_info 
 #define NCR5380_write_info		dtc_write_info 
 
Index: linux/drivers/scsi/pas16.h
===================================================================
--- linux.orig/drivers/scsi/pas16.h	2014-10-02 16:56:00.000000000 +1000
+++ linux/drivers/scsi/pas16.h	2014-10-02 16:56:05.000000000 +1000
@@ -143,6 +143,7 @@
 #define NCR5380_queue_command pas16_queue_command
 #define NCR5380_abort pas16_abort
 #define NCR5380_bus_reset pas16_bus_reset
+#define NCR5380_info pas16_info
 #define NCR5380_show_info pas16_show_info
 #define NCR5380_write_info pas16_write_info
 
Index: linux/drivers/scsi/t128.h
===================================================================
--- linux.orig/drivers/scsi/t128.h	2014-10-02 16:56:00.000000000 +1000
+++ linux/drivers/scsi/t128.h	2014-10-02 16:56:05.000000000 +1000
@@ -116,6 +116,7 @@
 #define NCR5380_queue_command t128_queue_command
 #define NCR5380_abort t128_abort
 #define NCR5380_bus_reset t128_bus_reset
+#define NCR5380_info t128_info
 #define NCR5380_show_info t128_show_info
 #define NCR5380_write_info t128_write_info
 
Index: linux/drivers/scsi/mac_scsi.h
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.h	2014-10-02 16:56:00.000000000 +1000
+++ linux/drivers/scsi/mac_scsi.h	2014-10-02 16:56:05.000000000 +1000
@@ -53,6 +53,7 @@
 #define NCR5380_queue_command macscsi_queue_command
 #define NCR5380_abort macscsi_abort
 #define NCR5380_bus_reset macscsi_bus_reset
+#define NCR5380_info macscsi_info
 #define NCR5380_show_info macscsi_show_info
 #define NCR5380_write_info macscsi_write_info
 
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2014-10-02 16:56:04.000000000 +1000
+++ linux/drivers/scsi/atari_NCR5380.c	2014-10-02 16:56:05.000000000 +1000
@@ -144,12 +144,6 @@
  * be able to coexist with appropriate changes to the high level
  * SCSI code.
  *
- * A NCR5380_PUBLIC_REVISION macro is provided, with the release
- * number (updated for each public release) printed by the
- * NCR5380_print_options command, which should be called from the
- * wrapper detect function, so that I know what release of the driver
- * users are using.
- *
  * Issues specific to the NCR5380 :
  *
  * When used in a PIO or pseudo-dma mode, the NCR5380 is a braindead
@@ -247,7 +241,6 @@
  * NCR5380_queue_command
  * NCR5380_reset
  * NCR5380_abort
- * NCR5380_proc_info
  *
  * to be the global entry points into the specific driver, ie
  * #define NCR5380_queue_command t128_queue_command.
@@ -259,8 +252,7 @@
  * The generic driver is initialized by calling NCR5380_init(instance),
  * after setting the appropriate host specific fields and ID.  If the
  * driver wishes to autoprobe for an IRQ line, the NCR5380_probe_irq(instance,
- * possible) function may be used.  Before the specific driver initialization
- * code finishes, NCR5380_print_options should be called.
+ * possible) function may be used.
  */
 
 static struct Scsi_Host *first_instance = NULL;
@@ -667,30 +659,50 @@ static inline void NCR5380_all_init(void
 	}
 }
 
-
-/*
- * Function : void NCR58380_print_options (struct Scsi_Host *instance)
+/**
+ * NCR58380_info - report driver and host information
+ * @instance: relevant scsi host instance
  *
- * Purpose : called by probe code indicating the NCR5380 driver
- *	     options that were selected.
+ * For use as the host template info() handler.
  *
- * Inputs : instance, pointer to this instance.  Unused.
+ * Locks: none
  */
 
-static void __init NCR5380_print_options(struct Scsi_Host *instance)
+static const char *NCR5380_info(struct Scsi_Host *instance)
+{
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+
+	return hostdata->info;
+}
+
+static void prepare_info(struct Scsi_Host *instance)
 {
-	printk(" generic options"
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+
+	snprintf(hostdata->info, sizeof(hostdata->info),
+	         "%s, io_port 0x%lx, n_io_port %d, "
+	         "base 0x%lx, irq %d, "
+	         "can_queue %d, cmd_per_lun %d, "
+	         "sg_tablesize %d, this_id %d, "
+	         "options { %s} ",
+	         instance->hostt->name, instance->io_port, instance->n_io_port,
+	         instance->base, instance->irq,
+	         instance->can_queue, instance->cmd_per_lun,
+	         instance->sg_tablesize, instance->this_id,
+#ifdef DIFFERENTIAL
+	         "DIFFERENTIAL "
+#endif
 #ifdef REAL_DMA
-	       " REAL DMA"
+	         "REAL_DMA "
 #endif
 #ifdef PARITY
-	       " PARITY"
+	         "PARITY "
 #endif
 #ifdef SUPPORT_TAGS
-	       " SCSI-2 TAGGED QUEUING"
+	         "SUPPORT_TAGS "
 #endif
-	       );
-	printk(" generic release=%d", NCR5380_PUBLIC_RELEASE);
+	         "");
+	hostdata->info[sizeof(hostdata->info) - 1] = '\0';
 }
 
 /*
@@ -836,6 +848,8 @@ static int __init NCR5380_init(struct Sc
 		first_instance = instance;
 	}
 
+	prepare_info(instance);
+
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(TARGET_COMMAND_REG, 0);
Index: linux/drivers/scsi/atari_scsi.h
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.h	2014-10-02 16:55:52.000000000 +1000
+++ linux/drivers/scsi/atari_scsi.h	2014-10-02 16:56:05.000000000 +1000
@@ -47,6 +47,7 @@
 #define NCR5380_queue_command atari_scsi_queue_command
 #define NCR5380_abort atari_scsi_abort
 #define NCR5380_show_info atari_scsi_show_info
+#define NCR5380_info atari_scsi_info
 #define NCR5380_dma_read_setup(inst,d,c) atari_scsi_dma_setup (inst, d, c, 0)
 #define NCR5380_dma_write_setup(inst,d,c) atari_scsi_dma_setup (inst, d, c, 1)
 #define NCR5380_dma_residual(inst) atari_scsi_dma_residual( inst )
Index: linux/drivers/scsi/sun3_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/sun3_NCR5380.c	2014-10-02 16:56:04.000000000 +1000
+++ linux/drivers/scsi/sun3_NCR5380.c	2014-10-02 16:56:05.000000000 +1000
@@ -131,12 +131,6 @@
  * be able to coexist with appropriate changes to the high level
  * SCSI code.  
  *
- * A NCR5380_PUBLIC_REVISION macro is provided, with the release
- * number (updated for each public release) printed by the 
- * NCR5380_print_options command, which should be called from the 
- * wrapper detect function, so that I know what release of the driver
- * users are using.
- *
  * Issues specific to the NCR5380 : 
  *
  * When used in a PIO or pseudo-dma mode, the NCR5380 is a braindead 
@@ -234,7 +228,6 @@
  * NCR5380_queue_command
  * NCR5380_reset
  * NCR5380_abort
- * NCR5380_proc_info
  *
  * to be the global entry points into the specific driver, ie 
  * #define NCR5380_queue_command t128_queue_command.
@@ -246,8 +239,7 @@
  * The generic driver is initialized by calling NCR5380_init(instance),
  * after setting the appropriate host specific fields and ID.  If the 
  * driver wishes to autoprobe for an IRQ line, the NCR5380_probe_irq(instance,
- * possible) function may be used.  Before the specific driver initialization
- * code finishes, NCR5380_print_options should be called.
+ * possible) function may be used.
  */
 
 static struct Scsi_Host *first_instance = NULL;
@@ -613,30 +605,50 @@ static inline void NCR5380_all_init (voi
     }
 }
 
- 
-/*
- * Function : void NCR58380_print_options (struct Scsi_Host *instance)
+/**
+ * NCR58380_info - report driver and host information
+ * @instance: relevant scsi host instance
  *
- * Purpose : called by probe code indicating the NCR5380 driver
- *	     options that were selected.
+ * For use as the host template info() handler.
  *
- * Inputs : instance, pointer to this instance.  Unused.
+ * Locks: none
  */
 
-static void __init NCR5380_print_options (struct Scsi_Host *instance)
+static const char *NCR5380_info(struct Scsi_Host *instance)
+{
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+
+	return hostdata->info;
+}
+
+static void prepare_info(struct Scsi_Host *instance)
 {
-    printk(" generic options"
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+
+	snprintf(hostdata->info, sizeof(hostdata->info),
+	         "%s, io_port 0x%lx, n_io_port %d, "
+	         "base 0x%lx, irq %d, "
+	         "can_queue %d, cmd_per_lun %d, "
+	         "sg_tablesize %d, this_id %d, "
+	         "options { %s} ",
+	         instance->hostt->name, instance->io_port, instance->n_io_port,
+	         instance->base, instance->irq,
+	         instance->can_queue, instance->cmd_per_lun,
+	         instance->sg_tablesize, instance->this_id,
+#ifdef DIFFERENTIAL
+	         "DIFFERENTIAL "
+#endif
 #ifdef REAL_DMA
-    " REAL DMA"
+	         "REAL_DMA "
 #endif
 #ifdef PARITY
-    " PARITY"
+	         "PARITY "
 #endif
 #ifdef SUPPORT_TAGS
-    " SCSI-2 TAGGED QUEUING"
+	         "SUPPORT_TAGS "
 #endif
-    );
-    printk(" generic release=%d", NCR5380_PUBLIC_RELEASE);
+	         "");
+	hostdata->info[sizeof(hostdata->info) - 1] = '\0';
 }
 
 /*
@@ -781,7 +793,9 @@ static int __init NCR5380_init(struct Sc
 	the_template = instance->hostt;
 	first_instance = instance;
     }
-	
+
+    prepare_info(instance);
+
     NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
     NCR5380_write(MODE_REG, MR_BASE);
     NCR5380_write(TARGET_COMMAND_REG, 0);
Index: linux/drivers/scsi/sun3_scsi.h
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.h	2014-10-02 16:56:00.000000000 +1000
+++ linux/drivers/scsi/sun3_scsi.h	2014-10-02 16:56:05.000000000 +1000
@@ -74,6 +74,7 @@
 #define NCR5380_bus_reset sun3scsi_bus_reset
 #define NCR5380_abort sun3scsi_abort
 #define NCR5380_show_info sun3scsi_show_info
+#define NCR5380_info sun3scsi_info
 #define NCR5380_dma_xfer_len(i, cmd, phase) \
         sun3scsi_dma_xfer_len(cmd->SCp.this_residual,cmd,((phase) & SR_IO) ? 0 : 1)
 


