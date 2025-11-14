Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5B233BBCE
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 14:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763132244; cv=none; b=ESEM/B9/AhyPA4jVbGO8vHccN8EiBizjktt8YUePgttxS4XLBNtkzI1mjdeIaQKxzA3HiZVyNMKFlgGYtijF98b3v4wTf5WWY0ncCdILhKd4Y4M5176EbBZOm97Ap8DeiqY5LBCs2wqHbMsAKFkuDzd6Xb8pudma1HASE5FMaTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763132244; c=relaxed/simple;
	bh=Xuswy4RfzUTcxu2jskWZbDfB5ogB/jLLSySFNw+mA+s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hpCsZEIFbVeSn8N/PKDTSbod00RGW9xz80pZn1F78Clz8ljqHfaT6yZeiskQ/19VLoissD8y6LIaoC7449IuGK2HOwBHsL0ohJLbpsldVa47KnoCYgSK27hI6C8almvu7a1zoIy80MwK9wx1C6K9ZYjieI1k8gByUQ1Tt36VsfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AzvMWg1M; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=D17Cs736; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AzvMWg1M";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="D17Cs736"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AEDtq7J4121694
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 14:57:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3bpMiE0+GH0xu0Nruh6V37CvxzUKksX2wmr+vwwBtfE=; b=AzvMWg1MRRzLXi7i
	v2duDCZHYYVts65KiAoe/9Iu1n9LiG8ZXgiB+zUisL0WcjGcJic0CXPzLvI2kGtP
	vqFnn4KMZeuGlNLdfKZII5A8mpFJiIBuRJ/ri4hXRrwadRBy2b0lSNs08hKECV5T
	kA/Bx+mpy85vT6Mr5k950clMGfYpJYWvEDRs7ixD1sD3KU6yqFdEj7c3gwqmcK0i
	OiAO0uRzXy4G3dQ7LHBhtTjBZXBj71ssoWeYiBSzG+4uwlBXIKD7cJhWOEeYXLW2
	DNWsisBoCHPGodA7KwC0YGN0BI2VJVMu+Rs91dETLi+fBAa6mILHckff5LO96VJz
	welorQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ae5r7r5q6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 14:57:21 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-297f48e81b8so38113535ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 06:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1763132240; x=1763737040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3bpMiE0+GH0xu0Nruh6V37CvxzUKksX2wmr+vwwBtfE=;
        b=D17Cs736BzLwULKcA64VYfXczn5FkxVOuMxRs7KAThn8Jk3XsaZM/vKisD64nojwdF
         wxnQLfzjHJilXbEtxsUT9HJm8wMDCJO4IJ8wb7H8XkeBRTVaWRt2/aqP2KtOZrCKYGka
         ZdnXH0oMt498DMo0j9jvU3NxfKoSOUkrx2JMfpBSedJPN9lpWRaOd4zhsBpOEpEMDTl0
         MWQaMbO+hHVkqUOB1kDVO7kHv7X1OhGysgZ8X+mqParhu4Tyc3LqwsBvDb516+WvXoc0
         dyc+3FD1YNCQFEJ3oreR04Sk49SuKVuqi0LoINeLV4c7XBHPJ0azGfFK6ddHP6Arq1bc
         jteg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763132240; x=1763737040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3bpMiE0+GH0xu0Nruh6V37CvxzUKksX2wmr+vwwBtfE=;
        b=ZolgewWgHt1Z+TgpqyNr2JaGXYcAkpm0NTLMTQIe4uy6lAGGtF7maMxNB0P390OTSL
         WhqMtyC8jICYsH2udD05Int8aJ5y0ZW1Ph8ztCWOy24o5qfyNITGzb2q15E70I8agkH8
         4JSTTqSCAU3wfL2J35J94IOrCj2zLmpvxHfSNnTgjtBv/MhnLzxPgDl73+Rsh7cj9eb4
         Pn6uE/mc/YwzHpmIE14sx2p2eW/V/Dbn3Fy2XaU6uTilhCC5lRHjMz6O163Paw0EaIbH
         Lf5U9oxK1/Z/TCu83H5dCqPu/e3yIiIb33W04rCiZY/JFbQ/gJ0+urkNsFAQoeHyvHJc
         oVAQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4h767ilnIQnLkFCi0uM+O0jueTroQm+8ISaF+Ni7Vq03cXNskK9s6YBfSExetec08kcYwd3Wv/wlZ@vger.kernel.org
X-Gm-Message-State: AOJu0YyrAOb0FoW8mHmluwLduuEFywN/Q/kCTAyhYpVl9wSeSfdPV95W
	1aiENr9W4tirMUgwWx9ByYZ1zGIvO+U9+nZSk9rlYJH+F7WIFbkeRD/+/313ca2g4/yIasCxwBT
	yFix7QDpXTLb6KLXA8+3Rvku+5DjuVzkYcH+rIx39vRUpCHfS/7gDLT94i86sGISc
X-Gm-Gg: ASbGncs0Wh5jSdHkxGYbskiXX+lq/zBlyyF2S2k9AhKB6ORx30tCWKb6fRR09LpB3g9
	Wo1nUNf1V2xZwK7/qe+ukV96ojthxbmXo2DtwVX81fmjSt2w2bQegbilRhB9vdyCU+nr4pLpPtX
	xeZ3r7H+ROceneWlwk3uhE86Op801dnVJWEhd0yj3/u8doTu9hEkxOuNPOQJdxrg6muxSC/eyMx
	N2xqkjR9CCq8zpvtO7zFhZVx9UWbU28J6XQNHz+JVYODkuyxERE75eLPeg7qwaz6ymWkjgRC7Z0
	kbZnDaW+Tk9210WFLSYZGCesjIc0/hlYqirs+SOsuV/3fikOJrPcEKaJ9T1Wg/4O19sQySUqhut
	MBMEVNVPfaGjrUmRUUi6pyujYjU2BLg==
