From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 11/12] scsi/NCR5380: reduce depth of sun3_scsi nested includes
Date: Wed, 19 Mar 2014 23:35:27 +1100
Message-ID: <20140319123519.842734137@telegraphics.com.au>
References: <20140319123516.542623278@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-sun3-includes
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Move the #include "NCR5380.h" out of the sun3_scsi.h header file and into
the driver .c files, like all the other NCR5380 drivers in the tree.

This improves uniformity and reduces the depth of nested includes. The
sequence of #include's, #define's and #if's no longer does my head in.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

Here's a graph showing the present #include structure.


      sun3_scsi_vme.c  ----->  sun3_scsi.h  ----->  NCR5380.h

              |                    ^
              '--------------------|----.
                                   |    |
                  .----------------'    |
                  |                     v

          sun3_scsi.c  ----->  sun3_NCR5380.c


And here's the situation at the end of this patch series, after moving the
#includes with this patch, and merging sun3_scsi.c and sun3_scsi_vme with
the next patch.


                           sun3_scsi.h

                               ^
                               |
                               |

    sun3_scsi_vme.c  ----->  sun3_scsi.c  ----->  sun3_NCR5380.c

                                   |
                                   |
                                   v

                               NCR5380.h


The final structure (see the next patch) of sun3_scsi_vme mirrors that of
g_NCR5380_mmio.c, and the final structure of sun3_scsi mirrors that of all
the other NCR5380 drivers.

BTW, both sun3_scsi.c and sun3_scsi_vme.c also #include "initio.h"
but I've sent a separate patch to address this.

---
 drivers/scsi/sun3_scsi.c     |    1 +
 drivers/scsi/sun3_scsi.h     |    8 +++-----
 drivers/scsi/sun3_scsi_vme.c |    1 +
 3 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-m68k/drivers/scsi/sun3_scsi.c
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi.c	2014-03-19 23:34:44.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi.c	2014-03-19 23:34:45.000000000 +1100
@@ -72,6 +72,7 @@
 #include "initio.h"
 #include <scsi/scsi_host.h>
 #include "sun3_scsi.h"
+#include "NCR5380.h"
 
 /* #define OLDDMA */
 
Index: linux-m68k/drivers/scsi/sun3_scsi.h
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi.h	2014-03-19 23:34:45.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi.h	2014-03-19 23:34:45.000000000 +1100
@@ -29,8 +29,8 @@
  * 1+ (800) 334-5454
  */
 
-#ifndef SUN3_NCR5380_H
-#define SUN3_NCR5380_H
+#ifndef SUN3_SCSI_H
+#define SUN3_SCSI_H
 
 #define SUN3SCSI_PUBLIC_RELEASE 1
 
@@ -182,7 +182,5 @@ struct sun3_udc_regs {
 
 #define VME_DATA24 0x3d00
 
-#include "NCR5380.h"
-
-#endif /* SUN3_NCR5380_H */
+#endif /* SUN3_SCSI_H */
 
Index: linux-m68k/drivers/scsi/sun3_scsi_vme.c
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi_vme.c	2014-03-19 23:34:44.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi_vme.c	2014-03-19 23:34:45.000000000 +1100
@@ -42,6 +42,7 @@
 #include "initio.h"
 #include <scsi/scsi_host.h>
 #include "sun3_scsi.h"
+#include "NCR5380.h"
 
 extern int sun3_map_test(unsigned long, char *);
 
