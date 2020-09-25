Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D227C4742B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9E4622B2D
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d8DpOf+w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbgIYQTu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 12:19:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46060 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729354AbgIYQTr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 12:19:47 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601050786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=36St5Oeqqpx9UTR9cd+r4hzn7jyQrQgdXE6WFtjZ9NY=;
        b=d8DpOf+wxiLFIzDok497bSG+hr17mrL4ah26onXo/cxMbdmvLAxi5nTih/Hynm3wMMV4g3
        QSuop1zg5H8PuCn0xxC43YpQY/NlJ4+HQpMbZFSxa2rQRGogkQL+sYdR3zP+5qCFS/Bhr1
        ULoP+vo+P+8czWbsygfBwJzpw6E4Edg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-zhfDJ7mRODmiJN2qUJywsg-1; Fri, 25 Sep 2020 12:19:44 -0400
X-MC-Unique: zhfDJ7mRODmiJN2qUJywsg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5153810BBECD;
        Fri, 25 Sep 2020 16:19:43 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.10.110.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 833095D9DC;
        Fri, 25 Sep 2020 16:19:42 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: [v5 11/12] print_req_error: Use durable_name_printk_ratelimited
Date:   Fri, 25 Sep 2020 11:19:28 -0500
Message-Id: <20200925161929.1136806-12-tasleson@redhat.com>
In-Reply-To: <20200925161929.1136806-1-tasleson@redhat.com>
References: <20200925161929.1136806-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace printk_ratelimited with one that adds the key/value
durable name to log entry.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 block/blk-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 03252af8c82c..59e0ff583eb6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -218,12 +218,15 @@ EXPORT_SYMBOL_GPL(blk_status_to_errno);
 static void print_req_error(struct request *req, blk_status_t status,
 		const char *caller)
 {
+	struct device *dev;
 	int idx = (__force int)status;
 
 	if (WARN_ON_ONCE(idx >= ARRAY_SIZE(blk_errors)))
 		return;
 
-	printk_ratelimited(KERN_ERR
+	dev = req->rq_disk ? disk_to_dev(req->rq_disk) : NULL;
+
+	durable_name_printk_ratelimited(KERN_ERR, dev,
 		"%s: %s error, dev %s, sector %llu op 0x%x:(%s) flags 0x%x "
 		"phys_seg %u prio class %u\n",
 		caller, blk_errors[idx].name,
-- 
2.26.2

