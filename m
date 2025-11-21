Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657473446DF
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 10:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763721393; cv=none; b=VL+GaClFRsIYa+uzXVcthQ06Yp49xz93IYgPx77x+TcIdJx+kHFd8T5B4+9jYav7mOfZbMdFj9S+Y2FBBId+idkqOkHkRLj6NKjc8Y9OnMqWO1oSTW28vusk9XjJ7j+E7HuHdAKzXZfQovHTdx7LlOV/Unbf+p1sydl50RAgAXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763721393; c=relaxed/simple;
	bh=wpQN7UC1/g2YsCJcn4Wn3sB8Jm+UDAok6ndDubzSCaw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sTBUr1JAqpIXu0/LwaUH/kcmaYU4JJkhUpbRfuohHQM5YBQfVAEw+MMHNwBO7C9+RDw4PL8DWirDhQs/Kk6M5SM2thjMJpK1QGOtRJekaXOG7lCtphOLLX45ypgj6D+ogL9CoJXxEt+euCErNWn/fuGodlIQ956O90sEJcArmHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cfK6nZja; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ay0AK+PS; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cfK6nZja";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ay0AK+PS"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AL8rhpp3676067
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 10:36:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	sHzgYhJ00ZqazENyTafSfehJgnteKbfrSvWtSFDScSc=; b=cfK6nZjaQv2G7++t
	1HLnY24kTwN8kbSsSX+XLpuPfwM6isI4haT8CmmNqqynHpjPaXfhjjtMevBy6iME
	inrXqjdL8PjKmcsuCmKc2LMg/i6HYRjlfh2bWoStJv3Re6nrxhB6O7IZNmP1XUWv
	UChBLKnf7NZlSnpmJ2ONBOC3NQMvuFTZzintiCQGh6B3jTRmKpveayOqMjnsGPH5
	GvJxrasB2VU7K26q9AGvk2VckwDsRkxYSCa0YLoo2BLknJ5wg9L9T6c1IdOdJId5
	xjm/ot4hKJdMnjJDcp3/0jMASWX2aiJ1X10IKhf07W30jVqVUQiimCnn2cK/lTFT
	bf57bg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ajmyj8ehc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 10:36:30 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-343725e6243so2869797a91.1
        for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 02:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1763721389; x=1764326189; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sHzgYhJ00ZqazENyTafSfehJgnteKbfrSvWtSFDScSc=;
        b=ay0AK+PSxOkL2SsiMBqrdFqYTrl58txwvxGTKdlskbP4niWPd+yoj1ao43+dBxM8hg
         ucO+qDp0lSPXq+mvvzfMPt3knnYar6Ham9Wo3732iqnMgCWSoiUOuvN9d1SxYwIME8WE
         /fspE3ftisBCLQ+2b7GCXMIC1FTmN8n9Om3kODTTrWQ0iGKhd8QrZVBWJVjSKBoq6Iea
         DWDjIIlPYoq8MWqU9Z+jJPMlV4BjDnVFZrhrRjNj9taB7hNpsZf9xBYangceBTpIaZm2
         3RM8YBlxF3gUQsDuhdBPpmyRjUw2JZJalOFigJ9D9DdYoG7I2l0UwHW7+v0nogvPuHwX
         oGPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763721389; x=1764326189;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sHzgYhJ00ZqazENyTafSfehJgnteKbfrSvWtSFDScSc=;
        b=tnX/Sh8b66ZC657hkRk62MRD3OTiGBx753/3aOVPnOM1GHLmkv9W9v5R03quxFHDjl
         B7kdQ22PlW8QVd9mQn1Ac4r/Kjy0ZdMH5iDUkr9hFXuy0E+BuMn/3JLaP6C7FYgKc9+7
         ydQ1WPq0AISfcaDe4idgI9olSikNbctancXowMVM30DhcerHPC8P4sKqzC/P4rZhlhGF
         pun/dpg0iGuIwe5cSNyBVAxu08QQ8Ugz992625XiIy4pr8rgKCY4O52jIbFxId80+QWT
         lOrKLc2TwumDlSp6Hxx4u/6vd99X58kJ2FXOvaW0Xgbt/IQo8w/kJWOXJVRjIDyvK3bg
         Li1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWogjc9wOGLJ2j33wyDaSe+1mNQ5l22p/wFjWcfZUn2DcnVuwn5X6dird44PAPhxzpYcx4ZYFLVDLZP@vger.kernel.org
