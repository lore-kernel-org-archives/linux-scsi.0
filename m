Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E131318ECD
	for <linux-scsi@vger.kernel.org>; Sun, 24 May 2026 19:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779650768; cv=none; b=ODKADEikMRCFu+tamJ6r6kXQy6x/9IvSTFE0KW8PyN7ssC2VOiUctFP9b53n4rZXuFs0SROr9yJh5qG4VEfMKFBX/UeFzN7CrQwb/dZ7Y9XnGwf4pIikrK3ShpGB1pSGWXX7/q1RHIZJyypsM1PmeeV9p2ol4DjOaS8P+V0IuUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779650768; c=relaxed/simple;
	bh=2XVqbbZnXrWdL6DvN4+UCZ8/oM3cT6QvMe4IpRa4F+c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tOHVxpx3ZG+v7sVV2z2JpJZWaNrOivgX5RfdP4VCRE6AARc1Ll0hrvpuTCyrGG3GoyRdMXPD63QgEopVLISwM4YvmMhRKJ2GdeSfKsGqcKjoLo6tFPYrs9rYTJyiGm6HGPlQXgO9GhhqbKM773kp9SUMoqRsDgfq3CXvQ9BCSGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pPTAroaM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=N7lzQW7a; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pPTAroaM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="N7lzQW7a"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64O8FcMa3282561
	for <linux-scsi@vger.kernel.org>; Sun, 24 May 2026 19:26:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BBy8Sga9ZNMwWSkdE9qADLLm3eq206uB394Jr3D5cVM=; b=pPTAroaMy2+6mEik
	HCA7vFtunh8DcJKzclu4nCSmAMCR18qtK3La2L6muWiclQHyeBYz6A2PpIaQ8BSX
	o7G/WFLePe/w6pPC1DMzPQ/6xMiflLdgBTO6zZg4mCyeXoJjGhuLp7tqVRGVcDsC
	DSqbKcVIhOg6bGwvZS4iE64+OPvKMuigaFDYcVk2S7m/xuF+5SlUFaMW7nW1Vn90
	2ty6+L2L/+CRcGefKfE0NbKRu9qOa4PWSgNLk45+FDLQjmAtcXUSXEwW/HlF6lR9
	UllHYg64kBtvQs686iQEGpnxwNB0EoqfP7zNTgqJn2/+DOS8srU9c+4ZME7CYCoP
	/EvnAQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eb4f3bu74-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 24 May 2026 19:26:05 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b9b8137828so90026115ad.0
        for <linux-scsi@vger.kernel.org>; Sun, 24 May 2026 12:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779650765; x=1780255565; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BBy8Sga9ZNMwWSkdE9qADLLm3eq206uB394Jr3D5cVM=;
        b=N7lzQW7alIXmPrtXbZYxYlVmyHJ1qWfHmXLDm+hesTuYuTj3IfDtbXpM60hbL5UKGS
         b7P62iSaT5UNzg2OcAIiCuqE+KmWmawkcqIdFsOWnri6VWsu3i+uaBZpcUeRjN9LlwYn
         CHTa6o/BGXhTJ2X+eW+J4v42jA/xfqQNAr6x/UDYL1p4d6iZaNzbsgdRtutULy3aey2o
         PxFfr8n6c9ZspkizVJH0ghIabFYcfNiujaJ1ydiGYC68MEx8g9sj8AFrhuyRiz6H8Gtr
         +opVAoHqCsTCsSjRmabYxLYzjLJRKHe0VIIuUryjXt4yFA8fDfH5P5YqDnI5Wh8T47VV
         paYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779650765; x=1780255565;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BBy8Sga9ZNMwWSkdE9qADLLm3eq206uB394Jr3D5cVM=;
        b=WUrYt0311CDXW6tASQkLfMiGQD1umERBiA+Zm3quTHGoaxfSjbrhZ92KtO6pbWH8Nc
         Fruz1ry/Bvi0LwkmbnGDfeGjsB/6Vcu4duR/hM6JqxWe2PJLenOUgTPIU5LYvvyHWCQu
         XJz8+jupPCZpTIZAr/ZGTjmQ/V+mJfxBYbAPp33F/dlE/J4aJzpCSGh6nn9Dc/mCzxz+
         BvlKgRVX+9mvIP7XMc+Of3n434vipKeIRDucIBfNw69cI6CItlkjrmixo+byBdrAa+xw
         zYkMaxzKkolepqwmNn1kMthSnDu1i9hSt1WraIgeWbe4YgfXEUn35m9qVilFT5iyLSHS
         QQUQ==
