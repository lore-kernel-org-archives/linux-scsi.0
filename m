Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF612C11E2
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 14:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767624423; cv=none; b=s2yVJKpaulyWVZnyx+L1lmm3YdZrZXIWwhcEcuVv54W8sO2ROeoMZbcy0yVg9jYuK+PbUM9J6Nh/PNUsH+erqOpqIlOm4uxDfjeg5gRI3jeVavuIgcBtoz1IP2pdbrVlcclBUshdc5FWQww9PJEltP8sfvBSyK6tyUP/xUTRJPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767624423; c=relaxed/simple;
	bh=Iksxeh+iZKWuqoMSccyLFBjsocyLuKyvC0sw416qK8A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uFuAbeaJS+bMEUgS/bZr8RyylUjIZuz7l2JkpKEIyG2YNbWHC29xIEx6q4s1KSIRLoa1HjuqGT2R042knJINQT4jeeuM+7mKMu56WLeYN6itAfPtdfDRpH7lgFXceEFo3vuiW6hVO6kJ9MykVDJgBuRhc2g/GzKcole5h9DuNmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=B0wUgMuS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ito26Krw; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="B0wUgMuS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ito26Krw"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6058L3Ap3652262
	for <linux-scsi@vger.kernel.org>; Mon, 5 Jan 2026 14:46:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=PZ93jr1D4zRH7N9PpSQt+IsQHrrWM2+KK0h
	qm7sbJpE=; b=B0wUgMuSvwjHM4Cg9T+rd5/SchNztsFXn7K0XNDmJo9pCZXxbmQ
	tv6vxpH6Mmq2GswfpfLSacUbWBJsV6jWoFE2+oVei6AkmndVsTd0zqHoz7bTjqXZ
	tqOx1cT58b/ev/NDwHIN+9s0sL5Ns2NBCimNfl6LXFDMPYPSS802I4kaAcLcwjZB
	6Lh8yUWgcIi6EC3jNcZ2w0yQh0oK2yDYCsomAYqlrY4UkE4tVVUQsWjRkkClpu6M
	Fis7pXtIkRwGG2xK/Hio0Y52OYVczlhMY/1p9GaKrxHPzbTg+/xNFzNPISUPbf2W
	bdDbY+GwxZJPYpO3NvNqRxP41tg2ftuEEOg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bet2qvyu8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 14:46:58 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-34ea5074935so41435a91.0
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 06:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767624418; x=1768229218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PZ93jr1D4zRH7N9PpSQt+IsQHrrWM2+KK0hqm7sbJpE=;
        b=ito26Krw/sHKBYiHy4YneQKREncDbyetIrIDMWvQUarSWp4akZTHfS7ysyC4t7cL3k
         KslehBznPRjvuqWBJoatGwfWzUtAmth3PaD3eY/3ohNIvjOwOnWn/r819qxDSlplMXJg
         dIPKrNJ5u0D4JQRp3ALneWkyyY3rB1LfH7UwjXlwUZC4HofO1HF9TQvg1Md/IEnd4Yff
         XBItjqK8eNl5cMw/+zT6SKDvFdAZKOd4uxXjirFFAJvXdicBt5YGdSRz/T0rud1HXdd2
         FJw9xs6uiAtvG/b5uvfcWni0ayjRgQtJ+w4qrV96zh6ardyGo8c+HLkt7c5wms8ycuVn
         MrpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767624418; x=1768229218;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PZ93jr1D4zRH7N9PpSQt+IsQHrrWM2+KK0hqm7sbJpE=;
        b=CCWxfqt9f4ies/SFRld2tU9CdtGoctDKKpSfGoLDnbZMKNPVkaVHHWdllsbowAEB8R
         2AqgwGNmx9tdvCfj2iaBx03Cu6OILcmIWTbEBzDoRkwGd6QMFXeCJ+BW7c70Ayz6EycY
         RDQHFhFRraH17Itl0TKzRPSHEwkEMwAVFnBREJ0YV/SHbPCRGKuCWXtiRHIWBdFEIP8S
         BTI31GteXtrM2cjOacsbU4lzeOj6FElPMhl9Vu/AxKAAAO7S43G8bc6hRoOErcjzSTOy
         7v6WwEHaiBpiHwoWNUa+k4c1hUIr50ebkOiJjMES7z6lDZU9gNyiWYE8+GcFjk4M1rUP
         UdKw==
