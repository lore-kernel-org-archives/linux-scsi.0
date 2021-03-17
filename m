Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88757C433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BA0C64F44
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhCQJM4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbhCQJMn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:12:43 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C110FC061765
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:42 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id k8so1004643wrc.3
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/Ist2WriQgAxq9syOJncEZN/L5jXNPETHQWe8qT5KR4=;
        b=hLzEuHn8Dns9Vhn27orHSyf4UKao9+a+puBhH1H69THyHVYuHN6f8svXJWqSWwy8Vb
         fEcGWwVL4ZS6RIxF8xGjkLuIpQ11I+t2yBr5dDekfAk9V7YpqmSFEZ0ScuWMt5ind6Tn
         wk7HtjGa2iNPd+aRXcnPdhwYfIUqtzr/ekeb0o8gK6YnWYYJVRwZmIf+tr2/NS/+Fq5T
         /RWOjcSaUu+IubRpjgKnJwGsOuQCtxEXeASIu2BllR/F2b4ykC0degWjp1aB9l2Ufx7M
         M+Z5BWXThT0+8NV/5FctN8rjj90hEkgu/Wn9+D1ZmeS/D8xbxKOQQrWUE30JWmLekK9/
         9/iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/Ist2WriQgAxq9syOJncEZN/L5jXNPETHQWe8qT5KR4=;
        b=q9L2V0dWVP/1WIDIV4Qvo7ea4tlY33mgvYc2G2CrV7VY2G2Mj2MzqA/g0sH0xmB2Ot
         tUpHgi5DeP7/7dvcb+plJgAbDlir7xqjBYGg3WOIcr9bNBTsPrFmT1y1c06MvDb4VKTk
         AkrumcQ0GqaVrJ1+vQFlqsbvPuEwA1jrLNJVZACCxb6WOZ+lE8P9070ontA7AHPCfO8M
         wYiIsFurudJGyG3byeAOKiP1xHJ/as02QNqHTjkqgdEUIGNHtxtT8dtNAeXl7Xk84Zc2
         ZeRt0BrR0kKkJJHKEVuYELPBeKJ+AGvSB/Cj7uJgOqlvHxqzOdoQx7ypujd4EddTMpMp
         FOKw==
X-Gm-Message-State: AOAM532MR3iDgnMugTwBKNO7ly8e9QykmVS2r/0k5Jh6XnL7M92WSc7S
        qnhe8fC8iqvknjW37J4iEobjJNGoWTkrkA==
X-Google-Smtp-Source: ABdhPJx3hkISBMhUz+a1u024RvY3voUQ85RuXXJngxSxdz33FXGhXVhah7uj0OwXOaElwMiEKkrZYQ==
X-Received: by 2002:a5d:4e52:: with SMTP id r18mr3532653wrt.28.1615972361513;
        Wed, 17 Mar 2021 02:12:41 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:12:41 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 02/36] scsi: ipr: Fix incorrect function names in their headers
Date:   Wed, 17 Mar 2021 09:11:56 +0000
Message-Id: <20210317091230.2912389-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/ipr.c:5335: warning: expecting prototype for ipr_eh_dev_reset(). Prototype was for __ipr_eh_dev_reset() instead
 drivers/scsi/ipr.c:5594: warning: expecting prototype for ipr_eh_abort(). Prototype was for ipr_scan_finished() instead
 drivers/scsi/ipr.c:5616: warning: expecting prototype for ipr_eh_host_reset(). Prototype was for ipr_eh_abort() instead
 drivers/scsi/ipr.c:6725: warning: expecting prototype for ipr_info(). Prototype was for ipr_ioa_info() instead

Cc: Brian King <brking@us.ibm.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/ipr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index e451102b9a299..fd6c974c2754e 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5321,7 +5321,7 @@ static int ipr_sata_reset(struct ata_link *link, unsigned int *classes,
 }
 
 /**
- * ipr_eh_dev_reset - Reset the device
+ * __ipr_eh_dev_reset - Reset the device
  * @scsi_cmd:	scsi command struct
  *
  * This function issues a device reset to the affected device.
@@ -5583,7 +5583,7 @@ static int ipr_cancel_op(struct scsi_cmnd *scsi_cmd)
 }
 
 /**
- * ipr_eh_abort - Abort a single op
+ * ipr_scan_finished - Abort a single op
  * @shost:           scsi host struct
  * @elapsed_time:    elapsed time
  *
@@ -5606,7 +5606,7 @@ static int ipr_scan_finished(struct Scsi_Host *shost, unsigned long elapsed_time
 }
 
 /**
- * ipr_eh_host_reset - Reset the host adapter
+ * ipr_eh_abort - Reset the host adapter
  * @scsi_cmd:	scsi command struct
  *
  * Return value:
@@ -6715,7 +6715,7 @@ static int ipr_ioctl(struct scsi_device *sdev, unsigned int cmd,
 }
 
 /**
- * ipr_info - Get information about the card/driver
+ * ipr_ioa_info - Get information about the card/driver
  * @host:	scsi host struct
  *
  * Return value:
-- 
2.27.0

