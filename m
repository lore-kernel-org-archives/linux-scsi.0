From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 07/12] scsi/ncr5380: Store IO ports and addresses in host
 private data
Date: Thu,  6 Oct 2016 19:41:07 -0400 (EDT)
Message-ID: <51c5435779b8823f4b2e1679159c82e0b13e5867.1475791899.git.fthain@telegraphics.com.au>
References: <cover.1475791899.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <cover.1475791899.git.fthain@telegraphics.com.au>
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

The various 5380 drivers inconsistently store register pointers
either in the Scsi_Host struct "legacy crap" area or in special,
board-specific members of the NCR5380_hostdata struct. Uniform
use of the latter struct makes for simpler and faster code (see
the following patches) and helps to reduce use of the
NCR5380_implementation_fields macro.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/NCR5380.c      |  8 +++---
 drivers/scsi/NCR5380.h      |  5 ++++
 drivers/scsi/arm/cumana_1.c | 60 ++++++++++++++++++++--------------------
 drivers/scsi/arm/oak.c      | 23 ++++++++--------
 drivers/scsi/dmx3191d.c     | 14 +++++++---
 drivers/scsi/g_NCR5380.c    | 67 +++++++++++++++++++++++----------------------
 drivers/scsi/g_NCR5380.h    |  6 ++--
 drivers/scsi/mac_scsi.c     | 27 ++++++++++--------
 drivers/scsi/sun3_scsi.c    |  5 +++-
 9 files changed, 118 insertions(+), 97 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 25ee5be..82fd37d 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -437,14 +437,14 @@ static void prepare_info(struct Scsi_Host *instance)
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
 	snprintf(hostdata->info, sizeof(hostdata->info),
-	         "%s, io_port 0x%lx, n_io_port %d, "
-	         "base 0x%lx, irq %d, "
+	         "%s, irq %d, "
+		 "io_port 0x%lx, base 0x%lx, "
 	         "can_queue %d, cmd_per_lun %d, "
 	         "sg_tablesize %d, this_id %d, "
 	         "flags { %s%s%s}, "
 	         "options { %s} ",
-	         instance->hostt->name, instance->io_port, instance->n_io_port,
-	         instance->base, instance->irq,
+	         instance->hostt->name, instance->irq,
+		 hostdata->io_port, hostdata->base,
 	         instance->can_queue, instance->cmd_per_lun,
 	         instance->sg_tablesize, instance->this_id,
 	         hostdata->flags & FLAG_DMA_FIXUP     ? "DMA_FIXUP "     : "",
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index ceafa0c..02f20ff 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -220,6 +220,8 @@
 
 struct NCR5380_hostdata {
 	NCR5380_implementation_fields;		/* Board-specific data */
+	u8 __iomem *io;				/* Remapped 5380 address */
+	u8 __iomem *pdma_io;			/* Remapped PDMA address */
 	unsigned long poll_loops;		/* Register polling limit */
 	spinlock_t lock;			/* Protects this struct */
 	struct scsi_cmnd *connected;		/* Currently connected cmnd */
@@ -230,6 +232,8 @@ struct NCR5380_hostdata {
 	int flags;				/* Board-specific quirks */
 	int dma_len;				/* Requested length of DMA */
 	int read_overruns;	/* Transfer size reduction for DMA erratum */
+	unsigned long io_port;			/* Device IO port */
+	unsigned long base;			/* Device base address */
 	struct list_head unissued;		/* Waiting to be issued */
 	struct scsi_cmnd *selecting;		/* Cmnd to be connected */
 	struct list_head autosense;		/* Priority cmnd queue */
@@ -239,6 +243,7 @@ struct NCR5380_hostdata {
 	unsigned char id_mask;			/* 1 << Host ID */
 	unsigned char id_higher_mask;		/* All bits above id_mask */
 	unsigned char last_message;		/* Last Message Out */
+	unsigned long region_size;		/* Size of address/port range */
 	char info[256];
 };
 
diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index f616756..88db281 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -27,9 +27,7 @@
 #define NCR5380_info			cumanascsi_info
 
 #define NCR5380_implementation_fields	\
-	unsigned ctrl;			\
-	void __iomem *base;		\
-	void __iomem *dma
+	unsigned ctrl
 
 #include "../NCR5380.h"
 
@@ -42,17 +40,18 @@ static inline int cumanascsi_pwrite(struct Scsi_Host *host,
                                     unsigned char *addr, int len)
 {
   unsigned long *laddr;
-  void __iomem *dma = priv(host)->dma + 0x2000;
+  u8 __iomem *base = priv(host)->io;
+  u8 __iomem *dma = priv(host)->pdma_io + 0x2000;
 
   if(!len) return 0;
 
-  writeb(0x02, priv(host)->base + CTRL);
+  writeb(0x02, base + CTRL);
   laddr = (unsigned long *)addr;
   while(len >= 32)
   {
     unsigned int status;
     unsigned long v;
-    status = readb(priv(host)->base + STAT);
+    status = readb(base + STAT);
     if(status & 0x80)
       goto end;
     if(!(status & 0x40))
@@ -71,12 +70,12 @@ static inline int cumanascsi_pwrite(struct Scsi_Host *host,
   }
 
   addr = (unsigned char *)laddr;
-  writeb(0x12, priv(host)->base + CTRL);
+  writeb(0x12, base + CTRL);
 
   while(len > 0)
   {
     unsigned int status;
-    status = readb(priv(host)->base + STAT);
+    status = readb(base + STAT);
     if(status & 0x80)
       goto end;
     if(status & 0x40)
@@ -86,7 +85,7 @@ static inline int cumanascsi_pwrite(struct Scsi_Host *host,
         break;
     }
 
-    status = readb(priv(host)->base + STAT);
+    status = readb(base + STAT);
     if(status & 0x80)
       goto end;
     if(status & 0x40)
@@ -97,7 +96,7 @@ static inline int cumanascsi_pwrite(struct Scsi_Host *host,
     }
   }
 end:
-  writeb(priv(host)->ctrl | 0x40, priv(host)->base + CTRL);
+  writeb(priv(host)->ctrl | 0x40, base + CTRL);
 
 	if (len)
 		return -1;
@@ -108,16 +107,17 @@ static inline int cumanascsi_pread(struct Scsi_Host *host,
                                    unsigned char *addr, int len)
 {
   unsigned long *laddr;
-  void __iomem *dma = priv(host)->dma + 0x2000;
+  u8 __iomem *base = priv(host)->io;
+  u8 __iomem *dma = priv(host)->pdma_io + 0x2000;
 
   if(!len) return 0;
 
-  writeb(0x00, priv(host)->base + CTRL);
+  writeb(0x00, base + CTRL);
   laddr = (unsigned long *)addr;
   while(len >= 32)
   {
     unsigned int status;
-    status = readb(priv(host)->base + STAT);
+    status = readb(base + STAT);
     if(status & 0x80)
       goto end;
     if(!(status & 0x40))
@@ -136,12 +136,12 @@ static inline int cumanascsi_pread(struct Scsi_Host *host,
   }
 
   addr = (unsigned char *)laddr;
-  writeb(0x10, priv(host)->base + CTRL);
+  writeb(0x10, base + CTRL);
 
   while(len > 0)
   {
     unsigned int status;
-    status = readb(priv(host)->base + STAT);
+    status = readb(base + STAT);
     if(status & 0x80)
       goto end;
     if(status & 0x40)
@@ -151,7 +151,7 @@ static inline int cumanascsi_pread(struct Scsi_Host *host,
         break;
     }
 
-    status = readb(priv(host)->base + STAT);
+    status = readb(base + STAT);
     if(status & 0x80)
       goto end;
     if(status & 0x40)
@@ -162,7 +162,7 @@ static inline int cumanascsi_pread(struct Scsi_Host *host,
     }
   }
 end:
-  writeb(priv(host)->ctrl | 0x40, priv(host)->base + CTRL);
+  writeb(priv(host)->ctrl | 0x40, base + CTRL);
 
 	if (len)
 		return -1;
@@ -171,7 +171,7 @@ end:
 
 static unsigned char cumanascsi_read(struct Scsi_Host *host, unsigned int reg)
 {
-	void __iomem *base = priv(host)->base;
+	u8 __iomem *base = priv(host)->io;
 	unsigned char val;
 
 	writeb(0, base + CTRL);
@@ -186,7 +186,7 @@ static unsigned char cumanascsi_read(struct Scsi_Host *host, unsigned int reg)
 
 static void cumanascsi_write(struct Scsi_Host *host, unsigned int reg, unsigned int value)
 {
-	void __iomem *base = priv(host)->base;
+	u8 __iomem *base = priv(host)->io;
 
 	writeb(0, base + CTRL);
 
@@ -231,11 +231,11 @@ static int cumanascsi1_probe(struct expansion_card *ec,
 		goto out_release;
 	}
 
-	priv(host)->base = ioremap(ecard_resource_start(ec, ECARD_RES_IOCSLOW),
-				   ecard_resource_len(ec, ECARD_RES_IOCSLOW));
-	priv(host)->dma = ioremap(ecard_resource_start(ec, ECARD_RES_MEMC),
-				  ecard_resource_len(ec, ECARD_RES_MEMC));
-	if (!priv(host)->base || !priv(host)->dma) {
+	priv(host)->io = ioremap(ecard_resource_start(ec, ECARD_RES_IOCSLOW),
+	                         ecard_resource_len(ec, ECARD_RES_IOCSLOW));
+	priv(host)->pdma_io = ioremap(ecard_resource_start(ec, ECARD_RES_MEMC),
+	                              ecard_resource_len(ec, ECARD_RES_MEMC));
+	if (!priv(host)->io || !priv(host)->pdma_io) {
 		ret = -ENOMEM;
 		goto out_unmap;
 	}
@@ -249,7 +249,7 @@ static int cumanascsi1_probe(struct expansion_card *ec,
 	NCR5380_maybe_reset_bus(host);
 
         priv(host)->ctrl = 0;
-        writeb(0, priv(host)->base + CTRL);
+        writeb(0, priv(host)->io + CTRL);
 
 	ret = request_irq(host->irq, cumanascsi_intr, 0,
 			  "CumanaSCSI-1", host);
@@ -271,8 +271,8 @@ static int cumanascsi1_probe(struct expansion_card *ec,
  out_exit:
 	NCR5380_exit(host);
  out_unmap:
-	iounmap(priv(host)->base);
-	iounmap(priv(host)->dma);
+	iounmap(priv(host)->io);
+	iounmap(priv(host)->pdma_io);
 	scsi_host_put(host);
  out_release:
 	ecard_release_resources(ec);
@@ -283,15 +283,17 @@ static int cumanascsi1_probe(struct expansion_card *ec,
 static void cumanascsi1_remove(struct expansion_card *ec)
 {
 	struct Scsi_Host *host = ecard_get_drvdata(ec);
+	void __iomem *base = priv(host)->io;
+	void __iomem *dma = priv(host)->pdma_io;
 
 	ecard_set_drvdata(ec, NULL);
 
 	scsi_remove_host(host);
 	free_irq(host->irq, host);
 	NCR5380_exit(host);
-	iounmap(priv(host)->base);
-	iounmap(priv(host)->dma);
 	scsi_host_put(host);
+	iounmap(base);
+	iounmap(dma);
 	ecard_release_resources(ec);
 }
 
diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
index a396024..1c4a44a 100644
--- a/drivers/scsi/arm/oak.c
+++ b/drivers/scsi/arm/oak.c
@@ -17,9 +17,9 @@
 #define priv(host)			((struct NCR5380_hostdata *)(host)->hostdata)
 
 #define NCR5380_read(reg) \
-	readb(priv(instance)->base + ((reg) << 2))
+	readb(priv(instance)->io + ((reg) << 2))
 #define NCR5380_write(reg, value) \
-	writeb(value, priv(instance)->base + ((reg) << 2))
+	writeb(value, priv(instance)->io + ((reg) << 2))
 
 #define NCR5380_dma_xfer_len(instance, cmd, phase)	(0)
 #define NCR5380_dma_recv_setup		oakscsi_pread
@@ -29,8 +29,7 @@
 #define NCR5380_queue_command		oakscsi_queue_command
 #define NCR5380_info			oakscsi_info
 
-#define NCR5380_implementation_fields	\
-	void __iomem *base
+#define NCR5380_implementation_fields	/* none */
 
 #include "../NCR5380.h"
 
@@ -43,7 +42,7 @@
 static inline int oakscsi_pwrite(struct Scsi_Host *instance,
                                  unsigned char *addr, int len)
 {
-  void __iomem *base = priv(instance)->base;
+  u8 __iomem *base = priv(instance)->io;
 
 printk("writing %p len %d\n",addr, len);
 
@@ -58,7 +57,7 @@ printk("writing %p len %d\n",addr, len);
 static inline int oakscsi_pread(struct Scsi_Host *instance,
                                 unsigned char *addr, int len)
 {
-  void __iomem *base = priv(instance)->base;
+  u8 __iomem *base = priv(instance)->io;
 printk("reading %p len %d\n", addr, len);
   while(len > 0)
   {
@@ -133,15 +132,14 @@ static int oakscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 		goto release;
 	}
 
-	priv(host)->base = ioremap(ecard_resource_start(ec, ECARD_RES_MEMC),
-				   ecard_resource_len(ec, ECARD_RES_MEMC));
-	if (!priv(host)->base) {
+	priv(host)->io = ioremap(ecard_resource_start(ec, ECARD_RES_MEMC),
+	                         ecard_resource_len(ec, ECARD_RES_MEMC));
+	if (!priv(host)->io) {
 		ret = -ENOMEM;
 		goto unreg;
 	}
 
 	host->irq = NO_IRQ;
-	host->n_io_port = 255;
 
 	ret = NCR5380_init(host, FLAG_DMA_FIXUP | FLAG_LATE_DMA_SETUP);
 	if (ret)
@@ -159,7 +157,7 @@ static int oakscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
  out_exit:
 	NCR5380_exit(host);
  out_unmap:
-	iounmap(priv(host)->base);
+	iounmap(priv(host)->io);
  unreg:
 	scsi_host_put(host);
  release:
@@ -171,13 +169,14 @@ static int oakscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 static void oakscsi_remove(struct expansion_card *ec)
 {
 	struct Scsi_Host *host = ecard_get_drvdata(ec);
+	void __iomem *base = priv(host)->io;
 
 	ecard_set_drvdata(ec, NULL);
 	scsi_remove_host(host);
 
 	NCR5380_exit(host);
-	iounmap(priv(host)->base);
 	scsi_host_put(host);
+	iounmap(base);
 	ecard_release_resources(ec);
 }
 
diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
index 9b5a457..3b6df90 100644
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -34,8 +34,10 @@
  * Definitions for the generic 5380 driver.
  */
 
-#define NCR5380_read(reg)		inb(instance->io_port + reg)
-#define NCR5380_write(reg, value)	outb(value, instance->io_port + reg)
+#define priv(instance)	((struct NCR5380_hostdata *)shost_priv(instance))
+
+#define NCR5380_read(reg)		inb(priv(instance)->base + (reg))
+#define NCR5380_write(reg, value)	outb(value, priv(instance)->base + (reg))
 
 #define NCR5380_dma_xfer_len(instance, cmd, phase)	(0)
 #define NCR5380_dma_recv_setup(instance, dst, len)	(0)
@@ -71,6 +73,7 @@ static int dmx3191d_probe_one(struct pci_dev *pdev,
 			      const struct pci_device_id *id)
 {
 	struct Scsi_Host *shost;
+	struct NCR5380_hostdata *hostdata;
 	unsigned long io;
 	int error = -ENODEV;
 
@@ -88,7 +91,9 @@ static int dmx3191d_probe_one(struct pci_dev *pdev,
 			sizeof(struct NCR5380_hostdata));
 	if (!shost)
 		goto out_release_region;       
-	shost->io_port = io;
+
+	hostdata = shost_priv(shost);
+	hostdata->base = io;
 
 	/* This card does not seem to raise an interrupt on pdev->irq.
 	 * Steam-powered SCSI controllers run without an IRQ anyway.
@@ -125,7 +130,8 @@ out_host_put:
 static void dmx3191d_remove_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
-	unsigned long io = shost->io_port;
+	struct NCR5380_hostdata *hostdata = shost_priv(shost);
+	unsigned long io = hostdata->base;
 
 	scsi_remove_host(shost);
 
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 4d7a9de..98aef0e 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -115,7 +115,7 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 	unsigned long region_size;
 	struct Scsi_Host *instance;
 	struct NCR5380_hostdata *hostdata;
-	void __iomem *iomem;
+	u8 __iomem *iomem;
 
 	switch (board) {
 	case BOARD_NCR5380:
@@ -201,11 +201,11 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 	}
 	hostdata = shost_priv(instance);
 
-	hostdata->iomem = iomem;
+	hostdata->io = iomem;
+	hostdata->region_size = region_size;
 
 	if (is_pmio) {
-		instance->io_port = base;
-		instance->n_io_port = region_size;
+		hostdata->io_port = base;
 		hostdata->io_width = 1; /* 8-bit PDMA by default */
 		hostdata->offset = 0;
 
@@ -215,7 +215,7 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 		 */
 		switch (board) {
 		case BOARD_NCR53C400:
-			instance->io_port += 8;
+			hostdata->io_port += 8;
 			hostdata->c400_ctl_status = 0;
 			hostdata->c400_blk_cnt = 1;
 			hostdata->c400_host_buf = 4;
@@ -231,8 +231,7 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 			break;
 		}
 	} else {
-		instance->base = base;
-		hostdata->iomem_size = region_size;
+		hostdata->base = base;
 		hostdata->offset = NCR53C400_mem_base;
 		switch (board) {
 		case BOARD_NCR53C400:
@@ -314,17 +313,21 @@ out_release:
 static void generic_NCR5380_release_resources(struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	void __iomem *iomem = hostdata->io;
+	unsigned long io_port = hostdata->io_port;
+	unsigned long base = hostdata->base;
+	unsigned long region_size = hostdata->region_size;
 
 	scsi_remove_host(instance);
 	if (instance->irq != NO_IRQ)
 		free_irq(instance->irq, instance);
 	NCR5380_exit(instance);
-	iounmap(hostdata->iomem);
-	if (instance->io_port)
-		release_region(instance->io_port, instance->n_io_port);
-	else
-		release_mem_region(instance->base, hostdata->iomem_size);
 	scsi_host_put(instance);
+	iounmap(iomem);
+	if (io_port)
+		release_region(io_port, region_size);
+	else
+		release_mem_region(base, region_size);
 }
 
 /**
@@ -356,15 +359,15 @@ static inline int generic_NCR5380_pread(struct Scsi_Host *instance,
 		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 			; /* FIXME - no timeout */
 
-		if (instance->io_port && hostdata->io_width == 2)
-			insw(instance->io_port + hostdata->c400_host_buf,
+		if (hostdata->io_port && hostdata->io_width == 2)
+			insw(hostdata->io_port + hostdata->c400_host_buf,
 							dst + start, 64);
-		else if (instance->io_port)
-			insb(instance->io_port + hostdata->c400_host_buf,
+		else if (hostdata->io_port)
+			insb(hostdata->io_port + hostdata->c400_host_buf,
 							dst + start, 128);
 		else
 			memcpy_fromio(dst + start,
-				hostdata->iomem + NCR53C400_host_buffer, 128);
+				hostdata->io + NCR53C400_host_buffer, 128);
 
 		start += 128;
 		blocks--;
@@ -374,15 +377,15 @@ static inline int generic_NCR5380_pread(struct Scsi_Host *instance,
 		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 			; /* FIXME - no timeout */
 
-		if (instance->io_port && hostdata->io_width == 2)
-			insw(instance->io_port + hostdata->c400_host_buf,
+		if (hostdata->io_port && hostdata->io_width == 2)
+			insw(hostdata->io_port + hostdata->c400_host_buf,
 							dst + start, 64);
-		else if (instance->io_port)
-			insb(instance->io_port + hostdata->c400_host_buf,
+		else if (hostdata->io_port)
+			insb(hostdata->io_port + hostdata->c400_host_buf,
 							dst + start, 128);
 		else
 			memcpy_fromio(dst + start,
-				hostdata->iomem + NCR53C400_host_buffer, 128);
+				hostdata->io + NCR53C400_host_buffer, 128);
 
 		start += 128;
 		blocks--;
@@ -431,14 +434,14 @@ static inline int generic_NCR5380_pwrite(struct Scsi_Host *instance,
 		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 			; // FIXME - timeout
 
-		if (instance->io_port && hostdata->io_width == 2)
-			outsw(instance->io_port + hostdata->c400_host_buf,
+		if (hostdata->io_port && hostdata->io_width == 2)
+			outsw(hostdata->io_port + hostdata->c400_host_buf,
 							src + start, 64);
-		else if (instance->io_port)
-			outsb(instance->io_port + hostdata->c400_host_buf,
+		else if (hostdata->io_port)
+			outsb(hostdata->io_port + hostdata->c400_host_buf,
 							src + start, 128);
 		else
-			memcpy_toio(hostdata->iomem + NCR53C400_host_buffer,
+			memcpy_toio(hostdata->io + NCR53C400_host_buffer,
 			            src + start, 128);
 
 		start += 128;
@@ -448,14 +451,14 @@ static inline int generic_NCR5380_pwrite(struct Scsi_Host *instance,
 		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 			; // FIXME - no timeout
 
-		if (instance->io_port && hostdata->io_width == 2)
-			outsw(instance->io_port + hostdata->c400_host_buf,
+		if (hostdata->io_port && hostdata->io_width == 2)
+			outsw(hostdata->io_port + hostdata->c400_host_buf,
 							src + start, 64);
-		else if (instance->io_port)
-			outsb(instance->io_port + hostdata->c400_host_buf,
+		else if (hostdata->io_port)
+			outsb(hostdata->io_port + hostdata->c400_host_buf,
 							src + start, 128);
 		else
-			memcpy_toio(hostdata->iomem + NCR53C400_host_buffer,
+			memcpy_toio(hostdata->io + NCR53C400_host_buffer,
 			            src + start, 128);
 
 		start += 128;
diff --git a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
index 2b777824..ec4d70b 100644
--- a/drivers/scsi/g_NCR5380.h
+++ b/drivers/scsi/g_NCR5380.h
@@ -17,18 +17,16 @@
 #define DRV_MODULE_NAME "g_NCR5380"
 
 #define NCR5380_read(reg) \
-	ioread8(((struct NCR5380_hostdata *)shost_priv(instance))->iomem + \
+	ioread8(((struct NCR5380_hostdata *)shost_priv(instance))->io + \
 		((struct NCR5380_hostdata *)shost_priv(instance))->offset + \
 		(reg))
 #define NCR5380_write(reg, value) \
-	iowrite8(value, ((struct NCR5380_hostdata *)shost_priv(instance))->iomem + \
+	iowrite8(value, ((struct NCR5380_hostdata *)shost_priv(instance))->io + \
 		((struct NCR5380_hostdata *)shost_priv(instance))->offset + \
 		(reg))
 
 #define NCR5380_implementation_fields \
 	int offset; \
-	void __iomem *iomem; \
-	resource_size_t iomem_size; \
 	int c400_ctl_status; \
 	int c400_blk_cnt; \
 	int c400_host_buf; \
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index a590089..80e10d9 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -28,8 +28,7 @@
 
 /* Definitions for the core NCR5380 driver. */
 
-#define NCR5380_implementation_fields   unsigned char *pdma_base; \
-                                        int pdma_residual
+#define NCR5380_implementation_fields   int pdma_residual
 
 #define NCR5380_read(reg)               macscsi_read(instance, reg)
 #define NCR5380_write(reg, value)       macscsi_write(instance, reg, value)
@@ -67,12 +66,16 @@ module_param(setup_toshiba_delay, int, 0);
 
 static inline char macscsi_read(struct Scsi_Host *instance, int reg)
 {
-	return in_8(instance->base + (reg << 4));
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+
+	return in_8(hostdata->io + (reg << 4));
 }
 
 static inline void macscsi_write(struct Scsi_Host *instance, int reg, int value)
 {
-	out_8(instance->base + (reg << 4), value);
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+
+	out_8(hostdata->io + (reg << 4), value);
 }
 
 #ifndef MODULE
@@ -171,7 +174,7 @@ static int macscsi_pread(struct Scsi_Host *instance,
                          unsigned char *dst, int len)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-	unsigned char *s = hostdata->pdma_base + (INPUT_DATA_REG << 4);
+	unsigned char *s = hostdata->pdma_io + (INPUT_DATA_REG << 4);
 	unsigned char *d = dst;
 	int n = len;
 	int transferred;
@@ -275,7 +278,7 @@ static int macscsi_pwrite(struct Scsi_Host *instance,
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char *s = src;
-	unsigned char *d = hostdata->pdma_base + (OUTPUT_DATA_REG << 4);
+	unsigned char *d = hostdata->pdma_io + (OUTPUT_DATA_REG << 4);
 	int n = len;
 	int transferred;
 
@@ -356,6 +359,7 @@ static struct scsi_host_template mac_scsi_template = {
 static int __init mac_scsi_probe(struct platform_device *pdev)
 {
 	struct Scsi_Host *instance;
+	struct NCR5380_hostdata *hostdata;
 	int error;
 	int host_flags = 0;
 	struct resource *irq, *pio_mem, *pdma_mem = NULL;
@@ -388,17 +392,18 @@ static int __init mac_scsi_probe(struct platform_device *pdev)
 	if (!instance)
 		return -ENOMEM;
 
-	instance->base = pio_mem->start;
 	if (irq)
 		instance->irq = irq->start;
 	else
 		instance->irq = NO_IRQ;
 
-	if (pdma_mem && setup_use_pdma) {
-		struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	hostdata = shost_priv(instance);
+	hostdata->base = pio_mem->start;
+	hostdata->io = (void *)pio_mem->start;
 
-		hostdata->pdma_base = (unsigned char *)pdma_mem->start;
-	} else
+	if (pdma_mem && setup_use_pdma)
+		hostdata->pdma_io = (void *)pdma_mem->start;
+	else
 		host_flags |= FLAG_NO_PSEUDO_DMA;
 
 	host_flags |= setup_toshiba_delay > 0 ? FLAG_TOSHIBA_DELAY : 0;
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 3c4c070..efee144 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -428,6 +428,7 @@ static struct scsi_host_template sun3_scsi_template = {
 static int __init sun3_scsi_probe(struct platform_device *pdev)
 {
 	struct Scsi_Host *instance;
+	struct NCR5380_hostdata *hostdata;
 	int error;
 	struct resource *irq, *mem;
 	unsigned char *ioaddr;
@@ -502,9 +503,11 @@ static int __init sun3_scsi_probe(struct platform_device *pdev)
 		goto fail_alloc;
 	}
 
-	instance->io_port = (unsigned long)ioaddr;
 	instance->irq = irq->start;
 
+	hostdata = shost_priv(instance);
+	hostdata->base = (unsigned long)ioaddr;
+
 	error = NCR5380_init(instance, host_flags);
 	if (error)
 		goto fail_init;
-- 
2.7.3
