From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] give all LLDD driver a ->release method
Date: Tue, 3 Jun 2003 22:19:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030603201902.GA8874@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:60328 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264094AbTFCUFo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2003 16:05:44 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This allows us to kill the horrible scsi_host_legacy_release hack.
Note that the new ->release methods still seem to be incorrect in
some case, but I really want to kill that hack in core code not
to make all drivers perfect.


diff -Nru a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
--- a/drivers/scsi/NCR53c406a.c	Tue Jun  3 00:27:44 2003
+++ b/drivers/scsi/NCR53c406a.c	Tue Jun  3 00:27:44 2003
@@ -590,6 +590,21 @@
 	return 0;
 }
 
+static int NCR53c406a_release(struct Scsi_Host *shost)
+{
+	if (shost->irq)
+		free_irq(shost->irq, NULL);
+#ifdef USE_DMA
+	if (shost->dma_channel != 0xff)
+		free_dma(shost->dma_channel);
+#endif
+	if (shost->io_port && shost->n_io_port)
+		release_region(shost->io_port, shost->n_io_port);
+
+	scsi_unregister(shost);
+	return 0;
+}
+
 /* called from init/main.c */
 static void __init NCR53c406a_setup(char *str, int *ints)
 {
@@ -1074,6 +1089,7 @@
      .proc_name         	= "NCR53c406a"		/* proc_name */,        
      .name              	= "NCR53c406a"		/* name */,             
      .detect            	= NCR53c406a_detect	/* detect */,           
+     .release            	= NCR53c406a_release,
      .info              	= NCR53c406a_info		/* info */,             
      .command           	= NCR53c406a_command	/* command */,          
      .queuecommand      	= NCR53c406a_queue	/* queuecommand */,     
diff -Nru a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
--- a/drivers/scsi/aha1542.c	Tue Jun  3 00:27:44 2003
+++ b/drivers/scsi/aha1542.c	Tue Jun  3 00:27:44 2003
@@ -1325,6 +1325,18 @@
 	return count;
 }
 
+static int aha1542_release(struct Scsi_Host *shost)
+{
+	if (shost->irq)
+		free_irq(shost->irq, NULL);
+	if (shost->dma_channel != 0xff)
+		free_dma(shost->dma_channel);
+	if (shost->io_port && shost->n_io_port)
+		release_region(shost->io_port, shost->n_io_port);
+	scsi_unregister(shost);
+	return 0;
+}
+
 static int aha1542_restart(struct Scsi_Host *shost)
 {
 	int i;
@@ -1817,6 +1829,7 @@
 	.proc_name		= "aha1542",
 	.name			= "Adaptec 1542",
 	.detect			= aha1542_detect,
+	.release		= aha1542_release,
 	.command		= aha1542_command,
 	.queuecommand		= aha1542_queuecommand,
 	.eh_abort_handler	= aha1542_abort,
diff -Nru a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
--- a/drivers/scsi/aha1740.c	Tue Jun  3 00:27:44 2003
+++ b/drivers/scsi/aha1740.c	Tue Jun  3 00:27:44 2003
@@ -567,6 +567,16 @@
     return count;
 }
 
+static int aha1740_release(struct Scsi_Host *shost)
+{
+	if (shost->irq)
+		free_irq(shost->irq, NULL);
+	if (shost->io_port && shost->n_io_port)
+		release_region(shost->io_port, shost->n_io_port);
+	scsi_unregister(shost);
+	return 0;
+}
+
 static int aha1740_biosparam(struct scsi_device *sdev, struct block_device *dev,
 		sector_t capacity, int* ip)
 {
@@ -596,6 +606,7 @@
 	.proc_info		= aha1740_proc_info,
 	.name			= "Adaptec 174x (EISA)",
 	.detect			= aha1740_detect,
+	.release		= aha1740_release,
 	.command		= aha1740_command,
 	.queuecommand		= aha1740_queuecommand,
 	.bios_param		= aha1740_biosparam,
diff -Nru a/drivers/scsi/amiga7xx.c b/drivers/scsi/amiga7xx.c
--- a/drivers/scsi/amiga7xx.c	Tue Jun  3 00:27:44 2003
+++ b/drivers/scsi/amiga7xx.c	Tue Jun  3 00:27:44 2003
@@ -134,9 +134,22 @@
     return num;
 }
 
