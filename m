Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C1AEC43445
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 667CE206D7
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="K/pgA01j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbgGWMZX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729000AbgGWMZV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:21 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D918C0619E5
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:21 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id y3so4978011wrl.4
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3pqGsbWZalxf7KD6RyeDaCfLDso/eIrkBstcO2+vgts=;
        b=K/pgA01jiliZZhOHrTKN8/Zxz79yXSGEiM6AmI+DmQHdjzWTJVTI6ok71y2wKeRqwa
         CxjUa/HChksPObKRNeCFic2v5Nby3SkIwvVOUNAtbwnpK0Nn6TjFEWeAFkTW5NYKRYQ4
         9kng0uv0+/p3q4PPKqBneNXfvbmkYugMlhxqfqPM3PUOGwZuRQ6D2CG8mw0QB8cmx7nr
         TywdbyleGx5DHbaEBZJdD2FZ8gbxqxS7BjMuVpWMbvXb2t9OWFiTa17DBiX7jDOJkAUm
         0iN/hQ2M5eT/CPWfy7XK/UX3W03y8Zg9jfMD3O0mA554r5EeeTVETiIXUjOOUSaqbxor
         v6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3pqGsbWZalxf7KD6RyeDaCfLDso/eIrkBstcO2+vgts=;
        b=omVnTGGwjuOYsdVn9i8BPjF4Xz64Ib9aBv+8+Xin0pOWuNnV8fjI2iwX/DL1xjfy24
         hSw6mnyvRdLFFvN7OlXN8MbKYy1HDktDscI3Yu4eSj683FGpUGsHIGO7fkpLZ07IoSSV
         Zt+ZSzZgeyswrymlufV/Ut4bDhNwgKsCZfhCqYxi6hAhtO2Xzx7idn7tyoA1lqicyuey
         +R+b4b3i9DqR3y8t931jV6E737uYGW1gcpmU1TMM5isgkpjPpQKhmtfZ9gHaobfIoSTj
         MoYT9MURjXaJcxq0tKGNuqc8QDm/5xW4CamNgqTpi1Wm/X3i+KHQj9+O2NFHD5dUoGCk
         C2tA==
X-Gm-Message-State: AOAM531Ze/jeZETPMI4uMx1mk+R6g+TnNJLZyu6CKf2+THgQ4nJ3W+59
        Ykpcyjv3N0Cq3Jfio+cCo0NoGg==
X-Google-Smtp-Source: ABdhPJzsoSMrqlqygUNaU5qbgYVAr1Wofya/CH5bMUGwoO5FJdONJmyvmo/qMhP/CfRfi1y2LNMtmg==
X-Received: by 2002:adf:e98c:: with SMTP id h12mr3774551wrm.3.1595507119836;
        Thu, 23 Jul 2020 05:25:19 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:19 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Subject: [PATCH 25/40] scsi: bfa: bfa_ioc_ct: Demote non-compliant kerneldoc headers to standard comments
Date:   Thu, 23 Jul 2020 13:24:31 +0100
Message-Id: <20200723122446.1329773-26-lee.jones@linaro.org>
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

 drivers/scsi/bfa/bfa_ioc_ct.c:504: warning: Function parameter or member 'ioc' not described in 'bfa_ioc_set_ctx_hwif'
 drivers/scsi/bfa/bfa_ioc_ct.c:504: warning: Function parameter or member 'hwif' not described in 'bfa_ioc_set_ctx_hwif'
 drivers/scsi/bfa/bfa_ioc_ct.c:525: warning: Function parameter or member 'ioc' not described in 'bfa_ioc_set_ct_hwif'
 drivers/scsi/bfa/bfa_ioc_ct.c:540: warning: Function parameter or member 'ioc' not described in 'bfa_ioc_set_ct2_hwif'

Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bfa/bfa_ioc_ct.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index 6fd3383ee5381..fb748291676b6 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -496,7 +496,7 @@ bfa_ioc_ct_sync_complete(struct bfa_ioc_s *ioc)
 	return BFA_FALSE;
 }
 
-/**
+/*
  * Called from bfa_ioc_attach() to map asic specific calls.
  */
 static void
@@ -517,7 +517,7 @@ bfa_ioc_set_ctx_hwif(struct bfa_ioc_s *ioc, struct bfa_ioc_hwif_s *hwif)
 	hwif->ioc_get_alt_fwstate = bfa_ioc_ct_get_alt_ioc_fwstate;
 }
 
-/**
+/*
  * Called from bfa_ioc_attach() to map asic specific calls.
  */
 void
@@ -532,7 +532,7 @@ bfa_ioc_set_ct_hwif(struct bfa_ioc_s *ioc)
 	ioc->ioc_hwif = &hwif_ct;
 }
 
-/**
+/*
  * Called from bfa_ioc_attach() to map asic specific calls.
  */
 void
-- 
2.25.1

