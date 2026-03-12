Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95AD26B2DA
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350255; cv=none; b=Lnrt4skBPsBJE4LKzpcaNI0z+KE/AHXdRQ44LOF41RGh6PXK0yAn0Y7AM+NKLQUaEWBAjmEd9HmVlS5OxXftOs49YfMfp2Jei1YIqQF20jy0nobnB7R3noxpgcTRt0lxWL9P5meC6Oj0F7JIsbvaB5iNcPafi/dp5xT/bwerQ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350255; c=relaxed/simple;
	bh=GMxP1D3g1NBSpHMP6qSykbeuKHik+o9EOo5ZXHlHn9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXtno3RMC1ZfIglUPSJqbmEU4yw9wyc/xFaaB/FR/jdpVye7zvRCv/24GKTXUJImyC59veHp4tCnsGhW39yYPaN/39c4LoCRlmABtW9XntxEfpWHdk3tIPc+1grvjh/xb2brrOpsg0Go4b5v+DwGq9RFMe2mWLV2uX1FgTm17bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mntFLXl9; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mntFLXl9"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0nT59Qpzlfl5W;
	Thu, 12 Mar 2026 21:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350248; x=1775942249; bh=3AuGo
	viAQOm71/8waLBLtyg/grjtRqYsetaZ4Bcq2kI=; b=mntFLXl9hVcJHEZ6YKDHb
	6RAo9k6tWRPxoLZjvz7vEB9Sh7R1cF2wbQMrV7ZiaP8zFoEXcJ6pokVsqbX0+3WW
	oGbRYurTKe7lJdN2bvkYBdkMhkdBtTEtcCF+4G6gRmo6GtmkJMdtDk1t7MZrmUqi
	bE5F1fmVUUapOaNPYZqViDVripkFCI9/2KvEEwytXwtzdPtrwmhUvxx2D/pKe5NG
	+miwuug4xyMzpaE6sawEpAPhPlg1824O5YlUGkZxPU8XsWu6sVfRe83TE0AIV915
	uIjflFaZvvqj6DJFqBLFmhOOMLpYWAhgZtzONvqyDhH3DDfuiPBpWihSZ7EM5phf
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id E_HRoMWxXSPB; Thu, 12 Mar 2026 21:17:28 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0nL6wSFzlfl8L;
	Thu, 12 Mar 2026 21:17:26 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 12/36] scsi: bnx2fc: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:23 -0700
Message-ID: <20260312211636.3245119-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260312211636.3245119-1-bvanassche@acm.org>
References: <20260312211636.3245119-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document the locking requirements with __must_hold(). Inform the
compiler about aliases for synchronization objects with
__assume_ctx_lock().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bnx2fc/bnx2fc.h     | 5 +++--
 drivers/scsi/bnx2fc/bnx2fc_els.c | 2 ++
 drivers/scsi/bnx2fc/bnx2fc_hwi.c | 3 +++
 drivers/scsi/bnx2fc/bnx2fc_io.c  | 6 +++++-
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 8c8968ec8cb4..566632d7e880 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -592,9 +592,10 @@ int bnx2fc_send_stat_req(struct bnx2fc_hba *hba);
 int bnx2fc_post_io_req(struct bnx2fc_rport *tgt, struct bnx2fc_cmd *io_r=
eq);
 int bnx2fc_send_rec(struct bnx2fc_cmd *orig_io_req);
 int bnx2fc_send_srr(struct bnx2fc_cmd *orig_io_req, u32 offset, u8 r_ctl=
);
-void bnx2fc_process_seq_cleanup_compl(struct bnx2fc_cmd *seq_clnup_req,
+void bnx2fc_process_seq_cleanup_compl(struct bnx2fc_cmd *seq_clnp_req,
 				      struct fcoe_task_ctx_entry *task,
-				      u8 rx_state);
+				      u8 rx_state)
+	__must_hold(&seq_clnp_req->cb_arg->aborted_io_req->tgt->tgt_lock);
 int bnx2fc_initiate_seq_cleanup(struct bnx2fc_cmd *orig_io_req, u32 offs=
et,
 				enum fc_rctl r_ctl);
=20
diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx2f=
c_els.c
index 749e30aaf926..1f333a135879 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -263,6 +263,7 @@ int bnx2fc_send_rls(struct bnx2fc_rport *tgt, struct =
fc_frame *fp)
 }
=20
 static void bnx2fc_srr_compl(struct bnx2fc_els_cb_arg *cb_arg)
+	__must_hold(&cb_arg->aborted_io_req->tgt->tgt_lock)
 {
 	struct bnx2fc_mp_req *mp_req;
 	struct fc_frame_header *fc_hdr, *fh;
@@ -373,6 +374,7 @@ static void bnx2fc_srr_compl(struct bnx2fc_els_cb_arg=
 *cb_arg)
 }
=20
 static void bnx2fc_rec_compl(struct bnx2fc_els_cb_arg *cb_arg)
+	__must_hold(&cb_arg->aborted_io_req->tgt->tgt_lock)
 {
 	struct bnx2fc_cmd *orig_io_req, *new_io_req;
 	struct bnx2fc_cmd *rec_req;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2f=
c_hwi.c
index a5ecb87d5b2d..a3670c48900b 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -880,6 +880,9 @@ void bnx2fc_process_cq_compl(struct bnx2fc_rport *tgt=
, u16 wqe,
 		return;
 	}
=20
+	/* Tell the compiler that there is an alias for tgt->tgt_lock. */
+	__assume_ctx_lock(&io_req->cb_arg->aborted_io_req->tgt->tgt_lock);
+
 	/* Timestamp IO completion time */
 	cmd_type =3D io_req->cmd_type;
=20
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc=
_io.c
index 9c7a541a4523..351c72404b5f 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1080,7 +1080,7 @@ int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd=
)
 }
=20
 static int bnx2fc_abts_cleanup(struct bnx2fc_cmd *io_req)
-	__must_hold(&tgt->tgt_lock)
+	__must_hold(&io_req->tgt->tgt_lock)
 {
 	struct bnx2fc_rport *tgt =3D io_req->tgt;
 	unsigned int time_left;
@@ -1207,6 +1207,8 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		if (cancel_delayed_work(&io_req->timeout_work))
 			kref_put(&io_req->refcount,
 				 bnx2fc_cmd_release); /* drop timer hold */
+		/* Tell the compiler that io_req->tgt =3D=3D tgt. */
+		__assume_ctx_lock(&io_req->tgt->tgt_lock);
 		/*
 		 * We don't want to hold off the upper layer timer so simply
 		 * cleanup the command and return that I/O was successfully
@@ -1258,6 +1260,8 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		/* Let the scsi-ml try to recover this command */
 		printk(KERN_ERR PFX "abort failed, xid =3D 0x%x\n",
 		       io_req->xid);
+		/* Tell the compiler that io_req->tgt =3D=3D tgt. */
+		__assume_ctx_lock(&io_req->tgt->tgt_lock);
 		/*
 		 * Cleanup firmware residuals before returning control back
 		 * to SCSI ML.
