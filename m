Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16F23375D1
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 14:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767624427; cv=none; b=uUHB+yVBOzCfX2YJE6k8Y+jE06bsMwl/ljMlX1fkeCjL59mF8mUDz2M5bb8zJd7/oea3xP5w5aBHNLB2L4AIv6t+UUvg3RHBt5pSGfcT1Nd55iuflIk5paEQ2obSjFKr7RvEzUqVf60X8SnN9jrC05hukPuRqteOFTKmqkTThVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767624427; c=relaxed/simple;
	bh=D4EdTDjAofl/keSmVTh77/IigDjeFsACMhK9OOnUjuc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s5xWQEbHNdqSffrPkPuaM/r5JJZ1ytok8EEQdlL0AlpGZiRfUAZxXzctVmwRhR6RGMlLmLEUTf3qbTiOc7VHeG5rfjA/vWc2P4humgLEhNxecNqPISDk7Pq15Opel44BBg8853uaptMkDxzoQ49Wwn5xLy17XrHHpVS9rRY5ggY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ai0FGE58; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AZoJo8MP; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ai0FGE58";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AZoJo8MP"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6059co70610507
	for <linux-scsi@vger.kernel.org>; Mon, 5 Jan 2026 14:47:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=JhBKVlQJz49
	+u6EBIZsBHwU82kPiFaw4dCGsqDxkSPM=; b=Ai0FGE58MpUcrqs8vOV2GOuMKxc
	szUJlwEjGUoH0ctemgjsogNFWidmd8+xghDuDAjWPMELWwhBkeK+wLYfF3bcqslo
	e8Rluf6FETVTGKkkmz4kp6DrLb3J5uuZqLbFQbOrTkl4Z9/3H0/imgfnFIwPlseY
	wJcE4tRibZwlUIAIFiXNgKkcl7Eo7kWAeqIRY9TxeajF4vAIQ6Dwqv9XvEBS4gWd
	foEtqh9pkdris/MK99VKJW8FTAlqrMLc2R/qGWdMkReq1P5xRLg7Yc9zWkH4y15g
	y5cLGSg66FRpYxPD0tK6bcJyXuVntQ0zbmbXm4licw7Q4ja7Woc3UOI+R4Q==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bgaus0rp1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 14:47:04 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-34c38781efcso20080a91.2
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 06:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767624424; x=1768229224; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JhBKVlQJz49+u6EBIZsBHwU82kPiFaw4dCGsqDxkSPM=;
        b=AZoJo8MPoJKZnVcoYCZu2GFxZQZuGhhkInSBnBeN1p7ZMzO081pAWXEMCwCH4bgZIn
         yPjGPc3z+gJ9GT+wBz9kUPyfaptLFHettkT0LUqEli/mAy/YwYFwSA1Gs/NKH2j7odfw
         fAfzfWiIz6yzqP4SQmBWeV8FTQ/spxNi8M4zrO92Ca/x8EiUmChXiwvRkXRDhr4Oh017
         LqlayNzkMkprf5Ambdh4N0TEhGP4M5NSKZyLxae+dKDZwK70SXMfvDRajrqcj8HU5Hhp
         8/iiR4bXh3UYmnpEy1DiWcegfyBrPZY0JmdnCAltFY+EdTHdodP2corWyryIzbzX7uKX
         7jEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767624424; x=1768229224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JhBKVlQJz49+u6EBIZsBHwU82kPiFaw4dCGsqDxkSPM=;
        b=EYUoUt1mBH8nQTszE4dI0n2/wbrGlxYC8Ml50/KirvRQRHT9uFdPsQzyUunvEu+cHu
         z9jyKUeCtHhy9tUbebbz0pRKnnj2tyyxaCb06pPZVBPRd2bwsupzU8f1p4iO4QKnwYTD
         51TJbefFW5qtnd55dkZ0/+DGzvaiOMCkwUwbG/kjMVHZQv9z18kllNR2QncdSbKq8uSX
         bYveyoEaaH8D6tK/lTVmMwVdjA9JEPmlI1ajFPJhZhc7OOAyN7H5cP2+T3q+SnnwWtA7
         n+C8rhiPph+LnVCFDz5eViMAweqwO+RIi8F4n/TLb/ghhv/5AawFdLhGOqTJkrd+GPTv
         ZcMg==
X-Forwarded-Encrypted: i=1; AJvYcCXn5mhUUIUPk8eKP/k/zDSQqr426Nj1cQjkM1eHcrjV90JAvhH6oo5GW0eaaYyaET0U33/EDPQB4Txm@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0GjwOQeU7XQoYSwnz8m22ulKuIDADpK4v/uF+aoQ9pOsTq19h
	VCi11sBckdUvxqirSewzQdm4fQiW1zzyBtwsoUPU5KdyIyI/bSXGqyTkejFgSvdrCr+YNSh7Vmt
	xPwb3Cp3nBr/4vZakb+S12fc3UbNe+UUi2pJxxUzmGCml37axbBW0ttCS9Gl69QRX
