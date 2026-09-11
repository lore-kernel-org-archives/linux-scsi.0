Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB641381AE5;
	Fri, 11 Sep 2026 05:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789105731; cv=none; b=DiK9gFEvmm+MxtlK7hHZ48m8C+XjG27CQeB6opzkGJ9dPrLj+ttuDxQwa6LcUfFpnEP0NS8bche4I7TD0EJfy4kjTJ1zjmnE/GcNhM2bdaz7NxpYkomAWLBmmCwQ+PKZWRY1RrVCrS8t8Ei2bfYL5A1Ck9PXwZyF45Vx4flLSqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789105731; c=relaxed/simple;
	bh=Yy0OU3dKq8cR/JdYCoiXYE3T/GnzwysU3idedb1DPV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vso9fNR/u69kEjcPESsAZEvZHTxqTvbAT5qsOcdJBPbIRf0/2KgsIVpu+nGbgNycNvtkYXxoJgdXtDFKH9x8smA06fhMZ/Eec2plNZazZ31+s0VuodVTi7pkoC3qKTXRxcyFheIyyhVkNt90ZlSu0zSsow9u2sWFyfWWh82Wn24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QKAzd0Nr; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QKAzd0Nr"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B4W35k820706;
	Fri, 11 Sep 2026 05:48:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=bVsy6e7RIWsa4inSY
	VWZiBsIlesxYTQaoaS4XZ8tKXk=; b=QKAzd0NrzjR2mKb9QeTvLQGgJbI5vLlDJ
	o/4JlVlt59iUKRpUD+QgGa0cCzaDpRXlnzJ1MMsPqvlsVjGXtpistjau9O33C+PW
	aq8HaNzo1vNixWMb/ytw7l+tyvR4NgD+ybZAS2EHdkmH5XrozQE4xqNNZg8yUWR8
	BeI9ELfSY2kMWzNJj1+BhnRiMWQHN7mBr2rSufp2VG5ETnqjRcScP5M4X2NNARip
	RJyQ8vAD0UXg74uUfYQVEPgX//0CxT/V7lZ8PE0ImSfyAEZpmcZ0upawqxb5SYRl
	zSC4N3/D8tEDkJccwphG1hPyC9SP8SV4WV+5chv/WvLhGWYJPJRbw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8t1fh0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 05:48:40 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B4K4ML1056152;
	Fri, 11 Sep 2026 05:48:40 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvvrchr2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 05:48:40 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B5md8J32572010
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 05:48:39 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E76AB5805E;
	Fri, 11 Sep 2026 05:48:38 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 46B255805A;
	Fri, 11 Sep 2026 05:48:38 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.103.123])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 05:48:38 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v10 3/9] scsi: ibmvfc: add FPIN extended flag and async sub-CRQ queue handle
Date: Thu, 10 Sep 2026 22:48:26 -0700
Message-ID: <20260911054832.1311668-4-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911054832.1311668-1-tyreld@linux.ibm.com>
References: <20260911054832.1311668-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDA3NCBTYWx0ZWRfX44wsF1sI+bH5
 Hm+FJizKOtttYntWsCR/xOQUDL15JD/q5deuPrjxB9Zd2SzcHSlk03JbLCKvf4dR50+B5DrV0Hi
 BrNbY2cxIT8ETdUOC+KGRTGJIcdz0dU=
X-Proofpoint-ORIG-GUID: U0fMvZgXOoe18jAYnN7gOdFbxoQwi9dJ
X-Proofpoint-GUID: U0fMvZgXOoe18jAYnN7gOdFbxoQwi9dJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDA3NCBTYWx0ZWRfX3UESG9sBXvBn
 KCUVKb0jJMwiOfz/kNB2GbRvCRD4NNNUBHQhBYSLThtgkquKKe4N9u0kBUvFf3Cx8I40N1o1NCD
 xmR02gI72CX1Q7fgxbhDSnWX7CG+Wd45gTY9PvpmYD0vNOBRGhkC877gw7jpxEGs6K6kHKMTg2o
 Ric3QrJLRbQL+DBs/o/X9iq3Bz1nu/bzGM07j8aH2d9yR/DGsESNHQl/tfZZH/8WwzNKt/7ZydB
 wDdPIE+n/c7wRgXDJBlOwCyRnaHnSAWkzyw9iHlOe9j+NBw8zPRgQP3XVPfms7DFL7nxTxdj2ep
 EILt/fJZiB5ap6vxRUy+Lf6VzATk0+KXv4oaLm6pT7HHkuyuyGttBxMhWELUVO31wbjX+UYdVRH
 jmQoSoCAdfURez+h7Elb26edfiILcnPBhXX5D4KAw0HrwQu/3N0AIpQCmA0dP6fNt9jIlN0xuQs
 XvR+BW5OH/rf8ip/Pow==
X-Authority-Analysis: v=2.4 cv=PIGaavqC c=1 sm=1 tr=0 ts=6aa39638 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=dC3NDtCKD2fC6gceAXcA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_02,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 bulkscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110074

From: Dave Marquardt <davemarq@linux.ibm.com>

Add IBMVFC_ASYNC_IS_FPIN_EXT flag bit (0x02) to ibmvfc_async_sub_crq.flags
to distinguish extended FPIN events from standard ones.

Add async_sub_crq field of type ibmvfc_queue to ibmvfc_host to hold the
queue handle for the asynchronous sub-CRQ, alongside the existing crq and
async_crq queues.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index d7a30e7a4a28..a8a063d99564 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -773,6 +773,7 @@ struct ibmvfc_async_sub_crq {
 	volatile u8 valid;
 	u8 flags;
 #define IBMVFC_ASYNC_ID_IS_ASSOC_ID	0x01
+#define IBMVFC_ASYNC_IS_FPIN_EXT	0x02
 	u8 link_state;
 	u8 fpin_status;
 	__be16 event;
@@ -990,6 +991,7 @@ struct ibmvfc_host {
 	mempool_t *tgt_pool;
 	struct ibmvfc_queue crq;
 	struct ibmvfc_queue async_crq;
+	struct ibmvfc_queue async_sub_crq;
 	struct ibmvfc_channels scsi_scrqs;
 	struct ibmvfc_channels nvme_scrqs;
 	struct ibmvfc_npiv_login login_info;
-- 
2.55.0

