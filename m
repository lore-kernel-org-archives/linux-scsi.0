Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472772E9730
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309844; cv=none; b=eBlLwaa1QCoD9WKbSEoFcPf9bfyn8uj0TU+h2kO+eNIchZG/PD8zkrUPpZ5CNpr98yVnVQg2EiKWDVSN382dpbyLhBoDzKYici/hoZrkEQdL5QQd/b+VTtM9U54esp14tcQjdguMIt85CPgF0dHef4TyEv2Ls+y0yTnfeFeZWgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309844; c=relaxed/simple;
	bh=6WCJUF2D9Juf7JoaCP8vv4x2yKLHuSrkHcLqpf4dut8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cC3LK/aTaGIT65MJZT9LsBpoKuvywzxbppjpkf0Gi9ZintFznlpsDZeoVdkvatuy67PfGcC/6hunuufTurJLpx//Fk7eqmsVdy197jOmXEKfoXeVS87Kw90q4CT18tWH9DHJXREHEP1vLrOfd5HLgGjZ08yf/l5Da8vI5wvRIIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=ZAfhQbQP; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ZAfhQbQP"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VMs0qN1117304;
	Mon, 1 Jun 2026 03:30:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=L
	DsVXv+Aij4ASULQf9Oqi8xdFEn5KuaGKGjiUAJdv4A=; b=ZAfhQbQPE6m6BKlp5
	KwRegom0gThyg+L/WCeIbSFG8YCatImYGWs993wcwW6v1SwAGLEFg0vc6y8lhiP4
	hECrOgxiZR55gBV8I3gMftQBvxeFRMvSow0ykC9z2ND/tBMiB3bgZMcWnGOW87jA
	+03or3Ud+SDQQb3GBpaG+3D2SKgCM25QVuLOFeswRlIwlgBTdxYxsxmnUe2OoOmP
	FNhUmPkImPsVPy7rbiL8c9zmWslsB66p1qAO8PTmsfvz07MtYImJ6IPbjPT7kIyx
	BYYetK/dSdoo8YQqlBQKVXkO8BP7ojS02mbXoRYY6hjL4rjqXbuLkHnI2puGRLjQ
	iHXsA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4efw8hwpq5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:30:39 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:30:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:30:38 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 3A0873F7054;
	Mon,  1 Jun 2026 03:30:35 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 27/44] scsi: qla2xxx: Refactor marker IOCB handling for 29xx series
Date: Mon, 1 Jun 2026 15:58:36 +0530
Message-ID: <20260601102853.328426-28-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfX7zHuvrUexNfY
 hLupWmcvH+qVpBYplBgrHwyRVbCOIhJ6taSdTK5E02+lf3cCBJN5KUPFuUdgS6I70vwb0pJkNIT
 d8rSNGAuPC+HlpUpZj/wWAp4ZAIG9rXf835Sm34I568A+5HCeyZxcrAUEGDedpxeAfHPFVbBGSa
 mk5XgNt+0lXMaLcmwhMp8gluBeQm4miVd3BHkluq228MJJgtZPCn5piabND/z+9ZXhsL+lvcYji
 I7qDL/poJCdcFT+KpfroYYj5S+Rz/QZPfR4mbcf7Yb9J7+Qoh5ecoJxCZD7gheL8DTIC1egQhHr
 OdY4aWUXcfpE97oEIpFfH57/CJkMS4tBoNLU3RvtD15dgK7nOwHs+CK70XDj4QtfKeA70L/tJvD
 0XGI1Dvj/NocNmq6JbV5GYJ4aZTu4OMj+S2gTt/tQCa/gG52pG/zHH8lGswwFHJv0f7EXH+zK4X
 V0oDgf7MsjD1Zt4bhfw==
X-Proofpoint-GUID: DXX8rrcAMqEtcJeIYEjHh7ed-hGlNl4N
X-Proofpoint-ORIG-GUID: DXX8rrcAMqEtcJeIYEjHh7ed-hGlNl4N
X-Authority-Analysis: v=2.4 cv=F99nsKhN c=1 sm=1 tr=0 ts=6a1d5f4f cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=jv2C93Soc78RleZVqFQA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

