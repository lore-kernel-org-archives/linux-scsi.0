Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF68E26C385
	for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 15:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777043682; cv=none; b=QD13ynOc2Dn6AsztIq4CXbB2mm6dGP60IzPJknFzyFN7bPI2XAAlofieB0i8lgXMuQOo4MgQrj9oVQ24o0IYzSM4OIvQ2PIs1CKTQrYbrxVeDT4iAiIPBNHHzXXXcgct+XcQuFmNnEpb0xTZgXEsVPXS9bYR6q5pGFhkR+EkUuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777043682; c=relaxed/simple;
	bh=SmetdeW5sleHX6MlklF+vylJnzF1r4wNynEPdQIhhXI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=im3julbzT29LWq1Aw/1EboRbu4q3/dk6PgGNCLqAAgpCROFT/5w0/UBAnoQY6v3e+JYrGxILLx8qGpT49Bm0keoSmBhhlXE2q7ZpO/bemW8DB0ek4fGZqQHKSNyf7Qgqe551f33kPV+4YoTTw/jzMIxuocPDC+oUkTh8xsfED9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PdjYgiWI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PdjYgiWI"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63OAErOV2447109;
	Fri, 24 Apr 2026 15:14:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=/LHpKCuYxmMln0IJmi9USPZzzmBeVIVCJI2
	Nz0wYXvk=; b=PdjYgiWIEbpzzqZhka78gb9b0rdgXbxcmFOsDyXNoAkc8Ystskw
	Ooqy1k/CsocqVsdYVs1saFYvJAhBxfKcVimj3IHkQzHhmRiccVNeoro7jfdv3LK9
	bVRLGi+JqcC7SdpwZjWivhbQNGeGhBWyr7hxtNXKsl0bTn5hdKId9394tk+eN90Y
	+DDi4NkPB1cGW31gxnEjTjzmLy5Tqcw/oNylUIvk5y68qBunFWa2kBg7EzGLY24Y
	kiiUrVqmAwVfZA2mj4il8gzGjQDXLt1pz2m4ybMyKohDwi6lhXlJURlXG3+PtatS
	QGVfLBBnvE3UHUmkch6n7z8PmQPWBCjD1Ow==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dr6kps7kb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Apr 2026 15:14:23 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 63OFEM7b029709;
	Fri, 24 Apr 2026 15:14:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 4dqvyt7m4u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Apr 2026 15:14:22 +0000 (GMT)
