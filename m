From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove superflous ->command instances
Date: Mon, 9 Jun 2003 17:15:26 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609151526.GA1325@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:13454 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263705AbTFIPB6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2003 11:01:58 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

->command is never called if can_queue is set, remove the dead code.


diff -Nru a/drivers/message/i2o/i2o_scsi.c b/drivers/message/i2o/i2o_scsi.c
--- a/drivers/message/i2o/i2o_scsi.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/message/i2o/i2o_scsi.c	Sun Jun  8 19:18:41 2003
@@ -866,34 +866,6 @@
 }
 
 /**
- *	internal_done	-	legacy scsi glue
- *	@SCPnt: command
- *
- *	Completion function for a synchronous command
- */
-
-static void internal_done(Scsi_Cmnd * SCpnt)
-{
-	SCpnt->SCp.Status++;
-}
-
-/**
- *	i2o_scsi_command	-	issue a scsi command and wait
- *	@SCPnt: command
- *
- *	Issue a SCSI command and wait for it to complete.
- */
- 
-static int i2o_scsi_command(Scsi_Cmnd * SCpnt)
-{
-	i2o_scsi_queuecommand(SCpnt, internal_done);
-	SCpnt->SCp.Status = 0;
-	while (!SCpnt->SCp.Status)
-		barrier();
-	return SCpnt->result;
-}
-
-/**
  *	i2o_scsi_abort	-	abort a running command
  *	@SCpnt: command to abort
  *
@@ -1091,7 +1063,6 @@
 	.detect			= i2o_scsi_detect,
 	.release		= i2o_scsi_release,
 	.info			= i2o_scsi_info,
-	.command		= i2o_scsi_command,
 	.queuecommand		= i2o_scsi_queuecommand,
 	.eh_abort_handler	= i2o_scsi_abort,
 	.eh_bus_reset_handler	= i2o_scsi_bus_reset,
diff -Nru a/drivers/scsi/AM53C974.c b/drivers/scsi/AM53C974.c
--- a/drivers/scsi/AM53C974.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/AM53C974.c	Sun Jun  8 19:18:41 2003
@@ -817,22 +817,6 @@
 	return (info);
 }
 
-/************************************************************************** 
-* Function : int AM53C974_command (Scsi_Cmnd *SCpnt)                      *
-*                                                                         *
-* Purpose : the unqueued SCSI command function, replaced by the           *
-*           AM53C974_queue_command function                               *
-*                                                                         *
-* Inputs : SCpnt - pointer to command structure                           *
-*                                                                         *
-* Returns :status, see hosts.h for details                                *
-***************************************************************************/
-static int AM53C974_command(Scsi_Cmnd * SCpnt)
-{
-	DEB(printk("AM53C974_command called\n"));
-	return 0;
-}
-
 /**************************************************************************
 * Function : void initialize_SCp(Scsi_Cmnd *cmd)                          *
 *                                                                         *
@@ -2466,7 +2450,6 @@
 	.detect         	= AM53C974_pci_detect,
 	.release        	= AM53C974_release,	
 	.info			= AM53C974_info,
-	.command		= AM53C974_command,
 	.queuecommand		= AM53C974_queue_command,
 	.abort			= AM53C974_abort,
 	.reset			= AM53C974_reset,
diff -Nru a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
--- a/drivers/scsi/NCR53c406a.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/NCR53c406a.c	Sun Jun  8 19:18:41 2003
@@ -170,7 +170,6 @@
 /* Static function prototypes */
 static void NCR53c406a_intr(int, void *, struct pt_regs *);
 static irqreturn_t do_NCR53c406a_intr(int, void *, struct pt_regs *);
-static void internal_done(Scsi_Cmnd *);
 static void wait_intr(void);
 static void chip_init(void);
 static void calc_port_addr(void);
@@ -205,8 +204,6 @@
 #endif
 
 static Scsi_Cmnd *current_SC;
-static volatile int internal_done_flag;
-static volatile int internal_done_errcode;
 static char info_msg[256];
 
 /* ================================================================= */
@@ -664,13 +661,6 @@
 	return (info_msg);
 }
 
-static void internal_done(Scsi_Cmnd * SCpnt)
-{
-	internal_done_errcode = SCpnt->result;
-	++internal_done_flag;
-}
-
-
 static void wait_intr(void)
 {
 	unsigned long i = jiffies + WATCHDOG;
@@ -724,21 +714,6 @@
 	return 0;
 }
 
-static int NCR53c406a_command(Scsi_Cmnd * SCpnt)
-{
-	DEB(printk("NCR53c406a_command called\n"));
-	NCR53c406a_queue(SCpnt, internal_done);
-	if (irq_level)
-		while (!internal_done_flag)
-			cpu_relax();
-	else			/* interrupts not supported */
-		while (!internal_done_flag)
-			wait_intr();
-
-	internal_done_flag = 0;
-	return internal_done_errcode;
-}
-
 static int NCR53c406a_abort(Scsi_Cmnd * SCpnt)
 {
 	DEB(printk("NCR53c406a_abort called\n"));
@@ -1091,7 +1066,6 @@
      .detect            	= NCR53c406a_detect	/* detect */,           
      .release            	= NCR53c406a_release,
      .info              	= NCR53c406a_info		/* info */,             
-     .command           	= NCR53c406a_command	/* command */,          
      .queuecommand      	= NCR53c406a_queue	/* queuecommand */,     
      .eh_abort_handler  	= NCR53c406a_abort	/* abort */,            
      .eh_bus_reset_handler      = NCR53c406a_bus_reset	/* reset */,            
diff -Nru a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
--- a/drivers/scsi/aha152x.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/aha152x.c	Sun Jun  8 19:18:41 2003
@@ -1515,16 +1515,6 @@
 		up(SCSEM(SCpnt));
 }
 
