Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 409A7C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 06:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28493604AC
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 06:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239824AbhIFGva (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 02:51:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23845 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239829AbhIFGvR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 02:51:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630911013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qnzDfejYmhnz+7BovVT3U6Ivvhyjw+CAVfiG7DYXSTE=;
        b=Hy9snunJqfKLYCVelGwysN6uaD2y+p3a0YC52t5leVlPC0Ud30P1iUj8FfwXi9SM5GVSQN
        3Jfad5Lga1ORH3rQ8d1vkwVdicJ2dGEdZ0wIiofkRmdp1b/Hhuqd/KJW83swkMHk1yZ2YN
        KRLLf2leK7l8yGTNc5kJyQabxPlFKKk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-iwgMxG35OTOHjCT1sahnyQ-1; Mon, 06 Sep 2021 02:50:12 -0400
X-MC-Unique: iwgMxG35OTOHjCT1sahnyQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EDD5480006E;
        Mon,  6 Sep 2021 06:50:10 +0000 (UTC)
Received: from localhost (ovpn-8-35.pek2.redhat.com [10.72.8.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10D751970F;
        Mon,  6 Sep 2021 06:50:06 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        luojiaxing <luojiaxing@huawei.com>
Subject: [PATCH] blk-mq: avoid to iterate over stale request
Date:   Mon,  6 Sep 2021 14:50:03 +0800
Message-Id: <20210906065003.439019-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

blk-mq can't run allocating driver tag and updating ->rqs[tag]
atomically, meantime blk-mq doesn't clear ->rqs[tag] after the driver
tag is released.

So there is chance to iterating over one stale request just after the
tag is allocated and before updating ->rqs[tag].

scsi_host_busy_iter() calls scsi_host_check_in_flight() to count scsi
in-flight requests after scsi host is blocked, so no new scsi command can
be marked as SCMD_STATE_INFLIGHT. However, driver tag allocation still can
be run by blk-mq core. One request is marked as SCMD_STATE_INFLIGHT,
but this request may have been kept in another slot of ->rqs[], meantime
the slot can be allocated out but ->rqs[] isn't updated yet. Then this
in-flight request is counted twice as SCMD_STATE_INFLIGHT. This way causes
trouble in handling scsi error.

Fixes the issue by not iterating over stale request.

Cc: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Reported-by: luojiaxing <luojiaxing@huawei.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-tag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 86f87346232a..ff5caeb82542 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -208,7 +208,7 @@ static struct request *blk_mq_find_and_get_req(struct blk_mq_tags *tags,
 
 	spin_lock_irqsave(&tags->lock, flags);
 	rq = tags->rqs[bitnr];
-	if (!rq || !refcount_inc_not_zero(&rq->ref))
+	if (!rq || rq->tag != bitnr || !refcount_inc_not_zero(&rq->ref))
 		rq = NULL;
 	spin_unlock_irqrestore(&tags->lock, flags);
 	return rq;
-- 
2.31.1

