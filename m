Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3303C47088
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 17:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbiLARrL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Dec 2022 12:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiLARqk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2022 12:46:40 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8501B8453
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 09:45:31 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id w129so2559992pfb.5
        for <linux-scsi@vger.kernel.org>; Thu, 01 Dec 2022 09:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ff060FMlh2MHBX3ga6yMFYN0UyVEYS40VqwmLXF4PCQ=;
        b=ChLzP/jCsMP/7siDVnOirGouhwX7bHn8Xmjbes6aYzsley+JEB5YH+txK3cEAocgCO
         tWMUW7/XxtsTbxniN7+xNm4fhW98Cp3Olci2b+gVhIVPetAPa4iGquaU18A1UeLIk/rk
         qw1YFOlOUvEIdMFX4jfhaqeRikGbEsguk7uaxFycoJg9dhWF6dvyKdbANzsBlipDvWV3
         KXH/GfEG+DFeDnnu/dfw+sCyiMnsXdy/ujc3gNVWZ+hjo5+K/qEUA4Gi1s/WdJ/8fXxP
         YTJxbSJ8FbKZitaBUZXVjIvZZ65rWiinyCnJ/OeMStjTwWLNW+cQk2iQdE/foG8GJnZ8
         DomQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ff060FMlh2MHBX3ga6yMFYN0UyVEYS40VqwmLXF4PCQ=;
        b=oRh3mGnYayEYFTqZyM7JzmdTigmCQymkfJC/qilm6G5TypBWuTmtAaq3lsCWTdvujq
         zlELY+ldJNnevBSjV9OY/XwWnTxOaP3/C05sofSMN7r3rxWnnHe/PPWsOKY3kElTl4kj
         0buGNN/dmgmRMLM3Gm/GHFL2ZcZCtMfANSy/+FhLWu12EuNAJA4lZUCT8Q+iSpkfVQ+P
         ahuIax5UNxwbKN8vrLlujS5twEo6MiZiGSukwKb1xdH+FImTKoTWS86yeaj6ycNRKScA
         poKtWXjqQw0Uklwey1Px/AMuwIpjIrkcBMlczoR24Fu2ROSS1npFLSom1JUqGB7RHVrV
         OQ3Q==
X-Gm-Message-State: ANoB5pkaXMa+IvhFZwszITcIOTw+vgsSo5WImNeUXV3RsIJS8KPyp9RV
        MRxS2VSzgQ3I5YekgPdxR0Az
X-Google-Smtp-Source: AA0mqf4Cuxf3UyHQpczq+r1vzyH2b1ABJK/TrKQIBMWfdC192LUpUe035VBHnShh7DVbLhUTF/ngLw==
X-Received: by 2002:a62:f94c:0:b0:56e:174e:efdf with SMTP id g12-20020a62f94c000000b0056e174eefdfmr68316959pfm.29.1669916731346;
        Thu, 01 Dec 2022 09:45:31 -0800 (PST)
Received: from localhost.localdomain ([220.158.159.39])
        by smtp.gmail.com with ESMTPSA id p4-20020a170902780400b0016d9b101413sm3898743pll.200.2022.12.01.09.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 09:45:30 -0800 (PST)
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
Subject: [PATCH v4 16/23] scsi: ufs: ufs-qcom: Use dev_err_probe() for printing probe error
Date:   Thu,  1 Dec 2022 23:13:21 +0530
Message-Id: <20221201174328.870152-17-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221201174328.870152-1-manivannan.sadhasivam@linaro.org>
References: <20221201174328.870152-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make use of dev_err_probe() for printing the probe error.

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8bb0f4415f1a..38e2ed749d75 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1441,9 +1441,9 @@ static int ufs_qcom_probe(struct platform_device *pdev)
 	/* Perform generic probe */
 	err = ufshcd_pltfrm_init(pdev, &ufs_hba_qcom_vops);
 	if (err)
-		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
+		return dev_err_probe(dev, err, "ufshcd_pltfrm_init() failed\n");
 
-	return err;
+	return 0;
 }
 
 /**
-- 
2.25.1

