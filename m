Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA2A3C5837;
	Fri, 25 Sep 2026 04:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790311714; cv=none; b=sGMDtwEVDE44rv7zzvg9j8YKrNxF6A9FO7hJ1xaPaW2nswPXetW9fEj6vg4S+0GKDtFRDDGUeRLhGR3AyabwyUsqyB/O4FVSifvuv8OyHyMNacrsx/Yr8//5lMsC0vziSCF9wK/0zQdYE0MX/k2oijgFemW4vxw2DI0G2KNgQUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790311714; c=relaxed/simple;
	bh=VPhYZdCBB4vGTu5HP5U8xHbbo03j2Yw11Gza8lYJink=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nda3HO2tyqk68FLGiaSGcf4V9Hqt1HZgzNWWNGf7GNyiwwzmrAyccLRFoxeApTHwIaBChAwuhDqhhA8crRX2arFmtEr1y6Prk8CJPA9QlOjFaa8tifzRnrGJXOVjhBf9fqoTW2Xy1qYsnQZvP2oU8dNrRy6ObGOIlbDvUQQlsRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PYX4IPIo; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PYX4IPIo"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4b8QJ076615;
	Fri, 25 Sep 2026 04:48:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=VGliTUt2VZf0S+j9D
	1+NV5t5iw5NLYoH1kkUDfqGUPM=; b=PYX4IPIoWdgtiQr0R+bHp+6GNSFqaXEl9
	CRgncpXqS8hzkzrCKBCZfF5H9upzpriUM05hsAm3fIjQS8V0+Ksmgc8/aqCWgbza
	SNehaf0O37jGQg4win0ELcyW/74isM4PHFx371TAEgTaWWzIrrDxd7jh1SZ62WaF
	jf2HUobz6DYPdgSSN6k3BYgqOEOYS1aYc26UlS77xGJGVsXRt0difr0Vml1P8paw
	Qs7YfWN3y1cDPaEGw+cd9Pcm5XVtoeusP4jAkfSBeVPgB7uO9l3v+EPvSLx2JMjd
	xE50Lga4s6aTBlSpNaszbH9yBr8k7bizFzH/2c/rbXJV4bhOleRvQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gskg2w990-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Sep 2026 04:48:25 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4la8Z3244947;
	Fri, 25 Sep 2026 04:48:24 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gvbu90xq2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Sep 2026 04:48:24 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68P4mNhQ36766018
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Sep 2026 04:48:23 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3D55F5805A;
	Fri, 25 Sep 2026 04:48:23 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A0C45805F;
	Fri, 25 Sep 2026 04:48:22 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.142.241])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 25 Sep 2026 04:48:22 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v11 03/11] scsi: ibmvfc: fix potential NULL pointer dereference on failed queue allocation
Date: Thu, 24 Sep 2026 21:48:52 -0700
Message-ID: <20260925044900.414340-4-tyreld@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: AGuLjM2lwAWBFp4rINdpnm81ljR8xn07
X-Authority-Analysis: v=2.4 cv=I43w19gg c=1 sm=1 tr=0 ts=6ab5fd19 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=FYxBZ7uDKvT38RkufYwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDAxOCBTYWx0ZWRfX2R7uihcWRROP
 rgubU3qBJBIWvmxMY4wbKbQgFuZvmOkwV28FoipmruAACYA6POAx2pHonUlZJPWwizoHb/W87X2
 pxh0AjnbuPSegxP1NyTXheq4Sb3BiW4Jt5GeskuM5RAbGbTF5vDD44kFhFBFscXT8Zksk4gbNLj
 WJd3ynYUlufLTpq+CJO1wRvHVjrv96x7hgyOoiDPlB5CT5vyrs0TqbldjK9NkpQNW+kNK/2EDXE
 tfbFXs9BBhrC5eS8sC3nGgWPuJuzcjiavH2Sbe/Cn9p6I/THbDt3bRjo283ZdNulEC8ihYgHYYz
 oTo1vhwPSTeA0mHbGDStzGblP0R9fqEjsf43wrlCZl8JLSD2nl2E/vvnUN+aWRfVL1qwTh4ejgf
 W5zyz5HAd9q02RPe/2pL8eSrIlTQPd5mifziRr95jh6qrgtKynQBPg09pyvo4xUzsm4iNu+SBQS
 6KYRBpi9GPKaER9RU7Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDAxOCBTYWx0ZWRfX4uNEkhv9Obf+
 Dkl+z6okshNs3uXlGnEDwXEnQNL5rlsUBZNDvZIUZehBuJoAYw6WJh2rQoxZOlz1mPGRk/1IRDi
 4iFsBH6KkkNFemfJygTXVQK4hXHkPx0=
X-Proofpoint-GUID: AGuLjM2lwAWBFp4rINdpnm81ljR8xn07
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 adultscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250018

Guard the memset() in ibmvfc_deregister_channel() behind a check of
scrq->msgs.handle to prevent a NULL dereference when the function is
called on a queue that was never allocated, such as async_sub_crq when
multi-queue is disabled or initialization failed before
ibmvfc_alloc_queue() was reached.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 17c49a0ed4f4..ef76f8c194eb 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6481,8 +6481,10 @@ static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
 		dev_err(dev, "Failed to free sub-crq[%d]: rc=%ld\n", index, rc);
 
 	/* Clean out the queue */
-	memset(scrq->msgs.crq, 0, PAGE_SIZE);
-	scrq->cur = 0;
+	if (scrq->msgs.handle) {
+		memset(scrq->msgs.crq, 0, PAGE_SIZE);
+		scrq->cur = 0;
+	}
 
 	LEAVE;
 }
-- 
2.55.0

