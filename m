Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7581337BAA
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 08:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769590022; cv=none; b=ptAyL6LZHYGPHOqAPoEEsu8tsZZgg2/okaDzs9ztPqRKn2CgflY0obrdVzrdo/otw9YrDZfvTFtKvXf3p9iMmLdx7Pp+fx0y1Fk5Welhb/YgIpULg7iioKeih29j8GYUEB1Cr/SvhSZGiXK9/LMYzWUx8UkMSCuUnhY9CI2EEFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769590022; c=relaxed/simple;
	bh=hRvuZIYdhDUVRkdEwKu638nsg/O+JUIyZupt/R4wHoc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AiWNntm3wYClHs+WqiQj+ZNujYU5k0PImuLuGXvzoMDmDu7F2bnG3WKheTzK8h7+RbIsVKZs3BVr8aykXezEa9NoXshVDIFT3e0eLcBnKAfiigWDyixwGq4UZL5WqHbbXIV4dgG/BHifGu+IOH4ln2KzQ8059NhWZL2L69kNPUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=R6gPKJWT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TwDcf+oX; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="R6gPKJWT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TwDcf+oX"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60S53oXk3353088
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 08:47:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	VV5bXW4Tit8T6WjDr8B3O4bogH/N0WdtjKHvAWV26dw=; b=R6gPKJWTgoAi0QjA
	Zx8Zi92qzw5kQ4/NC+8IToez2uTIJpnaoPEs8MX2B5IjvPoArKGOPen8f9Nd3jND
	5TLb0vNDLE3X5YfTQE+jekM+lxs/XlIl4c0GpQOlvvDr9VsqDhvQhaAXF92LkfJ0
	BdKMC+SVXUbLxBPbKlbZr4H6afgwJUurrKSc+KBq3hXvccrwqIajFXwoNTg4ESEX
	UUkvZgoDNFO+5By2Lqrpcg5SW4Sq4MruEcp6k9b2bNPDzSlHCPa63qKQwicoLuVk
	VSk5dmok1PIm+OhVASXHmMS3g2uVP3XOTT0QiiROzEH1/slRaZrp4HUl5kpSmgEN
	PGgiaw==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bybyv0npx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 08:46:59 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a13be531b2so66673765ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 00:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769590018; x=1770194818; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VV5bXW4Tit8T6WjDr8B3O4bogH/N0WdtjKHvAWV26dw=;
        b=TwDcf+oXxmmEo6w8OAK+yQoUlE2V+XzEJ32/2fPNbr2qTRBq3/9HN/0cLSPIDPWP5Z
         3LOxMAcPjt4KtOGgO4rnqPtWWM0Rupro84pPpdQ6Y70X77auDypBRUWdboxgbAF8Twmn
         1pvY6kYQT2z7fS6HB7Fn1IyrfiMi2Ftd5ghl3yHjFnZZx9ylgfh9aJHU8J2reaVN2l02
         ILdcONE1NkeJDJa549vXU/3UeUUCc7NkPK6u0JeCnDCydzlKWG8Z8Dw7B10skyss9A8t
         7T9Z+xWrnxjBenLQ/mPQH+n2yc4IFiOjWPcNOhuI7ELZr5BX5bWLsIC6LSM+KOc5R+1h
         9WzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769590018; x=1770194818;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VV5bXW4Tit8T6WjDr8B3O4bogH/N0WdtjKHvAWV26dw=;
        b=Ull2fKoyjJafeGCOM2Z29TKL3NU39R4nR69IjYAmJGYVVtC0oM/FU8U26tqg47R0je
         PnNBTRlomNMHkXDuZnBXGLz4pu9Dwpci37xykE/cPhvAOxR+HlyOYM5R0udVrVlDUKYE
         SmFY7L7tBwWcIEawU80EOrHLZeJ0H/QdBFw6k7kei1tKV8VE+bLo4mRs6aGuS9ak+fYL
         xuhbJ/xmEOlr94PgyO3QhtPW24e7xf2lmmT21DSC7u+WmJx6IXiE0emPb3VlNe6S+1Gm
         bVJl5C+x460agvOZ7r/w6kGZhgd+f+K+WTWo7L3Z/uQlLWK2ujppkGesTzMY22lcIgXa
         JNuw==
X-Forwarded-Encrypted: i=1; AJvYcCVVevJEM3VoSumUuTygK6E2xRsqTcKuSyZZYSf89M+NRfiVi+/eCEOONzSVn06UEm6FqYoH5h5SZ6NQ@vger.kernel.org
X-Gm-Message-State: AOJu0YyPpIEAigNhF8+3uoWpxEoDc9NmMpk7nqvso7KYJNgri4vEuZPp
	tuKf1C8JMS2rrpIj4WclKbiXNwjVGydqAhe/tdigvB1q6Z3KuBSkJti3XP3BlJsxSq35NMxH9HW
	WtxzHyDvPJYw9Unvuu6WPp70pa8hKYd7PU8XU78w1HKx0KlS6J2v+wutRHeo5HQRK
