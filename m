From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 02/29] ncr5380: Remove unused hostdata fields
Date: Thu, 02 Oct 2014 16:56:30 +1000
Message-ID: <20141002065628.746182414@telegraphics.com.au>
References: <20141002065628.256592712@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33693 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaJBNDn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 09:03:43 -0400
Content-Disposition: inline; filename=ncr5380-remove-unused-hostdata
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

Remove unused fields from hostdata structs declared with the
NCR5380_implementation_fields macro.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/dmx3191d.c  |    4 ++--
 drivers/scsi/mac_scsi.c  |   33 ---------------------------------
 drivers/scsi/mac_scsi.h  |    3 +--
 drivers/scsi/sun3_scsi.c |    2 --
 drivers/scsi/sun3_scsi.h |    3 +--
 5 files changed, 4 insertions(+), 41 deletions(-)

Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2014-10-02 16:55:29.000000000 +1000
+++ linux/drivers/scsi/dmx3191d.c	2014-10-02 16:55:50.000000000 +1000
@@ -38,8 +38,8 @@
 #define NCR5380_read(reg)		inb(port + reg)
 #define NCR5380_write(reg, value)	outb(value, port + reg)
 
-#define NCR5380_implementation_fields	unsigned int port
-#define NCR5380_local_declare()		NCR5380_implementation_fields
+#define NCR5380_implementation_fields	/* none */
+#define NCR5380_local_declare()		unsigned int port
 #define NCR5380_setup(instance)		port = instance->io_port
 
 /*
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2014-10-02 16:55:29.000000000 +1000
+++ linux/drivers/scsi/mac_scsi.c	2014-10-02 16:55:50.000000000 +1000
@@ -93,35 +93,6 @@ static volatile unsigned char *mac_scsi_
  * NCR 5380 register access functions
  */
 
-#if 0
-/* Debug versions */
-#define CTRL(p,v) (*ctrl = (v))
-
-static char macscsi_read(struct Scsi_Host *instance, int reg)
-{
-  int iobase = instance->io_port;
-  int i;
-  int *ctrl = &((struct NCR5380_hostdata *)instance->hostdata)->ctrl;
-
-  CTRL(iobase, 0);
-  i = in_8(iobase + (reg<<4));
-  CTRL(iobase, 0x40);
-
-  return i;
-}
-
-static void macscsi_write(struct Scsi_Host *instance, int reg, int value)
-{
-  int iobase = instance->io_port;
-  int *ctrl = &((struct NCR5380_hostdata *)instance->hostdata)->ctrl;
-
-  CTRL(iobase, 0);
-  out_8(iobase + (reg<<4), value);
-  CTRL(iobase, 0x40);
-}
-#else
-
-/* Fast versions */
 static __inline__ char macscsi_read(struct Scsi_Host *instance, int reg)
 {
   return in_8(instance->io_port + (reg<<4));
@@ -131,8 +102,6 @@ static __inline__ void macscsi_write(str
 {
   out_8(instance->io_port + (reg<<4), value);
 }
-#endif
-
 
 /*
  * Function : mac_scsi_setup(char *str)
@@ -279,8 +248,6 @@ int __init macscsi_detect(struct scsi_ho
 
     instance->n_io_port = 255;
 
-    ((struct NCR5380_hostdata *)instance->hostdata)->ctrl = 0;
-
     if (instance->irq != SCSI_IRQ_NONE)
 	if (request_irq(instance->irq, NCR5380_intr, 0, "ncr5380", instance)) {
 	    printk(KERN_WARNING "scsi%d: IRQ%d not free, interrupts disabled\n",
Index: linux/drivers/scsi/mac_scsi.h
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.h	2014-10-02 16:55:29.000000000 +1000
+++ linux/drivers/scsi/mac_scsi.h	2014-10-02 16:55:50.000000000 +1000
@@ -47,8 +47,7 @@
 
 #include <scsi/scsicam.h>
 
-#define NCR5380_implementation_fields \
-    int port, ctrl
+#define NCR5380_implementation_fields /* none */
 
 #define NCR5380_local_declare() \
         struct Scsi_Host *_instance
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2014-10-02 16:55:29.000000000 +1000
+++ linux/drivers/scsi/sun3_scsi.c	2014-10-02 16:55:50.000000000 +1000
@@ -313,8 +313,6 @@ static int __init sun3scsi_detect(struct
 
 	instance->n_io_port = 32;
 
-        ((struct NCR5380_hostdata *)instance->hostdata)->ctrl = 0;
-
 	if (request_irq(instance->irq, scsi_sun3_intr,
 			     0, "Sun3SCSI-5380", instance)) {
 #ifndef REAL_DMA
Index: linux/drivers/scsi/sun3_scsi.h
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.h	2014-10-02 16:55:29.000000000 +1000
+++ linux/drivers/scsi/sun3_scsi.h	2014-10-02 16:55:50.000000000 +1000
@@ -78,8 +78,7 @@ static int sun3scsi_release (struct Scsi
 #define SUN3_SCSI_NAME "Sun3 NCR5380 SCSI"
 #endif
 
-#define NCR5380_implementation_fields \
-    int port, ctrl
+#define NCR5380_implementation_fields /* none */
 
 #define NCR5380_local_declare() \
         struct Scsi_Host *_instance


