Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C1A392803;
	Sat, 19 Sep 2026 01:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781605; cv=none; b=JyVkIytZX/vvbY7nZ7f1YUrDRFRWOkXsn0mdoP4uJpAEnOPMM17UMJo+JucKvvld6xyy8Zk/tcnSteOSquBAFkLMWWkR3MPUP27v/bXoJZuXDt+OWEDksx/Qj1lvzbJMB/NhZdn2fXmUGOy7AYxCgoM9AvVonbudPJ+U2BMAGko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781605; c=relaxed/simple;
	bh=SboujiZPx0dO95s8SWb4cg5yhHk8NZ+4vwp4FI/oTx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uHkrnHub6afvP3nvoAX8HTXEdLiDYi6XpT1MrJniHb1PtByO8pBC5Cwgmt6lqXZ5+UGx0ry3nA77KhIBtGU79W0Bqesubltxt+FVQqDJFsnA0hDycUAV4UdpjSzejQ6M0SozqEoEwrE+DoUcqvsFoSdCM1X5GgfpV7DxOOwuNbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=M3PMstWt; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="M3PMstWt"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J01YgF2662346;
	Sat, 19 Sep 2026 01:33:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=qKWjd2
	VxrQCWdkJT+HzuuJcqIBWYZesLYnGWk9djE3k=; b=M3PMstWt3fqgQePf4cmhrB
	5xcC6rZMEt5wZY3VcVmGnQXwC6FGHEy4TIvh9klWQDtHhoRjDEwuqTcBlDcsY7b3
	RmhTnA8vWlhDDs7xv5FwPkc/fv9PPnRPkCT7NL6DyNcON9xNg6nFLiVPRQMJiD7K
	HAMaKU4mWQszW6tez1gTdFQpTlXlOf4xIL/wVrJnrYC8NBP8B2gjCIwzxbo/cwLl
	NjQeO7fEGXbw1kQXoDWRYOItmQBynhBGxaL4VVTR2Oa7OZmZ+xqq2rTyJFm9NQGX
	gpuBwW++aBWLZxVfHtNQ67KC0yb2py83GENs2vy85rFDR8e8fvU1lBwpKQfTuILQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmx84b0j9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:15 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1RaOX1658899;
	Sat, 19 Sep 2026 01:33:14 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gsgrgg0cm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:14 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68J1XDnF15139558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 01:33:14 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E277858051;
	Sat, 19 Sep 2026 01:33:13 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A38F5805A;
	Sat, 19 Sep 2026 01:33:13 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.101.145])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 19 Sep 2026 01:33:13 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 04/20] scsi: ibmvfc: defer NVMe local port registration out of atomic context
Date: Fri, 18 Sep 2026 18:32:50 -0700
Message-ID: <20260919013306.2948028-5-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919013306.2948028-1-tyreld@linux.ibm.com>
References: <20260919013306.2948028-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX4ay4QnTBCntQ
 vX6+EvRZ0TSAYgUJ0rANvogJBSAEIPH9Ofh8Cqh6456WB+jHX2UampYahOYfG/URxFrjqEknAPC
 /NLwQ/uKSVQ70lQbqJ/iqyyRs6RQOoeYuRDgK9Ch7qT3D7IIGdZMk4+5KfRCVdRaU+LLTtjNfdv
 YULE/wWaYnqJNpNIOgNreAZz6fZLW9QmO6RGvt+0wfAu7tI7jo6q/xy5nie5zNOs7VOTP4+c4bf
 cGcsg6dyuG7pR8g2VlAA/4E3Cs4WpTsUjnuvmG0Ct05KvHsW7CVl6PKiY0jdpQC9J+6Jy7vK9Y3
 GnPgJpO5vOEXYk1/iA3/ouRReQXd18ZqzhZcnfuNxlsOdvIGgY1w7Rx0b6z1kAI7DlXY1+ATJnW
 06VroyVgxJmpGOIxfDQk1M5ndmXzNI/b0kTites/9qtuHvLYRoLu8NVL4wt2F2bryjplOVTzHZj
 6J0GoeT7ew4g3j+Vqbg==
