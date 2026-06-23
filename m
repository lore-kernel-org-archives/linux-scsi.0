Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3720C38C2AE;
	Tue, 23 Jun 2026 01:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178267; cv=none; b=MrrHIpHwMujLexCHcVt7QX/jq2RhIknX5ywJ3KJzfjy0fczOpnWIR3efmXDXw6+0BVOQZ9Aq1s4icqX9T9A5gXfhfwtbHO6ewavCof2IVuXJNMbCn9/ssjwNSrBbuTkAiXDzTVYkIuwKyGf3XlfJcHi6/TNF9aR2ogRUYzZLTnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178267; c=relaxed/simple;
	bh=yTjEysQw/wSx000QvV85x4w69FBUTyeqp5ZwHM6dXWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNWLgCBRCyD5hm6sdpvMnigiszJvdSPQQt+lxVi0mTURqqLPm2MxaqXsvikx8tcVnh95f6BL+bE3RzzR296Tb4XtdwJN0fKCZ56kpD1vfHDDIp3KOr2FvcxtsuWxeBKCMHoVXUsd4ZqhUOKeP+m6hmXm/dSKneBhx4IuQbRuGDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lx6Tw8DB; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lx6Tw8DB"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0oJC1286129;
	Tue, 23 Jun 2026 01:30:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=NzzMzrvh2G4aI3GfQ
	M7XGlh4HeWzJSQ29GFgBDju5do=; b=lx6Tw8DB+/pLdfvVc9Po7qJn4/kuCcfd/
	+UigeFdy0iJNk2X0tJmx8Rqc43ey9au8umQGvdCE8qaM/D4qvTyTHx/JnPqQRNDk
	BRKUjatiGi4xOmebwpA9CqqDh8KNTfpzESmlOEJBt7fXzsqQNeD2IeOuQD02nU0g
	5GmWhnuHjWAjqyWmfp3sMrdBtAxhJHh26LhTrKUXW+Ltt+Jfk/fNBixWMZPgvKP7
	W3Kv6hERo19lboQbQ4qscKop7s9q8C/xCJ5v/KZmHNdIgbBDDgyEMHFB/kscuq2u
	GhGOLLPForvkRjiIrwIF18BroxoyMif956aNjx5C7s5dX5g4Ji0Ww==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjgskys1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:54 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1Jgp7014680;
	Tue, 23 Jun 2026 01:30:54 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ex6ph8vme-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:54 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1Uq8318547232
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:53 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9504458056;
	Tue, 23 Jun 2026 01:30:52 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 05C3558052;
	Tue, 23 Jun 2026 01:30:52 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:51 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 20/29] ibmvfc: register local nvme fc port after fabric login
Date: Mon, 22 Jun 2026 18:30:26 -0700
Message-ID: <20260623013035.3436640-21-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX2WG6acaiiAW9
 tRROFk54iEgKXY5wgMOjNLDdU1l3Su1fnsEzPHm5FnJH4/RMZ6k1S7QUADE4AsIj86jKiVs2itp
 NcYDYW4G3+Uo+sZxv66Gf/grFUDJiey7SY/DVm/oCk0fbsEpBq/hacZ95LmugKJIMiGQ1Q8zKTF
 8efznHw0ZWvVvC469Q2MLHc5VNcaTQ5NGVfiayvMUWqEJRNkh3y47DGOU0U+uuJI/T0+aCc6RYM
 gOWpu/RxrAxDqeao5lmgol3UeIvSYiDD+LAZihN1fahsgIjjTTsRlqYFKemDqGLlYSgm+yPoec3
 PSWEnhN0m7NnfDlMbDAFy8HeInGL2spUwv2sNc+Duva1zSAaPmAwBo35z5LB0VFt590ph9GJta7
 g4/MrA6F8cX+808H/LiJ78DSCrGpl/LnwrP0+cwG/T1598LsWdGyGwQ8BhS/xFcpU59bZ9GDDSX
 Gd6NFV9AEk1/ui8lxOw==
