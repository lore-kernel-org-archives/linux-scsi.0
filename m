Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EC517758
	for <linux-scsi@vger.kernel.org>; Wed, 22 May 2024 07:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716361319; cv=none; b=jDrXZk4uqcEvNA1ZY45IB4Pv+7u10OiXTBRlrqdXx4JbvVL+J5oj9rglhIDQRIpM6wzVQ0CR9uyHj9+3Lf8QPgd8+Au43ooEMahCI68WHyYFEioADIjTQGgJeDx7bHw+qcCcu9QlsbxrrSqXtMT8l8O0suTnPpSvTCCQw8laxWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716361319; c=relaxed/simple;
	bh=tZ8YcJpIBK3lxMgpbXrhWJ0e1mlHqH2PF5rDTvqKrEM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AGtQR31/IxDx014S190crp/PoMq/yC/ZQP7go9FooporJ3K9RCM5PBKYAuySYyjmKcKM++h9Oua/Byx7+He22gka1m1W/8nQLsHhE3OvMblGFc2Bvw370gQT8YtPdlMieykzR4s2AOykPszDYkx+pbSyJ87F6VDIde/lh/5N3Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=V2eyQ7p/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="V2eyQ7p/"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44M39aJe030957;
	Wed, 22 May 2024 07:01:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	from:to:cc:subject:date:message-id:mime-version:content-type; s=
	qcppdkim1; bh=E7ce5weP9A/C0wEJ4bXNIo9f+8PC6M5Pp3Iun987OFE=; b=V2
	eyQ7p/oRpFtTQ7OrVGsoThKEs8gOboQLbaOwrBt2P7zAZXO8LqPVtYO6ozEg81mU
	lhzev/jM94eYAAWhgdMHlihKIgA4FCMtPE9T+ucYY1Ml0RerCjMwEn29l1NM9Clc
	AeneICkzDyKCVQfXUK4p/+8yWyootsEckjE3Zpwy1dXGxMrZUCncUcWdamsv4Yi7
	Vhbe23hYr7BJuut36KSWm5KAoNtWyWIyUG27lQZEleg6W4FzARAtIstEBQFXa20M
	3cbMGQuagGxm8wYeVcFluQcjgSXVKDehvtM2l2kbX6lejThVbV30UBUR/E8lmkqW
	MaFYL22TdTifAIg8lcLw==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3y6pqc8anc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 07:01:47 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 44M71kXs009613
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 07:01:46 GMT
Received: from stor-berry.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Wed, 22 May 2024 00:01:46 -0700
From: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
To: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <beanhuo@micron.com>, <adrian.hunter@intel.com>,
        <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH v1 0/2] Allow vendor drivers to update UIC command timeout 
Date: Wed, 22 May 2024 00:01:26 -0700
Message-ID: <cover.1716359578.git.quic_nguyenb@quicinc.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: K_Sp0t4kZ6esv1iWPQbQLLDa_PSx4bfz
X-Proofpoint-GUID: K_Sp0t4kZ6esv1iWPQbQLLDa_PSx4bfz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-22_03,2024-05-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 spamscore=0 clxscore=1011 lowpriorityscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=972 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405010000 definitions=main-2405220049

The UIC command timeout default value remains as 500ms.

Allow vendor drivers to change the UIC command timeout as they wish.
During product development where a lot of debug logging/printing can
occur, the uart may print from different modules with interrupt disabled
for more than 500ms, causing interrupt starvation and UIC command timeout
as a result. The UIC command timeout may eventually cause a watchdog
timeout unnecessarily. With this change, the vendor drivers can set a
different UIC command timeout during their product development and
revert to the default 500ms when development completes as desired.

Bao D. Nguyen (2):
  scsi: ufs: core: Support Updating UIC Command Timeout
  scsi: ufs: qcom: Update the UIC Command Timeout

 drivers/ufs/core/ufshcd.c   | 9 ++++++---
 drivers/ufs/host/ufs-qcom.c | 3 +++
 include/ufs/ufshcd.h        | 2 ++
 3 files changed, 11 insertions(+), 3 deletions(-)

-- 
2.7.4

