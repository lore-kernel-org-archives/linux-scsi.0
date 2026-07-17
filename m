Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4983B176FB1
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302195; cv=none; b=IjSJibvWDXdkD1RGiPrU2uLXfqQZlCIIEfjbBifKexqGgWkZEMoayt+uyNaSCILTZst0uB0SClEAsiQ/7oEZgsnw9+zMSx7zJv4zRJdSiUMtQCyuiPe5kGTJt3XJEb9ldOib8a981i5w5eZGpRKIiVStSmYhC+b1MhzzzPCz0kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302195; c=relaxed/simple;
	bh=ne4yTsq1x0xiWovj9dw6cwQ8hSOCkwlDl0kVIfBhVYU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DcmrZ4JUYV5XAAyrxR0/vtKhV1bvc4qhq9GAEfEja5FNe8HWhVkumtrVYQD98kJ7DKx0cqd0wvoZjiiLiRXhnj2bQcjI3kSaFimIiVXm5eX0GmkW94i22o7VFR6+qtjP12ccmGJi49o+FH+ys5gswxbT/WsuyP7LAQhaN58hWQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=fo1NC4AD; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fo1NC4AD"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE80Ua094827;
	Fri, 17 Jul 2026 08:29:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=r
	CS5FRGGDTUi7rc7bKuVD07nxh3khmCu3AbzZlwF4Tw=; b=fo1NC4AD8RVlSuayZ
	QMeghlDqyNJ1ci3Mn9cY5zrUK7gqEv9yjZw1CJSSIR9eyIHR31Yaw3W7kNVNzun+
	LUFiMGr2OtxbIp9d6pvBv9LzOFWD45aOFRUzYAXBXzhHtP9geyHXloxFOcWiRhYA
	3gZAd5RDgfNzEPAVG6q09thCBU9FslJNDBloq/O+c4Yic2dxJ3a+88wnhOHgmzJw
	FbZeX4+9r4KPZEOmIfM3mUXSoQ+6QaPyDcFBKoGm0DfPMs0RK2x83p5BGhfjLagc
	v8HJZFAN6u5pI6/b7RLMg1PUxcR1GL5kXheHC4+3lwPAvvu43szUgQw9CbjHdZ/P
	nVvCg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4ffhg8rxa5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:29:45 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:29:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:29:43 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 7E5CF5B693B;
	Fri, 17 Jul 2026 08:29:40 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 11/56] scsi: qla2xxx: Update IO path to use 128-byte IOCBs for 29xx
Date: Fri, 17 Jul 2026 20:58:19 +0530
Message-ID: <20260717152904.3155730-12-njavali@marvell.com>
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
X-Proofpoint-GUID: n4DOJTyrYIlTrNdgoSvRZLdDLfTrIm6j
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfXzLEj4jfQYoqR
 zJMBcn8oY73haL7zSyrlO3m5/P/c71bdZmzisU12xFYB8wVPQd+ZrzI2pAgSdVbVm+L91eboCSe
 rSbC625ANmZ2LP867I21cSqeYK+D6J4=
X-Authority-Analysis: v=2.4 cv=SpKgLvO0 c=1 sm=1 tr=0 ts=6a5a4a69 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=M5GUcnROAAAA:8
 a=wazruIWr-kOBu5qCteQA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX4XUZzLYueJVe
 VJsHZlBbTahTlyZz5S28FxR/CaaKj7uXuHTJzcZJJWFIysb6p3W+R5s2S+Yy0Cn0h04nyV7BBLT
 JI61g0/L+e3wPEW6ml1cJnXEtjxRhETMW+ZnZKw4hoEW/TGB8ny2Ghjy52lq0W/7hnnzTulVB78
 AQWcFAjPhCAJC4lNq+ic91F8UmCOO5mmfC3JSPQ7VTRojVWz4TZDDe0CcrmjYcCcKI3YkHe/6JQ
 dM1EB2v/k8/E2KTW/FmSS9uBkamj+SuarzoDpi0SOV6FWH4T/xiuUPynjGb5wzc/zHtl3AW0/3/
 gEAgnIc9mevoXLQoltuPSZQksUMyI/UvswOQqVLoLZmPiUQPZd7xcc5J7TL+q5Lbe5aOU/9gSpP
 Ch9bkvqrl0tRhgbFWJDNizcBGXfPPCUd9EXm0C3AZyU/uqV94/te6ooZ3kHoZKckS5sadi58v7Z
 dgOxSEpnwffKQKXskQw==
X-Proofpoint-ORIG-GUID: n4DOJTyrYIlTrNdgoSvRZLdDLfTrIm6j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

From: Anil Gurumurthy <agurumurthy@marvell.com>

Wire the 128-byte extended IOCB structures into the IO submission,
completion, and queue-management paths.  On 29xx adapters the driver
now builds cmd_type_6_ext / cmd_type_7_ext command IOCBs and processes
the corresponding extended status entries, while falling back to the
existing 64-byte IOCBs for earlier adapters.

Ring entry-size selection uses the qla_req_entry_size() /
qla_rsp_entry_size() helpers and ring slot advancement uses
qla_req_ring_advance() rather than open-coding IS_QLA29XX() branches
at every call site.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607141827.R9mpeMZx-lkp@intel.com/
Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_dbg.c    |   31 +-
 drivers/scsi/qla2xxx/qla_def.h    |   29 +-
 drivers/scsi/qla2xxx/qla_edif.c   |   18 +-
 drivers/scsi/qla2xxx/qla_fw29.h   |   77 ++
 drivers/scsi/qla2xxx/qla_gbl.h    |    4 +-
 drivers/scsi/qla2xxx/qla_init.c   |   53 +-
 drivers/scsi/qla2xxx/qla_inline.h |  174 ++++-
 drivers/scsi/qla2xxx/qla_iocb.c   | 1116 ++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_isr.c    |   55 +-
 drivers/scsi/qla2xxx/qla_mid.c    |   65 +-
 drivers/scsi/qla2xxx/qla_nvme.c   |  156 ++--
 drivers/scsi/qla2xxx/qla_os.c     |   39 +-
 drivers/scsi/qla2xxx/qla_target.c |   34 +-
 13 files changed, 1497 insertions(+), 354 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index a7e3ec9bba47..acb58daacf35 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -89,16 +89,17 @@ qla2xxx_copy_queues(struct qla_hw_data *ha, void *ptr)
 {
 	struct req_que *req = ha->req_q_map[0];
 	struct rsp_que *rsp = ha->rsp_q_map[0];
+	size_t req_entry_size = qla_req_entry_size(ha);
+	size_t rsp_entry_size = qla_rsp_entry_size(ha);
+
 	/* Request queue. */
-	memcpy(ptr, req->ring, req->length *
-	    sizeof(request_t));
+	memcpy(ptr, req->ring, req->length * req_entry_size);
 
 	/* Response queue. */
-	ptr += req->length * sizeof(request_t);
-	memcpy(ptr, rsp->ring, rsp->length  *
-	    sizeof(response_t));
+	ptr += req->length * req_entry_size;
+	memcpy(ptr, rsp->ring, rsp->length * rsp_entry_size);
 
-	return ptr + (rsp->length * sizeof(response_t));
+	return ptr + (rsp->length * rsp_entry_size);
 }
 
 int
@@ -606,6 +607,8 @@ qla25xx_copy_mqueues(struct qla_hw_data *ha, void *ptr, __be32 **last_chain)
 	struct req_que *req;
 	struct rsp_que *rsp;
 	int que;
+	size_t req_entry_size = qla_req_entry_size(ha);
+	size_t rsp_entry_size = qla_rsp_entry_size(ha);
 
 	if (!ha->mqenable)
 		return ptr;
@@ -623,19 +626,19 @@ qla25xx_copy_mqueues(struct qla_hw_data *ha, void *ptr, __be32 **last_chain)
 		q->chain_size = htonl(
 		    sizeof(struct qla2xxx_mqueue_chain) +
 		    sizeof(struct qla2xxx_mqueue_header) +
-		    (req->length * sizeof(request_t)));
+		    (req->length * req_entry_size));
 		ptr += sizeof(struct qla2xxx_mqueue_chain);
 
 		/* Add header. */
 		qh = ptr;
 		qh->queue = htonl(TYPE_REQUEST_QUEUE);
 		qh->number = htonl(que);
-		qh->size = htonl(req->length * sizeof(request_t));
+		qh->size = htonl(req->length * req_entry_size);
 		ptr += sizeof(struct qla2xxx_mqueue_header);
 
 		/* Add data. */
-		memcpy(ptr, req->ring, req->length * sizeof(request_t));
-		ptr += req->length * sizeof(request_t);
+		memcpy(ptr, req->ring, req->length * req_entry_size);
+		ptr += req->length * req_entry_size;
 	}
 
 	/* Response queues */
@@ -651,19 +654,19 @@ qla25xx_copy_mqueues(struct qla_hw_data *ha, void *ptr, __be32 **last_chain)
 		q->chain_size = htonl(
 		    sizeof(struct qla2xxx_mqueue_chain) +
 		    sizeof(struct qla2xxx_mqueue_header) +
-		    (rsp->length * sizeof(response_t)));
+		    (rsp->length * rsp_entry_size));
 		ptr += sizeof(struct qla2xxx_mqueue_chain);
 
 		/* Add header. */
 		qh = ptr;
 		qh->queue = htonl(TYPE_RESPONSE_QUEUE);
 		qh->number = htonl(que);
-		qh->size = htonl(rsp->length * sizeof(response_t));
+		qh->size = htonl(rsp->length * rsp_entry_size);
 		ptr += sizeof(struct qla2xxx_mqueue_header);
 
 		/* Add data. */
-		memcpy(ptr, rsp->ring, rsp->length * sizeof(response_t));
-		ptr += rsp->length * sizeof(response_t);
+		memcpy(ptr, rsp->ring, rsp->length * rsp_entry_size);
+		ptr += rsp->length * rsp_entry_size;
 	}
 
 	return ptr;
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 4de0de5cccc8..7220617c2568 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -577,7 +577,7 @@ struct srb_iocb {
 			__le16 comp_status;
 
 			uint8_t modifier;
-			uint8_t vp_index;
+			uint16_t vp_index;
 			uint16_t loop_id;
 		} tmf;
 		struct {
@@ -2528,6 +2528,14 @@ struct imm_ntfy_from_isp {
 #define REQUEST_ENTRY_SIZE	(sizeof(request_t))
 
 
+/*
+ * 29xx (qla29xx) uses 128-byte ring entries for both request and response
+ * queues.  These macros give the size of an extended IOCB slot and are
+ * used when allocating from / zeroing the 29xx request ring via ring_ext_ptr.
+ */
+#define RESPONSE_ENTRY_SIZE_EXT (sizeof(struct response_ext))
+#define REQUEST_ENTRY_SIZE_EXT  (sizeof(struct request_ext))
+
 
 /*
  * Switch info gathering structure.
@@ -3789,6 +3797,14 @@ struct rsp_que {
 	dma_addr_t  dma;
 	response_t *ring;
 	response_t *ring_ptr;
+	/*
+	 * 29xx extended IOCB ring (128-byte entries) aliases of ring/ring_ptr.
+	 * Allocated when IS_QLA29XX(ha); set up at queue-init time to point at
+	 * the same DMA memory as 'ring' but typed for the 29xx stride.  24xx
+	 * code paths walk via ring_ptr; 29xx paths walk via ring_ext_ptr.
+	 */
+	struct response_ext *ring_ext;
+	struct response_ext *ring_ext_ptr;
 	__le32	__iomem *rsp_q_in;	/* FWI2-capable only. */
 	__le32	__iomem *rsp_q_out;
 	uint16_t  ring_index;
@@ -3816,6 +3832,14 @@ struct req_que {
 	dma_addr_t  dma;
 	request_t *ring;
 	request_t *ring_ptr;
+	/*
+	 * 29xx extended IOCB ring (128-byte entries) aliases of ring/ring_ptr.
+	 * Allocated when IS_QLA29XX(ha); set up at queue-init time to point at
+	 * the same DMA memory as 'ring' but typed for the 29xx stride.  24xx
+	 * code paths must not run on 29xx HW, and vice-versa.
+	 */
+	struct request_ext *ring_ext;
+	struct request_ext *ring_ext_ptr;
 	__le32	__iomem *req_q_in;	/* FWI2-capable only. */
 	__le32	__iomem *req_q_out;
 	uint16_t  ring_index;
@@ -4488,7 +4512,8 @@ struct qla_hw_data {
 #define IS_ATIO_MSIX_CAPABLE(ha) (IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
 				IS_QLA28XX(ha))
 #define IS_TGT_MODE_CAPABLE(ha)	(ha->tgt.atio_q_length)
-#define IS_SHADOW_REG_CAPABLE(ha)  (IS_QLA27XX(ha) || IS_QLA28XX(ha))
+#define IS_SHADOW_REG_CAPABLE(ha)  (IS_QLA27XX(ha) || IS_QLA28XX(ha) || \
+				IS_QLA29XX(ha))
 #define IS_DPORT_CAPABLE(ha)  (IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
 				IS_QLA28XX(ha))
 #define IS_FAWWN_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index eccedb38a515..4416197a35b0 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2989,6 +2989,21 @@ qla28xx_start_scsi_edif(srb_t *sp)
 	struct req_que *req = sp->qpair->req;
 	spinlock_t *lock = sp->qpair->qp_lock_ptr;
 
+	/*
+	 * EDIF on 29xx is not supported by this driver yet.  The EDIF fast
+	 * path builds 64-byte cmd_type_6 IOCBs and advances req->ring_ptr
+	 * with a 64-byte stride, which would corrupt the 128-byte extended
+	 * request ring that 29xx hardware uses.  A proper 29xx EDIF port
+	 * requires a cmd_type_6_ext-shaped submission path; until that is
+	 * implemented, refuse the command rather than risk ring corruption.
+	 */
+	if (IS_QLA29XX(ha)) {
+		ql_log(ql_log_warn, vha, 0x13ae,
+		    "EDIF is not supported on 29xx hardware; failing cmd sp=%p.\n",
+		    sp);
+		return QLA_FUNCTION_FAILED;
+	}
+
 	/* Setup device pointers. */
 	cmd = GET_CMD_SP(sp);
 
@@ -3129,7 +3144,8 @@ qla28xx_start_scsi_edif(srb_t *sp)
 			 * Five DSDs are available in the Continuation
 			 * Type 1 IOCB.
 			 */
-			cont_pkt = qla2x00_prep_cont_type1_iocb(vha, req);
+			cont_pkt = qla2x00_prep_cont_type1_iocb(vha,
+			    ha, req);
 			cur_dsd = cont_pkt->dsd;
 			avail_dsds = 5;
 		}
diff --git a/drivers/scsi/qla2xxx/qla_fw29.h b/drivers/scsi/qla2xxx/qla_fw29.h
index efe1c60bee81..088a220472a5 100644
--- a/drivers/scsi/qla2xxx/qla_fw29.h
+++ b/drivers/scsi/qla2xxx/qla_fw29.h
@@ -95,6 +95,17 @@ struct cmd_type_7_ext {
 	struct dsd64 dsd[NUM_CMD67_DSDS];	/* Data Segment Descriptors */
 };
 
+/*
+ * Inline data-DSD capacity of the 29xx cmd_type_crc_2_ext IOCB.  Unlike
+ * cmd_type_6_ext / cmd_type_7_ext (which carry NUM_CMD67_DSDS inline DSDs),
+ * CRC_2 places the bulk of its DSDs in the separate CRC-context DMA; only
+ * a single data_dsd is carried inline in both the u.nobundling and
+ * u.bundling variants.  Use this constant wherever the IOCB-reservation
+ * calculator needs the CRC_2 ext inline capacity so it stays in sync with
+ * the firmware-facing layout below.
+ */
+#define NUM_CRC2_EXT_INLINE_DSDS	1
+
 struct cmd_type_crc_2_ext {
 	uint8_t entry_type;		/* Entry type. */
 	uint8_t entry_count;		/* Entry count. */
@@ -683,4 +694,70 @@ struct vp_rpt_id_entry_24xx_ext {
 		} f2;
 	} u;
 };
