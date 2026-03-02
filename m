Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1482359A64
	for <linux-scsi@vger.kernel.org>; Mon,  2 Mar 2026 10:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772448582; cv=none; b=Btmuj8ihfpzfQmkpQJH2XXElGQtmdT+voskZuo3kqyJyhz27nZSaEW/dlQNoSVQCK1wpKr8xdVLRgcV+pR73e4VvmteeqwXXJBx/vZsUEUVF97nTTmeFjVAZklONHl2AMWjiS9RPlez6i8XlULhHAr0U/Eix19+9rt4FL0UflW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772448582; c=relaxed/simple;
	bh=LQOEsE4EW+va2w/H5UXNAJZLOMqN0BK3R/N17G2bTRo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aRFEQBglIki6kNr5MUwwU/3i67m5q4O9izu2f0tHagmXk8GLyeN9vMMn56hhgWj2pqwe8tTvS/aisb1CynhnHEmhti8yWLVAf7KEFYrdY1NsC7JV31hZ7hWmN9MeborGXgknEDWRmZh3DhsagVaAbOlAaND3YpDwRrrattO50d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Q/TO6t5s; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Wo/PJT+2; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Q/TO6t5s";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Wo/PJT+2"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6229JZ5o3741985
	for <linux-scsi@vger.kernel.org>; Mon, 2 Mar 2026 10:49:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vOpykfayt0+7TDme6wXpTLrfIkBegFZJ5vdJl8DJV6A=; b=Q/TO6t5sgRiUMt+B
	NqIomCcMpnJkcwv9QCfwJ9IKyvCE2SVHNymKaexIU2V8hlQ4CeZF0FU1yJVEVe50
	8okcj4Bgrk0FQxKo4l/EQiZ22fcOZrsx4mTiznwKD2XMxTPrjZacHfAcbfigU0WN
	Tc6fWG5gt69qcSDInyqML6YyW/tUC5kMfDKfVnmtCc6z8+6zfwRQb/8dzvoUaFsH
	uV38+rJ8QM5tnGlqFLbHqqh3Zw+jKqWj1s5NmngxDG5Q1NCAlTruJ7aueMwBGrAI
	Fs+5uljavFbrBSmo6+FK2fl3TWhdqdbW9ilUaYqb6G5yB+h4WS3Fk9tInpoMhcsK
	UKxARg==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cn7trgakx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2026 10:49:40 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-824bf5fe8cbso1862558b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2026 02:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772448579; x=1773053379; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vOpykfayt0+7TDme6wXpTLrfIkBegFZJ5vdJl8DJV6A=;
        b=Wo/PJT+2HHTeM2xImhw4iEIk7MTtNgOd9CbwpvJ7G0CqnYtJz+EykxzlE4fOqydKFh
         Q806qm8rXq1zJCHLML4OykdOVeUKMT50q35a/YKbMtcgMPtde76Cvl/W75PCiKaGQc4x
         1pjd1+uizFvqBZVemanF/cwkxXTYXdmDn3S9mdseYzNNk8MKz79gnwlrsDnUnayiny3X
         x+RaL/0erbfRrWoNwvbyTAlQZwejZKoIZ29B00PgZi5OOdGmrs9uy1snw6snD39uyP7e
         hnTqBFck02MEcgCX7eeF72EJoJFiridLalqda4+Kw0Ua5dWc4OtBPgkfWSw82njoKF1/
         XvWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772448579; x=1773053379;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vOpykfayt0+7TDme6wXpTLrfIkBegFZJ5vdJl8DJV6A=;
        b=DoiZvWzrEwYG48EtFzTnAFCiI/JIpaZPxNXy+CAx0QrOBMgMeTl+DIWabbI0NBj81t
         oRpxYFhrGDLMEnvy7YSW1mrmwpr+/YtACmKfy/Viosbk3nbX+kAsj4pmpjteAjg+9fFm
         Mw9ojF8+1tWYbyN5ckujgOEHVxrau6fiN2xk2XrKqoOHk98AW1heEBB93jipvRKa/qtI
         PPD5ARNHquYyFmr1hUcts2bRPN9vEgR07603cetyDe/FVRHmm/Oxk+BMO+DjcwvQSi+M
         6ZqPJxPCR55rIyY8K25wKadnhjH5DC4lNy+RHDwOjEZXnPOWr9lE0SLM713b0lPOxRva
         62ww==