-static int aha152x_command(Scsi_Cmnd * SCpnt)
-{
-	DECLARE_MUTEX_LOCKED(sem);
-
-	aha152x_internal_queue(SCpnt, &sem, 0, 0, internal_done);
-	down(&sem);
-
-	return SUCCESS;
-}
-
 /*
  *  Abort a command
  *
@@ -3876,7 +3866,6 @@
 	.proc_name		= "aha152x",
 	.proc_info		= aha152x_proc_info,
 	.detect			= aha152x_detect,
-	.command		= aha152x_command,
 	.queuecommand		= aha152x_queue,
 	.eh_abort_handler	= aha152x_abort,
 	.eh_device_reset_handler = aha152x_device_reset,
diff -Nru a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
--- a/drivers/scsi/aha1542.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/aha1542.c	Sun Jun  8 19:18:41 2003
@@ -774,23 +774,6 @@
 	return 0;
 }
 
-static void internal_done(Scsi_Cmnd * SCpnt)
-{
-	SCpnt->SCp.Status++;
-}
-
-static int aha1542_command(Scsi_Cmnd * SCpnt)
-{
-	DEB(printk("aha1542_command: ..calling aha1542_queuecommand\n"));
-
-	aha1542_queuecommand(SCpnt, internal_done);
-
-	SCpnt->SCp.Status = 0;
-	while (!SCpnt->SCp.Status)
-		barrier();
-	return SCpnt->result;
-}
-
 /* Initialize mailboxes */
 static void setup_mailboxes(int bse, struct Scsi_Host *shpnt)
 {
@@ -1830,7 +1813,6 @@
 	.name			= "Adaptec 1542",
 	.detect			= aha1542_detect,
 	.release		= aha1542_release,
-	.command		= aha1542_command,
 	.queuecommand		= aha1542_queuecommand,
 	.eh_abort_handler	= aha1542_abort,
 	.eh_device_reset_handler= aha1542_dev_reset,
diff -Nru a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
--- a/drivers/scsi/aha1740.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/aha1740.c	Sun Jun  8 19:18:41 2003
@@ -476,23 +476,6 @@
     return 0;
 }
 
-static void internal_done(Scsi_Cmnd * SCpnt)
-{
-    SCpnt->SCp.Status++;
-}
-
-static int aha1740_command(Scsi_Cmnd * SCpnt)
-{
-    aha1740_queuecommand(SCpnt, internal_done);
-    SCpnt->SCp.Status = 0;
-    while (!SCpnt->SCp.Status)
-    {
-	cpu_relax();
-	barrier();
-    }
-    return SCpnt->result;
-}
-
 /* Query the board for its irq_level.  Nothing else matters
    in enhanced mode on an EISA bus. */
 
@@ -607,7 +590,6 @@
 	.name			= "Adaptec 174x (EISA)",
 	.detect			= aha1740_detect,
 	.release		= aha1740_release,
-	.command		= aha1740_command,
 	.queuecommand		= aha1740_queuecommand,
 	.bios_param		= aha1740_biosparam,
 	.can_queue		= AHA1740_ECBS,
diff -Nru a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
--- a/drivers/scsi/arm/arxescsi.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/arm/arxescsi.c	Sun Jun  8 19:18:41 2003
@@ -264,7 +264,6 @@
 	.proc_info			= arxescsi_proc_info,
 	.name				= "ARXE SCSI card",
 	.info				= arxescsi_info,
-	.command			= fas216_command,
 	.queuecommand			= fas216_queue_command,
 	.eh_host_reset_handler		= fas216_eh_host_reset,
 	.eh_bus_reset_handler		= fas216_eh_bus_reset,
diff -Nru a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
--- a/drivers/scsi/arm/cumana_2.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/arm/cumana_2.c	Sun Jun  8 19:18:41 2003
@@ -386,7 +386,6 @@
 	.proc_info			= cumanascsi_2_proc_info,
 	.name				= "Cumana SCSI II",
 	.info				= cumanascsi_2_info,
-	.command			= fas216_command,
 	.queuecommand			= fas216_queue_command,
 	.eh_host_reset_handler		= fas216_eh_host_reset,
 	.eh_bus_reset_handler		= fas216_eh_bus_reset,
diff -Nru a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
--- a/drivers/scsi/arm/eesox.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/arm/eesox.c	Sun Jun  8 19:18:41 2003
@@ -492,7 +492,6 @@
 	.proc_info			= eesoxscsi_proc_info,
 	.name				= "EESOX SCSI",
 	.info				= eesoxscsi_info,
-	.command			= fas216_command,
 	.queuecommand			= fas216_queue_command,
 	.eh_host_reset_handler		= fas216_eh_host_reset,
 	.eh_bus_reset_handler		= fas216_eh_bus_reset,
diff -Nru a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
--- a/drivers/scsi/arm/fas216.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/arm/fas216.c	Sun Jun  8 19:18:41 2003
@@ -225,8 +225,7 @@
 	printk("    dma={ transfer_type=%X setup=%p pseudo=%p stop=%p }\n",
 		info->dma.transfer_type, info->dma.setup,
 		info->dma.pseudo, info->dma.stop);
-	printk("    internal_done=%X magic_end=%lX }\n",
-		info->internal_done, info->magic_end);
+	printk("    magic_end=%lX }\n", info->magic_end);
 }
 
 #ifdef CHECK_STRUCTURE
@@ -2251,74 +2250,6 @@
 		result ? "failure" : "success");
 
 	return result;
