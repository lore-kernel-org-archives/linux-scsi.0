Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A706533DED9
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403804; cv=none; b=SvzkPVqEPT9NX4ShLuw5bQ7APtLWsxgRHnCY4kC6jTk5bvuqR16r0VSVwRv/VV92N9tr+ocrCv9+ZVitEmF1QN2y90X0+pOiZfF100MXT7mPZJ8HH3HhcQ/Xx5ZMdkHHclNcoVJQI30dh1LwhksJFwDPXfuGZzEDAA6BGosmhN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403804; c=relaxed/simple;
	bh=6I4OXdZ4w1bnQWOelo9QFa3zrV9JFDcsSSiUSjJedRo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jeJUnM3afH0pMKc8er6gB4kWw73Rcri+9Xkh8NFTQcw2hfwkMGzz/YV5D5FDgs0BSBTzlJpHX2RE99+ez0fRjbIItBFPy7bGq0fpa+oRTpGxnxO68C90fIAXpQWITJ6GQBr1YcPBE2SUuIwqZMcvA2Xcvkl3pPqgc64WXCB9tMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=attVpiO4; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="attVpiO4"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748kW01656479;
	Mon, 6 Jul 2026 22:56:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=d
	q0r5yO72mQ2fW/QnGYRLA+0qY8YvCWesgwl6vTgDc4=; b=attVpiO4QUVXBvVFT
	knqm+FNrJ/8X2hCnpPRj0HkwzGZhX1GFtjyh0oRivOGld8wnuszd/zm3Ke3FoBui
	bSepBXRzhZ11QVF7NItnHBRXYJn8RJWmiqxOdh20qrmY0QeTclCtSKcKgkJesBSm
	+obbQ5YBYEsX2nZ1pYrJoTl2E2tf6AjE/JvR46CW+grtDaoagfBhbWWRiSpidCVF
	2u5ne8z7Vw1zfGY9XAn8dGS7RnSPMRDRn93Ay5/nf84xPHPctZfisO6mGnc4ReRO
	qTWC+tLtbACapMcdsCDmOsKKPQRHSOqJU2I46ftiZRgiWUnyAQdD5I35e8ly82Yq
	YfgQw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqdwb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:56:39 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:56:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:56:39 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 9508D3F7066;
	Mon,  6 Jul 2026 22:56:36 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 34/88] scsi: qla2xxx: Enhance ABTS processing for 29xx series
Date: Tue, 7 Jul 2026 11:23:41 +0530
Message-ID: <20260707055435.2680300-35-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260707055435.2680300-1-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: bzc9J4oTzVHRrUiZHsAEeT1skTzMxQK9
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c9518 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=T1xl5BmS7sXS1TMlQ_kA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: bzc9J4oTzVHRrUiZHsAEeT1skTzMxQK9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX6pYjUl6uL0HV
 ct8e4OqPUAZ2L5Ibcxv4Cdg6VhcvafSbYWhQHUrsBLJMwYYu96c3LTRNkk2p9zIGQ0CgfDbc6gj
 ShPNSD/fPhL9raljmnyKxpyBEiD7nz4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX0aenaqKz2ICw
 EXv+TxzuCs9au+DQ0YACcubg0HSXpw/aorYLDiXgiQ8eypj6usIH6kvITvmkItwBzLck2+jBkmF
 rPEOE1vSskNYExZ3QnmFQTu8gum8qFDjAZKBWeqLR3Ebtc1YauDw0uqSeOtSk2DYNc//KnoxeEc
 k60T/6Chp/EzZhZvL2I8ZtsMpL8qyk86cqFZSL9NobseXxtjpYS76HIntkXMkEcMjd+2/OOgWKZ
 AKaiptgK1JJ+apNuNF7B3JOfQDtn5c+CWwwSBKL+NlGR6utpgQKXJ/kkQQ8C8HG5Q0PFCAO3ZCg
 RQ914zdiro1Q0MuTPE94OoDbLhOWqAhoNzjRfLnhHYG9O2cwGGompXrDZ2oX/1yvkvDVVrz98hv
 vmChs6VoWOclBvVOc6iBZ7XV8ACQm0BdW/J/C7W55FrL6vy6gri50oMbH8jgfgGrLkoiU+z7OZT
 IA0k1LuqtAD1+QoY7zg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

Use extended ABTS entry structures (abts_entry_24xx_ext) for 29xx
series adapters to properly handle the larger 128-byte IOCB format.

