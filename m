Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461683D093A;
	Sat, 19 Sep 2026 01:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781609; cv=none; b=GzrOCrU6Jih7kfgCHPx4QLZpzT7T4D9b/gR8DDK5qTxrJ4nW1mc2/5CEaLCqL7QqwfATEs0rm0Me5eKKkifXfNDBoWXKNQZTnOrsYEiLpj/0x0Kp5JVeDBJFaBz+TOTtiQfujxqanOeqLkbRgZCKtlteKDa3pMKlxChLYrM4NPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781609; c=relaxed/simple;
	bh=1v+B61qectOfATj4wDOKlDSAoMNZ8igm2c94UBM6p6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPunJ/iXjbpXHjagMJiT29y2aVZHErq/tfV3/AcOHHwur5TlhIyyQpwuag+fBu5NQvA7hR3uUZx+wgDMnOKRU7JyVtxg746+EDNLlpHLAfwEzlLAAu3HarTt7uZ5h6j4/SHr4fcWMZ2HDQi8/roQEo0cxZ2RagiPyKyYYTfDYJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kICrviCF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kICrviCF"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J0Nv9c2565988;
	Sat, 19 Sep 2026 01:33:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9brRyILqr21NfsPun
	JSLVDDhoEO0fDeyEFwXk4ednRM=; b=kICrviCFuVEtvrmGgIe+KXePRit7e1aHE
	Ur2nvazJPjgfwj/2PgMmQHncPPl53m1DFVIQx7J9e7UxxX/0idSa2cL5DXoXt3nc
	Dpr/5XJB/ZxvX1NvGkAjMcnhwRUGyB1pfPgZ0/YUbhf2R6G94EM00+l51qRJevEA
	lVFyO4zuhOX3BPUHeb4Boh8Ytq9EIsROsap3bAsFj+ZR4IrZ91yzYEN1tVJd2O2/
	uiakSGXzQVQDBcqTW2z0L/EqIXsuemhcZM6sXljcarFWrZU+eU9sHjlxOc+Y9yAf
	GBrulwhee5NG8DFJ9XFaq6li/hA8Whh4KEZFmQKcBjYPGw+8zwczg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gsftk04hg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:20 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1PmMf1662748;
	Sat, 19 Sep 2026 01:33:19 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gsgqn00fm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:19 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68J1WYhF29098668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 01:32:35 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B234558051;
	Sat, 19 Sep 2026 01:33:17 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 109F45805A;
	Sat, 19 Sep 2026 01:33:17 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.101.145])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 19 Sep 2026 01:33:16 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 09/20] scsi: ibmvfc: fix infinite reset loop on NULL evt in implicit logout path
Date: Fri, 18 Sep 2026 18:32:55 -0700
Message-ID: <20260919013306.2948028-10-tyreld@linux.ibm.com>
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
X-Proofpoint-GUID: 50B31vID0Y6sRvubIVPBaOC66sS7Br0W
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX4fvr7XGU8fAV
 KJ6kt9KZ5NVTCst8gqsoSRArThQQCvuVekaipn30eSwcFPYCAp7WYlDHK6BBGjHX54HS73fZYsD
 z/0DTYzamYC6HlvuDzDXjj0Ma9d9jP8=
X-Authority-Analysis: v=2.4 cv=EMaTQFZC c=1 sm=1 tr=0 ts=6aade660 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=b_dQgyAL5RWhf91NP5kA:9
X-Proofpoint-ORIG-GUID: 50B31vID0Y6sRvubIVPBaOC66sS7Br0W
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX6FH9HO0uq2f4
 KHHIOkI9h755jPkiRkoeBCiYf8ZpdAc2Lu1pKG/tWnnrcCLYkwUjs+YtrkVPopUXEJUoXkfvQgc
 blN6PCOqpI6OO5edU3NSRUipM1hKPtbWAUGUjCfiRxI4+5doEcEQr/6ELJrRd/PGAXpPyrLWcZj
 lX5qS13v/IZmHab2jm0rCmZFX5qGl4JVjQi47UYn0wTvw0w88AxoMm6NO7QQcGlXKPFZUfr4Vcs
 MVp6oYRPBBn+SKsCL7yOZIVQw+rLbLB6OtQ89BDC/RRdmrmJi0JFl2AJ0m65j2XzYzkZ9YWSRci
 aVvewPmWlui5b3dhwhKQqwbCTtcn0OxSgH/vziVzeV0m7jGzf/T6rf+LrGaXf9j123et6ZCrTvr
 bc5sM9E8+jQ0ftSUxdLM6ocAXtCDz3JOvbPzNp8RTbM0/o7EXYjNiY2ytAF87k9TCsZ9LYk8XVr
 4iATlEQZnKBd/DoN5kg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609190018

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

Fixes: 0122eab60b15 ("ibmvfc: check for NULL evt in implicit LOGO and target delete path")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 5ba8058991ef..70771f6420d9 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -4545,7 +4545,7 @@ static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *tgt)
 
 	if (!evt) {
 		vhost->discovery_threads--;
-		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
 		kref_put(&tgt->kref, ibmvfc_release_tgt);
 		__ibmvfc_reset_host(vhost);
 		return;
-- 
2.55.0

