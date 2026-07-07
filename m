Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FA527466A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403782; cv=none; b=mcbr2PSCTqA+hqWi7IIlTLo4QmrjFgpwLluE/zbwhrQEXdEtcDsEmMvBnDdi8y3BJ2qsRnwJlb5X7YxCfy6XPIKUEWfzMrDOzjtAxNtc6iUNAidgUdwmMR8snbei+60rTdxWMBbCTre0XvkpElSeyfVF2OLhF/uo1SPnz+KiSKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403782; c=relaxed/simple;
	bh=raYVDgcto8+UIidof5+PGevIFhfnUlUwSFMceLHIOHo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HuUWTQbrpBeqDbEU5J1752LFVPRebVB+hqXJdTBbIn3whuFp5PIX6QVWVWjbAwEIczdwd4VCHel0PT1SwaNk+G2ch6O/6oJgDxRZC5G3jk8OS/kRIW5JewtEPzv6PqcLgx2swMBmIcI4G3tdNgtgo3DcUJePEd9XGAwJcX91wTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=BeZc6jD9; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="BeZc6jD9"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667483tc872835;
	Mon, 6 Jul 2026 22:56:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=u
	NTtviPdNU4y271er4E4/S4ObGaK/YMokcc6dgn/w3U=; b=BeZc6jD9qKdAG3sT8
	KKENM6yEFRNymQzLZur+x2nRzzDlex3Cv48omQQYeiQ7+6p9SSZ0+h1+v1V9+FXT
	4syGf/lECc49JMXU1AvD6PEd5U07Kqdz7Zzota2pZuHX9Gi9akDOsWIvp+kLHBgC
	4ONoktegxDE5IY0N2nTAVPPgHTPIReTzwwzBkuRysil4qDiTyz1pcHLEujnyL2CH
	SEytf9O9E776bzooU7CFV7SOxUX0Aw8wRJJeorm+y+kluQwcwVt2oqUfNP0TDGlz
	c5HExcc6yH2aCjOWjBNBEEsCaZvQnZW+pZNxLrunYjOXCtbsPcEIFHWJS2RHSyJC
	TEwWA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9waa28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:56:17 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:56:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:56:16 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id C87E53F7066;
	Mon,  6 Jul 2026 22:56:13 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 26/88] scsi: qla2xxx: Update handling of status entries for 29xx series
Date: Tue, 7 Jul 2026 11:23:33 +0530
Message-ID: <20260707055435.2680300-27-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: 4dxTekgbKB6CzapT0EZ4E0rp9DF9JA81
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX/ymEh3CWPy4s
 SC3I1PBXgcZ85cgNqJ5KLoTobN4qy/g9abAkXCMCxdCgoo/ZZNJSopCv+yJIuySFRW6ZCXOiLuo
 k/VB6Bz6RlP8VmgRj8ReF9hepM2nmN44RXf9UT1VFmh76FImItzYOrW+LJ2e6uxMclOJ8oVjiXP
 LHTi6ViEdGhAFsoPJIwS7EQPjvVeJED0+ky1AtJFg4uFaQjq70uztGtznvT659AqprpP1gDInxg
 HZv+WuufA0a9alupJeaEKlYu05O+pBxLCMw3+/K4utncXYF8REp0EcVtlWQdvFRfNCPdL5RJbYo
 Fgp16b8iA9grujZ3CuSsldrUhupv5m9yr7Co1GkiOS95EPUEke+LVzGhG7TuPliou3Rm+VBQbR+
 uLGFx/iwjRETpvhTd87hYvEyM1j9ptwhXnA9JtsGqwb9fhWGZ1CqD439w7yaRGzky211bEc2d32
 xYMOJF5lBlYjGPmghTg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXzB2BeOktDoBS
 bqYMPcPAjWglolWL0/cHtApfASnHsleCCZTwqN26TvTM3Dav2JbyAK9aUw4NpAmUCvDxesh0XtZ
 OjcF1yYScnsztuBQZx6CLaE3NiRCF68=
X-Proofpoint-GUID: 4dxTekgbKB6CzapT0EZ4E0rp9DF9JA81
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c9501 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=eacJ5Deg6zpetDbprnAA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