Rework __qla2x00_marker() and qla_marker_iocb() for QLA29XX extended
marker IOCB (128-byte) support.  The extended layout (mrk_entry_24xx_ext)
overlays mrk_entry_24xx through 'lun', so the common header fields
(entry_type, modifier, nport_handle, lun, handle) are written through a
single struct mrk_entry_24xx pointer; only vp_index, which differs in
width (u8 in 24xx vs __le16 in the ext layout), needs a stride-aware
IS_QLA29XX() branch.

 - Allocate the IOCB once via __qla2x00_alloc_iocbs() and cast to
   struct mrk_entry_24xx, eliminating duplicated alloc/error paths.
 - Branch only on vp_index assignment where layout diverges.
 - Update qla_marker_iocb_entry() in qla_isr.c to accept void *pkt
   so it handles both 64-byte and 128-byte marker completions.
 - Add BUILD_BUG_ON size checks for mrk_entry_ext_t (128) and
   struct mrk_entry_24xx_ext (128).

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 88 +++++++++++++++------------------
 drivers/scsi/qla2xxx/qla_isr.c  |  7 +--
 drivers/scsi/qla2xxx/qla_os.c   |  2 +
 3 files changed, 45 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index e5a4bc58cc9a..6bff1b464660 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -522,63 +522,38 @@ static int
 __qla2x00_marker(struct scsi_qla_host *vha, struct qla_qpair *qpair,
     uint16_t loop_id, uint64_t lun, uint8_t type)
 {
-	mrk_entry_t *mrk;
-	struct mrk_entry_24xx *mrk24 = NULL;
-	struct req_que *req = qpair->req;
 	struct qla_hw_data *ha = vha->hw;
+	struct mrk_entry_24xx *mrk24;
+	struct req_que *req = qpair->req;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
-	mrk = (mrk_entry_t *)__qla2x00_alloc_iocbs(qpair, NULL);
-	if (mrk == NULL) {
-		ql_log(ql_log_warn, base_vha, 0x3026,
-		    "Failed to allocate Marker IOCB.\n");
-
-		return (QLA_FUNCTION_FAILED);
-	}
-
 	/*
 	 * 29xx uses the extended marker IOCB (128 bytes) with a __le16
 	 * vp_index field.  The first 64 bytes of mrk_entry_24xx_ext are
-	 * layout-compatible with mrk_entry_24xx except for the vp_index
-	 * storage, which differs in width and offset, so handle it via
-	 * a dedicated branch.
+	 * layout-compatible with mrk_entry_24xx through 'lun', so the
+	 * common header is written through a struct mrk_entry_24xx * view;
+	 * vp_index differs in width (u8 vs __le16) and is the only branch.
 	 */
-	if (IS_QLA29XX(ha)) {
-		struct mrk_entry_24xx_ext *mrk29 =
-			(struct mrk_entry_24xx_ext *)mrk;
-
-		mrk29->entry_type = MARKER_TYPE;
-		mrk29->modifier = type;
-		if (type != MK_SYNC_ALL) {
-			mrk29->nport_handle = cpu_to_le16(loop_id);
-			int_to_scsilun(lun, (struct scsi_lun *)&mrk29->lun);
-			host_to_fcp_swap(mrk29->lun, sizeof(mrk29->lun));
-			mrk29->vp_index = cpu_to_le16(vha->vp_idx);
-		}
-		mrk29->handle = QLA_SKIP_HANDLE;
-		goto post;
+	mrk24 = __qla2x00_alloc_iocbs(qpair, NULL);
+	if (!mrk24) {
+		ql_log(ql_log_warn, base_vha, 0x3026,
+		    "Failed to allocate Marker IOCB.\n");
+		return QLA_FUNCTION_FAILED;
 	}
 
-	mrk24 = (struct mrk_entry_24xx *)mrk;
-
-	mrk->entry_type = MARKER_TYPE;
-	mrk->modifier = type;
+	mrk24->entry_type = MARKER_TYPE;
+	mrk24->modifier = type;
 	if (type != MK_SYNC_ALL) {
-		if (IS_FWI2_CAPABLE(ha)) {
-			mrk24->nport_handle = cpu_to_le16(loop_id);
-			int_to_scsilun(lun, (struct scsi_lun *)&mrk24->lun);
-			host_to_fcp_swap(mrk24->lun, sizeof(mrk24->lun));
+		mrk24->nport_handle = cpu_to_le16(loop_id);
+		int_to_scsilun(lun, (struct scsi_lun *)&mrk24->lun);
+		host_to_fcp_swap(mrk24->lun, sizeof(mrk24->lun));
+		if (IS_QLA29XX(ha))
+			((struct mrk_entry_24xx_ext *)mrk24)->vp_index =
+			    cpu_to_le16(vha->vp_idx);
+		else
 			mrk24->vp_index = vha->vp_idx;
-		} else {
-			SET_TARGET_ID(ha, mrk->target, loop_id);
-			mrk->lun = cpu_to_le16((uint16_t)lun);
-		}
 	}
-
-	if (IS_FWI2_CAPABLE(ha))
-		mrk24->handle = QLA_SKIP_HANDLE;
-
-post:
+	mrk24->handle = QLA_SKIP_HANDLE;
 
 	wmb();
 
@@ -4059,16 +4034,31 @@ static int qla_get_iocbs_resource(struct srb *sp)
 }
 
 static void
-qla_marker_iocb(srb_t *sp, struct mrk_entry_24xx *mrk)
+qla_marker_iocb(srb_t *sp, void *pkt)
 {
+	struct qla_hw_data *ha = sp->vha->hw;
+	struct mrk_entry_24xx *mrk = pkt;
+
+	/*
+	 * mrk_entry_24xx_ext overlays mrk_entry_24xx through 'lun', so
+	 * the common-header writes go through the 24xx-typed pointer;
+	 * only vp_index (u8 in 24xx, __le16 in the ext layout) needs a
+	 * stride-aware branch.
+	 */
 	mrk->entry_type = MARKER_TYPE;
 	mrk->modifier = sp->u.iocb_cmd.u.tmf.modifier;
 	mrk->handle = make_handle(sp->qpair->req->id, sp->handle);
 	if (sp->u.iocb_cmd.u.tmf.modifier != MK_SYNC_ALL) {
-		mrk->nport_handle = cpu_to_le16(sp->u.iocb_cmd.u.tmf.loop_id);
-		int_to_scsilun(sp->u.iocb_cmd.u.tmf.lun, (struct scsi_lun *)&mrk->lun);
+		mrk->nport_handle =
+		    cpu_to_le16(sp->u.iocb_cmd.u.tmf.loop_id);
+		int_to_scsilun(sp->u.iocb_cmd.u.tmf.lun,
+		    (struct scsi_lun *)&mrk->lun);
 		host_to_fcp_swap(mrk->lun, sizeof(mrk->lun));
-		mrk->vp_index = sp->u.iocb_cmd.u.tmf.vp_index;
+		if (IS_QLA29XX(ha))
+			((struct mrk_entry_24xx_ext *)pkt)->vp_index =
+			    cpu_to_le16(sp->u.iocb_cmd.u.tmf.vp_index);
+		else
+			mrk->vp_index = sp->u.iocb_cmd.u.tmf.vp_index;
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b8397912cb04..e95fb0e59f38 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3917,9 +3917,10 @@ static int qla_chk_cont_iocb_avail(struct scsi_qla_host *vha,
 }
 
 static void qla_marker_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
-	struct mrk_entry_24xx *pkt)
+	void *pkt)
 {
 	const char func[] = "MRK-IOCB";
+	struct mrk_entry_24xx *mrk = pkt;
 	srb_t *sp;
 	int res = QLA_SUCCESS;
 
@@ -3930,7 +3931,7 @@ static void qla_marker_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	if (!sp)
 		return;
 
-	if (pkt->entry_status) {
+	if (mrk->entry_status) {
 		ql_dbg(ql_dbg_taskm, vha, 0x8025, "marker failure.\n");
 		res = QLA_COMMAND_ERROR;
 	}
@@ -4049,7 +4050,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 					(struct nack_to_isp *)pkt);
 			break;
 		case MARKER_TYPE:
-			qla_marker_iocb_entry(vha, rsp->req, (struct mrk_entry_24xx *)pkt);
+			qla_marker_iocb_entry(vha, rsp->req, pkt);
 			break;
 		case ABORT_IOCB_TYPE:
 			qla24xx_abort_iocb_entry(vha, rsp->req,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bbbddb55eabd..4540506cfd29 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8324,6 +8324,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(cont_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(init_cb_t) != 96);
 	BUILD_BUG_ON(sizeof(mrk_entry_t) != 64);
+	BUILD_BUG_ON(sizeof(struct mrk_entry_ext) != 128);
 	BUILD_BUG_ON(sizeof(ms_iocb_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(request_t) != 64);
 	BUILD_BUG_ON(sizeof(struct abort_entry_24xx) != 64);
@@ -8360,6 +8361,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct mbx_entry) != 64);
 	BUILD_BUG_ON(sizeof(struct mid_init_cb_24xx) != 5252);
 	BUILD_BUG_ON(sizeof(struct mrk_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct mrk_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct nvram_24xx) != 512);
 	BUILD_BUG_ON(sizeof(struct nvram_81xx) != 512);
 	BUILD_BUG_ON(sizeof(struct pt_ls4_request) != 64);
-- 
2.47.3