-}
-
-/**
- * fas216_internal_done - trigger restart of a waiting thread in fas216_command
- * @SCpnt: Command to wake
- *
- * Trigger restart of a waiting thread in fas216_command
- */
-static void fas216_internal_done(Scsi_Cmnd *SCpnt)
-{
-	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
-
-	fas216_checkmagic(info);
-
-	info->internal_done = 1;
-}
-
-/**
- * fas216_command - queue a command for adapter to process.
- * @SCpnt: Command to queue
- *
- * Queue a command for adapter to process.
- * Returns: scsi result code.
- * Notes: io_request_lock is held, interrupts are disabled.
- */
-int fas216_command(Scsi_Cmnd *SCpnt)
-{
-	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
-
-	fas216_checkmagic(info);
-
-	/*
-	 * We should only be using this if we don't have an interrupt.
-	 * Provide some "incentive" to use the queueing code.
-	 */
-	if (info->scsi.irq != NO_IRQ)
-		BUG();
-
-	info->internal_done = 0;
-	fas216_queue_command(SCpnt, fas216_internal_done);
-
-	/*
-	 * This wastes time, since we can't return until the command is
-	 * complete. We can't sleep either since we may get re-entered!
-	 * However, we must re-enable interrupts, or else we'll be
-	 * waiting forever.
-	 */
-	spin_unlock_irq(info->host->host_lock);
-
-	while (!info->internal_done) {
-		/*
-		 * If we don't have an IRQ, then we must poll the card for
-		 * it's interrupt, and use that to call this driver's
-		 * interrupt routine.  That way, we keep the command
-		 * progressing.  Maybe we can add some inteligence here
-		 * and go to sleep if we know that the device is going
-		 * to be some time (eg, disconnected).
-		 */
-		if (fas216_readb(info, REG_STAT) & STAT_INT) {
-			spin_lock_irq(info->host->host_lock);
-			fas216_intr(info);
-			spin_unlock_irq(info->host->host_lock);
-		}
-	}
-
-	spin_lock_irq(info->host->host_lock);
-
-	return SCpnt->result;
 }
 
 /*
diff -Nru a/drivers/scsi/arm/fas216.h b/drivers/scsi/arm/fas216.h
--- a/drivers/scsi/arm/fas216.h	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/arm/fas216.h	Sun Jun  8 19:18:41 2003
@@ -310,8 +310,6 @@
 	} dma;
 
 	/* miscellaneous */
-	int			internal_done;		/* flag to indicate request done */
-
 	unsigned long		magic_end;
 } FAS216_Info;
 
