Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC8D27700D
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 06:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766988442; cv=none; b=nduobi+HcUGjnsLjgWvXgC2fMWljX/iqQqUQQBEvc1M3fWj6jd1vJ7g6ivqoeXbpsA753UGRx7MpuOnuhjQGD3qxzfCmfA0eFRzbNVnySzkOs38GyCbL9I1Q9Gayy/rHFw4/2j1R0Xdk/Wg/ppx2HexX2X5xUwB958fzLkTRhRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766988442; c=relaxed/simple;
	bh=1a/rkl9DL29252mLhAZQjZjZoImYh9SS+B0b29pr5wY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dqzFHtE+s26uTHyA34gy5vBHzuT388l0BvaOlZCZYyH5TjYI3rEmfh73iZVIwP/MNQg5LfR6sy0yFp+w+wrbcdteL/o5wSId37O7sm67LNMSmt0b/BoORZKfu9MHwMskOxH9qX9+aTaDi/IK3jNviq5ZQOXn0h2ZjkP7kCXiaek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QARk2Jud; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fSRWJm/H; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QARk2Jud";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fSRWJm/H"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BSLn9rf3156595
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 06:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=zTbjgk+NOs3
	Iov4G6gd+2hf2/oFZUgG+sIHDNi2qqkA=; b=QARk2Jud6WXpGHJj9SRGkA8d/cA
	Iz/L43WUW2LOBZSYB0J2BJEntf7kCJTjtScJK0tnP8ZvXcQDsgEyNu/2swBmTvP+
	6lSOD6ly2+4sAikoSSiyDF6KfPmKCsdeNfy6n+DHeaERhM8fEsqX+sfo/KXR89sN
	lFba19itaweXgfqJYYlVSqI/DlUz+SRhBa/v3lTxrlkBie28pTrwpfYCwVrSTJsR
	Pny22lVnMWaTBJBJww3jQt0ARYRiApErxDf64gnW5lUpOTGeSGSqkwrUs/nenDgx
	tX/j96jKlKtcz101VPzxh8qnICTsi5VKX8rtkFviD1YxntNnwIfVRA5Z0Pg==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ba4tnuq40-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 06:07:18 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7ba9c366057so22895352b3a.1
        for <linux-scsi@vger.kernel.org>; Sun, 28 Dec 2025 22:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1766988437; x=1767593237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zTbjgk+NOs3Iov4G6gd+2hf2/oFZUgG+sIHDNi2qqkA=;
        b=fSRWJm/HCBw4Z6MGLdqIiqlSd/uxtJwjIgLIU2XD3RoUKeV1lJo/46WYakijwMI2JO
         f7y9ZvpUYqE5P18DfTx48O6jzuMGW1xBZujKfTPz9SeGnFmNjZlcNLRuNbYbc3Av1TEL
         isROlL8O5nNMAXmfppKm6c/cV7BGTsyeti1YkaZefTlIBZgCEjw/rlzvuLWyROu2DH1k
         FIGNyH/K0LbDGM6wpZpsNpuj/eEAUrcKcscW26QnTkT+hQiorKoahgaiacQI8yzmyKMQ
         qRiq+ZVtquS3Jl6xPqLmvHzpKuyuQkGxsLOCKumnwAIXeSnToZ3+PKsQqdWc91bbAaf2
         nF5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766988437; x=1767593237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zTbjgk+NOs3Iov4G6gd+2hf2/oFZUgG+sIHDNi2qqkA=;
        b=V1j5deoeKYsa5I8pKrVzd3jRmzrmfqJxfete6rvIJZOCV0gYmsAolm62EDGIyP4/yR
         Bw/u7ZWukqHZBjmhLQk1Bwajaz9QLwVHzP9TGMj6Lu5yPW7NUv5jzRNYr2P6dXYEv9hM
         0u3D5t3g8vWXjwv3xm8jZIRauHIdCEgQKCFYvXrfSyhrXzsDmwL9TuDFziwoNKTSZXq1
         DzzPSQylHEvBln5PVeBCqQYmrm4p78IqVGExSp723icATAsrBevacRQUApIjxfw9Rsmy
         Z2bZBPYlb5EUScXuO47trl279Cd3EcyWlrrxk3rQjsZ8TQArokbqq7yJRYMmZONYw0kY
         tR6w==
X-Forwarded-Encrypted: i=1; AJvYcCXJKARKs4DlBVVBsOn5Z228RPG1mKaeAVzGnnc31WfLE2JG6sHRA4nkQi/ZwfX0ZKJ5J++N9fR+K5Xt@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz6eZxFkp3cvWRKgIVg8zZEVdIR04xC5mmElVS9yxUhkO3PqkV
	w+Z4vbzVfVS2c0AIOh0c9bj83Wgc8j12L6g81oiG14aAKJWB6mvs1LSOmRTQLc7YWnVynITYVh5
	rgfcffX7ehnOAwpB0KV8qqKoWm7mdIT7ETNnrpTAs4Cj2dORUYTh3SYQvqHEfIYBC
