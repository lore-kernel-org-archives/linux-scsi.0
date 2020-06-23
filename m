Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F3E9C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 19:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 312BB20888
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 19:18:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JvmYPyeH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387510AbgFWTSB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 15:18:01 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34992 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387478AbgFWTSA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Jun 2020 15:18:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592939879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mw38SrAOK4PZpvbcKWC3wVsl3jfKtIJjGqTKE+RHMHI=;
        b=JvmYPyeHwWoE0WzsFKt2BjyaXGtG8yxD4GWb3RPmjqnN6qaE16B0I9w6KMwXzCRflhER67
        OB5xwJ50ORt6aZFPHyEVtZE7ssQhKGH6eQvXTtlgfBVM/1alJyIKILwMm1z2N+g2od21nK
        ELjijTJTpDcKzr+wtay6+lO1rARm9Io=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-h5LrkLiZO1yElnw2pIGn3w-1; Tue, 23 Jun 2020 15:17:58 -0400
X-MC-Unique: h5LrkLiZO1yElnw2pIGn3w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 057E418585A1;
        Tue, 23 Jun 2020 19:17:57 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.3.128.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0B4A71694;
        Tue, 23 Jun 2020 19:17:55 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: [RFC PATCH v3 4/8] buffer_io_error: Use dev_printk
Date:   Tue, 23 Jun 2020 14:17:45 -0500
Message-Id: <20200623191749.115200-5-tasleson@redhat.com>
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
 fs/buffer.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index a60f60396cfa..97b8f455c031 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -133,10 +133,16 @@ __clear_page_buffers(struct page *page)
 
 static void buffer_io_error(struct buffer_head *bh, char *msg)
 {
-	if (!test_bit(BH_Quiet, &bh->b_state))
-		printk_ratelimited(KERN_ERR
+	if (!test_bit(BH_Quiet, &bh->b_state)) {
+		struct device *gendev;
+
+		gendev = (bh->b_bdev->bd_disk) ?
+			disk_to_dev(bh->b_bdev->bd_disk) : NULL;
+
+		dev_err_ratelimited(gendev,
 			"Buffer I/O error on dev %pg, logical block %llu%s\n",
 			bh->b_bdev, (unsigned long long)bh->b_blocknr, msg);
+	}
 }
 
 /*
-- 
2.25.4

