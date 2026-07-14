Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5501B15E5DC
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022928; cv=none; b=uma3bYilVSOhzDgWBGipaxOH09cSoONclCHmh4vL3gcD7EUFzG60aYE1JtxxgJz6SkTS23yzscgtrtdPlg4faW/9AmdBoauJhkFGOZeGrU6RFufUy8jiwZeLjPMAqKD+tyDFCbHfhM3WVNv92tKi8jU3K2njjUdlyJkzTfdgK2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022928; c=relaxed/simple;
	bh=B8VY85PkvUXUM6Cpo80XuDLa8EsNkse7qts+o+opScI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bQ/S8DaAKleHklGWk5a4wlmgHGHIqT98BilW7fMWAF5s2pSxuNWBVB4IOcnJ+8M8vFHXuVlzc/CEsPhUGziZWnB1NoMxEjshaQ8Q82ffDvasVfnDAdkg5pRQ81nXa2cVGPcVPu5icfcB7N7cqqd9NccDDLX49NDKNzsSUbnzeGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=BBlIBm87; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="BBlIBm87"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UksA3693367;
	Tue, 14 Jul 2026 02:55:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=3
	rGdXygwGtGFc88ivVhWNVQvso02FWJBxRxaX6PHB5Q=; b=BBlIBm87XK1mZwHr6
	vj8TNR5ukn++Kxh8VynVVeEsWO7BBlDIMXi7MtHzLlR1soSEgX/Lf6PSrnNbR8LU
	yWV5DGTM1vXgJqvDPSPZuc66QHFdsIacbD51dCMUNjp7CIk12r8n7L86lkHSD7hs
	AZyl9B6XZ6mWjb2D+/JOmAkClpkwrpRQTzNtFtGa67En+kL3d5yGOvD4PqlbYCoi
	F1A7XhY7S7cllXam0qfP2UbXmDG0iyjLVeV42jk2zyM+KqINOz8/soUOakp/wint
	itJHTfQbH05usV8yHE+2I55DAoi5A3pkhGJlG1ZBzDOGc8hvJujHMcr6ATrpWqic
	GAC6A==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fbnbey8kn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:55:23 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:55:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:55:22 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 705D35E6867;
	Tue, 14 Jul 2026 02:55:19 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 25/56] scsi: qla2xxx: Handle sts_cont_entry_ext_t for 29xx adapters
Date: Tue, 14 Jul 2026 15:23:22 +0530
Message-ID: <20260714095353.289460-26-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260714095353.289460-1-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 66xqVqgFggsEI_AeuHYTQak7iUR3KQDI
X-Authority-Analysis: v=2.4 cv=WOdPmHsR c=1 sm=1 tr=0 ts=6a56078b cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=6bq2EJHy0pCLO45fYVoA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: 66xqVqgFggsEI_AeuHYTQak7iUR3KQDI
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX5lNNsWnz00m8
 zYevIbIq+PfjTRdN6DIgwc6WZDJ8vFQ49duntw/9sh08CcYjP1Oj7RF10E8Xkaxkgmds/xBidMh
 FjFjHwRUprEYSohYKJxCVHKihPly2aU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX/m7fIcJ0XEvv
 PsezPeb+tnAXiGBnoEcnnl7rY4/CW4XL+hxlaSJuHmOEA060BwrqcSrVS+lbIf+07l+z0782cQD
 GturXtgUCbm28678DP2XZOgf6iouWrINRGSfTMKqZRgIh6nv3N5iLFcX/z2JzXnyJeBLdjWpEZi
 hdOaoQ1phafUMBeoyBDJj9+QFQGFWKVT+kK6JD5BsmUNiCqn5PwMpXBcLNHmDhXWN8k4BV3KZUG
 pa1nDbEacfKIvjg+kYpQzFdAq2YaJ3ZNcc20F8aomPIzMcSTS9mx1BJPzWSuS18HR1LaJ/CyElB
 enCP9c02ePhayh7bRhNcRJbM73E1BhNPrECQ/yravUKXocxbhGgF1BqlJVu4snKsw9PlNG4lvvj
 pV/mYTYdKfLAvXfRubCMou66OOe9NQTujdhp4zPbIvokQTq46QnNH5zert/x/JGIc0WhhA+INjz
 p5hlKpcevPcviVZd+lQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