X-Gm-Gg: AY/fxX7TYb9IWQE6Zi2qZzgIWcN7ibqdh3JAjNonFJ6CY/6yx2NrDVhFPfs/gG7/kAo
	nQxPGjt6Fr+duk6cDXf8/NLZIOMoMFZCdWf9sZihsgb4+sJisP4CEOy6YmRisUVGLubn5D5JnOh
	BvqGBXTwYOr1jgUT8hvpG216JzGR3qB6X/+tbj9UGdUYfnQ1hn9aCxGaCyh1V03egG4zwZ8VZ3P
	veUcovR313npOg/+gJAT4CdA0l0FXoEmSE0mYFoBWzRb/40yQviXC83/OoKu24WmPuSmBop0+z0
	sOeh3ylcWPbHSB4CoLvqr21rjfj/lpVfi9U3KWE1pmS/nBz+RHVO5BU9aFKIm7C1dnya4PR9VkL
	RS+eN2maGMlqOTc/3LfA9J1UDxou5t/m4zm1rp1l+OzTrNG2q6PJ7
X-Received: by 2002:a05:6a00:e15:b0:7f7:4dc8:55e with SMTP id d2e1a72fcca58-7ff646f9556mr26819253b3a.7.1766988437366;
        Sun, 28 Dec 2025 22:07:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFb5Y4sFr51IIwczO5+Lk8y814x/vUUUITjRTxac/NwTklarS9mW2K1VPjPW7044XMMmmWvPA==
X-Received: by 2002:a05:6a00:e15:b0:7f7:4dc8:55e with SMTP id d2e1a72fcca58-7ff646f9556mr26819238b3a.7.1766988436899;
        Sun, 28 Dec 2025 22:07:16 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e8947a1sm27917763b3a.67.2025.12.28.22.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Dec 2025 22:07:15 -0800 (PST)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Subject: [PATCH V1 1/4] scsi: ufs: phy: dt-bindings: Add QMP UFS PHY compatible for Hamoa
Date: Mon, 29 Dec 2025 11:36:39 +0530
Message-Id: <20251229060642.2807165-2-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251229060642.2807165-1-pradeep.pragallapati@oss.qualcomm.com>
References: <20251229060642.2807165-1-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=G+YR0tk5 c=1 sm=1 tr=0 ts=69521a96 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=QmIOYfwlR66hjO0Y-QEA:9 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-GUID: mo29ElJO3LaSVHrmPLy-SJz4f7Vs6yJF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI5MDA1NCBTYWx0ZWRfX8h8nBFVA1QLi
 +VFZQ0aEtpFllm4zQlg6GXyeW85TMTzjtA5nOQ4oMG5g4eXltr8svNc0I1GuB9BBYl8dMhKUvnd
 BceRD+xbQq2/TTR/an76GngKnKHk0O65ahAjajzg4QMT67rGIQ/BzulidmhgIRQILBFbwzW1z33
 9casmB06DwmaxTMwQBn4fDULkbPEkpUoLIC3dgnevzYAfO6Ot0nIyV72CSkMn51HUnyD+ArWHcG
 3nyGeDcBDnRXahrg2JovCk8x+n500qyMVXSV6PPLIHSKPMjJbT/2mAY9Uot/2Sm8Thv9nUIR8cl
 I0mBea4ZmUQksDw+LYGy2xFG5yMrvS6kKzaVtgSqScWVOXMD4nUUGWpKleoVAK5rf2Y+I3VxqJN
 D49bDQL4nIh0meA7yR++aKevrMUJ8L4rQWXNaUEPEEKMid6Ryjek2KvgO5ewEKLwZKQS/tMJZOs
 peLlQgfWtcf36ewy4Fg==
X-Proofpoint-ORIG-GUID: mo29ElJO3LaSVHrmPLy-SJz4f7Vs6yJF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_01,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 bulkscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1011 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2512290054

Document the QMP UFS PHY compatible for Qualcomm Hamoa to support
physical layer functionality for UFS found on the SoC. Use fallback to
indicate the compatibility of the QMP UFS PHY on the Hamoa with that
on the SM8550.

Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 .../devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml    | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
index fba7b2549dde..b501f76d8c53 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -28,6 +28,10 @@ properties:
           - enum:
               - qcom,kaanapali-qmp-ufs-phy
           - const: qcom,sm8750-qmp-ufs-phy
+      - items:
+          - enum:
+              - qcom,hamoa-qmp-ufs-phy
+          - const: qcom,sm8550-qmp-ufs-phy
       - enum:
           - qcom,msm8996-qmp-ufs-phy
           - qcom,msm8998-qmp-ufs-phy
-- 
2.34.1

