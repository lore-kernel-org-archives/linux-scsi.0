Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BEE33F8A6
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 11:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781609640; cv=none; b=Ou/IGQJ3ktu8jXXkhk2ggTzKcdT8DEF3hfzkOwvAlLx7zhJ6paZwoMarATurkyvbQx+Z8vXQqx69U0vRadECvpW6DFIqOm8h1hY+gLFnNJNTfALctTmxnEtDgtcMcglPokD5ijIhElMcbek4wVCH64gjuITKQyKS37LKj2THBGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781609640; c=relaxed/simple;
	bh=0ysLonqTPdY1Ri3IOsnqonGQxVeQZcbc3YX5nEQSd0Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hTru/qb4auEJYf5YSLDmSxFh1eKlqUSiBtPR1FmMzvHRcS0BPi3bcWeZu7R3CIzVzOskZ5y0gVb4uHyMq3ZEzavCOZwzySK2WZB8IvJnq2A5l7SB+x47Be40e+QdgcSTJbm3BD369jmrFTV8pACuxPGHo3FqtXXqkAaiQRMeIvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PwHXV5WN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PwHXV5WN"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65GA9LFX1414438;
	Tue, 16 Jun 2026 11:33:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=aHn/TVohK7c+B5ytpJ0P98w5CHtjTL0fBjf
	oHyypD+k=; b=PwHXV5WN47xH9NP/QMXNrTURERj0v46xQBXvxEoEhxjq7K3kFAF
	XbgWb7y/HiIsYU8T40Sakw6oUfz/yeKT2j+JHI8jdgElOIDNrJzr5CgVR3LH30z0
	HvyneXAIVuYo1avqzR6dMPqGk0yj3/KHoTAD7mY0R0bl7vI/2/b32oKkIyYEygTz
	TTLPgPvzC96LJRSmRCmpr8CS3sPvJ9UTWgrbVPZmfkHbMzRiHZQA0yEPs71jEEj4
	LVUeE5Lfc/BEo72E/7EnVg7I3bLEWK2smB7ZxX0eh0ws8xrOBPJth+YDvAlFBCP4
	RgAUoafLpA3T+fIbUVV7alNKZZdCfoe1wjQ==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eu3ct0mhy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jun 2026 11:33:50 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 65GBXnVs014949;
	Tue, 16 Jun 2026 11:33:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 4etk1at1tj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jun 2026 11:33:49 +0000 (GMT)
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 65GBXn1c014838;
	Tue, 16 Jun 2026 11:33:49 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 65GBXn6q014765
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jun 2026 11:33:49 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 4BAE5654; Tue, 16 Jun 2026 04:33:49 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: krzk@kernel.org, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>
Subject: [PATCH v10 0/2] scsi: ufs: Add support for static TX Equalization settings
Date: Tue, 16 Jun 2026 04:33:46 -0700
Message-Id: <20260616113348.1168248-1-can.guo@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=SoCgLvO0 c=1 sm=1 tr=0 ts=6a31349e cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=Um2Pa8k9VHT-vaBCBUpS:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=XdTHD_4Rer6ofGn37IEA:9
X-Proofpoint-GUID: decUw4FFQsS0P1b3prTOxLmiRt8Db7c8
X-Proofpoint-ORIG-GUID: decUw4FFQsS0P1b3prTOxLmiRt8Db7c8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDExOCBTYWx0ZWRfXwmZTWfDu8QtT
 b7AGWIGJnCr1dzPipNx+XGWsvPTIP3fM+KM3GREQOcsoPEp1f0FVTbs+xSSYFT2Sf2N8iKvKYpU
 cjkQ/2FO9kZOlufQTqLN9hVFTc+I+esJ1DfQ/PL+Sf6W+llWpfxYi/V8qi3WwbQbVsDSQGKjUoN
 R7mvE4cNXw/fWohbUX0mwtk3GBEcCh+k9X01MoGBxGl7gc1nnUyeJSiyMwRAyIM7BLPDgZ6nmTV
 C0L/OPbxk0IHqnNikzWZrJKsVKJ6z2C9scicBNOWNUY414QTSLmcxulhasCWNDliwIfNWQuMCJ7
 TR8fkLQh90GiV7SRxICnOl8cZfai28k8g7FS9gm3CpYSNcQp11jTX/XMTWAHKoGvCEwQmQcmkKR
 swYnWP3Puk119EqhbqdFKPvpsTk9rF+naexWOjBvxOKqgfPt/b33UZMeSb1YYG9zynT8TspIGsF
 qHNX3cuHMgXtpFVGZjQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDExOCBTYWx0ZWRfX8tUzcFCjuI0C
 8Ql6u08GEH5udCuwMl/jRbJ3HMfrzbsJnbUOLjACUwYLW7P4feQL0qhuHGpcq8uybW/opcubNKj
 bIMBRuuvuoBewEezpFsHbIGWC8LBQ70=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_03,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 clxscore=1015 spamscore=0 phishscore=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606160118

Hi,

This series adds support for board-specific static TX Equalization settings
provided through Device Tree.

This series is based on the earlier TX Equalization enablement work and
persistent storage/retrieval of optimal TX Equalization settings work:
https://lore.kernel.org/all/20260325152154.1604082-1-can.guo@oss.qualcomm.com
https://lore.kernel.org/all/20260424151420.111675-1-can.guo@oss.qualcomm.com

Background
==========

UFS v5.0/UFSHCI v5.0 adds HS-G6 support (46.6 Gbps/lane) via UniPro v3.0
and M-PHY v6.0. These specs define TX Equalization for all High-Speed
Gears (not only HS-G6) to compensate channel loss and improve signal
integrity at high speed.

