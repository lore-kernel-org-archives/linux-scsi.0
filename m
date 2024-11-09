Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFD58F49
	for <linux-scsi@vger.kernel.org>; Sat,  9 Nov 2024 04:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731127534; cv=none; b=hsy7H9IPcC2xUb4YjWAJ402BW79fEQONgrhAbM03NueyFtlu/rSHjHk91FR2pR2RPYEK4S7Q2EE7eBpLk9zONfIvKHADyipRzh4yeopq72CRnrYDmpM+ElM60sZJA8OBmab4bL5KlUhJKim4P7+i9VDk7q5ALaqeRjaenBdzMiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731127534; c=relaxed/simple;
	bh=D6Pt6Hi4drKyc/3hSREbGwEXRBznzUXvEPxaQadJyC4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=n8UqMTa3fllA391h5J9z1qi5Q8VVwFsBGi31bRoeFcIM5sRX9lv4bVIhFGO3eSnaCFsWjelgKEQMb/M3xn/WGYKVl/FbwTeDCS5KvGf4qkFZIJHln5zUwhtAWcMZ4al8I+s2IXnWEKvdqOXEyk7tVJaKnepR9Yrmsh16RVpe4qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UQl7/NSy; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UQl7/NSy"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A94NS1K005246
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=yPR5Iw03E/IiPK3kXZVG+nIFP9Ngd
	JT1lX+UQxZ+nGE=; b=UQl7/NSyMcwpiDjy21Gr/nHX90iLNe3SEp23CB8R9K3Lv
	JBCteqX2XJWUTeS6Ky9Pl/PcaGwDJ9Xr0Zh23rPKEFye1KoZ2tCNeV0g4x+6A9x7
	qGBFmezxm/OEFTneQ3jQhhB70Y0XiyJN/yfbnvpjhr45MKAP0qHDj+4QTgTAOtcn
	PzHSKQfLKIKGJtjTvIiZQNUxZXS+FL0ros/KTbl1Z7NKoraBuMADf5EqJdVT/fk9
	Ba575VZJL5Bw+MlPBdBGY+2E63pUWp7BAcn8p3jKFm3rwpb9GWe9zIwW+pSbLpVb
	G4oC/nlgR96Fz632O5OoNEE/e2Kytnqvw2hYlxlnw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0nwg07t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 09 Nov 2024 04:45:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A91XZOV034293
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx65aj9p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 09 Nov 2024 04:45:29 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A94jTdM001575
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:29 GMT
Received: from hmadhani-upstream.osdevelopmeniad.oraclevcn.com (hmadhani-upstream.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42sx65aj9h-1;
	Sat, 09 Nov 2024 04:45:29 +0000
From: himanshu.madhani@oracle.com
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: [RFC v1 0/8] scsi: Multipath support for scsi disk devices. 
Date: Sat,  9 Nov 2024 04:45:21 +0000
Message-ID: <20241109044529.992935-1-himanshu.madhani@oracle.com>
X-Mailer: git-send-email 2.41.0.rc2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-09_03,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411090036
X-Proofpoint-GUID: usTVli0obIeLE6_kPv6Ek5vNaU5JuZPW
X-Proofpoint-ORIG-GUID: usTVli0obIeLE6_kPv6Ek5vNaU5JuZPW

From: Himanshu Madhani <himanshu.madhani@oracle.com>

Hello Folks,

Here is a very early RFC for multipath support in the scsi layer. This patch series
implements native multipath support for scsi disks devices.

In this series, I am providing conceptual changes which still needs work. However,
I wanted to get this RFC out to get community feedback on the direction of changes.

This RFC follows NVMe multipath implementation closely for SCSI multipath. Currently,
SCSI multipath only supports disk devices which advertises ALUA (Asymmetric Logical
Unit Access) capability in the Inquiry response data.

Patches are split as following

Patch 1: Add new SCSI multipath files and makefile changes for enabling multipath support.
Patch 2: Adds changes to scsi_host structure for multipath support
Patch 3: Adds error handling capability to the multipath changes.
Patch 4: Wires up commpletion path for the request
Patch 5: Adds sysfs hooks for displaying iopolicy and state.
Patch 6: Adds changes to use ALUA handler for multipath
Patch 7: Adds changes in sd driver for multipath.
Patch 8: Adds changes to scsi_debug driver for ALUA testing.

Here's list of TO-DO that will be addressed in next RFC version

1. Cleanup sysfs directory structure and only show first multipath device.
2. Test failover scenario with multiple disks and injecting errors with IO.
3. Test updating iopolicy while running IO and make sure path failover happens.
4. cleanup ALUA code to integrate more closely with new multipath code.
5. Performance numbers for the multipath disks.
6. PR ops are not yet handled by this series and will be added in next RFC.

Thanks,
Himanshu

Himanshu Madhani (8):
  scsi: Add multipath device support
  scsi: create multipath capable scsi host
  scsi: Add error handling capability for multipath
  scsi: Complete multipath request
  scsi: Add scsi multipath sysfs hooks
  scsi: Add multipath suppport for device handler
  scsi: Add multipath disk init code for sd driver
  scsi_debug: Add module parameter for ALUA multipath

 drivers/scsi/Kconfig                       |  12 +
 drivers/scsi/Makefile                      |   2 +
 drivers/scsi/device_handler/scsi_dh_alua.c |  15 +
 drivers/scsi/hosts.c                       |  12 +
 drivers/scsi/scsi_debug.c                  |  16 +-
 drivers/scsi/scsi_dh.c                     |   3 +
 drivers/scsi/scsi_error.c                  |   8 +
 drivers/scsi/scsi_lib.c                    |  25 +
 drivers/scsi/scsi_multipath.c              | 896 +++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c                  | 104 +++
 drivers/scsi/sd.c                          |  83 ++
 include/scsi/scsi.h                        |   1 +
 include/scsi/scsi_device.h                 |  64 ++
 include/scsi/scsi_host.h                   |   7 +
 include/scsi/scsi_multipath.h              |  86 ++
 15 files changed, 1332 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/scsi/scsi_multipath.h


base-commit: 128faa1845a2d5b0178b986f3bd18fb38cc08cc2
-- 
2.41.0.rc2

