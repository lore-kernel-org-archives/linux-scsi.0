Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8394C3B47DA
	for <linux-scsi@vger.kernel.org>; Fri,  1 May 2026 13:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777643071; cv=none; b=hkg5P6O2wb8Okcdg6GpeWvc6vI15ikeJW4wKmcAIN2FF6iQzl/TCrC8e0IuhCYkCCLw7G0+Rx63Q8lmfL1VI3Z7deHRMiBAFW9Oxl9H90hgBaIbUrTPT1Z70l0oa7MEKkYvDTOioSqH7y1iwk5pYhvt8kpCitw9vlLFdrS9f7oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777643071; c=relaxed/simple;
	bh=GAQY75kIhScRdOSxg3YNiMLua0vzS7F4lQ6c/nIhLUc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=u8gDY5cyB1DQtbgJhl9eL+I/BbTTEZvXEsZdANlkxxjhoUBlnpQmDdit3VOg0PHnNS97r6/9jtB8i6B5E9oBSJB//Ppc5gBrvRNrRM0d0NvFtyigjsFzTG9Szu+6TNvN8sHMhcW90/HtdsS1gVfDzK6nZDQF/k6uObmxM4nHKHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gAScYcNL; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gAScYcNL"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 641AXD4u3950822;
	Fri, 1 May 2026 13:44:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=9L4zsD9OwGa/k5XyU7PqdPac7gO3yxnibTO
	xffsK0L4=; b=gAScYcNL4iSoWHoer8gDHvTJ/vNQpUnaE8LYqT64KJ+sVs5O4Xb
	CXUUJfMeBxsOonsGncziy9podoDLxcs3EuaYJuYtlZ9qrFtTqEhsOtzb2u9reoHM
	4rFlrSnuMhdgaK/+GDqXNulcLE50GTJBvYl5LcF6sTPeaSDVXizjB8rmk68K0jIV
	slMOKQwAc00Av2H6Q3luCFKuj0/9DvT/CuWrGYlLK7SdBDWMlP13b0rNwmFc6LdG
	11kn2oIETocyaZ4/573j7yPiqMb+7Zb3RzirnDEVFOQ10ASawPr4aJ0nzt8Xgf4a
	jw0McDfdgHFmQ4mkpc9xW5cL3GwOS8/LYLw==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dvchkane1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 13:44:21 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 641DiKGm025025;
	Fri, 1 May 2026 13:44:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 4dvgkwn2hw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 13:44:20 +0000 (GMT)
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 641DZUAr013982;
	Fri, 1 May 2026 13:44:20 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 641DiJ9A025016
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 13:44:19 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id B5261B1B; Fri,  1 May 2026 06:44:19 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>
Subject: [PATCH 0/2] Add static TX Equalization settings support from DT
Date: Fri,  1 May 2026 06:44:16 -0700
Message-Id: <20260501134418.863432-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTAxMDEzMyBTYWx0ZWRfX+IN2gHwoFArO
 4I7Jj3rdcwc2kYIdbp7eOYrZ3oCOjPAmBJSu03n5ElE+UsMS5He4vlGlr/ENWgB6Zj/M0N4Hpdk
 ZXHLoK93Mf/W7PpOR0k06vnl5cv+V0l2PtiQfYr4H88XG+MVd12XnOJRnB0OeYjKO9fKvPVBW9l
 gS35tHYXErB4iMAiDQM3w5UW1eGxSp/OAT6wGnoin+prAOiVd80Xm3lKrDETEN6gMMqid0ZVa0z
 8ugVuYEqA+pSVz06lDBsKqlz2O7W6KTi3bDIq5meBI/JN8yTg4na3D0mFkp8hCTJuLdiLPcfYa5
 t7YClzMmOVVVFQ+JG/INv/L9cOpY+zaMLIO2MfOx42WtQyZn3w01kY0Ts5JiHIMrjzcHKeavDkb
 1lgVCjiX+PgwafZ01XvZqeqEDcUZK6WSgG9c4bCvLy/t9Zf77/ahRaB8QheA7kSZwWz+RmjUcA3
 u2oo7ynEG3LBBQspFPQ==
X-Authority-Analysis: v=2.4 cv=Zdkt8MVA c=1 sm=1 tr=0 ts=69f4ae35 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yx91gb_oNiZeI1HMLzn7:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=Mvjp5gLCuttxcCko6jkA:9
X-Proofpoint-ORIG-GUID: M98BNR0YUzobimB4luf9MMmd-sc-Ia-J
X-Proofpoint-GUID: M98BNR0YUzobimB4luf9MMmd-sc-Ia-J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-01_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605010133

Hi,

This series adds support for board-specific static TX Equalization settings
provided through device tree.

This series is based on the earlier TX Equalization enablement work and
persistent storage/retrieval of optimal TX Equalization settings work:
https://lore.kernel.org/all/20260325152154.1604082-1-can.guo@oss.qualcomm.com
https://lore.kernel.org/all/20260424151420.111675-1-can.guo@oss.qualcomm.com

Background
==========

For some boards, HW design teams also provide pre-characterized static TX
Equalization values per gear/lane. This series adds a DT path for those
static values.

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


Can Guo (2):
  dt-bindings: ufs: Document static TX Equalization settings properties
  scsi: ufs: core: Add support for static TX Equalization settings

 .../devicetree/bindings/ufs/ufs-common.yaml   | 11 +++
 drivers/ufs/core/ufs-txeq.c                   |  4 +-
 drivers/ufs/host/ufshcd-pltfrm.c              | 82 +++++++++++++++++++
 include/ufs/ufshcd.h                          |  5 ++
 4 files changed, 101 insertions(+), 1 deletion(-)

-- 
2.34.1