+
+/*
+ * ISP queue - 64-Bit addressing, continuation entry structure definition
+ * for the 29xx extended (128-byte) IOCB ring.  Mirrors cont_a64_entry_t
+ * but carries 10 DSDs per entry instead of 5.
+ */
+#define NUM_CONT1_DSDS	10
+struct cont_a64_entry_ext {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+	uint32_t reserved;
+	struct dsd64 dsd[NUM_CONT1_DSDS];
+};
+
+/*
+ * 29xx extended Command Type FC-NVMe IOCB (128 bytes).
+ *
+ * The header layout up through 'byte_count' (offset 48) is identical to the
+ * 64-byte struct cmd_nvme used by 24xx-class adapters, so common code can
+ * populate those fields via either type.  Fields beyond 'byte_count' diverge:
+ * 29xx adds control_flags_2/vp_index/first_burst_rx_id/io_tag/..., drops
+ * port_id[3]+vp_index(byte), and carries NUM_NVME_DSDS inline DSDs.
+ */
+#define NUM_NVME_DSDS	4
+struct cmd_nvme_ext {
+	uint8_t entry_type;		/* Entry type. */
+	uint8_t entry_count;		/* Entry count. */
+	uint8_t sys_define;		/* System defined. */
+	uint8_t entry_status;		/* Entry Status. */
+
+	uint32_t handle;		/* System handle. */
+	__le16	nport_handle;		/* N_PORT handle. */
+	__le16	timeout;		/* Command timeout. */
+
+	__le16	dseg_count;		/* Data segment count. */
+	__le16	nvme_rsp_dsd_len;	/* NVMe RSP DSD length */
+
+	uint64_t rsvd;
+
+	__le16	control_flags;		/* Control Flags (see struct cmd_nvme) */
+	__le16	nvme_cmnd_dseg_len;			/* Data segment length. */
+
+	__le64	 nvme_cmnd_dseg_address __packed;	/* Data segment address. */
+
+	__le64	 nvme_rsp_dseg_address __packed;	/* Data segment address. */
+
+	__le32	byte_count;		/* Total byte count. */
+
+	__le16	control_flags_2;
+	/*
+	 * vp_index layout matches the other 29xx extended IOCBs: only bits
+	 * [8:0] are meaningful (see CMD_EXT_VP_INDEX_MASK).
+	 */
+	__le16	vp_index;
+	__le32	first_burst_rx_id;
+	__le16	io_tag;
+	uint8_t vl_n_fctl;	/* VL(7:4) | RSVD(3:2) | F_CTL[17](1) | RSVD(0) */
+	uint8_t prtag_csctl;	/* Priority Tag or CS_CTL */
+	__le32	src_vm_id;	/* Source VM ID */
+	uint8_t reserved_2[16];
+
+	struct dsd64 nvme_dsd[NUM_NVME_DSDS];
+};
+
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 106f95a4e7f0..91900a601a97 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -297,7 +297,9 @@ void qla_adjust_buf(struct scsi_qla_host *);
 void qla_els_pt_iocb(struct scsi_qla_host *vha,
 	struct els_entry_24xx *pkt, struct qla_els_pt_arg *a);
 cont_a64_entry_t *qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *vha,
-		struct req_que *que);
+		struct qla_hw_data *ha, struct req_que *que);
+struct cont_a64_entry_ext *qla2900_prep_cont_type1_iocb(scsi_qla_host_t *vha,
+		struct req_que *req);
 extern uint16_t qla2x00_calc_iocbs_32(uint16_t);
 extern uint16_t qla2x00_calc_iocbs_64(uint16_t);
 extern void qla2x00_build_scsi_iocbs_32(srb_t *, cmd_entry_t *, uint16_t);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5b0dc9b0a679..1b011aea432f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3814,6 +3814,8 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 	struct req_que *req = ha->req_q_map[0];
 	struct rsp_que *rsp = ha->rsp_q_map[0];
 	struct qla2xxx_fw_dump *fw_dump;
+	size_t req_entry_size = qla_req_entry_size(ha);
+	size_t rsp_entry_size = qla_rsp_entry_size(ha);
 
 	if (ha->fw_dump) {
 		ql_dbg(ql_dbg_init, vha, 0x00bd,
@@ -3852,9 +3854,9 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 			 * Resizing must be done at end-of-dump processing.
 			 */
 			mq_size += (ha->max_req_queues - 1) *
-			    (req->length * sizeof(request_t));
+			    (req->length * req_entry_size);
 			mq_size += (ha->max_rsp_queues - 1) *
-			    (rsp->length * sizeof(response_t));
+			    (rsp->length * rsp_entry_size);
 		}
 		if (ha->tgt.atio_ring)
 			mq_size += ha->tgt.atio_q_length * sizeof(request_t);
@@ -3890,8 +3892,8 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		/* Add space for spare MPI fw dump. */
 		dump_size += ha->fwdt[1].dump_size;
 	} else {
-		req_q_size = req->length * sizeof(request_t);
-		rsp_q_size = rsp->length * sizeof(response_t);
+		req_q_size = req->length * req_entry_size;
+		rsp_q_size = rsp->length * rsp_entry_size;
 		dump_size = offsetof(struct qla2xxx_fw_dump, isp);
 		dump_size += fixed_size + mem_size + req_q_size + rsp_q_size
 			+ eft_size;
@@ -4479,15 +4481,33 @@ void
 qla2x00_init_response_q_entries(struct rsp_que *rsp)
 {
 	uint16_t cnt;
-	response_t *pkt;
 
 	rsp->ring_ptr = rsp->ring;
 	rsp->ring_index    = 0;
 	rsp->status_srb = NULL;
-	pkt = rsp->ring_ptr;
-	for (cnt = 0; cnt < rsp->length; cnt++) {
-		pkt->signature = RESPONSE_PROCESSED;
-		pkt++;
+
+	if (rsp->hw && IS_QLA29XX(rsp->hw)) {
+		/*
+		 * 29xx uses a 128-byte response-ring stride.  The signature
+		 * field offset matches response_t, but the entry pitch is
+		 * sizeof(struct response_ext); walk via ring_ext_ptr / struct response_ext.
+		 */
+		struct response_ext *pkt;
+
+		rsp->ring_ext_ptr = rsp->ring_ext;
+		pkt = rsp->ring_ext_ptr;
+		for (cnt = 0; cnt < rsp->length; cnt++) {
+			pkt->signature = RESPONSE_PROCESSED;
+			pkt++;
+		}
+	} else {
+		response_t *pkt;
+
+		pkt = rsp->ring_ptr;
+		for (cnt = 0; cnt < rsp->length; cnt++) {
+			pkt->signature = RESPONSE_PROCESSED;
+			pkt++;
+		}
 	}
 }
 
@@ -4808,7 +4828,12 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 		req = ha->req_q_map[que];
 		if (!req || !test_bit(que, ha->req_qid_map))
 			continue;
-		req->out_ptr = (uint16_t *)(req->ring + req->length);
+		if (IS_QLA29XX(ha))
+			req->out_ptr =
+			    (uint16_t *)(req->ring_ext + req->length);
+		else
+			req->out_ptr =
+			    (uint16_t *)(req->ring + req->length);
 		*req->out_ptr = 0;
 		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++)
 			req->outstanding_cmds[cnt] = NULL;
@@ -4819,13 +4844,19 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 		req->ring_ptr  = req->ring;
 		req->ring_index    = 0;
 		req->cnt      = req->length;
+		if (IS_QLA29XX(ha))
+			req->ring_ext_ptr = req->ring_ext;
 	}
 
 	for (que = 0; que < ha->max_rsp_queues; que++) {
 		rsp = ha->rsp_q_map[que];
 		if (!rsp || !test_bit(que, ha->rsp_qid_map))
 			continue;
-		rsp->in_ptr = (uint16_t *)(rsp->ring + rsp->length);
+		if (IS_QLA29XX(ha))
+			rsp->in_ptr =
+			    (uint16_t *)(rsp->ring_ext + rsp->length);
+		else
+			rsp->in_ptr = (uint16_t *)(rsp->ring + rsp->length);
 		*rsp->in_ptr = 0;
 		/* Initialize response queue entries */
 		if (IS_QLAFX00(ha))
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 47fbd830ff16..d5178e0ace22 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -54,6 +54,55 @@ qla2x00_debounce_register(volatile __le16 __iomem *addr)
 	return (first);
 }
 
