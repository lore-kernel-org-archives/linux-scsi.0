From: Andy Grover <agrover@redhat.com>
Subject: [PATCH] iscsi: Use struct scsi_lun in iscsi structs instead of u8[8]
Date: Thu, 16 Jun 2011 15:57:09 -0700
Message-ID: <1308265029-32337-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756144Ab1FPW5O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2011 18:57:14 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5GMvEG3015044
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2011 18:57:14 -0400
Received: from agrover.com ([10.3.113.10])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p5GMvE3A024013
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2011 18:57:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

struct scsi_lun is also just a struct with an array of 8 octets (64 bits)
but using it instead in iscsi structs lets us call scsilun_to_int
without a cast, and also lets us copy it using assignment, instead of
memcpy().

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/scsi/be2iscsi/be_main.c |    5 ++---
 drivers/scsi/bnx2i/bnx2i_hwi.c  |    8 ++++----
 drivers/scsi/libiscsi.c         |   14 +++++++-------
 include/scsi/iscsi_proto.h      |   18 +++++++++---------
 include/scsi/libiscsi.h         |    2 +-
 5 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 94b9a07..96d7d07 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3963,11 +3963,10 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 	}
 	memcpy(&io_task->cmd_bhs->iscsi_data_pdu.
 	       dw[offsetof(struct amap_pdu_data_out, lun) / 32],
-	       io_task->cmd_bhs->iscsi_hdr.lun, sizeof(struct scsi_lun));
+	       &io_task->cmd_bhs->iscsi_hdr.lun, sizeof(struct scsi_lun));
 
 	AMAP_SET_BITS(struct amap_iscsi_wrb, lun, pwrb,
-		      cpu_to_be16((unsigned short)io_task->cmd_bhs->iscsi_hdr.
-				  lun[0]));
+		      cpu_to_be16(*(unsigned short*)&io_task->cmd_bhs->iscsi_hdr.lun));
 	AMAP_SET_BITS(struct amap_iscsi_wrb, r2t_exp_dtl, pwrb, xferlen);
 	AMAP_SET_BITS(struct amap_iscsi_wrb, wrb_idx, pwrb,
 		      io_task->pwrb_handle->wrb_index);
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 5c54a2d..550e6c4 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -430,7 +430,7 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_conn,
 	default:
 		tmfabort_wqe->ref_itt = RESERVED_ITT;
 	}
-	memcpy(scsi_lun, tmfabort_hdr->lun, sizeof(struct scsi_lun));
+	memcpy(scsi_lun, &tmfabort_hdr->lun, sizeof(struct scsi_lun));
 	tmfabort_wqe->lun[0] = be32_to_cpu(scsi_lun[0]);
 	tmfabort_wqe->lun[1] = be32_to_cpu(scsi_lun[1]);
 
@@ -547,7 +547,7 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
 
 	nopout_wqe->op_code = nopout_hdr->opcode;
 	nopout_wqe->op_attr = ISCSI_FLAG_CMD_FINAL;