X-Gm-Gg: AZuq6aJX2wEJb4vVucB1it8sgpdEFYczse4qQoyumflSAOASb20cca9cSRHpfKnzIR0
	H//nM1DlOYqgIRout605W2tjsLZF9kkmEZ2uOo1kEpVT60olAnjK2Mab/vZOoA0q4frd57RFskg
	xmOYRZGRtTNMoS052g7bvyCcmdk4DPOiy4M3CQJ4jVF/wzPpS/HMpRCbaQI/3WBlPMilEcRWMoF
	Y/2Ca9qmA6dvP1pXj+aLjjl+dFEPYKp3TnLi8xNxiPiRdgxOm0NxanEvbg3upkHHoYesTx0dwZz
	jY4kaYhrNvE0jz9L0MVtHv3FI9KDQC5T2PQEsLo3TXNnlLk9qbkeWdK9nFprVu2aJoP0tnA8JOC
	bfW6szfSzDFd5lGGFDmHv7I9X4GNepfsJlbUp1hvHD6fWMpI=
X-Received: by 2002:a17:902:f603:b0:2a2:f0cd:4351 with SMTP id d9443c01a7336-2a870ddebf9mr44086385ad.37.1769590018338;
        Wed, 28 Jan 2026 00:46:58 -0800 (PST)
X-Received: by 2002:a17:902:f603:b0:2a2:f0cd:4351 with SMTP id d9443c01a7336-2a870ddebf9mr44085955ad.37.1769590017710;
        Wed, 28 Jan 2026 00:46:57 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b4c3b1esm16263075ad.63.2026.01.28.00.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 00:46:57 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Wed, 28 Jan 2026 14:16:41 +0530
Subject: [PATCH v4 2/4] soc: qcom: ice: Add OPP-based clock scaling support
 for ICE
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-enable-ufs-ice-clock-scaling-v4-2-260141e8fce6@oss.qualcomm.com>
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
In-Reply-To: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
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
X-Proofpoint-GUID: 8oY1A_mzMxPrf6MGFf4OCcVkKIgolJcY
X-Authority-Analysis: v=2.4 cv=ZZ4Q98VA c=1 sm=1 tr=0 ts=6979cd03 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=7Xpflpev5xBMPMNHqgAA:9
 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI4MDA3MCBTYWx0ZWRfXxYC+/Ovd2fh2
 0F3+zaiLHqOIjzFVHslzppLW7CBChOK3cZyWa0wANGq6GbsSYxisRH5/19SjaqPKi6dpyduIVvW
 Q3oQ+QJE3j/ndsU8Sj9/nxZ1EFZ3vpXxivEN9JfxVW183eSKnH5Fi+vBA0PgqQJL05N3bCCWjFx
 Nuvbz+f1X+pD9S8XqkrJkNUIwQTae8qyKiAAH0xt+PSz0GGyQ2nUF1VMa/7rtIEtT7uSBNVeQN9
 StXnuKd4axZ9rJsEPzuMx/neQyFn/Hp9wdoqkss40mI3WLOwMB+lFIOKVmgJ+wzTYmwFAG61Yca
 W2h64NzjRrIW35Vf8jkzn8BW4TUdg2ft73IiyPJotTP5dC2znUnbz55BtZmtTc50DfldjCk+7Y8
 pTuTSSy9zn6Anr6P+Gct4SCj6MDICNY/cKxi9TW4ZdK41ndX5lo7K1TUPapXx49L1GkczDhXBnN
 K1yOpAB8rw5BH+OS9hw==
X-Proofpoint-ORIG-GUID: 8oY1A_mzMxPrf6MGFf4OCcVkKIgolJcY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-28_01,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601280070

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

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 107 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/soc/qcom/ice.h |   5 +++
 2 files changed, 112 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index b203bc685cadd21d6f96eb1799963a13db4b2b72..90106186c15e644527fdf75a186a2e8adeb299a3 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -16,6 +16,7 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
+#include <linux/pm_opp.h>
 
 #include <linux/firmware/qcom/qcom_scm.h>
 
@@ -111,6 +112,9 @@ struct qcom_ice {
 	bool use_hwkm;
 	bool hwkm_init_complete;
 	u8 hwkm_version;
+	unsigned long max_freq;
+	unsigned long min_freq;
+	bool has_opp;
 };
 
 static bool qcom_ice_check_supported(struct qcom_ice *ice)
@@ -549,10 +553,73 @@ int qcom_ice_import_key(struct qcom_ice *ice,
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
+	return dev_pm_opp_set_rate(ice->dev, ice_freq);
+}
+EXPORT_SYMBOL_GPL(qcom_ice_scale_clk);
+
 static struct qcom_ice *qcom_ice_create(struct device *dev,
 					void __iomem *base)
 {
 	struct qcom_ice *engine;
+	struct dev_pm_opp *opp;
+	int err;
+	unsigned long rate;
 
 	if (!qcom_scm_is_available())
 		return ERR_PTR(-EPROBE_DEFER);
@@ -584,6 +651,46 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 	if (IS_ERR(engine->core_clk))
 		return ERR_CAST(engine->core_clk);
 
+	/* Register the OPP table only when ICE is described as a standalone
+	 * device node. Older platforms place ICE inside the storage controller
+	 * node, so they don't need an OPP table here, as they are handled in
+	 * storage controller.
+	 */
+	if (of_device_is_compatible(dev->of_node, "qcom,inline-crypto-engine")) {
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
 	if (!qcom_ice_check_supported(engine))
 		return ERR_PTR(-EOPNOTSUPP);
 
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