X-Forwarded-Encrypted: i=1; AFNElJ/YNJ8KSAdFvw3byXQNILAuK6pDrniktO4ekIHZVilRs1A2YlvOK5GY+y/tTYx0bqDTbnJjnBXro87J@vger.kernel.org
X-Gm-Message-State: AOJu0YznEaJl1PA+Vg76VeUpVUwmbvbfov8POxPIxTk14lvuM4BXnUcj
	DOPBEryzJwPnhMyDseniFArQRh4+7ePWDTFVe1TYH5TI7Rhm75HrQKyYlr9xrohXWymXErj0mxj
	bjSEqkT8bLkE+r8Xh60eFAorNI+DH+/aHwHi2PJN8QRLre2pCWPfb9Acj3ICnCsVd
X-Gm-Gg: Acq92OFXWqcHgKgqbW0sEVJ8y9/hjntq0MkbNfnYr5tic0XVNP2reYeGp5zDk7mA0Xp
	fj38P8rWv/6jBzfA9pGcwJck8ftnHl5Fro7wfZKhao5Dgd6KKoHZ5tq8RNE3yIp2oOG5s0Jzzyr
	Ioaeoqdv7lcHmizVVSVCxT0VDGZhApmuBHoBvRyTq3khkU3FOcqMO84cotVwj7mocJXblsbo2K6
	VDWQXwMGvlVy+wVDdi6wl8HQQF3gfgx9tEXnx3p95HFIx+8eDVcK37Hk0myN7mDZt/nW++ibDpW
	WdDgW8Fqm1ops6xFlNloWj+FIdoa2jTTmQidZw0ZVjonWgYkVVSiSzn+yT18yUyA8Zh3GUw3S4V
	KnLTo7zMyZahTRtGDhXXprTEnR23iDB3i7WgZlXAB3h4qiGvwULVV8mhACJI=
X-Received: by 2002:a17:903:3b8b:b0:2b2:ebed:7af8 with SMTP id d9443c01a7336-2beb05a5776mr124836785ad.1.1779650764896;
        Sun, 24 May 2026 12:26:04 -0700 (PDT)
X-Received: by 2002:a17:903:3b8b:b0:2b2:ebed:7af8 with SMTP id d9443c01a7336-2beb05a5776mr124836465ad.1.1779650764342;
        Sun, 24 May 2026 12:26:04 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56ce2cdsm75329945ad.29.2026.05.24.12.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 12:26:03 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Mon, 25 May 2026 00:55:48 +0530
Subject: [PATCH v9 1/5] soc: qcom: ice: Add OPP-based clock scaling support
 for ICE
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260525-enable-ice-clock-scaling-v9-1-c84613e9ce47@oss.qualcomm.com>
References: <20260525-enable-ice-clock-scaling-v9-0-c84613e9ce47@oss.qualcomm.com>
In-Reply-To: <20260525-enable-ice-clock-scaling-v9-0-c84613e9ce47@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-ORIG-GUID: CjUmSd9DspL5xJWkQ5ODQ_vW4pfm8Gns
X-Authority-Analysis: v=2.4 cv=WvYb99fv c=1 sm=1 tr=0 ts=6a1350cd cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=zlodBCVASgOsPZHI1q0A:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI0MDE5NCBTYWx0ZWRfX+TF8gOJPb1gV
 oOhPUUFM64BcJ73sLcxO6VPhFK/i+E3/lfoW/8UBEAMCgcIl2NaGuj0vqcZm467hbBsA446rVbP
 ZLWT3J/2Zuzze8VuWPSxnCEopuAPGbi79EpXHIxDjM4woy6DNbWdKTMTaXfvo9BGXfAODkehDtp
 s+xV9FHspAb0Yq0jivfj7Sgo4Oqpmk9EeLVvF2rdxrNNfiD/WW73SKa5yjdegIdCkDDaZFTV+8N
 d8yTX7bKKiDQR0qzUV1pnmX4057eUODHi/k8ma9zJqFo3E3AkCBJaQNldX8jUHNnSBUiuM8tvDi
 sorA9qPrXfF8/ij6Gvqa3SoZLrtU7iUQlqiOQa6mBfVuGj4NAh++/Orz+dJSM100FS7GYuRnqDe
 CmPA6NhsSI/cZHuPp5+DcElPEuC0JHEq8OK1hZJoENU1X9NCb5jlfXW0duRYoBNs5C+H3NVaQxT
 6mxCOweG2HoxSHt3khQ==
X-Proofpoint-GUID: CjUmSd9DspL5xJWkQ5ODQ_vW4pfm8Gns
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-24_06,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0 impostorscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605240194

Register optional operation-points-v2 table for ICE device
during device probe. Attach the OPP-table with only the ICE
core clock. Since, dtbinding is on a trasition phase to include
iface clock and clock-names, attaching the opp-table to core clock
remains optional such that it does not cause probe failures.

