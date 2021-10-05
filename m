Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D3DC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 10:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD6F561381
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 10:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbhJEKbO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 06:31:14 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3924 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234108AbhJEKaw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 06:30:52 -0400
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HNtyQ1j4mz67NZp;
        Tue,  5 Oct 2021 18:25:34 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 5 Oct 2021 12:29:00 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 5 Oct 2021 11:28:58 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <hare@suse.de>,
        <linux-scsi@vger.kernel.org>, <kashyap.desai@broadcom.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v5 07/14] blk-mq: Pass driver tags to blk_mq_clear_rq_mapping()
Date:   Tue, 5 Oct 2021 18:23:32 +0800
Message-ID: <1633429419-228500-8-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1633429419-228500-1-git-send-email-john.garry@huawei.com>
References: <1633429419-228500-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Function blk_mq_clear_rq_mapping() will be used for shared sbitmap tags
in future, so pass a driver tags pointer instead of the tagset container
and HW queue index.

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9895b55dff61..1bee153e6b7f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2304,10 +2304,9 @@ static size_t order_to_size(unsigned int order)
 }
 
 /* called before freeing request pool in @tags */
-static void blk_mq_clear_rq_mapping(struct blk_mq_tag_set *set,
-		struct blk_mq_tags *tags, unsigned int hctx_idx)
+static void blk_mq_clear_rq_mapping(struct blk_mq_tags *drv_tags,
+				    struct blk_mq_tags *tags)
 {
-	struct blk_mq_tags *drv_tags = set->tags[hctx_idx];
 	struct page *page;
 	unsigned long flags;
 
@@ -2316,7 +2315,7 @@ static void blk_mq_clear_rq_mapping(struct blk_mq_tag_set *set,
 		unsigned long end = start + order_to_size(page->private);
 		int i;
 
-		for (i = 0; i < set->queue_depth; i++) {
+		for (i = 0; i < drv_tags->nr_tags; i++) {
 			struct request *rq = drv_tags->rqs[i];
 			unsigned long rq_addr = (unsigned long)rq;
 
@@ -2340,8 +2339,11 @@ static void blk_mq_clear_rq_mapping(struct blk_mq_tag_set *set,
 void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 		     unsigned int hctx_idx)
 {
+	struct blk_mq_tags *drv_tags;
 	struct page *page;
 
+	drv_tags = set->tags[hctx_idx];
+
 	if (tags->static_rqs && set->ops->exit_request) {
 		int i;
 
@@ -2355,7 +2357,7 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
 		}
 	}
 
-	blk_mq_clear_rq_mapping(set, tags, hctx_idx);
+	blk_mq_clear_rq_mapping(drv_tags, tags);
 
 	while (!list_empty(&tags->page_list)) {
 		page = list_first_entry(&tags->page_list, struct page, lru);
-- 
2.26.2

