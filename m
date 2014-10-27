From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 20/36] mac_scsi: Cleanup PDMA code
Date: Mon, 27 Oct 2014 16:26:27 +1100
Message-ID: <20141027052611.955142205@telegraphics.com.au>
References: <20141027052607.105914311@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=mac_scsi-pdma-cleanup
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fix whitespace, remove pointless volatile qualifiers and improve code style
by use of INPUT_DATA_REG and OUTPUT_DATA_REG macros.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/mac_scsi.c |  122 ++++++++++++++++++++++++------------------------
 1 file changed, 62 insertions(+), 60 deletions(-)

Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2014-10-27 16:25:42.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2014-10-27 16:25:43.000000000 +1100
@@ -86,9 +86,9 @@ module_param(setup_hostid, int, 0);
 #define	AFTER_RESET_DELAY	(HZ/2)
 #endif
 
-static volatile unsigned char *mac_scsi_regp = NULL;
-static volatile unsigned char *mac_scsi_drq  = NULL;
-static volatile unsigned char *mac_scsi_nodrq = NULL;
+static unsigned char *mac_scsi_regp;
+static unsigned char *mac_scsi_drq;
+static unsigned char *mac_scsi_nodrq;
 
 
 /*
@@ -262,6 +262,7 @@ static void mac_scsi_reset_boot(struct S
 }
 #endif
 
+#ifdef PSEUDO_DMA
 /* 
    Pseudo-DMA: (Ove Edlund)
    The code attempts to catch bus errors that occur if one for example
@@ -331,38 +332,38 @@ __asm__ __volatile__					\
      : "0"(s), "1"(d), "2"(len)				\
      : "d0")
 
-
-static int macscsi_pread (struct Scsi_Host *instance,
-			  unsigned char *dst, int len)
+static int macscsi_pread(struct Scsi_Host *instance,
+                         unsigned char *dst, int len)
 {
-   unsigned char *d;
-   volatile unsigned char *s;
+	unsigned char *d;
+	unsigned char *s;
+
+	NCR5380_local_declare();
+	NCR5380_setup(instance);
+
+	s = mac_scsi_drq + (INPUT_DATA_REG << 4);
+	d = dst;
 
-   NCR5380_local_declare();
-   NCR5380_setup(instance);
+	/* These conditions are derived from MacOS */
 
-   s = mac_scsi_drq+0x60;
-   d = dst;
+	while (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ) &&
+	       !(NCR5380_read(STATUS_REG) & SR_REQ))
+		;
+
+	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ) &&
+	    (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH)) {
+		pr_err("Error in macscsi_pread\n");
+		return -1;
+	}
 
-/* These conditions are derived from MacOS */
-
-   while (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ) 
-         && !(NCR5380_read(STATUS_REG) & SR_REQ))
-      ;
-   if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ) 
-         && (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH)) {
-      printk(KERN_ERR "Error in macscsi_pread\n");
-      return -1;
-   }
-
-   CP_IO_TO_MEM(s, d, len);
-   
-   if (len != 0) {
-      printk(KERN_NOTICE "Bus error in macscsi_pread\n");
-      return -1;
-   }
-   
-   return 0;
+	CP_IO_TO_MEM(s, d, len);
+
+	if (len != 0) {
+		pr_notice("Bus error in macscsi_pread\n");
+		return -1;
+	}
+
+	return 0;
 }
 
 
@@ -424,39 +425,40 @@ __asm__ __volatile__					\
      : "0"(s), "1"(d), "2"(len)				\
      : "d0")
 
-static int macscsi_pwrite (struct Scsi_Host *instance,
-				  unsigned char *src, int len)
+static int macscsi_pwrite(struct Scsi_Host *instance,
+                          unsigned char *src, int len)
 {
-   unsigned char *s;
-   volatile unsigned char *d;
+	unsigned char *s;
+	unsigned char *d;
+
+	NCR5380_local_declare();
+	NCR5380_setup(instance);
 
-   NCR5380_local_declare();
-   NCR5380_setup(instance);
+	s = src;
+	d = mac_scsi_drq + (OUTPUT_DATA_REG << 4);
 
-   s = src;
-   d = mac_scsi_drq;
-   
-/* These conditions are derived from MacOS */
-
-   while (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ) 
-         && (!(NCR5380_read(STATUS_REG) & SR_REQ) 
-            || (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))) 
-      ;
-   if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ)) {
-      printk(KERN_ERR "Error in macscsi_pwrite\n");
-      return -1;
-   }
-
-   CP_MEM_TO_IO(s, d, len);   
-
-   if (len != 0) {
-      printk(KERN_NOTICE "Bus error in macscsi_pwrite\n");
-      return -1;
-   }
-   
-   return 0;
-}
+	/* These conditions are derived from MacOS */
+
+	while (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ) &&
+	       (!(NCR5380_read(STATUS_REG) & SR_REQ) ||
+	        (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH)))
+		;
+
+	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ)) {
+		pr_err("Error in macscsi_pwrite\n");
+		return -1;
+	}
+
+	CP_MEM_TO_IO(s, d, len);
 
+	if (len != 0) {
+		pr_notice("Bus error in macscsi_pwrite\n");
+		return -1;
+	}
+
+	return 0;
+}
+#endif
 
 #include "NCR5380.c"
 
