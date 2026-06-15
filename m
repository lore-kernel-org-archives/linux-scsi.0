Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE44E37DE83
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 08:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781513448; cv=none; b=F8YlM/497bqkWhjcXTtXuf3WMyqkra4JzeI3V+ZbO/LNWZ7e2wEWTD6nSji2qqTCq5VEEYnELnM4wkdIqnVsQiq65k4aTaAquPcwIQLH/udzcacAURF0giU1Gnuhe5E5sT5ofHinx+X81+kam37CHq/L4az7MRpE3wRCL1yOCnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781513448; c=relaxed/simple;
	bh=kCSlbx5jQs+uYK+purP1D+A4NGJKM+wHYYQg93EXBFc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iieSGfhdrqDH471Kd4WJqyW86ohaVBqqxCpPvH5cLXJ7pcK5OGlYrE+dFgJypf8u86O74QJ/7CdAUjUHma2yqFlah6/NfkTb0GHwx518a7R2Pa8lISFlTsR/fglTgWgprd1tBxrl3DY37ljDGePCLsijYUYVkQDQ1dVoR4kPI34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hI+pNwQC; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hI+pNwQC"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65F6J3Gh3327636;
	Mon, 15 Jun 2026 08:50:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=Vm2vH5tzpXn5xQ5qgX0iHH83w3g0qnkbHiS
	EO+Dd2NI=; b=hI+pNwQC1DWNE56sCietifJCPpIq4eojPTdrk9v0wi5wUWhoDoI
	GgU48LJC98WcFZmQUFy8Mlu5HDVmZvR5fr7wY5GWF8M4Lt96HkN6f9crfnC8qwtk
	vCfvN6VC0SfJC2+k2dmNOwMH5XEJMfZEOFQUQffdufsYUwrMNOVTWna/NqzQ2oEt
	8kUBrFtZTqgtvnzVLKUZzz8TLAXctAdJvlMuDwO7dv8OqQNcSgI4ODIlecA0aKFg
	wJxSR5exCtNqemUSyNp23z3fKXer2GiU6xWggjHgVnelLEaF8EKz55Nc4NrVBOK6
	h5o6/vD8pdcFvvs35PKDd2MjUlQwjuBkySg==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4es0cgpc7y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 08:50:29 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 65F8mLpV001165;
	Mon, 15 Jun 2026 08:50:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 4es09ja4tu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 08:50:28 +0000 (GMT)
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 65F8oSuW006222;
	Mon, 15 Jun 2026 08:50:28 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 65F8oRVk006217
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 08:50:28 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id CE416656; Mon, 15 Jun 2026 01:50:27 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: krzk@kernel.org, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>
Subject: [PATCH v8 0/2] scsi: ufs: Add support for static TX Equalization settings
Date: Mon, 15 Jun 2026 01:50:24 -0700
Message-Id: <20260615085027.2102882-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: L3p9ofHxgyLeYg5bTAVOZ1-VShqkJYHX
X-Authority-Analysis: v=2.4 cv=NPLlPU6g c=1 sm=1 tr=0 ts=6a2fbcd5 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=DJpcGTmdVt4CTyJn9g5Z:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=-6uHncHyrKnbPZfOGhcA:9
X-Proofpoint-GUID: L3p9ofHxgyLeYg5bTAVOZ1-VShqkJYHX
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDA5MiBTYWx0ZWRfXyDJnXf+LumhA
 KZr6QRTqYQhY/y8XogUyNZGDYpYNTahNEkA+7sfNSICdK6BTs8vgpDf9dW1jT7jhtg1VySAJfey
 YhXcSwpQ29DgKJBMB6+syyjacTjdQ84=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDA5MiBTYWx0ZWRfX1IhkFCq3ZRR1
 mycBmCgarB0bsOc237dTFd5zYUh9/IaD+JAj+M+hsBrsPnAwK5Xasrsuv3AJHEznoxH5xKXpfIz
 ueHXBCsNl8m+QXV6DEQ35DxptdGc+Al7vDa09JzwrPMfQpWavXsyxvQY3Sijm7kn9D+HMlrAtzp
 wRMj4QmQHebNeofGMSmh2DryMQAine2NtnTDd9OO0M3HyZr9OWY1ekzK5Ww+BzlrmmX9tdOiFXC
 QNThXhiJwG92znA6OSNZvQgLx+W6f0sLvQsGEzwX8f3xJTTYNfTylYSs/ty7U0COFDykzGj7PjV
 pFGo5Rf0d48Yk3JOONa+uqhY6/hOtqgey5tHny87kTonu5UPwI40gI6GrR7xfSCttY6sDZCTt8D
 vH3it0DsF7W424nrZCgt7WAVeWtiqv9kfT0LcAA8otibOIQMGTqbjV8liIcdE5rrip5RXP6FrQg
 fN9jMGLNgLzTIUCd7kQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_02,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150092

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

 .../devicetree/bindings/ufs/ufs-common.yaml   |  55 ++++++
 drivers/ufs/core/ufs-txeq.c                   |  15 +-
 drivers/ufs/host/ufshcd-pltfrm.c              | 156 ++++++++++++++++++
 include/ufs/ufshcd.h                          |   2 +
 4 files changed, 227 insertions(+), 1 deletion(-)

-- 
2.34.1
