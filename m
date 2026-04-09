Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CEF3C2797
	for <linux-scsi@vger.kernel.org>; Thu,  9 Apr 2026 11:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775735089; cv=none; b=GOW1RQxCKaxJGksKEE8jlspLkhUZsow6JSEBVZcadSqNChJ77lNL3kjhyhJxEbaaWVjaY1o8DE23nfHivELED3JG6p27PnKSyf8M1a3KW7EIxXo5mNdJ/gB9zlQu4XiRKCKCsRcRxkUhrwhpmf7Ktt9ejCLeDqmeb/ULtbiM4wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775735089; c=relaxed/simple;
	bh=3XHgcSRng10PQalp+4T3zNZuirhzNRsRGe4tsfJoq24=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=f2X8LFUSWuf3X6mQyTm4JbAjPCIeAmuGOJPZzi/9tDcFgtRo2WXQt6fkdtbxqlkbnP5o4ms5vXKLf2g2g/im8ISei7zIHJdiWemw/SbDWPigQJq+y4vVhY25RPAZhKmawIYXIPTf0Dz/Csg4amyYmC/+OW1TVuD/0iVAyjTyyFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VmxJQleO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Jliwo2YM; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VmxJQleO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Jliwo2YM"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6397L4NG4047542
	for <linux-scsi@vger.kernel.org>; Thu, 9 Apr 2026 11:44:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rKSy/85A70XkSZk9VI18GBLszleodgD9VRhwuaEGsDI=; b=VmxJQleOwdaNBDy6
	F/C2vuXJCaX5IexCHIXWTrueJxYC/1wmnTXbodWW/fCrpdzQeSxJFfPuWfdPZmxj
	Q0k5E67UVCBRLBCFta+luY03MF+EBBglvVVGQvzk9+GNVSysLPLRZF1w3QdrZmha
	0R+nArISSqFr9wjHXsA1fE4/xjmfYOnugZdZip4IRLsfzrPvC290Jk+70U37oKB4
	/V8MG0ZSgcoBfRjuRbKgeCPvGNlmnk/b/+g1zB066jFxjSa4mrTWXD5dhi+Jit8D
	vHRxbIStrmsXkiSnE6XCsVLtTdbvrGnxRxdzv2btDI3GLupPH3Ik652hJe8uo6bE
	r19d/g==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ddtd73tuw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 09 Apr 2026 11:44:47 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b2471321dcso22415335ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Apr 2026 04:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775735086; x=1776339886; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rKSy/85A70XkSZk9VI18GBLszleodgD9VRhwuaEGsDI=;
        b=Jliwo2YMQSa8M26b7QcsBU7zsq2mQcAPoDXdryeaUbiJDPIl4Tf3wzPYTLOkhVQLPh
         3eB7Qzm1TrfFbLYQLEdtG0TBV7qTG/64bJvnR0celoNgIqFVQ9RFXc6+6QbOgzfxa4MG
         1FeUrSqu2CJpHl0uNMZ2jkaE394jacWjT4hP6isjVzHpvpmxW2LuXfV5O3NMv/uYER2X
         u3D7gzISCRDAfnyqm+XVoQUBlXQMnXNTs7d0ltF6+Cxn5UhxCOGokTJ8d4DZp4Z1HV4Y
         Ut+6lA2ECJAD5DtNmzeqo8P2U81/h53S9NgD26Je+RiFLtF3LL9F+RYQjFvgR7GFOjYn
         ijcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775735086; x=1776339886;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rKSy/85A70XkSZk9VI18GBLszleodgD9VRhwuaEGsDI=;
        b=CM8osTyzMPO6pv4FOzhsSZsyfrXtb7fIS23yTgHBqgqyI2bhhM23yYHAOHBonZ/8oN
         p5EvsLykb0VDvvXunhHe0iBm1OdAo/DueFrJi9PzQmLwLsxgZpkcy5FVhtQ66USdXInk
         zHI3pbti+YmFs77m07Hndr/OR7T7Ej0wCILo5MJ4wKCigtXBU+uxwLlzccDhRnom0hnm
         G4SXYrV5fbvSMv2Lc7sX1Yputc5PtmbksTNtN5Z6PowaiXS6U/oT+4WmVe7/0JpsjAHI
         5hRVQin+tnmGN4drJvRmcOEp/+N4KFYEYR1xwHSoNJH8JhHffJzidx2MNyBOBAee6ZhM
         SUog==
X-Forwarded-Encrypted: i=1; AJvYcCUWjhnS04ZsP+acCHv2ncpkcJHHnbLtV2d7YR93bt30TrilYuOsJfJVrN+JyZTQWtFp1M50dRaznfSv@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6Po/yu5VRP+VMhePGkeD/1aVonoQezk30BvqrClsVtTiXTrij
	YKBio8Mbh8BoJ0QPNng794PkYLInJQJTqyNkJU8JAR8Ok/YpjucNA1R4YhxxdEbnLRjL2YFRMjf
	2N2h6KY35BB5D2Zl/cgcSws57Bp0SJ+WQvdUypD0J3h9Pm5JMPOxeVnsh+td1z/wH
