From: brking@us.ibm.com
Subject: [patch 08/15] libata: Add ability to prevent PRD from being allocated
Date: Mon, 06 Feb 2006 09:42:27 -0600
Message-ID: <200602061542.k16FgXXX015889@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:64991 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S932167AbWBFPmf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2006 10:42:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com


For some HBAs, particularly SAS HBAs, there is no reason to
allocate a PRD buffer, since it is not used. Add a flag
to prevent its allocation.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/libata-core.c |   11 +++++++----
 include/linux/libata.h     |    1 +
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN include/linux/libata.h~libata_no_prd include/linux/libata.h
--- libata-dev/include/linux/libata.h~libata_no_prd	2006-02-03 12:37:32.000000000 -0600
+++ libata-dev-bjking1/include/linux/libata.h	2006-02-03 12:37:32.000000000 -0600
@@ -161,6 +161,7 @@ enum {
 
 	ATA_FLAG_PIO_LBA48	= (1 << 13), /* Host DMA engine is LBA28 only */
 	ATA_FLAG_IRQ_MASK	= (1 << 14), /* Mask IRQ in PIO xfers */
+	ATA_FLAG_NO_PRD		= (1 << 15), /* No PRD to allocate */
 
 	ATA_QCFLAG_ACTIVE	= (1 << 1), /* cmd not yet ack'd to scsi lyer */
 	ATA_QCFLAG_SG		= (1 << 3), /* have s/g table? */
diff -puN drivers/scsi/libata-core.c~libata_no_prd drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_no_prd	2006-02-03 12:37:32.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-02-03 12:37:32.000000000 -0600
@@ -4644,9 +4644,11 @@ int ata_port_start (struct ata_port *ap)
 	struct device *dev = ap->dev;
 	int rc;
 
-	ap->prd = dma_alloc_coherent(dev, ATA_PRD_TBL_SZ, &ap->prd_dma, GFP_KERNEL);
-	if (!ap->prd)
-		return -ENOMEM;
+	if ((ap->flags & ATA_FLAG_NO_PRD) == 0) {
+		ap->prd = dma_alloc_coherent(dev, ATA_PRD_TBL_SZ, &ap->prd_dma, GFP_KERNEL);
+		if (!ap->prd)
+			return -ENOMEM;
+	}
 
 	rc = ata_pad_alloc(ap, dev);
 	if (rc) {
@@ -4676,7 +4678,8 @@ void ata_port_stop (struct ata_port *ap)
 {
 	struct device *dev = ap->dev;
 
-	dma_free_coherent(dev, ATA_PRD_TBL_SZ, ap->prd, ap->prd_dma);
+	if ((ap->flags & ATA_FLAG_NO_PRD) == 0)
+		dma_free_coherent(dev, ATA_PRD_TBL_SZ, ap->prd, ap->prd_dma);
 	ata_pad_free(ap, dev);
 }
 
_
