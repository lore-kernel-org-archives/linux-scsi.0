Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603A4367F41
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 09:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770803292; cv=none; b=HsVSGLmMagDV77zRwfIEtxISX3xBwBEoJsVWldWrJMywpRoauNe8ZWGca+vamRfeQLwuYeOUX5Ao5TgqDllADcz4LHNcinLV3SWwpgPMKYgjNfDVTc5UUER7ykiQ6qp9XdI5K+gJdNcz00MgleEA98enODr7iND+kwa0TXIL+HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770803292; c=relaxed/simple;
	bh=f787Up0EhRy8WkAfsNkCR9M3EI+tIDdcqS3Jo2fPGco=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=opynW5HrMfvhQTR4PV6cdgBLRI73n9uN/yH14fIV0aw4SnNLu3EKclcZnYZdRhgXaeEDCdPXZac5aUS4DD4Q1ooM/19VfJ/oj6Bld2mMrEuGCc32GrOyASU+E8E3PlID6xPdzBO3lXzn274Snn0hMzIQLCDPoCOqSIbcTN9F7vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mgn6W34T; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZncOnVe3; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mgn6W34T";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZncOnVe3"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61B54LOt4013972
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 09:48:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	t6ovBuigOTYzxtYq6iL3axs74leILzsr4KDWdNf9kxs=; b=mgn6W34TK7DS5VA/
	hjMkx97ruIk27C0sFLUZgvcCA7WY2fgNrvtDo4R+bIHF6tBYz+40I96JzJhAy2hC
	KfuD97TFqtR9aFV7mwNxOwJsnvtz2oyNfI8ykdH23xRS9btPb5gUxVFTdCdySy2V
	n4MK4djWzb5n9DE3LE2tq4Sm9oWwvNiV2FPHXmR8UHqjMV5dMN0W4S1VuDBtql1m
	z2x9WGnFck1uv/crkOSNcusLGWwwcojYZjYdJRNipyY2vLHudkflJ3f/SzC3jIjQ
	wXPEsigS1VhwhHauOaEJwUv3easPwFNISfO/1bWQgEVX6s+TWSzNa61NSHY/We8j
	fOSCWg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c8aadagxg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 09:48:10 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-354c0234c1fso4707450a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 01:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770803289; x=1771408089; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t6ovBuigOTYzxtYq6iL3axs74leILzsr4KDWdNf9kxs=;
        b=ZncOnVe3lDapayNbK9nEHtDifMxlZnIsQCq3t9iqxnrGUgBtpZkIzT35AkvXWeOrxx
         Nbfp0f4IYqg+HFN/mTbQ8hPmG/283T8pX4FSb+p727cyfM/SddlA+pp+dRj+/RstLRo4
         a085vLDc7N9H4Bspe8CV68qUkONoUxaejVZGnkua/My0mT2L6lvzFOzvTiFR5YqSmE1M
         oB/U/QLqzyRQC4WUjRxoJs5oKseemQA3rB1Z52rcX/c0dSAtJmIfnfE4kV+wA/LGwmjV
         Wc4ohg6W2x87aDf6QXtXqrYSQfbDyGsqXIprBtvwUgEkBbGuHqftozMguLQ7vQebbglK
         Pj0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770803289; x=1771408089;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t6ovBuigOTYzxtYq6iL3axs74leILzsr4KDWdNf9kxs=;
        b=TDMgzflykGxSiF3qrAZSYPMFStjOpHVsTFiq4d+lvzjgHNrc6m/NNtgIUgIHkyv81q
         L1gbITIJKLuZRLMX2gPsUib3HR+tODwxWHSQ0bfNECQMC65asO/xDml1rftLb2d5bU9u
         YxEjxO7+Vs1IveNwAUdSgkny69YFfLLuUAmY7l84f1vX/12psPnZ7D0Nr8MhwyvrJ+36
         QhVWnfw8506Np3fzuxGmHw8OaPGvF/65XCiqB2LsXJrj/nX+MEIspKeRzZ/VQy0JSR1a
         xWhmDiG6AdzLdUzPc76DuxCGwN9EmycOcU9EBUoUKrT1ma9hfE5ZyqxnDlBMyMT+k09o
         ZAKA==
X-Forwarded-Encrypted: i=1; AJvYcCU0gq5pFFRSGp1SzQ8drwB1Ry9kIhuF8Pv1B2sJG6yZursCalKS3wIl5QjJSkaiUSnQbOitEMhQQIx7@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7hl6JqeED1nDVR933txl7uUQNE1AjyjBfMAoyuaW+ZbtcNAUI
	r7EciTUc5yChE+MRNuc8ESxzzPwv6CrYd0WKv7CXF3fAlzEu4WXkZan6PWqmrqkNy7OtVwpvedE
	DyqWHDfwrMW6dW0fcJ6O8b0dzGgtLHAM4RJVwk8cZ3yS6Jk8G50Ora7nzhgdfp19i+2JpcP1p
