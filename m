Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADCE6FA3746
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Oct 2022 18:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiJaSEW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Oct 2022 14:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiJaSEE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2022 14:04:04 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63B210FD3
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 11:03:58 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 78so11335816pgb.13
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 11:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fvt/ooOFeIQi2DBt2IsAxWGkItH8ZOWcpqthZcxorNk=;
        b=MRr8I4HdQhqgTo0yNOhsFOhZV/I9beGFFMFSzQ5/qewYPlKyDMnTu1cb8X2l7NnkBC
         D/vh5oh44rVIq5XLoY3RWT0n8Gi6fqUYZT5lW0Njj1f9XpMLyDdrdPuqwwQ2R+tVXHuH
         rxtTzBVxF+smBqHDdP89u/1etqmRaIfsrmFs52mjVHwSMlzKZxKs2FD05lRsJI5kHaAB
         RNr++j1JU/y9a5A17NMz9hWSquiIaUzWCAlVD5m9he4b57+Qk7pxB4o/e2HXwHEpWxZo
         M8PpwHV9IJ2M9SVifRB3jUkzQNQsmWty46csc0KPf1s7FR2ayyHnP2sF/ewS4uKr1gBG
         wY3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fvt/ooOFeIQi2DBt2IsAxWGkItH8ZOWcpqthZcxorNk=;
        b=VzMl8aCeLwFU7sXmI+UIsZ0iIDBR2p5MuZtpX80ZRHqIGKSQxkeyvp/TLLhCDhFDSg
         b9NAWfCmOveqpRbCgJcVlvMUHG7VeM2ysH6Qb7GXsY0EuLiO+cYdLjw0teU32ROoSh1q
         vWaC/mhMoqQPiM3K4scf4yofUBRGlP4eylXPdFE1BRLq+aD37Wyv8XfQGgNWrKVTR+Df
         GCEQqz4UGLWPsjKmffzvDbwqAa+n3vuWklVDDs8UpI9wYpD4uUKy6FGsAiN+jxiK6SE8
         16U3klLwxkSPzaUgZxNgNCw73028kmI/kZzCm3loktRWp33UNImoxSYocub8W9g4Pyez
         Yf1g==
X-Gm-Message-State: ACrzQf3AB/w3rIWzSHt2yGa34eObLvixhugEvtHyzva6FduG+VgCjkxz
        NHmkOP/8KGW1bg3z7gGn61re
X-Google-Smtp-Source: AMsMyM7U31sdCQlnOqIi2pBNFs391BLTLFCHqOQ/hBImrmMpgUG5LDMLLefA9kc2/40q7k5hU0royQ==
X-Received: by 2002:a63:f153:0:b0:46e:b0e3:547e with SMTP id o19-20020a63f153000000b0046eb0e3547emr14247127pgk.51.1667239438233;
        Mon, 31 Oct 2022 11:03:58 -0700 (PDT)
Received: from localhost.localdomain ([117.193.209.221])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b00186c6d2e7e3sm4742224plb.26.2022.10.31.11.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 11:03:55 -0700 (PDT)
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
Subject: [PATCH v2 11/15] scsi: ufs: ufs-qcom: Use dev_err_probe() for printing probe error
Date:   Mon, 31 Oct 2022 23:32:13 +0530
Message-Id: <20221031180217.32512-12-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221031180217.32512-1-manivannan.sadhasivam@linaro.org>
References: <20221031180217.32512-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make use of dev_err_probe() for printing the probe error.

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

