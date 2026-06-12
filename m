Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BD23806C1
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258166; cv=none; b=FycN7Vt/vCG8ak59RSbO7HgTd0SBeEGOT21mHnIDwl4nMt1lzWRYZf2oNa/z4I3LI6SwmLY6lv2yO1vcDGZ0EQrRayVt14TchpR1XVx4iWcpCb4fY3PnXHaBFQ6JmlLa6RXn7jQbf1Y+QLadyEmYHFXEArU9dWisE8oA5lIZZ98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258166; c=relaxed/simple;
	bh=eQEd2P0GCNg+aA6WdvF+jsbEjy2ehZdqRCuiw/YTolY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rhdNG3LCtC/pJA0BB2Vw1p4oJl/R294Kdm22nGZKTPsjVcOqMn0EaUtNPwLf4Rp8vVA5AlsFurY+rZw6vHUoA7NThDdq5Bay7/ihZzbOAQNIq+PpLYEmvRMI2vsTXmd2qlKeMrByRo/QPG3/3c6U+TI+6hIWitWosEcMjsptlqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Osp/wz0b; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Osp/wz0b"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C3ASqh071190;
	Fri, 12 Jun 2026 02:55:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=6
	RqjEynTsx0ulde+YasrACdxZa7BW9Bw2DZepTxiMW4=; b=Osp/wz0bJNNgQns+j
	664rUBpyoBYmO3RvL+gjI279OWPgucSScVGX9kJPj/YXafZ/SoYAY+RkVLVvAw8t
	zgwazWgAu+w1LJSpPzgVrUIvtsMNiFIO8CIa4Rxtko2TYtis4aCHZ5MOa6BB2/Z2
	fQLe8+JhuNbnSX4LU+kbupGXkWs1KogSW1Y654ckIVVkMqHgQcZvFSbVWJNJWxGT
	5jwfVyH1lfHWeqPuRBvfntfC+DFHCORo2cQYgS2wJyVbnq/K/oOMRv+3mNlLECtm
	yYG+q7rwi0RFaoFoe+B2jk3wzfMad7s7LLpyue0sng3sIK0StiKoAus3f3gpMyHw
	9RZow==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5vxrpv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:55:57 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:55:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:55:55 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 97EC03F704D;
	Fri, 12 Jun 2026 02:55:52 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 38/60] scsi: qla2xxx: Update VP control IOCB handling for 29xx series
Date: Fri, 12 Jun 2026 15:23:11 +0530
Message-ID: <20260612095333.1666592-39-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX9M1na6gGKICH
 4v6Ohh+WgErB5bgAbVvU1PnjFv6tzUirJV+KhrYngzgP3xY8OpY/20O9CvYjWy7hxCfww1402Rg
 kjoLkqnfnIXNcbDONYMQtLShGGFhie0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX+z08oLb6xAH8
 6Wy0qZH3n+o5m/eFIy89zq3zBVhboZ7ZjQBvsWodivxSoRUcHC67088+xYalpKrDobdG4xqlu3t
 ZYdWpomZy158hlOze3vgaRlphX4eI1Ngsd4JhL+5H5goApCSc+YTUKW8csRhYp+dTRmJqXld7Km
 zKoizo0e/0JB/aDsBNGHfh1Tef1k5M5IfPOS3McX0umDBkMLyublzmLCByDz7q/XzMmqzQs2OqQ
 i8OTlX/emFUygRYOVZALm9OyVHHc/6LKYGg7p3XeierAvNKn61AJwTaaaSrSbkPz5UvJgAgsFCt
 9qACG2UA8P8WOHlhZEBlZG5j6ZsByOV85fZlZY4/tnxC9EnXqdSaWlsx3oNs7H2sqCdgkFnRPZi
 j7DZpHvZdPMDVPRhMNpefZQH7SrZ5nFiPUifuPC9TTgJmS5S7lB7eeugq6Gs77EohWjWfnaGG3F
 fVxOknJzgEE+dIHtv0A==
X-Authority-Analysis: v=2.4 cv=UPDt2ify c=1 sm=1 tr=0 ts=6a2bd7ad cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=Mw6LxwIP_SzeKoanQqkA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: 9jB8sd5st9A5qVmc_sQ8PxC4XhRbNUEO
X-Proofpoint-GUID: 9jB8sd5st9A5qVmc_sQ8PxC4XhRbNUEO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

Update VP control IOCB command and response handling to support the
29xx series adapters, which use the 128-byte vp_ctrl_entry_24xx_ext
layout.

