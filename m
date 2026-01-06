Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6703370F2
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 15:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767714145; cv=none; b=KQdt6U/twtUbVVub/0XD6C1sIH/x4x+u/1NuWsYtaOEuEvCCgzw9a1V0T/ZszeWDEEtPjKJlWUGXNdl/jGSaBtl7i9ZojbIbCT+Zbet9BzX5vF7SRM8etdZp4kbkXL55bj8n0TRuiPzxc+kQ7QH9bbeM4WRKa2lK0qCrcnzgo4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767714145; c=relaxed/simple;
	bh=8iFNGEM6G0SGx+YCWMUDESDVajTlvJZQMG+GznL8tfk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iHTbCulvCA+ewlqn7XoPpV0i4fYUP5e3tHYfmbJDg0pfHIvKTT+aDf0VsJB8/8IUCBn/nLO/XiXSURyQDmfX/NWDKNKAq6WKS5SP6fwb2LETLDzeDB/f43TLUIaVaH8ylXwEbSGvn39rWM0p7N+0pZ6lFNpkzeQrcmEKrjUp8K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TcxKdOiq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HngDIwCD; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TcxKdOiq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HngDIwCD"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606AtJ6x3214304
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2026 15:42:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=Xbc3kQ/3J35Ph1RdKmRXDEClfieoAFkWx/T
	fAmjKN4E=; b=TcxKdOiqsUD7KrTEBMt/IYJ/+v9A10iMXAbrTcewYmlccXvX2yq
	SKAqMbMka5/lLOjAcVaYlmGxqaDt9edbOFQPleylJ+o9CtgoZsFX1Jo+0MgyWAYk
	cJE2ZOnPAeBisStXD0KszAbZTao9ApkLjbd7GVFHyJ6m046NWAnxp3+LtLk1gQJQ
	2LiM20sOFCj3YwXrO/RkVm6YoMuf0NGClgOgdWCqnsfh3jU87G2l9v1lIXjtj69b
	Qg8RFr7r6CPeSzOKgZQ8S+JjUTRZ2sYMs0fNYI1cgfd7I/iujcueWL9m0XA8GCX7
	wkvFPJZz6TjJuNvyYys3gXA0RTjj43Afvdw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bgpndak17-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 15:42:20 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-29f27176aa7so21356795ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 07:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767714139; x=1768318939; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Xbc3kQ/3J35Ph1RdKmRXDEClfieoAFkWx/TfAmjKN4E=;
        b=HngDIwCDlq0RfwfgEFu1WA63p3lyI11ZChNtrBYYQxO4b2UPFziAdjCN8k1RxrKt+3
         dWHh/Ykuim5YHtEFEIfWRigMzahen6QxPQDMil2jg/WwyGaxj4S1ReTDLBCeb3BaCaQM
         WR0OdmMe4y5iwxYYdgQmeVLtrvaoQ5WBQOWoCz9dbmeL8Wv/EgvaXv8lfO7J62nd9FlG
         adpu32A7i6bj+MaG700cf4BUYXiKTJL3ZI+zf4v+dx8Zj6ycUDtIr6idMufirQszEdTY
         o3tDklpsMbG6t7a0J1KSNT2nr66avNNqLIBOovxL36SL4AGJAdI3CFo56EKTkK/zlN5T
         fwBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767714139; x=1768318939;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xbc3kQ/3J35Ph1RdKmRXDEClfieoAFkWx/TfAmjKN4E=;
        b=kTlyDfB9iPgnnhMu0NztcVas4MeuXzTnkSf5DKgQyQQ3OA8+rdDC0qCndiiYL6LUjq
         T/kGu90rsDBBGQ/fC0dbOQgFMqUpVj3UXsQYW5+txwc1W3YqUYgvddpxFqQ/NrEdtuUB
         3kl3rQmhqx5MYD8ZyIQWPHVkqL/Yf2a776enI2kRx587yIsWXFA49j6yanTKYQDBoJLa
         j2jsYNV8DgiciZiKTa/o6FDz4UPETBWVydW+nZlG2kiz73j7lDJoaGHCFDxoDTxdwpA0
         SYL7klaIYREKYYFkLE1BTZL+3igqylB2EPN0SU8sbRxRhwyoaZ09odNkq/SWaGwGLoaP
         HvRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlgVjTloAh0Bm8zKzPrBfaxb5e4X2Om0syuoG4rF4SgOnSMYkeg5NTWUv1+QUCtwilKtqGLXWff8yb@vger.kernel.org