X-Gm-Message-State: AOJu0YwzQwtmIunOE/h6T9iJ4b2wt2Vlyj0AvnB4Fg9vlv/3mnSCs8qi
	RzKBCOxW6lM2Hje5x+ZjE3Lfpto69mlYRCSU6N3WxQULau67Z9sr8vVB1im/GoyczizMqlFayFA
	XyFsxAKRkMWNFRD4tPcMWxYyq0NcJ+gNiuKvqI2FpWFP+KqV6tp258OKgTVKYb2ej
X-Gm-Gg: ASbGncv5CTvKa8cuIdalUjZeUx041fj4VE0F+6A6XPdn/4lfbgUjV4gvsm5miPg1KYQ
	igKSZ1rERo/0xT/siKOV2HdKZ4DhF9hcpmZPQAlt29nUMBDjNEDFROdSzERAN0EVmTparc9pSzD
	ykyYRYglByfLyTkZTMZub8/z6NjU4E8ltnjAtOAJLo1ge4KULIGvAvpWuIYdtY4yG830+ejHsfc
	TqFrx1zjaiLTGMMJXUiFVQ1PxvXLMYh2+ehL947tUpbr2p2jmKh9Q1eXiwnBpufGsJSnK8SOoMe
	PVBG/BjXNqu6WLzasfbPWeLI+Syhqz6APtdUtSg5jnWTMYpfnwARWruxVEbsShBGMxm+REWqsaI
	O88YbYeIx2sOetBjett8h8vKbwiYJ4/lNzzgedsQu6z3G+zA=
X-Received: by 2002:a17:90b:5144:b0:343:72d5:2c18 with SMTP id 98e67ed59e1d1-347298a950dmr6061467a91.12.1763721389019;
        Fri, 21 Nov 2025 02:36:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE96BaIvXWpv4sL4F+JmwyTCe1/pr4N9tBzQDFb8EEWvRt7SAa1qn7Je0pHZOR2x9XHXKxGvg==
X-Received: by 2002:a17:90b:5144:b0:343:72d5:2c18 with SMTP id 98e67ed59e1d1-347298a950dmr6061440a91.12.1763721388546;
        Fri, 21 Nov 2025 02:36:28 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34727be2fa7sm5122890a91.6.2025.11.21.02.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 02:36:28 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Fri, 21 Nov 2025 16:06:04 +0530
Subject: [PATCH v2 1/3] soc: qcom: ice: Add OPP-based clock scaling support
 for ICE
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251121-enable-ufs-ice-clock-scaling-v2-1-66cb72998041@oss.qualcomm.com>
References: <20251121-enable-ufs-ice-clock-scaling-v2-0-66cb72998041@oss.qualcomm.com>
In-Reply-To: <20251121-enable-ufs-ice-clock-scaling-v2-0-66cb72998041@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Authority-Analysis: v=2.4 cv=ELgLElZC c=1 sm=1 tr=0 ts=692040ae cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=BuG_O9g0V-cG3JJ2DZcA:9
 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIxMDA4MSBTYWx0ZWRfX7SBx8s/NCh/z
 HjppnXK+fzl+dSmatL9B/BNbifyNwOWv6HPWbngk+vbX7qMHcGscxykohX8DLuIScOGHRMbuieP
 etsXh/zRap5NjFnMdwvs2V5PbOYtcenP3ArtWuo5M0BhPbss6mMB5ShJ1NQkfh8HXjq9bJmx9Nz
 DaOfawJ9XPgOvVbJ7SvAkNzFxh9yaSLsELBCH4B1ksDZt4Kkmy73qPdTKwuQUMVDecYjpilTGOd
 02ZRgT1cLXH3lu9lFlFu74/OL05J0l2hoc+NGBC7NiTYzhnp+g1FjzPqBypS2U5h6LJU2SrvLBA
 N17DveBjeF1WHyX3rh7pN0SLa8OAxpEq1/p+e7wBg3hThvn9TjPeFfXIxA8naNQ4aGXYjPtGqXo
 L4N2Nd3VIC8KezBK8FnTOxH49Etiqg==
