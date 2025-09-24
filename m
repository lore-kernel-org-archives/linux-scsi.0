Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EF329D28B
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 23:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758756551; cv=none; b=m0dJxNHdXZkCMI17FLiy3+9hkbrEPS20/V23ANhFnJgngsILt4aKhIq7upGmti5AoxZNVv+89nPlaS6cVYkSh/z+3MzalOqxWbvwACgJWf9jmoOcca/9Xcp1q8kB66YnVMzO/2IlnlRsyDA5BTMmEm704kdDwvnuJmBln8DXOI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758756551; c=relaxed/simple;
	bh=1ixz4E1H2pIiXzLXyMSyDlIXCkqJA/x/F+DP+KNf3Q0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HQ7VStDZzQ25wS4sCeiR7N/c2NdKhlt9NxotxbPjh2RVyoqiEfGmg2R8DVnK+rhWnB/bvqoz3P6PEtYQsSazFe4bvcqIDfWRDwH7q3u5eXl/Aggs5RJl/ojtD8Uq4RFrAPQJQcGNmvGMxGMPh+k1nuvuCfWOwomLOoLZxiiTgLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GaSp1RQX; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GaSp1RQX"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58ODGO0T017437
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 23:29:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yoYprIzQpGEht+RtS27992YaizRl4nrFk0NKTW3GFWA=; b=GaSp1RQXuPs/Lo47
	6bjaqR8s8oESCs8ROTbo6wAzzzVWbzxoxET/0GlN9dIHC767HknaQBgeHIsstVTe
	my3uH2C7bTc60NlxnpA9AaDAwxDWXcnYYoRY2mUIlfXZBTldGLXruRKtF8JBzdu3
	nReElghga/YDVLdy+vu1TEI/mN8puiRQk9iiSzniQw0pV/0WivLcLSVmOieKycwV
	g6JR0BPiS7dby2qSK9Yrbkb5ZwYJBLP02RKPaghoqXjjlEWMRVQVOTRNT8jDsuKV
	x9ZoKSY488Q0ovObgwBNXdTSebIyUDvLnljn8IOkBK8Byfp54XFfEoSt1UHdGWPM
	pYNC1A==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49bhvjyc5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 23:29:08 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-268141f759aso2757695ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 16:29:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758756547; x=1759361347;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yoYprIzQpGEht+RtS27992YaizRl4nrFk0NKTW3GFWA=;
        b=D3QlrjoQ2+7f0V2wGg6dLtzDRMQLrfoA1BnT6grsuSjzM5M6A8r2TjwKc9byLJZ3Yo
         c1Q7sjgK/a9N1t7R1eyBkL27qVuGmMkX6058jU3Y4j6qARVCWGWB89tSkgQvzD2NToy5
         wjbTtRBGUjPSN1+8PAp7jGKCcf6q2Gu8gaH7zsLErD4kVp/qB+NgXV64FONgCf5CqE4O
         zRnERGB/A0Fefw98uSnJaHO0uAC5TAkA85p+2Nq4w9C6gAJ1N2MiO1jfCGJYAgRjWTjb
         TvVeHAFPooJv6Pp0BxhiEZBYyBtbL9f/YSVHYzmDbe1lr0Ws5hNFe9LYn24ugZNhr+wi
         /5bg==
X-Forwarded-Encrypted: i=1; AJvYcCX1PrVSeKIuydv0cHmIcHSOvHQY6jshQvPdff1W8AcRSaCKDw3Oqtp//YPJg2fPNxiYcAjlsfUXL/Gc@vger.kernel.org
X-Gm-Message-State: AOJu0YxV/O+JzeYRXGnirR1NgFu6UgNyfkTuRSqg+f/BkGdOXxa06EF9
	TU1fsx+3KTdnA98fXGzi51pwXmRRPS4tBFAI68cWcieHAonaG5amuZ7VPy+gelXLcgs+L1+hv6/
	bTcaC/zm4SdEVcCsQnm1lNuBOIXkd+wBu6ZUruEAtcG3uu8R0DzNrVYpFhXDXN5c6
X-Gm-Gg: ASbGncs1361burUUnxieHXrAAH+LEcQboJZyiryQ6UMjZgclJ/g/UT9b3jjJ3sqqiil
	+YTs+i1Dbw0j8cN2l54cUA3zdBDR01SBsTnJmAKCA8bTavb0JgDVaWmkT3JKGXMaODcUjXWAUTs
	8kTC/IxVNV6BUXFH7vYVDJt+us9UJEwLUUjmTpzI5sQlaMDJ3gd1ssHp87bF+ErHXtAC/QbdjCf
	Qy3ETB6UZzc/RsTqESuboxDnzGuDNPJRcooHC4hTedY6Yx66etZyEpWJipYvwRaBH8Iltxhgxtr
	7jBYDqreKFoMF+49WzJa3qnni/tdVyaardevyX3n14AnAIlI04vKgex6a7J3rMgNCwzXZ3xUfHu
	nhrCoiAUwX7JlqMc=
