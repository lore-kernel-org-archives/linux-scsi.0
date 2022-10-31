Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E0DBFA3741
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Oct 2022 18:04:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiJaSEq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Oct 2022 14:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiJaSEG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2022 14:04:06 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B461F5A0
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 11:04:05 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 130so11345965pfu.8
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 11:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YE5rC5/HZ6deD3gc3XT/0TjMi23c/Z+tQRwUel8pEh4=;
        b=ngJIar4cRFhRJ87WFHp+luxDgZu2MaxOeVJXEy03uFeynHfCGlgzi4+nVEms9Rrk/Q
         ROcU3ieIa5E29iAolL6Yz77bfEMHKLh2mFIhoEnOubAUebbX3Dzmrq3EfuEWPqxXcGAn
         +rBiHDSlorwin1D7vz7k0tIR9TXt2rDcpAzH0KgK7R9bo7hJdfwl2kDscvhpG21gRei3
         12EO1W5NsPVUZGAi3n6ARvNOrJOdZDWH0wgCmOWRsDnRciNmsfVWUCRg64m1ovtl4KFd
         WqilTAX+Qx8nkQbWp1fEc6ofx7HjegeZT9bzcabe1M2IwGmiYj98lf7yZUYxJEjmd7aJ
         EkdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YE5rC5/HZ6deD3gc3XT/0TjMi23c/Z+tQRwUel8pEh4=;
        b=W3iU+OA8mMr/hROtyNc5njPO32zOU5kud+vGGmp8OGenNvwOxgCMp9tC2jAUvxnD/t
         6zDT9C42iwbkS1bj1sNiwmMRUOZCyeA6FBXVAiLqmvka75xbRClLhfGPxCcuAzWQabGY
         8gl5cFFJH5I2/JlE0iA3drGn2m3Pq1Fcag9FPDaSxbnLoHuBEoai4VnyDgOugz0X8IpC
         2qnGml0E/EsK/cgcQVwvWPLKAOWFONZAnktuLPY9mOkshnoiILBl8EgtqT6RJhyGdsc3
         cavBmzbnH0pVhQSVhAM+EkYdCXWVE/sklJ6V9CNuZl0LyOlVcUsrDg35EWfeGAOO+QAX
         HuDw==
X-Gm-Message-State: ACrzQf1QBfV5389se6T843rih/3cC5NQcEcLfTiIFPd6VQif3WseGaKp
        NiLu1jtjtoCJ6nJppj9ZKyoO
X-Google-Smtp-Source: AMsMyM6yyBG+NNnymIFV2d9Fi+RqjhDyAZ0khdcfg9ZdsJeRcnR/xBL9MobSoFweIhYMbnTUnxEfBA==
X-Received: by 2002:a65:68cb:0:b0:460:b552:fbf4 with SMTP id k11-20020a6568cb000000b00460b552fbf4mr13750019pgt.457.1667239445056;
        Mon, 31 Oct 2022 11:04:05 -0700 (PDT)
Received: from localhost.localdomain ([117.193.209.221])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b00186c6d2e7e3sm4742224plb.26.2022.10.31.11.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 11:04:03 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     konrad.dybcio@somainline.org, robh+dt@kernel.org,
        quic_cang@quicinc.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        dmitry.baryshkov@linaro.org, ahalaney@redhat.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v2 12/15] scsi: ufs: ufs-qcom: Fix the Qcom register name for offset 0xD0
Date:   Mon, 31 Oct 2022 23:32:14 +0530
Message-Id: <20221031180217.32512-13-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221031180217.32512-1-manivannan.sadhasivam@linaro.org>
References: <20221031180217.32512-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On newer UFS revisions, the register at offset 0xD0 is called,
REG_UFS_PARAM0. Since the existing register, RETRY_TIMER_REG is not used
anywhere, it is safe to use the new name.

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

