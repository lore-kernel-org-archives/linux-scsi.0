Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA1B0C43619
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C904764F00
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbhCLJsk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbhCLJsI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:48:08 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCC7C061763
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:47:58 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo14771909wmq.4
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z+kSFSRrtdMVZ+j5+NugdaTX8hYYEw2c6IlgmOo4rIo=;
        b=HOcgEfaVoDJMWGnXaPpzgoYuj5aTw+ZVk9EuklTc1mwNWSzqEN5tkcy6SK22px7l2Z
         IH3b6a3DKeSc6jMUyR8EiLiJSP8A8swQ8qkWg3D1lqe/3lgUEb3SaN54EwL+87/rB6BM
         CO+2p6eJzkxo/NXOoqirxPaMWxKAxx+bH3ejrW26ApFwYq/fK1IykgBIrxqWyTbCpbUt
         g4l96HdnU9mxuZgI9lIrgVc+UfeG7p0fueHRhwfc8R9vhTO7ODFY3Ou5/lpCQCl99M4Q
         XwkTVTUmmfZtTgzZUDSoOE3L/lTFhPPNzZlYGRU2kPjTFoT4ML1VPdCPRod00eYtXtbP
         MZVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z+kSFSRrtdMVZ+j5+NugdaTX8hYYEw2c6IlgmOo4rIo=;
        b=EMIZV1cq71jLhh4JB7PKFUCXy2YXMz7yYdTY4NHfwES09ChaKhrdXu5Qf0Lyckvggh
         S9oz6gFh6IYrBLRulQWzhYeOxqeG7lnyxh6mnlIy+1FRq98qiB5UXQKm50G4p5u42bkM
         XroVFSyY1SlmAgVCH1wzXZnLApvHPdueWiGBC/VF02EGKJAzlHF6xax4ikWJ9zjSGj06
         PgsKf531OGDJWSXdXuBZwJ2D4diqimov6EHrQ2/nCGxI1Ntngtpm3CpukUFnoyAURg33
         Xlg+v5GflgexxHOkst7b9hNoersgUiYeZkoIZSM9w0tJZ2LpJHekhZSPxICoU9FSMw3n
         OwUg==
X-Gm-Message-State: AOAM530NJ4IgtXJfi8jsCLT4YhE3pZK+Sn0Ffxt7TMjQ4t3VcB9DjsDZ
        HOkefXSA6kYWdU4yvxb6F7MFUQ==
X-Google-Smtp-Source: ABdhPJyauKNkVBNzIvCP4ejtdeK/afAqJ050OX03Yub6PLyrcVZ1HV+Ir85+FHBYND0KC3AU7EZsQA==
X-Received: by 2002:a05:600c:4150:: with SMTP id h16mr12248304wmm.120.1615542477173;
        Fri, 12 Mar 2021 01:47:57 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:47:56 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 08/30] scsi: qla2xxx: qla_mr: Fix a couple of misnamed functions
Date:   Fri, 12 Mar 2021 09:47:16 +0000
Message-Id: <20210312094738.2207817-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qla2xxx/qla_mr.c:525: warning: expecting prototype for qlafx00_warm_reset(). Prototype was for qlafx00_soc_cpu_reset() instead
 drivers/scsi/qla2xxx/qla_mr.c:2869: warning: expecting prototype for qlafx00x_mbx_completion(). Prototype was for qlafx00_mbx_completion() instead

Cc: Nilesh Javali <njavali@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qla2xxx/qla_mr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index ca73066853255..d488ae95e149a 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -516,7 +516,7 @@ qlafx00_pci_config(scsi_qla_host_t *vha)
 }
 
 /**
- * qlafx00_warm_reset() - Perform warm reset of iSA(CPUs being reset on SOC).
+ * qlafx00_soc_cpu_reset() - Perform warm reset of iSA(CPUs being reset on SOC).
  * @vha: HA context
  *
  */
@@ -2860,7 +2860,7 @@ qlafx00_async_event(scsi_qla_host_t *vha)
 }
 
 /**
- * qlafx00x_mbx_completion() - Process mailbox command completions.
+ * qlafx00_mbx_completion() - Process mailbox command completions.
  * @vha: SCSI driver HA context
  * @mb0: value to be written into mailbox register 0
  */
-- 
2.27.0

