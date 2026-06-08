Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473BE3B0AE2
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jun 2026 21:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780955329; cv=none; b=SS2y7xYmbo6Nyle9YpWBIfDzdgUUQzPU3uWiPwKo6B83z0j2xfkQ4LvkCTqN2Sy+dF60TXsT4ST6wqFbOdkrZzJhzQfea3l5I1Q9S7H4bAc4UvIGxfKoFwNi99h4SfKGK7XryN3UP4sDiWGd3jC8n7zGn5WzPY9oq5ftYX4kee0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780955329; c=relaxed/simple;
	bh=3w4W63xsG2++dPCs7ogqk5Rw8JmFxMFLrWxtVoquP6U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=r+MljvmtBY/MDIn5Boc9C59rKlRenummnBCnFFrkUx4DZ3OoPA3eUuBFhpMqtEGBB4TDgQayBIB9PoDDPwZpOObP+D2xDfAcD6oCJfLGwaJkPH+GrWrgbTrhK8xmb+9osOXLv7aiVh1xCukeBqyuvKo2OcB1jjl7HcZsoG97jf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kkGUOKQu; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Pn+75K+Y; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kkGUOKQu";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Pn+75K+Y"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658Ix4L8327872
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2026 21:48:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	b/5zy6XbjJJB6n/FuzDKwDIAc3x2b9RV3asGSb1UkAE=; b=kkGUOKQusDaiFbnM
	QF4S3K/wASQ9PrY9YNt9NatG4BG2lIEOKVzVfoiUkt0gkyOBFOT9Uldu3E5fhWHM
	p/zL4oabam9WBmSvVUBw6XYidqwbn5pNRF24opLrbN6LDP+o9zBxgJKTuv2GBbcx
	2hunvWl9Uq7YO6XpzyXOe32NjxpCXFGzq7hi9zzxWwOoGWrF3QvGOh63FgCXtNR2
	DUng7WWzpZCqFKo8Cxq5IRGzDiUMvVcJrD6etqwqK+fiKBbZoDJQyyn/dxHy3GDJ
	NoJNQ+hHIyt3e03W7Ru121Z5/bygUrT+Uu34NmJUVrk4Ov8mjxkpEvlKi4626OXc
	lTm5WQ==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4enun8k3j0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 08 Jun 2026 21:48:47 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c85798977dcso2955288a12.0
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jun 2026 14:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780955326; x=1781560126; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b/5zy6XbjJJB6n/FuzDKwDIAc3x2b9RV3asGSb1UkAE=;
        b=Pn+75K+YXPc+XVrgMrrhf4l7Mh4zasX3CldWqHY+cbSyAdjaZ6RYr4BMXl4n1SVtox
         DZxJHoV6N8hvbDYNhyMdEnDdYxroJ9K/dQXRKcoV8kuC+3hwxtiAE+/TAC0qxQzjjUe2
         MjMJ7+P/zK88mtr9jJk6Aj8j9yKAfszrU/jyPCblHQTcbF1mXJU6WjtV7gwdv4f6xaqC
         9+chHvfmJGUhOuplGGh90Zrx4b+nEK7wAXHfa3bYTgMJ6lfhe5+1gYtbO2LhsZuEybuO
         EK8j9tnuQrZ9tMjMZe89gLMYCRebsedxcHsu7v3LEC/CfmGAF9xT0Lsbqc7hcXHVqBbL
         5BWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780955326; x=1781560126;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b/5zy6XbjJJB6n/FuzDKwDIAc3x2b9RV3asGSb1UkAE=;
        b=SBKRJhCy/vVS+KSsKBRuqQ7hfzeRoXjNmv4kfslBylHK9CruSGJkjsi3ndL/WE17WH
         AY/04EOYc03+XIBiOJmx763S3QLlaFnF8IPVE7iLLFUnPj1Ri/OZP6kkXN8gmKIFUmWt
         Y691jkVu6ZjWkIeq6z96s6dzTKFGwZ14r0VFSWKIfhKgcNyqI7xQO1Y3xywyAV7vT8a8
         7+A02/sOy9aRbpq6whCmXjejBZygPqDnfZb33Iit9fnpZrLgcvdbEVsLacccWyFTpJVD
         3+lBdYhlYyYzc//t8tiaIl9tDJe2SAalCROtL4B6Td1Wa+aBhGoEccqOBRRDrJRvLYxi
         t2iQ==
