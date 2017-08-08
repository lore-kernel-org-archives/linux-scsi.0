From: Pan Bian <bianpan2016@163.com>
Subject: scsi: qla2xxx: use dma_mapping_error to check map errors
Date: Tue,  8 Aug 2017 21:55:30 +0800
Message-ID: <1502200531-15219-1-git-send-email-bianpan2016@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
List-Id: linux-scsi@vger.kernel.org

The return value of dma_map_single() should be checked by
dma_mapping_error(). However, in function qla26xx_dport_diagnostics(), its
return value is checked against NULL, which could result in failures.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7c6d1a4..eafb709 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5817,7 +5817,7 @@ struct cs84xx_mgmt_cmd {
 
 	dd_dma = dma_map_single(&vha->hw->pdev->dev,
 	    dd_buf, size, DMA_FROM_DEVICE);
-	if (!dd_dma) {
+	if (dma_mapping_error(&vha->hw->pdev->dev, dd_dma)) {
 		ql_log(ql_log_warn, vha, 0x1194, "Failed to map dma buffer.\n");
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
-- 
1.9.1
