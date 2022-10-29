Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3912EC433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Oct 2022 14:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiJ2OTP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Oct 2022 10:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiJ2OSl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Oct 2022 10:18:41 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99E25FDCF
        for <linux-scsi@vger.kernel.org>; Sat, 29 Oct 2022 07:17:47 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso6834348pjc.2
        for <linux-scsi@vger.kernel.org>; Sat, 29 Oct 2022 07:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V6Cn6AAM+ruCSUx7hOhryryIVpbAjdLGLzoffp2NaNY=;
        b=WT8C9Z4ISqHLbq0ws3aGDgQn4ZnrIZqfE5JVaofV5V8Q/4jxd/1yyHqv+szIEQSkn/
         riTWtO4o/TvPc6R8oZY/v+TEMjhwsi/S+LT97zFoYU9jwW+CJ7MOP9ZvNnz8MfbhHCyL
         piUS20GmVWf83DmJTqvaoYZTSazuQFQMAC5CQkfSe818aWluRP0HEls7yLgLiIRNeLL9
         /Go8f5VbiyicQH0qeVEfZJ+DXXaf5Hkx2G1PrhLJVIFfhxhM4heT3hANhJlELhjj0s1w
         5rp+srjuc3fYOW+HOQkxT22kfud+zAn4bo8AVgkIBLU0D8EixcMx/N6GA83haFqO4MNN
         LIlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V6Cn6AAM+ruCSUx7hOhryryIVpbAjdLGLzoffp2NaNY=;
        b=24ygpcPfXcKChCAKCauTOtkoLLU1hVN5UMwMnH4ea6+O9XW5AGB3dIMXmZCkV3stsO
         3HmaYLr2g+W+e0hDjMrjEqRBk+01LUmVSC1VKUOuwKfFmcF56r2w0kY5qi7A6YzzWO9P
         msCuJLamowN3ARMrdFel/0cdw1FXzkJaBSg3NMoLjbvAy3J7tDxsRQrcq37Zz3I2seS9
         +O+G4aznyrlqU8oU6jCql4PkXTum7lM/TEhob8WtcRk49+Mpe1/ULsAtPPQgt9aHXyUS
         Nz0meYrM89Ul/OAvo0LnESYYUKUfJ4R82wltIGGgRwTxYfpZrUsyKefj5ROLOFG5KGhV
         l6Tw==
X-Gm-Message-State: ACrzQf3C7eoeOUvBQyKMuRAWbZy6lSJzEzj/uakR61RReol46JijOE47
        32y31/ADLlLUU7YOuStm8eop
X-Google-Smtp-Source: AMsMyM6BzVwQ2YhU3TiOk54m9WMzzOVEFEMcHpJCXT2JKGyLHJFwwW9gtknZ00dp5yk2PL8C5QiBJQ==
X-Received: by 2002:a17:90a:5509:b0:213:98ab:da74 with SMTP id b9-20020a17090a550900b0021398abda74mr5056156pji.208.1667053067496;
        Sat, 29 Oct 2022 07:17:47 -0700 (PDT)
Received: from localhost.localdomain ([117.193.208.18])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e5c400b001866049ddb1sm1370157plf.161.2022.10.29.07.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 07:17:46 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     konrad.dybcio@somainline.org, robh+dt@kernel.org,
        quic_cang@quicinc.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 12/15] scsi: ufs: ufs-qcom: Fix the Qcom register name for offset 0xD0
Date:   Sat, 29 Oct 2022 19:46:30 +0530
Message-Id: <20221029141633.295650-13-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221029141633.295650-1-manivannan.sadhasivam@linaro.org>
References: <20221029141633.295650-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the register name used for offset 0xD0. The correct name is
REG_UFS_PARAM0.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 6cb0776456b3..214ea50acab9 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -33,7 +33,7 @@ enum {
 	REG_UFS_TX_SYMBOL_CLK_NS_US         = 0xC4,
 	REG_UFS_LOCAL_PORT_ID_REG           = 0xC8,
 	REG_UFS_PA_ERR_CODE                 = 0xCC,
-	REG_UFS_RETRY_TIMER_REG             = 0xD0,
+	REG_UFS_PARAM0                      = 0xD0,
 	REG_UFS_PA_LINK_STARTUP_TIMER       = 0xD8,
 	REG_UFS_CFG1                        = 0xDC,
 	REG_UFS_CFG2                        = 0xE0,
-- 
2.25.1

