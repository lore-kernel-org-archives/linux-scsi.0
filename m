Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20263C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Apr 2022 22:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbiDMWE7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Apr 2022 18:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234544AbiDMWE6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2022 18:04:58 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14A221E0A
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 15:02:35 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id a16-20020a17090a6d9000b001c7d6c1bb13so3752433pjk.4
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 15:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thejof-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VXE2lhxJ7a+Az148QixVj0EDrAKIoM3zV1jdntotgyE=;
        b=234oPgWlSUNbetydXd4byxHUQ78lCWKiUkNP5sqbneXGhtnS9crd0NNZXJTvPS8Okr
         n3jYHSaaJ2LjGyYv08rYniBfQK5rxkIE2qfhOiFjQe1BvMpWcmdprNX0liJj62cymUz7
         AtLkzt+rhrg5t9nCCtv4pNqIEipxljFWE50hxjRJSbwp/kEqTSJ9H677HYG1J06xErbN
         7iPiT61dClXl3/OnI166pbTaRbhxY/QJo3yYzLtaafiLi7zK0aVEylkQbAGDIZIW4vD8
         poDnwDOdggy9Fo6IkZTbqBzRSIVPGc8lmyT8S+6wTom6aiQMhtLCiTVxVRRf2pWdrYVR
         GB2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VXE2lhxJ7a+Az148QixVj0EDrAKIoM3zV1jdntotgyE=;
        b=3ASL4Ya4yzZWfrHPfNh+FTl1hra6/EzlGBtinuzBuxHUHv27uKMw1efotWt7+hP1Nw
         /XwZNIMDE35gykV/zei6a5kkstxuG3/RRvt2ZcTrebzloRFq1gq09bMIualZrkWfM09p
         7ZB9EC+O5NtZ8jmn67VikkDn+d1SHZvPJnGiFkZuS69HW/+CsylQpOK+4sgx5FJIMMeX
         ucONaWoHGMU39Ybr1Jlh/zaQpwQMRBV90DIEKDgB8Pv778aiMwGA1sQX8DwqJM/ttGik
         g3Y5Wzg//WqEfQORmsAhNX2s/YMZ89wZE/WR3201KIwsOlJTWva+6ktXFtptzbCyaIid
         SvEg==
X-Gm-Message-State: AOAM530xO05jFVDhtUY1uLV6fOureR7SF6V2gkyFvE+dm7EChg9MjeM5
        p7GiT0Rkwps65C+jYDAE32Aj3xFDRLAIZ1zxNyYSow==
X-Google-Smtp-Source: ABdhPJxKm2gfU+8LigIzvF27okzNew93JR+qLYNnxn2DKggNtOdZZ+aZK86hzp4T7p277KhO9xiWGw==
X-Received: by 2002:a17:90b:1bc4:b0:1cb:c3db:5f4c with SMTP id oa4-20020a17090b1bc400b001cbc3db5f4cmr242210pjb.125.1649887354845;
        Wed, 13 Apr 2022 15:02:34 -0700 (PDT)
Received: from oak.jof.github.beta.tailscale.net ([2601:645:8780:7d20::5f8c])
        by smtp.gmail.com with ESMTPSA id z6-20020a056a00240600b004e17ab23340sm55586pfh.177.2022.04.13.15.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 15:02:34 -0700 (PDT)
From:   Jonathan Lassoff <jof@thejof.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jonathan Lassoff <jof@thejof.com>
Subject: [PATCH 1/1] Add printk indexing to scsi drivers.
Date:   Wed, 13 Apr 2022 22:02:12 +0000
Message-Id: <20220413220212.4738-2-jof@thejof.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220413220212.4738-1-jof@thejof.com>
References: <20220413220212.4738-1-jof@thejof.com>
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

Signed-off-by: Jonathan Lassoff <jof@thejof.com>
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

