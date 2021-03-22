Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9E8C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 06:46:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98AF96196C
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 06:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhCVGp5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 02:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhCVGpd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 02:45:33 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC3AC061574;
        Sun, 21 Mar 2021 23:45:33 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id g15so9556029qkl.4;
        Sun, 21 Mar 2021 23:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QtmhrowCTfNHyoCoFD8E6E78GRrQTtUiAR57cdkH3Hc=;
        b=BZKhcY8qXT9SGbArIyli/3oRwbYk/MNGpjLz4vVXCZkYnXw6SKvlPP3wOxQwrCPpQ4
         SJXHwqX7UaeTROmy5up/sgw2texw08L4aFkoxHnCcwskIdKiRiS8wR/8wYyBtxCWvjR6
         auUJWNURkBA1z9YngfqsQ9eWSl1B2bIfB3tW6qxx6CX1LYyGr30UfD7wfzXzKG6BxZiE
         FaUPXnILQr3F1M8eOJgVt9i82kL/B4dlby4ZBSusiVmbr7Jy5SbEhJ4g6Zu2xRNx/j0T
         Mb49iHFMWKUBY7niD5hQqI6S3WAbXnZBpQzQdFCXYViaBJnH8uXyrSZQqhuJo+e5mw/Z
         htLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QtmhrowCTfNHyoCoFD8E6E78GRrQTtUiAR57cdkH3Hc=;
        b=AlRd/+zJux82ZfVT2mk8RXNkRCPVn+8PzSTW+YGGUmIYNyqaHzhUoFTo01erMSyRko
         yNG+23IW4WzLuQy+0M6hJNOR3GE0m9BrL0W38sD56gXD2ophLuhOF7dSCTVNa9rG/ES2
         DCahNdGMILTlxFsPxLoKr7ho4Pox9pLH7vANm2ex5kZ9PJvNXM5E2l9L69TwZXGRtIDO
         HF9ypKyFWAlr589wFA7RlSKzsMl5PGFg4l5Wtv8SAMHZmOZBV8YfJhekwrZeeUJuFBIA
         iMgmGv+EUr1fvaMoNEmzAfSzb4NugrYH3tJgwxyj9noWyeqfAi4cUvmG2LRc+/pgRAiY
         RQOA==
X-Gm-Message-State: AOAM530uRjnKK/vk1BBlk0vIeaJAzI97p99f+bvECQrc4Q+ceud5yVob
        E21MMx8N/bi2ENZ4tjw6hYc=
X-Google-Smtp-Source: ABdhPJyW73D3T20ui7CtAix+D9CY9HxkZXEzYVD392goAKlXyfo6ejC6MCTGREKBjAaE3ZyXUl06vw==
X-Received: by 2002:a37:ac10:: with SMTP id e16mr9789336qkm.314.1616395532636;
        Sun, 21 Mar 2021 23:45:32 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.40])
        by smtp.gmail.com with ESMTPSA id f8sm8405433qth.6.2021.03.21.23.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 23:45:32 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] scsi_dh: Fix a typo
Date:   Mon, 22 Mar 2021 12:15:21 +0530
Message-Id: <20210322064521.4022142-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


s/infrastruture/infrastructure/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 include/scsi/scsi_dh.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index 2852e470a8ed..a9f782fe732a 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- * Header file for SCSI device handler infrastruture.
+ * Header file for SCSI device handler infrastructure.
  *
  * Modified version of patches posted by Mike Christie <michaelc@cs.wisc.edu>
  *
--
2.31.0

