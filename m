From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 45/78] ncr5380: Cleanup #include directives
Date: Sun, 03 Jan 2016 16:05:46 +1100
Message-ID: <20160103050512.941979535@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline; filename=ncr5380-move-core-driver-includes
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

Remove unused includes (stat.h, signal.h, proc_fs.h) and move includes
needed by the core drivers into the common header (delay.h etc).

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |    2 --
 drivers/scsi/NCR5380.h       |    4 ++++
 drivers/scsi/arm/cumana_1.c  |    4 ----
 drivers/scsi/arm/oak.c       |    2 --
 drivers/scsi/atari_NCR5380.c |    5 -----
 drivers/scsi/atari_scsi.c    |    1 -
 drivers/scsi/dmx3191d.c      |    5 -----
 drivers/scsi/dtc.c           |    4 +---
 drivers/scsi/g_NCR5380.c     |    6 ++----
 drivers/scsi/mac_scsi.c      |    1 -
 drivers/scsi/pas16.c         |    4 ----
 drivers/scsi/t128.c          |    3 ---
 12 files changed, 7 insertions(+), 34 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:03:59.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:04:00.000000000 +1100
@@ -79,8 +79,6 @@
  * 4.  Test SCSI-II tagged queueing (I have no devices which support 
  *      tagged queueing)
  */
-#include <scsi/scsi_dbg.h>
-#include <scsi/scsi_transport_spi.h>
 
 #if (NDEBUG & NDEBUG_LISTS)
 #define LIST(x,y) {printk("LINE:%d   Adding %p to %p\n", __LINE__, (void*)(x), (void*)(y)); if ((x)==(y)) udelay(5); }
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2016-01-03 16:03:54.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2016-01-03 16:04:00.000000000 +1100
@@ -22,8 +22,12 @@
 #ifndef NCR5380_H
 #define NCR5380_H
 
+#include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <scsi/scsi_dbg.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_transport_spi.h>
 
 #define NDEBUG_ARBITRATION	0x1
 #define NDEBUG_AUTOSENSE	0x2
Index: linux/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux.orig/drivers/scsi/arm/cumana_1.c	2016-01-03 16:03:31.000000000 +1100
+++ linux/drivers/scsi/arm/cumana_1.c	2016-01-03 16:04:00.000000000 +1100
@@ -4,9 +4,7 @@
  * Copyright 1995-2002, Russell King
  */
 #include <linux/module.h>
-#include <linux/signal.h>
 #include <linux/ioport.h>
-#include <linux/delay.h>
 #include <linux/blkdev.h>
 #include <linux/init.h>
 
@@ -15,8 +13,6 @@
 
 #include <scsi/scsi_host.h>
 
-#include <scsi/scsicam.h>
-
 #define PSEUDO_DMA
 
 #define priv(host)			((struct NCR5380_hostdata *)(host)->hostdata)
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2016-01-03 16:03:31.000000000 +1100
+++ linux/drivers/scsi/arm/oak.c	2016-01-03 16:04:00.000000000 +1100
@@ -5,9 +5,7 @@
  */
 
 #include <linux/module.h>
-#include <linux/signal.h>
 #include <linux/ioport.h>
-#include <linux/delay.h>
 #include <linux/blkdev.h>
 #include <linux/init.h>
 
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:59.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:04:00.000000000 +1100
@@ -68,9 +68,6 @@
 
 /* Adapted for the sun3 by Sam Creasey. */
 
-#include <scsi/scsi_dbg.h>
-#include <scsi/scsi_transport_spi.h>
-
 #if (NDEBUG & NDEBUG_LISTS)
 #define LIST(x, y)						\
 	do {							\
@@ -517,8 +514,6 @@ static inline int NCR5380_poll_politely(
 	                                        reg, bit, val, wait);
 }
 
-#include <linux/delay.h>
-
 #if NDEBUG
 static struct {
 	unsigned char mask;
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2016-01-03 16:03:23.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2016-01-03 16:04:00.000000000 +1100
@@ -66,7 +66,6 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/delay.h>
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2016-01-03 16:03:23.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2016-01-03 16:04:00.000000000 +1100
@@ -41,11 +41,6 @@
 
 #define NCR5380_implementation_fields	/* none */
 
-/*
- * Includes needed for NCR5380.[ch] (XXX: Move them to NCR5380.h)
- */
-#include <linux/delay.h>
-
 #include "NCR5380.h"
 #include "NCR5380.c"
 
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2016-01-03 16:03:54.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2016-01-03 16:04:00.000000000 +1100
@@ -46,15 +46,13 @@
 
 
 #include <linux/module.h>
-#include <linux/signal.h>
 #include <linux/blkdev.h>
-#include <linux/delay.h>
-#include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <scsi/scsi_host.h>
+
 #include "dtc.h"
 #define AUTOPROBE_IRQ
 #include "NCR5380.h"
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-01-03 16:03:54.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-01-03 16:04:00.000000000 +1100
@@ -63,16 +63,14 @@
 #endif
 
 #include <asm/io.h>
-#include <linux/signal.h>
 #include <linux/blkdev.h>
+#include <linux/module.h>
 #include <scsi/scsi_host.h>
 #include "g_NCR5380.h"
 #include "NCR5380.h"
-#include <linux/stat.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/isapnp.h>
-#include <linux/delay.h>
 #include <linux/interrupt.h>
 
 static int ncr_irq;
@@ -732,7 +730,7 @@ static struct scsi_host_template driver_
 	.cmd_per_lun    	= CMD_PER_LUN,
         .use_clustering		= DISABLE_CLUSTERING,
 };
-#include <linux/module.h>
+
 #include "scsi_module.c"
 
 module_param(ncr_irq, int, 0);
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2016-01-03 16:03:31.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2016-01-03 16:04:00.000000000 +1100
@@ -12,7 +12,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2016-01-03 16:03:49.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2016-01-03 16:04:00.000000000 +1100
@@ -69,14 +69,10 @@
  
 #include <linux/module.h>
 
-#include <linux/signal.h>
-#include <linux/proc_fs.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <linux/blkdev.h>
-#include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <linux/stat.h>
 #include <linux/init.h>
 
 #include <scsi/scsi_host.h>
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2016-01-03 16:03:23.000000000 +1100
+++ linux/drivers/scsi/t128.c	2016-01-03 16:04:00.000000000 +1100
@@ -68,14 +68,11 @@
  * 15 9-11
  */
  
-#include <linux/signal.h>
 #include <linux/io.h>
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
-#include <linux/stat.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/delay.h>
 
 #include <scsi/scsi_host.h>
 #include "t128.h"
