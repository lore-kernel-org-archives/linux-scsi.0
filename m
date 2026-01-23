Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBED3563F6
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 07:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769152354; cv=none; b=m73CTAL8K3GTRx4UvNFbUeqOd/Df8RBAvlZun0skrxReTq/LF/hKugrw02XM2dQdInHq/qyWmezeqIxOM0SjcPtoIO7JIAG63zEqYIgmEgSCOJLWqyW4aJD75UEtm2dAyGVd8dICKSSL7rUtBiMevH3L8n3B3u3yV0p/67253Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769152354; c=relaxed/simple;
	bh=mbeGn668zLrH+yppQKFVMkx9Lnc+kerz8T6Sa+p3VVE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WylyrRWmdpYaVPSaN+fgVj/ZjjxUkZpCpJ6BFhAKjc0H0WP2kq04LKi6MOcpDnfRaD0VVXBsHZV9ZbFYyZOOmY0S+GIHcjEYPURtHIiSzTITYj49Gy8AuhDdMgxxW+XJHpsEXIypykIsuBWgCDXKyTeCf9w+sIr7ByqCdID8Mro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aMKqNoO/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=afG1Qjdv; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aMKqNoO/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="afG1Qjdv"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N5naxe3704248
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 07:12:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	x4MzyUwxeUkU22EMG4YtRil/j6K8vfk+OPjmGCpuy44=; b=aMKqNoO/C/HEOlOO
	Senw/1zS0OIt/Iv4+hKtu6LNSLlhXanH2STZBgdPARsv5idu9z/p9IdSwwPc3kpQ
	sRxdn2IEgnxo4uvJZmHeQAFcmAdH5dws99yaJuQZcUJLmhdBHGW/vnniyi6AKl0J
	L5ZgDSGCKMXFcZ9a+rFjvc7CzHL8NRHBcyUvYH0V01+YL09WScJY9HxKCCEkwXtc
	4OA0lx5bgSZf//rGpFvE2RmTQ1+zceRx6maCNYIoaxut/Y5upTXmEIKvGvs8BpKX
	qaGTRsPu/RKKsuWK7bq0jpQJbS+KGm8gLtCwDW8iJ9zrVNTJbY1VyKTRZo+BVqGd
	j6YnHg==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4buuaysqm3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 07:12:32 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a0f4822f77so39297525ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2026 23:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769152351; x=1769757151; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x4MzyUwxeUkU22EMG4YtRil/j6K8vfk+OPjmGCpuy44=;
        b=afG1Qjdv0npekoKySCv0Hk6TRED/JwdqozfZ7cxMoAvF6J8nd3D5Chho++BXSWKnY0
         yqs6+L5Sd0OmEap2uUD80TEIxX8INidxr9U6MK5Io1yyBGN5GQJbPuzlJH2rxVbXgfd2
         ybArAH/u1P2d0eWk/BrHfqwFaVrav+rGWbelwch3ilys5cArZqXRtye61HH1L8rAxwCi
         yb2E6KZ3fVS0QqO8yEfS+hTctIo4S1IbdHMOrZLYKe6wSvcDbZSjg11qJhHI6jYqFCfy
         lPOESmYrSMoVEPgs4I+xW58cxIr+v+LMuxYTrhi+Ad5LmrcMMkdu0kHlT82pr/HSfv3V
         2C7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769152351; x=1769757151;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=x4MzyUwxeUkU22EMG4YtRil/j6K8vfk+OPjmGCpuy44=;
        b=WR+O0P/s/hgSg/UZFi0iSapa55P7IEQFKfNAHy2JRYOoRYRFMdynSqjs7WRxgtRQie
         sFTu7pnULwjoi5o3zNmYxnPUwPfIytbv6SOrLPZ+JrZUNVXadQO987/qkigyUm5idsRY
         q2Xto46YirIPz0ugwL0kyRRu7eC+f+t1xE+MDkGNphKY/9wlFkKHt7ZuGECyD+V//yXn
         /qQBgzd0Wy6SMRR62qt62pLMyEEjWgt+BlWMyEgkM4to0qZyOuXzhwuNiZQrcWqANsPq
         Tlht/U5ny+UDMrTxkNfRahCl3BmTgDBCqZTTpJYp/JCkeLZxdrLVOP0HrBtyU6m5UreN
         B34g==
X-Forwarded-Encrypted: i=1; AJvYcCUTiDFqWqtOCXX/nmOG5mbNrfAFLpBoVzBNkxmZTSRLq1rKhlrYEA86r8Mv1yIlMT970i/urI/jJrO1@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+4OOUyWpQ9UhnqTGKlYZ2b+m2Jqzm6DkWs9ILCj43wFgg2Nqv
	XKpI74ZEx6yKx4VXLEDlNehNgcwJzqCBYGyPwP2P08agJXo12EyOFVFnvT53NQy3SRDbUp5CE7f
	aoH1lv1pewZ4TLvx7hMAvzZIsR8KZln0X5PMn8dcGdFEvbqQ/MqnRqkm3HSWUfJN0
