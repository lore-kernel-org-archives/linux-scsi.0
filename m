From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] wd7000 updates
Date: Thu, 20 Feb 2003 20:45:07 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030220204507.D19476@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Move the host template to the actual source file and get rid of wd7000.h


--- 1.18/drivers/scsi/wd7000.c	Tue Feb 18 02:02:26 2003
+++ edited/drivers/scsi/wd7000.c	Thu Feb 20 17:57:04 2003
@@ -158,6 +158,11 @@
  * Clean up delay to udelay, and yielding sleeps
  * Make host reset actually reset the card
  * Make everything static
+ *
+ * 2003/02/12 - Christoph Hellwig <hch@infradead.org>
+ *
+ * Cleaned up host template defintion
+ * Removed now obsolete wd7000.h
  */
 
 #include <linux/module.h>
@@ -170,8 +175,8 @@
 #include <linux/ioport.h>
 #include <linux/proc_fs.h>
 #include <linux/blk.h>
-#include <linux/version.h>
 #include <linux/init.h>
+#include <linux/stat.h>
 
 #include <asm/system.h>
 #include <asm/dma.h>
@@ -179,9 +184,9 @@
 
 #include "scsi.h"
 #include "hosts.h"
-
 #include <scsi/scsicam.h>
 
+
 #define ANY2SCSI_INLINE		/* undef this to use old macros */
 #undef  WD7000_DEBUG		/* general debug                */
 #ifdef WD7000_DEBUG
@@ -190,9 +195,6 @@
 #define dprintk(format,args...)
 #endif
 
-#include "wd7000.h"
-#include <linux/stat.h>
-
 /*
  *  Mailbox structure sizes.
  *  I prefer to keep the number of ICMBs much larger than the number of
@@ -212,6 +214,21 @@
 #define MAX_SCBS        32
 
 /*
+ *  In this version, sg_tablesize now defaults to WD7000_SG, and will
+ *  be set to SG_NONE for older boards.  This is the reverse of the
+ *  previous default, and was changed so that the driver-level
+ *  Scsi_Host_Template would reflect the driver's support for scatter/
+ *  gather.
+ *
+ *  Also, it has been reported that boards at Revision 6 support scatter/
+ *  gather, so the new definition of an "older" board has been changed
+ *  accordingly.
+ */
+#define WD7000_Q	16
+#define WD7000_SG	16
+
+
+/*
  *  WD7000-specific mailbox structure
  *
  */
@@ -1737,7 +1754,23 @@
 MODULE_DESCRIPTION("Driver for the WD7000 series ISA controllers");
 MODULE_LICENSE("GPL");
 
-/* Eventually this will go into an include file, but this will be later */
-static Scsi_Host_Template driver_template = WD7000;
+static Scsi_Host_Template driver_template = {
+	.proc_name		= "wd7000",
+	.proc_info		= wd7000_proc_info,
+	.name			= "Western Digital WD-7000",
+	.detect			= wd7000_detect,
+	.command		= wd7000_command,
+	.queuecommand		= wd7000_queuecommand,
+	.eh_bus_reset_handler	= wd7000_bus_reset,
+	.eh_device_reset_handler = wd7000_device_reset,
+	.eh_host_reset_handler	= wd7000_host_reset,
+	.bios_param		= wd7000_biosparam,
+	.can_queue		= WD7000_Q,
+	.this_id		= 7,
+	.sg_tablesize		= WD7000_SG,
+	.cmd_per_lun		= 1,
+	.unchecked_isa_dma	= 1,
+	.use_clustering		= ENABLE_CLUSTERING,
+};
 
 #include "scsi_module.c"
===== drivers/scsi/wd7000.h 1.8 vs edited =====
--- 1.8/drivers/scsi/wd7000.h	Tue Dec 10 21:28:34 2002
+++ edited/drivers/scsi/wd7000.h	Thu Feb 20 17:57:04 2003
@@ -1,64 +0,0 @@
-#ifndef _WD7000_H
-
-/* $Id: $
- *
- * Header file for the WD-7000 driver for Linux
- *
- * John Boyd <boyd@cis.ohio-state.edu>  Jan 1994:
- * This file has been reduced to only the definitions needed for the
- * WD7000 host structure.
- *
- * Revision by Miroslav Zagorac <zaga@fly.cc.fer.hr>  Jun 1997.
- */
-
-#include <linux/types.h>
-
-static int wd7000_set_info(char *buffer, int length, struct Scsi_Host *host);
-static int wd7000_proc_info(char *buffer, char **start, off_t offset, int length, int hostno, int inout);
-static int wd7000_detect(Scsi_Host_Template *);
-static int wd7000_command(Scsi_Cmnd *);
-static int wd7000_queuecommand(Scsi_Cmnd *, void (*done) (Scsi_Cmnd *));
-static int wd7000_abort(Scsi_Cmnd *);
-static int wd7000_bus_reset(Scsi_Cmnd *);
-static int wd7000_host_reset(Scsi_Cmnd *);
-static int wd7000_device_reset(Scsi_Cmnd *);
-static int wd7000_biosparam(struct scsi_device *, struct block_device *,
-		sector_t, int *);
-
-#ifndef NULL
-#define NULL 0L
-#endif
-
-/*
- *  In this version, sg_tablesize now defaults to WD7000_SG, and will
- *  be set to SG_NONE for older boards.  This is the reverse of the
- *  previous default, and was changed so that the driver-level
- *  Scsi_Host_Template would reflect the driver's support for scatter/
- *  gather.
- *
- *  Also, it has been reported that boards at Revision 6 support scatter/
- *  gather, so the new definition of an "older" board has been changed
- *  accordingly.
- */
-#define WD7000_Q    16
-#define WD7000_SG   16
-
-#define WD7000 {						\
-	.proc_name		= "wd7000",			\
-	.proc_info		= wd7000_proc_info,		\
-	.name			= "Western Digital WD-7000",	\
-	.detect			= wd7000_detect,			\
-	.command		= wd7000_command,			\
-	.queuecommand		= wd7000_queuecommand,		\
-	.eh_bus_reset_handler	= wd7000_bus_reset,		\
-	.eh_device_reset_handler = wd7000_device_reset,		\
-	.eh_host_reset_handler	= wd7000_host_reset,		\
-	.bios_param		= wd7000_biosparam,		\
-	.can_queue		= WD7000_Q,			\
-	.this_id		= 7,				\
-	.sg_tablesize		= WD7000_SG,			\
-	.cmd_per_lun		= 1,				\
-	.unchecked_isa_dma	= 1,				\
-	.use_clustering		= ENABLE_CLUSTERING,		\
-}
-#endif