For HS-G6, M-PHY uses PAM4 1b1b line coding. Pre-Coding may also be
required depending on channel characteristics.

This series adds vendor-neutral DT properties:
- patternProperties: txeq-preshoot-g[1-6], txeq-deemphasis-g[1-6]
- fixed property: tx-precode-enable-g6

All properties use per-lane Host/Device tuples and accept 2 or 4 values
for x1/x2 lane configurations:
- txeq-preshoot-g[1-6]: values 0..7
- txeq-deemphasis-g[1-6]: values 0..7
- tx-precode-enable-g6: values 0/1

These properties carry board-level SI characterization data used as static
TX Equalization settings for each High-Speed Gear.

Example DTS snippet
===================

The following x2-lane example shows the expected DT encoding:

	ufs@1d84000 {
		lanes-per-direction = <2>;

		txeq-preshoot-g6 = <1 2>, <3 4>;
		txeq-deemphasis-g6 = <0 1>, <2 3>;
		tx-precode-enable-g6 = <1 0>, <0 1>;
	};

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
- Document txeq-preshoot-g[1-6], txeq-deemphasis-g[1-6], and
  tx-precode-enable-g6 in ufs-common.yaml.
- Define tuple encoding for host/device values per lane.
- Add per-property value validation ranges in schema.

2. UFS core/platform integration:
- Parse and validate per-gear DT TX EQ settings during platform init.
- Store parsed values into per-gear TX EQ params and track DT origin using
  the from_dt flag.
- Integrate static-state handling in TX EQ flow so DT-provided entries are
  fed through the adaptive TX Equalization path and then converted to
  normal runtime params.

v9 -> v10:
- Incorporated review comments from Bart (patch 1).
- Included Reviewed-by tag from Krzysztof Kozlowski (patch 1)
- Included Reviewed-by tag from Manivannan Sadhasivam (patch 1 & 2)
- Included Reviewed-by tag from Peter Wang (patch 1 & 2)

v8 -> v9:
- Fix DT schema shape for TX EQ properties to use proper uint32-matrix tuple
  form (nested rows) for tx-precode-enable-g6, txeq-preshoot-g[1-6], and
  txeq-deemphasis-g[1-6].

v7 -> v8:
- Replace split HS-G6 precode lane-list properties
  (tx-precode-g6-host-lanes/tx-precode-g6-device-lanes) with a single
  tx-precode-enable-g6 tuple property in the binding.
- Update parser in patch 2 to read tx-precode-enable-g6 as Host/Device
  tuples and validate full lane coverage and 0/1 values.
- Rename is_static to from_dt for clearer semantics in TX EQ params.
- Update commit messages for clarity and consistency.

v6 -> v7:
- Add DTS properties example in the cover letter.
- Replace tx-precode-enable-g6 tuple encoding with split lane-list
  properties:
  tx-precode-g6-host-lanes and tx-precode-g6-device-lanes.
- Update parser in patch 2 to read optional u32 lane-index arrays and
  treat unlisted lanes as precode disabled.
- Refactor patch 2 TX EQ property parsing to share a single helper for
  txeq-preshoot-gN/txeq-deemphasis-gN array read and validation.
- Dropped Reviewed-by/Acked-by due to code changes.

v5 -> v6:
- Use num_elems instead of count in the per-property validation loops for
  clarity (patch 2).
- Change else if (lpd > UFS_MAX_LANES) to a plain if after the !lpd early
  return, per kernel style (patch 2).

v4 -> v5:
- Extract the body of the per-gear for-loop in
  ufshcd_parse_static_tx_eq_settings() into a new helper
  ufshcd_parse_tx_eq_settings_for_gear() to reduce indentation depth
  (patch 2).
- Mark lpd and num_elems as const u32; rename sz to num_elems for clarity;
  use %u format specifier to match (patch 2).
- Replace size_t with u32 for the element-count variable (patch 2).
- Emit dev_warn() when lanes_per_direction exceeds UFS_MAX_LANES
  (patch 2).

v3 -> v4:
- Add Acked-by from Manivannan Sadhasivam to patch 1.
- Remove spurious dev_err() on the lpd guard in patch 2 (lpd == 0 is
  normal on platforms without lanes-per-direction in DT, not an error).
- Improve comment above the is_static condition in patch 2 to read
  "valid but static, i.e., populated from DT" for clarity.

v2 -> v3:
- Split the DT TX EQ binding into semantically separate properties:
  txeq-preshoot-g*, txeq-deemphasis-g*, tx-precode-g6-*-lanes.
- Place precode properties in properties (fixed keys) instead of
  patternProperties to satisfy dt-schema meta-schema rules.
- Restrict precode property to HS-G6 and document per-property ranges.
- Update the core parser to consume split properties.
- Drop unrelated arch/arm64/configs/defconfig changes from patch 2.

v1 -> v2:
- Improve the commit message of patch 1.


Can Guo (2):
  dt-bindings: ufs: Document static TX Equalization settings properties
  scsi: ufs: core: Add support for static TX Equalization settings

 .../devicetree/bindings/ufs/ufs-common.yaml   |  58 +++++++
 drivers/ufs/core/ufs-txeq.c                   |  15 +-
 drivers/ufs/host/ufshcd-pltfrm.c              | 155 ++++++++++++++++++
 include/ufs/ufshcd.h                          |   2 +
 4 files changed, 229 insertions(+), 1 deletion(-)

-- 
2.34.1

