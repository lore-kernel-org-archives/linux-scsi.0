Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FA933A70D
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 08:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769590017; cv=none; b=nHPhCGPHZewQzzVD2w358CVPYt5z4fOydnEfcINxwxb2cTYhjFIA5blsbImBoo3/hCAtXICXHbbaFqFhclC8A7Rg0iz+QPv/ZUIthobJlI+HZ556v+NK3CfJx8CzL+Xyc7SfdAy8eR88b53FGPGjctGcTNa6w+bBWgyHOMFxYbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769590017; c=relaxed/simple;
	bh=fmj74JXS7b3/5JPwnhbm6Z+ccfNWzkm0zWwsIkb9dMc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JCj427pY7WT0D5rMtqfvmTFaLmwfjldZrIeGlvH5l5p0VhMRnyiINF+RsAd57Y8IP0FWnviqy/dzHVy0L8Ew6dY//7u22jsmXnZ+FUpUNYjj9GJ5IQBg5BBEtie4X569muHIg8AGaugpB85y5qjtLwkBX8+TMt8BozHGTqFjds4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cNxQ5JfG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AdEu4vU8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cNxQ5JfG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AdEu4vU8"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60S53oXj3353088
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 08:46:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yfXxaOd9plb61s8TF4WmKmUfjZnHFbvBpCT+9AAgBMQ=; b=cNxQ5JfGTdFsguwq
	a+yQ6WlBN7RzFzTRD0tCyWzIPX4XOzNr2G9Y4oAvQpogqQ89P/TdJSu97PQ1P8zA
	ZLg3qx6lgKzK50lCuRKoHVnfLgENZbBSlUEzExeR7CX3VZd0Lm7hoXs9PFNvOwbG
	f+IgP9yqMZadQAXgsk0e5vvrZLLwAU1qirkRF+QpZPI6p8MM1SKf57Yvpb6pY48+
	0SPNhno2fW0eIGnrRbjCVcwPFbj7WMUOOrSkizVgIPYdCYrAjk4dAMlDC/wismbs
	aih70PHfzdVQnhGGbUVlkRyZyvOo8LD2xXuv4Cg1LR/MfT65+eDTa4SJMqvPGyoE
	uIpBLA==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bybyv0npp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 08:46:54 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a7a98ba326so11148845ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 00:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769590013; x=1770194813; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yfXxaOd9plb61s8TF4WmKmUfjZnHFbvBpCT+9AAgBMQ=;
        b=AdEu4vU83H6CuuMdwpaVK4nj0g/nkmOA3bDrmNJTOJAJlNZjB5eulSFTbiIjhBdBsV
         IsKGRiJHx+nbZP3dXgUPtbMNK76Jea08gpXIHvTpUlwx9Oo6F9wwQgpR3xHr57HaElOh
         KJ0M5p2e31PWKlH9zTRJlKU1pLZgMLwgNnsvSvRLwbfjoqM7QSi6w/3OxGiYpCahd3pS
         CRD6LiiRJDFKpF5h8AtqAhGJMFOrZqRaj6uANy8zvMKLxasISVFrh6T4XCkHx+FwJ5nb
         NKbe8WIaGYJvWbhNH2ccaR/NHBui/DQ+qk1YmWnL7GS3kV9fJU8y6p5L6GiuOHbcKMu7
         MInQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769590013; x=1770194813;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yfXxaOd9plb61s8TF4WmKmUfjZnHFbvBpCT+9AAgBMQ=;
        b=ScbuZmvdS4039YKW4wZ52hx4R/NhDDNOtbjVV6dceSNUlt8txgYdnpBG1VhHAsj8z8
         nx//obILzEdLLaFz2pyQ9Jx6dhJwEZMJDduZZEII19nU+EyF42JC5oU4ALckhAjNY1jt
         gsNTbko4Wz0EK4GEl15nar6KeWkLxHgPHTZOxsybY5329+zlJFOkvXlxOJ8KT9bFMMlf
         jQezRlt3ryYL4Fl4n2MMO40tWMNKBq02GOiOIFqhXcQ+RAGZz4ptLmN6vV2evMxVeWCe
         pC0QmxeAkodsjygRriY1pe73WY1DlptE90E6V38TFB4nrSyMnus5tr4HQWyxUoFPmTs0
         3X1Q==
X-Forwarded-Encrypted: i=1; AJvYcCX5WOgJxQMsHpxUblSPYEdVijRoJFzbv0Mn0ZEPV5jleuTf1G5ijRxh0aNpZCM8vPn/bX3eZOVvIz8m@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9zLlrd9qFGkyXRipwwv+3kGgVZrakx9d4kjwUxVry1lR2wQtk
	zUndKhg+EAM1Em/OKrZwHnDKFMLoupo45KaJuBJZVTN6NlIiWGDz0aOoqAmgKLua6xxMskPZNIx
	7ZK5Z5/oSEpm41st+YDNE/SWeOttUbl1QL6H8M/+l7vb3E7AnW3H6AMaMRoduZk/c