X-Gm-Gg: AZuq6aJ6PIU3pSttHaBB0nAnx5W7t/N227KZfEIDBu3TgjZASVYZ0P2ybaBNHzZhvZt
	63U9wj3pD2fsvcraHXOrVJxbFDw1Sav/3MVwBCHEC5a/pbkqLjiaiHrBVgM0/eoab4dyTHIIPbP
	6JMheYi3K818lXj8qavZJP1cK77Me0vmH50h3VAgJpqzHeuyUvvzC1uUfuhbGw5KIYvcbYGRgVe
	VqvI9mHhLyO45y8ENsiN2HLW+QckUTWPBbVseb0LSFg/VetLDiX+uLPKKLC5zPjNVdQoAhVdp7m
	ngDeZE0Jo57Do3SO+IAEAku5oOTGs2QgCAkSNh4tDS7K5GualYv3rApeP4L6DnMwVW2FSnDwnT7
	A3osQSBIRWbCQYdGPuaYcm3fDEx5cvQODFxl/80C5Mg589qM=
X-Received: by 2002:a17:902:f651:b0:2a0:d33d:a8f0 with SMTP id d9443c01a7336-2a7fe74e57cmr17004505ad.50.1769152351390;
        Thu, 22 Jan 2026 23:12:31 -0800 (PST)
X-Received: by 2002:a17:902:f651:b0:2a0:d33d:a8f0 with SMTP id d9443c01a7336-2a7fe74e57cmr17004265ad.50.1769152350872;
        Thu, 22 Jan 2026 23:12:30 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802f978e0sm11336775ad.62.2026.01.22.23.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 23:12:30 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Fri, 23 Jan 2026 12:42:12 +0530
Subject: [PATCH v3 1/3] soc: qcom: ice: Add OPP-based clock scaling support
 for ICE
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-enable-ufs-ice-clock-scaling-v3-1-d0d8532abd98@oss.qualcomm.com>
References: <20260123-enable-ufs-ice-clock-scaling-v3-0-d0d8532abd98@oss.qualcomm.com>
In-Reply-To: <20260123-enable-ufs-ice-clock-scaling-v3-0-d0d8532abd98@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=GP4F0+NK c=1 sm=1 tr=0 ts=69731f60 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=GaBF8cNdLVowMAKyZsMA:9
 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: ES_5pZg7xUKB7Yz2i23_0l_UZpDnBbVA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDA1NCBTYWx0ZWRfX+k5mztRjgtnO
 Ji2Kj+LUog+dD/ywRI86bs+ZT2pKjYeeSLEzzkgGjU7uaTySs4RK6qVxJlivZ4QxqJC4QRIG48L
 d3Fb3g0WWnGfQ7qgB5Gp7RMc8JYI1D8fmId3SGmyb45XxFOljJ0w9y/YE7aTYt9OCsiQKKGbFmI
 GxO6dz3tmyeQo7BF9FWr1tjmEQVmZ3/to4yk9ghMddHu1NINamWrCb1q3GAgED7/szVG34K2gIC
 un31aq6zJIPnXnyyFDoh0esoe0qE4P1WBYThRs3ZJBo4fN7SedaM1h2fVBZpKIP3ii6L3LMqXW4
 O2pQgF7g3VG/ORa8z7I2p2gKAC2k5n0Q0qua5WE+GKbWWBZX3FNzssYe48qW6vIQRlulrQYsemC
 etItMKGWv80bw4vtjRS+M/9mOIBtZVwjRggAC9EYX6YL3bkj0PhWH8nqekZOiDswG1bDYjBuZUN
 6UWtQD7xdObBGWlC0KA==
X-Proofpoint-GUID: ES_5pZg7xUKB7Yz2i23_0l_UZpDnBbVA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_06,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601230054

Register optional operation-points-v2 table for ICE device
and aquire its minimum and maximum frequency during ICE
device probe.

Introduce clock scaling API qcom_ice_scale_clk which scale ICE
core clock if valid (non-zero) frequencies are obtained from
OPP-table. Disable clock scaling if OPP-table is not registered.

When an ICE-device specific OPP table is available, use the PM OPP
framework to manage frequency scaling and maintain proper power-domain
constraints.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/soc/qcom/ice.h |  1 +
 2 files changed, 64 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index b203bc685cadd21d6f96eb1799963a13db4b2b72..ca6a7df7a6827378af1f013c7e62a835d1b80cc5 100644
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
@@ -549,10 +553,29 @@ int qcom_ice_import_key(struct qcom_ice *ice,
 }
 EXPORT_SYMBOL_GPL(qcom_ice_import_key);
 
+int qcom_ice_scale_clk(struct qcom_ice *ice, bool scale_up)
+{
+	int ret = 0;
+
+	if (!ice->has_opp)
+		return ret;
+
+	if (scale_up && ice->max_freq)
+		ret = dev_pm_opp_set_rate(ice->dev, ice->max_freq);
+	else if (!scale_up && ice->min_freq)
+		ret = dev_pm_opp_set_rate(ice->dev, ice->min_freq);
+
+	return ret;
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
@@ -584,6 +607,46 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
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

