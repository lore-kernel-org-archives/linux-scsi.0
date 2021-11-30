Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B7B3C43217
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 07:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbhK3Hmp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 02:42:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239102AbhK3HmI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Nov 2021 02:42:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638257929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qP5lgzlSfPS1WcUPtQFjVSSj/qUXqQzGqLQNL0G+rkE=;
        b=CGV67cF8GAQafd4zdgAIz1Hd2ylULSK9YGq316MLWvFkIetFjJ3EcrC+MEelki3N1YWQ0m
        cwXLqaXXk1HhYcDeTgoqhWChRhW3HFE6jVzxFoTRJuA21AM0/rPjswWTtiyzY74KwzE+FB
        w1UffLRR8Yvpji+fNnoNgKYkDFygycA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-QyGI1VKwPbepzAfNy_X2bg-1; Tue, 30 Nov 2021 02:38:46 -0500
X-MC-Unique: QyGI1VKwPbepzAfNy_X2bg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1F2580DDFE;
        Tue, 30 Nov 2021 07:38:44 +0000 (UTC)
Received: from localhost (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C935E5D6BA;
        Tue, 30 Nov 2021 07:38:43 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 5/5] scsi: use blk-mq quiesce APIs to implement scsi_host_block
Date:   Tue, 30 Nov 2021 15:37:52 +0800
Message-Id: <20211130073752.3005936-6-ming.lei@redhat.com>
In-Reply-To: <20211130073752.3005936-1-ming.lei@redhat.com>
References: <20211130073752.3005936-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_host_block() calls synchronize_rcu() directly to wait for
quiesce done, this way is ugly since it exposes blk-mq quiesce's
implementation details.

Instead apply blk_mq_wait_quiesce_done() and
blk_mq_shared_quiesce_wait() for scsi_host_block().

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5e8b5ecb3245..d93bfc08bc1a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2952,15 +2952,15 @@ scsi_host_block(struct Scsi_Host *shost)
 		}
 	}
 
-	/*
-	 * SCSI never enables blk-mq's BLK_MQ_F_BLOCKING flag so
-	 * calling synchronize_rcu() once is enough.
-	 */
-	WARN_ON_ONCE(shost->tag_set.flags & BLK_MQ_F_BLOCKING);
-
-	if (!ret)
-		synchronize_rcu();
+	if (!ret) {
+		shost_for_each_device(sdev, shost) {
+			struct request_queue *q = sdev->request_queue;
 
+			blk_mq_wait_quiesce_done(q);
+			if (blk_mq_shared_quiesce_wait(q))
+				break;
+		}
+	}
 	return ret;
 }
 EXPORT_SYMBOL_GPL(scsi_host_block);
-- 
2.31.1

