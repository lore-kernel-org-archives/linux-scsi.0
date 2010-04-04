From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 18/21] m68k/scsi: a3000 - Kill a3000_scsiregs typedef
Date: Sun,  4 Apr 2010 11:00:48 +0200
Message-ID: <1270371651-2584-19-git-send-email-geert@linux-m68k.org>
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
 <1270371651-2584-17-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-18-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-18-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/a3000.c |   12 ++++++------
 drivers/scsi/a3000.h |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 008a999..cf3a345 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -26,7 +26,7 @@ static int a3000_release(struct Scsi_Host *instance);
 static irqreturn_t a3000_intr(int irq, void *data)
 {
 	struct Scsi_Host *instance = data;
-	a3000_scsiregs *regs = (a3000_scsiregs *)(instance->base);
+	struct a3000_scsiregs *regs = (struct a3000_scsiregs *)(instance->base);
 	unsigned int status = regs->ISTR;
 	unsigned long flags;
 
@@ -46,7 +46,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
 	struct Scsi_Host *instance = cmd->device->host;
 	struct WD33C93_hostdata *hdata = shost_priv(instance);
-	a3000_scsiregs *regs = (a3000_scsiregs *)(instance->base);
+	struct a3000_scsiregs *regs = (struct a3000_scsiregs *)(instance->base);
 	unsigned short cntr = CNTR_PDMD | CNTR_INTEN;
 	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
 
@@ -109,7 +109,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		     int status)
 {
 	struct WD33C93_hostdata *hdata = shost_priv(instance);
-	a3000_scsiregs *regs = (a3000_scsiregs *)(instance->base);
+	struct a3000_scsiregs *regs = (struct a3000_scsiregs *)(instance->base);
 
 	/* disable SCSI interrupts */
 	unsigned short cntr = CNTR_PDMD;
@@ -165,7 +165,7 @@ static int __init a3000_detect(struct scsi_host_template *tpnt)
 {
 	struct Scsi_Host *instance;
 	wd33c93_regs wdregs;
-	a3000_scsiregs *regs;
+	struct a3000_scsiregs *regs;
 	struct WD33C93_hostdata *hdata;
 
 	if (!MACH_IS_AMIGA || !AMIGAHW_PRESENT(A3000_SCSI))
@@ -182,7 +182,7 @@ static int __init a3000_detect(struct scsi_host_template *tpnt)
 
 	instance->base = ZTWO_VADDR(0xDD0000);
 	instance->irq = IRQ_AMIGA_PORTS;
-	regs = (a3000_scsiregs *)(instance->base);
+	regs = (struct a3000_scsiregs *)(instance->base);
 	regs->DAWR = DAWR_A3000;
 	wdregs.SASR = &regs->SASR;
 	wdregs.SCMD = &regs->SCMD;
@@ -242,7 +242,7 @@ static struct scsi_host_template driver_template = {
 
 static int a3000_release(struct Scsi_Host *instance)
 {
-	a3000_scsiregs *regs = (a3000_scsiregs *)(instance->base);
+	struct a3000_scsiregs *regs = (struct a3000_scsiregs *)(instance->base);
 
 	regs->CNTR = 0;
 	release_mem_region(0xDD0000, 256);
diff --git a/drivers/scsi/a3000.h b/drivers/scsi/a3000.h
index 684813e..49db4a3 100644
--- a/drivers/scsi/a3000.h
+++ b/drivers/scsi/a3000.h
@@ -25,7 +25,7 @@
  */
 #define A3000_XFER_MASK		(0x00000003)
 
-typedef struct {
+struct a3000_scsiregs {
 		 unsigned char	pad1[2];
 	volatile unsigned short	DAWR;
 	volatile unsigned int	WTC;
@@ -46,7 +46,7 @@ typedef struct {
 	volatile unsigned char	SASR;
 		 unsigned char	pad9;
 	volatile unsigned char	SCMD;
-} a3000_scsiregs;
+};
 
 #define DAWR_A3000		(3)
 
-- 
1.6.0.4
