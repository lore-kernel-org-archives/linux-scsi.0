Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52F231BCB7
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 09:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771493975; cv=none; b=EhOPVypmuSlREh8f75gwJ8jL0dm6Nd09GzdIFRpAGwZECPp/WPC9X6KwwW1vN1e4NZ2d2CCpJYt5A21JzKYCCTMopaOPK+4MTn7P507nVQ4mYwcGP73TlT2o/s3alqUoPWj0Kn+3P0mu7mqa1p5X3Wxp779u4FkVXzqSW2WuAwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771493975; c=relaxed/simple;
	bh=kDMzpbJp7/rLqYwKGMaZIVc8pzd6JwXhACdjFivVaJ8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bmIytZJyGg0ek2xjh+kOtbJQPe00OIhZRzvHX6d7+NJM/jM7WUtVs0pxK5ZAZk/zXQJWy0kabwebc50+xOQRWv81LlQ0h6r7mz7Amb+ZJd0exP7JaO1t7k4UWFrTwaVfcK2UpxccF1aSorXcJoPnS/Qoznz3lMdVdu/TIXuoIcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mL0glHvV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=E5+TjTuE; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mL0glHvV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="E5+TjTuE"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61J56jUa3319588
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 09:39:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	eJ7q7P1YKR2cir05Q7NmQQK/JszGCthoOd76hIYXMrc=; b=mL0glHvV0k0mRFIw
	r0v9z3tV6hXob4Q0TdXzmSjOxpg0/4T4q9YgbSd+Zl2EAtmzuUHL712h2KKEQVfA
	YZxuf+j2hogkvtJ8lnEdgLeCFSXy4C4tH4jfjz71Zt9hmtJ0+9nCjd+XB/5r2kTv
	cmNYu2NtdycRMpQLXtxHqA7bLLHXB08dplb6sqUwC5ukhaat15JYdMEI2tFSGzxw
	bZH1H0g9XH3advhmjvOzABlNjhbfdnW03pzN8tE8+GLMVe+i9x4qpU57JuNqbAi5
	d53SjF5RBmgcvh59+odb6gCRTjERXrH2rUiH9Ber/IJCjrUKAg3/zoPvqKeX3xSX
	oz55ZQ==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cdv388kc8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 09:39:32 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8249cbbf769so352012b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 01:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771493972; x=1772098772; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eJ7q7P1YKR2cir05Q7NmQQK/JszGCthoOd76hIYXMrc=;
        b=E5+TjTuESiuqvHMULuI05yCNM5N53u60NLdB3W82KIctcRd4IFWFUalg+jS+IJGpqq
         t4K0bTWstqkdFZRt9qlHyb3687SQ7ENbWEhPbPLXTJyQYwgbNsvQKikMGI5Uq+EhfuCv
         hSOSBvdVb4rbU5wHKCxcJqL/63TOBjxubqyPNBtaQOH/k4MG79QwfSwu0c9cn3kjJyUJ
         qTXY8TzUaBPjlbCCndzlk4vkA2U8UpousiWjaj3BiJFZJdVMnS2DdLO2JKnTcjZjT9F2
         WzMh0AtJLOE8cF9dyrS/cJShk/Q1lp7UvrZXMCUoY6RtZoKRXQyhMUOU4d+xY3SfkThB
         RkLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771493972; x=1772098772;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eJ7q7P1YKR2cir05Q7NmQQK/JszGCthoOd76hIYXMrc=;
        b=DJi2rXYQUVm+0HagKOrMkLxTcd3pCOsbX8qvddAaC+Gvl1xzhXka4QE3EIkNoZ587m
         qoHLExYUbvyXHUKR/mlu6lLlgJCAj9Jkcf4Lnjp0u0oMJ6CUQN9fhkr1DXyOVGit5bYE
         FS3fs0+strNt16TwQysCiROd8cAsJqRYwmX5Y/4U2APS9VF3/pAZ+mfeCfRGO+yOA9sW
         Ia5wfACFSZyleF9AiaLYJJ3S8g2JNlL7SyykGUtkXq3H27kaVRvBus3MJ10fJzLKLMoj
         wyK+f79p6NjH7wNoUpTaTXLdy4Yq3uQWjjyS81X5zOquhXPxANc01HGoPzsMHDD8khsr
         RTzA==
