Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27DF35CB91
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 09:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779786626; cv=none; b=Xnb23Ju6HDXcwCnOhzpcm2gJ3bnD9SNppZ7vu+MBJxFuqNYGkTcb7g6Wzr1dNlE1nscULsCUjwpMMKS3Z4sZZGBGtgKggHmmuylTX/4E/anhavvzaZuFuAke909aiEEAzPuZuwKNR8jwrVRV3sUo8P6uim/tnI2dJqpiR3Ven6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779786626; c=relaxed/simple;
	bh=pU8zTR/qVRAWQJbSPMb7T+BR9B6f8N0WanaJydtgIOw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XNS62lVloT8kR6UlPGwhJEbT2Fg7FoY1aa54J4QpEfGk99tLWtTIVC7mm9jHQaGGJUJH/CLS+BSVGen+5D+PyHOsSsyhtzAc2UT//OwtGw6PV7KvD8MfcAr3GYDN/2uN6ePC1rUp41C15O8czdxnCJE4GQOC+tWfcGajV/dMzjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UF6Nei2k; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NyFxJiHx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UF6Nei2k";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NyFxJiHx"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64Q8x7vu2823127
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 09:10:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=9MpKqNNzUQn
	MR+cmU3gyGCyl3tS5MB81vXFKtNUOtS8=; b=UF6Nei2kcAR4RP7j8c8v7cCNTJ9
	DktAj2gBXt1Tpu3U+G6NQyzf2O3sQLftKBt1hS5d2O9VmccBAnwHpH9h+ouc6TFE
	ydCuk+1YJBD2rGQZPWW2kmGo3l7NQlH9MMQKH6L5ZI86sw4aPDfEc/D/Giueh2ee
	RpKllUKa7CHA+iHGierwa1OAm/4rABoYRTdbOqr9k8r77BELFcqyRxyDJcKT3ULd
	SRqmp04MxE+6muCQoimTI0H4Onb2UWon4VIwEEJjHLk5JLGqHNybY09F1UId95iy
	YrGAQ1DYJTCkd9InLI36IgYlbQJYxAJuQ+dqQCW/QNYKByI2rWamsZ6K0ug==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ecqvwu129-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 09:10:20 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2bc977e6aedso109567895ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 02:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779786620; x=1780391420; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9MpKqNNzUQnMR+cmU3gyGCyl3tS5MB81vXFKtNUOtS8=;
        b=NyFxJiHx5hBxpQOaLaZgM6AHQfjj2KG45BAdLbc2IIfjRNW+PAiSPxTlq95GFhSXT2
         D5QXcQGtL7ZQR/ASpmfWwxnKd8CjGFzhGGTnnCu3MkBZdQ2xHRXR0LFOABOa+weNqM6Q
         yIFM8zgoyE3fKosHSe2YT/9BcTlhYefWlYt3d+tcfhihvB5jz60mOSQ/vgibbOdSTaNE
         A7zPzXS4mnisfIZTv8uyOqiOVQJTZrwgCcJgwUC8oRsVARe9NJgZA0SsEpCYvBzyzoaJ
         +OOmN4KTkZNlWpTaZEjXRBBBgmXrvdja9lUxucaJp67Sn+2/DJUt99KZPHnKADAwajw+
         R6yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779786620; x=1780391420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9MpKqNNzUQnMR+cmU3gyGCyl3tS5MB81vXFKtNUOtS8=;
        b=rG/OnnxAZ3Zihvh4Hjn2kozu+5fER8t03umFCc+LNspeonmOS30BPZQD0g6bXi/BQx
         0CRu5QSr9pEVau0+SpDQQDfVL7r4xgPThmldwzktnGFTQGcMU5I1faGAH7EzYcerdcti
         ikjTe2qTX36RHv4VFOyimHjnZ/faFHg/bGGE3/u/HRKmC5hfPawb8nVgFBIKRV2WveGd
         tfSgKpUEt19vDa1E1BubE4a259u9XnaAjsQmSJv9XUdvoRsijdV7Ar0kr03r89vcy0Pm
         FVxqrNjYPAmx9IDF432w3o5TXWV2jJLbIvzh/0vGaAM3z0PFGVYF+Bpmb/HKkwDDjtio
         GNqg==
X-Forwarded-Encrypted: i=1; AFNElJ82uHGg++MeKCAI0pY79sZLs3UdUeVvigN7s3956U2zg89E+lBONRgg/l0jPZpV6j7S+Bq31UzepdZk@vger.kernel.org
X-Gm-Message-State: AOJu0YxIPRIRigtW2Zccx9KLzpU2xHbGSvfgxvq29y3NW6u2HkIhTzLG
	epK/tFHkdxpqQ47f/V2vsuX+1QLH1NVoX8lfNsUhxfciJP8BzPp0PY4wutSyXHSRXIjJJ282ajt
	oO8Fm8SZb/uMJYQ6UW/j66G7OKM7ER41KlNa+aU2XPf8M6F4Ar86u/1UBen3uRIWN