X-Gm-Gg: AZuq6aK8rVt2uVBmY97WOjPNzLrpyd5oxmr5dmuZYZTLKKD1r5lz7MSIa+vNaqf0jpH
	EGMA/7Or36y3Uy4F768VBKGrF7Cd1n8uO4K/RBZsN1WwOdHb4r+kDQYDv3lZSQ4B5TeXBgJAOg1
	1gX1gOrzlyue3v+iuT5XiBgk4ZMhaTmNtobwvNp7KNB7cCxYkic5hx1OY8FU9vdCZuWSODES+Ya
	V4j8Tryj/xvslzEZERQKlVDni+QbvF/L4BVz0cVCnVdyUVzYPCf1DmhjCK/HSQc+BAV5FgBwen9
	jZbrCIkvpSjviA2rInrk4FVpyOSoRgZDdaqdgHFbe4Ib3edQVVLPhym03vkaJ+v4lNrb9iArYe4
	R6Y79ZFN0ZQW9owvnWC7n+lE1NEIB69lxvkD0oBxuqkejvKwPRPBi/fkziWU=
X-Received: by 2002:a17:90b:164b:b0:356:268e:ff97 with SMTP id 98e67ed59e1d1-3567b077a54mr2126528a91.20.1770803288989;
        Wed, 11 Feb 2026 01:48:08 -0800 (PST)
X-Received: by 2002:a17:90b:164b:b0:356:268e:ff97 with SMTP id 98e67ed59e1d1-3567b077a54mr2126505a91.20.1770803288456;
        Wed, 11 Feb 2026 01:48:08 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35662f6b84dsm7526640a91.10.2026.02.11.01.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 01:48:08 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Wed, 11 Feb 2026 15:17:45 +0530
Subject: [PATCH v5 2/4] soc: qcom: ice: Add OPP-based clock scaling support
 for ICE
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260211-enable-ufs-ice-clock-scaling-v5-2-221c520a1f2e@oss.qualcomm.com>
References: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
In-Reply-To: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-ORIG-GUID: 3rY9ZXGe9KFqmkw2FYCXZzyukJxXErnx
X-Proofpoint-GUID: 3rY9ZXGe9KFqmkw2FYCXZzyukJxXErnx
X-Authority-Analysis: v=2.4 cv=OoVCCi/t c=1 sm=1 tr=0 ts=698c505a cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=JZEC_EQWKO-DjWEl64AA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDA3OSBTYWx0ZWRfX+px6DseDdDst
 PeMdJlwmAKI/cZ3JHSURA6UAXNN3m1MFimiMXrCBM+P8fbSKMYQgzZQxxFC5N5C2Jy9gVUiArZL
 3e11329cQCMChR02z36Di2rzGLjZaAvH0TN/OoFxFXpMjndwdY/5U2l+G8K2CDNQZIP0pmbZGb6
 vFXyMp1ijURfhkbsudpmzmE0vdhnOoWzhWYKaub8C2nbh60cD0wuJ/imOuXKjJfqWk5B8cgPY5Q
 JDzEmx0aNaMEj9B42Mag+6VCLcWgVG8QlYc+HUDWhaBZn502703mNjZLjhZKu6caHmpalzLc3Je
 IfUKcUnnUJLfL9VmUugXD00r7OgNuBctsThvszvytCJ8YxRJh+cquOSHJvmaT044KSkAawMJY9d
 BL9VUVpX3+cYQGgckoVVIKE3B1gfTKit06TtOqG6bsyPP4QVVaplPp7hQ6yNU2TdLheCieW+Ibv
 Dl6Csduj63CVlE4/qHg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_03,2026-02-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602110079

Register optional operation-points-v2 table for ICE device
and aquire its minimum and maximum frequency during ICE
device probe.

Introduce clock scaling API qcom_ice_scale_clk which scale ICE
core clock based on the target frequency provided and if a valid
OPP-table is registered. Use flags (if provided) to decide on
the rounding of the clock freq against OPP-table. Incase no flags
are provided use default behaviour (CEIL incase of scale_up and FLOOR
incase of ~scale_up). Disable clock scaling if OPP-table is not
registered.

When an ICE-device specific OPP table is available, use the PM OPP
framework to manage frequency scaling and maintain proper power-domain
constraints.

Also, ensure to drop the votes in suspend to prevent power/thermal
retention. Subsequently restore the frequency in resume from
core_clk_freq which stores the last ICE core clock operating frequency.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 132 +++++++++++++++++++++++++++++++++++++++++++++++--
 include/soc/qcom/ice.h |   5 ++
 2 files changed, 134 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index b203bc685cadd21d6f96eb1799963a13db4b2b72..0bdc64db414a7028653c0f3327988b1554788fcf 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -16,6 +16,7 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
+#include <linux/pm_opp.h>
 
 #include <linux/firmware/qcom/qcom_scm.h>
 
@@ -111,6 +112,10 @@ struct qcom_ice {
 	bool use_hwkm;
 	bool hwkm_init_complete;
 	u8 hwkm_version;
+	unsigned long max_freq;
+	unsigned long min_freq;
+	unsigned long core_clk_freq;
+	bool has_opp;
 };
 
 static bool qcom_ice_check_supported(struct qcom_ice *ice)
