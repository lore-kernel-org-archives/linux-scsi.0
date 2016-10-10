From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 11/12] scsi/ncr5380: Use correct types for DMA routines
Date: Mon, 10 Oct 2016 00:46:53 -0400 (EDT)
Message-ID: <8390541e30d7b7cd418a7b5095fdb4b5fc7aa0ed.1476051962.git.fthain@telegraphics.com.au>
References: <cover.1476051961.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476051961.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Apply prototypes to get consistent function signatures for the DMA
functions implemented in the board-specific drivers. To avoid using
macros to alter actual parameters, some of those functions are reworked
slightly.

This is a step toward the goal of passing the board-specific routines
to the core driver using an ops struct (as in a platform driver or
library module).

This also helps fix some inconsistent types: where the core driver uses
ints (cmd->SCp.this_residual and hostdata->dma_len) for keeping track of
transfers, certain board-specific routines used unsigned long.

While we are fixing these function signatures, pass the hostdata pointer
to DMA routines instead of a Scsi_Host pointer, for shorter and faster
code.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
---
 drivers/scsi/NCR5380.c      | 74 +++++++++++++++++++++++++--------------------
 drivers/scsi/NCR5380.h      | 25 +++++++++++++++
 drivers/scsi/arm/cumana_1.c | 26 ++++++++++------
 drivers/scsi/arm/oak.c      | 13 ++++----
 drivers/scsi/atari_scsi.c   | 45 +++++++++++++++------------
 drivers/scsi/dmx3191d.c     |  8 ++---
 drivers/scsi/g_NCR5380.c    | 13 +++-----
 drivers/scsi/g_NCR5380.h    |  5 ++-
 drivers/scsi/mac_scsi.c     | 36 +++++++++++-----------
 drivers/scsi/sun3_scsi.c    | 45 +++++++++++++++++++--------
 10 files changed, 176 insertions(+), 114 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 3f2bfd2..72ac31cd 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -121,9 +121,10 @@
  *
  * Either real DMA *or* pseudo DMA may be implemented
  *
- * NCR5380_dma_write_setup(instance, src, count) - initialize
- * NCR5380_dma_read_setup(instance, dst, count) - initialize
- * NCR5380_dma_residual(instance); - residual count
+ * NCR5380_dma_xfer_len   - determine size of DMA/PDMA transfer
+ * NCR5380_dma_send_setup - execute DMA/PDMA from memory to 5380
+ * NCR5380_dma_recv_setup - execute DMA/PDMA from 5380 to memory
+ * NCR5380_dma_residual   - residual byte count
  *
  * The generic driver is initialized by calling NCR5380_init(instance),
  * after setting the appropriate host specific fields and ID.  If the
@@ -871,7 +872,7 @@ static void NCR5380_dma_complete(struct Scsi_Host *instance)
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 
-	transferred = hostdata->dma_len - NCR5380_dma_residual(instance);
+	transferred = hostdata->dma_len - NCR5380_dma_residual(hostdata);
 	hostdata->dma_len = 0;
 
 	data = (unsigned char **)&hostdata->connected->SCp.ptr;
@@ -1578,9 +1579,9 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
 		 * starting the NCR. This is also the cleaner way for the TT.
 		 */
 		if (p & SR_IO)
-			result = NCR5380_dma_recv_setup(instance, d, c);
+			result = NCR5380_dma_recv_setup(hostdata, d, c);
 		else
-			result = NCR5380_dma_send_setup(instance, d, c);
+			result = NCR5380_dma_send_setup(hostdata, d, c);
 	}
 
 	/*
@@ -1612,9 +1613,9 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
 		 * NCR access, else the DMA setup gets trashed!
 		 */
 		if (p & SR_IO)
-			result = NCR5380_dma_recv_setup(instance, d, c);
+			result = NCR5380_dma_recv_setup(hostdata, d, c);
 		else
-			result = NCR5380_dma_send_setup(instance, d, c);
+			result = NCR5380_dma_send_setup(hostdata, d, c);
 	}
 
 	/* On failure, NCR5380_dma_xxxx_setup() returns a negative int. */
@@ -1754,22 +1755,26 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				NCR5380_dprint_phase(NDEBUG_INFORMATION, instance);
 			}
 #ifdef CONFIG_SUN3
