Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67227C433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 11:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2334A229C7
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 11:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbhAELfn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 06:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbhAELfl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 06:35:41 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED258C061793;
        Tue,  5 Jan 2021 03:35:00 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id ce23so40766411ejb.8;
        Tue, 05 Jan 2021 03:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=e2p6ovsTZi3RI/1s5tiOcO3cGPDLijFKcdx9hDvuso4=;
        b=mvl8QMjfZO453TDy57JBtq+f9vo+IKpPgpPqfKfxYTGbpqY2AY4tcyQ8jCJYoz0AXh
         kUb7tuu6R4GZ3CQCdzx3j6ENYHcKPP6rWq+NPhGD7B9AEIT4PXXCLoVxlFDugmkXpgnm
         JIqVMuDKssSJeF0nsI0Hp6G3ZCEVAK5b+LOyN1Wr5BwSvREwYbgd/uOoj2vCoraXtW8G
         27TIre7dbgMbJrxWu0BY7MKy8wyHKM/KY4n2W/MFmUFODUubKB2tCN2GToh2dzrqhOIe
         IRe1lm37yFrdPuabLwbfqHdT7hiGSgN2W7NEgF224qmDxanDZDNR7WYDlKN1gfmcD/2m
         7XDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=e2p6ovsTZi3RI/1s5tiOcO3cGPDLijFKcdx9hDvuso4=;
        b=cv0ymkywyTRke4nUswTYGURIWxpVKuWaPSe80McFxMntAL1q0So0uR1Fl8mjQVaxHK
         VUSxm5UhodzJFmrd0Ww/MDt6Q/N6A2jWCmCifeA44rzFMSiS2bTTjQioA5jBN0V39hbH
         C0KUVzlbdrWpZ+N1HHKvslYC2dzeaauj6FYlqRsWW3MVdc8Czt2d8taEyEUVQcjkSPyH
         s1o/G3ElxyA1qAl3qMjhgm0ikY87fkvlUQrRK7AG45sO0iMPzy39nufv3eVTeyxUjy+8
         /SN6d2fnRVnqJZj9YOum8g98K3kHUJb7uB0BJgrsfarJjMhkwOJoFFxVCAi1sheZ7RBu
         zkgA==
X-Gm-Message-State: AOAM530gM7n3fVGknApMfxN3kKEGcxnUD10hsyeWRMFnSdx3WmgxWs0p
        FzIeCO8WnXJVCPiZaccNy08=
X-Google-Smtp-Source: ABdhPJz9xFoQB536zwz3lQaquuMQ5r7hZgL9DC4kgfBxXl1OnmhDcL4OQZFoRjNEKy24ZmmqMgvHgQ==
X-Received: by 2002:a17:906:f9da:: with SMTP id lj26mr68670285ejb.467.1609846499675;
        Tue, 05 Jan 2021 03:34:59 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.gmail.com with ESMTPSA id n17sm24640772ejh.49.2021.01.05.03.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 03:34:59 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/6] scsi: ufs: Remove stringize operator '#' restriction
Date:   Tue,  5 Jan 2021 12:34:41 +0100
Message-Id: <20210105113446.16027-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105113446.16027-1-huobean@gmail.com>
References: <20210105113446.16027-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Current EM macro definition, we use stringize operator '#', which turns
the argument it precedes into a quoted string. Thus requires the symbol
of __print_symbolic() should be the string corresponding to the name of
the enum.

However, we have other cases, the symbol and enum name are not the same,
we can redefine EM/EMe, but there will introduce some redundant codes.
This patch is to remove this restriction, let others reuse the current
EM/EMe definition.

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 include/trace/events/ufs.h | 40 +++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
index 0bd54a184391..fa755394bc0f 100644
--- a/include/trace/events/ufs.h
+++ b/include/trace/events/ufs.h
@@ -20,28 +20,28 @@
 		{ SYNCHRONIZE_CACHE,	"SYNC" },			\
 		{ UNMAP,		"UNMAP" })
 
-#define UFS_LINK_STATES			\
-	EM(UIC_LINK_OFF_STATE)		\
-	EM(UIC_LINK_ACTIVE_STATE)	\
-	EMe(UIC_LINK_HIBERN8_STATE)
-
-#define UFS_PWR_MODES			\
-	EM(UFS_ACTIVE_PWR_MODE)		\
-	EM(UFS_SLEEP_PWR_MODE)		\
-	EM(UFS_POWERDOWN_PWR_MODE)	\
-	EMe(UFS_DEEPSLEEP_PWR_MODE)
-
-#define UFSCHD_CLK_GATING_STATES	\
-	EM(CLKS_OFF)			\
-	EM(CLKS_ON)			\
-	EM(REQ_CLKS_OFF)		\
-	EMe(REQ_CLKS_ON)
+#define UFS_LINK_STATES						\
+	EM(UIC_LINK_OFF_STATE,		"UIC_LINK_OFF_STATE")		\
+	EM(UIC_LINK_ACTIVE_STATE,	"UIC_LINK_ACTIVE_STATE")	\
+	EMe(UIC_LINK_HIBERN8_STATE,	"UIC_LINK_HIBERN8_STATE")
+
+#define UFS_PWR_MODES							\
+	EM(UFS_ACTIVE_PWR_MODE,		"UFS_ACTIVE_PWR_MODE")		\
+	EM(UFS_SLEEP_PWR_MODE,		"UFS_SLEEP_PWR_MODE")		\
+	EM(UFS_POWERDOWN_PWR_MODE,	"UFS_POWERDOWN_PWR_MODE")	\
+	EMe(UFS_DEEPSLEEP_PWR_MODE,	"UFS_DEEPSLEEP_PWR_MODE")
+
+#define UFSCHD_CLK_GATING_STATES				\
+	EM(CLKS_OFF,			"CLKS_OFF")		\
+	EM(CLKS_ON,			"CLKS_ON")		\
+	EM(REQ_CLKS_OFF,		"REQ_CLKS_OFF")		\
+	EMe(REQ_CLKS_ON,		"REQ_CLKS_ON")
 
 /* Enums require being exported to userspace, for user tool parsing */
 #undef EM
 #undef EMe
-#define EM(a)	TRACE_DEFINE_ENUM(a);
-#define EMe(a)	TRACE_DEFINE_ENUM(a);
+#define EM(a, b)	TRACE_DEFINE_ENUM(a);
+#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
 
 UFS_LINK_STATES;
 UFS_PWR_MODES;
@@ -53,8 +53,8 @@ UFSCHD_CLK_GATING_STATES;
  */
 #undef EM
 #undef EMe
-#define EM(a)	{ a, #a },
-#define EMe(a)	{ a, #a }
+#define EM(a, b)	{a, b},
+#define EMe(a, b)	{a, b}
 
 TRACE_EVENT(ufshcd_clk_gating,
 
-- 
2.17.1

