Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4423672AF;
	Wed, 16 Sep 2026 23:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600187; cv=none; b=n9BcCsLD9i3SrObji/sZkyREeSCg32lO9QqwOTZiITTjeteTU4yZgdpcCdmBT3SDS/Ev1qKfVT+gGGLQOrstPS4ro27cyIJf9e6/QZ2iTRP2J2nv/bYCI9zY79fBuOj4KwCDYCuutlE+AOFkR/8rxwRBnZVsScV/HakNPDSHVO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600187; c=relaxed/simple;
	bh=tUtaWbur0QmkgQCjkqSrBsGo2lGsoBBIIO81ja21X2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKLfJJbTYrOzgu0v5XrTKBdRHO4wA5lSoog4mcM2s7KQljUXmN0BSKXrWYeY5yg9e0m6J00xuCxPrXmQzPoMrQJKVZMxEWEueBNh2S97NMma0R8fiNb1JkjagSzPn8aAnLI5Wa39SMJIK+rUfPkFxP/f6Q6/RNZAOevKR/VKHME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SNm9OgwZ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SNm9OgwZ"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GG1oY32330700;
	Wed, 16 Sep 2026 23:09:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=0/D2WZgW8ZUpM0jYn
	MsgllEp9stvQoyFzifPfHfFtSc=; b=SNm9OgwZvNYHDkSOxyH6UPAQqnkLVvznt
	pNIBnEgdi8AJbwmr3CxlsddpYfN/NhzqOL5ty51BQfxcdiYdyGDciGl7+1OwU/Pz
	HEI7GBlmsVTPFWegAAvn4Aa5+lUhMSeJdaPZmMjXchi0gIuhjDigx5VIx1MhGSC5
	TpqcCtm6s//yYvVglDeGgzLXcwTnNFqQRxCcuzvntWXNFdMkf/bKPY3yDqbwGkk6
	RZ8xX1ypVZiAUA9xe2+Qb/B2e2dWAJcXY1Ixptk64x+tGHeggOFUwqUpT/o/tb9A
	AOBrdEoiJqYS9q7mw+bm5yKMgpgM8+OJP8Dpr682DSh/EajNZHcmg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxdqfd9y-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:37 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GMjrVZ2599760;
	Wed, 16 Sep 2026 23:09:36 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gpw6d9e91-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:36 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GN9ZqQ15598176
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 23:09:35 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1578E58054;
	Wed, 16 Sep 2026 23:09:35 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 270905804E;
	Wed, 16 Sep 2026 23:09:34 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.141.190])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 23:09:34 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 07/20] scsi: ibmvfc: fix uninitialized status logged on LS abort send failure
Date: Wed, 16 Sep 2026 16:09:08 -0700
Message-ID: <20260916230921.2204729-8-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX2CJFOvuSmWRU
 JvdaiadTiu7/scAI1IKRm2Gg1/oOBuFwkaa1gqnRj1PsaZMx54ZqEKJM/dpVAhGUx3loyXYfvzI
 fjnDaiBt4plvVxQmx/eEUnpgO6kwP20xK06OtQsnhOF5SM0uInG08AlwGM4D9ee+80pKdjteO4z
 BQ19rjHbiupHmompuck353FKqcq5ypx5VPWydrkcgci0OLX92F43SdGBx/iP4Rvvge+QwtCXXYm
 lw4riNsFsOLWgi73pFAGtDVwKT5r7fRbFoAbAOdWJm9Peifwn5L9EU5dWu/9IPn7f61wSMWQT7J
 NB5BaYiD67AByFlg6ukS0jd9+7NYW3Q2dnvyZ0VnzAo2jCJS1lQFw7pjkh3Kki7kBttnTnNXfgN
 Ap2c0Y8z248Sj29cZRBLgzXumJ4A7Z2oef6e73anAp0BfekKLr8OOjRnJeqI16POH3uWe+Vqpup
 kfzTwK23WovTrVEXuUQ==
X-Proofpoint-GUID: pTwCKefeuy2YW38mqfFbFOE1qurfBAXm
X-Authority-Analysis: v=2.4 cv=DobDa2/+ c=1 sm=1 tr=0 ts=6aab21b1 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=dm6BVu0w9rUwWJiP_yAA:9
X-Proofpoint-ORIG-GUID: pTwCKefeuy2YW38mqfFbFOE1qurfBAXm
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX3MOQk2NpDT3s
 k6D3D/ISTcis8gnXZhZBnFI0mE1beURduh7RsJtxk/RIqHruz961u8IyZUh85mPy10CX7TMOpFq
 mFiRJcDI5QJnvs3onlpdxl706sAoePM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 spamscore=0 clxscore=1015 adultscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160322

In ibmvfc_nvme_ls_abort(), 'status' is declared without an initialiser.
It is only assigned at line 223 on the ibmvfc_send_event() success path:

    wait_for_completion(&evt->comp);
    status = be16_to_cpu(rsp.mad_common.status);

When ibmvfc_send_event() fails the code jumps via 'goto out', skipping
the assignment entirely. The ibmvfc_dbg() call that immediately follows
the out: label then reads uninitialised stack memory and logs a
meaningless status value.

Fix by initialising status to IBMVFC_MAD_CRQ_ERROR at its declaration.
This sentinel accurately reflects that the underlying CRQ send failed
and produces a meaningful log message on the error path.

Fixes: 508e0371279894 ("ibmvfc: implement nvme-fc LS abort handling callback")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
index 9ed6522c2e9e..ddd750f1cf33 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -202,7 +202,7 @@ static void ibmvfc_nvme_ls_abort(struct nvme_fc_local_port *lport,
 	struct ibmvfc_event *evt;
 	union ibmvfc_iu rsp;
 	unsigned long flags;
-	u16 status;
+	u16 status = IBMVFC_MAD_CRQ_ERROR;
 
 	evt = ibmvfc_get_event(&vhost->crq);
 	if (!vhost->logged_in || !evt)
-- 
2.55.0

