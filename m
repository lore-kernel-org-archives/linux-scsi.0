From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] scsi: qla2xxx: remove dead code
Date: Tue, 9 May 2017 11:51:15 -0500
Message-ID: <20170509165114.GA14533@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.148.214]:30813 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753322AbdEIRPv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 May 2017 13:15:51 -0400
Received: from cm5.websitewelcome.com (cm5.websitewelcome.com [108.167.139.22])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 5011A55B5B
        for <linux-scsi@vger.kernel.org>; Tue,  9 May 2017 11:51:17 -0500 (CDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>

Local variable page_mode is assigned to a constant value and it is never
updated again. Remove this variable and the dead code it guards.

Addresses-Coverity-ID: 200420
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/scsi/qla2xxx/qla_nx.c | 48 -------------------------------------------
 1 file changed, 48 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 0a1723c..bff63b2 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2676,26 +2676,9 @@ qla82xx_write_flash_data(struct scsi_qla_host *vha, uint32_t *dwptr,
 	int ret;
 	uint32_t liter;
 	uint32_t rest_addr;
-	dma_addr_t optrom_dma;
-	void *optrom = NULL;
-	int page_mode = 0;
 	struct qla_hw_data *ha = vha->hw;
 
 	ret = -1;
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
 
 	ret = qla82xx_unprotect_flash(ha);
@@ -2718,34 +2701,6 @@ qla82xx_write_flash_data(struct scsi_qla_host *vha, uint32_t *dwptr,
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
@@ -2761,9 +2716,6 @@ qla82xx_write_flash_data(struct scsi_qla_host *vha, uint32_t *dwptr,
 		ql_log(ql_log_warn, vha, 0xb021,
 		    "Unable to protect flash after update.\n");
 write_done:
-	if (optrom)
-		dma_free_coherent(&ha->pdev->dev,
-		    OPTROM_BURST_SIZE, optrom, optrom_dma);
 	return ret;
 }
 
-- 
2.5.0
