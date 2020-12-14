Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436D9C2BB48
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 20:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 119EB2250F
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 20:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503065AbgLNUVT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 15:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727855AbgLNUVH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 15:21:07 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F784C0613D6;
        Mon, 14 Dec 2020 12:20:27 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id qw4so24334348ejb.12;
        Mon, 14 Dec 2020 12:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=e2p6ovsTZi3RI/1s5tiOcO3cGPDLijFKcdx9hDvuso4=;
        b=jhWGEXIsT7wblDPiUbRKmNvCe3+UbZDYw9Cb+ohgdlYrv+8fdsF80eF7JhLeVl3274
         5r8mD1JVvM0ar8eDyXs58QDvYXVCQJNfMYyQT0q2k7256GBw9IolXB9D6NDEIyizE6tX
         i3EqNOLyUMO2j63q+o3xGD3/DFVAyee+qyUyqvHt10RiNin+ZHZiUWTRZLrVo7NTUUa+
         UfEJ3dGTs92SQ7xM9j/YEV7Ja0IgFqcwNsQy87aYHK2M8WRFnaYSladHDHOVUfp0jG71
         8VecjINNPfcMP9RmXVfpPIuYwZmbp7i9NZLpIiyKvKEgWnHNgOnwqmypsQjcWXXH8y0v
         EW/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=e2p6ovsTZi3RI/1s5tiOcO3cGPDLijFKcdx9hDvuso4=;
        b=hvYk+0l0zunOuLqvYu7I+9k0U+fRoXetLQDNPAqSyBTyqrlxStMRh5p+bX+8jdzx3R
         VDbGS3rS0DYCBD26bE83QBvFfyEMjfhWFQhezASI7crPKog1wdGaOGs3c59/7ucIatdO
         +KgunUl8EQEi1gOAnCbQXuYKwZPKPR3nTffLXvoPQrw0zCuchAh/lHjDCmyQAGJ0uOGS
         DUFAUkp688zP263QOLy9pZvyP6hD4SPOprOgspMYmIMLmBFZy7pBikopm52ZTL9QyGRP
         6Vkjlt+IeN9vJdOkM8wVWqluxEuzNCNVRkUxfDaBlGm4E2lyqusBWE+4Jrl+e1yE/qh0
         9jtg==
X-Gm-Message-State: AOAM533FDC8hFakFPfaEZ+15YRnrCK5uNV9JbET3wgNYQh+s0qT7d2DK
        50sbAlH5vtiydUdM3N7M/SE=
X-Google-Smtp-Source: ABdhPJyUN46LzuPeZ3au8ZcYHb4l6lEitKROqN88NkJ4nLISi9FFJdEtrtK9Oui0eAKRh9Dt5voCyg==
X-Received: by 2002:a17:906:4705:: with SMTP id y5mr23882838ejq.112.1607977225892;
        Mon, 14 Dec 2020 12:20:25 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id r7sm9334634edh.86.2020.12.14.12.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:20:25 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org, joe@perches.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/6] scsi: ufs: Remove stringize operator '#' restriction
Date:   Mon, 14 Dec 2020 21:20:09 +0100
Message-Id: <20201214202014.13835-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214202014.13835-1-huobean@gmail.com>
References: <20201214202014.13835-1-huobean@gmail.com>
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