X-Proofpoint-GUID: A_RpjtSS2_OkLrLCJS4Ea9g_7VT_IVr1
X-Proofpoint-ORIG-GUID: A_RpjtSS2_OkLrLCJS4Ea9g_7VT_IVr1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_03,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 phishscore=0 spamscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511210081

Register optional operation-points-v2 table for ICE device
and aquire its minimum and maximum frequency during ICE
device probe.

Introduce clock scaling API qcom_ice_scale_clk which scale ICE
core clock if valid (non-zero) frequencies are obtained from
OPP-table. Zero min and max (default values) frequencies depicts
clock scaling is disabled.

When an ICE-device specific OPP table is available, use the PM OPP
framework to manage frequency scaling and maintain proper power-domain
constraints. For legacy targets without an ICE-device specific OPP table,
fall back to the standard clock framework APIs to set the frequency.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 106 ++++++++++++++++++++++++++++++++++++++++++++-----
 include/soc/qcom/ice.h |   1 +
 2 files changed, 96 insertions(+), 11 deletions(-)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index b203bc685cadd21d6f96eb1799963a13db4b2b72..c352446707ab5e90e6baf159c86a0914ff4bfc53 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -16,6 +16,7 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
+#include <linux/pm_opp.h>
 
 #include <linux/firmware/qcom/qcom_scm.h>
 
@@ -111,6 +112,14 @@ struct qcom_ice {
 	bool use_hwkm;
 	bool hwkm_init_complete;
 	u8 hwkm_version;
+	unsigned long max_freq;
+	unsigned long min_freq;
+	bool has_opp;
+};
+
+static const char * const legacy_ice_clk_names[] = {
+	"ice_core_clk",
+	"ice",
 };
 
 static bool qcom_ice_check_supported(struct qcom_ice *ice)
@@ -549,10 +558,29 @@ int qcom_ice_import_key(struct qcom_ice *ice,
 }
 EXPORT_SYMBOL_GPL(qcom_ice_import_key);
 