X-Forwarded-Encrypted: i=1; AFNElJ8V3DXXwIGPdcCuPVgDRFRWun7uKpbBRA1xhG+GMxwiXo2EK5rW+c/o6oIddPMHdMc2xmWHJaPzyo0v@vger.kernel.org
X-Gm-Message-State: AOJu0YyZXOi4fi/Q+PLoab/w+XtVAeFw7xq22nAvGpxhcM5KFmpl/I/x
	IkfGHXiPP7tC0Bov6LagYTWQQxJi691Dk2ICcu1LqcfaKciha/3Igjl8Y/GWLe6V0ZvX9qKl1Cx
	yn5GRo2zAEHbF3z6IYZlV0X8Np8xOgc47NWSIqURUwe95p9rmfwM4LEZPhI1NOHiv
X-Gm-Gg: Acq92OGSc/77Qj9vGaxBLorvOx00cVgf6BevFKvyiU4336RyBEJW1rsZd0Lx1Lr6pgx
	ngCoHp8uOf9EPapj8UdJrvvR1A7oRtImRLSZcoCzbyNoOhfh4tbmRsxQEixdLUDzAvTtt8egv0T
	1S2vhgcHWX4Hlec4GKaiDa7Q/nE149uhotl6aCvYU/NO3/WA0f5tjszoLd7h6uVUIHiwfC5tO9t
	MWxuecPw5pABOD4WEBzRAdedJbSeEsojT3ddyzD8COwLkOOj5Pe9wLAoWNVBDFTy3rKd09GcbWd
	VoEuvrxlkDaz9llEZv1/U59IIjId6JupPQ2IfmD83ynEJz/Z9aeu1M9261s/dRM5iWH+4hpUobk
	p8+rdi/HzEb58n3zQTXznFd0D17iD5LJizlrcn+uXeSDqDeWLy3u1Zt9HNyon4Ft5RkCBnQ==
X-Received: by 2002:a05:6a00:32c7:b0:842:422b:259f with SMTP id d2e1a72fcca58-842b0e30c6dmr15595682b3a.10.1780955326095;
        Mon, 08 Jun 2026 14:48:46 -0700 (PDT)
X-Received: by 2002:a05:6a00:32c7:b0:842:422b:259f with SMTP id d2e1a72fcca58-842b0e30c6dmr15595665b3a.10.1780955325533;
        Mon, 08 Jun 2026 14:48:45 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828cf783sm19607485b3a.40.2026.06.08.14.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 14:48:45 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Tue, 09 Jun 2026 03:17:25 +0530
Subject: [PATCH v11 3/6] mmc: sdhci-msm: Set ICE clk to TURBO at sdhci ICE
 init
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-enable-ice-clock-scaling-v11-3-1cebc8b3275b@oss.qualcomm.com>
References: <20260609-enable-ice-clock-scaling-v11-0-1cebc8b3275b@oss.qualcomm.com>
In-Reply-To: <20260609-enable-ice-clock-scaling-v11-0-1cebc8b3275b@oss.qualcomm.com>
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
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDE5OSBTYWx0ZWRfX1my3VQPUBrhG
 JH5bhjSC4iNa7HlpiMEFcIWF5lmhZRYHY4Pj6EQP1Isr8m0WSMKxgWA3qZPapGwFb6Rj2ir1TrK
 ggqxnyNSKinE0uvc15KMKM98Y2+6Cx9rXOcYuBYQkByi7kFJzZoLCFm2fxTbyPfMzA8iQXS1YlE
 cjbzMUpU34eNFZfUx6Eppl/Hl9ESdFQ/CGsx1lL84TWqvSRYxOaHYEBKcj+2LPIXIph1yGbRWT8
 VJo0114Ym1J7OFjizxl21SM4Pu0sUiVnK1UKOD01C8pfofCZlMby6oF9YjGyQnnMeylW6mzWLmk
 DlJaOVPgD/MyDS8jCvjf7dkqHvmH/6dhz+NLMfm2UBJ//wMnMmPRdbDO/lDEVfBz+0Or+0jVmXs
 nyN3A1EyF7DcG+9px4V6snCnPPIhD5/aDuslEwa5Ze+u/CQwSEdUnoQ3l/hYO+liOpyBCJsVugE
 j24Kbf7G+QAf4+uEJ4Q==
