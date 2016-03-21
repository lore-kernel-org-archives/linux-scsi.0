From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 06/23] ncr5380: Remove PSEUDO_DMA macro
Date: Mon, 21 Mar 2016 13:31:55 +1100
Message-ID: <20160321023151.233993317@telegraphics.com.au>
References: <20160321023149.604138431@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-remove-PSEUDO_DMA-macro
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

For those wrapper drivers which only implement Programmed IO, have
NCR5380_dma_xfer_len() evaluate to zero. That allows PDMA to be easily
disabled at run-time and so the PSEUDO_DMA macro is no longer needed.

Also remove the spin counters used for debugging pseudo DMA drivers.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c      |   32 +-------------------------------
 drivers/scsi/NCR5380.h      |    4 ----
 drivers/scsi/arm/cumana_1.c |    2 --
 drivers/scsi/arm/oak.c      |    3 +--
 drivers/scsi/dmx3191d.c     |    4 ++++
 drivers/scsi/dtc.c          |    7 -------
 drivers/scsi/dtc.h          |    2 --
 drivers/scsi/g_NCR5380.c    |    1 -
 drivers/scsi/g_NCR5380.h    |    1 -
 drivers/scsi/mac_scsi.c     |   10 ----------
 drivers/scsi/pas16.c        |   10 ----------
 drivers/scsi/pas16.h        |    2 --
 drivers/scsi/t128.c         |    4 ----
 drivers/scsi/t128.h         |    2 --
 14 files changed, 6 insertions(+), 78 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-03-21 13:31:14.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-03-21 13:31:16.000000000 +1100
@@ -469,34 +469,9 @@ static void prepare_info(struct Scsi_Hos
 #ifdef PARITY
 	         "PARITY "
 #endif
-#ifdef PSEUDO_DMA
-	         "PSEUDO_DMA "
-#endif
 	         "");
 }
 
-#ifdef PSEUDO_DMA
-static int __maybe_unused NCR5380_write_info(struct Scsi_Host *instance,
-	char *buffer, int length)
-{
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-
-	hostdata->spin_max_r = 0;
-	hostdata->spin_max_w = 0;
-	return 0;
-}
-
-static int __maybe_unused NCR5380_show_info(struct seq_file *m,
-                                            struct Scsi_Host *instance)
-{
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-
-	seq_printf(m, "Highwater I/O busy spin counts: write %d, read %d\n",
-	        hostdata->spin_max_w, hostdata->spin_max_r);
-	return 0;
-}
-#endif
-
 /**
  * NCR5380_init - initialise an NCR5380
  * @instance: adapter to configure
@@ -1436,7 +1411,6 @@ timeout:
 	return -1;
 }
 
-#if defined(PSEUDO_DMA)
 /*
  * Function : int NCR5380_transfer_dma (struct Scsi_Host *instance,
  * unsigned char *phase, int *count, unsigned char **data)
@@ -1592,7 +1566,6 @@ static int NCR5380_transfer_dma(struct S
 	*phase = NCR5380_read(STATUS_REG) & PHASE_MASK;
 	return foo;
 }
-#endif /* PSEUDO_DMA */
 
 /*
  * Function : NCR5380_information_transfer (struct Scsi_Host *instance)
@@ -1683,7 +1656,6 @@ static void NCR5380_information_transfer
 				 * in an unconditional loop.
 				 */
 
-#if defined(PSEUDO_DMA)
 				transfersize = 0;
 				if (!cmd->device->borken)
 					transfersize = NCR5380_dma_xfer_len(instance, cmd, phase);
@@ -1706,9 +1678,7 @@ static void NCR5380_information_transfer
 						/* XXX - need to source or sink data here, as appropriate */
 					} else
 						cmd->SCp.this_residual -= transfersize - len;
