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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F49C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 07:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6886652AB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 07:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhCIHmC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 02:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhCIHlc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2021 02:41:32 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CB2C06174A;
        Mon,  8 Mar 2021 23:41:32 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id kx1so430951pjb.3;
        Mon, 08 Mar 2021 23:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KbV+SfCubtqdOftAIHCxJ7FznXZ3hV2iW/0IfhczYoA=;
        b=SpvJZ4wWpOT2LTF+tQ9RC3xdilBpPpt+tQIIHiP6cFikUdBPXexK0xgOae6paVqQCS
         +v4gPd3HaURw8AOehSFeJ/RbAzTWtjOC+7CMx2vY3hWIzuGJ44AR7IlfERK/F9m0OS1c
         nn/upJ9RUJT92pj9mcreHgU6FIWlyPo9kh3Oqys6E9jt41wfD1Vw0qjHNkTx9y6362q7
         gFDmZsd1QED4iOvqUP4CfIqLYIoRyUUb4hgdODivMyfGlnH7E4NuOQIeFduA9XwSkYQT
         fcV7ZOLIBOeMkFMcF9wW5b4jSKIhT7lNF3zagbB2qrgeUvUfJB5W2Frh1wUnB6IGfETM
         uyKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KbV+SfCubtqdOftAIHCxJ7FznXZ3hV2iW/0IfhczYoA=;
        b=JSXdEMYEuOryDuGGXYCbCfAsCDiLEH1njlANNgWtiDQDJLVaDT1fPS+J+dOMzCECK6
         pzBUMCNCEO2LLvYGEJLT1xWBhBDhwHfHhveXYCyeLhYvIlJRkn6dOCfekKNn4ix4drvz
         BRbJXjDe+wQqeW/ZZnWofR+4obgPS98wtLzRcxmggKK48wN23Lun7CbTYBpIY3v2GC+h
         eY0xmUFiG/ZbTDX0dK6eLLXYD/ABJfehrFsN/W/Rt/e+b23hX1xnt4qxfV8YF6RJqra7
         HMJcQYqXUmxjF3D/Fd6Arjj75BsuFcLhVRfTz3gEHXpa1pC/HwhByBjdhPAxJ6h0VePZ
         H6Zw==
X-Gm-Message-State: AOAM530xLI0/theTZ3wzmhriGQgfOEXDVpBBlQlsYAYzH5N5n0wG8yxU
        /WB4lqFHLRG2bqXA+NFXTwo=
X-Google-Smtp-Source: ABdhPJyjUEBJRXeOBTcIAM97/xEDZU87MW9Yc6/XIHvppPofqbXlb6fOwafC2s5NTzlMYwjvIzahsA==
X-Received: by 2002:a17:90a:bc06:: with SMTP id w6mr3303034pjr.44.1615275691981;
        Mon, 08 Mar 2021 23:41:31 -0800 (PST)
Received: from tj.ccdomain.com ([103.220.76.197])
        by smtp.gmail.com with ESMTPSA id bb24sm1806966pjb.5.2021.03.08.23.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 23:41:31 -0800 (PST)
From:   Yue Hu <zbestahu@gmail.com>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        stanley.chu@mediatek.com, cang@codeaurora.org, beanhuo@micron.com,
        jaegeuk@kernel.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyue2@yulong.com, zbestahu@163.com
Subject: [PATCH] scsi: ufs: Remove unnecessary null checks in ufshcd_find_max_sup_active_icc_level()
Date:   Tue,  9 Mar 2021 15:40:51 +0800
Message-Id: <20210309074051.506-1-zbestahu@gmail.com>
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

