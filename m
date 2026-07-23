Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCC5379C40;
	Thu, 23 Jul 2026 00:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764945; cv=none; b=gEJCF3ba/zK0bwMvJXKkQZFvTk0A18CQ4+7gmxqMYah21L1uOFdFX3Bhn7v8n8NDrTVwgEKbyFBBgFuHWU87M+dgXJrhNSZynBFGG47BVmDaPrL5WUKHg2mvvqv3kpZWj6IMYm53JsfapSsJ36kfHfeekr9T/QSKLFlPIX2OuT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764945; c=relaxed/simple;
	bh=SsrsDiEFpNrW7OsO70Sb3h0EtB9O4E9dFG9ACq6dWos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpeulfhxgKxu66YmcLcyRWzrN3a4j74uEr5WFK1mmCdjZeQiIRDnr8CEReODTAasejy9R5CuFEuM+pxMqwcXKsHhaedo5Q0zxvMKDtlJtsxYpZIV+Vl6Odsl3Y1B/y7Q0dGfFUnR1zTbL15ep/YjeTjkf3DuqC3/veQZBzLuHdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TjzKHnYd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TjzKHnYd"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIBwbC713588;
	Thu, 23 Jul 2026 00:02:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=prYcbuWCVd6ViwbzA
	vLmQBGVfQ93OQI+gDSd9Mn/J8o=; b=TjzKHnYds4M/AiLD5z0GK6bh00ycuGiK/
	J6877zozRSJcv2J6GYMHs3YVsonkIXsI+X851+6lo36WfM/kfEVXSKyt/Ah3bHiE
	+DSycPnJMygHIYzFpvCAZ8pKXVGfSjq52W70ZXpDDrLGDcKa/tzx2m2NgUj9W/xe
	Z0RT3IbEBoG7JD8kcnkeGYAUZsC2wNlvh0GriF93nOMT+/4h+SKrgH0XVw56ftq1
	iXb1HA7aN8xdr6tJPksmaGv6dwIJXsTPjqQWKYQaCf1lqXuyFoyUmAq8QOFA4kR3
	lDcvRKa0k6colz1V5hiTDc1muLObWS6k1OhVHQ1K0/z1otAOpuaWA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7ahcctu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:18 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNnhbo021767;
	Thu, 23 Jul 2026 00:02:18 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgm6w9ukn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:18 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N02H2Q15139448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:02:17 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3699658060;
	Thu, 23 Jul 2026 00:02:17 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8ED2158056;
	Thu, 23 Jul 2026 00:02:16 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:02:16 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 31/33] ibmvfc: implement nvme-fc LS abort handling callback
Date: Wed, 22 Jul 2026 17:01:47 -0700
Message-ID: <20260723000149.969416-32-tyreld@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: dMgBv_ffQzlj--f7jnjHDWEfNGPUAYOK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX3DvrZ+0qbzy1
 WrKfnNau+wtJUS1qw4PRY2AEtw1Xr9JkCdZm+oW0MzQXAtB7s3ruyj5VrJtZpa71VabRunCLlBt
 T8IvkOTfa9Ml74XMkyEtZA35pLvAL1Rmim1JI8m+37yplmGiLPUavPlRERPMn/6l5Qjx1ppDBr2
 2OBIMaY2K7PWWAnjwOmh+Bph657HSvxRMQL2VgGSyf1lxDrwim0PjnJ5inXpuVVCTvxYUG1+zi6
 EJcupr0p+kYGeGYoApjK1GENhiYWiXUm95Dxy8AEe4Obs8pO9veqAbnJVXXjYKijScfgv+m86Ly
 0ygQ40IKiCxb/dBY/IzHBxgH0r5xoDU6bQFqIZR/Klu9s9OwUaSEKzme79Sn+o07LWu29FKDcCb
 JGymOoOpCGg66x5U0OXMlx/XJsrZOCP5ywcyTezwWp/TICDZ232D+vPy58cgQ2ehx1VL4VJ+xoZ
 tUbLrt9RuMiepdmr98w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX2RDDTAEy01hw
 qn/S/IAWvFJXQjKGY0Xz7ihvA1Ozzscif7qxMQRmVB5Wa00p+Y9Qj6HGCSdaaiGFEpQTslrHl2g
 vK3mmtVpKqHh18jm6oqRWaNQuFxCESI=
