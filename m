Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8017AC43217
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 17:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiLARrY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Dec 2022 12:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiLARqv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2022 12:46:51 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEC6B5DAE
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 09:45:38 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id w2so1021925pfq.12
        for <linux-scsi@vger.kernel.org>; Thu, 01 Dec 2022 09:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dxBfeAGPJSh5Y/5FKQg+M0y4cyLZHfyLwZKtosIJVD4=;
        b=cVwgxrvy/wOo/YjbpaKogtDcuRpXMD+mUA4GkYeUOI6ezInGYpeliOJhgIJry0ziLR
         8y9LGTbBtBmeMdV/H8LCPq3vDwErrNqkT9rgREnBoj3DsUMM1DopJr76+l6mMKCBpxJu
         zmMZN4Bah9vgAJWZDusTqfvblRNVK4s8q3kahKW9bwfUHWxxlZm0ixfbpawBuguxhREf
         UfvY4NEIePA5J+Qi8PGi5o6eTWE3eJ3zuKPx6VPJaNQ76kUG2CBWQ5Qe/oD+9AtYmR/s
         FEgVg6l1SkCWtxOLanu3bXfrK0hyRTrvYJqivFlLYP92MKJNPayoF7ims3T9syyvtCTT
         NqDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dxBfeAGPJSh5Y/5FKQg+M0y4cyLZHfyLwZKtosIJVD4=;
        b=Xj2VcXj8xm2mfkCiSHlijTMJGuu9Dnq/EEZEbOxzqEch3P2IRhr90WuBmEU3h33+40
         7ora254ddCS9bpN5ttgIpiMqHYnSn3Cdz+yPZ0Ftmzhyr8OjtXH036Tsxayf1Jrs2P69
         0lwyCbvtS4B4/EK0JT5kQYw1drPrnm4d1Vp9u6S47I3QuzGSvPfAEO1XcZZnmly6ut2O
         vwrnQJUPdWR8pxeGLte05oZoavyonxKQqmzcHZu4+T+QctdgRMiTk/ELy9uVRI9hiKXp
         kiD8t/yyof0chMj92zmCnLQyMY7vNhechFg402evOF/sOwA8+iHOqA9oVwZ1D/KYLV1d
         OM+A==
X-Gm-Message-State: ANoB5pk5qSUDnoyIVo7GRQZuuL70+ujQkhCv8bwoS/Y/h2yD0R3ET7Lu
        nSmqDTVhUpjn6tLnF1wcB4NR
X-Google-Smtp-Source: AA0mqf5Mgc99o/UTJhLXzyZGQaJIysEcv5YHIa6ydHMeEjKzcZ4+/ZNExCZfxzP0xAEDdC+jXRyw0w==
X-Received: by 2002:a05:6a00:f8a:b0:56c:2576:9d2a with SMTP id ct10-20020a056a000f8a00b0056c25769d2amr49815642pfb.60.1669916737965;
        Thu, 01 Dec 2022 09:45:37 -0800 (PST)
Received: from localhost.localdomain ([220.158.159.39])
        by smtp.gmail.com with ESMTPSA id p4-20020a170902780400b0016d9b101413sm3898743pll.200.2022.12.01.09.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 09:45:37 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org
Cc:     quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        dmitry.baryshkov@linaro.org, ahalaney@redhat.com,
        abel.vesa@linaro.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v4 17/23] scsi: ufs: ufs-qcom: Fix the Qcom register name for offset 0xD0
Date:   Thu,  1 Dec 2022 23:13:22 +0530
Message-Id: <20221201174328.870152-18-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221201174328.870152-1-manivannan.sadhasivam@linaro.org>
References: <20221201174328.870152-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On newer UFS revisions, the register at offset 0xD0 is called,
REG_UFS_PARAM0. Since the existing register, RETRY_TIMER_REG is not used
anywhere, it is safe to use the new name.

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 9d96ac71b27f..7fe928b82753 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -33,7 +33,8 @@ enum {
 	REG_UFS_TX_SYMBOL_CLK_NS_US         = 0xC4,
 	REG_UFS_LOCAL_PORT_ID_REG           = 0xC8,
 	REG_UFS_PA_ERR_CODE                 = 0xCC,
-	REG_UFS_RETRY_TIMER_REG             = 0xD0,
+	/* On older UFS revisions, this register is called "RETRY_TIMER_REG" */
+	REG_UFS_PARAM0                      = 0xD0,
 	REG_UFS_PA_LINK_STARTUP_TIMER       = 0xD8,
 	REG_UFS_CFG1                        = 0xDC,
 	REG_UFS_CFG2                        = 0xE0,
-- 
2.25.1

