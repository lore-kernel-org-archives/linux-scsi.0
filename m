Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4115938D407;
	Tue, 23 Jun 2026 01:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178270; cv=none; b=kHhIAs3JhteJ062X0s5xMkeD9j9DxGC2gGp9cahhFeDv4TjAv4cxu6bx8Q4bMM38bavJJt7wi0VacS49vT6FQUtVN86s5OulYzTHTUbDzEZdvjB9huHgGorkilof8jX09nl20nR7wR/A2H377szWRJ36wN8ti3yVaOoUZbmvpe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178270; c=relaxed/simple;
	bh=SSUTmUdlcPDkYJ73O8hS01qCg13hZ3jBc7dmva8BdNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQEmK74NXnWKnZ4kv0IKNQXkERRgHXG/H1znbZmgcAEy+k86OTm2zLvjRMLLj1VHpGp1TfIOvbw3W0ay5P9OWfM+l8aLaCR2TpBzo3OAmtO5mXWSOeynlrBbpThBl1j6J5/E2Ua+keIfQeW0M/jBlNV8DOyqQ98PKJ1lnh4y5Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lENl9Lo5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lENl9Lo5"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0nxI2348186;
	Tue, 23 Jun 2026 01:30:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=fL6FAi9eLzj3Lbpze
	+HYwcASdxDdDVQ+XLlZnfhxaIo=; b=lENl9Lo5EpQF8Uf2kq1gmd6r1z1K+Hn3X
	K02Tj7u0D8+3OtV6VJjpZqvHLOSwf0QFIF8t5Ig2lDLAY101GaKcTT+50NMYnKvH
	KMUMHqjjeayY1A5XrXaq4z5jGZ1aKR/vml3tR7MVhnYiLhVWHCcs2hy75PPpqh25
	d77/AeCGfbdr7zQZT+7UTKE84f97ParVCGZ69URc1m+gJ/bQDpgWFHJpnyNoIncO
	XJs+5OQbAL2D35KaMQeNUKzXAK22/x/dn+ZdN94+3/SiLeTZrmb0FeoCBY46iJ01
	s+swc1vWe/Sn3Xoot4iMT2kSe5A+tnc2TU+sRsOzWJz6oPjwTFANg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewh9gc43h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:54 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1Jfmu018374;
	Tue, 23 Jun 2026 01:30:53 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ex7vygn3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:53 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1UqdZ27853322
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:52 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF85258056;
	Tue, 23 Jun 2026 01:30:51 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A1475805E;
	Tue, 23 Jun 2026 01:30:51 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:51 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 19/29] ibmvfc: implement NVMe/FC stubs for local/remote port registration
Date: Mon, 22 Jun 2026 18:30:25 -0700
Message-ID: <20260623013035.3436640-20-tyreld@linux.ibm.com>
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
X-Proofpoint-GUID: Og5wtMPXIJIaEyjed_rz12fo3FbMQhTO
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfXy4UsRlh5fEyL
 SGWa9+A4dp3bLdJyppx33cLh1ZOqs/abk0JCX3mnKDiUqzWWF8UOYI0AWWvyEON5tsS3BPI9sB3
 0Cr0BQ+8DcLuXcPGTiU43OeMU2HeYXU=
X-Authority-Analysis: v=2.4 cv=c62bhx9l c=1 sm=1 tr=0 ts=6a39e1ce cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=y1iSCKkB5_XLrlYggoUA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX6U+59PtZ4ULp
 Mc0YSZ20ZdyXaH9i0KSTaW/X7kG+uOW2VI+fr14nSasqI0gh/SWsCdsetoqUs0p+PZnIf/Fl2KW
 WAihqwkeDrz8WV8k8D1PR+AzUqK06THTi8tj0qwYVQ+2AWtednK4ZEfN3OJOgz85ev4h2FsviHt
 fLuRx+P5pqrcXjo3Mi9YNbJ8MpaNBa6E8+aHnEt8iwQ7Ss/AV7NPftJjVkgfnuyk7GAyNo3EJnS
 sHHFXaX0NISo/DShfTF5JIDVDM+ohLlbPj4Y9gjVnnBFTT4pyjDK8axdqT1mFaoSWxmTxq+7vHP
 pZ1IP/6PZJE6/QscZU4riARGq8jT5+D8aY9ipH9IU57xv5fupezxIBnaccgEhq64YGDag7Fxt4L
 7pMiU+8lmPWRuGj0ujQJ/GcL3qi8nBFWWU2WW+JytJeLkfpBlgYLPOUw3DQZifforjaEytyfSJ6
 LorDuqNORbgu2b99mwQ==
X-Proofpoint-ORIG-GUID: Og5wtMPXIJIaEyjed_rz12fo3FbMQhTO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 phishscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230008

Implement the initial NVMe/FC local-port and remote-port registration
functions that notify the NVMe-FC midlayr of port discovery and loss.

Register the local port with the NVMe-FC transport, register discovered
remote ports against that local port, and add matching unregister paths
that wait for the NVMe-FC core to complete asynchronous deletion before
dropping driver references. Also store driver-private host and target
pointers in the registered NVMe-FC port objects.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c | 79 ++++++++++++++++++++++++++++-
 drivers/scsi/ibmvscsi/ibmvfc-nvme.h |  4 +-
 drivers/scsi/ibmvscsi/ibmvfc.h      |  4 ++
 3 files changed, 83 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
