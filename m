Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA426C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Mar 2022 05:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiCQF4A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Mar 2022 01:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiCQFz6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2022 01:55:58 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D45104A66
        for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2022 22:29:40 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id z16so5964539pfh.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2022 22:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thejof-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iMAa32qn8nQJhxNmYxgEASFXZAhR05S+rnNGsuL3qrk=;
        b=2OLIO26ngVzUov6e/NU8wrWOmWcILgn0p3rec0FUwtd8uL6xWqdlvlzzys9+P+4emJ
         weeHuoiE0OUSo9Kb6ITC6NAiNoJeWO4C6rO9LcQCHhA7oO41EdCgLZwlGJc4rS3iqVCW
         IflyBh9GgeVD/KjLS/7bTviaypjjpZaf4torSx6ozBqgStkWSA3tZ6p/DriE1EE77EpG
         nAoWD56rP59gdz4H7/LmQedWuwmYF71k+9LwLh5ZdTlN3ZzYhtrOrqqhaHdzXTYfQkBR
         CrOlOqp3IZBcwevCuE7spWute9gouh/ORl92rksdfchmr48xyD8Zj94GI7m31Hfp0vWG
         v2Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iMAa32qn8nQJhxNmYxgEASFXZAhR05S+rnNGsuL3qrk=;
        b=hgKtShSYA4Z0XZR5CjySCl206mNQBmizBhgWnd7pupMC/aWgpeJciftwmQYlYbvNMa
         Y/aCduC9zJ0XJto9GNwuoLHzBZurLFKJBcGWUiJ/wZYpeqQgz8bXE4hlybvV4hhUckT7
         CC7iWCdzX2jVYri2BJDoUElvpIDs894P1j8xP+oQNGpqNsl1Lye0jWFIr1d9Scr9E6pD
         6kq+l4VAxCsTcJ19Idxu1beulVRsdCFIWVZoBAZC5LzlDVWg+KTMnNR9UxVmxljhnkjH
         uCi33j2WuZR+4ti6gKRLWP01Lwf9PfrywjzjLzxDk7/ZQr+8cxvzd1o8Q7jrg76mvoDF
         Ygzw==
X-Gm-Message-State: AOAM5322ipQWBc/gVbcPojYWd5OjNnuHWvgxeb6VYsGAw7Bjl1kyadzJ
        8o7Kvm0D1HFsWsU1UG2YcQJElDDdKM8Nhy0Tqmc=
X-Google-Smtp-Source: ABdhPJwuieccXf1e/IzXgHDvP2IvNTIhOKZ5NpA+OTd/3ltzXU114ktBEC7v3MgDOzAQjY6Ep2kwzQ==
X-Received: by 2002:a05:6a00:2448:b0:4f7:a138:29c7 with SMTP id d8-20020a056a00244800b004f7a13829c7mr2782716pfj.32.1647494979998;
        Wed, 16 Mar 2022 22:29:39 -0700 (PDT)
Received: from banyan.jof.github.beta.tailscale.net ([2600:1700:2f74:11f:a6ae:11ff:fe14:a442])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a00115000b004f6ff260c9esm5138311pfm.207.2022.03.16.22.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 22:29:39 -0700 (PDT)
From:   Jonathan Lassoff <jof@thejof.com>
To:     linux-scsi@vger.kernel.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Lassoff <jof@thejof.com>
Subject: [PATCH v0 1/2] Add printk indexing to scsi drivers.
Date:   Wed, 16 Mar 2022 22:29:34 -0700
Message-Id: <bb8faa82799b2ced7ed1948857f652f0330f92cf.1647494793.git.jof@thejof.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In order for end users to quickly react to new issues that come up in
production, it is proving useful to leverage the printk indexing system.
This printk index enables kernel developers to use calls to printk()
with changable ad-hoc format strings, while still enabling end users to
detect changes and develop a semi-stable interface for detecting and
parsing these messages.

So that detailed SCSI driver messages are captured by this printk index,
this patch wraps sdev_prefix_printk with a macro.

Signed-off-by: Jonathan Lassoff <jof@thejof.com>
---
 drivers/scsi/scsi_logging.c | 7 ++++---
 include/scsi/scsi_device.h  | 8 +++++++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index 1f8f80b2dbfc..62aae95fc80f 100644
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
index 647c53b26105..59a1087107ed 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -262,9 +262,15 @@ struct scsi_device {
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
2.35.1

