From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH 5/5] [ARM] rpc: acornscsi: update to new style ecard driver
Date: Mon, 12 May 2008 18:02:14 +0100
Message-ID: <git-1210611733-a9c5a6355947db11935d7749a09b96c85aeb5a6f@dyn-67.arm.linux.org.uk>
References: <git-1210611733-e5a7d2f30204ded6822bab9ce49b68c7d27f127d@dyn-67.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39308 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969AbYELROP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 May 2008 13:14:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LAK <linux-arm-kernel@lists.arm.linux.org.uk>

From: Russell King <rmk@dyn-67.arm.linux.org.uk>

Update acornscsi as per all the other ecard drivers to use MMIO
accessors rather than the obsolete 'pc io' style inb/outb accessors.

Use ecard_request_resources()/ecard_release_resources() for easier
resource handling, rather than requesting 5 separate regions
individually.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/scsi/arm/acornscsi.c |  160 +++++++++++++++++++-----------------------
 drivers/scsi/arm/acornscsi.h |    9 +--
 2 files changed, 75 insertions(+), 94 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index a2f8113..918ccf8 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -136,9 +136,9 @@
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/stringify.h>
+#include <linux/io.h>
 
 #include <asm/system.h>
-#include <asm/io.h>
 #include <asm/ecard.h>
 
 #include "../scsi.h"
@@ -198,35 +198,40 @@ static void acornscsi_abortcmd(AS_Host *host, unsigned char tag);
  * Miscellaneous
  */
 
+/* Offsets from MEMC base */
+#define SBIC_REGIDX	0x2000
+#define SBIC_REGVAL	0x2004
+#define DMAC_OFFSET	0x3000
+
+/* Offsets from FAST IOC base */
+#define INT_REG		0x2000
+#define PAGE_REG	0x3000
+
 static inline void sbic_arm_write(AS_Host *host, unsigned int reg, unsigned int value)
 {
-    __raw_writeb(reg, host->scsi.io_port);
-    __raw_writeb(value, host->scsi.io_port + 4);
+    writeb(reg, host->base + SBIC_REGIDX);
+    writeb(value, host->base + SBIC_REGVAL);
 }
 
-#define sbic_arm_writenext(host,val) \
-	__raw_writeb((val), (host)->scsi.io_port + 4)
-
 static inline int sbic_arm_read(AS_Host *host, unsigned int reg)
 {
     if(reg == SBIC_ASR)
-	   return __raw_readl(host->scsi.io_port) & 255;
-    __raw_writeb(reg, host->scsi.io_port);
-    return __raw_readl(host->scsi.io_port + 4) & 255;
+	   return readl(host->base + SBIC_REGIDX) & 255;
+    writeb(reg, host->base + SBIC_REGIDX);
+    return readl(host->base + SBIC_REGVAL) & 255;
 }
 
-#define sbic_arm_readnext(host) \
-	__raw_readb((host)->scsi.io_port + 4)
+#define sbic_arm_writenext(host, val)	writeb((val), (host)->base + SBIC_REGVAL)
+#define sbic_arm_readnext(host) 	readb((host)->base + SBIC_REGVAL)
 
 #ifdef USE_DMAC
 #define dmac_read(host,reg) \
-	inb((host)->dma.io_port + (reg))
+	readb((host)->base + DMAC_OFFSET + ((reg) << 2))
 
 #define dmac_write(host,reg,value) \
-	({ outb((value), (host)->dma.io_port + (reg)); })
+	({ writeb((value), (host)->base + DMAC_OFFSET + ((reg) << 2)); })
 
