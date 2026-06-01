Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC613537CC
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309887; cv=none; b=cYC1uPXkKnxOIwmLD8d92kaOwts0EV5ayzCY/TBDTH5kfjy0Npj7u3UO1Vu7PpcI0kCLkVVyj6nYXKtSY83nX//fl7sR+OcZiA3JtsqM8yfVlGCL6ehfQ4Fmem0zJRU3z9S2tJgpXO7AqY2cPdtzR905RTm22SHksqtkg0I456Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309887; c=relaxed/simple;
	bh=PBJUUkn9BUWptVFLDeWT6w0EVgW560e4+g02OgTLlsE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z5XhF5mX301YRyHJC9JSzavEoXp9XKl2ECYFsUtFUWULS10d3W49M85nifYa7eyZPuHh0FQv21YAtZzPS2TLlqt5OfGlLtB/v0avxnDkP1qOsMvh/CaydtbvmUe7q0Io8Oy+tRMlmvXG5xTt47mvG+PqmSareYKIOw70OkPWRhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=QEUAjHP5; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QEUAjHP5"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VMs0qb1117304;
	Mon, 1 Jun 2026 03:31:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=R
	g02jq4RhCnMDAP0Co7LFE5BMyUv8IqWpgB7FjZ4foo=; b=QEUAjHP5ToijfTdfx
	B4+niHp8O0eGP4pClxCawDSemtf0Mt/Ql+xmNOltP1yfH8G8LY9vU2CvX9oY0k8J
	hZE7hsgYz6IVP7+Kdb3Wc0Dl31AmjI/2Msf2m4kz+tZqoqrJjQ5ckpbeJSq3QxVb
	BiUHWcp46mgysbXoGtkBhkTNhZHmK7izgnNNiRWFJ9ncCeVQA5qR1aQNbRz0w4FZ
	/afRGlRNplp7IKWFWmCMh06VmrhBIK9MgeEnxjNyyCu1DVtoRvT74OKxlDExn542
	0MapHhFe+dcqxDGG0SXppOCMbM82ZKjo0gt48WnzybAKlpE+zxNX3JvqDoB8mzOe
	f502w==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4efw8hwptn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:31:22 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:31:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:31:21 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id C79673F7053;
	Mon,  1 Jun 2026 03:31:18 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 41/44] scsi: qla2xxx: Unify NVMe IOCB build path for 29xx and legacy adapters
Date: Mon, 1 Jun 2026 15:58:50 +0530
Message-ID: <20260601102853.328426-42-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260601102853.328426-1-njavali@marvell.com>
References: <20260601102853.328426-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfX66koxQzlwMQN
 e313iX3Z6/ke6GUF0fGWl9BORQYhZbbcdfaxXgMsVA1THhyZ1VKwzwXFTJ5Nv5qt62dSpkiCRvf
 fqRxJoCd5n0/nVTOg4bP+GWTV32GpHDyfoAZmditVjXIfxf5U2gb+A6uHIfxxUsYTybGpnf6q93
 qvVPQA8pPvk1vQi/zNaKSZh0u2yhGx9KokBZvagZXXpsBB5v+zi8ObARsTT+qpYVyp96rav9aE0
 QOiy1sXbI31aE6N94ru0D/m+mhqidx40Y7noWV6doX12hHF61KFGKS7C1adeQtdDc1FdTLaXSBF
 gm5OAJnKOfhzNVuIrcXizaGAl4po7EgZI1uRHahnjWjnXEcSdEMnvefAVDo79OUCHkN/EITZrZX
 gbGZheHy/xiMy7GUx9gg2MmA1JnAQyuCKwr3bCvHnUFaAZbcS/l6TlaKzACUkpiYTPbkH22PHb7
 cJKWL5XTU3deEY2w/wA==
X-Proofpoint-GUID: WOmyuOenmGSP25cJtZyGAfy5v_vrQxwW
X-Proofpoint-ORIG-GUID: WOmyuOenmGSP25cJtZyGAfy5v_vrQxwW
X-Authority-Analysis: v=2.4 cv=F99nsKhN c=1 sm=1 tr=0 ts=6a1d5f7a cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=_bSsD-E4fiH2av7KfxkA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

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

Cc: stable@vger.kernel.org
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
index fc3d28116244..62f9323e5dc3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8357,6 +8357,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct access_chip_rsp_84xx) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_bidir) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_nvme) != 64);
+	BUILD_BUG_ON(sizeof(struct cmd_nvme_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct cmd_type_6) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_type_7) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_type_7_fx00) != 64);
-- 
2.47.3

