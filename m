Return-Path: <SRS0=9S6W=BD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F9AFC43462
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 17:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64FB0206F6
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 17:17:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c4/PR2pl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgGXRRa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 13:17:30 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37530 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726988AbgGXRR3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Jul 2020 13:17:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595611048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xe0E3S9exdPhGHIrK2txdY7JFNUs5+KrQtc03x8Wv3I=;
        b=c4/PR2plVqAnA3zVKRews+NrIdCaow4aUKBGH9TUa6buN0oLrLjxL6sZqkf3y5YJ7n/gUp
        X7e4aSdMrx73bVHyHB8uOYGt84c3SVqZOBuF1f+VJgU+OgCLPEU3ha3TZloMlcNZMo4ZTN
        CfhT+GRwkpdOOBXxn4qwU0iYLIpm/o0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-yg0wLr6wM-e88C_FVgUgOg-1; Fri, 24 Jul 2020 13:17:26 -0400
X-MC-Unique: yg0wLr6wM-e88C_FVgUgOg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 441F780183C;
        Fri, 24 Jul 2020 17:17:25 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.3.128.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 026F274F64;
        Fri, 24 Jul 2020 17:17:23 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, b.zolnierkie@samsung.com,
        axboe@kernel.dk
Subject: [v4 10/11] print_req_error: Use durable_name_printk_ratelimited
Date:   Fri, 24 Jul 2020 12:17:05 -0500
Message-Id: <20200724171706.1550403-11-tasleson@redhat.com>
In-Reply-To: <20200724171706.1550403-1-tasleson@redhat.com>
References: <20200724171706.1550403-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
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
index 9bfaee050c82..a1f35e3e21d8 100644
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
+	durable_name_printk_ratelimited(KERN_ERR, dev,
 		"%s: %s error, dev %s, sector %llu op 0x%x:(%s) flags 0x%x "
 		"phys_seg %u prio class %u\n",
 		caller, blk_errors[idx].name,
-- 
2.26.2