+/**
+ * qla29xx_calc_iocbs() - Determine number of Command-Type and Continuation
+ * IOCBs to allocate for the 29xx extended (128-byte) IOCB ring.
+ * @vha: HA context
+ * @dsds: number of data segment descriptors needed
+ * @iocb_dsds: number of DSDs embedded in the first (command) IOCB.  The
+ *	remaining DSDs ride on Continuation Type 1 Ext IOCBs which hold
+ *	NUM_CONT1_DSDS (10) each.
+ *
+ * Returns the total number of IOCB entries needed to carry @dsds.
+ */
+static inline uint16_t
+qla29xx_calc_iocbs(scsi_qla_host_t *vha, uint16_t dsds, uint8_t iocb_dsds)
+{
+	uint16_t iocbs = 1;
+
+	if (dsds > iocb_dsds) {
+		iocbs += (dsds - iocb_dsds) / NUM_CONT1_DSDS;
+		if ((dsds - iocb_dsds) % NUM_CONT1_DSDS)
+			iocbs++;
+	}
+	return iocbs;
+}
+
+/**
+ * qla_req_entry_size() - request-ring entry stride.
+ * @ha: HBA pointer
+ *
+ * Returns sizeof(struct request_ext) (128) on 29xx, sizeof(request_t) (64)
+ * everywhere else.
+ */
+static inline size_t
+qla_req_entry_size(struct qla_hw_data *ha)
+{
+	return IS_QLA29XX(ha) ? sizeof(struct request_ext) : sizeof(request_t);
+}
+
+/**
+ * qla_rsp_entry_size() - response-ring entry stride.
+ * @ha: HBA pointer
+ *
+ * Counterpart of qla_req_entry_size() for the response ring.
+ */
+static inline size_t
+qla_rsp_entry_size(struct qla_hw_data *ha)
+{
+	return IS_QLA29XX(ha) ? sizeof(struct response_ext) : sizeof(response_t);
+}
+
 static inline void
 qla2x00_poll(struct rsp_que *rsp)
 {
@@ -358,17 +407,132 @@ static inline void
 qla_83xx_start_iocbs(struct qla_qpair *qpair)
 {
 	struct req_que *req = qpair->req;
+	struct qla_hw_data *ha = qpair->vha->hw;
 
+	/*
+	 * 29xx uses the 128-byte-strided extended request ring; advance the
+	 * matching ring_ext_ptr so the next IOCB allocator sees the correct
+	 * slot.  All other 83xx-family generations (83xx/27xx/28xx) keep the
+	 * 64-byte ring_ptr.
+	 */
 	req->ring_index++;
-	if (req->ring_index == req->length) {
-		req->ring_index = 0;
-		req->ring_ptr = req->ring;
-	} else
-		req->ring_ptr++;
+	if (IS_QLA29XX(ha)) {
+		if (req->ring_index == req->length) {
+			req->ring_index = 0;
+			req->ring_ext_ptr = req->ring_ext;
+		} else {
+			req->ring_ext_ptr++;
+		}
+	} else {
+		if (req->ring_index == req->length) {
+			req->ring_index = 0;
+			req->ring_ptr = req->ring;
+		} else {
+			req->ring_ptr++;
+		}
+	}
 
 	wrt_reg_dword(req->req_q_in, req->ring_index);
 }
 
+/**
+ * qla_rsp_ring_advance() - Advance the response queue consumer pointer
+ * to the next IOCB slot, handling both 24xx (64-byte) and 29xx (128-byte)
+ * ring strides.
+ *
+ * On 29xx, ring_ext_ptr is the authoritative slot pointer (correct 128-byte
+ * pitch) and ring_ptr is kept in sync as a response_t view of the same slot
+ * so existing 24xx-shaped reads (rsp->ring_ptr->signature,
+ * (struct sts_entry_24xx *)rsp->ring_ptr, etc.) keep working unchanged; the
+ * first 64 bytes of struct response_ext are layout-compatible with response_t.
+ */
+static inline void
+qla_rsp_ring_advance(struct rsp_que *rsp)
+{
+	rsp->ring_index++;
+	if (rsp->ring_index == rsp->length) {
+		rsp->ring_index = 0;
+		rsp->ring_ptr = rsp->ring;
+		if (rsp->hw && IS_QLA29XX(rsp->hw))
+			rsp->ring_ext_ptr = rsp->ring_ext;
+	} else if (rsp->hw && IS_QLA29XX(rsp->hw)) {
+		rsp->ring_ext_ptr++;
+		rsp->ring_ptr = (response_t *)rsp->ring_ext_ptr;
+	} else {
+		rsp->ring_ptr++;
+	}
+}
+
+/**
+ * qla_req_ring_slot() - return the current request-ring producer slot.
+ * @ha: HBA pointer
+ * @req: request queue
+ *
+ * On 29xx the firmware-visible ring uses 128-byte-strided entries
+ * referenced by ring_ext_ptr; on earlier adapters the 64-byte ring
+ * referenced by ring_ptr is used.  The returned pointer is
+ * layout-compatible with request_t for common header writes; callers
+ * needing 29xx-specific fields should cast to struct request_ext.
+ */
+static inline void *
+qla_req_ring_slot(struct qla_hw_data *ha, struct req_que *req)
+{
+	return IS_QLA29XX(ha) ? (void *)req->ring_ext_ptr
+			      : (void *)req->ring_ptr;
+}
+
+/**
+ * qla_req_ring_advance() - advance request-ring producer pointer.
+ * @ha: HBA pointer
+ * @req: request queue
+ *
+ * Mirrors qla_rsp_ring_advance().  Does NOT publish the new producer
+ * index to firmware; callers that need to do so should follow with a
+ * wrt_reg_dword or qla_83xx_start_iocbs().
+ */
+static inline void
+qla_req_ring_advance(struct qla_hw_data *ha, struct req_que *req)
+{
+	req->ring_index++;
+	if (IS_QLA29XX(ha)) {
+		if (req->ring_index == req->length) {
+			req->ring_index = 0;
+			req->ring_ext_ptr = req->ring_ext;
+		} else {
+			req->ring_ext_ptr++;
+		}
+	} else {
+		if (req->ring_index == req->length) {
+			req->ring_index = 0;
+			req->ring_ptr = req->ring;
+		} else {
+			req->ring_ptr++;
+		}
+	}
+}
+
+/**
+ * qla_rsp_ring_rewind_to() - Restore the response queue consumer pointer
+ * to a previously-observed slot (used when we need to defer processing an
+ * IOCB whose continuation entries have not yet arrived).
+ * @rsp: response queue
+ * @pkt: 64-byte view of the slot to rewind to (captured from a prior read
+ *       of rsp->ring_ptr)
+ * @idx: matching ring_index value (also captured before the advance)
+ *
+ * On 29xx, pkt was originally obtained as (response_t *)rsp->ring_ext_ptr,
+ * so casting back to struct response_ext * recovers the 128-byte-stride slot
+ * pointer.
+ */
+static inline void
+qla_rsp_ring_rewind_to(struct rsp_que *rsp, response_t *pkt, uint16_t idx)
+{
+	rsp->ring_ptr = pkt;
+	rsp->ring_index = idx;
+	if (rsp->hw && IS_QLA29XX(rsp->hw))
+		rsp->ring_ext_ptr = (struct response_ext *)pkt;
+}
+
 static inline int
 qla2xxx_get_fc4_priority(struct scsi_qla_host *vha)
 {
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index dbe3cd4e274c..aab7905c0d6c 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -12,6 +12,19 @@
 #include <scsi/scsi_tcq.h>
 
 static int qla_start_scsi_type6(srb_t *sp);
+
+/*
+ * 29xx extended IOCB builders, implemented later in this file.  Forward
+ * declared here because the unified 24xx/29xx fast paths dispatch to them
+ * via IS_QLA29XX() branches.
+ */
+static void qla29xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7_ext *cmd_pkt,
+	uint16_t tot_dsds, struct req_que *req);
+static void qla29xx_build_scsi_type_6_iocbs(srb_t *sp,
+	struct cmd_type_6_ext *cmd_pkt, uint16_t tot_dsds);
+static int qla29xx_build_scsi_crc_2_iocbs(srb_t *sp,
+	struct cmd_type_crc_2_ext *cmd_pkt, uint16_t tot_dsds,
+	uint16_t tot_prot_dsds, uint16_t fw_prot_opts);
 /**
  * qla2x00_get_cmd_direction() - Determine control_flag data direction.
  * @sp: SCSI command
@@ -115,25 +128,21 @@ qla2x00_prep_cont_type0_iocb(struct scsi_qla_host *vha)
 /**
  * qla2x00_prep_cont_type1_iocb() - Initialize a Continuation Type 1 IOCB.
  * @vha: HA context
+ * @ha: pointer to adapter hardware data
  * @req: request queue
  *
  * Returns a pointer to the continuation type 1 IOCB packet.
  */
 cont_a64_entry_t *
-qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *vha, struct req_que *req)
+qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *vha, struct qla_hw_data *ha,
+			      struct req_que *req)
 {
 	cont_a64_entry_t *cont_pkt;
 
 	/* Adjust ring index. */
-	req->ring_index++;
-	if (req->ring_index == req->length) {
-		req->ring_index = 0;
-		req->ring_ptr = req->ring;
-	} else {
-		req->ring_ptr++;
-	}
+	qla_req_ring_advance(ha, req);
 
-	cont_pkt = (cont_a64_entry_t *)req->ring_ptr;
+	cont_pkt = (cont_a64_entry_t *)qla_req_ring_slot(ha, req);
 
 	/* Load packet defaults. */
 	put_unaligned_le32(IS_QLAFX00(vha->hw) ? CONTINUE_A64_TYPE_FX00 :
@@ -284,7 +293,8 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 			 * Five DSDs are available in the Continuation
 			 * Type 1 IOCB.
 			 */
-			cont_pkt = qla2x00_prep_cont_type1_iocb(vha, vha->req);
+			cont_pkt = qla2x00_prep_cont_type1_iocb(vha,
+			    vha->hw, vha->req);
 			cur_dsd = cont_pkt->dsd;
 			avail_dsds = ARRAY_SIZE(cont_pkt->dsd);
 		}
@@ -464,16 +474,16 @@ qla2x00_start_iocbs(struct scsi_qla_host *vha, struct req_que *req)
 	if (IS_P3P_TYPE(ha)) {
 		qla82xx_start_iocbs(vha);
 	} else {
-		/* Adjust ring index. */
-		req->ring_index++;
-		if (req->ring_index == req->length) {
-			req->ring_index = 0;
-			req->ring_ptr = req->ring;
-		} else
-			req->ring_ptr++;
+		/*
+		 * Adjust ring index.  29xx uses a 128-byte-strided ring, so
+		 * advance the extended pointer; all other generations advance
+		 * the 64-byte ring_ptr.
+		 */
+		qla_req_ring_advance(ha, req);
 
 		/* Set chip new ring index. */
-		if (ha->mqenable || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (ha->mqenable || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+		    IS_QLA29XX(ha)) {
 			wrt_reg_dword(req->req_q_in, req->ring_index);
 		} else if (IS_QLA83XX(ha)) {
 			wrt_reg_dword(req->req_q_in, req->ring_index);
@@ -509,36 +519,46 @@ static int
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
+	/*
+	 * FWI2-capable adapters use the 24xx marker layout; 29xx uses the
+	 * extended marker IOCB (128 bytes) whose first 64 bytes overlay
+	 * mrk_entry_24xx through 'lun', so the common header is written
+	 * through a struct mrk_entry_24xx * view and only vp_index (u8 vs
+	 * __le16) needs a stride-aware branch.  Pre-FWI2 adapters
+	 * (ISP21xx/22xx/23xx) use the legacy mrk_entry_t layout with a
+	 * 2-byte target ID and a 16-bit LUN.
+	 */
+	mrk24 = __qla2x00_alloc_iocbs(qpair, NULL);
+	if (!mrk24) {
 		ql_log(ql_log_warn, base_vha, 0x3026,
 		    "Failed to allocate Marker IOCB.\n");
-
-		return (QLA_FUNCTION_FAILED);
+		return QLA_FUNCTION_FAILED;
 	}
 
-	mrk24 = (struct mrk_entry_24xx *)mrk;
-
-	mrk->entry_type = MARKER_TYPE;
-	mrk->modifier = type;
+	mrk24->entry_type = MARKER_TYPE;
+	mrk24->modifier = type;
 	if (type != MK_SYNC_ALL) {
 		if (IS_FWI2_CAPABLE(ha)) {
 			mrk24->nport_handle = cpu_to_le16(loop_id);
 			int_to_scsilun(lun, (struct scsi_lun *)&mrk24->lun);
 			host_to_fcp_swap(mrk24->lun, sizeof(mrk24->lun));
-			mrk24->vp_index = vha->vp_idx;
+			if (IS_QLA29XX(ha))
+				((struct mrk_entry_24xx_ext *)mrk24)->vp_index =
+				    cpu_to_le16(vha->vp_idx);
+			else
+				mrk24->vp_index = vha->vp_idx;
 		} else {
+			mrk_entry_t *mrk = (mrk_entry_t *)mrk24;
+
 			SET_TARGET_ID(ha, mrk->target, loop_id);
 			mrk->lun = cpu_to_le16((uint16_t)lun);
 		}
 	}
-
 	if (IS_FWI2_CAPABLE(ha))
 		mrk24->handle = QLA_SKIP_HANDLE;
 
@@ -747,7 +767,8 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 			 * Five DSDs are available in the Continuation
 			 * Type 1 IOCB.
 			 */
-			cont_pkt = qla2x00_prep_cont_type1_iocb(vha, req);
+			cont_pkt = qla2x00_prep_cont_type1_iocb(vha,
+			    vha->hw, req);
 			cur_dsd = cont_pkt->dsd;
 			avail_dsds = ARRAY_SIZE(cont_pkt->dsd);
 		}
@@ -1620,46 +1641,84 @@ qla24xx_start_scsi(srb_t *sp)
 	cmd->host_scribble = (unsigned char *)(unsigned long)handle;
 	req->cnt -= req_cnt;
 
-	cmd_pkt = (struct cmd_type_7 *)req->ring_ptr;
-	cmd_pkt->handle = make_handle(req->id, handle);
+	if (IS_QLA29XX(ha)) {
+		/*
+		 * cmd_type_7_ext diverges from cmd_type_7 past offset 48
+		 * (port_id[3]+vp_index vs ctrl_flags_2+__le16 vp_index),
+		 * so the packet-field writes can't be shared via a common
+		 * pointer type.
+		 */
+		struct cmd_type_7_ext *cmd_pkt_ext =
+			(struct cmd_type_7_ext *)req->ring_ext_ptr;
 
-	/* Zero out remaining portion of packet. */
-	/*    tagged queuing modifier -- default is TSK_SIMPLE (0). */
-	clr_ptr = (uint32_t *)cmd_pkt + 2;
-	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
-	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
+		cmd_pkt_ext->handle = make_handle(req->id, handle);
 
-	/* Set NPORT-ID and LUN number*/
-	cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
-	cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
-	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
-	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
-	cmd_pkt->vp_index = sp->vha->vp_idx;
+		/* Zero out remaining portion of packet. */
+		/*    tagged queuing modifier -- default is TSK_SIMPLE (0). */
+		clr_ptr = (uint32_t *)cmd_pkt_ext + 2;
+		memset(clr_ptr, 0, REQUEST_ENTRY_SIZE_EXT - 8);
+		cmd_pkt_ext->dseg_count = cpu_to_le16(tot_dsds);
 
-	int_to_scsilun(cmd->device->lun, &cmd_pkt->lun);
-	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
+		/* Set NPORT-ID and LUN number. */
+		cmd_pkt_ext->nport_handle =
+			cpu_to_le16(sp->fcport->loop_id);
+		cmd_pkt_ext->vp_index =
+			cpu_to_le16(sp->fcport->vha->vp_idx);
 
-	cmd_pkt->task = TSK_SIMPLE;
+		int_to_scsilun(cmd->device->lun, &cmd_pkt_ext->lun);
+		host_to_fcp_swap((uint8_t *)&cmd_pkt_ext->lun, sizeof(cmd_pkt_ext->lun));
 
-	/* Load SCSI command packet. */
-	memcpy(cmd_pkt->fcp_cdb, cmd->cmnd, cmd->cmd_len);
-	host_to_fcp_swap(cmd_pkt->fcp_cdb, sizeof(cmd_pkt->fcp_cdb));
+		cmd_pkt_ext->task = TSK_SIMPLE;
 
-	cmd_pkt->byte_count = cpu_to_le32((uint32_t)scsi_bufflen(cmd));
+		/* Load SCSI command packet. */
+		memcpy(cmd_pkt_ext->fcp_cdb, cmd->cmnd, cmd->cmd_len);
+		host_to_fcp_swap(cmd_pkt_ext->fcp_cdb, sizeof(cmd_pkt_ext->fcp_cdb));
 
-	/* Build IOCB segments */
-	qla24xx_build_scsi_iocbs(sp, cmd_pkt, tot_dsds, req);
+		cmd_pkt_ext->byte_count =
+			cpu_to_le32((uint32_t)scsi_bufflen(cmd));
 
-	/* Set total data segment count. */
-	cmd_pkt->entry_count = (uint8_t)req_cnt;
+		/* Build IOCB segments */
+		qla29xx_build_scsi_iocbs(sp, cmd_pkt_ext, tot_dsds, req);
+
+		/* Set total data segment count. */
+		cmd_pkt_ext->entry_count = (uint8_t)req_cnt;
+	} else {
+		cmd_pkt = (struct cmd_type_7 *)req->ring_ptr;
+		cmd_pkt->handle = make_handle(req->id, handle);
+
+		/* Zero out remaining portion of packet. */
+		/*    tagged queuing modifier -- default is TSK_SIMPLE (0). */
+		clr_ptr = (uint32_t *)cmd_pkt + 2;
+		memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
+		cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
+
+		/* Set NPORT-ID and LUN number*/
+		cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+		cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
+		cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
+		cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
+		cmd_pkt->vp_index = sp->vha->vp_idx;
+
+		int_to_scsilun(cmd->device->lun, &cmd_pkt->lun);
+		host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
+
+		cmd_pkt->task = TSK_SIMPLE;
+
+		/* Load SCSI command packet. */
+		memcpy(cmd_pkt->fcp_cdb, cmd->cmnd, cmd->cmd_len);
+		host_to_fcp_swap(cmd_pkt->fcp_cdb, sizeof(cmd_pkt->fcp_cdb));
+
+		cmd_pkt->byte_count = cpu_to_le32((uint32_t)scsi_bufflen(cmd));
+
+		/* Build IOCB segments */
+		qla24xx_build_scsi_iocbs(sp, cmd_pkt, tot_dsds, req);
+
+		/* Set total data segment count. */
+		cmd_pkt->entry_count = (uint8_t)req_cnt;
+	}
 	wmb();
 	/* Adjust ring index. */
-	req->ring_index++;
-	if (req->ring_index == req->length) {
-		req->ring_index = 0;
-		req->ring_ptr = req->ring;
-	} else
-		req->ring_ptr++;
+	qla_req_ring_advance(ha, req);
 
 	sp->qpair->cmd_cnt++;
 	sp->flags |= SRB_DMA_VALID;
@@ -1798,7 +1857,20 @@ qla24xx_dif_start_scsi(srb_t *sp)
 
 	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
 	sp->iores.exch_cnt = 1;
-	sp->iores.iocb_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+	/*
+	 * Unlike cmd_type_6_ext / cmd_type_7_ext (which carry NUM_CMD67_DSDS
+	 * inline DSDs), cmd_type_crc_2_ext carries only a single inline
+	 * data_dsd; the remaining DSDs live in the separate CRC-context DMA.
+	 * Size the firmware IOCB-pool reservation against the CRC_2 ext inline
+	 * capacity (NUM_CRC2_EXT_INLINE_DSDS) so it mirrors the 24xx path
+	 * (qla24xx_calc_iocbs assumes 1 inline DSD for cmd_type_crc_2) and
+	 * doesn't under-count continuations expected by firmware.
+	 */
+	if (IS_QLA29XX(ha))
+		sp->iores.iocb_cnt = qla29xx_calc_iocbs(vha, tot_dsds,
+							NUM_CRC2_EXT_INLINE_DSDS);
+	else
+		sp->iores.iocb_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 	if (qla_get_fw_resources(sp->qpair, &sp->iores))
 		goto queuing_error;
 
@@ -1829,17 +1901,24 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	req->cnt -= req_cnt;
 
 	/* Fill-in common area */
-	cmd_pkt = (struct cmd_type_crc_2 *)req->ring_ptr;
+	cmd_pkt = (struct cmd_type_crc_2 *)qla_req_ring_slot(ha, req);
 	cmd_pkt->handle = make_handle(req->id, handle);
 
 	clr_ptr = (uint32_t *)cmd_pkt + 2;
-	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
+	memset(clr_ptr, 0, qla_req_entry_size(ha) - 8);
 
 	/* Set NPORT-ID and LUN number*/
 	cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
-	cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
-	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
-	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
+	if (!IS_QLA29XX(ha)) {
+		cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
+		cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
+		cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
+	}
+	/*
+	 * vp_index: 24xx uses a uint8_t field at offset 51 (in port_id
+	 * group); 29xx replaces that region with control_flags_2/vp_index as
+	 * __le16s starting at offset 48.
+	 */
 
 	int_to_scsilun(cmd->device->lun, &cmd_pkt->lun);
 	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
@@ -1848,10 +1927,22 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
 
 	/* Build IOCB segments and adjust for data protection segments */
-	if (qla24xx_build_scsi_crc_2_iocbs(sp, (struct cmd_type_crc_2 *)
-	    req->ring_ptr, tot_dsds, tot_prot_dsds, fw_prot_opts) !=
-		QLA_SUCCESS)
-		goto queuing_error;
+	if (IS_QLA29XX(ha)) {
+		struct cmd_type_crc_2_ext *cmd_pkt_ext =
+			(struct cmd_type_crc_2_ext *)cmd_pkt;
+
+		cmd_pkt_ext->vp_index = cpu_to_le16(sp->vha->vp_idx);
+
+		if (qla29xx_build_scsi_crc_2_iocbs(sp, cmd_pkt_ext, tot_dsds,
+						   tot_prot_dsds, fw_prot_opts) !=
+		    QLA_SUCCESS)
+			goto queuing_error;
+	} else {
+		if (qla24xx_build_scsi_crc_2_iocbs(sp, cmd_pkt, tot_dsds,
+						   tot_prot_dsds, fw_prot_opts) !=
+		    QLA_SUCCESS)
+			goto queuing_error;
+	}
 
 	cmd_pkt->entry_count = (uint8_t)req_cnt;
 	/* Specify response queue number where completion should happen */
@@ -1860,12 +1951,7 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	wmb();
 
 	/* Adjust ring index. */
-	req->ring_index++;
-	if (req->ring_index == req->length) {
-		req->ring_index = 0;
-		req->ring_ptr = req->ring;
-	} else
-		req->ring_ptr++;
+	qla_req_ring_advance(ha, req);
 
 	sp->qpair->cmd_cnt++;
 	/* Set chip new ring index. */
@@ -1954,7 +2040,17 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 		nseg = 0;
 
 	tot_dsds = nseg;
-	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+	/*
+	 * 29xx posts into the 128-byte extended IOCB ring (cmd_type_7_ext,
+	 * NUM_CMD67_DSDS inline DSDs) via ring_ext_ptr; all other FWI2-capable
+	 * generations use the 64-byte cmd_type_7 / ring_ptr path.  The common
+	 * skeleton (marker/handle/sg-map/resource-check/ring advance) is
+	 * shared; only the cmd_pkt field-writes and ring stride differ.
+	 */
+	if (IS_QLA29XX(ha))
+		req_cnt = qla29xx_calc_iocbs(vha, tot_dsds, NUM_CMD67_DSDS);
+	else
+		req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 
 	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
 	sp->iores.exch_cnt = 1;
@@ -1987,46 +2083,84 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	cmd->host_scribble = (unsigned char *)(unsigned long)handle;
 	req->cnt -= req_cnt;
 
-	cmd_pkt = (struct cmd_type_7 *)req->ring_ptr;
-	cmd_pkt->handle = make_handle(req->id, handle);
+	if (IS_QLA29XX(ha)) {
+		/*
+		 * cmd_type_7_ext diverges from cmd_type_7 past offset 48
+		 * (port_id[3]+vp_index vs ctrl_flags_2+__le16 vp_index),
+		 * so the packet-field writes can't be shared via a common
+		 * pointer type.
+		 */
+		struct cmd_type_7_ext *cmd_pkt_ext =
+			(struct cmd_type_7_ext *)req->ring_ext_ptr;
 
-	/* Zero out remaining portion of packet. */
-	/*    tagged queuing modifier -- default is TSK_SIMPLE (0). */
-	clr_ptr = (uint32_t *)cmd_pkt + 2;
-	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
-	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
+		cmd_pkt_ext->handle = make_handle(req->id, handle);
 
-	/* Set NPORT-ID and LUN number*/
-	cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
-	cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
-	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
-	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
-	cmd_pkt->vp_index = sp->fcport->vha->vp_idx;
+		/* Zero out remaining portion of packet. */
+		/*    tagged queuing modifier -- default is TSK_SIMPLE (0). */
+		clr_ptr = (uint32_t *)cmd_pkt_ext + 2;
+		memset(clr_ptr, 0, REQUEST_ENTRY_SIZE_EXT - 8);
+		cmd_pkt_ext->dseg_count = cpu_to_le16(tot_dsds);
 
-	int_to_scsilun(cmd->device->lun, &cmd_pkt->lun);
-	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
+		/* Set NPORT-ID and LUN number. */
+		cmd_pkt_ext->nport_handle =
+			cpu_to_le16(sp->fcport->loop_id);
+		cmd_pkt_ext->vp_index =
+			cpu_to_le16(sp->fcport->vha->vp_idx);
 
-	cmd_pkt->task = TSK_SIMPLE;
+		int_to_scsilun(cmd->device->lun, &cmd_pkt_ext->lun);
+		host_to_fcp_swap((uint8_t *)&cmd_pkt_ext->lun,
+				sizeof(cmd_pkt_ext->lun));
 
-	/* Load SCSI command packet. */
-	memcpy(cmd_pkt->fcp_cdb, cmd->cmnd, cmd->cmd_len);
-	host_to_fcp_swap(cmd_pkt->fcp_cdb, sizeof(cmd_pkt->fcp_cdb));
+		cmd_pkt_ext->task = TSK_SIMPLE;
 
-	cmd_pkt->byte_count = cpu_to_le32((uint32_t)scsi_bufflen(cmd));
+		memcpy(cmd_pkt_ext->fcp_cdb, cmd->cmnd, cmd->cmd_len);
+		host_to_fcp_swap(cmd_pkt_ext->fcp_cdb,
+				sizeof(cmd_pkt_ext->fcp_cdb));
 
-	/* Build IOCB segments */
-	qla24xx_build_scsi_iocbs(sp, cmd_pkt, tot_dsds, req);
+		cmd_pkt_ext->byte_count =
+			cpu_to_le32((uint32_t)scsi_bufflen(cmd));
+
+		qla29xx_build_scsi_iocbs(sp, cmd_pkt_ext, tot_dsds, req);
+
+		cmd_pkt_ext->entry_count = (uint8_t)req_cnt;
+	} else {
+		cmd_pkt = (struct cmd_type_7 *)req->ring_ptr;
+		cmd_pkt->handle = make_handle(req->id, handle);
+
+		/* Zero out remaining portion of packet. */
+		/*    tagged queuing modifier -- default is TSK_SIMPLE (0). */
+		clr_ptr = (uint32_t *)cmd_pkt + 2;
+		memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
+		cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
+
+		/* Set NPORT-ID and LUN number. */
+		cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+		cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
+		cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
+		cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
+		cmd_pkt->vp_index = sp->fcport->vha->vp_idx;
+
+		int_to_scsilun(cmd->device->lun, &cmd_pkt->lun);
+		host_to_fcp_swap((uint8_t *)&cmd_pkt->lun,
+				sizeof(cmd_pkt->lun));
+
+		cmd_pkt->task = TSK_SIMPLE;
+
+		memcpy(cmd_pkt->fcp_cdb, cmd->cmnd, cmd->cmd_len);
+		host_to_fcp_swap(cmd_pkt->fcp_cdb,
+				sizeof(cmd_pkt->fcp_cdb));
+
+		cmd_pkt->byte_count =
+			cpu_to_le32((uint32_t)scsi_bufflen(cmd));
+
+		qla24xx_build_scsi_iocbs(sp, cmd_pkt, tot_dsds, req);
+
+		cmd_pkt->entry_count = (uint8_t)req_cnt;
+	}
 
-	/* Set total data segment count. */
-	cmd_pkt->entry_count = (uint8_t)req_cnt;
 	wmb();
 	/* Adjust ring index. */
-	req->ring_index++;
-	if (req->ring_index == req->length) {
-		req->ring_index = 0;
-		req->ring_ptr = req->ring;
-	} else
-		req->ring_ptr++;
+	qla_req_ring_advance(ha, req);
 
 	sp->qpair->cmd_cnt++;
 	sp->flags |= SRB_DMA_VALID;
@@ -2034,8 +2168,12 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	/* Set chip new ring index. */
 	wrt_reg_dword(req->req_q_in, req->ring_index);
 
-	/* Manage unprocessed RIO/ZIO commands in response queue. */
-	if (vha->flags.process_response_queue &&
+	/*
+	 * Manage unprocessed RIO/ZIO commands in response queue. 29xx skips
+	 * this optimization until rsp_que is made 128-byte-stride aware;
+	 * completions still arrive via the regular ISR path.
+	 */
+	if (!IS_QLA29XX(ha) && vha->flags.process_response_queue &&
 	    rsp->ring_ptr->signature != RESPONSE_PROCESSED)
 		qla24xx_process_response_queue(vha, rsp);
 
@@ -2180,7 +2318,20 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 
 	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
 	sp->iores.exch_cnt = 1;
-	sp->iores.iocb_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+	/*
+	 * Unlike cmd_type_6_ext / cmd_type_7_ext (which carry NUM_CMD67_DSDS
+	 * inline DSDs), cmd_type_crc_2_ext carries only a single inline
+	 * data_dsd; the remaining DSDs live in the separate CRC-context DMA.
+	 * Size the firmware IOCB-pool reservation against the CRC_2 ext inline
+	 * capacity (NUM_CRC2_EXT_INLINE_DSDS) so it mirrors the 24xx path
+	 * (qla24xx_calc_iocbs assumes 1 inline DSD for cmd_type_crc_2) and
+	 * doesn't under-count continuations expected by firmware.
+	 */
+	if (IS_QLA29XX(ha))
+		sp->iores.iocb_cnt = qla29xx_calc_iocbs(vha, tot_dsds,
+						       NUM_CRC2_EXT_INLINE_DSDS);
+	else
+		sp->iores.iocb_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 	if (qla_get_fw_resources(sp->qpair, &sp->iores))
 		goto queuing_error;
 
@@ -2211,18 +2362,35 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 	cmd->host_scribble = (unsigned char *)(unsigned long)handle;
 	req->cnt -= req_cnt;
 
-	/* Fill-in common area */
-	cmd_pkt = (struct cmd_type_crc_2 *)req->ring_ptr;
+	/*
+	 * cmd_type_crc_2 and cmd_type_crc_2_ext share an identical header
+	 * layout through byte_count (offset 44); the trailing port_id /
+	 * vp_index / CRC-context fields diverge.  The common header writes
+	 * (handle, memset, nport_handle, lun, dseg_count, entry_count,
+	 * timeout) are performed via the 24xx-typed pointer in both paths;
+	 * the divergent tail and builder use hardware-specific handling.
+	 */
+	if (IS_QLA29XX(ha))
+		cmd_pkt = (struct cmd_type_crc_2 *)req->ring_ext_ptr;
+	else
+		cmd_pkt = (struct cmd_type_crc_2 *)req->ring_ptr;
 	cmd_pkt->handle = make_handle(req->id, handle);
 
 	clr_ptr = (uint32_t *)cmd_pkt + 2;
-	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
+	memset(clr_ptr, 0, qla_req_entry_size(ha) - 8);
 
 	/* Set NPORT-ID and LUN number*/
 	cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
-	cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
-	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
-	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
+	if (!IS_QLA29XX(ha)) {
+		cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
+		cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
+		cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
+	}
+	/*
+	 * vp_index: 24xx uses a uint8_t field at offset 51 (in port_id
+	 * group); 29xx replaces that region with control_flags_2/vp_index as
+	 * __le16s starting at offset 48.
+	 */
 
 	int_to_scsilun(cmd->device->lun, &cmd_pkt->lun);
 	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
@@ -2231,29 +2399,41 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
 
 	/* Build IOCB segments and adjust for data protection segments */
-	if (qla24xx_build_scsi_crc_2_iocbs(sp, (struct cmd_type_crc_2 *)
-	    req->ring_ptr, tot_dsds, tot_prot_dsds, fw_prot_opts) !=
-		QLA_SUCCESS)
-		goto queuing_error;
+	if (IS_QLA29XX(ha)) {
+		struct cmd_type_crc_2_ext *cmd_pkt_ext =
+			(struct cmd_type_crc_2_ext *)cmd_pkt;
+
+		cmd_pkt_ext->vp_index = cpu_to_le16(sp->vha->vp_idx);
+
+		if (qla29xx_build_scsi_crc_2_iocbs(sp, cmd_pkt_ext, tot_dsds,
+						   tot_prot_dsds,
+						   fw_prot_opts) !=
+		    QLA_SUCCESS)
+			goto queuing_error;
+	} else {
+		if (qla24xx_build_scsi_crc_2_iocbs(sp, cmd_pkt, tot_dsds,
+						   tot_prot_dsds,
+						   fw_prot_opts) !=
+		    QLA_SUCCESS)
+			goto queuing_error;
+	}
 
 	cmd_pkt->entry_count = (uint8_t)req_cnt;
 	cmd_pkt->timeout = cpu_to_le16(0);
 	wmb();
 
-	/* Adjust ring index. */
-	req->ring_index++;
-	if (req->ring_index == req->length) {
-		req->ring_index = 0;
-		req->ring_ptr = req->ring;
-	} else
-		req->ring_ptr++;
+	/* Adjust ring index.  29xx uses the 128-byte extended ring pointer. */
+	qla_req_ring_advance(ha, req);
 
 	sp->qpair->cmd_cnt++;
 	/* Set chip new ring index. */
 	wrt_reg_dword(req->req_q_in, req->ring_index);
 
-	/* Manage unprocessed RIO/ZIO commands in response queue. */
-	if (vha->flags.process_response_queue &&
+	/*
+	 * Manage unprocessed RIO/ZIO commands in response queue. 29xx skips
+	 * this optimization until rsp_que is made 128-byte-stride aware.
+	 */
+	if (!IS_QLA29XX(ha) && vha->flags.process_response_queue &&
 	    rsp->ring_ptr->signature != RESPONSE_PROCESSED)
 		qla24xx_process_response_queue(vha, rsp);
 
@@ -2303,7 +2483,7 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 		if (qpair->use_shadow_reg)
 			cnt = *req->out_ptr;
 		else if (ha->mqenable || IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
-		    IS_QLA28XX(ha))
+		    IS_QLA28XX(ha) || IS_QLA29XX(ha))
 			cnt = rd_reg_dword(&reg->isp25mq.req_q_out);
 		else if (IS_P3P_TYPE(ha))
 			cnt = rd_reg_dword(reg->isp82.req_q_out);
@@ -2343,10 +2523,20 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 		sp->handle = handle;
 	}
 
-	/* Prep packet */
+	/*
+	 * Prep packet.  29xx posts into a 128-byte-strided ring via
+	 * ring_ext_ptr; the first 8 bytes of struct request_ext overlay the
+	 * common request_t header, so entry_count/handle writes are
+	 * layout-compatible once we return the pkt as request_t *.
+	 */
 	req->cnt -= req_cnt;
-	pkt = req->ring_ptr;
-	memset(pkt, 0, REQUEST_ENTRY_SIZE);
+	if (IS_QLA29XX(ha)) {
+		pkt = (request_t *)req->ring_ext_ptr;
+		memset(pkt, 0, REQUEST_ENTRY_SIZE_EXT);
+	} else {
+		pkt = req->ring_ptr;
+		memset(pkt, 0, REQUEST_ENTRY_SIZE);
+	}
 	if (IS_QLAFX00(ha)) {
 		wrt_reg_byte((u8 __force __iomem *)&pkt->entry_count, req_cnt);
 		wrt_reg_dword((__le32 __force __iomem *)&pkt->handle, handle);
@@ -3269,7 +3459,7 @@ qla2x00_ct_iocb(srb_t *sp, ms_iocb_entry_t *ct_iocb)
 			* Type 1 IOCB.
 			       */
 			cont_pkt = qla2x00_prep_cont_type1_iocb(vha,
-			    vha->hw->req_q_map[0]);
+			    ha, ha->req_q_map[0]);
 			cur_dsd = cont_pkt->dsd;
 			avail_dsds = 5;
 			entry_count++;
@@ -3295,7 +3485,6 @@ qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
 	struct qla_hw_data *ha = vha->hw;
 	struct bsg_job *bsg_job = sp->u.bsg_job;
 	int entry_count = 1;
-	cont_a64_entry_t *cont_pkt = NULL;
 
 	ct_iocb->entry_type = CT_IOCB_TYPE;
         ct_iocb->entry_status = 0;
@@ -3320,16 +3509,29 @@ qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
 	index = 0;
 
 	for_each_sg(bsg_job->request_payload.sg_list, sg, cmd_dsds, index) {
-		/* Allocate additional continuation packets? */
+		/*
+		 * Allocate additional continuation packets.  24xx uses the
+		 * 64-byte cont_a64_entry_t (5 DSDs); 29xx uses the 128-byte
+		 * cont_a64_entry_ext_t (NUM_CONT1_DSDS) and advances through
+		 * the ring_ext_ptr stride so the CT head IOCB isn't
+		 * overlapped.
+		 */
 		if (avail_dsds == 0) {
-			/*
-			 * Five DSDs are available in the Cont.
-			 * Type 1 IOCB.
-			 */
-			cont_pkt = qla2x00_prep_cont_type1_iocb(
-			    vha, ha->req_q_map[0]);
-			cur_dsd = cont_pkt->dsd;
-			avail_dsds = 5;
+			if (IS_QLA29XX(ha)) {
+				struct cont_a64_entry_ext *cont_pkt;
+
+				cont_pkt = qla2900_prep_cont_type1_iocb(vha,
+				    ha->req_q_map[0]);
+				cur_dsd = cont_pkt->dsd;
+				avail_dsds = ARRAY_SIZE(cont_pkt->dsd);
+			} else {
+				cont_a64_entry_t *cont_pkt;
+
+				cont_pkt = qla2x00_prep_cont_type1_iocb(vha,
+				    ha, ha->req_q_map[0]);
+				cur_dsd = cont_pkt->dsd;
+				avail_dsds = ARRAY_SIZE(cont_pkt->dsd);
+			}
 			entry_count++;
 		}
 
@@ -3340,16 +3542,22 @@ qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *ct_iocb)
 	index = 0;
 
 	for_each_sg(bsg_job->reply_payload.sg_list, sg, rsp_dsds, index) {
-		/* Allocate additional continuation packets? */
 		if (avail_dsds == 0) {
-			/*
-			* Five DSDs are available in the Cont.
-			* Type 1 IOCB.
-			       */
-			cont_pkt = qla2x00_prep_cont_type1_iocb(vha,
-			    ha->req_q_map[0]);
-			cur_dsd = cont_pkt->dsd;
-			avail_dsds = 5;
+			if (IS_QLA29XX(ha)) {
+				struct cont_a64_entry_ext *cont_pkt;
+
+				cont_pkt = qla2900_prep_cont_type1_iocb(vha,
+				    ha->req_q_map[0]);
+				cur_dsd = cont_pkt->dsd;
+				avail_dsds = ARRAY_SIZE(cont_pkt->dsd);
+			} else {
+				cont_a64_entry_t *cont_pkt;
+
+				cont_pkt = qla2x00_prep_cont_type1_iocb(vha,
+				    ha, ha->req_q_map[0]);
+				cur_dsd = cont_pkt->dsd;
+				avail_dsds = ARRAY_SIZE(cont_pkt->dsd);
+			}
 			entry_count++;
 		}
 
@@ -3903,16 +4111,31 @@ static int qla_get_iocbs_resource(struct srb *sp)
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
 
@@ -4098,7 +4321,8 @@ qla25xx_build_bidir_iocb(srb_t *sp, struct scsi_qla_host *vha,
 			/* Continuation type 1 IOCB can accomodate
 			 * 5 DSDS
 			 */
-			cont_pkt = qla2x00_prep_cont_type1_iocb(vha, vha->req);
+			cont_pkt = qla2x00_prep_cont_type1_iocb(vha,
+			    vha->hw, vha->req);
 			cur_dsd = cont_pkt->dsd;
 			avail_dsds = 5;
 			entry_count++;
@@ -4120,7 +4344,8 @@ qla25xx_build_bidir_iocb(srb_t *sp, struct scsi_qla_host *vha,
 			/* Continuation type 1 IOCB can accomodate
 			 * 5 DSDS
 			 */
-			cont_pkt = qla2x00_prep_cont_type1_iocb(vha, vha->req);
+			cont_pkt = qla2x00_prep_cont_type1_iocb(vha,
+			    vha->hw, vha->req);
 			cur_dsd = cont_pkt->dsd;
 			avail_dsds = 5;
 			entry_count++;
@@ -4152,6 +4377,21 @@ qla2x00_start_bidir(srb_t *sp, struct scsi_qla_host *vha, uint32_t tot_dsds)
 	rsp = ha->rsp_q_map[0];
 	req = vha->req;
 
+	/*
+	 * 29xx uses a 128-byte extended IOCB ring, but no extended
+	 * COMMAND_BIDIRECTIONAL IOCB layout has been defined and no
+	 * firmware-spec'd cmd_bidir_ext exists.  Posting the 64-byte
+	 * struct cmd_bidir against req->ring_ptr would overlap the next
+	 * ring slot on 29xx HW (see BUILD_BUG_ON(sizeof(struct cmd_bidir)
+	 * != 64) in qla_os.c), so refuse BSG BIDIR on 29xx rather than
+	 * corrupt the request ring.
+	 */
+	if (IS_QLA29XX(ha)) {
+		ql_log(ql_log_warn, vha, 0x70af,
+		    "BSG BIDIR not supported on 29xx adapters.\n");
+		return EXT_STATUS_INVALID_PARAM;
+	}
+
 	/* Send marker if required */
 	if (vha->marker_needed != 0) {
 		if (qla2x00_marker(vha, ha->base_qpair,
@@ -4289,8 +4529,15 @@ qla_start_scsi_type6(srb_t *sp)
 
 	tot_dsds = nseg;
 
-	/* eventhough driver only need 1 T6 IOCB, FW still convert DSD to Continueation IOCB */
-	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+	/*
+	 * Even though the driver only needs 1 T6 IOCB, FW still converts the
+	 * DSD list into continuation IOCBs for reservation purposes.  29xx
+	 * follows the same rule against its extended-IOCB inline DSD count.
+	 */
+	if (IS_QLA29XX(ha))
+		req_cnt = qla29xx_calc_iocbs(vha, tot_dsds, NUM_CMD67_DSDS);
+	else
+		req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 
 	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
 	sp->iores.exch_cnt = 1;
@@ -4394,23 +4641,44 @@ qla_start_scsi_type6(srb_t *sp)
 	cmd->host_scribble = (unsigned char *)(unsigned long)handle;
 	req->cnt -= req_cnt;
 
-	cmd_pkt = (struct cmd_type_6 *)req->ring_ptr;
+	/*
+	 * cmd_type_6 and cmd_type_6_ext share an identical header layout
+	 * from offset 0 through byte_count (offset 48), so the common
+	 * header/nport/lun writes go through the 24xx-typed cmd_pkt even on
+	 * 29xx.  Only the divergent port_id/vp_index tail and the DSD layout
+	 * need hardware-specific handling.
+	 */
+	if (IS_QLA29XX(ha))
+		cmd_pkt = (struct cmd_type_6 *)req->ring_ext_ptr;
+	else
+		cmd_pkt = (struct cmd_type_6 *)req->ring_ptr;
 	cmd_pkt->handle = make_handle(req->id, handle);
 
 	/* tagged queuing modifier -- default is TSK_SIMPLE (0). */
 	clr_ptr = (uint32_t *)cmd_pkt + 2;
-	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
+	memset(clr_ptr, 0, qla_req_entry_size(ha) - 8);
 	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
 
 	/* Set NPORT-ID and LUN number */
 	cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
-	cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
-	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
-	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
-	cmd_pkt->vp_index = sp->vha->vp_idx;
 
-	/* Build IOCB segments */
-	qla24xx_build_scsi_type_6_iocbs(sp, cmd_pkt, tot_dsds);
+	if (IS_QLA29XX(ha)) {
+		struct cmd_type_6_ext *cmd_pkt_ext =
+			(struct cmd_type_6_ext *)cmd_pkt;
+
+		cmd_pkt_ext->vp_index = cpu_to_le16(sp->vha->vp_idx);
+
+		/* Build IOCB segments (dsd[] in 29xx extended layout). */
+		qla29xx_build_scsi_type_6_iocbs(sp, cmd_pkt_ext, tot_dsds);
+	} else {
+		cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
+		cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
+		cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
+		cmd_pkt->vp_index = sp->vha->vp_idx;
+
+		/* Build IOCB segments (24xx fcp_dsd single-DSD layout). */
+		qla24xx_build_scsi_type_6_iocbs(sp, cmd_pkt, tot_dsds);
+	}
 
 	int_to_scsilun(cmd->device->lun, &cmd_pkt->lun);
 	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
@@ -4445,14 +4713,8 @@ qla_start_scsi_type6(srb_t *sp)
 	cmd_pkt->entry_count = (uint8_t)req_cnt;
 
 	wmb();
-	/* Adjust ring index. */
-	req->ring_index++;
-	if (req->ring_index == req->length) {
-		req->ring_index = 0;
-		req->ring_ptr = req->ring;
-	} else {
-		req->ring_ptr++;
-	}
+	/* Adjust ring index. 29xx uses the 128-byte extended ring pointer.*/
+	qla_req_ring_advance(ha, req);
 
 	sp->qpair->cmd_cnt++;
 	sp->flags |= SRB_DMA_VALID;
@@ -4460,8 +4722,11 @@ qla_start_scsi_type6(srb_t *sp)
 	/* Set chip new ring index. */
 	wrt_reg_dword(req->req_q_in, req->ring_index);
 
-	/* Manage unprocessed RIO/ZIO commands in response queue. */
-	if (vha->flags.process_response_queue &&
+	/*
+	 * Manage unprocessed RIO/ZIO commands in response queue. 29xx skips
+	 * this optimization until rsp_que is made 128-byte-stride aware.
+	 */
+	if (!IS_QLA29XX(ha) &&  vha->flags.process_response_queue &&
 	    rsp->ring_ptr->signature != RESPONSE_PROCESSED)
 		qla24xx_process_response_queue(vha, rsp);
 
@@ -4487,3 +4752,492 @@ qla_start_scsi_type6(srb_t *sp)
 
 	return QLA_FUNCTION_FAILED;
 }
+
+/*
+ * ---------------------------------------------------------------------------
+ * 29xx extended (128-byte) IOCB fast-path helpers.
+ *
+ * These helpers drive the extended IOCB ring used by 29xx-class adapters and
+ * operate on the *_ext IOCB variants declared in qla_fw29.h
+ * (cmd_type_6_ext, cmd_type_7_ext, cmd_type_crc_2_ext, struct cont_a64_entry_ext).
+ *
+ * They are not yet wired into any dispatch path; the top-level entry points
+ * (e.g. qla29xx_start_scsi / qla29xx_dif_start_scsi_mq) and isp_ops hooks are
+ * added in subsequent merge phases.  Until then the top-of-tree builder
+ * functions are marked __maybe_unused so the build stays warning-clean.
+ *
+ * Ported from the out-of-tree qla29xx driver.  Signatures have been adapted
+ * to the Mach qla2xxx single-srb_t model:
+ *   struct qla_io_srb *  -->  srb_t *
+ *   sp->qcb.qpair        -->  sp->qpair
+ *   sp->qcb.iores        -->  sp->iores
+ *   sp->qcb.handle       -->  sp->handle
+ *   qla2900_hba_err_chk_enabled()  -->  qla2x00_hba_err_chk_enabled()
+ * ---------------------------------------------------------------------------
+ */
+
+static void qla29xx_copy_dif_iocb_data(struct cmd_type_crc_2_ext *cmd_pkt,
+	struct crc_context *crc_ctx_pkt, uint8_t dif_bundling);
+
+/**
+ * qla2900_prep_cont_type1_iocb() - Initialize a 29xx-ext Continuation
+ * Type 1 IOCB on the extended IOCB ring.
+ * @vha: HA context
+ * @req: request queue
+ *
+ * Returns a pointer to the continuation type 1 IOCB packet.
+ */
+struct cont_a64_entry_ext *
+qla2900_prep_cont_type1_iocb(scsi_qla_host_t *vha, struct req_que *req)
+{
+	struct cont_a64_entry_ext *cont_pkt;
+
+	/*
+	 * 29xx uses the 128-byte extended IOCB ring.  Advance via ring_ext_ptr
+	 * so the pointer arithmetic matches the on-ring stride.
+	 */
+	req->ring_index++;
+	if (req->ring_index == req->length) {
+		req->ring_index = 0;
+		req->ring_ext_ptr = req->ring_ext;
+	} else {
+		req->ring_ext_ptr++;
+	}
+
+	cont_pkt = (struct cont_a64_entry_ext *)req->ring_ext_ptr;
+
+	/* Load packet defaults. */
+	put_unaligned_le32(CONTINUE_A64_TYPE, &cont_pkt->entry_type);
+
+	return cont_pkt;
+}
+
+/*
+ * Note: the 29xx extended path reuses qla24xx_configure_prot_mode() -- the
+ * SCSI-prot-op to PO_MODE_DIF_* translation is independent of the IOCB
+ * generation.
+ */
+
+/**
+ * qla29xx_build_scsi_type_6_iocbs() - Build IOCB command utilizing Command
+ * Type 6 IOCB types on the 29xx extended ring.
+ * @sp: SRB command to process
+ * @cmd_pkt: Command type 6 extended IOCB
+ * @tot_dsds: Total number of segments to transfer
+ */
+static void
+qla29xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd_type_6_ext *cmd_pkt,
+	uint16_t tot_dsds)
+{
+	struct dsd64 *cur_dsd = NULL, *next_dsd;
+	struct scsi_cmnd *cmd;
+	struct	scatterlist *cur_seg;
+	uint8_t avail_dsds;
+	uint8_t first_iocb = 1;
+	uint32_t dsd_list_len;
+	struct dsd_dma *dsd_ptr;
+	struct ct6_dsd *ctx;
+	struct qla_qpair *qpair = sp->qpair;
+
+	cmd = GET_CMD_SP(sp);
+
+	/* Update entry type to indicate Command Type 6 IOCB */
+	put_unaligned_le32(COMMAND_TYPE_6, &cmd_pkt->entry_type);
+
+	/* No data transfer */
+	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE) {
+		cmd_pkt->byte_count = cpu_to_le32(0);
+		goto function_end;
+	}
+
+	/* Set transfer direction */
+	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
+		cmd_pkt->control_flags = cpu_to_le16(CF_WRITE_DATA);
+		qpair->counters.output_bytes += scsi_bufflen(cmd);
+		qpair->counters.output_requests++;
+	} else if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
+		cmd_pkt->control_flags = cpu_to_le16(CF_READ_DATA);
+		qpair->counters.input_bytes += scsi_bufflen(cmd);
+		qpair->counters.input_requests++;
+	}
+
+	cur_seg = scsi_sglist(cmd);
+	ctx = &sp->u.scmd.ct6_ctx;
+
+	while (tot_dsds) {
+		avail_dsds = (tot_dsds > QLA_DSDS_PER_IOCB) ?
+		    QLA_DSDS_PER_IOCB : tot_dsds;
+		tot_dsds -= avail_dsds;
+		dsd_list_len = (avail_dsds + 1) * QLA_DSD_SIZE;
+
+		dsd_ptr = list_first_entry(&qpair->dsd_list, struct dsd_dma,
+					   list);
+		next_dsd = dsd_ptr->dsd_addr;
+		list_del(&dsd_ptr->list);
+		qpair->dsd_avail--;
+		list_add_tail(&dsd_ptr->list, &ctx->dsd_list);
+		ctx->dsd_use_cnt++;
+		qpair->dsd_inuse++;
+
+		if (first_iocb) {
+			first_iocb = 0;
+			put_unaligned_le64(dsd_ptr->dsd_list_dma,
+					   &cmd_pkt->dsd[0].address);
+			cmd_pkt->dsd[0].length = cpu_to_le32(dsd_list_len);
+		} else {
+			put_unaligned_le64(dsd_ptr->dsd_list_dma,
+					   &cur_dsd->address);
+			cur_dsd->length = cpu_to_le32(dsd_list_len);
+			cur_dsd++;
+		}
+		cur_dsd = next_dsd;
+		while (avail_dsds) {
+			append_dsd64(&cur_dsd, cur_seg);
+			cur_seg = sg_next(cur_seg);
+			avail_dsds--;
+		}
+	}
+
+	/* Null termination */
+	if (cur_dsd) {
+		cur_dsd->address = 0;
+		cur_dsd->length = 0;
+		cur_dsd++;
+	}
+	cmd_pkt->control_flags |= cpu_to_le16(CF_DATA_SEG_DESCR_ENABLE);
+function_end:
+	return;
+}
+
+/*
+ * Note: the 29xx extended path reuses qla24xx_calc_dsd_lists() -- the
+ * DSD-list-per-IOCB arithmetic (based on QLA_DSDS_PER_IOCB) is generation-
+ * agnostic.
+ */
+
+/**
+ * qla29xx_build_scsi_iocbs() - Build IOCB command utilizing Command Type 7
+ * IOCB types on the 29xx extended ring.
+ * @sp: SRB command to process
+ * @cmd_pkt: Command type 7 extended IOCB
+ * @tot_dsds: Total number of segments to transfer
+ * @req: pointer to request queue
+ */
+static void __maybe_unused
+qla29xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7_ext *cmd_pkt,
+	uint16_t tot_dsds, struct req_que *req)
+{
+	uint8_t	avail_dsds;
+	struct dsd64 *cur_dsd;
+	scsi_qla_host_t	*vha;
+	struct scsi_cmnd *cmd;
+	struct scatterlist *sg;
+	int i;
+	struct qla_qpair *qpair = sp->qpair;
+
+	cmd = GET_CMD_SP(sp);
+
+	/* Update entry type to indicate Command Type 7 IOCB */
+	put_unaligned_le32(COMMAND_TYPE_7, &cmd_pkt->entry_type);
+
+	/* No data transfer */
+	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE) {
+		cmd_pkt->byte_count = cpu_to_le32(0);
+		return;
+	}
+
+	vha = sp->vha;
+
+	/* Set transfer direction */
+	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
+		cmd_pkt->task_mgmt_flags = cpu_to_le16(TMF_WRITE_DATA);
+		qpair->counters.output_bytes += scsi_bufflen(cmd);
+		qpair->counters.output_requests++;
+	} else if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
+		cmd_pkt->task_mgmt_flags = cpu_to_le16(TMF_READ_DATA);
+		qpair->counters.input_bytes += scsi_bufflen(cmd);
+		qpair->counters.input_requests++;
+	}
+
+	/* NUM_CMD67_DSDS DSDs available in the Command Type 7 ext IOCB */
+	avail_dsds = NUM_CMD67_DSDS;
+	cur_dsd = &cmd_pkt->dsd[0];
+
+	scsi_for_each_sg(cmd, sg, tot_dsds, i) {
+		struct cont_a64_entry_ext *cont_pkt;
+
+		/* Allocate additional continuation packets? */
+		if (avail_dsds == 0) {
+			/*
+			 * NUM_CONT1_DSDS DSDs are available in the Continuation
+			 * Type 1 extended IOCB.
+			 */
+			cont_pkt = qla2900_prep_cont_type1_iocb(vha, req);
+			cur_dsd = cont_pkt->dsd;
+			avail_dsds = ARRAY_SIZE(cont_pkt->dsd);
+		}
+
+		append_dsd64(&cur_dsd, sg);
+		avail_dsds--;
+	}
+}
+
+/*
+ * Note: the 29xx extended path reuses qla24xx_set_t10dif_tags() (defined
+ * earlier in this file) -- the T10-DIF ref/app tag layout is identical
+ * between the 24xx and 29xx extended CRC_2 IOCBs (both share the same
+ * fw_dif_context layout inside struct crc_context).
+ */
+
+/*
+ * Note: the 29xx extended CRC_2 path reuses the 24xx SG walkers
+ * (qla24xx_get_one_block_sg, qla24xx_walk_and_build_sglist_no_difb,
+ * qla24xx_walk_and_build_sglist, qla24xx_walk_and_build_prot_sglist).
+ * The DSD-chain / CRC-context layout they produce is generation-agnostic;
+ * only the IOCB that points at the chain (Type-6/7/CRC_2 vs their _ext
+ * variants) differs between generations, and that is handled by the
+ * separate qla29xx_build_* builders.
+ *
+ * The walkers that take a struct qla_tc_param *tc are invoked with tc=NULL
+ * here because the 29xx fast-path does not use the tape/copy offload.
+ */
+
+/**
+ * qla29xx_build_scsi_crc_2_iocbs() - Build IOCB command utilizing Command
+ * Type CRC_2 IOCB types on the 29xx extended ring.
+ * @sp: SRB command to process
+ * @cmd_pkt: Command type CRC_2 extended IOCB
+ * @tot_dsds: Total number of segments to transfer
+ * @tot_prot_dsds: Total number of segments with protection information
+ * @fw_prot_opts: Protection options to be passed to firmware
+ *
+ * Returns 0 if successful, 1 otherwise.
+ */
+static int
+qla29xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2_ext *cmd_pkt,
+	uint16_t tot_dsds, uint16_t tot_prot_dsds, uint16_t fw_prot_opts)
+{
+	struct dsd64		*cur_dsd;
+	__be32			*fcp_dl;
+	scsi_qla_host_t		*vha;
+	struct scsi_cmnd	*cmd;
+	uint32_t		total_bytes = 0;
+	uint32_t		data_bytes;
+	uint32_t		dif_bytes;
+	uint8_t			bundling = 1;
+	uint16_t		blk_size;
+	struct crc_context	*crc_ctx_pkt = NULL;
+	struct qla_hw_data	*ha;
+	uint8_t			additional_fcpcdb_len;
+	uint16_t		fcp_cmnd_len;
+	struct fcp_cmnd		*fcp_cmnd;
+	dma_addr_t		crc_ctx_dma;
+
+	cmd = GET_CMD_SP(sp);
+
+	/* Update entry type to indicate Command Type CRC_2 IOCB */
+	put_unaligned_le32(COMMAND_TYPE_CRC_2, &cmd_pkt->entry_type);
+
+	vha = sp->vha;
+	ha = vha->hw;
+
+	/* No data transfer */
+	data_bytes = scsi_bufflen(cmd);
+	if (!data_bytes || cmd->sc_data_direction == DMA_NONE) {
+		cmd_pkt->byte_count = cpu_to_le32(0);
+		return QLA_SUCCESS;
+	}
+
+	cmd_pkt->vp_index = cpu_to_le16(sp->vha->vp_idx);
+
+	/* Set transfer direction */
+	if (cmd->sc_data_direction == DMA_TO_DEVICE)
+		cmd_pkt->control_flags_1 = cpu_to_le16(CF_WRITE_DATA);
+	else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
+		cmd_pkt->control_flags_1 = cpu_to_le16(CF_READ_DATA);
+
+	if ((scsi_get_prot_op(cmd) == SCSI_PROT_READ_INSERT) ||
+	    (scsi_get_prot_op(cmd) == SCSI_PROT_WRITE_STRIP) ||
+	    (scsi_get_prot_op(cmd) == SCSI_PROT_READ_STRIP) ||
+	    (scsi_get_prot_op(cmd) == SCSI_PROT_WRITE_INSERT))
+		bundling = 0;
+
+	/* Allocate CRC context from global pool */
+	crc_ctx_pkt = sp->u.scmd.crc_ctx =
+	    dma_pool_zalloc(ha->dl_dma_pool, GFP_ATOMIC, &crc_ctx_dma);
+
+	if (!crc_ctx_pkt)
+		goto crc_queuing_error;
+
+	crc_ctx_pkt->crc_ctx_dma = crc_ctx_dma;
+
+	sp->flags |= SRB_CRC_CTX_DMA_VALID;
+
+	/* Set handle */
+	crc_ctx_pkt->handle = cmd_pkt->handle;
+
+	INIT_LIST_HEAD(&crc_ctx_pkt->dsd_list);
+
+	qla24xx_set_t10dif_tags(sp, (struct fw_dif_context *)
+	    &crc_ctx_pkt->ref_tag, tot_prot_dsds);
+
+	/* Determine SCSI command length -- align to 4 byte boundary */
+	if (cmd->cmd_len > 16) {
+		additional_fcpcdb_len = cmd->cmd_len - 16;
+		if ((cmd->cmd_len % 4) != 0) {
+			/* SCSI cmd > 16 bytes must be multiple of 4 */
+			goto crc_queuing_error;
+		}
+		fcp_cmnd_len = 12 + cmd->cmd_len + 4;
+	} else {
+		additional_fcpcdb_len = 0;
+		fcp_cmnd_len = 12 + 16 + 4;
+	}
+
+	fcp_cmnd = &crc_ctx_pkt->fcp_cmnd;
+
+	fcp_cmnd->additional_cdb_len = additional_fcpcdb_len;
+	if (cmd->sc_data_direction == DMA_TO_DEVICE)
+		fcp_cmnd->additional_cdb_len |= 1;
+	else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
+		fcp_cmnd->additional_cdb_len |= 2;
+
+	int_to_scsilun(cmd->device->lun, &fcp_cmnd->lun);
+	memcpy(fcp_cmnd->cdb, cmd->cmnd, cmd->cmd_len);
+	cmd_pkt->fcp_cmnd_dseg_len = cpu_to_le16(fcp_cmnd_len);
+	put_unaligned_le64(crc_ctx_dma + CRC_CONTEXT_FCPCMND_OFF,
+			   &cmd_pkt->fcp_cmnd_dseg_address);
+	fcp_cmnd->task_management = 0;
+	fcp_cmnd->task_attribute = TSK_SIMPLE;
+
+	cmd_pkt->fcp_rsp_dseg_len = 0; /* Let response come in status iocb */
+
+	/* Compute dif len and adjust data len to include protection */
+	dif_bytes = 0;
+	blk_size = cmd->device->sector_size;
+	dif_bytes = (data_bytes / blk_size) * 8;
+
+	switch (scsi_get_prot_op(GET_CMD_SP(sp))) {
+	case SCSI_PROT_READ_INSERT:
+	case SCSI_PROT_WRITE_STRIP:
+		total_bytes = data_bytes;
+		data_bytes += dif_bytes;
+		break;
+
+	case SCSI_PROT_READ_STRIP:
+	case SCSI_PROT_WRITE_INSERT:
+	case SCSI_PROT_READ_PASS:
+	case SCSI_PROT_WRITE_PASS:
+		total_bytes = data_bytes + dif_bytes;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return 1;
+	}
+
+	if (!qla2x00_hba_err_chk_enabled(sp))
+		fw_prot_opts |= 0x10; /* Disable Guard tag checking */
+	/* HBA error checking enabled */
+	else {
+		if ((scsi_get_prot_type(GET_CMD_SP(sp)) == SCSI_PROT_DIF_TYPE1)
+		    || (scsi_get_prot_type(GET_CMD_SP(sp)) ==
+			SCSI_PROT_DIF_TYPE2))
+			fw_prot_opts |= BIT_10;
+		else if (scsi_get_prot_type(GET_CMD_SP(sp)) ==
+		    SCSI_PROT_DIF_TYPE3)
+			fw_prot_opts |= BIT_11;
+	}
+
+	if (!bundling) {
+		cur_dsd = &crc_ctx_pkt->u.nobundling.data_dsd[0];
+	} else {
+		/*
+		 * Configure Bundling if we need to fetch interleaving
+		 * protection PCI accesses
+		 */
+		fw_prot_opts |= PO_ENABLE_DIF_BUNDLING;
+		crc_ctx_pkt->u.bundling.dif_byte_count = cpu_to_le32(dif_bytes);
+		crc_ctx_pkt->u.bundling.dseg_count = cpu_to_le16(tot_dsds -
+							tot_prot_dsds);
+		cur_dsd = &crc_ctx_pkt->u.bundling.data_dsd[0];
+	}
+
+	/* Finish the common fields of CRC pkt */
+	crc_ctx_pkt->blk_size = cpu_to_le16(blk_size);
+	crc_ctx_pkt->prot_opts = cpu_to_le16(fw_prot_opts);
+	crc_ctx_pkt->byte_count = cpu_to_le32(data_bytes);
+	crc_ctx_pkt->guard_seed = cpu_to_le16(0);
+	/* Fibre channel byte count */
+	cmd_pkt->byte_count = cpu_to_le32(total_bytes);
+	fcp_dl = (__be32 *)(crc_ctx_pkt->fcp_cmnd.cdb + 16 +
+	    additional_fcpcdb_len);
+	*fcp_dl = htonl(total_bytes);
+
+	/* Walks data segments */
+
+	cmd_pkt->control_flags_1 |= cpu_to_le16(CF_DATA_SEG_DESCR_ENABLE);
+
+	if (!bundling && tot_prot_dsds) {
+		if (qla24xx_walk_and_build_sglist_no_difb(ha, sp,
+			cur_dsd, tot_dsds, NULL))
+			goto crc_queuing_error;
+	} else if (qla24xx_walk_and_build_sglist(ha, sp, cur_dsd,
+			(tot_dsds - tot_prot_dsds), NULL))
+		goto crc_queuing_error;
+
+	if (bundling && tot_prot_dsds) {
+		/* Walks dif segments */
+		cmd_pkt->control_flags_1 |= cpu_to_le16(CF_DIF_SEG_DESCR_ENABLE);
+		cur_dsd = &crc_ctx_pkt->u.bundling.dif_dsd;
+		if (qla24xx_walk_and_build_prot_sglist(ha, sp, cur_dsd,
+				tot_prot_dsds, NULL))
+			goto crc_queuing_error;
+	}
+	qla29xx_copy_dif_iocb_data(cmd_pkt, crc_ctx_pkt, bundling);
+
+	return QLA_SUCCESS;
+
+crc_queuing_error:
+	/* Cleanup will be performed by the caller */
+	return QLA_FUNCTION_FAILED;
+}
+
+/**
+ * qla29xx_copy_dif_iocb_data() - Populate the DIF-related fields of an
+ * extended CRC_2 command IOCB from a freshly populated crc_context.
+ * @cmd_pkt: Extended CRC_2 command IOCB
+ * @crc_ctx_pkt: Source CRC context
+ * @dif_bundling: DIF bundling flag
+ */
+static void
+qla29xx_copy_dif_iocb_data(struct cmd_type_crc_2_ext *cmd_pkt,
+	struct crc_context *crc_ctx_pkt, uint8_t dif_bundling)
+{
+	cmd_pkt->ref_tag = crc_ctx_pkt->ref_tag;
+	cmd_pkt->app_tag = crc_ctx_pkt->app_tag;
+	memcpy(cmd_pkt->ref_tag_mask, crc_ctx_pkt->ref_tag_mask,
+	       sizeof(cmd_pkt->ref_tag_mask));
+	memcpy(cmd_pkt->app_tag_mask, crc_ctx_pkt->app_tag_mask,
+	       sizeof(cmd_pkt->app_tag_mask));
+	cmd_pkt->blk_size = crc_ctx_pkt->blk_size;
+	cmd_pkt->prot_opts = crc_ctx_pkt->prot_opts;
+	cmd_pkt->tot_byte_count = crc_ctx_pkt->byte_count;
+	if (dif_bundling) {
+		cmd_pkt->u.bundling.guard_seed = crc_ctx_pkt->guard_seed;
+		cmd_pkt->u.bundling.dif_byte_count =
+			crc_ctx_pkt->u.bundling.dif_byte_count;
+		cmd_pkt->u.bundling.dseg_count =
+			crc_ctx_pkt->u.bundling.dseg_count;
+		memcpy(cmd_pkt->u.bundling.data_dsd,
+		       crc_ctx_pkt->u.bundling.data_dsd,
+		       sizeof(cmd_pkt->u.bundling.data_dsd));
+		memcpy(&cmd_pkt->u.bundling.dif_dsd,
+		       &crc_ctx_pkt->u.bundling.dif_dsd,
+		       sizeof(cmd_pkt->u.bundling.dif_dsd));
+	} else {
+		cmd_pkt->u.nobundling.guard_seed = crc_ctx_pkt->guard_seed;
+		memcpy(cmd_pkt->u.nobundling.data_dsd,
+		       crc_ctx_pkt->u.nobundling.data_dsd,
+		       sizeof(cmd_pkt->u.nobundling.data_dsd));
+	}
+}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c47c38e099ff..e95fb0e59f38 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -209,13 +209,7 @@ void __qla_consume_iocb(struct scsi_qla_host *vha,
 		new_pkt = rsp_q->ring_ptr;
 		*pkt = new_pkt;
 
-		rsp_q->ring_index++;
-		if (rsp_q->ring_index == rsp_q->length) {
-			rsp_q->ring_index = 0;
-			rsp_q->ring_ptr = rsp_q->ring;
-		} else {
-			rsp_q->ring_ptr++;
-		}
+		qla_rsp_ring_advance(rsp_q);
 
 		new_pkt->signature = RESPONSE_PROCESSED;
 		/* flush signature */
@@ -287,13 +281,7 @@ int __qla_copy_purex_to_buffer(struct scsi_qla_host *vha,
 				break;
 			}
 
-			rsp_q->ring_index++;
-			if (rsp_q->ring_index == rsp_q->length) {
-				rsp_q->ring_index = 0;
-				rsp_q->ring_ptr = rsp_q->ring;
-			} else {
-				rsp_q->ring_ptr++;
-			}
+			qla_rsp_ring_advance(rsp_q);
 			no_bytes = (pending_bytes > sizeof(new_pkt->data)) ?
 			    sizeof(new_pkt->data) : pending_bytes;
 			if ((buffer_copy_offset + no_bytes) <= total_bytes) {
@@ -1212,13 +1200,7 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 				break;
 			}
 
-			rsp_q->ring_index++;
-			if (rsp_q->ring_index == rsp_q->length) {
-				rsp_q->ring_index = 0;
-				rsp_q->ring_ptr = rsp_q->ring;
-			} else {
-				rsp_q->ring_ptr++;
-			}
+			qla_rsp_ring_advance(rsp_q);
 			no_bytes = (pending_bytes > sizeof(new_pkt->data)) ?
 			    sizeof(new_pkt->data) : pending_bytes;
 			if ((buffer_copy_offset + no_bytes) <= total_bytes) {
@@ -2973,13 +2955,7 @@ qla2x00_process_response_queue(struct rsp_que *rsp)
 	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
 		pkt = (sts_entry_t *)rsp->ring_ptr;
 
-		rsp->ring_index++;
-		if (rsp->ring_index == rsp->length) {
-			rsp->ring_index = 0;
-			rsp->ring_ptr = rsp->ring;
-		} else {
-			rsp->ring_ptr++;
-		}
+		qla_rsp_ring_advance(rsp);
 
 		if (pkt->entry_status != 0) {
 			qla2x00_error_entry(vha, rsp, pkt);
@@ -3941,9 +3917,10 @@ static int qla_chk_cont_iocb_avail(struct scsi_qla_host *vha,
 }
 
 static void qla_marker_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
-	struct mrk_entry_24xx *pkt)
+	void *pkt)
 {
 	const char func[] = "MRK-IOCB";
+	struct mrk_entry_24xx *mrk = pkt;
 	srb_t *sp;
 	int res = QLA_SUCCESS;
 
@@ -3954,7 +3931,7 @@ static void qla_marker_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	if (!sp)
 		return;
 
-	if (pkt->entry_status) {
+	if (mrk->entry_status) {
 		ql_dbg(ql_dbg_taskm, vha, 0x8025, "marker failure.\n");
 		res = QLA_COMMAND_ERROR;
 	}
@@ -4003,13 +3980,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
 		cur_ring_index = rsp->ring_index;
 
-		rsp->ring_index++;
-		if (rsp->ring_index == rsp->length) {
-			rsp->ring_index = 0;
-			rsp->ring_ptr = rsp->ring;
-		} else {
-			rsp->ring_ptr++;
-		}
+		qla_rsp_ring_advance(rsp);
 
 		if (pkt->entry_status != 0) {
 			if (qla2x00_error_entry(vha, rsp, (sts_entry_t *) pkt))
@@ -4079,7 +4050,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 					(struct nack_to_isp *)pkt);
 			break;
 		case MARKER_TYPE:
-			qla_marker_iocb_entry(vha, rsp->req, (struct mrk_entry_24xx *)pkt);
+			qla_marker_iocb_entry(vha, rsp->req, pkt);
 			break;
 		case ABORT_IOCB_TYPE:
 			qla24xx_abort_iocb_entry(vha, rsp->req,
@@ -4127,8 +4098,8 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 					 * interrupt with all IOCBs to arrive
 					 * and re-process.
 					 */
-					rsp->ring_ptr = (response_t *)pkt;
-					rsp->ring_index = cur_ring_index;
+					qla_rsp_ring_rewind_to(rsp,
+					    (response_t *)pkt, cur_ring_index);
 
 					ql_dbg(ql_dbg_init, vha, 0x5091,
 					    "Defer processing ELS opcode %#x...\n",
@@ -4150,8 +4121,8 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 		case PT_LS4_UNSOL:
 			p = (void *)pkt;
 			if (qla_chk_cont_iocb_avail(vha, rsp, (response_t *)pkt, rsp_in)) {
-				rsp->ring_ptr = (response_t *)pkt;
-				rsp->ring_index = cur_ring_index;
+				qla_rsp_ring_rewind_to(rsp, (response_t *)pkt,
+						       cur_ring_index);
 
 				ql_dbg(ql_dbg_init, vha, 0x2124,
 				       "Defer processing UNSOL LS req opcode %#x...\n",
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index e75b7ae22bc5..bb2521c052bf 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -574,13 +574,11 @@ qla25xx_free_req_que(struct scsi_qla_host *vha, struct req_que *req)
 {
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t que_id = req->id;
-	uint16_t reqsz;
+	size_t req_entry_size = qla_req_entry_size(ha);
 
-	reqsz = IS_QLA29XX(ha) ? sizeof(struct request_ext) :
-				 sizeof(request_t);
-
-	dma_free_coherent(&ha->pdev->dev, (req->length + 1) *
-			  reqsz, req->ring, req->dma);
+	dma_free_coherent(&ha->pdev->dev,
+			  (req->length + 1) * req_entry_size,
+			  req->ring, req->dma);
 	req->ring = NULL;
 	req->dma = 0;
 	if (que_id) {
@@ -598,10 +596,7 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 {
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t que_id = rsp->id;
-	uint16_t rspsz;
-
-	rspsz = IS_QLA29XX(ha) ? sizeof(struct response_ext) :
-				 sizeof(response_t);
+	size_t rsp_entry_size = qla_rsp_entry_size(ha);
 
 	if (rsp->msix && rsp->msix->have_irq) {
 		free_irq(rsp->msix->vector, rsp->msix->handle);
@@ -610,8 +605,9 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 		rsp->msix->handle = NULL;
 	}
 
-	dma_free_coherent(&ha->pdev->dev, (rsp->length + 1) *
-			  rspsz, rsp->ring, rsp->dma);
+	dma_free_coherent(&ha->pdev->dev,
+			  (rsp->length + 1) * rsp_entry_size,
+			  rsp->ring, rsp->dma);
 	rsp->ring = NULL;
 	rsp->dma = 0;
 	if (que_id) {
@@ -715,7 +711,7 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	uint16_t que_id = 0;
 	device_reg_t *reg;
 	uint32_t cnt;
-	uint16_t reqsz;
+	size_t req_entry_size = qla_req_entry_size(ha);
 
 	req = kzalloc_obj(struct req_que);
 	if (req == NULL) {
@@ -724,18 +720,19 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 		goto failed;
 	}
 
-	reqsz = IS_QLA29XX(ha) ? sizeof(struct request_ext) :
-				 sizeof(request_t);
-
 	req->length = REQUEST_ENTRY_CNT_24XX;
 	req->ring = dma_alloc_coherent(&ha->pdev->dev,
-			(req->length + 1) * reqsz,
+			(req->length + 1) * req_entry_size,
 			&req->dma, GFP_KERNEL);
 	if (req->ring == NULL) {
 		ql_log(ql_log_fatal, base_vha, 0x00da,
 		    "Failed to allocate memory for request_ring.\n");
 		goto que_failed;
 	}
+	if (IS_QLA29XX(ha)) {
+		req->ring_ext = (struct request_ext *)req->ring;
+		req->ring_ext_ptr = req->ring_ext;
+	}
 
 	ret = qla2x00_alloc_outstanding_cmds(ha, req);
 	if (ret != QLA_SUCCESS)
@@ -781,7 +778,15 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 		req->outstanding_cmds[cnt] = NULL;
 	req->current_outstanding_cmd = 1;
 
+	/*
+	 * Re-anchor both the 24xx (ring_ptr) and 29xx (ring_ext_ptr) views
+	 * at the start of the ring.  Keeping them reset together here
+	 * guarantees they stay in sync with ring_index=0 regardless of any
+	 * prior allocator/fast-path advances against this queue.
+	 */
 	req->ring_ptr = req->ring;
+	if (IS_QLA29XX(ha))
+		req->ring_ext_ptr = req->ring_ext;
 	req->ring_index = 0;
 	req->cnt = req->length;
 	req->id = que_id;
@@ -789,7 +794,15 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	req->req_q_in = &reg->isp25mq.req_q_in;
 	req->req_q_out = &reg->isp25mq.req_q_out;
 	req->max_q_depth = ha->req_q_map[0]->max_q_depth;
-	req->out_ptr = (uint16_t *)(req->ring + req->length);
+	/*
+	 * out_ptr sits in the scratch slot immediately after the ring.  Use
+	 * the 29xx-stride pointer when the ring is 128-byte-per-entry so the
+	 * pointer arithmetic resolves to the correct byte offset.
+	 */
+	if (IS_QLA29XX(ha))
+		req->out_ptr = (uint16_t *)(req->ring_ext + req->length);
+	else
+		req->out_ptr = (uint16_t *)(req->ring + req->length);
 	mutex_unlock(&ha->mq_lock);
 	ql_dbg(ql_dbg_multiq, base_vha, 0xc004,
 	    "ring_ptr=%p ring_index=%d, "
@@ -846,7 +859,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	struct scsi_qla_host *vha = pci_get_drvdata(ha->pdev);
 	uint16_t que_id = 0;
 	device_reg_t *reg;
-	uint16_t rspsz;
+	size_t rsp_entry_size = qla_rsp_entry_size(ha);
 
 	rsp = kzalloc_obj(struct rsp_que);
 	if (rsp == NULL) {
@@ -855,18 +868,19 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 		goto failed;
 	}
 
-	rspsz = IS_QLA29XX(ha) ? sizeof(struct response_ext) :
-				 sizeof(response_t);
-
 	rsp->length = RESPONSE_ENTRY_CNT_MQ;
 	rsp->ring = dma_alloc_coherent(&ha->pdev->dev,
-			(rsp->length + 1) * rspsz,
+			(rsp->length + 1) * rsp_entry_size,
 			&rsp->dma, GFP_KERNEL);
 	if (rsp->ring == NULL) {
 		ql_log(ql_log_warn, base_vha, 0x00e1,
 		    "Failed to allocate memory for response ring.\n");
 		goto que_failed;
 	}
+	if (IS_QLA29XX(ha)) {
+		rsp->ring_ext = (struct response_ext *)rsp->ring;
+		rsp->ring_ext_ptr = rsp->ring_ext;
+	}
 
 	mutex_lock(&ha->mq_lock);
 	que_id = find_first_zero_bit(ha->rsp_qid_map, ha->max_rsp_queues);
@@ -905,7 +919,10 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	reg = ISP_QUE_REG(ha, que_id);
 	rsp->rsp_q_in = &reg->isp25mq.rsp_q_in;
 	rsp->rsp_q_out = &reg->isp25mq.rsp_q_out;
-	rsp->in_ptr = (uint16_t *)(rsp->ring + rsp->length);
+	if (IS_QLA29XX(ha))
+		rsp->in_ptr = (uint16_t *)(rsp->ring_ext + rsp->length);
+	else
+		rsp->in_ptr = (uint16_t *)(rsp->ring + rsp->length);
 	mutex_unlock(&ha->mq_lock);
 	ql_dbg(ql_dbg_multiq, base_vha, 0xc00b,
 	    "options=%x id=%d rsp_q_in=%p rsp_q_out=%p\n",
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 2531e71c39dc..b2eacf0277f4 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -554,7 +554,8 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	unsigned long   flags;
 	uint32_t        *clr_ptr;
 	uint32_t        handle;
-	struct cmd_nvme *cmd_pkt;
+	struct cmd_nvme *cmd_pkt = NULL;
+	struct cmd_nvme_ext *cmd_pkt_ext = NULL;
 	uint16_t        cnt, i;
 	uint16_t        req_cnt;
 	uint16_t        tot_dsds;
@@ -584,7 +585,10 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 		rval = -EBUSY;
 		goto queuing_error;
 	}
-	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+	if (IS_QLA29XX(ha))
+		req_cnt = qla29xx_calc_iocbs(vha, tot_dsds, NUM_NVME_DSDS);
+	else
+		req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 
 	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
 	sp->iores.exch_cnt = 1;
@@ -629,19 +633,62 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	sp->handle = handle;
 	req->cnt -= req_cnt;
 
-	cmd_pkt = (struct cmd_nvme *)req->ring_ptr;
+	/*
+	 * 29xx operates on the 128-byte extended IOCB ring; the header
+	 * layout of struct cmd_nvme is identical to the head of struct
+	 * cmd_nvme_ext through 'byte_count', so the common-field writes
+	 * below go through cmd_pkt regardless of stride.  Divergent tail
+	 * fields (port_id/vp_index, DSD array) are handled via
+	 * IS_QLA29XX(ha) branches.
+	 *
+	 * Enforce the layout contract at compile time so any future
+	 * change to either struct that breaks the common-header overlap
+	 * fails the build rather than silently corrupting IOCBs.
+	 */
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, entry_type) !=
+		     offsetof(struct cmd_nvme_ext, entry_type));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, handle) !=
+		     offsetof(struct cmd_nvme_ext, handle));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, nport_handle) !=
+		     offsetof(struct cmd_nvme_ext, nport_handle));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, timeout) !=
+		     offsetof(struct cmd_nvme_ext, timeout));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, dseg_count) !=
+		     offsetof(struct cmd_nvme_ext, dseg_count));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, nvme_rsp_dsd_len) !=
+		     offsetof(struct cmd_nvme_ext, nvme_rsp_dsd_len));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, rsvd) !=
+		     offsetof(struct cmd_nvme_ext, rsvd));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, control_flags) !=
+		     offsetof(struct cmd_nvme_ext, control_flags));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, nvme_cmnd_dseg_len) !=
+		     offsetof(struct cmd_nvme_ext, nvme_cmnd_dseg_len));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, nvme_cmnd_dseg_address) !=
+		     offsetof(struct cmd_nvme_ext, nvme_cmnd_dseg_address));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, nvme_rsp_dseg_address) !=
+		     offsetof(struct cmd_nvme_ext, nvme_rsp_dseg_address));
+	BUILD_BUG_ON(offsetof(struct cmd_nvme, byte_count) !=
+		     offsetof(struct cmd_nvme_ext, byte_count));
+	BUILD_BUG_ON(sizeof_field(struct cmd_nvme, byte_count) !=
+		     sizeof_field(struct cmd_nvme_ext, byte_count));
+
+	if (IS_QLA29XX(ha))
+		cmd_pkt = (struct cmd_nvme *)req->ring_ext_ptr;
+	else
+		cmd_pkt = (struct cmd_nvme *)req->ring_ptr;
+	cmd_pkt_ext = (struct cmd_nvme_ext *)cmd_pkt;
 	cmd_pkt->handle = make_handle(req->id, handle);
 
 	/* Zero out remaining portion of packet. */
 	clr_ptr = (uint32_t *)cmd_pkt + 2;