Received: from NALASPPMTA04.qualcomm.com (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 63OFEMBd029704;
	Fri, 24 Apr 2026 15:14:22 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 63OFEMex029700
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Apr 2026 15:14:22 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 21C305D0; Fri, 24 Apr 2026 08:14:22 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>
Subject: [PATCH v2 0/2] scsi: ufs: Add persistent TX Equalization settings support
Date: Fri, 24 Apr 2026 08:14:18 -0700
Message-Id: <20260424151420.111675-1-can.guo@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=cdDiaHDM c=1 sm=1 tr=0 ts=69eb88cf cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=eoimf2acIAo5FJnRuUoq:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=uvS0cDOMVqQPhaQuCmkA:9
X-Proofpoint-GUID: 89y2-euBUwMUKlizQFOQcimrv4aYC6oD
X-Proofpoint-ORIG-GUID: 89y2-euBUwMUKlizQFOQcimrv4aYC6oD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI0MDE0NyBTYWx0ZWRfXxyai/BwrdVSu
 3QWeTNsqvhn8brFAJcSio6IbiLbQqV4/gNj8RuuAzNhdBDbDfzWafG9OdBH/1L5fFZd1BTS2hXK
 QPJB07fLSEEc+AyJVz8M7GMO6gndCJMFV6TESHyGmoAnu/CEvZ/HNcxAg7Yn3hreYZ6Isi+CbRm
 RwkD8zynsF2fZ+gdAIkC2k9H6Nymkhon3Rl+VG0rTH6n2sLjsFySlsdkN6UYmmgMxOdjvMgbElz
 gSkElycOWi+MfN2yfDOqB88kZt/P5ZkNbwl3o+GfNf9Lp+jxmJ83ZMrOmuhv8QtfUWaet3hRvEq
 YbRMQWB8syGveJlFxfk7UXOrz5N8txPAMVjHs+HNMXNTq1bH8mdyh7PQFmxEguvMi/ZdEpTuFSU
 QI/5IytG6x/M3uQlymr5uaSTegYk1plDi8R0vs82Vlm+HK3Igvz5tmGrGmdfheohh5disAwviFa
 JKrNt+yDyIDz0rVUO0A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-24_01,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604240147

Hi,

This series is a follow-up to the earlier TX Equalization enablement series:

https://lore.kernel.org/all/20260325152154.1604082-1-can.guo@oss.qualcomm.com

In that cover letter, the "Next" section mentioned adding support for
UFS v5.0 Attributes qTxEQGnSettings and wTxEQGnSettingsExt, and enabling
persistent storage/retrieval of optimal TX Equalization settings. This
2-patch series implements that part.

Motivation
==========

TX EQTR procedure is required to find the optimal TX Equalization settings
for HS Gears (4-6) before changing Power Mode to the target HS Gears.
However, TX EQTR procedure introduces latencies to the first Power Mode
change.

With optimal TX Equalization settings stored in UFS v5.0 Attributes
qTxEQGnSettings and wTxEQGnSettingsExt, host software can reuse known-good
settings and avoid going through the TX EQTR procedure.

Array Attribute Model
=====================

qTxEQGnSettings and wTxEQGnSettingsExt are array-type Attributes. Each
element in an array-type Attribute is selected by an (Index, Selector) pair.

For these two attributes:
- Valid Index range: [0, Max HS Gear - 1]
- Valid Selector range: [0, 1]

This effectively forms a 2-dimensional array. For HS-Gear n, its TX
Equalization settings are stored/retrieved at Index (n - 1). Selector is
configurable via a module parameter so that platforms can choose the
Selector policy that matches their use.

Implementation Overview
=======================

1. Introduce a generic helper for 64-bit query attributes:
   ufshcd_query_attr_qword().

2. Add TX EQ settings persistence flow:
   - Read stored settings from qTxEQGnSettings & wTxEQGnSettingsExt.
   - Decode and populate per-gear TX EQ parameters.
   - Use Bit[15] in wTxEQGnSettingsExt as validity indication.
   - Store trained settings back to these attributes for future reuse.

3. Integrate with existing lifecycle:
   - Retrieve settings during device parameter initialization.
   - Store settings during shutdown.

New Module Parameters
=====================

Three module parameters are added for TX EQ settings persistence control:
- txeq_setting_sel (default: 0, range: 0..1)
    Selects which selector value is used when reading/writing
    qTxEQGnSettings and wTxEQGnSettingsExt.
- retrieve_txeq_setting (default: true)
    Enables/disables retrieving stored TX EQ settings from device attributes
    during initialization.
- store_txeq_setting (default: true)
    Enables/disables storing last trained TX EQ settings into device attributes
    during shutdown.

Testing
=======

Tested on a UFS v5.0 platform:
- TX Equalization setting store path, settings were correctly encoded and stored.
- TX Equalization setting retrieval path, settings were correctly extracted and reused.
- Full TX EQTR procedure was skipped for a given HS Gear when valid TX EQ settings
  were provided in qTxEQGnSettings & wTxEQGnSettingsExt for the given HS-Gear.

v1 -> v2:
1. Incorporated comments from Peter, Bart and Bean.
2. Fixed typos and minor coding style issues.
3. Converted macros to inline functions.


Can Guo (2):
  scsi: ufs: core: Introduce function ufshcd_query_attr_qword()
  scsi: ufs: core: Add support to retrieve and store TX Equalization
    settings

 drivers/ufs/core/ufs-sysfs.c   |  30 +++-
 drivers/ufs/core/ufs-txeq.c    | 287 +++++++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h |   5 +-
 drivers/ufs/core/ufshcd.c      | 131 ++++++++-------
 include/ufs/ufs.h              |   2 +
 include/ufs/ufshcd.h           |   2 +
 6 files changed, 392 insertions(+), 65 deletions(-)

-- 
2.34.1

