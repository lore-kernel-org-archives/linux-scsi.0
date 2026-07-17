Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FD4190462
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302237; cv=none; b=eUMxK1dabyuEVnwvC57cPX08Rjh3+ZXfrx4Q22NEkEgGC1mmg5P5ioXNQINLUcc6xTku6b8nMh7fNrGjO0COp4VarI76TYkSfj301MjtTgYpuaLd99bPeKRWvE74SUlV2Sr/+AB+RkRrG6Vm/mKHirn/UK0X5oTy+6daE4OXSLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302237; c=relaxed/simple;
	bh=uuMIHyM6uLV1paZPg1fdAC9jOJervQ0I8jhO3TveZZc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AI0GcNPatoO83v2AB4QOi+i0hSwwn7L5KWDHjUNuh9sl+1CuzGFlKGUFTjgeo6gRBvc6gHlfRpOSMoAymeVlrf2CRfwnPGoHNjLpgA8GvqzyIeF7fSPxg4GzAKSigYZbpv2h7h65ZSlL5MtOziZEeY5rlWLIiXPBEBPEVpBoljg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=CpNqpUGz; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="CpNqpUGz"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE5KWe2729332;
	Fri, 17 Jul 2026 08:30:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=j
	HSk30QpgDQ4pkWinYN/h8td/9sTSaePPKHBYykQoaw=; b=CpNqpUGzyVL56R3MQ
	ChNhoxqcyxWEZMKEOjy6WUMDwMVpsylKh2OhWcGBevlocH1Sy7O0DX1sWIC2Fsyd
	bM1/nWGy2JbqIaUIUbT4WGmS5SSfPY/MfEI/IqhAxZrYHwfMbNs3LEmSfBnqjTgZ
	Euk90cmeTGVR8IPCYQAr0HSorPTd6KFuOlcflP1Cz95GZabFGuuBDiXHhMvliQI0
	KL7TfVYpaseyWgqCDtmjmHocaXRrLzvXZWhTJc7w0XzQLc50WbRNvwKQvPy5+a9r
	FRVxcqDiT+WgQ5y3els83mNS65JE/Y1YBN22Gx/LcWcyeg4am90GTt7HsMUJJiWk
	1spMA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fewjwmj2x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:30:31 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:30:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:30:30 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 3D3895B693B;
	Fri, 17 Jul 2026 08:30:28 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 28/56] scsi: qla2xxx: Enhance purex_entry handling for 29xx series
Date: Fri, 17 Jul 2026 20:58:36 +0530
Message-ID: <20260717152904.3155730-29-njavali@marvell.com>
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
X-Proofpoint-GUID: tG180GezO1NxcBsQpq5NDn6XQN8lyWcR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX+46xEIS1Cdel
 tN9nmGzx+ZDNv6IQT+rPyeDd0sg8qhSJvT4Ngjkbk5aGN3YVs/ave5sOmcwqaXqCWYDURiV1kOE
 1R2WI8LzEydLSZLwF4onwpzeqR0p2zuIFYGJl1rUgdePgYOh1uBJ+pwPiI0qTydFatlKvXDpP0y
 /UdonLFf0z/45ln2pnNFDv0XCB3uklvgKkrUw1Hk2Yg1nZFiOoS5TtCa8xctMrt2CbvQLRNlBQ/
 iJcVZ3U/KxNFHkdhWm8M/2hM0ecjIPALAos4KY7ggAOV/rd2bf75hsHAWfx8SCB2r+dhKPcGLyw
 WTjHKvMQ6bKKBBMzGSewrkFwZ+uhwMV2MUfCamEj1XwWWK5q7F/+QQT+wfgfRSuugfg438KEU7C
 sm+rwexRhMI6byc0ScNFs/bIq/rgoyzdTEaCd+4UkBf4QZjzo20H8t8UCMI/tWOxI6UfFZ04MdN
 xNxjTxpfPX5zQLTGjHA==
