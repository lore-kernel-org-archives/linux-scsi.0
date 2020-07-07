Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC77C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39BB02073E
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HBvBoIuz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbgGGOBO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 10:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgGGOBN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 10:01:13 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F655C08C5E1
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2020 07:01:13 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f7so42241391wrw.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2020 07:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Otr0IW/lc2aubOhQuGn1p9ls5bh+wk/N6Wv8oEf4Osw=;
        b=HBvBoIuzw1P53PX21z9xl0S2Ei5cCmdfti89y/X22YhzPD8leJdxCyYAe5MqjAAObx
         t1E1P2P9Mt2oi9isgC0/LHnqeHNKZYWtJaO+qhuy07fzjZUTGXrc+CimfVho9ZGf/ZWU
         FDKy8A+01W+GzzbMSh0NL/QIw5GrC1SzMU8Ku91XKRykA1P90kFf0lvjwOf9VATuJ2AA
         9517Y+eDIrAIT5wZd8ZZtjlif5PsJkDCzQ/IYlFfSzlxY79jehb6IrMwyQxTx7/P8qGZ
         eTJ9g4UC2LIojpNdHyExhVDGr4hCe53uRJOxLjIosZU7CLcCCZeB1c2aAfcu+QhcE4go
         aC+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Otr0IW/lc2aubOhQuGn1p9ls5bh+wk/N6Wv8oEf4Osw=;
        b=TPM6kgCBZ3vZCzFcyNoUxr4c9on2tlrN6axoelFDrMHBxvSuD76j6XzBfNzuZp8W+n
         pXeglBd4JmoC3O0Jpu4YGkPrctDZy9vbT3ZtR5zaQn/3H0xUaRmqvG/FhBSxGEqLVGb6
         FX+CLKmxgLPld3myMbYnWVC/4PBsVawo5EWk2OJo/sORc6vHrDjWyZJf0P/YPVWFftRZ
         NJC2YZw5BNWmtW7r3pymi+DLMAVSLUXzjAU3LfOF1kiatCuJv5cgfxZiYRGiGwCvAyw1
         LS16xRsZ9+bmAHlosilYsUClGY9IlRSpVREO2HpSvnjAMggoGnUxNs/V3Ic2XnjzhA8M
         AJ4Q==
X-Gm-Message-State: AOAM5311LFbOW8Vkjuhx7ErEp5GUjrzbX8of+gb3Go0mXZQg3wGHmP3z
        e+w2fcjIOo5BTvsFjpNOaRMJRw==
X-Google-Smtp-Source: ABdhPJyMIkqrJx6U0TAgCC1Ldg2yjfRozO5omk7C8zyrNAPXTCsDDxyptx/G91iGoIUhvFmHoTGxBQ==
X-Received: by 2002:adf:e647:: with SMTP id b7mr57813003wrn.170.1594130471901;
        Tue, 07 Jul 2020 07:01:11 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id z25sm1102823wmk.28.2020.07.07.07.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 07:01:11 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        megaraidlinux.pdl@broadcom.com