index 4a66cde8a8d2..202e8d0b0081 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -14,10 +14,18 @@
 
 static void ibmvfc_nvme_localport_delete(struct nvme_fc_local_port *lport)
 {
+	struct ibmvfc_host *vhost = lport->private;
+
+	vhost->nvme_local_port = NULL;
+	complete(&vhost->nvme_delete_done);
 }
 
 static void ibmvfc_nvme_remoteport_delete(struct nvme_fc_remote_port *rport)
 {
+	struct ibmvfc_target *tgt = rport->private;
+
+	tgt->nvme_remote_port = NULL;
+	complete(&tgt->nvme_delete_done);
 }
 
 static int ibmvfc_nvme_ls_req(struct nvme_fc_local_port *lport,
@@ -70,18 +78,85 @@ static struct nvme_fc_port_template ibmvfc_nvme_fc_transport = {
 
 int ibmvfc_nvme_register_remoteport(struct ibmvfc_target *tgt)
 {
-	return 0;
+	struct ibmvfc_host *vhost = tgt->vhost;
+	struct nvme_fc_port_info pinfo;
+	int rc;
+
+	if (!vhost->nvme_local_port) {
+		dev_err(vhost->dev, "Attempt to register NVMe fc remoteport without valid localport\n");
+		return -EINVAL;
+	}
+
+	memset(&pinfo, 0, sizeof(struct nvme_fc_port_info));
+	pinfo.node_name = tgt->ids.node_name;
+	pinfo.port_name = tgt->ids.port_name;
+	pinfo.port_id = tgt->ids.port_id;
+	pinfo.port_role = FC_PORT_ROLE_NVME_TARGET;
+
+	rc = nvme_fc_register_remoteport(vhost->nvme_local_port, &pinfo,
+					 &tgt->nvme_remote_port);
+
+	if (!rc) {
+		ibmvfc_log(vhost, 2, "register_remoteport: traddr=nn-0x%llx:pn-0x%llx PortID:%x\n",
+			   pinfo.node_name, pinfo.port_name, pinfo.port_id);
+		tgt->nvme_remote_port->private = tgt;
+	}
+
+	return rc;
 }
 
 void ibmvfc_nvme_unregister_remoteport(struct ibmvfc_target *tgt)
 {
+	struct ibmvfc_host *vhost = tgt->vhost;
+	struct nvme_fc_remote_port *rport = tgt->nvme_remote_port;
+	int rc;
+
+	if (!tgt->nvme_remote_port)
+		return;
+
+	ibmvfc_log(vhost, 2, "unregister_remoteport: traddr=nn-0x%llx:pn-0x%llx PortID:%x\n",
+		   rport->node_name, rport->port_name, rport->port_id);
+	init_completion(&tgt->nvme_delete_done);
+	rc = nvme_fc_unregister_remoteport(tgt->nvme_remote_port);
+
+	if (!rc) {
+		wait_for_completion(&tgt->nvme_delete_done);
+		tgt->nvme_remote_port->private = NULL;
+	}
 }
 
 int ibmvfc_nvme_register(struct ibmvfc_host *vhost)
 {
-	return 0;
+	struct nvme_fc_port_info pinfo;
+	int rc;
+
+	pinfo.node_name = fc_host_node_name(vhost->host);
+	pinfo.port_name = fc_host_port_name(vhost->host);
+	pinfo.port_id = fc_host_port_id(vhost->host);
+	pinfo.port_role = FC_PORT_ROLE_NVME_INITIATOR;
+	pinfo.dev_loss_tmo = 0;
+
+	rc = nvme_fc_register_localport(&pinfo, &ibmvfc_nvme_fc_transport,
+					vhost->dev, &vhost->nvme_local_port);
+
+	if (!rc) {
+		ibmvfc_log(vhost, 2, "register_localport: host-traddr=nn-0x%llx:pn-0x%llx on portID:%x\n",
+			   pinfo.node_name, pinfo.port_name, pinfo.port_id);
+		vhost->nvme_local_port->private = vhost;
+	} else
+		dev_err(vhost->dev, "Failed to register NVMe fc localport (%d)\n", rc);
+
+	return rc;
 }
 
 void ibmvfc_nvme_unregister(struct ibmvfc_host *vhost)
 {
+	int rc;
+
+	if (vhost->nvme_local_port) {
+		init_completion(&vhost->nvme_delete_done);
+		rc = nvme_fc_unregister_localport(vhost->nvme_local_port);
+		if (!rc)
+			wait_for_completion(&vhost->nvme_delete_done);
+	}
 }
diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.h b/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
index 97e267871df2..0465e8719881 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
@@ -11,8 +11,8 @@
 #ifndef _IBMVFC_NVME_H
 #define _IBMVFC_NVME_H
 
-#include <uapi/scsi/fc/fc_fs.h>
-#include <uapi/scsi/fc/fc_els.h>
+#include <scsi/fc/fc_fs.h>
+#include <scsi/fc/fc_els.h>
 #include <linux/nvme-fc-driver.h>
 
 #include "ibmvfc.h"
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 66025e6ffeed..d8c2e5f1fdec 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -839,6 +839,8 @@ struct ibmvfc_target {
 	void (*job_step) (struct ibmvfc_target *);
 	struct timer_list timer;
 	struct kref kref;
+	struct completion nvme_delete_done;
+	struct nvme_fc_remote_port *nvme_remote_port;
 };
 
 /* a unit of work for the hosting partition */
@@ -1015,6 +1017,8 @@ struct ibmvfc_host {
 	struct work_struct rport_add_work_q;
 	wait_queue_head_t init_wait_q;
 	wait_queue_head_t work_wait_q;
+	struct nvme_fc_local_port *nvme_local_port;
+	struct completion nvme_delete_done;
 };
 
 static inline struct ibmvfc_host *ibmvfc_channels_to_vhost(struct ibmvfc_channels *channels)
-- 
2.54.0

