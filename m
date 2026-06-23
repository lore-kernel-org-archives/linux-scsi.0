Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380B1391842;
	Tue, 23 Jun 2026 01:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178274; cv=none; b=pSUWEhnxr/uSs94jeWyBnF4rnaONjDjyHsdjMYBbswnXyWk8wgEW772oVvntATXHwTKk4XtnrF/wJJb71X3U5n/1SRoXxCiC+A6Mvh1nGBo3nFdeNSelQpStHwNvp/qLqHSH6mBMr/KO97M+Vv+JraP3UZqKkj3xAGDLHa3XpQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178274; c=relaxed/simple;
	bh=1TZHLP6tr2EBywbQY5hyeBGAMXai8v2siJwj4LePqe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpYdqA9A3DwXExhZGLNomHfd8dDbjPuoIY7rzug+yYVlTVaRvexI7umaKDdBPK+/2xyumx9omqgkRzH/bKVRYXbrxg61BPzz8Qg+gFMVaiOeNhUBp5KsYw3tM+2sE0X1UHz8ts8s2jvfpXLxC18+SehN1R7e/C6lckk/RGFjBiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dIOfSV8t; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dIOfSV8t"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0o30H285734;
	Tue, 23 Jun 2026 01:30:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=jj1dzoLpt+UOL2v1g
	sCTt2MMirqrKF3G1CjTwNrIf70=; b=dIOfSV8teW6LSFfJizYIo2PBDQCnyhVmP
	ZAdur7V3MZo4o+fQUZFn65fkWQfn+CT7xs4aMUF15wH8gvnSebNV1Lg08zpk381n
	MdD85bEDvHwGco3e4LY1w6xb8yPH8AJ5oOFJte4Em3Y7W+/iewc/VASEMdT7UOSL
	5jroIU5ifVnWkzGkh7QtVV7+zfBQ2hMebzhYUZaM/FUXjWkWOBTqWEQUJiYpH79s
	f54tAMPjouJmuO5IIHod4pu42ZN95hyUea6Z+nyEgER38eHo6SSURk4XV9UHLjGd
	auzNwMM69PaKWMnweOHJPDv/CiURlsSOqsugm8T+yILw9FYon1V9A==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjgskysb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:58 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1K2rN026922;
	Tue, 23 Jun 2026 01:30:58 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ex7dg0qws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:57 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1UvlP41746726
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:57 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 034F058052;
	Tue, 23 Jun 2026 01:30:57 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 652C75805A;
	Tue, 23 Jun 2026 01:30:56 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:56 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 26/29] ibmvfc: implement nvme-fc IO command submission callback
Date: Mon, 22 Jun 2026 18:30:32 -0700
Message-ID: <20260623013035.3436640-27-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX0hRWVyk4e0uu
 4dDWBk2IBZRCujyBfv0tLuaEc6klctY2PpsEIIRiIa4sTvmGaUMYYDFYO5sAtl+L4SWNg14qIZC
 WmaGHT6G5Bz1QyNiepWdD/sjUv8uagIm3zaBSfg5rirHg7jAIjXPYCpU4b8dSZ9VG0hszBfawDT
 5MwDqXiEjzgUnm+sXyrk8eyKeUWfTUm9zAVhfcyjaShYKUOWn+beTog7QWNlOsEKFoyxXtfWf/G
 n6UpnVBiSECyW+N23wsnv0wx3nXmFIec8IlyX7QgrHQJM+5Tq9umyaZxCaY/95blw8SpR1GQZPH
 cXSMRTERuHogM6rUvyGwNZh71lc82Quzpfa0qXDRVfuKxjJQNmZmX+MCjSldzm03cUiFYOicYpf
 /tzUFFlzm28zqkeVv17K/BRQvAVhjKbYZxU5FaAwm8JbcEYiPE7oDcPX9tZOZsQvpxr4ZRulIZq
 GcFaxaUJNZwSCT2k8mA==
X-Proofpoint-GUID: wNeRsj9amWO9cwnoRFyDsw79wlCTMchD
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX0qYYLLy91/pL
 BdRhz6vN5tHDV+3+1l0pXH59Bq/O0Q7cnuEFNS6lWUvXIGx+sh8VtxdarnvlGjkUJbCzvPbsfFW
 eyQJtkVoC0dhlb95IZN+dSNV8mOXEUE=
X-Authority-Analysis: v=2.4 cv=I/lVgtgg c=1 sm=1 tr=0 ts=6a39e1d2 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=m0QgfwBejkhnWor617sA:9
X-Proofpoint-ORIG-GUID: wNeRsj9amWO9cwnoRFyDsw79wlCTMchD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 impostorscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230008