X-Proofpoint-ORIG-GUID: GdArrWrAuNJsGiU11f3OnAKP-UjaL3MV
X-Proofpoint-GUID: GdArrWrAuNJsGiU11f3OnAKP-UjaL3MV
X-Authority-Analysis: v=2.4 cv=Z7rc2nRA c=1 sm=1 tr=0 ts=6a2738bf cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=QyXUC8HyAAAA:8 a=PzEurhthzZq-M9kHIYIA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_05,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606080199

MMC controller lacks a clock scaling mechanism, unlike the UFS
controller. By default, the MMC controller is set to TURBO mode
during probe, but the ICE clock remains at XO frequency,
leading to read/write performance degradation on eMMC.

To address this, set the ICE clock to TURBO during sdhci_msm_ice_init
to align it with the controller clock. This ensures consistent
performance and avoids mismatches between the controller
and ICE clock frequencies.

For platforms where ICE is represented as a separate device,
use the OPP framework to vote for TURBO mode, maintaining
proper voltage and power domain constraints.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/mmc/host/sdhci-msm.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 0882ce74e0c9bdddd98341a67b97bcef74078e0c..b655bcb5b90c0677bbe3dc6140de488038fe5ee8 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1901,6 +1901,8 @@ static void sdhci_msm_set_clock(struct sdhci_host *host, unsigned int clock)
 #ifdef CONFIG_MMC_CRYPTO
 
 static const struct blk_crypto_ll_ops sdhci_msm_crypto_ops; /* forward decl */
+static int sdhci_msm_ice_scale_clk(struct sdhci_msm_host *msm_host, unsigned long target_freq,
+				   bool round_ceil); /* forward decl */
 
 static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 			      struct cqhci_host *cq_host)
@@ -1959,6 +1961,11 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 	}
 
 	mmc->caps2 |= MMC_CAP2_CRYPTO;
+
+	err = sdhci_msm_ice_scale_clk(msm_host, ULONG_MAX, false);
+	if (err && err != -EOPNOTSUPP)
+		dev_warn(dev, "Unable to boost ICE clock to TURBO\n");
+
 	return 0;
 }
 
@@ -1984,6 +1991,16 @@ static int sdhci_msm_ice_suspend(struct sdhci_msm_host *msm_host)
 	return 0;
 }
 
+static int sdhci_msm_ice_scale_clk(struct sdhci_msm_host *msm_host,
+				   unsigned long target_freq,
+				   bool round_ceil)
+{
+	if (msm_host->mmc->caps2 & MMC_CAP2_CRYPTO)
+		return qcom_ice_scale_clk(msm_host->ice, target_freq, round_ceil);
+
+	return 0;
+}
+
 static inline struct sdhci_msm_host *
 sdhci_msm_host_from_crypto_profile(struct blk_crypto_profile *profile)
 {
@@ -2149,6 +2166,13 @@ sdhci_msm_ice_suspend(struct sdhci_msm_host *msm_host)
 {
 	return 0;
 }
+
+static inline int
+sdhci_msm_ice_scale_clk(struct sdhci_msm_host *msm_host, unsigned long target_freq,
+			bool round_ceil)
+{
+	return 0;
+}
 #endif /* !CONFIG_MMC_CRYPTO */
 
 /*****************************************************************************\

-- 
2.34.1

