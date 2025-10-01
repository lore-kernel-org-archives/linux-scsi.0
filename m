Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE2F2D1319
	for <linux-scsi@vger.kernel.org>; Wed,  1 Oct 2025 11:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759318713; cv=none; b=iEtkJWd8uk3L66cALaEKd+CR/efP/1KVZLyIh3Q3+jc9hM6wwmnQH3ZMLfPm3VS8dpLeVkA3RmnKF901R1SJy1FDNfKIBQhjb7IL+1eJcxQvUdV/z8iAAbrlGk94c0m3sJlfnlNvSIlwXN6Nq8X3LzixsKZJbrQEmaziuLskCik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759318713; c=relaxed/simple;
	bh=9ZvSGMpPGnK7VVXjn6MKbn86JCCr6aXxG/+dB5PGOO8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rWYdhMehTFCC0/icoMr8VXCBMIeu0oGWg9KkdnbVc91Pa+eFqrD/opiRG5uuzEw07tLPdiV/MtGaA67zT1/lvldaoVtGxfiJ6KUojZgBtWLH9bcm3BWp/v7UVUR5Po1tW9Oe41uAXFvjekY8B368T+oU5yJ6BEzL/9+moTGfTuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Gha6A2D2; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Gha6A2D2"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 591ABFXm030619
	for <linux-scsi@vger.kernel.org>; Wed, 1 Oct 2025 11:38:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Lyph5tNp8pQ4OzoN16KiBwnev2tHz7WupW9VSeqcMCo=; b=Gha6A2D2I+g1IyFg
	jQqgjMK1wG2btSNih125oFn3itDPsYxA7RXqadV4U3Ryp/NLNYwf8HWimUsbcD4m
	RnJPYytCEH7c9DgRf7WxoMcCXoqnkSQFq5Z46HwfST9nk4IWIfxRC0nGBkaaqu0+
	7nahJyZOcnchO52gU8cnfESKd4X7HzQdb04adsCKumdypY+P3qy5csndqkQlMMal
	q3PpaYzYIwXZqRrSKEgBag2ygFn0xgygjvCxroLn1ZrYt5oCcXKXIr0zGFv5T7C5
	IXIEexfNq4KW4AByEaqujarV9K40v5pWh2TAb0IphExvmt0hqnE6shi5QdfvsEQI
	pM7KZg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49e8pdm6cj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 01 Oct 2025 11:38:31 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-33428befc08so13868160a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 01 Oct 2025 04:38:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759318710; x=1759923510;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lyph5tNp8pQ4OzoN16KiBwnev2tHz7WupW9VSeqcMCo=;
        b=nTSDGhis8b+HxpBbAUgMacMjaVp3Slz+E4Ao583oXR3MGdJohSiVq/i3srZCLCS+5p
         ownPRGsydqEobFM/rGiSOkY2G3xwCnITQHWXtjlFCfmMJewSyfgBg8u/rhm7kioSP2qS
         oUyHPuWvh/GotC+ehuY66dhnPBdysH+FytCTlk5TAfnURsqprDwnT+m1dtsk3bIUr7mj
         z4ut+geJ2OQkNEGTH4ZsZnTzf7leOzOlXybMUlLa2QuV4ZeuAKYTrHEZmmlZ7YfJHK5I
         hN80wFsPbf9rFld7R272bZ9s4TojwAYLBliuGQsyZcGZj+JY9W1LCCvy2Y7dp3EQL1Tz
         KiHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfanJArBeGZW6w04bQtVXtEC+avkLf/W9DxNGzp8qPE/PX7CRcrWMmZR/gjoApMqcmLubYLoCuXE/f@vger.kernel.org
X-Gm-Message-State: AOJu0YxrvdDWj9Azh8XLIwvtmwIO55KvycZN2lvWxm5vAMgwiGlFj138
	5giUbWTfPnAK4n08/dyJUg9sbmXrShCbzsRR+HMjHiGttMiaNYYFk6lAco+sQCUnOKDVqnM9wOl
	1lp/A2z6x60RoxwKmfWJ5t4FQJvrEwNqIktDGR/ZsAK2swP+UutkSbVlUZPt5KzRb
X-Gm-Gg: ASbGncsiSgFgvx/6014VMYqiLtntozS0UiXqnS0kIQbXfrjdvMp1rUibqSA5VxMvJS4
	bp2yRF7bjFtz+YzCzNz7NXn1fBAbJ69ZaQniOWaldOoFpbzF6is++LN9qLgCEirCOxLGxDjCZ7B
	0QwxGnmDD42jeLRZqDAMFZTwfAVMc6o7BZvc+qszs4hm1BlPL6U/ij25qYDjWBV7aFXYKOR2/K9
	4zWwWWz7TwoWJ7LnJ+sGi+IAUQorPL9z5+yud5ZPJa4PnvwIwl1zMEzptea6XXxHbQtn1TTwdgz
	3RrU+/7iH/y83u3pmQxzCFGKziky0+CAZy2Bu0WYzbXUSwax8m1EfT/uw70Ft281eBrhaDjO1JJ
	VdBZDL3Y=
