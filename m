Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94770C6FA86
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 08:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbiI0IWe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 04:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbiI0IWd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 04:22:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D88D4D837;
        Tue, 27 Sep 2022 01:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=HRWFEeWMtXvbGxljJYOHgCEyk8xlLSKsrSBT7PltRIE=; b=KXyKubuctdKcqVthuWb0B7lgfD
        SnN6eQrGNjXrlw5ouPkOwl0c1GPUjRdPUw+iyN2v378hmJBwMoHMRxDzzLa2BQ+XNS8MKXbYoZtAy
        eAK+IMmoR5UsFqeMsapJya150gKDvRH1Gc267E6YGD7j7Oh92N6VU8UNHLpDJRnrrCCREwIE4XAXm
        g1BNFMGsDBzI0I3fc6+C23dxDVOX1eV82SCH//RVEGXJS7rmJELPrz4oT6klR2avaGPJr+3c/hes7
        MoDrVuZXGKJsY8Rg+U7curKV0Djk97+T9eDxAHkgWla9Nw77CqFwiccx8isMc8Q4qVvJB6iAePq41
        +GCYSv0Q==;
Received: from [2001:4bb8:180:b903:a982:5e85:edf4:3fb5] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1od5rH-0096jc-JY; Tue, 27 Sep 2022 08:22:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH] target/iblock: fold iblock_emulate_read_cap_with_block_size into iblock_get_blocks
Date:   Tue, 27 Sep 2022 10:22:25 +0200
Message-Id: <20220927082225.271975-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fold iblock_emulate_read_cap_with_block_size into its only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_iblock.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 8351c974cee32..d9266cf558dcb 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -230,14 +230,12 @@ static void iblock_unplug_device(struct se_dev_plug *se_plug)
 	clear_bit(IBD_PLUGF_PLUGGED, &ib_dev_plug->flags);
 }
 
-static unsigned long long iblock_emulate_read_cap_with_block_size(
-	struct se_device *dev,
-	struct block_device *bd,
-	struct request_queue *q)
+static sector_t iblock_get_blocks(struct se_device *dev)
 {
-	u32 block_size = bdev_logical_block_size(bd);
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+	u32 block_size = bdev_logical_block_size(ib_dev->ibd_bd);
 	unsigned long long blocks_long =
-		div_u64(bdev_nr_bytes(bd), block_size) - 1;
+		div_u64(bdev_nr_bytes(ib_dev->ibd_bd), block_size) - 1;
 
 	if (block_size == dev->dev_attrib.block_size)
 		return blocks_long;
@@ -829,15 +827,6 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 }
 
-static sector_t iblock_get_blocks(struct se_device *dev)
-{
-	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
-	struct block_device *bd = ib_dev->ibd_bd;
-	struct request_queue *q = bdev_get_queue(bd);
-
-	return iblock_emulate_read_cap_with_block_size(dev, bd, q);
-}
-
 static sector_t iblock_get_alignment_offset_lbas(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
-- 
2.30.2

