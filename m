Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501093E171E;
	Fri, 11 Sep 2026 02:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789093171; cv=none; b=qHCUNvYhXMkGr6VW/xdsM/qw5nS0oeOWeLRk33lAsspTp+8dJM51orZMTR38/vjTuRMx528nQyYGs8Zf6QaYRBMkh6QQyE5/uC2lNKGC4E+10AD31UgTWm1sBMVvgfXCCdZ3jnrts3qn69rWZAi4FA74QgSnc8BzX/gCpYgy6Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789093171; c=relaxed/simple;
	bh=AYtr4P1+OoFMuKpi0e4Fpa//4fIG28Wi9w5zooY5Kqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/nW5OTRRjvJa9ghl5xcNtanvQx31kVEqFm5s77+obls/P6wFGFdW+4rbaKqVs86A3i1A7+B4g87h0iKoxlb69WH9zkueJ/bTd4Pd0etfoBS/JWzQQxUSiFqg1xfyAuuwWJnpf4zlProPmOJE397VfYONzycTkb086voAoSgc5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=W829eATP; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="W829eATP"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B12JKi311148;
	Fri, 11 Sep 2026 02:19:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=S0CHDiBfIIn8Lz/9u
	l9S7S1oBS76OTnFD8iyF+QdJDU=; b=W829eATP3xR4KffzF+ZuvgaPnPBZc9Qrz
	R0bJDCA9hKdJWkf5o7GTIA/UFUcUcEFheToXp3C8mwxb6jhsudLo16VNJuDE0SKN
	/doLOk4P+bL96P/Ocmnb/lP3ARu0HlwcqBQUs5JSi6+/FZE9l/HiZKx/rme4i4Ot
	8nxxAinERyZ4qOAOsoWeZNnuN0EX8vtUPqaAX7869DnBulQ+cntWNe7bCsh8ip+Z
	LKtl1CMhT1mXvp0X/aegdANQTKVn07tQex3uQ3GAzuXM4O0kSZtJRPk91fMpgEO5
	oQoTTJMXivWZ0zYCOp1X9JbRtTuEwE9MHIpMy75r/vGXokOW7buMA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8prtbt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:19:22 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B15LLD872408;
	Fri, 11 Sep 2026 02:19:21 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvwk3u3b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:19:21 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B2JK9c60948922
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 02:19:20 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5523858065;
	Fri, 11 Sep 2026 02:19:20 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 51A7158059;
	Fri, 11 Sep 2026 02:19:19 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.103.123])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 02:19:19 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v9 7/9] scsi: ibmvfc: fix IRQ leak and guard deregister on channel reg failure
Date: Thu, 10 Sep 2026 19:19:07 -0700
Message-ID: <20260911021910.1038128-8-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911021910.1038128-1-tyreld@linux.ibm.com>
References: <20260911021910.1038128-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=eM2GH3p1 c=1 sm=1 tr=0 ts=6aa3652a cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=acainBHvso6FeXtkDgYA:9
X-Proofpoint-ORIG-GUID: EbBCu-IQjTh674Hirg-pcEkU3xbQTUOa
X-Proofpoint-GUID: EbBCu-IQjTh674Hirg-pcEkU3xbQTUOa
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfX3KIkdqhrwPMF
 ONptEwc0zWFvVUK3Sjc2Ib4UOESSQAxS0ktuTPPJYk8kyRdqwVc1XOrEN9xPzkzucsMts6vUYU1
 fCzWRR6Hi6SALhYQsXBpef+vNG8oru4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfX1NnCzC8uH1fs
 RegbpEVXKEy3x1opRJrFT45T2xukgTVtGbLn99Q5AlkyuhL7vUKvIoQtBeWHydoGtmA6euV7oI3
 W0mgjurc2Iohtz+/ih915jbG8dtBGQ0HgIkYP2QdCGq1T7PYWjY7+7oLQaV8SyRuT2+y52kjyaQ
 88r9tQ19hN7NqLaEbcmmDQ+nRpP9q9MRmx/iUxVoJwCSh2kSBg2/A4XBpgZciZh9z7gjopu3Bnx
 tTjL2oBXm+6B6snUunyqkjBuKE5NWa5dBFs4sjlN/V60Q9IKLZDbaQM3nPN85D92GXyAkEelnoZ
 wnkLmqdi8aYS1RoHpDnNHWARe9RRY3DAdCUgUtXh1DgUxb7kdYNM9M9Vw1TNzDXYJi640wxwC9u
 q18lQ1HCxL1kbui1rKM+C2B5dWLRdBPfjDYdSRoHQKtsvgU5r2VHSdvTYaGmhuHcF/OOGrS2Wo3
 7TmeoR3bS7W2CDdb6WQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_01,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 malwarescore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110024

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
index fa312a58471f..8eeb125ee13b 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6891,6 +6891,7 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 		else
 			dev_err(dev, "Couldn't register async sub-crq irq\n");
 		irq_dispose_mapping(scrq->irq);
+		scrq->irq = 0;
 		goto irq_failed;
 	}
 
@@ -6933,9 +6934,11 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
 
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

