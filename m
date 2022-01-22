Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A8DC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Jan 2022 11:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbiAVLMT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Jan 2022 06:12:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234243AbiAVLMT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 Jan 2022 06:12:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642849938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pZXy6AjZjPC6H/SXIyE5VyyrzC96iMDRLk5+OuIek/c=;
        b=QiIn4rfabcgdIlB+mxTua2WwWC8Ss+FfscKz4QY18CmWSXV9XTJVkfwBLS4uk+/kQlPA8X
        abRTMUiKurjQHECUe4/J2tcVfqYmN6uzLCCJ5JNGZzjJfWdUUjNGHO+/pDnYrgGDduQAIk
        wjRpNZxTFa9rV8RgNXyHZmwopZuWLoY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-VMuyXiscMfyyuedqexKhUA-1; Sat, 22 Jan 2022 06:12:15 -0500
X-MC-Unique: VMuyXiscMfyyuedqexKhUA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFBEF2F47;
        Sat, 22 Jan 2022 11:12:13 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC14D7B9DC;
        Sat, 22 Jan 2022 11:12:12 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 07/13] block: move q_usage_counter release into blk_queue_release
Date:   Sat, 22 Jan 2022 19:10:48 +0800
Message-Id: <20220122111054.1126146-8-ming.lei@redhat.com>
In-Reply-To: <20220122111054.1126146-1-ming.lei@redhat.com>
References: <20220122111054.1126146-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After blk_cleanup_queue() returns, disk may not be released yet, so
probably bio may still be submitted and ->q_usage_counter may be
touched, so far this way seems safe, but not good from API's viewpoint.

Move the release ofq_usage_counter into blk_queue_release().

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c  | 2 --
 block/blk-sysfs.c | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d9477191b303..bcb4d982cd80 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -341,8 +341,6 @@ void blk_cleanup_queue(struct request_queue *q)
 		blk_mq_sched_free_rqs(q);
 	mutex_unlock(&q->sysfs_lock);
 
-	percpu_ref_exit(&q->q_usage_counter);
-
 	/* @q is and will stay empty, shutdown and put */
 	blk_put_queue(q);
 }
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 6f326b44fb00..5f14fd333182 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -780,6 +780,8 @@ static void blk_release_queue(struct kobject *kobj)
 
 	might_sleep();
 
+	percpu_ref_exit(&q->q_usage_counter);
+
 	if (q->poll_stat)
 		blk_stat_remove_callback(q, q->poll_cb);
 	blk_stat_free_callback(q->poll_cb);
-- 
2.31.1

