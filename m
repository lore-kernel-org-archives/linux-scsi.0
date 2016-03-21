From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 08/23] ncr5380: Use DMA hooks for PDMA
Date: Mon, 21 Mar 2016 13:31:57 +1100
Message-ID: <20160321023151.743984915@telegraphics.com.au>
References: <20160321023149.604138431@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline; filename=ncr5380-rename-pread-and-pwrite
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Sam Creasey <sammy@sammy.net>, Ondrej Zary <linux@rainbow-software.org>
List-Id: linux-scsi@vger.kernel.org

Those wrapper drivers which use DMA define the REAL_DMA macro and
those which use pseudo DMA define PSEUDO_DMA. These macros need to be
removed for a number of reasons, not least of which is to have drivers
share more code.

Redefine the PDMA send and receive hooks as DMA setup hooks, so that the
DMA code can be shared by all 5380 wrapper drivers. This will help to
reunify the forked core driver.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c      |   10 ++--------
 drivers/scsi/arm/cumana_1.c |   10 ++++++----
 drivers/scsi/arm/oak.c      |   10 ++++++----
 drivers/scsi/dmx3191d.c     |    4 ++--
 drivers/scsi/dtc.c          |    6 ++++--
 drivers/scsi/dtc.h          |    2 ++
 drivers/scsi/g_NCR5380.c    |   10 ++++++----
 drivers/scsi/g_NCR5380.h    |    4 ++--
 drivers/scsi/mac_scsi.c     |    5 ++---
 drivers/scsi/pas16.c        |   14 ++++++++------
 drivers/scsi/pas16.h        |    2 ++
 drivers/scsi/t128.c         |   12 ++++++------
 drivers/scsi/t128.h         |    2 ++
 13 files changed, 50 insertions(+), 41 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-03-21 13:31:20.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-03-21 13:31:21.000000000 +1100
@@ -127,17 +127,11 @@
  * specific implementation of the NCR5380
  *
  * Either real DMA *or* pseudo DMA may be implemented
- * Note that the DMA setup functions should return the number of bytes
- * that they were able to program the controller for.
  *
  * NCR5380_dma_write_setup(instance, src, count) - initialize
  * NCR5380_dma_read_setup(instance, dst, count) - initialize
  * NCR5380_dma_residual(instance); - residual count
  *