@@ -336,13 +334,6 @@
  * Returns : 0 - success, else error
  */
 extern int fas216_queue_command (Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-
-/* Function: int fas216_command (Scsi_Cmnd *SCpnt)
- * Purpose : queue a command for adapter to process.
- * Params  : SCpnt - Command to queue
- * Returns : scsi result code
- */
-extern int fas216_command (Scsi_Cmnd *);
 
 /* Function: irqreturn_t fas216_intr (FAS216_Info *info)
  * Purpose : handle interrupts from the interface to progress a command
diff -Nru a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
--- a/drivers/scsi/arm/powertec.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/arm/powertec.c	Sun Jun  8 19:18:41 2003
@@ -296,7 +296,6 @@
 	.proc_info			= powertecscsi_proc_info,
 	.name				= "PowerTec SCSI",
 	.info				= powertecscsi_info,
-	.command			= fas216_command,
 	.queuecommand			= fas216_queue_command,
 	.eh_host_reset_handler		= fas216_eh_host_reset,
 	.eh_bus_reset_handler		= fas216_eh_bus_reset,
diff -Nru a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
--- a/drivers/scsi/atp870u.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/atp870u.c	Sun Jun  8 19:18:41 2003
@@ -829,25 +829,6 @@
 
 }
 
-static void internal_done(Scsi_Cmnd * SCpnt)
-{
-	SCpnt->SCp.Status++;
-}
-
-static int atp870u_command(Scsi_Cmnd * SCpnt)
-{
-
-	atp870u_queuecommand(SCpnt, internal_done);
-
-	SCpnt->SCp.Status = 0;
-	while (!SCpnt->SCp.Status)
-	{
-		cpu_relax();
-		barrier();
-	}
-	return SCpnt->result;
-}
-
 static unsigned char fun_scam(struct atp_unit *dev, unsigned short int *val)
 {
 	unsigned int tmport;
@@ -2732,7 +2713,6 @@
 	.detect			= atp870u_detect,
 	.release		= atp870u_release,
 	.info			= atp870u_info,
-	.command		= atp870u_command,
 	.queuecommand		= atp870u_queuecommand,
 	.eh_abort_handler	= atp870u_abort,
 	.bios_param		= atp870u_biosparam,
diff -Nru a/drivers/scsi/atp870u.h b/drivers/scsi/atp870u.h
--- a/drivers/scsi/atp870u.h	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/atp870u.h	Sun Jun  8 19:18:41 2003
@@ -18,7 +18,6 @@
 #define MAX_SENSE 14
 
 static int atp870u_detect(Scsi_Host_Template *);
-static int atp870u_command(Scsi_Cmnd *);
 static int atp870u_queuecommand(Scsi_Cmnd *, void (*done) (Scsi_Cmnd *));
 static int atp870u_abort(Scsi_Cmnd *);
 static int atp870u_biosparam(struct scsi_device *, struct block_device *,
diff -Nru a/drivers/scsi/blz1230.c b/drivers/scsi/blz1230.c
--- a/drivers/scsi/blz1230.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/blz1230.c	Sun Jun  8 19:18:41 2003
@@ -334,7 +334,6 @@
 	.name			= "Blizzard1230 SCSI IV",
 	.detect			= blz1230_esp_detect,
 	.release		= blz1230_esp_release,
-	.command		= esp_command,
 	.queuecommand		= esp_queue,
 	.eh_abort_handler	= esp_abort,
 	.eh_bus_reset_handler	= esp_reset,
diff -Nru a/drivers/scsi/dec_esp.c b/drivers/scsi/dec_esp.c
--- a/drivers/scsi/dec_esp.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/dec_esp.c	Sun Jun  8 19:18:41 2003
@@ -126,7 +126,6 @@
 	.detect			= dec_esp_detect,
 	.release		= dec_esp_release,
 	.info			= esp_info,
-	.command		= esp_command,
 	.queuecommand		= esp_queue,
 	.eh_abort_handler	= esp_abort,
 	.eh_bus_reset_handler	= esp_reset,
diff -Nru a/drivers/scsi/esp.c b/drivers/scsi/esp.c
--- a/drivers/scsi/esp.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/esp.c	Sun Jun  8 19:18:41 2003
@@ -1882,15 +1882,6 @@
 	return 0;
 }
 
-/* Only queuing supported in this ESP driver. */
-static int esp_command(Scsi_Cmnd *SCpnt)
-{
-	struct esp *esp = (struct esp *) SCpnt->device->host->hostdata;
-
-	ESPLOG(("esp%d: esp_command() called...\n", esp->esp_id));
-	return -1;
-}
-
 /* Dump driver state. */
 static void esp_dump_cmd(Scsi_Cmnd *SCptr)
 {
@@ -4405,7 +4396,6 @@
 	.slave_destroy		= esp_slave_destroy,
 	.release		= esp_release,
 	.info			= esp_info,
-	.command		= esp_command,
 	.queuecommand		= esp_queue,
 	.eh_abort_handler	= esp_abort,
 	.eh_bus_reset_handler	= esp_reset,
diff -Nru a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
--- a/drivers/scsi/fd_mcs.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/fd_mcs.c	Sun Jun  8 19:18:41 2003
@@ -1186,24 +1186,6 @@
 	return 0;
 }
 
-static void internal_done(Scsi_Cmnd * SCpnt)
-{
-	/* flag it done */
-	SCpnt->host_scribble = (unsigned char *) 1;
-}
-
-int fd_mcs_command(Scsi_Cmnd * SCpnt)
-{
-	fd_mcs_queue(SCpnt, internal_done);
-	/* host_scribble is used for status here */
-	SCpnt->host_scribble = NULL;
-	while (!SCpnt->host_scribble) {
-		cpu_relax();
-		barrier();
-	}
-	return SCpnt->result;
-}
-
 #if DEBUG_ABORT || DEBUG_RESET
 static void fd_mcs_print_info(Scsi_Cmnd * SCpnt)
 {
@@ -1431,7 +1413,6 @@
 	.detect				= fd_mcs_detect,
 	.release			= fd_mcs_release,
 	.info				= fd_mcs_info,
-	.command			= fd_mcs_command,
 	.queuecommand   		= fd_mcs_queue, 
 	.eh_abort_handler		= fd_mcs_abort,
 	.eh_bus_reset_handler		= fd_mcs_bus_reset,
diff -Nru a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
--- a/drivers/scsi/fdomain.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/fdomain.c	Sun Jun  8 19:18:41 2003
@@ -255,11 +255,6 @@
  be increased by changing this value to values which are close to 2.
  Please let me know if you try any different values.
 
- DO_DETECT: This activates some old scan code which was needed before the
- high level drivers got fixed.  If you are having trouble with the driver,
- turning this on should not hurt, and might help.  Please let me know if
- this is the case, since this code will be removed from future drivers.
-
  RESELECTION: This is no longer an option, since I gave up trying to
  implement it in version 4.x of this driver.  It did not improve
  performance at all and made the driver unstable (because I never found one
@@ -303,7 +298,6 @@
 #define DEBUG            0	/* Enable debugging output */
 #define ENABLE_PARITY    1	/* Enable SCSI Parity */
 #define FIFO_COUNT       2	/* Number of 512 byte blocks before INTR */
-#define DO_DETECT        0	/* Do device detection here (see scsi.c) */
 
 /* END OF USER DEFINABLE OPTIONS */
 
@@ -863,17 +857,6 @@
    int              retcode;
    struct Scsi_Host *shpnt;
    struct pci_dev *pdev = NULL;
-#if DO_DETECT
-   int i = 0;
-   int j = 0;
-   const int        buflen = 255;
-   Scsi_Cmnd        SCinit;
-   unsigned char    do_inquiry[] =       { INQUIRY, 0, 0, 0, buflen, 0 };
-   unsigned char    do_request_sense[] = { REQUEST_SENSE, 0, 0, 0, buflen, 0 };
-   unsigned char    do_read_capacity[] = { READ_CAPACITY,
-					   0, 0, 0, 0, 0, 0, 0, 0, 0 };
-   unsigned char    buf[buflen];
-#endif
 
    if (setup_called) {
 #if DEBUG_DETECT
@@ -984,59 +967,6 @@
    /* Log I/O ports with kernel */
    request_region( port_base, 0x10, "fdomain" );
 
-#if DO_DETECT
-
-   /* These routines are here because of the way the SCSI bus behaves after
-      a reset.  This appropriate behavior was not handled correctly by the
-      higher level SCSI routines when I first wrote this driver.  Now,
-      however, correct scan routines are part of scsi.c and these routines
-      are no longer needed.  However, this code is still good for
-      debugging.  */
-
-   SCinit.request_buffer  = SCinit.buffer = buf;
-   SCinit.request_bufflen = SCinit.bufflen = sizeof(buf)-1;
-   SCinit.use_sg          = 0;
-   SCinit.lun             = 0;
-
-   printk( "scsi: <fdomain> detection routine scanning for devices:\n" );
-   for (i = 0; i < 8; i++) {
-      SCinit.target = i;
-      if (i == tpnt->this_id)	/* Skip host adapter */
-	    continue;
-      memcpy(SCinit.cmnd, do_request_sense, sizeof(do_request_sense));
-      retcode = fdomain_16x0_command(&SCinit);
-      if (!retcode) {
-	 memcpy(SCinit.cmnd, do_inquiry, sizeof(do_inquiry));
-	 retcode = fdomain_16x0_command(&SCinit);
-	 if (!retcode) {
-	    printk( "     SCSI ID %d: ", i );
-	    for (j = 8; j < (buf[4] < 32 ? buf[4] : 32); j++)
-		  printk( "%c", buf[j] >= 20 ? buf[j] : ' ' );
-	    memcpy(SCinit.cmnd, do_read_capacity, sizeof(do_read_capacity));
-	    retcode = fdomain_16x0_command(&SCinit);
-	    if (!retcode) {
-	       unsigned long blocks, size, capacity;
-	       
-	       blocks = (buf[0] << 24) | (buf[1] << 16)
-		     | (buf[2] << 8) | buf[3];
-	       size = (buf[4] << 24) | (buf[5] << 16) | (buf[6] << 8) | buf[7];
-	       capacity = +( +(blocks / 1024L) * +(size * 10L)) / 1024L;
-	       
-	       printk( "%lu MB (%lu byte blocks)",
-		       ((capacity + 5L) / 10L), size );
-	    } else {
-	       memcpy(SCinit.cmnd, do_request_sense, sizeof(do_request_sense));
-	       retcode = fdomain_16x0_command(&SCinit);
-	    }
-	    printk ("\n" );
-	 } else {
-	    memcpy(SCinit.cmnd, do_request_sense, sizeof(do_request_sense));
-	    retcode = fdomain_16x0_command(&SCinit);
-	 }
-      }
-   }
-#endif
-
    return shpnt;
 }
 
@@ -1508,31 +1438,6 @@
    return 0;
 }
 
-/* The following code, which simulates the old-style command function, was
-   taken from Tommy Thorn's aha1542.c file.  This code is Copyright (C)
-   1992 Tommy Thorn. */
-
-static volatile int internal_done_flag    = 0;
-static volatile int internal_done_errcode = 0;
-
-static void internal_done(Scsi_Cmnd *SCpnt)
-{
-    internal_done_errcode = SCpnt->result;
-    ++internal_done_flag;
-}
-
-static int fdomain_16x0_command(Scsi_Cmnd *SCpnt)
-{
-    fdomain_16x0_queue(SCpnt, internal_done);
-
-    while (!internal_done_flag)
-	  cpu_relax();
-    internal_done_flag = 0;
-    return internal_done_errcode;
-}
-
-/* End of code derived from Tommy Thorn's work. */
-
 #if DEBUG_ABORT
 static void print_info(Scsi_Cmnd *SCpnt)
 {
@@ -1833,7 +1738,6 @@
 	.proc_name		= "fdomain",
 	.detect			= fdomain_16x0_detect,
 	.info			= fdomain_16x0_info,
-	.command		= fdomain_16x0_command,
 	.queuecommand		= fdomain_16x0_queue,
 	.eh_abort_handler	= fdomain_16x0_abort,
 	.eh_bus_reset_handler	= fdomain_16x0_bus_reset,
diff -Nru a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
--- a/drivers/scsi/ibmmca.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/ibmmca.c	Sun Jun  8 19:18:41 2003
@@ -1793,15 +1793,6 @@
 	return shpnt;
 }
 
-static int ibmmca_command(Scsi_Cmnd * cmd)
-{
-	ibmmca_queuecommand(cmd, internal_done);
-	cmd->SCp.Status = 0;
-	while (!cmd->SCp.Status)
-		barrier();
-	return cmd->result;
-}
-
 static int ibmmca_release(struct Scsi_Host *shpnt)
 {
 	release_region(shpnt->io_port, shpnt->n_io_port);
@@ -2490,7 +2481,6 @@
           .name           = "IBM SCSI-Subsystem",
           .detect         = ibmmca_detect,
           .release        = ibmmca_release,
-          .command        = ibmmca_command,
           .queuecommand   = ibmmca_queuecommand,
 	  .eh_abort_handler = ibmmca_abort,
 	  .eh_host_reset_handler = ibmmca_host_reset,
diff -Nru a/drivers/scsi/imm.c b/drivers/scsi/imm.c
--- a/drivers/scsi/imm.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/imm.c	Sun Jun  8 19:18:41 2003
@@ -113,7 +113,6 @@
 	.name				= "Iomega VPI2 (imm) interface",
 	.detect				= imm_detect,
 	.release			= imm_release,
-	.command			= imm_command,
 	.queuecommand			= imm_queuecommand,
 	.eh_abort_handler               = imm_abort,
 	.eh_bus_reset_handler           = imm_reset,
@@ -856,39 +855,6 @@
 	    return 0;
     }
     return 1;			/* FINISH_RETURN */
-}
-
-/* deprecated synchronous interface */
-int imm_command(Scsi_Cmnd * cmd)
-{
-    static int first_pass = 1;
-    int host_no = cmd->device->host->unique_id;
-
-    if (first_pass) {
-	printk("imm: using non-queuing interface\n");
-	first_pass = 0;
-    }
-    if (imm_hosts[host_no].cur_cmd) {
-	printk("IMM: bug in imm_command\n");
-	return 0;
-    }
-    imm_hosts[host_no].failed = 0;
-    imm_hosts[host_no].jstart = jiffies;
-    imm_hosts[host_no].cur_cmd = cmd;
-    cmd->result = DID_ERROR << 16;	/* default return code */
-    cmd->SCp.phase = 0;
-
-    imm_pb_claim(host_no);
-
-    while (imm_engine(&imm_hosts[host_no], cmd))
-	schedule();
-
-    if (cmd->SCp.phase)		/* Only disconnect if we have connected */
-	imm_disconnect(cmd->device->host->unique_id);
-
-    imm_pb_release(host_no);
-    imm_hosts[host_no].cur_cmd = 0;
-    return cmd->result;
 }
 
 /*
diff -Nru a/drivers/scsi/ini9100u.c b/drivers/scsi/ini9100u.c
--- a/drivers/scsi/ini9100u.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/ini9100u.c	Sun Jun  8 19:18:41 2003
@@ -147,7 +147,6 @@
 	.name		= i91u_REVID,
 	.detect		= i91u_detect,
 	.release	= i91u_release,
-	.command	= i91u_command,
 	.queuecommand	= i91u_queue,
 	.abort		= i91u_abort,
 	.reset		= i91u_reset,
@@ -555,15 +554,6 @@
 	i91uBuildSCB(pHCB, pSCB, SCpnt);
 	tul_exec_scb(pHCB, pSCB);	/* Start execute SCB            */
 	return (0);
-}
-
-/*
- *  We only support command in interrupt-driven fashion
- */
-int i91u_command(Scsi_Cmnd * SCpnt)
-{
-	printk("i91u: interrupt driven driver; use i91u_queue()\n");
-	return -1;
 }
 
 /*
diff -Nru a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
--- a/drivers/scsi/jazz_esp.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/jazz_esp.c	Sun Jun  8 19:18:41 2003
@@ -292,7 +292,6 @@
 	.detect			= jazz_esp_detect,
 	.release		= jazz_esp_release,
 	.info			= esp_info,
-	.command		= esp_command,
 	.queuecommand		= esp_queue,
 	.eh_abort_handler	= esp_abort,
 	.eh_bus_reset_handler	= esp_reset,
diff -Nru a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
--- a/drivers/scsi/mac_esp.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/mac_esp.c	Sun Jun  8 19:18:41 2003
@@ -729,7 +729,6 @@
 	.detect			= mac_esp_detect,
 	.release		= mac_esp_release,
 	.info			= esp_info,
-	/* .command		= esp_command, */
 	.queuecommand		= esp_queue,
 	.eh_abort_handler	= esp_abort,
 	.eh_bus_reset_handler	= esp_reset,
