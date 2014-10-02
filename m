From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 13/29] ncr5380: Move static PDMA spin counters to host data
Date: Thu, 02 Oct 2014 16:56:41 +1000
Message-ID: <20141002065631.386186286@telegraphics.com.au>
References: <20141002065628.256592712@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-move-pdma-spin-counters
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Static variables from dtc.c and pas16.c should not appear in the core
NCR5380.c driver. Aside from being a layering issue this worsens the
divergence between the three core driver variants (atari_NCR5380.c and
sun3_NCR5380.c don't support PSEUDO_DMA) and it can mean multiple hosts
share the same counters.

Fix this by making the pseudo DMA spin counters in the core more generic.
This also avoids the abuse of the {DTC,PAS16}_PUBLIC_RELEASE macros, so
they can be removed.

oak.c doesn't use PDMA and hence it doesn't use the counters and hence it
needs no write_info() method. Remove it.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c |   22 ++++++++++------------
 drivers/scsi/NCR5380.h |    4 ++++
 drivers/scsi/arm/oak.c |    2 --
 drivers/scsi/dtc.c     |   13 ++++++-------
 drivers/scsi/pas16.c   |   12 ++++++------
 5 files changed, 26 insertions(+), 27 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2014-10-02 16:56:05.000000000 +1000
+++ linux/drivers/scsi/NCR5380.c	2014-10-02 16:56:09.000000000 +1000
@@ -693,6 +693,7 @@ static void NCR5380_print_status(struct
 	NCR5380_dprint_phase(NDEBUG_ANY, instance);
 }
 
+#ifdef PSEUDO_DMA
 /******************************************/
 /*
  * /proc/scsi/[dtc pas16 t128 generic]/[0-ASC_NUM_BOARD_SUPPORTED]
@@ -710,14 +711,13 @@ static void NCR5380_print_status(struct
 static int __maybe_unused NCR5380_write_info(struct Scsi_Host *instance,
 	char *buffer, int length)
 {
-#ifdef DTC_PUBLIC_RELEASE
-	dtc_wmaxi = dtc_maxi = 0;
-#endif
-#ifdef PAS16_PUBLIC_RELEASE
-	pas_wmaxi = pas_maxi = 0;
-#endif
-	return (-ENOSYS);	/* Currently this is a no-op */
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+
+	hostdata->spin_max_r = 0;
+	hostdata->spin_max_w = 0;
+	return 0;
 }
+#endif
 
 #undef SPRINTF
 #define SPRINTF(args...) seq_printf(m, ## args)
@@ -752,11 +752,9 @@ static int __maybe_unused NCR5380_show_i
 	SPRINTF("PAS16 release=%d", PAS16_PUBLIC_RELEASE);
 #endif
 