X-Gm-Gg: AeBDieuXdhEv01gS2Ro2CrUr1AONxS/80qjvRRkNIGN2NSC9YJFEvslyuJdyjnz1NxK
	LWteq1ItYYY2hlJJm3dnEySrb/YQDTfEecetNT+BBhMrDOq3ihU7w7l9CHcC90s9J+ym14wvP7Q
	TKtUa6TfrRUtj/xIbwmhA4lWzDuEdOfITPE9FiTSINJwoz+uVE+mBsfLt1hDHbd1K+YhuRw/B7j
	SnPqr4NGiUB+JB1wccv35c8+eIjHa99iO6hNh1ihZVQetR/vl4wqzVIpfUA6mtcBKjKUW3RikRe
	c4yghxER73CyeL+Q+10SLhTrX/oKfQtElsUDNIu/LhHIf+LkGNhaLSwA0jeUmGj8/4oB/35uAIl
	FoZgryDEXHmiEYdoWk/o4gmh4dCLInazi3HvOaW4cn/T2J7LKMlJnXky3kFo=
X-Received: by 2002:a17:903:3586:b0:2b2:6b58:9317 with SMTP id d9443c01a7336-2b28194ec0fmr255741405ad.39.1775735086296;
        Thu, 09 Apr 2026 04:44:46 -0700 (PDT)
X-Received: by 2002:a17:903:3586:b0:2b2:6b58:9317 with SMTP id d9443c01a7336-2b28194ec0fmr255740925ad.39.1775735085788;
        Thu, 09 Apr 2026 04:44:45 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749cbd9fsm230957355ad.75.2026.04.09.04.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 04:44:45 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Thu, 09 Apr 2026 17:14:08 +0530
Subject: [PATCH v8 1/5] soc: qcom: ice: Add OPP-based clock scaling support
 for ICE
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260409-enable-ice-clock-scaling-v8-1-ca1129798606@oss.qualcomm.com>
References: <20260409-enable-ice-clock-scaling-v8-0-ca1129798606@oss.qualcomm.com>
In-Reply-To: <20260409-enable-ice-clock-scaling-v8-0-ca1129798606@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Authority-Analysis: v=2.4 cv=QoRuG1yd c=1 sm=1 tr=0 ts=69d7912f cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=zlodBCVASgOsPZHI1q0A:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: XKOH_us43g12ZRSw09d1X1NtGxf3LH0C
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDEwNSBTYWx0ZWRfXxWsP9PiJPj9u
 G43ZnasJNo1NYGdCF4F5uD1piS7rZo4WZ90AuM58hi9f4aDGr+n/axdYL2uDVG8iLo3mzHadrTw
 BDrJe7N3OT1Q4jB3W2dfPi0dQOqVqnK0FAv8ZO79cG6Eqe3ueP7M5qoAJ3Mx/xNUgS236uLiKhA
 EVjJ24MRp1lyQbBlaX7BC1eQyR6mRIg5EmXvAKpKEtxdnwPA0NFq8TsYEjisdmY8GX7cP/nelR7
 DK5tHbrhohNXWIyeMWc3ZQUCrUd7JYXSSNHRiYPbI5tDC64ZhH2kDgcsJ+pj9pMoquO7trj7PDV
 oTvmlxbeHOEUpuJ98AFvJ7NzKQleIktmKoWEUay1SNksqcielRlWexUX9oMyjxjY1Cu7OXxVzhb
 TUzQHoitFly6Rrz+AgK8KIZJ7N5BrkuVr0J1JcclHlB3TKRqDT42EsWxKkqLUPeiu+9+F+pz9AU
 al5l49iKHktsKSBxFSA==
X-Proofpoint-GUID: XKOH_us43g12ZRSw09d1X1NtGxf3LH0C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090105

Register optional operation-points-v2 table for ICE device
during device probe. Attach the OPP-table with only the ICE
core clock. Since, dtbinding is on a trasition phase to include
iface clock and clock-names, attaching the opp-table to core clock
remains options such that it does not cause probe failures.

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

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/soc/qcom/ice.h |  2 ++
 2 files changed, 94 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index bf4ab2d9e5c0360d8fe6135cc35f93b6b09e7a0e..9e869e6abc6300c7608b4d9a18e7f3e80c93f5e7 100644
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
@@ -742,6 +800,40 @@ static int qcom_ice_probe(struct platform_device *pdev)
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
+	 * when the return value is 0.
+	 */
+	engine->has_opp = (err == 0);
+	if (!engine->has_opp)
+		dev_info(&pdev->dev, "ICE OPP table is not registered, please update your DT\n");
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

