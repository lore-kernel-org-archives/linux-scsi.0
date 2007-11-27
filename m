From: peter fuerst <post@pfrst.de>
Subject: Re: [PATCH] SGIWD93: use cached memory access to make driver work
 on IP28
Date: Wed, 28 Nov 2007 00:00:39 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0711272348360.407@Indigo2.Peter>
References: <20071126223921.A566CC2B26@solo.franken.de>
Reply-To: post@pfrst.de
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <20071126223921.A566CC2B26@solo.franken.de>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-scsi@vger.kernel.org, linux-mips@linux-mips.org, ralf@linux-mips.org, James.Bottomley@HansenPartnership.com
List-Id: linux-scsi@vger.kernel.org



Hello Thomas,

unlike with sgiseeq.c, in sgiwd93.c there's no need to bloat the hpc_chunk
and only a single dma_cache_sync-call is necessary in fill_hpc_entries and
init_hpc_chain respectively.

kind regards

peter


On Mon, 26 Nov 2007, Thomas Bogendoerfer wrote:

> Date: Mon, 26 Nov 2007 18:41:15 +0100
> From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> To: linux-scsi@vger.kernel.org, linux-mips@linux-mips.org
> Cc: ralf@linux-mips.org, James.Bottomley@HansenPartnership.com
> Subject: [PATCH] SGIWD93: use cached memory access to make driver work on
>     IP28
>
> Following patch is 2.6.25 material needed to get SGI IP28 machines
> supported.
>
> Thomas.
>
> SGI IP28 machines would need special treatment (enable adding addtional
> wait states) when accessing memory uncached. To avoid this pain I
> changed the driver to use only cached access to memory.
>
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> ---
>  drivers/scsi/sgiwd93.c |   68 ++++++++++++++++++++++++++++++-----------------
>  1 files changed, 43 insertions(+), 25 deletions(-)
>
> ...





Signed-off-by: peter fuerst <post@pfrst.de>
---
diff -up a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -42,15 +42,13 @@ struct ip22_hostdata {

 struct hpc_chunk {
 	struct hpc_dma_desc desc;
-	u32 _padding[128/4 - 3];	/* align to biggest cache line size */
+	u32 _padding;
 };

 /* space for hpc dma descriptors */
-#define HPC_DMA_SIZE   (4 * PAGE_SIZE)
+#define HPC_DMA_SIZE   PAGE_SIZE

 /* we only need to sync the dma descriptor */
-#define DMA_HPC_SYNC(dev, hcp, dir) \
-	dma_cache_sync(dev, hcp, sizeof(struct hpc_dma_desc), dir)

 #define DMA_DIR(d)   ((d == DATA_OUT_DIR) ? DMA_TO_DEVICE : DMA_FROM_DEVICE)

@@ -73,6 +71,7 @@ void fill_hpc_entries(void *dev, struct
 	void *addr = cmd->SCp.ptr;
 	dma_addr_t physaddr;
 	unsigned long count;
+	struct hpc_chunk *hcpstart = hcp;

 	physaddr = dma_map_single(dev, addr, len, DMA_DIR(datainp));
 	cmd->SCp.dma_handle = physaddr;
@@ -85,7 +84,6 @@ void fill_hpc_entries(void *dev, struct
 		count = len > 8192 ? 8192 : len;
 		hcp->desc.pbuf = physaddr;
 		hcp->desc.cntinfo = count;
-		DMA_HPC_SYNC(dev, hcp, DMA_TO_DEVICE);
 		hcp++;
 		len -= count;
 		physaddr += count;
@@ -98,7 +96,7 @@ void fill_hpc_entries(void *dev, struct
 	 */
 	hcp->desc.pbuf = 0;
 	hcp->desc.cntinfo = HPCDMA_EOX;
-	DMA_HPC_SYNC(dev, hcp, DMA_TO_DEVICE);
+	dma_cache_sync(dev, hcpstart, sizeof(*hcp)*(1+hcp-hcpstart), DMA_TO_DEVICE);
 }

 static int dma_setup(struct scsi_cmnd *cmd, int datainp)
@@ -181,18 +179,17 @@ static inline void init_hpc_chain(void *
 	unsigned long start, end;

 	start = (unsigned long) hcp;
-	end = start + (4 * PAGE_SIZE);
+	end = start + HPC_DMA_SIZE;
 	while (start < end) {
 		hcp->desc.pnext = (u32) (dma + sizeof(struct hpc_chunk));
 		hcp->desc.cntinfo = HPCDMA_EOX;
-		DMA_HPC_SYNC(dev, hcp, DMA_TO_DEVICE);
 		hcp++;
 		dma += sizeof(struct hpc_chunk);
 		start += sizeof(struct hpc_chunk);
 	};
 	hcp--;
 	hcp->desc.pnext = hdata->dma;
-	DMA_HPC_SYNC(dev, hcp, DMA_TO_DEVICE);
+	dma_cache_sync(dev, hdata->cpu, HPC_DMA_SIZE, DMA_TO_DEVICE);
 }

 static int sgiwd93_bus_reset(struct scsi_cmnd *cmd)
