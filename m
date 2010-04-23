From: Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH] SCSI: sgiwd93: Convert to use shost_priv()
Date: Fri, 23 Apr 2010 11:26:54 +0100
Message-ID: <20100423102654.GA9105@linux-mips.org>
References: <1270371651-2584-8-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-9-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-10-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-11-git-send-email-geert@linux-m68k.org>
 <20100405062529.GA28950@infradead.org>
 <s2o10f740e81004051242r27951fcftefe2ca3d1425ff66@mail.gmail.com>
 <i2h10f740e81004230137oc7c5f464w164786cd7f13f589@mail.gmail.com>
 <n2o10f740e81004230138j67eb7e51k8920e49766fa4a4@mail.gmail.com>
 <s2z10f740e81004230140xd60ac9dbv8c904a3aa365edad@mail.gmail.com>
 <20100423101540.GA27244@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100423101540.GA27244@linux-mips.org>
Sender: linux-m68k-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The driver had its own similar macro and still one open-coded reference
to ->hostdata.  Use shost_priv() everywhere for consistency.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---
Build tested only - I don't have a test system at hand atm.

The previous patch was missing a Signed-off-by: line, feel free to add it.

 drivers/scsi/sgiwd93.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 1b24e8d..e9204fb 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -39,8 +39,6 @@ struct ip22_hostdata {
 	struct hpc3_scsiregs *hregs;
 };
 
-#define host_to_hostdata(host) ((struct ip22_hostdata *)((host)->hostdata))
-
 struct hpc_chunk {
 	struct hpc_dma_desc desc;
 	u32 _padding;	/* align to quadword boundary */
@@ -103,7 +101,7 @@ void fill_hpc_entries(struct ip22_hostdata *hd, struct scsi_cmnd *cmd, int din)
 
 static int dma_setup(struct scsi_cmnd *cmd, int datainp)
 {
-	struct ip22_hostdata *hdata = host_to_hostdata(cmd->device->host);
+	struct ip22_hostdata *hdata = shost_priv(cmd->device->host);
 	struct hpc3_scsiregs *hregs = hdata->hregs;
 
 	pr_debug("dma_setup: datainp<%d> hcp<%p> ", datainp, hdata->cpu);
@@ -136,7 +134,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int datainp)
 static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		     int status)
 {
-	struct ip22_hostdata *hdata = host_to_hostdata(instance);
+	struct ip22_hostdata *hdata = shost_priv(instance);
 	struct hpc3_scsiregs *hregs = hdata->hregs;
 
 	if (!SCpnt)
@@ -244,7 +242,7 @@ static int __devinit sgiwd93_probe(struct platform_device *pdev)
 
 	host->irq = irq;
 
-	hdata = host_to_hostdata(host);
+	hdata = shost_priv(host);
 	hdata->hregs = hregs;
 	hdata->dev = &pdev->dev;
 	hdata->cpu = dma_alloc_noncoherent(&pdev->dev, HPC_DMA_SIZE,
@@ -298,7 +296,7 @@ out:
 static int __exit sgiwd93_remove(struct platform_device *pdev)
 {
 	struct Scsi_Host *host = platform_get_drvdata(pdev);
-	struct ip22_hostdata *hdata = (struct ip22_hostdata *) host->hostdata;
+	struct ip22_hostdata *hdata = shost_priv(host);
 	struct sgiwd93_platform_data *pd = pdev->dev.platform_data;
 
 	scsi_remove_host(host);
