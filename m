Return-Path: <SRS0=9S6W=BD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC646C433F7
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 17:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E58620737
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 17:17:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NpyVqwUk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgGXRRV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 13:17:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23297 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726895AbgGXRRS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 13:17:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595611037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1I1jj7ycE4M8Ce2HJV0/6+ITH9/gcB8f4Vcrj+v3V5Q=;
        b=NpyVqwUk8+ROG/u8kv+cku1HpOrFoxdjrBSeepP7Em3fafJpzhCVLjNYEnefiKcPSxARQc
        iICvnBKFm0+/k0TZM4zVruXIvQrKZamHKlqQeFubidQo7IBIVIUv3knuBpKXKF2CB1HOSZ
        9YUEYcjyGGgetsb4kfjARrEwbN6NH3o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-euqzHgGTMtaMOXJQeLhktw-1; Fri, 24 Jul 2020 13:17:15 -0400
X-MC-Unique: euqzHgGTMtaMOXJQeLhktw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 402291009615;
        Fri, 24 Jul 2020 17:17:14 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.3.128.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02EE379D01;
        Fri, 24 Jul 2020 17:17:12 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, b.zolnierkie@samsung.com,
        axboe@kernel.dk
Subject: [v4 03/11] dev_vprintk_emit: Increase hdr size
Date:   Fri, 24 Jul 2020 12:16:58 -0500
Message-Id: <20200724171706.1550403-4-tasleson@redhat.com>
In-Reply-To: <20200724171706.1550403-1-tasleson@redhat.com>
References: <20200724171706.1550403-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With the addition of the device persistent id we have the possibility
of adding 154 more bytes to the hdr.  Thus if we assume the previous
size of 128 was sufficent we can simply add the 2 amounts and round
up.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 drivers/base/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 964690572a89..c2439d12608d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3814,7 +3814,7 @@ create_syslog_header(const struct device *dev, char *hdr, size_t hdrlen)
 int dev_vprintk_emit(int level, const struct device *dev,
 		     const char *fmt, va_list args)
 {
-	char hdr[128];
+	char hdr[288];
 	size_t hdrlen;
 
 	hdrlen = create_syslog_header(dev, hdr, sizeof(hdr));
-- 
2.26.2

