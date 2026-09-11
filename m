Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E57D3E0220;
	Fri, 11 Sep 2026 02:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789093168; cv=none; b=s2t4VkJfqhARdY6e9XoEcVPp7cVHNOJl/Oo286AhvNae3j6kUi9HKqRtYcHXcTIn9Kj1gI3Xt90Yop6HlH9AgS4eVRgWyuDfJyNXdsi/EKyI9jgZKfnU6RoPfmenXeshiyjU3XP9uSDdLlUIwuSEQlmLK01mO12bStj0OlehvsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789093168; c=relaxed/simple;
	bh=hSyVSW0UdAzjZ8y21iz9muNELtSLn6sQ5L6QbUFHhBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjjvOZHY0uCWI42tf/M0MfKj7KczhFFyGBs+x6hT+BlbWmY270mDHe1k90FHDoWnH+SbrlzACsbImNts3UajW5A1UO7QNMP6hY9zUeDAktd5XL1WBWszLvoF7fLviFF2hPk3gj8iknrc2t8RELMZWARQ44KbrPm9hFk4H6rntcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X6MCXkHv; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X6MCXkHv"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B12miQ3367405;
	Fri, 11 Sep 2026 02:19:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=xRkX0vdTetUU0VI+3
	Ap8L3XsiP6kBCiw73CgJoFuutw=; b=X6MCXkHv5Lx4F1x0LtMWeRbp5ElfvG+Il
	v/nVNaMYaeAZHXojCNcFOApFXaqhDTIW7kD7qX3aexWec171xfzjo9kIjtqrEbF0
	Vtx1bmqczmrYUotJ2Vw73XcaV50mWBqsd0YmBkKtVUQwS6Ldyt9JuyVRtSFSPBug
	tsSry6MaJbAEy2NZPRU+f83eJRHR8u0AJe5mo+PhmjrIzBJ8ApUpCXKUnKBZam00
	VEgj8DKqihnL9gQ9UYPT+D8c2h3jb5b2fsqDGffhxU+N/zDzyAcYdB02VeEGzTik
	gQy7uq2s94uEg6lHTcz0SRCz72zhYM9UtHOQbyk9jbaaInGf1OV6g==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8q8qv6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:19:19 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B151IW891383;
	Fri, 11 Sep 2026 02:19:19 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gkvq2uvpk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:19:19 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B2JIGn13107934
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 02:19:18 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 13C6E58055;
	Fri, 11 Sep 2026 02:19:18 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B7BB58059;
	Fri, 11 Sep 2026 02:19:17 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.103.123])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 02:19:17 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v9 5/9] scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ
Date: Thu, 10 Sep 2026 19:19:05 -0700
Message-ID: <20260911021910.1038128-6-tyreld@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: BwRh0cR1evkluw0KBcNzPAaHzQTj1GMY
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfXxbQthTiMhi52
 YlAm6HpnhUEuKjesxF6lI6e4noOrZfpQF1P8l4tEZySTiL9Pui27iAS3+k9qtSJHeinuAmcc5gt
 DGjLv9Bu0sDZxAtz1zELLsfWawVrL1o=
X-Authority-Analysis: v=2.4 cv=E/dYNqdl c=1 sm=1 tr=0 ts=6aa36527 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=w-kvVH-zZ2E7PihfXZYA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfX0afsxfLOxAQC
 MOKjZU4LQKdR1E9klTFWttSxah36iwF5IDMNT2cSVKlaR1shw69/fagwtmpTVKdvu+xQguWC9nz
 +sCtxbHYG1I6xX5S7JNUlu+dF2I3zC/+vxNXfEl9LdjD6WqVNdmOkvcn0hvFlpXz0WEFTn2Dw9e
 3hYnxh+9yiFVtcwmaL/QTnP/KeYXmYePxWw6JqSNVz9SlJCnM/ebG+J7qnP5EWLmGbjD/+auIu2
 mB6cspZ64zBZNDPxX/9Cr8YPcU4sN9IfsIywROtB6rCnfMPZhAy1gpg20rXP56VSJ4WY1IJNBLG
 9HOvLd85KQgTQ2mkh2kmKiKC4Nkk0dqjAkiQ5rkNpfZfz7BSCOAaWyE+U46jSjb6jTp2oBFx1An
 CFvcTf3SRxSar1CcisAa8yX07/mwAdpS96i1icJm7sYXi8/KTv3yzfvG56VtC6zpCzLbSWnxLlJ
 dGeCUwF5FPjmUPc7bWw==