X-Proofpoint-GUID: K6X1ZiZR1D_xqD0g1vntUyPAoWvK05Pl
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX/jgCjCgUHYSa
 42oj91y6mLrFnumFUPJcoqDG/6im6AaPBthRJJOppLUgilV8/sbM74Evg6sVzWJRty5mznYMU2I
 uMqcsp76/p7h4Iyq7/r2i9fuy1qYcgk=
X-Authority-Analysis: v=2.4 cv=I/lVgtgg c=1 sm=1 tr=0 ts=6a39e1ce cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=vSfUSS9DNbx-ZO_tdLQA:9
X-Proofpoint-ORIG-GUID: K6X1ZiZR1D_xqD0g1vntUyPAoWvK05Pl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 impostorscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230008

Register the local NVMe/FC port only after fabric login has completed.

The VIOS returns the client port ID in the fabric login response, and
that port ID is required to populate the local-port information passed
to the NVMe-FC midlayer. Delay local-port registration until that data
is available and update the registration helper accordingly.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c |  3 +++
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c | 18 +++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 9a6a885aa57e..2c7ecf7bdde9 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -5184,6 +5184,8 @@ static void ibmvfc_fabric_login_nvme_done(struct ibmvfc_event *evt)
 
 	switch (mad_status) {
 	case IBMVFC_MAD_SUCCESS:
+		fc_host_port_id(vhost->host) = be64_to_cpu(rsp->nport_id);
+		ibmvfc_nvme_register(vhost);
 		ibmvfc_dbg(vhost, "NVMe fabric login succeeded\n");
 		break;
 	case IBMVFC_MAD_FAILED:
@@ -5245,6 +5247,7 @@ static void ibmvfc_fabric_login_scsi_done(struct ibmvfc_event *evt)
 
 	switch (mad_status) {
 	case IBMVFC_MAD_SUCCESS:
+		fc_host_port_id(vhost->host) = be64_to_cpu(rsp->nport_id);
 		ibmvfc_dbg(vhost, "SCSI fabric login succeeded\n");
 		break;
 	case IBMVFC_MAD_FAILED:
diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
index 202e8d0b0081..fc4337fc9b3f 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -137,14 +137,17 @@ int ibmvfc_nvme_register(struct ibmvfc_host *vhost)
 	pinfo.dev_loss_tmo = 0;
 
 	rc = nvme_fc_register_localport(&pinfo, &ibmvfc_nvme_fc_transport,
-					vhost->dev, &vhost->nvme_local_port);
+					get_device(vhost->dev),
+					&vhost->nvme_local_port);
 
 	if (!rc) {
 		ibmvfc_log(vhost, 2, "register_localport: host-traddr=nn-0x%llx:pn-0x%llx on portID:%x\n",
 			   pinfo.node_name, pinfo.port_name, pinfo.port_id);
 		vhost->nvme_local_port->private = vhost;
-	} else
+	} else {
 		dev_err(vhost->dev, "Failed to register NVMe fc localport (%d)\n", rc);
+		put_device(vhost->dev);
+	}
 
 	return rc;
 }
@@ -154,9 +157,18 @@ void ibmvfc_nvme_unregister(struct ibmvfc_host *vhost)
 	int rc;
 
 	if (vhost->nvme_local_port) {
+		ibmvfc_log(vhost, 2, "unregister_localport: host-traddr=nn-0x%llx:pn-0x%llx on portID:%x\n",
+			   vhost->nvme_local_port->node_name,
+			   vhost->nvme_local_port->port_name,
+			   vhost->nvme_local_port->port_id);
 		init_completion(&vhost->nvme_delete_done);
 		rc = nvme_fc_unregister_localport(vhost->nvme_local_port);
-		if (!rc)
+		if (!rc) {
 			wait_for_completion(&vhost->nvme_delete_done);
+			vhost->nvme_local_port->private = NULL;
+		} else
+			dev_err(vhost->dev, "Failed to unregister NVMe fc localport (%d)\n", rc);
+
+		put_device(vhost->dev);
 	}
 }
-- 
2.54.0

