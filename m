Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588865478D
	for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2026 13:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776606838; cv=none; b=Qck0VrpUucecAZS53L7mG939CF59XcDVNWn5W3ta7PGDw/T8uQyW2c0aISThSUPdENtXX2B1TGwmWkGBkdn+4xyVhN2xYf4SHkV7ZV8B4/s3rqPRH8SkKvtOH3+J7VaXvHezBW292R1gyijUW++/btm6VpU8ONB1m9lnw2ROaZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776606838; c=relaxed/simple;
	bh=ctA2UPsTTtYnGgajgvaDSMoyIfXm+1jr1l9jT+vVobQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Qm3WF4jn/JuM4eKcLJK8q0lcKKC9aUUPgAuFleDWIkyrn56zQGxfU6DTdBl6av0NdsHeKt9KM/xZBc3xJRkuzwY5dNdFfCOBsHTOdrTVnVHInYFvv61PSuC6IhcELajheTerMmjr9+ubAcP/p33oEILNCJakLxda3pmIMGfrbMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=U+AWw2Wi; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="U+AWw2Wi"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63INeaAl2340932;
	Sun, 19 Apr 2026 13:53:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=XBVS0hN6HUIuaZg5IfkOWgzcSQ77wyG7zWw
	vVPxRea8=; b=U+AWw2WiVtaJVlJtN+mmUEiPy2Ts9JHWzYCj83RbhuoeEriqcMm
	oNUu1B/bM/NCqhgvLXGSpRGqDchssGdlCklVl7rgtuYAitCjlWp1mAph3zqzZ9mG
	/ioDgKOdS0FE+PPZ587GozTBLscHTdGoKUjOZy6IPnWuIzEa8sIglAOSpusnUY1e
	0g4vsjywfVSXBovz0fJMGQdHPmDM9x0iv62hWIncsywUJnArb2+ldPpHxlTEj54F
	gWyUnI5sNm4SSSYt927ORqa8HAh27DF2NlZ6tXk0nGLc7x8i8MPNGQInU4JO4E++
	Da4sC+AldivbOTWGg8XAT9JJfx1RULu8uVA==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dm1hx2nwg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 19 Apr 2026 13:53:24 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 63JDrNXx017768;
	Sun, 19 Apr 2026 13:53:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 4dm31ht243-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 19 Apr 2026 13:53:23 +0000 (GMT)
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 63JDrNDr017763;
	Sun, 19 Apr 2026 13:53:23 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 63JDrN44017762
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 19 Apr 2026 13:53:23 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id DBB96607; Sun, 19 Apr 2026 06:53:22 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>
Subject: [PATCH 0/2] scsi: ufs: Add persistent TX Equalization settings support
Date: Sun, 19 Apr 2026 06:52:27 -0700
Message-Id: <20260419135229.1036926-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: KCwNLm5_i_qx_rZ-4RIzzZSwevAuBi11
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE5MDE0OCBTYWx0ZWRfX1dyZYwVqkN7I
 fwTxVupdHrRHOpVA5jkztZ1NPVnE/DhAt7RW59Z/W0SoLcqG4JLPoyKMC54SWIOTY8xWvbsU6fi
 As9IcKGFHeuE/AXWsa1/nsJ3GwwyZKAw+qPzn9W/3TSt3/QxBl9TwbrqIM5RTPpx8RvIc+aPY2i
 lPqNiv6taaZ9nXs9QPpNUjWDMRCEJiNrATZ9okCVN3irFL9DNwgxtEKvGxgd7GCGXBhIIOhDssF
 0Xq+JL2EpmMvz2CuZ0f6VSRocWtYWwDrbOQvRByE+EwEAAYnUD6mfVL+nI6QbqF8adYNi+3tN1S
 4NKLXK7gza2imhVw4EPVDlsr/IwgoY1wTewtd/WJh0HWkxpMWs3PhtK/+58DTRXO8/q8dtlUMb7
 zZQbUqtXqY8Pr+qKYgR8cRFtk5C/aiypuzg+MQ7JmPRprDOJowxxGkOeMiBGid+tov6N0coWLDI
 OXTTcieF8QXPBqBQ5Ow==
X-Proofpoint-GUID: KCwNLm5_i_qx_rZ-4RIzzZSwevAuBi11
X-Authority-Analysis: v=2.4 cv=RoX16imK c=1 sm=1 tr=0 ts=69e4de54 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=uvS0cDOMVqQPhaQuCmkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-19_04,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604190148

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


Can Guo (2):
  scsi: ufs: core: Introduce function ufshcd_query_attr_qword()
  scsi: ufs: core: Add support to retrieve and store TX Equalization
    settings

 drivers/ufs/core/ufs-sysfs.c   |  30 +++-
 drivers/ufs/core/ufs-txeq.c    | 241 +++++++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h |   5 +-
 drivers/ufs/core/ufshcd.c      | 131 ++++++++++--------
 include/ufs/ufs.h              |   2 +
 include/ufs/ufshcd.h           |   2 +
 6 files changed, 346 insertions(+), 65 deletions(-)

-- 
2.34.1

