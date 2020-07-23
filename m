Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B27B4C4345A
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E261206D7
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ASk1pLpm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgGWMZQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728959AbgGWMZN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:13 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D00C0619E7
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:11 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f18so5010114wml.3
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vvVihUnRFqMdxGLBXS9BPHUYjIV5Tt/WnThdFe3tGqE=;
        b=ASk1pLpmZPrxFOz/aAoD/Ta392mN6iPzej/2OLBJcHirDz4m4DiqrW5Rz8pnvQCg3b
         4v1g2OLLCe8FpjQJnZbAmPuD2pF1PSDJsZK514iZvhY8Z6kiTMAG/BH9ixrHk6waYQzx
         ggrEIo1zyDBRcLeIGpoY2MvSAUuRDyZmxGPDMWr3jLGah+qTy04BkMCb6LVokUZaZ56L
         My+BJAHs3hylLRjrKDjgrECQ9WsWKYatXeURswCgJiF/6C4uEhK1mX6ODqqF4pv6hNWE
         DrdDaaHD92YqGw+fv5ny+LnMAm5fSxmOYdbY5EDb73V86wYzvhFb6GT8ElCfzuLgCQsW
         /nnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vvVihUnRFqMdxGLBXS9BPHUYjIV5Tt/WnThdFe3tGqE=;
        b=F0YnvI3mDIaUV5gHGc+CcbUICdR3CXHnV4QHrgG5/+NS7NL0Umw5OhVRWH2VfJBz7x
         x7GI2oqOjNV5T9xuUPa5uHkPAObnM2z5q7GSglVqgDWVKR3y0OztTMyCAF2ddCRpXEud
         TEbZKA1tcbpeP9Xq18v0VJCvPy1VgkWgttezDD2IQ9b8lUGrzToA1I1/aqmn6rBbTWhq
         FeoQH9s1QF2B+iBjK7xH0hKJzzfR5I9g6mYMO+qH+rDJ11wuBn7Uq7NKBSa31DduKHiT
         FXj1RZjx/YTDIewxGTcjFgJWkCTd1PgaoL9JPzjEGhIOrMCyoUgnoIjVXNMf5rEYNTnp
         TsAA==
X-Gm-Message-State: AOAM530Y22Vo6F8id5ZaDgKp+pjzzcJF3BXY5TGES0b5kHIxtN/D5Kv+
        YjLXxTAs24PuNfRCAlNWBlp2vw==
X-Google-Smtp-Source: ABdhPJyKG4U0JmHyOzcwDHBhbjxqAF1cbPfZqUXMamtCsYAkdrJV/XwgD9FSh+MCWccrwNnLa0xp2A==
X-Received: by 2002:a1c:a757:: with SMTP id q84mr1700943wme.1.1595507109953;
        Thu, 23 Jul 2020 05:25:09 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:09 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com
Subject: [PATCH 17/40] scsi: qla4xxx: ql4_bsg: Rename function parameter descriptions
Date:   Thu, 23 Jul 2020 13:24:23 +0100
Message-Id: <20200723122446.1329773-18-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qla4xxx/ql4_bsg.c:811: warning: Function parameter or member 'bsg_job' not described in 'qla4xxx_process_vendor_specific'
 drivers/scsi/qla4xxx/ql4_bsg.c:811: warning: Excess function parameter 'job' description in 'qla4xxx_process_vendor_specific'
 drivers/scsi/qla4xxx/ql4_bsg.c:858: warning: Function parameter or member 'bsg_job' not described in 'qla4xxx_bsg_request'
 drivers/scsi/qla4xxx/ql4_bsg.c:858: warning: Excess function parameter 'job' description in 'qla4xxx_bsg_request'

Cc: QLogic-Storage-Upstream@qlogic.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qla4xxx/ql4_bsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_bsg.c b/drivers/scsi/qla4xxx/ql4_bsg.c
index 415ee5eb3fc7e..9231917066d3e 100644
--- a/drivers/scsi/qla4xxx/ql4_bsg.c
+++ b/drivers/scsi/qla4xxx/ql4_bsg.c
@@ -805,7 +805,7 @@ static int qla4xxx_execute_diag_test(struct bsg_job *bsg_job)
 
 /**
  * qla4xxx_process_vendor_specific - handle vendor specific bsg request
- * @job: iscsi_bsg_job to handle
+ * @bsg_job: iscsi_bsg_job to handle
  **/
 int qla4xxx_process_vendor_specific(struct bsg_job *bsg_job)
 {
@@ -852,7 +852,7 @@ int qla4xxx_process_vendor_specific(struct bsg_job *bsg_job)
 
 /**
  * qla4xxx_bsg_request - handle bsg request from ISCSI transport
- * @job: iscsi_bsg_job to handle
+ * @bsg_job: iscsi_bsg_job to handle
  */
 int qla4xxx_bsg_request(struct bsg_job *bsg_job)
 {
-- 
2.25.1

