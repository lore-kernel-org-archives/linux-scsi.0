Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7713F9294
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 06:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791354605; cv=none; b=iXdRLAcP1/ya7JmHherTYELke+P7duT6oRotvq1AJV3UUNs55oiBK2av9IAoV3aSmCYGL6Db6qwE2PaLht+2XC2mW4aJ3Qr/4PJda1pWETF8uxL9UNKNpuHF8NlqvdJbX7XXdJPmPBS/hkQkfMrNKzzFwZDbcJgpNaafpneRuaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791354605; c=relaxed/simple;
	bh=UbxlUsVad51XjlMr7BHaxV3dWnxuikGfc2t4VeSwSBE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NGHbOGno9a8MVxwWeB/9coJmHSAuKCeNlP0BWff9rbTP0rzhC4DGj4sYgibU1dND0IQVC5XV75UiEK/Aa5GkksGJ690ha7tbQiKsd61e9uT/fjvWFpX3kzICtbQWTLLrToe9ghAKuLvlVijHD8Dv5yeZvmoytiNk8mSWmqwW1XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fDa+s77j; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LH+gsREr; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fDa+s77j";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LH+gsREr"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6974U2HS2295029
	for <linux-scsi@vger.kernel.org>; Wed, 7 Oct 2026 06:30:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	X5RO6KrOqtQUt/yGDo9w7+j/X7O1yX9dfy86UnAtqqo=; b=fDa+s77j/RNxG1Vk
	7FNsYIu5E2xSFIS5YPGLdH218qQfnbCU1VeB6H1rUyYJWp2kpkuSV5xV5lOFV8In
	9WPjCfgo+uvdCu18NRNpJwFE9+lpaPz1NlG3v+MctOPuVjQ2IOfDRoOGazRKJQUU
	9edZplpEErATK3Q8YY0CZOjLPHlyj14uATqUWkhfLtZpI/sBv0PN4YZJUn2E/Al8
	WUEp4j50XBGMpE9CLw5+rXvu2AGdSAxH6d2SHE0nDt4rjouPUF8nTSEN/ckE9nsh
	DBZR1hcmzHmiUwAfrk5Ypk27dix4SDMl/Uozb+DGlopuI76ISGPJjhftH5WO7Rls
	cXpQqA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5c1s0wp4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 06:30:03 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3a7d2f25f65so1223593a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 23:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791354603; x=1791959403; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X5RO6KrOqtQUt/yGDo9w7+j/X7O1yX9dfy86UnAtqqo=;
        b=LH+gsRErI5LLl4KAtp66bZuMNYtVPE4Vb/jlPjxYBewDW7dKFuAeWuV5TSjTQm9aVH
         WiHCIhNovwjfYgQVtRFYjrB5phyS/y7qbLxmgGuRV4NOD7wTVLWSv3un+cG3RRRSGodG
         JlqEBL61b5ZTpHZl094udKk8MW1p85Us0YepnCUE5ltL/tyT7PZDKBjOrYsNGBNo0y4Y
         R/CJJCbFNZbyrdEQD5r9XpYChNDw5OrD98MxhmTUdfV7xSSdhRODAZTEPve2vw0VfU+D
         dFAY7v1Cr3r4aLw98Eeyoo76i00UnRpIQ8Hyzl/7hycc19py/k8RutJP9nZynt6oO840
         0Byw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791354603; x=1791959403;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X5RO6KrOqtQUt/yGDo9w7+j/X7O1yX9dfy86UnAtqqo=;
        b=HQ5CEEhrwB6oH0ZYUPcp6Iog1E4MIiZVUf8cSr9qv0g3vOWJIzHJwnQ3k7UcnN4Mh8
         n78l6ul7+Xoax8YQX80nkobJn8pqDwVkVxPCSG1u27fcMle4zrVB93PaIg+n/YJsxZKs
         cpBJRgMKdUlmtF63AnOZQqV9BXB4jRSJlJtgphmcH6WyP8fl00FyxlakK5AsUnit9msJ
         T+77GGB1ieFrcYGH5XunHBNdRmYYGgbjHYw/NQblaWAT3hdg9JgjuvgoC+CFqcIvW79M
         uujJzZlIqxgYd+2B3djBgTWmxU1djOW9mHA6dU1MF9aux/hWm1Qcka7SPNQ1qfp5MkQl
         nidg==
X-Forwarded-Encrypted: i=1; AKwUvBw9klZAf82yHFnD/khsolbeqaEHXCDaVLNb6EXTITfM7hk37OuZyECKKlfud+T8Rtqt2rOnTmLowsrv@vger.kernel.org
X-Gm-Message-State: AFq9FYI9p1KNffQ4o2q/YRjtyVahlqxLvJxfOVx7LIlBtct19tK7P27m
	rBCzwu1Q4hKrlWyhkwIpTpabpeTZP9+G4UErheZBsYg/pK+5aFiq8zPY7oo4Nn2TaqH2HxFtqjW
	fu2TBP4pjx3HkVxKamjC4+2kt8RpPo2vx7GcIXg70zB/YWbxCHMNJtEhES35Z7GWW
