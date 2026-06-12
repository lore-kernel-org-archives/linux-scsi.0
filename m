Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C152E258CE5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258126; cv=none; b=qI9gjH2BQ2f9BEK+zMWJ5epJrHpDmc0RYZMZ3EqPNxKv7Kpd0YNGKUrRRDKbg0X5uLnCIhzoZtVG/RN6GzP3yEj1ZncxSHmMNzdu1D0FnNZQmcwQQQYgjPRcDVvaGAqH3DEGQMuOjPbeXS/oNbC841NlhhliS5AKAcRyfvZa+u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258126; c=relaxed/simple;
	bh=W4bPU0GUw6poXJOHOC4CPLI6YlzVh8RoSYR9x8Ym6Ao=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=um74ZH7wTNQc7MkmZyoDAZigdBcE/BP1LvaYv4xnTbfdPfo2GE0qPsF9klxIM1oQhiXTOH8+HwHve//X5QCCrY9hH+Npl7VSGiEWoV25lBoUJNqpg8b5NuWaaU8HQ53OZkQTgKXSy5tONjazEgia0BLtxkY0vDfbrFzQqjlfUXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=WMLY9OKg; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="WMLY9OKg"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C3AQHt071108;
	Fri, 12 Jun 2026 02:55:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=v
	Z98K1+17bMLxcZ0Y6OZcSjGmASJBvQ9m2BJnEvaTFo=; b=WMLY9OKgBj9YAfWHj
	Mbx3gQlz1/ei9n56GiAoJcCc/PYX4vdWd0e/NmGHp1i5ZeA/iVmZmpERseuGnFBw
	RcsuD5zc7sP1ItMm7fBchuYCzx2GMFoUc0HbNLz8MbXlHU4P4QC3B4l6LA9VRCRc
	WwdRmptWxmeCNQX+To61yVZPAAnxC9ohHz/RXMxCw7lz/82zBES3hSDv4XMMvOVG
	yKHLsBShXLySYG5NJvAU8qZxGPRTwm1l+dqYlk746vqWzQqhYkuYmBkZqlWxycWy
	qxRt+zwrFZyVM/NAHDgmFd90qFEXb9bPKy4GtUo9hjhC+usN+2kqWCQlRMQaQ5/M
	U1wkw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5vxrn7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:55:21 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:55:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:55:19 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 757CC3F7040;
	Fri, 12 Jun 2026 02:55:17 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 27/60] scsi: qla2xxx: Refactor marker IOCB handling for 29xx series
Date: Fri, 12 Jun 2026 15:23:00 +0530
Message-ID: <20260612095333.1666592-28-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfXz8czCg2R4q5m
 yxyl1lMK2SJdVTpvFAhMcyrS5VeGmsuF5LnqqpXWdyV25FKdhvpjc0GkCCiFTdlu8XPMs0bMlIV
 jEGqxa8vh6vWug455AobjtsltC2hN20=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX0jv+SMoBi2ej
 K+WRehz+c6H25Xf8BjUeTrIjZ+ebGG8UNhgPERLPJuphXS3Mu4XrlT43ZBZCqx9en/kpby8EtlD
 D+AeG/TiSn+wTCZTqMsbdbqLupldmtHjLV1kxEaNRQdruWx0be/l2J3NKx9VkuDomcqqagVfKsf
 igDGvYXmIh0PF9GwgIbe4DBlZ0Oodf/128rckzTL0UsRKl0Cfp3TO8FaTLvj8HJIrdJ1zpraDdK
 K1IZHAqjzXc7sNHJtpfMQMwfhskgb1gWc1Cdz3JopyQyHJYHH6ln648zT3ynpKbvlzEsnu6ZV0T
 cJalzQOMWu3O1stwGhuDtpuuhwo5JvD3x9BGsUb9IjRqWOAD3ZWk9D04Oww4PWWYIMET8G+BoHs
 KWHfHq4t4RNX5OK51q+iFuQmUN6vL33Xj++JtKBp+leZ50vNiGmRkjfDSVz5+qbc9K8Fxu+5NY8
 s9/AfRgx4fhdc+K4wzw==
X-Authority-Analysis: v=2.4 cv=UPDt2ify c=1 sm=1 tr=0 ts=6a2bd789 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=jv2C93Soc78RleZVqFQA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: AKq_pWaap5dPzhA6W1OwXMhBgvVs1KGz
X-Proofpoint-GUID: AKq_pWaap5dPzhA6W1OwXMhBgvVs1KGz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

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

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  2 +-
 drivers/scsi/qla2xxx/qla_iocb.c | 84 ++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_isr.c  |  7 +--
 drivers/scsi/qla2xxx/qla_os.c   |  1 +
 4 files changed, 48 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index e93766e81480..0bbe2bae7101 100644
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
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index c219cafe4f28..595fe78920ae 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -518,64 +518,49 @@ static int
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
-	 * 29xx uses the extended marker IOCB (128 bytes) with a __le16
-	 * vp_index field.  The first 64 bytes of mrk_entry_24xx_ext are
-	 * layout-compatible with mrk_entry_24xx except for the vp_index
-	 * storage, which differs in width and offset, so handle it via
-	 * a dedicated branch.
+	 * FWI2-capable adapters use the 24xx marker layout; 29xx uses the
+	 * extended marker IOCB (128 bytes) whose first 64 bytes overlay
+	 * mrk_entry_24xx through 'lun', so the common header is written
+	 * through a struct mrk_entry_24xx * view and only vp_index (u8 vs
+	 * __le16) needs a stride-aware branch.  Pre-FWI2 adapters
+	 * (ISP21xx/22xx/23xx) use the legacy mrk_entry_t layout with a
+	 * 2-byte target ID and a 16-bit LUN.
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
 
-post:
-
 	wmb();
 
 	qla2x00_start_iocbs(vha, req);
@@ -4046,16 +4031,31 @@ static int qla_get_iocbs_resource(struct srb *sp)
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
index 3ac48eeb9f69..9dd181feeb87 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8370,6 +8370,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct mbx_entry) != 64);
 	BUILD_BUG_ON(sizeof(struct mid_init_cb_24xx) != 5252);
 	BUILD_BUG_ON(sizeof(struct mrk_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct mrk_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct nvram_24xx) != 512);
 	BUILD_BUG_ON(sizeof(struct nvram_81xx) != 512);
 	BUILD_BUG_ON(sizeof(struct pt_ls4_request) != 64);
-- 
2.47.3

