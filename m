Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9964DA9BD
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361025; cv=none; b=ZVEi1+/Rsjp0OOUXfMo9t5IWT8WE4FRJozgtXa8OFZFJUOeBx4yIPtiSXWFRgwqGLAvAa/vSF2ksycx9VWDEVRykLK3Zsil9cmLcY/oWDSIpRzFlhlwI645w1n7ekHK0p4nnEPkBCgql+17knQ9AKNFVAn3kGFui4nwGbCjjkUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361025; c=relaxed/simple;
	bh=zwomvNpKf4soEi8Wb/zou1i8ZllKbiwi1H0gSpfFyI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lg9zp9kYb/C4WEtRuEtdqhuhxLXnDVbKoXXC0XJhDe87v4Qj1RETz66olXULoiJ8a1Oz+1phRGrnxtFwFBHtzAj5D7rAOzSxqMhfcHT5LNJwkmdTWknmH+T8J+h+1jmTMAKYmrDJSyQZPQhPelOyZ8FOGE4pNcdS/dCh5kXeg+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nWJk+KYO; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nWJk+KYO"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzld5yr7z1XM5kY;
	Fri, 25 Sep 2026 18:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361009; x=1792953010; bh=krB1V
	qPElVeEOiuzlG+8hjITpgq1OqYWyta4Kd/YVdA=; b=nWJk+KYO5+5DVlefWLXW7
	nuYDpw0ARYGayJ5Fx6int/aXl7P1Rs95cAS5Vn4UhmeeC4V5StASql1rnFfXGUeg
	Xc8dLtkLVjcwus5swrvU+8dqADV34TVLtGE2MtwLztsTt6seNCfoNb5GvAQnex/x
	rmlJ4bSErU5slGHmwj3cl//UCkHcuZac8oQOhZ0cjldVxXx9y+pzLxrv/xoZyXrR
	0gC5ISFcx56eQ8viOCWwXAh9/FVDb4j6zdYTBgZgAPwaFwKiMNsrelY3bHsqk2/3
	kbzZBGtbrNUWIZg+dH80fshhNPKSutHulozKrM6MdakZGml9GNtHKeSBzoCly1eU
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 28lbR6vuDieP; Fri, 25 Sep 2026 18:30:09 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzlL5mhQz1XM5kW;
	Fri, 25 Sep 2026 18:30:06 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 17/54] scsi: bnx2fc: Pass tgt directly to several functions
Date: Fri, 25 Sep 2026 11:25:55 -0700
Message-ID: <e0073d5095f58569c8c16217f9b2fabd44762ad9.1790360262.git.bvanassche@acm.org>
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