-#define dmac_clearintr(host) \
-	({ outb(0, (host)->dma.io_intr_clear); })
+#define dmac_clearintr(host) 	writeb(0, (host)->fast + INT_REG)
 
 static inline unsigned int dmac_address(AS_Host *host)
 {
@@ -323,20 +328,20 @@ void acornscsi_resetcard(AS_Host *host)
 
     /* assert reset line */
     host->card.page_reg = 0x80;
-    outb(host->card.page_reg, host->card.io_page);
+    writeb(host->card.page_reg, host->fast + PAGE_REG);
 
     /* wait 3 cs.  SCSI standard says 25ms. */
     acornscsi_csdelay(3);
 
     host->card.page_reg = 0;
-    outb(host->card.page_reg, host->card.io_page);
+    writeb(host->card.page_reg, host->fast + PAGE_REG);
 
     /*
      * Should get a reset from the card
      */
     timeout = 1000;
     do {
-	if (inb(host->card.io_intr) & 8)
+	if (readb(host->fast + INT_REG) & 8)
 	    break;
 	udelay(1);
     } while (--timeout);
@@ -357,7 +362,7 @@ void acornscsi_resetcard(AS_Host *host)
      */
     timeout = 1000;
     do {
-	if (inb(host->card.io_intr) & 8)
+	if (readb(host->fast + INT_REG) & 8)
 	    break;
 	udelay(1);
     } while (--timeout);
@@ -377,7 +382,7 @@ void acornscsi_resetcard(AS_Host *host)
     sbic_arm_write(host, SBIC_SOURCEID, SOURCEID_ER | SOURCEID_DSP);
 
     host->card.page_reg = 0x40;
-    outb(host->card.page_reg, host->card.io_page);
+    writeb(host->card.page_reg, host->fast + PAGE_REG);
 
     /* setup dmac - uPC71071 */
     dmac_write(host, DMAC_INIT, 0);
@@ -910,13 +915,13 @@ static
 void acornscsi_data_read(AS_Host *host, char *ptr,
 				 unsigned int start_addr, unsigned int length)
 {
-    extern void __acornscsi_in(int port, char *buf, int len);
+    extern void __acornscsi_in(void __iomem *, char *buf, int len);
     unsigned int page, offset, len = length;
 
     page = (start_addr >> 12);
     offset = start_addr & ((1 << 12) - 1);
 
-    outb((page & 0x3f) | host->card.page_reg, host->card.io_page);
+    writeb((page & 0x3f) | host->card.page_reg, host->fast + PAGE_REG);
 
     while (len > 0) {
 	unsigned int this_len;
@@ -926,7 +931,7 @@ void acornscsi_data_read(AS_Host *host, char *ptr,
 	else
 	    this_len = len;
 
-	__acornscsi_in(host->card.io_ram + (offset << 1), ptr, this_len);
+	__acornscsi_in(host->base + (offset << 1), ptr, this_len);
 
 	offset += this_len;
 	ptr += this_len;
@@ -935,10 +940,10 @@ void acornscsi_data_read(AS_Host *host, char *ptr,
 	if (offset == (1 << 12)) {
 	    offset = 0;
 	    page ++;
-	    outb((page & 0x3f) | host->card.page_reg, host->card.io_page);
+	    writeb((page & 0x3f) | host->card.page_reg, host->fast + PAGE_REG);
 	}
     }
-    outb(host->card.page_reg, host->card.io_page);
+    writeb(host->card.page_reg, host->fast + PAGE_REG);
 }
 
 /*
@@ -955,13 +960,13 @@ static
 void acornscsi_data_write(AS_Host *host, char *ptr,
 				 unsigned int start_addr, unsigned int length)
 {
-    extern void __acornscsi_out(int port, char *buf, int len);
+    extern void __acornscsi_out(void __iomem *, char *buf, int len);
     unsigned int page, offset, len = length;
 
     page = (start_addr >> 12);
     offset = start_addr & ((1 << 12) - 1);
 
-    outb((page & 0x3f) | host->card.page_reg, host->card.io_page);
+    writeb((page & 0x3f) | host->card.page_reg, host->fast + PAGE_REG);
 
     while (len > 0) {
 	unsigned int this_len;
@@ -971,7 +976,7 @@ void acornscsi_data_write(AS_Host *host, char *ptr,
 	else
 	    this_len = len;
 
-	__acornscsi_out(host->card.io_ram + (offset << 1), ptr, this_len);
+	__acornscsi_out(host->base + (offset << 1), ptr, this_len);
 
 	offset += this_len;
 	ptr += this_len;
@@ -980,10 +985,10 @@ void acornscsi_data_write(AS_Host *host, char *ptr,
 	if (offset == (1 << 12)) {
 	    offset = 0;
 	    page ++;
-	    outb((page & 0x3f) | host->card.page_reg, host->card.io_page);
+	    writeb((page & 0x3f) | host->card.page_reg, host->fast + PAGE_REG);
 	}
     }
-    outb(host->card.page_reg, host->card.io_page);
+    writeb(host->card.page_reg, host->fast + PAGE_REG);
 }
 
 /* =========================================================================================
@@ -2468,11 +2473,11 @@ acornscsi_intr(int irq, void *dev_id)
     do {
 	ret = INTR_IDLE;
 
-	iostatus = inb(host->card.io_intr);
+	iostatus = readb(host->fast + INT_REG);
 
 	if (iostatus & 2) {
 	    acornscsi_dma_intr(host);
-	    iostatus = inb(host->card.io_intr);
+	    iostatus = readb(host->fast + INT_REG);
 	}
 
 	if (iostatus & 8)
@@ -2858,11 +2863,11 @@ int acornscsi_proc_info(struct Scsi_Host *instance, char *buffer, char **start,
 #endif
 		"\n\n", VER_MAJOR, VER_MINOR, VER_PATCH);
 
-    p += sprintf(p,	"SBIC: WD33C93A  Address: %08X  IRQ : %d\n",
-			host->scsi.io_port, host->scsi.irq);
+    p += sprintf(p,	"SBIC: WD33C93A  Address: %p    IRQ : %d\n",
+			host->base + SBIC_REGIDX, host->scsi.irq);
 #ifdef USE_DMAC
-    p += sprintf(p,	"DMAC: uPC71071  Address: %08X  IRQ : %d\n\n",
-			host->dma.io_port, host->scsi.irq);
+    p += sprintf(p,	"DMAC: uPC71071  Address: %p  IRQ : %d\n\n",
+			host->base + DMAC_OFFSET, host->scsi.irq);
 #endif
 
     p += sprintf(p,	"Statistics:\n"
@@ -2964,48 +2969,37 @@ acornscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 {
 	struct Scsi_Host *host;
 	AS_Host *ashost;
-	int ret = -ENOMEM;
+	int ret;
 
-	host = scsi_host_alloc(&acornscsi_template, sizeof(AS_Host));
-	if (!host)
+	ret = ecard_request_resources(ec);
+	if (ret)
 		goto out;
 
+	host = scsi_host_alloc(&acornscsi_template, sizeof(AS_Host));
+	if (!host) {
+		ret = -ENOMEM;
+		goto out_release;
+	}
+
 	ashost = (AS_Host *)host->hostdata;
 
-	host->io_port = ecard_address(ec, ECARD_MEMC, 0);
-	host->irq = ec->irq;
+	ashost->base = ecardm_iomap(ec, ECARD_RES_MEMC, 0, 0);
+	ashost->fast = ecardm_iomap(ec, ECARD_RES_IOCFAST, 0, 0);
+	if (!ashost->base || !ashost->fast)
+		goto out_put;
 
-	ashost->host		= host;
-	ashost->scsi.io_port	= ioaddr(host->io_port + 0x800);
-	ashost->scsi.irq	= host->irq;
-	ashost->card.io_intr	= POD_SPACE(host->io_port) + 0x800;
-	ashost->card.io_page	= POD_SPACE(host->io_port) + 0xc00;
-	ashost->card.io_ram	= ioaddr(host->io_port);
-	ashost->dma.io_port	= host->io_port + 0xc00;
-	ashost->dma.io_intr_clear = POD_SPACE(host->io_port) + 0x800;
+	host->irq = ec->irq;
+	ashost->host = host;
+	ashost->scsi.irq = host->irq;
 
-	ec->irqaddr	= (char *)ioaddr(ashost->card.io_intr);
+	ec->irqaddr	= ashost->fast + INT_REG;
 	ec->irqmask	= 0x0a;
 
-	ret = -EBUSY;
-	if (!request_region(host->io_port + 0x800, 2, "acornscsi(sbic)"))
-		goto err_1;
-	if (!request_region(ashost->card.io_intr, 1, "acornscsi(intr)"))
-		goto err_2;
-	if (!request_region(ashost->card.io_page, 1, "acornscsi(page)"))
-		goto err_3;
-#ifdef USE_DMAC
-	if (!request_region(ashost->dma.io_port, 256, "acornscsi(dmac)"))
-		goto err_4;
-#endif
-	if (!request_region(host->io_port, 2048, "acornscsi(ram)"))
-		goto err_5;
-
 	ret = request_irq(host->irq, acornscsi_intr, IRQF_DISABLED, "acornscsi", ashost);
 	if (ret) {
 		printk(KERN_CRIT "scsi%d: IRQ%d not free: %d\n",
 			host->host_no, ashost->scsi.irq, ret);
-		goto err_6;
+		goto out_put;
 	}
 
 	memset(&ashost->stats, 0, sizeof (ashost->stats));
@@ -3017,27 +3011,22 @@ acornscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 
 	ret = scsi_add_host(host, &ec->dev);
 	if (ret)
-		goto err_7;
+		goto out_irq;
 
 	scsi_scan_host(host);
 	goto out;
 
- err_7:
+ out_irq:
 	free_irq(host->irq, ashost);
- err_6:
-	release_region(host->io_port, 2048);
- err_5:
-#ifdef USE_DMAC
-	release_region(ashost->dma.io_port, 256);
-#endif
- err_4:
-	release_region(ashost->card.io_page, 1);
- err_3:
-	release_region(ashost->card.io_intr, 1);    
- err_2:
-	release_region(host->io_port + 0x800, 2);
- err_1:
+	msgqueue_free(&ashost->scsi.msgs);
+	queue_free(&ashost->queues.disconnected);
+	queue_free(&ashost->queues.issue);
+ out_put:
+	ecardm_iounmap(ec, ashost->fast);
+	ecardm_iounmap(ec, ashost->base);
 	scsi_host_put(host);
+ out_release:
+	ecard_release_resources(ec);
  out:
 	return ret;
 }
@@ -3053,20 +3042,17 @@ static void __devexit acornscsi_remove(struct expansion_card *ec)
 	/*
 	 * Put card into RESET state
 	 */
-	outb(0x80, ashost->card.io_page);
+	writeb(0x80, ashost->fast + PAGE_REG);
 
 	free_irq(host->irq, ashost);
 
-	release_region(host->io_port + 0x800, 2);
-	release_region(ashost->card.io_intr, 1);
-	release_region(ashost->card.io_page, 1);
-	release_region(ashost->dma.io_port, 256);
-	release_region(host->io_port, 2048);
-
 	msgqueue_free(&ashost->scsi.msgs);
 	queue_free(&ashost->queues.disconnected);
 	queue_free(&ashost->queues.issue);
+	ecardm_iounmap(ec, ashost->fast);
+	ecardm_iounmap(ec, ashost->base);
 	scsi_host_put(host);
+	ecard_release_resources(ec);
 }
 
 static const struct ecard_id acornscsi_cids[] = {
diff --git a/drivers/scsi/arm/acornscsi.h b/drivers/scsi/arm/acornscsi.h
index d11424b..8d2172a 100644
--- a/drivers/scsi/arm/acornscsi.h
+++ b/drivers/scsi/arm/acornscsi.h
@@ -179,7 +179,6 @@
 
 /* miscellaneous internal variables */
 
-#define POD_SPACE(x)	((x) + 0xd0000)
 #define MASK_ON		(MASKREG_M3|MASKREG_M2|MASKREG_M1|MASKREG_M0)
 #define MASK_OFF	(MASKREG_M3|MASKREG_M2|MASKREG_M1)
 
@@ -279,10 +278,11 @@ typedef struct acornscsi_hostdata {
     struct Scsi_Host	*host;			/* host					*/
     struct scsi_cmnd	*SCpnt;			/* currently processing command		*/
     struct scsi_cmnd	*origSCpnt;		/* original connecting command		*/
+    void __iomem	*base;			/* memc base address 			*/
+    void __iomem	*fast;			/* fast ioc base address		*/
 
     /* driver information */
     struct {
-	unsigned int	io_port;		/* base address of WD33C93		*/
 	unsigned int	irq;			/* interrupt				*/
 	phase_t		phase;			/* current phase			*/
 
@@ -329,8 +329,6 @@ typedef struct acornscsi_hostdata {
 
     /* DMA info */
     struct {
-	unsigned int	io_port;		/* base address of DMA controller	*/
-	unsigned int	io_intr_clear;		/* address of DMA interrupt clear	*/
 	unsigned int	free_addr;		/* next free address			*/
 	unsigned int	start_addr;		/* start address of current transfer	*/
 	dmadir_t	direction;		/* dma direction			*/
@@ -345,9 +343,6 @@ typedef struct acornscsi_hostdata {
 
     /* card info */
     struct {
-	unsigned int	io_intr;		/* base address of interrupt id reg	*/
-	unsigned int	io_page;		/* base address of page reg		*/
-	unsigned int	io_ram;			/* base address of RAM access		*/
 	unsigned char	page_reg;		/* current setting of page reg		*/
     } card;
 
