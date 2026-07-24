Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF81C3A1DB;
	Fri, 24 Jul 2026 06:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784872907; cv=none; b=e/ib8vuJjMkqwL6yHvtcxqIvO6uqIIvbE7LUw8iOoKk3ono4ww9pSdbCbH0Ey8Jvz5aVr7FeLC7ACh8D6kqRvU+cufWf9QhMrGzA0td5T44i2QcxMBUi3T16Xp2VpCR0gE/qYNy3s2iqINCm9aXe/ubj5NXFK2+lJQ4Hvh8I4mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784872907; c=relaxed/simple;
	bh=pCnOOMhl5Bfb1yTKdYmxhxI1ULRZSCgiBibTGT0d85c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQFWcwBK1hFmkTReEJvyi05MNRZjaaWKISb4duw7cuRj/35c8mgTi3dzUYcFsF0sUD+3IKMkohUGdRF0BSVuKHhxf1P0vJQq1dLPlTjDOX1byx/JANL3ep4MgCFGoxn++pver1/46vCXeBoD0ZeUb/D4IEpNVWd4ZktTVvkPiR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mkYnJoJH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mkYnJoJH"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66O5BnoA904032;
	Fri, 24 Jul 2026 06:01:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=N9ZIpcOzcgZhe3o1u
	iyu1lpaEUGg/yFaYR8f+O885js=; b=mkYnJoJHXd3pTwL8vntRcXUy6t8Puun8K
	36HnNBlLHYdsWuWCgdI5mBDWYpjejcFo64IIm7BvbXP/GTlcDVHglD8iIrMPTS91
	chDHazeMie/Y0e3+XfcolSPzh1RNDLKFwkAN/VGMBQWdBomnu4XenuWEhUxTQgq6
	NZ07tk0EGYcdfM/SIa9V6x5ymWLg7NrDqrb1PRjjZNNW05pp0qeUb6EQp5IJcayO
	KMq83FuNjQhgvqKQ1h/aYvVhJWS9yOStbJbGIPLytTSiq0sv6Mphs5S4bPajE4rc
	su0Ro+qQY2a1a/TkgNn3gaFulAbCpKycofsckrcxCZweZvPP6Pv1w==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7abua7t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Jul 2026 06:01:42 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66O5nf35016926;
	Fri, 24 Jul 2026 06:01:41 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgpgyqcr5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Jul 2026 06:01:41 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66O61ZlF15270210
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jul 2026 06:01:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E4B64201AA;
	Fri, 24 Jul 2026 05:40:03 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B4426201A9;
	Fri, 24 Jul 2026 05:40:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 24 Jul 2026 05:40:03 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        =?UTF-8?q?Vasily=20Gorbik=C2=A0?= <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        =?UTF-8?q?Christian=20Borntraeger=C2=A0?= <borntraeger@de.ibm.com>,
        =?UTF-8?q?Nihar=20Panda=C2=A0?= <nihar.panda@ibm.com>
Subject: [PATCH 4/4] fixup! zfcp: trace return values of sysfs unit add store
Date: Fri, 24 Jul 2026 07:39:34 +0200
Message-ID: <20260724053934.2781087-5-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724053934.2781087-1-niharp@linux.ibm.com>
References: <20260724053934.2781087-1-niharp@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDA1MCBTYWx0ZWRfX1DZmt0Y3WDN1
 RAx+TAPfOLNc00YHzC/h7Z7NV7L7NVNVvhz7cYczeYoGTx45r4wCLWt1FmLn+RQV7rLUXujEGsm
 G990x8TG8Mphzz9mUABTuyhr7eExaPkQdBc7qKBhqvufFqpdfIVUO/3s8CEpJThlwlhJXaVQ9lW
 ZmlplwNo43J+Jdn9zPXedpui4wKz3N8sXPklkCi0JLWq7DQKGyKtD5ihj8iWd6y8g0bBBQ9jTq7
 A3O3NmQ9Th2yyqgMfuGB7XigVshvLZ+g2Vm8TtwLksEMuqQXANpx4HysKpi9CF6si/g26MJTRpW
 QyDJweuiPkRErz/Kr2kNmEQvuMmidNSZ3gOJ7yIDU144UDXg/Frz7izlvFwhh0cvKWwaaEwMzHA
 3iWCA5T4M5egPnPmDgkxiZmMo6hVLB5A5NvriU54DJqNtb65eoZjZ4TuY+aeQ78s41mdKbRsOkJ
 +s+pCKuqswGntZiQD1Q==
X-Authority-Analysis: v=2.4 cv=F7ZnsKhN c=1 sm=1 tr=0 ts=6a62ffc6 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=MVSg9qra9vKCiucYxwQA:9
X-Proofpoint-ORIG-GUID: ybgtzIpYWm8Eq0q_sdSw8KLzjV2mg984
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDA1MCBTYWx0ZWRfX6mlWdTK/tGO0
 l4yz48v4aq3ZqPA5gzWlGmCPsBsGe5aQhc5LAuXt4rbULUoOYTqRBJe7gytO6//VznnnXEO/glG
 KAgQN3DCUPllUbIVFzPgviYG+annD/E=
X-Proofpoint-GUID: ybgtzIpYWm8Eq0q_sdSw8KLzjV2mg984
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_01,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240050

upstream discussions...

Signed-off-by: Nihar Panda <niharp@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 729c9664a48f..597e04cdcc97 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -443,7 +443,7 @@ static ssize_t zfcp_sysfs_unit_add_store(struct device *dev,
 {
 	struct zfcp_port *port = container_of(dev, struct zfcp_port, dev);
 	struct zfcp_adapter *adapter = port->adapter;
-	u64 fcp_lun;
+	u64 fcp_lun = 0x0ULL;
 	int retval = -EINVAL;
 
 	if (kstrtoull(buf, 0, (unsigned long long *)&fcp_lun)) {
-- 
2.53.0

