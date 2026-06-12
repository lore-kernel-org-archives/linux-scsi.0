Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00115368D43
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258128; cv=none; b=ro9M/AHsvv/EZsdLlY0tmTgFcfXIaKwUeTdWUPdaUuql3ROXo0r7SI7sZn6PrA00H+whyPGZgw0ArHm8Oi9QMSws4j11BEseejxuxaHVUp37Pv7AeTj5axFJzwJIoUUr+cwGkndrIWb4q3XnHaZMLkERwfirBQjOS1q6uEVKfGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258128; c=relaxed/simple;
	bh=UVDist/VrCX4O0xfBO8Z9M1aGDqcbfEV+WyMNPceeZA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p5fz7K3kGJ2DGhdZc37L5hTKkImwH6HjYqU+z3twrltFsV4V3KfiX/FjmAnrkgVu12F8XYphIuJ2ocQVxtlc8+JkGc8f9PqHjzPaSroRmPvfjxAM1YqOYCbSx+NqoPg25W40Cs7xS6+yS606FrIjBTfKFMbndeEv3T7f8KSb4Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=FGCJX+j7; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="FGCJX+j7"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C39Xos3782589;
	Fri, 12 Jun 2026 02:55:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=k
	ELswim594ZXtpFLxuYup/JFfIxnk9Depy58FRF9AYo=; b=FGCJX+j7qaJe62pwT
	lu62u4D3sd/EY5FMU59OrKZ0chmfx/3hPiYsznUjdXvleoQFw9vPRzqDd7l3pk8r
	+kOTGbYbd6PIABKFzkSBXF6AA8Z06RF8GdbQ0h7ZzJEffpCNWtzv6c2i/VA2n/KP
	MQVkfWb+usmqgXO9BtWOr7SdYU1Fmn3oYQj7JPMhRAIPu4P/TUXplpaX+I4D3KEP
	4mU27YAB2lK++yV7Uwz+gqGnXAtazmnmGQjrDjzk7dFUtk8md10DLW+hMxtC+fQj
	hhY20T542CHZ6F7tIlc/y4RXIbCYP9JhJTBC684WOtLEuRDsyPYLpgLZNcguCSVJ
	B3vDQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4er6r2hjhg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:55:24 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:55:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:55:22 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 76F413F7040;
	Fri, 12 Jun 2026 02:55:20 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 28/60] scsi: qla2xxx: Handle sts_cont_entry_ext_t for 29xx adapters
Date: Fri, 12 Jun 2026 15:23:01 +0530
Message-ID: <20260612095333.1666592-29-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX7Z2GrGHQpSi4
 h5g59NFVjfh6X+MhkUUyiDDoXcqqBPuFQG/DklOfrcxLotmq9ZGwaNgjfrkH1NxWU74SGDs21Lf
 hOLAfnmuRKFM+Fr8mDnWV2kJHKtrdI8nirjE9gOG/JwnqZ4U31AR2BA6cnGBx1tSrx2hOb5HQdu
 5kkrBzMQJUsHAhktQ1XiqJ3rzeyQxwGFDgVDV2xOhgRpcbkeiWt1QGRho7qJ1/FxLBJmb0+jPvR
 EirXeB2gChuCvTdzuq5W8KsXdPpx7fGc2c+3UGFyPHS9FceXAhSunSAXvlEPxtPZgQlexf+jkug
 Jk8sNSHmPOYLC95BWrCCittb56kMddl8ahM8XMg3jgrjHNn3jNTW1J4Y+y1/9m4Ydc4Lt8bUzyY
 xdgFpwafbo47txIVIX+Exn9QFcTw1uARCkHYzvy7qfhb5Zwq0QAIyAbm84GHqkiHuLhLIFNkpf0
 wlqfQdzGsOB2pB/QNlA==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a2bd78c cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=6bq2EJHy0pCLO45fYVoA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfXy82fUvV23I3u
 ZCUIrK+2Hy+RJ3slER3oIaaXmJF1PoqOCWsfPDNSCngH4Wv1amJdliS6Z7w0Va24XtNgFM3sTFk
 Dk/eknGOYbvkx15TUpYBr2B9fBsZzHU=