Introduce type-generic macros (QLA_LOG_ABTS_RCV, QLA_BUILD_ABTS_BA_ACC,
QLA_LOG_ISSUE_ABTS_RSP) that leverage the shared field names between
abts_entry_24xx and abts_entry_24xx_ext to avoid code duplication.
Branch on IS_QLA29XX() for receive logging, exchange termination, and
BA_ACC response construction, with each path passing the correctly
typed pointer to the shared macros. The sof_type handling difference
(direct for 29xx bitfield vs & 0xf0 mask for legacy) is parameterized
through the sof_val macro argument.

Add BUILD_BUG_ON size check for struct abts_entry_24xx_ext.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 167 ++++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_os.c  |   1 +
 2 files changed, 104 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index dd4416a3bf3a..774ccf6b2adc 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -72,15 +72,89 @@ static inline void display_Laser_info(scsi_qla_host_t *vha,
 		       mb3);
 }
 
+/*
+ * Type-generic helpers for qla24xx_process_abts().
+ * Both abts_entry_24xx and abts_entry_24xx_ext share field names for all
+ * accessed fields, so these macros expand correctly for either type.
+ */
+#define QLA_LOG_ABTS_RCV(vha, abts_ptr) do {				\
+	ql_log(ql_log_warn, (vha), 0x0287,				\
+	    "Processing ABTS xchg=%#x oxid=%#x rxid=%#x "		\
+	    "seqid=%#x seqcnt=%#x\n",					\
+	    (abts_ptr)->rx_xch_addr_to_abort, (abts_ptr)->ox_id,	\
+	    (abts_ptr)->rx_id, (abts_ptr)->seq_id,			\
+	    (abts_ptr)->seq_cnt);					\
+	ql_dbg(ql_dbg_init + ql_dbg_verbose, (vha), 0x0287,		\
+	    "-------- ABTS RCV -------\n");				\
+	ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, (vha), 0x0287,	\
+	    (uint8_t *)(abts_ptr), sizeof(*(abts_ptr)));		\
+} while (0)
+
+#define QLA_BUILD_ABTS_BA_ACC(rsp, src, sof_val, fctl) do {		\
+	memset((rsp), 0, sizeof(*(rsp)));				\
+	(rsp)->entry_type = ABTS_RSP_TYPE;				\
+	(rsp)->entry_count = 1;						\
+	(rsp)->nport_handle = (src)->nport_handle;			\
+	(rsp)->vp_idx = (src)->vp_idx;					\
+	(rsp)->sof_type = (sof_val);					\
+	(rsp)->rx_xch_addr = (src)->rx_xch_addr;			\
+	(rsp)->d_id[0] = (src)->s_id[0];				\
+	(rsp)->d_id[1] = (src)->s_id[1];				\
+	(rsp)->d_id[2] = (src)->s_id[2];				\
+	(rsp)->r_ctl = FC_ROUTING_BLD | FC_R_CTL_BLD_BA_ACC;		\
+	(rsp)->s_id[0] = (src)->d_id[0];				\
+	(rsp)->s_id[1] = (src)->d_id[1];				\
+	(rsp)->s_id[2] = (src)->d_id[2];				\
+	(rsp)->cs_ctl = (src)->cs_ctl;					\
+	(fctl) = ~((src)->f_ctl[2] | 0x7F) << 16 |			\
+	    FC_F_CTL_LAST_SEQ | FC_F_CTL_END_SEQ | FC_F_CTL_SEQ_INIT;	\
+	(rsp)->f_ctl[0] = (fctl) >> 0 & 0xff;				\
+	(rsp)->f_ctl[1] = (fctl) >> 8 & 0xff;				\
+	(rsp)->f_ctl[2] = (fctl) >> 16 & 0xff;				\
+	(rsp)->type = FC_TYPE_BLD;					\
+	(rsp)->rx_id = (src)->rx_id;					\
+	(rsp)->ox_id = (src)->ox_id;					\
+	(rsp)->payload.ba_acc.aborted_rx_id = (src)->rx_id;		\
+	(rsp)->payload.ba_acc.aborted_ox_id = (src)->ox_id;		\
+	(rsp)->payload.ba_acc.high_seq_cnt = cpu_to_le16(~0);		\
+	(rsp)->rx_xch_addr_to_abort = (src)->rx_xch_addr_to_abort;	\
+} while (0)
+
+#define QLA_LOG_ISSUE_ABTS_RSP(vha, rsp, dma, rval) do {		\
+	ql_dbg(ql_dbg_init, (vha), 0x028b,				\
+	    "Sending BA ACC response to ABTS %#x...\n",			\
+	    (rsp)->rx_xch_addr_to_abort);				\
+	ql_dbg(ql_dbg_init + ql_dbg_verbose, (vha), 0x028b,		\
+	    "-------- ELS RSP -------\n");				\
+	ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, (vha), 0x028b,	\
+	    (uint8_t *)(rsp), sizeof(*(rsp)));				\
+	(rval) = qla2x00_issue_iocb((vha), (rsp), (dma), 0);		\
+	if (rval) {							\
+		ql_log(ql_log_warn, (vha), 0x028c,			\
+		    "%s: iocb failed to execute -> %x\n",		\
+		    __func__, (rval));					\
+	} else if ((rsp)->comp_status) {				\
+		ql_log(ql_log_warn, (vha), 0x028d,			\
+		    "%s: iocb failed to complete -> "			\
+		    "completion=%#x subcode=(%#x,%#x)\n",		\
+		    __func__, (rsp)->comp_status,			\
+		    (rsp)->payload.error.subcode1,			\
+		    (rsp)->payload.error.subcode2);			\
+	} else {							\
+		ql_dbg(ql_dbg_init, (vha), 0x028ea,			\
+		    "%s: done.\n", __func__);				\
+	}								\
+} while (0)
+
 static void
 qla24xx_process_abts(struct scsi_qla_host *vha, struct purex_item *pkt)
 {
-	struct abts_entry_24xx *abts =
-	    (struct abts_entry_24xx *)&pkt->iocb;
 	struct qla_hw_data *ha = vha->hw;
+	struct abts_entry_24xx *abts = NULL;
+	struct abts_entry_24xx_ext *abts_ext = NULL;
 	struct els_entry_24xx *rsp_els;
-	struct abts_entry_24xx *abts_rsp;
 	dma_addr_t dma;
+	__le32 rx_xch_addr_to_abort;
 	uint32_t fctl;
 	int rval;
 	void *rsp_pkt;
@@ -88,19 +162,17 @@ qla24xx_process_abts(struct scsi_qla_host *vha, struct purex_item *pkt)
 
 	ql_dbg(ql_dbg_init, vha, 0x0286, "%s: entered.\n", __func__);
 
-	ql_log(ql_log_warn, vha, 0x0287,
-	    "Processing ABTS xchg=%#x oxid=%#x rxid=%#x seqid=%#x seqcnt=%#x\n",
-	    abts->rx_xch_addr_to_abort, abts->ox_id, abts->rx_id,
-	    abts->seq_id, abts->seq_cnt);
-	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x0287,
-	    "-------- ABTS RCV -------\n");
-	ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, vha, 0x0287,
-	    (uint8_t *)abts, sizeof(*abts));
-
-	if (IS_QLA29XX(ha))
+	if (IS_QLA29XX(ha)) {
+		abts_ext = (struct abts_entry_24xx_ext *)&pkt->iocb;
+		QLA_LOG_ABTS_RCV(vha, abts_ext);
 		rsp_sz = sizeof(struct els_entry_24xx_ext);
-	else
+		rx_xch_addr_to_abort = abts_ext->rx_xch_addr_to_abort;
+	} else {
+		abts = (struct abts_entry_24xx *)&pkt->iocb;
+		QLA_LOG_ABTS_RCV(vha, abts);
 		rsp_sz = sizeof(struct els_entry_24xx);
+		rx_xch_addr_to_abort = abts->rx_xch_addr_to_abort;
+	}
 
 	rsp_pkt = dma_alloc_coherent(&ha->pdev->dev, rsp_sz, &dma,
 	    GFP_KERNEL);
