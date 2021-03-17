Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4834C43331
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9885364F67
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhCQJNh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbhCQJNB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:13:01 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0776AC0613DB
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:59 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo832025wmq.4
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2WzJnbFL63fAV5MF42unVnj6zPztfqCHzahd4B5nEa4=;
        b=jZUCRs8H69Csf5GhLrFIyA4rweatwr5fIlLJsoTfOZCevrPenu0dFtLGuORdXc2276
         2Jkd2Ts0hUStkN6TbwYXKHElcc00A3iOyZ68bsVRYT9ohIaBIYri9u/kClPJPP9LXDsE
         R7riR2wJUO1CGCWXqFtnMzjImY/oPqxtL406B6FX7pHyM8UnhI3vjV931tGiXRh1FKRM
         ZH+0/sNADp74b6brzumnXVo+PMTF2snqJqE9qmHykwBnTPIv6bTrC3Fc2brOZMBuj4RK
         2EJK9JccG0CyvMBYRmw1yei1MUr6x5WPwzlfPuo4K+gea1JdHh81fDketrOqFQ0Sum5U
         IXvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2WzJnbFL63fAV5MF42unVnj6zPztfqCHzahd4B5nEa4=;
        b=d+DKEcx91jsC4py1FTXmxPt8oUud7azPnasgoVDJIAzpYFLg/LK9S9+KxhEWt2+1ia
         j0AH+dxtrRwNi2Wu5dz26Er3GUr4NBLrtpEZAdllfogL8u9B1E6sgt2Y7Z2QEbsvy5nY
         WlywEw9MQwJJPW56doTKW+xKcGEFNAspks2L7tOfSAxoMk4+YrQYqVzCGSLNRsztDxkY
         +UbS+WpP00y/J4eFsfDAezyeN99K5ZH/0I1oyV+MiE3aoir3+VztF0+RSObMf7XgI15H
         ypq0SeR/5MVV/ZgKDu8AnIzqbbBmLfzr+vC3hFQuVskyW7V7P8ENWi3mCka4CguGVxMw
         7pJQ==
X-Gm-Message-State: AOAM533CzaMqcWoafEHt7F7JqJw3Nr8r2P3dpVflUPh/Y/KAuPqCUlT5
        e0nrhDH33K1DYsaVTW8uyu5Utw==
X-Google-Smtp-Source: ABdhPJy4Rc8DlJvoxcqDMdMNTBb6d2JmTTrCLlkVJiCcC6wkRqqi0PABaVpBSQLbvZO8sgkBKM/WUg==
X-Received: by 2002:a05:600c:198c:: with SMTP id t12mr2650590wmq.183.1615972377801;
        Wed, 17 Mar 2021 02:12:57 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:12:57 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 17/36] scsi: fnic: fnic_scsi: Demote non-conformant kernel-doc headers
Date:   Wed, 17 Mar 2021 09:12:11 +0000
Message-Id: <20210317091230.2912389-18-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/fnic/fnic_scsi.c:183: warning: Function parameter or member 'fnic' not described in '__fnic_set_state_flags'
 drivers/scsi/fnic/fnic_scsi.c:183: warning: Function parameter or member 'st_flags' not described in '__fnic_set_state_flags'
 drivers/scsi/fnic/fnic_scsi.c:183: warning: Function parameter or member 'clearbits' not described in '__fnic_set_state_flags'
 drivers/scsi/fnic/fnic_scsi.c:2296: warning: Function parameter or member 'fnic' not described in 'fnic_scsi_host_start_tag'
 drivers/scsi/fnic/fnic_scsi.c:2296: warning: Function parameter or member 'sc' not described in 'fnic_scsi_host_start_tag'
 drivers/scsi/fnic/fnic_scsi.c:2316: warning: Function parameter or member 'fnic' not described in 'fnic_scsi_host_end_tag'
 drivers/scsi/fnic/fnic_scsi.c:2316: warning: Function parameter or member 'sc' not described in 'fnic_scsi_host_end_tag'

Cc: Satish Kharat <satishkh@cisco.com>
Cc: Sesidhar Baddela <sebaddel@cisco.com>
Cc: Karan Tilak Kumar <kartilak@cisco.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/fnic/fnic_scsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 36744968378ff..e619a82f921b1 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -173,7 +173,7 @@ static int free_wq_copy_descs(struct fnic *fnic, struct vnic_wq_copy *wq)
 }
 
 
-/**
+/*
  * __fnic_set_state_flags
  * Sets/Clears bits in fnic's state_flags
  **/
@@ -2287,7 +2287,7 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 	return ret;
 }
 
-/**
+/*
  * fnic_scsi_host_start_tag
  * Allocates tagid from host's tag list
  **/
@@ -2307,7 +2307,7 @@ fnic_scsi_host_start_tag(struct fnic *fnic, struct scsi_cmnd *sc)
 	return dummy->tag;
 }
 
-/**
+/*
  * fnic_scsi_host_end_tag
  * frees tag allocated by fnic_scsi_host_start_tag.
  **/
-- 
2.27.0