Add helpers to initialize an ibmvfc command from an nvmefc_fcp_req,
map request scatterlists into either an inline descriptor or an external
DMA pool list, and submit the request on the selected NVMe hardware
queue. On completion, translate ibmvfc status into the NVMe-FC response
format, including transferred length and CQE handling for no-DMA
responses.

Also store the NVMe request pointer in struct ibmvfc_event so the
completion path can finish the original request.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c |   2 +-
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c | 140 +++++++++++++++++++++++++++-
 drivers/scsi/ibmvscsi/ibmvfc.h      |   1 +
 3 files changed, 141 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 177d341ce7bc..a7183493cf96 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1539,7 +1539,7 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 
 	login_info->ostype = cpu_to_be32(IBMVFC_OS_LINUX);
 	login_info->max_dma_len = cpu_to_be64(max_sectors << 9);
-	login_info->max_payload = cpu_to_be32(sizeof(struct ibmvfc_fcp_cmd_iu));
+	login_info->max_payload = cpu_to_be32(sizeof(struct nvme_fc_cmd_iu));
 	login_info->max_response = cpu_to_be32(sizeof(struct ibmvfc_fcp_rsp));
 	login_info->partition_num = cpu_to_be32(vhost->partition_number);
 	login_info->vfc_frame_version = cpu_to_be32(1);
diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
index 506135c1a34e..bff469d0b47d 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -8,6 +8,7 @@
  * Copyright (C) IBM Corporation, 2026
  */
 
+#include <linux/dmapool.h>
 #include <scsi/scsi_transport_fc.h>
 
 #include "ibmvfc-nvme.h"