X-Gm-Gg: AY/fxX7c8LlQpFitpxwhXvqSdCB4C+SrtQVwmIGGG4SLYpjTja5hPrG65scteTr9lrM
	/Lgwp0wk4JQuAOWLwqGY0FCTj5XN5P8tmZaVJTe6y69GQQ7EC/t4kx/FLz5rM5Nqv7OLTaS/6MY
	EiO8PCRPB27002VxbnPRE3dFRd7XHffK/8q++nK9s7i0wR1EDlGDMK2uyCDaFQWEIkCWSEJ86pP
	lyx6FFDPQfIqcHmxbSbQKTQv/Run4EtggyCtov75JXNpX64b1cd+s0wRH9tvrhJbeL5HmCOKJhP
	GSDUbXAAiRF9zNFsi4DtIiqfZydZDp9wTMHLpnktWhS5SE/znijlTQvBsQwk9bp2WEBEsykE1CS
	G6Mf8C9JvQKEmYIVqD0xghGMZZO00HiPp7PMFNnaIacfiU/C/Wo9e
X-Received: by 2002:a17:90b:298:b0:34c:7183:e290 with SMTP id 98e67ed59e1d1-34e921eaf5dmr29670299a91.31.1767624423794;
        Mon, 05 Jan 2026 06:47:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGSOJMt9LPpStimWUWAc3THDarK/RDjttBLCdC3rkMFxijAsvfUDvaknO3V83tRQ9PNeE5XzA==
X-Received: by 2002:a17:90b:298:b0:34c:7183:e290 with SMTP id 98e67ed59e1d1-34e921eaf5dmr29670272a91.31.1767624423306;
        Mon, 05 Jan 2026 06:47:03 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f476ec311sm6634868a91.4.2026.01.05.06.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 06:47:02 -0800 (PST)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
        manivannan.sadhasivam@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Subject: [PATCH V3 1/4] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add QMP UFS PHY compatible
Date: Mon,  5 Jan 2026 20:16:40 +0530
Message-Id: <20260105144643.669344-2-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260105144643.669344-1-pradeep.pragallapati@oss.qualcomm.com>
References: <20260105144643.669344-1-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: wW2JBkwT5HT1BENs6pUSf6bAgYWfSYh4
X-Authority-Analysis: v=2.4 cv=DP6CIiNb c=1 sm=1 tr=0 ts=695bcee8 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=0Nzjj2pCF3-L_PL3nR0A:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: wW2JBkwT5HT1BENs6pUSf6bAgYWfSYh4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDEyOSBTYWx0ZWRfX+BYaosjvUjOq
 wzcoUYfBtY/Pz7/0siF4T1RiMEQHZDva0HijShci83oQZAIbvq5TWNUk3ZtEssIUtoCEI01tFT1
 ErI2qscV2IqxHxk+9vvAIgApvZnqbhJk9HTioUvMW16rdWltiOjmrme60xTxA5cbHJrOz4c8RKC
 +PNUsuonZ+dlRGX7M53xJG+ZJiyt2k1zi9pCnw8iCMIc5F1CzZpqZ2xs/GuqNgQaBpvslSDkcrN
 iyt5uOUP9DJsQQ2Kl6ck2EuCmG5sxwrAYiI+jD39M+V5lYWgUnoc/U8WCcaIPZVEbPc25XARxCH
 fEDasbwrrEPTiQbIChKOgHuRs4RlEXnhbcZewSPzTN4qNieEMHxS3fs/Q8EZOaJOnYGax8upplr
 u2Yosv7j8bRP5DjJ1qsUehHzz97HpNN3K8hdjmu0/qH7+yBuiksjmfDcJfPdu3+O4uIjJPuyBw/
 J3xmRX9VriJzcF+e3ow==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 spamscore=0 suspectscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601050129

Document QMP UFS PHY compatible for x1e80100 SoC. Use SM8550 as a
fallback since x1e80100 is fully compatible with it.

Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 .../devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml    | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
index fba7b2549dde..166e3787db58 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -20,6 +20,10 @@ properties:
           - enum:
               - qcom,qcs615-qmp-ufs-phy
           - const: qcom,sm6115-qmp-ufs-phy
+      - items:
+          - enum:
+              - qcom,x1e80100-qmp-ufs-phy
+          - const: qcom,sm8550-qmp-ufs-phy
       - items:
           - enum:
               - qcom,qcs8300-qmp-ufs-phy
-- 
2.34.1

