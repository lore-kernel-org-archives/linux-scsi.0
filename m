Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 037B3C47420
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1ACC2311D
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hyTgD2ZA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbgIYQTz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 12:19:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20440 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729517AbgIYQTp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 12:19:45 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601050784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F6eo05v4RI1S7qaxLX6OH/af8QrKhgKrDe4W0YSlPVc=;
        b=hyTgD2ZAUdVWyRKmAFVSKtXfwrZsiVKwsb4yh2NFJwW4dWCwcKVhCDNyn8VzwhG95uN+tF
        gR62cHPO6X8S9VKyiLPMhZ9rutyufPBq+Y1/ORii7K3H/dAi8L/O5XD8aUwHkj8cpcKJHK
        jMWb4AVGKtbuhbE/o9ZRRfk8nLsKqKU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-7H6l-eN7MamwiCKrXZX-kA-1; Fri, 25 Sep 2020 12:19:42 -0400
X-MC-Unique: 7H6l-eN7MamwiCKrXZX-kA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DCC1104FC80;
        Fri, 25 Sep 2020 16:19:40 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.10.110.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41F335D9DC;
        Fri, 25 Sep 2020 16:19:39 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: [v5 08/12] Add durable_name_printk
Date:   Fri, 25 Sep 2020 11:19:25 -0500
Message-Id: <20200925161929.1136806-9-tasleson@redhat.com>
In-Reply-To: <20200925161929.1136806-1-tasleson@redhat.com>
References: <20200925161929.1136806-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ideally block related code would standardize on using dev_printk,
but dev_printk does change the user visible messages which is
questionable.  Adding this function which adds the structured
key/value durable name to the log entry.  It has the
same signature as dev_printk.  In the future, code that
is using this could easily transition to dev_printk when that
becomes workable.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 drivers/base/core.c        | 15 +++++++++++++++
 include/linux/dev_printk.h |  5 +++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 72a93b041a2d..447b0ebc93af 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3975,6 +3975,21 @@ void dev_printk(const char *level, const struct device *dev,
 }
 EXPORT_SYMBOL(dev_printk);
 
+void durable_name_printk(const char *level, const struct device *dev,
+		const char *fmt, ...)
+{
+	size_t dictlen;
+	va_list args;
+	char dict[288];
+
+	dictlen = dev_durable_name(dev, dict, sizeof(dict));
+
+	va_start(args, fmt);
+	vprintk_emit(0, level[1] - '0', dict, dictlen, fmt, args);
+	va_end(args);
+}
+EXPORT_SYMBOL(durable_name_printk);
+
 #define define_dev_printk_level(func, kern_level)		\
 void func(const struct device *dev, const char *fmt, ...)	\
 {								\
diff --git a/include/linux/dev_printk.h b/include/linux/dev_printk.h
index 3028b644b4fb..4d57b940b692 100644
--- a/include/linux/dev_printk.h
+++ b/include/linux/dev_printk.h
@@ -32,6 +32,11 @@ int dev_printk_emit(int level, const struct device *dev, const char *fmt, ...);
 __printf(3, 4) __cold
 void dev_printk(const char *level, const struct device *dev,
 		const char *fmt, ...);
+
+__printf(3, 4) __cold
+void durable_name_printk(const char *level, const struct device *dev,
+			const char *fmt, ...);
+
 __printf(2, 3) __cold
 void _dev_emerg(const struct device *dev, const char *fmt, ...);
 __printf(2, 3) __cold
-- 
2.26.2

