Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E48BAC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 03:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C89FD60E05
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 03:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhKCDrL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 23:47:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230291AbhKCDrL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 23:47:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635911075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dAYJx74U+GdQXr+dAoKOA4zqw8371ITy4X5feU72lkI=;
        b=Qr5GmrUcgfoBPEU0Qr0zhXX3QQlu84a9OgTsvhhhMhykr7DiD4FMKirXM/06Um6fuEMQYW
        G2dpCZc/GEQWmzmhG6SDKzWLXh7PdoFD6qLBDBsdVpgJSZSkR2HfwefT+KEh8hKaKUCGmE
        1itGATGEOjBcK2h2hvAHLrIZ8UJpUSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-hE6ypDbqM0i1blHUz4Pm-A-1; Tue, 02 Nov 2021 23:44:31 -0400
X-MC-Unique: hE6ypDbqM0i1blHUz4Pm-A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 718AF1006AA3;
        Wed,  3 Nov 2021 03:44:30 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DB9E5C1BB;
        Wed,  3 Nov 2021 03:44:23 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Yi Zhang <yi.zhang@redhat.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 4/4] nvme: wait until quiesce is done
Date:   Wed,  3 Nov 2021 11:43:05 +0800
Message-Id: <20211103034305.3691555-5-ming.lei@redhat.com>
In-Reply-To: <20211103034305.3691555-1-ming.lei@redhat.com>
References: <20211103034305.3691555-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

NVMe uses one atomic flag to check if quiesce is needed. If quiesce is
started, the helper returns immediately. This way is wrong, since we
have to wait until quiesce is done.

Fixes: e70feb8b3e68 ("blk-mq: support concurrent queue quiesce/unquiesce")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/nvme/host/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 838b5e2058be..4b5de8f5435a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4518,6 +4518,8 @@ static void nvme_stop_ns_queue(struct nvme_ns *ns)
 {
 	if (!test_and_set_bit(NVME_NS_STOPPED, &ns->flags))
 		blk_mq_quiesce_queue(ns->queue);
+	else
+		blk_mq_wait_quiesce_done(ns->queue);
 }
 
 /*
@@ -4637,6 +4639,8 @@ void nvme_stop_admin_queue(struct nvme_ctrl *ctrl)
 {
 	if (!test_and_set_bit(NVME_CTRL_ADMIN_Q_STOPPED, &ctrl->flags))
 		blk_mq_quiesce_queue(ctrl->admin_q);
+	else
+		blk_mq_wait_quiesce_done(ctrl->admin_q);
 }
 EXPORT_SYMBOL_GPL(nvme_stop_admin_queue);
 
-- 
2.31.1

