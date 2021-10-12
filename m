Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2981FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 03:23:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06CE860F43
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 03:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhJLDZ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 23:25:29 -0400
Received: from mx24.baidu.com ([111.206.215.185]:38518 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232098AbhJLDZ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Oct 2021 23:25:28 -0400
Received: from BC-Mail-Ex12.internal.baidu.com (unknown [172.31.51.52])
        by Forcepoint Email with ESMTPS id 963E031DEB67981EA3BC;
        Tue, 12 Oct 2021 11:23:24 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex12.internal.baidu.com (172.31.51.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Tue, 12 Oct 2021 11:23:24 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Tue, 12 Oct 2021 11:23:23 +0800
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
Subject: [PATCH v2] scsi: ibmvscsi: Use dma_alloc_noncoherent() instead of get_zeroed_page/dma_map_single()
Date:   Tue, 12 Oct 2021 11:23:16 +0800
Message-ID: <20211012032317.2360-1-caihuoqing@baidu.com>
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
code size, and simplify the code, and the hardware can keeep DMA
coherent itself.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
v1->v2:
	*Change to dma_alloc/free_noncoherent from dma_alloc/free_coherent.
	*Update changelog.

 drivers/scsi/ibmvscsi/ibmvfc.c   | 16 ++++------------
 drivers/scsi/ibmvscsi/ibmvscsi.c | 29 +++++++++--------------------
 2 files changed, 13 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 1f1586ad48fe..6e95fd02fd25 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -869,8 +869,8 @@ static void ibmvfc_free_queue(struct ibmvfc_host *vhost,
 {
 	struct device *dev = vhost->dev;
 
-	dma_unmap_single(dev, queue->msg_token, PAGE_SIZE, DMA_BIDIRECTIONAL);
-	free_page((unsigned long)queue->msgs.handle);
+	dma_free_noncoherent(dev, PAGE_SIZE, queue->msgs.handle,
+			     queue->msg_token, DMA_BIDIRECTIONAL);
 	queue->msgs.handle = NULL;
 
 	ibmvfc_free_event_pool(vhost, queue);
@@ -5663,19 +5663,11 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 		return -ENOMEM;
 	}
 
-	queue->msgs.handle = (void *)get_zeroed_page(GFP_KERNEL);
+	queue->msgs.handle = dma_alloc_noncoherent(dev, PAGE_SIZE, &queue->msg_token,
+						   DMA_BIDIRECTIONAL, GFP_KERNEL);
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
index ea8e01f49cba..68409c298c74 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -151,10 +151,8 @@ static void ibmvscsi_release_crq_queue(struct crq_queue *queue,
 			msleep(100);
 		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
 	} while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
-	dma_unmap_single(hostdata->dev,
-			 queue->msg_token,
-			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
-	free_page((unsigned long)queue->msgs);
+	dma_free_noncoherent(hostdata->dev, PAGE_SIZE,
+			     queue->msgs, queue->msg_token, DMA_BIDIRECTIONAL);
 }
 
 /**
@@ -331,18 +329,12 @@ static int ibmvscsi_init_crq_queue(struct crq_queue *queue,
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
+	queue->msgs = dma_alloc_noncoherent(hostdata->dev,
+					    PAGE_SIZE, &queue->msg_token,
+					    DMA_BIDIRECTIONAL, GFP_KERNEL);
+	if (!queue->msg)
+		goto malloc_failed;
 
 	gather_partition_info();
 	set_adapter_info(hostdata);
@@ -395,11 +387,8 @@ static int ibmvscsi_init_crq_queue(struct crq_queue *queue,
 		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
 	} while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
       reg_crq_failed:
-	dma_unmap_single(hostdata->dev,
-			 queue->msg_token,
-			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
-      map_failed:
-	free_page((unsigned long)queue->msgs);
+	dma_free_noncoherent(hostdata->dev, PAGE_SIZE, queue->msg,
+			     queue->msg_token, DMA_BIDIRECTIONAL);
       malloc_failed:
 	return -1;
 }
-- 
2.25.1

