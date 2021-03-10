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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA11C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 08:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFD7964FF1
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 08:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhCJI2J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 03:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbhCJI2E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 03:28:04 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636E9C06174A;
        Wed, 10 Mar 2021 00:28:04 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so7079231pjb.2;
        Wed, 10 Mar 2021 00:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gXHvFOcpTs5YSNgg90LeTtmLZOSFRC3TkmFfCtcgHFM=;
        b=qLyzb+Nl/WHv4ILfCqMuiicINya6xVDZM3Aztv3RQq8pTPSAAVD6II1S2yApFiyI9W
         Ni2074l0vT583ozI9ObzHYye7vWAGvO/jmE111vDgis8RF/3b1d+G72CW0ktfJFpfjqx
         KMvZnAFQ7q/apq9WU7KCe8s37/5RjDqDCDwHBfMbPW03pytdgXYsemNFeBcS8rsaK49o
         aGPO8xQWLACdlIZ4hbwCj+18qN3YcWABm9k602TgmbxaOFcBXDlhNBVnPhwBrgpYZJRK
         CxcfotkQ2wkmV+f3SIorOfmgVwlMi5bWoMaMELi7p6jalIz7Wipm9C0A8EKbEqMKmruW
         4NfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gXHvFOcpTs5YSNgg90LeTtmLZOSFRC3TkmFfCtcgHFM=;
        b=myS2ahRw8F5vKRg6d3sYx8vhXy/dgFZ7TUm0yrahk3f9R42EQwmrbEsjUQNl0ho9oB
         pAZVRAckfYHY736/zAtxED9+yHHyFaAnC/RXa/K1Cxt0BUv8mTNhJNZ/1NriwuNymgeI
         ugFsPNxAn4AiDClB749//aPz5IQmODhBWC/xbOr0lFFEd5ciiaxvAtbj6amXJwZ5hBom
         4BvRbaU+12VlXWk234CmtbGIgynRmrH1w27AZau88OvgG7dSXMFSvIKGJYQ3X37+D578
         XyHp5N3ShjOjOYQtD32+fqxLgBrUbbK7AcMvYGET57IYQCXwYD2grktOBKGo6h/CLVVC
         KdEA==
X-Gm-Message-State: AOAM530kF0Hv0beWKPWplKX0trL+qDRtMD4rcg1DvoyLQ/A+VnTdd+cB
        p8c8kzcyMegD9bvn2EXqMv4=
X-Google-Smtp-Source: ABdhPJztrwO8n0VoO3qra8G+kOHoiVb9mqvj2ofY6GJJdo20IPhwvB4kG6P/DRnwLnfuZhp/ub3+XA==
X-Received: by 2002:a17:90a:7e8b:: with SMTP id j11mr2447290pjl.11.1615364884031;
        Wed, 10 Mar 2021 00:28:04 -0800 (PST)
Received: from tj.ccdomain.com ([103.220.76.197])
        by smtp.gmail.com with ESMTPSA id b3sm14327748pgd.48.2021.03.10.00.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 00:28:03 -0800 (PST)
From:   Yue Hu <zbestahu@gmail.com>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, beanhuo@micron.com,
        stanley.chu@mediatek.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyue2@yulong.com, zbestahu@163.com, zhangwen@yulong.com
Subject: [PATCH] scsi: ufs: Remove unnecessary ret in ufshcd_populate_vreg()
Date:   Wed, 10 Mar 2021 16:27:41 +0800
Message-Id: <20210310082741.647-1-zbestahu@gmail.com>
X-Mailer: git-send-email 2.29.2.windows.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yue Hu <huyue2@yulong.com>

The local variable _ret_ is always zero, so we can remove it and just
return 0 directly in the end.

Signed-off-by: Yue Hu <huyue2@yulong.com>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 1a69949..fedb7de 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -106,7 +106,6 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 static int ufshcd_populate_vreg(struct device *dev, const char *name,
 		struct ufs_vreg **out_vreg)
 {
-	int ret = 0;
 	char prop_name[MAX_PROP_SIZE];
 	struct ufs_vreg *vreg = NULL;
 	struct device_node *np = dev->of_node;
@@ -135,9 +134,8 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 		vreg->max_uA = 0;
 	}
 out:
-	if (!ret)
-		*out_vreg = vreg;
-	return ret;
+	*out_vreg = vreg;
+	return 0;
 }
 
 /**
-- 
1.9.1

