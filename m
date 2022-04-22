Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE48C43219
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Apr 2022 13:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447923AbiDVNZK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Apr 2022 09:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447917AbiDVNZH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2022 09:25:07 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55484580CC
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 06:22:14 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id g9so7315090pgc.10
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 06:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0aTsYn+fbrLEF70DYT+XvQa13+urwQkivcKboFHg6Ao=;
        b=BOWeG3zHuKTf7IsyuvqRU3jzy2o2wts7viRFugf1Pq0w96/Km8O4Z+eJ2+lyhol87H
         +nf+ptgdCfyRAaqddYGbtV4kEO+ytbIsmQeEGqiHBne7/jNBDm67O5iYSFNFrjm7RAsw
         N6C3S2vmvGkMTEPHkduQOV+yLdG5nxhYV2QHDGaU3OH8ebpGH77AEutetm5R9RavxTKU
         KEU8uLmduxy72vCwY749LFujpiNd7YHncSrAEYOJdveIC8sDklLoyn5svJGrUBY0AVce
         pwjP1COoZcqz8dArUevYhB2ccY6+/LThiedXZ1zt/hMTaVEMaAGlX0OsBc2l9td7HRxX
         VBDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0aTsYn+fbrLEF70DYT+XvQa13+urwQkivcKboFHg6Ao=;
        b=obwtvtBjAYNHgTAl4zX57Hs6almp0l3T3QI3cCmTeTFRSdyss3f9Zt5YAyJ7L5/EXR
         BLuJhbtNdrtugsXeS4PtunVlzgP4lVVLTv93M+VLX2c2NtroSMEeGxgLJv1A1QQmrVJK
         nCwtUCZTpZN3GXSGwUC/cdRUi7VwJO2TiZHH5YPGf5Dc3plECLAq2NaieZHaKLikhci6
         MM6Wt7ORaARm+fX5aBHitwdpBLyZXBdXmRm9WCvPWeUqL/HYfQ/kCldrTcPtAMnNHbx3
         Na9/tmsOa/2TgP0jjqpxvXLAAeOmlD2MFCe0DfKz4+S3YOp/A4eF3y/oKVhlKNmFNk2u
         FAEg==
X-Gm-Message-State: AOAM532bi0kw27fOjFtHNmQa2tc64iUz5Q7wr4wkNxjczUrvcgTAVCxQ
        k6jV46lrZG9zuCC5ooMvDnTL
X-Google-Smtp-Source: ABdhPJzvnw8o1O07FvEJgfNvXBizaKMHbMO8qkm1OWHXlD40i9elG+wZHzzrDZiNB5lhOGu8ebUopg==
X-Received: by 2002:a63:d855:0:b0:39c:e714:c79f with SMTP id k21-20020a63d855000000b0039ce714c79fmr3830235pgj.570.1650633733833;
        Fri, 22 Apr 2022 06:22:13 -0700 (PDT)
Received: from localhost.localdomain ([117.207.28.196])
        by smtp.gmail.com with ESMTPSA id g13-20020a62520d000000b0050a923a7754sm2586840pfb.119.2022.04.22.06.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 06:22:13 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     avri.altman@wdc.com, alim.akhtar@samsung.com,
        bjorn.andersson@linaro.org, linux-arm-msm@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 3/5] scsi: ufs: qcom: Add a readl() to make sure ref_clk gets enabled
Date:   Fri, 22 Apr 2022 18:51:38 +0530
Message-Id: <20220422132140.313390-4-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422132140.313390-1-manivannan.sadhasivam@linaro.org>
References: <20220422132140.313390-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In ufs_qcom_dev_ref_clk_ctrl(), it was noted that the ref_clk needs to be
stable for atleast 1us. Eventhough there is wmb() to make sure the write
gets "completed", there is no guarantee that the write actually reached
the UFS device. There is a good chance that the write could be stored in
a Write Buffer (WB). In that case, eventhough the CPU waits for 1us, the
ref_clk might not be stable for that period.

So lets do a readl() to make sure that the previous write has reached the
UFS device before udelay().

Cc: stable@vger.kernel.org
Fixes: f06fcc7155dc ("scsi: ufs-qcom: add QUniPro hardware support and power optimizations")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 5f0a8f646eb5..5b9986c63eed 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -690,6 +690,12 @@ static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool enable)
 		/* ensure that ref_clk is enabled/disabled before we return */
 		wmb();
 
+		/*
+		 * Make sure the write to ref_clk reaches the destination and
+		 * not stored in a Write Buffer (WB).
+		 */
+		readl(host->dev_ref_clk_ctrl_mmio);
+
 		/*
 		 * If we call hibern8 exit after this, we need to make sure that
 		 * device ref_clk is stable for at least 1us before the hibern8
-- 
2.25.1

