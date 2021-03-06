Return-Path: <SRS0=PYL1=IE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3516C433E0
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Mar 2021 11:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC48864FEE
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Mar 2021 11:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhCFLrQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Mar 2021 06:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbhCFLrO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Mar 2021 06:47:14 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DE9C06174A;
        Sat,  6 Mar 2021 03:47:14 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id z5so2731528plg.3;
        Sat, 06 Mar 2021 03:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rajPZQvK+Fslf8NyrtY3YSn7CgCwIT/U4wqXMTZdE3M=;
        b=qqWdmn2zAPaoKvzPbQs/uGWtEUJlJcwn8HxypI5XtJHb7vsn9qflI0Xep/v9WR/EKk
         qdjnvta3gAVRgAYuCscCJvIy1V8PlWC1PjmMSDfY4/usmcoOjHTzBZQg68P3Jj0bz/Ko
         N+PUBZ/J4LjiA91fUn4930xqi4JlMh5d7PqF0KNsJdZKl0HunhHHzuNdG15hFO+THW3V
         5pa0X/ZqhyCse42X2tIyQOC1q140nNgbjelxB3X2C8A52tm3Hxx/0DDoAPZ+v7jaErmO
         AIKY35ruk4cfJqcwfyCmRZkpk3eaEVJQGWXtDaO8aibGt1slOKX5ynJxMP/4yD7OlyR8
         WNlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rajPZQvK+Fslf8NyrtY3YSn7CgCwIT/U4wqXMTZdE3M=;
        b=KPz3jKPcw4VRWBT1yvwTyisjfa7h3/xZGXJOUne8KrBvPWV7eW+x5mgTefSKcYYAV3
         SAc092vibEJWvXJ/mC21AJu+v6c0/CzGo8bODXMlsBx7/kcsYH6vm5U2kD8vYn/DL2cq
         QtW+ky0dBglt5UQsfxdLoC4Gk1Z0oqWd7zycGRuBqswxod+E4+Av805610HTW8uokgiB
         SoCeYs4bDrbtU3nVVGDxcZAP+aRRh8Rb+byM/HGqlSc8czUIeje5M3slcMf7J4HDwBRc
         Dp0RC/dnwSry/WKO5K2sfcSbkb+S48MuJyCrQbra9pBbs3bPULH9mnMefFKiKV6xLKGv
         9c0A==
X-Gm-Message-State: AOAM532Y7C4BhMPxFscDAKIclpcABEbyiQ00l8o+v+55nSnY5CH0q4pY
        9xZUxZeOGFGb87kmdQmwMGBjbFxqgUA=
X-Google-Smtp-Source: ABdhPJyiOvhtapIDzsnz3eB0j9OO+k6Bk8sY+5WIzkLMASRa9I6w39tJ82K2o7nnDIIGhqHGW9b/RA==
X-Received: by 2002:a17:90a:d911:: with SMTP id c17mr3142106pjv.98.1615031233524;
        Sat, 06 Mar 2021 03:47:13 -0800 (PST)
Received: from localhost.localdomain ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id x1sm5073502pje.40.2021.03.06.03.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 03:47:13 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: zhang.yunkai@zte.com.cn
To:     cang@codeaurora.org
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, jaegeuk@kernel.org, asutoshd@codeaurora.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Yunkai <zhang.yunkai@zte.com.cn>
Subject: [PATCH] scsi:ufs: remove duplicate include in ufshcd
Date:   Sat,  6 Mar 2021 03:47:06 -0800
Message-Id: <20210306114706.217873-1-zhang.yunkai@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Zhang Yunkai <zhang.yunkai@zte.com.cn>

'blkdev.h' included in 'ufshcd.c' is duplicated.
It is also included in the 18th line.

Signed-off-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
---
 drivers/scsi/ufs/ufshcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 77161750c9fb..9a564b6fd092 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -24,7 +24,6 @@
 #include "ufs_bsg.h"
 #include "ufshcd-crypto.h"
 #include <asm/unaligned.h>
-#include <linux/blkdev.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ufs.h>
-- 
2.25.1

