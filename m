From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 07/23] ncr5380: Remove BOARD_REQUIRES_NO_DELAY macro
Date: Wed, 23 Mar 2016 21:10:16 +1100
Message-ID: <20160323101011.131720642@telegraphics.com.au>
References: <20160323101009.341929635@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-io_recovery_delay
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

The io_recovery_delay macro is intended to insert a microsecond delay
between the chip register accesses that begin a DMA operation. This
is reportedly needed for some ISA boards.

Reverse the sense of the macro test so that in the common case,
where no delay is required, drivers need not define the macro.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>

---
 drivers/scsi/NCR5380.c   |   18 ++++++++----------
 drivers/scsi/dtc.h       |    2 ++
 drivers/scsi/g_NCR5380.h |    2 ++
 drivers/scsi/t128.h      |    2 ++
 4 files changed, 14 insertions(+), 10 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-03-23 21:09:28.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-03-23 21:09:34.000000000 +1100
@@ -39,12 +39,6 @@
  * tagged queueing)
  */
 
-#ifdef BOARD_REQUIRES_NO_DELAY
-#define io_recovery_delay(x)
-#else
-#define io_recovery_delay(x)	udelay(x)
-#endif
-
 /*
  * Design
  *
@@ -150,6 +144,10 @@
  * possible) function may be used.
  */
 
+#ifndef NCR5380_io_delay
+#define NCR5380_io_delay(x)
+#endif
+
 static int do_abort(struct Scsi_Host *);
 static void do_reset(struct Scsi_Host *);
 
@@ -1468,14 +1466,14 @@ static int NCR5380_transfer_dma(struct S
 	 */
 
 	if (p & SR_IO) {
-		io_recovery_delay(1);
+		NCR5380_io_delay(1);
 		NCR5380_write(START_DMA_INITIATOR_RECEIVE_REG, 0);
 	} else {
-		io_recovery_delay(1);
+		NCR5380_io_delay(1);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_DATA);
-		io_recovery_delay(1);
+		NCR5380_io_delay(1);
 		NCR5380_write(START_DMA_SEND_REG, 0);
-		io_recovery_delay(1);
+		NCR5380_io_delay(1);
 	}
 
 /*
Index: linux/drivers/scsi/dtc.h
===================================================================
--- linux.orig/drivers/scsi/dtc.h	2016-03-23 21:09:28.000000000 +1100
+++ linux/drivers/scsi/dtc.h	2016-03-23 21:09:34.000000000 +1100
@@ -28,6 +28,8 @@
 #define NCR5380_bus_reset		dtc_bus_reset
 #define NCR5380_info			dtc_info
 
+#define NCR5380_io_delay(x)		udelay(x)
+
 /* 15 12 11 10
    1001 1100 0000 0000 */
 
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2016-03-23 21:09:28.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.h	2016-03-23 21:09:34.000000000 +1100
@@ -71,6 +71,8 @@
 #define NCR5380_pwrite generic_NCR5380_pwrite
 #define NCR5380_info generic_NCR5380_info
 
+#define NCR5380_io_delay(x)		udelay(x)
+
 #define BOARD_NCR5380	0
 #define BOARD_NCR53C400	1
 #define BOARD_NCR53C400A 2
Index: linux/drivers/scsi/t128.h
===================================================================
--- linux.orig/drivers/scsi/t128.h	2016-03-23 21:09:28.000000000 +1100
+++ linux/drivers/scsi/t128.h	2016-03-23 21:09:34.000000000 +1100
@@ -84,6 +84,8 @@
 #define NCR5380_bus_reset t128_bus_reset
 #define NCR5380_info t128_info
 
+#define NCR5380_io_delay(x)		udelay(x)
+
 /* 15 14 12 10 7 5 3
    1101 0100 1010 1000 */
 