X-Gm-Gg: Acq92OGKO6v0dafdtOQ9tGUlAWSk1etV+kEI1c62FZE6MbKWfPprbQR/F2VbTSkWxIF
	5E63a7fet87Ullu835iqpQlIyOav9NjCsuHVO+v5Lu3JhiGFADD0I7oiEnqC9x+TiTOvdVtFQEs
	bLpwcNLw+lKf23McDWO9jm678Fhy9QFqIfPHLsBtuynrqmR+WEUJhee4hX4nCEtEz9Sk4uSq9WZ
	nzam5aCG3RReaA4y1fjDekURMxZlPt6jZDwIbTu/qpYIgKOGFyZiTNcufwa4iD80tJDrt2Z05PN
	g1ImFGNzwaru+FRxUT8YFNuUME3iyeqQjESJgFocjSy/aK4PdanWHb4q6dVAmNKiy2ChsICm+l8
	QXCuE+fAKHFFAbHODbS0W6w7ueb3WbI0jghfY5O2xKe1ro4Ick0+IZ8rYSSlnrIh0
X-Received: by 2002:a17:902:e790:b0:2bd:9061:d544 with SMTP id d9443c01a7336-2beb06a07cdmr186884215ad.34.1779786620085;
        Tue, 26 May 2026 02:10:20 -0700 (PDT)
X-Received: by 2002:a17:902:e790:b0:2bd:9061:d544 with SMTP id d9443c01a7336-2beb06a07cdmr186883735ad.34.1779786619631;
        Tue, 26 May 2026 02:10:19 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb5695a40sm109237915ad.17.2026.05.26.02.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 02:10:19 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, andersson@kernel.org,
        dmitry.baryshkov@oss.qualcomm.com, abel.vesa@oss.qualcomm.com,
        luca.weiss@fairphone.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH v3 1/3] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add Hawi UFS PHY compatible
Date: Tue, 26 May 2026 14:39:54 +0530
Message-Id: <20260526090956.2340262-2-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526090956.2340262-1-palash.kambar@oss.qualcomm.com>
References: <20260526090956.2340262-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: JejneiOT5bjMjXWlEK3Hpv22p_9CbHBR
X-Proofpoint-GUID: JejneiOT5bjMjXWlEK3Hpv22p_9CbHBR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDA3OSBTYWx0ZWRfX+XmOruZGoMWI
 8vl9/KwQXFvZePZZeYe8NiixemU6WzGFSlhgvQpoQEcm4C9mTntZu82RA+3jurV5huA9LX01m9C
 PAEqcjssbV9LTa0E/3YTUVYEHZeCEXBbUzIOk0tYGT5W3BVcIjmmq1M2hrapCN4VORdFz+htZM1
 AAb16KPqZu9NeCCVXFvwlhzK+YLpfacFg9iodPeQwzb9+0DVwEo0yJZ4gitUWq/p7cS7uL9meyn
 zZ7RyioE4K+cJrltT8nqB5920n8RTni/GpguwZc5019zM3FeuZTPFcbeI3vJnG1lUP00EVHKfLx
 T/xKLb3e9p1GGsoHrh/idH5eeNiKzcrFUJWYlBh2X/OaamVeixlAwXSafzWX0uElL4O/NLELUJ8
 LHcEX1H77LgxW6g8oYKp98BOHAEAq5nLys4Xj0yplXGjQyOUBzINJ+qhWEMaVXhtPFQE0VKeQpS
 GHstCu6LEQv0+aMRFQQ==
X-Authority-Analysis: v=2.4 cv=M4l97Sws c=1 sm=1 tr=0 ts=6a15637c cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=MMZtLZuhhDi3SW52_uAA:9 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-26_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 suspectscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605260079

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

Document QMP UFS PHY compatible for Hawi SoC.

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
---
 .../devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml      | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
index 9616c736b6d4..b75015f3ea70 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -37,6 +37,7 @@ properties:
               - qcom,kaanapali-qmp-ufs-phy
           - const: qcom,sm8750-qmp-ufs-phy
       - enum:
+          - qcom,hawi-qmp-ufs-phy
           - qcom,milos-qmp-ufs-phy
           - qcom,msm8996-qmp-ufs-phy
           - qcom,msm8998-qmp-ufs-phy
@@ -107,6 +108,7 @@ allOf:
         compatible:
           contains:
             enum:
+              - qcom,hawi-qmp-ufs-phy
               - qcom,milos-qmp-ufs-phy
               - qcom,msm8998-qmp-ufs-phy
               - qcom,sa8775p-qmp-ufs-phy
-- 
2.34.1

