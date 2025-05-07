Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818092AD20;
	Wed,  7 May 2025 04:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746592172; cv=none; b=JurcQtxY+tbprsfoRlMTGiTjEmP5uO5s2wIrNvtZdpliUlztTjVQSvMsD4CoBDVvkRaB1u36jccDBxNxzax0ErAyaFjhmOHhX+OrwCWlqrM/yT7Futw6052LRLRN/Q4ZnxoJtItUexTB8Itn4lewQ/OABO39qbQlrnCJNR3JKgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746592172; c=relaxed/simple;
	bh=t5lko5B4xTtBPNXIbAlW8Mwmu1BpmjGaHMy4taPgWx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OB1L+zER7WiENT+MD462NtFpvLTpd8Vhtoi7/+2+EqRz0z3PrggKPkrMlRc+VDiZemnEq6FUxIpLf80EuBm9+RsTIlLuzowD1220YHGjv1ZmmEtUuF/fd7KscazxEkhzhQfY+sP5Fv3Gr52/tOCMhLIEoZ1vRz5nAJysuWgMkbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UX2kbCrN; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UX2kbCrN"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 546NkXdP016852;
	Wed, 7 May 2025 04:29:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=j2uMQc6F6g5CTR2kZ
	Z5BQ0WEIPLNrboNIpsRCAYfypk=; b=UX2kbCrNB6FZ2mzNuPHqpjgh6swCYIqTs
	PZMUaQcPFD91T7ve7m01Cc7jKdwB5bPccQcGcRZNf7htqqevndknUmQnB+hK/FlS
	Xf9qKcueVyk28/hVxl/xDq0I1K4KpyPRrNM2q8VwXsWCrlH4KwYq3AjAMa9MyPUv
	4zAL2sVSJI4NvRA3uyFgJZZhsrPC2+hXoPx4DWrvIDjMv86C/QTxdbQnzGDYokOt
	fLF0qBE4ezY/6ni5V2w5PxIgJFc45rQkPiB9/Xi14WQZN12wA/wZiM1gZGZTR0AK
	4FZHJO8Iq2EEX/74vZ4e2M2DWX74jtskayl46V2U3OCn1B2T3B45g==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46fvd0gy5k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 May 2025 04:29:27 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5471e9XN014137;
	Wed, 7 May 2025 04:29:26 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46dypkpq8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 May 2025 04:29:26 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5474TKLq49152338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 May 2025 04:29:21 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD60720043;
	Wed,  7 May 2025 04:29:20 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8432F20040;
	Wed,  7 May 2025 04:29:20 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  7 May 2025 04:29:20 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH] zfcp: simplify workqueue allocation
Date: Wed,  7 May 2025 06:28:07 +0200
Message-ID: <20250507042854.3607038-3-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250507042854.3607038-1-niharp@linux.ibm.com>
References: <20250507042854.3607038-1-niharp@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dEcoTfaBGHvImq32cpHgbgd7KAA243GH
X-Proofpoint-GUID: dEcoTfaBGHvImq32cpHgbgd7KAA243GH
X-Authority-Analysis: v=2.4 cv=LYc86ifi c=1 sm=1 tr=0 ts=681ae1a7 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=rhwnJcFf0Zl9LhuSO-cA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA3MDAzNiBTYWx0ZWRfX48UobnegUkBo 9t4hFkOYbGQBWxh/qvvGqOtwcDTvnaWZ9C+QdF3E+Juh9FG63adzdJMjduUjLoM1BH+8bWK4aD8 7SpFxYPyO9T2GQ6zCP4OYObOZlSj6ND///RquKYhOfDBTWSHSqZNjwoVdurPNdNBNM+/nupBukL
 4uGKuzqm+o2xVnCQXCl8FzC5DGTlhCps6F1keJVHomVKdXeASH3qIQjvqUF7Kn8ky+XoLKt9LNX 8sK5GaHLnOFGPqIWRTho/+SxSlNqUgG9HCxTG5Ip2uh3GrJpReY8REdvZuKBD/En5GZWj1cx0rc pvUIhBr06qtM68HhHGbJN11SIh3wIl672hgt0BPesSUO643bgXUkixOTwnIThQHEGRtyMSl6w+p
 nC6/mILVQPOwHZbJN9lee2kx0QwaVNqxwDtI6jThUXLcLes7BYHT25Sx2CkHcuY7h/IrYwOf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-07_01,2025-05-06_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 priorityscore=1501 spamscore=0 clxscore=1011 phishscore=0
 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505070036

From: Benjamin Block <bblock@linux.ibm.com>

`alloc_ordered_workqueue()` accepts a format string and format arguments
as part of the call, so there is no need for the indirection of first
using `snprintf()` to print the name into an local array, and then
passing that array to the allocation call.

Also make the error-/non-error-case handling more canonical in that the
error case is tested in the `if` that follows the allocation call, and
the default return value of the function is `0`.

Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Fedor Loshakov <loshakov@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Reviewed-by: M Nikhil <nikh1092@linux.ibm.com>
Reviewed-by: Nihar Panda <niharp@linux.ibm.com>
Signed-off-by: Nihar Panda <niharp@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 22074e81bd38..dc2265ebb11b 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -312,15 +312,13 @@ static void zfcp_print_sl(struct seq_file *m, struct service_level *sl)
 
 static int zfcp_setup_adapter_work_queue(struct zfcp_adapter *adapter)
 {
-	char name[TASK_COMM_LEN];
-
-	snprintf(name, sizeof(name), "zfcp_q_%s",
-		 dev_name(&adapter->ccw_device->dev));
-	adapter->work_queue = alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
+	adapter->work_queue =
+		alloc_ordered_workqueue("zfcp_q_%s", WQ_MEM_RECLAIM,
+					dev_name(&adapter->ccw_device->dev));
+	if (!adapter->work_queue)
+		return -ENOMEM;
 
-	if (adapter->work_queue)
-		return 0;
-	return -ENOMEM;
+	return 0;
 }
 
 static void zfcp_destroy_adapter_work_queue(struct zfcp_adapter *adapter)

base-commit: e142de4aac2aae697d7e977b01e7a889e9f454df
-- 
2.45.2

