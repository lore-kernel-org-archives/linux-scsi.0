Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FECF3EF0BD
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 14:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779892870; cv=none; b=A/NrBdVlVJRJO5oSjGL6sArl8BGo0m263Qgn50exhJbx/Gf8u/o7qmTwzTPseH8aPfgXUAKQpIGulD6mchxaahq/cxwc57y50Bh9eNJgqrZA3TqUzPdTi+ha5fTpb090EhvLglCugPAIXByqCYmvH5HbTeLSlNc2l6NNoueKHLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779892870; c=relaxed/simple;
	bh=tS8NhNqCzad75BGkrz15PhBxjELyFIDoEZBp0DgvlPs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qiGHVax64JlWN/Mq/BCertvPQOqBxkqcqvRuh3Qp8O8AT8vY3J/dTrWAfmnCCJhHidvU0C0Ja0XJScfz8ioXa2DvNH+2bnvcBeFcpH0ohvDj33JoU35IziBpmUMui6J0MU6iMSJdOi3T+YcQvxX3UUr1IooqyoxsWHyT8QROWaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=k/o6jUD+; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="k/o6jUD+"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64R8mXYe2282627;
	Wed, 27 May 2026 14:40:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=Gk5TsPijekmJ0gZC4Xa/HKSyJude0TSyFpa
	6kqBkgb0=; b=k/o6jUD+EiuMT/JsQsuiFTW06LnAvWyp8AoPm7VHWAxuLPsp/bm
	+j+cThMGPDFyN2uf0LX1ToOMeEtsUtAjYeFkGlEhGrgBgWuyE3MqJj1pF/e5QCJp
	qII466Tau3gIMUfd0ZZxJkmz1UBsAj+0Ryi4wF6CugR9tg9H04x2BsRscjUwegBW
	YvbeXimAP6I7/GiJgaRjIIKzJ+bxP4vZp8D3Trgb1ORm2CiHSENa7dh+wcVFGLny
	ZajxoLCuIPTkyTzgQehar3YdXVOh9XYSXjBla847Di8zcEd/pBv2c2I6NhNlQi67
	NRUPcIziwaQNrZVsDowyaVbwnjTWkXTLJzA==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4edtvcswq8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 14:40:58 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 64REevMv009394;
	Wed, 27 May 2026 14:40:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 4ecnabf4d3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 14:40:57 +0000 (GMT)
Received: from NALASPPMTA04.qualcomm.com (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64REevTF009388;
	Wed, 27 May 2026 14:40:57 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 64REevwR009385
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 14:40:57 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 1C616631; Wed, 27 May 2026 07:40:57 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>
Subject: [PATCH v3 0/2] Add static TX Equalization settings support from DT
Date: Wed, 27 May 2026 07:40:53 -0700
Message-Id: <20260527144055.2758170-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-GUID: TdXiQ4edp_HA74VB1Q_rlrxQguiuiAZa
X-Authority-Analysis: v=2.4 cv=CY84Irrl c=1 sm=1 tr=0 ts=6a17027a cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=Um2Pa8k9VHT-vaBCBUpS:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=4ajky533VDcJp0aEe7MA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDE0NCBTYWx0ZWRfXwh1JP/qTFkpg
 Jlgv4CI+5PPm8BQEtGqE60/p4uY1VEVg60e8bO9oLMIl2SKLyLk2DVvLFXtPbFVb8dq3HepiL43
 ntyzEHK8hUwhx/qkE2yorORdU4yIgRi6M+71cPwCi5yR/x2fDaT9Jj4s48o8v84eNjWLDaEYTD1
 6dG9O5fVUlw50Iw3EuvRu0jS85+f8GRh8pLQ1+VReoCIVwu7dOvLXtayZwgZxQeR7BqAGJZZE6T
 6Ic44v2DjiHypNG0iRMXaDeYhqKlkovtm/7oYTmML9ercvOskHG+yge0zPIaXvm+3lTyGzGepAE
 P2ZAgfe3bCOfVn7JvOrikaeSFbJOPIm6NZ3P03nQWwK5gZbhvMvRZqNbGJpjFVGXEs93odS6l5A
 2/Lbf7oFSz9rUcwgAJsiVY2bnHj/eAv05NTVwXEWFtticbECdVSyLME6dOyZbji6FQ3pbg3Asan
 Valt+fKGOtDKlc28CLA==
X-Proofpoint-ORIG-GUID: TdXiQ4edp_HA74VB1Q_rlrxQguiuiAZa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605270144

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
<Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]

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
 drivers/ufs/core/ufs-txeq.c                   |   4 +-
 drivers/ufs/host/ufshcd-pltfrm.c              | 128 ++++++++++++++++++
 include/ufs/ufshcd.h                          |   2 +
 4 files changed, 178 insertions(+), 1 deletion(-)

-- 
2.34.1