-				} else
-#endif /* PSEUDO_DMA */
-				{
+				} else {
 					/* Break up transfer into 3 ms chunks,
 					 * presuming 6 accesses per handshake.
 					 */
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2016-03-21 13:31:14.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2016-03-21 13:31:16.000000000 +1100
@@ -257,10 +257,6 @@ struct NCR5380_hostdata {
 #ifdef SUPPORT_TAGS
 	struct tag_alloc TagAlloc[8][8];	/* 8 targets and 8 LUNs */
 #endif
-#ifdef PSEUDO_DMA
-	unsigned spin_max_r;
-	unsigned spin_max_w;
-#endif
 	struct workqueue_struct *work_q;
 	unsigned long accesses_per_ms;	/* chip register accesses per ms */
 };
Index: linux/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux.orig/drivers/scsi/arm/cumana_1.c	2016-03-21 13:31:14.000000000 +1100
+++ linux/drivers/scsi/arm/cumana_1.c	2016-03-21 13:31:16.000000000 +1100
@@ -13,8 +13,6 @@
 
 #include <scsi/scsi_host.h>
 
-#define PSEUDO_DMA
-
 #define priv(host)			((struct NCR5380_hostdata *)(host)->hostdata)
 #define NCR5380_read(reg)		cumanascsi_read(instance, reg)
 #define NCR5380_write(reg, value)	cumanascsi_write(instance, reg, value)
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2016-03-21 13:31:14.000000000 +1100
+++ linux/drivers/scsi/arm/oak.c	2016-03-21 13:31:16.000000000 +1100
@@ -14,7 +14,6 @@
 
 #include <scsi/scsi_host.h>
 
-/*#define PSEUDO_DMA*/
 #define DONT_USE_INTR
 
 #define priv(host)			((struct NCR5380_hostdata *)(host)->hostdata)
@@ -24,7 +23,7 @@
 #define NCR5380_write(reg, value) \
 	writeb(value, priv(instance)->base + ((reg) << 2))
 
-#define NCR5380_dma_xfer_len(instance, cmd, phase)	(cmd->transfersize)
+#define NCR5380_dma_xfer_len(instance, cmd, phase)	(0)
 
 #define NCR5380_queue_command		oakscsi_queue_command
 #define NCR5380_info			oakscsi_info
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2016-03-21 13:31:14.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2016-03-21 13:31:16.000000000 +1100
@@ -1,4 +1,3 @@
-#define PSEUDO_DMA
 #define DONT_USE_INTR
 
 /*
@@ -352,8 +351,6 @@ static inline int NCR5380_pread(struct S
 	while (!(NCR5380_read(DTC_CONTROL_REG) & D_CR_ACCESS))
 		++i;
 	rtrc(0);
-	if (i > hostdata->spin_max_r)
-		hostdata->spin_max_r = i;
 	return (0);
 }
 
@@ -400,8 +397,6 @@ static inline int NCR5380_pwrite(struct
 	rtrc(7);
 	/* Check for parity error here. fixme. */
 	rtrc(0);
-	if (i > hostdata->spin_max_w)
-		hostdata->spin_max_w = i;
 	return (0);
 }
 
@@ -440,8 +435,6 @@ static struct scsi_host_template driver_
 	.detect			= dtc_detect,
 	.release		= dtc_release,
 	.proc_name		= "dtc3x80",
-	.show_info		= dtc_show_info,
-	.write_info		= dtc_write_info,
 	.info			= dtc_info,
 	.queuecommand		= dtc_queue_command,
 	.eh_abort_handler	= dtc_abort,
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-03-21 13:31:14.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-03-21 13:31:16.000000000 +1100
@@ -57,7 +57,6 @@
  */
 
 #define AUTOPROBE_IRQ
-#define PSEUDO_DMA
 
 #include <asm/io.h>
 #include <linux/blkdev.h>
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2016-03-21 13:31:09.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2016-03-21 13:31:16.000000000 +1100
@@ -28,8 +28,6 @@
 
 /* Definitions for the core NCR5380 driver. */
 
-#define PSEUDO_DMA
-
 #define NCR5380_implementation_fields   unsigned char *pdma_base
 
 #define NCR5380_read(reg)               macscsi_read(instance, reg)
@@ -46,8 +44,6 @@
 #define NCR5380_abort                   macscsi_abort
 #define NCR5380_bus_reset               macscsi_bus_reset
 #define NCR5380_info                    macscsi_info
-#define NCR5380_show_info               macscsi_show_info
-#define NCR5380_write_info              macscsi_write_info
 
 #include "NCR5380.h"
 
