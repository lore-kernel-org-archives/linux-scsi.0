Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D44C43460
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 08:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6115E61350
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 08:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhDYI65 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 04:58:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41649 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229485AbhDYI65 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Apr 2021 04:58:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619341097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1ncarbKPgNU0ZeJA+q4PSEQDtpWvG/p0TouzrHLB+yU=;
        b=iPaKGmBwbmMK+Y2jxbXFDgUefM+FWMsBNrV7wVra2dbn1TgP78xGCqI5B/9hb+iwjfvo+w
        UKxKcFeI2MrH44rTpSjq55c+OwUbE8LSf6qsdLJ5Cvj6hTebn0bDMRZBYcLAte+VhgA9MN
        x3enomEdB9BFJ2ymjOqgPhlNJ/glk4Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-9R7uqRVmPr-f_nmiv8kLAQ-1; Sun, 25 Apr 2021 04:58:15 -0400
X-MC-Unique: 9R7uqRVmPr-f_nmiv8kLAQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E755E1006701;
        Sun, 25 Apr 2021 08:58:13 +0000 (UTC)
Received: from localhost (ovpn-13-143.pek2.redhat.com [10.72.13.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4420C2BFF1;
        Sun, 25 Apr 2021 08:58:12 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Khazhy Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        David Jeffery <djeffery@redhat.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 2/8] Revert "blk-mq: Make it safe to use RCU to iterate over blk_mq_tag_set.tag_list"
Date:   Sun, 25 Apr 2021 16:57:47 +0800
Message-Id: <20210425085753.2617424-3-ming.lei@redhat.com>
In-Reply-To: <20210425085753.2617424-1-ming.lei@redhat.com>
References: <20210425085753.2617424-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This reverts commit a8a6ac7ad3fb6b84b933ca1ea5110998bdaeee17.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 7d2ea6357c7d..8b59f6b4ec8e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2947,7 +2947,7 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 	struct blk_mq_tag_set *set = q->tag_set;
 
 	mutex_lock(&set->tag_list_lock);
-	list_del_rcu(&q->tag_set_list);
+	list_del(&q->tag_set_list);
 	if (list_is_singular(&set->tag_list)) {
 		/* just transitioned to unshared */
 		set->flags &= ~BLK_MQ_F_TAG_QUEUE_SHARED;
@@ -2955,11 +2955,7 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 		blk_mq_update_tag_set_shared(set, false);
 	}
 	mutex_unlock(&set->tag_list_lock);
-	/*
-	 * Calling synchronize_rcu() and INIT_LIST_HEAD(&q->tag_set_list) is
-	 * not necessary since blk_mq_del_queue_tag_set() is only called from
-	 * blk_cleanup_queue().
-	 */
+	INIT_LIST_HEAD(&q->tag_set_list);
 }
 
 static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
-- 
2.29.2

