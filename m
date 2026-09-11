Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B8E24DFF9;
	Fri, 11 Sep 2026 02:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789092517; cv=none; b=unc36M18EkD9sGKac9/WFJXM+FTfZ/6VCDJ6v9qRr2vzCZuciYjCDRXTikFGH2Of+tb6fMC5oWi+qSl8/k/x4YIKANM9Y7q6kG/xtPsGGbYqnXVPz9cRlN0Sdgs/VnaeZFZGDaulgmqDB4TvwNCl5CbgLWs7sFaeo0lkvDixh4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789092517; c=relaxed/simple;
	bh=AYtr4P1+OoFMuKpi0e4Fpa//4fIG28Wi9w5zooY5Kqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SED9nSmgzBiLNJW4VlAgaoN+m95gs+fWajGMW222+c3oBvF8tCKFC6aDuMOpiIPK68yuKTeRCUp/bMOZmmMhzggfCbO4zSMG9Aw910iam2zsAWpbL95a7dtWIWoEtSnZ2hFPn1jIoaOjAxx7+MLs8lk01MMIawyw3oF1bFQb/yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EQLzXjJr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EQLzXjJr"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B12Qik311303;
	Fri, 11 Sep 2026 02:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=S0CHDiBfIIn8Lz/9u
	l9S7S1oBS76OTnFD8iyF+QdJDU=; b=EQLzXjJraAQeeih3L+xaOoHjlfpKuRsBu
	XMeyImxEQjvwWSdXhxflG4sz+5jx5sveD2LhL7/VO5iW79LA8hWoOJ/9Pwk0glMy
	w7dYcQw8s0ZvfU2CVEXkbMUoqZ+SssmTqmQmlSV6dWb/2ooPqAx0YSHX0TsqmHa3
	J80Bjek8Dv5PAxCbIJA0z9OIFB6S0Iqayy8BSaLPf5o3BGQXE+I7/qQfMy4HVOZ3
	Fp0orLmZmjRITEQj0WcapbLoZmyKiMqlsU3usadVtxuYMt4yvrAxnsOZYwSJnrJR
	Solqqup19ZlxE48EsEznOuL9MHcP+WpK8spbUCdrLg9RZIF3Me+gg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8prsbm-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:08:25 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B152SD855015;
	Fri, 11 Sep 2026 02:08:24 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvvrbsh0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:08:24 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B28NZl11665994
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 02:08:23 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1307E58052;
	Fri, 11 Sep 2026 02:08:23 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A40958064;
	Fri, 11 Sep 2026 02:08:22 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.103.123])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 02:08:22 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v9 7/9] scsi: ibmvfc: fix IRQ leak and guard deregister on channel reg failure
Date: Thu, 10 Sep 2026 19:08:13 -0700
Message-ID: <20260911020817.1033789-7-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=eM2GH3p1 c=1 sm=1 tr=0 ts=6aa36299 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=acainBHvso6FeXtkDgYA:9
X-Proofpoint-ORIG-GUID: 87nYsn-AaV4speGzRed953VrIEXilVqW
X-Proofpoint-GUID: 87nYsn-AaV4speGzRed953VrIEXilVqW
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfX22NoQWZGJv/6
 EF6OqO4WkGWznpp+uHz5JcWk7q/mSaQHssydw/W54blCT5SiRXLO6fSjTzw+D1WeY430FGW8pOl
 XnML+t8z0gprhdUWX/z41dIYDZhlje4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfX54tKHZTqp8qC
 DCcus6HgtKjU432O1wAYoWAdpw2kXyltfuWo2vyBgrkFgtC2NUO1AvD4uVeOpNZPXo5Re02btS0
 1+k/EfU5OqUca3s1sskb11gXjjg7u8s0pExYrCorrw/c+VEDFYxEaViw59w9AWP2Y2w146t/6Ga
 AbSZePn5KLU+8+AwgpWH03wXZ0WzbD3oEHhPT3+4Qym9Jc+Y8Q8Cqk6Yl+NU18XdNay8QE1v6fo
 n33Z+3UkavMYkDTO1SmWPHwJoAJMMmI47XwtPUoBnWxD/kiIdFAzsM3ordHlzimmubACwQJEmJL
 6/pxynzMKreBrJzq36FSuHSEcr06MBp0uDJU4WfunRyuYOQfVroOg5W0QPSLJFEux7hMjd1bUyi
 vDJvVkYTMdiNsA2TzYiyhOieUiRi9qtfHzfqLsE5tkNi0+zr7Wo/AJvnZwsvGs1ojh+vJckw+6W
 T8sRejzPIdEbPBRc3Ew==
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

