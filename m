From: Brian King <brking@us.ibm.com>
Subject: [PATCH 4/6] libata: Add ata_host_flags
Date: Wed, 07 Jun 2006 11:25:52 -0500
Message-ID: <200606071625.k57GPrit014721@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48025 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932297AbWFGQZ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2006 12:25:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com


Since SATA devices attached to SAS HBAs will not have
a host_set, add a helper function to retrieve the host_set
flags which can check for the existence of a host_set.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-core.c |    7 +++----
 libata-dev-bjking1/include/linux/libata.h     |    7 +++++++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/libata-core.c~libata_sas_no_simplex drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_sas_no_simplex	2006-06-06 08:55:43.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-06-06 08:55:43.000000000 -0500
@@ -2161,7 +2161,7 @@ int ata_set_mode(struct ata_port *ap, st
 	/* Record simplex status. If we selected DMA then the other
 	 * host channels are not permitted to do so.
 	 */
-	if (used_dma && (ap->host_set->flags & ATA_HOST_SIMPLEX))
+	if (used_dma && (ata_host_flags(ap) & ATA_HOST_SIMPLEX))
 		ap->host_set->simplex_claimed = 1;
 
 	/* step5: chip specific finalisation */
@@ -3012,7 +3012,6 @@ static int ata_dma_blacklisted(const str
 static void ata_dev_xfermask(struct ata_device *dev)
 {
 	struct ata_port *ap = dev->ap;
-	struct ata_host_set *hs = ap->host_set;
 	unsigned long xfer_mask;
 	int i;
 
@@ -3050,8 +3049,8 @@ static void ata_dev_xfermask(struct ata_
 		ata_dev_printk(dev, KERN_WARNING,
 			       "device is on DMA blacklist, disabling DMA\n");
 
-	if (hs->flags & ATA_HOST_SIMPLEX) {
-		if (hs->simplex_claimed)
+	if (ata_host_flags(ap) & ATA_HOST_SIMPLEX) {
+		if (ap->host_set->simplex_claimed)
 			xfer_mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
 	}
 
diff -puN include/linux/libata.h~libata_sas_no_simplex include/linux/libata.h
--- libata-dev/include/linux/libata.h~libata_sas_no_simplex	2006-06-06 08:55:43.000000000 -0500
+++ libata-dev-bjking1/include/linux/libata.h	2006-06-06 08:55:43.000000000 -0500
@@ -1103,4 +1103,11 @@ static inline struct ata_port *ata_shost
 	return (struct ata_port *) &host->hostdata[0];
 }
 
+static inline unsigned int ata_host_flags(struct ata_port *ap)
+{
+	if (ap->host_set)
+		return ap->host_set->flags;
+	return 0;
+}
+
 #endif /* __LINUX_LIBATA_H__ */
_
