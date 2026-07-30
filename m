Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9143B7B76
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451670; cv=none; b=DQu4mf4EvufD3X9a15S6VCJ9eujJZuL7wxUMlcNTV0z7gnglSMgGaps4816RDelSJC0OjGDH+sjhYSYSPAeIHU2ilaG8wLM0R9T62wwu+Rnz/LVg7a/pEhG470cDVSPd7e3VwiB5LpS/dkj1YRo/i4zLWRFv6DGxtSl5BdJkSNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451670; c=relaxed/simple;
	bh=YhRBffoI0/iaDjoJeOhfUVTVCueD+Tzc0x5Kv/bk9E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaN4+tCe7JVS656euUQm4NArNb8CWo2MUHO2ObG/xfjj2V3PEheAK/ZPe281OuB8Pjg1amP7gId53XXZ9KHeRNczI2IoCswK0G3QTa6BnCwEA/TvJbplNZfMiATwqEK91lsDmU80pJaBh93wy/fRS1KK2rmdswUYJJ4pcEsLv5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wH9VH3ZJ; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wH9VH3ZJ"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4904tzRz1XM6Jk;
	Thu, 30 Jul 2026 22:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451661; x=1788043662; bh=rIYz0
	VXU8Y/pSlvurWLlPwI5HdPyaTg/6SnrQ29rL+I=; b=wH9VH3ZJ/GCYypsxObDKy
	ohN5sbyhmEfhwv7PzwKxLpBLCRrWIFZQGLtiO+Qe+afonCggrryeVwxuVFfAw13U
	AIyT15ZWx4rUPd3dJ5CgEYvlSEO9BHyMP6uN9vXjTphOJ33uRdecRrOLOAtbCgKS
	L878nBPtfFS3DW96t5PyjfDAGjDIgjg+MnRb9R6hFLJUsSu8QJTRVLWOn5otcOZs
	Kn1ZOGGgFrBa2qHWM3z+IUEZXpi5GoY97QRcGkZ0JxJ9KbBh7U0a0k43Vsl1n/DS
	s+E8qgtv7IaZJmASpmFSjFgbTA+tbHIEU/sfYx2O5WV0MEfQv7fUkczxs9Ya1aiR
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Nx66I_w7KuAe; Thu, 30 Jul 2026 22:47:41 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB48q3Wgvz1XM30k;
	Thu, 30 Jul 2026 22:47:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 19/57] scsi: bnx2fc: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:02 -0700
Message-ID: <8916cb8f189b235cf7873378617575c922463dd3.1785451174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <cover.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document the locking requirements with __must_hold(). Inform the
compiler about aliases for synchronization objects with
__assume_ctx_lock(). Make the argument names in the definition and the
declaration of bnx2fc_process_seq_cleanup_compl() consistent.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bnx2fc/Makefile     | 3 +++
 drivers/scsi/bnx2fc/bnx2fc.h     | 5 +++--
 drivers/scsi/bnx2fc/bnx2fc_els.c | 2 ++
 drivers/scsi/bnx2fc/bnx2fc_hwi.c | 3 +++
 drivers/scsi/bnx2fc/bnx2fc_io.c  | 6 +++++-
 5 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/Makefile b/drivers/scsi/bnx2fc/Makefile
index 1d72e279a97d..3feb6b4dae64 100644
--- a/drivers/scsi/bnx2fc/Makefile
+++ b/drivers/scsi/bnx2fc/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_BNX2X_FCOE) +=3D bnx2fc.o
=20
 bnx2fc-y :=3D bnx2fc_els.o bnx2fc_fcoe.o bnx2fc_hwi.o bnx2fc_io.o bnx2fc=
_tgt.o \
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
