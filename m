Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62279377ED2
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 17:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779470860; cv=none; b=tLGY/CkGt5h7pUAqtBD/5DEM/ZeOBtACNO2F6C4sPtBsytf3h/yOC0gYQWpuZI+SFvt+8e3nP1qA1ULaiu/FkE1kr2LZh3duIT1UHQxKLjBS1HihqsRa71VqOQ/uUQGhwXpv5hEi2Ja3KlhjRlMxHAPzT0x5BHQKhAisW1sct2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779470860; c=relaxed/simple;
	bh=ZtudtnJuX8Faby0VuV52r6celt2UQfjIrIlwr3oabns=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HfC+awtJTKVk0bsnhOd2IlggkAuIn6nz7/je6wFvJCqdf3qVn2eFwQ0m/0pmbyPRG3P7dggcc2HZnLBTu8fMiYZezHkjUbPPxxi42UKtA+shMIGtdakr46oI9kTr29iF0ZnbWCrKprd87NL0CNbd6tR2L9ZxTP9plwnT/xpxBIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UQS1K/L6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dPV7EVSw; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UQS1K/L6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dPV7EVSw"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MDpmHD2125423
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 17:27:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=OQen+VoAHis
	aKxiinT3/zd7m47X7BB/wcGnNSYFTrVA=; b=UQS1K/L6dH8o/QuU6jPbVbMeBj6
	UkNoCP3Zy4xXoISy40tP3L0TSMUpC6OovZNHNLOXOg1GdQVrCMvIFJuZUaxkmSV4
	quqzokSeB6ur7hwakWp3wiAhG5aTCXV8/Nwk4kbitK2AscbD4vg2SIkqaX7M+wYI
	N6T2hWtvL0beyBDfgaaLl1BJgUgtz9krUZAnhxESEYnb04GG4EVPqpEp2YrkaxBx
	LcUGTH37/HAFednOVYN1xKIQW6ec8ZAgHJ+4/Qa9WofoF5ryZpP4YGSfVCf8S/ds
	jLn5G51wdSypsW9qg9/DV29tSJxTMs781A7yO97quPwBpomXGvquSCNT49w==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eard88yxk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 17:27:38 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-82f85179263so9581342b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 10:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779470858; x=1780075658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OQen+VoAHisaKxiinT3/zd7m47X7BB/wcGnNSYFTrVA=;
        b=dPV7EVSwPAjUDGd277CcKJ7opjujfTmUSH72biMak+b0hNW7utLPo+sLjNXzCwxd7h
         Og3adzaT6epNKETTtspdOZIM9H8o3LdSrULWxWspw+HzzSO4t4VaKD6qV/3snImi/LKi
         Z7ntWDqGZehld6t+fcHql4MOuJVOUqqVWTb9JNkJN4T0I7CyRE7gvnaJR6htNF1nvfOF
         sO7XE6ZjqC85kPAxnFYdCHk2if1nOightfkIGUuPF+cNAT86UieCOqFoXWaSkj7H/OuH
         Yw2ynvWjXleYygQnYuBfKB8izaEto0+ZK8qMmTIzAHGBxQRCoisH/TmCMyLinFomWmAc
         PV6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779470858; x=1780075658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OQen+VoAHisaKxiinT3/zd7m47X7BB/wcGnNSYFTrVA=;
        b=S1/EN0Fd80lk71ZYQBGEL09VYRpogPatHGjkXlRorSuplGPH08iOFy63A5dUI83YCQ
         /UndmDyN9pLupqqX0VQYXV6n15iXF7Pao/LFgSG/efhcmoaZSSqhD+dcb61Y1JGFB95Y
         Mjz23Mac9JdCtXVwuuDAte9Wb6nTDf/IbJyZyYwrOwB45cheLhr7CkraxeOoHOS0RSLt
         A2xJJv7aDG6zqGA/mU/Ssbuqsy33I01Ogc0OvaoZ8uTvN9ePKY3lt1z3rUiPrOntVoi5
         9jSkEqGboYKTVHTKAWxfkaKxJ62DUOLUYxGbZNORncvPZilVJd0zMbOJj6vVsY6gElov
         nR0Q==