@@ -116,11 +188,11 @@ qla24xx_process_abts(struct scsi_qla_host *vha, struct purex_item *pkt)
 	rsp_els->entry_type = ELS_IOCB_TYPE;
 	rsp_els->entry_count = 1;
 	rsp_els->nport_handle = cpu_to_le16(~0);
-	rsp_els->rx_xchg_address = abts->rx_xch_addr_to_abort;
+	rsp_els->rx_xchg_address = rx_xch_addr_to_abort;
 	rsp_els->control_flags = cpu_to_le16(EPD_RX_XCHG);
 	ql_dbg(ql_dbg_init, vha, 0x0283,
 	    "Sending ELS Response to terminate exchange %#x...\n",
-	    abts->rx_xch_addr_to_abort);
+	    rx_xch_addr_to_abort);
 	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x0283,
 	    "-------- ELS RSP -------\n");
 	ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, vha, 0x0283,
@@ -140,60 +212,27 @@ qla24xx_process_abts(struct scsi_qla_host *vha, struct purex_item *pkt)
 	}
 
 	/* send ABTS response */
-	abts_rsp = rsp_pkt;
-	memset(abts_rsp, 0, sizeof(*abts_rsp));
-	abts_rsp->entry_type = ABTS_RSP_TYPE;
-	abts_rsp->entry_count = 1;
-	abts_rsp->nport_handle = abts->nport_handle;
-	abts_rsp->vp_idx = abts->vp_idx;
-	abts_rsp->sof_type = abts->sof_type & 0xf0;
-	abts_rsp->rx_xch_addr = abts->rx_xch_addr;
-	abts_rsp->d_id[0] = abts->s_id[0];
-	abts_rsp->d_id[1] = abts->s_id[1];
-	abts_rsp->d_id[2] = abts->s_id[2];
-	abts_rsp->r_ctl = FC_ROUTING_BLD | FC_R_CTL_BLD_BA_ACC;
-	abts_rsp->s_id[0] = abts->d_id[0];
-	abts_rsp->s_id[1] = abts->d_id[1];
-	abts_rsp->s_id[2] = abts->d_id[2];
-	abts_rsp->cs_ctl = abts->cs_ctl;
-	/* include flipping bit23 in fctl */
-	fctl = ~(abts->f_ctl[2] | 0x7F) << 16 |
-	    FC_F_CTL_LAST_SEQ | FC_F_CTL_END_SEQ | FC_F_CTL_SEQ_INIT;
-	abts_rsp->f_ctl[0] = fctl >> 0 & 0xff;
-	abts_rsp->f_ctl[1] = fctl >> 8 & 0xff;
-	abts_rsp->f_ctl[2] = fctl >> 16 & 0xff;
-	abts_rsp->type = FC_TYPE_BLD;
-	abts_rsp->rx_id = abts->rx_id;
-	abts_rsp->ox_id = abts->ox_id;
-	abts_rsp->payload.ba_acc.aborted_rx_id = abts->rx_id;
-	abts_rsp->payload.ba_acc.aborted_ox_id = abts->ox_id;
-	abts_rsp->payload.ba_acc.high_seq_cnt = cpu_to_le16(~0);
-	abts_rsp->rx_xch_addr_to_abort = abts->rx_xch_addr_to_abort;
-	ql_dbg(ql_dbg_init, vha, 0x028b,
-	    "Sending BA ACC response to ABTS %#x...\n",
-	    abts->rx_xch_addr_to_abort);
-	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x028b,
-	    "-------- ELS RSP -------\n");
-	ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, vha, 0x028b,
-	    (uint8_t *)abts_rsp, sizeof(*abts_rsp));
-	rval = qla2x00_issue_iocb(vha, abts_rsp, dma, 0);
-	if (rval) {
-		ql_log(ql_log_warn, vha, 0x028c,
-		    "%s: iocb failed to execute -> %x\n", __func__, rval);
-	} else if (abts_rsp->comp_status) {
-		ql_log(ql_log_warn, vha, 0x028d,
-		    "%s: iocb failed to complete -> completion=%#x subcode=(%#x,%#x)\n",
-		    __func__, abts_rsp->comp_status,
-		    abts_rsp->payload.error.subcode1,
-		    abts_rsp->payload.error.subcode2);
+	if (IS_QLA29XX(ha)) {
+		struct abts_entry_24xx_ext *rsp_ext = rsp_pkt;
+
+		QLA_BUILD_ABTS_BA_ACC(rsp_ext, abts_ext,
+		    abts_ext->sof_type, fctl);
+		QLA_LOG_ISSUE_ABTS_RSP(vha, rsp_ext, dma, rval);
 	} else {
-		ql_dbg(ql_dbg_init, vha, 0x028ea,
-		    "%s: done.\n", __func__);
+		struct abts_entry_24xx *abts_rsp = rsp_pkt;
+
+		QLA_BUILD_ABTS_BA_ACC(abts_rsp, abts,
+		    abts->sof_type & 0xf0, fctl);
+		QLA_LOG_ISSUE_ABTS_RSP(vha, abts_rsp, dma, rval);
 	}
 
 	dma_free_coherent(&ha->pdev->dev, rsp_sz, rsp_pkt, dma);
 }
 
+#undef QLA_LOG_ABTS_RCV
+#undef QLA_BUILD_ABTS_BA_ACC
+#undef QLA_LOG_ISSUE_ABTS_RSP
+
 /**
  * __qla_consume_iocb - this routine is used to tell fw driver has processed
  *   or consumed the head IOCB along with the continuation IOCB's from the
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d9141d62bbb5..5f11c46821c1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8361,6 +8361,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct abort_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct abort_iocb_entry_fx00) != 64);
 	BUILD_BUG_ON(sizeof(struct abts_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct abts_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct access_chip_84xx) != 64);
 	BUILD_BUG_ON(sizeof(struct access_chip_rsp_84xx) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_bidir) != 64);
-- 
2.47.3

