Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 016A1C001DC
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 16:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjGaQfH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 12:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbjGaQfB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 12:35:01 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3E9198C
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2023 09:34:57 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1b8b2886364so28572845ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2023 09:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690821297; x=1691426097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wq5hmtX8ZeCMMm6dbjvDpGuRjsszILDfZnpFa+4jjvg=;
        b=DmcMMsuMKXVwoIN53aQmcgBWXZ3Ir4uk0JPEQWwiAfeLg6MkjnhYptoSZ17VvYRMw9
         XAtqf3t9hCgkVpmoEjaNTvXacsWjwh59Dfs6C9jbST9VtYk6O4hgcBzmRZLDMCZSdPri
         SHhNfWlWuJWMa6lnl8n7dErfKkT5Q180YoM3kupE99PCrSJtcL3sYh4PORY7nTCWOsEA
         ZDQESmgyOHFF5VF3KcPbQo7cnahaBE9s0pPxVkj5jAfo3liSDj9AgY0m7v1YGCWhvyU5
         qTmSvNIlSwLxwubSARoXBtlHKRHzAjpHkO2naLxMPvH2Rby6uHgWPMtoBCrI3Tfqix7x
         wcrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690821297; x=1691426097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wq5hmtX8ZeCMMm6dbjvDpGuRjsszILDfZnpFa+4jjvg=;
        b=iCjDp1UdgI9CCRMh+R4NDCWl4MjbASlGDADFVt13L6t+4WYoI+P3fInV6Ul7OKIfn1
         O2zQNCzx7qbOZ0yYnLFFLScVQrbaOIaQS/f9Jq89SnE0f2WqR5Ghqu5XD08ELbobQ5eX
         B7Y2Gv1k4KjXDk/u8TgWHCKekO3CXpbsua9D6BD4BeaJt7//7KI30FLO4GVONYO2r/QF
         dpw8vwSaqrvpGvxIiOZj4eJsR9yqJPcEbqQSSmHHJhdheBC0mcYDiCuwKWC7UsdwOEZS
         6QFdx37MbCN97RQ5m70adVSXD3KZkf+WHjcBmZff/qRDVWIBnxwI2p/A2chBoxYhXG85
         LkMg==
X-Gm-Message-State: ABy/qLbDKVbRoRDRf8EgQgugzGpRzGSN8aI7U+4BunUpGVswxJ+3eWS/
        QVdSSryr3+FW3ppngC+QGdOY
X-Google-Smtp-Source: APBJJlHUXoiZQg0YOeQJphp4nPR2nI3HqtCggRL4ekhBqvOGQeezGteiuK5jIFeygfbii/Y2hCQFdQ==
X-Received: by 2002:a17:902:6b87:b0:1bb:a55d:c6d7 with SMTP id p7-20020a1709026b8700b001bba55dc6d7mr8921646plk.66.1690821297396;
        Mon, 31 Jul 2023 09:34:57 -0700 (PDT)
Received: from localhost.localdomain ([117.193.209.129])
        by smtp.gmail.com with ESMTPSA id w8-20020a170902e88800b001bb1f09189bsm8779541plg.221.2023.07.31.09.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 09:34:56 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     vireshk@kernel.org, nm@ti.com, sboyd@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, andersson@kernel.org,
        konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        quic_nitirawa@quicinc.com, quic_narepall@quicinc.com,
        quic_bhaskarv@quicinc.com, quic_richardp@quicinc.com,
        quic_nguyenb@quicinc.com, quic_ziqichen@quicinc.com,
        bmasney@redhat.com, krzysztof.kozlowski@linaro.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v3 2/6] PM / devfreq: Switch to dev_pm_opp_find_freq_{ceil/floor}_indexed() APIs
Date:   Mon, 31 Jul 2023 22:03:53 +0530
Message-Id: <20230731163357.49045-3-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230731163357.49045-1-manivannan.sadhasivam@linaro.org>
References: <20230731163357.49045-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some devfreq consumers like UFS driver need to work with multiple clocks
through the OPP framework. For this reason, OPP framework exposes the
_indexed() APIs for finding the floor/ceil of the supplied frequency of
the indexed clock. So let's use them in the devfreq driver.

Currently, the clock index of 0 is used which works fine for multiple as
well as single clock.

Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/devfreq/devfreq.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index db50c93c0ac3..e2939c1b7d1f 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -88,7 +88,7 @@ static unsigned long find_available_min_freq(struct devfreq *devfreq)
 	struct dev_pm_opp *opp;
 	unsigned long min_freq = 0;
 
-	opp = dev_pm_opp_find_freq_ceil(devfreq->dev.parent, &min_freq);
+	opp = dev_pm_opp_find_freq_ceil_indexed(devfreq->dev.parent, &min_freq, 0);
 	if (IS_ERR(opp))
 		min_freq = 0;
 	else
@@ -102,7 +102,7 @@ static unsigned long find_available_max_freq(struct devfreq *devfreq)
 	struct dev_pm_opp *opp;
 	unsigned long max_freq = ULONG_MAX;
 
-	opp = dev_pm_opp_find_freq_floor(devfreq->dev.parent, &max_freq);
+	opp = dev_pm_opp_find_freq_floor_indexed(devfreq->dev.parent, &max_freq, 0);
 	if (IS_ERR(opp))
 		max_freq = 0;
 	else
@@ -196,7 +196,7 @@ static int set_freq_table(struct devfreq *devfreq)
 		return -ENOMEM;
 
 	for (i = 0, freq = 0; i < devfreq->max_state; i++, freq++) {
-		opp = dev_pm_opp_find_freq_ceil(devfreq->dev.parent, &freq);
+		opp = dev_pm_opp_find_freq_ceil_indexed(devfreq->dev.parent, &freq, 0);
 		if (IS_ERR(opp)) {
 			devm_kfree(devfreq->dev.parent, devfreq->freq_table);
 			return PTR_ERR(opp);
@@ -2035,18 +2035,18 @@ struct dev_pm_opp *devfreq_recommended_opp(struct device *dev,
 
 	if (flags & DEVFREQ_FLAG_LEAST_UPPER_BOUND) {
 		/* The freq is an upper bound. opp should be lower */
-		opp = dev_pm_opp_find_freq_floor(dev, freq);
+		opp = dev_pm_opp_find_freq_floor_indexed(dev, freq, 0);
 
 		/* If not available, use the closest opp */
 		if (opp == ERR_PTR(-ERANGE))
-			opp = dev_pm_opp_find_freq_ceil(dev, freq);
+			opp = dev_pm_opp_find_freq_ceil_indexed(dev, freq, 0);
 	} else {
 		/* The freq is an lower bound. opp should be higher */
-		opp = dev_pm_opp_find_freq_ceil(dev, freq);
+		opp = dev_pm_opp_find_freq_ceil_indexed(dev, freq, 0);
 
 		/* If not available, use the closest opp */
 		if (opp == ERR_PTR(-ERANGE))
-			opp = dev_pm_opp_find_freq_floor(dev, freq);
+			opp = dev_pm_opp_find_freq_floor_indexed(dev, freq, 0);
 	}
 
 	return opp;
-- 
2.25.1

