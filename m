Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C8D390995;
	Tue, 23 Jun 2026 01:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178272; cv=none; b=hpZl+uvHca85pTsJ6NGSWnAuXhvTRFjFOVWutrCFYPmacQ964CuXlXfG5IWhFYGLFFtXKFe2GrswqmYg8EvDsgbA0dtEwec5BEYT3lmOJ0FqQikrrWgyR1ma1OpO0yJcmHQPdUyiTfNPDBRCez98Mi2KNUhmmsMQqeyfC4Y32dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178272; c=relaxed/simple;
	bh=MTifirXaknGdhmIM2QGL4w54CIKB1JiNvoSn2LfBvQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRN2wD0gAj3OcgFge8yBxDtOS/d7E5WafRdfjsgUfUXUywclQ9Bp41DQbkODiPDPFqUSgB39boOcz4XOsmSYF/rBmdDU1mp1VnByFh7NnTJzYCzCWrlRyUlduXc6q9kstM5yO4v3c1iAjVGd/ZGMkYKtHef3rYNgYgIFqsfhhSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GhRApJA5; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GhRApJA5"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0nX7a347285;
	Tue, 23 Jun 2026 01:30:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Xtj8B06Ht9tln3wD0
	y8g1aljCFfOZpHymwG2yWYKQBw=; b=GhRApJA5k2G1OGKJbr6BfNAScCHFcHxqO
	hghEruDhZCOlrwQSTCVpfGcansDbW/8C8vPbWN4vQQBwmtuDPaMY8n0qVHC9TMUq
	HZ3kVy7tY3u2376WHQEj+UTt6z+kyu2eLH+K1ZyFTBW6+o6GKy1oWYw5ySs70VME
	J6qu0XjBnA4wcwI+LyQoT696r4B+tP2jYRvTir9nCixpaWZoHXYAYp4Q8R3TTm2C
	w86qMTKPn/m7XE1cB7vQRE/xIb/XMZiSCfEWC/tpfPpOxOAHm2vtTbG+jy4n9LTs
	IcBIXWqxtbrxRlaCk/VzFN9RCoAWvg16A6V3NYlewPZ24y+onx2cQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewh9gc43t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:59 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1JslV005273;
	Tue, 23 Jun 2026 01:30:59 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ex5jw92k1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:58 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1UvhF22217318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:57 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B401E5805A;
	Tue, 23 Jun 2026 01:30:57 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E24958056;
	Tue, 23 Jun 2026 01:30:57 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:57 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 27/29] ibmvfc: implement nvme-fc LS abort handling callback
Date: Mon, 22 Jun 2026 18:30:33 -0700
Message-ID: <20260623013035.3436640-28-tyreld@linux.ibm.com>
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
X-Proofpoint-GUID: 32_ZTHBjjOlqyS_NGuxpNaaRqD25dzY3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX6bagq0GRrDT9
 iXe/zaH7zSZgg3VXgcXLi9/JaP2klwzE6BWr76GBLxRfsXmbqbvlbdlMpYS/cpQEOdEEXfuYG9Z
 kLw0Iox+H/8e52GawCQmxat5NUOTePM=
X-Authority-Analysis: v=2.4 cv=c62bhx9l c=1 sm=1 tr=0 ts=6a39e1d3 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=i_vXdmPKhaR3-41kbpgA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX0sPFhAI++n08
 sE5TJTgmIBKfykHSloLpq4nFGVdILbn0n+fV0T1qfv0TbOK7tOHJDm3+wG2BkbyUseFlvaoYmPs
 qOFiaNeQY/ae8fSwMklF69uNzVgqv7OgfbxDozg6veepbMlwMdL74A6MzEMthSptkrIu8T05yZV
 0J0XYKBJ+dB0qKR9BuIA7WdXhT6jjwMs971x2FNVdIlX6X78OK+qEeUNHG0YTn4yrceXxzMwjoy
 T3WGoGWCPEUAE5gV4bAiTfMkPy23m+20bh79Nczy9kyNIGcAZUXL+pQBIVGAEzGUtC0QnZd/8q4
 01HKDHHoWA728O3pdGkjymKjiE4SiQm5XWXDpZqgQtz/si2i4ljjNquUon0ia8XW6/5Yiq0psTC
 UZweX8hJoO0/QTFTjN67MRTdkUT+Lbd3CUHLe3fbUqFt0wMcwderV7OVXJI/BntBT06wwcce9W+
 1Gr5F33btOkjVIIwcqQ==
X-Proofpoint-ORIG-GUID: 32_ZTHBjjOlqyS_NGuxpNaaRqD25dzY3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 phishscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230008

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
index bff469d0b47d..18e8657abc44 100644
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
2.54.0

