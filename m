Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBCA0C433E9
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 07:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87E4064EFC
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 07:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbhCSHKe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 03:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233942AbhCSHKR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2021 03:10:17 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BF2C06174A;
        Fri, 19 Mar 2021 00:10:16 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id u19so3073260pgh.10;
        Fri, 19 Mar 2021 00:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KbV+SfCubtqdOftAIHCxJ7FznXZ3hV2iW/0IfhczYoA=;
        b=mrjTG0bKDnGMn63RsmgXF4kywMFGGGFIHumcirUdgxnJ5JOFo+D826jm9WNXKFhnqM
         xG0BtgoW4Bx95cvXviTpM/ZIXjpZeE1vATXCicVKLgA/Iawr75IzThR9SaI0Euw/Do3g
         J+0JnU7ln4RDtC5keXGmdUn0zUiAtcuk5NfA4bB7RQWgUT8vU+YX1V/HMyOluINZm6QG
         R8OVAcmJo3vUGi4IrwT+4VbXjrF5QXzL2AqjVY6Xd8kf1voGSXx/kXaRBZmKKW8uUAzU
         1jdEsFkBPfwC+aJBTyUXjYgIYM01b3YpTa8jp4c0uRwE8oljyhexzbYTYvXBDqehZky+
         M8oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KbV+SfCubtqdOftAIHCxJ7FznXZ3hV2iW/0IfhczYoA=;
        b=GoHXreD0lM32q2G6xUeFNYOv/Kf9jfY1D5Bz9VzWVWCMmyKcu6bTmWTfbhN0BKsXo6
         y2VmWxRZBiSbKcgLJWR6vIFFsCuAvVaFOaAQ7eXiprT1GB9c/qSFfWMgX6mnV5LT/IrU
         sY2Zcm8g0n7xSnSg8pbZOU7yp28uqOlkYg5LgO25AA561clP0V83Ml5zDSMaCLanrnHb
         KdsEP4EhOW2pBSjnV9wBnfB0nZh+qX7D3NR0uHqOH/FW1zl8p0cyncKotl//xkWlJ9PH
         PmO8qv6GOAiJjh7xZvWjgE21VZDGVhX+wB3WMqAA7QWSElTUsq1/Xn0HaIjXV2hglIBU
         5gXQ==
X-Gm-Message-State: AOAM531l2vSg8MgLpIh07IB2CF7FMfst8ZPhxW7JZ1Xo3/DcslMqr0lB
        M2TZz5AvX9Zkw3S+g0ld3II=
X-Google-Smtp-Source: ABdhPJwHVCJtoTco45xuL06ppxWh7L0uLy90ierQExN5IGzD+Xvktg6+ujwF/s+WuWFyF5AsCNhMNQ==
X-Received: by 2002:a62:35c4:0:b029:202:b2e5:132b with SMTP id c187-20020a6235c40000b0290202b2e5132bmr7849629pfa.64.1616137815789;
        Fri, 19 Mar 2021 00:10:15 -0700 (PDT)
Received: from tj.ccdomain.com ([103.220.76.197])
        by smtp.gmail.com with ESMTPSA id ms21sm4425820pjb.5.2021.03.19.00.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 00:10:15 -0700 (PDT)
From:   Yue Hu <zbestahu@gmail.com>
To:     martin.petersen@oracle.com, avri.altman@wdc.com,
        jejb@linux.ibm.com, alim.akhtar@samsung.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, huyue2@yulong.com, zbestahu@163.com
Subject: [PATCH RESEND] scsi: ufs: Remove unnecessary null checks in ufshcd_find_max_sup_active_icc_level()
Date:   Fri, 19 Mar 2021 15:09:16 +0800
Message-Id: <20210319070916.2254-1-zbestahu@gmail.com>
X-Mailer: git-send-email 2.29.2.windows.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yue Hu <huyue2@yulong.com>

Since vcc/vccq/vccq2 have already been null checked before using.

Signed-off-by: Yue Hu <huyue2@yulong.com>
---
 drivers/scsi/ufs/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7b3267e..f941bc3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7145,19 +7145,19 @@ static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
 		goto out;
 	}
 
-	if (hba->vreg_info.vcc && hba->vreg_info.vcc->max_uA)
+	if (hba->vreg_info.vcc->max_uA)
 		icc_level = ufshcd_get_max_icc_level(
 				hba->vreg_info.vcc->max_uA,
 				POWER_DESC_MAX_ACTV_ICC_LVLS - 1,
 				&desc_buf[PWR_DESC_ACTIVE_LVLS_VCC_0]);
 
-	if (hba->vreg_info.vccq && hba->vreg_info.vccq->max_uA)
+	if (hba->vreg_info.vccq->max_uA)
 		icc_level = ufshcd_get_max_icc_level(
 				hba->vreg_info.vccq->max_uA,
 				icc_level,
 				&desc_buf[PWR_DESC_ACTIVE_LVLS_VCCQ_0]);
 
-	if (hba->vreg_info.vccq2 && hba->vreg_info.vccq2->max_uA)
+	if (hba->vreg_info.vccq2->max_uA)
 		icc_level = ufshcd_get_max_icc_level(
 				hba->vreg_info.vccq2->max_uA,
 				icc_level,
-- 
1.9.1

