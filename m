From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH] WD33C93: let platform stub override no_sync/fast/dma_mode
Date: Fri, 21 Mar 2008 22:25:43 +0100 (CET)
Message-ID: <20080321212543.6F769C2DF8@solo.franken.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elvis.franken.de ([193.175.24.41]:40028 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbYCUV1A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 17:27:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-mips@linux-mips.org
Cc: ralf@linux-mips.org, James.Bottomley@HansenPartnership.com

SGI machines with WD33C93 allow usage of burst mode DMA, which increases
performance noticable. To make this selectable by the sgiwd93 stub,
setting the values for no_sync, fast and dma_mode has been moved to the
individual platform stubs.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---

Please apply for 2.6.26

 drivers/scsi/a2091.c   |    3 +++
 drivers/scsi/a3000.c   |    3 +++
 drivers/scsi/gvp11.c   |    3 +++
 drivers/scsi/mvme147.c |    3 +++
 drivers/scsi/sgiwd93.c |    7 ++++---
 drivers/scsi/wd33c93.c |    3 ---
 6 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index 5ac3a3e..1d1bb25 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -179,6 +179,9 @@ int __init a2091_detect(struct scsi_host_template *tpnt)
 	DMA(instance)->DAWR = DAWR_A2091;
 	regs.SASR = &(DMA(instance)->SASR);
 	regs.SCMD = &(DMA(instance)->SCMD);
+	HDATA(a3000_host)->no_sync = 0xff;
+	HDATA(a3000_host)->fast = 0;
+	HDATA(a3000_host)->dma_mode = CTRL_DMA;
 	wd33c93_init(instance, regs, dma_setup, dma_stop, WD33C93_FS_8_10);
 	request_irq(IRQ_AMIGA_PORTS, a2091_intr, IRQF_SHARED, "A2091 SCSI",
 		    instance);
diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 3aeec96..8b449d8 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -178,6 +178,9 @@ int __init a3000_detect(struct scsi_host_template *tpnt)
     DMA(a3000_host)->DAWR = DAWR_A3000;
     regs.SASR = &(DMA(a3000_host)->SASR);
     regs.SCMD = &(DMA(a3000_host)->SCMD);
+    HDATA(a3000_host)->no_sync = 0xff;
+    HDATA(a3000_host)->fast = 0;
+    HDATA(a3000_host)->dma_mode = CTRL_DMA;
     wd33c93_init(a3000_host, regs, dma_setup, dma_stop, WD33C93_FS_12_15);
     if (request_irq(IRQ_AMIGA_PORTS, a3000_intr, IRQF_SHARED, "A3000 SCSI",
 		    a3000_intr))
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 91f8522..e75a7ba 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -322,6 +322,9 @@ int __init gvp11_detect(struct scsi_host_template *tpnt)
 	 */
 	regs.SASR = &(DMA(instance)->SASR);
 	regs.SCMD = &(DMA(instance)->SCMD);
+	HDATA(a3000_host)->no_sync = 0xff;
+	HDATA(a3000_host)->fast = 0;
+	HDATA(a3000_host)->dma_mode = CTRL_DMA;
 	wd33c93_init(instance, regs, dma_setup, dma_stop,
 		     (epc & GVP_SCSICLKMASK) ? WD33C93_FS_8_10
 					     : WD33C93_FS_12_15);
diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
index be41aad..6a8cf17 100644
--- a/drivers/scsi/mvme147.c
+++ b/drivers/scsi/mvme147.c
@@ -82,6 +82,9 @@ int mvme147_detect(struct scsi_host_template *tpnt)
     mvme147_host->irq = MVME147_IRQ_SCSI_PORT;
     regs.SASR = (volatile unsigned char *)0xfffe4000;
     regs.SCMD = (volatile unsigned char *)0xfffe4001;
+    HDATA(a3000_host)->no_sync = 0xff;
+    HDATA(a3000_host)->fast = 0;
+    HDATA(a3000_host)->dma_mode = CTRL_DMA;
     wd33c93_init(mvme147_host, regs, dma_setup, dma_stop, WD33C93_FS_8_10);
 
     if (request_irq(MVME147_IRQ_SCSI_PORT, mvme147_intr, 0, "MVME147 SCSI PORT", mvme147_intr))
diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 26cfc56..03e3596 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -263,10 +263,11 @@ static int __init sgiwd93_probe(struct platform_device *pdev)
 	regs.SASR = wdregs + 3;
 	regs.SCMD = wdregs + 7;
 
-	wd33c93_init(host, regs, dma_setup, dma_stop, WD33C93_FS_MHZ(20));
+	hdata->wh.no_sync = 0;
+	hdata->wh.fast = 1;
+	hdata->wh.dma_mode = CTRL_BURST;
 
-	if (hdata->wh.no_sync == 0xff)
-		hdata->wh.no_sync = 0;
+	wd33c93_init(host, regs, dma_setup, dma_stop, WD33C93_FS_MHZ(20));
 
 	err = request_irq(irq, sgiwd93_intr, 0, "SGI WD93", host);
 	if (err) {
diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index f286c37..5fda881 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -1973,10 +1973,7 @@ wd33c93_init(struct Scsi_Host *instance, const wd33c93_regs regs,
 	hostdata->incoming_ptr = 0;
 	hostdata->outgoing_len = 0;
 	hostdata->default_sx_per = DEFAULT_SX_PER;
-	hostdata->no_sync = 0xff;	/* sync defaults to off */
 	hostdata->no_dma = 0;	/* default is DMA enabled */
-	hostdata->fast = 0;	/* default is Fast SCSI transfers disabled */
-	hostdata->dma_mode = CTRL_DMA;	/* default is Single Byte DMA */
 
 #ifdef PROC_INTERFACE
 	hostdata->proc = PR_VERSION | PR_INFO | PR_STATISTICS |