X-Forwarded-Encrypted: i=1; AFNElJ+9gdF65HxvT3e5HCuN5C8KxT4Fz4/gwJK2M1p9rjrmahitUv70fx/fHuyTHSnQGUP8MWUSsQ5Pk/CB@vger.kernel.org
X-Gm-Message-State: AOJu0YwNRSmGX45/aKiU0NL+7+WO4hcF2v0T9o9Cd/u8CMn/ItBUpqbH
	R50YieWcjXUn84+C2SK2jjO3m+8f2SEFFAxo7UJz5PM9N8cEA/2euhk0jEmVa9lcqQO/F/4zhtS
	1oX9zudujkSCZ4Ma96CRrUR3i7IvQhzLbkQ955AtTxU5lsJvbRJ3pmnVNHObOILZv
X-Gm-Gg: Acq92OEQCA9QyaCab3oA15oJQlKXiBzVOLgFWzEm/OenAKToWcuzYJjqUgyGym5oaYJ
	vRwCVz8Gytdrt1Qy5+JkohaVTswDPdMpBharSHgKZ/rZgJs9DfxEpUoykQXoz1xW4NDfDVeyfnL
	D3L9InZXNuHnNKBuOuMvdCJnsSeIzPIlD7rwCxuMncMpKaDNKfuEKlPO3lTToR1KbDkjyKvDVqw
	23O+s8noERWYfHZo0NLCbahYW3xRKOUVWlglm0GJEdUISz8sSwDHgMVl+kLqdPcU5PIx+fJiZ5O
	MWuI1kTXrpGusJyL/VDzDxtvwEUtjxABDFD8vF+yT5jxq4cVecdP4HwZjDHtD/GVPHRBuGlB9dJ
	TkVWlr2mHGN6WBdOh8cHIDnk7bOQFPXwlz3bpkBw/4ez0RqpW8xJIvg==
X-Received: by 2002:a05:6a00:8c04:b0:838:af72:fb2f with SMTP id d2e1a72fcca58-8415f3af2d2mr5234129b3a.6.1779470857797;
        Fri, 22 May 2026 10:27:37 -0700 (PDT)
X-Received: by 2002:a05:6a00:8c04:b0:838:af72:fb2f with SMTP id d2e1a72fcca58-8415f3af2d2mr5234097b3a.6.1779470857341;
        Fri, 22 May 2026 10:27:37 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84164ea09a9sm3045693b3a.31.2026.05.22.10.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 10:27:37 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, andersson@kernel.org,
        dmitry.baryshkov@oss.qualcomm.com, abel.vesa@oss.qualcomm.com,
        luca.weiss@fairphone.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH V2 1/3] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add Hawi UFS PHY compatible
Date: Fri, 22 May 2026 22:57:14 +0530
Message-Id: <20260522172716.820490-2-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260522172716.820490-1-palash.kambar@oss.qualcomm.com>
References: <20260522172716.820490-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=Fus1OWrq c=1 sm=1 tr=0 ts=6a10920a cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=MMZtLZuhhDi3SW52_uAA:9 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-ORIG-GUID: A0yNjNQJSua8UVd205hVwywB9LCu5WOt
X-Proofpoint-GUID: A0yNjNQJSua8UVd205hVwywB9LCu5WOt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDE3NCBTYWx0ZWRfX7aZrRT60bwPP
 wx3cuTu+Xky1TvmlrGeg3SndsI7L3x+1pMhkzOGGD5nU/nziOkC5+LOBJE5974j3+dkZ/NzY3OI
 1LFo5L3sDqG+6CNMliqBY3X0OzIMOoJQm52V4myGXOSDZ8NTJU0zKeLXeLIoduzO+hFweZGEk3Z
 BxQ/I3aQKj5mFWUHd7UpbLwGyifBFWp5SlgZfrtPWqM+6I3qBe/OKVErF16JB2FSnmdex1le8rI
 cxFIFOe7YhpRfHogpSQSSrp3YmeTaNHz1ssEuhbYP1DfSRb1az3wEdWxsxgHnFfGwsRBhJBYkIF
 dMAmhrIKSOsMWIGTAO1J29Rmg/iw2MSZEMH6Obt/s0a4ASxiwX76hrR9cB32PbDXglPlBOF6RgP
 XzdvED9q54k6Zg1/kyeH20/shN9OWZ3KTsjUDsiE3Pq5ukF6AKV6JClJ8gJ1uoZU23WEMwdN42J
 DWZjztlSyrzUil5LNiQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_04,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605220174

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

Document QMP UFS PHY compatible for Hawi SoC.

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

