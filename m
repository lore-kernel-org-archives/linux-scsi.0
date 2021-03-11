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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0041C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 04:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9145C64FBF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 04:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhCKECy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 23:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbhCKECX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 23:02:23 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBB4C061574
        for <linux-scsi@vger.kernel.org>; Wed, 10 Mar 2021 20:02:23 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso8681346pjb.4
        for <linux-scsi@vger.kernel.org>; Wed, 10 Mar 2021 20:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2koCQnWaYtyYB2JteVe7/38eVCPZU8+uW5u2/HvKPk4=;
        b=e9w23tmaAcA8ezwVX6GLhjPV/5CPHN6qQO0cGgKmbHQv0lT8jidm41SOe2LKCxzn6B
         PxTEUzH0J2tbf9idz8FJCMtz8/gTGcKG0oGB3l0zAqnrIrDubfNCjeE41eL46EcBjTKI
         un7QZqsG60XFTZF8U4uyUQlcD2OSWMAJP/bBa9lgv8JYea+T+ge6VdhUze0kvX+mJBrm
         VCWA7hQjKTG2vCAWAoQL3VKbBa9KbdbVkYGwzi1fghwwDcIARhxPhBDGRC7rzWrH2DQR
         SxkgU72S9QYKGH0r0iG+lm/F6bk0dHdlz7wX787VlQwZ6q2WJRWeFRLLMnZPKOB+sc5S
         61iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2koCQnWaYtyYB2JteVe7/38eVCPZU8+uW5u2/HvKPk4=;
        b=Ix1qTI5U9eRKj5pVKS++AXiypO4RTQTFXIiE9/IDrCOtL5X+JjLBSsfWyoLffC2LWp
         1UqjzUUlsgHwex8p1gJ1cAuqGYoEFfozTo/3LhGm3AwuvLQt1zJL2tC07noIiMwFl6gf
         Ob+Dj6mdAa0L2oge3HKhT0VUxziICEn+HbpTwT5w4WiqVR4aQsOXDzv/xe1FRutOuGM7
         TO/bRwjjNmU1fD9s+2dh0M7xP71oMvJULua6fJsq8LiODCXXYZPT/YkaoKRZrVblxNja
         OAdyLI1gxwEtEXA79zH0PFNzeVCs6qbpV7y+1PktvF3zzInAKpI7sCNCo7YylBdmWDRt
         mvaA==
X-Gm-Message-State: AOAM5330CWNu3KPgKRBM7HZZzpKAcMg7XnoCllNTyH4GHFOowFH9bTcq
        r35x0PNscBPS4SHRgIM3ahU=
X-Google-Smtp-Source: ABdhPJzH6X6eFMQP0yGMXseuLd/vBeUKoBn/Ue5Nn6EfLyXEdKS9XVcZHV1hmABqXqecziBPACsxuQ==
X-Received: by 2002:a17:90a:f82:: with SMTP id 2mr7094320pjz.196.1615435342644;
        Wed, 10 Mar 2021 20:02:22 -0800 (PST)
Received: from tj.ccdomain.com ([103.220.76.197])
        by smtp.gmail.com with ESMTPSA id u22sm814094pgh.20.2021.03.10.20.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 20:02:22 -0800 (PST)
From:   Yue Hu <zbestahu@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        stanley.chu@mediatek.com, cang@codeaurora.org,
        asutoshd@codeaurora.org, kwmad.kim@samsung.com, beanhuo@micron.com
Cc:     linux-scsi@vger.kernel.org, huyue2@yulong.com, zbestahu@163.com,
        zhangwen@yulong.com
Subject: [PATCH] scsi: ufs: Correct status type in ufshcd_vops_pwr_change_notify()
Date:   Thu, 11 Mar 2021 12:02:10 +0800
Message-Id: <20210311040210.1315-1-zbestahu@gmail.com>
X-Mailer: git-send-email 2.29.2.windows.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yue Hu <huyue2@yulong.com>

The status paramster's type should be enum ufs_notify_change_status.

Signed-off-by: Yue Hu <huyue2@yulong.com>
---
 drivers/scsi/ufs/ufshcd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 18e56c1..b8c9582 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1181,7 +1181,7 @@ static inline int ufshcd_vops_phy_initialization(struct ufs_hba *hba)
 }
 
 static inline int ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
-				  bool status,
+				  enum ufs_notify_change_status status,
 				  struct ufs_pa_layer_attr *dev_max_params,
 				  struct ufs_pa_layer_attr *dev_req_params)
 {
-- 
1.9.1

