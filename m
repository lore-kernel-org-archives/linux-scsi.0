Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D8DC4361B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 16:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BEF1225AB
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 16:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439785AbgLNQTG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 11:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2501917AbgLNQQK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 11:16:10 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDEBC0613D6;
        Mon, 14 Dec 2020 08:15:29 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id q16so17704904edv.10;
        Mon, 14 Dec 2020 08:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=B8DG8sj0mVxCy24G0WJAp1ENLV6t+4B+o+Ikvj584D4=;
        b=eN+aMYX5vrpcSavcggl/T03qrpR/2Dc75fFYYBdC07KkMUIMJlVf0O/3Hpg+geqscT
         feqLPv3IbRdrK00+KT2Gx5XsgCJOSxDde+726N2ajSexy2oR2V/LuPNwM4XWbSSICEMX
         cudrSFIaH1K8wF5YKLMr7IvHrR1QHk0E6Cpn1HniBJ/+di3LPzqCf81zwvgMi07iNe4I
         zcToSVF5KSRjNPlSVSWqAngnIztqOTBVLQEqTLdW2gMWnhUxUZkw6bespgXBRA/0jgu4
         Hl2sOoMzEBpQgklu7zaClQ6KygAzkzGFnkVlCwagFH1x9DTWJDa1fMPULgqhy6TDplc3
         /zWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=B8DG8sj0mVxCy24G0WJAp1ENLV6t+4B+o+Ikvj584D4=;
        b=qk3G/Mfd3AvcH3aJ2GtyI3kfgB1thA4TG+dIuV8m+YQQCbJ/GGcXptEbDutj3/PczV
         z8WceFtNLMobkLGUU71WKDVty0WRgMqjeTqDuTLcCn4SC25t0IRaJ8MHxs17q7CPRy7f
         eEG0Ah0ENQnBw1uo16duTehBQWrkxKJR0tg+e+d3/LAeqIaXRlA7w4TKOvdLr6j8KC4T
         ciueA7defore/pQfC9oHct19wUe7dR9UgeH/HaxR9imw8MdjLAXxu/e4ziTsA6UQANGJ
         AowsTULDY1wizuvTHjI1PlqfOQ0Zai4OO5kVyZGcL4U3S7ugJEKvR+Z1zEuYj2gmthT+
         jREQ==
X-Gm-Message-State: AOAM532LwzNMqgww3UEbN+bVGBL9ekqPQLt5Q8t+zRDBqzr4cfcGI/ga
        P8kcIOZgzi9LWdC6R5xUvHM=
X-Google-Smtp-Source: ABdhPJwI2Nh0aTj44+o3MpcwT+ML9whPThKeiovA3PkVgeqn0ERPECNwp/xF9FDa8yut/5Au4rPMYg==
X-Received: by 2002:a05:6402:1a30:: with SMTP id be16mr26006248edb.124.1607962528678;
        Mon, 14 Dec 2020 08:15:28 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id i13sm6646056edu.22.2020.12.14.08.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 08:15:28 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] scsi: ufs: Remove stringize operator '#' restriction
Date:   Mon, 14 Dec 2020 17:14:57 +0100
Message-Id: <20201214161502.13440-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214161502.13440-1-huobean@gmail.com>
References: <20201214161502.13440-1-huobean@gmail.com>
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

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 include/trace/events/ufs.h | 40 +++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
index 0bd54a184391..84e16868bb39 100644
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
+	EM(UIC_LINK_OFF_STATE, "UIC_LINK_OFF_STATE")		\
+	EM(UIC_LINK_ACTIVE_STATE, "UIC_LINK_ACTIVE_STATE,")	\
+	EMe(UIC_LINK_HIBERN8_STATE, "UIC_LINK_HIBERN8_STATE")
+
+#define UFS_PWR_MODES						\
+	EM(UFS_ACTIVE_PWR_MODE, "UFS_ACTIVE_PWR_MODE")		\
+	EM(UFS_SLEEP_PWR_MODE, "UFS_SLEEP_PWR_MODE")		\
+	EM(UFS_POWERDOWN_PWR_MODE, "UFS_POWERDOWN_PWR_MODE")	\
+	EMe(UFS_DEEPSLEEP_PWR_MODE, "UFS_DEEPSLEEP_PWR_MODE")
+
+#define UFSCHD_CLK_GATING_STATES				\
+	EM(CLKS_OFF, "CLKS_OFF")				\
+	EM(CLKS_ON, "CLKS_ON")					\
+	EM(REQ_CLKS_OFF, "REQ_CLKS_OFF")			\
+	EMe(REQ_CLKS_ON, "REQ_CLKS_ON")
 
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

