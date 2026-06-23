Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61772390224;
	Tue, 23 Jun 2026 01:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178271; cv=none; b=q5yIp14x0Irfj4ACAo0lG9Ml1ziW/2Tme6MPashNBJOPPsU9pZuZiYEAYOBdjjSI4S73yEQ3z7ka635+EuMm6CRL3nbwGa7kljQuUJF4RCSjfTfFAAU83D0/m+o+UJ7Ct4KCU65JFdWg54YeeYStwyykyQnyRoSPArAvO0BXxpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178271; c=relaxed/simple;
	bh=N4U0//uvM8b+FzbL+qWCn8A+DoHuvEpkvbx8qDg3G1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COnONHaaRQzlEOt6XwyIDKsKz8TM+DKtumOQ+twSi3qH8ksGmqNQQLxBmGHPb8L0A+buS1+Kyr/KzxbZFAanYJN17BThzOwwgBK75ZDbRl6oJoJWLCo39Q2wWqjVnWU4nnbqHCxZALGbVPMD+ut3i07flpyXyHJ50ivBvI0iD6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=A/+SFpqy; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="A/+SFpqy"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0mJMQ351950;
	Tue, 23 Jun 2026 01:30:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=uKKAmXUR6GTfXGWhT
	G+kUILrYiJuhpmZ2xb7lf9KKNM=; b=A/+SFpqySCFF7Lx71KIfHRvrzRkFC480i
	U834om4h9YhSgIIhy09DZzvb+PoqHbC0YYoGxoCBEJl1kHwBpKQhaXyCwrzBh8vs
	Tuku+y2ICBea/8tDJYoiezJbNw+PkX0ordIrWI1k0sg0sKEQA7ViZabAKIZI2Mn8
	+oSZbATv0fRMapZNul4WiKpPx7yj5QgrhOxeGsDuMbsB+DOm0eZ6GrE322JYsiNB
	APL18uZVS6nVCQUynI8fo3X8zu2O4FUance1ldvRYsFCb1DrS75Il9VuvWX4y0Tq
	17GEb0IhMEmEAzEG7P8nkS3OzeO7ZfCOZ90nrRvMDfkipNiRXpKuA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjk4c38g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:57 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1Jdi0026295;
	Tue, 23 Jun 2026 01:30:56 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ex7dg0qwp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:56 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1UtOW6357656
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:55 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8BBC75805E;
	Tue, 23 Jun 2026 01:30:55 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D9A4758052;
	Tue, 23 Jun 2026 01:30:54 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:54 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 24/29] ibmvfc: implement LLDD callbacks for mapping nvme-fc queues
Date: Mon, 22 Jun 2026 18:30:30 -0700
Message-ID: <20260623013035.3436640-25-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260623013035.3436640-1-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX9DUvpuLR2vcs
 gdLOkpkhIZxJBtg6KsrQDQpp6a19lm6K675M8a5co/Pd/rkmdZ2kXSAZa0wZ3m8hBrBzhT3/M4G
 lWhOCIBYVi4rBlVHtZje6guIk6S5r/A=
X-Proofpoint-ORIG-GUID: mWFueeVd2Q4RLOJPee6HJoJXnIKU3_Xm
X-Authority-Analysis: v=2.4 cv=Oph/DS/t c=1 sm=1 tr=0 ts=6a39e1d1 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=xXv5fKpT-M1mo7RiuCsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfXyowQXwUQsPGE
 ToZyhPUQ2UHcoQhovh/IvL7oQHAKkOr58MPRD9sjj7b8T0zlCJ1ogEj6DPHUki1Y0vH8jeEXhpc
 f9ecq1pXnZRGoSJBwnQKwmlMyQTwBgSJUKGoBQPxTP0PrtR816vOtF0To/e6XEp+oAMANsUZHSu
 F/K+uUH5QwE2PgjkDhjMGngVXLHCJXw0BRvunP2O82XXZlN4Ib41vc9QcIojPQWQ19eS4tTv70z
 2V0kOSdCpC2dmX2+2hp2iWjMyUTLvij/sGL6QuvzjewHJLKVdkcuM8+IASs446jSPu12P2IIDvA
 fg3WekBd+hGR8dYOc34teY+Z1Te7JU+/2KwD6+4/OsKA0A22FSeEvTZwUfJyOg7cvTommD8tphN
 SN3EEFdb4L06LaiuOCPIwa73TZIXN7igAYek2lgRJWeT2dewYojGJfApTj8UYaZy31jbU9+K8T1
 dTqslSfWPWj6N6PZf6Q==