-	memcpy(nopout_wqe->lun, nopout_hdr->lun, 8);
+	memcpy(nopout_wqe->lun, &nopout_hdr->lun, 8);
 
 	if (test_bit(BNX2I_NX2_DEV_57710, &ep->hba->cnic_dev_type)) {
 		u32 tmp = nopout_wqe->lun[0];
@@ -1711,7 +1711,7 @@ static int bnx2i_process_nopin_mesg(struct iscsi_session *session,
 		hdr->flags = ISCSI_FLAG_CMD_FINAL;
 		hdr->itt = task->hdr->itt;
 		hdr->ttt = cpu_to_be32(nop_in->ttt);
-		memcpy(hdr->lun, nop_in->lun, 8);
+		memcpy(&hdr->lun, nop_in->lun, 8);
 	}
 done:
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
@@ -1754,7 +1754,7 @@ static void bnx2i_process_async_mesg(struct iscsi_session *session,
 	resp_hdr->opcode = async_cqe->op_code;
 	resp_hdr->flags = 0x80;
 
-	memcpy(resp_hdr->lun, async_cqe->lun, 8);
+	memcpy(&resp_hdr->lun, async_cqe->lun, 8);
 	resp_hdr->exp_cmdsn = cpu_to_be32(async_cqe->exp_cmd_sn);
 	resp_hdr->max_cmdsn = cpu_to_be32(async_cqe->max_cmd_sn);
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0c550d5..d7a4120 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -169,7 +169,7 @@ void iscsi_prep_data_out_pdu(struct iscsi_task *task, struct iscsi_r2t_info *r2t
 	hdr->datasn = cpu_to_be32(r2t->datasn);
 	r2t->datasn++;
 	hdr->opcode = ISCSI_OP_SCSI_DATA_OUT;
-	memcpy(hdr->lun, task->lun, sizeof(hdr->lun));
+	hdr->lun = task->lun;
 	hdr->itt = task->hdr_itt;
 	hdr->exp_statsn = r2t->exp_statsn;
 	hdr->offset = cpu_to_be32(r2t->data_offset + r2t->sent);
@@ -296,7 +296,7 @@ static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
 		/*
 		 * Allow PDUs for unrelated LUNs
 		 */
-		hdr_lun = scsilun_to_int((struct scsi_lun *)tmf->lun);
+		hdr_lun = scsilun_to_int(&tmf->lun);
 		if (hdr_lun != task->sc->device->lun)
 			return 0;
 		/* fall through */
@@ -389,8 +389,8 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 		return rc;
 	hdr->opcode = ISCSI_OP_SCSI_CMD;
 	hdr->flags = ISCSI_ATTR_SIMPLE;
-	int_to_scsilun(sc->device->lun, (struct scsi_lun *)hdr->lun);
-	memcpy(task->lun, hdr->lun, sizeof(task->lun));
+	int_to_scsilun(sc->device->lun, &hdr->lun);
+	task->lun = hdr->lun;
 	hdr->exp_statsn = cpu_to_be32(conn->exp_statsn);
 	cmd_len = sc->cmd_len;
 	if (cmd_len < ISCSI_CDB_SIZE)
@@ -968,7 +968,7 @@ static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 	hdr.flags = ISCSI_FLAG_CMD_FINAL;
 
 	if (rhdr) {
-		memcpy(hdr.lun, rhdr->lun, 8);
+		hdr.lun = rhdr->lun;
 		hdr.ttt = rhdr->ttt;
 		hdr.itt = RESERVED_ITT;
 	} else
@@ -2092,7 +2092,7 @@ static void iscsi_prep_abort_task_pdu(struct iscsi_task *task,
 	hdr->opcode = ISCSI_OP_SCSI_TMFUNC | ISCSI_OP_IMMEDIATE;
 	hdr->flags = ISCSI_TM_FUNC_ABORT_TASK & ISCSI_FLAG_TM_FUNC_MASK;
 	hdr->flags |= ISCSI_FLAG_CMD_FINAL;
-	memcpy(hdr->lun, task->lun, sizeof(hdr->lun));
+	hdr->lun = task->lun;
 	hdr->rtt = task->hdr_itt;
 	hdr->refcmdsn = task->cmdsn;
 }
@@ -2233,7 +2233,7 @@ static void iscsi_prep_lun_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
 	hdr->opcode = ISCSI_OP_SCSI_TMFUNC | ISCSI_OP_IMMEDIATE;
 	hdr->flags = ISCSI_TM_FUNC_LOGICAL_UNIT_RESET & ISCSI_FLAG_TM_FUNC_MASK;
 	hdr->flags |= ISCSI_FLAG_CMD_FINAL;
-	int_to_scsilun(sc->device->lun, (struct scsi_lun *)hdr->lun);
+	int_to_scsilun(sc->device->lun, &hdr->lun);
 	hdr->rtt = RESERVED_ITT;
 }
 
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index dd0a52c..ea68b3c 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -60,7 +60,7 @@ struct iscsi_hdr {
 	uint8_t		rsvd2[2];
 	uint8_t		hlength;	/* AHSs total length */
 	uint8_t		dlength[3];	/* Data length */
-	uint8_t		lun[8];
+	struct scsi_lun	lun;
 	itt_t		itt;		/* Initiator Task Tag, opaque for target */
 	__be32		ttt;		/* Target Task Tag */
 	__be32		statsn;
@@ -122,7 +122,7 @@ struct iscsi_cmd {
 	__be16 rsvd2;
 	uint8_t hlength;
 	uint8_t dlength[3];
-	uint8_t lun[8];
+	struct scsi_lun lun;
 	itt_t	 itt;	/* Initiator Task Tag */
 	__be32 data_length;
 	__be32 cmdsn;
@@ -198,7 +198,7 @@ struct iscsi_async {
 	uint8_t rsvd2[2];
 	uint8_t rsvd3;
 	uint8_t dlength[3];
-	uint8_t lun[8];
+	struct scsi_lun	lun;
 	uint8_t rsvd4[8];
 	__be32	statsn;
 	__be32	exp_cmdsn;
@@ -226,7 +226,7 @@ struct iscsi_nopout {
 	__be16	rsvd2;
 	uint8_t rsvd3;
 	uint8_t dlength[3];
-	uint8_t lun[8];
+	struct scsi_lun	lun;
 	itt_t	 itt;	/* Initiator Task Tag */
 	__be32	ttt;	/* Target Transfer Tag */
 	__be32	cmdsn;
@@ -241,7 +241,7 @@ struct iscsi_nopin {
 	__be16	rsvd2;
 	uint8_t rsvd3;
 	uint8_t dlength[3];
-	uint8_t lun[8];
+	struct scsi_lun	lun;
 	itt_t	 itt;	/* Initiator Task Tag */
 	__be32	ttt;	/* Target Transfer Tag */
 	__be32	statsn;
@@ -257,7 +257,7 @@ struct iscsi_tm {
 	uint8_t rsvd1[2];
 	uint8_t hlength;
 	uint8_t dlength[3];
-	uint8_t lun[8];
+	struct scsi_lun lun;
 	itt_t	 itt;	/* Initiator Task Tag */
 	itt_t	 rtt;	/* Reference Task Tag */
 	__be32	cmdsn;
@@ -315,7 +315,7 @@ struct iscsi_r2t_rsp {
 	uint8_t rsvd2[2];
 	uint8_t	hlength;
 	uint8_t	dlength[3];
-	uint8_t lun[8];
+	struct scsi_lun	lun;
 	itt_t	 itt;	/* Initiator Task Tag */
 	__be32	ttt;	/* Target Transfer Tag */
 	__be32	statsn;
@@ -333,7 +333,7 @@ struct iscsi_data {
 	uint8_t rsvd2[2];
 	uint8_t rsvd3;
 	uint8_t dlength[3];
-	uint8_t lun[8];
+	struct scsi_lun lun;
 	itt_t	 itt;
 	__be32	ttt;
 	__be32	rsvd4;
@@ -353,7 +353,7 @@ struct iscsi_data_rsp {
 	uint8_t cmd_status;
 	uint8_t hlength;
 	uint8_t dlength[3];
-	uint8_t lun[8];
+	struct scsi_lun	lun;
 	itt_t	 itt;
 	__be32	ttt;
 	__be32	statsn;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 0f43677..cedcff3 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -115,7 +115,7 @@ struct iscsi_task {
 	/* copied values in case we need to send tmfs */
 	itt_t			hdr_itt;
 	__be32			cmdsn;
-	uint8_t			lun[8];
+	struct scsi_lun		lun;
 
 	int			itt;		/* this ITT */
 
-- 
1.7.1