X-Forwarded-Encrypted: i=1; AJvYcCUKbhinmjB0g2E6B1y0GTgsKyEBxwLD8LffA+/B7XXNXzouqIyfJ96r8Yhikg5V17KdNycqdukM7Rl3@vger.kernel.org
X-Gm-Message-State: AOJu0YxAdGQM/G5s1M5G1+PuMIuAidzpMCoqyMmBc0ZyW62e3m33hUwm
	QMBZZZUrw0W4tjVfE6UUa6Bl8D7nUdpk17apeR/txbQxfBwIbHaCel9xK19olTBZLTfz0XoChJA
	f8p/7Kmj5tcEeCbinyAhT21WWJLlFWTa4L1EiRKqIX7sQsn+Uh25SaH25ixKkmTSx
X-Gm-Gg: AZuq6aKrLaxJTQNSTYHTTo7+hAoOreaG/SwQcdTfLPKHh1QuRjWwBOzOgSJztYvP6oO
	Xo+JQzX/GtLVLjSNe3vFv2KA1EgVwUVoip+NLbQcZ7AF4bRwhSLGhLEzJ24Ep8jC+GYjHQ+d4dE
	KektN6rZMFrA/xKo68loo3zmKYDjZcVt+Vry4E6/dN6O0kvoWE+y/6kTOmFkqU5OmafGCdZ/cv9
	E6W1xEmCY/BdPWqi3yHTBPM31jo6IwfzH4hR+UlvtFNA6VcfDDU+g30OECMlnGE7Ydaon1F3ceb
	Q2/eS2CIuV+N5iFA9KdUBt63kDSlDINp+ydnoCcF4Yv6VmnX3sK0fhRAy2Q5I/xtZRRFlOpEFm3
	ETpxyg8mJwbQa8wGTTefJepwg+mnZgIOYJB64cwZWvzyFMJ0pFEn48U2fetU=
X-Received: by 2002:a05:6a00:14cd:b0:81f:4294:6080 with SMTP id d2e1a72fcca58-825274bb7eamr5025419b3a.20.1771493971751;
        Thu, 19 Feb 2026 01:39:31 -0800 (PST)
X-Received: by 2002:a05:6a00:14cd:b0:81f:4294:6080 with SMTP id d2e1a72fcca58-825274bb7eamr5025404b3a.20.1771493971216;
        Thu, 19 Feb 2026 01:39:31 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6a2ac83sm17710250b3a.12.2026.02.19.01.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 01:39:30 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Thu, 19 Feb 2026 15:09:14 +0530
Subject: [PATCH v6 2/4] soc: qcom: ice: Add OPP-based clock scaling support
 for ICE
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260219-enable-ufs-ice-clock-scaling-v6-2-0c5245117d45@oss.qualcomm.com>
References: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
In-Reply-To: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Authority-Analysis: v=2.4 cv=ceffb3DM c=1 sm=1 tr=0 ts=6996da54 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=mjMY47ajJ_YgJ0Xw87EA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: 2ITaDmFgbZcHJizKwu5htdx0pVaBaE_G
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA4NyBTYWx0ZWRfX6PNPUt2wE+L+
 jl2jjTyNiJ+qxVRfItxNxOXy7yfFU233dcE0Q+R4JHFS8hslEVLiz8pSutHU0zZnD2LFX5W3+c3
 wJgucFu2nZowUIC4bws9Xhb4bJE1JlSDMKMbqqu5dzUuc6pg+TpgJ8Xfh6uMAg/OKConMZTrJDL
 YBgp3aqhx3v1KjspMHsk7Jl/sV+SKAm9XEaBgSmNT2JKZZr5ZPgNbyw/EQa048Vn8iygplDs7cm
 fILzRdTKyEWAWo4DI5TMg4QTjtKmal8Z59aftoRBHn55ks36cROCbZ5+RGBGpzRgMrlzEyQQP5C
 Rx0ynNQ8F1eDkv25txxZ8Kvo90ERtEreZP6EL7iZm2jeWrtEkH5Ild/j7FB988PCXvqSMLkLcNf
 BDIZtwxaeD/yJMMPLczGQRq59s30YrOAS8T+q/6jNwqhu6uzMQgvh27ILkXPJH7Fh+pym9wCjdC
 zHrM83FdRKYCYSu3fQg==
