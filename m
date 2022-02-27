Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E6BC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Feb 2022 17:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiB0RWh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 12:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiB0RWd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 12:22:33 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA816C95E;
        Sun, 27 Feb 2022 09:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=3obkjTecc+tBmDXw3y9QiE7nas6q/YaXMeQ/pRJ2RoA=; b=k3KQm58hrqLXij9S6IU52Ar2QT
        qVafiY8PMp6le6+cboRlSb16z+OU05SUiyqiL0Okgi0scpF4EQ/a+FBbimvnnNDl78bt81dC8y4pY
        wuKaGwMdn/HtWoQlH2AfKV1f2TFy0z1Nz8r+uT0dO0BNpkJfxpNyCbY7Liin0EJcPFPG5raAZlOtY
        QqrAe/nhPM8MLgo19kQE9UEulCD1UoRqeAM+s1auJUP37TrYWtKd67o78Q1ewb96nlAyvFQk4ZCUM
        45xMhQN6s4BtdVADIwl/qBOr2K+7z6OlPuXeXPdb9UY0UmHkDQtLAtDGjvW22jeJzn+N15VyRDL6t
        HBoXqayw==;
Received: from 91-118-163-82.static.upcbusiness.at ([91.118.163.82] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nONF4-009ry8-AO; Sun, 27 Feb 2022 17:21:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 02/14] blk-mq: handle already freed tags gracefully in blk_mq_free_rqs
Date:   Sun, 27 Feb 2022 18:21:32 +0100
Message-Id: <20220227172144.508118-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220227172144.508118-1-hch@lst.de>
References: <20220227172144.508118-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

To simplify further changes allow for double calling blk_mq_free_rqs on
a queue.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
[hch: split out from a larger patch]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ee80853473d1e..63e2d3fd60946 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3061,6 +3061,9 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 	struct blk_mq_tags *drv_tags;
 	struct page *page;
 
+	if (list_empty(&tags->page_list))
+		return;
+
 	if (blk_mq_is_shared_tags(set->flags))
 		drv_tags = set->shared_tags;
 	else
-- 
2.30.2

