Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A6FC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97ED0610FB
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236605AbhDOWJ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:09:26 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:38854 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236594AbhDOWJV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 18:09:21 -0400
Received: by mail-pl1-f180.google.com with SMTP id y2so12879148plg.5
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 15:08:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C9geURtvhgy0oh6Os7QkxpkalLgF/JNjljCUvvDlLko=;
        b=CSIbgRwwvqaaPvsiUluB/WLvvqFVNb3ZTxXjBgKbIUU5+65AZqSmkZFtqVopIeE7YY
         /bzewWVpx7FZBEJGQYIzd3QMcA65MXNxOcjgftEZV2gZUUu09G8TEKWxOJ1DRmryG+fH
         7u0IqHUqACp4w2EiEGn7ON4pDw0u4gP58FZHLK4SPb9rBB3k4ZhlVDS0+WrFEdndtVEb
         /QyXEhE2W67dFJmIJBS+tWZh3eM5bVTNVCRtm2qek35Lq2NOsVVJNLZj3OPqCKLMR1WD
         Z7kKJgl0EX0hPCFlBC6TfTcZKOapmPF70HWxGB7UMQsD16qzsyfZslFV/emXM1IDb8xs
         /oqg==
X-Gm-Message-State: AOAM533n6GO9UvlENaN3NM8OjVgEq21F291sRVyL3C3reib5zGdDtyjw
        9RDzsX3+MLhV/OIDSo4Hb6g=
X-Google-Smtp-Source: ABdhPJzCBN9+snMpinSF0D7bWfbb1zt5DJIwmgLG5NTZrPM0vUb/Wb5lp3QZQSORLBxo/CBKGoxejQ==
X-Received: by 2002:a17:90a:34c5:: with SMTP id m5mr6052192pjf.147.1618524537790;
        Thu, 15 Apr 2021 15:08:57 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id w4sm3311155pjk.55.2021.04.15.15.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:08:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 19/20] target: Shorten ALUA error messages
Date:   Thu, 15 Apr 2021 15:08:25 -0700
Message-Id: <20210415220826.29438-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415220826.29438-1-bvanassche@acm.org>
References: <20210415220826.29438-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Do not print tg_pt_gp->tg_pt_gp_valid_id if we already know that it is zero.

Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_configfs.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 9cb1ca8421c8..4b2e49341ad6 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2745,8 +2745,7 @@ static ssize_t target_tg_pt_gp_alua_access_state_store(struct config_item *item,
 	int new_state, ret;
 
 	if (!tg_pt_gp->tg_pt_gp_valid_id) {
-		pr_err("Unable to do implicit ALUA on non valid"
-			" tg_pt_gp ID: %hu\n", tg_pt_gp->tg_pt_gp_valid_id);
+		pr_err("Unable to do implicit ALUA on invalid tg_pt_gp ID\n");
 		return -EINVAL;
 	}
 	if (!target_dev_configured(dev)) {
@@ -2797,9 +2796,7 @@ static ssize_t target_tg_pt_gp_alua_access_status_store(
 	int new_status, ret;
 
 	if (!tg_pt_gp->tg_pt_gp_valid_id) {
-		pr_err("Unable to do set ALUA access status on non"
-			" valid tg_pt_gp ID: %hu\n",
-			tg_pt_gp->tg_pt_gp_valid_id);
+		pr_err("Unable to set ALUA access status on invalid tg_pt_gp ID\n");
 		return -EINVAL;
 	}
 
@@ -2852,9 +2849,7 @@ static ssize_t target_tg_pt_gp_alua_support_##_name##_store(		\
 	int ret;							\
 									\
 	if (!t->tg_pt_gp_valid_id) {					\
-		pr_err("Unable to do set " #_name " ALUA state on non"	\
-		       " valid tg_pt_gp ID: %hu\n",			\
-		       t->tg_pt_gp_valid_id);				\
+		pr_err("Unable to set " #_name " ALUA state on invalid tg_pt_gp ID\n"); \
 		return -EINVAL;						\
 	}								\
 									\
