Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F33C4707A
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 11:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 536AF61244
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 11:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbhEWLEG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 07:04:06 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:24748 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbhEWLEE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 07:04:04 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d83 with ME
        id 8B2d2500221Fzsu03B2dup; Sun, 23 May 2021 13:02:37 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 23 May 2021 13:02:37 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     skashyap@marvell.com, jhasan@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, chad.dupuis@cavium.com,
        arun.easi@cavium.com, nilesh.javali@cavium.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/3] scsi: qedf: Simplify 'qedf_alloc_global_queues()'
Date:   Sun, 23 May 2021 13:02:36 +0200
Message-Id: <8c53db1d644f09ee0ac1e23b0ce4c5df8eedcf14.1621765056.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1621765056.git.christophe.jaillet@wanadoo.fr>
References: <cover.1621765056.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In 'qedf_alloc_global_queues()', 'qedf->global_queues[i]', is used many
times. Use an intermediate variable with a much shorter name, 'q', to
simplify and make the code more readable.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/qedf/qedf_main.c | 53 +++++++++++++++--------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index ff3a1b183a7c..3b80d4298f15 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3045,55 +3045,46 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 
 	/* Allocate a CQ and an associated PBL for each MSI-X vector */
 	for (i = 0; i < qedf->num_queues; i++) {
-		qedf->global_queues[i] = kzalloc(sizeof(struct global_queue),
-		    GFP_KERNEL);
-		if (!qedf->global_queues[i]) {
+		struct global_queue *q;
+
+		q = kzalloc(sizeof(*q), GFP_KERNEL);
+		if (!q) {
 			QEDF_WARN(&(qedf->dbg_ctx), "Unable to allocate "
 				   "global queue %d.\n", i);
 			status = -ENOMEM;
 			goto mem_alloc_failure;
 		}
+		qedf->global_queues[i] = q;
 
-		qedf->global_queues[i]->cq_mem_size =
+		q->cq_mem_size =
 		    FCOE_PARAMS_CQ_NUM_ENTRIES * sizeof(struct fcoe_cqe);
-		qedf->global_queues[i]->cq_mem_size =
-		    ALIGN(qedf->global_queues[i]->cq_mem_size, QEDF_PAGE_SIZE);
-
-		qedf->global_queues[i]->cq_pbl_size =
-		    (qedf->global_queues[i]->cq_mem_size /
-		    PAGE_SIZE) * sizeof(void *);
-		qedf->global_queues[i]->cq_pbl_size =
-		    ALIGN(qedf->global_queues[i]->cq_pbl_size, QEDF_PAGE_SIZE);
-
-		qedf->global_queues[i]->cq =
-		    dma_alloc_coherent(&qedf->pdev->dev,
-				       qedf->global_queues[i]->cq_mem_size,
-				       &qedf->global_queues[i]->cq_dma,
-				       GFP_KERNEL);
-
-		if (!qedf->global_queues[i]->cq) {
+		q->cq_mem_size = ALIGN(q->cq_mem_size, QEDF_PAGE_SIZE);
+
+		q->cq_pbl_size = (q->cq_mem_size / PAGE_SIZE) * sizeof(void *);
+		q->cq_pbl_size = ALIGN(q->cq_pbl_size, QEDF_PAGE_SIZE);
+
+		q->cq = dma_alloc_coherent(&qedf->pdev->dev, q->cq_mem_size,
+					   &q->cq_dma, GFP_KERNEL);
+
+		if (!q->cq) {
 			QEDF_WARN(&(qedf->dbg_ctx), "Could not allocate cq.\n");
 			status = -ENOMEM;
 			goto mem_alloc_failure;
 		}
 
-		qedf->global_queues[i]->cq_pbl =
-		    dma_alloc_coherent(&qedf->pdev->dev,
-				       qedf->global_queues[i]->cq_pbl_size,
-				       &qedf->global_queues[i]->cq_pbl_dma,
-				       GFP_KERNEL);
+		q->cq_pbl = dma_alloc_coherent(&qedf->pdev->dev, q->cq_pbl_size,
+					       &q->cq_pbl_dma, GFP_KERNEL);
 
-		if (!qedf->global_queues[i]->cq_pbl) {
+		if (!q->cq_pbl) {
 			QEDF_WARN(&(qedf->dbg_ctx), "Could not allocate cq PBL.\n");
 			status = -ENOMEM;
 			goto mem_alloc_failure;
 		}
 
 		/* Create PBL */
-		num_pages = qedf->global_queues[i]->cq_mem_size /
-		    QEDF_PAGE_SIZE;
-		page = qedf->global_queues[i]->cq_dma;
-		pbl = (u32 *)qedf->global_queues[i]->cq_pbl;
+		num_pages = q->cq_mem_size / QEDF_PAGE_SIZE;
+		page = q->cq_dma;
+		pbl = (u32 *)q->cq_pbl;
 
 		while (num_pages--) {
 			*pbl = U64_LO(page);
@@ -3103,7 +3094,7 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 			page += QEDF_PAGE_SIZE;
 		}
 		/* Set the initial consumer index for cq */
-		qedf->global_queues[i]->cq_cons_idx = 0;
+		q->cq_cons_idx = 0;
 	}
 
 	list = (u32 *)qedf->p_cpuq;
-- 
2.30.2

