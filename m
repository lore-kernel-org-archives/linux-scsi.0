Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1613A782B
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361021; cv=none; b=HcmcID/p6FoLkL9w/w19BcnNHy+dUtIWVsDcU4MliJ9fSM6cljzF6dmEH50TIv7UZc6Col7hQSKRoNgESKkuF0/5gIN+7dUiRncp+jw5MZ1UX0w3pXxekD+E7d8a7+Wx3NgwpD3St99vxvJPlujwHx5fX5LHCg5+uvGLpkqZJvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361021; c=relaxed/simple;
	bh=ogqreC+pRfYqMLkPjBMK9gYiNgh7SNUiNz/D8n2op9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQiAUiSwPwG3O97Q4+pDfogOuurfygNn/WiiOerXnVAjJ+lxErt58khBHxFvM/W/0MZE/pXwXohu30bHlCvO/mJZZRCYYaPg9u7seBDrxy1XEltX+MUjH8R2DgxDTy4RW15lwqHNzfUrOQBMdyxORTeiqv29NbY+KcY+hKtXFWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Egs4gzC+; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Egs4gzC+"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzlb0rF2z1XM30g;
	Fri, 25 Sep 2026 18:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361013; x=1792953014; bh=XdNNz
	n7/mr2WwL23zGxZ9IgU4sgT3R4YZWaQisHgRhY=; b=Egs4gzC+c1qR2bqsBbHy2
	Dy0+S9xWnTr/3KgFCcyBL+qn3PDubJo1CjenZXZFuQGyaWbc1dcBJfYpsoIv294x
	Ux3FIuG/eudYkhVhH3AjkN87my67B4dxuquRLH8awN3L2/8V4okPJhKJ/69CAara
	P8p01AKEoDfw/AcAWsdWlZF/tFWLrqDgWI9W3jJDGn1mcBQcZqO9fizQF18HZTI9
	CDcj3n5u/On52hwFIyo9H4koEcIDfAftixzoAVopS/Mz1xDYOyX8BtQgVIuDQAXt
	AmPKUeuY+FesbwzDDxpE+Q1aUiAHAAQoS3erTl9q5CbZPYhZh22Kt/gJ9xI65Jnt
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OSKyuQzDzEJc; Fri, 25 Sep 2026 18:30:13 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzlQ5CRrz1XM5kt;
	Fri, 25 Sep 2026 18:30:10 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 18/54] scsi: bnx2fc: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:25:56 -0700
Message-ID: <224219367c2af9fc4d193d0568bb8a6e8d22f97d.1790360262.git.bvanassche@acm.org>
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

Document the locking requirements with __must_hold(). Make the argument
names in the definition and the declaration of
bnx2fc_process_seq_cleanup_compl() consistent.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bnx2fc/Makefile     | 3 +++
 drivers/scsi/bnx2fc/bnx2fc.h     | 3 ++-
 drivers/scsi/bnx2fc/bnx2fc_els.c | 2 ++
 drivers/scsi/bnx2fc/bnx2fc_io.c  | 1 +
 4 files changed, 8 insertions(+), 1 deletion(-)

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
index fde41224d31f..2fc80c607437 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -596,7 +596,8 @@ int bnx2fc_send_srr(struct bnx2fc_cmd *orig_io_req, u=
32 offset, u8 r_ctl);
 void bnx2fc_process_seq_cleanup_compl(struct bnx2fc_rport *tgt,
 				      struct bnx2fc_cmd *seq_clnp_req,
 				      struct fcoe_task_ctx_entry *task,
-				      u8 rx_state);
+				      u8 rx_state)
+	__must_hold(&tgt->tgt_lock);
 int bnx2fc_initiate_seq_cleanup(struct bnx2fc_cmd *orig_io_req, u32 offs=
et,
 				enum fc_rctl r_ctl);
=20
diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx2f=
c_els.c
index 5191d87fb446..bca28acaa1a2 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -265,6 +265,7 @@ int bnx2fc_send_rls(struct bnx2fc_rport *tgt, struct =
fc_frame *fp)
=20
 static void bnx2fc_srr_compl(struct bnx2fc_rport *tgt,
 			     struct bnx2fc_els_cb_arg *cb_arg)
+	__must_hold(&tgt->tgt_lock)
 {
 	struct bnx2fc_mp_req *mp_req;
 	struct fc_frame_header *fc_hdr, *fh;
@@ -375,6 +376,7 @@ static void bnx2fc_srr_compl(struct bnx2fc_rport *tgt=
,
=20
 static void bnx2fc_rec_compl(struct bnx2fc_rport *tgt,
 			     struct bnx2fc_els_cb_arg *cb_arg)
+	__must_hold(&tgt->tgt_lock)
 {
 	struct bnx2fc_cmd *orig_io_req, *new_io_req;
 	struct bnx2fc_cmd *rec_req;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc=
_io.c
index 82d70ccfc59b..60346d77cb6d 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1286,6 +1286,7 @@ void bnx2fc_process_seq_cleanup_compl(struct bnx2fc=
_rport *tgt,
 				      struct bnx2fc_cmd *seq_clnp_req,
 				      struct fcoe_task_ctx_entry *task,
 				      u8 rx_state)
+	__must_hold(&tgt->tgt_lock)
 {
 	struct bnx2fc_els_cb_arg *cb_arg =3D seq_clnp_req->cb_arg;
 	struct bnx2fc_cmd *orig_io_req =3D cb_arg->aborted_io_req;