Modify the handling of status entries in the qla2xxx driver to
accommodate the extended structure for the 29xx series. Changes include
updating function signatures to accept a generic pointer for status
packets, and adjusting the logic to differentiate between the standard
and extended status entries. This ensures proper processing of
completion statuses and error handling for the new hardware
capabilities.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c   |  15 ++--
 drivers/scsi/qla2xxx/qla_gbl.h    |   2 +-
 drivers/scsi/qla2xxx/qla_inline.h |  45 ++++++++++++
 drivers/scsi/qla2xxx/qla_isr.c    | 111 +++++++++++++++++++-----------
 drivers/scsi/qla2xxx/qla_mbx.c    |  28 ++++----
 drivers/scsi/qla2xxx/qla_os.c     |   1 +
 6 files changed, 143 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 4416197a35b0..b05f8e0b705e 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -3501,12 +3501,15 @@ static void __chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha,
 }
 
 void qla_chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha,
-		srb_t *sp, struct sts_entry_24xx *sts24)
+		srb_t *sp, void *pkt)
 {
+	struct sts_entry_24xx *sts24 = pkt;
+	struct sts_entry_24xx_ext *stsext = pkt;
+	struct qla_hw_data *ha = vha->hw;
 	fc_port_t *fcport = sp->fcport;
-	/* sa_index used by this iocb */
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	uint32_t handle;
+	uint16_t sa_index;
 
 	handle = (uint32_t)LSW(sts24->handle);
 
@@ -3514,8 +3517,12 @@ void qla_chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha,
 	if (cmd->sc_data_direction != DMA_FROM_DEVICE)
 		return;
 
-	return __chk_edif_rx_sa_delete_pending(vha, fcport, handle,
-	   le16_to_cpu(sts24->edif_sa_index));
+	if (IS_QLA29XX(ha))
+		sa_index = le16_to_cpu(stsext->read_sa_index);
+	else
+		sa_index = le16_to_cpu(sts24->edif_sa_index);
+
+	return __chk_edif_rx_sa_delete_pending(vha, fcport, handle, sa_index);
 }
 
 void qlt_chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha, fc_port_t *fcport,
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 04f4cfadc510..2b66c59e9a6d 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -136,7 +136,7 @@ void qla_edif_sadb_release(struct qla_hw_data *ha);
 int qla_edif_sadb_build_free_pool(struct qla_hw_data *ha);
 void qla_edif_sadb_release_free_pool(struct qla_hw_data *ha);
 void qla_chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha,
-		srb_t *sp, struct sts_entry_24xx *sts24);
+		srb_t *sp, void *pkt);
 void qlt_chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha, fc_port_t *fcport,
 		struct ctio7_from_24xx *ctio);
 void qla2x00_release_all_sadb(struct scsi_qla_host *vha, struct fc_port *fcport);
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 8c581e37e6c3..cc613bc98e92 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -818,3 +818,48 @@ static inline bool val_is_in_range(u32 val, u32 start, u32 end)
 	else
 		return false;
 }
+
+/*
+ * Common fields extracted from FWI2 status IOCBs.  Populated once so
+ * callers avoid duplicated IS_QLA29XX() branches for every field access.
+ */
+struct qla_sts_fwi2 {
+	u8  *data;
+	u32 data_sz;
+	u16 scsi_status;
+	u16 sts_qual;
+	u32 sense_len;
+	u32 rsp_data_len;
+	u32 rsp_residual_count;
+};
+
+static inline void
+qla_sts_fwi2_extract(struct qla_hw_data *ha, void *pkt,
+		      struct qla_sts_fwi2 *sf)
+{
+	if (IS_QLA29XX(ha)) {
+		struct sts_entry_24xx_ext *s = pkt;
+
+		sf->scsi_status = le16_to_cpu(s->u2.scsi_status);
+		sf->sts_qual = le16_to_cpu(s->u2.retry_delay_timer);
+		sf->sense_len = le32_to_cpu(s->u2.sense_len);
+		sf->rsp_data_len = le32_to_cpu(s->u2.rsp_data_len_ndma);
+		sf->rsp_residual_count = le32_to_cpu(s->u2.rsp_residual_count);
+		sf->data = s->u2.data;
+		sf->data_sz = sizeof(s->u2.data);
+		host_to_fcp_swap(s->u2.data, sizeof(s->u2.data));
+		host_to_fcp_swap(s->act_dif, sizeof(s->act_dif));
+		host_to_fcp_swap(s->exp_dif, sizeof(s->exp_dif));
+	} else {
+		struct sts_entry_24xx *s = pkt;
+
+		sf->scsi_status = le16_to_cpu(s->scsi_status);
+		sf->sts_qual = le16_to_cpu(s->status_qualifier);
+		sf->sense_len = le32_to_cpu(s->sense_len);
+		sf->rsp_data_len = le32_to_cpu(s->rsp_data_len);
+		sf->rsp_residual_count = le32_to_cpu(s->rsp_residual_count);
+		sf->data = s->data;
+		sf->data_sz = sizeof(s->data);
+		host_to_fcp_swap(s->data, sizeof(s->data));
+	}
+}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index f668012de3d4..c38771e4202c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2307,8 +2307,9 @@ qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 
 static void
 qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