X-Forwarded-Encrypted: i=1; AJvYcCUhnNUBVKGidG1E3isoQ3UAZDSp3feKq7dq39OJuYCYXG6oMH1udpPqQ8TTdNuHjIqRhMv90lrmkrfB@vger.kernel.org
X-Gm-Message-State: AOJu0YyqxR+UprxNm5iaZate0VuEqUekuujSzrhuqqRWH8rC9lroxjVg
	6gTBh40Bicb7CRURma+X7JKVRgo83J2SKchjmaQZWcQuOaUyFNq2hk/COR+bp9Bsjjwd825zYmG
	RWHbNo94BIEADnjXGC8Q3o8h8JMgsPPU+d1RX/AFxKcZQY+Hfna3q9eDBY2yuF/3n
X-Gm-Gg: AY/fxX4SVNCgYphl+zX8/aH7HUiXgokyNMPwbRepnwOZcnCN2q7m1ervdyyfjYPFkG0
	6FDbnLu0ZJOwb3aOYLFWlboeWh4EAW0QYw/uxUHrIcidGlQJbXhWFtrr4jHwBrsx2RH6+zqSPgq
	uxf8Dd0eKopx83Svk32guwN+R5S1NAUh9bEKGkhI5Rk1X1pisqiNl1Bt113n8R+2f2lcSKneyTE
	mcjQ399n9FVgXf3qt5skSP7fm6IGqBP+EPiQ6IbrJVIVBaRzkZ77BMFVVIRf6aIu4SmqPbDgZzM
	/7BWlwPA0HWgBIJKQYJd3RjHOeOWRQL4sf19NM85V3HgP+YU/Z5ONrG2wDMv2ZAhe8dP501EQ37
	BVshhNwOjNVqvvO0a30mHFKM3TXbWAVtEn8Qho22EXAHhw4f1ji/I
X-Received: by 2002:a17:90b:580e:b0:34e:5516:6655 with SMTP id 98e67ed59e1d1-34e92143ca1mr39102505a91.9.1767624418163;
        Mon, 05 Jan 2026 06:46:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEtgxrBJy+KlEiCPbQnnuwqMX4vv2QGV7RNNjtLOl6mRIRz3nWiVPztFg2wB2/6dl+kJEARIw==
X-Received: by 2002:a17:90b:580e:b0:34e:5516:6655 with SMTP id 98e67ed59e1d1-34e92143ca1mr39102485a91.9.1767624417667;
        Mon, 05 Jan 2026 06:46:57 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f476ec311sm6634868a91.4.2026.01.05.06.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 06:46:57 -0800 (PST)
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
Subject: [PATCH V3 0/4] Add UFS support for x1e80100 SoC
Date: Mon,  5 Jan 2026 20:16:39 +0530
Message-Id: <20260105144643.669344-1-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: MN_HQwoqVnGtLmYqW3u2al1ygq984qw8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDEyOSBTYWx0ZWRfXy73fkkDE6RSr
 My+8X17I9OI4UkJCkegTWUgYcEmNqggBQGJ9xEbSFk/E/z/a8cqEY6U1lk38dZ989yfuhvttABX
 g5JDbSB4a7bbzTAg7kZfUZf6LYWhKU1Svx4UbAEZyPhZ9ccimV3K8QyK8zO5ic/t9XFKwmY36t3
 PVdgOjk06xDdE+dH8rr4x0NyCdu6Y/Zj0X2B5HgZRiXy/Fd01FCfBgtVmEn7eR27EUzctenNf8c
 2fpzHNI9LdNJmNcB7WZ0Dx/7M6VSaiFs9tQUyK2cuOWFbvpxpCaZVE34I6SEMRRBJKuGSn2lS2r
 AxjJzuLy1K/wzVyvWOGELhoIN+kLvP7MfxNMROA77uBlL+eIg0Svf3300WYSzy9o5R5CB66Q6TS
 Y0RP0AI/ywruLd/64fXGleVs/kNqgWnNJmj881W90MB8cZWhYvV3SjdJHk9/9IbI9qvvKgl2X54
 Izn1YoNxP/hWEE/6uRQ==
X-Authority-Analysis: v=2.4 cv=RKK+3oi+ c=1 sm=1 tr=0 ts=695bcee2 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=g41jKqSBfOdEa1tnm9UA:9
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: MN_HQwoqVnGtLmYqW3u2al1ygq984qw8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 adultscore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601050129

Add UFSPHY, UFSHC compatible binding names and UFS devicetree
enablement changes for Qualcomm x1e80100 SoC.

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

