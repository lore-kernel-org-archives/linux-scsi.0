From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 08/12] scsi/ncr5380: Use correct types for device register
 accessors
Date: Tue,  4 Oct 2016 01:40:50 -0400 (EDT)
Message-ID: <910a65949139de8a997feadaf8462ce506427d45.1475559357.git.fthain@telegraphics.com.au>
References: <cover.1475559357.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <cover.1475559357.git.fthain@telegraphics.com.au>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

For timeout values adopt unsigned long, which is the type of jiffies etc.

For chip register values and bit masks pass u8, which is the return type
of readb, inb etc.

For device register offsets adopt unsigned int, as it is suitable for
adding to base addresses.

Pass the NCR5380_hostdata pointer to the board-specific routines instead
of the Scsi_Host pointer. The board-specific code is concerned with
hardware and not with SCSI protocol or the mid-layer.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.c      | 10 ++++++++--
 drivers/scsi/NCR5380.h      |  7 +++++--
 drivers/scsi/arm/cumana_1.c | 20 +++++++++++---------
 drivers/scsi/arm/oak.c      |  6 ++----
 drivers/scsi/atari_scsi.c   | 16 ++++++++--------
 drivers/scsi/dmx3191d.c     |  6 ++----
 drivers/scsi/g_NCR5380.h    |  8 ++------
 drivers/scsi/mac_scsi.c     | 22 ++--------------------
 drivers/scsi/sun3_scsi.c    | 32 +++++++++-----------------------
 9 files changed, 49 insertions(+), 78 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 68092f7..8e11ab7 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -196,8 +196,9 @@ static inline void initialize_SCp(struct scsi_cmnd *cmd)
  */
 
 static int NCR5380_poll_politely2(struct Scsi_Host *instance,
-                                  int reg1, int bit1, int val1,
-                                  int reg2, int bit2, int val2, int wait)
+                                  unsigned int reg1, u8 bit1, u8 val1,
+                                  unsigned int reg2, u8 bit2, u8 val2,
+                                  unsigned long wait)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned long n = hostdata->poll_loops;
@@ -284,6 +285,7 @@ mrs[] = {
 
 static void NCR5380_print(struct Scsi_Host *instance)
 {
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char status, data, basr, mr, icr, i;
 
 	data = NCR5380_read(CURRENT_SCSI_DATA_REG);
@@ -333,6 +335,7 @@ static struct {
 
 static void NCR5380_print_phase(struct Scsi_Host *instance)
 {
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char status;
 	int i;
 
@@ -1316,6 +1319,7 @@ static int NCR5380_transfer_pio(struct Scsi_Host *instance,
 				unsigned char *phase, int *count,
 				unsigned char **data)
 {
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char p = *phase, tmp;
 	int c = *count;
 	unsigned char *d = *data;
@@ -1438,6 +1442,7 @@ static int NCR5380_transfer_pio(struct Scsi_Host *instance,
 
 static void do_reset(struct Scsi_Host *instance)
 {
+	struct NCR5380_hostdata __maybe_unused *hostdata = shost_priv(instance);
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -1460,6 +1465,7 @@ static void do_reset(struct Scsi_Host *instance)
 
 static int do_abort(struct Scsi_Host *instance)
 {
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char *msgptr, phase, tmp;
 	int len;
 	int rc;
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 5441970..79f8add 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -302,10 +302,13 @@ static void NCR5380_reselect(struct Scsi_Host *instance);
 static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *, struct scsi_cmnd *);
 static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
 static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
-static int NCR5380_poll_politely2(struct Scsi_Host *, int, int, int, int, int, int, int);
+static int NCR5380_poll_politely2(struct Scsi_Host *,
+                                  unsigned int, u8, u8,
+                                  unsigned int, u8, u8, unsigned long);
 
 static inline int NCR5380_poll_politely(struct Scsi_Host *instance,
-                                        int reg, int bit, int val, int wait)
+                                        unsigned int reg, u8 bit, u8 val,
+                                        unsigned long wait)
 {
 	return NCR5380_poll_politely2(instance, reg, bit, val,
 	                                        reg, bit, val, wait);
diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index 88db281..ae1d4c6 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -14,8 +14,8 @@
 #include <scsi/scsi_host.h>
 
 #define priv(host)			((struct NCR5380_hostdata *)(host)->hostdata)
-#define NCR5380_read(reg)		cumanascsi_read(instance, reg)
-#define NCR5380_write(reg, value)	cumanascsi_write(instance, reg, value)
+#define NCR5380_read(reg)		cumanascsi_read(hostdata, reg)
+#define NCR5380_write(reg, value)	cumanascsi_write(hostdata, reg, value)
 
 #define NCR5380_dma_xfer_len(instance, cmd, phase)	(cmd->transfersize)
 #define NCR5380_dma_recv_setup		cumanascsi_pread
@@ -169,30 +169,32 @@ end:
 	return 0;
 }
 
-static unsigned char cumanascsi_read(struct Scsi_Host *host, unsigned int reg)
+static u8 cumanascsi_read(struct NCR5380_hostdata *hostdata,
+                          unsigned int reg)
 {
-	u8 __iomem *base = priv(host)->io;
-	unsigned char val;
+	u8 __iomem *base = hostdata->io;
+	u8 val;
 
 	writeb(0, base + CTRL);
 
 	val = readb(base + 0x2100 + (reg << 2));
 
-	priv(host)->ctrl = 0x40;
+	hostdata->ctrl = 0x40;
 	writeb(0x40, base + CTRL);
 
 	return val;
 }
 
-static void cumanascsi_write(struct Scsi_Host *host, unsigned int reg, unsigned int value)
+static void cumanascsi_write(struct NCR5380_hostdata *hostdata,
+                             unsigned int reg, u8 value)
 {
-	u8 __iomem *base = priv(host)->io;
+	u8 __iomem *base = hostdata->io;
 
 	writeb(0, base + CTRL);
 
 	writeb(value, base + 0x2100 + (reg << 2));
 
-	priv(host)->ctrl = 0x40;
+	hostdata->ctrl = 0x40;
 	writeb(0x40, base + CTRL);
 }
 
diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
index 1c4a44a..d320f88 100644
--- a/drivers/scsi/arm/oak.c
+++ b/drivers/scsi/arm/oak.c
@@ -16,10 +16,8 @@
 
 #define priv(host)			((struct NCR5380_hostdata *)(host)->hostdata)
 
-#define NCR5380_read(reg) \
-	readb(priv(instance)->io + ((reg) << 2))
-#define NCR5380_write(reg, value) \
-	writeb(value, priv(instance)->io + ((reg) << 2))
+#define NCR5380_read(reg)           readb(hostdata->io + ((reg) << 2))
+#define NCR5380_write(reg, value)   writeb(value, hostdata->io + ((reg) << 2))
 
 #define NCR5380_dma_xfer_len(instance, cmd, phase)	(0)
 #define NCR5380_dma_recv_setup		oakscsi_pread
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 862f30c..aed69ac 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -126,8 +126,8 @@ static inline unsigned long SCSI_DMA_GETADR(void)
 
 static void atari_scsi_fetch_restbytes(void);
 
-static unsigned char (*atari_scsi_reg_read)(unsigned char reg);
-static void (*atari_scsi_reg_write)(unsigned char reg, unsigned char value);
+static u8 (*atari_scsi_reg_read)(unsigned int);
+static void (*atari_scsi_reg_write)(unsigned int, u8);
 
 static unsigned long	atari_dma_residual, atari_dma_startaddr;
 static short		atari_dma_active;
@@ -658,30 +658,30 @@ static unsigned long atari_dma_xfer_len(unsigned long wanted_len,
  * NCR5380_write call these functions via function pointers.
  */
 
-static unsigned char atari_scsi_tt_reg_read(unsigned char reg)
+static u8 atari_scsi_tt_reg_read(unsigned int reg)
 {
 	return tt_scsi_regp[reg * 2];
 }
 
-static void atari_scsi_tt_reg_write(unsigned char reg, unsigned char value)
+static void atari_scsi_tt_reg_write(unsigned int reg, u8 value)
 {
 	tt_scsi_regp[reg * 2] = value;
 }
 
-static unsigned char atari_scsi_falcon_reg_read(unsigned char reg)
+static u8 atari_scsi_falcon_reg_read(unsigned int reg)
 {
 	unsigned long flags;
-	unsigned char result;
+	u8 result;
 
 	reg += 0x88;
 	local_irq_save(flags);
 	dma_wd.dma_mode_status = (u_short)reg;
-	result = (u_char)dma_wd.fdc_acces_seccount;
+	result = (u8)dma_wd.fdc_acces_seccount;
 	local_irq_restore(flags);
 	return result;
 }
 
-static void atari_scsi_falcon_reg_write(unsigned char reg, unsigned char value)
+static void atari_scsi_falcon_reg_write(unsigned int reg, u8 value)
 {
 	unsigned long flags;
 
diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
index 3b6df90..ab7b097 100644
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -34,10 +34,8 @@
  * Definitions for the generic 5380 driver.
  */
 
-#define priv(instance)	((struct NCR5380_hostdata *)shost_priv(instance))
-
-#define NCR5380_read(reg)		inb(priv(instance)->base + (reg))
-#define NCR5380_write(reg, value)	outb(value, priv(instance)->base + (reg))
+#define NCR5380_read(reg)		inb(hostdata->base + (reg))
+#define NCR5380_write(reg, value)	outb(value, hostdata->base + (reg))
 
 #define NCR5380_dma_xfer_len(instance, cmd, phase)	(0)
 #define NCR5380_dma_recv_setup(instance, dst, len)	(0)
diff --git a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
index ec4d70b..10191d1 100644
--- a/drivers/scsi/g_NCR5380.h
+++ b/drivers/scsi/g_NCR5380.h
@@ -17,13 +17,9 @@
 #define DRV_MODULE_NAME "g_NCR5380"
 
 #define NCR5380_read(reg) \
-	ioread8(((struct NCR5380_hostdata *)shost_priv(instance))->io + \
-		((struct NCR5380_hostdata *)shost_priv(instance))->offset + \
-		(reg))
+	ioread8(hostdata->io + hostdata->offset + (reg))
 #define NCR5380_write(reg, value) \
-	iowrite8(value, ((struct NCR5380_hostdata *)shost_priv(instance))->io + \
-		((struct NCR5380_hostdata *)shost_priv(instance))->offset + \
-		(reg))
+	iowrite8(value, hostdata->io + hostdata->offset + (reg))
 
 #define NCR5380_implementation_fields \
 	int offset; \
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 80e10d9..9ac3822 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -30,8 +30,8 @@
 
 #define NCR5380_implementation_fields   int pdma_residual
 
-#define NCR5380_read(reg)               macscsi_read(instance, reg)
-#define NCR5380_write(reg, value)       macscsi_write(instance, reg, value)
+#define NCR5380_read(reg)           in_8(hostdata->io + ((reg) << 4))
+#define NCR5380_write(reg, value)   out_8(hostdata->io + ((reg) << 4), value)
 
 #define NCR5380_dma_xfer_len(instance, cmd, phase) \
         macscsi_dma_xfer_len(instance, cmd)
@@ -60,24 +60,6 @@ module_param(setup_hostid, int, 0);
 static int setup_toshiba_delay = -1;
 module_param(setup_toshiba_delay, int, 0);
 
-/*
- * NCR 5380 register access functions
- */
-
-static inline char macscsi_read(struct Scsi_Host *instance, int reg)
-{
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-
-	return in_8(hostdata->io + (reg << 4));
-}
-
-static inline void macscsi_write(struct Scsi_Host *instance, int reg, int value)
-{
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-
-	out_8(hostdata->io + (reg << 4), value);
-}
-
 #ifndef MODULE
 static int __init mac_scsi_setup(char *str)
 {
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index efee144..b408474 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -43,8 +43,8 @@
 
 #define NCR5380_implementation_fields   /* none */
 
-#define NCR5380_read(reg)               sun3scsi_read(reg)
-#define NCR5380_write(reg, value)       sun3scsi_write(reg, value)
+#define NCR5380_read(reg)               in_8(hostdata->io + (reg))
+#define NCR5380_write(reg, value)       out_8(hostdata->io + (reg), value)
 
 #define NCR5380_queue_command           sun3scsi_queue_command
 #define NCR5380_bus_reset               sun3scsi_bus_reset
@@ -82,7 +82,6 @@ module_param(setup_hostid, int, 0);
 #define SUN3_DVMA_BUFSIZE 0xe000
 
 static struct scsi_cmnd *sun3_dma_setup_done;
-static unsigned char *sun3_scsi_regp;
 static volatile struct sun3_dma_regs *dregs;
 static struct sun3_udc_regs *udc_regs;
 static unsigned char *sun3_dma_orig_addr;
@@ -90,20 +89,6 @@ static unsigned long sun3_dma_orig_count;
 static int sun3_dma_active;
 static unsigned long last_residual;
 
-/*
- * NCR 5380 register access functions
- */
-
-static inline unsigned char sun3scsi_read(int reg)
-{
-	return in_8(sun3_scsi_regp + reg);
-}
-
-static inline void sun3scsi_write(int reg, int value)
-{
-	out_8(sun3_scsi_regp + reg, value);
-}
-
 #ifndef SUN3_SCSI_VME
 /* dma controller register access functions */
 
@@ -431,7 +416,7 @@ static int __init sun3_scsi_probe(struct platform_device *pdev)
 	struct NCR5380_hostdata *hostdata;
 	int error;
 	struct resource *irq, *mem;
-	unsigned char *ioaddr;
+	void __iomem *ioaddr;
 	int host_flags = 0;
 #ifdef SUN3_SCSI_VME
 	int i;
@@ -494,8 +479,6 @@ static int __init sun3_scsi_probe(struct platform_device *pdev)
 	}
 #endif
 
-	sun3_scsi_regp = ioaddr;
-
 	instance = scsi_host_alloc(&sun3_scsi_template,
 	                           sizeof(struct NCR5380_hostdata));
 	if (!instance) {
@@ -506,7 +489,8 @@ static int __init sun3_scsi_probe(struct platform_device *pdev)
 	instance->irq = irq->start;
 
 	hostdata = shost_priv(instance);
-	hostdata->base = (unsigned long)ioaddr;
+	hostdata->base = mem->start;
+	hostdata->io = ioaddr;
 
 	error = NCR5380_init(instance, host_flags);
 	if (error)
@@ -555,13 +539,15 @@ fail_init:
 fail_alloc:
 	if (udc_regs)
 		dvma_free(udc_regs);
-	iounmap(sun3_scsi_regp);
+	iounmap(ioaddr);
 	return error;
 }
 
 static int __exit sun3_scsi_remove(struct platform_device *pdev)
 {
 	struct Scsi_Host *instance = platform_get_drvdata(pdev);
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	void __iomem *ioaddr = hostdata->io;
 
 	scsi_remove_host(instance);
 	free_irq(instance->irq, instance);
@@ -569,7 +555,7 @@ static int __exit sun3_scsi_remove(struct platform_device *pdev)
 	scsi_host_put(instance);
 	if (udc_regs)
 		dvma_free(udc_regs);
-	iounmap(sun3_scsi_regp);
+	iounmap(ioaddr);
 	return 0;
 }
 
-- 
2.7.3
