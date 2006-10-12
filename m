From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] SCSI/aha1740: handle SCSI API errors
Date: Wed, 11 Oct 2006 21:44:08 -0400
Message-ID: <20061012014408.GA12771@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1422672AbWJLBoL@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



Signed-off-by: Jeff Garzik <jeff@garzik.org>

---

 drivers/scsi/aha1740.c          |   10 ++++++-

diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index c3c38a7..d7af9c6 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -586,7 +586,7 @@ static struct scsi_host_template aha1740
 
 static int aha1740_probe (struct device *dev)
 {
-	int slotbase;
+	int slotbase, rc;
 	unsigned int irq_level, irq_type, translation;
 	struct Scsi_Host *shpnt;
 	struct aha1740_hostdata *host;
@@ -641,10 +641,16 @@ static int aha1740_probe (struct device 
 	}
 
 	eisa_set_drvdata (edev, shpnt);
-	scsi_add_host (shpnt, dev); /* XXX handle failure */
+
+	rc = scsi_add_host (shpnt, dev);
+	if (rc)
+		goto err_irq;
+
 	scsi_scan_host (shpnt);
 	return 0;
 
+ err_irq:
+ 	free_irq(irq_level, shpnt);
  err_unmap:
 	dma_unmap_single (&edev->dev, host->ecb_dma_addr,
 			  sizeof (host->ecb), DMA_BIDIRECTIONAL);
