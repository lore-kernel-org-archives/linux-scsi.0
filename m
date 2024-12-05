Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81F020D4E9;
	Thu,  5 Dec 2024 14:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733408439; cv=none; b=H6lM0vud8wfVrUcCTdv8wdExD+OCxVquHJQVNSf+FGlc8nL9EgH94n7h95EcTmLQ6QYk2DgGVly9IshWHKFoSuwUqI7OPCsC6mItMMLe1W3AJVGFgB/CzTWtP0VirNTyKiCTWDs1kxM86rDEsqwht/LRjjbLbHO9jJeUMGR24rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733408439; c=relaxed/simple;
	bh=gSKa9WhavEhtAbM1vsa9yDdbEx2Gc6mFrz1UylHc9tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBdagmipE4xnK8EAOWbbGydGmQb3dq9wc+G4VHB1ryARzT4xR5UOjjkzXsZBupdA8h/rnkAS0BtvJcRTFEow3tSdkvBEyECNzxgAspKVE4umwCWaX/NQdutTGCMJv5LHkIv4lD95Kjja+x9jKHBb6UyfU92G/0GPRM2AGMd4T0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gtxptIU8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gtxptIU8"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B56brDC017939;
	Thu, 5 Dec 2024 14:20:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=gyIHPWyO6IIdVVdER
	8WYYy+vDlmEBd+/Zqg25fp99ng=; b=gtxptIU8H/29qFG+fEHvjnVPW8MjINqMH
	C0+Xz1X16DxwyM04XtK+O1S+629bK+Mi8o2p/42ZSCjPPL9XeZiucPWb6zMPASmv
	6PAyBK2gzBAdz/8lsiaPcF2mVE3/CeLF3N4aSHb8BtQQX4peQ2AenpcRIXldcPct
	BlGeI6X17Nw25GX/4OZcBCCCohG0q9k4wm0lHmcsJVomwHzqp0ugiv3syfUj0W1c
	Q6m9Oshkq6JrjHeDf4bwv9c8ZM0hLKhxycjo5iYXW58mqQQEhh1AbSAsjmi61LUW
	qktKayg98/WQ9+MW8GfRstBxK1ifQ0FhvqImrBurYBCoZGl98Oz4g==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 437tbxwrmh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Dec 2024 14:20:33 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5C4FqC008576;
	Thu, 5 Dec 2024 14:20:33 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 438f8jt3f7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Dec 2024 14:20:32 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4B5EKRLc56885732
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Dec 2024 14:20:27 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D9D020043;
	Thu,  5 Dec 2024 14:20:27 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 67B7920040;
	Thu,  5 Dec 2024 14:20:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Dec 2024 14:20:27 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH 1/3] zfcp: correct kdoc parameter description for sending ELS and CT
Date: Thu,  5 Dec 2024 15:19:30 +0100
Message-ID: <20241205141932.1227039-2-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241205141932.1227039-1-niharp@linux.ibm.com>
References: <20241205141932.1227039-1-niharp@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2hmu2xlq4XxL_MHXlp6ePTXhhgyoaq1g
X-Proofpoint-GUID: 2hmu2xlq4XxL_MHXlp6ePTXhhgyoaq1g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 phishscore=0 adultscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2412050101

From: Fedor Loshakov <loshakov@linux.ibm.com>

Since commit 7c7dc196814b ("[SCSI] zfcp: Simplify handling of ct and els
requests") there are no more such structures as zfcp_send_els and
zfcp_send_ct. Instead there is now one common fsf structure to hold zfcp
data for ct and els requests. Fix parameter description for
zfcp_fsf_send_ct() and zfcp_fsf_send_els() accordingly.

Signed-off-by: Fedor Loshakov <loshakov@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Nihar Panda <niharp@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 22e82000334a..99d6b3f8692b 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1218,7 +1218,7 @@ static int zfcp_fsf_setup_ct_els(struct zfcp_fsf_req *req,
 /**
  * zfcp_fsf_send_ct - initiate a Generic Service request (FC-GS)
  * @wka_port: pointer to zfcp WKA port to send CT/GS to
- * @ct: pointer to struct zfcp_send_ct with data for request
+ * @ct: pointer to struct zfcp_fsf_ct_els with data for CT request
  * @pool: if non-null this mempool is used to allocate struct zfcp_fsf_req
  * @timeout: timeout that hardware should use, and a later software timeout
  */
@@ -1316,7 +1316,7 @@ static void zfcp_fsf_send_els_handler(struct zfcp_fsf_req *req)
  * zfcp_fsf_send_els - initiate an ELS command (FC-FS)
  * @adapter: pointer to zfcp adapter
  * @d_id: N_Port_ID to send ELS to
- * @els: pointer to struct zfcp_send_els with data for the command
+ * @els: pointer to struct zfcp_fsf_ct_els with data for the ELS command
  * @timeout: timeout that hardware should use, and a later software timeout
  */
 int zfcp_fsf_send_els(struct zfcp_adapter *adapter, u32 d_id,
-- 
2.45.2

