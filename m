Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303E230276A
	for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2025 14:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764168036; cv=none; b=LfrKA7YZf9YiemEpY2cq93m/adtauEErcyV5FGAfI6RFnnJUYtmpBYvwFfAAlUJjSvIw3QtCVWxmPLAMF7S6yitosAE7dRP9zNuwoSm1INdSmNwMk03zey8+T8AXcYknPT94CLrGfoaVV6/6v3XkgtrMkOqmMEK1teRIAPSCWqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764168036; c=relaxed/simple;
	bh=CYyddyXviv3taKXdklE7V5boCf+1M5slFXkIIMFjpkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OQzFpwGPIuPzb6u2IP24ErnVm7S3vLQQiGGvlkEKmFGa9lmiPdkRLXBgFVcNm/rOB+zZ1Ysp33z2jyGsVoGsgN+iSx3oLBuEf07FFYCWMDB3Dotur0HbkrNuOr1t6w/Ujrlapw+e5TNaq6+hLjUtTGZZrq8ZNcAlXSGxmG+6mrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WhV68p1i; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WhV68p1i"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQB1YI7025641;
	Wed, 26 Nov 2025 14:40:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=wN3Cm5pluYfMPObrIUmZCsNh8jqHP4Qjw9OiaVPaN
	9I=; b=WhV68p1iuaMMcxnQaFrBD0tlKSPy+mo5W0mUmWz0ZlFBXRTVE/KhPW5sy
	GaZHAb9FGRH/wt3DQoyskhcCOYvIR8qwJh+O/fKEemwnKQ5iOR0kirJijUQr7GYR
	sea9o58tvivdW/J1vjwEbaPHgmT/77oIAcwDdmyg6WRuEM5PxRZcbifdw55jt2j1
	acjdh3EvQ8JZTyi+iGXiN8wYfgzneN3ySOnQSPS8uuGPYuRl0eyjkAYz94iCDGiR
	IO1mV2t2aT07OTtoKU5jD6Q0yta1RxF4ORIz4owi7d1sBsjvnK4q2p/svjmsMn6J
	XxFfo+VVWnz+eT1yQTy+xlkUiCACA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak2kq3vec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 14:40:29 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQE0xiu030759;
	Wed, 26 Nov 2025 14:40:29 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4akqgsk6r2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 14:40:28 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AQEeRUv26018530
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 14:40:27 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 61D902004F;
	Wed, 26 Nov 2025 14:40:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 42AF220040;
	Wed, 26 Nov 2025 14:40:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Nov 2025 14:40:27 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: Chris Boot <bootc@bootc.net>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: target: sbp: Remove KMSG_COMPONENT macro
Date: Wed, 26 Nov 2025 15:40:27 +0100
Message-ID: <20251126144027.2213895-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAwMCBTYWx0ZWRfX2rPxd1X9SmeV
 Q3fIBhUbZVtfQSsOqVpV9rouGKZYpXtyTzlAkcrVgwa4uOTMnMBRx8QaV2JIYXr6WRIxoaJwdgv
 AYdkJKA9pqsUPW7zHUaPhBEGJmAAeRCvc6sC0rn6W8V/pmY/d/zkmE+DRIXGQkCbsislooo6lc7
 T82/ja+dIjVPYHzEzhBeHo6QArdJ4c6s1r8/qmFHTGMv391iPX5N36Y+eBW8xgszo5tBHORNRxw
 D2Fy0vTdARo0CfZoS6PJOEjGlpwCIyqY02BzBcEy46AF90Zy4Cw50hV7ulu5s7Y+nuxmockeCii
 +l4JDTy+aS9Jq3oHKaeuocaY8YLHJXTZ4vurRZ7vvHrJc9EeUjrKG9QWP3pHBOSmuwb7EE9WMNN
 ogm6nqTilM7A+PZnn7WQjsP/qGZKkw==
X-Authority-Analysis: v=2.4 cv=fJM0HJae c=1 sm=1 tr=0 ts=6927115d cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=07d9gI8wAAAA:8 a=VnNF1IyMAAAA:8
 a=bVn-44OEAAAA:8 a=M9wc2OgTsJqKPhFCr0sA:9 a=e2CUPOnPG4QKp8I52DXD:22
 a=wc5UUqwVB_nuYuPpUnYO:22
X-Proofpoint-GUID: rlv61v5r8y6G12MQXqXfk_3YAb_StCxj
X-Proofpoint-ORIG-GUID: rlv61v5r8y6G12MQXqXfk_3YAb_StCxj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220000

The KMSG_COMPONENT macro is a leftover of the s390 specific "kernel message
catalog" from 2008 [1] which never made it upstream.

The macro was added to s390 code to allow for an out-of-tree patch which
used this to generate unique message ids. Also this out-of-tree doesn't
exist anymore.

The pattern of how the KMSG_COMPONENT is used was partially also used for
non s390 specific code, for whatever reasons.

Remove the macro in order to get rid of a pointless indirection.

[1] https://lwn.net/Articles/292650/

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 drivers/target/sbp/sbp_target.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 3b89b5a70331..e0472b4dbd90 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -5,8 +5,7 @@
  * Copyright (C) 2011  Chris Boot <bootc@bootc.net>
  */
 
-#define KMSG_COMPONENT "sbp_target"
-#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+#define pr_fmt(fmt) "sbp_target: " fmt
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-- 
2.51.0

