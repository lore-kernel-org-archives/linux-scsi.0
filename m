Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D284C175A8C
	for <linux-scsi@vger.kernel.org>; Sun,  1 Mar 2026 12:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772369486; cv=none; b=GIy5SzmPuUJ5n30gf18ToIusVJPGxZRjRiMjWXSPGxdfXenvtt0HTcSMgU+v48RJnRaJ3/Pm7yYAD8Cp0rFAR32y8oFT5blqDRHBXGkU/iUSOikq8f+mPlGgSmLgFkWjkLhxfiAFfc13ZWtKKNM6kncppsfrix0AHWLVaTReNE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772369486; c=relaxed/simple;
	bh=wgT9aQ6ozHfMwSBleuKSPPaATyc6nalmjMQ0QIygP9Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gOBfsQcggqUnlSsqRCXlmNnrREUqcEjqLigvLgDp+9u3syHJQJJuQ2y3IgiO3ivzus5vhxMrn7S+PS7H99sX5THIqT3UFcvE02nOiSL8bwUKtuPPFpcv1V171Via+LKdE5OjGnHTWo8YxJul0w8sNJheAbQvv6jFBYRftB5qUfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Nquwp/Zj; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Nquwp/Zj"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 621AaYI2533014;
	Sun, 1 Mar 2026 12:51:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=BHNL/+NtmMN5rqm1jpP66GL8roJU50cQExm
	PiLSnWFs=; b=Nquwp/ZjImG9a8LFFCriIDFX+U9rrnzCxohPHgwDuMYGL6OZJdl
	iuXUigJ8QgLTQu5hnR2jb8A3+aI3u5iXYmMZpJsaNWHuFPinrdiqRVYIYKgAL41x
	CryOYHf2DT4xpG0zT2Fl0LKDIKW54CoGGJa8XZ+3bKwDOQ5hvG7SnATCWlzXpJBY
	8rxBeXSNtkwThIgO02MsUn2Hf0wg2nvRR7shgnKchdQltQKlx8Xy5PlPVhmjiAJU
	zUL1Mb5aZAnt3+me+4kwL+gligQUcw2IYWYu63160lq8mhIHQ6OfcaEBRrMdUNBy
	BQYJXYre2t9OWMAmpUXYQSA6ydt0zjzZy+A==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ckshktmey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 01 Mar 2026 12:51:19 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 621CpIww013689;
	Sun, 1 Mar 2026 12:51:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 4cksekjhek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 01 Mar 2026 12:51:18 +0000
Received: from NALASPPMTA04.qualcomm.com (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 621CpIQj013527;
	Sun, 1 Mar 2026 12:51:18 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 621CpIDa013370
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 01 Mar 2026 12:51:18 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 18C745A5; Sun,  1 Mar 2026 04:51:18 -0800 (PST)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>
Subject: [PATCH v3 0/1] Add sysfs entries to facilitate UFS UniPro QoS monitoring
Date: Sun,  1 Mar 2026 04:51:15 -0800
Message-Id: <20260301125116.808992-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAxMDExNiBTYWx0ZWRfX79PORvN0H5K2
 +kLX1zCfindVx3nLLS4H0DHWr8tDC6/7V3vrH8uW+Sn6yYSkFKUenpspAPAkfZnSKVJ5UeckaFv
 5IpJtZVVBFS3sUSm0W4y70fdujv3b4qKkh9W6bv2BcTWDU3/Je7b9Lg6Bk1oEZo9wc0F4FjJLBu
 5Fpa0ojeV7ENsniVZzwwJRtZ5klanGl16QzGWcVomjV/dCRYAspgjfqo7cZmC2DhSlkNn4SUba8
 KUAzGIuOJ/I++DwqzzwxCuuCLrLAOLK0KQzzlgh3dwTWo5H/5w6jeauV02+RTR65esqg7qPz7kZ
 j7L7trvXxEFbwUdpzFiDd0lgjf2fTDWDLmmztQXrvdHvndw6GjqVD2zXO1j9oBwP9sLeHJEt7Bx
 lptohkWbduec1Xu65FoBYbhcPMmygVFCYE33QQkbnMXW2RZsDZVex3nKgV6k3qIXvPNXBVHdBib
 kHK7RRS0neGN5v0i74w==
X-Proofpoint-ORIG-GUID: IH9ZgWw_dPV9yJ03zCR8zgeqAU0AZMMx
X-Authority-Analysis: v=2.4 cv=EvbfbCcA c=1 sm=1 tr=0 ts=69a43647 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=rJkE3RaqiGZ5pbrm-msn:22 a=L804ja9khbPVvLby85IA:9
X-Proofpoint-GUID: IH9ZgWw_dPV9yJ03zCR8zgeqAU0AZMMx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-01_01,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 impostorscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603010116

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

