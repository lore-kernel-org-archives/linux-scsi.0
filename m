Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED9EC43332
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C2D464F37
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhCQJNi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbhCQJNB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:13:01 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E33C0613DD
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:59 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id m20-20020a7bcb940000b029010cab7e5a9fso2934864wmi.3
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1cUaH1b/K2O6ERJ+bzFiuL6brJDSqamBpVZhrZptGlg=;
        b=Im7bMn59N95huVs4Cu4fmRc+YGmxvRCVAMpXXHJhZWc1pJOWrIaZSXIMXl5w8V/lSr
         YJvntp3NAD6/3rrIW26RPA/WItV8qBpPgULuGC28khbozZ3k0Wat4XlD95GvkSkAcv/C
         m9I9ObxabwTJhuGmzCzb+q2778Y7BK4eg8xjD2eNFMcmovc078KN0GGDrR5MuMfEm50a
         tymDrTgN/8qneiFeUnZPu26PhGPvhZWbj9LIZIRCHW7UoMBpiwULAAe899JKIAj5ns7y
         GBvbRmTzzUbXt2Pm5fvtFywSkRAIhrl/c7jj55xm2xPaZIDxCWy/vgce1cC3REk9Wmc5
         fvnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1cUaH1b/K2O6ERJ+bzFiuL6brJDSqamBpVZhrZptGlg=;
        b=J0tgQF6dpXgDRJe5dzSd5hXyLIhcyGUMGQHBa8x4RXO/Of869Z0wlI5CP7eVEJftmE
         O63tcmfQ3a9XC61ESP4JmLkEeovoO/4EqT50k2EAIPRvnERDPevkLUrmzxcITqNoUk++
         HcQUe2n/ga608V3ZMnzdBOpPJsmFcFwcFyImWCKTMMLDBlan0lA+amq3gqLPmmBylrfG
         H59AmOX2qggqzMpoEER15OhUwj4Ycf86tFrbefn0luA9/SvNcCHnHBTw/qNO3TP+zyS+
         usHivqfjKvpPYkhHCk+oOQbrbzIg0DgWd+VtUeqnW8oPKUwLqJPucXxSChQ7la+pUxh3
         Ahjw==
X-Gm-Message-State: AOAM532+PBADOXdhTIcXqT4sKneRPenMinQo4Rq4Z+u9a+2GLw3u9sGt
        p7qJ/q91f7gAw6d0YTfz6k393A==
X-Google-Smtp-Source: ABdhPJwIk5rpoN3LmJQkdEKCG9jZDzdAiOO4zRK9qdElTovUN0ILJhHR+J3PBnW2y3jZYlqEt4zoMg==
X-Received: by 2002:a1c:f404:: with SMTP id z4mr2748623wma.39.1615972378673;
        Wed, 17 Mar 2021 02:12:58 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:12:58 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 18/36] scsi: fnic: fnic_fcs: Kernel-doc headers must contain the function name
Date:   Wed, 17 Mar 2021 09:12:12 +0000
Message-Id: <20210317091230.2912389-19-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/fnic/fnic_fcs.c:308: warning: expecting prototype for Check if the Received FIP FLOGI frame is rejected(). Prototype was for is_fnic_fip_flogi_reject() instead

Cc: Satish Kharat <satishkh@cisco.com>
Cc: Sesidhar Baddela <sebaddel@cisco.com>
Cc: Karan Tilak Kumar <kartilak@cisco.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/fnic/fnic_fcs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index e0cee4dcb4391..881c4823d7e24 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -296,7 +296,7 @@ void fnic_handle_event(struct work_struct *work)
 }
 
 /**
- * Check if the Received FIP FLOGI frame is rejected
+ * is_fnic_fip_flogi_reject() - Check if the Received FIP FLOGI frame is rejected
  * @fip: The FCoE controller that received the frame
  * @skb: The received FIP frame
  *
-- 
2.27.0

