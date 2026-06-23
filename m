Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D9B385D83;
	Tue, 23 Jun 2026 01:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178257; cv=none; b=I1fnD/Lh52oEIyQk1rwSWIpPoUzik6naVytTh4IGxNKAHTgZbq9vl/Xu+/Zv5FgavZhVCNyCgL01F8lI0a2X/hMHtJUhbAeddlTTolfBFdsza13H0987ustt1jrAIjRt6hrTAHvozkdlXMZ4wp0ytpGgXv8mwXm4ZXIUi4a1fXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178257; c=relaxed/simple;
	bh=j1jwcqTwWRCAYj0MNu2YrM00ELJ9lhL/L1PXgPHML0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9uVEdZyzSYOcI/ftoNtiRFrm/YKdECNiq2Mu8g+4s39gOw8HEWk/eXnP6pC4CN8dk9Q3CHxB6f4oqrkkBgFz1UVvs2t/VqZXXmobimZDnnt0cxWz1EfZsm1DPSjiik/TJCSarJCo/neoaUOeZczxsLYsMS9/WRCx2GUJkNf9qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UEp5KnIz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UEp5KnIz"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0nCpD310034;
	Tue, 23 Jun 2026 01:30:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=TIiRZkBPkygtg4p8M
	//5jLZKT/lzGh7dEiHTKqhSbZY=; b=UEp5KnIzD1akY0blgyAX95zdybNFuA29f
	w1stqsRB+UnmKtUnjIPJPWysn4Qwg/Z+EeDfCsyJ97z8S253uQjcRku70+2xTAPP
	ewJZZuSARj8d8yKJcYpWj8f31y8ds2BNqB0mW1tUEPSwu1RRsClj0hIBQjciadVR
	trimwk8jUNHeNluH59Ii7I0MXSnk/NfPm12rC2Ro094UX1WuAugUvDkplVht9bsy
	DNVKkkaYmbxe4wZl2MVB6dVG2TDpC9OqmlhuskY/T4A8Mg2W4Bzhrgjq3YBIWz+s
	yskIg8d7/w0Mg1pG+W7UZBKKPYhKiMotpYXx5AB482UG3Y6/orTCQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewg9hmbub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:44 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1JlRb002081;
	Tue, 23 Jun 2026 01:30:44 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ex56q95m2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:44 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1UhVa17498666
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:43 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 581A158052;
	Tue, 23 Jun 2026 01:30:43 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B0B1B58056;
	Tue, 23 Jun 2026 01:30:42 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:42 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 07/29] ibmvfc: add wrapper to get vhost associated with a channel struct
Date: Mon, 22 Jun 2026 18:30:13 -0700
Message-ID: <20260623013035.3436640-8-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260623013035.3436640-1-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bN6VEpoPE2YpjLPIemjugTyU2MPlYs5T
X-Proofpoint-GUID: bN6VEpoPE2YpjLPIemjugTyU2MPlYs5T
X-Authority-Analysis: v=2.4 cv=Y4XIdBeN c=1 sm=1 tr=0 ts=6a39e1c5 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=LqRknZQVlxeFVEtwFW4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfXw75xdjKt96OH
 aJxaoRg0lr/B/4ohoboFyA9xVgwCKuL0oja8MNA0bBvMmgaPTZow+7oDiGte3aaM09eZeBmA+pg
 MLXUVBKvX/FdRCWrBWueX9OeezyGX2W8S/3+ggNXBiBJaB80b8rMWFqkLXM65DmZpxNksriPsqB
 LKSrsiYFk+yeQXzX8SKixDTRBbKrLOkKQ9KInNeBJQ5zVc9nRzsFVDZjmxxNZfXwsgeywAvNMbR
 WhmJy32WbkyOP6RFZsFotYSa1g6JEazy8GSZfGKnT/AqE7Otj8QmDUbrcqN+6kE8Chgf6/5k7Cc
 khCx/QAkWRrE8qCXsEm9VRdm9ecdGdS6D7alPiZygWvWjInqqBqEyOsTNGfP718WSRMIq8uubvm
 shr534Alvx089BBj/XrvZ5Eiu8971xDxhkIcmHfWXi+iE6P04oYPmneZqQ5azjxn6hUXyq6vn6k
 v/i7CSLbkRfQ6ZLTnxg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfXxx3i59jGkAXH
 qOg7Fl1W2gcMruwvWvFSgtkKk8KeG9lgoiJCieCfIVqzO0OHC6jy/qRCq+ZQyLeCdtYWLE2FIMX
 GLBEKuxqZCdklH+4KIuAoIMvs/M/OHg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0 spamscore=0
 clxscore=1015 suspectscore=0 impostorscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230008

Add ibmvfc_channels_to_vhost() to recover the parent struct ibmvfc_host
from a protocol-specific struct ibmvfc_channels.

Later patches need to operate on either the SCSI or NVMe channel group
and still access host-wide state such as the primary CRQ, device, and
logging context. Centralize that mapping in a helper instead of open-
coding container lookups at each call site.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 454968de925b..67f546ff092e 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -1011,6 +1011,16 @@ struct ibmvfc_host {
 	wait_queue_head_t work_wait_q;
 };
 
+static inline struct ibmvfc_host *ibmvfc_channels_to_vhost(struct ibmvfc_channels *channels)
+{
+	if (channels->protocol == IBMVFC_PROTO_SCSI)
+		return container_of(channels, struct ibmvfc_host, scsi_scrqs);
+	else if (channels->protocol == IBMVFC_PROTO_NVME)
+		return container_of(channels, struct ibmvfc_host, nvme_scrqs);
+
+	return NULL;
+}
+
 #define DBG_CMD(CMD) do { if (ibmvfc_debug) CMD; } while (0)
 
 #define tgt_dbg(t, fmt, ...)			\
-- 
2.54.0

