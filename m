Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFD43D75C7
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 11:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780054433; cv=none; b=KTpJZ2gEUXgEYVRdiJTegTx0y5vo/2YtOLV/eei41luutnJ03qFs+kyQhlT364T2nL06jJ7seoyqR9ZZoLm6sD5tGNZQo5edCFNPkAOc6+aSTuJE969Uyf8jAfJVBV3hWAFgOpqWTRh4P2VXSZ8YOm699HcHstgIEdz+sVW1VJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780054433; c=relaxed/simple;
	bh=rLs1t0xB6kj4RK5r28DQ76/jaka5xe0q/GEj++rE1qQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=S7EuyP+FBilTVbf7tuFxkW1z5SzN2pC25x1G8fqq0eFvLAkOKEuH39N+l9lu3vRiVLsQ6MYLlQtq+e/t5ucDFXh3cti4TQAwQ/eQDa3q1V8rMz0NCtX/ro4PMTbHShwU226UiDKaJ9Axdduy0+ePpYfLljBhhptShVUpBQvw0l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FzcRialI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FzcRialI"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64T6fpIM1388067;
	Fri, 29 May 2026 11:33:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=lEflP1EdXzIN10WHffFQS/5tvAROHdoCAun
	Y6i6XiZU=; b=FzcRialIUPcCIEBEMVSBGUux7Drx9EcJ2y0eLSo1wewm4opiS/x
	JPoDWgeTC3Rk1jAclZUE/FC/zHOb9NRrICaFXsmBTWkAxn5sDeEUICxqQwBHRg+e
	fqzFGIObZI/xP0yGj7Q/hQalgK85O2vvdYQBWZ+8pNTMaOYzs7ZNktpehkwkLug/
	pCDotDQr22Gsmj/ysRsUTi5dWea2LrthADXqiB6x63TGS6BnlHC2mgSKhZUvUlYY
	ZZ+9cWACcmB246mJEAgnPV69BdRZg5Q7kP9sN8FDf8kB/1zdh5LX7sjGvqmKiFIH
	MDj/SyoKZW7LPINMRrgoVOK7DV1dqrPi2Aw==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eevumu9d4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 May 2026 11:33:41 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 64TBUAHd011265;
	Fri, 29 May 2026 11:33:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 4ef1qkccfh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 May 2026 11:33:40 +0000 (GMT)
Received: from NALASPPMTA04.qualcomm.com (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64TBTpX5009772;
	Fri, 29 May 2026 11:33:40 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 64TBXdMD017899
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 May 2026 11:33:40 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id C1D8F62E; Fri, 29 May 2026 04:33:39 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>
Subject: [PATCH v6 0/2] Add static TX Equalization settings support from DT
Date: Fri, 29 May 2026 04:33:36 -0700
Message-Id: <20260529113338.984301-1-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-GUID: Aal1Q9TGN4zbwzaOHoUj43FNTRFdILVt
X-Proofpoint-ORIG-GUID: Aal1Q9TGN4zbwzaOHoUj43FNTRFdILVt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI5MDExNSBTYWx0ZWRfX0/4HahgP7ljo
 7/z/pGSbFexGxIvMl/Lx65QAIGRmiEAMHP2oStfJEocKe8xPNbvUQWGAiKxv2Sev1KcqLrBh54D
 FDDFfO3secc0CUml4aE++19lInZrFpLqpJrPV0+mPcF3a8GB4uHN8mgF5kzGGnGS84zq469WqA1
 9DSHygmipl1Oz7ghCG0X30lcHMNaEESTA13S7/Iak9IC1XfjXqFR05hDkYOSaLwb1C9NSYPYQyp
 C1nQnJo3QlCioCLkto3DTPSJknT7Bf58uDFTDFaviDeKlVefaBfBL/5kSUyZHBztzdlBkf9ksZN
 Aj41e19kyUAmLc8Hs8UEwBe7br4ZunmogUHKYlSR7qCtdjtXFHIB3en8HTcbV9CQTKauklhC95L
 /8FXUyCDR8VK/vk3G6upioHaY3Hz6KLInYv7d+HXm4p/S/g7B7+MVztccpn7JEso4i2Z7rsEXHC
 UNQ1PJToUkeh7e3PJyg==
X-Authority-Analysis: v=2.4 cv=cObQdFeN c=1 sm=1 tr=0 ts=6a197995 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=PU2HUsy48LbWZyxNEuoA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-29_03,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 clxscore=1015 spamscore=0 malwarescore=0
 phishscore=0 suspectscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605290115

Hi,

This series adds support for board-specific static TX Equalization settings
provided through device tree.

This series is based on the earlier TX Equalization enablement work and
persistent storage/retrieval of optimal TX Equalization settings work:
https://lore.kernel.org/all/20260325152154.1604082-1-can.guo@oss.qualcomm.com
https://lore.kernel.org/all/20260424151420.111675-1-can.guo@oss.qualcomm.com

Background
==========

UFS v5.0/UFSHCI v5.0 add HS-G6 support (46.6 Gbps/lane) via UniPro v3.0
and M-PHY v6.0. In these specs, TX Equalization is defined for all High
Speed Gears (not only HS-G6) to compensate channel loss and improve signal
integrity at high speed operation.

For HS-G6, M-PHY uses PAM4 1b1b line coding, Pre-Coding may also be
required depending on channel characteristics.

Add vendor-neutral DT properties:
- patternProperties: txeq-preshoot-g[1-6], txeq-deemphasis-g[1-6]
- fixed property: tx-precode-enable-g6

Each property is a uint32 array of per-lane tuples:
<Host Lane 0 Device Lane 0>, [<Host Lane 1 Device Lane 1>]

Accept 2 or 4 values (x1/x2 lane configs). PreShoot and DeEmphasis values
are 0..7. Precode enable values are 0/1 and only applicable to HS-G6.
These patternProperties carry board-level SI characterization data used as
static TX Equalization settings for each High Speed Gear.

Relationship with Adaptive TX Equalization
==========================================

Adaptive TX Equalization remains the primary path when enabled.

Static TX Equalization settings from DT are board-specific baseline values,
but when adaptive TX Equalization is used, static settings are not final:
- If valid settings are retrieved from qTxEQGnSettings/wTxEQGnSettingsExt,
those retrieved settings override static DT settings.
- If retrieval is not available/valid, TX EQTR runs and trained settings
override static DT settings.

So static DT settings are a fallback and are intended for cases where
adaptive TX Equalization is not enabled/used.

No behavior changes for platforms that do not provide these properties.

What this series adds
=====================

1. dt-bindings:
- Document `txeq-preshoot-g[1-6]`, `txeq-deemphasis-g[1-6]`,
  and `tx-precode-enable-g6` in `ufs-common.yaml`.
- Define per-lane tuple format:
  <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>].
