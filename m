Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F25C3C76A0;
	Fri, 25 Sep 2026 04:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790311713; cv=none; b=DFlyj2HM0FF4IiczTuJpuJCr/uNe06KHTnAUYox2g3G0jEiVFoCKfn6OyQn3iQBqhFZjfBZMt/behXFVr8l3U/xeq//ilWvKtx8VnF7M4ZYwvt0fg1qr3ECjx84v0rEYxuPe4zdTyD+ge6TRwS/cXDI8fKoA/0ypE3hptiaYdHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790311713; c=relaxed/simple;
	bh=V0dX9CB+nTtB3omTikvKzQWBtwYrL8TDG5ypN7LuzgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUACTAwAxI01ugXjI/zeq2nUbU3dSr+0FwF6XT1CAPXOh3oHXRuVOqm3FghDA30E8tLptAvPqgmhkhL0p6BIXVIGk0iU8bvEvs73kP5aJnUStI4RzAyC3wLXNH+SCxe/G11O0rLWYsNhf31u2hW6ZKcxTjWoDJBeX5Lx6bYC4lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jzFMXd84; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jzFMXd84"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4aZbE3084274;
	Fri, 25 Sep 2026 04:48:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=fR0+7jE6kMlV3eplY
	tArXSLtg09Ia45aSRhA6aj8evI=; b=jzFMXd84kVhSrogi0kzXSJu1rVfmYKkf7
	fuqJ5PFvJjNhRUFbtaRLHXeuJaSpv3jshYga45GyBDsEIdXJKmiIow5o9WAm8LZc
	onMTMxhnd1Y2JAaOFQ4yuCr8dYfCFGkJVnrko27BnrmkM7NmbBzTtN0Uq4bkDREN
	/5UBFUNJODCPRkr3TZSoOvCdh8p1YB8vzyjRlFoT2Tc5VEKzqcNPG1RFJ7IM1veb
	WewHUY5c/moZYVzd0LEuAm7VP7fsUxa1ylDFAIso+WODaKGlwRqU1HlNPadnftrF
	kJEWnXVb6akqcMQvbT2gxQ/I2/U8hbXlVUmPIR4l7g11oKsqnO4iA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gskgqv81u-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Sep 2026 04:48:23 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4lYHl3288207;
	Fri, 25 Sep 2026 04:48:23 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gvbe2125p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Sep 2026 04:48:23 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68P4mMBs29295284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Sep 2026 04:48:22 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3251D5805C;
	Fri, 25 Sep 2026 04:48:22 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28F7A58051;
	Fri, 25 Sep 2026 04:48:21 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.142.241])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 25 Sep 2026 04:48:21 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v11 02/11] scsi: ibmvfc: fix potential clobbering of rc after failed irq setup
Date: Thu, 24 Sep 2026 21:48:51 -0700
Message-ID: <20260925044900.414340-3-tyreld@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=G+OJgNk5 c=1 sm=1 tr=0 ts=6ab5fd17 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=MVjHE8Z1wCOhovhPjBEA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDAxOCBTYWx0ZWRfXwWVI9nSgrV3R
 ybKAy0VJX/jcdDMloxn+215SzgeBXO8KlYWcV9xxranCeZEIuaQfX3ShUstdSnGRmxHFt/jJfJ+
 5cUGO6F3Bidph7JfaViqmSwLHGdENXAsVYw9R0qldCHjAmdOTPRQBtp8TwfJwQRBxT6kEqe1qRn
 8jy3aEW12OnE8Zdrkti1S5Kys1/qB0MGWlWu+o1E78GY0FjdzJNGLhFuggGRraJ2AC0y/F05wmh
 nOOOm4PziIcr8xEjVtCg8T0rfk9Vc4Q531tJtUT3gNJou8s59vo/MuKV3KzWBlHk+OuHKLlCRKh
 Fs5Fdf+Stt+eleKo63XACnYL3xz2rvVzgsGbAQJO7u0jMbv/udyvaJG2goFB4ma6YSaT7c+t3P9
 HRhTmq+buq/+/24x/BNbQKd74WyQyxJdwmWHf+OqAJYL21onPWPvqKxmQjlWcgKbj72yD+Qn1Tg
 GQ9ZDbkk3Oih3k07ZMQ==
X-Proofpoint-ORIG-GUID: LVSMEdt15z1Tlt6eAMsZnh3JHMy4uIId
X-Proofpoint-GUID: LVSMEdt15z1Tlt6eAMsZnh3JHMy4uIId
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDAxOCBTYWx0ZWRfX0fUEWCiLILzj
 dMZBfoY1FxjuZrwZKCjvkyuUwgyHbPDaJjSOAY1CQA7rvkePz2+59uks+cRD93/6WrOgl2fubqK
 5yWQypd2mcUSp0p/BHIEEPcD7gVGYEo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 clxscore=1015 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250018

Fix a variable-shadowing bug in ibmvfc_register_channel() where the
irq_failed cleanup loop reused rc for the H_FREE_SUB_CRQ hcall result,
clobbering the error code returned to the caller.

Introduce hcall_rc for the cleanup loop instead.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index c4dc48ef1ec8..17c49a0ed4f4 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6392,6 +6392,7 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 	struct vio_dev *vdev = to_vio_dev(dev);
 	struct ibmvfc_queue *scrq = &channels->scrqs[index];
 	int rc = -ENOMEM;
+	int hcall_rc;
 
 	ENTER;
 
@@ -6447,8 +6448,8 @@ static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
 
 irq_failed:
 	do {
-		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
-	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
+		hcall_rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
+	} while (hcall_rc == H_BUSY || H_IS_LONG_BUSY(hcall_rc));
 reg_failed:
 	LEAVE;
 	return rc;
-- 
2.55.0

