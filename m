Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0401DC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 10:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5C8264E83
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 10:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhCQKNG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 06:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhCQKM6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 06:12:58 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE98FC06174A;
        Wed, 17 Mar 2021 03:12:57 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id 73so919833qtg.13;
        Wed, 17 Mar 2021 03:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qq+6rnjwZUXy0xdppfbPndd57JZCgaq/YgQkJLINgHE=;
        b=SMyHqGTntvVj5VKZDTgIz1os+brbsz83qBFt1WcKY5bTmCQE5jG+8Mrs+m2jpVGXw/
         7mAPxEUMN/wIij8N/z/pOYkHUCAPZnsFp/GK1CtWBfr8+tuJCNQoHeN0OeC9PnYuPaXy
         18hhN/xf1WiyUhB7igEmukBaewXBsx85EL3gltLHf6n8NI9N7r9wX8J+hm2i/msnLhkd
         AL+o9Pcho2ah7uHkGZ1kcm0jA0Ts2dnFqaA1edB0SukKpTn1V+msBRDlgy7P625674LN
         uFwSV+RAQ79Dmo4wN0m+y2ATuPibX92vGe7IhZcv5GCF0fucSKCed0RXc7ydrl2fdTey
         d+Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qq+6rnjwZUXy0xdppfbPndd57JZCgaq/YgQkJLINgHE=;
        b=K5qhe7DPhXcxcB+b96tOKLftdorPXWa5yd2k4ToSogezo/dJmxKQHqsZ0ICbqnFa3i
         sM1rQINoBgGB1ijgqZnXe5feyTXmsPnBV5I6ycAs7IXu8RiIObLaJRHICfqtJl3bXUC9
         sVLsJ0Dn65NKCEPwxXsWewJOVqwbDA33M9xCwzq7BsanWwQsySG8Axl2Nc+LJyXSk5ht
         OWbEXY/j0Q7A8AjXcoqXOVos1z2lwBAQbKK+9flrc5qFIp4n28/GTvzDy62IM2r2I3g6
         KsMYgD2NgkTuFhBJa+t1G0DdG8wrcukBkJWjSHNjrElK/6wL1/uDqgp47ucuj9TqnYFR
         2C3w==
X-Gm-Message-State: AOAM532nSR/3YcLpD6u2U/Uq4Y5yQssY6MqmZ5Wkmoi8Y4M3isOpmRi7
        KjLYETqwYui2UON851d9UyU=
X-Google-Smtp-Source: ABdhPJzbEuLCgLKH92IsbHHtuY9C5ljyRO7REUBh+cjhdsDoJJpvaGIsGT0582g7xK0Q4nkHvC6L1w==
X-Received: by 2002:ac8:5448:: with SMTP id d8mr3112813qtq.392.1615975977108;
        Wed, 17 Mar 2021 03:12:57 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.48])
        by smtp.gmail.com with ESMTPSA id i89sm13802871qtb.95.2021.03.17.03.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 03:12:56 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] message: fusion: Fix a typo in the file mptbase.h
Date:   Wed, 17 Mar 2021 15:42:38 +0530
Message-Id: <20210317101238.2627574-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


s/contets/contents/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/message/fusion/mptbase.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 813d46311f6a..b9e0376be723 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -274,7 +274,7 @@ typedef union _MPT_FRAME_TRACKER {
 	} linkage;
 	/*
 	 * NOTE: When request frames are free, on the linkage structure
-	 * contets are valid.  All other values are invalid.
+	 * contents are valid.  All other values are invalid.
 	 * In particular, do NOT reply on offset [2]
 	 * (in words) being the * message context.
 	 * The message context must be reset (computed via base address
--
2.30.2

