Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760D215278E
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302240; cv=none; b=CMDicKADtBiog0eZEcOhyz3Ex7T3PYA0RKvn5s78HoMjapk9n71KpbBgrSQpjHJPD2GQh5Lfj1FMucnD+o4+7fXfN4ihhMegx87oUZCSl2NFMPZwi9rIusRZL9t5O3AJRqFKNDKpdAQZsvL/3yOcDn7YuNsCPa+/phVviKlSFMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302240; c=relaxed/simple;
	bh=MQhs+DWM01wbdZ54CgmPdsWChSmJ5xaQdB1lqaC1+uQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gQ/qt3k+rBTMdewjUuJI+vJODbilDbxh7z1z7bL9HUN361EoRDHiCcs+J2PsUs+JtY4QxEUWsj9EsUHkhJ2MrRVArywRPvRW/0Jbzr0dfJtSosG5XMmE2EMHlK94KWYjvMYCTVoOqAjvDCq4e0pm832nAHnk6S4HeXC/ieyZUek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=FVCBaI1W; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="FVCBaI1W"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE5qmZ113130;
	Fri, 17 Jul 2026 08:30:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=+
	34pS/g09xATwVTYmO3PnsXQtMeJIj00P8HEwRjId3g=; b=FVCBaI1WQXXEz3/p5
	+OlP/AUl8FuIpfHtc+Yp427nW8A+PXjHp+mWGNo2ZNujqOWbFzgVWjODF86cmN7g
	6hLrN85uMwwyzCmC4br0923AmOIosASu4IhTMsEMpH8Cxsb1degaBuUtxxUyZ3Ap
	lN5uriEzWnJUKCJMvBqeJQ8Lf5cGSviK5ED7IosOpWYUsph5FrqeRMmLQQWz8okk
	YfbshUlww6cHGe3vgp/tOHlZM6w4UzVq9LfhKk47H0DyZ/BXTyIR5S2ePVC3mdMQ
	OQ4fpSnM2zGigl8bYY3hP2odV2xAe9FIhMpJYAmI+do1k7SfYpJJdCf3jEKfn1UY
	Nu2Yg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fetcbn17a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:30:34 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:30:33 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:30:33 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 1F3145B693B;
	Fri, 17 Jul 2026 08:30:30 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 29/56] scsi: qla2xxx: Update handling of ELS IOCBs for 29xx series
Date: Fri, 17 Jul 2026 20:58:37 +0530
Message-ID: <20260717152904.3155730-30-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260717152904.3155730-1-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: A6iVFlSX5iqydOWM5fZ1C2ed105ihGSY
X-Authority-Analysis: v=2.4 cv=Y7jIdBeN c=1 sm=1 tr=0 ts=6a5a4a9a cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=_nWVH5cHqnzpQDwIf0YA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfXzKCE0is4PNte
 X1eYDpfpW2a/I3T71ojhDoV05L7RmNv6n5c7Io8TGWBFt4x/lZXD2NQ/Bq2dS5lHNi/kJQ7tB22
 NGxq2qpm5x8u1VlJSIFwuQ/fnnvi8IU=
