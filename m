Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1C0C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59BDE20739
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V7YTg/Nu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgGHMDD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729186AbgGHMDC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:03:02 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE32BC08C5DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:03:01 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id b6so48661608wrs.11
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EfL+TnTwzrxBs3OWsbVJ1u2HNp81yr5D58y8jJwfHCg=;
        b=V7YTg/NuT1ipSiphL7EvNRuTDaXv8eq0KaXXKKSKjl/mC+jCiU36KNbNpr6xipISRd
         qWZWOid3XF/HdL7CtyOkvOVNsRM4xkEX+fjQAovODTP/W0CIuJkkHlFIFykYxRI9Qvo2
         qE8RJ0nwah9EwAlJFf+GPBkJRk63xtzmgOt4P6iT0iahUYwp1gIlsl3MCWmaGO79N5bN
         y1DSQnGFHBZLQ2sIPBPi+E2ieP2vvs1eA/maPioucGFRuBDhYQtQrlppYxc8xu68qIFj
         L6IHtoeUfefWuAax+TghGhwH9LCZf0l5eps2R/cZBZljKcjvX9KvozXCeIy4iILmYgId
         Awwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EfL+TnTwzrxBs3OWsbVJ1u2HNp81yr5D58y8jJwfHCg=;
        b=ttdWFeYFyowELllEhCsPZPhIc59onOzglgcrRsmt2mfV2UTdsXCmJO/N5GKUT2RNcG
         odaNWsjId2YaGkiloN511ZfIJpPeCzV5iacgx/cezH7ej0Iaf5TJ6a8BBcPt9ENFbcjm
         dzrxgRcQYuTx/WI+Th9BXVq1EozetwUJSRj2QNn+hsulfG88ROQYJUw1ydaZSmDwPg3h
         QX5xXGH4KS62pCUvRrLqZXNVbUjgoNbn9DKUftZwwoGywFyvStSFy3fbDzwo3SNl9tj2
         udhIHSrrORjF/J7a0Q0EFQ8UOf3L77XqR5ciE5tj6LTVhImyOcC5wHlJ5z7XYg4HuGN5
         rdDA==
X-Gm-Message-State: AOAM5339/Ew6yc/W322ama1sLbCdR2ZC1lHIGHBFZrHDg2aTJzt3zJdn
        phywiXUyzAKaOuEtf5PkOO9Jdg==
X-Google-Smtp-Source: ABdhPJwDfd21b5LkVyddx+3HtwmIG7Pf/brq+tML6qftxXPRLFkk5Zh6X+F0E5Q2tUlt/E8YIAo/KQ==
X-Received: by 2002:a5d:5549:: with SMTP id g9mr61834625wrw.419.1594209780204;
        Wed, 08 Jul 2020 05:03:00 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:02:59 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Subject: [PATCH 24/30] scsi: aacraid: linit: Provide suggested curly braces around empty body of if()
Date:   Wed,  8 Jul 2020 13:02:15 +0100
Message-Id: <20200708120221.3386672-25-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aacraid/linit.c: In function ‘aac_biosparm’:
 drivers/scsi/aacraid/linit.c:368:41: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
 368 | param->heads, param->sectors, num));
 | ^

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aacraid/linit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index a308e86a97f19..734dd6e67246d 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -363,9 +363,10 @@ static int aac_biosparm(struct scsi_device *sdev, struct block_device *bdev,
 
 		param->cylinders = cap_to_cyls(capacity, param->heads * param->sectors);
 		if (num < 4 && end_sec == param->sectors) {
-			if (param->cylinders != saved_cylinders)
+			if (param->cylinders != saved_cylinders) {
 				dprintk((KERN_DEBUG "Adopting geometry: heads=%d, sectors=%d from partition table %d.\n",
 					param->heads, param->sectors, num));
+			}
 		} else if (end_head > 0 || end_sec > 0) {
 			dprintk((KERN_DEBUG "Strange geometry: heads=%d, sectors=%d in partition table %d.\n",
 				end_head + 1, end_sec, num));
-- 
2.25.1

