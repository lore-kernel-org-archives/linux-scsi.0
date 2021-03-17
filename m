Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D4E8C432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DE3164F18
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhCQJNk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbhCQJNE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:13:04 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22ACEC061762
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:04 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id b9so999766wrt.8
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=17QMvq2Q/M7Orri85J9dD3hcU2vgqE2nGmmSGPSN8N4=;
        b=xSui72cH7mynYUdWePzFI99ZQeLZVleHwCOGmVd/+zEzOtTrUJRIvq57rNSXdvtkFD
         AuTsw5cXDndwCIwGCovMJCcwWXX7vWOmrbro5MTnHR3M+nBZq4rvHW9wlbyD8ues64tq
         W0YVxGRYhaLiqE6iw/EOX4jN89g3+mzKO757fML5iJh6mfUEdB8Zwanp+oGDRV45hvCo
         JKbNmBqoLpYVWtkzG9OTEaQPPFPFCl1+ynQYr2zX1AEXvEanYpHlyvofdCFdydvXaKF7
         ZJT/RZDz3IgE7F0U1RAzWKtbyut9QwgIQD6RwWTACnPS1DBXMU5I5rJpQGFdhv0b9JFF
         xySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=17QMvq2Q/M7Orri85J9dD3hcU2vgqE2nGmmSGPSN8N4=;
        b=cuAQ3Wc6JU2RLUClu58thXM++KsY8R5/OSd5ulke9c/RWM79PeKTl3FGlxP+y/PTNa
         LVG4mtZCi3ZOa1z6H0tpAAzQRMNOLD/rySoe2xOFFs8DrDkRHQkgU7ZaAPoBLaqpeE3Z
         aF1JwiSsONYfvjt90GZdky3uhhD5QbEnhjsmkWBVso6wqFIICtJm611ndb5pmIOZ3s/t
         p/AvgxsAtJ1iyhgTSji6HWtKmeU+2Xk8scokUVpblO8MivSH4Uv6OMB2KTJ/8gKAcU+u
         B6NtVNSk0MkGK+WeGNq2Re7eZXyZJButleL8khe747Gpk9+O/9XW0HkeYDYcRQur/Ub1
         G2ow==
X-Gm-Message-State: AOAM532SJcBZkh29p4NRj/B0VJgDfZGuxSSjV6q5xR7UuVYYwO10Aa+J
        5bWQhbDcjc7I9NJjSJvJ9fiaJQ==
X-Google-Smtp-Source: ABdhPJwrr2v5Uzj5rO4yccSwWfcn+rSDc0xVCmXuTwKBhIjkhQolLTOZ2lwCsqPaBEIEY3HzZDh6Ig==
X-Received: by 2002:a5d:6c67:: with SMTP id r7mr1164616wrz.373.1615972382873;
        Wed, 17 Mar 2021 02:13:02 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:13:02 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 22/36] scsi: isci: task: Demote non-conformant header and remove superfluous param
Date:   Wed, 17 Mar 2021 09:12:16 +0000
Message-Id: <20210317091230.2912389-23-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/isci/task.c:383: warning: Function parameter or member 'isci_host' not described in 'isci_task_send_lu_reset_sas'
 drivers/scsi/isci/task.c:383: warning: Function parameter or member 'isci_device' not described in 'isci_task_send_lu_reset_sas'
 drivers/scsi/isci/task.c:677: warning: Excess function parameter 'lun' description in 'isci_task_query_task'

Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/isci/task.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 26fa1a4d1e6bf..62062ed6cd9ad 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -369,7 +369,7 @@ static void isci_task_build_abort_task_tmf(struct isci_tmf *tmf,
 	tmf->io_tag = old_request->io_tag;
 }
 
-/**
+/*
  * isci_task_send_lu_reset_sas() - This function is called by of the SAS Domain
  *    Template functions.
  * @lun: This parameter specifies the lun to be reset.
@@ -668,7 +668,6 @@ int isci_task_clear_task_set(
  *    returned, libsas turns this into a LUN reset; when FUNC_FAILED is
  *    returned, libsas will turn this into a target reset
  * @task: This parameter specifies the sas task being queried.
- * @lun: This parameter specifies the lun associated with this request.
  *
  * status, zero indicates success.
  */
-- 
2.27.0

