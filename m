Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD19C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Dec 2022 14:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbiLVOQI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Dec 2022 09:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235708AbiLVOO6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Dec 2022 09:14:58 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B76730F65
        for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2022 06:12:55 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id jn22so2090606plb.13
        for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2022 06:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8r6KWtBC24mvcKhKbi7oMsl/OBPp4xpGlki0s+jabEY=;
        b=P4YYRDE7eLMbshCu/AHFfq4yO9XLNrx8vkP9s9ulv6mT6xjsgejmF7rZxI3q6MWsSr
         UcJ/yJdcKMahNPOMOwprplmiNGv11pKw3UvQEFcQzE30vtdW0VhOzTrWNV/1uvEvvluk
         OKfjfmw9AXCkybIh1bWJ/Q1J7cd6cPuLRqolxmcXGTN08h/p+BEieKI61QV1pHZ9ZKkR
         BgbFvnOWEgC8craFOZ56y8EqPp3zuw3fmmdf0tkDj+35Ic9zylbaBTXttoxUCBZw8lM7
         bSMJXQuRCBYHyGvemSAbZYbbI/xLN0tzsFHPyKRd1xShBmwCEfCM526PNiNxrlL5msmL
         ukbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8r6KWtBC24mvcKhKbi7oMsl/OBPp4xpGlki0s+jabEY=;
        b=j1DjSvPSWrSAB8/IIhK768o5YTyLEhpgWApiqwCLZfCyvrSjrGVt3hrWsohlParEb8
         /2ZCc3xUkJNY9PyU3r3SHPpxGO5MwzQ/245XCLd+W89D5zhHdi4usQMrlMKOMDRUzujN
         dQWz4YHeL5yHu2gMZymam+g5IApamfhNcApLsJ4OIZ0QShwlMmu4xdYcMzT6yJDnbbJ1
         S5UcoFIPFy+DQSXNsQ7EkPBo9M8XDDA44VmfxmselgwiCX1o566sW/iyjYAKaCcd1oGo
         DWUmWhzVLH2Vnuw2zUPFcHAk1KUMH/gwFame/HTYJqPzXzn6whvSbloICcJq/FzVGNuK
         uEIw==
X-Gm-Message-State: AFqh2kpji3SQAugQTcQ4wlalMobYD7x1px5iZ3h42M3E8mFusweozWYN
        4fzn35WJBSyrNmTGC9Fe9k41
X-Google-Smtp-Source: AMrXdXt39otDg2GPiuR+A8WWlXVq1iDlfUJ6rH6SVRvyktfugDgqkZ6oq6hotpPIIqAIrKuhLnlHxQ==
X-Received: by 2002:a05:6a20:3ca5:b0:af:ae01:54df with SMTP id b37-20020a056a203ca500b000afae0154dfmr9321720pzj.11.1671718374656;
        Thu, 22 Dec 2022 06:12:54 -0800 (PST)
Received: from localhost.localdomain ([117.217.177.177])
        by smtp.gmail.com with ESMTPSA id f8-20020a655908000000b0047829d1b8eesm832031pgu.31.2022.12.22.06.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 06:12:53 -0800 (PST)
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
Subject: [PATCH v5 22/23] scsi: ufs: ufs-qcom: Add support for finding max gear on new platforms
Date:   Thu, 22 Dec 2022 19:40:00 +0530
Message-Id: <20221222141001.54849-23-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221222141001.54849-1-manivannan.sadhasivam@linaro.org>
References: <20221222141001.54849-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Starting from Qcom UFS version 4.0, vendor specific REG_UFS_PARAM0 register
can be used to determine the maximum gear supported by the controller.

Suggested-by: Can Guo <quic_cang@quicinc.com>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Tested-by: Andrew Halaney <ahalaney@redhat.com> # Qdrive3/sa8540p-ride
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 2 ++
 drivers/ufs/host/ufs-qcom.h | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 3efef2f36e69..607fddb7b4c3 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -291,6 +291,8 @@ static u32 ufs_qcom_get_hs_gear(struct ufs_hba *hba)
 		 * Hence downgrade the maximum supported gear to HS-G2.
 		 */
 		return UFS_HS_G2;
+	} else if (host->hw_ver.major >= 0x4) {
+		return UFS_QCOM_MAX_GEAR(ufshcd_readl(hba, REG_UFS_PARAM0));
 	}
 
 	/* Default is HS-G3 */
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 4b00c67e9d7f..dd3abd23ec22 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -94,6 +94,10 @@ enum {
 #define TMRLUT_HW_CGC_EN	BIT(6)
 #define OCSC_HW_CGC_EN		BIT(7)
 
+/* bit definitions for REG_UFS_PARAM0 */
+#define MAX_HS_GEAR_MASK	GENMASK(6, 4)
+#define UFS_QCOM_MAX_GEAR(x)	FIELD_GET(MAX_HS_GEAR_MASK, (x))
+
 /* bit definition for UFS_UFS_TEST_BUS_CTRL_n */
 #define TEST_BUS_SUB_SEL_MASK	GENMASK(4, 0)  /* All XXX_SEL fields are 5 bits wide */
 
-- 
2.25.1

