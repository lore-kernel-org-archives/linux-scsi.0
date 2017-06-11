From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/2] scsi: qedi: Use 'dma_zalloc_coherent' to reduce code verbosity.
Date: Sun, 11 Jun 2017 08:40:19 +0200
Message-ID: <86ebfb8beeafc7ae8f5e39b4add3cf8666b81c19.1497162751.git.christophe.jaillet@wanadoo.fr>
References: <cover.1497162751.git.christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1497162751.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <cover.1497162751.git.christophe.jaillet@wanadoo.fr>
References: <cover.1497162751.git.christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

Replace some 'dma_alloc_coherent+memset' by some quivalent
'dma_zalloc_coherent' in order to reduce code verbosity

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch generates some checkpatch errors about the use of space to indent code.
I've left it as-is to keep consistency with the style used in this file.
---
 drivers/scsi/qedi/qedi_main.c | 39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index c81e494a9067..37bf881ccfb3 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1241,16 +1241,15 @@ static int qedi_alloc_bdq(struct qedi_ctx *qedi)
 	}
 
 	/* Allocate list of PBL pages */
-	qedi->bdq_pbl_list = dma_alloc_coherent(&qedi->pdev->dev,
-						PAGE_SIZE,
-						&qedi->bdq_pbl_list_dma,
-						GFP_KERNEL);
+	qedi->bdq_pbl_list = dma_zalloc_coherent(&qedi->pdev->dev,
+						 PAGE_SIZE,
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
@@ -1337,10 +1336,10 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 		    (QEDI_PAGE_SIZE - 1));
 
 		qedi->global_queues[i]->cq =
-		    dma_alloc_coherent(&qedi->pdev->dev,
-				       qedi->global_queues[i]->cq_mem_size,
-				       &qedi->global_queues[i]->cq_dma,
-				       GFP_KERNEL);
+		    dma_zalloc_coherent(&qedi->pdev->dev,
+				        qedi->global_queues[i]->cq_mem_size,
+				        &qedi->global_queues[i]->cq_dma,
+				        GFP_KERNEL);
 
 		if (!qedi->global_queues[i]->cq) {
 			QEDI_WARN(&qedi->dbg_ctx,
@@ -1348,14 +1347,12 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 			status = -ENOMEM;
 			goto mem_alloc_failure;
 		}
-		memset(qedi->global_queues[i]->cq, 0,
-		       qedi->global_queues[i]->cq_mem_size);
 
 		qedi->global_queues[i]->cq_pbl =
-		    dma_alloc_coherent(&qedi->pdev->dev,
-				       qedi->global_queues[i]->cq_pbl_size,
-				       &qedi->global_queues[i]->cq_pbl_dma,
-				       GFP_KERNEL);
+		    dma_zalloc_coherent(&qedi->pdev->dev,
+				        qedi->global_queues[i]->cq_pbl_size,
+				        &qedi->global_queues[i]->cq_pbl_dma,
+				        GFP_KERNEL);
 
 		if (!qedi->global_queues[i]->cq_pbl) {
 			QEDI_WARN(&qedi->dbg_ctx,
@@ -1363,8 +1360,6 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 			status = -ENOMEM;
 			goto mem_alloc_failure;
 		}
-		memset(qedi->global_queues[i]->cq_pbl, 0,
-		       qedi->global_queues[i]->cq_pbl_size);
 
 		/* Create PBL */
 		num_pages = qedi->global_queues[i]->cq_mem_size /
@@ -1425,25 +1420,23 @@ int qedi_alloc_sq(struct qedi_ctx *qedi, struct qedi_endpoint *ep)
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
2.11.0
