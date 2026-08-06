Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1663806DA;
	Thu,  6 Aug 2026 13:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786024089; cv=none; b=Im6U/mtmmI5xBjaUBFudU6FkrErrkn5xRJKJLIWcs9zkCrV1l/PAGf8ODrk4qzkHKZ93jwXfwqo9bGTrjBfQ+v5c0/W1OAa6MDaL8W2STH1LWS9Gxmhh/GYLQ+WqvcGQfHz0UFlQjKMQ2qpjoe2kO6V3SWlAWs/Q3rK/ZIyMucg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786024089; c=relaxed/simple;
	bh=RI/mQMlZ6Pt7jyC8PY+9x+Dcb0wxLvZRi+2Z5QVMB40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xfseoi5qn1qhy1lLAg3yQtyVeto3ZQwXNN51h8Seewlhz87CbwpASDlnwO8LFsxQ01F023kFBw9ppbIOQfjBPQWrWVWmwRN8rHS31seguk0CUg91s/QxzAgtvto4EyMYi+4fvfudmrs4bJPNeZx71BjmpwOuIc4/ZGA1qX9Dlvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=S9VQWLaw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="S9VQWLaw"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675NoB73997850;
	Thu, 6 Aug 2026 13:48:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=666xZ6UAy+T1hDl2E
	tJMLiI9Za3rNhhS58S4Wez6vUo=; b=S9VQWLaw85h15zFP4x5aUP+7/3c6KC5pc
	bSVdtBcqZtR2Tr91y6qXnCLBwgbC5mgO2n31Yydgtyyw5FqrVmxv+x4P+yKZkw0r
	WlAG4VXxuY8g3uHMVopG+ITZR4DityP0VBUnPtYd2OqihhNFLx1F2Wi8llw/FW5u
	UzkUM7J4T4389FPGnIlberUnaBnFdH++comKFwzvjHGcOLCn+5I0TZtXTMxKZhIZ
	sATQhKZT533+aJ65N/zoM5QkQeTVye2yTZzjA4+CP7b3KtEsOuXN8KaLkeTq6x9M
	NDBiKiksDTS2XiJJdj6JD4kY5eYMJ1/GRF+N6EfCPgx46D+mCiASQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs67j05w6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 13:48:03 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 676DfHp6022250;
	Thu, 6 Aug 2026 13:48:02 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fswbgk64m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 13:48:02 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 676Dm0fp47579436
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Aug 2026 13:48:00 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 596C22004E;
	Thu,  6 Aug 2026 13:48:00 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B1812005A;
	Thu,  6 Aug 2026 13:48:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Aug 2026 13:48:00 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nihar Panda <niharp@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 1/2] scsi: zfcp: Add __must_hold() attribute to zfcp_qdio_sbal_get()
Date: Thu,  6 Aug 2026 15:47:58 +0200
Message-ID: <20260806134759.2122369-2-hca@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260806134759.2122369-1-hca@linux.ibm.com>
References: <20260806134759.2122369-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDEwOCBTYWx0ZWRfX1P0prZIeAJ9E
 dC87J4LmrXxD6Dnb2Mb1G+zkv5uqx0lhvKJ2FSVkxgJCzxSGJZrrXiQDrgGJwTNFFclqZRU7Fly
 nu0a8vDlWUg/SGT8QWO8QL32xmYNZlw=
X-Authority-Analysis: v=2.4 cv=I7VVgtgg c=1 sm=1 tr=0 ts=6a749093 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=8a-6C-2fXwRV3OIRGBQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDEwOCBTYWx0ZWRfXzPf6ky05Y7c9
 vsvfyKhAosiIDtXu75ozFH81BpLb4DBkm4J1vZ90AQ3NmRRA/q5x09TjplMJML9XGNs5d8wRoVz
 bD1P6/zMS9T98kcYp/n9J7m1SVgF71XI8UfafB19DpZxWZ13CKt7g0hmdeB4gdNcveyMDGXKXHo
 LlgLCcd5q1hrmyguy84x1ah1W9AeD8xOBjcrWjYtilJUctxMG2weKMCUahpReVC15Pm8oqrAMLO
 AxIZjfc+JMImdW2O0N00W2QaZvepY29x8BSeipme0mb7WeAIPOW35cDsANkMAZCp2ZDxUOFYnnA
 zcgqdqkgZo3lRtvMli/CCjQyOS8WUkJoRG26/ae/WeM947ZhgQA2R81uJ+gDVfTuyDTm+lwm5xx
 MVfdk7/XWoCQ6XdQeeWQXnf+7UJaWMQkFQCR2ooOjlmBWsaBJD3tLLEkgH65eC2L3oRt9c9IMY/
 7Bid+o51Lo2xBQaG5jQ==
X-Proofpoint-ORIG-GUID: GnDXFbEMvcKWo2VqNb6IKdoc0lvdcYth
X-Proofpoint-GUID: GnDXFbEMvcKWo2VqNb6IKdoc0lvdcYth
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 clxscore=1011 priorityscore=1501 suspectscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060108

Add __must_hold() attribute to zfcp_qdio_sbal_get() in order to let
clang's context analysis know that qdio->req_q_wq must be held on
function entry. This is also documented above the function. Without this
annotation this leads to a valid warning when context analysis is
enabled:

drivers/s390/scsi/zfcp_qdio.c:287:8: warning:
  expecting spinlock '->req_q_lock' to be held at start of each loop [-Wthread-safety-analysis]
  287 |         ret = wait_event_interruptible_lock_irq_timeout(qdio->req_q_wq,
      |               ^

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_ext.h  | 3 ++-
 drivers/s390/scsi/zfcp_qdio.c | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 40bd597fb4cd..0eb9bc9d03e4 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -154,7 +154,8 @@ extern ssize_t zfcp_fsf_scnprint_fc_security(char *buf, size_t size,
 /* zfcp_qdio.c */
 extern int zfcp_qdio_setup(struct zfcp_adapter *);
 extern void zfcp_qdio_destroy(struct zfcp_qdio *);
-extern int zfcp_qdio_sbal_get(struct zfcp_qdio *);
+extern int zfcp_qdio_sbal_get(struct zfcp_qdio *qdio)
+	__must_hold(qdio->req_q_lock);
 extern int zfcp_qdio_send(struct zfcp_qdio *, struct zfcp_qdio_req *);
 extern int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *, struct zfcp_qdio_req *,
 				   struct scatterlist *);
diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index ce1af72d9b61..bac8385e069f 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -281,6 +281,7 @@ static int zfcp_qdio_sbal_check(struct zfcp_qdio *qdio)
  * Returns: 0 on success, -EIO if there is no free sbal after waiting.
  */
 int zfcp_qdio_sbal_get(struct zfcp_qdio *qdio)
+	__must_hold(qdio->req_q_lock)
 {
 	long ret;
 
-- 
2.53.0

