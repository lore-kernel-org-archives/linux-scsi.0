Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB739C47088
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 17:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbiLARqo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Dec 2022 12:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbiLARqE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2022 12:46:04 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41089CAB6F
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 09:45:19 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id v3-20020a17090ac90300b00218441ac0f6so4642857pjt.0
        for <linux-scsi@vger.kernel.org>; Thu, 01 Dec 2022 09:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RgfrCdEhXykVwBp3nVTN7WEjo711kZc0QKngTjXB/aU=;
        b=F5Y0Q5UQLyyIR5QPRFA5yUqqUh1IxjxKnxrw7Sg44Xod7IPkxDk8a8CvKdMfIKAu4R
         8JPI6vH4kowAIxeAtJ4bFRkU5Gn9nlW8Cqevp1wF/BckB6B8H2KcLqmorCEE1Zzb0cI6
         UUTeX3qDPg+udsYi3swPmdvFHV50CMC3cd2RYw2iEpPIzM2SkNSVmYc0KSz1sSBsL7ls
         GfdGRgfyV0yZfHpQdtAZ9//P9o1qB++UJXkC1FmvHhTk/QzQxW+3Iam3ZgSr9u4HkJfO
         FBYLzj9kA1r3l2Z43glviXlDKmd845CiempMsq6KKAJbctYVyTLtO5Z9Q1gNeV2BF/AK
         dPDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RgfrCdEhXykVwBp3nVTN7WEjo711kZc0QKngTjXB/aU=;
        b=oG4TqsySeCRDpvsq+CwTpH0jGNqBbCPFGb+SrEg0ssdltXQNEUibWl9rKlnnoKU5Ir
         7hSntF40gFpINIswiW/EaI634sFFFRcoN72n+tht9WAEKeYG34N5+xs5mWopOKKmYEsM
         ZFbzJitScI6N7JyZg5wKISlYZVoReNeTultU6QdpmP/3/u6Zt/7owHtRuDltOLPlVLIY
         zKdchw7BapLhvEih9ZaLHA0Jgit5gVc6vsbgPw4Ur2knuNtw4UOrEWSWqLTNX/BSbVgX
         3EZ+CiTgiiw8S6t43hR/h6E+5GvGVM4pXBm/Hu9hR6n30wV1HJbwA53fG/T4dKO5kfPx
         AIgg==
X-Gm-Message-State: ANoB5pky8FHmYlhxliADHo/UYADwRWawEsX07L98ZW20UogSS0pZJIlt
        8KRUlBNRdMV0CEqjAb8uqKt5
X-Google-Smtp-Source: AA0mqf4RNaazYmkyS7egwN1iTEJDJ3lN1cFKiS5tVRX/fWUVO+9HFwVP5nZEnrW4BdqyH9lc2QPy6A==
X-Received: by 2002:a17:903:2683:b0:186:6f1e:5087 with SMTP id jf3-20020a170903268300b001866f1e5087mr50040574plb.119.1669916718738;
        Thu, 01 Dec 2022 09:45:18 -0800 (PST)
Received: from localhost.localdomain ([220.158.159.39])
        by smtp.gmail.com with ESMTPSA id p4-20020a170902780400b0016d9b101413sm3898743pll.200.2022.12.01.09.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 09:45:17 -0800 (PST)
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
Subject: [PATCH v4 14/23] scsi: ufs: ufs-qcom: Remove un-necessary WARN_ON()
Date:   Thu,  1 Dec 2022 23:13:19 +0530
Message-Id: <20221201174328.870152-15-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221201174328.870152-1-manivannan.sadhasivam@linaro.org>
References: <20221201174328.870152-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the reset assert and deassert callbacks, the supplied "id" is not used
at all and only the hba reset is performed all the time. So there is no
reason to use a WARN_ON on the "id".

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 7cd996ac180b..8bb0f4415f1a 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -895,8 +895,6 @@ ufs_qcom_reset_assert(struct reset_controller_dev *rcdev, unsigned long id)
 {
 	struct ufs_qcom_host *host = rcdev_to_ufs_host(rcdev);
 
-	/* Currently this code only knows about a single reset. */
-	WARN_ON(id);
 	ufs_qcom_assert_reset(host->hba);
 	/* provide 1ms delay to let the reset pulse propagate. */
 	usleep_range(1000, 1100);
@@ -908,8 +906,6 @@ ufs_qcom_reset_deassert(struct reset_controller_dev *rcdev, unsigned long id)
 {
 	struct ufs_qcom_host *host = rcdev_to_ufs_host(rcdev);
 
-	/* Currently this code only knows about a single reset. */
-	WARN_ON(id);
 	ufs_qcom_deassert_reset(host->hba);
 
 	/*
-- 
2.25.1

