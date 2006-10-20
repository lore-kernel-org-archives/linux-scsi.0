From: akpm@osdl.org
Subject: [patch 38/45] SCSI/aha1740: handle SCSI API errors
Date: Fri, 20 Oct 2006 14:48:35 -0700
Message-ID: <200610202148.k9KLmZxg004189@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:13703 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992811AbWJTVtS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:49:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, jeff@garzik.org

From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aha1740.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/aha1740.c~scsi-aha1740-handle-scsi-api-errors drivers/scsi/aha1740.c
--- a/drivers/scsi/aha1740.c~scsi-aha1740-handle-scsi-api-errors
+++ a/drivers/scsi/aha1740.c
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
_