X-Proofpoint-GUID: BwRh0cR1evkluw0KBcNzPAaHzQTj1GMY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_01,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110024

From: Dave Marquardt <davemarq@linux.ibm.com>

Add ibmvfc_interrupt_async_subq(), an IRQ handler dedicated to
asynchronous sub-CRQ events from the adapter. The handler disables
the sub-CRQ IRQ and then calls ibmvfc_drain_async_subq() to consume
all pending entries before re-enabling interrupts. The handler is
marked as __maybe_unused until a later patch when it is used.

ibmvfc_drain_async_subq() holds the per-queue q_lock while
processing. It loops over available CRQ entries via ibmvfc_next_scrq(),
wrapping each in a typed struct ibmvfc_async_crq_event and dispatching
it to ibmvfc_handle_async(), then clears the valid bit and issues a
write barrier. After draining, it re-enables the sub-CRQ IRQ and performs
one final check for a newly arrived entry to close the IRQ-enable race;
if one is found it is processed before exiting the loop.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 54 +++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index daec81f48857..553fca31cb3a 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -4376,6 +4376,60 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct ibmvfc_queue *scrq)
 	return crq;
 }
 
+static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
+{
+	struct ibmvfc_host *vhost = scrq->vhost;
+	unsigned long flags;
+	struct ibmvfc_crq *crq;
+	int done = 0;
+
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock(scrq->q_lock);
+	while (!done) {
+		while ((crq = ibmvfc_next_scrq(scrq)) != NULL) {
+			struct ibmvfc_async_crq_event ae = {
+				.type = IBMVFC_ASYNC_CRQ_SUB,
+				.subq = *(struct ibmvfc_async_sub_crq *)crq,
+			};
+			ibmvfc_handle_async(&ae, scrq->vhost);
+			crq->valid = 0;
+			wmb();	/* complete write */
+		}
+
+		ibmvfc_toggle_scrq_irq(scrq, 1);
+		crq = ibmvfc_next_scrq(scrq);
+		if (crq != NULL) {
+			struct ibmvfc_async_crq_event ae = {
+				.type = IBMVFC_ASYNC_CRQ_SUB,
+				.subq = *(struct ibmvfc_async_sub_crq *)crq,
+			};
+			ibmvfc_toggle_scrq_irq(scrq, 0);
+			ibmvfc_handle_async(&ae, scrq->vhost);
+			crq->valid = 0;
+			wmb();	/* complete write */
+		} else
+			done = 1;
+	}
+	spin_unlock(scrq->q_lock);
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+}
+
+/**
+ * ibmvfc_interrupt_async_subq - Handle an async event from the adapter
+ * @irq:           interrupt request
+ * @scrq_instance: async subq
+ *
+ **/
+static irqreturn_t __maybe_unused ibmvfc_interrupt_async_subq(int irq, void *scrq_instance)
+{
+	struct ibmvfc_queue *scrq = (struct ibmvfc_queue *)scrq_instance;
+
+	ibmvfc_toggle_scrq_irq(scrq, 0);
+	ibmvfc_drain_async_subq(scrq);
+
+	return IRQ_HANDLED;
+}
+
 static void ibmvfc_drain_sub_crq(struct ibmvfc_queue *scrq)
 {
 	struct ibmvfc_crq *crq;
-- 
2.55.0

