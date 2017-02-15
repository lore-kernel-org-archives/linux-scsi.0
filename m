From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 1/3] qla2xxx: Cleaned up queue configuration code.
Date: Wed, 15 Feb 2017 15:37:19 -0800
Message-ID: <1487201841-28846-2-git-send-email-himanshu.madhani@cavium.com>
References: <1487201841-28846-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0053.outbound.protection.outlook.com ([104.47.41.53]:53222
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755406AbdBOXiN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 18:38:13 -0500
In-Reply-To: <1487201841-28846-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Michael Hernandez <michael.hernandez@cavium.com>

This patch cleaned up queue configuration code, such that
once initialized, we should not touch msix_count value.
This will prevent incorrect numbers of MSI-X vectors requested
while performing target mode configuration.

Fixes: d745952 ("scsi: qla2xxx: Add multiple queue pair functionality.")
Signed-off-by: Michael Hernandez <michael.hernandez@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d01c90c..8174cee 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1815,6 +1815,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 
 	/* Determine queue resources */
 	ha->max_req_queues = ha->max_rsp_queues = 1;
+	ha->msix_count = QLA_BASE_VECTORS;
 	if (!ql2xmqsupport || (!IS_QLA25XX(ha) && !IS_QLA81XX(ha)))
 		goto mqiobase_exit;
 
@@ -1842,9 +1843,8 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 		    "BAR 3 not enabled.\n");
 
 mqiobase_exit:
-	ha->msix_count = ha->max_rsp_queues + 1;
 	ql_dbg_pci(ql_dbg_init, ha->pdev, 0x001c,
-	    "MSIX Count:%d.\n", ha->msix_count);
+	    "MSIX Count: %d.\n", ha->msix_count);
 	return (0);
 
 iospace_error_exit:
@@ -1892,6 +1892,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	/* 83XX 26XX always use MQ type access for queues
 	 * - mbar 2, a.k.a region 4 */
 	ha->max_req_queues = ha->max_rsp_queues = 1;
+	ha->msix_count = QLA_BASE_VECTORS;
 	ha->mqiobase = ioremap(pci_resource_start(ha->pdev, 4),
 			pci_resource_len(ha->pdev, 4));
 
@@ -1934,14 +1935,8 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 		    "BAR 1 not enabled.\n");
 
 mqiobase_exit:
-	ha->msix_count = ha->max_rsp_queues + 1;
-	if (QLA_TGT_MODE_ENABLED())
-		ha->msix_count++;
-
-	qlt_83xx_iospace_config(ha);
-
 	ql_dbg_pci(ql_dbg_init, ha->pdev, 0x011f,
-	    "MSIX Count:%d.\n", ha->msix_count);
+	    "MSIX Count: %d.\n", ha->msix_count);
 	return 0;
 
 iospace_error_exit:
-- 
1.8.3.1