-    struct sts_entry_24xx *pkt, int iocb_type)
+		     void *pkt, int iocb_type)
 {
+	struct sts_entry_24xx *sts24 = pkt;
 	struct els_sts_entry_24xx *ese = (struct els_sts_entry_24xx *)pkt;
 	const char func[] = "ELS_CT_IOCB";
 	const char *type;
@@ -2331,9 +2332,9 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 
 	type = NULL;
 
-	comp_status = fw_status[0] = le16_to_cpu(pkt->comp_status);
-	fw_status[1] = le32_to_cpu(((struct els_sts_entry_24xx *)pkt)->error_subcode_1);
-	fw_status[2] = le32_to_cpu(((struct els_sts_entry_24xx *)pkt)->error_subcode_2);
+	comp_status = fw_status[0] = le16_to_cpu(sts24->comp_status);
+	fw_status[1] = le32_to_cpu(ese->error_subcode_1);
+	fw_status[2] = le32_to_cpu(ese->error_subcode_2);
 
 	switch (sp->type) {
 	case SRB_ELS_CMD_RPT:
@@ -2669,7 +2670,9 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req, void *tsk)
 	srb_t *sp;
 	struct srb_iocb *iocb;
 	struct sts_entry_24xx *sts = (struct sts_entry_24xx *)tsk;
+	struct qla_hw_data *ha = vha->hw;
 	u16 comp_status;
+	struct qla_sts_fwi2 sf;
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, tsk);
 	if (!sp)
@@ -2691,18 +2694,19 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req, void *tsk)
 		    "Async-%s error - hdl=%x completion status(%x).\n",
 		    type, sp->handle, comp_status);
 		iocb->u.tmf.data = QLA_FUNCTION_FAILED;
-	} else if ((le16_to_cpu(sts->scsi_status) &
-	    SS_RESPONSE_INFO_LEN_VALID)) {
-		host_to_fcp_swap(sts->data, sizeof(sts->data));
-		if (le32_to_cpu(sts->rsp_data_len) < 4) {
-			ql_log(ql_log_warn, fcport->vha, 0x503b,
-			    "Async-%s error - hdl=%x not enough response(%d).\n",
-			    type, sp->handle, sts->rsp_data_len);
-		} else if (sts->data[3]) {
-			ql_log(ql_log_warn, fcport->vha, 0x503c,
-			    "Async-%s error - hdl=%x response(%x).\n",
-			    type, sp->handle, sts->data[3]);
-			iocb->u.tmf.data = QLA_FUNCTION_FAILED;
+	} else {
+		qla_sts_fwi2_extract(ha, tsk, &sf);
+		if (sf.scsi_status & SS_RESPONSE_INFO_LEN_VALID) {
+			if (sf.rsp_data_len < 4) {
+				ql_log(ql_log_warn, fcport->vha, 0x503b,
+				    "Async-%s error - hdl=%x not enough response(%d).\n",
+				    type, sp->handle, sf.rsp_data_len);
+			} else if (sf.data[3]) {
+				ql_log(ql_log_warn, fcport->vha, 0x503c,
+				    "Async-%s error - hdl=%x response(%x).\n",
+				    type, sp->handle, sf.data[3]);
+				iocb->u.tmf.data = QLA_FUNCTION_FAILED;
+			}
 		}
 	}
 
@@ -2731,7 +2735,8 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req, void *tsk)
 
 	if (iocb->u.tmf.data != QLA_SUCCESS)
 		ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, sp->vha, 0x5055,