- Add per-property value validation ranges in schema.

2. UFS core/platform integration:
- Parse and validate per-gear DT TX EQ settings during platform init.
- Store parsed values into per-gear TX EQ params and mark them as static.
- Integrate static-state handling in TX EQ flow so static entries are
  handled through the adaptive TX Equalization path and then converted to
  normal runtime params.


v5 -> v6:
- Use num_elems instead of count in the per-property validation loops for
  clarity (patch 2).
- Change else if (lpd > UFS_MAX_LANES) to a plain if after the !lpd early
  return, per kernel style (patch 2).

v4 -> v5:
- Extract the body of the per-gear for-loop in ufshcd_parse_static_tx_eq_settings()
  into a new helper ufshcd_parse_tx_eq_settings_for_gear() to reduce indentation
  depth (patch 2).
- Mark lpd and num_elems as const u32; rename sz to num_elems for clarity; use
  %u format specifier to match (patch 2).
- Replace size_t with u32 for the element-count variable (patch 2).
- Emit dev_warn() when lanes_per_direction exceeds UFS_MAX_LANES (patch 2).

v3 -> v4:
- Add Acked-by from Manivannan Sadhasivam to patch 1.
- Remove spurious dev_err() on the lpd guard in patch 2 (lpd == 0 is
  normal on platforms without lanes-per-direction in DT, not an error).
- Improve comment above the is_static condition in patch 2 to read
  "valid but static, i.e., populated from DT" for clarity.

v2 -> v3:
- Split the DT TX EQ binding into semantically separate properties:
  txeq-preshoot-g*, txeq-deemphasis-g*, tx-precode-enable-g6.
- Place tx-precode-enable-g6 in `properties` (fixed key) instead of
  `patternProperties` to satisfy dt-schema meta-schema rules.
- Restrict precode property to HS-G6 and document per-property ranges.
- Update the core parser to consume split properties.
- Drop unrelated `arch/arm64/configs/defconfig` changes from patch 2.

v1 -> v2:
- Improved the commit message of patch 1.

Can Guo (2):
  dt-bindings: ufs: Document static TX Equalization settings properties
  scsi: ufs: core: Add support for static TX Equalization settings

 .../devicetree/bindings/ufs/ufs-common.yaml   |  45 ++++++
 drivers/ufs/core/ufs-txeq.c                   |  10 +-
 drivers/ufs/host/ufshcd-pltfrm.c              | 139 ++++++++++++++++++
 include/ufs/ufshcd.h                          |   2 +
 4 files changed, 195 insertions(+), 1 deletion(-)

-- 
2.34.1

