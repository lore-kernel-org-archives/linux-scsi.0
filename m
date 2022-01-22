Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BB8C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Jan 2022 11:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbiAVLLx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Jan 2022 06:11:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44681 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234157AbiAVLLw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 Jan 2022 06:11:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642849912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CpLLy27V5MbHuoHqIYVsmv/vaXJTkt3tPuaNGjzjjso=;
        b=VF5p26LB5BGmUk/JR0/4+FnOSolY7fqD0dMm3qmlYn0U8p+RjwNW5mZRwDvKIVmcmMbks/
        H9MbbQQL+GwPofYENsuITisPakyzu6Yjb6VBx3OFV0Dh+eMi0VuRymGePH9blK/H0GWxue
        sa6settbe6xD7fMV5iRxOuXDZ1g0ou8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-covyJr92MAS458TWqOBzTw-1; Sat, 22 Jan 2022 06:11:49 -0500
X-MC-Unique: covyJr92MAS458TWqOBzTw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD8B7814245;
        Sat, 22 Jan 2022 11:11:47 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B167E6F116;
        Sat, 22 Jan 2022 11:11:31 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 02/13] block: move initialization of q->blkg_list into blkcg_init_queue
Date:   Sat, 22 Jan 2022 19:10:43 +0800
Message-Id: <20220122111054.1126146-3-ming.lei@redhat.com>
In-Reply-To: <20220122111054.1126146-1-ming.lei@redhat.com>
References: <20220122111054.1126146-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

q->blkg_list is only used by blkcg code, so move it into
blkcg_init_queue.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-cgroup.c | 2 ++
 block/blk-core.c   | 3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 650f7e27989f..498753e2bb73 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1176,6 +1176,8 @@ int blkcg_init_queue(struct request_queue *q)
 	bool preloaded;
 	int ret;
 
+	INIT_LIST_HEAD(&q->blkg_list);
+
 	new_blkg = blkg_alloc(&blkcg_root, q, GFP_KERNEL);
 	if (!new_blkg)
 		return -ENOMEM;
diff --git a/block/blk-core.c b/block/blk-core.c
index 97f8bc8d3a79..2a400fa8cabd 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -475,9 +475,6 @@ struct request_queue *blk_alloc_queue(int node_id, bool alloc_srcu)
 	timer_setup(&q->timeout, blk_rq_timed_out_timer, 0);
 	INIT_WORK(&q->timeout_work, blk_timeout_work);
 	INIT_LIST_HEAD(&q->icq_list);
-#ifdef CONFIG_BLK_CGROUP
-	INIT_LIST_HEAD(&q->blkg_list);
-#endif
 
 	kobject_init(&q->kobj, &blk_queue_ktype);
 
-- 
2.31.1

