From: Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH] SCSI: sgiwd93: remove use of legacy base field of host struct
Date: Fri, 23 Apr 2010 11:15:40 +0100
Message-ID: <20100423101540.GA27244@linux-mips.org>
References: <1270371651-2584-7-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-8-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-9-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-10-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-11-git-send-email-geert@linux-m68k.org>
 <20100405062529.GA28950@infradead.org>
 <s2o10f740e81004051242r27951fcftefe2ca3d1425ff66@mail.gmail.com>
 <i2h10f740e81004230137oc7c5f464w164786cd7f13f589@mail.gmail.com>
 <n2o10f740e81004230138j67eb7e51k8920e49766fa4a4@mail.gmail.com>
 <s2z10f740e81004230140xd60ac9dbv8c904a3aa365edad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <s2z10f740e81004230140xd60ac9dbv8c904a3aa365edad@mail.gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

---
Build tested only - I don't have a test system at hand atm.

 drivers/scsi/sgiwd93.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index fef0e3c..1b24e8d 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -36,6 +36,7 @@ struct ip22_hostdata {
 	dma_addr_t dma;
 	void *cpu;
 	struct device *dev;
+	struct hpc3_scsiregs *hregs;
 };
 
 #define host_to_hostdata(host) ((struct ip22_hostdata *)((host)->hostdata))
@@ -103,8 +104,7 @@ void fill_hpc_entries(struct ip22_hostdata *hd, struct scsi_cmnd *cmd, int din)
 static int dma_setup(struct scsi_cmnd *cmd, int datainp)
 {
 	struct ip22_hostdata *hdata = host_to_hostdata(cmd->device->host);
-	struct hpc3_scsiregs *hregs =
-		(struct hpc3_scsiregs *) cmd->device->host->base;
+	struct hpc3_scsiregs *hregs = hdata->hregs;
 
 	pr_debug("dma_setup: datainp<%d> hcp<%p> ", datainp, hdata->cpu);
 
@@ -137,7 +137,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		     int status)
 {
 	struct ip22_hostdata *hdata = host_to_hostdata(instance);
-	struct hpc3_scsiregs *hregs;
+	struct hpc3_scsiregs *hregs = hdata->hregs;
 
 	if (!SCpnt)
 		return;
@@ -145,8 +145,6 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	if (SCpnt->SCp.ptr == NULL || SCpnt->SCp.this_residual == 0)
 		return;
 
-	hregs = (struct hpc3_scsiregs *) SCpnt->device->host->base;
-
 	pr_debug("dma_stop: status<%d> ", status);
 
 	/* First stop the HPC and flush it's FIFO. */
@@ -244,10 +242,10 @@ static int __devinit sgiwd93_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	host->base = (unsigned long) hregs;
 	host->irq = irq;
 
 	hdata = host_to_hostdata(host);
+	hdata->hregs = hregs;
 	hdata->dev = &pdev->dev;
 	hdata->cpu = dma_alloc_noncoherent(&pdev->dev, HPC_DMA_SIZE,
 					   &hdata->dma, GFP_KERNEL);
