From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 16/21] m68k/scsi: a2091 - Kill a2091_scsiregs typedef
Date: Sun,  4 Apr 2010 11:00:46 +0200
Message-ID: <1270371651-2584-17-git-send-email-geert@linux-m68k.org>
References: <1270371651-2584-1-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-2-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-3-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-4-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-5-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-6-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-7-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-8-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-9-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-10-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-11-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-12-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-13-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-14-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-15-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-16-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-16-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/a2091.c |   12 ++++++------
 drivers/scsi/a2091.h |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index e762cae..ff2cdbb 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -26,7 +26,7 @@ static int a2091_release(struct Scsi_Host *instance);
 static irqreturn_t a2091_intr(int irq, void *data)
 {
 	struct Scsi_Host *instance = data;
-	a2091_scsiregs *regs = (a2091_scsiregs *)(instance->base);
+	struct a2091_scsiregs *regs = (struct a2091_scsiregs *)(instance->base);
 	unsigned int status = regs->ISTR;
 	unsigned long flags;
 
@@ -43,7 +43,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
 	struct Scsi_Host *instance = cmd->device->host;
 	struct WD33C93_hostdata *hdata = shost_priv(instance);
-	a2091_scsiregs *regs = (a2091_scsiregs *)(instance->base);
+	struct a2091_scsiregs *regs = (struct a2091_scsiregs *)(instance->base);
 	unsigned short cntr = CNTR_PDMD | CNTR_INTEN;
 	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
 
@@ -108,7 +108,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		     int status)
 {
 	struct WD33C93_hostdata *hdata = shost_priv(instance);
-	a2091_scsiregs *regs = (a2091_scsiregs *)(instance->base);
+	struct a2091_scsiregs *regs = (struct a2091_scsiregs *)(instance->base);
 
 	/* disable SCSI interrupts */
 	unsigned short cntr = CNTR_PDMD;
@@ -153,7 +153,7 @@ static int __init a2091_detect(struct scsi_host_template *tpnt)
 	unsigned long address;
 	struct zorro_dev *z = NULL;
 	wd33c93_regs wdregs;
-	a2091_scsiregs *regs;
+	struct a2091_scsiregs *regs;
 	struct WD33C93_hostdata *hdata;
 	int num_a2091 = 0;
 
@@ -178,7 +178,7 @@ static int __init a2091_detect(struct scsi_host_template *tpnt)
 		instance->base = ZTWO_VADDR(address);
 		instance->irq = IRQ_AMIGA_PORTS;
 		instance->unique_id = z->slotaddr;
-		regs = (a2091_scsiregs *)(instance->base);
+		regs = (struct a2091_scsiregs *)(instance->base);
 		regs->DAWR = DAWR_A2091;
 		wdregs.SASR = &regs->SASR;
 		wdregs.SCMD = &regs->SCMD;
@@ -242,7 +242,7 @@ static struct scsi_host_template driver_template = {
 static int a2091_release(struct Scsi_Host *instance)
 {
 #ifdef MODULE
-	a2091_scsiregs *regs = (a2091_scsiregs *)(instance->base);
+	struct a2091_scsiregs *regs = (struct a2091_scsiregs *)(instance->base);
 
 	regs->CNTR = 0;
 	release_mem_region(ZTWO_PADDR(instance->base), 256);
diff --git a/drivers/scsi/a2091.h b/drivers/scsi/a2091.h
index 1c3daa1..794b8e6 100644
--- a/drivers/scsi/a2091.h
+++ b/drivers/scsi/a2091.h
@@ -25,7 +25,7 @@
  */
 #define A2091_XFER_MASK		(0xff000001)
 
-typedef struct {
+struct a2091_scsiregs {
 		 unsigned char	pad1[64];
 	volatile unsigned short	ISTR;
 	volatile unsigned short	CNTR;
@@ -44,7 +44,7 @@ typedef struct {
 	volatile unsigned short	CINT;
 		 unsigned char	pad7[2];
 	volatile unsigned short	FLUSH;
-} a2091_scsiregs;
+};
 
 #define DAWR_A2091		(3)
 
-- 
1.6.0.4
