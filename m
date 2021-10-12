Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4F0C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 03:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19CBE60F43
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 03:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhJLDXa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 23:23:30 -0400
Received: from mx24.baidu.com ([111.206.215.185]:35986 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231742AbhJLDX3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Oct 2021 23:23:29 -0400
Received: from BC-Mail-Ex07.internal.baidu.com (unknown [172.31.51.47])
        by Forcepoint Email with ESMTPS id 4E7EAD74461F2518E7E5;
        Tue, 12 Oct 2021 11:21:17 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-EX07.internal.baidu.com (172.31.51.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Tue, 12 Oct 2021 11:21:17 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Tue, 12 Oct 2021 11:21:16 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <hch@infradead.org>
CC:     Cai Huoqing <caihuoqing@baidu.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] scsi: ibmvscsi_tgt: Use dma_alloc_noncoherent() instead of get_zeroed_page/dma_map_single()
Date:   Tue, 12 Oct 2021 11:21:09 +0800
Message-ID: <20211012032110.2224-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex12.internal.baidu.com (172.31.51.52) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replacing get_zeroed_page/free_page/dma_map_single/dma_unmap_single()
with dma_alloc_noncoherent/dma_free_noncoherent() helps to reduce
code size, and simplify the code, and the hardware keep DMA coherent
itself.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
v1->v2:
	*Change to dma_alloc/free_noncoherent from dma_alloc/free_coherent.
	*Update changelog.

 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 46 ++++++++----------------
 1 file changed, 15 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 61f06f6885a5..91199b969718 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3007,20 +3007,13 @@ static long ibmvscsis_create_command_q(struct scsi_info *vscsi, int num_cmds)
 
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
+	vscsi->cmd_q.base_addr = dma_alloc_noncoherent(&vdev->dev, PAGE_SIZE,
+						       &vscsi->cmd_q.crq_token,
+						       DMA_BIDIRECTIONAL, GFP_KERNEL);
+	if (!vscsi->cmd_q.base_addr)
 		return -ENOMEM;
-	}
 
 	return 0;
 }
@@ -3036,9 +3029,9 @@ static long ibmvscsis_create_command_q(struct scsi_info *vscsi, int num_cmds)
  */
 static void ibmvscsis_destroy_command_q(struct scsi_info *vscsi)
 {
-	dma_unmap_single(&vscsi->dma_dev->dev, vscsi->cmd_q.crq_token,
-			 PAGE_SIZE, DMA_BIDIRECTIONAL);
-	free_page((unsigned long)vscsi->cmd_q.base_addr);
+	dma_free_noncoherent(&vscsi->dma_dev->dev,
+			     PAGE_SIZE, vscsi->cmd_q.base_addr,
+			     vscsi->cmd_q.crq_token, DMA_BIDIRECTIONAL);
 	vscsi->cmd_q.base_addr = NULL;
 	vscsi->state = NO_QUEUE;
 }
@@ -3504,18 +3497,12 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 		goto free_timer;
 	}
 
-	vscsi->map_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	vscsi->map_buf = dma_alloc_noncoherent(&vdev->dev,
+					       PAGE_SIZE, &vscsi->map_ioba,
+					       DMA_BIDIRECTIONAL, GFP_KERNEL);
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
 
@@ -3544,7 +3531,7 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 	if (!vscsi->work_q) {
 		rc = -ENOMEM;
 		dev_err(&vscsi->dev, "create_workqueue failed\n");
-		goto unmap_buf;
+		goto destroy_queue;
 	}
 
 	rc = request_irq(vdev->irq, ibmvscsis_interrupt, 0, "ibmvscsis", vscsi);
@@ -3562,11 +3549,9 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 
 destroy_WQ:
 	destroy_workqueue(vscsi->work_q);
-unmap_buf:
-	dma_unmap_single(&vdev->dev, vscsi->map_ioba, PAGE_SIZE,
-			 DMA_BIDIRECTIONAL);
 free_buf:
-	kfree(vscsi->map_buf);
+	dma_free_noncoherent(&vdev->dev, PAGE_SIZE, vscsi->map_buf,
+			     vscsi->map_ioba, DMA_BIDIRECTIONAL);
 destroy_queue:
 	tasklet_kill(&vscsi->work_task);
 	ibmvscsis_unregister_command_q(vscsi);
@@ -3602,9 +3587,8 @@ static void ibmvscsis_remove(struct vio_dev *vdev)
 	vio_disable_interrupts(vdev);
 	free_irq(vdev->irq, vscsi);
 	destroy_workqueue(vscsi->work_q);
-	dma_unmap_single(&vdev->dev, vscsi->map_ioba, PAGE_SIZE,
-			 DMA_BIDIRECTIONAL);
-	kfree(vscsi->map_buf);
+	dma_free_noncoherent(&vdev->dev, PAGE_SIZE, vscsi->map_buf,
+			     vscsi->map_ioba, DMA_BIDIRECTIONAL);
 	tasklet_kill(&vscsi->work_task);
 	ibmvscsis_destroy_command_q(vscsi);
 	ibmvscsis_freetimer(vscsi);
-- 
2.25.1

