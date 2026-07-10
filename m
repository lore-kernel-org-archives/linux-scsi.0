Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D3437C908;
	Fri, 10 Jul 2026 19:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783711018; cv=none; b=qw4++jE1edGSvKh4x+hz6sztQC7TUE0bGcDhd1F6HECSP3lmVjc+c/crmbx7wNkMFBZvLlSTAVf9FEIgWTgwXqov1pkT1VdB3tuqurra/J48JYZY/C5w6Blv8u51AqW2N03nZhudcCtRwf7kt7q+bY2DhIBxeByAEe5Gwri7Nmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783711018; c=relaxed/simple;
	bh=rMLaqrdfziwuC0RZ1ub4p5UStVN916u5G5CxmEpiCKA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Bs4oIM2PyVWQFrVcKTu0/1djnzm6QB73u6094wrKIErAykgu7D5YcWdeZOARbsa3jArB73lRN1P+1CIc3C8eYlCI5k8fvCP4hcKWiLNcmSiQdsQAKmsQMAPdJKBd5AGJfLxg/dz/YkGnGpIc2Z5NnuROeWSAMsirN724SpbjtIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UZW/lvkF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UZW/lvkF"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4C4AC2BCF4;
	Fri, 10 Jul 2026 19:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783711017;
	bh=rMLaqrdfziwuC0RZ1ub4p5UStVN916u5G5CxmEpiCKA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=UZW/lvkFeQJ4gTbOnUX2o8RpAwDaMcr0ae81ZKtACmxhP7wG/KIOJHXEaRYUy1fPi
	 RHOQp8AgXWBMGBPuZqz1A74JFsucA5avmNIhdtd/zRUvcz+ZWi1NT2nz2Cmib9gn/N
	 9XAyI1O1OZTDMlZChQgCJLLPYgLb4j9DxL1rtLV0JEaxZsfHcTJJsra5aF18wT/2Xy
	 lIxRGSNavggB6th56zHJXhMtmMJE4tIVl6IyYSB+nv6LimgjqBw+yN4FWYISctB7AP
	 4BmjM2RxyR18D+l8ktdduU52+UOp71oy22u7gUwX5bHaYMxZVo7DayHLM4mVV6Xmg2
	 CKvjb2lQ0pwBw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A87AFC44508;
	Fri, 10 Jul 2026 19:16:57 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Date: Fri, 10 Jul 2026 14:16:43 -0500
Subject: [PATCH v4 3/8] ibmvfc: make ibmvfc login to fabric
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-ibmvfc-fpin-support-v4-3-ef031ac19520@linux.ibm.com>
References: <20260710-ibmvfc-fpin-support-v4-0-ef031ac19520@linux.ibm.com>
In-Reply-To: <20260710-ibmvfc-fpin-support-v4-0-ef031ac19520@linux.ibm.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.ibm.com>, 
 Greg Joyce <gjoyce@linux.ibm.com>, Kyle Mahlkuch <kmahlkuc@linux.ibm.com>, 
 Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783711016; l=6602;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=dwpZu8Tf7g3wCB01cs6sTJsbVV1BtGJDXqGvQLlA3Fo=;
 b=9dSlEYZ7rpdF6wJjDaQ1btFowvC5hZ300PQ/FiwQbZjjqOdnfGfBMMgI/Ufm+ovkA+LekKfo1
 aFTexd/DPS7Bw10W2D4JOuDsk41533o2tDfey68pnNrsbEuE85o714d
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

From: Dave Marquardt <davemarq@linux.ibm.com>

Add fabric login capability to support asynchronous event queue with
dedicated interrupt as required by NPIV specification for async sub-queue
and full/extended FPIN message support.

Implement ibmvfc_fabric_login() to perform fabric login using MAD
(Management Adapter Data) format. Add ibmvfc_fabric_login_done() callback
to handle login completion, including error handling and retry logic.

On successful fabric login, store the assigned N_Port ID in the FC host
structure and transition to IBMVFC_HOST_ACTION_QUERY state to continue
initialization.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 96 ++++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/ibmvscsi/ibmvfc.h | 17 ++++++++
 2 files changed, 109 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index a7e3b7ee0683..c95e78d729ed 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -5265,6 +5265,88 @@ static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
 		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
 }
 
