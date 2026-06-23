Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25168388397;
	Tue, 23 Jun 2026 01:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178262; cv=none; b=Nu+Q6qZ/RlnHmJKeMd9QjdspBv2fTx7+rA0Qpt1qmL6CklksZKEhfJK0PV5vMRw9OwcKTKLqjBtymDaf97TfJMr2aDRzmQPdlttGF0Yi69BriytDXm2G6ZgDFYY2T1x3Y9460saXNYEhwSh1fqsfxIzoMqCZh3G9WFJ4pRL37gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178262; c=relaxed/simple;
	bh=PiywdQ46Ch2ng6d0TsdTRDyUv5PMSyXb3vOHtSHz1TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6MThBUbg+egDPb4XbnjsYmFtfu8LywFnz29nflGiBbm02Pt+4sHTXL3q9t9xVrvu2rKm+rstZixoPWdjhDkpk4Uw7IqnhKDoXcGpoaCJ8u9PMJ1ZClx8GCffeZTpPug35NfPxMo6NXbDHYp09b86Gd2V3pMI3+a+oPr6CxQWEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Xy2I5xSK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Xy2I5xSK"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0mQN8550807;
	Tue, 23 Jun 2026 01:30:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=yOjIreacqhESTBzOH
	alaCyPaJ2XVpl3P33nMfqnqG6Q=; b=Xy2I5xSKINXkWTSyDnsNcoxA1qBEkizIQ
	EAMYQg5SQra51m7cM1rfx0An7dU1ptl5FFuO+ogo+Or/YMo3M5m/yCXd3JYLuKxk
	1IdLFZujBOR2jAlC+FVLytDtnurJs71L2VN4JGeZVQ6gF5SWeEzuhMwKkvpt6iIy
	SiDo5bex8LhFusYT0CYW2+ZCr7WyPdntsJce9a2BsHz3BSWmxQJnqvJvgS5zusVm
	w0wx2Fc/HInG4AfXEEtXwRtOVOiV2XErwTT3ySIY992F8lLTn3atgz/c/M8dzUq1
	yFhs2d7qO+35I0XgVkmaXohVj6fXPeF5BEy7SspjoFyxTxxa1IE6g==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjhqm1rw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:44 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1Jje9026315;
	Tue, 23 Jun 2026 01:30:43 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ex7dg0qvt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:43 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1UgnI47972812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:42 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9673758052;
	Tue, 23 Jun 2026 01:30:42 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F280A5805E;
	Tue, 23 Jun 2026 01:30:41 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:41 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 06/29] ibmvfc: add logic for protocol specific fabric logins
Date: Mon, 22 Jun 2026 18:30:12 -0700
Message-ID: <20260623013035.3436640-7-tyreld@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=I4VVgtgg c=1 sm=1 tr=0 ts=6a39e1c4 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=FovE9xXL7NGL95JtJZEA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX/H1Ug63ZXXCM
 gL3nHbCrn9kXiHcM0NCoi0yF9/EpEXxshXXwWxjLtyNEUDWO+p8I22YYZxSkVONN3U/8AsmMIzl
 ndjBdea0XUV6aUeJ1Ksvr/C57avre8/DTGsiSBlXxbUYBX8cliLuOJIG4nn7OAD9SlrQjxM68lZ
 ZUOK2dYJOptHB+NI9AZ4L7W0T8F7wvo0rpYsScvgE/BrxhIbcWNRtR8zAZOjCBgJD9IDnW17q+s
 I6fGFxo0KprL6PH6dNCd6p4zk1V99PZVf7teidzG2Iwi3dDKiF0IH1mIn+/bNuXtmC2IzJRFrYB
 r4Jdy/4tBR2QuEFdffAsWWGSKXvk8wraPtJKbNrNndeARiynURRa1dCC62wprWjnEMgfjk5R+5v
 WrvF+wGL8SaL0dnQEtoMTXu9nFspWjAFLr2aQGk8Ck5HWKvipC+dzBc8OMla+mIJOVzoZ7h6AT0
 3DWBcJeeaLhXJJDoUOQ==