diff -Nru a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/megaraid.c	Sun Jun  8 19:18:41 2003
@@ -2569,35 +2569,6 @@
 	return buffer;
 }
 
-volatile static int internal_done_flag = 0;
-volatile static int internal_done_errcode = 0;
-
-static DECLARE_WAIT_QUEUE_HEAD (internal_wait);
-
-static void internal_done (Scsi_Cmnd *cmd)
-{
-	internal_done_errcode = cmd->result;
-	internal_done_flag++;
-	wake_up (&internal_wait);
-}
-
-/* shouldn't be used, but included for completeness */
-
-static int
-megaraid_command (Scsi_Cmnd *cmd)
-{
-	internal_done_flag = 0;
-
-	/* Queue command, and wait until it has completed */
-	megaraid_queue (cmd, internal_done);
-
-	while (!internal_done_flag)
-		interruptible_sleep_on (&internal_wait);
-
-	return internal_done_errcode;
-}
-
-
 /*
  * Abort a previous SCSI request. Only commands on the pending list can be
  * aborted. All the commands issued to the F/W must complete.
@@ -5367,7 +5338,6 @@
 	.detect =			megaraid_detect,
 	.release =			megaraid_release,
 	.info =				megaraid_info,
-	.command =			megaraid_command,
 	.queuecommand =			megaraid_queue,	
 	.bios_param =			megaraid_biosparam,
 	.max_sectors =			MAX_SECTORS_PER_IO,
diff -Nru a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
--- a/drivers/scsi/megaraid.h	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/megaraid.h	Sun Jun  8 19:18:41 2003
@@ -1001,7 +1001,6 @@
 static void mega_free_scb(adapter_t *, scb_t *);
 
 static int megaraid_release (struct Scsi_Host *);
-static int megaraid_command (Scsi_Cmnd *);
 static int megaraid_abort(Scsi_Cmnd *);
 static int megaraid_reset(Scsi_Cmnd *);
 static int megaraid_abort_and_reset(adapter_t *, Scsi_Cmnd *, int);
diff -Nru a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
--- a/drivers/scsi/mesh.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/mesh.c	Sun Jun  8 19:18:41 2003
@@ -2047,11 +2047,8 @@
 	.name				= "MESH",
 	.detect				= mesh_detect,
 	.release			= mesh_release,
-	.command			= NULL,
 	.queuecommand			= mesh_queue,
 	.eh_abort_handler		= mesh_abort,
-	.eh_device_reset_handler	= NULL,
-	.eh_bus_reset_handler		= NULL,
 	.eh_host_reset_handler		= mesh_host_reset,
 	.can_queue			= 20,
 	.this_id			= 7,
diff -Nru a/drivers/scsi/pci2000.c b/drivers/scsi/pci2000.c
--- a/drivers/scsi/pci2000.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/pci2000.c	Sun Jun  8 19:18:41 2003
@@ -612,41 +612,6 @@
 	return 0;
 	}
 /****************************************************************
- *	Name:	internal_done :LOCAL
- *
- *	Description:	Done handler for non-queued commands
- *
- *	Parameters:		SCpnt - Pointer to SCSI command structure.
- *
- *	Returns:		Nothing.
- *
- ****************************************************************/
-static void internal_done (Scsi_Cmnd * SCpnt)
-	{
-	SCpnt->SCp.Status++;
-	}
-/****************************************************************
- *	Name:	Pci2000_Command
- *
- *	Description:	Process a command from the SCSI manager.
- *
- *	Parameters:		SCpnt - Pointer to SCSI command structure.
- *
- *	Returns:		Status code.
- *
- ****************************************************************/
-int Pci2000_Command (Scsi_Cmnd *SCpnt)
-	{
-	DEB(printk("pci2000_command: ..calling pci2000_queuecommand\n"));
-
-	Pci2000_QueueCommand (SCpnt, internal_done);
-
-    SCpnt->SCp.Status = 0;
-	while (!SCpnt->SCp.Status)
-		barrier ();
-	return SCpnt->result;
-	}
-/****************************************************************
  *	Name:	Pci2000_Detect
  *
  *	Description:	Detect and initialize our boards.
@@ -863,7 +828,6 @@
 	.name		= "PCI-2000 SCSI Intelligent Disk Controller",
 	.detect		= Pci2000_Detect,
 	.release	= Pci2000_Release,
-	.command	= Pci2000_Command,
 	.queuecommand	= Pci2000_QueueCommand,
 	.abort		= Pci2000_Abort,
 	.reset		= Pci2000_Reset,
diff -Nru a/drivers/scsi/pci2220i.c b/drivers/scsi/pci2220i.c
--- a/drivers/scsi/pci2220i.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/pci2220i.c	Sun Jun  8 19:18:41 2003
@@ -2307,28 +2307,6 @@
 		}
 	return 0;
 	}
-static void internal_done(Scsi_Cmnd *SCpnt)
-	{
-	SCpnt->SCp.Status++;
-	}
-/****************************************************************
- *	Name:	Pci2220i_Command
- *
- *	Description:	Process a command from the SCSI manager.
- *
- *	Parameters:		SCpnt - Pointer to SCSI command structure.
- *
- *	Returns:		Status code.
- *
- ****************************************************************/
-int Pci2220i_Command (Scsi_Cmnd *SCpnt)
-	{
-	Pci2220i_QueueCommand (SCpnt, internal_done);
-    SCpnt->SCp.Status = 0;
-	while (!SCpnt->SCp.Status)
-		barrier ();
-	return SCpnt->result;
-	}
 /****************************************************************
  *	Name:			ReadFlash
  *
@@ -2930,7 +2908,6 @@
 	.name			= "PCI-2220I/PCI-2240I",
 	.detect			= Pci2220i_Detect,
 	.release		= Pci2220i_Release,
-	.command		= Pci2220i_Command,
 	.queuecommand		= Pci2220i_QueueCommand,
 	.abort			= Pci2220i_Abort,
 	.reset			= Pci2220i_Reset,
diff -Nru a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
--- a/drivers/scsi/ppa.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/ppa.c	Sun Jun  8 19:18:41 2003
@@ -103,7 +103,6 @@
 	.name				= "Iomega VPI0 (ppa) interface",
 	.detect				= ppa_detect,
 	.release			= ppa_release,
-	.command			= ppa_command,
 	.queuecommand			= ppa_queuecommand,
 	.eh_abort_handler		= ppa_abort,
 	.eh_bus_reset_handler		= ppa_reset,
@@ -759,39 +758,6 @@
 	    return 0;
     }
     return 1;			/* FINISH_RETURN */
