Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E8F2E9730
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309860; cv=none; b=u5xXiZQmp8+VTX3+SGSjpGgzkgIN2PcmwJxNUKO5DVJkY9bZE60hOHLzzSyiR5G+Fq1Kp3pw6C6Xcjp7r7gPmaLDcZoOQdzR+VOHnC3qYzzTNhHcCrIYT7MKIeckY7q1zXjDMjQ9NCmfX94sOZpsvMGiMKmFJWI01ctBUbxIiJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309860; c=relaxed/simple;
	bh=2tzQqQjr9cDwOIArfHduZ6fB7TL9nPilmso48M6DPZY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AoYadV8OSu/CZcq7ApUj4vBfgQkECrHqIuncdLzzfxrtSRHU7Y1sdtOBPWUafQ5K1LwWI9aDp4pHLFS3yxxYEoWMALhmwQUtat7Q9ksLEbuxmwdsQuAEPbjb+WMe0T+jeJo8Rmmjmzshi5KNfoeLzXz9LGtR3tTu8tlpDuquzro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=HHRCs9uE; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="HHRCs9uE"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VNRT0w3486398;
	Mon, 1 Jun 2026 03:30:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=G
	59hIfuDz7mq+uXtmjsr9zNUvmAoyjR4f7YbtRNCM5Y=; b=HHRCs9uEeRJXhfdFT
	vkO79G+JCZYt/K1mDYZ+RrVngs0C1s0SCb+oL4i6ZxVODq3L/yfmbOWzcvmJkv7j
	LAD8UY5xKrzOOicd2MNenHL4edDPPVn1XwQwDJmmLKlKP4aKddqXDoQEjNIx63jA
	meYhP0DVM6kBqMfyzUl1diFyLDLF6j5AQGUvfzdwuP72KDFjwCN5CYcjccbRzzrJ
	D3g8nFaRyx1hgv2BCifO01GRp80CthYu6NxaSk3Molk7oBnXf/afMp+yMeR3utv/
	nTPtDR87hzRoaTSGCmkdthVm5v8Tg5ofhzAj2DIibPZ6pB+wq4CanhUWSiBoC8Ep
	Z8TVw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4eggn8b8w9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:30:55 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:30:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:30:54 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id CFDB03F7053;
	Mon,  1 Jun 2026 03:30:51 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 32/44] scsi: qla2xxx: Update handling of ELS IOCBs for 29xx series
Date: Mon, 1 Jun 2026 15:58:41 +0530
Message-ID: <20260601102853.328426-33-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: IdROROe-yBGDiXo8gqwwApV7Dog0ejMK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfXzvRM2C//UhMj
 SEKUwjRBnkqCC8fvjHEvgwXxFi+qt86uz9aKOUF6OUAvzPIi8C2The+hnUuqRcRlvvwGD+sRbQ+
 dHKsoT7Nr1coawWEk78+FkTsDAbDkgoG3PKM7WyRl7ktrUlNL/nVJX14TE/N90IXdl9r3VPIVvg
 GItC/mqhy3fbldBxwn4iLE+TW5osv/kKs+dCX7ivkuXFI+RxRExDGp+ITiv3KkTJIkf301smdTh
 GWed9t/S1LZV5RzoZ8KPLIIF7TDLfNRK6ZZHYYGKu/m2zAgoNFKnGEgjqLCtdsPxzrzg7IHqI9z
 kNWNQiXxJBReMhgSrpguTNEDHfk6e/HditupK1x9mtrzasMyRjA/H4n92xOuqPzq894mc7KZ2ZV
 KvGG5uquDqnmUKBJC+XTUeNyRS0yz26bI4rb9KdFm4/z+3r1RZHXPOUtZSjL8dWlSaoGbvKzlP6
 I5yas6Dij2OtigdfCdg==
X-Proofpoint-GUID: IdROROe-yBGDiXo8gqwwApV7Dog0ejMK
X-Authority-Analysis: v=2.4 cv=ON0XGyaB c=1 sm=1 tr=0 ts=6a1d5f5f cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=_nWVH5cHqnzpQDwIf0YA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