@@ -111,7 +107,6 @@ static int __init mac_scsi_setup(char *s
 __setup("mac5380=", mac_scsi_setup);
 #endif /* !MODULE */
 
-#ifdef PSEUDO_DMA
 /* 
    Pseudo-DMA: (Ove Edlund)
    The code attempts to catch bus errors that occur if one for example
@@ -303,7 +298,6 @@ static int macscsi_pwrite(struct Scsi_Ho
 
 	return 0;
 }
-#endif
 
 static int macscsi_dma_xfer_len(struct Scsi_Host *instance,
                                 struct scsi_cmnd *cmd)
@@ -324,8 +318,6 @@ static int macscsi_dma_xfer_len(struct S
 static struct scsi_host_template mac_scsi_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= DRV_MODULE_NAME,
-	.show_info		= macscsi_show_info,
-	.write_info		= macscsi_write_info,
 	.name			= "Macintosh NCR5380 SCSI",
 	.info			= macscsi_info,
 	.queuecommand		= macscsi_queue_command,
@@ -351,9 +343,7 @@ static int __init mac_scsi_probe(struct
 	if (!pio_mem)
 		return -ENODEV;
 
-#ifdef PSEUDO_DMA
 	pdma_mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-#endif
 
 	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2016-03-21 13:31:14.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2016-03-21 13:31:16.000000000 +1100
@@ -1,5 +1,3 @@
-#define PSEUDO_DMA
-
 /*
  * This driver adapted from Drew Eckhardt's Trantor T128 driver
  *
@@ -479,7 +477,6 @@ static inline int NCR5380_pread (struct
 	P_DATA_REG_OFFSET);
     register int i = len;
     int ii = 0;
-    struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
     while ( !(inb(instance->io_port + P_STATUS_REG_OFFSET) & P_ST_RDY) )
 	 ++ii;
@@ -492,8 +489,6 @@ static inline int NCR5380_pread (struct
 	    instance->host_no);
 	return -1;
     }
-    if (ii > hostdata->spin_max_r)
-        hostdata->spin_max_r = ii;
     return 0;
 }
 
@@ -516,7 +511,6 @@ static inline int NCR5380_pwrite (struct
     register unsigned short reg = (instance->io_port + P_DATA_REG_OFFSET);
     register int i = len;
     int ii = 0;
-    struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
     while ( !((inb(instance->io_port + P_STATUS_REG_OFFSET)) & P_ST_RDY) )
 	 ++ii;
@@ -529,8 +523,6 @@ static inline int NCR5380_pwrite (struct
 	    instance->host_no);
 	return -1;
     }
-    if (ii > hostdata->spin_max_w)
-        hostdata->spin_max_w = ii;
     return 0;
 }
 
@@ -550,8 +542,6 @@ static struct scsi_host_template driver_
 	.detect			= pas16_detect,
 	.release		= pas16_release,
 	.proc_name		= "pas16",
-	.show_info		= pas16_show_info,
-	.write_info		= pas16_write_info,
 	.info			= pas16_info,
 	.queuecommand		= pas16_queue_command,
 	.eh_abort_handler	= pas16_abort,
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2016-03-21 13:31:14.000000000 +1100
+++ linux/drivers/scsi/t128.c	2016-03-21 13:31:16.000000000 +1100
@@ -1,5 +1,3 @@
-#define PSEUDO_DMA
-
 /*
  * Trantor T128/T128F/T228 driver
  *	Note : architecturally, the T100 and T130 are different and won't 
@@ -394,8 +392,6 @@ static struct scsi_host_template driver_
 	.detect			= t128_detect,
 	.release		= t128_release,
 	.proc_name		= "t128",
-	.show_info		= t128_show_info,
-	.write_info		= t128_write_info,
 	.info			= t128_info,
 	.queuecommand		= t128_queue_command,
 	.eh_abort_handler	= t128_abort,
Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2016-03-21 13:31:09.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2016-03-21 13:31:16.000000000 +1100
@@ -39,6 +39,10 @@
 #define NCR5380_read(reg)		inb(instance->io_port + reg)
 #define NCR5380_write(reg, value)	outb(value, instance->io_port + reg)
 
+#define NCR5380_dma_xfer_len(instance, cmd, phase)	(0)
+#define NCR5380_pread(instance, dst, len)		(0)
+#define NCR5380_pwrite(instance, src, len)		(0)
+
 #define NCR5380_implementation_fields	/* none */
 
 #include "NCR5380.h"
Index: linux/drivers/scsi/dtc.h
===================================================================
--- linux.orig/drivers/scsi/dtc.h	2016-03-21 13:31:07.000000000 +1100
+++ linux/drivers/scsi/dtc.h	2016-03-21 13:31:16.000000000 +1100
@@ -27,8 +27,6 @@
 #define NCR5380_abort			dtc_abort
 #define NCR5380_bus_reset		dtc_bus_reset
 #define NCR5380_info			dtc_info
-#define NCR5380_show_info		dtc_show_info 
-#define NCR5380_write_info		dtc_write_info 
 
 /* 15 12 11 10
    1001 1100 0000 0000 */
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2016-03-21 13:31:09.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.h	2016-03-21 13:31:16.000000000 +1100
@@ -70,7 +70,6 @@
 #define NCR5380_pread generic_NCR5380_pread
 #define NCR5380_pwrite generic_NCR5380_pwrite
 #define NCR5380_info generic_NCR5380_info
-#define NCR5380_show_info generic_NCR5380_show_info
 
 #define BOARD_NCR5380	0
 #define BOARD_NCR53C400	1
Index: linux/drivers/scsi/pas16.h
===================================================================
--- linux.orig/drivers/scsi/pas16.h	2016-03-21 13:31:07.000000000 +1100
+++ linux/drivers/scsi/pas16.h	2016-03-21 13:31:16.000000000 +1100
@@ -109,8 +109,6 @@
 #define NCR5380_abort pas16_abort
 #define NCR5380_bus_reset pas16_bus_reset
 #define NCR5380_info pas16_info
-#define NCR5380_show_info pas16_show_info
-#define NCR5380_write_info pas16_write_info
 
 /* 15 14 12 10 7 5 3 
    1101 0100 1010 1000 */
Index: linux/drivers/scsi/t128.h
===================================================================
--- linux.orig/drivers/scsi/t128.h	2016-03-21 13:31:07.000000000 +1100
+++ linux/drivers/scsi/t128.h	2016-03-21 13:31:16.000000000 +1100
@@ -83,8 +83,6 @@
 #define NCR5380_abort t128_abort
 #define NCR5380_bus_reset t128_bus_reset
 #define NCR5380_info t128_info
-#define NCR5380_show_info t128_show_info
-#define NCR5380_write_info t128_write_info
 
 /* 15 14 12 10 7 5 3
    1101 0100 1010 1000 */