-}
-
-/* deprecated synchronous interface */
-int ppa_command(Scsi_Cmnd * cmd)
-{
-    static int first_pass = 1;
-    int host_no = cmd->device->host->unique_id;
-
-    if (first_pass) {
-	printk("ppa: using non-queuing interface\n");
-	first_pass = 0;
-    }
-    if (ppa_hosts[host_no].cur_cmd) {
-	printk("PPA: bug in ppa_command\n");
-	return 0;
-    }
-    ppa_hosts[host_no].failed = 0;
-    ppa_hosts[host_no].jstart = jiffies;
-    ppa_hosts[host_no].cur_cmd = cmd;
-    cmd->result = DID_ERROR << 16;	/* default return code */
-    cmd->SCp.phase = 0;
-
-    ppa_pb_claim(host_no);
-
-    while (ppa_engine(&ppa_hosts[host_no], cmd))
-	schedule();
-
-    if (cmd->SCp.phase)		/* Only disconnect if we have connected */
-	ppa_disconnect(cmd->device->host->unique_id);
-
-    ppa_pb_release(host_no);
-    ppa_hosts[host_no].cur_cmd = 0;
-    return cmd->result;
 }
 
 /*
diff -Nru a/drivers/scsi/psi240i.c b/drivers/scsi/psi240i.c
--- a/drivers/scsi/psi240i.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/psi240i.c	Sun Jun  8 19:18:41 2003
@@ -496,31 +496,6 @@
 	return 0;
 	}
 
-static void internal_done(Scsi_Cmnd * SCpnt)
-	{
-	SCpnt->SCp.Status++;
-	}
-/****************************************************************
- *	Name:	Psi240i_Command
- *
- *	Description:	Process a command from the SCSI manager.
- *
- *	Parameters:		SCpnt - Pointer to SCSI command structure.
- *
- *	Returns:		Status code.
- *
- ****************************************************************/
-int Psi240i_Command (Scsi_Cmnd *SCpnt)
-	{
-	DEB(printk("psi240i_command: ..calling psi240i_queuecommand\n"));
-
-	Psi240i_QueueCommand (SCpnt, internal_done);
-
-    SCpnt->SCp.Status = 0;
-	while (!SCpnt->SCp.Status)
-		barrier ();
-	return SCpnt->result;
-	}
 /***************************************************************************
  *	Name:			ReadChipMemory
  *
@@ -734,7 +709,6 @@
 	.name			= "PSI-240I EIDE Disk Controller",
 	.detect			= Psi240i_Detect,
 	.release		= Psi240i_Release,
-	.command		= Psi240i_Command,
 	.queuecommand		= Psi240i_QueueCommand,
 	.abort	  		= Psi240i_Abort,
 	.reset	  		= Psi240i_Reset,
diff -Nru a/drivers/scsi/qlogicfas.c b/drivers/scsi/qlogicfas.c
--- a/drivers/scsi/qlogicfas.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/qlogicfas.c	Sun Jun  8 19:18:41 2003
@@ -544,46 +544,6 @@
 
 #if QL_USE_IRQ
 
-static void qlidone(Scsi_Cmnd * cmd)
-{
-}				/* null function */
-
-#endif
-
-/*
- *	Synchronous command processing
- */
- 
-static int qlogicfas_command(Scsi_Cmnd * cmd)
-{
-	int k;
-#if QL_USE_IRQ
-	if (qlirq >= 0) {
-		qlogicfas_queuecommand(cmd, qlidone);
-		while (qlcmd != NULL)
-		{
-			cpu_relax();
-			barrier();
-		}
-		return cmd->result;
-	}
-#endif
-
-	/*
-	 *	Non-irq version
-	 */
-	 
-	if (cmd->device->id == qinitid)
-		return (DID_BAD_TARGET << 16);
-	ql_icmd(cmd);
-	if ((k = ql_wai()))
-		return (k << 16);
-	return ql_pcmd(cmd);
-
-}
-
-#if QL_USE_IRQ
-
 /*
  *	Queued command
  */