X-Received: by 2002:a17:902:e749:b0:27d:6cdc:99e4 with SMTP id d9443c01a7336-27ed49e6cacmr15277845ad.21.1758756547566;
        Wed, 24 Sep 2025 16:29:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFgt7aoTizG+JzBBCRszUgmA8ZQFFFV6kXdzPC21oHMm1YuShUXyP6D9IxHyhwdW2zXjSqSjQ==
X-Received: by 2002:a17:902:e749:b0:27d:6cdc:99e4 with SMTP id d9443c01a7336-27ed49e6cacmr15277545ad.21.1758756547098;
        Wed, 24 Sep 2025 16:29:07 -0700 (PDT)
Received: from hu-jingyw-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cdfafsm4292825ad.30.2025.09.24.16.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 16:29:06 -0700 (PDT)
From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Date: Wed, 24 Sep 2025 16:29:01 -0700
Subject: [PATCH 2/2] dt-bindings: phy: Add QMP UFS PHY compatible for
 Kaanapali
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250924-knp-ufs-v1-2-42e0955a1f7c@oss.qualcomm.com>
References: <20250924-knp-ufs-v1-0-42e0955a1f7c@oss.qualcomm.com>
In-Reply-To: <20250924-knp-ufs-v1-0-42e0955a1f7c@oss.qualcomm.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>, aiqun.yu@oss.qualcomm.com,
        tingwei.zhang@oss.qualcomm.com, trilok.soni@oss.qualcomm.com,
        yijie.yang@oss.qualcomm.com
X-Mailer: b4 0.15-dev-99b12
X-Developer-Signature: v=1; a=ed25519-sha256; t=1758756543; l=1139;
 i=jingyi.wang@oss.qualcomm.com; s=20250911; h=from:subject:message-id;
 bh=1ixz4E1H2pIiXzLXyMSyDlIXCkqJA/x/F+DP+KNf3Q0=;
 b=e4+RfHwGDQQ69QoAGJgmiuXeCPI6N/wpSRjaFCHERX+3Y9Wd6oeSiZH9OuG6nj1rSJ9ctggJX
 nFb12dXQbf5A+22joIbSiJNqgjR/D9hN/PK5aZ9Cp+UdhKJ5qHcQo4N
X-Developer-Key: i=jingyi.wang@oss.qualcomm.com; a=ed25519;
 pk=PSoHZ6KbUss3IW8FPRVMHMK0Jkkr/jV347mBYJO3iLo=
X-Proofpoint-ORIG-GUID: SjIAqZ9QXARBujcqKUaBG3vA-9mD10aU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIzMDAxMSBTYWx0ZWRfX9cBACgNYgOr3
 KOohsNvjqBg1VoJ6gurMUwo+72MOeW9Ggkzc1tLUxLwpuK99NGgT9tUrYtd4VBnktehcSGnq3Tu
 vnUdVUDDrI8tfLARPc/hw45OGjwovg/MqxCTuyHYqQCpYS5PwLfCJHH2xbnhyJ35EDbt7awuEtk
 xmrIFoLz/P9jQ20X74EESzyyHPL2LUQAwGq+IU1ItDO5sLW5uLIxtZVl1xtD/PRdeLpoEAspe+w
 OKzIgs1zDXB07rr94rI7DPRHgUWNfTSUQsDQA+YDMeWMbiVssTW2tPNLwHl0VefPCvfcTabg8bP
 jszN5BXI5+ZertVyAfq/kjnv5xuEGKt3xtaHQqNQ5HX7ujBBl3GkornVFe5qJW8OX2IVntsRMJ4
 x8zYyhKI
X-Proofpoint-GUID: SjIAqZ9QXARBujcqKUaBG3vA-9mD10aU
X-Authority-Analysis: v=2.4 cv=Csq/cm4D c=1 sm=1 tr=0 ts=68d47ec4 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=EUspDBNiAAAA:8 a=CSN1HuAOl2xf59Ui8-YA:9
 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_07,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 adultscore=0 impostorscore=0 phishscore=0
 clxscore=1011 spamscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509230011

Document the QMP UFS PHY compatible for Qualcomm Kaanapali to support
physical layer functionality for UFS found on the SoC. Use fallback to
indicate the compatibility of the QMP UFS PHY on the Kaanapali with that
on the SM8750.

Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
index a58370a6a5d3..fba7b2549dde 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -24,6 +24,10 @@ properties:
           - enum:
               - qcom,qcs8300-qmp-ufs-phy
           - const: qcom,sa8775p-qmp-ufs-phy
+      - items:
+          - enum:
+              - qcom,kaanapali-qmp-ufs-phy
+          - const: qcom,sm8750-qmp-ufs-phy
       - enum:
           - qcom,msm8996-qmp-ufs-phy
           - qcom,msm8998-qmp-ufs-phy

-- 
2.25.1

