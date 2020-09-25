Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81023C4727D
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D9E121D7A
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Usm+W0Ra"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgIYQTk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 12:19:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33506 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728443AbgIYQTi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 12:19:38 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601050777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tjfyyqBk18iK3mdk298NBEQQwB4z45w48Rk7GFdPx3g=;
        b=Usm+W0RaSVWQNz5FDoRFyadWj+A84Wr87Iwx7kLKo8YsIutN0KbBVfPusJADXPwpykWduq
        XpeFobEUSVozWWJ46BjiwE3AR7Aq7HVETJFW/YsrOz91ddz8ei8bgMlAWkSZ0LQSWE2UR+
        6Mh3tMdaXyjEwRWkHEwUeSn139yKfW8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-Gc0cH_BDPRmq_HAU3k6tPg-1; Fri, 25 Sep 2020 12:19:35 -0400
X-MC-Unique: Gc0cH_BDPRmq_HAU3k6tPg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D9691DDF3;
        Fri, 25 Sep 2020 16:19:34 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.10.110.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFBCB5D9DC;
        Fri, 25 Sep 2020 16:19:33 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: [v5 03/12] dev_vprintk_emit: Increase hdr size
Date:   Fri, 25 Sep 2020 11:19:20 -0500
Message-Id: <20200925161929.1136806-4-tasleson@redhat.com>
In-Reply-To: <20200925161929.1136806-1-tasleson@redhat.com>
References: <20200925161929.1136806-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With the addition of the device persistent id we have the possibility
of adding 154 more bytes to the hdr.  Thus if we assume the previous
size of 128 was sufficient we can simply add the 2 amounts and round
up.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 drivers/base/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index adef36d4b475..72a93b041a2d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3924,7 +3924,7 @@ create_syslog_header(const struct device *dev, char *hdr, size_t hdrlen)
 int dev_vprintk_emit(int level, const struct device *dev,
 		     const char *fmt, va_list args)
 {
-	char hdr[128];
+	char hdr[288];
 	size_t hdrlen;
 
 	hdrlen = create_syslog_header(dev, hdr, sizeof(hdr));
-- 
2.26.2