X-Proofpoint-GUID: nDQnwW8r6gB2PKhq47E5KDByNiMqjbmw
X-Proofpoint-ORIG-GUID: nDQnwW8r6gB2PKhq47E5KDByNiMqjbmw
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX8Gch1GVvPoap
 ptw5IHJoan2AKdUlOoLzPR3Vuonl8Jd4OSkxPGfA49sXbLJsOp5ukMUN2NXNNBS9OrYWzDqvT3Z
 S3i/h5laJzp0JxlgVuj2oaGpZ7vSJ1Y=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606230008

Add support for the protocol-specific fabric login flow introduced by
the updated client/VIOS interface.

After NPIV login, a VIOS that advertises protocol-specific support
requires separate fabric login MADs for SCSI and NVMe/FC. Track whether
SCSI and NVMe/FC fabric login are needed, extend channel enquiry/setup
handling to negotiate both SCSI and NVMe queue counts, and issue the
appropriate fabric login MADs before target discovery begins.

Also update command layout selection so the driver uses the v3 command
format when the VIOS advertises NVMe/FC-capable framing.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 230 ++++++++++++++++++++++++----
 drivers/scsi/ibmvscsi/ibmvfc.h      |  11 +-
 2 files changed, 206 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 6f5e8b3cbfc8..93c32fa162f8 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -210,7 +210,9 @@ static int ibmvfc_check_caps(struct ibmvfc_host *vhost, unsigned long cap_flags)
 static struct ibmvfc_fcp_cmd_iu *ibmvfc_get_fcp_iu(struct ibmvfc_host *vhost,
 						   struct ibmvfc_cmd *vfc_cmd)
 {
-	if (ibmvfc_check_caps(vhost, IBMVFC_HANDLE_VF_WWPN))
+	if (ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NVMEOF))
+		return &vfc_cmd->v3scsi.iu;
+	else if (ibmvfc_check_caps(vhost, IBMVFC_HANDLE_VF_WWPN))
 		return &vfc_cmd->v2.iu;
 	else
 		return &vfc_cmd->v1.iu;
@@ -219,7 +221,9 @@ static struct ibmvfc_fcp_cmd_iu *ibmvfc_get_fcp_iu(struct ibmvfc_host *vhost,
 static struct ibmvfc_fcp_rsp *ibmvfc_get_fcp_rsp(struct ibmvfc_host *vhost,
 						 struct ibmvfc_cmd *vfc_cmd)
 {
-	if (ibmvfc_check_caps(vhost, IBMVFC_HANDLE_VF_WWPN))
+	if (ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NVMEOF))
+		return &vfc_cmd->v3scsi.rsp;
+	else if (ibmvfc_check_caps(vhost, IBMVFC_HANDLE_VF_WWPN))
 		return &vfc_cmd->v2.rsp;
 	else
 		return &vfc_cmd->v1.rsp;
@@ -961,6 +965,8 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	spin_lock(vhost->crq.q_lock);
 	vhost->do_enquiry = 1;
 	vhost->using_channels = 0;
+	vhost->do_scsi_login = 0;
+	vhost->do_nvme_login = 0;
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
@@ -1000,6 +1006,8 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	vhost->logged_in = 0;
 	vhost->do_enquiry = 1;
 	vhost->using_channels = 0;
+	vhost->do_scsi_login = 0;
+	vhost->do_nvme_login = 0;
 
 	/* Clean out the queue */
 	memset(crq->msgs.crq, 0, PAGE_SIZE);
@@ -1512,7 +1520,7 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 	max_cmds = scsi_qdepth + IBMVFC_NUM_INTERNAL_REQ;
 	if (mq_enabled)
 		max_cmds += (scsi_qdepth + IBMVFC_NUM_INTERNAL_SUBQ_REQ) *
-			vhost->scsi_scrqs.desired_queues;
+			(vhost->scsi_scrqs.desired_queues + vhost->nvme_scrqs.desired_queues);
 
 	memset(login_info, 0, sizeof(*login_info));
 
@@ -1530,8 +1538,14 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 	login_info->max_cmds = cpu_to_be32(max_cmds);
 	login_info->capabilities = cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN);
 
