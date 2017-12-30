From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH 3/9] scsi: qedi: Use zeroing allocator instead of allocator/memset
Date: Sat, 30 Dec 2017 20:58:26 +0530
Message-ID: <1514647712-6332-4-git-send-email-himanshujha199640@gmail.com>
References: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, aacraid@adaptec.com
Cc: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, QLogic-Storage-Upstream@qlogic.com, satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, QLogic-Storage-Upstream@cavium.com, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Himanshu Jha <himanshujha199640@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Use dma_zalloc_coherent instead of dma_alloc_coherent followed by memset
0.

Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci

Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/scsi/qedi/qedi_main.c | 42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index cccc34a..5ef0b36 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1268,16 +1268,14 @@ static int qedi_alloc_bdq(struct qedi_ctx *qedi)
 	}
 
 	/* Allocate list of PBL pages */
-	qedi->bdq_pbl_list = dma_alloc_coherent(&qedi->pdev->dev,
-						PAGE_SIZE,
-						&qedi->bdq_pbl_list_dma,
-						GFP_KERNEL);
+	qedi->bdq_pbl_list = dma_zalloc_coherent(&qedi->pdev->dev, PAGE_SIZE,
+						 &qedi->bdq_pbl_list_dma,
+						 GFP_KERNEL);
 	if (!qedi->bdq_pbl_list) {
 		QEDI_ERR(&qedi->dbg_ctx,
 			 "Could not allocate list of PBL pages.\n");
 		return -ENOMEM;
 	}
-	memset(qedi->bdq_pbl_list, 0, PAGE_SIZE);
 
 	/*
 	 * Now populate PBL list with pages that contain pointers to the
@@ -1367,11 +1365,10 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 		    (qedi->global_queues[i]->cq_pbl_size +
 		    (QEDI_PAGE_SIZE - 1));
 
-		qedi->global_queues[i]->cq =
-		    dma_alloc_coherent(&qedi->pdev->dev,
-				       qedi->global_queues[i]->cq_mem_size,
-				       &qedi->global_queues[i]->cq_dma,
-				       GFP_KERNEL);
+		qedi->global_queues[i]->cq =
+			dma_zalloc_coherent(&qedi->pdev->dev,
+					qedi->global_queues[i]->cq_mem_size,
+					&qedi->global_queues[i]->cq_dma,
+					GFP_KERNEL);
 
 		if (!qedi->global_queues[i]->cq) {
 			QEDI_WARN(&qedi->dbg_ctx,
@@ -1379,14 +1376,10 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 			status = -ENOMEM;
 			goto mem_alloc_failure;
 		}
-		memset(qedi->global_queues[i]->cq, 0,
-		       qedi->global_queues[i]->cq_mem_size);
-
-		qedi->global_queues[i]->cq_pbl =
-		    dma_alloc_coherent(&qedi->pdev->dev,
-				       qedi->global_queues[i]->cq_pbl_size,
-				       &qedi->global_queues[i]->cq_pbl_dma,
-				       GFP_KERNEL);
+		qedi->global_queues[i]->cq_pbl =
+			dma_zalloc_coherent(&qedi->pdev->dev,
+					qedi->global_queues[i]->cq_pbl_size,
+					&qedi->global_queues[i]->cq_pbl_dma,
+					GFP_KERNEL);
 
 		if (!qedi->global_queues[i]->cq_pbl) {
 			QEDI_WARN(&qedi->dbg_ctx,
@@ -1394,8 +1387,6 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 			status = -ENOMEM;
 			goto mem_alloc_failure;
 		}
-		memset(qedi->global_queues[i]->cq_pbl, 0,
-		       qedi->global_queues[i]->cq_pbl_size);
 
 		/* Create PBL */
 		num_pages = qedi->global_queues[i]->cq_mem_size /
@@ -1456,25 +1447,22 @@ int qedi_alloc_sq(struct qedi_ctx *qedi, struct qedi_endpoint *ep)
 	ep->sq_pbl_size = (ep->sq_mem_size / QEDI_PAGE_SIZE) * sizeof(void *);
 	ep->sq_pbl_size = ep->sq_pbl_size + QEDI_PAGE_SIZE;
 
-	ep->sq = dma_alloc_coherent(&qedi->pdev->dev, ep->sq_mem_size,
-				    &ep->sq_dma, GFP_KERNEL);
+	ep->sq = dma_zalloc_coherent(&qedi->pdev->dev, ep->sq_mem_size,
+				     &ep->sq_dma, GFP_KERNEL);
 	if (!ep->sq) {
 		QEDI_WARN(&qedi->dbg_ctx,
 			  "Could not allocate send queue.\n");
 		rval = -ENOMEM;
 		goto out;
 	}
-	memset(ep->sq, 0, ep->sq_mem_size);
-
-	ep->sq_pbl = dma_alloc_coherent(&qedi->pdev->dev, ep->sq_pbl_size,
-					&ep->sq_pbl_dma, GFP_KERNEL);
+	ep->sq_pbl = dma_zalloc_coherent(&qedi->pdev->dev, ep->sq_pbl_size,
+					 &ep->sq_pbl_dma, GFP_KERNEL);
 	if (!ep->sq_pbl) {
 		QEDI_WARN(&qedi->dbg_ctx,
 			  "Could not allocate send queue PBL.\n");
 		rval = -ENOMEM;
 		goto out_free_sq;
 	}
-	memset(ep->sq_pbl, 0, ep->sq_pbl_size);
 
 	/* Create PBL */
 	num_pages = ep->sq_mem_size / QEDI_PAGE_SIZE;
-- 
2.7.4
