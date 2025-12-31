Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627DC2E764D
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 10:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767176425; cv=none; b=qBNNE006L8/jZDpR/9TG4Cx0Q3iWpdB6FGmxnfPmGPTuSCai2AhyhnN83D8gx5Qyc8B2DtsABNr/wLQ1BVWbAo6JOQbegd+cZNlhKdRiSGyk3atwkbaNKtfN9xqCg9W76n4HfTV0+Jw2n9AWbChlkbO4sYbCb/AOMCz+CPvmnB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767176425; c=relaxed/simple;
	bh=+9ZaeYSITjqa9LaWH6LtiAlmb0JwMQ1G1kWe7jUvDrA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ILZ97EVTmDmIj9jmGbMNUAdl21bUiWq3n4asIqZyfKbQ0INEZwHkmyruixTyCoz9pm69a2I1NxeywZ8+6U0Cc0X0pwNEeEZBtL5rLpg+aEQM2UPcq7jFW304q1ppsOmsJrkRlyY4l3rVofCgNqKgZpI+Q6o/SfuhREeoKmelclg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gOhFVLaV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=c3HS9VbR; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gOhFVLaV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="c3HS9VbR"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BULtXwN2725780
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 10:20:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=EBm+C9txCrc0JpQP/cSYDwUBJ05oXh+KTPs
	Ja3/CzN0=; b=gOhFVLaV01MCt51zqc1hSSQRV2Eya9gg3BUNQj3TDg5/j7JwRNE
	okza17le6Acn1QJfJXlp/1Kolz8+HK6qYCGMVL6TnGIPudC+L1rRAFONKlKbWP4g
	p3PRyxfz6Tvv9RyodjayzeGxFzkPOhR5XF93cnleq0b0/ioPlJpJeyban17L1eb2
	dz4iBwI5ZiZPsIT+jaO/xww5FAG+8G1ywN9Mo2n9VckP1vV97VUl3nA/Xgvm6LLj
	gvKnsEOG+pjeFXNq4sLf3imkCdowbQ8GCFEQmoL3UJoXZaZOskvJHyXbIaIbHb+7
	WzuuYA5OXg2ClDYUyCY836z29zlDl9EOlcQ==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bc0vdm465-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 10:20:23 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34eff656256so8175911a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 02:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767176422; x=1767781222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EBm+C9txCrc0JpQP/cSYDwUBJ05oXh+KTPsJa3/CzN0=;
        b=c3HS9VbRhCFaFk1ZxK053hYdTcI2dtpTtJCrJY62hVeaufumo3kd/wL+ZiKiYvh73X
         uuceaSAwmdpziDrjlbz6Jg7e/jSCQvl2ccEcLu+nwxwNffH9gvIr0bxLXIWfSXJYykbm
         9zWBVyO9d3grTT6MGchTq0aDAxqG2DjSE5/6wI6yiE9NQYe/e6eHN3+5vQ9D024OhyNh
         5NbQjNI7j52oWa/qnjpN00GwP56XfZOiKRt+5PVZzISllhc38+rUTJymOZxDiR6XiD49
         y5ODK8SF3zIualbbEwvlQC+CYMocahGlgHnSDMcSalfWE7kARSueTfDthgsBJhQjLBJk
         cD4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767176422; x=1767781222;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EBm+C9txCrc0JpQP/cSYDwUBJ05oXh+KTPsJa3/CzN0=;
        b=O4wF6FvyhehLp+YlFqy+nRZ0CsQ4esA3SnJHEtX871LJ0YGDTf23zdusDTsjkvkU5F
         BpFQRO0SQwY9s9ZnH5+uIPdCd8hHHkPsRjQJCEVQEb4xCpEXZoqJm96/wrEE5GGBpzvl
         rjlDGDRUq1K09/hcE1PjRt4wz9S5jNFbQ99et/AlPJNHjtM8/QPXMlQptTV2nZbaZpvC
         85IRIUqdbQ6tPXQIb8C5nlcynmJFhVmZqNPbw2cJ5LRZMFkqA9F79LPJST6Nfo+7N2Fy
         CQB3muJsJUN3lRYqcdh+bDgFX7bkPdEoHqwNMJE9ie9YoAlfPoFAWw2C7FSiyVCiunYH
         Gssg==
X-Forwarded-Encrypted: i=1; AJvYcCUrTWFanmIrVSQrSQ1ORtJ7gn234iIVL+JknKdZoBbDIbdwjBaxFdWRI8lChqt1wE+tcQsF5L+31UyM@vger.kernel.org
X-Gm-Message-State: AOJu0YzLIkIpm8QT9u9EJsHFs4A4kR9hB1CH8h9PYqSX7k/jqVuNsyrK
	xEmA9eTxHzNNi8UsmqH5ygbfW3nG/SsHUXFbelTX3vM9sppI3HLf0cGvFQL8zaK///5MhgjZMwv
	PPOcVG+NWQX4YJJ+6wVUQGz9cnryv8UKNyqRpTnJuLC20PxjE7SFh9rWyGvz/tuhW