X-Gm-Message-State: AOJu0YwF62FXRTKg+LOw+QMMm6EnLWzmwNn2cV8S3S8XpEI+c8xABBkA
	shKmzQuDDguNQTfY/yKnVM4vnOcOhROQY/BBYeaKVnzwnR1eLqoOcEiKuM1Iqfc/DW43DWwhTXL
	vaae0LZQj2nOabcb++XRKT1SD2L/ICb7minleJwgN2T7wbgOVFAod7fsYKoLIR6W8
X-Gm-Gg: AY/fxX6szio8BtstLw1nCwl+paBTssJRcKhaHWwRxZ2lV2Y6m1KgaoTDR6HE4hcBfhc
	e7DLL+aj4OhoCGyVL4i4xoPwXxN9QrqyDbvmcjGKk3cav+SH0htkLwuCL2WXRXYD0OPk7FRwlIf
	g82LtYcjOQREEwvJzARXMehsTTGiPEZarcm6AAidrZH+OtrCDAOT433gHDD4xIfTf1yH7KORN3Q
	ifzNYpfgPQzfdoSBOxq2BRtzhAE2nRcFnDk4Ugd07IEvqxQkBOaexqJutCekC1oyZrR+14+CjB+
	O3yGaFJYiA36LID6oAY6vOc8cIsgoXajIrQ6B0hHvqNcYz8/VddwsUFe95aGe+/jQaH+8nfv8Bw
	smk2vO6CwPod/FCV1JEWGpFzrwLbG3JrbiY11v/H1e4WOcIDYtKK+
X-Received: by 2002:a17:902:d488:b0:295:96bc:8699 with SMTP id d9443c01a7336-2a3e2d8eb8emr34279205ad.20.1767714138915;
        Tue, 06 Jan 2026 07:42:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFr0lGVIZnh5mEJ0lsPTYQ6WJK/ZNFzz+RbfUFoD1NKhkA3sF5ohpJ8ppkYMwJ7WS3VNv9vpw==
X-Received: by 2002:a17:902:d488:b0:295:96bc:8699 with SMTP id d9443c01a7336-2a3e2d8eb8emr34278945ad.20.1767714138370;
        Tue, 06 Jan 2026 07:42:18 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cd492esm26606395ad.98.2026.01.06.07.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 07:42:17 -0800 (PST)
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
Subject: [PATCH V4 0/4] Add UFS support for x1e80100 SoC
Date: Tue,  6 Jan 2026 21:12:03 +0530
Message-Id: <20260106154207.1871487-1-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: p3q8CpcYSnQRB_iG0b196BHdWKakaMj_
X-Proofpoint-GUID: p3q8CpcYSnQRB_iG0b196BHdWKakaMj_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEzNiBTYWx0ZWRfXxCJV8dgMp9TN
 rrU5yPjiU99WlJr4DHA9snsknKhXEshQyb9yHSCWWyjAfjrwWxjAZ3qJDVUbflFi99vFmZz0+6C
 oaDQt2upofNyId2mycLtcThAdU1OlFkBNOuvNmH8PKnq1ZI5NYpR5iN/Nli8ItsYDx3naoB6FSs
 /C0LI8LDLIlyiY8byLy8kDLJ8AuU2fDAiJQhkjCyHGniKPk2YU7HLf11zQK2P8NQNSjFXl1+CAp
 +4fTdVxBzeW8spoaeMUYHk9iaS/x9USryxnJph8PD88kYwmgjKZ55VIRjS82O+icKv0wR8Rr21l
 SayE6wttTA1MJz1HCTXUGDQGBAQI7oEj22XUl87GlSCNGLUAXVJWSEGjaIZB7fMv14/6bXByyQq
 B19KoeHYdfsobrf2Fbq+W2P/nTs/6yyFEYjccyBzGCY39p0PggO7Ivs9XHZcXi1dlfs9+ndzJaX
 DI1XGR7ASWXpB4EGSXw==
