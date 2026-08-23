Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20123B0594
	for <linux-scsi@vger.kernel.org>; Sun, 23 Aug 2026 19:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787514479; cv=none; b=khHUS3f7aIZo2uVTB+7j1sYvVqpUzWuBYg45BNxTJp8vxzgLydAPs+nuudl287+iw+DNbiDPznOuSAiOVe9QwbzjfxGMuky+v4axgdyLzVJFxbhQNqDwVMRuJiBB7RmLzrgoQZtmtuDgDE3fFZoZWI7+mZ+6zKSKnoC4UdA+uGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787514479; c=relaxed/simple;
	bh=s07n3zGyKTRgJPko42YKE9eClepjokuIZv+mP2hp+u0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=faahXkQaTRUQOIRBJJQirMinzV1GPnhp4pK/qEpFFBGssTmm4CTvVyUTf3X31/9DGMHdvtx3xBl+cJbDeGlkARuHmR610xwflphNZ1L1kjDIiu+3bqgjK2EQna49OZMePzo8bXm0AZurRIWajzAHC1RQ40PGwpSfpMSIvGN64VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=D/fqd0fE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jl4oNrc7; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="D/fqd0fE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jl4oNrc7"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67NG7gpf3569395
	for <linux-scsi@vger.kernel.org>; Sun, 23 Aug 2026 19:47:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rQ+w/bYviLoJPls42Bjsc8yKlWdYtQ8gvXqF+HhAlTQ=; b=D/fqd0fEfU6deNWN
	NFuzWaq/qI6ZisS5C0oMtYzW4ANmt3d1oNSiAoNO/9aQ5KQaxhYqkRMT0gFY7YMw
	wk+CjIrJd6noLjEefijEd8Wqy8mjdsW54Kgp4Mv2hB/IhjELvu0QpZEgUEcn1TMl
	93pRz8SGqa0TaqcJ2zePGl5ehrtfwe6Dq0Bvi80USM9An72SbWwHufDSczobmCe8
	eDAXDN8Iby7VbIwiQIKIUJj09AEGrS+ZfpBlAQwXIRrCG2o0QrfBgcd96r17bOUz
	EDbWlzQETdXuP9JpxrBezRhFPGRHvq1v0xplT4zTzl9xy+4BVB0JTD3PILwQeQ+w
	1ZDNpg==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g74xhc7fw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 23 Aug 2026 19:47:53 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb11535e6a1so2405338a12.0
        for <linux-scsi@vger.kernel.org>; Sun, 23 Aug 2026 12:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787514472; x=1788119272; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rQ+w/bYviLoJPls42Bjsc8yKlWdYtQ8gvXqF+HhAlTQ=;
        b=jl4oNrc7l1a1RrtUSMTJUsduQJ4mvufjFK6PmvHPHCBJ+QnsKVHwW09ViUZsV10mxt
         5s+XX/UqJrQNz5TnER2gFyRLPrhOstYQJhof84KduESCbBYW150pYLA1zxt/ZTjd7ucO
         r2CpQOhs2MdCTxvEqIcZHQZcvXz/78bf/Bp+uRGZNI0fZmw5mZn2X54BBI/Oe07zT3S/
         gQ3m+c3eTEAcYrOaqia60wkygVoFwd8vx/mKYtTEkib4QtyvdmnNrq0JyM63xtCB6vZy
         iBV3we3SiqkoJS2xFg54L/GEDbpefQ5v27US4roOImp5zT+1cgYmD1GyFFGX2YoR2D5o
         xiIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787514472; x=1788119272;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rQ+w/bYviLoJPls42Bjsc8yKlWdYtQ8gvXqF+HhAlTQ=;
        b=hTssOjeVmNkTRhz4gX0y1Pr9SAlFYkjdXskOcpGfOOo4l7QOM/hUZGSuohwDMk+1vN
         31SrdA73prZsuF3nNsrtShxT/GLj9p5dwsXtTiOuh5uYAda+0xc5Cc0UbaSlJlULeuUi
         7nuRJ5RPAaMZ53+b+at/bFQ9nX/BXf5VhrAUBYEC8TqChYxuubsqHc+hLLSP9rH3mVZM
         mjVbCualY/XjT6f8De/EVCZyzg80EHICJWworo9igud8KcRkyJU8x7ySYiD2wFnXdHlC
         ZfbX3UuIQEwfDGF2k1L5RS7bp2utZRxBAag0iCZ7NOAWGuzgkTjs77UPc9PfRj3ZCMVg
         3Kmg==
