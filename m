Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9C0369996
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258172; cv=none; b=crbkaVfeoCN1HEzR0/hSUR28K0s39G5UK9yZ8mZHjfIrT/xolcVN/KyNK4bNe6IWipfQbqlqd4LJxgeJkbuMYltqHdIPqQYR79w/shJdEIqqgRI7LCWpc7GsUNo41Nr1rrIdVKhr2VCYyrIrIruKGlieCVUTMndKzOZd4pbJT6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258172; c=relaxed/simple;
	bh=zP05syCMB2tclzIXcCevzA1JoTkXLAezmJwyJmiGZHc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rSId65+eHbyu+0oqrwT+iftbF2AXtH3Yqoo1fu2GgFmQ3AtQUubnwEUdNhx0NISl0Y5IA4HnzkKnCyJD3ZfleWXZUOatu0Lxk9jPnlbdCXKrKbXdvKN3tQgeAwp2BBusErN08E7fV2oJ0U22wnRqnxCQwVF0pkfW7gw6Nk2qgDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=ap+mnppD; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ap+mnppD"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C39qBw3679423;
	Fri, 12 Jun 2026 02:56:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=T
	JZ9jzT+JD5A7u1b8dsB9WohNX17wolqNREFo7X+XFY=; b=ap+mnppDQRecbuict
	rDzcu09vHCyiT73ak4abVBWcLetvKECUuDZLq4u5I1N1lfrP8FzIhA/AVVfrI7DI
	31nFfwE58kJYCn/VxyMYxO5Gk+sv9EyyJA7e8JWTpLBhzSHTB+o0fd+6XRSS1Y6N
	ShGtIWjxniyig4aBFuaQbXhIv0GbU+SmQuMnB8899rV5ilqrz0kF0e09I1LRl5PI
	zAC7q+s6LAU4nxxzOUf0wq9pIcrPSPA8S8ytlxWEtDuVy+on3LK7LGJt0OodVi42
	Kz4YFj5PfTWHGniCgR2QEe8CVr6oOnhfVdarZD+CUVVq/qTWkzsyZzbSKNYmsJ5F
	mjlAQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4er9qn92n4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:56:05 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:56:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:56:05 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id AD5833F7040;
	Fri, 12 Jun 2026 02:56:02 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 41/60] scsi: qla2xxx: Unify NVMe IOCB build path for 29xx and legacy adapters
Date: Fri, 12 Jun 2026 15:23:14 +0530
Message-ID: <20260612095333.1666592-42-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260612095333.1666592-1-njavali@marvell.com>
References: <20260612095333.1666592-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Mx5oMAoz1YJgkeTMux2XO2Nk59S0J3hc
X-Authority-Analysis: v=2.4 cv=Y9HIdBeN c=1 sm=1 tr=0 ts=6a2bd7b5 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=_bSsD-E4fiH2av7KfxkA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX4ZImTueGLcIw
 XDYMpsO7XsYGkYUeVaOfXCd0Cdy1eztGZF+6nNXOZ4LR/gn5Zs6XMgqi/NPYihlff8wMB8U+CXS
 36TvfVPtbIdwdC+9VWWt74UdJFb/LIw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX99Vom7cstxV7
 hakXw2Qxayffl5+hNpRFsokUp5eHy+X/ZsLrv2Mkv1e1rXj1y2KEBqd40mJII1+rG+9iJFxVNGG
 57CW7nELNug3MiDSQlrJkq3CV8m+0Nx8zVwrxnlHccO43G4zhnj+tkI3Hyrj9pux0e77jSLNObL
 PIKGH21bP0JuBLjN0e7ALNX1LvQ7s8CKxk4JSDH/Pn+YLexm6pl3bn0sJNu9QTWhVkXecnIqpu0
 h68eKtKLNUJv5dRZxaIuc1YLh5/58R93xGBTeloV5d+CwBcnHr+iS7f/oOSZXpeDYnPELQiZqm0
 Uyq8fhkLcBNxWafxf00yVoWNmNvEK8YAjQG1QogrmaYI9yWA7Qtadwm82V7IYJ9yR0y94xWmg1J
 1XBzrYeHfRgfkT4wZ+TeESMQjTRmvG6t/G+Zbst+HYLX+XTwjYpQg42jDCwFe9nbN1eOGai8HK8
 UifzDDIigdCG4dO6GIQ==
X-Proofpoint-GUID: Mx5oMAoz1YJgkeTMux2XO2Nk59S0J3hc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

The cmd_nvme and cmd_nvme_ext structs share an identical header layout
through byte_count, so the IOCB build code in qla2x00_start_nvme_mq()
need not duplicate all common-field writes in separate IS_QLA29XX(ha)
and legacy blocks.

Initialize the cmd_pkt and cmd_pkt_ext pointers to NULL, then write
common header fields through a single cmd_pkt (struct cmd_nvme *) view,
branching on IS_QLA29XX(ha) only where the layouts genuinely diverge:

  - port_id[] vs __le16 vp_index
  - single inline DSD vs NUM_NVME_DSDS DSD array

Add BUILD_BUG_ON checks that enforce the layout contract at compile
time so any future struct change that breaks the common-header overlap
fails the build rather than silently corrupting IOCBs.

Also add a BUILD_BUG_ON size check for struct cmd_nvme_ext during
module initialization and a reserved_end field to
vp_rpt_id_entry_24xx_ext to ensure proper memory allocation and data
integrity for 29xx series adapters.

