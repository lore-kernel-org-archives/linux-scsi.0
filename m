From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 1/5] 53c700 scsi: m68k support for the 53c700 SCSI core
Date: Sun, 17 Jun 2007 14:47:05 +0200
Message-ID: <20070617125029.864159199@mail.of.borg>
References: <20070617124704.800461751@mail.of.borg>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759593AbXFQMvq@vger.kernel.org>
Content-Disposition: inline; filename=m68k-53c700-core.diff
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>, Kars de Jong <jongk@linux-m68k.org>, Richard Hirst <rhirst@levanta.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Kars de Jong <jongk@linux-m68k.org>

Add m68k support to the 53c700 SCSI driver

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/53c700.c |   20 ++++++++++----------
 drivers/scsi/53c700.h |    5 +++++
 drivers/scsi/Kconfig  |   13 +++++--------
 3 files changed, 20 insertions(+), 18 deletions(-)

--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -653,7 +653,6 @@ NCR_700_chip_setup(struct Scsi_Host *hos
 {
 	struct NCR_700_Host_Parameters *hostdata = 
 		(struct NCR_700_Host_Parameters *)host->hostdata[0];
-	__u32 dcntl_extra = 0;
 	__u8 min_period;
 	__u8 min_xferp = (hostdata->chip710 ? NCR_710_MIN_XFERP : NCR_700_MIN_XFERP);
 
@@ -678,13 +677,14 @@ NCR_700_chip_setup(struct Scsi_Host *hos
 			        burst_disable = BURST_DISABLE;
 			        break;
 		}
-		dcntl_extra = COMPAT_700_MODE;
+		hostdata->dcntl_extra |= COMPAT_700_MODE;
 
-		NCR_700_writeb(dcntl_extra, host, DCNTL_REG);
+		NCR_700_writeb(hostdata->dcntl_extra, host, DCNTL_REG);
 		NCR_700_writeb(burst_length | hostdata->dmode_extra,
 			       host, DMODE_710_REG);
-		NCR_700_writeb(burst_disable | (hostdata->differential ? 
-						DIFF : 0), host, CTEST7_REG);
+		NCR_700_writeb(burst_disable | hostdata->ctest7_extra |
+			       (hostdata->differential ? DIFF : 0),
+			       host, CTEST7_REG);
 		NCR_700_writeb(BTB_TIMER_DISABLE, host, CTEST0_REG);
 		NCR_700_writeb(FULL_ARBITRATION | ENABLE_PARITY | PARITY
 			       | AUTO_ATN, host, SCNTL0_REG);
@@ -719,13 +719,13 @@ NCR_700_chip_setup(struct Scsi_Host *hos
 		 * of spec: sync divider 2, async divider 3 */
 		DEBUG(("53c700: sync 2 async 3\n"));
 		NCR_700_writeb(SYNC_DIV_2_0, host, SBCL_REG);
-		NCR_700_writeb(ASYNC_DIV_3_0 | dcntl_extra, host, DCNTL_REG);
+		NCR_700_writeb(ASYNC_DIV_3_0 | hostdata->dcntl_extra, host, DCNTL_REG);
 		hostdata->sync_clock = hostdata->clock/2;
 	} else	if(hostdata->clock > 50  && hostdata->clock <= 75) {
 		/* sync divider 1.5, async divider 3 */
 		DEBUG(("53c700: sync 1.5 async 3\n"));
 		NCR_700_writeb(SYNC_DIV_1_5, host, SBCL_REG);
-		NCR_700_writeb(ASYNC_DIV_3_0 | dcntl_extra, host, DCNTL_REG);
+		NCR_700_writeb(ASYNC_DIV_3_0 | hostdata->dcntl_extra, host, DCNTL_REG);
 		hostdata->sync_clock = hostdata->clock*2;
 		hostdata->sync_clock /= 3;
 		
@@ -733,18 +733,18 @@ NCR_700_chip_setup(struct Scsi_Host *hos
 		/* sync divider 1, async divider 2 */
 		DEBUG(("53c700: sync 1 async 2\n"));
 		NCR_700_writeb(SYNC_DIV_1_0, host, SBCL_REG);
-		NCR_700_writeb(ASYNC_DIV_2_0 | dcntl_extra, host, DCNTL_REG);
+		NCR_700_writeb(ASYNC_DIV_2_0 | hostdata->dcntl_extra, host, DCNTL_REG);
 		hostdata->sync_clock = hostdata->clock;
 	} else if(hostdata->clock > 25 && hostdata->clock <=37) {
 		/* sync divider 1, async divider 1.5 */
 		DEBUG(("53c700: sync 1 async 1.5\n"));
 		NCR_700_writeb(SYNC_DIV_1_0, host, SBCL_REG);
-		NCR_700_writeb(ASYNC_DIV_1_5 | dcntl_extra, host, DCNTL_REG);
+		NCR_700_writeb(ASYNC_DIV_1_5 | hostdata->dcntl_extra, host, DCNTL_REG);
 		hostdata->sync_clock = hostdata->clock;
 	} else {
 		DEBUG(("53c700: sync 1 async 1\n"));
 		NCR_700_writeb(SYNC_DIV_1_0, host, SBCL_REG);
-		NCR_700_writeb(ASYNC_DIV_1_0 | dcntl_extra, host, DCNTL_REG);
+		NCR_700_writeb(ASYNC_DIV_1_0 | hostdata->dcntl_extra, host, DCNTL_REG);
 		/* sync divider 1, async divider 1 */
 		hostdata->sync_clock = hostdata->clock;
 	}
--- a/drivers/scsi/53c700.h
+++ b/drivers/scsi/53c700.h
@@ -177,6 +177,7 @@ struct NCR_700_command_slot {
 	__u8	state;
 	#define NCR_700_FLAG_AUTOSENSE	0x01
 	__u8	flags;
+	__u8	pad1[2];	/* Needed for m68k where min alignment is 2 bytes */
 	int	tag;
 	__u32	resume_offset;
 	struct scsi_cmnd *cmnd;
@@ -196,6 +197,8 @@ struct NCR_700_Host_Parameters {
 	void __iomem	*base;		/* the base for the port (copied to host) */
 	struct device	*dev;
 	__u32	dmode_extra;	/* adjustable bus settings */
+	__u32	dcntl_extra;	/* adjustable bus settings */
+	__u32	ctest7_extra;	/* adjustable bus settings */
 	__u32	differential:1;	/* if we are differential */
 #ifdef CONFIG_53C700_LE_ON_BE
 	/* This option is for HP only.  Set it if your chip is wired for
@@ -352,6 +355,7 @@ struct NCR_700_Host_Parameters {
 #define		SEL_TIMEOUT_DISABLE	0x10 /* 710 only */
 #define         DFP                     0x08
 #define         EVP                     0x04
+#define         CTEST7_TT1              0x02
 #define		DIFF			0x01
 #define CTEST6_REG                      0x1A
 #define	TEMP_REG			0x1C
@@ -385,6 +389,7 @@ struct NCR_700_Host_Parameters {
 #define		SOFTWARE_RESET		0x01
 #define		COMPAT_700_MODE		0x01
 #define 	SCRPTS_16BITS		0x20
+#define		EA_710			0x20
 #define		ASYNC_DIV_2_0		0x00
 #define		ASYNC_DIV_1_5		0x40
 #define		ASYNC_DIV_1_0		0x80
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1006,6 +1006,11 @@ config SCSI_STEX
 	  To compile this driver as a module, choose M here: the
 	  module will be called stex.
 
+config 53C700_BE_BUS
+	bool
+	depends on M68K
+	default y
+
 config SCSI_SYM53C8XX_2
 	tristate "SYM53C8XX Version 2 SCSI support"
 	depends on PCI && SCSI
@@ -1728,14 +1733,6 @@ config BVME6000_SCSI
 	  SCSI controller chip.  Almost everyone using one of these boards
 	  will want to say Y to this question.
 
-config SCSI_NCR53C7xx_FAST
-	bool "allow FAST-SCSI [10MHz]"
-	depends on SCSI_AMIGA7XX || MVME16x_SCSI || BVME6000_SCSI
-	help
-	  This will enable 10MHz FAST-SCSI transfers with your host
-	  adapter. Some systems have problems with that speed, so it's safest
-	  to say N here.
-
 config SUN3_SCSI
 	tristate "Sun3 NCR5380 SCSI"
 	depends on SUN3 && SCSI

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