29xx adapters use 128-byte response queue entries
(sts_cont_entry_ext_t) instead of 64-byte (sts_cont_entry_t).  Update
all status continuation IOCB processing paths to branch on
IS_QLA29XX() and use the correct entry type and data payload size.

The affected functions are __qla_copy_purex_to_buffer(),
qla27xx_copy_multiple_pkt(), qla2x00_status_cont_entry(), and their
call sites in qla2x00_process_response_entry() and
qla24xx_process_response_queue().

Change qla2x00_status_cont_entry() to accept void * so callers no
longer need an explicit cast and the function can internally select the
right structure based on the adapter type.

Add BUILD_BUG_ON for sts_cont_entry_ext_t size (128 bytes).

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_inline.h |  16 ++++
 drivers/scsi/qla2xxx/qla_isr.c    | 117 ++++++++++++++++++------------
 drivers/scsi/qla2xxx/qla_os.c     |   1 +
 3 files changed, 86 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index d5178e0ace22..ff0fd0bff6d0 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -103,6 +103,22 @@ qla_rsp_entry_size(struct qla_hw_data *ha)
 	return IS_QLA29XX(ha) ? sizeof(struct response_ext) : sizeof(response_t);
 }
 
+/**
+ * qla_sts_cont_data_size() - status-continuation IOCB data payload size.
+ * @ha: HBA pointer
+ *
+ * sts_cont_entry_t and struct sts_cont_entry_ext share the same header and
+ * data offset; only the trailing data[] size differs (60 vs 124 bytes).
+ * Returns that size so callers need not branch on the adapter type.
+ */
+static inline u32
+qla_sts_cont_data_size(struct qla_hw_data *ha)
+{
+	return IS_QLA29XX(ha) ?
+		sizeof_field(struct sts_cont_entry_ext, data) :
+		sizeof_field(sts_cont_entry_t, data);
+}
+
 static inline void
 qla2x00_poll(struct rsp_que *rsp)
 {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 26722afa937c..f668012de3d4 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -19,7 +19,7 @@
 
 static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
 static void qla2x00_status_entry(scsi_qla_host_t *, struct rsp_que *, void *);
-static void qla2x00_status_cont_entry(struct rsp_que *, sts_cont_entry_t *);
+static void qla2x00_status_cont_entry(struct rsp_que *, void *, u32);
 static int qla2x00_error_entry(scsi_qla_host_t *, struct rsp_que *,
 	sts_entry_t *);
 static void qla27xx_process_purex_fpin(struct scsi_qla_host *vha,
@@ -231,8 +231,13 @@ int __qla_copy_purex_to_buffer(struct scsi_qla_host *vha,
 	void **pkt, struct rsp_que **rsp, u8 *buf, u32 buf_len)
 {
 	struct purex_entry_24xx *purex = *pkt;
+	struct qla_hw_data *ha = vha->hw;
 	struct rsp_que *rsp_q = *rsp;
-	sts_cont_entry_t *new_pkt;
+	size_t payload_size = IS_QLA29XX(ha) ?
+		sizeof_field(struct purex_entry_24xx_ext, els_frame_payload) :
+		sizeof_field(struct purex_entry_24xx, els_frame_payload);
+	u8 *data;
+	u32 data_sz;
 	uint16_t no_bytes = 0, total_bytes = 0, pending_bytes = 0;
 	uint16_t buffer_copy_offset = 0;
 	uint16_t entry_count_remaining;
@@ -271,10 +276,12 @@ int __qla_copy_purex_to_buffer(struct scsi_qla_host *vha,
 
 	do {
 		while ((total_bytes > 0) && (entry_count_remaining > 0)) {
-			new_pkt = (sts_cont_entry_t *)rsp_q->ring_ptr;
-			*pkt = new_pkt;
+			*pkt = rsp_q->ring_ptr;
+			data = ((sts_cont_entry_t *)*pkt)->data;
+			data_sz = qla_sts_cont_data_size(ha);
 
-			if (new_pkt->entry_type != STATUS_CONT_TYPE) {
+			if (((sts_cont_entry_t *)*pkt)->entry_type !=
+			    STATUS_CONT_TYPE) {
 				ql_log(ql_log_warn, vha, 0x507a,
 				    "Unexpected IOCB type, partial data 0x%x\n",
 				    buffer_copy_offset);
@@ -282,10 +289,10 @@ int __qla_copy_purex_to_buffer(struct scsi_qla_host *vha,
 			}
 
 			qla_rsp_ring_advance(rsp_q);
-			no_bytes = (pending_bytes > sizeof(new_pkt->data)) ?
-			    sizeof(new_pkt->data) : pending_bytes;
+			no_bytes = (pending_bytes > data_sz) ?
+			    data_sz : pending_bytes;
 			if ((buffer_copy_offset + no_bytes) <= total_bytes) {
-				memcpy((buf + buffer_copy_offset), new_pkt->data,
+				memcpy((buf + buffer_copy_offset), data,
 				    no_bytes);
 				buffer_copy_offset += no_bytes;
 				pending_bytes -= no_bytes;
@@ -294,11 +301,11 @@ int __qla_copy_purex_to_buffer(struct scsi_qla_host *vha,
 				ql_log(ql_log_warn, vha, 0x5044,
 				    "Attempt to copy more that we got, optimizing..%x\n",
 				    buffer_copy_offset);
-				memcpy((buf + buffer_copy_offset), new_pkt->data,
+				memcpy((buf + buffer_copy_offset), data,
 				    total_bytes - buffer_copy_offset);
 			}
 
-			((response_t *)new_pkt)->signature = RESPONSE_PROCESSED;
+			((response_t *)*pkt)->signature = RESPONSE_PROCESSED;
 			/* flush signature */
 			wmb();
 		}
@@ -844,13 +851,15 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha, void **pkt,
 {
 	struct purex_entry_24xx *purex = NULL;
 	struct pt_ls4_rx_unsol *purls = NULL;
+	struct qla_hw_data *ha = vha->hw;
 	struct rsp_que *rsp_q = *rsp;
-	sts_cont_entry_t *new_pkt;
 	uint16_t no_bytes = 0, total_bytes = 0, pending_bytes = 0;
 	uint16_t buffer_copy_offset = 0, payload_size = 0;
 	uint16_t entry_count, entry_count_remaining;
 	struct purex_item *item;
 	void *iocb_pkt = NULL;
+	u8 *data;
+	u32 data_sz;
 
 	if (is_purls) {
 		purls = *pkt;
@@ -906,28 +915,24 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha, void **pkt,
 				continue;
 			}
 
-			new_pkt = (sts_cont_entry_t *)rsp_q->ring_ptr;
-			*pkt = new_pkt;
+			*pkt = rsp_q->ring_ptr;
+			data = ((sts_cont_entry_t *)*pkt)->data;
+			data_sz = qla_sts_cont_data_size(ha);
 
-			if (new_pkt->entry_type != STATUS_CONT_TYPE) {
+			if (((sts_cont_entry_t *)*pkt)->entry_type !=
+			    STATUS_CONT_TYPE) {
 				ql_log(ql_log_warn, vha, 0x507a,
 				       "Unexpected IOCB type, partial data 0x%x\n",
 				       buffer_copy_offset);
 				break;
 			}
 
-			rsp_q->ring_index++;
-			if (rsp_q->ring_index == rsp_q->length) {
-				rsp_q->ring_index = 0;
-				rsp_q->ring_ptr = rsp_q->ring;
-			} else {
-				rsp_q->ring_ptr++;
-			}
-			no_bytes = (pending_bytes > sizeof(new_pkt->data)) ?
-				sizeof(new_pkt->data) : pending_bytes;
+			qla_rsp_ring_advance(rsp_q);
+			no_bytes = (pending_bytes > data_sz) ?
+				   data_sz : pending_bytes;
 			if ((buffer_copy_offset + no_bytes) <= total_bytes) {
-				memcpy(((uint8_t *)iocb_pkt + buffer_copy_offset),
-				       new_pkt->data, no_bytes);
+				memcpy(((uint8_t *)iocb_pkt +
+					buffer_copy_offset), data, no_bytes);
 				buffer_copy_offset += no_bytes;
 				pending_bytes -= no_bytes;
 				--entry_count_remaining;
@@ -935,12 +940,12 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha, void **pkt,
 				ql_log(ql_log_warn, vha, 0x5044,
 				       "Attempt to copy more that we got, optimizing..%x\n",
 				       buffer_copy_offset);
-				memcpy(((uint8_t *)iocb_pkt + buffer_copy_offset),
-				       new_pkt->data,
-				       total_bytes - buffer_copy_offset);
+				memcpy(((uint8_t *)iocb_pkt +
+					buffer_copy_offset), data,
+					total_bytes - buffer_copy_offset);
 			}
 
-			((response_t *)new_pkt)->signature = RESPONSE_PROCESSED;
+			((response_t *)*pkt)->signature = RESPONSE_PROCESSED;
 			wmb();
 		}
 
@@ -1144,8 +1149,13 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 		      struct rsp_que **rsp)
 {
 	struct purex_entry_24xx *purex = *pkt;
+	struct qla_hw_data *ha = vha->hw;
 	struct rsp_que *rsp_q = *rsp;
-	sts_cont_entry_t *new_pkt;
+	size_t payload_size = IS_QLA29XX(ha) ?
+		sizeof_field(struct purex_entry_24xx_ext, els_frame_payload) :
+		sizeof_field(struct purex_entry_24xx, els_frame_payload);
+	u8 *data;
+	u32 data_sz;
 	uint16_t no_bytes = 0, total_bytes = 0, pending_bytes = 0;
 	uint16_t buffer_copy_offset = 0;
 	uint16_t entry_count, entry_count_remaining;
@@ -1160,8 +1170,8 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 
 	pending_bytes = total_bytes;
 	entry_count = entry_count_remaining = purex->entry_count;
-	no_bytes = (pending_bytes > sizeof(purex->els_frame_payload))  ?
-		   sizeof(purex->els_frame_payload) : pending_bytes;
+	no_bytes = (pending_bytes > payload_size) ?
+		   payload_size : pending_bytes;
 	ql_log(ql_log_info, vha, 0x509a,
 	       "FPIN ELS, frame_size 0x%x, entry count %d\n",
 	       total_bytes, entry_count);
@@ -1172,7 +1182,13 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 
 	fpin_pkt = &item->iocb;
 
-	memcpy(fpin_pkt, &purex->els_frame_payload[0], no_bytes);
+	if (IS_QLA29XX(ha)) {
+		struct purex_entry_24xx_ext *purex_ext = *pkt;
+
+		memcpy(fpin_pkt, &purex_ext->els_frame_payload[0], no_bytes);
+	} else {
+		memcpy(fpin_pkt, &purex->els_frame_payload[0], no_bytes);
+	}
 	buffer_copy_offset += no_bytes;
 	pending_bytes -= no_bytes;
 	--entry_count_remaining;
@@ -1190,10 +1206,12 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 				continue;
 			}
 
-			new_pkt = (sts_cont_entry_t *)rsp_q->ring_ptr;
-			*pkt = new_pkt;
+			*pkt = rsp_q->ring_ptr;
+			data = ((sts_cont_entry_t *)*pkt)->data;
+			data_sz = qla_sts_cont_data_size(ha);
 
-			if (new_pkt->entry_type != STATUS_CONT_TYPE) {
+			if (((sts_cont_entry_t *)*pkt)->entry_type !=
+			    STATUS_CONT_TYPE) {
 				ql_log(ql_log_warn, vha, 0x507a,
 				       "Unexpected IOCB type, partial data 0x%x\n",
 				       buffer_copy_offset);
@@ -1201,11 +1219,11 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 			}
 
 			qla_rsp_ring_advance(rsp_q);
-			no_bytes = (pending_bytes > sizeof(new_pkt->data)) ?
-			    sizeof(new_pkt->data) : pending_bytes;
+			no_bytes = (pending_bytes > data_sz) ?
+			    data_sz : pending_bytes;
 			if ((buffer_copy_offset + no_bytes) <= total_bytes) {
 				memcpy(((uint8_t *)fpin_pkt +
-				    buffer_copy_offset), new_pkt->data,
+				    buffer_copy_offset), data,
 				    no_bytes);
 				buffer_copy_offset += no_bytes;
 				pending_bytes -= no_bytes;
@@ -1215,11 +1233,11 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 				       "Attempt to copy more that we got, optimizing..%x\n",
 				       buffer_copy_offset);
 				memcpy(((uint8_t *)fpin_pkt +
-				    buffer_copy_offset), new_pkt->data,
+				    buffer_copy_offset), data,
 				    total_bytes - buffer_copy_offset);
 			}
 
-			((response_t *)new_pkt)->signature = RESPONSE_PROCESSED;
+			((response_t *)*pkt)->signature = RESPONSE_PROCESSED;
 			wmb();
 		}
 
@@ -2918,7 +2936,8 @@ static void qla2x00_process_response_entry(struct scsi_qla_host *vha,
 						sts22_entry->handle[cnt]);
 		break;
 	case STATUS_CONT_TYPE:
-		qla2x00_status_cont_entry(rsp, (sts_cont_entry_t *)pkt);
+		qla2x00_status_cont_entry(rsp, pkt,
+		    qla_sts_cont_data_size(rsp->hw));
 		break;
 	case MBX_IOCB_TYPE:
 		qla2x00_mbx_iocb_entry(vha, rsp->req, (struct mbx_entry *)pkt);
@@ -3682,7 +3701,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
  * Extended sense data.
  */
 static void
-qla2x00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
+qla2x00_status_cont_entry(struct rsp_que *rsp, void *pkt, u32 data_sz)
 {
 	uint8_t	sense_sz = 0;
 	struct qla_hw_data *ha = rsp->hw;
@@ -3691,6 +3710,7 @@ qla2x00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
 	struct scsi_cmnd *cp;
 	uint32_t sense_len;
 	uint8_t *sense_ptr;
+	u8 *data = ((sts_cont_entry_t *)pkt)->data;
 
 	if (!sp || !GET_CMD_SENSE_LEN(sp))
 		return;
@@ -3707,15 +3727,15 @@ qla2x00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
 		return;
 	}
 
-	if (sense_len > sizeof(pkt->data))
-		sense_sz = sizeof(pkt->data);
+	if (sense_len > data_sz)
+		sense_sz = data_sz;
 	else
 		sense_sz = sense_len;
 
 	/* Move sense data. */
 	if (IS_FWI2_CAPABLE(ha))
-		host_to_fcp_swap(pkt->data, sizeof(pkt->data));
-	memcpy(sense_ptr, pkt->data, sense_sz);
+		host_to_fcp_swap(data, data_sz);
+	memcpy(sense_ptr, data, sense_sz);
 	ql_dump_buffer(ql_dbg_io + ql_dbg_buffer, vha, 0x302c,
 		sense_ptr, sense_sz);
 
@@ -3997,7 +4017,8 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			qla2x00_status_entry(vha, rsp, pkt);
 			break;
 		case STATUS_CONT_TYPE:
-			qla2x00_status_cont_entry(rsp, (sts_cont_entry_t *)pkt);
+			qla2x00_status_cont_entry(rsp, pkt,
+			    qla_sts_cont_data_size(rsp->hw));
 			break;
 		case VP_RPT_ID_IOCB_TYPE:
 			qla24xx_report_id_acquisition(vha,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3be59179a024..fdb53811e0c7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8411,6 +8411,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(sts21_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(sts22_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(sts_cont_entry_t) != 64);
+	BUILD_BUG_ON(sizeof(struct sts_cont_entry_ext) != 128);
 	BUILD_BUG_ON(sizeof(sts_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(sw_info_t) != 32);
 	BUILD_BUG_ON(sizeof(target_id_t) != 2);
-- 
2.47.3

