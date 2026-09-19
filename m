Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C89F38E8CA;
	Sat, 19 Sep 2026 01:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781611; cv=none; b=Ubv0PX1nvt4d41MQQGVYIyLtCNNymDq3CX5mfwcjucF8MBFkzikIp6o2EhwcWfDuKZ5M+0DLULNx9Oo7CirubpZd3qCpkbLKfrDit/zTlkoUUJn6GIpgLPD+b+oVMsJlhFlItNhZU7Fjit3tWM5ERF1SqcPWwUOmtfz+NNyGI3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781611; c=relaxed/simple;
	bh=b+g6uPRILIUdLbMLvnEJ/8ndpNXcfA8TBlgzLc2sUqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLHUGGqXJczOG41LGi4Tpc60NBwV7UPo2X3Xya0UmbVfo5z2VnetT6fHnd95Aar/hl/3ivjVAJwO02pLsec8hS9pyk+4C7FQkDRjRmKmjR75Y6ecUcxEpL4WhT4BxoHmJLx9DgZJNiuD2YlO6boALa/0L5RIN/4b86khyPOEbto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VClFZRnn; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VClFZRnn"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1Vtvx1676601;
	Sat, 19 Sep 2026 01:33:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=VTEB1W/56/OQ00pSx
	2m5TN3gBudtFEjM/SFMfZL+Hu8=; b=VClFZRnnPqNo89hGGYsKPsnPBbCTgDFa2
	4DpeE25xYZBwEiRAD3ca+pOkfiNF7wPneC9QQUjwAErsoQDu4mDmpAlEQB9aGf97
	ZjzIbldlJhVAkrha+BoUMLjPNB7Rjynhn4mwjLsQIWnJ2ueeH4h4cuglK8nuP5OX
	3L2Y7kRgn0rKMM4QP/zWYdZYPRZyOh3EGAS92Hjs+WG7EcBjDwBBDKpjFVFKFUN5
	eg0LVbOKD+nbHMBOYXouq42vzAJztAWMTHi+/y0xrp/sLvA5IABYziB2NPiSDvf3
	b0nN/okCG1qA9x+z6v6MRfFbltHVKp87e+UmoUIFXxzblbRQ4E7rg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gsgtd803s-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:21 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1SRvT1608270;
	Sat, 19 Sep 2026 01:33:21 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gsgrx00aa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:21 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68J1XKa748169226
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 01:33:20 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 120E858051;
	Sat, 19 Sep 2026 01:33:20 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 681D25805C;
	Sat, 19 Sep 2026 01:33:19 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.101.145])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 19 Sep 2026 01:33:19 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 12/20] scsi: ibmvfc: fix data race on tgt->nvme_remote_port
Date: Fri, 18 Sep 2026 18:32:58 -0700
Message-ID: <20260919013306.2948028-13-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX6HBkGL3HP2yj
 xNEM8aWs9b71NPeNwAHTM/FGTIl7jK27CvcDZEubDTA1CpIqBQTgb/pRRg+ynW9f+5Mi0pizGIL
 10SKOBmCq4MUWKeuwAyQyZThEd/pvxMBXhAS7/Ve3WvDNH/ZE+UjTseLtqgXGMnd7nqgL8JX3rr
 RYHfH9q5PeLE7uyiAGWoyCyiFGfGRj1P8hhvxkrSm/C3NwjWuGr4UkiF0IbsCK00EaSZfG0arpS
 CXpk9SbwtcXPLk0s7CyKocHhCoelni56pXVmKiOiTUaEg63IYeCZ28zya/7fiVM8FdmtQEiyaMn
 rF31q9yQsT+xLyNmy7UOFoXp62RStjzATQWt+cLaXaRimraEMWRYHtsn+2csOfB8E6+vWWrPRYu
 6oNZtxZu+l6pHNIpyxsFcDKOOFT4HUUg9PB3c4HAyay32iXzWxhm5b5Y0ThacFGxdKHJgsOR8OB
 U/iaztevrT3UQU0r24w==
