Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F13CEC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 02:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB9B961AE2
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 02:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbhKSCWl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 21:22:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30683 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234069AbhKSCWh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 21:22:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637288376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Yd7NKGQpp1ZdaKbTLbIuoVxBrLtjhZOvXvgiVmAZ9k=;
        b=IQwgYSpQDJLUA5+DtFRzL3OYJUHaHp8iDt+rTauz6AXqQ+mRW1Wd852YvSEViSN4aKfis2
        BwgZr9K6QT5nLfZvt0b2IABhD1dTYRgOYHGG1sZMLpK7nFEkHytcjmzjmihrdmTACMuJIf
        hIbgWsAn+hnYmnv2xdH7meuItZ5vuiI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-299-EZEdM3BnMdSXUOPyRgh_jg-1; Thu, 18 Nov 2021 21:19:33 -0500
X-MC-Unique: EZEdM3BnMdSXUOPyRgh_jg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9BC1802C94;
        Fri, 19 Nov 2021 02:19:31 +0000 (UTC)
Received: from localhost (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A71460BF1;
        Fri, 19 Nov 2021 02:19:24 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 3/5] blk-mq: add helper of blk_mq_global_quiesce_wait()
Date:   Fri, 19 Nov 2021 10:18:47 +0800
Message-Id: <20211119021849.2259254-4-ming.lei@redhat.com>
In-Reply-To: <20211119021849.2259254-1-ming.lei@redhat.com>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add helper of blk_mq_global_quiesce_wait() for supporting to quiesce
queues in parallel, then we can just wait once if global quiesce wait
is allowed.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/blk-mq.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 5cc7fc1ea863..a9fecda2507e 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -777,6 +777,19 @@ static inline bool blk_mq_add_to_batch(struct request *req,
 	return true;
 }
 
+/*
+ * If the queue has allocated & used srcu to quiesce queue, quiesce wait is
+ * done via the synchronize_srcu(q->rcu), otherwise it is done via global
+ * synchronize_rcu().
+ *
+ * This helper can help us to support quiescing queue in parallel, so just
+ * one quiesce wait is enough if global quiesce wait is allowed.
+ */
+static inline bool blk_mq_global_quiesce_wait(struct request_queue *q)
+{
+	return !q->alloc_srcu;
+}
+
 void blk_mq_requeue_request(struct request *rq, bool kick_requeue_list);
 void blk_mq_kick_requeue_list(struct request_queue *q);
 void blk_mq_delay_kick_requeue_list(struct request_queue *q, unsigned long msecs);
-- 
2.31.1