-	if (vhost->mq_enabled || vhost->using_channels)
+	if (vhost->mq_enabled || vhost->using_channels) {
 		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
+		if (vhost->nvme_enabled) {
+			login_info->capabilities |= cpu_to_be64(IBMVFC_YES_NVMEOF);
+			login_info->capabilities |= cpu_to_be64(IBMVFC_YES_SCSI);
+			login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_WWPN_ALL);
+		}
+	}
 
 	login_info->async.va = cpu_to_be64(vhost->async_crq.msg_token);
 	login_info->async.len = cpu_to_be32(async_crq->size *
@@ -1954,11 +1968,13 @@ static struct ibmvfc_cmd *ibmvfc_init_vfc_cmd(struct ibmvfc_event *evt, struct s
 	size_t offset;
 
 	memset(vfc_cmd, 0, sizeof(*vfc_cmd));
-	if (ibmvfc_check_caps(vhost, IBMVFC_HANDLE_VF_WWPN)) {
+	if (ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NVMEOF))
+		offset = offsetof(struct ibmvfc_cmd, v3scsi.rsp);
+	else if (ibmvfc_check_caps(vhost, IBMVFC_HANDLE_VF_WWPN))
 		offset = offsetof(struct ibmvfc_cmd, v2.rsp);
-		vfc_cmd->target_wwpn = cpu_to_be64(rport->port_name);
-	} else
+	else
 		offset = offsetof(struct ibmvfc_cmd, v1.rsp);
+	vfc_cmd->target_wwpn = cpu_to_be64(rport->port_name);
 	vfc_cmd->resp.va = cpu_to_be64(be64_to_cpu(evt->crq.ioba) + offset);
 	vfc_cmd->resp.len = cpu_to_be32(sizeof(*rsp));
 	vfc_cmd->frame_type = cpu_to_be32(IBMVFC_SCSI_FCP_TYPE);
@@ -5042,14 +5058,141 @@ static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
 		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
 }
 