X-Proofpoint-ORIG-GUID: 2ITaDmFgbZcHJizKwu5htdx0pVaBaE_G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_03,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 bulkscore=0 clxscore=1015 malwarescore=0
 impostorscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602190087

Register optional operation-points-v2 table for ICE device
during device probe.

Introduce clock scaling API qcom_ice_scale_clk which scale ICE
core clock based on the target frequency provided and if a valid
OPP-table is registered. Use flags (if provided) to decide on
the rounding of the clock freq against OPP-table. Disable clock
scaling if OPP-table is not registered.

When an ICE-device specific OPP table is available, use the PM OPP
framework to manage frequency scaling and maintain proper power-domain
constraints.

Also, ensure to drop the votes in suspend to prevent power/thermal
retention. Subsequently restore the frequency in resume from
core_clk_freq which stores the last ICE core clock operating frequency.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++--
 include/soc/qcom/ice.h |  5 +++
 2 files changed, 90 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index b203bc685cadd21d6f96eb1799963a13db4b2b72..1372dc4a4a4d0df982ea3a174df8779a37ce07c6 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -16,6 +16,7 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
+#include <linux/pm_opp.h>
 
 #include <linux/firmware/qcom/qcom_scm.h>
 
@@ -111,6 +112,8 @@ struct qcom_ice {
 	bool use_hwkm;
 	bool hwkm_init_complete;
 	u8 hwkm_version;
+	unsigned long core_clk_freq;
+	bool has_opp;
 };
 
 static bool qcom_ice_check_supported(struct qcom_ice *ice)
@@ -310,12 +313,17 @@ int qcom_ice_resume(struct qcom_ice *ice)
 	struct device *dev = ice->dev;
 	int err;
 
+	/* Restore the ICE core clk freq */
+	if (ice->has_opp && ice->core_clk_freq)
+		dev_pm_opp_set_rate(ice->dev, ice->core_clk_freq);
+
 	err = clk_prepare_enable(ice->core_clk);
 	if (err) {
 		dev_err(dev, "failed to enable core clock (%d)\n",
 			err);
 		return err;
 	}
+
 	qcom_ice_hwkm_init(ice);
 	return qcom_ice_wait_bist_status(ice);
 }
