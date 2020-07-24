Return-Path: <SRS0=9S6W=BD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E90FC4345D
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 17:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F6752070B
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 17:17:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QgDlSM0v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgGXRR2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 13:17:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42253 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726617AbgGXRR0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 13:17:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595611045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oSlX4q9qPcgrYzkVhKJS1bSnP7QaRJh6k1RERLvLpgM=;
        b=QgDlSM0vCog/BXcnChmMgQH6neCYtDVl/Kdlpq0OY5aBZM0cX1Cn4xSMgfDYLRYShP9ems
        0p+e4Nh8aS5ZYgLIQljpHV7KAJ2zZKyIwxYWu2LpHh/GfSi4LCudk1DQpAvykAMpeaJliG
        YPSyaO8eIFZQ741l7cEBIWJLjCxSZ8k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-9AoSTa1sNEaDeNxosstYRQ-1; Fri, 24 Jul 2020 13:17:21 -0400
X-MC-Unique: 9AoSTa1sNEaDeNxosstYRQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EEE958;
        Fri, 24 Jul 2020 17:17:20 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.3.128.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4389674F64;
        Fri, 24 Jul 2020 17:17:19 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, b.zolnierkie@samsung.com,
        axboe@kernel.dk
Subject: [v4 07/11] Add durable_name_printk
Date:   Fri, 24 Jul 2020 12:17:02 -0500
Message-Id: <20200724171706.1550403-8-tasleson@redhat.com>
In-Reply-To: <20200724171706.1550403-1-tasleson@redhat.com>
References: <20200724171706.1550403-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
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
index c2439d12608d..aaf7b8256712 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3865,6 +3865,21 @@ void dev_printk(const char *level, const struct device *dev,
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
index 5aad06b4ca7b..502cf9fd7fe7 100644
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