-			if (phase == PHASE_CMDOUT) {
-				void *d;
-				unsigned long count;
+			if (phase == PHASE_CMDOUT &&
+			    sun3_dma_setup_done != cmd) {
+				int count;
 
 				if (!cmd->SCp.this_residual && cmd->SCp.buffers_residual) {
-					count = cmd->SCp.buffer->length;
-					d = sg_virt(cmd->SCp.buffer);
-				} else {
-					count = cmd->SCp.this_residual;
-					d = cmd->SCp.ptr;
+					++cmd->SCp.buffer;
+					--cmd->SCp.buffers_residual;
+					cmd->SCp.this_residual = cmd->SCp.buffer->length;
+					cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 				}
 
-				if (sun3_dma_setup_done != cmd &&
-				    sun3scsi_dma_xfer_len(count, cmd) > 0) {
-					sun3scsi_dma_setup(instance, d, count,
-					                   rq_data_dir(cmd->request));
+				count = sun3scsi_dma_xfer_len(hostdata, cmd);
+
+				if (count > 0) {
+					if (rq_data_dir(cmd->request))
+						sun3scsi_dma_send_setup(hostdata,
+						                        cmd->SCp.ptr, count);
+					else
+						sun3scsi_dma_recv_setup(hostdata,
+						                        cmd->SCp.ptr, count);
 					sun3_dma_setup_done = cmd;
 				}
 #ifdef SUN3_SCSI_VME
@@ -1830,7 +1835,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 
 				transfersize = 0;
 				if (!cmd->device->borken)
-					transfersize = NCR5380_dma_xfer_len(instance, cmd, phase);
+					transfersize = NCR5380_dma_xfer_len(hostdata, cmd);
 
 				if (transfersize > 0) {
 					len = transfersize;
@@ -2207,22 +2212,25 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 	}
 
 #ifdef CONFIG_SUN3
-	{
-		void *d;
-		unsigned long count;
+	if (sun3_dma_setup_done != tmp) {
+		int count;
 
 		if (!tmp->SCp.this_residual && tmp->SCp.buffers_residual) {
-			count = tmp->SCp.buffer->length;
-			d = sg_virt(tmp->SCp.buffer);
-		} else {
-			count = tmp->SCp.this_residual;
-			d = tmp->SCp.ptr;
+			++tmp->SCp.buffer;
+			--tmp->SCp.buffers_residual;
+			tmp->SCp.this_residual = tmp->SCp.buffer->length;
+			tmp->SCp.ptr = sg_virt(tmp->SCp.buffer);
 		}
 
-		if (sun3_dma_setup_done != tmp &&
-		    sun3scsi_dma_xfer_len(count, tmp) > 0) {
-			sun3scsi_dma_setup(instance, d, count,
-			                   rq_data_dir(tmp->request));
+		count = sun3scsi_dma_xfer_len(hostdata, tmp);
+
+		if (count > 0) {
+			if (rq_data_dir(tmp->request))
+				sun3scsi_dma_send_setup(hostdata,
+				                        tmp->SCp.ptr, count);
+			else
+				sun3scsi_dma_recv_setup(hostdata,
+				                        tmp->SCp.ptr, count);
 			sun3_dma_setup_done = tmp;
 		}
 	}
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index b2c560c..3c6ce54 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -317,5 +317,30 @@ static inline int NCR5380_poll_politely(struct NCR5380_hostdata *hostdata,
 						reg, bit, val, wait);
 }
 
+static int NCR5380_dma_xfer_len(struct NCR5380_hostdata *,
+                                struct scsi_cmnd *);
+static int NCR5380_dma_send_setup(struct NCR5380_hostdata *,
+                                  unsigned char *, int);
+static int NCR5380_dma_recv_setup(struct NCR5380_hostdata *,
+                                  unsigned char *, int);
+static int NCR5380_dma_residual(struct NCR5380_hostdata *);
+
+static inline int NCR5380_dma_xfer_none(struct NCR5380_hostdata *hostdata,
+                                        struct scsi_cmnd *cmd)
+{
+	return 0;
+}
+
+static inline int NCR5380_dma_setup_none(struct NCR5380_hostdata *hostdata,
+                                         unsigned char *data, int count)
+{
+	return 0;
+}
+
+static inline int NCR5380_dma_residual_none(struct NCR5380_hostdata *hostdata)
+{
+	return 0;
+}
+
 #endif				/* __KERNEL__ */
 #endif				/* NCR5380_H */
diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index fb7600d..a87b99c 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -17,10 +17,10 @@
 #define NCR5380_read(reg)		cumanascsi_read(hostdata, reg)
 #define NCR5380_write(reg, value)	cumanascsi_write(hostdata, reg, value)
 
-#define NCR5380_dma_xfer_len(instance, cmd, phase)	(cmd->transfersize)
+#define NCR5380_dma_xfer_len		cumanascsi_dma_xfer_len
 #define NCR5380_dma_recv_setup		cumanascsi_pread
 #define NCR5380_dma_send_setup		cumanascsi_pwrite
-#define NCR5380_dma_residual(instance)	(0)
+#define NCR5380_dma_residual		NCR5380_dma_residual_none
 
 #define NCR5380_intr			cumanascsi_intr
 #define NCR5380_queue_command		cumanascsi_queue_command
@@ -40,12 +40,12 @@ static void cumanascsi_write(struct NCR5380_hostdata *, unsigned int, u8);
 #define L(v)	(((v)<<16)|((v) & 0x0000ffff))
 #define H(v)	(((v)>>16)|((v) & 0xffff0000))
 
-static inline int cumanascsi_pwrite(struct Scsi_Host *host,
+static inline int cumanascsi_pwrite(struct NCR5380_hostdata *hostdata,
                                     unsigned char *addr, int len)
 {
   unsigned long *laddr;
-  u8 __iomem *base = priv(host)->io;
-  u8 __iomem *dma = priv(host)->pdma_io + 0x2000;
+  u8 __iomem *base = hostdata->io;
+  u8 __iomem *dma = hostdata->pdma_io + 0x2000;
 
   if(!len) return 0;
 
@@ -100,19 +100,19 @@ static inline int cumanascsi_pwrite(struct Scsi_Host *host,
     }
   }
 end:
-  writeb(priv(host)->ctrl | 0x40, base + CTRL);
+  writeb(hostdata->ctrl | 0x40, base + CTRL);
 
 	if (len)
 		return -1;
 	return 0;
 }
 
-static inline int cumanascsi_pread(struct Scsi_Host *host,
+static inline int cumanascsi_pread(struct NCR5380_hostdata *hostdata,
                                    unsigned char *addr, int len)
 {
   unsigned long *laddr;
-  u8 __iomem *base = priv(host)->io;
-  u8 __iomem *dma = priv(host)->pdma_io + 0x2000;
+  u8 __iomem *base = hostdata->io;
+  u8 __iomem *dma = hostdata->pdma_io + 0x2000;
 
   if(!len) return 0;
 
@@ -166,13 +166,19 @@ static inline int cumanascsi_pread(struct Scsi_Host *host,
     }
   }
 end:
-  writeb(priv(host)->ctrl | 0x40, base + CTRL);
+  writeb(hostdata->ctrl | 0x40, base + CTRL);
 
 	if (len)
 		return -1;
 	return 0;
 }
 
+static int cumanascsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
+                                   struct scsi_cmnd *cmd)
+{
+	return cmd->transfersize;
+}
+
 static u8 cumanascsi_read(struct NCR5380_hostdata *hostdata,
                           unsigned int reg)
 {
diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
index d320f88..6be6666 100644
--- a/drivers/scsi/arm/oak.c
+++ b/drivers/scsi/arm/oak.c
@@ -19,10 +19,10 @@
 #define NCR5380_read(reg)           readb(hostdata->io + ((reg) << 2))
 #define NCR5380_write(reg, value)   writeb(value, hostdata->io + ((reg) << 2))
 
-#define NCR5380_dma_xfer_len(instance, cmd, phase)	(0)
+#define NCR5380_dma_xfer_len		NCR5380_dma_xfer_none
 #define NCR5380_dma_recv_setup		oakscsi_pread
 #define NCR5380_dma_send_setup		oakscsi_pwrite
-#define NCR5380_dma_residual(instance)	(0)
+#define NCR5380_dma_residual		NCR5380_dma_residual_none
 
 #define NCR5380_queue_command		oakscsi_queue_command
 #define NCR5380_info			oakscsi_info
@@ -37,10 +37,10 @@
 #define STAT	((128 + 16) << 2)
 #define DATA	((128 + 8) << 2)
 
-static inline int oakscsi_pwrite(struct Scsi_Host *instance,
+static inline int oakscsi_pwrite(struct NCR5380_hostdata *hostdata,
                                  unsigned char *addr, int len)
 {
-  u8 __iomem *base = priv(instance)->io;
+  u8 __iomem *base = hostdata->io;
 
 printk("writing %p len %d\n",addr, len);
 
@@ -52,10 +52,11 @@ printk("writing %p len %d\n",addr, len);
   return 0;
 }
 
-static inline int oakscsi_pread(struct Scsi_Host *instance,
+static inline int oakscsi_pread(struct NCR5380_hostdata *hostdata,
                                 unsigned char *addr, int len)
 {
-  u8 __iomem *base = priv(instance)->io;
+  u8 __iomem *base = hostdata->io;
+
 printk("reading %p len %d\n", addr, len);
   while(len > 0)
   {
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index f77c311..105b353 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -67,14 +67,10 @@ static void (*atari_scsi_reg_write)(unsigned int, u8);
 #define NCR5380_abort                   atari_scsi_abort
 #define NCR5380_info                    atari_scsi_info
 
-#define NCR5380_dma_recv_setup(instance, data, count) \
-        atari_scsi_dma_setup(instance, data, count, 0)
-#define NCR5380_dma_send_setup(instance, data, count) \
-        atari_scsi_dma_setup(instance, data, count, 1)
-#define NCR5380_dma_residual(instance) \
-        atari_scsi_dma_residual(instance)
-#define NCR5380_dma_xfer_len(instance, cmd, phase) \
-        atari_dma_xfer_len(cmd->SCp.this_residual, cmd, !((phase) & SR_IO))
+#define NCR5380_dma_xfer_len            atari_scsi_dma_xfer_len
+#define NCR5380_dma_recv_setup          atari_scsi_dma_recv_setup
+#define NCR5380_dma_send_setup          atari_scsi_dma_send_setup
+#define NCR5380_dma_residual            atari_scsi_dma_residual
 
 #define NCR5380_acquire_dma_irq(instance)      falcon_get_lock(instance)
 #define NCR5380_release_dma_irq(instance)      falcon_release_lock()
@@ -457,15 +453,14 @@ static int __init atari_scsi_setup(char *str)
 __setup("atascsi=", atari_scsi_setup);
 #endif /* !MODULE */
 
-
-static unsigned long atari_scsi_dma_setup(struct Scsi_Host *instance,
+static unsigned long atari_scsi_dma_setup(struct NCR5380_hostdata *hostdata,
 					  void *data, unsigned long count,
 					  int dir)
 {
 	unsigned long addr = virt_to_phys(data);
 
-	dprintk(NDEBUG_DMA, "scsi%d: setting up dma, data = %p, phys = %lx, count = %ld, "
-		   "dir = %d\n", instance->host_no, data, addr, count, dir);
+	dprintk(NDEBUG_DMA, "scsi%d: setting up dma, data = %p, phys = %lx, count = %ld, dir = %d\n",
+	        hostdata->host->host_no, data, addr, count, dir);
 
 	if (!IS_A_TT() && !STRAM_ADDR(addr)) {
 		/* If we have a non-DMAable address on a Falcon, use the dribble
@@ -522,8 +517,19 @@ static unsigned long atari_scsi_dma_setup(struct Scsi_Host *instance,
 	return count;
 }
 
+static inline int atari_scsi_dma_recv_setup(struct NCR5380_hostdata *hostdata,
+                                            unsigned char *data, int count)
+{
+	return atari_scsi_dma_setup(hostdata, data, count, 0);
+}
+
+static inline int atari_scsi_dma_send_setup(struct NCR5380_hostdata *hostdata,
+                                            unsigned char *data, int count)
+{
+	return atari_scsi_dma_setup(hostdata, data, count, 1);
+}
 
-static long atari_scsi_dma_residual(struct Scsi_Host *instance)
+static int atari_scsi_dma_residual(struct NCR5380_hostdata *hostdata)
 {
 	return atari_dma_residual;
 }
@@ -564,10 +570,11 @@ static int falcon_classify_cmd(struct scsi_cmnd *cmd)
  * the overrun problem, so this question is academic :-)
  */
 
-static unsigned long atari_dma_xfer_len(unsigned long wanted_len,
-					struct scsi_cmnd *cmd, int write_flag)
+static int atari_scsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
+                                   struct scsi_cmnd *cmd)
 {
-	unsigned long	possible_len, limit;
+	int wanted_len = cmd->SCp.this_residual;
+	int possible_len, limit;
 
 	if (wanted_len < DMA_MIN_SIZE)
 		return 0;
@@ -604,7 +611,7 @@ static unsigned long atari_dma_xfer_len(unsigned long wanted_len,
 	 * use the dribble buffer and thus can do only STRAM_BUFFER_SIZE bytes.
 	 */
 
-	if (write_flag) {
+	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
 		/* Write operation can always use the DMA, but the transfer size must
 		 * be rounded up to the next multiple of 512 (atari_dma_setup() does
 		 * this).
@@ -644,8 +651,8 @@ static unsigned long atari_dma_xfer_len(unsigned long wanted_len,
 		possible_len = limit;
 
 	if (possible_len != wanted_len)
-		dprintk(NDEBUG_DMA, "Sorry, must cut DMA transfer size to %ld bytes "
-			   "instead of %ld\n", possible_len, wanted_len);
+		dprintk(NDEBUG_DMA, "DMA transfer now %d bytes instead of %d\n",
+		        possible_len, wanted_len);
 
 	return possible_len;
 }
diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
index ab7b097..3aa4657 100644
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -37,10 +37,10 @@
 #define NCR5380_read(reg)		inb(hostdata->base + (reg))
 #define NCR5380_write(reg, value)	outb(value, hostdata->base + (reg))
 
-#define NCR5380_dma_xfer_len(instance, cmd, phase)	(0)
-#define NCR5380_dma_recv_setup(instance, dst, len)	(0)
-#define NCR5380_dma_send_setup(instance, src, len)	(0)
-#define NCR5380_dma_residual(instance)			(0)
+#define NCR5380_dma_xfer_len		NCR5380_dma_xfer_none
+#define NCR5380_dma_recv_setup		NCR5380_dma_setup_none
+#define NCR5380_dma_send_setup		NCR5380_dma_setup_none
+#define NCR5380_dma_residual		NCR5380_dma_residual_none
 
 #define NCR5380_implementation_fields	/* none */
 
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 98aef0e..7299ad9 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -332,7 +332,7 @@ static void generic_NCR5380_release_resources(struct Scsi_Host *instance)
 
 /**
  *	generic_NCR5380_pread - pseudo DMA read
- *	@instance: adapter to read from
+ *	@hostdata: scsi host private data
  *	@dst: buffer to read into
  *	@len: buffer length
  *
@@ -340,10 +340,9 @@ static void generic_NCR5380_release_resources(struct Scsi_Host *instance)
  *	controller
  */
  
-static inline int generic_NCR5380_pread(struct Scsi_Host *instance,
+static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
                                         unsigned char *dst, int len)
 {
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int blocks = len / 128;
 	int start = 0;
 
@@ -406,7 +405,7 @@ static inline int generic_NCR5380_pread(struct Scsi_Host *instance,
 
 /**
  *	generic_NCR5380_pwrite - pseudo DMA write
- *	@instance: adapter to read from
+ *	@hostdata: scsi host private data
  *	@dst: buffer to read into
  *	@len: buffer length
  *
@@ -414,10 +413,9 @@ static inline int generic_NCR5380_pread(struct Scsi_Host *instance,
  *	controller
  */
 
-static inline int generic_NCR5380_pwrite(struct Scsi_Host *instance,
+static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
                                          unsigned char *src, int len)
 {
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int blocks = len / 128;
 	int start = 0;
 
@@ -480,10 +478,9 @@ static inline int generic_NCR5380_pwrite(struct Scsi_Host *instance,
 	return 0;
 }
 
-static int generic_NCR5380_dma_xfer_len(struct Scsi_Host *instance,
+static int generic_NCR5380_dma_xfer_len(struct NCR5380_hostdata *hostdata,
                                         struct scsi_cmnd *cmd)
 {
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int transfersize = cmd->transfersize;
 
 	if (hostdata->flags & FLAG_NO_PSEUDO_DMA)
diff --git a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
index 10191d1..3ce5b65 100644
--- a/drivers/scsi/g_NCR5380.h
+++ b/drivers/scsi/g_NCR5380.h
@@ -32,11 +32,10 @@
 #define NCR53C400_host_buffer 0x3900
 #define NCR53C400_region_size 0x3a00
 
-#define NCR5380_dma_xfer_len(instance, cmd, phase) \
-        generic_NCR5380_dma_xfer_len(instance, cmd)
+#define NCR5380_dma_xfer_len		generic_NCR5380_dma_xfer_len
 #define NCR5380_dma_recv_setup		generic_NCR5380_pread
 #define NCR5380_dma_send_setup		generic_NCR5380_pwrite
-#define NCR5380_dma_residual(instance)	(0)
+#define NCR5380_dma_residual		NCR5380_dma_residual_none
 
 #define NCR5380_intr generic_NCR5380_intr
 #define NCR5380_queue_command generic_NCR5380_queue_command
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 07f956c..ccb68d1 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -33,11 +33,10 @@
 #define NCR5380_read(reg)           in_8(hostdata->io + ((reg) << 4))
 #define NCR5380_write(reg, value)   out_8(hostdata->io + ((reg) << 4), value)
 
-#define NCR5380_dma_xfer_len(instance, cmd, phase) \
-        macscsi_dma_xfer_len(instance, cmd)
+#define NCR5380_dma_xfer_len            macscsi_dma_xfer_len
 #define NCR5380_dma_recv_setup          macscsi_pread
 #define NCR5380_dma_send_setup          macscsi_pwrite
-#define NCR5380_dma_residual(instance)  (hostdata->pdma_residual)
+#define NCR5380_dma_residual            macscsi_dma_residual
 
 #define NCR5380_intr                    macscsi_intr
 #define NCR5380_queue_command           macscsi_queue_command
@@ -152,10 +151,9 @@ __asm__ __volatile__					\
      : "0"(s), "1"(d), "2"(n)				\
      : "d0")
 
-static int macscsi_pread(struct Scsi_Host *instance,
-                         unsigned char *dst, int len)
+static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
+                                unsigned char *dst, int len)
 {
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char *s = hostdata->pdma_io + (INPUT_DATA_REG << 4);
 	unsigned char *d = dst;
 	int n = len;
@@ -181,16 +179,16 @@ static int macscsi_pread(struct Scsi_Host *instance,
 		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
 			return 0;
 
-		dsprintk(NDEBUG_PSEUDO_DMA, instance,
+		dsprintk(NDEBUG_PSEUDO_DMA, hostdata->host,
 		         "%s: bus error (%d/%d)\n", __func__, transferred, len);
-		NCR5380_dprint(NDEBUG_PSEUDO_DMA, instance);
+		NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
 		d = dst + transferred;
 		n = len - transferred;
 	}
 
 	scmd_printk(KERN_ERR, hostdata->connected,
 	            "%s: phase mismatch or !DRQ\n", __func__);
-	NCR5380_dprint(NDEBUG_PSEUDO_DMA, instance);
+	NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
 	return -1;
 }
 
@@ -255,10 +253,9 @@ __asm__ __volatile__					\
      : "0"(s), "1"(d), "2"(n)				\
      : "d0")
 
-static int macscsi_pwrite(struct Scsi_Host *instance,
-                          unsigned char *src, int len)
+static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
+                                 unsigned char *src, int len)
 {
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char *s = src;
 	unsigned char *d = hostdata->pdma_io + (OUTPUT_DATA_REG << 4);
 	int n = len;
@@ -290,25 +287,23 @@ static int macscsi_pwrite(struct Scsi_Host *instance,
 			return 0;
 		}
 
-		dsprintk(NDEBUG_PSEUDO_DMA, instance,
+		dsprintk(NDEBUG_PSEUDO_DMA, hostdata->host,
 		         "%s: bus error (%d/%d)\n", __func__, transferred, len);
-		NCR5380_dprint(NDEBUG_PSEUDO_DMA, instance);
+		NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
 		s = src + transferred;
 		n = len - transferred;
 	}
 
 	scmd_printk(KERN_ERR, hostdata->connected,
 	            "%s: phase mismatch or !DRQ\n", __func__);
-	NCR5380_dprint(NDEBUG_PSEUDO_DMA, instance);
+	NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
 
 	return -1;
 }
 
-static int macscsi_dma_xfer_len(struct Scsi_Host *instance,
+static int macscsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
                                 struct scsi_cmnd *cmd)
 {
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-
 	if (hostdata->flags & FLAG_NO_PSEUDO_DMA ||
 	    cmd->SCp.this_residual < 16)
 		return 0;
@@ -316,6 +311,11 @@ static int macscsi_dma_xfer_len(struct Scsi_Host *instance,
 	return cmd->SCp.this_residual;
 }
 
+static int macscsi_dma_residual(struct NCR5380_hostdata *hostdata)
+{
+	return hostdata->pdma_residual;
+}
+
 #include "NCR5380.c"
 
 #define DRV_MODULE_NAME         "mac_scsi"
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index b408474..88db699 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -51,12 +51,10 @@
 #define NCR5380_abort                   sun3scsi_abort
 #define NCR5380_info                    sun3scsi_info
 
-#define NCR5380_dma_recv_setup(instance, data, count) (count)
-#define NCR5380_dma_send_setup(instance, data, count) (count)
-#define NCR5380_dma_residual(instance) \
-        sun3scsi_dma_residual(instance)
-#define NCR5380_dma_xfer_len(instance, cmd, phase) \
-        sun3scsi_dma_xfer_len(cmd->SCp.this_residual, cmd)
+#define NCR5380_dma_xfer_len            sun3scsi_dma_xfer_len
+#define NCR5380_dma_recv_setup          sun3scsi_dma_count
+#define NCR5380_dma_send_setup          sun3scsi_dma_count
+#define NCR5380_dma_residual            sun3scsi_dma_residual
 
 #define NCR5380_acquire_dma_irq(instance)    (1)
 #define NCR5380_release_dma_irq(instance)
@@ -143,8 +141,8 @@ static irqreturn_t scsi_sun3_intr(int irq, void *dev)
 }
 
 /* sun3scsi_dma_setup() -- initialize the dma controller for a read/write */
-static unsigned long sun3scsi_dma_setup(struct Scsi_Host *instance,
-                                void *data, unsigned long count, int write_flag)
+static int sun3scsi_dma_setup(struct NCR5380_hostdata *hostdata,
+                              unsigned char *data, int count, int write_flag)
 {
 	void *addr;
 
@@ -196,9 +194,10 @@ static unsigned long sun3scsi_dma_setup(struct Scsi_Host *instance,
 	dregs->csr |= CSR_FIFO;
 	
 	if(dregs->fifo_count != count) { 
-		shost_printk(KERN_ERR, instance, "FIFO mismatch %04x not %04x\n",
+		shost_printk(KERN_ERR, hostdata->host,
+		             "FIFO mismatch %04x not %04x\n",
 		             dregs->fifo_count, (unsigned int) count);
-		NCR5380_dprint(NDEBUG_DMA, instance);
+		NCR5380_dprint(NDEBUG_DMA, hostdata->host);
 	}
 
 	/* setup udc */
@@ -233,14 +232,34 @@ static unsigned long sun3scsi_dma_setup(struct Scsi_Host *instance,
 
 }
 
-static inline unsigned long sun3scsi_dma_residual(struct Scsi_Host *instance)
+static int sun3scsi_dma_count(struct NCR5380_hostdata *hostdata,
+                              unsigned char *data, int count)
+{
+	return count;
+}
+
+static inline int sun3scsi_dma_recv_setup(struct NCR5380_hostdata *hostdata,
+                                          unsigned char *data, int count)
+{
+	return sun3scsi_dma_setup(hostdata, data, count, 0);
+}
+
+static inline int sun3scsi_dma_send_setup(struct NCR5380_hostdata *hostdata,
+                                          unsigned char *data, int count)
+{
+	return sun3scsi_dma_setup(hostdata, data, count, 1);
+}
+
+static int sun3scsi_dma_residual(struct NCR5380_hostdata *hostdata)
 {
 	return last_residual;
 }
 
-static inline unsigned long sun3scsi_dma_xfer_len(unsigned long wanted_len,
-                                                  struct scsi_cmnd *cmd)
+static int sun3scsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
+                                 struct scsi_cmnd *cmd)
 {
+	int wanted_len = cmd->SCp.this_residual;
+
 	if (wanted_len < DMA_MIN_SIZE || cmd->request->cmd_type != REQ_TYPE_FS)
 		return 0;
 
-- 
2.7.3
