Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABD8399015
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 10:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779962799; cv=none; b=BipQv4qehujyWkuOeLXG78jWmLDFJQuHBZdmcjnNPhthC9BAPWfVhp7Q4eHSHcFoL/9Urpn7xrPwBZpSsD0Krhm8vgLNyCUaAj2FoYeH5NvKxBoosqyIu5woOib6A4OgbjqWvSN65xyT9OesuACM0OwCJOfYhMfNvXDuYS6K9Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779962799; c=relaxed/simple;
	bh=dZ13DkesEcu8Y9e9k1G3dUiBOQ39N8iDAIAeXEWLDkI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=c1YYZOau2vALx82dXLgny1snwsjI578KRiezIa7HNnq0RTgNSpry9jMk8gBCOsxbrVfwGZVFLD9+7XJODJM50PhE61cAULy4uCseCJ7/I0sXu5cdkrIkY3c4dIYc+TbozmmVcUBc7XxG9Tux9Wtbf1XlLqbFrNuuLpdDIfHRdY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IdqA3MMJ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IdqA3MMJ"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64S8vKJD1562576;
	Thu, 28 May 2026 10:06:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=q3zGj1BxONND3HWcGFeebliajphLWtGWdKV
	qBB+ZnDw=; b=IdqA3MMJML3nfC/7BVSlK09RMkYq0m2omasB2f7FKsPRjfGjnk3
	o0eL+VpdX24vFd9ptzfiz5t+jB1LeK/7smp/O0eewpv45zH3SprrlZ50ACK6Basw
	gkxfOjAuX9DqI3zYIGs65xSmaIOGCg0xBL2di8H+d8IUjdS/OJJTQzHCvfQ36Q78
	tb7gT3UYaWg6RlHpHpQK7JObCoYSxUyYKyjn0xJqsSc8D42NRD7BEPV8syAYogB2
	6X+IJ0p5smtyC2NL0aMmMw1rjENqW2bTIOLIkMd7kxPRjxM3V2uAzUd8wA8qLf5z
	0AVqykFAXFDerj3D7aR+A8jet3S26s+mvpQ==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ee7y2ta80-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 May 2026 10:06:16 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 64SA6Gpp015841;
	Thu, 28 May 2026 10:06:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 4eea4av34r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 May 2026 10:06:16 +0000 (GMT)
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64SA6Gt4015835;
	Thu, 28 May 2026 10:06:16 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 64SA6Fvu015834
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 May 2026 10:06:16 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id BC1CF62C; Thu, 28 May 2026 03:06:15 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>
Subject: [PATCH v4 0/2] Add static TX Equalization settings support from DT
Date: Thu, 28 May 2026 03:06:12 -0700
Message-Id: <20260528100614.3386423-1-can.guo@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=VeXH+lp9 c=1 sm=1 tr=0 ts=6a181399 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_K5XuSEh1TEqbUxoQ0s3:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=PU2HUsy48LbWZyxNEuoA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI4MDEwMSBTYWx0ZWRfX0d8+M0TfzvKk
 MshfcUh928ncnZH4TXx2TcwQrg+7Sx7qaJq+skb+ZDorVpXoBNMc8friIJ25ikZstaig/UMwCXx
 lZqyudjwoa2vBKuWeto7vILhNGlMbglkRIEUlxagjBrkdt0x9z8sEsh9LqJoTqinuP9X5icT1Pl
 LtVC7rtM2bYc2VEvTz1lES98WAN3pLPviTSM04UTM2YJ/gLGhN8aY876k5utje5drkRML+o6oml
 00HUVHBsacTiNS3R4q5LpBCOhMSsIA5AwK/DlgE4JwAIcfkNKuHieZ9QfmmjB2Zk5m4GOMuhDHs
 uKmfLRtA+uJMiEVuebJU7Fajm1wJdjJ/Zj3tXJZ30JMzcghPKquuhh3CXWBGU8fUGeBNfhplaNv
 qAsw9hmkRPa8wCAvEPJu3LRHowKTU21MT8vv2T8y9TqAB+Yvvxb3CcZ6Vy+ncIJVe/RuahyutEC
 zDRX06JS+AZ8rGpeNKQ==
X-Proofpoint-GUID: Lh3I9i-dA7fMi0eJv6SeA3jsDB2S3s_K
X-Proofpoint-ORIG-GUID: Lh3I9i-dA7fMi0eJv6SeA3jsDB2S3s_K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-28_03,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 suspectscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605280101

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

 .../devicetree/bindings/ufs/ufs-common.yaml   |  45 +++++++
 drivers/ufs/core/ufs-txeq.c                   |  10 +-
 drivers/ufs/host/ufshcd-pltfrm.c              | 126 ++++++++++++++++++
 include/ufs/ufshcd.h                          |   2 +
 4 files changed, 182 insertions(+), 1 deletion(-)

-- 
2.34.1