X-Proofpoint-GUID: A6iVFlSX5iqydOWM5fZ1C2ed105ihGSY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX3lYgiw6bsyCb
 VBts+ONDegd2fRUpRb0PgqACKXZwJay3D1jjX7wBkGsEPWSYcSulOt9Dt1/eVuVdOuHR/bb1bdN
 PtZVXT4rnH/xuYB72aBHQwfiUO8gmgfoY/7oy1Io+hSlrOlCe7D80A1tzXGMY+RSq7NkKIb8Jep
 A0qZhtkdq5VfmLbfV1D2rVGyC6rBk9MMv+glDxJmg7rJOoIf61Yuyz9mXcwyCEIhdNIolC8FJzR
 5+720BUnbcxASoWQBGJMbHA8/bqkG15+tmIWiGXwGoJ0iwkn9u252qpqNhku7LgbwFNkAwtg+f1
 nKUjjkWn5ZJGFhY1qZXnUTyhvk5MvgLu1oakxQSOxREb6xB8p2LQlgAsmGYHoi/dhjt5kTaZX+3
 drK2dCXBF7hep73Ofku70zDQ0s10gCES2XGghPo551tEgcl9Q3b0Wq4kyXOlBkLFK8BvYcz7/Az
 st4yPyrLpSzJwfCoqpA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h    |  2 +-
 drivers/scsi/qla2xxx/qla_inline.h | 28 ++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_iocb.c   | 28 ++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_isr.c    | 26 ++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_os.c     | 31 ++++++++++++++++++++-----------
 5 files changed, 85 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 5d5ee3ee321f..9db6efaa6c4d 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -295,7 +295,7 @@ void qla_adjust_buf(struct scsi_qla_host *);
  * Global Function Prototypes in qla_iocb.c source file.
  */
 void qla_els_pt_iocb(struct scsi_qla_host *vha,
-	struct els_entry_24xx *pkt, struct qla_els_pt_arg *a);
+	void *pkt, struct qla_els_pt_arg *a);
 cont_a64_entry_t *qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *vha,
 		struct qla_hw_data *ha, struct req_que *que);
 struct cont_a64_entry_ext *qla2900_prep_cont_type1_iocb(scsi_qla_host_t *vha,
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 49b858e7cf2a..2ade5e852251 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -863,3 +863,31 @@ qla_sts_fwi2_extract(struct qla_hw_data *ha, void *pkt,
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
+qla_els_set_vp_sof(struct scsi_qla_host *vha, void *pkt, u16 vp_idx)
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
index 7315bc4df00e..ab4f5f1ec73f 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2975,8 +2975,9 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 }
 
 static void
-qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
+qla24xx_els_logo_iocb(srb_t *sp, void *pkt)
 {
+	struct els_entry_24xx *els_iocb = pkt;
 	scsi_qla_host_t *vha = sp->vha;
 	struct srb_iocb *elsio = &sp->u.iocb_cmd;
 
@@ -2987,11 +2988,11 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
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
@@ -3322,9 +3323,10 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 
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
@@ -3333,11 +3335,11 @@ void qla_els_pt_iocb(struct scsi_qla_host *vha,
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
@@ -3358,8 +3360,9 @@ void qla_els_pt_iocb(struct scsi_qla_host *vha,
 }
 
 static void
-qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
+qla24xx_els_iocb(srb_t *sp, void *pkt)
 {
+	struct els_entry_24xx *els_iocb = pkt;
 	struct bsg_job *bsg_job = sp->u.bsg_job;
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 
@@ -3370,8 +3373,8 @@ qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
         els_iocb->handle = sp->handle;
 	els_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
 	els_iocb->tx_dsd_count = cpu_to_le16(bsg_job->request_payload.sg_cnt);
-	els_iocb->vp_index = sp->vha->vp_idx;
-        els_iocb->sof_type = EST_SOFI3;
+
+	qla_els_set_vp_sof(sp->vha, pkt, sp->vha->vp_idx);
 	els_iocb->rx_dsd_count = cpu_to_le16(bsg_job->reply_payload.sg_cnt);
 
 	els_iocb->opcode =
@@ -4203,6 +4206,11 @@ qla2x00_start_sp(srb_t *sp)
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
index 75ce09933afc..404dcb24b688 100644
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
@@ -2385,7 +2394,8 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 	case SRB_ELS_CMD_HST_NOLOGIN:
 		type = "els";
 		{
-			struct els_entry_24xx *els = (void *)pkt;
+			__le16 ctl_flags =
+				((struct els_entry_24xx *)pkt)->control_flags;
 			struct qla_bsg_auth_els_request *p =
 				(struct qla_bsg_auth_els_request *)bsg_job->request;
 
@@ -2395,7 +2405,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 			     e->d_id[2], e->d_id[1], e->d_id[0],
 			     comp_status, p->e.extra_rx_xchg_address, bsg_job);
 
-			if (!(le16_to_cpu(els->control_flags) & ECF_PAYLOAD_DESCR_MASK)) {
+			if (!(le16_to_cpu(ctl_flags) & ECF_PAYLOAD_DESCR_MASK)) {
 				if (sp->remap.remapped) {
 					n = sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 						bsg_job->reply_payload.sg_cnt,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c327d053f8ee..74bf203f8d9f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6211,8 +6211,10 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
 	uint8_t *sfp = NULL;
 	uint16_t sfp_flags = 0;
 	uint rsp_payload_length = sizeof(*rsp_payload);
-	uint8_t vp_idx;
+	u16 vp_idx;
 	size_t purex_sz;
+	size_t rsp_els_sz;
+	void *rsp_els_pkt = NULL;
 	int rval;
 
 	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x0180,
@@ -6240,13 +6242,19 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
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
@@ -6270,12 +6278,12 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
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
@@ -6575,13 +6583,13 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
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
@@ -6605,9 +6613,9 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
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
@@ -8376,6 +8384,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct device_reg_82xx) != 1288);
 	BUILD_BUG_ON(sizeof(struct device_reg_fx00) != 216);
 	BUILD_BUG_ON(sizeof(struct els_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct els_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct els_sts_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct fxdisc_entry_fx00) != 64);
 	BUILD_BUG_ON(sizeof(struct imm_ntfy_from_isp) != 64);
-- 
2.47.3