-#ifdef DTC_PUBLIC_RELEASE
-	SPRINTF("Highwater I/O busy_spin_counts -- write: %d  read: %d\n", dtc_wmaxi, dtc_maxi);
-#endif
-#ifdef PAS16_PUBLIC_RELEASE
-	SPRINTF("Highwater I/O busy_spin_counts -- write: %d  read: %d\n", pas_wmaxi, pas_maxi);
+#ifdef PSEUDO_DMA
+	SPRINTF("Highwater I/O busy spin counts: write %d, read %d\n",
+	        hostdata->spin_max_w, hostdata->spin_max_r);
 #endif
 	spin_lock_irq(instance->host_lock);
 	if (!hostdata->connected)
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2014-10-02 16:56:05.000000000 +1000
+++ linux/drivers/scsi/NCR5380.h	2014-10-02 16:56:09.000000000 +1000
@@ -270,6 +270,10 @@ struct NCR5380_hostdata {
 	struct delayed_work coroutine;		/* our co-routine */
 	struct scsi_eh_save ses;
 	char info[256];
+#ifdef PSEUDO_DMA
+	unsigned spin_max_r;
+	unsigned spin_max_w;
+#endif
 };
 
 #ifdef __KERNEL__
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2014-10-02 16:56:05.000000000 +1000
+++ linux/drivers/scsi/dtc.c	2014-10-02 16:56:09.000000000 +1000
@@ -332,13 +332,11 @@ static int dtc_biosparam(struct scsi_dev
  * 	timeout.
 */
 
-static int dtc_maxi = 0;
-static int dtc_wmaxi = 0;
-
 static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst, int len)
 {
 	unsigned char *d = dst;
 	int i;			/* For counting time spent in the poll-loop */
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	NCR5380_local_declare();
 	NCR5380_setup(instance);
 
@@ -369,8 +367,8 @@ static inline int NCR5380_pread(struct S
 	NCR5380_write(MODE_REG, 0);	/* Clear the operating mode */
 	rtrc(0);
 	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-	if (i > dtc_maxi)
-		dtc_maxi = i;
+	if (i > hostdata->spin_max_r)
+		hostdata->spin_max_r = i;
 	return (0);
 }
 
@@ -390,6 +388,7 @@ static inline int NCR5380_pread(struct S
 static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src, int len)
 {
 	int i;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	NCR5380_local_declare();
 	NCR5380_setup(instance);
 
@@ -422,8 +421,8 @@ static inline int NCR5380_pwrite(struct
 	/* Check for parity error here. fixme. */
 	NCR5380_write(MODE_REG, 0);	/* Clear the operating mode */
 	rtrc(0);
-	if (i > dtc_wmaxi)
-		dtc_wmaxi = i;
+	if (i > hostdata->spin_max_w)
+		hostdata->spin_max_w = i;
 	return (0);
 }
 
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2014-10-02 16:56:05.000000000 +1000
+++ linux/drivers/scsi/pas16.c	2014-10-02 16:56:09.000000000 +1000
@@ -88,8 +88,6 @@
 #include "NCR5380.h"
 
 
-static int pas_maxi = 0;
-static int pas_wmaxi = 0;
 static unsigned short pas16_addr = 0;
 static int pas16_irq = 0;
  
@@ -502,6 +500,7 @@ static inline int NCR5380_pread (struct
 	P_DATA_REG_OFFSET);
     register int i = len;
     int ii = 0;
+    struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
     while ( !(inb(instance->io_port + P_STATUS_REG_OFFSET) & P_ST_RDY) )
 	 ++ii;
@@ -514,8 +513,8 @@ static inline int NCR5380_pread (struct
 	    instance->host_no);
 	return -1;
     }
-   if (ii > pas_maxi)
-      pas_maxi = ii;
+    if (ii > hostdata->spin_max_r)
+        hostdata->spin_max_r = ii;
     return 0;
 }
 
@@ -538,6 +537,7 @@ static inline int NCR5380_pwrite (struct
     register unsigned short reg = (instance->io_port + P_DATA_REG_OFFSET);
     register int i = len;
     int ii = 0;
+    struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
     while ( !((inb(instance->io_port + P_STATUS_REG_OFFSET)) & P_ST_RDY) )
 	 ++ii;
@@ -550,8 +550,8 @@ static inline int NCR5380_pwrite (struct
 	    instance->host_no);
 	return -1;
     }
-    if (ii > pas_maxi)
-	 pas_wmaxi = ii;
+    if (ii > hostdata->spin_max_w)
+        hostdata->spin_max_w = ii;
     return 0;
 }
 
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2014-10-02 16:56:05.000000000 +1000
+++ linux/drivers/scsi/arm/oak.c	2014-10-02 16:56:09.000000000 +1000
@@ -31,7 +31,6 @@
 #define NCR5380_queue_command		oakscsi_queue_command
 #define NCR5380_info			oakscsi_info
 #define NCR5380_show_info		oakscsi_show_info
-#define NCR5380_write_info		oakscsi_write_info
 
 #define NCR5380_implementation_fields	\
 	void __iomem *base
@@ -108,7 +107,6 @@ printk("reading %p len %d\n", addr, len)
 static struct scsi_host_template oakscsi_template = {
 	.module			= THIS_MODULE,
 	.show_info		= oakscsi_show_info,
-	.write_info		= oakscsi_write_info,
 	.name			= "Oak 16-bit SCSI",
 	.info			= oakscsi_info,
 	.queuecommand		= oakscsi_queue_command,
