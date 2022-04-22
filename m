Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B60C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Apr 2022 13:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447913AbiDVNZD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Apr 2022 09:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447907AbiDVNZB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2022 09:25:01 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E973457B27
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 06:22:07 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id b7so10824415plh.2
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 06:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VJEo0X0uIfdf+jZ7SJyM0RcOsc+vZ/1fj3+IRG98uSo=;
        b=UuRfAQoJy7K2TBJgQEpJQdV/DyUhoMT+iHugPct0qwKEVM9OSiu64f6/0B9X+WWfiA
         3+CM67PnLsbtUmdy8sW9tfWCaZ2G1SUKgdssobL5IhS0BuFrFLsZZfKLRHk4NGcXWOMX
         jPhSXh2ogF5zWn7nkX1otJt+OucDcCzF4IvQsl3XoZxPh3heMOlBIQDnNdSK0Ck2YdJM
         ifvTVRFePBfEXQS5SMY3DRDSfsU14tkKS+IFnF+FlvfzVL9GYbMYlqX34GzJA5PY0Tgk
         WU+iZmC8KM2rV4tuJDe5BJDPq7dskuW3kmRIuJL+oOkAPscewSavvAoXDPpvUgRkR3mq
         cukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VJEo0X0uIfdf+jZ7SJyM0RcOsc+vZ/1fj3+IRG98uSo=;
        b=e9fxwdQM7l2Fh1ZsBqyA4EjhDy2P/8DHB6+cl/gf2V4suwU2zVa3yKn9vezCNFl9qY
         PmikbBT3Vvq1vQbfOMie+dncFovF8rJ4cpEr7M3EYi5tPzoT+ozO2ficgGo7Yedhh/5j
         9khmnkQT5yrQJ8dqEkp2cZE3kb+YWwiXKktoSAQxllyoA8IcmpvX251HKBjUXBFtgK2t
         WG+fCI03+1SvlwZGzYK7IFNRV6J+nRUHh4+qCNy5Dq0QqU0eA4xTJhp0ammkTVzYJXLL
         qsPYVtbLvLGtH/Z8/TC7y/kdT686b4quwi7vi7+EKEngu2q6DDkNpKyaPcbt2GpZaKQN
         D5BA==
X-Gm-Message-State: AOAM531X33ZD8RfAktapdt4UA5gSu/94MeGhx+d+2eXrNUsT4RryAHUH
        hwNsMjqG8yeqwzOGOeYYqTk3
X-Google-Smtp-Source: ABdhPJxJ88rBQ4fFhIg73VLAJ+s3N5JhHTKd8gfgR2ZdjfcWB/ifpsSKJMAATbIAqEfKugX7B3fOTw==
X-Received: by 2002:a17:902:f792:b0:153:1566:18 with SMTP id q18-20020a170902f79200b0015315660018mr4534014pln.115.1650633727467;
        Fri, 22 Apr 2022 06:22:07 -0700 (PDT)
Received: from localhost.localdomain ([117.207.28.196])
        by smtp.gmail.com with ESMTPSA id g13-20020a62520d000000b0050a923a7754sm2586840pfb.119.2022.04.22.06.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 06:22:06 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     avri.altman@wdc.com, alim.akhtar@samsung.com,
        bjorn.andersson@linaro.org, linux-arm-msm@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 2/5] scsi: ufs: qcom: Simplify handling of devm_phy_get()
Date:   Fri, 22 Apr 2022 18:51:37 +0530
Message-Id: <20220422132140.313390-3-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422132140.313390-1-manivannan.sadhasivam@linaro.org>
References: <20220422132140.313390-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no need to call devm_phy_get() if ACPI is used, so skip it.
The "host->generic_phy" pointer should already be NULL due to the kzalloc,
so no need to set it NULL again.

Also, don't print the error message in case of -EPROBE_DEFER and return
the error code directly.

While at it, also remove the comment that has no relationship with
devm_phy_get().

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 5db0fd922062..5f0a8f646eb5 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1022,28 +1022,12 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 		err = 0;
 	}
 
-	/*
-	 * voting/devoting device ref_clk source is time consuming hence
-	 * skip devoting it during aggressive clock gating. This clock
-	 * will still be gated off during runtime suspend.
-	 */
-	host->generic_phy = devm_phy_get(dev, "ufsphy");
-
-	if (host->generic_phy == ERR_PTR(-EPROBE_DEFER)) {
-		/*
-		 * UFS driver might be probed before the phy driver does.
-		 * In that case we would like to return EPROBE_DEFER code.
-		 */
-		err = -EPROBE_DEFER;
-		dev_warn(dev, "%s: required phy device. hasn't probed yet. err = %d\n",
-			__func__, err);
-		goto out_variant_clear;
-	} else if (IS_ERR(host->generic_phy)) {
-		if (has_acpi_companion(dev)) {
-			host->generic_phy = NULL;
-		} else {
+	if (!has_acpi_companion(dev)) {
+		host->generic_phy = devm_phy_get(dev, "ufsphy");
+		if (IS_ERR(host->generic_phy)) {
 			err = PTR_ERR(host->generic_phy);
-			dev_err(dev, "%s: PHY get failed %d\n", __func__, err);
+			if (err != -EPROBE_DEFER)
+				dev_err(dev, "Failed to get PHY: %d\n", err);
 			goto out_variant_clear;
 		}
 	}
-- 
2.25.1

