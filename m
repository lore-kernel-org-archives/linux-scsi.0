Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E26425F98B
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 13:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770816596; cv=none; b=HjK4W33aITkD0XP+x/wmJHcrgxdNfCZhF8m6GPG9hPQ5mTp890xus5vtnn66v/pDDJPairDjnrHr+JLDpXGsF0k4oR1wn9y9i/4WpOnGAx6YubHlS7wUVw0r3G7YW8AuV4qkXPO/LpOnhxxkLilFk/mRgUlyMTw1UJs9ZmQUkCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770816596; c=relaxed/simple;
	bh=F8dlGzylXsUZhimrq6/FNXTDw5cd94/cgBPDlPbZYrY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=I4TeOU6YvcgAOkf9mt8PJ+VHWWeGDjCDS9MZOTSdjPWc5n1n4A+WpV2mCkwUovGgeopYWkDwcRWy8N5KTjD7lDdafXEgURnxOGcejYCM/+ouw+1xzyBux88b/2ZpK+kCXTnTkWPZE1PggNoVYlI50p2ZwiKXClYlwsVvQgzf+4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lDulmL+N; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KfVWqaNC; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lDulmL+N";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KfVWqaNC"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61BAxY9Q3203729
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 13:29:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=YDSGphfqFZHevoU9vCq3tM3+41gKEg0Wz8i
	vxkG1eS0=; b=lDulmL+NGReNGymP19CwwilGoeXvz6NthGOGbaKie3/eqgTAxzU
	Srd+2bbBN7M8/G/dfJjilHaajSmTyb4diUJTaKIV29s5w7yEaeWawekCv1saE9A1
	y2sJTF+BKh4cWK5EmEAtLoe/5OceMYymi06tcYHU9s1lfElPY8x7AEbn+ubCnYbo
	jjyEPmNqWXAu1ArhatcXno6nRTiG1oC64MuSa8zWQCjChE60+NvJsi/i7GHImGOZ
	D/ulxXP3C6H2HlvyC9GjRT9BNrluV5MEkbtEDXrMfSwKh7R6k5rwDHKS/nLMaDbP
	6ynl/9YCEwvDeHBJJ1x3KoZ6Csgd1O2BHww==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c894g3dk0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 13:29:53 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2aad3f8367bso45344865ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 05:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770816592; x=1771421392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YDSGphfqFZHevoU9vCq3tM3+41gKEg0Wz8ivxkG1eS0=;
        b=KfVWqaNC5M9hlflyvBQzwaDLYx1uyMciUQQ1Scx71nxATCEN1DBI5/1uj0nINVhPMb
         FpJPTIpsr3mLTNg/YZu6vqLsu+PvGawAOwumPqw/ivUYjV/rx6ZTd2WyuYLWSoTcJEb+
         I74UjBJxRAGIavAPIj6ZfvMOZzUIkPb5Pp0TgwOTzi/gox+hoUU2jtDW2PVuh/G6xyJY
         Iqvr4ZNX9YF5jW6VusMsfOpqrpTpfwn0r3d7ZVGzR++9c2PcXmULoOaYPTs6XKykfiFo
         hUrdprS8C+IJxssjhyG2mElqDPxA8nriskuBjuhcIIwaK2ZwMyiT5vdiVeX96VU6I4z5
         +xCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770816592; x=1771421392;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YDSGphfqFZHevoU9vCq3tM3+41gKEg0Wz8ivxkG1eS0=;
        b=uMKMf+AuoTnGqVSbTGkGey+AyXxy6R2AeBsn0XtwafRdwn/Fu9/FFFORSwxPZd6A2P
         BAAAS7OHxUHXnzx9cdTMkJAFBVLaa/h5nKTRm9AQSy2ekBpEJAL4bLVpkHXD/3IeRbzA
         bsOtuIKi+Y8M0W5lX3zAdKlv/l16I5m8lHN99Q5qWg+8PYndpxvw+TNLL9OBXehkgmYl
         H+FYvbyLcRt69TNGIgWj3EYhjn68alwbOPWucQ1GXn9CMXRs6S9SCLbA++jM988oJIZ+
         oDI5seRUQDbuOJ7RLhvTj92OFsh9eJaF9d74LyQkXHHNRM0yA5McDu85tyWP2JRq5RUY
         9JYg==
X-Forwarded-Encrypted: i=1; AJvYcCUaOv/cnykfKQ7T9s4T6G03iJyyPGiIZfSevJ25l9agzDXKwUOx+23jix8qN+oAmQqGFe18azpHIXYA@vger.kernel.org
X-Gm-Message-State: AOJu0YwAhzNPrgyQMhqJE4QZdoRghTYUxT4oG4nNafdESXfgw3i2TGxI
	QZdAtz+WtjMQtzivGlzyE5N3EFW4fS5DAv1qm19XaZDzyb8/Bj2yISNqi7V4vSC9f6SghW/ZCFH
	3OYrkT4UMz1fAjype0MaAoWHzNyjwyzEJ6YeLLCB/W6sPAS63Ceo0eyNs84p2Gcrm