Update ELS IOCB handling to support the extended 128-byte
els_entry_24xx_ext structure used by 29xx series adapters.

Change the signatures of qla24xx_els_logo_iocb(), qla_els_pt_iocb(),
and qla24xx_els_iocb() to accept a generic void pointer, enabling
differentiation between standard and extended ELS structures at
runtime.

Introduce a static inline helper qla_els_set_vp_sof() in qla_inline.h
that centralises the 24xx-vs-29xx vp_index/sof_type encoding: the 24xx
layout uses separate u8 vp_index + u8 sof_type (EST_SOFI3), while
29xx uses a __le16 with bitfields (vp_index:9 / sof_type:4 /
ELS_EXT_EST_SOFI3).  All ELS issue paths now call this helper instead
of open-coding the branch, including the RDP response path in qla_os.c.

In qla2x00_start_sp(), collapse the IS_QLA29XX() branch for the
handle assignment in SRB_ELS_CMD_HST_NOLOGIN: els_entry_24xx::handle
and els_entry_24xx_ext::handle are both u32 at offset 4, so a single
24xx-view write is layout-compatible with both strides.

DMA allocations in qla24xx_process_abts() and
qla24xx_process_purex_rdp() are updated to use the correct size for
the adapter type.  A BUILD_BUG_ON is added to verify the extended
structure size.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h    |  2 +-
 drivers/scsi/qla2xxx/qla_inline.h | 28 ++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_iocb.c   | 28 ++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_isr.c    | 26 ++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_os.c     | 29 +++++++++++++++++++----------
 5 files changed, 84 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 7b4172ebbb5c..8afce623516f 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -295,7 +295,7 @@ void qla_adjust_buf(struct scsi_qla_host *);
  * Global Function Prototypes in qla_iocb.c source file.
  */
 void qla_els_pt_iocb(struct scsi_qla_host *vha,
-	struct els_entry_24xx *pkt, struct qla_els_pt_arg *a);
+	void *pkt, struct qla_els_pt_arg *a);
 cont_a64_entry_t *qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *vha,
 		struct req_que *que);
 struct cont_a64_entry_ext *qla2900_prep_cont_type1_iocb(scsi_qla_host_t *vha,
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 7e353ac8e66c..da4753b4d769 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -847,3 +847,31 @@ qla_sts_fwi2_extract(struct qla_hw_data *ha, void *pkt,
 		host_to_fcp_swap(s->data, sizeof(s->data));
 	}
 }
+
+/*
+ * qla_els_set_vp_sof() - write the vp_index / sof_type pair into an ELS
+ *    pass-through IOCB (els_entry_24xx{,_ext}).
+ *
+ * Both layouts have the same 16-bit slot at offset 14, but it is encoded
+ * differently:
+ *   - 24xx: separate u8 vp_index + u8 sof_type with EST_SOFI3 (1 << 4)
+ *   - 29xx: __le16 with bitfields { vp_index:9, reserved_1_sof:3,
+ *           sof_type:4 } and ELS_EXT_EST_SOFI3
+ * so this is the single point in the driver that knows about that
+ * encoding split.
+ */
+static inline void
+qla_els_set_vp_sof(struct scsi_qla_host *vha, void *pkt, u8 vp_idx)
+{
+	if (IS_QLA29XX(vha->hw)) {
+		struct els_entry_24xx_ext *ext = pkt;
+
+		ext->vp_index = vp_idx;
+		ext->sof_type = ELS_EXT_EST_SOFI3;
+	} else {
+		struct els_entry_24xx *e = pkt;
+
+		e->vp_index = vp_idx;
+		e->sof_type = EST_SOFI3;
+	}
+}
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 782ba94a0293..5c11f01d5c21 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2904,8 +2904,9 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 }
 
 static void
-qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
+qla24xx_els_logo_iocb(srb_t *sp, void *pkt)
 {
+	struct els_entry_24xx *els_iocb = pkt;
 	scsi_qla_host_t *vha = sp->vha;
 	struct srb_iocb *elsio = &sp->u.iocb_cmd;
 
@@ -2916,11 +2917,11 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 	els_iocb->handle = sp->handle;
 	els_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
 	els_iocb->tx_dsd_count = cpu_to_le16(1);
-	els_iocb->vp_index = vha->vp_idx;
-	els_iocb->sof_type = EST_SOFI3;
 	els_iocb->rx_dsd_count = 0;
 	els_iocb->opcode = elsio->u.els_logo.els_cmd;
 
+	qla_els_set_vp_sof(vha, pkt, vha->vp_idx);
+
 	els_iocb->d_id[0] = sp->fcport->d_id.b.al_pa;
 	els_iocb->d_id[1] = sp->fcport->d_id.b.area;
 	els_iocb->d_id[2] = sp->fcport->d_id.b.domain;
@@ -3251,9 +3252,10 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 
 /* it is assume qpair lock is held */
 void qla_els_pt_iocb(struct scsi_qla_host *vha,
-	struct els_entry_24xx *els_iocb,
-	struct qla_els_pt_arg *a)
+	void *pkt, struct qla_els_pt_arg *a)
 {
+	struct els_entry_24xx *els_iocb = pkt;
+
 	els_iocb->entry_type = ELS_IOCB_TYPE;
 	els_iocb->entry_count = 1;
 	els_iocb->sys_define = 0;
@@ -3262,11 +3264,11 @@ void qla_els_pt_iocb(struct scsi_qla_host *vha,
 	els_iocb->nport_handle = a->nport_handle;
 	els_iocb->rx_xchg_address = a->rx_xchg_address;
 	els_iocb->tx_dsd_count = cpu_to_le16(1);
-	els_iocb->vp_index = a->vp_idx;
-	els_iocb->sof_type = EST_SOFI3;
 	els_iocb->rx_dsd_count = cpu_to_le16(0);
 	els_iocb->opcode = a->els_opcode;
 
+	qla_els_set_vp_sof(vha, pkt, a->vp_idx);
+
 	els_iocb->d_id[0] = a->did.b.al_pa;
 	els_iocb->d_id[1] = a->did.b.area;
 	els_iocb->d_id[2] = a->did.b.domain;
@@ -3287,8 +3289,9 @@ void qla_els_pt_iocb(struct scsi_qla_host *vha,
 }
 
 static void
-qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
+qla24xx_els_iocb(srb_t *sp, void *pkt)
 {
+	struct els_entry_24xx *els_iocb = pkt;
 	struct bsg_job *bsg_job = sp->u.bsg_job;
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 
@@ -3299,8 +3302,8 @@ qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
         els_iocb->handle = sp->handle;
 	els_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
 	els_iocb->tx_dsd_count = cpu_to_le16(bsg_job->request_payload.sg_cnt);
-	els_iocb->vp_index = sp->vha->vp_idx;
-        els_iocb->sof_type = EST_SOFI3;
+
+	qla_els_set_vp_sof(sp->vha, pkt, sp->vha->vp_idx);
 	els_iocb->rx_dsd_count = cpu_to_le16(bsg_job->reply_payload.sg_cnt);
 
 	els_iocb->opcode =
@@ -4132,6 +4135,11 @@ qla2x00_start_sp(srb_t *sp)
 		break;
 	case SRB_ELS_CMD_HST_NOLOGIN:
 		qla_els_pt_iocb(sp->vha, pkt,  &sp->u.bsg_cmd.u.els_arg);
+		/*
+		 * els_entry_24xx::handle and els_entry_24xx_ext::handle are
+		 * both u32 at offset 4, so a 24xx-view write is layout-
+		 * compatible with both strides.
+		 */
 		((struct els_entry_24xx *)pkt)->handle = sp->handle;
 		break;
 	case SRB_CT_CMD:
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 9b93f1d5ca4f..a3be142b9d1c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -83,6 +83,8 @@ qla24xx_process_abts(struct scsi_qla_host *vha, struct purex_item *pkt)
 	dma_addr_t dma;
 	uint32_t fctl;
 	int rval;
+	void *rsp_pkt;
+	size_t rsp_sz;
 
 	ql_dbg(ql_dbg_init, vha, 0x0286, "%s: entered.\n", __func__);
 
@@ -95,15 +97,22 @@ qla24xx_process_abts(struct scsi_qla_host *vha, struct purex_item *pkt)
 	ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, vha, 0x0287,
 	    (uint8_t *)abts, sizeof(*abts));
 
-	rsp_els = dma_alloc_coherent(&ha->pdev->dev, sizeof(*rsp_els), &dma,
+	if (IS_QLA29XX(ha))
+		rsp_sz = sizeof(struct els_entry_24xx_ext);
+	else
+		rsp_sz = sizeof(struct els_entry_24xx);
+
+	rsp_pkt = dma_alloc_coherent(&ha->pdev->dev, rsp_sz, &dma,
 	    GFP_KERNEL);
-	if (!rsp_els) {
+	if (!rsp_pkt) {
 		ql_log(ql_log_warn, vha, 0x0287,
 		    "Failed allocate dma buffer ABTS/ELS RSP.\n");
 		return;
 	}
+	rsp_els = rsp_pkt;
 
 	/* terminate exchange */
+	memset(rsp_pkt, 0, rsp_sz);
 	rsp_els->entry_type = ELS_IOCB_TYPE;
 	rsp_els->entry_count = 1;
 	rsp_els->nport_handle = cpu_to_le16(~0);
@@ -115,8 +124,8 @@ qla24xx_process_abts(struct scsi_qla_host *vha, struct purex_item *pkt)
 	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x0283,
 	    "-------- ELS RSP -------\n");
 	ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, vha, 0x0283,
-	    (uint8_t *)rsp_els, sizeof(*rsp_els));
-	rval = qla2x00_issue_iocb(vha, rsp_els, dma, 0);
+	    (uint8_t *)rsp_pkt, rsp_sz);
+	rval = qla2x00_issue_iocb(vha, rsp_pkt, dma, 0);
 	if (rval) {
 		ql_log(ql_log_warn, vha, 0x0288,
 		    "%s: iocb failed to execute -> %x\n", __func__, rval);
@@ -131,7 +140,7 @@ qla24xx_process_abts(struct scsi_qla_host *vha, struct purex_item *pkt)
 	}
 
 	/* send ABTS response */
-	abts_rsp = (void *)rsp_els;
+	abts_rsp = rsp_pkt;
 	memset(abts_rsp, 0, sizeof(*abts_rsp));
 	abts_rsp->entry_type = ABTS_RSP_TYPE;
 	abts_rsp->entry_count = 1;
@@ -182,7 +191,7 @@ qla24xx_process_abts(struct scsi_qla_host *vha, struct purex_item *pkt)
 		    "%s: done.\n", __func__);
 	}
 
