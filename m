From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] avoid obsolete APIs in fdomain
Date: Mon, 21 Jun 2004 16:27:45 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621142745.GC32068@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:41680 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264119AbUFUO1v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 10:27:51 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.26/drivers/scsi/fdomain.c	2004-06-18 22:44:28 +02:00
+++ edited/drivers/scsi/fdomain.c	2004-06-20 17:55:02 +02:00
@@ -284,8 +284,11 @@
 #include <asm/io.h>
 #include <asm/system.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_ioctl.h>
 
 MODULE_AUTHOR("Rickard E. Faith");
 MODULE_DESCRIPTION("Future domain SCSI driver");
@@ -386,7 +389,7 @@
 static int               Quantum;	/* Quantum board variant */
 static int               interrupt_level;
 static volatile int      in_command;
-static Scsi_Cmnd         *current_SC;
+static struct scsi_cmnd  *current_SC;
 static enum chip_type    chip              = unknown;
 static int               adapter_mask;
 static int               this_id;
@@ -415,7 +418,7 @@
 
 static irqreturn_t       do_fdomain_16x0_intr( int irq, void *dev_id,
 					    struct pt_regs * regs );
-int		 	fdomain_16x0_bus_reset(Scsi_Cmnd *SCpnt);
+static int		 fdomain_16x0_bus_reset(struct scsi_cmnd *SCpnt);
 
 /* Allow insmod parameters to be like LILO parameters.  For example:
    insmod fdomain fdomain=0x140,11 */
@@ -552,7 +555,7 @@
    printk( "\n" );
 }
 
-int __init fdomain_setup(char *str)
+static int __init fdomain_setup(char *str)
 {
 	int ints[4];
 
@@ -853,7 +856,7 @@
 }
 #endif
 
-struct Scsi_Host *__fdomain_16x0_detect( Scsi_Host_Template *tpnt )
+struct Scsi_Host *__fdomain_16x0_detect(struct scsi_host_template *tpnt )
 {
    int              retcode;
    struct Scsi_Host *shpnt;
@@ -971,7 +974,7 @@
    return shpnt;
 }
 
-static int fdomain_16x0_detect( Scsi_Host_Template *tpnt )
+static int fdomain_16x0_detect(struct scsi_host_template *tpnt)
 {
 	if (fdomain)
 		fdomain_setup(fdomain);
@@ -1255,7 +1258,7 @@
    if (chip == tmc1800 && !current_SC->SCp.have_data_in
        && (current_SC->SCp.sent_command >= current_SC->cmd_len)) {
       
-      if(scsi_to_pci_dma_dir(current_SC->sc_data_direction)	== PCI_DMA_TODEVICE)
+      if(current_SC->sc_data_direction == DMA_TO_DEVICE)
       {
 	 current_SC->SCp.have_data_in = -1;
 	 outb( 0xd0 | PARITY_MASK, TMC_Cntl_port );
@@ -1388,7 +1391,8 @@
    return IRQ_HANDLED;
 }
 
-static int fdomain_16x0_queue( Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *))
+static int fdomain_16x0_queue(struct scsi_cmnd *SCpnt,
+		void (*done)(struct scsi_cmnd *))
 {
    if (in_command) {
       panic( "scsi: <fdomain> fdomain_16x0_queue() NOT REENTRANT!\n" );
@@ -1440,7 +1444,7 @@
 }
 
 #if DEBUG_ABORT
-static void print_info(Scsi_Cmnd *SCpnt)
+static void print_info(struct scsi_cmnd *SCpnt)
 {
    unsigned int imr;
    unsigned int irr;
@@ -1511,7 +1515,7 @@
 }
 #endif
 
-static int fdomain_16x0_abort( Scsi_Cmnd *SCpnt)
+static int fdomain_16x0_abort(struct scsi_cmnd *SCpnt)
 {
 #if EVERY_ACCESS || ERRORS_ONLY || DEBUG_ABORT
    printk( "scsi: <fdomain> abort " );
@@ -1537,7 +1541,7 @@
    return SUCCESS;
 }
 
-int fdomain_16x0_bus_reset(Scsi_Cmnd *SCpnt)
+static int fdomain_16x0_bus_reset(struct scsi_cmnd *SCpnt)
 {
    outb( 1, SCSI_Cntl_port );
    do_pause( 2 );
@@ -1548,18 +1552,6 @@
    return SUCCESS;
 }
 
-static int fdomain_16x0_host_reset(Scsi_Cmnd *SCpnt)
-{
-  return FAILED;
-}
-
-static int fdomain_16x0_device_reset(Scsi_Cmnd *SCpnt)
-{
-  return FAILED;
-}
-
-#include <scsi/scsi_ioctl.h>
-
 static int fdomain_16x0_biosparam(struct scsi_device *sdev,
 		struct block_device *bdev,
 		sector_t capacity, int *info_array)
@@ -1723,7 +1715,7 @@
 	return 0;
 }
 
-Scsi_Host_Template fdomain_driver_template = {
+struct scsi_host_template fdomain_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "fdomain",
 	.proc_name		= "fdomain",
@@ -1732,8 +1724,6 @@
 	.queuecommand		= fdomain_16x0_queue,
 	.eh_abort_handler	= fdomain_16x0_abort,
 	.eh_bus_reset_handler	= fdomain_16x0_bus_reset,
-	.eh_device_reset_handler = fdomain_16x0_device_reset,
-	.eh_host_reset_handler	= fdomain_16x0_host_reset,
 	.bios_param		= fdomain_16x0_biosparam,
 	.release		= fdomain_16x0_release,
 	.can_queue		= 1,