X-Forwarded-Encrypted: i=1; AHgh+Rpmm3xa+9YmrtVyHbZwHp3k95/V1dRRsGGM1sKuF5vw3nTxfE6nz0I519xlO7aGzKx9z8HaI9he7E3J@vger.kernel.org
X-Gm-Message-State: AFuF++lE8ZXRXtn3TxROZdXGu6ZpXDLaJYm0NmultFguAP0cmi1t+o9d
	CfvUAxzSCDmDsbFsXhPMfefkDvs9/eujBWH4Jgy/pFSkOedXG8O23wNO02ZlgdpIn4GsVg2lHW2
	AIgjOMtQk9jPalN3pUtbFj7wCLOYry1cEj7zf26mx58eROxatAWwKCtvChOzVU+xD
X-Gm-Gg: AR+sD10gbKAoNVnGDLSmgfBU9gGIbcnrvDS/KRS+h/zU2g4odBMhO/KndadT3lDpLVY
	/i3vke1BSvow3g4PZHhsKOdt6UizVBBAf4uGWxsx3L3U3R7O4W8Iax48KKQOrKp7QVav2ODku5R
	kmmID3xToEryn+24X3DCPnO0ulf61BCSQ7nOhlDNGgiLUnPoyd5FUJtg01cMZVh8ILuKAD9KTv6
	bzIeUIaO+1SKbGpLocLp4AI8bcseBxLuiBsRIkfo7eRxvO4bSNHyf5bRzcOLcPXcgm4y2jqzdwg
	4noQSth0kJbyItcYzeAdXOnwzEx8F8VaxQjmfFvHdWfwInlqXwtk7pwqf8+MY7EoLaf210O3HTR
	BS5awsMSZNWJ/COKBHiLA/55HQJQVntk8VZzHsA==
X-Received: by 2002:a05:6a21:3a45:b0:3cc:fb7d:a9ab with SMTP id adf61e73a8af0-3cd4b9ea5famr26997355637.2.1787514472494;
        Sun, 23 Aug 2026 12:47:52 -0700 (PDT)
X-Received: by 2002:a05:6a21:3a45:b0:3cc:fb7d:a9ab with SMTP id adf61e73a8af0-3cd4b9ea5famr26997288637.2.1787514472039;
        Sun, 23 Aug 2026 12:47:52 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f925190fsm32321623eec.31.2026.08.23.12.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 12:47:51 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Mon, 24 Aug 2026 01:17:38 +0530
Subject: [PATCH v12 1/6] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-enable-ice-clock-scaling-v12-1-09271f583dc6@oss.qualcomm.com>
References: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
In-Reply-To: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: wIaiULMx9J9GJOvtA6brM4rgSd36n-06
X-Authority-Analysis: v=2.4 cv=GdQnWwXL c=1 sm=1 tr=0 ts=6a8b4e69 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=Ncwwxt0CvNVXG9qWacgA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIzMDE4MSBTYWx0ZWRfX/dGAByUvll8a
 Zc3Lpz5zxsApCJlbIpSKdvYWVweE+0BPWPupWgY8fLMKapRPHWP1MQyBBj3CcUZBuCpcmQpO/FP
 VzAk9j1aYasIl2V58eIzY+1mvXrZggbhSTdl8bU7Bw1AesnXcB1EuIV8VE0MlJpijEFidvpTL/6
 RPxOGR4fUPnaThyidMXqibZNMvIIwv93RZtNYjrG7/HSRdNRVl2fpqox1jxQyDz9PBAHUzRHMe5
 soUXeLahV6QeTRyM7BqZ/bYMglcVTW44MdY/bUVNFSWGlWdgE+ZWexcxESKy/1qSmsZR7fsu8rW
 RSsqDcG3k1axEp6KOEpuFYi1AoU1X6AxHPfEHg8TgaVLBA/QZ0PCmysuBIPcJGnjQA6gWZZssin
 dPYyGE5q/tGjnyVkcUV8ea8h4AUubvqc1ttVS0tzCg80NhItyPPKJoWnRryzT93YZZP0XEIeo4v
 CA5HkCxOICDyBq9NtDg==