X-Proofpoint-GUID: mWFueeVd2Q4RLOJPee6HJoJXnIKU3_Xm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230008

Implement the NVMe-FC queue create and delete callbacks and map NVMe
controller queues onto ibmvfc hardware queues.

Use qidx of NVMe controller queue to map onto a ibmvfc_queue channel.
The Admin queue is always qidx 0 and general practice among other
drivers is to map both the Admin queue and first IO queue to the same HW
queue. Add a new ibmvfc_nvme_qhandle struct that will be used as the
opaque queue handle by the NVMe-FC layer when issuing fcp IO.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c | 38 +++++++++++++++++++++++++++--
 drivers/scsi/ibmvscsi/ibmvfc-nvme.h |  7 ++++++
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
index fc4337fc9b3f..1108d11d6b2d 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -28,6 +28,40 @@ static void ibmvfc_nvme_remoteport_delete(struct nvme_fc_remote_port *rport)
 	complete(&tgt->nvme_delete_done);
 }
 
+static int ibmvfc_nvme_create_queue(struct nvme_fc_local_port *lport, unsigned int qidx,
+				    u16 qsize, void **handle)
+{
+	struct ibmvfc_host *vhost = lport->private;
+	struct ibmvfc_nvme_qhandle *qhandle;
+
+	if (!vhost->nvme_scrqs.active_queues)
+		return -ENODEV;
+
+	qhandle = kzalloc_obj(struct ibmvfc_nvme_qhandle);
+	if (!qhandle)
+		return -ENOMEM;
+
+	qhandle->cpu_id = raw_smp_processor_id();
+	qhandle->qidx = qidx;
+
+	/* Admin and first IO queue are both mapped to index 0 */
+	if (qidx)
+		qhandle->index = (qidx - 1) % vhost->nvme_scrqs.active_queues;
+	else
+		qhandle->index = qidx;
+
+	qhandle->queue = &vhost->nvme_scrqs.scrqs[qhandle->index];
+
+	*handle = qhandle;
+	return 0;
+}
+
+static void ibmvfc_nvme_delete_queue(struct nvme_fc_local_port *lport, unsigned int qidx,
+				     void *handle)
+{
+	kfree(handle);
+}
+
 static int ibmvfc_nvme_ls_req(struct nvme_fc_local_port *lport,
 			      struct nvme_fc_remote_port *rport,
 			      struct nvmefc_ls_req *ls_req)
@@ -59,8 +93,8 @@ static void ibmvfc_nvme_fcp_abort(struct nvme_fc_local_port *lport,
 static struct nvme_fc_port_template ibmvfc_nvme_fc_transport = {
 	.localport_delete	= ibmvfc_nvme_localport_delete,
 	.remoteport_delete	= ibmvfc_nvme_remoteport_delete,
-	.create_queue		= NULL,
-	.delete_queue		= NULL,
+	.create_queue		= ibmvfc_nvme_create_queue,
+	.delete_queue		= ibmvfc_nvme_delete_queue,
 	.ls_req			= ibmvfc_nvme_ls_req,
 	.ls_abort		= ibmvfc_nvme_ls_abort,
 	.fcp_io			= ibmvfc_nvme_fcp_io,
diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.h b/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
index 3aa285788795..4c6146048a6f 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
@@ -27,6 +27,13 @@ extern unsigned int ibmvfc_debug;
 struct ibmvfc_host;
 struct ibmvfc_target;
 
+struct ibmvfc_nvme_qhandle {
+	unsigned int qidx;
+	u16 cpu_id;
+	unsigned long index;
+	struct ibmvfc_queue *queue;
+};
+
 int ibmvfc_nvme_register_remoteport(struct ibmvfc_target *tgt);
 void ibmvfc_nvme_unregister_remoteport(struct ibmvfc_target *tgt);
 int ibmvfc_nvme_register(struct ibmvfc_host *vhost);
-- 
2.54.0

