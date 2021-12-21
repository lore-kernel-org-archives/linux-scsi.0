Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B04FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Dec 2021 11:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237110AbhLULbJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Dec 2021 06:31:09 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:29276 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbhLULbJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Dec 2021 06:31:09 -0500
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JJDm503hjzbhrt;
        Tue, 21 Dec 2021 19:30:45 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 19:31:07 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Tue, 21 Dec
 2021 19:31:07 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
CC:     <hch@lst.de>, <james.smart@broadcom.com>,
        <martin.petersen@oracle.com>
Subject: [PATCH -next] scsi: efct: Use GFP_ATOMIC under spin lock
Date:   Tue, 21 Dec 2021 19:37:06 +0800
Message-ID: <20211221113706.329791-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A spin lock is taken here so we should use GFP_ATOMIC.

Fixes: efac162a4e4d ("scsi: efct: Don't pass GFP_DMA to dma_alloc_coherent()")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/scsi/elx/libefc/efc_els.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/elx/libefc/efc_els.c b/drivers/scsi/elx/libefc/efc_els.c
index 7bb4f9aad2c8..7043a61d553d 100644
--- a/drivers/scsi/elx/libefc/efc_els.c
+++ b/drivers/scsi/elx/libefc/efc_els.c
@@ -71,7 +71,7 @@ efc_els_io_alloc_size(struct efc_node *node, u32 reqlen, u32 rsplen)
 	/* now allocate DMA for request and response */
 	els->io.req.size = reqlen;
 	els->io.req.virt = dma_alloc_coherent(&efc->pci->dev, els->io.req.size,
-					      &els->io.req.phys, GFP_KERNEL);
+					      &els->io.req.phys, GFP_ATOMIC);
 	if (!els->io.req.virt) {
 		mempool_free(els, efc->els_io_pool);
 		spin_unlock_irqrestore(&node->els_ios_lock, flags);
@@ -80,7 +80,7 @@ efc_els_io_alloc_size(struct efc_node *node, u32 reqlen, u32 rsplen)
 
 	els->io.rsp.size = rsplen;
 	els->io.rsp.virt = dma_alloc_coherent(&efc->pci->dev, els->io.rsp.size,
-					      &els->io.rsp.phys, GFP_KERNEL);
+					      &els->io.rsp.phys, GFP_ATOMIC);
 	if (!els->io.rsp.virt) {
 		dma_free_coherent(&efc->pci->dev, els->io.req.size,
 				  els->io.req.virt, els->io.req.phys);
-- 
2.25.1

