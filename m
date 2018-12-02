From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] scsi: qla4xxx: NULL check before some freeing functions is
 not needed.
Date: Sun, 02 Dec 2018 21:52:11 +0100
Message-ID: <1543760930052-1104447559-14-diffsplit-thomas@m3y3r.de>
References: <1543760930050-1499171309-0-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1543760930050-1499171309-0-diffsplit-thomas@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

NULL check before some freeing functions is not needed.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4160,20 +4160,17 @@ static void qla4xxx_mem_free(struct scsi
 	ha->fw_dump_size = 0;
 
 	/* Free srb pool. */
-	if (ha->srb_mempool)
-		mempool_destroy(ha->srb_mempool);
+	mempool_destroy(ha->srb_mempool);
 
 	ha->srb_mempool = NULL;
 
-	if (ha->chap_dma_pool)
-		dma_pool_destroy(ha->chap_dma_pool);
+	dma_pool_destroy(ha->chap_dma_pool);
 
 	if (ha->chap_list)
 		vfree(ha->chap_list);
 	ha->chap_list = NULL;
 
-	if (ha->fw_ddb_dma_pool)
-		dma_pool_destroy(ha->fw_ddb_dma_pool);
+	dma_pool_destroy(ha->fw_ddb_dma_pool);
 
 	/* release io space registers  */
 	if (is_qla8022(ha)) {