X-Authority-Analysis: v=2.4 cv=Pa3PQChd c=1 sm=1 tr=0 ts=6a5a4a97 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=cxd6FSJZLq2k18q51YsA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: tG180GezO1NxcBsQpq5NDn6XQN8lyWcR
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX50VOkP5+HxoB
 6AVzCvWemITosW+slayfXIqttTljHW41aJ6lY+dpYJkldSxr4McVsMlBi6pALJBXh5mizIczJ96
 LFxJrmFgkoATSpprxyx2lBYaEQGpjko=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

Update function signatures and internal logic across qla_edif.c,
qla_isr.c, and qla_os.c to accept a generic pointer for packet data and
differentiate between standard purex_entry_24xx and the extended
purex_entry_24xx_ext structures based on IS_QLA29XX().

This ensures proper initialization and processing of command and response
data for both 64-byte and 128-byte PUREX IOCBs across all ELS paths
including auth_els, RDP, copy_std_pkt, copy_multiple_pkt, consume_iocb,
and copy_purex_to_buffer.

Where the two layouts overlap at byte-identical offsets (entry_count,
frame_size, nport_handle, rx_xchg_addr, ox_id, status_flags,
trunc_frame_size, s_id, d_id, els_frame_payload base, and
response_t::signature), use a single struct purex_entry_24xx * view to
avoid duplicating read paths.  Branch only where field encoding differs:
vp_idx (u8 at offset 6 in 24xx vs __le16 at offsets 6-7 in 29xx) and
els_frame_payload[] array length (20 vs 84 bytes, handled via a
sizeof_field()-based payload_size local).

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h  |  3 +-
 drivers/scsi/qla2xxx/qla_edif.c | 65 +++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_isr.c  | 88 ++++++++++++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_os.c   | 24 +++++++--
 4 files changed, 139 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 0fc858ab4e8c..42826c1e4959 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5001,6 +5001,7 @@ struct active_regions {
 #define QLA_SET_DATA_RATE_LR	2 /* Set speed and initiate LR */
 
 #define QLA_DEFAULT_PAYLOAD_SIZE	64
+#define QLA_MAX_IOCB_SIZE		128
 /*
  * This item might be allocated with a size > sizeof(struct purex_item).
  * The "size" variable gives the size of the payload (which
@@ -5015,7 +5016,7 @@ struct purex_item {
 	atomic_t in_use;
 	uint16_t size;
 	struct {
-		uint8_t iocb[64];
+		u8 iocb[QLA_MAX_IOCB_SIZE];
 	} iocb;
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index b05f8e0b705e..ade1d8178573 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2534,7 +2534,7 @@ qla24xx_sa_replace_iocb(srb_t *sp, struct sa_update_28xx *sa_update_iocb)
 
 void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 {
-	struct purex_entry_24xx *p = *pkt;
+	struct qla_hw_data *ha = vha->hw;
 	struct enode		*ptr;
 	int		sid;
 	u16 totlen;
@@ -2544,26 +2544,55 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 	struct fc_port *fcport;
 	struct qla_els_pt_arg a;
 	be_id_t beid;
+	__le16 nport_handle;
+	__le32 rx_xchg_addr;
+	__le16 ox_id;
+	__le16 frame_size, status_flags, trunc_frame_size;
+	uint8_t s_id[3], d_id[3];
+	uint8_t vp_idx;
+	struct purex_entry_24xx *p = *pkt;
 
 	memset(&a, 0, sizeof(a));
 
+	/*
+	 * purex_entry_24xx_ext (29xx) overlays purex_entry_24xx for every
+	 * field touched here -- nport_handle, rx_xchg_addr, ox_id, frame_size,
+	 * status_flags, trunc_frame_size, s_id[3], d_id[3] -- with only
+	 * vp_idx differing in width (u8 at offset 6 vs __le16 at offsets 6-7,
+	 * with reserved2 at offset 7 in the 24xx layout). So all reads but
+	 * vp_idx go through a single struct purex_entry_24xx * view.
+	 */
+	nport_handle = p->nport_handle;
+	rx_xchg_addr = p->rx_xchg_addr;
+	ox_id = p->ox_id;
+	frame_size = p->frame_size;
+	status_flags = p->status_flags;
+	trunc_frame_size = p->trunc_frame_size;
+	memcpy(s_id, p->s_id, sizeof(s_id));
+	memcpy(d_id, p->d_id, sizeof(d_id));
+	if (IS_QLA29XX(ha))
+		vp_idx = le16_to_cpu(((struct purex_entry_24xx_ext *)
+				      *pkt)->vp_idx);
+	else
+		vp_idx = p->vp_idx;
+
 	a.els_opcode = ELS_AUTH_ELS;
-	a.nport_handle = p->nport_handle;
-	a.rx_xchg_address = p->rx_xchg_addr;
-	a.did.b.domain = p->s_id[2];
-	a.did.b.area   = p->s_id[1];
-	a.did.b.al_pa  = p->s_id[0];
+	a.nport_handle = nport_handle;
+	a.rx_xchg_address = rx_xchg_addr;
+	a.did.b.domain = s_id[2];
+	a.did.b.area   = s_id[1];
+	a.did.b.al_pa  = s_id[0];
 	a.tx_byte_count = a.tx_len = sizeof(struct fc_els_ls_rjt);
-	a.tx_addr = vha->hw->elsrej.cdma;
+	a.tx_addr = ha->elsrej.cdma;
 	a.vp_idx = vha->vp_idx;
 	a.control_flags = EPD_ELS_RJT;
-	a.ox_id = le16_to_cpu(p->ox_id);
+	a.ox_id = le16_to_cpu(ox_id);
 
-	sid = p->s_id[0] | (p->s_id[1] << 8) | (p->s_id[2] << 16);
+	sid = s_id[0] | (s_id[1] << 8) | (s_id[2] << 16);
 
-	totlen = (le16_to_cpu(p->frame_size) & 0x0fff) - PURX_ELS_HEADER_SIZE;
-	if (le16_to_cpu(p->status_flags) & 0x8000) {
-		totlen = le16_to_cpu(p->trunc_frame_size);
+	totlen = (le16_to_cpu(frame_size) & 0x0fff) - PURX_ELS_HEADER_SIZE;
+	if (le16_to_cpu(status_flags) & 0x8000) {
+		totlen = le16_to_cpu(trunc_frame_size);
 		qla_els_reject_iocb(vha, (*rsp)->qpair, &a);
 		__qla_consume_iocb(vha, pkt, rsp);
 		return;
@@ -2600,12 +2629,12 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 	purex = &ptr->u.purexinfo;
 	purex->pur_info.pur_sid = a.did;
 	purex->pur_info.pur_bytes_rcvd = totlen;
-	purex->pur_info.pur_rx_xchg_address = le32_to_cpu(p->rx_xchg_addr);
-	purex->pur_info.pur_nphdl = le16_to_cpu(p->nport_handle);
-	purex->pur_info.pur_did.b.domain =  p->d_id[2];
-	purex->pur_info.pur_did.b.area =  p->d_id[1];
-	purex->pur_info.pur_did.b.al_pa =  p->d_id[0];
-	purex->pur_info.vp_idx = p->vp_idx;
+	purex->pur_info.pur_rx_xchg_address = le32_to_cpu(rx_xchg_addr);
+	purex->pur_info.pur_nphdl = le16_to_cpu(nport_handle);
+	purex->pur_info.pur_did.b.domain =  d_id[2];
+	purex->pur_info.pur_did.b.area =  d_id[1];
+	purex->pur_info.pur_did.b.al_pa =  d_id[0];
+	purex->pur_info.vp_idx = vp_idx;
 
 	a.sid = purex->pur_info.pur_did;
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5aa45b8f4929..75ce09933afc 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -202,6 +202,11 @@ void __qla_consume_iocb(struct scsi_qla_host *vha,
 	struct rsp_que *rsp_q = *rsp;
 	response_t *new_pkt;
 	uint16_t entry_count_remaining;
+	/*
+	 * entry_count is u8 at offset 1 in both purex_entry_24xx and
+	 * purex_entry_24xx_ext, so the 24xx view is layout-compatible with
+	 * either stride.
+	 */
 	struct purex_entry_24xx *purex = *pkt;
 
 	entry_count_remaining = purex->entry_count;
@@ -230,6 +235,14 @@ void __qla_consume_iocb(struct scsi_qla_host *vha,
 int __qla_copy_purex_to_buffer(struct scsi_qla_host *vha,
 	void **pkt, struct rsp_que **rsp, u8 *buf, u32 buf_len)
 {
+	/*
+	 * purex_entry_24xx_ext overlays purex_entry_24xx for entry_count
+	 * (offset 1), frame_size (offset 12) and els_frame_payload (offset
+	 * 44, base address only -- the array size grows from 20 to 84
+	 * bytes).  Header fields are read through the 24xx view; the
+	 * initial payload memcpy uses a purex_entry_24xx_ext pointer on
+	 * 29xx so that FORTIFY_SOURCE sees the correct 84-byte source.
+	 */
 	struct purex_entry_24xx *purex = *pkt;
 	struct qla_hw_data *ha = vha->hw;
 	struct rsp_que *rsp_q = *rsp;
@@ -244,8 +257,8 @@ int __qla_copy_purex_to_buffer(struct scsi_qla_host *vha,
 	u16 tpad;
 
 	entry_count_remaining = purex->entry_count;
-	total_bytes = (le16_to_cpu(purex->frame_size) & 0x0FFF)
-		- PURX_ELS_HEADER_SIZE;
+	total_bytes = (le16_to_cpu(purex->frame_size) & 0x0FFF) -
+		PURX_ELS_HEADER_SIZE;
 
 	/*
 	 * end of payload may not end in 4bytes boundary.  Need to
@@ -262,14 +275,24 @@ int __qla_copy_purex_to_buffer(struct scsi_qla_host *vha,
 	}
 
 	pending_bytes = total_bytes = tpad;
-	no_bytes = (pending_bytes > sizeof(purex->els_frame_payload))  ?
-	    sizeof(purex->els_frame_payload) : pending_bytes;
+	no_bytes = (pending_bytes > payload_size) ?
+		payload_size : pending_bytes;
+	if (IS_QLA29XX(ha)) {
+		struct purex_entry_24xx_ext *purex_ext = *pkt;
 
-	memcpy(buf, &purex->els_frame_payload[0], no_bytes);
+		memcpy(buf, &purex_ext->els_frame_payload[0], no_bytes);
+	} else {
+		memcpy(buf, &purex->els_frame_payload[0], no_bytes);
+	}
 	buffer_copy_offset += no_bytes;
 	pending_bytes -= no_bytes;
 	--entry_count_remaining;
 
+	/*
+	 * response_t::signature and struct response_ext::signature are both u32
+	 * at offset 60 (handle:4 + data[52]:60), so the 24xx view writes
+	 * the right slot regardless of stride.
+	 */
 	((response_t *)purex)->signature = RESPONSE_PROCESSED;
 	/* flush signature */
 	wmb();
@@ -849,6 +872,7 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha, void **pkt,
 			  struct rsp_que **rsp, bool is_purls,
 			  bool byte_order)
 {
+	struct purex_entry_24xx_ext *purex_ext = NULL;
 	struct purex_entry_24xx *purex = NULL;
 	struct pt_ls4_rx_unsol *purls = NULL;
 	struct qla_hw_data *ha = vha->hw;
@@ -867,6 +891,13 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha, void **pkt,
 			      PURX_ELS_HEADER_SIZE;
 		entry_count = entry_count_remaining = purls->entry_count;
 		payload_size = sizeof(purls->payload);
+	} else if (IS_QLA29XX(ha)) {
+		purex_ext = *pkt;
+		total_bytes = (le16_to_cpu(purex_ext->frame_size) & 0x0FFF) -
+			      PURX_ELS_HEADER_SIZE;
+		entry_count = entry_count_remaining =
+		    purex_ext->entry_count;
+		payload_size = sizeof(purex_ext->els_frame_payload);
 	} else {
 		purex = *pkt;
 		total_bytes = (le16_to_cpu(purex->frame_size) & 0x0FFF) -
@@ -875,8 +906,8 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha, void **pkt,
 		payload_size = sizeof(purex->els_frame_payload);
 	}
 
-	if (total_bytes > sizeof(item->iocb.iocb))
-		total_bytes = sizeof(item->iocb.iocb);
+	if (total_bytes > QLA_MAX_IOCB_SIZE)
+		total_bytes = QLA_MAX_IOCB_SIZE;
 
 	pending_bytes = total_bytes;
 	no_bytes = (pending_bytes > payload_size) ? payload_size :
@@ -893,6 +924,8 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha, void **pkt,
 
 	if (is_purls)
 		memcpy(iocb_pkt, &purls->payload[0], no_bytes);
+	else if (IS_QLA29XX(ha))
+		memcpy(iocb_pkt, &purex_ext->els_frame_payload[0], no_bytes);
 	else
 		memcpy(iocb_pkt, &purex->els_frame_payload[0], no_bytes);
 	buffer_copy_offset += no_bytes;
@@ -901,6 +934,8 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha, void **pkt,
 
 	if (is_purls)
 		((response_t *)purls)->signature = RESPONSE_PROCESSED;
+	else if (IS_QLA29XX(ha))
+		((struct response_ext *)purex_ext)->signature = RESPONSE_PROCESSED;
 	else
 		((response_t *)purex)->signature = RESPONSE_PROCESSED;
 	wmb();
@@ -1075,9 +1110,9 @@ qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
 	struct purex_item *item = NULL;
 	uint8_t item_hdr_size = sizeof(*item);
 
-	if (size > QLA_DEFAULT_PAYLOAD_SIZE) {
+	if (size > QLA_MAX_IOCB_SIZE) {
 		item = kzalloc(item_hdr_size +
-		    (size - QLA_DEFAULT_PAYLOAD_SIZE), GFP_ATOMIC);
+		    (size - QLA_MAX_IOCB_SIZE), GFP_ATOMIC);
 	} else {
 		if (atomic_inc_return(&vha->default_item.in_use) == 1) {
 			item = &vha->default_item;
@@ -1126,14 +1161,20 @@ qla24xx_queue_purex_item(scsi_qla_host_t *vha, struct purex_item *pkt,
 static struct purex_item
 *qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
 {
+	struct qla_hw_data *ha = vha->hw;
 	struct purex_item *item;
+	u16 copy_sz;
 
-	item = qla24xx_alloc_purex_item(vha,
-					QLA_DEFAULT_PAYLOAD_SIZE);
+	if (IS_QLA29XX(ha))
+		copy_sz = sizeof(struct purex_entry_24xx_ext);
+	else
+		copy_sz = QLA_DEFAULT_PAYLOAD_SIZE;
+
+	item = qla24xx_alloc_purex_item(vha, copy_sz);
 	if (!item)
 		return item;
 
-	memcpy(&item->iocb, pkt, sizeof(item->iocb));
+	memcpy(&item->iocb, pkt, copy_sz);
 	return item;
 }
 
@@ -1165,8 +1206,8 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 	total_bytes = (le16_to_cpu(purex->frame_size) & 0x0FFF)
 	    - PURX_ELS_HEADER_SIZE;
 
-	if (total_bytes > sizeof(item->iocb.iocb))
-		total_bytes = sizeof(item->iocb.iocb);
+	if (total_bytes > QLA_MAX_IOCB_SIZE)
+		total_bytes = QLA_MAX_IOCB_SIZE;
 
 	pending_bytes = total_bytes;
 	entry_count = entry_count_remaining = purex->entry_count;
@@ -3996,6 +4037,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 {
 	void *pkt;
 	struct qla_hw_data *ha = vha->hw;
+	struct purex_entry_24xx_ext *purex_entry_ext;
 	struct purex_entry_24xx *purex_entry;
 	struct purex_item *pure_item;
 	struct pt_ls4_rx_unsol *p;
@@ -4113,8 +4155,16 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			    (struct vp_ctrl_entry_24xx *)pkt);
 			break;
 		case PUREX_IOCB_TYPE:
-			purex_entry = (void *)pkt;
-			switch (purex_entry->els_frame_payload[3]) {
+			if (IS_QLA29XX(ha)) {
+				purex_entry_ext = (void *)pkt;
+				purex_entry = NULL;
+			} else {
+				purex_entry = (void *)pkt;
+				purex_entry_ext = NULL;
+			}
+			switch (IS_QLA29XX(ha) ?
+			    purex_entry_ext->els_frame_payload[3] :
+			    purex_entry->els_frame_payload[3]) {
 			case ELS_RDP:
 				pure_item = qla24xx_copy_std_pkt(vha, pkt);
 				if (!pure_item)
@@ -4151,6 +4201,8 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 
 					ql_dbg(ql_dbg_init, vha, 0x5091,
 					    "Defer processing ELS opcode %#x...\n",
+					    IS_QLA29XX(ha) ?
+					    purex_entry_ext->els_frame_payload[3] :
 					    purex_entry->els_frame_payload[3]);
 					return;
 				}
@@ -4158,7 +4210,9 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 				break;
 			default:
 				ql_log(ql_log_warn, vha, 0x509c,
-				       "Discarding ELS Request opcode 0x%x\n",
+				       "Discarding ELS Request opcode 0x%x...\n",
+				       IS_QLA29XX(ha) ?
+				       purex_entry_ext->els_frame_payload[3] :
 				       purex_entry->els_frame_payload[3]);
 			}
 			break;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0b7c4ee73ebf..c327d053f8ee 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6138,13 +6138,15 @@ qla83xx_idc_lock(scsi_qla_host_t *base_vha, uint16_t requester_id)
 }
 
 static bool
-qla25xx_rdp_rsp_reduce_size(struct scsi_qla_host *vha,
-	struct purex_entry_24xx *purex)
+qla25xx_rdp_rsp_reduce_size(struct scsi_qla_host *vha, void *pkt)
 {
+	struct purex_entry_24xx *purex = pkt;
 	char fwstr[16];
-	u32 sid = purex->s_id[2] << 16 | purex->s_id[1] << 8 | purex->s_id[0];
+	u32 sid;
 	struct port_database_24xx *pdb;
 
+	sid = purex->s_id[2] << 16 | purex->s_id[1] << 8 | purex->s_id[0];
+
 	/* Domain Controller is always logged-out. */
 	/* if RDP request is not from Domain Controller: */
 	if (sid != 0xfffc01)
@@ -6209,15 +6211,26 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
 	uint8_t *sfp = NULL;
 	uint16_t sfp_flags = 0;
 	uint rsp_payload_length = sizeof(*rsp_payload);
+	uint8_t vp_idx;
+	size_t purex_sz;
 	int rval;
 
 	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x0180,
 	    "%s: Enter\n", __func__);
 
+	if (IS_QLA29XX(ha)) {
+		vp_idx = le16_to_cpu(
+		    ((struct purex_entry_24xx_ext *)purex)->vp_idx);
+		purex_sz = sizeof(struct purex_entry_24xx_ext);
+	} else {
+		vp_idx = purex->vp_idx;
+		purex_sz = sizeof(*purex);
+	}
+
 	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x0181,
 	    "-------- ELS REQ -------\n");
 	ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, vha, 0x0182,
-	    purex, sizeof(*purex));
+	    purex, purex_sz);
 
 	if (qla25xx_rdp_rsp_reduce_size(vha, purex)) {
 		rsp_payload_length =
@@ -6257,7 +6270,7 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
 	rsp_els->handle = 0;
 	rsp_els->nport_handle = purex->nport_handle;
 	rsp_els->tx_dsd_count = cpu_to_le16(1);
-	rsp_els->vp_index = purex->vp_idx;
+	rsp_els->vp_index = vp_idx;
 	rsp_els->sof_type = EST_SOFI3;
 	rsp_els->rx_xchg_address = purex->rx_xchg_addr;
 	rsp_els->rx_dsd_count = 0;
@@ -8378,6 +8391,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct pt_ls4_request) != 64);
 	BUILD_BUG_ON(sizeof(struct pt_ls4_rx_unsol) != 64);
 	BUILD_BUG_ON(sizeof(struct purex_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct purex_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct qla2100_fw_dump) != 123634);
 	BUILD_BUG_ON(sizeof(struct qla2300_fw_dump) != 136100);
 	BUILD_BUG_ON(sizeof(struct qla24xx_fw_dump) != 37976);
-- 
2.47.3

