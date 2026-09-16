Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E8F4D7D29;
	Wed, 16 Sep 2026 23:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600189; cv=none; b=lFBj64gdYDz77xfhzPTrV4QrJGgkEszkLfk8JUAobmkExXmxqeceuwQ3GqQ5PydMpN4imTEVZzhlk67D8h155lVcGooDUvmGAR92+GXx1vyDT66p5nwQgKo5HV/RBkHZSImFAI0oQWY2e976FfIqVFm+WzjowSkQ9Evc4nspDAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600189; c=relaxed/simple;
	bh=tm/nKFgTUqADr5iWyStu3PFbisxvORDM1FA+iBvRng0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTB0HovI8e/+UU47X9w9t/t3B6y7wd4QdIzs6oEbGZM7LaDTnNgIMdICV3rw1AnxohTsvyOCbW4hNoQjzXY1wNHEgbBPBIwZPjzQWEq/E1AsnDA1lyZn+90m3C0cbA1+t0f7BktFK/lRLBE8AFcLc7VWd6rPh6Dr0iABOckfSDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GMDVNlka; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GMDVNlka"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GG1bbM4057211;
	Wed, 16 Sep 2026 23:09:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=FrLC2oNPttFPs4Vfk
	4Y4zUrmTP6nitaE45z1d6F8D/k=; b=GMDVNlkawJCL6S70MYeRJFUaDQ14zItU/
	jD9X1ik3RvyOiMslpDcxD/7cO/3Coj21Vg01HyNogNzBJH3TxB9SWwmmseMlZXVo
	qfQz8xfnddBSx5mYXH4biOoIK9HSvpuyJIcYWNQRFq6U4tWVwQ7yT4SalcfBdhhj
	mI3bKlu1oiC1Q9l6jzvHLkaiUeRF7MTs1KVHWq1g0W74M13M4ECplrKDyCqo0Wmp
	7dXKXp80RemIK094RDzbQoZrCr1bF86xyiz4uDQL+GV4ZNfQT3yTmy3c+1OfLZTO
	ye5PVvft/PIXWNP8xvLgdS8EBAeCqxmJaHsywJMDtcFDVNQyj2GEw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmv5hy9v6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:39 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GN0dv82599738;
	Wed, 16 Sep 2026 23:09:38 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gpw6d9e93-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:38 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GN9baI53477874
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 23:09:37 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4F5B758060;
	Wed, 16 Sep 2026 23:09:37 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5EB0D58054;
	Wed, 16 Sep 2026 23:09:36 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.141.190])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 23:09:36 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 09/20] scsi: ibmvfc: fix infinite reset loop on NULL evt in implicit logout path
Date: Wed, 16 Sep 2026 16:09:10 -0700
Message-ID: <20260916230921.2204729-10-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916230921.2204729-1-tyreld@linux.ibm.com>
References: <20260916230921.2204729-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX+6lJ0kJDM/Ee
 ztVYrJerrGxA8bdFmPUvO4dBhxpkHjIreBxa5gIjPV+Dem3o4Z78m5sVLGvnko7IN27JU09urOF
 4JtQjU/ZDhztFlbKd9I8F/dxX2notzxQlRO/hi3t9wChnWs2kDl64ayo/K/7Qln3D6fbBdSKTav
 qiadETwtqJDb7c2OjKaId9PkgJnEUioEfUOAh2YGoqNP08I9sf0a3KpM5BUtYUqsv22oZijNyis
 anfp70Kd2cHrWdD+adVzp4r1MNneEXV1NKVZTWosONbuFE8YldD/+cq03AziLEsUsbceACI3sJZ
 TMiUzlJo9bu/iCC9vHsAXrekQ2OhyHgMVrV+WP/YwIZlTx9ycP1lwS1Dr1t2btvDD8mOR1q1UdP
 6MgXhx0/zqYzFYItAaVnZmptI99VviYH/Rk1HO6v0JImG8Nqm6xhhYsA4vW9OjH8CF24CooOcd0
 MmhY44/MA9kpaJS7lhg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX6+qAfU7ur3Iq
 OCgycOUOtxnpKf1/vuzmK7+BYAq/yK2f2Ylz82hYo7Qk2UlvxPVPNo/cU+Bfxf+L7i0pqnxopol
 0gcN9BpZ/6sGXIHyG/egBxBqzh7uT7Y=
X-Authority-Analysis: v=2.4 cv=Zsx4uN7G c=1 sm=1 tr=0 ts=6aab21b3 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=b_dQgyAL5RWhf91NP5kA:9
X-Proofpoint-ORIG-GUID: Zu2guZDqoAWmUqu9iTalyHmIe9n6-iUQ
X-Proofpoint-GUID: Zu2guZDqoAWmUqu9iTalyHmIe9n6-iUQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160322

ibmvfc_tgt_implicit_logout_and_del() calls ibmvfc_set_tgt_action() with
IBMVFC_TGT_ACTION_NONE in the NULL evt error path. However the state
machine in ibmvfc_set_tgt_action() explicitly handles LOGOUT_RPORT and
only permits transitions to LOGOUT_RPORT_WAIT or DEL_RPORT from that
state; NONE is silently rejected and returns -EINVAL, leaving the target
stuck in LOGOUT_RPORT.

With the target permanently in LOGOUT_RPORT, ibmvfc_dev_logo_to_do()
keeps returning 1, causing the host to spin in an infinite reset loop.

Use IBMVFC_TGT_ACTION_DEL_RPORT instead, which is the same transition
taken by the !vhost->logged_in early-exit path in the same function and
is the correct valid transition to unblock target cleanup.

Fixes: c8380c3ff651 ("ibmvfc: check for NULL evt in implicit LOGO and target delete path")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 18e7a462e32d..e5eb0997d507 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -4542,7 +4542,7 @@ static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *tgt)
 
 	if (!evt) {
 		vhost->discovery_threads--;
-		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
 		kref_put(&tgt->kref, ibmvfc_release_tgt);
 		__ibmvfc_reset_host(vhost);
 		return;
-- 
2.55.0

