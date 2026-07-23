Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9CE35957;
	Thu, 23 Jul 2026 00:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764946; cv=none; b=Pogy6TBw0cZfJtLZM985boN0UUsYtY9BN7ZvVqMrlZnX/Ov/tceoWZ9HPuDRrEHRnINbuIUWIPox1coWnec94MICjNYJozYJFcC8BNvXUcYOi3Dp6VND2BU8YiX3Ev5HxrngxGIfHDekhAfKW0ytXq4IwP9ToOfcptqilhSdito=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764946; c=relaxed/simple;
	bh=yic6PIDmBhqORlP50GHs4yLLGk9Jk3P1wDFGjWjskiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUv4bszd9KVlbmZDTncqF2v89FhQjRJVNag6yg02PX+3xZHZTFsqM1Bs/fZgPz/Xufs9zbNxEFlIIRB3n3Ag1cS+Cda0i13141RYjWzOJZScCi5STAVUDWwY6BF1FQRFt7IxVVQaxLnoO/hZ4WB8DBGUenokozbhL56zhMzf+GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JBXKYCDG; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JBXKYCDG"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIBops704742;
	Thu, 23 Jul 2026 00:02:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9oZF5eKYWTktbd3MC
	UKEqg1YGV0TwxcKFYdkYfPr/j8=; b=JBXKYCDGE2Qt4MxZ/47dd5HnP+bc4o0tt
	dM9OSZyy3v9aL9aiJVBtQMGW9c8mApWJYrd3Pqp6uDlmWRPf6+nSqrVNW0oj6GnP
	/NVERgCRKyipbdUgEbCvdTA2qn2ESH5F1NvLSWiOnO9dmbr0V6yjwaT9Zp9cPj8U
	vqc9Bx779YYRovSIc0ByaGdKufppJOVZPXaie4vIRAHxUlhqYyMk9PG7gJjeoYSK
	eQUDna9HxYAb35ZowGZgcZ0HiSsRxGrwBQ9norMM3uvw+Jq17Ftv3TsfFisnPrQu
	7mpRLqfuRWGVg4mTf/furGGh1dwhZd2ImzGmD0Owb1XSDyZM/WXjQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7abmyn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:03 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNnfgA032317;
	Thu, 23 Jul 2026 00:02:02 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgmtk1rry-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:02 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N021Dk20579026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:02:01 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD54958060;
	Thu, 23 Jul 2026 00:02:00 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 47D125805A;
	Thu, 23 Jul 2026 00:02:00 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:02:00 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 10/33] ibmvfc: add logic for protocol specific fabric logins
Date: Wed, 22 Jul 2026 17:01:26 -0700
Message-ID: <20260723000149.969416-11-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX7znpq3SV6KD5
 BS+5OFaVXXfFLNr5dUXO5p+DYyjX40dw5X2bgFIks1SDBC1qV93MOpJLeKlBGMjAgVRSpnp+kXI
 qdpX5cJCM/amujoIz5b3DvSqtiiTmEYR+GY/2W01YsKLiE/YrEZE8/Aw8CwqRm4cdcP0XTcQKxC
 HWLbkgmmvkLk1RM5kbRBEOD2UGg3GvG/FaGHiZmX30shMmGsXpYJafqbo9GMHRpCFK57ZFcQf6/
 fwd8TErQLgz0xC9jPzdfBCc5QUms7ChU2sXuyCAJUppfRpwMGPleMXYb4xvvOX8T1bVtOuoFaI8
 u4V6Hq/1V0MB6mph2vvHz7K4523bv3RQ4143jqdiG0WBfX6qx+tD+f0K+VOIUClRA3shP9a3gtb
 YXQR2/79ezI6v5HbAcbF1KSnhDdPYBlnxFYFvg7hD6QUOimC8cdsavmWZDuGcJFK1zervuAuhdW
 Z1n/xWScR8p649rHfOw==
X-Authority-Analysis: v=2.4 cv=F7ZnsKhN c=1 sm=1 tr=0 ts=6a6159fb cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=FovE9xXL7NGL95JtJZEA:9
X-Proofpoint-ORIG-GUID: tglKqAi-9u085gSVshxuUWz2BRKYHBOI
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX4iEH84kD29GD
 mb/bwG7UqoQ5iMs+VFKL21z/2qqBhRjvqas3eYRhSCSqnh/rqYY03rH4k+bLkzfFUFv2ulwQHNF
 9PDLWjcYKhgl34mMLXOexJEfqCdr6JA=
X-Proofpoint-GUID: tglKqAi-9u085gSVshxuUWz2BRKYHBOI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220234

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
index d8c2b56258ee..e0edd71e9fd4 100644
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
@@ -1956,11 +1970,13 @@ static struct ibmvfc_cmd *ibmvfc_init_vfc_cmd(struct ibmvfc_event *evt, struct s
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
@@ -5052,14 +5068,141 @@ static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
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
 
@@ -5068,22 +5211,28 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
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
@@ -5098,8 +5247,12 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
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
@@ -5107,9 +5260,12 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
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
 
@@ -5120,12 +5276,17 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
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
@@ -5156,6 +5317,7 @@ static void ibmvfc_channel_enquiry_done(struct ibmvfc_event *evt)
 	case IBMVFC_MAD_SUCCESS:
 		ibmvfc_dbg(vhost, "Channel Enquiry succeeded\n");
 		vhost->max_vios_scsi_channels = be32_to_cpu(rsp->num_scsi_subq_channels);
+		vhost->max_vios_nvme_channels = be32_to_cpu(rsp->num_nvme_subq_channels);
 		ibmvfc_free_event(evt);
 		break;
 	case IBMVFC_MAD_FAILED:
@@ -5290,8 +5452,14 @@ static void ibmvfc_npiv_login_done(struct ibmvfc_event *evt)
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
2.55.0

