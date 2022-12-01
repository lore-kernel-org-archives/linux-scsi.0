Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E8A4C47088
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 17:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiLARs6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Dec 2022 12:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiLARsI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2022 12:48:08 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2545BD417
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 09:46:10 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id o12so2516499pjo.4
        for <linux-scsi@vger.kernel.org>; Thu, 01 Dec 2022 09:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6j6MDpCLb+McpecemKMLJBiFRu5JxDaZjTLdO5ExkiE=;
        b=qm1An1wnNA4JoFkmc8RLxXAUN5b1VJMqvUQeJKWDZO8VpPHJJytH/a0wukFgCOEsQR
         PvGKlwQN3Pb2fuYtDoCTV5/tIrJy8CRXv6LJCganss6jIk07kEbQAJ8d7u5mEwU0skZ/
         FJcYOO/573sfawqfjpoM3U2FdRTle6JLR41EA/ous0A/ZUB5pZeqWumjGpPRQpWAbKFY
         VsMFWP/tJF23y85ZNZSPrmt2VHgyHmj38L6j2wN5MEBC7GBGnugxzq6yXUW0ncuTybE0
         BBq71sWiayRPPaKTcEuZpZSiHF4xm4IKTVcSO5oTbYBy7l9R13Rq2KSseUJNbeZLo+yR
         Mrfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6j6MDpCLb+McpecemKMLJBiFRu5JxDaZjTLdO5ExkiE=;
        b=NztM2l5cSvTM0pcV1V4n65cHsMB05kaKqrzcWGyFW3Mp1YiDcpClwytY+gmwru9KTd
         s1znD7vD/9LqPtzIi2h1DgsSuCaD7wkDTzFDPu6wuOCbSYw+mnwBaUmbpdrKLzsgBRF/
         +7aaJqiHERJsamUD+QZKqVrk/ry04Yk9eVhTWUreK0tvSRzJ4M1bNTqNheIUrJq2VAj3
         eShJUagf7DhvYpYDkoVlDrmvIebz2g6Ongi8q+oeOtVZK6PBsG1mzQBnaU6RfgygGnBN
         h4758Sq9TPiK6JwD9a53hH05Z1QnDa+RONe/rSa8lKkZATsMkL8vbAzdaH4JM3vcFFIR
         1Crw==
X-Gm-Message-State: ANoB5pk/loOwl1Bwt5xEN4pZ8zqUzhJ7sA7YzUcTGDVsf48EZfNEhgvJ
        +Dm95TM3r0htLJGImvMk5Qu/
X-Google-Smtp-Source: AA0mqf78KOsPbaaFlVhcd28Ih9c2G7S6cX3mlAYi31+Gy7RmnH1cTQ9mb4rh4Nel4BZ59XsqVQWANg==
X-Received: by 2002:a17:902:ce90:b0:187:19c4:373a with SMTP id f16-20020a170902ce9000b0018719c4373amr61127615plg.163.1669916769695;
        Thu, 01 Dec 2022 09:46:09 -0800 (PST)
Received: from localhost.localdomain ([220.158.159.39])
        by smtp.gmail.com with ESMTPSA id p4-20020a170902780400b0016d9b101413sm3898743pll.200.2022.12.01.09.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 09:46:08 -0800 (PST)
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
Subject: [PATCH v4 22/23] scsi: ufs: ufs-qcom: Add support for finding max gear on new platforms
Date:   Thu,  1 Dec 2022 23:13:27 +0530
Message-Id: <20221201174328.870152-23-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221201174328.870152-1-manivannan.sadhasivam@linaro.org>
References: <20221201174328.870152-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Starting from Qcom UFS version 4.0, vendor specific REG_UFS_PARAM0 register
can be used to determine the maximum gear supported by the controller.

Suggested-by: Can Guo <quic_cang@quicinc.com>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
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