No functional change.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 58 ++++++++++++++++++++++++---------
 drivers/scsi/qla2xxx/qla_os.c   |  1 +
 2 files changed, 43 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index cdd9e657bec6..fa89cd2b5f29 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -554,8 +554,8 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	unsigned long   flags;
 	uint32_t        *clr_ptr;
 	uint32_t        handle;
-	struct cmd_nvme *cmd_pkt;
-	struct cmd_nvme_ext *cmd_pkt_ext;
+	struct cmd_nvme *cmd_pkt = NULL;
+	struct cmd_nvme_ext *cmd_pkt_ext = NULL;
 	uint16_t        cnt, i;
 	uint16_t        req_cnt;
 	uint16_t        tot_dsds;
@@ -634,12 +634,44 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	req->cnt -= req_cnt;
 
 	/*
-	 * 29xx operates on the 128-byte extended IOCB ring via ring_ext_ptr;
-	 * the header layout of struct cmd_nvme is identical to the head of
-	 * struct cmd_nvme_ext through 'byte_count', so common field writes
-	 * below go through 'cmd_pkt'.  Divergent tail fields
-	 * (port_id/vp_index, DSD array) are handled via IS_QLA29XX() branches.
+	 * 29xx operates on the 128-byte extended IOCB ring; the header
+	 * layout of struct cmd_nvme is identical to the head of struct
+	 * cmd_nvme_ext through 'byte_count', so the common-field writes
+	 * below go through cmd_pkt regardless of stride.  Divergent tail
+	 * fields (port_id/vp_index, DSD array) are handled via
+	 * IS_QLA29XX(ha) branches.
+	 *
+	 * Enforce the layout contract at compile time so any future
+	 * change to either struct that breaks the common-header overlap
+	 * fails the build rather than silently corrupting IOCBs.
 	 */
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, entry_type) !=
+		     offsetof(struct cmd_nvme_ext, entry_type));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, handle) !=
+		     offsetof(struct cmd_nvme_ext, handle));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, nport_handle) !=
+		     offsetof(struct cmd_nvme_ext, nport_handle));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, timeout) !=
+		     offsetof(struct cmd_nvme_ext, timeout));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, dseg_count) !=
+		     offsetof(struct cmd_nvme_ext, dseg_count));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, nvme_rsp_dsd_len) !=
+		     offsetof(struct cmd_nvme_ext, nvme_rsp_dsd_len));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, rsvd) !=
+		     offsetof(struct cmd_nvme_ext, rsvd));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, control_flags) !=
+		     offsetof(struct cmd_nvme_ext, control_flags));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, nvme_cmnd_dseg_len) !=
+		     offsetof(struct cmd_nvme_ext, nvme_cmnd_dseg_len));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, nvme_cmnd_dseg_address) !=
+		     offsetof(struct cmd_nvme_ext, nvme_cmnd_dseg_address));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, nvme_rsp_dseg_address) !=
+		     offsetof(struct cmd_nvme_ext, nvme_rsp_dseg_address));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, byte_count) !=
+		     offsetof(struct cmd_nvme_ext, byte_count));
+	BUILD_BUG_ON(sizeof_field(struct cmd_nvme, byte_count) !=
+		     sizeof_field(struct cmd_nvme_ext, byte_count));
+
 	if (IS_QLA29XX(ha))
 		cmd_pkt = (struct cmd_nvme *)req->ring_ext_ptr;
 	else
@@ -655,11 +687,8 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 		memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
 
 	cmd_pkt->entry_status = 0;
-
-	/* Update entry type to indicate Command NVME IOCB */
 	cmd_pkt->entry_type = COMMAND_NVME;
 
-	/* No data transfer how do we check buffer len == 0?? */
 	if (fd->io_dir == NVMEFC_FCP_READ) {
 		cmd_pkt->control_flags = cpu_to_le16(CF_READ_DATA);
 		qpair->counters.input_bytes += fd->payload_length;
@@ -684,18 +713,15 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	if (sp->fcport->edif.enable && fd->io_dir != 0)
 		cmd_pkt->control_flags |= cpu_to_le16(CF_EN_EDIF);
 
-	/* Set BIT_13 of control flags for Async event */
 	if (vha->flags.nvme2_enabled &&
-	    cmd->sqe.common.opcode == nvme_admin_async_event) {
+	    cmd->sqe.common.opcode == nvme_admin_async_event)
 		cmd_pkt->control_flags |= cpu_to_le16(CF_ADMIN_ASYNC_EVENT);
-	}
 
-	/* Set NPORT-ID */
 	cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
 	if (IS_QLA29XX(ha)) {
 		/*
-		 * 29xx extended NVMe IOCB has no port_id[] field; vp_index is a
-		 * 9-bit __le16 (see CMD_EXT_VP_INDEX_MASK).
+		 * 29xx extended NVMe IOCB has no port_id[] field; vp_index is
+		 * a 9-bit __le16 (see CMD_EXT_VP_INDEX_MASK).
 		 */
 		cmd_pkt_ext->vp_index = cpu_to_le16(sp->fcport->vha->vp_idx);
 	} else {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d8945cab3251..f539190dd504 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8366,6 +8366,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct access_chip_rsp_84xx) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_bidir) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_nvme) != 64);
+	BUILD_BUG_ON(sizeof(struct cmd_nvme_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct cmd_type_6) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_type_7) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_type_7_fx00) != 64);
-- 
2.47.3

