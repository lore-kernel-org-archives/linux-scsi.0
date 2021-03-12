Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5715DC41519
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FC5364FF3
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbhCLJsv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbhCLJsV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:48:21 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F00C061574
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:09 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id l19so3399649wmh.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cAgrlXd2l1LJdhAbUiQiEGzy9+X15djTsbIgtd+mY2I=;
        b=lVMCHULUc5/aA9eGRFFQrjna7vIsiRzLtnqSsoC0NJMHqsv/u8vvcgXmV6Cqq8tRDa
         MHdCbm9U1qbzrGZJhJL3k1zKbbjt/SwoVE91G4peiMCu0bQzrQN0/lzOu7g9leTDUEi5
         a8X/Y3TwSYRE6y1WsHvze5bFHmLgPq5tgSumBnDRe5iSEWaLyjPjhwWld48S/Ddp5iwG
         pBgnAxqhCyeoZB9+R8q2++w0gN2CP8I0ulVZNlJvcoecnG0LoGlV80vFU2P4v9Ped6+4
         ash1+yOFmYD0afs62CoH6VLeKAXPSpbH9+pK54Vyi/SNC08nB+xGwthDnf0hqgNIQMee
         BJCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cAgrlXd2l1LJdhAbUiQiEGzy9+X15djTsbIgtd+mY2I=;
        b=bC2fuvWnRLFkbDDsPlf3kxi1xRInBu/RQWqDeddQCxfaPo8k2QSszNtODJDRXelcxn
         dSKu4quYtM4mEqN68qCMLg3QbCAbOsi8CAbzpAS3kkFuCIIsEJbvBwNHiMXoFDznD2Fa
         3OHGx+3swBq8+HHI4L4yKF1rZj6zIFMUABwb/X7CGgYzBCEbt8MZTlaXoPycJm+YoyYX
         qFp3jcDacnQKx7SsqDSkpWUx0VcUErfsigcCh6L8BR586Hby8rWP/1GmdLbP5WhxlPcB
         59NSwoJ2g8ciY5OjI7FpJkztrL6TSUaZ8UUIGcUsw0X+yx0tGIYdCEIOIqCAD/Qn/+X3
         aaPA==
X-Gm-Message-State: AOAM532keHn6XIwSL5avAR3p1qk85HRBKnC/WB2ue4q4kYY3sczFc0ia
        wNL/lrxqeegAuePAy7Q1WXcWKX0kvMyIqw==
X-Google-Smtp-Source: ABdhPJxtxs+yAdlG3bLdXNsyC/3JEqEfDxibDtPZ2HJjVgqSmtWHsn8Q0+9JVZCgM1P++N0ANZzplg==
X-Received: by 2002:a1c:5416:: with SMTP id i22mr12228165wmb.146.1615542486634;
        Fri, 12 Mar 2021 01:48:06 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:48:06 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Karen Xie <kxie@chelsio.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Dimitris Michailidis <dm@chelsio.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 17/30] scsi: cxgbi: cxgb3i: cxgb3i: Fix misnaming of ddp_setup_conn_digest()
Date:   Fri, 12 Mar 2021 09:47:25 +0000
Message-Id: <20210312094738.2207817-18-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c:1189: warning: expecting prototype for cxgb3i_setup_conn_digest(). Prototype was for ddp_setup_conn_digest() instead

Cc: Karen Xie <kxie@chelsio.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Dimitris Michailidis <dm@chelsio.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 37d99357120fa..203f938fca7e5 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -1177,7 +1177,7 @@ static int ddp_setup_conn_pgidx(struct cxgbi_sock *csk,
 }
 
 /**
- * cxgb3i_setup_conn_digest - setup conn. digest setting
+ * ddp_setup_conn_digest - setup conn. digest setting
  * @csk: cxgb tcp socket
  * @tid: connection id
  * @hcrc: header digest enabled
-- 
2.27.0

