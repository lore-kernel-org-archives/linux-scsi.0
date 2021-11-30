Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3344AC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 07:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239116AbhK3Hmn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 02:42:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57338 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239100AbhK3HmF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Nov 2021 02:42:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638257926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7xMXqhptIWrpNXAqWAhz5g7mlgjr3NfEv27Xmhs7v4E=;
        b=iunFKNMt2Wa7SfQZcNZkClkRua39Q2N95DCx8IUKJSEWFIctgEMjNSnGkzWbFAhUHTCxCT
        hVYUzp93jgjlLTLnhAgFWDJxtCPzzxroT81Ypxu2/pcBO3I0pJ4tGL1e8liTkY0mdzt2rd
        bYei+/6Tk6WsW+SupwZ3NEMjJWVW7IQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-303-SQ0-HJPHMh2yTZUriJMdlQ-1; Tue, 30 Nov 2021 02:38:42 -0500
X-MC-Unique: SQ0-HJPHMh2yTZUriJMdlQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 005AB94EE1;
        Tue, 30 Nov 2021 07:38:41 +0000 (UTC)
Received: from localhost (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A54D5D6BA;
        Tue, 30 Nov 2021 07:38:31 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, Chao Leng <lengchao@huawei.com>
Subject: [PATCH V2 4/5] nvme: quiesce namespace queue in parallel
Date:   Tue, 30 Nov 2021 15:37:51 +0800
Message-Id: <20211130073752.3005936-5-ming.lei@redhat.com>
In-Reply-To: <20211130073752.3005936-1-ming.lei@redhat.com>
References: <20211130073752.3005936-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Chao Leng reported that in case of lots of namespaces, it may take quite a
while for nvme_stop_queues() to quiesce all namespace queues.

Improve nvme_stop_queues() by running quiesce in parallel, and just wait
once if global quiesce wait is allowed.

Link: https://lore.kernel.org/linux-block/cc732195-c053-9ce4-e1a7-e7f6dcf762ac@huawei.com/
Reported-by: Chao Leng <lengchao@huawei.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/nvme/host/core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 4c63564adeaa..20827a360099 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4540,9 +4540,7 @@ static void nvme_start_ns_queue(struct nvme_ns *ns)
 static void nvme_stop_ns_queue(struct nvme_ns *ns)
 {
 	if (!test_and_set_bit(NVME_NS_STOPPED, &ns->flags))
-		blk_mq_quiesce_queue(ns->queue);
-	else
-		blk_mq_wait_quiesce_done(ns->queue);
+		blk_mq_quiesce_queue_nowait(ns->queue);
 }
 
 /*
@@ -4643,6 +4641,11 @@ void nvme_stop_queues(struct nvme_ctrl *ctrl)
 	down_read(&ctrl->namespaces_rwsem);
 	list_for_each_entry(ns, &ctrl->namespaces, list)
 		nvme_stop_ns_queue(ns);
+	list_for_each_entry(ns, &ctrl->namespaces, list) {
+		blk_mq_wait_quiesce_done(ns->queue);
+		if (blk_mq_shared_quiesce_wait(ns->queue))
+			break;
+	}
 	up_read(&ctrl->namespaces_rwsem);
 }
 EXPORT_SYMBOL_GPL(nvme_stop_queues);
-- 
2.31.1

