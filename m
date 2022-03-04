Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B52DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 16:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240560AbiCDQEk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Mar 2022 11:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236700AbiCDQEg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2022 11:04:36 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FA01AEEF1;
        Fri,  4 Mar 2022 08:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=FnZ1fpykhfq9OvBcy/Lm11zVWshjv7O0KP30y4r9KR0=; b=dLKoxtaVVTKaA1w9vFRyv7HZ1E
        kD6ixBRyzZRhwEJ2mbKPQBuzAGzseEbJoDDV/ANELkDFn01LKRkCjjL5iWwhFlc+zhB8CpXmGqKjW
        oQwWwAwWMPiJX+t9JdTvrBtLwqxKSoZq7Qmqhw15yWVtRPI5pGb1vrEmD7eZ9IzqOvIivQi3Z7DCa
        7xyrlY4NMQ7xfmWLz0M0yEKW/PYz0l14vtJ58CSu8XirLSiQfm1lSyD/bE0LD5pC/DOHUeGl3fVMf
        NhISqJ9N2T2Z2yJmB+3ftzrEzl5BUrvK6LpsA7JRcQbjML+bEscSsgoIyYJTJcheGd/i7PZOe/0f3
        mVkfyJJw==;
Received: from [2001:4bb8:180:5296:7360:567:acd5:aaa2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nQAP6-00Atza-5S; Fri, 04 Mar 2022 16:03:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 02/14] blk-mq: handle already freed tags gracefully in blk_mq_free_rqs
Date:   Fri,  4 Mar 2022 17:03:19 +0100
Message-Id: <20220304160331.399757-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220304160331.399757-1-hch@lst.de>
References: <20220304160331.399757-1-hch@lst.de>
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
index ab4b646551334..6fd0b0f652514 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3070,6 +3070,9 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
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