X-Forwarded-Encrypted: i=1; AJvYcCX6j57LKuPYcsij3AK/NPEwPC/PKUGOZGtzS+9maXtlavF0S/962Xy51e6D6DHiWGWQEIAD36P9nSvs@vger.kernel.org
X-Gm-Message-State: AOJu0YyLSfnxtj+5Urq6P9KGZd0UZxU9Rw/zCVMB7kIsnNNyemBtzHmS
	baes9Jj8huVJJAxTq5Z6+nt7lb8KVAjv2COxx6zcjzy58omZyOzBYS73eErjV5oFGvYVcvbW/1s
	PJYLzPjc/rJlNePkJq4C+U8TDQkIIntFmLhzWgfkceEU0RscBHyi4xDNqejEC4JE8
X-Gm-Gg: ATEYQzwUIZFR3kMgiliXtefgn0wlAToCAwe8f2Yl+qASDjciVPKBnTUs+q6RhIG9/65
	HKODSVmIjs2xcgWERNXn9OzuWf+F2u39yiwz6hzD8pd5H3hcyYQabmNgTjYvAd29rM7C6A1eHU4
	cgi53JjBk1p/DhpqaAMwr3ey9XSobMu7yxMTDVuCKCovYnEjkxAly6ECzYrqZzXTml5k+K1HAfD
	jccz4Ynh3vLOsisyQ8mUlgHiHQHGtDMm4e8h8FiQYzRhQgnt5NBpvbxcl90xjnw303W+IbWXmeC
	qlc0gv/QE69quzQe1B2gm0DOgte8VBe9jwiVY3Ma9oQxlwEgkY1Yo8vI4J6uSZu5R/s4A1k2mIb
	x+Qw1IjdcmB+p9GYX0g9dQT4EERsIRUiwc0IfjHgNbVdVKmZStCTA0j2fwHs=
X-Received: by 2002:a05:6a00:ad86:b0:827:282e:cb1d with SMTP id d2e1a72fcca58-8274da24aa9mr8939990b3a.66.1772448579390;
        Mon, 02 Mar 2026 02:49:39 -0800 (PST)
X-Received: by 2002:a05:6a00:ad86:b0:827:282e:cb1d with SMTP id d2e1a72fcca58-8274da24aa9mr8939975b3a.66.1772448578906;
        Mon, 02 Mar 2026 02:49:38 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8273a054b49sm12225956b3a.53.2026.03.02.02.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 02:49:38 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Mon, 02 Mar 2026 16:19:13 +0530
Subject: [PATCH v7 1/3] soc: qcom: ice: Add OPP-based clock scaling support
 for ICE
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-enable-ufs-ice-clock-scaling-v7-1-669b96ecadd8@oss.qualcomm.com>
References: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
In-Reply-To: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA4OSBTYWx0ZWRfX4xoc6y146ZA6
 4x3FVG1WQi/sMoZJg5+pmdcy9tE0wHPePqpes3kl6HwR5G2ak9ZguZ9ha/cB1D/9mpQQfDUUB2O
 EDX5xGcqzsxhi3TWUrKXUm5i8ghcrQvaEKylELpTEyBqBjwfpR9ehE6RtLEVwkFk5sEla9FKvML
 9JanAail3NR/nsw9lSGFClDa1IZjcIkNOUAX1LFuCC2lgNomalbDNGZwhIMElCubcUf9u/QTZMG
 Wruz3YMrmJenUHJH/IxnSTZrY1RM37VtRjgfEi3GkPh2NkFxU6tfurmZBIsxiQC5B3BfdO66/qJ
 kqnDIncUefoI9RbAPDsDuzSZhCZG3L4Cz7/dPkDNzYs4lUsErJ8gqZxxQyE0yK+TWU+RTCO68kX
 udwHjufg3kDEbre5yfkVVSVDTz46vAUkxqSJmhf2Em5vCFsAnwdaMB4AferJuTimwTPCE8eo1qk
 rTBEusIyLYk0NUU/a1w==
X-Authority-Analysis: v=2.4 cv=TNhIilla c=1 sm=1 tr=0 ts=69a56b44 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=qcZjKvIi6tDtp92yFeoA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-ORIG-GUID: k2nF1dy98sgp1GBTPjJO8aErc5HxUJtv
X-Proofpoint-GUID: k2nF1dy98sgp1GBTPjJO8aErc5HxUJtv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603020089

Register optional operation-points-v2 table for ICE device
during device probe.