Pass the tgt pointer directly to several functions. This patch prepares f=
or
enabling lock context annotation. No functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bnx2fc/bnx2fc.h     |  6 ++++--
 drivers/scsi/bnx2fc/bnx2fc_els.c | 25 +++++++++++++------------
 drivers/scsi/bnx2fc/bnx2fc_hwi.c |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c  | 14 +++++++-------
 drivers/scsi/bnx2fc/bnx2fc_tgt.c |  2 +-
 5 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 8c8968ec8cb4..fde41224d31f 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -423,7 +423,8 @@ struct bnx2fc_cmd {
 	struct scsi_cmnd *sc_cmd;
 	struct bnx2fc_cmd_mgr *cmd_mgr;
 	struct bnx2fc_mp_req mp_req;
-	void (*cb_func)(struct bnx2fc_els_cb_arg *cb_arg);
+	void (*cb_func)(struct bnx2fc_rport *tgt,
+			struct bnx2fc_els_cb_arg *cb_arg);
 	struct bnx2fc_els_cb_arg *cb_arg;
 	struct delayed_work timeout_work; /* timer for ULP timeouts */
 	struct completion abts_done;
@@ -592,7 +593,8 @@ int bnx2fc_send_stat_req(struct bnx2fc_hba *hba);
 int bnx2fc_post_io_req(struct bnx2fc_rport *tgt, struct bnx2fc_cmd *io_r=
eq);
 int bnx2fc_send_rec(struct bnx2fc_cmd *orig_io_req);
 int bnx2fc_send_srr(struct bnx2fc_cmd *orig_io_req, u32 offset, u8 r_ctl=
);
-void bnx2fc_process_seq_cleanup_compl(struct bnx2fc_cmd *seq_clnup_req,
+void bnx2fc_process_seq_cleanup_compl(struct bnx2fc_rport *tgt,
+				      struct bnx2fc_cmd *seq_clnp_req,
 				      struct fcoe_task_ctx_entry *task,
 				      u8 rx_state);
 int bnx2fc_initiate_seq_cleanup(struct bnx2fc_cmd *orig_io_req, u32 offs=
et,
diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx2f=
c_els.c
index 749e30aaf926..5191d87fb446 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -22,10 +22,12 @@ static void bnx2fc_flogi_resp(struct fc_seq *seq, str=
uct fc_frame *fp,
 			      void *arg);
 static int bnx2fc_initiate_els(struct bnx2fc_rport *tgt, unsigned int op=
,
 			void *data, u32 data_len,
-			void (*cb_func)(struct bnx2fc_els_cb_arg *cb_arg),
+			void (*cb_func)(struct bnx2fc_rport *tgt,
+					struct bnx2fc_els_cb_arg *cb_arg),
 			struct bnx2fc_els_cb_arg *cb_arg, u32 timer_msec);
=20
-static void bnx2fc_rrq_compl(struct bnx2fc_els_cb_arg *cb_arg)
+static void bnx2fc_rrq_compl(struct bnx2fc_rport *tgt,
+			     struct bnx2fc_els_cb_arg *cb_arg)
 {
 	struct bnx2fc_cmd *orig_io_req;
 	struct bnx2fc_cmd *rrq_req;
@@ -119,10 +121,10 @@ int bnx2fc_send_rrq(struct bnx2fc_cmd *aborted_io_r=
eq)
 	return rc;
 }
=20
-static void bnx2fc_l2_els_compl(struct bnx2fc_els_cb_arg *cb_arg)
+static void bnx2fc_l2_els_compl(struct bnx2fc_rport *tgt,
+				struct bnx2fc_els_cb_arg *cb_arg)
 {
 	struct bnx2fc_cmd *els_req;
-	struct bnx2fc_rport *tgt;
 	struct bnx2fc_mp_req *mp_req;
 	struct fc_frame_header *fc_hdr;
 	unsigned char *buf;
@@ -150,7 +152,6 @@ static void bnx2fc_l2_els_compl(struct bnx2fc_els_cb_=
arg *cb_arg)
 		goto free_arg;
 	}
=20
-	tgt =3D els_req->tgt;
 	mp_req =3D &(els_req->mp_req);
 	fc_hdr =3D &(mp_req->resp_fc_hdr);
 	resp_len =3D mp_req->resp_len;
@@ -262,7 +263,8 @@ int bnx2fc_send_rls(struct bnx2fc_rport *tgt, struct =
fc_frame *fp)
 	return rc;
 }
=20
-static void bnx2fc_srr_compl(struct bnx2fc_els_cb_arg *cb_arg)
+static void bnx2fc_srr_compl(struct bnx2fc_rport *tgt,
+			     struct bnx2fc_els_cb_arg *cb_arg)
 {
 	struct bnx2fc_mp_req *mp_req;
 	struct fc_frame_header *fc_hdr, *fh;
@@ -296,7 +298,6 @@ static void bnx2fc_srr_compl(struct bnx2fc_els_cb_arg=
 *cb_arg)
 		}
 		orig_io_req->srr_retry++;
 		if (orig_io_req->srr_retry <=3D SRR_RETRY_COUNT) {
-			struct bnx2fc_rport *tgt =3D orig_io_req->tgt;
 			spin_unlock_bh(&tgt->tgt_lock);
 			rc =3D bnx2fc_send_srr(orig_io_req,
 					     orig_io_req->srr_offset,
@@ -372,7 +373,8 @@ static void bnx2fc_srr_compl(struct bnx2fc_els_cb_arg=
 *cb_arg)
 	kref_put(&orig_io_req->refcount, bnx2fc_cmd_release);
 }
=20
-static void bnx2fc_rec_compl(struct bnx2fc_els_cb_arg *cb_arg)
+static void bnx2fc_rec_compl(struct bnx2fc_rport *tgt,
+			     struct bnx2fc_els_cb_arg *cb_arg)
 {
 	struct bnx2fc_cmd *orig_io_req, *new_io_req;
 	struct bnx2fc_cmd *rec_req;
@@ -380,7 +382,6 @@ static void bnx2fc_rec_compl(struct bnx2fc_els_cb_arg=
 *cb_arg)
 	struct fc_frame_header *fc_hdr, *fh;
 	struct fc_els_ls_rjt *rjt;
 	struct fc_els_rec_acc *acc;
-	struct bnx2fc_rport *tgt;
 	struct fcoe_err_report_entry *err_entry;
 	struct scsi_cmnd *sc_cmd;
 	enum fc_rctl r_ctl;
@@ -399,7 +400,6 @@ static void bnx2fc_rec_compl(struct bnx2fc_els_cb_arg=
 *cb_arg)
 	rec_req =3D cb_arg->io_req;
 	orig_io_req =3D cb_arg->aborted_io_req;
 	BNX2FC_IO_DBG(rec_req, "rec_compl: orig xid =3D 0x%x", orig_io_req->xid=
);
-	tgt =3D orig_io_req->tgt;
=20
 	/* Handle REC timeout case */
 	if (test_and_clear_bit(BNX2FC_FLAG_ELS_TIMEOUT, &rec_req->req_flags)) {
@@ -669,7 +669,8 @@ int bnx2fc_send_srr(struct bnx2fc_cmd *orig_io_req, u=
32 offset, u8 r_ctl)
=20
 static int bnx2fc_initiate_els(struct bnx2fc_rport *tgt, unsigned int op=
,
 			void *data, u32 data_len,
-			void (*cb_func)(struct bnx2fc_els_cb_arg *cb_arg),
+			void (*cb_func)(struct bnx2fc_rport *tgt,
+					struct bnx2fc_els_cb_arg *cb_arg),
 			struct bnx2fc_els_cb_arg *cb_arg, u32 timer_msec)
 {
 	struct fcoe_port *port =3D tgt->port;
@@ -847,7 +848,7 @@ void bnx2fc_process_els_compl(struct bnx2fc_cmd *els_=
req,
=20
 	/* Parse ELS response */
 	if ((els_req->cb_func) && (els_req->cb_arg)) {
-		els_req->cb_func(els_req->cb_arg);
+		els_req->cb_func(els_req->tgt, els_req->cb_arg);
 		els_req->cb_arg =3D NULL;
 	}
=20
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2f=
c_hwi.c
index a5ecb87d5b2d..833ec0e35731 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -943,7 +943,7 @@ void bnx2fc_process_cq_compl(struct bnx2fc_rport *tgt=
, u16 wqe,
 	case BNX2FC_SEQ_CLEANUP:
 		BNX2FC_IO_DBG(io_req, "cq_compl(0x%x) - seq cleanup resp\n",
 			      io_req->xid);
-		bnx2fc_process_seq_cleanup_compl(io_req, task, rx_state);
+		bnx2fc_process_seq_cleanup_compl(tgt, io_req, task, rx_state);
 		kref_put(&io_req->refcount, bnx2fc_cmd_release);
 		break;
=20
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc=
_io.c
index 9c7a541a4523..82d70ccfc59b 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -142,7 +142,7 @@ static void bnx2fc_cmd_timeout(struct work_struct *wo=
rk)
 			set_bit(BNX2FC_FLAG_ELS_TIMEOUT, &io_req->req_flags);
=20
 			if ((io_req->cb_func) && (io_req->cb_arg)) {
-				io_req->cb_func(io_req->cb_arg);
+				io_req->cb_func(tgt, io_req->cb_arg);
 				io_req->cb_arg =3D NULL;
 			}
 		}
@@ -1079,10 +1079,10 @@ int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_c=
md)
 				   FCP_TMF_LUN_RESET);
 }
=20
-static int bnx2fc_abts_cleanup(struct bnx2fc_cmd *io_req)
+static int bnx2fc_abts_cleanup(struct bnx2fc_rport *tgt,
+			       struct bnx2fc_cmd *io_req)
 	__must_hold(&tgt->tgt_lock)
 {
-	struct bnx2fc_rport *tgt =3D io_req->tgt;
 	unsigned int time_left;
=20
 	init_completion(&io_req->cleanup_done);
@@ -1212,7 +1212,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		 * cleanup the command and return that I/O was successfully
 		 * aborted.
 		 */
-		bnx2fc_abts_cleanup(io_req);
+		bnx2fc_abts_cleanup(tgt, io_req);
 		/* This only occurs when an task abort was requested while ABTS
 		   is in progress.  Setting the IO_CLEANUP flag will skip the
 		   RRQ process in the case when the fw generated SCSI_CMD cmpl
@@ -1262,7 +1262,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		 * Cleanup firmware residuals before returning control back
 		 * to SCSI ML.
 		 */
-		rc =3D bnx2fc_abts_cleanup(io_req);
+		rc =3D bnx2fc_abts_cleanup(tgt, io_req);
 		goto done;
 	} else {
 		/*
@@ -1282,7 +1282,8 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	return rc;
 }
=20
-void bnx2fc_process_seq_cleanup_compl(struct bnx2fc_cmd *seq_clnp_req,
+void bnx2fc_process_seq_cleanup_compl(struct bnx2fc_rport *tgt,
+				      struct bnx2fc_cmd *seq_clnp_req,
 				      struct fcoe_task_ctx_entry *task,
 				      u8 rx_state)
 {
@@ -1291,7 +1292,6 @@ void bnx2fc_process_seq_cleanup_compl(struct bnx2fc=
_cmd *seq_clnp_req,
 	u32 offset =3D cb_arg->offset;
 	enum fc_rctl r_ctl =3D cb_arg->r_ctl;
 	int rc =3D 0;
-	struct bnx2fc_rport *tgt =3D orig_io_req->tgt;
=20
 	BNX2FC_IO_DBG(orig_io_req, "Entered process_cleanup_compl xid =3D 0x%x"
 			      "cmd_type =3D %d\n",
diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2f=
c_tgt.c
index 77dcdfc412b1..e6942cb6cae6 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -224,7 +224,7 @@ void bnx2fc_flush_active_ios(struct bnx2fc_rport *tgt=
)
 				 bnx2fc_cmd_release); /* drop timer hold */
=20
 		if ((io_req->cb_func) && (io_req->cb_arg)) {
-			io_req->cb_func(io_req->cb_arg);
+			io_req->cb_func(tgt, io_req->cb_arg);
 			io_req->cb_arg =3D NULL;
 		}
=20
