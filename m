Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6574C47431
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 797D82344C
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SMwzqXnR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbgIYQTy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 12:19:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43424 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729522AbgIYQTp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 12:19:45 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601050785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JVm1mp3p8i8CqDumdPNUgn0vv7qi6XfNucb1VG5u2E8=;
        b=SMwzqXnRKMTCW4hKlscsr5jYUwAXN5YFP2aiPr/hWrqZpqYxz3sLUThx0aYyc5Gl72FTks
        mc/dUWZEqerEe3EXLZfbLt9um9nci6gfiaBiFJ0ZWsh36AzcvEKHLwxMR8vwfSH1cSvtqq
        /yghLGb4iqhg/MzKhgSIil2zPpggEyI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-NIvPIg8dOka0XoIinW8uFA-1; Fri, 25 Sep 2020 12:19:43 -0400
X-MC-Unique: NIvPIg8dOka0XoIinW8uFA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31A4326557;
        Fri, 25 Sep 2020 16:19:42 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.10.110.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6211E5D9DC;
        Fri, 25 Sep 2020 16:19:41 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: [v5 10/12] Add durable_name_printk_ratelimited
Date:   Fri, 25 Sep 2020 11:19:27 -0500
Message-Id: <20200925161929.1136806-11-tasleson@redhat.com>
In-Reply-To: <20200925161929.1136806-1-tasleson@redhat.com>
References: <20200925161929.1136806-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Create a rate limited macro for durable_name_printk so that
we can use this for printk_ratelimited usage in the block
layers and add the durable name key/value to the log
message.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 include/linux/dev_printk.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/dev_printk.h b/include/linux/dev_printk.h
index 4d57b940b692..9fd675b9ac7c 100644
--- a/include/linux/dev_printk.h
+++ b/include/linux/dev_printk.h
@@ -37,6 +37,15 @@ __printf(3, 4) __cold
 void durable_name_printk(const char *level, const struct device *dev,
 			const char *fmt, ...);
 
+#define durable_name_printk_ratelimited(level, dev, fmt, ...)		\
+do {									\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+					DEFAULT_RATELIMIT_INTERVAL,	\
+					DEFAULT_RATELIMIT_BURST);	\
+	if (__ratelimit(&_rs))						\
+		durable_name_printk(level, dev, fmt, ##__VA_ARGS__);	\
+} while (0)
+
 __printf(2, 3) __cold
 void _dev_emerg(const struct device *dev, const char *fmt, ...);
 __printf(2, 3) __cold
-- 
2.26.2

