From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: qla2xxx: remove dead code in qla82xx_write_flash_data
Date: Wed, 4 Oct 2017 18:28:08 -0500
Message-ID: <20171004232808.GA31707@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway36.websitewelcome.com ([192.185.192.36]:23677 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751201AbdJDXwp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2017 19:52:45 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 9DF2A40765B37
        for <linux-scsi@vger.kernel.org>; Wed,  4 Oct 2017 18:28:11 -0500 (CDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>

Local variable page_mode is assigned to a constant value and it is never
updated again. Remove this variable and the dead code it guards.

Addresses-Coverity-ID: 200420
Addresses-Coverity-ID: 114338
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
This code was tested by compilation only. Also, notice that this code has
not been updated since 2010.

 drivers/scsi/qla2xxx/qla_nx.c | 54 ++-----------------------------------------
 1 file changed, 2 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index a77c339..d5c3d36 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2676,33 +2676,14 @@ qla82xx_write_flash_data(struct scsi_qla_host *vha, uint32_t *dwptr,
 	int ret;
 	uint32_t liter;
 	uint32_t rest_addr;
-	dma_addr_t optrom_dma;
-	void *optrom = NULL;
-	int page_mode = 0;
 	struct qla_hw_data *ha = vha->hw;
 
-	ret = -1;
-
-	/* Prepare burst-capable write on supported ISPs. */
-	if (page_mode && !(faddr & 0xfff) &&
-	    dwords > OPTROM_BURST_DWORDS) {
-		optrom = dma_alloc_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE,
-		    &optrom_dma, GFP_KERNEL);
-		if (!optrom) {
-			ql_log(ql_log_warn, vha, 0xb01b,
-			    "Unable to allocate memory "
-			    "for optrom burst write (%x KB).\n",
-			    OPTROM_BURST_SIZE / 1024);
-		}
-	}
-
 	rest_addr = ha->fdt_block_size - 1;
-
 	ret = qla82xx_unprotect_flash(ha);
 	if (ret) {
 		ql_log(ql_log_warn, vha, 0xb01c,
 		    "Unable to unprotect flash for update.\n");
-		goto write_done;
+		return ret;
 	}
 
 	for (liter = 0; liter < dwords; liter++, faddr += 4, dwptr++) {
@@ -2718,34 +2699,6 @@ qla82xx_write_flash_data(struct scsi_qla_host *vha, uint32_t *dwptr,
 			}
 		}
 
-		/* Go with burst-write. */
-		if (optrom && (liter + OPTROM_BURST_DWORDS) <= dwords) {
-			/* Copy data to DMA'ble buffer. */
-			memcpy(optrom, dwptr, OPTROM_BURST_SIZE);
-
-			ret = qla2x00_load_ram(vha, optrom_dma,
-			    (ha->flash_data_off | faddr),
-			    OPTROM_BURST_DWORDS);
-			if (ret != QLA_SUCCESS) {
-				ql_log(ql_log_warn, vha, 0xb01e,
-				    "Unable to burst-write optrom segment "
-				    "(%x/%x/%llx).\n", ret,
-				    (ha->flash_data_off | faddr),
-				    (unsigned long long)optrom_dma);
-				ql_log(ql_log_warn, vha, 0xb01f,
-				    "Reverting to slow-write.\n");
-
-				dma_free_coherent(&ha->pdev->dev,
-				    OPTROM_BURST_SIZE, optrom, optrom_dma);
-				optrom = NULL;
-			} else {
-				liter += OPTROM_BURST_DWORDS - 1;
-				faddr += OPTROM_BURST_DWORDS - 1;
-				dwptr += OPTROM_BURST_DWORDS - 1;
-				continue;
-			}
-		}
-
 		ret = qla82xx_write_flash_dword(ha, faddr,
 		    cpu_to_le32(*dwptr));
 		if (ret) {
@@ -2760,10 +2713,7 @@ qla82xx_write_flash_data(struct scsi_qla_host *vha, uint32_t *dwptr,
 	if (ret)
 		ql_log(ql_log_warn, vha, 0xb021,
 		    "Unable to protect flash after update.\n");
-write_done:
-	if (optrom)
-		dma_free_coherent(&ha->pdev->dev,
-		    OPTROM_BURST_SIZE, optrom, optrom_dma);
+
 	return ret;
 }
 
-- 
2.7.4
