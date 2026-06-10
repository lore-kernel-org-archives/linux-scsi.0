Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896DE30C608
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 07:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781075746; cv=none; b=c8nEip/b7bSIOqBth0btwck0W6TitTyF1YDP0FZ2UqDj/hGALDyETeSsoRpULm6m68Wb7KE0+6wSXnODA7K/wDkoBOF26BHgqUZlR9C7+UZ25CBC831E10v3ETdqofUUwijHxkTwW0VtleApnkrlXWxe9MYNdUf8Z+W2jcv28Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781075746; c=relaxed/simple;
	bh=uzQviwg0swJMV7rORH/REMfefStidLRoVVMQs1WgDYE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SqYpmZxV9CJk8h5nKK0XDSmxLcuo0lOL3iur9viyLj4pGf/eY45JlaX+1sgGIpzYwYVkz3xwSeDNtWnWzjD3LurTKQ8J/4CugdFHVQ7cvEDeFm0bOc0B7MRP+0Nad+umQV0PODV8XkeqI3KRcTtJSzrelk+CxSDL9Ph+Qt4jVd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eanyD8ft; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eanyD8ft"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65A5Sgtm688926;
	Wed, 10 Jun 2026 07:15:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=flZIXKpJY0hkcpSInQMxtqSseU3JL3rVFPl
	dAKgMje4=; b=eanyD8ft049yF+xtJx4PD5rwS3aa1sCSD+vhSIQksVSvPT8CUd2
	+6q7wt+zI+KjkCOiNkBiCyLrO9z4ogxhbt5gaaKQ4z09AgDHVM1JrLajdt7ZoTkW
	SeAAeyOmOwahdKJsbkvBztTPI+G71qB9d6Eh+VwVIJcU+RPfFjLrcSG1haVoXCV0
	DDwXVndrM+7WKUGtgl7vTgP5RoJ55xPvyc1AEkmXerE/8+A3ztyeqiXbrxLwd/q/
	L30TQ4HV+kT6xWe6gvT8WTBuQxRoD1PNo/WvaEdyGHjgDo2v+4ZGb6Ck5RFqaFD5
	3TqTOlsWvH7eTotUyeQgriwJBhsR5LDdMpw==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eq1tg0cd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jun 2026 07:15:20 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 65A7FJ12005880;
	Wed, 10 Jun 2026 07:15:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 4epg0b31fh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jun 2026 07:15:19 +0000 (GMT)
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 65A7D3j0001676;
	Wed, 10 Jun 2026 07:15:18 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 65A7FIjF005809
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jun 2026 07:15:18 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 1D0DF619; Wed, 10 Jun 2026 00:15:17 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: krzk@kernel.org, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>
Subject: [PATCH v7 0/2] scsi: ufs: Add support for static TX Equalization settings
Date: Wed, 10 Jun 2026 00:15:13 -0700
Message-Id: <20260610071516.3763916-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-GUID: heNvPVWdVuf6dYVbh9PhRNKvRFML5tm9
X-Authority-Analysis: v=2.4 cv=dLmWXuZb c=1 sm=1 tr=0 ts=6a290f08 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=gowsoOTTUOVcmtlkKump:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=XdTHD_4Rer6ofGn37IEA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEwMDA2NyBTYWx0ZWRfX+N1A1Jv87LIX
 PAHSPG32jaAGSf0G2S9UcBmuQR9LfAzmI14F8VjBK/opfHn3tWUb1QEEJAEs9H+Bw5F5GGycUVI
 3a04UKQ3hq0P1d9O4gg+ZyiBdzN7w+vC0xUO2CxmFzcHKmmOTNSzgC0MUM4lAloOnJtwZIgyxCb
 m6dmorpEUSVd+RG97NyB/DXjlxdIy9ZxS2ubuy6dVzBJ+y1gkXKbb4mshpNGnUO07dTX0Kc963p
 bSPxIb7JBd5ZToxdcefv+yM0DmrVShGCrDqcaLoXjVZFbIhNKJdDoe1Ts12+IEWYjMhgmHAk/sR
 LkcJp729MCNBZkSOGk0paZ1mN4yAhx0s16bLPdkOCK0nkMiqx41/ci9J1CztyfeMFrkPq/cDzyB
 Stypmm70HxxP28gjx2ZM7bVKT/Z2LUikqi80luBjc5sMkppEl0TocMDKWextqFxdPdDENC3dyIU
 6XinjNuvoMHL44F9f2g==