-	dma_free_coherent(&ha->pdev->dev, sizeof(*rsp_els), rsp_els, dma);
+	dma_free_coherent(&ha->pdev->dev, rsp_sz, rsp_pkt, dma);
 }
 
 /**
@@ -2395,7 +2404,8 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 	case SRB_ELS_CMD_HST_NOLOGIN:
 		type = "els";
 		{
-			struct els_entry_24xx *els = (void *)pkt;
+			__le16 ctl_flags =
+				((struct els_entry_24xx *)pkt)->control_flags;
 			struct qla_bsg_auth_els_request *p =
 				(struct qla_bsg_auth_els_request *)bsg_job->request;
 
@@ -2405,7 +2415,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 			     e->d_id[2], e->d_id[1], e->d_id[0],
 			     comp_status, p->e.extra_rx_xchg_address, bsg_job);
 
-			if (!(le16_to_cpu(els->control_flags) & ECF_PAYLOAD_DESCR_MASK)) {
+			if (!(le16_to_cpu(ctl_flags) & ECF_PAYLOAD_DESCR_MASK)) {
 				if (sp->remap.remapped) {
 					n = sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 						bsg_job->reply_payload.sg_cnt,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4718d9b01877..c8f2d83dd872 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6203,6 +6203,8 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
 	uint rsp_payload_length = sizeof(*rsp_payload);
 	uint8_t vp_idx;
 	size_t purex_sz;
+	size_t rsp_els_sz;
+	void *rsp_els_pkt = NULL;
 	int rval;
 
 	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x0180,
@@ -6230,13 +6232,19 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
 		    rsp_payload_length);
 	}
 
-	rsp_els = dma_alloc_coherent(&ha->pdev->dev, sizeof(*rsp_els),
+	if (IS_QLA29XX(ha))
+		rsp_els_sz = sizeof(struct els_entry_24xx_ext);
+	else
+		rsp_els_sz = sizeof(struct els_entry_24xx);
+
+	rsp_els_pkt = dma_alloc_coherent(&ha->pdev->dev, rsp_els_sz,
 	    &rsp_els_dma, GFP_KERNEL);
-	if (!rsp_els) {
+	if (!rsp_els_pkt) {
 		ql_log(ql_log_warn, vha, 0x0183,
-		    "Failed allocate dma buffer ELS RSP.\n");
+		    "Failed to allocate dma buffer ELS RSP.\n");
 		goto dealloc;
 	}
+	rsp_els = rsp_els_pkt;
 
 	rsp_payload = dma_alloc_coherent(&ha->pdev->dev, sizeof(*rsp_payload),
 	    &rsp_payload_dma, GFP_KERNEL);
@@ -6260,12 +6268,12 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
 	rsp_els->handle = 0;
 	rsp_els->nport_handle = purex->nport_handle;
 	rsp_els->tx_dsd_count = cpu_to_le16(1);
-	rsp_els->vp_index = vp_idx;
-	rsp_els->sof_type = EST_SOFI3;
 	rsp_els->rx_xchg_address = purex->rx_xchg_addr;
 	rsp_els->rx_dsd_count = 0;
 	rsp_els->opcode = purex->els_frame_payload[0];
 
+	qla_els_set_vp_sof(vha, rsp_els_pkt, vp_idx);
+
 	rsp_els->d_id[0] = purex->s_id[0];
 	rsp_els->d_id[1] = purex->s_id[1];
 	rsp_els->d_id[2] = purex->s_id[2];
@@ -6565,13 +6573,13 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
 	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x0184,
 	    "-------- ELS RSP -------\n");
 	ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, vha, 0x0185,
-	    rsp_els, sizeof(*rsp_els));
+	    rsp_els_pkt, rsp_els_sz);
 	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x0186,
 	    "-------- ELS RSP PAYLOAD -------\n");
 	ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, vha, 0x0187,
 	    rsp_payload, rsp_payload_length);
 
-	rval = qla2x00_issue_iocb(vha, rsp_els, rsp_els_dma, 0);
+	rval = qla2x00_issue_iocb(vha, rsp_els_pkt, rsp_els_dma, 0);
 
 	if (rval) {
 		ql_log(ql_log_warn, vha, 0x0188,
@@ -6595,9 +6603,9 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
 	if (rsp_payload)
 		dma_free_coherent(&ha->pdev->dev, sizeof(*rsp_payload),
 		    rsp_payload, rsp_payload_dma);
-	if (rsp_els)
-		dma_free_coherent(&ha->pdev->dev, sizeof(*rsp_els),
-		    rsp_els, rsp_els_dma);
+	if (rsp_els_pkt)
+		dma_free_coherent(&ha->pdev->dev, rsp_els_sz,
+		    rsp_els_pkt, rsp_els_dma);
 }
 
 void
@@ -8366,6 +8374,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct device_reg_82xx) != 1288);
 	BUILD_BUG_ON(sizeof(struct device_reg_fx00) != 216);
 	BUILD_BUG_ON(sizeof(struct els_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct els_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct els_sts_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct fxdisc_entry_fx00) != 64);
 	BUILD_BUG_ON(sizeof(struct imm_ntfy_from_isp) != 64);
-- 
2.47.3

