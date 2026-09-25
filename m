Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50B04D0CFA
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361083; cv=none; b=Ye4OWZFCFN56MD8hiRdhJHfuONcflmgm1oWx/QRsq0c48Kh2CFsEueOTM4KKXRoj2E+KMq704J/Wa9urvwMdvZLAWWfjLinU1jRgoQzyiGqpkkIc5eGWAP8g4fU55sXK2bwIcDY/EHxeIGPkJY3NVGWXghClt6RStE9IrPUhwEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361083; c=relaxed/simple;
	bh=0W+mgjxwchIzuOtxAWWzL+i917Ff8oR1SinjDt4JLMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nv65ShEdYzoNosrH1VE59UrbQxtE94kQ3eqVPTSk+8YiGsz9fvhEb8gvOV65WSGneZIMoswF6Jc+eNiH/h0iojQ16cp54m7xodLRfn1cXB9hObeQ83FbkG2Rd/wnfMmm1mSKeeg1++8XCILPwMNXnECoM4NwETdn8trukHRognI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=guDyj+5n; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="guDyj+5n"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzmm4Mtfz1XM30k;
	Fri, 25 Sep 2026 18:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790360985; x=1792952986; bh=BzpmT
	QYrpB3/fREalEFJ3x7gRg/TRay8vtgHEa7Q92Q=; b=guDyj+5nqBxPJNlQS0YRg
	N54Jh156p+dmp8vwq4joNwtwuEog9hbR5G0ggqoq2+zzV4j+nCm2NGxExAJGYv+e
	Sv8Jp+mTJxE+zNI++H2Juw0B/Y2yqdjBlQIO3/ttgLAn0w3xj5FfQE5IFzX8+coN
	ysb4SIjqUhNlVoj2dWvWNpCb5ds1NvvJGV1LzwXf4UYJtxwfaoficmnjX0Pe6150
	WE1QlsYcDeMe/TM9zCkXQgZJuD7bcWol3Lde8f6Sj+DEfSHxSuI6XhN2nNuZAkS1
	k0vMfVsU4n6nY22n1ZOV29LjhruWQPfT9gu2uF8pFVvRkTFqshSOhs7jkbXfgfMu
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Hmp79uSnu0M9; Fri, 25 Sep 2026 18:29:45 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzkq2P44z1XM4Sx;
	Fri, 25 Sep 2026 18:29:38 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Kees Cook <kees@kernel.org>
Subject: [PATCH v4 12/54] scsi: libiscsi: Pass the session pointer directly to several functions
Date: Fri, 25 Sep 2026 11:25:50 -0700
Message-ID: <f717adbc1d64a4ddb457d4878d704999922bf1d0.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Pass the struct iscsi_session pointer directly to all functions that must
be called with an iscsi_session synchronization object held.

Update the callers of the modified functions in the iSER, be2iscsi, bnx2i=
,
cxgbi, libiscsi, qedi and qla4xxx drivers.

This patch prepares for enabling compile-time lock context analysis in
libiscsi.  No functionality has been changed.

Cc: Lee Duncan <lduncan@suse.com>
Cc: Chris Leech <cleech@redhat.com>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/iser/iser_initiator.c |   3 +-
 drivers/scsi/be2iscsi/be_main.c              |  13 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c               |  40 ++--
 drivers/scsi/cxgbi/libcxgbi.c                |   8 +-
 drivers/scsi/libiscsi.c                      | 237 ++++++++++---------
 drivers/scsi/libiscsi_tcp.c                  |  17 +-
 drivers/scsi/qedi/qedi_fw.c                  |  34 +--
 drivers/scsi/qla4xxx/ql4_isr.c               |   8 +-
 include/scsi/libiscsi.h                      |  16 +-
 9 files changed, 204 insertions(+), 172 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infin=
iband/ulp/iser/iser_initiator.c
index 12a2d12fef07..d8e732425e77 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -604,7 +604,8 @@ static int iser_check_remote_inv(struct iser_conn *is=
er_conn, struct ib_wc *wc,
 			return -EPROTO;
 		}
=20
-		task =3D iscsi_itt_to_ctask(iser_conn->iscsi_conn, hdr->itt);
+		task =3D iscsi_itt_to_ctask(iser_conn->iscsi_conn->session,
+					  iser_conn->iscsi_conn, hdr->itt);
 		if (likely(task)) {
 			struct iscsi_iser_task *iser_task =3D task->dd_data;
 			struct iser_fr_desc *desc;
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_m=
ain.c
index fd18d4d3d219..c8ee0473a1dd 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1178,7 +1178,7 @@ be_complete_io(struct beiscsi_conn *beiscsi_conn,
 		scsi_dma_unmap(io_task->scsi_cmnd);
 		io_task->scsi_cmnd =3D NULL;
 	}
-	iscsi_complete_scsi_task(task, exp_cmdsn, max_cmdsn);
+	iscsi_complete_scsi_task(conn->session, task, exp_cmdsn, max_cmdsn);
 }
=20
 static void
@@ -1205,7 +1205,7 @@ be_complete_logout(struct beiscsi_conn *beiscsi_con=
n,
 	hdr->dlength[2] =3D 0;
 	hdr->hlength =3D 0;
 	hdr->itt =3D io_task->libiscsi_itt;
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
+	__iscsi_complete_pdu(conn->session, conn, (struct iscsi_hdr *)hdr, NULL=
, 0);
 }
=20
 static void
@@ -1226,7 +1226,7 @@ be_complete_tmf(struct beiscsi_conn *beiscsi_conn,
 				     csol_cqe->cmd_wnd - 1);
=20
 	hdr->itt =3D io_task->libiscsi_itt;
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
+	__iscsi_complete_pdu(conn->session, conn, (struct iscsi_hdr *)hdr, NULL=
, 0);
 }
=20
 static void
@@ -1260,7 +1260,7 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi=
_conn,
 	spin_lock_bh(&session->back_lock);
 	task =3D pwrb_handle->pio_handle;
 	if (task)
-		__iscsi_put_task(task);
+		__iscsi_put_task(session, task);
 	spin_unlock_bh(&session->back_lock);
 }
=20
@@ -1281,7 +1281,7 @@ be_complete_nopin_resp(struct beiscsi_conn *beiscsi=
_conn,
=20
 	hdr->opcode =3D ISCSI_OP_NOOP_IN;
 	hdr->itt =3D io_task->libiscsi_itt;
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
+	__iscsi_complete_pdu(conn->session, conn, (struct iscsi_hdr *)hdr, NULL=
, 0);
 }
=20
 static void adapter_get_sol_cqe(struct beiscsi_hba *phba,
@@ -1460,7 +1460,8 @@ beiscsi_complete_pdu(struct beiscsi_conn *beiscsi_c=
onn,
 			    code);
 		return 1;
 	}
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)phdr, pdata, dlen);
+	__iscsi_complete_pdu(conn->session, conn, (struct iscsi_hdr *)phdr, pda=
ta,
+			     dlen);
 	return 0;
 }