+static void ibmvfc_fabric_login_done(struct ibmvfc_event *evt)
+{
+	struct ibmvfc_fabric_login *rsp = &evt->xfer_iu->fabric_login;
+	u32 mad_status = be16_to_cpu(rsp->common.status);
+	struct ibmvfc_host *vhost = evt->vhost;
+	int level = IBMVFC_DEFAULT_LOG_LEVEL;
+
+	ENTER;
+
+	switch (mad_status) {
+	case IBMVFC_MAD_SUCCESS:
+		fc_host_port_id(vhost->host) = be64_to_cpu(rsp->nport_id);
+		ibmvfc_free_event(evt);
+		break;
+
+	case IBMVFC_MAD_FAILED:
+		if (ibmvfc_retry_cmd(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)))
+			level += ibmvfc_retry_host_init(vhost);
+		else
+			ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
+		ibmvfc_log(vhost, level, "Fabric Login failed: %s (%x:%x)\n",
+			   ibmvfc_get_cmd_error(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)),
+						be16_to_cpu(rsp->status), be16_to_cpu(rsp->error));
+		ibmvfc_free_event(evt);
+		LEAVE;
+		return;
+
+	case IBMVFC_MAD_CRQ_ERROR:
+		ibmvfc_retry_host_init(vhost);
+		fallthrough;
+
+	case IBMVFC_MAD_DRIVER_FAILED:
+		ibmvfc_free_event(evt);
+		LEAVE;
+		return;
+
+	default:
+		dev_err(vhost->dev, "Invalid fabric Login response: 0x%x\n", mad_status);
+		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
+		ibmvfc_free_event(evt);
+		LEAVE;
+		return;
+	}
+
+	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
+	wake_up(&vhost->work_wait_q);
+
+	LEAVE;
+}
+
+static void ibmvfc_fabric_login(struct ibmvfc_host *vhost)
+{
+	struct ibmvfc_fabric_login *mad;
+	struct ibmvfc_event *evt;
+	int level = IBMVFC_DEFAULT_LOG_LEVEL;
+
+	if (vhost->scsi_scrqs.protocol != IBMVFC_PROTO_SCSI) {
+		ibmvfc_log(vhost, level, "Fabric Login failed: unknown protocol\n");
+		ibmvfc_hard_reset_host(vhost);
+		return;
+	}
+
+	evt = ibmvfc_get_reserved_event(&vhost->crq);
+	if (!evt) {
+		ibmvfc_log(vhost, level, "Fabric Login failed: no available events\n");
+		ibmvfc_hard_reset_host(vhost);
+		return;
+	}
+
+	ibmvfc_init_event(evt, ibmvfc_fabric_login_done, IBMVFC_MAD_FORMAT);
+	mad = &evt->iu.fabric_login;
+	memset(mad, 0, sizeof(*mad));
+	mad->common.opcode = cpu_to_be32(IBMVFC_FABRIC_LOGIN);
+	mad->common.version = cpu_to_be32(1);
+	mad->common.length = cpu_to_be16(sizeof(*mad));
+
+	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT_WAIT);
+
+	if (ibmvfc_send_event(evt, vhost, default_timeout))
+		ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
+}
+
 static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 {
 	struct ibmvfc_host *vhost = evt->vhost;
@@ -5311,8 +5393,12 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 		return;
 	}
 
-	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
-	wake_up(&vhost->work_wait_q);
+	if (ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_SCSI)) {
+		ibmvfc_fabric_login(vhost);
+	} else {
+		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
+		wake_up(&vhost->work_wait_q);
+	}
 }
 
 static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
@@ -5503,9 +5589,11 @@ static void ibmvfc_npiv_login_done(struct ibmvfc_event *evt)
 	vhost->host->can_queue = be32_to_cpu(rsp->max_cmds) - IBMVFC_NUM_INTERNAL_REQ;
 	vhost->host->max_sectors = npiv_max_sectors;
 
-	if (ibmvfc_check_caps(vhost, IBMVFC_CAN_SUPPORT_CHANNELS) && vhost->do_enquiry) {
+	if (ibmvfc_check_caps(vhost, IBMVFC_CAN_SUPPORT_CHANNELS) && vhost->do_enquiry)
 		ibmvfc_channel_enquiry(vhost);
-	} else {
+	else if (ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_SCSI))
+		ibmvfc_fabric_login(vhost);
+	else {
 		vhost->do_enquiry = 0;
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
 		wake_up(&vhost->work_wait_q);
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 526632cb7237..adfd67e85af8 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -138,6 +138,7 @@ enum ibmvfc_mad_types {
 	IBMVFC_CHANNEL_ENQUIRY	= 0x1000,
 	IBMVFC_CHANNEL_SETUP	= 0x2000,
 	IBMVFC_CONNECTION_INFO	= 0x4000,
+	IBMVFC_FABRIC_LOGIN	= 0x8000,
 };
 
 struct ibmvfc_mad_common {
@@ -180,6 +181,7 @@ struct ibmvfc_npiv_login {
 #define IBMVFC_CAN_HANDLE_FPIN		0x004
 #define IBMVFC_CAN_USE_MAD_VERSION	0x008
 #define IBMVFC_CAN_SEND_VF_WWPN		0x010
+#define IBMVFC_YES_SCSI			0x040
 #define IBMVFC_CAN_USE_NOOP_CMD		0x200
 	__be64 node_name;
 	struct srp_direct_buf async;
@@ -227,6 +229,7 @@ struct ibmvfc_npiv_login_resp {
 #define IBMVFC_MAD_VERSION_CAP		0x0020
 #define IBMVFC_HANDLE_VF_WWPN		0x0040
 #define IBMVFC_CAN_SUPPORT_CHANNELS	0x0080
+#define IBMVFC_SUPPORT_SCSI		0x0200
 #define IBMVFC_SUPPORT_NOOP_CMD		0x1000
 	__be32 max_cmds;
 	__be32 scsi_id_sz;
@@ -590,6 +593,19 @@ struct ibmvfc_connection_info {
 	__be64 reserved[16];
 } __packed __aligned(8);
 
+struct ibmvfc_fabric_login {
+	struct ibmvfc_mad_common common;
+	__be64 flags;
+#define IBMVFC_STRIP_MERGE	0x1
+#define IBMVFC_LINK_COMMANDS	0x2
+	__be64 capabilities;
+	__be64 nport_id;
+	__be16 status;
+	__be16 error;
+	__be32 pad;
+	__be64 reserved[16];
+} __packed __aligned(8);
+
 struct ibmvfc_trace_start_entry {
 	u32 xfer_len;
 } __packed;
@@ -715,6 +731,7 @@ union ibmvfc_iu {
 	struct ibmvfc_channel_enquiry channel_enquiry;
 	struct ibmvfc_channel_setup_mad channel_setup;
 	struct ibmvfc_connection_info connection_info;
+	struct ibmvfc_fabric_login fabric_login;
 } __packed __aligned(8);
 
 enum ibmvfc_target_action {

-- 
2.55.0


