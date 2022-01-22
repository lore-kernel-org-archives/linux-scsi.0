Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA0DC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Jan 2022 11:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiAVLMF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Jan 2022 06:12:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40638 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234157AbiAVLME (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 Jan 2022 06:12:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642849924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LlF+wgG4ISXixuSFtCnbmre1aZwrkzCKFUpXClc+E00=;
        b=EvJ8xKv3rKLEjB0a3e5rauGs7M2FTKZMsJEQQ2VljyXU75LgUAiedhIZLR/SuqKbKBY48/
        FZyc9DzeO9mlQnFgPnL5WilND6Wv7gtBNY9KxgiAN12mGwoxsmQd4NmqMeq3+TVuJ0i3cp
        m401AoQLxMYHW3LmOySXVhTM4RzExDE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-z72St53NPz-2-WbMBszyRQ-1; Sat, 22 Jan 2022 06:12:00 -0500
X-MC-Unique: z72St53NPz-2-WbMBszyRQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08F9A814243;
        Sat, 22 Jan 2022 11:11:59 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A9E8752D6;
        Sat, 22 Jan 2022 11:11:57 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Laibin Qiu <qiulaibin@huawei.com>,
        Ming Lei <ming.lei@rehdat.com>
Subject: [PATCH V2 04/13] block/wbt: fix negative inflight counter when remove scsi device
Date:   Sat, 22 Jan 2022 19:10:45 +0800
Message-Id: <20220122111054.1126146-5-ming.lei@redhat.com>
In-Reply-To: <20220122111054.1126146-1-ming.lei@redhat.com>
References: <20220122111054.1126146-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Laibin Qiu <qiulaibin@huawei.com>

Now that we disable wbt by set WBT_STATE_OFF_DEFAULT in
wbt_disable_default() when switch elevator to bfq. And when
we remove scsi device, wbt will be enabled by wbt_enable_default.
If it become false positive between wbt_wait() and wbt_track()
when submit write request.

The following is the scenario that triggered the problem.

T1                          T2                           T3
                            elevator_switch_mq
                            bfq_init_queue
                            wbt_disable_default <= Set
                            rwb->enable_state (OFF)
Submit_bio
blk_mq_make_request
rq_qos_throttle
<= rwb->enable_state (OFF)
                                                         scsi_remove_device
                                                         sd_remove
                                                         del_gendisk
                                                         blk_unregister_queue
                                                         elv_unregister_queue
                                                         wbt_enable_default
                                                         <= Set rwb->enable_state (ON)
q_qos_track
<= rwb->enable_state (ON)
^^^^^^ this request will mark WBT_TRACKED without inflight add and will
lead to drop rqw->inflight to -1 in wbt_done() which will trigger IO hung.

Fix this by move wbt_enable_default() from elv_unregister to
bfq_exit_queue(). Only re-enable wbt when bfq exit.

Fixes: 76a8040817b4b ("blk-wbt: make sure throttle is enabled properly")

Remove oneline stale comment, and kill one oneshot local variable.

Signed-off-by: Ming Lei <ming.lei@rehdat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/linux-block/20211214133103.551813-1-qiulaibin@huawei.com/
Signed-off-by: Laibin Qiu <qiulaibin@huawei.com>
---
 block/bfq-iosched.c | 2 ++
 block/elevator.c    | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 0c612a911696..36a66e97e3c2 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -7018,6 +7018,8 @@ static void bfq_exit_queue(struct elevator_queue *e)
 	spin_unlock_irq(&bfqd->lock);
 #endif
 
+	wbt_enable_default(bfqd->queue);
+
 	kfree(bfqd);
 }
 
diff --git a/block/elevator.c b/block/elevator.c
index ec98aed39c4f..482df2a350fc 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -525,8 +525,6 @@ void elv_unregister_queue(struct request_queue *q)
 		kobject_del(&e->kobj);
 
 		e->registered = 0;
-		/* Re-enable throttling in case elevator disabled it */
-		wbt_enable_default(q);
 	}
 }
 
-- 
2.31.1

