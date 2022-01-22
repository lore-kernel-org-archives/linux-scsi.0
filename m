Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F07C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Jan 2022 11:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiAVLMv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Jan 2022 06:12:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58143 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234276AbiAVLMt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 Jan 2022 06:12:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642849968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qirubjWy4NpcVODIc9rAZROQONujRbVp9oXqOYfiJYE=;
        b=N5JMxV94UMk5lAMhjuVOhE8QIax+bO9KpcCkcvIqtc4BeclYBPgBznEgdQhtYvkQN5P7Xx
        +nP/H8qXq+/7+eFagJW5i+BD5AtpbCr9BTKmUnEIJXgBCjYgeNAx9gjlz5GNwHozLTE0Yz
        UEys1aFos55DdgTCOsg7ZCUxoaMjKL4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-jlWM71YgOaKt1P9L5_8vIQ-1; Sat, 22 Jan 2022 06:12:46 -0500
X-MC-Unique: jlWM71YgOaKt1P9L5_8vIQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18906814245;
        Sat, 22 Jan 2022 11:12:45 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 408711081300;
        Sat, 22 Jan 2022 11:12:43 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 12/13] block: move rq_qos_exit() into disk_release()
Date:   Sat, 22 Jan 2022 19:10:53 +0800
Message-Id: <20220122111054.1126146-13-ming.lei@redhat.com>
In-Reply-To: <20220122111054.1126146-1-ming.lei@redhat.com>
References: <20220122111054.1126146-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There can't be FS IO in disk_release(), so it is safe to move rq_qos_exit()
there.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/genhd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index f1aef5d13afa..2f0e92cdcf6d 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -622,7 +622,6 @@ void del_gendisk(struct gendisk *disk)
 
 	blk_mq_freeze_queue_wait(q);
 
-	rq_qos_exit(q);
 	blk_sync_queue(q);
 	blk_flush_integrity();
 	/*
@@ -1125,6 +1124,7 @@ static void disk_release_queue(struct gendisk *disk)
 		 */
 		blk_mq_freeze_queue(q);
 		blk_exit_queue(q);
+		rq_qos_exit(q);
 		__blk_mq_unfreeze_queue(q, true);
 	}
 
-- 
2.31.1