+static int amiga7xx_release(struct Scsi_Host *shost)
+{
+	if (shost->irq)
+		free_irq(shost->irq, NULL);
+	if (shost->dma_channel != 0xff)
+		free_dma(shost->dma_channel);
+	if (shost->io_port && shost->n_io_port)
+		release_region(shost->io_port, shost->n_io_port);
+	scsi_unregister(shost);
+	return 0;
+}
+
 static Scsi_Host_Template driver_template = {
 	.name			= "Amiga NCR53c710 SCSI",
 	.detect			= amiga7xx_detect,
+	.release		= amiga7xx_release,
 	.queuecommand		= NCR53c7xx_queue_command,
 	.abort			= NCR53c7xx_abort,
 	.reset			= NCR53c7xx_reset,
diff -Nru a/drivers/scsi/bvme6000.c b/drivers/scsi/bvme6000.c
--- a/drivers/scsi/bvme6000.c	Tue Jun  3 00:27:44 2003
+++ b/drivers/scsi/bvme6000.c	Tue Jun  3 00:27:44 2003
@@ -51,9 +51,22 @@
     return 1;
 }
 
+static int mvme6000_scsi_release(struct Scsi_Host *shost)
+{
+	if (shost->irq)
+		free_irq(shost->irq, NULL);
+	if (shost->dma_channel != 0xff)
+		free_dma(shost->dma_channel);
+	if (shost->io_port && shost->n_io_port)
+		release_region(shost->io_port, shost->n_io_port);
+	scsi_unregister(shost);
+	return 0;
+}
+
 static Scsi_Host_Template driver_template = {
 	.name			= "BVME6000 NCR53c710 SCSI",
 	.detect			= bvme6000_scsi_detect,
+	.release		= bvme6000_scsi_release,
 	.queuecommand		= NCR53c7xx_queue_command,
 	.abort			= NCR53c7xx_abort,
 	.reset			= NCR53c7xx_reset,
diff -Nru a/drivers/scsi/dec_esp.c b/drivers/scsi/dec_esp.c
--- a/drivers/scsi/dec_esp.c	Tue Jun  3 00:27:45 2003
+++ b/drivers/scsi/dec_esp.c	Tue Jun  3 00:27:45 2003
@@ -109,11 +109,22 @@
 
 int dec_esp_detect(Scsi_Host_Template * tpnt);
 
+static int dec_esp_release(struct Scsi_Host *shost)
+{
+	if (shost->irq)
+		free_irq(shost->irq, NULL);
+	if (shost->io_port && shost->n_io_port)
+		release_region(shost->io_port, shost->n_io_port);
+	scsi_unregister(shost);
+	return 0;
+}
+
 static Scsi_Host_Template driver_template = {
 	.proc_name		= "esp",
 	.proc_info		= &esp_proc_info,
 	.name			= "NCR53C94",
 	.detect			= dec_esp_detect,
+	.release		= dec_esp_release,
 	.info			= esp_info,
 	.command		= esp_command,
 	.queuecommand		= esp_queue,
diff -Nru a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
--- a/drivers/scsi/dtc.c	Tue Jun  3 00:27:45 2003
+++ b/drivers/scsi/dtc.c	Tue Jun  3 00:27:45 2003
@@ -447,9 +447,20 @@
 
 #include "NCR5380.c"
 
+static int dtc_release(struct Scsi_Host *shost)
+{
+	if (shost->irq)
+		free_irq(shost->irq, NULL);
+	if (shost->io_port && shost->n_io_port)
+		release_region(shost->io_port, shost->n_io_port);
+	scsi_unregister(shost);
+	return 0;
+}
+
 static Scsi_Host_Template driver_template = {
 	.name				= "DTC 3180/3280 ",
 	.detect				= dtc_detect,
+	.release			= dtc_release,
 	.queuecommand			= dtc_queue_command,
 	.eh_abort_handler		= dtc_abort,
 	.eh_bus_reset_handler		= dtc_bus_reset,
diff -Nru a/drivers/scsi/esp.c b/drivers/scsi/esp.c
--- a/drivers/scsi/esp.c	Tue Jun  3 00:27:45 2003
+++ b/drivers/scsi/esp.c	Tue Jun  3 00:27:45 2003
@@ -1237,6 +1237,17 @@
         return 0;
 }
 
+/* this is clearly wrong for esp.. */
+static int esp_release(struct Scsi_Host *shost)
+{
+	if (shost->irq)
+		free_irq(shost->irq, NULL);
+	if (shost->io_port && shost->n_io_port)
+		release_region(shost->io_port, shost->n_io_port);
+	scsi_unregister(shost);
+	return 0;
+}
+
 /* The info function will return whatever useful
  * information the developer sees fit.  If not provided, then
  * the name field will be used instead.
@@ -4384,12 +4395,12 @@
 	SDptr->hostdata = NULL;
 }
 
-
 static Scsi_Host_Template driver_template = {
 	.proc_name		= "esp",
 	.proc_info		= esp_proc_info,
 	.name			= "Sun ESP 100/100a/200",
 	.detect			= esp_detect,
+	.release		= esp_release,
 	.slave_alloc		= esp_slave_alloc,
 	.slave_destroy		= esp_slave_destroy,
 	.release		= esp_release,
diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Tue Jun  3 00:27:44 2003
+++ b/drivers/scsi/hosts.c	Tue Jun  3 00:27:44 2003
@@ -34,11 +34,9 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/init.h>
-#include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/completion.h>
 #include <linux/unistd.h>
-#include <asm/dma.h>
 
 #include "scsi.h"
 #include "hosts.h"
@@ -83,28 +81,6 @@
 }
 
 /**
- * scsi_host_legacy_release - default release function for hosts
- * @shost: 
- * 
- * Description:
- * 	This is the default case for the release function.  Its completely
- *	useless for anything but old ISA adapters
- **/
-static int scsi_host_legacy_release(struct Scsi_Host *shost)
-{
-	if (shost->irq)
-		free_irq(shost->irq, NULL);
-#ifdef CONFIG_GENERIC_ISA_DMA
-	if (shost->dma_channel != 0xff)
-		free_dma(shost->dma_channel);
-#endif
-	if (shost->io_port && shost->n_io_port)
-		release_region(shost->io_port, shost->n_io_port);
-
-	return 0;
-}
-
-/**
  * scsi_remove_host - check a scsi host for release and release
  * @shost:	a pointer to a scsi host to release
  *
@@ -355,7 +331,9 @@
 		printk(KERN_WARNING
 		    "scsi HBA driver %s didn't set a release method, "
 		    "please fix the template\n", shost_tp->name);
-		shost_tp->release = &scsi_host_legacy_release;
+		dump_stack();
+		return -EINVAL;
+		
 	}
 
 	shost_tp->detect(shost_tp);
diff -Nru a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
--- a/drivers/scsi/jazz_esp.c	Tue Jun  3 00:27:44 2003
+++ b/drivers/scsi/jazz_esp.c	Tue Jun  3 00:27:44 2003
@@ -139,6 +139,18 @@
     return 0;
 }
 
+static int jazz_esp_release(struct Scsi_Host *shost)
+{
+	if (shost->irq)
+		free_irq(shost->irq, NULL);
+	if (shost->dma_channel != 0xff)
+		free_dma(shost->dma_channel);
+	if (shost->io_port && shost->n_io_port)
+		release_region(shost->io_port, shost->n_io_port);
+	scsi_unregister(shost);
+	return 0;
+}
+
 /************************************************************* DMA Functions */
 static int dma_bytes_sent(struct NCR_ESP *esp, int fifo_count)
 {
@@ -278,6 +290,7 @@
 	.proc_info		= &esp_proc_info,
 	.name			= "ESP 100/100a/200",
 	.detect			= jazz_esp_detect,
+	.release		= jazz_esp_release,
 	.info			= esp_info,
 	.command		= esp_command,
 	.queuecommand		= esp_queue,
diff -Nru a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
--- a/drivers/scsi/mac_esp.c	Tue Jun  3 00:27:44 2003
+++ b/drivers/scsi/mac_esp.c	Tue Jun  3 00:27:44 2003
@@ -464,6 +464,16 @@
 	return chipspresent;
 }
 
+static int mac_esp_release(struct Scsi_Host *shost)
+{
+	if (shost->irq)
+		free_irq(shost->irq, NULL);
+	if (shost->io_port && shost->n_io_port)
+		release_region(shost->io_port, shost->n_io_port);
+	scsi_unregister(shost);
+	return 0;
+}
+
 /*
  * I've been wondering what this is supposed to do, for some time. Talking 
  * to Allen Briggs: These machines have an extra register someplace where the
@@ -717,6 +727,7 @@
 	.proc_name		= "esp",
 	.name			= "Mac 53C9x SCSI",
 	.detect			= mac_esp_detect,
+	.release		= mac_esp_release,
 	.info			= esp_info,
 	/* .command		= esp_command, */
 	.queuecommand		= esp_queue,
diff -Nru a/drivers/scsi/mvme16x.c b/drivers/scsi/mvme16x.c
--- a/drivers/scsi/mvme16x.c	Tue Jun  3 00:27:45 2003
+++ b/drivers/scsi/mvme16x.c	Tue Jun  3 00:27:45 2003
@@ -53,9 +53,22 @@
     return 1;
 }
 
+static int mvme16x_scsi_release(struct Scsi_Host *shost)
+{
+	if (shost->irq)
+		free_irq(shost->irq, NULL);
+	if (shost->dma_channel != 0xff)
+		free_dma(shost->dma_channel);
+	if (shost->io_port && shost->n_io_port)
+		release_region(shost->io_port, shost->n_io_port);
+	scsi_unregister(shost);
+	return 0;
+}
+
 static Scsi_Host_Template driver_template = {
 	.name			= "MVME16x NCR53c710 SCSI",
 	.detect			= mvme16x_scsi_detect,
+	.release		= mvme16x_scsi_release,
 	.queuecommand		= NCR53c7xx_queue_command,
 	.abort			= NCR53c7xx_abort,
 	.reset			= NCR53c7xx_reset,
diff -Nru a/drivers/scsi/pas16.c b/drivers/scsi/pas16.c
--- a/drivers/scsi/pas16.c	Tue Jun  3 00:27:44 2003
+++ b/drivers/scsi/pas16.c	Tue Jun  3 00:27:44 2003
@@ -600,9 +600,22 @@
 
 #include "NCR5380.c"
 
+static int pas16_release(struct Scsi_Host *shost)
+{
+	if (shost->irq)
+		free_irq(shost->irq, NULL);
+	if (shost->dma_channel != 0xff)
+		free_dma(shost->dma_channel);
+	if (shost->io_port && shost->n_io_port)
+		release_region(shost->io_port, shost->n_io_port);
+	scsi_unregister(shost);
+	return 0;
+}
+
 static Scsi_Host_Template driver_template = {
 	.name           = "Pro Audio Spectrum-16 SCSI",
 	.detect         = pas16_detect,
+	.release        = pas16_release,
 	.queuecommand   = pas16_queue_command,
 	.eh_abort_handler = pas16_abort,
 	.eh_bus_reset_handler = pas16_bus_reset,
diff -Nru a/drivers/scsi/psi240i.c b/drivers/scsi/psi240i.c
--- a/drivers/scsi/psi240i.c	Tue Jun  3 00:27:44 2003
+++ b/drivers/scsi/psi240i.c	Tue Jun  3 00:27:45 2003
@@ -655,6 +655,17 @@
 		}
 	return count;
 	}
+
+static int Psi240i_Release(struct Scsi_Host *shost)
+{
+	if (shost->irq)
+		free_irq(shost->irq, NULL);
+	if (shost->io_port && shost->n_io_port)
+		release_region(shost->io_port, shost->n_io_port);
+	scsi_unregister(shost);
+	return 0;
+}
+
 /****************************************************************
  *	Name:	Psi240i_Abort
  *
@@ -722,6 +733,7 @@
 	.proc_name		= "psi240i", 
 	.name			= "PSI-240I EIDE Disk Controller",
 	.detect			= Psi240i_Detect,
+	.release		= Psi240i_Release,
 	.command		= Psi240i_Command,
 	.queuecommand		= Psi240i_QueueCommand,
 	.abort	  		= Psi240i_Abort,
diff -Nru a/drivers/scsi/qlogicfas.c b/drivers/scsi/qlogicfas.c
--- a/drivers/scsi/qlogicfas.c	Tue Jun  3 00:27:45 2003
+++ b/drivers/scsi/qlogicfas.c	Tue Jun  3 00:27:45 2003
@@ -739,6 +739,18 @@
 	return (__qlogicfas_detect(sht) != NULL);
 }
 
+static int qlogicfas_release(struct Scsi_Host *shost)
+{
+	if (shost->irq)
+		free_irq(shost->irq, NULL);
+	if (shost->dma_channel != 0xff)
+		free_dma(shost->dma_channel);
+	if (shost->io_port && shost->n_io_port)
+		release_region(shost->io_port, shost->n_io_port);
+	scsi_unregister(shost);
+	return 0;
+}
+
 /* 
  *	Return bios parameters 
  */
@@ -826,6 +838,7 @@
 	.name			= "qlogicfas",
 	.proc_name		= "qlogicfas",
 	.detect			= qlogicfas_detect,
+	.release		= qlogicfas_release,
 	.info			= qlogicfas_info,
 	.command		= qlogicfas_command,
 	.queuecommand		= qlogicfas_queuecommand,
diff -Nru a/drivers/scsi/t128.c b/drivers/scsi/t128.c
--- a/drivers/scsi/t128.c	Tue Jun  3 00:27:45 2003
+++ b/drivers/scsi/t128.c	Tue Jun  3 00:27:45 2003
@@ -280,6 +280,16 @@
     return count;
 }
 
