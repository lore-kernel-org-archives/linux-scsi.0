From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 2/3] scsi/ncr5380: Avoid a compiler warning
Date: Sat, 27 Aug 2016 12:30:00 +1000
Message-ID: <20160827022959.211730285@telegraphics.com.au>
References: <20160827022958.983743612@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-warning-declared-inline-after-called
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

With commit 3a0f64bfa907 ("mac_scsi: Fix pseudo DMA implementation")
some versions of gcc now warn:

In file included from drivers/scsi/mac_scsi.c:335:
drivers/scsi/NCR5380.h:295: warning: `NCR5380_poll_politely' declared inline after being called
drivers/scsi/NCR5380.h:295: warning: previous declaration of `NCR5380_poll_politely' was here

Avoid this by defining NCR5380_poll_politely() in NCR5380.h.

Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c |    7 -------
 drivers/scsi/NCR5380.h |    8 +++++++-
 2 files changed, 7 insertions(+), 8 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-08-27 12:29:57.000000000 +1000
+++ linux/drivers/scsi/NCR5380.c	2016-08-27 12:29:57.000000000 +1000
@@ -230,13 +230,6 @@ static int NCR5380_poll_politely2(struct
 	return -ETIMEDOUT;
 }
 
-static inline int NCR5380_poll_politely(struct Scsi_Host *instance,
-                                        int reg, int bit, int val, int wait)
-{
-	return NCR5380_poll_politely2(instance, reg, bit, val,
-	                                        reg, bit, val, wait);
-}
-
 #if NDEBUG
 static struct {
 	unsigned char mask;
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2016-08-27 12:29:57.000000000 +1000
+++ linux/drivers/scsi/NCR5380.h	2016-08-27 12:29:57.000000000 +1000
@@ -292,8 +292,14 @@ static void NCR5380_reselect(struct Scsi
 static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *, struct scsi_cmnd *);
 static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
 static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
-static int NCR5380_poll_politely(struct Scsi_Host *, int, int, int, int);
 static int NCR5380_poll_politely2(struct Scsi_Host *, int, int, int, int, int, int, int);
 
+static inline int NCR5380_poll_politely(struct Scsi_Host *instance,
+                                        int reg, int bit, int val, int wait)
+{
+	return NCR5380_poll_politely2(instance, reg, bit, val,
+	                                        reg, bit, val, wait);
+}
+
 #endif				/* __KERNEL__ */
 #endif				/* NCR5380_H */