-	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
+	if (IS_QLA29XX(ha))
+		memset(clr_ptr, 0, REQUEST_ENTRY_SIZE_EXT - 8);
+	else
+		memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
 
 	cmd_pkt->entry_status = 0;
-
-	/* Update entry type to indicate Command NVME IOCB */
 	cmd_pkt->entry_type = COMMAND_NVME;
 
-	/* No data transfer how do we check buffer len == 0?? */
 	if (fd->io_dir == NVMEFC_FCP_READ) {
 		cmd_pkt->control_flags = cpu_to_le16(CF_READ_DATA);
 		qpair->counters.input_bytes += fd->payload_length;
@@ -666,18 +713,23 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	if (sp->fcport->edif.enable && fd->io_dir != 0)
 		cmd_pkt->control_flags |= cpu_to_le16(CF_EN_EDIF);
 
-	/* Set BIT_13 of control flags for Async event */
 	if (vha->flags.nvme2_enabled &&
-	    cmd->sqe.common.opcode == nvme_admin_async_event) {
+	    cmd->sqe.common.opcode == nvme_admin_async_event)
 		cmd_pkt->control_flags |= cpu_to_le16(CF_ADMIN_ASYNC_EVENT);
-	}
 
-	/* Set NPORT-ID */
 	cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
