Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0352C4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Oct 2021 16:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 864AF61076
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Oct 2021 16:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhJJQDp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Oct 2021 12:03:45 -0400
Received: from mx22.baidu.com ([220.181.50.185]:53298 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230271AbhJJQDo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 Oct 2021 12:03:44 -0400
Received: from BC-Mail-Ex18.internal.baidu.com (unknown [172.31.51.12])
        by Forcepoint Email with ESMTPS id F423C628CB139476D543;
        Mon, 11 Oct 2021 00:01:43 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex18.internal.baidu.com (172.31.51.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Mon, 11 Oct 2021 00:01:43 +0800
Received: from localhost.localdomain (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Mon, 11 Oct 2021 00:01:42 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul Mackerras" <paulus@samba.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: ibmvscsi: Use dma_alloc_coherent() instead of get_zeroed_page/dma_map_single()
Date:   Mon, 11 Oct 2021 00:01:19 +0800
Message-ID: <20211010160121.539-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex16.internal.baidu.com (10.127.64.39) To
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
 drivers/scsi/ibmvscsi/ibmvfc.c   | 15 +++------------
 drivers/scsi/ibmvscsi/ibmvscsi.c | 26 ++++++--------------------
 2 files changed, 9 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 1f1586ad48fe..f65d1a78b272 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -869,8 +869,7 @@ static void ibmvfc_free_queue(struct ibmvfc_host *vhost,
 {
 	struct device *dev = vhost->dev;
 
-	dma_unmap_single(dev, queue->msg_token, PAGE_SIZE, DMA_BIDIRECTIONAL);
-	free_page((unsigned long)queue->msgs.handle);
+	dma_free_coherent(dev, PAGE_SIZE, queue->msgs.handle, queue->msg_token);
 	queue->msgs.handle = NULL;
 
 	ibmvfc_free_event_pool(vhost, queue);
@@ -5663,19 +5662,11 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 		return -ENOMEM;
 	}
 
-	queue->msgs.handle = (void *)get_zeroed_page(GFP_KERNEL);
+	queue->msgs.handle = dma_alloc_coherent(dev, PAGE_SIZE,
+						&queue->msg_token, GFP_KERNEL);
 	if (!queue->msgs.handle)
 		return -ENOMEM;
 
-	queue->msg_token = dma_map_single(dev, queue->msgs.handle, PAGE_SIZE,
-					  DMA_BIDIRECTIONAL);
-
-	if (dma_mapping_error(dev, queue->msg_token)) {
-		free_page((unsigned long)queue->msgs.handle);
-		queue->msgs.handle = NULL;
-		return -ENOMEM;
-	}
-
 	queue->cur = 0;
 	queue->fmt = fmt;
 	queue->size = PAGE_SIZE / fmt_size;
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index ea8e01f49cba..61b315d1edbc 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -151,10 +151,7 @@ static void ibmvscsi_release_crq_queue(struct crq_queue *queue,
 			msleep(100);
 		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
 	} while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
-	dma_unmap_single(hostdata->dev,
-			 queue->msg_token,
-			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
-	free_page((unsigned long)queue->msgs);
+	dma_free_coherent(hostdata->dev, PAGE_SIZE, queue->msgs, queue->msg_token);
 }
 
 /**
@@ -331,18 +328,11 @@ static int ibmvscsi_init_crq_queue(struct crq_queue *queue,
 	int retrc;
 	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
 
-	queue->msgs = (struct viosrp_crq *)get_zeroed_page(GFP_KERNEL);
-
-	if (!queue->msgs)
-		goto malloc_failed;
 	queue->size = PAGE_SIZE / sizeof(*queue->msgs);
-
-	queue->msg_token = dma_map_single(hostdata->dev, queue->msgs,
-					  queue->size * sizeof(*queue->msgs),
-					  DMA_BIDIRECTIONAL);
-
-	if (dma_mapping_error(hostdata->dev, queue->msg_token))
-		goto map_failed;
+	queue->msgs = dma_alloc_coherent(hostdata->dev, PAGE_SIZE,
+					&queue->msg_token, GFP_KERNEL);
+	if (!queue->msg)
+		goto malloc_failed;
 
 	gather_partition_info();
 	set_adapter_info(hostdata);
@@ -395,11 +385,7 @@ static int ibmvscsi_init_crq_queue(struct crq_queue *queue,
 		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
 	} while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
       reg_crq_failed:
-	dma_unmap_single(hostdata->dev,
-			 queue->msg_token,
-			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
-      map_failed:
-	free_page((unsigned long)queue->msgs);
+	dma_free_coherent(hostdata->dev, PAGE_SIZE, queue->msg, queue->msg_token);
       malloc_failed:
 	return -1;
 }
-- 
2.25.1

