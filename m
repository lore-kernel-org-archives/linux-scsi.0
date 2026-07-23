Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FB535E95A;
	Thu, 23 Jul 2026 00:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764943; cv=none; b=Dh4TsEgwGSgDMu8EW+7Tpk7t9vK3NWUhp+MVlR4f4Y7A0vMv0BG8UF0uPjE9YEA9XXf5fvsZoGTuw2zO5ktDo7VE+LT1eyGIWYn/WZCKDz1h/n6cMkKqlLzxCEZbxrs+nqErqShKFaNd4hzkC5WvBBI8TUJ15LcMvjmYNZG9fRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764943; c=relaxed/simple;
	bh=cZvBzWRwu6RVCObl6kSOriIWMVHJW1LyYNvbQUq6hr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAgv7RkJcoPwd+AvZg5hMqxs5yAC1EobLsoNnNNuE4dCeijAOr3m75K7FOvar/5rwbhhigKkmQENazIDRfjQLBOBjyfPfUbiSODPss3UCbKLLrDXruOsFLexKdeFsvDv38UTZWa7KjyLt/7rVcv+fmkiUQ3MLS2eePkiAjBWpkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rCgbrP0S; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rCgbrP0S"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIBnqn704737;
	Thu, 23 Jul 2026 00:02:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=2JuQbKzsDYCpK4SmN
	ldH6JnL9Rd7p65GzDLrst72JuU=; b=rCgbrP0SaMmvovpE6O0ePauX2HkNnqP7F
	M2vDVZF5vIo+ieZNsBlTW3S6j8VbB11jtSNNppzv57rZZuw+96b+0qiv0wtbDuta
	18JUQBD6JaQDzrEzw72odVZXr79mYaGOJo7ZqZqHJc8pFKNSamowqZiUl3u4dC0O
	jOW5ymW4kW1Euo/F+7sRBZnXZerePXDSJKP6KJ/40bpjn0TLicSaT5BBgzHkIq3e
	PhUwnwPOP0PV3JIKZMJkNmuUhpbW3Is6Ug3NIr/aagA83dY0E1JKgFiFc9/4liWC
	yU9twEQn3UQx0k0nIJ4XomXwgxwcNAHgSdk2cMqT7vR5Nty5kfxWw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7abmyny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:16 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNnj26026459;
	Thu, 23 Jul 2026 00:02:16 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgktq9x38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:16 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N02FEW29884940
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:02:15 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3017E5803F;
	Thu, 23 Jul 2026 00:02:15 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9001D58063;
	Thu, 23 Jul 2026 00:02:14 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:02:14 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 29/33] ibmvfc: implement nvme-fc LS submission transport callback
Date: Wed, 22 Jul 2026 17:01:45 -0700
Message-ID: <20260723000149.969416-30-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX9sG+M1Ds5iPM
 JwFelVJrls7+Zw/z50zniJAzEnE8b3jC6MeTGY/EtdSuzp8P5xc2IXvs7YqR6QnydrkSsAg8eBe
 wFXTRbdZeCZNXcjkpXcWc/fDxBt4y5pLn8wpYHLIBkx2L17CMXNT+X9rVDrx1xaAT1kLfcFUmGG
 xIDiO3kQiP+PeksoVqh47vg14CcbwFwIA/2gGw3gsuVk4UiHuxqnOjjQI7DlfRX0hM05Nr5baKd
 8LHJcKpoUfbiVFNBdDKQc2cE85aVjBd8+5oONNh3WreOmRsmoQuUgqcgBBVQWueTkI6VF/8Rwd9
 fw5d2V57ixT1812sA68Lj2Nhy+QDgDHXZExFLtWlWLxR4NbzyLiCZCM8qOe1NhAATxkgPHxu7Ho
 WEq9BInJUNX7huMZ2X0qT/0mS4Y0UxEygfoiEZm4X+DbzgxOGo/tLRx72OBGc388Ly1eBy+i7Vd
 qDAqwm08FNti7qALXcw==
X-Authority-Analysis: v=2.4 cv=F7ZnsKhN c=1 sm=1 tr=0 ts=6a615a09 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=IdS6GuFC8RQCFmc2Bu0A:9
X-Proofpoint-ORIG-GUID: nn720i-CnKSKmrqcigoovqmix4OAJGyG
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX4YmwP+qr058F
 qErGcu5vv8Dr5A2LqgmR0LAiuwMn+BJRQWgB81/QUWHd8HiR7W/3OqTHSUxiSIUrQeI399Xpsg7
 6sIOafspOirpzfNf5bvwZzV7aCfTnPA=