@@ -164,12 +165,149 @@ static void ibmvfc_nvme_ls_abort(struct nvme_fc_local_port *lport,
 {
 }
 
+static void ibmvfc_nvme_done(struct ibmvfc_event *evt)
+{
+	struct ibmvfc_cmd *vfc_cmd = &evt->xfer_iu->cmd;
+	struct nvmefc_fcp_req *fcp_req = evt->fcp_req;
+	struct nvme_fc_ersp_iu *ersp = (struct nvme_fc_ersp_iu *)fcp_req->rspaddr;
+	struct nvme_completion *cqe = &ersp->cqe;
+	struct nvme_command *sqe = &((struct nvme_fc_cmd_iu *)fcp_req->cmdaddr)->sqe;
+
+	ibmvfc_dbg(evt->vhost, "fc_done: (%x:%x)\n", be16_to_cpu(vfc_cmd->status),
+		   be16_to_cpu(vfc_cmd->error));
+	ibmvfc_dbg(evt->vhost, "fc_done: cmdlen: %d, rsplen %d, payload_len %d\n",
+		   fcp_req->cmdlen, fcp_req->rsplen, fcp_req->payload_length);
+
+	fcp_req->status = 0;
+	if (!vfc_cmd->status) {
+		fcp_req->rcv_rsplen = NVME_FC_SIZEOF_ZEROS_RSP;
+		fcp_req->transferred_length = fcp_req->payload_length;
+	} else if (be16_to_cpu(vfc_cmd->status) & IBMVFC_FC_NVME_STATUS) {
+		fcp_req->rcv_rsplen = sizeof(struct nvme_fc_ersp_iu);
+		fcp_req->transferred_length = be32_to_cpu(ersp->xfrd_len);
+		if (be16_to_cpu(vfc_cmd->error) & IBMVFC_NVMS_VALID_NODMA_CQE)
+			cqe->command_id = sqe->common.command_id;
+	} else {
+		fcp_req->rcv_rsplen = 0;
+		fcp_req->transferred_length = 0;
+		fcp_req->status = NVME_SC_INTERNAL;
+	}
+
+	fcp_req->done(fcp_req);
+	ibmvfc_free_event(evt);
+}
+
+static struct ibmvfc_cmd *ibmvfc_nvme_init_vfc_cmd(struct ibmvfc_event *evt,
+						   struct nvme_fc_remote_port *rport,
+						   struct nvmefc_fcp_req *fcp_req)
+{
+	struct ibmvfc_target *tgt = rport->private;
+	struct ibmvfc_cmd *vfc_cmd = &evt->iu.cmd;
+
+	memset(vfc_cmd, 0, sizeof(*vfc_cmd));
+
+	vfc_cmd->resp.va = cpu_to_be64(fcp_req->rspdma);
+	vfc_cmd->resp.len = cpu_to_be32(fcp_req->rsplen);
+	vfc_cmd->frame_type = cpu_to_be32(IBMVFC_NVME_FCP_TYPE);
+	vfc_cmd->flags |= cpu_to_be16(IBMVFC_NVMEOF_PROTOCOL);
+	vfc_cmd->payload_len = cpu_to_be32(fcp_req->cmdlen);
+	vfc_cmd->resp_len = cpu_to_be32(fcp_req->rsplen);
+	vfc_cmd->cancel_key = cpu_to_be32((u64)evt);
+	vfc_cmd->target_wwpn = cpu_to_be64(rport->port_name);
+	vfc_cmd->tgt_scsi_id = cpu_to_be64(rport->port_id);
+	vfc_cmd->assoc_id = cpu_to_be64(tgt->assoc_id);
+
+	memcpy(&vfc_cmd->v3nvme.iu, fcp_req->cmdaddr, fcp_req->cmdlen);
+
+	return vfc_cmd;
+}
+
+static void ibmvfc_nvme_map_sg_list(struct nvmefc_fcp_req *fcp_req,
+				    struct srp_direct_buf *md)
+{
+	int i;
+	struct scatterlist *sg;
+
+	for_each_sg(fcp_req->first_sgl, sg, fcp_req->sg_cnt, i) {
+		md[i].va = cpu_to_be64(sg_dma_address(sg));
+		md[i].len = cpu_to_be32(sg_dma_len(sg));
+		md[i].key = 0;
+	}
+}
+
+static int ibmvfc_nvme_map_sg_data(struct nvmefc_fcp_req *fcp_req,
+				    struct ibmvfc_event *evt,
+				    struct ibmvfc_cmd *vfc_cmd)
+{
+	struct srp_direct_buf *data = &vfc_cmd->ioba;
+	struct ibmvfc_host *vhost = evt->vhost;
+
+	if (!fcp_req->sg_cnt) {
+		vfc_cmd->flags |= cpu_to_be16(IBMVFC_NO_MEM_DESC);
+		return 0;
+	}
+
+	if (fcp_req->io_dir == NVMEFC_FCP_WRITE)
+		vfc_cmd->flags |= cpu_to_be16(IBMVFC_WRITE);
+	else
+		vfc_cmd->flags |= cpu_to_be16(IBMVFC_READ);
+
+	if (fcp_req->sg_cnt == 1) {
+		ibmvfc_nvme_map_sg_list(fcp_req, data);
+		return 0;
+	}
+
+	vfc_cmd->flags |= cpu_to_be16(IBMVFC_SCATTERLIST);
+
+	if (!evt->ext_list) {
+		evt->ext_list = dma_pool_alloc(vhost->sg_pool, GFP_ATOMIC,
+					       &evt->ext_list_token);
+
+		if (!evt->ext_list)
+			return -ENOMEM;
+	}
+
+	ibmvfc_nvme_map_sg_list(fcp_req, evt->ext_list);
+
+	data->va = cpu_to_be64(evt->ext_list_token);
+	data->len = cpu_to_be32(fcp_req->sg_cnt * sizeof(struct srp_direct_buf));
+	data->key = 0;
+	return 0;
+}
+
 static int ibmvfc_nvme_fcp_io(struct nvme_fc_local_port *lport,
 			      struct nvme_fc_remote_port *rport,
 			      void *hw_queue_handle,
 			      struct nvmefc_fcp_req *fcp_req)
 {
-	return 0;
+	struct ibmvfc_host *vhost = lport->private;
+	struct ibmvfc_nvme_qhandle *qhandle = hw_queue_handle;
+	struct ibmvfc_cmd *vfc_cmd;
+	struct ibmvfc_event *evt;
+	int rc;
+
+	ibmvfc_dbg(vhost, "nvme_fcp_io\n");
+	evt = ibmvfc_get_event(qhandle->queue);
+	if (!evt)
+		return -EBUSY;
+
+	evt->hwq = qhandle->index;
+	ibmvfc_dbg(vhost, "vfc-nvme-mq-%d\n", evt->hwq);
+
+	ibmvfc_init_event(evt, ibmvfc_nvme_done, IBMVFC_CMD_FORMAT);
+	evt->fcp_req = fcp_req;
+	fcp_req->private = evt;
+
+	vfc_cmd = ibmvfc_nvme_init_vfc_cmd(evt, rport, fcp_req);
+
+	vfc_cmd->correlation = cpu_to_be64((u64)evt);
+
+	if (likely(!(rc = ibmvfc_nvme_map_sg_data(fcp_req, evt, vfc_cmd))))
+		return ibmvfc_send_event(evt, vhost, 0);
+
+	ibmvfc_free_event(evt);
+
+	return rc;
 }
 
 static void ibmvfc_nvme_fcp_abort(struct nvme_fc_local_port *lport,
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 9f6705e604fd..ca80ceffe53a 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -853,6 +853,7 @@ struct ibmvfc_event {
 	struct ibmvfc_target *tgt;
 	struct scsi_cmnd *cmnd;
 	struct nvmefc_ls_req *ls_req;
+	struct nvmefc_fcp_req *fcp_req;
 	atomic_t free;
 	atomic_t active;
 	union ibmvfc_iu *xfer_iu;
-- 
2.54.0