X-Proofpoint-GUID: Hg-VXygLqjHuQADbIk4r97UkIKOe4Nmv
X-Proofpoint-ORIG-GUID: Hg-VXygLqjHuQADbIk4r97UkIKOe4Nmv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

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
---
 drivers/scsi/qla2xxx/qla_isr.c | 192 +++++++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_os.c  |   1 +
 2 files changed, 139 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e95fb0e59f38..c18ee2459f5b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -19,7 +19,7 @@
 
 static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
 static void qla2x00_status_entry(scsi_qla_host_t *, struct rsp_que *, void *);
-static void qla2x00_status_cont_entry(struct rsp_que *, sts_cont_entry_t *);
+static void qla2x00_status_cont_entry(struct rsp_que *, void *);
 static int qla2x00_error_entry(scsi_qla_host_t *, struct rsp_que *,
 	sts_entry_t *);
 static void qla27xx_process_purex_fpin(struct scsi_qla_host *vha,
@@ -231,8 +231,15 @@ int __qla_copy_purex_to_buffer(struct scsi_qla_host *vha,
 	void **pkt, struct rsp_que **rsp, u8 *buf, u32 buf_len)
 {
 	struct purex_entry_24xx *purex = *pkt;
+	struct qla_hw_data *ha = vha->hw;
 	struct rsp_que *rsp_q = *rsp;
 	sts_cont_entry_t *new_pkt;
+	struct sts_cont_entry_ext *new_pkt29;
+	size_t payload_size = IS_QLA29XX(ha) ?
+		sizeof_field(struct purex_entry_24xx_ext, els_frame_payload) :
+		sizeof_field(struct purex_entry_24xx, els_frame_payload);
+	u8 *data;
+	u32 data_sz;
 	uint16_t no_bytes = 0, total_bytes = 0, pending_bytes = 0;
 	uint16_t buffer_copy_offset = 0;
 	uint16_t entry_count_remaining;
@@ -271,21 +278,37 @@ int __qla_copy_purex_to_buffer(struct scsi_qla_host *vha,
 
 	do {
 		while ((total_bytes > 0) && (entry_count_remaining > 0)) {
-			new_pkt = (sts_cont_entry_t *)rsp_q->ring_ptr;
-			*pkt = new_pkt;
+			if (IS_QLA29XX(ha)) {
+				new_pkt29 = (struct sts_cont_entry_ext *)rsp_q->ring_ptr;
+				*pkt = new_pkt29;
+
+				if (new_pkt29->entry_type != STATUS_CONT_TYPE) {
+					ql_log(ql_log_warn, vha, 0x507a,
+					    "Unexpected IOCB type, partial data 0x%x\n",
+					    buffer_copy_offset);
+					break;
+				}
+				data = new_pkt29->data;
+				data_sz = sizeof(new_pkt29->data);
+			} else {
+				new_pkt = (sts_cont_entry_t *)rsp_q->ring_ptr;
+				*pkt = new_pkt;
 
-			if (new_pkt->entry_type != STATUS_CONT_TYPE) {
-				ql_log(ql_log_warn, vha, 0x507a,
-				    "Unexpected IOCB type, partial data 0x%x\n",
-				    buffer_copy_offset);
-				break;
+				if (new_pkt->entry_type != STATUS_CONT_TYPE) {
+					ql_log(ql_log_warn, vha, 0x507a,
+					    "Unexpected IOCB type, partial data 0x%x\n",
+					    buffer_copy_offset);
+					break;
+				}
+				data = new_pkt->data;
+				data_sz = sizeof(new_pkt->data);
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
@@ -294,11 +317,16 @@ int __qla_copy_purex_to_buffer(struct scsi_qla_host *vha,
 				ql_log(ql_log_warn, vha, 0x5044,
 				    "Attempt to copy more that we got, optimizing..%x\n",
 				    buffer_copy_offset);
-				memcpy((buf + buffer_copy_offset), new_pkt->data,
+				memcpy((buf + buffer_copy_offset), data,
 				    total_bytes - buffer_copy_offset);
 			}
 
-			((response_t *)new_pkt)->signature = RESPONSE_PROCESSED;
+			if (IS_QLA29XX(ha))
+				((struct response_ext *)new_pkt29)->signature =
+				    RESPONSE_PROCESSED;
+			else
+				((response_t *)new_pkt)->signature =
+				    RESPONSE_PROCESSED;
 			/* flush signature */
 			wmb();
 		}
@@ -844,13 +872,15 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha, void **pkt,
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
@@ -906,28 +936,33 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha, void **pkt,
 				continue;
 			}
 
-			new_pkt = (sts_cont_entry_t *)rsp_q->ring_ptr;
-			*pkt = new_pkt;
+			*pkt = rsp_q->ring_ptr;
+			if (IS_QLA29XX(ha)) {
+				struct sts_cont_entry_ext *p = *pkt;
+
+				data = p->data;
+				data_sz = sizeof(p->data);
+			} else {
+				sts_cont_entry_t *p = *pkt;
+
+				data = p->data;
+				data_sz = sizeof(p->data);
+			}
 
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
@@ -935,12 +970,12 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha, void **pkt,
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
 
@@ -1144,8 +1179,15 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 		      struct rsp_que **rsp)
 {
 	struct purex_entry_24xx *purex = *pkt;
+	struct qla_hw_data *ha = vha->hw;
 	struct rsp_que *rsp_q = *rsp;
 	sts_cont_entry_t *new_pkt;
+	struct sts_cont_entry_ext *new_pkt29;
+	size_t payload_size = IS_QLA29XX(ha) ?
+		sizeof_field(struct purex_entry_24xx_ext, els_frame_payload) :
+		sizeof_field(struct purex_entry_24xx, els_frame_payload);
+	u8 *data;
+	u32 data_sz;
 	uint16_t no_bytes = 0, total_bytes = 0, pending_bytes = 0;
 	uint16_t buffer_copy_offset = 0;
 	uint16_t entry_count, entry_count_remaining;
@@ -1160,8 +1202,8 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 
 	pending_bytes = total_bytes;
 	entry_count = entry_count_remaining = purex->entry_count;
-	no_bytes = (pending_bytes > sizeof(purex->els_frame_payload))  ?
-		   sizeof(purex->els_frame_payload) : pending_bytes;
+	no_bytes = (pending_bytes > payload_size) ?
+		   payload_size : pending_bytes;
 	ql_log(ql_log_info, vha, 0x509a,
 	       "FPIN ELS, frame_size 0x%x, entry count %d\n",
 	       total_bytes, entry_count);
@@ -1172,7 +1214,13 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 
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
@@ -1190,22 +1238,39 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 				continue;
 			}
 
-			new_pkt = (sts_cont_entry_t *)rsp_q->ring_ptr;
-			*pkt = new_pkt;
+			if (IS_QLA29XX(ha)) {
+				new_pkt29 =
+				    (struct sts_cont_entry_ext *)rsp_q->ring_ptr;
+				*pkt = new_pkt29;
 
-			if (new_pkt->entry_type != STATUS_CONT_TYPE) {
-				ql_log(ql_log_warn, vha, 0x507a,
-				       "Unexpected IOCB type, partial data 0x%x\n",
-				       buffer_copy_offset);
-				break;
+				if (new_pkt29->entry_type != STATUS_CONT_TYPE) {
+					ql_log(ql_log_warn, vha, 0x507a,
+					       "Unexpected IOCB type, partial data 0x%x\n",
+					       buffer_copy_offset);
+					break;
+				}
+				data = new_pkt29->data;
+				data_sz = sizeof(new_pkt29->data);
+			} else {
+				new_pkt = (sts_cont_entry_t *)rsp_q->ring_ptr;
+				*pkt = new_pkt;
+
+				if (new_pkt->entry_type != STATUS_CONT_TYPE) {
+					ql_log(ql_log_warn, vha, 0x507a,
+					       "Unexpected IOCB type, partial data 0x%x\n",
+					       buffer_copy_offset);
+					break;
+				}
+				data = new_pkt->data;
+				data_sz = sizeof(new_pkt->data);
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
@@ -1215,11 +1280,16 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 				       "Attempt to copy more that we got, optimizing..%x\n",
 				       buffer_copy_offset);
 				memcpy(((uint8_t *)fpin_pkt +
-				    buffer_copy_offset), new_pkt->data,
+				    buffer_copy_offset), data,
 				    total_bytes - buffer_copy_offset);
 			}
 
-			((response_t *)new_pkt)->signature = RESPONSE_PROCESSED;
+			if (IS_QLA29XX(ha))
+				((struct response_ext *)new_pkt29)->signature =
+				    RESPONSE_PROCESSED;
+			else
+				((response_t *)new_pkt)->signature =
+				    RESPONSE_PROCESSED;
 			wmb();
 		}
 
@@ -2918,7 +2988,7 @@ static void qla2x00_process_response_entry(struct scsi_qla_host *vha,
 						sts22_entry->handle[cnt]);
 		break;
 	case STATUS_CONT_TYPE:
-		qla2x00_status_cont_entry(rsp, (sts_cont_entry_t *)pkt);
+		qla2x00_status_cont_entry(rsp, pkt);
 		break;
 	case MBX_IOCB_TYPE:
 		qla2x00_mbx_iocb_entry(vha, rsp->req, (struct mbx_entry *)pkt);
@@ -3682,7 +3752,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
  * Extended sense data.
  */
 static void
-qla2x00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
+qla2x00_status_cont_entry(struct rsp_que *rsp, void *pkt)
 {
 	uint8_t	sense_sz = 0;
 	struct qla_hw_data *ha = rsp->hw;
@@ -3691,6 +3761,8 @@ qla2x00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
 	struct scsi_cmnd *cp;
 	uint32_t sense_len;
 	uint8_t *sense_ptr;
+	u8 *data;
+	u32 data_sz;
 
 	if (!sp || !GET_CMD_SENSE_LEN(sp))
 		return;
@@ -3707,15 +3779,27 @@ qla2x00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
 		return;
 	}
 
-	if (sense_len > sizeof(pkt->data))
-		sense_sz = sizeof(pkt->data);
+	if (IS_QLA29XX(ha)) {
+		struct sts_cont_entry_ext *pkt29 = pkt;
+
+		data = pkt29->data;
+		data_sz = sizeof(pkt29->data);
+	} else {
+		sts_cont_entry_t *sts_pkt = pkt;
+
+		data = sts_pkt->data;
+		data_sz = sizeof(sts_pkt->data);
+	}
+
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
 
@@ -3997,7 +4081,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			qla2x00_status_entry(vha, rsp, pkt);
 			break;
 		case STATUS_CONT_TYPE:
-			qla2x00_status_cont_entry(rsp, (sts_cont_entry_t *)pkt);
+			qla2x00_status_cont_entry(rsp, pkt);
 			break;
 		case VP_RPT_ID_IOCB_TYPE:
 			qla24xx_report_id_acquisition(vha,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9dd181feeb87..fc94eb62fc49 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8410,6 +8410,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(sts21_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(sts22_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(sts_cont_entry_t) != 64);
+	BUILD_BUG_ON(sizeof(struct sts_cont_entry_ext) != 128);
 	BUILD_BUG_ON(sizeof(sts_entry_t) != 64);
 	BUILD_BUG_ON(sizeof(sw_info_t) != 32);
 	BUILD_BUG_ON(sizeof(target_id_t) != 2);
-- 
2.47.3