Change the qla25xx_ctrlvp_iocb() and qla_ctrlvp_completed() function
signatures from typed struct pointers to void *, since callers already
pass a generic ring-slot pointer.  Both the standard 64-byte
vp_ctrl_entry_24xx and the 128-byte vp_ctrl_entry_24xx_ext are
layout-identical for every field touched in these helpers (entry_type,
handle, entry_count, command, vp_count, vp_idx_map, entry_status,
comp_status, vp_idx_failed), so a single struct vp_ctrl_entry_24xx *
view handles both adapter families without an IS_QLA29XX() branch.

Add a BUILD_BUG_ON size check for the extended structure.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 23 ++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_isr.c  | 13 +++++++++----
 drivers/scsi/qla2xxx/qla_os.c   |  1 +
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 8e435b170fe1..a286e947fb21 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -4016,22 +4016,31 @@ qla_nvme_ls(srb_t *sp, struct pt_ls4_request *cmd_pkt)
 }
 
 static void
-qla25xx_ctrlvp_iocb(srb_t *sp, struct vp_ctrl_entry_24xx *vce)
+qla25xx_ctrlvp_iocb(srb_t *sp, void *pkt)
 {
+	/*
+	 * vp_ctrl_entry_24xx_ext is layout-identical to vp_ctrl_entry_24xx
+	 * for all fields touched here (entry_type, handle, entry_count,
+	 * command, vp_count, vp_idx_map) -- they all sit at the same
+	 * offsets and types in both structs, and the ext layout merely
+	 * tacks on flags/id/hopct/reserved at offset 32+.  So no
+	 * IS_QLA29XX(ha) dispatch is needed on the issue path.
+	 */
+	struct vp_ctrl_entry_24xx *vce = pkt;
 	int map, pos;
 
-	vce->entry_type = VP_CTRL_IOCB_TYPE;
-	vce->handle = sp->handle;
-	vce->entry_count = 1;
-	vce->command = cpu_to_le16(sp->u.iocb_cmd.u.ctrlvp.cmd);
-	vce->vp_count = cpu_to_le16(1);
-
 	/*
 	 * index map in firmware starts with 1; decrement index
 	 * this is ok as we never use index 0
 	 */
 	map = (sp->u.iocb_cmd.u.ctrlvp.vp_index - 1) / 8;
 	pos = (sp->u.iocb_cmd.u.ctrlvp.vp_index - 1) & 7;
+
+	vce->entry_type = VP_CTRL_IOCB_TYPE;
+	vce->handle = sp->handle;
+	vce->entry_count = 1;
+	vce->command = cpu_to_le16(sp->u.iocb_cmd.u.ctrlvp.cmd);
+	vce->vp_count = cpu_to_le16(1);
 	vce->vp_idx_map[map] |= 1 << pos;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 284d874392fd..9c12e99ba5bd 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3052,13 +3052,19 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 }
 
 static void qla_ctrlvp_completed(scsi_qla_host_t *vha, struct req_que *req,
-    struct vp_ctrl_entry_24xx *vce)
+				 void *pkt)
 {
 	const char func[] = "CTRLVP-IOCB";
+	/*
+	 * vp_ctrl_entry_24xx_ext overlays vp_ctrl_entry_24xx for all
+	 * fields read here (entry_status, comp_status, vp_idx_failed),
+	 * so the read goes through one struct vp_ctrl_entry_24xx * view.
+	 */
+	struct vp_ctrl_entry_24xx *vce = pkt;
 	srb_t *sp;
 	int rval = QLA_SUCCESS;
 
-	sp = qla2x00_get_sp_from_handle(vha, func, req, vce);
+	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 	if (!sp)
 		return;
 
@@ -4290,8 +4296,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			    (struct mbx_24xx_entry *)pkt);
 			break;
 		case VP_CTRL_IOCB_TYPE:
-			qla_ctrlvp_completed(vha, rsp->req,
-			    (struct vp_ctrl_entry_24xx *)pkt);
+			qla_ctrlvp_completed(vha, rsp->req, pkt);
 			break;
 		case PUREX_IOCB_TYPE:
 			if (IS_QLA29XX(ha)) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 24a066b304d9..bf5f3b16bdae 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8436,6 +8436,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct vf_evfp_entry_24xx) != 56);
 	BUILD_BUG_ON(sizeof(struct vp_config_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct vp_rpt_id_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(sts21_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(sts22_entry_t) != 64);
-- 
2.47.3

