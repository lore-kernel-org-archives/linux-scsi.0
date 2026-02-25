Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE85230BEC
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 02:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771986587; cv=none; b=EzZuregEM8Y6VeOz54zbHgoC/JeK+v9rV+G6kdfPedrAf/GZAt8Ny4y1gFz8iPzUGHcU//VK8QVWtVZy3pZAbptpGj/f0R/25P4R7iaHJ/DkEH94IhLW/BcXVshoWtxoK1E0IZGaqmmOGwC0+k2Wp7ofr10CbFS7XDCXucTPnoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771986587; c=relaxed/simple;
	bh=hyGuGqa+A3vJ103t+nW2zNah2pH/Mk+mJMQFXMU5nww=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=grCdaS0u5RrYCeAYUzQbaCAl5BqHcpX8obJXhHgEBb8JseWJqcPoqWZGT78yWH7ijH+wWse6qkUCJT64yYO7YTcOGIdXfdu6GYCfapAErlwUqKNSO6+pIwLJDlKeeblfqeHq1Y6Ge3OSECqYmd0Bh1mVu8km+jJj54ybsf1ECK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=axGZ/tB1; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="axGZ/tB1"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OLuTrJ061750;
	Wed, 25 Feb 2026 02:29:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=OWBCv6OP7G8lrHHGLKXxnH+CDtJPy4N6elr
	6WuTVStQ=; b=axGZ/tB18sFpJsD+GJamPHMJHVMrTTAQeN5bF3/ab5Jq5MUMGTW
	nXMp6nxSQN1MzDRS5OTaVzjfe30HkmnxLjrHs35LGa2SEipMrNpZrSwpyf3G2wrz
	AXB4uhnngf5zAZ+r1/PY4MpwLb1wf9BmxTZ7b0dxjKm0ys82kq6Q+5WmTZnNzfyT
	JuT0lMp61vKmAE7ohZ4oGESYRLhm8d/NapgaH1JiJJgiWNVDcsWF/6Ct95y47bWx
	xiUc5s53HVi3kpSKPrupKL30iTqUDkDeZe/FXp8S7M3MzxsBbsp60+rCOZa7MlNq
	dPGvqu1uM8h7zN2xMkjt6t7Q53usEOlPauQ==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cherja0a3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 02:29:44 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 61P2TiDZ024752;
	Wed, 25 Feb 2026 02:29:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 4chmqjhmfm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 02:29:44 +0000
Received: from NALASPPMTA03.qualcomm.com (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61P2TiEV024746;
	Wed, 25 Feb 2026 02:29:44 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 61P2Thc3024742
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 02:29:44 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id D8ECE5A5; Tue, 24 Feb 2026 18:29:43 -0800 (PST)
From: Can Guo <can.guo@oss.qualcomm.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>
Subject: [PATCH v2 0/2] Add sysfs entries to facilitate UFS UniPro QoS monitoring
Date: Tue, 24 Feb 2026 18:29:40 -0800
Message-Id: <20260225022942.345564-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDAyMSBTYWx0ZWRfXyznBaF4eITcK
 qGZRe14ve/B64NYsRtE/P9wT6eTilXqfoXcIOLEg67y+lgCbxGDSVQx3e2Ch0a8DQV7Ongmayop
 7ks4Fv97U9qC2PYIZSnZTGaMGtqoM/OUPMPdLYUSG+gido1jpSph1DW5Af/hnH7KmRxC9PPhPHD
 vxRA1jH6OROKQmYH0K0MgvIfT1xCe4KNYmu2xImswAZzmHc0zk7pni6VCCMWoNOH9020AWoIpWc
 hjaX7RmihkgbEPiMLT2fcu/syf4rZOCB37T+fMO8zYgHE+S8rGGiDPBOGR4E26zdYPMEUZ6MnEh
 n1vBL05ADmCrVyyxdo0nIKdgb2DfRitZNfoDAI4WUfxqdu5O/TH7PSBxF40AkdpG6P6rsoxgNWg
 WCA2OnhYccQNV5OUx6xeyGC7At8fHuXaIWC/SFnNgokodJcCWdB785eZROFCgch3rESyIJkw/QF
 DKPajMXaAKywtAcbpJA==
X-Proofpoint-GUID: BtXODpM4BVb5bWbkzgwW9zy8czdmZD03
X-Proofpoint-ORIG-GUID: BtXODpM4BVb5bWbkzgwW9zy8czdmZD03
X-Authority-Analysis: v=2.4 cv=NeDrFmD4 c=1 sm=1 tr=0 ts=699e5e98 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=DJpcGTmdVt4CTyJn9g5Z:22 a=DoZd3WRFHSi2sOIFn6IA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_03,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 adultscore=0 spamscore=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602250021

This series introduces two sysfs entries to the UFS core to improve the
observability of UFS Link and HBA states from userspace.

While userspace can currently configure UniPro QoS monitoring via UFS BSG,
tracking events requires constant polling of UniPro attributes. This series
enables event-driven monitoring by using sysfs_notify_dirent(), allowing
the driver to proactively signal userspace via poll() whenever a DME QoS
interrupt occurs.

Additionally, UFS host or device resets triggered by error handling can
reset UniPro QoS monitoring attributes. The second patch introduces a
ufshcd_state sysfs entry, allowing userspace to monitor the HBA state
and determine when a re-configuration of QoS attributes is necessary
following a reset.

Together, these changes provide an efficient, low-overhead mechanism for
userspace to perform real-time link quality monitoring and reporting.

v1 -> v2:
  1. Removed a blank line in the first patch in v1.
  2. Updated texts in cover letter.

Can Guo (2):
  scsi: ufs: core: Add support to notify userspace of UniPro QoS events
  scsi: ufs: core: Add a sysfs entry for ufshcd_state

 Documentation/ABI/testing/sysfs-driver-ufs | 19 +++++++++
 drivers/ufs/core/ufs-sysfs.c               | 48 ++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h             |  6 +++
 drivers/ufs/core/ufshcd.c                  | 17 ++++++--
 include/ufs/ufshcd.h                       |  6 +++
 include/ufs/ufshci.h                       |  1 +
 6 files changed, 94 insertions(+), 3 deletions(-)

-- 
2.34.1

