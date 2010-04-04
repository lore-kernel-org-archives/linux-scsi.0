From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 15/21] m68k/scsi: gvp11 - Extract check_wd33c93()
Date: Sun,  4 Apr 2010 11:00:45 +0200
Message-ID: <1270371651-2584-16-git-send-email-geert@linux-m68k.org>
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
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-15-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/gvp11.c |  160 ++++++++++++++++++++++++++------------------------
 1 files changed, 83 insertions(+), 77 deletions(-)

diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 5f07648..265cd27 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -21,6 +21,8 @@
 #include <linux/stat.h>
 
 
+#define CHECK_WD33C93
+
 static irqreturn_t gvp11_intr(int irq, void *data)
 {
 	struct Scsi_Host *instance = data;
@@ -166,7 +168,85 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	}
 }
 
-#define CHECK_WD33C93
+static int __init check_wd33c93(gvp11_scsiregs *regs)
+{
+#ifdef CHECK_WD33C93
+	volatile unsigned char *sasr_3393, *scmd_3393;
+	unsigned char save_sasr;
+	unsigned char q, qq;
+
+	/*
+	 * These darn GVP boards are a problem - it can be tough to tell
+	 * whether or not they include a SCSI controller. This is the
+	 * ultimate Yet-Another-GVP-Detection-Hack in that it actually
+	 * probes for a WD33c93 chip: If we find one, it's extremely
+	 * likely that this card supports SCSI, regardless of Product_
+	 * Code, Board_Size, etc.
+	 */
+
+	/* Get pointers to the presumed register locations and save contents */
+
+	sasr_3393 = &regs->SASR;
+	scmd_3393 = &regs->SCMD;
+	save_sasr = *sasr_3393;
+
+	/* First test the AuxStatus Reg */
+
+	q = *sasr_3393;	/* read it */
+	if (q & 0x08)	/* bit 3 should always be clear */
+		return -ENODEV;
+	*sasr_3393 = WD_AUXILIARY_STATUS;	/* setup indirect address */
+	if (*sasr_3393 == WD_AUXILIARY_STATUS) {	/* shouldn't retain the write */
+		*sasr_3393 = save_sasr;	/* Oops - restore this byte */
+		return -ENODEV;
+	}
+	if (*sasr_3393 != q) {	/* should still read the same */
+		*sasr_3393 = save_sasr;	/* Oops - restore this byte */
+		return -ENODEV;
+	}
+	if (*scmd_3393 != q)	/* and so should the image at 0x1f */
+		return -ENODEV;
+
+	/*
+	 * Ok, we probably have a wd33c93, but let's check a few other places
+	 * for good measure. Make sure that this works for both 'A and 'B
+	 * chip versions.
+	 */
+
+	*sasr_3393 = WD_SCSI_STATUS;
+	q = *scmd_3393;
+	*sasr_3393 = WD_SCSI_STATUS;
+	*scmd_3393 = ~q;
+	*sasr_3393 = WD_SCSI_STATUS;
+	qq = *scmd_3393;
+	*sasr_3393 = WD_SCSI_STATUS;
+	*scmd_3393 = q;
+	if (qq != q)	/* should be read only */
+		return -ENODEV;
+	*sasr_3393 = 0x1e;	/* this register is unimplemented */
+	q = *scmd_3393;
+	*sasr_3393 = 0x1e;
+	*scmd_3393 = ~q;
+	*sasr_3393 = 0x1e;
+	qq = *scmd_3393;
+	*sasr_3393 = 0x1e;
+	*scmd_3393 = q;
+	if (qq != q || qq != 0xff)	/* should be read only, all 1's */
+		return -ENODEV;
+	*sasr_3393 = WD_TIMEOUT_PERIOD;
+	q = *scmd_3393;
+	*sasr_3393 = WD_TIMEOUT_PERIOD;
+	*scmd_3393 = ~q;
+	*sasr_3393 = WD_TIMEOUT_PERIOD;
+	qq = *scmd_3393;
+	*sasr_3393 = WD_TIMEOUT_PERIOD;
+	*scmd_3393 = q;
+	if (qq != (~q & 0xff))	/* should be read/write */
+		return -ENODEV;
+#endif /* CHECK_WD33C93 */
+
+	return 0;
+}
 
 int __init gvp11_detect(struct scsi_host_template *tpnt)
 {
@@ -180,11 +260,6 @@ int __init gvp11_detect(struct scsi_host_template *tpnt)
 	gvp11_scsiregs *regs;
 	wd33c93_regs wdregs;
 	int num_gvp11 = 0;
-#ifdef CHECK_WD33C93
-	volatile unsigned char *sasr_3393, *scmd_3393;
-	unsigned char save_sasr;
-	unsigned char q, qq;
-#endif
 
 	if (!MACH_IS_AMIGA || called)
 		return 0;
@@ -225,77 +300,9 @@ int __init gvp11_detect(struct scsi_host_template *tpnt)
 		if (!request_mem_region(address, 256, "wd33c93"))
 			continue;
 
-#ifdef CHECK_WD33C93
-
-		/*
-		 * These darn GVP boards are a problem - it can be tough to tell
-		 * whether or not they include a SCSI controller. This is the
-		 * ultimate Yet-Another-GVP-Detection-Hack in that it actually
-		 * probes for a WD33c93 chip: If we find one, it's extremely
-		 * likely that this card supports SCSI, regardless of Product_
-		 * Code, Board_Size, etc.
-		 */
-
-		/* Get pointers to the presumed register locations and save contents */
-
-		sasr_3393 = &(((gvp11_scsiregs *)(ZTWO_VADDR(address)))->SASR);
-		scmd_3393 = &(((gvp11_scsiregs *)(ZTWO_VADDR(address)))->SCMD);
-		save_sasr = *sasr_3393;
-
-		/* First test the AuxStatus Reg */
-
-		q = *sasr_3393;	/* read it */
-		if (q & 0x08)	/* bit 3 should always be clear */
-			goto release;
-		*sasr_3393 = WD_AUXILIARY_STATUS;	/* setup indirect address */
-		if (*sasr_3393 == WD_AUXILIARY_STATUS) {	/* shouldn't retain the write */
-			*sasr_3393 = save_sasr;	/* Oops - restore this byte */
-			goto release;
-		}
-		if (*sasr_3393 != q) {	/* should still read the same */
-			*sasr_3393 = save_sasr;	/* Oops - restore this byte */
-			goto release;
-		}
-		if (*scmd_3393 != q)	/* and so should the image at 0x1f */
-			goto release;
-
-		/*
-		 * Ok, we probably have a wd33c93, but let's check a few other places
-		 * for good measure. Make sure that this works for both 'A and 'B
-		 * chip versions.
-		 */
-
-		*sasr_3393 = WD_SCSI_STATUS;
-		q = *scmd_3393;
-		*sasr_3393 = WD_SCSI_STATUS;
-		*scmd_3393 = ~q;
-		*sasr_3393 = WD_SCSI_STATUS;
-		qq = *scmd_3393;
-		*sasr_3393 = WD_SCSI_STATUS;
-		*scmd_3393 = q;
-		if (qq != q)	/* should be read only */
-			goto release;
-		*sasr_3393 = 0x1e;	/* this register is unimplemented */
-		q = *scmd_3393;
-		*sasr_3393 = 0x1e;
-		*scmd_3393 = ~q;
-		*sasr_3393 = 0x1e;
-		qq = *scmd_3393;
-		*sasr_3393 = 0x1e;
-		*scmd_3393 = q;
-		if (qq != q || qq != 0xff)	/* should be read only, all 1's */
+		regs = (gvp11_scsiregs *)(ZTWO_VADDR(address));
+		if (check_wd33c93(regs))
 			goto release;
-		*sasr_3393 = WD_TIMEOUT_PERIOD;
-		q = *scmd_3393;
-		*sasr_3393 = WD_TIMEOUT_PERIOD;
-		*scmd_3393 = ~q;
-		*sasr_3393 = WD_TIMEOUT_PERIOD;
-		qq = *scmd_3393;
-		*sasr_3393 = WD_TIMEOUT_PERIOD;
-		*scmd_3393 = q;
-		if (qq != (~q & 0xff))	/* should be read/write */
-			goto release;
-#endif
 
 		instance = scsi_register(tpnt, sizeof(struct WD33C93_hostdata));
 		if (instance == NULL)
@@ -310,7 +317,6 @@ int __init gvp11_detect(struct scsi_host_template *tpnt)
 		else
 			hdata->dma_xfer_mask = default_dma_xfer_mask;
 
-		regs = (gvp11_scsiregs *)(instance->base);
 		regs->secret2 = 1;
 		regs->secret1 = 0;
 		regs->secret3 = 15;
-- 
1.6.0.4