X-Proofpoint-GUID: wIaiULMx9J9GJOvtA6brM4rgSd36n-06
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIzMDE4MSBTYWx0ZWRfX7Rf3JmPsprUn
 dfDb+iIV6KNqQoZXHcX9tx7+4icj8yxp605eEodqccQZn0zf8rTpg47Vf2evV9pK7a5TxVObfXi
 ra01wO8UKhE2geNcr/2wMfVIr2luGKo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-23_06,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608230181

Register optional operation-points-v2 table for ICE device
during device probe. Attach the OPP-table with only the ICE
core clock. Since, dtbinding is on a transition phase to include
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

Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/soc/qcom/ice.h |  2 ++
 2 files changed, 77 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 5f20108aa03ebe9a47a10fba9afde420add0f34a..a7112b4ebab0c76ccb3faf9415dc22b28b73bdcc 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -17,6 +17,7 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/xarray.h>
+#include <linux/pm_opp.h>
 
 #include <linux/firmware/qcom/qcom_scm.h>
 
@@ -113,6 +114,7 @@ struct qcom_ice {
 	bool use_hwkm;
 	bool hwkm_init_complete;
 	u8 hwkm_version;
+	bool has_opp;
 };
 
 static DEFINE_XARRAY(ice_handles);
@@ -560,6 +562,50 @@ int qcom_ice_import_key(struct qcom_ice *ice,
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
+ * framework.
+ *
+ * Return: 0 on success; -EOPNOTSUPP if no OPP table; or errno from
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
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_scale_clk);
+
 static struct qcom_ice *qcom_ice_create(struct device *dev,
 					void __iomem *base)
 {
@@ -738,6 +784,7 @@ static int qcom_ice_probe(struct platform_device *pdev)
 	unsigned long phandle = pdev->dev.of_node->phandle;
 	struct qcom_ice *engine;
 	void __iomem *base;
+	int err;
 
 	guard(mutex)(&ice_mutex);
 
@@ -756,6 +803,34 @@ static int qcom_ice_probe(struct platform_device *pdev)
 		return PTR_ERR(engine);
 	}
 
+	err = devm_pm_opp_set_clkname(&pdev->dev, "core");
+	if (err && err != -ENOENT) {
+		dev_err(&pdev->dev, "Unable to set core clkname to OPP-table\n");
+		/* Store the error pointer for devm_of_qcom_ice_get() */
+		xa_store(&ice_handles, phandle, ERR_PTR(err), GFP_KERNEL);
+		return err;
+	}
+
+	/* OPP table is optional */
+	err = devm_pm_opp_of_add_table(&pdev->dev);
+	if (err && err != -ENODEV) {
+		dev_err(&pdev->dev, "Invalid OPP table in Device tree\n");
+		/* Store the error pointer for devm_of_qcom_ice_get() */
+		xa_store(&ice_handles, phandle, ERR_PTR(err), GFP_KERNEL);
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
+		dev_dbg(&pdev->dev, "ICE OPP table is not registered, please update your DT\n");
+	else
+		engine->has_opp = true;
+
 	xa_store(&ice_handles, phandle, engine, GFP_KERNEL);
 
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