X-Gm-Gg: AZuq6aKimpX9rjnIDXwasQ+Q4P06UKa3f2aq5gFi8COAAjFScIZ9nh6AcuoH9W3OkSU
	7snsz0gLEqogrnToT7vyI1cW9J4ynlvAC4qOuiv/7iictTTGsidijkFGM05ShybjRmDJxo+hnr6
	kukgfK3ADGqpY8cHZpRVa855HR/u06zzRd3TvECD49gXIHXS5Hf6/JyCVoLWiu/1XYHVLQqs6b2
	bk/V7vGsJ0xzbp/KwRv+QNWsVmeWf9sNAVV4OgVW/ZPV1t+3oE2/WZc6rQ/MJ8rsWyNv+TAGhDz
	Opb1m+Gy495yU2efL2qoC4pfXTH9iHC2IPpTaEVFu27B/7jpr4wy1lO/0PCdUgaYN96eJXXf4Oh
	k/dqKhFPZyc1E1JAAhNCqVQ9PyayGqV37Gxhd++oCWgnRN7w=
X-Received: by 2002:a17:902:e881:b0:2a7:8486:ef13 with SMTP id d9443c01a7336-2a87134ea8fmr48957305ad.29.1769590013393;
        Wed, 28 Jan 2026 00:46:53 -0800 (PST)
X-Received: by 2002:a17:902:e881:b0:2a7:8486:ef13 with SMTP id d9443c01a7336-2a87134ea8fmr48956775ad.29.1769590012783;
        Wed, 28 Jan 2026 00:46:52 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b4c3b1esm16263075ad.63.2026.01.28.00.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 00:46:52 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Wed, 28 Jan 2026 14:16:40 +0530
Subject: [PATCH v4 1/4] dt-bindings: crypto: ice: add operating-points-v2
 property for QCOM ICE
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-enable-ufs-ice-clock-scaling-v4-1-260141e8fce6@oss.qualcomm.com>
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
X-Proofpoint-GUID: WRofSJHJFiCynkpkGdejjWUDMJWAPqZv
X-Authority-Analysis: v=2.4 cv=ZZ4Q98VA c=1 sm=1 tr=0 ts=6979ccfe cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=nchbEs_9QIawOzQC_EQA:9
 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI4MDA3MCBTYWx0ZWRfX0AYzsGE5+Xbp
 naF2i+o56vHJifh6Z/46AgypslTSKSP8Z52+j0X1ZlXut2tdD1vbR+SDG9LOpd51C8GLMzd5Lba
 PB5rnPU5fAHPnkvp5CZPyRHrrNfO59PGB3x2na3p5rvaXxJYrcTogcG73CfgC6Si7mxAXLvp9Sn
 TEW+595UuNdqCZ8Rvb4/8tYpJtWXdq4Q7TotZlzgve+UVvv7iOifgT31hHvVdCvZGnTy8eFw4HN
 w3FCkYQhy9hWK1pkVaaRFXosKPz1crRx3hoHUsN3BloWhMn4VhrG9ZG80GGjulrOFRs2+SOr8ke
 sbCr9z6u0u7T6MZyFl9ZKzR5iKUklQA99tctp7cMbnLTe4V5WbzNIFKg/t/gvMMeheGCLDnO18Z
 Q+mbnCGpC8ReTPfCgkFd0K4+bfUHKbcAfKG7WWwSsPp5YR1mFsxoqhlH37VT8b6k4NoRayQlZOC
 aBwOwfc4rhD+hpJgXhg==
X-Proofpoint-ORIG-GUID: WRofSJHJFiCynkpkGdejjWUDMJWAPqZv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-28_01,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601280070

Add support for specifying OPPs for the Qualcomm Inline Crypto Engine
by allowing the use of the standard "operating-points-v2" property in
the ICE device node. OPP-tabel is kept as an optional property.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 .../bindings/crypto/qcom,inline-crypto-engine.yaml | 29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index c3408dcf5d2057270a732fe0e6744f4aa6496e06..1e849def1e0078feb45874a436411188d26cf37f 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -30,6 +30,14 @@ properties:
   clocks:
     maxItems: 1
 
+  operating-points-v2:
+    description:
+      Each OPP entry contains the frequency configuration for the ICE device
+      clock(s).
+
+  opp-table:
+    type: object
+
 required:
   - compatible
   - reg
@@ -46,5 +54,26 @@ examples:
                    "qcom,inline-crypto-engine";
       reg = <0x01d88000 0x8000>;
       clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+
+      operating-points-v2 = <&ice_opp_table>;
+
+      ice_opp_table: opp-table {
+        compatible = "operating-points-v2";
+
+        opp-100000000 {
+          opp-hz = /bits/ 64 <100000000>;
+          required-opps = <&rpmhpd_opp_low_svs>;
+        };
+
+        opp-201500000 {
+          opp-hz = /bits/ 64 <201500000>;
+          required-opps = <&rpmhpd_opp_svs_l1>;
+        };
+
+        opp-403000000 {
+          opp-hz = /bits/ 64 <403000000>;
+          required-opps = <&rpmhpd_opp_nom>;
+        };
+      };
     };
 ...

-- 
2.34.1

