Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F074A38399E
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258158; cv=none; b=IUgv0XHI4x+WSCJXYGgUU10/X9Qs51F6HRSmw+bmukFj3MT4idJ+9uzOFeQipR8zQNvsNtV0idWm2xcuWM90n1i6mWfrDvZVhYE8dY9taB4b45ymEfhY6hmRuxMMwAgQ2/MhdJXvXwBbxpaKV4jXfDSNwp+xhDrIUr2pdrd+VYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258158; c=relaxed/simple;
	bh=o51nEdNvvYQ2kWO28Lc+V4AXe0uIE84KYaz7b1MuOCU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kG7mpjsuqd7J1XTlZxWwW1efWJaTSllYlPZ/6wpBOsBVQ2AT6H00r1oKewL//jnuMZtXZVWnNU3ssw8/ucKBzFQQDmRW5mWaYW/U+WXQO5QnA8CGGOhynuTA0DNVmJpaIY/VhGobiXvS8L4yF7YKd+kOEcAkYQQKIV0M/Ncya7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=G7Od57Vk; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="G7Od57Vk"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C39QF53679059;
	Fri, 12 Jun 2026 02:55:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=8
	BRDMTAvdRBQu2zRWNA6j46/o4iQfI+xyoyQEnAGbOc=; b=G7Od57VkJwk6st71v
	IB9BF7Fq0GmjzxvUCOZ9xcApk/vbCoUTBOPMLaqCyH3NP2rKuZSdjNXRxc9nGi7e
	Ay8wPCVW0gnnpsmA31t+Ppj+37iYV6zjR/bKYH+WVvP1hnDpJ6YD70hxqPiCJt5D
	8MAnsd95NkpObTBYZjP/gcrV7bpaPuTB4QkKyJf1bQ4yoh0mAOyJ1wDJvtRlfnRb
	8S5c8RJp/Sn4JjN4OhrUYSNJfPQHAIn3itfd8g6ggbr+okwX1VkDDD6lEJ4nvj2S
	+q/adDPgUpH/idSSR8KBTKq/Qp4NtWR37gUosGQFSHNvdQwdgVYtIom3+2g8GwmZ
	P47Nw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4er9qn92mc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:55:53 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:55:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:55:52 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id C87733F7040;
	Fri, 12 Jun 2026 02:55:49 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 37/60] scsi: qla2xxx: Enhance ABTS processing for 29xx series
Date: Fri, 12 Jun 2026 15:23:10 +0530
Message-ID: <20260612095333.1666592-38-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: j5qFpH0HvYye9kCmpGWgaZmPCPUaUuWy
X-Authority-Analysis: v=2.4 cv=Y9HIdBeN c=1 sm=1 tr=0 ts=6a2bd7a9 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=T1xl5BmS7sXS1TMlQ_kA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX3ghHjWmJPnvO
 YoCQfG3C29TVoSJBaFGgXkMB48Ek0mTwy+8O1WW9gyvbUfQKvBGLoGh3eSYG5gN2tOIVjBi3DFR
 CGYc7Z5cveD/RrxqX/nGKjDPZ1Ti8dY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX+TJ75N81AWGr
 AHqFNPin2KyGXUvLN/urM7dCnjvneHl79og13wJC0x3h08/AEmWL6IB6ISXozljRqlFE9gX7bmy
 3fYzHj8qJb/G80y/WAxSUs5WVoFQ0Jamf+rsY+clK6kwDqiE9OBKn5iBaHhniVmHk1Vq+ybay98
 s6HGs7+UPaxkFzO2bATCO+MAEd8dIP/aTuwidPFMrgiBSQUKMzVmr3xCPbMRLH97rGiK5q32IbL
 Ut+HMxefFaRcAu+auZXhttnlLyrjPd/5nPIbRqiRkAcHr3dUM2VrtI4pvmlB0SbeSDMpZjf1n5T
 n7YwMEEx6Un2reQaIBwC1SfiVGtwoBLZyHhO3GYDw9cMwuxNVTBPcAssfUz+WN1IRNl+mfEkw6d
 JiVfKAV5vpkqp44qsPvD5EnFamqvLzhVM7rLj2PIla8MS3+w8s3kRAjhm01ghXYmh+NXIICDHT1
 aaHr79ehorl+E/j20JQ==
X-Proofpoint-GUID: j5qFpH0HvYye9kCmpGWgaZmPCPUaUuWy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

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
---
 drivers/scsi/qla2xxx/qla_isr.c | 167 ++++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_os.c  |   1 +
 2 files changed, 104 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5b5ccf207535..284d874392fd 100644
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
index a0191bf0e9fd..24a066b304d9 100644
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

