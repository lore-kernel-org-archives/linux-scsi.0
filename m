Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5F85C004D4
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Jan 2023 15:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjASPOQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Jan 2023 10:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjASPOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2023 10:14:14 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A87683FA
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2023 07:14:13 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id g10so1803534wmo.1
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2023 07:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pf3TiddMsThpqJL9fIlmLucaPD0shwz9CIN7cHEPyr0=;
        b=ciqJnrk/dNCtuRAhGKIqib0DKk1KQq4dv27OTrSxqBn4uztJ29ylGmVNSq+kuFoHbM
         N06fHJjW6+pxIZM1BGHpWFvjpXBY51p7qcLhlI5s8+i2jK4Q1vZbL+fYp00V57HALfWA
         QpXqOk8AvFEhe1M02RyYEhdPoD11qxd5WRbXkDJCcNrP0XN5WA0Em8rTHvV13ALYdlm/
         4we2Bq0dtocr4mhqw8Px2VK3VsVgl0iJC8pkA6GLACn1RTPe/MkZW0mZZdXwT+lTCauC
         1sVALHfXwQG93wskl76nAMqAh9ow/LgC8UyfZvXoMvBsDdsZncMEfpeeEZ0CvJrOJCpe
         v/Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pf3TiddMsThpqJL9fIlmLucaPD0shwz9CIN7cHEPyr0=;
        b=oYVArwGvREEwMaCvKDw1/AW+1k/sGf+GqhBA1Zh0/qL6vSI2ndDUgTvUJqR9b4L6Hu
         fRbA6ojHLS3fO+KokiqFzfrFRLkxKXmOfxDRy2G0yijKh/ijBKwccopiVO+4btS+rnqt
         Kr33QTAmI7ZnHnsTZ6m+NKkXuPdBe1/w+uiPbhT0bBI7BBzqmXoQe5fnhhrUrdTAeLdB
         /SNfjYoN92IA2dI3pHDpxna6CB22APWxDBb6ZYxtRgqjHOzvlt7yBS+YOKrg1QUwcxEi
         RSCh24zu/oDCzcIiZaiwDFM4fYyty64GlCIWvprcU3iR3ilrj/7OS59t9ifz6qcyRf4u
         pfqA==
X-Gm-Message-State: AFqh2kqAsqgoYPNCdkwlSYrVyGYjnMVm4H4spLuuncJvzVd+HPQPv/BP
        5PjZr/CjKq6OopCLB8JbheiRVw==
X-Google-Smtp-Source: AMrXdXsSGV1ODfoA0XoBReZRcjU3MvJ0gjrgI4ak53eo9a6/AKoUP8jLjPAEP2gXWUtOZDMT6lZYHA==
X-Received: by 2002:a05:600c:3ca0:b0:3da:fc15:740c with SMTP id bg32-20020a05600c3ca000b003dafc15740cmr10731943wmb.19.1674141251582;
        Thu, 19 Jan 2023 07:14:11 -0800 (PST)
Received: from hackbox.lan ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id o16-20020a05600c379000b003db15b1fb3csm4566605wmr.13.2023.01.19.07.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 07:14:11 -0800 (PST)
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Manivannan Sadhasivam <mani@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/2] scsi: ufs: ufs-qcom: Clear qunipro_g4_sel for HW version major 5
Date:   Thu, 19 Jan 2023 17:14:05 +0200
Message-Id: <20230119151406.4168685-2-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230119151406.4168685-1-abel.vesa@linaro.org>
References: <20230119151406.4168685-1-abel.vesa@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On SM8550, depending on the Qunipro, we can run with G5 or G4.
For now, when the major version is 5 or above, we go with G5.
Therefore, we need to specifically tell UFS HC that.

Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 8 ++++++--
 drivers/ufs/host/ufs-qcom.h | 6 +++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 5e7ba3b6a59d..7b6deef4e49a 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -218,6 +218,10 @@ static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
 	ufshcd_rmwl(host->hba, QUNIPRO_SEL,
 		   ufs_qcom_cap_qunipro(host) ? QUNIPRO_SEL : 0,
 		   REG_UFS_CFG1);
+
+	if (host->hw_ver.major == 0x05)
+		ufshcd_rmwl(host->hba, QUNIPRO_G4_SEL, 0, REG_UFS_CFG0);
+
 	/* make sure above configuration is applied before we return */
 	mb();
 }
@@ -507,9 +511,9 @@ static int ufs_qcom_cfg_timers(struct ufs_hba *hba, u32 gear,
 		mb();
 	}
 
-	if (update_link_startup_timer) {
+	if (update_link_startup_timer && host->hw_ver.major != 0x5) {
 		ufshcd_writel(hba, ((core_clk_rate / MSEC_PER_SEC) * 100),
-			      REG_UFS_PA_LINK_STARTUP_TIMER);
+			      REG_UFS_CFG0);
 		/*
 		 * make sure that this configuration is applied before
 		 * we return
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index f744a9e62002..cca773210bcb 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -35,7 +35,8 @@ enum {
 	REG_UFS_PA_ERR_CODE                 = 0xCC,
 	/* On older UFS revisions, this register is called "RETRY_TIMER_REG" */
 	REG_UFS_PARAM0                      = 0xD0,
-	REG_UFS_PA_LINK_STARTUP_TIMER       = 0xD8,
+	/* On older UFS revisions, this register is called "REG_UFS_PA_LINK_STARTUP_TIMER" */
+	REG_UFS_CFG0                        = 0xD8,
 	REG_UFS_CFG1                        = 0xDC,
 	REG_UFS_CFG2                        = 0xE0,
 	REG_UFS_HW_VERSION                  = 0xE4,
@@ -73,6 +74,9 @@ enum {
 #define UFS_CNTLR_2_x_x_VEN_REGS_OFFSET(x)	(0x000 + x)
 #define UFS_CNTLR_3_x_x_VEN_REGS_OFFSET(x)	(0x400 + x)
 
+/* bit definitions for REG_UFS_CFG0 register */
+#define QUNIPRO_G4_SEL		BIT(5)
+
 /* bit definitions for REG_UFS_CFG1 register */
 #define QUNIPRO_SEL		BIT(0)
 #define UFS_PHY_SOFT_RESET	BIT(1)
-- 
2.34.1

