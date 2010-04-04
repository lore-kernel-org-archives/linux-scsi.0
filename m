From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 17/21] m68k/scsi: gvp11 - Kill gvp11_scsiregs typedef
Date: Sun,  4 Apr 2010 11:00:47 +0200
Message-ID: <1270371651-2584-18-git-send-email-geert@linux-m68k.org>
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
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-17-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/gvp11.c |   14 +++++++-------
 drivers/scsi/gvp11.h |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 265cd27..8167b79 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -26,7 +26,7 @@
 static irqreturn_t gvp11_intr(int irq, void *data)
 {
 	struct Scsi_Host *instance = data;
-	gvp11_scsiregs *regs = (gvp11_scsiregs *)(instance->base);
+	struct gvp11_scsiregs *regs = (struct gvp11_scsiregs *)(instance->base);
 	unsigned int status = regs->CNTR;
 	unsigned long flags;
 
@@ -50,7 +50,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
 	struct Scsi_Host *instance = cmd->device->host;
 	struct WD33C93_hostdata *hdata = shost_priv(instance);
-	gvp11_scsiregs *regs = (gvp11_scsiregs *)(instance->base);
+	struct gvp11_scsiregs *regs = (struct gvp11_scsiregs *)(instance->base);
 	unsigned short cntr = GVP11_DMAC_INT_ENABLE;
 	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
 	int bank_mask;
@@ -144,7 +144,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		     int status)
 {
-	gvp11_scsiregs *regs = (gvp11_scsiregs *)(instance->base);
+	struct gvp11_scsiregs *regs = (struct gvp11_scsiregs *)(instance->base);
 	struct WD33C93_hostdata *hdata = shost_priv(instance);
 
 	/* stop DMA */
@@ -168,7 +168,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	}
 }
 
-static int __init check_wd33c93(gvp11_scsiregs *regs)
+static int __init check_wd33c93(struct gvp11_scsiregs *regs)
 {
 #ifdef CHECK_WD33C93
 	volatile unsigned char *sasr_3393, *scmd_3393;
@@ -257,7 +257,7 @@ int __init gvp11_detect(struct scsi_host_template *tpnt)
 	struct zorro_dev *z = NULL;
 	unsigned int default_dma_xfer_mask;
 	struct WD33C93_hostdata *hdata;
-	gvp11_scsiregs *regs;
+	struct gvp11_scsiregs *regs;
 	wd33c93_regs wdregs;
 	int num_gvp11 = 0;
 
@@ -300,7 +300,7 @@ int __init gvp11_detect(struct scsi_host_template *tpnt)
 		if (!request_mem_region(address, 256, "wd33c93"))
 			continue;
 
-		regs = (gvp11_scsiregs *)(ZTWO_VADDR(address));
+		regs = (struct gvp11_scsiregs *)(ZTWO_VADDR(address));
 		if (check_wd33c93(regs))
 			goto release;
 
@@ -398,7 +398,7 @@ static struct scsi_host_template driver_template = {
 int gvp11_release(struct Scsi_Host *instance)
 {
 #ifdef MODULE
-	gvp11_scsiregs *regs = (gvp11_scsiregs *)(instance->base);
+	struct gvp11_scsiregs *regs = (struct gvp11_scsiregs *)(instance->base);
 
 	regs->CNTR = 0;
 	release_mem_region(ZTWO_PADDR(instance->base), 256);
diff --git a/drivers/scsi/gvp11.h b/drivers/scsi/gvp11.h
index e2efdf9..b27a3ee 100644
--- a/drivers/scsi/gvp11.h
+++ b/drivers/scsi/gvp11.h
@@ -30,7 +30,7 @@ int gvp11_release(struct Scsi_Host *);
  */
 #define GVP11_XFER_MASK		(0xff000001)
 
-typedef struct {
+struct gvp11_scsiregs {
 		 unsigned char	pad1[64];
 	volatile unsigned short	CNTR;
 		 unsigned char	pad2[31];
@@ -46,7 +46,7 @@ typedef struct {
 	volatile unsigned short	SP_DMA;
 	volatile unsigned short	secret2; /* store 1 here */
 	volatile unsigned short	secret3; /* store 15 here */
-} gvp11_scsiregs;
+};
 
 /* bits in CNTR */
 #define GVP11_DMAC_BUSY		(1<<0)
-- 
1.6.0.4