+static void ibmvfc_fabric_login_nvme_done(struct ibmvfc_event *evt)
+{
+	struct ibmvfc_host *vhost = evt->vhost;
+	struct ibmvfc_fabric_login_mad *rsp = &evt->xfer_iu->fabric_login;
+	u32 mad_status = be16_to_cpu(rsp->common.status);
+	int level = IBMVFC_DEFAULT_LOG_LEVEL;
+
+	switch (mad_status) {
+	case IBMVFC_MAD_SUCCESS:
+		ibmvfc_dbg(vhost, "NVMe fabric login succeeded\n");
+		break;
+	case IBMVFC_MAD_FAILED:
+		if (ibmvfc_retry_cmd(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)))
+			level += ibmvfc_retry_host_init(vhost);
+		else
+			ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
+		ibmvfc_log(vhost, level, "NVMe fabric login failed: %s (%x:%x)\n",
+			   ibmvfc_get_cmd_error(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)),
+			   be16_to_cpu(rsp->status), be16_to_cpu(rsp->error));
+		ibmvfc_free_event(evt);
+		return;
+	case IBMVFC_MAD_DRIVER_FAILED:
+		ibmvfc_free_event(evt);
+		return;
+	default:
+		dev_err(vhost->dev, "Invalid NVMe fabric login response: 0x%x\n", mad_status);
+		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
+		break;
+	}
+
+	ibmvfc_free_event(evt);
+
+	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
+	wake_up(&vhost->work_wait_q);
+}
+
+static void ibmvfc_fabric_login_nvme(struct ibmvfc_host *vhost)
+{
+	struct ibmvfc_fabric_login_mad *mad;
+	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
+
+	if (!evt) {
+		ibmvfc_retry_host_init(vhost);
+		return;
+	}
+
+	ibmvfc_init_event(evt, ibmvfc_fabric_login_nvme_done, IBMVFC_MAD_FORMAT);
+	mad = &evt->iu.fabric_login;
+	memset(mad, 0, sizeof(*mad));
+	mad->common.version = cpu_to_be32(1);
+	mad->common.opcode = cpu_to_be32(IBMVFC_NVMF_FABRIC_LOGIN);
+	mad->common.length = cpu_to_be16(sizeof(*mad));
+
+	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT_WAIT);
+
+	if (!ibmvfc_send_event(evt, vhost, default_timeout))
+		ibmvfc_dbg(vhost, "Send NVMe fabric login\n");
+	else
+		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
+}
+
+static void ibmvfc_fabric_login_scsi_done(struct ibmvfc_event *evt)
+{
+	struct ibmvfc_host *vhost = evt->vhost;
+	struct ibmvfc_fabric_login_mad *rsp = &evt->xfer_iu->fabric_login;
+	u32 mad_status = be16_to_cpu(rsp->common.status);
+	int level = IBMVFC_DEFAULT_LOG_LEVEL;
+
+	switch (mad_status) {
+	case IBMVFC_MAD_SUCCESS:
+		ibmvfc_dbg(vhost, "SCSI fabric login succeeded\n");
+		break;
+	case IBMVFC_MAD_FAILED:
+		if (ibmvfc_retry_cmd(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)))
+			level += ibmvfc_retry_host_init(vhost);
+		else
+			ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
+		ibmvfc_log(vhost, level, "SCSI fabric login failed: %s (%x:%x)\n",
+			   ibmvfc_get_cmd_error(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)),
+			   be16_to_cpu(rsp->status), be16_to_cpu(rsp->error));
+		ibmvfc_free_event(evt);
+		return;
+	case IBMVFC_MAD_DRIVER_FAILED:
+		ibmvfc_free_event(evt);
+		return;
+	default:
+		dev_err(vhost->dev, "Invalid SCSI fabric login response: 0x%x\n", mad_status);
+		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
+		break;
+	}
+
+	ibmvfc_free_event(evt);
+
+	if (vhost->do_nvme_login) {
+		ibmvfc_fabric_login_nvme(vhost);
+	} else {
+		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
+		wake_up(&vhost->work_wait_q);
+	}
+}
+
+static void ibmvfc_fabric_login_scsi(struct ibmvfc_host *vhost)
+{
+	struct ibmvfc_fabric_login_mad *mad;
+	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
+
+	if (!evt) {
+		ibmvfc_retry_host_init(vhost);
+		return;
+	}
+
+	ibmvfc_init_event(evt, ibmvfc_fabric_login_scsi_done, IBMVFC_MAD_FORMAT);
+	mad = &evt->iu.fabric_login;
+	memset(mad, 0, sizeof(*mad));
+	mad->common.version = cpu_to_be32(1);
+	mad->common.opcode = cpu_to_be32(IBMVFC_FABRIC_LOGIN);
+	mad->common.length = cpu_to_be16(sizeof(*mad));
+
+	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT_WAIT);
+
+	if (!ibmvfc_send_event(evt, vhost, default_timeout))
+		ibmvfc_dbg(vhost, "Send SCSI fabric login\n");
+	else
+		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
+}
+
 static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 {
 	struct ibmvfc_host *vhost = evt->vhost;
 	struct ibmvfc_channel_setup *setup = vhost->channel_setup_buf;
-	struct ibmvfc_channels *scrqs = &vhost->scsi_scrqs;
+	struct ibmvfc_channels *scsi = &vhost->scsi_scrqs;
+	struct ibmvfc_channels *nvme = &vhost->nvme_scrqs;
 	u32 mad_status = be16_to_cpu(evt->xfer_iu->channel_setup.common.status);
 	int level = IBMVFC_DEFAULT_LOG_LEVEL;
-	int flags, active_queues, i;
+	int flags, i;
 
 	ibmvfc_free_event(evt);
 
@@ -5058,22 +5201,28 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 		ibmvfc_dbg(vhost, "Channel Setup succeeded\n");
 		flags = be32_to_cpu(setup->flags);
 		vhost->do_enquiry = 0;
-		active_queues = be32_to_cpu(setup->num_scsi_subq_channels);
-		scrqs->active_queues = active_queues;
+		scsi->active_queues = be32_to_cpu(setup->num_scsi_subq_channels);
+		nvme->active_queues = be32_to_cpu(setup->num_nvme_subq_channels);
 
 		if (flags & IBMVFC_CHANNELS_CANCELED) {
 			ibmvfc_dbg(vhost, "Channels Canceled\n");
 			vhost->using_channels = 0;
-		} else {
-			if (active_queues)
-				vhost->using_channels = 1;
-			for (i = 0; i < active_queues; i++)
-				scrqs->scrqs[i].vios_cookie =
-					be64_to_cpu(setup->channel_handles[i]);
-
-			ibmvfc_dbg(vhost, "Using %u channels\n",
-				   vhost->scsi_scrqs.active_queues);
+			break;
 		}
+
+		if (scsi->active_queues || nvme->active_queues)
+			vhost->using_channels = 1;
+		for (i = 0; i < scsi->active_queues; i++)
+			scsi->scrqs[i].vios_cookie =
+				be64_to_cpu(setup->channel_handles[i]);
+		for (i = 0; i < nvme->active_queues; i++)
+			nvme->scrqs[i].vios_cookie =
+				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
+
+		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",
+			   scsi->active_queues);
+		ibmvfc_dbg(vhost, "Using %u NVMe channels\n",
+			   nvme->active_queues);
 		break;
 	case IBMVFC_MAD_FAILED:
 		level += ibmvfc_retry_host_init(vhost);