-		    sts, sizeof(*sts));
+		    tsk, IS_QLA29XX(ha) ?
+		    sizeof(struct sts_entry_24xx_ext) : sizeof(*sts));
 
 	sp->done(sp, 0);
 }
@@ -2742,6 +2747,8 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	fc_port_t *fcport;
 	struct srb_iocb *iocb;
 	struct sts_entry_24xx *sts = (struct sts_entry_24xx *)tsk;
+	struct sts_entry_24xx_ext *stsext = (struct sts_entry_24xx_ext *)tsk;
+	struct qla_hw_data *ha = vha->hw;
 	uint16_t        state_flags;
 	struct nvmefc_fcp_req *fd;
 	uint16_t        ret = QLA_SUCCESS;
@@ -2793,7 +2800,10 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		uint32_t *inbuf, *outbuf;
 		uint16_t iter;
 
-		inbuf = (uint32_t *)&sts->nvme_ersp_data;
+		if (IS_QLA29XX(ha))
+			inbuf = (uint32_t *)stsext->u2.nvme_ersp_data;
+		else
+			inbuf = (uint32_t *)&sts->nvme_ersp_data;
 		outbuf = (uint32_t *)fd->rspaddr;
 		iocb->u.nvme.rsp_pyld_len = sts->nvme_rsp_pyld_len;
 		if (unlikely(le16_to_cpu(iocb->u.nvme.rsp_pyld_len) >
@@ -3038,16 +3048,26 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t par_sense_len,
  * to indicate to the kernel that the HBA detected error.
  */
 static inline int
-qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
+qla2x00_handle_dif_error(srb_t *sp, void *pkt)
 {
 	struct scsi_qla_host *vha = sp->vha;
+	struct qla_hw_data *ha = vha->hw;
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
-	uint8_t		*ap = &sts24->data[12];
-	uint8_t		*ep = &sts24->data[20];
+	struct sts_entry_24xx *sts24 = pkt;
+	struct sts_entry_24xx_ext *stsext = pkt;
+	uint8_t		*ap, *ep;
 	uint32_t	e_ref_tag, a_ref_tag;
 	uint16_t	e_app_tag, a_app_tag;
 	uint16_t	e_guard, a_guard;
 
+	if (IS_QLA29XX(ha)) {
+		ap = stsext->act_dif;
+		ep = stsext->exp_dif;
+	} else {
+		ap = &sts24->data[12];
+		ep = &sts24->data[20];
+	}
+
 	/*
 	 * swab32 of the "data" field in the beginning of qla2x00_status_entry()
 	 * would make guard field appear at offset 2
@@ -3060,7 +3080,7 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 	e_ref_tag = get_unaligned_le32(ep + 4);
 
 	ql_dbg(ql_dbg_io, vha, 0x3023,
-	    "iocb(s) %p Returned STATUS.\n", sts24);
+	    "iocb(s) %px Returned STATUS.\n", pkt);
 
 	ql_dbg(ql_dbg_io, vha, 0x3024,
 	    "DIF ERROR in cmd 0x%x lba 0x%llx act ref"
@@ -3192,7 +3212,9 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 
 	if (IS_FWI2_CAPABLE(ha)) {
 		comp_status = le16_to_cpu(sts24->comp_status);
-		scsi_status = le16_to_cpu(sts24->scsi_status) & SS_MASK;
+		scsi_status = IS_QLA29XX(ha) ?
+		    le16_to_cpu(((struct sts_entry_24xx_ext *)pkt)->u2.scsi_status) & SS_MASK :
+		    le16_to_cpu(sts24->scsi_status) & SS_MASK;
 	} else {
 		comp_status = le16_to_cpu(sts->comp_status);
 		scsi_status = le16_to_cpu(sts->scsi_status) & SS_MASK;
@@ -3328,10 +3350,13 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	int res = 0;
 	uint16_t state_flags = 0;
 	uint16_t sts_qual = 0;
+	struct qla_sts_fwi2 sf;
 
 	if (IS_FWI2_CAPABLE(ha)) {
 		comp_status = le16_to_cpu(sts24->comp_status);
-		scsi_status = le16_to_cpu(sts24->scsi_status) & SS_MASK;
+		scsi_status = IS_QLA29XX(ha) ?
+		    le16_to_cpu(((struct sts_entry_24xx_ext *)pkt)->u2.scsi_status) & SS_MASK :
+		    le16_to_cpu(sts24->scsi_status) & SS_MASK;
 		state_flags = le16_to_cpu(sts24->state_flags);
 	} else {
 		comp_status = le16_to_cpu(sts->comp_status);
@@ -3402,7 +3427,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	}
 
 	/* Fast path completion. */
-	qla_chk_edif_rx_sa_delete_pending(vha, sp, sts24);
+	qla_chk_edif_rx_sa_delete_pending(vha, sp, pkt);
 	sp->qpair->cmd_completion_cnt++;
 
 	if (comp_status == CS_COMPLETE && scsi_status == 0) {
@@ -3429,20 +3454,20 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	sense_len = par_sense_len = rsp_info_len = resid_len =
 	    fw_resid_len = 0;
 	if (IS_FWI2_CAPABLE(ha)) {
+		qla_sts_fwi2_extract(ha, pkt, &sf);
 		if (scsi_status & SS_SENSE_LEN_VALID)
-			sense_len = le32_to_cpu(sts24->sense_len);
+			sense_len = sf.sense_len;
 		if (scsi_status & SS_RESPONSE_INFO_LEN_VALID)
-			rsp_info_len = le32_to_cpu(sts24->rsp_data_len);
+			rsp_info_len = sf.rsp_data_len;
 		if (scsi_status & (SS_RESIDUAL_UNDER | SS_RESIDUAL_OVER))
-			resid_len = le32_to_cpu(sts24->rsp_residual_count);
+			resid_len = sf.rsp_residual_count;
 		if (comp_status == CS_DATA_UNDERRUN)
 			fw_resid_len = le32_to_cpu(sts24->residual_len);
-		rsp_info = sts24->data;
-		sense_data = sts24->data;
-		host_to_fcp_swap(sts24->data, sizeof(sts24->data));
+		rsp_info = sf.data;
+		sense_data = sf.data;
+		par_sense_len = sf.data_sz;
+		sts_qual = sf.sts_qual;
 		ox_id = le16_to_cpu(sts24->ox_id);
-		par_sense_len = sizeof(sts24->data);
-		sts_qual = le16_to_cpu(sts24->status_qualifier);
 	} else {
 		if (scsi_status & SS_SENSE_LEN_VALID)
 			sense_len = le16_to_cpu(sts->req_sense_length);
@@ -3642,7 +3667,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		break;
 
 	case CS_DIF_ERROR:
-		logit = qla2x00_handle_dif_error(sp, sts24);
+		logit = qla2x00_handle_dif_error(sp, pkt);
 		res = cp->result;
 		break;
 
@@ -3667,7 +3692,8 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		    ox_id, cp->cmnd, scsi_bufflen(cp), rsp_info_len,
 		    resid_len, fw_resid_len, sp, cp);
 		ql_dump_buffer(ql_dbg_tgt + ql_dbg_verbose, vha, 0xe0ee,
-		    pkt, sizeof(*sts24));
+		    pkt, IS_QLA29XX(ha) ?
+		    sizeof(struct sts_entry_24xx_ext) : sizeof(*sts24));
 		res = DID_ERROR << 16;
 		vha->hw_err_cnt++;
 		break;
@@ -3967,7 +3993,7 @@ static void qla_marker_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	struct rsp_que *rsp)
 {
-	struct sts_entry_24xx *pkt;
+	void *pkt;
 	struct qla_hw_data *ha = vha->hw;
 	struct purex_entry_24xx *purex_entry;
 	struct purex_item *pure_item;
@@ -3997,13 +4023,13 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 
 	while (rsp->ring_index != rsp_in &&
 		       rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
-		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
+		pkt = (void *)rsp->ring_ptr;
 		cur_ring_index = rsp->ring_index;
 
 		qla_rsp_ring_advance(rsp);
 
-		if (pkt->entry_status != 0) {
-			if (qla2x00_error_entry(vha, rsp, (sts_entry_t *) pkt))
+		if (((response_t *)pkt)->entry_status != 0) {
+			if (qla2x00_error_entry(vha, rsp, (sts_entry_t *)pkt))
 				goto process_err;
 
 			((response_t *)pkt)->signature = RESPONSE_PROCESSED;
@@ -4012,7 +4038,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 		}
 process_err:
 
-		switch (pkt->entry_type) {
+		switch (((response_t *)pkt)->entry_type) {
 		case STATUS_TYPE:
 			qla2x00_status_entry(vha, rsp, pkt);
 			break;
@@ -4063,7 +4089,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			    rsp->req);
 			break;
 		case NOTIFY_ACK_TYPE:
-			if (pkt->handle == QLA_TGT_SKIP_HANDLE)
+			if (((response_t *)pkt)->handle == QLA_TGT_SKIP_HANDLE)
 				qlt_response_pkt_all_vps(vha, rsp,
 				    (response_t *)pkt);
 			else
@@ -4156,7 +4182,8 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			/* Type Not Supported. */
 			ql_dbg(ql_dbg_async, vha, 0x5042,
 			       "Received unknown response pkt type 0x%x entry status=%x.\n",
-			       pkt->entry_type, pkt->entry_status);
+			       ((response_t *)pkt)->entry_type,
+			       ((response_t *)pkt)->entry_status);
 			break;
 		}
 		((response_t *)pkt)->signature = RESPONSE_PROCESSED;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index c073dc35ef8e..f9b326c02055 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3407,6 +3407,7 @@ struct tsk_mgmt_cmd {
 	union {
 		struct tsk_mgmt_entry tsk;
 		struct sts_entry_24xx sts;
+		struct sts_entry_24xx_ext sts_ext;
 	} p;
 };
 
@@ -3417,6 +3418,7 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 	int		rval, rval2;
 	struct tsk_mgmt_cmd *tsk;
 	struct sts_entry_24xx *sts;
+	struct qla_sts_fwi2 sf;
 	dma_addr_t	tsk_dma;
 	scsi_qla_host_t *vha;
 	struct qla_hw_data *ha;
@@ -3474,18 +3476,20 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 		    "Failed to complete IOCB -- completion status (%x).\n",
 		    le16_to_cpu(sts->comp_status));
 		rval = QLA_FUNCTION_FAILED;
-	} else if (le16_to_cpu(sts->scsi_status) &
-	    SS_RESPONSE_INFO_LEN_VALID) {
-		if (le32_to_cpu(sts->rsp_data_len) < 4) {
-			ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1097,
-			    "Ignoring inconsistent data length -- not enough "
-			    "response info (%d).\n",
-			    le32_to_cpu(sts->rsp_data_len));
-		} else if (sts->data[3]) {
-			ql_dbg(ql_dbg_mbx, vha, 0x1098,
-			    "Failed to complete IOCB -- response (%x).\n",
-			    sts->data[3]);
-			rval = QLA_FUNCTION_FAILED;
+	} else {
+		qla_sts_fwi2_extract(ha, sts, &sf);
+		if (sf.scsi_status & SS_RESPONSE_INFO_LEN_VALID) {
+			if (sf.rsp_data_len < 4) {
+				ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha,
+				    0x1097,
+				    "Ignoring inconsistent data length -- not enough response info (%d).\n",
+				    sf.rsp_data_len);
+			} else if (sf.data[3]) {
+				ql_dbg(ql_dbg_mbx, vha, 0x1098,
+				    "Failed to complete IOCB -- response (%x).\n",
+				    sf.data[3]);
+				rval = QLA_FUNCTION_FAILED;
+			}
 		}
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index fdb53811e0c7..4f7e5f9372ef 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8400,6 +8400,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct rdp_rsp_payload) != 336);
 	BUILD_BUG_ON(sizeof(struct sns_cmd_pkt) != 2064);
 	BUILD_BUG_ON(sizeof(struct sts_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct sts_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct tsk_mgmt_entry) != 64);
 	BUILD_BUG_ON(sizeof(struct tsk_mgmt_entry_fx00) != 64);
 	BUILD_BUG_ON(sizeof(struct verify_chip_entry_84xx) != 64);
-- 
2.47.3