X-Proofpoint-GUID: fIN0yPIIkSjo5dFcax-3hn4rAc0Cu9wf
X-Proofpoint-ORIG-GUID: fIN0yPIIkSjo5dFcax-3hn4rAc0Cu9wf
X-Authority-Analysis: v=2.4 cv=Q49HcI2a c=1 sm=1 tr=0 ts=6aade661 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=J1oym3C9a2iPP8IqlnUA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX1uSyWWF+r9oG
 4fKYgcg5Q7fceF38D6rDojzd6mOneHJlnL/vQt+5ehlm+7i/Yr4J8X98K38f6soXCOThgBPcndp
 RkhVMavVYklX5G+k/qqmM57sqLOuSj4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 suspectscore=0 spamscore=0 impostorscore=0
 phishscore=0 malwarescore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609190018

tgt->nvme_remote_port is written in two places without holding host_lock:

1. ibmvfc_nvme_register_remoteport() calls nvme_fc_register_remoteport()
   and stores the result directly into tgt->nvme_remote_port with no lock
   held, racing against locked readers in ibmvfc_tgt_add_nvme_rport() and
   ibmvfc_do_work().

2. The ibmvfc_nvme_remoteport_delete() callback writes
   tgt->nvme_remote_port = NULL from the NVMe core's thread context with
   no lock held, again racing against every locked reader of the field.

All readers of tgt->nvme_remote_port acquire host_lock before reading the
field, so both writers must do the same.

For ibmvfc_nvme_register_remoteport(): nvme_fc_register_remoteport() may
sleep so it must be called before acquiring the spinlock. Use a local
pointer to capture the result, then take host_lock and store the pointer
into tgt->nvme_remote_port and set ->private under the lock.

For ibmvfc_nvme_remoteport_delete(): acquire host_lock around the
tgt->nvme_remote_port = NULL store. The callback is always invoked after
ibmvfc_nvme_unregister_remoteport() drops host_lock before waiting for
completion, so taking the lock here is safe.

Fixes: 696d1cc2aaa2 ("scsi: ibmvfc: process NVMe/FC rports in work thread")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
index 58e3e50d0c5c..a6fc9e8a35f6 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -26,8 +26,11 @@ static void ibmvfc_nvme_localport_delete(struct nvme_fc_local_port *lport)
 static void ibmvfc_nvme_remoteport_delete(struct nvme_fc_remote_port *rport)
 {
 	struct ibmvfc_target *tgt = rport->private;
+	unsigned long flags;
 
+	spin_lock_irqsave(&tgt->vhost->host->host_lock, flags);
 	tgt->nvme_remote_port = NULL;
+	spin_unlock_irqrestore(&tgt->vhost->host->host_lock, flags);
 	complete(&tgt->nvme_delete_done);
 }
 
@@ -473,7 +476,9 @@ static struct nvme_fc_port_template ibmvfc_nvme_fc_transport = {
 int ibmvfc_nvme_register_remoteport(struct ibmvfc_target *tgt)
 {
 	struct ibmvfc_host *vhost = tgt->vhost;
+	struct nvme_fc_remote_port *rport;
 	struct nvme_fc_port_info pinfo;
+	unsigned long flags;
 	int rc;
 
 	if (!IS_ENABLED(CONFIG_NVME_FC))
@@ -490,14 +495,16 @@ int ibmvfc_nvme_register_remoteport(struct ibmvfc_target *tgt)
 	pinfo.port_id = tgt->ids.port_id;
 	pinfo.port_role = FC_PORT_ROLE_NVME_TARGET;
 
-	rc = nvme_fc_register_remoteport(vhost->nvme_local_port, &pinfo,
-					 &tgt->nvme_remote_port);
+	rc = nvme_fc_register_remoteport(vhost->nvme_local_port, &pinfo, &rport);
 
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	if (!rc) {
 		ibmvfc_log(vhost, 2, "register_remoteport: traddr=nn-0x%llx:pn-0x%llx PortID:%x\n",
 			   pinfo.node_name, pinfo.port_name, pinfo.port_id);
-		tgt->nvme_remote_port->private = tgt;
+		rport->private = tgt;
+		tgt->nvme_remote_port = rport;
 	}
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
 	return rc;
 }
-- 
2.55.0