X-Authority-Analysis: v=2.4 cv=Jpz8bc4C c=1 sm=1 tr=0 ts=695d2d5c cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=pGLkceISAAAA:8 a=l61i-3TWFFmDW3nFSd4A:9
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0
 phishscore=0 suspectscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601060136

Add UFSPHY, UFSHC compatible binding names and UFS devicetree
enablement changes for Qualcomm x1e80100 SoC.

Changes in V4:
- Update ufs@ with ufshc@ in SoC dtsi [Mani]
- Retain complete change history in cover letter [Dmitry]
- Remove "jedec,ufs-2.0" compatible from ufshc dt-bindings
  and SoC dtsi files [Krzysztof, Mani]
- Remove RB-by tag from Krzysztof and AB-by tag from Mani on
  UFSHC dt-binding file as it has changes and needs re-review.
- Add RB-by for QMP UFS PHY dt-binding [Krzysztof]
- Add RB-by for SoC dtsi [Konrad, Abel, Taniya, Mani]
- Add RB-by for board dts [Konrad]
- Link to V3:
  https://lore.kernel.org/all/0689ae93-0684-4bf8-9bce-f9f32e56fe06@oss.qualcomm.com
 
Changes in V3:
- Update all dt-bindings commit messages with concise and informative
  statements [Krzysztof]
- keep the QMP UFS PHY order by last compatible in numerical ascending
  order [Krzysztof]
- Remove qcom,x1e80100-ufshc from select: enum: list of
  qcom,sc7180-ufshc.yaml file [Krzysztof]
- Update subject prefix for all dt-bindings [Krzysztof]
- Add RB-by for SoC dtsi [Konrad, Abel, Taniya]
- Add RB-by for board dts [Konrad]
- Link to V2:
  https://lore.kernel.org/all/20251231101951.1026163-1-pradeep.pragallapati@oss.qualcomm.com

Changes in V2:
- Update all dt-bindings commit messages to explain fallback
  to SM8550 [Krzysztof]
- Pad register addresses to 8-digit hex format [Konrad]
- Place one compatible string per line [Konrad]
- Replace chip codenames with numeric identifiers throughout [Konrad]
- Fix dt_binding_check error in UFSHC dt-bindings [Rob]

- This series is rebased on GCC bindings and driver changes:
  https://lore.kernel.org/lkml/20251230-ufs_symbol_clk-v1-0-47d46b24c087@oss.qualcomm.com/

- This series address issues and gaps noticed on:
  https://lore.kernel.org/linux-devicetree/20250814005904.39173-2-harrison.vanderbyl@gmail.com/
  https://lore.kernel.org/linux-devicetree/p3mhtj2rp6y2ezuwpd2gu7dwx5cbckfu4s4pazcudi4j2wogtr@4yecb2bkeyms/

- Link to V1:
  https://lore.kernel.org/linux-phy/20251229060642.2807165-1-pradeep.pragallapati@oss.qualcomm.com/

---
Pradeep P V K (4):
  dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add QMP UFS PHY
    compatible
  dt-bindings: ufs: qcom,sc7180-ufshc: Add UFSHC compatible for x1e80100
  arm64: dts: qcom: hamoa: Add UFS nodes for x1e80100 SoC
  arm64: dts: qcom: hamoa-iot-evk: Enable UFS

 .../phy/qcom,sc8280xp-qmp-ufs-phy.yaml        |   4 +
 .../bindings/ufs/qcom,sc7180-ufshc.yaml       |  37 +++---
 arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts    |  18 +++
 arch/arm64/boot/dts/qcom/hamoa.dtsi           | 123 +++++++++++++++++-
 4 files changed, 164 insertions(+), 18 deletions(-)

-- 
2.34.1