X-Proofpoint-GUID: nn720i-CnKSKmrqcigoovqmix4OAJGyG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220234

NVMe FC Link Service commands are required to use the ibmvfc_passthru
MAD. Initialize a pssthru mad for the target port including the DMA
addresses for the FC4_LS request and response as well as the max length
of each IU as provided in the nvmefc_ls_req struct. FC4_LS commands are
sent via the primary CRQ. Further, store the assoc_id during a create
association request as this is a required field in our vfc_cmd struct
for nvme_fcp_io commands.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c |  1 +
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c | 89 +++++++++++++++++++++++++++++
 drivers/scsi/ibmvscsi/ibmvfc-nvme.h |  8 +++
 drivers/scsi/ibmvscsi/ibmvfc.h      |  2 +
 4 files changed, 100 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 206cc9508dda..45c7bcf69201 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1633,6 +1633,7 @@ void ibmvfc_init_event(struct ibmvfc_event *evt,
 			      void (*done) (struct ibmvfc_event *), u8 format)
 {
 	evt->cmnd = NULL;
+	evt->ls_req = NULL;
 	evt->sync_iu = NULL;
 	evt->eh_comp = NULL;
 	evt->crq.format = format;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
index ecf9f4c0549c..cf72f0682297 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -62,10 +62,99 @@ static void ibmvfc_nvme_delete_queue(struct nvme_fc_local_port *lport, unsigned
 	kfree(handle);
 }
 
+static void ibmvfc_ls_req_done(struct ibmvfc_event *evt)
+{
+	struct ibmvfc_target *tgt = evt->tgt;
+	struct ibmvfc_passthru_mad *mad = &evt->xfer_iu->passthru;
+	struct fcnvme_ls_rqst_w0 *ls_rqst;
+	struct fcnvme_ls_cr_assoc_acc *ls_resp;
+	u32 status = be16_to_cpu(mad->common.status);
+	int rc = 0;
+
+	ls_rqst = (struct fcnvme_ls_rqst_w0 *)evt->ls_req->rqstaddr;
+	ls_resp = (struct fcnvme_ls_cr_assoc_acc *)evt->ls_req->rspaddr;
+
+	switch (status) {
+	case IBMVFC_MAD_SUCCESS:
+		tgt_dbg(tgt, "ls_req succeeded\n");
+		if ((ls_rqst->ls_cmd == FCNVME_LS_CREATE_ASSOCIATION) &&
+		    (ls_resp->hdr.w0.ls_cmd == FCNVME_LS_ACC)) {
+			tgt->assoc_id = be64_to_cpu(ls_resp->associd.association_id);
+			tgt_dbg(tgt, "assoc_id 0x%llx\n", tgt->assoc_id);
+		}
+		break;
+	case IBMVFC_MAD_DRIVER_FAILED:
+		break;
+	case IBMVFC_MAD_FAILED:
+	default:
+		tgt_info(tgt, "ls_req failed: %s (%x:%x) rc=0x%02X\n",
+			 ibmvfc_get_cmd_error(be16_to_cpu(mad->iu.status), be16_to_cpu(mad->iu.error)),
+			 be16_to_cpu(mad->iu.status), be16_to_cpu(mad->iu.error), status);
+		break;
+	}
+
+	if (status)
+		rc = -EIO;
+
+	evt->ls_req->done(evt->ls_req, rc);
+
+	kref_put(&tgt->kref, ibmvfc_release_tgt);
+	ibmvfc_free_event(evt);
+}
+
+static void ibmvfc_init_ls_req(struct ibmvfc_event *evt, struct nvmefc_ls_req *ls_req)
+{
+	struct ibmvfc_passthru_mad *mad = &evt->iu.passthru;
+
+	memset(mad, 0, sizeof(*mad));
+	mad->common.version = cpu_to_be32(2);
+	mad->common.opcode = cpu_to_be32(IBMVFC_NVMF_PASSTHRU);
+	mad->common.length = cpu_to_be16(sizeof(*mad) - sizeof(mad->fc_iu) - sizeof(mad->iu));
+	mad->cmd_ioba.va = cpu_to_be64((u64)be64_to_cpu(evt->crq.ioba) +
+				       offsetof(struct ibmvfc_passthru_mad, iu));
+	mad->cmd_ioba.len = cpu_to_be32(sizeof(mad->iu));
+	mad->iu.cmd_len = cpu_to_be32(ls_req->rqstlen);
+	mad->iu.rsp_len = cpu_to_be32(ls_req->rsplen);
+	mad->iu.cmd.va = cpu_to_be64(ls_req->rqstdma);
+	mad->iu.cmd.len = cpu_to_be32(ls_req->rqstlen);
+	mad->iu.rsp.va = cpu_to_be64(ls_req->rspdma);
+	mad->iu.rsp.len = cpu_to_be32(ls_req->rsplen);
+}
+
 static int ibmvfc_nvme_ls_req(struct nvme_fc_local_port *lport,
 			      struct nvme_fc_remote_port *rport,
 			      struct nvmefc_ls_req *ls_req)
 {
+	struct ibmvfc_host *vhost = lport->private;
+	struct ibmvfc_target *tgt = rport->private;
+	struct ibmvfc_passthru_mad *mad;
+	struct ibmvfc_event *evt;
+
+	kref_get(&tgt->kref);
+	evt = ibmvfc_get_event(&vhost->crq);
+	if (!evt) {
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
+		return -EBUSY;
+	}
+
+	ibmvfc_init_event(evt, ibmvfc_ls_req_done, IBMVFC_MAD_FORMAT);
+	evt->tgt = tgt;
+	evt->ls_req = ls_req;
+	ls_req->private = evt;
+
+	ibmvfc_init_ls_req(evt, ls_req);
+	mad = &evt->iu.passthru;
+	mad->iu.flags = cpu_to_be32(IBMVFC_FC4_LS_DSC_CTRL);
+	mad->iu.scsi_id = cpu_to_be64(tgt->scsi_id);
+	mad->iu.cancel_key = cpu_to_be32((u64)evt);
+	mad->iu.target_wwpn = cpu_to_be64(tgt->wwpn);
+
+	ibmvfc_dbg(vhost, "nvme_ls_req\n");
+	if (ibmvfc_send_event(evt, vhost, IBMVFC_FC4_LS_PLUS_CANCEL_TIMEOUT)) {
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
+		return -ENXIO;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.h b/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
index 4c6146048a6f..e245b6ed0875 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
@@ -14,6 +14,8 @@
 #include <scsi/fc/fc_fs.h>
 #include <scsi/fc/fc_els.h>
 #include <linux/nvme-fc-driver.h>
+#include <linux/nvme.h>
+#include <linux/nvme-fc.h>
 
 #include "ibmvfc.h"
 
@@ -22,10 +24,16 @@
 #define IBMVFC_MAX_NVME_QUEUES	16
 #define IBMVFC_NVME_CHANNELS	8
 
+#define IBMVFC_FC4_LS_TIMEOUT	15
+#define IBMVFC_FC4_LS_CANCEL_TIMEOUT	45
+#define IBMVFC_FC4_LS_PLUS_CANCEL_TIMEOUT	\
+	(IBMVFC_FC4_LS_TIMEOUT + IBMVFC_FC4_LS_CANCEL_TIMEOUT)
+
 extern unsigned int ibmvfc_debug;
 
 struct ibmvfc_host;
 struct ibmvfc_target;
+struct ibmvfc_queue;
 
 struct ibmvfc_nvme_qhandle {
 	unsigned int qidx;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index ece1f379c269..9f6705e604fd 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -824,6 +824,7 @@ struct ibmvfc_target {
 	u64 scsi_id;
 	u64 wwpn;
 	u64 new_scsi_id;
+	u64 assoc_id;
 	struct fc_rport *rport;
 	int target_id;
 	enum ibmvfc_target_action action;
@@ -851,6 +852,7 @@ struct ibmvfc_event {
 	struct ibmvfc_queue *queue;
 	struct ibmvfc_target *tgt;
 	struct scsi_cmnd *cmnd;
+	struct nvmefc_ls_req *ls_req;
 	atomic_t free;
 	atomic_t active;
 	union ibmvfc_iu *xfer_iu;
-- 
2.55.0

