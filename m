Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF31DC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 19:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93C2C2084D
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 19:18:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J/BsOvDY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387489AbgFWTSC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 15:18:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33490 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387492AbgFWTSB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2020 15:18:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592939879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TDzzcWBWxyBrAXvr4d3HonY06ASz+B0m8SXpgWZP+74=;
        b=J/BsOvDYrVTHtLrv0ByVn9BMVYkOJ47iFCSyoQFpJ7qeHsl9og9ZcTUnlfp7f0+iLdylJ4
        j7PYlp2LehjWHEVohUckiODzXY5WcA0vHaCh8zAstwoS9s39lQNksF4SIfglM5w0e5FNPu
        T/EcH3MqKM7GnWlTDB6dwa+Cq00SqNQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-PAiMjlmLPQe97U4JuIhF4w-1; Tue, 23 Jun 2020 15:17:56 -0400
X-MC-Unique: PAiMjlmLPQe97U4JuIhF4w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FC0C464;
        Tue, 23 Jun 2020 19:17:55 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.3.128.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 888827168D;
        Tue, 23 Jun 2020 19:17:54 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: [RFC PATCH v3 3/8] print_req_error: Use dev_printk
Date:   Tue, 23 Jun 2020 14:17:44 -0500
Message-Id: <20200623191749.115200-4-tasleson@redhat.com>
In-Reply-To: <20200623191749.115200-1-tasleson@redhat.com>
References: <20200623191749.115200-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 block/blk-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9bfaee050c82..bd57278d7113 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -213,12 +213,15 @@ EXPORT_SYMBOL_GPL(blk_status_to_errno);
 static void print_req_error(struct request *req, blk_status_t status,
 		const char *caller)
 {
+	struct device *dev;
 	int idx = (__force int)status;
 
 	if (WARN_ON_ONCE(idx >= ARRAY_SIZE(blk_errors)))
 		return;
 
-	printk_ratelimited(KERN_ERR
+	dev = (req->rq_disk) ? disk_to_dev(req->rq_disk) : NULL;
+
+	dev_err_ratelimited(dev,
 		"%s: %s error, dev %s, sector %llu op 0x%x:(%s) flags 0x%x "
 		"phys_seg %u prio class %u\n",
 		caller, blk_errors[idx].name,
-- 
2.25.4

