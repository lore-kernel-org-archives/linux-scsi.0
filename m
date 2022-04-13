Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC771C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Apr 2022 21:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbiDMVv3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Apr 2022 17:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234075AbiDMVv3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2022 17:51:29 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077EF4705D
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 14:49:07 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id n22so2809272pfa.0
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 14:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thejof-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N+nLapIv4dRBveuNJm5K5jQf+KxBDb0VN5bdOKa5W18=;
        b=YjU46vSdD/jmW6iEYVZnRQQCL01saWmchajLrzSn9X01IUYg0NUNDJcWN++7IBs/nc
         K49YFsPGfHEPL8XOXMvefxTYkIvSrITNjvhOrnLz8pooDLr83ioJPAkof532sAOoi5NO
         YtTBgij9mzWxHQNzEf+fTtd42MbXC1ZwKWcYYWg4opAvk9DgL6Bs4SrarJC1IaohHCC0
         2M4H0o85gPMgWABXkD6oLk0x9Fe9kWDx8fmIegvmY8PbelUeVlkXWDPZJX6SZt/nz7vp
         ZwaLbGYCjQ7SDwda2UvLn9NbKzzv1bQetkStg1NNOuZS74jiOAgtR/9T+PbDo3DPVJCx
         cIZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N+nLapIv4dRBveuNJm5K5jQf+KxBDb0VN5bdOKa5W18=;
        b=wVZSCYRRwkcaOPcBsYu8BhXABs74ULBpBIyIlwD0ij5LjW/z8r7AOSWR/yTMfvyBxm
         +Cz/rTmzedKx1oevSALFv3wnIfkjVh3zWBReZ5rKlMdJ17T3m2iKvS+UeiDsT6F/eCan
         i2WmrKlFY0CvYc0YOVox+dDpdYlJa7KqLfJj/NyZvjazW0BYL0jT75PJ1LSn9UWJxGww
         kHQ2zvnm6iBzGoh4rBzbPtJwb7CeYA5mbvdemOI/6R7L3jNsbEfcoL+6A+FFpdEPZapx
         3z6NVTo4RuNM6LkxWOm0jzOaQnUcr+cf9nn+9qyBBqw61r+a/mKvtqoeXwwdqjrgAeNA
         Mz3A==
X-Gm-Message-State: AOAM533wdwzMICWwoA+R845L4l5SuhzW+q8VGr7yUiIu+ecF1OGbd7xU
        OoTs/SIIlZbS20VExxZyMeEi8V9aynSr4visgcAM+w==
X-Google-Smtp-Source: ABdhPJyTy8q3tWHWjsxiLQfsC0JBm4vHCUeIeGfdvlni5zuL9Eegwik5BGuXJlTOwz9F+xm2ebTTiA==
X-Received: by 2002:a65:53cc:0:b0:382:8506:f1a6 with SMTP id z12-20020a6553cc000000b003828506f1a6mr36834627pgr.44.1649886546249;
        Wed, 13 Apr 2022 14:49:06 -0700 (PDT)
Received: from oak.jof.github.beta.tailscale.net ([2601:645:8780:7d20::5f8c])
        by smtp.gmail.com with ESMTPSA id k13-20020aa7820d000000b004fa72a52040sm37508pfi.172.2022.04.13.14.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 14:49:05 -0700 (PDT)
From:   Jonathan Lassoff <jof@thejof.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jonathan Lassoff <jof@thejof.com>
Subject: [PATCH 1/1] Add printk indexing to scsi drivers.
Date:   Wed, 13 Apr 2022 21:47:36 +0000
Message-Id: <20220413214735.3870-2-jof@thejof.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220413214735.3870-1-jof@thejof.com>
References: <20220413214735.3870-1-jof@thejof.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The printk index collects some of the format strings and locations.
Kernel developers, packagers, and operators can examine the index
contents to see what may get printed out to the kernel message buffer.
This can be useful for developers of message matchers or documentation
to detect changes from release to release, without requiring any kind of
coordination or commitment from the Kernel developer community.

So that detailed SCSI driver messages are captured by this printk index,
this patch wraps sdev_prefix_printk with a macro.
---
 drivers/scsi/scsi_logging.c | 7 ++++---
 include/scsi/scsi_device.h  | 8 +++++++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index b02af340c2d3..a348d931472e 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -53,7 +53,8 @@ static size_t sdev_format_header(char *logbuf, size_t logbuf_len,
 	return off;
 }
 
-void sdev_prefix_printk(const char *level, const struct scsi_device *sdev,
+
+void _sdev_prefix_printk(const char *level, const struct scsi_device *sdev,
 			const char *name, const char *fmt, ...)
 {
 	va_list args;
@@ -75,10 +76,10 @@ void sdev_prefix_printk(const char *level, const struct scsi_device *sdev,
 		off += vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
 		va_end(args);
 	}
-	dev_printk(level, &sdev->sdev_gendev, "%s", logbuf);
+	_dev_printk(level, &sdev->sdev_gendev, "%s", logbuf);
 	scsi_log_release_buffer(logbuf);
 }
-EXPORT_SYMBOL(sdev_prefix_printk);
+EXPORT_SYMBOL(_sdev_prefix_printk);
 
 void scmd_printk(const char *level, const struct scsi_cmnd *scmd,
 		const char *fmt, ...)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 57e3e239a1fc..f9dcbd8dc51e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -263,9 +263,15 @@ struct scsi_device {
  * as a string pointer
  */
 __printf(4, 5) void
-sdev_prefix_printk(const char *, const struct scsi_device *, const char *,
+_sdev_prefix_printk(const char *, const struct scsi_device *, const char *,
 		const char *, ...);
 
+#define sdev_prefix_printk(level, sdev, name, fmt, ...)             \
+({                                                                  \
+		printk_index_subsys_emit("%s %s: [%s] ", level, fmt);       \
+		_sdev_prefix_printk(level, sdev, name, fmt, ##__VA_ARGS__); \
+})
+
 #define sdev_printk(l, sdev, fmt, a...)				\
 	sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
 
-- 
2.30.2