@@ -5088,8 +5237,12 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 		return;
 	}
 
-	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
-	wake_up(&vhost->work_wait_q);
+	if (vhost->do_scsi_login) {
+		ibmvfc_fabric_login_scsi(vhost);
+	} else {
+		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
+		wake_up(&vhost->work_wait_q);
+	}
 }
 
 static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
@@ -5097,9 +5250,12 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 	struct ibmvfc_channel_setup_mad *mad;
 	struct ibmvfc_channel_setup *setup_buf = vhost->channel_setup_buf;
 	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
-	struct ibmvfc_channels *scrqs = &vhost->scsi_scrqs;
-	unsigned int num_channels =
-		min(scrqs->desired_queues, vhost->max_vios_scsi_channels);
+	struct ibmvfc_channels *scsi = &vhost->scsi_scrqs;
+	struct ibmvfc_channels *nvme = &vhost->nvme_scrqs;
+	unsigned int scsi_channels =
+		min(scsi->desired_queues, vhost->max_vios_scsi_channels);
+	unsigned int nvme_channels =
+		min(nvme->desired_queues, vhost->max_vios_nvme_channels);
 	int level = IBMVFC_DEFAULT_LOG_LEVEL;
 	int i;
 
@@ -5110,12 +5266,17 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 	}
 
 	memset(setup_buf, 0, sizeof(*setup_buf));
-	if (num_channels == 0)
+	if (!scsi_channels && !nvme_channels)
 		setup_buf->flags = cpu_to_be32(IBMVFC_CANCEL_CHANNELS);
 	else {
-		setup_buf->num_scsi_subq_channels = cpu_to_be32(num_channels);
-		for (i = 0; i < num_channels; i++)
-			setup_buf->channel_handles[i] = cpu_to_be64(scrqs->scrqs[i].cookie);
+		setup_buf->num_scsi_subq_channels = cpu_to_be32(scsi_channels);
+		setup_buf->num_nvme_subq_channels = cpu_to_be32(nvme_channels);
+		for (i = 0; i < scsi_channels; i++)
+			setup_buf->channel_handles[i] =
+				cpu_to_be64(scsi->scrqs[i].cookie);
+		for (i = 0; i < nvme_channels; i++)
+			setup_buf->channel_handles[scsi_channels + i] =
+				cpu_to_be64(nvme->scrqs[i].cookie);
 	}
 
 	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
