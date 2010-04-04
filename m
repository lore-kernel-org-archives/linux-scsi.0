From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 04/21] m68k/scsi: mvme147 - Reindentation
Date: Sun,  4 Apr 2010 11:00:34 +0200
Message-ID: <1270371651-2584-5-git-send-email-geert@linux-m68k.org>
References: <1270371651-2584-1-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-2-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-3-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-4-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-4-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/mvme147.c |  166 ++++++++++++++++++++++++-----------------------
 drivers/scsi/mvme147.h |    4 +-
 2 files changed, 87 insertions(+), 83 deletions(-)

diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
index a423fcc..b236d72 100644
--- a/drivers/scsi/mvme147.c
+++ b/drivers/scsi/mvme147.c
@@ -13,111 +13,115 @@
 #include "wd33c93.h"
 #include "mvme147.h"
 
-#include<linux/stat.h>
+#include <linux/stat.h>
 
-#define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
+
+#define HDATA(ptr)	((struct WD33C93_hostdata *)((ptr)->hostdata))
 
 static struct Scsi_Host *mvme147_host = NULL;
 
-static irqreturn_t mvme147_intr (int irq, void *dummy)
+static irqreturn_t mvme147_intr(int irq, void *dummy)
 {
-    if (irq == MVME147_IRQ_SCSI_PORT)
-	wd33c93_intr (mvme147_host);
-    else
-	m147_pcc->dma_intr = 0x89;	/* Ack and enable ints */
-    return IRQ_HANDLED;
+	if (irq == MVME147_IRQ_SCSI_PORT)
+		wd33c93_intr(mvme147_host);
+	else
+		m147_pcc->dma_intr = 0x89;	/* Ack and enable ints */
+	return IRQ_HANDLED;
 }
 
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
-    unsigned char flags = 0x01;
-    unsigned long addr = virt_to_bus(cmd->SCp.ptr);
-
-    /* setup dma direction */
-    if (!dir_in)
-	flags |= 0x04;
-
-    /* remember direction */
-    HDATA(mvme147_host)->dma_dir = dir_in;
-
-    if (dir_in)
-  	/* invalidate any cache */
-	cache_clear (addr, cmd->SCp.this_residual);
-    else
-	/* push any dirty cache */
-	cache_push (addr, cmd->SCp.this_residual);
-
-    /* start DMA */
-    m147_pcc->dma_bcr   = cmd->SCp.this_residual | (1<<24);
-    m147_pcc->dma_dadr  = addr;
-    m147_pcc->dma_cntrl = flags;
-
-    /* return success */
-    return 0;
+	unsigned char flags = 0x01;
+	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
+
+	/* setup dma direction */
+	if (!dir_in)
+		flags |= 0x04;
+
+	/* remember direction */
+	HDATA(mvme147_host)->dma_dir = dir_in;
+
+	if (dir_in) {
+		/* invalidate any cache */
+		cache_clear(addr, cmd->SCp.this_residual);
+	} else {
+		/* push any dirty cache */
+		cache_push(addr, cmd->SCp.this_residual);
+	}
+
+	/* start DMA */
+	m147_pcc->dma_bcr = cmd->SCp.this_residual | (1 << 24);
+	m147_pcc->dma_dadr = addr;
+	m147_pcc->dma_cntrl = flags;
+
+	/* return success */
+	return 0;
 }
 
 static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