X-Received: by 2002:a17:90b:1642:b0:32e:a5ae:d00 with SMTP id 98e67ed59e1d1-339a6e75e28mr3163105a91.13.1759318710152;
        Wed, 01 Oct 2025 04:38:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFqVi+dCk7+IbRNgq6QRUG62TTtnWfhtQXxPs6teeYKYZCwjTVOjzt4g+1y74h3nIYVzSFkVA==
X-Received: by 2002:a17:90b:1642:b0:32e:a5ae:d00 with SMTP id 98e67ed59e1d1-339a6e75e28mr3163068a91.13.1759318709604;
        Wed, 01 Oct 2025 04:38:29 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3399ce47d7csm1861646a91.10.2025.10.01.04.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 04:38:29 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Wed, 01 Oct 2025 17:08:19 +0530
Subject: [PATCH 1/2] soc: qcom: ice: enable ICE clock scaling API
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251001-enable-ufs-ice-clock-scaling-v1-1-ec956160b696@oss.qualcomm.com>
References: <20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com>
In-Reply-To: <20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-GUID: tXlrspKM5BBBWLwYCrpzoO5f7S9-6Nue
X-Authority-Analysis: v=2.4 cv=MYZhep/f c=1 sm=1 tr=0 ts=68dd12b7 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=EUspDBNiAAAA:8 a=QjoXURTcySDqg8pLkwcA:9
 a=QEXdDO2ut3YA:10 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: tXlrspKM5BBBWLwYCrpzoO5f7S9-6Nue
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAzNiBTYWx0ZWRfX1C8XtTYqUsfd
 dk5pNtSk4FPhnQyffjd+cfngkwtXCpM2GKWGwVHWAtsxYu8vE/heDPSmJeTha3SeSTy0zODBBu5
 BbIGBh5YjERoTAvuXd0ihBUeAJ+pFYulzbl9IFQ/IditeS7uEVps2fT7vJgMT/tsd+GkOSlMhl/
 ZvH9QCHb+jXklt+fx2WQO+1yHTeAz5Y/XT4qc09GMtC9Lo2zJB5elhOqD66g8Mp6GVIk0ibGH1f
 LM9975oR6x4XMGLsQlBfyKinjNkHCiiKy3YHwGjEJhOfreuI1LvWafHubwQMv6b54mszNcmvPXq
 AEazOSChdGN8GLCrlHAAjP56+LE+/B/bARZEqculUbNHKAYG4GrigUwfHx1uhZrrNBZysy74WnF
 89Kmlhv+rNolyAHPl7cQUQ+4Od9+OQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_03,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2509150000
 definitions=main-2509270036

Add ICE clock scaling API based on the parsed clk supported
frequencies from dt entry.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 25 +++++++++++++++++++++++++
 include/soc/qcom/ice.h |  1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index c467b55b41744ebec0680f5112cc4bb1ba00c513..ec8d6bb9f426deee1038616282176bfc8e5b9ec1 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -97,6 +97,8 @@ struct qcom_ice {
 	struct clk *core_clk;
 	bool use_hwkm;
 	bool hwkm_init_complete;
+	u32 max_freq;
+	u32 min_freq;
 };
 
 static bool qcom_ice_check_supported(struct qcom_ice *ice)
@@ -514,10 +516,25 @@ int qcom_ice_import_key(struct qcom_ice *ice,
 }
 EXPORT_SYMBOL_GPL(qcom_ice_import_key);
 
+int qcom_ice_scale_clk(struct qcom_ice *ice, bool scale_up)
+{
+	int ret = 0;
+
+	if (scale_up && ice->max_freq)
+		ret = clk_set_rate(ice->core_clk, ice->max_freq);
+	else if (!scale_up && ice->min_freq)
+		ret = clk_set_rate(ice->core_clk, ice->min_freq);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_scale_clk);
+
 static struct qcom_ice *qcom_ice_create(struct device *dev,
 					void __iomem *base)
 {
 	struct qcom_ice *engine;
+	const __be32 *prop;
+	int len;
 
 	if (!qcom_scm_is_available())
 		return ERR_PTR(-EPROBE_DEFER);
@@ -549,6 +566,14 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 	if (IS_ERR(engine->core_clk))
 		return ERR_CAST(engine->core_clk);
 
+	prop = of_get_property(dev->of_node, "freq-table-hz", &len);
+	if (!prop || len < 2 * sizeof(uint32_t)) {
+		dev_err(dev, "Freq-hz property not found or invalid length\n");
+	} else {
+		engine->min_freq = be32_to_cpu(prop[0]);
+		engine->max_freq = be32_to_cpu(prop[1]);
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