=20
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hw=
i.c
index d24cc2c795d6..4d4eca23d471 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -383,6 +383,7 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_con=
n,
 			 struct iscsi_task *mtask)
 {
 	struct iscsi_conn *conn =3D bnx2i_conn->cls_conn->dd_data;
+	struct iscsi_session *session =3D conn->session;
 	struct iscsi_tm *tmfabort_hdr;
 	struct scsi_cmnd *ref_sc;
 	struct iscsi_task *ctask;
@@ -404,7 +405,7 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_con=
n,
 	switch (tmfabort_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) {
 	case ISCSI_TM_FUNC_ABORT_TASK:
 	case ISCSI_TM_FUNC_TASK_REASSIGN:
-		ctask =3D iscsi_itt_to_task(conn, tmfabort_hdr->rtt);
+		ctask =3D iscsi_itt_to_task(session, conn, tmfabort_hdr->rtt);
 		if (!ctask || !ctask->sc)
 			/*
 			 * the iscsi layer must have completed the cmd while
@@ -1347,7 +1348,7 @@ int bnx2i_process_scsi_cmd_resp(struct iscsi_sessio=
n *session,
=20
 	resp_cqe =3D (struct bnx2i_cmd_response *)cqe;
 	spin_lock_bh(&session->back_lock);
-	task =3D iscsi_itt_to_task(conn,
+	task =3D iscsi_itt_to_task(session, conn,
 				 resp_cqe->itt & ISCSI_CMD_RESPONSE_INDEX);
 	if (!task)
 		goto fail;
@@ -1414,7 +1415,7 @@ int bnx2i_process_scsi_cmd_resp(struct iscsi_sessio=
n *session,
 	}
=20
 done:
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr,
+	__iscsi_complete_pdu(session, conn, (struct iscsi_hdr *)hdr,
 			     conn->data, datalen);
 fail:
 	spin_unlock_bh(&session->back_lock);
@@ -1443,7 +1444,7 @@ static int bnx2i_process_login_resp(struct iscsi_se=
ssion *session,
=20
 	login =3D (struct bnx2i_login_response *) cqe;
 	spin_lock(&session->back_lock);
-	task =3D iscsi_itt_to_task(conn,
+	task =3D iscsi_itt_to_task(session, conn,
 				 login->itt & ISCSI_LOGIN_RESPONSE_INDEX);
 	if (!task)
 		goto done;
@@ -1481,7 +1482,7 @@ static int bnx2i_process_login_resp(struct iscsi_se=
ssion *session,
 		}
 	}
=20
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr,
+	__iscsi_complete_pdu(session, conn, (struct iscsi_hdr *)resp_hdr,
 		bnx2i_conn->gen_pdu.resp_buf,
 		bnx2i_conn->gen_pdu.resp_wr_ptr - bnx2i_conn->gen_pdu.resp_buf);
 done:
@@ -1511,7 +1512,8 @@ static int bnx2i_process_text_resp(struct iscsi_ses=
sion *session,
=20
 	text =3D (struct bnx2i_text_response *) cqe;
 	spin_lock(&session->back_lock);
-	task =3D iscsi_itt_to_task(conn, text->itt & ISCSI_LOGIN_RESPONSE_INDEX=
);
+	task =3D iscsi_itt_to_task(session, conn,
+				 text->itt & ISCSI_LOGIN_RESPONSE_INDEX);
 	if (!task)
 		goto done;
=20
@@ -1541,7 +1543,7 @@ static int bnx2i_process_text_resp(struct iscsi_ses=
sion *session,
 			bnx2i_conn->gen_pdu.resp_wr_ptr++;
 		}
 	}
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr,
+	__iscsi_complete_pdu(session, conn, (struct iscsi_hdr *)resp_hdr,
 			     bnx2i_conn->gen_pdu.resp_buf,
 			     bnx2i_conn->gen_pdu.resp_wr_ptr -
 			     bnx2i_conn->gen_pdu.resp_buf);
@@ -1570,7 +1572,7 @@ static int bnx2i_process_tmf_resp(struct iscsi_sess=
ion *session,
=20
 	tmf_cqe =3D (struct bnx2i_tmf_response *)cqe;
 	spin_lock(&session->back_lock);
-	task =3D iscsi_itt_to_task(conn,
+	task =3D iscsi_itt_to_task(session, conn,
 				 tmf_cqe->itt & ISCSI_TMF_RESPONSE_INDEX);
 	if (!task)
 		goto done;
@@ -1583,7 +1585,7 @@ static int bnx2i_process_tmf_resp(struct iscsi_sess=
ion *session,
 	resp_hdr->itt =3D task->hdr->itt;
 	resp_hdr->response =3D tmf_cqe->response;
=20
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, NULL, 0);
+	__iscsi_complete_pdu(session, conn, (struct iscsi_hdr *)resp_hdr, NULL,=
 0);
 done:
 	spin_unlock(&session->back_lock);
 	return 0;
@@ -1609,7 +1611,7 @@ static int bnx2i_process_logout_resp(struct iscsi_s=
ession *session,
=20
 	logout =3D (struct bnx2i_logout_response *) cqe;
 	spin_lock(&session->back_lock);
-	task =3D iscsi_itt_to_task(conn,
+	task =3D iscsi_itt_to_task(session, conn,
 				 logout->itt & ISCSI_LOGOUT_RESPONSE_INDEX);
 	if (!task)
 		goto done;
@@ -1628,7 +1630,7 @@ static int bnx2i_process_logout_resp(struct iscsi_s=
ession *session,
 	resp_hdr->t2wait =3D cpu_to_be32(logout->time_to_wait);
 	resp_hdr->t2retain =3D cpu_to_be32(logout->time_to_retain);
=20
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, NULL, 0);
+	__iscsi_complete_pdu(session, conn, (struct iscsi_hdr *)resp_hdr, NULL,=
 0);
=20
 	bnx2i_conn->ep->state =3D EP_STATE_LOGOUT_RESP_RCVD;
 done:
@@ -1654,10 +1656,10 @@ static void bnx2i_process_nopin_local_cmpl(struct=
 iscsi_session *session,
=20
 	nop_in =3D (struct bnx2i_nop_in_msg *)cqe;
 	spin_lock(&session->back_lock);
-	task =3D iscsi_itt_to_task(conn,
+	task =3D iscsi_itt_to_task(session, conn,
 				 nop_in->itt & ISCSI_NOP_IN_MSG_INDEX);
 	if (task)
-		__iscsi_put_task(task);
+		__iscsi_put_task(session, task);
 	spin_unlock(&session->back_lock);
 }
=20
@@ -1713,7 +1715,7 @@ static int bnx2i_process_nopin_mesg(struct iscsi_se=
ssion *session,
 	}
=20
 	/* this is a response to one of our nop-outs */
-	task =3D iscsi_itt_to_task(conn,
+	task =3D iscsi_itt_to_task(session, conn,
 			 (itt_t) (nop_in->itt & ISCSI_NOP_IN_MSG_INDEX));
 	if (task) {
 		hdr->flags =3D ISCSI_FLAG_CMD_FINAL;
@@ -1722,7 +1724,7 @@ static int bnx2i_process_nopin_mesg(struct iscsi_se=
ssion *session,
 		memcpy(&hdr->lun, nop_in->lun, 8);
 	}
 done:
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
+	__iscsi_complete_pdu(session, conn, (struct iscsi_hdr *)hdr, NULL, 0);
 	spin_unlock(&session->back_lock);
=20
 	return tgt_async_nop;
@@ -1773,7 +1775,7 @@ static void bnx2i_process_async_mesg(struct iscsi_s=
ession *session,
 	resp_hdr->param2 =3D cpu_to_be16(async_cqe->param2);
 	resp_hdr->param3 =3D cpu_to_be16(async_cqe->param3);
=20
-	__iscsi_complete_pdu(bnx2i_conn->cls_conn->dd_data,
+	__iscsi_complete_pdu(session, bnx2i_conn->cls_conn->dd_data,
 			     (struct iscsi_hdr *)resp_hdr, NULL, 0);
 	spin_unlock(&session->back_lock);
 }
@@ -1811,7 +1813,7 @@ static void bnx2i_process_reject_mesg(struct iscsi_=
session *session,
 	hdr->max_cmdsn =3D cpu_to_be32(reject->max_cmd_sn);
 	hdr->exp_cmdsn =3D cpu_to_be32(reject->exp_cmd_sn);
 	hdr->ffffffff =3D cpu_to_be32(RESERVED_ITT);
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, conn->data,
+	__iscsi_complete_pdu(session, conn, (struct iscsi_hdr *)hdr, conn->data=
,
 			     reject->data_length);
 	spin_unlock(&session->back_lock);
 }
@@ -1834,7 +1836,7 @@ static void bnx2i_process_cmd_cleanup_resp(struct i=
scsi_session *session,
=20
 	cmd_clean_rsp =3D (struct bnx2i_cleanup_response *)cqe;
 	spin_lock(&session->back_lock);
-	task =3D iscsi_itt_to_task(conn,
+	task =3D iscsi_itt_to_task(session, conn,
 			cmd_clean_rsp->itt & ISCSI_CLEANUP_RESPONSE_INDEX);
 	if (!task)
 		printk(KERN_ALERT "bnx2i: cmd clean ITT %x not active\n",
@@ -1908,7 +1910,7 @@ static int bnx2i_queue_scsi_cmd_resp(struct iscsi_s=
ession *session,
 	int rc =3D 0;
=20
 	spin_lock(&session->back_lock);
-	task =3D iscsi_itt_to_task(bnx2i_conn->cls_conn->dd_data,
+	task =3D iscsi_itt_to_task(session, bnx2i_conn->cls_conn->dd_data,
 				 cqe->itt & ISCSI_CMD_RESPONSE_INDEX);
 	if (!task || !task->sc) {
 		spin_unlock(&session->back_lock);
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.=
c
index ea9631bfe2e2..d73a6578b461 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1537,9 +1537,11 @@ skb_read_pdu_bhs(struct cxgbi_sock *csk, struct is=
csi_conn *conn,
 		 * for the last pdu of a sequence.
 		 */
 		itt_t itt =3D ((struct iscsi_data *)skb->data)->itt;
-		struct iscsi_task *task =3D iscsi_itt_to_ctask(conn, itt);
-		u32 data_sn =3D be32_to_cpu(((struct iscsi_data *)
-							skb->data)->datasn);
+		struct iscsi_task *task;
+		u32 data_sn;
+
+		task =3D iscsi_itt_to_ctask(conn->session, conn, itt);
+		data_sn =3D be32_to_cpu(((struct iscsi_data *)skb->data)->datasn);
 		if (task && task->sc) {
 			struct iscsi_tcp_task *tcp_task =3D task->dd_data;
=20
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 7637aacd6037..179de08ca515 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -445,16 +445,17 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_tas=
k *task)
=20
 /**
  * iscsi_free_task - free a task
+ * @session: iscsi session
  * @task: iscsi cmd task
  *
  * Must be called with session back_lock.
  * This function returns the scsi command to scsi-ml or cleans
  * up mgmt tasks then returns the task to the pool.
  */
-static void iscsi_free_task(struct iscsi_task *task)
+static void iscsi_free_task(struct iscsi_session *session,
+			    struct iscsi_task *task)
 {
 	struct iscsi_conn *conn =3D task->conn;
-	struct iscsi_session *session =3D conn->session;
 	struct scsi_cmnd *sc =3D task->sc;
 	int oldstate =3D task->state;
=20
@@ -492,14 +493,15 @@ EXPORT_SYMBOL_GPL(iscsi_get_task);
=20
 /**
  * __iscsi_put_task - drop the refcount on a task
+ * @session: iscsi session
  * @task: iscsi_task to drop the refcount on
  *
  * The back_lock must be held when calling in case it frees the task.
  */
-void __iscsi_put_task(struct iscsi_task *task)
+void __iscsi_put_task(struct iscsi_session *session, struct iscsi_task *=
task)
 {
 	if (refcount_dec_and_test(&task->refcount))
-		iscsi_free_task(task);
+		iscsi_free_task(session, task);
 }
 EXPORT_SYMBOL_GPL(__iscsi_put_task);
=20
@@ -509,7 +511,7 @@ void iscsi_put_task(struct iscsi_task *task)
=20
 	if (refcount_dec_and_test(&task->refcount)) {
 		spin_lock_bh(&session->back_lock);
-		iscsi_free_task(task);
+		iscsi_free_task(session, task);
 		spin_unlock_bh(&session->back_lock);
 	}
 }
@@ -517,17 +519,18 @@ EXPORT_SYMBOL_GPL(iscsi_put_task);
=20
 /**
  * iscsi_complete_task - finish a task
+ * @session: iscsi session
  * @task: iscsi cmd task
  * @state: state to complete task with
  *
  * Must be called with session back_lock.
  */
-static void iscsi_complete_task(struct iscsi_task *task, int state)
+static void iscsi_complete_task(struct iscsi_session *session,
+				struct iscsi_task *task, int state)
 {
 	struct iscsi_conn *conn =3D task->conn;
=20
-	ISCSI_DBG_SESSION(conn->session,
-			  "complete task itt 0x%x state %d sc %p\n",
+	ISCSI_DBG_SESSION(session, "complete task itt 0x%x state %d sc %p\n",
 			  task->itt, task->state, task->sc);
 	if (task->state =3D=3D ISCSI_TASK_COMPLETED ||
 	    task->state =3D=3D ISCSI_TASK_ABRT_TMF ||
@@ -541,11 +544,12 @@ static void iscsi_complete_task(struct iscsi_task *=
task, int state)
 		WRITE_ONCE(conn->ping_task, NULL);
=20
 	/* release get from queueing */
-	__iscsi_put_task(task);
+	__iscsi_put_task(session, task);
 }
=20
 /**
  * iscsi_complete_scsi_task - finish scsi task normally
+ * @session: iscsi session
  * @task: iscsi task for scsi cmd
  * @exp_cmdsn: expected cmd sn in cpu format
  * @max_cmdsn: max cmd sn in cpu format
@@ -555,23 +559,25 @@ static void iscsi_complete_task(struct iscsi_task *=
task, int state)
  *
  * Called with session back_lock
  */
-void iscsi_complete_scsi_task(struct iscsi_task *task,
+void iscsi_complete_scsi_task(struct iscsi_session *session,
+			      struct iscsi_task *task,
 			      uint32_t exp_cmdsn, uint32_t max_cmdsn)
 {
 	struct iscsi_conn *conn =3D task->conn;
=20
-	ISCSI_DBG_SESSION(conn->session, "[itt 0x%x]\n", task->itt);
+	ISCSI_DBG_SESSION(session, "[itt 0x%x]\n", task->itt);
=20
 	conn->last_recv =3D jiffies;
-	__iscsi_update_cmdsn(conn->session, exp_cmdsn, max_cmdsn);
-	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+	__iscsi_update_cmdsn(session, exp_cmdsn, max_cmdsn);
+	iscsi_complete_task(session, task, ISCSI_TASK_COMPLETED);
 }
 EXPORT_SYMBOL_GPL(iscsi_complete_scsi_task);
=20
 /*
  * Must be called with back and frwd lock
  */
-static bool cleanup_queued_task(struct iscsi_task *task)
+static bool cleanup_queued_task(struct iscsi_session *session,
+				struct iscsi_task *task)
 {
 	struct iscsi_conn *conn =3D task->conn;
 	bool early_complete =3D false;
@@ -592,17 +598,17 @@ static bool cleanup_queued_task(struct iscsi_task *=
task)
 		 */
 		if (task->state =3D=3D ISCSI_TASK_RUNNING ||
 		    task->state =3D=3D ISCSI_TASK_COMPLETED)
-			__iscsi_put_task(task);
+			__iscsi_put_task(session, task);
 	}
=20
-	if (conn->session->running_aborted_task =3D=3D task) {
-		conn->session->running_aborted_task =3D NULL;
-		__iscsi_put_task(task);
+	if (session->running_aborted_task =3D=3D task) {
+		session->running_aborted_task =3D NULL;
+		__iscsi_put_task(session, task);
 	}
=20
 	if (conn->task =3D=3D task) {
 		conn->task =3D NULL;
-		__iscsi_put_task(task);
+		__iscsi_put_task(session, task);
 	}
=20
 	return early_complete;
@@ -612,13 +618,13 @@ static bool cleanup_queued_task(struct iscsi_task *=
task)
  * session back and frwd lock must be held and if not called for a task =
that
  * is still pending or from the xmit thread, then xmit thread must be su=
spended
  */
-static void __fail_scsi_task(struct iscsi_task *task, int err)
+static void __fail_scsi_task(struct iscsi_session *session,
+			     struct iscsi_task *task, int err)
 {
-	struct iscsi_conn *conn =3D task->conn;
 	struct scsi_cmnd *sc;
 	int state;
=20
-	if (cleanup_queued_task(task))
+	if (cleanup_queued_task(session, task))
 		return;
=20
 	if (task->state =3D=3D ISCSI_TASK_PENDING) {
@@ -626,7 +632,7 @@ static void __fail_scsi_task(struct iscsi_task *task,=
 int err)
 		 * cmd never made it to the xmit thread, so we should not count
 		 * the cmd in the sequencing
 		 */
-		conn->session->queued_cmdsn--;
+		session->queued_cmdsn--;
 		/* it was never sent so just complete like normal */
 		state =3D ISCSI_TASK_COMPLETED;
 	} else if (err =3D=3D DID_TRANSPORT_DISRUPTED)
@@ -637,15 +643,14 @@ static void __fail_scsi_task(struct iscsi_task *tas=
k, int err)
 	sc =3D task->sc;
 	sc->result =3D err << 16;
 	scsi_set_resid(sc, scsi_bufflen(sc));
-	iscsi_complete_task(task, state);
+	iscsi_complete_task(session, task, state);
 }
=20
-static void fail_scsi_task(struct iscsi_task *task, int err)
+static void fail_scsi_task(struct iscsi_session *session,
+			   struct iscsi_task *task, int err)
 {
-	struct iscsi_session *session =3D task->conn->session;
-
 	spin_lock_bh(&session->back_lock);
-	__fail_scsi_task(task, err);
+	__fail_scsi_task(session, task, err);
 	spin_unlock_bh(&session->back_lock);
 }
=20
@@ -857,6 +862,7 @@ EXPORT_SYMBOL_GPL(iscsi_conn_send_pdu);
=20
 /**
  * iscsi_scsi_cmd_rsp - SCSI Command Response processing
+ * @session: iscsi session
  * @conn: iscsi connection
  * @hdr: iscsi header
  * @task: scsi command task
@@ -866,12 +872,12 @@ EXPORT_SYMBOL_GPL(iscsi_conn_send_pdu);
  * iscsi_cmd_rsp sets up the scsi_cmnd fields based on the PDU and
  * then completes the command and task. called under back_lock
  **/
-static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr=
 *hdr,
+static void iscsi_scsi_cmd_rsp(struct iscsi_session *session,
+			       struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			       struct iscsi_task *task, char *data,
 			       int datalen)
 {
 	struct iscsi_scsi_rsp *rhdr =3D (struct iscsi_scsi_rsp *)hdr;
-	struct iscsi_session *session =3D conn->session;
 	struct scsi_cmnd *sc =3D task->sc;
=20
 	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
@@ -950,11 +956,12 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *c=
onn, struct iscsi_hdr *hdr,
 	ISCSI_DBG_SESSION(session, "cmd rsp done [sc %p res %d itt 0x%x]\n",
 			  sc, sc->result, task->itt);
 	conn->scsirsp_pdus_cnt++;
-	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+	iscsi_complete_task(session, task, ISCSI_TASK_COMPLETED);
 }
=20
 /**
  * iscsi_data_in_rsp - SCSI Data-In Response processing
+ * @session: iscsi session
  * @conn: iscsi connection
  * @hdr:  iscsi pdu
  * @task: scsi command task
@@ -963,8 +970,8 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *con=
n, struct iscsi_hdr *hdr,
  * then completes the command and task. called under back_lock
  **/
 static void
-iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
-		  struct iscsi_task *task)
+iscsi_data_in_rsp(struct iscsi_session *session, struct iscsi_conn *conn=
,
+		  struct iscsi_hdr *hdr, struct iscsi_task *task)
 {
 	struct iscsi_data_rsp *rhdr =3D (struct iscsi_data_rsp *)hdr;
 	struct scsi_cmnd *sc =3D task->sc;
@@ -972,7 +979,7 @@ iscsi_data_in_rsp(struct iscsi_conn *conn, struct isc=
si_hdr *hdr,
 	if (!(rhdr->flags & ISCSI_FLAG_DATA_STATUS))
 		return;
=20
-	iscsi_update_cmdsn(conn->session, (struct iscsi_nopin *)hdr);
+	iscsi_update_cmdsn(session, (struct iscsi_nopin *)hdr);
 	sc->result =3D (DID_OK << 16) | rhdr->cmd_status;
 	conn->exp_statsn =3D be32_to_cpu(rhdr->statsn) + 1;
 	if (rhdr->flags & (ISCSI_FLAG_DATA_UNDERFLOW |
@@ -987,11 +994,11 @@ iscsi_data_in_rsp(struct iscsi_conn *conn, struct i=
scsi_hdr *hdr,
 			sc->result =3D (DID_BAD_TARGET << 16) | rhdr->cmd_status;
 	}
=20
-	ISCSI_DBG_SESSION(conn->session, "data in with status done "
+	ISCSI_DBG_SESSION(session, "data in with status done "
 			  "[sc %p res %d itt 0x%x]\n",
 			  sc, sc->result, task->itt);
 	conn->scsirsp_pdus_cnt++;
-	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+	iscsi_complete_task(session, task, ISCSI_TASK_COMPLETED);
 }
=20
 static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr=
)
@@ -1059,6 +1066,7 @@ static int iscsi_send_nopout(struct iscsi_conn *con=
n, struct iscsi_nopin *rhdr)
=20
 /**
  * iscsi_nop_out_rsp - SCSI NOP Response processing
+ * @session: iscsi session
  * @task: scsi command task
  * @nop: the nop structure
  * @data: where to put the data
@@ -1067,7 +1075,8 @@ static int iscsi_send_nopout(struct iscsi_conn *con=
n, struct iscsi_nopin *rhdr)
  * iscsi_nop_out_rsp handles nop response from use or
  * from user space. called under back_lock
  **/
-static int iscsi_nop_out_rsp(struct iscsi_task *task,
+static int iscsi_nop_out_rsp(struct iscsi_session *session,
+			     struct iscsi_task *task,
 			     struct iscsi_nopin *nop, char *data, int datalen)
 {
 	struct iscsi_conn *conn =3D task->conn;
@@ -1083,11 +1092,12 @@ static int iscsi_nop_out_rsp(struct iscsi_task *t=
ask,
 			rc =3D ISCSI_ERR_CONN_FAILED;
 	} else
 		mod_timer(&conn->transport_timer, jiffies + conn->recv_timeout);
-	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+	iscsi_complete_task(session, task, ISCSI_TASK_COMPLETED);
 	return rc;
 }
=20
-static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr=
 *hdr,
+static int iscsi_handle_reject(struct iscsi_session *session,
+			       struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			       char *data, int datalen)
 {
 	struct iscsi_reject *reject =3D (struct iscsi_reject *)hdr;
@@ -1136,26 +1146,27 @@ static int iscsi_handle_reject(struct iscsi_conn =
*conn, struct iscsi_hdr *hdr,
 			 * Just resend.
 			 */
 			/* In RX path we are under back lock */
-			spin_unlock(&conn->session->back_lock);
-			spin_lock(&conn->session->frwd_lock);
+			spin_unlock(&session->back_lock);
+			spin_lock(&session->frwd_lock);
 			iscsi_send_nopout(conn,
 					  (struct iscsi_nopin*)&rejected_pdu);
-			spin_unlock(&conn->session->frwd_lock);
-			spin_lock(&conn->session->back_lock);
+			spin_unlock(&session->frwd_lock);
+			spin_lock(&session->back_lock);
 		} else {
 			struct iscsi_task *task;
 			/*
 			 * Our nop as ping got dropped. We know the target
 			 * and transport are ok so just clean up
 			 */
-			task =3D iscsi_itt_to_task(conn, rejected_pdu.itt);
+			task =3D iscsi_itt_to_task(session, conn,
+						 rejected_pdu.itt);
 			if (!task) {
 				iscsi_conn_printk(KERN_ERR, conn,
 						 "Invalid pdu reject. Could "
 						 "not lookup rejected task.\n");
 				rc =3D ISCSI_ERR_BAD_ITT;
 			} else
-				rc =3D iscsi_nop_out_rsp(task,
+				rc =3D iscsi_nop_out_rsp(session, task,
 					(struct iscsi_nopin*)&rejected_pdu,
 					NULL, 0);
 		}
@@ -1172,6 +1183,7 @@ static int iscsi_handle_reject(struct iscsi_conn *c=
onn, struct iscsi_hdr *hdr,
=20
 /**
  * iscsi_itt_to_task - look up task by itt
+ * @session: iscsi session
  * @conn: iscsi connection
  * @itt: itt
  *
@@ -1180,9 +1192,9 @@ static int iscsi_handle_reject(struct iscsi_conn *c=
onn, struct iscsi_hdr *hdr,
  *
  * The session back_lock must be held.
  */
-struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *conn, itt_t itt)
+struct iscsi_task *iscsi_itt_to_task(struct iscsi_session *session,
+				     struct iscsi_conn *conn, itt_t itt)
 {
-	struct iscsi_session *session =3D conn->session;
 	int i;
=20
 	if (itt =3D=3D RESERVED_ITT)
@@ -1201,6 +1213,7 @@ EXPORT_SYMBOL_GPL(iscsi_itt_to_task);
=20
 /**
  * __iscsi_complete_pdu - complete pdu
+ * @session: iscsi session
  * @conn: iscsi conn
  * @hdr: iscsi header
  * @data: data buffer
@@ -1210,10 +1223,9 @@ EXPORT_SYMBOL_GPL(iscsi_itt_to_task);
  * queuecommand or send generic. session back_lock must be held and veri=
fy
  * itt must have been called.
  */
-int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
-			 char *data, int datalen)
+int __iscsi_complete_pdu(struct iscsi_session *session, struct iscsi_con=
n *conn,
+			 struct iscsi_hdr *hdr, char *data, int datalen)
 {
-	struct iscsi_session *session =3D conn->session;
 	int opcode =3D hdr->opcode & ISCSI_OPCODE_MASK, rc =3D 0;
 	struct iscsi_task *task;
 	uint32_t itt;
@@ -1252,7 +1264,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, s=
truct iscsi_hdr *hdr,
 			spin_lock(&session->back_lock);
 			break;
 		case ISCSI_OP_REJECT:
-			rc =3D iscsi_handle_reject(conn, hdr, data, datalen);
+			rc =3D iscsi_handle_reject(session, conn, hdr, data, datalen);
 			break;
 		case ISCSI_OP_ASYNC_EVENT:
 			conn->exp_statsn =3D be32_to_cpu(hdr->statsn) + 1;
@@ -1269,7 +1281,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, s=
truct iscsi_hdr *hdr,
 	switch(opcode) {
 	case ISCSI_OP_SCSI_CMD_RSP:
 	case ISCSI_OP_SCSI_DATA_IN:
-		task =3D iscsi_itt_to_ctask(conn, hdr->itt);
+		task =3D iscsi_itt_to_ctask(session, conn, hdr->itt);
 		if (!task)
 			return ISCSI_ERR_BAD_ITT;
 		task->last_xfer =3D jiffies;
@@ -1284,7 +1296,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, s=
truct iscsi_hdr *hdr,
 	case ISCSI_OP_TEXT_RSP:
 	case ISCSI_OP_SCSI_TMFUNC_RSP:
 	case ISCSI_OP_NOOP_IN:
-		task =3D iscsi_itt_to_task(conn, hdr->itt);
+		task =3D iscsi_itt_to_task(session, conn, hdr->itt);
 		if (!task)
 			return ISCSI_ERR_BAD_ITT;
 		break;
@@ -1294,10 +1306,10 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn,=
 struct iscsi_hdr *hdr,
=20
 	switch(opcode) {
 	case ISCSI_OP_SCSI_CMD_RSP:
-		iscsi_scsi_cmd_rsp(conn, hdr, task, data, datalen);
+		iscsi_scsi_cmd_rsp(session, conn, hdr, task, data, datalen);
 		break;
 	case ISCSI_OP_SCSI_DATA_IN:
-		iscsi_data_in_rsp(conn, hdr, task);
+		iscsi_data_in_rsp(session, conn, hdr, task);
 		break;
 	case ISCSI_OP_LOGOUT_RSP:
 		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
@@ -1323,7 +1335,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, s=
truct iscsi_hdr *hdr,
 		}
=20
 		iscsi_tmf_rsp(conn, hdr);
-		iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+		iscsi_complete_task(session, task, ISCSI_TASK_COMPLETED);
 		break;
 	case ISCSI_OP_NOOP_IN:
 		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
@@ -1333,7 +1345,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, s=
truct iscsi_hdr *hdr,
 		}
 		conn->exp_statsn =3D be32_to_cpu(hdr->statsn) + 1;
=20
-		rc =3D iscsi_nop_out_rsp(task, (struct iscsi_nopin*)hdr,
+		rc =3D iscsi_nop_out_rsp(session, task, (struct iscsi_nopin*)hdr,
 				       data, datalen);
 		break;
 	default:
@@ -1346,7 +1358,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, s=
truct iscsi_hdr *hdr,
 recv_pdu:
 	if (iscsi_recv_pdu(conn->cls_conn, hdr, data, datalen))
 		rc =3D ISCSI_ERR_CONN_FAILED;
-	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+	iscsi_complete_task(session, task, ISCSI_TASK_COMPLETED);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(__iscsi_complete_pdu);
@@ -1354,11 +1366,12 @@ EXPORT_SYMBOL_GPL(__iscsi_complete_pdu);
 int iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		       char *data, int datalen)
 {
+	struct iscsi_session *session =3D conn->session;
 	int rc;
=20
-	spin_lock(&conn->session->back_lock);
-	rc =3D __iscsi_complete_pdu(conn, hdr, data, datalen);
-	spin_unlock(&conn->session->back_lock);
+	spin_lock(&session->back_lock);
+	rc =3D __iscsi_complete_pdu(session, conn, hdr, data, datalen);
+	spin_unlock(&session->back_lock);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(iscsi_complete_pdu);
@@ -1397,6 +1410,7 @@ EXPORT_SYMBOL_GPL(iscsi_verify_itt);
=20
 /**
  * iscsi_itt_to_ctask - look up ctask by itt
+ * @session: iscsi session
  * @conn: iscsi connection
  * @itt: itt
  *
@@ -1404,21 +1418,22 @@ EXPORT_SYMBOL_GPL(iscsi_verify_itt);
  *
  * The session back_lock must be held.
  */
-struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *conn, itt_t itt=
)
+struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_session *session,
+				      struct iscsi_conn *conn, itt_t itt)
 {
 	struct iscsi_task *task;
=20
 	if (iscsi_verify_itt(conn, itt))
 		return NULL;
=20
-	task =3D iscsi_itt_to_task(conn, itt);
+	task =3D iscsi_itt_to_task(session, conn, itt);
 	if (!task || !task->sc)
 		return NULL;
=20
-	if (iscsi_cmd(task->sc)->age !=3D conn->session->age) {
-		iscsi_session_printk(KERN_ERR, conn->session,
+	if (iscsi_cmd(task->sc)->age !=3D session->age) {
+		iscsi_session_printk(KERN_ERR, session,
 				  "task's session age %d, expected %d\n",
-				  iscsi_cmd(task->sc)->age, conn->session->age);
+				  iscsi_cmd(task->sc)->age, session->age);
 		return NULL;
 	}
=20
@@ -1482,10 +1497,9 @@ void iscsi_conn_failure(struct iscsi_conn *conn, e=
num iscsi_err err)
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_failure);
=20
-static int iscsi_check_cmdsn_window_closed(struct iscsi_conn *conn)
+static int iscsi_check_cmdsn_window_closed(struct iscsi_session *session=
,
+					   struct iscsi_conn *conn)
 {
-	struct iscsi_session *session =3D conn->session;
-
 	/*
 	 * Check for iSCSI window and take care of CmdSN wrap-around
 	 */
@@ -1499,8 +1513,8 @@ static int iscsi_check_cmdsn_window_closed(struct i=
scsi_conn *conn)
 	return 0;
 }
=20
-static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *t=
ask,
-			   bool was_requeue)
+static int iscsi_xmit_task(struct iscsi_session *session, struct iscsi_c=
onn *conn,
+			   struct iscsi_task *task, bool was_requeue)
 {
 	int rc;
=20
@@ -1540,9 +1554,9 @@ static int iscsi_xmit_task(struct iscsi_conn *conn,=
 struct iscsi_task *task,
 		return -ENODATA;
 	}
=20
-	spin_unlock_bh(&conn->session->frwd_lock);
-	rc =3D conn->session->tt->xmit_task(task);
-	spin_lock_bh(&conn->session->frwd_lock);
+	spin_unlock_bh(&session->frwd_lock);
+	rc =3D session->tt->xmit_task(task);
+	spin_lock_bh(&session->frwd_lock);
 	if (!rc) {
 		/* done with this task */
 		task->last_xfer =3D jiffies;
@@ -1599,18 +1613,19 @@ EXPORT_SYMBOL_GPL(iscsi_requeue_task);
  **/
 static int iscsi_data_xmit(struct iscsi_conn *conn)
 {
+	struct iscsi_session *session =3D conn->session;
 	struct iscsi_task *task;
 	int rc =3D 0;
=20
-	spin_lock_bh(&conn->session->frwd_lock);
+	spin_lock_bh(&session->frwd_lock);
 	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
-		ISCSI_DBG_SESSION(conn->session, "Tx suspended!\n");
-		spin_unlock_bh(&conn->session->frwd_lock);
+		ISCSI_DBG_SESSION(session, "Tx suspended!\n");
+		spin_unlock_bh(&session->frwd_lock);
 		return -ENODATA;
 	}
=20
 	if (conn->task) {
-		rc =3D iscsi_xmit_task(conn, conn->task, false);
+		rc =3D iscsi_xmit_task(session, conn, conn->task, false);
 	        if (rc)
 		        goto done;
 	}
@@ -1627,12 +1642,12 @@ static int iscsi_data_xmit(struct iscsi_conn *con=
n)
 		list_del_init(&task->running);
 		if (iscsi_prep_mgmt_task(conn, task)) {
 			/* regular RX path uses back_lock */
-			spin_lock_bh(&conn->session->back_lock);
-			__iscsi_put_task(task);
-			spin_unlock_bh(&conn->session->back_lock);
+			spin_lock_bh(&session->back_lock);
+			__iscsi_put_task(session, task);
+			spin_unlock_bh(&session->back_lock);
 			continue;
 		}
-		rc =3D iscsi_xmit_task(conn, task, false);
+		rc =3D iscsi_xmit_task(session, conn, task, false);
 		if (rc)
 			goto done;
 	}
@@ -1642,7 +1657,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 		/*
 		 * we always do fastlogout - conn stop code will clean up.
 		 */
-		if (conn->session->state =3D=3D ISCSI_STATE_LOGGING_OUT)
+		if (session->state =3D=3D ISCSI_STATE_LOGGING_OUT)
 			break;
=20
 		task =3D list_entry(conn->requeue.next, struct iscsi_task,
@@ -1652,7 +1667,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 			break;
=20
 		list_del_init(&task->running);
-		rc =3D iscsi_xmit_task(conn, task, true);
+		rc =3D iscsi_xmit_task(session, conn, task, true);
 		if (rc)
 			goto done;
 		if (!list_empty(&conn->mgmtqueue))
@@ -1664,19 +1679,19 @@ static int iscsi_data_xmit(struct iscsi_conn *con=
n)
 		task =3D list_entry(conn->cmdqueue.next, struct iscsi_task,
 				  running);
 		list_del_init(&task->running);
-		if (conn->session->state =3D=3D ISCSI_STATE_LOGGING_OUT) {
-			fail_scsi_task(task, DID_IMM_RETRY);
+		if (session->state =3D=3D ISCSI_STATE_LOGGING_OUT) {
+			fail_scsi_task(session, task, DID_IMM_RETRY);
 			continue;
 		}
 		rc =3D iscsi_prep_scsi_cmd_pdu(task);
 		if (rc) {
 			if (rc =3D=3D -ENOMEM || rc =3D=3D -EACCES)
-				fail_scsi_task(task, DID_IMM_RETRY);
+				fail_scsi_task(session, task, DID_IMM_RETRY);
 			else
-				fail_scsi_task(task, DID_ABORT);
+				fail_scsi_task(session, task, DID_ABORT);
 			continue;
 		}
-		rc =3D iscsi_xmit_task(conn, task, false);
+		rc =3D iscsi_xmit_task(session, conn, task, false);
 		if (rc)
 			goto done;
 		/*
@@ -1690,11 +1705,11 @@ static int iscsi_data_xmit(struct iscsi_conn *con=
n)
 			goto check_requeue;
 	}
=20
-	spin_unlock_bh(&conn->session->frwd_lock);
+	spin_unlock_bh(&session->frwd_lock);
 	return -ENODATA;
=20
 done:
-	spin_unlock_bh(&conn->session->frwd_lock);
+	spin_unlock_bh(&session->frwd_lock);
 	return rc;
 }
=20
@@ -1828,7 +1843,7 @@ enum scsi_qc_status iscsi_queuecommand(struct Scsi_=
Host *host,
 		goto fault;
 	}
=20
-	if (iscsi_check_cmdsn_window_closed(conn)) {
+	if (iscsi_check_cmdsn_window_closed(session, conn)) {
 		reason =3D FAILURE_WINDOW_CLOSED;
 		goto reject;
 	}
@@ -1866,7 +1881,7 @@ enum scsi_qc_status iscsi_queuecommand(struct Scsi_=
Host *host,
=20
 prepd_reject:
 	spin_lock_bh(&session->back_lock);
-	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
+	iscsi_complete_task(session, task, ISCSI_TASK_REQUEUE_SCSIQ);
 	spin_unlock_bh(&session->back_lock);
 reject:
 	spin_unlock_bh(&session->frwd_lock);
@@ -1876,7 +1891,7 @@ enum scsi_qc_status iscsi_queuecommand(struct Scsi_=
Host *host,
=20
 prepd_fault:
 	spin_lock_bh(&session->back_lock);
-	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
+	iscsi_complete_task(session, task, ISCSI_TASK_REQUEUE_SCSIQ);
 	spin_unlock_bh(&session->back_lock);
 fault:
 	spin_unlock_bh(&session->frwd_lock);
@@ -1913,13 +1928,12 @@ static void iscsi_tmf_timedout(struct timer_list =
*t)
 	spin_unlock(&session->frwd_lock);
 }
=20
-static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
+static int iscsi_exec_task_mgmt_fn(struct iscsi_session *session,
+				   struct iscsi_conn *conn,
 				   struct iscsi_tm *hdr, int age,
 				   int timeout)
 	__must_hold(&session->frwd_lock)
 {
-	struct iscsi_session *session =3D conn->session;
-
 	if (__iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0)) {
 		spin_unlock_bh(&session->frwd_lock);
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send TMF.\n");
@@ -1962,9 +1976,9 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_con=
n *conn,
 /*
  * Fail commands. session frwd lock held and xmit thread flushed.
  */
-static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
+static void fail_scsi_tasks(struct iscsi_session *session, struct iscsi_=
conn *conn,
+			    u64 lun, int error)
 {
-	struct iscsi_session *session =3D conn->session;
 	struct iscsi_task *task;
 	int i;
=20
@@ -1993,8 +2007,8 @@ static void fail_scsi_tasks(struct iscsi_conn *conn=
, u64 lun, int error)
 		ISCSI_DBG_SESSION(session,
 				  "failing sc %p itt 0x%x state %d\n",
 				  task->sc, task->itt, task->state);
-		__fail_scsi_task(task, error);
-		__iscsi_put_task(task);
+		__fail_scsi_task(session, task, error);
+		__iscsi_put_task(session, task);
 	}
 	spin_unlock_bh(&session->back_lock);
 }
@@ -2415,7 +2429,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	spin_unlock(&session->back_lock);
=20
 	if (task->state =3D=3D ISCSI_TASK_PENDING) {
-		fail_scsi_task(task, DID_ABORT);
+		fail_scsi_task(session, task, DID_ABORT);
 		goto success;
 	}
=20
@@ -2427,7 +2441,8 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	hdr =3D &session->tmhdr;
 	iscsi_prep_abort_task_pdu(task, hdr);
=20
-	if (iscsi_exec_task_mgmt_fn(conn, hdr, age, session->abort_timeout))
+	if (iscsi_exec_task_mgmt_fn(session, conn, hdr, age,
+				    session->abort_timeout))
 		goto failed;
=20
 	switch (session->tmf_state) {
@@ -2444,7 +2459,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		 * then sent more data for the cmd.
 		 */
 		spin_lock_bh(&session->frwd_lock);
-		fail_scsi_task(task, DID_ABORT);
+		fail_scsi_task(session, task, DID_ABORT);
 		session->tmf_state =3D TMF_INITIAL;
 		memset(hdr, 0, sizeof(*hdr));
 		spin_unlock_bh(&session->frwd_lock);
@@ -2541,7 +2556,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	hdr =3D &session->tmhdr;
 	iscsi_prep_lun_reset_pdu(sc, hdr);
=20
-	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
+	if (iscsi_exec_task_mgmt_fn(session, conn, hdr, session->age,
 				    session->lu_reset_timeout)) {
 		rc =3D FAILED;
 		goto unlock;
@@ -2566,7 +2581,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
=20
 	spin_lock_bh(&session->frwd_lock);
 	memset(hdr, 0, sizeof(*hdr));
-	fail_scsi_tasks(conn, sc->device->lun, DID_ERROR);
+	fail_scsi_tasks(session, conn, sc->device->lun, DID_ERROR);
 	session->tmf_state =3D TMF_INITIAL;
 	spin_unlock_bh(&session->frwd_lock);
=20
@@ -2703,7 +2718,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *=
sc)
 	hdr =3D &session->tmhdr;
 	iscsi_prep_tgt_reset_pdu(sc, hdr);
=20
-	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
+	if (iscsi_exec_task_mgmt_fn(session, conn, hdr, session->age,
 				    session->tgt_reset_timeout)) {
 		rc =3D FAILED;
 		goto unlock;
@@ -2728,7 +2743,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *=
sc)
=20
 	spin_lock_bh(&session->frwd_lock);
 	memset(hdr, 0, sizeof(*hdr));
-	fail_scsi_tasks(conn, -1, DID_ERROR);
+	fail_scsi_tasks(session, conn, -1, DID_ERROR);
 	session->tmf_state =3D TMF_INITIAL;
 	spin_unlock_bh(&session->frwd_lock);
=20
@@ -3374,7 +3389,7 @@ fail_mgmt_tasks(struct iscsi_session *session, stru=
ct iscsi_conn *conn)
 				  task->itt, task->state);
=20
 		spin_lock_bh(&session->back_lock);
-		if (cleanup_queued_task(task)) {
+		if (cleanup_queued_task(session, task)) {
 			spin_unlock_bh(&session->back_lock);
 			continue;
 		}
@@ -3382,7 +3397,7 @@ fail_mgmt_tasks(struct iscsi_session *session, stru=
ct iscsi_conn *conn)
 		state =3D ISCSI_TASK_ABRT_SESS_RECOV;
 		if (task->state =3D=3D ISCSI_TASK_PENDING)
 			state =3D ISCSI_TASK_COMPLETED;
-		iscsi_complete_task(task, state);
+		iscsi_complete_task(session, task, state);
 		spin_unlock_bh(&session->back_lock);
 	}
 }
@@ -3442,7 +3457,7 @@ void iscsi_conn_stop(struct iscsi_cls_conn *cls_con=
n, int flag)
 	 * flush queues.
 	 */
 	spin_lock_bh(&session->frwd_lock);
-	fail_scsi_tasks(conn, -1, DID_TRANSPORT_DISRUPTED);
+	fail_scsi_tasks(session, conn, -1, DID_TRANSPORT_DISRUPTED);
 	fail_mgmt_tasks(session, conn);
 	memset(&session->tmhdr, 0, sizeof(session->tmhdr));
 	spin_unlock_bh(&session->frwd_lock);
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 7223bb18b048..a9c092a80b81 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -529,7 +529,7 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn,=
 struct iscsi_hdr *hdr)
 	int rc;
=20
 	spin_lock(&session->back_lock);
-	task =3D iscsi_itt_to_ctask(conn, hdr->itt);
+	task =3D iscsi_itt_to_ctask(session, conn, hdr->itt);
 	if (!task) {
 		spin_unlock(&session->back_lock);
 		return ISCSI_ERR_BAD_ITT;
@@ -677,6 +677,7 @@ iscsi_tcp_process_data_in(struct iscsi_tcp_conn *tcp_=
conn,
 static int
 iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 {
+	struct iscsi_session *session =3D conn->session;
 	int rc =3D 0, opcode, ahslen;
 	struct iscsi_tcp_conn *tcp_conn =3D conn->dd_data;
 	struct iscsi_task *task;
@@ -706,14 +707,14 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, stru=
ct iscsi_hdr *hdr)
=20
 	switch(opcode) {
 	case ISCSI_OP_SCSI_DATA_IN:
-		spin_lock(&conn->session->back_lock);
-		task =3D iscsi_itt_to_ctask(conn, hdr->itt);
+		spin_lock(&session->back_lock);
+		task =3D iscsi_itt_to_ctask(session, conn, hdr->itt);
 		if (!task)
 			rc =3D ISCSI_ERR_BAD_ITT;
 		else
 			rc =3D iscsi_tcp_data_in(conn, task);
 		if (rc) {
-			spin_unlock(&conn->session->back_lock);
+			spin_unlock(&session->back_lock);
 			break;
 		}
=20
@@ -731,7 +732,7 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct=
 iscsi_hdr *hdr)
 			 * update the digest per-entry.
 			 */
 			if (conn->datadgst_en &&
-			    !(conn->session->tt->caps & CAP_DIGEST_OFFLOAD))
+			    !(session->tt->caps & CAP_DIGEST_OFFLOAD))
 				rx_crcp =3D tcp_conn->rx_crcp;
=20
 			ISCSI_DBG_TCP(conn, "iscsi_tcp_begin_data_in( "
@@ -746,11 +747,11 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, stru=
ct iscsi_hdr *hdr)
 						   tcp_conn->in.datalen,
 						   iscsi_tcp_process_data_in,
 						   rx_crcp);
-			spin_unlock(&conn->session->back_lock);
+			spin_unlock(&session->back_lock);
 			return rc;
 		}
-		rc =3D __iscsi_complete_pdu(conn, hdr, NULL, 0);
-		spin_unlock(&conn->session->back_lock);
+		rc =3D __iscsi_complete_pdu(session, conn, hdr, NULL, 0);
+		spin_unlock(&session->back_lock);
 		break;
 	case ISCSI_OP_R2T:
 		if (ahslen) {
diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 854efa4f61d8..37945f16811b 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -73,7 +73,7 @@ static void qedi_process_logout_resp(struct qedi_ctx *q=
edi,
 	spin_unlock(&qedi_conn->list_lock);
=20
 	cmd->state =3D RESPONSE_RECEIVED;
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, NULL, 0);
+	__iscsi_complete_pdu(session, conn, (struct iscsi_hdr *)resp_hdr, NULL,=
 0);
=20
 	spin_unlock(&session->back_lock);
 }
@@ -138,7 +138,7 @@ static void qedi_process_text_resp(struct qedi_ctx *q=
edi,
=20
 	cmd->state =3D RESPONSE_RECEIVED;
=20
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr,
+	__iscsi_complete_pdu(session, conn, (struct iscsi_hdr *)resp_hdr_ptr,
 			     qedi_conn->gen_pdu.resp_buf,
 			     (qedi_conn->gen_pdu.resp_wr_ptr -
 			      qedi_conn->gen_pdu.resp_buf));
@@ -163,7 +163,8 @@ static void qedi_tmf_resp_work(struct work_struct *wo=
rk)
 		goto exit_tmf_resp;
=20
 	spin_lock(&session->back_lock);
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
+	__iscsi_complete_pdu(session, conn, (struct iscsi_hdr *)resp_hdr_ptr, N=
ULL,
+			     0);
 	spin_unlock(&session->back_lock);
=20
 exit_tmf_resp:
@@ -247,7 +248,8 @@ static void qedi_process_tmf_resp(struct qedi_ctx *qe=
di,
 	}
 	spin_unlock(&qedi_conn->tmf_work_lock);
=20
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
+	__iscsi_complete_pdu(session, conn, (struct iscsi_hdr *)resp_hdr_ptr, N=
ULL,
+			     0);
 	kfree(resp_hdr_ptr);
=20
 unblock_sess:
@@ -304,7 +306,7 @@ static void qedi_process_login_resp(struct qedi_ctx *=
qedi,
=20
 	memset(task_ctx, '\0', sizeof(*task_ctx));
=20
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr,
+	__iscsi_complete_pdu(session, conn, (struct iscsi_hdr *)resp_hdr_ptr,
 			     qedi_conn->gen_pdu.resp_buf,
 			     (qedi_conn->gen_pdu.resp_wr_ptr -
 			     qedi_conn->gen_pdu.resp_buf));
@@ -470,7 +472,8 @@ static int qedi_process_nopin_mesg(struct qedi_ctx *q=
edi,
 	}
=20
 done:
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, bdq_data, pdu_len);
+	__iscsi_complete_pdu(session, conn, (struct iscsi_hdr *)hdr, bdq_data,
+			     pdu_len);
=20
 	spin_unlock_bh(&session->back_lock);
 	return tgt_async_nop;
@@ -524,7 +527,7 @@ static void qedi_process_async_mesg(struct qedi_ctx *=
qedi,
 	resp_hdr->param2 =3D cpu_to_be16(cqe_async_msg->param2_rsrv);
 	resp_hdr->param3 =3D cpu_to_be16(cqe_async_msg->param3_rsrv);
=20
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr, bdq_data,
+	__iscsi_complete_pdu(session, conn, (struct iscsi_hdr *)resp_hdr, bdq_d=
ata,
 			     pdu_len);
=20
 	spin_unlock_bh(&session->back_lock);
@@ -567,7 +570,7 @@ static void qedi_process_reject_mesg(struct qedi_ctx =
*qedi,
 	hdr->statsn =3D cpu_to_be32(cqe_reject->stat_sn);
 	hdr->ffffffff =3D cpu_to_be32(0xffffffff);
=20
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr,
+	__iscsi_complete_pdu(session, conn, (struct iscsi_hdr *)hdr,
 			     conn->data, pld_len);
 	spin_unlock_bh(&session->back_lock);
 }
@@ -664,7 +667,7 @@ static void qedi_scsi_completion(struct qedi_ctx *qed=
i,
 	if (qedi_io_tracing)
 		qedi_trace_io(qedi, task, cmd->task_id, QEDI_IO_TRACE_RSP);
=20
-	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr,
+	__iscsi_complete_pdu(session, conn, (struct iscsi_hdr *)hdr,
 			     conn->data, datalen);
 error:
 	spin_unlock_bh(&session->back_lock);
@@ -722,7 +725,7 @@ static void qedi_process_nopin_local_cmpl(struct qedi=
_ctx *qedi,
 	cmd->state =3D RESPONSE_RECEIVED;
=20
 	spin_lock_bh(&session->back_lock);
-	__iscsi_put_task(task);
+	__iscsi_put_task(session, task);
 	spin_unlock_bh(&session->back_lock);
 }
=20
@@ -1316,6 +1319,7 @@ static void qedi_abort_work(struct work_struct *wor=
k)
 	struct qedi_conn *qedi_conn =3D qedi_cmd->conn;
 	struct qedi_ctx *qedi =3D qedi_conn->qedi;
 	struct iscsi_conn *conn =3D qedi_conn->cls_conn->dd_data;
+	struct iscsi_session *session =3D conn->session;
 	struct qedi_work_map *list_work =3D NULL;
 	struct iscsi_task *mtask;
 	struct qedi_cmd *cmd;
@@ -1326,16 +1330,16 @@ static void qedi_abort_work(struct work_struct *w=
ork)
 	mtask =3D qedi_cmd->task;
 	tmf_hdr =3D (struct iscsi_tm *)mtask->hdr;
=20
-	spin_lock_bh(&conn->session->back_lock);
-	ctask =3D iscsi_itt_to_ctask(conn, tmf_hdr->rtt);
+	spin_lock_bh(&session->back_lock);
+	ctask =3D iscsi_itt_to_ctask(session, conn, tmf_hdr->rtt);
 	if (!ctask) {
-		spin_unlock_bh(&conn->session->back_lock);
+		spin_unlock_bh(&session->back_lock);
 		QEDI_ERR(&qedi->dbg_ctx, "Invalid RTT. Letting abort timeout.\n");
 		goto clear_cleanup;
 	}
=20
 	if (iscsi_task_is_completed(ctask)) {
-		spin_unlock_bh(&conn->session->back_lock);
+		spin_unlock_bh(&session->back_lock);
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
 			  "Task already completed\n");
 		/*
@@ -1344,7 +1348,7 @@ static void qedi_abort_work(struct work_struct *wor=
k)
 		 */
 		goto send_tmf;
 	}
-	spin_unlock_bh(&conn->session->back_lock);
+	spin_unlock_bh(&session->back_lock);
=20
 	cmd =3D (struct qedi_cmd *)ctask->dd_data;
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_is=
r.c
index cf52258ecdde..81989c905c82 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -367,6 +367,7 @@ static void qla4xxx_passthru_status_entry(struct scsi=
_qla_host *ha,
 	struct ddb_entry *ddb_entry;
 	struct ql4_task_data *task_data;
 	struct iscsi_cls_conn *cls_conn;
+	struct iscsi_session *session;
 	struct iscsi_conn *conn;
 	itt_t itt;
 	uint32_t fw_ddb_index;
@@ -384,9 +385,10 @@ static void qla4xxx_passthru_status_entry(struct scs=
i_qla_host *ha,
=20
 	cls_conn =3D ddb_entry->conn;
 	conn =3D cls_conn->dd_data;
-	spin_lock(&conn->session->back_lock);
-	task =3D iscsi_itt_to_task(conn, itt);
-	spin_unlock(&conn->session->back_lock);
+	session =3D conn->session;
+	spin_lock(&session->back_lock);
+	task =3D iscsi_itt_to_task(session, conn, itt);
+	spin_unlock(&session->back_lock);
=20
 	if (task =3D=3D NULL) {
 		ql4_printk(KERN_ERR, ha, "%s: Task is NULL\n", __func__);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 3d765c77bcd9..f79b46798edf 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -474,17 +474,21 @@ extern int iscsi_conn_send_pdu(struct iscsi_cls_con=
n *, struct iscsi_hdr *,
 				char *, uint32_t);
 extern int iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
 			      char *, int);
-extern int __iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
+extern int __iscsi_complete_pdu(struct iscsi_session *session,
+				struct iscsi_conn *conn, struct iscsi_hdr *,
 				char *, int);
 extern int iscsi_verify_itt(struct iscsi_conn *, itt_t);
-extern struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *, itt_t)=
;
-extern struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *, itt_t);
+struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_session *session,
+				      struct iscsi_conn *, itt_t);
+struct iscsi_task *iscsi_itt_to_task(struct iscsi_session *session,
+				     struct iscsi_conn *, itt_t);
 extern void iscsi_requeue_task(struct iscsi_task *task);
 extern void iscsi_put_task(struct iscsi_task *task);
-extern void __iscsi_put_task(struct iscsi_task *task);
+void __iscsi_put_task(struct iscsi_session *session, struct iscsi_task *=
task);
 extern bool iscsi_get_task(struct iscsi_task *task);
-extern void iscsi_complete_scsi_task(struct iscsi_task *task,
-				     uint32_t exp_cmdsn, uint32_t max_cmdsn);
+void iscsi_complete_scsi_task(struct iscsi_session *session,
+			      struct iscsi_task *task,
+			      uint32_t exp_cmdsn, uint32_t max_cmdsn);
=20
 /*
  * generic helpers