X-Proofpoint-ORIG-GUID: IDmpCSFxxlZa1ZxrAbCzZds_d48jCqCT
X-Proofpoint-GUID: IDmpCSFxxlZa1ZxrAbCzZds_d48jCqCT
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfXzLdzzxJgWoya
 gOKLmJvL7tWF57bqQ5WVlgfCKjpAE9DRkKTMtejPsiRg+OA84UFTOL2uCetItMxn4RMJXpchRAA
 M5040MLdtZyNB7dfiTwKr9YGE7sqEmY=
X-Authority-Analysis: v=2.4 cv=cY9HPXDM c=1 sm=1 tr=0 ts=6aade65b cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=kpGpFJlvQmPtm4ZHpHAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609190018

ibmvfc_fabric_login_nvme_done() is invoked under vhost->host->host_lock
via the ibmvfc_locked_done() wrapper, which acquires the spinlock with
IRQs disabled before calling the MAD completion handler.

On the IBMVFC_MAD_SUCCESS path the handler called ibmvfc_nvme_register()
directly. That function calls nvme_fc_register_localport(), which
performs GFP_KERNEL memory allocations and may sleep — both illegal
inside a spinlock-held (atomic) context — resulting in a 'scheduling
while atomic' kernel panic during NVMe/FC fabric login.

Fix this by replacing the direct call with a new do_nvme_register flag
that mirrors the existing do_nvme_login pattern already used in the
driver. The flag is consumed in ibmvfc_do_work() under the
IBMVFC_HOST_ACTION_QUERY case, which runs in the kernel thread context
(ibmvfc_work) where sleeping allocations are safe. The lock is dropped
before calling ibmvfc_nvme_register() and re-acquired on return so the
rest of the QUERY case proceeds normally.

Fixes: 3831863f9f56 ("ibmvfc: register local nvme fc port after fabric login")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 12 +++++++++++-
 drivers/scsi/ibmvscsi/ibmvfc.h      |  1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 6558ed3c67c4..728529155ded 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -991,6 +991,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	vhost->using_channels = 0;
 	vhost->do_scsi_login = 0;
 	vhost->do_nvme_login = 0;
+	vhost->do_nvme_register = 0;
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
@@ -1032,6 +1033,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	vhost->using_channels = 0;
 	vhost->do_scsi_login = 0;
 	vhost->do_nvme_login = 0;
+	vhost->do_nvme_register = 0;
 
 	/* Clean out the queue */
 	memset(crq->msgs.crq, 0, PAGE_SIZE);
@@ -5243,7 +5245,7 @@ static void ibmvfc_fabric_login_nvme_done(struct ibmvfc_event *evt)
 	switch (mad_status) {
 	case IBMVFC_MAD_SUCCESS:
 		fc_host_port_id(vhost->host) = be64_to_cpu(rsp->nport_id);
-		ibmvfc_nvme_register(vhost);
+		vhost->do_nvme_register = 1;
 		ibmvfc_dbg(vhost, "NVMe fabric login succeeded\n");
 		break;
 	case IBMVFC_MAD_FAILED:
@@ -6070,6 +6072,14 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 			vhost->job_step(vhost);
 		break;
 	case IBMVFC_HOST_ACTION_QUERY:
+		if (vhost->do_nvme_register) {
+			vhost->do_nvme_register = 0;
+			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+			ibmvfc_nvme_register(vhost);
+			spin_lock_irqsave(&vhost->host->host_lock, flags);
+			if (vhost->action != IBMVFC_HOST_ACTION_QUERY)
+				break;
+		}
 		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue)
 			ibmvfc_init_tgt(tgt, ibmvfc_tgt_query_target);
 		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue)
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index ca80ceffe53a..df0775183d72 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -1005,6 +1005,7 @@ struct ibmvfc_host {
 	unsigned int nvme_enabled:1;
 	unsigned int do_scsi_login:1;
 	unsigned int do_nvme_login:1;
+	unsigned int do_nvme_register:1;
 	unsigned int aborting_passthru:1;
 	unsigned int scan_complete:1;
 	int scan_timeout;
-- 
2.55.0