+int qcom_ice_scale_clk(struct qcom_ice *ice, bool scale_up)
+{
+	int ret = 0;
+
+	if (scale_up && ice->max_freq)
+		ret = (ice->has_opp) ? dev_pm_opp_set_rate(ice->dev, ice->max_freq)
+				     : clk_set_rate(ice->core_clk, ice->max_freq);
+	else if (!scale_up && ice->min_freq)
+		ret = (ice->has_opp) ? dev_pm_opp_set_rate(ice->dev, ice->min_freq)
+				     : clk_set_rate(ice->core_clk, ice->min_freq);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_scale_clk);
+
 static struct qcom_ice *qcom_ice_create(struct device *dev,
 					void __iomem *base)
 {
 	struct qcom_ice *engine;
+	u32 clk_index;
+	struct dev_pm_opp *opp;
+	int err;
+	unsigned long rate;
 
 	if (!qcom_scm_is_available())
 		return ERR_PTR(-EPROBE_DEFER);
@@ -571,18 +599,74 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 
 	/*
 	 * Legacy DT binding uses different clk names for each consumer,
-	 * so lets try those first. If none of those are a match, it means
-	 * the we only have one clock and it is part of the dedicated DT node.
-	 * Also, enable the clock before we check what HW version the driver
-	 * supports.
+	 * so lets try those first. Also get its corresponding clock index.
+	 */
+	for (int i = 0; i < ARRAY_SIZE(legacy_ice_clk_names); i++) {
+		engine->core_clk = devm_clk_get_optional(dev, legacy_ice_clk_names[i]);
+		if (!engine->core_clk)
+			continue;
+
+		if (IS_ERR(engine->core_clk))
+			return ERR_CAST(engine->core_clk);
+
+		/* Get the ICE clk index */
+		clk_index = of_property_match_string(dev->of_node,
+						     "clock-names",
+						     legacy_ice_clk_names[i]);
+		if (clk_index < 0)
+			return ERR_PTR(clk_index);
+
+		break;
+	}
+
+	/* When it does not match the legacy DT bindings
+	 * it must have only one clock and it is part of
+	 * decicated DT node
 	 */
-	engine->core_clk = devm_clk_get_optional_enabled(dev, "ice_core_clk");
-	if (!engine->core_clk)
-		engine->core_clk = devm_clk_get_optional_enabled(dev, "ice");
-	if (!engine->core_clk)
-		engine->core_clk = devm_clk_get_enabled(dev, NULL);
-	if (IS_ERR(engine->core_clk))
-		return ERR_CAST(engine->core_clk);
+	if (!engine->core_clk) {
+		engine->core_clk = devm_clk_get(dev, NULL);
+		if (IS_ERR(engine->core_clk))
+			return ERR_CAST(engine->core_clk);
+
+		/* OPP table is optional */
+		err = devm_pm_opp_of_add_table(dev);
+		if (err && err != -ENODEV) {
+			dev_err(dev, "Invalid OPP table in Device tree\n");
+			return ERR_PTR(err);
+		}
+		engine->has_opp = (err == 0);
+
+		/* Since, there is only one clock
+		 * index can be set as 0
+		 */
+		clk_index = 0;
+	}
+
+	/* Find the ICE core clock min and max frequencies */
+	rate = 0;
+	opp = dev_pm_opp_find_freq_ceil_indexed(dev, &rate, clk_index);
+	if (IS_ERR(opp)) {
+		dev_warn(dev, "Unable to find ICE core clock min freq\n");
+	} else {
+		engine->min_freq = rate;
+		dev_pm_opp_put(opp);
+	}
+
+	rate = ULONG_MAX;
+	opp = dev_pm_opp_find_freq_floor_indexed(dev, &rate, clk_index);
+	if (IS_ERR(opp)) {
+		dev_warn(dev, "Unable to find ICE core clock max freq\n");
+	} else {
+		engine->max_freq = rate;
+		dev_pm_opp_put(opp);
+	}
+
+	/* Enable the clock before we check what HW version the driver supports */
+	err = clk_prepare_enable(engine->core_clk);
+	if (err) {
+		dev_err(dev, "Failed to enable ICE core clock\n");
+		return ERR_PTR(err);
+	}
 
 	if (!qcom_ice_check_supported(engine))
 		return ERR_PTR(-EOPNOTSUPP);
diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
index 4bee553f0a59d86ec6ce20f7c7b4bce28a706415..b701ec9e062f70152f6dea8bf6c4637ab6ef20f1 100644
--- a/include/soc/qcom/ice.h
+++ b/include/soc/qcom/ice.h
@@ -30,5 +30,6 @@ int qcom_ice_import_key(struct qcom_ice *ice,
 			const u8 *raw_key, size_t raw_key_size,
 			u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
 struct qcom_ice *devm_of_qcom_ice_get(struct device *dev);
+int qcom_ice_scale_clk(struct qcom_ice *ice, bool scale_up);
 
 #endif /* __QCOM_ICE_H__ */

-- 
2.34.1

