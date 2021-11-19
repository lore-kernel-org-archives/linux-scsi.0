Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD865C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 02:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A431D61B27
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 02:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhKSCW4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 21:22:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47082 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234085AbhKSCWy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 21:22:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637288392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kVmDn8fHlf4GXS6Ok/pt7q9KsTTX1i/7O5l8UCEX6+c=;
        b=ZpLoG852e661ZrhtAPcZKOHMntiCKTpXRhGjo6s450ZDURFFiv5S66dsq60UxkOJZrCJY6
        DPaH4BOrvE+3bKOoskN7QKdDvwmZBKt5GArkImg9rNDl1ohUDb9kkuIy/5HtTJsjnEtuYB
        TWfMnlrsbbsdAWF/PFhg1W0P+PNC51c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-ueS-ZQ7CPi6veN9qdj_HDQ-1; Thu, 18 Nov 2021 21:19:51 -0500
X-MC-Unique: ueS-ZQ7CPi6veN9qdj_HDQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE2E91808312;
        Fri, 19 Nov 2021 02:19:49 +0000 (UTC)
Received: from localhost (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84D115F4ED;
        Fri, 19 Nov 2021 02:19:44 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 5/5] scsi: use blk-mq quiesce APIs to implement scsi_host_block
Date:   Fri, 19 Nov 2021 10:18:49 +0800
Message-Id: <20211119021849.2259254-6-ming.lei@redhat.com>
In-Reply-To: <20211119021849.2259254-1-ming.lei@redhat.com>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
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
blk_mq_global_quiesce_wait() for scsi_host_block().

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5e8b5ecb3245..b0da6a4a1784 100644
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
+			if (blk_mq_global_quiesce_wait(q))
+				break;
+		}
+	}
 	return ret;
 }
 EXPORT_SYMBOL_GPL(scsi_host_block);
-- 
2.31.1

