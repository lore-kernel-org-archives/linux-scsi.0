Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95A8384237
	for <linux-scsi@vger.kernel.org>; Thu,  5 Mar 2026 11:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772708948; cv=none; b=VG30KNML5IJXiGSdSGpEEXrtqUC2ELQ47TkwydvpcdmLealEJNM9Wx1N0gPvfYiL76qN0m/TP5ZR5LSCDZB7Qyh1rHOXWyqZsi2Gs1qp0GNSnCpEdi/rQV2G2qpVlO99JFUx3C0lOXP2i83ivAt57NEHcrNynUYZpZQGHt12Pek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772708948; c=relaxed/simple;
	bh=bzFoEOvQxPWNEihZz4JkJfD8XtgjFB5z2yTqJBVJEh4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=n8tJpUmDp1rYDSRniVmTetft0QLgR+OGisFaC10V3I5nUpIsqzJM9/XmO99HaRBsi1vwZiJW0Lppf9YtdduiGmaRznRYJ4vo5zsFxb9DUF5F/wrXF4Ngoh4GI52R5u1r9RLPGbCuIxgd7e0raKf9CiQua5229w5+/yPzvVTC9Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=o8d+/mPg; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="o8d+/mPg"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 625AFjDV2922834;
	Thu, 5 Mar 2026 11:09:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=FWG6BW8u1EDqaQGKincjoexSPOlUDV6bKsb
	t/n2w/SY=; b=o8d+/mPggnLFP+bYVn8J4pmcT7cgzHTD01RLy4G0JZs4z5z2/kg
	F7P07Iul/U4SwnKLez1xTgv3DmynlT7lKNAjEbCSoGfq3aP32aB07l2Uy3jmvV5c
	tL2kirSrgbMlIsCknlDPg88RPMDzL93X837bzIZYxkdL/HJN4g/wiwo1+7EOxAM3
	PE5EhFPM41ihZ3+EgXe+R2g96pOXuc4PapD8QsWvJQZxa96jseBC3AwOqw45MNeX
	+LLVxHUc8VVpttDrMn+O5cxL6K6j/2LyqlN24s/nsejnRKaKVecteAPOpCB8V3yj
	JAwkDdu9I2Kh5aK7orTBjnSeaim9iDwzSOQ==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cq2q81amc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 11:09:00 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 625B8xXW017960;
	Thu, 5 Mar 2026 11:08:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 4cq51yantj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 11:08:59 +0000
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 625B8xVR017950;
	Thu, 5 Mar 2026 11:08:59 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 625B8wXt017947
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 11:08:59 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id C6B535B2; Thu,  5 Mar 2026 03:08:58 -0800 (PST)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>
Subject: [PATCH v4 0/1] Add sysfs entries to facilitate UFS UniPro QoS monitoring
Date: Thu,  5 Mar 2026 03:08:55 -0800
Message-Id: <20260305110856.959211-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-GUID: rLczA3ZS6q4q1oUIPBrVBlMgBhj4_PyU
X-Proofpoint-ORIG-GUID: rLczA3ZS6q4q1oUIPBrVBlMgBhj4_PyU
X-Authority-Analysis: v=2.4 cv=GecaXAXL c=1 sm=1 tr=0 ts=69a9644c cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_K5XuSEh1TEqbUxoQ0s3:22 a=L804ja9khbPVvLby85IA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA1MDA5MCBTYWx0ZWRfX38/Tx2KRJ0xB
 dsVgWgxRjxq4z811mU86LcRkGcQU+q6jej+xGK8/+wT32e/bdj4cH0VdLy6T4pRQOOWRL1gStXg
 MJzvPpgQ6uEN4G+/odWQ83x6PgYnFhcPp4eQ1NEhdqQMzIZhplwZv2ELiOFeY6DYhb7ckSyifRH
 ikdbEZeLuOaKKAxX4LLL9GTcrwUG0PA9OCVI3D6wEi2q0W5xx6MZt6XoEfK4Hgs8qnRMxGinOCl
 NqQTCCFmwQ4dWF98Yw4HaglZlfZSGOnnhr38iUy11hzSDwcfexvuVeCrNgEpY12lXAm1IIA5YTj
 5wNk1NOrrbohld28KAdfb7+O6xL+BTKtZbvLfMeCQwLfeZb3DJTwEvvlHLplsfiQ3LisgS61fk/
 fW+f9QiJBvFA1g4RuVHng6FjHn4yiNn8taKAKcozwRelolYUzWg1kx4gOQvfL6UV99Qh6khtq/L
 Ny07tDrJJc5dnXmIAEw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-05_03,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 impostorscore=0 spamscore=0 suspectscore=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603050090

While userspace can currently configure UniPro Quality of Service (QoS)
monitoring via UFS BSG, tracking events requires constant polling of
UniPro attributes. Additionally, UFS host reset caused by err handling or
resuming (from LPM) can reset UniPro QoS monitoring attributes.

This series introduces a sysfs attribute to the UFS core to improve the
observability of DME QoS monitoring. Userspace can configure and enable
UniPro QoS monitor via UniPro QoS Attributes (using UFS BSG) and get
notified by the proposed dme_qos_notification attribute without polling
UniPro QoS Status attribute. The dme_qos_notification attribute is a
bitfield with the following bit assignments:

Bit	Description
===	======================================
0	DME QoS Monitor has been reset by host
1	QoS from TX is detected
2	QoS from RX is detected
3	QoS from PA_INIT is detected

v3 -> v4:
  1. Updated 'Date' to March in Documentation/ABI/testing/sysfs-driver-ufs

v2 -> v3:
  1. Updated texts in cover letter.
  2. Removed the second patch in v2.
  3. Incorporated comments from Bart.
  2. Improved the Documentation writeup in the first patch.
  3. Added sysfs_put() in ufshcd_hba_exit().
  4. Used Bit[0] in dme_qos_notification attribute to indicate DME QoS
     has been reset by host.

v1 -> v2:
  1. Removed a blank line in the first patch in v1.
  2. Updated texts in cover letter.

Can Guo (1):
  scsi: ufs: core: Add support to notify userspace of UniPro QoS events

 Documentation/ABI/testing/sysfs-driver-ufs | 23 +++++++++++++++++
 drivers/ufs/core/ufs-sysfs.c               | 30 ++++++++++++++++++++++
 drivers/ufs/core/ufshcd.c                  | 24 ++++++++++++++---
 include/ufs/ufshcd.h                       |  9 +++++++
 include/ufs/ufshci.h                       |  1 +
 5 files changed, 84 insertions(+), 3 deletions(-)

-- 
2.34.1