X-Gm-Gg: AYBFou2b/lrurj0DIkmpzvKRh55vDvF8AN/2n+rn2PLYvX0Zo0LgFWFmDz0Sov2UFL5
	BPHceDaol5Yabi2+VQfxTX1PTm8Gtm0vQLh8EubcnrkZfk9cZiluFNbcVZTJNZjHWgfA3Pwovwa
	0xfnbunt0zXMlAlHTwFzlMlrJDcZFPZEpQ+g4NTl6o4G8VYGycK1RX5VWxCXL+gJ+Dkt9ZqWBHo
	sQBa+ghVfPRAnccwANgtybOleD3vFxXfFYeBdD0LbkH9hMSpA1R1ih8Q+Z1dZ4/pLxxQIygXqcP
	sAOc7cTBBZ04BlivqwtR8I3TcpoAbxKBoJ3PQcOvRGYQWRMpnkIVStuuu/YTgl07BasugwgDBOz
	1J1SwjApTzuuFTrQpZtG2xegioQ==
X-Received: by 2002:a17:90b:2245:b0:3a8:21eb:2e1a with SMTP id 98e67ed59e1d1-3a8a12be15dmr869401a91.30.1791354602427;
        Tue, 06 Oct 2026 23:30:02 -0700 (PDT)
X-Received: by 2002:a17:90b:2245:b0:3a8:21eb:2e1a with SMTP id 98e67ed59e1d1-3a8a12be15dmr869369a91.30.1791354601923;
        Tue, 06 Oct 2026 23:30:01 -0700 (PDT)
Received: from [10.213.101.15] ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a89ab81bb0sm2972690a91.5.2026.10.06.23.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 23:30:01 -0700 (PDT)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Date: Wed, 07 Oct 2026 11:59:34 +0530
Subject: [PATCH v3 1/5] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy:
 Document Glymur QMP UFS PHY
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261007-glymur_ufs_qcb_enablement-v3-1-84cf4f861415@oss.qualcomm.com>
References: <20261007-glymur_ufs_qcb_enablement-v3-0-84cf4f861415@oss.qualcomm.com>
In-Reply-To: <20261007-glymur_ufs_qcb_enablement-v3-0-84cf4f861415@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Abel Vesa <abelvesa@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791354585; l=1186;
 i=pradeep.pragallapati@oss.qualcomm.com; s=20260911;
 h=from:subject:message-id; bh=UbxlUsVad51XjlMr7BHaxV3dWnxuikGfc2t4VeSwSBE=;
 b=VDlPhQHPY80/A3c4TZb87pFj8z1u1YbRnTRRqhQ3i/QTowrosI0/f+9EodGI9A2Cs8stxim/f
 vQ8IPcNv3FtCt3aaBqHedQutRr6XTMxxNDTzejfWNzNxjSVheDLW8H/
X-Developer-Key: i=pradeep.pragallapati@oss.qualcomm.com; a=ed25519;
 pk=uyRUsge8nQMwf3iW/e/o0U8z9nWLCMm1MGKxEftztic=
X-Proofpoint-ORIG-GUID: PtTqJEParCvXG2S3eMGpsXb3_cfmISAX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDAyNSBTYWx0ZWRfX9JZ8YuOnFw0E
 72q7O4Mi3fR6B1kpxAZUF1dKRb9DODGy85B+MiNSA3odQsLNo9aqAnWqSJnEsyVo1iP76PYC2tP
 ujx6cOrsU8AM/paSeP+vqDLmH40mL6fSWGK+jkt0rqoe3ce6PojZcOVmOnAJ/5aLyrGmIPWH3JN
 Ijk9ClOnhMaJq4PIQ0EdTp+buM0CxitvfZwstrw+JYF+V293v5m4IGs2sJDKS25XT3PQGFZVLME
 zIA7cF/hT1bUI1+7Qc+S6oJGVAPw8GJcLMM/XSadmNPa6y3cz+XRKEWq4P7T1EGH90fw3o4bKAc
 jEoERcYj/nbfqdLQvxHPI5KVgJfEMVAPYaeemLOdExTxRSfAe1VYRaElZMaZrXDN4MiLQVLcjYM
 WgIaQIMjkcQT5m5JX5D5dYOK5ClrlkQRGT98x58+9QlRv9fMkV2H4RqJLAGCfQTUHwB0vxnKPdS
 Pw5kKLQyyvcL2gKphYQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDAyNSBTYWx0ZWRfX00FKX+6D6NjG
 hFcFOxmL9jjgjgAoBHBQBvh8MOsBm/XWGxijxdULu28UIWF/guxpL5+G/M0HueH/bJXXZta6Dai
 IPvZBzs7NcHGqBCf+eYflRzw9D03SeY=
X-Proofpoint-GUID: PtTqJEParCvXG2S3eMGpsXb3_cfmISAX
X-Authority-Analysis: v=2.4 cv=NatzRGD4 c=1 sm=1 tr=0 ts=6ac5e6eb cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=BahsdhlD1VgbZ89a8f0A:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_02,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070025

Document the QMP UFS PHY on Glymur SoC.

Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
index eb289c09906a..fb631f906513 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -42,6 +42,7 @@ properties:
               - qcom,kaanapali-qmp-ufs-phy
           - const: qcom,sm8750-qmp-ufs-phy
       - enum:
+          - qcom,glymur-qmp-ufs-phy
           - qcom,hawi-qmp-ufs-phy
           - qcom,milos-qmp-ufs-phy
           - qcom,msm8996-qmp-ufs-phy
@@ -113,6 +114,7 @@ allOf:
         compatible:
           contains:
             enum:
+              - qcom,glymur-qmp-ufs-phy
               - qcom,hawi-qmp-ufs-phy
               - qcom,milos-qmp-ufs-phy
               - qcom,msm8998-qmp-ufs-phy

-- 
2.34.1

