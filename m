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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB81C3526B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9564D22D07
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgLPAAt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731224AbgLOXGO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 18:06:14 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E51CC06179C;
        Tue, 15 Dec 2020 15:05:34 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id q22so12314705eja.2;
        Tue, 15 Dec 2020 15:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UA9lHOsQsRrkKAcdZ8/uAX/YO+6TM8c289Nn7aSmqEg=;
        b=VOGv5uDHRJKxSSjAac0HWnwkGX0jib/wf6oafOg+aJl30V/K7X9QDWUA1bxRlEA9Va
         qbVSJOgBBHSHTN1eF5lYj86uI5WQvED3wEuXhjGYaVJk8BbiGbsHZnbg4rLy0xaCroeQ
         ZY40B+2sj/XRoYKTNJTO7dY4imH83uaXibnj62Vh+mT4L71s75Lrfl6FIy6tOwEQrK5k
         Xumcsui8Dc0JA4diHUaDLZXDWcBXTkHX6fAj2eT5vQVTcTBa/ouwB1jxnWyrox7FnRmu
         Rubptq1Yao+4Qwj7XFfvgwGGI7+cuHXfagoIkrBMxacKgzN5f6hvDoE70fPtu3KpZ8dJ
         mcmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UA9lHOsQsRrkKAcdZ8/uAX/YO+6TM8c289Nn7aSmqEg=;
        b=B95kH1j6oJaGPGi5yEpD3hUZCJwkzTNkYFvkBAuhAono9l6rDnBngsyK0Aa+VTKdKk
         sH5um5KTW/gGYv7cDMP9v5gIIl5WKVUctPnhU9xnaC7j1hJ2R5K/iluZOf6w35G+BhNP
         krH3eBybD6bYTWWcmKxR0nQI610KioFMOVpXx2ciDlq786T5GNMbED7C9qMm9jV41W5C
         sqXYCO97ZxX3/8cSzNB2yy39xKlZLTiBUc0kQslEEaUzmiU4PDpZdP9ASoB7JOulV4FF
         oemcbT2ks9XEDZ64x34I+vXwaRxq+TWvMBmoFY322E6D+oQimJzLEfGKMAxVfUAuuExn
         Ir4w==
X-Gm-Message-State: AOAM5301XTD8nm5pr6pf+AApRGRWqCVyoT+bqWOGH2DIwJQmiWI99119
        lYlTVywo4ZBdAF7/x2yVfcs=
X-Google-Smtp-Source: ABdhPJyvslV0GKJwsm2/Oggw/x+4kQhfQO4gMgXIoCDvtb0U25TgFt95ts4guUArXt6+Ww7xain7OA==
X-Received: by 2002:a17:906:cd14:: with SMTP id oz20mr26773171ejb.99.1608073532980;
        Tue, 15 Dec 2020 15:05:32 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id e11sm19280455edj.44.2020.12.15.15.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 15:05:32 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/7] docs: ABI: Add wb_on documentation for UFS sysfs
Date:   Wed, 16 Dec 2020 00:05:14 +0100
Message-Id: <20201215230519.15158-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215230519.15158-1-huobean@gmail.com>
References: <20201215230519.15158-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Adds UFS sysfs documentation for new entry wb_on.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index d1a352194d2e..5a70d541b2f2 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1019,3 +1019,11 @@ Contact:	Asutosh Das <asutoshd@codeaurora.org>
 Description:	This entry shows the configured size of WriteBooster buffer.
 		0400h corresponds to 4GB.
 		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/wb_on
+Date:		December 2020
+Contact:	Bean Huo <beanhuo@micron.com>
+Description:	This sets or displays whether UFS WriteBooster is enabled. Echo
+        0 into this file to disable UFS WriteBooster or 1 to enable it. Note,
+        this is only allowed for the platform doesen't support
+        UFSHCD_CAP_CLK_SCALING.
-- 
2.17.1

