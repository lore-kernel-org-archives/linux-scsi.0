From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [RESEND PATCH 2/2] scsi: qedi: Use zeroing allocator instead of allocator/memset
Date: Tue,  9 Jan 2018 14:36:52 +0530
Message-ID: <1515488812-22664-2-git-send-email-himanshujha199640@gmail.com>
References: <1515488812-22664-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32848 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751709AbeAIJHN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jan 2018 04:07:13 -0500
Received: by mail-pf0-f194.google.com with SMTP id y89so8117505pfk.0
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jan 2018 01:07:13 -0800 (PST)
In-Reply-To: <1515488812-22664-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com, chad.dupuis@cavium.com, Manish.Rangankar@cavium.com, Himanshu Jha <himanshujha199640@gmail.com>

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
+		qedi->global_queues[i]->cq = dma_zalloc_coherent(&qedi->pdev->dev,
+								 qedi->global_queues[i]->cq_mem_size,
+								 &qedi->global_queues[i]->cq_dma,
+								 GFP_KERNEL);
 
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
+		qedi->global_queues[i]->cq_pbl = dma_zalloc_coherent(&qedi->pdev->dev,
+								     qedi->global_queues[i]->cq_pbl_size,
+								     &qedi->global_queues[i]->cq_pbl_dma,
+								     GFP_KERNEL);
 
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