X-Proofpoint-ORIG-GUID: heNvPVWdVuf6dYVbh9PhRNKvRFML5tm9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-10_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 phishscore=0 adultscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606100067

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
- fixed properties: tx-precode-g6-host-lanes, tx-precode-g6-device-lanes

`txeq-preshoot-g[1-6]` and `txeq-deemphasis-g[1-6]` are uint32 arrays.
`tx-precode-g6-host-lanes` and `tx-precode-g6-device-lanes` are optional
u32 lane-index arrays for host-side and device-side TX respectively.

Accept 2 or 4 values (x1/x2 lane configs). PreShoot and DeEmphasis values
are 0..7. For precode, listed lanes are enabled and unlisted lanes are
disabled by default.
These properties carry board-level SI characterization data used as
static TX Equalization settings for each High Speed Gear.

Example DTS snippet
===================

The following x2-lane example shows the expected DT encoding:

	ufs@1d84000 {
		lanes-per-direction = <2>;

		txeq-preshoot-g6 = <1 2>, <3 4>;
		txeq-deemphasis-g6 = <0 1>, <2 3>;
		tx-precode-g6-host-lanes = <0 1>;
		tx-precode-g6-device-lanes = <1>;
	};

PreShoot & DeEmphasis numeric encodings
=======================================

The DT properties carry numeric encodings in the range 0..7, as defined by
the UniPro/M-PHY specifications. Interpretation (including mapping to dB
levels) is normative in the M-PHY specification. The tables below are
informative convenience text only.

PreShoot numeric encodings mapped to dB levels:
0: No PreShoot selected
1: PreShoot of 0.4 dB selected
2: PreShoot of 0.8 dB selected
3: PreShoot of 1.2 dB selected
4: PreShoot of 1.6 dB selected
5: PreShoot of 2.5 dB selected
6: PreShoot of 3.5 dB selected
7: PreShoot of 4.7 dB selected

DeEmphasis numeric encodings mapped to dB levels:
0: No DeEmphasis selected
1: DeEmphasis of 0.8 dB selected
2: DeEmphasis of 1.6 dB selected
3: DeEmphasis of 2.5 dB selected
4: DeEmphasis of 3.5 dB selected
5: DeEmphasis of 4.7 dB selected
6: DeEmphasis of 6.0 dB selected
7: DeEmphasis of 7.6 dB selected

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
  `tx-precode-g6-host-lanes`, and `tx-precode-g6-device-lanes` in
  `ufs-common.yaml`.
- Define optional lane-list encoding for HS-G6 precode:
  listed lanes enabled, unlisted lanes disabled.
- Add per-property value validation ranges in schema.

2. UFS core/platform integration:
- Parse and validate per-gear DT TX EQ settings during platform init.
- Store parsed values into per-gear TX EQ params and mark them as static.
- Integrate static-state handling in TX EQ flow so static entries are
  handled through the adaptive TX Equalization path and then converted to
  normal runtime params.


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
  txeq-preshoot-g*, txeq-deemphasis-g*, tx-precode-g6-*-lanes.
- Place precode properties in `properties` (fixed keys) instead of
  `patternProperties` to satisfy dt-schema meta-schema rules.
- Restrict precode property to HS-G6 and document per-property ranges.
- Update the core parser to consume split properties.
- Drop unrelated `arch/arm64/configs/defconfig` changes from patch 2.

v1 -> v2:
- Improved the commit message of patch 1.


Can Guo (2):
  dt-bindings: ufs: Document static TX Equalization settings properties
  scsi: ufs: core: Add support for static TX Equalization settings

 .../devicetree/bindings/ufs/ufs-common.yaml   |  61 +++++++
 drivers/ufs/core/ufs-txeq.c                   |  10 +-
 drivers/ufs/host/ufshcd-pltfrm.c              | 159 ++++++++++++++++++
 include/ufs/ufshcd.h                          |   2 +
 4 files changed, 231 insertions(+), 1 deletion(-)

-- 
2.34.1