-	cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
-	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
-	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
-	cmd_pkt->vp_index = sp->fcport->vha->vp_idx;
+	if (IS_QLA29XX(ha)) {
+		/*
+		 * 29xx extended NVMe IOCB has no port_id[] field; vp_index is
+		 * a 9-bit __le16 (see CMD_EXT_VP_INDEX_MASK).
+		 */
+		cmd_pkt_ext->vp_index = cpu_to_le16(sp->fcport->vha->vp_idx);
+	} else {
+		cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
+		cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
+		cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
+		cmd_pkt->vp_index = sp->fcport->vha->vp_idx;
+	}
 
 	/* NVME RSP IU */
 	cmd_pkt->nvme_rsp_dsd_len = cpu_to_le16(fd->rsplen);
@@ -690,36 +742,51 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
 	cmd_pkt->byte_count = cpu_to_le32(fd->payload_length);
 
-	/* One DSD is available in the Command Type NVME IOCB */
-	avail_dsds = 1;
-	cur_dsd = &cmd_pkt->nvme_dsd;
+	/*
+	 * 24xx carries a single inline DSD in the NVMe command IOCB; 29xx
+	 * carries NUM_NVME_DSDS inline DSDs in the extended IOCB.
+	 */
+	if (IS_QLA29XX(ha)) {
+		avail_dsds = NUM_NVME_DSDS;
+		cur_dsd = &cmd_pkt_ext->nvme_dsd[0];
+	} else {
+		avail_dsds = 1;
+		cur_dsd = &cmd_pkt->nvme_dsd;
+	}
 	sgl = fd->first_sgl;
 
 	/* Load data segments */
 	for_each_sg(sgl, sg, tot_dsds, i) {
-		cont_a64_entry_t *cont_pkt;
-
 		/* Allocate additional continuation packets? */
 		if (avail_dsds == 0) {
-			/*
-			 * Five DSDs are available in the Continuation
-			 * Type 1 IOCB.
-			 */
-
-			/* Adjust ring index */
-			req->ring_index++;
-			if (req->ring_index == req->length) {
-				req->ring_index = 0;
-				req->ring_ptr = req->ring;
+			if (IS_QLA29XX(ha)) {
+				struct cont_a64_entry_ext *cont_pkt;
+
+				cont_pkt = qla2900_prep_cont_type1_iocb(vha,
+									req);
+				cur_dsd = cont_pkt->dsd;
+				avail_dsds = ARRAY_SIZE(cont_pkt->dsd);
 			} else {
-				req->ring_ptr++;
+				cont_a64_entry_t *cont_pkt;
+
+				/*
+				 * Five DSDs are available in the 24xx
+				 * Continuation Type 1 IOCB.
+				 */
+				req->ring_index++;
+				if (req->ring_index == req->length) {
+					req->ring_index = 0;
+					req->ring_ptr = req->ring;
+				} else {
+					req->ring_ptr++;
+				}
+				cont_pkt = (cont_a64_entry_t *)req->ring_ptr;
+				put_unaligned_le32(CONTINUE_A64_TYPE,
+						   &cont_pkt->entry_type);
+
+				cur_dsd = cont_pkt->dsd;
+				avail_dsds = ARRAY_SIZE(cont_pkt->dsd);
 			}
-			cont_pkt = (cont_a64_entry_t *)req->ring_ptr;
-			put_unaligned_le32(CONTINUE_A64_TYPE,
-					   &cont_pkt->entry_type);
-
-			cur_dsd = cont_pkt->dsd;
-			avail_dsds = ARRAY_SIZE(cont_pkt->dsd);
 		}
 
 		append_dsd64(&cur_dsd, sg);
@@ -731,13 +798,7 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	wmb();
 
 	/* Adjust ring index. */
-	req->ring_index++;
-	if (req->ring_index == req->length) {
-		req->ring_index = 0;
-		req->ring_ptr = req->ring;
-	} else {
-		req->ring_ptr++;
-	}
+	qla_req_ring_advance(ha, req);
 
 	/* ignore nvme async cmd due to long timeout */
 	if (!nvme->u.nvme.aen_op)
@@ -746,7 +807,12 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	/* Set chip new ring index. */
 	wrt_reg_dword(req->req_q_in, req->ring_index);
 
-	if (vha->flags.process_response_queue &&
+	/*
+	 * 29xx inline response drain would require the 128-byte response ring
+	 * view, which the 24xx qla24xx_process_response_queue() does not walk;
+	 * skip here and rely on the normal ISR path.
+	 */
+	if (!IS_QLA29XX(ha) && vha->flags.process_response_queue &&
 	    rsp->ring_ptr->signature != RESPONSE_PROCESSED)
 		qla24xx_process_response_queue(vha, rsp);
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 948242f0088e..146701445485 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -502,6 +502,8 @@ static int qla2x00_alloc_queues(struct qla_hw_data *ha, struct req_que *req,
 
 static void qla2x00_free_req_que(struct qla_hw_data *ha, struct req_que *req)
 {
+	size_t req_entry_size = qla_req_entry_size(ha);
+
 	if (IS_QLAFX00(ha)) {
 		if (req && req->ring_fx00)
 			dma_free_coherent(&ha->pdev->dev,
@@ -509,8 +511,8 @@ static void qla2x00_free_req_que(struct qla_hw_data *ha, struct req_que *req)
 			    req->ring_fx00, req->dma_fx00);
 	} else if (req && req->ring)
 		dma_free_coherent(&ha->pdev->dev,
-		(req->length + 1) * sizeof(request_t),
-		req->ring, req->dma);
+		    (req->length + 1) * req_entry_size,
+		    req->ring, req->dma);
 
 	if (req)
 		kfree(req->outstanding_cmds);
@@ -520,6 +522,8 @@ static void qla2x00_free_req_que(struct qla_hw_data *ha, struct req_que *req)
 
 static void qla2x00_free_rsp_que(struct qla_hw_data *ha, struct rsp_que *rsp)
 {
+	size_t rsp_entry_size = qla_rsp_entry_size(ha);
+
 	if (IS_QLAFX00(ha)) {
 		if (rsp && rsp->ring_fx00)
 			dma_free_coherent(&ha->pdev->dev,
@@ -527,8 +531,8 @@ static void qla2x00_free_rsp_que(struct qla_hw_data *ha, struct rsp_que *rsp)
 			    rsp->ring_fx00, rsp->dma_fx00);
 	} else if (rsp && rsp->ring) {
 		dma_free_coherent(&ha->pdev->dev,
-		(rsp->length + 1) * sizeof(response_t),
-		rsp->ring, rsp->dma);
+		    (rsp->length + 1) * rsp_entry_size,
+		    rsp->ring, rsp->dma);
 	}
 	kfree(rsp);
 }
@@ -2693,6 +2697,7 @@ static struct isp_operations qla29xx_isp_ops = {
 	.read_optrom_region	= qla29xx_read_optrom_data,
 	.write_optrom_region	= qla29xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
+	.start_scsi		= qla24xx_dif_start_scsi,
 	.start_scsi_mq		= qla2xxx_dif_start_scsi_mq,
 	.abort_isp		= qla2x00_abort_isp,
 	.iospace_config		= qla83xx_iospace_config,
@@ -4249,6 +4254,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 {
 	char	name[16];
 	int rc;
+	size_t req_entry_size = qla_req_entry_size(ha);
+	size_t rsp_entry_size = qla_rsp_entry_size(ha);
 
 	if (QLA_TGT_MODE_ENABLED() || EDIF_CAP(ha)) {
 		ha->vp_map = kzalloc_objs(struct qla_vp_map,
@@ -4444,13 +4451,17 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	}
 	(*req)->length = req_len;
 	(*req)->ring = dma_alloc_coherent(&ha->pdev->dev,
-		((*req)->length + 1) * sizeof(request_t),
+		((*req)->length + 1) * req_entry_size,
 		&(*req)->dma, GFP_KERNEL);
 	if (!(*req)->ring) {
 		ql_log_pci(ql_log_fatal, ha->pdev, 0x0029,
 		    "Failed to allocate memory for req_ring.\n");
 		goto fail_req_ring;
 	}
+	if (IS_QLA29XX(ha)) {
+		(*req)->ring_ext = (struct request_ext *)(*req)->ring;
+		(*req)->ring_ext_ptr = (*req)->ring_ext;
+	}
 	/* Allocate memory for response ring */
 	*rsp = kzalloc_obj(struct rsp_que);
 	if (!*rsp) {
@@ -4461,13 +4472,17 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	(*rsp)->hw = ha;
 	(*rsp)->length = rsp_len;
 	(*rsp)->ring = dma_alloc_coherent(&ha->pdev->dev,
-		((*rsp)->length + 1) * sizeof(response_t),
+		((*rsp)->length + 1) * rsp_entry_size,
 		&(*rsp)->dma, GFP_KERNEL);
 	if (!(*rsp)->ring) {
 		ql_log_pci(ql_log_fatal, ha->pdev, 0x002b,
 		    "Failed to allocate memory for rsp_ring.\n");
 		goto fail_rsp_ring;
 	}
+	if (IS_QLA29XX(ha)) {
+		(*rsp)->ring_ext = (struct response_ext *)(*rsp)->ring;
+		(*rsp)->ring_ext_ptr = (*rsp)->ring_ext;
+	}
 	(*req)->rsp = *rsp;
 	(*rsp)->req = *req;
 	ql_dbg_pci(ql_dbg_init, ha->pdev, 0x002c,
@@ -4617,16 +4632,18 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 fail_ex_init_cb:
 	kfree(ha->npiv_info);
 fail_npiv_info:
-	dma_free_coherent(&ha->pdev->dev, ((*rsp)->length + 1) *
-		sizeof(response_t), (*rsp)->ring, (*rsp)->dma);
+	dma_free_coherent(&ha->pdev->dev,
+		((*rsp)->length + 1) * rsp_entry_size,
+		(*rsp)->ring, (*rsp)->dma);
 	(*rsp)->ring = NULL;
 	(*rsp)->dma = 0;
 fail_rsp_ring:
 	kfree(*rsp);
 	*rsp = NULL;
 fail_rsp:
-	dma_free_coherent(&ha->pdev->dev, ((*req)->length + 1) *
-		sizeof(request_t), (*req)->ring, (*req)->dma);
+	dma_free_coherent(&ha->pdev->dev,
+		((*req)->length + 1) * req_entry_size,
+		(*req)->ring, (*req)->dma);
 	(*req)->ring = NULL;
 	(*req)->dma = 0;
 fail_req_ring:
@@ -8324,6 +8341,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct access_chip_rsp_84xx) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_bidir) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_nvme) != 64);
+	BUILD_BUG_ON(sizeof(struct cmd_nvme_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct cmd_type_6) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_type_7) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_type_7_fx00) != 64);
@@ -8351,6 +8369,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct mbx_entry) != 64);
 	BUILD_BUG_ON(sizeof(struct mid_init_cb_24xx) != 5252);
 	BUILD_BUG_ON(sizeof(struct mrk_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct mrk_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct nvram_24xx) != 512);
 	BUILD_BUG_ON(sizeof(struct nvram_81xx) != 512);
 	BUILD_BUG_ON(sizeof(struct pt_ls4_request) != 64);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index e47da45e93a0..53a505df8da0 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1738,8 +1738,8 @@ static int qlt_build_abts_resp_iocb(struct qla_tgt_mgmt_cmd *mcmd)
 		return -EAGAIN;
 	}
 
