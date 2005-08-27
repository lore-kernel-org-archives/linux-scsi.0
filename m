From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/16]  qla2xxx: Use dma_get_required_mask() in determining the 'ideal' DMA mask.
Date: Fri, 26 Aug 2005 19:08:00 -0700 (PDT)
Message-ID: <20050827020800.27275.73773.sendpatchset@plap.qlogic.com>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:32359 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751600AbVH0CIA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 22:08:00 -0400
In-Reply-To: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Use dma_get_required_mask() in determining the 'ideal' DMA mask.

In order to efficiently utilise the ISP's IOCB
request-queue, use the dma_get_required_mask() function to
determine the use of command-type 2 or 3 IOCBs when queueing
SCSI commands.  This applies to ISP2[123]xx chips only, as
the ISP24xx uses command-type 7 IOCBs which use 64bit DSDs.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_os.c |   33 ++++++++++-----------------------
 1 files changed, 10 insertions(+), 23 deletions(-)

2978995966996a021e5ac86dbccf917846553754
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1113,36 +1113,23 @@ qla2xxx_slave_destroy(struct scsi_device
 static void
 qla2x00_config_dma_addressing(scsi_qla_host_t *ha)
 {
-	/* Assume 32bit DMA address */
+	/* Assume a 32bit DMA mask. */
 	ha->flags.enable_64bit_addressing = 0;
 
-	/*
-	 * Given the two variants pci_set_dma_mask(), allow the compiler to
-	 * assist in setting the proper dma mask.
-	 */
-	if (sizeof(dma_addr_t) > 4) {
-		if (pci_set_dma_mask(ha->pdev, DMA_64BIT_MASK) == 0) {
+	if (!dma_set_mask(&ha->pdev->dev, DMA_64BIT_MASK)) {
+		/* Any upper-dword bits set? */
+		if (MSD(dma_get_required_mask(&ha->pdev->dev)) &&
+		    !pci_set_consistent_dma_mask(ha->pdev, DMA_64BIT_MASK)) {
+			/* Ok, a 64bit DMA mask is applicable. */
 			ha->flags.enable_64bit_addressing = 1;
 			ha->isp_ops.calc_req_entries = qla2x00_calc_iocbs_64;
 			ha->isp_ops.build_iocbs = qla2x00_build_scsi_iocbs_64;
-
-			if (pci_set_consistent_dma_mask(ha->pdev,
-			    DMA_64BIT_MASK)) {
-				qla_printk(KERN_DEBUG, ha,
-				    "Failed to set 64 bit PCI consistent mask; "
-				    "using 32 bit.\n");
-				pci_set_consistent_dma_mask(ha->pdev,
-				    DMA_32BIT_MASK);
-			}
-		} else {
-			qla_printk(KERN_DEBUG, ha,
-			    "Failed to set 64 bit PCI DMA mask, falling back "
-			    "to 32 bit MASK.\n");
-			pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK);
+			return;
 		}
-	} else {
-		pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK);
 	}
+
+	dma_set_mask(&ha->pdev->dev, DMA_32BIT_MASK);
+	pci_set_consistent_dma_mask(ha->pdev, DMA_32BIT_MASK);
 }
 
 static int

-- 
Andrew Vasquez