Introduce clock scaling API qcom_ice_scale_clk which scale ICE
core clock based on the target frequency provided and if a valid
OPP-table is registered. Use round_ceil passed to decide on the
rounding of the clock freq against OPP-table. Clock scaling is
disabled when a valid OPP-table is not registered.

This ensures when an ICE-device specific OPP table is available,
use the PM OPP framework to manage frequency scaling and maintain
proper power-domain constraints.

Also, ensure to drop the votes in suspend to prevent power/thermal
retention. Subsequently restore the frequency in resume from
core_clk_freq which stores the last ICE core clock operating frequency.

Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 93 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/soc/qcom/ice.h |  2 ++
 2 files changed, 95 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index bf4ab2d9e5c0360d8fe6135cc35f93b6b09e7a0e..7b98afec71f6135f580f82497127b0db7e70a6da 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -16,6 +16,7 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
+#include <linux/pm_opp.h>
 
 #include <linux/firmware/qcom/qcom_scm.h>
 
@@ -112,6 +113,8 @@ struct qcom_ice {
 	bool use_hwkm;
 	bool hwkm_init_complete;
 	u8 hwkm_version;
+	unsigned long core_clk_freq;
+	bool has_opp;
 };
 
 static bool qcom_ice_check_supported(struct qcom_ice *ice)
@@ -311,6 +314,10 @@ int qcom_ice_resume(struct qcom_ice *ice)
 	struct device *dev = ice->dev;
 	int err;
 
+	/* Restore the ICE core clk freq */
+	if (ice->has_opp && ice->core_clk_freq)
+		dev_pm_opp_set_rate(ice->dev, ice->core_clk_freq);
+
 	err = clk_prepare_enable(ice->core_clk);
 	if (err) {
 		dev_err(dev, "Failed to enable core clock: %d\n", err);
@@ -331,6 +338,11 @@ int qcom_ice_suspend(struct qcom_ice *ice)
 {
 	clk_disable_unprepare(ice->iface_clk);
 	clk_disable_unprepare(ice->core_clk);
+
+	/* Drop the clock votes while suspend */
+	if (ice->has_opp)
+		dev_pm_opp_set_rate(ice->dev, 0);
+
 	ice->hwkm_init_complete = false;
 
 	return 0;
@@ -556,6 +568,51 @@ int qcom_ice_import_key(struct qcom_ice *ice,
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
+ * Return: 0 on success; -EOPNOTSUPP if no OPP table; or error from
+ *         dev_pm_opp_set_rate()/OPP lookup.
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
+	if (ret) {
+		dev_err(ice->dev, "Unable to scale ICE clock rate\n");
+		return ret;
+	}
+	ice->core_clk_freq = ice_freq;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_scale_clk);
+
 static struct qcom_ice *qcom_ice_create(struct device *dev,
 					void __iomem *base)
 {
@@ -731,6 +788,7 @@ static int qcom_ice_probe(struct platform_device *pdev)
 {
 	struct qcom_ice *engine;
 	void __iomem *base;
+	int err;
 
 	base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base)) {
@@ -742,6 +800,41 @@ static int qcom_ice_probe(struct platform_device *pdev)
 	if (IS_ERR(engine))
 		return PTR_ERR(engine);
 
+	/* qcom_ice_create() may return NULL if scm calls are not available */
+	if (!engine)
+		return -EOPNOTSUPP;
+
+	err = devm_pm_opp_set_clkname(&pdev->dev, "core");
+	if (err && err != -ENOENT) {
+		dev_err(&pdev->dev, "Unable to set core clkname to OPP-table\n");
+		return err;
+	}
+
+	/* OPP table is optional */
+	err = devm_pm_opp_of_add_table(&pdev->dev);
+	if (err && err != -ENODEV) {
+		dev_err(&pdev->dev, "Invalid OPP table in Device tree\n");
+		return err;
+	}
+
+	/*
+	 * The OPP table is optional. devm_pm_opp_of_add_table() returns
+	 * -ENODEV when no OPP table is present in DT, which is not treated
+	 * as an error. Therefore, track successful OPP registration only
+	 * when err is not -ENODEV.
+	 */
+	if (err == -ENODEV)
+		dev_info(&pdev->dev, "ICE OPP table is not registered, please update your DT\n");
+	else
+		engine->has_opp = true;
+
+	/*
+	 * Store the core clock rate for suspend resume cycles,
+	 * against OPP aware DVFS operations. core_clk_freq will
+	 * have a valid value only for non-legacy bindings.
+	 */
+	engine->core_clk_freq = clk_get_rate(engine->core_clk);
+
 	platform_set_drvdata(pdev, engine);
 
 	return 0;
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