@@ -324,6 +332,11 @@ EXPORT_SYMBOL_GPL(qcom_ice_resume);
 int qcom_ice_suspend(struct qcom_ice *ice)
 {
 	clk_disable_unprepare(ice->core_clk);
+
+	/* Drop the clock votes while suspend */
+	if (ice->has_opp)
+		dev_pm_opp_set_rate(ice->dev, 0);
+
 	ice->hwkm_init_complete = false;
 
 	return 0;
@@ -549,10 +562,59 @@ int qcom_ice_import_key(struct qcom_ice *ice,
 }
 EXPORT_SYMBOL_GPL(qcom_ice_import_key);
 
+/**
+ * qcom_ice_scale_clk() - Scale ICE clock for DVFS-aware operations
+ * @ice: ICE driver data
+ * @target_freq: requested frequency in Hz
+ * @flags: Rounding policy (ICE_CLOCK_ROUND_*)
+ *
+ * Selects an OPP frequency based on @target_freq and the rounding mode in
+ * @flags, then programs it using dev_pm_opp_set_rate(), including any
+ * voltage or power-domain transitions handled by the OPP framework.
+ * Updates ice->core_clk_freq on success.
+ *
+ * Return: 0 on success; -EOPNOTSUPP if no OPP table; -EINVAL in-case of
+ *         incorrect flags; or error from dev_pm_opp_set_rate()/OPP lookup.
+ */
+int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
+		       unsigned int flags)
+{
+	unsigned long ice_freq = target_freq;
+	struct dev_pm_opp *opp;
+	int ret;
+
+	if (!ice->has_opp)
+		return -EOPNOTSUPP;
+
+	switch (flags) {
+	case ICE_CLOCK_ROUND_CEIL:
+		opp = dev_pm_opp_find_freq_ceil(ice->dev, &ice_freq);
+		break;
+	case ICE_CLOCK_ROUND_FLOOR:
+		opp = dev_pm_opp_find_freq_floor(ice->dev, &ice_freq);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (IS_ERR(opp))
+		return PTR_ERR(opp);
+	dev_pm_opp_put(opp);
+
+	ret = dev_pm_opp_set_rate(ice->dev, ice_freq);
+	if (!ret)
+		ice->core_clk_freq = ice_freq;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_scale_clk);
+
 static struct qcom_ice *qcom_ice_create(struct device *dev,
-					void __iomem *base)
+					void __iomem *base,
+					bool is_legacy_binding)
 {
 	struct qcom_ice *engine;
+	int err;
 
 	if (!qcom_scm_is_available())
 		return ERR_PTR(-EPROBE_DEFER);
@@ -584,6 +646,26 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 	if (IS_ERR(engine->core_clk))
 		return ERR_CAST(engine->core_clk);
 
+	/*
+	 * Register the OPP table only when ICE is described as a standalone
+	 * device node. Older platforms place ICE inside the storage controller
+	 * node, so they don't need an OPP table here, as they are handled in
+	 * storage controller.
+	 */
+	if (!is_legacy_binding) {
+		/* OPP table is optional */
+		err = devm_pm_opp_of_add_table(dev);
+		if (err && err != -ENODEV) {
+			dev_err(dev, "Invalid OPP table in Device tree\n");
+			return ERR_PTR(err);
+		}
+		engine->has_opp = (err == 0);
+
+		if (!engine->has_opp)
+			dev_info(dev, "ICE OPP table is not registered\n");
+	}
+
+	engine->core_clk_freq = clk_get_rate(engine->core_clk);
 	if (!qcom_ice_check_supported(engine))
 		return ERR_PTR(-EOPNOTSUPP);
 
@@ -628,7 +710,7 @@ static struct qcom_ice *of_qcom_ice_get(struct device *dev)
 			return ERR_CAST(base);
 
 		/* create ICE instance using consumer dev */
-		return qcom_ice_create(&pdev->dev, base);
+		return qcom_ice_create(&pdev->dev, base, true);
 	}
 
 	/*
@@ -725,7 +807,7 @@ static int qcom_ice_probe(struct platform_device *pdev)
 		return PTR_ERR(base);
 	}
 
-	engine = qcom_ice_create(&pdev->dev, base);
+	engine = qcom_ice_create(&pdev->dev, base, false);
 	if (IS_ERR(engine))
 		return PTR_ERR(engine);
 
diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
index 4bee553f0a59d86ec6ce20f7c7b4bce28a706415..962454b85ccd994aeeb373729d4b39a2e0b40069 100644
--- a/include/soc/qcom/ice.h
+++ b/include/soc/qcom/ice.h
@@ -9,6 +9,9 @@
 #include <linux/blk-crypto.h>
 #include <linux/types.h>
 
+#define ICE_CLOCK_ROUND_CEIL	BIT(1)
+#define ICE_CLOCK_ROUND_FLOOR	BIT(2)
+
 struct qcom_ice;
 
 int qcom_ice_enable(struct qcom_ice *ice);
@@ -30,5 +33,7 @@ int qcom_ice_import_key(struct qcom_ice *ice,
 			const u8 *raw_key, size_t raw_key_size,
 			u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
 struct qcom_ice *devm_of_qcom_ice_get(struct device *dev);
+int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
+		       unsigned int flags);
 
 #endif /* __QCOM_ICE_H__ */

-- 
2.34.1

