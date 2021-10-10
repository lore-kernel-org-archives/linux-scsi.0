Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF8EC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Oct 2021 16:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C54A160231
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Oct 2021 16:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbhJJQDT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Oct 2021 12:03:19 -0400
Received: from mx22.baidu.com ([220.181.50.185]:52968 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231842AbhJJQDS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 Oct 2021 12:03:18 -0400
Received: from BC-Mail-Ex19.internal.baidu.com (unknown [172.31.51.13])
        by Forcepoint Email with ESMTPS id 7E744F410DA053291EAE;
        Mon, 11 Oct 2021 00:01:17 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex19.internal.baidu.com (172.31.51.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Mon, 11 Oct 2021 00:01:17 +0800
Received: from localhost.localdomain (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Mon, 11 Oct 2021 00:01:16 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Michael Cyr <mikecyr@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: ibmvscsi_tgt: Use dma_alloc_coherent() instead of get_zeroed_page/dma_map_single()
Date:   Mon, 11 Oct 2021 00:00:53 +0800
Message-ID: <20211010160055.488-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex13.internal.baidu.com (172.31.51.53) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replacing get_zeroed_page/free_page/dma_map_single/dma_unmap_single()
with dma_alloc_coherent/dma_free_coherent() helps to reduce
code size, and simplify the code, and coherent DMA will not
clear the cache every time.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 41 ++++++------------------
 1 file changed, 10 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 61f06f6885a5..24aa0a0d49a6 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3007,20 +3007,12 @@ static long ibmvscsis_create_command_q(struct scsi_info *vscsi, int num_cmds)
 
 	vscsi->cmd_q.size = pages;
 
-	vscsi->cmd_q.base_addr =
-		(struct viosrp_crq *)get_zeroed_page(GFP_KERNEL);
-	if (!vscsi->cmd_q.base_addr)
-		return -ENOMEM;
-
 	vscsi->cmd_q.mask = ((uint)pages * CRQ_PER_PAGE) - 1;
 
-	vscsi->cmd_q.crq_token = dma_map_single(&vdev->dev,
-						vscsi->cmd_q.base_addr,
-						PAGE_SIZE, DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(&vdev->dev, vscsi->cmd_q.crq_token)) {
-		free_page((unsigned long)vscsi->cmd_q.base_addr);
+	vscsi->cmd_q.base_addr = dma_alloc_coherent(&vdev->dev, PAGE_SIZE,
+						    &vscsi->cmd_q.crq_token, GFP_KERNEL);
+	if (!vscsi->cmd_q.base_addr)
 		return -ENOMEM;
-	}
 
 	return 0;
 }
@@ -3036,9 +3028,8 @@ static long ibmvscsis_create_command_q(struct scsi_info *vscsi, int num_cmds)
  */
 static void ibmvscsis_destroy_command_q(struct scsi_info *vscsi)
 {
-	dma_unmap_single(&vscsi->dma_dev->dev, vscsi->cmd_q.crq_token,
-			 PAGE_SIZE, DMA_BIDIRECTIONAL);
-	free_page((unsigned long)vscsi->cmd_q.base_addr);
+	dma_free_coherent(&vscsi->dma_dev->dev, PAGE_SIZE,
+			  vscsi->cmd_q.base_addr, vscsi->cmd_q.crq_token);
 	vscsi->cmd_q.base_addr = NULL;
 	vscsi->state = NO_QUEUE;
 }
@@ -3504,18 +3495,11 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 		goto free_timer;
 	}
 
-	vscsi->map_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	vscsi->map_buf = dma_alloc_coherent(&vdev->dev, PAGE_SIZE,
+					    &vscsi->map_ioba, GFP_KERNEL);
 	if (!vscsi->map_buf) {
 		rc = -ENOMEM;
 		dev_err(&vscsi->dev, "probe: allocating cmd buffer failed\n");
-		goto destroy_queue;
-	}
-
-	vscsi->map_ioba = dma_map_single(&vdev->dev, vscsi->map_buf, PAGE_SIZE,
-					 DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(&vdev->dev, vscsi->map_ioba)) {
-		rc = -ENOMEM;
-		dev_err(&vscsi->dev, "probe: error mapping command buffer\n");
 		goto free_buf;
 	}
 
@@ -3544,7 +3528,7 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 	if (!vscsi->work_q) {
 		rc = -ENOMEM;
 		dev_err(&vscsi->dev, "create_workqueue failed\n");
-		goto unmap_buf;
+		goto destroy_queue;
 	}
 
 	rc = request_irq(vdev->irq, ibmvscsis_interrupt, 0, "ibmvscsis", vscsi);
@@ -3562,11 +3546,8 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 
 destroy_WQ:
 	destroy_workqueue(vscsi->work_q);
-unmap_buf:
-	dma_unmap_single(&vdev->dev, vscsi->map_ioba, PAGE_SIZE,
-			 DMA_BIDIRECTIONAL);
 free_buf:
-	kfree(vscsi->map_buf);
+	dma_free_coherent(&vdev->dev, PAGE_SIZE, vscsi->map_buf, vscsi->map_ioba);
 destroy_queue:
 	tasklet_kill(&vscsi->work_task);
 	ibmvscsis_unregister_command_q(vscsi);
@@ -3602,9 +3583,7 @@ static void ibmvscsis_remove(struct vio_dev *vdev)
 	vio_disable_interrupts(vdev);
 	free_irq(vdev->irq, vscsi);
 	destroy_workqueue(vscsi->work_q);
-	dma_unmap_single(&vdev->dev, vscsi->map_ioba, PAGE_SIZE,
-			 DMA_BIDIRECTIONAL);
-	kfree(vscsi->map_buf);
+	dma_free_coherent(&vdev->dev, PAGE_SIZE, vscsi->map_buf, vscsi->map_ioba);
 	tasklet_kill(&vscsi->work_task);
 	ibmvscsis_destroy_command_q(vscsi);
 	ibmvscsis_freetimer(vscsi);
-- 
2.25.1