+static int t128_release(struct Scsi_Host *shost)
+{
+	if (shost->irq)
+		free_irq(shost->irq, NULL);
+	if (shost->io_port && shost->n_io_port)
+		release_region(shost->io_port, shost->n_io_port);
+	scsi_unregister(shost);
+	return 0;
+}
+
 /*
  * Function : int t128_biosparam(Disk * disk, struct block_device *dev, int *ip)
  *
@@ -403,6 +413,7 @@
 static Scsi_Host_Template driver_template = {
 	.name           = "Trantor T128/T128F/T228",
 	.detect         = t128_detect,
+	.release        = t128_release,
 	.queuecommand   = t128_queue_command,
 	.eh_abort_handler = t128_abort,
 	.eh_bus_reset_handler    = t128_bus_reset,
diff -Nru a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
--- a/drivers/scsi/ultrastor.c	Tue Jun  3 00:27:44 2003
+++ b/drivers/scsi/ultrastor.c	Tue Jun  3 00:27:44 2003
@@ -643,6 +643,18 @@
 	return ultrastor_14f_detect(tpnt) || ultrastor_24f_detect(tpnt);
 }
 
+static int ultrastor_release(struct Scsi_Host *shost)
+{
+	if (shost->irq)
+		free_irq(shost->irq, NULL);
+	if (shost->dma_channel != 0xff)
+		free_dma(shost->dma_channel);
+	if (shost->io_port && shost->n_io_port)
+		release_region(shost->io_port, shost->n_io_port);
+	scsi_unregister(shost);
+	return 0;
+}
+
 static const char *ultrastor_info(struct Scsi_Host * shpnt)
 {
     static char buf[64];
@@ -1177,6 +1189,7 @@
 static Scsi_Host_Template driver_template = {
 	.name              = "UltraStor 14F/24F/34F",
 	.detect            = ultrastor_detect,
+	.release	   = ultrastor_release,
 	.info              = ultrastor_info,
 	.queuecommand      = ultrastor_queuecommand,
 	.eh_abort_handler  = ultrastor_abort,
diff -Nru a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
--- a/drivers/scsi/wd7000.c	Tue Jun  3 00:27:45 2003
+++ b/drivers/scsi/wd7000.c	Tue Jun  3 00:27:45 2003
@@ -1616,6 +1616,15 @@
 	return (present);
 }
 
+static int wd7000_release(struct Scsi_Host *shost)
+{
+	if (shost->irq)
+		free_irq(shost->irq, NULL);
+	if (shost->io_port && shost->n_io_port)
+		release_region(shost->io_port, shost->n_io_port);
+	scsi_unregister(shost);
+	return 0;
+}
 
 /*
  *  I have absolutely NO idea how to do an abort with the WD7000...
@@ -1722,6 +1731,7 @@
 	.proc_info		= wd7000_proc_info,
 	.name			= "Western Digital WD-7000",
 	.detect			= wd7000_detect,
+	.release		= wd7000_release,
 	.command		= wd7000_command,
 	.queuecommand		= wd7000_queuecommand,
 	.eh_bus_reset_handler	= wd7000_bus_reset,