X-Received: by 2002:a17:902:ced0:b0:283:f19a:bffe with SMTP id d9443c01a7336-29867eeb17bmr43951295ad.7.1763132239950;
        Fri, 14 Nov 2025 06:57:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE9Rx5Kuzi67UsGXalnzY8HfFhKg+I7R6ZKFyOolDRgvZ+lKBDRiO8YMTPQK25ANBO4+XZyEg==
X-Received: by 2002:a17:902:ced0:b0:283:f19a:bffe with SMTP id d9443c01a7336-29867eeb17bmr43951035ad.7.1763132239477;
        Fri, 14 Nov 2025 06:57:19 -0800 (PST)
Received: from hu-rdwivedi-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c244e13sm57548015ad.29.2025.11.14.06.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 06:57:19 -0800 (PST)
From: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
To: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, ram.dwivedi@oss.qualcomm.com,
        quic_ahari@quicinc.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V1 2/3] dt-bindings: ufs: Document bindings for SA8255P UFS Host Controller
Date: Fri, 14 Nov 2025 20:26:45 +0530
Message-Id: <20251114145646.2291324-3-ram.dwivedi@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251114145646.2291324-1-ram.dwivedi@oss.qualcomm.com>
References: <20251114145646.2291324-1-ram.dwivedi@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE0MDEyMCBTYWx0ZWRfX60gZBtCS8Vdc
 5R2m9Kt7sfIeJ0xOZ3Dw8RfEQCgGfdrKRigmaiRvE26I+R+USm4npm8IK6LyFBolY6zZvKmXupB
 nJ+6nHg+fOm0sXEjAkc/HP/J8sefX1ls030xOjfdaRA2enL0w+I55taOXvTaCDa5RqggM/XNCrX
 d60+MmPD3Ea1EWtu386P9Cdf/eEr36n5yNDEhw5S1OfLWylOEkg237JiQjSZassppyZh6gaNBQ6
 Zq3wUtG4rILjLszxRQ4fGxQvm+UOHzGt/veNF7AQl1IPffndwVHguV7LgKuFLqsJ/TNCSK0OQVY
 AfFZKmqFB9tL2rng4QJT0pMeOj/y2/1JkUDl0MDuUem4u7SsCnIKwSiPwoVonHNACrCiil1FKLz
 zd/2LTvhEoDbvgl6iZDJAT4OBbAOlQ==
X-Proofpoint-ORIG-GUID: b9nXMt5ZCfUiErNmRCkxLbG1S8-jFfZP
X-Authority-Analysis: v=2.4 cv=BJO+bVQG c=1 sm=1 tr=0 ts=69174351 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=gEfo2CItAAAA:8 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8
 a=VcM-S10TGioI4za7RKgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22 a=sptkURWiP4Gy88Gu7hUp:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: b9nXMt5ZCfUiErNmRCkxLbG1S8-jFfZP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-14_04,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 clxscore=1011 suspectscore=0
 priorityscore=1501 adultscore=0 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2511140120

From: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>

Document the device tree bindings for UFS host controller on
Qualcomm SA8255P platform which integrates firmware-managed
resources.

The platform firmware implements the SCMI server and manages
resources such as the PHY, clocks, regulators and resets via the
SCMI power protocol. As a result, the OS-visible DT only describes
the controller’s MMIO, interrupt, IOMMU and power-domain interfaces.

The generic "qcom,ufshc" and "jedec,ufs-2.0" compatible strings are
removed from the binding, since this firmware managed design won't
be compatible with the drivers doing full resource management.

Co-developed-by: Anjana Hari <quic_ahari@quicinc.com>
Signed-off-by: Anjana Hari <quic_ahari@quicinc.com>
Signed-off-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
---
 .../bindings/ufs/qcom,sa8255p-ufshc.yaml      | 63 +++++++++++++++++++
 1 file changed, 63 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
new file mode 100644
index 000000000000..3b31f6282feb
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
@@ -0,0 +1,63 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/qcom,sa8255p-ufshc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm SA8255P UFS Host Controller
+
+maintainers:
+  - Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
+  - Anjana Hari <quic_ahari@quicinc.com>
+
+properties:
+  compatible:
+    const: qcom,sa8255p-ufshc
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  iommus:
+    maxItems: 1
+
+  dma-coherent:
+    type: boolean
+
+  power-domains:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - power-domains
+  - iommus
+  - dma-coherent
+
+allOf:
+  - $ref: ufs-common.yaml
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    soc {
+        #address-cells = <2>;
+        #size-cells = <2>;
+
+        ufshc@1d84000 {
+            compatible = "qcom,sa8255p-ufshc";
+            reg = <0x0 0x01d84000 0x0 0x3000>;
+            interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
+            lanes-per-direction = <2>;
+
+            iommus = <&apps_smmu 0x100 0x0>;
+            power-domains = <&scmi3_pd 0>;
+            dma-coherent;
+        };
+    };
-- 
2.34.1