@@ -840,7 +800,6 @@
 	.detect			= qlogicfas_detect,
 	.release		= qlogicfas_release,
 	.info			= qlogicfas_info,
-	.command		= qlogicfas_command,
 	.queuecommand		= qlogicfas_queuecommand,
 	.eh_abort_handler	= qlogicfas_abort,
 	.eh_bus_reset_handler	= qlogicfas_bus_reset,
diff -Nru a/drivers/scsi/seagate.c b/drivers/scsi/seagate.c
--- a/drivers/scsi/seagate.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/seagate.c	Sun Jun  8 19:18:41 2003
@@ -729,13 +729,6 @@
 	return 0;
 }
 
-static int seagate_st0x_command(Scsi_Cmnd * SCpnt)
-{
-	return internal_command (SCpnt->device->id, SCpnt->device->lun, SCpnt->cmnd,
-				 SCpnt->request_buffer, SCpnt->request_bufflen,
-				 (int) NO_RECONNECT);
-}
-
 static int internal_command (unsigned char target, unsigned char lun,
 		  const void *cmnd, void *buff, int bufflen, int reselect)
 {
@@ -1704,7 +1697,6 @@
 	.detect         	= seagate_st0x_detect,
 	.release        	= seagate_st0x_release,
 	.info           	= seagate_st0x_info,
-	.command        	= seagate_st0x_command,
 	.queuecommand   	= seagate_st0x_queue_command,
 	.eh_abort_handler	= seagate_st0x_abort,
 	.eh_bus_reset_handler	= seagate_st0x_bus_reset,
diff -Nru a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
--- a/drivers/scsi/sun3x_esp.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/sun3x_esp.c	Sun Jun  8 19:18:41 2003
@@ -413,7 +413,6 @@
 	.slave_alloc		= esp_slave_alloc,
 	.slave_destroy		= esp_slave_destroy,
 	.info			= esp_info,
-	.command		= esp_command,
 	.queuecommand		= esp_queue,
 	.eh_abort_handler	= esp_abort,
 	.eh_bus_reset_handler	= esp_reset,
diff -Nru a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
--- a/drivers/scsi/sym53c416.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/sym53c416.c	Sun Jun  8 19:18:41 2003
@@ -787,20 +787,6 @@
 	return 0;
 }
 