Introduce clock scaling API qcom_ice_scale_clk which scale ICE
core clock based on the target frequency provided and if a valid
OPP-table is registered. Use round_ceil passed to decide on the
rounding of the clock freq against OPP-table. Disable clock scaling
if OPP-table is not registered.

When an ICE-device specific OPP table is available, use the PM OPP
framework to manage frequency scaling and maintain proper power-domain
constraints.

Also, ensure to drop the votes in suspend to prevent power/thermal
retention. Subsequently restore the frequency in resume from
core_clk_freq which stores the last ICE core clock operating frequency.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++--
 include/soc/qcom/ice.h |  2 ++
 2 files changed, 81 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index b203bc685cadd21d6f96eb1799963a13db4b2b72..7976a18d9a4cda1ad6b62b66ce011e244d0f6856 100644
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
@@ -310,6 +313,10 @@ int qcom_ice_resume(struct qcom_ice *ice)
 	struct device *dev = ice->dev;
 	int err;
 
+	/* Restore the ICE core clk freq */
+	if (ice->has_opp && ice->core_clk_freq)
+		dev_pm_opp_set_rate(ice->dev, ice->core_clk_freq);
+
 	err = clk_prepare_enable(ice->core_clk);
 	if (err) {
 		dev_err(dev, "failed to enable core clock (%d)\n",
@@ -324,6 +331,11 @@ EXPORT_SYMBOL_GPL(qcom_ice_resume);
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
@@ -549,10 +561,54 @@ int qcom_ice_import_key(struct qcom_ice *ice,
 }
 EXPORT_SYMBOL_GPL(qcom_ice_import_key);
 
+/**
+ * qcom_ice_scale_clk() - Scale ICE clock for DVFS-aware operations
+ * @ice: ICE driver data
+ * @target_freq: requested frequency in Hz
+ * @round_ceil: when true, selects nearest freq >= @target_freq;
+ *              otherwise, selects nearest freq <= @target_freq
+ *
+ * Selects an OPP frequency based on @target_freq and the rounding direction
+ * specified by @round_ceil, then programs it using dev_pm_opp_set_rate(),
+ * including any voltage or power-domain transitions handled by the OPP
+ * framework. Updates ice->core_clk_freq on success.
+ *
+ * Return: 0 on success; -EOPNOTSUPP if no OPP table; -EINVAL in-case of
+ *         incorrect flags; or error from dev_pm_opp_set_rate()/OPP lookup.
+ */
+int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
+		       bool round_ceil)
+{
+	unsigned long ice_freq = target_freq;
+	struct dev_pm_opp *opp;
+	int ret;
+
+	if (!ice->has_opp)
+		return -EOPNOTSUPP;
+
+	if (round_ceil)
+		opp = dev_pm_opp_find_freq_ceil(ice->dev, &ice_freq);
+	else
+		opp = dev_pm_opp_find_freq_floor(ice->dev, &ice_freq);
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
@@ -584,6 +640,26 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
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
+			dev_info(dev, "ICE OPP table is not registered, please update your DT\n");
+	}
+
+	engine->core_clk_freq = clk_get_rate(engine->core_clk);
 	if (!qcom_ice_check_supported(engine))
 		return ERR_PTR(-EOPNOTSUPP);
 
@@ -628,7 +704,7 @@ static struct qcom_ice *of_qcom_ice_get(struct device *dev)
 			return ERR_CAST(base);
 
 		/* create ICE instance using consumer dev */
-		return qcom_ice_create(&pdev->dev, base);
+		return qcom_ice_create(&pdev->dev, base, true);
 	}
 
 	/*
@@ -725,7 +801,7 @@ static int qcom_ice_probe(struct platform_device *pdev)
 		return PTR_ERR(base);
 	}
 
-	engine = qcom_ice_create(&pdev->dev, base);
+	engine = qcom_ice_create(&pdev->dev, base, false);
 	if (IS_ERR(engine))
 		return PTR_ERR(engine);
 
diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
index 4bee553f0a59d86ec6ce20f7c7b4bce28a706415..4eb58a264d416e71228ed4b13e7f53c549261fdc 100644
--- a/include/soc/qcom/ice.h
+++ b/include/soc/qcom/ice.h
@@ -30,5 +30,7 @@ int qcom_ice_import_key(struct qcom_ice *ice,
 			const u8 *raw_key, size_t raw_key_size,
 			u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
 struct qcom_ice *devm_of_qcom_ice_get(struct device *dev);
+int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
+		       bool round_ceil);
 
 #endif /* __QCOM_ICE_H__ */

-- 
2.34.1