@@ -5146,6 +5307,7 @@ static void ibmvfc_channel_enquiry_done(struct ibmvfc_event *evt)
 	case IBMVFC_MAD_SUCCESS:
 		ibmvfc_dbg(vhost, "Channel Enquiry succeeded\n");
 		vhost->max_vios_scsi_channels = be32_to_cpu(rsp->num_scsi_subq_channels);
+		vhost->max_vios_nvme_channels = be32_to_cpu(rsp->num_nvme_subq_channels);
 		ibmvfc_free_event(evt);
 		break;
 	case IBMVFC_MAD_FAILED:
@@ -5280,8 +5442,14 @@ static void ibmvfc_npiv_login_done(struct ibmvfc_event *evt)
 	vhost->host->can_queue = be32_to_cpu(rsp->max_cmds) - IBMVFC_NUM_INTERNAL_REQ;
 	vhost->host->max_sectors = npiv_max_sectors;
 
-	if (ibmvfc_check_caps(vhost, IBMVFC_CAN_SUPPORT_CHANNELS) && vhost->do_enquiry) {
-		ibmvfc_channel_enquiry(vhost);
+
+	if (ibmvfc_check_caps(vhost, IBMVFC_CAN_SUPPORT_CHANNELS)) {
+		if (ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_SCSI))
+			vhost->do_scsi_login = 1;
+		if (ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NVMEOF))
+			vhost->do_nvme_login = 1;
+		if (vhost->do_enquiry)
+			ibmvfc_channel_enquiry(vhost);
 	} else {
 		vhost->do_enquiry = 0;
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 01c49d81b135..454968de925b 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -617,9 +617,9 @@ struct ibmvfc_channel_enquiry {
 #define IBMVFC_SUPPORT_VARIABLE_SUBQ_MSG	0x02
 #define IBMVFC_NO_N_TO_M_CHANNELS_SUPPORT	0x04
 	__be32 num_scsi_subq_channels;
-	__be32 num_nvmeof_subq_channels;
+	__be32 num_nvme_subq_channels;
 	__be32 num_scsi_vas_channels;
-	__be32 num_nvmeof_vas_channels;
+	__be32 num_nvme_vas_channels;
 } __packed __aligned(8);
 
 struct ibmvfc_channel_setup_mad {
@@ -636,9 +636,9 @@ struct ibmvfc_channel_setup {
 #define IBMVFC_CHANNELS_CANCELED	0x04
 	__be32 reserved;
 	__be32 num_scsi_subq_channels;
-	__be32 num_nvmeof_subq_channels;
+	__be32 num_nvme_subq_channels;
 	__be32 num_scsi_vas_channels;
-	__be32 num_nvmeof_vas_channels;
+	__be32 num_nvme_vas_channels;
 	struct srp_direct_buf buffer;
 	__be64 reserved2[5];
 	__be64 channel_handles[IBMVFC_MAX_CHANNELS];
@@ -979,6 +979,7 @@ struct ibmvfc_host {
 	int log_level;
 	struct mutex passthru_mutex;
 	unsigned int max_vios_scsi_channels;
+	unsigned int max_vios_nvme_channels;
 	int task_set;
 	int init_retries;
 	int discovery_threads;
@@ -991,6 +992,8 @@ struct ibmvfc_host {
 	unsigned int using_channels:1;
 	unsigned int do_enquiry:1;
 	unsigned int nvme_enabled:1;
+	unsigned int do_scsi_login:1;
+	unsigned int do_nvme_login:1;
 	unsigned int aborting_passthru:1;
 	unsigned int scan_complete:1;
 	int scan_timeout;
-- 
2.54.0