-static void internal_done(Scsi_Cmnd *SCpnt)
-{
-	SCpnt->SCp.Status++;
-}
-
-static int sym53c416_command(Scsi_Cmnd *SCpnt)
-{
-	sym53c416_queuecommand(SCpnt, internal_done);
-	SCpnt->SCp.Status = 0;
-	while(!SCpnt->SCp.Status)
-		barrier();
-	return SCpnt->result;
-}
-
 static int sym53c416_abort(Scsi_Cmnd *SCpnt)
 {
 	return FAILED;
@@ -880,7 +866,6 @@
 	.name =			"Symbios Logic 53c416",
 	.detect =		sym53c416_detect,
 	.info =			sym53c416_info,	
-	.command =		sym53c416_command,
 	.queuecommand =		sym53c416_queuecommand,
 	.eh_abort_handler =	sym53c416_abort,
 	.eh_host_reset_handler =sym53c416_host_reset,
diff -Nru a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
--- a/drivers/scsi/wd7000.c	Sun Jun  8 19:18:41 2003
+++ b/drivers/scsi/wd7000.c	Sun Jun  8 19:18:41 2003
@@ -1031,14 +1031,6 @@
 	return (scsierr | (hosterr << 16));
 }
 
-
-static void wd7000_scsi_done(Scsi_Cmnd * SCpnt)
-{
-	dprintk("wd7000_scsi_done: 0x%06lx\n", (long) SCpnt);
-	SCpnt->SCp.phase = 0;
-}
-
-
 #define wd7000_intr_ack(host)   outb (0, host->iobase + ASC_INTR_ACK)
 
 static void wd7000_intr_handle(int irq, void *dev_id, struct pt_regs *regs)
@@ -1188,20 +1180,6 @@
 	return 0;
 }
 
-
-static int wd7000_command(Scsi_Cmnd * SCpnt)
-{
-	wd7000_queuecommand(SCpnt, wd7000_scsi_done);
-
-	while (SCpnt->SCp.phase > 0) {
-		cpu_relax();
-		barrier();	/* phase counts scbs down to 0 */
-	}
-
-	return (SCpnt->result);
-}
-
-
 static int wd7000_diagnostics(Adapter * host, int code)
 {
 	static IcbDiag icb = { ICB_OP_DIAGNOSTICS };
@@ -1732,7 +1710,6 @@
 	.name			= "Western Digital WD-7000",
 	.detect			= wd7000_detect,
 	.release		= wd7000_release,
-	.command		= wd7000_command,
 	.queuecommand		= wd7000_queuecommand,
 	.eh_bus_reset_handler	= wd7000_bus_reset,
 	.eh_device_reset_handler = wd7000_device_reset,
