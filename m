From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH] SGIWD93: use cached memory access to make driver work on IP28
Date: Mon, 26 Nov 2007 18:41:15 +0100
Message-ID: <20071126223921.A566CC2B26@solo.franken.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elvis.franken.de ([193.175.24.41]:59074 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543AbXKZWkR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Nov 2007 17:40:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-mips@linux-mips.org
Cc: ralf@linux-mips.org, James.Bottomley@HansenPartnership.com

Following patch is 2.6.25 material needed to get SGI IP28 machines
supported.

Thomas.

SGI IP28 machines would need special treatment (enable adding addtional
wait states) when accessing memory uncached. To avoid this pain I
changed the driver to use only cached access to memory.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 drivers/scsi/sgiwd93.c |   68 ++++++++++++++++++++++++++++++-----------------
 1 files changed, 43 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index eef8275..d4e6468 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -33,19 +33,27 @@
 
 struct ip22_hostdata {
 	struct WD33C93_hostdata wh;
-	struct hpc_data {
-		dma_addr_t      dma;
-		void		*cpu;
-	} hd;
+	dma_addr_t dma;
+	void *cpu;
+	void *dev;
 };
 
 #define host_to_hostdata(host) ((struct ip22_hostdata *)((host)->hostdata))
 
 struct hpc_chunk {
 	struct hpc_dma_desc desc;
-	u32 _padding;	/* align to quadword boundary */
+	u32 _padding[128/4 - 3];	/* align to biggest cache line size */
 };
 
+/* space for hpc dma descriptors */
+#define HPC_DMA_SIZE   (4 * PAGE_SIZE)
+
+/* we only need to sync the dma descriptor */
+#define DMA_HPC_SYNC(dev, hcp, dir) \
+	dma_cache_sync(dev, hcp, sizeof(struct hpc_dma_desc), dir)
+
+#define DMA_DIR(d)   ((d == DATA_OUT_DIR) ? DMA_TO_DEVICE : DMA_FROM_DEVICE)
+
 static irqreturn_t sgiwd93_intr(int irq, void *dev_id)
 {
 	struct Scsi_Host * host = dev_id;
@@ -59,14 +67,14 @@ static irqreturn_t sgiwd93_intr(int irq, void *dev_id)
 }
 
 static inline
-void fill_hpc_entries(struct hpc_chunk *hcp, struct scsi_cmnd *cmd, int datainp)
+void fill_hpc_entries(void *dev, struct hpc_chunk *hcp, struct scsi_cmnd *cmd, int datainp)
 {
 	unsigned long len = cmd->SCp.this_residual;
 	void *addr = cmd->SCp.ptr;
 	dma_addr_t physaddr;
 	unsigned long count;
 
-	physaddr = dma_map_single(NULL, addr, len, cmd->sc_data_direction);
+	physaddr = dma_map_single(dev, addr, len, DMA_DIR(datainp));
 	cmd->SCp.dma_handle = physaddr;
 
 	while (len) {
@@ -77,6 +85,7 @@ void fill_hpc_entries(struct hpc_chunk *hcp, struct scsi_cmnd *cmd, int datainp)
 		count = len > 8192 ? 8192 : len;
 		hcp->desc.pbuf = physaddr;
 		hcp->desc.cntinfo = count;
+		DMA_HPC_SYNC(dev, hcp, DMA_TO_DEVICE);
 		hcp++;
 		len -= count;
 		physaddr += count;
@@ -89,6 +98,7 @@ void fill_hpc_entries(struct hpc_chunk *hcp, struct scsi_cmnd *cmd, int datainp)
 	 */
 	hcp->desc.pbuf = 0;
 	hcp->desc.cntinfo = HPCDMA_EOX;
+	DMA_HPC_SYNC(dev, hcp, DMA_TO_DEVICE);
 }
 
 static int dma_setup(struct scsi_cmnd *cmd, int datainp)
@@ -96,7 +106,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int datainp)
 	struct ip22_hostdata *hdata = host_to_hostdata(cmd->device->host);
 	struct hpc3_scsiregs *hregs =
 		(struct hpc3_scsiregs *) cmd->device->host->base;
-	struct hpc_chunk *hcp = (struct hpc_chunk *) hdata->hd.cpu;
+	struct hpc_chunk *hcp = (struct hpc_chunk *)hdata->cpu;
 
 	pr_debug("dma_setup: datainp<%d> hcp<%p> ", datainp, hcp);
 
@@ -111,12 +121,12 @@ static int dma_setup(struct scsi_cmnd *cmd, int datainp)
 	if (cmd->SCp.ptr == NULL || cmd->SCp.this_residual == 0)
 		return 1;
 
-	fill_hpc_entries(hcp, cmd, datainp);
+	fill_hpc_entries(hdata->dev, hcp, cmd, datainp);
 
 	pr_debug(" HPCGO\n");
 
 	/* Start up the HPC. */
-	hregs->ndptr = hdata->hd.dma;
+	hregs->ndptr = hdata->dma;
 	if (datainp)
 		hregs->ctrl = HPC3_SCTRL_ACTIVE;
 	else
@@ -134,6 +144,9 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	if (!SCpnt)
 		return;
 
+	if (SCpnt->SCp.ptr == NULL || SCpnt->SCp.this_residual == 0)
+		return;
+
 	hregs = (struct hpc3_scsiregs *) SCpnt->device->host->base;
 
 	pr_debug("dma_stop: status<%d> ", status);
@@ -145,8 +158,9 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 			barrier();
 	}
 	hregs->ctrl = 0;