X-Gm-Gg: AZuq6aJvy966v+UWJ+c4tCte4HBjYqwdZIFDPnV1xJwCnwRvZieJfCkXagkrDEv8+Vu
	Hq8f1H+1Rn8IwGqaddgieukRswMJQgqT5EL0D1ahc5gHu/F8xczKDTuTS6nyOGgHNhYDxP4IVCd
	YduNrUaTmV7IUjlLrE3UDX70LSoojounLLR5BB0y4O0ZU9lrwfACT3+j1D7D2+xmGiDpAqzC5kD
	eRuxyk2tyvuyz/yU1Fyzra/8ZVim8iNTQegCKkGAreNCjmLB5pBx/68gBty+QlO5KzcK89PkoUd
	z1e2aWuma9znhHaDJC2K593KXb+28D9ys2jpbuoupzs3FZSLHimto3bdeOB+UqTsF4SBbLA5zr3
	2NvoWPw0AcTtDfZcqXttnfYFI8kNfohy+kmUnSKDn3HrclvJbc3FTyEXoOh8eCnFD
X-Received: by 2002:a05:6a20:2453:b0:38d:ef23:12d1 with SMTP id adf61e73a8af0-3942e6c6040mr2508650637.74.1770816592421;
        Wed, 11 Feb 2026 05:29:52 -0800 (PST)
X-Received: by 2002:a05:6a20:2453:b0:38d:ef23:12d1 with SMTP id adf61e73a8af0-3942e6c6040mr2508608637.74.1770816591817;
        Wed, 11 Feb 2026 05:29:51 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e84bc1asm2143655b3a.58.2026.02.11.05.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 05:29:51 -0800 (PST)
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
Subject: [PATCH V5 0/3] Add UFS support for x1e80100 SoC
Date: Wed, 11 Feb 2026 18:59:23 +0530
Message-Id: <20260211132926.3716716-1-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDEwNCBTYWx0ZWRfX38EC0kEXD1oG
 bQmCrFy3vLJDGSr7Sp6e/P97txQua+CGtxh3iVjbT0wviVgvAgXadjFyTrDFFal6CcyEmGHn1kO
 bQSUiJWBn7xyCKgj/NyfHd/isHKp8TRZqEnhllACaLzSnC/tEB9nRQe13F+bPQCxEF9fG8kwNaJ
 jzPUh9QNFzTnRaPeLRZzBOlBDkEamyf7wMrVb6aKjhciXoFvlQyhH/khmcJdSV1EHynM7gc+fmP
 hUPamcG/bFy4sI3Bb45pkrJmkaBlub7NHWI/+Lg9t6ol6vfuji9MVmO2SwLnXPKKopjc5wnKdl1
 Vuvr3ZBF+7y1rPrhfUkXROTm3RQG0u7WpaM1mwRyCNoWwqjR//qaUi9oD0/HDJG/DzsBjqtYpMw
 aZ71867gGgEQrnggi6pCFkd17pVF3GD1m7iSFIknZDT+dgUxu1kpt7QB95L1iKdADeVgKP/Yx7d
 wlDk/8l3Pyye1HkbpNQ==
X-Authority-Analysis: v=2.4 cv=R64O2NRX c=1 sm=1 tr=0 ts=698c8451 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=pGLkceISAAAA:8 a=w1dworix_CjMrjKQpqQA:9
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: iLfdSyOHjnSzYMgYqic2ZLRVxxT5CNMu
X-Proofpoint-ORIG-GUID: iLfdSyOHjnSzYMgYqic2ZLRVxxT5CNMu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-11_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602110104

Add UFSPHY, UFSHC compatible binding names and UFS devicetree
enablement changes for Qualcomm x1e80100 SoC.

Changes in V5:
- Rebased on linux-next (next-20260210) to resolve merge conflicts.
- Add RB-by for UFSHC dt-binding [Krzysztof]
- Add AB-by for UFSHC dt-binding [Mani]
- Add RB-by for SoC dtsi [Konrad, Abel, Taniya, Mani]
- Add RB-by for board dts [Konrad, Mani]
- Link to V4:
  https://lore.kernel.org/all/20260106154207.1871487-1-pradeep.pragallapati@oss.qualcomm.com

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
Pradeep P V K (3):
  dt-bindings: ufs: qcom,sc7180-ufshc: Add UFSHC compatible for x1e80100
  arm64: dts: qcom: hamoa: Add UFS nodes for x1e80100 SoC
  arm64: dts: qcom: hamoa-iot-evk: Enable UFS

 .../bindings/ufs/qcom,sc7180-ufshc.yaml       |  36 +++---
 arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts    |  18 +++
 arch/arm64/boot/dts/qcom/hamoa.dtsi           | 122 +++++++++++++++++-
 3 files changed, 158 insertions(+), 18 deletions(-)

-- 
2.34.1