-	resp = (struct abts_resp_to_24xx *)qpair->req->ring_ptr;
-	memset(resp, 0, sizeof(*resp));
+	resp = (struct abts_resp_to_24xx *)qla_req_ring_slot(ha, qpair->req);
+	memset(resp, 0, qla_req_entry_size(ha));
 
 	h = qlt_make_handle(qpair);
 	if (unlikely(h == QLA_TGT_NULL_HANDLE)) {
@@ -2490,17 +2490,13 @@ static int qlt_check_reserve_free_req(struct qla_qpair *qpair,
 /*
  * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
  */
-static inline void *qlt_get_req_pkt(struct req_que *req)
+static inline void *qlt_get_req_pkt(struct qla_hw_data *ha,
+				     struct req_que *req)
 {
 	/* Adjust ring index. */
-	req->ring_index++;
-	if (req->ring_index == req->length) {
-		req->ring_index = 0;
-		req->ring_ptr = req->ring;
-	} else {
-		req->ring_ptr++;
-	}
-	return (cont_entry_t *)req->ring_ptr;
+	qla_req_ring_advance(ha, req);
+
+	return qla_req_ring_slot(ha, req);
 }
 
 /* ha->hardware_lock supposed to be held on entry */
@@ -2549,9 +2545,9 @@ static int qlt_24xx_build_ctio_pkt(struct qla_qpair *qpair,
 	uint16_t temp;
 	struct qla_tgt_cmd      *cmd = prm->cmd;
 
-	pkt = (struct ctio7_to_24xx *)qpair->req->ring_ptr;
+	pkt = (struct ctio7_to_24xx *)qla_req_ring_slot(qpair->hw, qpair->req);
 	prm->pkt = pkt;
-	memset(pkt, 0, sizeof(*pkt));
+	memset(pkt, 0, qla_req_entry_size(qpair->hw));
 
 	pkt->entry_type = CTIO_TYPE7;
 	pkt->entry_count = (uint8_t)prm->req_cnt;
@@ -2600,11 +2596,12 @@ static void qlt_load_cont_data_segments(struct qla_tgt_prm *prm)
 {
 	int cnt;
 	struct dsd64 *cur_dsd;
+	struct qla_hw_data *ha = prm->cmd->qpair->hw;
 
 	/* Build continuation packets */
 	while (prm->seg_cnt > 0) {
 		cont_a64_entry_t *cont_pkt64 =
-			(cont_a64_entry_t *)qlt_get_req_pkt(
+			(cont_a64_entry_t *)qlt_get_req_pkt(ha,
 			   prm->cmd->qpair->req);
 
 		/*
@@ -2614,7 +2611,7 @@ static void qlt_load_cont_data_segments(struct qla_tgt_prm *prm)
 		 * that.
 		 */
 
-		memset(cont_pkt64, 0, sizeof(*cont_pkt64));
+		memset(cont_pkt64, 0, qla_req_entry_size(ha));
 
 		cont_pkt64->entry_count = 1;
 		cont_pkt64->sys_define = 0;
@@ -3012,9 +3009,9 @@ qlt_build_ctio_crc2_pkt(struct qla_qpair *qpair, struct qla_tgt_prm *prm)
 
 	ha = vha->hw;
 
-	pkt = (struct ctio_crc2_to_fw *)qpair->req->ring_ptr;
+	pkt = (struct ctio_crc2_to_fw *)qla_req_ring_slot(ha, qpair->req);
 	prm->pkt = pkt;
-	memset(pkt, 0, sizeof(*pkt));
+	memset(pkt, 0, qla_req_entry_size(ha));
 
 	ql_dbg_qp(ql_dbg_tgt, cmd->qpair, 0xe071,
 		"qla_target(%d):%s: se_cmd[%p] CRC2 prot_op[0x%x] cmd prot sg:cnt[%p:%x] lba[%llu]\n",
@@ -3306,7 +3303,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 			 */
 			struct ctio7_to_24xx *ctio =
 				(struct ctio7_to_24xx *)qlt_get_req_pkt(
-				    qpair->req);
+				    vha->hw, qpair->req);
 
 			ql_dbg_qp(ql_dbg_tgt, qpair, 0x305e,
 			    "Building additional status packet 0x%p.\n",
@@ -3316,6 +3313,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 			 * T10Dif: ctio_crc2_to_fw overlay ontop of
 			 * ctio7_to_24xx
 			 */
+			memset(ctio, 0, qla_req_entry_size(vha->hw));
 			memcpy(ctio, pkt, sizeof(*ctio));
 			/* reset back to CTIO7 */
 			ctio->entry_count = 1;
-- 
2.47.3