- * PSEUDO functions :
- * NCR5380_pwrite(instance, src, count)
- * NCR5380_pread(instance, dst, count);
- *
  * The generic driver is initialized by calling NCR5380_init(instance),
  * after setting the appropriate host specific fields and ID.  If the
  * driver wishes to autoprobe for an IRQ line, the NCR5380_probe_irq(instance,
@@ -1511,7 +1505,7 @@ static int NCR5380_transfer_dma(struct S
  */
 
 	if (p & SR_IO) {
-		foo = NCR5380_pread(instance, d,
+		foo = NCR5380_dma_recv_setup(instance, d,
 			hostdata->flags & FLAG_DMA_FIXUP ? c - 1 : c);
 		if (!foo && (hostdata->flags & FLAG_DMA_FIXUP)) {
 			/*
@@ -1542,7 +1536,7 @@ static int NCR5380_transfer_dma(struct S
 			d[c - 1] = NCR5380_read(INPUT_DATA_REG);
 		}
 	} else {
-		foo = NCR5380_pwrite(instance, d, c);
+		foo = NCR5380_dma_send_setup(instance, d, c);
 		if (!foo && (hostdata->flags & FLAG_DMA_FIXUP)) {
 			/*
 			 * Wait for the last byte to be sent.  If REQ is being asserted for
Index: linux/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux.orig/drivers/scsi/arm/cumana_1.c	2016-03-21 13:31:16.000000000 +1100
+++ linux/drivers/scsi/arm/cumana_1.c	2016-03-21 13:31:21.000000000 +1100
@@ -18,6 +18,8 @@
 #define NCR5380_write(reg, value)	cumanascsi_write(instance, reg, value)
 
 #define NCR5380_dma_xfer_len(instance, cmd, phase)	(cmd->transfersize)
+#define NCR5380_dma_recv_setup		cumanascsi_pread
+#define NCR5380_dma_send_setup		cumanascsi_pwrite
 
 #define NCR5380_intr			cumanascsi_intr
 #define NCR5380_queue_command		cumanascsi_queue_command
@@ -39,8 +41,8 @@ void cumanascsi_setup(char *str, int *in
 #define L(v)	(((v)<<16)|((v) & 0x0000ffff))
 #define H(v)	(((v)>>16)|((v) & 0xffff0000))
 
-static inline int
-NCR5380_pwrite(struct Scsi_Host *host, unsigned char *addr, int len)
+static inline int cumanascsi_pwrite(struct Scsi_Host *host,
+                                    unsigned char *addr, int len)
 {
   unsigned long *laddr;
   void __iomem *dma = priv(host)->dma + 0x2000;
@@ -102,8 +104,8 @@ end:
   return len;
 }
 
-static inline int
-NCR5380_pread(struct Scsi_Host *host, unsigned char *addr, int len)
+static inline int cumanascsi_pread(struct Scsi_Host *host,
+                                   unsigned char *addr, int len)
 {
   unsigned long *laddr;
   void __iomem *dma = priv(host)->dma + 0x2000;
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2016-03-21 13:31:16.000000000 +1100
+++ linux/drivers/scsi/arm/oak.c	2016-03-21 13:31:21.000000000 +1100
@@ -24,6 +24,8 @@
 	writeb(value, priv(instance)->base + ((reg) << 2))
 
 #define NCR5380_dma_xfer_len(instance, cmd, phase)	(0)
+#define NCR5380_dma_recv_setup		oakscsi_pread
+#define NCR5380_dma_send_setup		oakscsi_pwrite
 
 #define NCR5380_queue_command		oakscsi_queue_command
 #define NCR5380_info			oakscsi_info
@@ -39,8 +41,8 @@
 #define STAT	((128 + 16) << 2)
 #define DATA	((128 + 8) << 2)
 
-static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *addr,
-              int len)
+static inline int oakscsi_pwrite(struct Scsi_Host *instance,
+                                 unsigned char *addr, int len)
 {
   void __iomem *base = priv(instance)->base;
 
@@ -54,8 +56,8 @@ printk("writing %p len %d\n",addr, len);
   }
 }
 
-static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *addr,
-              int len)
+static inline int oakscsi_pread(struct Scsi_Host *instance,
+                                unsigned char *addr, int len)
 {
   void __iomem *base = priv(instance)->base;
 printk("reading %p len %d\n", addr, len);
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2016-03-21 13:31:16.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2016-03-21 13:31:21.000000000 +1100
@@ -322,7 +322,8 @@ static int dtc_biosparam(struct scsi_dev
  * 	timeout.
 */
 
-static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst, int len)
+static inline int dtc_pread(struct Scsi_Host *instance,
+                            unsigned char *dst, int len)
 {
 	unsigned char *d = dst;
 	int i;			/* For counting time spent in the poll-loop */
@@ -367,7 +368,8 @@ static inline int NCR5380_pread(struct S
  * 	timeout.
 */
 
-static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src, int len)
+static inline int dtc_pwrite(struct Scsi_Host *instance,
+                             unsigned char *src, int len)
 {
 	int i;
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
Index: linux/drivers/scsi/dtc.h
===================================================================
--- linux.orig/drivers/scsi/dtc.h	2016-03-21 13:31:20.000000000 +1100
+++ linux/drivers/scsi/dtc.h	2016-03-21 13:31:21.000000000 +1100
@@ -21,6 +21,8 @@
 
 #define NCR5380_dma_xfer_len(instance, cmd, phase) \
         dtc_dma_xfer_len(cmd)
+#define NCR5380_dma_recv_setup		dtc_pread
+#define NCR5380_dma_send_setup		dtc_pwrite
 
 #define NCR5380_intr			dtc_intr
 #define NCR5380_queue_command		dtc_queue_command
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-03-21 13:31:16.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-03-21 13:31:21.000000000 +1100
@@ -551,7 +551,7 @@ static int generic_NCR5380_release_resou
 }
 
 /**
- *	NCR5380_pread		-	pseudo DMA read
+ *	generic_NCR5380_pread - pseudo DMA read
  *	@instance: adapter to read from
  *	@dst: buffer to read into
  *	@len: buffer length
@@ -560,7 +560,8 @@ static int generic_NCR5380_release_resou
  *	controller
  */
  
-static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst, int len)
+static inline int generic_NCR5380_pread(struct Scsi_Host *instance,
+                                        unsigned char *dst, int len)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int blocks = len / 128;
@@ -628,7 +629,7 @@ static inline int NCR5380_pread(struct S
 }
 
 /**
- *	NCR5380_write		-	pseudo DMA write
+ *	generic_NCR5380_pwrite - pseudo DMA write
  *	@instance: adapter to read from
  *	@dst: buffer to read into
  *	@len: buffer length
@@ -637,7 +638,8 @@ static inline int NCR5380_pread(struct S
  *	controller
  */
 
-static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src, int len)
+static inline int generic_NCR5380_pwrite(struct Scsi_Host *instance,
+                                         unsigned char *src, int len)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int blocks = len / 128;
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2016-03-21 13:31:20.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.h	2016-03-21 13:31:21.000000000 +1100
@@ -62,13 +62,13 @@
 
 #define NCR5380_dma_xfer_len(instance, cmd, phase) \
         generic_NCR5380_dma_xfer_len(instance, cmd)
+#define NCR5380_dma_recv_setup		generic_NCR5380_pread
+#define NCR5380_dma_send_setup		generic_NCR5380_pwrite
 
 #define NCR5380_intr generic_NCR5380_intr
 #define NCR5380_queue_command generic_NCR5380_queue_command
 #define NCR5380_abort generic_NCR5380_abort
 #define NCR5380_bus_reset generic_NCR5380_bus_reset
-#define NCR5380_pread generic_NCR5380_pread
-#define NCR5380_pwrite generic_NCR5380_pwrite
 #define NCR5380_info generic_NCR5380_info
 
 #define NCR5380_io_delay(x)		udelay(x)
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2016-03-21 13:31:16.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2016-03-21 13:31:21.000000000 +1100
@@ -33,11 +33,10 @@
 #define NCR5380_read(reg)               macscsi_read(instance, reg)
 #define NCR5380_write(reg, value)       macscsi_write(instance, reg, value)
 
-#define NCR5380_pread                   macscsi_pread
-#define NCR5380_pwrite                  macscsi_pwrite
-
 #define NCR5380_dma_xfer_len(instance, cmd, phase) \
         macscsi_dma_xfer_len(instance, cmd)
+#define NCR5380_dma_recv_setup          macscsi_pread
+#define NCR5380_dma_send_setup          macscsi_pwrite
 
 #define NCR5380_intr                    macscsi_intr
 #define NCR5380_queue_command           macscsi_queue_command
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2016-03-21 13:31:16.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2016-03-21 13:31:21.000000000 +1100
@@ -458,7 +458,7 @@ static int pas16_biosparam(struct scsi_d
 }
 
 /*
- * Function : int NCR5380_pread (struct Scsi_Host *instance, 
+ * Function : int pas16_pread (struct Scsi_Host *instance,
  *	unsigned char *dst, int len)
  *
  * Purpose : Fast 5380 pseudo-dma read function, transfers len bytes to 
@@ -470,8 +470,9 @@ static int pas16_biosparam(struct scsi_d
  * 	timeout.
  */
 
-static inline int NCR5380_pread (struct Scsi_Host *instance, unsigned char *dst,
-    int len) {
+static inline int pas16_pread(struct Scsi_Host *instance,
+                              unsigned char *dst, int len)
+{
     register unsigned char  *d = dst;
     register unsigned short reg = (unsigned short) (instance->io_port + 
 	P_DATA_REG_OFFSET);
@@ -493,7 +494,7 @@ static inline int NCR5380_pread (struct
 }
 
 /*
- * Function : int NCR5380_pwrite (struct Scsi_Host *instance, 
+ * Function : int pas16_pwrite (struct Scsi_Host *instance,
  *	unsigned char *src, int len)
  *
  * Purpose : Fast 5380 pseudo-dma write function, transfers len bytes from
@@ -505,8 +506,9 @@ static inline int NCR5380_pread (struct
  * 	timeout.
  */
 
-static inline int NCR5380_pwrite (struct Scsi_Host *instance, unsigned char *src,
-    int len) {
+static inline int pas16_pwrite(struct Scsi_Host *instance,
+                               unsigned char *src, int len)
+{
     register unsigned char *s = src;
     register unsigned short reg = (instance->io_port + P_DATA_REG_OFFSET);
     register int i = len;
Index: linux/drivers/scsi/pas16.h
===================================================================
--- linux.orig/drivers/scsi/pas16.h	2016-03-21 13:31:16.000000000 +1100
+++ linux/drivers/scsi/pas16.h	2016-03-21 13:31:21.000000000 +1100
@@ -103,6 +103,8 @@
 #define NCR5380_write(reg, value) ( outb((value),PAS16_io_port(reg)) )
 
 #define NCR5380_dma_xfer_len(instance, cmd, phase)	(cmd->transfersize)
+#define NCR5380_dma_recv_setup		pas16_pread
+#define NCR5380_dma_send_setup		pas16_pwrite
 
 #define NCR5380_intr pas16_intr
 #define NCR5380_queue_command pas16_queue_command
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2016-03-21 13:31:16.000000000 +1100
+++ linux/drivers/scsi/t128.c	2016-03-21 13:31:21.000000000 +1100
@@ -292,7 +292,7 @@ static int t128_biosparam(struct scsi_de
 }
 
 /*
- * Function : int NCR5380_pread (struct Scsi_Host *instance, 
+ * Function : int t128_pread (struct Scsi_Host *instance,
  *	unsigned char *dst, int len)
  *
  * Purpose : Fast 5380 pseudo-dma read function, transfers len bytes to 
@@ -304,8 +304,8 @@ static int t128_biosparam(struct scsi_de
  * 	timeout.
  */
 
-static inline int
-NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst, int len)
+static inline int t128_pread(struct Scsi_Host *instance,
+                             unsigned char *dst, int len)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	void __iomem *reg, *base = hostdata->base;
@@ -338,7 +338,7 @@ NCR5380_pread(struct Scsi_Host *instance
 }
 
 /*
- * Function : int NCR5380_pwrite (struct Scsi_Host *instance, 
+ * Function : int t128_pwrite (struct Scsi_Host *instance,
  *	unsigned char *src, int len)
  *
  * Purpose : Fast 5380 pseudo-dma write function, transfers len bytes from
@@ -350,8 +350,8 @@ NCR5380_pread(struct Scsi_Host *instance
  * 	timeout.
  */
 
-static inline int
-NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src, int len)
+static inline int t128_pwrite(struct Scsi_Host *instance,
+                              unsigned char *src, int len)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	void __iomem *reg, *base = hostdata->base;
Index: linux/drivers/scsi/t128.h
===================================================================
--- linux.orig/drivers/scsi/t128.h	2016-03-21 13:31:20.000000000 +1100
+++ linux/drivers/scsi/t128.h	2016-03-21 13:31:21.000000000 +1100
@@ -77,6 +77,8 @@
 #define NCR5380_write(reg, value) writeb((value),(T128_address(reg)))
 
 #define NCR5380_dma_xfer_len(instance, cmd, phase)	(cmd->transfersize)
+#define NCR5380_dma_recv_setup		t128_pread
+#define NCR5380_dma_send_setup		t128_pwrite
 
 #define NCR5380_intr t128_intr
 #define NCR5380_queue_command t128_queue_command
Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2016-03-21 13:31:16.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2016-03-21 13:31:21.000000000 +1100
@@ -40,8 +40,8 @@
 #define NCR5380_write(reg, value)	outb(value, instance->io_port + reg)
 
 #define NCR5380_dma_xfer_len(instance, cmd, phase)	(0)
-#define NCR5380_pread(instance, dst, len)		(0)
-#define NCR5380_pwrite(instance, src, len)		(0)
+#define NCR5380_dma_recv_setup(instance, dst, len)	(0)
+#define NCR5380_dma_send_setup(instance, src, len)	(0)
 
 #define NCR5380_implementation_fields	/* none */
