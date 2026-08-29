Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782C72D061C;
	Sat, 29 Aug 2026 07:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787989446; cv=none; b=oSOcrd0KHlcHqCUlsTz+QZZ3K9baqVuGaEJDbOFQNEMO3pbEF5yl7vLdw90Jivq/oPf0TMQ1YXexZ25GToLaxP6W03vD0tBYRg1lGzueZFOrutxDsCnYjumFAkiko0+VvCkcKS4o84CV1RLieyHUKT0LKnXmoSC8m2bDm0mmBc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787989446; c=relaxed/simple;
	bh=juVydeC6ZRo7gPFEtzN8jHuzip7JwcvpVU/Pl3ADBB4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=S6bIkDTMNmbXDJl8Q56Fe/6fDV0XuYnHpvFihOmtNph0h/iFAflL/KUVewf76r0ZlmsotWTkssRgxTc4YMOqvh0JPyneLr1myY4+Z1bLprg4ajgUuw84KCWTy3/F7+IzPDipjlHj1MU6vyrPZauBMRP3HhTUcAXpA7luElY38QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PdlgoCtb; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PdlgoCtb"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67T57gFX297147;
	Sat, 29 Aug 2026 07:44:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=L96cf7qs+bP0PlwOJ/I2cBM+xCrriJi0jw/
	fOMOD68M=; b=PdlgoCtbf6+NWHvuZrpeh4JtYHiNkuYeYfdMFp6RtsXxcoTb9vE
	iUV8Lg8nj3+GNDguzADQRQEyRCMIjnBqoqeYenvSHxM4WL4x8K1/cLq/TfrOZLV2
	49gMFvrucxoYUAt+M5FeD9kHlWreaPdh4gEIKurA2Eh740L4cS/xxPK6SfEuRms/
	IFDFjtKW6vGERQ7bqIIw24+n6rVs3BAvlsNw6LsW2WEX1CT/aN/pgBvgkE5IZAvo
	zGiJ9suz+IKHVxTQqoYGPjrsTtxsQwIMkGwR/SUuPTLjy/8aMT5M1wvVilMsAEHe
	BjAs/1qyvF76wIbKu4F25BsqAAb+QNZHErg==
Received: from apblrppmta01.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gbrq809qg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 29 Aug 2026 07:44:01 +0000 (GMT)
Received: from pps.filterd (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 67T7hwsl002260;
	Sat, 29 Aug 2026 07:43:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTPS id 4gbrgh21tx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 29 Aug 2026 07:43:58 +0000 (GMT)
Received: from APBLRPPMTA01.qualcomm.com (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 67T7hv7U002255;
	Sat, 29 Aug 2026 07:43:57 GMT
Received: from hu-devc-hyd-u22-c.qualcomm.com ([10.213.101.157])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTPS id 67T7hviQ002254
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 29 Aug 2026 07:43:57 +0000 (GMT)
Received: by hu-devc-hyd-u22-c.qualcomm.com (Postfix, from userid 2342877)
	id C234363E; Sat, 29 Aug 2026 13:13:56 +0530 (+0530)
From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
To: krzk+dt@kernel.org, robh@kernel.org, conor+dt@kernel.org,
        andersson@kernel.org, konradybcio@kernel.org, mani@kernel.org,
        James.Bottomley@HansenPartnership.com, mkp@kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Subject: [PATCH V1 0/2] scsi: ufs: ufs-qcom: Add specified gear support for multi gear scaling
Date: Sat, 29 Aug 2026 13:13:53 +0530
Message-Id: <20260829074355.946543-1-nitin.rawat@oss.qualcomm.com>
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
X-Proofpoint-GUID: hUtT9nh1EsPqdNKpBLybkUBCGkFb8r3O
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDA2NSBTYWx0ZWRfX0tze1WiWA4vv
 di9tOGGNGGaxX83JtYC3NB/TOBEjcORAOrei9lvxmGHy1/NWDznABmQu4+6Aiiaa157mwU+7yPf
 /6KYfu62cfUmFHoZJUN+5eDpMtwXtBY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDA2NSBTYWx0ZWRfX+2Kw4x577/k6
 MEJYl1cy/lJhzGZcFgcM9HX4GGKm2vDi+VjfCICQBbx+Alj9xZ1voVbi2EmCJBpYtgmv3NM7tsu
 dQowB3YJpfmWbSeEOySFXc4/nf7XxRn2si/EGIqTWxNUe9QVseq+wFznZvaOnPyCeBe5rATgVem
 4BxhMFmu1BeSde26UWh787CTgH9eBrI56YcCjaA247rBsucwrLWPk8xEfXkYkq2xC+BOFJQaw/U
 oThPEpaKiba2RMLnS3VwgvOySDPOYuM2yrBbX2rW1NBhUdQzReNd2SvPiE/zD79pfJ3HbyPo6Kw
 RpXM8dO+z87RF9nqWBr3/9/pqG9gDE87yPJ4vktKOimJDUIxgtViM/l9YVMOxRP5eNFrakhwo25
 FWq9o83ievd8z5k3+ZQKfbxkpVp4V+vtgm2u64kQdQH9TMsbBruwh6rYuDiccmnVF36saiDlUfy
 s2ctBE6RTraONOmWpdQ==
X-Authority-Analysis: v=2.4 cv=ZOPnX37b c=1 sm=1 tr=0 ts=6a928dc1 cx=c_pps
 a=Ou0eQOY4+eZoSc0qltEV5Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=YMgV9FUhrdKAYTUUvYB2:22 a=wa_km6tUUitTdDDs5jcA:9
X-Proofpoint-ORIG-GUID: hUtT9nh1EsPqdNKpBLybkUBCGkFb8r3O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-29_02,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 impostorscore=0 phishscore=0
 clxscore=1011 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608290065

This patch series adds support for configuring UFS gear speeds on a
per-OPP frequency basis for Qualcomm UFS host controllers, enabling
more flexible multi-gear scaling.

On certain Qualcomm platforms, the UFS clock frequency and gear speed
do not have a strict one-to-one mapping. To handle this, the first patch
introduces a device tree based configuration mechanism using the
"opp-level" property within the OPP table. This allows each supported
operating frequency to be explicitly associated with a specific HS gear
speed. When this property is absent, the driver gracefully falls back to
the existing default frequency-to-gear lookup table.

The second patch applies this configuration to the Hamoa platform,
assigning the appropriate HS gear levels (G1, G3, G5) to the
corresponding OPP frequency entries in the device tree.

Nitin Rawat (1):
  arm64: dts: qcom: Set specified gear configuration for Hamoa

Ziqi Chen (1):
  scsi: ufs: ufs-qcom: Add specified gear support for multi gear scaling

 arch/arm64/boot/dts/qcom/hamoa.dtsi |  3 +++
 drivers/ufs/host/ufs-qcom.c         | 30 +++++++++++++++++++++++++----
 2 files changed, 29 insertions(+), 4 deletions(-)

--
2.34.1

