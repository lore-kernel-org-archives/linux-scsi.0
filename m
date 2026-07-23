Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF9929992A;
	Thu, 23 Jul 2026 00:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764938; cv=none; b=KhSU3mhvUVFU0NF2EzUxVPp+az+ed1NrUgOAhPBuvSa5ubPD+P6y2ZvxjHDj73tI+aPRUsH2V9KVFv+xOsKp1sEHlA4TfHRbnmFdaelyvLV4OiMQ+3e+PR1XPZE7VFkHPLsOtxmMKWYA7GiGC2X2ylJ4A4oLoEOAmJArRfo+GhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764938; c=relaxed/simple;
	bh=xpSxNOezGu8BqiUe3cBzbkYd4Ha9G8RN0XziyJ7RNCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHNtGmkqdxAX0GaUij/VqG39JXpzZZuqiUNIDbBAeMBalFGikOtbGigHWSVcq3Gt89XqgAuLJ/uMjsKlMZMyuSY61TwSMUe5HuxKcSLnqGYqN5z32UoA2f1A9iIettUdtHxrwxNU6NjQcUvATWgylzua6J4vX3xPW9q8kQ5yZcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HRyY2n4t; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HRyY2n4t"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIBkqu712893;
	Thu, 23 Jul 2026 00:02:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=AhCyypioFTGg6CSh6
	AxewyLQ2QuLXsoUiJheEA/2Cxg=; b=HRyY2n4treLzbHQC2QbABMLwF4x0rH2AV
	zuuYdJ9Uc4p9tjvdGgYaU3fopWp6Pp9DZYnjPrJgw3ctBehg1p6adFinIsS+gSxj
	yvKViYw0CRgQTDirxb6ssLlLyD0Q3RTGdzvBlzfojor7C7aECzZxeA83aVbjt4Jn
	JrcGniU/M4Lz3MIGSnbZk7doTAQ2YUnEoPaGxRYCQ10gsJEoZmeGNA3qDTiE1hFo
	LFgs2vgoQYFAZBItyuCXzV+ibCtyNBjkWjAJQZJsrO52T3HSlOW+Nn4pKzcD0hwv
	CAHyiHLMtFZR+B/lv6NmqeFXmULHBdxkFmC93ydBzZVmI48ASemaA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7ahcctm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:12 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNnj25026459;
	Thu, 23 Jul 2026 00:02:11 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgktq9x32-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:11 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N02Ak833489528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:02:10 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C05E658060;
	Thu, 23 Jul 2026 00:02:10 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 274275803F;
	Thu, 23 Jul 2026 00:02:10 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:02:10 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 23/33] ibmvfc: implement NVMe/FC stubs for local/remote port registration
Date: Wed, 22 Jul 2026 17:01:39 -0700
Message-ID: <20260723000149.969416-24-tyreld@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: Yu9wz6s3_2YJ_t1qNm9cqSHnHhqTy55x
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX61wjT14IEBUf
 Bne4gw/MzYbNUp6sCMDOhpj6h/pxguQbwiNig37pP+hjjzqSBRmH8O1trQg2abAAKa/+RJpCmgj
 nBmzAhB3UnqRqjxG57M6ivaOTeaE1XoAJqegRv3HkusdLcubcV3WY2DLp0UeaBhfffhskJQJSGY
 7rqijdSk2ccKPQNt6RQrgbOz2PaBWBKoI14CeIcQIO1FrRY7zlGCHI2dlbT6flj9l/Q/JSMYT4C
 L6Rq2T36ghNF/kMO518HYSoukbhZX1+ZfnEQGq87SlqRHisD6/eYvZK4sq8X/5GpMNCZ3TWIk7I
 7zBze4byosx22eOCeAyUdYjc3bETbPRKUqZd0htaV4T5ukcornlkvOIchX59WllrZyc/LnlG9Fy
 XTg3elFBd6ui68PxkvHbqtaU5Ny5ue6PArzm3ayeuK49JFEtslLgHCkbL+pFKm3ZtvgVjC6vdM9
 aGlxdm4PxeNqs4CQlMw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX8eR8zMEj09sq
 0fy6NAuTguM90aOIIM6bBuK//jNwjE6WvGS+2i4WjANhwKQZfK0RGpGw2K/cQ2G2HV4eMemxbV7
 gApIh2oAepxJi9WI8+z0dsG72xBapIE=
X-Proofpoint-GUID: Yu9wz6s3_2YJ_t1qNm9cqSHnHhqTy55x
X-Authority-Analysis: v=2.4 cv=SM5ykuvH c=1 sm=1 tr=0 ts=6a615a04 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=y1iSCKkB5_XLrlYggoUA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220234

Implement the initial NVMe/FC local-port and remote-port registration
functions that notify the NVMe-FC midlayr of port discovery and loss.

Register the local port with the NVMe-FC transport, register discovered
remote ports against that local port, and add matching unregister paths
that wait for the NVMe-FC core to complete asynchronous deletion before
dropping driver references. Also store driver-private host and target
pointers in the registered NVMe-FC port objects.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c | 80 ++++++++++++++++++++++++++++-
 drivers/scsi/ibmvscsi/ibmvfc-nvme.h |  4 +-
 drivers/scsi/ibmvscsi/ibmvfc.h      |  4 ++
 3 files changed, 84 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
index 2ee1c64665d9..d679d1ca366a 100644
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
@@ -70,28 +78,96 @@ static struct nvme_fc_port_template ibmvfc_nvme_fc_transport = {
 
 int ibmvfc_nvme_register_remoteport(struct ibmvfc_target *tgt)
 {
+	struct ibmvfc_host *vhost = tgt->vhost;
+	struct nvme_fc_port_info pinfo;
+	int rc;
+
 	if (!IS_ENABLED(CONFIG_NVME_FC))
 		return 0;
 
-	return 0;
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
 	if (!IS_ENABLED(CONFIG_NVME_FC))
 		return;
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
+	}
 }
 
 int ibmvfc_nvme_register(struct ibmvfc_host *vhost)
 {
+	struct nvme_fc_port_info pinfo;
+	int rc;
+
 	if (!IS_ENABLED(CONFIG_NVME_FC))
 		return 0;
 
-	return 0;
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
 	if (!IS_ENABLED(CONFIG_NVME_FC))
 		return;
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
2.55.0