Subject: [PATCH 10/10] scsi: megaraid: megaraid_sas: Convert forward-declarations to prototypes
Date:   Tue,  7 Jul 2020 15:00:55 +0100
Message-Id: <20200707140055.2956235-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200707140055.2956235-1-lee.jones@linaro.org>
References: <20200707140055.2956235-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/megaraid/megaraid_sas_base.c:240:5: warning: no previous prototype for ‘megasas_readl’ [-Wmissing-prototypes]
 240 | u32 megasas_readl(struct megasas_instance *instance,
 | ^~~~~~~~~~~~~
 drivers/scsi/megaraid/megaraid_sas_base.c:301:21: warning: no previous prototype for ‘megasas_get_cmd’ [-Wmissing-prototypes]
 301 | struct megasas_cmd *megasas_get_cmd(struct megasas_instance
 | ^~~~~~~~~~~~~~~
 drivers/scsi/megaraid/megaraid_sas_base.c:327:1: warning: no previous prototype for ‘megasas_return_cmd’ [-Wmissing-prototypes]
 327 | megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 | ^~~~~~~~~~~~~~~~~~
 drivers/scsi/megaraid/megaraid_sas_base.c:1088:1: warning: no previous prototype for ‘megasas_issue_polled’ [-Wmissing-prototypes]
 1088 | megasas_issue_polled(struct megasas_instance *instance, struct megasas_cmd *cmd)
 | ^~~~~~~~~~~~~~~~~~~~
 drivers/scsi/megaraid/megaraid_sas_base.c:2149:6: warning: no previous prototype for ‘megaraid_sas_kill_hba’ [-Wmissing-prototypes]
 2149 | void megaraid_sas_kill_hba(struct megasas_instance *instance)
 | ^~~~~~~~~~~~~~~~~~~~~
 drivers/scsi/megaraid/megaraid_sas_base.c:2186:1: warning: no previous prototype for ‘megasas_check_and_restore_queue_depth’ [-Wmissing-prototypes]
 2186 | megasas_check_and_restore_queue_depth(struct megasas_instance *instance)
 | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 drivers/scsi/megaraid/megaraid_sas_base.c:2263:6: warning: no previous prototype for ‘megasas_start_timer’ [-Wmissing-prototypes]
 2263 | void megasas_start_timer(struct megasas_instance *instance)
 | ^~~~~~~~~~~~~~~~~~~
 drivers/scsi/megaraid/megaraid_sas_base.c:2579:5: warning: no previous prototype for ‘megasas_sriov_start_heartbeat’ [-Wmissing-prototypes]
 2579 | int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 drivers/scsi/megaraid/megaraid_sas_base.c:4292:6: warning: no previous prototype for ‘megasas_free_cmds’ [-Wmissing-prototypes]
 4292 | void megasas_free_cmds(struct megasas_instance *instance)
 | ^~~~~~~~~~~~~~~~~
 drivers/scsi/megaraid/megaraid_sas_base.c:4329:5: warning: no previous prototype for ‘megasas_alloc_cmds’ [-Wmissing-prototypes]
 4329 | int megasas_alloc_cmds(struct megasas_instance *instance)
 | ^~~~~~~~~~~~~~~~~~

Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: megaraidlinux.pdl@broadcom.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/megaraid/megaraid_sas.h        | 25 +++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 29 ---------------------
 2 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index af2c7a2a95657..5c8037fca5fc6 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2683,8 +2683,31 @@ void megasas_return_cmd_fusion(struct megasas_instance *instance,
 	struct megasas_cmd_fusion *cmd);
 int megasas_issue_blocked_cmd(struct megasas_instance *instance,
 	struct megasas_cmd *cmd, int timeout);
-void __megasas_return_cmd(struct megasas_instance *instance,
+void megasas_return_cmd(struct megasas_instance *instance,
 	struct megasas_cmd *cmd);
+u32 megasas_readl(struct megasas_instance *instance,
+		  const volatile void __iomem *addr);
+void megasas_free_cmds(struct megasas_instance *instance);
+struct megasas_cmd *megasas_get_cmd(struct megasas_instance *instance);
+void megaraid_sas_kill_hba(struct megasas_instance *instance);
+void megasas_complete_cmd(struct megasas_instance *instance,
+		     struct megasas_cmd *cmd, u8 alt_status);
+int wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
+		  int seconds);
+
+int megasas_alloc_cmds(struct megasas_instance *instance);
+int megasas_clear_intr_fusion(struct megasas_instance *instance);
+int megasas_issue_polled(struct megasas_instance *instance,
+			 struct megasas_cmd *cmd);
+void megasas_check_and_restore_queue_depth(struct megasas_instance *instance);
+
+int megasas_transition_to_ready(struct megasas_instance *instance, int ocr);
+void megaraid_sas_kill_hba(struct megasas_instance *instance);
+
+extern u32 megasas_dbg_lvl;
+int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
+				  int initial);
+void megasas_start_timer(struct megasas_instance *instance);
 
 void megasas_return_mfi_mpt_pthr(struct megasas_instance *instance,
 	struct megasas_cmd *cmd_mfi, struct megasas_cmd_fusion *cmd_fusion);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index a0cf55776361c..fd0f40bc1795d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -48,34 +48,7 @@
 #include "megaraid_sas.h"
 
 
-extern void megasas_free_cmds(struct megasas_instance *instance);
-extern struct megasas_cmd *megasas_get_cmd(struct megasas_instance
-					   *instance);
-extern void
-megasas_complete_cmd(struct megasas_instance *instance,
-		     struct megasas_cmd *cmd, u8 alt_status);
-int
-wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
-	      int seconds);
-
-void
-megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd);
-int megasas_alloc_cmds(struct megasas_instance *instance);
-int
-megasas_clear_intr_fusion(struct megasas_instance *instance);
-int
-megasas_issue_polled(struct megasas_instance *instance,
-		     struct megasas_cmd *cmd);
-void
-megasas_check_and_restore_queue_depth(struct megasas_instance *instance);
-
-int megasas_transition_to_ready(struct megasas_instance *instance, int ocr);
-void megaraid_sas_kill_hba(struct megasas_instance *instance);
 
-extern u32 megasas_dbg_lvl;
-int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
-				  int initial);
-void megasas_start_timer(struct megasas_instance *instance);
 extern struct megasas_mgmt_info megasas_mgmt_info;
 extern unsigned int resetwaittime;
 extern unsigned int dual_qdepth_disable;
@@ -84,8 +57,6 @@ static void megasas_free_reply_fusion(struct megasas_instance *instance);
 static inline
 void megasas_configure_queue_sizes(struct megasas_instance *instance);
 static void megasas_fusion_crash_dump(struct megasas_instance *instance);
-extern u32 megasas_readl(struct megasas_instance *instance,
-			 const volatile void __iomem *addr);
 
 /**
  * megasas_adp_reset_wait_for_ready -	initiate chip reset and wait for
-- 
2.25.1

