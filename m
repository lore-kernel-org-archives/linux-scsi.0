Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA5438F251
	for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 13:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779544054; cv=none; b=OZBOSpUU6tBhzXjPmLGueTIeneZyJOVmu0FTQ3G14/OveGciZIKNX/xVmeyeyM+3tidWmch5MGP6Eye1c+ATYq9T5M+hk+cNmfDnk6Svyjftvv99YpzAzUU83betImNaan1J6SD8nkfAPrOjEr00HVt1bBKHQ0EABtkW6PViX68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779544054; c=relaxed/simple;
	bh=k/mcuSRHwTFgtu+FciEXYjQ0vWINqaIzGSUzSylC1bQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=axPhXr9BRF/X51XkqJCHuKaA51g+BwBbjJiAxZmf33vSsYeV7+LQ5TJ2/wqE9FDfX7n5OemrZSUCLtH4UDNWo0l8JYVEvoTk1iKvPzFONdmU7s0e894BZ3eYyFzgx5Jc4bF8qVbDvUQ0VD4VunwEa0iuo4O3QaHl40obzrSyn2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Jn117R7J; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Jn117R7J"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N3ZJ1V4027569;
	Sat, 23 May 2026 13:47:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=dyy9X+s2t9wmY6ED1NOEfPYMwyF7GknY1tE
	F0r67N0M=; b=Jn117R7JeqD+9gmYDQk9hqSYCNmOitUPfYIPVSwWSyr6JYTrFEz
	X1KcPgoQW4g5ebS4kgKwfrzOdfs/i697UXHNt71NuBD1zAqd7K/3npa/Gq+nNRQ9
	/sNDU0RMH5UzyI2zkOzAXQsmGI3cNcGK8ut8myjVA3h1RAnQp5V+X18BmziPywys
	w+DleBGNPatGAaqhVZecvr8zTcQoB8HabL/vGH6UYOM+zDH1F1RNg5D0rueUramy
	LJZ5jKDQDgN10ZpT0JATJ9vtP0TfNLBcCZbWdCewnApLg5dHTgFaLRKFlU9tsMFa
	/tkD/D08Zl3MDMf5VuYq4fgKmyEn8SAO+jg==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eb4f392g5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 May 2026 13:47:14 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 64NDlEsI031952;
	Sat, 23 May 2026 13:47:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 4eb5ahayu8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 May 2026 13:47:14 +0000 (GMT)
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64NDlDWl031947;
	Sat, 23 May 2026 13:47:14 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 64NDlD4b031943
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 May 2026 13:47:13 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id AEE5061F; Sat, 23 May 2026 06:47:13 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>
Subject: [PATCH v2 0/2] Add static TX Equalization settings support from DT
Date: Sat, 23 May 2026 06:47:09 -0700
Message-Id: <20260523134711.323425-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: dDE5IcN9NQLNs7vVjErwBv1Qden4k1gE
X-Authority-Analysis: v=2.4 cv=WvYb99fv c=1 sm=1 tr=0 ts=6a11afe2 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yOCtJkima9RkubShWh1s:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=4ajky533VDcJp0aEe7MA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDE0MSBTYWx0ZWRfX8BI88ttSJD2H
 FHWdCagX/28wBxir3Hdon6aB6qlno5ga5dIeBZEoxQYNS2aWrO5OGWWifd1B1Hltzt55PifChRE
 vKq4HxgHRxnmWgDe8Nt+ixzS5ACiSywMPJwoqu3TB/HFLcjwoPS7d0C3lewMORF/xpTvfv1sNjF
 kE8RUVKXkGgaXd505Xby7HfCtjzkpLFqqX0EcdiZgWOZlGyr0DcUQB+uJVfCdju+nBIYcMmpJma
 Rn0Ek2iPYf+2moHkot8scgjuRssDk9aIkgffzxJ9wHaNsrViWGnFxcBNJhA4QAuKWRsCpL++lEc
 N9rtmpdrWFzSIofj8iu62465zK5vh8KsZpd409oTbKiRxoZpV2wf+b4ZWKhueIfbhS5q4ez/eU1
 rWsbhIeaGGqaDDROzHBPZ1gJ8Id4SL8m9F/ja7ZNObjq1ujJBy3LvVffZwbw3zKlFxflXJOJ9dC
 i/xJt88JfouEp9Eug/g==
X-Proofpoint-GUID: dDE5IcN9NQLNs7vVjErwBv1Qden4k1gE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-23_04,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0 impostorscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605230141

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

Add vendor-neutral DT patternProperties:
txeq-settings-g[1-6]

Each property is a uint32 array of per-lane tuples:
(PreShoot, DeEmphasis, PrecodeEn)

Tuple order is:
Host Lane 0, [Host Lane 1], Device Lane 0, [Device Lane 1]

Accept 2..4 tuples (6..12 u32 values) to cover x1/x2 lane configs. These
patternProperties carry board-level SI characterization data used as
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

No behavior changes for platforms that do not provide `txeq-settings-g*`
properties.

What this series adds
=====================

1. dt-bindings:
- Document `txeq-settings-g[1-6]` in `ufs-common.yaml`.
- Define tuple format as `(PreShoot, DeEmphasis, PreCodeEn)` in lane order:
Host Lane 0, [Host Lane 1], Device Lane 0, [Device Lane 1].

2. UFS core/platform integration:
- Parse and validate per-gear DT TX EQ settings during platform init.
- Store parsed values into per-gear TX EQ params and mark them as static.
- Integrate static-state handling in TX EQ flow so static entries are
  handled through the adaptive TX Equalization path and then converted to
  normal runtime params.

v1 -> v2:
- Improved the commit message of patch 1.


Can Guo (2):
  dt-bindings: ufs: Document static TX Equalization settings properties
  scsi: ufs: core: Add support for static TX Equalization settings

 .../devicetree/bindings/ufs/ufs-common.yaml   |  11 +
 arch/arm64/configs/defconfig                  | 289 +++++++-----------
 drivers/ufs/core/ufs-txeq.c                   |   4 +-
 drivers/ufs/host/ufshcd-pltfrm.c              |  82 +++++
 include/ufs/ufshcd.h                          |   5 +
 5 files changed, 208 insertions(+), 183 deletions(-)

-- 
2.34.1