@@ -310,12 +315,17 @@ int qcom_ice_resume(struct qcom_ice *ice)
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
@@ -324,6 +334,11 @@ EXPORT_SYMBOL_GPL(qcom_ice_resume);
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
@@ -549,10 +564,79 @@ int qcom_ice_import_key(struct qcom_ice *ice,
 }
 EXPORT_SYMBOL_GPL(qcom_ice_import_key);
 
+/**
+ * qcom_ice_scale_clk() - Scale ICE clock for DVFS-aware operations
+ * @ice: ICE driver data
+ * @target_freq: requested frequency in Hz
+ * @scale_up: If @flags is 0, choose ceil (true) or floor (false)
+ * @flags: Rounding policy (ICE_CLOCK_ROUND_*); overrides @scale_up
+ *
+ * Clamps @target_freq to the OPP range (min/max), selects an OPP per rounding
+ * policy, then applies it via dev_pm_opp_set_rate() (including voltage/PD
+ * changes).
+ *
+ * Return: 0 on success; -EOPNOTSUPP if no OPP table; or error from
+ *         dev_pm_opp_set_rate()/OPP lookup.
+ */
+int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
+		       bool scale_up, unsigned int flags)
+{
+	int ret;
+	unsigned long ice_freq = target_freq;
+	struct dev_pm_opp *opp;
+
+	if (!ice->has_opp)
+		return -EOPNOTSUPP;
+
+	/* Clamp the freq to max if target_freq is beyond supported frequencies */
+	if (ice->max_freq && target_freq >= ice->max_freq) {
+		ice_freq = ice->max_freq;
+		goto scale_clock;
+	}
+
+	/* Clamp the freq to min if target_freq is below supported frequencies */
+	if (ice->min_freq && target_freq <= ice->min_freq) {
+		ice_freq = ice->min_freq;
+		goto scale_clock;
+	}
+
+	switch (flags) {
+	case ICE_CLOCK_ROUND_CEIL:
+		opp = dev_pm_opp_find_freq_ceil_indexed(ice->dev, &ice_freq, 0);
+		break;
+	case ICE_CLOCK_ROUND_FLOOR:
+		opp = dev_pm_opp_find_freq_floor_indexed(ice->dev, &ice_freq, 0);
+		break;
+	default:
+		if (scale_up)
+			opp = dev_pm_opp_find_freq_ceil_indexed(ice->dev, &ice_freq, 0);
+		else
+			opp = dev_pm_opp_find_freq_floor_indexed(ice->dev, &ice_freq, 0);
+		break;
+	}
+
+	if (IS_ERR(opp))
+		return -EINVAL;
+	dev_pm_opp_put(opp);
+
+scale_clock:
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
+	struct dev_pm_opp *opp;
+	int err;
+	unsigned long rate;
 
 	if (!qcom_scm_is_available())
 		return ERR_PTR(-EPROBE_DEFER);
@@ -584,6 +668,48 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
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
+	if (engine->has_opp) {
+		/* Find the ICE core clock min frequency */
+		rate = 0;
+		opp = dev_pm_opp_find_freq_ceil_indexed(dev, &rate, 0);
+		if (IS_ERR(opp)) {
+			dev_warn(dev, "Unable to find ICE core clock min freq\n");
+		} else {
+			engine->min_freq = rate;
+			dev_pm_opp_put(opp);
+		}
+
+		/* Find the ICE core clock max frequency */
+		rate = ULONG_MAX;
+		opp = dev_pm_opp_find_freq_floor_indexed(dev, &rate, 0);
+		if (IS_ERR(opp)) {
+			dev_warn(dev, "Unable to find ICE core clock max freq\n");
+		} else {
+			engine->max_freq = rate;
+			dev_pm_opp_put(opp);
+		}
+	}
+
+	engine->core_clk_freq = clk_get_rate(engine->core_clk);
 	if (!qcom_ice_check_supported(engine))
 		return ERR_PTR(-EOPNOTSUPP);
 
@@ -628,7 +754,7 @@ static struct qcom_ice *of_qcom_ice_get(struct device *dev)
 			return ERR_CAST(base);
 
 		/* create ICE instance using consumer dev */
-		return qcom_ice_create(&pdev->dev, base);
+		return qcom_ice_create(&pdev->dev, base, true);
 	}
 
 	/*
@@ -725,7 +851,7 @@ static int qcom_ice_probe(struct platform_device *pdev)
 		return PTR_ERR(base);
 	}
 
-	engine = qcom_ice_create(&pdev->dev, base);
+	engine = qcom_ice_create(&pdev->dev, base, false);
 	if (IS_ERR(engine))
 		return PTR_ERR(engine);
 
diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
index 4bee553f0a59d86ec6ce20f7c7b4bce28a706415..055edf3a704ff25a608a880cf9be35363f8a02d3 100644
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
+		       bool scale_up, unsigned int flags);
 
 #endif /* __QCOM_ICE_H__ */

-- 
2.34.1