X-Proofpoint-GUID: dMgBv_ffQzlj--f7jnjHDWEfNGPUAYOK
X-Authority-Analysis: v=2.4 cv=SM5ykuvH c=1 sm=1 tr=0 ts=6a615a0b cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=i_vXdmPKhaR3-41kbpgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220234

Implement the NVMe FC-LS abort callback by issuing an ibmvfc cancel MAD
to the VIOS for the outstanding link-service request.

Use the saved event pointer from the original FC-LS request to identify
the command to cancel, submit the cancel operation, and complete the
abort request based on the returned status.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c | 64 +++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
index d31e7e9ea7a9..390410e44f0d 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -13,6 +13,8 @@
 
 #include "ibmvfc-nvme.h"
 
+static unsigned int default_timeout = IBMVFC_DEFAULT_TIMEOUT;
+
 static void ibmvfc_nvme_localport_delete(struct nvme_fc_local_port *lport)
 {
 	struct ibmvfc_host *vhost = lport->private;
@@ -159,10 +161,72 @@ static int ibmvfc_nvme_ls_req(struct nvme_fc_local_port *lport,
 	return 0;
 }
 
+static void ibmvfc_sync_nvme_completion(struct ibmvfc_event *evt)
+{
+	/* copy the response back */
+	if (evt->sync_iu)
+		*evt->sync_iu = *evt->xfer_iu;
+
+	complete(&evt->comp);
+}
+
+static void ibmvfc_init_ls_abort(struct ibmvfc_event *evt, struct nvmefc_ls_req *ls_abort)
+{
+	struct ibmvfc_tmf *tmf;
+	struct ibmvfc_event *abt_evt = ls_abort->private;
+	struct ibmvfc_target *tgt = abt_evt->tgt;
+	struct ibmvfc_host *vhost = evt->vhost;
+
+	tmf = &evt->iu.tmf;
+	memset(tmf, 0, sizeof(*tmf));
+	tmf->common.version = cpu_to_be32(2);
+	tmf->target_wwpn = cpu_to_be64(tgt->wwpn);
+	tmf->common.opcode = cpu_to_be32(IBMVFC_NVMF_TMF_MAD);
+	tmf->common.length = cpu_to_be16(sizeof(*tmf));
+	if (vhost->state != IBMVFC_ACTIVE)
+		if (!ibmvfc_check_caps(vhost, IBMVFC_CAN_SUPPRESS_ABTS))
+			tmf->flags = cpu_to_be32(IBMVFC_TMF_SUPPRESS_ABTS);
+	tmf->cancel_key = cpu_to_be32((u64)abt_evt);
+	tmf->my_cancel_key = cpu_to_be32((u64)evt);
+	tmf->assoc_id = cpu_to_be64(tgt->assoc_id);
+
+	init_completion(&evt->comp);
+}
+
 static void ibmvfc_nvme_ls_abort(struct nvme_fc_local_port *lport,
 				struct nvme_fc_remote_port *rport,
 				struct nvmefc_ls_req *ls_abort)
 {
+	struct ibmvfc_host *vhost = lport->private;
+	struct ibmvfc_target *tgt = rport->private;
+	struct ibmvfc_event *evt;
+	union ibmvfc_iu rsp;
+	unsigned long flags;
+	u16 status;
+
+	evt = ibmvfc_get_event(&vhost->crq);
+	if (!vhost->logged_in || !evt)
+		return;
+
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	kref_get(&tgt->kref);
+	ibmvfc_init_event(evt, ibmvfc_sync_nvme_completion, IBMVFC_MAD_FORMAT);
+	ibmvfc_init_ls_abort(evt, ls_abort);
+	evt->sync_iu = &rsp;
+
+	if (ibmvfc_send_event(evt, vhost, default_timeout))
+		goto out;
+
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+
+	wait_for_completion(&evt->comp);
+	status = be16_to_cpu(rsp.mad_common.status);
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	ibmvfc_free_event(evt);
+out:
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	ibmvfc_dbg(vhost, "ls_abort: cancel failed with rc=%x\n", status);
+	kref_put(&tgt->kref, ibmvfc_release_tgt);
 }
 
 static void ibmvfc_nvme_done(struct ibmvfc_event *evt)
-- 
2.55.0