-		      int status)
+		     int status)
 {
-    m147_pcc->dma_cntrl = 0;
+	m147_pcc->dma_cntrl = 0;
 }
 
 int mvme147_detect(struct scsi_host_template *tpnt)
 {
-    static unsigned char called = 0;
-    wd33c93_regs regs;
-
-    if (!MACH_IS_MVME147 || called)
-	return 0;
-    called++;
-
-    tpnt->proc_name = "MVME147";
-    tpnt->proc_info = &wd33c93_proc_info;
-
-    mvme147_host = scsi_register (tpnt, sizeof(struct WD33C93_hostdata));
-    if (!mvme147_host)
-	    goto err_out;
-
-    mvme147_host->base = 0xfffe4000;
-    mvme147_host->irq = MVME147_IRQ_SCSI_PORT;
-    regs.SASR = (volatile unsigned char *)0xfffe4000;
-    regs.SCMD = (volatile unsigned char *)0xfffe4001;
-    HDATA(mvme147_host)->no_sync = 0xff;
-    HDATA(mvme147_host)->fast = 0;
-    HDATA(mvme147_host)->dma_mode = CTRL_DMA;
-    wd33c93_init(mvme147_host, regs, dma_setup, dma_stop, WD33C93_FS_8_10);
-
-    if (request_irq(MVME147_IRQ_SCSI_PORT, mvme147_intr, 0, "MVME147 SCSI PORT", mvme147_intr))
-	    goto err_unregister;
-    if (request_irq(MVME147_IRQ_SCSI_DMA, mvme147_intr, 0, "MVME147 SCSI DMA", mvme147_intr))
-	    goto err_free_irq;
+	static unsigned char called = 0;
+	wd33c93_regs regs;
+
+	if (!MACH_IS_MVME147 || called)
+		return 0;
+	called++;
+
+	tpnt->proc_name = "MVME147";
+	tpnt->proc_info = &wd33c93_proc_info;
+
+	mvme147_host = scsi_register(tpnt, sizeof(struct WD33C93_hostdata));
+	if (!mvme147_host)
+		goto err_out;
+
+	mvme147_host->base = 0xfffe4000;
+	mvme147_host->irq = MVME147_IRQ_SCSI_PORT;
+	regs.SASR = (volatile unsigned char *)0xfffe4000;
+	regs.SCMD = (volatile unsigned char *)0xfffe4001;
+	HDATA(mvme147_host)->no_sync = 0xff;
+	HDATA(mvme147_host)->fast = 0;
+	HDATA(mvme147_host)->dma_mode = CTRL_DMA;
+	wd33c93_init(mvme147_host, regs, dma_setup, dma_stop, WD33C93_FS_8_10);
+
+	if (request_irq(MVME147_IRQ_SCSI_PORT, mvme147_intr, 0,
+			"MVME147 SCSI PORT", mvme147_intr))
+		goto err_unregister;
+	if (request_irq(MVME147_IRQ_SCSI_DMA, mvme147_intr, 0,
+			"MVME147 SCSI DMA", mvme147_intr))
+		goto err_free_irq;
 #if 0	/* Disabled; causes problems booting */
-    m147_pcc->scsi_interrupt = 0x10;	/* Assert SCSI bus reset */
-    udelay(100);
-    m147_pcc->scsi_interrupt = 0x00;	/* Negate SCSI bus reset */
-    udelay(2000);
-    m147_pcc->scsi_interrupt = 0x40;	/* Clear bus reset interrupt */
+	m147_pcc->scsi_interrupt = 0x10;	/* Assert SCSI bus reset */
+	udelay(100);
+	m147_pcc->scsi_interrupt = 0x00;	/* Negate SCSI bus reset */
+	udelay(2000);
+	m147_pcc->scsi_interrupt = 0x40;	/* Clear bus reset interrupt */
 #endif
-    m147_pcc->scsi_interrupt = 0x09;	/* Enable interrupt */
+	m147_pcc->scsi_interrupt = 0x09;	/* Enable interrupt */
 
-    m147_pcc->dma_cntrl = 0x00;		/* ensure DMA is stopped */
-    m147_pcc->dma_intr = 0x89;		/* Ack and enable ints */
+	m147_pcc->dma_cntrl = 0x00;	/* ensure DMA is stopped */
+	m147_pcc->dma_intr = 0x89;	/* Ack and enable ints */
 
-    return 1;
+	return 1;
 
- err_free_irq:
-    free_irq(MVME147_IRQ_SCSI_PORT, mvme147_intr);
- err_unregister:
-    scsi_unregister(mvme147_host);
- err_out:
-    return 0;
+err_free_irq:
+	free_irq(MVME147_IRQ_SCSI_PORT, mvme147_intr);
+err_unregister:
+	scsi_unregister(mvme147_host);
+err_out:
+	return 0;
 }
 
 static int mvme147_bus_reset(struct scsi_cmnd *cmd)
 {
 	/* FIXME perform bus-specific reset */
 
-	/* FIXME 2: kill this function, and let midlayer fallback to 
+	/* FIXME 2: kill this function, and let midlayer fallback to
 	   the same result, calling wd33c93_host_reset() */
 
 	spin_lock_irq(cmd->device->host->host_lock);
@@ -153,9 +157,9 @@ static struct scsi_host_template driver_template = {
 int mvme147_release(struct Scsi_Host *instance)
 {
 #ifdef MODULE
-    /* XXX Make sure DMA is stopped! */
-    free_irq(MVME147_IRQ_SCSI_PORT, mvme147_intr);
-    free_irq(MVME147_IRQ_SCSI_DMA, mvme147_intr);
+	/* XXX Make sure DMA is stopped! */
+	free_irq(MVME147_IRQ_SCSI_PORT, mvme147_intr);
+	free_irq(MVME147_IRQ_SCSI_DMA, mvme147_intr);
 #endif
-    return 1;
+	return 1;
 }
diff --git a/drivers/scsi/mvme147.h b/drivers/scsi/mvme147.h
index 32aee85..bfd4566 100644
--- a/drivers/scsi/mvme147.h
+++ b/drivers/scsi/mvme147.h
@@ -14,11 +14,11 @@ int mvme147_detect(struct scsi_host_template *);
 int mvme147_release(struct Scsi_Host *);
 
 #ifndef CMD_PER_LUN
-#define CMD_PER_LUN 2
+#define CMD_PER_LUN		2
 #endif
 
 #ifndef CAN_QUEUE
-#define CAN_QUEUE 16
+#define CAN_QUEUE		16
 #endif
 
 #endif /* MVME147_H */
-- 
1.6.0.4
