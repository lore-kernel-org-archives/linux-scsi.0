Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393AAC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Dec 2021 09:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243842AbhLVJSK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 04:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbhLVJSI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Dec 2021 04:18:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0875C061574
        for <linux-scsi@vger.kernel.org>; Wed, 22 Dec 2021 01:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=OiyJtfFCNNxgCulvBYTuC9WxQyTdzcLiel92vF3Xj5A=; b=TPL/7bcOENdSD4uZFCUC7M894J
        Yh2l7QdK/qjpRlB37IW0/P/nGtdgj+J75jfIryjDi6NFMknb3F1S6sVRBmT3sajuOynqVKnb72hQb
        JmH8HdJ/1+zSIODybT4V+MXDJHRmgtvvGbmDjfNE39CzDAbCqFrU83OeoW84kdi9NsmSyoCIstYtO
        jiBjNsJulC6M5lTIlyBSFT0XjHkNUngZ8/Um0C7mlMxIANpizGb9GDGffhyQz/a+73YjJ7gMGxjPe
        iqwkSyytzFJ0btPrMw5HbWufV/Bt3g0yH0Bo+b/XzKfd+wz+7xrNxCmJMXYT3VSDkBcih0mjQnRZY
        J6t1myyw==;
Received: from [2001:4bb8:190:3b1b:96b5:489:ff97:f4cf] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mzxl4-003EpG-PL; Wed, 22 Dec 2021 09:18:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com, hare@kernel.org
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH] myrb: don't use GFP_DMA in myrb_pdev_slave_alloc
Date:   Wed, 22 Dec 2021 10:18:01 +0100
Message-Id: <20211222091801.924745-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver doesn't express DMA addressing limitation under 32-bits
anywhere else, so remove the spurious GFP_DMA allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/myrb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 2a4506a5083ee..71585528e8db9 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1674,7 +1674,7 @@ static int myrb_pdev_slave_alloc(struct scsi_device *sdev)
 	if (sdev->id > MYRB_MAX_TARGETS)
 		return -ENXIO;
 
-	pdev_info = kzalloc(sizeof(*pdev_info), GFP_KERNEL|GFP_DMA);
+	pdev_info = kzalloc(sizeof(*pdev_info), GFP_KERNEL);
 	if (!pdev_info)
 		return -ENOMEM;
 
-- 
2.30.2

