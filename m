Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA643C4B8E;
	Fri, 25 Sep 2026 04:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790311710; cv=none; b=Usix2wEYL3BlRt2iRf2NUZ1cDt96wcHrBzbWJSMn4zbYzzo+/RDF9yaLwYOZYtf+icflWKmptbxkNFJlw1Gc1dg32pKzkVmeqoFC++Kz32y++DGWtBbLhiRIpb45xNGsc+6UGlXB/ldYor+AveWQXYU/zaZ5GLiimG1KEkmXFn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790311710; c=relaxed/simple;
	bh=uyvnMpQAHJaBQ6DkGdidSoyZQ2PA/9DGwRg0DwZSma8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+lCK2FN7Np2+8iwDGHX0ohn1j9ZL72onYVKzUASw46BNLkyLmnTAnYhZnbILQKCiXg4p2ednTnPnAV0MUWbgvOYCH02EZPe2TtzJNx1/g03RO/d528RYqRk4bTEdMlI5tAzFvSXgXZJH/MDl9fcIqZLE/khYYc/yJBQY1INcxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hIVmE1VC; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hIVmE1VC"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4aKdV061566;
	Fri, 25 Sep 2026 04:48:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=7LHvZ+fwN6je3uxuu
	7gw0xpGsCqTv27Dq/zDhA/7oFo=; b=hIVmE1VCCyYM2Iggt+Xwce6I5MML/tMcZ
	9v3T53w+dCYorPlg+PTs8RwASr48Bx0YwPi4aKFUFSYzR+vnx+THonq+kOdq8RiH
	asO5VjDhYMdxuwoBfuSL9S3sZqh7nLFQScxCetH3LPZpHz7nHikgzDGZ/RIvumaM
	8SyPNSwjuCSHnIVzgBhP6MVB5mU752RA0pEsLKj/9Qbivlxw+BuIgtUEYZA3cTLK
	U6OWwl47lh+qzCvI6KldGrftE6XKVjUGPgGOMDswEvkXzen2eae+ydQILf0q4YtN
	hWOECk2i8rmPvpJ2oTlTwy4PjcPIUncfZSSmk+QLbN9oOTCnNDTUg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gskgsn45e-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Sep 2026 04:48:23 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4lXlC3244919;
	Fri, 25 Sep 2026 04:48:22 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gvbu90xq0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Sep 2026 04:48:22 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68P4mLWg25297484
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Sep 2026 04:48:21 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 00C2C58051;
	Fri, 25 Sep 2026 04:48:21 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0AAA45805A;
	Fri, 25 Sep 2026 04:48:20 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.142.241])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 25 Sep 2026 04:48:19 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v11 01/11] scsi: ibmvfc: fix IRQ leak and guard deregister on channel reg failure
Date: Thu, 24 Sep 2026 21:48:50 -0700
Message-ID: <20260925044900.414340-2-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925044900.414340-1-tyreld@linux.ibm.com>
References: <20260925044900.414340-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=V/XoQuni c=1 sm=1 tr=0 ts=6ab5fd17 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=acainBHvso6FeXtkDgYA:9
X-Proofpoint-ORIG-GUID: Ve6OsW7uUbWBUmRZB8EQ4whU-6oHGzyJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDAxOCBTYWx0ZWRfX7RRWCHuJKhv+
 XalXzbjwtlx3swoFPFM8lj/XcYFwj1YyZ9mJREZkrLzkXo0unZ844VfL/trr5i0p2Mnn+u1sdIm
 hxp4FkbqdbMIYHhtPqxyQWSz8AVZZs7yTejDbait82LeaPhVbXuhGfUqIPICVmoFeykxI3Mcov8
 MtTVoCGDF8WFvlVyufhrylXZd0kUd6RbX3RdXwd3On73IafKcpjUQG2yOx/kQvk587nSHTZz+KJ
 jfEMeRjZ3H/TzK3uD/Ndk+Wz0v/ADNE3hVfJQpfin3mQPtwBbDL+tHibohvhX3zVHNMgWs3XpNl
 Am7wfzp7zrVxseVGzMiC/lvCtFUyHdHkq1NgGgm/BsRiXPHxvPE8ETWQrpAVvpks//vXliqnscI
 /XsdgV1YFoB2qhRu1wOQDRcw7wMafvIF8c26hOm0JM7gSBcArKAHuxm49XgG1XdWCy3Vu7/pFhX
 hS+JHjfGZnvZo4yD5EQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDAxOCBTYWx0ZWRfX+kR0OcNrxatm
 0PwzbWd/IkfXbRA8j3I1mvwB8Rth2LF1FQ259I8GUKMq0XzB7qOi7M+LJA1uz0eqxjkEu1sA9il
 6ZRYNfIlVoepzE7mfn2Q90nJLnCzmLE=
X-Proofpoint-GUID: Ve6OsW7uUbWBUmRZB8EQ4whU-6oHGzyJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250018

From: Dave Marquardt <davemarq@linux.ibm.com>

If request_irq() fails during ibmvfc_register_channel(), the error path
disposes of the IRQ mapping via irq_dispose_mapping() but leaves scrq->irq
populated with the stale virq number. A subsequent call to
ibmvfc_deregister_channel() during teardown or reset cleanup then
unconditionally invokes free_irq() and irq_dispose_mapping() on the stale
IRQ descriptor, triggering kernel warnings.

Fix this by:
1. Explicitly setting scrq->irq to 0 after irq_dispose_mapping() in the
   ibmvfc_register_channel() error path.
2. Guarding free_irq() and irq_dispose_mapping() with a check for scrq->irq
   in ibmvfc_deregister_channel() so unmapped or unregistered queues are
   safely skipped.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 3534ac45e9b8..c4dc48ef1ec8 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6436,6 +6436,7 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 	if (rc) {
 		dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
 		irq_dispose_mapping(scrq->irq);
+		scrq->irq = 0;
 		goto irq_failed;
 	}
 
@@ -6464,9 +6465,11 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
 
 	ENTER;
 
-	free_irq(scrq->irq, scrq);
-	irq_dispose_mapping(scrq->irq);
-	scrq->irq = 0;
+	if (scrq->irq) {
+		free_irq(scrq->irq, scrq);
+		irq_dispose_mapping(scrq->irq);
+		scrq->irq = 0;
+	}
 
 	do {
 		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address,
-- 
2.55.0

