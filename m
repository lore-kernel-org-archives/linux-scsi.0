Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2F8223339
	for <linux-scsi@vger.kernel.org>; Mon, 16 Feb 2026 13:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771249603; cv=none; b=aW0AwGSSXqniSIXHtcRjAUfb65kDt27do3uNi/a1smFFXj0JMJE0DIdmyMM9oKYrg4n11e+TlGq0s3TpKm7cVaQTWUeBs6/eIQ9WqXJzG4/2Nx1H+frpSjMrWylfGOojXqLqcR0vCqUCx/80WC7YbMaaHnmr3Q8JfzBnppi3iEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771249603; c=relaxed/simple;
	bh=iDADPA9k4+KVhqgRr2wi/o0BAhPgl0uv51ND53uUeXY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RSk1m4hbftxQfeYwH7UDQkGRBYMhGUnVfXM4L93pAaKU5WsLesky5/Mpn6sTFUG2s0/wXGPyNd5rrfBOfxMX2LcKtmMUgP2CqptwX13gcawIp0VCVMq4RZS8MHYKlJMnb7dut2xlVoPzYw4w5yBczGk98B2HyKulCQFfA+IImX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Wt79u+pM; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Wt79u+pM"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61GBeNJi2170175;
	Mon, 16 Feb 2026 13:46:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=wcAoY7fiW2MWTvJ+uysYOB2R7G0n1i8d414
	yn7x0gf4=; b=Wt79u+pMGvihKlYU7BORwj1DxNRtEXpZ6YTot+t6qxDTeEorSS4
	S6nNdEiM65nBUu40iDsDUqyMW2683nNLfuyIM/UsAMdKMjovRYxeBD17YhL2D63B
	5GLPXwp0Ys52YXw22SYVhIlFGOYV3Qcs4iJQKKIM7uM4Aqe/CN+/pFOWvxWfgtGF
	BkhnSP1y9wfR6jqTqwXXIhXlkabDwtqUdpKQFGASeT/ilS5doSBCHhEYzuWr2juH
	nVjMx/ymV3D4E/etFxpoPnl27h3G9PTgsMzaSureIJz1hT5M3KoCQjbvpDyA0WSi
	HjFefPp57Jui56fewL+2x+yeEOfiGtg7Zmw==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cbnv9hrw5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Feb 2026 13:46:40 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 61GDkdwN009490;
	Mon, 16 Feb 2026 13:46:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 4cc04njfqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Feb 2026 13:46:39 +0000
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61GDkcn0009475;
	Mon, 16 Feb 2026 13:46:39 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 61GDkcQp009472
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Feb 2026 13:46:38 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id A97C25A8; Mon, 16 Feb 2026 05:46:38 -0800 (PST)
From: Can Guo <can.guo@oss.qualcomm.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>
Subject: [PATCH 0/2] Add sysfs entries to facilitate UFS UniPro QoS monitoring
Date: Mon, 16 Feb 2026 05:46:34 -0800
Message-Id: <20260216134636.3477154-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: OG_3LipfedoKjEVVk9kFxjE4DDyihnYu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE2MDExNiBTYWx0ZWRfXyrBZLmvd0sEP
 lrwU8TP0jaWZIC7Y7lmW/9ZVaQ8P5mk0dbGnpy0KopJEg2GxXZs8v+MofOZIKs8XFGul+pvevil
 LmBjUfsvmSHFXgXWSDYhuzFWjjAzY+L6u4jMXQy+5YI9HiDb0gcT+qFPFlCoFSsXlxDAFMNLT8B
 vZd/tHNI1BrGTzxlIm3WSDS9a2BqXZDDu230q9T3aDQk2e3vrslxsal59ztVmYDhrZtN10ESpWF
 vPVXbHlsu21Aa51muI4Hkc84023HTKmQOowKn+7tGr5Abhcdns3o5OodM8B//M3gII5GdGZQici
 r5crOUvrc4hWq0hZYHi1gIFrqOxNkn+oWHdkgMHpJq0QGEsJNEBrxfsFvAQbK/FwIr8LPIhPs5H
 dumk7VVT/I3FdUkATUIPA6j+sjTGtzUBb9tvmMTfVePLGjnDrTdfkyYsfZ403KqOy1dw59UannM
 xFqOPOf6aVS+XOGL1Tw==
X-Authority-Analysis: v=2.4 cv=b7K/I9Gx c=1 sm=1 tr=0 ts=69931fc0 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=DoZd3WRFHSi2sOIFn6IA:9
X-Proofpoint-GUID: OG_3LipfedoKjEVVk9kFxjE4DDyihnYu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-16_04,2026-02-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 clxscore=1011 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602160116

This series introduces two sysfs entries to the UFS core to improve the
observability of UFS Link and HBA states from userspace.

While userspace can currently configure UniPro QoS monitoring via UFS BSG,
tracking events requires constant polling of UniPro attributes. This series
enables event-driven monitoring by using sysfs_notify_dirent(), allowing
the driver to proactively signal userspace via poll() whenever a DME QoS
interrupt occurs.

Additionally, UFS host or device resets triggered by error handling can
reset UniPro QoS monitoring attributes. The first patch introduces a
ufshcd_state sysfs entry, allowing userspace to monitor the HBA state
and determine when a re-configuration of QoS attributes is necessary
following a reset.

Together, these changes provide an efficient, low-overhead mechanism for
userspace to perform real-time link quality monitoring and reporting.

Can Guo (2):
  scsi: ufs: core: Add support to notify userspace of UniPro QoS events
  scsi: ufs: core: Add a sysfs entry for ufshcd_state

 Documentation/ABI/testing/sysfs-driver-ufs | 19 +++++++++
 drivers/ufs/core/ufs-sysfs.c               | 48 ++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h             |  6 +++
 drivers/ufs/core/ufshcd.c                  | 18 ++++++--
 include/ufs/ufshcd.h                       |  6 +++
 include/ufs/ufshci.h                       |  1 +
 6 files changed, 95 insertions(+), 3 deletions(-)

-- 
2.34.1

