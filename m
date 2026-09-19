Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4013CC7EB;
	Sat, 19 Sep 2026 01:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781607; cv=none; b=mlDPp22a0ySwS43bSrk2NXolodqiCJj8Nus544ZqV7X9vcPfnm4YmM3GernfM0cn7OPZlsF4v+dq8/DV2lSKRQ09hnYARJt04EYLiXvpemN3YuonuxHdhAr5bs68memfJ7p36gHLosxts/4ghz/ihHW4YhIkB6P/LRTGtrB1K/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781607; c=relaxed/simple;
	bh=G/KdWH0LXWh5PyYtHCfZlqMtt5iGwmwCW3WoZKhrm4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0FZr64dhqefIBWnwBL4MPQ2MQaFKe/X20bZbu1kcQWSssPFlDwjTHHypVFN81Nu53hpJu9T+GETCLNVo2+sRqkWv9WohZTe73JagxryXhtzmVKZj/17A7W6EvDtZXeg43V1XIuU+n9z5F7tICiz4ibluKZ/CUjj2KZ7XNgYoYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=e8SbRvLK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="e8SbRvLK"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J01b542680724;
	Sat, 19 Sep 2026 01:33:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Q/epBG4Ib5i0S5+W8
	2s+9IpRYqugI0agn8sH+YnW6QM=; b=e8SbRvLKH3ER/faOqVE0pnpAokTE+Voxm
	LyifSWHNCdndcdJ68DBeWHm0oz2Rztt+BO+BQHIqNRqLFp+fDKjd8zw/3zVQGyyP
	qY+ENwPwLVDc6sJScjR7wdniMgGD9nK/3eUICsno7ibp2ZKve/vtmH2sEdfTupI3
	fBzy53RbnKPNJJW+nyJbLEFnZtmjmYSorVYijUI0/CgK9hPDvpW1Q3c0QvkwhiqM
	s5VfJGcvhWO9jvWLRd7eX9BPWicZsKZdA29bQCzhJgYS9HaGtZ+k/GTJuX/24TL+
	UIy07pnHxMvJOy2Pc0HkYtn277OD5+h+8VF5sBkLRPNKujsT0wvBg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxf5k1tx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:19 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1RaOY1658899;
	Sat, 19 Sep 2026 01:33:18 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gsgrgg0cr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:18 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68J1WYC529098666
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 01:32:34 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E5EDB58051;
	Sat, 19 Sep 2026 01:33:16 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4678E5805A;
	Sat, 19 Sep 2026 01:33:16 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.101.145])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 19 Sep 2026 01:33:16 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 08/20] scsi: ibmvfc: fix inverted suppress-ABTS capability check in NVMe TMF path
Date: Fri, 18 Sep 2026 18:32:54 -0700
Message-ID: <20260919013306.2948028-9-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919013306.2948028-1-tyreld@linux.ibm.com>
References: <20260919013306.2948028-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8W4TuUHt2lS9V9GXxJUEeWW2WnEnskuW
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX4EDCIOQCWH9c
 v7q9Cj0HxkTcqdQVgKsZXcq1JnLmo06PJlynUELC6NphNQyzaefcxfnFJVQLPCdSFt1zfM7mD4q
 Rj6TLSIZYDuNU2jcsjpa2beuhFoODgo=
X-Authority-Analysis: v=2.4 cv=cvgOAF4i c=1 sm=1 tr=0 ts=6aade65f cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=4DjNXy2qQgjy61e-tjkA:9
X-Proofpoint-ORIG-GUID: 8W4TuUHt2lS9V9GXxJUEeWW2WnEnskuW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX4LbNS8mGiEDY
 4VpNIthCeMUTk6YqCglDiAeEaBJZMSTpSts9hnI8rYqaKylfMplU7vFU6OCO4ZxkxEe1B76cHg2
 rwrbnpQvYdY3EC5sm6YAy/Gp+7CrSK5EbFWD1Ovxt85sq6G3cQTBDpkZBUTYMm9qEQhgeS5C58i
 9iDVLLZGVqv7Q/M/DBuZUg2ExVEbSrBMkTWjOtQbVGA9mZjb3lWb0da5gSl2mCM7ENJQ78jPdoU
 fi80eL7g4Z5e+yKjEi0vtr7vpNE7aa5secPs+QzrhaCbN5LRsjjtU1vdlNCAthV559VXCH8Ywqi
 CWTAVx6WGE2nUSyAiyTkVKqIJBv8/RSt/81jFc5IwX+z+133sVtmLbGyHZOB8JflwIM5GLsrPXR
 dVuxbAjz4G/NbVmO3+HHp2zpktIFGFonLaGw45+pDz+3lrS0btXzRvSlgYltXidB23FrrHV1aVm
 cSTtbcrwHl9b7sSJE2A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609190018

ibmvfc_nvme_setup_fcp_abort() sets the IBMVFC_TMF_SUPPRESS_ABTS flag
only when the adapter does NOT have the IBMVFC_CAN_SUPPRESS_ABTS
capability, which is the exact opposite of the intended behaviour.

Remove the erroneous '!' negation so the flag is set when the adapter
actually reports the capability, consistent with how the SCSI TMF path
in ibmvfc_cancel_all() handles the same check.

Fixes: 20bec08f0208 ("ibmvfc: implement nvme-fc LS abort handling callback")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
index 0391fdb4642d..58e3e50d0c5c 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -184,7 +184,7 @@ static void ibmvfc_init_ls_abort(struct ibmvfc_event *evt, struct nvmefc_ls_req
 	tmf->common.opcode = cpu_to_be32(IBMVFC_NVMF_TMF_MAD);
 	tmf->common.length = cpu_to_be16(sizeof(*tmf));
 	if (vhost->state != IBMVFC_ACTIVE)
-		if (!ibmvfc_check_caps(vhost, IBMVFC_CAN_SUPPRESS_ABTS))
+		if (ibmvfc_check_caps(vhost, IBMVFC_CAN_SUPPRESS_ABTS))
 			tmf->flags = cpu_to_be32(IBMVFC_TMF_SUPPRESS_ABTS);
 	tmf->cancel_key = cpu_to_be32((u64)abt_evt);
 	tmf->my_cancel_key = cpu_to_be32((u64)evt);
-- 
2.55.0