X-Gm-Gg: AY/fxX7Gq3+MQveMgvbrgekU7yOI/95c28+pCr32xHAzn6A4WWt5o59wPsHbfh3r8h1
	IxOD5L8awkp/TYrGrUGeCnus5lVYOjQ/73L5bl3sHFsZlhb2lfcRzYYVzY18vhGiEH2iZka0gWR
	/DoLDaVV0xbzdCWQq02B3uG3r+h0Jl/LVHfbbYRkNUwFoYpSt5g2ilR+Gu0w2x7xuBX13/tBISe
	Y6/vP73y0Js5pfQwyYgvbsURngLvrTUg1Jeklg4Yt3AFYs4+iOjAX/cnHUR9DHQZFXE/ytfR0xN
	tuL0oMtxhDrGbv13CkZQk/0WwJCqv25I5jJQspnQJQnzRvv18DmJ3uq1LgjK3EXUZjIfP6vqJlE
	Y+MO/OqP5zgLbQgYuMFUmBU18nHNY31XJCIfHWeLT94R4gL1gDdXl
X-Received: by 2002:a17:90b:5843:b0:32e:528c:60ee with SMTP id 98e67ed59e1d1-34e921c3dc8mr30732602a91.24.1767176422164;
        Wed, 31 Dec 2025 02:20:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHBBK2KabkmuNb8Z7SZE+KAlG1z4dXeua00bYwsikaNo04m/NZt3iH73LymmMzPuFxfkb4ELg==
X-Received: by 2002:a17:90b:5843:b0:32e:528c:60ee with SMTP id 98e67ed59e1d1-34e921c3dc8mr30732574a91.24.1767176421701;
        Wed, 31 Dec 2025 02:20:21 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e9223ae29sm32163920a91.16.2025.12.31.02.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 02:20:21 -0800 (PST)
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
Subject: [PATCH V2 0/4] Add UFS support for x1e80100 SoC
Date: Wed, 31 Dec 2025 15:49:47 +0530
Message-Id: <20251231101951.1026163-1-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=dfONHHXe c=1 sm=1 tr=0 ts=6954f8e7 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=pGLkceISAAAA:8 a=IsWZ5-T0EzXF7LRbJecA:9
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMxMDA5MCBTYWx0ZWRfX7kjhr2dySLpx
 Xn9sZXoNdNxhivUCeWxDoCyNlT+SPvXdxwfjZkC7mgTVCO0p5sdcl7uIRd00jIrVdLyPnV/PJKd
 p4Koyc/vdZPN6rC+qbhpJHDd2CNTf8pp/dLhXnnMi5QM31YDQ32kvVr3xyA1lEWvcBLxycfA2By
 sBQhAlT6au0/V7zqGjXA7d3rL0EQSBW43XL9cE4tGx/R5sc5uyGhGN/R4oo8/aayuDD6UBs2jwZ
 7ACACrS5kJL05NVb21cXpwC22njbMu4ARQGbu8mXwbvCnbchn+Ma9ncYwcjwjKhZoG6Ylt0LZpb
 MVYBAg1oQLNEg2ZSV16a2X5Br3YJUHP9tgurh1LXWdcBa64paTyEBvTCQfzoGbdjeSHL9pm3IrT
 CVD6dBzFqqMiS+B00JI0PVyiHb0BsfGJ56NPROxQMPTtDWbz0l4+aAoBrtoyFI6YxXnu8Y1q4mY
 AeuwG7EiKGIFNec6VLA==
X-Proofpoint-GUID: u62ASm4qq3e7UtdQG4_etCpA9o2xB_5B
X-Proofpoint-ORIG-GUID: u62ASm4qq3e7UtdQG4_etCpA9o2xB_5B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-31_03,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512310090

Add UFSPHY, UFSHC compatible binding names and UFS devicetree
enablement changes for Qualcomm x1e80100 SoC.

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
  dt-bindings: phy: Add QMP UFS PHY compatible for x1e80100
  scsi: ufs: qcom: dt-bindings: Document UFSHC compatible for x1e80100
  arm64: dts: qcom: hamoa: Add UFS nodes for x1e80100 SoC
  arm64: dts: qcom: hamoa-iot-evk: Enable UFS

 .../phy/qcom,sc8280xp-qmp-ufs-phy.yaml        |   4 +
 .../bindings/ufs/qcom,sc7180-ufshc.yaml       |  38 +++---
 arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts    |  18 +++
 arch/arm64/boot/dts/qcom/hamoa.dtsi           | 123 +++++++++++++++++-
 4 files changed, 165 insertions(+), 18 deletions(-)

-- 
2.34.1

