From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 04/12] scsi/NCR5380: use NCR5380_dprint() instead of NCR5380_print()
Date: Wed, 19 Mar 2014 23:35:20 +1100
Message-ID: <20140319123517.752438506@telegraphics.com.au>
References: <20140319123516.542623278@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-debug-macros-sun3-NCR5380_print
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Only the NCR5380_dprint() macro should invoke the NCR5380_print() function.
That's why NCR5380.c only defines the function #if NDEBUG. Use the standard
macro.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/sun3_scsi.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-m68k/drivers/scsi/sun3_scsi.c
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi.c	2014-03-19 23:34:41.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi.c	2014-03-19 23:34:41.000000000 +1100
@@ -79,8 +79,6 @@
 #include <scsi/scsi_host.h>
 #include "sun3_scsi.h"
 
-static void NCR5380_print(struct Scsi_Host *instance);
-
 /* #define OLDDMA */
 
 #define USE_WRAPPER
@@ -463,7 +461,7 @@ static unsigned long sun3scsi_dma_setup(
 		printk("scsi%d: fifo_mismatch %04x not %04x\n",
 		       default_instance->host_no, dregs->fifo_count,
 		       (unsigned int) count);
-		NCR5380_print(default_instance);
+		NCR5380_dprint(NDEBUG_DMA, default_instance);
 	}
 
 	/* setup udc */
