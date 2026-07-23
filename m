Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3DB3624CC;
	Thu, 23 Jul 2026 00:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764943; cv=none; b=GkigJvxqTrwsGw2mMYwSh5+qUrwSRnBjIrCNGFpScq3Gnw2Xkii+X5Voqvu0twRlIZKJGmqcvGRfy6GU76vkf9adrmsLsNDp4NdFd3qh7ChJRXFTh92t9Kps2OiD5PVMe/IAQ507CkQo8n1PuOL4tUbub/vS7V/iGagnUwz9y/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764943; c=relaxed/simple;
	bh=TySdMx2Doo6myQfeU43Wb4gLfIRw97fnqm/4NP5kCjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNnR/BywJCltDECiQA3B0Cv7jUM+1M8Rln3ckYEaIocvFhgjk5HcraB1X9v/iR1KXosQpOesLzhoOUPQv2L+tc0cjLm6tMYuRXWZk+/65EpFjL44m7uS819IfR6PfK52YnK9IypVjpgsA318vHeSVjCbCiAJhTyNqrg65U+uPR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=I81EHICA; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="I81EHICA"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIBjBV704715;
	Thu, 23 Jul 2026 00:02:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=1KaxPxGMAHBRCGOFa
	AOShkVVGnR/EB7WQ+/6AMC/qdA=; b=I81EHICA9zVYQSAtnUxR/ys29zJ1xk8/d
	Pok6NSgorbG2fTFfHmj8HzQRNuLzVqfN8uz7Kqtr//tD4rGQfZwRE0nYzOeDi//2
	2oTSzelvAyHVdMd5sUyNT47iQizAC4l105MApGbLLHcb6fb8acZ6OXtCkOq8yUjD
	xtpzu7GJ0L17nmADx4noXhFRoUc5J0TbrpvihcDgz/Bl1FUQ4bcs8yi4z+DMuwCo
	e2yLrXGbL30xN5Emv4LJ7JsZKExgDx2HRbQOACy/JiBLaveGjsqKrO81ZChGd/XI
	bl42FVf6jPVvyLJ4SgpH4WYvhOt3yX/JKiRWeGL6F1w1WOUEi2GSQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7abmynx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:16 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNndSZ032298;
	Thu, 23 Jul 2026 00:02:15 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgmtk1rt4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:15 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N02E5K5702394
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:02:14 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7420C5805A;
	Thu, 23 Jul 2026 00:02:14 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D461458063;
	Thu, 23 Jul 2026 00:02:13 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:02:13 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 28/33] ibmvfc: implement LLDD callbacks for mapping nvme-fc queues
Date: Wed, 22 Jul 2026 17:01:44 -0700
Message-ID: <20260723000149.969416-29-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260723000149.969416-1-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX3S03qJh6AhyT
 Wmjw8DXvtYnnXAO3EvZuxgaVSvsGL+4dmwKI1jqHzvyaOS7uRJAD7BDNNGNHKiDXlbfNnDPsrxi
 ko8QZpURiSkUt0EMnJg1NRPg9YPBtLDkeVhRt7XhRClmDBJFtQHXqEx9h/wfgP6eyXe+UNgzAez
 3+t6kw9BtxKIDgzmjwCZSM5xN9FBD0X/jnnj3EXlSF1ZHjJ58tQoECLre+/aDZSma4w4X+xxByZ
 cG6MpUgDoD1FniVlivaDzilmq6JMZhlQHtwrs8fLufd2VXNovZDiC0bIx07zoL8WgArNhxtOAwy
 usKKXmrGhypit6v1oNr3zTWwjTWIfNbg33M2+91tEQWCChTMefnAwbZa0TyK+qRnRfpnl52tDlZ
 4KILk/3N6MrT71kuIDjAL0S3Ro1tjb50Dxm1mTVba+dTCAdDCtJl+DhXXl7DKV8EKZovchJmqs8
 quxi6lf4U1CXUJQ/WdQ==
X-Authority-Analysis: v=2.4 cv=F7ZnsKhN c=1 sm=1 tr=0 ts=6a615a08 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=xXv5fKpT-M1mo7RiuCsA:9
X-Proofpoint-ORIG-GUID: jESuruwRYuPgGBA3dPxQ42kLgbN-O7sM
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX8ioTH1cMbu57
 SGYByUOuPvB7tW9N+1ts5n8z9aqVAvuU4RaNiGDUs7I5/dUajNhW/OQtuwSZ9lu/+enxHUlvr5z
 7i+yBV3w7JPLGaOZ9l9QVolR6FV6jXk=
X-Proofpoint-GUID: jESuruwRYuPgGBA3dPxQ42kLgbN-O7sM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220234

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
index 637d7d7015cf..ecf9f4c0549c 100644
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
2.55.0