-	dma_unmap_single(NULL, SCpnt->SCp.dma_handle, SCpnt->SCp.this_residual,
-	                 SCpnt->sc_data_direction);
+	dma_unmap_single(hdata->dev, SCpnt->SCp.dma_handle,
+			 SCpnt->SCp.this_residual,
+			 DMA_DIR(hdata->wh.dma_dir));
 
 	pr_debug("\n");
 }
@@ -160,22 +174,25 @@ void sgiwd93_reset(unsigned long base)
 	hregs->ctrl = 0;
 }
 
-static inline void init_hpc_chain(struct hpc_data *hd)
+static inline void init_hpc_chain(void *dev, struct ip22_hostdata *hdata)
 {
-	struct hpc_chunk *hcp = (struct hpc_chunk *) hd->cpu;
-	struct hpc_chunk *dma = (struct hpc_chunk *) hd->dma;
+	struct hpc_chunk *hcp = (struct hpc_chunk *)hdata->cpu;
+	dma_addr_t dma = hdata->dma;
 	unsigned long start, end;
 
 	start = (unsigned long) hcp;
-	end = start + PAGE_SIZE;
+	end = start + (4 * PAGE_SIZE);
 	while (start < end) {
-		hcp->desc.pnext = (u32) (dma + 1);
+		hcp->desc.pnext = (u32) (dma + sizeof(struct hpc_chunk));
 		hcp->desc.cntinfo = HPCDMA_EOX;
-		hcp++; dma++;
+		DMA_HPC_SYNC(dev, hcp, DMA_TO_DEVICE);
+		hcp++;
+		dma += sizeof(struct hpc_chunk);
 		start += sizeof(struct hpc_chunk);
 	};
 	hcp--;
-	hcp->desc.pnext = hd->dma;
+	hcp->desc.pnext = hdata->dma;
+	DMA_HPC_SYNC(dev, hcp, DMA_TO_DEVICE);
 }
 
 static int sgiwd93_bus_reset(struct scsi_cmnd *cmd)
@@ -234,16 +251,17 @@ static int __init sgiwd93_probe(struct platform_device *pdev)
 	host->irq = irq;
 
 	hdata = host_to_hostdata(host);
-	hdata->hd.cpu = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
-	                                   &hdata->hd.dma, GFP_KERNEL);
-	if (!hdata->hd.cpu) {
+	hdata->dev = &pdev->dev;
+	hdata->cpu = dma_alloc_noncoherent(&pdev->dev, HPC_DMA_SIZE,
+					   &hdata->dma, GFP_KERNEL);
+	if (!hdata->cpu) {
 		printk(KERN_WARNING "sgiwd93: Could not allocate memory for "
 		       "host %d buffer.\n", unit);
 		err = -ENOMEM;
 		goto out_put;
 	}
 
-	init_hpc_chain(&hdata->hd);
+	init_hpc_chain(&pdev->dev, hdata);
 
 	regs.SASR = wdregs + 3;
 	regs.SCMD = wdregs + 7;
@@ -273,7 +291,7 @@ static int __init sgiwd93_probe(struct platform_device *pdev)
 out_irq:
 	free_irq(irq, host);
 out_free:
-	dma_free_coherent(NULL, PAGE_SIZE, hdata->hd.cpu, hdata->hd.dma);
+	dma_free_noncoherent(NULL, HPC_DMA_SIZE, hdata->cpu, hdata->dma);
 out_put:
 	scsi_host_put(host);
 out:
@@ -289,7 +307,7 @@ static void __exit sgiwd93_remove(struct platform_device *pdev)
 
 	scsi_remove_host(host);
 	free_irq(pd->irq, host);
-	dma_free_coherent(&pdev->dev, PAGE_SIZE, hdata->hd.cpu, hdata->hd.dma);
+	dma_free_noncoherent(&pdev->dev, HPC_DMA_SIZE, hdata->cpu, hdata->dma);
 	scsi_host_put(host);
 }
 
-- 
1.4.4.4

