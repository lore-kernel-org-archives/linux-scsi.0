Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274F31A0712
	for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 01:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780017275; cv=none; b=pUFoa6y2yWaRSJolmJMGe6bW0Nh70YXdqYPs3WLjjM1H3+coZjqgY4cmaVas09sAyKXRELK8Id27RZbLnteX8LECsSv5OyNxjOGbItiCjM00mdsYIPxyY1kuhP5KN5y4PcP1iW1YWOXa3V0fAn0cAYD+GkKIK9HIgb0uArpYUwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780017275; c=relaxed/simple;
	bh=lmZEkV+ABUSxZgsGarhPI4Wy3vbhdAHCgPp6lcYxkCc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cl+uUAaePRUoxS0HEMtnHH/oFxW1kgJgLpDziiZ6t9h64CooYSVktGAFZDHVQ3Mwt5+l8eCaoJkNaVsbm1VViA233xC2ljb9G/U/+t5bGJrb/6pFbdvH4jrWq2p86/KQWXOwKvvVYk5/itMd/CfRrHw3W8KHtMrHRlHGbW1wKhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Yrk2wfjo; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Yrk2wfjo"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64SNtfWN2258579;
	Fri, 29 May 2026 01:14:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=4M79rtlpeAyrvQL2QBQ0pJgDVuYpyjmUEVG
	OHqGVJOc=; b=Yrk2wfjoFM2JAOTpdLOT9n/opBjBYGFHutDUpJAg5Qf5imr4XEK
	4XL8ryo6p2EBBbL/9BlE6dcYECTWmBaATmHJrAQHXTirP/KrhoRJsD3hhqolK4z5
	hJWkuIKxKTVbse5t1NSVp0Kg4MXakjM/06i5Z104oyIrHVfYRHgYfekqmBGNXu5Q
	p4Bq88OHZTHfgWMRJXw8UHG9nY4f/FZdWsPDJ04gMSt7IcNn4i4s7jpJ6tiKThjP
	ypf8+9Ew5IQcydfVN3gTGNmU2kE9h1VJMZWfakVBnprN7M2A9lJaWPy8kE8ZVF48
	8YtfoYnjxXfHyxFRsIgSfyNraJdmMLOm3hA==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eety51j3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 May 2026 01:14:23 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 64T1EMWX026151;
	Fri, 29 May 2026 01:14:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 4eerb83sxd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 May 2026 01:14:22 +0000 (GMT)
Received: from NALASPPMTA03.qualcomm.com (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64T1EMUE026140;
	Fri, 29 May 2026 01:14:22 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 64T1EMqh026136
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 May 2026 01:14:22 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 3BCD662E; Thu, 28 May 2026 18:14:22 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>
Subject: [PATCH v5 0/2] Add static TX Equalization settings support from DT
Date: Thu, 28 May 2026 18:14:18 -0700
Message-Id: <20260529011421.462046-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI5MDAwOSBTYWx0ZWRfX53Cr7l7n6VEK
 uS24cj7DQVxp82WQCmZjIE1WjwamXyPf+q1AGTptio2I9jtrj6UzbGh0XNVZahG9qT+qey5V5Ec
 MuhjRBMRnPVKB002UNCYpdOmV5LuzHhtYynnkeJdftVAk7wLAKUavzaC2D/iCaXEZNVHNAqMdOG
 2xYIwmPTcRp9SYvYmPRFvnxgPHgNDzvXEReZs/3cAmr8ZgMWMXckxgSg4NPLOvuDCq7Y54skOnu
 GONe9mxGUJDiJY8PTcp6Hd9eD509J6cbe30SLyySFEmDnpv8g/UMLvQHBWeI/sxM6NjcxX2/wcy
 gJ1GMkLJSodA2m6cZrOyh0/GBbGTR210gSRCWI/GjtWnmp8iWffOM6OJmeAH6jneDN7Fl25K4x3
 6QZM2lt2OUl/lLqRD0mRv9420xREcrooMLyYMRLnoxryxTbxLTWbqtlL9NYRbHHjdgj8kmBG9Pb
 60FysUWoul1Cdqg5DWw==
X-Proofpoint-GUID: dSmLsCgsRWwVsW0efpZIM5ZXal2HEvSG
X-Authority-Analysis: v=2.4 cv=WaM8rUhX c=1 sm=1 tr=0 ts=6a18e86f cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yx91gb_oNiZeI1HMLzn7:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=PU2HUsy48LbWZyxNEuoA:9
X-Proofpoint-ORIG-GUID: dSmLsCgsRWwVsW0efpZIM5ZXal2HEvSG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-28_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605290009

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
 drivers/ufs/host/ufshcd-pltfrm.c              | 137 ++++++++++++++++++
 include/ufs/ufshcd.h                          |   2 +
 4 files changed, 193 insertions(+), 1 deletion(-)

-- 
2.34.1

