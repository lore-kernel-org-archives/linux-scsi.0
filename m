From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/3] scsi: qedf: Use 'dma_zalloc_coherent' to reduce code verbosity.
Date: Sun, 11 Jun 2017 08:16:03 +0200
Message-ID: <47616af3fb2cb34d834375c27dec5597ed62f2e9.1497160148.git.christophe.jaillet@wanadoo.fr>
References: <cover.1497160148.git.christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1497160148.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <cover.1497160148.git.christophe.jaillet@wanadoo.fr>
References: <cover.1497160148.git.christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

Replace some 'dma_alloc_coherent+memset' by some quivalent
'dma_zalloc_coherent' in order to reduce code verbosity

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/qedf/qedf_main.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 52a27100ca6d..19a2bbc65f54 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -972,17 +972,16 @@ static int qedf_alloc_sq(struct qedf_ctx *qedf, struct qedf_rport *fcport)
 	    sizeof(void *);
 	fcport->sq_pbl_size = fcport->sq_pbl_size + QEDF_PAGE_SIZE;
 
-	fcport->sq = dma_alloc_coherent(&qedf->pdev->dev, fcport->sq_mem_size,
-	    &fcport->sq_dma, GFP_KERNEL);
+	fcport->sq = dma_zalloc_coherent(&qedf->pdev->dev,
+	    fcport->sq_mem_size, &fcport->sq_dma, GFP_KERNEL);
 	if (!fcport->sq) {
 		QEDF_WARN(&(qedf->dbg_ctx), "Could not allocate send "
 			   "queue.\n");
 		rval = 1;
 		goto out;
 	}
-	memset(fcport->sq, 0, fcport->sq_mem_size);
 
-	fcport->sq_pbl = dma_alloc_coherent(&qedf->pdev->dev,
+	fcport->sq_pbl = dma_zalloc_coherent(&qedf->pdev->dev,
 	    fcport->sq_pbl_size, &fcport->sq_pbl_dma, GFP_KERNEL);
 	if (!fcport->sq_pbl) {
 		QEDF_WARN(&(qedf->dbg_ctx), "Could not allocate send "
@@ -990,7 +989,6 @@ static int qedf_alloc_sq(struct qedf_ctx *qedf, struct qedf_rport *fcport)
 		rval = 1;
 		goto out_free_sq;
 	}
-	memset(fcport->sq_pbl, 0, fcport->sq_pbl_size);
 
 	/* Create PBL */
 	num_pages = fcport->sq_mem_size / QEDF_PAGE_SIZE;
@@ -2597,14 +2595,13 @@ static int qedf_alloc_bdq(struct qedf_ctx *qedf)
 	}
 
 	/* Allocate list of PBL pages */
-	qedf->bdq_pbl_list = dma_alloc_coherent(&qedf->pdev->dev,
+	qedf->bdq_pbl_list = dma_zalloc_coherent(&qedf->pdev->dev,
 	    QEDF_PAGE_SIZE, &qedf->bdq_pbl_list_dma, GFP_KERNEL);
 	if (!qedf->bdq_pbl_list) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Could not allocate list of PBL "
 		    "pages.\n");
 		return -ENOMEM;
 	}
-	memset(qedf->bdq_pbl_list, 0, QEDF_PAGE_SIZE);
 
 	/*
 	 * Now populate PBL list with pages that contain pointers to the
@@ -2689,7 +2686,7 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 		    ALIGN(qedf->global_queues[i]->cq_pbl_size, QEDF_PAGE_SIZE);
 
 		qedf->global_queues[i]->cq =
-		    dma_alloc_coherent(&qedf->pdev->dev,
+		    dma_zalloc_coherent(&qedf->pdev->dev,
 			qedf->global_queues[i]->cq_mem_size,
 			&qedf->global_queues[i]->cq_dma, GFP_KERNEL);
 
@@ -2699,11 +2696,9 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 			status = -ENOMEM;
 			goto mem_alloc_failure;
 		}
-		memset(qedf->global_queues[i]->cq, 0,
-		    qedf->global_queues[i]->cq_mem_size);
 
 		qedf->global_queues[i]->cq_pbl =
-		    dma_alloc_coherent(&qedf->pdev->dev,
+		    dma_zalloc_coherent(&qedf->pdev->dev,
 			qedf->global_queues[i]->cq_pbl_size,
 			&qedf->global_queues[i]->cq_pbl_dma, GFP_KERNEL);
 
@@ -2713,8 +2708,6 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 			status = -ENOMEM;
 			goto mem_alloc_failure;
 		}
-		memset(qedf->global_queues[i]->cq_pbl, 0,
-		    qedf->global_queues[i]->cq_pbl_size);
 
 		/* Create PBL */
 		num_pages = qedf->global_queues[i]->cq_mem_size /
-- 
2.11.0
