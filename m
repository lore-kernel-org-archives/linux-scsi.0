Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4FB8C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 10:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87711613D5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 10:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbhJEKav (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 06:30:51 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3920 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbhJEKan (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 06:30:43 -0400
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HNtyb66xJz67S0x;
        Tue,  5 Oct 2021 18:25:43 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 5 Oct 2021 12:28:51 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 5 Oct 2021 11:28:49 +0100
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <hare@suse.de>,
        <linux-scsi@vger.kernel.org>, <kashyap.desai@broadcom.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v5 03/14] blk-mq: Relocate shared sbitmap resize in blk_mq_update_nr_requests()
Date:   Tue, 5 Oct 2021 18:23:28 +0800
Message-ID: <1633429419-228500-4-git-send-email-john.garry@huawei.com>
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

For shared sbitmap, if the call to blk_mq_tag_update_depth() was
successful for any hctx when hctx->sched_tags is not set, then it would be
successful for all (due to nature in which blk_mq_tag_update_depth()
fails).

As such, there is no need to call blk_mq_tag_resize_shared_sbitmap() for
each hctx. So relocate the call until after the hctx iteration under the
!q->elevator check, which is equivalent (to !hctx->sched_tags).

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-mq.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index bc8238ab1aef..290821580ecf 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3618,8 +3618,6 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 		if (!hctx->sched_tags) {
 			ret = blk_mq_tag_update_depth(hctx, &hctx->tags, nr,
 							false);
-			if (!ret && blk_mq_is_sbitmap_shared(set->flags))
-				blk_mq_tag_resize_shared_sbitmap(set, nr);
 		} else {
 			ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
 							nr, true);
@@ -3637,9 +3635,13 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 	}
 	if (!ret) {
 		q->nr_requests = nr;
-		if (q->elevator && blk_mq_is_sbitmap_shared(set->flags))
-			sbitmap_queue_resize(&q->sched_bitmap_tags,
-					     nr - set->reserved_tags);
+		if (blk_mq_is_sbitmap_shared(set->flags)) {
+			if (q->elevator)
+				sbitmap_queue_resize(&q->sched_bitmap_tags,
+						     nr - set->reserved_tags);
+			else
+				blk_mq_tag_resize_shared_sbitmap(set, nr);
+		}
 	}
 
 	blk_mq_unquiesce_queue(q);
-- 
2.26.2

